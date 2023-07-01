require "Vector2"
require "Player"
require "Enemy"


--Slime start


Slime = {}

function SlimeInsert(x, y)
    return {
        position = vector2.new(x, y),
        distanceFromPlayer = vector2.new(0,0),
        velocity = vector2.new(0, 0),
        direction = vector2.new(0, 0),
        collision = vector2.new(0, 0),
        speed = 150,
        stop = 1,
        hp = 5,
        hitbox = 12,
        movementswitchtimer = 0,
        movementswitch = 5,


        projectile = {
            cooldown = 0.2,
            cooldowntimer = 0,
            detectionRange = 800,
            maxlifetime = 4,
            radius = 7,
            damage = 30,
            bullet = {}
        }
    }
end

function SlimeCreate(x, y)
    table.insert(Slime, SlimeInsert(x, y))
end

function SlimeUpdate(dt)
    for i = 1, #Slime, 1 do
        if Slime[i] then
            if Slime[i].hp > 0 then
                SlimeMovement(Slime[i], dt)
                SlimeProjectileSpawn(Slime[i])
                EnemyProjectileCooldown(Slime[i], dt)
                PlayerProjectileDetection(Slime[i], dt)
            end
            SlimeProjectileLifetime(Slime[i], dt)
            if player.invincibility == false then
                PlayerTakeDamageSlimeEditionCauseImBadAtCoding(Slime[i], dt)
            end
            SlimeProjectileDeletion(Slime[i])

            if Slime[i].hp <= 0 and #Slime[i].projectile.bullet == 0 then
                table.remove(Slime, i)
            end
        end
    end
end

function SlimeMovement(enemy, dt)
    enemy.direction = vector2.sub(player.position, enemy.position)
    enemy.distanceFromPlayer = vector2.magnitude(enemy.direction)
    enemy.direction = vector2.normalize(enemy.direction)
    enemy.velocity = vector2.mult(enemy.direction, enemy.speed)
    if enemy.distanceFromPlayer < enemy.stop then
        enemy.position = enemy.position
    else
        CollisionWall(enemy, dt)
        enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, dt))
    end

    --[[enemy.movementswitchtimer = enemy.movementswitchtimer + 1*dt
    if enemy.movementswitchtimer >= enemy.movementswitch then
        enemy.direction = vector2.new(math.random(-1000, 1000), math.random(-1000, 1000))
        enemy.movementswitchtimer = 0
    end
    CollisionWall(enemy, dt)
    enemy.distanceFromPlayer = vector2.magnitude(enemy.direction)
    enemy.direction = vector2.normalize(enemy.direction)
    enemy.velocity = vector2.mult(enemy.direction, enemy.speed)
    enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, dt))--]]
end

function PlayerTakeDamageSlimeEditionCauseImBadAtCoding(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i].shot.damagedplayer == false then
            local dist = vector2.sub(player.position, enemy.projectile.bullet[i].shot.position)
            dist = vector2.magnitude(dist)
            if dist <= player.hitbox then
                player.hp = player.hp - enemy.projectile.damage
                enemy.projectile.bullet[i].shot.damagedplayer = true
                player.regencooldowntimer = 0
             end
        end
    end
end

function SlimeProjectileCreation(enemy)
    local direction = vector2.sub(player.position, enemy.position)
    direction = vector2.normalize(direction)
    
    return {shot = {position = vector2.new(enemy.position.x, enemy.position.y),
            lifetime = 0,
            damagedplayer = false}}
end

function SlimeProjectileSpawn(enemy)
    if enemy.distanceFromPlayer <= enemy.projectile.detectionRange and (enemy.projectile.cooldowntimer >= enemy.projectile.cooldown) then
        table.insert(enemy.projectile.bullet, SlimeProjectileCreation(enemy))
        enemy.projectile.cooldowntimer = 0
    end
end

function SlimeProjectileLifetime(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i].shot then
            enemy.projectile.bullet[i].shot.lifetime = enemy.projectile.bullet[i].shot.lifetime + 1*dt
        end
    end 
end

function SlimeProjectileDeletion(enemy)
for i = 1, #enemy.projectile.bullet, 1 do
    if enemy.projectile.bullet[i] then
        if enemy.projectile.bullet[i].shot.lifetime >= enemy.projectile.maxlifetime or enemy.projectile.bullet[i].shot.damagedplayer == true then
            table.remove(enemy.projectile.bullet, i)
        end
    end
end
end

function SlimeDraw()
    for i = 1, #Slime, 1 do
        if Slime[i] and Slime[i].hp > 0 then
            love.graphics.setColor(0.5,0,0.5)
            love.graphics.circle("fill", Slime[i].position.x, Slime[i].position.y, Slime[i].hitbox)
            love.graphics.print(Slime[i].hp, Slime[i].position.x - 5, Slime[i].position.y + 15)
        end
            SlimeDrawProjectiles(Slime[i])
    end
end

function SlimeDrawProjectiles(Slime)
    for i = 1, #Slime.projectile.bullet, 1 do
        love.graphics.setColor(1, 0, 1)
        love.graphics.circle("fill", Slime.projectile.bullet[i].shot.position.x, Slime.projectile.bullet[i].shot.position.y, Slime.projectile.radius)
    end
end
    