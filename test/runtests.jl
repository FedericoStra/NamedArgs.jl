using Test, SafeTestsets, TestSetExtensions

const SKIP_BENCHMARKS = true

@testset ExtendedTestSet "All tests" begin
    @safetestset "Aqua tests" include("Aqua.jl")

    @testset "NamedArgs.jl" begin
        @safetestset "simple" include("simple.jl")
    end

    @testset "benches" begin
        @safetestset "dispatch_time" include("../benches/dispatch_time.jl")
    end
end
