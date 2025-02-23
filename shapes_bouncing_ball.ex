/*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/

include raylib.e

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------

    // Initialization
    //---------------------------------------------------------
    atom screenWidth = 800;
    atom screenHeight = 450;

    SetConfigFlags(FLAG_MSAA_4X_HINT)
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bouncing ball")

    Vector2 ballPosition = new({ GetScreenWidth()/2.0, GetScreenHeight()/2.0 })
    Vector2 ballSpeed = new({ 5.0, 4.0 })
    integer ballRadius = 20

    bool pause = 0
    integer framesCounter = 0

    SetTargetFPS(60)                // Set our game to run at 60 frames-per-second
    //----------------------------------------------------------

    // Main game loop
    while not WindowShouldClose() do    // Detect window close button or ESC key
    
        // Update
        //-----------------------------------------------------
        if (IsKeyPressed(KEY_SPACE)) then pause = not pause end if

        if not pause then
        
            ballPosition.x += ballSpeed.x;
            ballPosition.y += ballSpeed.y;

            // Check walls collision for bouncing
            if ((ballPosition.x >= (GetScreenWidth() - ballRadius)) || (ballPosition.x <= ballRadius)) then  ballSpeed.x *= -1.0 end if
            if ((ballPosition.y >= (GetScreenHeight() - ballRadius)) || (ballPosition.y <= ballRadius)) then ballSpeed.y *= -1.0 end if
        
        else framesCounter +=1
        end if
        //-----------------------------------------------------

        // Draw
        //-----------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawCircleV(ballPosition, ballRadius, MAROON)
            DrawText("PRESS SPACE to PAUSE BALL MOVEMENT", 10, GetScreenHeight() - 25, 20, LIGHTGRAY)
            DrawCircleV(GetMousePosition(), 10, DARKBLUE);
            // On pause, we draw a blinking message
--          if (pause && ((framesCounter/30)%2)) DrawText("PAUSED", 350, 200, 30, GRAY)
            if pause and mod((framesCounter/30),2) then DrawText("PAUSED", 350, 200, 30, GRAY) end if
            DrawFPS(10, 10)

        EndDrawing()
        //-----------------------------------------------------
    end while

    // De-Initialization
    //---------------------------------------------------------
    CloseWindow()         // Close window and OpenGL context
    //----------------------------------------------------------

--  return 0;

