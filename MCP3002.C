10 main () {
20   unsigned char a[34]={
30   0,2,6,2,6,0,4,2,6,
40   0,5,0,5,0,5,0,5,0,5,
50   0,5,0,5,0,5,0,5,0,5,0,5,
55   8,12,99
60   };
70   int c,d,i;
80   unsigned char r;
90   int x=-1;int w;
100   clrscr();
110   outport(0x60,1);
120   outport(0x61,1);
130   do {
140     c=10;d=0;i=-1;
150     do {
160       outport(0x62,(a[i] & 0xFE));
170       if((a[i] & 1)!=0) {
180         r=inport(0x62);
190         if(c!=10) {
200           if(r==1) d+=(1<<c);
205           if(c==0) {
210             w=(int)(d/8);
220             if(x!=w) {
230               gotoxy(0,3);printf("%d\n",d);
240               line(x+(x<w),0,w+(x>w),15,2,0xFFFF,2);
250               x=w;
260             }
270           }
280         }
290         c--;
300       }
310     } while(a[i++]!=99);
320   } while(1);
330 }


