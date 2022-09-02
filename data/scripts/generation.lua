
ROOM_LAYOUTS = 1

function generate()

    local rooms = {}
    roomAt = 0

    for i=1, love.math.random(4, 5) do

        local layout = loadJson("data/levels/level"..tostring(love.math.random(1, ROOM_LAYOUTS))..".json")

        local room   = newRoom((i - 1) * WS[2], layout)

        table.insert(rooms, room)

    end

    return rooms

end
