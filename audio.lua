Audio = Object.extend(Object) 

function Audio.new(self)
self.sound = {}
self.sound.ambience = love.audio.newSource("sounds/ambience.wav","stream")
self.sound.shoot = love.audio.newSource("sounds/shoot.wav","static")
self.sound.decoy = love.audio.newSource("sounds/decoy.wav","static")
end


function Audio.update(self)
    if love.mouse.isDown(1) then 
        self.sound.shoot : play()
    end
end