function part1(filename)
    solve(filename, strategy1)
end
    
function part2(filename)
    solve(filename, strategy2)
end
    
function solve(filename, strategy)

    f = open(filename)
    lines = readlines(f)

    surface::Set{CartesianIndices{3}} = Set()
    minX = minY = minZ = typemax(Int8)
    maxX = maxY = maxZ = typemin(Int8)
    
    for line in lines
        x, y, z = parse.(Int8, split(line, ","))
        minX = min(x, minX); minY = min(y, minY); minZ = min(z, minZ)
        maxX = max(x, maxX); maxY = max(y, maxY); maxZ = max(z, maxZ)
        sides::Array{CartesianIndices{3}} = [
            CartesianIndices((x:x+1, y:y+1, z:z)),
            CartesianIndices((x:x+1, y:y, z:z+1)),
            CartesianIndices((x:x, y:y+1, z:z+1)),
            CartesianIndices((x:x+1, y:y+1, z+1:z+1)),
            CartesianIndices((x:x+1, y+1:y+1, z:z+1)),
            CartesianIndices((x+1:x+1, y:y+1, z:z+1)),
        ]
        for side in sides
            if side ∈ surface
                delete!(surface, side)
            else
                push!(surface, side)
            end
        end
    end

    minXYZ = CartesianIndex(minX - 1, minY - 1, minZ - 1)
    maxXYZ = CartesianIndex(maxX + 1, maxY + 1, maxZ + 1)
    
    strategy(surface, minX - 1, minY - 1, minZ - 1, maxX + 1, maxY + 1, maxZ + 1)
end

function strategy1(surface, minX, minY, minZ, maxX, maxY, maxZ)
    length(surface)
end

function strategy2(surface, minX, minY, minZ, maxX, maxY, maxZ)

    water::Dict{CartesianIndices{3}, Bool} = Dict()
    outerSurface::Set{CartesianIndices{3}} = Set()

    start = CartesianIndices((minX:minX + 1, minY:minY + 1, minZ:minZ + 1))
    water[start]  = false

    while true
        complete = true
        for (cell, handled) in water
            if !handled
                complete = false
                neighbors::Dict{CartesianIndices{3}, CartesianIndices{3}} = Dict()
                x = cell[1][1]
                y = cell[1][2]
                z = cell[1][3]
                if x - 1 >= minX
                    neighbors[CartesianIndices((x:x, y:y+1, z:z+1))] = CartesianIndices((x-1:x, y:y+1, z:z+1))
                end
                if y - 1 >= minY
                    neighbors[CartesianIndices((x:x+1, y:y, z:z+1))] = CartesianIndices((x:x+1, y-1:y, z:z+1))
                end
                if z - 1 >= minZ
                    neighbors[CartesianIndices((x:x+1, y:y+1, z:z))] = CartesianIndices((x:x+1, y:y+1, z-1:z))
                end
                if x + 1 <= maxX
                    neighbors[CartesianIndices((x+1:x+1, y:y+1, z:z+1))] = CartesianIndices((x+1:x+2, y:y+1, z:z+1))
                end
                if y + 1 <= maxY
                    neighbors[CartesianIndices((x:x+1, y+1:y+1, z:z+1))] = CartesianIndices((x:x+1, y+1:y+2, z:z+1))
                end
                if z + 1 <= maxZ
                    neighbors[CartesianIndices((x:x+1, y:y+1, z+1:z+1))] = CartesianIndices((x:x+1, y:y+1, z+1:z+2))
                end
                for (boundary, neighbor) in neighbors
                    if boundary in surface
                        push!(outerSurface, boundary)
                    elseif !haskey(water, neighbor)
                        water[neighbor] = false
                    end
                end
                water[cell] = true
            end
        end
        if complete
            break
        end
    end

    length(outerSurface)

end