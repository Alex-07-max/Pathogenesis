
function love:load()
    love.graphics.setDefaultFilter('nearest', 'nearest', 0)
    Object = require "libraries/classic"
    require "player"
    require "bullets"
    require "user"
    require "decoy"
    require "map"
    require "audio"
    require "boss"
    require "killer_cells"
    require "boss_decoy"
    Camera = require 'libraries/camera'
    --love.window.setMode(1800, 900, {resizable=true, vsync=0, minwidth=400, minheight=300})
    love.window.setFullscreen(true, "desktop")
    player = Player()
    decoy = Decoy()
    intro = love.graphics.newImage("sprites/spleen_tissue.png")
    intro_x = -500
    sound = Audio()
    bullet = Bullets()
    ui = User_interface()
    mp = Map()
    cam = Camera()
   _G.game_state = "menu"
    boss = Boss(900,-900)
    is_boss_active = false
   _G.intro_timer = 0
   -- create_cells_right()
    _G.timer = 5
    _G.cooldown = 0
    _G.can_escape = true
    wait_to_remove_dead = 0
    dec_ui = love.graphics.newImage("sprites/decoy_ui2.png")
    death_particle_x = 0
    death_particle_y = 0
    --player.x =  love.graphics.getWidth() / 2
    --player.y = love.graphics.getHeight() / 2 + 200
    
    
    look_cursor = love.graphics.newImage("sprites/hover_free.png")
    attack_cursor = love.graphics.newImage("sprites/hover_attack.png")
    
    love.mouse.setVisible(false)
    --love.mouse.setGrab(true)
    boss_decoy = Boss_Decoy()
    _G.cells = { Killer_cells(200,-200),
                Killer_cells(840,-200),
                 Killer_cells(1400,-200)}

    _G.back_up = { Killer_cells(200,-200),
                Killer_cells(840,-200),
                Killer_cells(1400,-200)}

    _G.back_up_table = {}

    for i = 1, 10 do 
        back_up_table[i] = { Killer_cells(200,-200),
                                Killer_cells(840,-200),
                                Killer_cells(1400,-200)}
    end

    intro_text = {}
    for i = 1 , 14 do 
        table.insert(intro_text, love.graphics.newImage("sprites/spleen - text/spleen" .. i .. ".png"))
    end
    intro_text_frame = 1 
    intro_text_frame_rev = 14
    
end








function draw_start_menu()
    menu_img_= love.graphics.newImage("sprites/menu2.png")
    
    love.graphics.draw(menu_img_,0,0)
    

end

function draw_game_over()
    game_over_img = love.graphics.newImage("sprites/gameover.png")
    love.graphics.draw(game_over_img,0,0)
end




function love.update(dt)
   
    if game_state == "game" then
        sound.sound.ambience:play()
        
        intro_timer = intro_timer + dt
    
        if love.mouse.isDown(2) and decoy ~= nil then 
        sound.sound.decoy:play()
        
    end
    
    intro_text_frame = intro_text_frame + 1  
    if intro_text ~= nil then
        if intro_text_frame >= 14 then  
            intro_text_frame = intro_text_frame_rev
            if intro_timer > 3 then 
            intro_text_frame_rev = intro_text_frame_rev - 1 end
            if intro_text_frame_rev <= 1 then intro_text_frame_rev = 1 end  
            if intro_timer > 4 then intro_text = nil end
        end
    end
    
    
   
    

    if timer <= 0 then 
        decoy = nil 
        boss_decoy = nil
        cooldown = cooldown + dt
        can_escape = false
        
    end
    if cooldown >= 10 then
        timer = 5
       --
    
       if love.mouse.isDown(2)  then 
        
        boss_decoy = Boss_Decoy()
        decoy = Decoy()
        can_escape = true
        cooldown = 0
        
       end
    end
        --if player.state == "escaped" then
        --timer = 3
        --cooldown = 0 
        --elseif player.state == "free" then timer = 10 cooldown = 0 end
        --end
        
    --end
    timer = timer - dt 
    
    --sound.update(sound)
    
   
    --if #cell.cells_table == 0 then 
    --    create_cells_up()
   -- end
   
    
   -- cam:lookAt(player.x, player.y)
   cursor = look_cursor
   for i ,killer in ipairs(cells) do   
        
    
        m_x2 = love.mouse.getX()
        m_y2 = love.mouse.getY()
    --ui.draw_viral_health(ui,life_val)
    
        if math.sqrt( (m_x2 - killer.x_coord)^2 + (m_y2 - killer.y_coord)^2 ) < 100 then
            cursor = attack_cursor   
        end

    
    end
    
   
    if #cells == 0 then 
        
            for i,v in ipairs(back_up_table) do 
               if #cells == 0 then  
                    cells = back_up_table[i]
                end
           end 
       
     end
    
    --stop_camera()
    
  

    for i,killer in ipairs(cells) do 
        if decoy ~= nil then
            if intro_timer > 5 then
            killer.update(killer,decoy.x,decoy.y,dt,player.health)
            end
        end
        if decoy == nil then
            if intro_timer > 5 then
            killer.update(killer,player.x,player.y,dt)
            end
        end
    end
    
   




   local x = 0 
   local y = 0 
   if boss_decoy ~= nil then 
    x = boss_decoy.x 
    y = boss_decoy.y 
   end
   if #cells == 0 then is_boss_active = true end
   
    boss.update(boss,dt,player.x,player.y,x,y,is_boss_active) 
    if boss.health <= 0 then game_state = "game_over" end
   -- if en1.dead == false then 
       -- bullet.shoot_player(bullet,dt,player.x,player.y,en1.x_2,en1.y_2) 
   -- end
    bullet.update(bullet,dt,player.x,player.y)
    --if player.y < 45 then player.y = 1000 end

    bullet.shoot_from_player(bullet,dt)
    
    for i = 1, #cells do
       killer = cells[i]
       
        if bullet.has_collided(bullet,killer.x_coord,killer.y_coord) == true then 
                killer.health = killer.health - 18
        end
    end

    if bullet.has_collided_boss(bullet,boss.x,boss.y) == true then 
        if boss.state == "cought_decoy" or boss.state == "attack_decoy" then
            boss.health = boss.health - 10 
        end
    end
    
    
    

    for i = 1, #cells do 
        killer = cells[i] 
        if killer.health <= 0 then 
            
            killer.dead = true 
            
        end 
    end
    
    for i ,killer in ipairs(cells) do 
        
        if killer.dead == true then
            wait_to_remove_dead = wait_to_remove_dead + dt
            if wait_to_remove_dead > 2 then 
                table.remove(cells,i)
                wait_to_remove_dead = 0
            end
           
            
        end 
        
    end

  

    for i ,killer in ipairs(cells) do 
        
      bullet.remove_bullets(bullet,killer.x_coord,killer.y_coord,boss.x,boss.y)
        
    end
    
    bullet.remove_bullets(bullet,killer.x_coord,killer.y_coord,boss.x,boss.y)
    
   
   
    
    player.move2(player,boss.state,boss.x,boss.y,dt)
    player.play_animation(player,dt)
    player.rotate(player,dt)   
    
    if boss_decoy ~= nil then 
        boss_decoy.update(boss_decoy,dt,boss.x,boss.y,player.state,boss.state)
    end
    if decoy ~= nil then
        decoy.update(decoy,dt,player.x,player.y,player.state)
    end
    
    --knockback when shot
    for i ,killer in ipairs(cells) do 
        for j, bullet in ipairs(killer.bullets) do 
            local dir = math.atan2(player.y - bullet.y, player.x - bullet.x)
            local cos = math.cos(dir) 
            local sin = math.sin(dir)
            if killer.is_hit_bybullet(killer,player.x,player.y,dt) then 
                player.x = player.x + 175 * cos * dt 
                player.y = player.y + 175 * sin * dt  
            end 
        end      
    end
    --knockback when shot end
    
    for i ,killer in ipairs(cells) do 
        for j, blt in ipairs(bullet.bullet_list) do
            local dir2 = math.atan2(killer.y_coord - blt.y, killer.x_coord - blt.x)
            local cos2 = math.cos(dir2) 
            local sin2 = math.sin(dir2)
            if bullet.knockback(bullet,killer.x_coord,killer.y_coord) then 
                killer.x_coord = killer.x_coord + 175 * cos2 * dt 
                killer.y_coord = killer.y_coord + 175 * sin2 * dt  
            end
        end 
           
    end

  --  for i, blt in ipairs(bullet.bullet_list) do 
  --      local dir3 = math.atan2(boss.y - blt.y, boss.x - blt.x)
  --      local cos3 = math.cos(dir3) 
  --      local sin3 = math.sin(dir3)
  --      if bullet.knockback2(bullet,boss.x,boss.y) and boss.state == "attack_decoy" then 
  --          boss.x = boss.x + 50 * cos3 * dt 
  --          boss.y = boss.y + 50 * sin3 * dt  
  --      end
  --  end


    for i, killer in ipairs(cells) do 
        if killer.is_hit_bybullet(killer,player.x,player.y,dt) then 
            player.health = player.health - 7 
        end 
    end

    for i ,killer in ipairs(cells) do 
        
        bullet.remove_bullets_after_enemy_death(bullet,killer.dead)
          
    end
    
    
   
    mp.update(mp,dt)
    if player.health <= 0 then game_state = "game_over" end
    
    end--game_state end
    if game_state == "menu" or game_state == "game_over" then 
        love.audio.stop()
    end
    
    
        
    
    
end



function stop_camera()
    local x = love.graphics.getWidth()
    local y = love.graphics.getHeight()

    if cam.x < x/2 then 
        cam.x = x/2
    end
    --if cam.y < y/2 then 
    --    cam.y = y/2
    --end
    if cam.x > x/2 then 
        cam.x = x /2
    end
    if cam.y > y / 2 then 
        cam.y = y / 2 
    end


end



function is_enemy_moving(pl_x,pl_y,en_x,en_y)
    local distance_x = pl_x - en_x 
    local distance_y = pl_y - en_y 
    if distance_x > 500 or distance_x < -500
    or distance_y > 500 or distance_y < -500 then
        return true 
    else 
        return false 
    end

end

function love.draw()
    if game_state == "menu" then 
        draw_start_menu()
    end
    if game_state == "game_over" then 
        draw_game_over()
    end
    if game_state == "game" then 
    --cam:attach()
    
    mp.draw(mp)
    
    
    if intro_timer > 1 then 
        if intro_text ~= nil then
            love.graphics.draw(intro_text[math.floor(intro_text_frame)],660,540)
        end
    end
    
    if decoy == nil then 
        love.graphics.draw(dec_ui,300,950,0,0.7,0.7,0,0)
        love.graphics.print(math.floor(cooldown),480,980)
        if math.floor(cooldown) == 10 then 
            love.graphics.print('deploy',600,980)
        end
    end
    boss.draw(boss)
    
    if boss_decoy ~= nil then
        boss_decoy.draw(boss_decoy)
    end
    bullet.draw(bullet)
    bullet.en_bull_draw(bullet)
   -- love.graphics.push()
   -- love.graphics.scale(0.1,0.1)
    
    --love.graphics.pop()
    --love.graphics.draw(look_cursor, love.mouse.getX() - look_cursor:getWidth() / 2, love.mouse.getY() - look_cursor:getHeight() / 2)
    for i,killer in ipairs(cells) do 
        
        killer.draw(killer)
        
    end
    
    --cell.draw(cell)
    
    
    player.draw(player)
    if decoy ~= nil then 
        
        decoy.draw(decoy)
    end
   
    
    
    
    --show health bars
    
    
    for i = 1, #cells do   
        cell_life = cells[i] 
        val = ui.calculate_ui_val(ui,cell_life.health)
        --life_val = ui.calculate_life(ui,player.health)
        m_x = love.mouse.getX()
        m_y = love.mouse.getY()
        --ui.draw_viral_health(ui,life_val)
        
        if math.sqrt( (m_x - cell_life.x_coord)^2 + (m_y - cell_life.y_coord)^2 ) < 100 then
            if cell_life.dead == false then 
                
                    ui.draw(ui,val)
                
           end
        end
    end
    --cam:detach()
    if math.sqrt( (love.mouse.getX() - boss.x)^2 + (love.mouse.getY() - boss.y)^2 ) < 200 then
        love.graphics.print("DENDRILION",800,0)
        love.graphics.print(boss.health,880,40)
    end
    
    love.graphics.draw(player.health_ui,0,950,0,0.7,0.7,0,0)
    love.graphics.print(player.health,150,980)

    
    love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
    end--game_state end
    
    -- end show health bars
    
    
    
    --love.graphics.print(love.graphics.getHeight(),250,250)
    
    
    
    
    
      
   -- en1.draw(en1)
   

end

function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then
		fullscreen = not fullscreen
		--love.window.setFullscreen(fullscreen, "exclusive")
        love.window.setMode(1900, 1080)
	end          
    if game_state == "menu" and  key == "s" then 
        
        game_state = "game"
    end
    if game_state == "menu" and key == "e" then 
        love.event.quit()
    end
    if key == "space" then 
        game_state = "menu"
    end
    if game_state == "game_over" and key == "s" then 
        love.load()
    elseif game_state == "game_over" and key == "b" then 
        love.event.quit()
    end
    

end

