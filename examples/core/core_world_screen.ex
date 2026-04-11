/*******************************************************************************************
*
*   raylib [core] example - world screen
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
enum _position,target,up,fovy,projection
enum x,y,z
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - world screen") 

    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D 
    camera[_position] = { 10.0, 10.0, 10.0 }  -- Camera position
    camera[target] = { 0.0, 0.0, 0.0 }      -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }          -- Camera up vector (rotation towards target)
    camera[fovy] = 45.0                             -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE             -- Camera projection type

    sequence cubePosition = { 0.0, 0.0, 0.0 } 
    sequence cubeScreenPosition = { 0.0, 0.0 } 

    DisableCursor()                     -- Limit cursor to relative movement inside the window

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())      -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_THIRD_PERSON) 

        -- Calculate cube screen space position (with a little offset to be in top)
        cubeScreenPosition = GetWorldToScreen({cubePosition[x], cubePosition[y] + 2.5, cubePosition[z]}, camera) 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                DrawCube(cubePosition, 2.0, 2.0, 2.0, RED) 
                DrawCubeWires(cubePosition, 2.0, 2.0, 2.0, MAROON) 

                DrawGrid(10, 1.0) 

            EndMode3D() 

            DrawText("Enemy: 100/100", cubeScreenPosition[x] - MeasureText("Enemy: 100/100", 20)/2, cubeScreenPosition[y], 20, BLACK) 

            DrawText(TextFormat("Cube position in screen space coordinates: [%i, %i]", {cubeScreenPosition[x], cubeScreenPosition[y]}), 10, 10, 20, LIME) 
            DrawText("Text 2d should be always on top of the cube", 10, 40, 20, GRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


