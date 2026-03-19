/*******************************************************************************************
*
*   raylib [audio] example - module playing
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.5
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
constant true=1
constant false=0
--include raylib.e
--*/

constant MAX_CIRCLES =64

--typedef struct {
--  Vector2 position;
--  float radius;
--  float alpha;
--  float speed;
--  Color color;
--} CircleWave;
sequence CircleWave={{0,0},0,0,0,{0,0,0,0}}
enum position_,radius,alpha,speed,color
enum x,y,looping=3

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    SetConfigFlags(FLAG_MSAA_4X_HINT)   -- NOTE: Try to enable MSAA 4X

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - module playing")

    InitAudioDevice()                   -- Initialize audio device

    sequence colors= { ORANGE, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK,
                         YELLOW, GREEN, SKYBLUE, PURPLE, BEIGE }

    -- Creates some circles for visual effect
    sequence circles=repeat(CircleWave,MAX_CIRCLES)

    for  i = MAX_CIRCLES -1 to 1 by -1
    do
        circles[i][alpha] = 0.0
        circles[i][radius] = GetRandomValue(10, 40)
        circles[i][position_][x] = GetRandomValue(circles[i][radius], (screenWidth - circles[i][radius]))
        circles[i][position_][y] = GetRandomValue(circles[i][radius], (screenHeight - circles[i][radius]))
        circles[i][speed] = GetRandomValue(1, 100)/2000.0
        circles[i][color] = colors[GetRandomValue(1, 13)]
    end for

    sequence music = LoadMusicStream("resources/country.mp3")
    
    music[looping] = false
    atom pitch = 1.0

    PlayMusicStream(music)

    atom timePlayed = 0.0
    integer pause = false

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        UpdateMusicStream(music)       -- Update music buffer with new stream data

        -- Restart music playing (stop and play)
        if (IsKeyPressed(KEY_SPACE))
        then
            StopMusicStream(music)
            PlayMusicStream(music)
            pause = false
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

        if (IsKeyDown(KEY_DOWN)) 
        then 
            pitch -= 0.01
        elsif (IsKeyDown(KEY_UP)) 
        then 
            pitch += 0.01
        end if
        
        SetMusicPitch(music, pitch)

        -- Get timePlayed scaled to bar dimensions
        --?GetMusicTimePlayed(music)
        timePlayed = GetMusicTimePlayed(music)/GetMusicTimeLength(music)*(screenWidth - 40)
        -- Color circles animation
        if not pause 
        then
        for i = MAX_CIRCLES - 1 to 1 by -1
        do
            circles[i][alpha] += circles[i][speed]
            circles[i][radius] += circles[i][speed]*10.0

            if (circles[i][alpha] > 1.0) then circles[i][speed] *= -1 end if

            if (circles[i][alpha] <= 0.0)
            then
                circles[i][alpha] = 0.0
                circles[i][radius] = GetRandomValue(10, 40)
                circles[i][position_][x] = GetRandomValue(circles[i][radius], (screenWidth - circles[i][radius]))
                circles[i][position_][y] = GetRandomValue(circles[i][radius], (screenHeight - circles[i][radius]))
                circles[i][color] = colors[GetRandomValue(1, 13)]
                circles[i][speed] = GetRandomValue(1, 100)/2000.0
            end if
        end for
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            for  i = MAX_CIRCLES - 1 to 1 by -1
            do
                DrawCircleV (circles[i][position_], circles[i][radius], Fade(circles[i][color], circles[i][alpha]))
            end for

            -- Draw time bar
            DrawRectangle(20, screenHeight - 20 - 12, screenWidth - 40, 12, LIGHTGRAY)
            DrawRectangle(20, screenHeight - 20 - 12, timePlayed, 12, MAROON)
            DrawRectangleLines(20, screenHeight - 20 - 12, screenWidth - 40, 12, GRAY)

            -- Draw help instructions
            DrawRectangle(20, 20, 425, 145, WHITE)
            DrawRectangleLines(20, 20, 425, 145, GRAY)
            DrawText("PRESS SPACE TO RESTART MUSIC", 40, 40, 20, BLACK)
            DrawText("PRESS P TO PAUSE/RESUME", 40, 70, 20, BLACK)
            DrawText("PRESS UP/DOWN TO CHANGE SPEED", 40, 100, 20, BLACK)
            DrawText(sprintf("SPEED: %f", pitch), 40, 130, 20, MAROON)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadMusicStream(music)       -- Unload music stream buffers from RAM

    CloseAudioDevice()  -- Close audio device (music streaming is automatically stopped)

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


