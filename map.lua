Map = Object.extend(Object)


function Map.new(self) 
    self.map = {}
    for i = 1, 27 do 
        table.insert(self.map,love.graphics.newImage("sprites/images/map"..i..".png"))
    end
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    for i = 1, 27 do 
        self.sx = self.width / self.map[i]:getWidth()
        self.sy = self.height / self.map[i]:getHeight()
    end
    --self.img:setWrap('repeat','repeat')
    
    self.frame = 1
    self.speed = 5
    self.y = 0
    self.offset = 0
end


function Map.update(self,dt) 
    self.frame = self.frame + 1
    if self.frame > 27 then self.frame = 1 end 
    --if love.keyboard.isDown("up","w") then 
        self.y = self.y + self.speed
        self.offset = self.offset + 5
        if self.offset > 1080 then self.y = 0 self.offset = 0 end
        if self.offset < -1080 then self.y = 0 self.offset = 0 end
    --end
   -- if self.y > -10 then
   --     if love.keyboard.isDown("down","s") then 
   --         self.y = self.y - self.speed
   --         self.offset = self.offset - 1
   --         if self.offset < -1080 then self.y = 0 self.offset = 0 end
   --     end
  --  end

        
   
end

function Map.draw(self)
    --love.graphics.setBackgroundColor(1,1,1)
    
    --love.graphics.setColor(1,1,1,1)
    

    love.graphics.draw(self.map[self.frame],0,self.y,0,self.sx,1.01)
    love.graphics.draw(self.map[self.frame],0,-1080 +self.y,0,self.sx,1.01)
   -- love.graphics.print(self.y,400,400)
   -- love.graphics.print(self.offset,500,500)
    --love.graphics.draw(self.map[self.frame],0,-2160 +self.y,0,self.sx,1)
    --love.graphics.draw(self.map[self.frame],0,-2161,0,self.sx,self.sy)
    
    --love.graphics.draw(self.map[self.frame], self.maps[self.frame], 0, 0)
   -- love.graphics.draw(self.map, self.quad, self.px,self.py, 0, 
                    --   self.width/self.w,self.height/self.h)
    --love.graphics.draw(self.img,self.quad,self.px,self.py,self.width/self.w,self.height/self.h)
end