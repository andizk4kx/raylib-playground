-- cube.ex 
-- Rotating wireframe cube, 1024x800 window, colour-cycling edges 
-- Requires: 32-bit Euphoria 4.x and Euraylib 5 (Andy P / Icy Viking) 
--/* 
include std/math.e 
--*/
include ../../raylib64.e 
 
constant SCREEN_W = 1024 
constant SCREEN_H = 800 
constant CENTRE_X = SCREEN_W / 2 
constant CENTRE_Y = SCREEN_H / 2 
 
constant CUBE_SIZE = 180      -- half the length of a cube edge, in pixels 
constant CAMERA_DIST = 700    -- distance from the "camera" to the cube centre 
constant FOCAL = 700          -- perspective strength 
 
-- the 8 corners of a cube centred on the origin 
constant verts = { 
    {-1, -1, -1}, { 1, -1, -1}, { 1,  1, -1}, {-1,  1, -1}, 
    {-1, -1,  1}, { 1, -1,  1}, { 1,  1,  1}, {-1,  1,  1} 
} 
 
-- the 12 edges, as pairs of indexes into verts 
constant edges = { 
    {1, 2}, {2, 3}, {3, 4}, {4, 1},     -- back face 
    {5, 6}, {6, 7}, {7, 8}, {8, 5},     -- front face 
    {1, 5}, {2, 6}, {3, 7}, {4, 8}      -- connecting edges 
} 
 
-- rotate a point around the X, then Y, then Z axis 
function rotate_point(sequence v, atom ax, atom ay, atom az) 
    atom x = v[1] 
    atom y = v[2] 
    atom z = v[3] 
    atom t 
 
    -- around X 
    t = y * cos(ax) - z * sin(ax) 
    z = y * sin(ax) + z * cos(ax) 
    y = t 
 
    -- around Y 
    t = x * cos(ay) + z * sin(ay) 
    z = -x * sin(ay) + z * cos(ay) 
    x = t 
 
    -- around Z 
    t = x * cos(az) - y * sin(az) 
    y = x * sin(az) + y * cos(az) 
    x = t 
 
    return {x, y, z} 
end function 
 
-- project a 3D point onto the 2D screen, returns {screen_x, screen_y} 
function project_point(sequence v) 
    atom scale = FOCAL / (CAMERA_DIST + v[3] * CUBE_SIZE) 
    integer sx = floor(CENTRE_X + v[1] * CUBE_SIZE * scale) 
    integer sy = floor(CENTRE_Y + v[2] * CUBE_SIZE * scale) 
    return {sx, sy} 
end function 
 
-- turn a hue angle (radians) into an {r, g, b, a} colour 
function hue_colour(atom h) 
    integer r = floor(127.5 + 127.5 * sin(h)) 
    integer g = floor(127.5 + 127.5 * sin(h + 2.094)) 
    integer b = floor(127.5 + 127.5 * sin(h + 4.188)) 
    return {r, g, b, 255} 
end function 
 
atom ax = 0 
atom ay = 0 
atom az = 0 
atom hue = 0 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Rotating Cube") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    -- advance the rotation angles (different speeds look more natural) 
    ax += 0.011 
    ay += 0.017 
    az += 0.007 
    hue += 0.03 
 
    -- rotate and project all 8 corners 
    sequence pts = repeat({0, 0}, length(verts)) 
    for i = 1 to length(verts) do 
        pts[i] = project_point(rotate_point(verts[i], ax, ay, az)) 
    end for 
 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
    -- draw each edge, each with its own offset in the colour cycle 
    for i = 1 to length(edges) do 
        sequence a = pts[edges[i][1]] 
        sequence b = pts[edges[i][2]] 
        sequence col = hue_colour(hue + i * 0.5) 
 
        -- draw each line three times with 1-pixel offsets to make it thicker 
        DrawLine(a[1],     a[2],     b[1],     b[2],     col) 
        DrawLine(a[1] + 1, a[2],     b[1] + 1, b[2],     col) 
        DrawLine(a[1],     a[2] + 1, b[1],     b[2] + 1, col) 
    end for 
 
    EndDrawing() 
 
end while 
 
CloseWindow() 
