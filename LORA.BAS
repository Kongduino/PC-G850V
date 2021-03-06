10 CALL 256
20 OPEN "COM1:"
30 DIM X$(0)*68: FQ=433
40 BW=1
50 SF=12
60 CR=1
70 PWR=20
80 E=0: REM ENCRYPTION 0 OFF 1 ON
90 GOSUB "LOADSETTINGS"
100 REM if there's no settings, at least defaults are set
110 DIM CMD$(0)*64

200*INIT: CALL 256
210 LOCATE 0,0:PRINT "LoRa Messenger"
220 PRINT "[Z] [X] [/]"
225 PRINT "[P] [Q]"

230*MAINLOOP: A$= INKEY$
240 IF A$="X" THEN "SENDTEXT"
250 IF A$="Q" THEN "BAIL"
260 IF A$="/" THEN "SETTINGS"
270 IF A$="Z" THEN "RECEIVE"
280 IF A$="P" THEN "PASSWD"
290 GOTO "MAINLOOP"

300*RECEIVE: GOSUB "CLEARBOTTOMHALF"
310 LOCATE 0,3: PRINT "Rx: "
320 INPUT # 1,X$(0)
330 LOCATE 0,4: PRINT X$(0)
340 CLOSE : OPEN "COM:"
350 REM prevents I/O errors
360*RCVLOOP: A$= INKEY$
370 IF A$="" THEN "RCVLOOP"
380 GOTO "INIT"
390 REM wait for key press

400*SENDTEXT: GOSUB "CLEARBOTTOMHALF"
410 LOCATE 0,3: INPUT "Text: "; X$(0)
470 PRINT #1,"S"+X$(0)
490 GOTO "INIT"

500*SETTINGS: CLS : PRINT " SETTINGS"
520 PRINT "[F]req [S]F [P]wr"
530 PRINT "[B]W [C]R [B]ACK"
570 ENDIF

580*SETTINGSLOOP: A$= INKEY$
670 IF A$="F" THEN
680 GOSUB "CLEARBOTTOMHALF"
690 LOCATE 0,4: INPUT "Freq: "; F
700 IF F>115 AND F<1000 THEN
710 FQ=F
720 ENDIF
730 GOTO "SETTINGS"
740 ENDIF
750 IF A$="P" THEN
760 GOSUB "CLEARBOTTOMHALF"
770 LOCATE 0,4: INPUT "Power: "; F
780 IF F>4 AND F<21 THEN
790 PWR=F
800 ENDIF
810 GOTO "SETTINGS"
820 ENDIF
830 IF A$="B" THEN
850 GOSUB "CLEARBOTTOMHALF"
860 REM WAIT (3*64)
870 LOCATE 0,4: PRINT CMD$(0)
880 GOSUB "SAVESETTINGS"
890 WAIT (0)
900 GOTO "INIT"
910 ENDIF
920 IF A$="C" THEN
930 LOCATE 0,4: PRINT "C/R 4/[5678]"

940*CRLOOP: B$= INKEY$
950 IF B$="" THEN "CRLOOP"
960 F= VAL (B$)
970 IF F<5 OR F>8 THEN "CRLOOP"
980 CR=F-4
990 GOTO "SETTINGS"
1000 ENDIF
1010 IF A$="S" THEN
1020 GOSUB "CLEARBOTTOMHALF"
1030 LOCATE 0,4: INPUT "SF [6-12]: "; F
1040 IF F<6 OR F>12 THEN "SETTINGSLOOP"
1050 SF=F
1060 GOTO "SETTINGS"
1070 ENDIF
1080 IF A$="B" THEN
1090 LOCATE 0,4: PRINT "BW 125/250/500 [012]"
1100*BWLOOP: B$= INKEY$
1110 IF B$="" THEN "BWLOOP"
1120 IF B$<"0" OR B$>"2" THEN "BWLOOP"
1130 BW= VAL (B$)
1140 GOTO "SETTINGS"
1150 ENDIF
1160 GOTO "SETTINGSLOOP"

1200*PASSWD: GOSUB "CLEARBOTTOMHALF"
1210 LOCATE 0,3:X$(0)=""
1220 INPUT "Pwd: "; X$(0)
1230 GOSUB "CLEARBOTTOMHALF"
1240 I=LEN(X$(0))
1250 IF I=0 THEN
1260 PRINT #1,"e"
1270 LOCATE 0,3: PRINT "Encryption OFF"
1280 GOSUB "WAITKEY"
1290 GOTO "INIT"
1300 ENDIF
1310 IF I=32 OR I=64 THEN
1320 PRINT #1,"E"
1330 PRINT #1,"P"+X$(0)
1340 LOCATE 0,3: PRINT "Password sent."
1350 GOSUB "WAITKEY"
1360 GOTO "INIT"
1370 ENDIF
1380*PWFAIL: LOCATE 0,3: PRINT "Incorrect length ["+STR$(I)+"]."
1390 GOSUB "WAITKEY"
1400 GOTO "INIT"


1500*WAITKEY: LOCATE 0,5: PRINT "Press a key..." 
1510 A$= INKEY$
1520 IF A$="" THEN "WAITKEY"
1530 RETURN

2000*CLEARBOTTOMHALF: LINE (0,24)-(143,47),R,BF
2010 RETURN

2020*PREPAREATCMD: J= LEN (X$(0)): CMD$(0)=""
2030 FOR I=1 TO J
2040 Y$= MID$ (X$(0),I,1): N= ASC (Y$)
2050 M= INT (N/16)
2060 IF M<10 THEN
2070 CMD$(0)=CMD$(0)+ CHR$ (M+48)
2080 ELSE
2090 CMD$(0)=CMD$(0)+ CHR$ (M+55)
2100 ENDIF
2110 M=N-(M*16)
2120 IF M<10 THEN
2130 CMD$(0)=CMD$(0)+ CHR$ (M+48)
2140 ELSE
2150 CMD$(0)=CMD$(0)+ CHR$ (M+55)
2160 ENDIF
2170 NEXT I
2180 RETURN

2190*SENDATSETTINGS: CMD$(0)="at+set_config=lorap2p:"+ STR$ (FQ*1000000)+":"
2200 CMD$(0)=CMD$(0)+ STR$ (SF)+":"+ STR$ (BW)+":"+ STR$ (CR)+":8:"+ STR$ (PWR)+""
2210 PRINT #1, CMD$(0)
2220 RETURN

2300*LOADSETTINGS: OPEN "E:LORA.TXT" FOR INPUT AS #2
2310*LOOPLOADS: LNINPUT #2, X$(0)
2320 PRINT #1, "-Dealing with "+X$(0)
2330 IF EOF (2) THEN
2340 CLOSE #2
2350 GOTO "SETTINGS2"
2360 ENDIF
2370 C$= LEFT$ (X$(0),2)
2380 V= VAL(MID$ (X$(0),3,7))
2390 IF C$="FQ" THEN
2400 FQ=V
2410 ENDIF
2420 IF C$="CR" THEN
2430 CR=V
2440 ENDIF
2450 IF C$="BW" THEN
2460 BW=V
2470 ENDIF
2480 IF C$="SF" THEN
2490 SF=V
2500 ENDIF
2510 IF C$="PW" THEN
2520 PW=V
2530 ENDIF
2540 GOTO "LOOPLOADS"

2550*SETTINGS2: OPEN "E:PWD.TXT" FOR INPUT AS #2
2560*LOOPLOAD2: LNINPUT #2, X$(0)
2570 PRINT #1, "-Dealing with "+X$(0)
2580 IF EOF (2) THEN
2590 CLOSE #2
2600 RETURN
2610 ENDIF
2620 C$= LEFT$ (X$(0),1)
2630 IF C$="E" THEN
2640 C$=MID$ (X$(0),2,1)
2650 IF C$="Y" THEN
2660 E=1: PRINT #1,"E"
2670 ELSE
2680 E=0: PRINT #1,"e"
2690 ENDIF
2700 ENDIF
2710 IF C$="P" THEN
2720 IF I=32 OR I=64 THEN
2730 PRINT #1,"E"
2740 E=1
2750 PRINT #1,"P"+X$(0)
2760 ENDIF
2770 ENDIF
2780 GOTO "LOOPLOAD2"


2800*SAVESETTINGS: OPEN "E:LORA.TXT" FOR OUTPUT AS #2
2810 PRINT #2, "FQ"+ STR$ (FQ)
2820 PRINT #2, "CR"+ STR$ (CR)
2830 PRINT #2, "BW"+ STR$ (BW)
2840 PRINT #2, "SF"+ STR$ (SF)
2850 PRINT #2, "PW"+ STR$ (PW)
2860 CLOSE #2
2870 RETURN
2880*SAVESETTINGS2: OPEN "E:PWD.TXT" FOR OUTPUT AS #2
2890 PRINT #2, "E"+ STR$ (E)
2900 PRINT #2, "P"+ X$(0)
2910 CLOSE #2

3000*BAIL: CLS : PRINT "Good bye..."
3010 CLOSE
3020 END

