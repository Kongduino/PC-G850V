10 ORG 100H
20 JP MAIN

30RPTCHR EQU 0BFEEH
40GPF EQU 0BFD0H
50AOUT EQU 0BD09H
60PUTSTR EQU 0BFF1H
70WAITK EQU 0BFCDH
80LDPSTR EQU 0BD00H

100MAIN: CALL CLS
110 LD DE,0104H
120 LD (POSXY), DE
130 LD HL,LABEL
140 CALL STRLN
150 LD A,B
160 LD (LNSTR),A
170 CALL DSPLBL
180 LD DE,0303H
190 LD (POSXY),DE
200 LD A,48
210 LD (COUNT),A
220 CALL PBAR
230 LD HL,LEGEND
240 LD B,5
250 LD DE,0408H
260 CALL PUTSTR
180 CALL WAIT
190 RET

970LEGEND: DB '50%',13,10
980LABEL: DB ' poking stuff '
990COUNT: DB 0
1000LNSTR: DB 0
1010POSXY: DB 0,0
1020WIDTH: DB 0
1030BUFFER: DEFS 144

1040DSPLBL: LD A,(LNSTR)
1050 LD B,A
1060 LD DE,(POSXY)
1070 CALL PUTSTR
1080 LD A,(LNSTR) ; A chars
1090 ADD A,A ; A*2
1100 LD C,A
1110 ADD A,A ; A*4
1120 ADD A,C ; A*6
1130 LD (WIDTH),A ; A chars x 6 pixels
1140 LD B,A
1150 LD DE,(POSXY)
1160 LD HL,BUFFER
1170 INC HL
1180 INC HL ; leave 2 columns for frame
1190 CALL LDPSTR ; get a copy of the pixels
1200 LD HL,BUFFER
1210 LD (HL),0FFH
1220 INC HL
1230 LD (HL),0FFH ; set the left side of the frame
1240 INC HL
1250 LD A,(WIDTH)
1260 LD B,A
1270LBL0: LD A,(HL) ; get 8-bit column
1280 XOR 7EH ; invert pixels
1290 OR 81H ; set top and bottom to black
1300 LD (HL),A ; save column
1310 INC HL
1320 DJNZ LBL0 ; loop
1330 LD (HL),0FFH
1340 INC HL
1350 LD (HL),0FFH ; set the right side of the frame
1360 LD HL,BUFFER
1370 LD A,(WIDTH)
1380 ADD A,4 ; WIDTH + 4 columns
1390 LD B,A
1400 LD DE,(POSXY)
1410 CALL GPF
1420 RET

1500PBAR: LD A,0FFH
1510 LD HL,BUFFER
1520 LD (HL),A ; left frame
1530 INC HL
1540 LD A,(WIDTH)
1550 DEC A
1560 DEC A ; WIDTH - 2 
1570 LD B,A
1580PBAR0: LD A,(COUNT)
1590 CP 0 ; have we reached the max %?
1600 JP NZ,PBAR1
1610 LD A,81H ; yes, draw top/bottom pixels
1620 JP PBAR2
1630PBAR1: DEC A
1640 LD (COUNT),A ; decrement
1650 LD A,0FFH ; no, draw full column
1660PBAR2: LD (HL),A
1670 INC HL
1680 DJNZ PBAR0 ; loop
1690 LD A,0FFH
1700 LD (HL),A ; right frame
1710 LD HL,BUFFER
1720 LD A,(WIDTH)
1730 LD B,A
1740 LD DE,(POSXY)
1750 CALL GPF
1760 RET

1800WAIT: CALL WAITK
1810 CP 0
1820 JP Z,WAIT
1830 RET


2000CLS: LD B, 144
2010 LD DE, 0
2020CLS0: LD A, 32
2030 CALL RPTCHR
2040 RET
2050CLLN: LD B,24
2060 LD E,0
2070 JP CLS0

3190STRLN: LD B,0
3200 PUSH HL
3210STRLN0: LD A,(HL)
3220 CP 0
3230 JP Z,STRLN1
3240 INC HL
3250 INC B
3260 JP STRLN0
3270STRLN1: POP HL
3280 RET

