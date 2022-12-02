#=
Test:
- Julia version: 1.8.3
- Author: Jens Voß
- Date: 2022-12-01
=#

include("Day1.jl")

filename = "src\\day1\\main.txt"

println(solve1(filename))
println(solve2(filename))