@kwdef struct LLMDescriber{M}
    model::String = "gpt4o"
    verbose::Bool = false
    api_kwargs::NamedTuple
    template::Union{Symbol, PromptingTools.AITemplate}
end

function (plugin::LLMDescriber)(flattened_string::String)
    response = aigenerate(...)
end