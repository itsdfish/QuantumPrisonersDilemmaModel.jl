"""
    predict(dist::AbstractQPDM; t = π / 2)

Returns predicted defection probability for the following conditions:

1. Player 2 is told that player 1 defected
2. Player 2 is told that player 1 cooperated
3. Player 2 is not informed of player 1's action
    
# Arguments

- `dist::AbstractQPDM`

# Keywords

- `t = π / 2`: time of decision

# Example 

```julia 
using QuantumPrisonersDilemmaModel 
model = QPDM(; μd=.51, γ=2.09)
predict(model)
```
"""
function predict(dist::AbstractQPDM; t = π / 2)
    (; μd, μc, γ) = dist
    # rotates belief in favor of cooperation of defection 
    𝐇1 = make_H1(μd, μc)
    # hamiltonian matrix for reducing cognitive dissonance
    # aligns action with belief about opponent's action 
    𝐇2 = make_H2(γ)
    # combine both hamiltonian matrices so that time evolution reflects their joint contribution
    𝐇 = 𝐇1 .+ 𝐇2
    # unitary transformation matrix
    𝐔 = exp(-im * t * 𝐇)

    # cognitive state after learning the opponent defected
    ψd = [√(0.5), √(0.5), 0, 0]
    # cognitive state after learning the opponent cooperated
    ψc = [0, 0, √(0.5), √(0.5)]
    # cognitive state when nothing is known about the action of the opponent
    ψ0 = fill(0.5, 4)

    # projection matrix for defecting 
    𝐏 = Diagonal([1.0, 0.0, 1.0, 0.0])

    # compute probability of defecting given that opponent defected
    proj_d = 𝐏 * 𝐔 * ψd
    p_d = real(proj_d' * proj_d)

    # compute probability of defecting given that opponent cooperated
    proj_c = 𝐏 * 𝐔 * ψc
    p_c = real(proj_c' * proj_c)

    # compute probability of defecting given no knowledge of opponent's action
    proj = 𝐏 * 𝐔 * ψ0
    p = real(proj' * proj)
    return [p_d, p_c, p]
end

"""
    make_H1(μd, μc)

Creates a Hamiltonian matrix which rotates in favor of defecting or cooperating depending on 
μd and μd. 

# Arguments 

- `μd`: utility for defecting 
- `μc`: utility for cooperating
"""
function make_H1(μd, μc)
    𝐇 = fill(0.0, 4, 4)
    sub_h!(𝐇, μd, 1:2)
    sub_h!(𝐇, μc, 3:4)
    return 𝐇
end

function sub_h!(𝐇, μ, i)
    v = 1 / √(1 + μ^2)
    𝐇[i, i] .= v
    𝐇[i[1], i[1]] *= μ
    𝐇[i[2], i[2]] *= -μ
    return 𝐇
end

"""
    make_H2(γ)

Creates a Hamiltonian matrix which represents cognitive dissonance or wishful thinking. The matrix can be decomposed
into two components. The components rotate beliefs about the other player to be more consistent with planned actions.  
For example, if the other player defected, the matrix will rotate actions towards defection. 

# Arguments 

- `γ`: entanglement parameter which aligns beliefs and actions
"""
function make_H2(γ)
    v = -γ / √(2)
    𝐇 = [v 0 v 0;
        0 -v 0 v;
        v 0 -v 0;
        0 v 0 v]
    return 𝐇
end

rand(dist::AbstractQPDM; t = π / 2) = rand(dist, 1; t = π / 2)

"""
    rand(dist::AbstractQPDM, n::Int; t = π / 2)

Generates simulated data for the number of decisions to defect out of `n` decisions in the following conditions:

1. Player 2 is told that player 1 defected
2. Player 2 is told that player 1 cooperated
3. Player 2 is not informed of player 1's action

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 

# Keywords

- `t = π / 2`: time of decision

# Returns

- `defections`: a vector of defection counts. Elements correspond to conditions listed above.

# Example 

```julia 
using QuantumPrisonersDilemmaModel 
model = QPDM(; μd=.51, γ=2.09)
data = rand(model, 100)
```
"""
function rand(dist::AbstractQPDM, n::Int; t = π / 2)
    Θ = predict(dist; t)
    return @. rand(Binomial(n, Θ))
end

"""
    pdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)

Returns the joint probability density given data for the following conditions:

1. Player 2 is told that player 1 defected
2. Player 2 is told that player 1 cooperated
3. Player 2 is not informed of player 1's action
    

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 
- `n_d`: the number of defections in each condition 

# Keywords

- `t = π / 2`: time of decision
"""
function pdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)
    Θ = predict(dist; t)
    return prod(@. pdf(Binomial(n, Θ), n_d))
end

"""
    logpdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)

Returns the joint log density given data for the following conditions:

1. Player 2 is told that player 1 defected
2. Player 2 is told that player 1 cooperated
3. Player 2 is not informed of player 1's action

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 
- `n_d`: the number of defections in each condition 

# Keywords

- `t = π / 2`: time of decision

# Example 

```julia 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
n_trials = 100
data = rand(model, n_trials)
logpdf(model, n_trials, data)
```
"""
function logpdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)
    Θ = predict(dist; t)
    return sum(@. logpdf(Binomial(n, Θ), n_d))
end

loglikelihood(d::AbstractQPDM, data::Tuple) = logpdf(d, data...)

logpdf(dist::AbstractQPDM, x::Tuple) = logpdf(dist, x...)
