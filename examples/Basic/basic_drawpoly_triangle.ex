/**************************************************************************
 *   Prog:      main.c         Ver: 2024.05.01         By: Jan Zumwalt    *
 *   About:     RayLib triangle functions                                 *
 *   Copyright: No rights reserved, released to the public domain.        *
 **************************************************************************  */
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
include std/math.e
--*/

-- -------------  global  -------------
    constant screenWidth = 800 
    constant screenHeight = 550 


-- -------------  functions  -------------

-- DrawTriangle - color-filled triangle (vertex in counter-clockwise order!)
procedure drawtriangle ()   
  sequence v1   = { 50, 150 } 
  sequence v2   = { 125, 150 } 
  sequence v3   = { 85, 75 } 
  sequence color    = { 75, 100, 225, 255 }   -- red, green, blue, alpha
  DrawTriangle ( v1, v2, v3, color ) 
end procedure


-- DrawTriangleFan - color-filled triangle fan (vertex in counter-clockwise order!)
--                   first point is center
procedure drawtrianglefan ()  
  sequence points = {   {260, 75},{ 260, 125} ,{300, 145} ,{ 345, 125} ,{ 345, 75},{ 300, 60} } --[6][2]
  integer     pointCount   = 6 
  sequence   color     = { 25, 100, 100, 255 }   -- red, green, blue, alpha
  DrawTriangleFan ( points, pointCount,color ) 

  DrawText ( "center\n point", 220, 65, 10, GREEN ) 
  DrawText ( "2", 250, 125, 10, GREEN ) 
  DrawText ( "3", 300, 150, 10, GREEN ) 
  DrawText ( "4", 350, 125, 10, GREEN ) 
  DrawText ( "5", 350,  65, 10, GREEN ) 
  DrawText ( "6", 297,  45, 10, GREEN ) 
end procedure


-- DrawTriangleLines - triangle outline (vertex in counter-clockwise order!)
procedure drawtrianglelines ()  
  sequence v1   = { 450, 150 } 
  sequence v2   = { 550, 150 } 
  sequence v3   = { 500, 75 } 
  sequence color    = { 255, 100, 100, 255 }   -- red, green, blue, alpha
  DrawTriangleLines( v1, v2, v3, color ) 
end procedure


-- DrawTriangleStrip - color-filled triangle strip defined by points
procedure drawtrianglestrip ()  
  sequence points = {   {650, 75} ,  {675, 150} ,  {700, 50} ,  {725, 150},  {750, 75}  } --[5][2]
  integer pointCount       = 5
  sequence color           = { 200, 200, 0, 255 }   -- red, green, blue, alpha
  DrawTriangleStrip ( points, pointCount, color ) 
end procedure


-- DrawLineStrip - line sequence (using gl lines)
procedure drawlinestrip () 
  sequence points = { {50, 475}, {75, 375},{ 100, 450},{ 125, 400} } -- [4][2]
  integer     pointCount   = 4                       -- num of points
  sequence   color     = { 0, 255, 100, 255 }    -- red, green, blue, alpha
  DrawLineStrip ( points, pointCount, color ) 
end procedure


-- DrawPoly - color-filled polygon n sided (Vector version)
procedure drawpoly () 
  sequence center = { 285, 440 } 
  integer   sides    = 5 
  atom radius    = 40.0 
  atom rotation = 45 
  sequence color     = { 250, 75, 0, 255 }   -- red, green, blue, alpha
  DrawPoly ( center, sides, radius, rotation, color ) 
end procedure


-- DrawPolyLines - polygon outline n sided
procedure drawpolylines () 
  sequence center   = { 500, 440 } 
  integer     sides    = 6 
  atom   radius   = 40.0 
  atom   rotation = 45 
  sequence   color    = { 0, 200, 225, 255 }    -- red, green, blue, alpha
  DrawPolyLines ( center, sides, radius, rotation, color) 
end procedure


-- DrawPolyLinesEx - polygon outline n sided with extended parameters
procedure drawpolylinesex () 
  sequence center   = {700,440} 
  integer     sides     = 7 
  atom   radius = 40.0 
  atom   rotation   = 45 
  atom   lineThick = 7 
  sequence   color  = { 225, 0, 255, 255 }   -- red, green, blue, alpha
  DrawPolyLinesEx ( center, sides, radius, rotation, lineThick, color ) 
end procedure


-- **************************************************
-- *                      main                      *
-- **************************************************

  -- .................     setup - run once     .................

  -- Hi-res and ant-aliased mode
  SetConfigFlags(or_all({FLAG_VSYNC_HINT,FLAG_MSAA_4X_HINT,FLAG_WINDOW_HIGHDPI})) 
  InitWindow ( screenWidth, screenHeight, "RayLib Template" ) 
  SetTargetFPS ( 60 )                            -- 60 frames-per-second

  -- .................       animation loop     .................
  while not (WindowShouldClose()) 
    do            -- Quit if win btn / ESC key
    -- .................          draw          .................
    BeginDrawing (  ) 
      ClearBackground ( BLACK )                -- clear window
      DrawText ( "RayLib 2d Triangle and Polygon Functions", 50, 10, 30, GREEN ) 

      DrawText ( "DrawTriangle",        50,  200, 10, WHITE ) 
      DrawText ( "DrawTriangleFan",    250,  200, 10, WHITE ) 
      DrawText ( "DrawTriangleLines",  450,  200, 10, WHITE ) 
      DrawText ( "DrawTriangleStrip",  650,  200, 10, WHITE ) 

      DrawText ( "DrawLineStrip",       50,  500, 10, WHITE ) 
      DrawText ( "DrawPoly",           265,  500, 10, WHITE ) 
      DrawText ( "DrawPolyLines",      460,  500, 10, WHITE ) 
      DrawText ( "DrawPolyLinesEx",    650,  500, 10, WHITE ) 


      -- triangles
      drawtriangle ( )           -- outline of triangle
      drawtrianglefan ( )        -- color-filled triangle fan
                                 -- points must be in counter-clockwise order
      drawtrianglelines ( )      -- Draw line
      drawtrianglestrip ( )      -- outline line (using triangles/quads)

      -- lines
      drawlinestrip ( )          -- line sequence (using gl lines)

      -- poly-lines
      drawpoly ( )               -- polygon outline (Vector version)
      drawpolylines ( )          -- polygon outline of n sides
      drawpolylinesex ( )        -- polygon outline of n sides, extended param

    EndDrawing (  ) 
    end while  -- .................  end animation loop  .................

  -- ***  quit  ***
  CloseWindow (  )               -- cleanup

