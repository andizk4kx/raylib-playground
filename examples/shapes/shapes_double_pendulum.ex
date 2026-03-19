/*******************************************************************************************
*
*   raylib [shapes] example - double pendulum
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.5
*
*   Example contributed by JoeCheong (@Joecheong2006) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 JoeCheong (@Joecheong2006)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--include raylib.e
--include raymath.e
--#include <math.h>     -- Required for: sin(), cos(), PI

-- Constant for Simulation
constant SIMULATION_STEPS = 30
constant G = 9.81
enum x,y
enum texture=2
enum width=2,height
------------------------------------------------------------------------------------
-- Module Functions Declaration
------------------------------------------------------------------------------------
--/**/forward function CalculatePendulumEndPoint(atom  l, atom  theta)
--/**/forward function CalculateDoublePendulumEndPoint(atom  l1, atom  theta1, atom  l2, atom  theta2)

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    SetConfigFlags(FLAG_WINDOW_HIGHDPI)
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - double pendulum")

    -- Simulation Parameters
    atom l1 = 15.0, m1 = 0.2, theta1 = DEG2RAD*170, w1 = 0
    atom l2 = 15.0, m2 = 0.1, theta2 = DEG2RAD*0, w2 = 0
    atom lengthScaler = 0.1
    atom totalM = m1 + m2

    sequence previousPosition = CalculateDoublePendulumEndPoint(l1, theta1, l2, theta2)
    previousPosition[x] += (screenWidth/2)
    previousPosition[y] += (screenHeight/2 - 100)

    -- Scale length
    atom L1 = l1*lengthScaler
    atom L2 = l2*lengthScaler

    -- Draw parameters
    atom lineThick = 20, trailThick = 2
    atom fateAlpha = 0.01

    -- Create framebuffer
    sequence target = LoadRenderTexture(screenWidth, screenHeight)
    SetTextureFilter(target[texture], TEXTURE_FILTER_BILINEAR)

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        atom dt = GetFrameTime()
        atom step = dt/SIMULATION_STEPS, step2 = step*step

        -- Update Physics - larger steps = better approximation
        for  i = 0 to  SIMULATION_STEPS
        do
            atom delta = theta1 - theta2
            atom sinD = sin(delta), cosD = cos(delta), cos2D = cos(2*delta)
            atom ww1 = w1*w1, ww2 = w2*w2

            -- Calculate a1
            atom a1 = (-G*(2*m1 + m2)*sin(theta1)
                         - m2*G*sin(theta1 - 2*theta2)
                         - 2*sinD*m2*(ww2*L2 + ww1*L1*cosD))
                        /(L1*(2*m1 + m2 - m2*cos2D))

            -- Calculate a2
            atom a2 = (2*sinD*(ww1*L1*totalM
                         + G*totalM*cos(theta1)
                         + ww2*L2*m2*cosD))
                        /(L2*(2*m1 + m2 - m2*cos2D))

            -- Update thetas
            theta1 += w1*step + 0.5*a1*step2
            theta2 += w2*step + 0.5*a2*step2

            -- Update omegas
            w1 += a1*step
            w2 += a2*step
        end for

        -- Calculate position
        sequence currentPosition = CalculateDoublePendulumEndPoint(l1, theta1, l2, theta2)
        currentPosition[x] += screenWidth/2
        currentPosition[y] += screenHeight/2 - 100

        -- Draw to render texture
        BeginTextureMode(target)
            -- Draw a transparent rectangle - smaller alpha = longer trails
            DrawRectangle(0, 0, screenWidth, screenHeight, Fade(BLACK, fateAlpha))

            -- Draw trail
            DrawCircleV(previousPosition, trailThick, RED)
            DrawLineEx(previousPosition, currentPosition, trailThick*2, RED)
        EndTextureMode()

        -- Update previous position
        previousPosition = currentPosition
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(BLACK)

            -- Draw trails texture
            DrawTextureRec(target[texture],{ 0, 0,target[texture][width],-target[texture][height] },{ 0, 0 }, WHITE)

            -- Draw double pendulum
            DrawRectanglePro({ screenWidth/2.0, screenHeight/2.0 - 100, 10*l1, lineThick },
                {0, lineThick*0.5}, 90 - RAD2DEG*theta1, RAYWHITE)

            sequence endpoint1 = CalculatePendulumEndPoint(l1, theta1)
            DrawRectanglePro({ screenWidth/2.0 + endpoint1[x], screenHeight/2.0 - 100 + endpoint1[y], 10*l2, lineThick },
                {0, lineThick*0.5}, 90 - RAD2DEG*theta2, RAYWHITE)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadRenderTexture(target)

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------



------------------------------------------------------------------------------------
-- Module Functions Definition
------------------------------------------------------------------------------------
-- Calculate pendulum end point
function CalculatePendulumEndPoint(atom  l, atom  theta)
    return { 10*l*sin(theta), 10*l*cos(theta) }
end function

-- Calculate double pendulum end point
function CalculateDoublePendulumEndPoint(atom  l1, atom  theta1, atom  l2, atom  theta2)
    sequence endpoint1 = CalculatePendulumEndPoint(l1, theta1)
    sequence endpoint2 = CalculatePendulumEndPoint(l2, theta2)
    return { endpoint1[x] + endpoint2[x], endpoint1[y] + endpoint2[y] }
end function

