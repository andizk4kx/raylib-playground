/*******************************************************************************************
*
*   raylib [core] example - Mouse input
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.0, last time updated with raylib 5.5
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
    atom screenWidth = 800
    atom screenHeight = 450
procedure main()

    -- Initialization
    ----------------------------------------------------------------------------------------


    InitWindow(screenWidth, screenHeight, "raylib [core] example - mouse input")

    sequence ballPosition = { -100.0, -100.0 }
    sequence ballColor = DARKBLUE
    integer isCursorHidden = 0

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    -----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_H)) then
        
            if (isCursorHidden = 0) then
                HideCursor()
                isCursorHidden = 1
            
            else
            
                ShowCursor()
                isCursorHidden = 0
            end if
        end if
        
        ballPosition = GetMousePosition()

        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT))then ballColor = MAROON
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE))then ballColor = LIME
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_RIGHT))then ballColor = DARKBLUE
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_SIDE))then ballColor = PURPLE
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_EXTRA))then ballColor = YELLOW
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_FORWARD))then ballColor = ORANGE
        elsif (IsMouseButtonPressed(MOUSE_BUTTON_BACK))then ballColor = BEIGE
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawCircleV(ballPosition, 40, ballColor)

            DrawText("move ball with mouse and click mouse button to change color", 10, 10, 20, DARKGRAY)
            DrawText("Press 'H' to toggle cursor visibility", 10, 30, 20, DARKGRAY)

            if (isCursorHidden = 1)then 
                DrawText("CURSOR HIDDEN", 20, 60, 20, RED)
                else 
                DrawText("CURSOR VISIBLE", 20, 60, 20, LIME)
            end if
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------

    --  return 0
    
end procedure
main()
