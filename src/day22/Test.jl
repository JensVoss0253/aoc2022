
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @time @test part1(filename) == 6032
    @time @test part2(filename) == 5031
end