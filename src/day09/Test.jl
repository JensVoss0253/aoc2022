
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")
filename2 = string(@__DIR__, "/test2.txt")

@testset "Today" begin
    @test part1(filename) == 13
    @test part2(filename) == 1
    @test part2(filename2) == 36
end