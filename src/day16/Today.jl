using Pkg
Pkg.add("Combinatorics")

using Combinatorics

struct Valve
    name::String
    flow::Int32
    tunnels::Array{Valve}
    Valve(name, flow) = new(name, flow, [])
end

global startIndex::Int
global flows::Array{Int}
global totalFlow::Int
global distances::Array{Array{Int}}
global options::Dict{Array{Int}, Array{Int}}

global record::Int = 0
global dockets::Array{Array{Int}}

function init(filename)

    global startIndex, flows, totalFlow, distances, options

    f = open(filename)
    lines = readlines(f)

    valvesByName::Dict{String, Valve} = Dict([])
    functional = 0
    totalFlow = 0
    for line in lines
        name, flow = match(r"Valve (.*) has flow rate=(.*); tunnels? leads? to valves? .*", line)
        valve = Valve(name, parse(Int32, flow))
        valvesByName[name] = valve
        if (valve.flow > 0)
            functional += 1
            totalFlow += valve.flow
        end
    end
    for line in lines
        name, tunnels = match(r"Valve (.*) has flow rate=.*; tunnels? leads? to valves? (.*)", line)
        for tunnel in split(tunnels, ",")
            push!(valvesByName[name].tunnels, valvesByName[strip(tunnel)])
        end
    end

    valves = sort(collect(values(valvesByName)), lt = (v, w) -> v.flow == w.flow ? v.name <= w.name : v.flow > w.flow)
    
    indexes::Dict{Valve, Int32} = Dict([])
    for i in eachindex(valves)
        indexes[valves[i]] = i
    end

    startIndex = indexes[valvesByName["AA"]]

    flows = []
    for i = 1:startIndex + 1
        push!(flows, valves[i].flow)
    end

    n::Int = length(valves)
    adj = [falses(n) for _ = 1:n]
    distances = [fill(n, n) for _ = 1:n]
    for i = 1:n
        for valve in valves[i].tunnels
            adj[i][indexes[valve]] = true
        end
    end
    for i = 1:n, j = 1:n
        if i == j
            distances[i][j] = 0
        elseif adj[i][j]
            distances[i][j] = 1
        end
    end
    for k = 1:n
        for i = 1:n, j = 1:n
            distances[i][j] = min(distances[i][j], distances[i][k] + distances[k][j])
        end
    end

    options = Dict([])
    for x = 1:startIndex, t = 0:30
        options[[x, t]] = sort(filter(y -> distances[x][y] < t, 1:startIndex-1), by = y -> (t - distances[x][y] - 1) * valves[y].flow, rev = true)
    end

end

function part1(filename)

    global startIndex, totalFlow, distances, options, dockets, record

    init(filename)
    dockets = [[startIndex]]

    search1(30, 0, 0)

    record
end

function part2(filename)

    global startIndex, totalFlow, distances, options, dockets, record

    init(filename)
    dockets = [[startIndex], [startIndex]]

    search2(26, [0, 0], 0, 0, 0)

    record
end

function search1(t, flow, sum)
    global startIndex, flows, totalFlow, distances, options, dockets
    checkResult(sum + t * flow)
    x = dockets[1][end]
    for y in setdiff(options[[x, t]], dockets[1])
        push!(dockets[1], y)
        interval = distances[x][y] + 1
        newFlow = flow + flows[y]
        search1(t - interval, newFlow, sum + interval * flow)
        pop!(dockets[1])
    end
end

function search2(t, timeLeft, flow1, flow2, sum)
    global startIndex, flows, totalFlow, distances, options, dockets
    checkResult(sum + t * flow1 + t * flow2)
    x1 = dockets[1][end]
    x2 = dockets[2][end]
    options1 = setdiff(options[[x1, t]], (dockets[1] ∪ dockets[2]))
    options2 = setdiff(options[[x2, t]], (dockets[1] ∪ dockets[2]))
    if timeLeft[1] == 0 && timeLeft[2] == 0
        for y1 in options1, y2 in options2
            if y1 != y2
                push!(dockets[1], y1)
                push!(dockets[2], y2)
                interval1 = distances[x1][y1] + 1
                interval2 = distances[x2][y2] + 1
                interval = min(interval1, interval2)
                newFlow1 = interval == interval1 ? flow1 + flows[y1] : flow1
                newFlow2 = interval == interval2 ? flow2 + flows[y2] : flow2
                search2(t - interval, [interval1 - interval, interval2 - interval], newFlow1, newFlow2, sum + interval * (flow1 + flow2))
                pop!(dockets[2])
                pop!(dockets[1])
            end
        end
        for y1 in options1
            push!(dockets[1], y1)
            interval = distances[x1][y1] + 1
            newFlow = flow1 + flows[y1]
            search2(t - interval, [0, 0], newFlow, flow2, sum + interval * (flow1 + flow2))
            pop!(dockets[1])
        end
        for y2 in options2
            push!(dockets[2], y2)
            interval = distances[x2][y2] + 1
            newFlow = flow2 + flows[y2]
            search2(t - interval, [0, 0], flow1, newFlow, sum + interval * (flow1 + flow2))
            pop!(dockets[2])
        end
    elseif timeLeft[1] == 0
        if isempty(options1)
            search2(t - timeLeft[2], [0, 0], flow1, flow2 + flows[dockets[2][end]], sum + timeLeft[2] * (flow1 + flow2))
        end
        for y1 in options1
            push!(dockets[1], y1)
            interval1 = distances[x1][y1] + 1
            interval2 = timeLeft[2]
            interval = min(interval1, interval2)
            newFlow1 = interval == interval1 ? flow1 + flows[y1] : flow1
            newFlow2 = interval == interval2 ? flow2 + flows[dockets[2][end]] : flow2
            search2(t - interval, [interval1 - interval, interval2 - interval], newFlow1, newFlow2, sum + interval * (flow1 + flow2))
            pop!(dockets[1])
        end
    else
        if isempty(options2)
            search2(t - timeLeft[1], [0, 0], flow1 + flows[dockets[1][end]], flow2, sum + timeLeft[1] * (flow1 + flow2))
        end
        for y2 in options2
            push!(dockets[2], y2)
            interval1 = timeLeft[1]
            interval2 = distances[x2][y2] + 1
            interval = min(interval1, interval2)
            newFlow1 = interval == interval1 ? flow1 + flows[dockets[1][end]] : flow1
            newFlow2 = interval == interval2 ? flow2 + flows[y2] : flow2
            search2(t - interval, [interval1 - interval, interval2 - interval], newFlow1, newFlow2, sum + interval * (flow1 + flow2))
            pop!(dockets[2])
        end
    end
end

function checkResult(flow)
    global dockets, record
    if flow > record
        # println("Neuer Flow-Rekord: ", flow)
        # println("Dockets: ", dockets)
        record = flow
    end
end