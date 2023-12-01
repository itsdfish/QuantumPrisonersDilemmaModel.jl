# Overview

This page provides an overview of the API along with examples. 

# Make Predictions

The quantum prisoner's dilemma model (QPDM) generates predictions for three conditions:

1. Player 1 is told that player 2 defected
2. Player 1 is told that player 2 cooperated
3. Player 1 is not informed of the action of player 2

```@example 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
predict(model)
```

# Simulate Model

The code block below demonstrates how to generate simulated data from the model using `rand`. In the example, we will generate 100 simulated trials for each condition. 
```@example 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
data = rand(model, 100)
```

# Evaluate Log Likelihood

The log likelihood of data can be evaluated using `logpdf`. In the code block below, we generate simulated data and evaluate the logpdf: 
```@example 
using QuantumPrisonersDilemmaModel 
model = QPDM(;μd=.51, γ=2.09)
n_trials = 100
data = rand(model, n_trials)
logpdf(model, n_trials, data)
```