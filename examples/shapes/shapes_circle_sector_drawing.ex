/*******************************************************************************************
*
*   raylib [shapes] example - circle sector drawing
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2025 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
include std/machine.e
include std/math.e
--*/
--#define RAYGUI_IMPLEMENTATION
--#include "raygui.h"               -- Required for GUI controls

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - circle sector drawing")

    sequence center = {(GetScreenWidth() - 300)/2.0, GetScreenHeight()/2.0 }
    sequence txt="dabbadabbaduh"
    sequence col=GREEN
    atom outerRadius = 180.0
    atom startAngle = 0.0
    atom endAngle = 180.0
    atom segments = 10.0
    atom minSegments = 4
    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- NOTE: All variables update happens inside GUI control functions
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawLine(500, 0, 500, GetScreenHeight(), Fade(LIGHTGRAY, 0.6))
            DrawRectangle(500, 0, GetScreenWidth() - 500, GetScreenHeight(), Fade(LIGHTGRAY, 0.3))

            DrawCircleSector(center, outerRadius, startAngle, endAngle, segments, Fade(MAROON, 0.3))
            DrawCircleSectorLines(center, outerRadius, startAngle, endAngle, segments, Fade(MAROON, 0.6))

            -- Draw GUI controls // Slider Bar control alternate version you have to provide a unique id and value in this form {id,value}
            -- does not provide the has_changed information in the returned result but the value
            --------------------------------------------------------------------------------
            startAngle=GuiSliderBar({ 600, 40, 120, 20}, "StartAngle", sprintf("%.2d", startAngle), {1,startAngle}, 0, 720)
            endAngle=GuiSliderBar({ 600, 70, 120, 20}, "EndAngle", sprintf("%.2d", endAngle), {2,endAngle}, 0, 720)

            outerRadius=GuiSliderBar({ 600, 140, 120, 20}, "Radius", sprintf("%.2d", outerRadius), {3,outerRadius}, 0, 200)
            segments=GuiSliderBar({ 600, 170, 120, 20}, "Segments", sprintf("%.2d", segments), {4,segments}, 0, 100)
            --------------------------------------------------------------------------------

            
            minSegments = trunc(ceil((endAngle - startAngle)/90))
            if segments>=minSegments then
                col=MAROON
                txt="MANUAL"
            else
                col=DARKGRAY
                txt="AUTO"
            end if
            DrawText(sprintf("MODE: %s", {txt}), 600, 200, 10, col)

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------



