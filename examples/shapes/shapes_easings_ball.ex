/*******************************************************************************************
*
*   raylib [shapes] example - easings ball
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--include raylib.e
include "reasings.e"              -- Required for easing functions

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - easings ball") 

    -- Ball variable value to be animated with easings
    atom ballPositionX = -100 
    atom ballRadius = 20 
    atom ballAlpha = 0.0 

    integer state = 0 
    integer framesCounter = 0 

    SetTargetFPS(30)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (state = 0)          -- Move ball position X with easing
        then
            framesCounter+=1
            ballPositionX = EaseElasticOut(framesCounter, -100, screenWidth/2.0 + 100, 120) 

            if (framesCounter >= 120)
            then
                framesCounter = 0 
                state = 1 
            end if
--      end if
        elsif (state = 1)       -- Increase ball radius with easing
        then
            framesCounter+=1
            ballRadius = EaseElasticIn(framesCounter, 20, 500, 200) 

            if (framesCounter >= 200)
            then
                framesCounter = 0 
                state = 2 
            end if
--      end if
        elsif (state = 2)       -- Change ball alpha with easing (background color blending)
        then
            framesCounter+=1 
            ballAlpha = EaseCubicOut(framesCounter, 0.0, 1.0, 200) 

            if (framesCounter >= 200)
            then
                framesCounter = 0 
                state = 3 
            end if
--      end if
        elsif (state = 3)       -- Reset state to play again
        then
            if (IsKeyPressed(KEY_ENTER))
            then
                -- Reset required variables to play again
                ballPositionX = -100 
                ballRadius = 20 
                ballAlpha = 0.0 
                state = 0 
            end if
        end if

        if (IsKeyPressed(KEY_R)) then 
            framesCounter = 0 
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            if (state >= 2)then  DrawRectangle(0, 0, screenWidth, screenHeight, GREEN) end if 
            DrawCircle(ballPositionX, 200, ballRadius, Fade(RED, 1.0 - ballAlpha)) 
            if (state = 3) then DrawText("PRESS [ENTER] TO PLAY AGAIN!", 240, 200, 20, BLACK) end if

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------



