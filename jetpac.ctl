> $5CCB ; SkoolKit disassembly for JETPAC (cartridge)
> $5CCB ; (https://github.com/mrcook/jetpac-disassembly)
> $5CCB ;
> $5CCB ; Copyright (c) 2020 Michael R. Cook (this disassembly)
> $5CCB ; Copyright (c) 1983 Ultimate Play the Game (JETPAC)
> $5CCB ; JETPAC was designed and developed by Tim Stamper and Chris Stamper
> $5CCB @start=$6000
> $5CCB
> $5CCB ; Frame counter.
> $5CCB ;
> $5CCB ; These lower two bytes of frame counter are incremented every 20 ms.
> $5CCB @equ=SYSVAR_FRAMES=$5c78
@ $5CCB org
s $5CCB Stack: 37 bytes of memory allocated for use as the system stack.
@ $5CCB label=stack_memory
S $5CCB,37,$25
b $5CF0 High score for current game session.
D $5CF0 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF0 label=hi_score
S $5CF0,3,$03
b $5CF3 Game options.
D $5CF3 #TABLE(default,centre,:w) { =h Bits(n) | =h Option } { 0 | Players (reset=1, set=2) } { 1 | Input Type (reset=Keyboard, set=Joystick) } TABLE#
@ $5CF3 label=game_options
B $5CF3,1,1
b $5CF4 Player one score.
D $5CF4 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF4 label=p1_score
S $5CF4,3,$03
b $5CF7 Player two score.
D $5CF7 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF7 label=p2_score
S $5CF7,3,$03
s $5CFA Padding to make block from hi_score to here 16 bytes in length.
S $5CFA,6,$06
b $5D00 Jetman direction.
D $5D00 Indicates the direction that Jetman is travelling/facing. #TABLE(default,centre,:w) { =h Byte | =h Bits | =h Direction } { 82 | 10000010 | WALK RIGHT } { C2 | 11000010 | WALK LEFT } { 01 | 00000001 | FLY UP RIGHT (default) } { 41 | 01000001 | FLY UP LEFT } { 81 | 10000001 | FLY DOWN RIGHT } { C1 | 11000001 | FLY DOWN LEFT } TABLE#
@ $5D00 label=jetman_direction
B $5D00,1,1
b $5D01 Jetman X position.
D $5D01 Default start position is $80.
@ $5D01 label=jetman_pos_x
B $5D01,1,1
b $5D02 Jetman Y position.
D $5D02 Default start position is $B7.
@ $5D02 label=jetman_pos_y
B $5D02,1,1
b $5D03 Jetman sprite colour attribute.
D $5D03 Initialised to $47 on new player.
@ $5D03 label=jetman_colour
B $5D03,1,1
b $5D04 Jetman moving direction.
D $5D04 Indicates the direction in which Jetman is moving. #TABLE(default,centre,:w) { =h Bits(n) | =h Direction } { 6 | 0=right, 1=left } { 7 | 0=up/standing still, 1=down } { 1 | ? } { 0 | 0=horizontal, 1=vertical } TABLE#
@ $5D04 label=jetman_moving
B $5D04,1,1
b $5D05 Jetman Speed: Horizontal.
D $5D05 Max Walking: $20. Max Flying: $40.
@ $5D05 label=jetman_speed_x
B $5D05,1,1
b $5D06 Jetman Speed: Vertical.
D $5D06 Max: $3F.
@ $5D06 label=jetman_speed_y
B $5D06,1,1
b $5D07 Jetman sprite height, which is always $24, as set by the defaults.
@ $5D07 label=jetman_height
B $5D07,1,1
b $5D08 Laser beams
D $5D08 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Unused=$00, Used=$10 } { 1 | Y Position } { 2 | X position pulse #1 } { 3 | X position pulse #2 } { 4 | X position pulse #3 } { 5 | X position pulse #4 } { 6 | Beam length } { 7 | Colour attribute } TABLE#
@ $5D08 label=laser_beam_params
B $5D08,8,8 laser beam #1
B $5D10,8,8 laser beam #2
B $5D18,8,8 laser beam #3
B $5D20,8,8 laser beam #4
b $5D28 Sound type parameters for explosions.
D $5D28 Byte 1=Frequency, byte 2=Duration.
@ $5D28 label=explosion_sfx_params
B $5D28,1,1 Frequency is $0C or $0D
B $5D29,1,1 Length is always set to $04
b $5D2A Explosion params padding, making 8 bytes total. Unused.
S $5D2A,6,$06
b $5D30 Rocket object attributes.
D $5D30 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Movement: $09=on pad, $0A=up, $0B=down } { 1 | X Position (pixels) } { 2 | Y Position (pixels) (base module) } { 3 | Colour Attribute } { 4 | Modules on Pad: $01 (new level default) to $03 } { 5 | Fuel Pods collected: 0-6 } { 6 | Unused } { 7 | Always $1C } TABLE#
@ $5D30 label=rocket_state
B $5D30,8,8
b $5D38 Rocket module state (fuel/part).
D $5D38 NOTE: Used for top module at level start, then only fuel pods. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Type: $00=Unused, $04=Ship/Fuel Pod } { 1 | X Position (pixels) } { 2 | Y Position (pixels) } { 3 | Colour Attribute } { 4 | State: 1=new, 3=collected, 5=free-fall, 7=dropped } { 5 | Unused } { 6 | Sprite jump table offset } { 7 | Sprite Height } TABLE#
@ $5D38 label=rocket_module_state
B $5D38,8,8
b $5D40 Current Collectible object.
D $5D40 Used for the middle ship module at level start, then only collectibles. The "state" field is not used for collectibles (remains $00). #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Type: $00=Unused, $04=Rocket, $0E=Collectible } { 1 | X Position (pixels) } { 2 | Y Position (pixels) } { 3 | Colour Attribute } { 4 | State: 1=new, 3=collected, 5=free-fall, 7=dropped } { 5 | Unused } { 6 | Sprite jump table offset } { 7 | Sprite Height } TABLE#
@ $5D40 label=item_state
B $5D40,8,8
b $5D48 Thruster/Explosion animation sprite state.
D $5D48 Holds the sprite state for the current animation frame being displayed for Jetman's jetpac thruster "smoke". Note: each animation loop uses a (random) two colour pair from the 4 possible colours. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Animating: 00=no, 03=anim done, 08=animating } { 1 | Last Jetman X location } { 2 | Last Jetman Y location } { 3 | Colour: Red, Magenta, Yellow, White } { 4 | Frame: 0-7 } { 5 | Unused } { 6 | Unknown (set to $03 on first use) } { 7 | Unused } TABLE#
@ $5D48 label=jetman_thruster_anim_state
B $5D48,8,8
b $5D50 Alien state objects.
D $5D50 There are a maximum of 6 aliens on the screen at one time, and those states are stored here in this data block. See Jetman object for more details. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 00 | Direction } { 01 | X location (pixels) } { 02 | Y location (pixels) } { 03 | Colour attribute } { 04 | Moving direction } { 05 | X Speed (default: $04) } { 06 | Y Speed } { 07 | Sprite Height } TABLE#
@ $5D50 label=alien_states
B $5D50,8,8 slot #1
B $5D58,8,8 slot #2
B $5D60,8,8 slot #3
B $5D68,8,8 slot #4
B $5D70,8,8 slot #5
B $5D78,8,8 slot #6
b $5D80 Jetman exploding animation object.
D $5D80 Holds the sprite state for the current animation frame being displayed for the explosion sprite when Jetman is killed. Note: each animation loop uses a (random) two colour pair from the 4 possible colours. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Animating: 00=no, 08=yes } { 1 | Jetman X location (pixels) } { 2 | Jetman Y location (pixels) } { 3 | Colour: Red, Magenta, Yellow, White } { 4 | Frame: 0-7 } { 5 | State (set=animating) } { 6 | Jetman direction } { 7 | Unused } TABLE#
@ $5D80 label=jetman_exploding_anim_state
B $5D80,8,8
b $5D88 Jetman object backup for the inactive player.
@ $5D88 label=inactive_jetman_state
B $5D88,8,8
@ $5D90 defs=$5D90:$08,$00
s $5D90 Unused padding.
S $5D90,8,$08
b $5D98 Rocket/collectible object backup for the inactive player.
@ $5D98 label=inactive_rocket_state
B $5D98,8,8 Rocket object
B $5DA0,8,8 Rocket module (fuel/part)
B $5DA8,8,8 Collectible/Rocket middle
@ $5DB0 defs=$5DB0:$06,$00
s $5DB0 Unused padding.
S $5DB0,8,$08
@ $5DB8 defs=$5DB8:$06,$00
s $5DB8 Unused padding.
S $5DB8,8,$08
b $5DC0 Temporary actor state.
D $5DC0 Many actor routines use this to hold state temporarily during updates. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | X location } { 1 | Y location } { 2 | Movement direction } { 3 | Height (pixels) } { 4 | Width (tiles) } { 5 | Current sprite height value (?) } { 6 | Sprite GFX data height value (?) } { 7 | Unknown flying movement/direction (used only for Jetman?) } TABLE#
@ $5DC0 label=actor
B $5DC0,8,8
b $5DC8 Value only changes while Jetman is moving up/down - has no obvious pattern.
@ $5DC8 label=jetman_fly_counter
B $5DC8,1,1
b $5DC9 Alien direction update flag for: Squidgy, UFO, Sphere, Crossed Ship.
D $5DC9 Each alien update routine first resets the value, then after the first check, increments the value, which triggers the draw alien routine.
@ $5DC9 label=alien_new_dir_flag
B $5DC9,1,1
b $5DCA Jetman speed modifier.
D $5DCA Initialised to $04 by initialise game routine, otherwise value is $00 during game play.
@ $5DCA label=jetman_speed_modifier
B $5DCA,1,1
b $5DCB Current alien ID being updated?
D $5DCB Values are $00 (no alien update?) up to the max number of aliens: $01 to $06. Used by all alien update routines and in a few other places.
@ $5DCB label=current_alien_number
B $5DCB,1,1
w $5DCC Game timer.
D $5DCC 16-bit counter starting at 0x0000 and counting +1 (each time a sprite is moved or redrawn?), although sometimes it will increment +2. This continues until the whole game is over - for both 1 and 2 player games. Counter loops around after reaching 0xFFFF.
@ $5DCC label=game_timer
W $5DCC,2,2
b $5DCE Random Number.
D $5DCE Value is calculated using the 16-bit game timer LSB value, which is used to fetch a byte from the ROM (between addresses $00 and $FF), then by adding the current #REGr.
@ $5DCE label=random_number
B $5DCE,1,1
b $5DCF Temporary actor coordinates.
D $5DCF Coordinates (Y,X) used when colouring a sprite. Set by the Actor, along with being inc/decremented during the Rocket launch/land phase.
@ $5DCF label=actor_coords
B $5DCF,1,1 Y location (pixels)
B $5DD0,1,1 X location (pixels)
b $5DD1 Current active player.
D $5DD1 $00=player #1, $FF=player #2.
@ $5DD1 label=current_player_number
B $5DD1,1,1
b $5DD2 Jetman Rocket module attached success.
D $5DD2 Set to $01 at the start of each new life/level. When one of the two modules becomes attached to the Rocket (top or middle, but not fuel) then this is changed to $00.
@ $5DD2 label=jetman_rocket_mod_connected
B $5DD2,1,1
b $5DD3 Rocket modules attached.
D $5DD3 Set to $04 at the start of each new level. When one of the two modules becomes attached to the Rocket (top or middle, but not fuel) then this is changed to $02.
@ $5DD3 label=rocket_mod_attached
B $5DD3,1,1
b $5DD4 Holds a copy of the last SYSVAR_FRAMES counter.
@ $5DD4 label=last_frame
B $5DD4,1,1
b $5DD5 Has a frame ticked over.
D $5DD5 $00=no, $01=yes.
@ $5DD5 label=frame_ticked
B $5DD5,1,1
b $5DD6 Current menu item colour attribute.
@ $5DD6 label=current_colour_attr
B $5DD6,1,1
b $5DD7 "Get Ready" delay timer.
D $5DD7 At the beginning of each player turn there is a delay to allow the player to be ready for play. Values are $80 for a 1 player game, $FF for a two player game. The larger delay is useful for swapping players controls.
@ $5DD7 label=begin_play_delay_counter
B $5DD7,1,1
@ $5DD8 defs=$5DD8:$06,$00
s $5DD8 Unused padding.
S $5DD8,24,$18
b $5DF0 Game level for current player.
D $5DF0 Level #1 starts at $00.
@ $5DF0 label=player_level
B $5DF0,1,1
b $5DF1 Current player lives remaining.
@ $5DF1 label=player_lives
B $5DF1,1,1
@ $5DF2 defs=$5DF2:$08,$00
s $5DF2 Unused padding for player level/lives object (8 bytes total).
S $5DF2,6,$06
b $5DF8 Game level for inactive player.
D $5DF8 Level #1 starts at $00.
@ $5DF8 label=inactive_player_level
B $5DF8,1,1
b $5DF9 Inactive player lives remaining.
@ $5DF9 label=inactive_player_lives
B $5DF9,1,1
@ $5DFA defs=$5DFA:$08,$00
s $5DFA Unused padding for inactive player level/lives object (8 bytes total).
S $5DFA,6,$06
b $5E00 Buffers for Alien sprites.
D $5E00 4 buffers representing left/right facing aliens, with 2 animation frames each. #TABLE(default,centre,:w) { =h Bytes(n) | =h Meaning } { $00     | Header byte - always NULL? } { $01     | Width value - always $03 } { $02     | Height value } { $03-$33 | Pixel data } TABLE#
@ $5E00 label=buffers_aliens_R1
S $5E00,51,$33 right facing, anim frame 1
@ $5E33 label=buffers_aliens_R2
S $5E33,51,$33 right facing, anim frame 2
@ $5E66 label=buffers_aliens_L1
S $5E66,51,$33 left facing, anim frame 1
@ $5E99 label=buffers_aliens_L2
S $5E99,51,$33 left facing, anim frame 2
b $5ECC Buffers for Collectible/Rocket sprites.
D $5ECC Buffer to hold 4 item sprites. #TABLE(default,centre,:w) { =h Bytes(n) | =h Meaning } { $00     | Header byte } { $01     | Width value - always $03? } { $02     | Height value } { $03-$33 | Pixel data } TABLE#
@ $5ECC label=buffers_item_1
S $5ECC,51,$33 sprite 1
@ $5EFF label=buffers_item_2
S $5EFF,51,$33 sprite 2
@ $5F32 label=buffers_item_3
S $5F32,51,$33 sprite 3
@ $5F65 label=buffers_item_4
S $5F65,51,$33 sprite 4
@ $5F98 defs=$5F98:$68,$00
s $5F98 Unused padding.
S $5F98,104,$68
c $6000 #REGpc starts here, after game load.
@ $6000 label=EntryPoint
b $6003 Platform GFX location and size.
D $6003 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 1 | Colour Attribute } { 2 | X location (pixels) } { 3 | Y location (pixels) } { 4 | Width } TABLE#
@ $6003 label=gfx_params_platforms
B $6003,4,4 Middle
B $6007,4,4 Bottom
B $600B,4,4 Left
B $600F,4,4 Right
b $6013 Default player object state.
@ $6013 label=default_player_state
B $6013,8,8
b $601B Default Rocket and module objects state.
@ $601B label=default_rocket_state
B $601B,8,8 Rocket state
B $6023,8,8 Top module state
B $602B,8,8 Middle module state
b $6033 Default Rocket module state is a Fuel Pod.
@ $6033 label=default_rocket_module_state
B $6033,8,8
b $603B Default collectible item state.
@ $603B label=default_item_state
B $603B,8,8
b $6043 Main menu copyright message.
@ $6043 label=menu_copyright
B $6043,1,1 Text colour attribute
B $6044,1,1 Font code for © symbol
T $6045,30,30
B $6063,1,1 ASCII "D" & $80 (EOL)
c $6064 Reset the screen to its default state.
D $6064 Used by the routines at #R$6094, #R$60b7 and #R$61c9.
@ $6064 label=ResetScreen
C $6065,2 Set screen border to black
C $6067,3 Clear the screen
C $606A,3 Reset the screen colours
C $606D,3 Display score labels
N $6070 Display score labels text at the top of the screen.
C $6070,3 #REGhl=attribute file location
C $6073,3 #REGb=tile count, and #REGc=yellow colour
C $6076,4 Now set the tile colours
C $607A,3 Update display with player 1 score
C $607D,3 Update display with player 2 score
C $6080,3 Update display with high score
c $6083 Initialises a new level.
D $6083 A new Rocket is generated every 4 levels, otherwise it's a normal fuel collecting level. Used by the routines at #R$62fe and #R$6690.
@ $6083 label=LevelNew
C $6083,5 Check if player level is a MOD of 4?
C $6088,2 If not, initialise the level normally
N $608A Initialisation for a new rocket level.
C $608A,3 Reset all rocket modules with defaults
C $608D,4 Jetman has boarded the rocket; increment lives count. Used for display purposes only
C $6091,3 Initialise the player for the next level
c $6094 Initialise the level.
D $6094 Used by the routines at #R$6083 and #R$60b7.
@ $6094 label=LevelInit
C $6094,3 Initialise alien buffers
C $6097,3 Initialise the screen
C $609A,3 Draw the platforms
C $609D,3 Display all player lives
C $60A0,6 Set last_frame to current SYSVAR_FRAMES
c $60A7 Reset all rocket module states to their defaults.
D $60A7 Set object data to their defaults and copy to buffers. Used by the routines at #R$6083 and #R$62da.
@ $60A7 label=RocketReset
C $60A7,3 #REGhl=default rocket data
C $60AA,3 #REGde=start of rocket structs
C $60AD,3 24 bytes of rocket data to copy
C $60B4,3 Copy sprite data to the buffers.
c $60B7 End of turn for the current player.
D $60B7 Resets level states/buffers, and checks if it's game over for a player. Used by the routine at #R$687a.
@ $60B7 label=PlayerTurnEnds
C $60B7,3 #REGhl=Jetman thruster animation object
C $60BA,5 Reset all object states to be inactive
@ $60BF ssub=ld hl,$5d38+$04 ; #REGhl=Rocket module "state" field
C $60C2,2 Set to unused state
@ $60C4 ssub=ld hl,$5d40+$04 ; #REGhl=Collectible item "state" field
C $60C7,2 Set to unused state
N $60C9 Check if current and inactive player has lives, if not it is game over.
C $60C9,3 Game Options
C $60CE,2 Jump if two player
C $60D0,3 Current player lives
C $60D4,3 Game over if no lives remaining
C $60D7,3 Initialise a new level
C $60DA,3 Initialise next player
C $60DD,3 Inactive player lives
C $60E1,2 Game over if no lives remaining
C $60E3,3 Current player lives
C $60E7,3 Game over if no lives remaining
C $60EA,3 Switch players
C $60ED,7 Change current player (flip bits between $00 and $FF)
N $60F4 Switch rocket objects data for this new player
@ $60F4 ssub=ld a,($5d30+$04) ; Rocket module "state" field
C $60F7,5 Calculate the offset
C $60FC,3 Copy rocket sprite to buffer
C $60FF,3 Initialise level
C $6102,3 Initialise player
N $6105 Display the GAME OVER message for a player.
C $6105,2 ASCII character for the number "1" + EOL bit
@ $6107 ssub=ld ($6161+$12),a ; Append the number to game over text
C $610A,3 Initialise level screen
C $610D,3 Game Over message
@ $6110 keep
C $6110,3 Y,X coords in the display file
C $6113,3 Draw text to the screen
N $6116 After displaying the text, pause for a while.
N $6123 Handle message for player #2.
C $6123,2 ASCII character for the number "2" + EOL bit
C $6125,2 Append the number to the text, the display it
N $6127 Choose which player to show Game Over message for.
C $6127,6 Jump if current player is #1
C $612D,2 else, player is #2.
N $612F Game Over: update scores, show game over message, and initialise system.
C $612F,3 Update the high score
C $6132,6 Jump if current player is #2
C $6138,3 Display game over for player #1
C $613B,3 Reset the game
C $613E,3 Display game over for player #2
C $6141,3 Reset the game
c $6144 Swap current/inactive player/rocket states.
D $6144 Used by the routines at #R$60b7 and #R$62da.
@ $6144 label=PlayersSwap
C $6144,3 Current player level/lives
C $6147,3 Inactive player level/lives
C $614C,3 Swap 2 bytes
N $614F Now swap the current/inactive rocket states.
C $614F,3 Current player rocker state
C $6152,3 Inactive player rocker state
C $6155,2 We will be swapping 24 bytes
N $6157 Sub-routine for swapping HL/DE bytes.
b $6161 Text for game over message.
@ $6161 label=game_over_text
B $6161,1,1 Colour attribute
T $6162,17,17
B $6173,1,1 Player # (ASCII $31/$32) + $80 (EOL)
c $6174 Initialise player for new turn.
D $6174 Player has died, or started a new level, so Jetman object should be updated with default values. Used by the routines at #R$6083, #R$60b7 and #R$66b4.
@ $6174 label=PlayerInit
C $6174,3 Default Jetman values
C $6177,3 Jetman object
N $617F Set default "begin play" delay period.
C $617F,2 1 player delay
C $6181,3 Game options
C $6186,2 Jump if one player game
C $6188,2 else, double delay for 2 player game
C $618A,3 Update delay: 1 Player=$80, 2 Player=$FF
N $618D Decrement current player lives and update display.
C $618D,3 Current player lives
C $6194,3 Display player lives
c $6197 Flash 1UP or 2UP score label for active player.
D $6197 Used by the routine at #R$737d.
@ $6197 label=ScoreLabelFlash
C $6197,3 Current player number
C $619B,2 If player #2, flash 2UP text
C $619D,3 else #REGhl=1UP column position in attr file
c $61A0 Set flash state for the 3-attributes of the score label.
D $61A0 Used by the routine at #R$61ba.
R $61A0 Input:HL screen coordinate.
@ $61A0 label=FlashText
C $61A0,3 #REGhl=coord to attribute file address (using #REGhl)
C $61A3,2 Loop counter for 3 characters
C $61A5,7 Set FLASH on for each attribute
c $61AD Turn off flashing of 1UP or 2UP score label for active player.
D $61AD Used by the routine at #R$737d.
R $61AD Input:HL screen coordinate.
@ $61AD label=ScoreLabelUnflash
C $61AD,3 #REGhl=coord to attribute file address (using #REGhl)
C $61B0,2 Loop counter for 3 characters
C $61B2,7 Set FLASH=off on for each attribute
c $61BA Flash 2UP score label.
D $61BA Used by the routine at #R$6197.
@ $61BA label=FlashScoreLabel2UP
C $61BA,3 2UP column position in attribute file
c $61BF Game initialisation for first run.
D $61BF Reset all scores, sets the SP, initialises the screen, and displays the main menu. Used by the routine at #R$6000.
@ $61BF label=StartGame
C $61BF,10 Reset all scores
c $61C9 Reset system and show menu screen.
D $61C9 Used by the routine at #R$60b7.
@ $61C9 label=ResetGame
C $61C9,1 Interrupts are disabled for the core engine code
@ $61CA ssub=ld sp,$5ccb+$25 ; Set the stack pointer
C $61CD,3 Reset the screen
C $61D2,3 Reset Speed modifier to its default
c $61D5 Show menu screen and handle menu selection.
@ $61D5 label=MenuScreen
C $61D5,3 Draw the menu entries
C $61D8,4 #REGd=Game options
N $61DC Read the keyboard and perform menu selection.
C $61DC,2 Row: 1,2,3,4,5
C $61DE,2 Set port for reading keyboard
C $61E0,2 ...and read that row of keys
C $61E2,1 Flip bits so a `1` means a key is pressed.
C $61E3,2 Key #1 pressed? ("1 PLAYER GAME")
C $61E5,2 No key pressed? Jump
C $61E7,2 else, Player count = 1
C $61E9,2 Key #2 pressed? ("2 PLAYER GAME")
C $61EB,2 No key pressed? Jump
C $61ED,2 else, Player count = 2
C $61EF,2 Key #3 pressed? ("KEYBOARD")
C $61F1,2 No key pressed? Jump
C $61F3,2 else, Input type = keyboard
C $61F5,2 Key #4 pressed? ("JOYSTICK")
C $61F7,2 No key pressed? Jump
C $61F9,2 else, Input type = joystick
C $61FB,5 Key #5 pressed? ("START GAME")
C $6200,4 Update the Game options
N $6204 Update flashing state of the menu items.
@ $6204 ssub=ld hl,$6261+$01
C $6204,3 Point #REGhl to main menu colour attributes list.
C $6207,4 #REGc=Game options
C $620B,4 Jump if player count = 2
C $620F,3 Set flashing state for a one player game
C $6212,4 Jump if input type = joystick
C $6216,3 Set flashing state for keyboard input
C $6219,3 Loop and process again main menu input
C $621C,3 Set flashing state for a two player game
C $621F,2 Check input type
C $6221,3 Set flashing state for joystick input
C $6224,2 Loop and process again menu selection
N $6226 Set flashing state for "1 PLAYER GAME" and "KEYBOARD" menu items.
N $622D Set "2 PLAYER GAME" and "JOYSTICK" menu items flashing.
c $6234 Display the main menu items to the screen.
D $6234 Used by the routine at #R$61d5.
@ $6234 label=MenuDrawEntries
C $6234,3 Point #REGde to main menu colour attributes
C $6238,3 #REGhl'=Y (y-position of the menu item)
C $623B,3 #REGde'=to the beginning of the menu strings
C $623E,2 #REGb'=loop counter for the 6 colour attribute bytes
N $6240 Flip-flop between normal/shadow registers: meaning one time we hit this EXX we are using the shadow registers, the next the normal registers.
C $6241,1 #REGa=current colour attribute
C $6242,3 Store menu colour attribute
C $624C,2 #REGl'=indentation
C $624E,3 Write line of text to screen
C $6255,2 Duel purpose loop: both colour attrs and menu items
@ $6257 keep
C $6257,3 Note: address is past 7FFF limit of 16K ZX Spectrum
C $625A,3 Point #REGde to the copyright string
C $625D,3 Now display the copyright message
b $6261 Colour attributes for main menu.
D $6261 #TABLE(default,centre,:w) { =h Bytes(n) | =h Menu Item } { 1 | Jetpac Game Selection } { 2 | 1 Player Game } { 3 | 2 Player Game } { 4 | Keyboard } { 5 | Joystick } { 6 | Start Game } TABLE#
@ $6261 label=menu_colour_table
B $6261,6,6
b $6267 Vertical position of each line of text in the main menu.
D $6267 #TABLE(default,centre,:w) { =h Byte(n) | =h Menu Item } { 1 | Jetpac Game Selection } { 2 | 1 Player Game } { 3 | 2 Player Game } { 4 | Keyboard } { 5 | Joystick } { 6 | Start Game } TABLE#
@ $6267 label=menu_position_table
B $6267,6,6
t $626D Text displayed on the main menu screen
@ $626D label=menu_text
T $626D,20,20
B $6281,1,1 ASCII "N" & $80 (EOL)
T $6282,16,16
B $6292,1,1 ASCII "E" & $80 (EOL)
T $6293,16,16
B $62A3,1,1 ASCII "E" & $80 (EOL)
T $62A4,11,11
B $62AF,1,1 ASCII "D" & $80 (EOL)
T $62B0,11,11
B $62BB,1,1 ASCII "K" & $80 (EOL)
T $62BC,13,13
B $62C9,1,1 ASCII "E" & $80 (EOL)
c $62CA Write a single line of text on the main menu screen.
D $62CA Used by the routine at #R$6234.
R $62CA Input:HL Coordinate on the screen to display the string.
@ $62CA label=MenuWriteText
C $62CA,1 Backup coordinate
C $62CB,3 #REGhl=coord to screen address (using #REGhl)
C $62CE,3 Current colour attribute
C $62D3,1 Restore coordinate
C $62D4,3 #REGhl=coord to attribute file address (using #REGhl)
C $62D7,3 Display text string at #REGhl, using #REGa' colour
c $62DA Reset current and inactive player data on new game.
D $62DA Used by the routine at #R$62fe.
@ $62DA label=ResetPlayerData
C $62DA,2 Loop counter: current then inactive player
C $62DE,3 Reset player level
C $62E3,3 First player has 4 "remaining" lives
C $62E6,3 Reset the rocket modules
C $62E9,3 Swap player game states
C $62ED,2 Repeat again for inactive player
C $62EF,5 But now update inactive player to have 5 "remaining" lives, not 4
C $62F4,3 Game options
C $62F9,1 Return if two player game
C $62FA,3 else one player game, so inactive player has no lives
c $62FE Start a new game.
D $62FE Resets all player, alien, and level data, then start a new game. Used by the routine at #R$61d5.
@ $62FE label=NewGame
C $62FE,3 Starting at the Player 1 score
@ $6301 nowarn
@ $6301 keep
C $6301,3 #REGb = counter, #REGc = fill byte
C $6304,3 Clear memory, with null byte
C $6307,3 Reset the player data
C $630A,3 Reset the self-modifying code
C $630D,3 Initialise a new level
c $6310 Reset stack pointer and enable interrupts before running main loop.
D $6310 If new item/alien was generated, this routine is called instead of MainLoop.
D $6310 Used by the routine at #R$6971.
@ $6310 label=MainLoopResetStack
@ $6310 ssub=ld sp,$5ccb+$25 ; Set the stack pointer
C $6314,4 #REGix=Rocket object
C $6319,3 Reset current alien number
c $631C The main game loop.
D $631C This routine is called until a new item/alien is generated, then #R$6310 is called.
D $631C Used by the routines at #R$6310, #R$692e and #R$6971.
R $631C Input:IX address of main jump table
@ $631C label=MainLoop
C $631C,8 Compare SYSVAR_FRAMES and last_frame
N $6324 Note: if we have EI here, then #R$692e will be called and DI executed.
C $6324,3 If they're not equal, do frame update
N $6327 When one of the `main_jump_table` update routines RETurns, the new game actor routine will be called.
@ $6327 nowarn
C $6327,3 #REGhl=generate new actor routine
C $632A,1 ...and push `ret` address to the stack.
N $632B Execute one of the update routines using the value in IX.
C $632B,3 #REGhl=main jump table
C $632E,6 Calculate the jump table offset
c $6334 Performs a main loop update jump.
D $6334 Used by the routines at #R$631c and #R$648b.
R $6334 Input:A Offset for jump table address.
R $6334 HL Address to the jump table.
@ $6334 label=PerformJump
C $6335,2 #REGbc=offset: 34 max (size of jump table)
C $6337,1 Set #REGhl to jump table address using offset
C $6338,4 Assign the jump address back to #REGhl
C $633C,1 Use `jp` so `ret` calls the new actor/timer routine
w $633D Main game loop jump table.
D $633D Addresses for all the main routines to be updated per game loop.
@ $633D label=main_jump_table
W $633D,2,2 Frame rate limiter
W $633F,2,2 Jetman Fly
W $6341,2,2 Jetman Walk
W $6343,2,2 Meteor Update
W $6345,2,2 Collision Detection
W $6347,2,2 Crossed Space Ship Update
W $6349,2,2 Sphere Alien Update
W $634B,2,2 Jet Fighter Update
W $634D,2,2 Animate Explosion
W $634F,2,2 Rocket Update
W $6351,2,2 Rocket Take off
W $6353,2,2 Rocket Landing
W $6355,2,2 SFX Death: Enemy
W $6357,2,2 SFX Death: Player
W $6359,2,2 Check Item Collected
W $635B,2,2 UFO Update
W $635D,2,2 Animate Laser Beam
W $635F,2,2 Squidgy Alien Update
c $6361 Update the high score.
D $6361 If one of the players score is a new max score, then update the high score with that of the player with the highest score. Used by the routine at #R$60b7.
@ $6361 label=UpdateHiScore
C $6361,3 #REGhl=player 1 score
C $6364,4 #REGde=player 2 score
C $6368,3 Swap the P1 LSB/MSB values so we can perform calculations on them.
C $636B,3 Swap the P2 LSB/MSB values so we can perform calculations on them
C $636E,1 Reset the Carry flag
C $6371,2 Jump if score P2 > P1, else
C $6373,2 Jump if score P1 > P2, else P1==P2, so no jump
@ $6375 ssub=ld a,($5cf4+$02)
C $6375,4 #REGe=3rd byte of the P1 score
@ $6379 ssub=ld a,($5cf7+$02) ; P2 score
C $6379,3 #REGa=3rd byte of the P2 score
C $637D,2 Jump if score of P2 < P1 (set's #REGhl to P1 score)
N $637F Inactive player has the highest score.
C $637F,3 #REGhl=P2 score
N $6382 Update the high score if the player score has beaten it.
C $6383,3 #REGde=high score
C $6386,2 Loop counter (all 3 score bytes)
C $6388,1 #REGa = hi-score byte
C $6389,1 Compare with player
C $638A,2 If hi-score < player, update highscore score
C $638C,2 If hi-score != player (not equal), then RET
C $638E,1 else hi-score == player: next player byte
C $638F,1 next high score byte
C $6390,2 Repeat
C $6392,1 Restores #REGhl to the highest player score
N $6394 Sets the bytes for the high score with those from the player.
C $6395,3 High Score
N $639E Player 1 has the highest score.
C $639E,3 #REGhl=P1 score
C $63A1,2 Update HI score
c $63A3 Update Jet Fighter.
R $63A3 Input:IX Alien object for one of the Jet Fighters.
@ $63A3 label=JetFighterUpdate
C $63A3,4 Increment current alien number
C $63A7,3 Update Alien direction
C $63AA,3 Alien "moving" field
C $63B0,4 Move if bit-1 is set
C $63B4,3 Check and update speed
C $63B7,3 #REGa=Jetman Y position
C $63BC,6 Update Alien speed if Jetman Y position-12 equals Alien Y position
C $63C2,3 #REGa=LSB of game timer
C $63C7,2 Move vertically if bit-6 is reset
C $63CF,2 Move vertically +2 or -2
N $63D1 Decide if speed should be updated.
C $63D1,3 #REGa=random number
C $63D6,1 Return if not zero
N $63D7 Update speed.
C $63D7,4 Alien "moving" field
C $63DB,1 #REGc=Jetman Y position-12 ?
C $63DC,3 #REGa=LSB of game timer
C $63E4,3 Set new X speed value
C $63E7,4 Set "colour" to White
N $63EC Move Jet Fighter horizontally.
C $63EC,3 Decrement alien X speed
C $63EF,2 Jet Fighter killed if X speed is zero
C $63F1,2 #REGa=default speed
C $63F3,4 Check bit-6 of Alien "direction"
C $63FB,1 #REGl=$FC or $04?
N $63FC Target the player and move towards them.
C $63FC,8 Move upwards if Jetman Y position higher than Alien Y position
C $6404,2 else, move down
N $6406 Move Jet Fighter vertically and horizontally.
C $6406,3 Alien "direction"
C $6409,2 Reset FLY and WALK bits
C $640D,3 Update "direction" value
C $6410,7 Update Alien X position (#REGl is probably 3 or 4)
C $6417,7 Update Alien Y position
C $641E,3 Update Actor Position X and draw
C $6421,3 Colourize the sprite
C $6424,7 Kill Fighter if Y position < $28
C $642B,3 Fire laser beam - returns #REGc
C $642E,4 Kill if a laser hit the Alien
C $6432,3 Platform collision - returns #REGe
C $6435,4 Kill if Alien hit a platform
C $6439,3 Alien collision - returns #REGde
C $643D,2 Alien killed by collision
C $643F,10 Update Alien "direction"
N $644A Jet Fighter is dead. Added score and make exploding sound.
C $644A,3 55 points for a dead jet fighter (decimal value)
C $644D,3 Add points to score
C $6450,3 Exploding jet fighter SFX - actually Thruster SFX!
C $6453,3 Update current alien state
c $6456 Alien SFX when killed by collision.
D $6456 Reset anim state and set SFX params #2.
D $6456 Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
@ $6456 label=AlienCollisionAnimSfx
C $6456,3 Update actor state
C $6459,5 Play explosion sound with SFX type #2
C $645E,3 Animate explosion
c $6461 Jetman collects a collectible item.
R $6461 Input:IX Collectible item object
@ $6461 label=ItemCheckCollect
C $6461,3 Update Actor position direction
C $6464,3 Platform collision - returns #REGe
C $6467,10 Increment item Y position if bit-2 is set
C $6471,3 Alien collision - returns #REGe
C $6475,2 Drop new collectible item if #REGe > 0
C $6477,1 Reset #REGa
C $6478,3 #REGhl=sprite address
C $647B,3 Destroy the collected item
C $647E,4 Set type as unused
C $6482,3 250 points to add to score (decimal value)
C $6485,3 Add points to score
C $6488,3 SFX for item collect (and return)
c $648B Drop a new collectible item.
D $648B Used by the routine at #R$6461.
R $648B Input:IX Collectible item object
@ $648B label=ItemDropNew
C $648B,3 Jump table offset
C $648E,2 Values: 0, 2, 4, 6, or 8
C $6490,3 #REGhl=item drop jump table
C $6493,3 Execute the jump using #REGhl address
w $6496 Item drop jump table.
@ $6496 label=item_drop_jump_table
W $6496,2,2 Drop Gold bar collectible
W $6498,2,2 Drop chemical based collectible
W $649A,2,2 Drop chemical based collectible
W $649C,2,2 Drop green coloured collectible
W $649E,2,2 Drop collectible with random colour
c $64A0 Drop a gold bar collectible item.
R $64A0 Input:IX Collectible item object
@ $64A0 label=ItemDropGoldBar
C $64A0,4 Set colour to GOLD
c $64A4 Display a collectible sprite.
D $64A4 Used by the routines at #R$64bc, #R$64c2 and #R$64d7.
@ $64A4 label=ItemDisplaySprite
C $64A5,3 #REGde=item sprite address
C $64A8,3 Update the item sprite
C $64AB,3 Colourize the sprite
c $64AE Sprite offset using colour attribute.
D $64AE Used by the routines at #R$6461, #R$64a4 and #R$6514.
@ $64AE label=ItemGetSpriteAddressAttrOffset
c $64B1 Get address for collectible sprite.
D $64B1 Used by the routine at #R$66fc.
R $64B1 Input:A Offset for the desired sprite.
R $64B1 Output:DE Address for a sprite.
@ $64B1 label=ItemGetSpriteAddress
C $64B1,3 Sprite lookup table
C $64B4,4 Add offset to base address
C $64B8,3 Assign sprite address to #REGde
c $64BC Drop a Plutonium collectible item.
R $64BC Input:IX Collectible item object.
@ $64BC label=ItemDropPlutonium
C $64BC,4 Set the colour to green
C $64C0,2 Display item sprite
c $64C2 Drop a chemical based item, flashing items radiation and plutonium.
R $64C2 Input:IX Collectible item object.
@ $64C2 label=ItemDropChemical
C $64C2,3 Game timer
C $64C9,2 Use cyan colour and display sprite
N $64CB Flashing items: hidden.
C $64CB,4 Set the colour to black
C $64CF,2 Display the item sprite
N $64D1 Flashing items: visible.
C $64D1,4 Set the colour to cyan
C $64D5,2 Display the item sprite
c $64D7 Drop a random coloured collectible item.
D $64D7 Set the sprite to a random colour based on it's ID, which means colour values will be between $41 and $47.
R $64D7 Input:IX Collectible item object.
@ $64D7 label=ItemDropRandomColour
C $64D7,3 Game timer
C $64DE,2 Jump if #REGa is now 1-7
C $64E1,2 Make sure colour value is > $40
C $64E3,3 Set the colour to between $41 and $47
C $64E6,2 Display the item sprite
c $64E8 Collision detection for collectible items / rocket modules.
R $64E8 Input:IX Collectible item object.
@ $64E8 label=CollisionDetection
C $64E8,3 Update Actor position direction
C $64EB,3 #REGa=item "state"
C $64EE,5 Pick up rocket module if bit-2 set
C $64F3,4 Carrying rocket module/fuel if bit-1 set
C $64F7,4 Draw sprite if bit-0 reset
C $64FB,3 Check for alien collision - returns #REGe
C $64FE,3 Collect rocket module if #REGe == 0
C $6501,3 Platform collision - returns #REGe
C $6504,4 Draw sprite if bit-2 set
c $6508 Increment Y position and draw sprite.
D $6508 Used by the routine at #R$6565.
@ $6508 label=IncYRedrawSprite
c $650E Redraw a sprite.
D $650E Used by the routines at #R$64e8, #R$6523 and #R$6541.
@ $650E label=RedrawSprite
C $650E,3 Update actor and draw sprite
C $6511,3 Colourize the sprite
c $6514 Gets collectible ID based on the current user level.
D $6514 Used by the routine at #R$64e8.
@ $6514 label=GetCollectibleID
C $6514,3 Current player level
C $6518,2 There are only 6 collectibles?
C $651A,3 #REGde=collectible item sprite address
C $651D,3 Erase an item sprite
C $6520,3 Colourize the sprite
c $6523 Collect Rocket module or fuel pod.
D $6523 Module is collected after player collides with it. Used by the routine at #R$64e8.
R $6523 Input:IX Rocket module object.
@ $6523 label=CollectRocketItem
C $6523,4 Module "state"
C $6527,3 Find and destroy the sprite (returns #REGde)
C $652A,3 100 points to add to score (decimal value)
C $652D,3 Add points to score
C $6530,3 SFX for collecting fuel
C $6533,9 Update module position so it becomes attached to the player via the Jetman Y,X positions
C $653C,3 Update sprite X position
C $653F,2 Colourize the sprite
c $6541 Carry a collected rocket module/fuel pod.
D $6541 Ensure the rocket module/fuel pod remains attached to the foot of the Jetman sprite. Used by the routine at #R$64e8.
R $6541 Input:IX Rocket module object.
@ $6541 label=CarryRocketItem
C $6541,9 Update module position so it becomes attached to the player via the Jetman Y,X positions
@ $654A ssub=ld a,($5d30+$01) ; Rocket X position
C $654D,3 Subtract module X position
C $6550,3 If already negative, jump
C $6553,2 else make a negative value
C $6555,4 Draw sprite if #REGa >= 6
C $6559,4 Set module "state" to collected
@ $655D ssub=ld a,($5d30+$01) ; Rocket: X position
C $6560,3 Update module X position to be same as Rocket position
C $6563,2 Update module and draw sprite
c $6565 Pick up and carry a rocket module/fuel pod.
D $6565 Used by the routine at #R$64e8.
R $6565 Input:IX Collectible item object - rocket module or fuel pod.
@ $6565 label=PickupRocketItem
C $6565,3 Item sprite jump table offset
C $656A,2 Jump to delivery check if a fuel pod?
C $656E,3 Add item Y position
C $6573,3 Increment item Y position and draw sprite if < 183
@ $6576 ssub=ld a,($5d38+$04) ;
@ $657B ssub=ld ($5d38+$04),a ; Set module "state" to collected
@ $657E ssub=ld a,($5d30+$04) ; #REGa=Rocket "state" value
@ $6582 ssub=ld ($5d30+$04),a ; Update rocket "state" value
C $6585,3 Item sprite jump table offset
C $658A,3 Copy rocket sprite to buffers
C $658D,3 Find and destroy current sprite
C $6590,4 Set item type to unused
C $6594,3 SFX for rocket building
N $6597 Check if fuel pod delivered to ship, and increment count if so.
C $6597,3 Item Y position of fuel pod
C $659A,2 Has it reached the rocket yet?
C $659C,3 Move the fuel cell down one pixel if not
@ $659F ssub=ld a,($5d30+$05) ; #REGa=rocket fuel pod count
@ $65A3 ssub=ld ($5d30+$05),a ; Increment rocket fuel pod count
C $65A6,2 Loop back and repeat
c $65A8 Release new collectible item.
D $65A8 Used by the routine at #R$6971.
@ $65A8 label=ItemNewCollectible
C $65A8,3 Jetman direction
C $65AD,1 Return if not one of the 6 directions
C $65B0,1 Return if >= 3 (all movement except up right?)
C $65B1,3 #REGhl=default item state
C $65B4,3 #REGde=collectible object
C $65BA,1 #REGa=item type
C $65BC,1 Return if currently in use
C $65BD,3 Game timer
C $65C2,1 Return if between 1-127
C $65C5,3 #REGa=column to drop item
@ $65C8 ssub=ld ($5d40+$01),a ; Update item X position
C $65CB,2 Get random number
C $65CD,2 #REGa=2, 4, 6, 8, 10, 12, or 14
C $65CF,4 Jump if bit-3 is already reset
C $65D3,2 else set bit-3
C $65D5,2 Make sure bit-5 (32) is set
@ $65D7 ssub=ld ($5d40+$06),a ; Update item with new jump table offset
c $65DB Calculate column on which to drop a new collectible item/fuel pod.
D $65DB Used by the routines at #R$65a8 and #R$65f9.
R $65DB Ouput:A Column position.
@ $65DB label=ItemCalcDropColumn
C $65DB,3 #REGhl=item drop position table
C $65DE,3 #REGa=random number
C $65E3,3 #REGbc = byte offset (0-15)
C $65E6,1 Add offset
C $65E7,1 Set #REGa to position
b $65E9 Horizontal column positions for dropping collectibles.
@ $65E9 label=item_drop_positions_table
B $65E9,16,8
c $65F9 Drop a new fuel pod collectible.
D $65F9 Used by the routine at #R$6971.
@ $65F9 label=ItemNewFuelPod
C $65F9,3 Jetman direction
C $65FE,1 Return if not one of the 6 directions
C $6601,1 Return if >= 3 (all movement except up right?)
C $6602,3 #REGhl=default rocket module state
C $6605,3 #REGde=rocket module object
C $660B,3 Return if currently in use
@ $660E ssub=ld a,($5d30+$05) ; #REGa=Rocket fuel Pod count
C $6613,1 Return if fuel collected >= 6
C $6614,3 Game timer
C $661A,1 Return if #REGa is between 1-15
C $661D,3 #REGa=column to drop item
@ $6620 ssub=ld ($5d38+$01),a ; Update fuel pod X position
c $6624 Reset the Rocket modules state data ready for next level.
D $6624 After the rocket hits top of screen this routine resets all the collectibles, aliens, and player states for that level. Used by the routine at #R$6690.
@ $6624 label=RocketModulesReset
C $6624,3 #REGhl=rocket module
C $6627,2 Loop counter
c $6629 Set objects as inactive.
D $6629 Used by the routines at #R$60b7 and #R$6624.
R $6629 Input:B Loop counter: either $0A or $0C.
R $6629 HL Object to be updated: fuel pod or thruster animation.
@ $6629 label=SetObjectInactive
C $6629,3 Increment value
C $662C,2 Reset first byte of object
C $662E,1 Set #REGhl to beginning of next object
c $6632 Animate the rocket flame sprites.
D $6632 Used by the routines at #R$6690 and #R$66b4.
R $6632 Input:IX Rocket object
@ $6632 label=RocketAnimateFlames
C $6632,8 Add 21 to rocket Y position
@ $663A ssub=ld hl,$5dc0+$01 ; #REGhl=Actor Y position
C $663D,4 Add 21 to actor Y position
C $6641,7 If near ground, turn off flame sprites
C $6648,2 If >= 184, just update flame sprite vars
C $664A,3 Game timer
C $664F,2 #REGde=flame sprite #1 if bit-3 is set
C $6651,3 else #REGde=flame sprite #2
N $6654 Draw the flame sprites.
C $6655,6 Destroy flame sprite #1
C $665B,6 Destroy flame sprite #2
C $6662,3 Erase and animate actor sprite
C $6665,4 Set flame sprite colour to Red
C $6669,3 Colourize the sprite
N $666C Update Rocket and Actor Y positions.
C $666C,8 Subtract $15 from rocket Y position
@ $6674 ssub=ld hl,$5dc0+$01 ; #REGhl=Actor Y position
C $6677,4 Subtract 21 from actor Y position
N $667C Set first rocket flame sprite to be displayed.
C $667C,3 Rocket flame sprite #1
C $667F,2 Draw flame sprite
N $6681 Turn off the rocket flame sprites and update sprite variables.
C $6681,6 Destroy flame sprite #1
C $6687,6 Destroy flame sprite #2
C $668D,3 Update sprite variables
c $6690 Rocket ship is taking off.
R $6690 Input:IX Rocket object.
@ $6690 label=RocketTakeoff
C $6690,3 Update Actor position direction
C $6693,3 Decrement Y position
C $6696,3 Thruster SFX
C $6699,3 Animate rocket flame sprites
C $669C,5 Check if rocket has reached top of screen
C $66A1,2 Update rocket colour if not
N $66A3 Rocket has reached top of screen - set up next level.
C $66A3,4 Increment current player level
C $66A7,3 Reset rocket ready for next level
C $66AA,3 Set Rocket "move" state to down
C $66AD,4 Reset fuel pod counter
C $66B1,3 New level
c $66B4 Rocket ship is landing.
R $66B4 Input:IX Rocket object.
@ $66B4 label=RocketLanding
C $66B4,3 Update Actor position direction
C $66B7,3 Increment Y position
C $66BA,3 Thruster SFX
C $66BD,3 Animate rocket flame sprites
C $66C0,5 Check if rocket has landed
C $66C5,2 Update rocket colour if not (and RET)
N $66C7 Rocket has landed!
C $66C7,4 Set Rocket "move" state to default (on pad)
C $66CB,3 Initialise the player state
C $66CE,2 Update rocket colour (and RET)
c $66D0 Update the rocket ship.
R $66D0 Input:IX Rocket object.
@ $66D0 label=RocketUpdate
C $66D0,3 Update Actor position direction
C $66D3,3 #REGe=Alien collision result: $00 or $01
C $66D6,3 Update rocket colour if not zero (and RET)
C $66D9,7 Update rocket colour if fuel pod counter < 6 (and RET)
C $66E0,3 Set Rocket "move" state to up
C $66E5,4 #REGix=Jetman object
C $66E9,3 Update Jetman position direction
C $66EC,3 Jetman, find and destroy
C $66EF,4 Reset Jetman direction
C $66F3,2 Restore #REGix to be the rocket object
C $66F5,4 Increment current player lives
C $66F9,3 Display player lives (and RET)
c $66FC Update Rocket ship colour.
D $66FC Colouring is based on the number of fuel pods collected. This routine is never CALLed (only via JR), so the last RET forces the calling routine to return. Used by the routines at #R$6690, #R$66b4 and #R$66d0.
R $66FC Input:IX Rocket object.
@ $66FC label=UpdateRocketColour
C $66FC,3 Rocket X position
C $66FF,3 Rocket Y position
C $6703,3 #REGa=colour attribute
C $6706,3 Set loop counter
N $6709 Draw all collected rocket modules.
C $670A,3 #REGa=player level
C $670D,7 Calculate which sprite to use for the current level
C $6714,3 #REGde=item address from lookup table using #REGa
C $6717,3 Update actor position using #REGde
C $671A,1 Restore loop counter
C $671B,8 Subtract 16 from a rocket Y position
@ $6723 ssub=ld a,($5dc0+$01) ; #REGa=Actor Y position
C $6726,2 Subtract 16 from Actor Y position
@ $6728 ssub=ld ($5dc0+$01),a ; Update Actor Y position
C $672F,2 Loop and update rocket/actor again
@ $6733 ssub=ld ($5dc0+$04),a ; Actor width = 2
@ $6737 ssub=ld ($5dc0+$03),a ; Actor height = 0 (?)
C $673B,3 Update rocket Y position: only Y changed in loop above
C $673E,3 Update current Actor Y,X coords
N $6741 Colour the rocket modules based on collected fuel pod count.
C $6741,6 Rocket "state"
C $6747,10 if value < 6, or the fuel pod counter is zero, then set rocket colour to white and redraw
C $6751,2 Check if all fuel collected (is checked at 6760)
C $6753,1 Preserve Carry (no care for #REGa)
C $6754,3 Game timer
C $675E,1 Restore Carry value (from 6751 check above)
C $6760,2 Colour all sprites if all fuel has been collected
C $6762,3 else use fuel pod count as loop counter
C $6765,4 Set colour to Magenta
C $6769,3 Update sprite colour
N $676C Set part of rocket back to white based on amount of uncollected fuel pods.
C $676C,2 #REGa=max possible fuel pods
C $676E,3 Subtract remaining fuel pod count
C $6771,1 Set loop counter
C $6772,5 Set Rocket colour to white
C $6777,3 Redundant JP!
C $677B,3 Colourize the sprite
C $677F,3 #REGhl=current rocket sprite coords
C $6782,4 Update Y position
C $6786,3 Update current rocket sprite coords
C $6789,2 Loop and continue colouring
w $678C Rocket and collectible sprite address lookup table.
@ $678C label=collectible_sprite_table
W $678C,2,2 Offset: $00 - Rocket #1: Bottom
W $678E,2,2 Offset: $02 - Rocket #5: Bottom
W $6790,2,2 Offset: $04 - Rocket #3: Bottom
W $6792,2,2 Offset: $06 - Rocket #4: Bottom
W $6794,2,2 Offset: $08 - Rocket #1: Middle
W $6796,2,2 Offset: $0A - Rocket #5: Middle
W $6798,2,2 Offset: $0C - Rocket #3: Middle
W $679A,2,2 Offset: $0E - Rocket #4: Middle
W $679C,2,2 Offset: $10 - Rocket #1: Top
W $679E,2,2 Offset: $12 - Rocket #5: Top
W $67A0,2,2 Offset: $14 - Rocket #3: Top
W $67A2,2,2 Offset: $16 - Rocket #4: Top
W $67A4,2,2 Offset: $18 - Fuel Cell
W $67A6,2,2 Offset: $1A - Fuel Cell
W $67A8,2,2 Offset: $1C - Fuel Cell
W $67AA,2,2 Offset: $1E - Fuel Cell
W $67AC,2,2 Offset: $20 - Gold Bar
W $67AE,2,2 Offset: $22 - Radiation
W $67B0,2,2 Offset: $24 - Chemical Weapon
W $67B2,2,2 Offset: $26 - Plutonium
W $67B4,2,2 Offset: $28 - Diamond
c $67B6 Rocket thruster SFX, and Jet Fighter explosions.
D $67B6 Used by the routines at #R$63a3, #R$6690 and #R$66b4.
R $67B6 Input:IX Jetman or Rocket object.
@ $67B6 label=SfxThrusters
C $67B6,3 Y position
C $67B9,8 Change pitch based on vertical position
C $67C1,1 Pitch
C $67C2,2 Duration
C $67C4,2 Play square wave sound
c $67C6 SFX for ship building.
D $67C6 Activated when ship module is dropped, or fuel cell touches the rocket base.
@ $67C6 label=SfxRocketBuild
C $67C6,2 Pitch
C $67C8,2 Duration
C $67CA,2 Play square wave sound
c $67CC SFX for collecting a fuel cell.
D $67CC Used by the routine at #R$6523.
@ $67CC label=SfxPickupFuel
C $67CC,2 Pitch
C $67CE,2 Duration
C $67D0,2 Play square wave sound
c $67D2 SFX for collecting an item, and when Jetman appears on-screen.
D $67D2 Used by the routines at #R$6461 and #R$737d.
@ $67D2 label=SfxPickupItem
C $67D2,2 Pitch
C $67D4,2 Duration
c $67D6 Play square wave sound.
D $67D6 Used by the routine at #R$67db.
@ $67D6 label=PlaySquareWave1
c $67DB Play square wave sound, starting with silence.
D $67DB Used by the routines at #R$67b6, #R$67c6 and #R$67cc.
R $67DB Input:D Sound frequency
R $67DB C Sound duration
@ $67DB label=PlaySquareWav2
C $67DB,2 Play sound/silence for desired length
C $67DD,6 Turn speaker OFF for desired duration
C $67E3,1 Decrement duration
C $67E4,2 Repeat until duration is zero
c $67E7 SFX for Laser Fire.
D $67E7 Used by the routine at #R$6f86.
@ $67E7 label=SfxLaserFire
C $67E7,2 Pitch/duration
C $67EC,7 Play sound for desire duration
C $67F4,2 Turn speaker OFF
C $67F6,1 Increment pitch
C $67FA,2 Repeat until pitch is $38
c $67FD Set the default explosion SFX params.
D $67FD The audio is triggered from the #R$6971 routine using the explosion_sfx_params data.
D $67FD Used by the routines at #R$6456, #R$6bf1, #R$6d5c and #R$6d9c.
R $67FD Input:A selects SFX #1 or #2.
@ $67FD label=SfxSetExplodeParams
C $67FE,2 #REGc=0 or 2
C $6802,3 #REGde=explosion SFX params
C $6805,3 #REGhl=explosion SFX param defaults
C $6808,1 Set offset: first or second pair of bytes
C $6809,6 Copy defaults to the params
b $6810 Default explosion SFX parameters.
D $6810 These parameters are used in pairs: SFX #1 is used for most aliens, while SFX #2 is used for player, sphere alien, and crossed ship. #TABLE(default,centre,:w) { =h Bytes(n) | =h Parameter } { 1 | SFX 1: Frequency } { 2 | SFX 1: Duration } { 3 | SFX 2: Frequency } { 4 | SFX 2: Duration } TABLE#
@ $6810 label=explosion_sfx_defaults
B $6810,4,4
c $6814 Play Jetman death SFX.
R $6814 Input:IX The explosion SFX params array.
@ $6814 label=SfxJetmanDeath
C $6814,3 Decrement the SFX duration
C $6817,2 Stop playing SFX if duration is zero
C $6819,2 Frequency = 16
C $681B,2 Play explosion SFX
c $681D Play enemy death SFX.
R $681D Input:IX The explosion SFX params array.
@ $681D label=SfxEnemyDeath
C $681D,3 Decrement the SFX duration
C $6820,2 Stop playing SFX if duration is zero
C $6827,1 Frequency = Duration + 24
c $6828 Plays the explosion sound effect.
D $6828 The note pitch goes from `low` to `high`.
D $6828 Used by the routine at #R$6814.
R $6828 Input:C note frequency.
@ $6828 label=SfxPlayExplosion
C $682A,2 Turn speaker ON
C $682C,1 Set duration
C $682D,2 Note continues for the frequency duration
C $6830,2 Turn speaker OFF
C $6833,2 Silence for the frequency duration
C $6835,1 Decrement frequency (higher pitch)
C $6836,2 Repeat until frequency is zero
c $6839 Sound has finished playing.
D $6839 Used by the routines at #R$6814 and #R$681d.
R $6839 Input:IX The explosion SFX params array.
@ $6839 label=SfxFinishReturn
C $6839,4 Set frequency to zero
c $683E Animate explosion after killing an alien.
D $683E Used by the routine at #R$6456.
@ $683E label=ExplosionAfterKill
C $6840,4 Jetman explosion animation object
C $6844,3 Jetman object
C $6847,1 Assign direction to temp variable
C $6848,1 Animation X position
C $6849,4 Set explosion X position to match Jetman X position
C $684D,5 Set explosion Y position to match Jetman
C $6852,1 #REGa=Jetman direction
C $6853,3 Reset actor, which also sets anim object "state" to $01
C $6859,3 Reset Jetman direction to not moving
c $685D Enable animation, state false.
D $685D Used by the routines at #R$63a3, #R$6456, #R$6bf1, #R$6d5c, #R$6d9c and #R$753c.
R $685D Input:IX Animation object.
@ $685D label=AnimationStateReset
C $685D,3 Animating state
C $6864,4 Set "state" to un-animated
c $6868 Enable animation and reset frame count.
D $6868 Used by the routine at #R$6874.
R $6868 Input:A New direction value.
R $6868 IX Animation object.
@ $6868 label=EnableAnimationState
C $6868,3 Update direction
C $686B,4 Set animating to "yes"
C $686F,4 Reset frame count
c $6874 Enable animation, state true.
D $6874 Used by the routine at #R$683e.
R $6874 Input:A New direction value.
R $6874 IX Animation object.
@ $6874 label=AnimationStateSet
C $6874,4 Set "state" to animating
c $687A Animates the explosion sprites.
R $687A Input:IX Explosion animation object
@ $687A label=AnimateExplosion
C $687A,4 Increment current alien number
C $687E,3 #REGc=explosion animation frame
C $6881,3 #REGb=explosion animation state
C $6884,3 Game timer
C $6888,5 Increment frame if timer&state is zero
C $688D,1 #REGa=original frame count
C $688E,2 Multiply by 2 (addresses are two-bytes)
C $6892,3 #REGhl=explosion sprite lookup table
C $6895,1 Set offset
C $6896,3 #REGde=address of the desired sprite
C $6899,6 Set #REGhl to Y,X coords of sprite
C $689F,2 Comparing with original frame count from 687e
C $68A1,2 If original frame >= 6 then animation has finished
C $68A5,2 If original frame >= 3 then half animated
C $68A7,3 Erase animation sprite
C $68AA,3 #REGa=random number
C $68B1,3 Update colour attribute to a random colour
C $68B4,3 Colourize the sprite
N $68B7 After an explosion, we check if it was the player that died!
C $68B7,6 Update anim object so "animating" = "direction"?
C $68BD,3 Update Actor position direction
C $68C0,3 Find and destroy actor
C $68C3,4 Reset "animating"
C $68C7,3 Animation object "direction"
C $68CE,3 Player was killed if < 3 (end of turn)
N $68D2 Called when half the explosion has been animated.
C $68D2,3 Get sprite screen position
C $68D5,3 Erase a destroyed actor
w $68D8 Explosion sprites lookup table.
D $68D8 Sprite addresses are repeated because on first use they are animated using a pink colour, then animated again in black, so as to make them disappear.
@ $68D8 label=explosion_sprite_table
W $68D8,2,2 Small explosion
W $68DA,2,2 Medium explosion
W $68DC,2,2 Large explosion
W $68DE,2,2 Small explosion
W $68E0,2,2 Medium explosion
W $68E2,2,2 Large explosion
c $68E4 Frame rate limiter.
D $68E4 Called at the beginning of each game loop. Setting a higher pause value will slow down aliens, and the speed at which fuel/collectibles fall.
@ $68E4 label=FrameRateLimiter
C $68E4,3 #REGa=frame ticked?
C $68E8,1 We have a new frame, so no pause
N $68E9 Execute an end-of-frame pause for the correct game speed
C $68E9,8 #REGhl=pause counter (192)
c $68F2 Copy the two sprites for an alien to the buffers.
D $68F2 Used by the routine at #R$6094.
@ $68F2 label=AlienBufferInit
C $68F2,3 #REGhl=alien sprite lookup table
C $68F5,3 Current player level
C $68FC,3 #REGde=offset address for lookup table
C $68FF,1 Add offset
C $6901,3 #REGde=right facing alien sprite buffer
C $6904,3 Reset rocket and copy sprite to buffer
C $6908,3 #REGde=left facing alien sprite buffer
N $690B Set rocket building state on Jetman, then copy sprites to the first pair of buffers.
C $690B,3 Jetman rocket state update
w $690E Alien sprite lookup table.
D $690E Aliens have three basic movement types:
R $690E * Single path: die upon impact with platforms.
R $690E - Meteor
R $690E - Jet Fighter
R $690E - Space Craft
R $690E * Variable path: direction changes randomly, or on platform collision.
R $690E - Squidgy Alien
R $690E - Sphere Alien
R $690E - Crossed Ship
R $690E * Chasers: move toward Jetman, avoid platform impacts.
R $690E - UFO
R $690E - Frog Alien
@ $690E label=alien_sprite_table
W $690E,2,2 Level #1: Meteor        (frame 1)
W $6910,2,2 -                     - (frame 2)
W $6912,2,2 Level #2: Squidgy Alien (frame 1)
W $6914,2,2 -                     - (frame 2)
W $6916,2,2 Level #3: Sphere Alien  (frame 1)
W $6918,2,2 -                     - (frame 2)
W $691A,2,2 Level #4: Jet Fighter
W $691C,2,2
W $691E,2,2 Level #5: UFO
W $6920,2,2
W $6922,2,2 Level #6: Crossed Space Ship
W $6924,2,2
W $6926,2,2 Level #7: Spacecraft
W $6928,2,2
W $692A,2,2 Level #8: Frog Alien
W $692C,2,2
c $692E Frame update and disabled item drop.
D $692E This also performs the self-modifying code update.
@ $692E label=FrameUpdate
C $692E,1 This routine only called if EI, so we must now disable
C $692F,6 Update last_frame to current SYSVAR_FRAMES
C $6935,5 Frame has ticked over, set to true
C $693A,2 Backup main jump table address
N $693C Do some the code modifying...
C $693C,3 #REGhl=points to the rocket object
@ $693F ssub=ld ($6971+$0d),hl ; Modify `LD BC, nnnn` - rocket object
C $6942,2 Value is a `JP` opcode
@ $6944 ssub=ld ($6971+$2b),a  ; Modify instruction to be `JP`
@ $6947 nowarn
C $6947,3 #REGhl=address to be modified
@ $694A ssub=ld ($6971+$2c),hl ; Modify `JP nnnn` address
N $694D ...code modifying complete.
C $694D,4 #REGix=Jetman object
C $6951,3 Execute main loop
c $6954 New actor: reset the modified code to original values.
D $6954 Used by the routines at #R$62fe and #R$6966.
@ $6954 label=ResetModifiedCode
C $6954,3 #REGhl=inactive Jetman object
@ $6957 ssub=ld ($6971+$0d),hl ; Reset `LD BC, 5D30` to use #REGhl
C $695A,2 Value is a `LD A (nnnn)` opcode
@ $695C ssub=ld ($6971+$2b),a  ; Restore modified opcode to `LD A (nnnn)` instruction.
@ $6962 ssub=ld ($6971+$2c),hl ; Restore to `LD A (nnnn)` address to 0244
c $6966 Reset the modified code within the current frame.
D $6966 Used by the routine at #R$6971, but only after that routine's code has been modified by #R$692e.
@ $6966 label=ResetModifiedInFrame
C $6966,3 First, reset the self-modifying code
C $6969,2 Restore jump table address, saved during frame update
C $696B,4 frame ticked=false - not a new frame
C $696F,2 Needed to tick over SYSVAR_FRAMES, main loop will disable interrupts with the frame update call
c $6971 Generate new game actor: alien, fuel, or collectible item.
D $6971 Depending on the self-modifying code state, this routine either generates a new item/alien, or updates the item drop game timer.
R $6971 Input:IX Item object.
@ $6971 label=NewActor
C $6971,4 Increment random number
C $6975,3 Set offset
C $6978,2 Set IX to next group of bytes
C $697A,3 Copy IX to HL
N $697D The self-modifying code routines change the address here to be either the inactive player (5d88) or the rocket object (5d30).
C $697D,3 #REGbc=inactive player or rocket object
C $6980,1 Clear the Carry flag
C $6981,5 If object pointed to by #REGix is before #REGbc object, then jump back to the main loop
N $6986 Read the keyboard to introduce a slight pause?
C $6986,2 Row: Shift,Z,X,C,V
C $6988,2 Set port for reading keyboard
C $698A,2 ...and read that row of keys
C $698C,2 Check if SHIFT key pressed
C $698E,2 Jump if pressed
N $6990 Now increment timer and get new random number.
C $6990,7 Increment the game timer
C $6997,2 Make sure #REGhl remains <= $00FF
C $6999,2 Get a RANDOM number?
N $699C The self-modifying code routine changes this to `JP 6966`. That routine resets the interrupts, before changing instruction here to `LD A,(0244)` - an address in the ROM which always returns $C1.
C $699C,3 #REGa=$C1, from 0244, because 5DCE is never used!
C $699F,1 #REGa=byte from address $0000 - $00FF
C $69A0,1 Add #REGr to the number
C $69A1,3 Update random number
C $69A4,9 Jump if current alien number < 3
C $69AF,2 Drop fuel/collectible if RND is < 32
C $69B1,7 Drop fuel/collectible if current alien number >= 6
C $69B8,6 Drop fuel/collectible if begin play delay counter > zero
C $69BE,3 Get jetman direction
C $69C4,2 If direction is zero, then find unused alien slot
C $69C7,2 Drop fuel/collectible if direction is still > zero
N $69C9 Find first unused alien slot.
C $69C9,3 Alien state objects
C $69CC,2 Loop counter (6 aliens)
C $69D1,5 Generate new alien if the slot is unused
C $69D6,1 else increment to the next alien object
C $69D7,2 ...and try again
N $69D9 Drop either a fuel pod or collectible item.
C $69D9,3 New fuel pod item
C $69DC,3 New collectible item
C $69DF,3 Run main loop after resetting SP and EI
N $69E2 Generate new alien in the given state slot (#REGhl).
C $69E2,1 Push current alien to stack (will be copied to #REGix)
C $69E4,8 Copy default alien state to current alien slot
C $69EC,2 Restore #REGix to point to current item object
C $69EE,3 Game timer
C $69F1,1 Backup to #REGe
C $69F2,2 #REGa=either 0 or 64
C $69F4,3 Set item "direction"
C $69F7,3 Set item "movement"
C $69FA,1 Restore #REGa to original game timer value
C $69FF,3 Update item Y position
C $6A02,3 Copy current item object address to #REGbc
N $6A05 Calculate and update new colour attribute.
C $6A05,1 Example: if BC = 5D78, C = $78 = 01111000
C $6A06,1 00111100
C $6A07,1 00011110
C $6A08,1 00001111
C $6A09,2 00000011 <- result of AND $03
C $6A0B,1 00000100
C $6A0C,1 00000101 = $05
C $6A0D,3 Update colour with value: $02, $03, $04, or $05
C $6A12,3 Update jump table offset to either 0 or 1
C $6A15,3 #REGhl=item level object types
C $6A18,15 Using the current player level, pull a value from the item level params table
C $6A27,3 Update item type to this value
C $6A2A,3 Drop fuel/collectible then execute the main loop
b $6A2D New item object types for each level - 8 bytes for 8 levels.
@ $6A2D label=item_level_object_types
B $6A2D,8,8
c $6A35 Update Squidgy Alien.
R $6A35 Input:IX Alien object.
@ $6A35 label=SquidgyAlienUpdate
C $6A35,4 Increment current alien number
C $6A39,3 Update actor direction
C $6A3C,3 Fire laser beam (returns #REGc)
C $6A40,3 Add the points for a kill if alien is dead
C $6A43,3 Alien collision check (returns #REGe)
C $6A47,3 Alien killed by collision if #REGe is zero
C $6A4B,3 Reset alien new direction flag
N $6A4E Check which direction alien is travelling after hitting a platform.
C $6A4E,3 Platform collision (returns #REGe)
C $6A51,4 Update alien X position if bit-2 is reset
C $6A55,4 Set alien direction to up if bit-7 set
C $6A59,4 Set alien direction to down if bit-4 set
N $6A5D Alien has hit the end of a platform: change direction.
C $6A5D,13 Update alien "moving" value
N $6A6A Update the alien X position.
C $6A6A,4 Check alien moving left/right bit
C $6A6E,3 #REGa=alien X position (fetch before the jump)
C $6A71,2 If moving left, subtract 2 from direction (via jump)
C $6A73,2 otherwise, we add 2 to move right
C $6A75,3 Set new X position +/- 2
N $6A78 Update the alien Y position, first checking if within the upper/lower bounds of the screen.
C $6A78,4 Check alien moving up/down bit
C $6A7C,3 #REGa=alien Y position (fetch before the jump)
C $6A7F,2 If moving up, subtract 2 from direction (via jump)
C $6A81,2 otherwise, we add 2 to move down
C $6A83,3 Set new alien Y position +/- 2
N $6A86 Draw the alien if new direction is set, otherwise repeat collision check again.
C $6A86,11 Draw the alien if the new direction flag is set, otherwise, increment the value
C $6A91,2 Jump back and repeat collision check
N $6A93 Change alien moving direction to up.
N $6A99 Change alien moving direction to down.
N $6A9F Subtract 2 from the X position (move left).
N $6AA3 Subtract 2 from the Y position (move up), unless it has reached top of screen.
C $6AA7,2 Return if not at top of screen
C $6AA9,4 Otherwise, set alien to moving down.
N $6AAF Add score to player if alien is dead.
C $6AAF,3 80 points (decimal value)
C $6AB2,3 Add points to score
C $6AB5,3 Kill Alien SFX #1
c $6AB8 Update UFO alien -- this alien is a chaser!
D $6AB8 TODO: annotations are really messy/wrong here, needs lots more work to understand how the movement is calculated.
R $6AB8 Input:IX Alien object.
@ $6AB8 label=UFOUpdate
C $6AB8,4 Increment current alien number
C $6ABC,3 Update actor direction
C $6ABF,3 Fire laser beam (returns #REGc)
C $6AC3,3 Add the points for a kill if alien is dead
C $6AC6,3 Alien collision check (returns #REGe)
C $6ACA,3 Alien killed by collision if #REGe is zero
C $6ACE,3 Reset alien new direction flag
N $6AD1 Check which direction alien is travelling after hitting a platform.
C $6AD1,3 Platform collision (returns #REGe)
C $6AD4,4 Update alien X position if bit-2 is reset
C $6AD8,5 Set alien direction to up if bit-7 set
C $6ADD,5 Set alien direction to down if bit-4 set
N $6AE2 Move the flying saucer in a slightly more erratic way (the XOR), rather than just heading directly for the Jetman.
C $6AE2,15 Update alien "moving" value
N $6AF1 Calculate new horizontal position and speed.
C $6AF1,3 Alien X speed
C $6AF4,8 Calculate new speed?
C $6AFC,3 Jetman X position
C $6AFF,3 Subtract alien X position
C $6B02,3 If Jetman X > alien X, then jump
C $6B05,7 If alien is moving left, then jump
C $6B0C,6 If current speed is less than max, then increment
N $6B12 Calculate new X position.
C $6B12,1 #REGc=current speed
C $6B13,3 #REGh=X position
C $6B16,3 Calculates and returns #REGde, new position offset
C $6B19,1 Clear the carry flag
N $6B1C Update the X position and speed
C $6B1C,3 Update X position
C $6B1F,7 Calculate and update X speed
N $6B26 Calculate new Y position and speed.
C $6B26,3 Alien Y speed
C $6B31,3 Jetman Y position
C $6B34,3 Subtract alien Y position
C $6B37,3 If Jetman Y > alien Y, then jump
C $6B3A,7 If alien is moving up then increment Y position (if not at top of screen) and jump to 6b49
C $6B41,4 Calculate new down Y position if #REGc > 0 (presumably above the ground)
C $6B45,4 else moving direction must be set to up...
C $6B49,1 ..and #REGc will have been decremented here
C $6B4A,3 #REGh=Y position
C $6B4D,3 Calculates and returns #REGde, new position offset
C $6B50,1 Clear the carry flag
C $6B53,9 Set moving direction as down if at top of screen
C $6B5C,3 Update Y position
C $6B5F,7 Update Y speed
N $6B66 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
C $6B66,3 Draw the alien if the new direction flag is set,
C $6B69,1 otherwise, increment it
C $6B6E,3 }
C $6B71,3 Jump back and repeat collision check
N $6B74 Check moving direction and update.
C $6B74,4 Check moving left/right bit
C $6B78,2 If moving left, increment speed (via jump)
C $6B7C,3 If not zero, calculate X direction/speed
C $6B7F,4 else set X moving to "right"
C $6B83,1 #REGa (speed) was decremented from 0, so will now be FF
C $6B84,3 #REGh=X position
C $6B87,3 Calculates and returns #REGde, new position offset
C $6B8B,3 Update the X position and speed
C $6B8E,6 If current speed is less than max, then increment
C $6B94,2 Update position
C $6B96,1 #REGa=speed
C $6B98,3 Update X position and speed unless zero
C $6B9B,4 Set moving direction to "right"
C $6B9F,3 Update X direction/speed
C $6BA2,4 Check Jetman moving direction
C $6BA6,2 Jump if top bit not set
C $6BA8,5 Jump if #REGc >= 15
C $6BAD,1 else increment it
C $6BAE,1 (will be #REGc = #REGc - 1)
C $6BB2,3 Calculates and returns #REGde, new position offset
C $6BB6,3 Update Y position and speed
C $6BB9,1 #REGa=speed
C $6BBB,2 If speed > 0 move upwards
C $6BBD,4 else set moving direction to "down"
C $6BC1,2 ...and update Y position and speed
C $6BC3,10 If current speed is less than max, then increment it, and update position
N $6BCD Change alien moving direction to up.
N $6BD4 Change alien moving direction to down.
N $6BDB Returns #REGde (new position) as calculated from the speed (#REGc).
C $6BDC,1 #REGc should be <= 15. Example, if value is $0F:
C $6BDD,1 0 00011110
C $6BDE,1 0 00111100
C $6BDF,1 0 01111000
C $6BE0,1 0 11110000
C $6BE1,2 Clear lower 4 bits...just in case!
C $6BE6,2 1 11100000
C $6BE8,2 If E >= 8, then bit-0 of D is set
c $6BEB Add points for UFO kill.
D $6BEB Used by the routine at #R$6ab8.
@ $6BEB label=UFOKillAddPoints
C $6BEB,3 50 points (decimal value)
C $6BEE,3 Add points to score
> $6BF1 ; Alien Killed SFX #1 - no score added.
c $6BF1 When alien was killed by laser fire, reset anim state, set explosion SFX params. Used by the routine at #R$6a35.
D $6BF1 Used by the routine at #R$6a35.
@ $6BF1 label=AlienKillAnimSfx1
C $6BF1,3 Update actor state
C $6BF4,1 #REGa should be 0 for the Alien SFX
C $6BF5,3 Plays explosion SFX for an Alien
c $6BF8 Update Sphere alien.
R $6BF8 Input:IX Alien object.
@ $6BF8 label=SphereAlienUpdate
C $6BF8,4 Increment current alien number
C $6BFC,3 Update actor direction
C $6C00,3 Reset alien new direction flag
C $6C03,3 Fire laser beam (returns #REGc)
C $6C07,3 40 points (decimal value)
C $6C0A,3 Kill Alien SFX #2 if alien is dead
C $6C0D,3 Alien collision check (returns #REGe)
C $6C11,3 Alien killed by collision if #REGe is zero
N $6C14 Check which direction alien is travelling after hitting a platform.
C $6C14,3 Platform collision (returns #REGe)
C $6C17,4 Update alien Y position if bit-2 is reset
C $6C1B,4 Set alien direction to up if bit-7 set
C $6C1F,4 Set alien direction to down if bit-4 set
N $6C23 Alien has hit the end of a platform: change direction.
C $6C23,13 Update alien "moving" value
N $6C30 Update the alien Vertical position.
C $6C30,4 Check alien moving direction
C $6C34,2 Update Y position if vertical movement
C $6C36,4 #REGe=random number
C $6C3C,2 Jump if != 0
C $6C3E,4 else set "moving" bit-0
C $6C42,10 Use Game timer to Y speed
C $6C4C,1 #REGa=original random number
C $6C4F,1 #REGe = 0 or 128
C $6C50,9 Update alien "moving" to either 127 or 255
C $6C59,2 Jump back and repeat collision check
N $6C5B Update the alien Horizontal position.
C $6C5B,4 Check alien "moving"
C $6C5F,2 Update X position if horizontal movement
C $6C61,3 else update Y position
N $6C64 Update the alien Y position, first checking if within the upper/lower bounds of the screen.
C $6C64,4 Check moving up/down bit
C $6C68,2 If moving up, subtract 2 from direction (via jump)
C $6C6A,2 otherwise, we add 2 to move down
C $6C6C,3 Set new Y position +/- 2
C $6C6F,3 Decrement Y speed
C $6C74,4 Reset bit-0 of alien "moving" if speed is zero
N $6C78 Update the alien X position.
C $6C78,3 #REGa=X position (fetch before the jump)
C $6C7B,4 Check moving left/right bit
C $6C7F,2 If moving left, subtract 2 from direction (via jump)
C $6C81,2 otherwise, we add 2 to move right
C $6C83,3 Set new X position +/- 2
N $6C86 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
C $6C86,11 Draw the alien if the new direction flag is set, otherwise, increment the value
C $6C91,3 Jump back and repeat collision check
N $6C94 Change alien moving direction to up.
N $6C9A Change alien moving direction to down.
N $6CA0 Subtract 2 from the Y position (move up), unless it has reached top of screen.
C $6CA4,2 Return if not at top of screen
C $6CA6,4 Otherwise, set to moving down
N $6CAC Subtract 2 from horizontal direction.
c $6CB0 Update Actor direction.
D $6CB0 Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8 and #R$6cbe.
R $6CB0 Input:IX Actor object.
@ $6CB0 label=ActorUpdateDir
C $6CB0,3 Update Actor position direction
C $6CB3,3 Actor direction
@ $6CBA ssub=ld ($5dc0+$02),a ; Update actor "direction"
c $6CBE Update crossed space ship.
R $6CBE Input:IX Alien object.
@ $6CBE label=CrossedShipUpdate
C $6CBE,3 Update actor direction
C $6CC1,4 Increment alien number
C $6CC5,3 Fire laser beam (returns #REGc)
C $6CC9,3 Add points and kill alien (type #3) if dead
C $6CCC,3 Alien collision (returns #REGe)
C $6CD0,3 Alien killed by collision
C $6CD4,3 Reset alien new direction
N $6CD7 Crossed ship direction change on platform collision.
@ $6CD7 label=CrossedShipPlatformCollision
C $6CD7,3 Platform collision (returns #REGe)
C $6CDA,4 Update alien X position if bit-2 is reset
C $6CDE,5 Set alien direction to up if bit-7 set
C $6CE3,5 Set alien direction to down if bit-4 set
N $6CE8 Alien has hit the end of a platform: change direction in a slightly more erratic way than other aliens (note the XOR).
C $6CE8,15 Update alien "moving" value
N $6CF7 Move crossed ship horizontally.
@ $6CF7 label=CrossedShipMoveShip
C $6CF7,4 Check moving left/right bit
C $6CFB,3 #REGa=X position (fetch before the jump)
C $6CFE,3 If moving left, subtract 2 from direction (via jump)
C $6D01,2 otherwise, we add 2 to move right
N $6D03 Update the alien YX position.
C $6D03,3 Set new X position +/- 2
C $6D06,6 #REGhl=Y speed x 2
C $6D0C,3 #REGd=alien X position
C $6D0F,3 #REGe=alien X speed
C $6D12,6 If alien moving is "up" subtract hl/de
C $6D18,1 else add them
N $6D19 Update vertical position, direction, and speed.
C $6D19,3 Set alien X speed
C $6D1C,3 Alien Y position = #REGh
C $6D1F,9 If alien is at top of screen, set to moving down
C $6D28,4 Check if moving up
C $6D2C,2 Change alien direction to down if it is
C $6D2E,3 else increment Y speed
C $6D31,2 Jump if it wasn't $FF before the increment
C $6D33,4 else set Y speed to $FF
N $6D37 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
C $6D37,10 Draw the alien if the new direction flag is set, otherwise, increment the value
C $6D41,2 Jump back and repeat collision check
c $6D43 Draw an alien sprite to the screen.
D $6D43 Used by the routines at #R$6a35, #R$6ab8, #R$6bf8 and #R$6cbe.
R $6D43 Input:IX Alien object.
@ $6D43 label=DrawAlien
C $6D43,4 Backup alien direction
C $6D47,7 Temporarily change alien direction
C $6D4E,3 Update actor X position (using temp direction)
C $6D51,3 Colourize the sprite
C $6D55,3 Restore original direction
c $6D59 Add score for crossed space ship kill.
D $6D59 Used by the routine at #R$6cbe.
@ $6D59 label=CrossedShipKillPoints
C $6D59,3 60 points (decimal value)
c $6D5C Alien Killed SFX #2.
D $6D5C When alien was killed by laser fire, reset anim state, set explosion SFX params, and add score. Used by the routine at #R$6bf8.
@ $6D5C label=AlienKillAnimSfx2
C $6D5C,3 Add points to score
C $6D5F,3 Update actor state
C $6D62,2 Set SFX to type #2
C $6D64,3 Play explosion sound with SFX type #2
c $6D67 Change alien direction flag to up, and other updates.
D $6D67 Used by the routine at #R$6cd7.
@ $6D67 label=CrossedShipDirUp
C $6D67,4 Set alien to moving up
C $6D6B,8 Update Y speed using random number
C $6D73,3 Update alien position
N $6D76 Change alien moving direction flag to down.
C $6D7A,3 Update alien position
N $6D7D Subtract 2 from X position.
C $6D7F,3 Update alien YX position
N $6D82 Change direction to down.
@ $6D82 label=CrossedShipDirDown
C $6D82,3 Decrement Y speed
C $6D85,6 If speed is zero, set to moving down
C $6D8B,2 Draw alien and perform platform collision
N $6D8D This entry point is used by the routine at #R$6cbe.
C $6D8D,1 Reset Carry flag
C $6D8E,1 Swap registers
C $6D8F,2 Subtract #REGde and Carry flag from #REGhl
C $6D91,3 Update vertical position, direction, and speed
b $6D94 Default alien state.
D $6D94 Copied to the alien object when a new alien is instantiated.
@ $6D94 label=default_alien_state
B $6D94,8,8
c $6D9C Update the meteor.
R $6D9C Input:IX Alien object.
@ $6D9C label=MeteorUpdate
C $6D9C,3 Update Actor position direction
C $6D9F,4 Increment alien number
N $6DA3 Update the alien X position.
C $6DA3,3 #REGa=X position
C $6DA6,4 Check moving left/right bit
C $6DAA,2 If moving left, subtract 2 from direction (via jump)
C $6DAC,3 otherwise, we add alien X speed to value
C $6DAF,3 Set new X position +/- 2
N $6DB2 Update the alien Y position.
C $6DB2,9 Add Y speed to current Y position
C $6DBB,3 Update actor X position (using temp direction)
C $6DBE,3 Colourize the sprite
C $6DC1,3 Platform collision (returns #REGe)
C $6DC4,4 Kill alien it collided with a platform
C $6DC8,3 Fire laser beam (returns #REGc)
C $6DCB,4 Kill alien if it is dead
C $6DCF,3 Alien collision check (returns #REGe)
C $6DD2,4 Alien killed by collision if #REGe is zero. Player gets no points!
N $6DD7 Add score for Meteor kill.
C $6DD7,3 25 points (decimal value)
C $6DDA,3 Add points to score
N $6DDD Kill meteor - reset state, and play explosion SFX #1.
C $6DDD,3 Update actor state
C $6DE0,1 #REGa should be 0 for the Alien SFX
C $6DE1,3 Plays explosion SFX for an Alien
N $6DE4 Subtract 2 from horizontal direction.
C $6DE4,3 Subtract X speed
c $6DE9 Alien Collision.
D $6DE9 Used by the routines at #R$63a3, #R$6461, #R$64e8, #R$66d0, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
R $6DE9 Input:IX Alien object.
R $6DE9 Output:E as either $00 or $01.
@ $6DE9 label=AlienCollision
C $6DE9,3 #REGhl=Jetman object
C $6DEC,2 Default value for #REGe
C $6DEE,1 Jetman direction
C $6DF1,3 Jump if #REGa - 1 == 0
C $6DF5,1 Return if #REGa is not zero
C $6DF6,1 #REGhl=Jetman X position
C $6DF8,3 Jetman X position - Alien X position
C $6DFB,5 Make sure we have a positive byte
C $6E00,3 Return if #REGa >= 12
C $6E03,1 #REGhl=Jetman Y position
C $6E05,3 Jetman Y position - Alien Y position
C $6E08,3 Set #REGd to 15 if it's still a positive number
C $6E0B,2 else: negate it
C $6E0D,3 #REGd=alien sprite height
C $6E12,2 Compare and return
C $6E14,2 default #REGd to 21
C $6E16,2 Return $00 if #REGd >= #REGa
C $6E1A,1 else return $01
c $6E1B Fire a laser beam.
D $6E1B Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
R $6E1B Input:IX Alien object.
R $6E1B Output:C Is either $00 or $01.
R $6E1B HL Pointer to current active laser beam object.
@ $6E1B label=LaserBeamFire
C $6E1B,3 offset
C $6E1E,3 Laser beam objects
C $6E21,2 Loop counter (4 laser beams)
C $6E23,1 #REGhl: += 8 after first iteration
C $6E24,4 If current laser beam is in use, try next one
C $6E28,1 #REGhl=Y position
C $6E29,1 #REGhl=X position: pulse #1
C $6E2A,1 #REGhl=X position: pulse #2
C $6E2B,1 #REGa=pulse #2
C $6E2C,1 #REGhl=X position: pulse #1
C $6E2D,4 Next iteration is bit-2 of pulse #2 is reset
C $6E33,3 Subtract alien X position from laser beam X position
C $6E36,3 If positive number, check position and next iteration
C $6E41,3 Next iteration if pulse X position is now >= 8/32
C $6E44,1 #REGhl=Y position
C $6E46,3 Subtract alien Y position from laser beam Y position
C $6E4B,3 If subtraction was negative number, next iteration
C $6E4E,2 else, add 12
C $6E50,6 Next iteration if >= sprite height
C $6E56,2 else set return value to $01
C $6E58,5 Update X position: pulse #1
C $6E5D,1 Set #REGhl to first byte of current group
C $6E5E,1 We're done here
C $6E5F,4 Try next laser beam object
C $6E63,3 Return $00
c $6E66 Reads 2 bytes of pixel data from a sprite.
D $6E66 Used by the routine at #R$6ea5.
R $6E66 Input:B Loop counter - sprite height?
R $6E66 HL Address of byte for current sprite.
R $6E66 Output:B Same value as on entry.
R $6E66 D First byte of pixel data.
R $6E66 E ????
R $6E66 C Second byte of pixel data.
R $6E66 HL Address to the next byte of the sprite.
@ $6E66 label=SpriteReadTwoBytes
C $6E66,2 Backup #REGb value
C $6E68,2 #REGe=third byte - NULL on read
C $6E6A,1 #REGc=first pixel byte
C $6E6C,1 #REGd=second pixel byte
C $6E6D,1 Set #REGhl to next byte (used later)
C $6E6E,3 Return if #REGb == 0
N $6E71 Rotating the bits.
C $6E71,8 Executes #REGb times
C $6E79,2 Restore #REGb to the entry value
c $6E7C Reverse all bits in Accumulator.
D $6E7C Two buffers are used for sprites facing the opposite direction so we need to flip the bits such that %00100111 becomes %11100100.
@ $6E7C label=ReverseAccBits
C $6E7C,1 Backup #REGbc
C $6E7D,2 Counter of 8-bits
C $6E7F,5 Do the bit reversal
C $6E84,1 Set return value
C $6E85,1 Restore #REGbc
c $6E87 Flip byte pair of an alien sprite so it faces opposite direction.
D $6E87 Used by the routine at #R$6ea5.
R $6E87 Input:B Loop counter.
R $6E87 HL Pointer to current byte of sprite.
R $6E87 Output:B Same value as on entry.
R $6E87 DE The flipped byte pair.
R $6E87 HL Pointer to next byte of sprite.
@ $6E87 label=BufferFlipSprite
C $6E87,2 Backup #REGb value
C $6E8B,1 Get byte from sprite
C $6E8C,3 #REGa=reversed byte
C $6E90,2 Get next byte from sprite
C $6E92,3 #REGa=reversed byte
C $6E96,1 Point #REGhl to next byte
C $6E97,3 Return if all bytes have been processed
C $6E9A,8 Shift sprite 4-pixels to the right?
C $6EA2,2 Restore #REGb to the original value
c $6EA5 Write all sprite pixel bytes to buffer.
D $6EA5 Bytes are first shifted and/or flipped along the horizontal axis. Used by the routine at #R$6f2a.
R $6EA5 Input:B Loop counter - sprite height.
R $6EA5 HL Pointer to buffer for data to be written to.
@ $6EA5 label=BufferWritePixel
C $6EA5,1 #REGhl=sprite, #REGhl'=buffer, #REGb'=counter
C $6EA6,6 Get next two bytes if Jetman rocket module status is zero
C $6EAC,3 #REGde=flipped byte pair
C $6EB1,1 #REGhl=buffer, #REGb=counter
C $6EB3,1 Write first byte
C $6EB6,1 Write the second byte
C $6EB8,1 Write third byte
C $6EB9,1 #REGhl=next buffer address
C $6EBA,2 Loop back, writing reversed sprite data to buffer
C $6EBC,1 We're done.
C $6EBD,3 #REGde=two new bytes of sprite pixel data
C $6EC0,2 Loop back, writing non-reversed sprite data to buffer
c $6EC2 Copy Rocket sprites for current level to the buffers.
D $6EC2 Using the sprite lookup table, this routine calculates which Rocket sprites to copy to the buffers or the current level, then calls the copy routine. Used by the routines at #R$60a7, #R$60b7 and #R$6565.
R $6EC2 Input:A Is the byte offset between the modules of the current rocket.
@ $6EC2 label=BufferCopyRocket
C $6EC3,3 #REGa=player level. Example, if level 3:
C $6EC6,1 A=10000001, C=1
C $6EC7,2 A=00000000
C $6EC9,1 A=00001000 (e.g. if #REGc=$08)
C $6ECA,3 #REGbc=sprite offset value
C $6ECD,3 Collectible sprite lookup table
C $6ED0,1 Offset address
C $6ED1,3 #REGde=start of buffers for all item sprites
C $6ED6,3 Set default for rocket module attached value
C $6EDA,3 Set default for Jetman rocket module connected value
C $6EDD,2 Loop counter - all 4 sprites?
C $6EE0,1 Backup loop counter
C $6EE1,1 #REGa starts at $00, then returns value from #R$6f0b
C $6EE2,2 #REGc=sprite count
C $6EE4,3 #REGhl=pointer to sprite pixel data
C $6EE8,1 Restore loop counter
C $6EE9,2 #REGhl=previous lookup table offset
C $6EEB,1 Decrement loop counter
C $6EEC,2 Repeat until counter is zero
c $6EEF Initialise rocket build state for new level.
D $6EEF After initialising, sprites are copied to the first pair of buffers. Used by the routine at #R$68f2.
R $6EEF Output:A New Jetman module connect status.
@ $6EEF label=RocketBuildStateReset
C $6EEF,3 #REGbc=sprite count
C $6EF2,5 Start of new level rocket state
C $6EF7,1 Used to reset Jetman module connect status
i $6EFA Old unused routines.
c $6F0B Copy Rocket sprite pixel data to the buffer.
D $6F0B Looks up the address for a sprite from the lookup table, then points #REGhl to the pixel data for that sprite. Used by the routine at #R$6ec2.
R $6F0B Input:HL Offset address in sprite lookup table.
R $6F0B DE Address of buffer to use.
R $6F0B Output:HL Pointer to pixel data block.
@ $6F0B label=BufferCopyRocketSpriteData
C $6F0E,4 #REGhl=sprite address, from lookup table
C $6F12,1 #REGhl=sprite "height"
C $6F13,1 #REGhl=sprite data block
C $6F14,2 Perform the copy
c $6F16 Set the rocket building state on Jetman.
D $6F16 After initialising the states, the sprites are then copied to the second pair of buffers. Used by the routine at #R$68f2.
@ $6F16 label=JetmanRocketStateUpdate
C $6F16,3 #REGbc=sprite count
C $6F19,2 Redundant opcode
C $6F1B,3 Redundant entry point for old code at 6F31
C $6F1E,2 Will set Jetman module connect status
c $6F20 Set rocket module state that Jetman was carrying.
D $6F20 Changed when Jetman successfully drops a carried module onto the Rocket pad. Used by the routine at #R$6eef.
R $6F20 Input:A state value.
@ $6F20 label=SetDroppedModuleState
c $6F23 Get address to sprite pixel data then copy to the buffer.
D $6F23 Used by the routine at #R$6f2a.
R $6F23 Input:HL Offset address in sprite lookup table.
R $6F23 Output:HL Pointer to pixel data block.
@ $6F23 label=BufferCopySprite
C $6F26,4 #REGhl=sprite address from lookup table
c $6F2A Copies the sprite pixel data to a buffer.
D $6F2A Note the copious amounts of register swapping! These annotations need checking. Used by the routine at #R$6f0b.
R $6F2A Input:C Number of bytes to copy?
R $6F2A HL Address pointing to the "height" value in a sprite header
R $6F2A DE Address of buffer to use.
@ $6F2A label=BufferCopySpriteData
C $6F2B,1 Swap Sprite<->Buffer addresses
C $6F2D,1 #REGhl=sprite address
C $6F2E,1 #REGc (sprite count) is the important value
C $6F2F,1 Copy the counter back on the stack
C $6F30,1 #REGa=sprite height value
C $6F31,1 Backup "height" to #REGa'
C $6F32,1 #REGhl=start of sprite pixel data
C $6F33,1 #REGhl=buffer, #REGde=sprite
C $6F34,2 Buffer: set first byte
C $6F37,2 Buffer: set sprite width
C $6F39,1 Point Buffer to height variable
C $6F3A,1 Restore #REGa with height value
C $6F3B,4 Jump if height < 17 pixels
C $6F3F,2 else height=16 pixels
C $6F41,1 Buffer: height will be <= 16
C $6F42,1 Point Buffer to start of pixel data
C $6F43,1 #REGb=height variable
C $6F44,3 Write pixel to a buffer
C $6F47,1 Reset #REGbc to be only the sprite counter?
C $6F48,1 #REGhl=start of buffer
C $6F49,4 #REGhl=start of next buffer
C $6F4D,1 #REGde=lookup table address
C $6F4E,1 #REGhl=sprite, #REGde=buffer
C $6F4F,1 #REGhl=sprite width value
C $6F50,1 #REGhl=sprite height value
C $6F51,3 #REGa=Rocket build state - only $00 or $04?
C $6F56,1 Decrement the sprite counter
C $6F57,2 Fetch next sprite address
c $6F5A Create new laser beam.
D $6F5A Find an unused laser beam slot - return if non free - then initialise and draw the laser GFX in the correct location and direction in relation to Jetman. Used by the routine at #R$7492.
R $6F5A Output:HL Address pointing to a free laser beam slot.
@ $6F5A label=LaserNewIfFreeSlot
C $6F5A,6 Return unless one of first two bits of SYSVAR_FRAMES are set
C $6F60,3 #REGhl=laser beam objects
C $6F66,2 Loop counter for all 4 laser beams
C $6F68,1 Get first byte of object
C $6F6A,2 Initialise and draw laser beam, if unused
C $6F6D,2 Repeat until an unused beam is found
C $6F6F,1 Return if no free slots are available
c $6F70 Initialise laser beam slot, and draw graphics.
D $6F70 Used by the routine at #R$6f5a.
R $6F70 Input:HL Address pointing to an unused laser beam.
@ $6F70 label=LaserBeamInit
C $6F70,2 Set first byte to 16: "used"
C $6F72,1 Laser Y position
C $6F73,3 #REGde=Jetman object
C $6F76,2 #REGb=direction in which to draw laser beam, based on Jetman movement action
C $6F79,1 #REGa=Jetman X position
C $6F7E,1 #REGc=laser beam X position
C $6F7F,4 Shoot laser right if Jetman is facing right
C $6F83,2 else shoot laser beam left
C $6F85,1 #REGc=Jetman X position - 8
c $6F86 Draw laser beam.
D $6F86 Used by the routine at #R$6fb6.
R $6F86 Input:C The X Position to start drawing the laser.
R $6F86 DE Jetman object (pointing to X position)
R $6F86 HL Laser beam object to be drawn (pointing to Y position)
@ $6F86 label=LaserBeamDraw
C $6F86,1 Jetman Y position
C $6F87,4 Update the laser beam Y position to align with the middle of the Jetman sprite
C $6F8B,1 Laser X position: pulse #1
C $6F8C,2 Loop counter
C $6F8E,1 Update pulse #1
C $6F92,4 Update the rest of the pulses: #2, #3 and #4
C $6F96,9 Update the laser beam "length" value, using the random_number as a base value
C $6F9F,2 #REGde points to laser beam "colour attribute"
C $6FA1,3 #REGhl=Laser beam colour table
C $6FA4,10 Use random_number to point #REGhl to one of the values in the colour table
C $6FAE,1 Assign laser beam "colour attribute" a new colour
C $6FAF,3 Laser fire SFX
b $6FB2 Laser beam colour attribute table.
@ $6FB2 label=laser_beam_colours
B $6FB2,4,4
c $6FB6 Shoots a laser beam to the right.
D $6FB6 Once position of Jetman's gun is located, we call the draw laser beam routine. Used by the routine at #R$6f70.
R $6FB6 Input:C Jetman X position +/- a few pixels: 0-7 maybe?
R $6FB6 DE Address of Jetman X position variable.
R $6FB6 Output:C New X position of laser beam.
@ $6FB6 label=LaserBeamShootRight
C $6FB6,1 Jetman X position
C $6FB7,2 Checking for any laser beam pixels?
C $6FBA,4 Increment X position if some laser pixels are set
C $6FBE,4 Add 16 and reset bit-0
C $6FC2,1 Set return value
C $6FC3,2 Draw laser beam
c $6FC5 Animate a laser beam.
D $6FC5 Note the copious amounts of register swapping! These annotations need checking.
R $6FC5 Input:IX Laser beam object
@ $6FC5 label=LaserBeamAnimate
C $6FC5,3 Laser Y position
C $6FC8,3 Laser X position: pulse #1
C $6FCB,4 Jump if bit-2 is reset
C $6FCF,1 #REGl=X position: pules #1
C $6FD2,6 Negate (#REGa=$F8) if bit-0 of pulse #1 is reset
C $6FD8,3 #REGh=laser Y position, #REGl=updated X position
C $6FDB,1 Preserve #REGhl - pulse Y,X position
C $6FDC,3 #REGhl=coord to screen address (using #REGhl)
C $6FDF,3 Laser Y position
C $6FE2,4 Jump if Y position >= 128
C $6FE6,1 #REGa=byte at Y,X position of laser pulse #1
C $6FE8,2 Jump if byte is empty
N $6FEA Update the on screen colour for the pulse.
C $6FEA,3 Update X position: pulse #1
C $6FED,2 Add a "full length" pulse to Y,X position
C $6FEF,1 Restores the pulse Y,X positions
C $6FF0,3 #REGhl=coord to attribute file address (using #REGhl)
C $6FF3,4 Set screen colour attribute to the laser pulse colour
C $6FF7,8 Subtract 8 from laser pulse "length"
C $7001,2 Jump if pulse length has bit 3-7 set
N $7003 Update the X position of all the laser beam pulses.
C $7003,4 Reset bit-2 of X position: pulse #1
C $700B,2 Loop counter (14)
C $700E,2 Loop counter (to process pulses #2, #3, #4)
C $7010,3 #REGbc is now the laser beam object
C $7013,1 Laser beam Y position
C $7014,1 Laser beam X position: pulse #1
C $7015,1 Laser beam X position: pulse #2
N $7016 A loop (to the end of routine) which draws the pixel byte to the screen.
C $7016,1 #REGa=X position (loops on pulse #2, #3, #4)
C $7017,3 XOR with X position: pulse #1
C $701C,2 Jump if #REGa has any of these bits set
C $7023,4 Repeat for next X position pulse
C $7027,4 Set laser beam to "unused"
N $702C No pixel to draw, loop back and process next pulse.
N $702F Update the length of the laser beam pulse.
C $702F,1 Laser beam X position
C $7030,4 Jump if bit-2 is set
C $7034,3 Decrement pulse length
C $703A,3 Return if pulse has any pixels set?
C $703D,3 Random number
C $7040,10 Calculate the length of the laser pulse
C $704A,4 Current X position += 4
C $7050,1 #REGl=current X position pulse
C $7053,6 Negate (#REGa=$F8) if bit-0 of pulse is reset
C $705A,1 Update current X position
C $705B,1 #REGh=laser Y position, #REGl=updated X position
C $705C,3 #REGhl=coord to screen address (using #REGhl)
N $7064 Create a new laser beam pixel and merge with current screen pixel.
C $7064,1 Create the pixel byte. E.g. $FC=11111100
C $7065,1 Merge with current screen pixel
C $7066,1 Update display file
C $7067,2 Next X position byte
C $7069,3 Repeat if counter > 0
c $706D Display the remaining player lives in the status bar.
D $706D Used by the routines at #R$6094, #R$6174 and #R$66d0.
@ $706D label=DisplayPlayerLives
C $706D,3 Screen column for Player 1
C $7070,3 #REGhl=coord to screen address (using #REGhl)
C $7073,3 #REGa=Get player 1 lives count
C $7077,2 Display empty space if no lives remaining
C $7079,3 Display lives counter and icon sprite
N $707C Now display lives for inactive player.
C $707C,3 Screen column for Player 2
C $707F,3 #REGhl=coord to screen address (using #REGhl)
C $7082,3 #REGa=Get player 2 lives count
C $7086,2 Display empty space if no lives remaining
N $7088 Displays the lives count and sprite icon.
C $7088,2 ASCII character starting at `0` character
C $708A,3 Display font character
C $708D,3 Sprite for the lives icon
C $7092,3 Now display the number of lives
N $7095 Current player has no lives remaining, display spaces.
C $7095,3 Display " " for no lives
C $7098,2 Display inactive player lives count
N $709A Display just spaces instead of number + sprite.
C $709C,3 Display " " font character
C $70A1,3 Display " " font character
b $70A4 Icon sprite of the little person shown next to number of lives.
@ $70A4 label=tile_life_icon
B $70A4,8,8
c $70AC Gets the remaining lives for player 1.
D $70AC Used for displaying the player lives in the status bar.
R $70AC Output:A Is the number of lives remaining
@ $70AC label=P1GetLifeCount
C $70AC,3 Current player number
C $70B0,2 If not current player, use inactive player
c $70B2 Reads the current player lives.
D $70B2 Used by the routine at #R$70ba.
@ $70B2 label=CurrentPlayerLifeCount
C $70B2,3 Current player lives remaining
c $70B6 Reads inactive player lives.
D $70B6 Used by the routines at #R$70ac and #R$70ba.
@ $70B6 label=InactivePlayerLifeCount
C $70B6,3 Inactive player lives remaining
c $70BA Gets the remaining lives for player 2.
D $70BA Used for displaying the player lives in the status bar.
R $70BA Output:A Is the number of lives remaining
@ $70BA label=P2GetLifeCount
C $70BA,3 Current player number
C $70BE,2 If not current player, use inactive player
C $70C0,2 else get current player lives
c $70C2 Add points to the active player's score.
D $70C2 Used by the routines at #R$63a3, #R$6461, #R$6523, #R$6a35, #R$6beb, #R$6d5c and #R$6d9c.
R $70C2 Input:C The number of points (in decimal) to be added to the score.
@ $70C2 label=AddPointsToScore
C $70C2,6 Use player 2 score if current player is 2
@ $70C8 ssub=ld hl,$5cf4+$02 ; #REGhl=Player 1 score byte #3
@ $70CD ssub=ld hl,$5cf7+$02 ; #REGhl=Player 2 score byte #3
N $70D0 Add the points to the current score.
C $70D0,4 Update score byte #3, with BCD conversion
C $70D5,4 Update score byte #2, with BCD conversion
C $70DA,5 Update score byte #1, with BCD conversion
C $70DF,6 Jump and show player 2 score if current player is 2, else show player 1
c $70E5 Updates display to show player 1 score.
D $70E5 Used by the routine at #R$6064.
@ $70E5 label=ShowScoreP1
C $70E5,3 Screen address for score text
C $70E8,3 3-byte score value
C $70EB,2 Display a score
c $70ED Updates display to show player 2 score.
D $70ED Used by the routines at #R$6064 and #R$70c2.
@ $70ED label=ShowScoreP2
C $70ED,3 Screen address for score text
C $70F0,3 3-byte score value
C $70F3,2 Display a score
c $70F5 Updates display to show high score.
D $70F5 Used by the routine at #R$6064.
@ $70F5 label=ShowScoreHI
C $70F5,3 Screen address for score text
C $70F8,3 3-byte hi score value
c $70FB Display a score.
D $70FB Scores are stored as decimal values in 3-bytes (making 999999 the maximum score). A score of 15,120 decimal is stored in hex as: $01,$51,$20. This routine displays each byte (reading left-to-right) of the score in two steps.
R $70FB Input:HL Screen address of the score to be written.
R $70FB DE The 3-byte score value (P1, P2, HI).
@ $70FB label=DisplayScore
C $70FB,2 Loop counter for the 3 bytes
C $70FD,1 Score value. Example, if 85 points:
C $70FE,1 A=11000010, C=1
C $70FF,1 A=01100001, C=0
C $7100,1 A=10110000, C=1
C $7101,1 A=01011000, C=0
C $7102,2 A=00001000
C $7104,2 A=00111000 - $30 + $08 = ASCII char `8`
C $7106,3 Display font character
C $7109,1 And again with the same byte:
C $710A,2 A=00000101
C $710C,2 A=00110101 - $30 + $05 = ASCII char `5`
C $710E,3 Display font character
C $7111,3 Process next score byte
c $7115 Display an ASCII character from the Font.
D $7115 An ASCII 8x8 tile graphic is fetched from the font data and drawn to the screen. As HL is multiplied by 3 a 256 bytes offset must first be subtracted.
R $7115 Input:A Character (Z80 ASCII) used to fetch the character from the font.
R $7115 HL Screen address where character should be drawn.
R $7115 Output:HL Location for the next location character.
@ $7115 label=DrawFontChar
C $7118,1 #REGl=ASCII value
C $711B,3 Calculate correct offset for ASCII character
@ $711E ssub=ld de,$9ab3-$0100 ; #REGde=base address of the font data - 256 bytes
C $7121,1 #REGhl += base address
C $7122,1 Store the character address in #REGde
C $7123,1 Restore #REGhl
c $7124 Characters are 8 rows of pixels.
D $7124 Used by the routine at #R$706d.
@ $7124 label=DrawCharPixels8Rows
C $7124,2 Loop counter
c $7126 Draw the pixels for an ASCII character on screen
D $7126 Used by the routine at #R$76a6.
R $7126 Input:B Loop counter for no. of pixel rows - is always $08!
R $7126 DE Address for desired character from the font set.
R $7126 HL Display address for where to draw the character.
R $7126 Output:HL Next character location.
@ $7126 label=DrawCharPixels
C $7126,1 Current byte from the font character
C $7127,1 Write byte to screen
C $7128,1 Next row of font pixels
C $7129,1 Next pixel line
C $712A,2 Repeat until 8x8 char displayed
C $712E,4 Reset display line
C $7132,1 Increment column
c $7134 Display string (with colour) on the screen.
D $7134 Calculates the start location in the DISPLAY/ATTRIBUTE files for writing the string, then executes WriteAsciiChars, which writes each individual character to the screen.
R $7134 Input:DE Text data block (expects first byte to be a colour attr).
R $7134 HL Screen address for writing the text.
R $7134 Output:A' Colour attribute for the text.
R $7134 DE' Address to the ASCII characters for displaying.
R $7134 HL' Screen address of next location.
R $7134 HL Attribute file address of next location.
@ $7134 label=DisplayString
C $7134,1 Preserve display file address
C $7135,3 #REGhl=coord to screen address (using #REGhl)
C $7138,2 #REGa'=colour attribute
C $713A,1 #REGde=next colour attribute
C $713C,1 Set #REGhl back to screen address
C $713D,3 #REGhl=coord to attribute file address (using #REGhl)
c $7140 Write a list of ASCII characters to the screen.
D $7140 Used by the routine at #R$62ca.
R $7140 Input:A' Colour byte for the entire string.
R $7140 DE' Address to a list of ASCII character to display.
R $7140 HL' Display file address for writing the string.
R $7140 HL Attribute file address for writing the colour byte.
@ $7140 label=WriteAsciiChars
C $7141,1 #REGa=ASCII character value
C $7142,4 If EOL byte then extract and display character
C $7146,3 Display font character
C $7149,1 Get next character
C $714C,1 Write the colour attribute
C $714D,1 Next column
C $714E,1 Put colour attribute back in #REGa'
C $714F,2 Loop back and display next character
c $7151 Write an EOL character to the screen.
D $7151 Game strings (e.g. score labels) set bit-7 on the last character to indicate it is EOL. This bit needs to be reset before displaying the character on the screen.
R $7151 Input:A' Colour byte for the character.
R $7151 A The EOL ASCII character to be displayed.
R $7151 HL Screen address for writing the string.
R $7151 HL' Attribute file address for writing the colour byte.
@ $7151 label=WriteEOLChar
C $7151,2 Turn off the EOL flag: bit-7
C $7153,3 Display font character
C $7158,1 Write the colour byte
c $715A Displays score labels at top of screen.
D $715A Used by the routine at #R$6064.
@ $715A label=DrawStatusBarLabels
C $715A,9 Display "1UP" text at column 24
C $7163,9 Display "HI" text at column 120
C $716C,9 Display "2UP" text at column 216
b $7175 GFX score labels.
D $7175 As displayed in the status bar - the last char includes an EOL bit ($80). #TABLE(default,centre,:w) { =h Bits(n) | =h Option } { 0 | Colour Attribute } { 1..n | ASCII char, n=EOL bit } TABLE#
@ $7175 label=ScoreLabel1UP
B $7175,4,4 WHITE "1UP" score label
b $7179 Data block at 7179
@ $7179 label=ScoreLabel2UP
B $7179,4,4 WHITE "2UP" score label
b $717D Data block at 717d
@ $717D label=ScoreLabelHI
B $717D,3,3 CYAN  "HI" score label
c $7180 Clears the entire ZX Spectrum display file.
D $7180 Used by the routine at #R$6064.
@ $7180 label=ClearScreen
C $7180,3 Beginning of display file
C $7183,2 MSB to stop at (end of display file)
c $7185 Clear memory block with null.
D $7185 Used by the routine at #R$62fe.
R $7185 Input:B Loop counter: the MSB of the address to stop at.
R $7185 HL Start address to begin filling.
@ $7185 label=ClearMemoryBlock
C $7185,2 Byte to use for the fill
c $7187 Fill a memory block with a byte value.
D $7187 Used by the routine at #R$718e.
R $7187 Input:B Loop counter: the MSB of the address to stop at.
R $7187 C Fill byte.
R $7187 HL Start address to begin filling.
@ $7187 label=MemoryFill
C $7187,1 Write the fill byte
C $718B,2 Repeat until #REGh matches #REGb
c $718E Clears the entire ZX Spectrum attribute file.
D $718E PAPER=black, INK=white.
@ $718E label=ClearAttrFile
C $718E,3 Attribute file
C $7191,2 MSB to stop at (end of attribute file)
C $7193,2 Colour byte: PAPER=black, INK=white, BRIGHT
C $7195,2 Fill memory
c $7197 Colourize a sprite.
D $7197 Using Actor, adds colour to a sprite, working from bottom-to-top, left-to-right. This also handles sprites that are wrapped around the screen. Used by the routines at #R$63a3, #R$64a4, #R$650e, #R$6514, #R$6632, #R$66fc, #R$687a, #R$6d43, #R$6d9c and #R$7492.
R $7197 Input:IX Jetman/Alien object.
@ $7197 label=ColourizeSprite
C $7198,3 #REGhl=actor coords
C $719B,3 #REGhl=coord to attribute file address (using #REGhl)
@ $719E ssub=ld a,($5dc0+$04) ; Actor state "width"
C $71A1,1 #REGb=width loop counter (in pixels)
@ $71A2 ssub=ld a,($5dc0+$03) ; Actor state "height"
C $71AC,1 #REGc=height loop counter (in pixels)
C $71AD,3 #REGd=object colour attribute
C $71B0,1 #REGe=width loop counter (in pixels)
N $71B2 Loop for updating attribute file with colour.
C $71B2,1 #REGa=actor Y position
C $71B3,8 Decrement position if address is outside of attribute file address range
C $71BB,1 Otherwise, set the colour at this location
C $71BC,1 Next tile column
C $71BD,5 Next tile if column < screen width (32 chars)
C $71C2,1 else, wrap-around and continue applying colour
C $71C5,1 #REGl=start of current row
C $71C6,2 Loop back and continue with next tile
N $71C8 Decrement the vertical position and colour the tiles.
C $71CA,1 Clear Carry flag
C $71CB,5 #REGhl -= 32 tiles. Places address pointer previous line
C $71D1,1 #REGb=reset to original width counter
C $71D2,1 Decrement height counter
C $71D3,2 Repeat until all tiles have been coloured
c $71D6 Convert a Y,X pixel coordinate to an ATTRIBUTE_FILE address.
D $71D6 Used by the routines at #R$61a0, #R$61ad, #R$62ca, #R$6fc5, #R$7134, #R$7197 and #R$7638.
R $71D6 Input:H Vertical coordinate in pixels (0-191).
R $71D6 L Horizontal coordinate in pixels (0-255).
R $71D6 Output:HL An address in the attribute file.
@ $71D6 label=Coord2AttrFile
C $71D6,1 Horizontal coordinate. Example, if $B8:
C $71D7,1 A=01011100, C=0
C $71D8,1 A=00101110, C=0
C $71D9,1 A=00010111, C=0
C $71DA,2 A=00010111 <- screen width?
C $71DC,1 #REGl=$17
C $71DD,1 Vertical coordinate. Example, if $68:
C $71DE,1 A=00110100, C=0
C $71DF,1 A=00011010, C=0
C $71E0,1 Backup value to #REGc
C $71E1,2 A=00000000
C $71E3,1 A=00010111
C $71E4,1 #REGl=$17 <- new LSB of attribute file
C $71E5,1 Restore the row value
C $71E6,2 A=00000010 <- top of screen?
C $71E8,2 A=01011010
C $71EA,1 #REGh=$5A <- ATTRIBUTE_FILE address (>= 5800)
C $71EB,1 Return #REGhl=5A17
c $71EC Generic jump routine for finding actor pos/dir.
D $71EC Used by the routines at #R$7232 and #R$726d.
@ $71EC label=JumpActorFindPosDir
C $71EC,3 Find sprite using Actor
c $71EF Get location of Actor.
D $71EF Used by the routines at #R$7226 and #R$7268.
@ $71EF label=GetActorLocation
C $71EF,3 #REGhl=Actor.X/Y position
c $71F2 Get sprite position and dimensions.
D $71F2 Note: the sprite header byte is added to the X position. So the question is: what is this header byte really for? Used by the routine at #R$687a.
R $71F2 Input:DE Address to the start of a Sprite or Buffer.
R $71F2 HL The Y,X coordinate of the sprite.
R $71F2 Output:B Is the sprite width.
R $71F2 C Is always NULL.
R $71F2 HL Screen address of sprite.
R $71F2 DE Address pointing to the pixel data block.
@ $71F2 label=GetSpritePosition
C $71F2,1 #REGa=header value: X position offset?
C $71F3,1 #REGde=next header value: sprite width
C $71F4,2 #REGl=X position + offset
C $71F6,3 #REGhl=coord to screen address (using/returning #REGhl)
C $71F9,2 #REGb=read sprite width again
C $71FB,2 #REGa=next header value: sprite height
@ $71FD ssub=ld ($5dc0+$05),a ; Set Actor height to header height value
c $7200 Increment #REGde to beginning of next sprite header.
D $7200 Used by the routines at #R$71f2 and #R$7207.
@ $7200 label=NextSprite
C $7202,1 #REGde=next header value: sprite data bytes
c $7204 Find actor sprite address and update actor.
D $7204 Used by the routines at #R$7232 and #R$727d.
@ $7204 label=FindActorSpriteAndUpdate
C $7204,3 Find actor position.
c $7207 Update actor state.
D $7207 Get sprite position/dimensions, and update actor. Used by the routines at #R$7226 and #R$7263.
R $7207 Input:DE Address of header block for sprite or buffer data.
R $7207 IX Actor object states: jetman, item, rocket, alien, etc.
R $7207 Output:B Is the sprite width.
R $7207 C Is always NULL.
R $7207 HL Pixel coordinates (Y/X) of the actor
R $7207 DE Start address pointing at the "sprite data" block.
@ $7207 label=ActorUpdate
C $7207,3 #REGl=actor X location
C $720A,3 #REGh=actor Y location
C $720D,1 #REGa=sprite header byte
C $720E,1 #REGde=next header value: sprite width
C $720F,2 #REGl=X column + header byte
C $7211,3 Set actor_coords variable with these actor coordinates
C $7214,3 #REGhl=coord to screen address (using #REGhl)
C $7217,2 #REGb=sprite width
@ $7219 ssub=ld ($5dc0+$04),a ; Actor width=sprite width
C $721C,2 #REGa=next header value: sprite height
@ $721E ssub=ld ($5dc0+$06),a ; Set Actor sprite height
@ $7221 ssub=ld ($5dc0+$03),a ; Set Actor height to sprite height
C $7224,2 Set return values (#REGde points to sprite pixel data)
c $7226 Update Actor X/Y positions.
D $7226 Used by the routines at #R$64a4 and #R$66fc.
@ $7226 label=ActorUpdatePosition
C $7227,3 #REGhl=Get sprite position
C $722C,3 Update actor
C $7230,2 Erase actor sprite
c $7232 Now update and erase the actor.
D $7232 Used by the routines at #R$63a3, #R$650e, #R$6d43, #R$6d9c and #R$7492.
@ $7232 label=UpdateAndEraseActor
C $7232,3 Find sprite using X position and update actor
C $7236,3 Find sprite using actor and get address
c $7239 Erase an actor sprite - after an it's been moved.
D $7239 Used by the routine at #R$7226.
R $7239 Input:IX Actor object.
@ $7239 label=ActorEraseMovedSprite
@ $7239 ssub=ld a,($5dc0+$01) ; #REGa=actor Y position
C $723C,3 Subtract the actor Y position
C $723F,3 Update actor size if 0
C $7242,3 Jump if result is negative
C $7245,1 else #REGc=result
@ $7246 ssub=ld a,($5dc0+$05) ; #REGa=actor current sprite height
C $724A,3 Update actor size if REGa < #REGc
C $724D,1 else subtract #REGc
@ $724E ssub=ld ($5dc0+$05),a ; Update actor current sprite height
C $7251,3 Mask sprite pixels
@ $7258 ssub=ld a,($5dc0+$06) ; #REGa=actor sprite height
C $725C,3 Update actor size if < #REGc
C $7260,3 Erase sprite pixels
c $7263 Find animation sprite position and erase its pixels.
D $7263 Used by the routines at #R$6514, #R$6632 and #R$687a.
@ $7263 label=ActorEraseAnimSprite
C $7263,3 Update the Actor
C $7266,2 Erase sprite pixels
c $7268 Find Actor position, then erase its sprite.
D $7268 Used by the routines at #R$6461 and #R$6632.
@ $7268 label=ActorDestroy
C $7268,3 Get sprite position
C $726B,2 Erase a destroyed actor
c $726D Find an Actor and destroy it.
D $726D Used by the routines at #R$6523, #R$6565, #R$66d0 and #R$687a.
@ $726D label=ActorFindDestroy
C $726D,3 Find sprite and sprite position
c $7270 Erase a destroyed Actor.
D $7270 Used by the routines at #R$687a and #R$7268.
@ $7270 label=ActorEraseDestroyed
@ $7273 ssub=ld ($5dc0+$06),a ; Actor sprite height = $00
@ $7276 ssub=ld ($5dc0+$03),a ; Actor "height" = $00
C $727A,3 Mask sprite pixels
c $727D Unused?
c $7280 Erase an animation sprite.
D $7280 Used by the routine at #R$7263.
@ $7280 label=EraseAnimationSprite
@ $7282 ssub=ld ($5dc0+$05),a ; Actor current sprite height = $00
C $7285,1 #REGc = $00
C $7286,3 Mask sprite pixels
c $7289 Find position and direction of an Actor.
D $7289 Used by the routine at #R$71ec.
@ $7289 label=ActorFindPosDir
C $7289,3 #REGa=actor X position
@ $728F ssub=ld a,($5dc0+$02) ; #REGa=actor movement direction
c $7292 Get actor sprite address.
D $7292 Used by the routine at #R$72ab.
R $7292 Input:A Sprite header byte or Actor movement.
R $7292 C Sprite header byte or X position.
R $7292 Output:DE Address for sprite.
@ $7292 label=ActorGetSpriteAddress
C $7294,2 Jump if bit-6 of header is reset
C $7296,2 else set bit-3 of X position
C $7298,8 Calculate offset for sprite lookup table
C $72A1,2 #REGbc=lookup table offset
C $72A3,3 #REGhl=start of Jetman/Buffer sprite lookup tables
C $72A7,3 #REGde=sprite address
c $72AB Move an actor's sprite to it's current position.
D $72AB The IX register can point to one of the actor object types: `jetman_direction`, `item_state`, or one of the 6 `alien_states`.
D $72AB Used by the routine at #R$7204.
R $72AB Input:IX actor object.
@ $72AB label=ActorMoveSprite
C $72AB,3 #REGa=X position
C $72B1,3 #REGa=sprite header byte
C $72B4,2 Get sprite address
c $72B6 Calculate screen address one pixel above current position.
D $72B6 Calculates the new address for writing a sprite pixel, in an upward direction, taking into consideration the screen memory layout.
D $72B6 Used by the routine at #R$7705.
R $72B6 Input:HL Current position.
R $72B6 Output:HL Address for new position.
@ $72B6 label=ScreenPosOnePixelAbove
C $72B6,1 Decrement #REGh to move up one pixel on screen
C $72BA,2 Has a character line been crossed?
C $72BC,1 If not, return
C $72BD,4 else subtract 32 from #REGl
C $72C3,2 Has a new section of the screen been crossed?
C $72C5,1 Return if not
i $72CB Unused code.
c $72D0 Convert a Y,X pixel coordinate to a DISPLAY_FILE address.
D $72D0 Used by the routines at #R$62ca, #R$6fc5, #R$706d, #R$7134, #R$71f2, #R$7207 and #R$7638.
R $72D0 Input:H Vertical position in pixels (0-191).
R $72D0 L Horizontal position in pixels (0-255).
R $72D0 Output:HL An address in the display file.
@ $72D0 label=Coord2Scr
C $72D0,1 Horizontal coordinate. Example, if $B8:
C $72D1,1 A=01011100, C=0
C $72D2,1 A=00101110, C=0
C $72D3,1 A=00010111, C=0
C $72D4,2 A=00010111 <- screen width?
C $72D6,1 #REGl=$17
C $72D7,1 Vertical coordinate. Example, if $68:
C $72D8,1 A=00110100, C=0
C $72D9,1 A=00011010, C=0
C $72DA,2 A=00000000
C $72DC,1 A=00010111
C $72DD,1 #REGl=$17 <- new LSB of attribute file
C $72DE,1 Vertical coordinate. Example, if $68:
C $72DF,2 A=00000100
C $72E1,1 Puts the value into the shadow register
C $72E2,1 Vertical coordinate. Example, if $68:
C $72E3,1 A=00110100, C=0
C $72E4,1 A=00011010, C=0
C $72E5,1 A=00001101, C=0
C $72E6,2 A=00001000
C $72E8,2 A=00101000
C $72EA,1 #REGhl=$48
C $72EB,1 Get the shadow register value
C $72EC,1 A=00101100
C $72ED,1 #REGh=$4C <- DISPLAY_FILE address (>= 4000)
C $72EE,1 Return #REGhl=4C68
c $72EF Copy actor position/direction values to Actor.
D $72EF Used by the routines at #R$6461, #R$64e8, #R$6523, #R$6690, #R$66b4, #R$66d0, #R$687a, #R$6cb0, #R$6d9c, #R$739e and #R$753c.
R $72EF Input:IX Jetman object.
@ $72EF label=ActorUpdatePosDir
C $72EF,6 Actor X position = Jetman X position
@ $72F8 ssub=ld ($5dc0+$01),a ; Actor Y position = Jetman Y position
@ $72FE ssub=ld ($5dc0+$02),a ; Actor movement = Jetman direction
c $7302 Joystick Input (Interface 2)
D $7302 The ROM cartridge was made for the Interface 2 which reads the Joystick I bits in the format of 000LRDUF, which are mapped to the keyboard keys: 6, 7, 8, 9, and 0. Note that a reset bit means the button is pressed.
D $7302 Used by the routines at #R$7309, #R$733f, #R$735e and #R$743e.
R $7302 Output:A Joystick direction/button state.
@ $7302 label=ReadInterface2Joystick
C $7302,2 Interface 2 Joystick port
C $7306,2 #REGa = bits for 000LRDUF
c $7309 Read input from the keyboard port.
D $7309 Used by the routines at #R$739e and #R$753c.
R $7309 Output:A direction values $EF (L), $F7 (R) or $FF for no input detected - like joystick: 000LRDUF.
@ $7309 label=ReadInputLR
C $7309,3 Game options
C $730C,2 Use Joystick?
C $730E,2 Jump if so
N $7310 Read bottom-left row of keys.
C $7310,2 Row: Shift,Z,X,C,V
C $7312,2 Set port for reading keyboard
C $7314,2 ...and read that row of keys
C $7318,2 Check if any keys on the row are pressed
C $731A,2 Jump if not - read inputs again
C $731C,2 Reset all bits except X and V keys (RIGHT keys)
C $731E,2 Check if neither are pressed (reset)
C $7320,2 If so, a LEFT key was pressed: Z and C
C $7322,2 else RIGHT key was pressed: X and V
N $7324 Read bottom-right row of keys.
C $7324,2 Row: B,N,M.Sym,Sp
C $7326,2 Set port for reading keyboard
C $7328,2 ...and read that row of keys
C $732C,2 Check if any keys on the row are pressed
C $732E,2 Jump if not - no input detected.
C $7330,2 Reset all bits except B and M keys (LEFT keys)
C $7332,2 Check if neither are pressed (reset)
C $7334,2 If so, a RIGHT key was pressed: N and Sym
C $7336,2 #REGa=LEFT_KEY  : 1110 1111
C $7339,2 #REGa=RIGHT_KEY : 1111 0111
C $733C,2 #REGa=No input detected
c $733F Check if fire button is pressed.
D $733F Used by the routine at #R$7492.
R $733F Output:A fire button, $FE = pressed, $FF = no input - like joystick: 000LRDUF.
@ $733F label=ReadInputFire
C $733F,3 Game options
C $7342,2 Use Joystick?
C $7344,2 Jump if so
C $7346,2 Loop count: read left and right row of keys
C $7348,2 Row: A,S,D,F,G
C $734A,2 Set port for reading keyboard
C $734C,2 ...and read that row of keys
C $7350,2 Check if any keys on the row are pressed
C $7352,2 Jump if so - key press detected
C $7354,2 Row: H,J,K,L,Enter
C $7356,2 Loop back and read input again
C $7358,2 Still no input detected
C $735B,2 #REGa=FIRE : 1111 1110
c $735E Check if thrust (up) button is pressed.
D $735E Used by the routines at #R$7412 and #R$753c.
R $735E Output:A thrust button, $FE = pressed, $FF = no input - like joystick: 000LRDUF.
@ $735E label=ReadInputThrust
C $735E,3 Game options
C $7361,2 Use Joystick?
C $7363,2 Jump if so
C $7365,2 Loop count: read left and right row of keys
C $7367,2 Row: Q,W,E,R,T
C $7369,2 Set port for reading keyboard
C $736B,2 ...and read that row of keys
C $736F,2 Check if any keys on the row are pressed
C $7371,2 Jump if so - key press detected
C $7373,2 Row: Y,U,I,O,P
C $7375,2 Loop back and read input again
C $7377,2 Still no input detected
C $737A,2 #REGa=UP (thrust) : 1111 1101
c $737D Game play starts, or prepare new turn, or check Jetman thrust input.
@ $737D label=GamePlayStarts
C $737D,7 If begin play delay timer is zero (turn started), check to see if player is thrusting
C $7384,1 else decrement timer
C $7385,3 Flash Score label if still not zero
C $7388,3 SFX to indicate play is about to start!
C $738B,6 Stop flashing 2UP if current player number is 2
C $7391,6 Stop flashing "1UP" text
C $7397,2 Check if player is thrusting
C $7399,5 Stop flashing "2UP" text
c $739E Airborne Jetman update.
D $739E Read thrust/direction controls and update position accordingly. Used by the routine at #R$737d.
R $739E Input:IX Jetman object.
@ $739E label=JetmanFlyThrust
C $739E,3 Update actor position direction
C $73A1,3 Read Left/Right input
C $73A4,5 Update Jetman direction for THRUST RIGHT
C $73A9,5 Jetman thrust left
C $73AE,3 Game timer
C $73B1,4 If bit-0 is reset, fly horizontal
C $73B5,3 Calculate new horizontal speed
C $73B8,4 Set Jetman direction to be "right"
C $73BC,7 Flip direction if currently moving left
c $73C3 Increase Jetman horizontal speed.
D $73C3 Used by the routine at #R$7501.
R $73C3 Input:IX Jetman object.
@ $73C3 label=JetmanFlyIncSpdX
C $73C3,3 Jetman speed modifier ($00 or $04)
C $73CA,3 #REGa += Jetman X speed
C $73CF,2 Jump if speed >= max
c $73D1 Update Jetman X speed with new value.
D $73D1 Used by the routines at #R$750c and #R$752d.
@ $73D1 label=JetmanFlySetSpdX
C $73D1,3 Update Jetman X speed with #REGa (will be < 64)
C $73D4,2 Fly horizontally
c $73D6 Set Jetman X speed to the max flying speed.
D $73D6 Used by the routine at #R$73c3.
@ $73D6 label=JetmanFlySetMaxSpdX
c $73DA Fly Jetman horizontally.
D $73DA Used by the routines at #R$739e, #R$73d1 and #R$750c.
R $73DA Input:IX Jetman object.
R $73DA Output:H New X position.
R $73DA L New Thrust value.
@ $73DA label=JetmanFlyHorizontal
C $73DC,3 Jetman X speed (will be <= 64)
C $73DF,3 Multiply X speed by 3
C $73E2,3 #REGd=Jetman X position
@ $73E5 ssub=ld a,($5dc0+$07) ; Actor thrust
C $73E9,7 Decrease Jetman X position if moving right
C $73F0,1 else, increase X position
c $73F1 Apply gravity to Jetman if no thrust button detected.
D $73F1 Used by the routine at #R$74fa.
R $73F1 Input:IX Jetman object.
R $73F1 H New X position.
R $73F1 L New Thrust value.
@ $73F1 label=JetmanApplyGravity
@ $73F2 ssub=ld ($5dc0+$07),a ; Update Actor thrust
C $73F5,3 Set new Jetman X position
N $73F8 Check if thruster is being aplpied
C $73F8,3 Game options
C $73FB,5 Use Joystick? Jump if so.
N $7400 Induce a slight pause before reading keys - this is required so that the gravity kicks in. It also acts as an undocumented hover key.
C $7400,2 Loop count: read left and right row of keys
C $7402,2 Read top-right row of keys
C $7404,2 Set port for reading keyboard
C $7406,2 ...and read that row of keys
C $740A,2 Check if any keys on the row are pressed
C $740C,2 Jump if so - hover Jetman
C $740E,2 Read top-left row of keys
C $7410,2 ...and repeat
c $7412 Check if Jetman is moving falling downward.
D $7412 Used by the routine at #R$743e.
@ $7412 label=JetmanFlyCheckFalling
C $7412,3 Check if THRUST button pressed (Joystick or Keys)
C $7415,5 Set Jetman to down position if not thrusting
C $741A,8 Jetman direction is DOWN or WALKing
C $7422,3 Flip vertical direction if moving down
c $7425 Increase Jetman vertical speed.
D $7425 Used by the routine at #R$74d5.
@ $7425 label=JetmanSpeedIncY
C $7425,3 Jetman speed modifier ($00 or $04)
C $742C,3 #REGa += Jetman Y speed
C $7431,2 Set vertical speed to max if >= 63
c $7433 Update Jetman vertical speed with new value.
D $7433 Used by the routine at #R$74e0.
@ $7433 label=JetmanSetSpdY
C $7433,3 Y speed = #REGa (is < 63)
C $7436,2 Update vertical flying
c $7438 Set Jetman vertical speed to zero.
D $7438 Used by the routines at #R$73f1 and #R$743e.
@ $7438 label=JetmanSetZeroSpdY
C $7438,4 Jetman Y speed is zero
C $743C,2 Update vertical flying
c $743E Check joystick input for FIRE or THRUST.
D $743E Used by the routine at #R$73f1.
@ $743E label=JetmanFlyCheckThrusting
C $743E,3 Read Joystick
C $7441,5 Set Y speed to zero if not thrusting
C $7446,2 else check if falling and update movement
c $7448 Set Jetman vertical speed to maximum.
D $7448 Used by the routine at #R$7425.
@ $7448 label=JetmanSetMaxSpdY
C $7448,4 Set Jetman Y speed to 63
c $744C Fly Jetman vertically.
D $744C Used by the routines at #R$7433, #R$7438 and #R$74e0.
R $744C Input:IX Jetman object.
@ $744C label=JetmanFlyVertical
C $744C,3 #REGl=Jetman Y speed (will be <= 63)
C $7451,3 Multiply vertical X speed by 3
C $7454,3 #REGd=Jetman Y position
C $7457,4 #REGe=Jetman flying counter
C $745B,7 Move Jetman up if moving up
C $7462,1 else move downwards
c $7463 Check vertical position while in mid-flight.
D $7463 Used by the routine at #R$7526.
@ $7463 label=JetmanFlyCheckPosY
C $7463,4 Update Jetman flying counter
C $7467,3 Update Jetman Y position
C $746D,2 Move up if within screen limits: 42 to 192
C $7471,2 Check if hit top of screen
c $7473 Jetman flight collision detection.
D $7473 Used by the routines at #R$74bf and #R$74c5.
R $7473 Input:IX Jetman object.
@ $7473 label=JetmanCollision
C $7473,3 Platform collision detection (returns #REGe)
C $7476,4 Redraw Jetman if bit-2 has not been set
C $747A,5 Jetman lands on top of a platform
C $747F,4 Jetman hits bottom of a platform
N $7483 Jetman hits platform edge.
C $7484,5 Update #REGe to be either $00 or $40.
C $7489,9 Update Jetman moving direction
c $7492 Redraw Jetman sprite on the screen.
D $7492 Every time this function is called, a check is also made to see if the player is pressing the fire button, and draws a laser beam if so.
@ $7492 label=JetmanRedraw
C $7492,3 Update and erase the actor
C $7495,3 Colour the sprite
C $7498,3 Read the input for a FIRE button
C $749D,3 If pressed, Fire laser (if free slot is available)
c $74A1 Jetman hits the underneath of a platform.
D $74A1 Used by the routine at #R$7473.
@ $74A1 label=JetmanBumpsHead
C $74A1,4 Set Jetman to be moving down
C $74A5,2 Redraw Jetman
c $74A7 Jetman lands on a platform.
D $74A7 Used by the routine at #R$7473.
@ $74A7 label=JetmanLands
C $74A7,4 Set Jetman to be standing still
C $74AB,3 Jetman direction
C $74AE,2 Reset FLY and WALK bits
C $74B0,2 Now set movement to WALK
C $74B2,3 Update Jetman direction to be walking
C $74B5,4 Set Jetman X speed to stopped
C $74B9,4 Set Jetman Y speed to stopped
C $74BD,2 Redraw Jetman
c $74BF Reset Jetman movement direction.
D $74BF Used by the routine at #R$7463.
@ $74BF label=JetmanSetMoveUp
C $74BF,4 Set Jetman to be moving up
C $74C3,2 Jetman flight collision detection
c $74C5 Jetman hits the top of the screen.
D $74C5 Used by the routine at #R$7463.
@ $74C5 label=JetmanHitScreenTop
C $74C5,4 Set Jetman to be moving down
C $74C9,3 Jetman Y speed
C $74CE,2 Jetman collision detection if #REGa was $00 or $01
C $74D0,3 Update Jetman Y speed
C $74D3,2 Jetman flight collision detection
c $74D5 Jetman is falling.
D $74D5 Used by the routine at #R$7412.
@ $74D5 label=JetmanSetMoveDown
C $74D5,4 Set Jetman direction to WALK/DOWN
C $74D9,7 Increment Jetman Y speed if moving down
c $74E0 Flip vertical direction Jetman is flying.
D $74E0 Used by the routine at #R$7412.
@ $74E0 label=JetmanDirFlipY
C $74E0,3 Jetman speed modifier ($00 or $04)
C $74E3,2 #REGa=$F8 or $FC
C $74E5,3 #REGa += Jetman Y speed
C $74E8,3 Update vertical speed if new speed is positive
C $74EB,4 else set Y speed to zero
C $74EF,8 Flip Jetman vertical moving direction
C $74F7,3 Fly Jetman vertically
c $74FA Decrease Jetman X position.
D $74FA Used by the routine at #R$73da.
@ $74FA label=JetmanFlyDecreasePosX
C $74FA,1 Reset Carry flag
C $74FE,3 Update Jetman speed/dir if thrusting
c $7501 Jetman THRUST-LEFT input.
D $7501 Used by the routine at #R$739e.
@ $7501 label=JetmanFlyThrustLeft
C $7501,4 Set Jetman direction to be LEFT
C $7505,7 Increase Jetman X speed if moving RIGHT
c $750C Flip Jetman left/right flying direction.
D $750C Used by the routine at #R$739e.
@ $750C label=JetmanDirFlipX
C $750C,3 Jetman speed modifier ($00 or $04)
C $750F,2 #REGa=$F8 or $FC
C $7511,3 #REGa += Jetman X speed
C $7514,3 Update horizontal speed if new speed is positive
C $7517,4 else set X speed to zero
C $751B,8 Flip Jetman left/right moving direction
C $7523,3 Fly Jetman vertically
c $7526 Move Jetman up: decrease Y position.
D $7526 Used by the routine at #R$744c.
@ $7526 label=JetmanFlyMoveUp
C $7526,1 Reset Carry flag
C $7528,2 Move upwards
C $752A,3 Check vertical position within screen limits
c $752D Calculate new Jetman horizontal speed.
D $752D Used by the routine at #R$739e.
@ $752D label=JetmanFlyCalcSpeedX
C $752D,3 Jetman speed modifier ($00 or $04)
C $7530,2 #REGa=$F8 or $FC
C $7532,3 #REGa += Jetman X speed
C $7535,3 Update horizontal speed if new speed is positive
C $7539,3 Update horizontal speed to zero
c $753C Jetman walking.
R $753C Input:IX Jetman object.
@ $753C label=JetmanWalk
C $753C,3 Update Actor position direction
C $753F,3 Read Left/Right input
C $7542,4 Walk RIGHT
C $7546,5 Walk LEFT
C $754B,4 else set Jetman X speed to zero
C $754F,3 Read THRUST button
C $7552,4 Walk off platform if thrusting
C $7556,3 Platform collision check (returns #REGe)
C $7559,4 Leave platform if bit-2 is reset
C $755D,5 Redraw Jetman if bit-3 is reset
C $7562,3 Jetman X speed
C $7566,3 Redraw Jetman if X speed > 0
C $7569,22 Jetman leaves a platform, either left or right based on the value of bit-6. The X position is dec/inc appropriately, and the Redraw Jetman routine is called. Note also that the X speed is set to max walking speed, but this instruction might be irrelevant as hacking the speed value has no noticeable effect.
N $757F Jetman leaves a platform by thrusters or by walking.
@ $757F label=JetmanWalkOffPlatform
C $757F,3 Jetman direction
C $7582,2 Reset FLY and WALK bits
C $7584,2 Now set movement to FLY
C $7586,3 Update Jetman direction to be flying
C $7589,3 #REGhl=Jetman Y,X position
C $758E,4 #REGix=Jetman thruster animation object
C $7592,6 Jump if thrusters are already being animated
C $7598,4 else set thrusters to be animating?
@ $759C ssub=ld ($5d48+$01),hl ; Update thruster animation Y,X position
C $759F,3 Update actor movement states
C $75A2,2 Restore #REGix to Jetman object
C $75A4,6 Jetman Y position -= 2
C $75AA,3 Redraw Jetman
N $75AD Jetman walks right.
C $75AD,3 Jetman X position += 1
C $75B0,4 Jetman direction is right
C $75B4,4 Jetman moving direction to right
C $75B8,4 Set Jetman X speed to maximum
C $75BC,3 Loop back, checking again for THRUST input
N $75BF Jetman walks left.
C $75BF,3 Jetman X position -= 1
C $75C2,4 Jetman direction is left
C $75C6,4 Jetman moving direction to left
C $75CA,4 Set Jetman X speed to maximum
C $75CE,3 Loop back, checking again for THRUST input
c $75D1 Related to horizontal platform collision detection - possibly flipping between sprite X position collision and Jetman direction collision...needs more work!
D $75D1 Used by the routine at #R$75ed.
R $75D1 Input:A Sprite X position minus Platform X position?
R $75D1 IX Jetman or alien.
C $75D2,3 Jetman/alien direction
C $75D5,2 Value must be <= 63
C $75D7,4 Jump if value == 3 (therefore never when Jetman)
C $75DB,1 Restore #REGa to entry value
C $75DC,2 Vertical collision detection
C $75DE,1 Flip again
C $75E1,7 Vertical collision detection, first incrementing by $09 if #REGa is negative
c $75E8 Jetman/platform collision detection.
D $75E8 NOTE: collision detection is location based not pixel/colour based, so even if platform tiles are not drawn, a collision will be detected! Used by the routines at #R$63a3, #R$6461, #R$64e8, #R$6a35, #R$6ab8, #R$6bf8, #R$6cd7, #R$6d9c, #R$7473 and #R$753c.
R $75E8 Input:IX Jetman or Alien object.
R $75E8 Output:E Collision state.
@ $75E8 label=JetmanPlatformCollision
C $75E8,2 Loop counter (4 platforms to check)
C $75EA,3 Platform location/size params
c $75ED Horizontal platform collision detection for Jetman/Alien.
D $75ED Used by the routine at #R$75fc.
R $75ED Input:HL Address of platform object.
R $75ED IX Jetman or Alien object.
@ $75ED label=JetmanPlatformCollisionX
C $75F0,2 #REGa=Platform X position
C $75F2,3 Subtract Jetman/Alien X position
C $75F5,3 If positive, Horizontal collision detection
C $75FA,2 Set bit-6 and then vertical collision detection
c $75FC Vertical platform collision detection for Jetman/Aliens.
D $75FC Used by the routine at #R$75d1.
R $75FC Input:A Sprite X position.
R $75FC E Collision state on entry.
R $75FC HL Address of platform object.
R $75FC IX Jetman/Alien object.
R $75FC Output:E Collision state. Bit: 7=landed, 4=hits head, 3=?, 2=?.
@ $75FC label=JetmanPlatformCollisionY
C $75FC,1 Platform Y location
C $75FD,1 Platform width
C $75FE,4 X position >= width (no collision) so try next platform
C $7604,6 Set bit 3 if collision: X position >= width
C $760A,1 Platform Y location
C $760B,1 #REGa=platform Y position
C $760C,3 Subtract sprite Y position
C $7611,2 Add 2
C $7613,3 Next platform if no collision: Y position is negative
C $7616,4 #REGa < 2, Landed on platform
C $761A,5 #REGa < sprite height, hits underneath of platform?
C $761F,2 Subtract 2
C $7621,5 Next platform if no collision: Y position >= sprite height
N $7626 Jetman hits the bottom of a platform
C $7628,2 Set bit-2 (4) <- Jetman is leaving a platform?
C $762A,1 Set #REGhl back to beginning of platform object
C $762C,2 Bit-7 indicates landing on a platform
C $7630,1 Set #REGhl back to beginning of platform object
C $7631,4 Increment #REGhl until is points to the start of the next platform sprite
C $7635,2 Loop back until all 4 platforms have been checked
c $7638 Displays platforms on screen.
D $7638 Used by the routine at #R$6094.
@ $7638 label=DrawPlatforms
C $7638,2 Loop counter (4 platforms for draw)
C $763A,3 Platform location/size params
C $763D,1 Backup loop counter
C $763E,5 Process next platform if sprite colour is black/unused
C $7643,2 #REGc=X position
C $7647,1 #REGa=platform width
C $764C,1 #REGa += platform X position
C $764D,2 #REGa += 16
C $7650,2 #REGh=Y position byte
C $7652,1 #REGl=new X position
C $7653,3 #REGhl=coord to screen address (using #REGhl)
C $7656,3 #REGde=address for LEFT platform sprite
C $7659,3 Draw LEFT platform tile pixels
C $765C,9 Does this fetch the platform width value?
C $7665,1 #REGb=loop counter for # of middle platform sprites
C $7666,3 #REGde=address for MIDDLE platform sprite
C $7669,5 Draw (all) MIDDLE platform tiles pixels
C $766E,3 #REGde=address for RIGHT platform sprite
C $7671,3 Draw RIGHT platform tile pixels
C $7675,1 #REGa=platform width
C $767A,1 #REGa += X position
C $767B,2 #REGa += 16
C $767E,2 #REGb=Y position
C $7680,3 #REGc=colour attribute
C $7683,2 #REGhl=Y,X position
C $7686,3 #REGhl=coord to attribute file address (using #REGhl)
C $768A,9 Does this fetch the platform width value?
C $7693,1 #REGb=loop counter for # of middle platform sprites
C $7694,2 Apply platform colour to ATTRIBUTE_FILE
C $7696,1 #REGhl=next sprite position
C $7697,2 Repeat until all sprites are coloured
C $7699,1 Restore #REGhl=platform object at "width" byte
C $769A,1 #REGhl=beginning of next platform struct
C $769B,1 Restore #REGbc for loop counter
C $769C,2 Loop back and processing next platform
N $769E These instructions are only called if current platform colour was black. Why would a platform colour be black?
C $769E,1 restore loop counter
C $769F,4 Place #REGhl to beginning of next platform struct
C $76A3,2 Loop back and process next platform
c $76A6 Draws the pixels for a platform sprite to the screen.
D $76A6 Used by the routine at #R$7638.
@ $76A6 label=DrawPlatformTile
C $76A8,2 Loop counter (8x8 pixel)
C $76AA,3 Draw character pixels for tile
b $76AD Platform sprite: left.
@ $76AD label=tile_platform_left
B $76AD,8,8
b $76B5 Platform sprite: middle (repeated for width).
@ $76B5 label=tile_platfor_mmiddle
B $76B5,8,8
b $76BD Platform sprite: right.
@ $76BD label=tile_platform_right
B $76BD,8,8
w $76C5 Sprite/Buffer lookup tables.
D $76C5 The following 3 lookup tables must remain together as they are all accessed via this first label. Lookup table for the Jetman sprite GFX addresses.
@ $76C5 label=sprite_lookup_tables
@ $76C5 label=jetman_sprite_table
W $76C5,2,2 fly right 1
W $76C7,2,2 fly right 2
W $76C9,2,2 fly right 3
W $76CB,2,2 fly right 4
W $76CD,2,2 fly left 4
W $76CF,2,2 fly left 3
W $76D1,2,2 fly left 2
W $76D3,2,2 fly left 1
W $76D5,2,2 walk right 1
W $76D7,2,2 walk right 2
W $76D9,2,2 walk right 3
W $76DB,2,2 walk right 4
W $76DD,2,2 walk left 4
W $76DF,2,2 walk left 3
W $76E1,2,2 walk left 2
W $76E3,2,2 walk left 1
w $76E5 Lookup table for the alien sprites buffer addresses.
@ $76E5 label=buffers_aliens_lookup_table
W $76E5,2,2 right facing, anim frame 1
W $76E7,2,2 right facing, anim frame 1
W $76E9,2,2 right facing, anim frame 2
W $76EB,2,2 right facing, anim frame 2
W $76ED,2,2 left facing,  anim frame 2
W $76EF,2,2 left facing,  anim frame 2
W $76F1,2,2 left facing,  anim frame 1
W $76F3,2,2 left facing,  anim frame 1
N $76F5 Lookup table for the item sprites buffer addresses.
@ $76F5 label=buffers_items_lookup_table
W $76F5,2,2 sprite 1
W $76F7,2,2 sprite 2
W $76F9,2,2 sprite 3
W $76FB,2,2 sprite 4
W $76FD,2,2 sprite 4
W $76FF,2,2 sprite 3
W $7701,2,2 sprite 2
W $7703,2,2 sprite 1
c $7705 Erase sprite pixels when actor/sprite moves.
D $7705 Used by the routines at #R$7239, #R$7270, #R$7280 and #R$775b.
R $7705 Input:B Loop counter.
R $7705 C Actor Y position, or zero?
R $7705 DE Address into a sprite/buffer.
R $7705 HL Address in the DISPLAY_FILE.
R $7705 Output:BC is this the unchanged input value?
R $7705 HL is this the unchanged input value?
@ $7705 label=MaskSprite
C $7705,4 Jump if vertical position is zero
C $7709,1 else decrement
N $770C Loop to create a mask of the sprite and it write to the screen.
C $770C,1 #REGa=sprite byte
C $770D,3 Create mask and write to screen
C $7710,1 Next byte
C $7711,1 Next column
C $7715,6 If column is zero, subtract 32
C $771B,2 Repeat and process for next byte
C $771D,1 Restore #REGhl to be the display file address
C $771E,3 Calculate new pixel position
C $7722,1 NOTE: what is in C' register before this swap?
C $7723,4 Jump back to the top of routine if #REGc is zero
C $7727,1 else decrement (vertical position?)
N $772A Merging sprite with current on-screen sprite (the mask?)
C $772A,3 Merge with current on-screen byte (mask?)
C $772D,1 Next sprite byte
C $772F,1 #REGa=next column number
C $7732,6 Set #REGl to beginning of line if > 0 && < 32, and repeat process for next byte
C $7738,2 Repeat and process next byte
N $773A Calculate position for next pixel location
C $773B,3 Calculate new pixel position
C $7740,2 Loop back to top of routine
C $7743,4 Jump if #REGc != 0
c $7747 EXX then update Actor.
D $7747 Used by the routine at #R$7239.
@ $7747 label=ActorUpdateSizeFlipReg
c $7748 Update Actor height related values.
D $7748 Used by the routine at #R$7239.
@ $7748 label=ActorUpdateSize
@ $7748 ssub=ld a,($5dc0+$05) ; Actor current sprite height
@ $774C ssub=ld a,($5dc0+$06) ; Actor sprite height
C $774F,1 Compare actor sprite height values
C $7750,1 Return if both are zero
@ $7752 ssub=ld ($5dc0+$05),a ; Actor current sprite height = $00
@ $7756 ssub=ld a,($5dc0+$06) ; Actor sprite height
c $775B Update Actor sprite height, then mask the sprite.
D $775B Used by the routine at #R$7239.
@ $775B label=ActorUpdateHeightAndMask
@ $775B ssub=ld ($5dc0+$06),a ; Update Actor sprite height
C $775F,2 Mask sprite pixels
> $7761 ; Actor/Collectible sprites start with a 3-byte header.
> $7761 ;
> $7761 ; +----------+--------------------+
> $7761 ; | Bytes(n) | Definition         |
> $7761 ; +----------+--------------------+
> $7761 ; | 0        | X position offset? |
> $7761 ; | 1        | Width (tiles)      |
> $7761 ; | 2        | Height (pixels)    |
> $7761 ; | 3...     | Pixel data         |
> $7761 ; +----------+--------------------+
b $7761 Jetman sprite for flying right #1.
@ $7761 label=gfx_jetman_fly_right1
B $7761,1,1 Header byte
B $7762,2,2 Width (tiles), Height (pixels)
B $7764,8,8 Pixel data follows
B $776C,40,8
b $7794 Jetman sprite for flying right #2.
@ $7794 label=gfx_jetman_fly_right2
B $7794,75,1,2,8
b $77DF Jetman sprite for flying right #3.
@ $77DF label=gfx_jetman_fly_right3
B $77DF,75,1,2,8
b $782A Jetman sprite for flying right #4.
@ $782A label=gfx_jetman_fly_right4
B $782A,75,1,2,8
b $7875 Jetman sprite for flying left #1.
@ $7875 label=gfx_jetman_fly_left1
B $7875,51,1,2,8
b $78A8 Jetman sprite for flying left #2.
@ $78A8 label=gfx_jetman_fly_left2
B $78A8,51,1,2,8
b $78DB Jetman sprite for flying left #3.
@ $78DB label=gfx_jetman_fly_left3
B $78DB,75,1,2,8
b $7926 Jetman sprite for flying left #4.
@ $7926 label=gfx_jetman_fly_left4
B $7926,75,1,2,8
b $7971 Jetman sprite for walking left #1.
@ $7971 label=gfx_jetman_walk_left1
B $7971,51,1,2,8
b $79A4 Jetman sprite for walking left #2.
@ $79A4 label=gfx_jetman_walk_left2
B $79A4,51,1,2,8
b $79D7 Jetman sprite for walking left #3.
@ $79D7 label=gfx_jetman_walk_left3
B $79D7,75,1,2,8
b $7A22 Jetman sprite for walking left #4.
@ $7A22 label=gfx_jetman_walk_left4
B $7A22,75,1,2,8
b $7A6D Jetman sprite for walking right #1.
@ $7A6D label=gfx_jetman_walk_right1
B $7A6D,51,1,2,8
b $7AA0 Jetman sprite for walking right #2.
@ $7AA0 label=gfx_jetman_walk_right2
B $7AA0,51,1,2,8
b $7AD3 Jetman sprite for walking right #3.
@ $7AD3 label=gfx_jetman_walk_right3
B $7AD3,75,1,2,8
b $7B1E Jetman sprite for walking right #4.
@ $7B1E label=gfx_jetman_walk_right4
B $7B1E,75,1,2,8
b $7B69 Meteor sprite #1.
@ $7B69 label=gfx_meteor1
B $7B69,23,1,8*2,6
b $7B80 Meteor sprite #2.
@ $7B80 label=gfx_meteor2
B $7B80,23,1,8*2,6
b $7B97 Explosion sprite: BIG.
@ $7B97 label=gfx_explosion_big
B $7B97,51,1,2,8
b $7BCA Explosion sprite: MEDIUM.
@ $7BCA label=gfx_explosion_medium
B $7BCA,51,1,2,8
b $7BFD Explosion sprite: SMALL.
@ $7BFD label=gfx_explosion_small
B $7BFD,51,1,2,8
b $7C30 U3 Rocket ship sprite: bottom.
@ $7C30 label=gfx_rocket_u3_bottom
B $7C30,35,1,2,8
b $7C53 U3 Rocket ship sprite: middle.
@ $7C53 label=gfx_rocket_u3_middle
B $7C53,35,1,2,8
b $7C76 U3 Rocket ship sprite: top.
@ $7C76 label=gfx_rocket_u3_top
B $7C76,35,1,2,8
b $7C99 U1 Rocket ship sprite: bottom.
@ $7C99 label=gfx_rocket_u1_bottom
B $7C99,35,1,2,8
b $7CBC U1 Rocket ship sprite: middle.
@ $7CBC label=gfx_rocket_u1_middle
B $7CBC,35,1,2,8
b $7CDF U1 Rocket ship sprite: top.
@ $7CDF label=gfx_rocket_u1_top
B $7CDF,35,1,2,8
b $7D02 U5 Rocket ship sprite: bottom.
@ $7D02 label=gfx_rocket_u5_bottom
B $7D02,35,1,2,8
b $7D25 U5 Rocket ship sprite: middle.
@ $7D25 label=gfx_rocket_u5_middle
B $7D25,35,1,2,8
b $7D48 U5 Rocket ship sprite: top.
@ $7D48 label=gfx_rocket_u5_top
B $7D48,35,1,2,8
b $7D6B U4 Rocket ship sprite: bottom.
@ $7D6B label=gfx_rocket_u4_bottom
B $7D6B,35,1,2,8
b $7D8E U4 Rocket ship sprite: middle.
@ $7D8E label=gfx_rocket_u4_middle
B $7D8E,35,1,2,8
b $7DB1 U4 Rocket ship sprite: top.
@ $7DB1 label=gfx_rocket_u4_top
B $7DB1,35,1,2,8
b $7DD4 Gold bar collectible sprite.
@ $7DD4 label=gfx_gold_bar
B $7DD4,19,1,2,8
b $7DE7 Fuel pod sprite.
@ $7DE7 label=gfx_fuel_pod
B $7DE7,25,1,2,8*2,6
b $7E00 Radiation collectible sprite.
@ $7E00 label=gfx_radiation
B $7E00,25,1,2,8*2,6
b $7E19 Chemical weapon collectible sprite.
@ $7E19 label=gfx_chemical_weapon
B $7E19,29,1,2,8*3,2
b $7E36 Plutonium collectible sprite.
@ $7E36 label=gfx_plutonium
B $7E36,21,1,2,8*2,2
b $7E4B Diamond collectible sprite.
@ $7E4B label=gfx_diamond
B $7E4B,27,1,2,8
> $7E66 ; Alien sprites start with a 1-byte header, and are always 16 pixels wide.
> $7E66 ;
> $7E66 ; +----------+-----------------+
> $7E66 ; | Bytes(n) | Definition      |
> $7E66 ; +----------+-----------------+
> $7E66 ; | 0        | Height (pixels) |
> $7E66 ; | 1...     | Pixel data      |
> $7E66 ; +----------+-----------------+
b $7E66 Squidgy Alien sprite #1.
@ $7E66 label=gfx_squidgy_alien1
B $7E66,1,1 Height (pixels)
B $7E67,8,8 Pixel data follows
B $7E6F,20,8*2,4
b $7E83 Squidgy Alien sprite #2.
@ $7E83 label=gfx_squidgy_alien2
B $7E83,29,1,8*3,4
b $7EA0 Jet Plane sprite.
@ $7EA0 label=gfx_jet_fighter
B $7EA0,15,1,8,6
b $7EAF Flying Saucer sprite.
@ $7EAF label=gfx_ufo
B $7EAF,17,1,8
b $7EC0 Sphere alien sprite #1.
@ $7EC0 label=gfx_sphere_alien1
B $7EC0,33,1,8
b $7EE1 Sphere alien sprite #2.
@ $7EE1 label=gfx_sphere_alien2
B $7EE1,29,1,8*3,4
b $7EFE Crossed Space craft sprite.
@ $7EFE label=gfx_cross_ship
B $7EFE,31,1,8*3,6
b $7F1D Space craft sprite.
@ $7F1D label=gfx_space_craft
B $7F1D,29,1,8*3,4
b $7F3A Frog Alien sprite.
@ $7F3A label=gfx_frog_alien
B $7F3A,29,1,8*3,4
b $7F57 Rocket Flame sprite #1.
@ $7F57 label=gfx_rocket_flames1
B $7F57,35,1,2,8
b $7F7A Rocket Flame sprite #2.
@ $7F7A label=gfx_rocket_flames2
B $7F7A,35,1,2,8
i $7F9D Unused bytes.
b $7FB3 Jetpac loading screen image
D $7FB3 #UDGTABLE { #SCR(1,,,,,32691,38835)(splash) | Splash screen data. } TABLE#
@ $7FB3 label=loading_screen
B $7FB3,6912,16
b $9AB3 ZX Spectrum font sprites.
@ $9AB3 label=system_font
B $9AB3,480,8
i $9C93 Unused.
