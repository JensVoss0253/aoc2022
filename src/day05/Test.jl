
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test part1(filename) == "CMZ"
    @test part2(filename) == "MCD"
end