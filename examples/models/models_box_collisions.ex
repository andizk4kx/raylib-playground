/*******************************************************************************************
*
*   raylib [models] example - box collisions
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix 2025 Andreas Wagner

include "..\\..\\raylib64.e"
--/*
constant true=1
constant false=0
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [models] example - box collisions") 

    -- Define the camera to look into our 3d world
    sequence camera = { { 0.0, 10.0, 10.0 }, { 0.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0 }, 45.0, 0 } 

    sequence playerPosition = { 0.0, 1.0, 2.0 } 
    sequence playerSize = { 1.0, 2.0, 1.0 } 
    sequence playerColor = GREEN 

    sequence enemyBoxPos = { -4.0, 1.0, 0.0 } 
    sequence enemyBoxSize = { 2.0, 2.0, 2.0 } 

    sequence enemySpherePos = { 4.0, 0.0, 0.0 } 
    atom enemySphereSize = 1.5 
    enum x,y,z
    integer collision = false 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------

        -- Move player
        if (IsKeyDown(KEY_RIGHT)) 
        then 
            playerPosition[x] += 0.2
        elsif (IsKeyDown(KEY_LEFT)) 
        then 
            playerPosition[x] -= 0.2 
        elsif (IsKeyDown(KEY_DOWN)) 
        then 
            playerPosition[z] += 0.2 
        elsif (IsKeyDown(KEY_UP)) 
        then 
            playerPosition[z] -= 0.2 
        end if
        
        collision = false 

        -- Check collisions player vs enemy-box
        if (CheckCollisionBoxes({{ playerPosition[x] - playerSize[x]/2,playerPosition[y] - playerSize[y]/2,playerPosition[z] - playerSize[z]/2 },
                                 { playerPosition[x] + playerSize[x]/2,playerPosition[y] + playerSize[y]/2,playerPosition[z] + playerSize[z]/2 }},
                                {{ enemyBoxPos[x] - enemyBoxSize[x]/2,enemyBoxPos[y] - enemyBoxSize[y]/2,enemyBoxPos[z] - enemyBoxSize[z]/2 },
                                 { enemyBoxPos[x] + enemyBoxSize[x]/2,enemyBoxPos[y] + enemyBoxSize[y]/2,enemyBoxPos[z] + enemyBoxSize[z]/2 }})) 
        then 
            collision = true 
        end if
        
        -- Check collisions player vs enemy-sphere
        if (CheckCollisionBoxSphere({{ playerPosition[x] - playerSize[x]/2,playerPosition[y] - playerSize[y]/2,playerPosition[z] - playerSize[z]/2 },
                                     { playerPosition[x] + playerSize[x]/2,playerPosition[y] + playerSize[y]/2,playerPosition[z] + playerSize[z]/2 }},
                                        enemySpherePos, enemySphereSize)) 
        then 
            collision = true 
        end if

        if (collision) 
        then 
            playerColor = RED 
        else 
            playerColor = GREEN
        end if 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                -- Draw enemy-box
                DrawCube(enemyBoxPos, enemyBoxSize[x], enemyBoxSize[y], enemyBoxSize[z], GRAY) 
                DrawCubeWires(enemyBoxPos, enemyBoxSize[x], enemyBoxSize[y], enemyBoxSize[z], DARKGRAY) 

                -- Draw enemy-sphere
                DrawSphere(enemySpherePos, enemySphereSize, GRAY) 
                DrawSphereWires(enemySpherePos, enemySphereSize, 16, 16, DARKGRAY) 

                -- Draw player
                DrawCubeV(playerPosition, playerSize, playerColor) 

                DrawGrid(10, 1.0)      -- Draw a grid

            EndMode3D() 

            DrawText("Move player with arrow keys to collide", 220, 40, 20, GRAY) 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


