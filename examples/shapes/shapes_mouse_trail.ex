/*******************************************************************************************
*
* raylib [shapes] example - Draw a mouse trail (position history)
*
* Example complexity rating: [★☆☆☆] 1/4
*
* Example originally created with raylib 5.6
*
* Example contributed by Balamurugan R (@Bala050814]) and reviewed by Ramon Santamaria (@raysan5)
*
* Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
* BSD-like license that allows static linking with closed source software
*
* Copyright (c) 2025 Balamurugan R (@Bala050814)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--#include "raymath.h"

-- Define the maximum number of positions to store in the trail
constant MAX_TRAIL_LENGTH=100
enum x,y
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - mouse trail")

    -- Array to store the history of mouse positions (our fixed-size queue)
    sequence trailPositions=repeat({0,0},MAX_TRAIL_LENGTH)

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        sequence mousePosition = GetMousePosition()

        -- Shift all existing positions backward by one slot in the array
        -- The last element (the oldest position) is dropped
        for i = MAX_TRAIL_LENGTH - 1 to 2 by -1
        do
            trailPositions[i] = trailPositions[i - 1]
        end for

        -- Store the new, current mouse position at the start of the array (Index 0)
        trailPositions[1] = mousePosition
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(BLACK)

            -- Draw the trail by looping through the history array
            for i = 1 to MAX_TRAIL_LENGTH
            do
                -- Ensure we skip drawing if the array hasn't been fully filled on startup
                if ((trailPositions[i][x] > 0.0) or (trailPositions[i][y] > 0.0))
                then
                    -- Calculate relative trail strength (ratio is near 1.0 for new, near 0.0 for old)
                    atom ratio = (MAX_TRAIL_LENGTH - i)/MAX_TRAIL_LENGTH

                    -- Fade effect: oldest positions are more transparent
                    -- Fade (color, alpha) - alpha is 0.5 to 1.0 based on ratio
                    sequence trailColor = Fade(SKYBLUE, ratio*0.5 + 0.5)

                    -- Size effect: oldest positions are smaller
                    atom trailRadius = 15.0*ratio

                    DrawCircleV(trailPositions[i], trailRadius, trailColor)
                end if
            end for

            -- Draw a distinct white circle for the current mouse position (Index 0)
            DrawCircleV(mousePosition, 15.0, BLUE)
            --DrawFPS(10,10)
            DrawText("Move the mouse to see the trail effect!", 10, screenHeight - 30, 20, LIGHTGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()          -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


