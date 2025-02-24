#=*******************************************************************************************
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
********************************************************************************************/=#
#adapted to julia 2025 Andreas Wagner

using Printf
include("raylib.jl")

#//------------------------------------------------------------------------------------
#// Program main entry point
#//------------------------------------------------------------------------------------
function main()

    #// Initialization
    #//--------------------------------------------------------------------------------------
    screenWidth = 800;
    screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - keyboard input");

    ballPosition = Vector2( screenWidth/2, screenHeight/2 )
    ballSpeed = Vector2( 2.0, 2.0 )
    ballRadius = 25.0
    maxspeed =25

    SetTargetFPS(60);               #// Set our game to run at 60 frames-per-second
    #//--------------------------------------------------------------------------------------

    #// Main game loop
    while  !WindowShouldClose()   #// Detect window close button or ESC key
    
        #// Update
        #//----------------------------------------------------------------------------------
        if (IsKeyDown(key_right))  ballPosition.x += ballSpeed.x end 
        if (IsKeyDown(key_left))  ballPosition.x -= ballSpeed.x end 
        if (IsKeyDown(key_up))  ballPosition.y -= ballSpeed.y end 
        if (IsKeyDown(key_down))  ballPosition.y += ballSpeed.y end 
        if (IsKeyDown(key_kp_subtract))  
            ballSpeed.x -= 1  
            ballSpeed.y -= 1 
        end 
        if (IsKeyDown(key_kp_add))  
            ballSpeed.y += 1 
            ballSpeed.x += 1 
        end 
        
        if ballSpeed.x>maxspeed  ballSpeed.x=maxspeed end 
        if ballSpeed.y>maxspeed  ballSpeed.y=maxspeed end 
        if ballSpeed.x<0  ballSpeed.x=1 end 
        if ballSpeed.y<0  ballSpeed.y=1 end 
        
        #//----------------------------------------------------------------------------------
        
        #// Check walls collision for bouncing
        if (ballPosition.x >= (GetScreenWidth() - ballRadius))    ballPosition.x -= ballRadius/2 end 
        if (ballPosition.y >= (GetScreenHeight() - ballRadius))   ballPosition.y -= ballRadius/2 end 
        if (ballPosition.x <= ballRadius)   ballPosition.x += ballRadius/2 end 
        if (ballPosition.y <= ballRadius)   ballPosition.y += ballRadius/2 end 
        #// Draw
        #//----------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)
            DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY)
            DrawText("Press Keypad [+/-] to increase/decrease Ballspeed", 10, 30, 20, DARKGRAY)
            DrawText(@sprintf("Ballspeed: [%d,%d]", ballSpeed.x,ballSpeed.y), 10, 50, 20, DARKGRAY)
            DrawCircleV(ballPosition,ballRadius, MAROON)

        EndDrawing()
        #//----------------------------------------------------------------------------------
    end 

    #// De-Initialization
    #//--------------------------------------------------------------------------------------
    CloseWindow()         #// Close window and OpenGL context
    #//--------------------------------------------------------------------------------------

    
end 

main()
