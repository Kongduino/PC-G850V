# A SHORT ASM DOCUMENTATION

## This README documents my ASM code, since memory is limited on the Sharp.

- The code uses (un)documented ROM routines. These are named for readability, but it's not exactly scintillating. Known routines are documented below.

- People who come from "modern" language might find some concepts weird (like flag-based comparisons). I'll try to explain these.

- Library of subroutines. In order to avoid reinventing the wheel, I am writing code so as to be reusable. I'll document these routines here.

## ROM routines

- **REGOUT EQU 0BD03H**

 It clears the screen (need to find THAT routine), displays the contents of all registers, then waits for the user to press a key. Useful when debugging.

- **DSPDE EQU 0BFF1H**

 In the same vein, this one displays DE, and waits for a key to be pressed.

- **AOUT EQU 0BD09H**

 Same for A.

- **AOUTSR EQU 0BFAFH**

 Same again for A, but to Serial.

- **HLOUT EQU 0BD0FH**

 Same for HL.

- **HLOSR EQU 0BFB2H**

 Same again for HL, but to Serial.

- **INKEY EQU 089BEH**

 Polls the keyboard and puts in A the key (from the Key Matrix). A = 0 ==> no key pressed.
```ASM
250LOOP0: CALL INKEY
260 CP 0
270 JP Z, LOOP0
```
 Waits for a key to be pressed.
 - `CALL INKEY` ==> polls keyboard and puts result in A.
 - `CP 0` ==> compares A with 0.
 - `JP Z, LOOP0` ==> If flag is Zero (true), go back to LOOP0.

- **GETCHR EQU 0BCFDH (088C1H)**

 INKEY gives you the key according to the key matrix. This gives you the real character. Used to do real user input (as opposed to press a key to continue kind of things).

- **PUTCHR EQU 08440H**

 Displays the ASCII(ish) char in A at position ED (E=x, D=y, so reverse order).
```ASM
100 LD A, 058H
510 LD DE, 00205H
516 CALL PUTCHR
```
 This displays an X at position x=5, y=2 (column 6, line 3). The `CLS` function I wrote uses this intensively.

- **INITSR EQU 0871AH**

- **OPENSR EQU 0BCE8H**

- **CLOSSR EQU 0BCEBH**

 These 3 functions initialize, open and close the serial port (11-pin). They're very very useful.

- **LRDSR EQU 0BD15H**

 Reads a line into HL until EOL or EOF is detected, or there's an error.

- **WSTSR EQU 0BFB2H**

 The reverse – writes a 0x00-terminated string to Serial.

- **0BCDFH / 0BCE2H / BCE5H**

 I haven't named them yet, and the docs aren't that clear, but they read a char from Serial. The first one waits a short amount of time, the latter 2 indefinitely. I have used the last one with success.

- **WAITK EQU 0BFCDH**

 Same for keyboard. Waits until a key is pressed, result stored in A.

- **DSPHEX EQU 0F9BDH**

 Converts the contents of A (8-bit value) to a 2-char HEX (ASCII) string, positioned at HL. Much better than doing it yourself, believe me...

There are others, but I haven't used them yet – or some didn't work as advertised. tbc...

## My routines

- **CLS**

```ASM
500CLS: LD B, 6 ; 6 lines
502 LD DE, 0
504CLS1: PUSH BC ; B is used both for line and column [DJNZ]. So the line is saved in the stack
506 LD B, 24 ; 24 chars per line
508CLS2: LD A, 32 ; ' '
510 PUSH BC
512 PUSH DE
514 PUSH HL
516 CALL PUTCHR ; writes A (ie 32, ie ' ') to the screen at pos E,D
518 POP HL
520 POP DE
522 POP BC
524 INC E ; Increment pos X
526 DJNZ CLS2 ; Very powerful: decrement B and go if non-zero
528 INC D ; Increment pos Y
530 LD E, 0
532 POP BC ; B is used both for line and column [DJNZ]. So the line is saved in the stack
534 DJNZ CLS1
536 RET
```

Clears the screen. Haven't found yet the ROM routine that does that...

- **DSPSTR**

```ASM
210 LD HL, L0 ; beginning of the string
215 CALL STRLN ; get length of the string into B --> See next function
220 LD HL, L0 ; beginning of the string
230 LD DE, 00100H ; Y/X position [0-5, 0-23]
240 CALL DSPSTR ; call the routine

[...]

600DSPSTR: LD A, (HL) ; Same principle as CLS, really
610 INC HL
620 PUSH BC
630 PUSH DE
640 PUSH HL
650 CALL PUTCHR ; writes A (ie 32, ie ' ') to the screen at pos E,D
660 POP HL
670 POP DE
680 POP BC
690 INC E
700 LD A, E
710 SUB 24 ; This is how you do a comparison
720 JP M, SKIP0 ; deduct 24: if the result is negative you haven't displayed 24 chars yet.
730 INC D ; increment y pos
740 LD E, 0 ; reset x pos to 0
750SKIP0: DJNZ DSPSTR ; decrement B (char count) and loop if any left
760 RET
```

- **DSPSTR**

```ASM
210 LD HL, L0 ; beginning of the string
215 CALL STRLN ; get length of the string into B

[...]

1000STRLN: LD B, 0 ; char count initialized at 0
1010STRLN0: LD A, (HL) ; load current char pointed to by HL
1015 CP 0 ; Is it a zero? aka EOL?
1020 JP Z, STRLN1 ; Ayuh. Bail
1030 INC HL ; Increment HL
1040 INC B ; Increment count
1050 JP STRLN0 ; Loop
1060STRLN1: RET
```
