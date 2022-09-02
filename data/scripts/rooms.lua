
ROOM_PRESETS = 0
ROOM_TILESET = newSpritesheet("data/graphics/images/tileset.png", 16, 16)

function newRoom(y)

    local room = {

        y = y,

        drawBg = drawRoomBg

    }

    local layout = love.math.random(1, ROOM_PRESETS + 1)

    room.bgTilemap = newTilemap(ROOM_TILESET, 48)

    for Tx=0, 16 do

        for Ty=0, 12 do

            local tileToPlace = math.floor(math.abs(love.math.noise(Tx * 0.1, Ty * 0.1)) * 3)

            room.bgTilemap:setTile(Tx, Ty, {1 + tileToPlace, 1})

        end

    end

    return room

end

function drawRoomBg(this)

    this.bgTilemap:draw()

end