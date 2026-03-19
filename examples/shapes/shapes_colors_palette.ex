/*******************************************************************************************
*
*   raylib [shapes] example - Colors palette
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.0, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix 2026  Andreas Wagner
include "../../raylib64.e"
--/*
include std/math.e
--*/
constant MAX_COLORS_COUNT=21            -- Number of colors available

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - colors palette")

    sequence colors = {
        DARKGRAY, MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN,
        GRAY, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK, YELLOW,
        GREEN, SKYBLUE, PURPLE, BEIGE }

    sequence colorNames = {"DARKGRAY", "MAROON", "ORANGE", "DARKGREEN", "DARKBLUE", "DARKPURPLE",
        "DARKBROWN", "GRAY", "RED", "GOLD", "LIME", "BLUE", "VIOLET", "BROWN",
        "LIGHTGRAY", "PINK", "YELLOW", "GREEN", "SKYBLUE", "PURPLE", "BEIGE" }

    sequence colorsRecs=repeat({0,0,0,0},MAX_COLORS_COUNT)      -- Rectangles array
    enum x,y,width,height
    sequence RecX={0,0,0,0}
    atom fade=0
    
    -- Fills colorsRecs data (for every rectangle)
    for i= 0 to MAX_COLORS_COUNT-1 do
        RecX=colorsRecs[i+1]
        RecX[x] = 20.0 + 100.0 *(mod(i,7)) + 10.0 *(mod(i,7))
        RecX[y] = 80.0 + 100.0 *floor(i/7) + 10.0 *floor(i/7)
        RecX[width] = 100.0
        RecX[height] = 100.0
        colorsRecs[i+1]=RecX
    end for

    sequence colorState=repeat(0,MAX_COLORS_COUNT)          -- Color state: 0-DEFAULT, 1-MOUSE_HOVER

    sequence mousePoint = { 0.0, 0.0 }

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        mousePoint = GetMousePosition()

        for i = 1 to  MAX_COLORS_COUNT do
            RecX=colorsRecs[i]
            if (CheckCollisionPointRec(mousePoint, RecX)) then 
                colorState[i] = 1
            else 
                colorState[i] = 0
            end if
        
        end for
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawText("raylib colors palette", 28, 42, 20, BLACK)
            DrawText("press SPACE to see all colors", GetScreenWidth() - 180, GetScreenHeight() - 40, 10, GRAY)

            for i = 1 to MAX_COLORS_COUNT     -- Draw all rectangles
            do
                RecX=colorsRecs[i]
                if colorState[i] then
                    fade=0.6
                else
                    fade=1.0
                end if
                DrawRectangleRec(RecX, Fade(colors[i], fade))

                if (IsKeyDown(KEY_SPACE) or colorState[i]) then
            
                    DrawRectangle(RecX[x],RecX[y] + RecX[height] - 26, RecX[width], 20, BLACK)
                    DrawRectangleLinesEx(RecX, 6, Fade(BLACK, 0.3))
                    DrawText(colorNames[i], (RecX[x] + RecX[width] - MeasureText(colorNames[i], 10) - 12),(RecX[y] + RecX[height] - 20), 10, colors[i])
                    
                end if
            end for

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()                 -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


