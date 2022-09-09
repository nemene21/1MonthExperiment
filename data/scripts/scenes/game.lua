
function gameReload()

    player = newPlayer(400, 300)

    rooms = generate()

    BACKGROUND = love.graphics.newCanvas(WS[1], WS[2])
    FOREGROUND = love.graphics.newCanvas(WS[1], WS[2])

    ROOM_BLOCKAGE_MESH = love.graphics.newMesh({{0, 0, 0, 0, 1, 1, 1, 1}, {WS[1], 0, 1, 0, 1, 1, 1, 1}, {WS[1], 44, 1, 1, 1, 1, 1, 1}, {0, 44, 0, 1, 1, 1, 1, 1}}, "fan", "dynamic")
    blockageAnim = 0

    playerBullets = {}

    ROOM_IN = rooms[1]

    particleSystems = {}
    PLAYER_BULLET_HIT_PARTICLES = loadJson("data/graphics/particles/playerBulletHit.json")

    enemyBodies = {}
    ENEMY_DIE_PARTICLES = loadJson("data/graphics/particles/enemyKilled.json")
    
end

function gameDie()
    
end

function game()
    
    -- Reset
    sceneAt = "game"
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    love.graphics.setCanvas(BACKGROUND)
    clear(255, 157, 129)

    for id, room in ipairs(rooms) do room:drawBg() end -- Draw room background

    love.graphics.setCanvas(FOREGROUND)
    clear(0, 0, 0, 0)

    local kill = {}
    for id, bullet in ipairs(playerBullets) do -- Process player bullets

        bullet.x = bullet.x + bullet.vel.x * dt
        bullet.y = bullet.y + bullet.vel.y * dt

        bullet:process()

        local enemyHit = false
        for _, enemy in ipairs(ROOM_IN.enemies) do

            if rectCollidingCircle(enemy.pos, bullet.x, bullet.y, 18) and not enemyHit then

                local knockback = newVec(player.stats.shootKnockback, 0)
                knockback:rotate(bullet.vel:getRot())

                enemy:hit(player.stats.shootDamage, knockback)
                enemyHit = true

                particles = newParticleSystem(bullet.x, bullet.y, deepcopyTable(PLAYER_BULLET_HIT_PARTICLES))
                particles.rotation = knockback:getRot() + 90

            end

        end

        if rooms[roomAt].tilemap:getTile(math.floor((bullet.x + rooms[roomAt].tilemap.offset.x) / 48), math.floor((bullet.y + rooms[roomAt].tilemap.offset.y) / 48)) ~= nil or enemyHit then

            table.insert(kill, id)

            shock(bullet.x, bullet.y, 0.075, 0.03, 0.2)

            bullet.spawning = false
            table.insert(particleSystems, bullet)

        end

    end playerBullets = wipeKill(kill, playerBullets)

    setColor(255, 255, 255)

    if #ROOM_IN.enemies == 0 then roomAt = math.floor(- player.pos.y / WS[2] + 2) end -- Set room at and bind the camera
    ROOM_IN = rooms[roomAt]
    bindCamera(WS[1] * 0.5, - ((roomAt - 2) * WS[2] + WS[2] * 0.5), 1)

    player:process()

    local kill = {}
    for id, enemy in ipairs(rooms[roomAt].enemies) do -- Process and draw the enemies

        enemy:process()
        enemy:draw()

        if enemy.hp < 0 then

            table.insert(kill, id)
            table.insert(enemyBodies, {

                x = enemy.pos.x,
                y = enemy.pos.y,

                time = 0.4, timeMax = 0.4,

                vel = newVec(300, 0):rotate(enemy.knockback:getRot()),

                image = enemy.image

            })

            local particles = newParticleSystem(enemy.pos.x, enemy.pos.y, deepcopyTable(ENEMY_DIE_PARTICLES))

            particles.rotation = enemy.knockback:getRot()

            table.insert(particleSystems, particles)

        end

    end rooms[roomAt].enemies = wipeKill(kill, rooms[roomAt].enemies)

    local kill = {}
    for id, body in ipairs(enemyBodies) do -- Process and draw the enemy bodies

        body.x = body.x + body.vel.x * dt
        body.y = body.y + body.vel.y * dt

        body.time = body.time - dt

        local anim = body.time / body.timeMax

        flash(1)
        drawSprite(body.image, body.x, body.y, anim, anim)
        resetShader()

        if body.time < 0 then

            table.insert(kill, id)

        end

    end enemyBodies = wipeKill(kill, enemyBodies)

    player:draw()

    for id, room in ipairs(rooms) do room:drawFg() end -- Draw room foreground

    local kill = {}                                            -- Draw particles
    for id,P in ipairs(particleSystems) do
        P:process()

        if #P.particles == 0 and P.ticks == 0 and P.timer < 0 then table.insert(kill,id) end

    end particleSystems = wipeKill(kill,particleSystems)

    setColor(255, 255, 255)

    love.graphics.setCanvas(display) -- Draw bg and fg on the display

    love.graphics.draw(BACKGROUND)

    love.graphics.setShader(SHADERS.SHADOW)
    love.graphics.draw(FOREGROUND, -8, 8)
    love.graphics.setShader()

    love.window.setTitle(love.timer.getFPS())

    love.graphics.draw(FOREGROUND)

    if #rooms[roomAt].enemies ~= 0 then -- Process doors

        blockageAnim = clamp(blockageAnim + dt * 4, 0, 1)

        if player.pos.y < - rooms[roomAt].y then
 
            player.pos.y = player.pos.y - player.vel.y * dt

            player.vel.y = player.vel.y * - 0.8

        end

        if player.pos.y > - rooms[roomAt].y + WS[2] then

            player.pos.y = player.pos.y - player.vel.y * dt

            player.vel.y = player.vel.y * - 0.8

        end

        player.pos.y = clamp(player.pos.y, - rooms[roomAt].y, - rooms[roomAt].y + WS[2])

    else

        blockageAnim = clamp(blockageAnim - dt * 4, 0, 1)

    end

    if blockageAnim ~= 0 then -- Draw doors

        love.graphics.setShader(SHADERS.ROOM_BLOCKAGE)
        SHADERS.ROOM_BLOCKAGE:send("time", globalTimer)

        love.graphics.draw(ROOM_BLOCKAGE_MESH, 0, - 80 + 80 * blockageAnim)
        love.graphics.draw(ROOM_BLOCKAGE_MESH, 0, WS[2] + 80 - 80 * blockageAnim, 0, 1, -1)
        love.graphics.setShader()

    end

    drawEveryIndicator()

    -- Return scene
    return sceneAt
end