include ..\..\raylib64.e

constant screenWidth  = 800
constant screenHeight = 600

InitWindow(screenWidth, screenHeight, "Rubik's cube")

-- Camera position in polar coordinate system (Radius, Horizontal Angle, Vertical Angle)
atom radius = 16.0
atom angleH = 0.785   -- approx. 45 degrees initial horizontal angle
atom angleV = 0.615   -- initial vertical angle for default isometric view
atom speed  = 0.05    -- rotation speed

SetTargetFPS(60)

while not WindowShouldClose() do

    -- Input handling for camera rotation (WASD)
    if IsKeyDown(KEY_RIGHT) then
        angleH -= speed
    end if
    if IsKeyDown(KEY_LEFT) then
        angleH += speed
    end if
    if IsKeyDown(KEY_DOWN) then
        angleV += speed
        if angleV > 1.4 then angleV = 1.4 end if   -- clamp to prevent flipping overhead
    end if
    if IsKeyDown(KEY_UP) then
        angleV -= speed
        if angleV < -1.4 then angleV = -1.4 end if  -- clamp for under-cube view
    end if

    -- Calculate new camera position in 3D space using spherical trigonometry
    atom camX = radius * cos(angleV) * sin(angleH)
    atom camY = radius * sin(angleV)
    atom camZ = radius * cos(angleV) * cos(angleH)

    -- Dynamically update the camera sequence with new coordinates
    sequence camera = {
        {camX, camY, camZ}, -- position
        {0.0, 0.0, 0.0},    -- target
        {0.0, 1.0, 0.0},    -- up
        40.0,               -- fovy
        0                   -- projection (CAMERA_PERSPECTIVE = 0)
    }

    BeginDrawing()
    ClearBackground(RAYWHITE)

    BeginMode3D(camera)

        for x = -1 to 1 do
            for y = -1 to 1 do
                for z = -1 to 1 do

                    atom posX = x * 2.1
                    atom posY = y * 2.1
                    atom posZ = z * 2.1
                    
                    -- Main cube body (Black)
                    sequence cubePos = {posX, posY, posZ}
                    DrawCube(cubePos, 1.9, 1.9, 1.9, BLACK)

                    -- Top face (White)
                    if y = 1 then
                        DrawCube({posX, posY + 0.95, posZ}, 1.8, 0.05, 1.8, WHITE)
                    end if

                    -- Bottom face (Yellow)
                    if y = -1 then
                        DrawCube({posX, posY - 0.95, posZ}, 1.8, 0.05, 1.8, YELLOW)
                    end if

                    -- Front face (Green)
                    if z = 1 then
                        DrawCube({posX, posY, posZ + 0.95}, 1.8, 1.8, 0.05, GREEN)
                    end if

                    -- Back face (Blue)
                    if z = -1 then
                        DrawCube({posX, posY, posZ - 0.95}, 1.8, 1.8, 0.05, BLUE)
                    end if

                    -- Right face (Red)
                    if x = 1 then
                        DrawCube({posX + 0.95, posY, posZ}, 0.05, 1.8, 1.8, RED)
                    end if

                    -- Left face (Orange)
                    if x = -1 then
                        DrawCube({posX - 0.95, posY, posZ}, 0.05, 1.8, 1.8, ORANGE)
                    end if

                    -- Wireframe grid outlines (Dark Gray)
                    DrawCubeWires(cubePos, 1.95, 1.95, 1.95, DARKGRAY)

                end for
            end for
        end for

    EndMode3D()

    DrawText("Standard 3x3 Rubik's Cube", 15, 15, 20, DARKGRAY)
    DrawText("Scheme: White(Top) | Green(Front) | Red(Right)", 15, 40, 16, GRAY)

    EndDrawing()
end while

CloseWindow()
