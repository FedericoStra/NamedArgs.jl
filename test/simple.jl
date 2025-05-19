using NamedArgs

foo(n::Integer, r::Real; offset=100) = n + r + offset
foo(n::Number, c::Char) = "$(c)_$(n)"

@testset "Integer, Real" begin
    @test 145.14 == @na foo(  42,   3.14;)
    @test 145.14 == @na foo(n=42,   3.14;)
    @test 145.14 == @na foo(  42, r=3.14;)
    @test 145.14 == @na foo(n=42, r=3.14;)
    @test 245.14 == @na foo(  42,   3.14; offset=200)
    @test 245.14 == @na foo(n=42,   3.14; offset=200)
    @test 245.14 == @na foo(  42, r=3.14; offset=200)
    @test 245.14 == @na foo(n=42, r=3.14; offset=200)
end

@testset "Int<:Number, Char" begin
    @test "x_314" == @na foo(  314,   'x';)
    @test "x_314" == @na foo(n=314,   'x';)
    @test "x_314" == @na foo(  314, c='x';)
    @test "x_314" == @na foo(n=314, c='x';)
end

@testset "Float64<:Number, Char" begin
    @test "x_3.14" == @na foo(  3.14,   'x';)
    @test "x_3.14" == @na foo(n=3.14,   'x';)
    @test "x_3.14" == @na foo(  3.14, c='x';)
    @test "x_3.14" == @na foo(n=3.14, c='x';)
end

@testset "expressions" begin
    @test 145.14 == @na foo(  6*7,   3+0.14;)
    @test 145.14 == @na foo(n=6*7,   3+0.14;)
    @test 145.14 == @na foo(  6*7, r=3+0.14;)
    @test 145.14 == @na foo(n=6*7, r=3+0.14;)
    @test 245.14 == @na foo(  6*7,   3+0.14; offset=100*2)
    @test 245.14 == @na foo(n=6*7,   3+0.14; offset=100*2)
    @test 245.14 == @na foo(  6*7, r=3+0.14; offset=100*2)
    @test 245.14 == @na foo(n=6*7, r=3+0.14; offset=100*2)
end

@testset "wrong argument name" begin
    @test_throws "ArgumentError: expected argument name `c`, got `r`." begin
        for v in (3.14, 'x')
            @na foo(n=42, r=v;)
        end
    end

    @test_throws "ArgumentError: expected argument name `r`, got `c`." begin
        for v in ('x', 3.14)
            @na foo(n=42, c=v;)
        end
    end
end
