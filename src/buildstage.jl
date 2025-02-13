abstract type DescriptionAdder <: Documenter.Builder.DocumentPipeline end

Documenter.Selectors.order(::Type{DescriptionAdder}) = 5.9 # just before RenderDocument, which is 6.0

function Documenter.Selectors.runner(::Type{DescriptionAdder}, doc::Documenter.Document)
    # First, retrieve the plugin from the document.
    plugin = Documenter.getplugin(doc, AbstractDescriber)

    # For each page, insert a description if none exists
    for (filename, page) in doc.blueprint.pages
        # If there is a description then we shouldn't do anything,
        # otherwise we should insert a description.
        get!(page.globals.meta, :Description) do 
            plugin(page, doc)
        end
    end
end