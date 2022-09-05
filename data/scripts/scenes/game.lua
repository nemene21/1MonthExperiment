
function gameReload()

    player = newPlayer(400, 300)

    rooms = generate()

    BACKGROUND = love.graphics.newCanvas(WS[1], WS[2])
    FOREGROUND = love.graphics.newCanvas(WS[1], WS[2])

    playerBullets = {}

    ROOM_IN = rooms[1]
    
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

    for id, bullet in ipairs(playerBullets) do -- Process player bullets

        bullet.x = bullet.x + bullet.vel.x * dt
        bullet.y = bullet.y + bullet.vel.y * dt

        bullet:process()

    end

    player:process()

    local kill = {}
    for id, enemy in ipairs(rooms[roomAt].enemies) do

        enemy:process()
        enemy:draw()

    end rooms[roomAt].enemies = wipeKill(kill, rooms[roomAt].enemies)

    player:draw()

    roomAt = math.floor(- player.pos.y / WS[2] + 2) -- Set room at and bind the camera
    ROOM_IN = rooms[roomAt]
    bindCamera(WS[1] * 0.5, - ((roomAt - 2) * WS[2] + WS[2] * 0.5), 1)

    for id, room in ipairs(rooms) do room:drawFg() end -- Draw room foreground

    love.graphics.setCanvas(display) -- Draw bg and fg on the display

    love.graphics.draw(BACKGROUND)

    love.graphics.setShader(SHADERS.SHADOW)
    love.graphics.draw(FOREGROUND, -8, 8)
    love.graphics.setShader()

    love.window.setTitle(love.timer.getFPS())

    love.graphics.draw(FOREGROUND)

    -- Return scene
    return sceneAt
end