/*******************************************************************************************
*
*   raylib [shapes] example - easings box
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--include raylib.e
include "reasings.e"          -- Required for easing functions

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450
    enum y=2,width,height
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - easings box")

    -- Box variables to be animated with easings
    sequence rec = { GetScreenWidth()/2.0, -100, 100, 100 }
    atom rotation = 0.0
    atom alpha = 1.0

    integer state = 0
    integer framesCounter = 0

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------

            if state = 0    -- Move box down to center of screen
            then
                framesCounter+=1

                -- NOTE: Remember that 3rd parameter of easing function refers to
                -- desired value variation, do not confuse it with expected final value!
                rec[y] = EaseElasticOut(framesCounter, -100, GetScreenHeight()/2.0 + 100, 120)

                if (framesCounter >= 120)
                then
                    framesCounter = 0
                    state = 1
                end if          
            elsif state = 1     -- Scale box to an horizontal bar
            then
                framesCounter+=1
                rec[height] = EaseBounceOut(framesCounter, 100, -90, 120)
                rec[width] = EaseBounceOut(framesCounter, 100, GetScreenWidth(), 120)

                if (framesCounter >= 120)
                then
                    framesCounter = 0
                    state = 2
                end if          
            elsif state = 2     -- Rotate horizontal bar rectangle
            then
                framesCounter+=1
                rotation = EaseQuadOut(framesCounter, 0.0, 270.0, 240)

                if (framesCounter >= 240)
                then
                    framesCounter = 0
                    state = 3
                end if
            elsif state = 3     -- Increase bar size to fill all screen
            then
                framesCounter+=1
                rec[height] = EaseCircOut(framesCounter, 10, GetScreenWidth(), 120)

                if (framesCounter >= 120) 
                then
                    framesCounter = 0
                    state = 4
                end if
            elsif state = 4     -- Fade out animation
            then
                framesCounter+=1
                alpha = EaseSineOut(framesCounter, 1.0, -1.0, 160)

                if (framesCounter >= 160)
                then
                    framesCounter = 0
                    state = 5
                end if
            else
            --default: break;
            end if

        -- Reset animation at any moment
        if (IsKeyPressed(KEY_SPACE))
        then
            rec = { GetScreenWidth()/2.0, -100, 100, 100 }
            rotation = 0.0
            alpha = 1.0
            state = 0
            framesCounter = 0
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawRectanglePro(rec, { rec[width]/2, rec[height]/2 }, rotation, Fade(BLACK, alpha))

            DrawText("PRESS [SPACE] TO RESET BOX ANIMATION!", 10, GetScreenHeight() - 25, 20, LIGHTGRAY)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()  -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


