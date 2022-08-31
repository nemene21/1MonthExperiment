
GRAVITY        = 800
MAX_FALL_SPEED = 1200

function newPlayer(x, y)

    return {

        pos = newVec(x, y),
        vel = newVec(0, 0),

        knockback = newVec(0, 0),

        process = processPlayer,
        draw    = drawPlayer,

        holdPos = nil,
        holding = false,

        floatTimer = 5,
        isFloating = false,

        stats = {

            flingStrenght = 3

        }
        
    }
end

function processPlayer(this)

    -- Gravity
    this.vel.y = math.min(this.vel.y + dt * GRAVITY * boolToInt(not this.isFloating), MAX_FALL_SPEED)

    -- Air friction
    this.vel.x = lerp(this.vel.x, 0, dt)

    this.pos.x = this.pos.x + this.vel.x * dt -- Apply velocity and knockback
    this.pos.y = this.pos.y + this.vel.y * dt
    this.pos.x = this.pos.x + this.knockback.x * dt
    this.pos.y = this.pos.y + this.knockback.y * dt

    this.pos.y = clamp(this.pos.y, 0, 600)

    if player.pos.x < 18 then -- Hitting left edge

        this.pos.x = this.pos.x - this.vel.x * dt -- Apply opposite velocity

        player.vel.x = player.vel.x * - 0.8

    end

    if player.pos.x > 782 then -- Hitting right edge

        this.pos.x = this.pos.x - this.vel.x * dt -- Apply opposite velocity

        player.vel.x = player.vel.x * - 0.8

    end

    this.isFloating = false
    if pressed("space") then -- Try floating

        this.floatTimer = clamp(this.floatTimer - dt, 0, 5)

        if this.floatTimer ~= 0 then

            this.isFloating = true

        end

    else

        this.floatTimer = clamp(this.floatTimer + dt, 0, 5)

    end

    if this.isFloating then -- Float

        this.vel.x = lerp(this.vel.x, 0, dt * 8)
        this.vel.y = lerp(this.vel.y, 0, dt * 8)

    end

    if mouseJustPressed(1) then -- Hold

        this.holdPos = newVec(xM, yM)

        this.holding = true

    end

    if not mousePressed(1) and this.holding then -- Let go

        local velToAdd = newVec(this.holdPos.x - xM, this.holdPos.y - yM)

        this.vel.x = this.vel.x + velToAdd.x * this.stats.flingStrenght
        this.vel.y = this.vel.y + velToAdd.y * this.stats.flingStrenght

        this.holding = false

    end

end

function drawPlayer(this)

    setColor(255, 255 * this.floatTimer / 5, 255 * this.floatTimer / 5)

    if this.holding then

        love.graphics.line(xM, yM, this.holdPos.x, this.holdPos.y)

    end

    love.graphics.circle("fill", this.pos.x - camera[1], this.pos.y - camera[2], 36)

end