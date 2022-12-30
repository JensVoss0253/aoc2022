directions::Array{CartesianIndex{2}} = [
    CartesianIndex((1, 0)),
    CartesianIndex((0, 1)),
    CartesianIndex((-1, 0)),
    CartesianIndex((0, -1))
]

lines::Array{String} = []
height::Int64 = -1
width::Int64 = -1

function part1(filename)
    solve(filename, getTargetByCyclicShift)
end

function part2(filename)
    if endswith(filename, "test.txt")
        return solve(filename, getTargetForTestCube)
    else
        return solve(filename, getTargetForMainCube)
    end
end

function solve(filename, getTarget)

    f = open(filename)
    global lines = readlines(f)

    global height = length(lines) - 2
    global width = maximum(length, lines)

    for y = 1:height
        if length(lines[y]) < width
            lines[y] *= repeat(' ', width - length(lines[y]))
        end
    end

    pos::CartesianIndex{2} = CartesianIndex((1, 1))
    dir::Int8 = 1

    while lines[pos[2]][pos[1]] == ' '
        pos += directions[dir]
    end


    for m in collect(eachmatch(r"(\d+|[^\d]+)", lines[end]))
        op = m[1]
        if op == "L"
            dir = mod1(dir - 1, 4)
        elseif op == "R"
            dir = mod1(dir + 1, 4)
        elseif op != "0"
            steps = parse(Int, op)
            while true
                (targetPos, targetDir) = getTarget(pos, dir)
                if lines[targetPos[2]][targetPos[1]] == '#'
                    break
                else
                    pos = targetPos
                    dir = targetDir
                end
                steps -= 1
                if steps == 0
                    break
                end
            end
        end
    end
    
    1000 * pos[2] + 4 * pos[1] + dir - 1
    
end

function getTargetByCyclicShift(pos::CartesianIndex{2}, dir::Int8)
    target = pos
    while true
        target += directions[dir]
        if target[1] == 0
            target = CartesianIndex((width, target[2]))
        elseif target[1] == width + 1
            target = CartesianIndex((1, target[2]))
        elseif target[2] == 0
            target = CartesianIndex((target[1], height))
        elseif target[2] == height + 1
            target = CartesianIndex((target[1], 1))
        end
        if lines[target[2]][target[1]] != ' '
            break
        end
    end
    (target, dir)
end
    
function getTargetForTestCube(pos::CartesianIndex{2}, dir::Int8)
    target = pos + directions[dir]
    if target[2] == 9 && target[1] <= 4
        return (CartesianIndex((13 - target[1], 12)), 4)
    elseif target[1] == 0
        return (CartesianIndex((21 - target[2], 12)), 4)
    elseif target[2] == 4 && target[1] <= 4
        return (CartesianIndex((13 - target[1], 1)), 2)
    elseif target[2] == 4 && target[1] <= 8 && dir == 4
        return (CartesianIndex((9, target[1] - 4)), 1)
    elseif target[1] == 8 && target[2] <= 4
        return (CartesianIndex((target[2] + 4, 5)), 2)
    elseif target[2] == 0
        return (CartesianIndex((13 - target[1], 5)), 2)
    elseif target[1] == 13 && target[2] <= 4
        return (CartesianIndex((16, 13 - target[2])), 3)
    elseif target[1] == 13 && target[2] <= 8 && dir == 1
        return (CartesianIndex((21 - target[2], 9)), 2)
    elseif target[2] == 8 && target[1] >= 13
        return (CartesianIndex((12, 21 - target[1])), 3)
    elseif target[1] == 17
        return (CartesianIndex((12, 13 - target[2])), 3)
    elseif target[2] == 13 && target[1] >= 13
        return (CartesianIndex((1, 21 - target[1])), 1)
    elseif target[2] == 13
        return (CartesianIndex((13 - target[1], 8)), 4)
    elseif target[1] == 8 && target[2] >= 9 && dir == 3
        return (CartesianIndex((17 - target[2], 8)), 4)
    elseif target[2] == 9 && target[1] <= 8
        return (CartesianIndex((9, 17 - target[1])), 1)
    else
        return (target, dir)
    end
end

function getTargetForMainCube(pos::CartesianIndex{2}, dir::Int8)
    target = pos + directions[dir]
    if target[2] == 0 && target[1] <= 100
        return (CartesianIndex((1, target[1] + 100)), 1)
    elseif target[2] == 0
        return (CartesianIndex((target[1] - 100, 200)), 4)
    elseif target[1] == 151
        return (CartesianIndex((100, 151 - target[2])), 3)
    elseif target[2] == 51 && target[1] >= 100 && dir == 2
        return (CartesianIndex((100, target[1] - 50)), 3)
    elseif target[1] == 101 && 51 <= target[2] <= 100
        return (CartesianIndex((target[2] + 50, 50)), 4)
    elseif target[1] == 101 && target[2] >= 101
        return (CartesianIndex((150, 151 - target[2])), 3)
    elseif target[2] == 151 && target[1] >= 51 && dir == 2
        return (CartesianIndex((50, target[1] + 100)), 3)
    elseif target[1] == 51 && target[2] >= 151 
        return (CartesianIndex((target[2] - 100, 150)), 4)
    elseif target[2] == 201
        return (CartesianIndex((target[1] + 100, 1)), 2)
    elseif target[1] == 0 && target[2] >= 151
        return (CartesianIndex((target[2] - 100, 1)), 2)
    elseif target[1] == 0 
        return (CartesianIndex((51, 151 - target[2])), 1)
    elseif target[2] == 100 && target[1] <= 50 && dir == 4
        return (CartesianIndex((51, target[1] + 50)), 1)
    elseif target[1] == 50 && 51 <= target[2] <= 100
        return (CartesianIndex((target[2] - 50, 101)), 2)
    elseif target[1] == 50 && target[2] <= 50
        return (CartesianIndex((1, 151 - target[2])), 1)
    else
        return (target, dir)
    end
end