


User_interface = Object.extend(Object)


function User_interface.new(self)
    self.img = love.graphics.newImage("sprites/cell ui/CELL UI 1.png")
    self.x = 2700
    self.y = 75
    self.bars = {}
    for i=1,7 do
        table.insert(self.bars, love.graphics.newImage("sprites/cell ui/CELL UI " .. i .. ".png"))
    end
    self.viral_health_bar = {}
    self.vir_x = 150
    self.vir_y = 1900
    for i  = 1 , 7 do 
        table.insert(self.viral_health_bar,love.graphics.newImage("sprites/viral particle ui/membrane"..i..".png"))
    end
end

function User_interface.calculate_ui_val(self,val)
    v = 1
    if val < 190 then
        v = 2
    end
    if val < 150 then
        v = 3 
    end
    if val < 120 then 
        v = 4 
    end
    if val < 60 then 
        v = 5 
    end
    if val < 20 then 
        v = 6
    end
    if val < 10 then 
        v = 7
    end
    
    return v
end

function User_interface.calculate_life(self,val) 
    v = 1 
    if val < 190 then
        v = 2
    end
    if val < 150 then
        v = 3 
    end
    if val < 120 then 
        v = 4 
    end
    if val < 60 then 
        v = 5 
    end
    if val < 20 then 
        v = 6
    end
    if val < 10 then 
        v = 7
    end
    
    return v
end

function User_interface.draw_viral_health(self,val) 
    love.graphics.push()
        love.graphics.scale(0.5,0.5)

        
        
            love.graphics.draw(self.viral_health_bar[val],self.vir_x,self.vir_y)
        
        
    love.graphics.pop()
end


function User_interface.draw(self,val)
    
    love.graphics.push()
        love.graphics.scale(0.3,0.3)

        
        
            love.graphics.draw(self.bars[val],self.x,self.y)
        
        
    love.graphics.pop()
    
end


