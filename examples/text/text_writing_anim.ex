/*******************************************************************************************
*
*   raylib [text] example - writing anim
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.4, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [text] example - writing anim")

    sequence message = "This sample illustrates a text writing\nanimation effect! Check it out! ;)"

    integer framesCounter = 0

    SetTargetFPS(60)            -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyDown(KEY_SPACE)) 
        then 
            framesCounter += 8 
        else 
            framesCounter+=1 
        end if
        if (IsKeyPressed(KEY_ENTER)) then framesCounter = 0 end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText(TextSubtext(message, 0, framesCounter/10), 210, 160, 20, MAROON) 

            DrawText("PRESS [ENTER] to RESTART!", 240, 260, 20, LIGHTGRAY) 
            DrawText("HOLD [SPACE] to SPEED UP!", 239, 300, 20, LIGHTGRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


