/*******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--#include "rcamera.h"
--/*
--include raylib.e
constant true=1
constant false=0
--*/
constant MAX_COLUMNS= 20
enum position_,target,up,fovy,projection
enum x,y,z
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person")

    -- Define the camera to look into our 3d world (position, target, up vector)
    sequence camera = Tcamera3D
    camera[position_] = { 0.0, 2.0, 4.0 }   -- Camera position
    camera[target] = { 0.0, 2.0, 0.0 }      -- Camera looking at point
    camera[up] = { 0.0, 1.0, 0.0 }          -- Camera up vector (rotation towards target)
    camera[fovy] = 60.0                             -- Camera field-of-view Y
    camera[projection] = CAMERA_PERSPECTIVE             -- Camera projection type

    integer cameraMode = CAMERA_FIRST_PERSON 

    -- Generates some random columns
    sequence heights=repeat(0,MAX_COLUMNS) 
    sequence positions=repeat({0,0,0},MAX_COLUMNS) 
    sequence colors=repeat({0,0,0,0},MAX_COLUMNS) 

    for  i = 1  to  MAX_COLUMNS 
    do
        heights[i] = GetRandomValue(1, 12) 
        positions[i] = { GetRandomValue(-15, 15), heights[i]/2.0, GetRandomValue(-15, 15) } 
        colors[i] = { GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255 } 
    end for

    DisableCursor()                     -- Limit cursor to relative movement inside the window

    SetTargetFPS(60)                    -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())      -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Switch camera mode
        if (IsKeyPressed(KEY_ONE))
        then
            cameraMode = CAMERA_FREE 
            camera[up] = { 0.0, 1.0, 0.0 }  -- Reset roll
        end if

        if (IsKeyPressed(KEY_TWO))
        then
            cameraMode = CAMERA_FIRST_PERSON 
            camera[up] = { 0.0, 1.0, 0.0 }  -- Reset roll
        end if

        if (IsKeyPressed(KEY_THREE))
        then
            cameraMode = CAMERA_THIRD_PERSON 
            camera[up] = { 0.0, 1.0, 0.0 }  -- Reset roll
        end if

        if (IsKeyPressed(KEY_FOUR))
        then
            cameraMode = CAMERA_ORBITAL 
            camera[up] = { 0.0, 1.0, 0.0 }  -- Reset roll
        end if

        -- Switch camera projection
        if (IsKeyPressed(KEY_P))
        then
            if (camera[projection] = CAMERA_PERSPECTIVE)
            then
                -- Create isometric view
                cameraMode = CAMERA_THIRD_PERSON 
                -- Note: The target distance is related to the render distance in the orthographic projection
                camera[position_] = { 0.0, 2.0, -100.0 } 
                camera[target] = { 0.0, 2.0, 0.0 } 
                camera[up] = { 0.0, 1.0, 0.0 } 
                camera[projection] = CAMERA_ORTHOGRAPHIC 
                camera[fovy] = 20.0  -- near plane width in CAMERA_ORTHOGRAPHIC
                camera=CameraYaw(camera, -135*DEG2RAD, true) 
                camera=CameraPitch(camera, -45*DEG2RAD, true, true, false) 
            elsif (camera[projection] = CAMERA_ORTHOGRAPHIC)
            then
                -- Reset to default view
                cameraMode = CAMERA_THIRD_PERSON 
                camera[position_] = { 0.0, 2.0, 10.0 } 
                camera[target] = { 0.0, 2.0, 0.0 } 
                camera[up] = { 0.0, 1.0, 0.0 } 
                camera[projection] = CAMERA_PERSPECTIVE 
                camera[fovy] = 60.0 
            end if
        end if

        -- Update camera computes movement internally depending on the camera mode
        -- Some default standard keyboard/mouse inputs are hardcoded to simplify use
        -- For advanced camera controls, it's recommended to compute camera movement manually
        camera=UpdateCamera(camera, cameraMode)                     -- Update camera
/*
        -- Camera PRO usage example (EXPERIMENTAL)
        -- This new camera function allows custom movement/rotation values to be directly provided
        -- as input parameters, with this approach, rcamera module is internally independent of raylib inputs
        UpdateCameraPro(&camera,
            (Vector3){
                (IsKeyDown(KEY_W) || IsKeyDown(KEY_UP))*0.1f -      -- Move forward-backward
                (IsKeyDown(KEY_S) || IsKeyDown(KEY_DOWN))*0.1f,
                (IsKeyDown(KEY_D) || IsKeyDown(KEY_RIGHT))*0.1f -   -- Move right-left
                (IsKeyDown(KEY_A) || IsKeyDown(KEY_LEFT))*0.1f,
                0.0f                                                -- Move up-down
            },
            (Vector3){
                GetMouseDelta().x*0.05f,                            -- Rotation: yaw
                GetMouseDelta().y*0.05f,                            -- Rotation: pitch
                0.0f                                                -- Rotation: roll
            },
            GetMouseWheelMove()*2.0f)                               -- Move to target (zoom)
*/
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 

                DrawPlane({ 0.0, 0.0, 0.0 }, { 32.0, 32.0 }, LIGHTGRAY)  -- Draw ground
                DrawCube({ -16.0, 2.5, 0.0 }, 1.0, 5.0, 32.0, BLUE)     -- Draw a blue wall
                DrawCube({ 16.0, 2.5, 0.0 }, 1.0, 5.0, 32.0, LIME)      -- Draw a green wall
                DrawCube({ 0.0, 2.5, 16.0 }, 32.0, 5.0, 1.0, GOLD)      -- Draw a yellow wall

                -- Draw some cubes around
                for  i = 1  to MAX_COLUMNS  
                do
                    DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i]) 
                    DrawCubeWires(positions[i], 2.0, heights[i], 2.0, MAROON) 
                end for

                -- Draw player cube
                if (cameraMode = CAMERA_THIRD_PERSON)
                then
                    DrawCube(camera[target], 0.5, 0.5, 0.5, PURPLE) 
                    DrawCubeWires(camera[target], 0.5, 0.5, 0.5, DARKPURPLE) 
                end if

            EndMode3D() 

            -- Draw info boxes
            DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5)) 
            DrawRectangleLines(5, 5, 330, 100, BLUE) 

            DrawText("Camera controls:", 15, 15, 10, BLACK) 
            DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, BLACK) 
            DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK) 
            DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, BLACK) 
            DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, BLACK) 
            DrawText("- Camera projection key: P", 15, 90, 10, BLACK) 

            DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5)) 
            DrawRectangleLines(600, 5, 195, 100, BLUE) 

            DrawText("Camera status:", 610, 15, 10, BLACK) 
            sequence text
            if  (cameraMode = CAMERA_FREE) then
                    text="FREE"
            elsif (cameraMode = CAMERA_FIRST_PERSON) then
                    text="FIRST_PERSON"
            elsif (cameraMode = CAMERA_THIRD_PERSON) then
                    text="THIRD_PERSON"
            elsif (cameraMode = CAMERA_ORBITAL) then
                    text="ORBITAL"
            else
                    text="CUSTOM"
            end if
            DrawText(TextFormat("- Mode: %s",{text}), 610, 30, 10, BLACK) 
            
            if camera[projection]=CAMERA_PERSPECTIVE then
                text="PERSPECTIVE"
            elsif camera[projection]=CAMERA_ORTHOGRAPHIC then
                text="ORTHOGRAPHIC"
            else
                text="CUSTOM"
            end if
            DrawText(TextFormat("- Projection: %s",{text}), 610, 45, 10, BLACK) 
            DrawText(TextFormat("- Position: (%06.3f, %06.3f, %06.3f)", {camera[position_][x], camera[position_][y], camera[position_][z]}), 610, 60, 10, BLACK) 
            DrawText(TextFormat("- Target: (%06.3f, %06.3f, %06.3f)", {camera[target][x], camera[target][y], camera[target][z]}), 610, 75, 10, BLACK) 
            DrawText(TextFormat("- Up: (%06.3f, %06.3f, %06.3f)", {camera[up][x], camera[up][y], camera[up][z]}), 610, 90, 10, BLACK) 
        DrawFPS(10,420)
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()  -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


