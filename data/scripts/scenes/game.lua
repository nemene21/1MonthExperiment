
function gameReload()

    player = newPlayer(400, 300)

    rooms = generate()

    BACKGROUND = love.graphics.newCanvas(WS[1], WS[2])
    FOREGROUND = love.graphics.newCanvas(WS[1], WS[2])

    playerBullets = {}
    
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

    for id, room in ipairs(rooms) do room:drawBg() end

    love.graphics.setCanvas(FOREGROUND)
    clear(0, 0, 0, 0)

    for id, bullet in ipairs(playerBullets) do

        bullet.x = bullet.x + bullet.vel.x * dt
        bullet.y = bullet.y + bullet.vel.y * dt

        bullet:process()

    end

    player:process()
    player:draw()

    for id, room in ipairs(rooms) do room:drawFg() end

    love.graphics.setCanvas(display)

    love.graphics.draw(BACKGROUND)

    love.graphics.setShader(SHADERS.SHADOW)
    love.graphics.draw(FOREGROUND, -8, 8)
    love.graphics.setShader()

    love.graphics.draw(FOREGROUND)

    shock(400, 300, 0.5, 0.1, 0.5)

    -- Return scene
    return sceneAt
end