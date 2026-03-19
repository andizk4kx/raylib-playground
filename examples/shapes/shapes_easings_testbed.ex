/*******************************************************************************************
*
*   raylib [shapes] example - easings testbed
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Juan Miguel López (@flashback-fx) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2025 Juan Miguel López (@flashback-fx) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"
include "reasings.e"     -- Required for: easing functions
--include raylib.e
--------------------------------------------------------------------------------------
-- Module Functions Declaration
--------------------------------------------------------------------------------------
-- NoEase function, used when "no easing" is selected for any axis
-- It just ignores all parameters besides b
function NoEase(atom  t, atom  b, atom  c, atom  d)
    -- Hack to avoid compiler warning (about unused variables)(yep, same for Euphoria/Phix)
    atom burn = t + b + c + d
    d += burn
    return b
end function


constant FONT_SIZE=20
constant D_STEP =   20.0
constant D_STEP_FINE =2.0
constant D_MIN  =   1.0
constant D_MAX  =   10000.0
enum x,y

--/*
integer true=1
integer false=0
--*/
------------------------------------------------------------------------------------
-- Types and Structures Definition
------------------------------------------------------------------------------------
-- Easing types
 
enum    EASE_LINEAR_NONE = 1,
    EASE_LINEAR_IN,
    EASE_LINEAR_OUT,
    EASE_LINEAR_IN_OUT,
    EASE_SINE_IN,
    EASE_SINE_OUT,
    EASE_SINE_IN_OUT,
    EASE_CIRC_IN,
    EASE_CIRC_OUT,
    EASE_CIRC_IN_OUT,
    EASE_CUBIC_IN,
    EASE_CUBIC_OUT,
    EASE_CUBIC_IN_OUT,
    EASE_QUAD_IN,
    EASE_QUAD_OUT,
    EASE_QUAD_IN_OUT,
    EASE_EXPO_IN,
    EASE_EXPO_OUT,
    EASE_EXPO_IN_OUT,
    EASE_BACK_IN,
    EASE_BACK_OUT,
    EASE_BACK_IN_OUT,
    EASE_BOUNCE_OUT,
    EASE_BOUNCE_IN,
    EASE_BOUNCE_IN_OUT,
    EASE_ELASTIC_IN,
    EASE_ELASTIC_OUT,
    EASE_ELASTIC_IN_OUT,
    NUM_EASING_TYPES,
    EASING_NONE = NUM_EASING_TYPES




sequence  EasingFunc={"",0}
--------------------------------------------------------------------------------------
-- Module Functions Declaration
--------------------------------------------------------------------------------------
-- Function used when "no easing" is selected for any axis
--static float NoEase(float t, float b, float c, float d);  

--------------------------------------------------------------------------------------
-- Global Variables Definition
--------------------------------------------------------------------------------------
-- Easing functions reference data
sequence easings=repeat(EasingFunc,NUM_EASING_TYPES)

easings [EASE_LINEAR_NONE] = {"EaseLinearNone",routine_id("EaseLinearNone")}
easings [EASE_LINEAR_IN] = {"EaseLinearIn",routine_id("EaseLinearIn") }
easings [EASE_LINEAR_OUT] = { "EaseLinearOut",routine_id("EaseLinearOut") }
easings [EASE_LINEAR_IN_OUT] = {  "EaseLinearInOut",routine_id("EaseLinearInOut") }
easings [EASE_SINE_IN] = {  "EaseSineIn",routine_id("EaseSineIn") }
easings [EASE_SINE_OUT] = {  "EaseSineOut",routine_id("EaseSineOut") }
easings [EASE_SINE_IN_OUT] = {  "EaseSineInOut",routine_id("EaseSineInOut") }
easings [EASE_CIRC_IN] = {  "EaseCircIn",routine_id("EaseCircIn") }
easings [EASE_CIRC_OUT] = {  "EaseCircOut",routine_id("EaseCircOut") }
easings [EASE_CIRC_IN_OUT] = {  "EaseCircInOut",routine_id("EaseCircInOut") }
easings [EASE_CUBIC_IN] = {  "EaseCubicIn",routine_id("EaseCubicIn") }
easings [EASE_CUBIC_OUT] = {  "EaseCubicOut",routine_id("EaseCubicOut") }
easings [EASE_CUBIC_IN_OUT] = {  "EaseCubicInOut",routine_id("EaseCubicInOut") }
easings [EASE_QUAD_IN] = {  "EaseQuadIn",routine_id("EaseQuadIn") }
easings [EASE_QUAD_OUT] = {  "EaseQuadOut",routine_id("EaseQuadOut") }
easings [EASE_QUAD_IN_OUT] = {  "EaseQuadInOut",routine_id("EaseQuadInOut") }
easings [EASE_EXPO_IN] = {  "EaseExpoIn",routine_id("EaseExpoIn") }
easings [EASE_EXPO_OUT] = {  "EaseExpoOut",routine_id("EaseExpoOut") }
easings [EASE_EXPO_IN_OUT] = {  "EaseExpoInOut",routine_id("EaseExpoInOut") }
easings [EASE_BACK_IN] = {  "EaseBackIn",routine_id("EaseBackIn") }
easings [EASE_BACK_OUT] = {  "EaseBackOut",routine_id("EaseBackOut") }
easings [EASE_BACK_IN_OUT] = {  "EaseBackInOut",routine_id("EaseBackInOut") }
easings [EASE_BOUNCE_OUT] = {  "EaseBounceOut",routine_id("EaseBounceOut") }
easings [EASE_BOUNCE_IN] = {  "EaseBounceIn",routine_id("EaseBounceIn") }
easings [EASE_BOUNCE_IN_OUT] = {  "EaseBounceInOut",routine_id("EaseBounceInOut") }
easings [EASE_ELASTIC_IN] = {  "EaseElasticIn",routine_id("EaseElasticIn") }
easings [EASE_ELASTIC_OUT] = {  "EaseElasticOut",routine_id("EaseElasticOut") }
easings [EASE_ELASTIC_IN_OUT] = {  "EaseElasticInOut",routine_id("EaseElasticInOut") }
easings [EASING_NONE] = {  "None",routine_id("NoEase") }

for i = 1 to EASING_NONE   
do  
    puts(1,easings[i][1]&" "&sprintf("%d",easings[i][2])&"\n")
end for
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant  screenWidth = 800
    constant  screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - easings testbed")

    sequence ballPosition = { 100.0, 100.0 }

    atom t = 0.0            -- Current time (in any unit measure, but same unit as duration)
    atom d = 300.0          -- Total time it should take to complete (duration)
    integer paused = true
    integer boundedT = true     -- If true, t will stop when d >= td, otherwise t will keep adding td to its value every loop

    integer easingX = EASING_NONE   -- Easing selected for x axis
    integer easingY = EASING_NONE   -- Easing selected for y axis

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_T)) then boundedT = not boundedT end if

        -- Choose easing for the X axis
        if (IsKeyPressed(KEY_RIGHT))
        then
            easingX+=1

            if (easingX > EASING_NONE) then easingX = 1 end if
        elsif (IsKeyPressed(KEY_LEFT))
        then
            if (easingX <= 1) 
            then 
                easingX = EASING_NONE
            else 
                easingX-=1
            end if
        end if

        -- Choose easing for the Y axis
        if (IsKeyPressed(KEY_DOWN))
        then
            easingY+=1

            if (easingY > EASING_NONE) then easingY = 1 end if
        elsif (IsKeyPressed(KEY_UP))
        then
            if (easingY <= 1) 
            then 
                easingY = EASING_NONE
            else 
                easingY-=1
            end if
        end if

        -- Change d (duration) value
        if (IsKeyPressed(KEY_W) and (d < D_MAX - D_STEP)) 
        then 
            d += D_STEP
        elsif (IsKeyPressed(KEY_Q) and (d > D_MIN + D_STEP)) 
            then
            d -= D_STEP
        end if
        
        if (IsKeyDown(KEY_S) and (d < D_MAX - D_STEP_FINE)) 
        then 
            d += D_STEP_FINE
        elsif (IsKeyDown(KEY_A) and (d > D_MIN + D_STEP_FINE))  
        then 
            d -= D_STEP_FINE
        end if
        -- Play, pause and restart controls
        if (IsKeyPressed(KEY_SPACE) or IsKeyPressed(KEY_T) or
            IsKeyPressed(KEY_RIGHT) or IsKeyPressed(KEY_LEFT) or
            IsKeyPressed(KEY_DOWN) or IsKeyPressed(KEY_UP) or
            IsKeyPressed(KEY_W) or IsKeyPressed(KEY_Q) or
            IsKeyDown(KEY_S)  or IsKeyDown(KEY_A) or
            (IsKeyPressed(KEY_ENTER) and (boundedT = true) and (t >= d)))
        then
            t = 0.0
            ballPosition[x] = 100.0
            ballPosition[y] = 100.0
            paused = true
        end if

        if (IsKeyPressed(KEY_ENTER)) 
        then 
            paused = not paused 
        end if

        -- Movement computation
        if (not(paused) and ((boundedT and t < d) or not(boundedT)))
        then
            ballPosition[x] = call_func(easings[easingX][2],{t, 100.0, 700.0 - 170.0, d})
            ballPosition[y] = call_func(easings[easingY][2],{t, 100.0, 400.0 - 170.0, d})
            t += 1.0
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            -- Draw information text
            DrawText(sprintf("Easing x: %s", {easings[easingX][1]}), 20, FONT_SIZE, FONT_SIZE, LIGHTGRAY)
            DrawText(sprintf("Easing y: %s", {easings[easingY][1]}), 20, FONT_SIZE*2, FONT_SIZE, LIGHTGRAY)
            if boundedT 
            then
                DrawText(sprintf("t (%s) = %.2d d = %.2d",{'b', t, d} ), 20, FONT_SIZE*3, FONT_SIZE, LIGHTGRAY)
            else
                DrawText(sprintf("t (%s) = %.2d d = %.2d", { 'u', t, d}), 20, FONT_SIZE*3, FONT_SIZE, LIGHTGRAY)
            end if
            -- Draw instructions text
            DrawText("Use ENTER to play or pause movement, use SPACE to restart", 20, GetScreenHeight() - FONT_SIZE*2, FONT_SIZE, LIGHTGRAY)
            DrawText("Use Q and W or A and S keys to change duration", 20, GetScreenHeight() - FONT_SIZE*3, FONT_SIZE, LIGHTGRAY)
            DrawText("Use LEFT or RIGHT keys to choose easing for the x axis", 20, GetScreenHeight() - FONT_SIZE*4, FONT_SIZE, LIGHTGRAY)
            DrawText("Use UP or DOWN keys to choose easing for the y axis", 20, GetScreenHeight() - FONT_SIZE*5, FONT_SIZE, LIGHTGRAY)

            -- Draw ball
            DrawCircleV(ballPosition, 16.0, MAROON)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()
    ----------------------------------------------------------------------------------------





