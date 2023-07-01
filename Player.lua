require "Vector2"
require "world"

function PlayerCreate()
player = {
    position = vector2.new(0, 0),
    direction = vector2.new(0, 0),
    collision = vector2.new(0, 0),
    speed = 300,
    hitbox = 8,
    hp = 200,
    regen = 10,
    regencooldown = 3,
    regencooldowntimer = 0,
    abilitycooldown = 60,
    abilitycooldowntimer = 0,
    showstats = false,
    invincibility = false,
    dead = false,
    velocity = vector2.new(0, 0),

    projectile = {
        cooldown = 10,
        cooldowntimer = 0,
        speed = 400,
        range = 200,
        radius = 5,
        bullet = {}
    },

    mouse = 0
}
end

function PlayerUpdate(dt)
    player.mouse = vector2.new(love.mouse.getX() - (love.graphics.getWidth() / 2 - player.position.x), love.mouse.getY() - (love.graphics.getHeight() / 2 - player.position.y))
    PlayerMovement(dt)
    PlayerHealth(dt)
    PlayerProjectileSword(dt)
    
end

function PlayerMovement(dt)
    if love.keyboard.isDown("w") and love.keyboard.isDown("s") == false then
        player.direction.y = -1
    end
    if love.keyboard.isDown("s") and love.keyboard.isDown("w") == false then
        player.direction.y = 1
    end
    if love.keyboard.isDown("s") == false and love.keyboard.isDown("w") == false then
        player.direction.y = 0
    end
    if love.keyboard.isDown("a") and love.keyboard.isDown("d") == false then
        player.direction.x = -1
    end
    if love.keyboard.isDown("d") and love.keyboard.isDown("a") == false then
        player.direction.x = 1
    end
    if love.keyboard.isDown("d") == false and love.keyboard.isDown("a") == false then
        player.direction.x = 0
    end

    player.velocity = vector2.mult(player.direction, player.speed)
    player.velocity = vector2.limit(player.velocity, player.speed) 
    CollisionWall(player, dt)
    player.position = vector2.add(player.position, vector2.mult(player.velocity, dt))
end

function PlayerHealth(dt)


    if player.regencooldowntimer < 3 then
        player.regencooldowntimer = player.regencooldowntimer + 1*dt
    end

    if player.regencooldowntimer >= 3 and player.hp < 200 then
        player.hp = player.hp + player.regen*dt
    end

    if player.hp > 200 then
        player.hp = 200
    end

    if player.abilitycooldowntimer > 0 then
        player.abilitycooldowntimer = player.abilitycooldowntimer - 1*dt
    end

    if player.abilitycooldowntimer <= 0 and love.keyboard.isDown("f") then
        player.hp = player.hp + 100
        player.abilitycooldowntimer = player.abilitycooldown
    end

    if player.hp <= 0 then
        player.dead = true
    end

    function love.keypressed(key)
        if key == "c" and player.showstats == false then
            player.showstats = true
        elseif key == "c" and player.showstats == true then
            player.showstats = false
        end

        if key == "p" and player.invincibility == false then
            player.invincibility = true
        elseif key == "p" and player.invincibility == true then
            player.invincibility = false
        end
    end

end

function PlayerTakeDamage(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        for e = 1, #enemy.projectile.bullet[i].shot, 1 do
            if enemy.projectile.bullet[i].shot[e].damagedplayer == false then
                local dist = vector2.sub(player.position, enemy.projectile.bullet[i].shot[e].position)
                dist = vector2.magnitude(dist)
                if dist <= player.hitbox then
                    player.hp = player.hp - enemy.projectile.damage
                    enemy.projectile.bullet[i].shot[e].damagedplayer = true
                    player.regencooldowntimer = 0
                end
            end
         end
    end
end

function PlayerProjectileSword(dt)
    if player.projectile.cooldowntimer <= player.projectile.cooldown then
        player.projectile.cooldowntimer = player.projectile.cooldowntimer + 60*dt
    end

    if love.mouse.isDown("1") and (player.projectile.cooldowntimer >= player.projectile.cooldown) then
        table.insert(player.projectile.bullet, PlayerProjectileCreate())
        player.projectile.cooldowntimer = 0
    end

    for i = 1, #player.projectile.bullet, 1 do
        player.projectile.bullet[i].position = vector2.add(player.projectile.bullet[i].position, vector2.mult(player.projectile.bullet[i].velocity, dt))
    end 

    for i = 1, #player.projectile.bullet, 1 do
        if player.projectile.bullet[i] then
            local dist = vector2.sub(player.projectile.bullet[i].position, player.projectile.bullet[i].originalPosition)
            dist = vector2.magnitude(dist)
                if dist >= player.projectile.range then
                    table.remove(player.projectile.bullet, i)
                end
        end
    end
end

function PlayerProjectileCreate()
    local direction = vector2.sub(player.mouse, player.position)
    direction = vector2.normalize(direction)
    return {position = player.position,
            originalPosition = vector2.new(player.position.x, player.position.y),
            velocity = vector2.mult(direction, player.projectile.speed),
            colided = false}
end

function PlayerProjectileDetection(enemy, dt)
    for i = 1, #player.projectile.bullet, 1 do
        if player.projectile.bullet[i] then
            if (vector2.magnitude(vector2.sub(enemy.position, player.projectile.bullet[i].position)) <= enemy.hitbox) and (player.projectile.bullet[i].colided == false) then
                enemy.hp = enemy.hp - 1
                player.projectile.bullet[i].colided = true
                table.remove(player.projectile.bullet, i)
            end
        end
    end
    if enemy.hp <= 0 then
        enemy.alive = false
    end
end

function PlayerDraw()

    --player circle
    if player.hp >= 100 then
        love.graphics.setColor(0, player.hp/200, 0)
    end
    if player.hp >= 50 and player.hp < 100 then
        love.graphics.setColor(player.hp/100, player.hp/100, 0)
    end
    if player.hp >= 0 and player.hp < 50 then
        love.graphics.setColor(0.8, 0, 0)
    end
    love.graphics.circle("fill", player.position.x, player.position.y, player.hitbox)

    if player.showstats == true then
        love.graphics.print(math.floor(player.hp), player.position.x - 10, player.position.y + 10)
        if player.invincibility == true then
            love.graphics.setColor(0,1,0)
            love.graphics.print("Invincible", player.position.x - 10, player.position.y + 40)
        end
    end
    
    --Ability circle
    if player.abilitycooldowntimer >= 45 then
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
    if player.abilitycooldowntimer >= 30 then
        love.graphics.setColor(0.3, 0.3, 0.3)
    end
    if player.abilitycooldowntimer >= 15 then
        love.graphics.setColor(0.4, 0.4, 0.4)
    end
    if player.abilitycooldowntimer > 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    if player.abilitycooldowntimer <= 0 then
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.circle("line", player.position.x, player.position.y, player.hitbox)
    love.graphics.circle("line", player.position.x, player.position.y, player.hitbox-1)

    if player.showstats == true then
        if player.abilitycooldowntimer <= 0 then
            love.graphics.print("Ready", player.position.x - 15, player.position.y + 25)
        elseif player.abilitycooldowntimer > 0 then
            love.graphics.print(math.floor(player.abilitycooldowntimer), player.position.x - 10, player.position.y + 25)
        end
    end

    --draw bullet
    love.graphics.setColor(1, 1, 1)
    for i = 1, #player.projectile.bullet, 1 do
        love.graphics.circle("fill", player.projectile.bullet[i].position.x, player.projectile.bullet[i].position.y, player.projectile.radius)
    end
end