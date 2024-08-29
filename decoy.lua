Decoy = Object.extend(Object) 

function Decoy.new(self)
    self.decoy = love.graphics.newImage("sprites/decoy.png")
    self.x = -200 
    self.y = -200
    self.x_self = self.decoy:getWidth()--love.graphics.getWidth() / 2--self.img:getWidth()
    self.y_self = self.decoy:getHeight()--love.graphics.getHeight() / 2
    self.x_rotate = self.decoy:getWidth()
    self.y_rotate = self.decoy:getHeight()
    self.start_angle = 0
    self.start_pos = self.start_angle + .5*math.pi 
    self.speed = 800
    self.angle = 0
    self.x_scale = 0.5
    self.y_scale = 0.5
    self.origin_x = self.x_scale / 2
    self.origin_y = self.y_scale / 2
    self.timer = 0 
    self.switch = true 
    love.graphics.setNewFont("sprites/Glaure.ttf", 40)
    
    self.timer = 0
end

function Decoy.right(self,pl_x,pl_y,dt) 
    self.x = self.x + self.speed * dt 

end

function Decoy.left(self,pl_x,pl_y,dt) 
    self.x = self.x - self.speed * dt 

end



function Decoy.update(self,dt,pl_x,pl_y,pl_state)
    
    if pl_state == "free" then
   
        if love.mouse.isDown(2) then
            self.x = pl_x 
            self.y = pl_y 
        
        end
    

    
        
       
        if self.y > 300 then self.y = self.y - 800 * dt end
        if self.x >= 1700 then switch = false end 
        if self.x <= 150 then switch = true end 

        if switch == true then Decoy.right(self,pl_x,_pl_y,dt)end
        if switch == false then Decoy.left(self,pl_x,_pl_y,dt)end
    end

    
             

end


function Decoy.draw(self) 
    
    love.graphics.push()
    
    love.graphics.draw(self.decoy,self.x,self.y,self.angle ,
                            self.x_scale,self.y_scale,self.origin_x,self.origin_y)
    love.graphics.pop()
end