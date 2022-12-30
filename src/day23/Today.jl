const directions::Array{Array{CartesianIndex{2}}} = [
    [CartesianIndex((-1, -1)), CartesianIndex((0, -1)), CartesianIndex((1, -1))],
    [CartesianIndex((-1, 1)), CartesianIndex((0, 1)), CartesianIndex((1, 1))],
    [CartesianIndex((-1, -1)), CartesianIndex((-1, 0)), CartesianIndex((-1, 1))],
    [CartesianIndex((1, -1)), CartesianIndex((1, 0)), CartesianIndex((1, 1))]
]

function part1(filename)
    solve(filename, 10)
end

function part2(filename)
    solve(filename, 100000000)
end

function solve(filename, rounds)
    f = open(filename)
    lines = readlines(f)

    elves::Array{CartesianIndex{2}} = []
    for y = 1:length(lines)
        for x = 1:length(lines[y])
            if lines[y][x] == '#'
                push!(elves, CartesianIndex((x, y)))
            end
        end
    end

    prop::Dict{CartesianIndex{2}, CartesianIndex{2}} = Dict([])
    dir = 1
    for n = 1:rounds
        empty!(prop)
        for elf in elves
            if elf + directions[1][1] ∈ elves || elf + directions[1][2] ∈ elves || elf + directions[1][3] ∈ elves || 
                        elf + directions[2][1] ∈ elves || elf + directions[2][2] ∈ elves || elf + directions[2][3] ∈ elves || 
                        elf + directions[3][2] ∈ elves || elf + directions[4][2] ∈ elves
                for d = dir:dir+3
                    direction = directions[mod1(d, 4)]
                    if elf + direction[1] ∉ elves && elf + direction[2] ∉ elves && elf + direction[3] ∉ elves
                        p = elf + direction[2]
                        if haskey(prop, p)
                            delete!(prop, p)
                        else
                            prop[p] = elf
                        end
                        break
                    end
                end
            end
        end
        if isempty(prop)
            return n
        end
        for (p, e) in prop
            replace!(elves, e => p)
        end
        dir = mod1(dir + 1, 4)
    end

    minX = elves[1][1]
    maxX = elves[1][1]
    minY = elves[1][2]
    maxY = elves[1][2]
    for elf in elves
        minX = min(minX, elf[1])
        maxX = max(maxX, elf[1])
        minY = min(minY, elf[2])
        maxY = max(maxY, elf[2])
    end

    (maxX - minX + 1) * (maxY - minY + 1) - length(elves)

end
