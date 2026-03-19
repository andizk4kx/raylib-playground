/*******************************************************************************************
*
*   raylib [textures] example - sprite animation
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/

include "../../raylib64.e"

constant MAX_FRAME_SPEED =  15
constant MIN_FRAME_SPEED =   1
enum width=2,height=3
enum x=1,y
enum widthrect=3,heightrect=4
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - sprite animation") 

    -- NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    sequence scarfy = LoadTexture("resources/scarfy.png")      -- Texture loading

    sequence position_ = { 350.0, 280.0 } 
    sequence frameRec = { 0.0, 0.0, scarfy[width]/6, scarfy[height] } 
    integer currentFrame = 0 

    integer framesCounter = 0 
    integer framesSpeed = 8             -- Number of spritesheet frames shown by second

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while  not WindowShouldClose()  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        framesCounter+=1

        if (framesCounter >= (60/framesSpeed))
        then
            framesCounter = 0 
            currentFrame+=1 

            if (currentFrame > 5) then 
                currentFrame = 0 
            end if
            frameRec[x] = currentFrame*scarfy[width]/6
        end if

        -- Control frames speed
        if (IsKeyPressed(KEY_RIGHT)) 
        then 
            framesSpeed+=1 
        elsif (IsKeyPressed(KEY_LEFT)) 
        then 
            framesSpeed-=1 
        end if
            
        if (framesSpeed > MAX_FRAME_SPEED) 
        then 
            framesSpeed = MAX_FRAME_SPEED 
        elsif (framesSpeed < MIN_FRAME_SPEED) 
        then 
            framesSpeed = MIN_FRAME_SPEED
        end if 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawTexture(scarfy, 15, 40, WHITE) 
            DrawRectangleLines(15, 40, scarfy[width], scarfy[height], LIME) 
            DrawRectangleLines(15 + frameRec[x], 40 + frameRec[y], frameRec[widthrect], frameRec[heightrect], RED) 

            DrawText("FRAME SPEED: ", 165, 210, 10, DARKGRAY) 
            DrawText(sprintf("%02d FPS", framesSpeed), 575, 210, 10, DARKGRAY) 
            DrawText("PRESS RIGHT/LEFT KEYS to CHANGE SPEED!", 290, 240, 10, DARKGRAY) 

            for  i = 0 to  MAX_FRAME_SPEED
            do
                if (i < framesSpeed) 
                then 
                    DrawRectangle(250 + 21*i, 205, 20, 20, RED) 
                    DrawRectangleLines(250 + 21*i, 205, 20, 20, MAROON)
                end if 
            end for

            DrawTextureRec(scarfy, frameRec, position_, WHITE)  -- Draw part of the texture

            DrawText("(c) Scarfy sprite by Eiden Marsal", screenWidth - 200, screenHeight - 20, 10, GRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(scarfy)        -- Texture unloading

    CloseWindow()                 -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------
    

