10 ORG 100H
20 JP MAIN

30REGOUT EQU 0BD03H
40RPTCHR EQU 0BFEEH
50GPF EQU 0BFD0H
60AOUT EQU 0BD09H
70PUTSTR EQU 0BFF1H
80WAITK EQU 0BFCDH

100MAIN: CALL CLS
110 LD A,64
120 LD B,6
130 CALL DIV
140 PUSH AF
150 LD A,D
160 LD HL,RSLT0
170 CALL HX2DEC
180 POP AF
190 LD HL,RSLT1
200 CALL HX2DEC
210 LD HL,RSLT
220 CALL STRLN
225 LD DE,0400H
230 CALL PUTSTR
240 RET

1000DIV: LD D,0
1010 ; A=X. B=Y. D=RSLT
1020DIV00: CP B
1030 JP M,DIV01
1040 SUB B
1050 INC D
1060 JP DIV00
1070DIV01: RET
1080 ; D=RESULT A=REMAINDER

3140CLS: LD B, 144
3150 LD DE, 0
3160CLS0: LD A, 32
3170 CALL RPTCHR
3180 RET
3190CLLN: LD B,24
3200 LD E,0
3210 JP CLS0

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

4000HX2DEC: LD B,'0'
4010 LD (HL),B
4020HDEC00: LD (TMP),A
4030 CP 100
4040 JP M,HDEC01
4050 INC (HL)
4060 SUB 100
4070 JP HDEC00
4080HDEC01: INC HL
4090 LD B,'0'
4100 LD (HL),B
4110 LD A,(TMP)
4120HDEC02: LD (TMP),A
4130 CP 10
4140 JP M,HDEC03
4150 INC (HL)
4160 SUB 10
4170 JP HDEC02
4180HDEC03: INC HL
4185 LD A,(TMP)
4190 ADD A,48
4200 LD (HL),A
4210 RET

5000RSLT: DB '64 / 6 = '
5010RSLT0: DB 0,0,0
5020 DB ', R = '
5030RSLT1: DB 0,0,0,0
5040TMP: DB 0


