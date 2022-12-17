
shapes::Array{BitArray{2}} = [
    # Dash
    BitArray([0 0 1 1 1 1 0]),
    # Plus
    BitArray([0 0 0 1 0 0 0; 0 0 1 1 1 0 0; 0 0 0 1 0 0 0]),
    # Hook
    BitArray([0 0 1 1 1 0 0; 0 0 0 0 1 0 0; 0 0 0 0 1 0 0]),
    # Pipe
    BitArray([0 0 1 0 0 0 0; 0 0 1 0 0 0 0; 0 0 1 0 0 0 0; 0 0 1 0 0 0 0]),
    # Square
    BitArray([0 0 1 1 0 0 0; 0 0 1 1 0 0 0])
]

mutable struct Rock
    points::Array{CartesianIndex{2}}
    Rock(shape::BitArray{2}, height::Int) = new(shift(findall(shape), CartesianIndex(height, 0)))
end

function shift(points::Array{CartesianIndex{2}}, direction::CartesianIndex{2})::Array{CartesianIndex{2}}
    map(p -> p + direction, points)
end

function isValid(points::Array{CartesianIndex{2}}, cave::BitArray{2})
    for point in points
        if point[1] <= 0 || point[2] <= 0 || point[2] >= 8
            return false
        end
        if cave[point]
            return false
        end
    end
    true
end

function solve(filename, rocks::Int64)::Int64
    
    f = open(filename)
    lines = readlines(f)
    jets = lines[1]

    maxJ = length(jets)
    j = 1

    cave::BitArray{2} = falses(0, 7)
    height = 0
    results::Array{Tuple{Int64, Int64}} = []

    for s = 1:rocks
        
        height += 3
        cave = vcat(cave, falses(3, 7))
        
        shape = shapes[(s-1) % 5 + 1]
        rock = Rock(shape, height)
        height += size(shape)[1]
        if (size(cave)[1] < height)
            cave = vcat(cave, falses(height - size(cave)[1], 7))
        end

        while true

            # Move horizontally ...
            jet = jets[j]
            j = j % maxJ + 1
            dir = CartesianIndex(0, jet == '<' ? -1 : 1)
            points = shift(rock.points, dir)
            # ... if possible
            if isValid(points, cave)
                rock.points = points
            end

            # Then move vertically ...
            points = shift(rock.points, CartesianIndex(-1, 0))
            # ... if possible, ...
            if isValid(points, cave)
                rock.points = points
            else
                # ..., otherwise fix rock ...
                for point in rock.points
                    cave[point] = true
                end
                height = maximum(map(p -> p[1], findall(cave)))
                push!(results, (height, j))

                # ... detect period
                for r = s-5:-5:s÷2
                    if results[r][2] == j
                        u = (rocks - r) % (s - r) + r
                        return results[u][1] + (rocks - u) ÷ (s - r) * (height - results[r][1])
                    end
                end

                break
            end
        end

    end

    height
end

function part1(filename)
    solve(filename, 2022)
end

function part2(filename)
    solve(filename, 1000000000000)
end