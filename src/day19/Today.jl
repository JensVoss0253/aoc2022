using Pkg
Pkg.add("DataStructures")

using DataStructures

struct Blueprint
    number::Int8
    ore4Ore::Int8
    ore4Clay::Int8
    ore4Obs::Int8
    clay4Obs::Int8
    ore4Geode::Int8
    obs4Geode::Int8
    Blueprint(description::String) = new(parseBlueprint(description)...)
end

function parseBlueprint(description::String)
    parse.(Int, match(r"Blueprint (\d*): Each ore robot costs (\d*) ore. Each clay robot costs (\d*) ore. Each obsidian robot costs (\d*) ore and (\d*) clay. Each geode robot costs (\d*) ore and (\d*) obsidian.", description))
end

function quality(blueprint::Blueprint, minutes)
    statesArray::Array{Array{Array{Int16}}} = [[[1, 0, 0, 0, 0, 0, 0, 0]]]
    maxOre4Robots = max(blueprint.ore4Ore, blueprint.ore4Clay, blueprint.ore4Obs, blueprint.ore4Geode)
    for _ = 1:minutes
        states::SortedSet{Array{Int16}} = SortedSet()
        for state in statesArray[end]
            push!(states, [state[1], state[2], state[3], state[4], state[5] + state[1], state[6] + state[2], state[7] + state[3], state[8] + state[4]])
            if state[1] < maxOre4Robots && state[5] >= blueprint.ore4Ore
                push!(states, [state[1] + 1, state[2], state[3], state[4], state[5] + state[1] - blueprint.ore4Ore, state[6] + state[2], state[7] + state[3], state[8] + state[4]])
            end
            if state[2] < blueprint.clay4Obs && state[5] >= blueprint.ore4Clay
                push!(states, [state[1], state[2] + 1, state[3], state[4], state[5] + state[1] - blueprint.ore4Clay, state[6] + state[2], state[7] + state[3], state[8] + state[4]])
            end
            if state[3] < blueprint.obs4Geode && state[5] >= blueprint.ore4Obs && state[6] >= blueprint.clay4Obs
                push!(states, [state[1], state[2], state[3] + 1, state[4], state[5] + state[1] - blueprint.ore4Obs, state[6] + state[2] - blueprint.clay4Obs, state[7] + state[3], state[8] + state[4]])
            end
            if state[5] >= blueprint.ore4Geode && state[7] >= blueprint.obs4Geode
                push!(states, [state[1], state[2], state[3], state[4] + 1, state[5] + state[1] - blueprint.ore4Geode, state[6] + state[2], state[7] + state[3] - blueprint.obs4Geode, state[8] + state[4]])
            end
        end
        arr = collect(states)
        if length(states) < 75000
            for i = length(arr):-1:1
                for j = length(arr):-1:i+1
                    domination = true
                    for k = 1:8
                        if arr[i][k] > arr[j][k]
                            domination = false
                            break
                        end
                    end
                    if domination
                        deleteat!(arr, i)
                        break
                    end
                end
            end
        end
        push!(statesArray, arr)
        # println(length(statesArray), ": ", length(statesArray[end]))
    end
    quality = 0
    for state in statesArray[end]
        if state[8] > quality
            quality = state[8]
        end
    end
    quality
end

function part1(filename)
    f = open(filename)
    lines = readlines(f)

    blueprints = map(desc -> Blueprint(desc), lines)

    score = 0

    for blueprint in blueprints
        score += quality(blueprint, 24) * blueprint.number
    end

    score
end
    
function part2(filename)
    f = open(filename)
    lines = readlines(f)

    blueprints = []
    for line in lines
        push!(blueprints, Blueprint(line))
        if length(blueprints) == 3
            break
        end
    end

    score = 1

    for blueprint in blueprints
        score *= quality(blueprint, 32)
    end

    score
end
