/*******************************************************************************************
*
*   raylib [shapes] example - triangle strip
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6-dev
*
*   Example contributed by Jopestpe (@jopestpe)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Jopestpe (@jopestpe)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--#include <math.h>

--#define RAYGUI_IMPLEMENTATION
--#include "raygui.h"               -- Required for GUI controls
enum x,y
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - triangle strip")

    sequence points = repeat({0,0},122+2)
    sequence center = { (screenWidth/2.0) - 125.0, screenHeight/2.0 }
    atom segments = 6.0
    atom insideRadius = 100.0
    atom outsideRadius = 150.0
    bool outline = true

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        atom pointCount =floor(segments)
        atom angleStep = (360.0/pointCount)*DEG2RAD
        integer i2 = 1 
        for i = 0 to pointCount 
        do
            atom angle1 = i*angleStep
            points[i2] = { center[x] + cos(angle1)*insideRadius, center[y] + sin(angle1)*insideRadius }
            atom angle2 = angle1 + angleStep/2.0
            points[i2 + 1] = { center[x] + cos(angle2)*outsideRadius, center[y] + sin(angle2)*outsideRadius }
            i2=i2+2
        end for
        
        points[pointCount*2+1] = points[1]
        points[pointCount*2+2 ] = points[2]
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            for i = 0 to pointCount-1
            do
                sequence a = points[i*2+1]
                sequence b = points[i*2 + 1+1]
                sequence c = points[i*2 + 2+1]
                sequence d = points[i*2 + 3+1]

                atom angle1 = i*angleStep
                --DrawTriangle(a, b, c, BLUE)
                DrawTriangle(c, b,a , ColorFromHSV(angle1*RAD2DEG, 1.0, 1.0))
                DrawTriangle(d, b, c, ColorFromHSV((angle1 + angleStep/2)*RAD2DEG, 1.0, 1.0))
                --DrawTriangle(c, b, d, RED)
                if (outline)
                then
                    DrawTriangleLines(a, b, c, BLACK)
                    DrawTriangleLines(c, b, d, BLACK)
                end if
            end for

            DrawLine(580, 0, 580, GetScreenHeight(), { 218, 218, 218, 255 })
            DrawRectangle(580, 0, GetScreenWidth(), GetScreenHeight(), { 232, 232, 232, 255 })

            -- Draw GUI controls
            --------------------------------------------------------------------------------
            segments=GuiSliderBar({ 640, 40, 120, 20}, "Segments", sprintf("%.0f", segments), {1,segments}, 6.0, 60.0)
            outline=GuiCheckBox({ 640, 70, 20, 20 }, "Outline", {2,outline})
            --------------------------------------------------------------------------------

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


