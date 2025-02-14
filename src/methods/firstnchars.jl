"""
    FirstNCharsDescriber(; nchars = 160, approx = true) <: AbstractDescriber

A describer that takes the first `nchars` characters of text.

# Arguments
- `nchars::Int = 160`: The target number of characters to include in the description
- `approx::Bool = true`: If true, will try to break at word boundaries rather than exactly at `nchars` characters

# Details
When `approx=true`, the describer will attempt to break at word boundaries to avoid cutting words in half. It will return
slightly fewer characters than requested to ensure this. If `approx=false`, it will break exactly at `nchars` characters.

If the input text is shorter than `nchars`, the entire text is returned.

The text is preprocessed to collapse multiple whitespace characters into single spaces and trim leading/trailing whitespace.

"""
Base.@kwdef struct FirstNCharsDescriber <: AbstractDescriber
    nchars::Int = 160
    approx::Bool = true
end

function (plugin::FirstNCharsDescriber)(flattened_text::String)

    # Create an initial description of the page.
    initial_description = flattened_text[1:(min(end, plugin.nchars * 4))] # 4x to account for potential markdown formatting
    initial_description = replace(replace(initial_description, r"\s+" => " "), r"^\s+|\s+$" => "")

    if plugin.approx
        # If the description is shorter than the requested number of characters, return it as is.
        if length(initial_description) <= plugin.nchars
            return initial_description
        else
            words = split(initial_description, " ") # this has already been preprocessed such that there is only one space between each word
            cum_n_chars = cumsum(length.(words)) #= the length of each word =# .+ (1:length(words)) #= one space between each word =#
            cutoff_idx = searchsortedfirst(plugin.nchars, cum_n_chars)
            return initial_description[1:(cum_n_chars[cutoff_idx])]
        end
    else
        return initial_description[1:(min(end, plugin.nchars))]
    end
end
