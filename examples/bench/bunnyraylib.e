--file: bunnyraylib.e only 64bitPhix/Euphoria
--/*
include std/dll.e
include std/machine.e
include std/convert.e
--*/
constant Color =C_ULONG,        
        C_TEXTURE=C_POINTER,
        C_HPTR=C_POINTER --A Pointer that is added (64 bit calling convention) for a struct result (not really part of the Api)
                         -- normally silenty done by the C-Compiler
atom ray=0


sequence raylib="raylib.dll"
ray = open_dll(raylib)

global constant     MOUSE_BUTTON_LEFT    = 0      --  // Mouse button left

--Colors                                
global  constant WHITE = {255,255,255,255},
                 BLACK = {0,0,0,255},
                 RAYWHITE = {245,245,245,255},
                 GREEN    = {0,228,48,255},
                 MAROON    = {190,33,55,255}            



-- Converts a 64-bit Vector2 result into a sequence
function RegtoV2(atom in)
sequence result={0,0}
sequence x=int_to_bytes(in,8)
    result[1]=float32_to_atom(x[1..4])
    result[2]=float32_to_atom(x[5..8])
return result
end function

constant xInitWindow = define_c_proc(ray,"+InitWindow",{C_INT,C_INT,C_POINTER})

global procedure InitWindow(atom width,atom height,sequence title)
atom ptitle = allocate_string(title)        
        c_proc(xInitWindow,{width,height,ptitle})
        free(ptitle)
end procedure

constant xWindowShouldClose = define_c_func(ray,"+WindowShouldClose",{},C_BOOL)

global function WindowShouldClose()
        return c_func(xWindowShouldClose,{})
end function

constant xCloseWindow = define_c_proc(ray,"+CloseWindow",{})

public procedure CloseWindow()
        c_proc(xCloseWindow,{})
end procedure

constant xIsMouseButtonDown = define_c_func(ray,"+IsMouseButtonDown",{C_INT},C_BOOL)

global function IsMouseButtonDown(atom button)
        return and_bits(c_func(xIsMouseButtonDown,{button}),1)
end function

constant xBeginDrawing = define_c_proc(ray,"+BeginDrawing",{})

global procedure BeginDrawing()
        c_proc(xBeginDrawing,{})
end procedure

constant xEndDrawing = define_c_proc(ray,"+EndDrawing",{})

global procedure EndDrawing()
        c_proc(xEndDrawing,{})
end procedure

constant xSetTargetFPS = define_c_proc(ray,"+SetTargetFPS",{C_INT})

global procedure SetTargetFPS(atom fps)
        c_proc(xSetTargetFPS,{fps})
end procedure


constant xClearBackground = define_c_proc(ray,"+ClearBackground",{Color})

global procedure ClearBackground(object  color)
        c_proc(xClearBackground,{bytes_to_int(color)})
end procedure

constant xGetScreenWidth = define_c_func(ray,"+GetScreenWidth",{},C_INT)

global function GetScreenWidth()
        return c_func(xGetScreenWidth,{})
end function

constant xGetScreenHeight = define_c_func(ray,"+GetScreenHeight",{},C_INT)

global function GetScreenHeight()
        return c_func(xGetScreenHeight,{})
end function

constant xDrawFPS = define_c_proc(ray,"+DrawFPS",{C_INT,C_INT})

global procedure DrawFPS(atom x,atom y)
        c_proc(xDrawFPS,{x,y})
end procedure

constant xDrawText = define_c_proc(ray,"DrawText",{C_POINTER,C_INT,C_INT,C_INT,Color})

global procedure DrawText(sequence text,atom x,atom y,atom fontSize,sequence color)
atom ptext =allocate_string(text)
        c_proc(xDrawText,{ptext,x,y,fontSize,bytes_to_int(color)})
        free(ptext)
end procedure

constant xDrawRectangle = define_c_proc(ray,"DrawRectangle",{C_INT,C_INT,C_INT,C_INT,Color})

global procedure DrawRectangle(atom x,atom y,atom width,atom height,sequence color)
        c_proc(xDrawRectangle,{x,y,width,height,bytes_to_int(color)})
end procedure

constant xUnloadTexture = define_c_proc(ray,"+UnloadTexture",{C_TEXTURE})

global procedure UnloadTexture(sequence  tex)
atom mem=allocate(20)
poke4(mem,tex[1])
poke4(mem+4,tex[2])
poke4(mem+8,tex[3])
poke4(mem+12,tex[4])
poke4(mem+16,tex[5])
        c_proc(xUnloadTexture,{mem})
free(mem)
end procedure

constant xDrawTexture = define_c_proc(ray,"DrawTexture",{C_TEXTURE,C_INT,C_INT,Color})

global procedure DrawTexture(sequence  tex,atom x,atom y,sequence color)
atom mem=allocate(20)
poke4(mem,tex[1])
poke4(mem+4,tex[2])
poke4(mem+8,tex[3])
poke4(mem+12,tex[4])
poke4(mem+16,tex[5])
        c_proc(xDrawTexture,{mem,x,y,bytes_to_int(color)})
free(mem)
end procedure

global constant xLoadTexture = define_c_func(ray,"+LoadTexture",{C_HPTR,C_POINTER},C_TEXTURE)
--RLAPI Texture2D LoadTexture(const char *fileName);    // Load texture from file into GPU memory (VRAM)

global function LoadTexture(sequence fname)
sequence tex={0,0,0,0,0}
atom mem= allocate(20)
atom pstr=allocate_string(fname)
atom ptr
        ptr = c_func(xLoadTexture,{mem,pstr})
if not equal(ptr,mem) then
    puts(1,"Something ugly happend  in: LoadTexture")
end if
tex[1]=peek4u(mem)
tex[2]=peek4s(mem+4)
tex[3]=peek4s(mem+8)
tex[4]=peek4s(mem+12)
tex[5]=peek4s(mem+16)       
free (pstr)
free (mem)
return tex
end function

--/*
constant xGetMousePosition = define_c_func(ray,"+GetMousePosition",{},C_ULONGLONG)
--*/
--/* */constant xGetMousePosition = define_c_func(ray,"GetMousePosition",{},C_QWORD)

public function GetMousePosition()
sequence result
    result=RegtoV2(c_func(xGetMousePosition,{}))
return result
end function
