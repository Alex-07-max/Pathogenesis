# Pathogenesis
## Video Demo: <tbr>
### Description: Top down 2d shooter game ,made in Lua with the Love framework.


				 We're controlling a viral particle, which invaded a living organism,
				 and has to fight off the defender cells , by shooting sequences of it's 
				 dna strand. As we progress we make our way through various parts of the 
				 body, starting in the "spleen tissue" area. The particle is controlled 
				 via "w,a,s,d" keys for direction , mouse movement for rotation(facing),
				 left click for shooting,and right click for decoy deployment(which has a cooldown).
				 				  
								  
#### Game files and functions description below.

**main.lua** -  main file where the three main , love2d functions are called:
				**love.load()** , **love.update()**, **love.draw()**
				
				**love.load()**: 
				Here are declared all game objects
				required on game load , also , i have been using https://github.com/rxi/classic 
				library for OOP style.Game state is set to "menu" here(to start on game menu).
				the variable **is_boss_active** is set to false , it becomes true(and deploy the map boss)
				once the number of elements in the tables containing the enemies is 0.
				after **love.load()** , the two functions **draw_start_menu()** and **draw_game_over**
				are used for drawing the according images to screen via **love.graphics.draw()**.
				They will get called according to game states.
				
				**love.update()**:
				The lines between 107 and 114 are handling the text appearing(and disappearing) when game starts.
				The lines between 122 and 141 are handling the decoy deployment. if timer is less or equal to zero
				decoy is set to null,initiate the cooldown timer,**can_escape** is set to false. Once the cooldown 
				reaches 10, timer is reset to 5. Right clicking now, can create a decoy object,**can_escape** is 
				set to true , cooldown is reset to 0.
				Between lines 160 and 173 the mouse cursor is set to "look cursor", which changes once it hovers over enemies,
				via conditional statement on line 168 to verify collision between mouse coordinates and enemies coordinates. 
				Between lines 176 and 184 it is checked if the enemies table is empty,and sets it to another full table of 
				the same enemies which was also called in **love.load()**, tried to refill the same table once it's empty,
				without using other tables of the same enemies, but the game loop would freeze for one second, before 
				continuing,as it would need to refill it while still in **love.update()**
				From line 190 to 201 , for every enemy in table , it checks to see if decoy is present, if timer is greater than 5,
				and if they are, every enemy shall attack only the decoy, if not, the player gets attacked.
				From line 208 to 347: calling of the update functions of various objects, like boss, bullets, enemies, also verifications of
				when should the bullets be removed from screen , collision verifications, enemies health drop when hit, when the enemies should 
				be removed from screen(once dead == true , after health reached 0).Knockback simulation function from getting hit by bullets. 
				All calculations of the moving parts, like bullets trajectory, enemies always facing player while player changes position, 
				player rotation, knockback effect from getting hit by bullets, were done by using Lua math library functions.
				
				
				**love.draw()**:
				From line 385 to 487.
				Draws everything appearing on screen. 
				Conditionals for game states, in order to draw accordingly(menus, game over screen etc.) 
				Conditionals for collisions , in order to display health bars.

				
**map.lua**  - 	Contains the constructor for the background object **Map.new(self)** and it's respective update and draw functions. 
				Table containing all background sprites, gets drawn in loop as the background is animated as opposed to static. 
				Whole map gets redrawn at it's respective coordinates once offset is reached.
				Offset value is changed by moving the map downwards while player is moving upward.
				
**player.lua** - Contains the constructor for the player object **Player.new(self)** and it's respective methods, update , draw, 
				 movement, game states logic etc. 
				 
**boss_decoy.lua** - Contains the constructor for the decoy object used on final boss **Boss_decoy.new(self)** and it's respective methods, update , draw, 
				 movement, game states logic etc. 
				 
				 
**decoy.lua** - Contains the constructor for the decoy object used on enemies **Decoy.new(self)** and it's respective methods, update , draw, 
				 movement, game states logic etc. 
				 

**bullets.lua** - Contains the constructor for the bullet object **Bullets.new(self)** and it's respective methods, update, draw , collision checks.

**killer_cells.lua** - Contains the constructor for the enemy object **Killer_cells.new(self,x,y)** and it's respective methods , update, draw, collision checks, 
						behaviour.
						
**boss.lua** - Contains the constructor for the final boss object **Boss.new(self)** and it's respective methods, update, draw, collision checks, game states logic. 

**user.lua** - Contains the constructor for the HUD object **User_interface.new(self)** and it's respective methods, update, draw, health bars HUD , cooldowns HUD etc. 


__game files description ends here__


**credits**:

				All artwork and animations by Baciu Alexandru and Adrian Suliap .
				Programmed by Baciu Alexandru in Lua and Love2d framework in the year: 2024 , as a final project for https://cs50.harvard.edu/college/2024/fall/.
				
				
**release notes** :
				
				Initially the idea was to have a big background which you could explore, hence the code remnants in **main.lua** ,of using a camera library 
				for creating a camera which follows the player. The idea was later scrapped, as i felt it would surpass the scope of the project
				in terms of time needeed for implementing all functionality. It would've need a different(more complex) approach in the way of defining 
				enemies behaviour(and everything for that matter).
				
				
				
				(I had different, perhaps more appropiate game mechanics ideas which seemed more 
				 in tune with the theme later in development as opposed to just shooting,
				 but was allready too far off with the idea presented in this version,
				 so a reimplementation in a 2.0 version, maybe?) 


  				Path to Love2d engine must be set up before testing the game.

				
				
				
				
				
				
				
				
				
				 
				 
				 
																				
