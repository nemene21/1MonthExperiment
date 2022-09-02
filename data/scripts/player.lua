
GRAVITY        = 800
MAX_FALL_SPEED = 1200

PLAYER_IMAGE   = love.graphics.newImage("data/graphics/images/ball.png")
PLAYER_BULLET  = loadJson("data/graphics/particles/playerBullet.json")

function newPlayer(x, y)

    local player = {

        pos = newVec(x, y),
        vel = newVec(0, 0),

        velocityParticles = newParticleSystem(x, y, loadJson("data/graphics/particles/playerTrail.json")),

        knockback = newVec(0, 0),

        process = processPlayer,
        draw    = drawPlayer,

        holdPos = nil,
        holding = false,

        floatTimer = 3,
        isFloating = false,
        floatingAnimation = 0,

        bullets    = {},
        shootTimer = 0,

        stats = {

            flingStrenght = 4,
            maxBullets = 8,
            spread = 5,
            knockbackResistance = 0.5

        }
        
    }

    local rot = 360 / player.stats.maxBullets

    for i=1, player.stats.maxBullets do

        local pos = newVec(40, 0)
        pos:rotate(rot * i)

        table.insert(player.bullets, newParticleSystem(pos.x + player.pos.x, pos.y + player.pos.y, deepcopyTable(PLAYER_BULLET)))

    end

    return player
end

function processPlayer(this)

    -- Gravity
    this.vel.y = math.min(this.vel.y + dt * GRAVITY * boolToInt(not this.isFloating), MAX_FALL_SPEED)

    -- Air friction
    this.vel.x = lerp(this.vel.x, 0, dt * boolToInt(not this.isFloating))

    this.pos.x = this.pos.x + this.vel.x * dt -- Apply velocity and knockback
    this.pos.y = this.pos.y + this.vel.y * dt
    this.pos.x = this.pos.x + this.knockback.x * dt
    this.pos.y = this.pos.y + this.knockback.y * dt

    this.knockback.x = lerp(this.knockback.x, 0, dt * 2)
    this.knockback.y = lerp(this.knockback.y, 0, dt * 2)

    local rot = 360 / player.stats.maxBullets
    for id, bullet in ipairs(this.bullets) do -- Put bullets in their place

        local pos = newVec(40, 0)
        pos:rotate(rot * id)

        bullet.x = pos.x + this.pos.x
        bullet.y = pos.y + this.pos.y

    end

    this.velocityParticles.x = this.pos.x -- Set particle position
    this.velocityParticles.y = this.pos.y

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

        this.floatTimer = clamp(this.floatTimer - dt, 0, 3)

        if this.floatTimer ~= 0 then

            this.isFloating = true

        end

    else

        this.floatTimer = clamp(this.floatTimer + dt, 0, 3)

    end

    if this.isFloating then -- Float

        this.vel.x = lerp(this.vel.x, 0, dt * 8)
        this.vel.y = lerp(this.vel.y, 0, dt * 8)

        this.floatingAnimation = lerp(this.floatingAnimation, 1, dt * 4)

    else

        this.floatingAnimation = lerp(this.floatingAnimation, 0, dt * 4)

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

        shock(this.pos.x, this.pos.y, 0.5, 0.05, 0.2)

        shake(20 * math.min(velToAdd:getLen() / 2000, 1), 1, 0.2, velToAdd:getRot())

    end

    this.shootTimer = this.shootTimer - dt
    if this.shootTimer < 0 and mousePressed(2) and #this.bullets ~= 0 then -- Shoot

        this.shootTimer = 0.2

        local bullet = this.bullets[#this.bullets]

        local bulletVel = newVec(xM - bullet.x, yM - bullet.y)
        bulletVel:normalize()
        bulletVel:rotate(love.math.random(this.stats.spread * - 0.5, this.stats.spread * 0.5))

        bullet.vel = newVec(bulletVel.x * 800, bulletVel.y * 800)

        table.remove(this.bullets, #this.bullets)

        table.insert(playerBullets, bullet)

        this.vel.x = this.vel.x - bulletVel.x * 200
        this.vel.y = this.vel.y - bulletVel.y * 200

        shake(3, 1, 0.15, bulletVel:getRot() + 180)

    end

end

function drawPlayer(this)

    if this.holding then

        love.graphics.line(xM, yM, this.holdPos.x, this.holdPos.y)

    end

    for id, bullet in ipairs(this.bullets) do

        bullet:process()

    end

    love.graphics.setShader(SHADERS.PLAYER); SHADERS.PLAYER:send("intensity", 1 - this.floatTimer / 3)

    local particleStrength = this.vel:getLen() / 1000
    this.velocityParticles.rotation = this.vel:getRot()
    this.velocityParticles.particleData.width.a = particleStrength * 12
    this.velocityParticles.particleData.width.b = particleStrength * 24

    this.velocityParticles:process()
    setColor(255, 255, 255)

    local stretch = this.vel:getLen() / 3000

    local floatAnimation = this.floatingAnimation * math.abs(math.sin(globalTimer * 10) * 0.2)

    local angle = this.vel:getRot() / 180 * 3.14

    love.graphics.translate(this.pos.x - camera[1], this.pos.y - camera[2])
    love.graphics.rotate(angle)
    love.graphics.scale(1 + stretch, 1 - stretch)
    love.graphics.rotate(-angle)

    love.graphics.draw(PLAYER_IMAGE, 0, 0, 0, (1 + floatAnimation) * 3, (1 + floatAnimation) * 3, PLAYER_IMAGE:getWidth() * 0.5, PLAYER_IMAGE:getHeight() * 0.5)

    love.graphics.origin()

    love.graphics.setShader()

end