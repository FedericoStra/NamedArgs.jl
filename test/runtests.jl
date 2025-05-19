using Test, SafeTestsets, TestSetExtensions

@testset ExtendedTestSet "All tests" begin
    @testset "NamedArgs.jl" begin
        @safetestset "simple" include("simple.jl")
    end
end
