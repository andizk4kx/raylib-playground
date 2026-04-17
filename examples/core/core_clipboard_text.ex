/*******************************************************************************************
*
*   raylib [core] example - clipboard text
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 6.0, last time updated with raylib 6.0
*
*   Example contributed by Ananth S (@Ananth1839) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Ananth S (@Ananth1839)
*
********************************************************************************************/
--adapted to Phix/Euphoria 2026 Andreas Wagner
include "..\\..\\raylib64.e"

--/*
constant true = 1
constant false = 0
--*/

constant MAX_TEXT_SAMPLES = 5

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [core] example - clipboard text")

    -- Define some sample texts
    sequence sampleTexts = {
        "Hello from raylib!",
        "The quick brown fox jumps over the lazy dog",
        "Clipboard operations are useful!",
        "raylib is a simple and easy-to-use library",
        "Copy and paste me!"
        }

    sequence clipboardText = {} 
    sequence inputBuffer = "Hello from raylib!"  -- Random initial string

    -- UI required variables
    integer textBoxEditMode = false 

    integer btnCutPressed = false 
    integer btnCopyPressed = false 
    integer btnPastePressed = false 
    integer btnClearPressed = false 
    integer btnRandomPressed = false 

    -- Set UI style
    GuiSetStyle(DEFAULT, TEXT_SIZE, 20) 
    GuiSetIconScale(2) 

    SetTargetFPS(60)                -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        -- Handle button interactions
        if (btnCutPressed)
        then
            SetClipboardText(inputBuffer) 
            clipboardText = GetClipboardText() 
            inputBuffer = {}  -- Quick solution to clear text
            --memset(inputBuffer, 0, 256)  -- Clear full buffer properly
        end if

        if (btnCopyPressed)
        then
            SetClipboardText(inputBuffer)  -- Copy text to clipboard
            clipboardText = GetClipboardText()  -- Get text from clipboard
        end if

        if (btnPastePressed)
        then
            -- Paste text from clipboard
            clipboardText = GetClipboardText() 
            if length(clipboardText) then inputBuffer=clipboardText end if -- TextCopy(inputBuffer, clipboardText) 
        end if

        if (btnClearPressed)
        then
            inputBuffer = {}  -- Quick solution to clear text
            --memset(inputBuffer, 0, 256)  -- Clear full buffer properly
        end if

        if (btnRandomPressed)
        then
            -- Get random text from sample list
            --TextCopy(inputBuffer, sampleTexts[GetRandomValue(0, MAX_TEXT_SAMPLES - 1)]) 
            inputBuffer=sampleTexts[GetRandomValue(1, MAX_TEXT_SAMPLES)]
        end if

        -- Quick cut/copy/paste with keyboard shortcuts
        if (IsKeyDown(KEY_LEFT_CONTROL) or IsKeyDown(KEY_RIGHT_CONTROL))
        then
            if (IsKeyPressed(KEY_X))
            then
                SetClipboardText(inputBuffer) 
                inputBuffer = {}  -- Quick solution to clear text
            end if

            if (IsKeyPressed(KEY_C)) then SetClipboardText(inputBuffer) clipboardText = GetClipboardText() end  if 

            if (IsKeyPressed(KEY_V))
            then
                clipboardText = GetClipboardText() 
                if length(clipboardText) then inputBuffer=clipboardText end if --if (clipboardText != NULL) TextCopy(inputBuffer, clipboardText) 
            end if
        end if
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

        ClearBackground(RAYWHITE) 

        -- Draw instructions
        {}=GuiLabel({ 50, 20, 700, 36 }, "Use the BUTTONS or KEY SHORTCUTS:") 
        DrawText("[CTRL+X] - CUT | [CTRL+C] COPY | [CTRL+V] | PASTE", 50, 60, 20, MAROON) 

        -- Draw text box
        inputBuffer=(GuiTextBox({ 50, 120, 652, 40 }, {1,inputBuffer}, 256, true))
        
        -- if length(inputBuffer) then textBoxEditMode = not(textBoxEditMode) end if 

        -- Random text button
        btnRandomPressed = GuiButton({ 50 + 652 + 8, 120, 40, 40 }, "#77#") 

        -- Draw buttons
        btnCutPressed = GuiButton({ 50, 180, 158, 40 }, "#17#CUT") 
        btnCopyPressed = GuiButton({ 50 + 165, 180, 158, 40 }, "#16#COPY") 
        btnPastePressed = GuiButton({ 50 + 165*2, 180, 158, 40 }, "#18#PASTE") 
        btnClearPressed = GuiButton({ 50 + 165*3, 180, 158, 40 }, "#143#CLEAR") 

        -- Draw clipboard status
        GuiSetState(STATE_DISABLED) 
        {}=GuiLabel({ 50, 260, 700, 40 }, "Clipboard current text data:") 
        GuiSetStyle(TEXTBOX, TEXT_READONLY, 1) 
        clipboardText=GuiTextBox({ 50, 300, 700, 40 }, {2,clipboardText}, 256, false) 
        GuiSetStyle(TEXTBOX, TEXT_READONLY, 0) 
        {}=GuiLabel({ 50, 360, 700, 40 }, "Try copying text from other applications and pasting here!") 
        GuiSetState(STATE_NORMAL) 

        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


