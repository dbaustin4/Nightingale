require "Player"

Menu = {
    title = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2-200),
    start = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2),
    quit = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2+40),
    select = 0,
    pressed = false
}

function MenuUpdate()
    if (love.mouse.getX() >= love.graphics.getWidth()/2-35 and love.mouse.getX() <= love.graphics.getWidth()/2-35 + 100) and (love.mouse.getY() >= love.graphics.getHeight()/2-10 and love.mouse.getY() <= love.graphics.getHeight()/2-10+34) then
        Menu.select = true
        if love.mouse.isDown("1") then
            Menu.pressed = true
        end
    end

    if (love.mouse.getX() >= love.graphics.getWidth()/2-35 and love.mouse.getX() <= love.graphics.getWidth()/2-35 + 100) and (love.mouse.getY() >= love.graphics.getHeight()/2+30 and love.mouse.getY() <= love.graphics.getHeight()/2+30+35) then
        Menu.select = false
        if love.mouse.isDown("1") then
            love.event.quit()
        end
    end

    if love.keyboard.isDown("c") and Menu.select == true then
        Menu.pressed = true
    elseif love.keyboard.isDown("c") and Menu.select == false then
        love.event.quit()
    end
    function love.keypressed(key)
        if key == "w" then
            Menu.select = true
        elseif key == "s" then
            Menu.select = false
        end
    end
end

function MenuDraw()
    love.graphics.setColor(1, 1, 1)
    if Menu.select == true then
        love.graphics.rectangle("line", love.graphics.getWidth()/2-35, love.graphics.getHeight()/2-10, 100, 34)
    elseif Menu.select == false then
        love.graphics.rectangle("line", love.graphics.getWidth()/2-35, love.graphics.getHeight()/2+30, 100, 35)
    end
    love.graphics.print("Nightingale", love.graphics.getWidth()/2-23, 150)
    love.graphics.print("Start", Menu.start.x, Menu.start.y)
    love.graphics.print("Quit", Menu.quit.x, Menu.quit.y)
end 