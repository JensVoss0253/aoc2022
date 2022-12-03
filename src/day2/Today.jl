
function part1(filename)
    solve(filename, strategy1)
end

function part2(filename)
    solve(filename, strategy2)
end

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
    1 + (o + i + 3) % 3
end

