include ..\..\raylib64.e

constant screenWidth  = 800
constant screenHeight = 600

InitWindow(screenWidth, screenHeight, "Rubik's cube")

-- Kamera-Definition als native Phix-Sequence
sequence camera = {
    {9.0, 9.0, 11.0},   -- position
    {0.0, 0.0, 0.0},    -- target
    {0.0, 1.0, 0.0},    -- up
    40.0,               -- fovy
    0                   -- projection (CAMERA_PERSPECTIVE = 0)
}

SetTargetFPS(60)

while not WindowShouldClose() do

    camera=UpdateCamera(camera,CAMERA_ORBITAL) 


    BeginDrawing()
    ClearBackground(RAYWHITE)

    BeginMode3D(camera)

        for x = -1 to 1 do
            for y = -1 to 1 do
                for z = -1 to 1 do

                    atom posX = x * 2.1
                    atom posY = y * 2.1
                    atom posZ = z * 2.1
                    
                    -- Haupt-Wuerfel (Schwarz)
                    sequence cubePos = {posX, posY, posZ}
                    DrawCube(cubePos, 1.9, 1.9, 1.9, BLACK)

                    -- Oben (Weiss)
                    if y = 1 then
                        DrawCube({posX, posY + 0.95, posZ}, 1.8, 0.05, 1.8, WHITE)
                    end if

                    -- Unten (Gelb)
                    if y = -1 then
                        DrawCube({posX, posY - 0.95, posZ}, 1.8, 0.05, 1.8, YELLOW)
                    end if

                    -- Vorne (Gruen)
                    if z = 1 then
                        DrawCube({posX, posY, posZ + 0.95}, 1.8, 1.8, 0.05, GREEN)
                    end if

                    -- Hinten (Blau)
                    if z = -1 then
                        DrawCube({posX, posY, posZ - 0.95}, 1.8, 1.8, 0.05, BLUE)
                    end if

                    -- Rechts (Rot)
                    if x = 1 then
                        DrawCube({posX + 0.95, posY, posZ}, 0.05, 1.8, 1.8, RED)
                    end if

                    -- Links (Orange)
                    if x = -1 then
                        DrawCube({posX - 0.95, posY, posZ}, 0.05, 1.8, 1.8, ORANGE)
                    end if

                    -- Gitterlinien (Dunkelgrau)
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
