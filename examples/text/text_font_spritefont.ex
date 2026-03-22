/*******************************************************************************************
*
*   raylib [text] example - font spritefont
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   NOTE: Sprite fonts should be generated following this conventions:
*
*     - Characters must be ordered starting with character 32 (Space)
*     - Every character must be contained within the same Rectangle height
*     - Every character and every line must be separated by the same distance (margin/padding)
*     - Rectangles must be defined by a MAGENTA color background
*
*   Following those constraints, a font can be provided just by an image,
*   this is quite handy to avoid additional font descriptor files (like BMFonts use)
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
--include raylib.e
--*/
constant baseSize = 1
constant x=1
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [text] example - font spritefont")

    sequence msg1 = "THIS IS A custom SPRITE FONT..."
    sequence msg2 = "...and this is ANOTHER CUSTOM font..."
    sequence msg3 = "...and a THIRD one! GREAT! :D"

    -- NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)
    sequence font1 = LoadFont("resources/custom_mecha.png")       -- Font loading
    sequence font2 = LoadFont("resources/custom_alagard.png")         -- Font loading
    sequence font3 = LoadFont("resources/custom_jupiter_crash.png")  -- Font loading
    sequence size1=MeasureTextEx(font1, msg1, font1[baseSize], -3)
    sequence size2=MeasureTextEx(font2, msg2, font2[baseSize], -2.0)
    sequence size3=MeasureTextEx(font3, msg3, font3[baseSize], 2.0)

    sequence fontPosition1 = { screenWidth/2.0 - size1[x]/2,screenHeight/2.0 - font1[baseSize]/2.0 - 80.0 }
    sequence fontPosition2 = { screenWidth/2.0 - size2[x]/2.0,screenHeight/2.0 - font2[baseSize]/2.0 - 10.0 }
    sequence fontPosition3 = { screenWidth/2.0 - size3[x]/2.0,screenHeight/2.0 - font3[baseSize]/2.0 + 50.0 }

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- TODO: Update variables here...
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawTextEx(font1, msg1, fontPosition1, font1[baseSize], -3, WHITE)
            DrawTextEx(font2, msg2, fontPosition2, font2[baseSize], -2, WHITE)
            DrawTextEx(font3, msg3, fontPosition3, font3[baseSize], 2, WHITE)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadFont(font1)       -- Font unloading
    UnloadFont(font2)       -- Font unloading
    UnloadFont(font3)       -- Font unloading

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


