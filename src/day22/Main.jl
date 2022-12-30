
include("Today.jl")

filename = string(@__DIR__, "/main.txt")

println("Part 1: ", @time part1(filename))
println("Part 2: ", @time part2(filename))