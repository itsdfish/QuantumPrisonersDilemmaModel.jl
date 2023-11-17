module QuantumPrisonersDilemmaModel

    using Distributions: Binomial
    using Distributions: ContinuousUnivariateDistribution
    using LinearAlgebra

    import Distributions: logpdf
    import Distributions: pdf
    import Distributions: rand 
    import Distributions: loglikelihood

    export predict
    export logpdf 
    export pdf
    export QPDM
    export rand 

    include("structs.jl")
    include("function.jl")
end
