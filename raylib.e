-- file: ray.e 
-- practically everything is shamelessly copied from Icy Vikings raylib.e
include rayconst.e
global atom ray 

constant Color =C_ULONG,
         CF= C_FLOAT,
         CP= C_PTR
constant bits=machine_bits()


public struct Vector2
    atom x = 0
    atom y = 0
end struct

public  struct Rectangle
    atom x = 0
    atom y = 0
    atom width = 0
    atom height = 0
end struct


sequence raylib=""
if bits=32 then
    raylib="raylib_32.dll"
else
    raylib="raylib.dll"
end if


ray = open_dll(raylib)

if ray = 0 then
        puts(1,"Unable to load Raylib!\n")
        abort(0)
end if

--public function makeRGB(integer REDi,integer GREENi, integer BLUEi,integer ALPHAi)
--      return(REDi+BLUEi*256+(GREENi*256*256)+(ALPHAi*256*256*256))
--end function

public function makeRGB(sequence color)
        return(color[1]+color[2]*256+(color[3]*256*256)+(color[4]*256*256*256))         
end function



                

constant xInitWindow = define_c_proc(ray,"+InitWindow",{C_INT,C_INT,C_PTR}),
        xCloseWindow = define_c_proc(ray,"+CloseWindow",{}),
  xWindowShouldClose = define_c_func(ray,"+WindowShouldClose",{},C_BOOL),
       xSetTargetFPS = define_c_proc(ray,"+SetTargetFPS",{C_INT}),
       xBeginDrawing = define_c_proc(ray,"+BeginDrawing",{}),
         xEndDrawing = define_c_proc(ray,"+EndDrawing",{}),
    xClearBackground = define_c_proc(ray,"+ClearBackground",{Color}),
           xDrawText = define_c_proc(ray,"+DrawText",{CP,C_INT,C_INT,C_INT,Color}),
xIsWindowReady = define_c_func(ray,"+IsWindowReady",{},C_BOOL),
    xIsWindowFullscreen = define_c_func(ray,"+IsWindowFullscreen",{},C_BOOL),
    xIsWindowHidden = define_c_func(ray,"+IsWindowHidden",{},C_BOOL),
    xIsWindowMinimized = define_c_func(ray,"+IsWindowMinimized",{},C_BOOL),
    xIsWindowMaximized = define_c_func(ray,"+IsWindowMaximized",{},C_BOOL),
    xIsWindowFocused = define_c_func(ray,"+IsWindowFocused",{},C_BOOL),
    xIsWindowResized = define_c_func(ray,"+IsWindowResized",{},C_BOOL),
    xIsWindowState = define_c_func(ray,"+IsWindowState",{C_UINT},C_BOOL),
    xSetWindowState = define_c_proc(ray,"+SetWindowState",{C_UINT}),
    
    xGetScreenWidth = define_c_func(ray,"+GetScreenWidth",{},C_INT),
    xGetScreenHeight = define_c_func(ray,"+GetScreenHeight",{},C_INT),
    xIsKeyPressed = define_c_func(ray,"+IsKeyPressed",{C_INT},C_BOOL),
    xIsKeyPressedRepeat = define_c_func(ray,"+IsKeyPressedRepeat",{C_INT},C_BOOL),
    xIsKeyDown = define_c_func(ray,"+IsKeyDown",{C_INT},C_BOOL),
    xIsKeyReleased = define_c_func(ray,"+IsKeyReleased",{C_INT},C_BOOL),
    xIsKeyUp = define_c_func(ray,"+IsKeyUp",{C_INT},C_BOOL),
    xGetKeyPressed = define_c_func(ray,"+GetKeyPressed",{},C_INT),
    xGetCharPressed = define_c_func(ray,"+GetCharPressed",{},C_INT),
    xSetExitKey = define_c_proc(ray,"+SetExitKey",{C_INT}),
    xDrawFPS = define_c_proc(ray,"+DrawFPS",{C_INT,C_INT}),
    xSetConfigFlags = define_c_proc(ray,"+SetConfigFlags",{C_UINT}),
    xDrawCircle = define_c_proc(ray,"+DrawCircle",{C_INT,C_INT,C_FLOAT,Color}),
    xDrawCircleSector = define_c_proc(ray,"+DrawCircleSector",{CF,CF,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,Color}),
    xDrawCircleSectorLines = define_c_proc(ray,"+DrawCircleSectorLines",{CF,CF,C_FLOAT,C_FLOAT,C_FLOAT,C_INT,Color}),
    xDrawCircleGradient = define_c_proc(ray,"+DrawCircleGradient",{C_INT,C_INT,C_FLOAT,Color,Color}),
    xDrawCircleV = define_c_proc(ray,"+DrawCircleV",{CF,CF,C_FLOAT,Color}),
    xDrawCircleLines = define_c_proc(ray,"+DrawCircleLines",{C_INT,C_INT,C_FLOAT,Color}),
    xDrawCircleLinesV = define_c_proc(ray,"+DrawCircleLinesV",{CF,CF,C_FLOAT,Color}),
    xDrawRectangle = define_c_proc(ray,"+DrawRectangle",{C_INT,C_INT,C_INT,C_INT,Color}),
    xDrawRectangleGradientH = define_c_proc(ray,"+DrawRectangleGradientH",{C_INT,C_INT,C_INT,C_INT,Color,Color}),
    xDrawRectangleLines = define_c_proc(ray,"+DrawRectangleLines",{C_INT,C_INT,C_INT,C_INT,Color}),
    xDrawRectangleLinesEx = define_c_proc(ray,"+DrawRectangleLinesEx",{CF,CF,CF,CF,C_FLOAT,Color}),
    xDrawTriangle = define_c_proc(ray,"+DrawTriangle",{CF,CF,CF,CF,CF,CF,Color}),
    xDrawTriangleLines = define_c_proc(ray,"+DrawTriangleLines",{CF,CF,CF,CF,CF,CF,Color}),
    xDrawPoly = define_c_proc(ray,"+DrawPoly",{CF,CF,C_INT,C_FLOAT,C_FLOAT,Color}),
    xDrawPolyLines = define_c_proc(ray,"+DrawPolyLines",{CF,CF,C_INT,C_FLOAT,C_FLOAT,Color}),
    xDrawPolyLinesEx = define_c_proc(ray,"+DrawPolyLinesEx",{CF,CF,C_INT,C_FLOAT,C_FLOAT,C_FLOAT,Color}),
    xDrawLine = define_c_proc(ray,"+DrawLine",{C_INT,C_INT,C_INT,C_INT,Color}),
    xDrawRectangleRec = define_c_proc(ray,"+DrawRectangleRec",{CF,CF,CF,CF,Color}),

    xIsMouseButtonPressed = define_c_func(ray,"+IsMouseButtonPressed",{C_INT},C_BOOL),
    xIsMouseButtonDown = define_c_func(ray,"+IsMouseButtonDown",{C_INT},C_BOOL),
    xIsMouseButtonReleased = define_c_func(ray,"+IsMouseButtonReleased",{C_INT},C_BOOL),
    xIsMouseButtonUp = define_c_func(ray,"+IsMouseButtonUp",{C_INT},C_BOOL),
    xGetMouseX = define_c_func(ray,"+GetMouseX",{},C_INT),
    xGetMouseY = define_c_func(ray,"+GetMouseY",{},C_INT),
    --xGetMousePosition = define_c_func(ray,"+GetMousePosition",{},Vector2),
    --xGetMouseDelta = define_c_func(ray,"+GetMouseDelta",{},Vector2),
    xSetMousePosition = define_c_proc(ray,"+SetMousePosition",{C_INT,C_INT}),
    xSetMouseOffset = define_c_proc(ray,"+SetMouseOffset",{C_INT,C_INT}),
    xSetMouseScale = define_c_proc(ray,"+SetMouseScale",{C_FLOAT,C_FLOAT}),
    xGetMouseWheelMove = define_c_func(ray,"+GetMouseWheelMove",{},C_FLOAT),
    --xGetMouseWheelMoveV = define_c_func(ray,"+GetMouseWheelMoveV",{},Vector2),
    xSetMouseCursor = define_c_proc(ray,"+SetMouseCursor",{C_INT})
    
public procedure SetConfigFlags(atom flags)
        c_proc(xSetConfigFlags,{flags})
end procedure

public procedure DrawFPS(atom x,atom y)
        c_proc(xDrawFPS,{x,y})
end procedure

public function GetScreenWidth()
        return c_func(xGetScreenWidth,{})
end function

public function GetScreenHeight()
        return c_func(xGetScreenHeight,{})
end function
    
public function IsKeyPressed(atom key)
        return c_func(xIsKeyPressed,{key})
end function

public function IsKeyPressedRepeat(atom key)
        return c_func(xIsKeyPressedRepeat,{key})
end function

public function IsKeyDown(atom key)
        return c_func(xIsKeyDown,{key})
end function

public function IsKeyReleased(atom key)
        return c_func(xIsKeyReleased,{key})
end function

public function IsKeyUp(atom key)
        return c_func(xIsKeyUp,{key})
end function

public function GetKeyPressed()
        return c_func(xGetKeyPressed,{})
end function

public function GetCharPressed()
        return c_func(xGetCharPressed,{})
end function

public procedure SetExitKey(atom key)
        c_proc(xSetExitKey,{key})
end procedure
        
public procedure InitWindow(atom width,atom height,sequence title)
atom ptitle = allocate_string(title)        
        c_proc(xInitWindow,{width,height,ptitle})
        free(ptitle)
end procedure

public procedure CloseWindow()
        c_proc(xCloseWindow,{})
end procedure

public function WindowShouldClose()
        return c_func(xWindowShouldClose,{})
end function

public procedure SetTargetFPS(atom fps)
        c_proc(xSetTargetFPS,{fps})
end procedure

public procedure ClearBackground(object  color)
        c_proc(xClearBackground,{makeRGB(color)})
end procedure

public procedure BeginDrawing()
        c_proc(xBeginDrawing,{})
end procedure

public procedure EndDrawing()
        c_proc(xEndDrawing,{})
end procedure

public procedure DrawText(sequence text,atom x,atom y,atom fontSize,sequence color)
atom ptext =allocate_string(text)
        c_proc(xDrawText,{ptext,x,y,fontSize,makeRGB(color)})
        free(ptext)
end procedure

public procedure DrawCircleV(Vector2 center,atom radius,sequence color)
        c_proc(xDrawCircleV,{center.x,center.y,radius,makeRGB(color)})
end procedure

public procedure DrawCircle(atom x,atom y,atom radius,sequence color)
        c_proc(xDrawCircle,{x,y,radius,makeRGB(color)})
end procedure

public procedure DrawCircleSector(Vector2 center,atom radius,atom start,atom endAngle,atom segments,sequence color)
        c_proc(xDrawCircleSector,{center.x,center.y,radius,start,endAngle,segments,makeRGB(color)})
end procedure

public procedure DrawCircleSectorLines(Vector2 center,atom radius,atom start,atom endAngle,atom segments,sequence color)
        c_proc(xDrawCircleSectorLines,{center.x,center.y,radius,start,endAngle,segments,makeRGB(color)})
end procedure

public procedure DrawCircleGradient(atom x,atom y,atom radius,sequence inner,sequence outer)
        c_proc(xDrawCircleGradient,{x,y,radius,makeRGB(inner),makeRGB(outer)})
end procedure


public procedure DrawCircleLines(atom x,atom y,atom radius,sequence color)
        c_proc(xDrawCircleLines,{x,y,radius,makeRGB(color)})
end procedure

public procedure DrawCircleLinesV(Vector2 center,atom radius,sequence color)
        c_proc(xDrawCircleLinesV,{center.x,center.y,radius,makeRGB(color)})
end procedure       

public procedure DrawRectangle(atom x,atom y,atom width,atom height,sequence color)
        c_proc(xDrawRectangle,{x,y,width,height,makeRGB(color)})
end procedure

public procedure DrawRectangleGradientH(atom x,atom y,atom width,atom height,sequence left,sequence right)
        c_proc(xDrawRectangleGradientH,{x,y,width,height,makeRGB(left),makeRGB(right)})
end procedure

public procedure DrawRectangleLines(atom x,atom y,atom width,atom height,sequence color)
        c_proc(xDrawRectangleLines,{x,y,width,height,makeRGB(color)})
end procedure

public procedure DrawTriangle(Vector2 v,Vector2 v2,Vector2 v3,sequence color)
        c_proc(xDrawTriangle,{v.x,v.y,v2.x,v2.y,v3.x,v3.y,makeRGB(color)})
end procedure

public procedure DrawTriangleLines(Vector2 v,Vector2 v2,Vector2 v3,sequence color)
        c_proc(xDrawTriangleLines,{v.x,v.y,v2.x,v2.y,v3.x,v3.y,makeRGB(color)})
end procedure

public procedure DrawPoly(Vector2 center,atom sides,atom radius,atom rotation,sequence color)
        c_proc(xDrawPoly,{center.x,center.y,sides,radius,rotation,makeRGB(color)})
end procedure

public procedure DrawPolyLines(Vector2 center,atom sides,atom radius,atom rotation,sequence color)
        c_proc(xDrawPolyLines,{center.x,center.y,sides,radius,rotation,makeRGB(color)})
end procedure

public procedure DrawPolyLinesEx(Vector2 center,atom sides,atom radius,atom rotation,atom thick,sequence color)
        c_proc(xDrawPolyLinesEx,{center.x,center.y,sides,radius,rotation,thick,makeRGB(color)})
end procedure

public procedure DrawLine(atom startX,atom startY,atom endX,atom endY,sequence color)
        c_proc(xDrawLine,{startX,startY,endX,endY,makeRGB(color)})
end procedure

public procedure DrawRectangleRec(Rectangle rec,sequence color)
        c_proc(xDrawRectangleRec,{rec.x,rec.y,rec.width,rec.height,makeRGB(color)})
end procedure

public procedure DrawRectangleLinesEx(Rectangle rec,atom thick,sequence color)
        c_proc(xDrawRectangleLinesEx,{rec.x,rec.y,rec.width,rec.height,thick,makeRGB(color)})
end procedure

public function IsMouseButtonPressed(atom button)
        return c_func(xIsMouseButtonPressed,{button})
end function

public function IsMouseButtonDown(atom button)
        return c_func(xIsMouseButtonDown,{button})
end function

public function IsMouseButtonReleased(atom button)
        return c_func(xIsMouseButtonReleased,{button})
end function

public function IsMouseButtonUp(atom button)
        return c_func(xIsMouseButtonUp,{button})
end function

public function GetMouseX()
        return c_func(xGetMouseX,{})
end function

public function GetMouseY()
        return c_func(xGetMouseY,{})
end function
/*
public function GetMousePosition()
        return c_func(xGetMousePosition,{})
end function

public function GetMouseDelta()
        return c_func(xGetMouseDelta,{})
end function
*/
public function GetMousePosition()
Vector2 pos = new()
    pos.x=c_func(xGetMouseX,{})
    pos.y=c_func(xGetMouseY,{})
    return pos
end function

public procedure SetMousePosition(atom x,atom y)
        c_proc(xSetMousePosition,{x,y})
end procedure

public procedure SetMouseOffset(atom x,atom y)
        c_proc(xSetMouseOffset,{x,y})
end procedure

public procedure SetMouseScale(atom x,atom y)
        c_proc(xSetMouseScale,{x,y})
end procedure

public function GetMouseWheelMove()
        return c_func(xGetMouseWheelMove,{})
end function
/*
public function GetMouseWheelMoveV()
        return c_func(xGetMouseWheelMoveV,{})
end function
*/
public procedure SetMouseCursor(atom cursor)
        c_proc(xSetMouseCursor,{cursor})
end procedure

public function IsWindowReady()
        return c_func(xIsWindowReady,{})
end function

public function IsWindowFullscreen()
        return c_func(xIsWindowFullscreen,{})
end function

public function IsWindowHidden()
        return c_func(xIsWindowHidden,{})
end function

public function IsWindowMinimized()
        return c_func(xIsWindowMinimized,{})
end function

public function IsWindowMaximized()
        return c_func(xIsWindowMaximized,{})
end function

public function IsWindowFocused()
        return c_func(xIsWindowFocused,{})
end function

public function IsWindowResized()
        return c_func(xIsWindowResized,{})
end function

public function IsWindowState(atom flag)
        return c_func(xIsWindowState,{flag})
end function

public procedure SetWindowState(atom flags)
        c_proc(xSetWindowState,{flags})
end procedure       
