require "Vector2"
require "Player"
require "Enemy"


PossessedArmor = {}

function PossessedArmorInsert(x, y)
    return {
        position = vector2.new(x, y),
        distanceFromPlayer = vector2.new(0,0),
        velocity = vector2.new(0, 0),
        direction = vector2.new(0, 0),
        collision = vector2.new(0, 0),
        speed = 50,
        stop = 100,
        hp = 10,
        hitbox = 16,


        projectile = {
            cooldown = 1,
            cooldowntimer = 0,
            detectionRange = 250,
            speed = 300,
            range = 250,
            radius = 5,
            amount = 10,
            damage = 20,
            returnspeed = 2,
            bullet = {}
            }
    }
end

function PossessedArmorCreate(x, y)
    table.insert(PossessedArmor, PossessedArmorInsert(x, y))
end

function PossessedArmorUpdate(dt)
    for i = 1, #PossessedArmor, 1 do
        if PossessedArmor[i] then
            if PossessedArmor[i].hp > 0 then
                PossessedArmorMovement(PossessedArmor[i], dt)
                PossessedArmorProjectileSpawn(PossessedArmor[i])
                EnemyProjectileCooldown(PossessedArmor[i], dt)
                PlayerProjectileDetection(PossessedArmor[i], dt)
            end
            PossessedArmorProjectileSpeed(PossessedArmor[i], dt)
            if player.invincibility == false then
                PlayerTakeDamage(PossessedArmor[i], dt)
            end
            PossessedArmorProjectileDeletion(PossessedArmor[i])

            if PossessedArmor[i].hp <= 0 and #PossessedArmor[i].projectile.bullet == 0 then
                table.remove(PossessedArmor, i)
            end
        end
    end
end

function PossessedArmorMovement(enemy, dt)
    enemy.direction = vector2.sub(player.position, enemy.position)
    enemy.distanceFromPlayer = vector2.magnitude(enemy.direction)
    enemy.direction = vector2.normalize(enemy.direction)
    enemy.velocity = vector2.mult(enemy.direction, enemy.speed)

    if enemy.distanceFromPlayer < enemy.stop then
        enemy.position = enemy.position
    else
        enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, dt))
    end
end



function PossessedArmorProjectileCreation(enemy)
-- thank you so much professor Edirlei
    local direction = vector2.sub(player.position, enemy.position)
    local distance = vector2.magnitude(direction)
    local futureplayerposition = vector2.add(player.position, vector2.mult(player.direction, distance))
    direction = vector2.normalize(vector2.sub(futureplayerposition, enemy.position))
    
    return {shot = {{position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed),
            boomerang = false,
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.1 ),
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.2),
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.3),
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.4),
            damagedplayer = false},
        
            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.5),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.6),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.7),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.8),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed * 0.9),
            damagedplayer = false}}}
end

function PossessedArmorProjectileSpawn(enemy)
    if enemy.distanceFromPlayer <= enemy.projectile.detectionRange and (enemy.projectile.cooldowntimer >= enemy.projectile.cooldown) then
        table.insert(enemy.projectile.bullet, PossessedArmorProjectileCreation(enemy))
        enemy.projectile.cooldowntimer = 0
    end
end

function PossessedArmorProjectileSpeed(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        for e = 1, #enemy.projectile.bullet[i].shot, 1 do
            if enemy.projectile.bullet[i].shot[e] then
                enemy.projectile.bullet[i].shot[e].position = vector2.add(enemy.projectile.bullet[i].shot[e].position, vector2.mult(enemy.projectile.bullet[i].shot[e].velocity, dt))
            end
        end
    end 
end

function PossessedArmorProjectileDeletion(enemy)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i] then
            local dist = vector2.sub(enemy.projectile.bullet[i].shot[1].position, enemy.projectile.bullet[i].shot[1].originalPosition)
            dist = vector2.magnitude(dist)
            if dist >= enemy.projectile.range and enemy.projectile.bullet[i].shot[1].boomerang == false then
                for e = 1, #enemy.projectile.bullet[i].shot, 1 do
                    enemy.projectile.bullet[i].shot[e].velocity = vector2.mult(enemy.projectile.bullet[i].shot[e].velocity, -enemy.projectile.returnspeed)
                end
                enemy.projectile.bullet[i].shot[1].originalPosition = vector2.new(enemy.projectile.bullet[i].shot[1].position.x, enemy.projectile.bullet[i].shot[1].position.y)
                dist = vector2.sub(enemy.projectile.bullet[i].shot[1].position, enemy.projectile.bullet[i].shot[1].originalPosition)
                dist = vector2.magnitude(dist)
                enemy.projectile.bullet[i].shot[1].boomerang = true
            end
            if dist >= enemy.projectile.range and enemy.projectile.bullet[i].shot[1].boomerang == true then
                table.remove(enemy.projectile.bullet, i)
            end
        end
    end
end

function PossessedArmorDraw()
    for i = 1, #PossessedArmor, 1 do
        if PossessedArmor[i] and PossessedArmor[i].hp > 0 then
            love.graphics.setColor(0.2,0,0.5)
            love.graphics.circle("fill", PossessedArmor[i].position.x, PossessedArmor[i].position.y, PossessedArmor[i].hitbox)
            love.graphics.print(PossessedArmor[i].hp, PossessedArmor[i].position.x - 10, PossessedArmor[i].position.y + 20)
        end
            PossessedArmorDrawProjectiles(PossessedArmor[i])
    end
end

function PossessedArmorDrawProjectiles(PossessedArmor)
    for i = 1, #PossessedArmor.projectile.bullet, 1 do
        love.graphics.setColor(0.2, 0, 0.5)
        love.graphics.circle("fill", PossessedArmor.projectile.bullet[i].shot[1].position.x, PossessedArmor.projectile.bullet[i].shot[1].position.y, PossessedArmor.projectile.radius+5)
        love.graphics.setColor(0.8, 0, 0)
        for e = 2, #PossessedArmor.projectile.bullet[i].shot, 1 do
            love.graphics.circle("fill", PossessedArmor.projectile.bullet[i].shot[e].position.x, PossessedArmor.projectile.bullet[i].shot[e].position.y, PossessedArmor.projectile.radius)
        end
    end
end