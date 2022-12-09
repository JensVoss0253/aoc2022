
function part1(filename)
    solve(filename, 2)
end

function part2(filename)
    solve(filename, 10)
end

function solve(filename, knotCount)
    f = open(filename)
    lines = readlines(f)

    knots = Array{Cell}(undef, knotCount)
    for k = 1:knotCount
        knots[k] = Cell(0, 0)
    end
    tails = Set()

    for line in lines
        direction = SubString(line, 1, 1)
        count = parse(Int, SubString(line, 3))
        for c = 1:count
            knots[1] = move(knots[1], direction)
            for k = 2:knotCount
                knots[k] = follow(knots[k-1], knots[k])
            end
            push!(tails, knots[knotCount])
        end
    end

    length(tails)
end

struct Cell
    x::Int
    y::Int
end

function move(cell::Cell, direction)::Cell
    if direction == "R"
        Cell(cell.x + 1, cell.y)
    elseif direction == "L"
        Cell(cell.x - 1, cell.y)
    elseif direction == "U"
        Cell(cell.x, cell.y + 1)
    else
        Cell(cell.x, cell.y - 1)
    end
end

function follow(head::Cell, tail::Cell)::Cell
    if abs(head.x - tail.x) == 2
        Cell((head.x + tail.x) ÷ 2, head.y)
    elseif abs(head.y - tail.y) == 2
        Cell(head.x, (head.y + tail.y) ÷ 2)
    else
        tail
    end
end