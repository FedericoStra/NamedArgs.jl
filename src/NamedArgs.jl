module NamedArgs

export @na

"""
    @na f(arg=val, ...; kwargs)

Allow naming arguments in a function call.

See the [module](@ref NamedArgs) documentation.

# Examples

```jldoctest example
julia> add(x, y; offset=100) = x + y + offset
add (generic function with 1 method)

julia> @na add(x=40, y=2;)
142

julia> @na add(40, y=2; offset=300) # can omit some names
342

julia> @na add(x=4*10, y=2; offset=300) # can use expressions as arguments
342
```

The following invocations are invalid.

```jldoctest example
julia> @na add(40, 2) # cannot omit semicolon
ERROR: LoadError: ArgumentError: the function call does not have a semicolon.
[...]

julia> @na add(y=2, x=40;) # cannot swap arguments
ERROR: ArgumentError: expected argument name `x`, got `y`.
[...]

julia> @na add(x=40; y=2, offset=200) # must correctly separate args and kwargs
ERROR: Calling invoke(f, t, args...) would throw:
MethodError: no method matching invoke add(::Int64)
[...]
```
"""
macro na(ex::Expr)
    # Sanity checks about the macro call.
    if ex.head != :call
        error("the expression is not a function call")
    elseif !(length(ex.args) >= 2 && isa(ex.args[2], Expr) && ex.args[2].head == :parameters)
        throw(ArgumentError(
            """the function call does not have a semicolon.
            Hints:
            - The function call should be of the form `f(args...; kwargs...)`.
            - Use a semicolon even if there are no keyword arguments, e.g. `@na sin(3.14;)`.
            - You called the macro with the expression `$(ex)`."""))
    end

    # This is the (possibly empty) list of keyword arguments.
    # At the AST level, it is an `Expr` with head `:parameters`.
    # Remove it temporarily; we will put it back in second position later.
    parameters = popat!(ex.args, 2)

    # Collect the argument names used in the function call.
    names = Union{Nothing,Symbol}[]
    for i in 2:length(ex.args) # Skip `i=1`, where there is the function to be called.
        arg = ex.args[i]
        if arg isa Expr && arg.head == :kw
            if isa(arg.args[1], Symbol)
                # If an argument is of the form `arg=value`, replace it simply with `value`.
                ex.args[i] = arg.args[2]
                push!(names, arg.args[1])
            else
                throw(ArgumentError("the argument name should be a symbol, got $(repr(arg.args[1]))."))
            end
        else
            push!(names, nothing)
        end
    end

    world_counters = gensym("world_counters")
    __module__.eval(:(const $(world_counters) = Dict{Any,UInt}()))

    # Transform `f(args...)` to `dispatch(f, world_counters, Val(tuple(names...)), args...)`.
    insert!(ex.args, 1, :(NamedArgs.dispatch))
    insert!(ex.args, 3, world_counters)
    insert!(ex.args, 4, Val(tuple(names...)))

    # Put back the keyword arguments in second position.
    insert!(ex.args, 2, parameters)

    # Return the expression properly escaped.
    return esc(ex)
end

function dispatch(f::Function, world_counters::Dict{Any,UInt}, Val_names::Val{names}, args...; kwargs...) where names
    types = Tuple{Core.Typeof.(args)...}
    world_counter = Base.get_world_counter()
    if get(world_counters, types, UInt(0)) < world_counter
        check_names(f, Val_names, types)
        world_counters[types] = world_counter
    end
    f(args...; kwargs...)
end

function check_names(f::Function, Val_names::Val{names}, Types::Type{<:Tuple}) where names
    method = @inline which(f, Types)
    @inline check_names(method, Val_names)
end

function check_names(method::Method, ::Val{names}) where names
    method_argnames = @view Base.method_argnames(method)[2:end]
    for i in eachindex(names)
        if names[i] != nothing && names[i] != method_argnames[i]
            throw(ArgumentError("expected argument name `$(method_argnames[i])`, got `$(names[i])`."))
        end
    end
end

end
