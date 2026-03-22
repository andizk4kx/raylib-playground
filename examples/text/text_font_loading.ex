/*******************************************************************************************
*
*   raylib [text] example - font loading
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   NOTE: raylib can load fonts from multiple input file formats:
*
*     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
*                 some of the generation parameters (size, characters to include)
*     - BMFonts > Angel code font fileformat, sprite font image must be provided
*                 together with the .fnt file, font generation can not be configured
*     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
*                 Characters in image must follow some spacing and order rules
*
*   Example originally created with raylib 1.4, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
--include raylib.e
constant true=1
constant false=0
--*/
enum baseSize
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [text] example - font loading")

    -- Define characters to draw
    -- NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
    sequence msg = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ\nÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷\nøùúûüýþÿ"

    -- NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    -- BMFont (AngelCode) : Font data and image atlas have been generated using external program
    sequence fontBm = LoadFont("resources/pixantiqua.fnt")

    -- TTF font : Font data and atlas are generated directly from TTF
    -- NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
    sequence fontTtf = LoadFontEx("resources/pixantiqua.ttf", 32, 0, 250)

    SetTextLineSpacing(16)      -- Set line spacing for multiline text (when line breaks are included '\n')

    integer useTtf = false

    --SetTargetFPS(60)          -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyDown(KEY_SPACE)) 
        then 
            useTtf = true
        else 
            useTtf = false
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawText("Hold SPACE to use TTF generated font", 20, 20, 20, LIGHTGRAY)

            if not(useTtf)
            then
                DrawTextEx(fontBm, msg, { 20.0, 100.0 }, fontBm[baseSize], 2, MAROON)
                DrawText("Using BMFont (Angelcode) imported", 20, GetScreenHeight() - 30, 20, GRAY)
            else
                DrawTextEx(fontTtf, msg,{ 20.0, 100.0 }, fontTtf[baseSize], 2, LIME)
                DrawText("Using TTF font generated", 20, GetScreenHeight() - 30, 20, GRAY)
            end if
            DrawFPS(10,10)
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadFont(fontBm)  -- AngelCode Font unloading
    UnloadFont(fontTtf) -- TTF Font unloading

    CloseWindow()       -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


