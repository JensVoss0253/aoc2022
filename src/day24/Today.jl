const EAST::Array{Int8} = [1, 0]
const WEST::Array{Int8} = [-1, 0]
const NORTH::Array{Int8} = [0, -1]
const SOUTH::Array{Int8} = [0, 1]

const MOVES::Array{Array{Int8}} = [[0, 0], EAST, WEST, NORTH, SOUTH]

function part1(filename)
    solve(filename, 1)
end

function part2(filename)
    solve(filename, 3)
end

function solve(filename, rounds)
    f = open(filename)
    lines = readlines(f)

    height = length(lines) - 2
    width = length(lines[1]) - 2

    winds::Dict{Array{Int8}, Array{Array{Int8}}} = Dict([
        (EAST, []), (WEST, []), (NORTH, []), (SOUTH, [])
    ])

    for y = 1:height, x = 1:width
        c = lines[y + 1][x + 1]
        if c == '>'
            push!(winds[EAST], [x, y])
        elseif c == '<'
            push!(winds[WEST], [x, y])
        elseif c == '^'
            push!(winds[NORTH], [x, y])
        elseif c == 'v'
            push!(winds[SOUTH], [x, y])
        end
    end

    start = [1, 0]
    finish = [width, height + 1]

    score = 0
    for _ = 1:rounds
        positions::Array{Set{Array{Int8}}} = [Set([start])]
        n = 1
        while true
            windset::Set{Array{Int8}} = Set([])
            for (key, _) in winds
                winds[key] = map(x -> mod1.(x + key, [width, height]), winds[key])
                push!(windset, winds[key]...)
            end
            nextSet::Set{Array{Int8}} = Set([])
            for position in positions[end], move in MOVES
                target = position + move
                if target == finish
                    score += n
                    @goto outer
                elseif target == start || (1 <= target[1] <= width && 1 <= target[2] <= height && target ∉ windset)
                    push!(nextSet, target)
                end
            end
            push!(positions, nextSet)
            n += 1
        end
        @label outer
        (start, finish) = (finish, start)
    end
    score
end
