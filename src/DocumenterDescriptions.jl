module DocumenterDescriptions

using Documenter
import PromptingTools # for LLM based description generation


include("interface.jl")
include("methods/firstnchars.jl")
include("methods/writetofile.jl")

include("buildstage.jl")

export FirstNCharsDescriber, LLMDescriber, WriteToFile

end
