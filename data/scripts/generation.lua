
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

        if i ~= 1 and i ~= lastRoom then
            
            room.enemySpawns = generateRoomEnemies(room)

        end

        room.tilemap:buildColliders()

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
