10 main() {
20 unsigned char a [34] = {
30 0,2,6,2,6,0,4,2,6,0,5,0,5,0,5,0,
40 5,0,5,0,5,0,5,0,5,0,5,0,5,0,5,8,12,99
50 };
60 int c,d,i,w,x;
70 unsigned char r;
80 x = -1;
90 clrscr();
100 outport(0x60,1);
110 outport(0x61,1);
120 do {
130 c = 10; d = 0; i = -1;
140 do {
150 outport(0x62,(a [i] & 0xFE));
160 if ((a[i] & 1) != 0) {
170 r = inport(0x62);
180 if (c != 10) {
190 if (r == 1) d += (1 << c);
200 if (c == 0) {
210 w = (int)(d / 8);
220 if (x != w) {
230 gotoxy(0,3); printf("% d \ n",d);
240 line(x + (x < w),0,w + (x > w),15,2,0xFFFF,2);
250 x = w;
260 }
270 }
280 }
290 c-;
300 }
310 } while (a[i++] != 99);
320 } while (1);
330 }

