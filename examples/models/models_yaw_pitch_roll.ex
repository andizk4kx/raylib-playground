/*******************************************************************************************
*
*   raylib [models] example - yaw pitch roll
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2025 Berni (@Berni8k) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--#include "raymath.h"      -- Required for: MatrixRotateXYZ()
enum transform =1
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    --SetConfigFlags(FLAG_MSAA_4X_HINT | FLAG_WINDOW_HIGHDPI) 
    InitWindow(screenWidth, screenHeight, "raylib [models] example - yaw pitch roll") 

    sequence camera = {  
    { 0.0, 50.0, -120.0 }, -- Camera position perspective
    { 0.0, 0.0, 0.0 },  -- Camera looking at point
    { 0.0, 1.0, 0.0 },  -- Camera up vector (rotation towards target)
    30.0,                   -- Camera field-of-view Y
    CAMERA_PERSPECTIVE}     -- Camera type

    sequence model = LoadModel("resources/models/obj/plane.obj")                    -- Load model
    sequence texture = LoadTexture("resources/models/obj/plane_diffuse.png")    -- Load model texture
    model[mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture             -- Set map diffuse texture

    atom pitch = 0.0
    atom roll = 0.0 
    atom yaw = 0.0 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Plane pitch (x-axis) controls
        if (IsKeyDown(KEY_DOWN)) 
        then 
            pitch += 0.6
        elsif (IsKeyDown(KEY_UP)) 
        then 
            pitch -= 0.6 
        else
            if (pitch > 0.3)
            then 
                pitch -= 0.3
            elsif (pitch < -0.3) 
            then 
                pitch += 0.3
            end if 
        end if

        -- Plane yaw (y-axis) controls
        if (IsKeyDown(KEY_S)) 
        then 
            yaw -= 1.0 
        elsif (IsKeyDown(KEY_A)) 
        then 
            yaw += 1.0 
        else
            if (yaw > 0.0) 
            then 
                yaw -= 0.5
            elsif (yaw < 0.0) 
            then 
                yaw += 0.5 
            end if
        end if

        -- Plane roll (z-axis) controls
        if (IsKeyDown(KEY_LEFT)) 
        then 
            roll -= 1.0
        elsif (IsKeyDown(KEY_RIGHT)) 
        then 
            roll += 1.0 
        else
            if (roll > 0.0) 
            then 
                roll -= 0.5 
            elsif (roll < 0.0) 
            then 
                roll += 0.5
            end if 
        end if

        -- Tranformation matrix for rotations
        
        model[transform] = MatrixRotateXYZ({ DEG2RAD*pitch, DEG2RAD*yaw, DEG2RAD*roll }) 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            -- Draw 3D model (recomended to draw 3D always before 2D)
            BeginMode3D(camera) 

                DrawModel(model,{ 0.0, -8.0, 0.0 }, 1.0, WHITE)      -- Draw 3d model with texture
                DrawGrid(10, 10.0) 

            EndMode3D() 

            -- Draw controls info
            DrawRectangle(30, 370, 260, 70, Fade(GREEN, 0.5)) 
            DrawRectangleLines(30, 370, 260, 70, Fade(DARKGREEN, 0.5)) 
            DrawText("Pitch controlled with: KEY_UP / KEY_DOWN", 40, 380, 10, DARKGRAY) 
            DrawText("Roll controlled with: KEY_LEFT / KEY_RIGHT", 40, 400, 10, DARKGRAY) 
            DrawText("Yaw controlled with: KEY_A / KEY_S", 40, 420, 10, DARKGRAY) 

            DrawText("(c) WWI Plane Model created by GiaHanLam", screenWidth - 240, screenHeight - 20, 10, DARKGRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadModel(model)      -- Unload model data
    UnloadTexture(texture)  -- Unload texture data

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


