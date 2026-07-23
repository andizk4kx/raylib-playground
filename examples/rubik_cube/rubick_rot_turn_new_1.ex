include ..\..\raylib64.e

constant screenWidth  = 800
constant screenHeight = 600

InitWindow(screenWidth, screenHeight, "Rubik's cube")

-- Camera position in polar coordinate system (Radius, Horizontal Angle, Vertical Angle)
atom radius = 16.0
atom angleH = 0.785   -- approx. 45 degrees initial horizontal angle
atom angleV = 0.615   -- initial vertical angle for default isometric view
atom speed  = 0.05    -- rotation speed

-- Structure of each cubie inside the 3x3x3 grid:
-- Each cubie is a structure: { colors, normals }
-- colors:  { Top, Bottom, Front, Back, Right, Left } 
-- normals: { {x,y,z}, {x,y,z}, {x,y,z}, {x,y,z}, {x,y,z}, {x,y,z} }
sequence cubeState = repeat(repeat(repeat(0, 3), 3), 3)

-- Standard color constants mapped to the 6 face indices
constant FACE_TOP    = 1 -- White
constant FACE_BOTTOM = 2 -- Yellow
constant FACE_FRONT  = 3 -- Green
constant FACE_BACK   = 4 -- Blue
constant FACE_RIGHT  = 5 -- Red
constant FACE_LEFT   = 6 -- Orange

-- Initialize all 27 cubies with their native color assignments and identity direction vectors
for x = 1 to 3 do
    for y = 1 to 3 do
        for z = 1 to 3 do
            sequence colors = {WHITE, YELLOW, GREEN, BLUE, RED, ORANGE}
            sequence normals = {
                {0, 1, 0},  -- Top face pointing Up
                {0, -1, 0}, -- Bottom face pointing Down
                {0, 0, 1},  -- Front face pointing Forward
                {0, 0, -1}, -- Back face pointing Backward
                {1, 0, 0},  -- Right face pointing Right
                {-1, 0, 0}  -- Left face pointing Left
            }
            cubeState[x][y][z] = {colors, normals}
        end for
    end for
end for

-- Rotates a single 3D vector 90 degrees around the X axis
function rotate_vec_x(sequence v, integer dir)
    -- dir: 1 = CW, -1 = CCW
    if dir = 1 then return {v[1], -v[3], v[2]} else return {v[1], v[3], -v[2]} end if
end function

-- Rotates a single 3D vector 90 degrees around the Y axis
function rotate_vec_y(sequence v, integer dir)
    if dir = 1 then return {v[3], v[2], -v[1]} else return {-v[3], v[2], v[1]} end if
end function

-- Rotates a single 3D vector 90 degrees around the Z axis
function rotate_vec_z(sequence v, integer dir)
    if dir = 1 then return {-v[2], v[1], v[3]} else return {v[2], -v[1], v[3]} end if
end function

-- Rotates all face direction normals of a single cubie around a specific axis
function rotate_cubie_normals(sequence cubie, integer axis, integer dir)
    sequence colors = cubie[1]
    sequence normals = cubie[2]
    for i = 1 to 6 do
        if axis = 1 then
            normals[i] = rotate_vec_x(normals[i], dir)
        elsif axis = 2 then
            normals[i] = rotate_vec_y(normals[i], dir)
        elsif axis = 3 then
            normals[i] = rotate_vec_z(normals[i], dir)
        end if
    end for
    return {colors, normals}
end function

SetTargetFPS(60)

while not WindowShouldClose() do

    -- 1. Camera Input Handling (Arrow keys control orientation smoothly around the center)
    if IsKeyDown(KEY_LEFT)  then angleH -= speed end if
    if IsKeyDown(KEY_RIGHT) then angleH += speed end if
    if IsKeyDown(KEY_UP) then
        angleV += speed
        if angleV > 1.4 then angleV = 1.4 end if
    end if
    if IsKeyDown(KEY_DOWN) then
        angleV -= speed
        if angleV < -1.4 then angleV = -1.4 end if
    end if

    -- Check modifier to flip rotation directions
    integer shift = IsKeyDown(KEY_LEFT_SHIFT) or IsKeyDown(KEY_RIGHT_SHIFT)

    -- 2. Rubik's Layer Rotations & Matrix Position Transformations
    
    -- UP Layer (y = 3) -> Axis Y (2)
    if IsKeyPressed(KEY_U) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = 1  if shift then dir = -1 end if
        for x = 1 to 3 do
            for z = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[x][3][z], 2, dir)
                if dir = 1 then temp[z][4-x] = cubie else temp[4-z][x] = cubie end if
            end for
        end for
        for x = 1 to 3 do
            for z = 1 to 3 do cubeState[x][3][z] = temp[x][z] end for
        end for
    end if

    -- DOWN Layer (y = 1) -> Axis Y (2)
    if IsKeyPressed(KEY_D) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = -1  if shift then dir = 1 end if
        for x = 1 to 3 do
            for z = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[x][1][z], 2, dir)
                if dir = 1 then temp[z][4-x] = cubie else temp[4-z][x] = cubie end if
            end for
        end for
        for x = 1 to 3 do
            for z = 1 to 3 do cubeState[x][1][z] = temp[x][z] end for
        end for
    end if

    -- RIGHT Layer (x = 3) -> Axis X (1)
    if IsKeyPressed(KEY_R) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = 1  if shift then dir = -1 end if
        for y = 1 to 3 do
            for z = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[3][y][z], 1, dir)
                if dir = 1 then temp[z][4-y] = cubie else temp[4-z][y] = cubie end if
            end for
        end for
        for y = 1 to 3 do
            for z = 1 to 3 do cubeState[3][y][z] = temp[y][z] end for
        end for
    end if

    -- LEFT Layer (x = 1) -> Axis X (1)
    if IsKeyPressed(KEY_L) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = -1  if shift then dir = 1 end if
        for y = 1 to 3 do
            for z = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[1][y][z], 1, dir)
                if dir = 1 then temp[z][4-y] = cubie else temp[4-z][y] = cubie end if
            end for
        end for
        for y = 1 to 3 do
            for z = 1 to 3 do cubeState[1][y][z] = temp[y][z] end for
        end for
    end if

    -- FRONT Layer (z = 3) -> Axis Z (3)
    if IsKeyPressed(KEY_F) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = 1  if shift then dir = -1 end if
        for x = 1 to 3 do
            for y = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[x][y][3], 3, dir)
                if dir = 1 then temp[y][4-x] = cubie else temp[4-y][x] = cubie end if
            end for
        end for
        for x = 1 to 3 do
            for y = 1 to 3 do cubeState[x][y][3] = temp[x][y] end for
        end for
    end if

    -- BACK Layer (z = 1) -> Axis Z (3)
    if IsKeyPressed(KEY_B) then
        sequence temp = repeat(repeat(0, 3), 3)
        integer dir = -1  if shift then dir = 1 end if
        for x = 1 to 3 do
            for y = 1 to 3 do
                sequence cubie = rotate_cubie_normals(cubeState[x][y][1], 3, dir)
                if dir = 1 then temp[y][4-x] = cubie else temp[4-y][x] = cubie end if
            end for
        end for
        for x = 1 to 3 do
            for y = 1 to 3 do cubeState[x][y][1] = temp[x][y] end for
        end for
    end if

    -- Compute Camera LookAt Vectors
    atom camX = radius * cos(angleV) * sin(angleH)
    atom camY = radius * sin(angleV)
    atom camZ = radius * cos(angleV) * cos(angleH)

    sequence camera = {
        {camX, camY, camZ},
        {0.0, 0.0, 0.0},
        {0.0, 1.0, 0.0},
        40.0,
        0
    }

    BeginDrawing()
    ClearBackground(RAYWHITE)

    BeginMode3D(camera)

        -- 3. 3D Scene Rendering Loop
        for x = 1 to 3 do
            for y = 1 to 3 do
                for z = 1 to 3 do

                    -- Visual spatial center slot for drawing
                    atom posX = (x - 2) * 2.1
                    atom posY = (y - 2) * 2.1
                    atom posZ = (z - 2) * 2.1
                    sequence cubePos = {posX, posY, posZ}
                    
                    -- Extract structured cubie property states
                    sequence cubie = cubeState[x][y][z]
                    sequence colors = cubie[1]
                    sequence normals = cubie[2]

                    -- Render base inner core structure (Black)
                    DrawCube(cubePos, 1.9, 1.9, 1.9, BLACK)

                    -- Iterate over all 6 stickers and process their dynamically transformed normals.
                    -- If a face's normal currently points outwards matching a boundary, we apply its color!
                    for f = 1 to 6 do
                        sequence n = normals[f]
                        
                        -- Top sticker (Pointing Upwards: y = 1)
                        if n[2] = 1 then
                            DrawCube({posX, posY + 0.95, posZ}, 1.8, 0.05, 1.8, colors[f])
                        -- Bottom sticker (Pointing Downwards: y = -1)
                        elsif n[2] = -1 then
                            DrawCube({posX, posY - 0.95, posZ}, 1.8, 0.05, 1.8, colors[f])
                        -- Front sticker (Pointing Forward: z = 1)
                        elsif n[3] = 1 then
                            DrawCube({posX, posY, posZ + 0.95}, 1.8, 1.8, 0.05, colors[f])
                        -- Back sticker (Pointing Backward: z = -1)
                        elsif n[3] = -1 then
                            DrawCube({posX, posY, posZ - 0.95}, 1.8, 1.8, 0.05, colors[f])
                        -- Right sticker (Pointing Right: x = 1)
                        elsif n[1] = 1 then
                            DrawCube({posX + 0.95, posY, posZ}, 0.05, 1.8, 1.8, colors[f])
                        -- Left sticker (Pointing Left: x = -1)
                        elsif n[1] = -1 then
                            DrawCube({posX - 0.95, posY, posZ}, 0.05, 1.8, 1.8, colors[f])
                        end if
                    end for

                    -- Render outer border frame grids
                    DrawCubeWires(cubePos, 1.95, 1.95, 1.95, DARKGRAY)

                end for
            end for
        end for

    EndMode3D()

    -- 4. User Interface HUD Layout
    DrawText("Rubik's Cube 3D", 10, 10, 20, DARKGRAY)
    DrawText("Rubik's Cube 3D", 10, 10, 20, DARKGRAY)
    DrawText("Camera: Arrow keys", 10, 40, 16, DARKGRAY)
    DrawText("Layers: U, D, R, L, F, B (SHIFT to reverse)", 10, 65, 16, DARKGRAY)

    EndDrawing()
end while
CloseWindow()
