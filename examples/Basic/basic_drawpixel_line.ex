/**************************************************************************
 *   Prog:      main.c         Ver: 2024.05.01         By: Jan Zumwalt    *
 *   About:     RayLib pixel and line functions                           *
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
-- pixel
procedure drawpixel () 
  for count = 0 to  150 
    do
    integer   posX  = GetRandomValue ( 1, 150 ) + 50 
    integer   posY  = GetRandomValue ( 1, 75 ) + 100 
    sequence color = { 255, 225, 255, 255 }                      -- red, green, blue, alpha
    DrawPixel(posX, posY, color)   -- pixel
  end for
end procedure


-- pixel (Vector version)
procedure drawpixelv () 
  for count = 0 to  150
    do 
    sequence posXY = { GetRandomValue ( 1, 150 ) + 300, GetRandomValue ( 1, 75 ) + 100 } 
    sequence    color = { 225, 255, 255, 255 }   -- red, green, blue, alpha
    DrawPixelV(posXY, color) 
  end for
end procedure


-- lines
procedure drawline () 
  integer   startPosX = 575 
  integer   startPosY = 100 
  integer   endPosX   = 675 
  integer   endPosY   = 150 
  sequence color      = { 225, 225, 255, 255 }   -- red, green, blue, alpha
  DrawLine( startPosX, startPosY, endPosX, endPosY,  color)   -- Draw a line
end procedure


procedure drawlineex () 
  sequence startPos = { 75, 250 } 
  sequence endPos   = { 175, 325 } 
  atom  thick    = 7 
  sequence   color    = { 75, 255, 225, 255 }   -- red, green, blue, alpha
  DrawLineEx(startPos, endPos, thick, color)   -- Draw a line (using triangles/quads)
end procedure


procedure drawlinestrip () 
  sequence pts = {  {350, 250} , { 400, 325} , { 450, 250 }, { 350, 250 } } -- [4][2]
  integer ptCount = 4                         -- num of poin ts
  sequence color = { 255, 255, 225, 255 }    -- red, green, blue, alpha
  DrawLineStrip ( pts, ptCount, color )   -- draw line sequence (using gl lines)
end procedure


procedure drawlinev () 
  sequence startPos = { 575, 250 } 
  sequence endPos   = { 675, 325 } 
  sequence   color    = { 75, 100, 125, 255 }   -- red, green, blue, alpha
  DrawLineV( startPos, endPos, color)   -- Draw a line (using gl lines)
end procedure


-- poly-lines
procedure drawpoly () 
  sequence center = { 125, 440 } 
  integer   sides    = 5 
  atom radius    = 40.0 
  atom rotation = 45 
  sequence color     = { 75, 100, 225, 255 }   -- red, green, blue, alpha
  DrawPoly ( center, sides, radius, rotation, color)    -- n sided filled polygon (Vector version)
end procedure


procedure drawpolylines () 
  sequence center   = { 375, 440 } 
  integer     sides    = 5 
  atom  radius   = 40.0 
  atom  rotation = 45 
  sequence   color    = { 75, 100, 225, 255 }   -- red, green, blue, alpha
  DrawPolyLines ( center, sides, radius, rotation, color)    -- n sided polygon outline

end procedure


procedure drawpolylinesex () 
  sequence center   = { 650, 440 } 
  integer     sides     = 5 
  atom  radius  = 40.0 
  atom  rotation    = 45 
  atom  lineThick = 7 
  sequence   color  = { 75, 100, 225, 255 }   -- red, green, blue, alpha
  DrawPolyLinesEx( center, sides, radius, rotation, lineThick, color )   -- Draw a polygon outline of n sides with extended parameters

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
  while not (WindowShouldClose())             -- Quit if win btn / ESC key
  do    -- .................          draw          .................
    BeginDrawing (  ) 
      ClearBackground ( BLACK )                -- clear window
      DrawText ( "RayLib 2d Pixel and Line Functions", 50, 10, 40, GREEN ) 

      DrawText ( "DrawPixel",       100,  200, 10, WHITE ) 
      DrawText ( "DrawPixelV",      350,  200, 10, WHITE ) 

      DrawText ( "DrawLine",        600,  200, 10, WHITE ) 
      DrawText ( "DrawLineEx",      100,  350, 10, WHITE ) 
      DrawText ( "DrawLineStrip",   350,  350, 10, WHITE ) 
      DrawText ( "DrawLineV",       600,  350, 10, WHITE ) 

      DrawText ( "DrawPoly",        100,  500, 10, WHITE ) 
      DrawText ( "DrawPolyLines",   350,  500, 10, WHITE ) 
      DrawText ( "DrawPolyLinesEx", 600,  500, 10, WHITE ) 


      -- pixels
      drawpixel ()            -- Draw pixel
      drawpixelv ()        -- Draw pixel (Vector version)

      -- lines
      drawline ()          -- Draw line
      drawlineex ()        -- Draw line (using triangles/quads)
      drawlinestrip ()     -- Draw line sequence (using gl lines)
      drawlinev ()         -- Draw line (using gl lines)

      -- poly-lines
      drawpoly ()          -- Draw regular polygon (Vector version)
      drawpolylines ()     -- Draw polygon outline of n sides
      drawpolylinesex ()   -- Draw polygon outline of n sides, extended param

    EndDrawing (  ) 
  end while  -- .................  end animation loop  .................

  -- ***  quit  ***
  CloseWindow (  )                               -- cleanup

