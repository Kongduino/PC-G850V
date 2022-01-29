var EQUs={};
EQUs["0xBE62"]="PUTCHR";
EQUs["0x8440"]="PUTCHR";
EQUs["0xBFF1"]="DSPSTR";
EQUs["0xBFF4"]="RUN";
EQUs["0xBFEE"]="RPTCHR";
EQUs["0xBCFD"]="GETCHR";
EQUs["0x88C1"]="GETCHR";
EQUs["0xBFCD"]="WAITK";
EQUs["0xBE53"]="INKEY";
EQUs["0x89BE"]="INKEY";
EQUs["0xBCEE"]="ADCRLF";
EQUs["0xBE65"]="INSLN";
EQUs["0xBD09"]="AOUT";
EQUs["0xF9BD"]="A2HEX";
EQUs["0xBD0F"]="HLOUT";
EQUs["0xBD03"]="REGOUT";
EQUs["0x84F7"]="ROLLUP";
EQUs["0x871A"]="INITSR";
EQUs["0xBFAF"]="WRASR";
EQUs["0xBCE8"]="OPENSR";
EQUs["0xBCEB"]="CLOSSR";
EQUs["0xBD15"]="LRDSR";
EQUs["0xBFB2"]="WSTSR";
EQUs["0xBCDF"]="RDBSR0";
EQUs["0xBCE2"]="RDBSR1";
EQUs["0xBCE5"]="RDBSR2";
EQUs["0xBD00"]="LDPSTR";
EQUs["0xBFD0"]="WPIXELS";
EQUs["0xBD2D"]="PWROFF";
EQUs["0xC110"]="PWROFF";
EQUs["0xBCF1"]="CLRBAS";
EQUs["0xBCF7"]="CLRTXT";

var lastBlob="";

function hexDump(buf) {
  var result = [];
  var len = buf.byteLength;
  buf = new Uint8Array(buf);
  var alphabet = "0123456789abcdef".split("");
  console.log("   +------------------------------------------------+ +----------------+");
  result.push("   +------------------------------------------------+ +----------------+");
  console.log("   |.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 .a .b .c .d .e .f | |      ASCII     |");
  result.push("   |.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 .a .b .c .d .e .f | |      ASCII     |");
  for (i = 0; i < len; i += 16) {
    if (i % 128 == 0) {
      console.log("   +------------------------------------------------+ +----------------+");
      result.push("   +------------------------------------------------+ +----------------+");
    }
    var s = "|                                                | |                |".split("");
    var ix = 1, iy = 52, j;
    for (j = 0; j < 16; j++) {
      if (i + j < len) {
        var c = buf[i + j];
        s[ix++] = alphabet[(c >> 4) & 0x0F];
        s[ix++] = alphabet[c & 0x0F];
        ix++;
        if (c > 31 && c < 128) s[iy++] = String.fromCharCode(c);
        else s[iy++] = '.';
      }
    }
    var index = i / 16;
    var zeNum = "";
    if (i < 256) zeNum += "0";
    zeNum += index.toString(16) + ".";
    console.log(zeNum + s.join(""));
    result.push(zeNum + s.join(""));
  }
  console.log("   +------------------------------------------------+ +----------------+");
  result.push("   +------------------------------------------------+ +----------------+");
  return result.join("\n");
}


function openFile() {
  document.getElementById('inp').click();
}

function readFile(e) {
  var file = e.target.files[0];
  if (!file) return;
  var reader = new FileReader();
  reader.onload = function(e) {
    document.getElementById('contents').innerHTML = hexDump(e.target.result);
    document.getElementById('decoded').innerHTML = disasm(e.target.result);
  }
  reader.readAsArrayBuffer(file)
}

var tableR = "B,C,D,E,H,L,(HL),A".split(",");
var tableRP = "BC,DE,HL,SP".split(",");
var tableRP2 = "BC,DE,HL,AF".split(",");
var tableCC = "NZ,Z,NC,C,PO,PE,P,M".split(",");
var tableALU = "ADD A,ADC A,SUB,SBC A,AND,XOR,OR,CP".split(",");
var tableROT = "RLC,RRC,RL,RR,SLA,SRA,SLL,SRL".split(",");
var tableIM = "0,0/1,1,2,0,0/1,1,2".split(",");
var tableBLI = [];
tableBLI.push("LDI,CPI,INI,OUTI".split(","));
tableBLI.push("LDD,CPD,IND,OUTD".split(","));
tableBLI.push("LDIR,CPIR,INIR,OTIR".split(","));
tableBLI.push("LDDR,CPDR,INDR,OTDR".split(","));
var tableX0Z7 = "RLCA,RRCA,RLA,RRA,DAA,CPL,SCF,CCF".split(",");
var tableX1Z7 = "LD I, A;LD R, A;LD A, I;LD A, R;RRD;RLD;NOP;NOP".split(";");


// http://z80.info/decoding.htm#upfx
function opcodeToBits(n) {
  var buf = new Uint8Array(5); // x, y, z, p, q
  buf[0] = (n >> 6) & 0b011;
  buf[1] = (n >> 3) & 0b111;
  buf[2] = n & 0b111;
  buf[3] = (n >> 4) & 0b011;
  buf[4] = (n >> 3) & 0b001;
  return buf;
}

function displacement(n) {
  if (n < 128) return "$+" + (n + 2).toString();
  return "$" + (n - 255).toString();
}

function currentAddr(i, baseAddr) {
  var rslt = "0x";
  var tmp = ("000"+(i + baseAddr).toString(16)).substr(-4).toUpperCase();
  return rslt + tmp;
}

function format16(nn) {
  return ("000" + nn.toString(16)).substr(-4).toUpperCase();
}

function format8(n) {
  return ("0" + n.toString(16)).substr(-2).toUpperCase();
}

function disasm(blob) {
  var len = blob.byteLength;
  //console.log("len =", len)
  document.getElementById('reload').style.display = 'block';
  lastBlob=blob;
  buf = new Uint8Array(blob);
  var result = [];
  var i = 0;
  var baseAddr = parseInt("0x"+document.getElementById('BaseAddr').value);
  console.log("baseAddr: 0x"+format16(baseAddr));
  var addresses = {};
  while (i < len) {
    var explain = [";"];
    var ascii = ["|"];
    var ctAddr = currentAddr(i, baseAddr);
    n = buf[i];
    explain.push(format8(n));
    if (n < 32 || n > 127) ascii.push(".");
    else ascii.push(String.fromCharCode(n));
    var inc = 1;
    var bits = opcodeToBits(n);
    var x = bits[0];
    var y = bits[1];
    var z = bits[2];
    var p = bits[3];
    var q = bits[4];
    //console.log("x =", x, "y =", y, "z =", z, "p =", p, "q =", q);
    if (x == 0) {
      if (z == 7) result.push(ctAddr + " " +tableX0Z7[y]);
      else if (z == 0) {
        if (y == 0) result.push(ctAddr + " " +"NOP");
        else if (y == 1) result.push(ctAddr + " " +"EX AF, AF'");
        else if (y == 2) {
          inc = 2;
          n = buf[i + 1];
          result.push(ctAddr + " " +"DJNZ " + displacement(n));
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
        } else if (y == 2) {
          inc = 2;
          n = buf[i + 1];
          result.push(ctAddr + " " +"JR " + displacement(n));
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
        } else {
          n = buf[i + 1];
          inc = 2;
          result.push(ctAddr + " " +"JR " + tableCC[y - 4] + displacement(n));
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
        }
      } else if (z == 1) {
        var rpp = tableRP[p];
        if (q == 0) {
          n = buf[i + 1];
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          n = buf[i + 2];
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          inc = 3;
          var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
          // addresses[myAddr] = "Y";
          result.push(ctAddr + " " +"LD " + rpp + ", " + myAddr);
        } else if (q == 1) {
          result.push(ctAddr + " " +"ADD HL, " + rpp);
        }
      } else if (z == 2) {
        if (q == 0) {
          if (p == 0) result.push(ctAddr + " " +"LD (BC), A");
          else if (p == 1) result.push(ctAddr + " " +"LD (DE), A");
          else if (p == 2) {
            n = buf[i + 1];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            n = buf[i + 2];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            inc = 3;
            var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
            // addresses[myAddr] = "Y";
            result.push(ctAddr + " " +"LD (" + myAddr + "), HL");
          } else if (p == 3) {
            n = buf[i + 1];
            explain.push(format8(n));
            n = buf[i + 2];
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            inc = 3;
            var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
            // addresses[myAddr] = "Y";
            result.push(ctAddr + " " +"LD (" + myAddr + "), A");
          }
        } else if (q == 1) {
          if (p == 0) result.push(ctAddr + " " +"LD A, (BC)");
          else if (p == 1) result.push(ctAddr + " " +"LDA, (DE)");
          else if (p == 2) {
            n = buf[i + 1];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            n = buf[i + 2];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            inc = 3;
            var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
            // addresses[myAddr] = "Y";
            result.push(ctAddr + " " +"LD HL, (" + myAddr + ")");
          } else if (p == 3) {
            n = buf[i + 1];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            n = buf[i + 2];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            inc = 3;
            var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
            // addresses[myAddr] = "Y";
            result.push(ctAddr + " " +"LD A, (" + myAddr + ")");
          }
        }
      } else if (z == 3) {
        var rpp = tableRP[p];
        if (q == 0) {
          result.push(ctAddr + " " +"INC " + rpp);
        } else if (q == 1) {
          result.push(ctAddr + " " +"DEC " + rpp);
        }
      } else if (z == 4) {
        var ry = tableR[y];
        result.push(ctAddr + " " +"INC " + ry);
      } else if (z == 5) {
        var ry = tableR[y];
        result.push(ctAddr + " " +"DEC " + ry);
      } else if (z == 6) {
        var ry = tableR[y];
        var n = buf[i + 1];
        var ns = format8(n);
        result.push(ctAddr + " " +"LD " + ry + ", 0x" + ns);
        inc = 2;
        explain.push(ns);
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
      }
    } else if (x == 1) {
      if (z == 6) {
        if (y == 6) result.push(ctAddr + " " +"HALT");
        else result.push(ctAddr + " " +"?");
      } else {
        result.push(ctAddr + " " +"LD " + tableR[y] + ", " + tableR[z]);
      }
    } else if (x == 2) {
      result.push(ctAddr + " " +tableALU[y] + " " + tableR[z]);
    } else if (x == 3) {
      if (z == 0) {
        result.push(ctAddr + " " +"RET " + tableCC[y]);
      } else if (z == 1) {
        if (q == 0) result.push(ctAddr + " " +"POP " + tableRP2[p]);
        else if (q == 1) {
          if (p == 0) result.push(ctAddr + " " +"RET");
          else if (p == 1) result.push(ctAddr + " " +"EXX");
          else if (p == 2) result.push(ctAddr + " " +"JP HL");
          else if (p == 3) result.push(ctAddr + " " +"LD SP, HL");
        }
      } else if (z == 2) {
        n = buf[i + 1];
        explain.push(format8(n));
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
        n = buf[i + 2];
        explain.push(format8(n));
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
        inc = 3;
        var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
        addresses[myAddr] = "Y";
        result.push(ctAddr + " " +"JP " + tableCC[y] + ", <a href='#L"+ myAddr+"'>" + myAddr + "</a>");
      } else if (z == 3) {
        if (y == 0) {
          n = buf[i + 1];
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          n = buf[i + 2];
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          inc = 3;
          var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
          addresses[myAddr] = "Y";
          result.push(ctAddr + " " +"JP <a href='#L"+ myAddr+"'>" + myAddr + "</a>");
        } else if (y == 1) {
          // CB prefix
          inc = 2;
          n = buf[i + 1];
          bits = opcodeToBits(n);
          x = bits[0];
          y = bits[1];
          z = bits[2];
          p = bits[3];
          q = bits[4];
          console.log("CB prefix. x =", x, "y =", y, "z =", z, "p =", p, "q =", q);
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          if (x == 0) result.push(ctAddr + " " +tableROT[y] + " " + tableR[z]);
          else if (x == 1) result.push(ctAddr + " " +"BIT " + y.toString() + ", " + tableR[z]);
          else if (x == 2) result.push(ctAddr + " " +"RES " + y.toString() + ", " + tableR[z]);
          else if (x == 3) result.push(ctAddr + " " +"SET " + y.toString() + ", " + tableR[z]);
        } else if (y == 2) {
          n = buf[i + 1];
          inc = 2;
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          result.push(ctAddr + " " +"OUT (Ox" + format8(n) + "), A");
        } else if (y == 3) {
          n = buf[i + 1];
          inc = 2;
          explain.push(format8(n));
          if (n < 32 || n > 127) ascii.push(".");
          else ascii.push(String.fromCharCode(n));
          result.push(ctAddr + " " +"IN A, (Ox" + format8(n) + ")");
        } else if (y == 4) {
          result.push(ctAddr + " " +"EX (SP), HL");
        } else if (y == 5) {
          result.push(ctAddr + " " +"EX DE, HL");
        } else if (y == 6) {
          result.push(ctAddr + " " +"DI");
        } else if (y == 7) {
          result.push(ctAddr + " " +"EI");
        }
      } else if (z == 4) {
        n = buf[i + 1];
        explain.push(format8(n));
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
        n = buf[i + 2];
        explain.push(format8(n));
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
        inc = 3;
        var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
        if (EQUs[myAddr]!=undefined) myAddr = EQUs[myAddr] + " ["+myAddr+"]";
        else addresses[myAddr] = "Y";
        result.push(ctAddr + " " +"CALL " + tableCC[y] + ", <a href='#L"+ myAddr+"'>" + myAddr + "</a>");
      } else if (z == 5) {
        if (q == 0) {
          result.push(ctAddr + " " +"PUSH " + tableRP2[p]);
        } else if (q == 1) {
          if (p == 0) {
            n = buf[i + 1];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            n = buf[i + 2];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            inc = 3;
            var myAddr = "0x" + format8(buf[i + 2]) + format8(buf[i + 1]);
            if (EQUs[myAddr]!=undefined) myAddr = EQUs[myAddr] + " ["+myAddr+"]";
            else addresses[myAddr] = "Y";
            result.push(ctAddr + " " +"CALL <a href='#L"+ myAddr+"'>" + myAddr + "</a>");
          } else if (p == 1 || p == 3) {
            // DD prefix / FD prefix
            var prefix = "IX";
            if (p == 3) prefix = "IY";
            // The FD prefix acts exactly like the DD prefix, but the IY register is used instead of IX.
            result.push(ctAddr + " " +"DD / FD prefix");
          } else if (p == 2) {
            // ED prefix
            n = buf[i+1];
            explain.push(format8(n));
            if (n < 32 || n > 127) ascii.push(".");
            else ascii.push(String.fromCharCode(n));
            var inc = 1;
            var bits = opcodeToBits(n);
            var x = bits[0];
            var y = bits[1];
            var z = bits[2];
            var p = bits[3];
            var q = bits[4];
            inc = 2;
            if (x==0 || x==3) {
              n = buf[i + 1];
              explain.push(format8(n));
              if (n < 32 || n > 127) ascii.push(".");
              else ascii.push(String.fromCharCode(n));
              result.push(ctAddr + " NONI + NOP ; !");
            } else if (x==2) {
              if (z <= 3 && y >= 4) result.push(ctAddr + " " +tableBLI[y-4][z]);
              else {
                n = buf[i + 1];
                explain.push(format8(n));
                if (n < 32 || n > 127) ascii.push(".");
                else ascii.push(String.fromCharCode(n));
                result.push(ctAddr + " NONI + NOP ; !!");
              }
            } else if (x == 1) {
              if(z==0) {
                if(y==6) result.push(ctAddr + " IN (C)");
                else result.push(ctAddr + " IN "+tableR[y]+",(C)");
              } else if(z==1) {
                if(y==6) result.push(ctAddr + " OUT (C), 0");
                else result.push(ctAddr + " OUT C, "+tableR[y]);
              } else if(z==2) {
                if(q==0) result.push(ctAddr + " SBC HL, "+tableRP[p]);
                else result.push(ctAddr + " ADC HL, "+tableRP[p]);
              }
            }
          }
        }
      } else if (z == 6) {
        n = buf[i + 1];
        inc = 2;
        explain.push(format8(n));
        if (n < 32 || n > 127) ascii.push(".");
        else ascii.push(String.fromCharCode(n));
        result.push(ctAddr + " " +tableALU[y]+" 0x" + format8(n));
      } else if (z == 7) {
        result.push(ctAddr + " RST 0x" + format8(y));
      }
    } else result.push(ctAddr + " " +"?");
    var padding0 = "&nbsp;";
    var padding1 = "&nbsp;";
    var ln0 = 32 - result[result.length - 1].length;
    while (ln0-- > 0) padding0 += "&nbsp;";
    ln0 = (4 - inc) * 3;
    while (ln0-- > 0) padding1 += "&nbsp;";
    result[result.length - 1] += padding0 + explain.join(" ") + padding1 + ascii.join("");
    i += inc;
  }
  ln = result.length;
  for (i=0; i<ln; i++) {
    result[i] = result[i].trim();
    var t = result[i].split(" ");
    var s = t[0];
    if (addresses[s] == "Y") {
      t[0] = "<span class='L0x' id ='L"+s+"'>"+s+"</span>";
      result[i] = t.join(" ");
    }
    console.log(">"+result[i].replace(/&nbsp;/g," ")+"<");
  }
  return result.join("<br />\n");
}
