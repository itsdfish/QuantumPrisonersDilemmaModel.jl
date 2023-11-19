# QuantumPrisonersDilemmaModel.jl

This package contains code for a quantum cognition model of inteference effects in the prisoner's dilemma. 

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

# References 

Pothos, E. M., & Busemeyer, J. R. (2009). A quantum probability explanation for violations of ‘rational’decision theory. Proceedings of the Royal Society B: Biological Sciences, 276(1665), 2171-2178.
