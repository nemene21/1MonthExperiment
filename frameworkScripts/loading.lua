function loadJson(path)
    local file = love.filesystem.read(path)
    return json.decode(file)
end

function saveJson(path,tableConverting)
    local data = json.encode(tableConverting)
    print(data)
    s,m = love.filesystem.write(path,data)
    print(m)
end