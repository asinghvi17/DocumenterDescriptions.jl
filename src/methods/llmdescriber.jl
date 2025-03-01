"""
    LLMDescriber(; model = "gpt4o", verbose, api_kwargs, template, return_type)

A describer that uses an LLM to parse a version of the flattened Markdown of the page (prior to docs block expansion)
into an ~160 character description of the page.

This description can be cached when you're running locally by wrapping `LLMDescriber` in `WriteToFile`.

## Keyword arguments
- `model = "gpt4o"`: The model to use for the LLM call.
- `verbose = false`: Whether to print the prompt and response.
- `api_kwargs = NamedTuple()`: Additional keyword arguments to pass to the LLM call.
- `template = SEOWriterTemplate`: The template to use for the LLM call.  Defaults to our [`SEOWriterTemplate`](@ref).
- `return_type = SEOMetadata`: The type to use for the structured output.  Defaults to [`SEOMetadata`](@ref).
"""
@kwdef struct LLMDescriber <: AbstractDescriber
    model::String = "gpt4o"
    verbose::Bool = false
    api_kwargs::NamedTuple = NamedTuple()
    ## Note: prompt and template are often coupled! They dont have to, but often are
    template::Union{Symbol, PromptingTools.AITemplate} = SEOWriterTemplate
    return_type::DataType = SEOMetadata
end
# Define return type for structured extraction (docs are passed into LLM, upto you what you include here vs prompt)
"""
    SEOMetadata

Structured output for SEO metadata extraction.

Fields:
- `reasoning::String`: Explanation of how the meta description was crafted
- `meta_description::String`: SEO-optimized meta description (≈160 characters)
"""
@kwdef struct SEOMetadata
    reasoning::String
    meta_description::String
end

"""
    SEOWriterTemplate

A PromptingTools.jl template for creating an SEO meta description for a given documentation page of a Julia package.

Focus on including relevant keywords while maintaining readability and encouraging clicks.
"""
const SEOWriterTemplate = PromptingTools.create_template(;
    system = """
    Your task is to create an SEO meta description for a given documentation page of a Julia package.
    Focus on including relevant keywords while maintaining readability and encouraging clicks.
    """,
    user = """
    Create an SEO meta description (around 160 characters) for the following documentation page.

    Requirements:
    1. Include key technical terms and concepts from the content
    2. Make it action-oriented and compelling for developers
    3. Ensure it accurately represents the page content
    4. Optimize for search engine visibility

    Please provide:
    - reasoning: Explain your keyword selection and optimization strategy
    - meta_description: The optimized meta description (≈160 chars)

    Documentation page to analyze:
    {{page}}
    """,
    load_as = :SEOWriterTemplate
)

function (plugin::LLMDescriber)(flattened_string::String)
    response = PromptingTools.aiextract(
        plugin.template; page = flattened_string, plugin.return_type,
        plugin.model, plugin.api_kwargs, plugin.verbose)
    ## If it fails, you can retry etc. 
    ## Failure would be that return type is a Dict, because we couldn't parse it into the return type struct
    ## You can add other conditions, like length below 160chars etc.
    successful_extraction = PromptingTools.last_output(response) isa plugin.return_type
    if !successful_extraction
        @warn "Failed to extract metadata from page" response=response
        return nothing # do not write a description!
    end
    ## last_output is the same as response.content
    return PromptingTools.last_output(response).meta_description
end