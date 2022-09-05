
require "data.scripts.enemies.slime"

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

    return enemy

end

function processEnemy(this)

    this.flash = clamp(this.flash - dt, 0, 0.2)

    this.knockback.x = lerp(this.knockback.x, 0, dt * 2)
    this.knockback.y = lerp(this.knockback.y, 0, dt * 2)

    this:additionalProcess()

    this.pos = moveRect(this.pos, newVec(this.knockback.x + this.vel.x, this.knockback.y + this.vel.y), rooms[roomAt].tilemap.colliders)

end

function drawEnemy(this)

    flash(this.flash)
    this:additionalDraw()
    resetShader()

end

function hurtEnemy(this, damage, knockback)

    this.hp = this.hp - damage
    this.knockback.x = this.knockback.x + knockback.x
    this.knockback.y = this.knockback.y + knockback.y

    this.flash = 0.2

end