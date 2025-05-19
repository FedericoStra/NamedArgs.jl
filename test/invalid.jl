using NamedArgs

@test_throws "the expression is not a function call" begin
    include("invalid/no_function_call.jl")
end

@test_throws "the function call does not have a semicolon" begin
    include("invalid/no_semicolon.jl")
end

@test_throws "ArgumentError: the argument name should be a symbol, got \"r\"" begin
    include("invalid/no_symbol.jl")
end
