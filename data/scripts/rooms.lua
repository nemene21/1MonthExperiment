
ROOM_TILESET = newSpritesheet("data/graphics/images/tileset.png", 16, 16)

function newRoom(y, layout)

    local room = {

        y = y,

        drawBg = drawRoomBg

    }

    room.bgTilemap = newTilemap(ROOM_TILESET, 48) -- Background

    for Tx=0, 16 do

        for Ty=0, 12 do

            local tileToPlace = math.floor(math.abs(love.math.noise(Tx * 0.1, Ty * 0.1)) * 3)

            room.bgTilemap:setTile(Tx, Ty, {1 + tileToPlace, 1})

        end

    end

    room.tilemap = newTilemap(ROOM_TILESET, 48, layout) -- Foreground
    room.tilemap.buildColliders()

    return room

end

function drawRoomBg(this)

    this.bgTilemap:draw()

end