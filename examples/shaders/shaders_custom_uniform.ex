/*******************************************************************************************
*
*   raylib [shaders] example - custom uniform
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--#if defined(PLATFORM_DESKTOP)
constant GLSL_VERSION = 330
--#else // PLATFORM_ANDROID, PLATFORM_WEB
--  #define GLSL_VERSION            100
--#endif
enum rtex_texture=2,tex_width=2,tex_height=3
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 

    SetConfigFlags(FLAG_MSAA_4X_HINT)       -- Enable Multi Sampling Anti Aliasing 4x (if available)

    InitWindow(screenWidth, screenHeight, "raylib [shaders] example - custom uniform") 

    -- Define the camera to look into our 3d world
    sequence camera = {  
                        { 8.0, 8.0, 8.0 },  -- Camera position
                        { 0.0, 1.5, 0.0 },      -- Camera looking at point
                        { 0.0, 1.0, 0.0 },          -- Camera up vector (rotation towards target)
                        45.0,                               -- Camera field-of-view Y
                        CAMERA_PERSPECTIVE }            -- Camera projection type

    sequence model = LoadModel("resources/models/barracks.obj")                     -- Load OBJ model
    sequence texture = LoadTexture("resources/models/barracks_diffuse.png")     -- Load model texture (diffuse map)
    model[mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture                      -- Set model diffuse texture
    sequence position_ = { 0.0, 0.0, 0.0 }                                  -- Set model position

    -- Load postprocessing shader
    -- NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    sequence shader = LoadShader(0, TextFormat("resources/shaders/glsl%i/swirl.fs", GLSL_VERSION)) 

    -- Get variable (uniform) location on the shader to connect with the program
    -- NOTE: If uniform variable could not be found in the shader, function returns -1
    integer swirlCenterLoc = GetShaderLocation(shader, "center") 

    sequence swirlCenter = { screenWidth/2, screenHeight/2 } 

    -- Create a RenderTexture2D to be used for render to texture
    sequence target = LoadRenderTexture(screenWidth, screenHeight) 

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())      -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_ORBITAL) 

        sequence mousePosition = GetMousePosition() 

        swirlCenter[1] = mousePosition[1]
        swirlCenter[2] = screenHeight - mousePosition[2] 

        -- Send new value to the shader to be used on drawing
        SetShaderValue(shader, swirlCenterLoc, swirlCenter, SHADER_UNIFORM_VEC2) 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginTextureMode(target)        -- Enable drawing to texture
            ClearBackground(RAYWHITE)   -- Clear texture background

            BeginMode3D(camera)         -- Begin 3d mode drawing
                DrawModel(model, position_, 0.5, WHITE)    -- Draw 3d model with texture
                DrawGrid(10, 1.0)   -- Draw a grid
            EndMode3D()                 -- End 3d mode drawing, returns to orthographic 2d mode

            DrawText("TEXT DRAWN IN RENDER TEXTURE", 200, 10, 30, RED) 
        EndTextureMode()                -- End drawing to texture (now we have a texture available for next passes)

        BeginDrawing() 
            ClearBackground(RAYWHITE)   -- Clear screen background

            -- Enable shader using the custom uniform
            BeginShaderMode(shader) 
                -- NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
                DrawTextureRec(target[rtex_texture], { 0, 0, target[rtex_texture][tex_width], -target[rtex_texture][tex_height] },{ 0, 0 }, WHITE) 
            EndShaderMode() 

            -- Draw some 2d text over drawn texture
            DrawText("(c) Barracks 3D model by Alberto Cano", screenWidth - 220, screenHeight - 20, 10, GRAY) 
            DrawFPS(10, 10) 
        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadShader(shader)                -- Unload shader
    UnloadTexture(texture)              -- Unload texture
    UnloadModel(model)                  -- Unload model
    UnloadRenderTexture(target)         -- Unload render texture

    CloseWindow()                       -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


