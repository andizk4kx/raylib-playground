/*******************************************************************************************
*
*   raylib [core] example - 2d camera
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
include std/rand.e
include std/math.e
--*/
constant MAX_BUILDINGS =    100

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")

    sequence player = { 400, 280, 40, 40 }
    sequence buildings=repeat({0,0,0,0},MAX_BUILDINGS) 
    sequence buildColors=repeat({0,0,0,0},MAX_BUILDINGS)
    enum x,y,width,height
    enum target,offset,rotation,zoom    
    integer spacing = 0

    for  i = 1 to MAX_BUILDINGS
    do
        
        buildings[i][width] = rand_range(50, 200)
        buildings[i][height] = rand_range(100, 800)
        buildings[i][y] = screenHeight - 130.0 - buildings[i][height]
        buildings[i][x] = -6000.0 + spacing

        spacing += buildings[i][width]+5

        buildColors[i] = {
                rand_range(200, 240),
                rand_range(200, 240),
                rand_range(200, 250),255}
    end for

    sequence camera ={{0,0},{0,0},0,0}
    camera[target] = { player[x] + 20.0, player[y] + 20.0 }
    camera[offset] = { screenWidth/2.0, screenHeight/2.0 }
    camera[rotation] = 0.0
    camera[zoom] = 1.0

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())      -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Player movement
        if (IsKeyDown(KEY_RIGHT)) then 
            player[x] += 2
        elsif (IsKeyDown(KEY_LEFT)) then 
            player[x] -= 2
        end if
        -- Camera target follows player
        camera[target][x] =  player[x] + 20
        camera[target][y] =  player[y] + 20 

        -- Camera rotation controls
        if (IsKeyDown(KEY_A)) then 
            camera[rotation]-=1
        elsif (IsKeyDown(KEY_S)) then 
            camera[rotation]+=1
        end if
        
        -- Limit camera rotation to 80 degrees (-40 to 40)
        if (camera[rotation] > 40) then
             camera[rotation] = 40
        elsif (camera[rotation] < -40) then 
             camera[rotation] = -40
        end if
        
        -- Camera zoom controls
        -- Uses log scaling to provide consistent zoom speed
        camera[zoom] = exp(log(camera[zoom]) + GetMouseWheelMove()*0.1)

        if (camera[zoom] > 3.0) then 
            camera[zoom] = 3.0
        elsif (camera[zoom] < 0.1) then 
            camera[zoom] = 0.1
        end if
        -- Camera reset (zoom and rotation)
        if (IsKeyPressed(KEY_R))
        then
            camera[zoom] = 1.0
            camera[rotation] = 0.0
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            BeginMode2D(camera)

                DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY)

                for i =  1 to MAX_BUILDINGS 
                do 
                    DrawRectangleRec(buildings[i], buildColors[i])
                end for
                DrawRectangleRec(player, RED)

                DrawLine(camera[target][x], -screenHeight*10, camera[target][x], screenHeight*10, GREEN)
                DrawLine(-screenWidth*10, camera[target][y], screenWidth*10, camera[target][y], GREEN)

            EndMode2D()

            DrawText("SCREEN AREA", 640, 10, 20, RED)

            DrawRectangle(0, 0, screenWidth, 5, RED)
            DrawRectangle(0, 5, 5, screenHeight - 10, RED)
            DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED)
            DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED)

            DrawRectangle( 10, 10, 250, 113, Fade(SKYBLUE, 0.5))
            DrawRectangleLines( 10, 10, 250, 113, BLUE)

            DrawText("Free 2D camera controls:", 20, 20, 10, BLACK)
            DrawText("- Right/Left to move player", 40, 40, 10, DARKGRAY)
            DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY)
            DrawText("- A / S to Rotate", 40, 80, 10, DARKGRAY)
            DrawText("- R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()     -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


