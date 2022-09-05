
ROOM_LAYOUTS = 2

function generate()

    local rooms = {}
    roomAt = 1

    local lastRoom = 5

    for i=1, lastRoom do

        local layout = nil -- Layout

        if i == 1 then

            layout = loadJson("data/levels/first.json")

        else if i == lastRoom then

            layout = loadJson("data/levels/last.json")

        else

            layout = loadJson("data/levels/level"..tostring(love.math.random(1, ROOM_LAYOUTS))..".json")

        end end

        local yOffset = (i - 1) * WS[2]

        local room   = newRoom(yOffset, layout) -- Room built

        room.enemies = {newEnemy("slime", 400, 300 - yOffset)}

        

        rooms[i] = room -- Append room

    end

    return rooms

end