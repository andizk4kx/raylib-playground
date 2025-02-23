include("raylib.jl")
const s_w = 800
const s_h = 450
WHITE = Color(255,255,255,255)
BLACK = Color(0,0,0,255)
RAYWHITE = Color(245,245,245,255)
v1 = Vector2(s_w/2+70,s_h/2)
v2 = Vector2(s_w/2 + 55, s_h/2 + 25)
v3 = Vector2(s_w/2 + 85, s_h/2 + 25 )

InitWindow(s_w,s_h,"raylib [shapes] - raylib logo")
SetTargetFPS(60)
while !WindowShouldClose()
	BeginDrawing()
		ClearBackground(WHITE)
		DrawRectangle(s_w÷2 - 128, s_h÷2 - 128,256,256,Color(77,100,174,255))
		DrawRectangle(s_w÷2 - 112, s_h÷2 - 112,224,224,RAYWHITE)
		DrawCircleV(v1 , 12.0, Color(56,152,38,255))
		DrawCircleV(v2 , 12.0, Color(203,60,51,255))
		DrawCircleV(v3 , 12.0, Color(149,88,178,255))
		DrawText("raylib.jl",div(s_w,2) - 44, s_h÷2+48,40,BLACK)
	EndDrawing()
end
