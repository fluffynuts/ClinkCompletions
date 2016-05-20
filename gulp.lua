local Gulp = {}
Gulp.last_gulp_modified = 0
Gulp.cached_gulp_tasks = {}

Gulp.find_gulpfile = function()
    return find_file_upward('gulpfile.js')
end

Gulp.erase = function(message)
    local messageLen = len(message)
    for i=1,messageLen do
        io.write("\b")
    end
    for i=1,messageLen do
        io.write(" ")
    end
    for i=1,messageLen do
        io.write("\b")
    end
end

Gulp.quick_find_tasks = function()
    local gulpfile = Gulp.find_gulpfile()
    if gulpfile == nil then
        return {}
    end
    local last_modified = get_last_modified_for(gulpfile)
    if last_modified ~= 0 and Gulp.last_gulp_modified ~= 0 then
        if last_modified == Gulp.last_gulp_modified then
            return Gulp.cached_gulp_tasks
        end
    end
    return nil
end

Gulp.set_cache_marker = function()
    local gulpfile = Gulp.find_gulpfile()
    Gulp.last_gulp_modified = get_last_modified_for(gulpfile)
end

Gulp.get_gulp_tasks_lines = function(message)
    local file = io.popen("gulp --tasks")
    if file == nil then
        return nil
    end
    io.write(message)
    local data = file:read("*a")
    file.close()
    return split(data, "\n")
end

Gulp.get_completions_from = function(lines)
    local i = 1
    local line = lines[i]
    local result = {}
    local j = 1
    while line ~= nil do
        local parts = split(line, " ")
        -- skip console.logs (gulp output has a date prefix)
        local skip = string.sub(line, 1, 1) ~= '['
        for k,part in pairs(parts) do
            -- skip the lines about using and tasks
            if part == "Using" or part == "Tasks" then
                skip = true
                break
            end
        end
        if not skip then
            local lastpart = last(parts)
            result[j] = lastpart
            j = j + 1
        end
        i = i + 1
        line = lines[i]
    end
    return result
end

Gulp.get_gulp_tasks = function()
    local quick = Gulp.quick_find_tasks()
    if quick ~= nil then
        return quick
    end
    Gulp.set_cache_marker()
    local message = " (retrieving tasks... please wait...)"
    local lines = Gulp.get_gulp_tasks_lines(message)
    if lines == nil then
        return { "(no global gulp found; try npm install -g gulp)" }
    end
    local result = Gulp.get_completions_from(lines)
    Gulp.erase(message)
    Gulp.cached_gulp_tasks = result
    return result
end
gulp_parser = clink.arg.new_parser():set_arguments({ Gulp.get_gulp_tasks })
clink.arg.register_parser("gulp", gulp_parser)

