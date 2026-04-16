/*******************************************************************************************
*
*   raylib [models] example - geometric shapes
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.0, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 
    enum _position,target,up,fovy,projection
    InitWindow(screenWidth, screenHeight, "raylib [models] example - geometric shapes") 

    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D 
    camera[_position] = { 0.0, 10.0, 10.0 } 
    camera[target] = { 0.0, 0.0, 0.0 } 
    camera[up] = { 0.0, 1.0, 0.0 } 
    camera[fovy] = 45.0
    camera[projection] = CAMERA_PERSPECTIVE 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- TODO: Update your variables here
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                DrawCube({-4.0, 0.0, 2.0}, 2.0, 5.0, 2.0, RED) 
                DrawCubeWires({-4.0, 0.0, 2.0}, 2.0, 5.0, 2.0, GOLD) 
                DrawCubeWires({-4.0, 0.0, -2.0}, 3.0, 6.0, 2.0, MAROON) 

                DrawSphere({-1.0, 0.0, -2.0}, 1.0, GREEN) 
                DrawSphereWires({1.0, 0.0, 2.0}, 2.0, 16, 16, LIME) 

                DrawCylinder({4.0, 0.0, -2.0}, 1.0, 2.0, 3.0, 4, SKYBLUE) 
                DrawCylinderWires({4.0, 0.0, -2.0}, 1.0, 2.0, 3.0, 4, DARKBLUE) 
                DrawCylinderWires({4.5, -1.0, 2.0}, 1.0, 1.0, 2.0, 6, BROWN) 

                DrawCylinder({1.0, 0.0, -4.0}, 0.0, 1.5, 3.0, 8, GOLD) 
                DrawCylinderWires({1.0, 0.0, -4.0}, 0.0, 1.5, 3.0, 8, PINK) 

                DrawCapsule     ({-3.0, 1.5, -4.0},{-4.0, -1.0, -4.0}, 1.2, 8, 8, VIOLET) 
                DrawCapsuleWires({-3.0, 1.5, -4.0}, {-4.0, -1.0, -4.0}, 1.2, 8, 8, PURPLE) 

                DrawGrid(10, 1.0)      -- Draw a grid

            EndMode3D() 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


