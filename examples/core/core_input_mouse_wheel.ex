/*******************************************************************************************
*
*   raylib [core] examples - Mouse wheel input
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.1, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant  screenWidth = 800
    constant  screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse wheel")

    atom boxPositionY = screenHeight/2 - 40
    atom scrollSpeed = 4            -- Scrolling speed in pixels
    integer pause = 0
    SetTargetFPS(10)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
            if (IsKeyPressed(KEY_SPACE)) then pause = not pause end if
        -- Update 
        ------------------------------------------------------------------------------------
        if not pause then
       boxPositionY -= (GetMouseWheelMove()*scrollSpeed)
        end if
        ------------------------------------------------------------------------------------
        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            
            ClearBackground(RAYWHITE)

            DrawRectangle(screenWidth/2 - 40, boxPositionY, 80, 80, MAROON)

            DrawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, GRAY)
            DrawText(sprintf("Box position Y: %d", boxPositionY), 10, 40, 20, LIGHTGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


