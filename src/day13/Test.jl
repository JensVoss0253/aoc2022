
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test @time part1(filename) == 13
    @test @time part2(filename) == 140
end