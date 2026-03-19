/*******************************************************************************************
*
*   raylib [shapes] example - math sine cosine
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6-dev
*
*   Example contributed by Jopestpe (@jopestpe) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Jopestpe (@jopestpe)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
--#include <math.h>
--#include "raymath.h"
--/*
include std/math.e
constant true=1
constant false=0
--*/
--#define RAYGUI_IMPLEMENTATION
--#include "raygui.h"               -- Required for GUI controls

-- Wave points for sine/cosine visualization
constant WAVE_POINTS=36
enum x,y,width,height
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    SetConfigFlags(FLAG_MSAA_4X_HINT)
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - math sine cosine")

    sequence sinePoints =repeat({0,0},WAVE_POINTS+1)
    sequence cosPoints =repeat({0,0},WAVE_POINTS+1)
    sequence center = { (screenWidth/2.0) - 30.0, screenHeight/2.0 }
    sequence start = { 20.0, screenHeight - 120.0 , 200.0, 100.0}
    atom radius = 130.0
    atom angle = 0.0
    integer pause = false

    for  i =0 to WAVE_POINTS
    do
        atom t = i/(WAVE_POINTS-1 )
        atom currentAngle = t*360.0*DEG2RAD
        sinePoints[i+1] = { start[x] + t*start[width], start[y] + start[height]/2.0 - sin(currentAngle)*(start[height]/2.0) }
        cosPoints[i+1] = { start[x] + t*start[width], start[y] + start[height]/2.0 - cos(currentAngle)*(start[height]/2.0) }
    end for

    SetTargetFPS(60)            -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        atom angleRad = angle*DEG2RAD
        atom cosRad = cos(angleRad)
        atom sinRad = sin(angleRad)

        sequence point = { center[x] + cosRad*radius, center[y] - sinRad*radius }
        sequence limitMin = { center[x] - radius, center[y] - radius }
        sequence limitMax = { center[x] + radius, center[y] + radius }

        atom complementary = 90.0 - angle
        atom supplementary = 180.0 - angle
        atom explementary = 360.0 - angle

        atom tangent = Clamp(tan(angleRad), -10.0, 10.0)
        --atom cotangent = (abs(tangent) > 0.001) ? Clamp(1.0f/tangent, -radius, radius) : 0.0f;
        atom cotangent
        if (abs(tangent) > 0.001)
        then 
            cotangent=Clamp(1.0/tangent, -radius, radius)
        else
            cotangent= 0
        end if
        sequence tangentPoint = { center[x] + radius, center[y] - tangent*radius }
        sequence cotangentPoint = { center[x] + cotangent*radius, center[y] - radius }
        atom helper
        if not pause 
        then
            helper=1
        else
            helper =0   
        end if
        angle = Wrap(angle + helper, 0.0, 360.0)
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()
            ClearBackground(RAYWHITE)

            -- Cotangent (orange)
            DrawLineEx({ center[x] , limitMin[y] }, { cotangentPoint[x], limitMin[y] }, 2.0, ORANGE)
            DrawLineDashed(center, cotangentPoint, 10, 4, ORANGE)

            -- Side background
            DrawLine(580, 0, 580, GetScreenHeight(), { 218, 218, 218, 255 })
            DrawRectangle(580, 0, GetScreenWidth(), GetScreenHeight(), { 232, 232, 232, 255 })

            -- Base circle and axes
            DrawCircleLinesV(center, radius, GRAY)
            DrawLineEx({ center[x], limitMin[y] }, { center[x], limitMax[y] }, 1.0, GRAY)
            DrawLineEx({ limitMin[x], center[y] }, { limitMax[x], center[y] }, 1.0, GRAY)

            -- Wave graph axes
            DrawLineEx({ start[x] , start[y] }, { start[x] , start[y] + start[height] }, 2.0, GRAY)
            DrawLineEx({ start[x] + start[width], start[y] }, { start[x] + start[width], start[y] + start[height] }, 2.0, GRAY)
            DrawLineEx({ start[x], start[y] + start[height]/2 }, { start[x] + start[width], start[y] + start[height]/2 }, 2.0, GRAY)

            -- Wave graph axis labels
            DrawText("1", start[x] - 8, start[y], 6, GRAY)
            DrawText("0", start[x] - 8, start[y] + start[height]/2 - 6, 6, GRAY)
            DrawText("-1", start[x] - 12, start[y] + start[height] - 8, 6, GRAY)
            DrawText("0", start[x] - 2, start[y] + start[height] + 4, 6, GRAY)
            DrawText("360", start[x] + start[width] - 8, start[y] + start[height] + 4, 6, GRAY)

            -- Sine (red - vertical)
            DrawLineEx({ center[x], center[y] }, { center[x], point[y] }, 2.0, RED)
            DrawLineDashed({ point[x], center[y] }, { point[x], point[y] }, 10, 4, RED)
            DrawText(sprintf("Sine %.2f", sinRad), 640, 190, 6, RED)
            DrawCircleV({ start[x] + (angle/360.0)*start[width], start[y] + ((-sinRad + 1)*start[height]/2.0) }, 4.0, RED)
            DrawSplineLinear(sinePoints, WAVE_POINTS, 1.0, RED)

            -- Cosine (blue - horizontal)
            DrawLineEx({ center[x], center[y] },{ point[x], center[y] }, 2.0, BLUE)
            DrawLineDashed({ center[x] , point[y] }, { point[x], point[y] }, 10, 4, BLUE)
            DrawText(sprintf("Cosine %.2f", cosRad), 640, 210, 6, BLUE)
            DrawCircleV({ start[x] + (angle/360.0)*start[width], start[y] + ((-cosRad + 1)*start[height]/2.0) }, 4.0, BLUE)
            DrawSplineLinear(cosPoints, WAVE_POINTS, 1.0, BLUE)

            -- Tangent (purple)
            DrawLineEx({ limitMax[x] , center[y] }, { limitMax[x], tangentPoint[y] }, 2.0, PURPLE)
            DrawLineDashed(center, tangentPoint, 10, 4, PURPLE)
            DrawText(sprintf("Tangent %.2f", tangent), 640, 230, 6, PURPLE)

            -- Cotangent (orange)
            DrawText(sprintf("Cotangent %.2f", cotangent), 640, 250, 6, ORANGE)

            -- Complementary angle (beige)
            DrawCircleSectorLines(center, radius*0.6 , -angle, -90.0 , 36, BEIGE)
            DrawText(sprintf("Complementary  %0.d°",complementary), 640, 150, 6, BEIGE)

            -- Supplementary angle (darkblue)
            DrawCircleSectorLines(center, radius*0.5 , -angle, -180.0 , 36, DARKBLUE)
            DrawText(sprintf("Supplementary  %0.d°",supplementary), 640, 130, 6, DARKBLUE)

            -- Explementary angle (pink)
            DrawCircleSectorLines(center, radius*0.4 , -angle, -360.0 , 36, PINK)
            DrawText(sprintf("Explementary  %0.d°",explementary), 640, 170, 6, PINK)

            -- Current angle - arc (lime), radius (black), endpoint (black)
            DrawCircleSectorLines(center, radius*0.7 , -angle, 0.0, 36, LIME)
            DrawLineEx({ center[x] , center[y] }, point, 2.0, BLACK)
            DrawCircleV(point, 4.0, BLACK)

            -- Draw GUI controls
            --------------------------------------------------------------------------------
            GuiSetStyle(LABEL, TEXT_COLOR_NORMAL, ColorToInt(GRAY))
            pause=GuiToggle({ 640, 70, 120, 20}, sprintf("Pause",1), {2,pause})
            GuiSetStyle(LABEL, TEXT_COLOR_NORMAL, ColorToInt(LIME))
            angle=GuiSliderBar({ 640, 40, 120, 20}, "Angle", sprintf("%.0d°", angle), {1,angle}, 0.0, 360.0)
            ?pause
            -- Angle values panel
    atom dummy = GuiGroupBox({ 620, 110, 140, 170}, "Angle Values")
            --------------------------------------------------------------------------------

            DrawFPS(10, 10)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()     -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


