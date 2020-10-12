10 A=&H14C: LA=A
15 OPEN "COM1:"
16 PRINT #1, "": PRINT #1, " -- z80 disasm --"
20 DT=-1: I=-1: DEFD=0: DD=0
25 RA=-1: SA=0
30 DIM SU$(0) * 16
40 DIM SB$(0) * 12
50 DIM D$(0) * 13
60 DIM ALU$(8) * 6
65 DIM ST(5): SI=-1
70 ALU$(0)="ADD A,": ALU$(1)="ADC A,"
80 ALU$(2)="SUB": ALU$(3)="SBC A,"
90 ALU$(4)="AND": ALU$(5)="XOR"
100 ALU$(4)="OR": ALU$(5)="CP"

110*MAIN: CLS : B=PEEK(A)
120 IF DEFD > 0 OR DD > 0 THEN "MAIN0"
130 REM DEFD / DD flags
140 E$=RIGHT$("000"+HEX$(A), 4)+": "
141 IF (A >=I) AND (I>-1) THEN
142 DT=0
143 ENDIF
145 IF DT=0 THEN "DATDSP"

150*MAIN0: SU$(0)=SU$(0)+"0x"+RIGHT$("0"+HEX$(B), 2)+" "
160 D$(0)=""
170 LA=A: A=A+1: RA=-1
180 IF B=&HDD THEN
190 B=PEEK(A)
200 IF B=&HDD OR B=&HED OR B=&HFD THEN
210 DEFD=B
220 LOCATE 0, 4: PRINT "DD,ED,FD PREFIX: "+HEX$(B)
230 GOTO "PRLOOP"
240 ENDIF
250 IF B=&HCB THEN
260 LOCATE 0, 3: PRINT "DDCB PREFIX"
270 A=A+1
280 GOTO "DDCB"
290 ENDIF
300 REM other code
310 DD=1
320 REM this will be used as offset
330 REM HL, H, L replaced by IX, IXH, IX
340 GOTO "MAIN"
350 ENDIF
360 REM SINGLE OPCODES
370 GOSUB "XYZPQ"
380 IF B=&HCB THEN
390 B=PEEK(A): A=A+1
400 GOSUB "XYZPQ"
405 K=Z: CALL "GR"
410 IF X > 0 THEN
420 D$(0)=MID$("BITRESSET",(Y * 3)+1, 3)+","+RR$
430 ELSE
440 D$(0)=MID$("RLCADAA RRCACPL RLA SCF RRA CCF ",(Y * 4)+1, 1)+","+RR$
450 ENDIF
460 GOTO "PRLOOP"
470 ENDIF
480 IF X=1 THEN
490 IF Z=6 AND Y=6 THEN
500 D$(0)="HALT"
510 ELSE
520 K=Y: GOSUB "GR"
530 R$=RR$
540 K=Z: GOSUB "GR"
550 D$(0)="LD "+R$+","+RR$
560 ENDIF
570 GOTO "PRLOOP"
580 ENDIF
590 IF X=3 THEN
600 IF Z=0 THEN
605 K=Y: GOSUB "GETCC"
610 D$(0)="RET "+RR$
620 GOTO "PRLOOP"
630 ENDIF
640 IF Z=1 THEN
650 IF Q=0 THEN
660 K=P: GOSUB "GRP2"
670 D$(0)="POP "+RR$
680 GOTO "PRLOOP"
690 ENDIF
700 IF P=0 THEN
710 D$(0)="RET"
720 GOTO "PRLOOP"
730 ENDIF
740 IF P=1 THEN
750 D$(0)="EXX"
760 GOTO "PRLOOP"
770 ENDIF
780 IF P=2 THEN
790 D$(0)="JP HL"
800 GOTO "PRLOOP"
810 ENDIF
820 IF P=3 THEN
830 D$(0)="LD SP, HL"
840 GOTO "PRLOOP"
850 ENDIF
860 ENDIF
870 IF Z=2 THEN
875 K=Y: GOSUB "GETCC"
880 D$(0)="JP "+RR$
910 GOSUB "MKADR"
915 RA=0: SA=B
920 D$(0)=D$(0)+","+AD$
922 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
923 A=A+1
924 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
925 A=A+1
940 GOTO "PRLOOP"
950 ENDIF
960 IF Z=3 THEN
970 IF Y=0 THEN
1000 GOSUB "MKADR"
1005 RA=0: SA=B
1010 D$(0)="JP "+AD$
1012 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1013 A=A+1
1014 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1015 A=A+1
1030 GOTO "PRLOOP"
1040 ENDIF
1050 IF Y=1 THEN
1060 D$(0)="CB prefix. Shouldn't happen."
1070 GOTO "PRLOOP"
1080 ENDIF
1090 IF Y=2 THEN
1100 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1105 D$(0)="OUT("+AD$+"),A"
1110 A=A+1
1120 GOTO "PRLOOP"
1130 ENDIF
1140 IF Y=3 THEN
1145 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1150 D$(0)="IN A,"+AD$
1160 A=A+1
1170 GOTO "PRLOOP"
1180 ENDIF
1190 IF Y=4 THEN
1200 D$(0)="EX(SP),HL"
1210 GOTO "PRLOOP"
1220 ENDIF
1230 IF Y=5 THEN
1235 D$(0)="EX DE, HL"
1240 A=A+1
1250 GOTO "PRLOOP"
1260 ENDIF
1270 IF Y=6 OR Y=7 THEN
1280 D$(0)=CHR$(62+Y)+"I"
1290 GOTO "PRLOOP"
1300 ENDIF
1310 ENDIF
1320 IF Z=4 THEN
1350 GOSUB "MKADR"
1355 RA=0: SA=B
1355 K=Y: GOSUB "GETCC"
1360 D$(0)="CALL "+RR$+","+AD$
1370 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1375 A=A+1
1380 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1385 A=A+1
1400 GOTO "PRLOOP"
1410 ENDIF
1420 IF Z=5 THEN
1430 REM un beau merdier ce truc
1440 IF Q=0 THEN
1450 K=P: GOSUB "GRP2"
1460 D$(0)="PUSH "+RR$
1470 GOTO "PRLOOP"
1480 ENDIF
1490 REM Q=1
1500 IF P=0 THEN
1510 GOSUB "MKADR"
1515 RA=0: SA=B
1520 D$(0)="CALL "+AD$
1530 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1535 A=A+1
1540 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
1545 A=A+1
1560 GOTO "PRLOOP"
1570 ENDIF
1580 IF P=1 OR P=2 OR P=3 THEN
1590 D$(0)=CHR$(66+P)+"D prefix. Weird."
1600 GOTO "PRLOOP"
1610 ENDIF
1620 ENDIF
1630 IF Z=6 THEN
1640 GOSUB "MKBY": D$(0)=ALU$(Y)+" "+AD$
1650 A=A+1
1660 GOTO "PRLOOP"
1670 ENDIF
1680 IF Z=7 THEN
1690 D$(0)="RST "+STR$(Y * 8)
1700 GOTO "PRLOOP"
1710 ENDIF
1720 ENDIF
1730 IF X=0 THEN
1740 REM le plus gros merdier

1750 IF Z=0 THEN
1760 IF Y=0 THEN
1770 D$(0)="NOP"
1780 GOTO "PRLOOP"
1790 ENDIF
1800 IF Y=1 THEN
1810 D$(0)="EX AF,AF'"
1820 GOTO "PRLOOP"
1830 ENDIF
1840 IF Y=2 THEN
1850 B=PEEK(A)
1860 IF B < 127 THEN
1870 B=B - 128
1880 ENDIF
1890 D$(0)="DJNZ "+RIGHT$("000"+HEX$(A+B), 4)
1900 A=A+1: GOTO "PRLOOP"
1910 ENDIF
1920 IF Y > 2 THEN
1930 B=PEEK(A): D$(0)="JR "
1940 IF B < 127 THEN
1950 B=B - 128
1960 ENDIF
1970 IF Y > 3 THEN
1975 K=Y-4: GOSUB "GETCC"
1980 D$(0)=D$(0)+RR$+","
1990 ENDIF
2000 D$(0)=D$(0)+RIGHT$("000"+HEX$(A+B), 4)
2010 A=A+1: GOTO "PRLOOP"
2020 ENDIF
2030 ENDIF

2040 IF Z=2 THEN
2050 IF Q=0 AND P=0 THEN
2060 D$(0)="LD(BC),A"
2070 GOTO "PRLOOP"
2080 ENDIF
2090 IF Q=0 AND P=1 THEN
2100 D$(0)="LD(DE),A"
2110 GOTO "PRLOOP"
2120 ENDIF
2130 IF Q=1 AND P=0 THEN
2140 D$(0)="LD A,(BC)"
2150 GOTO "PRLOOP"
2160 ENDIF
2170 IF Q=1 AND P=1 THEN
2180 D$(0)="LD A,(DE)"
2190 GOTO "PRLOOP"
2200 ENDIF
2210 IF Q=0 AND P=2 THEN
2220 GOSUB "MKADR"
2230 IF DD=0 THEN
2240 D$(0)="LD("+AD$+"),HL"
2250 ELSE
2260 D$(0)="LD("+AD$+"),IX"
2270 ENDIF
2272 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2273 A=A+1
2274 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2275 A=A+1
2280 GOTO "PRLOOP"
2290 ENDIF
2300 IF Q=0 AND P=3 THEN
2310 GOSUB "MKADR"
2320 D$(0)="LD("+AD$+"),A"
2322 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2323 A=A+1
2324 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2325 A=A+1
2330 GOTO "PRLOOP"
2340 ENDIF
2350 IF Q=1 AND P=2 THEN
2360 GOSUB "MKADR"
2370 IF DD=0 THEN
2380 D$(0)="LD HL,("+AD$+")"
2390 ELSE
2400 D$(0)="LD IX,("+AD$+")"
2410 ENDIF
2412 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2413 A=A+1
2414 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2415 A=A+1
2420 GOTO "PRLOOP"
2430 ENDIF
2440 IF Q=1 AND P=3 THEN
2450 GOSUB "MKADR"
2460 D$(0)="LD A,("+AD$+")"
2462 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2463 A=A+1
2464 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2465 A=A+1
2470 GOTO "PRLOOP"
2480 ENDIF
2490 ENDIF

2500 IF Z=7 THEN
2510 REM le plus simple
2520 D$(0)=MID$("RLCADAA RRCACPL RLA SCF RRA CCF ",(Y * 4)+1, 1)
2530 GOTO "PRLOOP"
2540 ENDIF
2550 IF Z=6 THEN
2560 K=Y: GOSUB "GR"
2570 GOSUB "MKBY": D$(0)="LD "+RR$+","+AD$
2575 SU$(0)=SU$(0)+AD$
2760 A=A+1: GOTO "PRLOOP"
2600 ENDIF

2610 IF Z=4 OR Z=5 THEN
2620 K=Y: GOSUB "GR"
2625 R$=RR$: K=Z-4: GOSUB "GINDC"
2630 D$(0)=RR$+" "+R$
2640 GOTO "PRLOOP"
2650 ENDIF

2660 IF Z=3 THEN
2670 K=P: GOSUB "GRP"
2675 R$=RR$: K=Q: GOSUB "GINDC"
2680 D$(0)=RR$+" "+R$
2690 GOTO "PRLOOP"
2700 ENDIF

2710 IF Z=1 THEN
2715 K=P: GOSUB "GRP": REM STOP
2720 IF Q=0 THEN
2730 GOSUB "MKADR"
2731 IF RR$="HL" OR RR$="IX" THEN
2732 IF (B<&H3000) AND (A<&H2FF) THEN
2733 IF I=-1 THEN
2734 I=B
2735 SB$(0)=SB$(0)+" [1D]"
2737 ELSE
2738 IF I>B THEN
2739 I=B
2740 SB$(0)=SB$(0)+" [ND]"
2742 ENDIF
2743 ENDIF
2744 ENDIF
2745 ENDIF
2750 D$(0)="LD "+RR$+","+AD$
2755 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2757 A=A+1: GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2760 A=A+1: GOTO "PRLOOP"
2770 ELSE
2780 D$(0)="ADD HL,"+RR$
2790 ENDIF
2800 GOTO "PRLOOP"
2810 ENDIF
2830 LOCATE 0, 3: PRINT "NOTHING"

2840*PRLOOP: LOCATE 0, 1: PRINT E$+D$(0)
2842 LOCATE 0,4: PRINT SB$(0)
2844 LOCATE 6,2: PRINT SU$(0)
2846 WHILE LEN(D$(0))<13
2847 D$(0)=D$(0)+" "
2848 WEND
2849 WHILE LEN(SU$(0))<16
2850 SU$(0)=SU$(0)+" "
2851 WEND

2860 PRINT #1, E$+D$(0)+" | "+SU$(0)+" | "+SB$(0)
2870*PRLP0: B=A: GOSUB "MKADR0"
2890*LOOPER: NK$=INKEY$
2900 IF NK$="" THEN "LOOPER"
2901 IF NK$="D" THEN
2902 DT=0: A=LA
2903 ENDIF
2904 IF NK$="A" THEN
2905 DT=-1: A=LA
2906 ENDIF
2907 IF (NK$="G") AND (RA=0) AND (SI<5) THEN
2908 GOSUB "GOADD"
2910 ENDIF
2911 IF (NK$="R") AND (SI>-1) THEN
2912 GOSUB "RETADD"
2913 ENDIF

2915 DEFD=0: DD=0
2920 SB$(0)="": D$(0)=""
2930 GOTO "MAIN"
2940*DDCB: D$(0)="DDCB "
2950 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
2960 DB=PEEK(A)
2970 A=A+1
2980 B=PEEK(A)
2990 GOSUB "MKBY": SU$(0)=SU$(0)+AD$+" "
3000 A=A+1: CALL "XYZPQ"
3010 IF X=0 THEN
3020 IF Z !=6 THEN
3030 K=Z: GOSUB "GR"
3040 D$(0)="LD "+RR$+","
3050 ENDIF
3060 D$(0)=D$(0)+MID$("RLCRRCRL RR SLASRASLLSRL",(Y+1) * 3, 3)+"(IX+"+STR$(DB)+")"
3070 ENDIF
3080 IF X=1 THEN
3090 D$(0)="BIT "+STR$(Y)+",(IX+"+STR$(DB)+")"
3100 ENDIF
3110 IF X=2 THEN
3120 IF Z !=6 THEN
3130 K=Z: GOSUB "GR"
3140 D$(0)="LD "+RR$+","
3150 ENDIF
3160 D$(0)=D$(0)+"RES "+STR$(Y)+",(IX+"+STR$(DB)+")"
3170 ENDIF
3180 IF X=3 THEN
3190 IF Z !=6 THEN
3200 K=Z: GOSUB "GR"
3210 D$(0)="LD "+RR$+","
3220 ENDIF
3230 D$(0)=D$(0)+"SET "+STR$(Y)+",(IX+"+STR$(DB)+")"
3240 GOTO "PRLOOP"
3250 ENDIF
3260 GOTO "PRLOOP"

3270*XYZPQ: X=INT((B AND &HC0)/ 64)
3280 LOCATE 4,0:PRINT "X:"+STR$(X)
3290 Y=INT(((B AND &H38)/ 8)AND 7)
3300 LOCATE 8,0:PRINT "Y:"+STR$(Y)+" "
3310 Z=B AND &H07
3320 LOCATE 12,0:PRINT "Z:"+STR$(Z)+" "
3330 P=INT(Y / 2)
3340 LOCATE 16,0:PRINT "P:"+STR$(P)+" "
3350 Q=Y AND 1
3360 LOCATE 20,0:PRINT "Q:"+STR$(Q)
3370 RETURN

3380*GR: IF DD=1 AND K=4 THEN
3390 RR$="IXH"
3400 ENDIF
3410 IF DD=1 AND K=5 THEN
3420 RR$="IXL"
3430 ENDIF
3440 IF DD=0 THEN
3442 IF K=6 THEN
3443 RR$="(HL)"
3445 ELSE
3450 RR$=MID$("BCDEHL A", K+1, 1)
3455 ENDIF
3460 ENDIF
3470 LOCATE 0, 4
3480 PRINT "GR: DD="+STR$(DD)+": K="+STR$(K)+"==> "+RR$
3490 REM *GR0: NK$=INKEY$
3500 REM IF NK$="" THEN "GR0"
3510 RETURN

3520*GRP: IF DD=1 THEN
3521 IF K=2 THEN
3522 RR$="IX"
3524 ELSE
3526 RR$="??"
3528 ENDIF
3540 ENDIF
3550 IF DD=0 THEN
3560 RR$=MID$("BCDEHLSP",(K * 2)+1, 2)
3570 ENDIF
3580 REM LOCATE 0, 4
3590 REM PRINT "GRP: DD="+STR$(DD)+": K="+STR$(K)+"==> "+RR$
3600 REM *GRP0: NK$=INKEY$
3610 REM IF NK$="" THEN "GRP0"
3615 REM NK$=INKEY$
3620 RETURN

3630*GRP2: IF DD=1 THEN
3640 IF K=2 THEN
3650 RR$="IX."
3660 ELSE
3670 RR$="??"
3680 ENDIF
3690 ENDIF
3700 IF DD=0 THEN
3710 RR$=MID$("BCDEHLAF",(K * 2)+1, 2)
3720 ENDIF
3730 REM LOCATE 0, 4
3740 REM PRINT "GRP2: DD="+STR$(DD)+": K="+STR$(K)+"==> "+RR$
3750 REM *GRP20: NK$=INKEY$
3760 REM IF NK$="" THEN "GRP20"
3770 RETURN

3800*GETCC: RR$=MID$("NZZ NCC POPEP M ",(K * 2)+1, 2)
3810 RETURN

3850*GINDC: RR$=MID$("INCDEC",(K*3)+1, 3)
3860 RETURN

3870*GOADD: SI=SI+1
3875 ST(SI)=A
3880 DT=-1: A=SA
3885 RETURN

3890*RETADD: A=ST(SI)
3895 SI=SI-1
3900 DT=-1
3905 RETURN

4000*MKADR: B=PEEK(A+1) * 256+PEEK(A)
4010*MKADR0: AD$=""
4015 SB$(0)=SB$(0)+" RA "
4020 IF B=&H89BE THEN
4025 AD$="INKEY": RETURN
4030 ENDIF
4035 IF B=&H8440 THEN
4036 AD$="PUTCHR": RETURN
4037 ENDIF
4040 IF B=&H871A THEN
4041 AD$="INITSR": RETURN
4042 ENDIF
4045 IF B=&HBD09 THEN
4046 AD$="AOUT": RETURN
4047 ENDIF
4050 IF B=&HBCE8 THEN
4051 AD$="OPENSR": RETURN
4052 ENDIF
4055 IF B=&HF9BD THEN
4056 AD$="DSPHEX": RETURN
4057 ENDIF
4060 IF B=&HBCEB THEN
4061 AD$="CLOSSR": RETURN
4062 ENDIF
4070 IF B=&HBD15 THEN
4072 AD$="LRDSR": RETURN
4074 ENDIF
4080 IF B=&HBFCD THEN
4082 AD$="WAITK": RETURN
4084 ENDIF
4086 IF B=&HBFB2 THEN
4088 AD$="WSTSR": RETURN
4090 ENDIF
4092 IF B=&HBE65 THEN
4094 AD$="INSLN": RETURN
4096 ENDIF
4098 IF B=&HBFF1 THEN
4100 AD$="DSPDE": RETURN
4104 ENDIF
4106 IF B=&HBD03 THEN
4108 AD$="REGOUT": RETURN
4110 ENDIF

4120 AD$="0x"+RIGHT$("000"+HEX$(B), 4)
4130 RETURN

4200*MKBY: AD$="0x"+RIGHT$("0"+HEX$(PEEK(A)), 2)
4210 RETURN

4220*MKBY0: AD$=RIGHT$("0"+HEX$(PEEK(A)), 2)
4230 RETURN

4300*DATDSP CLS: SB$(0)=""
4305 FOR J=0 TO 5
4310 D$(0)="": SU$(0)=""
4315 E$=RIGHT$("000"+HEX$(A), 4)+": "
4320 FOR I=0 TO 3
4330 GOSUB "MKBY0"
4340 D$(0)=D$(0)+AD$+" "
4350 B=PEEK(A): A=A+1
4360 IF B<32 THEN
4370 SU$(0)=SU$(0)+"."
4380 ELSE
4390 SU$(0)=SU$(0)+CHR$(B)
4400 ENDIF
4410 NEXT I
4420 LOCATE 0, J: PRINT E$+D$(0)+"|"+SU$(0)
4421 IF (J MOD 2)=0 THEN
4422 SB$(0)=E$+D$(0): SV$="|"+SU$(0)
4423 ELSE
4424 PRINT #1, SB$(0)+D$(0)+SV$+SU$(0)
4425 ENDIF
4430 NEXT J
4440 GOTO "PRLP0"

