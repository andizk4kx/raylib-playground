/*******************************************************************************************
*
*   raylib [shaders] example - ascii rendering
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.6
*
*   Example contributed by Maicon Santana (@maiconpintoabreu) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Maicon Santana (@maiconpintoabreu)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--#if defined(PLATFORM_DESKTOP)
--  #define GLSL_VERSION            330
constant GLSL_VERSION=330
--#else // PLATFORM_ANDROID, PLATFORM_WEB
--  #define GLSL_VERSION            100
--#endif
enum x,texture=2,width=2,height=3
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shaders] example - ascii rendering")

    -- Texture to test static drawing
    sequence fudesumi = LoadTexture("resources/fudesumi.png")
    -- Texture to test moving drawing
    sequence raysan = LoadTexture("resources/raysan.png")

    -- Load shader to be used on postprocessing
    sequence shader = LoadShader(0, TextFormat("resources/shaders/glsl%i/ascii.fs", GLSL_VERSION))

    -- These locations are used to send data to the GPU
    integer resolutionLoc = GetShaderLocation(shader, "resolution")
    integer fontSizeLoc = GetShaderLocation(shader, "fontSize")

    -- Set the character size for the ASCII effect
    -- Fontsize should be 9 or more
    atom fontSize = 9.0

    -- Send the updated values to the shader
    sequence resolution = { screenWidth, screenHeight }
    SetShaderValue(shader, resolutionLoc, resolution, SHADER_UNIFORM_VEC2)

    sequence circlePos = {40.0, screenHeight*0.5}
    atom circleSpeed = 1.0

    -- RenderTexture to apply the postprocessing later
    sequence target = LoadRenderTexture(screenWidth, screenHeight)

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        circlePos[x] += circleSpeed
        if ((circlePos[x] > 200.0) or (circlePos[x] < 40.0)) 
        then
            circleSpeed *= -1 -- Revert speed
        end if
        if (IsKeyPressed(KEY_LEFT) and (fontSize > 9.0)) 
        then 
            fontSize -= 1   -- Reduce fontSize
        end if
        
        if (IsKeyPressed(KEY_RIGHT) and (fontSize < 15.0)) 
        then 
            fontSize += 1  -- Increase fontSize
        end if
        -- Set fontsize for the shader
        SetShaderValue(shader, fontSizeLoc, fontSize, SHADER_UNIFORM_FLOAT)

        -- Draw
        ------------------------------------------------------------------------------------
        BeginTextureMode(target)
            ClearBackground(WHITE)

            -- Draw scene in our render texture
            DrawTexture(fudesumi, 500, -30, WHITE)
            DrawTextureV(raysan, circlePos, WHITE)
        EndTextureMode()

        BeginDrawing()
            ClearBackground(RAYWHITE)

            BeginShaderMode(shader)
                -- Draw the scene texture (that we rendered earlier) to the screen
                -- The shader will process every pixel of this texture
                DrawTextureRec(target[texture],{ 0, 0, target[texture][width], -target[texture][height] },{ 0, 0 }, WHITE)
            EndShaderMode()

            DrawRectangle(0, 0, screenWidth, 40, BLACK)
            DrawText(TextFormat("Ascii effect - FontSize:%2.0f - [Left] -1 [Right] +1 ", fontSize), 120, 10, 20, LIGHTGRAY)
            DrawFPS(10, 10)
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadRenderTexture(target) -- Unload render texture

    UnloadShader(shader)            -- Unload shader
    UnloadTexture(fudesumi)     -- Unload texture
    UnloadTexture(raysan)           -- Unload texture

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


