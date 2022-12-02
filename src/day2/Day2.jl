#=
Day1:
- Julia version: 1.8.3
- Author: Jens Voß
- Date: 2022-12-01
=#

function solve(filename, strategy)

    f = open(filename)
    lines = readlines(f)

    score = 0
    for line in lines
        o = codeunit(line, 1) - 64
        i = strategy(line)
        score += i + 3 * ((4 + i - o) % 3)
    end

    score
end

function strategy1(line)
    codeunit(line, 3) - 87
end

function strategy2(line)
    o = codeunit(line, 1) - 64
    i = codeunit(line, 3) - 87
    r = 1 + (o + i + 3) % 3
#     println(line)
#     println(r)
    r
end

function solve1(filename)
    solve(filename, strategy1)
end

function solve2(filename)
    solve(filename, strategy2)
end
