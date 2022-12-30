struct Config
    sx::Int32
    sy::Int32
    bx::Int32
    by::Int32
    d::Int32
end

const configs::Array{Config} = []

function initConfigs(filename)

    global configs

    f = open(filename)
    lines = readlines(f)
    
    minX = maxX = 0
    for line in lines
        sx, sy, bx, by = map(x -> parse(Int, x), match(r"Sensor at x=(.*), y=(.*): closest beacon is at x=(.*), y=(.*)", line))
        d = abs(sx - bx) + abs(sy - by)
        push!(configs, Config(sx, sy, bx, by, d))
        minX = min(minX, sx - d)
        maxX = max(maxX, sx + d)
    end

    (minX, maxX)
end

function isBeaconFree(x, y, respectKnown::Bool)::Bool
    global configs
    for config in configs
        if respectKnown && x == config.bx && y == config.by
            return false
        end
        d = abs(config.sx - x) + abs(config.sy - y)
        if d <= config.d
            return true
        end
    end
    return false
end

function part1(filename, row)

    minX, maxX = initConfigs(filename)
    score = 0
    for x = minX:maxX
        if isBeaconFree(x, row, true)
            score += 1
        end
    end
    score
end

function part2(filename, max)
    global configs
    initConfigs(filename)
    for config in configs
        for i = -config.d - 1:config.d + 1
            x = config.sx + i
            for y in [config.sy - config.d - 1 + abs(i), config.sy + config.d + 1 - abs(i)]
                if 0 <= x <= max && 0 <= y <= max && !isBeaconFree(x, y, false)
                    return 4000000 * x + y
                end
            end
        end
    end
end