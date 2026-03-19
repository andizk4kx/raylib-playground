/*******************************************************************************************
*
*   raylib [shapes] example - starfield effect
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.6-dev
*
*   Example contributed by JP Mortiboys (@themushroompirates) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 JP Mortiboys (@themushroompirates)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--include raylib.e
--include raymath.e
--include "raymath.h"   -- Required for: Lerp()

constant STAR_COUNT=420
--/*
constant false =0
constant true=1
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 *1.5
    constant screenHeight = 450 *1.5
    enum x,y,z
    
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - starfield effect") 

    sequence bgColor = ColorLerp(DARKBLUE, BLACK, 0.69) 

    -- Speed at which we fly forward
    atom speed = 10.0/9.0
    atom dt = 0
    atom t = 0
    atom radius = 0
    -- We're either drawing lines or circles
    integer drawLines_ = true 
    atom mouseMove=0
    sequence stars = repeat({0,0,0},STAR_COUNT)  -- array of Vector3
    sequence starsScreenPos = repeat({0,0},STAR_COUNT)  -- array of Vector2
    sequence startPos = {0,0}
    sequence outtext ="outtext"
    -- Setup the stars with a random position
    for i = 1 to STAR_COUNT
    do
        stars[i][x] = GetRandomValue(-screenWidth / 2, screenWidth / 2) 
        stars[i][y] = GetRandomValue(-screenHeight / 2, screenHeight / 2) 
        stars[i][z] = 1.0 
    end for

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Change speed based on mouse
        mouseMove = GetMouseWheelMove() 
        if not equal(mouseMove,0) then speed += 2.0*mouseMove/9.0 end if
        if (speed < 0.0) then 
            speed = 0.1 
        elsif (speed > 2.0) then 
            speed = 2.0 
        end if
        
        -- Toggle lines / points with space bar
        if (IsKeyPressed(KEY_SPACE)) then 
            drawLines_ =  not drawLines_
        end if
        
        dt = GetFrameTime() 
        for  i = 1 to  STAR_COUNT
        do
            -- Update star's timer
            stars[i][z] -= dt*speed 

            -- Calculate the screen position
            starsScreenPos[i] = {screenWidth*0.5 + stars[i][x]/stars[i][z],screenHeight*0.5 + stars[i][y]/stars[i][z]} 

            -- If the star is too old, or offscreen, it dies and we make a new random one
            if ((stars[i][z] < 0.0) or (starsScreenPos[i][x] < 0) or (starsScreenPos[i][y] < 0.0) or
                (starsScreenPos[i][x] > screenWidth) or (starsScreenPos[i][y] > screenHeight))
            then
                stars[i][x] = GetRandomValue(-screenWidth / 2, screenWidth / 2) 
                stars[i][y] = GetRandomValue(-screenHeight / 2, screenHeight / 2) 
                stars[i][z] = 1.0
            end if
        end for
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(bgColor) 

            for i = 1 to STAR_COUNT
            do
                if (drawLines_)
                then
                    -- Get the time a little while ago for this star, but clamp it
                     t = Clamp(stars[i][z] + 1.0/32.0, 0.0, 1.0) 
                    -- If it's different enough from the current time, we proceed
                    if ((t - stars[i][z]) > 1e-3)
                    then
                        -- Calculate the screen position of the old point
                        startPos = {screenWidth*0.5 + stars[i][x]/t,screenHeight*0.5 + stars[i][y]/t} 

                        -- Draw a line connecting the old point to the current point
                        DrawLineV(startPos, starsScreenPos[i], RAYWHITE) 
                    end if
                
                else
                    -- Make the radius grow as the star ages
                     radius = Lerp(stars[i][z], 1.0, 5.0) 

                    -- Draw the circle
                --  DrawCircleV(starsScreenPos[i], radius, RAYWHITE)
                    DrawCircle(starsScreenPos[i][x],starsScreenPos[i][y], radius, RAYWHITE)  
                end if
            end for

            if drawLines_ then
                outtext="Lines"
            else
                outtext="Circles"
            end if

            DrawText(sprintf("[MOUSE WHEEL] Current Speed: %.0f", 9.0*speed/2.0), 10, 40, 20, RAYWHITE) 
            DrawText(sprintf("[SPACE] Current draw mode: %s",{outtext}), 10, 70, 20, RAYWHITE) 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


