using DocumenterDescriptions
using Documenter

DocMeta.setdocmeta!(DocumenterDescriptions, :DocTestSetup, :(using DocumenterDescriptions); recursive=true)

makedocs(;
    modules=[DocumenterDescriptions],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com> and contributors",
    sitename="DocumenterDescriptions.jl",
    format=Documenter.HTML(;
        canonical="https://asinghvi17.github.io/DocumenterDescriptions.jl",
        edit_link="main",
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
        "preexisting_description.md"
    ],
    checkdocs = :exports,
)

deploydocs(;
    repo="github.com/asinghvi17/DocumenterDescriptions.jl",
    devbranch="main",
)
