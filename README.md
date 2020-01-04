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


## Copyright Information

This disassembly, comments and support files, Copyright © 2020 Michael R. Cook.

JETPAC Copyright, ULTIMATE PLAY THE GAME. Copyright & Trade Name, 1983 Ashby Computers & Graphics Ltd. All rights reserved Worldwide.
