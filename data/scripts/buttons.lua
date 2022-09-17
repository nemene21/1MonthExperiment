

function newButton(x, y, text, dir)

    local width = FONT:getWidth(text)

    local button = {

        x = x, y = y,

        text = text,

        process = processButton,
        draw = drawButton,

        dir = dir,

        anim = 0,
        pressedAnim = 0,
        spawnAnim = 0,
        yOffset = 0

    }

    return button
end

function processButton(this)

    this.pressed = false
    if xM > this.x - 144 and xM < this.x + 144 and yM > this.y - 36 and yM < this.y + 36 then

        this.anim = math.min(this.anim + dt * 4, 1)

        this.yOffset = easeOutBack(0, 28, this.anim)

        if mouseJustPressed(1) then

            this.pressedAnim = 1
            this.pressed = true

        end

    else

        this.anim = math.max(this.anim - dt * 4, 0)

        this.yOffset = easeOutBack(0, 28, this.anim)

    end

end

buttonImage = love.graphics.newImage("data/graphics/images/shaderMasks/button.png")

function drawButton(this)

    this.spawnAnim = math.min(this.spawnAnim + dt, 1)

    this.pressedAnim = math.max(this.pressedAnim - dt * 5, 0)
    local pressedAnim = easeInOutQuad(0, 1, this.pressedAnim)

    love.graphics.setShader(SHADERS.BUTTON)

    if this.pressedAnim > 0.85 then flash(1) end

    drawSprite(buttonImage, this.x + this.dir * easeOutElastic(300, 0, this.spawnAnim), this.y - this.yOffset, 1 + pressedAnim * 0.2, 1 - pressedAnim * 0.2)

    resetShader()

    outlinedText(this.x + this.dir * easeOutElastic(300, 0, this.spawnAnim), this.y - this.yOffset - 8, 3, this.text, {255, 255, 255}, 2 + pressedAnim * 0.4, 2 - pressedAnim * 0.4, 0.5, 0.5)

end