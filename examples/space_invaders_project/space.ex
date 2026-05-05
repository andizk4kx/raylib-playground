without warning
/*
*  see: https://github.com/Memorix101/space_invaders_project
*  Execute with either
*
*  Euphoria eui filename.ex
*  or
*  Phix p64 filename.ex
*
*/
--adapted to Phix/Euphoria 2026 Andreas Wagner
--/*
--include raylib.e
include std/os.e
--*/
include "..\\..\\raylib64.e"

integer screenWidth=1024
integer screenHeight=768

constant Ttexture={0,0,0,0,0}
enum rec_x,rec_y,rec_width,rec_height
enum tex_width=2,tex_height=3
--struct player_t {
--      Rectangle hitbox;
--      Rectangle pos;
--      Texture2D tex;
--      int alive; --bool
--};
sequence player_t={{0,0,0,0},{0,0,0,0},Ttexture,0}
enum play_hit,play_pos,play_tex,play_alive

--struct bullet_t
--{
--      Rectangle hitbox;
--      Rectangle pos;
--      Texture2D tex;
--};
sequence bullet_t={{0,0,0,0},{0,0,0,0},Ttexture}
enum bul_hit,bul_pos,bul_tex

--struct enemy_bullet_t
--{
--      Rectangle hitbox;
--      Rectangle pos;
--      Texture2D tex;
--};
sequence enemy_bullet_t={{0,0,0,0},{0,0,0,0},Ttexture}
enum ene_bul_hit,ene_bul_pos,ene_bul_tex

--struct explo_t
--{
--      Rectangle pos;
--      Rectangle rect;
--      Texture2D tex;
--      int animationFinished; --bool
--      int currentFrame_ex;
--};
sequence explo_t={{0,0,0,0},{0,0,0,0},Ttexture,0,0}
enum exp_pos,exp_rec,exp_tex,exp_ani_fin,exp_cur_fram

--struct enemy_t {
--      Rectangle hitbox;
--      Rectangle pos;
--      Rectangle rect;
--      Texture2D tex;
--      int goLeft; --bool
--      int startPos;
--      int rowPosID;
--      int alive; --bool
--      float shootTimer;
--      int shoot; --bool
--      float shootTimeLimit;
--};
sequence enemy_t={{0,0,0,0},{0,0,0,0},{0,0,0,0},Ttexture,0,0,0,0,0,0,0}
enum ene_hit,ene_pos,ene_rect,ene_tex,ene_gol,ene_spos,ene_rpoid,ene_aliv,ene_stim,ene_sho,ene_stimlim

--base stuff
sequence space
sequence screen

--player
constant MAX_BULLETS = 50
sequence player = player_t
integer p_move

--enemy
constant MAX_ENEMY_BULLETS=100
constant MAX_ENEMIES=40
sequence enemy=repeat(0,MAX_ENEMIES) -- sequence enemy=repeat(enemy_t,MAX_ENEMIES)
integer currentFrame = 0
integer enemies_killed = MAX_ENEMIES

--stuff
sequence bullets=repeat(0,MAX_BULLETS)
sequence enemy_bullets=repeat(0,MAX_ENEMY_BULLETS) -- sequence enemy_bullets=repeat(enemy_bullet_t,MAX_ENEMY_BULLETS)
constant MAX_EXPLO = 100
sequence explo=repeat(0,MAX_EXPLO)
integer rowCount = 0
integer itemCount = 0
atom DeltaTime
atom lastTick=0
integer score = 0
integer gameover = 0

--Music
sequence music
sequence snd_pusher
sequence snd_blaster
sequence snd_explo

sequence enemy_tex
sequence player_tex
sequence bullet_tex
sequence enemy_bullet_tex
sequence explo_tex
sequence fmg_tex
sequence space_tex
sequence gameover_tex
sequence win_tex

sequence vermin_ttf

procedure preload_assets()

        --load tex
        fmg_tex = LoadTexture("rd/fmg_splash.png")
        space_tex = LoadTexture("rd/space3.png")
        enemy_bullet_tex = LoadTexture("rd/enemy-bullet.png")
        enemy_tex = LoadTexture("rd/invader32x32x4.png")
        bullet_tex = LoadTexture("rd/bullet.png")
        player_tex = LoadTexture("rd/player.png")
        explo_tex = LoadTexture("rd/explode.png")
        gameover_tex = LoadTexture("rd/gameover_ui.png")
        win_tex = LoadTexture("rd/win_ui.png")

        --load audio
        music = LoadMusicStream("rd/bodenstaendig.ogg")
        snd_blaster = LoadSound("rd/blaster.ogg")
        snd_explo = LoadSound("rd/explode1.wav")
        snd_pusher = LoadSound("rd/pusher.wav")

        --load font
        vermin_ttf = LoadFontEx("rd/vermin_vibes_1989.ttf", 24, 0, 0)
end procedure

/*
Enemy Bullets enum ene_bul_hit,ene_bul_pos,ene_bul_tex
*/

procedure addEnemyBullet(atom  x, atom  y)

        integer found = -1
        for i = 1 to MAX_ENEMY_BULLETS
        do
                if atom(enemy_bullets[i]) -- ==0
                then
                        found = i
                        exit
                end if
        end for

        if (found >= 1) -- sequence starts with 1
        then
                --printf("Pew Pew!");
                integer i = found
                enemy_bullets[i] = (enemy_bullet_t)
                enemy_bullets[i][ene_bul_tex] = enemy_bullet_tex
                enemy_bullets[i][ene_bul_pos][rec_x] = x
                enemy_bullets[i][ene_bul_pos][rec_y] = y
                enemy_bullets[i][ene_bul_hit][rec_width] = enemy_bullets[i][ene_bul_tex][tex_width]
                enemy_bullets[i][ene_bul_hit][rec_height] = enemy_bullets[i][ene_bul_tex][tex_height]
        end if
end procedure

procedure removeEnemyBullet(integer i)

        if sequence(enemy_bullets[i])
        then
            
                enemy_bullets[i] = 0
        end if
end procedure

procedure updateEnemyBullet()

        --int i;
        for i = 1 to MAX_ENEMY_BULLETS 
        do
            if sequence(enemy_bullets[i])
            then
                enemy_bullets[i][ene_bul_pos][rec_y] += 15

                if (enemy_bullets[i][ene_bul_pos][rec_y] >= screenHeight - 9)
                then
                        removeEnemyBullet(i)
                end if
            end if
        end for
end procedure

procedure drawEnemyBullet()

        --int i;
        for i = 1  to MAX_ENEMY_BULLETS 
        do
            if sequence(enemy_bullets[i])
            then
                DrawTexture(enemy_bullets[i][ene_bul_tex], enemy_bullets[i][ene_bul_pos][rec_x], enemy_bullets[i][ene_bul_pos][rec_y], WHITE)
            end if
        end for
end procedure

/*
Enemies enum ene_hit,ene_pos,ene_rect,ene_tex,ene_gol,ene_spos,ene_rpoid,ene_aliv,ene_stim,ene_sho,ene_stimlim
*/
procedure addEnemy()

        integer found = -1
        for  i = 1 to MAX_ENEMIES
        do
                if atom(enemy[i])
                then
                        found = i
                        exit
                end if
        end for

        if (found >= 1) -- sequence starts with 1
        then
                --printf(1,"GABAAA!!")
                integer i = found
                enemy[i] = enemy_t  --visual studio needs that "stupid" cast to operate >_>
                enemy[i][ene_tex] = enemy_tex --invader32x32x4
                enemy[i][ene_aliv] = 1
                enemy[i][ene_rect][rec_height] = 32
                enemy[i][ene_rect][rec_width] = 32
                enemy[i][ene_rect][rec_x] = 0
                enemy[i][ene_rect][rec_y] = 0
                enemy[i][ene_pos][rec_x] = itemCount * 40
                enemy[i][ene_pos][rec_y] = 40 * rowCount
                enemy[i][ene_spos] = enemy[i][ene_pos][rec_x]
                enemy[i][ene_rpoid] = 40 * (11 - itemCount)
                enemy[i][ene_gol] = 0
                enemy[i][ene_hit][rec_width] = enemy[i][ene_rect][rec_width]
                enemy[i][ene_hit][rec_height] = enemy[i][ene_rect][rec_height]
                enemy[i][ene_hit][rec_x] = enemy[i][ene_pos][rec_x]
                enemy[i][ene_hit][rec_y] = enemy[i][ene_pos][rec_y]
                enemy[i][ene_sho] = 0
                enemy[i][ene_stim] = 0
                enemy[i][ene_stimlim] = GetRandomValue(5,25) --CHECK  -- =(rand() % (20 - 3)) + 3; -- MAX - MIN + MIN
        end if
end procedure

procedure initEnemies()
-- itemCount=0
-- rowCount=0
for i=0 to MAX_ENEMIES-1 do
    if remainder(i, 10) = 0 
    then
        -- printf(1, "new row\n") 
        itemCount = 0
        rowCount += 1
    end if

    itemCount += 1
    addEnemy()
end for
end procedure



procedure animatorEnemies()
    currentFrame += 1
    
    if currentFrame >= 4 then
        currentFrame = 0
    end if

    for e=1 to MAX_ENEMIES do
        if sequence(enemy[e])
         then
            enemy[e][ene_rect][rec_x] = currentFrame * 32
        end if
    end for
end procedure

-- enum ene_hit,ene_pos,ene_rect,ene_tex,ene_gol,ene_spos,ene_rpoid,ene_aliv,ene_stim,ene_sho,ene_stimlim

procedure updateEnemies()

        animatorEnemies()

        integer moveSpeed = 2

        --int e;
        
    for e = 1 to MAX_ENEMIES 
    do
        if sequence(enemy[e]) 
        then
                if (enemy[e][ene_gol] = 0)
                then
                        enemy[e][ene_pos][rec_x] += moveSpeed
                end if

                if (enemy[e][ene_gol] = 1)
                then
                        enemy[e][ene_pos][rec_x] -= moveSpeed
                end if

                if ((enemy[e][ene_pos][rec_x] >= (screenWidth - (enemy[e][ene_rect][rec_width] + enemy[e][ene_rpoid]))) and (enemy[e][ene_gol] = 0))
                then
                        enemy[e][ene_gol] = 1
                end if
                --CHECK the +32
                if ((enemy[e][ene_pos][rec_x]+32 <= (enemy[e][ene_spos] + enemy[e][ene_rect][rec_width])) and (enemy[e][ene_gol] = 1))
                then
                        enemy[e][ene_gol] = 0
                end if

                enemy[e][ene_stim] += 1 * DeltaTime --CHECK 

                /*
                c = enemy[1]->shootTimer += 1 * DeltaTime;;
                printf("%0.8f\n", c);
                */

                if (enemy[e][ene_stim] >= enemy[e][ene_stimlim])
                then
                        enemy[e][ene_stim] = 0
                        enemy[e][ene_sho] = 1
                else
                        enemy[e][ene_sho] = 0
                end if

                if ((enemy[e][ene_sho] = 1) and (enemy[e][ene_aliv] = 1))
                then
                        addEnemyBullet(enemy[e][ene_pos][rec_x] + enemy[e][ene_rect][rec_width] / 2 - 4, enemy[e][ene_pos][rec_y] - 4)
                        PlaySound(snd_pusher)
                end if

                enemy[e][ene_hit][rec_x] = enemy[e][ene_pos][rec_x]
                enemy[e][ene_hit][rec_y] = enemy[e][ene_pos][rec_y]
        end if
    end for 
end procedure

procedure drawEnemies()

        --int e;
        for e = 1 to MAX_ENEMIES 
        do
            if sequence(enemy[e]) 
            then
                if (enemy[e][ene_aliv] = 1) 
                then
                        --SDL_FillRect(screen, &enemy[e]->hitbox, SDL_MapRGB(screen->format, 255, 0, 0));

                        sequence pos = { enemy[e][ene_pos][rec_x], enemy[e][ene_pos][rec_y] }
                        DrawTextureRec(enemy[e][ene_tex], enemy[e][ene_rect], pos, WHITE)
                end if
            end if
        end for
end procedure

/*
Player enum play_hit,play_pos,play_tex,play_alive
*/

procedure initPlayer()

        player[play_tex] = player_tex
        p_move = screenWidth / 2 - player[play_tex][tex_width] / 2
        player[play_pos][rec_y] = (screenHeight - 60) - player[play_tex][tex_height] / 2
        player[play_hit][rec_width] = player[play_tex][tex_width]
        player[play_hit][rec_height] = player[play_tex][tex_height]
        player[play_hit][rec_x] = player[play_pos][rec_x]
        player[play_hit][rec_y] = player[play_pos][rec_y]
        player[play_alive] = 1
end procedure

procedure input()

        --continuous-response keys
        if (IsKeyDown(KEY_RIGHT))
        then
                p_move += 15
        
        elsif (IsKeyDown(KEY_LEFT))
        then
                p_move -= 15
        end if

end procedure

procedure updatePlayer()

        input()

        player[play_pos][rec_x] = p_move

        player[play_hit][rec_x] = player[play_pos][rec_x]
        player[play_hit][rec_y] = player[play_pos][rec_y]

        if (player[play_pos][rec_x] <= 0)
        then
                player[play_pos][rec_x] = 0
        
        elsif (player[play_pos][rec_x] >= screenWidth - player[play_tex][tex_height])
        then
                player[play_pos][rec_x] = screenWidth - player[play_tex][tex_width]
        end if
end procedure

/*
Bullet --enum bul_hit,bul_pos,bul_tex
*/

procedure addBullet(atom  x, atom  y)

        integer found = -1
        for  i = 1 to MAX_BULLETS
        do
                if atom(bullets[i])
                then
                        found = i
                        exit
                end if
        end for

        if (found >= 1)
        then
                --printf(1,"BULLET\n")
                integer i = found
                bullets[i] = bullet_t
                bullets[i][bul_tex] = bullet_tex
                bullets[i][bul_pos][rec_x] = x
                bullets[i][bul_pos][rec_y] = y
                bullets[i][bul_hit][rec_width] = 6
                bullets[i][bul_hit][rec_height] = 36
        end if
end procedure

procedure removeBullet(integer i)

        if sequence(bullets[i])
        then
                --free(bullets[i])
                bullets[i] = 0
        end if
end procedure

procedure updateBullet()

        --integer i
        for i = 1 to MAX_BULLETS 
        do
            if sequence(bullets[i])
            then
                bullets[i][bul_pos][rec_y] -= 15

                if (bullets[i][bul_pos][rec_y] <= 0)
                then
                        removeBullet(i)
                end if
            end if
        end for
end procedure

procedure drawBullet()

        --integer i;
        for i = 1 to MAX_BULLETS 
        do
            if sequence(bullets[i])
            then
                DrawTexture(bullets[i][bul_tex], bullets[i][bul_pos][rec_x], bullets[i][bul_pos][rec_y], WHITE)
            end if
        end for
end procedure

/*
Explosion --enum exp_pos,exp_rec,exp_tex,exp_ani_fin,exp_cur_fram
*/

procedure addExplo(atom  x, atom  y)

        integer found = -1
        for i = 1 to MAX_EXPLO
        do
                if atom(explo[i])
                then
                        found = i
                        exit
                end if
        end for

        if (found >= 1)
        then
                integer i = found
                explo[i] = explo_t
                explo[i][exp_tex] = explo_tex
                explo[i][exp_pos][rec_x] = x
                explo[i][exp_pos][rec_y] = y
                explo[i][exp_rec][rec_width] = 128
                explo[i][exp_rec][rec_height] = 129
                explo[i][exp_rec][rec_x] = 0
                explo[i][exp_rec][rec_y] = 0
                explo[i][exp_ani_fin] = 0
                explo[i][exp_cur_fram] = 0
        end if
end procedure

procedure animatorExplo()

        --int e;
        for e = 1 to MAX_EXPLO
        do 
            if sequence(explo[e]) 
            then
                explo[e][exp_cur_fram] += 1
                explo[e][exp_rec][rec_x] = explo[e][exp_cur_fram] * 128

                if (explo[e][exp_cur_fram] >= 16)
                then
                        explo[e][exp_ani_fin] = 1
                end if
            end if
        end for
end procedure

procedure updateExplo()

        animatorExplo()

        --int i;
        for i = 1 to MAX_EXPLO
        do
            if sequence(explo[i])
            then
                if (explo[i][exp_ani_fin] = 1)
                then
                        --free(explo[i])
                        explo[i] = 0
                end if
            end if
        end for
end procedure

procedure drawExplo()

        --int i;
        for i = 1 to MAX_EXPLO
        do 
            if sequence(explo[i])
            then
                sequence pos = { explo[i][exp_pos][rec_x], explo[i][exp_pos][rec_y] }
                DrawTextureRec(explo[i][exp_tex], explo[i][exp_rec], pos, WHITE)
            end if
        end for
end procedure

procedure removeExplo(integer i)

        if sequence(explo[i])
        then
                --free(explo[i]);
                explo[i] = 0
        end if
end procedure

/*
Etc
*/

procedure updateLogic()

        --int i, e;
        for i = 1 to MAX_BULLETS 
        do  
            if sequence(bullets[i])
            then
                for e = 1 to MAX_ENEMIES 
                do
                    if sequence(enemy[e]) 
                    then
                        if ((bullets[i][bul_pos][rec_x] > enemy[e][ene_pos][rec_x]) 
                        and (bullets[i][bul_pos][rec_x] < enemy[e][ene_pos][rec_x] + enemy[e][ene_hit][rec_width]) 
                        and (bullets[i][bul_pos][rec_y] > enemy[e][ene_pos][rec_y]) 
                        and (bullets[i][bul_pos][rec_y] < enemy[e][ene_pos][rec_y] + enemy[e][ene_hit][rec_height]) 
                        and (enemy[e][ene_aliv] = 1))
                        then
                                enemy[e][ene_aliv] = 0
                                addExplo(bullets[i][bul_pos][rec_x] - 128 / 2, bullets[i][bul_pos][rec_y] - 128 / 2)
                                removeBullet(i)
                                PlaySound(snd_explo)
                                score += 100
                                enemies_killed-=1
                                --printf("BOOM!\n");
                                exit
                        end if
                    end if
                end for
            end if
        end for
        --int b;
        for b = 1 to MAX_ENEMY_BULLETS 
        do
            if sequence(enemy_bullets[b])
            then
                if ((enemy_bullets[b][ene_bul_pos][rec_x] > player[play_pos][rec_x]) 
                    and (enemy_bullets[b][ene_bul_pos][rec_x] < player[play_pos][rec_x] + player[play_hit][rec_width]) 
                    and (enemy_bullets[b][ene_bul_pos][rec_y] > player[play_pos][rec_y]) 
                    and (enemy_bullets[b][ene_bul_pos][rec_y] < player[play_pos][rec_y] + player[play_hit][rec_height]) 
                    and (player[play_alive] = 1))
                then
                        player[play_alive] = 0
                        addExplo(player[play_pos][rec_x] - 128 / 2, player[play_pos][rec_y] - 128 / 2)
                        removeEnemyBullet(b)  --???removeEnemyBullet(i)
                        PlaySound(snd_explo)
                        --printf("BOOM!\n");
                        exit
                end if
            end if
        end for
end procedure

procedure restart()

        enemies_killed = MAX_ENEMIES
        gameover = 0
        score = 0
        --memset(enemy, 0, sizeof(enemy));
        enemy=repeat(0,MAX_ENEMIES)
        currentFrame = 0
        --memset(bullets, 0, sizeof(bullets))
        bullets=repeat(0,MAX_BULLETS)
        --memset(enemy_bullets, 0, sizeof(enemy_bullets));
        enemy_bullets=repeat(0,MAX_ENEMY_BULLETS)
        --memset(explo, 0, sizeof(explo));
        explo=repeat(0,MAX_EXPLO)
        rowCount = 0
        itemCount = 0
        initEnemies()
        p_move = floor(screenWidth / 2 - player[play_tex][rec_width] / 2)
        player[play_alive] = 1
end procedure

--int main(int argc, char* argv[]) {

        --Start raylib
        SetConfigFlags(FLAG_WINDOW_RESIZABLE)
        InitWindow(screenWidth, screenHeight, "Space Invaders")
        InitAudioDevice() -- Initialize audio device
        SetTargetFPS(60)
        preload_assets()

        --(re)set everything
        score = 0
        rowCount = 0
        itemCount = 0
        currentFrame = 0
        StopMusicStream(music)

--      for (int e = 0; e < MAX_ENEMIES; e++)
--      {
--              enemy[e] = NULL;
--      }
--
--      for (int e = 0; e < MAX_ENEMY_BULLETS; e++)
--      {
--              enemy_bullets[e] = NULL;
--      }
--
--      for (int e = 0; e < MAX_BULLETS; e++)
--      {
--              bullets[e] = NULL;
--      }
--
--      for (int e = 0; e < MAX_EXPLO; e++)
--      {
--              explo[e] = NULL;
--      }

        --begin
        BeginDrawing()
        --DrawTexture(fmg_tex, 0, 0, WHITE)
        DrawTexturePro(fmg_tex,{ 0, 0,fmg_tex[tex_width],fmg_tex[tex_height]},{0,0,screenWidth,screenHeight},{0,0},0,WHITE)
        EndDrawing()
        sleep(1)
        --std::this_thread::sleep_for(std::chrono::milliseconds(2000));
        --UnloadTexture(fmg_splash);

        --Load image
        space = space_tex

        --init stuff
        initEnemies()
        initPlayer()

        --font
        sequence Color = { 255, 255, 255 }
        sequence textBuffer=""
        textBuffer=sprintf("SCORE: %05d", score)
        sequence score_txtsize = MeasureTextEx(vermin_ttf, textBuffer, 24, 0)
        sequence score_pos = { screenWidth - score_txtsize[1] - 20, 20 }  -- x,y

        sequence youWin_pos={0,0}
        sequence youWin_txtsize = MeasureTextEx(vermin_ttf, "Game Over!", 64, 0)
        youWin_pos[1] = screenWidth / 2 - youWin_txtsize[1] / 2
        youWin_pos[2] = screenHeight / 2 - youWin_txtsize[2] / 2

        sequence game_over_pos={0,0}
        sequence game_over_txtsize = MeasureTextEx(vermin_ttf, "Game Over!", 64, 0)
        game_over_pos[1] = screenWidth / 2 - game_over_txtsize[1] / 2
        game_over_pos[2] = screenHeight / 2 - game_over_txtsize[2] / 2

        --Play the music
        PlayMusicStream(music)
        --SetMusicLoopCount(music, -1);

        while not(WindowShouldClose())
        do
                UpdateMusicStream(music)         -- Update music buffer with new stream data
                if IsWindowResized() 
                then
                    screenWidth=GetScreenWidth()
                    screenHeight=GetScreenHeight()  
                    player[play_pos][rec_y] = (screenHeight - 60) - player[play_tex][tex_height] / 2
                end if
                --DeltaTime = (clock() / CLOCKS_PER_SEC) - lastTick;
                DeltaTime = time()-lastTick
                --Handle events on queue
                if (IsKeyPressed(KEY_SPACE) and player[play_alive] = 1)
                then
                        addBullet(player[play_pos][rec_x] + (player[play_tex][rec_width] / 2) - 3, player[play_pos][rec_y]-20)
                        PlaySound(snd_blaster)
                end if

                if (IsKeyPressed(KEY_ENTER))
                then
                        restart()
                end if

                BeginDrawing()

                ClearBackground({230, 230, 230, 255})

                updateExplo()
                updateBullet()
                updateEnemyBullet()
                updateEnemies()

                if (player[play_alive] = 1)
                then
                        updatePlayer() --player
                end if
                updateLogic()
                
                -- CHECK animatorEnemies
                --int e;
--              for e = 1 to MAX_ENEMIES 
--              do
--                  if sequence(enemy[e]) 
--                  then
--                      enemy[e][ene_rect][rec_x] = currentFrame * 32
--                  end if
--              end for
                DrawTexturePro(space,{ 0, 0,space[tex_width],space[tex_height]},{0,0,screenWidth,screenHeight},{0,0},0,WHITE)

                drawExplo()
                drawEnemies()
                drawBullet()
                drawEnemyBullet()

                if (player[play_alive] = 1) 
                then
                        DrawTexture(player[play_tex], player[play_pos][rec_x], player[play_pos][rec_y], { 255, 255, 255, 255 })
                else
                        --DrawTextEx(vermin_ttf, "Game Over!", game_over_pos, 64, 0, WHITE);
                        --DrawTexture(gameover_tex, 0, 0, { 255, 255, 255, 255 })
                        DrawTexturePro(gameover_tex,{ 0, 0,gameover_tex[tex_width],gameover_tex[tex_height]},{0,0,screenWidth,screenHeight},{0,0},0,WHITE)
                end if

                if (enemies_killed <= 0)
                then
                        --DrawTextEx(vermin_ttf, "You Win!", youWin_pos, 64, 0, WHITE);
                        --DrawTexture(win_tex, 0, 0, { 255, 255, 255, 255 })
                        DrawTexturePro(win_tex,{ 0, 0,win_tex[tex_width],win_tex[tex_height]},{0,0,screenWidth,screenHeight},{0,0},0,WHITE)
                end if

                --this ugly block is updating the score
                textBuffer=sprintf("SCORE: %05d", score)
                DrawTextEx(vermin_ttf, textBuffer, score_pos, 24, 0, { 255, 255, 255, 255 })

--              lastTick = (clock() / CLOCKS_PER_SEC)
                lastTick=time()
--              std::this_thread::sleep_for(std::chrono::milliseconds(30));
                DrawFPS(1,1)
                EndDrawing()
        end while

        UnloadTexture(player[play_tex])
        UnloadTexture(space)
        UnloadTexture(fmg_tex)
        --Quit
        CloseWindow()

--      return 0;
--}

