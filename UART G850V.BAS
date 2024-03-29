10 DIM TX$(0)*68
15 GOSUB *INIT
20 *LOOP
25 LOCATE 0,1
30 X=INP (&H71)
31 IF (X AND &H02)<>0 THEN
32 A$=CHR$(INP(&H72))
33 TX$(0)=A$
40 WHILE ASC(A$)>31
50 A$=CHR$(INP(&H72))
60 PRINT A$;
61 FOR I=1 TO 200
62 NEXT
63 TX$(0)=TX$(0)+A$
64 X=INP (&H71)
65 WHILE (X AND &H02)=0
66 X=INP (&H71)
67 WEND
70 WEND
71 ENDIF
75 A$=INKEY$
80 IF A$<>"" GOTO *SEND
90 GOTO *LOOP

2000 *INIT 'PC-G850V UART TEST
2010 OUT &H60,2
2020 OUT &H74,1
2030 OUT &H73,0
2040 OUT &H73,1
2050 OUT &H73,0
2060 OUT &H70,&HD
2070 OUT &H71,&H4E
2080 OUT &H71,&H10
2090 OUT &H63,0
2100 OUT &H71,&H5
2110 OUT &H63,&H14
2120 RETURN

2500 *RECEIVE
2510 WHILE (X AND &H02)<>0
2520 A$=CHR$(INP(&H72))
2530 PRINT A$;
2540 X=INP (&H71)
2550 WEND
2560 GOTO *LOOP

3000 *SEND
3010 LOCATE 0,3: PRINT "Text: "+A$
3020 LOCATE 7,3: INPUT TX$(0)
3030 TX$(0)=A$+TX$(0)
3040 J=LEN(TX$(0))
3050 CLS
3060 FOR I=1 TO J
3070 OUT &H72, ASC (MID$(TX$(0),I,1))
3080 LOCATE I-1,0: PRINT MID$(TX$(0),I,1)
3090 NEXT
3100 FOR I=1 TO 300
3110 NEXT
3120 GOTO *LOOP

