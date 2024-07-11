
Enemies = Object.extend(Object)

function Enemies.new(self)

self.animate = require("libraries/anim8")
self.img = love.graphics.newImage("sprites/evil pathogen_00.png")
self.x_2 = x
self.y_2 = y
self.x = self.img:getWidth()
self.y = self.img:getHeight()
self.x_start = 457
self.y_start = -650
self.angle = 0
self.start_angle = 0
self.start_pos = self.start_angle +.5*math.pi
self.x_scale = 0.5 
self.y_scale = 0.5
self.origin_x = self.x / 2 
self.origin_y = self.y / 2
self.sprite_sheet = love.graphics.newImage("sprites/Evil_pathogen.png")
self.death_anim = love.graphics.newImage("sprites/ev_pathogen_death.png")
self.grid = self.animate.newGrid(283,309,self.sprite_sheet:getWidth(),self.sprite_sheet:getHeight())
self.death_anim_grid = self.animate.newGrid(258,284,self.death_anim:getWidth(),self.death_anim:getHeight())
self.animations = {}
self.animations.move = self.animate.newAnimation(self.grid('1-7',1,'2-7',2,'3-7',3,'4-6',4), 0.05)
self.animations.die = self.animate.newAnimation(self.death_anim_grid('1-7',1,'2-7',2,'3-7',3,'4-6',4), 0.01)
self.timer = 4
self.health = 200
self.dead = false
self.move = false   
self.direction = math.atan2(0,0)   
self.speed = 3000
self.timer = 0 
self.cells = {}
end

function Enemies.get_cells_in_table(self,pl_y,dt)
    time = 0 
    time = time + dt
    
    table.insert(self.cells,{x = self.x,
                             y = self.y,
                             
                             speed = self.speed,
                             dead = self.dead,
                             x_2 = self.x_2,
                             y_2 = self.y_2,
                             start_pos = self.start_pos,
                             angle = self.angle,
                             x_scale = self.x_scale,
                             y_scale = self.y_scale,
                             origin_x = self.origin_x,
                             origin_y = self.origin_y})

    for i,v in ipairs(self.cells) do 
        if time > 2 then
            v.y = v.y + 1 * dt 
            time = 0 
        end
        
    end

end


function Enemies.has_collided(self,x,y)
    if math.sqrt((x - self.x_2)^2 + (y - self.y_2)^2 ) < 80 then 
        return true 
    else 
        return false
    end
end



function Enemies.rotate(self,inherit_x,inherit_y,dt)
    
   
    self.angle = math.atan2(inherit_y - self.y_2, inherit_x - self.x_2)
end

function Enemies.move(self,inherit_x,inherit_y,dt)
    local pl_top = false 
    local pl_middle = false 
    local pl_bottom = false 
    local cell_top = false 
    local cell_middle = false 
    local cell_bottom = false 

    if inherit_y < 360 then 
        pl_top = true 
        pl_middle = false 
        pl_bottom = false 
    elseif inherit_y > 360 and inherit_y < 720 then 
        pl_top = false 
        pl_middle = true 
        pl_bottom = false 
    elseif inherit_y > 720 and inherit_y < 1080 then 
        pl_top = false 
        pl_middle = false 
        pl_bottom = true 
    end

    if self.y_2 < 360 then 
        cell_top = true 
        cell_middle = false 
        cell_bottom = false 
    elseif self.y_2 > 360 and self.y_2 < 720 then 
        cell_top = false 
        cell_middle = true 
        cell_bottom = false 
    elseif self.y_2 > 720 and self.y_2 < 1080 then 
        cell_top = false
        cell_middle = false 
        cell_bottom = true
    end

    distance_y = self.y_2 - inherit_y 

    if self.y_2 < inherit_y and cell_top == true and pl_top == true then 
        self.y_2 = self.y_2 - distance_y * dt
    elseif self.y_2 > inherit_y and cell_top == true and pl_top == true then 
       self.y_2 = self.y_2 - distance_y * dt
    
    elseif self.y_2 < inherit_y and cell_middle == true and pl_middle == true then 
        self.y_2 = self.y_2 - distance_y * dt
    elseif self.y_2 > inherit_y and cell_middle == true and pl_middle == true then 
       self.y_2 = self.y_2 - distance_y * dt   

    elseif self.y_2 < inherit_y and cell_bottom == true and pl_bottom == true then 
        self.y_2 = self.y_2 - distance_y * dt
    elseif self.y_2 > inherit_y and cell_bottom == true and pl_bottom == true then 
       self.y_2 = self.y_2 - distance_y * dt   

    --elseif self.y_2 > inherit_y and self.y_2 < 720  and inherit_y > -320 then
    --    self.y_2 = self.y_2 - distance_y * dt
    end
    
    
   
end
    
function Enemies.move2(self,inherit_x,inherit_y,dt)
    if self.y_2 - inherit_y < -600 then 
        self.y_2 = self.y_2 + 200 * dt
    end
end


function Enemies.die_animate(self,dt)
    self.animations.die:update(dt)
end

function Enemies.move_animate(self,dt)
    self.animations.move:update(dt)
    
end

function Enemies.update(self,inherit_x,inherit_y,dt)
    --self.timer = self.timer + dt  
   -- if self.timer > 3 then 
       
    --    self.timer = 0 
    --
    self.animations.move:update(dt)
    self.animations.die:update(dt)
    --Enemies.die_animate(self,dt)
    Enemies.move_animate(self,dt)
    --Enemies.move(self,inherit_x,inherit_y,dt)
    --Enemies.move2(self,inherit_x,inherit_y,dt)
    --Enemies.rotate(self,inherit_x,inherit_y,dt)
    --if self.health <= 0 then 
    --    self.dead = true 
    --end 
    for i,v in ipairs(self.cells) do 
        v.y = v.y + 200 * dt
    end
    

    
end

function Enemies.death_particles(self,x,y,dead)
    local x = x 
    local y = y
    if dead == true then 
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", x, y, 5, 5) 
    end
end

function Enemies.draw(self)
    --love.graphics.print(inherit_x - self.x, 200,200)
   
    love.graphics.push()
        for i,v in ipairs(self.cells) do 
           -- love.graphics.translate(v.x_2,v.y_2)
           -- love.graphics.rotate(v.start_pos)
           -- love.graphics.translate(-v.x_2, -v.y_2)
            self.animations.move:draw(self.sprite_sheet,v.x,v.y,
                                      v.angle,v.x_scale,v.y_scale,
                                      v.origin_x,v.origin_y)
        end
        
    --    love.graphics.translate(self.x_2,self.y_2)
    --    love.graphics.rotate(self.start_pos)
    --    love.graphics.translate(-self.x_2, -self.y_2)
       
    --    self.animations.move:draw(self.sprite_sheet,self.x_2,self.y_2,self.angle,self.x_scale,self.y_scale,self.origin_x,self.origin_y)
       -- end
        
      
    love.graphics.pop()
   -- love.graphics.line(self.x,self.y,inherit_x,inherit_y)
   -- love.graphics.line(self.x,self.y,inherit_x,self.y)
   -- love.graphics.line(self.x,self.y,self.x,inherit_y)
    --love.graphics.print(self.angle,0,0)
end


