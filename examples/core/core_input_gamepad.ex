/*******************************************************************************************
*
*   raylib [core] example - input gamepad
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   NOTE: This example requires a Gamepad connected to the system
*         raylib is configured to work with the following gamepads:
*                - Xbox 360 Controller (Xbox 360, Xbox One)
*                - PLAYSTATION(R)3 Controller
*         Check raylib.h for buttons configuration
*
*   Example originally created with raylib 1.1, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

-- NOTE: Gamepad name ID depends on drivers and OS
constant XBOX_ALIAS_1 = "xbox"
constant XBOX_ALIAS_2 = "x-box"
constant PS_ALIAS_1 = "playstation"
constant PS_ALIAS_2 = "sony"

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    SetConfigFlags(FLAG_MSAA_4X_HINT)   -- Set MSAA 4X hint before windows creation

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input gamepad")

    sequence texPs3Pad = LoadTexture("resources/ps3.png")
    sequence texXboxPad = LoadTexture("resources/xbox.png")

    -- Set axis deadzones
    constant  leftStickDeadzoneX = 0.1
    constant  leftStickDeadzoneY = 0.1 
    constant  rightStickDeadzoneX = 0.1 
    constant  rightStickDeadzoneY = 0.1 
    constant  leftTriggerDeadzone = -0.9 
    constant  rightTriggerDeadzone = -0.9 
    enum x,y
    sequence vibrateButton 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    integer gamepad = 0  -- which gamepad to display

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_LEFT) and gamepad > 0) then gamepad-=1 end if 
        if (IsKeyPressed(KEY_RIGHT)) then gamepad+=1 end if 
        if gamepad>3 then gamepad=0 end if  --limit to 4 gamepads
        sequence mousePosition = GetMousePosition() 

        vibrateButton = { 10, 70.0 + 20*GetGamepadAxisCount(gamepad) + 20, 75, 24 } 
        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT) and CheckCollisionPointRec(mousePosition, vibrateButton)) 
        then 
            SetGamepadVibration(gamepad, 1.0, 1.0, 1.0) 
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            if (IsGamepadAvailable(gamepad))
            then
                DrawText(TextFormat("GP%d: %s", {gamepad, GetGamepadName(gamepad)}), 10, 10, 10, BLACK) 

                -- Get axis values
                atom leftStickX = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_X) 
                atom leftStickY = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_Y) 
                atom rightStickX = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_RIGHT_X) 
                atom rightStickY = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_RIGHT_Y) 
                atom leftTrigger = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_TRIGGER) 
                atom rightTrigger = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_RIGHT_TRIGGER) 

                -- Calculate deadzones
                if (leftStickX > -leftStickDeadzoneX and leftStickX < leftStickDeadzoneX) then leftStickX = 0.0 end if 
                if (leftStickY > -leftStickDeadzoneY and leftStickY < leftStickDeadzoneY) then leftStickY = 0.0 end if
                if (rightStickX > -rightStickDeadzoneX and rightStickX < rightStickDeadzoneX) then rightStickX = 0.0 end if
                if (rightStickY > -rightStickDeadzoneY and rightStickY < rightStickDeadzoneY) then rightStickY = 0.0 end if
                if (leftTrigger < leftTriggerDeadzone) then leftTrigger = -1.0 end if
                if (rightTrigger < rightTriggerDeadzone) then rightTrigger = -1.0 end if

                if ((TextFindIndex(TextToLower(GetGamepadName(gamepad)), XBOX_ALIAS_1) > -1) or
                    (TextFindIndex(TextToLower(GetGamepadName(gamepad)), XBOX_ALIAS_2) > -1))
                then
                    DrawTexture(texXboxPad, 0, 0, DARKGRAY) 

                    -- Draw buttons: xbox home
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE)) then DrawCircle(394, 89, 19, RED) end if

                    -- Draw buttons: basic
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_RIGHT)) then DrawCircle(436, 150, 9, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_LEFT)) then DrawCircle(352, 150, 9, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_LEFT)) then DrawCircle(501, 151, 15, BLUE) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_DOWN)) then DrawCircle(536, 187, 15, LIME) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) then DrawCircle(572, 151, 15, MAROON) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_UP)) then DrawCircle(536, 115, 15, GOLD) end if

                    -- Draw buttons: d-pad
                    DrawRectangle(317, 202, 19, 71, BLACK) 
                    DrawRectangle(293, 228, 69, 19, BLACK) 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_UP)) then DrawRectangle(317, 202, 19, 26, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_DOWN)) then DrawRectangle(317, 202 + 45, 19, 26, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_LEFT)) then DrawRectangle(292, 228, 25, 19, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_RIGHT)) then DrawRectangle(292 + 44, 228, 26, 19, RED) end if

                    -- Draw buttons: left-right back
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_TRIGGER_1)) then DrawCircle(259, 61, 20, RED) end if 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_TRIGGER_1))then  DrawCircle(536, 61, 20, RED) end if

                    -- Draw axis: left joystick
                    sequence leftGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_THUMB)) then leftGamepadColor = RED end if 
                    DrawCircle(259, 152, 39, BLACK) 
                    DrawCircle(259, 152, 34, LIGHTGRAY) 
                    DrawCircle(259 +  (leftStickX*20), 152 +  (leftStickY*20), 25, leftGamepadColor) 

                    -- Draw axis: right joystick
                    sequence rightGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_THUMB)) then rightGamepadColor = RED end if 
                    DrawCircle(461, 237, 38, BLACK) 
                    DrawCircle(461, 237, 33, LIGHTGRAY) 
                    DrawCircle(461 +  (rightStickX*20), 237 +  (rightStickY*20), 25, rightGamepadColor) 

                    -- Draw axis: left-right triggers
                    DrawRectangle(170, 30, 15, 70, GRAY) 
                    DrawRectangle(604, 30, 15, 70, GRAY) 
                    DrawRectangle(170, 30, 15,  (((1 + leftTrigger)/2)*70), RED) 
                    DrawRectangle(604, 30, 15,  (((1 + rightTrigger)/2)*70), RED) 

                    --DrawText(TextFormat("Xbox axis LT: %02.02f", GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_TRIGGER)), 10, 40, 10, BLACK) 
                    --DrawText(TextFormat("Xbox axis RT: %02.02f", GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_RIGHT_TRIGGER)), 10, 60, 10, BLACK) 
                
                elsif ((TextFindIndex(TextToLower(GetGamepadName(gamepad)), PS_ALIAS_1) > -1) or
                         (TextFindIndex(TextToLower(GetGamepadName(gamepad)), PS_ALIAS_2) > -1))
                then
                    DrawTexture(texPs3Pad, 0, 0, DARKGRAY) 

                    -- Draw buttons: ps
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE)) then DrawCircle(396, 222, 13, RED) end if

                    -- Draw buttons: basic
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_LEFT)) then DrawRectangle(328, 170, 32, 13, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_RIGHT)) then DrawTriangle({ 436, 168 },{ 436, 185 },{ 464, 177 }, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_UP)) then DrawCircle(557, 144, 13, LIME) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) then DrawCircle(586, 173, 13, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_DOWN)) then DrawCircle(557, 203, 13, VIOLET) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_LEFT)) then DrawCircle(527, 173, 13, PINK) end if

                    -- Draw buttons: d-pad
                    DrawRectangle(225, 132, 24, 84, BLACK) 
                    DrawRectangle(195, 161, 84, 25, BLACK) 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_UP)) then DrawRectangle(225, 132, 24, 29, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_DOWN)) then DrawRectangle(225, 132 + 54, 24, 30, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_LEFT)) then DrawRectangle(195, 161, 30, 25, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_RIGHT)) then DrawRectangle(195 + 54, 161, 30, 25, RED) end if

                    -- Draw buttons: left-right back buttons
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_TRIGGER_1)) then DrawCircle(239, 82, 20, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_TRIGGER_1)) then DrawCircle(557, 82, 20, RED) end if

                    -- Draw axis: left joystick
                    sequence leftGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_THUMB)) then leftGamepadColor = RED end if 
                    DrawCircle(319, 255, 35, BLACK) 
                    DrawCircle(319, 255, 31, LIGHTGRAY) 
                    DrawCircle(319 +  (leftStickX*20), 255 +  (leftStickY*20), 25, leftGamepadColor) 

                    -- Draw axis: right joystick
                    sequence rightGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_THUMB)) then rightGamepadColor = RED end if
                    DrawCircle(475, 255, 35, BLACK) 
                    DrawCircle(475, 255, 31, LIGHTGRAY) 
                    DrawCircle(475 +  (rightStickX*20), 255 +  (rightStickY*20), 25, rightGamepadColor) 

                    -- Draw axis: left-right triggers
                    DrawRectangle(169, 48, 15, 70, GRAY) 
                    DrawRectangle(611, 48, 15, 70, GRAY) 
                    DrawRectangle(169, 48, 15,  (((1 + leftTrigger)/2)*70), RED) 
                    DrawRectangle(611, 48, 15,  (((1 + rightTrigger)/2)*70), RED) 
                
                else
                
                    -- Draw background: generic
                    DrawRectangleRounded({ 175, 110, 460, 220}, 0.3, 16, DARKGRAY) 

                    -- Draw buttons: basic
                    DrawCircle(365, 170, 12, RAYWHITE) 
                    DrawCircle(405, 170, 12, RAYWHITE) 
                    DrawCircle(445, 170, 12, RAYWHITE) 
                    DrawCircle(516, 191, 17, RAYWHITE) 
                    DrawCircle(551, 227, 17, RAYWHITE) 
                    DrawCircle(587, 191, 17, RAYWHITE) 
                    DrawCircle(551, 155, 17, RAYWHITE) 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_LEFT)) then DrawCircle(365, 170, 10, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE)) then DrawCircle(405, 170, 10, GREEN) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_MIDDLE_RIGHT)) then DrawCircle(445, 170, 10, BLUE) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_LEFT)) then DrawCircle(516, 191, 15, GOLD) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_DOWN)) then DrawCircle(551, 227, 15, BLUE) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) then DrawCircle(587, 191, 15, GREEN) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_FACE_UP)) then DrawCircle(551, 155, 15, RED) end if

                    -- Draw buttons: d-pad
                    DrawRectangle(245, 145, 28, 88, RAYWHITE) 
                    DrawRectangle(215, 174, 88, 29, RAYWHITE) 
                    DrawRectangle(247, 147, 24, 84, BLACK) 
                    DrawRectangle(217, 176, 84, 25, BLACK) 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_UP)) then DrawRectangle(247, 147, 24, 29, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_DOWN)) then DrawRectangle(247, 147 + 54, 24, 30, RED) end if 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_LEFT)) then DrawRectangle(217, 176, 30, 25, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_FACE_RIGHT)) then DrawRectangle(217 + 54, 176, 30, 25, RED) end if

                    -- Draw buttons: left-right back
                    DrawRectangleRounded({ 215, 98, 100, 10}, 0.5, 16, DARKGRAY) 
                    DrawRectangleRounded({ 495, 98, 100, 10}, 0.5, 16, DARKGRAY) 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_TRIGGER_1)) then DrawRectangleRounded({ 215, 98, 100, 10}, 0.5, 16, RED) end if
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_TRIGGER_1)) then DrawRectangleRounded({ 495, 98, 100, 10}, 0.5, 16, RED) end if

                    -- Draw axis: left joystick
                    sequence leftGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_LEFT_THUMB)) then  leftGamepadColor = RED end if
                    DrawCircle(345, 260, 40, BLACK) 
                    DrawCircle(345, 260, 35, LIGHTGRAY) 
                    DrawCircle(345 +  (leftStickX*20), 260 +  (leftStickY*20), 25, leftGamepadColor) 

                    -- Draw axis: right joystick
                    sequence rightGamepadColor = BLACK 
                    if (IsGamepadButtonDown(gamepad, GAMEPAD_BUTTON_RIGHT_THUMB)) then rightGamepadColor = RED end if
                    DrawCircle(465, 260, 40, BLACK) 
                    DrawCircle(465, 260, 35, LIGHTGRAY) 
                    DrawCircle(465 +  (rightStickX*20), 260 +  (rightStickY*20), 25, rightGamepadColor) 

                    -- Draw axis: left-right triggers
                    DrawRectangle(151, 110, 15, 70, GRAY) 
                    DrawRectangle(644, 110, 15, 70, GRAY) 
                    DrawRectangle(151, 110, 15,  (((1 + leftTrigger)/2)*70), RED) 
                    DrawRectangle(644, 110, 15,  (((1 + rightTrigger)/2)*70), RED) 
                end if

                DrawText(TextFormat("DETECTED AXIS [%i]:", GetGamepadAxisCount(gamepad)), 10, 50, 10, MAROON) 

                for  i = 0 to  GetGamepadAxisCount(gamepad)
                do
                    DrawText(TextFormat("AXIS %i: %.02f", {i, GetGamepadAxisMovement(gamepad, i)}), 20, 70 + 20*i, 10, DARKGRAY) 
                end for

                -- Draw vibrate button
                DrawRectangleRec(vibrateButton, SKYBLUE) 
                DrawText("VIBRATE",  (vibrateButton[x] + 14),  (vibrateButton[y] + 1), 10, DARKGRAY) 

                if (GetGamepadButtonPressed() != GAMEPAD_BUTTON_UNKNOWN) 
                then 
                    DrawText(TextFormat("DETECTED BUTTON: %i", GetGamepadButtonPressed()), 10, 430, 10, RED) 
                else 
                    DrawText("DETECTED BUTTON: NONE", 10, 430, 10, GRAY) 
                end if
            else
                DrawText(TextFormat("GP%d: NOT DETECTED", gamepad), 10, 10, 10, GRAY) 
                DrawTexture(texXboxPad, 0, 0, LIGHTGRAY) 
            end if

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadTexture(texPs3Pad) 
    UnloadTexture(texXboxPad) 

    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


