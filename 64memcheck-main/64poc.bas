10 CLS
20 PRINT "MEMCHECKER BY HWR0"
30 CALL 256
40 A = PEEK(&H103)
50 PRINT "0x8000 before: ",A
60 A = PEEK(&H105)
70 PRINT "0x8000 after: ",A
80 A = PEEK(&H104)
90 PRINT "0x8001 before: ",A
100 A = PEEK(&H106)
110 PRINT "0x8001 after: ",A
120 INPUT "Now the RAM - Press Key", B
130 A = PEEK(&H107)
140 PRINT "0x8000 before: ",A
150 A = PEEK(&H109)
160 PRINT "0x8000 after: ",A
170 A = PEEK(&H108)
180 PRINT "0x8001 before: ",A
190 A = PEEK(&H10A)
200 PRINT "0x8001 after: ",A

