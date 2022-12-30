
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @time @test part1(filename, 10) == 26
    @time @test part2(filename, 20) == 56000011
end