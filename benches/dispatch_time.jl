using NamedArgs
using BenchmarkTools, Test

foo(n::Integer, r::Real; offset=100) = n + r + offset
foo(n::Number, c::Char) = "$(c)_$(n)"

direct() = foo(42, 3.14)
indirect() = @na foo(42, 3.14;)

@test direct() == 145.14
@test indirect() == 145.14

if !(hasproperty(Main, :SKIP_BENCHMARKS) && Main.SKIP_BENCHMARKS)
    display(@benchmark direct())
    display(@benchmark indirect())
end
