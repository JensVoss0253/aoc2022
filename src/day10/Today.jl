
function part1(filename, start = 20, step = 40)

    f = open(filename)
    lines = readlines(f)
    values = getValues(lines)

    score = 0
    for i = start:step:length(values)
        score += i * values[i]
    end
    score
end

function part2(filename)

    f = open(filename)
    lines = readlines(f)
    values = getValues(lines)

    image = ""
    for i = 1:length(values)
        j = 1 + ((i - 1) % 40)
        if 0 <= j - values[i] <= 2
            image *= "# "
        else
            image *= "  "
        end
        if j == 40
            image *= "\n"
        end
    end

    println(image)

    score = 0
    score

end

function getValues(lines)
    values = [1]

    for line in lines
        push!(values, values[end])
        if startswith(line, "addx")
            d = parse(Int, SubString(line, 6))
            push!(values, values[end] + d)
        end
    end

    values

end