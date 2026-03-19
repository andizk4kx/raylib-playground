/*******************************************************************************************
*
*   raylib [shapes] example - rounded rectangle drawing
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
constant true=1
constant false=0
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

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - rounded rectangle drawing")

    atom roundness = 0.2
    atom width = 200.0
    atom height = 100.0
    atom segments = 0.0
    atom lineThick = 1.0

    integer drawRect = false
    integer drawRoundedRect = true
    integer drawRoundedLines = false
    sequence txt=""
    sequence col=GREEN
    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        sequence rec = { (GetScreenWidth() - width - 250)/2, (GetScreenHeight() - height)/2.0, width, height }
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawLine(560, 0, 560, GetScreenHeight(), Fade(LIGHTGRAY, 0.6))
            DrawRectangle(560, 0, GetScreenWidth() - 500, GetScreenHeight(), Fade(LIGHTGRAY, 0.3))

            if (drawRect) then DrawRectangleRec(rec, Fade(GOLD, 0.6)) end if
            if (drawRoundedRect) then DrawRectangleRounded(rec, roundness,segments, Fade(MAROON, 0.2)) end if
            if (drawRoundedLines)then DrawRectangleRoundedLinesEx(rec, roundness, segments, lineThick, Fade(MAROON, 0.4)) end if

            -- Draw GUI controls
            --------------------------------------------------------------------------------
            --drawRect=_GuiSliderBar({ 600, 40, 120, 20}, "StartAngle", sprintf("%.2d", drawRect), {1,drawRect}, 0, 720)
            width=GuiSliderBar({ 640, 40, 105, 20 }, "Width", sprintf("%.2d", width), {1,width}, 0, GetScreenWidth() - 300)
            height=GuiSliderBar({ 640, 70, 105, 20 }, "Height", sprintf("%.2d", height), {2,height}, 0, GetScreenHeight() - 50)
            roundness=GuiSliderBar({ 640, 140, 105, 20 }, "Roundness", sprintf("%.2d", roundness), {3,roundness}, 0.0, 1.0)
            lineThick=GuiSliderBar({ 640, 170, 105, 20 }, "Thickness", sprintf("%.2d", lineThick), {4,lineThick}, 0, 20)
            segments=GuiSliderBar({ 640, 240, 105, 20}, "Segments", sprintf("%.2d", segments), {5,segments}, 0, 60)

            drawRoundedRect=GuiCheckBox({ 640, 320, 20, 20 }, "DrawRoundedRect", {6,drawRoundedRect})
            drawRoundedLines=GuiCheckBox({ 640, 350, 20, 20 }, "DrawRoundedLines", {7,drawRoundedLines})
            drawRect=GuiCheckBox({ 640, 380, 20, 20}, "DrawRect", {8,drawRect})
            --------------------------------------------------------------------------------
            if segments>=4 then
                col=MAROON
                txt="MANUAL"
            else
                col=DARKGRAY
                txt="AUTO"
            end if

            DrawText(sprintf("MODE: %s",{ txt}), 640, 280, 10, col)

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


