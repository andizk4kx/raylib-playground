/*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--/*
include std/math.e
constant false =0
constant true=1
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    -----------------------------------------------------------
    atom screenWidth = 800
    atom screenHeight = 450
    enum x,y
    SetConfigFlags(FLAG_MSAA_4X_HINT)
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bouncing ball")

    sequence ballPosition = { GetScreenWidth()/2.0, GetScreenHeight()/2.0 }
    sequence ballSpeed = { 5.0, 4.0 }
    integer ballRadius = 20
    atom gravity = 0.2
    integer pause = 0
    integer useGravity = true
    integer framesCounter = 0

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose() do    -- Detect window close button or ESC key
    
        -- Update
        -------------------------------------------------------
        if (IsKeyPressed(KEY_SPACE)) then pause = not pause end if
        if (IsKeyPressed(KEY_G)) then useGravity = not useGravity end if

        if not pause then
        
            ballPosition[x] += ballSpeed[x]
            ballPosition[y] += ballSpeed[y]
            
            if (useGravity) then ballSpeed[y] += gravity end if

            -- Check walls collision for bouncing
            if ((ballPosition[x] >= (GetScreenWidth() - ballRadius)) or (ballPosition[x] <= ballRadius)) then  ballSpeed[x] *= -1.0 end if
            if ((ballPosition[y] >= (GetScreenHeight() - ballRadius)) or (ballPosition[y] <= ballRadius)) then ballSpeed[y] *= -1.0 end if
        
        else framesCounter +=1
        end if
        -------------------------------------------------------

        -- Draw
        -------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawCircleV(ballPosition, ballRadius, MAROON)
            DrawText("PRESS SPACE to PAUSE BALL MOVEMENT", 10, GetScreenHeight() - 25, 20, LIGHTGRAY)
           if (useGravity) 
           then  
                DrawText("GRAVITY: ON (Press G to disable)", 10, GetScreenHeight() - 50, 20, DARKGREEN)
           else 
                DrawText("GRAVITY: OFF (Press G to enable)", 10, GetScreenHeight() - 50, 20, RED)
           end if
            -- On pause, we draw a blinking message
--          if (pause && ((framesCounter/30)%2)) DrawText("PAUSED", 350, 200, 30, GRAY)
            if pause and mod((framesCounter/30),2) then DrawText("PAUSED", 350, 200, 30, GRAY) end if
            DrawFPS(10, 10)

        EndDrawing()
        -------------------------------------------------------
    end while

    -- De-Initialization
    -----------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ------------------------------------------------------------

--  return 0;

