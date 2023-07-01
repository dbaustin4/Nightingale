require "Player"
require "Enemy"

Death = {
    select = 0,
    title = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2-200),
    restart = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2),
    quit = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2+40),
}

function DeathUpdate()
    if (love.mouse.getX() >= love.graphics.getWidth()/2-35 and love.mouse.getX() <= love.graphics.getWidth()/2-35 + 100) and (love.mouse.getY() >= love.graphics.getHeight()/2-10 and love.mouse.getY() <= love.graphics.getHeight()/2-10+34) then
        Death.select = true
        if love.mouse.isDown("1") then
            EnemyKill()
            ArenaCreate()
            PlayerCreate()
        end
    end

    if (love.mouse.getX() >= love.graphics.getWidth()/2-35 and love.mouse.getX() <= love.graphics.getWidth()/2-35 + 100) and (love.mouse.getY() >= love.graphics.getHeight()/2+30 and love.mouse.getY() <= love.graphics.getHeight()/2+30+35) then
        Death.select = false
        if love.mouse.isDown("1") then
            love.event.quit()
        end
    end

    if love.keyboard.isDown("c") and Death.select == true and player.dead == true then
        EnemyKill()
        ArenaCreate()
        PlayerCreate()
    elseif love.keyboard.isDown("c") and Death.select == false and player.dead == true then
        love.event.quit()
    end
    function love.keypressed(key)
        if key == "w" then
            Death.select = true
        elseif key == "s" then
            Death.select = false
        end
    end
end

function DeathDraw()
    love.graphics.setColor(1, 1, 1)
    if Death.select == true then
        love.graphics.rectangle("line", love.graphics.getWidth()/2-35, love.graphics.getHeight()/2-10, 100, 34)
    elseif Death.select == false then
        love.graphics.rectangle("line", love.graphics.getWidth()/2-35, love.graphics.getHeight()/2+30, 100, 35)
    end
    love.graphics.print("You have died :(", love.graphics.getWidth()/2-23, 150)
    love.graphics.print("Restart", Death.restart.x, Death.restart.y)
    love.graphics.print("Quit", Death.quit.x, Death.quit.y)
end 