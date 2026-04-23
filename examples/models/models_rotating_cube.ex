/*******************************************************************************************
*
*   raylib [models] example - rotating cube
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 6.0, last time updated with raylib 6.0
*
*   Example contributed by Jopestpe (@jopestpe)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Jopestpe (@jopestpe)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450
    enum _position,target,up,fovy,projection
    enum width=2,height
        
    InitWindow(screenWidth, screenHeight, "raylib [models] example - rotating cube") 

    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D 
    camera[_position] = { 0.0, 3.0, 3.0 } 
    camera[target] = { 0.0, 0.0, 0.0 } 
    camera[up] = { 0.0, 1.0, 0.0} 
    camera[fovy] = 45.0 
    camera[projection] = CAMERA_PERSPECTIVE 

    -- Load image to create texture for the cube
    sequence model = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0)) 
    sequence img = LoadImage("resources/cubicmap_atlas.png") 
    sequence crop = ImageFromImage(img, {0, img[height]/2.0, img[width]/2.0, img[height]/2.0}) 
    sequence texture = LoadTextureFromImage(crop) 
    UnloadImage(img) 
    UnloadImage(crop) 

    --model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture 
    model[mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture
    atom rotation = 0.0

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        rotation += 1.0
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                -- Draw model defining: position, rotation-axis, rotation (degrees), size, and tint-color
                DrawModelEx(model,{ 0.0, 0.0, 0.0 },{ 0.5, 1.0, 0.0 },rotation,{ 1.5, 1.5, 1.5 }, WHITE) 

                DrawGrid(10, 1.0) 

            EndMode3D() 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texture)  -- Unload texture
    UnloadModel(model)      -- Unload model

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


