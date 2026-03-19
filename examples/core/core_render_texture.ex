/*******************************************************************************************
*
*   raylib [core] example - render texture
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6-dev
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
enum x,y
enum texture=2
enum width=2,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    -----------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - render texture")

    -- Define a render texture to render
    integer renderTextureWidth = 300
    integer renderTextureHeight = 300
    sequence target = LoadRenderTexture(renderTextureWidth, renderTextureHeight) 

    sequence ballPosition = { renderTextureWidth/2.0, renderTextureHeight/2.0 } 
    sequence ballSpeed = { 5.0, 4.0 } 
    integer ballRadius = 20 

    atom rotation = 0.0 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        -------------------------------------------------------
        -- Ball movement logic
        ballPosition[x] += ballSpeed[x] 
        ballPosition[y] += ballSpeed[y] 

        -- Check walls collision for bouncing
        if ((ballPosition[x] >= (renderTextureWidth - ballRadius)) or (ballPosition[x] <= ballRadius)) then  ballSpeed[x] *= -1.0 end if
        if ((ballPosition[y] >= (renderTextureHeight - ballRadius)) or (ballPosition[y] <= ballRadius)) then ballSpeed[y] *= -1.0 end if

        -- Render texture rotation
        rotation += 0.5
        -------------------------------------------------------

        -- Draw
        -------------------------------------------------------
        -- Draw our scene to the render texture
        BeginTextureMode(target) 

            ClearBackground(SKYBLUE) 

            DrawRectangle(0, 0, 20, 20, RED) 
            DrawCircleV(ballPosition, ballRadius, MAROON) 

        EndTextureMode() 

        -- Draw render texture to main framebuffer
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            -- Draw our render texture with rotation applied
            -- NOTE 1: We set the origin of the texture to the center of the render texture
            -- NOTE 2: We flip vertically the texture setting negative source rectangle height
            DrawTexturePro(target[texture],
                { 0, 0,target[texture][width], -target[texture][height] },
                { screenWidth/2.0, screenHeight/2.0, target[texture][width], target[texture][height] },
                { target[texture][width]/2.0, target[texture][height]/2.0 }, rotation, WHITE) 

            DrawText("DRAWING BOUNCING BALL INSIDE RENDER TEXTURE!", 10, screenHeight - 40, 20, BLACK) 


            DrawFPS(10, 10) 

        EndDrawing() 
        -------------------------------------------------------
    end while

    -- De-Initialization
    -----------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ------------------------------------------------------------


