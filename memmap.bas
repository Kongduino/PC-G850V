10 CLS
20 OPEN "COM1:": PRINT #1, "Memory Map"
30 CS=&H0100
40 CE=PEEK(&H7FFF)*256+PEEK(&H7FFE)-1
50 LOCATE 1,0: PRINT "Code:"
60 A$=RIGHT$("000"+HEX$(CS),4)+ " - "
70 B$=RIGHT$("000"+HEX$(CE),4)
80 DIM S$(0)*60
90 DIM T$(0)*18
100 LOCATE 7,0: PRINT A$
110 LOCATE 14,0: PRINT B$
120 PRINT #1, "Code:"+A$+ " - "+B$
130 DS=CE+1
140 DE=PEEK(&H7974)*256+PEEK(&H7973)-1
150 LOCATE 1,1: PRINT "RAMD:"
160 A$=RIGHT$("000"+HEX$(DS),4)+ " - "
170 B$=RIGHT$("000"+HEX$(DE),4)
180 PRINT #1, "RAMD:"+A$+ " - "+B$
190 FOR I=DS TO DE STEP 16
200 S$(0)=RIGHT$("000"+HEX$(I),4)+ " "
210 T$(0)="|"
220 FOR J=0 TO 15
230 X=PEEK(I+J)
240 S$(0)=S$(0)+RIGHT$("0"+HEX$(X),2)+ " "
250 IF X<32 THEN
260 T$(0)=T$(0)+"."
270 ELSE
280 T$(0)=T$(0)+CHR$(X)
290 ENDIF
300 NEXT
310 PRINT #1,S$(0)+T$(0)+"|"
320 NEXT
330 LOCATE 7,1: PRINT A$
340 LOCATE 14,1: PRINT B$
350 TS=DE+1
360 TE=PEEK(&H7976)*256+PEEK(&H7975)
370 A$=RIGHT$("000"+HEX$(TS),4)+ " - "
380 B$=RIGHT$("000"+HEX$(TE),4)
390 PRINT #1, "Text:"+A$+ " - "+B$
400 LOCATE 1,2: PRINT "Text:"
410 LOCATE 7,2: PRINT A$
420 LOCATE 14,2: PRINT B$
430 BS=PEEK(&H79E2)*256+PEEK(&H79E1)
440 BE=PEEK(&H79E4)*256+PEEK(&H79E3)
450 A$=RIGHT$("000"+HEX$(BS),4)+ " - "
460 B$=RIGHT$("000"+HEX$(BE),4)
470 PRINT #1, "Text:"+A$+ " - "+B$
480 BS=PEEK(&H79E2)*256+PEEK(&H79E1)
490 BE=PEEK(&H79E4)*256+PEEK(&H79E3)
500 A$=RIGHT$("000"+HEX$(BS),4)+ " - "
510 B$=RIGHT$("000"+HEX$(BE),4)
520 PRINT #1, "BASIC:"+A$+ " - "+B$
530 LOCATE 1,3: PRINT "BASIC:"
540 LOCATE 7,3: PRINT RIGHT$("000"+HEX$(BS),4)+ " - "
550 LOCATE 14,3: PRINT RIGHT$("000"+HEX$(BE),4)



