10 OPEN "COM1:"
20 DIM X$(0)*45
30CLS: LOCATE 0,0
40 PRINT "Send a .hex file"
50*MAIN: INPUT # 1,X$(0)
60 C$=LEFT$(X$(0),1)
70 IF C$<>":" THEN "FMTERR"
80 C$=MID$(X$(0),2,2)
90 NB=VAL("&H"+C$)
100 IF NB=0 THEN "THEEND"
110 C$=MID$(X$(0),4,4)
120 A=VAL("&H"+C$): CLS
130 LOCATE 0,0: PRINT "ADDRESS: &H"+C$
140 LOCATE 0,1: PRINT "LENGTH: "+STR$(NB)
150 C$=MID$(X$(0),8,2)
160 IF C$="00" THEN
170 LOCATE 0,2: PRINT MID$(X$(0),10,NB*2)
180 FOR I=0 TO NB-1
190 REM DATA
200 C$=MID$(X$(0),10+I*2,2)
210 V=VAL("&H"+C$)
220 POKE (A),V
230 A=A+1
240 NEXT
170 LOCATE 0,4: PRINT "DONE WITH THAT LINE"
250 ENDIF
260 GOTO "MAIN"
270*FMTERR: PRINT "FORMAT ERROR"
275 CLOSE
280*THEEND: PRINT "DONE"
