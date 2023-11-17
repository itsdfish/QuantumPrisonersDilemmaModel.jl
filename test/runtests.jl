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