100 'PC-G850V UART TEST
110 OUT &H60,2
120 OUT &H74,1
130 OUT &H73,0
140 OUT &H73,1
150 OUT &H73,0
160 OUT &H70,&HD
170 OUT &H71,&H4E
180 OUT &H71,&H10
190 OUT &H63,0
200 OUT &H71,&H5
210 OUT &H63,&H14
220*LOOP
230 X= INP(&H71)
240 IF (X AND &H02)<>0 GOTO *RECEIVE
250 IF (X AND &H04)<>0 GOTO *SEND
260GOTO *LOOP
270*RECEIVE
280 X$= CHR$ (INP(&H72))
290 PRINT X$;
300GOTO *LOOP
310*SEND
320 X$= INKEY$
330 IF X$="" THEN GOTO *LOOP
340 OUT &H72, ASC (X$)
345 FOR I=1 TO 300
346 NEXT
350 GOTO *LOOP

