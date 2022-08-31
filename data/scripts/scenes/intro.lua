
function introReload()

    introAnimation = 0

    introDone = 0

    LOGO = love.graphics.newImage("data/graphics/images/logo.png")
    LOGO_LETTERS = love.graphics.newImage("data/graphics/images/logoLetters.png")

    introShaken = false

end

function introDie()

end

function intro()

    -- Reset
    sceneAt = "intro"

    clear(0, 0, 0)

    introAnimation = introAnimation + dt
    introDone = clamp(introDone + dt, 0, 3)

    local animation = clamp(introAnimation, 0, 0.5) * 2
    local squash = 0

    if introAnimation > 0.5 then

        squash = 0.4 - clamp((introAnimation - 0.5) * 2, 0, 0.4)

    end

    local fadeAnimation = introAnimation * 0.5

    setColor(255, 255, 255, 255 * fadeAnimation)
    love.graphics.draw(LOGO, 400, 300 - 400 * (1 - animation), 0, 2 - animation + squash, animation - squash, LOGO:getWidth() * 0.5, LOGO:getHeight() * 0.5)

    setColor(255, 255, 255, 255 * fadeAnimation)
    love.graphics.draw(LOGO_LETTERS, 400, 450, 0, 1, 1, LOGO_LETTERS:getWidth() * 0.5, LOGO_LETTERS:getHeight() * 0.5)

    if introAnimation > 0.5 and not introShaken then

        shake(12, 3, 0.08)

        introShaken = true

    end

    if introDone > 2.5 then

        transition = (introDone - 2.5) * 2

    end

    if introDone == 3 then sceneAt = "game" end

    -- Return scene
    return sceneAt

end