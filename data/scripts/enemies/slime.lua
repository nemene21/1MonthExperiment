
SLIME = love.graphics.newImage("data/graphics/images/slime.png")

function newSlime(x, y)

    return {

        pos = newRect(x, y, 42, 24),

        additionalProcess = processSlime,
        additionalDraw    = drawSlime,

        scale = newVec(1, 1)

    }

end

function processSlime(this)

end

function drawSlime(this)

    print(this.pos.x, this.pos.y)
    drawSprite(SLIME, this.pos.x, this.pos.y)

end