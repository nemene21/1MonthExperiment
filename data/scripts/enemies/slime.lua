
SLIME = love.graphics.newImage("data/graphics/images/slime.png")

SLIME_LAND_PARTICLES = loadJson("data/graphics/particles/slimeLand.json")
SLIME_JUMP_PARTICLES = loadJson("data/graphics/particles/slimeJump.json")

function newSlime(x, y)

    return {

        pos = newRect(x, y, 42, 24),

        additionalProcess = processSlime,
        additionalDraw    = drawSlime,

        attackAnimation = 0,

        scale = newVec(1, 1),

        hp = 50,

        image = SLIME,

        state = "idle",
        switchStateTimer = 3 + love.math.random(1, 2),

        states = {

            idle = slimeIdle,
            jump = slimeJump

        }

    }

end

function processSlime(this)

    this.states[this.state](this)

    this.vel.y = math.min(this.vel.y + GRAVITY * dt * 0.75, MAX_FALL_SPEED)

end

function slimeIdle(this)

    this.attackAnimation = lerp(this.attackAnimation, 0, dt * 12)

    if this.pos.touching.y == 1 then

        this.vel.y = 0

        this.vel.x = 0

    end

    this.scale.x = lerp(this.scale.x, 1 + math.sin(globalTimer * 4) * 0.1, dt * 3)
    this.scale.y = lerp(this.scale.y, 1 + math.sin(globalTimer * 4 + 1.57) * 0.1, dt * 3)

    if this.switchStateTimer < 1.5 then

        drawIndicator(this.pos.x, this.pos.y - 24, this.switchStateTimer)

    end

    this.switchStateTimer = this.switchStateTimer - dt
    if this.switchStateTimer < 0 then

        this.state = "jump"

        this.scale.x = 0.6
        this.scale.y = 1.4

        this.vel.y = - 500

        this.vel.x = 250 * (boolToInt(this.pos.x < player.pos.x) * 2 - 1)

        table.insert(particleSystems, newParticleSystem(this.pos.x, this.pos.y + 10, deepcopyTable(SLIME_JUMP_PARTICLES)))

    end

end

function slimeJump(this)

    this.attackAnimation = lerp(this.attackAnimation, 1, dt * 12)

    this.scale.x = lerp(this.scale.x, 1, dt * 1)
    this.scale.y = lerp(this.scale.y, 1, dt * 1)

    if this.pos.touching.x ~= 0 then

        this.pos.x = this.pos.x - this.vel.x * dt

        this.vel.x = this.vel.x * - 0.8

    end

    if this.pos.touching.y == - 1 then

        this.pos.y = this.pos.y - this.vel.y * dt

        this.vel.y = this.vel.y * - 0.8

    end

    if this.pos.touching.y == 1 then

        this.switchStateTimer = 3 + love.math.random(1, 2)
        this.state = "idle"

        this.scale.x = 1.4
        this.scale.y = 0.6

        this.vel.x = 0

        this.vel.y = - 100

        table.insert(particleSystems, newParticleSystem(this.pos.x, this.pos.y + 10, deepcopyTable(SLIME_LAND_PARTICLES)))
    
    else

        if rectCollidingCircle(this.pos, player.pos.x, player.pos.y, player.pos.w) then
            
            player:hit(1)

        end

    end

end

function drawSlime(this)

    setColor(255, 255 * (1 - this.attackAnimation), 255 * (1 - this.attackAnimation))
    drawSprite(this.image, this.pos.x, this.pos.y, this.scale.x, this.scale.y)

    shine(this.pos.x, this.pos.y, 96, {255 * this.attackAnimation, 255 * (1 - this.attackAnimation), 0, 100})
    setColor(255, 255, 255)

end