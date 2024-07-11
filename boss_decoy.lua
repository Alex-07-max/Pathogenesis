Boss_Decoy = Object.extend(Object) 

function Boss_Decoy.new(self)
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
    self.state = "inert"
    self.timer = 0
end




function Boss_Decoy.update(self,dt,b_x,b_y,player_state,boss_state)
    self.state = boss_state
    if player_state == "cought" then 
   
        if love.mouse.isDown(2) then
            self.x = b_x 
            self.y = b_y 
        
        end
    end
             

end


function Boss_Decoy.draw(self) 
    
    love.graphics.push()
    if self.state ~= "attack_decoy" then
    love.graphics.draw(self.decoy,self.x,self.y,self.angle ,
                            self.x_scale,self.y_scale,self.origin_x,self.origin_y)
    end
    love.graphics.pop()
end