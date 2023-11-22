using SafeTestsets

@safetestset "predict" begin
    using QuantumPrisonersDilemmaModel
    using Test

    model = QPDM(;μd=.51, γ=2.09)
    preds = predict(model)
    @test preds ≈ [.81,.65,.57] atol = .01
end

@safetestset "rand" begin
    @safetestset "rand 1" begin
        using QuantumPrisonersDilemmaModel
        using Test
        using Random 

        Random.seed!(7878)
    
        n = 100_000
        model = QPDM(;μd=.51, γ=2.09)
        data = rand(model, n)
        preds = predict(model)
        probs = data ./ n 
        @test probs ≈ preds atol = 1e-2
    end

    @safetestset "rand 2" begin
        using QuantumPrisonersDilemmaModel
        using Test
        using Random 

        Random.seed!(4741)
    
        n = 100_000
        model = QPDM(;μd=1.5, γ=-1.09)
        data = rand(model, n)
        preds = predict(model)
        probs = data ./ n 
        @test probs ≈ preds atol = 1e-2
    end
end

@safetestset "H1" begin
    using QuantumPrisonersDilemmaModel
    using QuantumPrisonersDilemmaModel: make_H1
    using Test

    H1 = make_H1(1.5, 2)
    @test H1[1,1] == -H1[2,2]
    @test H1[3,3] == -H1[4,4]
    @test H1[1,2] == H1[2,1]
    @test H1[4,3] == H1[3,4]
    @test H1 == H1'
end

@safetestset "H2" begin
    using QuantumPrisonersDilemmaModel
    using QuantumPrisonersDilemmaModel: make_H2
    using Test

    H2 = make_H2(√(2) * 2)
    @test H2[1,1] == -2
    @test H2[2,2] == 2
    @test H2[2,4] == -2
    @test H2[3,1] == -2
    @test H2[3,3] == 2
    @test H2[4,2] == -2
    @test H2[4,4] == -2
    @test H2 == H2'
end

@safetestset "logpdf" begin
    using QuantumPrisonersDilemmaModel
    using Test
    using Random 

    Random.seed!(410)

    n = 20_000
    μd = 1.0
    γ = 2.0

    μds = range(.8 * μd, 1.2 * μd, length=100)
    γs = range(.8 * γ, 1.2 * γ, length=100)

    model = QPDM(;μd, γ)
    data = rand(model, n)

    LLs = map(μd -> logpdf(QPDM(;μd=μd, γ), n, data), μds)
    _,mxi = findmax(LLs)
    @test μds[mxi] ≈ μd rtol = 1e-2

    LLs = map(γ -> logpdf(QPDM(;μd, γ=γ), n, data), γs)
    _,mxi = findmax(LLs)
    @test γs[mxi] ≈ γ rtol = 1e-2
end

@safetestset "pdf" begin
    using QuantumPrisonersDilemmaModel
    using Distributions
    using Test
    using Random 

    Random.seed!(11214)

    n = 5

    model = QPDM(;μd=.5, γ=2)
    data = rand(model, n)

    for _ ∈ 1:10
        μd = rand(Uniform(-1, 1))
        γ = rand(Uniform(-2, 2))
        LL1 = logpdf(QPDM(;μd, γ), n, data)
        LL2 = log(pdf(QPDM(;μd, γ), n, data))
        @test LL1 ≈ LL2
    end
end