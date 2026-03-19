/*******************************************************************************************
*
*   raylib [models] example - directional billboard
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6
*
*   Example contributed by Robin (@RobinsAviary) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Robin (@RobinsAviary)
*   Killbot art by patvanmackelberg https://opengameart.org/content/killbot-8-directional under CC0
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--#include "raymath.h"
constant Vector3Zero={0,0,0}
constant Vector2One={1,1}

--#include <stdlib.h>
enum position_,target,up,fovy,projection
enum x=1,z=3
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [models] example - directional billboard")

    -- Set up the camera
    sequence camera=Tcamera3D

    camera[position_] = { 2.0, 1.0, 2.0 } -- Starting position
    camera[target] = { 0.0, 0.5, 0.0 }  -- Target position
    camera[up] = { 0.0, 1.0, 0.0 } -- Up vector
    camera[fovy] = 45.0 -- FOV
    camera[projection] = CAMERA_PERSPECTIVE; -- Projection type (Standard 3D perspective)

    -- Load billboard texture
    sequence skillbot = LoadTexture("resources/skillbot.png")

    -- Timer to update animation
    atom anim_timer = 0.0
    -- Animation frame
    integer anim = 0

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_ORBITAL)

        -- Update timer with delta time
        anim_timer += GetFrameTime()

        -- Update frame index after a certain amount of time (half a second)
        if (anim_timer > 0.5)
        then
            anim_timer = 0.0
            anim += 1
        end if

        -- Reset frame index to zero on overflow
        if (anim >= 4) then anim = 0 end if

        -- Find the current direction frame based on the camera position to the billboard object
        atom dir_ = floor(((Vector2Angle({ 2.0, 0.0 },{ camera[position_][x], camera[position_][z] })/PI)*4.0) + 0.25)

        -- Correct frame index if angle is negative
        if (dir_ < 0.0)
        then
            dir_ = 8.0 - abs(dir_)
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            DrawGrid(10, 1.0)

            -- Draw billboard pointing straight up to the sky, rotated relative to the camera and offset from the bottom
            DrawBillboardPro(camera, skillbot,{ 0.0 + (anim*24.0), 0.0 + (dir_*24.0), 24.0, 24.0 }, Vector3Zero,{ 0.0, 1.0, 0.0 }, Vector2One,{ 0.5, 0.0 }, 0, WHITE)

        EndMode3D()

        -- Render various variables for reference
        DrawText(sprintf("animation: %d", anim), 10, 10, 20, DARKGRAY)
        DrawText(sprintf("direction frame: %.0d", dir_), 10, 40, 20, DARKGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    -- Unload billboard texture
    UnloadTexture(skillbot)

    CloseWindow()     -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


