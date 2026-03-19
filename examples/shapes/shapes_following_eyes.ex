/*******************************************************************************************
*
*   raylib [shapes] example - following eyes
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
include std/math.e
--*/

enum x,y
--#include <math.h>     -- Required for: atan2f()

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant  screenWidth = 800
    constant  screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - following eyes")

    sequence scleraLeftPosition = { GetScreenWidth()/2.0 - 100.0, GetScreenHeight()/2.0 }
    sequence scleraRightPosition = { GetScreenWidth()/2.0 + 100.0, GetScreenHeight()/2.0 }
    atom scleraRadius = 80

    sequence irisLeftPosition = { GetScreenWidth()/2.0 - 100.0, GetScreenHeight()/2.0 }
    sequence irisRightPosition = { GetScreenWidth()/2.0 + 100.0, GetScreenHeight()/2.0 }
    atom irisRadius = 24

    atom angle = 0.0
    atom dx = 0.0, 
         dy = 0.0,
         dxx = 0.0,
         dyy = 0.0

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        irisLeftPosition = GetMousePosition()
        irisRightPosition = GetMousePosition()

        -- Check not inside the left eye sclera
        if not ( CheckCollisionPointCircle(irisLeftPosition, scleraLeftPosition, scleraRadius - irisRadius)) 
        then
            dx = irisLeftPosition[x] - scleraLeftPosition[x]
            dy = irisLeftPosition[y] - scleraLeftPosition[y]

            angle = atan2(dy, dx)

            dxx = (scleraRadius - irisRadius)*cos(angle)
            dyy = (scleraRadius - irisRadius)*sin(angle)

            irisLeftPosition[x] = scleraLeftPosition[x] + dxx
            irisLeftPosition[y] = scleraLeftPosition[y] + dyy
        end if

        -- Check not inside the right eye sclera
        if not (CheckCollisionPointCircle(irisRightPosition, scleraRightPosition, scleraRadius - irisRadius))
        then
            dx = irisRightPosition[x] - scleraRightPosition[x]
            dy = irisRightPosition[y] - scleraRightPosition[y]

            angle = atan2(dy, dx)

            dxx = (scleraRadius - irisRadius)*cos(angle)
            dyy = (scleraRadius - irisRadius)*sin(angle)

            irisRightPosition[x] = scleraRightPosition[x] + dxx
            irisRightPosition[y] = scleraRightPosition[y] + dyy
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawCircleV(scleraLeftPosition, scleraRadius, LIGHTGRAY)
            DrawCircleV(irisLeftPosition, irisRadius, BROWN)
            DrawCircleV(irisLeftPosition, 10, BLACK)

            DrawCircleV(scleraRightPosition, scleraRadius, LIGHTGRAY)
            DrawCircleV(irisRightPosition, irisRadius, DARKGREEN)
            DrawCircleV(irisRightPosition, 10, BLACK)

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


