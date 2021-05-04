110 /* test_01.c */
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

260 }
270 }

280 void c_dotp(int a,int b) {
290 int i,j;
300 for (i = 0; i < 6; i++) {
310 for (j = 0; j < 8; j++) {
320 line(a+i*b,j*b,a+i*b+b-2,j*b+b-2,0,65535,1+point(i+6,j));
330 pset(i+6,j,1);
340 a=a+40;
350 line(a+i*b,j*b,a+i*b+b-2,j*b+b-2,0,65535,1+point(i+6,j));
360 pset(i+6,j,1);
365 a=a-40;
370 }
380 }
390 }

