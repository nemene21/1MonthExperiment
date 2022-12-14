
GRAVITY        = 800
MAX_FALL_SPEED = 1200

PLAYER_IMAGE   = love.graphics.newImage("data/graphics/images/ball.png")
PLAYER_BULLET  = loadJson("data/graphics/particles/playerBullet.json")

function newPlayer(x, y)

    local player = {

        pos = newRect(x, y, 40, 40),
        vel = newVec(0, 0),

        hp = 5,
        iFrames = 0,

        velocityParticles = newParticleSystem(x, y, loadJson("data/graphics/particles/playerTrail.json")),

        knockback = newVec(0, 0),

        process = processPlayer,
        draw    = drawPlayer,
        hit     = hitPlayer,

        holdPos = nil,
        holding = false,

        floatTimer = 3,
        isFloating = false,
        floatingAnimation = 0,

        bullets    = {},
        shootTimer = 0,

        bulletOffsetRot = 0,
        bulletOffset = newVec(x, y),

        stats = {

            flingStrenght = 4,
            maxBullets = 8,
            spread = 5,
            knockbackResistance = 0.5,
            shootDamage = 20,
            reloadTime = 0.2,
            shootKnockback = 200,
            iFrames = 0.5,
            pickupRange = 128,
            bulletStorage = 8,
            bulletBounce = 0

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

    this.iFrames = clamp(this.iFrames - dt, 0, this.stats.iFrames)

    SHADERS.POST_PROCESS:send("hurtVignetteIntensity", this.iFrames / this.stats.iFrames)

    -- Air friction
    this.vel.x = lerp(this.vel.x, 0, dt * boolToInt(not this.isFloating))

    this.pos = moveRect(this.pos, newVec(this.vel.x + this.knockback.x, this.vel.y + this.knockback.y), ROOM_IN.tilemap.colliders)

    this.knockback.x = lerp(this.knockback.x, 0, dt * 2)
    this.knockback.y = lerp(this.knockback.y, 0, dt * 2)

    this.bulletOffsetRot = this.bulletOffsetRot + dt * 90

    this.bulletOffset.x = lerp(this.bulletOffset.x, this.pos.x, dt * 8)
    this.bulletOffset.y = lerp(this.bulletOffset.y, this.pos.y, dt * 8)

    local rot = 360 / this.stats.maxBullets
    for id, bullet in ipairs(this.bullets) do -- Put bullets in their place

        local pos = newVec(40, 0)
        pos:rotate(rot * id + this.bulletOffsetRot)

        bullet.x = pos.x + this.bulletOffset.x
        bullet.y = pos.y + this.bulletOffset.y

        bullet.follow = true

    end

    this.velocityParticles.x = this.pos.x -- Set particle position
    this.velocityParticles.y = this.pos.y

    -- Gravity
    this.vel.y = math.min(this.vel.y + dt * GRAVITY * boolToInt(not this.isFloating), MAX_FALL_SPEED)

    if this.pos.touching.x ~= 0 then -- Hitting on x

        this.pos.x = this.pos.x - this.vel.x * dt -- Apply opposite velocity

        this.vel.x = this.vel.x * - 0.8

    end

    if this.pos.touching.y ~= 0 then -- Hitting on y

        this.pos.y = this.pos.y - this.vel.y * dt -- Apply opposite velocity

        this.vel.y = this.vel.y * - 0.75

        if math.abs(this.vel.y) < 100 then

            this.vel.y = 0

        end

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

        shock(this.pos.x, this.pos.y, 0.2 * math.min(velToAdd:getLen() / 500, 1), 0.05 * math.min(velToAdd:getLen() / 500, 1), 0.2)

        shake(20 * math.min(velToAdd:getLen() / 2000, 1), 1, 0.2, velToAdd:getRot())

    end

    this.shootTimer = math.max(this.shootTimer - dt, 0)
    if this.shootTimer == 0 and mousePressed(2) and #this.bullets ~= 0 then -- Shoot

        this.shootTimer = this.stats.reloadTime

        local bullet = this.bullets[#this.bullets]

        local bulletVel = newVec(xM - this.pos.x + camera[1], yM - this.pos.y + camera[2])
        bulletVel:normalize()
        bulletVel:rotate(love.math.random(this.stats.spread * - 0.5, this.stats.spread * 0.5))

        bullet.vel = newVec(bulletVel.x * 600, bulletVel.y * 600)

        bullet.interpolation = "linear"
        bullet.tickSpeed.a = 0.01
        bullet.tickSpeed.b = 0.02

        bullet.follow = false

        bullet.x = this.pos.x
        bullet.y = this.pos.y

        table.remove(this.bullets, #this.bullets)

        table.insert(playerBullets, bullet)

        this.vel.x = this.vel.x - bulletVel.x * 100
        this.vel.y = this.vel.y - bulletVel.y * 100

        shake(3, 1, 0.15, bulletVel:getRot() + 180)
        shock(bullet.x, bullet.y, 0.05, 0.025, 0.2)

    end

end

function drawPlayer(this)

    if this.holding then

        love.graphics.line(xM, yM, this.holdPos.x, this.holdPos.y)

    end

    for id, bullet in ipairs(this.bullets) do

        bullet:process()

    end

    local particleStrength = this.vel:getLen() / 1000
    this.velocityParticles.rotation = this.vel:getRot()
    this.velocityParticles.particleData.width.a = particleStrength * 12
    this.velocityParticles.particleData.width.b = particleStrength * 24

    this.velocityParticles:process()

    love.graphics.setShader(SHADERS.PLAYER)

    SHADERS.PLAYER:send("intensity", 1 - this.floatTimer / 3)
    SHADERS.PLAYER:send("hp", this.hp)

    setColor(255, 255, 255, 255 * (1 - math.abs(math.sin(player.iFrames / player.stats.iFrames * 3.14 * 5))))

    local stretch = this.vel:getLen() / 3000

    local floatAnimation = this.floatingAnimation * math.abs(math.sin(globalTimer * 10) * 0.2)

    local shootAnimation = this.shootTimer / this.stats.reloadTime * 0.33

    local angle = this.vel:getRot() / 180 * 3.14

    love.graphics.translate(this.pos.x - camera[1], this.pos.y - camera[2])
    love.graphics.rotate(angle)
    love.graphics.scale(1 + stretch + shootAnimation, 1 - stretch - shootAnimation)
    love.graphics.rotate(-angle)

    love.graphics.draw(PLAYER_IMAGE, 0, 0, 0, (1 + floatAnimation) * 3, (1 + floatAnimation) * 3, PLAYER_IMAGE:getWidth() * 0.5, PLAYER_IMAGE:getHeight() * 0.5)

    love.graphics.origin()

    love.graphics.setShader()

    setColor(255, 255, 255)

    shine(player.pos.x, player.pos.y, 140, {0, 100, 255, 110 * (1 - math.abs(math.sin(player.iFrames / player.stats.iFrames * 3.14 * 5)))})

end

function hitPlayer(this, dmg)

    if this.iFrames == 0 then

        this.hp = this.hp - dmg
        this.iFrames = this.stats.iFrames

    end

end