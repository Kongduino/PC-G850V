10 #define BOOL char
20 #define TRUE 1
30 #define FALSE 0
40 #define BTN 0x02
50 char BTNstate = 0;
60 char LEDstate = 0;
70 BOOL setupPIO() {
80 if(!fopen("pio","a+")) {
90 printf("can't open port. Abort\n");
100 return FALSE;
110 }
120 pioset(BTN);
130 return TRUE;
140 }
150 BOOL pressed() {
160 BOOL rtn=FALSE;
170 char btn;
180 btn=pioget()&BTN;
190 if(btn && BTNstate==0)
200 rtn=TRUE;
210 BTNstate=btn;
220 return rtn;
230 }
240 toggleLED() {
250 LEDstate=!LEDstate;
260 printf("LED=%x\n",LEDstate);
270 pioput(LEDstate);
280 }
290 main() {
300 printf("PIO test. Init: ");
310 if(!setupPIO()) abort();
315 printf("success.\n");
320 while(TRUE) {
105 if(pressed()){
106 printf("button pressed\n");
107 toggleLED();
108 }
109 }
110 }

