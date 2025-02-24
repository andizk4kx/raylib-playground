#=/*******************************************************************************************
*
*   raylib [shapes] example - Draw basic shapes 2d (rectangle, circle, line...)
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/=#
#adapted to julia 2025 Andreas Wagner

include("raylib.jl")

#//------------------------------------------------------------------------------------
#// Program main entry point
#//------------------------------------------------------------------------------------

    #// Initialization
    #//--------------------------------------------------------------------------------------
    screenWidth = 800
    screenHeight = 450

 v1= Vector2( screenWidth/4.0 *3.0, 80.0 )
 v2= Vector2( screenWidth/4.0 *3.0 - 60.0, 150.0 )
 v3= Vector2( screenWidth/4.0 *3.0 + 60.0, 150.0 )

 v4= Vector2( screenWidth/4.0*3.0, 160.0 )
 v5= Vector2( screenWidth/4.0*3.0 - 20.0, 230.0 )
 v6= Vector2( screenWidth/4.0*3.0 + 20.0, 230.0 )

 v7= Vector2( screenWidth/4.0*3, 330 )
 rotation = 0.0
 
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - basic shapes drawing");

    

    SetTargetFPS(60)                #// Set our game to run at 60 frames-per-second
    #//--------------------------------------------------------------------------------------

    #// Main game loop
    while  !WindowShouldClose()    #// Detect window close button or ESC key

        #// Update
        #//----------------------------------------------------------------------------------
        global rotation +=  0.2
        #//----------------------------------------------------------------------------------

        #// Draw
        #//----------------------------------------------------------------------------------
        BeginDrawing()
            #v7=GetMousePosition()
            ClearBackground(RAYWHITE)

            DrawText("some basic shapes available on raylib", 20, 20, 20, DARKGRAY)

            #// Circle shapes and lines
            DrawCircle( Int64(screenWidth/5), 120, 35.0, DARKBLUE)
            DrawCircleGradient(Int64(screenWidth/5), 220, 60.0, GREEN, SKYBLUE)
            DrawCircleLines(Int64(screenWidth/5), 340, 80.0, DARKBLUE)

            #// Rectangle shapes and lines
            DrawRectangle(Int64(screenWidth/4*2) - 60, 100, 120, 60, RED)
            DrawRectangleGradientH(Int64(screenWidth/4*2) - 90, 170, 180, 130, MAROON, GOLD)
            DrawRectangleLines(Int64(screenWidth/4*2) - 40, 320, 80, 60, ORANGE)   #// NOTE: Uses QUADS internally, not lines
    
            #// Triangle shapes and lines
            DrawTriangle(v1,v2,v3, VIOLET);
            DrawTriangleLines(v4,v5,v6, DARKBLUE)

            #// Polygon shapes and lines
            DrawPoly(v7, 6, 80.0, rotation, BROWN)
            DrawPolyLines(v7, 6, 90.0, rotation, BROWN)
            DrawPolyLinesEx(v7, 6 , 85.0, rotation, 6.0, BEIGE)

            #// NOTE: We draw all LINES based shapes together to optimize internal drawing,
            #// this way, all LINES are rendered in a single draw pass
            DrawLine(18, 42, screenWidth - 18, 42, BLACK)
        
        EndDrawing()
        #//----------------------------------------------------------------------------------
    end

    #// De-Initialization
    #//--------------------------------------------------------------------------------------
    CloseWindow()      #// Close window and OpenGL context
    #//--------------------------------------------------------------------------------------

