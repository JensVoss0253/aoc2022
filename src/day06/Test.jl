
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test part1(filename) == "7 5 6 10 11"
    @test part2(filename) == "19 23 23 29 26"
end