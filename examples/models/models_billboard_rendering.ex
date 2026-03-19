/*******************************************************************************************
*
*   raylib [models] example - billboard rendering
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--#include "raymath.h"
enum position_,target,up,fovy,projection
enum width=2,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [models] example - billboard rendering")

    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D
    camera[position_] = { 5.0, 4.0, 5.0 }   -- Camera position
    camera[target] = { 0.0, 2.0, 0.0 }      -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }      -- Camera up vector (rotation towards target)
    camera[fovy] = 45.0                             -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE         -- Camera projection type
    sequence fname="resources/billboard.png"
    ifdef PHIX then
        fname="resources/phix.png"
    end ifdef
    sequence bill = LoadTexture(fname)  -- Our billboard texture
    sequence billPositionStatic = { 0.0, 2.0, 0.0 }     -- Position of static billboard
    sequence billPositionRotating = { 1.0, 2.0, 1.0 }       -- Position of rotating billboard

    -- Entire billboard texture, source is used to take a segment from a larger texture
    sequence source = { 0.0, 0.0, bill[width], bill[height] }

    -- NOTE: Billboard locked on axis-Y
    sequence billUp = { 0.0, 1.0, 0.0 }

    -- Set the height of the rotating billboard to 1.0 with the aspect ratio fixed
    sequence size = { source[3]/source[4], 1.0 }

    -- Rotate around origin
    -- Here we choose to rotate around the image center
    sequence origin = Vector2Scale(size, 0.5)

    -- Distance is needed for the correct billboard draw order
    -- Larger distance (further away from the camera) should be drawn prior to smaller distance
    atom distanceStatic
    atom distanceRotating
    atom rotation = 0.0

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose())     -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_ORBITAL)

        rotation += 0.4
        distanceStatic = Vector3Distance(camera[position_], billPositionStatic)
        distanceRotating = Vector3Distance(camera[position_], billPositionRotating)

        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            BeginMode3D(camera)

                DrawGrid(10, 1.0)      -- Draw a grid

                -- Draw order matters!
                if (distanceStatic > distanceRotating)
                then
                    DrawBillboard(camera, bill, billPositionStatic, 2.0, WHITE)
                    DrawBillboardPro(camera, bill, source, billPositionRotating, billUp, size, origin, rotation, WHITE)
                else
                    DrawBillboardPro(camera, bill, source, billPositionRotating, billUp, size, origin, rotation, WHITE)
                    DrawBillboard(camera, bill, billPositionStatic, 2.0, WHITE)
                end if

            EndMode3D()

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(bill)     -- Unload texture

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


