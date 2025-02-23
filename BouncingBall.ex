include raylib.e

 atom width = 800
atom height = 600

 InitWindow(width,height,"Bouncing Ball")
 
 Vector2 ballPos = new({GetScreenWidth() / 2.0, GetScreenHeight() / 2.0})
 Vector2 ballSpeed = new({5.0, 4.0})
 atom ballRadius = 30
 
 integer paused = 0
 integer framesCount = 0
 
 SetTargetFPS(120)
 
 while not WindowShouldClose() do
 
 if IsKeyPressed(KEY_SPACE) and paused = 0  then
        paused = 1
        elsif IsKeyPressed(KEY_SPACE) and paused = 1 then
                paused = 0
 end if
 
 if paused = 0 then
 
        ballPos.x += ballSpeed.x --[1] is x
        ballPos.y += ballSpeed.y --[2] is y
        

        if ballPos.x >= GetScreenWidth() - ballRadius or ballPos.x <= ballRadius then
                ballSpeed.x *= -1.0

        elsif ballPos.y >= GetScreenHeight() - ballRadius or ballPos.y <= ballRadius then
                ballSpeed.y *= -1.0

        else
                framesCount += 1
        end if
 end if
 
 BeginDrawing()
 
 ClearBackground(RAYWHITE)
 
 DrawCircleV(ballPos,ballRadius,MAROON)
 
 DrawFPS(1,1)
 
 if paused = 1 then
        DrawText("Paused",GetScreenWidth() / 2,GetScreenHeight() / 2,50,LIGHTGRAY)
 end if
 
 EndDrawing()
        
 end while
 
 CloseWindow()

