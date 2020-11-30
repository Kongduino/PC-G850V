10  main() {
20    unsigned char a[34]={
30    0,2,6,2,6,0,4,2,6,0,5,0,5,
40    0,5,0,5,0,5,0,5,0,5,0,5,0,
50    5,0,5,0,5,8,12,99};
60    char b[3][21]={
70    "003C7EFFFFFDFD723C00",
80    "003C4EFFFFFDFD723C00",
90    "003C7EFFFFCDFD723C00"};
100   char u[21]="00000000000000000000";
110   int c,d,i,f=0;
120   unsigned char r;
130   int x=-1,x1=-1,x2=-1,w,m=0,k=0;
140   clrscr();
150   outport(0x60,1);
160   outport(0x61,1);
170   do {
180     c=10;d=0;i=-1;
190     do {
200       outport(0x62,(a[i] & 0xFE));
210       if((a[i] & 1)!=0){
220         r=inport(0x62);
230         if(c!=10) {
240           if(r==1) d+=(1＜＜c);
250           if(c==0) {
260             w=(int)(d/8);
270             if(f==0) x=x1;
280             else x=x2;
290             if(x!=w) {
300               gcursor(70+(k++%50),25);
310               if(k==49){
320                 gcursor(70+48,25);gprint(u);k=0;
330               } else gprint(b[m++%3]);
340               gotoxy(f*5,4);printf("% 5d",d);
350               line(x+(x＜w),f*8,w+(x＞w),7+f*8,2,0xFFFF,2);
360               if(f==0){
370                 a[5]=2;a[6]=6;x1=w;
380               }else{
390                 a[5]=0;a[6]=4;x2=w;
400               }
410               f=1-f;
420             }
430             /*pset(x++,d/22,1); */
440             /*x=(x<144)*x;*/
450           }
460         }
470         c--;
480       }
490     } while(a[i++]!=99);
500   } while(1);
510 }
