local Shake = {}

	Shake.Duration = 0
	Shake.Magnitude = 0
	Shake.Rotation = 0

function Shake:update(dt)
	if self.Duration > 0 then
        self.Duration = self.Duration - dt
        if self.Duration < 0 then
            self.Duration = 0
        end
    end
end

function Shake:start(duration, magnitude, rotation)
    self.Duration  = duration
    self.Magnitude = magnitude
    self.Rotation  = rotation
end

function Shake:push(camX, camY)
	love.graphics.push()
	
    if self.Duration > 0 then
        local t = shakeDuration
        local offsetX = (math.random() * 2 - 1) * self.Magnitude
        local offsetY = (math.random() * 2 - 1) * self.Magnitude
        local angle   = (math.random() * 2 - 1) * self.Rotation

        -- Вращаем вокруг центра экрана (или вокруг camX, camY)
        love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
        love.graphics.rotate(math.rad(angle))
        love.graphics.translate(-love.graphics.getWidth()/2, -love.graphics.getHeight()/2)

        love.graphics.translate(offsetX, offsetY)
    end
end

function Shake:pop()
	love.graphics.pop()
end

return Shake
