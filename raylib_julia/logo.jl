include("raylib.jl")
const s_w = 800
const s_h = 450

WHITE = Color(255,255,255,255)
BLACK = Color(0,0,0,255)
RAYWHITE = Color(245,245,245,255)
JGREEN = Color(56,152,38,255)
JRED = Color(203,60,51,255)
JPURPLE = Color(149,88,178,255)
JBLUE = Color(77,100,174,255)

v1 = Vector2(s_w/2+70,s_h/2)
v2 = Vector2(s_w/2 + 55, s_h/2 + 25)
v3 = Vector2(s_w/2 + 85, s_h/2 + 25 )

InitWindow(s_w,s_h,"raylib [shapes] - raylib logo")
SetTargetFPS(60)
while !WindowShouldClose()
        BeginDrawing()
                ClearBackground(WHITE)
                DrawRectangle(div(s_w,2) - 128, div(s_h,2) - 128,256,256,JBLUE)
                DrawRectangle(div(s_w,2) - 112, div(s_h,2) - 112,224,224,RAYWHITE)
                DrawCircleV(v1 , 12.0, JGREEN)
                DrawCircleV(v2 , 12.0, JRED)
                DrawCircleV(v3 , 12.0, JPURPLE)
                DrawText("raylib.jl",div(s_w,2) - 44, div(s_h,2)+48,40,BLACK)
        EndDrawing()
end
