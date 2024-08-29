--require "enemies"

Killer_cells = Object.extend(Object)

function Killer_cells.new(self,x,y)
    self.x_coord = x 
    self.y_coord = y
    self.animate = require("libraries/anim8")
    self.img = love.graphics.newImage("sprites/evil pathogen_00.png")
    self.x = self.img:getWidth()
    self.y = self.img:getHeight()
    self.x_scale = 0.5 
    self.y_scale = 0.5
    self.angle = 0
    self.ang = 0
    self.start_ang = self.ang +.5*math.pi
    self.org_x = self.x / 2 
    self.org_y = self.y / 2
    self.sprite_sheet = love.graphics.newImage("sprites/Evil_pathogen.png")
    self.death_anim = love.graphics.newImage("sprites/ev_pathogen_death.png")
    self.grid = self.animate.newGrid(283,309,self.sprite_sheet:getWidth(),self.sprite_sheet:getHeight())
    self.death_anim_grid = self.animate.newGrid(258,284,self.death_anim:getWidth(),self.death_anim:getHeight())
    self.animations = {}
    self.animations.move = self.animate.newAnimation(self.grid('1-7',1,'2-7',2,'3-7',3,'4-6',4), 0.05)
    self.animations.die = self.animate.newAnimation(self.death_anim_grid('1-7',1,'2-7',2,'3-7',3,'4-6',4), 0.01)
    self.timer = 0
    self.health = 200
    self.dead = false
    self.bullet = love.graphics.newImage("sprites/dna_strand.png")
    self.dir = math.atan2(0,0)
    self.cos = math.cos(self.dir)
    self.sin = math.sin(self.dir)
    self.bullets = {}
    self.heat = 0
	self.heat_p = 0.1
    self.shoot_timer = 0
end


function Killer_cells.shoot(self,dt,pl_x,pl_y)
    
    
	self.dir = math.atan2(pl_y - self.y_coord, pl_x - self.x_coord)
	self.cos = math.cos(self.dir)
    self.sin = math.sin(self.dir)
    
	
	speed = 2000

	if self.heat <= 0 then
	    table.insert(self.bullets,{x = self.x_coord ,
							    y = self.y_coord ,
								dir = self.dir , 
								speed = speed})
        self.heat = self.heat_p
	
    end
    self.heat = math.max(0, self.heat - dt)

	for i,v in ipairs(self.bullets) do 
		v.x = v.x + v.speed * self.cos * dt  
		v.y = v.y + v.speed * self.sin * dt 
	end
	
	for i = #self.bullets, 1, -1 do
        local v = self.bullets[i]
        if (v.x < -10) or (v.x > love.graphics.getWidth() + 10)
        or (v.y < -10) or (v.y > love.graphics.getHeight() + 10) 
		or math.sqrt( (pl_x - v.x)^2 + (pl_y - v.y)^2 ) < 80 
         then
            table.remove(self.bullets, i)
    end
	

end
end




function Killer_cells.is_hit_bybullet(self,pl_x,pl_y)
    for i,v in ipairs(self.bullets) do
        if math.sqrt( (pl_x - v.x)^2 + (pl_y - v.y)^2 ) < 120 then 
           return true 
       else 
           return false
       end
   end

end

function Killer_cells.update(self,pl_x,pl_y,dt)
   
    self.animations.die:update(dt)
    self.animations.move:update(dt)
    if self.health > 0 then 
        Killer_cells.shoot(self,dt,pl_x,pl_y)
    end

    local pl_left = false 
    local pl_middle = false 
    local pl_right = false 
    local cell_left = false 
    local cell_middle = false 
    local cell_right = false 

    if pl_x < 640 then 
        pl_left = true 
        pl_middle = false 
        pl_right = false 
    elseif pl_x > 640 and pl_x < 1080 then 
        pl_left = false 
        pl_middle = true 
        pl_right = false 
    elseif pl_x > 1080 and pl_x < 1920 then 
        pl_left = false
        pl_middle = false 
        pl_right = true 
    end

    if self.x_coord < 640 then 
        cell_left = true 
        cell_middle = false 
        cell_right = false 
    elseif self.x_coord > 640 and self.x_coord < 1080 then 
        cell_left = false 
        cell_middle = true 
        cell_right = false 
    elseif self.x_coord > 1080 and self.x_coord < 1920 then 
        cell_left = false
        cell_middle = false 
        cell_right = true 
    end

    distance_x = self.x_coord - pl_x 
    if cell_left == true and pl_left == true then 
        self.x_coord = self.x_coord - distance_x * 2.5 *  dt  
    
    end

    if  cell_middle == true and pl_middle == true then 
        self.x_coord = self.x_coord - distance_x * 2.5 *  dt  
    
    end

    if cell_right == true and pl_right == true then 
        self.x_coord = self.x_coord - distance_x * 2.5 *  dt  
    
    end



    if cell_middle == true and self.y_coord < 200 then 
        self.y_coord = self.y_coord + 700 * dt 
    end 
    if cell_left == true and self.y_coord < 100 then 
        self.y_coord = self.y_coord + 700 * dt 
    end 
    if cell_right == true and self.y_coord < 100 then 
        self.y_coord = self.y_coord + 700 * dt 
    end 


    self.angle = math.atan2(pl_y - self.y_coord, pl_x - self.x_coord)
   
end

function Killer_cells.draw(self)
    for i,v in ipairs(self.bullets) do 
        if self.dead == false then
            love.graphics.draw(self.bullet,v.x,v.y)
        end
    end
    love.graphics.push()
    love.graphics.translate(self.x_coord,self.y_coord)
    love.graphics.rotate(self.start_ang)
    love.graphics.translate(-self.x_coord, -self.y_coord)
    if self.dead == true then 
        self.animations.die:draw(self.death_anim,self.x_coord,self.y_coord,
                             self.angle,self.x_scale,self.y_scale,
                                      self.org_x,self.org_y)
    else
        self.animations.move:draw(self.sprite_sheet,self.x_coord,self.y_coord,
                             self.angle,self.x_scale,self.y_scale,
                                      self.org_x,self.org_y)
    end
    
    love.graphics.pop()
    
   
end