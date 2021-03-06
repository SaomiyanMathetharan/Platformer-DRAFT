Player = Entity:extend()

function Player:new(x, y)
    -- Player.super.new(self, x, y, "assets/player.png")
    Player.super.new(self, x, y, "assets/footballer_right.png")
    self.strength = 10

    self.weight = 50
    self.gravity = -40

    self.canJump = false
end

function Player:update(dt)
    Player.super.update(self, dt)

    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    elseif love.keyboard.isDown("up") then
        self.y = self.y - 200 * dt
    elseif love.keyboard.isDown("down") then
        self.y = self.y + 200 * dt
    end

    -- Prevent mid-jumps when coming off platforms
    if self.last.y ~= self.y then
        self.canJump = false
    end

    self.y = self.y + 200 * dt
end


function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

function Player:checkResolve(e, direction)
    if e:is(Box) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    end
    return true
end

function Player:jump()
    if self.canJump then
        self.gravity = -300
        self.canJump = false
    end
end