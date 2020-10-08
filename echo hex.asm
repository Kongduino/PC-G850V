10 ORG 100H
20 JP MAIN
30SCRLP EQU 084F7H
40INITSR EQU 0871AH
50OPENSR EQU 0BCE8H
60CLOSSR EQU 0BCEBH
70LRDSR EQU 0BD15H
80WAITK EQU 0BFCDH
90WSTSR EQU 0BFB2H
100MAIN: CALL INITSR
110 CALL OPENSR
120 LD IX, L2
130 LD B, 4
140 LD HL, L1
150LOOP: LD A, (IX)
160 AND 0F0H
170 RRCA
171 RRCA
172 RRCA
173 RRCA
180 CALL NIBBLE
190 INC HL
200 LD A, (IX)
205 INC IX
210 AND 15
220 CALL NIBBLE
225 INC HL
250 DJNZ LOOP
260 LD HL, L0
270 CALL WSTSR
280 LD DE, 0000H
290 LD HL, L0
300 LD B, 37
310 CALL DSPSTR
320 CALL WAITK

400 CALL CLOSSR
410 RET

600DSPSTR: LD A, (HL)
610 INC HL
620 PUSH BC
630 PUSH DE
640 PUSH HL
650 CALL 08440H
660 POP HL
670 POP DE
680 POP BC
690 INC E
700 LD A, E
710 SUB 24
720 JP M, SKIP0
730 INC D
740 LD E, 0
750SKIP0: DJNZ DSPSTR
760 RET

800NIBBLE: SUB 10
820 JP M, ZERO9
830 ADD A, 7
840ZERO9: ADD A, 58
850 LD (HL), A
860 RET 


1000L0: DB 'Converting HEX to ASCII: 0x'
1010L1: DB 0,0,0,0,0,0,0,0
1020 DB 13,10,0
1030L2: DB 0DEH, 0CAH, 0FBH, 0ADH

