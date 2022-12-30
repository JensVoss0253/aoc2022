
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @time @test part1(filename) == 3
    @time @test part2(filename) == 1623178306
end