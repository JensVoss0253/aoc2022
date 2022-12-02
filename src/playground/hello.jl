#=
hello:
- Julia version: 1.8.3
- Author: Jens Voß
- Date: 2022-11-30
=#

add DebuggerFramework

function foo()
    x = 100
    x
end

y = foo()
println(y)