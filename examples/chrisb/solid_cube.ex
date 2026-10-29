-- solid_cube.ex 
-- Rotating solid cube, 1024x800 window, six differently coloured opaque faces 
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
 
-- the 6 faces, each as 4 indexes into verts (in order around the face) 
constant faces = { 
    {1, 2, 3, 4},   -- back 
    {5, 6, 7, 8},   -- front 
    {1, 4, 8, 5},   -- left 
    {2, 3, 7, 6},   -- right 
    {1, 2, 6, 5},   -- top 
    {4, 3, 7, 8}    -- bottom 
} 
 
-- one colour per face {r, g, b, a} 
constant face_colours = { 
    {230,  40,  40, 255},   -- red 
    { 40, 200,  60, 255},   -- green 
    { 50,  90, 240, 255},   -- blue 
    {245, 220,  40, 255},   -- yellow 
    {220,  60, 220, 255},   -- magenta 
    { 40, 220, 220, 255}    -- cyan 
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
 
-- draw a filled triangle, fixing the vertex order so raylib always accepts it 
-- (raylib only draws triangles whose points run counter-clockwise on screen) 
procedure draw_tri(sequence a, sequence b, sequence c, sequence col) 
    atom cross = (b[1] - a[1]) * (c[2] - a[2]) - (b[2] - a[2]) * (c[1] - a[1]) 
    if cross > 0 then 
        DrawTriangle(a, c, b, col) 
    else 
        DrawTriangle(a, b, c, col) 
    end if 
end procedure 
 
atom ax = 0 
atom ay = 0 
atom az = 0 
 
-- the camera sits on the negative Z side, in the same units as the cube corners 
constant cam_z = -CAMERA_DIST / CUBE_SIZE 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Solid Cube") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    ax += 0.011 
    ay += 0.017 
    az += 0.007 
 
    -- rotate all 8 corners, then project them 
    sequence rotated = repeat({0, 0, 0}, length(verts)) 
    sequence pts = repeat({0, 0}, length(verts)) 
    for i = 1 to length(verts) do 
        rotated[i] = rotate_point(verts[i], ax, ay, az) 
        pts[i] = project_point(rotated[i]) 
    end for 
 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
    for f = 1 to length(faces) do 
        sequence idx = faces[f] 
 
        -- face centre = average of its 4 rotated corners. 
        -- For a cube centred on the origin this is also the outward normal. 
        atom cx = 0 
        atom cy = 0 
        atom cz = 0 
        for k = 1 to 4 do 
            cx += rotated[idx[k]][1] 
            cy += rotated[idx[k]][2] 
            cz += rotated[idx[k]][3] 
        end for 
        cx /= 4 
        cy /= 4 
        cz /= 4 
 
        -- the face is visible if its normal points towards the camera: 
        -- dot(normal, camera_position - face_centre) > 0 
        atom facing = cx * (0 - cx) + cy * (0 - cy) + cz * (cam_z - cz) 
 
        if facing > 0 then 
            sequence p1 = pts[idx[1]] 
            sequence p2 = pts[idx[2]] 
            sequence p3 = pts[idx[3]] 
            sequence p4 = pts[idx[4]] 
 
            -- a quad is two triangles 
            draw_tri(p1, p2, p3, face_colours[f]) 
            draw_tri(p1, p3, p4, face_colours[f]) 
 
            -- thin black outline so the edges stand out 
            DrawLine(p1[1], p1[2], p2[1], p2[2], BLACK) 
            DrawLine(p2[1], p2[2], p3[1], p3[2], BLACK) 
            DrawLine(p3[1], p3[2], p4[1], p4[2], BLACK) 
            DrawLine(p4[1], p4[2], p1[1], p1[2], BLACK) 
        end if 
    end for 
 
    EndDrawing() 
 
end while 
 
CloseWindow() 
 
