
function part1(filename)

    f = open(filename)
    lines = readlines(f)

    score = 0
    for line in lines
        bounds = getBounds(line)
        if (bounds[1][1] - bounds[2][1]) * (bounds[1][2] - bounds[2][2]) <= 0
            score += 1
        end
    end
    score
end

function part2(filename)

    f = open(filename)
    lines = readlines(f)

    score = 0
    for line in lines
        bounds = getBounds(line)
        if (length(intersect(bounds[1][1]:bounds[1][2], bounds[2][1]:bounds[2][2]))) > 0
            score += 1
        end
    end
    score

end

function getBounds(line)
    elves = split(line, ",")
    [[parse(Int, b) for b in split(elves[i], "-")] for i in 1:2]
end