s="1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736";
t=[];
j=s.length;
for(i=0;i<j; i+=2) {
  r=parseInt("0x"+s.substr(i,2));
  t[i/2]=r;
}
j/=2;
bscore=0;
bchar=-1;
for(n=1; n<256; n++) {
  score=0;
  for(i=0;i<j; i++){
    x=t[i]^n;
    if (x>31 && x<127) {
      a=String.fromCharCode(x).toUpperCase();
      sc="ETAOIN SHRDLU".indexOf(a);
      if(sc>-1) score+=13-sc;
    }
  }
  if(score>bscore) {
    bscore=score;
    bchar=n;
  }
}
z="";
for(i=0;i<j; i++){
  z=z+String.fromCharCode(t[i]^bchar);
}
console.log("Best char: "+String.fromCharCode(bchar),bchar,bchar.toString(16));
console.log(z);
