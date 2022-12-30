struct Cell
    x::Int32
    y::Int32
end

function part1(filename)
    solve(filename, strategy1)
end

function part2(filename)
    solve(filename, strategy2)
end

function solve(filename, strategy)
    
    f = open(filename)
    lines = readlines(f)
    
    paths::Array{Array{Cell}} = []

    height::Int32 = 0
    for line in lines
        path::Array{Cell} = []
        for positions in split(line, "->")
            (x, y) = map(s -> parse(Int, s), split(strip(positions), ","))
            push!(path, Cell(x, y))
            if y > height
                height = y
            end
        end
        push!(paths, path)
    end

    height += 3

    offset::Int32 = 500 - height
    width::Int32 = 2 * height - 1

    cave = [falses(width) for _ in 1:height-1]
    push!(cave, trues(width))

    for path in paths
        for i = 2:length(path)
            x = path[i-1].x
            y = path[i-1].y
            dx = sign(path[i].x - x)
            dy = sign(path[i].y - y)
            while true
                cave[y+1][x-offset] = true
                if (x, y) == (path[i].x, path[i].y)
                    break
                end
                x += dx
                y += dy
            end
        end
    end

    score = 0
    while true
        (x, y) = (500 - offset, 1)
        while true
            if !cave[y+1][x]
                y += 1
            elseif !cave[y+1][x-1]
                (x, y) = (x - 1, y + 1)
            elseif !cave[y+1][x+1]
                (x, y) = (x + 1, y + 1)
            else
                break
            end
        end
        if strategy(y, height)
            return score
        end
        cave[y][x] = true
        score += 1
    end

end

function strategy1(y, height)
    return y >= height - 2
end

function strategy2(y, height)
    return y == 1
end