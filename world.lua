

-- Table used for creating doors
function CreateDoors(x, y, w, h)
    return {
        dpos = vector2.new(x, y),
        dsize = vector2.new(w, h),
        open = false
    }
end
-- Table used for creating walls
function CreateWalls(x, y, w, h)
    return {
        position = vector2.new(x, y),
        size = vector2.new(w, h)
    }
end

world = {} -- x,y,w,h
doors = {} -- x,y,w,h

-- Checks if a key is released, and removes or adds the doors
-- Draws the walls
function DrawWalls(world)
    for i = 1, #world, 1 do
        love.graphics.setColor(0.5, 0, 0)
        love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
    end
end
-- Draws the doors
function DrawDoors(doors)
    for i = 1, #doors, 1 do
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", doors[i].dpos.x, doors[i].dpos.y, doors[i].dsize.x, doors[i].dsize.y)
    end
end
function DrawSlime(slime)
    for i = 1, #slime, 1 do
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", slime[i].slimepos.x, slime[i].slimepos.y, slime[i].slimesize.x,
            slime[i].slimesize.y)
    end
end

function LoadMap()
    -- Walls and Doors

    --starting room
    world[1] = CreateWalls(-250, 200, 500, 50) --bottom
    world[2] = CreateWalls(-300, -200, 50, 450) --left
    world[3] = CreateWalls(250, -200, 50, 450) --right
    world[4] = CreateWalls(-300, -250, 200, 50) --TopLeft
    world[5] = CreateWalls(100, -250, 200, 50) --TopRight

    world[6] = CreateWalls(-150, -350, 50, 100) --Connection left
    world[7] = CreateWalls(100, -350, 50, 100) --Connection Right

    --room 1
    world[8] = CreateWalls(-400, -400, 300, 50) --BottomLeft
    world[9] = CreateWalls(100, -400, 300, 50) --BottomRight
    world[10] = CreateWalls(-400, -900, 50, 500) --Left
    world[11] = CreateWalls(350, -900, 50, 500) --Right
    world[12] = CreateWalls(-400, -950, 300, 50) --Top Left
    world[13] = CreateWalls(100, -950, 300, 50) --Top Right

    world[14] = CreateWalls(-150, -1050, 50, 100) --Connection left
    world[15] = CreateWalls(100, -1050, 50, 100) --Connection Right

    --room 2
    world[16] = CreateWalls(-400, -1100, 300, 50) --BottomLeft
    world[17] = CreateWalls(100, -1100, 300, 50) --BottomRight
    world[18] = CreateWalls(-400, -1600, 50, 500) --Left
    world[19] = CreateWalls(350, -1600, 50, 500) --Right
    world[20] = CreateWalls(-400, -1650, 300, 50) --Top Left
    world[21] = CreateWalls(100, -1650, 300, 50) --Top Right

    world[22] = CreateWalls(-150, -1750, 50, 100) --Connection left
    world[23] = CreateWalls(100, -1750, 50, 100) --Connection Right

    --room 3
    world[24] = CreateWalls(-400, -1800, 300, 50) --BottomLeft
    world[25] = CreateWalls(100, -1800, 300, 50) --BottomRight
    world[26] = CreateWalls(-400, -2300, 50, 500) --Left
    world[27] = CreateWalls(350, -2300, 50, 500) --Right
    world[28] = CreateWalls(-400, -2350, 800, 50) --Top

    --Doors Room 1
    doors[1] = CreateDoors(-100, -250, 200, 50)
    doors[2] = CreateDoors(-100, -400, 200, 50)

    --Doors room 2
    doors[3] = CreateDoors(-100, -950, 200, 50)
    doors[4] = CreateDoors(-100, -1100, 200, 50)

    --Doors room 3
    doors[5] = CreateDoors(-100, -1650, 200, 50)
    doors[6] = CreateDoors(-100, -1800, 200, 50)
end
