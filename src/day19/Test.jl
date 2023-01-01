
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @time @test part1(filename) == 33
    @time @test part2(filename) == 56 * 62
end