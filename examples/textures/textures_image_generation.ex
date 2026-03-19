/*******************************************************************************************
*
*   raylib [textures] example - image generation
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.8, last time updated with raylib 1.8
*
*   Example contributed by Wilhem Barbier (@nounoursheureux) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2025 Wilhem Barbier (@nounoursheureux) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--/*
include std/math.e
--*/

constant NUM_TEXTURES = 10   -- Currently we have 8 generation algorithms but some have multiple purposes (Linear and Square Gradients)

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - image generation") 

    sequence verticalGradient = GenImageGradientLinear(screenWidth, screenHeight, 0, RED, BLUE) 
    sequence horizontalGradient = GenImageGradientLinear(screenWidth, screenHeight, 90, RED, BLUE) 
    sequence diagonalGradient = GenImageGradientLinear(screenWidth, screenHeight, 45, RED, BLUE) 
    sequence radialGradient = GenImageGradientRadial(screenWidth, screenHeight, 0.0, WHITE, BLACK) 
    sequence squareGradient = GenImageGradientSquare(screenWidth, screenHeight, 0.0, WHITE, BLACK) 
    sequence checked = GenImageChecked(screenWidth, screenHeight, 32, 32, RED, BLUE) 
    sequence whiteNoise = GenImageWhiteNoise(screenWidth, screenHeight, 0.5) 
    sequence perlinNoise = GenImagePerlinNoise(screenWidth, screenHeight, 50, 50, 4.0) 
    sequence cellular = GenImageCellular(screenWidth, screenHeight, 32) 

    sequence textures=repeat(0,NUM_TEXTURES) 

    textures[1] = LoadTextureFromImage(verticalGradient) 
    textures[2] = LoadTextureFromImage(horizontalGradient) 
    textures[3] = LoadTextureFromImage(diagonalGradient) 
    textures[4] = LoadTextureFromImage(radialGradient) 
    textures[5] = LoadTextureFromImage(squareGradient) 
    textures[6] = LoadTextureFromImage(checked) 
    textures[7] = LoadTextureFromImage(whiteNoise) 
    textures[8] = LoadTextureFromImage(perlinNoise) 
    textures[9] = LoadTextureFromImage(cellular) 

    -- Unload image data (CPU RAM)
    UnloadImage(verticalGradient) 
    UnloadImage(horizontalGradient) 
    UnloadImage(diagonalGradient) 
    UnloadImage(radialGradient) 
    UnloadImage(squareGradient) 
    UnloadImage(checked) 
    UnloadImage(whiteNoise) 
    UnloadImage(perlinNoise) 
    UnloadImage(cellular) 

    integer currentTexture = 1 

    SetTargetFPS(60) 
    -----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT) or IsKeyPressed(KEY_RIGHT))
        then
            currentTexture = mod((currentTexture + 1),NUM_TEXTURES)  -- Cycle between the textures
            if currentTexture=0  then
                currentTexture=1
            end if
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawTexture(textures[currentTexture], 0, 0, WHITE) 

            DrawRectangle(30, 400, 325, 30, Fade(SKYBLUE, 0.5)) 
            DrawRectangleLines(30, 400, 325, 30, Fade(WHITE, 0.5)) 
            DrawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, WHITE) 

            switch (currentTexture)
            do
                case 1 then DrawText("VERTICAL GRADIENT", 560, 10, 20, RAYWHITE)  break 
                case 2 then DrawText("HORIZONTAL GRADIENT", 540, 10, 20, RAYWHITE)  break 
                case 3 then DrawText("DIAGONAL GRADIENT", 540, 10, 20, RAYWHITE)  break 
                case 4 then DrawText("RADIAL GRADIENT", 580, 10, 20, LIGHTGRAY)  break 
                case 5 then DrawText("SQUARE GRADIENT", 580, 10, 20, LIGHTGRAY)  break 
                case 6 then DrawText("CHECKED", 680, 10, 20, RAYWHITE)  break 
                case 7 then DrawText("WHITE NOISE", 640, 10, 20, RED)  break 
                case 8 then DrawText("PERLIN NOISE", 640, 10, 20, RED)  break 
                case 9 then DrawText("CELLULAR", 670, 10, 20, RAYWHITE)  break 
                case else break 
            end switch

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------

    -- Unload textures data (GPU VRAM)
    for  i = 1 to  NUM_TEXTURES-1
    do
        UnloadTexture(textures[i]) 
    end for
    CloseWindow()                 -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


