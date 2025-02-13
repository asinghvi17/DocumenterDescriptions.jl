module DocumenterDescriptions

using Documenter

include("interface.jl")
include("methods/firstnchars.jl")

include("buildstage.jl")

export FirstNCharsDescriber

end
