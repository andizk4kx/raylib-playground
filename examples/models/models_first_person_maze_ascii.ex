/*******************************************************************************************
*
*   raylib [models] example - first person maze
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
constant GLSL_VERSION=330  -- for shader
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 1800
    constant screenHeight = 850
    enum _position,_target,up,fovy,projection
    enum width=2,height
    enum x,y,z
    enum _texture=2 -- for shader fun
    
    InitWindow(screenWidth, screenHeight, "raylib [models] example - first person maze") 
----------------------------------------------------------------------------------------
-- Add shader for fun
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
    
    -- RenderTexture to apply the postprocessing later
    sequence target = LoadRenderTexture(screenWidth, screenHeight)
----------------------------------------------------------------------------------------
    -- Define the camera to look into our 3d world
    sequence camera = Tcamera3D
    camera[_position] = { 0.2, 0.4, 0.2 }   -- Camera position
    camera[_target] = { 0.185, 0.4, 0.0 }   -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }          -- Camera up vector (rotation towards target)
    camera[fovy] = 45.0                                 -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE             -- Camera projection type
    sequence fname="resources/cubicmap.png"
    ifdef PHIX then
        fname="resources/cubicmap_phix.png"
    end ifdef
    sequence imMap = LoadImage(fname)       -- Load cubicmap image (RAM)
    sequence cubicmap = LoadTextureFromImage(imMap)         -- Convert image to texture to display (VRAM)
    sequence mesh = GenMeshCubicmap(imMap,{ 1.0, 1.0, 1.0 }) 
    sequence model = LoadModelFromMesh(mesh) 

    -- NOTE: By default each cube is mapped to one part of texture atlas
    sequence texture = LoadTexture("resources/cubicmap_atlas.png")  -- Load map texture
    --model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture   -- Set map diffuse texture
    model[mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture
    
    -- Get map image data to be used for collision detection
    sequence mapPixels = LoadImageColors(imMap) 

    UnloadImage(imMap)              -- Unload image from RAM

    sequence mapPosition = { -16.0, 0.0, -8.0 }     -- Set model position

    DisableCursor()                 -- Limit cursor to relative movement inside the window

    --SetTargetFPS(60)              -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        sequence oldCamPos = camera[_position]  -- Store old camera position

        camera=UpdateCamera(camera, CAMERA_FIRST_PERSON) 

        -- Check player collision (we simplify to 2D collision detection)
        sequence playerPos = { camera[_position][x], camera[_position][z] } 
        atom playerRadius = 0.1     -- Collision radius (player is modelled as a cilinder for collision)

        integer playerCellX = floor((playerPos[x] - mapPosition[x] + 0.5)) 
        integer playerCellY = floor((playerPos[y] - mapPosition[z] + 0.5)) 

        -- Out-of-limits security check
        if (playerCellX < 0) then 
            playerCellX = 0 
        elsif (playerCellX >= cubicmap[width]) then 
            playerCellX = cubicmap[width] - 1 
        end if

        if (playerCellY < 0) then 
            playerCellY = 0 
        elsif (playerCellY >= cubicmap[height]) then
            playerCellY = cubicmap[height] - 1 
        end if
        
        -- Check map collisions using image data and player position against surrounding cells only
        for y1 = playerCellY - 1 to playerCellY + 1 
        do
            -- Avoid map accessing out of bounds
            if ((y1 >= 0) and (y1 < cubicmap[height]))
            then
                for  x1 = playerCellX - 1 to playerCellX + 1 
                do
                    -- NOTE: Collision: Only checking R channel for white mapPixel[1]=r and off
                    
                    if (((x1 >= 0) and (x1 < cubicmap[width])) and (mapPixels[y1*cubicmap[width] + x1+1][1] = 255) and
                        (CheckCollisionCircleRec(playerPos, playerRadius,
                        { mapPosition[x] - 0.5 + x1*1.0, mapPosition[z] - 0.5 + y1*1.0, 1.0, 1.0 })))
                    then
                        -- Collision detected, reset camera position

                        camera[_position] = oldCamPos 
                    end if
                end for
            end if
        end for
        ------------------------------------------------------------------------------------
        -- Set fontsize for the shader
        SetShaderValue(shader, fontSizeLoc, fontSize, SHADER_UNIFORM_FLOAT)
        -- Draw
        ------------------------------------------------------------------------------------
        BeginTextureMode(target)
            ClearBackground(WHITE) 

            BeginMode3D(camera) 
                DrawModel(model, mapPosition, 1.0, WHITE)                   -- Draw maze map
            EndMode3D() 
        EndTextureMode()
        
        BeginDrawing() 
            ClearBackground(RAYWHITE) 

            BeginShaderMode(shader)
                DrawTextureRec(target[_texture],{ 0, 0, target[_texture][width], -target[_texture][height] },{ 0, 0 }, WHITE)           
            EndShaderMode()
            
            DrawTextureEx(cubicmap,{ GetScreenWidth() - cubicmap[width]*4.0 - 20, 20.0 }, 0.0, 4.0, WHITE) 
            DrawRectangleLines(GetScreenWidth() - cubicmap[width]*4 - 20, 20, cubicmap[width]*4, cubicmap[height]*4, GREEN) 

            -- Draw player position radar
            DrawRectangle(GetScreenWidth() - cubicmap[width]*4 - 20 + playerCellX*4, 20 + playerCellY*4, 4, 4, RED) 

            DrawFPS(10, 10) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadImageColors(mapPixels)    -- Unload color array

    UnloadTexture(cubicmap)         -- Unload cubicmap texture
    UnloadTexture(texture)          -- Unload map texture
    UnloadModel(model)              -- Unload map model

    CloseWindow()                   -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


