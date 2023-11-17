# QuantumPrisonersDilemmaModel.jl

This package contains code for a quantum cognition model of the disjunction effect in the prisoner's dilemma. 

## Disjunction Effect

The disjunction effect occurs when decisions in the prisoner's dilemma violate the law of total probability. Consider an experiment of the prisoner's dilemma with three conditions:

1. Player 1 is told that player 2 defected: $R_2=d$
2. Player 1 is told that player 2 cooperated: $R_2=c$
3. Player 1 is not informed of player's action

The law of total probability requires:

$\Pr(R_1=d) = \Pr(R_1=d \mid R_2=d) \Pr(R_2=d) + \Pr(R_1=d \mid R_2=c) \Pr(R_2=c)$

Where the left hand side corresponds to condition 3 and the terms on the right hand side correspond to conditions 1 and 2, respectively. In the experiment, $\Pr(R_2=d)$ and $\Pr(R_2=c)$ are unknown. However, the law of total probability requires the following ordering of terms:

$\min(\Pr(R_1=d \mid R_2=d), \Pr(R_1=d \mid R_2=c)) \leq \Pr(R_1=d) \leq \max(\Pr(R_1=d \mid R_2=d), \Pr(R_1=d \mid R_2=c)),$

which is violated in human decision making. The results below show a typical response pattern:

|  Condition   | Formula    | Data | Model |
| :-- | :-- | :-- | :-- |
|  1   |  $\Pr(R_1=d \mid R_2=d)$   | .84| .81|
|  2  |   $\Pr(R_1=d \mid R_2=c)$   | .66| .65|
|  3   |  $\Pr(R_1=d)$  | .55 | .57|

The predictions of the quantum model are shown in the last column.

## QPDM Predictions

As a simple example, the code block illustrates how to generate the predictions in the table above. The first parameter $\mu_d$ is the utility for defecting. When no value is passed for the utility of cooperating, $\mu_d = \mu_c$. The parameter $\gamma$ is the entanglement parameter which aligns beliefs about the opponents action and one's own action. 

```@example 
using QuantumPrisonersDilemmaModel
model = QPDM(;μd=.51, γ=2.09)
preds = predict(model)
```




# References 

Pothos, E. M., & Busemeyer, J. R. (2009). A quantum probability explanation for violations of ‘rational’decision theory. Proceedings of the Royal Society B: Biological Sciences, 276(1665), 2171-2178.
