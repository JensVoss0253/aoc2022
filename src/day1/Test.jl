#=
Test:
- Julia version: 1.8.3
- Author: Jens Voß
- Date: 2022-12-01
=#

include("Day1.jl")

filename = "src\\day1\\test.txt"

println(solve1(filename))
println(solve2(filename))