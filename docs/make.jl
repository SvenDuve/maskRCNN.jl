using maskRCNN
using Documenter

DocMeta.setdocmeta!(maskRCNN, :DocTestSetup, :(using maskRCNN); recursive=true)

makedocs(;
    modules=[maskRCNN],
    authors="Sven Duve",
    repo="https://github.com/SvenDuve/maskRCNN.jl/blob/{commit}{path}#{line}",
    sitename="maskRCNN.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://SvenDuve.github.io/maskRCNN.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SvenDuve/maskRCNN.jl",
    devbranch="main",
)
