
using Test
include("Today.jl")

filename0 = string(@__DIR__, "/test0.txt")
filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @test part1(filename0, 3, 2) == 23
    @test part1(filename) == 13140
    @test part2(filename) == 0
end