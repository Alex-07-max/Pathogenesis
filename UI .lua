Ui = Object.extend(Object)


function Ui.new(self)
    self.img = "sprites/cell ui/CELL UI 1.png"
    self.x = love.graphics.getWidth() / 2 
    self.y = 600

end

function Ui.draw(self)
    love.graphics.draw(self.img,self.x,self.y)
end