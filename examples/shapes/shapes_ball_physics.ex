/*******************************************************************************************
*
*   raylib [shapes] example - ball physics
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.6-dev, last time updated with raylib 5.6-dev
*
*   Example contributed by David Buzatto (@davidbuzatto) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 David Buzatto (@davidbuzatto)
*
********************************************************************************************/
--adapted to Euphoria/Phix 2026 Andreas Wagner
include "../../raylib64.e"

--/*
include std/rand.e
constant true=1
constant false=0
--*/

constant MAX_BALLS=5000 -- Maximum quantity of balls

--typedef struct Ball {
--  Vector2 pos;       -- Position
--  Vector2 vel;       -- Velocity
--  Vector2 ppos;      -- Previous position
--  float radius;
--  float friction;   
--  float elasticity;
--  Color color;
--  bool grabbed;
--} Ball;
function hypot(atom x,atom y)
    return sqrt((x*x) + (y*y))
end function
--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------

    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800
    constant screenHeight = 450

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - ball physics")

    sequence Ball  = {{ GetScreenWidth()/2.0, GetScreenHeight()/2.0 },
                      { 200, 200 },
                      { 0,0 },
                      40,0.99,0.9,
                      BLUE,
                      false}
    sequence balls=repeat(Ball,MAX_BALLS)

    enum pos,vel,ppos,radius,friction,elasticity,color,grabbed
    enum x,y
    integer ballCount = 1
    integer grabbedBall = 0 -- A pointer to the current ball that is grabbed
    sequence pressOffset = { 0,0 }  -- Mouse press offset relative to the ball that grabbedd

    atom gravity = 100      -- World gravity

    SetTargetFPS(60)            -- Set our game to run at 60 frames-per-second
    -----------------------------------------------------------------------------------------

    -- Main game loop
    while not WindowShouldClose()   -- Detect window close button or ESC key
    do
        -- Update
        ------------------------------------------------------------------------------------
        atom delta = GetFrameTime()
        sequence mousePos = GetMousePosition()

        -- Checks if a ball was grabbed
        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT))
        then
            
            for  i =  ballCount to 1 by -1  
            do
                --Ball *ball = &balls[i];
                pressOffset[x] = mousePos[x] - balls[i][pos][x]
                pressOffset[y] = mousePos[y] - balls[i][pos][y]

                -- If the distance between the ball position and the mouse press position
                -- is less than or equal to the ball radius, the event occurred inside the ball
                if (hypot(pressOffset[x], pressOffset[y]) <= balls[i][radius])
                then
                    balls[i][grabbed] = true
                    --printf(1,"habe ihn Nummer : %d\n",i)
                    grabbedBall = i
                    exit
                end if
            end for
        end if

        -- Releases any ball the was grabbed
        if (IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) 
        then
            if  grabbedBall >0 then                 
                if (balls[grabbedBall][grabbed]=true)   
                then
                    balls[grabbedBall][grabbed] = false
                    grabbedBall = 0
                end if
            end if
        end if

        -- Creates a new ball
        if (IsMouseButtonPressed(MOUSE_BUTTON_RIGHT) or (IsKeyDown(KEY_LEFT_CONTROL) and IsMouseButtonDown(MOUSE_BUTTON_RIGHT)))
        then
            if (ballCount < MAX_BALLS)
            then
                ballCount+=1
                balls[ballCount] = {mousePos,{rand_range(-300, 300),rand_range(-300, 300) },{0,0},20+rand_range(0,50),0.99,0.9,
                                    { rand_range(0, 255), rand_range(0, 255), rand_range(0, 255), 255 },false}
--                  .pos = mousePos,
--                  .vel = { (float)GetRandomValue(-300, 300), (float)GetRandomValue(-300, 300) },
--                  .ppos = { 0 },
--                  .radius = 20.0f + (float)GetRandomValue(0, 30),
--                  .friction = 0.99f,
--                  .elasticity = 0.9f,
--                  .color = { GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255 },
--                  .grabbed = false
            end if
        end if

        -- Shake balls
        if (IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE))
        then
            for  i = 1 to ballCount
            do
                if (not balls[i][grabbed]) then balls[i][vel] = { rand_range(-2000, 2000), rand_range(-2000, 2000) } end if
            end for
        end if

        -- Changes gravity
        gravity += GetMouseWheelMove()*5

        -- Updates each ball state
        for i = 1 to ballCount
        do
            --Ball *ball = &balls[i];

            -- The ball is not grabbed
            if (balls[i][grabbed]=false)
            then
                -- Ball repositioning using the velocity
                balls[i][pos][x] += balls[i][vel][x] * delta
                balls[i][pos][y] += balls[i][vel][y] * delta

                -- Does the ball hit the screen right boundary?
                if ((balls[i][pos][x] + balls[i][radius]) >= screenWidth)
                then
                    balls[i][pos][x] = screenWidth - balls[i][radius] -- Ball repositioning
                    balls[i][vel][x] = -balls[i][vel][x]*balls[i][elasticity]  -- Elasticity makes the ball lose 10% of its velocity on hit
                 
                -- Does the ball hit the screen left boundary?
                elsif ((balls[i][pos][x] - balls[i][radius]) <= 0)
                then
                    balls[i][pos][x] = balls[i][radius]
                    balls[i][vel][x] = -balls[i][vel][x]*balls[i][elasticity]
                end if

                -- The same for y axis
                if ((balls[i][pos][y] + balls[i][radius]) >= screenHeight)
                then
                    balls[i][pos][y] = screenHeight - balls[i][radius]
                    balls[i][vel][y] = -balls[i][vel][y]*balls[i][elasticity]
                 
                elsif ((balls[i][pos][y] - balls[i][radius]) <= 0)
                then
                    balls[i][pos][y] = balls[i][radius]
                    balls[i][vel][y] = -balls[i][vel][y]*balls[i][elasticity]
                end if

                -- Friction makes the ball lose 1% of its velocity each frame
                balls[i][vel][x] = balls[i][vel][x]*balls[i][friction]
                -- Gravity affects only the y axis
                balls[i][vel][y] = balls[i][vel][y]*balls[i][friction] + gravity
            
            else
                --mousePos=GetMousePosition()
                -- Ball repositioning using the mouse position
                balls[i][pos][x] = mousePos[x] -pressOffset[x]
                balls[i][pos][y] = mousePos[y] - pressOffset[y]

                -- While the ball is grabbed, recalculates its velocity
                balls[i][vel][x] = (balls[i][pos][x] - balls[i][ppos][x])/delta
                balls[i][vel][y] = (balls[i][pos][y] - balls[i][ppos][y])/delta
                balls[i][ppos] = balls[i][pos]
            end if
        end for
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing()

            ClearBackground(RAYWHITE)

            for  i = 1 to ballCount
            do
                DrawCircleV(balls[i][pos], balls[i][radius], balls[i][color])
                DrawCircleLinesV(balls[i][pos], balls[i][radius], BLACK)
            end for

            DrawText("grab a ball by pressing with the mouse and throw it by releasing", 10, 10, 10, DARKGRAY)
            DrawText("right click to create new balls (keep left control pressed to create a lot)", 10, 30, 10, DARKGRAY)
            DrawText("use mouse wheel to change gravity", 10, 50, 10, DARKGRAY)
            DrawText("middle click to shake", 10, 70, 10, DARKGRAY)
            DrawText(sprintf("BALL COUNT: %d", ballCount), 10, GetScreenHeight() - 70, 20, BLACK)
            DrawText(sprintf("GRAVITY: %.2f", gravity), 10, GetScreenHeight() - 40, 20, BLACK)

        EndDrawing()
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()     -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------


