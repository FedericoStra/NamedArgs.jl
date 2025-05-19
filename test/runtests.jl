using Test, SafeTestsets, TestSetExtensions

@testset ExtendedTestSet "All tests" begin
    @safetestset "Aqua tests" include("Aqua.jl")

    @testset "NamedArgs.jl" begin
        @safetestset "simple" include("simple.jl")
    end
end
