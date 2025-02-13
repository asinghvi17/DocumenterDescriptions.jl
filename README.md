# DocumenterDescriptions

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://asinghvi17.github.io/DocumenterDescriptions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://asinghvi17.github.io/DocumenterDescriptions.jl/dev/)
[![Build Status](https://github.com/asinghvi17/DocumenterDescriptions.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/asinghvi17/DocumenterDescriptions.jl/actions/workflows/CI.yml?query=branch%3Amain)

DocumenterDescriptions.jl automatically adds descriptions generated on every page into your metadata, improving the searchability of your website.

Simply loading it is enough to make it start with the default (`FirstNChars(160 #= chars =#)`) description generator.  

If you want to customize which generator you use (right now there are no others, but there will be :D), you can do so by passing a custom describer to the `plugin` kwarg of `makedocs`.

```julia
using Documenter, DocumenterDescriptions\
# ...
makedocs(
    ...,
    plugins = [FirstNCharsDescriber(nchars = 160), ...]
)
```

## How does it work?

These "describers" are all subtypes of `AbstractDescriber`, and are used to generate the description for a page.  They operate on each page individually by default.

The default one is `FirstNCharsDescriber`, which takes the first `nchars` characters of the page and uses that as the description.  It's also a bit fuzzy, so it won't cut off words.

You can also pass a create a custom describer by defining your own subtype of `AbstractDescriber` and implementing the `(plugin::MyDescriber)(page::String)` method, or go a bit more granular and implement the `(plugin::MyDescriber)(page::Documenter.Page, doc::Documenter.Document)` method.

See the docstring of `AbstractDescriber` for more details.

We plan to add LLM-powered describers as well as description caching (to decrease your API costs)
in the future!

## Contributing

We welcome contributions!  Please open an issue or PR if you have any ideas or feedback.
