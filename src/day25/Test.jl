
using Test
include("Today.jl")

filename = string(@__DIR__, "/test.txt")

@testset "Today" begin
    @time @test part1(filename) == "2=-1=0"
    @time @test part2(filename) == 0
end