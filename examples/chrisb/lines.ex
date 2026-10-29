-- lines.ex 
-- Lines screensaver: 1024x800 window, bouncing line with fading trail 
-- Requires: 32-bit Euphoria 4.x and Euraylib 5 (Andy P / Icy Viking) 
 
include std/rand.e 
include std/math.e 
include ../../raylib64.e 
 
constant SCREEN_W = 1024 
constant SCREEN_H = 800 
constant TRAIL_LENGTH = 80      -- how many old lines stay on screen 
constant MAX_SPEED = 7 
 
set_rand(time()) 
 
-- p = {x1, y1, x2, y2}  : the two endpoints of the current line 
sequence p = { 
    rand(SCREEN_W) - 1, rand(SCREEN_H) - 1, 
    rand(SCREEN_W) - 1, rand(SCREEN_H) - 1 
} 
 
-- v = velocity of each coordinate, random speed and direction 
sequence v = repeat(0, 4) 
for i = 1 to 4 do 
    v[i] = rand_range(2, MAX_SPEED) * (rand(2) * 2 - 3)   -- (rand(2)*2-3) is -1 or +1 
end for 
 
sequence history = {}     -- each entry: {x1, y1, x2, y2, r, g, b} 
atom hue = 0              -- drives the colour cycling 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Lines") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    -- move the endpoints, bouncing off the edges 
    for i = 1 to 4 do 
        integer limit 
        if remainder(i, 2) = 1 then 
            limit = SCREEN_W - 1   -- x coordinates 
        else 
            limit = SCREEN_H - 1   -- y coordinates 
        end if 
 
        p[i] += v[i] 
 
        if p[i] < 0 then 
            p[i] = 0 
            v[i] = -v[i] 
        elsif p[i] > limit then 
            p[i] = limit 
            v[i] = -v[i] 
        end if 
    end for 
 
    -- smoothly cycle the colour 
    hue += 0.02 
    integer r = floor(127.5 + 127.5 * sin(hue)) 
    integer g = floor(127.5 + 127.5 * sin(hue + 2.094)) 
    integer b = floor(127.5 + 127.5 * sin(hue + 4.188)) 
 
    -- add this frame's line to the trail, drop the oldest if it's full 
    history = append(history, {p[1], p[2], p[3], p[4], r, g, b}) 
    if length(history) > TRAIL_LENGTH then 
        history = history[2..$] 
    end if 
 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
    -- draw oldest to newest, with newer lines more opaque 
    for i = 1 to length(history) do 
        sequence ln = history[i] 
        integer alpha = floor(255 * i / length(history)) 
        DrawLine(ln[1], ln[2], ln[3], ln[4], {ln[5], ln[6], ln[7], alpha}) 
    end for 
 
    EndDrawing() 
 
end while 
 
CloseWindow() 