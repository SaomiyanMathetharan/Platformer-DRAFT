--! file: main.lua
function love.load()
    Object = require "libraries/classic"
    require "entity"
    require "player"
    require "wall"
    require "box"

    player = Player(100, 390)
    box = Box(400, 150)

    objects = {}
    table.insert(objects, player)
    table.insert(objects, box)

    walls = {}


-- Test Map Types
    map1 = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }

    map2 = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1},
        {1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }

    -- map = map1
    map = map2

    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w == 1 then
                -- Add all the walls to the walls table instead.
                table.insert(walls, Wall((j-1)*50, (i-1)*50))
            end
        end
    end
end

function love.update(dt)
    for i,v in ipairs(objects) do
        v:update(dt)
    end

    -- Update the walls
    ---- ADD THIS
    for i,v in ipairs(walls) do
        v:update(dt)
    end
    -------------

    local loop = true
    -- It just might happen that in a weird occasion we keep getting collision
    -- somehow and we get stuck in an infinite loop!
    local limit = 0

    while loop do
        loop = false

        limit = limit + 1
        if limit > 100 then
            break
        end

        for i=1,#objects-1 do
            for j=i+1,#objects do
                local collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end

        -- For each object check collision with every wall.
        ---- ADD THIS
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                local collision = object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end
        -------------
    end
end

function love.draw()
    for i,v in ipairs(objects) do
        v:draw()
    end

    -- Draw the walls
    for i,v in ipairs(walls) do
        v:draw()
    end
end


function love.keypressed(key)
    -- Let the player jump when the up-key is pressed
    if key == "up" then
        player:jump()
    end
end