module DocumenterDescriptions

using Documenter

include("interface.jl")
include("methods/firstnchars.jl")
include("methods/writetofile.jl")

include("buildstage.jl")

export FirstNCharsDescriber, WriteToFile

end
