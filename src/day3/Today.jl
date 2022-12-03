
function part1(filename)

    f = open(filename)
    lines = readlines(f)

    score = 0
    for line in lines
        len = length(line) ÷ 2
        for i = 1:len, j = 1:len
            if line[i] == line[j+len]
                score += prio(codeunit(line, i))
                break
            end
        end
    end

    score
end

function part2(filename)

    f = open(filename)

    score = 0
    while true
        line1 = readline(f)
        line2 = readline(f)
        line3 = readline(f)
        len1 = length(line1)
        len2 = length(line2)
        len3 = length(line3)
        if (len1 + len2 + len3 == 0)
            break
        end
        for i = 1:len1, j = 1:len2, k = 1:len3
            if line1[i] == line2[j] == line3[k]
                score += prio(codeunit(line1, i))
                break
            end
        end
    end

    score

end

function prio(cu)
    prio = cu - 38
    if (prio > 52)
        prio -= 58
    end
    prio
end