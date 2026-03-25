/*******************************************************************************************
*
*   raylib [audio] example - sound loading
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.1, last time updated with raylib 3.5
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
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - sound loading")

    InitAudioDevice()       -- Initialize audio device

    sequence fxWav = LoadSound("resources/sound.wav")       -- Load WAV audio file
    sequence fxOgg = LoadSound("resources/target.ogg")      -- Load OGG audio file

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_SPACE)) then PlaySound(fxWav) end if       -- Play WAV sound
        if (IsKeyPressed(KEY_ENTER)) then PlaySound(fxOgg) end if   -- Play OGG sound
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawText("Press SPACE to PLAY the WAV sound!", 200, 180, 20, LIGHTGRAY)
            DrawText("Press ENTER to PLAY the OGG sound!", 200, 220, 20, LIGHTGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadSound(fxWav)  -- Unload sound data
    UnloadSound(fxOgg)  -- Unload sound data

    CloseAudioDevice()  -- Close audio device

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


