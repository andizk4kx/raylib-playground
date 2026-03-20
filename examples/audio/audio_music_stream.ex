/*******************************************************************************************
*
*   raylib [audio] example - music stream
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
constant true=1
constant false=0
--include raylib.e
--*/

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - music stream")

    InitAudioDevice()               -- Initialize audio device

    sequence music = LoadMusicStream("resources/country.mp3")
    PlayMusicStream(music)

    atom timePlayed = 0.0       -- Time played normalized [0.0f..1.0f]
    integer pause = false           -- Music playing paused

    atom pan = 0.0              -- Default audio pan center [-1.0f..1.0f]
    SetMusicPan(music, pan)

    atom volume = 0.8           -- Default audio volume [0.0f..1.0f]
    SetMusicVolume(music, volume)

    SetTargetFPS(30)                -- Set our game to run at 30 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        UpdateMusicStream(music)    -- Update music buffer with new stream data

        -- Restart music playing (stop and play)
        if (IsKeyPressed(KEY_SPACE))
        then
            StopMusicStream(music)
            PlayMusicStream(music)
        end if

        -- Pause/Resume music playing
        if (IsKeyPressed(KEY_P))
        then
            pause = not pause

            if (pause) 
            then 
                PauseMusicStream(music)
            else 
                ResumeMusicStream(music)
            end if
        end if

        -- Set audio pan
        if (IsKeyDown(KEY_LEFT))
        then
            pan -= 0.05
            if (pan < -1.0) 
            then 
                pan = -1.0
            end if
            SetMusicPan(music, pan)
        
        elsif (IsKeyDown(KEY_RIGHT))
        then
            pan += 0.05
            if (pan > 1.0) then pan = 1.0 end if
            SetMusicPan(music, pan)
        end if

        -- Set audio volume
        if (IsKeyDown(KEY_DOWN))
        then
            volume -= 0.05
            if (volume < 0.0) then  volume = 0.0 end if
            SetMusicVolume(music, volume)
        
        elsif (IsKeyDown(KEY_UP))
        then
            volume += 0.05
            if (volume > 1.0) then volume = 1.0 end if
            SetMusicVolume(music, volume)
        end if

        -- Get normalized time played for current music stream
        timePlayed = GetMusicTimePlayed(music)/GetMusicTimeLength(music)

        if (timePlayed > 1.0) then timePlayed = 1.0 end if  -- Make sure time played is no longer than music
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawText("MUSIC SHOULD BE PLAYING!", 255, 150, 20, LIGHTGRAY)

            DrawText("LEFT-RIGHT for PAN CONTROL", 320, 74, 10, DARKBLUE)
            DrawRectangle(300, 100, 200, 12, LIGHTGRAY)
            DrawRectangleLines(300, 100, 200, 12, GRAY)
            DrawRectangle((300 + (pan + 1.0)/2.0*200 - 5), 92, 10, 28, DARKGRAY)

            DrawRectangle(200, 200, 400, 12, LIGHTGRAY)
            DrawRectangle(200, 200, (timePlayed*400.0), 12, MAROON)
            DrawRectangleLines(200, 200, 400, 12, GRAY)

            DrawText("PRESS SPACE TO RESTART MUSIC", 215, 250, 20, LIGHTGRAY)
            DrawText("PRESS P TO PAUSE/RESUME MUSIC", 208, 280, 20, LIGHTGRAY)

            DrawText("UP-DOWN for VOLUME CONTROL", 320, 334, 10, DARKGREEN)
            DrawRectangle(300, 360, 200, 12, LIGHTGRAY)
            DrawRectangleLines(300, 360, 200, 12, GRAY)
            DrawRectangle((300 + volume*200 - 5), 352, 10, 28, DARKGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadMusicStream(music)    -- Unload music stream buffers from RAM

    CloseAudioDevice()      -- Close audio device (music streaming is automatically stopped)

    CloseWindow()               -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


