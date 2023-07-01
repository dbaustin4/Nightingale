require "Player"

function EnemyProjectileCooldown(enemy, dt)
    if enemy.projectile.cooldowntimer <= enemy.projectile.cooldown then
        enemy.projectile.cooldowntimer = enemy.projectile.cooldowntimer + 1*dt
    end
end

function EnemyDead()
    if #PossessedArmor == 0 and #Zombie == 0 and #Bat == 0 and #Slime == 0 then
        return(true)
    else
        return(false)
    end
end

function EnemyKill()
    while #Bat ~= 0 do
        table.remove(Bat, 1)
    end
    while #PossessedArmor ~= 0 do
        table.remove(PossessedArmor, 1)
    end
    while #Zombie ~= 0 do
        table.remove(Zombie, 1)
    end
    while #Slime ~= 0 do
        table.remove(Slime, 1)
    end
end

function CollisionWall(entity, dt)

    entity.collision = vector2.new(entity.position.x - entity.hitbox, entity.position.y - entity.hitbox)
    for i = 1, #world, 1 do
        local collisiondirection = GetBoxCollisionDirection(entity.collision.x, entity.collision.y, entity.hitbox*2,
                                       entity.hitbox*2, world[i].position.x, world[i].position.y, world[i].size.x,
                                       world[i].size.y)
        local collisiondirectionnormalized = vector2.normalize(collisiondirection)

        if (collisiondirectionnormalized.x ~= 0) or (collisiondirectionnormalized.y ~= 0) then
            if (collisiondirectionnormalized.y ~= 0 and entity.direction.y ~= collisiondirectionnormalized.y) then
                -- collision on y
                entity.velocity.y = 0
            end

            if (collisiondirectionnormalized.x ~= 0 and entity.direction.x ~= collisiondirectionnormalized.x) then
                 --collision on x
                entity.velocity.x = 0
            end

            if math.ceil(collisiondirection.x) ~= 0 then
                entity.position.x = entity.position.x + collisiondirection.x
            end

            if math.ceil(collisiondirection.y) ~= 0 then
                entity.position.y = entity.position.y + collisiondirection.y
            end
        end
    end

    love.graphics.setColor(0.5, 0, 0)

    if arena1.playerin == true or arena2.playerin == true or arena3.playerin == true then
        for i = 1, #doors, 1 do
            local collisiondirection = GetBoxCollisionDirection(entity.collision.x, entity.collision.y, entity.hitbox*2,
                                                    entity.hitbox*2, doors[i].dpos.x, doors[i].dpos.y, doors[i].dsize.x,
                                                    doors[i].dsize.y)
            local collisiondirectionnormalized = vector2.normalize(collisiondirection)
                
            if (collisiondirectionnormalized.x ~= 0) or (collisiondirectionnormalized.y ~= 0) then
                if (collisiondirectionnormalized.y ~= 0 and entity.direction.y ~= collisiondirectionnormalized.y) then
                                -- collision on y
                    entity.velocity.y = 0
                end
            end
            if (collisiondirectionnormalized.x ~= 0 and entity.direction.x ~= collisiondirectionnormalized.x) then
                                --collision on x
                entity.velocity.x = 0
            end
                
            if math.ceil(collisiondirection.x) ~= 0 then
                entity.position.x = entity.position.x + collisiondirection.x
            end
                
            if math.ceil(collisiondirection.y) ~= 0 then
                entity.position.y = entity.position.y + collisiondirection.y
            end
        end
    end
end