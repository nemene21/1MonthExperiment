
-- Table stuff

function elementIndex(table,element) -- returns an id of an element in a table, if its not in the table, returnes nil
    for id,E in pairs(table) do
        if E == element then return id end
    end

    return -1
end

function idInTable(table,id) return table[id] ~= nil end

function deepcopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopyTable(orig_key)] = deepcopyTable(orig_value)
        end
        setmetatable(copy, deepcopyTable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function wipeKill(kill,tableEditing)

    for i=#kill,1,-1 do
        table.remove(tableEditing,kill[i])
    end

    return tableEditing
end


-- Color 0-255 range functions (i just like it that way XD)

function clear(r,g,b,a) -- Clear but it uses 0-255
    a = a or 255
    local convert = 0.003921568627451
    love.graphics.clear(r * convert, g * convert, b * convert, a * convert)
end

function setColor(r,g,b,a) -- setColor but it uses 0-255
    a = a or 255
    local convert = 0.003921568627451
    love.graphics.setColor(r * convert, g * convert, b * convert, a * convert)
end

-- String stuff

function splitString(inputstr, sep)
    local sep = sep or "%s"
    
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function tablifyString(str)
    local tbl = {}
    for char in str:gmatch(".") do -- matches every character
        tbl[#tbl+1] = char
    end
    return tbl
end