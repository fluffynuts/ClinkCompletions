function find_file_upward(search)
    local depth = 0
    -- search up to 32 folders upward
    while depth < 32 do
        local fp = io.open(search, 'r')
        if fp ~= nil then
            fp.close()
            return search
        end
        search = '../'..search
        depth = depth + 1
    end
    return nil
end

function split(inputstr, sep)
    local t = {} 
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function trim(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function len(obj)
    if type(obj) == 'string' then
        return obj:len()
    end
    if type(obj) ~= 'table' then
        return nil
    end
    i = 0
    while obj[i] ~= nil do
        i = i + 1
    end
    return i - 1
end

function last(arr)
    -- find the last element in a table
    --  allow for zero- or one- indexed because, well, it seems that the
    --  lua community has this crazy one-indexed fetish
    local i = 0
    while arr[i] == nil do
        i = i + 1
    end
    while arr[i] ~= nil do
        i = i + 1
    end
    return arr[i-1]
end

function get_last_modified_for(path)
    if path == nil then
        return 0
    end
    local fp = io.popen('stat -c %Y '..path)
    if fp == nil then 
        return 0 
    end
    return tonumber(fp:read('*a'))
end
