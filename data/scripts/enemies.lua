
require "data.scripts.enemies.slime"

ENEMIES_TO_GENERATE = {"slime"}
ENEMIES = {

    slime = newSlime

}

function newEnemy(name, x, y)

    local enemy = ENEMIES[name](x, y)

    enemy.vel = enemy.vel or newVec(0, 0)

    enemy.knockback = newVec(0, 0)
    enemy.flash     = 0

    enemy.process = processEnemy
    enemy.draw    = drawEnemy
    enemy.hit     = hurtEnemy

    enemy.canGetContactDamage = true

    return enemy

end

function processEnemy(this)

    this.flash = clamp(this.flash - dt, 0, 0.2)

    this.knockback.x = lerp(this.knockback.x, 0, dt * 2)
    this.knockback.y = lerp(this.knockback.y, 0, dt * 2)

    this:additionalProcess()

    if this.pos.y > - rooms[roomAt].y + WS[2] - 24 then

        this.pos.touching.y = - 1

        this.vel.y = this.vel.y * - 0.8

        this.pos.y = - rooms[roomAt].y + WS[2] - 24

    end

    if this.pos.y < - rooms[roomAt].y + 24 then

        this.pos.touching.y = 1

        this.vel.y = this.vel.y * - 0.8

        this.pos.y = - rooms[roomAt].y + 24

    end

    if this.pos.touching.x ~= 0 then

        this.knockback.x = this.knockback.x * - 0.8

    end

    if this.pos.touching.y ~= 0 then

        this.knockback.y = this.knockback.y * - 0.8

    end

    this.pos = moveRect(this.pos, newVec(this.knockback.x + this.vel.x, this.knockback.y + this.vel.y), rooms[roomAt].tilemap.colliders)

    local hitStrength = newVec(this.knockback.x - player.vel.x, this.knockback.y - player.vel.y):getLen()

    if rectCollidingCircle(this.pos, player.pos.x, player.pos.y, player.pos.w + 4) and hitStrength > 400 then
        
        if this.canGetContactDamage then

            damage = hitStrength / 800 * 20

            this:hit(damage, player.vel)

        end

        this.canGetContactDamage = false
    else

        this.canGetContactDamage = true
        
    end

end

function drawEnemy(this)

    flash(boolToInt(this.flash * 5 > 0))
    this:additionalDraw()
    resetShader()
end

function hurtEnemy(this, damage, knockback)

    this.hp = this.hp - damage
    this.knockback.x = this.knockback.x + knockback.x
    this.knockback.y = this.knockback.y + knockback.y

    this.flash = 0.2

end

INDICATORS = {}
INDICATOR = love.graphics.newImage("data/graphics/images/exclamationMark.png")

function drawIndicator(x, y, time)

    table.insert(INDICATORS, {

        x = x, y = y, time = time

    })

end

function drawEveryIndicator()

    for id, indicator in ipairs(INDICATORS) do

        if math.sin(globalTimer * 12) > 0 then
            
            setColor(255, 0, 77)

        else

            setColor(255, 163, 0)

        end
        drawSprite(INDICATOR, indicator.x, indicator.y + 8 * math.sin(globalTimer * 3), 1, 1)

    end

    INDICATORS = {}

end