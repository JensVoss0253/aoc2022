
function part1(filename)
    f = open(filename)
    lines = readlines(f)
    numbers::Dict{String, Int64} = getNumbers(lines, [])
    numbers["root"]
end

function part2(filename)
    f = open(filename)
    lines = readlines(f)

    numbers::Dict{String, Int64} = getNumbers(lines, ["root", "humn"])

    left = ""
    right = ""
    for i = length(lines):-1:1
        name = SubString(lines[i], 1, 4)
        expr = SubString(lines[i], 7)
        if name == "humn"
            deleteat!(lines, i)
        elseif name == "root"
            deleteat!(lines, i)
            left = SubString(expr, 1, 4)
            right = SubString(expr, 8)
        end
    end

    expressions::Dict{String, Array{String}} = Dict([])
    for line in lines
        expressions[SubString(line, 1, 4)] = [SubString(line, 7, 10), SubString(line, 12, 12), SubString(line, 14)]
    end

    if haskey(numbers, left)
        return equate(expressions, numbers, right, numbers[left])
    else
        return equate(expressions, numbers, left, numbers[right])
    end

end

function getNumbers(lines, exceptions)

    numbers::Dict{String, Int64} = Dict([])

    while true
        changes = false
        for i = length(lines):-1:1
            name = SubString(lines[i], 1, 4)
            expr = SubString(lines[i], 7)
            if !any(x -> x == name, exceptions)
                if length(expr) < 11
                    numbers[name] = parse(Int64, expr)
                    deleteat!(lines, i)
                    changes = true
                else
                    name1 = SubString(expr, 1, 4)
                    name2 = SubString(expr, 8)
                    if haskey(numbers, name1) && haskey(numbers, name2)
                        op = SubString(expr, 6, 6)
                        if op == "+"
                            numbers[name] = numbers[name1] + numbers[name2]
                        elseif op == "-"
                            numbers[name] = numbers[name1] - numbers[name2]
                        elseif op == "*"
                            numbers[name] = numbers[name1] * numbers[name2]
                        elseif op == "/"
                            numbers[name] = numbers[name1] ÷ numbers[name2]
                        end
                        deleteat!(lines, i)
                        changes = true
                    end
                end
            end
        end
        if !changes
            break
        end
    end

    numbers

end

function equate(expressions, numbers, expression, num)
    if expression == "humn"
        return num
    else
        expr = expressions[expression]
        numberFirst::Bool = haskey(numbers, expr[1])
        number::Int64 = numbers[expr[numberFirst ? 1 : 3]]
        name::String = expr[numberFirst ? 3 : 1]
        if expr[2] == "+"
            return equate(expressions, numbers, name, num - number)
        elseif expr[2] == "-" && numberFirst
            return equate(expressions, numbers, name, number - num)
        elseif expr[2] == "-"
            return equate(expressions, numbers, name, num + number)
        elseif expr[2] == "*"
            return equate(expressions, numbers, name, num ÷ number)
        elseif numberFirst
            return equate(expressions, numbers, name, number ÷ num)
        else
            return equate(expressions, numbers, name, num * number)
        end
    end

end