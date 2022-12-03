
include("Today.jl")

filename = string(@__DIR__, "/main.txt")

println("Part 1: ", part1(filename))
println("Part 2: ", part2(filename))