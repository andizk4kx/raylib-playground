/*******************************************************************************************
*
*   raylib [shapes] example - collision area
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix 2026  Andreas Wagner
include "../../raylib64.e"

--/*
include std/types.e
--*/
--#include <stdlib.h>   -- Required for: abs()

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    -----------------------------------------------------------
    constant  screenWidth = 800
    constant  screenHeight = 450
    enum x,y,width,height
    
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - collision area")

    -- Box A: Moving box
    sequence boxA = { 10, GetScreenHeight()/2.0 - 50, 200, 100 }
    integer boxASpeedX = 4

    -- Box B: Mouse moved box
    sequence boxB = { GetScreenWidth()/2.0 - 30, GetScreenHeight()/2.0 - 30, 60, 60 }

    sequence boxCollision = {0,0,0,0} -- Collision rectangle
    sequence HEADCOL=RED
    
    integer screenUpperLimit = 40       -- Top menu limits

    integer pause = FALSE           -- Movement pause
    integer collision = FALSE       -- Collision detection

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        -------------------------------------------------------
        -- Move box if not paused
        if not pause then boxA[x] += boxASpeedX end if

        -- Bounce box on x screen limits
        if (((boxA[x] + boxA[width]) >= GetScreenWidth()) or (boxA[x] <= 0))then  boxASpeedX *= -1 end if

        -- Update player-controlled-box (box02)
        boxB[x] = GetMouseX() - boxB[width]/2
        boxB[y] = GetMouseY() - boxB[height]/2

        -- Make sure Box B does not go out of move area limits
        if ((boxB[x] + boxB[width]) >= GetScreenWidth()) then boxB[x] = GetScreenWidth() - boxB[width]
        elsif (boxB[x] <= 0) then boxB[x] = 0 end if

        if ((boxB[y] + boxB[height]) >= GetScreenHeight()) then
             boxB[y] = GetScreenHeight() - boxB[height] 
        elsif (boxB[y] <= screenUpperLimit) then
             boxB[y] = screenUpperLimit
        end if

        -- Check boxes collision
           collision = CheckCollisionRecs(boxA, boxB)

        -- Get collision rectangle (only on collision)
        if (collision) then 
            boxCollision = GetCollisionRec(boxA, boxB) 
        end if

        -- Pause Box A movement
        if (IsKeyPressed(KEY_SPACE)) then 
            pause = not pause 
        end if
        -------------------------------------------------------

        -- Draw
        -------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)
            if collision then
                HEADCOL=RED
            else
                HEADCOL=BLACK
            end if
            DrawRectangle(0, 0, screenWidth, screenUpperLimit,HEADCOL)
            --iff(collision? RED : BLACK)
            DrawRectangleRec(boxA, GOLD)
            DrawRectangleRec(boxB, BLUE)

            if (collision)
            then
                -- Draw collision area
                DrawRectangleRec(boxCollision,LIME)

                -- Draw collision message
                DrawText("COLLISION!", GetScreenWidth()/2 - MeasureText("COLLISION!", 20)/2, screenUpperLimit/2 - 10, 20, BLACK)
                -- Draw collision area
                DrawText(sprintf("Collision Area: %d", boxCollision[width]*boxCollision[height]), GetScreenWidth()/2 - 100, screenUpperLimit + 10, 20, BLACK)
            end if

            -- Draw help instructions
            DrawText("Press SPACE to PAUSE/RESUME", 20, screenHeight - 35, 20, LIGHTGRAY)

            DrawFPS(10, 10)

        EndDrawing()
        -------------------------------------------------------
    end while

    -- De-Initialization
    -----------------------------------------------------------
    CloseWindow()     -- Close window and OpenGL context
    ------------------------------------------------------------



