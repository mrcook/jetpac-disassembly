; JETPAC disassembled source code
; (https://github.com/mrcook/jetpac-disassembly)
;
; Copyright (c) 2018 Michael R. Cook (this disassembly)
; Copyright (c) 1983 Ultimate Play the Game (JETPAC)
; JETPAC was designed and developed by Tim Stamper and Chris Stamper

; Frame counter.
;
; These lower two bytes of frame counter are incremented every 20 ms.

SYSVAR_FRAMES EQU $5c78

  ORG $6000

; Stack: 37 bytes of memory allocated for use as the system stack.
stack_memory:
  defs $25

; High score for current game session.
;
; A 3-byte decimal representation of the score. Maximum value is 999999.
hi_score:
  defs $03

; Game options.
;
; +---------+-------------------------------------------+
; | Bits(n) | Option                                    |
; +---------+-------------------------------------------+
; | 0       | Players (reset=1, set=2)                  |
; | 1       | Input Type (reset=Keyboard, set=Joystick) |
; +---------+-------------------------------------------+
game_options:
  defb $00

; Player one score.
;
; A 3-byte decimal representation of the score. Maximum value is 999999.
p1_score:
  defs $03

; Player two score.
;
; A 3-byte decimal representation of the score. Maximum value is 999999.
p2_score:
  defs $03

; Padding to make block from hi_score to here 16 bytes in length.
L5CFA:
  defs $06

; Jetman direction.
;
; +------+----------+------------------------+
; | Byte | Bits     | Direction              |
; +------+----------+------------------------+
; | 82   | 10000010 | WALK RIGHT             |
; | C2   | 11000010 | WALK LEFT              |
; | 01   | 00000001 | FLY UP RIGHT (default) |
; | 41   | 01000001 | FLY UP LEFT            |
; | 81   | 10000001 | FLY DOWN RIGHT         |
; | C1   | 11000001 | FLY DOWN LEFT          |
; +------+----------+------------------------+
jetman_direction:
  defb $00

; Jetman X position.
;
; Default start position is $80.
jetman_pos_x:
  defb $00

; Jetman Y position.
;
; Default start position is $B7.
jetman_pos_y:
  defb $00

; Jetman sprite colour attribute.
;
; Initialised to $47 on new player.
jetman_colour:
  defb $00

; Jetman moving direction.
;
; +---------+-----------------------------+
; | Bits(n) | Direction                   |
; +---------+-----------------------------+
; | 6       | 0=right, 1=left             |
; | 7       | 0=up/standing still, 1=down |
; | 1       | ?                           |
; | 0       | 0=horizontal, 1=vertical    |
; +---------+-----------------------------+
jetman_moving:
  defb $00

; Jetman Speed: Horizontal.
;
; Max Walking: $20. Max Flying: $40.
jetman_speed_x:
  defb $00

; Jetman Speed: Vertical.
;
; Max: $3F.
jetman_speed_y:
  defb $00

; Jetman sprite height, which is always $24, as set by the defaults.
jetman_height:
  defb $00

; Laser beams
;
; +----------+----------------------+
; | Bytes(n) | Variable             |
; +----------+----------------------+
; | 0        | Unused=$00, Used=$10 |
; | 1        | Y Position           |
; | 2        | X position pulse #1  |
; | 3        | X position pulse #2  |
; | 4        | X position pulse #3  |
; | 5        | X position pulse #4  |
; | 6        | Beam length          |
; | 7        | Colour attribute     |
; +----------+----------------------+
laser_beam_params:
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; laser beam #1
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; laser beam #2
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; laser beam #3
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; laser beam #4

; Sound type parameters for explosions.
;
; Byte 1=Frequency, byte 2=Duration.
explosion_sfx_params:
  defb $00                ; Frequency is $0C or $0D
  defb $00                ; Length is always set to $04

; Explosion params padding, making 8 bytes total. Unused.
L5D2A:
  defs $06

; Rocket state object.
;
; +----------+----------------------------------------+
; | Bytes(n) | Variable                               |
; +----------+----------------------------------------+
; | 0        | Movement: $09=on pad, $0A=up, $0B=down |
; | 1        | X Position (pixels)                    |
; | 2        | Y Position (pixels) - Rocket base      |
; | 3        | Colour Attribute                       |
; | 4        | State: can be $00 or $01 (default)     |
; | 5        | Fuel Pods collected: 0-6               |
; | 6        | Unused                                 |
; | 7        | Always $1C                             |
; +----------+----------------------------------------+
rocket_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Rocket module state (fuel/part).
;
; +----------+---------------------------------------------------+
; | Bytes(n) | Variable                                          |
; +----------+---------------------------------------------------+
; | 0        | Type: $00=Unused, $04=Ship/Fuel Pod               |
; | 1        | X Position (pixels)                               |
; | 2        | Y Position (pixels)                               |
; | 3        | Colour Attribute                                  |
; | 4        | State: 1=new, 3=collected, 5=free-fall, 7=dropped |
; | 5        | Unused                                            |
; | 6        | Sprite jump table offset                          |
; | 7        | Sprite Height                                     |
; +----------+---------------------------------------------------+
rocket_module_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Current Collectible object.
;
; +----------+---------------------------------------------------+
; | Bytes(n) | Variable                                          |
; +----------+---------------------------------------------------+
; | 0        | Type: $00=Unused, $04=Rocket, $0E=Collectible     |
; | 1        | X Position (pixels)                               |
; | 2        | Y Position (pixels)                               |
; | 3        | Colour Attribute                                  |
; | 4        | State: 1=new, 3=collected, 5=free-fall, 7=dropped |
; | 5        | Unused                                            |
; | 6        | Sprite jump table offset                          |
; | 7        | Sprite Height                                     |
; +----------+---------------------------------------------------+
item_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Thruster/Explosion animation sprite state.
;
; +----------+----------------------------------------------+
; | Bytes(n) | Variable                                     |
; +----------+----------------------------------------------+
; | 0        | Animating: 00=no, 03=anim done, 08=animating |
; | 1        | Last Jetman X location                       |
; | 2        | Last Jetman Y location                       |
; | 3        | Colour: Red, Magenta, Yellow, White          |
; | 4        | Frame: 0-7                                   |
; | 5        | Unused                                       |
; | 6        | Unknown (set to $03 on first use)            |
; | 7        | Unused                                       |
; +----------+----------------------------------------------+
jetman_thruster_anim_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Alien state objects.
;
; +----------+------------------------+
; | Bytes(n) | Variable               |
; +----------+------------------------+
; | 00       | Direction              |
; | 01       | X location (pixels)    |
; | 02       | Y location (pixels)    |
; | 03       | Colour attribute       |
; | 04       | Moving direction       |
; | 05       | X Speed (default: $04) |
; | 06       | Y Speed                |
; | 07       | Sprite Height          |
; +----------+------------------------+
alien_states:
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #1
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #2
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #3
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #4
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #5
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; slot #6

; Jetman exploding animation object.
;
; +----------+-------------------------------------+
; | Bytes(n) | Variable                            |
; +----------+-------------------------------------+
; | 0        | Animating: 00=no, 08=yes            |
; | 1        | Jetman X location (pixels)          |
; | 2        | Jetman Y location (pixels)          |
; | 3        | Colour: Red, Magenta, Yellow, White |
; | 4        | Frame: 0-7                          |
; | 5        | State (set=animating)               |
; | 6        | Jetman direction                    |
; | 7        | Unused                              |
; +----------+-------------------------------------+
jetman_exploding_anim_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Jetman object backup for the inactive player.
inactive_jetman_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Unused padding.
L5D90:
  defs $08

; Rocket/collectible object backup for the inactive player.
inactive_rocket_state:
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; Rocket object
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; Rocket module (fuel/part)
  defb $00,$00,$00,$00,$00,$00,$00,$00 ; Collectible/Rocket middle

; Unused padding.
L5DB0:
  defs $08

; Unused padding.
L5DB8:
  defs $08

; Temporary actor state.
;
; +----------+-----------------------------------------------------------+
; | Bytes(n) | Variable                                                  |
; +----------+-----------------------------------------------------------+
; | 0        | X location                                                |
; | 1        | Y location                                                |
; | 2        | Movement direction                                        |
; | 3        | Height (pixels)                                           |
; | 4        | Width (tiles)                                             |
; | 5        | Current sprite height value (?)                           |
; | 6        | Sprite GFX data height value (?)                          |
; | 7        | Unknown flying movement/direction (used only for Jetman?) |
; +----------+-----------------------------------------------------------+
actor:
  defb $00,$00,$00,$00,$00,$00,$00,$00

; Value only changes while Jetman is moving up/down - has no obvious pattern.
jetman_fly_counter:
  defb $00

; Alien direction update flag for: Squidgy, UFO, Sphere, Crossed Ship.
;
; Each alien update routine first resets the value, then after the first check,
; increments the value, which triggers the draw alien routine.
alien_new_dir_flag:
  defb $00

; Jetman speed modifier.
;
; Initialised to $04 by initialise game routine, otherwise value is $00 during
; game play.
jetman_speed_modifier:
  defb $00

; Current alien ID being updated?
;
; Values are $00 (no alien update?) up to the max number of aliens: $01 to $06.
; Used by all alien update routines and in a few other places.
current_alien_number:
  defb $00

; Game timer.
;
; 16-bit counter starting at 0x0000 and counting +1 (each time a sprite is
; moved or redrawn?), although sometimes it will increment +2. This continues
; until the whole game is over - for both 1 and 2 player games. Counter loops
; around after reaching 0xFFFF.
game_timer:
  defw $0000

; Random Number.
;
; Value is calculated using the 16-bit game timer LSB value, which is used to
; fetch a byte from the ROM (between addresses $00 and $FF), then by adding the
; current R.
random_number:
  defb $00

; Temporary actor coordinates.
;
; Coordinates (Y,X) used when colouring a sprite. Set by the Actor, along with
; being inc/decremented during the Rocket launch/land phase.
actor_coords:
  defb $00                ; Y location (pixels)
  defb $00                ; X location (pixels)

; Current active player.
;
; $00=player #1, $FF=player #2.
current_player_number:
  defb $00

; Jetman Rocket module attached success.
;
; Set to $01 at the start of each new life/level. When one of the two modules
; becomes attached to the Rocket (top or middle, but not fuel) then this is
; changed to $00.
jetman_rocket_mod_connected:
  defb $00

; Rocket modules attached.
;
; Set to $04 at the start of each new level. When one of the two modules
; becomes attached to the Rocket (top or middle, but not fuel) then this is
; changed to $02.
rocket_mod_attached:
  defb $00

; Holds a copy of the last SYSVAR_FRAMES counter.
last_frame:
  defb $00

; Has a frame ticked over.
;
; $00=no, $01=yes.
frame_ticked:
  defb $00

; Current menu item colour attribute.
current_colour_attr:
  defb $00

; "Get Ready" delay timer.
;
; At the beginning of each player turn there is a delay to allow the player to
; be ready for play. Values are $80 for a 1 player game, $FF for a two player
; game. The larger delay is useful for swapping players controls.
begin_play_delay_counter:
  defb $00

; Unused padding.
L5DD8:
  defs $18

; Game level for current player.
;
; Level #1 starts at $00.
player_level:
  defb $00

; Current player lives remaining.
player_lives:
  defb $00

; Unused padding for player level/lives object (8 bytes total).
L5DF2:
  defb $00,$00,$00,$00,$00,$00

; Game level for inactive player.
;
; Level #1 starts at $00.
inactive_player_level:
  defb $00

; Inactive player lives remaining.
inactive_player_lives:
  defb $00

; Unused padding for inactive player level/lives object (8 bytes total).
L5DFA:
  defb $00,$00,$00,$00,$00,$00

; Buffers for Alien sprites.
;
; +----------+----------------------------+
; | Bytes(n) | Meaning                    |
; +----------+----------------------------+
; | $00      | Header byte - always NULL? |
; | $01      | Width value - always $03   |
; | $02      | Height value               |
; | $03-$33  | Pixel data                 |
; +----------+----------------------------+
buffer_alien_r1:
  defs $33
buffer_alien_r2:
  defs $33
buffer_alien_l1:
  defs $33
buffer_alien_l2:
  defs $33

; Buffers for Collectible/Rocket sprites.
;
; +----------+---------------------------+
; | Bytes(n) | Meaning                   |
; +----------+---------------------------+
; | $00      | Header byte               |
; | $01      | Width value - always $03? |
; | $02      | Height value              |
; | $03-$33  | Pixel data                |
; +----------+---------------------------+
buffer_item_r1:
  defs $33
buffer_item_r2:
  defs $33
buffer_item_l1:
  defs $33
buffer_item_l2:
  defs $33

; Unused padding.
L5F98:
  defs $6b

; Entry address after copying data from cartridge.
L6000:
  jp StartGame

; Platform GFX location and size.
;
; +----------+---------------------+
; | Bytes(n) | Variable            |
; +----------+---------------------+
; | 1        | Colour Attribute    |
; | 2        | X location (pixels) |
; | 3        | Y location (pixels) |
; | 4        | Width               |
; +----------+---------------------+
gfx_params_platforms:
  defb $04,$80,$60,$1b    ; Middle
  defb $06,$78,$b8,$88    ; Bottom
  defb $04,$30,$48,$23    ; Left
  defb $04,$d0,$30,$23    ; Right

; Default player object state.
default_player_state:
  defb $01,$80,$b7,$47,$00,$00,$00,$24

; Default Rocket and module objects state.
default_rocket_state:
  defb $09,$a8,$b7,$02,$01,$00,$00,$1c ; Rocket state
  defb $04,$30,$47,$47,$00,$00,$10,$18 ; Top module state
  defb $04,$80,$5f,$47,$01,$00,$08,$18 ; Middle module state

; Default Rocket module state is a Fuel Pod.
default_rocket_module_state:
  defb $04,$00,$20,$43,$01,$00,$18,$18

; Default collectible item state.
default_item_state:
  defb $0e,$00,$20,$00,$00,$00,$00,$18

; Main menu copyright message.
menu_copyright:
  defb $47                ; Text colour attribute
  defb $5b                ; Font code for © symbol
  defm "1983 A.C.G. ALL RIGHTS RESERVE"
  defb $c4                ; ASCII "D" & $80 (EOL)

; Reset the screen to its default state.
;
; Used by the routines at LevelInit, PlayerTurnEnds and ResetGame.
ResetScreen:
  xor a
  out ($fe),a             ; Set screen border to black
  call ClearScreen        ; Clear the screen
  call ClearAttrFile      ; Reset the screen colours
  call DrawStatusBarLabels ; Display score labels
; Display score labels text at the top of the screen.
  ld hl,$5820             ; HL=attribute file location
  ld bc,$2046             ; B=tile count, and C=yellow colour
ResetScreen_0:
  ld (hl),c               ; Now set the tile colours
  inc l                   ;
  djnz ResetScreen_0      ;
  call ShowScoreP1        ; Update display with player 1 score
  call ShowScoreP2        ; Update display with player 2 score
  jp ShowScoreHI          ; Update display with high score

; Initialises a new level.
;
; A new Rocket is generated every 4 levels, otherwise it's a normal fuel
; collecting level. Used by the routines at NewGame and RocketTakeoff.
LevelNew:
  ld a,(player_level)     ; Check if player level is a MOD of 4?
  and $03                 ;
  jr nz,LevelInit         ; If not, initialise the level normally
; Initialisation for a new rocket level.
  call RocketReset        ; Reset all rocket modules with defaults
  ld hl,player_lives      ; Jetman has boarded the rocket; increment lives
  inc (hl)                ; count. Used for display purposes only
  call PlayerInit         ; Initialise the player for the next level

; Initialise the level.
;
; Used by the routines at LevelNew and PlayerTurnEnds.
LevelInit:
  call AlienBufferInit    ; Initialise alien buffers
  call ResetScreen        ; Initialise the screen
  call DrawPlatforms      ; Draw the platforms
  call DisplayPlayerLives ; Display all player lives
  ld a,(SYSVAR_FRAMES)    ; Set last_frame to current SYSVAR_FRAMES
  ld (last_frame),a       ;
  ret

; Reset all rocket module states to their defaults.
;
; Set object data to their defaults and copy to buffers. Used by the routines
; at LevelNew and ResetPlayerData.
RocketReset:
  ld hl,default_rocket_state ; HL=default rocket data
  ld de,rocket_state      ; DE=start of rocket structs
  ld bc,$0018             ; 24 bytes of rocket data to copy
  ldir
  ld a,$08
  jp BufferCopyRocket     ; Copy sprite data to the buffers.

; End of turn for the current player.
;
; Resets level states/buffers, and checks if it's game over for a player. Used
; by the routine at AnimateExplosion.
PlayerTurnEnds:
  ld hl,jetman_thruster_anim_state ; HL=Jetman thruster animation object
  ld b,$0a                ; Reset all object states to be inactive
  call L6629              ;
  ld hl,rocket_module_state+$04 ; HL=Rocket module "state" field
  res 1,(hl)              ; Set to unused state
  ld hl,item_state+$04    ; HL=Collectible item "state" field
  res 1,(hl)              ; Set to unused state
; Check if current and inactive player has lives, if not it is game over.
  ld a,(game_options)     ; Game Options
  and $01
  jr nz,PlayerTurnEnds_1  ; Jump if two player
PlayerTurnEnds_0:
  ld a,(player_lives)     ; Current player lives
  and a
  jp z,PlayerTurnEnds_7   ; Game over if no lives remaining
  call LevelInit          ; Initialise a new level
  jp PlayerInit           ; Initialise next player
PlayerTurnEnds_1:
  ld a,(inactive_player_lives) ; Inactive player lives
  and a
  jr z,PlayerTurnEnds_0   ; Game over if no lives remaining
  ld a,(player_lives)     ; Current player lives
  and a
  call z,PlayerTurnEnds_6 ; Game over if no lives remaining
  call PlayersSwap        ; Switch players
  ld a,(current_player_number) ; Change current player (flip bits between $00
  cpl                          ; and $FF)
  ld (current_player_number),a ;
; Switch rocket objects data for this new player
  ld a,(rocket_state+$04) ; Rocket module "state" field
  rlca                    ; Calculate the offset
  rlca                    ;
  rlca                    ;
  and $38                 ;
  call BufferCopyRocket   ; Copy rocket sprite to buffer
  call LevelInit          ; Initialise level
  jp PlayerInit           ; Initialise player
; Display the GAME OVER message for a player.
PlayerTurnEnds_2:
  ld a,$b1                ; ASCII character for the number "1" + EOL bit
PlayerTurnEnds_3:
  ld (game_over_text+$12),a ; Append the number to game over text
  call ResetScreen        ; Initialise level screen
  ld de,game_over_text    ; Game Over message
  ld hl,$7038             ; Y,X coords in the display file
  call DisplayString      ; Draw text to the screen
; After displaying the text, pause for a while.
  ld b,$04
  ld hl,$0000
PlayerTurnEnds_4:
  dec hl
  ld a,h
  or l
  jr nz,PlayerTurnEnds_4
  djnz PlayerTurnEnds_4
  ret
; Handle message for player #2.
PlayerTurnEnds_5:
  ld a,$b2                ; ASCII character for the number "2" + EOL bit
  jr PlayerTurnEnds_3     ; Append the number to the text, the display it
; Choose which player to show Game Over message for.
PlayerTurnEnds_6:
  ld a,(current_player_number) ; Jump if current player is #1
  and a                        ;
  jr z,PlayerTurnEnds_2        ;
  jr PlayerTurnEnds_5     ; else, player is #2.
; Game Over: update scores, show game over message, and initialise system.
PlayerTurnEnds_7:
  call UpdateHiScore      ; Update the high score
  ld a,(current_player_number) ; Jump if current player is #2
  and a                        ;
  jr nz,PlayerTurnEnds_8       ;
  call PlayerTurnEnds_2   ; Display game over for player #1
  jp ResetGame            ; Reset the game
PlayerTurnEnds_8:
  call PlayerTurnEnds_5   ; Display game over for player #2
  jp ResetGame            ; Reset the game

; Swap current/inactive player/rocket states.
;
; Used by the routines at PlayerTurnEnds and ResetPlayerData.
PlayersSwap:
  ld hl,player_level      ; Current player level/lives
  ld de,inactive_player_level ; Inactive player level/lives
  ld b,$02
  call PlayersSwap_0      ; Swap 2 bytes
; Now swap the current/inactive rocket states.
  ld hl,rocket_state      ; Current player rocker state
  ld de,inactive_rocket_state ; Inactive player rocker state
  ld b,$18                ; We will be swapping 24 bytes
; Sub-routine for swapping HL/DE bytes.
PlayersSwap_0:
  ld a,(de)
  ld c,(hl)
  ld (hl),a
  ld a,c
  ld (de),a
  inc hl
  inc de
  djnz PlayersSwap_0
  ret

; Text for game over message.
game_over_text:
  defb $47                ; Colour attribute
  defm "GAME OVER PLAYER "
  defb $b1                ; Player # (ASCII $31/$32) + $80 (EOL)

; Initialise player for new turn.
;
; Player has died, or started a new level, so Jetman object should be updated
; with default values. Used by the routines at LevelNew, PlayerTurnEnds and
; RocketLanding.
PlayerInit:
  ld hl,default_player_state ; Default Jetman values
  ld de,jetman_direction  ; Jetman object
  ld bc,$0008
  ldir
; Set default "begin play" delay period.
  ld a,$80                ; 1 player delay
  ld hl,game_options      ; Game options
  bit 0,(hl)
  jr z,PlayerInit_0       ; Jump if one player game
  add a,$7f               ; else, double delay for 2 player game
PlayerInit_0:
  ld (begin_play_delay_counter),a ; Update delay: 1 Player=$80, 2 Player=$FF
; Decrement current player lives and update display.
  ld a,(player_lives)     ; Current player lives
  dec a
  ld (player_lives),a
  jp DisplayPlayerLives   ; Display player lives

; Flash 1UP or 2UP score label for active player.
;
; Used by the routine at GamePlayStarts.
ScoreLabelFlash:
  ld a,(current_player_number) ; Current player number
  and a
  jr nz,L61BA             ; If player #2, flash 2UP text
  ld hl,$0018             ; else HL=1UP column position in attr file

; Set flash state for the 3-attributes of the score label.
;
; Used by the routine at L61BA.
;
; Input:HL screen coordinate.
FlashText:
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  ld b,$03                ; Loop counter for 3 characters
FlashText_0:
  ld a,(hl)               ; Set FLASH on for each attribute
  or $80                  ;
  ld (hl),a               ;
  inc hl                  ;
  djnz FlashText_0        ;
  ret

; Turn off flashing of 1UP or 2UP score label for active player.
;
; Used by the routine at GamePlayStarts.
;
; Input:HL screen coordinate.
ScoreLabelUnflash:
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  ld b,$03                ; Loop counter for 3 characters
ScoreLabelUnflash_0:
  ld a,(hl)                ; Set FLASH=off on for each attribute
  and $7f                  ;
  ld (hl),a                ;
  inc hl                   ;
  djnz ScoreLabelUnflash_0 ;
  ret

; Flash 2UP score label.
;
; Used by the routine at ScoreLabelFlash.
L61BA:
  ld hl,$00d8             ; 2UP column position in attribute file
  jr FlashText

; Game initialisation for first run.
;
; Reset all scores, sets the SP, initialises the screen, and displays the main
; menu. Used by the routine at L6000.
StartGame:
  ld hl,hi_score          ; Reset all scores
  ld bc,$0a00             ;
StartGame_0:
  ld (hl),c               ;
  inc hl                  ;
  djnz StartGame_0        ;

; Reset system and show menu screen.
;
; Used by the routine at PlayerTurnEnds.
ResetGame:
  di                      ; Interrupts are disabled for the core engine code
  ld sp,stack_memory+$25  ; Set the stack pointer
  call ResetScreen        ; Reset the screen
  ld a,$04
  ld (jetman_speed_modifier),a ; Reset Speed modifier to its default

; Show menu screen and handle menu selection.
MenuScreen:
  call MenuDrawEntries    ; Draw the menu entries
  ld a,(game_options)     ; D=Game options
  ld d,a                  ;
; Read the keyboard and perform menu selection.
  ld a,$f7                ; Row: 1,2,3,4,5
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  cpl                     ; Flip bits so a `1` means a key is pressed.
  bit 0,a                 ; Key #1 pressed? ("1 PLAYER GAME")
  jr z,MenuScreen_0       ; No key pressed? Jump
  res 0,d                 ; else, Player count = 1
MenuScreen_0:
  bit 1,a                 ; Key #2 pressed? ("2 PLAYER GAME")
  jr z,MenuScreen_1       ; No key pressed? Jump
  set 0,d                 ; else, Player count = 2
MenuScreen_1:
  bit 2,a                 ; Key #3 pressed? ("KEYBOARD")
  jr z,MenuScreen_2       ; No key pressed? Jump
  res 1,d                 ; else, Input type = keyboard
MenuScreen_2:
  bit 3,a                 ; Key #4 pressed? ("JOYSTICK")
  jr z,MenuScreen_3       ; No key pressed? Jump
  set 1,d                 ; else, Input type = joystick
MenuScreen_3:
  bit 4,a                 ; Key #5 pressed? ("START GAME")
  jp nz,NewGame           ;
  ld a,d                  ; Update the Game options
  ld (game_options),a     ;
; Update flashing state of the menu items.
  ld hl,menu_colour_table+$01 ; Point HL to main menu colour attributes list.
  ld a,(game_options)     ; C=Game options
  ld c,a                  ;
  bit 0,c                 ; Jump if player count = 2
  jr nz,MenuScreen_6      ;
  call MenuScreen_8       ; Set flashing state for a one player game
MenuScreen_4:
  bit 1,c                 ; Jump if input type = joystick
  jr nz,MenuScreen_7      ;
  call MenuScreen_8       ; Set flashing state for keyboard input
MenuScreen_5:
  jp MenuScreen           ; Loop and process again main menu input
MenuScreen_6:
  call MenuScreen_9       ; Set flashing state for a two player game
  jr MenuScreen_4         ; Check input type
MenuScreen_7:
  call MenuScreen_9       ; Set flashing state for joystick input
  jr MenuScreen_5         ; Loop and process again menu selection
; Set flashing state for "1 PLAYER GAME" and "KEYBOARD" menu items.
MenuScreen_8:
  set 7,(hl)
  inc hl
  res 7,(hl)
  inc hl
  ret
; Set "2 PLAYER GAME" and "JOYSTICK" menu items flashing.
MenuScreen_9:
  res 7,(hl)
  inc hl
  set 7,(hl)
  inc hl
  ret

; Display the main menu items to the screen.
;
; Used by the routine at MenuScreen.
MenuDrawEntries:
  ld de,menu_colour_table ; Point DE to main menu colour attributes
  exx
  ld hl,menu_position_table ; HL'=Y (y-position of the menu item)
  ld de,menu_text         ; DE'=to the beginning of the menu strings
  ld b,$06                ; B'=loop counter for the 6 colour attribute bytes
; Flip-flop between normal/shadow registers: meaning one time we hit this EXX
; we are using the shadow registers, the next the normal registers.
MenuDrawEntries_0:
  exx
  ld a,(de)               ; A=current colour attribute
  ld (current_colour_attr),a ; Store menu colour attribute
  inc de
  exx
  push bc
  ld a,(hl)
  inc hl
  push hl
  ld h,a
  ld l,$30                ; L'=indentation
  call MenuWriteText      ; Write line of text to screen
  exx
  pop hl
  pop bc
  inc de
  djnz MenuDrawEntries_0  ; Duel purpose loop: both colour attrs and menu items
  ld hl,$b800             ; Note: address is past 7FFF limit of 16K ZX Spectrum
  ld de,menu_copyright    ; Point DE to the copyright string
  call DisplayString      ; Now display the copyright message
  ret

; Colour attributes for main menu.
;
; +----------+-----------------------+
; | Bytes(n) | Menu Item             |
; +----------+-----------------------+
; | 1        | Jetpac Game Selection |
; | 2        | 1 Player Game         |
; | 3        | 2 Player Game         |
; | 4        | Keyboard              |
; | 5        | Joystick              |
; | 6        | Start Game            |
; +----------+-----------------------+
menu_colour_table:
  defb $47,$47,$47,$47,$47,$47

; Vertical position of each line of text in the main menu.
;
; +---------+-----------------------+
; | Byte(n) | Menu Item             |
; +---------+-----------------------+
; | 1       | Jetpac Game Selection |
; | 2       | 1 Player Game         |
; | 3       | 2 Player Game         |
; | 4       | Keyboard              |
; | 5       | Joystick              |
; | 6       | Start Game            |
; +---------+-----------------------+
menu_position_table:
  defb $20,$38,$48,$58,$68,$98

; Text displayed on the main menu screen
menu_text:
  defm "JETPAC GAME SELECTIO"
  defb $ce                ; ASCII "N" & $80 (EOL)
  defm "1   1 PLAYER GAM"
  defb $c5                ; ASCII "E" & $80 (EOL)
  defm "2   2 PLAYER GAM"
  defb $c5                ; ASCII "E" & $80 (EOL)
  defm "3   KEYBOAR"
  defb $c4                ; ASCII "D" & $80 (EOL)
  defm "4   JOYSTIC"
  defb $cb                ; ASCII "K" & $80 (EOL)
  defm "5   START GAM"
  defb $c5                ; ASCII "E" & $80 (EOL)

; Write a single line of text on the main menu screen.
;
; Used by the routine at MenuDrawEntries.
;
; Input:HL Coordinate on the screen to display the string.
MenuWriteText:
  push hl                 ; Backup coordinate
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld a,(current_colour_attr) ; Current colour attribute
  ex af,af'
  exx
  pop hl                  ; Restore coordinate
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  jp WriteAsciiChars      ; Display text string at HL, using A' colour

; Reset current and inactive player data on new game.
;
; Used by the routine at NewGame.
ResetPlayerData:
  ld b,$02                ; Loop counter: current then inactive player
ResetPlayerData_0:
  push bc
  xor a
  ld (player_level),a     ; Reset player level
  ld a,$04
  ld (player_lives),a     ; First player has 4 "remaining" lives
  call RocketReset        ; Reset the rocket modules
  call PlayersSwap        ; Swap player game states
  pop bc
  djnz ResetPlayerData_0  ; Repeat again for inactive player
  ld a,$05                     ; But now update inactive player to have 5
  ld (inactive_player_lives),a ; "remaining" lives, not 4
  ld a,(game_options)     ; Game options
  and $01
  ret nz                  ; Return if two player game
  ld (inactive_player_lives),a ; else one player game, so inactive player has
                               ; no lives
  ret

; Start a new game.
;
; Resets all player, alien, and level data, then start a new game. Used by the
; routine at MenuScreen.
NewGame:
  ld hl,p1_score          ; Starting at the Player 1 score
  ld bc,L6000             ; To BC address-1 (779 bytes) with a $00 value (C)
  call ClearMemoryBlock
  call ResetPlayerData    ; Reset the player data
  call ResetModifiedCode  ; Reset the self-modifying code
  call LevelNew           ; Initialise a new level

; Reset stack pointer and enable interrupts before running main loop.
;
; If new item/alien was generated, this routine is called instead of MainLoop.
;
; Used by the routine at NewActor.
MainLoopResetStack:
  ld sp,stack_memory+$25  ; Set the stack pointer
  ei
  ld ix,rocket_state      ; IX=Rocket object
  xor a
  ld (current_alien_number),a ; Reset current alien number

; The main game loop.
;
; This routine is called until a new item/alien is generated, then
; MainLoopResetStack is called.
;
; Used by the routines at MainLoopResetStack, FrameUpdate and NewActor.
MainLoop:
  ld a,(SYSVAR_FRAMES)    ; Compare SYSVAR_FRAMES and last_frame
  ld c,a                  ;
  ld a,(last_frame)       ;
  cp c                    ;
; Note: if we have EI here, then FrameUpdate will be called and DI executed.
  call nz,FrameUpdate     ; If they're not equal, do frame update
; When one of the `main_jump_table` update routines RETurns, the new game actor
; routine will be called.
  ld hl,NewActor          ; HL=generate new actor routine
  push hl                 ; ...and push `ret` address to the stack.
; Execute one of the update routines using the value in IX.
  ld hl,main_jump_table   ; HL=main jump table
  ld a,(ix+$00)           ; Calculate the jump table offset
  rlca                    ;
  and $7e                 ;

; Performs a main loop update jump.
;
; Used by the routines at MainLoop and ItemDropNew.
;
; Input:A Offset for jump table address.
;       HL Address to the jump table.
PerformJump:
  ld c,a
  ld b,$00                ; BC=offset: 34 max (size of jump table)
  add hl,bc               ; Set HL to jump table address using offset
  ld a,(hl)               ; Assign the jump address back to HL
  inc hl                  ;
  ld h,(hl)               ;
  ld l,a                  ;
  jp (hl)                 ; Use `jp` so `ret` calls the new actor/timer routine

; Main game loop jump table.
;
; Addresses for all the main routines to be updated per game loop.
main_jump_table:
  defw FrameRateLimiter   ; Frame rate limiter
  defw GamePlayStarts     ; Jetman Fly
  defw JetmanWalk         ; Jetman Walk
  defw MeteorUpdate       ; Meteor Update
  defw CollisionDetection ; Collision Detection
  defw CrossedShipUpdate  ; Crossed Space Ship Update
  defw SphereAlienUpdate  ; Sphere Alien Update
  defw JetFighterUpdate   ; Jet Fighter Update
  defw AnimateExplosion   ; Animate Explosion
  defw RocketUpdate       ; Rocket Update
  defw RocketTakeoff      ; Rocket Take off
  defw RocketLanding      ; Rocket Landing
  defw SfxEnemyDeath      ; SFX Death: Enemy
  defw SfxJetmanDeath     ; SFX Death: Player
  defw ItemCheckCollect   ; Check Item Collected
  defw UFOUpdate          ; UFO Update
  defw LaserBeamAnimate   ; Animate Laser Beam
  defw SquidgyAlienUpdate ; Squidgy Alien Update

; Update the high score.
;
; If one of the players score is a new max score, then update the high score
; with that of the player with the highest score. Used by the routine at
; PlayerTurnEnds.
UpdateHiScore:
  ld hl,(p1_score)        ; HL=player 1 score
  ld de,(p2_score)        ; DE=player 2 score
  ld a,l                  ; Swap the P1 LSB/MSB values so we can perform
  ld l,h                  ; calculations on them.
  ld h,a                  ;
  ld a,e                  ; Swap the P2 LSB/MSB values so we can perform
  ld e,d                  ; calculations on them
  ld d,a                  ;
  and a                   ; Reset the Carry flag
  sbc hl,de
  jr c,UpdateHiScore_0    ; Jump if score P2 > P1, else
  jr nz,UpdateHiScore_5   ; Jump if score P1 > P2, else P1==P2, so no jump
  ld a,(p1_score+$02)     ; E=3rd byte of the P1 score
  ld e,a                  ;
  ld a,(p2_score+$02)     ; P2 score
  cp e
  jr c,UpdateHiScore_5    ; Jump if score of P2 < P1 (set's HL to P1 score)
; Inactive player has the highest score.
UpdateHiScore_0:
  ld hl,p2_score          ; HL=P2 score
; Update the high score if the player score has beaten it.
UpdateHiScore_1:
  push hl
  ld de,hi_score          ; DE=high score
  ld b,$03                ; Loop counter (all 3 score bytes)
UpdateHiScore_2:
  ld a,(de)               ; A = hi-score byte
  cp (hl)                 ; Compare with player
  jr c,UpdateHiScore_4    ; If hi-score < player, update highscore score
  jr nz,UpdateHiScore_3   ; If hi-score != player (not equal), then RET
  inc hl                  ; else hi-score == player: next player byte
  inc de                  ; next high score byte
  djnz UpdateHiScore_2    ; Repeat
UpdateHiScore_3:
  pop hl                  ; Restores HL to the highest player score
  ret
; Sets the bytes for the high score with those from the player.
UpdateHiScore_4:
  pop hl
  ld de,hi_score          ; High Score
  ld bc,$0003
  ldir
  ret
; Player 1 has the highest score.
UpdateHiScore_5:
  ld hl,p1_score          ; HL=P1 score
  jr UpdateHiScore_1      ; Update HI score

; Update Jet Fighter.
;
; Input:IX Alien object for one of the Jet Fighters.
JetFighterUpdate:
  ld hl,current_alien_number ; Increment current alien number
  inc (hl)                   ;
  call ActorUpdateDir     ; Update Alien direction
  ld a,(ix+$04)           ; Alien "moving" field
  ld hl,$0000
  bit 1,a                  ; Move if bit-1 is set
  jr nz,JetFighterUpdate_4 ;
  call JetFighterUpdate_2 ; Check and update speed
  ld a,(jetman_pos_y)     ; A=Jetman Y position
  sub $0c
  cp (ix+$02)               ; Update Alien speed if Jetman Y position-12 equals
  call z,JetFighterUpdate_3 ; Alien Y position
  ld a,(game_timer)       ; A=LSB of game timer
  and $40
  jr z,JetFighterUpdate_1 ; Move vertically if bit-6 is reset
JetFighterUpdate_0:
  inc h
  inc h
  inc h
  inc h
JetFighterUpdate_1:
  dec h
  dec h
  jr JetFighterUpdate_6   ; Move vertically +2 or -2
; Decide if speed should be updated.
JetFighterUpdate_2:
  ld a,(random_number)    ; A=random number
  and $1f
  ret nz                  ; Return if not zero
; Update speed.
JetFighterUpdate_3:
  set 1,(ix+$04)          ; Alien "moving" field
  ld c,a                  ; C=Jetman Y position-12 ?
  ld a,(game_timer)       ; A=LSB of game timer
  add a,c
  and $7f
  or $20
  ld (ix+$05),a           ; Set new X speed value
  ld (ix+$03),$47         ; Set "colour" to White
  ret
; Move Jet Fighter horizontally.
JetFighterUpdate_4:
  dec (ix+$05)            ; Decrement alien X speed
  jr z,JetFighterUpdate_7 ; Jet Fighter killed if X speed is zero
  ld a,$04                ; A=default speed
  bit 6,(ix+$00)          ; Check bit-6 of Alien "direction"
  jr z,JetFighterUpdate_5
  neg
JetFighterUpdate_5:
  ld l,a                  ; L=$FC or $04?
; Target the player and move towards them.
  ld a,(jetman_pos_y)     ; Move upwards if Jetman Y position higher than Alien
  cp (ix+$02)             ; Y position
  jr c,JetFighterUpdate_1 ;
  jr JetFighterUpdate_0   ; else, move down
; Move Jet Fighter vertically and horizontally.
JetFighterUpdate_6:
  ld a,(ix+$00)           ; Alien "direction"
  and $c0                 ; Reset FLY and WALK bits
  or $03
  ld (ix+$00),a           ; Update "direction" value
  ld a,(ix+$01)           ; Update Alien X position (L is probably 3 or 4)
  add a,l                 ;
  ld (ix+$01),a           ;
  ld a,(ix+$02)           ; Update Alien Y position
  add a,h                 ;
  ld (ix+$02),a           ;
  call L7232              ; Update Actor Position X and draw
  call ColourizeSprite    ; Colourize the sprite
  ld a,(ix+$02)           ; Kill Fighter if Y position < $28
  cp $28                  ;
  jr c,JetFighterUpdate_7 ;
  call LaserBeamFire      ; Fire laser beam - returns C
  bit 0,c                  ; Kill if a laser hit the Alien
  jr nz,JetFighterUpdate_7 ;
  call JetmanPlatformCollision ; Platform collision - returns E
  bit 2,e                  ; Kill if Alien hit a platform
  jr nz,JetFighterUpdate_7 ;
  call AlienCollision     ; Alien collision - returns DE
  dec e
  jr z,AlienCollisionAnimSfx ; Alien killed by collision
  ld a,(ix+$00)           ; Update Alien "direction"
  and $c0                 ;
  or $07                  ;
  ld (ix+$00),a           ;
  ret
; Jet Fighter is dead. Added score and make exploding sound.
JetFighterUpdate_7:
  ld bc,$0055             ; 55 points for a dead jet fighter (decimal value)
  call AddPointsToScore   ; Add points to score
  call SfxThrusters       ; Exploding jet fighter SFX - actually Thruster SFX!
  jp AnimationStateReset  ; Update current alien state

; Alien SFX when killed by collision.
;
; Reset anim state and set SFX params #2.
;
; Used by the routines at JetFighterUpdate, SquidgyAlienUpdate, UFOUpdate,
;      SphereAlienUpdate, CrossedShipUpdate and
; #R$6d9c.
AlienCollisionAnimSfx:
  call AnimationStateReset ; Update actor state
  ld a,$01                 ; Play explosion sound with SFX type #2
  call SfxSetExplodeParams ;
  jp ExplosionAfterKill   ; Animate explosion

; Jetman collects a collectible item.
;
; Input:IX Collectible item object
ItemCheckCollect:
  call ActorUpdatePosDir  ; Update Actor position direction
  call JetmanPlatformCollision ; Platform collision - returns E
  bit 2,e                  ; Increment item Y position if bit-2 is set
  jr nz,ItemCheckCollect_0 ;
  inc (ix+$02)             ;
  inc (ix+$02)             ;
ItemCheckCollect_0:
  call AlienCollision     ; Alien collision - returns E
  dec e
  jr nz,ItemDropNew       ; Drop new collectible item if E > 0
  xor a                   ; Reset A
  call L64AE              ; HL=sprite address
  call ActorDestroy       ; Destroy the collected item
  ld (ix+$00),$00         ; Set type as unused
  ld bc,$0250             ; 250 points to add to score (decimal value)
  call AddPointsToScore   ; Add points to score
  jp SfxPickupItem        ; SFX for item collect (and return)

; Drop a new collectible item.
;
; Used by the routine at ItemCheckCollect.
;
; Input:IX Collectible item object
ItemDropNew:
  ld a,(ix+$06)           ; Jump table offset
  and $0f                 ; Values: 0, 2, 4, 6, or 8
  ld hl,item_drop_jump_table ; HL=item drop jump table
  jp PerformJump          ; Execute the jump using HL address

; Item drop jump table.
item_drop_jump_table:
  defw ItemDropGoldBar    ; Drop Gold bar collectible
  defw ItemDropChemical   ; Drop chemical based collectible
  defw ItemDropChemical   ; Drop chemical based collectible
  defw ItemDropPlutonium  ; Drop green coloured collectible
  defw ItemDropRandomColour ; Drop collectible with random colour

; Drop a gold bar collectible item.
;
; Input:IX Collectible item object
ItemDropGoldBar:
  ld (ix+$03),$46         ; Set colour to GOLD

; Display a collectible sprite.
;
; Used by the routines at ItemDropPlutonium, ItemDropChemical and
; ItemDropRandomColour.
ItemDisplaySprite:
  xor a
  call L64AE              ; DE=item sprite address
  call ActorUpdatePosition ; Update the item sprite
  jp ColourizeSprite      ; Colourize the sprite

; Sprite offset using colour attribute.
;
; Used by the routines at ItemCheckCollect, ItemDisplaySprite and L6514.
L64AE:
  add a,(ix+$06)

; Get address for collectible sprite.
;
; Used by the routine at UpdateRocketColour.
;
;  Input:A Offset for the desired sprite.
; Output:DE Address for a sprite.
ItemGetSpriteAddress:
  ld hl,collectible_sprite_table ; Sprite lookup table
  ld c,a                  ; Add offset to base address
  ld b,$00                ;
  add hl,bc               ;
  ld e,(hl)               ; Assign sprite address to DE
  inc hl                  ;
  ld d,(hl)               ;
  ret

; Drop a Plutonium collectible item.
;
; Input:IX Collectible item object.
ItemDropPlutonium:
  ld (ix+$03),$44         ; Set the colour to green
  jr ItemDisplaySprite    ; Display item sprite

; Drop a chemical based item, flashing items radiation and plutonium.
;
; Input:IX Collectible item object.
ItemDropChemical:
  ld a,(game_timer)       ; Game timer
  and $1f
  cp $18
  jr nc,ItemDropChemical_0 ; Use cyan colour and display sprite
; Flashing items: hidden.
  ld (ix+$03),$00         ; Set the colour to black
  jr ItemDisplaySprite    ; Display the item sprite
; Flashing items: visible.
ItemDropChemical_0:
  ld (ix+$03),$45         ; Set the colour to cyan
  jr ItemDisplaySprite    ; Display the item sprite

; Drop a random coloured collectible item.
;
; Set the sprite to a random colour based on it's ID, which means colour values
; will be between $41 and $47.
;
; Input:IX Collectible item object.
ItemDropRandomColour:
  ld a,(game_timer)       ; Game timer
  rrca
  rrca
  and $07
  jr nz,ItemDropRandomColour_0 ; Jump if A is now 1-7
  inc a
ItemDropRandomColour_0:
  or $40                  ; Make sure colour value is > $40
  ld (ix+$03),a           ; Set the colour to between $41 and $47
  jr ItemDisplaySprite    ; Display the item sprite

; Collision detection for collectible items / rocket modules.
;
; Input:IX Collectible item object.
CollisionDetection:
  call ActorUpdatePosDir  ; Update Actor position direction
  ld a,(ix+$04)           ; A=item "state"
  bit 2,a                 ; Pick up rocket module if bit-2 set
  jp nz,PickupRocketItem  ;
  bit 1,a                 ; Carrying rocket module/fuel if bit-1 set
  jr nz,CarryRocketItem   ;
  bit 0,a                 ; Draw sprite if bit-0 reset
  jr z,L6514              ;
  call AlienCollision     ; Check for alien collision - returns E
  dec e                   ; Collect rocket module if E == 0
  jr z,CollectRocketItem  ;
  call JetmanPlatformCollision ; Platform collision - returns E
  bit 2,e                 ; Draw sprite if bit-2 set
  jr nz,L650E             ;

; Increment Y position and draw sprite
;
; Used by the routine at PickupRocketItem.
L6508:
  inc (ix+$02)
  inc (ix+$02)

; Draw a sprite.
;
; Used by the routines at CollisionDetection, CollectRocketItem and
; CarryRocketItem.
L650E:
  call L7232              ; Update actor and draw sprite
  jp ColourizeSprite      ; Colourize the sprite

; Gets collectible ID based on the current user level.
;
; Used by the routine at CollisionDetection.
L6514:
  ld a,(player_level)     ; Current player level
  rrca
  and $06                 ; There are only 6 collectibles?
  call L64AE              ; DE=collectible item sprite address
  call ActorEraseAnimSprite ; Erase an item sprite
  jp ColourizeSprite      ; Colourize the sprite

; Collect Rocket module or fuel pod.
;
; Module is collected after player collides with it. Used by the routine at
; CollisionDetection.
;
; Input:IX Rocket module object.
CollectRocketItem:
  set 1,(ix+$04)          ; Module "state"
  call ActorFindDestroy   ; Find and destroy the sprite (returns DE)
  ld bc,$0100             ; 100 points to add to score (decimal value)
  call AddPointsToScore   ; Add points to score
  call SfxPickupFuel      ; SFX for collecting fuel
  ld hl,(jetman_pos_x)    ; Update module position so it becomes attached to
  ld (ix+$01),l           ; the player via the Jetman Y,X positions
  ld (ix+$02),h           ;
  call ActorUpdatePosDir  ; Update sprite X position
  jr L650E                ; Colourize the sprite

; Carry a collected rocket module/fuel pod.
;
; Ensure the rocket module/fuel pod remains attached to the foot of the Jetman
; sprite. Used by the routine at CollisionDetection.
;
; Input:IX Rocket module object.
CarryRocketItem:
  ld hl,(jetman_pos_x)    ; Update module position so it becomes attached to
  ld (ix+$01),l           ; the player via the Jetman Y,X positions
  ld (ix+$02),h           ;
  ld a,(rocket_state+$01) ; Rocket X position
  sub (ix+$01)            ; Subtract module X position
  jp p,CarryRocketItem_0  ; If already negative, jump
  neg                     ; else make a negative value
CarryRocketItem_0:
  cp $06                  ; Draw sprite if A >= 6
  jr nc,L650E             ;
  set 2,(ix+$04)          ; Set module "state" to collected
  ld a,(rocket_state+$01) ; Rocket: X position
  ld (ix+$01),a           ; Update module X position to be same as Rocket
                          ; position
  jr L650E                ; Update module and draw sprite

; Pick up and carry a rocket module/fuel pod.
;
; Used by the routine at CollisionDetection.
;
; Input:IX Collectible item object - rocket module or fuel pod.
PickupRocketItem:
  ld a,(ix+$06)           ; Item sprite jump table offset
  cp $18
  jr z,PickupRocketItem_1 ; Jump to delivery check if a fuel pod?
  sla a
  add a,(ix+$02)          ; Add item Y position
  cp $b7
  jp c,L6508              ; Increment item Y position and draw sprite if < 183
  ld a,(rocket_module_state+$04)
  or $01
  ld (rocket_module_state+$04),a ; Set module "state" to collected
  ld a,(rocket_state+$04) ; A=Rocket "state" value
  inc a
  ld (rocket_state+$04),a ; Update rocket "state" value
  ld a,(ix+$06)           ; Item sprite jump table offset
  add a,$08
  call BufferCopyRocket   ; Copy rocket sprite to buffers
PickupRocketItem_0:
  call ActorFindDestroy   ; Find and destroy current sprite
  ld (ix+$00),$00         ; Set item type to unused
  jp SfxRocketBuild       ; SFX for rocket building
; Check if fuel pod delivered to ship, and increment count if so.
PickupRocketItem_1:
  ld a,(ix+$02)           ; Item Y position of fuel pod
  cp $b0                  ; Has it reached the rocket yet?
  jp c,L6508              ; Move the fuel cell down one pixel if not
  ld a,(rocket_state+$05) ; A=rocket fuel pod count
  inc a
  ld (rocket_state+$05),a ; Increment rocket fuel pod count
  jr PickupRocketItem_0   ; Loop back and repeat

; Release new collectible item.
;
; Used by the routine at NewActor.
ItemNewCollectible:
  ld a,(jetman_direction) ; Jetman direction
  and $3f
  ret z                   ; Return if not one of the 6 directions
  cp $03
  ret nc                  ; Return if >= 3 (all movement except up right?)
  ld hl,default_item_state ; HL=default item state
  ld de,item_state        ; DE=collectible object
  ld bc,$0008
  ld a,(de)               ; A=item type
  and a
  ret nz                  ; Return if currently in use
  ld a,(game_timer)       ; Game timer
  and $7f
  ret nz                  ; Return if between 1-127
  ldir
  call ItemCalcDropColumn ; A=column to drop item
  ld (item_state+$01),a   ; Update item X position
  ld a,r                  ; Get random number
  and $0e                 ; A=2, 4, 6, 8, 10, 12, or 14
  bit 3,a                   ; Jump if bit-3 is already reset
  jr z,ItemNewCollectible_0 ;
  and $08                 ; else set bit-3
ItemNewCollectible_0:
  or $20                  ; Make sure bit-5 (32) is set
  ld (item_state+$06),a   ; Update item with new jump table offset
  ret

; Calculate column on which to drop a new collectible item/fuel pod.
;
; Used by the routines at ItemNewCollectible and ItemNewFuelPod.
;
; Ouput:A Column position.
ItemCalcDropColumn:
  ld hl,item_drop_positions_table ; HL=item drop position table
  ld a,(random_number)    ; A=random number
  and $0f
  ld c,a                  ; BC = byte offset (0-15)
  ld b,$00                ;
  add hl,bc               ; Add offset
  ld a,(hl)               ; Set A to position
  ret

; Horizontal column positions for dropping collectibles.
item_drop_positions_table:
  defb $08,$20,$28,$30,$38,$40,$58,$60
  defb $78,$80,$88,$c0,$e0,$08,$58,$60

; Drop a new fuel pod collectible.
;
; Used by the routine at NewActor.
ItemNewFuelPod:
  ld a,(jetman_direction) ; Jetman direction
  and $3f
  ret z                   ; Return if not one of the 6 directions
  cp $03
  ret nc                  ; Return if >= 3 (all movement except up right?)
  ld hl,default_rocket_module_state ; HL=default rocket module state
  ld de,rocket_module_state ; DE=rocket module object
  ld bc,$0008
  ld a,(de)               ; Return if currently in use
  and a                   ;
  ret nz                  ;
  ld a,(rocket_state+$05) ; A=Rocket fuel Pod count
  cp $06
  ret nc                  ; Return if fuel collected >= 6
  ld a,(game_timer)       ; Game timer
  cpl
  and $0f
  ret nz                  ; Return if A is between 1-15
  ldir
  call ItemCalcDropColumn ; A=column to drop item
  ld (rocket_module_state+$01),a ; Update fuel pod X position
  ret

; Reset the Rocket modules state data ready for next level.
;
; After the rocket hits top of screen this routine resets all the collectibles,
; aliens, and player states for that level. Used by the routine at
; RocketTakeoff.
RocketModulesReset:
  ld hl,rocket_module_state ; HL=rocket module
  ld b,$0c                ; Loop counter

; Make objects inactive.
;
; Used by the routine at PlayerTurnEnds.
;
; Input:B Loop counter: either $0A or $0C.
;       HL Object to be updated: fuel pod or thruster animation.
L6629:
  ld de,$0008             ; Increment value
L6629_0:
  ld (hl),$00             ; Reset first byte of object
  add hl,de               ; HL += 8
  djnz L6629_0
  ret

; Animate the rocket flame sprites.
;
; Used by the routines at RocketTakeoff and RocketLanding.
;
; Input:IX Rocket object
RocketAnimateFlames:
  ld a,(ix+$02)           ; Add 21 to rocket Y position
  add a,$15               ;
  ld (ix+$02),a           ;
  ld hl,actor+$01         ; HL=Actor Y position
  ld a,(hl)               ; Add 21 to actor Y position
  add a,$15               ;
  ld (hl),a               ;
  ld a,(ix+$02)              ; If near ground, turn off flame sprites
  cp $b8                     ;
  jr z,RocketAnimateFlames_3 ;
  jr nc,RocketAnimateFlames_1 ; If >= 184, just update flame sprite vars
  ld a,(game_timer)       ; Game timer
  and $04
  jr nz,RocketAnimateFlames_2 ; DE=flame sprite #1 if bit-3 is set
  ld de,gfx_rocket_flames2 ; else DE=flame sprite #2
; Draw the flame sprites.
RocketAnimateFlames_0:
  push de
  ld de,gfx_rocket_flames1 ; Destroy flame sprite #1
  call ActorDestroy        ;
  ld de,gfx_rocket_flames2 ; Destroy flame sprite #2
  call ActorDestroy        ;
  pop de
  call ActorEraseAnimSprite ; Erase and animate actor sprite
  ld (ix+$03),$42         ; Set flame sprite colour to Red
  call ColourizeSprite    ; Colourize the sprite
; Update Rocket and Actor Y positions.
RocketAnimateFlames_1:
  ld a,(ix+$02)           ; Subtract $15 from rocket Y position
  sub $15                 ;
  ld (ix+$02),a           ;
  ld hl,actor+$01         ; HL=Actor Y position
  ld a,(hl)               ; Subtract 21 from actor Y position
  sub $15                 ;
  ld (hl),a               ;
  ret
; Set first rocket flame sprite to be displayed.
RocketAnimateFlames_2:
  ld de,gfx_rocket_flames1 ; Rocket flame sprite #1
  jr RocketAnimateFlames_0 ; Draw flame sprite
; Turn off the rocket flame sprites and update sprite variables.
RocketAnimateFlames_3:
  ld de,gfx_rocket_flames1 ; Destroy flame sprite #1
  call ActorDestroy        ;
  ld de,gfx_rocket_flames2 ; Destroy flame sprite #2
  call ActorDestroy        ;
  jp RocketAnimateFlames_1 ; Update sprite variables

; Rocket ship is taking off.
;
; Input:IX Rocket object.
RocketTakeoff:
  call ActorUpdatePosDir  ; Update Actor position direction
  dec (ix+$02)            ; Decrement Y position
  call SfxThrusters       ; Thruster SFX
  call RocketAnimateFlames ; Animate rocket flame sprites
  ld a,(ix+$02)           ; Check if rocket has reached top of screen
  cp $28                  ;
  jr nc,UpdateRocketColour ; Update rocket colour if not
; Rocket has reached top of screen - set up next level.
  ld hl,player_level      ; Increment current player level
  inc (hl)                ;
  call RocketModulesReset ; Reset rocket ready for next level
  inc (ix+$00)            ; Set Rocket "move" state to down
  ld (ix+$05),$00         ; Reset fuel pod counter
  jp LevelNew             ; New level

; Rocket ship is landing.
;
; Input:IX Rocket object.
RocketLanding:
  call ActorUpdatePosDir  ; Update Actor position direction
  inc (ix+$02)            ; Increment Y position
  call SfxThrusters       ; Thruster SFX
  call RocketAnimateFlames ; Animate rocket flame sprites
  ld a,(ix+$02)           ; Check if rocket has landed
  cp $b7                  ;
  jr c,UpdateRocketColour ; Update rocket colour if not
; Rocket has landed!
  ld (ix+$00),$09         ; Set Rocket "move" state to default (on pad)
  call PlayerInit         ; Initialise the player state
  jr UpdateRocketColour   ; Update rocket colour

; Update the rocket ship.
;
; Input:IX Rocket object.
RocketUpdate:
  call ActorUpdatePosDir  ; Update Actor position direction
  call AlienCollision     ; E=Alien collision result: $00 or $01
  dec e                    ; Update rocket colour if not zero
  jr nz,UpdateRocketColour ;
  ld a,(ix+$05)           ; Update rocket colour if fuel pod counter < 6
  cp $06                  ;
  jr c,UpdateRocketColour ;
  inc (ix+$00)            ; Set Rocket "move" state to up
  push ix
  ld ix,jetman_direction  ; IX=Jetman object
  call ActorUpdatePosDir  ; Update Jetman position direction
  call ActorFindDestroy   ; Jetman, find and destroy
  ld (ix+$00),$00         ; Reset Jetman direction
  pop ix                  ; Restore IX to be the rocket object
  ld hl,player_lives      ; Increment current player lives
  inc (hl)                ;
  jp DisplayPlayerLives   ; Display player lives

; Update Rocket ship colour.
;
; Colouring is based on the number of fuel pods collected. Used by the routines
; at RocketTakeoff, RocketLanding and RocketUpdate.
;
; Input:IX Rocket object.
UpdateRocketColour:
  ld l,(ix+$01)           ; Rocket X position
  ld h,(ix+$02)           ; Rocket Y position
  push hl
  ld a,(ix+$04)           ; A=colour attribute
  ld b,a                  ; Set loop counter
  ld c,$00                ;
; Draw all collected rocket modules.
UpdateRocketColour_0:
  push bc
  ld a,(player_level)     ; A=player level
  rrca                    ; Calculate which sprite to use for the current level
  rrca                    ;
  and $03                 ;
  or c                    ;
  sla a                   ;
  call ItemGetSpriteAddress ; DE=item address from lookup table using A
  call ActorUpdatePosition ; Update actor position using DE
  pop bc                  ; Restore loop counter
  ld a,(ix+$02)           ; Subtract 16 from a rocket Y position
  sub $10                 ;
  ld (ix+$02),a           ;
  ld a,(actor+$01)        ; A=Actor Y position
  sub $10                 ; Subtract 16 from Actor Y position
  ld (actor+$01),a        ; Update Actor Y position
  ld a,c
  add a,$04
  ld c,a
  djnz UpdateRocketColour_0 ; Loop and update rocket/actor again
  ld a,$02
  ld (actor+$04),a        ; Actor width = 2
  xor a
  ld (actor+$03),a        ; Actor height = 0 (?)
  pop hl
  ld (ix+$02),h           ; Update rocket Y position: only Y changed in loop
                          ; above
  ld (actor_coords),hl    ; Update current Actor Y,X coords
; Colour the rocket modules based on collected fuel pod count.
  ld b,(ix+$04)           ; Rocket "state"
  sla b                   ;
  ld a,b                  ;
  cp $06                    ; if value < 6, or the fuel pod counter is zero,
  jr c,UpdateRocketColour_1 ; then set rocket colour to white and redraw
  ld a,(ix+$05)             ;
  and a                     ;
  jr z,UpdateRocketColour_1 ;
  cp $06                  ; Check if all fuel collected (is checked at 6760)
  push af                 ; Preserve Carry (no care for A)
  ld a,(game_timer)       ; Game timer
  rrca
  rrca
  and $04
  or $43
  ld c,a
  pop af                  ; Restore Carry value (from 6751 check above)
  ld a,c
  jr nc,UpdateRocketColour_2 ; Colour all sprites if all fuel has been
                             ; collected
  ld b,(ix+$05)           ; else use fuel pod count as loop counter
  ld (ix+$03),$43         ; Set colour to Magenta
  call UpdateRocketColour_3 ; Update sprite colour
; Set part of rocket back to white based on amount of uncollected fuel pods.
  ld a,$06                ; A=max possible fuel pods
  sub (ix+$05)            ; Subtract remaining fuel pod count
  ld b,a                  ; Set loop counter
UpdateRocketColour_1:
  ld a,$47                ; Set Rocket colour to white
UpdateRocketColour_2:
  ld (ix+$03),a           ;
  jp UpdateRocketColour_3 ; Redundant JP!
UpdateRocketColour_3:
  push bc
  call ColourizeSprite    ; Colourize the sprite
  pop bc
  ld hl,(actor_coords)    ; HL=current rocket sprite coords
  ld a,h                  ; Update Y position
  sub $08                 ;
  ld h,a                  ;
  ld (actor_coords),hl    ; Update current rocket sprite coords
  djnz UpdateRocketColour_3 ; Loop and continue colouring
  ret

; Rocket and collectible sprite address lookup table.
collectible_sprite_table:
  defw gfx_rocket_u1_bottom ; Offset: $00 - Rocket #1: Bottom
  defw gfx_rocket_u5_bottom ; Offset: $02 - Rocket #5: Bottom
  defw gfx_rocket_u3_bottom ; Offset: $04 - Rocket #3: Bottom
  defw gfx_rocket_u4_bottom ; Offset: $06 - Rocket #4: Bottom
  defw gfx_rocket_u1_middle ; Offset: $08 - Rocket #1: Middle
  defw gfx_rocket_u5_middle ; Offset: $0A - Rocket #5: Middle
  defw gfx_rocket_u3_middle ; Offset: $0C - Rocket #3: Middle
  defw gfx_rocket_u4_middle ; Offset: $0E - Rocket #4: Middle
  defw gfx_rocket_u1_top  ; Offset: $10 - Rocket #1: Top
  defw gfx_rocket_u5_top  ; Offset: $12 - Rocket #5: Top
  defw gfx_rocket_u3_top  ; Offset: $14 - Rocket #3: Top
  defw gfx_rocket_u4_top  ; Offset: $16 - Rocket #4: Top
  defw gfx_fuel_pod       ; Offset: $18 - Fuel Cell
  defw gfx_fuel_pod       ; Offset: $1A - Fuel Cell
  defw gfx_fuel_pod       ; Offset: $1C - Fuel Cell
  defw gfx_fuel_pod       ; Offset: $1E - Fuel Cell
  defw gfx_gold_bar       ; Offset: $20 - Gold Bar
  defw gfx_radiation      ; Offset: $22 - Radiation
  defw gfx_chemical_weapon ; Offset: $24 - Chemical Weapon
  defw gfx_plutonium      ; Offset: $26 - Plutonium
  defw gfx_diamond        ; Offset: $28 - Diamond

; Rocket thruster SFX, and Jet Fighter explosions.
;
; Used by the routines at JetFighterUpdate, RocketTakeoff and RocketLanding.
;
; Input:IX Jetman or Rocket object.
SfxThrusters:
  ld a,(ix+$02)           ; Y position
  rrca                    ; Change pitch based on vertical position
  rrca                    ;
  rrca                    ;
  rrca                    ;
  and $7f                 ;
  or $40                  ;
  ld d,a                  ; Pitch
  ld c,$10                ; Duration
  jr PlaySquareWav2       ; Play square wave sound

; SFX for ship building.
;
; Activated when ship module is dropped, or fuel cell touches the rocket base.
SfxRocketBuild:
  ld d,$20                ; Pitch
  ld c,$50                ; Duration
  jr PlaySquareWav2       ; Play square wave sound

; SFX for collecting a fuel cell.
;
; Used by the routine at CollectRocketItem.
SfxPickupFuel:
  ld d,$50                ; Pitch
  ld c,$28                ; Duration
  jr PlaySquareWav2       ; Play square wave sound

; SFX for collecting an item, and when Jetman appears on-screen.
;
; Used by the routines at ItemCheckCollect and GamePlayStarts.
SfxPickupItem:
  ld d,$30                ; Pitch
  ld c,$40                ; Duration

; Play square wave sound.
;
; Used by the routine at PlaySquareWav2.
PlaySquareWave1:
  ld a,$10
  out ($fe),a
  ld b,d

; Play square wave sound, starting with silence.
;
; Used by the routines at SfxThrusters, SfxRocketBuild and SfxPickupFuel.
;
; Input:D Sound frequency
;       C Sound duration
PlaySquareWav2:
  djnz PlaySquareWav2     ; Play sound/silence for desired length
  xor a                   ; Turn speaker OFF for desired duration
  out ($fe),a             ;
  ld b,d                  ;
PlaySquareWav2_0:
  djnz PlaySquareWav2_0   ;
  dec c                   ; Decrement duration
  jr nz,PlaySquareWave1   ; Repeat until duration is zero
  ret

; SFX for Laser Fire.
;
; Used by the routine at LaserBeamDraw.
SfxLaserFire:
  ld c,$08                ; Pitch/duration
SfxLaserFire_0:
  ld b,c
SfxLaserFire_1:
  djnz SfxLaserFire_1
  ld a,$10                ; Play sound for desire duration
  out ($fe),a             ;
  ld b,c                  ;
SfxLaserFire_2:
  djnz SfxLaserFire_2     ;
  xor a
  out ($fe),a             ; Turn speaker OFF
  inc c                   ; Increment pitch
  ld a,c
  cp $38
  jr nz,SfxLaserFire_0    ; Repeat until pitch is $38
  ret

; Set the default explosion SFX params.
;
; The audio is triggered from the NewActor routine using the
; explosion_sfx_params data.
;
; Used by the routines at AlienCollisionAnimSfx, AlienKillAnimSfx1,
;      AlienKillAnimSfx2 and MeteorUpdate.
;
; Input:A selects SFX #1 or #2.
SfxSetExplodeParams:
  ld c,a
  sla c                   ; C=0 or 2
  ld b,$00
  ld de,explosion_sfx_params ; DE=explosion SFX params
  ld hl,explosion_sfx_defaults ; HL=explosion SFX param defaults
  add hl,bc               ; Set offset: first or second pair of bytes
  ld a,(hl)               ; Copy defaults to the params
  ld (de),a               ;
  inc hl                  ;
  inc de                  ;
  ld a,(hl)               ;
  ld (de),a               ;
  ret

; Default explosion SFX parameters.
;
; +----------+------------------+
; | Bytes(n) | Parameter        |
; +----------+------------------+
; | 1        | SFX 1: Frequency |
; | 2        | SFX 1: Duration  |
; | 3        | SFX 2: Frequency |
; | 4        | SFX 2: Duration  |
; +----------+------------------+
explosion_sfx_defaults:
  defb $0c,$04,$0d,$04

; Play Jetman death SFX.
;
; Input:IX The explosion SFX params array.
SfxJetmanDeath:
  dec (ix+$01)            ; Decrement the SFX duration
  jr z,SfxFinishReturn    ; Stop playing SFX if duration is zero
  ld c,$10                ; Frequency = 16
  jr SfxPlayExplosion     ; Play explosion SFX

; Play enemy death SFX.
;
; Input:IX The explosion SFX params array.
SfxEnemyDeath:
  dec (ix+$01)            ; Decrement the SFX duration
  jr z,SfxFinishReturn    ; Stop playing SFX if duration is zero
  ld a,(ix+$01)
  add a,$18
  ld c,a                  ; Frequency = Duration + 24

; Plays the explosion sound effect.
;
; The note pitch goes from `low` to `high`.
;
; Used by the routine at SfxJetmanDeath.
;
; Input:C note frequency.
SfxPlayExplosion:
  ld a,$10
  out ($fe),a             ; Turn speaker ON
  ld b,c                  ; Set duration
SfxPlayExplosion_0:
  djnz SfxPlayExplosion_0 ; Note continues for the frequency duration
  xor a
  out ($fe),a             ; Turn speaker OFF
  ld b,c
SfxPlayExplosion_1:
  djnz SfxPlayExplosion_1 ; Silence for the frequency duration
  dec c                   ; Decrement frequency (higher pitch)
  jr nz,SfxPlayExplosion  ; Repeat until frequency is zero
  ret

; Sound has finished playing.
;
; Input:IX The explosion SFX params array.
SfxFinishReturn:
  ld (ix+$00),$00         ; Set frequency to zero
  ret

; Animate explosion after killing an alien.
;
; Used by the routine at AlienCollisionAnimSfx.
ExplosionAfterKill:
  push ix
  ld ix,jetman_exploding_anim_state ; Jetman explosion animation object
  ld hl,jetman_direction  ; Jetman object
  ld c,(hl)               ; Assign direction to temp variable
  inc hl                  ; Animation X position
  ld a,(hl)               ; Set explosion X position to match Jetman X position
  ld (ix+$01),a           ;
  inc hl                  ; Set explosion Y position to match Jetman
  ld a,(hl)               ;
  ld (ix+$02),a           ;
  ld a,c                  ; A=Jetman direction
  call AnimationStateSet  ; Reset actor, which also sets anim object "state" to
                          ; $01
  pop ix
  xor a
  ld (jetman_direction),a ; Reset Jetman direction to not moving
  ret

; Enable animation, state false.
;
; Used by the routines at JetFighterUpdate, AlienCollisionAnimSfx,
; AlienKillAnimSfx1, AlienKillAnimSfx2, MeteorUpdate and JetmanWalk.
;
; Input:IX Animation object.
AnimationStateReset:
  ld a,(ix+$00)           ; Animating state
  and $c0
  or $03
  ld (ix+$05),$00         ; Set "state" to un-animated

; Enable animation and reset frame count.
;
; Used by the routine at AnimationStateSet.
;
; Input:A New direction value.
;       IX Animation object.
L6868:
  ld (ix+$06),a           ; Update direction
  ld (ix+$00),$08         ; Set animating to "yes"
  ld (ix+$04),$00         ; Reset frame count
  ret

; Enable animation, state true.
;
; Used by the routine at ExplosionAfterKill.
;
; Input:A New direction value.
;       IX Animation object.
AnimationStateSet:
  ld (ix+$05),$01         ; Set "state" to animating
  jr L6868

; Animates the explosion sprites.
;
; Input:IX Explosion animation object
AnimateExplosion:
  ld hl,current_alien_number ; Increment current alien number
  inc (hl)                   ;
  ld c,(ix+$04)           ; C=explosion animation frame
  ld b,(ix+$05)           ; B=explosion animation state
  ld a,(game_timer)       ; Game timer
  and b
  jr nz,AnimateExplosion_0 ; Increment frame if timer&state is zero
  inc (ix+$04)             ;
AnimateExplosion_0:
  ld a,c                  ; A=original frame count
  sla c                   ; Multiply by 2 (addresses are two-bytes)
  ld b,$00
  ld hl,explosion_sprite_table ; HL=explosion sprite lookup table
  add hl,bc               ; Set offset
  ld e,(hl)               ; DE=address of the desired sprite
  inc hl                  ;
  ld d,(hl)               ;
  ld l,(ix+$01)           ; Set HL to Y,X coords of sprite
  ld h,(ix+$02)           ;
  cp $06                  ; Comparing with original frame count from 687e
  jr nc,AnimateExplosion_1 ; If original frame >= 6 then animation has finished
  cp $03
  jr nc,AnimateExplosion_2 ; If original frame >= 3 then half animated
  call ActorEraseAnimSprite ; Erase animation sprite
  ld a,(random_number)    ; A=random number
  and $07
  or $42
  ld (ix+$03),a           ; Update colour attribute to a random colour
  jp ColourizeSprite      ; Colourize the sprite
; After an explosion, we check if it was the player that died!
AnimateExplosion_1:
  ld a,(ix+$06)           ; Update anim object so "animating" = "direction"?
  ld (ix+$00),a           ;
  call ActorUpdatePosDir  ; Update Actor position direction
  call ActorFindDestroy   ; Find and destroy actor
  ld (ix+$00),$00         ; Reset "animating"
  ld a,(ix+$06)           ; Animation object "direction"
  and $3f
  cp $03
  jp c,PlayerTurnEnds     ; Player was killed if < 3 (end of turn)
  ret
; Called when half the explosion has been animated.
AnimateExplosion_2:
  call GetSpritePosition  ; Get sprite screen position
  jp ActorEraseDestroyed  ; Erase a destroyed actor

; Explosion sprites lookup table.
;
; Sprite addresses are repeated because on first use they are animated using a
; pink colour, then animated again in black, so as to make them disappear.
explosion_sprite_table:
  defw gfx_explosion_small ; Small explosion
  defw gfx_explosion_medium ; Medium explosion
  defw gfx_explosion_big  ; Large explosion
  defw gfx_explosion_small ; Small explosion
  defw gfx_explosion_medium ; Medium explosion
  defw gfx_explosion_big  ; Large explosion

; Frame rate limiter.
;
; Called at the beginning of each game loop. Setting a higher pause value will
; slow down aliens, and the speed at which fuel/collectibles fall.
FrameRateLimiter:
  ld a,(frame_ticked)     ; A=frame ticked?
  and a
  ret nz                  ; We have a new frame, so no pause
; Execute an end-of-frame pause for the correct game speed
  ld hl,$00c0              ; HL=pause counter (192)
FrameRateLimiter_0:
  dec hl                   ;
  ld a,l                   ;
  or h                     ;
  jr nz,FrameRateLimiter_0 ;
  ret

; Copy the two sprites for an alien to the buffers.
;
; Used by the routine at LevelInit.
AlienBufferInit:
  ld hl,alien_sprite_table ; HL=alien sprite lookup table
  ld a,(player_level)     ; Current player level
  rlca
  rlca
  and $1c
  ld e,a                  ; DE=offset address for lookup table
  ld d,$00                ;
  add hl,de               ; Add offset
  push hl
  ld de,buffer_alien_r1   ; DE=first alien sprite buffer
  call RocketBuildStateReset ; Reset rocket and copy sprite to buffer
  pop hl
  ld de,buffer_alien_l1   ; DE=second alien sprite buffer
  jp JetmanRocketStateUpdate ; Copy sprite to buffer

; Alien sprite lookup table.
;
; Aliens have three basic movement types:
;
; * Single path: die upon impact with platforms.
; - Meteor
; - Jet Fighter
; - Space Craft
; * Variable path: direction changes randomly, or on platform collision.
; - Squidgy Alien
; - Sphere Alien
; - Crossed Ship
; * Chasers: move toward Jetman, avoid platform impacts.
; - UFO
; - Frog Alien
alien_sprite_table:
  defw gfx_meteor1        ; Level #1: Meteor        (frame 1)
  defw gfx_meteor2        ; -                     - (frame 2)
  defw gfx_squidgy_alien1 ; Level #2: Squidgy Alien (frame 1)
  defw gfx_squidgy_alien2 ; -                     - (frame 2)
  defw gfx_sphere_alien1  ; Level #3: Sphere Alien  (frame 1)
  defw gfx_sphere_alien2  ; -                     - (frame 2)
  defw gfx_jet_fighter    ; Level #4: Jet Fighter
  defw gfx_jet_fighter
  defw gfx_ufo            ; Level #5: UFO
  defw gfx_ufo
  defw gfx_cross_ship     ; Level #6: Crossed Space Ship
  defw gfx_cross_ship
  defw gfx_space_craft    ; Level #7: Spacecraft
  defw gfx_space_craft
  defw gfx_frog_alien     ; Level #8: Frog Alien
  defw gfx_frog_alien

; Frame update and disabled item drop.
;
; Also does the self-modifying code update.
;
; Output:IX Address of Jetman object
FrameUpdate:
  di                      ; This routine only called if EI, so we must now
                          ; disable
  ld a,(SYSVAR_FRAMES)    ; Update last_frame to current SYSVAR_FRAMES
  ld (last_frame),a       ;
  ld a,$01                ; Frame has ticked over, set to true
  ld (frame_ticked),a     ;
  push ix
; Do some the code modifying...
  ld hl,rocket_state      ; HL=points to the rocket object
  ld (NewActor+$0d),hl    ; Modify `LD BC, nnnn` - rocket object
  ld a,$c3                ; Value is a `JP` opcode
  ld (NewActor+$2b),a     ; Modify instruction to be `JP`
  ld hl,ResetModifiedInFrame ; HL=address to be modified
  ld (NewActor+$2c),hl    ; Modify `JP nnnn` address
; ...code modifying complete.
  ld ix,jetman_direction  ; IX=Jetman object
  jp MainLoop             ; Execute main loop

; New actor: reset the modified code to original values.
;
; Used by the routines at NewGame and ResetModifiedInFrame.
ResetModifiedCode:
  ld hl,inactive_jetman_state ; HL=inactive Jetman object
  ld (NewActor+$0d),hl    ; Reset `LD BC, 5D30` to use HL
  ld a,$3a                ; Value is a `LD A (nnnn)` opcode
  ld (NewActor+$2b),a     ; Restore modified opcode to `LD A (nnnn)`
                          ; instruction.
  ld hl,$0244
  ld (NewActor+$2c),hl    ; Restore to `LD A (nnnn)` address to 0244
  ret

; Reset the modified code within the current frame.
;
; Used by the routine at NewActor, but only after that routine's code has been
; modified by FrameUpdate.
ResetModifiedInFrame:
  call ResetModifiedCode  ; First, reset the self-modifying code
  pop ix                  ; Who does the push? Is it FrameUpdate ?
  xor a                   ; frame ticked=false - not a new frame
  ld (frame_ticked),a     ;
  ei                      ; Needed to tick over SYSVAR_FRAMES, main loop will
  ret                     ; disable interrupts with the frame update call

; Generate new game actor: alien, fuel, or collectible item.
;
; Depending on the self-modifying code state, this routine either generates a
; new item/alien, or updates the item drop game timer.
;
; Input:IX Item object.
NewActor:
  ld hl,random_number     ; Increment random number
  inc (hl)                ;
  ld de,$0008             ; Set offset
  add ix,de               ; Set IX to next group of bytes
  push ix                 ; Copy IX to HL
  pop hl                  ;
; The self-modifying code routines change the address here to be either the
; inactive player (5d88) or the rocket object (5d30).
  ld bc,inactive_jetman_state ; BC=inactive player or rocket object
  and a                   ; Clear the Carry flag
  sbc hl,bc               ; If object pointed to by IX is before BC object,
  jp c,MainLoop           ; then jump back to the main loop
; Read the keyboard to introduce a slight pause?
NewActor_0:
  ld a,$fe                ; Row: Shift,Z,X,C,V
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  bit 0,a                 ; Check if SHIFT key pressed
  jr z,NewActor_0         ; Jump if pressed
; Now increment timer and get new random number.
  ld hl,(game_timer)      ; Increment the game timer
  inc hl                  ;
  ld (game_timer),hl      ;
  ld h,$00                ; Make sure HL remains <= $00FF
  ld a,r                  ; Get a RANDOM number?
  ld c,a
; The self-modifying code routine changes this to `JP 6966`. That routine
; resets the interrupts, before changing instruction here to `LD A,(0244)` - an
; address in the ROM which always returns $C1.
  ld a,(random_number)    ; A=$C1, from 0244, because 5DCE is never used!
  add a,(hl)              ; A=byte from address $0000 - $00FF
  add a,c                 ; Add R to the number
  ld (random_number),a    ; Update random number
  ex af,af'                   ; Jump if current alien number < 3
  ld a,(current_alien_number) ;
  cp $03                      ;
  jr c,NewActor_1             ;
  ex af,af'                   ;
  and $1f
  jr nz,NewActor_4        ; Drop fuel/collectible if RND is < 32
  ld a,(current_alien_number) ; Drop fuel/collectible if current alien number
  cp $06                      ; >= 6
  jr nc,NewActor_4            ;
NewActor_1:
  ld a,(begin_play_delay_counter) ; Drop fuel/collectible if begin play delay
  and a                           ; counter > zero
  jr nz,NewActor_4                ;
  ld a,(jetman_direction) ; Get jetman direction
  and $3f
  dec a
  jr z,NewActor_2         ; If direction is zero, then find unused alien slot
  dec a
  jr nz,NewActor_4        ; Drop fuel/collectible if direction is still > zero
; Find first unused alien slot.
NewActor_2:
  ld hl,alien_states      ; Alien state objects
  ld b,$06                ; Loop counter (6 aliens)
  ld de,$0008
NewActor_3:
  ld a,(hl)               ; Generate new alien if the slot is unused
  and a                   ;
  jp z,NewActor_5         ;
  add hl,de               ; else increment to the next alien object
  djnz NewActor_3         ; ...and try again
; Drop either a fuel pod or collectible item.
NewActor_4:
  call ItemNewFuelPod     ; New fuel pod item
  call ItemNewCollectible ; New collectible item
  jp MainLoopResetStack   ; Run main loop after resetting SP and EI
; Generate new alien in the given state slot (HL).
NewActor_5:
  push hl                 ; Push current alien to stack (will be copied to IX)
  ex de,hl
  ld hl,default_alien_state ; Copy default alien state to current alien slot
  ld bc,$0008               ;
  ldir                      ;
  pop ix                  ; Restore IX to point to current item object
  ld a,(game_timer)       ; Game timer
  ld e,a                  ; Backup to E
  and $40                 ; A=either 0 or 64
  ld (ix+$04),a           ; Set item "direction"
  ld (ix+$00),a           ; Set item "movement"
  ld a,e                  ; Restore A to original game timer value
  and $7f
  add a,$28
  ld (ix+$02),a           ; Update item Y position
  push ix                 ; Copy current item object address to BC
  pop bc                  ;
; Calculate and update new colour attribute.
  ld a,c                  ; Example: if BC = 5D78, C = $78 = 01111000
  rra                     ; 00111100
  rra                     ; 00011110
  rra                     ; 00001111
  and $03                 ; 00000011 <- result of AND $03
  inc a                   ; 00000100
  inc a                   ; 00000101 = $05
  ld (ix+$03),a           ; Update colour with value: $02, $03, $04, or $05
  and $01
  ld (ix+$06),a           ; Update jump table offset to either 0 or 1
  ld hl,item_level_object_types ; HL=item level object types
  ld a,(player_level)     ; Using the current player level, pull a value from
  and $07                 ; the item level params table
  ld e,a                  ;
  ld d,$00                ;
  add hl,de               ;
  ld a,(ix+$00)           ;
  and $c0                 ;
  or (hl)                 ;
  ld (ix+$00),a           ; Update item type to this value
  jp NewActor_4           ; Drop fuel/collectible then execute the main loop

; New item object types for each level - 8 bytes for 8 levels.
item_level_object_types:
  defb $03,$11,$06,$07,$0f,$05,$03,$0f

; Update Squidgy Alien.
;
; Input:IX Alien object.
SquidgyAlienUpdate:
  ld hl,current_alien_number ; Increment current alien number
  inc (hl)                   ;
  call ActorUpdateDir     ; Update actor direction
  call LaserBeamFire      ; Fire laser beam (returns C)
  dec c
  jp z,SquidgyAlienUpdate_8 ; Add the points for a kill if alien is dead
  call AlienCollision     ; Alien collision check (returns E)
  dec e
  jp z,AlienCollisionAnimSfx ; Alien killed by collision if E is zero
  xor a
  ld (alien_new_dir_flag),a ; Reset alien new direction flag
; Check which direction alien is travelling after hitting a platform.
SquidgyAlienUpdate_0:
  call JetmanPlatformCollision ; Platform collision (returns E)
  bit 2,e                   ; Update alien X position if bit-2 is reset
  jr z,SquidgyAlienUpdate_1 ;
  bit 7,e                    ; Set alien direction to up if bit-7 set
  jr nz,SquidgyAlienUpdate_4 ;
  bit 4,e                    ; Set alien direction to down if bit-4 set
  jr nz,SquidgyAlienUpdate_5 ;
; Alien has hit the end of a platform: change direction.
  ld a,e                  ; Update alien "moving" value
  and $40                 ;
  ld e,a                  ;
  ld a,(ix+$04)           ;
  and $bf                 ;
  or e                    ;
  ld (ix+$04),a           ;
; Update the alien X position.
SquidgyAlienUpdate_1:
  bit 6,(ix+$04)          ; Check alien moving left/right bit
  ld a,(ix+$01)           ; A=alien X position (fetch before the jump)
  jr z,SquidgyAlienUpdate_6 ; If moving left, subtract 2 from direction (via
                            ; jump)
  add a,$02               ; otherwise, we add 2 to move right
SquidgyAlienUpdate_2:
  ld (ix+$01),a           ; Set new X position +/- 2
; Update the alien Y position, first checking if within the upper/lower bounds
; of the screen.
  bit 7,(ix+$04)          ; Check alien moving up/down bit
  ld a,(ix+$02)           ; A=alien Y position (fetch before the jump)
  jr z,SquidgyAlienUpdate_7 ; If moving up, subtract 2 from direction (via
                            ; jump)
  add a,$02               ; otherwise, we add 2 to move down
SquidgyAlienUpdate_3:
  ld (ix+$02),a           ; Set new alien Y position +/- 2
; Draw the alien if new direction is set, otherwise repeat collision check
; again.
  ld a,(alien_new_dir_flag) ; Draw the alien if the new direction flag is set,
  and a                     ; otherwise, increment the value
  jp nz,DrawAlien           ;
  inc a                     ;
  ld (alien_new_dir_flag),a ;
  jr SquidgyAlienUpdate_0 ; Jump back and repeat collision check
; Change alien moving direction to up.
SquidgyAlienUpdate_4:
  res 7,(ix+$04)
  jr SquidgyAlienUpdate_1
; Change alien moving direction to down.
SquidgyAlienUpdate_5:
  set 7,(ix+$04)
  jr SquidgyAlienUpdate_1
; Subtract 2 from the X position (move left).
SquidgyAlienUpdate_6:
  sub $02
  jr SquidgyAlienUpdate_2
; Subtract 2 from the Y position (move up), unless it has reached top of
; screen.
SquidgyAlienUpdate_7:
  sub $02
  cp $24
  jr nc,SquidgyAlienUpdate_3 ; Return if not at top of screen
  set 7,(ix+$04)          ; Otherwise, set alien to moving down.
  jr SquidgyAlienUpdate_3
; Add score to player if alien is dead.
SquidgyAlienUpdate_8:
  ld bc,$0080             ; 80 points (decimal value)
  call AddPointsToScore   ; Add points to score
  jp AlienKillAnimSfx1    ; Kill Alien SFX #1

; Update UFO alien -- this alien is a chaser!
;
; TODO: annotations are really messy/wrong here, needs lots more work to
; understand how the movement is calculated.
;
; Input:IX Alien object.
UFOUpdate:
  ld hl,current_alien_number ; Increment current alien number
  inc (hl)                   ;
  call ActorUpdateDir     ; Update actor direction
  call LaserBeamFire      ; Fire laser beam (returns C)
  dec c
  jp z,UFOKillAddPoints   ; Add the points for a kill if alien is dead
  call AlienCollision     ; Alien collision check (returns E)
  dec e
  jp z,AlienCollisionAnimSfx ; Alien killed by collision if E is zero
  xor a
  ld (alien_new_dir_flag),a ; Reset alien new direction flag
; Check which direction alien is travelling after hitting a platform.
UFOUpdate_0:
  call JetmanPlatformCollision ; Platform collision (returns E)
  bit 2,e                 ; Update alien X position if bit-2 is reset
  jr z,UFOUpdate_1        ;
  bit 7,e                 ; Set alien direction to up if bit-7 set
  jp nz,UFOUpdate_15      ;
  bit 4,e                 ; Set alien direction to down if bit-4 set
  jp nz,UFOUpdate_16      ;
; Move the flying saucer in a slightly more erratic way (the XOR), rather than
; just heading directly for the Jetman.
  ld a,e                  ; Update alien "moving" value
  and $40                 ;
  xor $40                 ;
  ld e,a                  ;
  ld a,(ix+$04)           ;
  and $bf                 ;
  or e                    ;
  ld (ix+$04),a           ;
; Calculate new horizontal position and speed.
UFOUpdate_1:
  ld a,(ix+$05)           ; Alien X speed
  ld b,a                  ; Calculate new speed?
  and $0f                 ;
  ld c,a                  ;
  ld a,b                  ;
  and $f0                 ;
  ld b,a                  ;
  ld a,(jetman_pos_x)     ; Jetman X position
  sub (ix+$01)            ; Subtract alien X position
  jp p,UFOUpdate_7        ; If Jetman X > alien X, then jump
  bit 6,(ix+$04)          ; If alien is moving left, then jump
  jp z,UFOUpdate_10       ;
  ld a,c                  ; If current speed is less than max, then increment
  cp $0f                  ;
  jr nc,UFOUpdate_2       ;
  inc a                   ;
; Calculate new X position.
UFOUpdate_2:
  ld c,a                  ; C=current speed
  ld h,(ix+$01)           ; H=X position
  call UFOUpdate_17       ; Calculates and returns DE, new position offset
  and a                   ; Clear the carry flag
  sbc hl,de
; Update the X position and speed
UFOUpdate_3:
  ld (ix+$01),h           ; Update X position
  ld a,l                  ; Calculate and update X speed
  and $f0                 ;
  or c                    ;
  ld (ix+$05),a           ;
; Calculate new Y position and speed.
  ld a,(ix+$06)           ; Alien Y speed
  ld b,a
  and $0f
  ld c,a
  ld a,b
  and $f0
  ld b,a
  ld a,(jetman_pos_y)     ; Jetman Y position
  sub (ix+$02)            ; Subtract alien Y position
  jp p,UFOUpdate_11       ; If Jetman Y > alien Y, then jump
  bit 7,(ix+$04)          ; If alien is moving up then increment Y position (if
  jp z,UFOUpdate_14       ; not at top of screen) and jump to 6b49
  ld a,c                  ; Calculate new down Y position if C > 0 (presumably
  dec a                   ; above the ground)
  jr nz,UFOUpdate_12      ;
  res 7,(ix+$04)          ; else moving direction must be set to up...
UFOUpdate_4:
  ld c,a                  ; ..and C will have been decremented here
  ld h,(ix+$02)           ; H=Y position
  call UFOUpdate_17       ; Calculates and returns DE, new position offset
  and a                   ; Clear the carry flag
  sbc hl,de
UFOUpdate_5:
  ld a,h                  ; Set moving direction as down if at top of screen
  cp $28                  ;
  jr nc,UFOUpdate_6       ;
  set 7,(ix+$04)          ;
UFOUpdate_6:
  ld (ix+$02),a           ; Update Y position
  ld a,l                  ; Update Y speed
  and $f0                 ;
  or c                    ;
  ld (ix+$06),a           ;
; Draw the alien if a new direction is set, otherwise repeat platform collision
; check again.
  ld a,(alien_new_dir_flag) ; Draw the alien if the new direction flag is set,
  and a                   ; otherwise, increment it
  jp nz,DrawAlien
  inc a
  ld (alien_new_dir_flag),a ; }
  jp UFOUpdate_0          ; Jump back and repeat collision check
; Check moving direction and update.
UFOUpdate_7:
  bit 6,(ix+$04)          ; Check moving left/right bit
  jr z,UFOUpdate_9        ; If moving left, increment speed (via jump)
  ld a,c
  dec a
  jp nz,UFOUpdate_2       ; If not zero, calculate X direction/speed
  res 6,(ix+$04)          ; else set X moving to "right"
UFOUpdate_8:
  ld c,a                  ; A (speed) was decremented from 0, so will now be FF
  ld h,(ix+$01)           ; H=X position
  call UFOUpdate_17       ; Calculates and returns DE, new position offset
  add hl,de
  jp UFOUpdate_3          ; Update the X position and speed
UFOUpdate_9:
  ld a,c                  ; If current speed is less than max, then increment
  cp $0f                  ;
  jr nc,UFOUpdate_8       ;
  inc a                   ;
  jr UFOUpdate_8          ; Update position
UFOUpdate_10:
  ld a,c                  ; A=speed
  dec a
  jp nz,UFOUpdate_8       ; Update X position and speed unless zero
  set 6,(ix+$04)          ; Set moving direction to "right"
  jp UFOUpdate_2          ; Update X direction/speed
UFOUpdate_11:
  bit 7,(ix+$04)          ; Check Jetman moving direction
  jr z,UFOUpdate_13       ; Jump if top bit not set
  ld a,c                  ; Jump if C >= 15
  cp $0f                  ;
  jr nc,UFOUpdate_12      ;
  inc a                   ; else increment it
UFOUpdate_12:
  ld c,a                  ; (will be C = C - 1)
  ld h,(ix+$02)
  call UFOUpdate_17       ; Calculates and returns DE, new position offset
  add hl,de
  jp UFOUpdate_5          ; Update Y position and speed
UFOUpdate_13:
  ld a,c                  ; A=speed
  dec a
  jr nz,UFOUpdate_4       ; If speed > 0 move upwards
  set 7,(ix+$04)          ; else set moving direction to "down"
  jr UFOUpdate_12         ; ...and update Y position and speed
UFOUpdate_14:
  ld a,c                  ; If current speed is less than max, then increment
  cp $0f                  ; it, and update position
  jp nc,UFOUpdate_4       ;
  inc a                   ;
  jp UFOUpdate_4          ;
; Change alien moving direction to up.
UFOUpdate_15:
  res 7,(ix+$04)
  jp UFOUpdate_1
; Change alien moving direction to down.
UFOUpdate_16:
  set 7,(ix+$04)
  jp UFOUpdate_1
; Returns DE (new position) as calculated from the speed (C).
UFOUpdate_17:
  ld l,b
  ld a,c                  ; C should be <= 15. Example, if value is $0F:
  rla                     ; 0 00011110
  rla                     ; 0 00111100
  rla                     ; 0 01111000
  rla                     ; 0 11110000
  and $f0                 ; Clear lower 4 bits...just in case!
  ld e,a
  ld d,$00
  sla e                   ; 1 11100000
  rl d                    ; If E >= 8, then bit-0 of D is set
  ret

; Add points for UFO kill.
;
; Used by the routine at UFOUpdate.
UFOKillAddPoints:
  ld bc,$0050             ; 50 points (decimal value)
  call AddPointsToScore   ; Add points to score

; Alien Killed SFX #1 - no score added.

; When alien was killed by laser fire, reset anim state, set explosion SFX
; params. Used by the routine at SquidgyAlienUpdate.
;
; Used by the routine at SquidgyAlienUpdate.
AlienKillAnimSfx1:
  call AnimationStateReset ; Update actor state
  xor a                   ; A should be 0 for the Alien SFX
  jp SfxSetExplodeParams  ; Plays explosion SFX for an Alien

; Update Sphere alien.
;
; Input:IX Alien object.
SphereAlienUpdate:
  ld hl,current_alien_number ; Increment current alien number
  inc (hl)                   ;
  call ActorUpdateDir     ; Update actor direction
  xor a
  ld (alien_new_dir_flag),a ; Reset alien new direction flag
  call LaserBeamFire      ; Fire laser beam (returns C)
  dec c
  ld bc,$0040             ; 40 points (decimal value)
  jp z,AlienKillAnimSfx2  ; Kill Alien SFX #2 if alien is dead
  call AlienCollision     ; Alien collision check (returns E)
  dec e
  jp z,AlienCollisionAnimSfx ; Alien killed by collision if E is zero
; Check which direction alien is travelling after hitting a platform.
SphereAlienUpdate_0:
  call JetmanPlatformCollision ; Platform collision (returns E)
  bit 2,e                  ; Update alien Y position if bit-2 is reset
  jr z,SphereAlienUpdate_1 ;
  bit 7,e                   ; Set alien direction to up if bit-7 set
  jr nz,SphereAlienUpdate_6 ;
  bit 4,e                   ; Set alien direction to down if bit-4 set
  jr nz,SphereAlienUpdate_7 ;
; Alien has hit the end of a platform: change direction.
  ld a,e                  ; Update alien "moving" value
  and $40                 ;
  ld e,a                  ;
  ld a,(ix+$04)           ;
  and $bf                 ;
  or e                    ;
  ld (ix+$04),a           ;
; Update the alien Vertical position.
SphereAlienUpdate_1:
  bit 0,(ix+$04)          ; Check alien moving direction
  jr nz,SphereAlienUpdate_2 ; Update Y position if vertical movement
  ld a,(random_number)    ; E=random number
  ld e,a                  ;
  and $0f
  jr nz,SphereAlienUpdate_2 ; Jump if != 0
  set 0,(ix+$04)          ; else set "moving" bit-0
  ld a,(game_timer)       ; Use Game timer to Y speed
  and $1f                 ;
  add a,$10               ;
  ld (ix+$06),a           ;
  ld a,e                  ; A=original random number
  and $80
  ld e,a                  ; E = 0 or 128
  ld a,(ix+$04)           ; Update alien "moving" to either 127 or 255
  and $7f                 ;
  or e                    ;
  ld (ix+$04),a           ;
  jr SphereAlienUpdate_0  ; Jump back and repeat collision check
; Update the alien Horizontal position.
SphereAlienUpdate_2:
  bit 0,(ix+$04)          ; Check alien "moving"
  jr z,SphereAlienUpdate_4 ; Update X position if horizontal movement
  ld a,(ix+$02)           ; else update Y position
; Update the alien Y position, first checking if within the upper/lower bounds
; of the screen.
  bit 7,(ix+$04)          ; Check moving up/down bit
  jr z,SphereAlienUpdate_8 ; If moving up, subtract 2 from direction (via jump)
  add a,$02               ; otherwise, we add 2 to move down
SphereAlienUpdate_3:
  ld (ix+$02),a           ; Set new Y position +/- 2
  dec (ix+$06)            ; Decrement Y speed
  jr nz,SphereAlienUpdate_4
  res 0,(ix+$04)          ; Reset bit-0 of alien "moving" if speed is zero
; Update the alien X position.
SphereAlienUpdate_4:
  ld a,(ix+$01)           ; A=X position (fetch before the jump)
  bit 6,(ix+$04)          ; Check moving left/right bit
  jr z,SphereAlienUpdate_9 ; If moving left, subtract 2 from direction (via
                           ; jump)
  add a,$02               ; otherwise, we add 2 to move right
SphereAlienUpdate_5:
  ld (ix+$01),a           ; Set new X position +/- 2
; Draw the alien if a new direction is set, otherwise repeat platform collision
; check again.
  ld a,(alien_new_dir_flag) ; Draw the alien if the new direction flag is set,
  and a                     ; otherwise, increment the value
  jp nz,DrawAlien           ;
  inc a                     ;
  ld (alien_new_dir_flag),a ;
  jp SphereAlienUpdate_0  ; Jump back and repeat collision check
; Change alien moving direction to up.
SphereAlienUpdate_6:
  res 7,(ix+$04)
  jr SphereAlienUpdate_1
; Change alien moving direction to down.
SphereAlienUpdate_7:
  set 7,(ix+$04)
  jr SphereAlienUpdate_1
; Subtract 2 from the Y position (move up), unless it has reached top of
; screen.
SphereAlienUpdate_8:
  sub $02
  cp $28
  jr nc,SphereAlienUpdate_3 ; Return if not at top of screen
  set 7,(ix+$04)          ; Otherwise, set to moving down
  jr SphereAlienUpdate_3
; Subtract 2 from horizontal direction.
SphereAlienUpdate_9:
  sub $02
  jr SphereAlienUpdate_5

; Update Actor direction.
;
; Used by the routines at JetFighterUpdate, SquidgyAlienUpdate, UFOUpdate,
; SphereAlienUpdate and CrossedShipUpdate.
;
; Input:IX Actor object.
ActorUpdateDir:
  call ActorUpdatePosDir  ; Update Actor position direction
  ld a,(ix+$00)           ; Actor direction
  and $c0
  or $03
  ld (actor+$02),a        ; Update actor "direction"
  ret

; Update crossed space ship.
;
; Input:IX Alien object.
CrossedShipUpdate:
  call ActorUpdateDir     ; Update actor direction
  ld hl,current_alien_number ; Increment alien number
  inc (hl)                   ;
  call LaserBeamFire      ; Fire laser beam (returns C)
  dec c
  jp z,CrossedShipKillPoints ; Add points and kill alien (type #3) if dead
  call AlienCollision     ; Alien collision (returns E)
  dec e
  jp z,AlienCollisionAnimSfx ; Alien killed by collision
  xor a
  ld (alien_new_dir_flag),a ; Reset alien new direction
; Crossed ship direction change on platform collision.
CrossedShipPlatformCollision:
  call JetmanPlatformCollision ; Platform collision (returns E)
  bit 2,e                  ; Update alien X position if bit-2 is reset
  jr z,CrossedShipMoveShip ;
  bit 7,e                 ; Set alien direction to up if bit-7 set
  jp nz,CrossedShipDirUp  ;
  bit 4,e                  ; Set alien direction to down if bit-4 set
  jp nz,CrossedShipDirUp_0 ;
; Alien has hit the end of a platform: change direction in a slightly more
; erratic way than other aliens (note the XOR).
  ld a,e                  ; Update alien "moving" value
  and $40                 ;
  xor $40                 ;
  ld e,a                  ;
  ld a,(ix+$04)           ;
  and $bf                 ;
  or e                    ;
  ld (ix+$04),a           ;
; Move crossed ship horizontally.
CrossedShipMoveShip:
  bit 6,(ix+$04)          ; Check moving left/right bit
  ld a,(ix+$01)           ; A=X position (fetch before the jump)
  jp nz,CrossedShipDirUp_1 ; If moving left, subtract 2 from direction (via
                           ; jump)
  add a,$02               ; otherwise, we add 2 to move right
; Update the alien YX position.
CrossedShipUpdate_0:
  ld (ix+$01),a           ; Set new X position +/- 2
  ld h,$00                ; HL=Y speed x 2
  ld l,(ix+$06)           ;
  add hl,hl               ;
  ld d,(ix+$02)           ; D=alien X position
  ld e,(ix+$05)           ; E=alien X speed
  bit 7,(ix+$04)          ; If alien moving is "up" subtract hl/de
  jr z,CrossedShipDirUp_2 ;
  add hl,de               ; else add them
; Update vertical position, direction, and speed.
CrossedShipUpdate_1:
  ld (ix+$05),l           ; Set alien X speed
  ld (ix+$02),h           ; Alien Y position = H
  ld a,h                    ; If alien is at top of screen, set to moving down
  cp $28                    ;
  jr nc,CrossedShipUpdate_2 ;
  set 7,(ix+$04)            ;
CrossedShipUpdate_2:
  bit 7,(ix+$04)          ; Check if moving up
  jr z,CrossedShipDirDown ; Change alien direction to down if it is
  inc (ix+$06)            ; else increment Y speed
  jr nz,CrossedShipUpdate_3 ; Jump if it wasn't $FF before the increment
  ld (ix+$06),$ff         ; else set Y speed to $FF
; Draw the alien if a new direction is set, otherwise repeat platform collision
; check again.
CrossedShipUpdate_3:
  ld a,(alien_new_dir_flag) ; Draw the alien if the new direction flag is set,
  and a                     ; otherwise, increment the value
  jr nz,DrawAlien           ;
  inc a                     ;
  ld (alien_new_dir_flag),a ;
  jr CrossedShipPlatformCollision ; Jump back and repeat collision check

; Draw an alien sprite to the screen.
;
; Input:IX Alien object.
DrawAlien:
  ld a,(ix+$00)           ; Backup alien direction
  push af                 ;
  and $c0                 ; Temporarily change alien direction
  or $03                  ;
  ld (ix+$00),a           ;
  call L7232              ; Update actor X position (using temp direction)
  call ColourizeSprite    ; Colourize the sprite
  pop af
  ld (ix+$00),a           ; Restore original direction
  ret

; Add score for crossed space ship kill.
;
; Used by the routine at CrossedShipUpdate.
CrossedShipKillPoints:
  ld bc,$0060             ; 60 points (decimal value)

; Alien Killed SFX #2.
;
; When alien was killed by laser fire, reset anim state, set explosion SFX
; params, and add score. Used by the routine at SphereAlienUpdate.
AlienKillAnimSfx2:
  call AddPointsToScore   ; Add points to score
  call AnimationStateReset ; Update actor state
  ld a,$01                ; Set SFX to type #2
  jp SfxSetExplodeParams  ; Play explosion sound with SFX type #2

; Change alien direction flag to up, and other updates.
;
; Used by the routine at CrossedShipPlatformCollision.
CrossedShipDirUp:
  res 7,(ix+$04)          ; Set alien to moving up
  ld a,(random_number)    ; Update Y speed using random number
  add a,$08               ;
  ld (ix+$06),a           ;
  jp CrossedShipMoveShip  ; Update alien position
; Change alien moving direction flag to down.
CrossedShipDirUp_0:
  set 7,(ix+$04)
  jp CrossedShipMoveShip  ; Update alien position
; Subtract 2 from X position.
CrossedShipDirUp_1:
  sub $02
  jp CrossedShipUpdate_0  ; Update alien YX position
; Change direction to down.
CrossedShipDirDown:
  dec (ix+$06)            ; Decrement Y speed
  jr nz,CrossedShipUpdate_3 ; If speed is zero, set to moving down
  set 7,(ix+$04)            ;
  jr CrossedShipUpdate_3  ; Draw alien and perform platform collision
; This entry point is used by the routine at CrossedShipUpdate.
CrossedShipDirUp_2:
  and a                   ; Reset Carry flag
  ex de,hl                ; Swap registers
  sbc hl,de               ; Subtract DE and Carry flag from HL
  jp CrossedShipUpdate_1  ; Update vertical position, direction, and speed

; Default alien state.
;
; Copied to the alien object when a new alien is instantiated.
default_alien_state:
  defb $03,$00,$00,$42,$80,$04,$00,$1c

; Update the meteor.
;
; Input:IX Alien object.
MeteorUpdate:
  call ActorUpdatePosDir  ; Update Actor position direction
  ld hl,current_alien_number ; Increment alien number
  inc (hl)                   ;
; Update the alien X position.
  ld a,(ix+$01)           ; A=X position
  bit 6,(ix+$04)          ; Check moving left/right bit
  jr nz,MeteorUpdate_3    ; If moving left, subtract 2 from direction (via
                          ; jump)
  add a,(ix+$05)          ; otherwise, we add alien X speed to value
MeteorUpdate_0:
  ld (ix+$01),a           ; Set new X position +/- 2
; Update the alien Y position.
  ld a,(ix+$02)           ; Add Y speed to current Y position
  add a,(ix+$06)          ;
  ld (ix+$02),a           ;
  call L7232              ; Update actor X position (using temp direction)
  call ColourizeSprite    ; Colourize the sprite
  call JetmanPlatformCollision ; Platform collision (returns E)
  bit 2,e                 ; Kill alien it collided with a platform
  jr nz,MeteorUpdate_2    ;
  call LaserBeamFire      ; Fire laser beam (returns C)
  ld a,c                  ; Kill alien if it is dead
  and a                   ;
  jr nz,MeteorUpdate_1    ;
  call AlienCollision     ; Alien collision check (returns E)
  dec e                      ; Alien killed by collision if E is zero. Player
  jp z,AlienCollisionAnimSfx ; gets no points!
  ret
; Add score for Meteor kill.
MeteorUpdate_1:
  ld bc,$0025             ; 25 points (decimal value)
  call AddPointsToScore   ; Add points to score
; Kill meteor - reset state, and play explosion SFX #1.
MeteorUpdate_2:
  call AnimationStateReset ; Update actor state
  xor a                   ; A should be 0 for the Alien SFX
  jp SfxSetExplodeParams  ; Plays explosion SFX for an Alien
; Subtract 2 from horizontal direction.
MeteorUpdate_3:
  sub (ix+$05)            ; Subtract X speed
  jr MeteorUpdate_0

; Alien Collision.
;
; Used by the routines at JetFighterUpdate, ItemCheckCollect,
; CollisionDetection, RocketUpdate, SquidgyAlienUpdate, UFOUpdate,
; SphereAlienUpdate, CrossedShipUpdate and MeteorUpdate.
;
;  Input:IX Alien object.
; Output:E as either $00 or $01.
AlienCollision:
  ld hl,jetman_direction  ; HL=Jetman object
  ld e,$00                ; Default value for E
  ld a,(hl)               ; Jetman direction
  and $3f
  dec a                   ; Jump if A - 1 == 0
  jr z,AlienCollision_0   ;
  dec a
  ret nz                  ; Return if A is not zero
AlienCollision_0:
  inc hl                  ; HL=Jetman X position
  ld a,(hl)
  sub (ix+$01)            ; Jetman X position - Alien X position
  jp p,AlienCollision_1   ; Make sure we have a positive byte
  neg                     ;
AlienCollision_1:
  cp $0c                  ; Return if A >= 12
  ret nc                  ;
  inc hl                  ; HL=Jetman Y position
  ld a,(hl)
  sub (ix+$02)            ; Jetman Y position - Alien Y position
  jp p,AlienCollision_2   ; Set D to 15 if it's still a positive number
  neg                     ; else: negate it
  ld d,(ix+$07)           ; D=alien sprite height
  add a,$0e
  jr AlienCollision_3     ; Compare and return
AlienCollision_2:
  ld d,$15                ; default D to 21
AlienCollision_3:
  cp d                    ; Return $00 if D >= A
  ret nc                  ;
  ld e,$01
  ret                     ; else return $01

; Fire a laser beam.
;
; Used by the routines at JetFighterUpdate, SquidgyAlienUpdate, UFOUpdate,
; SphereAlienUpdate, CrossedShipUpdate and MeteorUpdate.
;
;  Input:IX Alien object.
; Output:C Is either $00 or $01.
;        HL Pointer to current active laser beam object.
LaserBeamFire:
  ld de,$0008             ; offset
  ld hl,laser_beam_params ; Laser beam objects
  ld b,$04                ; Loop counter (4 laser beams)
LaserBeamFire_0:
  push hl                 ; HL: += 8 after first iteration
  ld a,(hl)               ; If current laser beam is in use, try next one
  and a                   ;
  jr z,LaserBeamFire_3    ;
  inc hl                  ; HL=Y position
  inc hl                  ; HL=X position: pulse #1
  inc hl                  ; HL=X position: pulse #2
  ld a,(hl)               ; A=pulse #2
  dec hl                  ; HL=X position: pulse #1
  bit 2,a                 ; Next iteration is bit-2 of pulse #2 is reset
  jr z,LaserBeamFire_3    ;
  and $f8
  sub (ix+$01)            ; Subtract alien X position from laser beam X
                          ; position
  jp p,LaserBeamFire_1    ; If positive number, check position and next
                          ; iteration
  neg
  ld c,$08
  jr LaserBeamFire_2
LaserBeamFire_1:
  ld c,$20
LaserBeamFire_2:
  cp c                    ; Next iteration if pulse X position is now >= 8/32
  jr nc,LaserBeamFire_3   ;
  dec hl                  ; HL=Y position
  ld a,(hl)
  sub (ix+$02)            ; Subtract alien Y position from laser beam Y
                          ; position
  neg
  jp m,LaserBeamFire_3    ; If subtraction was negative number, next iteration
  add a,$0c               ; else, add 12
  cp (ix+$07)             ; Next iteration if >= sprite height
  jp nc,LaserBeamFire_3   ;
  ld c,$01                ; else set return value to $01
  inc hl                  ; Update X position: pulse #1
  ld a,(hl)               ;
  and $f8                 ;
  ld (hl),a               ;
  pop hl                  ; Set HL to first byte of current group
  ret                     ; We're done here
LaserBeamFire_3:
  pop hl                  ; Try next laser beam object
  add hl,de               ;
  djnz LaserBeamFire_0    ;
  ld c,$00                ; Return $00
  ret                     ;

; Reads 2 bytes of pixel data from a sprite.
;
; Used by the routine at BufferWritePixel.
;
;  Input:B Loop counter - sprite height?
;        HL Address of byte for current sprite.
; Output:B Same value as on entry.
;        D First byte of pixel data.
;        E ????
;        C Second byte of pixel data.
;        HL Address to the next byte of the sprite.
SpriteReadTwoBytes:
  ld a,b                  ; Backup B value
  ex af,af'               ;
  ld e,$00                ; E=third byte - NULL on read
  ld c,(hl)               ; C=first pixel byte
  inc hl
  ld d,(hl)               ; D=second pixel byte
  inc hl                  ; Set HL to next byte (used later)
  ld a,b                  ; Return if B == 0
  and a                   ;
  ret z                   ;
; Rotating the bits.
SpriteReadTwoBytes_0:
  srl c                     ; Executes B times
  rr d                      ;
  rr e                      ;
  djnz SpriteReadTwoBytes_0 ;
  ex af,af'               ; Restore B to the entry value
  ld b,a                  ;
  ret

; Reverse all bits in Accumulator.
;
; Two buffers are used for sprites facing the opposite direction so we need to
; flip the bits such that %00100111 becomes %11100100.
ReverseAccBits:
  push bc                 ; Backup BC
  ld b,$08                ; Counter of 8-bits
ReverseAccBits_0:
  rrca                    ; Do the bit reversal
  rl c                    ;
  djnz ReverseAccBits_0   ;
  ld a,c                  ; Set return value
  pop bc                  ; Restore BC
  ret

; Flip byte pair of an alien sprite so it faces opposite direction.
;
; Used by the routine at BufferWritePixel.
;
;  Input:B Loop counter.
;        HL Pointer to current byte of sprite.
; Output:B Same value as on entry.
;        DE The flipped byte pair.
;        HL Pointer to next byte of sprite.
BufferFlipSprite:
  ld a,b                  ; Backup B value
  ex af,af'               ;
  ld c,$00
  ld a,(hl)               ; Get byte from sprite
  call ReverseAccBits     ; A=reversed byte
  ld e,a
  inc hl                  ; Get next byte from sprite
  ld a,(hl)               ;
  call ReverseAccBits     ; A=reversed byte
  ld d,a
  inc hl                  ; Point HL to next byte
  ld a,b                  ; Return if all bytes have been processed
  and a                   ;
  ret z                   ;
BufferFlipSprite_0:
  sla e                   ; Shift sprite 4-pixels to the right?
  rl d                    ;
  rl c                    ;
  djnz BufferFlipSprite_0 ;
  ex af,af'               ; Restore B to the original value
  ld b,a                  ;
  ret

; Write all sprite pixel bytes to buffer.
;
; Bytes are first shifted and/or flipped along the horizontal axis. Used by the
; routine at BufferCopySprite.
;
; Input:B Loop counter - sprite height.
;       HL Pointer to buffer for data to be written to.
BufferWritePixel:
  exx                     ; HL=sprite, HL'=buffer, B'=counter
  ld a,(jetman_rocket_mod_connected) ; Get next two bytes if Jetman rocket
  and a                              ; module status is zero
  jr z,BufferWritePixel_1            ;
  call BufferFlipSprite   ; DE=flipped byte pair
BufferWritePixel_0:
  push de
  push bc
  exx                     ; HL=buffer, B=counter
  pop de
  ld (hl),e               ; Write first byte
  inc hl
  pop de
  ld (hl),d               ; Write the second byte
  inc hl
  ld (hl),e               ; Write third byte
  inc hl                  ; HL=next buffer address
  djnz BufferWritePixel   ; Loop back, writing reversed sprite data to buffer
  ret                     ; We're done.
BufferWritePixel_1:
  call SpriteReadTwoBytes ; DE=two new bytes of sprite pixel data
  jr BufferWritePixel_0   ; Loop back, writing non-reversed sprite data to
                          ; buffer

; Copy Rocket sprites for current level to the buffers.
;
; Using the sprite lookup table, this routine calculates which Rocket sprites
; to copy to the buffers or the current level, then calls the copy routine.
; Used by the routines at RocketReset, PlayerTurnEnds and PickupRocketItem.
;
; Input:A Is the byte offset between the modules of the current rocket.
BufferCopyRocket:
  ld c,a
  ld a,(player_level)     ; A=player level. Example, if level 3:
  rrca                    ; A=10000001, C=1
  and $06                 ; A=00000000
  or c                    ; A=00001000 (e.g. if C=$08)
  ld c,a                  ; BC=sprite offset value
  ld b,$00                ;
  ld hl,collectible_sprite_table ; Collectible sprite lookup table
  add hl,bc
  ld de,buffer_item_r1    ; DE=start of rocket sprite buffers
  ld a,$02
  ld (rocket_mod_attached),a ; Set default for rocket module attached value
  xor a
  ld (jetman_rocket_mod_connected),a ; Set default for Jetman rocket module
                                     ; connected value
  ld c,$04                ; Loop counter
  xor a
BufferCopyRocket_0:
  push bc                 ; Backup loop counter
  ld b,a                  ; A starts at $00, then returns value from
                          ; PointerToSpritePixelDataAndCopy
  ld c,$01                ; C=sprite count
  call PointerToSpritePixelDataAndCopy ; HL=pointer to sprite pixel data
  ld a,b
  pop bc                  ; Restore loop counter
  dec hl                  ; HL=previous lookup table offset
  dec hl                  ;
  dec c                   ; Decrement loop counter
  jr nz,BufferCopyRocket_0 ; Repeat until counter is zero
  ret

; Initialise rocket build state for new level.
;
; After initialising, sprites are copied to the first pair of buffers. Used by
; the routine at AlienBufferInit.
;
; Output:A New Jetman module connect status.
RocketBuildStateReset:
  ld bc,$0002             ; BC=sprite count
  ld a,$04                   ; Start of new level rocket state
  ld (rocket_mod_attached),a ;
  xor a                   ; Used to reset Jetman module connect status
  jr L6F20

; Old unused routines.
L6EFA:
  defs $11

; Get address to sprite pixel data, and copy to a buffer.
;
; Looks up the address for a sprite from the lookup table, then points HL to
; the pixel data for that sprite. Used by the routine at BufferCopyRocket.
;
;  Input:HL Offset address in sprite lookup table.
;        DE Address of buffer to use.
; Output:HL Pointer to pixel data block.
PointerToSpritePixelDataAndCopy:
  push hl
  push de
  push bc
  ld a,(hl)               ; HL=sprite address, from lookup table
  inc hl                  ;
  ld h,(hl)               ;
  ld l,a                  ;
  inc hl                  ; HL=sprite "height"
  inc hl                  ; HL=sprite data block
  jr BufferCopySprite     ; Loop back up to the main copy routine

; Set the rocket building state on Jetman.
;
; After initialising the states, the sprites are then copied to the second pair
; of buffers. Used by the routine at AlienBufferInit.
JetmanRocketStateUpdate:
  ld bc,$0002             ; BC=sprite count
  ld a,$04                ; Redundant opcode
  ld a,(rocket_mod_attached) ; Redundant entry point for old code at 6F31
  ld a,$01                ; Will set Jetman module connect status

; Set Jetman module state.
;
; Used by the routine at RocketBuildStateReset.
L6F20:
  ld (jetman_rocket_mod_connected),a

; Get address to sprite pixel data.
;
; Used by the routine at BufferCopySprite.
;
;  Input:HL Offset address in sprite lookup table.
; Output:HL Pointer to pixel data block.
PointerToSpritePixelData:
  push hl
  push de
  push bc
  ld a,(hl)               ; HL=sprite address from lookup table
  inc hl                  ;
  ld h,(hl)               ;
  ld l,a                  ;

; Copies the sprite pixel data to a buffer.
;
; Note the copious amounts of register swapping! These annotations need
; checking. Used by the routine at PointerToSpritePixelDataAndCopy.
;
; Input:C Number of bytes to copy?
;       HL Address pointing to the "height" value in a sprite header
;       DE Address of buffer to use.
BufferCopySprite:
  push hl
  ex de,hl                ; Swap Sprite<->Buffer addresses
  exx
  pop hl                  ; HL=sprite address
  pop bc                  ; C (sprite count) is the important value
  push bc                 ; Copy the counter back on the stack
  ld a,(hl)               ; A=sprite height value
  ex af,af'               ; Backup "height" to A'
  inc hl                  ; HL=start of sprite pixel data
  exx                     ; HL=buffer, DE=sprite
  ld (hl),$00             ; Buffer: set first byte
  inc hl
  ld (hl),$03             ; Buffer: set sprite width
  inc hl                  ; Point Buffer to height variable
  ex af,af'               ; Restore A with height value
  cp $11                  ; Jump if height < 17 pixels
  jr c,BufferCopySprite_0 ;
  ld a,$10                ; else height=16 pixels
BufferCopySprite_0:
  ld (hl),a               ; Buffer: height will be <= 16
  inc hl                  ; Point Buffer to start of pixel data
  ld b,a                  ; B=height variable
  call BufferWritePixel   ; Write pixel to a buffer
  pop bc                  ; Reset BC to be only the sprite counter?
  pop hl                  ; HL=start of buffer
  ld de,$0033             ; HL=start of next buffer
  add hl,de               ;
  pop de                  ; DE=lookup table address
  ex de,hl                ; HL=sprite, DE=buffer
  inc hl                  ; HL=sprite width value
  inc hl                  ; HL=sprite height value
  ld a,(rocket_mod_attached) ; A=Rocket build state - only $02 or $04?
  add a,b
  ld b,a
  dec c                   ; Decrement the sprite counter
  jr nz,PointerToSpritePixelData ; Fetch next sprite address
  ret

; Create new laser beam.
;
; Find an unused laser beam slot - return if non free - then initialise and
; draw the laser GFX in the correct location and direction in relation to
; Jetman. Used by the routine at JetmanRedraw.
;
; Output:HL Address pointing to a free laser beam slot.
LaserNewIfFreeSlot:
  ld a,(SYSVAR_FRAMES)    ; Return unless one of first two bits of
  and $03                 ; SYSVAR_FRAMES are set
  ret nz                  ;
  ld hl,laser_beam_params ; HL=laser beam objects
  ld de,$0008
  ld b,$04                ; Loop counter for all 4 laser beams
LaserNewIfFreeSlot_0:
  ld a,(hl)               ; Get first byte of object
  and a
  jr z,LaserBeamInit      ; Initialise and draw laser beam, if unused
  add hl,de
  djnz LaserNewIfFreeSlot_0 ; Repeat until an unused beam is found
  ret                     ; Return if no free slots are available

; Initialise laser beam slot, and draw graphics.
;
; Used by the routine at LaserNewIfFreeSlot.
;
; Input:HL Address pointing to an unused laser beam.
LaserBeamInit:
  ld (hl),$10             ; Set first byte to 16: "used"
  inc hl                  ; Laser Y position
  ld de,jetman_direction  ; DE=Jetman object
  ld a,(de)               ; B=direction in which to draw laser beam, based on
  ld b,a                  ; Jetman movement action
  inc de
  ld a,(de)               ; A=Jetman X position
  and $f8
  or $05
  ld c,a                  ; C=laser beam X position
  bit 6,b                  ; Shoot laser right if Jetman is facing right
  jr z,LaserBeamShootRight ;
  sub $08                 ; else shoot laser beam left
  ld c,a                  ; C=Jetman X position - 8

; Draw laser beam.
;
; Used by the routine at LaserBeamShootRight.
;
; Input:C The X Position to start drawing the laser.
;       DE Jetman object (pointing to X position)
;       HL Laser beam object to be drawn (pointing to Y position)
LaserBeamDraw:
  inc de                  ; Jetman Y position
  ld a,(de)               ; Update the laser beam Y position to align with the
  sub $0d                 ; middle of the Jetman sprite
  ld (hl),a               ;
  inc hl                  ; Laser X position: pulse #1
  ld b,$03                ; Loop counter
  ld (hl),c               ; Update pulse #1
  ld a,c
  and $fb
LaserBeamDraw_0:
  inc hl                  ; Update the rest of the pulses: #2, #3 and #4
  ld (hl),a               ;
  djnz LaserBeamDraw_0    ;
  inc hl                  ; Update the laser beam "length" value, using the
  ld a,(random_number)    ; random_number as a base value
  and $38                 ;
  or $84                  ;
  ld (hl),a               ;
  inc hl                  ; DE points to laser beam "colour attribute"
  ex de,hl                ;
  ld hl,laser_beam_colours ; HL=Laser beam colour table
  ld a,(random_number)    ; Use random_number to point HL to one of the values
  and $03                 ; in the colour table
  ld c,a                  ;
  ld b,$00                ;
  add hl,bc               ;
  ld a,(hl)               ;
  ld (de),a               ; Assign laser beam "colour attribute" a new colour
  jp SfxLaserFire         ; Laser fire SFX

; Laser beam colour attribute table.
laser_beam_colours:
  defb $47,$43,$43,$45

; Shoots a laser beam to the right.
;
; Once position of Jetman's gun is located, we call the draw laser beam
; routine. Used by the routine at LaserBeamInit.
;
;  Input:C Jetman X position +/- a few pixels: 0-7 maybe?
;        DE Address of Jetman X position variable.
; Output:C New X position of laser beam.
LaserBeamShootRight:
  ld a,(de)               ; Jetman X position
  and $07                 ; Checking for any laser beam pixels?
  ld a,c
  jr z,LaserBeamShootRight_0 ; Increment X position if some laser pixels are
  add a,$08                  ; set
LaserBeamShootRight_0:
  add a,$10               ; Add 16 and reset bit-0
  and $fe                 ;
  ld c,a                  ; Set return value
  jr LaserBeamDraw        ; Draw laser beam

; Animate a laser beam.
;
; Note the copious amounts of register swapping! These annotations need
; checking.
;
; Input:IX Laser beam object
LaserBeamAnimate:
  ld d,(ix+$01)           ; Laser Y position
  ld a,(ix+$02)           ; Laser X position: pulse #1
  bit 2,a                 ; Jump if bit-2 is reset
  jr z,LaserBeamAnimate_3 ;
  ld l,a                  ; L=X position: pules #1
  ld a,$08
  bit 0,l                 ; Negate (A=$F8) if bit-0 of pulse #1 is reset
  jr z,LaserBeamAnimate_0 ;
  neg                     ;
LaserBeamAnimate_0:
  add a,l                 ; H=laser Y position, L=updated X position
  ld e,a                  ;
  ld h,d                  ;
  push hl                 ; Preserve HL - pulse Y,X position
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld a,(ix+$01)           ; Laser Y position
  cp $80                   ; Jump if Y position >= 128
  jr nc,LaserBeamAnimate_1 ;
  ld a,(hl)               ; A=byte at Y,X position of laser pulse #1
  and a
  jr nz,LaserBeamAnimate_5 ; Jump if byte is empty
; Update the on screen colour for the pulse.
LaserBeamAnimate_1:
  ld (ix+$02),e           ; Update X position: pulse #1
  ld (hl),$ff             ; Add a "full length" pulse to Y,X position
  pop hl                  ; Restores the pulse Y,X positions
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  ld a,(ix+$07)           ; Set screen colour attribute to the laser pulse
  ld (hl),a               ; colour
  ld a,(ix+$06)           ; Subtract 8 from laser pulse "length"
  sub $08                 ;
  ld (ix+$06),a           ;
  and $f8
  jr nz,LaserBeamAnimate_3 ; Jump if pulse length has bit 3-7 set
; Update the X position of all the laser beam pulses.
LaserBeamAnimate_2:
  res 2,(ix+$02)          ; Reset bit-2 of X position: pulse #1
LaserBeamAnimate_3:
  exx
  ld bc,$031c
  ld e,$e0                ; Loop counter (14)
  exx
  ld e,$03                ; Loop counter (to process pulses #2, #3, #4)
  push ix                 ; BC is now the laser beam object
  pop bc                  ;
  inc bc                  ; Laser beam Y position
  inc bc                  ; Laser beam X position: pulse #1
  inc bc                  ; Laser beam X position: pulse #2
; A loop (to the end of routine) which draws the pixel byte to the screen.
LaserBeamAnimate_4:
  ld a,(bc)               ; A=X position (loops on pulse #2, #3, #4)
  xor (ix+$02)            ; XOR with X position: pulse #1
  and $f8
  jr nz,LaserBeamAnimate_6 ; Jump if A has any of these bits set
  exx
  ld a,b
  ld b,c
  ld c,e
  exx
  inc bc                   ; Repeat for next X position pulse
  dec e                    ;
  jr nz,LaserBeamAnimate_4 ;
  ld (ix+$00),$00         ; Set laser beam to "unused"
  ret
; No pixel to draw, loop back and process next pulse.
LaserBeamAnimate_5:
  pop hl
  jr LaserBeamAnimate_2
; Update the length of the laser beam pulse.
LaserBeamAnimate_6:
  ld a,(bc)               ; Laser beam X position
  bit 2,a                  ; Jump if bit-2 is set
  jr nz,LaserBeamAnimate_7 ;
  dec (ix+$06)            ; Decrement pulse length
  ld a,(ix+$06)
  and $07                 ; Return if pulse has any pixels set?
  ret nz                  ;
  ld a,(random_number)    ; Random number
  and $03                 ; Calculate the length of the laser pulse
  or $04                  ;
  or (ix+$06)             ;
  ld (ix+$06),a           ;
  ld a,(bc)               ; Current X position += 4
  or $04                  ;
  ld (bc),a               ;
  ret
LaserBeamAnimate_7:
  ld a,(bc)
  ld l,a                  ; L=current X position pulse
  ld a,$08
  bit 0,l                 ; Negate (A=$F8) if bit-0 of pulse is reset
  jr z,LaserBeamAnimate_8 ;
  neg                     ;
LaserBeamAnimate_8:
  add a,l
  ld (bc),a               ; Update current X position
  ld h,d                  ; H=laser Y position, L=updated X position
  call Coord2Scr          ; HL=coord to screen address (using HL)
  exx
  ld a,b
  ld b,c
  ld c,e
  exx
; Create a new laser beam pixel and merge with current screen pixel.
  cpl                     ; Create the pixel byte. E.g. $FC=11111100
  and (hl)                ; Merge with current screen pixel
  ld (hl),a               ; Update display file
  inc bc                  ; Next X position byte
  dec e                   ;
  jp nz,LaserBeamAnimate_4 ; Repeat if counter > 0
  ret

; Display the remaining player lives in the status bar.
;
; Used by the routines at LevelInit, PlayerInit and RocketUpdate.
DisplayPlayerLives:
  ld hl,$0040             ; Screen column for Player 1
  call Coord2Scr          ; HL=coord to screen address (using HL)
  call P1GetLifeCount     ; A=Get player 1 lives count
  and a
  jr z,DisplayPlayerLives_2 ; Display empty space if no lives remaining
  call DisplayPlayerLives_1 ; Display lives counter and icon sprite
; Now display lives for inactive player.
DisplayPlayerLives_0:
  ld hl,$00b0             ; Screen column for Player 2
  call Coord2Scr          ; HL=coord to screen address (using HL)
  call P2GetLifeCount     ; A=Get player 2 lives count
  and a
  jr z,DisplayPlayerLives_3 ; Display empty space if no lives remaining
; Displays the lives count and sprite icon.
DisplayPlayerLives_1:
  add a,$30               ; ASCII character starting at `0` character
  call DrawFontChar       ; Display font character
  ld de,tile_life_icon    ; Sprite for the lives icon
  push bc
  push de
  jp L7124                ; Now display the number of lives
; Current player has no lives remaining, display spaces.
DisplayPlayerLives_2:
  call DisplayPlayerLives_3 ; Display " " for no lives
  jr DisplayPlayerLives_0 ; Display inactive player lives count
; Display just spaces instead of number + sprite.
DisplayPlayerLives_3:
  ld a,$20
  call DrawFontChar       ; Display " " font character
  ld a,$20
  jp DrawFontChar         ; Display " " font character

; Icon sprite of the little person shown next to number of lives.
tile_life_icon:
  defb $18,$24,$3c,$7e,$5a,$3c,$3c,$66

; Gets the remaining lives for player 1.
;
; Used for displaying the player lives in the status bar.
;
; Output:A Is the number of lives remaining
P1GetLifeCount:
  ld a,(current_player_number) ; Current player number
  and a
  jr nz,InactivePlayerLifeCount ; If not current player, use inactive player

; Reads the current player lives.
;
; Used by the routine at P2GetLifeCount.
CurrentPlayerLifeCount:
  ld a,(player_lives)     ; Current player lives remaining
  ret

; Reads inactive player lives.
;
; Used by the routines at P1GetLifeCount and P2GetLifeCount.
InactivePlayerLifeCount:
  ld a,(inactive_player_lives) ; Inactive player lives remaining
  ret

; Gets the remaining lives for player 2.
;
; Used for displaying the player lives in the status bar.
;
; Output:A Is the number of lives remaining
P2GetLifeCount:
  ld a,(current_player_number) ; Current player number
  and a
  jr z,InactivePlayerLifeCount ; If not current player, use inactive player
  jr CurrentPlayerLifeCount ; else get current player lives

; Add points to the active player's score.
;
; Used by the routines at JetFighterUpdate, ItemCheckCollect,
; CollectRocketItem, SquidgyAlienUpdate, UFOKillAddPoints, AlienKillAnimSfx2
; and MeteorUpdate.
;
; Input:C The number of points (in decimal) to be added to the score.
AddPointsToScore:
  ld a,(current_player_number) ; Use player 2 score if current player is 2
  and a                        ;
  jr nz,AddPointsToScore_0     ;
  ld hl,p1_score+$02      ; HL=Player 1 score byte #3
  jr AddPointsToScore_1
AddPointsToScore_0:
  ld hl,p2_score+$02      ; HL=Player 2 score byte #3
; Add the points to the current score.
AddPointsToScore_1:
  ld a,(hl)               ; Update score byte #3, with BCD conversion
  add a,c                 ;
  daa                     ;
  ld (hl),a               ;
  dec hl
  ld a,(hl)               ; Update score byte #2, with BCD conversion
  adc a,b                 ;
  daa                     ;
  ld (hl),a               ;
  dec hl
  ld a,(hl)               ; Update score byte #1, with BCD conversion
  adc a,$00               ;
  daa                     ;
  ld (hl),a               ;
  ld a,(current_player_number) ; Jump and show player 2 score if current player
  and a                        ; is 2, else show player 1
  jr nz,ShowScoreP2            ;

; Updates display to show player 1 score.
;
; Used by the routine at ResetScreen.
ShowScoreP1:
  ld hl,$4021             ; Screen address for score text
  ld de,p1_score          ; 3-byte score value
  jr DisplayScore         ; Display a score

; Updates display to show player 2 score.
;
; Used by the routines at ResetScreen and AddPointsToScore.
ShowScoreP2:
  ld hl,$4039             ; Screen address for score text
  ld de,p2_score          ; 3-byte score value
  jr DisplayScore         ; Display a score

; Updates display to show high score.
;
; Used by the routine at ResetScreen.
ShowScoreHI:
  ld hl,$402d             ; Screen address for score text
  ld de,hi_score          ; 3-byte hi score value

; Display a score.
;
; Scores are stored as decimal values in 3-bytes (making 999999 the maximum
; score). A score of 15,120 decimal is stored in hex as: $01,$51,$20. This
; routine displays each byte (reading left-to-right) of the score in two steps.
;
; Input:HL Screen address of the score to be written.
;       DE The 3-byte score value (P1, P2, HI).
DisplayScore:
  ld b,$03                ; Loop counter for the 3 bytes
DisplayScore_0:
  ld a,(de)               ; Score value. Example, if 85 points:
  rrca                    ; A=11000010, C=1
  rrca                    ; A=01100001, C=0
  rrca                    ; A=10110000, C=1
  rrca                    ; A=01011000, C=0
  and $0f                 ; A=00001000
  add a,$30               ; A=00111000 - $30 + $08 = ASCII char `8`
  call DrawFontChar       ; Display font character
  ld a,(de)               ; And again with the same byte:
  and $0f                 ; A=00000101
  add a,$30               ; A=00110101 - $30 + $05 = ASCII char `5`
  call DrawFontChar       ; Display font character
  inc de                  ; Process next score byte
  djnz DisplayScore_0     ;
  ret

; Display an ASCII character from the Font.
;
; An ASCII 8x8 tile graphic is fetched from the font data and drawn to the
; screen. As HL is multiplied by 3 a 256 bytes offset must first be subtracted.
;
;  Input:A Character (Z80 ASCII) used to fetch the character from the font.
;        HL Screen address where character should be drawn.
; Output:HL Location for the next location character.
DrawFontChar:
  push bc
  push de
  push hl
  ld l,a                  ; L=ASCII value
  ld h,$00
  add hl,hl               ; Calculate correct offset for ASCII character
  add hl,hl               ;
  add hl,hl               ;
  ld de,system_font-$0100 ; DE=base address of the font data - 256 bytes
  add hl,de               ; HL += base address
  ex de,hl                ; Store the character address in DE
  pop hl                  ; Restore HL

; Characters are 8 rows of pixels.
;
; Used by the routine at DisplayPlayerLives.
L7124:
  ld b,$08                ; Loop counter

; Draw the pixels for an ASCII character on screen
;
; Used by the routine at DrawPlatformTile.
;
;  Input:B Loop counter for no. of pixel rows - is always $08!
;        DE Address for desired character from the font set.
;        HL Display address for where to draw the character.
; Output:HL Next character location.
DrawCharPixels:
  ld a,(de)               ; Current byte from the font character
  ld (hl),a               ; Write byte to screen
  inc de                  ; Next row of font pixels
  inc h                   ; Next pixel line
  djnz DrawCharPixels     ; Repeat until 8x8 char displayed
  pop de
  pop bc
  ld a,h                  ; Reset display line
  sub $08                 ;
  ld h,a                  ;
  inc l                   ; Increment column
  ret

; Display string (with colour) on the screen.
;
; Calculates the start location in the DISPLAY/ATTRIBUTE files for writing the
; string, then executes WriteAsciiChars, which writes each individual character
; to the screen.
;
;  Input:DE Text data block (expects first byte to be a colour attr).
;        HL Screen address for writing the text.
; Output:A' Colour attribute for the text.
;        DE' Address to the ASCII characters for displaying.
;        HL' Screen address of next location.
;        HL Attribute file address of next location.
DisplayString:
  push hl                 ; Preserve display file address
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld a,(de)               ; A'=colour attribute
  ex af,af'               ;
  inc de                  ; DE=next colour attribute
  exx
  pop hl                  ; Set HL back to screen address
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)

; Write a list of ASCII characters to the screen.
;
; Used by the routine at MenuWriteText.
;
; Input:A' Colour byte for the entire string.
;       DE' Address to a list of ASCII character to display.
;       HL' Display file address for writing the string.
;       HL Attribute file address for writing the colour byte.
WriteAsciiChars:
  exx
  ld a,(de)               ; A=ASCII character value
  bit 7,a                 ; If EOL byte then extract and display character
  jr nz,WriteEOLChar      ;
  call DrawFontChar       ; Display font character
  inc de                  ; Get next character
  exx
  ex af,af'
  ld (hl),a               ; Write the colour attribute
  inc l                   ; Next column
  ex af,af'               ; Put colour attribute back in A'
  jr WriteAsciiChars      ; Loop back and display next character

; Write an EOL character to the screen.
;
; Game strings (e.g. score labels) set bit-7 on the last character to indicate
; it is EOL. This bit needs to be reset before displaying the character on the
; screen.
;
; Input:A' Colour byte for the character.
;       A The EOL ASCII character to be displayed.
;       HL Screen address for writing the string.
;       HL' Attribute file address for writing the colour byte.
WriteEOLChar:
  and $7f                 ; Turn off the EOL flag: bit-7
  call DrawFontChar       ; Display font character
  exx
  ex af,af'
  ld (hl),a               ; Write the colour byte
  ret

; Displays score labels at top of screen.
;
; Used by the routine at ResetScreen.
DrawStatusBarLabels:
  ld hl,$0018             ; Display "1UP" text at column 24
  ld de,Labels1UP         ;
  call DisplayString      ;
  ld hl,$0078             ; Display "HI" text at column 120
  ld de,LabelsHI          ;
  call DisplayString      ;
  ld hl,$00d8             ; Display "2UP" text at column 216
  ld de,Labels2UP         ;
  jp DisplayString        ;

; "1UP" score label - colour byte followed by ASCII characters.
Labels1UP:
  defb $47,$31,$55,$d0

; "2UP" score label - colour byte followed by ASCII characters.
Labels2UP:
  defb $47,$32,$55,$d0

; "HI" score label - colour byte followed by ASCII characters.
LabelsHI:
  defb $45,$48,$c9

; Clears the entire ZX Spectrum display file.
;
; Used by the routine at ResetScreen.
ClearScreen:
  ld hl,$4000             ; Beginning of display file
  ld b,$58                ; MSB to stop at (end of display file)

; Clear memory block with null.
;
; Used by the routine at NewGame.
;
; Input:B Loop counter: the MSB of the address to stop at.
;       HL Start address to begin filling.
ClearMemoryBlock:
  ld c,$00                ; Byte to use for the fill

; Fill a memory block with a byte value.
;
; Used by the routine at ClearAttrFile.
;
; Input:B Loop counter: the MSB of the address to stop at.
;       C Fill byte.
;       HL Start address to begin filling.
MemoryFill:
  ld (hl),c               ; Write the fill byte
  inc hl
  ld a,h
  cp b
  jr c,MemoryFill         ; Repeat until H matches B
  ret

; Clears the entire ZX Spectrum attribute file.
;
; PAPER=black, INK=white.
ClearAttrFile:
  ld hl,$5800             ; Attribute file
  ld b,$5b                ; MSB to stop at (end of attribute file)
  ld c,$47                ; Colour byte: PAPER=black, INK=white, BRIGHT
  jr MemoryFill           ; Fill memory

; Colourize a sprite.
;
; Using Actor, adds colour to a sprite, working from bottom-to-top,
; left-to-right. This also handles sprites that are wrapped around the screen.
; Used by the routines at JetFighterUpdate, ItemDisplaySprite, L650E, L6514,
; RocketAnimateFlames, UpdateRocketColour, AnimateExplosion, DrawAlien,
; MeteorUpdate and JetmanRedraw.
;
; Input:IX Jetman/Alien object.
ColourizeSprite:
  exx
  ld hl,(actor_coords)    ; HL=actor coords
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  ld a,(actor+$04)        ; Actor state "width"
  ld b,a                  ; B=width loop counter (in pixels)
  ld a,(actor+$03)        ; Actor state "height"
  rrca
  rrca
  inc a
  rrca
  and $1f
  inc a
  ld c,a                  ; C=height loop counter (in pixels)
  ld d,(ix+$03)           ; D=object colour attribute
  ld e,b                  ; E=width loop counter (in pixels)
ColourizeSprite_0:
  push hl
; Loop for updating attribute file with colour.
ColourizeSprite_1:
  ld a,h                  ; A=actor Y position
  cp $5b                  ; Decrement position if address is outside of
  jr nc,ColourizeSprite_3 ; attribute file address range
  cp $58                  ;
  jr c,ColourizeSprite_3  ;
  ld (hl),d               ; Otherwise, set the colour at this location
  inc l                   ; Next tile column
  ld a,l                  ; Next tile if column < screen width (32 chars)
  and $1f                 ;
  jr nz,ColourizeSprite_2 ;
  ld a,l                  ; else, wrap-around and continue applying colour
  sub $20
  ld l,a                  ; L=start of current row
ColourizeSprite_2:
  djnz ColourizeSprite_1  ; Loop back and continue with next tile
; Decrement the vertical position and colour the tiles.
ColourizeSprite_3:
  pop hl
  push bc
  and a                   ; Clear Carry flag
  ld bc,$0020             ; HL -= 32 tiles. Places address pointer previous
  sbc hl,bc               ; line
  pop bc
  ld b,e                  ; B=reset to original width counter
  dec c                   ; Decrement height counter
  jr nz,ColourizeSprite_0 ; Repeat until all tiles have been coloured
  ret

; Convert a Y,X pixel coordinate to an ATTRIBUTE_FILE address.
;
; Used by the routines at FlashText, ScoreLabelUnflash, MenuWriteText,
; LaserBeamAnimate, DisplayString, ColourizeSprite and DrawPlatforms.
;
;  Input:H Vertical coordinate in pixels (0-191).
;        L Horizontal coordinate in pixels (0-255).
; Output:HL An address in the attribute file.
Coord2AttrFile:
  ld a,l                  ; Horizontal coordinate. Example, if $B8:
  rrca                    ; A=01011100, C=0
  rrca                    ; A=00101110, C=0
  rrca                    ; A=00010111, C=0
  and $1f                 ; A=00010111 <- screen width?
  ld l,a                  ; L=$17
  ld a,h                  ; Vertical coordinate. Example, if $68:
  rlca                    ; A=00110100, C=0
  rlca                    ; A=00011010, C=0
  ld c,a                  ; Backup value to C
  and $e0                 ; A=00000000
  or l                    ; A=00010111
  ld l,a                  ; L=$17 <- new LSB of attribute file
  ld a,c                  ; Restore the row value
  and $03                 ; A=00000010 <- top of screen?
  or $58                  ; A=01011010
  ld h,a                  ; H=$5A <- ATTRIBUTE_FILE address (>= 5800)
  ret                     ; Return HL=5A17

; Sprite finder generic jump routine.
;
; Used by the routines at L7232 and ActorFindDestroy.
L71EC:
  call ActorFindPosDir    ; Find sprite using Actor

; Get location of Actor
;
; Used by the routines at ActorUpdatePosition and ActorDestroy.
L71EF:
  ld hl,(actor)           ; HL=Actor.X/Y position

; Get sprite position and dimensions.
;
; Note: the sprite header byte is added to the X position. So the question is:
; what is this header byte really for? Used by the routine at AnimateExplosion.
;
;  Input:DE Address to the start of a Sprite or Buffer.
;        HL The Y,X coordinate of the sprite.
; Output:B Is the sprite width.
;        C Is always NULL.
;        HL Screen address of sprite.
;        DE Address pointing to the pixel data block.
GetSpritePosition:
  ld a,(de)               ; A=header byte
  inc de                  ; DE=width byte
  add a,l                 ; L=X column + header byte
  ld l,a                  ;
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld a,(de)               ; B=sprite width
  ld b,a                  ;
  inc de                  ; A=sprite height
  ld a,(de)               ;
  ld (actor+$05),a        ; Set Actor current sprite height to this sprite
                          ; height

; Increment Sprite/Buffer address location.
;
; Used by the routine at ActorUpdate.
L7200:
  ld c,$00
  inc de                  ; DE=first byte of pixel data
  ret

; Sprite finder from X position.
;
; Used by the routines at L7232 and L727D.
L7204:
  call ActorGetSpriteAddressPosX ; Find sprite address using X position.

; Update Actor.
;
; Get sprite position/dimensions, and update actor. Used by the routines at
; ActorUpdatePosition and ActorEraseAnimSprite.
;
;  Input:DE Address to the start of a Sprite or Buffer.
;        IX Actor object for a fuel pod, collectible, etc.
; Output:B Is the sprite width.
;        C Is always NULL.
;        HL Screen address of sprite.
;        DE Address pointing to the pixel data block.
ActorUpdate:
  ld l,(ix+$01)           ; L=actor X location
  ld h,(ix+$02)           ; H=actor Y location
  ld a,(de)               ; A=sprite header byte
  inc de                  ; DE=sprite width byte
  add a,l                 ; L=X column + header byte
  ld l,a                  ;
  ld (actor_coords),hl    ; Set actor_coords variable with these actor
                          ; coordinates
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld a,(de)               ; B=sprite width
  ld b,a                  ;
  ld (actor+$04),a        ; Actor width=sprite width
  inc de                  ; A=sprite height
  ld a,(de)               ;
  ld (actor+$06),a        ; Set Actor sprite height
  ld (actor+$03),a        ; Set Actor height to sprite height
  jr L7200                ; Set return values (DE points to sprite pixel data)

; Update Actor X/Y positions.
;
; Used by the routines at ItemDisplaySprite and UpdateRocketColour.
ActorUpdatePosition:
  push de
  call L71EF              ; HL=Get sprite position
  exx
  pop de
  call ActorUpdate        ; Update actor
  exx
  jr ActorEraseSprite     ; Erase actor sprite

; Now update and erase the actor.
;
; Used by the routines at JetFighterUpdate, L650E, DrawAlien, MeteorUpdate and
; JetmanRedraw.
L7232:
  call L7204              ; Find sprite using X position and update actor
  exx
  call L71EC              ; Find sprite using actor and get address

; Erase Actor sprite from old position.
;
; Used by the routine at ActorUpdatePosition.
;
; Input:IX Actor object.
ActorEraseSprite:
  ld a,(actor+$01)        ; A=actor Y position
  sub (ix+$02)            ; Subtract the actor Y position
  jp z,ActorUpdateSize    ; Update actor size if 0
  jp m,ActorEraseSprite_0 ; Jump if result is negative
  ld c,a                  ; else C=result
  ld a,(actor+$05)        ; A=actor current sprite height
  cp c
  jp c,ActorUpdateSize    ; Update actor size if REGa < C
  sub c                   ; else subtract C
  ld (actor+$05),a        ; Update actor current sprite height
  jp MaskSprite           ; Mask sprite pixels
ActorEraseSprite_0:
  exx
  neg
  ld c,a
  ld a,(actor+$06)        ; A=actor sprite height
  cp c
  jp c,L7747              ; Update actor size if < C
  sub c
  jp L775B                ; Erase sprite pixels

; Find animation sprite position and erase its pixels.
;
; Used by the routines at L6514, RocketAnimateFlames and AnimateExplosion.
ActorEraseAnimSprite:
  call ActorUpdate        ; Update the Actor
  jr L7280                ; Erase sprite pixels

; Find Actor position, then erase its sprite.
;
; Used by the routines at ItemCheckCollect and RocketAnimateFlames.
ActorDestroy:
  call L71EF              ; Get sprite position
  jr ActorEraseDestroyed  ; Erase a destroyed actor

; Find an Actor and destroy it.
;
; Used by the routines at CollectRocketItem, PickupRocketItem, RocketUpdate and
; AnimateExplosion.
ActorFindDestroy:
  call L71EC              ; Find sprite and sprite position

; Erase a destroyed Actor.
;
; Used by the routines at AnimateExplosion and ActorDestroy.
ActorEraseDestroyed:
  exx
  xor a
  ld c,a
  ld (actor+$06),a        ; Actor sprite height = $00
  ld (actor+$03),a        ; Actor "height" = $00
  exx
  jp MaskSprite           ; Mask sprite pixels

; Unused?
L727D:
  call L7204

; Erase a sprite.
;
; Used by the routine at ActorEraseAnimSprite.
L7280:
  exx
  xor a
  ld (actor+$05),a        ; Actor current sprite height = $00
  ld c,a                  ; C = $00
  jp MaskSprite           ; Mask sprite pixels

; Find position and direction of an Actor.
;
; Used by the routine at L71EC.
ActorFindPosDir:
  ld a,(actor)            ; A=actor X position
  and $06
  ld c,a
  ld a,(actor+$02)        ; A=actor movement direction

; Get actor sprite address.
;
; Used by the routine at ActorGetSpriteAddressPosX.
;
;  Input:A Sprite header byte or Actor movement.
;        C Sprite header byte or X position.
; Output:DE Address for sprite.
ActorGetSpriteAddress:
  bit 6,a                      ; If bit-6 is set, then set bit 3 of C
  jr z,ActorGetSpriteAddress_0 ;
  set 3,c                      ;
ActorGetSpriteAddress_0:
  dec a                   ; Calculate offset for sprite lookup table
  rlca                    ;
  rlca                    ;
  rlca                    ;
  rlca                    ;
  and $f0                 ;
  or c                    ;
  ld c,a
  ld b,$00                ; BC=sprite lookup table offset
  ld hl,jetman_sprite_table ; HL=start of Jetman/Buffer sprite lookup tables
  add hl,bc
  ld e,(hl)               ; DE=sprite address
  inc hl                  ;
  ld d,(hl)               ;
  ret

; Get actor sprite address from X position.
;
; Used by the routine at L7204.
ActorGetSpriteAddressPosX:
  ld a,(ix+$01)           ; A=X position
  and $06
  ld c,a
  ld a,(ix+$00)           ; A=sprite header byte
  jr ActorGetSpriteAddress ; Get sprite address

; Related to erasing and masking sprites.
;
; Used by the routine at MaskSprite.
;
;  Input:HL Current position.
; Output:HL Address for new position.
EraseSpritesHelper:
  dec h
  ld a,h
  and $07
  cp $07
  ret nz
  ld a,l
  sub $20
  ld l,a
  and $e0
  cp $e0
  ret z
  ld a,h
  add a,$08
  ld h,a
  ret

; Unused code.
L72CB:
  defs $05

; Convert a Y,X pixel coordinate to a DISPLAY_FILE address.
;
; Used by the routines at MenuWriteText, LaserBeamAnimate, DisplayPlayerLives,
; DisplayString, GetSpritePosition, ActorUpdate and DrawPlatforms.
;
;  Input:H Vertical position in pixels (0-191).
;        L Horizontal position in pixels (0-255).
; Output:HL An address in the display file.
Coord2Scr:
  ld a,l                  ; Horizontal coordinate. Example, if $B8:
  rrca                    ; A=01011100, C=0
  rrca                    ; A=00101110, C=0
  rrca                    ; A=00010111, C=0
  and $1f                 ; A=00010111 <- screen width?
  ld l,a                  ; L=$17
  ld a,h                  ; Vertical coordinate. Example, if $68:
  rlca                    ; A=00110100, C=0
  rlca                    ; A=00011010, C=0
  and $e0                 ; A=00000000
  or l                    ; A=00010111
  ld l,a                  ; L=$17 <- new LSB of attribute file
  ld a,h                  ; Vertical coordinate. Example, if $68:
  and $07                 ; A=00000100
  ex af,af'               ; Puts the value into the shadow register
  ld a,h                  ; Vertical coordinate. Example, if $68:
  rrca                    ; A=00110100, C=0
  rrca                    ; A=00011010, C=0
  rrca                    ; A=00001101, C=0
  and $18                 ; A=00001000
  or $40                  ; A=00101000
  ld h,a                  ; HL=$48
  ex af,af'               ; Get the shadow register value
  or h                    ; A=00101100
  ld h,a                  ; H=$4C <- DISPLAY_FILE address (>= 4000)
  ret                     ; Return HL=4C68

; Copy actor position/direction values to Actor.
;
; Used by the routines at ItemCheckCollect, CollisionDetection,
; CollectRocketItem, RocketTakeoff, RocketLanding, RocketUpdate,
; AnimateExplosion, ActorUpdateDir, MeteorUpdate, JetmanFlyThrust and
; JetmanWalk.
;
; Input:IX Jetman object.
ActorUpdatePosDir:
  ld a,(ix+$01)           ; Actor X position = Jetman X position
  ld (actor),a            ;
  ld a,(ix+$02)
  ld (actor+$01),a        ; Actor Y position = Jetman Y position
  ld a,(ix+$00)
  ld (actor+$02),a        ; Actor movement = Jetman direction
  ret

; Joystick Input (Interface 2)
;
; The ROM cartridge was made for the Interface 2 which reads the Joystick I
; bits in the format of 000LRDUF, which are mapped to the keyboard keys: 6, 7,
; 8, 9, and 0. Note that a reset bit means the button is pressed.
;
; Used by the routines at ReadInputLR, ReadInputFire, ReadInputThrust and
;      JetmanFlyCheckThrusting.
;
; Output:A Joystick direction/button state.
ReadInterface2Joystick:
  ld a,$ef                ; Interface 2 Joystick port
  out ($fb),a
  in a,($fe)              ; A = bits for 000LRDUF
  ret

; Read input from the keyboard port.
;
; Used by the routines at JetmanFlyThrust and JetmanWalk.
;
; Output:A direction values $EF (L), $F7 (R) or $FF for no input detected -
;          like joystick: 000LRDUF.
ReadInputLR:
  ld a,(game_options)     ; Game options
  bit 1,a                 ; Use Joystick?
  jr nz,ReadInterface2Joystick ; Jump if so
; Read bottom-left row of keys.
  ld a,$fe                ; Row: Shift,Z,X,C,V
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  and $1e
  cp $1e                  ; Check if any keys on the row are pressed
  jr z,ReadInputLR_0      ; Jump if not - read inputs again
  and $14                 ; Reset all bits except X and V keys (RIGHT keys)
  cp $14                  ; Check if neither are pressed (reset)
  jr z,ReadInputLR_1      ; If so, a LEFT key was pressed: Z and C
  jr ReadInputLR_2        ; else RIGHT key was pressed: X and V
; Read bottom-right row of keys.
ReadInputLR_0:
  ld a,$7f                ; Row: B,N,M.Sym,Sp
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  and $1e
  cp $1e                  ; Check if any keys on the row are pressed
  jr z,ReadInputLR_3      ; Jump if not - no input detected.
  and $14                 ; Reset all bits except B and M keys (LEFT keys)
  cp $14                  ; Check if neither are pressed (reset)
  jr z,ReadInputLR_2      ; If so, a RIGHT key was pressed: N and Sym
ReadInputLR_1:
  ld a,$ef                ; A=LEFT_KEY  : 1110 1111
  ret
ReadInputLR_2:
  ld a,$f7                ; A=RIGHT_KEY : 1111 0111
  ret
ReadInputLR_3:
  ld a,$ff                ; A=No input detected
  ret

; Check if fire button is pressed.
;
; Used by the routine at JetmanRedraw.
;
; Output:A fire button, $FE = pressed, $FF = no input - like joystick:
;          000LRDUF.
ReadInputFire:
  ld a,(game_options)     ; Game options
  bit 1,a                 ; Use Joystick?
  jr nz,ReadInterface2Joystick ; Jump if so
  ld b,$02                ; Loop count: read left and right row of keys
  ld a,$fd                ; Row: A,S,D,F,G
ReadInputFire_0:
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  and $1f
  cp $1f                  ; Check if any keys on the row are pressed
  jr nz,ReadInputFire_1   ; Jump if so - key press detected
  ld a,$bf                ; Row: H,J,K,L,Enter
  djnz ReadInputFire_0    ; Loop back and read input again
  ld a,$ff                ; Still no input detected
  ret
ReadInputFire_1:
  ld a,$fe                ; A=FIRE : 1111 1110
  ret

; Check if thrust (up) button is pressed.
;
; Used by the routines at JetmanFlyCheckFalling and JetmanWalk.
;
; Output:A thrust button, $FE = pressed, $FF = no input - like joystick:
;          000LRDUF.
ReadInputThrust:
  ld a,(game_options)     ; Game options
  bit 1,a                 ; Use Joystick?
  jr nz,ReadInterface2Joystick ; Jump if so
  ld b,$02                ; Loop count: read left and right row of keys
  ld a,$fb                ; Row: Q,W,E,R,T
ReadInputThrust_0:
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  and $1f
  cp $1f                  ; Check if any keys on the row are pressed
  jr nz,ReadInputThrust_1 ; Jump if so - key press detected
  ld a,$df                ; Row: Y,U,I,O,P
  djnz ReadInputThrust_0  ; Loop back and read input again
  ld a,$ff                ; Still no input detected
  ret
ReadInputThrust_1:
  ld a,$fd                ; A=UP (thrust) : 1111 1101
  ret

; Game play starts, or prepare new turn, or check Jetman thrust input.
GamePlayStarts:
  ld hl,begin_play_delay_counter ; If begin play delay timer is zero (turn
  ld a,(hl)                      ; started), check to see if player is
  and a                          ; thrusting
  jr z,JetmanFlyThrust           ;
  dec (hl)                ; else decrement timer
  jp nz,ScoreLabelFlash   ; Flash Score label if still not zero
  call SfxPickupItem      ; SFX to indicate play is about to start!
  ld a,(current_player_number) ; Stop flashing 2UP if current player number is
  and a                        ; 2
  jr nz,GamePlayStarts_1       ;
  ld hl,$0018             ; Stop flashing "1UP" text
GamePlayStarts_0:
  call ScoreLabelUnflash  ;
  jr JetmanFlyThrust      ; Check if player is thrusting
GamePlayStarts_1:
  ld hl,$00d8             ; Stop flashing "2UP" text
  jr GamePlayStarts_0     ;

; Airborne Jetman update.
;
; Read thrust/direction controls and update position accordingly. Used by the
; routine at GamePlayStarts.
;
; Input:IX Jetman object.
JetmanFlyThrust:
  call ActorUpdatePosDir  ; Update actor position direction
  call ReadInputLR        ; Read Left/Right input
  bit 3,a                 ; Update Jetman direction for THRUST RIGHT
  jp z,JetmanFlyThrust_0  ;
  bit 4,a                  ; Jetman thrust left
  jp z,JetmanFlyThrustLeft ;
  ld a,(game_timer)       ; Game timer
  and $01                  ; If bit-0 is reset, fly horizontal
  jr z,JetmanFlyHorizontal ;
  jp JetmanFlyCalcSpeedX  ; Calculate new horizontal speed
JetmanFlyThrust_0:
  res 6,(ix+$00)          ; Set Jetman direction to be "right"
  bit 6,(ix+$04)          ; Flip direction if currently moving left
  jp nz,JetmanDirFlipX    ;

; Increase Jetman horizontal speed.
;
; Input:IX Jetman object.
JetmanFlyIncSpdX:
  ld a,(jetman_speed_modifier) ; Jetman speed modifier ($00 or $04)
  neg
  add a,$08
  add a,(ix+$05)          ; A += Jetman X speed
  cp $40
  jr nc,L73D6             ; Jump if speed >= max

; Update Jetman X speed with new value.
;
; Used by the routines at JetmanDirFlipX and JetmanFlyCalcSpeedX.
L73D1:
  ld (ix+$05),a           ; Update Jetman X speed with A (will be < 64)
  jr JetmanFlyHorizontal  ; Fly horizontally

; Set Jetman X speed to the max flying speed.
;
; Used by the routine at JetmanFlyIncSpdX.
L73D6:
  ld (ix+$05),$40

; Fly Jetman horizontally.
;
; Used by the routines at JetmanFlyThrust, L73D1 and JetmanDirFlipX.
;
;  Input:IX Jetman object.
; Output:H New X position.
;        L New Thrust value.
JetmanFlyHorizontal:
  ld h,$00
  ld l,(ix+$05)           ; Jetman X speed (will be <= 64)
  add hl,hl               ; Multiply X speed by 3
  add hl,hl               ;
  add hl,hl               ;
  ld d,(ix+$01)           ; D=Jetman X position
  ld a,(actor+$07)        ; Actor thrust
  ld e,a
  bit 6,(ix+$04)              ; Decrease Jetman X position if moving right
  jp nz,JetmanFlyDecreasePosX ;
  add hl,de               ; else, increase X position

; Apply gravity to Jetman if no thrust button detected.
;
; Used by the routine at JetmanFlyDecreasePosX.
;
; Input:IX Jetman object.
;       H New X position.
;       L New Thrust value.
JetmanApplyGravity:
  ld a,l
  ld (actor+$07),a        ; Update Actor thrust
  ld (ix+$01),h           ; Set new Jetman X position
; Check if thruster is being aplpied
  ld a,(game_options)     ; Game options
  bit 1,a                       ; Use Joystick? Jump if so.
  jp nz,JetmanFlyCheckThrusting ;
; Induce a slight pause before reading keys - this is required so that the
; gravity kicks in. It also acts as an undocumented hover key.
  ld b,$02                ; Loop count: read left and right row of keys
  ld a,$ef                ; Read top-right row of keys
JetmanApplyGravity_0:
  out ($fd),a             ; Set port for reading keyboard
  in a,($fe)              ; ...and read that row of keys
  and $1f
  cp $1f                  ; Check if any keys on the row are pressed
  jr nz,L7438             ; Jump if so - hover Jetman
  ld a,$f7                ; Read top-left row of keys
  djnz JetmanApplyGravity_0 ; ...and repeat

; Check if Jetman is moving falling downward.
;
; Used by the routine at JetmanFlyCheckThrusting.
JetmanFlyCheckFalling:
  call ReadInputThrust    ; Check if THRUST button pressed (Joystick or Keys)
  bit 1,a                 ; Set Jetman to down position if not thrusting
  jp nz,JetmanSetMoveDown ;
  res 7,(ix+$00)          ; Jetman direction is DOWN or WALKing
  bit 7,(ix+$04)          ;
  jp nz,JetmanDirFlipY    ; Flip vertical direction if moving down

; Increase Jetman vertical speed.
;
; Used by the routine at JetmanSetMoveDown.
JetmanSpeedIncY:
  ld a,(jetman_speed_modifier) ; Jetman speed modifier ($00 or $04)
  neg
  add a,$08
  add a,(ix+$06)          ; A += Jetman Y speed
  cp $3f
  jr nc,L7448             ; Set vertical speed to max if >= 63

; Update Jetman vertical speed with new value.
;
; Used by the routine at JetmanDirFlipY.
L7433:
  ld (ix+$06),a           ; Y speed = A (is < 63)
  jr JetmanFlyVertical    ; Update vertical flying

; Set Jetman vertical speed to zero.
;
; Used by the routines at JetmanApplyGravity and JetmanFlyCheckThrusting.
L7438:
  ld (ix+$06),$00         ; Jetman Y speed is zero
  jr JetmanFlyVertical    ; Update vertical flying

; Check joystick input for FIRE or THRUST.
;
; Used by the routine at JetmanApplyGravity.
JetmanFlyCheckThrusting:
  call ReadInterface2Joystick ; Read Joystick
  bit 2,a                 ; Set Y speed to zero if not thrusting
  jp z,L7438              ;
  jr JetmanFlyCheckFalling ; else check if falling and update movement

; Set Jetman vertical speed to maximum.
;
; Used by the routine at JetmanSpeedIncY.
L7448:
  ld (ix+$06),$3f         ; Set Jetman Y speed to 63

; Fly Jetman vertically.
;
; Input:IX Jetman object.
JetmanFlyVertical:
  ld l,(ix+$06)           ; L=Jetman Y speed (will be <= 63)
  ld h,$00
  add hl,hl               ; Multiply vertical X speed by 3
  add hl,hl               ;
  add hl,hl               ;
  ld d,(ix+$02)           ; D=Jetman Y position
  ld a,(jetman_fly_counter) ; E=Jetman flying counter
  ld e,a                    ;
  bit 7,(ix+$04)          ; Move Jetman up if moving up
  jp z,JetmanFlyMoveUp    ;
  add hl,de               ; else move downwards

; Check vertical position while in mid-flight.
;
; Used by the routine at JetmanFlyMoveUp.
JetmanFlyCheckPosY:
  ld a,l                    ; Update Jetman flying counter
  ld (jetman_fly_counter),a ;
  ld (ix+$02),h           ; Update Jetman Y position
  ld a,h
  cp $c0
  jr nc,JetmanSetMoveUp   ; Move up if within screen limits: 42 to 192
  cp $2a
  jr c,JetmanHitScreenTop ; Check if hit top of screen

; Jetman flight collision detection.
;
; Input:IX Jetman object.
JetmanCollision:
  call JetmanPlatformCollision ; Platform collision detection (returns E)
  bit 2,e                 ; Redraw Jetman if bit-2 has not been set
  jr z,JetmanRedraw       ;
  bit 7,e                 ; Jetman lands on top of a platform
  jp nz,JetmanLands       ;
  bit 4,e                 ; Jetman hits bottom of a platform
  jr nz,JetmanBumpsHead   ;
; Jetman hits platform edge.
  ld a,e
  xor $40                 ; Update E to be either $00 or $40.
  and $40                 ;
  ld e,a                  ;
  ld a,(ix+$04)           ; Update Jetman moving direction
  and $bf                 ;
  or e                    ;
  ld (ix+$04),a           ;

; Redraw Jetman sprite on the screen.
;
; Every time this function is called, a check is also made to see if the player
; is pressing the fire button, and draws a laser beam if so.
JetmanRedraw:
  call L7232              ; Update and erase the actor
  call ColourizeSprite    ; Colour the sprite
  call ReadInputFire      ; Read the input for a FIRE button
  bit 0,a
  call z,LaserNewIfFreeSlot ; If pressed, Fire laser (if free slot is
                            ; available)
  ret

; Jetman hits the underneath of a platform.
;
; Used by the routine at JetmanCollision.
JetmanBumpsHead:
  set 7,(ix+$04)          ; Set Jetman to be moving down
  jr JetmanRedraw         ; Redraw Jetman

; Jetman lands on a platform.
;
; Used by the routine at JetmanCollision.
JetmanLands:
  res 7,(ix+$04)          ; Set Jetman to be standing still
  ld a,(ix+$00)           ; Jetman direction
  and $c0                 ; Reset FLY and WALK bits
  or $02                  ; Now set movement to WALK
  ld (ix+$00),a           ; Update Jetman direction to be walking
  ld (ix+$05),$00         ; Set Jetman X speed to stopped
  ld (ix+$06),$00         ; Set Jetman Y speed to stopped
  jr JetmanRedraw         ; Redraw Jetman

; Reset Jetman movement direction.
;
; Used by the routine at JetmanFlyCheckPosY.
JetmanSetMoveUp:
  res 7,(ix+$04)          ; Set Jetman to be moving up
  jr JetmanCollision      ; Jetman flight collision detection

; Jetman hits the top of the screen.
;
; Used by the routine at JetmanFlyCheckPosY.
JetmanHitScreenTop:
  set 7,(ix+$04)          ; Set Jetman to be moving down
  ld a,(ix+$06)           ; Jetman Y speed
  srl a
  jr z,JetmanCollision    ; Jetman collision detection if A was $00 or $01
  ld (ix+$06),a           ; Update Jetman Y speed
  jr JetmanCollision      ; Jetman flight collision detection

; Jetman is falling.
;
; Used by the routine at JetmanFlyCheckFalling.
JetmanSetMoveDown:
  set 7,(ix+$00)          ; Set Jetman direction to WALK/DOWN
  bit 7,(ix+$04)          ; Increment Jetman Y speed if moving down
  jp nz,JetmanSpeedIncY   ;

; Flip vertical direction Jetman is flying.
;
; Used by the routine at JetmanFlyCheckFalling.
JetmanDirFlipY:
  ld a,(jetman_speed_modifier) ; Jetman speed modifier ($00 or $04)
  sub $08                 ; A=$F8 or $FC
  add a,(ix+$06)          ; A += Jetman Y speed
  jp p,L7433              ; Update vertical speed if new speed is positive
  ld (ix+$06),$00         ; else set Y speed to zero
  ld a,(ix+$04)           ; Flip Jetman vertical moving direction
  xor $80                 ;
  ld (ix+$04),a           ;
  jp JetmanFlyVertical    ; Fly Jetman vertically

; Decrease Jetman X position.
;
; Used by the routine at JetmanFlyHorizontal.
JetmanFlyDecreasePosX:
  and a                   ; Reset Carry flag
  ex de,hl
  sbc hl,de
  jp JetmanApplyGravity   ; Update Jetman speed/dir if thrusting

; Jetman THRUST-LEFT input.
;
; Used by the routine at JetmanFlyThrust.
JetmanFlyThrustLeft:
  set 6,(ix+$00)          ; Set Jetman direction to be LEFT
  bit 6,(ix+$04)          ; Increase Jetman X speed if moving RIGHT
  jp nz,JetmanFlyIncSpdX  ;

; Flip Jetman left/right flying direction.
;
; Used by the routine at JetmanFlyThrust.
JetmanDirFlipX:
  ld a,(jetman_speed_modifier) ; Jetman speed modifier ($00 or $04)
  sub $08                 ; A=$F8 or $FC
  add a,(ix+$05)          ; A += Jetman X speed
  jp p,L73D1              ; Update horizontal speed if new speed is positive
  ld (ix+$05),$00         ; else set X speed to zero
  ld a,(ix+$04)           ; Flip Jetman left/right moving direction
  xor $40                 ;
  ld (ix+$04),a           ;
  jp JetmanFlyHorizontal  ; Fly Jetman vertically

; Move Jetman up: decrease Y position.
;
; Used by the routine at JetmanFlyVertical.
JetmanFlyMoveUp:
  and a                   ; Reset Carry flag
  ex de,hl
  sbc hl,de               ; Move upwards
  jp JetmanFlyCheckPosY   ; Check vertical position within screen limits

; Calculate new Jetman horizontal speed.
;
; Used by the routine at JetmanFlyThrust.
JetmanFlyCalcSpeedX:
  ld a,(jetman_speed_modifier) ; Jetman speed modifier ($00 or $04)
  sub $08                 ; A=$F8 or $FC
  add a,(ix+$05)          ; A += Jetman X speed
  jp p,L73D1              ; Update horizontal speed if new speed is positive
  xor a
  jp L73D1                ; Update horizontal speed to zero

; Jetman walking.
;
; Input:IX Jetman object.
JetmanWalk:
  call ActorUpdatePosDir  ; Update Actor position direction
  call ReadInputLR        ; Read Left/Right input
  bit 3,a                 ; Walk RIGHT
  jr z,JetmanWalk_3       ;
  bit 4,a                 ; Walk LEFT
  jp z,JetmanWalk_4       ;
  ld (ix+$05),$00         ; else set Jetman X speed to zero
JetmanWalk_0:
  call ReadInputThrust    ; Read THRUST button
  bit 1,a                    ; Walk off platform if thrusting
  jr z,JetmanWalkOffPlatform ;
  call JetmanPlatformCollision ; Platform collision check (returns E)
  bit 2,e                    ; Leave platform if bit-2 is reset
  jr z,JetmanWalkOffPlatform ;
  bit 3,e                 ; Redraw Jetman if bit-3 is reset
  jp z,JetmanRedraw       ;
  ld a,(ix+$05)           ; Jetman X speed
  and a
  jp nz,JetmanRedraw      ; Redraw Jetman if X speed > 0
  bit 6,(ix+$00)          ; Jetman leaves a platform, either left or right
  jr z,JetmanWalk_1       ; based on the value of bit-6. The X position is
  dec (ix+$01)            ; dec/inc appropriately, and the Redraw Jetman
  jp JetmanRedraw         ; routine is called. Note also that the X speed is
JetmanWalk_1:
  inc (ix+$01)            ; set to max walking speed, but this instruction
  ld (ix+$05),$20         ; might be irrelevant as hacking the speed value has
  jp JetmanRedraw         ; no noticeable effect.
; Jetman leaves a platform by thrusters or by walking.
JetmanWalkOffPlatform:
  ld a,(ix+$00)           ; Jetman direction
  and $c0                 ; Reset FLY and WALK bits
  or $01                  ; Now set movement to FLY
  ld (ix+$00),a           ; Update Jetman direction to be flying
  ld hl,(jetman_pos_x)    ; HL=Jetman Y,X position
  push ix
  ld ix,jetman_thruster_anim_state ; IX=Jetman thruster animation object
  ld a,(ix+$00)           ; Jump if thrusters are already being animated
  and a                   ;
  jr nz,JetmanWalk_2      ;
  ld (ix+$00),$03         ; else set thrusters to be animating?
  ld (jetman_thruster_anim_state+$01),hl ; Update thruster animation Y,X
                                         ; position
  call AnimationStateReset ; Update actor movement states
JetmanWalk_2:
  pop ix                  ; Restore IX to Jetman object
  dec (ix+$02)            ; Jetman Y position -= 2
  dec (ix+$02)            ;
  jp JetmanRedraw         ; Redraw Jetman
; Jetman walks right.
JetmanWalk_3:
  inc (ix+$01)            ; Jetman X position += 1
  res 6,(ix+$00)          ; Jetman direction is right
  res 6,(ix+$04)          ; Jetman moving direction to right
  ld (ix+$05),$20         ; Set Jetman X speed to maximum
  jp JetmanWalk_0         ; Loop back, checking again for THRUST input
; Jetman walks left.
JetmanWalk_4:
  dec (ix+$01)            ; Jetman X position -= 1
  set 6,(ix+$00)          ; Jetman direction is left
  set 6,(ix+$04)          ; Jetman moving direction to left
  ld (ix+$05),$20         ; Set Jetman X speed to maximum
  jp JetmanWalk_0         ; Loop back, checking again for THRUST input

; Related to horizontal platform collision detection - possibly flipping
; between sprite X position collision and Jetman direction collision...needs
; more work!
;
; Used by the routine at JetmanPlatformCollisionX.
;
; Input:A Sprite X position minus Platform X position?
;       IX Jetman or alien.
L75D1:
  ex af,af'
  ld a,(ix+$00)           ; Jetman/alien direction
  and $3f                 ; Value must be <= 63
  cp $03                  ; Jump if value == 3 (therefore never when Jetman)
  jr z,L75D1_0            ;
  ex af,af'               ; Restore A to entry value
  jr JetmanPlatformCollisionY ; Vertical collision detection
L75D1_0:
  ex af,af'               ; Flip again
  sub $09
  jp p,JetmanPlatformCollisionY ; Vertical collision detection, first
  add a,$09                     ; incrementing by $09 if A is negative
  jr JetmanPlatformCollisionY   ;

; Jetman/platform collision detection.
;
; NOTE: collision detection is location based not pixel/colour based, so even
; if platform tiles are not drawn, a collision will be detected! Used by the
; routines at JetFighterUpdate, ItemCheckCollect, CollisionDetection,
; SquidgyAlienUpdate, UFOUpdate, SphereAlienUpdate,
; CrossedShipPlatformCollision, MeteorUpdate, JetmanCollision and JetmanWalk.
;
;  Input:IX Jetman or Alien object.
; Output:E Collision state.
JetmanPlatformCollision:
  ld b,$04                ; Loop counter (4 platforms to check)
  ld hl,gfx_params_platforms ; Platform location/size params

; Horizontal platform collision detection for Jetman/Alien.
;
; Used by the routine at JetmanPlatformCollisionY.
;
; Input:HL Address of platform object.
;       IX Jetman or Alien object.
JetmanPlatformCollisionX:
  ld e,$00
  push hl
  inc hl                  ; A=Platform X position
  ld a,(hl)               ;
  sub (ix+$01)            ; Subtract Jetman/Alien X position
  jp p,L75D1              ; If positive, Horizontal collision detection
  neg
  set 6,e                 ; Set bit-6 and then vertical collision detection

; Vertical platform collision detection for Jetman/Aliens.
;
; Used by the routine at L75D1.
;
;  Input:A Sprite X position.
;        E Collision state on entry.
;        HL Address of platform object.
;        IX Jetman/Alien object.
; Output:E Collision state. Bit: 7=landed, 4=hits head, 3=?, 2=?.
JetmanPlatformCollisionY:
  inc hl                  ; Platform Y location
  inc hl                  ; Platform width
  cp (hl)                          ; X position >= width (no collision) so try
  jp nc,JetmanPlatformCollisionY_3 ; next platform
  add a,$12
  cp (hl)                         ; Set bit 3 if collision: X position >= width
  jp c,JetmanPlatformCollisionY_0 ;
  set 3,e                         ;
JetmanPlatformCollisionY_0:
  dec hl                  ; Platform Y location
  ld a,(hl)               ; A=platform Y position
  sub (ix+$02)            ; Subtract sprite Y position
  neg
  inc a                   ; Add 2
  inc a                   ;
  jp m,JetmanPlatformCollisionY_3 ; Next platform if no collision: Y position
                                  ; is negative
  cp $02                          ; A < 2, Landed on platform
  jr c,JetmanPlatformCollisionY_2 ;
  cp (ix+$07)                     ; A < sprite height, hits underneath of
  jr c,JetmanPlatformCollisionY_1 ; platform?
  dec a                   ; Subtract 2
  dec a                   ;
  cp (ix+$07)                      ; Next platform if no collision: Y position
  jr nc,JetmanPlatformCollisionY_3 ; >= sprite height
; Jetman hits the bottom of a platform
  set 4,e
JetmanPlatformCollisionY_1:
  set 2,e                 ; Set bit-2 (4) <- Jetman is leaving a platform?
  pop hl                  ; Set HL back to beginning of platform object
  ret
JetmanPlatformCollisionY_2:
  set 7,e                 ; Bit-7 indicates landing on a platform
  jr JetmanPlatformCollisionY_1
JetmanPlatformCollisionY_3:
  pop hl                  ; Set HL back to beginning of platform object
  inc hl                  ; Increment HL until is points to the start of the
  inc hl                  ; next platform sprite
  inc hl                  ;
  inc hl                  ;
  djnz JetmanPlatformCollisionX ; Loop back until all 4 platforms have been
                                ; checked
  ret

; Displays platforms on screen.
;
; Used by the routine at LevelInit.
DrawPlatforms:
  ld b,$04                ; Loop counter (4 platforms for draw)
  ld hl,gfx_params_platforms ; Platform location/size params
DrawPlatforms_0:
  push bc                 ; Backup loop counter
  ld a,(hl)               ; Process next platform if sprite colour is
  and a                   ; black/unused
  jp z,DrawPlatforms_3    ;
  inc hl                  ; C=X position
  ld c,(hl)               ;
  inc hl
  inc hl
  ld a,(hl)               ; A=platform width
  and $fc
  neg
  add a,c                 ; A += platform X position
  add a,$10               ; A += 16
  push hl
  dec hl                  ; H=Y position byte
  ld h,(hl)               ;
  ld l,a                  ; L=new X position
  call Coord2Scr          ; HL=coord to screen address (using HL)
  ld de,tile_platform_left ; DE=address for LEFT platform sprite
  call DrawPlatformTile   ; Draw LEFT platform tile pixels
  ex (sp),hl              ; Does this fetch the platform width value?
  ld a,(hl)               ;
  ex (sp),hl              ;
  srl a                   ;
  srl a                   ;
  sub $04                 ;
  ld b,a                  ; B=loop counter for # of middle platform sprites
  ld de,tile_platfor_mmiddle ; DE=address for MIDDLE platform sprite
DrawPlatforms_1:
  call DrawPlatformTile   ; Draw (all) MIDDLE platform tiles pixels
  djnz DrawPlatforms_1    ;
  ld de,tile_platform_right ; DE=address for RIGHT platform sprite
  call DrawPlatformTile   ; Draw RIGHT platform tile pixels
  pop hl
  ld a,(hl)               ; A=platform width
  and $fc
  neg
  add a,c                 ; A += X position
  add a,$10               ; A += 16
  push hl
  dec hl                  ; B=Y position
  ld b,(hl)               ;
  dec hl                  ; C=colour attribute
  dec hl                  ;
  ld c,(hl)               ;
  ld h,b                  ; HL=Y,X position
  ld l,a                  ;
  push bc
  call Coord2AttrFile     ; HL=coord to attribute file address (using HL)
  pop bc
  ex (sp),hl              ; Does this fetch the platform width value?
  ld a,(hl)               ;
  ex (sp),hl              ;
  srl a                   ;
  srl a                   ;
  sub $02                 ;
  ld b,a                  ; B=loop counter for # of middle platform sprites
  ld a,c                  ; Apply platform colour to ATTRIBUTE_FILE
DrawPlatforms_2:
  ld (hl),a               ;
  inc hl                  ; HL=next sprite position
  djnz DrawPlatforms_2    ; Repeat until all sprites are coloured
  pop hl                  ; Restore HL=platform object at "width" byte
  inc hl                  ; HL=beginning of next platform struct
  pop bc                  ; Restore BC for loop counter
  jr DrawPlatforms_4      ; Loop back and processing next platform
; These instructions are only called if current platform colour was black. Why
; would a platform colour be black?
DrawPlatforms_3:
  pop bc                  ; restore loop counter
  inc hl                  ; Place HL to beginning of next platform struct
  inc hl                  ;
  inc hl                  ;
  inc hl                  ;
DrawPlatforms_4:
  djnz DrawPlatforms_0    ; Loop back and process next platform
  ret

; Draws the pixels for a platform sprite to the screen.
;
; Used by the routine at DrawPlatforms.
DrawPlatformTile:
  push bc
  push de
  ld b,$08                ; Loop counter (8x8 pixel)
  jp DrawCharPixels       ; Draw character pixels for tile

; Platform sprite: left.
tile_platform_left:
  defb $2f,$7f,$ff,$dd,$fb,$7b,$71,$21

; Platform sprite: middle (repeated for width).
tile_platfor_mmiddle:
  defb $bd,$ff,$ff,$f7,$eb,$dd,$ad,$04

; Platform sprite: right.
tile_platform_right:
  defb $4c,$fe,$ff,$3e,$ff,$fe,$9c,$08

; Jetman sprite address lookup table.
jetman_sprite_table:
  defw gfx_jetman_fly_right1 ; Flying right 1
  defw gfx_jetman_fly_right2 ; Flying right 2
  defw gfx_jetman_fly_right3 ; Flying right 3
  defw gfx_jetman_fly_right4 ; Flying right 4
  defw gfx_jetman_fly_left4 ; Flying left 4
  defw gfx_jetman_fly_left3 ; Flying left 3
  defw gfx_jetman_fly_left2 ; Flying left 2
  defw gfx_jetman_fly_left1 ; Flying left 1
  defw gfx_jetman_walk_right1 ; Walking right 1
  defw gfx_jetman_walk_right2 ; Walking right 2
  defw gfx_jetman_walk_right3 ; Walking right 3
  defw gfx_jetman_walk_right4 ; Walking right 4
  defw gfx_jetman_walk_left4 ; Walking left 4
  defw gfx_jetman_walk_left3 ; Walking left 3
  defw gfx_jetman_walk_left2 ; Walking left 2
  defw gfx_jetman_walk_left1 ; Walking left 1

; Buffer sprite lookup table.
;
; NOTE: must directly follow jetman_sprite_table, is not accessed directly.
buffers_lookup_table:
  defw buffer_alien_r1    ; Baddie R1
  defw buffer_alien_r1    ; Baddie R1
  defw buffer_alien_r2    ; Baddie R2
  defw buffer_alien_r2    ; Baddie R2
  defw buffer_alien_l2    ; Baddie L2
  defw buffer_alien_l2    ; Baddie L2
  defw buffer_alien_l1    ; Baddie L1
  defw buffer_alien_l1    ; Baddie L1
  defw buffer_item_r1     ; Item R1
  defw buffer_item_r2     ; Item R2
  defw buffer_item_l1     ; Item L1
  defw buffer_item_l2     ; Item L2
  defw buffer_item_l2     ; Item L2
  defw buffer_item_l1     ; Item L1
  defw buffer_item_r2     ; Item R2
  defw buffer_item_r1     ; Item R1

; Erase sprite pixels when actor/sprite moves.
;
; Used by the routines at ActorEraseSprite, ActorEraseDestroyed, L7280 and
; L775B.
;
; Input:B Loop counter.
;       C Actor Y position, or zero?
;       DE Address into a sprite/buffer.
;       HL Address in the DISPLAY_FILE.
MaskSprite:
  ld a,c                  ; Jump if vertical position is zero
  and a                   ;
  jr z,MaskSprite_6       ;
  dec c                   ; else decrement
  push bc
  push hl
; Loop to create a mask of the sprite and it write to the screen.
MaskSprite_0:
  ld a,(de)               ; A=sprite byte
  cpl                     ; Create mask and write to screen
  and (hl)                ;
  ld (hl),a               ;
  inc de                  ; Next byte
  inc l                   ; Next column
  ld a,l
  and $1f
  jr nz,MaskSprite_1      ; If column is zero, subtract 32
  ld a,l                  ;
  sub $20                 ;
  ld l,a                  ;
MaskSprite_1:
  djnz MaskSprite_0       ; Repeat and process for next byte
  pop hl                  ; Restore HL to be the display file address
  call EraseSpritesHelper ; Calculate new position
  pop bc
  exx                     ; NOTE: what is in C' register before this swap?
  ld a,c                  ; Jump back to the top of routine if C is zero
  and a                   ;
  jr z,MaskSprite_5       ;
MaskSprite_2:
  dec c                   ; else decrement (vertical position?)
  push bc
  push hl
; Merging sprite with current on-screen sprite (the mask?)
MaskSprite_3:
  ld a,(de)               ; Merge with current on-screen byte (mask?)
  or (hl)                 ;
  ld (hl),a               ;
  inc de                  ; Next sprite byte
  inc l
  ld a,l                  ; A=next column number
  and $1f
  jr nz,MaskSprite_4      ; Set L to beginning of line if > 0 && < 32, and
  ld a,l                  ; repeat process for next byte
  sub $20                 ;
  ld l,a                  ;
MaskSprite_4:
  djnz MaskSprite_3       ; Repeat and process next byte
; Calculate position for next byte?
  pop hl
  call EraseSpritesHelper ; Calculate new position
  pop bc
MaskSprite_5:
  exx
  jr MaskSprite           ; Loop back to top of routine
MaskSprite_6:
  exx
  ld a,c                  ; Jump if C != 0
  and a                   ;
  jr nz,MaskSprite_2      ;

; EXX then update Actor.
;
; Used by the routine at ActorEraseSprite.
L7747:
  exx

; Update Actor height related values.
;
; Used by the routine at ActorEraseSprite.
ActorUpdateSize:
  ld a,(actor+$05)        ; Actor current sprite height
  ld c,a
  ld a,(actor+$06)        ; Actor sprite height
  or c                    ; Compare actor sprite height values
  ret z                   ; Return if both are zero
  xor a
  ld (actor+$05),a        ; Actor current sprite height = $00
  exx
  ld a,(actor+$06)        ; Actor sprite height
  ld c,a
  xor a

; Update Actor sprite height, then mask the sprite.
;
; Used by the routine at ActorEraseSprite.
L775B:
  ld (actor+$06),a        ; Update Actor sprite height
  exx
  jr MaskSprite           ; Mask sprite pixels

; Actor/Collectible sprites start with a 3-byte header.
;
; #TABLE(default,centre,:w)
; { =h Bytes(n) | =h Meaning }
; { 0 | Unknown Header Byte }
; { 1 | Width (tiles) }
; { 2 | Height (pixels)  }
; { 3... | Pixel data  }
; TABLE#

; Jetman sprite for flying right #1.
gfx_jetman_fly_right1:
  defb $00                ; Header byte
  defb $02,$18            ; Width (tiles), Height (pixels)
  defb $10,$00,$20,$00,$d8,$00,$44,$00 ; Pixel data follows
  defb $38,$00,$50,$1e,$00,$1c,$7c,$00
  defb $54,$18,$29,$f8,$3d,$f8,$7b,$80
  defb $5b,$c0,$74,$3e,$54,$d0,$74,$d0
  defb $57,$80,$60,$00,$67,$c0,$2e,$e0
  defb $2e,$e0,$2d,$e0,$0e,$00,$07,$80

; Jetman sprite for flying right #2.
gfx_jetman_fly_right2:
  defb $00
  defb $03,$18
  defb $0a,$00,$00,$50,$00,$00,$05,$00
  defb $00,$0a,$00,$00,$08,$80,$00,$15
  defb $07,$80,$00,$07,$00,$1f,$00,$00
  defb $15,$06,$00,$0a,$7e,$00,$0f,$7e
  defb $00,$1e,$e0,$00,$16,$f0,$00,$1d
  defb $0f,$80,$15,$34,$00,$1d,$34,$00
  defb $15,$e0,$00,$18,$00,$00,$19,$f0
  defb $00,$0b,$b8,$00,$0b,$b8,$00,$0b
  defb $78,$00,$03,$80,$00,$01,$e0,$00

; Jetman sprite for flying right #3.
gfx_jetman_fly_right3:
  defb $00
  defb $03,$18
  defb $01,$00,$00,$04,$00,$00,$10,$80
  defb $00,$06,$00,$00,$00,$80,$00,$06
  defb $c1,$e0,$00,$01,$c0,$07,$c0,$00
  defb $05,$41,$80,$02,$9f,$80,$03,$df
  defb $80,$07,$b8,$00,$05,$bc,$00,$07
  defb $43,$e0,$05,$4d,$00,$07,$4d,$00
  defb $05,$78,$00,$06,$00,$00,$06,$7c
  defb $00,$02,$ee,$00,$02,$ee,$00,$02
  defb $de,$00,$00,$e0,$00,$00,$78,$00

; Jetman sprite for flying right #4.
gfx_jetman_fly_right4:
  defb $00
  defb $03,$18
  defb $08,$00,$00,$00,$80,$00,$09,$20
  defb $00,$02,$40,$00,$00,$90,$00,$02
  defb $d0,$78,$00,$00,$70,$01,$f0,$00
  defb $01,$50,$60,$00,$a7,$e0,$00,$f7
  defb $e0,$01,$ee,$00,$01,$6f,$00,$01
  defb $d0,$f8,$01,$53,$40,$01,$d3,$40
  defb $01,$5e,$00,$01,$80,$00,$01,$9f
  defb $00,$00,$bb,$80,$00,$bb,$80,$00
  defb $b7,$80,$00,$38,$00,$00,$1e,$00

; Jetman sprite for flying left #1.
gfx_jetman_fly_left1:
  defb $08
  defb $02,$18
  defb $00,$08,$00,$04,$00,$1b,$00,$22
  defb $00,$1c,$78,$0a,$38,$00,$00,$3e
  defb $18,$2a,$1f,$94,$1f,$bc,$01,$de
  defb $03,$da,$7c,$2e,$0b,$2a,$0b,$2e
  defb $01,$ea,$00,$06,$03,$e6,$07,$74
  defb $07,$74,$07,$b4,$00,$70,$01,$e0

; Jetman sprite for flying left #2.
gfx_jetman_fly_left2:
  defb $08
  defb $02,$18
  defb $00,$50,$00,$0a,$00,$a0,$00,$50
  defb $01,$10,$e0,$a8,$e0,$00,$00,$f8
  defb $60,$a8,$7e,$50,$7e,$f0,$07,$78
  defb $0f,$68,$f0,$b8,$2c,$a8,$2c,$b8
  defb $07,$a8,$00,$18,$0f,$98,$1d,$d0
  defb $1d,$d0,$1e,$d0,$01,$c0,$07,$80

; Jetman sprite for flying left #3.
gfx_jetman_fly_left3:
  defb $00
  defb $03,$18
  defb $00,$00,$80,$00,$00,$20,$00,$01
  defb $08,$00,$00,$60,$00,$01,$00,$07
  defb $83,$60,$03,$80,$00,$00,$03,$e0
  defb $01,$82,$a0,$01,$f9,$40,$01,$fb
  defb $c0,$00,$1d,$e0,$00,$3d,$a0,$07
  defb $c2,$e0,$00,$b2,$a0,$00,$b2,$e0
  defb $00,$1e,$a0,$00,$00,$60,$00,$3e
  defb $60,$00,$77,$40,$00,$77,$40,$00
  defb $7b,$40,$00,$07,$00,$00,$1e,$00

; Jetman sprite for flying left #4.
gfx_jetman_fly_left4:
  defb $00
  defb $03,$18
  defb $00,$00,$10,$00,$01,$00,$00,$04
  defb $90,$00,$02,$40,$00,$09,$00,$1e
  defb $0b,$40,$0e,$00,$00,$00,$0f,$80
  defb $06,$0a,$80,$07,$e5,$00,$07,$ef
  defb $00,$00,$77,$80,$00,$f6,$80,$1f
  defb $0b,$80,$02,$ca,$80,$02,$cb,$80
  defb $00,$7a,$80,$00,$01,$80,$00,$f9
  defb $80,$01,$dd,$00,$01,$dd,$00,$01
  defb $ed,$00,$00,$1c,$00,$00,$78,$00

; Jetman sprite for walking left #1.
gfx_jetman_walk_left1:
  defb $08
  defb $02,$18
  defb $00,$00,$00,$00,$07,$80,$03,$80
  defb $01,$80,$00,$00,$01,$80,$03,$be
  defb $03,$aa,$03,$d4,$03,$fc,$03,$be
  defb $03,$da,$7c,$2e,$0b,$2a,$0b,$2e
  defb $01,$ea,$00,$06,$03,$e6,$07,$74
  defb $07,$74,$07,$b4,$00,$70,$01,$e0

; Jetman sprite for walking left #2.
gfx_jetman_walk_left2:
  defb $08
  defb $02,$18
  defb $00,$00,$00,$00,$7f,$80,$3b,$80
  defb $19,$80,$0b,$00,$17,$00,$0e,$f8
  defb $0e,$a8,$0f,$50,$0f,$f0,$0f,$e8
  defb $0f,$68,$f0,$b8,$2c,$a8,$2c,$b8
  defb $07,$a8,$00,$18,$0f,$98,$1d,$d0
  defb $1d,$c8,$1e,$c8,$01,$c0,$07,$80

; Jetman sprite for walking left #3.
gfx_jetman_walk_left3:
  defb $00
  defb $03,$18
  defb $00,$00,$00,$00,$00,$00,$07,$87
  defb $00,$03,$83,$80,$01,$85,$80,$00
  defb $ce,$00,$00,$dc,$00,$00,$7b,$e0
  defb $00,$7e,$a0,$00,$3d,$40,$00,$3f
  defb $c0,$00,$3d,$e0,$00,$3d,$a0,$07
  defb $c2,$e0,$00,$b2,$a0,$00,$b2,$e0
  defb $00,$1e,$a0,$00,$00,$60,$00,$3e
  defb $60,$00,$77,$40,$00,$77,$40,$00
  defb $7b,$40,$00,$07,$00,$00,$1e,$00

; Jetman sprite for walking left #4.
gfx_jetman_walk_left4:
  defb $00
  defb $03,$18
  defb $00,$00,$00,$00,$00,$00,$07,$f8
  defb $00,$03,$b8,$00,$01,$98,$00,$00
  defb $b0,$00,$01,$70,$00,$00,$ef,$80
  defb $00,$ea,$80,$00,$f5,$00,$00,$ff
  defb $00,$00,$f7,$80,$00,$f6,$80,$1f
  defb $0b,$80,$02,$ca,$80,$02,$cb,$80
  defb $00,$7a,$80,$00,$01,$80,$00,$f1
  defb $80,$01,$dc,$80,$01,$dc,$80,$01
  defb $ec,$80,$00,$1c,$00,$00,$78,$00

; Jetman sprite for walking right #1.
gfx_jetman_walk_right1:
  defb $00
  defb $02,$18
  defb $00,$00,$00,$00,$01,$e0,$01,$c0
  defb $01,$80,$00,$00,$01,$80,$7d,$c0
  defb $55,$c0,$2b,$c0,$3f,$c0,$7b,$c0
  defb $5b,$c0,$74,$3e,$54,$d0,$74,$d0
  defb $57,$80,$60,$00,$67,$c0,$2e,$e0
  defb $2e,$e0,$2d,$e0,$0e,$00,$07,$80

; Jetman sprite for walking right #2.
gfx_jetman_walk_right2:
  defb $00
  defb $02,$18
  defb $00,$00,$00,$00,$01,$fe,$01,$dc
  defb $01,$98,$00,$d0,$00,$e8,$1f,$70
  defb $15,$70,$0a,$f0,$0f,$f0,$1e,$f0
  defb $16,$f0,$1d,$0f,$15,$34,$1d,$34
  defb $15,$e0,$18,$00,$19,$f0,$0b,$b8
  defb $13,$b8,$13,$78,$03,$80,$01,$e0

; Jetman sprite for walking right #3.
gfx_jetman_walk_right3:
  defb $00
  defb $03,$18
  defb $00,$00,$00,$00,$00,$00,$00,$e1
  defb $e0,$01,$c1,$c0,$01,$a1,$80,$00
  defb $73,$00,$00,$3b,$00,$07,$de,$00
  defb $05,$7e,$00,$02,$bc,$00,$03,$fc
  defb $00,$07,$bc,$00,$05,$bc,$00,$07
  defb $43,$e0,$05,$4d,$00,$07,$4d,$00
  defb $05,$78,$00,$06,$00,$00,$06,$7c
  defb $00,$02,$ee,$00,$02,$ee,$00,$02
  defb $de,$00,$00,$e0,$00,$00,$78,$00

; Jetman sprite for walking right #4.
gfx_jetman_walk_right4:
  defb $00
  defb $03,$18
  defb $00,$00,$00,$00,$00,$00,$00,$1f
  defb $e0,$00,$1d,$c0,$00,$19,$80,$00
  defb $0d,$00,$00,$0e,$80,$01,$f7,$00
  defb $01,$57,$00,$00,$af,$00,$00,$ff
  defb $00,$01,$ef,$00,$01,$6f,$00,$01
  defb $d0,$f8,$01,$53,$40,$01,$d3,$40
  defb $01,$5e,$00,$01,$80,$00,$01,$8f
  defb $00,$01,$3b,$80,$01,$3b,$80,$01
  defb $37,$80,$00,$38,$00,$00,$1e,$00

; Meteor sprite #1.
gfx_meteor1:
  defb $0b
  defb $02,$f8,$02,$ec,$51,$8e,$27,$e3
  defb $93,$f9,$ef,$e3,$27,$9d,$5b,$c2
  defb $25,$f4,$01,$78,$08,$10

; Meteor sprite #2.
gfx_meteor2:
  defb $0b
  defb $04,$78,$02,$8c,$25,$a6,$17,$df
  defb $c3,$e3,$5b,$8f,$16,$3f,$4d,$9a
  defb $01,$e4,$04,$70,$00,$90

; Explosion sprite: BIG.
gfx_explosion_big:
  defb $00
  defb $03,$10
  defb $01,$f0,$00,$07,$f8,$86,$0f,$fe
  defb $f0,$6b,$fe,$f8,$fc,$ff,$fc,$ff
  defb $7f,$78,$ff,$be,$e4,$ff,$7e,$5e
  defb $7e,$f9,$bf,$7b,$ff,$df,$dd,$fe
  defb $ff,$3f,$ef,$be,$6f,$ef,$c4,$67
  defb $d3,$f8,$3b,$9c,$e0,$0f,$0e,$c0

; Explosion sprite: MEDIUM.
gfx_explosion_medium:
  defb $00
  defb $03,$10
  defb $00,$00,$00,$00,$00,$00,$00,$7c
  defb $00,$00,$e6,$00,$0e,$fe,$c0,$1f
  defb $7f,$e0,$1f,$bf,$c0,$1f,$d7,$f8
  defb $0f,$ef,$fc,$1f,$ef,$ec,$17,$df
  defb $bc,$1e,$ff,$d8,$09,$bf,$c0,$07
  defb $1f,$80,$00,$00,$00,$00,$00,$00

; Explosion sprite: SMALL.
gfx_explosion_small:
  defb $00
  defb $03,$10
  defb $00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$0c,$00,$01
  defb $de,$c0,$03,$df,$c0,$03,$ef,$c0
  defb $03,$ac,$70,$03,$df,$f8,$01,$ff
  defb $f8,$00,$2f,$b0,$00,$33,$00,$00
  defb $0e,$00,$00,$00,$00,$00,$00,$00

; U3 Rocket ship sprite: bottom.
gfx_rocket_u3_bottom:
  defb $00
  defb $02,$10
  defb $9e,$4f,$9e,$4f,$9e,$4f,$82,$41
  defb $5c,$2e,$5c,$2e,$28,$14,$7f,$fe
  defb $45,$fe,$45,$fe,$45,$fe,$45,$fe
  defb $7f,$fe,$a6,$65,$a6,$65,$d9,$98

; U3 Rocket ship sprite: middle.
gfx_rocket_u3_middle:
  defb $00
  defb $02,$10
  defb $d9,$9b,$ff,$ff,$8b,$ff,$8a,$11
  defb $8a,$dd,$8a,$d1,$8a,$dd,$8a,$d1
  defb $8b,$ff,$8b,$ff,$ff,$ff,$a6,$65
  defb $a6,$65,$d9,$9b,$d9,$9b,$7f,$fe

; U3 Rocket ship sprite: top.
gfx_rocket_u3_top:
  defb $00
  defb $02,$10
  defb $4b,$fe,$25,$fc,$25,$fc,$13,$f8
  defb $1e,$08,$09,$f0,$09,$f0,$09,$f0
  defb $08,$10,$05,$e0,$02,$40,$01,$80
  defb $01,$80,$01,$80,$01,$80,$01,$80

; U1 Rocket ship sprite: bottom.
gfx_rocket_u1_bottom:
  defb $00
  defb $02,$10
  defb $b8,$17,$b8,$17,$b9,$97,$89,$91
  defb $52,$ca,$55,$ea,$f5,$ef,$f4,$2f
  defb $af,$f5,$a9,$f5,$a9,$f5,$f9,$ff
  defb $b9,$f7,$b9,$f7,$b9,$f7,$b9,$f7

; U1 Rocket ship sprite: middle.
gfx_rocket_u1_middle:
  defb $00
  defb $02,$10
  defb $b9,$f7,$b9,$f7,$b9,$f7,$b9,$f7
  defb $89,$f1,$59,$f6,$59,$f6,$29,$f4
  defb $29,$fc,$19,$f8,$19,$18,$09,$b0
  defb $09,$30,$09,$b0,$09,$f0,$09,$10

; U1 Rocket ship sprite: top.
gfx_rocket_u1_top:
  defb $00
  defb $02,$10
  defb $09,$50,$09,$50,$09,$50,$09,$f0
  defb $09,$f0,$09,$f0,$09,$f0,$09,$f0
  defb $08,$10,$09,$f0,$05,$e0,$05,$e0
  defb $02,$c0,$02,$c0,$01,$80,$01,$80

; U5 Rocket ship sprite: bottom.
gfx_rocket_u5_bottom:
  defb $00
  defb $02,$10
  defb $80,$4f,$80,$4f,$c0,$4f,$df,$4f
  defb $d7,$4f,$d7,$4f,$d7,$21,$d7,$2e
  defb $d7,$a2,$57,$9c,$57,$fe,$37,$7e
  defb $37,$76,$1b,$76,$0b,$76,$0d,$76

; U5 Rocket ship sprite: middle.
gfx_rocket_u5_middle:
  defb $00
  defb $02,$10
  defb $0b,$76,$0c,$7c,$0f,$f6,$0f,$f6
  defb $0b,$16,$0b,$76,$0b,$16,$0b,$d6
  defb $0d,$16,$0b,$f6,$0b,$f6,$0b,$16
  defb $0b,$56,$0d,$52,$0b,$5a,$0b,$5a

; U5 Rocket ship sprite: top.
gfx_rocket_u5_top:
  defb $00
  defb $02,$10
  defb $0b,$fa,$0b,$fa,$0f,$fa,$0f,$fa
  defb $0c,$fa,$0c,$fa,$07,$f2,$04,$f2
  defb $04,$f2,$03,$f2,$01,$f2,$01,$f2
  defb $00,$f2,$00,$f2,$00,$7c,$00,$38

; U4 Rocket ship sprite: bottom.
gfx_rocket_u4_bottom:
  defb $00
  defb $02,$10
  defb $80,$01,$89,$f1,$89,$f1,$c9,$f3
  defb $c8,$13,$e5,$e7,$e5,$e7,$f2,$4f
  defb $f3,$cf,$fb,$dd,$8b,$d1,$ab,$d5
  defb $ab,$df,$ab,$d7,$fb,$df,$bb,$dd

; U4 Rocket ship sprite: middle.
gfx_rocket_u4_middle:
  defb $00
  defb $02,$10
  defb $bb,$dd,$bb,$dd,$97,$e9,$97,$e9
  defb $97,$e9,$8f,$f1,$8f,$f1,$8f,$f1
  defb $0f,$f0,$1f,$f8,$1f,$f8,$1f,$f8
  defb $1d,$b8,$19,$98,$11,$88,$19,$88

; U4 Rocket ship sprite: top.
gfx_rocket_u4_top:
  defb $00
  defb $02,$10
  defb $15,$88,$13,$88,$19,$88,$15,$88
  defb $1b,$98,$09,$90,$09,$90,$0d,$b0
  defb $05,$a0,$05,$a0,$07,$e0,$03,$c0
  defb $03,$c0,$03,$c0,$01,$80,$01,$80

; Gold bar collectible sprite.
gfx_gold_bar:
  defb $00
  defb $02,$08
  defb $ff,$fc,$80,$0e,$40,$1e,$40,$1f
  defb $20,$3f,$3f,$de,$1f,$ec,$0f,$f8

; Fuel pod sprite.
gfx_fuel_pod:
  defb $00
  defb $02,$0b
  defb $18,$18,$ff,$ff,$ff,$ff,$b8,$89
  defb $ba,$bb,$8a,$9b,$ba,$bb,$8a,$8b
  defb $ff,$ff,$ff,$ff,$18,$18

; Radiation collectible sprite.
gfx_radiation:
  defb $00
  defb $02,$0b
  defb $0f,$f8,$10,$04,$23,$e2,$41,$c1
  defb $60,$83,$20,$82,$6f,$7b,$4e,$39
  defb $24,$12,$10,$04,$0f,$f8

; Chemical weapon collectible sprite.
gfx_chemical_weapon:
  defb $00
  defb $02,$0d
  defb $70,$1c,$f8,$3e,$bf,$ee,$98,$26
  defb $70,$1c,$20,$08,$10,$10,$10,$10
  defb $0b,$a0,$0f,$e0,$05,$c0,$04,$c0
  defb $03,$80

; Plutonium collectible sprite.
gfx_plutonium:
  defb $00
  defb $02,$09
  defb $3f,$fc,$7f,$fe,$ff,$ff,$cf,$ff
  defb $c7,$ff,$c3,$ff,$60,$7e,$38,$3c
  defb $0f,$f0

; Diamond collectible sprite.
gfx_diamond:
  defb $00
  defb $02,$0c
  defb $01,$80,$03,$c0,$07,$e0,$0f,$f0
  defb $1f,$f8,$38,$1c,$68,$16,$47,$e2
  defb $2f,$f4,$1f,$f8,$0f,$f0,$03,$c0

; Alien sprites start with a 1-byte header, and are always 16 pixels wide.
;
; #TABLE(default,centre,:w)
; { =h Bytes(n) | =h Meaning }
; { 0 | Height (pixels)  }
; { 1... | Pixel data  }
; TABLE#

; Squidgy Alien sprite #1.
gfx_squidgy_alien1:
  defb $0e                ; Height (pixels)
  defb $12,$40,$1a,$94,$6b,$ea,$5f,$ff ; Pixel data follows
  defb $3f,$fe,$f9,$9f,$36,$6c,$f6,$6e
  defb $79,$9f,$3f,$fe,$4f,$fd,$0f,$f4
  defb $16,$e8,$0a,$44

; Squidgy Alien sprite #2.
gfx_squidgy_alien2:
  defb $0e
  defb $0a,$44,$16,$e8,$0f,$f4,$4d,$fd
  defb $3f,$fe,$79,$9f,$f6,$6e,$36,$6c
  defb $f9,$9f,$3f,$fe,$5f,$ff,$6b,$ea
  defb $1a,$94,$12,$40

; Jet Plane sprite.
gfx_jet_fighter:
  defb $07
  defb $1f,$f0,$c7,$80,$fb,$df,$ff,$ec
  defb $cf,$f0,$1e,$00,$78,$00

; Flying Saucer sprite.
gfx_ufo:
  defb $08
  defb $3f,$fc,$7f,$fe,$d9,$9b,$7f,$fe
  defb $3f,$fc,$0d,$b0,$07,$e0,$01,$80

; Sphere alien sprite #1.
gfx_sphere_alien1:
  defb $10
  defb $07,$e0,$1f,$f8,$3f,$fc,$7f,$fe
  defb $7f,$fe,$ff,$ff,$ff,$ff,$ff,$ff
  defb $e7,$ff,$e7,$ff,$e3,$ff,$71,$fe
  defb $79,$fe,$3f,$fc,$1f,$f8,$07,$e0

; Sphere alien sprite #2.
gfx_sphere_alien2:
  defb $0e
  defb $07,$e0,$1f,$f8,$3f,$fc,$7f,$fe
  defb $7f,$fe,$ff,$ff,$ff,$ff,$e7,$ff
  defb $e7,$ff,$63,$fe,$71,$fe,$39,$fc
  defb $1f,$f8,$07,$e0

; Crossed Space craft sprite.
gfx_cross_ship:
  defb $0f
  defb $03,$80,$05,$c0,$04,$40,$07,$c0
  defb $04,$40,$7b,$bc,$f4,$5e,$b5,$56
  defb $94,$52,$7b,$bc,$04,$40,$07,$c0
  defb $05,$c0,$04,$c0,$03,$80

; Space craft sprite.
gfx_space_craft:
  defb $0e
  defb $10,$00,$1e,$00,$3f,$c0,$61,$f8
  defb $c0,$3f,$ff,$ff,$ca,$c0,$ca,$c0
  defb $ff,$ff,$c0,$3f,$61,$f8,$3f,$c0
  defb $1e,$00,$10,$00

; Frog Alien sprite.
gfx_frog_alien:
  defb $0e
  defb $0c,$30,$13,$c8,$3f,$fc,$7f,$fe
  defb $ff,$ff,$df,$ff,$df,$ff,$48,$9e
  defb $46,$6e,$2f,$f4,$19,$98,$19,$98
  defb $0f,$f0,$06,$60

; Rocket Flame sprite #1.
gfx_rocket_flames1:
  defb $00
  defb $02,$0f
  defb $00,$40,$04,$88,$02,$40,$10,$90
  defb $0b,$58,$24,$62,$53,$b4,$37,$6a
  defb $8a,$5a,$57,$ed,$2e,$f4,$b7,$fd
  defb $5e,$ec,$7f,$f4,$2f,$fc,$00,$00

; Rocket Flame sprite #2.
gfx_rocket_flames2:
  defb $00
  defb $02,$0f
  defb $00,$80,$02,$00,$00,$00,$00,$20
  defb $12,$40,$00,$00,$09,$a4,$12,$c8
  defb $4e,$18,$15,$d2,$2a,$a9,$5b,$d4
  defb $2d,$2e,$12,$f4,$bf,$7a,$1f,$fc

; Unused bytes.
L7F9D:
  defs $16

; Jetpac loading screen image
loading_screen:
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$00,$3f,$ff,$ff,$c0,$0f,$ff,$ff,$f0,$03,$ff,$ff,$fc,$00
  defb $0f,$ff,$ff,$c0,$00,$03,$ff,$ff,$e0,$00,$ff,$ff,$f8,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$fc,$20,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e2,$00,$bf,$ff,$ff,$c4,$23,$ff,$ff,$08,$01,$ff,$ff
  defb $ff,$ff,$00,$07,$7f,$ec,$00,$37,$ff,$ff,$ec,$00,$37,$fe,$c0,$00
  defb $37,$ff,$ff,$fc,$07,$ff,$ff,$ff,$d8,$1b,$ff,$60,$00,$01,$ff,$ff
  defb $ff,$ff,$00,$df,$ff,$e2,$00,$47,$ff,$ff,$00,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$00,$bf,$fe,$18,$ff,$c4,$23,$ff,$ff,$c0,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$84,$00,$47,$ff,$ff,$e4,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$0b,$ff,$e1,$08,$ff,$c4,$10,$ff,$ff,$f2,$01,$ff,$ff
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$00,$df,$ff,$ff,$b0,$37,$ff,$ff,$cc,$0d,$ff,$ff,$ff,$00
  defb $37,$ff,$ff,$e0,$00,$0f,$ff,$ff,$d8,$03,$ff,$ff,$e6,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$fc,$40,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e2,$01,$3f,$ff,$ff,$c4,$23,$ff,$fe,$10,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$ff,$f2,$00,$4f,$ff,$ff,$f2,$00,$4f,$ff,$20,$00
  defb $4f,$ff,$ff,$f2,$1f,$ff,$ff,$ff,$e4,$27,$ff,$90,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$9f,$ff,$e2,$00,$47,$ff,$fe,$80,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$01,$3f,$fe,$28,$ff,$c4,$23,$ff,$ff,$20,$01,$ff,$ff
  defb $ff,$ff,$01,$20,$00,$04,$00,$48,$00,$00,$14,$00,$48,$01,$20,$00
  defb $48,$01,$20,$16,$00,$32,$09,$00,$24,$10,$00,$00,$0a,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$ff,$c2,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$f0,$00,$17,$ff,$ff,$c4,$07,$ff,$ff,$e1,$01,$ff,$ff
  defb $ff,$ff,$01,$20,$ff,$f0,$48,$47,$fe,$03,$40,$12,$0f,$ff,$04,$80
  defb $47,$fe,$1f,$e2,$01,$7f,$f8,$ff,$c4,$23,$ff,$81,$10,$01,$ff,$ff
  defb $ff,$ff,$00,$07,$00,$0e,$00,$70,$00,$00,$0c,$00,$70,$00,$e0,$00
  defb $70,$00,$00,$0e,$1c,$00,$00,$00,$5c,$38,$00,$70,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$e2,$00,$47,$ff,$fe,$40,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$01,$7f,$fc,$28,$ff,$c4,$23,$ff,$ff,$90,$01,$ff,$ff
  defb $ff,$ff,$01,$c0,$00,$18,$00,$70,$00,$00,$0e,$00,$70,$00,$e0,$00
  defb $70,$00,$e0,$1c,$00,$1e,$0e,$00,$1c,$0c,$00,$00,$07,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$ff,$84,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e8,$00,$27,$ff,$ff,$c4,$0b,$ff,$ff,$c2,$01,$ff,$ff
  defb $ff,$ff,$01,$c3,$7f,$ec,$38,$47,$fe,$00,$80,$1c,$37,$fe,$c3,$80
  defb $47,$fe,$1f,$e2,$02,$7f,$f0,$ff,$c4,$23,$ff,$60,$e0,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$ff,$f2,$00,$4f,$ff,$ff,$f2,$00,$4f,$ff,$20,$00
  defb $4f,$ff,$ff,$f2,$27,$ff,$ff,$ff,$e4,$27,$ff,$90,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$e2,$00,$47,$ff,$ff,$60,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$02,$7f,$fc,$48,$ff,$c4,$23,$ff,$ff,$90,$01,$ff,$ff
  defb $ff,$ff,$01,$ff,$ff,$e0,$00,$7f,$ff,$ff,$fe,$00,$7f,$ff,$e0,$00
  defb $7f,$ff,$e0,$3f,$ff,$fc,$0f,$ff,$fc,$03,$ff,$ff,$ff,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$ff,$04,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e4,$00,$2f,$ff,$ff,$c4,$13,$ff,$ff,$c2,$01,$ff,$ff
  defb $ff,$ff,$01,$fc,$7f,$e3,$f8,$47,$ff,$ff,$f0,$1f,$c7,$fe,$3f,$80
  defb $47,$ff,$ff,$e2,$02,$ff,$ff,$ff,$c4,$23,$ff,$1f,$e0,$01,$ff,$ff
  defb $ff,$ff,$00,$07,$7f,$ec,$00,$37,$ff,$ff,$ec,$00,$37,$fe,$c0,$00
  defb $37,$ff,$ff,$8c,$3f,$ff,$ff,$ff,$dc,$1b,$ff,$60,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$e2,$00,$47,$ff,$ff,$20,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$02,$ff,$f8,$48,$ff,$c4,$23,$ff,$ff,$c8,$01,$ff,$ff
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$ff,$08,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e4,$00,$4f,$ff,$ff,$c4,$13,$ff,$ff,$84,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$7f,$e2,$00,$4f,$ff,$ff,$fc,$00,$0f,$ff,$20,$00
  defb $4f,$ff,$ff,$f2,$05,$ff,$ff,$ff,$e4,$27,$ff,$90,$00,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$7f,$e2,$00,$47,$fe,$00,$12,$00,$47,$fe,$20,$00
  defb $47,$ff,$00,$04,$4f,$ff,$81,$ff,$c4,$23,$ff,$10,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$e2,$00,$47,$ff,$ff,$90,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$04,$ff,$f8,$88,$ff,$c4,$23,$ff,$ff,$c8,$01,$ff,$ff
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$fe,$10,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e2,$00,$5f,$ff,$ff,$c4,$23,$ff,$ff,$84,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$00,$02,$00,$70,$00,$00,$0e,$00,$30,$00,$e0,$00
  defb $70,$00,$00,$0e,$06,$00,$00,$00,$1c,$38,$00,$70,$00,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$7f,$e2,$00,$47,$fe,$00,$0e,$00,$47,$fe,$20,$00
  defb $47,$fe,$c0,$18,$5f,$ff,$67,$ff,$c4,$23,$ff,$10,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$e2,$00,$47,$ff,$ff,$d0,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$05,$ff,$f0,$88,$ff,$c4,$23,$ff,$ff,$e4,$01,$ff,$ff
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$ff,$88,$47,$ff,$fc,$10,$11,$ff,$ff,$fc,$80
  defb $47,$ff,$ff,$e2,$00,$9f,$ff,$ff,$c4,$23,$ff,$ff,$08,$01,$ff,$ff
  defb $ff,$ff,$00,$04,$ff,$f2,$00,$4f,$ff,$ff,$f2,$00,$4f,$ff,$20,$00
  defb $4f,$ff,$ff,$f2,$09,$ff,$ff,$ff,$e4,$27,$ff,$90,$00,$01,$ff,$ff
  defb $ff,$ff,$00,$3f,$ff,$e2,$00,$47,$ff,$ff,$fe,$00,$47,$fe,$20,$00
  defb $47,$fe,$3f,$e0,$9f,$ff,$18,$ff,$c4,$23,$ff,$ff,$00,$01,$ff,$ff
  defb $ff,$ff,$01,$1f,$ff,$c2,$00,$47,$ff,$ff,$c8,$00,$47,$fe,$20,$00
  defb $47,$fe,$20,$09,$ff,$f1,$08,$ff,$c4,$21,$ff,$ff,$f4,$01,$ff,$ff
  defb $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3c,$00
  defb $f0,$00,$00,$08,$9f,$00,$00,$04,$e8,$00,$c2,$00,$00,$00,$00,$00
  defb $00,$40,$00,$00,$17,$37,$df,$81,$0e,$00,$00,$7e,$00,$00,$00,$00
  defb $33,$00,$13,$c1,$9f,$70,$3c,$00,$00,$00,$c1,$c0,$00,$00,$00,$00
  defb $00,$00,$00,$00,$fd,$51,$b2,$de,$bb,$d0,$00,$07,$0e,$0b,$f0,$00
  defb $0c,$78,$04,$04,$18,$20,$e0,$6c,$00,$30,$48,$78,$00,$01,$30,$00
  defb $00,$57,$03,$e0,$0f,$1f,$ff,$bc,$f7,$f7,$70,$01,$ff,$07,$0b,$8c
  defb $01,$00,$61,$e4,$07,$81,$83,$c0,$00,$60,$07,$03,$fe,$9a,$28,$ee
  defb $00,$37,$c7,$ff,$c0,$78,$30,$88,$e3,$bf,$77,$80,$00,$3f,$c0,$f3
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $f6,$93,$fe,$90,$90,$02,$01,$ea,$26,$77,$ee,$3e,$80,$07,$cc,$fc
  defb $03,$e0,$ce,$0c,$00,$80,$c0,$00,$8c,$00,$7c,$40,$e0,$7c,$10,$03
  defb $f8,$07,$fc,$0f,$f0,$07,$fc,$ff,$e3,$80,$31,$ea,$00,$00,$02,$31
  defb $03,$03,$c0,$3e,$00,$70,$61,$e0,$7e,$06,$00,$06,$00,$1c,$0f,$f2
  defb $0b,$98,$01,$c7,$e7,$18,$03,$f0,$78,$9f,$11,$7a,$5e,$a0,$00,$03
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$42,$00
  defb $f0,$00,$00,$09,$bb,$00,$00,$00,$40,$00,$40,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$26,$0b,$bf,$86,$f1,$00,$01,$fe,$00,$00,$00,$00
  defb $33,$80,$23,$c8,$8f,$e0,$3e,$00,$00,$03,$f2,$c0,$00,$00,$00,$00
  defb $00,$00,$00,$00,$9c,$89,$bd,$5e,$bb,$e8,$00,$03,$8c,$18,$78,$60
  defb $02,$38,$04,$08,$18,$10,$f0,$6e,$00,$50,$98,$78,$00,$02,$1c,$00
  defb $00,$cf,$87,$80,$3b,$ff,$c0,$79,$eb,$f7,$b8,$00,$6b,$83,$85,$8e
  defb $01,$00,$c3,$76,$0f,$c0,$80,$60,$01,$c0,$03,$80,$7f,$b6,$51,$c7
  defb $03,$ff,$c4,$9f,$ff,$fa,$08,$88,$c9,$bf,$7b,$40,$00,$1f,$e0,$7b
  defb $00,$07,$07,$b4,$00,$1c,$00,$63,$8c,$06,$00,$70,$01,$c1,$e3,$80
  defb $27,$bf,$ff,$61,$00,$02,$03,$d9,$23,$ef,$ec,$3e,$80,$06,$e6,$bc
  defb $07,$82,$fe,$0c,$00,$40,$e0,$00,$c3,$00,$1e,$20,$70,$3f,$0c,$01
  defb $fc,$02,$ab,$ff,$ff,$f8,$01,$ff,$82,$00,$cd,$f2,$00,$00,$00,$38
  defb $02,$03,$c0,$3f,$00,$78,$20,$f0,$7f,$01,$80,$0f,$80,$06,$1c,$7d
  defb $85,$f0,$02,$38,$18,$06,$1c,$00,$f8,$df,$39,$74,$3f,$84,$00,$01
  defb $00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$99,$00
  defb $d8,$00,$00,$11,$ad,$80,$00,$00,$10,$00,$28,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$4e,$06,$ef,$89,$ef,$00,$01,$ef,$80,$00,$00,$00
  defb $63,$c0,$5b,$88,$47,$70,$3f,$00,$00,$02,$74,$e0,$00,$00,$00,$00
  defb $02,$00,$00,$00,$9d,$06,$b3,$d9,$fb,$ec,$00,$03,$f0,$18,$7d,$e0
  defb $02,$30,$08,$10,$38,$11,$38,$67,$38,$f0,$9c,$7c,$00,$02,$43,$00
  defb $00,$e8,$9f,$7f,$fd,$3d,$3f,$cd,$db,$fb,$b8,$00,$35,$e1,$c3,$e7
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $fc,$be,$04,$4f,$ff,$e9,$80,$1f,$78,$df,$b8,$20,$00,$07,$f0,$3d
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ad,$86,$49,$98,$00,$04,$0d,$dd,$13,$df,$92,$1e,$80,$0f,$f3,$5e
  defb $0e,$07,$8c,$0e,$00,$40,$f0,$00,$e1,$00,$1f,$10,$70,$3f,$c2,$00
  defb $7e,$01,$b5,$ff,$ff,$ff,$ff,$ff,$19,$03,$3d,$e4,$70,$00,$00,$1c
  defb $02,$0e,$00,$3f,$00,$3c,$20,$70,$0e,$00,$f0,$ef,$f8,$03,$8c,$0f
  defb $c2,$f0,$03,$e9,$e0,$01,$7c,$01,$f8,$c3,$ff,$6a,$7e,$d0,$c0,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$1f,$fc,$00,$00,$44,$00,$00,$00,$10,$a1,$00
  defb $b8,$00,$01,$11,$ad,$c0,$10,$02,$40,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$4e,$03,$37,$36,$1e,$80,$03,$e5,$c0,$00,$00,$00
  defb $61,$c0,$99,$88,$41,$e0,$c7,$80,$00,$02,$38,$e0,$00,$00,$00,$00
  defb $01,$00,$00,$00,$fe,$00,$ed,$47,$f7,$ef,$00,$01,$f8,$2c,$37,$b8
  defb $04,$20,$08,$18,$3c,$01,$1c,$3b,$ff,$41,$2c,$76,$00,$05,$23,$c0
  defb $00,$57,$a1,$ff,$fd,$c2,$ff,$f3,$dd,$fb,$dc,$00,$3b,$f8,$c1,$b7
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $f5,$5b,$70,$4f,$89,$c4,$c0,$11,$3c,$ef,$bc,$20,$00,$00,$f8,$0f
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $d4,$d6,$49,$c7,$ff,$f8,$33,$dc,$97,$be,$73,$1e,$80,$1e,$f3,$8e
  defb $1c,$0e,$18,$1e,$00,$c0,$f8,$01,$f1,$80,$7e,$08,$38,$33,$e2,$80
  defb $3f,$00,$ea,$ff,$ff,$ff,$ff,$ff,$81,$0c,$fd,$ec,$24,$00,$00,$0e
  defb $04,$3c,$00,$ef,$80,$3e,$20,$70,$07,$00,$78,$01,$fe,$00,$e0,$0f
  defb $f0,$f0,$00,$16,$30,$00,$be,$03,$f8,$e3,$39,$76,$c3,$04,$08,$00
  defb $00,$00,$00,$00,$c0,$00,$00,$00,$00,$00,$38,$00,$00,$00,$00,$18
  defb $00,$00,$00,$00,$03,$ff,$fc,$03,$00,$06,$00,$08,$40,$38,$a1,$00
  defb $cc,$00,$03,$a1,$bd,$c3,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$9c,$03,$77,$db,$df,$40,$07,$ec,$70,$06,$00,$00
  defb $61,$e0,$a5,$10,$21,$f1,$1b,$c0,$00,$04,$30,$d0,$00,$00,$00,$00
  defb $10,$00,$00,$01,$cc,$40,$ee,$7a,$bf,$ef,$00,$01,$f8,$2c,$36,$1c
  defb $08,$20,$10,$0c,$3c,$02,$1e,$3d,$ef,$81,$0c,$7b,$00,$0a,$12,$c0
  defb $00,$be,$7f,$ff,$d9,$fe,$ff,$fb,$bd,$fd,$de,$00,$2f,$f8,$20,$f9
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ed,$2f,$c0,$4f,$b4,$60,$60,$3c,$9c,$6f,$bc,$70,$00,$00,$fe,$87
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ee,$49,$e0,$00,$f7,$c3,$bc,$8c,$79,$92,$8e,$80,$1e,$39,$c7
  defb $18,$1c,$f0,$1e,$00,$60,$f8,$03,$f8,$c0,$f8,$0c,$1c,$21,$f0,$c0
  defb $3f,$06,$7f,$ff,$ff,$ff,$ff,$ff,$01,$b3,$fe,$f0,$12,$40,$00,$0f
  defb $00,$38,$00,$7f,$80,$3d,$10,$30,$03,$c0,$78,$00,$0f,$80,$1f,$80
  defb $00,$38,$01,$e4,$08,$7c,$9f,$0f,$f4,$a3,$11,$f9,$1a,$b0,$90,$00
  defb $80,$00,$00,$01,$70,$00,$00,$02,$10,$00,$74,$00,$00,$00,$00,$18
  defb $00,$00,$00,$00,$06,$ff,$f6,$fc,$c0,$00,$00,$18,$00,$10,$99,$00
  defb $ce,$00,$05,$a1,$8c,$c4,$60,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$9c,$03,$79,$e4,$0f,$c0,$3f,$c2,$38,$1b,$80,$00
  defb $30,$f1,$05,$10,$20,$f1,$07,$e0,$00,$04,$30,$d0,$00,$00,$40,$00
  defb $00,$00,$00,$1f,$ce,$a9,$f7,$ad,$bf,$ef,$c0,$01,$f8,$4c,$12,$1e
  defb $04,$40,$10,$0c,$3c,$00,$0f,$06,$78,$12,$4c,$79,$80,$14,$11,$30
  defb $00,$bb,$77,$1c,$c8,$fb,$f8,$17,$be,$fd,$ee,$00,$7f,$f7,$10,$dc
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $b0,$17,$f0,$0f,$92,$32,$a0,$44,$9e,$77,$dc,$78,$00,$01,$ff,$47
  defb $00,$1c,$07,$08,$00,$01,$00,$30,$70,$00,$80,$70,$00,$e2,$40,$78
  defb $00,$33,$ff,$ff,$ff,$f8,$07,$7e,$4d,$e6,$14,$ed,$00,$3c,$1c,$c7
  defb $30,$18,$e0,$1e,$00,$70,$ec,$03,$fc,$61,$f0,$04,$07,$01,$f0,$20
  defb $0b,$0f,$00,$1f,$ff,$ff,$ff,$ff,$20,$cc,$fe,$f0,$79,$00,$00,$07
  defb $00,$30,$00,$ff,$c0,$7d,$80,$c0,$03,$20,$7c,$00,$03,$e0,$1c,$70
  defb $00,$0c,$01,$df,$e7,$ff,$5f,$7f,$e4,$b7,$93,$df,$5b,$d4,$60,$00
  defb $c0,$00,$00,$02,$38,$00,$00,$00,$40,$00,$c0,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$0f,$3f,$ee,$30,$30,$20,$00,$3c,$08,$00,$42,$00
  defb $e6,$00,$09,$e1,$9e,$c8,$70,$00,$40,$00,$00,$80,$00,$00,$00,$00
  defb $00,$00,$00,$00,$9c,$02,$fe,$de,$77,$a0,$46,$42,$3c,$13,$80,$08
  defb $10,$fa,$02,$08,$10,$f0,$81,$f0,$00,$08,$20,$70,$00,$00,$e0,$00
  defb $00,$1c,$00,$7e,$27,$17,$8b,$4d,$bf,$ee,$e0,$01,$fc,$24,$12,$1b
  defb $02,$40,$20,$7c,$3e,$04,$0f,$03,$e0,$30,$8e,$7f,$e0,$65,$12,$7c
  defb $00,$5c,$76,$0c,$24,$0f,$86,$17,$77,$7e,$ef,$00,$fd,$fe,$01,$dc
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $fa,$48,$3c,$0d,$92,$30,$28,$76,$4f,$17,$dc,$fe,$00,$01,$ff,$f0
  defb $00,$38,$0d,$0c,$01,$00,$80,$0c,$38,$00,$d0,$80,$00,$72,$20,$1e
  defb $00,$10,$03,$ff,$ff,$ff,$f7,$7e,$7d,$98,$0d,$65,$00,$e0,$0c,$e3
  defb $20,$38,$e8,$1e,$00,$70,$67,$01,$f8,$39,$80,$04,$03,$81,$df,$18
  defb $0b,$0d,$00,$40,$0f,$ff,$ff,$fc,$30,$b0,$fe,$f0,$5d,$08,$00,$07
  defb $00,$30,$01,$f3,$c0,$7e,$10,$18,$01,$10,$7c,$00,$00,$e0,$03,$08
  defb $00,$04,$01,$a0,$77,$ff,$ff,$ff,$e3,$3d,$ff,$6f,$1f,$62,$74,$00
  defb $e0,$00,$00,$04,$9e,$00,$00,$00,$40,$00,$c0,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$1f,$cf,$ef,$40,$0c,$00,$00,$7c,$00,$00,$3c,$08
  defb $77,$00,$13,$c1,$97,$70,$70,$00,$00,$00,$01,$80,$00,$00,$00,$00
  defb $00,$00,$00,$00,$9e,$23,$3e,$de,$8b,$d0,$80,$86,$0d,$cb,$60,$00
  defb $10,$7c,$02,$04,$18,$70,$80,$f8,$00,$10,$40,$78,$00,$01,$60,$00
  defb $00,$3f,$00,$f8,$16,$f7,$fe,$d6,$7f,$ef,$e0,$01,$fe,$1e,$09,$1d
  defb $00,$80,$20,$f4,$0f,$83,$03,$80,$c0,$61,$86,$3f,$f8,$9a,$2a,$ee
  defb $00,$bf,$88,$02,$24,$3f,$c1,$0f,$e3,$7e,$f7,$80,$80,$ff,$c0,$e6
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ed,$24,$03,$09,$92,$10,$20,$ea,$47,$2b,$dd,$7d,$00,$00,$dd,$f8
  defb $00,$70,$0e,$0c,$01,$00,$80,$07,$1c,$00,$78,$03,$e0,$3c,$30,$0f
  defb $c8,$0c,$00,$00,$0f,$ff,$fa,$fe,$22,$60,$0b,$c5,$00,$80,$06,$75
  defb $01,$f0,$60,$1e,$00,$f0,$63,$c0,$7c,$0f,$00,$06,$00,$61,$8f,$cc
  defb $1b,$1c,$00,$3f,$10,$e7,$ff,$f8,$38,$c1,$92,$f8,$aa,$01,$00,$03
  defb $00,$20,$10,$f3,$c0,$fc,$08,$1c,$01,$08,$fc,$00,$00,$60,$00,$07
  defb $00,$03,$00,$a3,$9b,$ff,$ff,$fe,$c5,$18,$fc,$3f,$a7,$f8,$96,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$ff,$ed,$ff,$ff,$fc,$c5,$10,$f0,$80,$1e,$ea,$21,$00
  defb $1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$38,$00,$5f,$0e,$7e,$00,$00,$00,$01,$01,$af,$fe,$fe,$14,$a0
  defb $38,$fc,$3f,$3f,$00,$3f,$01,$f9,$ff,$cf,$fe,$7c,$7c,$03,$f0,$1f
  defb $80,$1c,$00,$03,$1c,$ff,$dc,$00,$00,$00,$04,$88,$00,$06,$3d,$aa
  defb $38,$b4,$2f,$27,$00,$25,$01,$49,$29,$7a,$52,$4b,$df,$42,$70,$16
  defb $80,$1c,$3c,$00,$01,$f7,$ff,$75,$80,$00,$00,$00,$0a,$ae,$ff,$f7
  defb $38,$ff,$9e,$03,$fc,$f3,$c3,$ff,$79,$ef,$f8,$3f,$e7,$f9,$f0,$fd
  defb $ff,$1c,$00,$01,$be,$0f,$f3,$00,$00,$00,$00,$00,$00,$02,$6a,$d9
  defb $38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$01,$00,$f7,$5c,$ff,$9c,$42,$dd,$c2,$23,$66,$d4,$7a,$00
  defb $38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$1c,$00,$20,$39,$fe,$00,$00,$00,$00,$0a,$57,$ff,$ed,$ab,$08
  defb $38,$f4,$3f,$3f,$00,$3f,$01,$f9,$ff,$cf,$fe,$7f,$7c,$03,$f0,$1f
  defb $80,$1c,$00,$00,$f3,$c1,$be,$00,$00,$00,$00,$23,$1a,$9b,$5f,$de
  defb $38,$be,$5f,$2f,$00,$2d,$01,$69,$69,$7a,$7a,$5f,$ff,$c2,$f0,$17
  defb $80,$1c,$42,$00,$07,$fb,$ff,$7b,$80,$00,$00,$00,$21,$71,$ff,$ff
  defb $38,$ff,$de,$07,$fe,$f3,$c3,$ff,$79,$ef,$f8,$7f,$ef,$fd,$f9,$fd
  defb $ff,$1c,$00,$00,$1d,$ef,$ef,$00,$00,$00,$00,$00,$00,$00,$85,$26
  defb $1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$fc,$fc,$fe,$7f,$3f,$80,$e7,$7f,$71
  defb $c0,$7e,$3e,$00,$fe,$fe,$7e,$fc,$fe,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$01,$00,$1f,$8c,$ae,$9a,$8c,$3e,$1d,$dc,$7f,$ea,$3e,$80
  defb $38,$fc,$3f,$3f,$07,$ff,$f9,$f9,$fe,$01,$fe,$7f,$e0,$7f,$ff,$9f
  defb $ff,$1c,$00,$1f,$e7,$fd,$80,$00,$00,$00,$31,$ce,$df,$d6,$17,$64
  defb $38,$f4,$3d,$3d,$00,$3f,$01,$f9,$ff,$ff,$fa,$7e,$fe,$03,$d0,$1e
  defb $ff,$1c,$00,$00,$0c,$01,$67,$00,$00,$00,$02,$0d,$bf,$53,$77,$75
  defb $38,$bf,$ff,$2f,$ff,$2f,$01,$e9,$e8,$bc,$7e,$5e,$0f,$e2,$f0,$17
  defb $ff,$1c,$99,$00,$1f,$fd,$fe,$f6,$00,$00,$00,$00,$45,$af,$df,$ff
  defb $38,$f3,$de,$07,$9e,$f3,$c0,$78,$79,$ef,$00,$78,$0f,$3d,$f9,$fd
  defb $e0,$1c,$00,$00,$00,$df,$9e,$00,$00,$00,$00,$00,$00,$04,$13,$5d
  defb $1e,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$fe,$fe,$fc,$fe,$7f,$00,$ef,$7e,$73
  defb $c0,$7f,$7f,$01,$fc,$fe,$fe,$fe,$fe,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$01,$8f,$ff,$c4,$a1,$9a,$88,$00,$a1,$59,$ff,$bd,$5e,$00
  defb $38,$fc,$3f,$3f,$07,$ff,$f9,$f9,$fe,$01,$fe,$7f,$e0,$7f,$ff,$9f
  defb $ff,$1c,$00,$08,$0f,$fb,$c0,$00,$00,$00,$06,$19,$f4,$fc,$5e,$10
  defb $38,$f4,$3d,$3d,$00,$3d,$01,$f9,$ff,$ff,$fa,$7e,$ba,$03,$d0,$1e
  defb $81,$1c,$00,$00,$04,$02,$c3,$80,$00,$00,$00,$25,$e5,$fd,$be,$f6
  defb $38,$bf,$ff,$2f,$ff,$3f,$01,$f9,$f8,$fc,$7e,$5e,$0f,$e3,$f0,$1f
  defb $ff,$1c,$a1,$00,$ff,$fe,$fe,$ee,$00,$00,$00,$00,$00,$95,$7f,$fb
  defb $38,$ff,$de,$07,$fe,$ff,$c0,$78,$7f,$ef,$e0,$7b,$ef,$fd,$ff,$fd
  defb $fc,$1c,$00,$00,$00,$1f,$70,$00,$00,$00,$00,$00,$00,$00,$21,$2a
  defb $0f,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$f0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$ee,$ee,$e0,$f0,$78,$00,$fe,$70,$3f
  defb $80,$1c,$77,$01,$e0,$38,$ee,$ee,$38,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$80,$00,$7f,$ff,$e9,$c1,$35,$30,$00,$2a,$af,$ff,$f8,$95,$20
  defb $38,$fc,$3f,$3f,$07,$ff,$f9,$f9,$ff,$03,$fe,$7f,$f0,$7f,$ff,$9f
  defb $ff,$1c,$00,$08,$ff,$f7,$e0,$00,$00,$00,$05,$36,$fb,$b5,$06,$a8
  defb $38,$f4,$3d,$3d,$00,$3d,$01,$79,$7b,$ff,$fa,$7a,$5d,$02,$d0,$1e
  defb $fd,$1c,$00,$00,$03,$0d,$86,$80,$00,$00,$00,$0b,$6b,$5a,$5e,$d9
  defb $38,$5f,$fe,$3f,$ff,$3f,$01,$f9,$f8,$78,$7e,$7e,$07,$f3,$f0,$1f
  defb $ff,$1c,$a1,$01,$ff,$fd,$fe,$dc,$00,$00,$00,$00,$0c,$2f,$dd,$fe
  defb $38,$ff,$9e,$07,$fe,$7f,$c0,$78,$7f,$ef,$e0,$7b,$ef,$fd,$ff,$fd
  defb $fc,$1c,$00,$00,$00,$1c,$e0,$00,$00,$00,$00,$00,$00,$00,$04,$28
  defb $07,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$e0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$fe,$fe,$f8,$7e,$3f,$00,$fc,$7c,$1f
  defb $00,$1c,$77,$00,$fc,$39,$fe,$fe,$38,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $07,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$e0,$00,$80,$07,$f0,$43,$24,$c0,$00,$57,$7f,$ff,$f2,$3e,$80
  defb $38,$fc,$3f,$3f,$07,$ff,$f9,$f9,$ff,$03,$fe,$7f,$f0,$7f,$ff,$9f
  defb $ff,$1c,$00,$08,$01,$ef,$e0,$00,$00,$00,$02,$55,$d5,$6c,$7f,$20
  defb $38,$a4,$29,$2d,$00,$2d,$01,$69,$1d,$fe,$1a,$62,$5d,$02,$d0,$14
  defb $ff,$1c,$00,$00,$00,$f3,$0e,$f8,$00,$00,$00,$00,$4d,$aa,$fb,$b2
  defb $38,$3f,$fc,$3f,$ff,$3f,$01,$f9,$f8,$78,$7e,$7e,$07,$f3,$f0,$1f
  defb $ff,$1c,$99,$00,$ff,$fb,$fe,$a0,$00,$00,$00,$00,$01,$5a,$ba,$dd
  defb $38,$f0,$1e,$07,$9e,$03,$c0,$78,$79,$ef,$00,$79,$ef,$3d,$ef,$bd
  defb $e0,$1c,$00,$00,$00,$0b,$e0,$00,$00,$00,$00,$00,$00,$00,$00,$21
  defb $01,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$fc,$f8,$e0,$0f,$07,$80,$fe,$70,$0e
  defb $00,$1c,$77,$00,$1e,$39,$fe,$f8,$38,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $0f,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
  defb $ff,$f0,$00,$80,$ff,$6f,$fc,$07,$00,$00,$15,$7f,$7f,$fd,$44,$10
  defb $38,$fc,$3f,$3f,$00,$3f,$01,$f9,$ff,$87,$fe,$7f,$f8,$03,$f0,$1f
  defb $80,$1c,$00,$04,$00,$df,$e0,$00,$00,$00,$00,$a5,$53,$52,$4d,$d6
  defb $38,$84,$21,$21,$00,$21,$01,$09,$0a,$e1,$42,$42,$20,$82,$10,$10
  defb $80,$1c,$00,$00,$00,$df,$9e,$bc,$00,$00,$00,$00,$b7,$5d,$ff,$ec
  defb $38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$1c,$42,$03,$1f,$fb,$fe,$60,$00,$00,$00,$00,$00,$13,$6f,$7a
  defb $38,$f0,$1f,$f7,$9e,$ff,$c0,$78,$79,$ef,$f8,$7f,$ef,$3d,$e7,$3d
  defb $ff,$1c,$00,$00,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$e0,$ee,$fc,$7f,$3f,$80,$ef,$7e,$0e
  defb $00,$1c,$7f,$00,$fe,$3b,$8e,$ee,$38,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $1e,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$78,$00,$40,$fb,$9e,$03,$f8,$00,$00,$55,$7f,$d7,$78,$3f,$40
  defb $38,$fc,$3f,$3f,$00,$3f,$01,$f9,$ff,$87,$fe,$7f,$f8,$03,$f0,$1f
  defb $80,$1c,$00,$04,$03,$3f,$f0,$00,$00,$00,$00,$01,$48,$48,$57,$39
  defb $38,$84,$21,$21,$00,$21,$01,$09,$0a,$01,$42,$43,$e0,$82,$10,$10
  defb $80,$1c,$00,$00,$00,$ef,$ff,$47,$00,$00,$00,$05,$2a,$fb,$df,$fb
  defb $38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$1c,$3c,$03,$e1,$f7,$fd,$c0,$00,$00,$00,$00,$00,$08,$9c,$fe
  defb $38,$f0,$1f,$f7,$9e,$ff,$80,$78,$79,$ef,$f8,$3f,$ef,$3d,$e7,$3d
  defb $ff,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$e0,$e6,$fe,$fe,$7f,$00,$e7,$7f,$0e
  defb $00,$1c,$3e,$01,$fc,$3b,$8e,$e6,$38,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  defb $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$46,$46,$46
  defb $46,$46,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  defb $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$46,$46,$46
  defb $46,$46,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42
  defb $42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$46,$46,$46
  defb $46,$46,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42
  defb $42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$46,$46,$46
  defb $46,$46,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42
  defb $42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $43,$00,$47,$43,$43,$00,$00,$47,$47,$00,$47,$00,$47,$00,$00,$47
  defb $00,$00,$00,$00,$47,$47,$47,$47,$47,$47,$00,$43,$47,$47,$46,$47
  defb $43,$00,$43,$43,$43,$43,$43,$47,$47,$00,$47,$43,$00,$00,$00,$00
  defb $00,$47,$00,$00,$47,$47,$47,$47,$47,$47,$43,$43,$43,$43,$43,$47
  defb $43,$43,$43,$43,$43,$43,$43,$43,$00,$43,$43,$43,$00,$43,$43,$00
  defb $47,$47,$00,$47,$47,$47,$47,$47,$47,$47,$47,$43,$43,$43,$43,$43
  defb $43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43
  defb $00,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$43,$43,$43,$43
  defb $42,$42,$42,$42,$43,$43,$43,$41,$41,$41,$45,$45,$44,$44,$46,$46
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$00,$43,$43,$43
  defb $42,$42,$42,$42,$43,$43,$43,$41,$41,$41,$45,$45,$44,$44,$46,$46
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$43,$43,$43
  defb $43,$43,$43,$43,$00,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43
  defb $43,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$46,$46,$43,$43
  defb $43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43
  defb $43,$43,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$46,$46,$42,$43
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$46,$46,$46,$46,$42,$42
  defb $47,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  defb $45,$47,$00,$47,$47,$47,$47,$00,$00,$42,$46,$46,$46,$46,$42,$42
  defb $47,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45
  defb $45,$47,$00,$47,$47,$47,$47,$47,$00,$00,$42,$42,$42,$42,$42,$42
  defb $47,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44
  defb $44,$47,$43,$47,$47,$47,$47,$47,$47,$00,$00,$00,$42,$42,$42,$42
  defb $47,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44
  defb $44,$47,$00,$47,$47,$47,$47,$00,$00,$00,$00,$00,$00,$42,$42,$42
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
  defb $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
  defb $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
  defb $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46
  defb $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46

; ZX Spectrum font sprites.
system_font:
  defb $00,$00,$00,$00,$00,$00,$00,$00
  defb $00,$10,$10,$10,$10,$00,$10,$00
  defb $00,$24,$24,$00,$00,$00,$00,$00
  defb $00,$24,$7e,$24,$24,$7e,$24,$00
  defb $00,$08,$3e,$28,$3e,$0a,$3e,$08
  defb $00,$62,$64,$08,$10,$26,$46,$00
  defb $00,$10,$28,$10,$2a,$44,$3a,$00
  defb $00,$08,$10,$00,$00,$00,$00,$00
  defb $00,$04,$08,$08,$08,$08,$04,$00
  defb $00,$20,$10,$10,$10,$10,$20,$00
  defb $00,$00,$14,$08,$3e,$08,$14,$00
  defb $00,$00,$08,$08,$3e,$08,$08,$00
  defb $00,$00,$00,$00,$00,$08,$08,$10
  defb $00,$00,$00,$00,$3e,$00,$00,$00
  defb $00,$00,$00,$00,$00,$18,$18,$00
  defb $00,$00,$02,$04,$08,$10,$20,$00
  defb $00,$3c,$46,$4a,$52,$62,$3c,$00
  defb $00,$18,$28,$08,$08,$08,$3e,$00
  defb $00,$3c,$42,$02,$3c,$40,$7e,$00
  defb $00,$3c,$42,$0c,$02,$42,$3c,$00
  defb $00,$08,$18,$28,$48,$7e,$08,$00
  defb $00,$7e,$40,$7c,$02,$42,$3c,$00
  defb $00,$3c,$40,$7c,$42,$42,$3c,$00
  defb $00,$7e,$02,$04,$08,$10,$10,$00
  defb $00,$3c,$42,$3c,$42,$42,$3c,$00
  defb $00,$3c,$42,$42,$3e,$02,$3c,$00
  defb $00,$00,$00,$10,$00,$00,$10,$00
  defb $00,$00,$10,$00,$00,$10,$10,$20
  defb $00,$00,$04,$08,$10,$08,$04,$00
  defb $00,$00,$00,$3e,$00,$3e,$00,$00
  defb $00,$00,$10,$08,$04,$08,$10,$00
  defb $00,$3c,$42,$04,$08,$00,$08,$00
  defb $00,$3c,$4a,$56,$5e,$40,$3c,$00
  defb $00,$3c,$42,$42,$7e,$42,$42,$00
  defb $00,$7c,$42,$7c,$42,$42,$7c,$00
  defb $00,$3c,$42,$40,$40,$42,$3c,$00
  defb $00,$78,$44,$42,$42,$44,$78,$00
  defb $00,$7e,$40,$7c,$40,$40,$7e,$00
  defb $00,$7e,$40,$7c,$40,$40,$40,$00
  defb $00,$3c,$42,$40,$4e,$42,$3c,$00
  defb $00,$42,$42,$7e,$42,$42,$42,$00
  defb $00,$3e,$08,$08,$08,$08,$3e,$00
  defb $00,$02,$02,$02,$42,$42,$3c,$00
  defb $00,$44,$48,$70,$48,$44,$42,$00
  defb $00,$40,$40,$40,$40,$40,$7e,$00
  defb $00,$42,$66,$5a,$42,$42,$42,$00
  defb $00,$42,$62,$52,$4a,$46,$42,$00
  defb $00,$3c,$42,$42,$42,$42,$3c,$00
  defb $00,$7c,$42,$42,$7c,$40,$40,$00
  defb $00,$3c,$42,$42,$52,$4a,$3c,$00
  defb $00,$7c,$42,$42,$7c,$44,$42,$00
  defb $00,$3c,$40,$3c,$02,$42,$3c,$00
  defb $00,$fe,$10,$10,$10,$10,$10,$00
  defb $00,$42,$42,$42,$42,$42,$3c,$00
  defb $00,$42,$42,$42,$42,$24,$18,$00
  defb $00,$42,$42,$42,$42,$5a,$24,$00
  defb $00,$42,$24,$18,$18,$24,$42,$00
  defb $00,$82,$44,$28,$10,$10,$10,$00
  defb $00,$7e,$04,$08,$10,$20,$7e,$00
  defb $3c,$42,$99,$a1,$a1,$99,$42,$3c
