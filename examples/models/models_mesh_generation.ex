/*******************************************************************************************
*
*   raylib [models] example - mesh generation
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

constant NUM_MODELS=9               -- Parametric 3d shapes to generate

--------------------------------------------------------------------------------------
-- Module Functions Declaration
--------------------------------------------------------------------------------------
--static Mesh GenMeshCustom(void)   -- Generate a simple triangle mesh from code

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [models] example - mesh generation") 

    -- We generate a checked image for texturing
    sequence checked = GenImageChecked(2, 2, 1, 1, RED, GREEN) 
    sequence texture = LoadTextureFromImage(checked) 
    UnloadImage(checked) 

    sequence models = repeat(0,NUM_MODELS) 

    models[1] = LoadModelFromMesh(GenMeshPlane(2, 2, 4, 3)) 
    models[2] = LoadModelFromMesh(GenMeshCube(2.0, 1.0, 2.0)) 
    models[3] = LoadModelFromMesh(GenMeshSphere(2, 32, 32)) 
    models[4] = LoadModelFromMesh(GenMeshHemiSphere(2, 16, 16)) 
    models[5] = LoadModelFromMesh(GenMeshCylinder(1, 2, 16)) 
    models[6] = LoadModelFromMesh(GenMeshTorus(0.25, 4.0, 16, 32)) 
    models[7] = LoadModelFromMesh(GenMeshKnot(1.0, 2.0, 16, 128)) 
    models[8] = LoadModelFromMesh(GenMeshPoly(5, 2.0)) 
    models[9] = LoadModelFromMesh(GenMeshCone(2.0,3.0,8)) 

    -- NOTE: Generated meshes could be exported using ExportMesh()

    -- Set checked texture as default diffuse component for all models material
    for  i = 1 to NUM_MODELS 
    do
        models[i][mod_materials][1][mod_materialmaps][MATERIAL_MAP_DIFFUSE+1][matmap_texture] = texture
    end for
    -- Define the camera to look into our 3d world
    sequence camera = { { 5.0, 5.0, 5.0 }, { 0.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0 }, 45.0, 0 } 

    -- Model drawing position
    sequence _position = { 0.0, 0.0, 0.0 } 

    integer currentModel = 1 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_ORBITAL) 

        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT))
        then
            currentModel = remainder((currentModel + 1),NUM_MODELS)  -- Cycle between the textures
            if currentModel>NUM_MODELS 
            then 
                currentModel=1
            end if
            if currentModel<1 
            then 
                currentModel=NUM_MODELS
            end if
        end if

        if (IsKeyPressed(KEY_RIGHT))
        then
            currentModel += 1 
            if (currentModel > NUM_MODELS) then currentModel = 1 end if 
        
        elsif (IsKeyPressed(KEY_LEFT))
        then
            currentModel -= 1
            if (currentModel < 1) then currentModel = NUM_MODELS+1  end if
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

               DrawModel(models[currentModel], _position, 1.0, WHITE) 
               DrawGrid(10, 1.0) 

            EndMode3D() 

            DrawRectangle(30, 400, 310, 30, Fade(SKYBLUE, 0.5)) 
            DrawRectangleLines(30, 400, 310, 30, Fade(DARKBLUE, 0.5)) 
            DrawText("MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS", 40, 410, 10, BLUE) 

            switch (currentModel)
            do
                case 1 then DrawText("PLANE", 680, 10, 20, DARKBLUE)  break 
                case 2 then DrawText("CUBE", 680, 10, 20, DARKBLUE)  break 
                case 3 then DrawText("SPHERE", 680, 10, 20, DARKBLUE)  break 
                case 4 then DrawText("HEMISPHERE", 640, 10, 20, DARKBLUE)  break 
                case 5 then DrawText("CYLINDER", 680, 10, 20, DARKBLUE)  break 
                case 6 then DrawText("TORUS", 680, 10, 20, DARKBLUE)  break 
                case 7 then DrawText("KNOT", 680, 10, 20, DARKBLUE)  break 
                case 8 then DrawText("POLY", 680, 10, 20, DARKBLUE)  break 
                case 9 then DrawText("CONE", 580, 10, 20, DARKBLUE)  break 
                case else  break 
            end switch

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texture)  -- Unload texture

    -- Unload models data (GPU VRAM)
    for i = 1 to NUM_MODELS-1 do UnloadModel(models[i]) end for

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


--I still have no idea how I can implement that with Phix/Euphoria
--------------------------------------------------------------------------------------
--// Module Functions Definition
--//------------------------------------------------------------------------------------
--// Generate a simple triangle mesh from code
--static Mesh GenMeshCustom(void)
--{
--  Mesh mesh = { 0 };
--  mesh.triangleCount = 1;
--  mesh.vertexCount = mesh.triangleCount*3;
--  mesh.vertices = (float *)MemAlloc(mesh.vertexCount*3*sizeof(float));    // 3 vertices, 3 coordinates each (x, y, z)
--  mesh.texcoords = (float *)MemAlloc(mesh.vertexCount*2*sizeof(float));   // 3 vertices, 2 coordinates each (x, y)
--  mesh.normals = (float *)MemAlloc(mesh.vertexCount*3*sizeof(float));     // 3 vertices, 3 coordinates each (x, y, z)
--
--  // Vertex at (0, 0, 0)
--  mesh.vertices[0] = 0;
--  mesh.vertices[1] = 0;
--  mesh.vertices[2] = 0;
--  mesh.normals[0] = 0;
--  mesh.normals[1] = 1;
--  mesh.normals[2] = 0;
--  mesh.texcoords[0] = 0;
--  mesh.texcoords[1] = 0;
--
--  // Vertex at (1, 0, 2)
--  mesh.vertices[3] = 1;
--  mesh.vertices[4] = 0;
--  mesh.vertices[5] = 2;
--  mesh.normals[3] = 0;
--  mesh.normals[4] = 1;
--  mesh.normals[5] = 0;
--  mesh.texcoords[2] = 0.5f;
--  mesh.texcoords[3] = 1.0f;
--
--  // Vertex at (2, 0, 0)
--  mesh.vertices[6] = 2;
--  mesh.vertices[7] = 0;
--  mesh.vertices[8] = 0;
--  mesh.normals[6] = 0;
--  mesh.normals[7] = 1;
--  mesh.normals[8] = 0;
--  mesh.texcoords[4] = 1;
--  mesh.texcoords[5] =0;
--
--  // Upload mesh data from CPU (RAM) to GPU (VRAM) memory
--  UploadMesh(&mesh, false);
--
--  return mesh;
--}
