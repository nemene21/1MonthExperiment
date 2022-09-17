
function menuReload()

    PLAY = newButton(WS[1] * 0.5, WS[2] * 0.3 + 96, "Play", 1)
    OPTIONS = newButton(WS[1] * 0.5, WS[2] * 0.5 + 96, "Options", -1)
    QUIT = newButton(WS[1] * 0.5, WS[2] * 0.7 + 96, "Quit", 1)

    playPressed = false
    playAnimation = 0
    
end

function menuDie()

end

function menu()
    -- Reset
    sceneAt = "menu"
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    SHADERS.BUTTON:send("time", globalTimer)

    SHADERS.BUTTON:send("image", buttonBg)

    PLAY:process()
    PLAY:draw()

    if PLAY.pressed then
        playPressed = true
    end

    if playPressed then

        playAnimation = playAnimation + dt
        transition = playAnimation

        if playAnimation > 1 then sceneAt = "game" end

    end

    SHADERS.BUTTON:send("image", buttonBg3)

    OPTIONS:process()
    OPTIONS:draw()

    SHADERS.BUTTON:send("image", buttonBg2)

    QUIT:process()
    QUIT:draw()

    if QUIT.pressed then love.event.quit() end

    -- Return scene
    return sceneAt
end