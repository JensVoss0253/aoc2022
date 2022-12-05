function part1(filename)
    solve(filename, strategy1)
end

function part2(filename)
    solve(filename, strategy2)
end

function solve(filename, strategy)

    f = open(filename)
    lines = readlines(f)

    len = (length(lines[1]) + 1) ÷ 4
    
    stacks = Array{String}(undef, len)
    fill!(stacks, "")

    for line in lines
        if startswith(line, "move")
            count, source, target = map(x -> parse(Int, x), match(r"move (?<c>\d+) from (?<s>\d+) to (?<t>\d+)", line))
            stacks[target] = strategy(SubString(stacks[source], 1, count)) * stacks[target]
            stacks[source] = SubString(stacks[source], count + 1)
        elseif startswith(strip(line), "[")
            for i = 1:len
                c = line[4*i-2]
                stacks[i] *= c
            end
        elseif length(line) == 0
            for i = 1:len
                stacks[i] = strip(stacks[i])
            end
        end
    end

    score = ""
    for i = 1:len
        score *= SubString(stacks[i], 1, 1)
    end
    score
end

function strategy1(str)
    reverse(str)
end

function strategy2(str)
    str
end