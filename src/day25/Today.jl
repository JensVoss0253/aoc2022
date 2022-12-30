function part1(filename)
    f = open(filename)
    lines = readlines(f)

    sum = 0
    for line in lines
        num = 0
        for c in line
            num *= 5
            if c == '2'
                num += 2
            elseif c == '1'
                num += 1
            elseif c == '-'
                num -= 1
            elseif c == '='
                num -= 2
            end
        end
        sum += num
    end

    score = ""
    while true
        if sum == 0
            break
        end
        m = sum % 5
        if m == 0
            score = "0" * score
            sum = sum ÷ 5
        elseif m == 1
            score = "1" * score
            sum = (sum - 1) ÷ 5
        elseif m == 2
            score = "2" * score
            sum = (sum - 2) ÷ 5
        elseif m == 3
            score = "=" * score
            sum = (sum + 2) ÷ 5
        elseif m == 4
            score = "-" * score
            sum = (sum + 1) ÷ 5
        end
    end
    score
end
    
function part2(filename)
    f = open(filename)
    lines = readlines(f)

    score = 0
    score
end
