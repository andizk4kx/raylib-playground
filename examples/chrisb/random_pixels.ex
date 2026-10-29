-- random_pixels.ex 
-- Draws random pixels in random colours on an 800x600 window 
-- Requires: 32-bit Euphoria 4.x and Euraylib 5 (Andy P / Icy Viking) 
--/* 
include std/rand.e 
--*/
include ../../raylib64.e 
 
constant SCREEN_W = 800 
constant SCREEN_H = 600 
constant PIXELS_PER_FRAME = 10000 
 
set_rand(time())   -- seed the random number generator 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Random Pixels") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
    for i = 1 to PIXELS_PER_FRAME do 
        -- random position (raylib screen coords start at 0) 
        integer x = rand(SCREEN_W) - 1 
        integer y = rand(SCREEN_H) - 1 
 
        -- random colour {r, g, b, a} 
        sequence colour = {rand(256) - 1, rand(256) - 1, rand(256) - 1, 255} 
 
        DrawPixel(x, y, colour) 
    end for 
 
    EndDrawing() 
 
end while 
 
CloseWindow() 
