mutable struct Entry
    value::Int
    left::Entry
    right::Entry
    Entry(v::Int) = (x = new(); x.value = v; x.left = x; x.right = x)
end

mutable struct Cycle
    entries::Array{Entry}
    zeroIdx::Int
    Cycle() = new([], 0)
end

function swap!(entry::Entry)
    l = entry.left
    r = entry.right
    s = r.right

    l.right = r
    entry.left = r
    entry.right = s
    r.left = l
    r.right = entry
    s.left = entry

end

function solve(filename, factor, mixes)

    f = open(filename)
    lines = readlines(f)

    arr = parse.(Int, lines)
    len = length(arr)

    cycle = Cycle()
    for v in arr
        push!(cycle.entries, Entry(v * factor))
        if v == 0
            cycle.zeroIdx = length(cycle.entries)
        end
    end
    for i = 1:len
        cycle.entries[i].left = cycle.entries[mod1(i - 1, len)]
        cycle.entries[i].right = cycle.entries[mod1(i + 1, len)]
    end

    for _ = 1:mixes
        for entry in cycle.entries
            s = mod(entry.value, 1:len - 1)
            for _ = 1:s
                swap!(entry)
            end
        end
    end

    score = 0
    entry = cycle.entries[cycle.zeroIdx]
    for _ = 1:3
        for _ = 1:1000
            entry = entry.right
        end
        score += entry.value
    end

    close(f)
    score

end

function part1(filename)
    solve(filename, 1, 1)
end

function part2(filename)
    solve(filename, 811589153, 10)
end