// z80 disassembler for PC-G850 binaries
// Decoding follows http://z80.info/decoding.htm

// ROM entry points: names match the EQUs used in the G850 asm sources
var EQUs = {
  0xBE62: "PUTCHR",
  0x8440: "PUTCH2",
  0xBFF1: "PUTSTR",
  0xBFF4: "RUN",
  0xBFEE: "RPTCHR",
  0xBCFD: "GETCHR",
  0x88C1: "GETCH2",
  0xBFCD: "WAITK",
  0x89BE: "INKEY",
  0xBE53: "INKEY2",
  0xBCEE: "ADCRLF",
  0xBE65: "INSLN",
  0xBD09: "AOUT",
  0xF9BD: "A2HEX",
  0xBD0F: "HLOUT",
  0xBD03: "REGOUT",
  0x84F7: "ROLLUP",
  0x871A: "INITSR",
  0xBFAF: "WRASR",
  0xBCE8: "OPENSR",
  0xBCEB: "CLOSSR",
  0xBD15: "LRDSR",
  0xBFB2: "WSTSR",
  0xBCDF: "RDBSR0",
  0xBCE2: "RDBSR1",
  0xBCE5: "RDBSR2",
  0xBD00: "LDPSTR",
  0xBFD0: "GPF",
  0xC110: "PWROFF",
  0xBD2D: "PWROF2",
  0xBCF1: "CLRBAS",
  0xBCF7: "CLRTXT"
};

var tableR = ["B", "C", "D", "E", "H", "L", "(HL)", "A"];
var tableRP = ["BC", "DE", "HL", "SP"];
var tableRP2 = ["BC", "DE", "HL", "AF"];
var tableCC = ["NZ", "Z", "NC", "C", "PO", "PE", "P", "M"];
var tableALU = ["ADD A,", "ADC A,", "SUB ", "SBC A,", "AND ", "XOR ", "OR ", "CP "];
var tableROT = ["RLC", "RRC", "RL", "RR", "SLA", "SRA", "SLL", "SRL"];
var tableX0Z7 = ["RLCA", "RRCA", "RLA", "RRA", "DAA", "CPL", "SCF", "CCF"];
var tableBLI = [
  ["LDI", "CPI", "INI", "OUTI"],
  ["LDD", "CPD", "IND", "OUTD"],
  ["LDIR", "CPIR", "INIR", "OTIR"],
  ["LDDR", "CPDR", "INDR", "OTDR"]
];

// Numbers in G850 assembler syntax: 3CH, 0FFH, 0BFF1H
function hexG(n, digits) {
  var s = n.toString(16).toUpperCase();
  while (s.length < digits) s = "0" + s;
  if (/^[A-F]/.test(s)) s = "0" + s;
  return s + "H";
}

function format16(nn) {
  return ("000" + nn.toString(16)).substr(-4).toUpperCase();
}

function format8(n) {
  return ("0" + n.toString(16)).substr(-2).toUpperCase();
}

// Decode one instruction at pc. rd(addr) returns the byte there, or -1 when
// it is outside the file or inside a data area.
// Returns null when the instruction runs into such a byte, otherwise
// { len, text, ref, undoc, invalid, stop }:
// - text uses "@" where the 16-bit address operand goes, so it can be
//   replaced by a label or an EQU name later
// - ref = { addr, kind } with kind "jump", "call", "mem" or "imm"
// - undoc: undocumented instruction or alternate encoding; it would not
//   reassemble to the same bytes, so the .asm export writes it as DB
// - stop: unconditional jump or return; nothing falls through
function decode(rd, pc) {
  var len = 0;
  var short = false;
  var undoc = false, invalid = false, stop = false;
  var ref = null;
  var idx = null; // "IX" or "IY" after a DD/FD prefix
  var usedIdx = false;
  var disp = null;

  function next() {
    var b = rd((pc + len) & 0xFFFF);
    len++;
    if (b < 0) {
      short = true;
      return 0;
    }
    return b;
  }

  function imm8() {
    return hexG(next(), 2);
  }

  function imm16(kind) {
    var lo = next();
    var hi = next();
    ref = { addr: hi * 256 + lo, kind: kind };
    return "@";
  }

  function rel() {
    var d = next();
    if (d > 127) d -= 256;
    ref = { addr: (pc + len + d) & 0xFFFF, kind: "jump", rel: true };
    return "@";
  }

  function idxDisp() {
    if (disp === null) {
      disp = next();
      if (disp > 127) disp -= 256;
    }
    return "(" + idx + (disp < 0 ? "-" : "+") + Math.abs(disp) + ")";
  }

  // 8-bit register k; with a prefix, (HL) becomes (IX+d) and H/L become
  // the undocumented IXH/IXL unless the same instruction uses (IX+d)
  function r(k, hlOK) {
    if (idx) {
      if (k == 6) {
        usedIdx = true;
        return idxDisp();
      }
      if ((k == 4 || k == 5) && hlOK !== false) {
        usedIdx = true;
        undoc = true;
        return idx + (k == 4 ? "H" : "L");
      }
    }
    return tableR[k];
  }

  function hl() {
    if (idx) {
      usedIdx = true;
      return idx;
    }
    return "HL";
  }

  function rp(p) {
    return p == 2 ? hl() : tableRP[p];
  }

  function rp2(p) {
    return p == 2 ? hl() : tableRP2[p];
  }

  var prefix = next();
  var op = prefix;
  if (op == 0xDD || op == 0xFD) {
    idx = op == 0xDD ? "IX" : "IY";
    op = next();
    if (op == 0xDD || op == 0xFD || op == 0xED) {
      // a prefix followed by another prefix does nothing
      return { len: 1, text: "DB " + hexG(prefix, 2), ref: null, undoc: true, invalid: true, stop: false };
    }
  }

  var x = op >> 6, y = (op >> 3) & 7, z = op & 7, p = y >> 1, q = y & 1;
  var text = null;

  if (op == 0xCB) {
    var cb;
    if (idx) {
      // DD CB d op: the displacement comes before the opcode
      var opnd = idxDisp();
      usedIdx = true;
      cb = next();
      var cx = cb >> 6, cy = (cb >> 3) & 7, cz = cb & 7;
      if (cx == 0) text = tableROT[cy] + " " + opnd;
      else if (cx == 1) text = "BIT " + cy + "," + opnd;
      else if (cx == 2) text = "RES " + cy + "," + opnd;
      else text = "SET " + cy + "," + opnd;
      if (cz != 6) {
        // undocumented: the result is also copied into a register
        undoc = true;
        if (cx != 1) text += "," + tableR[cz];
      }
      if (cx == 0 && cy == 6) undoc = true;
    } else {
      cb = next();
      var bx = cb >> 6, by = (cb >> 3) & 7, bz = cb & 7;
      if (bx == 0) {
        text = tableROT[by] + " " + tableR[bz];
        if (by == 6) undoc = true;
      } else if (bx == 1) text = "BIT " + by + "," + tableR[bz];
      else if (bx == 2) text = "RES " + by + "," + tableR[bz];
      else text = "SET " + by + "," + tableR[bz];
    }
  } else if (op == 0xED) {
    var ed = next();
    var ex = ed >> 6, ey = (ed >> 3) & 7, ez = ed & 7, ep = ey >> 1, eq = ey & 1;
    if (ex == 1) {
      if (ez == 0) {
        if (ey == 6) {
          text = "IN F,(C)";
          undoc = true;
        } else text = "IN " + tableR[ey] + ",(C)";
      } else if (ez == 1) {
        if (ey == 6) {
          text = "OUT (C),0";
          undoc = true;
        } else text = "OUT (C)," + tableR[ey];
      } else if (ez == 2) {
        text = (eq == 0 ? "SBC HL," : "ADC HL,") + tableRP[ep];
      } else if (ez == 3) {
        if (eq == 0) text = "LD (" + imm16("mem") + ")," + tableRP[ep];
        else text = "LD " + tableRP[ep] + ",(" + imm16("mem") + ")";
        // ED 63 / ED 6B duplicate the shorter 22 / 2A encodings
        if (ep == 2) undoc = true;
      } else if (ez == 4) {
        text = "NEG";
        if (ey != 0) undoc = true;
      } else if (ez == 5) {
        text = ey == 1 ? "RETI" : "RETN";
        if (ey > 1) undoc = true;
        stop = true;
      } else if (ez == 6) {
        text = "IM " + ["0", "0", "1", "2", "0", "0", "1", "2"][ey];
        if (ey != 0 && ey != 2 && ey != 3) undoc = true;
      } else {
        if (ey < 6) text = ["LD I,A", "LD R,A", "LD A,I", "LD A,R", "RRD", "RLD"][ey];
      }
    } else if (ex == 2 && ez <= 3 && ey >= 4) {
      text = tableBLI[ey - 4][ez];
    }
    if (text === null) {
      // undefined ED opcodes behave as a 2-byte NOP
      text = "DB 0EDH," + hexG(ed, 2);
      undoc = true;
      invalid = true;
    }
  } else if (x == 0) {
    if (z == 0) {
      if (y == 0) text = "NOP";
      else if (y == 1) text = "EX AF,AF'";
      else if (y == 2) text = "DJNZ " + rel();
      else if (y == 3) {
        text = "JR " + rel();
        stop = true;
      } else text = "JR " + tableCC[y - 4] + "," + rel();
    } else if (z == 1) {
      if (q == 0) {
        var dst = rp(p);
        text = "LD " + dst + "," + imm16("imm");
        ref.reg = dst;
      } else {
        var dst2 = hl();
        text = "ADD " + dst2 + "," + rp(p);
      }
    } else if (z == 2) {
      if (q == 0) {
        if (p == 0) text = "LD (BC),A";
        else if (p == 1) text = "LD (DE),A";
        else if (p == 2) {
          var src = hl();
          text = "LD (" + imm16("mem") + ")," + src;
        } else text = "LD (" + imm16("mem") + "),A";
      } else {
        if (p == 0) text = "LD A,(BC)";
        else if (p == 1) text = "LD A,(DE)";
        else if (p == 2) {
          var dst3 = hl();
          text = "LD " + dst3 + ",(" + imm16("mem") + ")";
        } else text = "LD A,(" + imm16("mem") + ")";
      }
    } else if (z == 3) {
      text = (q == 0 ? "INC " : "DEC ") + rp(p);
    } else if (z == 4) {
      text = "INC " + r(y);
    } else if (z == 5) {
      text = "DEC " + r(y);
    } else if (z == 6) {
      var reg = r(y);
      text = "LD " + reg + "," + imm8();
    } else {
      text = tableX0Z7[y];
    }
  } else if (x == 1) {
    if (y == 6 && z == 6) text = "HALT";
    else {
      var hlOK = !(y == 6 || z == 6);
      var dst4 = r(y, hlOK);
      text = "LD " + dst4 + "," + r(z, hlOK);
    }
  } else if (x == 2) {
    text = tableALU[y] + r(z);
  } else {
    if (z == 0) text = "RET " + tableCC[y];
    else if (z == 1) {
      if (q == 0) text = "POP " + rp2(p);
      else if (p == 0) {
        text = "RET";
        stop = true;
      } else if (p == 1) text = "EXX";
      else if (p == 2) {
        text = "JP (" + hl() + ")";
        stop = true;
      } else text = "LD SP," + hl();
    } else if (z == 2) {
      text = "JP " + tableCC[y] + "," + imm16("jump");
    } else if (z == 3) {
      if (y == 0) {
        text = "JP " + imm16("jump");
        stop = true;
      } else if (y == 2) text = "OUT (" + imm8() + "),A";
      else if (y == 3) text = "IN A,(" + imm8() + ")";
      else if (y == 4) text = "EX (SP)," + hl();
      else if (y == 5) text = "EX DE,HL";
      else if (y == 6) text = "DI";
      else text = "EI";
    } else if (z == 4) {
      text = "CALL " + tableCC[y] + "," + imm16("call");
    } else if (z == 5) {
      if (q == 0) text = "PUSH " + rp2(p);
      else text = "CALL " + imm16("call");
    } else if (z == 6) {
      text = tableALU[y] + imm8();
    } else {
      text = "RST " + hexG(y * 8, 2);
    }
  }

  if (short) return null;
  if (idx && !usedIdx) {
    // the prefix has no effect on this opcode: emit it on its own
    return { len: 1, text: "DB " + hexG(prefix, 2), ref: null, undoc: true, invalid: true, stop: false };
  }
  return { len: len, text: text, ref: ref, undoc: undoc, invalid: invalid, stop: stop };
}

// Disassemble a whole buffer. opts:
// - dataAreas: [{start, end}] absolute addresses always shown as DB
// - flow: true to follow jumps and calls from the entry points and show
//   everything never reached as DB; false to decode straight through
// - entries: extra entry points (the base address is always one)
// Returns { base, size, lines, labels } where each line is
// { addr, len, ins } (code) or { addr, len, data: true } (DB bytes)
function analyse(bytes, base, opts) {
  var size = bytes.length;
  var dataAreas = opts.dataAreas || [];

  function inData(a) {
    for (var k = 0; k < dataAreas.length; k++) {
      if (a >= dataAreas[k].start && a <= dataAreas[k].end) return true;
    }
    return false;
  }

  function inFile(a) {
    return a >= base && a < base + size;
  }

  function rd(a) {
    if (!inFile(a) || inData(a)) return -1;
    return bytes[a - base];
  }

  // Code flow: mark instruction starts reachable from the entry points
  var codeAt = null;
  if (opts.flow) {
    codeAt = {};
    var covered = {};
    var queue = [base].concat(opts.entries || []);
    while (queue.length) {
      var a = queue.pop();
      while (inFile(a) && !inData(a) && !covered[a]) {
        var ins = decode(rd, a);
        if (!ins || ins.invalid) break;
        var clash = false;
        for (var k = 0; k < ins.len; k++) if (covered[a + k]) clash = true;
        if (clash) break;
        codeAt[a] = true;
        for (k = 0; k < ins.len; k++) covered[a + k] = true;
        if (ins.ref && (ins.ref.kind == "jump" || ins.ref.kind == "call")) queue.push(ins.ref.addr);
        if (ins.stop) break;
        a += ins.len;
      }
    }
  }

  var raw = [];
  var o = 0;
  while (o < size) {
    var addr = base + o;
    var ins2 = null;
    if (!inData(addr) && (!codeAt || codeAt[addr])) ins2 = decode(rd, addr);
    if (ins2 === null) {
      raw.push({ addr: addr, len: 1, data: true });
      o++;
    } else {
      raw.push({ addr: addr, len: ins2.len, ins: ins2 });
      o += ins2.len;
    }
  }

  // Jump, call and memory targets inside the file get a label. 16-bit
  // immediates (LD rr,nn) only when they point at data or at a jump/call
  // target, and never for DE, which mostly holds screen positions on the G850.
  var labels = {};
  var targets = {};
  raw.forEach(function(l) {
    if (l.ins && l.ins.ref && l.ins.ref.kind != "imm") targets[l.ins.ref.addr] = true;
  });
  var isCode = {};
  raw.forEach(function(l) {
    if (l.ins) isCode[l.addr] = true;
  });
  raw.forEach(function(l) {
    if (!(l.ins && l.ins.ref)) return;
    var t = l.ins.ref.addr;
    if (!inFile(t) || EQUs[t] !== undefined) return;
    if (l.ins.ref.kind == "imm" && (l.ins.ref.reg == "DE" || (isCode[t] && !targets[t]))) return;
    labels[t] = "L" + format16(t);
  });

  // Merge single data bytes into DB lines, split at labels: up to 8 bytes,
  // or up to 40 while inside text (plus its 0 terminator)
  var lines = [];
  raw.forEach(function(l) {
    var last = lines[lines.length - 1];
    var b = bytes[l.addr - base];
    var prev = bytes[l.addr - base - 1];
    var max = isText(prev) && (isText(b) || b == 0) ? 40 : 8;
    if (l.data && last && last.data && last.len < max && labels[l.addr] === undefined) last.len++;
    else lines.push(l);
  });
  return { base: base, size: size, lines: lines, labels: labels, bytes: bytes };
}

// Label or EQU name for an address, or the plain hex number
function addrName(res, a) {
  if (res.labels[a] !== undefined) return res.labels[a];
  if (EQUs[a] !== undefined) return EQUs[a];
  return hexG(a, 4);
}

function escapeHTML(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function pad(s, n) {
  while (s.length < n) s += " ";
  return s;
}

function lineBytes(res, l) {
  var b = [];
  for (var k = 0; k < l.len; k++) b.push(res.bytes[l.addr - res.base + k]);
  return b;
}

// Printable characters that can go inside a '...' string
function isText(b) {
  return b >= 0x20 && b < 0x7F && b != 0x27;
}

// DB operands: runs of 3 or more printable characters as 'text', the rest in hex
function dbOperands(bytes) {
  var parts = [];
  var k = 0;
  while (k < bytes.length) {
    var j = k;
    while (j < bytes.length && isText(bytes[j])) j++;
    if (j - k >= 3) {
      parts.push("'" + String.fromCharCode.apply(null, bytes.slice(k, j)) + "'");
      k = j;
    } else {
      parts.push(hexG(bytes[k], 2));
      k++;
    }
  }
  return parts.join(",");
}

function lineText(res, l) {
  if (l.data) return "DB " + dbOperands(lineBytes(res, l));
  if (!l.ins.ref) return l.ins.text;
  return l.ins.text.replace("@", addrName(res, l.ins.ref.addr));
}

// HTML listing: label, address, bytes, instruction, ASCII
function renderHTML(res) {
  var boundaries = {};
  res.lines.forEach(function(l) { boundaries[l.addr] = true; });
  var out = [];
  res.lines.forEach(function(l) {
    var label = res.labels[l.addr] !== undefined ? res.labels[l.addr] + ":" : "";
    var bytes = lineBytes(res, l);
    var hex = bytes.slice(0, 4).map(format8).join(" ") + (bytes.length > 4 ? "+" : "");
    var ascii = bytes.map(function(v) { return v > 31 && v < 127 ? String.fromCharCode(v) : "."; }).join("");
    var text = lineText(res, l);
    var html = escapeHTML(text);
    if (l.ins && l.ins.ref) {
      var a = l.ins.ref.addr;
      var name = addrName(res, a);
      if (res.labels[a] !== undefined) {
        // link to the line holding the target, even when it is mid-instruction
        var t = a;
        while (!boundaries[t] && t > res.base) t--;
        html = escapeHTML(text.replace(name, "\u0001")).replace("\u0001",
          "<a href='#a" + format16(t) + "'>" + name + "</a>");
      } else if (EQUs[a] !== undefined) {
        html = escapeHTML(text.replace(name, "\u0001")).replace("\u0001",
          "<span class='equ' title='" + hexG(a, 4) + "'>" + name + "</span>");
      }
    }
    var cls = l.data ? "data" : (l.ins.undoc ? "undoc" : "");
    var row = "<span id='a" + format16(l.addr) + "'" + (cls ? " class='" + cls + "'" : "") + ">" +
      "<span class='lbl'>" + pad(label, 7) + "</span>" +
      format16(l.addr) + "  " + pad(hex, 12) + "  " +
      html + pad("", 22 - text.length) + " ; " + escapeHTML(ascii) + "</span>";
    out.push(row);
    if (l.ins && l.ins.stop) out.push("");
  });
  return out.join("\n");
}

// Source for the G850 assembler: numbered lines, ORG, EQUs, labels, ending
// with Ctrl-Z. Undocumented instructions become DB so the bytes stay identical.
function renderASM(res) {
  var boundaries = {};
  res.lines.forEach(function(l) { boundaries[l.addr] = true; });
  var src = [];
  src.push(" ORG " + hexG(res.base, 4));
  var used = {};
  res.lines.forEach(function(l) {
    if (l.ins && l.ins.ref && res.labels[l.ins.ref.addr] === undefined && EQUs[l.ins.ref.addr] !== undefined) {
      used[l.ins.ref.addr] = true;
    }
  });
  Object.keys(used).map(Number).sort(function(a, b) { return a - b; }).forEach(function(a) {
    src.push(EQUs[a] + " EQU " + hexG(a, 4));
  });
  Object.keys(res.labels).map(Number).sort(function(a, b) { return a - b; }).forEach(function(a) {
    if (!boundaries[a]) src.push(res.labels[a] + " EQU " + hexG(a, 4));
  });
  res.lines.forEach(function(l) {
    var label = res.labels[l.addr] !== undefined ? res.labels[l.addr] + ":" : "";
    var text;
    // a relative jump whose target is not a label on a line of its own (an
    // EQU or a plain number) may not assemble as a jump to that address,
    // so keep its bytes
    var relToEQU = l.ins && l.ins.ref && l.ins.ref.rel &&
      !(boundaries[l.ins.ref.addr] && res.labels[l.ins.ref.addr] !== undefined);
    if (l.ins && ((l.ins.undoc && !l.ins.invalid) || relToEQU)) {
      text = "DB " + lineBytes(res, l).map(function(v) { return hexG(v, 2); }).join(",") + " ; " + lineText(res, l);
    } else text = lineText(res, l);
    src.push(label + " " + text);
  });
  var step = src.length * 10 <= 65279 ? 10 : 1;
  return src.map(function(s, k) { return ((k + 1) * step) + s; }).join("\n") + "\n\n\x1A";
}

// Intel HEX: returns { base, bytes } or null if the text is not Intel HEX
function parseIntelHex(text) {
  // G850 transfer files end with Ctrl-Z
  var lines = text.replace(/\x1A/g, "").split(/\r?\n/).filter(function(s) { return s.trim() !== ""; });
  if (lines.length == 0 || !lines.every(function(s) { return s.trim()[0] == ":"; })) return null;
  var mem = {};
  var lo = 0x10000, hi = -1;
  for (var k = 0; k < lines.length; k++) {
    var s = lines[k].trim();
    var n = parseInt(s.substr(1, 2), 16);
    var a = parseInt(s.substr(3, 4), 16);
    var type = parseInt(s.substr(7, 2), 16);
    if (type == 1) break;
    if (type != 0) continue;
    for (var j = 0; j < n; j++) {
      mem[a + j] = parseInt(s.substr(9 + j * 2, 2), 16);
      lo = Math.min(lo, a + j);
      hi = Math.max(hi, a + j);
    }
  }
  if (hi < 0) return null;
  var bytes = new Uint8Array(hi - lo + 1);
  for (var a2 = lo; a2 <= hi; a2++) bytes[a2 - lo] = mem[a2] || 0;
  return { base: lo, bytes: bytes };
}

function hexDump(bytes, base) {
  var result = [];
  result.push("       .0 .1 .2 .3 .4 .5 .6 .7 .8 .9 .A .B .C .D .E .F");
  for (var i = 0; i < bytes.length; i += 16) {
    var hex = [], ascii = [];
    for (var j = 0; j < 16; j++) {
      if (i + j < bytes.length) {
        var c = bytes[i + j];
        hex.push(format8(c));
        ascii.push(c > 31 && c < 127 ? String.fromCharCode(c) : ".");
      } else {
        hex.push("  ");
        ascii.push(" ");
      }
    }
    result.push(format16((base + i) & 0xFFF0) + "   " + hex.join(" ") + "  |" + ascii.join("") + "|");
  }
  return escapeHTML(result.join("\n"));
}

// ---- browser UI ----

var lastBytes = null;
var lastName = "disasm";
var lastResult = null;
var dataAreasRecord = [];

function openFile() {
  document.getElementById("inp").click();
}

function readFile(e) {
  var file = e.target.files[0];
  if (!file) return;
  lastName = file.name.replace(/\.[^.]*$/, "");
  var reader = new FileReader();
  reader.onload = function(ev) {
    var bytes = new Uint8Array(ev.target.result);
    var text = new TextDecoder("latin1").decode(bytes);
    var hex = parseIntelHex(text);
    if (hex) {
      bytes = hex.bytes;
      document.getElementById("BaseAddr").value = format16(hex.base);
    }
    lastBytes = bytes;
    dataAreasRecord = [];
    document.getElementById("Data_Areas").innerHTML = "";
    refresh();
  };
  reader.readAsArrayBuffer(file);
}

function refresh() {
  if (!lastBytes) return;
  var base = parseInt(document.getElementById("BaseAddr").value, 16);
  if (isNaN(base)) base = 0x100;
  document.getElementById("controls").style.display = "block";
  document.getElementById("contents").innerHTML = hexDump(lastBytes, base);
  var entries = document.getElementById("Entries").value.split(/[\s,]+/)
    .filter(function(s) { return s !== ""; })
    .map(function(s) { return parseInt(s, 16); })
    .filter(function(n) { return !isNaN(n); });
  lastResult = analyse(lastBytes, base, {
    dataAreas: dataAreasRecord,
    flow: document.getElementById("Flow").checked,
    entries: entries
  });
  document.getElementById("decoded").innerHTML = renderHTML(lastResult);
}

function addDataArea() {
  var st = parseInt(document.getElementById("StartAddr").value, 16);
  var en = parseInt(document.getElementById("EndAddr").value, 16);
  if (isNaN(st)) return;
  if (isNaN(en)) en = st;
  if (st > en) {
    var t = st;
    st = en;
    en = t;
  }
  dataAreasRecord.push({ start: st, end: en });
  var opt = document.createElement("option");
  opt.textContent = "From " + format16(st) + " to " + format16(en);
  document.getElementById("Data_Areas").appendChild(opt);
  refresh();
}

function removeDataArea() {
  var sel = document.getElementById("Data_Areas");
  if (sel.selectedIndex < 0) return;
  dataAreasRecord.splice(sel.selectedIndex, 1);
  sel.remove(sel.selectedIndex);
  refresh();
}

function downloadASM() {
  if (!lastResult) return;
  var src = renderASM(lastResult);
  var bytes = new Uint8Array(src.length);
  for (var k = 0; k < src.length; k++) bytes[k] = src.charCodeAt(k);
  var a = document.createElement("a");
  a.href = URL.createObjectURL(new Blob([bytes], { type: "application/octet-stream" }));
  a.download = lastName + ".dis.asm";
  a.click();
}

if (typeof module !== "undefined") {
  module.exports = { decode: decode, analyse: analyse, renderASM: renderASM, renderHTML: renderHTML, parseIntelHex: parseIntelHex, hexG: hexG };
}
