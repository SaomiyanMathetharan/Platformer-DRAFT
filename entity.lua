--! file: entity.lua
Entity = Object:extend()

function Entity:new(x, y, image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    -- Add a default value to the variable
    self.strength = 0
    -- Temp is short for temporary
    self.tempStrength = 0
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    -- Reset the strength
    self.tempStrength = self.strength
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end


function Entity:wasVerticallyAligned(e)
    -- It's basically the collisionCheck function, but with the x and width part removed.
    -- It uses last.y because we want to know this from the previous position
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAligned(e)
    -- It's basically the collisionCheck function, but with the y and height part removed.
    -- It uses last.x because we want to know this from the previous position
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end


function Entity:checkCollision(e)
    -- e will be the other entity with which we check if there is collision.
    -- This is the final compact version from chapter 13
    return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end

function Entity:resolveCollision(e)
    if self.tempStrength > e.tempStrength then
        return e:resolveCollision(self)
    end

    if self:checkCollision(e) then
        self.tempStrength = e.tempStrength
        if self:wasVerticallyAligned(e) then
            if self.x + self.width/2 < e.x + e.width/2 then
                -- Call checkResolve for both parties.
                local a = self:checkResolve(e, "right")
                local b = e:checkResolve(self, "left")
                -- If both a and b are true then resolve the collision.
                if a and b then
                    self:collide(e, "right")
                end
            else
                local a = self:checkResolve(e, "left")
                local b = e:checkResolve(self, "right")
                if a and b then
                    self:collide(e, "left")
                end
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height/2 < e.y + e.height/2 then
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "bottom")
                end
            else
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "top")
                end
            end
        end
        return true
    end
    return false
end

function Entity:checkResolve(e, direction)
    return true
end

-- When the entity collides with something with his right side
function Entity:collide(e, direction)
    if direction == "right" then
        local pushback = self.x + self.width - e.x
        self.x = self.x - pushback
    elseif direction == "left" then
        local pushback = e.x + e.width - self.x
        self.x = self.x + pushback
    elseif direction == "bottom" then
        local pushback = self.y + self.height - e.y
        self.y = self.y - pushback
        self.gravity = 0
    elseif direction == "top" then
        local pushback = e.y + e.height - self.y
        self.y = self.y + pushback
    end
end