
-- Tile functions
function getTilemapTile(tilemap,x,y) return tilemap.tiles[tostring(x)..","..tostring(y)] end

function setTilemapTile(tilemap,x,y,tile) tilemap.tiles[tostring(x)..","..tostring(y)] = tile end

function removeTilemapTile(tilemap,x,y) tilemap.tiles[tostring(x)..","..tostring(y)] = nil end

-- Drawing
function drawTilemap(tilemap)

    for id,T in pairs(tilemap.tiles) do
        local pos = splitString(id,",")
        local tileX = tonumber(pos[1]); local tileY = tonumber(pos[2])

        local pos = newVec(tileX*tilemap.tileSize - tilemap.offset.x, tileY*tilemap.tileSize- tilemap.offset.y)

        if pos.x - camera[1] >= -48 and pos.x - camera[1] <= 848 and pos.y - camera[2] >= -48 and pos.y - camera[2] <= 648 then
        
            drawFrame(tilemap.sheet,T[1],T[2],pos.x, pos.y)

        end
    end

end

-- Build colliders (goes trough all tiles, places a collider on them in the tilemap.collided if they dont have a neightbour somewhere)
function buildTilemapColliders(tilemap)
    tilemap.colliders = {}

    for id,T in pairs(tilemap.tiles) do
        local pos = splitString(id,",")
        local tileX = tonumber(pos[1]); local tileY = tonumber(pos[2])

        place = tilemap.tiles[tostring(tileX - 1)..","..tostring(tileY)] == nil or tilemap.tiles[tostring(tileX + 1)..","..tostring(tileY)] == nil or
                tilemap.tiles[tostring(tileX)..","..tostring(tileY - 1)] == nil or tilemap.tiles[tostring(tileX)..","..tostring(tileY + 1)] == nil

        if place then
            local rect = newRect(tileX * tilemap.tileSize + tilemap.tileSize * 0.5 + tilemap.offset.x, tileY * tilemap.tileSize + tilemap.tileSize * 0.5 - tilemap.offset.y, tilemap.tileSize, tilemap.tileSize)
            table.insert(tilemap.colliders,rect)
        end
    end
end

function buildTilemapCollidersBad(tilemap)
    tilemap.colliders = {}

    for id,T in pairs(tilemap.tiles) do
        local pos = splitString(id,",")
        local tileX = tonumber(pos[1]); local tileY = tonumber(pos[2])

        local rect = newRect(tileX * tilemap.tileSize + tilemap.tileSize * 0.5 + tilemap.offset.x, tileY * tilemap.tileSize + tilemap.tileSize * 0.5 - tilemap.offset.y, tilemap.tileSize, tilemap.tileSize)
        table.insert(tilemap.colliders, rect)
    end
end

-- New tilemap
function newTilemap(texture,tileSize,tiles, offset)
    local tilemap = {
        tiles=tiles or {},
        tileSize=tileSize,
        sheet=texture,

        getTile=getTilemapTile,
        setTile=setTilemapTile,
        removeTile=removeTilemapTile,
        draw=drawTilemap,

        offset = offset,

        colliders={},
        buildColliders=buildTilemapColliders,
        buildCollidersBad=buildTilemapCollidersBad
    }

    return tilemap
end