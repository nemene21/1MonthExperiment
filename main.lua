
-- All global values used in all scenes (display, textures, options, etc.)
function love.load()
    -- Get screenRes
    screenRes = {love.graphics.getWidth(),love.graphics.getHeight()}

    -- Window and defaulting
    globalTimer = 0; love.graphics.setDefaultFilter("nearest","nearest")

    fullscreen = false; title = "Ne_mene´s Framework"

    WS = {768,576}; wFlags = {resizable=true}
    aspectRatio = {WS[1]/WS[2],WS[2]/WS[1]}
    love.graphics.setBackgroundColor(0,0,0,1); love.window.setMode(WS[1],WS[2],wFlags); display = love.graphics.newCanvas(WS[1],WS[2]); displayScale = 1
    postProCanvas = love.graphics.newCanvas(WS[1],WS[2])

    love.window.setTitle(title.."                   [F1 for fullscreen]")

    -- Imports
    require "init"

    scenes[scene][2]()

    -- Mouse
    --love.mouse.setVisible(false)
    mouseMode = "pointer"
    mouse = {["pointer"] = love.graphics.newImage("data/graphics/images/mouse/pointer.png")}
    mouseOffset = {0,0}

    -- Set joysticks
    JOYSTICKS = love.joystick.getJoysticks()
    JOYSTICK_LAST_PRESSES = {}
    for id,J in pairs(JOYSTICKS) do JOYSTICK_LAST_PRESSES[id] = "none" end

    -- Transitions
    transition = 1

    TIME_SCALE = 1
end

-- Play scenes
function love.draw()

    processTextParticles()

    -- Time and resetting
    rawDt = love.timer.getDelta()

    dt = clamp(rawDt, 0, 1 / 30) * TIME_SCALE

    globalTimer = globalTimer + dt
    
    -- Mouse pos
    xM, yM = love.mouse.getPosition()

    w, h = love.graphics.getDimensions()
    dw, dh = display:getDimensions()

    xM = clamp(xM,w*0.5-dw*0.5*displayScale,w*0.5+dw*0.5*displayScale)
    yM = clamp(yM,h*0.5-dh*0.5*displayScale,h*0.5+dh*0.5*displayScale)
    xM = xM - (w*0.5-dw*0.5*displayScale)
    yM = yM - (h*0.5-dh*0.5*displayScale)
    xM = xM/displayScale; yM = yM/displayScale

    -- Bg and canvas resetting
    love.graphics.setColor(1,1,1,1); love.graphics.setCanvas(display)
    love.graphics.clear(0,0,0,1)

    --------------------------------------------------------------------------SCENE CALLED
    processCamera()
    processShockwaves()

    love.graphics.setShader()

    transition = clamp(transition - dt,0,1)

    sceneNew = scenes[scene][1]()

    if sceneNew ~= scene then
        scenes[scene][3]()
        scene = sceneNew; scenes[scene][2]()
        transition = 1
    end

    processAllLights()

    -- Mouse
    -- love.graphics.setColor(1,1,1,1)
    -- love.graphics.draw(mouse[mouseMode],xM,yM,0,SPRSCL,SPRSCL)

    -- Post processing
    love.graphics.setShader(SHADERS.POST_PROCESS)

    -- Draw display
    setColor(255 * (1 - transition), 255 * (1 - transition), 255 * (1 - transition))

    love.graphics.setCanvas()

    love.graphics.draw(display, w * 0.5 - dw * 0.5 * displayScale - screenshake[1] * displayScale, h * 0.5 - dh * 0.5 * displayScale - screenshake[2] * displayScale, 0, displayScale, displayScale)

    -- Check for fullscreen
    if justPressed("f1") then changeFullscreen() end

    -- Reset input
    lastKeyPressed = "none"; lastMouseButtonPressed = -1
    for id,J in pairs(JOYSTICKS) do JOYSTICK_LAST_PRESSES[id] = "none" end
end

-- Display resizing
function love.resize(w, h)
    displayScale = math.min(w/WS[1], h/WS[2])

    love.graphics.setCanvas(display)
    love.graphics.scale(zoom)
end

function changeFullscreen()
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen)
    if fullscreen == false then
        love.window.width = WS[1]; love.window.height = WS[2]; displayScale = 1
    end
end

-- Keyboard
function love.keypressed(k) setJustPressed(k) end

-- Mouse
function love.mousepressed(x,y,button) setMouseJustPressed(button) end

-- Joysticks
function love.joystickadded(joystick) table.insert(JOYSTICKS,joystick); table.insert(JOYSTICK_LAST_PRESSES,"none") end

function love.joystickremoved(joystick)
    id = elementIndex(JOYSTICKS,joystick)
    table.remove(JOYSTICKS,id); table.remove(JOYSTICK_LAST_PRESSES,id)
end

function love.joystickpressed(joystick,button)
    id = elementIndex(JOYSTICKS,joystick)
    JOYSTICK_LAST_PRESSES[id] = button
end