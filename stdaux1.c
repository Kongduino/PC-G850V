10 main () {
20 FILE* FP;
25 int err, cl;
30 printf ("Hello World!");
40 FP = fopen ("stdaux1", "a+");
50 err = fprintf (FP, "Hello World!");
60 cl = fclose (FP);
70 }

