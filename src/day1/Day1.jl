#=
Day1:
- Julia version: 1.8.3
- Author: Jens Voß
- Date: 2022-12-01
=#

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

function solve1(filename)
    result = solve(filename)
    result[3]
end

function solve2(filename)
    result = solve(filename)
    sum(result)
end
