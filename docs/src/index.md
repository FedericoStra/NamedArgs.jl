# NamedArgs

Documentation for [NamedArgs](https://github.com/FedericoStra/NamedArgs.jl).

This package allows naming arguments in function calls.

```@meta
CurrentModule = NamedArgs
```

## Usage

Adding the [`@na`](@ref) macro in front of a function call allows to use the syntax `arg=value`
also for non-keyword arguments:

```julia
@na my_function(name="Federico", age=35; kw=nothing)
```

### Examples

```@repl example
using NamedArgs

foo(n::Integer, r::Real; offset=100) = n + r + offset
foo(n::Number, c::Char) = "$(c)_$(n)"

@na foo(n=42, r=3.14;)
@na foo(n=42,   3.14;)
@na foo(  42, r=3.14;)
@na foo(n=42, r=3.14; offset=200)
```

### Possible errors

```@repl example
@na (1, 2)
@na foo(n=42, r=3.14)
@na foo(n=42, "r"=3.14;)
@na foo(n=42, r='x';)
```

## API

```@index
```

```@autodocs
Modules = [NamedArgs]
```
