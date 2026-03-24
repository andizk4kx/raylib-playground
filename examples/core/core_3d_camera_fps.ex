 
/*******************************************************************************************
*
*   raylib [core] example - 3d camera fps
*
*   Example complexity rating: [] 3/4
*
*   Example originally created with raylib 5.5, last time updated with raylib 5.5
*
*   Example contributed by Agnis Aldins (@nezvers) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Agnis Aldins (@nezvers)
*
********************************************************************************************/

include "../../raylib64.e"
--/*
include std/math.e
integer true=1
integer false=0
constant PI1=3.14159265358979323846
--*/
--#include "raymath.h"
--/**/atom PI1=PI
------------------------------------------------------------------------------------
-- Defines and Macros
------------------------------------------------------------------------------------
-- Movement constants
constant GRAVITY        =32.0
constant MAX_SPEED      =20.0
constant CROUCH_SPEED    =5.0
constant JUMP_FORCE     =12.0
constant MAX_ACCEL     =150.0
-- Grounded drag
constant FRICTION       = 0.86
-- Increasing air drag, increases strafing speed
constant AIR_DRAG       = 0.98
-- Responsiveness for turning movement direction to looked direction
constant CONTROL    = 15.0
constant CROUCH_HEIGHT  = 0.0
constant STAND_HEIGHT   = 1.0
constant BOTTOM_HEIGHT  = 0.5

constant NORMALIZE_INPUT = 0

------------------------------------------------------------------------------------
-- Types and Structures Definition
------------------------------------------------------------------------------------
-- Body structure
--typedef struct {
--  Vector3 position 
--  Vector3 velocity 
--  Vector3 dir 
--  bool isGrounded 
--} Body 
sequence Tbody={{0,0,0},{0,0,0},{0,0,0},0}
enum _position,velocity,_dir,isGrounded --enum player/body
enum position_,target,fovy=4,projection=5 --enum camera
enum x,y,z
------------------------------------------------------------------------------------
-- Global Variables Definition
------------------------------------------------------------------------------------
constant sensitivity = { 0.001, 0.001 } 

sequence  player = Tbody 
sequence lookRotation = { 0,0 } 
atom  headTimer = 0.0 
atom  walkLerp = 0.0 
atom  headLerp = STAND_HEIGHT 
sequence lean = { 0,0 } 

------------------------------------------------------------------------------------
-- Module Functions Declaration
------------------------------------------------------------------------------------
--/**/forward procedure DrawLevel() 
--/**/forward function UpdateCameraFPS(sequence camera) 
--/**/forward function UpdateBody(sequence  body, atom  rot, integer  side, integer  forward_, integer  jumpPressed, integer  crouchHold) 

--------------------------------------------------------------------------------------
-- Program main entry point
--------------------------------------------------------------------------------------


    -- Initialization
    ----------------------------------------------------------------------------------------
    constant screenWidth = 800 
    constant screenHeight = 450 
    
    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera fps") 

    -- Initialize camera variables
    -- NOTE: UpdateCameraFPS() takes care of the rest
    sequence camera = Tcamera3D 
    camera[fovy] = 60.0
    camera[projection] = CAMERA_PERSPECTIVE 
    camera[position_] = {player[_position][x],player[_position][y] + (BOTTOM_HEIGHT + headLerp),player[_position][z]} 

    camera=UpdateCameraFPS(camera)  -- Update camera parameters

    DisableCursor()         -- Limit cursor to relative movement inside the window

    --SetTargetFPS(60)      -- Set our game to run at 60 frames-per-second
    ----------------------------------------------------------------------------------------

    -- Main game loop
    while not(WindowShouldClose())  -- Detect window close button or ESC key
    do  
        -- Update
        ------------------------------------------------------------------------------------
        sequence mouseDelta = GetMouseDelta() 
        lookRotation[x] -= mouseDelta[x]*sensitivity[x] 
        lookRotation[y] += mouseDelta[y]*sensitivity[y] 

        integer sideway = (IsKeyDown(KEY_D) - IsKeyDown(KEY_A)) 
        integer forward_ = (IsKeyDown(KEY_W) - IsKeyDown(KEY_S)) 
        integer crouching = IsKeyDown(KEY_LEFT_CONTROL) 
        player=UpdateBody(player, lookRotation[x], sideway, forward_, IsKeyPressed(KEY_SPACE), crouching) 
        atom HEIGHT
        if crouching 
        then
            HEIGHT=CROUCH_HEIGHT
        else
            HEIGHT=STAND_HEIGHT 
        end if
        
        atom delta = GetFrameTime() 
        headLerp = Lerp(headLerp, HEIGHT, 20.0*delta) 
        camera[position_] = {player[_position][x],player[_position][y] + (BOTTOM_HEIGHT + headLerp),player[_position][z]} 

        if (player[isGrounded] and ((forward_ != 0) or (sideway != 0)))
        then
            headTimer += delta*3.0 
            walkLerp = Lerp(walkLerp, 1.0, 10.0*delta) 
            camera[fovy] = Lerp(camera[fovy], 55.0, 5.0*delta) 
        else
            walkLerp = Lerp(walkLerp, 0.0, 10.0*delta) 
            camera[fovy] = Lerp(camera[fovy], 60.0, 5.0*delta) 
        end if

        lean[x] = Lerp(lean[x], sideway*0.02, 10.0*delta) 
        lean[y] = Lerp(lean[y], forward_*0.015, 10.0*delta) 

        camera=UpdateCameraFPS(camera) 
        ------------------------------------------------------------------------------------

        -- Draw
        ------------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            BeginMode3D(camera) 
                DrawLevel() 
            EndMode3D() 

            -- Draw info box
            DrawRectangle(5, 5, 330, 75, Fade(SKYBLUE, 0.5)) 
            DrawRectangleLines(5, 5, 330, 75, BLUE) 

            DrawText("Camera controls:", 15, 15, 10, BLACK) 
            DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, BLACK) 
            DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK) 
            DrawText(TextFormat("- Velocity Len: (%06.3f)", Vector2Length({ player[velocity][x], player[velocity][z] })), 15, 60, 10, BLACK) 
            DrawFPS(10,420)
        EndDrawing() 
        ------------------------------------------------------------------------------------
    end while

    -- De-Initialization
    ----------------------------------------------------------------------------------------
    CloseWindow()         -- Close window and OpenGL context
    ----------------------------------------------------------------------------------------



------------------------------------------------------------------------------------
-- Module Functions Definition
------------------------------------------------------------------------------------
-- Update body considering current world state
function UpdateBody(sequence  body, atom  rot, integer  side, integer  forward_, integer  jumpPressed, integer  crouchHold)

    sequence input = { side, (-forward_) } 

if (NORMALIZE_INPUT)
then
--  -- Slow down diagonal movement
--/**/  if ((side <> 0) and (forward_ <> 0)) then input = Vector2Normalize(input) end if 
end if

    atom delta = GetFrameTime() 

    if not(body[isGrounded]) then body[velocity][y] -= GRAVITY*delta end if

    if (body[isGrounded] and jumpPressed)
    then
        body[velocity][y] = JUMP_FORCE 
        body[isGrounded] = false 

        -- Sound can be played at this moment
        --SetSoundPitch(fxJump, 1.0f + (GetRandomValue(-100, 100)*0.001)) 
        --PlaySound(fxJump) 
    end if

    sequence front = { sin(rot), 0.0, cos(rot) } 
    sequence right = { cos(-rot), 0.0, sin(-rot) } 

    sequence desiredDir = { input[x]*right[x] + input[y]*front[x], 0.0, input[x]*right[z] + input[y]*front[z] } 
    body[_dir] = Vector3Lerp(body[_dir], desiredDir, CONTROL*delta) 
    atom decel
    if body[isGrounded]
    then
        decel=FRICTION
    else
        decel=AIR_DRAG  
    end if
    

--  atom decel = iff(body[isGrounded] ? FRICTION : AIR_DRAG) 
    sequence hvel = { body[velocity][x]*decel, 0.0, body[velocity][z]*decel } 

    atom hvelLength = Vector3Length(hvel)   -- Magnitude
    if (hvelLength < (MAX_SPEED*0.01)) then hvel = { 0,0,0 } end if

    -- This is what creates strafing
    atom speed = Vector3DotProduct(hvel, body[_dir]) 

    -- Whenever the amount of acceleration to add is clamped by the maximum acceleration constant,
    -- a Player can make the speed faster by bringing the direction closer to horizontal velocity angle
    -- More info here: https:--youtu.be/v3zT3Z5apaM?t=165
    atom maxSpeed
    if crouchHold 
    then
        maxSpeed=CROUCH_SPEED
    else
        maxSpeed=MAX_SPEED  
    end if
    
--  atom maxSpeed = iff(crouchHold? CROUCH_SPEED : MAX_SPEED) 
    atom accel = Clamp(maxSpeed - speed, 0.0, MAX_ACCEL*delta) 
    hvel[x] += body[_dir][x]*accel 
    hvel[z] += body[_dir][z]*accel 

    body[velocity][x] = hvel[x] 
    body[velocity][z] = hvel[z] 

    body[_position][x] += body[velocity][x]*delta 
    body[_position][y] += body[velocity][y]*delta 
    body[_position][z] += body[velocity][z]*delta 

    -- Fancy collision system against the floor
    if (body[_position][y] <= 0.0)
    then
        body[_position][y] = 0.0 
        body[velocity][y] = 0.0
        body[isGrounded] = true  -- Enable jumping
    end if
return body
end function

-- Update camera for FPS behaviour
function UpdateCameraFPS(sequence camera)

    sequence up = { 0.0, 1.0, 0.0 } 
    sequence targetOffset = { 0.0, 0.0, -1.0 } 

    -- Left and right
    sequence yaw = Vector3RotateByAxisAngle(targetOffset, up, lookRotation[x]) 

    -- Clamp view up
    atom maxAngleUp = Vector3Angle(up, yaw) 
    maxAngleUp -= 0.001  -- Avoid numerical errors
    if ( -(lookRotation[y]) > maxAngleUp)  then  lookRotation[y] = -maxAngleUp  end if

    -- Clamp view down
    atom maxAngleDown = Vector3Angle(Vector3Negate(up), yaw) 
    maxAngleDown *= -1.0  -- Downwards angle is negative
    maxAngleDown += 0.001   -- Avoid numerical errors
    if ( -(lookRotation[y]) < maxAngleDown) then  lookRotation[y] = -maxAngleDown  end if

    -- Up and down
    sequence right = Vector3Normalize(Vector3CrossProduct(yaw, up)) 

    -- Rotate view vector around right axis
    atom pitchAngle = -lookRotation[y] - lean[y] 
    pitchAngle = Clamp(pitchAngle, -PI1/2 + 0.0001, PI1/2 - 0.0001)  -- Clamp angle so it doesn't go past straight up or straight down
    sequence pitch = Vector3RotateByAxisAngle(yaw, right, pitchAngle) 

    -- Head animation
    -- Rotate up direction around forward axis
    atom headSin = sin(headTimer*PI1) 
    atom headCos = cos(headTimer*PI1) 
    atom stepRotation = 0.01 
    camera[3] = Vector3RotateByAxisAngle(up, pitch, headSin*stepRotation + lean[x]) 
--  camera[up] = Vector3RotateByAxisAngle(up, pitch, headSin*stepRotation + lean[x]) 
    -- Camera BOB
    atom bobSide = 0.1 
    atom bobUp = 0.15
    sequence bobbing = Vector3Scale(right, headSin*bobSide) 
    bobbing[y] = abs(headCos*bobUp) 

    camera[_position] = Vector3Add(camera[position_], Vector3Scale(bobbing, walkLerp)) 
    camera[target] = Vector3Add(camera[position_], pitch) 
return camera
end function

-- Draw game level
procedure DrawLevel()

    integer floorExtent = 25 
    atom tileSize = 5.0
    sequence tileColor1 = { 150, 200, 200, 255 } 

    -- Floor tiles
    for y = -floorExtent to floorExtent
    do
        for x = -floorExtent to floorExtent
        do
            if ((and_bits(y , 1) and and_bits(x , 1)))
            then
                DrawPlane({ x*tileSize, 0.0, y*tileSize}, { tileSize, tileSize }, tileColor1) 
            elsif (not(and_bits(y , 1)) and not (and_bits(x , 1)))
            then
                DrawPlane({ x*tileSize, 0.0, y*tileSize}, { tileSize, tileSize }, LIGHTGRAY) 
            end if
        end for
    end for

    sequence towerSize = { 16.0, 32.0, 16.0 } 
    sequence towerColor={ 150, 200, 200, 255 } 

    sequence towerPos = { 16.0, 16.0, 16.0 } 
    DrawCubeV(towerPos, towerSize, towerColor) 
    DrawCubeWiresV(towerPos, towerSize, DARKBLUE) 

    towerPos[x] *= -1 
    DrawCubeV(towerPos, towerSize, towerColor) 
    DrawCubeWiresV(towerPos, towerSize, DARKBLUE) 

    towerPos[z] *= -1 
    DrawCubeV(towerPos, towerSize, towerColor) 
    DrawCubeWiresV(towerPos, towerSize, DARKBLUE) 

    towerPos[x] *= -1 
    DrawCubeV(towerPos, towerSize, towerColor) 
    DrawCubeWiresV(towerPos, towerSize, DARKBLUE) 

    -- Red sun
    DrawSphere({ 300.0, 300.0, 0.0 }, 100.0, { 255, 0, 0, 255 }) 
end procedure
