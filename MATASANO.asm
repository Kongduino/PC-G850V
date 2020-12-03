10 ORG 100H
20 JP PB00

30REGOUT EQU 0BD03H
40RPTCHR EQU 0BFEEH
50GPF EQU 0BFD0H
60AOUT EQU 0BD09H
70PUTSTR EQU 0BFF1H
80WAITK EQU 0BFCDH

100PB00: CALL CLS
110 LD HL,TXT00
120 CALL STRLN
130 LD DE,0
140 CALL PUTSTR
150 LD B,96
160 LD HL,BUFF00
170 LD DE,PBLM1
180 CALL ASC2H
190 LD HL,BUFF00
200 LD B,48
210 LD DE,0100H
220 CALL PUTSTR
230 CALL WAIT

240PB02: CALL CLS
245 CALL CLNUP
250 LD HL,TXT01
260 CALL STRLN
270 LD DE,0
280 CALL PUTSTR
290 LD B,36
300 LD HL,BUFF00
310 LD DE,PBML21
320 CALL ASC2H
330 LD BC,36
340 LD HL,BUFF00
350 ADD HL,BC
360 LD DE,PBML22
370 LD B,36
380 CALL ASC2H
390 LD HL,BUFF00
400 LD BC,36
410 ADD HL,BC
420 LD DE,BUFF00
430 LD B,18
440 PUSH IX
450 LD IX,BUFF01
460PB020: LD A,(DE)
470 XOR (HL)
480 LD (IX),A
490 INC IX
500 INC DE
510 INC HL
520 DJNZ PB020
530 POP IX
540 LD HL,BUFF01
550 LD BC,36
560 ADD HL,BC
570 PUSH HL
580 LD B,18
590 LD DE,BUFF01
600PB021: LD A,(DE)
610 CALL BYTE
620 INC DE
630 DJNZ PB021
640 POP HL
650 LD B,18
660 LD DE,0200H
670 CALL PUTSTR
680 LD B,18
690 LD DE,0300H
700 CALL PUTSTR
710 LD HL,BUFF01
720 LD B,18
730 LD DE,0400H
740 CALL PUTSTR
750 CALL WAIT

760PB03: CALL CLS
765 CALL CLNUP
770 LD HL,TXT01
780 CALL STRLN
790 LD DE,0
800 CALL PUTSTR
810 LD B,68
820 LD HL,BUFF00
830 LD DE,PBLM3
840 CALL ASC2H

850 LD HL,BSCORE
860 LD (HL),0
870 LD HL,BCHAR
880 LD (HL),0
890 LD A,0FFH
900 LD (CCHAR),A

910PB030: LD B,34
920 LD DE,BUFF00
930 LD HL,BUFF01
940 LD A,(CCHAR)
950 LD C,A
960PB031: LD A,(DE)
970 XOR C
980 LD (HL),A
990 INC HL
1000 INC DE
1010 DJNZ PB031 ; string is xored

1020 LD B,34 ; now rate it
1030 LD HL,0
1040 LD (CSCORE),HL
1050 LD HL,BUFF01
1060PB035: LD A,(HL)
1070 PUSH HL
1080 PUSH BC
1090 LD B,13
1100 ; "ETAOIN SHRDLU"
1110 CP 'E'
1120 JP M,PB033
1130 CP 'e'
1140 JP M,PB033
1150 DEC B
1160 CP 'T'
1170 JP M,PB033
1180 CP 't'
1190 JP M,PB033
1200 DEC B
1210 CP 'A'
1220 JP M,PB033
1230 CP 'a'
1240 JP M,PB033
1250 DEC B
1260 CP 'O'
1270 JP M,PB033
1280 CP 'o'
1290 JP M,PB033
1300 DEC B
1310 CP 'I'
1320 JP M,PB033
1330 CP 'i'
1340 JP M,PB033
1350 DEC B
1360 CP 'N'
1370 JP M,PB033
1380 CP 'n'
1390 JP M,PB033
1400 DEC B
1410 CP ' '
1420 JP M,PB033
1430 DEC B
1440 CP 'S'
1450 JP M,PB033
1460 CP 's'
1470 JP M,PB033
1480 DEC B
1490 CP 'H'
1500 JP M,PB033
1510 CP 'h'
1520 JP M,PB033
1530 DEC B
1540 CP 'R'
1550 JP M,PB033
1560 CP 'r'
1570 JP M,PB033
1580 DEC B
1590 CP 'D'
1600 JP M,PB033
1610 CP 'd'
1620 JP M,PB033
1630 DEC B
1640 CP 'L'
1650 JP M,PB033
1660 CP 'l'
1670 JP M,PB033
1680 DEC B
1690 CP 'U'
1700 JP M,PB033
1710 CP 'u'
1720 JP M,PB033
1730 JP PB036
1740PB033: LD HL,CSCORE
1750 INC (HL)
1760 DJNZ PB033 ; Increment CSCORE B times
1770PB036: POP HL
1780 INC HL
1790 POP BC
1800 DJNZ PB035A
1810 JP PB035B
1820PB035A: JP PB035
1830PB035B: LD HL,(CSCORE)
1840 LD BC,(BSCORE)
1850 SBC HL,BC
1860 JP M,PB034 ; LOWER, DON'T CARE
1870 LD (BSCORE),BC
1880 LD A,(CCHAR)
1890 LD (BCHAR),A
1900PB034: PUSH HL
1910 LD HL,0
1920 LD (CSCORE),HL
1930 POP HL
1940 ; Decrement CCHAR and go
1950 LD A,(CCHAR)
1960 DEC A
1970 LD (CCHAR),A
1980 CP 0
1990 JP NZ,PB030
2000 LD B,34
2010 LD A,(BCHAR)
2020 LD C,A
2030 LD DE,BUFF00
2040 LD HL,BUFF01
2050PB037: LD A,(DE)
2060 XOR C
2070 LD (HL),A
2080 DJNZ PB037
2090 ; string is xored with best char
2100 LD HL,BUFF01
2110 LD DE,BSCORE
2120 CALL REGOUT
2130 CALL CLS
2140 LD HL,BUFF01
2150 LD B,34
2160 LD DE,0200H
2170 CALL PUTSTR
2180 CALL WAIT

2170 RET

3000ASC2H: LD A,(DE)
3010 INC DE
3020 CALL HALF
3030 SLA A
3040 SLA A
3050 SLA A
3060 SLA A
3070 PUSH BC
3080 LD B,A
3090 LD A,(DE)
3100 INC DE
3110 CALL HALF
3120 ADD A,B
3130 LD (HL),A
3140 INC HL
3150 POP BC
3160 DJNZ ASC2H
3170 LD (HL),0
3180 RET

3190WAIT: CALL WAITK
3200 CP 0
3210 JP Z,WAIT
3220 RET
3230CLS: LD B, 144
3240 LD DE, 0
3250CLS0: LD A, 32
3260 CALL RPTCHR
3270 RET
3280CLLN: LD B,24
3290 LD E,0
3300 JP CLS0

3310BYTE: PUSH AF
3320 AND 0F0H
3330 RRCA
3340 RRCA
3350 RRCA
3360 RRCA
3370 CALL NIBBLE
3380 INC HL
3390 POP AF
3400 AND 15
3410 CALL NIBBLE
3420 INC HL
3430 RET
3440NIBBLE: SUB 10
3450 JP M,ZERO9
3460 ADD A,7
3470ZERO9: ADD A,58
3480 LD (HL),A
3490 RET

3500STRLN: LD B,0
3510 PUSH HL
3520STRLN0: LD A,(HL)
3530 CP 0
3540 JP Z,STRLN1
3550 INC HL
3560 INC B
3570 JP STRLN0
3580STRLN1: POP HL
3590 RET

3600HALF: SUB 48
3610 CP 10
3620 JP M,HALF9
3630 SUB 7
3640HALF9: RET

3650MX2KEY: LD B,0
3660 LD C,A ; A IS KEY INDEX
3670 LD HL, MATRIX
3680 ADD HL, BC
3690 LD A,(HL)
3700 RET

3710CLNUP: LD B,192
3720 LD HL,BUFF00
3730CLNUP0: LD (HL),0
3740 INC HL
3750 DJNZ CLNUP0
3760 RET

5000BUFF00: DEFS 96
5010BUFF01: DEFS 96
5020PBLM1: DB '49276D206B696C6C'
5030 DB '696E6720796F7572'
5040 DB '20627261696E206C'
5050 DB '696B65206120706F'
5060 DB '69736F6E6F757320'
5070 DB '6D757368726F6F6D'
5080 DB 0
5090PBML21: DB '1C0111001F01010006'
5100 DB '1A024B53535009181C'
5110PBML22: DB '686974207468652062'
5120 DB '756C6C277320657965'
5130PBLM3: DB '1B37373331363F78'
5140 DB '151B7F2B78343133'
5150 DB '3D78397828372D36'
5160 DB '3C78373E783A393B3736'
5170BSCORE: DB 0,0
5180BCHAR: DB 0
5190CSCORE: DB 0,0
5200CCHAR: DB 0
5210TXT00: DB 'Problem 1',0
5220TXT01: DB 'Problem 2',0
5230TXT02: DB 'Problem 3',0
5240ZOIGIN: DB 'Bye...',13,10,0
5250MATRIX: DB 0,0FFH
5260 DB 'QWERTYUASDFGHJKZXCVBNM,'
5270 DB 0FFH,0FFH,0FFH,0FFH,9,32,10,11,14,15 ; LEFT RIGHT UP DOWN
5280 DB 0FFH, '0.=+',13,'L;',0FFH,'123-'
5290 DB 0FFH,'IO',0FFH,'456*',0FFH,'P',8,0FFH,'789/)'
5300 DB 0FFH,0FFH,0FFH,0FFH,'(',0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
5310 DB 0,12,0FFH


