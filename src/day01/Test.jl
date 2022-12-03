
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test part1(filename) == 24000
    @test part2(filename) == 45000
end