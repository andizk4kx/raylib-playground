/*******************************************************************************************
*
*   raylib [models] example - cubicmap rendering
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.8, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
constant true =1
constant false = 0
--*/
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450
    enum _position,target,up,fovy,projection
    enum width=2,height
    InitWindow(screenWidth, screenHeight, "raylib [models] example - cubicmap rendering") 

    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D 
    camera[_position] = { 16.0, 14.0, 16.0 }    -- Camera position
    camera[target] = { 0.0, 0.0, 0.0 }          -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }              -- Camera up vector (rotation towards target)
    camera[fovy] = 45.0                                     -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE                 -- Camera projection type

    sequence image = LoadImage("resources/cubicmap.png")        -- Load cubicmap image (RAM)
    sequence cubicmap = LoadTextureFromImage(image)         -- Convert image to texture to display (VRAM)

    sequence mesh = GenMeshCubicmap(image,{ 1.0, 1.0, 1.0 }) 
    sequence model = LoadModelFromMesh(mesh) 

    -- NOTE: By default each cube is mapped to one part of texture atlas
    sequence texture = LoadTexture("resources/cubicmap_atlas.png")  -- Load map texture
    --model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture   -- Set map diffuse texture
    model[mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture

    sequence mapPosition = { -16.0, 0.0, -8.0 }             -- Set model position

    UnloadImage(image)      -- Unload cubesmap image from RAM, already uploaded to VRAM

    integer pause = false   -- Pause camera orbital rotation (and zoom)

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())      -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_P)) then 
            pause = not(pause)
        end if 

        if not (pause) then 
            camera=UpdateCamera(camera, CAMERA_ORBITAL) 
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                DrawModel(model, mapPosition, 1.0, WHITE) 

            EndMode3D() 

            DrawTextureEx(cubicmap,{ screenWidth - cubicmap[width]*4.0 - 20, 20.0 }, 0.0, 4.0, WHITE) 
            DrawRectangleLines(screenWidth - cubicmap[width]*4 - 20, 20, cubicmap[width]*4, cubicmap[height]*4, GREEN) 

            DrawText("cubicmap image used to", 658, 90, 10, GRAY) 
            DrawText("generate map 3d model", 658, 104, 10, GRAY) 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(cubicmap)     -- Unload cubicmap texture
    UnloadTexture(texture)      -- Unload map texture
    UnloadModel(model)          -- Unload map model

    CloseWindow()               -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


