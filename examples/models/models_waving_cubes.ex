without warning
without type_check 
/*******************************************************************************************
*
*   raylib [models] example - waving cubes
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Codecat (@codecat) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2025 Codecat (@codecat) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--#include <math.h>     -- Required for: sinf()
--/*
include std/math.e
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 
    enum _position,target,up,fovy,projection
    enum x,y,z
    
    InitWindow(screenWidth, screenHeight, "raylib [models] example - waving cubes") 

    -- Initialize the camera
    sequence camera = Tcamera3D 
    camera[_position] = { 30.0, 20.0, 30.0 }  -- Camera position
    camera[target] = { 0.0, 0.0, 0.0 }      -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }          -- Camera up vector (rotation towards target)
    camera[fovy] = 70.0                                 -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE             -- Camera projection type

    -- Specify the amount of blocks in each direction
    integer numBlocks = 15

    --SetTargetFPS(60) 
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        atom _time = GetTime() 

        -- Calculate time scale for cube position and size
        atom scale = (2.0 + sin(_time))*0.7 

        -- Move camera around the scene
        atom cameraTime = _time*0.3 
        camera[_position][x] = cos(cameraTime)*40.0
        camera[_position][z] = sin(cameraTime)*40.0 
        ------------------------------------------------------------------------------------
        atom blockScale,scatter,cubeSize
        sequence cubePos,cubeColor
        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                DrawGrid(10, 5.0) 

                for x1 = 0 to numBlocks
                do
                    for y1 = 0 to numBlocks
                    do
                        for  z1 = 0 to numBlocks
                        do
                            -- Scale of the blocks depends on x/y/z positions
                            blockScale = (x1 + y1 + z1)/30.0 

                            -- Scatter makes the waving effect by adding blockScale over time
                            scatter = sin(blockScale*20.0 + (_time*4.0)) 
                            -- Calculate the cube position
                            cubePos = {(x1 - numBlocks/2)*(scale*3.0) + scatter,
                                                (y1 - numBlocks/2)*(scale*2.0) + scatter,
                                                (z1 - numBlocks/2)*(scale*3.0) + scatter} 

                            -- Pick a color with a hue depending on cube position for the rainbow color effect
                            -- NOTE: This function is quite costly to be done per cube and frame,
                            -- pre-catching the results into a separate array could improve performance
                            --sequence cubeColor = ColorFromHSV((((x + y + z)*18)%360), 0.75, 0.9) 
                            --/**/ cubeColor = ColorFromHSV_(remainder(((x1 + y1 + z1)*18),360), 0.75, 0.9)
                            --/*
                            cubeColor = ColorFromHSV(remainder(((x1 + y1 + z1)*18),360), 0.75, 0.9)
                            --*/
                            -- Calculate cube size
                            cubeSize = (2.4 - scale)*blockScale 

                            -- And finally, draw the cube!
                            DrawCube(cubePos, cubeSize, cubeSize, cubeSize, cubeColor) 
                        end for
                    end for
                end for

            EndMode3D() 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


