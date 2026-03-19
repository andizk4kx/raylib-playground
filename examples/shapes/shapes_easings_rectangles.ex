/*******************************************************************************************
*
*   raylib [shapes] example - easings rectangles
*
*   Example complexity rating: [★★★☆] 3/4
*
*   NOTE: This example requires 'easings.h' library, provided on raylib/src. Just copy
*   the library to same directory as example or make sure it's available on include path
*
*   Example originally created with raylib 2.0, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
include "reasings.e"          -- Required for easing functions
--include raylib.e


constant RECS_WIDTH =50
constant RECS_HEIGHT =50

constant MAX_RECS_X =800/RECS_WIDTH
constant MAX_RECS_Y =450/RECS_HEIGHT

constant PLAY_TIME_IN_FRAMES =240               -- At 60 fps = 4 seconds
enum width=3,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - easings rectangles")
    sequence recX=repeat({0,0,0,0},MAX_RECS_X)
        
    sequence recs=repeat({0,0,0,0},(MAX_RECS_Y+1)*(MAX_RECS_X))

    for  y = 0 to  MAX_RECS_Y
    do
        for  x = 1 to MAX_RECS_X
        do
            recs[y*MAX_RECS_X + x][1] = RECS_WIDTH/2.0 + RECS_WIDTH*(x-1)
            recs[y*MAX_RECS_X + x][2] = RECS_HEIGHT/2.0 + RECS_HEIGHT*(y)
            recs[y*MAX_RECS_X + x][width] = RECS_WIDTH
            recs[y*MAX_RECS_X + x][height] = RECS_HEIGHT
        end for
    end for

    atom rotation = 0.0
    integer framesCounter = 0
    integer state = 0                   -- Rectangles animation state: 0-Playing, 1-Finished

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (state = 0)
        then
            framesCounter+=1

            for  i = 1 to  MAX_RECS_X*MAX_RECS_Y
            do
                recs[i][height] = EaseCircOut(framesCounter, RECS_HEIGHT, -RECS_HEIGHT, PLAY_TIME_IN_FRAMES)
                recs[i][width] = EaseCircOut(framesCounter, RECS_WIDTH, -RECS_WIDTH, PLAY_TIME_IN_FRAMES)

                if (recs[i][height] < 0) then recs[i][height] = 0 end if
                if (recs[i][width] < 0) then recs[i][width] = 0 end if

                if ((recs[i][height] = 0) and (recs[i][width] = 0)) then state = 1 end if   -- Finish playing

                rotation = EaseLinearIn(framesCounter, 0.0, 360.0, PLAY_TIME_IN_FRAMES)
            end for
        elsif ((state = 1) and IsKeyPressed(KEY_SPACE))
        then
            -- When animation has finished, press space to restart
            framesCounter = 0

            for  i = 1 to MAX_RECS_X*MAX_RECS_Y
            do
                recs[i][height] = RECS_HEIGHT
                recs[i][width] = RECS_WIDTH
            end for

            state = 0
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            if (state = 0)
            then
                for  i = 1 to MAX_RECS_X*MAX_RECS_Y
                do
                    DrawRectanglePro(recs[i], { recs[i][width]/2, recs[i][height]/2 }, rotation, RED)
                end for
            elsif (state = 1) 
            then 
                DrawText("PRESS [SPACE] TO PLAY AGAIN!", 240, 200, 20, GRAY)
            end if
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()     -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


