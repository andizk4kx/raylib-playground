/*******************************************************************************************
*
*   raylib [textures] example - gif player
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
include std/machine.e
--*/

constant MAX_FRAME_DELAY =  20
constant MIN_FRAME_DELAY =   1
enum data=1,width,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - gif player") 

    atom animFrames_ptr = allocate(4) --a pointer to an int 
    integer animFrames = 0
    -- Load all GIF animation frames into a single Image
    -- NOTE: GIF data is always loaded as RGBA (32bit) by default
    -- NOTE: Frames are just appended one after another in image.data memory
    sequence imScarfyAnim = LoadImageAnim("resources/scarfy_run.gif", animFrames_ptr) 
    animFrames=peek4s(animFrames_ptr)
    free(animFrames_ptr)
    -- Load texture from image
    -- NOTE: We will update this texture when required with next frame data
    -- WARNING: It's not recommended to use this technique for sprites animation,
    -- use spritesheets instead, like illustrated in textures_sprite_anim example
    sequence texScarfyAnim = LoadTextureFromImage(imScarfyAnim) 

    integer nextFrameDataOffset = 0   -- Current byte offset to next frame in image.data

    integer currentAnimFrame = 0        -- Current animation frame to load and draw
    integer frameDelay = 8              -- Frame delay to switch between animation frames
    integer frameCounter = 0            -- General frames counter

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        frameCounter+= 1
        if (frameCounter >= frameDelay)
        then
            -- Move to next frame
            -- NOTE: If final frame is reached we return to first frame
            currentAnimFrame+= 1 
            if (currentAnimFrame >= animFrames) 
            then 
                currentAnimFrame = 0 
            end if
            -- Get memory offset position for next frame data in image.data
            nextFrameDataOffset = imScarfyAnim[width]*imScarfyAnim[height]*4*currentAnimFrame 

            -- Update GPU texture data with next frame image data
            -- WARNING: Data size (frame size) and pixel format must match already created texture
            UpdateTexture(texScarfyAnim,imScarfyAnim[data] + nextFrameDataOffset) 

            frameCounter = 0 
        end if

        -- Control frames delay
        if (IsKeyPressed(KEY_RIGHT)) 
        then 
            frameDelay+= 1 
        elsif (IsKeyPressed(KEY_LEFT)) 
        then 
            frameDelay-= 1 
        end if
        
        if (frameDelay > MAX_FRAME_DELAY) 
        then 
            frameDelay = MAX_FRAME_DELAY 
        elsif (frameDelay < MIN_FRAME_DELAY) 
        then 
            frameDelay = MIN_FRAME_DELAY
        end if 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText(sprintf("TOTAL GIF FRAMES:  %02d", animFrames), 50, 30, 20, LIGHTGRAY) 
            DrawText(sprintf("CURRENT FRAME: %02d", currentAnimFrame), 50, 60, 20, GRAY) 
            DrawText(sprintf("CURRENT FRAME IMAGE.DATA OFFSET: %02d", nextFrameDataOffset), 50, 90, 20, GRAY) 

            DrawText("FRAMES DELAY: ", 100, 305, 10, DARKGRAY) 
            DrawText(sprintf("%02d frames", frameDelay), 620, 305, 10, DARKGRAY) 
            DrawText("PRESS RIGHT/LEFT KEYS to CHANGE SPEED!", 290, 350, 10, DARKGRAY) 

            for  i = 0 to MAX_FRAME_DELAY
            do
                if (i < frameDelay) 
                then 
                    DrawRectangle(190 + 21*i, 300, 20, 20, RED) 
                    DrawRectangleLines(190 + 21*i, 300, 20, 20, MAROON)
                end if 
            end for

            DrawTexture(texScarfyAnim, GetScreenWidth()/2 - texScarfyAnim[width]/2, 140, WHITE) 

            DrawText("(c) Scarfy sprite by Eiden Marsal", screenWidth - 200, screenHeight - 20, 10, GRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texScarfyAnim)    -- Unload texture
    UnloadImage(imScarfyAnim)       -- Unload image (contains all frames)

    CloseWindow()                   -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


