
FONT = love.graphics.newFont("data/font.ttf",16)
FONT:setFilter("nearest","nearest")

love.graphics.setFont(FONT)

function outlinedText(x,y,w,text,color, scaleX, scaleY, cX, cY)

    local color = color or {255,255,255}
    local scaleX = scaleX or 1; local scaleY = scaleY or 1
    local cX = cX or 0; local cY = cY or 0

    local width = FONT:getWidth(text) * cX
    local height = FONT:getHeight(text) * cY

    setColor(0,0,0,color[4] or 255)
    love.graphics.print(text,x - w,y, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x + w,y, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x,y - w, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x,y + w, 0, scaleX, scaleY, width, height)

    love.graphics.print(text,x,y + w + 2, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x - w,y + w + 2, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x + w,y + w + 2, 0, scaleX, scaleY, width, height)

    love.graphics.print(text,x - w,y - w, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x + w,y + w, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x + w,y - w, 0, scaleX, scaleY, width, height)
    love.graphics.print(text,x - w,y + w, 0, scaleX, scaleY, width, height)
    
    setColor(color[1],color[2],color[3],(color[4] or 255) * 2)
    love.graphics.print(text,x,y, 0, scaleX, scaleY, width, height)
end

function normalText(x,y,text,color, scaleX, scaleY, cX, cY)

    local color = color or {255,255,255}
    local scaleX = scaleX or 1; local scaleY = scaleY or 1
    local cX = cX or 0; local cY = cY or 0

    local width = FONT:getWidth(text) * cX
    local height = FONT:getHeight(text) * cY
    
    setColor(color[1],color[2],color[3],(color[4] or 255) * 2)
    love.graphics.print(text,x,y, 0, scaleX, scaleY, width, height)
end

function waveText(x,y,w,text,color, scaleX, scaleY ,cX,cY,waveSpeed,waveWidth)

    local width = FONT:getWidth(text) * (cX or 1) * (scaleX or 1) + #text * w
    local height = FONT:getHeight(text) * (cY or 1) * (scaleY or 1)

    text = tablifyString(text)

    local xOffset = -width * 0.5

    for id, L in ipairs(text) do

        xOffset = xOffset + FONT:getWidth(L) * 3 + w

        outlinedText(x + xOffset, y + math.sin(id + globalTimer * waveSpeed) * waveWidth or 1 - height, w, L, color, scaleX, scaleY, cX, cY)
    end

end

ALL_TEXT_PARTICLES = {}

function addNewText(text, x, y, color)
    table.insert(ALL_TEXT_PARTICLES, {text = text, x = x, y = y, color = color, lifetime = 1.2})
end

function processTextParticles()

    kill = {}
    for id, particle in ipairs(ALL_TEXT_PARTICLES) do

        particle.lifetime = particle.lifetime - dt

        local progress = particle.lifetime * 0.83
        local progressI = 1 - progress

        local scaleProgress = math.min(progressI * 8, 1)
        
        outlinedText(particle.x - camera[1], particle.y - camera[2] - 48 * progressI, 2, particle.text, {particle.color[1], particle.color[2], particle.color[3], 255 * clamp(progress * 4, 0, 1)}, lerp(3, 1, scaleProgress), lerp(0, 1, scaleProgress), 0.5, 0.5)

        if particle.lifetime < 0 then table.insert(kill, id) end

    end ALL_TEXT_PARTICLES = wipeKill(kill, ALL_TEXT_PARTICLES)

end