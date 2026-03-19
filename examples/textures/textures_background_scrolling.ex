/*******************************************************************************************
*
*   raylib [textures] example - background scrolling
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 2.0, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant  screenWidth = 800
    constant  screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - background scrolling")

    -- NOTE: Be careful, background width must be equal or bigger than screen width
    -- if not, texture should be draw more than two times for scrolling effect
    sequence background 
    sequence midground 
    sequence foreground
    background = LoadTexture("resources/cyberpunk_street_background.png")
    midground = LoadTexture("resources/cyberpunk_street_midground.png")
    foreground = LoadTexture("resources/cyberpunk_street_foreground.png")
    

    
    atom scrollingBack = 0.0
    atom scrollingMid = 0.0
    atom scrollingFore = 0.0

    SetTargetFPS(120)           -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        scrollingBack -= 0.1
        scrollingMid -= 0.5
        scrollingFore -= 1.0

        -- NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
        if (scrollingBack <= -background[2]*2) then scrollingBack = 0 end if
        if (scrollingMid <= -midground[2]*2) then scrollingMid = 0 end if
        if (scrollingFore <= -foreground[2]*2) then scrollingFore = 0 end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(GetColor(0x052c46ff))
            --ClearBackground({#05,#2c,#46,#ff})
            -- Draw background image twice
            -- NOTE: Texture is scaled twice its size

            DrawTextureEx(background,{ scrollingBack, 20 }, 0.0, 2.0, WHITE)
            DrawTextureEx(background,{ background[2]*2 + scrollingBack, 20 }, 0.0, 2.0, WHITE)

            -- Draw midground image twice
            
            DrawTextureEx(midground,{ scrollingMid, 20 }, 0.0, 2.0, WHITE)
            DrawTextureEx(midground,{ midground[2]*2 + scrollingMid, 20 }, 0.0, 2.0, WHITE)

            -- Draw foreground image twice

            DrawTextureEx(foreground,{ scrollingFore, 70 }, 0.0, 2.0, WHITE)
            DrawTextureEx(foreground,{ foreground[2]*2 + scrollingFore, 70 }, 0.0, 2.0, WHITE)

            DrawText("BACKGROUND SCROLLING & PARALLAX", 10, 10, 20, RED)
            DrawText("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, RAYWHITE)
            DrawFPS(10,40)
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(background)   -- Unload background texture
    UnloadTexture(midground)    -- Unload midground texture
    UnloadTexture(foreground)   -- Unload foreground texture

    CloseWindow()               -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


