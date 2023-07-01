require "Vector2"
require "Player"
require "Enemy"


Zombie = {}

function ZombieInsert(x, y)
    return {
        position = vector2.new(x, y),
        distanceFromPlayer = vector2.new(0,0),
        velocity = vector2.new(0, 0),
        direction = vector2.new(0, 0),
        collision = vector2.new(0, 0),
        speed = 150,
        stop = 250,
        hp = 5,
        hitbox = 10,


        projectile = {
            cooldown = 1.5,
            cooldowntimer = 0,
            detectionRange = 400,
            speed = 50,
            range = 400,
            radius = 5,
            angle = math.pi/6,
            returnspeed = 2,
            damage = 20,
            bullet = {}
            }
    }
end

function ZombieCreate(x, y)
    table.insert(Zombie, ZombieInsert(x, y))
end

function ZombieUpdate(dt)
    for i = 1, #Zombie, 1 do
        if Zombie[i] then
            if Zombie[i].hp > 0 then
                ZombieMovement(Zombie[i], dt)
                ZombieProjectileSpawn(Zombie[i])
                EnemyProjectileCooldown(Zombie[i], dt)
                PlayerProjectileDetection(Zombie[i], dt)
            end
            ZombieProjectileSpeed(Zombie[i], dt)
            if player.invincibility == false then
                PlayerTakeDamage(Zombie[i], dt)
            end
            ZombieProjectileDeletion(Zombie[i])

            if Zombie[i].hp <= 0 and #Zombie[i].projectile.bullet == 0 then
                table.remove(Zombie, i)
            end
        end
    end
end


function ZombieMovement(enemy, dt)
    enemy.direction = vector2.sub(player.position, enemy.position)
    enemy.distanceFromPlayer = vector2.magnitude(enemy.direction)
    enemy.direction = vector2.normalize(enemy.direction)
    enemy.velocity = vector2.mult(enemy.direction, enemy.speed)
    CollisionWall(enemy, dt)

    if enemy.distanceFromPlayer < enemy.stop then
        local invertedvelocity = vector2.mult(enemy.velocity, -0.35)
        enemy.position = vector2.add(enemy.position, vector2.mult(invertedvelocity, dt))
    elseif enemy.distanceFromPlayer < enemy.stop + 50 and enemy.distanceFromPlayer > enemy.stop then
        enemy.position = enemy.position
    else
        enemy.position = vector2.add(enemy.position, vector2.mult(enemy.velocity, dt))
    end
end


function ZombieProjectileCreation(enemy)
    local direction = vector2.sub(player.position, enemy.position)
    direction = vector2.normalize(direction)
    local direction2 = vector2.new(math.cos(enemy.projectile.angle)*direction.x - math.sin(enemy.projectile.angle)*direction.y, math.sin(enemy.projectile.angle)*direction.x + math.cos(enemy.projectile.angle)*direction.y)
    local direction3 = vector2.new(math.cos(-enemy.projectile.angle)*direction.x - math.sin(-enemy.projectile.angle)*direction.y, math.sin(-enemy.projectile.angle)*direction.x + math.cos(-enemy.projectile.angle)*direction.y)
    local direction4 = vector2.new(math.cos(2*enemy.projectile.angle)*direction.x - math.sin(2*enemy.projectile.angle)*direction.y, math.sin(2*enemy.projectile.angle)*direction.x + math.cos(2*enemy.projectile.angle)*direction.y)
    local direction5 = vector2.new(math.cos(2*-enemy.projectile.angle)*direction.x - math.sin(2*-enemy.projectile.angle)*direction.y, math.sin(2*-enemy.projectile.angle)*direction.x + math.cos(2*-enemy.projectile.angle)*direction.y)
    
    return {shot = {{position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction, enemy.projectile.speed),
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction2, enemy.projectile.speed),
            damagedplayer = false},

            {position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction3, enemy.projectile.speed),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction4, enemy.projectile.speed),
            damagedplayer = false},
            
            {position = vector2.new(enemy.position.x, enemy.position.y),
            originalPosition = vector2.new(enemy.position.x, enemy.position.y),
            velocity = vector2.mult(direction5, enemy.projectile.speed),
            damagedplayer = false}}}
end

function ZombieProjectileSpawn(enemy)
    if enemy.distanceFromPlayer <= enemy.projectile.detectionRange and (enemy.projectile.cooldowntimer >= enemy.projectile.cooldown) then
        table.insert(enemy.projectile.bullet, ZombieProjectileCreation(enemy))
        enemy.projectile.cooldowntimer = 0
    end
end

function ZombieProjectileSpeed(enemy, dt)
    for i = 1, #enemy.projectile.bullet, 1 do
        for e = 1, #enemy.projectile.bullet[i].shot, 1 do
            if enemy.projectile.bullet[i].shot[e].position.x then
                enemy.projectile.bullet[i].shot[e].velocity = vector2.add(enemy.projectile.bullet[i].shot[e].velocity, vector2.mult(enemy.projectile.bullet[i].shot[e].velocity, dt))
                enemy.projectile.bullet[i].shot[e].position = vector2.add(enemy.projectile.bullet[i].shot[e].position, vector2.mult(enemy.projectile.bullet[i].shot[e].velocity, dt))
            end
        end
    end 
end

function ZombieProjectileDeletion(enemy)
    for i = 1, #enemy.projectile.bullet, 1 do
        if enemy.projectile.bullet[i] then
            for e = 1, #enemy.projectile.bullet[i].shot, 1 do
                if enemy.projectile.bullet[i].shot[e] then
                    local dist = vector2.sub(enemy.projectile.bullet[i].shot[e].position, enemy.projectile.bullet[i].shot[e].originalPosition)
                    dist = vector2.magnitude(dist)
                    if dist >= enemy.projectile.range or enemy.projectile.bullet[i].shot[e].damagedplayer == true then
                        table.remove(enemy.projectile.bullet[i].shot, e)
                    end
                    if #enemy.projectile.bullet[i].shot == 0 then
                        table.remove(enemy.projectile.bullet, i)
                    end
                end
            end
        end
    end
end

function ZombieDraw()
    for i = 1, #Zombie, 1 do
        if Zombie[i] and Zombie[i].hp > 0 then
            love.graphics.setColor(0,0.5,0)
            love.graphics.circle("fill", Zombie[i].position.x, Zombie[i].position.y, Zombie[i].hitbox)
            love.graphics.print(Zombie[i].hp, Zombie[i].position.x - 5, Zombie[i].position.y + 10)
        end
            ZombieDrawProjectiles(Zombie[i])
    end
end

function ZombieDrawProjectiles(Zombie)
    love.graphics.setColor(0, 1, 0)
    for i = 1, #Zombie.projectile.bullet, 1 do
        for e = 1, #Zombie.projectile.bullet[i].shot, 1 do
            love.graphics.circle("fill", Zombie.projectile.bullet[i].shot[e].position.x, Zombie.projectile.bullet[i].shot[e].position.y, Zombie.projectile.radius)
        end
    end
end