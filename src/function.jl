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

function make_H2(γ)
	v = -γ / √(2)
	H = [v 0 v 0;
		 0 -v 0 v;
		 v 0 -v 0;
		 0 v 0 v]
	return H
end

"""
    predict(dist::AbstractQPDM; t = π / 2)

Returns predicted response probability for the following conditions:

1. Opponent defected
2. Opponent cooperated
3. Opponent's action uknown 

# Arguments

- `dist::AbstractQPDM`

# Keywords

- `t = π / 2`: time of decision
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

rand(dist::AbstractQPDM; t = π / 2) = rand(dist, 1; t = π / 2)

"""
    rand(dist::AbstractQPDM, n::Int; t = π / 2)

Generates simulated data for the following conditions:

1. Opponent defected
2. Opponent cooperated
3. Opponent's action uknown 

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 

# Keywords

- `t = π / 2`: time of decision
"""
function rand(dist::AbstractQPDM, n::Int; t = π / 2)
    Θ = predict(dist; t)
    return @. rand(Binomial(n, Θ))
end

"""
    pdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)

Returns the joint probability density given data for the following conditions:

1. Opponent defected
2. Opponent cooperated
3. Opponent's action uknown 

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 
- `n_d`: the number of defections in each condition 

# Keywords

- `t = π / 2`: time of decision
"""
function pdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)
    Θ = predict(dist; t)
    return @. pdf(Binomial(n, Θ)) |> prod 
end

"""
    logpdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)

Returns the joint log density given data for the following conditions:

1. Opponent defected
2. Opponent cooperated
3. Opponent's action uknown 

# Arguments

- `dist::AbstractQPDM`
- `n`: the number of trials per condition 
- `n_d`: the number of defections in each condition 

# Keywords

- `t = π / 2`: time of decision
"""
function logpdf(dist::AbstractQPDM, n::Int, n_d::Vector{Int}; t = π / 2)
    Θ = predict(dist; t)
    return @. logpdf(Binomial(n, Θ)) |> sum 
end