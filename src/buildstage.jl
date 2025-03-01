abstract type DescriptionAdder <: Documenter.Builder.DocumentPipeline end

Documenter.Selectors.order(::Type{DescriptionAdder}) = 5.9 # just before RenderDocument, which is 6.0

function Documenter.Selectors.runner(::Type{DescriptionAdder}, doc::Documenter.Document)
    # First, retrieve the plugin from the document.
    plugin = Documenter.getplugin(doc, AbstractDescriber)

    # For each page, insert a description if none exists
    for (filename, page) in doc.blueprint.pages
        # If there is a description then we shouldn't do anything,
        # otherwise we should insert a description.
        if haskey(page.globals.meta, :Description)
            @debug "DocumenterDescriptions: Page at $filename already has a description, skipping"
        else 
            @debug "DocumenterDescriptions: Page at $filename has no description, generating one"
            # Call the plugin on the page
            new_description = plugin(page, doc)
            # If the plugin returns `nothing`, it failed to add a description
            # Note that this is different from the plugin erroring, or returning an empty string
            # We catch this state and warn here.
            if isnothing(new_description)
                @warn "DocumenterDescriptions: Failed to generate description for page at $filename"
            else
                page.globals.meta[:Description] = new_description
            end
        end
    end
end