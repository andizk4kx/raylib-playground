/*******************************************************************************************
*
*   raylib [shapes] example - Draw raylib logo using basic shapes
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

include "raylib.e"

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------

    // Initialization
    //--------------------------------------------------------------------------------------
    constant int screenWidth = 800
    constant int screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - raylib logo using shapes")

    SetTargetFPS(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while not WindowShouldClose()   // Detect window close button or ESC key
    do
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawRectangle(screenWidth/2 - 128, screenHeight/2 - 128, 256, 256, BLACK)
            DrawRectangle(screenWidth/2 - 112, screenHeight/2 - 112, 224, 224, RAYWHITE)
            DrawText("raylib", screenWidth/2 - 44, screenHeight/2 + 48, 50, BLACK)

            DrawText("this is NOT a texture!", 350, 370, 10, GRAY)

        EndDrawing()
        //----------------------------------------------------------------------------------
    end while

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow()         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------


