--file: BasicWin.ex
include raylib.e

constant Width = 800
constant Height = 600

InitWindow(Width,Height,"Simple Window")

SetTargetFPS(60)

Vector2 pos =new()
pos.x=Width/2.5
pos.y=Height/2.5

while not WindowShouldClose() do
        BeginDrawing()
        ClearBackground(BLUE)
        DrawCircleV(pos,100,RED)
        DrawText("Simple Window Program",Width /2.5, Height /2.5 ,20,YELLOW)
        
        EndDrawing()
end while

CloseWindow()

