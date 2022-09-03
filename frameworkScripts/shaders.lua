-------- INIT SHADERS --------

SHADERS = {
    POST_PROCESS = love.graphics.newShader((love.filesystem.read("data/scripts/shaders/POST_PROCESS.fs"))),
    FLASH = love.graphics.newShader((love.filesystem.read("data/scripts/shaders/FLASH.fs"))),
    EMPTY = love.graphics.newShader((love.filesystem.read("data/scripts/shaders/EMPTY.fs"))),
    PLAYER = love.graphics.newShader((love.filesystem.read("data/scripts/shaders/PLAYER.fs"))),
    SHADOW = love.graphics.newShader((love.filesystem.read("data/scripts/shaders/SHADOW.fs")))
}

SHADERS.POST_PROCESS:send("vignetteMask",love.graphics.newImage("data/graphics/images/shaderMasks/vignette.png"))
SHADERS.POST_PROCESS:send("xRatio", WS[2] / WS[1])

---------- SPECIFIC SHADER FUNCTIONS

lightImage = love.graphics.newCanvas(WS[1],WS[2])                     --                LIGHTS
ambientLight = {255,255,255}

LIGHT_ROUND = love.graphics.newImage("data/graphics/images/roundLight.png")

lights = {}

function newNoiseTexture(w, h, zoom, seed)

    local zoom = zoom or 1
    local seed = seed or love.math.random(0, 1000000)

    local noiseTexture = love.graphics.newCanvas(w, h)

    love.graphics.setCanvas(noiseTexture)

    for x = 0, w do

        for y = 0, h do

            local noise = math.abs(love.math.noise(x * zoom, y * zoom, seed))

            love.graphics.setColor(noise, noise, noise)

            love.graphics.points(x, y)

        end

    end

    love.graphics.setCanvas()

    return noiseTexture

end

function shine(x, y, r, color)

    table.insert(lights, {x, y, r, color})

end

function processAllLights()

    love.graphics.setCanvas(lightImage)

    love.graphics.setShader()

    clear(ambientLight[1], ambientLight[2], ambientLight[3])

    for id, L in ipairs(lights) do

        drawLight(L[1], L[2], L[3], L[4])

    end

    SHADERS.POST_PROCESS:send("lightImage", lightImage); lights = {}

end

function drawLight(x, y, r, color)

    local color = color or {255, 255, 255, 255}

    local alpha = color[4] or 255

    setColor(color[1], color[2], color[3], alpha * 0.5)

    love.graphics.draw(LIGHT_ROUND, x - camera[1], y - camera[2], 0, r / 300, r / 300, LIGHT_ROUND:getWidth() * 0.5, LIGHT_ROUND:getHeight() * 0.5)

end

function flash(intensity)          --           FLASHES

    SHADERS.FLASH:send("intensity", intensity or 1)
    love.graphics.setShader(SHADERS.FLASH)
    
end

function resetShader() love.graphics.setShader() end

--                            SHOCKWAVES
SHOCKWAVES = {}

function processShockwaves()
    
    local kill = {}

    for id, shockwave in ipairs(SHOCKWAVES) do

        shockwave.lifetime = shockwave.lifetime - dt

        local idC = id - 1

        SHADERS.POST_PROCESS:send("shockwaves[" .. tostring(idC) .. "].lifetime", shockwave.lifetime)

        SHADERS.POST_PROCESS:send("shockwaves[" .. tostring(idC) .. "].lifetimeMax", shockwave.lifetimeMax)

        SHADERS.POST_PROCESS:send("shockwaves[" .. tostring(idC) .. "].force", shockwave.force)

        SHADERS.POST_PROCESS:send("shockwaves[" .. tostring(idC) .. "].position", {shockwave.position[1], shockwave.position[2]})
        
        SHADERS.POST_PROCESS:send("shockwaves[" .. tostring(idC) .. "].size", shockwave.size)

        if shockwave.lifetime < 0 then

            table.insert(kill, id)

        end

    end SHOCKWAVES = wipeKill(kill, SHOCKWAVES)

    SHADERS.POST_PROCESS:send("ACTIVE_SHOCKWAVES", #SHOCKWAVES)

end

function shock(x, y, size, force, lifetime)

    if #SHOCKWAVES < 16 then table.insert(SHOCKWAVES, {position = {x - camera[1], y - camera[2]}, size = size, lifetime = lifetime, force = force, lifetimeMax = lifetime}) end

end

postPro = "POST_PROCESS"