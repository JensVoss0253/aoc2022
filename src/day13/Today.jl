function part1(filename)

    lists = getLists(filename)

    score = 0
    for i = 1:length(lists[1])
        if compareLists(lists[1][i], lists[2][i]) < 0
            score += i
        end
    end
    score

end

function part2(filename)

    lists = getLists(filename)
    allLists = vcat(lists[1], lists[2])
    push!(allLists,[[2]])
    push!(allLists,[[6]])

    sort!(allLists, lt = (x, y) -> compareLists(x, y) < 0)

    score = 1
    for i = 1:length(allLists)
        if allLists[i] == [[2]] || allLists[i] == [[6]]
            score *= i
        end
    end
    score
end


function getLists(filename)
    f = open(filename)
    lines = readlines(f)
    lists = [[], []]
    for i = 1:3:length(lines)
        push!(lists[1], eval(Meta.parse(lines[i])))
        push!(lists[2], eval(Meta.parse(lines[i+1])))
    end
    lists
end

function compareLists(list1, list2)::Int
    len = min(length(list1), length(list2))
    for i = 1:len
        c = compareItems(list1[i], list2[i])
        if  c != 0
            return c
        end
    end
    if len < length(list1)
        return 1
    elseif len < length(list2)
        return -1
    else
        return 0
    end
end

function compareItems(item1, item2)::Int
    if typeof(item1) <: Number
        if typeof(item2) <: Number
            return item1 - item2
        else
            return compareLists([item1], item2)
        end
    else
        if typeof(item2) <: Number
            return compareLists(item1, [item2])
        else
            return compareLists(item1, item2)
        end
    end
end