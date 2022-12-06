function part1(filename)
    solve(filename, 4)
end

function part2(filename)
    solve(filename, 14)
end

function solve(filename, c)

    f = open(filename)
    lines = readlines(f)

    score = ""
    for line in lines
        for i = c:length(line)
            ok = true
            for j = i-c+1:i-1, k = j+1:i
                if line[j] == line[k]
                    ok = false
                    break
                end
            end
            if ok
                score *= string(i) * " "
                break
            end
        end
    end
    strip(score)
end
