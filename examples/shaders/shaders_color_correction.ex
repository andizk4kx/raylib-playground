/*******************************************************************************************
*
*   raylib [shaders] example - color correction
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version
*
*   Example originally created with raylib 5.6, last time updated with raylib 5.6
*
*   Example contributed by Jordi Santonja (@JordSant) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Jordi Santonja (@JordSant)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
constant GLSL_VERSION=330

--#define RAYGUI_IMPLEMENTATION
--#include "raygui.h"               -- Required for GUI controls
--
--#if defined(PLATFORM_DESKTOP)
--  #define GLSL_VERSION            330
--#else -- PLATFORM_ANDROID, PLATFORM_WEB
--  #define GLSL_VERSION            100
--#endif

constant MAX_TEXTURES = 4
enum width=2,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shaders] example - color correction")

    sequence texture = {LoadTexture("resources/parrots.png"),LoadTexture("resources/cat.png"),LoadTexture("resources/mandrill.png"),LoadTexture("resources/fudesumi.png")}

    sequence shdrColorCorrection = LoadShader(0, TextFormat("resources/shaders/glsl%i/color_correction.fs", GLSL_VERSION))

    integer imageIndex = 0
    integer picIndex =1 -- sequences are 1 indexed sometimes a pita
    integer resetButtonClicked = 0

    atom contrast = 0.0
    atom saturation = 0.0
    atom brightness = 0.0

    -- Get shader locations
    integer contrastLoc = GetShaderLocation(shdrColorCorrection, "contrast")
    integer saturationLoc = GetShaderLocation(shdrColorCorrection, "saturation")
    integer brightnessLoc = GetShaderLocation(shdrColorCorrection, "brightness")
    -- Set shader values (they can be changed later)
    SetShaderValue(shdrColorCorrection, contrastLoc, contrast, SHADER_UNIFORM_FLOAT)
    SetShaderValue(shdrColorCorrection, saturationLoc, saturation, SHADER_UNIFORM_FLOAT)
    SetShaderValue(shdrColorCorrection, brightnessLoc, brightness, SHADER_UNIFORM_FLOAT)

    SetTargetFPS(60)            -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Select texture to draw
        if (IsKeyPressed(KEY_ONE)) then imageIndex = 0 
        elsif (IsKeyPressed(KEY_TWO))then imageIndex = 1 
        elsif (IsKeyPressed(KEY_THREE))then  imageIndex = 2 
        elsif (IsKeyPressed(KEY_FOUR))then imageIndex = 3 end if

        -- Reset values to 0
        if (IsKeyPressed(KEY_R) or resetButtonClicked)
        then
            contrast = 0.0
            saturation = 0.0
            brightness = 0.0
        end if

        -- Send the values to the shader
        SetShaderValue(shdrColorCorrection, contrastLoc, contrast, SHADER_UNIFORM_FLOAT)
        SetShaderValue(shdrColorCorrection, saturationLoc,saturation, SHADER_UNIFORM_FLOAT)
        SetShaderValue(shdrColorCorrection, brightnessLoc,brightness, SHADER_UNIFORM_FLOAT)
        
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            BeginShaderMode(shdrColorCorrection)

                DrawTexture(texture[picIndex], 580/2 - texture[picIndex][width]/2, GetScreenHeight()/2 - texture[picIndex][height]/2, WHITE)

            EndShaderMode()

            DrawLine(580, 0, 580, GetScreenHeight(), { 218, 218, 218, 255 })
            DrawRectangle(580, 0, GetScreenWidth(), GetScreenHeight(), { 232, 232, 232, 255 })

            -- Draw UI info text
            DrawText("Color Correction", 585, 40, 20, GRAY)

            DrawText("Picture", 602, 75, 10, GRAY)
            DrawText("Press [1] - [4] to Change Picture", 600, 230, 8, GRAY)
            DrawText("Press [R] to Reset Values", 600, 250, 8, GRAY)

            -- Draw GUI controls
            --------------------------------------------------------------------------------
            imageIndex=GuiToggleGroup({ 645, 70, 20, 20 }, "1;2;3;4", {4,imageIndex})
            contrast=GuiSliderBar({ 645, 100, 120, 20 }, "Contrast", TextFormat("%.0f", contrast), {1,contrast}, -100.0, 100.0)
            saturation=GuiSliderBar({ 645, 130, 120, 20 }, "Saturation", TextFormat("%.0f", saturation), {2,saturation}, -100.0, 100.0)
            brightness=GuiSliderBar({ 645, 160, 120, 20 }, "Brightness", TextFormat("%.0f", brightness), {3,brightness}, -100.0, 100.0)
            --?contrast
            resetButtonClicked = GuiButton({ 645, 190, 40, 20 }, "Reset")
            --------------------------------------------------------------------------------
            picIndex=imageIndex+1 -- sequences
            DrawFPS(710, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    for  i = 1 to MAX_TEXTURES
    do
        UnloadTexture(texture[i])
    end for
    UnloadShader(shdrColorCorrection)

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


