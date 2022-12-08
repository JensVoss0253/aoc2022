
function part1(filename)

    f = open(filename)
    lines = readlines(f)

    height = length(lines)
    width = length(lines[1])

    score = 0
    for x = 1:width, y = 1:height
        if isVisible(lines, x, y)
            score += 1
        end
    end
    score
end

function part2(filename)

    f = open(filename)
    lines = readlines(f)

    height = length(lines)
    width = length(lines[1])

    score = 0
    for x = 2:width-1, y = 2:height-1
        scenicScore = getScenicScore(lines, x, y)
        if scenicScore > score
            score = scenicScore
        end
    end
    score

end

function isVisible(lines, x, y)
    isVisibleLeft(lines, x, y) || isVisibleRight(lines, x, y) || isVisibleTop(lines, x, y) || isVisibleBottom(lines, x, y)
end

function isVisibleLeft(lines, x, y)
    for i = 1:x-1
        if lines[y][i] >= lines[y][x]
            return false
        end
    end
    true
end

function isVisibleRight(lines, x, y)
    width = length(lines[1])
    for i = x+1:width
        if lines[y][i] >= lines[y][x]
            return false
        end
    end
    true
end

function isVisibleTop(lines, x, y)
    for j = 1:y-1
        if lines[j][x] >= lines[y][x]
            return false
        end
    end
    true
end

function isVisibleBottom(lines, x, y)
    height = length(lines)
    for j = y+1:height
        if lines[j][x] >= lines[y][x]
            return false
        end
    end
    true
end

function getScenicScore(lines, x, y)
    getScenicScoreLeft(lines, x, y) * getScenicScoreRight(lines, x, y) * getScenicScoreTop(lines, x, y) * getScenicScoreBottom(lines, x, y)
end

function getScenicScoreLeft(lines, x, y)
    score = 0
    for i = x-1:-1:1
        if lines[y][i] < lines[y][x]
            score += 1
        end
        if lines[y][i] >= lines[y][x]
            score += 1
            break
        end
    end
    score
end

function getScenicScoreRight(lines, x, y)
    width = length(lines[1])
    score = 0
    for i = x+1:width
        if lines[y][i] < lines[y][x]
            score += 1
        end
        if lines[y][i] >= lines[y][x]
            score += 1
            break
        end
    end
    score
end

function getScenicScoreTop(lines, x, y)
    score = 0
    for j = y-1:-1:1
        if lines[j][x] < lines[y][x]
            score += 1
        end
        if lines[j][x] >= lines[y][x]
            score += 1
            break
        end
    end
    score
end

function getScenicScoreBottom(lines, x, y)
    height = length(lines)
    score = 0
    for j = y+1:height
        if lines[j][x] < lines[y][x]
            score += 1
        end
        if lines[j][x] >= lines[y][x]
            score += 1
            break
        end
    end
    score
end

