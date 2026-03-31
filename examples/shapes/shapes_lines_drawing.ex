/*******************************************************************************************
*
*   raylib [shapes] example - lines drawing
*
*   Example complexity rating: [????] 1/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6
*
*   Example contributed by Robin (@RobinsAviary) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Robin (@RobinsAviary)
*
********************************************************************************************/
--adapted to Phix 2025 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
constant true=1
constant false=0
--*/

--#include "raymath.h"
enum texture=2,width=2,height=3
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - lines drawing") 

    -- Hint text that shows before you click the screen
    integer startText = true 

    -- The mouse's position on the previous frame
    sequence mousePositionPrevious = GetMousePosition() 

    -- The canvas to draw lines on
    sequence canvas = LoadRenderTexture(screenWidth, screenHeight) 

    -- The line's thickness
    atom lineThickness = 8.0
    -- The lines hue (in HSV, from 0-360)
    atom lineHue = 0.0

    -- Clear the canvas to the background color
    BeginTextureMode(canvas) 
        ClearBackground(RAYWHITE) 
    EndTextureMode() 

    SetTargetFPS(60) 
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose())    -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Disable the hint text once the user clicks
        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT) and startText) 
        then 
            startText = false 
        end if
        
        -- Clear the canvas when the user middle-clicks
        if (IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE))
        then
            BeginTextureMode(canvas) 
                ClearBackground(RAYWHITE) 
            EndTextureMode() 
        end if

        -- Store whether the left and right buttons are down
        integer leftButtonDown = IsMouseButtonDown(MOUSE_BUTTON_LEFT) 
        integer rightButtonDown = IsMouseButtonDown(MOUSE_BUTTON_RIGHT) 

        if (leftButtonDown or rightButtonDown)
        then
            -- The color for the line
            sequence drawColor = WHITE 

            if (leftButtonDown)
            then
                -- Increase the hue value by the distance our cursor has moved since the last frame (divided by 3)
                lineHue += Vector2Distance(mousePositionPrevious, GetMousePosition())/3.0

                -- While the hue is >=360, subtract it to bring it down into the range 0-360
                -- This is more visually accurate than resetting to zero
                while (lineHue >= 360.0) do lineHue -= 360.0 end while 

                -- Create the final color
                drawColor = ColorFromHSV(lineHue, 1.0, 1.0) 
            elsif (rightButtonDown) 
            then 
                drawColor = RAYWHITE  -- Use the background color as an "eraser"
            end if
            -- Draw the line onto the canvas
            BeginTextureMode(canvas) 
                -- Circles act as "caps", smoothing corners
                DrawCircleV(mousePositionPrevious, lineThickness/2.0, drawColor) 
                DrawCircleV(GetMousePosition(), lineThickness/2.0, drawColor) 
                DrawLineEx(mousePositionPrevious, GetMousePosition(), lineThickness, drawColor) 
            EndTextureMode() 
        end if

        -- Update line thickness based on mousewheel
        lineThickness += GetMouseWheelMove() 
        lineThickness = Clamp(lineThickness, 1.0, 500.0) 

        -- Update mouse's previous position
        mousePositionPrevious = GetMousePosition() 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            -- Draw the render texture to the screen, flipped vertically to make it appear top-side up
            DrawTextureRec(canvas[texture], { 0.0, 0.0, canvas[texture][width],-canvas[texture][height] }, Vector2Zero(), WHITE) 

            -- Draw the preview circle
            if not (leftButtonDown)  then DrawCircleLinesV(GetMousePosition(), lineThickness/2.0, { 127, 127, 127, 127 }) end if

            -- Draw the hint text
            if (startText) then DrawText("try clicking and dragging!", 275, 215, 20, LIGHTGRAY) end if 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadRenderTexture(canvas)  -- Unload the canvas render texture

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------

 
