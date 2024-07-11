User_interface = Object.extend(Object)


function User_interface.new(self)
    self.img = "sprites/cell ui/CELL UI 1.png"
    self.x = love.graphics.getWidth() / 2 
    self.y = 600

end

function User_interface.draw(self)
    love.graphics.draw(self.img,self.x,self.y)
end