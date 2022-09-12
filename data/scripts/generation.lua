
ROOM_LAYOUTS = 2

function newDecoration(name, image, placingRules, frequency, distance, drawCall, custom)
    local decoration = {

        name = name,

        placingRules = placingRules,

        frequency = frequency,

        distance = distance,

        draw = drawCall

    }

    if image ~= nil then

        decoration.image = love.graphics.newImage(image)

    end

    for id, thing in pairs(custom) do decoration[id] = thing end

    return decoration
end

function decorateRoom(room)

    local roomDecorations = {foreground = {}, background = {}}

    for layerId, layer in pairs(DECORATIONS) do -- For all layers

        local roomLayer = roomDecorations[layerId]

        for id, decoration in pairs(layer) do -- For all decorations in layer

            local positionsPlaced = {}

            for tileX = 1, 16 do -- For every tile position

                for tileY = 1, 11 do

                    local tooClose = false

                    for _, pos in ipairs(positionsPlaced) do -- For every position placed, check if too close

                        if pos.x > tileX - decoration.distance[1] and pos.x < tileX + decoration.distance[1] and -- Too close?
                            pos.y > tileY - decoration.distance[2] and pos.y < tileY + decoration.distance[2]
                        then
 
                            tooClose = true

                        end

                    end

                    if not tooClose and love.math.random(0, 100) < decoration.frequency then -- Is it going to try to spawn?

                        local placable = true

                        for _, rule in ipairs(decoration.placingRules) do -- Check every rule to see if its placable here

                            if (room.tilemap:getTile(tileX + rule[1], tileY + rule[2]) == nil) == rule[3] then

                                placable = false

                            end

                        end

                        if placable then

                            local decorationAdding = deepcopyTable(decoration)

                            decorationAdding.x = tileX * 48 + 24
                            decorationAdding.y = tileY * 48 + 24 - room.y

                            decorationAdding.placingRules = nil
                            decorationAdding.frequency    = nil
                            decorationAdding.distance     = nil

                            table.insert(roomLayer, decorationAdding)

                            table.insert(positionsPlaced, newVec(tileX, tileY))
                            
                        end

                    end

                end

            end

        end

    end

    return roomDecorations

end

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

        if i ~= 1 and i ~= lastRoom then
            
            room.enemySpawns = generateRoomEnemies(room)

        end

        room.tilemap:buildColliders()

        room.decorations = decorateRoom(room)

        rooms[i] = room -- Append room

    end

    return rooms

end

ENEMY_SPAWN_PARTICLES = loadJson("data/graphics/particles/enemySpawn.json")

function generateRoomEnemies(room)
    enemySpawns = {}

    for i = 1, love.math.random(2, 3) do

        local enemy = newEnemy(ENEMIES_TO_GENERATE[love.math.random(1, #ENEMIES_TO_GENERATE)], 0, 0)

        local positionCorrect = false

        while not positionCorrect do

            enemy.pos.x = love.math.random(48, WS[1] - 48)
            enemy.pos.y = love.math.random(48, WS[2] - 48) - room.y

            positionCorrect = #checkCollisions(enemy.pos, room.tilemap.colliders) == 0

        end

        local spawner = newParticleSystem(enemy.pos.x, enemy.pos.y, deepcopyTable(ENEMY_SPAWN_PARTICLES))

        spawner.spawnTimer = 3
        spawner.enemy = enemy

        table.insert(enemySpawns, spawner)

    end

    return enemySpawns
end

-- Decoration drawing functions
function drawTorch(this)

    drawSprite(this.image, this.x, this.y)

    this.particles.x = this.x
    this.particles.y = this.y - 12
    this.particles:process()

end

DECORATIONS = {
background = {
    torch = newDecoration("torch", "data/graphics/images/decorations/torch.png", {{0, 0, false}, {0, 1, false}, {0, 2, true}}, 20, {2, 2}, drawTorch, {
        particles = newParticleSystem(0, 0, loadJson("data/graphics/particles/torch.json"))
    })
},
foreground = {

}
}