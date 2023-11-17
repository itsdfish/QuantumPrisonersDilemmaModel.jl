abstract type AbstractQPDM  <: ContinuousUnivariateDistribution end

"""

    QPDM{T<:Real} <: AbstractQPDM

A model object for the Quantum Prisoner's Dilemma Model. The QPDM has four basis states:
    
1. opponent defects and you defect 
2. opponent defects and you cooperate 
3. opponent cooperates and you defect 
4. opponent cooperates and you cooperate

The bases are orthonormal and in standard form. The model assumes three conditions:

1. Player 1 (you) is told that player 2 defected
2. Player 1 (you) is told that player 2 cooperated
3. Player 1 (you) is not informed of player's action


Model inputs and outputs are assumed to be in the order above. 

# Fields 

- `μd`: utility for defecting 
- `μc`: utility for cooperating 
- `γ`: entanglement parameter for beliefs and actions 

# Example 

```julia
using QuantumPrisonersDilemmaModel
model = QPDM(;μd=.51, γ=2.09)
```

# References 

Pothos, E. M., & Busemeyer, J. R. (2009). A quantum probability explanation for violations of ‘rational’decision theory. Proceedings of the Royal Society B: Biological Sciences, 276(1665), 2171-2178.
"""
struct QPDM{T<:Real} <: AbstractQPDM
    μd::T
    μc::T
    γ::T
end

QPDM(;μd, μc=μd, γ) = QPDM(μd, μc, γ)

function QPDM(μd, μc, γ) 
    μd, μc, γ = promote(μd, μc, γ)
    return QPDM(μd, μc, γ)
end