

Player = Object.extend(Object)

function Player.new(self)
    self.animate = require("libraries/anim8")
    self.img = love.graphics.newImage("sprites/Pahtogen_idle_00.png")
    self.x = self.img:getWidth()--love.graphics.getWidth() / 2--self.img:getWidth()
    self.y = self.img:getHeight()--love.graphics.getHeight() / 2
    self.x_rotate = self.img:getWidth()
    self.y_rotate = self.img:getHeight()
    self.start_angle = 0
    self.start_pos = self.start_angle + .5*math.pi 
    self.speed = 1500
    self.angle = 0
    self.x_scale = 0.5
    self.y_scale = 0.5
    self.origin_x = self.x / 2
    self.origin_y = self.y / 2
    self.sprite_sheet = love.graphics.newImage("sprites/Pathogen_idle_sprite.png")
    self.grid = self.animate.newGrid(249,300,self.sprite_sheet:getWidth(),self.sprite_sheet:getHeight())
    self.animations = {}
    self.animations.idle = self.animate.newAnimation(self.grid('1-7',1,'2-7',2,'3-7',3,'4-6',4), 0.05)
    self.health = 5000
    self.state = "free"
    self.timer = 0
    self.health_ui = love.graphics.newImage("sprites/player_ui.png")
end

function Player.rotate(self,dt)
    local mouse_x, mouse_y = love.mouse.getPosition()
    local rotation_speed = 10
    self.angle = math.atan2(mouse_y - self.y, mouse_x - self.x) 

    --cos = math.cos(self.angle)
    --sin = math.sin(self.angle)

    --Make the circle move towards the mouse
    --Player.player_x = Player.player_x + Player.speed * cos * delta
    --Player.player_y = Player.player_y + Player.speed * sin * delta   
    
end



function Player.move(self, dt,en_x,en_y)
    local length = math.sqrt(self.x^2 + self.y^2)
    
    
    if love.keyboard.isDown("right","d") then
            
            if Player.has_collided(self,en_x,en_y) < 150 then   
                if self.x < en_x then 
                    self.x = en_x - 180
                end
            else 
                self.x = self.x + (self.speed * dt)
            end
    end

    
    if love.keyboard.isDown("left","a") then
        if Player.has_collided(self,en_x,en_y) < 150 then   
            if self.x > en_x then 
                self.x = en_x + 180 
            end
        else 
            self.x = self.x - (self.speed * dt)
        end
        
       
    end
    --if love.keyboard.isDown("up","w") then 
    --    if Player.has_collided(self,en_x,en_y) < 170 then   
     --       if self.y > en_y  then 
     --           self.y = en_y + 220
     --       end
    --    else 
    --        self.y = self.y - (self.speed * dt)
    --    end
       
      
    --end
    --if love.keyboard.isDown("down","s") then 
    --    if Player.has_collided(self,en_x,en_y) < 150 then   
    --        if self.y < en_y then 
    --            self.y = en_y - 220
    --        end
     --   else 
    --        self.y = self.y + (self.speed * dt)
     --   end
        
        
   -- end


end
function Player.move2(self,boss_state,b_x,b_y,dt)
    
    if boss_state == "pursuit" or boss_state == "cought_decoy" or 
        boss_state == "attack_decoy" then
    if love.keyboard.isDown("right","d") then
        self.x = self.x + (self.speed * dt)
    end
    if love.keyboard.isDown("left","a") then
        self.x = self.x - (self.speed * dt)
    end
    if love.keyboard.isDown("up","w") then 
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isDown("down","s") then
        self.y = self.y + (self.speed * dt)
    end
    elseif boss_state == "cought" then 
        self.x = b_x 
        self.y = b_y 
        
    end
    
    if self.state == "cought" and love.mouse.isDown(2)  then 
        if can_escape then
        self.state = "escaped"
        self.x = self.x + 500 
        end
        
        
    end

    if boss_state == "attack" then self.state = "trapped" end
    if boss_state == "attack_decoy" then self.state = "free" end
    
    if boss_state == "cought" then self.state = "cought"  end
    if self.state == "trapped" then self.health = self.health - 1 end 
    if self.state == "escaped" then 
        self.timer = self.timer + dt
        if self.timer > 4 then
        self.state = "free"
        self.timer = 0 
        end
        
    end
    
    

end

function Player.knockback(self,bl_x,bl_y,dt) 
    -- bullets knockback
    local dir = math.atan2(self.y - bl_y, self.x - bl_x)
    local cos = math.cos(dir) 
    local sin = math.sin(dir)
    if Player.is_collision(self,bl_x,bl_y) < 80 then 
        self.x = self.x + 2000 * cos * dt  
        self.y = self.y + 2000 * sin * dt
    end 
    --bullets knockback
end

function Player.has_collided(self,en_x,en_y)
    return math.sqrt( (en_x - self.x)^2 + (en_y - self.y)^2 )
end


function Player.play_animation(self,dt)
    self.animations.idle:update(dt)
end



function Player.draw(self)
    --rotate a quarter for main tendril positioning , align with cursor
    --love.graphics.print(self.state,200,200)
    love.graphics.push()
        
        love.graphics.translate(self.x, self.y)
	    love.graphics.rotate(self.start_pos)
	    love.graphics.translate(-self.x, -self.y)
    
    --draw animation
    
    
    
    if self.state ~= "trapped"  then
        self.animations.idle:draw(self.sprite_sheet,self.x,self.y,self.angle ,self.x_scale,self.y_scale,self.origin_x,self.origin_y)
    end
    
    love.graphics.pop()
    
    --love.graphics.draw(self.img,self.x,self.y,self.rotation,self.x_scale,self.y_scale,self.origin_x,self.origin_y)
    --love.graphics.rectangle("line" , self.x / 2, self.y / 2, self.angle, 249,300)
    --love.graphics.line(self.x,self.y,love.mouse.getX(),love.mouse.getY())
    --love.graphics.line(self.x,self.y,love.mouse.getX(),self.y)
    --love.graphics.line(self.x,self.y,self.x,love.mouse.getY())
    --love.graphics.print(self.angle,0,0)
    

end

