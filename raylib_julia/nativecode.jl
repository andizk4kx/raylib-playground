include("raylib.jl")
using InteractiveUtils #Not needed in REPL

screenWidth = 800
screenHeight = 450
    
v1= Vector2( screenWidth/4.0 *3.0, 80.0 )
v2= Vector2( screenWidth/4.0 *3.0 - 60.0, 150.0 )
v3= Vector2( screenWidth/4.0 *3.0 + 60.0, 150.0 )
#@code_native(DrawTriangle(v1,v2,v3, VIOLET))
#@code_native(DrawCircleV(v1,10.0,WHITE))
@code_native(DrawCircleV(Vector2(10.0,10.0),20.0,Color(64,128,192,255)))
