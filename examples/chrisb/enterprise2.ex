-- enterprise2.ex 
-- Wireframe starship (Constitution-class refit style) with starfield and keyboard control 
-- 1024x800 window 
-- Requires: 32-bit Euphoria 4.x and Euraylib 5 (Andy P / Icy Viking) 
-- 
-- Controls: 
--   Arrow keys : pitch (up/down) and yaw (left/right) 
--   Z / X      : roll 
--   SPACE      : turn the automatic spin on/off 
--   R          : reset the orientation 

--/* 
include std/rand.e 
--*/

include ../../raylib64.e 
 
constant SCREEN_W = 1024 
constant SCREEN_H = 800 
constant CENTRE_X = SCREEN_W / 2 
constant CENTRE_Y = SCREEN_H / 2 
 
constant MODEL_SCALE = 150    -- pixels per model unit 
constant CAMERA_DIST = 1100   -- distance from the "camera" to the model centre 
constant FOCAL = 1100         -- perspective strength 
constant TWO_PI = 6.283185307179586   -- own constant, avoids clashing with PI in raylib.e 
 
constant TURN_RATE = 0.03     -- radians per frame while a key is held 
 
-- starfield settings 
constant NUM_STARS = 300 
constant STAR_FAR = 1000      -- how far away new stars appear 
constant STAR_NEAR = 20       -- stars closer than this are recycled 
constant STAR_SPEED = 3       -- how fast the stars fly past 
constant STAR_FOCAL = 500 
 
set_rand(time()) 
 
------------------------------------------------------------------ 
-- Model building helpers 
------------------------------------------------------------------ 
sequence verts = {}                  -- each: {x, y, z} 
sequence edges = {}                  -- each: {vertex_a, vertex_b, {r, g, b}} 
sequence cur_col = {190, 205, 235}   -- colour given to new edges 
 
function add_v(atom x, atom y, atom z) 
    verts = append(verts, {x, y, z}) 
    return length(verts) 
end function 
 
procedure add_e(integer a, integer b) 
    edges = append(edges, {a, b, cur_col}) 
end procedure 
 
-- Spin a profile around an axis to make a ring-and-spoke surface. 
-- axis  : 2 = spin around Y (vertical), 3 = spin around Z (lengthwise) 
-- shape : list of {radius, position_along_axis}, in order along the axis 
-- A radius of 0 makes a single point (a nose or tail tip). 
-- A shape with just one entry makes a single ring (used for accent lines). 
-- spoke_step: draw a lengthwise/radial line every N segments 
procedure add_lathe(integer axis, atom cx, atom cy, atom cz, 
                    sequence shape, integer segs, integer spoke_step) 
    sequence prev = {} 
 
    for p = 1 to length(shape) do 
        atom r = shape[p][1] 
        atom along = shape[p][2] 
        sequence ring = repeat(0, segs) 
 
        if r = 0 then 
            if axis = 2 then 
                ring = repeat(add_v(cx, cy + along, cz), segs) 
            else 
                ring = repeat(add_v(cx, cy, cz + along), segs) 
            end if 
        else 
            for s = 1 to segs do 
                atom a = TWO_PI * (s - 1) / segs 
                atom u = r * cos(a) 
                atom w = r * sin(a) 
                if axis = 2 then 
                    ring[s] = add_v(cx + u, cy + along, cz + w) 
                else 
                    ring[s] = add_v(cx + u, cy + w, cz + along) 
                end if 
            end for 
 
            -- the ring itself 
            for s = 1 to segs do 
                add_e(ring[s], ring[remainder(s, segs) + 1]) 
            end for 
        end if 
 
        -- spokes joining this ring to the previous one 
        if p > 1 then 
            for s = 1 to segs by spoke_step do 
                if prev[s] != ring[s] then 
                    add_e(prev[s], ring[s]) 
                end if 
            end for 
        end if 
 
        prev = ring 
    end for 
end procedure 
 
------------------------------------------------------------------ 
-- Build the ship (nose points towards +Z) 
------------------------------------------------------------------ 
 
-- Primary hull (saucer): {radius, height}, top to bottom 
cur_col = {190, 205, 235} 
add_lathe(2, 0, 0, 0.9, 
    {{0.0, 0.20}, {0.15, 0.20}, {0.30, 0.17}, {0.45, 0.155}, {0.60, 0.12}, 
     {0.80, 0.08}, {0.95, 0.03}, {1.0, 0.0}, {0.95, -0.03}, {0.80, -0.07}, 
     {0.60, -0.09}, {0.40, -0.10}, {0.20, -0.11}, {0.0, -0.11}}, 
    40, 2) 
 
-- Window-light rings around the saucer edge 
cur_col = {255, 235, 150} 
add_lathe(2, 0, 0, 0.9, {{0.97, 0.025}}, 40, 1) 
add_lathe(2, 0, 0, 0.9, {{0.97, -0.025}}, 40, 1) 
 
-- Bridge dome on top of the saucer 
cur_col = {255, 230, 140} 
add_lathe(2, 0, 0.20, 0.9, 
    {{0.0, 0.09}, {0.06, 0.085}, {0.10, 0.05}, {0.13, 0.0}}, 
    12, 3) 
 
-- Sensor dome underneath the saucer 
cur_col = {120, 220, 255} 
add_lathe(2, 0, -0.11, 0.9, 
    {{0.12, 0.0}, {0.07, -0.05}, {0.0, -0.07}}, 
    12, 3) 
 
-- Secondary (engineering) hull: {radius, z} 
cur_col = {170, 185, 215} 
add_lathe(3, 0, -0.5, -0.4, 
    {{0.0, -0.9}, {0.08, -0.88}, {0.14, -0.80}, {0.17, -0.70}, {0.18, -0.40}, 
     {0.18, 0.0}, {0.17, 0.2}, {0.14, 0.35}, {0.10, 0.45}}, 
    16, 4) 
 
-- Hull accent rings 
cur_col = {255, 235, 150} 
add_lathe(3, 0, -0.5, -0.4, {{0.185, -0.55}}, 16, 1) 
add_lathe(3, 0, -0.5, -0.4, {{0.185, 0.15}}, 16, 1) 
 
-- Deflector dish at the front of the secondary hull 
cur_col = {120, 220, 255} 
add_lathe(3, 0, -0.5, -0.4, 
    {{0.10, 0.45}, {0.07, 0.42}, {0.03, 0.40}, {0.0, 0.395}}, 
    12, 3) 
 
-- Neck joining the secondary hull to the underside of the saucer 
cur_col = {170, 185, 215} 
integer n1 = add_v(-0.07, -0.33, -0.35) 
integer n2 = add_v( 0.07, -0.33, -0.35) 
integer n3 = add_v( 0.07, -0.33, -0.10) 
integer n4 = add_v(-0.07, -0.33, -0.10) 
integer t1 = add_v(-0.10, -0.07,  0.10) 
integer t2 = add_v( 0.10, -0.07,  0.10) 
integer t3 = add_v( 0.10, -0.10,  0.50) 
integer t4 = add_v(-0.10, -0.10,  0.50) 
add_e(n1, n2) 
add_e(n2, n3) 
add_e(n3, n4) 
add_e(n4, n1) 
add_e(t1, t2) 
add_e(t2, t3) 
add_e(t3, t4) 
add_e(t4, t1) 
add_e(n1, t1) 
add_e(n2, t2) 
add_e(n3, t3) 
add_e(n4, t4) 
 
-- Two nacelles with pylons (sx = -1 is one side, +1 is the other) 
for sx = -1 to 1 by 2 do 
    -- nacelle body 
    cur_col = {90, 170, 255} 
    add_lathe(3, sx * 0.7, 0.12, -0.75, 
        {{0.0, -0.78}, {0.05, -0.76}, {0.085, -0.70}, {0.10, -0.60}, 
         {0.10, 0.0}, {0.10, 0.40}}, 
        16, 4) 
 
    -- blue accent rings along the nacelle 
    cur_col = {120, 220, 255} 
    add_lathe(3, sx * 0.7, 0.12, -0.75, {{0.104, -0.35}}, 16, 1) 
    add_lathe(3, sx * 0.7, 0.12, -0.75, {{0.104, 0.05}}, 16, 1) 
 
    -- glowing red front dome (Bussard collector) 
    cur_col = {255, 90, 70} 
    add_lathe(3, sx * 0.7, 0.12, -0.35, 
        {{0.10, 0.0}, {0.09, 0.08}, {0.065, 0.17}, {0.035, 0.25}, {0.0, 0.30}}, 
        16, 4) 
 
    -- pylon from the secondary hull up to the nacelle 
    cur_col = {170, 185, 215} 
    integer pa = add_v(sx * 0.1, -0.36, -1.05) 
    integer pb = add_v(sx * 0.1, -0.36, -0.70) 
    integer pc = add_v(sx * 0.7,  0.03, -1.05) 
    integer pd = add_v(sx * 0.7,  0.03, -0.70) 
    add_e(pa, pb) 
    add_e(pc, pd) 
    add_e(pa, pc) 
    add_e(pb, pd) 
    add_e(pa, pd) 
end for 
 
-- Centre the whole model on the origin so it spins about its middle 
sequence lo = {1e30, 1e30, 1e30} 
sequence hi = {-1e30, -1e30, -1e30} 
for i = 1 to length(verts) do 
    for k = 1 to 3 do 
        if verts[i][k] < lo[k] then lo[k] = verts[i][k] end if 
        if verts[i][k] > hi[k] then hi[k] = verts[i][k] end if 
    end for 
end for
--/* 
sequence mid = (lo + hi) / 2 
--*/

--/**/ sequence mid=sq_div((sq_add(lo,hi)),2)
--/*
for i = 1 to length(verts) do 
    verts[i] -= mid 
end for 
--*/
--/**/for i = 1 to length(verts) do 
--/**/  verts[i] = sq_sub(verts[i],mid) 
--/**/end for  
------------------------------------------------------------------ 
-- 3D maths (3x3 rotation matrices, so steering always feels the same 
-- no matter which way the ship is currently facing) 
------------------------------------------------------------------ 
 
function m3_mul(sequence a, sequence b) 
    sequence r = repeat(repeat(0, 3), 3) 
    for i = 1 to 3 do 
        for j = 1 to 3 do 
            r[i][j] = a[i][1] * b[1][j] + a[i][2] * b[2][j] + a[i][3] * b[3][j] 
        end for 
    end for 
    return r 
end function 
 
function m3_rotx(atom t) 
    return {{1, 0, 0}, {0, cos(t), -sin(t)}, {0, sin(t), cos(t)}} 
end function 
 
function m3_roty(atom t) 
    return {{cos(t), 0, sin(t)}, {0, 1, 0}, {-sin(t), 0, cos(t)}} 
end function 
 
function m3_rotz(atom t) 
    return {{cos(t), -sin(t), 0}, {sin(t), cos(t), 0}, {0, 0, 1}} 
end function 
 
function m3_apply(sequence m, sequence v) 
    return { 
        m[1][1] * v[1] + m[1][2] * v[2] + m[1][3] * v[3], 
        m[2][1] * v[1] + m[2][2] * v[2] + m[2][3] * v[3], 
        m[3][1] * v[1] + m[3][2] * v[2] + m[3][3] * v[3] 
    } 
end function 
 
-- project a 3D point onto the screen (model +Y is up, screen Y is down) 
function project_point(sequence v) 
    atom scale = FOCAL / (CAMERA_DIST + v[3] * MODEL_SCALE) 
    integer sx = floor(CENTRE_X + v[1] * MODEL_SCALE * scale) 
    integer sy = floor(CENTRE_Y - v[2] * MODEL_SCALE * scale) 
    return {sx, sy} 
end function 
 
------------------------------------------------------------------ 
-- Starfield 
------------------------------------------------------------------ 
function new_star(integer at_far_end) 
    integer z 
    if at_far_end then 
        z = STAR_FAR 
    else 
        z = rand_range(STAR_NEAR, STAR_FAR) 
    end if 
    return {rand_range(-1200, 1200), rand_range(-1000, 1000), z} 
end function 
 
sequence stars = repeat({0, 0, 0}, NUM_STARS) 
for i = 1 to NUM_STARS do 
    stars[i] = new_star(0) 
end for 
 
procedure draw_stars() 
    for i = 1 to NUM_STARS do 
        stars[i][3] -= STAR_SPEED 
 
        if stars[i][3] < STAR_NEAR then 
            stars[i] = new_star(1) 
        end if 
 
        integer sx = floor(CENTRE_X + stars[i][1] * STAR_FOCAL / stars[i][3]) 
        integer sy = floor(CENTRE_Y + stars[i][2] * STAR_FOCAL / stars[i][3]) 
 
        if sx < 0 or sx >= SCREEN_W - 1 or sy < 0 or sy >= SCREEN_H - 1 then 
            -- flew off the edge of the screen, send it back to the distance 
            stars[i] = new_star(1) 
        else 
            -- nearer stars are brighter 
            integer b = floor(255 * (1 - stars[i][3] / STAR_FAR)) 
            if b < 40 then b = 40 end if 
            sequence col = {b, b, b, 255} 
 
            DrawPixel(sx, sy, col) 
            if b > 170 then 
                -- the nearest stars are drawn as little 2x2 squares 
                DrawPixel(sx + 1, sy, col) 
                DrawPixel(sx, sy + 1, col) 
                DrawPixel(sx + 1, sy + 1, col) 
            end if 
        end if 
    end for 
end procedure 
 
------------------------------------------------------------------ 
-- Main program 
------------------------------------------------------------------ 
sequence orient = m3_rotx(0.4)    -- current orientation of the ship 
integer auto_spin = 1 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Wireframe Starship") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    -- ---- keyboard ---- 
    if IsKeyPressed(KEY_SPACE) then 
        auto_spin = not auto_spin 
    end if 
 
    if IsKeyPressed(KEY_R) then 
        orient = m3_rotx(0.4) 
    end if 
 
    atom dx = 0 
    atom dy = 0 
    atom dz = 0 
 
    if auto_spin then 
        dx = 0.011 
        dy = 0.017 
        dz = 0.007 
    end if 
 
    if IsKeyDown(KEY_UP)    then dx -= TURN_RATE end if 
    if IsKeyDown(KEY_DOWN)  then dx += TURN_RATE end if 
    if IsKeyDown(KEY_LEFT)  then dy -= TURN_RATE end if 
    if IsKeyDown(KEY_RIGHT) then dy += TURN_RATE end if 
    if IsKeyDown(KEY_Z)     then dz += TURN_RATE end if 
    if IsKeyDown(KEY_X)     then dz -= TURN_RATE end if 
 
    -- turn the ship a small step about the screen's X, Y and Z axes 
    orient = m3_mul(m3_rotz(dz), m3_mul(m3_roty(dy), m3_mul(m3_rotx(dx), orient))) 
 
    -- ---- transform the model ---- 
    sequence rotated = repeat({0, 0, 0}, length(verts)) 
    sequence pts = repeat({0, 0}, length(verts)) 
    for i = 1 to length(verts) do 
        rotated[i] = m3_apply(orient, verts[i]) 
        pts[i] = project_point(rotated[i]) 
    end for 
 
    -- ---- draw ---- 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
    draw_stars() 
 
    for i = 1 to length(edges) do 
        integer ia = edges[i][1] 
        integer ib = edges[i][2] 
        sequence c = edges[i][3] 
 
        -- dim edges that are further from the camera (+Z is away from us) 
        atom zavg = (rotated[ia][3] + rotated[ib][3]) / 2 
        atom f = 0.65 - 0.35 * zavg / 1.9 
        if f < 0.25 then f = 0.25 end if 
        if f > 1 then f = 1 end if 
 
        DrawLine(pts[ia][1], pts[ia][2], pts[ib][1], pts[ib][2], 
                 {floor(c[1] * f), floor(c[2] * f), floor(c[3] * f), 255}) 
    end for 
 
    DrawText("Arrows: steer   Z/X: roll   SPACE: auto-spin   R: reset", 
             10, 10, 18, {150, 160, 185, 255}) 
 
    EndDrawing() 
 
end while 
 
CloseWindow() 
 
