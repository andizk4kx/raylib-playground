/*******************************************************************************************
*
*   raylib [shapes] example - bullet hell
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 5.6, last time updated with raylib 5.6
*
*   Example contributed by Zero (@zerohorsepower) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Zero (@zerohorsepower)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--#include <stdlib.h>       -- Required for: calloc(), free()
--#include <math.h>         -- Required for: cosf(), sinf()

--/*
constant false =0
constant true=1
include std/math.e
--*/
constant MAX_BULLETS=5000   -- Max bullets to be processed

------------------------------------------------------------------------------------
-- Types and Structures Definition
------------------------------------------------------------------------------------
--typedef struct Bullet {
--  Vector2 position;       -- Bullet position on screen
--  Vector2 acceleration;   -- Amount of pixels to be incremented to position every frame
--  bool disabled;          -- Skip processing and draw case out of screen
--  Color color;            -- Bullet color
--} Bullet;
sequence TBullet = {
    {0,0},                  -- Bullet position on screen
    {0,0},                  -- Amount of pixels to be incremented to position every frame
    0,                      -- Skip processing and draw case out of screen
    {0,0,0,0}               -- Bullet color
    }
enum _position,acceleration,disabled,color
enum x,y
enum texture=2,width=2,height=3
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bullet hell")

    -- Bullets definition
    sequence bullets = repeat(TBullet,MAX_BULLETS) -- Bullets array
    integer bulletCount = 1
    integer bulletDisabledCount = 1 -- Used to calculate how many bullets are on screen
    integer bulletRadius = 10
    atom bulletSpeed = 3.0
    integer bulletRows = 6
    sequence bulletColor = { RED, BLUE }

    -- Spawner variables
    atom baseDirection = 0
    integer angleIncrement = 5 -- After spawn all bullet rows, increment this value on the baseDirection for next the frame
    atom spawnCooldown = 2
    atom spawnCooldownTimer = spawnCooldown

    -- Magic circle
    atom magicCircleRotation = 0

    -- Used on performance drawing
    sequence bulletTexture = LoadRenderTexture(24, 24)

    -- Draw circle to bullet texture, then draw bullet using DrawTexture()
    -- NOTE: This is done to improve the performance, since DrawCircle() is very slow
    BeginTextureMode(bulletTexture)
        DrawCircle(12, 12, bulletRadius, WHITE)
        DrawCircleLines(12, 12,bulletRadius, BLACK)
    EndTextureMode()

    integer drawInPerformanceMode = true -- Switch between DrawCircle() and DrawTexture()

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not (WindowShouldClose()) -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Reset the bullet index
        -- New bullets will replace the old ones that are already disabled due to out-of-screen
        if (bulletCount >= MAX_BULLETS)
        then
            bulletCount = 1
            bulletDisabledCount = 0
        end if

        spawnCooldownTimer-= 1
        if (spawnCooldownTimer < 0)
        then
            spawnCooldownTimer = spawnCooldown

            -- Spawn bullets
            atom degreesPerRow = 360.0/bulletRows
            for  row = 0 to bulletRows
            do
                if (bulletCount < MAX_BULLETS)
                then
                    bullets[bulletCount][_position] = { screenWidth/2,screenHeight/2}
                    bullets[bulletCount][disabled] = false
                    bullets[bulletCount][color] = bulletColor[mod(row,2)+1]

                    atom bulletDirection = baseDirection + (degreesPerRow*row)

                    -- Bullet speed*bullet direction, this will determine how much pixels will be incremented/decremented
                    -- from the bullet position every frame. Since the bullets doesn't change its direction and speed,
                    -- only need to calculate it at the spawning time
                    -- 0 degrees = right, 90 degrees = down, 180 degrees = left and 270 degrees = up, basically clockwise
                    -- Case you want it to be anti-clockwise, add "* -1" at the y acceleration
                    bullets[bulletCount][acceleration] = {
                        bulletSpeed*cos(bulletDirection*DEG2RAD),
                        bulletSpeed*sin(bulletDirection*DEG2RAD)}

                    bulletCount+=1
                end if
            end for

            baseDirection += angleIncrement
        end if

        -- Update bullets position based on its acceleration
        for  i = 1 to bulletCount
        do
            -- Only update bullet if inside the screen
            if not(bullets[i][disabled])
            then
                bullets[i][_position][x] += bullets[i][acceleration][x]
                bullets[i][_position][y] += bullets[i][acceleration][y]

                -- Disable bullet if out of screen
                if ((bullets[i][_position][x] < -bulletRadius*2) or
                    (bullets[i][_position][x] > screenWidth + bulletRadius*2) or
                    (bullets[i][_position][y] < -bulletRadius*2) or
                    (bullets[i][_position][y] > screenHeight + bulletRadius*2))
                then
                    bullets[i][disabled] = true
                    bulletDisabledCount+=1
                end if
            end if
        end for

        -- Input logic
        if ((IsKeyPressed(KEY_RIGHT) or IsKeyPressed(KEY_D)) and (bulletRows < 359)) then bulletRows+=1 end if
        if ((IsKeyPressed(KEY_LEFT) or IsKeyPressed(KEY_A)) and (bulletRows > 1)) then bulletRows-=1 end if
        if (IsKeyPressed(KEY_UP) or IsKeyPressed(KEY_W)) then bulletSpeed += 0.25 end if
        if ((IsKeyPressed(KEY_DOWN) or IsKeyPressed(KEY_S)) and (bulletSpeed > 0.50)) then bulletSpeed -= 0.25 end if
        if (IsKeyPressed(KEY_Z) and (spawnCooldown > 1)) then spawnCooldown-=1 end if
        if (IsKeyPressed(KEY_X)) then spawnCooldown+=1 end if
        if (IsKeyPressed(KEY_ENTER)) then drawInPerformanceMode = not(drawInPerformanceMode) end if

        if (IsKeyDown(KEY_SPACE))
        then
            angleIncrement += 1
            angleIncrement =mod(angleIncrement, 360)
        end if

        if (IsKeyPressed(KEY_C))
        then
            bulletCount = 1
            bulletDisabledCount = 0
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()
            ClearBackground(RAYWHITE)

            -- Draw magic circle
            magicCircleRotation+=1
            DrawRectanglePro({screenWidth/2,screenHeight/2, 120, 120 },{ 60.0, 60.0 }, magicCircleRotation, PURPLE)
            DrawRectanglePro({screenWidth/2, screenHeight/2, 120, 120 },{ 60.0, 60.0 }, magicCircleRotation + 45, PURPLE)
            DrawCircleLines(screenWidth/2, screenHeight/2, 70, BLACK)
            DrawCircleLines(screenWidth/2, screenHeight/2, 50, BLACK)
            DrawCircleLines(screenWidth/2, screenHeight/2, 30, BLACK)

            -- Draw bullets
            if (drawInPerformanceMode)
            then
                -- Draw bullets using pre-rendered texture containing circle
                for  i = 1 to bulletCount
                do
                    -- Do not draw disabled bullets (out of screen)
                    if not(bullets[i][disabled])
                    then
                        DrawTexture(bulletTexture[texture],
                            (bullets[i][_position][x] - bulletTexture[texture][width]*0.5),
                            (bullets[i][_position][y] - bulletTexture[texture][height]*0.5),
                            bullets[i][color])
                    end if
                end for
            
            else
            
                -- Draw bullets using DrawCircle(), less performant
                for  i = 1 to bulletCount
                do
                    -- Do not draw disabled bullets (out of screen)
                    if not(bullets[i][disabled]) 
                    then
                        DrawCircleV(bullets[i][_position], bulletRadius, bullets[i][color])
                        DrawCircleLinesV(bullets[i][_position], bulletRadius, BLACK)
                    end if
                end for
            end if

            -- Draw UI
            DrawRectangle(10, 10, 280, 150, {0,0, 0, 200 })
            DrawText("Controls:", 20, 20, 10, LIGHTGRAY)
            DrawText("- Right/Left or A/D: Change rows number", 40, 40, 10, LIGHTGRAY)
            DrawText("- Up/Down or W/S: Change bullet speed", 40, 60, 10, LIGHTGRAY)
            DrawText("- Z or X: Change spawn cooldown", 40, 80, 10, LIGHTGRAY)
            DrawText("- Space (Hold): Change the angle increment", 40, 100, 10, LIGHTGRAY)
            DrawText("- Enter: Switch draw method (Performance)", 40, 120, 10, LIGHTGRAY)
            DrawText("- C: Clear bullets", 40, 140, 10, LIGHTGRAY)

            DrawRectangle(610, 10, 170, 30, {0,0, 0, 200 })
            if (drawInPerformanceMode) then 
                DrawText("Draw method: DrawTexture(*)", 620, 20, 10, GREEN)
            else 
                DrawText("Draw method: DrawCircle(*)", 620, 20, 10, RED)
            end if
            
            DrawRectangle(135, 410, 530, 30,{0,0, 0, 200 })
            DrawText(TextFormat("[ FPS: %d, Bullets: %d, Rows: %d, Bullet speed: %.2f, Angle increment per frame: %d, Cooldown: %.0f ]",
                    {GetFPS(), bulletCount - bulletDisabledCount, bulletRows, bulletSpeed,  angleIncrement, spawnCooldown}),155, 420, 10, GREEN)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadRenderTexture(bulletTexture) -- Unload bullet texture

    bullets={}    -- Free bullets array data

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


