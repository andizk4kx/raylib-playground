/*******************************************************************************************
*
*   raylib [audio] example - sound positioning
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.5
*
*   Example contributed by Le Juez Victor (@Bigfoot71) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Le Juez Victor (@Bigfoot71)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--#include "raymath.h"

--------------------------------------------------------------------------------------
-- Module Functions Declaration
--------------------------------------------------------------------------------------
--/**/forward procedure SetSoundPosition(sequence   listener, sequence  sound_, sequence  spherepos, atom  maxDist)

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450
    enum position_,target,up,fovy,projection
    InitWindow(screenWidth, screenHeight, "raylib [audio] example - sound positioning")

    InitAudioDevice()

    sequence sound_ = LoadSound("resources/coin.wav")
    sequence camera = Tcamera3D
    
    camera[position_] =  { 0, 5, 5 }
    camera[target] = { 0, 0, 0 }
    camera[up] = { 0, 1, 0 }
    camera[fovy] = 60
    camera[projection] = CAMERA_PERSPECTIVE


    --DisableCursor()

    SetTargetFPS(60)
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())
    do
        -- Update
        ------------------------------------------------------------------------------------
        camera=UpdateCamera(camera, CAMERA_FREE)

        atom th = GetTime()

        sequence spherePos = {5.0*cos(th),0.0,5.0*sin(th)}

        SetSoundPosition(camera, sound_, spherePos, 2.0)

        if not(IsSoundPlaying(sound_)) then PlaySound(sound_) end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            BeginMode3D(camera)
                DrawGrid(10, 2)
                DrawSphere(spherePos, 0.5, RED)
            EndMode3D()

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    UnloadSound(sound_)
    CloseAudioDevice()  -- Close audio device

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------
-- Module Functions Definition
--------------------------------------------------------------------------------------
-- Set sound 3d position
procedure SetSoundPosition(sequence  listener, sequence  sound_, sequence  spherepos, atom  maxDist)

    -- Calculate direction vector and distance between listener and sound source
    sequence direction = Vector3Subtract(spherepos, listener[position_])
    atom distance = Vector3Length(direction)

    -- Apply logarithmic distance attenuation and clamp between 0-1
    atom attenuation = 1.0/(1.0 + (distance/maxDist))
    attenuation = Clamp(attenuation, 0.0, 1.0)

    -- Calculate normalized vectors for spatial positioning
    sequence normalizedDirection = Vector3Normalize(direction)
    sequence forward_ = Vector3Normalize(Vector3Subtract(listener[target], listener[position_]))
    sequence right = Vector3Normalize(Vector3CrossProduct(listener[up], forward_))

    -- Reduce volume for sounds behind the listener
    atom dotProduct = Vector3DotProduct(forward_, normalizedDirection)
    if (dotProduct < 0.0) then attenuation *= (1.0 + dotProduct*0.5) end if

    -- Set stereo panning based on sound position relative to listener
    atom pan = 0.5 + 0.5*Vector3DotProduct(normalizedDirection, right)

    -- Apply final sound properties
    SetSoundVolume(sound_, attenuation)
    SetSoundPan(sound_, pan)
end procedure
