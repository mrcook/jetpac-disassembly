> $5CCB ; SkoolKit disassembly for JETPAC (cartridge)
> $5CCB ; (https://github.com/mrcook/jetpac-disassembly)
> $5CCB ;
> $5CCB ; Copyright (c) 2018 Michael R. Cook (this disassembly)
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
  $5CCB,37,$25
b $5CF0 High score for current game session.
D $5CF0 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF0 label=hi_score
S $5CF0,3,$03
b $5CF3 Game options.
D $5CF3 #TABLE(default,centre,:w) { =h Bits(n) | =h Option } { 0 | Players (reset=1, set=2) } { 1 | Input Type (reset=Keyboard, set=Joystick) } TABLE#
@ $5CF3 label=game_options
  $5CF3,1,1
b $5CF4 Player one score.
D $5CF4 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF4 label=p1_score
S $5CF4,3,$03
b $5CF7 Player two score.
D $5CF7 A 3-byte decimal representation of the score. Maximum value is 999999.
@ $5CF7 label=p2_score
S $5CF7,3,$03
s $5CFA Padding to make block from hi_score to here 16 bytes in length.
  $5CFA,6,$06
b $5D00 Jetman direction.
D $5D00 Indicates the direction that Jetman is travelling/facing. #TABLE(default,centre,:w) { =h Byte | =h Bits | =h Direction } { 82 | 10000010 | WALK RIGHT } { C2 | 11000010 | WALK LEFT } { 01 | 00000001 | FLY UP RIGHT (default) } { 41 | 01000001 | FLY UP LEFT } { 81 | 10000001 | FLY DOWN RIGHT } { C1 | 11000001 | FLY DOWN LEFT } TABLE#
@ $5D00 label=jetman_direction
  $5D00,1,1
b $5D01 Jetman X position.
D $5D01 Default start position is $80.
@ $5D01 label=jetman_pos_x
  $5D01,1,1
b $5D02 Jetman Y position.
D $5D02 Default start position is $B7.
@ $5D02 label=jetman_pos_y
  $5D02,1,1
b $5D03 Jetman sprite colour attribute.
D $5D03 Initialised to $47 on new player.
@ $5D03 label=jetman_colour
  $5D03,1,1
b $5D04 Jetman moving direction.
D $5D04 Indicates the direction in which Jetman is moving. #TABLE(default,centre,:w) { =h Bits(n) | =h Direction } { 6 | 0=right, 1=left } { 7 | 0=up/standing still, 1=down } { 1 | ? } { 0 | 0=horizontal, 1=vertical } TABLE#
@ $5D04 label=jetman_moving
  $5D04,1,1
b $5D05 Jetman Speed: Horizontal.
D $5D05 Max Walking: $20. Max Flying: $40.
@ $5D05 label=jetman_speed_x
  $5D05,1,1
b $5D06 Jetman Speed: Vertical.
D $5D06 Max: $3F.
@ $5D06 label=jetman_speed_y
  $5D06,1,1
b $5D07 Jetman sprite height, which is always $24, as set by the defaults.
@ $5D07 label=jetman_height
  $5D07,1,1
b $5D08 Laser beams
D $5D08 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Unused=$00, Used=$10 } { 1 | Y Position } { 2 | X position pulse #1 } { 3 | X position pulse #2 } { 4 | X position pulse #3 } { 5 | X position pulse #4 } { 6 | Beam length } { 7 | Colour attribute } TABLE#
@ $5D08 label=laser_beam_params
  $5D08,8,8 laser beam #1
  $5D10,8,8 laser beam #2
  $5D18,8,8 laser beam #3
  $5D20,8,8 laser beam #4
b $5D28 Sound type parameters for explosions.
D $5D28 Byte 1=Frequency, byte 2=Duration.
@ $5D28 label=explosion_sfx_params
  $5D28,1,1 Frequency is $0C or $0D
  $5D29,1,1 Length is always set to $04
b $5D2A Explosion params padding, making 8 bytes total. Unused.
S $5D2A,6,$06
b $5D30 Rocket state object.
D $5D30 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Movement: $09=on pad, $0A=up, $0B=down } { 1 | X Position (pixels) } { 2 | Y Position (pixels) - Rocket base } { 3 | Colour Attribute } { 4 | State: can be $00 or $01 (default) } { 5 | Fuel Pods collected: 0-6 } { 6 | Unused } { 7 | Always $1C } TABLE#
@ $5D30 label=rocket_state
  $5D30,8,8
b $5D38 Rocket module state (fuel/part).
D $5D38 NOTE: Used for top module at level start, then only fuel pods. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Type: $00=Unused, $04=Ship/Fuel Pod } { 1 | X Position (pixels) } { 2 | Y Position (pixels) } { 3 | Colour Attribute } { 4 | State: 1=new, 3=collected, 5=free-fall, 7=dropped } { 5 | Unused } { 6 | Sprite jump table offset } { 7 | Sprite Height } TABLE#
@ $5D38 label=rocket_module_state
  $5D38,8,8
b $5D40 Current Collectible object.
D $5D40 Used for the middle ship module at level start, then only collectibles. The "state" field is not used for collectibles (remains $00). #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Type: $00=Unused, $04=Rocket, $0E=Collectible } { 1 | X Position (pixels) } { 2 | Y Position (pixels) } { 3 | Colour Attribute } { 4 | State: 1=new, 3=collected, 5=free-fall, 7=dropped } { 5 | Unused } { 6 | Sprite jump table offset } { 7 | Sprite Height } TABLE#
@ $5D40 label=item_state
  $5D40,8,8
b $5D48 Thruster/Explosion animation sprite state.
D $5D48 Holds the sprite state for the current animation frame being displayed for Jetman's jetpac thruster "smoke". Note: each animation loop uses a (random) two colour pair from the 4 possible colours. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Animating: 00=no, 03=anim done, 08=animating } { 1 | Last Jetman X location } { 2 | Last Jetman Y location } { 3 | Colour: Red, Magenta, Yellow, White } { 4 | Frame: 0-7 } { 5 | Unused } { 6 | Unknown (set to $03 on first use) } { 7 | Unused } TABLE#
@ $5D48 label=jetman_thruster_anim_state
  $5D48,8,8
b $5D50 Alien state objects.
D $5D50 There are a maximum of 6 aliens on the screen at one time, and those states are stored here in this data block. See Jetman object for more details. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 00 | Direction } { 01 | X location (pixels) } { 02 | Y location (pixels) } { 03 | Colour attribute } { 04 | Moving direction } { 05 | X Speed (default: $04) } { 06 | Y Speed } { 07 | Sprite Height } TABLE#
@ $5D50 label=alien_states
  $5D50,8,8 slot #1
  $5D58,8,8 slot #2
  $5D60,8,8 slot #3
  $5D68,8,8 slot #4
  $5D70,8,8 slot #5
  $5D78,8,8 slot #6
b $5D80 Jetman exploding animation object.
D $5D80 Holds the sprite state for the current animation frame being displayed for the explosion sprite when Jetman is killed. Note: each animation loop uses a (random) two colour pair from the 4 possible colours. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | Animating: 00=no, 08=yes } { 1 | Jetman X location (pixels) } { 2 | Jetman Y location (pixels) } { 3 | Colour: Red, Magenta, Yellow, White } { 4 | Frame: 0-7 } { 5 | State (set=animating) } { 6 | Jetman direction } { 7 | Unused } TABLE#
@ $5D80 label=jetman_exploding_anim_state
  $5D80,8,8
b $5D88 Jetman object backup for the inactive player.
@ $5D88 label=inactive_jetman_state
  $5D88,8,8
b $5D90 Unused padding.
S $5D90,8,$08
b $5D98 Rocket/collectible object backup for the inactive player.
@ $5D98 label=inactive_rocket_state
  $5D98,8,8 Rocket object
  $5DA0,8,8 Rocket module (fuel/part)
  $5DA8,8,8 Collectible/Rocket middle
b $5DB0 Unused padding.
S $5DB0,8,$08
b $5DB8 Unused padding.
S $5DB8,8,$08
b $5DC0 Temporary actor state.
D $5DC0 Many actor routines use this to hold state temporarily during updates. #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 0 | X location } { 1 | Y location } { 2 | Movement direction } { 3 | Height (pixels) } { 4 | Width (tiles) } { 5 | Current sprite height value (?) } { 6 | Sprite GFX data height value (?) } { 7 | Unknown flying movement/direction (used only for Jetman?) } TABLE#
@ $5DC0 label=actor
  $5DC0,8,8
b $5DC8 Value only changes while Jetman is moving up/down - has no obvious pattern.
@ $5DC8 label=jetman_fly_counter
  $5DC8,1,1
b $5DC9 Alien direction update flag for: Squidgy, UFO, Sphere, Crossed Ship.
D $5DC9 Each alien update routine first resets the value, then after the first check, increments the value, which triggers the draw alien routine.
@ $5DC9 label=alien_new_dir_flag
  $5DC9,1,1
b $5DCA Jetman speed modifier.
D $5DCA Initialised to $04 by initialise game routine, otherwise value is $00 during game play.
@ $5DCA label=jetman_speed_modifier
  $5DCA,1,1
b $5DCB Current alien ID being updated?
D $5DCB Values are $00 (no alien update?) up to the max number of aliens: $01 to $06. Used by all alien update routines and in a few other places.
@ $5DCB label=current_alien_number
  $5DCB,1,1
w $5DCC Game timer.
D $5DCC 16-bit counter starting at 0x0000 and counting +1 (each time a sprite is moved or redrawn?), although sometimes it will increment +2. This continues until the whole game is over - for both 1 and 2 player games. Counter loops around after reaching 0xFFFF.
@ $5DCC label=game_timer
  $5DCC,2,2
b $5DCE Random Number.
D $5DCE Value is calculated using the 16-bit game timer LSB value, which is used to fetch a byte from the ROM (between addresses $00 and $FF), then by adding the current #REGr.
@ $5DCE label=random_number
  $5DCE,1,1
b $5DCF Temporary actor coordinates.
D $5DCF Coordinates (Y,X) used when colouring a sprite. Set by the Actor, along with being inc/decremented during the Rocket launch/land phase.
@ $5DCF label=actor_coords
  $5DCF,1,1 Y location (pixels)
  $5DD0,1,1 X location (pixels)
b $5DD1 Current active player.
D $5DD1 $00=player #1, $FF=player #2.
@ $5DD1 label=current_player_number
  $5DD1,1,1
b $5DD2 Jetman Rocket module attached success.
D $5DD2 Set to $01 at the start of each new life/level. When one of the two modules becomes attached to the Rocket (top or middle, but not fuel) then this is changed to $00.
@ $5DD2 label=jetman_rocket_mod_connected
  $5DD2,1,1
b $5DD3 Rocket modules attached.
D $5DD3 Set to $04 at the start of each new level. When one of the two modules becomes attached to the Rocket (top or middle, but not fuel) then this is changed to $02.
@ $5DD3 label=rocket_mod_attached
  $5DD3,1,1
b $5DD4 Holds a copy of the last SYSVAR_FRAMES counter.
@ $5DD4 label=last_frame
  $5DD4,1,1
b $5DD5 Interrupt state
D $5DD5 $00=enabled, $01=disabled.
@ $5DD5 label=interrupt_state
  $5DD5,1,1
b $5DD6 Current menu item colour attribute.
@ $5DD6 label=current_colour_attr
  $5DD6,1,1
b $5DD7 "Get Ready" delay timer.
D $5DD7 At the beginning of each player turn there is a delay to allow the player to be ready for play. Values are $80 for a 1 player game, $FF for a two player game. The larger delay is useful for swapping players controls.
@ $5DD7 label=begin_play_delay_counter
  $5DD7,1,1
s $5DD8 Unused padding.
  $5DD8,24,$18
b $5DF0 Game level for current player.
D $5DF0 Level #1 starts at $00.
@ $5DF0 label=player_level
  $5DF0,1,1
b $5DF1 Current player lives remaining.
@ $5DF1 label=player_lives
  $5DF1,1,1
b $5DF2 Unused padding for player level/lives object (8 bytes total).
  $5DF2,6,6
b $5DF8 Game level for inactive player.
D $5DF8 Level #1 starts at $00.
@ $5DF8 label=inactive_player_level
  $5DF8,1,1
b $5DF9 Inactive player lives remaining.
@ $5DF9 label=inactive_player_lives
  $5DF9,1,1
b $5DFA Unused padding for inactive player level/lives object (8 bytes total).
  $5DFA,6,6
b $5E00 Buffers for Alien sprites.
D $5E00 #TABLE(default,centre,:w) { =h Bytes(n) | =h Meaning } { $00     | Header byte - always NULL? } { $01     | Width value - always $03 } { $02     | Height value } { $03-$33 | Pixel data } TABLE#
@ $5E00 label=buffer_alien_r1
@ $5E33 label=buffer_alien_r2
@ $5E66 label=buffer_alien_l1
@ $5E99 label=buffer_alien_l2
S $5E00,204,$33
b $5ECC Buffers for Collectible/Rocket sprites.
D $5ECC #TABLE(default,centre,:w) { =h Bytes(n) | =h Meaning } { $00     | Header byte } { $01     | Width value - always $03? } { $02     | Height value } { $03-$33 | Pixel data } TABLE#
@ $5ECC label=buffer_item_r1
@ $5EFF label=buffer_item_r2
@ $5F32 label=buffer_item_l1
@ $5F65 label=buffer_item_l2
S $5ECC,204,$33
s $5F98 Unused padding.
  $5F98,107,$6b
c $6000 Entry address after copying data from cartridge.
b $6003 Platform GFX location and size.
D $6003 #TABLE(default,centre,:w) { =h Bytes(n) | =h Variable } { 1 | Colour Attribute } { 2 | X location (pixels) } { 3 | Y location (pixels) } { 4 | Width } TABLE#
@ $6003 label=gfx_params_platforms
  $6003,4,4 Middle
  $6007,4,4 Bottom
  $600B,4,4 Left
  $600F,4,4 Right
b $6013 Default player object state.
@ $6013 label=default_player_state
  $6013,8,8
b $601B Default Rocket and module objects state.
@ $601B label=default_rocket_state
  $601B,8,8 Rocket state
  $6023,8,8 Top module state
  $602B,8,8 Middle module state
b $6033 Default Rocket module state is a Fuel Pod.
@ $6033 label=default_rocket_module_state
  $6033,8,8
b $603B Default collectible item state.
@ $603B label=default_item_state
  $603B,8,8
b $6043 Main menu copyright message.
@ $6043 label=menu_copyright
  $6043,1,1 Text colour attribute
  $6044,1,1 Font code for © symbol
T $6045,30,30
  $6063,1,1 ASCII "D" & $80 (EOL)
c $6064 Reset the screen to its default state.
D $6064 Used by the routines at #R$6094, #R$60b7 and #R$61c9.
@ $6064 label=ResetScreen
  $6065,2 Set screen border to black
  $6067,3 Clear the screen
  $606A,3 Reset the screen colours
  $606D,3 Display score labels
N $6070 Display score labels text at the top of the screen.
  $6070,3 #REGhl=attribute file location
  $6073,3 #REGb=tile count, and #REGc=yellow colour
  $6076,4 Now set the tile colours
  $607A,3 Update display with player 1 score
  $607D,3 Update display with player 2 score
  $6080,3 Update display with high score
c $6083 Initialises a new level.
D $6083 A new Rocket is generated every 4 levels, otherwise it's a normal fuel collecting level. Used by the routines at #R$62fe and #R$6690.
@ $6083 label=LevelNew
  $6083,5 Check if player level is a MOD of 4?
  $6088,2 If not, initialise the level normally
N $608A Initialisation for a new rocket level.
  $608A,3 Reset all rocket modules with defaults
  $608D,4 Jetman has boarded the rocket; increment lives count. Used for display purposes only
  $6091,3 Initialise the player for the next level
c $6094 Initialise the level.
D $6094 Used by the routines at #R$6083 and #R$60b7.
@ $6094 label=LevelInit
  $6094,3 Initialise alien buffers
  $6097,3 Initialise the screen
  $609A,3 Draw the platforms
  $609D,3 Display all player lives
  $60A0,6 Set last_frame to current SYSVAR_FRAMES
c $60A7 Reset all rocket module states to their defaults.
D $60A7 Set object data to their defaults and copy to buffers. Used by the routines at #R$6083 and #R$62da.
@ $60A7 label=RocketReset
  $60A7,3 #REGhl=default rocket data
  $60AA,3 #REGde=start of rocket structs
  $60AD,3 24 bytes of rocket data to copy
  $60B4,3 Copy sprite data to the buffers.
c $60B7 End of turn for the current player.
D $60B7 Resets level states/buffers, and checks if it's game over for a player. Used by the routine at #R$687a.
@ $60B7 label=PlayerTurnEnds
  $60B7,3 #REGhl=Jetman thruster animation object
  $60BA,5 Reset all object states to be inactive
@ $60BF ssub=ld hl,$5d38+$04 ; #REGhl=Rocket module "state" field
  $60C2,2 Set to unused state
@ $60C4 ssub=ld hl,$5d40+$04 ; #REGhl=Collectible item "state" field
  $60C7,2 Set to unused state
N $60C9 Check if current and inactive player has lives, if not it is game over.
  $60C9,3 Game Options
  $60CE,2 Jump if two player
  $60D0,3 Current player lives
  $60D4,3 Game over if no lives remaining
  $60D7,3 Initialise a new level
  $60DA,3 Initialise next player
  $60DD,3 Inactive player lives
  $60E1,2 Game over if no lives remaining
  $60E3,3 Current player lives
  $60E7,3 Game over if no lives remaining
  $60EA,3 Switch players
  $60ED,7 Change current player (flip bits between $00 and $FF)
N $60F4 Switch rocket objects data for this new player
@ $60F4 ssub=ld a,($5d30+$04) ; Rocket module "state" field
  $60F7,5 Calculate the offset
  $60FC,3 Copy rocket sprite to buffer
  $60FF,3 Initialise level
  $6102,3 Initialise player
N $6105 Display the GAME OVER message for a player.
  $6105,2 ASCII character for the number "1" + EOL bit
@ $6107 ssub=ld ($6161+$12),a ; Append the number to game over text
  $610A,3 Initialise level screen
  $610D,3 Game Over message
@ $6110 keep
  $6110,3 Y,X coords in the display file
  $6113,3 Draw text to the screen
N $6116 After displaying the text, pause for a while.
N $6123 Handle message for player #2.
  $6123,2 ASCII character for the number "2" + EOL bit
  $6125,2 Append the number to the text, the display it
N $6127 Choose which player to show Game Over message for.
  $6127,6 Jump if current player is #1
  $612D,2 else, player is #2.
N $612F Game Over: update scores, show game over message, and initialise system.
  $612F,3 Update the high score
  $6132,6 Jump if current player is #2
  $6138,3 Display game over for player #1
  $613B,3 Reset the game
  $613E,3 Display game over for player #2
  $6141,3 Reset the game
c $6144 Swap current/inactive player/rocket states.
D $6144 Used by the routines at #R$60b7 and #R$62da.
@ $6144 label=PlayersSwap
  $6144,3 Current player level/lives
  $6147,3 Inactive player level/lives
  $614C,3 Swap 2 bytes
N $614F Now swap the current/inactive rocket states.
  $614F,3 Current player rocker state
  $6152,3 Inactive player rocker state
  $6155,2 We will be swapping 24 bytes
N $6157 Sub-routine for swapping HL/DE bytes.
b $6161 Text for game over message.
@ $6161 label=game_over_text
  $6161,1,1 Colour attribute
T $6162,17,17
  $6173,1,1 Player # (ASCII $31/$32) + $80 (EOL)
c $6174 Initialise player for new turn.
D $6174 Player has died, or started a new level, so Jetman object should be updated with default values. Used by the routines at #R$6083, #R$60b7 and #R$66b4.
@ $6174 label=PlayerInit
  $6174,3 Default Jetman values
  $6177,3 Jetman object
N $617F Set default "begin play" delay period.
  $617F,2 1 player delay
  $6181,3 Game options
  $6186,2 Jump if one player game
  $6188,2 else, double delay for 2 player game
  $618A,3 Update delay: 1 Player=$80, 2 Player=$FF
N $618D Decrement current player lives and update display.
  $618D,3 Current player lives
  $6194,3 Display player lives
c $6197 Flash 1UP or 2UP score label for active player.
D $6197 Used by the routine at #R$737d.
@ $6197 label=ScoreLabelFlash
  $6197,3 Current player number
  $619B,2 If player #2, flash 2UP text
  $619D,3 else #REGhl=1UP column position in attr file
c $61A0 Set flash state for the 3-attributes of the score label.
D $61A0 Used by the routine at #R$61ba.
R $61A0 Input:HL screen coordinate.
@ $61A0 label=FlashText
  $61A0,3 #REGhl=coord to attribute file address (using #REGhl)
  $61A3,2 Loop counter for 3 characters
  $61A5,7 Set FLASH on for each attribute
c $61AD Turn off flashing of 1UP or 2UP score label for active player.
D $61AD Used by the routine at #R$737d.
R $61AD Input:HL screen coordinate.
@ $61AD label=ScoreLabelUnflash
  $61AD,3 #REGhl=coord to attribute file address (using #REGhl)
  $61B0,2 Loop counter for 3 characters
  $61B2,7 Set FLASH=off on for each attribute
c $61BA Flash 2UP score label.
D $61BA Used by the routine at #R$6197.
  $61BA,3 2UP column position in attribute file
c $61BF Game initialisation for first run.
D $61BF Reset all scores, sets the SP, initialises the screen, and displays the main menu. Used by the routine at #R$6000.
@ $61BF label=StartGame
  $61BF,10 Reset all scores
c $61C9 Reset system and show menu screen.
D $61C9 Used by the routine at #R$60b7.
@ $61C9 label=ResetGame
  $61C9,1 Disable interrupts
@ $61CA ssub=ld sp,$5ccb+$25 ; Set the stack pointer
  $61CD,3 Reset the screen
  $61D2,3 Reset Speed modifier to its default
c $61D5 Show menu screen and handle menu selection.
@ $61D5 label=MenuScreen
  $61D5,3 Draw the menu entries
N $61D8 Read the keyboard and perform menu selection.
  $61D8,4 #REGd=Game options
  $61DE,2 Disable NMI?
  $61E0,2 Read the keyboard
  $61E2,1 Invert all bit in #REGa (same as XORing A with $FF)
  $61E3,2 Key #1 pressed? ("1 PLAYER GAME")
  $61E5,2 No key pressed? Jump
  $61E7,2 else, Player count = 1
  $61E9,2 Key #2 pressed? ("2 PLAYER GAME")
  $61EB,2 No key pressed? Jump
  $61ED,2 else, Player count = 2
  $61EF,2 Key #3 pressed? ("KEYBOARD")
  $61F1,2 No key pressed? Jump
  $61F3,2 else, Input type = keyboard
  $61F5,2 Key #4 pressed? ("JOYSTICK")
  $61F7,2 No key pressed? Jump
  $61F9,2 else, Input type = joystick
  $61FB,5 Key #5 pressed? ("START GAME")
  $6200,4 Update the Game options
N $6204 Update flashing state of the menu items.
@ $6204 ssub=ld hl,$6261+$01
  $6204,3 Point #REGhl to main menu colour attributes list.
  $6207,4 #REGc=Game options
  $620B,4 Jump if player count = 2
  $620F,3 Set flashing state for a one player game
  $6212,4 Jump if input type = joystick
  $6216,3 Set flashing state for keyboard input
  $6219,3 Loop and process again main menu input
  $621C,3 Set flashing state for a two player game
  $621F,2 Check input type
  $6221,3 Set flashing state for joystick input
  $6224,2 Loop and process again menu selection
N $6226 Set flashing state for "1 PLAYER GAME" and "KEYBOARD" menu items.
N $622D Set "2 PLAYER GAME" and "JOYSTICK" menu items flashing.
c $6234 Display the main menu items to the screen.
D $6234 Used by the routine at #R$61d5.
@ $6234 label=MenuDrawEntries
  $6234,3 Point #REGde to main menu colour attributes
  $6238,3 #REGhl'=Y (y-position of the menu item)
  $623B,3 #REGde'=to the beginning of the menu strings
  $623E,2 #REGb'=loop counter for the 6 colour attribute bytes
N $6240 Flip-flop between normal/shadow registers: meaning one time we hit this EXX we are using the shadow registers, the next the normal registers.
  $6241,1 #REGa=current colour attribute
  $6242,3 Store menu colour attribute
  $624C,2 #REGl'=indentation
  $624E,3 Write line of text to screen
  $6255,2 Duel purpose loop: both colour attrs and menu items
@ $6257 keep
  $6257,3 Note: address is past 7FFF limit of 16K ZX Spectrum
  $625A,3 Point #REGde to the copyright string
  $625D,3 Now display the copyright message
b $6261 Colour attributes for main menu.
D $6261 #TABLE(default,centre,:w) { =h Bytes(n) | =h Menu Item } { 1 | Jetpac Game Selection } { 2 | 1 Player Game } { 3 | 2 Player Game } { 4 | Keyboard } { 5 | Joystick } { 6 | Start Game } TABLE#
@ $6261 label=menu_colour_table
  $6261,6,6
b $6267 Vertical position of each line of text in the main menu.
D $6267 #TABLE(default,centre,:w) { =h Byte(n) | =h Menu Item } { 1 | Jetpac Game Selection } { 2 | 1 Player Game } { 3 | 2 Player Game } { 4 | Keyboard } { 5 | Joystick } { 6 | Start Game } TABLE#
@ $6267 label=menu_position_table
  $6267,6,6
t $626D Text displayed on the main menu screen
@ $626D label=menu_text
  $626D,20,20
B $6281,1,1 ASCII "N" & $80 (EOL)
  $6282,16,16
B $6292,1,1 ASCII "E" & $80 (EOL)
  $6293,16,16
B $62A3,1,1 ASCII "E" & $80 (EOL)
  $62A4,11,11
B $62AF,1,1 ASCII "D" & $80 (EOL)
  $62B0,11,11
B $62BB,1,1 ASCII "K" & $80 (EOL)
  $62BC,13,13
B $62C9,1,1 ASCII "E" & $80 (EOL)
c $62CA Write a single line of text on the main menu screen.
D $62CA Used by the routine at #R$6234.
R $62CA Input:HL Coordinate on the screen to display the string.
@ $62CA label=MenuWriteText
  $62CA,1 Backup coordinate
  $62CB,3 #REGhl=coord to screen address (using #REGhl)
  $62CE,3 Current colour attribute
  $62D3,1 Restore coordinate
  $62D4,3 #REGhl=coord to attribute file address (using #REGhl)
  $62D7,3 Display text string at #REGhl, using #REGa' colour
c $62DA Reset current and inactive player data on new game.
D $62DA Used by the routine at #R$62fe.
@ $62DA label=ResetPlayerData
  $62DA,2 Loop counter: current then inactive player
  $62DE,3 Reset player level
  $62E3,3 First player has 4 "remaining" lives
  $62E6,3 Reset the rocket modules
  $62E9,3 Swap player game states
  $62ED,2 Repeat again for inactive player
  $62EF,5 But now update inactive player to have 5 "remaining" lives, not 4
  $62F4,3 Game options
  $62F9,1 Return if two player game
  $62FA,3 else one player game, so inactive player has no lives
c $62FE Start a new game.
D $62FE Resets all player, alien, and level data, then start a new game. Used by the routine at #R$61d5.
@ $62FE label=NewGame
  $62FE,3 Starting at the Player 1 score
@ $6301 nowarn
  $6301,3 To #REGbc address-1 (779 bytes) with a $00 value (#REGc)
  $6307,3 Reset the player data
  $630A,3 Reset the self-modifying code
  $630D,3 Initialise a new level
c $6310 Reset stack pointer and enable interrupts.
D $6310 Used by the routine at #R$6971.
@ $6310 label=ResetStack
@ $6310 ssub=ld sp,$5ccb+$25 ; Set the stack pointer
  $6314,4 #REGix=Rocket object
  $6319,3 Reset current alien number
c $631C Main loop.
D $631C Used by the routines at #R$692e and #R$6971.
@ $631C label=MainLoop
  $631C,8 Compare SYSVAR_FRAMES and last_frame
  $6324,3 Call self-modifying code routine if they don't match
@ $6327 nowarn
  $6327,3 #REGhl points to generate new item routine
  $632A,1 Used as return address in several routines
  $632B,3 #REGhl=main jump table
  $632E,4 #REGa=Rocket "movement" field, used to calculate jump table offset?
  $6332,2 Make sure it can only be a power of 2
c $6334 Performs a jump.
D $6334 Used by the routine at #R$648b.
R $6334 Input:A Offset for jump table address.
R $6334 HL Address to the jump table.
@ $6334 label=PerformJump
  $6334,1 #REGa should be max of 34 (size of jump table)
  $6337,1 Add offset to base address
  $6338,4 #REGhl=jump address
  $633C,1 Execute the jump!
w $633D Main game loop jump table.
D $633D Holds addresses for all the main routines that need updating per game loop.
@ $633D label=main_jump_table
  $633D,2,2 Game Delay Loop
  $633F,2,2 Jetman Fly
  $6341,2,2 Jetman Walk
  $6343,2,2 Meteor Update
  $6345,2,2 Collision Detection
  $6347,2,2 Crossed Space Ship Update
  $6349,2,2 Sphere Alien Update
  $634B,2,2 Jet Fighter Update
  $634D,2,2 Animate Explosion
  $634F,2,2 Rocket Update
  $6351,2,2 Rocket Take off
  $6353,2,2 Rocket Landing
  $6355,2,2 SFX Explosion: Alien
  $6357,2,2 SFX Explosion: Player
  $6359,2,2 Check Item Collected
  $635B,2,2 UFO Update
  $635D,2,2 Animate Laser Beam
  $635F,2,2 Squidgy Alien Update
c $6361 Update the high score.
D $6361 If one of the players score is a new max score, then update the high score with that of the player with the highest score. Used by the routine at #R$60b7.
@ $6361 label=UpdateHiScore
  $6361,3 #REGhl=player 1 score
  $6364,4 #REGde=player 2 score
  $6368,3 Swap the P1 LSB/MSB values so we can perform calculations on them.
  $636B,3 Swap the P2 LSB/MSB values so we can perform calculations on them
  $636E,1 Reset the Carry flag
  $6371,2 Jump if score P2 > P1, else
  $6373,2 Jump if score P1 > P2, else P1==P2, so no jump
@ $6375 ssub=ld a,($5cf4+$02)
  $6375,4 #REGe=3rd byte of the P1 score
@ $6379 ssub=ld a,($5cf7+$02) ; P2 score
  $6379,3 #REGa=3rd byte of the P2 score
  $637D,2 Jump if score of P2 < P1 (set's #REGhl to P1 score)
N $637F Inactive player has the highest score.
  $637F,3 #REGhl=P2 score
N $6382 Update the high score if the player score has beaten it.
  $6383,3 #REGde=high score
  $6386,2 Loop counter (all 3 score bytes)
  $6388,1 #REGa = hi-score byte
  $6389,1 Compare with player
  $638A,2 If hi-score < player, update highscore score
  $638C,2 If hi-score != player (not equal), then RET
  $638E,1 else hi-score == player: next player byte
  $638F,1 next high score byte
  $6390,2 Repeat
  $6392,1 Restores #REGhl to the highest player score
N $6394 Sets the bytes for the high score with those from the player.
  $6395,3 High Score
N $639E Player 1 has the highest score.
  $639E,3 #REGhl=P1 score
  $63A1,2 Update HI score
c $63A3 Update Jet Fighter.
R $63A3 Input:IX Alien object for one of the Jet Fighters.
@ $63A3 label=JetFighterUpdate
  $63A3,4 Increment current alien number
  $63A7,3 Update Alien direction
  $63AA,3 Alien "moving" field
  $63B0,4 Move if bit-1 is set
  $63B4,3 Check and update speed
  $63B7,3 #REGa=Jetman Y position
  $63BC,6 Update Alien speed if Jetman Y position-12 equals Alien Y position
  $63C2,3 #REGa=LSB of game timer
  $63C7,2 Move vertically if bit-6 is reset
  $63CF,2 Move vertically +2 or -2
N $63D1 Decide if speed should be updated.
  $63D1,3 #REGa=random number
  $63D6,1 Return if not zero
N $63D7 Update speed.
  $63D7,4 Alien "moving" field
  $63DB,1 #REGc=Jetman Y position-12 ?
  $63DC,3 #REGa=LSB of game timer
  $63E4,3 Set new X speed value
  $63E7,4 Set "colour" to White
N $63EC Move Jet Fighter horizontally.
  $63EC,3 Decrement alien X speed
  $63EF,2 Jet Fighter killed if X speed is zero
  $63F1,2 #REGa=default speed
  $63F3,4 Check bit-6 of Alien "direction"
  $63FB,1 #REGl=$FC or $04?
N $63FC Target the player and move towards them.
  $63FC,8 Move upwards if Jetman Y position higher than Alien Y position
  $6404,2 else, move down
N $6406 Move Jet Fighter vertically and horizontally.
  $6406,3 Alien "direction"
  $6409,2 Reset FLY and WALK bits
  $640D,3 Update "direction" value
  $6410,7 Update Alien X position (#REGl is probably 3 or 4)
  $6417,7 Update Alien Y position
  $641E,3 Update Actor Position X and draw
  $6421,3 Colourize the sprite
  $6424,7 Kill Fighter if Y position < $28
  $642B,3 Fire laser beam - returns #REGc
  $642E,4 Kill if a laser hit the Alien
  $6432,3 Platform collision - returns #REGe
  $6435,4 Kill if Alien hit a platform
  $6439,3 Alien collision - returns #REGde
  $643D,2 Kill alien type #1
  $643F,10 Update Alien "direction"
N $644A Jet Fighter is dead. Added score and make exploding sound.
  $644A,3 55 points for a dead jet fighter (decimal value)
  $644D,3 Add points to score
  $6450,3 Thruster SFX (actually for exploding jet fighters)
  $6453,3 Update current alien state
c $6456 Kill Alien: Type #1.
D $6456 Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
@ $6456 label=KillAlienType1
  $6456,3 Update actor state
  $6459,5 Play explosion sound with SFX type #2
  $645E,3 Animate explosion
c $6461 Jetman collects a collectible item.
D $6461 Input:IX Collectible item object
@ $6461 label=ItemCheckCollect
  $6461,3 Update Actor position direction
  $6464,3 Platform collision - returns #REGe
  $6467,10 Increment item Y position if bit-2 is set
  $6471,3 Alien collision - returns #REGe
  $6475,2 Drop new collectible item if #REGe > 0
  $6477,1 Reset #REGa
  $6478,3 #REGhl=sprite address
  $647B,3 Destroy the collected item
  $647E,4 Set type as unused
  $6482,3 250 points to add to score (decimal value)
  $6485,3 Add points to score
  $6488,3 SFX for item collect (and return)
c $648B Drop a new collectible item.
D $648B Used by the routine at #R$6461.
R $648B Input:IX Collectible item object
@ $648B label=ItemDropNew
  $648B,3 Jump table offset
  $648E,2 Values: 0, 2, 4, 6, or 8
  $6490,3 #REGhl=item drop jump table
  $6493,3 Execute the jump using #REGhl address
w $6496 Item drop jump table.
@ $6496 label=item_drop_jump_table
  $6496,2,2 Drop Gold bar collectible
  $6498,2,2 Drop chemical based collectible
  $649A,2,2 Drop chemical based collectible
  $649C,2,2 Drop green coloured collectible
  $649E,2,2 Drop collectible with random colour
c $64A0 Drop a gold bar collectible item.
D $64A0 Input:IX Collectible item object
@ $64A0 label=ItemDropGoldBar
  $64A0,4 Set colour to GOLD
c $64A4 Display a collectible sprite.
D $64A4 Used by the routines at #R$64bc, #R$64c2 and #R$64d7.
@ $64A4 label=ItemDisplaySprite
  $64A5,3 #REGde=item sprite address
  $64A8,3 Update the item sprite
  $64AB,3 Colourize the sprite
c $64AE Sprite offset using colour attribute.
D $64AE Used by the routines at #R$6461, #R$64a4 and #R$6514.
c $64B1 Get address for collectible sprite.
D $64B1 Used by the routine at #R$66fc.
R $64B1 Input:A Offset for the desired sprite.
R $64B1 Output:DE Address for a sprite.
@ $64B1 label=ItemGetSpriteAddress
  $64B1,3 Sprite lookup table
  $64B4,4 Add offset to base address
  $64B8,3 Assign sprite address to #REGde
c $64BC Drop a Plutonium collectible item.
D $64BC Input:IX Collectible item object.
@ $64BC label=ItemDropPlutonium
  $64BC,4 Set the colour to green
  $64C0,2 Display item sprite
c $64C2 Drop a chemical based item, flashing items radiation and plutonium.
D $64C2 Input:IX Collectible item object.
@ $64C2 label=ItemDropChemical
  $64C2,3 Game timer
  $64C9,2 Use cyan colour and display sprite
N $64CB Flashing items: hidden.
  $64CB,4 Set the colour to black
  $64CF,2 Display the item sprite
N $64D1 Flashing items: visible.
  $64D1,4 Set the colour to cyan
  $64D5,2 Display the item sprite
c $64D7 Drop a random coloured collectible item.
D $64D7 Set the sprite to a random colour based on it's ID, which means colour values will be between $41 and $47.
R $64D7 Input:IX Collectible item object.
@ $64D7 label=ItemDropRandomColour
  $64D7,3 Game timer
  $64DE,2 Jump if #REGa is now 1-7
  $64E1,2 Make sure colour value is > $40
  $64E3,3 Set the colour to between $41 and $47
  $64E6,2 Display the item sprite
c $64E8 Collision detection for collectible items / rocket modules.
D $64E8 Input:IX Collectible item object.
@ $64E8 label=CollisionDetection
  $64E8,3 Update Actor position direction
  $64EB,3 #REGa=item "state"
  $64EE,5 Pick up rocket module if bit-2 set
  $64F3,4 Carrying rocket module/fuel if bit-1 set
  $64F7,4 Draw sprite if bit-0 reset
  $64FB,3 Check for alien collision - returns #REGe
  $64FE,3 Collect rocket module if #REGe == 0
  $6501,3 Platform collision - returns #REGe
  $6504,4 Draw sprite if bit-2 set
c $6508 Increment Y position and draw sprite
D $6508 Used by the routine at #R$6565.
c $650E Draw a sprite.
D $650E Used by the routines at #R$64e8, #R$6523 and #R$6541.
  $650E,3 Update actor and draw sprite
  $6511,3 Colourize the sprite
c $6514 Gets collectible ID based on the current user level.
D $6514 Used by the routine at #R$64e8.
  $6514,3 Current player level
  $6518,2 There are only 6 collectibles?
  $651A,3 #REGde=collectible item sprite address
  $651D,3 Erase an item sprite
  $6520,3 Colourize the sprite
c $6523 Collect Rocket module or fuel pod.
D $6523 Module is collected after player collides with it. Used by the routine at #R$64e8.
R $6523 Input:IX Rocket module object.
@ $6523 label=CollectRocketItem
  $6523,4 Module "state"
  $6527,3 Find and destroy the sprite (returns #REGde)
  $652A,3 100 points to add to score (decimal value)
  $652D,3 Add points to score
  $6530,3 SFX for collecting fuel
  $6533,9 Update module position so it becomes attached to the player via the Jetman Y,X positions
  $653C,3 Update sprite X position
  $653F,2 Colourize the sprite
c $6541 Carry a collected rocket module/fuel pod.
D $6541 Ensure the rocket module/fuel pod remains attached to the foot of the Jetman sprite. Used by the routine at #R$64e8.
R $6541 Input:IX Rocket module object.
@ $6541 label=CarryRocketItem
  $6541,9 Update module position so it becomes attached to the player via the Jetman Y,X positions
@ $654A ssub=ld a,($5d30+$01) ; Rocket X position
  $654D,3 Subtract module X position
  $6550,3 If already negative, jump
  $6553,2 else make a negative value
  $6555,4 Draw sprite if #REGa >= 6
  $6559,4 Set module "state" to collected
@ $655D ssub=ld a,($5d30+$01) ; Rocket: X position
  $6560,3 Update module X position to be same as Rocket position
  $6563,2 Update module and draw sprite
c $6565 Pick up and carry a rocket module/fuel pod.
D $6565 Used by the routine at #R$64e8.
R $6565 Input:IX Collectible item object - rocket module or fuel pod.
@ $6565 label=PickupRocketItem
  $6565,3 Item sprite jump table offset
  $656A,2 Jump to delivery check if a fuel pod?
  $656E,3 Add item Y position
  $6573,3 Increment item Y position and draw sprite if < 183
@ $6576 ssub=ld a,($5d38+$04) ;
@ $657B ssub=ld ($5d38+$04),a ; Set module "state" to collected
@ $657E ssub=ld a,($5d30+$04) ; #REGa=Rocket "state" value
@ $6582 ssub=ld ($5d30+$04),a ; Update rocket "state" value
  $6585,3 Item sprite jump table offset
  $658A,3 Copy rocket sprite to buffers
  $658D,3 Find and destroy current sprite
  $6590,4 Set item type to unused
  $6594,3 SFX for rocket building
N $6597 Check if fuel pod delivered to ship, and increment count if so.
  $6597,3 Item Y position of fuel pod
  $659A,2 Has it reached the rocket yet?
  $659C,3 Move the fuel cell down one pixel if not
@ $659F ssub=ld a,($5d30+$05) ; #REGa=rocket fuel pod count
@ $65A3 ssub=ld ($5d30+$05),a ; Increment rocket fuel pod count
  $65A6,2 Loop back and repeat
c $65A8 Release new collectible item.
D $65A8 Used by the routine at #R$6971.
@ $65A8 label=ItemNewCollectible
  $65A8,3 Jetman direction
  $65AD,1 Return if not one of the 6 directions
  $65B0,1 Return if >= 3 (all movement except up right?)
  $65B1,3 #REGhl=default item state
  $65B4,3 #REGde=collectible object
  $65BA,1 #REGa=item type
  $65BC,1 Return if currently in use
  $65BD,3 Game timer
  $65C2,1 Return if between 1-127
  $65C5,3 #REGa=column to drop item
@ $65C8 ssub=ld ($5d40+$01),a ; Update item X position
  $65CB,2 Get random number
  $65CD,2 #REGa=2, 4, 6, 8, 10, 12, or 14
  $65CF,4 Jump if bit-3 is already reset
  $65D3,2 else set bit-3
  $65D5,2 Make sure bit-5 (32) is set
@ $65D7 ssub=ld ($5d40+$06),a ; Update item with new jump table offset
c $65DB Calculate column on which to drop a new collectible item/fuel pod.
D $65DB Used by the routines at #R$65a8 and #R$65f9.
R $65DB Ouput:A Column position.
@ $65DB label=ItemCalcDropColumn
  $65DB,3 #REGhl=item drop position table
  $65DE,3 #REGa=random number
  $65E3,3 #REGbc = byte offset (0-15)
  $65E6,1 Add offset
  $65E7,1 Set #REGa to position
b $65E9 Horizontal column positions for dropping collectibles.
@ $65E9 label=item_drop_positions_table
  $65E9,16,8
c $65F9 Drop a new fuel pod collectible.
D $65F9 Used by the routine at #R$6971.
@ $65F9 label=ItemNewFuelPod
  $65F9,3 Jetman direction
  $65FE,1 Return if not one of the 6 directions
  $6601,1 Return if >= 3 (all movement except up right?)
  $6602,3 #REGhl=default rocket module state
  $6605,3 #REGde=rocket module object
  $660B,3 Return if currently in use
@ $660E ssub=ld a,($5d30+$05) ; #REGa=Rocket fuel Pod count
  $6613,1 Return if fuel collected >= 6
  $6614,3 Game timer
  $661A,1 Return if #REGa is between 1-15
  $661D,3 #REGa=column to drop item
@ $6620 ssub=ld ($5d38+$01),a ; Update fuel pod X position
c $6624 Reset the Rocket modules state data ready for next level.
D $6624 After the rocket hits top of screen this routine resets all the collectibles, aliens, and player states for that level. Used by the routine at #R$6690.
@ $6624 label=RocketModulesReset
  $6624,3 #REGhl=rocket module
  $6627,2 Loop counter
c $6629 Make objects inactive.
D $6629 Used by the routine at #R$60b7.
R $6629 Input:B Loop counter: either $0A or $0C.
R $6629 HL Object to be updated: fuel pod or thruster animation.
  $6629,3 Increment value
  $662C,2 Reset first byte of object
  $662E,1 #REGhl += 8
c $6632 Animate the rocket flame sprites.
D $6632 Used by the routines at #R$6690 and #R$66b4.
R $6632 Input:IX Rocket object
@ $6632 label=RocketAnimateFlames
  $6632,8 Add 21 to rocket Y position
@ $663A ssub=ld hl,$5dc0+$01 ; #REGhl=Actor Y position
  $663D,4 Add 21 to actor Y position
  $6641,7 If near ground, turn off flame sprites
  $6648,2 If >= 184, just update flame sprite vars
  $664A,3 Game timer
  $664F,2 #REGde=flame sprite #1 if bit-3 is set
  $6651,3 else #REGde=flame sprite #2
N $6654 Draw the flame sprites.
  $6655,6 Destroy flame sprite #1
  $665B,6 Destroy flame sprite #2
  $6662,3 Erase and animate actor sprite
  $6665,4 Set flame sprite colour to Red
  $6669,3 Colourize the sprite
N $666C Update Rocket and Actor Y positions.
  $666C,8 Subtract $15 from rocket Y position
@ $6674 ssub=ld hl,$5dc0+$01 ; #REGhl=Actor Y position
  $6677,4 Subtract 21 from actor Y position
N $667C Set first rocket flame sprite to be displayed.
  $667C,3 Rocket flame sprite #1
  $667F,2 Draw flame sprite
N $6681 Turn off the rocket flame sprites and update sprite variables.
  $6681,6 Destroy flame sprite #1
  $6687,6 Destroy flame sprite #2
  $668D,3 Update sprite variables
c $6690 Rocket ship is taking off.
D $6690 Input:IX Rocket object.
@ $6690 label=RocketTakeoff
  $6690,3 Update Actor position direction
  $6693,3 Decrement Y position
  $6696,3 Thruster SFX
  $6699,3 Animate rocket flame sprites
  $669C,5 Check if rocket has reached top of screen
  $66A1,2 Update rocket colour if not
N $66A3 Rocket has reached top of screen - set up next level.
  $66A3,4 Increment current player level
  $66A7,3 Reset rocket ready for next level
  $66AA,3 Set Rocket "move" state to down
  $66AD,4 Reset fuel pod counter
  $66B1,3 New level
c $66B4 Rocket ship is landing.
D $66B4 Input:IX Rocket object.
@ $66B4 label=RocketLanding
  $66B4,3 Update Actor position direction
  $66B7,3 Increment Y position
  $66BA,3 Thruster SFX
  $66BD,3 Animate rocket flame sprites
  $66C0,5 Check if rocket has landed
  $66C5,2 Update rocket colour if not
N $66C7 Rocket has landed!
  $66C7,4 Set Rocket "move" state to default (on pad)
  $66CB,3 Initialise the player state
  $66CE,2 Update rocket colour
c $66D0 Update the rocket ship.
D $66D0 Input:IX Rocket object.
@ $66D0 label=RocketUpdate
  $66D0,3 Update Actor position direction
  $66D3,3 #REGe=Alien collision result: $00 or $01
  $66D6,3 Update rocket colour if not zero
  $66D9,7 Update rocket colour if fuel pod counter < 6
  $66E0,3 Set Rocket "move" state to up
  $66E5,4 #REGix=Jetman object
  $66E9,3 Update Jetman position direction
  $66EC,3 Jetman, find and destroy
  $66EF,4 Reset Jetman direction
  $66F3,2 Restore #REGix to be the rocket object
  $66F5,4 Increment current player lives
  $66F9,3 Display player lives
c $66FC Update Rocket ship colour.
D $66FC Colouring is based on the number of fuel pods collected. Used by the routines at #R$6690, #R$66b4 and #R$66d0.
R $66FC Input:IX Rocket object.
@ $66FC label=UpdateRocketColour
  $66FC,3 Rocket X position
  $66FF,3 Rocket Y position
  $6703,3 #REGa=colour attribute
  $6706,3 Set loop counter
N $6709 Draw all collected rocket modules.
  $670A,3 #REGa=player level
  $670D,7 Calculate which sprite to use for the current level
  $6714,3 #REGde=item address from lookup table using #REGa
  $6717,3 Update actor position using #REGde
  $671A,1 Restore loop counter
  $671B,8 Subtract 16 from a rocket Y position
@ $6723 ssub=ld a,($5dc0+$01) ; #REGa=Actor Y position
  $6726,2 Subtract 16 from Actor Y position
@ $6728 ssub=ld ($5dc0+$01),a ; Update Actor Y position
  $672F,2 Loop and update rocket/actor again
@ $6733 ssub=ld ($5dc0+$04),a ; Actor width = 2
@ $6737 ssub=ld ($5dc0+$03),a ; Actor height = 0 (?)
  $673B,3 Update rocket Y position: only Y changed in loop above
  $673E,3 Update current Actor Y,X coords
N $6741 Colour the rocket modules based on collected fuel pod count.
  $6741,6 Rocket "state"
  $6747,10 if value < 6, or the fuel pod counter is zero, then set rocket colour to white and redraw
  $6751,2 Check if all fuel collected (is checked at 6760)
  $6753,1 Preserve Carry (no care for #REGa)
  $6754,3 Game timer
  $675E,1 Restore Carry value (from 6751 check above)
  $6760,2 Colour all sprites if all fuel has been collected
  $6762,3 else use fuel pod count as loop counter
  $6765,4 Set colour to Magenta
  $6769,3 Update sprite colour
N $676C Set part of rocket back to white based on amount of uncollected fuel pods.
  $676C,2 #REGa=max possible fuel pods
  $676E,3 Subtract remaining fuel pod count
  $6771,1 Set loop counter
  $6772,5 Set Rocket colour to white
  $6777,3 Redundant JP!
  $677B,3 Colourize the sprite
  $677F,3 #REGhl=current rocket sprite coords
  $6782,4 Update Y position
  $6786,3 Update current rocket sprite coords
  $6789,2 Loop and continue colouring
w $678C Rocket and collectible sprite address lookup table.
@ $678C label=collectible_sprite_table
  $678C,2,2 Offset: $00 - Rocket #1: Bottom
  $678E,2,2 Offset: $02 - Rocket #5: Bottom
  $6790,2,2 Offset: $04 - Rocket #3: Bottom
  $6792,2,2 Offset: $06 - Rocket #4: Bottom
  $6794,2,2 Offset: $08 - Rocket #1: Middle
  $6796,2,2 Offset: $0A - Rocket #5: Middle
  $6798,2,2 Offset: $0C - Rocket #3: Middle
  $679A,2,2 Offset: $0E - Rocket #4: Middle
  $679C,2,2 Offset: $10 - Rocket #1: Top
  $679E,2,2 Offset: $12 - Rocket #5: Top
  $67A0,2,2 Offset: $14 - Rocket #3: Top
  $67A2,2,2 Offset: $16 - Rocket #4: Top
  $67A4,2,2 Offset: $18 - Fuel Cell
  $67A6,2,2 Offset: $1A - Fuel Cell
  $67A8,2,2 Offset: $1C - Fuel Cell
  $67AA,2,2 Offset: $1E - Fuel Cell
  $67AC,2,2 Offset: $20 - Gold Bar
  $67AE,2,2 Offset: $22 - Radiation
  $67B0,2,2 Offset: $24 - Chemical Weapon
  $67B2,2,2 Offset: $26 - Plutonium
  $67B4,2,2 Offset: $28 - Diamond
c $67B6 Rocket thruster SFX, and Jet Fighter explosions.
D $67B6 Used by the routines at #R$63a3, #R$6690 and #R$66b4.
R $67B6 Input:IX Jetman or Rocket object.
@ $67B6 label=SfxThrusters
  $67B6,3 Y position
  $67B9,8 Change pitch based on vertical position
  $67C1,1 Pitch
  $67C2,2 Duration
  $67C4,2 Play square wave sound
c $67C6 SFX for ship building.
D $67C6 Activated when ship module is dropped, or fuel cell touches the rocket base.
@ $67C6 label=SfxRocketBuild
  $67C6,2 Pitch
  $67C8,2 Duration
  $67CA,2 Play square wave sound
c $67CC SFX for collecting a fuel cell.
D $67CC Used by the routine at #R$6523.
@ $67CC label=SfxFuelCollect
  $67CC,2 Pitch
  $67CE,2 Duration
  $67D0,2 Play square wave sound
c $67D2 SFX for collecting an item, and when Jetman appears on-screen.
D $67D2 Used by the routines at #R$6461 and #R$737d.
@ $67D2 label=SfxItemCollect
  $67D2,2 Pitch
  $67D4,2 Duration
c $67D6 Play square wave sound.
D $67D6 Used by the routine at #R$67db.
@ $67D6 label=PlaySquareWave1
c $67DB Play square wave sound, starting with silence.
D $67DB Used by the routines at #R$67b6, #R$67c6 and #R$67cc.
R $67DB Input:D Sound frequency
R $67DB C Sound duration
@ $67DB label=PlaySquareWav2
  $67DB,2 Play sound/silence for desired length
  $67DD,6 Turn speaker OFF for desired duration
  $67E3,1 Decrement duration
  $67E4,2 Repeat until duration is zero
c $67E7 SFX for Laser Fire.
D $67E7 Used by the routine at #R$6f86.
@ $67E7 label=SfxLaserFire
  $67E7,2 Pitch/duration
  $67EC,7 Play sound for desire duration
  $67F4,2 Turn speaker OFF
  $67F6,1 Increment pitch
  $67FA,2 Repeat until pitch is $38
c $67FD Set SFX params for explosion sound.
D $67FD Used by the routines at #R$6456, #R$6bf1, #R$6d5c and #R$6d9c.
R $67FD Input:A Is the alien (0) or the player (1).
@ $67FD label=SfxExplosion
  $67FE,2 #REGc=0 or 2
  $6802,3 #REGde=explosion SFX params
  $6805,3 #REGhl=explosion SFX param defaults
  $6808,1 Set offset: first or second pair of bytes
  $6809,6 Copy defaults to the params
b $6810 Default explosion SFX parameters.
D $6810 These parameters are used in pairs: SFX #1 is used for most aliens, while SFX #2 is used for player, sphere alien, and crossed ship. #TABLE(default,centre,:w) { =h Bytes(n) | =h Parameter } { 1 | SFX 1: Frequency } { 2 | SFX 1: Duration } { 3 | SFX 2: Frequency } { 4 | SFX 2: Duration } TABLE#
@ $6810 label=explosion_sfx_defaults
  $6810,4,4
c $6814 SFX for player explosion.
D $6814 Input:IX The explosion SFX params array.
@ $6814 label=SfxExplosionPlayer
  $6814,3 Decrement the SFX length
  $6817,2 Stop playing SFX if length is zero
  $6819,2 else, set frequency
  $681B,2 Play explosion SFX
c $681D SFX for alien explosion.
D $681D Input:IX The explosion SFX params array.
@ $681D label=SfxExplosionAlien
  $681D,3 Decrement the SFX length
  $6820,2 Stop playing SFX if length is zero
  $6822,3 Get SFX length
  $6825,2 Add 24
  $6827,1 Set as frequency
c $6828 Plays the explosion sound effect.
D $6828 Used by the routine at #R$6814.
R $6828 Input:C Amplitude frequency.
@ $6828 label=SfxPlayExplosion
  $6828,7 Play sound for desire duration
  $6830,2 Turn speaker OFF
  $6833,2 Silence for the duration
  $6835,1 Decrement note duration
  $6836,2 Repeat until duration is zero
c $6839 Sound has finished playing.
D $6839 Input:IX The explosion SFX params array.
@ $6839 label=SfxFinishReturn
  $6839,4 Set frequency to zero
c $683E Animate explosion after killing an alien.
D $683E Used by the routine at #R$6456.
@ $683E label=ExplosionAfterKill
  $6840,4 Jetman explosion animation object
  $6844,3 Jetman object
  $6847,1 Assign direction to temp variable
  $6848,1 Animation X position
  $6849,4 Set explosion X position to match Jetman X position
  $684D,5 Set explosion Y position to match Jetman
  $6852,1 #REGa=Jetman direction
  $6853,3 Reset actor, which also sets anim object "state" to $01
  $6859,3 Reset Jetman direction to not moving
c $685D Enable animation, state false.
D $685D Used by the routines at #R$63a3, #R$6456, #R$6bf1, #R$6d5c, #R$6d9c and #R$753c.
R $685D Input:IX Animation object.
@ $685D label=AnimationStateReset
  $685D,3 Animating state
  $6864,4 Set "state" to un-animated
c $6868 Enable animation and reset frame count.
D $6868 Used by the routine at #R$6874.
R $6868 Input:A New direction value.
R $6868 IX Animation object.
  $6868,3 Update direction
  $686B,4 Set animating to "yes"
  $686F,4 Reset frame count
c $6874 Enable animation, state true.
D $6874 Used by the routine at #R$683e.
R $6874 Input:A New direction value.
R $6874 IX Animation object.
@ $6874 label=AnimationStateSet
  $6874,4 Set "state" to animating
c $687A Animates the explosion sprites.
R $687A Input:IX Explosion animation object
@ $687A label=AnimateExplosion
  $687A,4 Increment current alien number
  $687E,3 #REGc=explosion animation frame
  $6881,3 #REGb=explosion animation state
  $6884,3 Game timer
  $6888,5 Increment frame if timer&state is zero
  $688D,1 #REGa=original frame count
  $688E,2 Multiply by 2 (addresses are two-bytes)
  $6892,3 #REGhl=explosion sprite lookup table
  $6895,1 Set offset
  $6896,3 #REGde=address of the desired sprite
  $6899,6 Set #REGhl to Y,X coords of sprite
  $689F,2 Comparing with original frame count from 687e
  $68A1,2 If original frame >= 6 then animation has finished
  $68A5,2 If original frame >= 3 then half animated
  $68A7,3 Erase animation sprite
  $68AA,3 #REGa=random number
  $68B1,3 Update colour attribute to a random colour
  $68B4,3 Colourize the sprite
N $68B7 After an explosion, we check if it was the player that died!
  $68B7,6 Update anim object so "animating" = "direction"?
  $68BD,3 Update Actor position direction
  $68C0,3 Find and destroy actor
  $68C3,4 Reset "animating"
  $68C7,3 Animation object "direction"
  $68CE,3 Player was killed if < 3 (end of turn)
N $68D2 Called when half the explosion has been animated.
  $68D2,3 Get sprite screen position
  $68D5,3 Erase a destroyed actor
w $68D8 Explosion sprites lookup table.
D $68D8 Sprite addresses are repeated because on first use they are animated using a pink colour, then animated again in black, so as to make them disappear.
@ $68D8 label=explosion_sprite_table
  $68D8,2,2 Small explosion
  $68DA,2,2 Medium explosion
  $68DC,2,2 Large explosion
  $68DE,2,2 Small explosion
  $68E0,2,2 Medium explosion
  $68E2,2,2 Large explosion
c $68E4 Game delay when interrupts are enabled.
D $68E4 Is this delay long enough so that interrupts will be forcefully disabled on next game loop?
@ $68E4 label=GameDelayLoop
  $68E4,3 #REGa=interrupt state
  $68E8,1 Return if interrupts disabled (value > 0)
  $68E9,8 #REGhl=loop counter, so we loop 192 times
c $68F2 Copy the two sprites for an alien to the buffers.
D $68F2 Used by the routine at #R$6094.
@ $68F2 label=AlienBufferInit
  $68F2,3 #REGhl=alien sprite lookup table
  $68F5,3 Current player level
  $68FC,3 #REGde=offset address for lookup table
  $68FF,1 Add offset
  $6901,3 #REGde=first alien sprite buffer
  $6904,3 Reset rocket and copy sprite to buffer
  $6908,3 #REGde=second alien sprite buffer
  $690B,3 Copy sprite to buffer
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
  $690E,2,2 Level #1: Meteor        (frame 1)
  $6910,2,2 -                     - (frame 2)
  $6912,2,2 Level #2: Squidgy Alien (frame 1)
  $6914,2,2 -                     - (frame 2)
  $6916,2,2 Level #3: Sphere Alien  (frame 1)
  $6918,2,2 -                     - (frame 2)
  $691A,2,2 Level #4: Jet Fighter
  $691C,2,2
  $691E,2,2 Level #5: UFO
  $6920,2,2
  $6922,2,2 Level #6: Crossed Space Ship
  $6924,2,2
  $6926,2,2 Level #7: Spacecraft
  $6928,2,2
  $692A,2,2 Level #8: Frog Alien
  $692C,2,2
c $692E New item: code modification routine.
D $692E Output:IX Address of Jetman object
@ $692E label=CodeModifier
  $692E,1 Disable interrupts
  $692F,6 Update last_frame to current SYSVAR_FRAMES
  $6935,5 Set interrupt state to disabled
  $693C,3 #REGhl=points to the rocket object
@ $693F ssub=ld ($6971+$0d),hl ; Modify `LD BC, nnnn` - rocket object
  $6942,2 Value is a `JP` opcode
@ $6944 ssub=ld ($6971+$2b),a ; Modify instruction to be `JP`
@ $6947 nowarn
  $6947,3 #REGhl=address to be modified
@ $694A ssub=ld ($6971+$2c),hl ; Modify `JP nnnn` address
  $694D,4 #REGix=Jetman object
  $6951,3 Execute main loop
c $6954 New item: restore modified code to original values.
D $6954 Used by the routines at #R$62fe and #R$6966.
@ $6954 label=RestoreModifiedCode
  $6954,3 #REGhl=inactive Jetman object
@ $6957 ssub=ld ($6971+$0d),hl ; Reset `LD BC, 5D30` to use #REGhl
  $695A,2 Value is a `LD A (nnnn)` opcode
@ $695C ssub=ld ($6971+$2b),a ; Restore modified opcode to `LD A (nnnn)` instruction.
@ $6962 ssub=ld ($6971+$2c),hl ; Restore to `LD A (nnnn)` address to 0244
c $6966 Restore modified code and enable interrupts.
D $6966 Used by the routine at #R$6971, but only after that routine's code has been modified.
@ $6966 label=ResetInterruptAndModifiedCode
  $6966,3 Restore modified code
  $696C,3 Set interrupt state to enabled
  $696F,1 Enable Interrupts
c $6971 Generate new alien/fuel/collectible.
D $6971 Input:IX Item object.
@ $6971 label=ItemNew
  $6971,4 Increment random number
  $6975,3 Set offset to be length of an item object
  $6978,2 Set pointer to next item
N $697D The self-modifying code routines change the address here to be either the inactive player (5d88) or the rocket object (5d30).
  $697D,3 #REGbc=inactive player or rocket object
  $6980,1 Clear the Carry flag
  $6981,5 If object pointed to by #REGix is before #REGbc object, execute main loop
  $6988,2 Does this switch NMI off?
  $698A,2 Read input port 254
  $698C,4 What is this waiting for?
  $6990,7 Increment the game timer
  $6997,2 #REGh=0 to make sure #REGhl remains <= $00FF
  $6999,2 Get random number
N $699C The self-modifying code routine changes this to `JP 6966`. That routine resets the interrupts, before changing instruction here to `LD A,(0244)` - an address in the ROM which always returns $C1.
  $699C,3 #REGa=$C1, from 0244, because 5DCE is never used!
  $699F,1 #REGa=byte from address between $0000 - $00FF
  $69A0,1 Add #REGr to the number
  $69A1,3 Update random number value
  $69A4,9 Jump if current alien number < 3
  $69AF,2 Jump if one of the first 5 bits of random number are set
  $69B1,7 Generate new item if current alien number >= 6
  $69B8,6 Generate new item if begin play delay counter > zero
  $69BE,3 Jetman direction
  $69C4,2 If direction is zero, then find unused alien slot
  $69C7,2 Generate new item if direction is still > zero
N $69C9 Find first unused alien slot.
  $69C9,3 Alien state objects
  $69CC,2 Loop counter (6 aliens)
  $69D1,5 Generate new alien if the slot is unused
  $69D6,1 else increment to the next alien object
  $69D7,2 ...and try again
N $69D9 Generate either a new fuel pod or a new collectible item.
  $69D9,3 New fuel pod item
  $69DC,3 New collectible item
  $69DF,3 Reset SP, EI and execute main loop
N $69E2 Generate new alien in the given state slot (#REGhl).
  $69E2,1 Push current alien to stack (will be copied to #REGix)
  $69E4,8 Copy default alien state to current alien slot
  $69EC,2 Restore #REGix to point to current item object
  $69EE,3 Game timer
  $69F1,1 Backup to #REGe
  $69F2,2 #REGa=either 0 or 64
  $69F4,3 Set item "direction"
  $69F7,3 Set item "movement"
  $69FA,1 Restore #REGa to original game timer value (at 69ee)
  $69FF,3 Update item Y position
  $6A02,3 Copy current item object address to #REGbc
  $6A05,8 Calculate a value for the colour attribute
  $6A0D,3 Update colour attribute
  $6A12,3 Set jump table offset
  $6A15,3 #REGhl=item level object types
  $6A18,15 Using the current player level, pull a value from the item level params table
  $6A27,3 Set item object type to this value
  $6A2A,3 Drop the collectible then execute the main loop
b $6A2D New item object types for each level - 8 bytes for 8 levels.
@ $6A2D label=item_level_object_types
  $6A2D,8,8
c $6A35 Update Squidgy Alien.
D $6A35 Input:IX Alien object.
@ $6A35 label=SquidgyAlienUpdate
  $6A35,4 Increment current alien number
  $6A39,3 Update actor direction
  $6A3C,3 Fire laser beam (returns #REGc)
  $6A40,3 Add the points for a kill if alien is dead
  $6A43,3 Alien collision check (returns #REGe)
  $6A47,3 Kill alien (type #1) if #REGe is zero
  $6A4B,3 Reset alien new direction flag
N $6A4E Check which direction alien is travelling after hitting a platform.
  $6A4E,3 Platform collision (returns #REGe)
  $6A51,4 Update alien X position if bit-2 is reset
  $6A55,4 Set alien direction to up if bit-7 set
  $6A59,4 Set alien direction to down if bit-4 set
N $6A5D Alien has hit the end of a platform: change direction.
  $6A5D,13 Update alien "moving" value
N $6A6A Update the alien X position.
  $6A6A,4 Check alien moving left/right bit
  $6A6E,3 #REGa=alien X position (fetch before the jump)
  $6A71,2 If moving left, subtract 2 from direction (via jump)
  $6A73,2 otherwise, we add 2 to move right
  $6A75,3 Set new X position +/- 2
N $6A78 Update the alien Y position, first checking if within the upper/lower bounds of the screen.
  $6A78,4 Check alien moving up/down bit
  $6A7C,3 #REGa=alien Y position (fetch before the jump)
  $6A7F,2 If moving up, subtract 2 from direction (via jump)
  $6A81,2 otherwise, we add 2 to move down
  $6A83,3 Set new alien Y position +/- 2
N $6A86 Draw the alien if new direction is set, otherwise repeat collision check again.
  $6A86,11 Draw the alien if the new direction flag is set, otherwise, increment the value
  $6A91,2 Jump back and repeat collision check
N $6A93 Change alien moving direction to up.
N $6A99 Change alien moving direction to down.
N $6A9F Subtract 2 from the X position (move left).
N $6AA3 Subtract 2 from the Y position (move up), unless it has reached top of screen.
  $6AA7,2 Return if not at top of screen
  $6AA9,4 Otherwise, set alien to moving down.
N $6AAF Add score to player if alien is dead.
  $6AAF,3 80 points (decimal value)
  $6AB2,3 Add points to score
  $6AB5,3 Kill alien (type #2)
c $6AB8 Update UFO alien -- this alien is a chaser!
D $6AB8 TODO: annotations are really messy/wrong here, needs lots more work to understand how the movement is calculated.
R $6AB8 Input:IX Alien object.
@ $6AB8 label=UFOUpdate
  $6AB8,4 Increment current alien number
  $6ABC,3 Update actor direction
  $6ABF,3 Fire laser beam (returns #REGc)
  $6AC3,3 Add the points for a kill if alien is dead
  $6AC6,3 Alien collision check (returns #REGe)
  $6ACA,3 Kill alien (type #1) if #REGe is zero
  $6ACE,3 Reset alien new direction flag
N $6AD1 Check which direction alien is travelling after hitting a platform.
  $6AD1,3 Platform collision (returns #REGe)
  $6AD4,4 Update alien X position if bit-2 is reset
  $6AD8,5 Set alien direction to up if bit-7 set
  $6ADD,5 Set alien direction to down if bit-4 set
N $6AE2 Move the flying saucer in a slightly more erratic way (the XOR), rather than just heading directly for the Jetman.
  $6AE2,15 Update alien "moving" value
N $6AF1 Calculate new horizontal position and speed.
  $6AF1,3 Alien X speed
  $6AF4,8 Calculate new speed?
  $6AFC,3 Jetman X position
  $6AFF,3 Subtract alien X position
  $6B02,3 If Jetman X > alien X, then jump
  $6B05,7 If alien is moving left, then jump
  $6B0C,6 If current speed is less than max, then increment
N $6B12 Calculate new X position.
  $6B12,1 #REGc=current speed
  $6B13,3 #REGh=X position
  $6B16,3 Calculates and returns #REGde, new position offset
  $6B19,1 Clear the carry flag
N $6B1C Update the X position and speed
  $6B1C,3 Update X position
  $6B1F,7 Calculate and update X speed
N $6B26 Calculate new Y position and speed.
  $6B26,3 Alien Y speed
  $6B31,3 Jetman Y position
  $6B34,3 Subtract alien Y position
  $6B37,3 If Jetman Y > alien Y, then jump
  $6B3A,7 If alien is moving up then increment Y position (if not at top of screen) and jump to 6b49
  $6B41,4 Calculate new down Y position if #REGc > 0 (presumably above the ground)
  $6B45,4 else moving direction must be set to up...
  $6B49,1 ..and #REGc will have been decremented here
  $6B4A,3 #REGh=Y position
  $6B4D,3 Calculates and returns #REGde, new position offset
  $6B50,1 Clear the carry flag
  $6B53,9 Set moving direction as down if at top of screen
  $6B5C,3 Update Y position
  $6B5F,7 Update Y speed
N $6B66 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
  $6B66,3 Draw the alien if the new direction flag is set,
  $6B69,1 otherwise, increment it
  $6B6E,3 }
  $6B71,3 Jump back and repeat collision check
N $6B74 Check moving direction and update.
  $6B74,4 Check moving left/right bit
  $6B78,2 If moving left, increment speed (via jump)
  $6B7C,3 If not zero, calculate X direction/speed
  $6B7F,4 else set X moving to "right"
  $6B83,1 #REGa (speed) was decremented from 0, so will now be FF
  $6B84,3 #REGh=X position
  $6B87,3 Calculates and returns #REGde, new position offset
  $6B8B,3 Update the X position and speed
  $6B8E,6 If current speed is less than max, then increment
  $6B94,2 Update position
  $6B96,1 #REGa=speed
  $6B98,3 Update X position and speed unless zero
  $6B9B,4 Set moving direction to "right"
  $6B9F,3 Update X direction/speed
  $6BA2,4 Check Jetman moving direction
  $6BA6,2 Jump if top bit not set
  $6BA8,5 Jump if #REGc >= 15
  $6BAD,1 else increment it
  $6BAE,1 (will be #REGc = #REGc - 1)
  $6BB2,3 Calculates and returns #REGde, new position offset
  $6BB6,3 Update Y position and speed
  $6BB9,1 #REGa=speed
  $6BBB,2 If speed > 0 move upwards
  $6BBD,4 else set moving direction to "down"
  $6BC1,2 ...and update Y position and speed
  $6BC3,10 If current speed is less than max, then increment it, and update position
N $6BCD Change alien moving direction to up.
N $6BD4 Change alien moving direction to down.
N $6BDB Returns #REGde (new position) as calculated from the speed (#REGc).
  $6BDC,1 #REGc should be <= 15. Example, if value is $0F:
  $6BDD,1 0 00011110
  $6BDE,1 0 00111100
  $6BDF,1 0 01111000
  $6BE0,1 0 11110000
  $6BE1,2 Clear lower 4 bits...just in case!
  $6BE6,2 1 11100000
  $6BE8,2 If E >= 8, then bit-0 of D is set
c $6BEB Add points for UFO kill.
D $6BEB Used by the routine at #R$6ab8.
@ $6BEB label=UFOKillAddPoints
  $6BEB,3 50 points (decimal value)
  $6BEE,3 Add points to score
c $6BF1 Kill alien update (type #2).
D $6BF1 Resets alien state, and plays explosion SFX #1. Used by the routine at #R$6a35.
@ $6BF1 label=KillAlienType2
  $6BF1,3 Update actor state
  $6BF4,1 #REGa should be 0 for the Alien SFX
  $6BF5,3 Plays explosion SFX for an Alien
c $6BF8 Update Sphere alien.
D $6BF8 Input:IX Alien object.
@ $6BF8 label=SphereAlienUpdate
  $6BF8,4 Increment current alien number
  $6BFC,3 Update actor direction
  $6C00,3 Reset alien new direction flag
  $6C03,3 Fire laser beam (returns #REGc)
  $6C07,3 40 points (decimal value)
  $6C0A,3 Kill alien (type #3) if alien is dead
  $6C0D,3 Alien collision check (returns #REGe)
  $6C11,3 Kill alien (type #1) if #REGe is zero
N $6C14 Check which direction alien is travelling after hitting a platform.
  $6C14,3 Platform collision (returns #REGe)
  $6C17,4 Update alien Y position if bit-2 is reset
  $6C1B,4 Set alien direction to up if bit-7 set
  $6C1F,4 Set alien direction to down if bit-4 set
N $6C23 Alien has hit the end of a platform: change direction.
  $6C23,13 Update alien "moving" value
N $6C30 Update the alien Vertical position.
  $6C30,4 Check alien moving direction
  $6C34,2 Update Y position if vertical movement
  $6C36,4 #REGe=random number
  $6C3C,2 Jump if != 0
  $6C3E,4 else set "moving" bit-0
  $6C42,10 Use Game timer to Y speed
  $6C4C,1 #REGa=original random number
  $6C4F,1 #REGe = 0 or 128
  $6C50,9 Update alien "moving" to either 127 or 255
  $6C59,2 Jump back and repeat collision check
N $6C5B Update the alien Horizontal position.
  $6C5B,4 Check alien "moving"
  $6C5F,2 Update X position if horizontal movement
  $6C61,3 else update Y position
N $6C64 Update the alien Y position, first checking if within the upper/lower bounds of the screen.
  $6C64,4 Check moving up/down bit
  $6C68,2 If moving up, subtract 2 from direction (via jump)
  $6C6A,2 otherwise, we add 2 to move down
  $6C6C,3 Set new Y position +/- 2
  $6C6F,3 Decrement Y speed
  $6C74,4 Reset bit-0 of alien "moving" if speed is zero
N $6C78 Update the alien X position.
  $6C78,3 #REGa=X position (fetch before the jump)
  $6C7B,4 Check moving left/right bit
  $6C7F,2 If moving left, subtract 2 from direction (via jump)
  $6C81,2 otherwise, we add 2 to move right
  $6C83,3 Set new X position +/- 2
N $6C86 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
  $6C86,11 Draw the alien if the new direction flag is set, otherwise, increment the value
  $6C91,3 Jump back and repeat collision check
N $6C94 Change alien moving direction to up.
N $6C9A Change alien moving direction to down.
N $6CA0 Subtract 2 from the Y position (move up), unless it has reached top of screen.
  $6CA4,2 Return if not at top of screen
  $6CA6,4 Otherwise, set to moving down
N $6CAC Subtract 2 from horizontal direction.
c $6CB0 Update Actor direction.
D $6CB0 Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8 and #R$6cbe.
R $6CB0 Input:IX Actor object.
@ $6CB0 label=ActorUpdateDir
  $6CB0,3 Update Actor position direction
  $6CB3,3 Actor direction
@ $6CBA ssub=ld ($5dc0+$02),a ; Update actor "direction"
c $6CBE Update crossed space ship.
D $6CBE Input:IX Alien object.
@ $6CBE label=CrossedShipUpdate
  $6CBE,3 Update actor direction
  $6CC1,4 Increment alien number
  $6CC5,3 Fire laser beam (returns #REGc)
  $6CC9,3 Add points and kill alien (type #3) if dead
  $6CCC,3 Alien collision (returns #REGe)
  $6CD0,3 Kill alien (type #1) if alien is dead
  $6CD4,3 Reset alien new direction
N $6CD7 Crossed ship direction change on platform collision.
@ $6CD7 label=CrossedShipPlatformCollision
  $6CD7,3 Platform collision (returns #REGe)
  $6CDA,4 Update alien X position if bit-2 is reset
  $6CDE,5 Set alien direction to up if bit-7 set
  $6CE3,5 Set alien direction to down if bit-4 set
N $6CE8 Alien has hit the end of a platform: change direction in a slightly more erratic way than other aliens (note the XOR).
  $6CE8,15 Update alien "moving" value
N $6CF7 Move crossed ship horizontally.
@ $6CF7 label=CrossedShipMoveShip
  $6CF7,4 Check moving left/right bit
  $6CFB,3 #REGa=X position (fetch before the jump)
  $6CFE,3 If moving left, subtract 2 from direction (via jump)
  $6D01,2 otherwise, we add 2 to move right
N $6D03 Update the alien YX position.
  $6D03,3 Set new X position +/- 2
  $6D06,6 #REGhl=Y speed x 2
  $6D0C,3 #REGd=alien X position
  $6D0F,3 #REGe=alien X speed
  $6D12,6 If alien moving is "up" subtract hl/de
  $6D18,1 else add them
N $6D19 Update vertical position, direction, and speed.
  $6D19,3 Set alien X speed
  $6D1C,3 Alien Y position = #REGh
  $6D1F,9 If alien is at top of screen, set to moving down
  $6D28,4 Check if moving up
  $6D2C,2 Change alien direction to down if it is
  $6D2E,3 else increment Y speed
  $6D31,2 Jump if it wasn't $FF before the increment
  $6D33,4 else set Y speed to $FF
N $6D37 Draw the alien if a new direction is set, otherwise repeat platform collision check again.
  $6D37,10 Draw the alien if the new direction flag is set, otherwise, increment the value
  $6D41,2 Jump back and repeat collision check
c $6D43 Draw an alien sprite to the screen.
D $6D43 Input:IX Alien object.
@ $6D43 label=DrawAlien
  $6D43,4 Backup alien direction
  $6D47,7 Temporarily change alien direction
  $6D4E,3 Update actor X position (using temp direction)
  $6D51,3 Colourize the sprite
  $6D55,3 Restore original direction
c $6D59 Add score for crossed space ship kill.
D $6D59 Used by the routine at #R$6cbe.
@ $6D59 label=CrossedShipKillPoints
  $6D59,3 60 points (decimal value)
c $6D5C Kill alien update (type #3).
D $6D5C Add score, reset alien state, and play explosion SFX #2. Used by the routine at #R$6bf8.
@ $6D5C label=KillAlienType3
  $6D5C,3 Add points to score
  $6D5F,3 Update actor state
  $6D62,2 Set SFX to type #2
  $6D64,3 Play explosion sound with SFX type #2
c $6D67 Change alien direction flag to up, and other updates.
D $6D67 Used by the routine at #R$6cd7.
@ $6D67 label=CrossedShipDirUp
  $6D67,4 Set alien to moving up
  $6D6B,8 Update Y speed using random number
  $6D73,3 Update alien position
N $6D76 Change alien moving direction flag to down.
  $6D7A,3 Update alien position
N $6D7D Subtract 2 from X position.
  $6D7F,3 Update alien YX position
N $6D82 Change direction to down.
@ $6D82 label=CrossedShipDirDown
  $6D82,3 Decrement Y speed
  $6D85,6 If speed is zero, set to moving down
  $6D8B,2 Draw alien and perform platform collision
N $6D8D This entry point is used by the routine at #R$6cbe.
  $6D8D,1 Reset Carry flag
  $6D8E,1 Swap registers
  $6D8F,2 Subtract #REGde and Carry flag from #REGhl
  $6D91,3 Update vertical position, direction, and speed
b $6D94 Default alien state.
D $6D94 Copied to the alien object when a new alien is instantiated.
@ $6D94 label=default_alien_state
  $6D94,8,8
c $6D9C Update the meteor.
D $6D9C Input:IX Alien object.
@ $6D9C label=MeteorUpdate
  $6D9C,3 Update Actor position direction
  $6D9F,4 Increment alien number
N $6DA3 Update the alien X position.
  $6DA3,3 #REGa=X position
  $6DA6,4 Check moving left/right bit
  $6DAA,2 If moving left, subtract 2 from direction (via jump)
  $6DAC,3 otherwise, we add alien X speed to value
  $6DAF,3 Set new X position +/- 2
N $6DB2 Update the alien Y position.
  $6DB2,9 Add Y speed to current Y position
  $6DBB,3 Update actor X position (using temp direction)
  $6DBE,3 Colourize the sprite
  $6DC1,3 Platform collision (returns #REGe)
  $6DC4,4 Kill alien it collided with a platform
  $6DC8,3 Fire laser beam (returns #REGc)
  $6DCB,4 Kill alien if it is dead
  $6DCF,3 Alien collision check (returns #REGe)
  $6DD2,4 Kill alien (type #1) if #REGe is zero. Player gets no points!
N $6DD7 Add score for Meteor kill.
  $6DD7,3 25 points (decimal value)
  $6DDA,3 Add points to score
N $6DDD Kill meteor - reset state, and play explosion SFX #1.
  $6DDD,3 Update actor state
  $6DE0,1 #REGa should be 0 for the Alien SFX
  $6DE1,3 Plays explosion SFX for an Alien
N $6DE4 Subtract 2 from horizontal direction.
  $6DE4,3 Subtract X speed
c $6DE9 Alien Collision.
D $6DE9 Used by the routines at #R$63a3, #R$6461, #R$64e8, #R$66d0, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
R $6DE9 Input:IX Alien object.
R $6DE9 Output:E as either $00 or $01.
@ $6DE9 label=AlienCollision
  $6DE9,3 #REGhl=Jetman object
  $6DEC,2 Default value for #REGe
  $6DEE,1 Jetman direction
  $6DF1,3 Jump if #REGa - 1 == 0
  $6DF5,1 Return if #REGa is not zero
  $6DF6,1 #REGhl=Jetman X position
  $6DF8,3 Jetman X position - Alien X position
  $6DFB,5 Make sure we have a positive byte
  $6E00,3 Return if #REGa >= 12
  $6E03,1 #REGhl=Jetman Y position
  $6E05,3 Jetman Y position - Alien Y position
  $6E08,3 Set #REGd to 15 if it's still a positive number
  $6E0B,2 else: negate it
  $6E0D,3 #REGd=alien sprite height
  $6E12,2 Compare and return
  $6E14,2 default #REGd to 21
  $6E16,2 Return $00 if #REGd >= #REGa
  $6E1A,1 else return $01
c $6E1B Fire a laser beam.
D $6E1B Used by the routines at #R$63a3, #R$6a35, #R$6ab8, #R$6bf8, #R$6cbe and #R$6d9c.
R $6E1B Input:IX Alien object.
R $6E1B Output:C Is either $00 or $01.
R $6E1B HL Pointer to current active laser beam object.
@ $6E1B label=LaserBeamFire
  $6E1B,3 offset
  $6E1E,3 Laser beam objects
  $6E21,2 Loop counter (4 laser beams)
  $6E23,1 #REGhl: += 8 after first iteration
  $6E24,4 If current laser beam is in use, try next one
  $6E28,1 #REGhl=Y position
  $6E29,1 #REGhl=X position: pulse #1
  $6E2A,1 #REGhl=X position: pulse #2
  $6E2B,1 #REGa=pulse #2
  $6E2C,1 #REGhl=X position: pulse #1
  $6E2D,4 Next iteration is bit-2 of pulse #2 is reset
  $6E33,3 Subtract alien X position from laser beam X position
  $6E36,3 If positive number, check position and next iteration
  $6E41,3 Next iteration if pulse X position is now >= 8/32
  $6E44,1 #REGhl=Y position
  $6E46,3 Subtract alien Y position from laser beam Y position
  $6E4B,3 If subtraction was negative number, next iteration
  $6E4E,2 else, add 12
  $6E50,6 Next iteration if >= sprite height
  $6E56,2 else set return value to $01
  $6E58,5 Update X position: pulse #1
  $6E5D,1 Set #REGhl to first byte of current group
  $6E5E,1 We're done here
  $6E5F,4 Try next laser beam object
  $6E63,3 Return $00
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
  $6E66,2 Backup #REGb value
  $6E68,2 #REGe=third byte - NULL on read
  $6E6A,1 #REGc=first pixel byte
  $6E6C,1 #REGd=second pixel byte
  $6E6D,1 Set #REGhl to next byte (used later)
  $6E6E,3 Return if #REGb == 0
N $6E71 Rotating the bits.
  $6E71,8 Executes #REGb times
  $6E79,2 Restore #REGb to the entry value
c $6E7C Reverse all bits in Accumulator.
D $6E7C Two buffers are used for sprites facing the opposite direction so we need to flip the bits such that %00100111 becomes %11100100.
@ $6E7C label=ReverseAccBits
  $6E7C,1 Backup #REGbc
  $6E7D,2 Counter of 8-bits
  $6E7F,5 Do the bit reversal
  $6E84,1 Set return value
  $6E85,1 Restore #REGbc
c $6E87 Flip byte pair of an alien sprite so it faces opposite direction.
D $6E87 Used by the routine at #R$6ea5.
R $6E87 Input:B Loop counter.
R $6E87 HL Pointer to current byte of sprite.
R $6E87 Output:B Same value as on entry.
R $6E87 DE The flipped byte pair.
R $6E87 HL Pointer to next byte of sprite.
@ $6E87 label=BufferFlipSprite
  $6E87,2 Backup #REGb value
  $6E8B,1 Get byte from sprite
  $6E8C,3 #REGa=reversed byte
  $6E90,2 Get next byte from sprite
  $6E92,3 #REGa=reversed byte
  $6E96,1 Point #REGhl to next byte
  $6E97,3 Return if all bytes have been processed
  $6E9A,8 Shift sprite 4-pixels to the right?
  $6EA2,2 Restore #REGb to the original value
c $6EA5 Write all sprite pixel bytes to buffer.
D $6EA5 Bytes are first shifted and/or flipped along the horizontal axis. Used by the routine at #R$6f2a.
R $6EA5 Input:B Loop counter - sprite height.
R $6EA5 HL Pointer to buffer for data to be written to.
@ $6EA5 label=BufferWritePixel
  $6EA5,1 #REGhl=sprite, #REGhl'=buffer, #REGb'=counter
  $6EA6,6 Get next two bytes if Jetman rocket module status is zero
  $6EAC,3 #REGde=flipped byte pair
  $6EB1,1 #REGhl=buffer, #REGb=counter
  $6EB3,1 Write first byte
  $6EB6,1 Write the second byte
  $6EB8,1 Write third byte
  $6EB9,1 #REGhl=next buffer address
  $6EBA,2 Loop back, writing reversed sprite data to buffer
  $6EBC,1 We're done.
  $6EBD,3 #REGde=two new bytes of sprite pixel data
  $6EC0,2 Loop back, writing non-reversed sprite data to buffer
c $6EC2 Copy Rocket sprites for current level to the buffers.
D $6EC2 Using the sprite lookup table, this routine calculates which Rocket sprites to copy to the buffers or the current level, then calls the copy routine. Used by the routines at #R$60a7, #R$60b7 and #R$6565.
R $6EC2 Input:A Is the byte offset between the modules of the current rocket.
@ $6EC2 label=BufferCopyRocket
  $6EC3,3 #REGa=player level. Example, if level 3:
  $6EC6,1 A=10000001, C=1
  $6EC7,2 A=00000000
  $6EC9,1 A=00001000 (e.g. if #REGc=$08)
  $6ECA,3 #REGbc=sprite offset value
  $6ECD,3 Collectible sprite lookup table
  $6ED1,3 #REGde=start of rocket sprite buffers
  $6ED6,3 Set default for rocket module attached value
  $6EDA,3 Set default for Jetman rocket module connected value
  $6EDD,2 Loop counter
  $6EE0,1 Backup loop counter
  $6EE1,1 #REGa starts at $00, then returns value from #R$6f0b
  $6EE2,2 #REGc=sprite count
  $6EE4,3 #REGhl=pointer to sprite pixel data
  $6EE8,1 Restore loop counter
  $6EE9,2 #REGhl=previous lookup table offset
  $6EEB,1 Decrement loop counter
  $6EEC,2 Repeat until counter is zero
c $6EEF Initialise rocket build state for new level.
D $6EEF After initialising, sprites are copied to the first pair of buffers. Used by the routine at #R$68f2.
R $6EEF Output:A New Jetman module connect status.
@ $6EEF label=RocketBuildStateReset
  $6EEF,3 #REGbc=sprite count
  $6EF2,5 Start of new level rocket state
  $6EF7,1 Used to reset Jetman module connect status
s $6EFA Old unused routines.
  $6EFA,17,$11
c $6F0B Get address to sprite pixel data, and copy to a buffer.
D $6F0B Looks up the address for a sprite from the lookup table, then points #REGhl to the pixel data for that sprite. Used by the routine at #R$6ec2.
R $6F0B Input:HL Offset address in sprite lookup table.
R $6F0B DE Address of buffer to use.
R $6F0B Output:HL Pointer to pixel data block.
@ $6F0B label=PointerToSpritePixelDataAndCopy
  $6F0E,4 #REGhl=sprite address, from lookup table
  $6F12,1 #REGhl=sprite "height"
  $6F13,1 #REGhl=sprite data block
  $6F14,2 Loop back up to the main copy routine
c $6F16 Set the rocket building state on Jetman.
D $6F16 After initialising the states, the sprites are then copied to the second pair of buffers. Used by the routine at #R$68f2.
@ $6F16 label=JetmanRocketStateUpdate
  $6F16,3 #REGbc=sprite count
  $6F19,2 Redundant opcode
  $6F1B,3 Redundant entry point for old code at 6F31
  $6F1E,2 Will set Jetman module connect status
c $6F20 Set Jetman module state.
D $6F20 Used by the routine at #R$6eef.
c $6F23 Get address to sprite pixel data.
D $6F23 Used by the routine at #R$6f2a.
R $6F23 Input:HL Offset address in sprite lookup table.
R $6F23 Output:HL Pointer to pixel data block.
@ $6F23 label=PointerToSpritePixelData
  $6F26,4 #REGhl=sprite address from lookup table
c $6F2A Copies the sprite pixel data to a buffer.
D $6F2A Note the copious amounts of register swapping! These annotations need checking. Used by the routine at #R$6f0b.
R $6F2A Input:C Number of bytes to copy?
R $6F2A HL Address pointing to the "height" value in a sprite header
R $6F2A DE Address of buffer to use.
@ $6F2A label=BufferCopySprite
  $6F2B,1 Swap Sprite<->Buffer addresses
  $6F2D,1 #REGhl=sprite address
  $6F2E,1 #REGc (sprite count) is the important value
  $6F2F,1 Copy the counter back on the stack
  $6F30,1 #REGa=sprite height value
  $6F31,1 Backup "height" to #REGa'
  $6F32,1 #REGhl=start of sprite pixel data
  $6F33,1 #REGhl=buffer, #REGde=sprite
  $6F34,2 Buffer: set first byte
  $6F37,2 Buffer: set sprite width
  $6F39,1 Point Buffer to height variable
  $6F3A,1 Restore #REGa with height value
  $6F3B,4 Jump if height < 17 pixels
  $6F3F,2 else height=16 pixels
  $6F41,1 Buffer: height will be <= 16
  $6F42,1 Point Buffer to start of pixel data
  $6F43,1 #REGb=height variable
  $6F44,3 Write pixel to a buffer
  $6F47,1 Reset #REGbc to be only the sprite counter?
  $6F48,1 #REGhl=start of buffer
  $6F49,4 #REGhl=start of next buffer
  $6F4D,1 #REGde=lookup table address
  $6F4E,1 #REGhl=sprite, #REGde=buffer
  $6F4F,1 #REGhl=sprite width value
  $6F50,1 #REGhl=sprite height value
  $6F51,3 #REGa=Rocket build state - only $02 or $04?
  $6F56,1 Decrement the sprite counter
  $6F57,2 Fetch next sprite address
c $6F5A Create new laser beam.
D $6F5A Find an unused laser beam slot - return if non free - then initialise and draw the laser GFX in the correct location and direction in relation to Jetman. Used by the routine at #R$7492.
R $6F5A Output:HL Address pointing to a free laser beam slot.
@ $6F5A label=LaserNewIfFreeSlot
  $6F5A,6 Return unless one of first two bits of SYSVAR_FRAMES are set
  $6F60,3 #REGhl=laser beam objects
  $6F66,2 Loop counter for all 4 laser beams
  $6F68,1 Get first byte of object
  $6F6A,2 Initialise and draw laser beam, if unused
  $6F6D,2 Repeat until an unused beam is found
  $6F6F,1 Return if no free slots are available
c $6F70 Initialise laser beam slot, and draw graphics.
D $6F70 Used by the routine at #R$6f5a.
R $6F70 Input:HL Address pointing to an unused laser beam.
@ $6F70 label=LaserBeamInit
  $6F70,2 Set first byte to 16: "used"
  $6F72,1 Laser Y position
  $6F73,3 #REGde=Jetman object
  $6F76,2 #REGb=direction in which to draw laser beam, based on Jetman movement action
  $6F79,1 #REGa=Jetman X position
  $6F7E,1 #REGc=laser beam X position
  $6F7F,4 Shoot laser right if Jetman is facing right
  $6F83,2 else shoot laser beam left
  $6F85,1 #REGc=Jetman X position - 8
c $6F86 Draw laser beam.
D $6F86 Used by the routine at #R$6fb6.
R $6F86 Input:C The X Position to start drawing the laser.
R $6F86 DE Jetman object (pointing to X position)
R $6F86 HL Laser beam object to be drawn (pointing to Y position)
@ $6F86 label=LaserBeamDraw
  $6F86,1 Jetman Y position
  $6F87,4 Update the laser beam Y position to align with the middle of the Jetman sprite
  $6F8B,1 Laser X position: pulse #1
  $6F8C,2 Loop counter
  $6F8E,1 Update pulse #1
  $6F92,4 Update the rest of the pulses: #2, #3 and #4
  $6F96,9 Update the laser beam "length" value, using the random_number as a base value
  $6F9F,2 #REGde points to laser beam "colour attribute"
  $6FA1,3 #REGhl=Laser beam colour table
  $6FA4,10 Use random_number to point #REGhl to one of the values in the colour table
  $6FAE,1 Assign laser beam "colour attribute" a new colour
  $6FAF,3 Laser fire SFX
b $6FB2 Laser beam colour attribute table.
@ $6FB2 label=laser_beam_colours
  $6FB2,4,4
c $6FB6 Shoots a laser beam to the right.
D $6FB6 Once position of Jetman's gun is located, we call the draw laser beam routine. Used by the routine at #R$6f70.
R $6FB6 Input:C Jetman X position +/- a few pixels: 0-7 maybe?
R $6FB6 DE Address of Jetman X position variable.
R $6FB6 Output:C New X position of laser beam.
@ $6FB6 label=LaserBeamShootRight
  $6FB6,1 Jetman X position
  $6FB7,2 Checking for any laser beam pixels?
  $6FBA,4 Increment X position if some laser pixels are set
  $6FBE,4 Add 16 and reset bit-0
  $6FC2,1 Set return value
  $6FC3,2 Draw laser beam
c $6FC5 Animate a laser beam.
D $6FC5 Note the copious amounts of register swapping! These annotations need checking.
R $6FC5 Input:IX Laser beam object
@ $6FC5 label=LaserBeamAnimate
  $6FC5,3 Laser Y position
  $6FC8,3 Laser X position: pulse #1
  $6FCB,4 Jump if bit-2 is reset
  $6FCF,1 #REGl=X position: pules #1
  $6FD2,6 Negate (#REGa=$F8) if bit-0 of pulse #1 is reset
  $6FD8,3 #REGh=laser Y position, #REGl=updated X position
  $6FDB,1 Preserve #REGhl - pulse Y,X position
  $6FDC,3 #REGhl=coord to screen address (using #REGhl)
  $6FDF,3 Laser Y position
  $6FE2,4 Jump if Y position >= 128
  $6FE6,1 #REGa=byte at Y,X position of laser pulse #1
  $6FE8,2 Jump if byte is empty
N $6FEA Update the on screen colour for the pulse.
  $6FEA,3 Update X position: pulse #1
  $6FED,2 Add a "full length" pulse to Y,X position
  $6FEF,1 Restores the pulse Y,X positions
  $6FF0,3 #REGhl=coord to attribute file address (using #REGhl)
  $6FF3,4 Set screen colour attribute to the laser pulse colour
  $6FF7,8 Subtract 8 from laser pulse "length"
  $7001,2 Jump if pulse length has bit 3-7 set
N $7003 Update the X position of all the laser beam pulses.
  $7003,4 Reset bit-2 of X position: pulse #1
  $700B,2 Loop counter (14)
  $700E,2 Loop counter (to process pulses #2, #3, #4)
  $7010,3 #REGbc is now the laser beam object
  $7013,1 Laser beam Y position
  $7014,1 Laser beam X position: pulse #1
  $7015,1 Laser beam X position: pulse #2
N $7016 A loop (to the end of routine) which draws the pixel byte to the screen.
  $7016,1 #REGa=X position (loops on pulse #2, #3, #4)
  $7017,3 XOR with X position: pulse #1
  $701C,2 Jump if #REGa has any of these bits set
  $7023,4 Repeat for next X position pulse
  $7027,4 Set laser beam to "unused"
N $702C No pixel to draw, loop back and process next pulse.
N $702F Update the length of the laser beam pulse.
  $702F,1 Laser beam X position
  $7030,4 Jump if bit-2 is set
  $7034,3 Decrement pulse length
  $703A,3 Return if pulse has any pixels set?
  $703D,3 Random number
  $7040,10 Calculate the length of the laser pulse
  $704A,4 Current X position += 4
  $7050,1 #REGl=current X position pulse
  $7053,6 Negate (#REGa=$F8) if bit-0 of pulse is reset
  $705A,1 Update current X position
  $705B,1 #REGh=laser Y position, #REGl=updated X position
  $705C,3 #REGhl=coord to screen address (using #REGhl)
N $7064 Create a new laser beam pixel and merge with current screen pixel.
  $7064,1 Create the pixel byte. E.g. $FC=11111100
  $7065,1 Merge with current screen pixel
  $7066,1 Update display file
  $7067,2 Next X position byte
  $7069,3 Repeat if counter > 0
c $706D Display the remaining player lives in the status bar.
D $706D Used by the routines at #R$6094, #R$6174 and #R$66d0.
@ $706D label=DisplayPlayerLives
  $706D,3 Screen column for Player 1
  $7070,3 #REGhl=coord to screen address (using #REGhl)
  $7073,3 #REGa=Get player 1 lives count
  $7077,2 Display empty space if no lives remaining
  $7079,3 Display lives counter and icon sprite
N $707C Now display lives for inactive player.
  $707C,3 Screen column for Player 2
  $707F,3 #REGhl=coord to screen address (using #REGhl)
  $7082,3 #REGa=Get player 2 lives count
  $7086,2 Display empty space if no lives remaining
N $7088 Displays the lives count and sprite icon.
  $7088,2 ASCII character starting at `0` character
  $708A,3 Display font character
  $708D,3 Sprite for the lives icon
  $7092,3 Now display the number of lives
N $7095 Current player has no lives remaining, display spaces.
  $7095,3 Display " " for no lives
  $7098,2 Display inactive player lives count
N $709A Display just spaces instead of number + sprite.
  $709C,3 Display " " font character
  $70A1,3 Display " " font character
b $70A4 Icon sprite of the little person shown next to number of lives.
@ $70A4 label=tile_life_icon
  $70A4,8,8
c $70AC Gets the remaining lives for player 1.
D $70AC Used for displaying the player lives in the status bar.
R $70AC Output:A Is the number of lives remaining
@ $70AC label=P1GetLifeCount
  $70AC,3 Current player number
  $70B0,2 If not current player, use inactive player
c $70B2 Reads the current player lives.
D $70B2 Used by the routine at #R$70ba.
@ $70B2 label=CurrentPlayerLifeCount
  $70B2,3 Current player lives remaining
c $70B6 Reads inactive player lives.
D $70B6 Used by the routines at #R$70ac and #R$70ba.
@ $70B6 label=InactivePlayerLifeCount
  $70B6,3 Inactive player lives remaining
c $70BA Gets the remaining lives for player 2.
D $70BA Used for displaying the player lives in the status bar.
R $70BA Output:A Is the number of lives remaining
@ $70BA label=P2GetLifeCount
  $70BA,3 Current player number
  $70BE,2 If not current player, use inactive player
  $70C0,2 else get current player lives
c $70C2 Add points to the active player's score.
D $70C2 Used by the routines at #R$63a3, #R$6461, #R$6523, #R$6a35, #R$6beb, #R$6d5c and #R$6d9c.
R $70C2 Input:C The number of points (in decimal) to be added to the score.
@ $70C2 label=AddPointsToScore
  $70C2,6 Use player 2 score if current player is 2
@ $70C8 ssub=ld hl,$5cf4+$02 ; #REGhl=Player 1 score byte #3
@ $70CD ssub=ld hl,$5cf7+$02 ; #REGhl=Player 2 score byte #3
N $70D0 Add the points to the current score.
  $70D0,4 Update score byte #3, with BCD conversion
  $70D5,4 Update score byte #2, with BCD conversion
  $70DA,5 Update score byte #1, with BCD conversion
  $70DF,6 Jump and show player 2 score if current player is 2, else show player 1
c $70E5 Updates display to show player 1 score.
D $70E5 Used by the routine at #R$6064.
@ $70E5 label=ShowScoreP1
  $70E5,3 Screen address for score text
  $70E8,3 3-byte score value
  $70EB,2 Display a score
c $70ED Updates display to show player 2 score.
D $70ED Used by the routines at #R$6064 and #R$70c2.
@ $70ED label=ShowScoreP2
  $70ED,3 Screen address for score text
  $70F0,3 3-byte score value
  $70F3,2 Display a score
c $70F5 Updates display to show high score.
D $70F5 Used by the routine at #R$6064.
@ $70F5 label=ShowScoreHI
  $70F5,3 Screen address for score text
  $70F8,3 3-byte hi score value
c $70FB Display a score.
D $70FB Scores are stored as decimal values in 3-bytes (making 999999 the maximum score). A score of 15,120 decimal is stored in hex as: $01,$51,$20. This routine displays each byte (reading left-to-right) of the score in two steps.
R $70FB Input:HL Screen address of the score to be written.
R $70FB DE The 3-byte score value (P1, P2, HI).
@ $70FB label=DisplayScore
  $70FB,2 Loop counter for the 3 bytes
  $70FD,1 Score value. Example, if 85 points:
  $70FE,1 A=11000010, C=1
  $70FF,1 A=01100001, C=0
  $7100,1 A=10110000, C=1
  $7101,1 A=01011000, C=0
  $7102,2 A=00001000
  $7104,2 A=00111000 - $30 + $08 = ASCII char `8`
  $7106,3 Display font character
  $7109,1 And again with the same byte:
  $710A,2 A=00000101
  $710C,2 A=00110101 - $30 + $05 = ASCII char `5`
  $710E,3 Display font character
  $7111,3 Process next score byte
c $7115 Display an ASCII character from the Font.
D $7115 An ASCII 8x8 tile graphic is fetched from the font data and drawn to the screen. As HL is multiplied by 3 a 256 bytes offset must first be subtracted.
R $7115 Input:A Character (Z80 ASCII) used to fetch the character from the font.
R $7115 HL Screen address where character should be drawn.
R $7115 Output:HL Location for the next location character.
@ $7115 label=DrawFontChar
  $7118,1 #REGl=ASCII value
  $711B,3 Calculate correct offset for ASCII character
@ $711E ssub=ld de,$9ab3-$0100 ; #REGde=base address of the font data - 256 bytes
  $7121,1 #REGhl += base address
  $7122,1 Store the character address in #REGde
  $7123,1 Restore #REGhl
c $7124 Characters are 8 rows of pixels.
D $7124 Used by the routine at #R$706d.
  $7124,2 Loop counter
c $7126 Draw the pixels for an ASCII character on screen
D $7126 Used by the routine at #R$76a6.
R $7126 Input:B Loop counter for no. of pixel rows - is always $08!
R $7126 DE Address for desired character from the font set.
R $7126 HL Display address for where to draw the character.
R $7126 Output:HL Next character location.
@ $7126 label=DrawCharPixels
  $7126,1 Current byte from the font character
  $7127,1 Write byte to screen
  $7128,1 Next row of font pixels
  $7129,1 Next pixel line
  $712A,2 Repeat until 8x8 char displayed
  $712E,4 Reset display line
  $7132,1 Increment column
c $7134 Display string (with colour) on the screen.
D $7134 Calculates the start location in the DISPLAY/ATTRIBUTE files for writing the string, then executes WriteAsciiChars, which writes each individual character to the screen.
R $7134 Input:DE Text data block (expects first byte to be a colour attr).
R $7134 HL Screen address for writing the text.
R $7134 Output:A' Colour attribute for the text.
R $7134 DE' Address to the ASCII characters for displaying.
R $7134 HL' Screen address of next location.
R $7134 HL Attribute file address of next location.
@ $7134 label=DisplayString
  $7134,1 Preserve display file address
  $7135,3 #REGhl=coord to screen address (using #REGhl)
  $7138,2 #REGa'=colour attribute
  $713A,1 #REGde=next colour attribute
  $713C,1 Set #REGhl back to screen address
  $713D,3 #REGhl=coord to attribute file address (using #REGhl)
c $7140 Write a list of ASCII characters to the screen.
D $7140 Used by the routine at #R$62ca.
R $7140 Input:A' Colour byte for the entire string.
R $7140 DE' Address to a list of ASCII character to display.
R $7140 HL' Display file address for writing the string.
R $7140 HL Attribute file address for writing the colour byte.
@ $7140 label=WriteAsciiChars
  $7141,1 #REGa=ASCII character value
  $7142,4 If EOL byte then extract and display character
  $7146,3 Display font character
  $7149,1 Get next character
  $714C,1 Write the colour attribute
  $714D,1 Next column
  $714E,1 Put colour attribute back in #REGa'
  $714F,2 Loop back and display next character
c $7151 Write an EOL character to the screen.
D $7151 Game strings (e.g. score labels) set bit-7 on the last character to indicate it is EOL. This bit needs to be reset before displaying the character on the screen.
R $7151 Input:A' Colour byte for the character.
R $7151 A The EOL ASCII character to be displayed.
R $7151 HL Screen address for writing the string.
R $7151 HL' Attribute file address for writing the colour byte.
@ $7151 label=WriteEOLChar
  $7151,2 Turn off the EOL flag: bit-7
  $7153,3 Display font character
  $7158,1 Write the colour byte
c $715A Displays score labels at top of screen.
D $715A Used by the routine at #R$6064.
@ $715A label=DrawStatusBarLabels
  $715A,9 Display "1UP" text at column 24
  $7163,9 Display "HI" text at column 120
  $716C,9 Display "2UP" text at column 216
b $7175 "1UP" score label - colour byte followed by ASCII characters.
@ $7175 label=Labels1UP
  $7175,4,4
b $7179 "2UP" score label - colour byte followed by ASCII characters.
@ $7179 label=Labels2UP
  $7179,4,4
b $717D "HI" score label - colour byte followed by ASCII characters.
@ $717D label=LabelsHI
  $717D,3,3
c $7180 Clears the entire ZX Spectrum display file.
D $7180 Used by the routine at #R$6064.
@ $7180 label=ClearScreen
  $7180,3 Beginning of display file
  $7183,2 MSB to stop at (end of display file)
c $7185 Clear memory block with null.
D $7185 Used by the routine at #R$62fe.
R $7185 Input:B Loop counter: the MSB of the address to stop at.
R $7185 HL Start address to begin filling.
@ $7185 label=ClearMemoryBlock
  $7185,2 Byte to use for the fill
c $7187 Fill a memory block with a byte value.
D $7187 Used by the routine at #R$718e.
R $7187 Input:B Loop counter: the MSB of the address to stop at.
R $7187 C Fill byte.
R $7187 HL Start address to begin filling.
@ $7187 label=MemoryFill
  $7187,1 Write the fill byte
  $718B,2 Repeat until #REGh matches #REGb
c $718E Clears the entire ZX Spectrum attribute file.
D $718E PAPER=black, INK=white.
@ $718E label=ClearAttrFile
  $718E,3 Attribute file
  $7191,2 MSB to stop at (end of attribute file)
  $7193,2 Colour byte: PAPER=black, INK=white, BRIGHT
  $7195,2 Fill memory
c $7197 Colourize a sprite.
D $7197 Using Actor, adds colour to a sprite, working from bottom-to-top, left-to-right. This also handles sprites that are wrapped around the screen. Used by the routines at #R$63a3, #R$64a4, #R$650e, #R$6514, #R$6632, #R$66fc, #R$687a, #R$6d43, #R$6d9c and #R$7492.
R $7197 Input:IX Jetman/Alien object.
@ $7197 label=ColourizeSprite
  $7198,3 #REGhl=actor coords
  $719B,3 #REGhl=coord to attribute file address (using #REGhl)
@ $719E ssub=ld a,($5dc0+$04) ; Actor state "width"
  $71A1,1 #REGb=width loop counter (in pixels)
@ $71A2 ssub=ld a,($5dc0+$03) ; Actor state "height"
  $71AC,1 #REGc=height loop counter (in pixels)
  $71AD,3 #REGd=object colour attribute
  $71B0,1 #REGe=width loop counter (in pixels)
N $71B2 Loop for updating attribute file with colour.
  $71B2,1 #REGa=actor Y position
  $71B3,8 Decrement position if address is outside of attribute file address range
  $71BB,1 Otherwise, set the colour at this location
  $71BC,1 Next tile column
  $71BD,5 Next tile if column < screen width (32 chars)
  $71C2,1 else, wrap-around and continue applying colour
  $71C5,1 #REGl=start of current row
  $71C6,2 Loop back and continue with next tile
N $71C8 Decrement the vertical position and colour the tiles.
  $71CA,1 Clear Carry flag
  $71CB,5 #REGhl -= 32 tiles. Places address pointer previous line
  $71D1,1 #REGb=reset to original width counter
  $71D2,1 Decrement height counter
  $71D3,2 Repeat until all tiles have been coloured
c $71D6 Convert a Y,X pixel coordinate to an ATTRIBUTE_FILE address.
D $71D6 Used by the routines at #R$61a0, #R$61ad, #R$62ca, #R$6fc5, #R$7134, #R$7197 and #R$7638.
R $71D6 Input:H Vertical coordinate in pixels (0-191).
R $71D6 L Horizontal coordinate in pixels (0-255).
R $71D6 Output:HL An address in the attribute file.
@ $71D6 label=Coord2AttrFile
  $71D6,1 Horizontal coordinate. Example, if $B8:
  $71D7,1 A=01011100, C=0
  $71D8,1 A=00101110, C=0
  $71D9,1 A=00010111, C=0
  $71DA,2 A=00010111 <- screen width?
  $71DC,1 #REGl=$17
  $71DD,1 Vertical coordinate. Example, if $68:
  $71DE,1 A=00110100, C=0
  $71DF,1 A=00011010, C=0
  $71E0,1 Backup value to #REGc
  $71E1,2 A=00000000
  $71E3,1 A=00010111
  $71E4,1 #REGl=$17 <- new LSB of attribute file
  $71E5,1 Restore the row value
  $71E6,2 A=00000010 <- top of screen?
  $71E8,2 A=01011010
  $71EA,1 #REGh=$5A <- ATTRIBUTE_FILE address (>= 5800)
  $71EB,1 Return #REGhl=5A17
c $71EC Sprite finder generic jump routine.
D $71EC Used by the routines at #R$7232 and #R$726d.
  $71EC,3 Find sprite using Actor
c $71EF Get location of Actor
D $71EF Used by the routines at #R$7226 and #R$7268.
  $71EF,3 #REGhl=Actor.X/Y position
c $71F2 Get sprite position and dimensions.
D $71F2 Note: the sprite header byte is added to the X position. So the question is: what is this header byte really for? Used by the routine at #R$687a.
R $71F2 Input:DE Address to the start of a Sprite or Buffer.
R $71F2 HL The Y,X coordinate of the sprite.
R $71F2 Output:B Is the sprite width.
R $71F2 C Is always NULL.
R $71F2 HL Screen address of sprite.
R $71F2 DE Address pointing to the pixel data block.
@ $71F2 label=GetSpritePosition
  $71F2,1 #REGa=header byte
  $71F3,1 #REGde=width byte
  $71F4,2 #REGl=X column + header byte
  $71F6,3 #REGhl=coord to screen address (using #REGhl)
  $71F9,2 #REGb=sprite width
  $71FB,2 #REGa=sprite height
@ $71FD ssub=ld ($5dc0+$05),a ; Set Actor current sprite height to this sprite height
c $7200 Increment Sprite/Buffer address location.
D $7200 Used by the routine at #R$7207.
  $7202,1 #REGde=first byte of pixel data
c $7204 Sprite finder from X position.
D $7204 Used by the routines at #R$7232 and #R$727d.
  $7204,3 Find sprite address using X position.
c $7207 Update Actor.
D $7207 Get sprite position/dimensions, and update actor. Used by the routines at #R$7226 and #R$7263.
R $7207 Input:DE Address to the start of a Sprite or Buffer.
R $7207 IX Actor object for a fuel pod, collectible, etc.
R $7207 Output:B Is the sprite width.
R $7207 C Is always NULL.
R $7207 HL Screen address of sprite.
R $7207 DE Address pointing to the pixel data block.
@ $7207 label=ActorUpdate
  $7207,3 #REGl=actor X location
  $720A,3 #REGh=actor Y location
  $720D,1 #REGa=sprite header byte
  $720E,1 #REGde=sprite width byte
  $720F,2 #REGl=X column + header byte
  $7211,3 Set actor_coords variable with these actor coordinates
  $7214,3 #REGhl=coord to screen address (using #REGhl)
  $7217,2 #REGb=sprite width
@ $7219 ssub=ld ($5dc0+$04),a ; Actor width=sprite width
  $721C,2 #REGa=sprite height
@ $721E ssub=ld ($5dc0+$06),a ; Set Actor sprite height
@ $7221 ssub=ld ($5dc0+$03),a ; Set Actor height to sprite height
  $7224,2 Set return values (#REGde points to sprite pixel data)
c $7226 Update Actor X/Y positions.
D $7226 Used by the routines at #R$64a4 and #R$66fc.
@ $7226 label=ActorUpdatePosition
  $7227,3 #REGhl=Get sprite position
  $722C,3 Update actor
  $7230,2 Erase actor sprite
c $7232 Now update and erase the actor.
D $7232 Used by the routines at #R$63a3, #R$650e, #R$6d43, #R$6d9c and #R$7492.
  $7232,3 Find sprite using X position and update actor
  $7236,3 Find sprite using actor and get address
c $7239 Erase Actor sprite from old position.
D $7239 Used by the routine at #R$7226.
R $7239 Input:IX Actor object.
@ $7239 label=ActorEraseSprite
@ $7239 ssub=ld a,($5dc0+$01) ; #REGa=actor Y position
  $723C,3 Subtract the actor Y position
  $723F,3 Update actor size if 0
  $7242,3 Jump if result is negative
  $7245,1 else #REGc=result
@ $7246 ssub=ld a,($5dc0+$05) ; #REGa=actor current sprite height
  $724A,3 Update actor size if REGa < #REGc
  $724D,1 else subtract #REGc
@ $724E ssub=ld ($5dc0+$05),a ; Update actor current sprite height
  $7251,3 Mask sprite pixels
@ $7258 ssub=ld a,($5dc0+$06) ; #REGa=actor sprite height
  $725C,3 Update actor size if < #REGc
  $7260,3 Erase sprite pixels
c $7263 Find animation sprite position and erase its pixels.
D $7263 Used by the routines at #R$6514, #R$6632 and #R$687a.
@ $7263 label=ActorEraseAnimSprite
  $7263,3 Update the Actor
  $7266,2 Erase sprite pixels
c $7268 Find Actor position, then erase its sprite.
D $7268 Used by the routines at #R$6461 and #R$6632.
@ $7268 label=ActorDestroy
  $7268,3 Get sprite position
  $726B,2 Erase a destroyed actor
c $726D Find an Actor and destroy it.
D $726D Used by the routines at #R$6523, #R$6565, #R$66d0 and #R$687a.
@ $726D label=ActorFindDestroy
  $726D,3 Find sprite and sprite position
c $7270 Erase a destroyed Actor.
D $7270 Used by the routines at #R$687a and #R$7268.
@ $7270 label=ActorEraseDestroyed
@ $7273 ssub=ld ($5dc0+$06),a ; Actor sprite height = $00
@ $7276 ssub=ld ($5dc0+$03),a ; Actor "height" = $00
  $727A,3 Mask sprite pixels
c $727D Unused?
c $7280 Erase a sprite.
D $7280 Used by the routine at #R$7263.
@ $7282 ssub=ld ($5dc0+$05),a ; Actor current sprite height = $00
  $7285,1 #REGc = $00
  $7286,3 Mask sprite pixels
c $7289 Find position and direction of an Actor.
D $7289 Used by the routine at #R$71ec.
@ $7289 label=ActorFindPosDir
  $7289,3 #REGa=actor X position
@ $728F ssub=ld a,($5dc0+$02) ; #REGa=actor movement direction
c $7292 Get actor sprite address.
D $7292 Used by the routine at #R$72ab.
R $7292 Input:A Sprite header byte or Actor movement.
R $7292 C Sprite header byte or X position.
R $7292 Output:DE Address for sprite.
@ $7292 label=ActorGetSpriteAddress
  $7292,6 If bit-6 is set, then set bit 3 of #REGc
  $7298,8 Calculate offset for sprite lookup table
  $72A1,2 #REGbc=sprite lookup table offset
  $72A3,3 #REGhl=start of Jetman/Buffer sprite lookup tables
  $72A7,3 #REGde=sprite address
c $72AB Get actor sprite address from X position.
D $72AB Used by the routine at #R$7204.
@ $72AB label=ActorGetSpriteAddressPosX
  $72AB,3 #REGa=X position
  $72B1,3 #REGa=sprite header byte
  $72B4,2 Get sprite address
c $72B6 Related to erasing and masking sprites.
D $72B6 Used by the routine at #R$7705.
R $72B6 Input:HL Current position.
R $72B6 Output:HL Address for new position.
@ $72B6 label=EraseSpritesHelper
s $72CB Unused code.
  $72CB,5,$05
c $72D0 Convert a Y,X pixel coordinate to a DISPLAY_FILE address.
D $72D0 Used by the routines at #R$62ca, #R$6fc5, #R$706d, #R$7134, #R$71f2, #R$7207 and #R$7638.
R $72D0 Input:H Vertical position in pixels (0-191).
R $72D0 L Horizontal position in pixels (0-255).
R $72D0 Output:HL An address in the display file.
@ $72D0 label=Coord2Scr
  $72D0,1 Horizontal coordinate. Example, if $B8:
  $72D1,1 A=01011100, C=0
  $72D2,1 A=00101110, C=0
  $72D3,1 A=00010111, C=0
  $72D4,2 A=00010111 <- screen width?
  $72D6,1 #REGl=$17
  $72D7,1 Vertical coordinate. Example, if $68:
  $72D8,1 A=00110100, C=0
  $72D9,1 A=00011010, C=0
  $72DA,2 A=00000000
  $72DC,1 A=00010111
  $72DD,1 #REGl=$17 <- new LSB of attribute file
  $72DE,1 Vertical coordinate. Example, if $68:
  $72DF,2 A=00000100
  $72E1,1 Puts the value into the shadow register
  $72E2,1 Vertical coordinate. Example, if $68:
  $72E3,1 A=00110100, C=0
  $72E4,1 A=00011010, C=0
  $72E5,1 A=00001101, C=0
  $72E6,2 A=00001000
  $72E8,2 A=00101000
  $72EA,1 #REGhl=$48
  $72EB,1 Get the shadow register value
  $72EC,1 A=00101100
  $72ED,1 #REGh=$4C <- DISPLAY_FILE address (>= 4000)
  $72EE,1 Return #REGhl=4C68
c $72EF Copy actor position/direction values to Actor.
D $72EF Used by the routines at #R$6461, #R$64e8, #R$6523, #R$6690, #R$66b4, #R$66d0, #R$687a, #R$6cb0, #R$6d9c, #R$739e and #R$753c.
R $72EF Input:IX Jetman object.
@ $72EF label=ActorUpdatePosDir
  $72EF,6 Actor X position = Jetman X position
@ $72F8 ssub=ld ($5dc0+$01),a ; Actor Y position = Jetman Y position
@ $72FE ssub=ld ($5dc0+$02),a ; Actor movement = Jetman direction
c $7302 Joystick Input (Interface 2)
D $7302 The ROM cartridge was made for the Interface 2 which reads the Joystick I bits in the format of 000LRDUF, which are mapped to the keyboard keys: 6, 7, 8, 9, and 0. Note that a reset bit means the button is pressed.
R $7302 Used by the routines at #R$7309, #R$733f, #R$735e and #R$743e.
N $7302 Output:A Joystick direction/button state.
@ $7302 label=ReadInterface2Joystick
  $7302,2 Interface 2 Joystick port
  $7306,2 #REGa = bits for 000LRDUF
c $7309 Read input from the keyboard port.
D $7309 Used by the routines at #R$739e and #R$753c.
R $7309 Output:A direction values $EF (L), $F7 (R) like joystick: 000LRDUF.
@ $7309 label=ReadInputLR
  $7309,3 Game options
  $730C,4 Read Joystick if option set
  $7310,6 Start reading the keyboard port (254)
  $7318,4 Read input again if 30
  $7320,2 Set direction to left
  $7322,2 else, must be right
N $7324 Reading the input again.
  $7324,6 Read input port 254...again
  $732C,4 No input detect if 30
  $7332,4 Set direction to right, else input is left
  $7336,2 #REGa=LEFT_KEY  : 1110 1111
  $7339,2 #REGa=RIGHT_KEY : 1111 0111
  $733C,2 #REGa=NO INPUT DETECTED
c $733F Check if fire button is pressed.
D $733F Used by the routine at #R$7492.
R $733F Output:A fire button - Pressed = $FE like joystick: 000LRDUF.
@ $733F label=ReadInputFire
  $733F,3 Game options
  $7342,4 Read Joystick if option set
  $7346,2 Read keyboard twice
N $734A Start reading the keyboard port (254).
  $7352,2 Fire button pressed?
  $7356,2 Read input again with new #REGa
  $7358,2 No input detected
  $735B,2 #REGa=FIRE : 1111 1110
c $735E Check if thrust (up) button is pressed.
D $735E Used by the routines at #R$7412 and #R$753c.
R $735E Output:A thrust button - Pressed = $FD like joystick: 000LRDUF.
@ $735E label=ReadInputThrust
  $735E,3 Game options
  $7361,4 Read Joystick if option set
  $7365,2 Read keyboard twice
N $7369 Start reading the keyboard port (254).
  $7371,2 Thrust button pressed?
  $7375,2 Read input again with new #REGa
  $7377,2 No input detected
  $737A,2 #REGa=THRUST (up) : 1111 1101
c $737D Game play starts, or prepare new turn, or check Jetman thrust input.
@ $737D label=GamePlayStarts
  $737D,7 If begin play delay timer is zero (turn started), check to see if player is thrusting
  $7384,1 else decrement timer
  $7385,3 Flash Score label if still not zero
  $7388,3 SFX to indicate play is about to start!
  $738B,6 Stop flashing 2UP if current player number is 2
  $7391,6 Stop flashing "1UP" text
  $7397,2 Check if player is thrusting
  $7399,5 Stop flashing "2UP" text
c $739E Airborne Jetman update.
D $739E Read thrust/direction controls and update position accordingly. Used by the routine at #R$737d.
R $739E Input:IX Jetman object.
@ $739E label=JetmanFlyThrust
  $739E,3 Update actor position direction
  $73A1,3 Read Left/Right input
  $73A4,5 Update Jetman direction for THRUST RIGHT
  $73A9,5 Jetman thrust left
  $73AE,3 Game timer
  $73B1,4 If bit-0 is reset, fly horizontal
  $73B5,3 Calculate new horizontal speed
  $73B8,4 Set Jetman direction to be "right"
  $73BC,7 Flip direction if currently moving left
c $73C3 Increase Jetman horizontal speed.
D $73C3 Input:IX Jetman object.
@ $73C3 label=JetmanFlyIncSpdX
  $73C3,3 Jetman speed modifier ($00 or $04)
  $73CA,3 #REGa += Jetman X speed
  $73CF,2 Jump if speed >= max
c $73D1 Update Jetman X speed with new value.
D $73D1 Used by the routines at #R$750c and #R$752d.
  $73D1,3 Update Jetman X speed with #REGa (will be < 64)
  $73D4,2 Fly horizontally
c $73D6 Set Jetman X speed to the max flying speed.
D $73D6 Used by the routine at #R$73c3.
c $73DA Fly Jetman horizontally.
D $73DA Used by the routines at #R$739e, #R$73d1 and #R$750c.
R $73DA Input:IX Jetman object.
R $73DA Output:H New X position.
R $73DA L New Thrust value.
@ $73DA label=JetmanFlyHorizontal
  $73DC,3 Jetman X speed (will be <= 64)
  $73DF,3 Multiply X speed by 3
  $73E2,3 #REGd=Jetman X position
@ $73E5 ssub=ld a,($5dc0+$07) ; Actor thrust
  $73E9,7 Decrease Jetman X position if moving right
  $73F0,1 else, increase X position
c $73F1 Apply gravity to Jetman if no thrust button detected.
D $73F1 Used by the routine at #R$74fa.
R $73F1 Input:IX Jetman object.
R $73F1 H New X position.
R $73F1 L New Thrust value.
@ $73F1 label=JetmanApplyGravity
@ $73F2 ssub=ld ($5dc0+$07),a ; Update Actor thrust
  $73F5,3 Set new Jetman X position
N $73F8 Short circuit thrust button check.
  $73F8,3 Game options
  $73FB,5 Read Joystick if option set
  $7400,2 Check input counter
  $7404,4 Read input port 254
  $740A,4 No thrust so set vertical speed to zero
  $740E,2 #REGa=THRUST
  $7410,2 Check input again
c $7412 Check if Jetman is moving falling downward.
D $7412 Used by the routine at #R$743e.
@ $7412 label=JetmanFlyCheckFalling
  $7412,3 Check if THRUST button pressed
  $7415,5 Set Jetman to down position if not thrusting
  $741A,8 Jetman direction is DOWN or WALKing
  $7422,3 Flip vertical direction if moving down
c $7425 Increase Jetman vertical speed.
D $7425 Used by the routine at #R$74d5.
@ $7425 label=JetmanSpeedIncY
  $7425,3 Jetman speed modifier ($00 or $04)
  $742C,3 #REGa += Jetman Y speed
  $7431,2 Set vertical speed to max if >= 63
c $7433 Update Jetman vertical speed with new value.
D $7433 Used by the routine at #R$74e0.
  $7433,3 Y speed = #REGa (is < 63)
  $7436,2 Update vertical flying
c $7438 Set Jetman vertical speed to zero.
D $7438 Used by the routines at #R$73f1 and #R$743e.
  $7438,4 Jetman Y speed is zero
  $743C,2 Update vertical flying
c $743E Check joystick input for FIRE or THRUST.
D $743E Used by the routine at #R$73f1.
@ $743E label=JetmanFlyCheckThrusting
  $743E,3 Read Joystick
  $7441,5 Set Y speed to zero if not thrusting
  $7446,2 else check if falling and update movement
c $7448 Set Jetman vertical speed to maximum.
D $7448 Used by the routine at #R$7425.
  $7448,4 Set Jetman Y speed to 63
c $744C Fly Jetman vertically.
D $744C Input:IX Jetman object.
@ $744C label=JetmanFlyVertical
  $744C,3 #REGl=Jetman Y speed (will be <= 63)
  $7451,3 Multiply vertical X speed by 3
  $7454,3 #REGd=Jetman Y position
  $7457,4 #REGe=Jetman flying counter
  $745B,7 Move Jetman up if moving up
  $7462,1 else move downwards
c $7463 Check vertical position while in mid-flight.
D $7463 Used by the routine at #R$7526.
@ $7463 label=JetmanFlyCheckPosY
  $7463,4 Update Jetman flying counter
  $7467,3 Update Jetman Y position
  $746D,2 Move up if within screen limits: 42 to 192
  $7471,2 Check if hit top of screen
c $7473 Jetman flight collision detection.
D $7473 Input:IX Jetman object.
@ $7473 label=JetmanCollision
  $7473,3 Platform collision detection (returns #REGe)
  $7476,4 Redraw Jetman if bit-2 has not been set
  $747A,5 Jetman lands on top of a platform
  $747F,4 Jetman hits bottom of a platform
N $7483 Jetman hits platform edge.
  $7484,5 Update #REGe to be either $00 or $40.
  $7489,9 Update Jetman moving direction
c $7492 Redraw Jetman sprite on the screen.
D $7492 Every time this function is called, a check is also made to see if the player is pressing the fire button, and draws a laser beam if so.
@ $7492 label=JetmanRedraw
  $7492,3 Update and erase the actor
  $7495,3 Colour the sprite
  $7498,3 Read the input for a FIRE button
  $749D,3 If pressed, Fire laser (if free slot is available)
c $74A1 Jetman hits the underneath of a platform.
D $74A1 Used by the routine at #R$7473.
@ $74A1 label=JetmanBumpsHead
  $74A1,4 Set Jetman to be moving down
  $74A5,2 Redraw Jetman
c $74A7 Jetman lands on a platform.
D $74A7 Used by the routine at #R$7473.
@ $74A7 label=JetmanLands
  $74A7,4 Set Jetman to be standing still
  $74AB,3 Jetman direction
  $74AE,2 Reset FLY and WALK bits
  $74B0,2 Now set movement to WALK
  $74B2,3 Update Jetman direction to be walking
  $74B5,4 Set Jetman X speed to stopped
  $74B9,4 Set Jetman Y speed to stopped
  $74BD,2 Redraw Jetman
c $74BF Reset Jetman movement direction.
D $74BF Used by the routine at #R$7463.
@ $74BF label=JetmanSetMoveUp
  $74BF,4 Set Jetman to be moving up
  $74C3,2 Jetman flight collision detection
c $74C5 Jetman hits the top of the screen.
D $74C5 Used by the routine at #R$7463.
@ $74C5 label=JetmanHitScreenTop
  $74C5,4 Set Jetman to be moving down
  $74C9,3 Jetman Y speed
  $74CE,2 Jetman collision detection if #REGa was $00 or $01
  $74D0,3 Update Jetman Y speed
  $74D3,2 Jetman flight collision detection
c $74D5 Jetman is falling.
D $74D5 Used by the routine at #R$7412.
@ $74D5 label=JetmanSetMoveDown
  $74D5,4 Set Jetman direction to WALK/DOWN
  $74D9,7 Increment Jetman Y speed if moving down
c $74E0 Flip vertical direction Jetman is flying.
D $74E0 Used by the routine at #R$7412.
@ $74E0 label=JetmanDirFlipY
  $74E0,3 Jetman speed modifier ($00 or $04)
  $74E3,2 #REGa=$F8 or $FC
  $74E5,3 #REGa += Jetman Y speed
  $74E8,3 Update vertical speed if new speed is positive
  $74EB,4 else set Y speed to zero
  $74EF,8 Flip Jetman vertical moving direction
  $74F7,3 Fly Jetman vertically
c $74FA Decrease Jetman X position.
D $74FA Used by the routine at #R$73da.
@ $74FA label=JetmanFlyDecreasePosX
  $74FA,1 Reset Carry flag
  $74FE,3 Update Jetman speed/dir if thrusting
c $7501 Jetman THRUST-LEFT input.
D $7501 Used by the routine at #R$739e.
@ $7501 label=JetmanFlyThrustLeft
  $7501,4 Set Jetman direction to be LEFT
  $7505,7 Increase Jetman X speed if moving RIGHT
c $750C Flip Jetman left/right flying direction.
D $750C Used by the routine at #R$739e.
@ $750C label=JetmanDirFlipX
  $750C,3 Jetman speed modifier ($00 or $04)
  $750F,2 #REGa=$F8 or $FC
  $7511,3 #REGa += Jetman X speed
  $7514,3 Update horizontal speed if new speed is positive
  $7517,4 else set X speed to zero
  $751B,8 Flip Jetman left/right moving direction
  $7523,3 Fly Jetman vertically
c $7526 Move Jetman up: decrease Y position.
D $7526 Used by the routine at #R$744c.
@ $7526 label=JetmanFlyMoveUp
  $7526,1 Reset Carry flag
  $7528,2 Move upwards
  $752A,3 Check vertical position within screen limits
c $752D Calculate new Jetman horizontal speed.
D $752D Used by the routine at #R$739e.
@ $752D label=JetmanFlyCalcSpeedX
  $752D,3 Jetman speed modifier ($00 or $04)
  $7530,2 #REGa=$F8 or $FC
  $7532,3 #REGa += Jetman X speed
  $7535,3 Update horizontal speed if new speed is positive
  $7539,3 Update horizontal speed to zero
c $753C Jetman walking.
D $753C Input:IX Jetman object.
@ $753C label=JetmanWalk
  $753C,3 Update Actor position direction
  $753F,3 Read Left/Right input
  $7542,4 Walk RIGHT
  $7546,5 Walk LEFT
  $754B,4 else set Jetman X speed to zero
  $754F,3 Read THRUST button
  $7552,4 Walk off platform if thrusting
  $7556,3 Platform collision check (returns #REGe)
  $7559,4 Leave platform if bit-2 is reset
  $755D,5 Redraw Jetman if bit-3 is reset
  $7562,3 Jetman X speed
  $7566,3 Redraw Jetman if X speed > 0
  $7569,22 Jetman leaves a platform, either left or right based on the value of bit-6. The X position is dec/inc appropriately, and the Redraw Jetman routine is called. Note also that the X speed is set to max walking speed, but this instruction might be irrelevant as hacking the speed value has no noticeable effect.
N $757F Jetman leaves a platform by thrusters or by walking.
@ $757F label=JetmanWalkOffPlatform
  $757F,3 Jetman direction
  $7582,2 Reset FLY and WALK bits
  $7584,2 Now set movement to FLY
  $7586,3 Update Jetman direction to be flying
  $7589,3 #REGhl=Jetman Y,X position
  $758E,4 #REGix=Jetman thruster animation object
  $7592,6 Jump if thrusters are already being animated
  $7598,4 else set thrusters to be animating?
@ $759C ssub=ld ($5d48+$01),hl ; Update thruster animation Y,X position
  $759F,3 Update actor movement states
  $75A2,2 Restore #REGix to Jetman object
  $75A4,6 Jetman Y position -= 2
  $75AA,3 Redraw Jetman
N $75AD Jetman walks right.
  $75AD,3 Jetman X position += 1
  $75B0,4 Jetman direction is right
  $75B4,4 Jetman moving direction to right
  $75B8,4 Set Jetman X speed to maximum
  $75BC,3 Loop back, checking again for THRUST input
N $75BF Jetman walks left.
  $75BF,3 Jetman X position -= 1
  $75C2,4 Jetman direction is left
  $75C6,4 Jetman moving direction to left
  $75CA,4 Set Jetman X speed to maximum
  $75CE,3 Loop back, checking again for THRUST input
c $75D1 Related to horizontal platform collision detection - possibly flipping between sprite X position collision and Jetman direction collision...needs more work!
D $75D1 Used by the routine at #R$75ed.
R $75D1 Input:A Sprite X position minus Platform X position?
R $75D1 IX Jetman or alien.
  $75D2,3 Jetman/alien direction
  $75D5,2 Value must be <= 63
  $75D7,4 Jump if value == 3 (therefore never when Jetman)
  $75DB,1 Restore #REGa to entry value
  $75DC,2 Vertical collision detection
  $75DE,1 Flip again
  $75E1,7 Vertical collision detection, first incrementing by $09 if #REGa is negative
c $75E8 Jetman/platform collision detection.
D $75E8 NOTE: collision detection is location based not pixel/colour based, so even if platform tiles are not drawn, a collision will be detected! Used by the routines at #R$63a3, #R$6461, #R$64e8, #R$6a35, #R$6ab8, #R$6bf8, #R$6cd7, #R$6d9c, #R$7473 and #R$753c.
R $75E8 Input:IX Jetman or Alien object.
R $75E8 Output:E Collision state.
@ $75E8 label=JetmanPlatformCollision
  $75E8,2 Loop counter (4 platforms to check)
  $75EA,3 Platform location/size params
c $75ED Horizontal platform collision detection for Jetman/Alien.
D $75ED Used by the routine at #R$75fc.
R $75ED Input:HL Address of platform object.
R $75ED IX Jetman or Alien object.
@ $75ED label=JetmanPlatformCollisionX
  $75F0,2 #REGa=Platform X position
  $75F2,3 Subtract Jetman/Alien X position
  $75F5,3 If positive, Horizontal collision detection
  $75FA,2 Set bit-6 and then vertical collision detection
c $75FC Vertical platform collision detection for Jetman/Aliens.
D $75FC Used by the routine at #R$75d1.
R $75FC Input:A Sprite X position.
R $75FC E Collision state on entry.
R $75FC HL Address of platform object.
R $75FC IX Jetman/Alien object.
R $75FC Output:E Collision state. Bit: 7=landed, 4=hits head, 3=?, 2=?.
@ $75FC label=JetmanPlatformCollisionY
  $75FC,1 Platform Y location
  $75FD,1 Platform width
  $75FE,4 X position >= width (no collision) so try next platform
  $7604,6 Set bit 3 if collision: X position >= width
  $760A,1 Platform Y location
  $760B,1 #REGa=platform Y position
  $760C,3 Subtract sprite Y position
  $7611,2 Add 2
  $7613,3 Next platform if no collision: Y position is negative
  $7616,4 #REGa < 2, Landed on platform
  $761A,5 #REGa < sprite height, hits underneath of platform?
  $761F,2 Subtract 2
  $7621,5 Next platform if no collision: Y position >= sprite height
N $7626 Jetman hits the bottom of a platform
  $7628,2 Set bit-2 (4) <- Jetman is leaving a platform?
  $762A,1 Set #REGhl back to beginning of platform object
  $762C,2 Bit-7 indicates landing on a platform
  $7630,1 Set #REGhl back to beginning of platform object
  $7631,4 Increment #REGhl until is points to the start of the next platform sprite
  $7635,2 Loop back until all 4 platforms have been checked
c $7638 Displays platforms on screen.
D $7638 Used by the routine at #R$6094.
@ $7638 label=DrawPlatforms
  $7638,2 Loop counter (4 platforms for draw)
  $763A,3 Platform location/size params
  $763D,1 Backup loop counter
  $763E,5 Process next platform if sprite colour is black/unused
  $7643,2 #REGc=X position
  $7647,1 #REGa=platform width
  $764C,1 #REGa += platform X position
  $764D,2 #REGa += 16
  $7650,2 #REGh=Y position byte
  $7652,1 #REGl=new X position
  $7653,3 #REGhl=coord to screen address (using #REGhl)
  $7656,3 #REGde=address for LEFT platform sprite
  $7659,3 Draw LEFT platform tile pixels
  $765C,9 Does this fetch the platform width value?
  $7665,1 #REGb=loop counter for # of middle platform sprites
  $7666,3 #REGde=address for MIDDLE platform sprite
  $7669,5 Draw (all) MIDDLE platform tiles pixels
  $766E,3 #REGde=address for RIGHT platform sprite
  $7671,3 Draw RIGHT platform tile pixels
  $7675,1 #REGa=platform width
  $767A,1 #REGa += X position
  $767B,2 #REGa += 16
  $767E,2 #REGb=Y position
  $7680,3 #REGc=colour attribute
  $7683,2 #REGhl=Y,X position
  $7686,3 #REGhl=coord to attribute file address (using #REGhl)
  $768A,9 Does this fetch the platform width value?
  $7693,1 #REGb=loop counter for # of middle platform sprites
  $7694,2 Apply platform colour to ATTRIBUTE_FILE
  $7696,1 #REGhl=next sprite position
  $7697,2 Repeat until all sprites are coloured
  $7699,1 Restore #REGhl=platform object at "width" byte
  $769A,1 #REGhl=beginning of next platform struct
  $769B,1 Restore #REGbc for loop counter
  $769C,2 Loop back and processing next platform
N $769E These instructions are only called if current platform colour was black. Why would a platform colour be black?
  $769E,1 restore loop counter
  $769F,4 Place #REGhl to beginning of next platform struct
  $76A3,2 Loop back and process next platform
c $76A6 Draws the pixels for a platform sprite to the screen.
D $76A6 Used by the routine at #R$7638.
@ $76A6 label=DrawPlatformTile
  $76A8,2 Loop counter (8x8 pixel)
  $76AA,3 Draw character pixels for tile
b $76AD Platform sprite: left.
@ $76AD label=tile_platform_left
  $76AD,8,8
b $76B5 Platform sprite: middle (repeated for width).
@ $76B5 label=tile_platfor_mmiddle
  $76B5,8,8
b $76BD Platform sprite: right.
@ $76BD label=tile_platform_right
  $76BD,8,8
w $76C5 Jetman sprite address lookup table.
@ $76C5 label=jetman_sprite_table
  $76C5,2,2 Flying right 1
  $76C7,2,2 Flying right 2
  $76C9,2,2 Flying right 3
  $76CB,2,2 Flying right 4
  $76CD,2,2 Flying left 4
  $76CF,2,2 Flying left 3
  $76D1,2,2 Flying left 2
  $76D3,2,2 Flying left 1
  $76D5,2,2 Walking right 1
  $76D7,2,2 Walking right 2
  $76D9,2,2 Walking right 3
  $76DB,2,2 Walking right 4
  $76DD,2,2 Walking left 4
  $76DF,2,2 Walking left 3
  $76E1,2,2 Walking left 2
  $76E3,2,2 Walking left 1
w $76E5 Buffer sprite lookup table.
D $76E5 NOTE: must directly follow jetman_sprite_table, is not accessed directly.
@ $76E5 label=buffers_lookup_table
  $76E5,2,2 Baddie R1
  $76E7,2,2 Baddie R1
  $76E9,2,2 Baddie R2
  $76EB,2,2 Baddie R2
  $76ED,2,2 Baddie L2
  $76EF,2,2 Baddie L2
  $76F1,2,2 Baddie L1
  $76F3,2,2 Baddie L1
  $76F5,2,2 Item R1
  $76F7,2,2 Item R2
  $76F9,2,2 Item L1
  $76FB,2,2 Item L2
  $76FD,2,2 Item L2
  $76FF,2,2 Item L1
  $7701,2,2 Item R2
  $7703,2,2 Item R1
c $7705 Erase sprite pixels when actor/sprite moves.
D $7705 Used by the routines at #R$7239, #R$7270, #R$7280 and #R$775b.
R $7705 Input:B Loop counter.
R $7705 C Actor Y position, or zero?
R $7705 DE Address into a sprite/buffer.
R $7705 HL Address in the DISPLAY_FILE.
@ $7705 label=MaskSprite
  $7705,4 Jump if vertical position is zero
  $7709,1 else decrement
N $770C Loop to create a mask of the sprite and it write to the screen.
  $770C,1 #REGa=sprite byte
  $770D,3 Create mask and write to screen
  $7710,1 Next byte
  $7711,1 Next column
  $7715,6 If column is zero, subtract 32
  $771B,2 Repeat and process for next byte
  $771D,1 Restore #REGhl to be the display file address
  $771E,3 Calculate new position
  $7722,1 NOTE: what is in C' register before this swap?
  $7723,4 Jump back to the top of routine if #REGc is zero
  $7727,1 else decrement (vertical position?)
N $772A Merging sprite with current on-screen sprite (the mask?)
  $772A,3 Merge with current on-screen byte (mask?)
  $772D,1 Next sprite byte
  $772F,1 #REGa=next column number
  $7732,6 Set #REGl to beginning of line if > 0 && < 32, and repeat process for next byte
  $7738,2 Repeat and process next byte
N $773A Calculate position for next byte?
  $773B,3 Calculate new position
  $7740,2 Loop back to top of routine
  $7743,4 Jump if #REGc != 0
c $7747 EXX then update Actor.
D $7747 Used by the routine at #R$7239.
c $7748 Update Actor height related values.
D $7748 Used by the routine at #R$7239.
@ $7748 label=ActorUpdateSize
@ $7748 ssub=ld a,($5dc0+$05) ; Actor current sprite height
@ $774C ssub=ld a,($5dc0+$06) ; Actor sprite height
  $774F,1 Compare actor sprite height values
  $7750,1 Return if both are zero
@ $7752 ssub=ld ($5dc0+$05),a ; Actor current sprite height = $00
@ $7756 ssub=ld a,($5dc0+$06) ; Actor sprite height
c $775B Update Actor sprite height, then mask the sprite.
D $775B Used by the routine at #R$7239.
@ $775B ssub=ld ($5dc0+$06),a ; Update Actor sprite height
  $775F,2 Mask sprite pixels
> $7761 ; Actor/Collectible sprites start with a 3-byte header.
> $7761 ;
> $7761 ; #TABLE(default,centre,:w)
> $7761 ; { =h Bytes(n) | =h Meaning }
> $7761 ; { 0 | Unknown Header Byte }
> $7761 ; { 1 | Width (tiles) }
> $7761 ; { 2 | Height (pixels)  }
> $7761 ; { 3... | Pixel data  }
> $7761 ; TABLE#
b $7761 Jetman sprite for flying right #1.
@ $7761 label=gfx_jetman_fly_right1
  $7761,1,1 Header byte
  $7762,2,2 Width (tiles), Height (pixels)
  $7764,8,8 Pixel data follows
  $776C,40,8
b $7794 Jetman sprite for flying right #2.
@ $7794 label=gfx_jetman_fly_right2
  $7794,75,1,2,8
b $77DF Jetman sprite for flying right #3.
@ $77DF label=gfx_jetman_fly_right3
  $77DF,75,1,2,8
b $782A Jetman sprite for flying right #4.
@ $782A label=gfx_jetman_fly_right4
  $782A,75,1,2,8
b $7875 Jetman sprite for flying left #1.
@ $7875 label=gfx_jetman_fly_left1
  $7875,51,1,2,8
b $78A8 Jetman sprite for flying left #2.
@ $78A8 label=gfx_jetman_fly_left2
  $78A8,51,1,2,8
b $78DB Jetman sprite for flying left #3.
@ $78DB label=gfx_jetman_fly_left3
  $78DB,75,1,2,8
b $7926 Jetman sprite for flying left #4.
@ $7926 label=gfx_jetman_fly_left4
  $7926,75,1,2,8
b $7971 Jetman sprite for walking left #1.
@ $7971 label=gfx_jetman_walk_left1
  $7971,51,1,2,8
b $79A4 Jetman sprite for walking left #2.
@ $79A4 label=gfx_jetman_walk_left2
  $79A4,51,1,2,8
b $79D7 Jetman sprite for walking left #3.
@ $79D7 label=gfx_jetman_walk_left3
  $79D7,75,1,2,8
b $7A22 Jetman sprite for walking left #4.
@ $7A22 label=gfx_jetman_walk_left4
  $7A22,75,1,2,8
b $7A6D Jetman sprite for walking right #1.
@ $7A6D label=gfx_jetman_walk_right1
  $7A6D,51,1,2,8
b $7AA0 Jetman sprite for walking right #2.
@ $7AA0 label=gfx_jetman_walk_right2
  $7AA0,51,1,2,8
b $7AD3 Jetman sprite for walking right #3.
@ $7AD3 label=gfx_jetman_walk_right3
  $7AD3,75,1,2,8
b $7B1E Jetman sprite for walking right #4.
@ $7B1E label=gfx_jetman_walk_right4
  $7B1E,75,1,2,8
b $7B69 Meteor sprite #1.
@ $7B69 label=gfx_meteor1
  $7B69,23,1,8*2,6
b $7B80 Meteor sprite #2.
@ $7B80 label=gfx_meteor2
  $7B80,23,1,8*2,6
b $7B97 Explosion sprite: BIG.
@ $7B97 label=gfx_explosion_big
  $7B97,51,1,2,8
b $7BCA Explosion sprite: MEDIUM.
@ $7BCA label=gfx_explosion_medium
  $7BCA,51,1,2,8
b $7BFD Explosion sprite: SMALL.
@ $7BFD label=gfx_explosion_small
  $7BFD,51,1,2,8
b $7C30 U3 Rocket ship sprite: bottom.
@ $7C30 label=gfx_rocket_u3_bottom
  $7C30,35,1,2,8
b $7C53 U3 Rocket ship sprite: middle.
@ $7C53 label=gfx_rocket_u3_middle
  $7C53,35,1,2,8
b $7C76 U3 Rocket ship sprite: top.
@ $7C76 label=gfx_rocket_u3_top
  $7C76,35,1,2,8
b $7C99 U1 Rocket ship sprite: bottom.
@ $7C99 label=gfx_rocket_u1_bottom
  $7C99,35,1,2,8
b $7CBC U1 Rocket ship sprite: middle.
@ $7CBC label=gfx_rocket_u1_middle
  $7CBC,35,1,2,8
b $7CDF U1 Rocket ship sprite: top.
@ $7CDF label=gfx_rocket_u1_top
  $7CDF,35,1,2,8
b $7D02 U5 Rocket ship sprite: bottom.
@ $7D02 label=gfx_rocket_u5_bottom
  $7D02,35,1,2,8
b $7D25 U5 Rocket ship sprite: middle.
@ $7D25 label=gfx_rocket_u5_middle
  $7D25,35,1,2,8
b $7D48 U5 Rocket ship sprite: top.
@ $7D48 label=gfx_rocket_u5_top
  $7D48,35,1,2,8
b $7D6B U4 Rocket ship sprite: bottom.
@ $7D6B label=gfx_rocket_u4_bottom
  $7D6B,35,1,2,8
b $7D8E U4 Rocket ship sprite: middle.
@ $7D8E label=gfx_rocket_u4_middle
  $7D8E,35,1,2,8
b $7DB1 U4 Rocket ship sprite: top.
@ $7DB1 label=gfx_rocket_u4_top
  $7DB1,35,1,2,8
b $7DD4 Gold bar collectible sprite.
@ $7DD4 label=gfx_gold_bar
  $7DD4,19,1,2,8
b $7DE7 Fuel pod sprite.
@ $7DE7 label=gfx_fuel_pod
  $7DE7,25,1,2,8*2,6
b $7E00 Radiation collectible sprite.
@ $7E00 label=gfx_radiation
  $7E00,25,1,2,8*2,6
b $7E19 Chemical weapon collectible sprite.
@ $7E19 label=gfx_chemical_weapon
  $7E19,29,1,2,8*3,2
b $7E36 Plutonium collectible sprite.
@ $7E36 label=gfx_plutonium
  $7E36,21,1,2,8*2,2
b $7E4B Diamond collectible sprite.
@ $7E4B label=gfx_diamond
  $7E4B,27,1,2,8
> $7E66 ; Alien sprites start with a 1-byte header, and are always 16 pixels wide.
> $7E66 ;
> $7E66 ; #TABLE(default,centre,:w)
> $7E66 ; { =h Bytes(n) | =h Meaning }
> $7E66 ; { 0 | Height (pixels)  }
> $7E66 ; { 1... | Pixel data  }
> $7E66 ; TABLE#
b $7E66 Squidgy Alien sprite #1.
@ $7E66 label=gfx_squidgy_alien1
  $7E66,1,1 Height (pixels)
  $7E67,8,8 Pixel data follows
  $7E6F,20,8*2,4
b $7E83 Squidgy Alien sprite #2.
@ $7E83 label=gfx_squidgy_alien2
  $7E83,29,1,8*3,4
b $7EA0 Jet Plane sprite.
@ $7EA0 label=gfx_jet_fighter
  $7EA0,15,1,8,6
b $7EAF Flying Saucer sprite.
@ $7EAF label=gfx_ufo
  $7EAF,17,1,8
b $7EC0 Sphere alien sprite #1.
@ $7EC0 label=gfx_sphere_alien1
  $7EC0,33,1,8
b $7EE1 Sphere alien sprite #2.
@ $7EE1 label=gfx_sphere_alien2
  $7EE1,29,1,8*3,4
b $7EFE Crossed Space craft sprite.
@ $7EFE label=gfx_cross_ship
  $7EFE,31,1,8*3,6
b $7F1D Space craft sprite.
@ $7F1D label=gfx_space_craft
  $7F1D,29,1,8*3,4
b $7F3A Frog Alien sprite.
@ $7F3A label=gfx_frog_alien
  $7F3A,29,1,8*3,4
b $7F57 Rocket Flame sprite #1.
@ $7F57 label=gfx_rocket_flames1
  $7F57,35,1,2,8
b $7F7A Rocket Flame sprite #2.
@ $7F7A label=gfx_rocket_flames2
  $7F7A,35,1,2,8
s $7F9D Unused bytes.
  $7F9D,22,$16
b $7FB3 Jetpac loading screen image
D $7FB3 #UDGTABLE { #SCR(0,,,,,32691,38835)(splash) | Splash screen data. } TABLE#
@ $7FB3 label=loading_screen
  $7FB3,6912,16
b $9AB3 ZX Spectrum font sprites.
@ $9AB3 label=system_font
  $9AB3,480,8
i $9C93 Unused.
