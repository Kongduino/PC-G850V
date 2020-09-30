10 main()
20 {
30 FILE * pfile;
40 int ch, vch;
50 printf("Hello World\n");
60 pfile=fopen ("stdaux1", "a+");
70 printf("Send Data from PC and press a key\n");
75 printf("Terminate with 0x1a\n");
80 ch=getchar();
90 if (feof(pfile) != EOF)
100 {
110 do
120 {
130 vch = fgetc(pfile);
140 printf("%c",vch);
150 }
160 while (vch != EOF);
170 }
180 printf("\nDONE\n");
190 fprintf (pfile, "Sent to PC over SIO\n");
210 printf("Sent msg to PC over SIO\n");
220 fclose(pfile);
230 }

