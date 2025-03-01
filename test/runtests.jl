using DocumenterDescriptions
using Test

@testset "DocumenterDescriptions.jl" begin
    @testset "FirstNChars" begin
        include("firstnchars.jl")
    end
end
