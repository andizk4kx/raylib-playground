/*******************************************************************************************
*
*   raylib [textures] example - logo raylib
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix 2025 Andreas Wagner

include "..\\..\\raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 
    enum width=2,height=3
    InitWindow(screenWidth, screenHeight, "raylib [textures] example - logo raylib") 

    -- NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    sequence texture = LoadTexture("resources/raylib_logo.png")          -- Texture loading

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    -----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- TODO: Update your variables here
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawTexture(texture, screenWidth/2 - texture[width]/2, screenHeight/2 - texture[height]/2, WHITE) 

            DrawText("this IS a texture!", 360, 370, 10, GRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texture)        -- Texture unloading

    CloseWindow()                 -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


