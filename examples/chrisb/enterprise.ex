-- enterprise.ex 
-- Rotating wireframe starship, 1024x800 window 
-- Requires: 32-bit Euphoria 4.x and Euraylib 5 (Andy P / Icy Viking) 
 
include ../../raylib64.e 
 
constant SCREEN_W = 1024 
constant SCREEN_H = 800 
constant CENTRE_X = SCREEN_W / 2 
constant CENTRE_Y = SCREEN_H / 2 
 
constant MODEL_SCALE = 150    -- pixels per model unit 
constant CAMERA_DIST = 1100   -- distance from the "camera" to the model centre 
constant FOCAL = 1100         -- perspective strength 
constant TWO_PI = 6.283185307179586   -- own constant, avoids clashing with PI in raylib.e 
 
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
 
-- Saucer section: {radius, height}, top to bottom 
cur_col = {190, 205, 235} 
add_lathe(2, 0, 0, 0.9, 
    {{0.0, 0.17}, {0.25, 0.17}, {0.5, 0.13}, {0.8, 0.07}, {1.0, 0.0}, 
     {0.8, -0.06}, {0.5, -0.09}, {0.25, -0.1}, {0.0, -0.1}}, 
    32, 2) 
 
-- Bridge dome on top of the saucer 
cur_col = {255, 230, 140} 
add_lathe(2, 0, 0.17, 0.9, 
    {{0.0, 0.1}, {0.08, 0.07}, {0.12, 0.0}}, 
    12, 3) 
 
-- Secondary (engineering) hull: {radius, z} 
cur_col = {170, 185, 215} 
add_lathe(3, 0, -0.5, -0.4, 
    {{0.0, -0.9}, {0.1, -0.85}, {0.17, -0.7}, {0.17, 0.3}, 
     {0.12, 0.5}, {0.0, 0.6}}, 
    16, 4) 
 
-- Neck joining the secondary hull to the underside of the saucer 
integer n1 = add_v(-0.07, -0.345, -0.35) 
integer n2 = add_v( 0.07, -0.345, -0.35) 
integer n3 = add_v( 0.07, -0.345, -0.10) 
integer n4 = add_v(-0.07, -0.345, -0.10) 
integer t1 = add_v(-0.10, -0.07,  0.10) 
integer t2 = add_v( 0.10, -0.07,  0.10) 
integer t3 = add_v( 0.10, -0.095, 0.50) 
integer t4 = add_v(-0.10, -0.095, 0.50) 
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
        {{0.0, -0.78}, {0.08, -0.72}, {0.1, -0.6}, {0.1, 0.4}}, 
        12, 3) 
 
    -- glowing red front dome 
    cur_col = {255, 90, 70} 
    add_lathe(3, sx * 0.7, 0.12, -0.35, 
        {{0.1, 0.0}, {0.085, 0.12}, {0.05, 0.22}, {0.0, 0.3}}, 
        12, 3) 
 
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
sequence mid = (lo + hi) / 2 
for i = 1 to length(verts) do 
    verts[i] -= mid 
end for 
 
------------------------------------------------------------------ 
-- 3D maths 
------------------------------------------------------------------ 
 
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
 
-- project a 3D point onto the screen (model +Y is up, screen Y is down) 
function project_point(sequence v) 
    atom scale = FOCAL / (CAMERA_DIST + v[3] * MODEL_SCALE) 
    integer sx = floor(CENTRE_X + v[1] * MODEL_SCALE * scale) 
    integer sy = floor(CENTRE_Y - v[2] * MODEL_SCALE * scale) 
    return {sx, sy} 
end function 
 
------------------------------------------------------------------ 
-- Main program 
------------------------------------------------------------------ 
atom ax = 0.4 
atom ay = 0 
atom az = 0 
 
InitWindow(SCREEN_W, SCREEN_H, "Euraylib 5 - Wireframe Starship") 
SetTargetFPS(60) 
 
while not WindowShouldClose() do 
 
    -- spin on all three axes at different speeds 
    ax += 0.011 
    ay += 0.017 
    az += 0.007 
 
    sequence rotated = repeat({0, 0, 0}, length(verts)) 
    sequence pts = repeat({0, 0}, length(verts)) 
    for i = 1 to length(verts) do 
        rotated[i] = rotate_point(verts[i], ax, ay, az) 
        pts[i] = project_point(rotated[i]) 
    end for 
 
    BeginDrawing() 
    ClearBackground(BLACK) 
 
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
 
    EndDrawing() 
 
end while 
 
CloseWindow() 
 
 