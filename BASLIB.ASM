10 ORG 100H
20PUTSTR EQU 0BFF1H
30WAITK EQU 0BFCDH
40RPTCHR EQU 0BFEEH
50 CALL CLS
60 LD HL,STRBUF
70 LD (HL),'C'
80 INC HL
90 LD (HL),'L'
100 INC HL
110 LD (HL),'S'
120 INC HL
130 LD (HL),' '
140 INC HL
150 LD DE, CLS
160 LD A,D
170 CALL BYTE
180 LD A,E
190 CALL BYTE
200 LD (HL),' '
210 INC HL
220 LD (HL),'C'
230 INC HL
240 LD (HL),'L'
250 INC HL
260 LD (HL),'S'
270 INC HL
280 LD (HL),'0'
290 INC HL
300 LD (HL),' '
310 INC HL
320 LD DE, CLS0
330 LD A,D
340 CALL BYTE
350 LD A,E
360 CALL BYTE
370 LD (HL),0
380 LD HL,STRBUF
390 LD DE,0
400 CALL STRLN
410 LD HL,STRBUF
420 CALL PUTSTR
430 LD HL,STRBUF
440 LD (HL),'C'
450 INC HL
460 LD (HL),'N'
470 INC HL
480 LD (HL),'U'
490 INC HL
500 LD (HL),'M'
510 INC HL
520 LD (HL),' '
530 INC HL
540 LD DE, CLSN
550 LD A,D
560 CALL BYTE
570 LD A,E
580 CALL BYTE
590 LD (HL),' '
600 INC HL
610 LD (HL),'X'
620 INC HL
630 LD (HL),' '
640 INC HL
650 LD DE, CLSX
660 LD A,D
670 CALL BYTE
680 LD A,E
690 CALL BYTE
700 LD (HL),' '
710 INC HL
720 LD (HL),'Y'
730 INC HL
740 LD (HL),' '
750 INC HL
760 LD DE, CLSY
770 LD A,D
780 CALL BYTE
790 LD A,E
800 CALL BYTE
810 LD (HL),0
820 LD HL,STRBUF
830 LD DE,00100H
840 CALL STRLN
850 LD HL,STRBUF
860 CALL PUTSTR

870 LD HL,STRBUF
220 LD (HL),'C'
230 INC HL
240 LD (HL),'H'
250 INC HL
260 LD (HL),'A'
270 INC HL
280 LD (HL),'R'
290 INC HL
300 LD (HL),' '
310 INC HL
320 LD DE, CHAR
330 LD A,D
340 CALL BYTE
350 LD A,E
360 CALL BYTE
880 LD (HL),' '
890 INC HL
880 LD (HL),'P'
890 INC HL
900 LD (HL),'W'
910 INC HL
920 LD (HL),'D'
930 INC HL
940 LD (HL),' '
950 INC HL
960 LD DE, PWD
970 LD A,D
980 CALL BYTE
990 LD A,E
1000 CALL BYTE
1010 LD (HL),0
1020 LD HL,STRBUF
1030 LD DE,00200H
1040 CALL STRLN
1050 LD HL,STRBUF
1060 CALL PUTSTR

1100WAIT: CALL WAITK
1110 CP 0
1120 JP Z, WAIT
1130 RET

2000CLS: LD A,144
2010 LD (CLSN), A
2020 LD DE, 0
2030 LD (CLSX), DE
2040 LD A,32
2050 LD (CHAR),A
2060CLS0: LD A,(CLSN)
2070 LD B,A
2080 LD A,(CHAR)
2090 LD DE,(CLSY)
2100 CALL RPTCHR
2110 RET
2120CLSN: DB 144
2130CLSY: DB 0
2140CLSX: DB 0
2150CHAR: DB 32

2160GETPWD: CALL CLS
2170 LD HL, 079C0H
2180 LD B, 8
2190 LD DE, 0000FH
2200 CALL PUTSTR
2210 LD HL, PWD
2220 LD B, 4
2230 LD DE, 0000AH
2240 CALL PUTSTR
2250 JP WAIT

3260BYTE: PUSH AF
3270 AND 0F0H
3280 RRCA
3290 RRCA
3300 RRCA
3310 RRCA
3320 CALL NIBBLE
3330 INC HL
3340 POP AF
3350 AND 15
3360 CALL NIBBLE
3370 INC HL
3380 RET
3390NIBBLE: SUB 10
3400 JP M, ZERO9
3410 ADD A, 7
3420ZERO9: ADD A, 58
3430 LD (HL), A
3440 RET

3450STRLN: LD B, 0
3460STRLN0: LD A, (HL)
3470 CP 0
3480 JP Z, STRLN1
3490 INC HL
3500 INC B
3510 JP STRLN0
3520STRLN1: RET

5000BUFFER: DB 0,0,0,0,0,0,0,0
5010PWD: DB 'pwd:'
5020STRBUF: DB 0,0,0,0,0,0,0,0
5030 DB 0,0,0,0,0,0,0,0
5040 DB 0,0,0,0,0,0,0,0
5050 DB 0,0,0,0,0,0,0,0

