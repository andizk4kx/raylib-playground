/*******************************************************************************************
*
*   raylib [core] example - Keyboard input
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

include "raylib.e"

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure main()

    // Initialization
    //--------------------------------------------------------------------------------------
    int screenWidth = 800;
    int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - keyboard input");

    Vector2 ballPosition = new({ screenWidth/2, screenHeight/2 })
    Vector2 ballSpeed = new({ 2.0, 2.0 })
    integer ballRadius = 25
    integer maxspeed =25

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while not WindowShouldClose()   // Detect window close button or ESC key
    do
        // Update
        //----------------------------------------------------------------------------------
        if (IsKeyDown(KEY_RIGHT)) then ballPosition.x += ballSpeed.x end if
        if (IsKeyDown(KEY_LEFT)) then ballPosition.x -= ballSpeed.x end if
        if (IsKeyDown(KEY_UP)) then ballPosition.y -= ballSpeed.y end if
        if (IsKeyDown(KEY_DOWN)) then ballPosition.y += ballSpeed.y end if
        if (IsKeyDown(KEY_KP_SUBTRACT)) then ballSpeed.x -= 1  ballSpeed.y -= 1 end if
        if (IsKeyDown(KEY_KP_ADD)) then ballSpeed.y += 1 ballSpeed.x += 1 end if
        
        if ballSpeed.x>maxspeed then ballSpeed.x=maxspeed end if
        if ballSpeed.y>maxspeed then ballSpeed.y=maxspeed end if
        if ballSpeed.x<0 then ballSpeed.x=1 end if
        if ballSpeed.y<0 then ballSpeed.y=1 end if
        
        //----------------------------------------------------------------------------------
        
        // Check walls collision for bouncing
        if (ballPosition.x >= (GetScreenWidth() - ballRadius))  then  ballPosition.x -= ballRadius/2 end if
        if (ballPosition.y >= (GetScreenHeight() - ballRadius)) then ballPosition.y -= ballRadius/2 end if
        if (ballPosition.x <= ballRadius) then  ballPosition.x += ballRadius/2 end if
        if (ballPosition.y <= ballRadius) then ballPosition.y += ballRadius/2 end if
        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE);

            DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY)
            DrawText("Press Keypad [+/-] to increase/decrease Ballspeed", 10, 30, 20, DARKGRAY);
            DrawText(sprintf("Ballspeed :[%d,%d]",{ballSpeed.x,ballSpeed.y}), 10, 50, 20, DARKGRAY);
            DrawCircleV(ballPosition,ballRadius, MAROON)

        EndDrawing()
        //----------------------------------------------------------------------------------
    end while

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow()         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    
end procedure

main()
