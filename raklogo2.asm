10 ORG 100H
20 JP MAIN
30GPF EQU 0BFD0H
40WAITK EQU 0BFCDH
50RPTCHR EQU 0BFEEH
60MAIN: CALL CLS
60 LD HL, L0
70 LD B, 144
80 LD DE, 0000H
90 CALL GPF
100 LD HL, L1
110 LD B, 144
120 LD DE, 0100H
130 CALL GPF
140 LD HL, L2
150 LD B, 144
160 LD DE, 0200H
170 CALL GPF
180 LD HL, L3
190 LD B, 144
200 LD DE, 0300H
210 CALL GPF
220 LD HL, L4
230 LD B, 144
240 LD DE, 0400H
250 CALL GPF
260 LD HL, L5
270 LD B, 144
280 LD DE, 0500H
290 CALL GPF
300MAIN0: CALL WAITK
310 CP 0
320 JP Z, MAIN0
330 RET
340CLS: LD B, 144
350 LD DE, 0
360CLS0: LD A, 32
370 CALL RPTCHR
380 RET

1000L0: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1001 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1002 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1003 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1004 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1005 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1006 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1007 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1008 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1009 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1010 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1011 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1012 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1013 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1014 DB 080H, 0C0H, 0C0H, 0E0H, 0F0H, 0F0H, 0F8H, 0F8H
1015 DB 078H, 078H, 07CH, 07CH, 07CH, 07CH, 078H, 078H
1016 DB 038H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1017 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1018L1: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1019 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1020 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1021 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1022 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1023 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1024 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1025 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1026 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1027 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1028 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1029 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1030 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1031 DB 000H, 000H, 080H, 080H, 098H, 01CH, 03EH, 03FH
1032 DB 09FH, 08FH, 087H, 013H, 033H, 039H, 03CH, 01CH
1033 DB 09CH, 09EH, 09EH, 09EH, 09EH, 09EH, 09EH, 01EH
1034 DB 01CH, 000H, 0C0H, 0F0H, 0E0H, 0E0H, 0C0H, 080H
1035 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1036L2: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1037 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1038 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1039 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1040 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1041 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1042 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1043 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1044 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1045 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1046 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1047 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1048 DB 000H, 000H, 0FEH, 0FFH, 0FFH, 0FFH, 0FFH, 000H
1049 DB 000H, 07FH, 0FFH, 0FFH, 0FFH, 000H, 000H, 0FFH
1050 DB 0FFH, 0FFH, 0FFH, 0FFH, 000H, 000H, 00FH, 01FH
1051 DB 01FH, 01FH, 01FH, 0DFH, 0CFH, 0CFH, 0CFH, 0CFH
1052 DB 006H, 000H, 0F8H, 0F1H, 0E3H, 087H, 01FH, 07FH
1053 DB 0FFH, 0FEH, 0FCH, 0F0H, 0E0H, 000H, 000H, 000H
1054L3: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1055 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1056 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1057 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1058 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1059 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1060 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1061 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1062 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1063 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1064 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1065 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1066 DB 000H, 000H, 000H, 007H, 01FH, 03FH, 0FFH, 0FFH
1067 DB 0FCH, 0F0H, 0E1H, 0C7H, 08FH, 00FH, 000H, 0E0H
1068 DB 0F3H, 0F1H, 0F1H, 0F1H, 0F0H, 0F0H, 0F0H, 0F8H
1069 DB 0F0H, 080H, 000H, 01FH, 0FFH, 0FFH, 0FFH, 0FFH
1070 DB 07EH, 000H, 001H, 0FFH, 0FFH, 0FFH, 0FCH, 000H
1071 DB 001H, 07FH, 0FFH, 0FFH, 0FFH, 07EH, 000H, 000H
1072L4: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1073 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1074 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1075 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1076 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1077 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1078 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1079 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1080 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1081 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1082 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1083 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1084 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 001H
1085 DB 003H, 003H, 007H, 00FH, 00FH, 002H, 000H, 038H
1086 DB 078H, 079H, 079H, 079H, 079H, 079H, 079H, 039H
1087 DB 038H, 01CH, 09CH, 0CCH, 0C0H, 0E1H, 0F1H, 0F8H
1088 DB 0FCH, 07CH, 038H, 008H, 001H, 001H, 000H, 000H
1089 DB 000H, 000H, 000H, 001H, 000H, 000H, 000H, 000H
1090L5: DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1091 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1092 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1093 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1094 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1095 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1096 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1097 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1098 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1099 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1100 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1101 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1102 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1103 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 018H
1104 DB 01CH, 03EH, 03EH, 03EH, 03EH, 03EH, 03EH, 03FH
1105 DB 01FH, 01FH, 01FH, 00FH, 00FH, 007H, 003H, 001H
1106 DB 001H, 000H, 000H, 000H, 000H, 000H, 000H, 000H
1107 DB 000H, 000H, 000H, 000H, 000H, 000H, 000H, 000H

