Boss = Object.extend(Object)

function Boss.new(self,x,y)
    self.x = x 
    self.y = y 
    self.img_open = love.graphics.newImage("sprites/evil_open.png")
    self.img_closed = love.graphics.newImage("sprites/evil_closed.png")
    self.x_w_open = self.img_open:getWidth()
    self.y_h_open = self.img_open:getHeight()
    self.x_w_closed = self.img_closed:getWidth()
    self.y_h_closed = self.img_closed:getHeight()
    self.touch = false
    self.rotation = math.rad(0)
    self.scale_x = 1
    self.scale_y = 1
    self.origin_x = self.x_w_closed / 2 
    self.origin_y = self.y_h_closed / 2
    self.state = "pursuit"
    self.timer = 2
    self.attack_time = 0
    self.health = 10000
    self.rot_speed = 1
    
end

function Boss.touch(self,pl_x,pl_y)
    
    if math.sqrt( (self.x - pl_x)^2 + (self.y - pl_y)^2 ) < 300 then
        self.state = "cought"
        return true 
    end

end

function Boss.touch_decoy(self,dec_x,dec_y)
    if math.sqrt( (self.x - dec_x)^2 + (self.y - dec_y)^2 ) < 300 then
        self.state = "cought_decoy"
        return true 
    else 
        self.state = "pursuit"
        return false 
    end

end

function Boss.r_speed(self)
    if self.health < 8500 then self.rot_speed = 2 end 
    if self.health < 6000 then self.rot_speed = 3 end 
    if self.health < 4000 then self.rot_speed = 4 end 
    if self.health < 3000 then self.rot_speed = 5 end 
    return self.rot_speed 
end


function Boss.update(self,dt,pl_x,pl_y,dec_x,dec_y,active)
   --if math.sqrt( (self.x_w_closed - pl_x)^2 + (self.y_h_closed - pl_y)^2 ) < 150 then
    if active == true then
        self.timer = self.timer - dt 
        dir_x = self.x - pl_x 
        dir_y = self.y - pl_y 
        Boss.r_speed(self)
        if Boss.touch(self,pl_x,pl_y) or Boss.touch_decoy(self,dec_x,dec_y)then
            self.touch = true 
        
        else self.touch = false end 

        if self.state == "cought_decoy" then 
            self.rotation = self.rotation + 0 * dt
        end

        if self.state == "cought" then 
            self.rotation = self.rotation + 0 * dt
        end
        if self.state == "pursuit" then 
            self.rotation = self.rotation + self.rot_speed * dt
            self.x = self.x - dir_x * 2 * dt  
            self.y = self.y - dir_y  * 2 * dt 
        end
   

   
        if self.state == "cought" and self.timer <= 0 then 
            self.attack_time = self.attack_time + dt
            self.state = "attack"
        
        end
        if self.state == "cought_decoy" and self.timer <= 0 then 
            self.attack_time = self.attack_time + dt
            self.state = "attack_decoy"
    
        end
        if self.attack_time > 5 then
            self.timer = 1
            self.attack_time = 0
        end
        if self.state == "pursuit" then 
            self.timer = 1 
            self.attack_time = 0 
        end
    end
   


end

function Boss.draw(self)
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.x, -self.y)
    
    if self.touch == false and self.state == "pursuit" then 
        love.graphics.draw(self.img_closed,self.x,self.y,self.rotation,self.scale_x,
                            self.scale_y,self.origin_x,self.origin_y)
    end
    if self.touch == true and self.state == "cought" then
        love.graphics.draw(self.img_open,self.x,self.y,self.rotation,self.scale_x,
                            self.scale_y,self.origin_x,self.origin_y)
    elseif self.touch == true and self.state == "cought_decoy" then
        love.graphics.draw(self.img_open,self.x,self.y,self.rotation,self.scale_x,
                            self.scale_y,self.origin_x,self.origin_y)
                            
    elseif self.touch == true and self.state == "attack" then 
        love.graphics.draw(self.img_closed,self.x,self.y,self.rotation,self.scale_x,
                            self.scale_y,self.origin_x,self.origin_y)
    elseif self.touch == true and self.state == "attack_decoy" then 
        love.graphics.draw(self.img_closed,self.x,self.y,self.rotation,self.scale_x,
                            self.scale_y,self.origin_x,self.origin_y)
    end
    love.graphics.pop()
    --love.graphics.print(self.health,600,800)
end