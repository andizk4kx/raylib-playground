/**************************************************************************
 *   Prog:      main.c         Ver: 2024.05.01         By: Jan Zumwalt    *
 *   About:     RayLib circle functions                                   *
 *   Copyright: No rights reserved, released to the public domain.        *
 **************************************************************************  */
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"
--/*
include std/math.e
--*/

-- -------------  global  -------------
    constant screenWidth = 1200 
    constant screenHeight = 550 

    -- DrawCircle - Draw a color-filled circle
    procedure drawcircle () 
      -- var example
      integer   centerX = 75 
      integer   centerY = 150 
      atom radius = 50 
      sequence color = { 50, 175, 50, 255 }   -- red, green, blue, alpha
      DrawCircle (centerX, centerY, radius, color)    -- green filled  circle


      -- DrawCircle inline example
      DrawCircle (200, 150, 50,  { 40, 100, 150, 255 } )   -- blue filled circle


      -- DrawCircle color name example
      DrawCircle (325, 150, 50,  BEIGE   )   -- BEIGE filled circle
    end procedure


    -- DrawCircleV - Draw a color-filled circle (Vector version)
    procedure  drawcirclev () 
      sequence center = { 450, 150 } 
      atom   radius = 50 
      sequence   color  = { 225, 100, 25, 255 }   -- red, green, blue, alpha
      DrawCircleV (center, radius, color)    -- green filled  circle
    end procedure


    -- DrawCircleGradient - gradient-filled circle
    procedure  drawcirclegradient () 
      integer   centerX = 575 
      integer   centerY = 150 
      atom radius = 50 
      sequence color1 = { 255, 25, 25, 255 }    -- red, green, blue, alpha
      sequence color2 = { 25, 25, 255, 255 }    -- red, green, blue, alpha
      DrawCircleGradient  ( centerX, centerY, radius, color1,color2  )  -- green/blue gradient
    end procedure

    -- DrawCircleLines - circle outline
    procedure   drawcirclelines () 
      integer   centerX = 700 
      integer   centerY = 150 
      atom radius   = 50 
      sequence color    = { 200, 50, 50, 255 } 
      DrawCircleLines ( centerX, centerY, radius, color )   -- red circle outline
    end procedure


    -- DrawCircleLinesV - circle outline (Vector version)
    procedure   drawcirclelinesv () 
      sequence center = { 825, 150 } 
      atom radius = 50 
      sequence color = { 200, 200, 25, 255 }    -- red, green, blue, alpha
      DrawCircleLinesV ( center, radius, color ) 
    end procedure


    -- DrawCircleSector - filled circle wedge, angle starts at 3 o'clock and are clockwise
    procedure   drawcirclesector () 
      sequence center   = { 950, 150 } 
      atom radius      = 50 
      atom startAngle = 45    -- degrees
      atom endAngle   = 270   -- degrees
      integer segments     = 8 
      sequence color = { 25, 150, 150, 255 }    -- red, green, blue, alpha
      DrawCircleSector  ( center, radius, startAngle, endAngle, segments, color ) 
    end procedure


    -- DrawCircleSectorLines - filled circle wedge, angles starts at 3 o'clock and are clockwise
    procedure   drawcirclesectorlines () 
      sequence center   = { 1075, 150 } 
      atom radius      = 50 
      atom startAngle = 45    -- degrees
      atom endAngle   = 270   -- degrees
      integer segments     = 8 
      sequence color = { 255, 255, 25, 255 }    -- red, green, blue, alpha
      DrawCircleSectorLines  ( center, radius, startAngle, endAngle, segments, color ) 
    end procedure


    -- DrawRing - colored donut
    procedure   drawring () 
      sequence center = { 75, 400 } 
      atom  innerRadius = 40 
      atom  outerRadius = 50 
      atom  startAngle  = 45 
      atom  endAngle      = 360 
      integer     segments    = 8 
      sequence   color  = { 75, 100, 225, 255 }   -- red, green, blue, alpha
      DrawRing ( center, innerRadius, outerRadius, startAngle, endAngle, segments, color )    -- green filled  circle
    end procedure


    -- DrawRingLines - donut outline
    procedure   drawringlines () 
      sequence center = { 200, 400 } 
      atom  innerRadius = 40 
      atom  outerRadius = 50 
      atom  startAngle  = 45 
      atom  endAngle      = 270 
      integer     segments    = 8 
      sequence   color  = { 75, 100, 225, 255 }   -- red, green, blue, alpha
      DrawRingLines ( center, innerRadius, outerRadius, startAngle, endAngle, segments, color )    -- green filled  circle
    end procedure


    -- DrawEllipse - cored filled ellipse
    procedure   drawellipse () 
      integer centerX = 325 
      integer centerY = 400 
      atom  radiusH = 50 
      atom  radiusV = 35 
      sequence   color  = { 75, 100, 225, 255 }   -- red, green, blue, alpha
      DrawEllipse ( centerX, centerY, radiusH, radiusV, color )    -- green filled  circle
    end procedure


    -- DrawEllipseLines - outline of ellipse
    procedure   drawellipselines () 
      integer centerX = 450 
      integer centerY = 400 
      atom  radiusH = 50 
      atom  radiusV = 35 
      sequence   color  = { 75, 100, 225, 255 }   -- red, green, blue, alpha
      DrawEllipseLines ( centerX, centerY, radiusH, radiusV, color )    -- green filled  circle
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
  while not(WindowShouldClose ())            -- Quit if win btn / ESC key
  do -- .................         draw          .................
    BeginDrawing (  ) 
      ClearBackground ( BLACK )                -- clear window
      DrawText ( "RayLib 2d Circle Functions", 300, 10, 40, GREEN ) 

      DrawText ( "DrawCircle (vars)",       30,  220, 10, WHITE ) 
        DrawText ( "Inline example",       160,  220, 10, WHITE ) 
        DrawText ( "Color name example",   275,  220, 10, WHITE ) 
      DrawText ( "DrawCircleV",            420,  220, 10, WHITE ) 
      DrawText ( "DrawCircleGradient",     525,  220, 10, WHITE ) 
      DrawText ( "DrawCircleLines",        650,  220, 10, WHITE ) 
      DrawText ( "DrawCircleLinesV",       775,  220, 10, WHITE ) 
      DrawText ( "DrawCircleSector",       900,  220, 10, WHITE ) 
      DrawText ( "DrawCircleSectorLines", 1025,  220, 10, WHITE ) 

      DrawText ( "DrawRing",                50,  475, 10, WHITE ) 
      DrawText ( "DrawRingLines",          155,  475, 10, WHITE ) 

      DrawText ( "DrawEllipse",            290,  475, 10, WHITE ) 
      DrawText ( "DrawEllipseLines",       415,  475, 10, WHITE ) 

      drawcircle ( ) 
      drawcirclegradient ( ) 
      drawcirclelines ( ) 
      drawcirclelinesv ( ) 
      drawcirclesector ( ) 
      drawcirclesectorlines ( ) 
      drawcirclev ( ) 

      drawring ( ) 
      drawringlines ( ) 

      drawellipse ( ) 
      drawellipselines ( ) 

    EndDrawing (  ) 
  end while  -- .................  end animation loop  .................

  -- ***  quit  ***
  CloseWindow (  )                               -- cleanup

