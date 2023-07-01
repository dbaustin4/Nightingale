require "Vector2"
require "Player"
require "Enemy"


--Bat start


Bat = {}

function BatInsert(x, y)
    return {
        position = vector2.new(x, y),
        distanceFromPlayer = vector2.new(0,0),
        velocity = vector2.new(0, 0),
        direction = vector2.new(0, 0),
        speed = 150,
        stop = 50,
        hp = 3,
        hitbox = 8,
        collision = vector2.new(0, 0),


        projectile = {
            cooldown = 0.5,
            cooldowntimer = 0,
            detectionRange = 200,
            speed = 250,
            range = 150,
            radius = 5,
            damage = 10,
            bullet = {}
        }
    }
end

function BatCreate(x, y)
    table.insert(Bat, BatInsert(x, y))
end

function BatUpdate(dt)
    for i = 1, #Bat, 1 do
        if Bat[i] then
            if Bat[i].hp > 0 then
                BatMovement(Bat[i], dt)
                BatProjectileSpawn(Bat[i])
                EnemyProjectileCooldown(Bat[i], dt)
                PlayerProjectileDetection(Bat[i], dt)
            end
            BatProjectileSpeed(Bat[i], dt)
            if player.invincibility == false then
                PlayerTakeDamageBatEditionCauseImBatAtCoding(Bat[i], dt)
            end
            BatProjectileDeletion(Bat[i])

            if Bat[i].hp <= 0 and #Bat[i].projectile.bullet == 0 then
                table.remove(Bat, i)
            end
        end
    end
end

function BatMovement(enemy, dt)
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
end

function PlayerTakeDamageBatEditionCauseImBatAtCoding(enemy, dt)
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

function BatProjectileCreation(enemy)
    local direction = vector2.sub(player.position, enemy.position)
    direction = vector2.normalize(direction)
    
    return {shot = {position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed),
            damagedplayer = false}}
end

function BatProjectileSpawn(enemy)
    if enemy.distanceFromPlayer <= enemy.projectile.detectionRange and (enemy.projectile.cooldowntimer >= enemy.projectile.cooldown) then
        table.insert(enemy.projectile.bullet, BatProjectileCreation(enemy))
        enemy.projectile.cooldowntimer = 0
    end
end

function BatProjectileSpeed(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i].shot then
            enemy.projectile.bullet[i].shot.position = vector2.add(enemy.projectile.bullet[i].shot.position, vector2.mult(enemy.projectile.bullet[i].shot.velocity, dt))
        end
    end 
end

function BatProjectileDeletion(enemy)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i] then
            local dist = vector2.sub(enemy.projectile.bullet[i].shot.position, enemy.projectile.bullet[i].shot.originalPosition)
            dist = vector2.magnitude(dist)
            if dist >= enemy.projectile.range or enemy.projectile.bullet[i].shot.damagedplayer == true then
                table.remove(enemy.projectile.bullet, i)
            end
        end
    end
end

function BatDraw()
    for i = 1, #Bat, 1 do
        if Bat[i] and Bat[i].hp > 0 then
            love.graphics.setColor(0,0,0.7)
            love.graphics.circle("fill", Bat[i].position.x, Bat[i].position.y, Bat[i].hitbox)
            love.graphics.print(Bat[i].hp, Bat[i].position.x - 5, Bat[i].position.y + 10)
        end
            BatDrawProjectiles(Bat[i])
    end
end

function BatDrawProjectiles(Bat)
    for i = 1, #Bat.projectile.bullet, 1 do
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle("fill", Bat.projectile.bullet[i].shot.position.x, Bat.projectile.bullet[i].shot.position.y, Bat.projectile.radius)
    end
end
    