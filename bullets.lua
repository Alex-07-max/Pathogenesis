


Bullets = Object.extend(Object)

function Bullets.new(self)
	self.bullet = love.graphics.newImage("sprites/bullet_2.png")
    
    self.direction = math.atan2(0,0)
    
    self.speed = 2000
	self.bullet_list = {}
	self.enemy_bullet_list = {}
	self.shooting_timer = 0
     
end

function Bullets.update(self,dt,pl_x,pl_y)
    local my = love.mouse.getY()
	local mx = love.mouse.getX()
	

	speed = 2000
	if love.mouse.isDown(1) and not love.keyboard.isDown("right","d") and not love.keyboard.isDown("left","a") then 
		self.direction = math.atan2(my - pl_y, mx - pl_x)
		cos = math.cos(self.direction)
    	sin = math.sin(self.direction)
		table.insert(self.bullet_list,{x = pl_x ,
									   y = pl_y ,
									   dir = self.direction , 
										speed = self.speed})

	end

function Bullets.shoot_from_player(self,dt)
	for i,v in ipairs(self.bullet_list) do 
		v.x = v.x + v.speed * cos * dt  
		v.y = v.y + v.speed * sin * dt 
	end
end
function Bullets.remove_bullets(self,en_x,en_y,b_x,b_y)
	for i = #self.bullet_list, 1, -1 do
        local v = self.bullet_list[i]
        if (v.x < -10) or (v.x > love.graphics.getWidth() + 10)
        or (v.y < -10) or (v.y > love.graphics.getHeight() + 10) 
		or math.sqrt( (en_x - v.x)^2 + (en_y - v.y)^2 ) < 80  or 
			math.sqrt( (b_x - v.x)^2 + (b_y - v.y)^2 ) < 150	then
            table.remove(self.bullet_list, i)
    end
end

function Bullets.remove_bullets_after_enemy_death(self,dead) 
	if dead == true then 
		for i = #self.enemy_bullet_list, 1, -1 do 
			local v = self.enemy_bullet_list[i]
			table.remove(self.enemy_bullet_list,i)
		end
	end
end
		
	
	
	--self.x = self.x + self.speed * cos * dt  
	--self.y = self.y + self.speed * sin * dt 
	
	
end		
end

function Bullets.shoot_player(self,dt,pl_x,pl_y,en_x,en_y)
	self.shooting_timer = self.shooting_timer + dt

	local dir = math.atan2(pl_y - en_y, pl_x - en_x)
	local cos = math.cos(dir)
    local sin = math.sin(dir)

	
	speed = 2000

	
	table.insert(self.enemy_bullet_list,{x = en_x ,
									   y = en_y ,
									   dir = dir , 
										speed = speed})

	
	
	for i,v in ipairs(self.enemy_bullet_list) do 
		v.x = v.x + v.speed * cos * dt  
		v.y = v.y + v.speed * sin * dt 
	end
	
	for i = #self.enemy_bullet_list, 1, -1 do
        local v = self.enemy_bullet_list[i]
        if (v.x < -10) or (v.x > love.graphics.getWidth() + 10)
        or (v.y < -10) or (v.y > love.graphics.getHeight() + 10) 
		or math.sqrt( (pl_x - v.x)^2 + (pl_y - v.y)^2 ) < 80  then
            table.remove(self.enemy_bullet_list, i)
    end
	

end
end


function Bullets.knockback(self,x,y)
	for i,v in ipairs(self.bullet_list) do
		if math.sqrt( (x - v.x)^2 + (y - v.y)^2 ) < 100 then 
			return true
		else 
			return false 
		end
	
	end

end
function Bullets.knockback2(self,x,y)
	for i,v in ipairs(self.bullet_list) do
		if math.sqrt( (x - v.x)^2 + (y - v.y)^2 ) < 200 then 
			return true
		else 
			return false 
		end
	
	end

end

function Bullets.has_collided(self,x,y)
	for i,v in ipairs(self.bullet_list) do
	 	if math.sqrt( (x - v.x)^2 + (y - v.y)^2 ) < 80 then 
			return true 
		else 
			return false
		end
	end
	
end
function Bullets.has_collided_boss(self,x,y)
	for i,v in ipairs(self.bullet_list) do
		if math.sqrt( (x - v.x)^2 + (y - v.y)^2 ) < 900 then 
		   return true 
	   else 
		   return false
	   end
   end
end
function Bullets.has_collided_with_player(self,x,y) 
	for i,v in ipairs(self.enemy_bullet_list) do
		if math.sqrt( (x - v.x)^2 + (y - v.y)^2 ) < 80 then 
		   return true 
	   else 
		   return false
	   end
   end

end

function Bullets.en_bull_draw(self)
	for i,v in ipairs(self.enemy_bullet_list) do 
		love.graphics.draw(self.bullet,v.x,v.y)
	end
end
function Bullets.draw(self)
	--love.graphics.print(self.shooting_timer,200,200)
	for i, v in ipairs(self.bullet_list) do
		love.graphics.draw(self.bullet,v.x,v.y)
	end
	
	
			
end



