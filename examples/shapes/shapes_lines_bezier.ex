/*******************************************************************************************
*
*   raylib [shapes] example - lines bezier
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.7, last time updated with raylib 1.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/

include "../../raylib64.e"
--include raylib.e
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    SetConfigFlags(FLAG_MSAA_4X_HINT)
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - lines bezier") 
--/*    
    integer false=0
    integer true=1
--*/    
    sequence startPoint = { 30, 30 } 
    sequence endPoint = { screenWidth - 30, screenHeight - 30 }
    sequence mouse={0,0} 
    sequence endcol,startcol
    integer moveStartPoint = false 
    integer moveEndPoint = false 
    atom startradius,endradius

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        mouse = GetMousePosition() 

        if (CheckCollisionPointCircle(mouse, startPoint, 10.0) and IsMouseButtonDown(MOUSE_BUTTON_LEFT)) 
        then
            moveStartPoint = true 
        else 
        if (CheckCollisionPointCircle(mouse, endPoint, 10.0) and IsMouseButtonDown(MOUSE_BUTTON_LEFT))
        then 
            moveEndPoint = true 
        end if
        end if      
        if (moveStartPoint)
        then
            startPoint = mouse 
            if (IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) 
            then
                moveStartPoint = false
            end if 
        end if

        if (moveEndPoint)
        then
            endPoint = mouse 
            if (IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) 
            then
                moveEndPoint = false
            end if 
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText("MOVE START-END POINTS WITH MOUSE", 15, 20, 20, GRAY) 

            -- Draw line Cubic Bezier, in-out interpolation (easing), no control points
            DrawLineBezier(startPoint, endPoint, 4.0, BLUE) 

            -- Draw start-end spline circles with some details
            if moveStartPoint then
                startcol=RED
            else
                startcol=BLUE
            end if

            if moveEndPoint then
                endcol=RED
            else
                endcol=BLUE
            end if

            if CheckCollisionPointCircle(mouse, startPoint, 10.0) then
                startradius=14
            else 
                startradius=8
            end if

            if CheckCollisionPointCircle(mouse, endPoint, 10.0) then
                endradius=14
            else
                endradius=8
            end if
            DrawCircleV(startPoint, startradius, startcol) 
            DrawCircleV(endPoint, endradius,endcol) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


