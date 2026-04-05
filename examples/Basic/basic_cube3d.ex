/**************************************************************************
 *   Prog:      main.c     Ver: 2024.03.10     By: Jan Zumwalt            *
 *   About:     RayLib very simple 3d cube example                        *
 *   Copyright: No rights reserved, released to the public domain.        *
 **************************************************************************  */
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
include std/math.e
--*/
-- -------------  global  -------------
    constant screenWidth = 800 
    constant screenHeight = 650 
enum _position,target,up,fovy,projection
  -- .....  hi-res setup  .....
  SetConfigFlags ( or_all({FLAG_VSYNC_HINT,FLAG_MSAA_4X_HINT,FLAG_WINDOW_HIGHDPI}) )
  InitWindow ( screenWidth, screenHeight, "Simple Spinning 3D Cube" )

  -- camera settings effect drawing between BeginMode3D and EndMode3D
  sequence camera   = Tcamera3D                             -- create camera
  camera[_position] = { 0.0, 10.0, 10.0 }   -- coordinate origin
  camera[target]    = { 0.0,  0.0,  0.0 }   -- rotation and zoom point
  camera[up]        = { 0.0,  1.0,  0.0 }   -- rotation
  camera[fovy]      = 20.0                              -- field of view i.e. zoom deg
  camera[projection] = CAMERA_PERSPECTIVE                   -- projection, persp or ortho
  SetTargetFPS ( 60 )                                       -- set frames per second

  -- Main game loop
  while not (WindowShouldClose()) 
  do                        -- loop until win close btn or ESC
    camera=UpdateCamera ( camera, CAMERA_ORBITAL )          -- builtin func orbits camera
    BeginDrawing (  )
      ClearBackground ( BLACK )
      BeginMode3D ( camera )
        DrawCube      ( { 0.0, 0.0, 0.0 }, 2.0, 2.0, 2.0, RED )
        DrawCubeWires ( { 0.0, 0.0, 0.0 }, 2.0, 2.0, 2.0, BLUE )
      EndMode3D (  )
      DrawText ( "Spinning 3D Cube", 300, 420, 20, LIGHTGRAY )
    DrawFPS(10,10)
    EndDrawing (  )
  end while

  -- *****  quit  *****
  CloseWindow (  )  -- close raylib and opengl

