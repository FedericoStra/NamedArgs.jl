using NamedArgs
using Documenter

DocMeta.setdocmeta!(NamedArgs, :DocTestSetup, :(using NamedArgs); recursive=true)

makedocs(;
    modules=[NamedArgs],
    authors="Federico Stra <stra.federico@gmail.com> and contributors",
    sitename="NamedArgs.jl",
    format=Documenter.HTML(;
        canonical="https://FedericoStra.github.io/NamedArgs.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/FedericoStra/NamedArgs.jl",
    devbranch="master",
)
