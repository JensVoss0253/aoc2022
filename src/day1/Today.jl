
function part1(filename)
    result = solve(filename)
    result[3]
end

function part2(filename)
    result = solve(filename)
    sum(result)
end

function solve(filename)

    f = open(filename)
    lines = readlines(f)

    result = [0, 0, 0];
    sum = 0;

    for line in lines
        if sizeof(line) == 0
            result = append!(result, [sum])
            result = sort(result)
            result = [result[2],result[3],result[4]]
            sum = 0
        else
            sum = sum + parse(Int, line)
        end
    end

    result = append!(result, [sum])
    result = sort(result)

    [result[2],result[3],result[4]]

end

