10 ORG 100H
20 JP MAIN
30REGOUT EQU 0BD03H
35INSLN EQU 0BE65H
40DSPDE EQU 0BFF1H
50INITSR EQU 0871AH
60OPENSR EQU 0BCE8H
70CLOSSR EQU 0BCEBH
80LRDSR EQU 0BD15H
90WAITK EQU 0BFCDH
100WSTSR EQU 0BFB2H
110MAIN: CALL INITSR
120 CALL OPENSR
121 LD DE, 0
122 CALL INSLN
123 LD DE, 00100H
124 CALL INSLN
125 LD DE, 00200H
126 CALL INSLN
127 LD DE, 00300H
128 CALL INSLN
129 LD DE, 00400H
130 CALL INSLN
131 LD DE, 00500H
132 CALL INSLN

139 LD DE, 0
140 LD B, 30
150 LD HL, L3
160 CALL DSPDE
170 LD HL, L0
180 CALL WSTSR
190 LD HL, L1
200 CALL LRDSR
210 LD DE, 00500H
220 LD B, 16
230 LD HL, L1
240 CALL DSPDE
250 CALL WAITK
260 CALL REGOUT

900 CALL CLOSSR
910 RET
1000L0: DB 'This me sending stuff from ASM'
1010 DB 13,10,0
1030L3: DB 'SEND STRING                   '
1020L1: DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

