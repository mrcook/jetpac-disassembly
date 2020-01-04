; Jetpac custom loader - requires a 48K ZX Spectrum
; (https://github.com/mrcook/jetpac-disassembly)
;
; Copyright (c) 2020 Michael R. Cook

; When assembling the source code, this file should be invoked by the
; Pasmo Assembler for generating a working TZX tape file.
;
;   $ pasmo --tzxbas loader.asm jetpac.tzx

; Address where the Jetpac game code will be placed.
  ORG $6000

INCLUDE "jetpac.asm"

; Game loader (based on the cartridge routine).
; Initialise the system and display the splash screen.
;
; Place loader well beyond the game source code.
  ORG $B000
Loader:
  di                     ;
  ld a,$3f               ;
  ld i,a                 ;
  ld sp,stack_memory+$25 ; Set top of Stack memory
  im 1                   ;
  ld hl,loading_screen   ; Copy the splash screen data to the display
  ld de,$4000            ;
  ld bc,$1b00            ;
  ldir                   ;
  xor a                  ;
  out ($fe),a            ; Set border to black
  out ($fd),a            ;
key_read:
  in a,($fe)             ; Wait for a key press to start the game
  cpl                    ;
  and $1f                ;
  jr z,key_read          ;
  ld a,$41               ; Set the frame counter (required?)
  ld (SYSVAR_FRAMES),a   ;
  xor a
  jp StartGame

; The Pasmo assembler uses this directive when generating a tape image.
; Expects the same address as the loader routine so that Pasmo knows where
; to start running the code.
end $B000
