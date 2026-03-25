/*******************************************************************************************
*
*   raylib [audio] example - sound multi
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.0
*
*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023-2025 Jeffery Myers (@JeffM2501)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

constant MAX_SOUNDS =10
sequence soundArray=repeat(Tsound,MAX_SOUNDS)
integer currentSound

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - sound multi")

    InitAudioDevice()       -- Initialize audio device

    -- Load audio file into the first slot as the 'source' sound,
    -- this sound owns the sample data
    soundArray[1] = LoadSound("resources/sound.wav")

    -- Load an alias of the sound into slots 1-9. These do not own the sound data, but can be played
    for  i = 2 to MAX_SOUNDS 
    do
        soundArray[i] = LoadSoundAlias(soundArray[1])
    end for
    currentSound = 1                -- Set the sound list to the start

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_SPACE))
        then
            PlaySound(soundArray[currentSound]) -- Play the next open sound slot
            currentSound+=1                         -- Increment the sound slot

            -- If the sound slot is out of bounds, go back to 0
            if (currentSound >= MAX_SOUNDS) then currentSound = 1 end if

            -- NOTE: Another approach would be to look at the list for the first sound
            -- that is not playing and use that slot
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            DrawText("Press SPACE to PLAY a WAV sound!", 200, 180, 20, LIGHTGRAY)
            DrawText(TextFormat("Now playing Slot : %i",currentSound), 300, 200, 20, LIGHTGRAY)
        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    for  i = 2 to  MAX_SOUNDS
    do
        UnloadSoundAlias(soundArray[i]) -- Unload sound aliases
    end for
    UnloadSound(soundArray[1]) -- Unload source sound data

    CloseAudioDevice()  -- Close audio device

    CloseWindow()           -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


