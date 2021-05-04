110 /* test_01.c */
111 /* https://cutt.ly/hbbB2UL */
112 /* BY @hangyodon1123 */
103 /* updated by @Kongduino */

120 main() {
130 int k;
140 void c_dotp(int,int);
150 clrscr();
160 gotoxy(0,0);
170 printf("c_ver 0.1 hit any key");
180 while (1) {
190 k = getch();
200 clrscr();
210 gotoxy(0,0);
220 printf("[%c]\n",k);
230 printf("%XH\n",k);
240 c_dotp(20,6);
250 }
260 }

270 void c_dotp(int a,int b) {
280 int i,j;
290 for (i = 0; i < 6; i++) {
300 for (j = 0; j < 8; j++) {
310 line(a+i*b,j*b,a+i*b+b-2,j*b+b-2,0,65535,1+point(i+6,j));
320 pset(i+6,j,1);
330 a=a+40;
340 line(a+i*b,j*b,a+i*b+b-2,j*b+b-2,0,65535,1+point(i+6,j));
350 pset(i+6,j,1);
360 a=a-40;
370 }
380 }
390 }

