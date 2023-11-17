using Documenter
using QuantumPrisonersDilemmaModel

makedocs(
    warnonly = true,
    sitename="QuantumPrisonersDilemmaModel",
    format=Documenter.HTML(
        assets=[
            asset(
                "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
                class=:css,
            ),
        ],
        collapselevel=1,
    ),
    modules=[
        QuantumPrisonersDilemmaModel, 
        # Base.get_extension(SequentialSamplingModels, :TuringExt),  
        # Base.get_extension(SequentialSamplingModels, :PlotsExt) 
    ],
    pages=[
        "Home" => "index.md",
        "Example" => "example.md",
    ]
)

deploydocs(
    repo="github.com/itsdfish/QuantumPrisonersDilemmaModel.jl.git",
)