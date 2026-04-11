/*******************************************************************************************
*
*   raylib [core] example - scissor test
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*
*   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2025 Chris Dill (@MysteriousSpace)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
constant true=1
constant false=0
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------
    enum x,y,width,height
    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [core] example - scissor test") 

    sequence scissorArea = { 0, 0, 300, 300 } 
    integer scissorMode = true 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_S)) then scissorMode = not(scissorMode)    end if 

        -- Centre the scissor area around the mouse position
        scissorArea[x] = GetMouseX() - scissorArea[width]/2 
        scissorArea[y] = GetMouseY() - scissorArea[height]/2 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            if (scissorMode) then BeginScissorMode(scissorArea[x], scissorArea[y], scissorArea[width], scissorArea[height]) end if 

            -- Draw full screen rectangle and some text
            -- NOTE: Only part defined by scissor area will be rendered
            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), RED) 
            DrawText("Move the mouse around to reveal this text!", 190, 200, 20, LIGHTGRAY) 

            if (scissorMode) then EndScissorMode() end if 

            DrawRectangleLinesEx(scissorArea, 1, BLACK) 
            DrawText("Press S to toggle scissor test", 10, 10, 20, BLACK) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


