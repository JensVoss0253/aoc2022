# global variables
old::Int128 = 0
product::Int128 = 1

mutable struct item
    worry::Int128
end

mutable struct monkey
    items
    op
    modulus
    success
    failure
    inspections
    monkey() = new([], undef, 0, 0, 0, 0)
end

function part1(filename)
    monkeys = getMonkeys(filename)
    solve(monkeys, strategy1, 20)
end

function part2(filename)
    monkeys = getMonkeys(filename)
    for monkey in monkeys
        global product *= monkey.modulus
    end
    solve(monkeys, strategy2, 10000)
end

function solve(monkeys, strategy, rounds)

    for round = 1:rounds
        for monkey in monkeys
            for item in monkey.items
                global old = item.worry
                item.worry = strategy(monkey)
                nextIdx = (item.worry % monkey.modulus) == 0 ? monkey.success : monkey.failure
                push!(monkeys[nextIdx].items, item)
                monkey.inspections += 1
            end
            monkey.items = []
        end
    end

    inspections = sort(map(m -> m.inspections, monkeys), rev=true)
    inspections[1] * inspections[2]

end

function getMonkeys(filename)

    monkeys = []

    f = open(filename)
    lines = readlines(f)

    for line in lines
        if startswith(line, "Monkey")
            push!(monkeys, monkey())
        elseif startswith(line, "  Starting items: ")
            for i in split(SubString(line, 19), ",")
                push!(monkeys[end].items, item(parse(Int128, strip(i))))
            end
        elseif startswith(line, "  Operation: new = ")
            monkeys[end].op = Meta.parse(SubString(line, 20))
        elseif startswith(line, "  Test: divisible by ")
            monkeys[end].modulus = parse(Int128, strip(SubString(line, 22)))
        elseif startswith(line, "    If true: throw to monkey ")
            monkeys[end].success = parse(Int128, strip(SubString(line, 30))) + 1
        elseif startswith(line, "    If false: throw to monkey ")
            monkeys[end].failure = parse(Int128, strip(SubString(line, 31))) + 1
        end
    end

    monkeys

end

function strategy1(monkey)
    eval(monkey.op) ÷ 3
end

function strategy2(monkey)
    eval(monkey.op) % product
end