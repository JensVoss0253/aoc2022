
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test part1(filename) == 2
    @test part2(filename) == 4
end