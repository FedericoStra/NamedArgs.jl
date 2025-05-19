.PHONY: default
default: test docs

.PHONY: all
all: test docs bench

.PHONY: test
test:
	julia --project -e 'using Pkg; Pkg.test()'

.PHONY: docs
docs:
	julia --project=docs docs/make.jl

.PHONY: bench
bench:
	julia --project benches/dispatch_time.jl
