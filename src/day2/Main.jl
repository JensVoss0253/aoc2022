
include("Today.jl")

filename = string(@__DIR__, "/main.txt")

println("Part1: ", part1(filename))
println("Part2: ", part2(filename))