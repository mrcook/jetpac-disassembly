# JETPAC cartridge ROM disassembly

An unofficial disassembly of JETPAC, the classic 8-bit computer game released
in 1983 for the 16K ZX Spectrum home computer.

[This disassembly](https://github.com/mrcook/jetpac-disassembly) has been
created from the raw binary data of the original ZX Spectrum JETPAC
cartridge ROM, using the [SkoolKit](http://skoolkit.ca) disassembly toolkit.


## Skoolkit Instructions

When the ZX Spectrum boots from a cartridge the _loader_ routine located at
address `$0000` is executed. This routine copies the loading screen to the
Spectrum display file, and waits for the player to press a key. The game code
and data is then copied to the computer RAM at address `$6000`
(`24499` in decimal).

So that the disassembly is placed at the correct address, Skoolkit needs to be
given an address to start writing the bytes. The following command will extract
the game from the `.rom` image (not included in this repository), apply the
disassembly annotations and write the resulting source code to a `.skool` file:

    $ sna2skool.py -c jetpac.ctl -Hl -o 24499 jetpac.rom > jetpac.skool


## Assembly

Skoolkit can generate valid Z80 ASM code with the following command:

    $ skool2asm.py -H -crs jetpac.skool > jetpac.asm

The generated `asm` won't be able to start the game without a loader routine.
A basic example is provided in the file
[`loader.asm`](https://github.com/mrcook/jetpac-disassembly/blob/master/loader.asm).

The [Pasmo Assembler](http://pasmo.speccy.org/) can be used to assemble the
source into a working ZX Spectrum tape image.

    $ pasmo --tzxbas loader.asm jetpac.tzx


### 128K Spectrum Fix

If you're wanting to assemble the game for the 128K Spectrum you'll first need
to apply this fix before converting the `skool` file to `asm`:

```
; jetpac.skool

- $7326 out ($fd),a   ; Set port for reading keyboard
+ $7326 nop
+ $7327 nop
```


## The Game

A fast-paced shooter video game for 8-bit home computer systems.

Jetpac is the first instalment in the Jetman series, followed by _Lunar Jetman_
(1983) and _Solar Jetman: Hunt for the Golden Warpship_ (1990).


  **The 'Acme Interstellar Transport Company' is delivering
  SPACESHIP KITS  to various planets in the solar systems
  throughout the Galaxy; and as chief test pilot, all you
  have to do is assemble the Rockets, and thrust onto your
  next destination.**

  But! as you don't often get the chance of a free trip across the
  Galaxy, and space travel is, oh, so expensive, now is your
  chance to get rich! You might just as well stop off on several
  planets on your journey, collect the odd sack of precious gems,
  elements or gold, and take them back with you.

  **Sounds simple doesn't it!**

  But! before you go and make yourself the richest person in the
  whole Universe, you must remember to refuel your Spaceship,
  every time you land on a planet, with 6 fuel pods. Any other
  goodies you collect, are yours to keep. Upon landing, you will
  find yourself equipped with the very latest Hydrovac **JET PAC**,
  which can automatically airlift almost any rocket stage, fuel
  pod or valuables, you care to land upon, and release them over
  the rocket ship base, plus mega powerful, Quad Photon Laser
  Phasers, to blast any nasty, mean, little aliens who might
  object to your visit.

  And my! do those aliens get upset, when you collect all of their
  valuables, and sneak off, without so much as a by-your-leave.


_JETPAC was designed and developed by Chris Stamper and Tim Stamper in 1983 for
the 16K and 48K Sinclair ZX Spectrum._


## Project Status

This disassembly might be considered done.

- All code blocks have been labelled and annotated.
- All variables have been labelled and annotated.
- All data has been isolated and annotated.
- All text data has been annotated.
- All graphics have been annotated (tiles, sprites).
- All game buffers (baddie/collectible) are annotated.

However, there are still a few sections of code and variables that would
benefit from a deeper analysis.

Feedback and submissions are welcome!


## Cassette version disassembly

This section contains some notes on how the cartridge and cassette versions of
Jetpac differ.

The code in the two versions is identical except for a slight difference on
where it's loaded in memory, and that the cassette version supports the
Kempston joystick instead of the Interface 2. There is also a _code mover_
routine used during tape loading.

The BASIC tape loader is one long line of instructions, which has been
reformatted to fit here.

```
1  CLEAR 24575:
   BEEP .1,1: BEEP .1,2: BEEP .1,3: BEEP .1,4: BEEP .1,5:
   PAPER 0: INK 7: BRIGHT 1: CLS : PRINT BRIGHT 1;INK 7;
   AT 9,7;"JETPAC IS LOADING";
   AT 12,10;"PLEASE WAIT":
   PRINT AT 0,0: LOAD ""SCREEN$ :
   INK 0: PAPER 0:
   PRINT AT 5,0: LOAD ""CODE :
   PRINT AT 5,0: LOAD ""CODE :
   PRINT AT 5,0: LOAD ""CODE :
   PRINT AT 5,0: LOAD ""CODE :
   PRINT USR 24576
```

Below is the skoolkit `t2s` config file, which can be used as a starting point
for disassembling a TZX image file.

```
; tap2sna.py file for Jetpac cassette version. Run
;
;   $ tap2sna.py @jetpac.t2s
;
; to create a Z80 snapshot.

jetpac.tzx
jetpac.z80

; Skoolkit handles these automatically,
; but listing here for reference.
; ram load:  4,16384  # load screen (JPSP)
; ram load:  6,24576  # load game code/data
; ram load:  8,23424  # load `mover` routine
; ram load: 10,23728  # load `JP (HL)` opcode
; ram load: 12,23672  # load game start check variables

; After the game loads the PC starts at $6000:
;
; c$6000 DI
;  $6001 JP $5B80
;
; The `mover` routine at $5B80 moves bytes 24580-32772 down to 24576-32768.
; This routine is loaded from tape block #8 (see above).
--ram move=$6004,$2000,$6000

; Initialize all game variables and data so the source code is clean.
--ram poke=$5CCB-$5FFF,$00

--reg sp=$5CF0
--reg pc=$61E5
```

As you can see, `--ram move=$6004,$2000,$6000` emulates the mover routine
found on the tape. For those interested, that routine is as follows:

```
; Skoolkit code mover disassembly for Jetpac

; Disassembly of the code mover routine, which copies 8192 bytes from address
; $6004 down to $6000, before then jumping to the game start routine.
c$5b80 ld hl,$6004   ;
 $5b83 ld de,$6000   ;
 $5b86 ld bc,$2000   ;
 $5b89 ldir          ;
 $5b8b jp $61e5      ;

; Tape block #6 ("The Game") is loaded at this address, starts running, then
; calls the above routine, which then overwrites these instructions.
c$6000 di            ;
 $6001 jp $5b80      ;
```

The Kempston joystick menu entry:

```
 $62dc defm "4   KEMPSTON JOYSTIC"
 $62f0 defb $cb                    ; ASCII "K" ($4B) + EOL control bit
```

The joystick reading routine and how the values are used in the code do have
some small differences. Here is the main read routine itself:

```
; Joystick Input (Kempston)
;
; Output:A Joystick direction/button state.
@label=ReadKempstonJoystick
c$733a in a,($1f)    ; Joystick port
 $733c cpl           ; Invert all bits in #REGa
 $733d ret           ;

```


## Copyright Information

This disassembly, comments and support files, Copyright © 2020 Michael R. Cook.

JETPAC Copyright, ULTIMATE PLAY THE GAME. Copyright & Trade Name, 1983 Ashby Computers & Graphics Ltd. All rights reserved Worldwide.
