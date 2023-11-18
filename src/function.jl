"""
    predict(dist::AbstractQPDM; t = π / 2)

Returns predicted response probability for the following conditions:

1. Player 1 is told that player 2 defected
2. Player 1 is told that player 2 cooperated
3. Player 1 is not informed of player's action
    
# Arguments

- `dist::AbstractQPDM`

# Keywords

- `t = π / 2`: time of decision

# Example 

```julia 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
predict(model)
```
"""
function predict(dist::AbstractQPDM; t = π / 2)
    (;μd,μc,γ) = dist
    # rotates belief in favor of cooperation of defection 
    H1 = make_H1(μd, μc)
    # hamiltonian matrix for reducing cognitive dissonance
    # aligns action with belief about opponent's action 
	H2 = make_H2(γ)
    # combine both hamiltonian matrices so that time evolution reflects their joint contribution
	H = H1 .+ H2
    # unitary transformation matrix
    U = exp(-im * t * H)

    # cognitive state after learning the opponent defected
    ψd = [√(.5), √(.5), 0, 0]
    # cognitive state after learning the opponent cooperated
	ψc = [0, 0, √(.5), √(.5)]
    # cognitive state when nothing is known about the action of the opponent
    ψ0 = fill(.5, 4)

    # projection matrix for defecting 
    M = Diagonal([1.0,0.0,1.0,0.0])

    # compute probability of defecting given that opponent defected
    ψd′ = U * ψd
	proj_d = M * ψd′
	p_d = real(proj_d' * proj_d)

    # compute probability of defecting given that opponent cooperated
    ψc′ = U * ψc
	proj_c = M * ψc′
	p_c = real(proj_c' * proj_c)

    # compute probability of defecting given no knowledge of opponent's action
    ψ0′ = U * ψ0
	proj = M * ψ0′
	p = real(proj' * proj)
    return [p_d,p_c,p]
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
	H = fill(0.0, 4, 4)
	sub_h!(H, μd, 1:2)
	sub_h!(H, μc, 3:4)
	return H
end

function sub_h!(H, μ, i)
	v = 1 / √(1 + μ^2)
	H[i,i] .= v
	H[i[1],i[1]] *= μ
	H[i[2],i[2]] *= -μ
	return H
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
	H = [v 0 v 0;
		 0 -v 0 v;
		 v 0 -v 0;
		 0 v 0 v]
	return H
end

rand(dist::AbstractQPDM; t = π / 2) = rand(dist, 1; t = π / 2)

"""
    rand(dist::AbstractQPDM, n::Int; t = π / 2)

Generates simulated data for the following conditions:

1. Player 1 is told that player 2 defected
2. Player 1 is told that player 2 cooperated
3. Player 1 is not informed of player's action

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 

# Keywords

- `t = π / 2`: time of decision

# Example 

```julia 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
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

1. Player 1 is told that player 2 defected
2. Player 1 is told that player 2 cooperated
3. Player 1 is not informed of player's action
    

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

1. Player 1 is told that player 2 defected
2. Player 1 is told that player 2 cooperated
3. Player 1 is not informed of player's action

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