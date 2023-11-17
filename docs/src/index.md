# QuantumPrisonersDilemmaModel.jl

This package contains code for a quantum cognition model of the disjunction effect in the prisoner's dilemma. 

# Installation

This package is not registered in Julia's general registry. However, there two ways you can install the package. Option 1 is to install without version control. In the REPL, use `]` to switch to the package mode and enter the following:

```julia
add https://github.com/itsdfish/QuantumPrisonersDilemmaModel.jl
```
Option 2 is to install via a custom registry. The advantage of this approach is that you have more control over version control, expecially if you are using a project-specfic environment. 

1. Install the registry using the directions found [here](https://github.com/itsdfish/Registry.jl).
2. Add the package by typing `]` into the REPL and then typing (or pasting):

```julia
add QuantumPrisonersDilemmaModel
```

## Interference Effect

The interference effect occurs when decisions in the prisoner's dilemma violate the law of total probability. Consider an experiment of the prisoner's dilemma with three conditions:

1. Player 1 is told that player 2 defected: $R_2=d$
2. Player 1 is told that player 2 cooperated: $R_2=c$
3. Player 1 is not informed of player's action

The law of total probability requires:

$\Pr(R_1=d) = \Pr(R_1=d \mid R_2=d) \Pr(R_2=d) + \Pr(R_1=d \mid R_2=c) \Pr(R_2=c),$

where the left hand side corresponds to condition 3 and the terms on the right hand side correspond to conditions 1 and 2, respectively. When this inequality does not hold, an interference effect occurs. 

An important property of the law of total probability is that it requires condition 3 to be a weighted average of conditions 1 and 2. This implies the following ordering of terms:

$\min(\Pr(R_1=d \mid R_2=d), \Pr(R_1=d \mid R_2=c)) \leq \Pr(R_1=d) \leq \max(\Pr(R_1=d \mid R_2=d), \Pr(R_1=d \mid R_2=c)),$

which is violated in human decision making, leading to an interference effect. The results below show a typical response pattern:

|  Condition   | Formula    | Data | Model |
| :-- | :-- | :-- | :-- |
|  1   |  $\Pr(R_1=d \mid R_2=d)$   | .84| .81|
|  2  |   $\Pr(R_1=d \mid R_2=c)$   | .66| .65|
|  3   |  $\Pr(R_1=d)$  | .55 | .57|

An interference effect is present in the data because the response probability in condition 3 is below the response probabilities in conditions 1 and 2. The predictions of the quantum model are shown in the last column.

## QPDM Predictions

As a simple example, the code block illustrates how to generate the predictions in the table above. The first parameter $\mu_d$ is the utility for defecting. When no value is passed for the utility of cooperating, $\mu_d = \mu_c$. The parameter $\gamma$ is the entanglement parameter which aligns beliefs about the opponents action and one's own action. 

```@example 
using QuantumPrisonersDilemmaModel
model = QPDM(;μd=.51, γ=2.09)
preds = predict(model)
```




# References 

Pothos, E. M., & Busemeyer, J. R. (2009). A quantum probability explanation for violations of ‘rational’decision theory. Proceedings of the Royal Society B: Biological Sciences, 276(1665), 2171-2178.
