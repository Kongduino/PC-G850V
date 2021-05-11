10 ORG 100H
20 JP MAIN
30PUTSTR EQU 0BFF1H
40PUTCHR EQU 0BE62H
50WAITK EQU 0BFCDH
60RPTCHR EQU 0BFEEH

70BUFFER: DEFS 128
80 DB 0

90MAIN: CALL CLS
140 LD HL,BUFFER
150 LD DE,8000H
160 CALL STRLN
170 CALL RAMON

180 LD HL,8000H
190 LD DE,BUFFER
200 CALL STRLN
210MAIN2: LD A,(HL)
220 LD (DE),A
230 CP 0
240 JP Z,MAIN3
250 INC HL
260 INC DE
270 DJNZ MAIN2
280MAIN3: CALL RAMOFF

290 LD HL,BUFFER
300 CALL STRLN
310 LD DE,0000H
320 CALL PUTSTR

370 CALL RAMON
380 LD HL,8080H
390 LD DE,BUFFER
400 CALL STRLN
410MAIN4: LD A,(HL)
420 LD (DE),A
430 CP 0
440 JP Z,MAIN5
450 INC HL
460 INC DE
470 DJNZ MAIN4
480MAIN5: CALL RAMOFF

490 LD HL,BUFFER
500 CALL STRLN
510 LD DE,0300H
520 CALL PUTSTR

530THEEND: CALL WAITK

540CLS: LD B,144
550 LD DE,0
560CLS0: LD A,32
570 CALL RPTCHR
580 RET
590CLLN: LD B,24
600 LD E,0
610 JP CLS0

620RAMON: ; DI
630 IN A,(17H)
640 LD (V19A),A
650 LD A,0
660 OUT (17H),A ; disable periph. interrupts
670 IN A, (19H)
680 LD (V19B),A
690 LD B, 50H  ; /CEROM2=L,  BANK1=0, BANK0=1
700 OR B
710 OUT (19H),A ; enable ext. ram to 0x8000-0xC0000
720 RET

730RAMOFF: LD A,(V19B)
740 OUT (19H),A
750 LD A,(V19A)
760 OUT (17H),A ; re-enable ROM
770 ; EI
780 RET
790V19A: DB 0
800V19B: DB 0

810STRLN: LD B,0
820 PUSH HL ; preserve HL
830STRLN0: LD A,(HL)
840 CP 0
850 JP Z,STRLN1
860 INC HL
870 INC B
880 JP STRLN0
890STRLN1: POP HL ; restore HL
900 RET

910MX2KEY: LD B,0
920 LD C,A ; A IS KEY INDEX
930 LD HL,MATRIX
940 ADD HL,BC
950 LD A,(HL)
960 RET

970MATRIX: DB 0,0FFH
980 DB 'QWERTYUASDFGHJKZXCVBNM,'
990 DB 0FFH,0FFH,0FFH,0FFH,9,32,10,11,14,15 ; LEFT RIGHT UP DOWN
1000 DB 0FFH,'0.=+',13,'L;',0FFH,'123-'
1010 DB 0FFH,'IO',0FFH,'456*',0FFH,'P',8,0FFH,'789/)'
1020 DB 0FFH,0FFH,0FFH,0FFH,'(',0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
1030 DB 0,12,0FFH

1040GREET0: DB 'msg @ 8000H',0
1050GREET1: DB 'msg @ 8080H',0

1060BYTE: PUSH AF
1070 AND 0F0H
1080 RRCA
1090 RRCA
1100 RRCA
1110 RRCA
1120 CALL NIBBLE
1130 INC HL
1140 POP AF
1150 AND 15
1160 CALL NIBBLE
1170 INC HL
1180 RET
1190NIBBLE: SUB 10
1200 JP M,ZERO9
1210 ADD A,7
1220ZERO9: ADD A,58
1230 LD (HL),A
1240 RET

1250PIN: DB 'You picked '
1260PIN00: DB 0,', ie 0x'
1270PIN01: DB 0,0,0

