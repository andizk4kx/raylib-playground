/*******************************************************************************************
*
*   raylib [textures] example - srcrec dstrec
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 
    enum x,y
    enum width=2,height=3
    InitWindow(screenWidth, screenHeight, "raylib [textures] example - srcrec dstrec") 

    -- NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    sequence scarfy = LoadTexture("resources/scarfy.png")      -- Texture loading

    atom frameWidth = scarfy[width]/6 
    atom frameHeight = scarfy[height] 

    -- Source rectangle (part of the texture to use for drawing)
    sequence sourceRec = { 0.0, 0.0, frameWidth, frameHeight } 

    -- Destination rectangle (screen rectangle where drawing part of texture)
    sequence destRec = { screenWidth/2.0, screenHeight/2.0, frameWidth*2.0, frameHeight*2.0 } 

    -- Origin of the texture (rotation/scale point), it's relative to destination rectangle size
    sequence origin = { frameWidth, frameHeight } 

    integer rotation = 0 

    SetTargetFPS(60) 
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        rotation+=1
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            -- NOTE: Using DrawTexturePro() we can easily rotate and scale the part of the texture we draw
            -- sourceRec defines the part of the texture we use for drawing
            -- destRec defines the rectangle where our texture part will fit (scaling it to fit)
            -- origin defines the point of the texture used as reference for rotation and scaling
            -- rotation defines the texture rotation (using origin as rotation point)
            DrawTexturePro(scarfy, sourceRec, destRec, origin, rotation, WHITE) 

            DrawLine(destRec[x], 0, destRec[x], screenHeight, GRAY) 
            DrawLine(0, destRec[y], screenWidth, destRec[y], GRAY) 

            DrawText("(c) Scarfy sprite by Eiden Marsal", screenWidth - 200, screenHeight - 20, 10, GRAY) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(scarfy)         -- Texture unloading

    CloseWindow()                 -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


