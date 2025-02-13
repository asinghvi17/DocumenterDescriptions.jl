"""
    abstract type AbstractDescriber

Abstract supertype for all describer plugins.

## Interface
- `(plugin::YourDescriber)(flattened_text::String)::String`: Obtain the description of a page as a string, return it as a String.
- `(::Type{YourDescriber})()`: There should be a no-argument constructor.

Optionally, you can hook into the more descriptive API by defining `(plugin::YourDescriber)(page, doc)::String`.
"""
abstract type AbstractDescriber <: Documenter.Plugin end

# default constructor
(::Type{AbstractDescriber})() = FirstNCharsDescriber()

function (plugin::AbstractDescriber)(page, doc)
    # Obtain the flattened text of the page.
    flattened_text = Documenter.MDFlatten.mdflatten(page.mdast)
    # Call the plugin on the flattened text
    return plugin(flattened_text)
end

function (plugin::AbstractDescriber)(flattened_text::String)
    error("Not implemented yet for plugin $(typeof(plugin))!  Please file an issue on Github.")
end