10 ORG 100H
20 JP START

30LDPSTR EQU 0BD00H
40GPF EQU 0BFD0H
50PUTSTR EQU 0BFF1H
60WAITK EQU 0BCFDH
70RPTCHR EQU 0BFEEH

100START: CALL CLS
110 LD HL,GREET
120 CALL STRLN
130 LD DE, 0500H
140 CALL PUTSTR

150MAIN: CALL WAITK
160 ; JP Z, MAIN ; wait for a key
170 CP 51H ; ON
180 JP Z, LEAVE
190 CP 01H ; OFF
200 JP Z, LEAVE
210 CP 50H ; CLS
220 JP Z, LEAVE
230 CALL MX2KEY ; convert
240 LD HL,TMP0
250 LD (HL),A
260 LD HL,TMP
270 LD B,3
280 LD DE,0
290 CALL PUTSTR ; display
300 LD B,5 ; 5 columns
310 LD DE,0001H ; y:x
320 LD HL,PIXELS
330 CALL LDPSTR ; scan screen
340 XOR A
350 LD (LINE),A
360MAIN0: LD A,5 ; 5 columns
370 LD (PIXEL),A
380 LD HL,BUFF ; pattern storage
390 LD E,04H ; y:x
400 LD A,(LINE)
410 LD D,A
420 LD B,92
430 CALL LDPSTR
440 LD HL,BUFF
450 LD B,92
460 LD E,08H
470 LD A,(LINE)
480 LD D,A
490 CALL GPF
500 LD DE,PIXELS
510 LD HL,BUFF ; pattern storage
520 LD B,20
530 XOR A
540ZEROBF: LD (HL),A
550 INC HL
560 DJNZ ZEROBF ; zero BUFF
570 LD HL,BUFF
580MAIN2: LD A,(DE)
590 AND 3 ; 00XX
600 CALL PATRN ; get pattern
610 LD (HL),A
620 INC HL
630 LD (HL),A
640 INC HL
650 LD (HL),A
660 INC HL ; 3 columns
670 XOR A
680 LD (HL),A
690 INC HL ; 1 blank column
700 LD A,(DE)
710 RRCA
720 RRCA
730 LD (DE),A ; DE >>2
740 INC DE
750 LD A,(PIXEL)
760 DEC A
770 LD (PIXEL),A
780 CP 0
790 JP NZ,MAIN2 ; loop

800 LD B,20 ; 20 columns
810 LD E,4 ; x=4
820 LD A,(LINE)
830 LD D,A ; y=line
840 INC A
850 LD (LINE),A ; increase line
860 LD HL,BUFF
870 CALL GPF

880 LD A,(LINE)
890 CP 4
900 JP NZ,MAIN0
910 JP MAIN

920LEAVE: LD HL,ZOIGIN
930 CALL STRLN
940 LD DE, 0
950 CALL PUTSTR
960 RET

1000PATRN: LD B,0
1010 CP 0 ; A=0? skip
1020 JP Z,SUITE0
1030 CP 1 ; 01
1040 JP NZ,SUITE1
1050 LD A,07H ; 0000.0111
1060 RET
1070SUITE1: CP 2 ; 10
1080 JP NZ,SUITE2
1090 LD A,70H ; 0111.0000
1100 RET
1110SUITE2: LD B,77H ; 0111.0111
1120SUITE0: LD A,B ; either 0 or 3
1130 RET

1140CLS: LD B, 144
1150 LD DE, 0
1160CLS0: LD A, 32
1170 CALL RPTCHR
1180 RET
1190CLLN: LD B,24
1200 LD E,0
1210 JP CLS0

1220STRLN: LD B,0
1230 PUSH HL ; preserve HL
1240STRLN0: LD A,(HL)
1250 CP 0
1260 JP Z,STRLN1
1270 INC HL
1280 INC B
1290 JP STRLN0
1300STRLN1: POP HL ; restore HL
1310 RET

1320MX2KEY: LD B,0
1330 LD C,A ; A IS KEY INDEX
1340 LD HL, MATRIX
1350 ADD HL, BC
1360 LD A,(HL)
1370 RET

1380PIXELS: DB 0,0,0,0,0
1390BUFF: DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
1391 DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
1392 DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
1393 DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
1394 DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

1400ZOIGIN: DB 'Bye...',13,10,0
1410MATRIX: DB 0,0FFH
1420 DB 'QWERTYUASDFGHJKZXCVBNM,'
1430 DB 0FFH,0FFH,0FFH,0FFH,9,32,10,11,14,15 ; LEFT RIGHT UP DOWN
1440 DB 0FFH, '0.=+',13,'L;',0FFH,'123-'
1450 DB 0FFH,'IO',0FFH,'456*',0FFH,'P',8,0FFH,'789/)'
1460 DB 0FFH,0FFH,0FFH,0FFH,'(',0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
1470 DB 0,12,0FFH
1480LINE: DB 0
1490COLUMN: DB 0
1500PIXEL: DB 0
1510TMP: DB '['
1515TMP0: DB 0,']'
1520GREET: DB 10,'Hello...',10,0

1530BYTE: PUSH AF
1540 AND 0F0H
1550 RRCA
1560 RRCA
1570 RRCA
1580 RRCA
1590 CALL NIBBLE
1600 INC HL
1610 POP AF
1620 AND 15
1630 CALL NIBBLE
1640 INC HL
1650 RET
1660NIBBLE: SUB 10
1670 JP M,ZERO9
1680 ADD A,7
1690ZERO9: ADD A,58
1700 LD (HL),A
1710 RET

