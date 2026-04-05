/**************************************************************************
 *   Prog:      main.c         Ver: 2024.05.01         By: Jan Zumwalt    *
 *   About:     RayLib rectangle functions                                   *
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


-- -------------  functions  -------------
-- void DrawRectangle(int x, int y, int width, int height, Color color);                                      -- Draw a color-filled rectangle
-- void DrawRectangleGradientEx(Rectangle rect, Color col1, Color col2, Color col3, Color col4);              -- Draw a gradient-filled rectangle with custom vertex colors
-- void DrawRectangleGradientH(int x, int y, int width, int height, Color color1, Color color2);              -- Draw a horizontal-gradient-filled rectangle
-- void DrawRectangleGradientV(int x, int y, int width, int height, Color color1, Color color2);              -- Draw a vertical-gradient-filled rectangle
-- void DrawRectangleLines(int x, int y, int width, int height, Color color);                                 -- Draw rectangle outline
-- void DrawRectangleLinesEx(Rectangle rect, float lineWidth, Color color);                                   -- Draw rectangle outline with extended parameters
-- void DrawRectanglePro(Rectangle rect, Vector2 origin, float rotation, Color color);                        -- Draw a color-filled rectangle with pro parameters
-- void DrawRectangleRec(Rectangle rect, Color color);                                                        -- Draw a color-filled rectangle
-- void DrawRectangleRounded(Rectangle rect, float radius, int segments, Color color);                       -- Draw rectangle with rounded edges
-- void DrawRectangleRoundedLines(Rectangle rect, float radius, int segments, float lineWidth, Color color); -- Draw rectangle with rounded edges outline
-- void DrawRectangleV(Vector2 position, Vector2 size, Color color);                                          -- Draw a color-filled rectangle (Vector version)

sequence rect,topl,botr,center
sequence color,color1,color2,color3,color4
atom x,y,width,height,segs,radius,lineWidth,rotDeg
-- **************************************************
-- *                      main                      *
-- **************************************************

  -- Hi-res and ant-aliased mode
  SetConfigFlags(or_all({FLAG_VSYNC_HINT , FLAG_MSAA_4X_HINT , FLAG_WINDOW_HIGHDPI}))
  InitWindow ( screenWidth, screenHeight, "RayLib Template" )
  SetTargetFPS ( 60 )                            -- 60 frames-per-second

  -- ..... animation loop
  while not ( WindowShouldClose (   ) )  -- Quit  ESC key
  do              
    BeginDrawing (  ) 
      ClearBackground ( BLACK )            -- clear window

      -- title
      DrawText ( "RayLib 2d Rectangle Functions", 150, 10, 30, GREEN ) 

      -- captions
      DrawText ( "DrawRectangle",              70,  175, 10, WHITE ) 
      DrawText ( "DrawRectangleV",            280,  175, 10, WHITE ) 
      DrawText ( "DrawRectangleRec",          480,  175, 10, WHITE ) 
      DrawText ( "DrawRectanglePro",          650,  175, 10, WHITE ) 

      DrawText ( "DrawRectangleGradientV",     50,  360, 10, WHITE ) 
      DrawText ( "DrawRectangleGradientH",    265,  360, 10, WHITE ) 
      DrawText ( "DrawRectangleGradientEx",   460,  360, 10, WHITE ) 
      DrawText ( "DrawRectangleLines",        650,  360, 10, WHITE ) 

      DrawText ( "DrawRectangleLinesEx",       50,  550, 10, WHITE ) 
      DrawText ( "DrawRectangleRounded",      265,  550, 10, WHITE ) 
      DrawText ( "DrawRectangleRoundedLines", 460,  550, 10, WHITE ) 


      -- functions
        -- Draw a color-filled rectangle
        --void DrawRectangle(int x, int y, int width, int height, Color color)
        color   = { 75, 100, 225, 255 }  -- red, green, blue, alpha
        DrawRectangle ( 60, 80, 100, 75, color ) -- Draw a color-filled rectangle
        
        -- Draw a color-filled rectangle (Vector version)
        -- void DrawRectangleV ( Vector2 position, Vector2 size, Color color )
        topl = { 275, 80}
        botr = { 100, 75}
        color  = {  75, 255, 255, 255 }         -- red, green, blue, alpha
        DrawRectangleV ( topl, botr, color )    -- Draw a color-filled rectangle
        
        -- Draw a color-filled rectangle
        -- void DrawRectangleRec ( Rectangle rect, Color color )
        rect = { 475, 80, 100, 75}
        color  = {  255, 200, 200, 255 }        -- red, green, blue, alpha
        DrawRectangleRec ( rect, color )        -- Draw a color-filled rectangle

        -- Draw a color-filled rectangle with vector and rotation
        -- void DrawRectanglePro ( Rectangle rect, Vector2 origin, float rotation, Color color )
        rect = { 735, 185, 100, 70 }            -- toplx, toply, width, height
        center = { 100, 100 }                   -- rotate center
        rotDeg = 22.5                       -- rotate degrees
        color  = {  75, 225, 100, 255 }     -- red, green, blue, alpha
        DrawRectanglePro ( rect, center, rotDeg, color ) -- Draw a color-filled rectangle
        
        -- Draw a vertical-gradient-filled rectangle
        -- void DrawRectangleGradientV ( int x, int y, int width, int height
        --                                    , Color color1, Color color2 )
        x = 60
        y = 270
        width = 100
        height = 75
        color1   = { 255, 100, 100, 255 }   -- red, green, blue, alpha
        color2   = { 100, 100, 255, 255 }   -- red, green, blue, alpha
        DrawRectangleGradientV ( x, y, width, height, color1, color2)

        -- Draw a horizontal-gradient-filled rectangle
        -- void DrawRectangleGradientH ( int x, int y, int width, int height
        --                                    , Color color1, Color color2 )
        x = 280
        y = 270
        width = 100
        height = 75
        color1   = { 255, 100, 100, 255 }   -- red, green, blue, alpha
        color2   = { 100, 100, 255, 255 }   -- red, green, blue, alpha
        DrawRectangleGradientH ( x, y, width, height, color1, color2)

        -- Draw a gradient-filled rectangle with custom vertex colors
        -- void DrawRectangleGradientEx ( Rectangle rect, Color col1, Color col2
        --                                              , Color col3, Color col4 )
        rect = { 470, 270, 100, 70 } -- toplx, toply, width, height
        color1   = { 200, 50, 50, 255 }  -- red, green, blue, alpha
        color2   = { 50, 50, 200, 255 }  -- red, green, blue, alpha
        color3   = { 50, 255, 50, 255 }  -- red, green, blue, alpha
        color4   = { 200, 50, 200, 255 }  -- red, green, blue, alpha
        DrawRectangleGradientEx ( rect, color1, color2, color3, color4 )

        -- Draw rectangle border
        -- void DrawRectangleLines ( int x, int y, int width, int height, Color color )
        x = 650
        y = 270
        lineWidth = 100
        height = 75
        color   = { 255, 100, 100, 255 } -- red, green, blue, alpha
        DrawRectangleLines ( x,  y, lineWidth, height, color )

        -- Draw rectangle outline with extended parameters
        -- void DrawRectangleLinesEx ( Rectangle rect, float lineWidth, Color color )
        rect = { 60, 460, 100, 70 } -- toplx, toply, width, height
        lineWidth = 10.0                    
        color = {  255, 200, 0, 255 }  -- red, green, blue, alpha
        DrawRectangleLinesEx ( rect, lineWidth, color )     

        -- Draw rectangle with rounded edges
        -- void DrawRectangleRounded ( Rectangle rect, float radius, int segments
        --                             , Color color )
        rect = { 275, 460, 100, 70 }     -- toplx, toply, width, height
        radius = 0.3                     
        segs = 10
        color = {   200, 255, 100, 255 }  -- red, green, blue, alpha
        DrawRectangleRounded ( rect, radius, segs, color )
        
        -- Draw rectangle with rounded edges outline
        -- void DrawRectangleRoundedLines ( Rectangle rect, float radius, int segments
        --                                            , float lineWidth, Color color )
        rect = { 485, 460, 100, 70 }    -- toplx, toply, width, height
        radius = 0.3                                
        segs = 10
        color = {   225, 0, 225, 255 }              -- red, green, blue, alpha
        DrawRectangleRoundedLines ( rect, radius, segs,  color )



    EndDrawing (  ) 
  end while  -- ......  end animation

  -- .....  quit
  CloseWindow (  )                               -- cleanup


