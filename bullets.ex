include raylib.e
--include rlgl.e
 
atom Width = 1024 
atom Height = 720 
 
InitWindow(Width,Height,"Bullets") 
 
SetTargetFPS(60) 
 
atom bullet_speed = 1.0 
 
sequence bullets = {} 
 
integer bullet_visible = 0 
 
Vector2 bullet_pos = new({GetScreenWidth() / 2, GetScreenHeight() / 2}) 

while not WindowShouldClose() do 
 
        if IsKeyPressed(KEY_SPACE) then 
                bullets = append(bullets,bullet_pos) 
                bullet_visible = 1 
        end if 
         
        for i = length(bullets) to 1 by -1 do 
                bullet_pos.x += bullet_speed 
                 
                if bullet_pos.x >= GetScreenWidth() then 
                        bullets = remove(bullets,i) 
                        continue 
                end if 
        end for 
 
        BeginDrawing() 
         
        if bullet_visible = 1 then
                ClearBackground(BLACK) 
                DrawCircleV(bullet_pos,20,mred) 
        end if 
            
        EndDrawing() 
end while 
 
CloseWindow() 
