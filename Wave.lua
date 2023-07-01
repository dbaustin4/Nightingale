require "Player"
require "Bat"

Warning = {}

function WarningCreate(x, y)
    return {
        position = vector2.new(x, y),
        radius = 20
    }
end

function WarningInsert(x, y)
    table.insert(Warning, WarningCreate(x, y))
end

function WarningDraw()
    love.graphics.setColor(1, 1, 0, 0.5)
    for i = 0, #Warning, 1 do
        if Warning[i] then
            love.graphics.circle("fill", Warning[i].position.x, Warning[i].position.y, Warning[i].radius )
        end
    end
end


function ArenaCreate()
arena1 = {
    playerin = false,
    complete = false,
    counter = 0,
    cooldown = 3,
    wave1 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave2 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave3 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    }
}

arena2 = {
    playerin = false,
    complete = false,
    counter = 0,
    cooldown = 3,
    wave1 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave2 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave3 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    }
}

arena3 = {
    playerin = false,
    complete = false,
    counter = 0,
    cooldown = 3,
    wave1 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave2 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    },
    wave3 ={
        prespawn = false,
        spawn = false,
        warning = false,
        complete = false
    }
}
end

function Room1(x, y, dt)

    --check if player enters room 1
    if arena1.playerin == false and arena1.complete == false then
        local dist = vector2.sub(vector2.new(x,y), player.position)
        dist = vector2.magnitude(dist)
        if dist <= 100 then
            arena1.playerin = true
        end
    end


    if arena1.playerin == true and arena1.complete == false then
    --wave 1
        --preparing spawns
        if arena1.counter < arena1.cooldown and arena1.wave1.prespawn == false then
            arena1.counter = arena1.counter + 1*dt
            if arena1.wave1.warning == false then
                WarningInsert(x+300, y+200)
                WarningInsert(x-300, y+200)
                arena1.wave1.warning = true
            end
        end
        if arena1.counter >= arena1.cooldown and arena1.wave1.prespawn == false then
            arena1.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena1.wave1.prespawn = true
        end

        --spawning
        if arena1.wave1.spawn == false and arena1.wave1.prespawn == true then
            BatCreate(x+300, y+200)
            BatCreate(x-300, y+200)
            arena1.wave1.spawn = true
        end
        if arena1.wave1.complete == false and arena1.wave1.spawn == true then
            BatUpdate(dt)
        end
        if EnemyDead() and arena1.wave1.complete == false and arena1.wave1.spawn == true then
            arena1.wave1.complete = true
            --arena1.playerin = false
        end


        --wave 2
        --preparing spawns
        if arena1.counter < arena1.cooldown and arena1.wave2.prespawn == false and arena1.wave1.complete == true then
            arena1.counter = arena1.counter + 1*dt
            if arena1.wave2.warning == false then
                WarningInsert(x, y)
                arena1.wave2.warning = true
            end
        end
        if arena1.counter >= arena1.cooldown and arena1.wave2.prespawn == false then
            arena1.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena1.wave2.prespawn = true
        end

        --spawning
        if arena1.wave2.spawn == false and arena1.wave2.prespawn == true then
            ZombieCreate(x, y)
            arena1.wave2.spawn = true
        end
        if arena1.wave2.complete == false and arena1.wave2.spawn == true then
            ZombieUpdate(dt)
        end
        if EnemyDead() and arena1.wave2.complete == false and arena1.wave2.spawn == true then
            arena1.wave2.complete = true
        end


        --wave 3
        --preparing spawns
        if arena1.counter < arena1.cooldown and arena1.wave3.prespawn == false and arena1.wave2.complete == true then
            arena1.counter = arena1.counter + 1*dt
            if arena1.wave3.warning == false then
                WarningInsert(x+300, y-200)
                WarningInsert(x-300, y-200)
                WarningInsert(x, y)
                arena1.wave3.warning = true
            end
        end
        if arena1.counter >= arena1.cooldown and arena1.wave3.prespawn == false then
            arena1.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena1.wave3.prespawn = true
        end

        --spawning
        if arena1.wave3.spawn == false and arena1.wave3.prespawn == true then
            BatCreate(x+300, y-200)
            BatCreate(x-300, y-200)
            ZombieCreate(x, y)
            arena1.wave3.spawn = true
        end
        if arena1.wave3.complete == false and arena1.wave3.spawn == true then
            BatUpdate(dt)
            ZombieUpdate(dt)
        end
        if EnemyDead() and arena1.wave3.complete == false and arena1.wave3.spawn == true then
            arena1.wave3.complete = true
        end

        --ending arena1

        if arena1.wave3.complete == true and arena1.complete == false then
            arena1.complete = true
            arena1.playerin = false
        end
    end
end


function Room2(x, y, dt)

 --check if player enters room 2
    if arena2.playerin == false and arena2.complete == false and arena1.complete == true then
        local dist = vector2.sub(vector2.new(x,y), player.position)
        dist = vector2.magnitude(dist)
        if dist <= 100 then
            arena2.playerin = true
        end
    end


    if arena2.playerin == true and arena2.complete == false then
    --wave 1
        --preparing spawns
        if arena2.counter < arena2.cooldown and arena2.wave1.prespawn == false then
            arena2.counter = arena2.counter + 1*dt
            if arena2.wave1.warning == false then
                WarningInsert(x+300, y-200)
                WarningInsert(x-300, y-200)
                arena2.wave1.warning = true
            end
        end
        if arena2.counter >= arena2.cooldown and arena2.wave1.prespawn == false then
            arena2.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena2.wave1.prespawn = true
        end

        --spawning
        if arena2.wave1.spawn == false and arena2.wave1.prespawn == true then
            ZombieCreate(x+300, y-200)
            ZombieCreate(x-300, y-200)
            arena2.wave1.spawn = true
        end
        if arena2.wave1.complete == false and arena2.wave1.spawn == true then
            ZombieUpdate(dt)
        end
        if EnemyDead() and arena2.wave1.complete == false and arena2.wave1.spawn == true then
            arena2.wave1.complete = true
            --arena2.playerin = false
        end


        --wave 2
        --preparing spawns
        if arena2.counter < arena2.cooldown and arena2.wave2.prespawn == false and arena2.wave1.complete == true then
            arena2.counter = arena2.counter + 1*dt
            if arena2.wave2.warning == false then
                WarningInsert(x, y-200)
                arena2.wave2.warning = true
            end
        end
        if arena2.counter >= arena2.cooldown and arena2.wave2.prespawn == false then
            arena2.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena2.wave2.prespawn = true
        end

        --spawning
        if arena2.wave2.spawn == false and arena2.wave2.prespawn == true then
            PossessedArmorCreate(x, y-200)
            arena2.wave2.spawn = true
        end
        if arena2.wave2.complete == false and arena2.wave2.spawn == true then
            PossessedArmorUpdate(dt)
        end
        if EnemyDead() and arena2.wave2.complete == false and arena2.wave2.spawn == true then
            arena2.wave2.complete = true
        end


        --wave 3
        --preparing spawns
        if arena2.counter < arena2.cooldown and arena2.wave3.prespawn == false and arena2.wave2.complete == true then
            arena2.counter = arena2.counter + 1*dt
            if arena2.wave3.warning == false then
                WarningInsert(x, y-200)
                WarningInsert(x-200, y+200)
                WarningInsert(x+200, y+200)
                arena2.wave3.warning = true
            end
        end
        if arena2.counter >= arena2.cooldown and arena2.wave3.prespawn == false then
            arena2.counter = 0
            while #Warning ~= 0 do
                table.remove(Warning, 1)
            end
            arena2.wave3.prespawn = true
        end

        --spawning
        if arena2.wave3.spawn == false and arena2.wave3.prespawn == true then
            PossessedArmorCreate(x, y-200)
            BatCreate(x-200, y+200)
            BatCreate(x+200, y+200)
            arena2.wave3.spawn = true
        end
        if arena2.wave3.complete == false and arena2.wave3.spawn == true then
            PossessedArmorUpdate(dt)
            BatUpdate(dt)
        end
        if EnemyDead() and arena2.wave3.complete == false and arena2.wave3.spawn == true then
            arena2.wave3.complete = true
        end

        --ending arena2

        if arena2.wave3.complete == true and arena2.complete == false then
            arena2.complete = true
            arena2.playerin = false
        end
    end
end


function Room3(x, y, dt)

    --check if player enters room 2
       if arena3.playerin == false and arena3.complete == false and arena2.complete == true then
           local dist = vector2.sub(vector2.new(x,y), player.position)
           dist = vector2.magnitude(dist)
           if dist <= 100 then
               arena3.playerin = true
           end
       end
   
   
       if arena3.playerin == true and arena3.complete == false then
       --wave 1
           --preparing spawns
           if arena3.counter < arena3.cooldown and arena3.wave1.prespawn == false then
               arena3.counter = arena3.counter + 1*dt
               if arena3.wave1.warning == false then
                   WarningInsert(x+200, y+200)
                   WarningInsert(x-200, y+200)
                   arena3.wave1.warning = true
               end
           end
           if arena3.counter >= arena3.cooldown and arena3.wave1.prespawn == false then
               arena3.counter = 0
               while #Warning ~= 0 do
                   table.remove(Warning, 1)
               end
               arena3.wave1.prespawn = true
           end
   
           --spawning
           if arena3.wave1.spawn == false and arena3.wave1.prespawn == true then
               BatCreate(x+200, y+200)
               SlimeCreate(x-200, y+200)
               arena3.wave1.spawn = true
           end
           if arena3.wave1.complete == false and arena3.wave1.spawn == true then
               BatUpdate(dt)
               SlimeUpdate(dt)
           end
           if EnemyDead() and arena3.wave1.complete == false and arena3.wave1.spawn == true then
               arena3.wave1.complete = true
               --arena3.playerin = false
           end
   
   
           --wave 2
           --preparing spawns
           if arena3.counter < arena3.cooldown and arena3.wave2.prespawn == false and arena3.wave1.complete == true then
               arena3.counter = arena3.counter + 1*dt
               if arena3.wave2.warning == false then
                   WarningInsert(x, y)
                   WarningInsert(x+200, y+200)
                   WarningInsert(x-200, y+200)
                   WarningInsert(x, y-200)
                   arena3.wave2.warning = true
               end
           end
           if arena3.counter >= arena3.cooldown and arena3.wave2.prespawn == false then
               arena3.counter = 0
               while #Warning ~= 0 do
                   table.remove(Warning, 1)
               end
               arena3.wave2.prespawn = true
           end
   
           --spawning
           if arena3.wave2.spawn == false and arena3.wave2.prespawn == true then
               SlimeCreate(x, y)
               BatCreate(x+200, y+200)
               BatCreate(x-200, y+200)
               PossessedArmorCreate(x, y-200)
               arena3.wave2.spawn = true
           end
           if arena3.wave2.complete == false and arena3.wave2.spawn == true then
               SlimeUpdate(dt)
               BatUpdate(dt)
               PossessedArmorUpdate(dt)
           end
           if EnemyDead() and arena3.wave2.complete == false and arena3.wave2.spawn == true then
               arena3.wave2.complete = true
           end
   
   
           --wave 3
           --preparing spawns
           if arena3.counter < arena3.cooldown and arena3.wave3.prespawn == false and arena3.wave2.complete == true then
               arena3.counter = arena3.counter + 1*dt
               if arena3.wave3.warning == false then
                   WarningInsert(x-200, y)
                   WarningInsert(x+200, y)
                   WarningInsert(x, y-200)
                   WarningInsert(x+200, y+200)
                   WarningInsert(x-200, y+200)
                   WarningInsert(x, y+200)
                   arena3.wave3.warning = true
               end
           end
           if arena3.counter >= arena3.cooldown and arena3.wave3.prespawn == false then
               arena3.counter = 0
               while #Warning ~= 0 do
                   table.remove(Warning, 1)
               end
               arena3.wave3.prespawn = true
           end
   
           --spawning
           if arena3.wave3.spawn == false and arena3.wave3.prespawn == true then
               BatCreate(x-200, y)
               BatCreate(x+200, y)
               PossessedArmorCreate(x, y-200)
               SlimeCreate(x+200, y+200)
               SlimeCreate(x-200, y+200)
               ZombieCreate(x, y+200)
               arena3.wave3.spawn = true
           end
           if arena3.wave3.complete == false and arena3.wave3.spawn == true then
               BatUpdate(dt)
               PossessedArmorUpdate(dt)
               SlimeUpdate(dt)
               ZombieUpdate(dt)
           end
           if EnemyDead() and arena3.wave3.complete == false and arena3.wave3.spawn == true then
               arena3.wave3.complete = true
           end
   
           --ending arena3
   
           if arena3.wave3.complete == true and arena3.complete == false then
               arena3.complete = true
               arena3.playerin = false
           end
       end
   end