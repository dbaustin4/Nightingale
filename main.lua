require "Player"
require "Camera"
require "Enemy"
require "Bat"
require "Vector2"
require "PossessedArmor"
require "Zombie"
require "Wave"
require "Slime"
require "Start"
require "Death"
require "Victory"
require "conf"
require "collision"
require "world"

function love.load()
  ArenaCreate()
  PlayerCreate()
  LoadMap()
end

function love.update(dt)

    if love.keyboard.isDown("o") then
        arena1.complete = true
    end

    if arena3.complete == false then
        if Menu.pressed == false then
            MenuUpdate()
        elseif player.dead == true then
            DeathUpdate()
        else
            Room1(0, -650, dt)
            Room2(0, -1350, dt)
            Room3(0, -2050, dt)
            PlayerUpdate(dt)
        end
    elseif arena1.complete == true then
        VictoryUpdate()
    end
    

end

function love.draw()
    if arena3.complete == false then
        if Menu.pressed == false then
            MenuDraw()
        elseif player.dead == true then
            DeathDraw()
        else
            CameraUpdate()
            PlayerDraw()
            BatDraw()
            ZombieDraw()
            PossessedArmorDraw()
            SlimeDraw()
            DrawWalls(world)
            if arena1.playerin == true or arena2.playerin == true or arena3.playerin == true then
                DrawDoors(doors)
            end
            WarningDraw()
        end
    elseif arena1.complete == true then
        VictoryDraw()
    end
end