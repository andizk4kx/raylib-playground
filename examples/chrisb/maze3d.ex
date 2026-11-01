-------------------------------------------------------------------------------- 
-- maze3d.ex : Doom-style first-person random maze (raycaster) 
-- Euphoria 4.1 (32-bit) + EuRayLib5 (Raylib wrapper by Andy P. / Icy Viking) 
-- 
-- Controls:  W/A/S/D = move/strafe     Mouse = look (left/right turns, up/down tilts) 
--            M = cycle map (local / full / off)     R = new maze     ESC = quit 
-- 
-- Wall colours (by the direction the wall FACES, so you always know which way 
-- you are heading, and darker with distance): 
--      North-facing = RED    South-facing = BLUE 
--      East-facing  = GREEN  West-facing  = YELLOW 
-------------------------------------------------------------------------------- 
include ../../raylib64.e 
--/*
include std/rand.e 
--*/ 
constant SW = 1024, SH = 800          -- window size 
constant COLW = 2                     -- pixel width of each ray column (1 = sharper, slower) 
constant NUMCOLS = floor(SW / COLW) 
constant MZ_PI = 3.14159265358979 
constant FOV = 0.66                   -- camera plane length (~66 degree view) 
constant MOVE_SPEED = 3.2             -- cells per second 
constant MOUSE_SENS = 0.0025          -- radians per pixel 
constant PITCH_SENS = 1.0             -- pixels of horizon shift per pixel 
constant MAX_PITCH  = 280 
constant PLAYER_R   = 0.22            -- collision radius 
 
constant mzDX = {1,-1,0,0}, mzDY = {0,0,1,-1} 
 
-- base colours: N, S, E, W 
constant mzFace = { {230,70,55}, {60,115,240}, {65,205,95}, {245,205,55} } 
 
-- ---------------------------------------------------------------- state ------ 
sequence mzGrid = {} 
integer  mzG = 0, mzN = 8, mzLevel = 1 
atom     posX = 1.5, posY = 1.5, ang = 0, pitch = 0 
atom     goalX = 0, goalY = 0 
atom     msgTimer = 0 
integer  mapMode = 1 
 
-- ------------------------------------------------------------- helpers ------- 
-- Colour helper: works whether the wrapper stores colours as {r,g,b,a} 
-- or as a packed 32-bit integer. If your colours break, edit only this. 

constant COLOR_IS_SEQ = sequence(RAYWHITE) 

function mzRGB(integer r, integer g, integer b, integer a = 255) 
    if COLOR_IS_SEQ then 
        return {r, g, b, a} 
    else 
        return r + g * 256 + b * 65536 + a * 16777216 
    end if
end function 
 
function mzAbs(atom x) 
    if x < 0 then return -x end if 
    return x 
end function 
 
function mzMax(integer a, integer b) 
    if a > b then return a end if 
    return b 
end function 
 
function mzMin(integer a, integer b) 
    if a < b then return a end if 
    return b 
end function 
 
-- ------------------------------------------------------ maze generation ------ 
-- Recursive backtracker on an (2n+1)x(2n+1) grid. 1 = wall, 0 = passage. 
-- Cells live on even 1-based indices (2,4,..,2n). 
procedure mzGenerate(integer n) 
    sequence stack, cand, cur 
    integer nx, ny, k 
 
    mzG = 2 * n + 1 
    mzGrid = repeat(repeat(1, mzG), mzG) 
    mzGrid[2][2] = 0 
    stack = {{2, 2}} 
 
    while length(stack) > 0 do 
        cur = stack[$] 
        cand = {} 
        for d = 1 to 4 do 
            nx = cur[1] + mzDX[d] * 2 
            ny = cur[2] + mzDY[d] * 2 
            if nx >= 2 and nx <= mzG - 1 and ny >= 2 and ny <= mzG - 1 then 
                if mzGrid[ny][nx] = 1 then 
                    cand = append(cand, d) 
                end if 
            end if 
        end for 
 
        if length(cand) = 0 then 
            stack = stack[1..$-1] 
        else 
            k  = cand[rand(length(cand))] 
            nx = cur[1] + mzDX[k] * 2 
            ny = cur[2] + mzDY[k] * 2 
            mzGrid[cur[2] + mzDY[k]][cur[1] + mzDX[k]] = 0   -- knock out wall between 
            mzGrid[ny][nx] = 0 
            stack = append(stack, {nx, ny}) 
        end if 
    end while 
end procedure 
 
procedure mzNewLevel() 
    mzGenerate(mzN) 
    posX = 1.5 
    posY = 1.5 
    if mzGrid[2][3] = 0 then 
        ang = 0                 -- face east if open 
    else 
        ang = MZ_PI / 2         -- otherwise face south 
    end if 
    pitch = 0 
    goalX = mzG - 1.5           -- centre of far corner cell 
    goalY = mzG - 1.5 
end procedure 
 
-- ------------------------------------------------------------ collision ------ 
function mzBlocked(atom x, atom y) 
    integer gx, gy 
    gx = floor(x) + 1 
    gy = floor(y) + 1 
    if gx < 1 or gy < 1 or gx > mzG or gy > mzG then 
        return 1 
    end if 
    return mzGrid[gy][gx] 
end function 
 
function mzCanStand(atom x, atom y) 
    if mzBlocked(x - PLAYER_R, y - PLAYER_R) then return 0 end if 
    if mzBlocked(x + PLAYER_R, y - PLAYER_R) then return 0 end if 
    if mzBlocked(x - PLAYER_R, y + PLAYER_R) then return 0 end if 
    if mzBlocked(x + PLAYER_R, y + PLAYER_R) then return 0 end if 
    return 1 
end function 
 
procedure mzMove(atom dx, atom dy)       -- axis-separated => slide along walls 
    if mzCanStand(posX + dx, posY) then posX += dx end if 
    if mzCanStand(posX, posY + dy) then posY += dy end if 
end procedure 
 
-- ------------------------------------------------------------ 3D render ------- 
procedure mzRender() 
    atom dirX, dirY, plX, plY, camX, rdx, rdy 
    atom ddX, ddY, sdX, sdY, perp, wallX, shade 
    integer mx, my, stepX, stepY, side, hit, face, top, h, horizon, lineH 
    integer r, g, b, y0, y1 
    sequence base 
 
    dirX = cos(ang) 
    dirY = sin(ang) 
    plX  = -dirY * FOV 
    plY  =  dirX * FOV 
    horizon = floor(SH / 2 + pitch) 
 
    -- ceiling (dark blue, brighter toward the horizon) 
    for i = 0 to 9 do 
        y0 = floor(horizon * i / 10) 
        y1 = floor(horizon * (i + 1) / 10) 
        DrawRectangle(0, y0, SW, y1 - y0 + 1, mzRGB(16 + i * 3, 18 + i * 3, 40 + i * 5)) 
    end for 
    -- floor (brown, brighter toward the player) 
    for i = 0 to 9 do 
        y0 = horizon + floor((SH - horizon) * i / 10) 
        y1 = horizon + floor((SH - horizon) * (i + 1) / 10) 
        DrawRectangle(0, y0, SW, y1 - y0 + 1, mzRGB(22 + i * 5, 20 + i * 4, 18 + i * 3)) 
    end for 
 
    -- walls: one DDA ray per column 
    for col = 0 to NUMCOLS - 1 do 
        camX = 2 * col / NUMCOLS - 1 
        rdx = dirX + plX * camX 
        rdy = dirY + plY * camX 
 
        mx = floor(posX) 
        my = floor(posY) 
 
        if rdx = 0 then ddX = 1e30 else ddX = mzAbs(1 / rdx) end if 
        if rdy = 0 then ddY = 1e30 else ddY = mzAbs(1 / rdy) end if 
 
        if rdx < 0 then 
            stepX = -1 
            sdX = (posX - mx) * ddX 
        else 
            stepX = 1 
            sdX = (mx + 1 - posX) * ddX 
        end if 
        if rdy < 0 then 
            stepY = -1 
            sdY = (posY - my) * ddY 
        else 
            stepY = 1 
            sdY = (my + 1 - posY) * ddY 
        end if 
 
        hit = 0 
        side = 0 
        while hit = 0 do 
            if sdX < sdY then 
                sdX += ddX 
                mx += stepX 
                side = 0 
            else 
                sdY += ddY 
                my += stepY 
                side = 1 
            end if 
            if mx < 0 or my < 0 or mx >= mzG or my >= mzG then 
                hit = 1 
            elsif mzGrid[my + 1][mx + 1] = 1 then 
                hit = 1 
            end if 
        end while 
 
        if side = 0 then 
            perp = sdX - ddX 
            wallX = posY + perp * rdy 
            if stepX > 0 then face = 4 else face = 3 end if   -- W / E face 
        else 
            perp = sdY - ddY 
            wallX = posX + perp * rdx 
            if stepY > 0 then face = 1 else face = 2 end if   -- N / S face 
        end if 
        if perp < 0.05 then perp = 0.05 end if 
        wallX -= floor(wallX) 
 
        -- distance fog + dark edges between wall blocks 
        shade = 1.2 / (1 + perp * 0.30) 
        if shade > 1 then shade = 1 end if 
        if shade < 0.10 then shade = 0.10 end if 
        if wallX < 0.03 or wallX > 0.97 then shade *= 0.55 end if 
 
        base = mzFace[face] 
        r = floor(base[1] * shade) 
        g = floor(base[2] * shade) 
        b = floor(base[3] * shade) 
 
        lineH = floor(SH / perp) 
        top = horizon - floor(lineH / 2) 
        h = lineH 
        if top < 0 then 
            h += top 
            top = 0 
        end if 
        if top + h > SH then 
            h = SH - top 
        end if 
        if h > 0 then 
            DrawRectangle(col * COLW, top, COLW, h, mzRGB(r, g, b)) 
        end if 
    end for 
end procedure 
 
-- --------------------------------------------------------------- map --------- 
procedure mzDrawMap(integer ox, integer oy, integer tile, integer x0, integer y0, integer x1, integer y1) 
    integer lo, hi, rs, px, py, gcx, gcy 
    sequence wallCol 
 
    wallCol = mzRGB(120, 130, 170) 
    DrawRectangle(ox - 3, oy - 3, (x1 - x0 + 1) * tile + 6, (y1 - y0 + 1) * tile + 6, mzRGB(0, 0, 0, 200)) 
    DrawRectangle(ox, oy, (x1 - x0 + 1) * tile, (y1 - y0 + 1) * tile, mzRGB(18, 18, 28, 230)) 
 
    lo = mzMax(x0, 1) 
    hi = mzMin(x1, mzG) 
    for gy = mzMax(y0, 1) to mzMin(y1, mzG) do 
        rs = 0 
        for gx = lo to hi + 1 do 
            if gx <= hi and mzGrid[gy][gx] = 1 then 
                if rs = 0 then rs = gx end if 
            elsif rs != 0 then 
                DrawRectangle(ox + (rs - x0) * tile, oy + (gy - y0) * tile, (gx - rs) * tile, tile, wallCol) 
                rs = 0 
            end if 
        end for 
    end for 
 
    -- exit (green) 
    gcx = floor(goalX) + 1 
    gcy = floor(goalY) + 1 
    if gcx >= x0 and gcx <= x1 and gcy >= y0 and gcy <= y1 then 
        DrawRectangle(ox + (gcx - x0) * tile, oy + (gcy - y0) * tile, tile, tile, mzRGB(60, 255, 100)) 
    end if 
 
    -- player (red dot + heading line) 
    px = ox + floor((posX - (x0 - 1)) * tile) 
    py = oy + floor((posY - (y0 - 1)) * tile) 
    DrawLine(px, py, px + floor(cos(ang) * tile * 1.6), py + floor(sin(ang) * tile * 1.6), mzRGB(255, 255, 255)) 
    DrawCircle(px, py, tile * 0.35 + 1, mzRGB(255, 60, 60)) 
end procedure 
 
procedure mzDrawMapOverlay() 
    integer cgx, cgy, tile, ox, oy 
    if mapMode = 1 then 
        cgx = floor(posX) + 1 
        cgy = floor(posY) + 1 
        tile = 9 
        ox = SW - 10 - 17 * tile 
        oy = 10 
        mzDrawMap(ox, oy, tile, cgx - 8, cgy - 8, cgx + 8, cgy + 8) 
    elsif mapMode = 2 then 
        tile = floor(700 / mzG) 
        if tile < 2 then tile = 2 end if 
        ox = floor((SW - mzG * tile) / 2) 
        oy = floor((SH - mzG * tile) / 2) 
        mzDrawMap(ox, oy, tile, 1, 1, mzG, mzG) 
    end if 
end procedure 
 
-- --------------------------------------------------------------- main -------- 
InitWindow(SW, SH, "Euphoria Maze - EuRayLib5 raycaster") 
SetTargetFPS(0) 
set_rand(time()) 
mzNewLevel() 
 
integer cx = floor(SW / 2), cy = floor(SH / 2) 
integer warm = 0, mxp, myp 
integer mvF, mvS 
atom dt, spd, _ln, dx, dy, dist 
 
HideCursor() 
SetMousePosition(cx, cy) 
 
while not WindowShouldClose() do 
    dt = GetFrameTime() 
    if dt > 0.1 then dt = 0.1 end if 
 
    -- ---- mouse look (re-centre the mouse every frame) ---- 
    if IsWindowFocused() then 
        mxp = GetMouseX() 
        myp = GetMouseY() 
        if warm > 5 then 
            ang   += (mxp - cx) * MOUSE_SENS 
            pitch -= (myp - cy) * PITCH_SENS 
            if pitch >  MAX_PITCH then pitch =  MAX_PITCH end if 
            if pitch < -MAX_PITCH then pitch = -MAX_PITCH end if 
        else 
            warm += 1 
        end if 
        SetMousePosition(cx, cy) 
    end if 
 
    -- ---- keyboard movement ---- 
    mvF = 0 
    mvS = 0 
    if IsKeyDown(KEY_W) then mvF += 1 end if 
    if IsKeyDown(KEY_S) then mvF -= 1 end if 
    if IsKeyDown(KEY_D) then mvS += 1 end if 
    if IsKeyDown(KEY_A) then mvS -= 1 end if 
 
    if mvF != 0 or mvS != 0 then 
        _ln = sqrt(mvF * mvF + mvS * mvS) 
        spd = MOVE_SPEED * dt 
        dx  = (cos(ang) * mvF - sin(ang) * mvS) / _ln * spd 
        dy  = (sin(ang) * mvF + cos(ang) * mvS) / _ln * spd 
        mzMove(dx, dy) 
    end if 
 
    if IsKeyPressed(KEY_M) then mapMode = remainder(mapMode + 1, 3) end if 
    if IsKeyPressed(KEY_R) then mzNewLevel() end if 
 
    -- ---- reached the exit? ---- 
    dist = sqrt((goalX - posX) * (goalX - posX) + (goalY - posY) * (goalY - posY)) 
    if dist < 0.7 then 
        mzLevel += 1 
        mzN = mzMin(8 + (mzLevel - 1) * 2, 24) 
        mzNewLevel() 
        msgTimer = 2.5 
    end if 
    if msgTimer > 0 then msgTimer -= dt end if 
 
    -- ---- draw ---- 
    BeginDrawing() 
        ClearBackground(mzRGB(0, 0, 0)) 
        mzRender() 
        mzDrawMapOverlay() 
 
        -- crosshair 
        DrawRectangle(cx - 8, cy - 1, 16, 2, mzRGB(255, 255, 255, 160)) 
        DrawRectangle(cx - 1, cy - 8, 2, 16, mzRGB(255, 255, 255, 160)) 
 
        DrawFPS(10, 10) 
        DrawText(sprintf("Level %d   Exit: %.1f m", {mzLevel, dist}), 10, 36, 20, mzRGB(255, 255, 255)) 
        DrawText("WASD move | Mouse look | M map | R new maze | ESC quit", 10, SH - 28, 18, mzRGB(220, 220, 220)) 
        if msgTimer > 0 then 
            DrawText("You escaped! Next maze...", cx - 170, 90, 32, mzRGB(255, 230, 80)) 
        end if 
    EndDrawing() 
end while 
 
ShowCursor() 
CloseWindow() 
 
