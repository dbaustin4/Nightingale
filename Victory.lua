require "Player"

Victory = {
    title = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2-200),
    quit = vector2.new(love.graphics.getWidth()/2, love.graphics.getHeight()/2),
    select = 0,
}

function VictoryUpdate()
    if (love.mouse.getX() >= love.graphics.getWidth()/2-35 and love.mouse.getX() <= love.graphics.getWidth()/2-35 + 100) and (love.mouse.getY() >= love.graphics.getHeight()/2-10 and love.mouse.getY() <= love.graphics.getHeight()/2-10+34) then
        Victory.select = true
        if love.mouse.isDown("1") then
            love.event.quit()
        end
    end

    if love.keyboard.isDown("c") and Victory.select == true then
        love.event.quit()
    end

    function love.keypressed(key)
        if key == "w" then
            Victory.select = true
        elseif key == "s" then
            Victory.select = true
        end
    end
end

function VictoryDraw()
    love.graphics.setColor(1, 1, 1)
    if Victory.select == true then
        love.graphics.rectangle("line", love.graphics.getWidth()/2-35, love.graphics.getHeight()/2-10, 100, 34)
    end
    love.graphics.print("Congratulations! You won!", love.graphics.getWidth()/2-70, 150)
    love.graphics.print("Quit", Victory.quit.x, Victory.quit.y)
end 