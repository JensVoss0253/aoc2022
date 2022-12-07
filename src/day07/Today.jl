
function part1(filename)
    eval1(getFileSystem(filename))
end

function part2(filename)
    root = getFileSystem(filename)
    score = totalSize(root)
    target = score - 40000000
    eval2(root, target, score)
end

struct File
    name::String
    size::Int64
end

struct Dir
    name::String
    parent::Union{Dir,Nothing}
    dirs::Dict{String,Dir}
    files::Dict{String,File}
end

function totalSize(dir::Dir)::Int64
    sum = 0
    for subdir in values(dir.dirs)
        sum += totalSize(subdir)
    end
    for file in values(dir.files)
        sum += file.size
    end
    sum
end

function getFileSystem(filename)

    f = open(filename)
    lines = readlines(f)

    root::Dir = Dir("", nothing, Dict(), Dict())
    current::Dir = root
    for line in lines
        if line == "\$ cd /"
            current = root
        elseif line == "\$ ls"
            # nada
        elseif startswith(line, "\$ cd ")
            name = SubString(line, 6)
            current = name == ".." ? current.parent : current.dirs[name]
        elseif startswith(line, "dir ")
            name = SubString(line, 5)
            current.dirs[name] = Dir(name, current, Dict(), Dict())
        else # i.e. if a file is listed
            parts = split(line, " ")
            size = parse(Int64, parts[1])
            name = parts[2]
            current.files[name] = File(name, size)
        end
    end

    root

end

function eval1(dir::Dir)
    score = 0
    size = totalSize(dir)
    if size <= 100000
        score += size
    end
    for subdir in values(dir.dirs)
        score += eval1(subdir)
    end
    score
end

function eval2(dir::Dir, target, currentScore)
    size = totalSize(dir)
    score = currentScore
    if size > target
        score = min(score, size)
        for subdir in values(dir.dirs)
            score = eval2(subdir, target, score)
        end
    end
    score
end

