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
250 CALL CLNUP
260 LD HL,TXT01
270 CALL STRLN
280 LD DE,0
290 CALL PUTSTR
300 LD B,36
310 LD HL,BUFF00
320 LD DE,PBML21
330 CALL ASC2H
340 LD BC,36
350 LD HL,BUFF00
360 ADD HL,BC
370 LD DE,PBML22
380 LD B,36
390 CALL ASC2H
400 LD HL,BUFF00
410 LD BC,36
420 ADD HL,BC
430 LD DE,BUFF00
440 LD B,18
450 PUSH IX
460 LD IX,BUFF01
470PB020: LD A,(DE)
480 XOR (HL)
490 LD (IX),A
500 INC IX
510 INC DE
520 INC HL
530 DJNZ PB020
540 POP IX
550 LD HL,BUFF01
560 LD BC,36
570 ADD HL,BC
580 PUSH HL
590 LD B,18
600 LD DE,BUFF01
610PB021: LD A,(DE)
620 CALL BYTE
630 INC DE
640 DJNZ PB021
650 POP HL
660 LD B,18
670 LD DE,0200H
680 CALL PUTSTR
690 LD B,18
700 LD DE,0300H
710 CALL PUTSTR
720 LD HL,BUFF01
730 LD B,18
740 LD DE,0400H
750 CALL PUTSTR
760 CALL WAIT

770PB03: CALL CLS
780 CALL CLNUP
790 LD HL,TXT02
800 CALL STRLN
810 LD DE,0
820 CALL PUTSTR
830 LD B,68
840 LD HL,BUFF00
850 LD DE,PBLM3
860 CALL ASC2H
870 LD HL,0
880 LD (BSCORE),HL
890 LD HL,BCHAR
900 LD (HL),0
910 LD A,0FFH; from 0xFF to 0x01
920 LD (CCHAR),A
930PB030: LD B,34
940 LD DE,BUFF00
950 LD HL,0
960 LD (CSCORE),HL
970 LD HL,BUFF01
980 LD A,(CCHAR)
990 LD C,A
1000PB031: LD A,(DE)
1010 XOR C
1020 LD (HL),A
1030 INC HL
1040 INC DE
1050 DJNZ PB031
1060 PUSH HL
1070 PUSH DE
1080 PUSH BC
1090 CALL GRADE ; now rate it
1100 LD DE,(CSCORE)
1110 LD HL,(BSCORE)
1120 SBC HL,DE
1130 JP NC,PB034 ; LOWER, DON'T CARE
1140 LD HL,(CSCORE)
1150 LD (BSCORE),HL
1160 LD A,(CCHAR)
1170 LD (BCHAR),A
1180 ; CALL REGOUT
1190PB034: POP BC
1200 POP DE
1210 POP HL ; Decrement CCHAR and go
1220 LD A,(CCHAR)
1230 DEC A
1240 LD (CCHAR),A
1250 CP 0
1260 JP NZ,PB030
1270 LD B,34
1280 LD A,(BCHAR)
1290 LD C,A
1300 LD DE,BUFF00
1310 LD HL,BUFF01
1320PB037: LD A,(DE)
1330 XOR C
1340 LD (HL),A
1350 INC HL
1360 INC DE
1370 DJNZ PB037
1380 ; string is xored with best char
1390 LD HL,TXT03A
1400 LD A,(BCHAR)
1410 CALL BYTE
1420 INC HL
1430 INC HL
1440 LD A,(BCHAR)
1450 LD (HL),A
1460 INC HL
1470 LD (HL),0
1480 LD HL,TXT03
1490 CALL STRLN
1500 LD DE,0100H
1510 CALL PUTSTR
1520 LD DE,(BSCORE)
1530 LD HL,BUFFXY
1540 LD BC,7
1550 ADD HL,BC
1560 LD A,D
1570 CALL BYTE
1580 LD A,E
1590 CALL BYTE
1600 LD HL,BUFFXY
1610 LD DE,010CH
1620 LD B,11
1630 CALL PUTSTR
1640 LD HL,BUFF01
1650 LD B,34
1660 LD DE,0300H
1670 CALL PUTSTR
1680 CALL WAIT
1690 CALL CLS
1700 LD HL,ZOIGIN
1710 CALL STRLN
1720 LD DE,0
1730 CALL PUTSTR
1740THEEND: RET

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

4000FREQ: DB ' ET.AOSINRHDLC',0
4010GRADE: ; CALL CLS
4020 ; LD HL,BUFFXX
4030 ; LD A,(CCHAR)
4040 ; LD (HL),A
4050 ; INC HL
4060 ; INC HL
4070 ; INC HL
4080 ; INC HL
4090 ; CALL BYTE
4100 ; LD HL,BUFFXX
4110 ; LD B,6
4120 ; LD DE,0
4130 ; CALL PUTSTR
4140 ; LD HL,BUFF01
4150 ; LD B,34
4160 ; LD DE,0100H
4170 ; CALL PUTSTR
4180 ; CALL WAIT
4190 LD DE,BUFF01 ; XOR'ed string
4200 LD A,34
4210GRADE0: LD (CNTR),A
4220 LD A,(DE)
4230 INC DE
4240 CP ' ' ; BELOW ' ' DON'T BOTHER
4250 JP M,GRADE3
4260 CP 127 ; above 7F DON'T BOTHER
4270 JP P,GRADE3
4280 CP 'a'
4290 JP M,SKIP00
4300 CP 'z'
4310 JP P,SKIP00
4320 ; CALL AOUT
4330 SUB 20H ; CAPITALIZE
4340SKIP00: LD HL,FREQ
4350 LD B,14
4360GRADE1: CP (HL)
4370 JP Z,GRADE2
4380 INC HL
4390 DJNZ GRADE1 ; NO MATCH
4400 JP GRADE3
4410GRADE2: LD HL,(CSCORE)
4420 LD C,B
4430 LD B,0
4440 ADD HL,BC
4450 INC HL
4460 LD (CSCORE),HL
4470GRADE3: ; LD A,(CNTR)
4480 ; LD B,A
4490 ; LD A,(CCHAR)
4500 ; CALL REGOUT
4510 LD A,(CNTR)
4520 DEC A
4530 CP 0
4540 JP NZ,GRADE0
4550GRADE4: RET

5000BUFF00: DEFS 96
5010BUFF01: DEFS 96
5020BUFFXX: DB 0,' 0x',0,0
5030BUFFXY: DB 'Score: ',0,0,0,0,0
5040CNTR: DB 0
5050PBLM1: DB '49276D206B696C6C'
5060 DB '696E6720796F7572'
5070 DB '20627261696E206C'
5080 DB '696B65206120706F'
5090 DB '69736F6E6F757320'
5100 DB '6D757368726F6F6D'
5110 DB 0
5120PBML21: DB '1C0111001F01010006'
5130 DB '1A024B53535009181C'
5140PBML22: DB '686974207468652062'
5150 DB '756C6C277320657965'
5160PBLM3: DB '1B37373331363F78'
5170 DB '151B7F2B78343133'
5180 DB '3D78397828372D36'
5190 DB '3C78373E783A393B3736'
5200BSCORE: DB 0,0
5210BCHAR: DB 0
5220CSCORE: DB 0,0
5230CCHAR: DB 0
5240TXT00: DB 'Problem 1',0
5250TXT01: DB 'Problem 2',0
5260TXT02: DB 'Problem 3',0
5270TXT03: DB 'Result 0x'
5280TXT03A: DB 0,0,32,0,0,0,0
5290ZOIGIN: DB 'Bye...',13,10,0
5300MATRIX: DB 0,0FFH
5310 DB 'QWERTYUASDFGHJKZXCVBNM,'
5320 DB 0FFH,0FFH,0FFH,0FFH,9,32,10,11,14,15 ; LEFT RIGHT UP DOWN
5330 DB 0FFH, '0.=+',13,'L;',0FFH,'123-'
5340 DB 0FFH,'IO',0FFH,'456*',0FFH,'P',8,0FFH,'789/)'
5350 DB 0FFH,0FFH,0FFH,0FFH,'(',0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
5360 DB 0,12,0FFH

