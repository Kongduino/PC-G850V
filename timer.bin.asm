; z80dasm 1.1.6
; command line: z80dasm -b timer.bin.def -t -l -g 0x100 /Users/dda/Kongduino/G850/code/timer.bin
; timer.bin.def: data: start 0x203 end 0x2fa type bytedata

	org	00100h

l0100h:
	call sub_01a2h		;0100	cd a2 01 	. . . 
	ld hl,l0243h		;0103	21 43 02 	! C . 
	call l01c5h+1		;0106	cd c6 01 	. . . 
	ld de,00000h		;0109	11 00 00 	. . . 
	call 0bff1h			;010c	cd f1 bf 	. . . 
	ld a,001h			;010f	3e 01 	> . 
	out (060h),a		;0111	d3 60 	. ` 
	ld a,000h			;0113	3e 00 	> . 
	out (061h),a		;0115	d3 61 	. a 
	call sub_0188h		;0117	cd 88 01 	. . . 
l011ah:
	ld hl,l0254h		;011a	21 54 02 	! T . 
	call l01c5h+1		;011d	cd c6 01 	. . . 
	ld de,l0100h		;0120	11 00 01 	. . . 
	call 0bff1h			;0123	cd f1 bf 	. . . 
	call sub_01dfh		;0126	cd df 01 	. . . 
	ld hl,l025dh		;0129	21 5d 02 	! ] . 
	call l01c5h+1		;012c	cd c6 01 	. . . 
	ld de,l0200h		;012f	11 00 02 	. . . 
	call 0bff1h			;0132	cd f1 bf 	. . . 
	ld hl,l0271h		;0135	21 71 02 	! q . 
	call l01c5h+1		;0138	cd c6 01 	. . . 
	ld de,00300h		;013b	11 00 03 	. . . 
	call 0bff1h			;013e	cd f1 bf 	. . . 
	call sub_0188h		;0141	cd 88 01 	. . . 
	call sub_01d6h		;0144	cd d6 01 	. . . 
	cp 051h				;0147	fe 51 	. Q 
	jp z,l0191h			;0149	ca 91 01 	. . . 
	cp 038h				;014c	fe 38 	. 8 
	jp z,l015ch			;014e	ca 5c 01 	. \ . 
	cp 034h				;0151	fe 34 	. 4 
	jp z,l0172h			;0153	ca 72 01 	. r . 
	call sub_01a2h		;0156	cd a2 01 	. . . 
	jp l011ah			;0159	c3 1a 01 	. . . 
l015ch:
	ld a,000h			;015c	3e 00 	> . 
	out (067h),a		;015e	d3 67 	. g 
	call sub_01a2h		;0160	cd a2 01 	. . . 
	ld hl,l02d4h		;0163	21 d4 02 	! . . 
	call l01c5h+1		;0166	cd c6 01 	. . . 
	ld de,00000h		;0169	11 00 00 	. . . 
	call 0bff1h			;016c	cd f1 bf 	. . . 
	jp l011ah			;016f	c3 1a 01 	. . . 
l0172h:
	ld a,001h			;0172	3e 01 	> . 
	out (067h),a		;0174	d3 67 	. g 
	call sub_01a2h		;0176	cd a2 01 	. . . 
	ld hl,l02e7h		;0179	21 e7 02 	! . . 
	call l01c5h+1		;017c	cd c6 01 	. . . 
	ld de,00000h		;017f	11 00 00 	. . . 
	call 0bff1h			;0182	cd f1 bf 	. . . 
	jp l011ah			;0185	c3 1a 01 	. . . 
sub_0188h:
	call 0bfcdh			;0188	cd cd bf 	. . . 
	cp 000h				;018b	fe 00 	. . 
	jp z,sub_0188h		;018d	ca 88 01 	. . . 
	ret					;0190	c9 	. 
l0191h:
	ld a,000h			;0191	3e 00 	> . 
	out (067h),a		;0193	d3 67 	. g 
	ld hl,l0265h		;0195	21 65 02 	! e . 
	call l01c5h+1		;0198	cd c6 01 	. . . 
	ld de,00500h		;019b	11 00 05 	. . . 
	call 0bff1h			;019e	cd f1 bf 	. . . 
	ret					;01a1	c9 	. 
sub_01a2h:
	ld a,090h			;01a2	3e 90 	> . 
	ld (l01c2h),a		;01a4	32 c2 01 	2 . . 
	ld de,00000h		;01a7	11 00 00 	. . . 
	ld (l01c4h),de		;01aa	ed 53 c4 01 	. S . . 
	ld a,020h			;01ae	3e 20 	>   
	ld (l01c5h),a		;01b0	32 c5 01 	2 . . 
	ld a,(l01c2h)		;01b3	3a c2 01 	: . . 
	ld b,a				;01b6	47 	G 
	ld a,(l01c5h)		;01b7	3a c5 01 	: . . 
	ld de,(l01c3h)		;01ba	ed 5b c3 01 	. [ . . 
	call 0bfeeh			;01be	cd ee bf 	. . . 
	ret					;01c1	c9 	. 
l01c2h:
	sub b				;01c2	90 	. 
l01c3h:
	nop					;01c3	00 	. 
l01c4h:
	nop					;01c4	00 	. 
l01c5h:
	jr nz,$+8			;01c5	20 06 	  . 
	nop					;01c7	00 	. 
	push hl				;01c8	e5 	. 
l01c9h:
	ld a,(hl)			;01c9	7e 	~ 
	cp 000h				;01ca	fe 00 	. . 
	jp z,l01d4h			;01cc	ca d4 01 	. . . 
	inc hl				;01cf	23 	# 
	inc b				;01d0	04 	. 
	jp l01c9h			;01d1	c3 c9 01 	. . . 
l01d4h:
	pop hl				;01d4	e1 	. 
	ret					;01d5	c9 	. 
sub_01d6h:
	ld b,000h			;01d6	06 00 	. . 
	ld c,a				;01d8	4f 	O 
	ld hl,l0283h		;01d9	21 83 02 	! . . 
	add hl,bc			;01dc	09 	. 
	ld a,(hl)			;01dd	7e 	~ 
	ret					;01de	c9 	. 
sub_01dfh:
	ld a,001h			;01df	3e 01 	> . 
	out (062h),a		;01e1	d3 62 	. b 
	ld a,000h			;01e3	3e 00 	> . 
l01e5h:
	push af				;01e5	f5 	. 
	ld a,000h			;01e6	3e 00 	> . 
l01e8h:
	push af				;01e8	f5 	. 
	ld hl,data_start	;01e9	21 03 02 	! . . 
	ld de,l0223h		;01ec	11 23 02 	. # . 
	ld bc,00020h		;01ef	01 20 00 	.   . 
	ldir				;01f2	ed b0 	. . 
	pop af				;01f4	f1 	. 
	dec a				;01f5	3d 	= 
	jp nz,l01e8h		;01f6	c2 e8 01 	. . . 
	pop af				;01f9	f1 	. 
	dec a				;01fa	3d 	= 
	jp nz,l01e5h		;01fb	c2 e5 01 	. . . 
	ld a,000h			;01fe	3e 00 	> . 
l0200h:
	out (062h),a		;0200	d3 62 	. b 
	ret					;0202	c9 	. 

; BLOCK 'data' (start 0x0203 end 0x02fa)
data_start:
	defb 001h		;0203	01 	. 
	defb 002h		;0204	02 	. 
	defb 003h		;0205	03 	. 
	defb 004h		;0206	04 	. 
	defb 005h		;0207	05 	. 
	defb 006h		;0208	06 	. 
	defb 007h		;0209	07 	. 
	defb 008h		;020a	08 	. 
	defb 009h		;020b	09 	. 
	defb 00ah		;020c	0a 	. 
	defb 00bh		;020d	0b 	. 
	defb 00ch		;020e	0c 	. 
	defb 00dh		;020f	0d 	. 
	defb 00eh		;0210	0e 	. 
	defb 00fh		;0211	0f 	. 
	defb 010h		;0212	10 	. 
	defb 001h		;0213	01 	. 
	defb 002h		;0214	02 	. 
	defb 003h		;0215	03 	. 
	defb 004h		;0216	04 	. 
	defb 005h		;0217	05 	. 
	defb 006h		;0218	06 	. 
	defb 007h		;0219	07 	. 
	defb 008h		;021a	08 	. 
	defb 009h		;021b	09 	. 
	defb 00ah		;021c	0a 	. 
	defb 00bh		;021d	0b 	. 
	defb 00ch		;021e	0c 	. 
	defb 00dh		;021f	0d 	. 
	defb 00eh		;0220	0e 	. 
	defb 00fh		;0221	0f 	. 
	defb 010h		;0222	10 	. 
l0223h:
	defb 000h		;0223	00 	. 
	defb 000h		;0224	00 	. 
	defb 000h		;0225	00 	. 
	defb 000h		;0226	00 	. 
	defb 000h		;0227	00 	. 
	defb 000h		;0228	00 	. 
	defb 000h		;0229	00 	. 
	defb 000h		;022a	00 	. 
	defb 000h		;022b	00 	. 
	defb 000h		;022c	00 	. 
	defb 000h		;022d	00 	. 
	defb 000h		;022e	00 	. 
	defb 000h		;022f	00 	. 
	defb 000h		;0230	00 	. 
	defb 000h		;0231	00 	. 
	defb 000h		;0232	00 	. 
	defb 000h		;0233	00 	. 
	defb 000h		;0234	00 	. 
	defb 000h		;0235	00 	. 
	defb 000h		;0236	00 	. 
	defb 000h		;0237	00 	. 
	defb 000h		;0238	00 	. 
	defb 000h		;0239	00 	. 
	defb 000h		;023a	00 	. 
	defb 000h		;023b	00 	. 
	defb 000h		;023c	00 	. 
	defb 000h		;023d	00 	. 
	defb 000h		;023e	00 	. 
	defb 000h		;023f	00 	. 
	defb 000h		;0240	00 	. 
	defb 000h		;0241	00 	. 
	defb 000h		;0242	00 	. 
l0243h:
	defb 048h		;0243	48 	H 
	defb 069h		;0244	69 	i 
	defb 074h		;0245	74 	t 
	defb 020h		;0246	20 	  
	defb 06bh		;0247	6b 	k 
	defb 065h		;0248	65 	e 
	defb 079h		;0249	79 	y 
	defb 020h		;024a	20 	  
	defb 074h		;024b	74 	t 
	defb 06fh		;024c	6f 	o 
	defb 020h		;024d	20 	  
	defb 073h		;024e	73 	s 
	defb 074h		;024f	74 	t 
	defb 061h		;0250	61 	a 
	defb 072h		;0251	72 	r 
	defb 074h		;0252	74 	t 
	defb 000h		;0253	00 	. 
l0254h:
	defb 053h		;0254	53 	S 
	defb 074h		;0255	74 	t 
	defb 061h		;0256	61 	a 
	defb 072h		;0257	72 	r 
	defb 074h		;0258	74 	t 
	defb 02eh		;0259	2e 	. 
	defb 02eh		;025a	2e 	. 
	defb 02eh		;025b	2e 	. 
	defb 000h		;025c	00 	. 
l025dh:
	defb 053h		;025d	53 	S 
	defb 074h		;025e	74 	t 
	defb 06fh		;025f	6f 	o 
	defb 070h		;0260	70 	p 
	defb 02eh		;0261	2e 	. 
	defb 02eh		;0262	2e 	. 
	defb 02eh		;0263	2e 	. 
	defb 000h		;0264	00 	. 
l0265h:
	defb 047h		;0265	47 	G 
	defb 06fh		;0266	6f 	o 
	defb 06fh		;0267	6f 	o 
	defb 064h		;0268	64 	d 
	defb 020h		;0269	20 	  
	defb 042h		;026a	42 	B 
	defb 079h		;026b	79 	y 
	defb 065h		;026c	65 	e 
	defb 02eh		;026d	2e 	. 
	defb 02eh		;026e	2e 	. 
	defb 02eh		;026f	2e 	. 
	defb 000h		;0270	00 	. 
l0271h:
	defb 051h		;0271	51 	Q 
	defb 020h		;0272	20 	  
	defb 02fh		;0273	2f 	/ 
	defb 020h		;0274	20 	  
	defb 034h		;0275	34 	4 
	defb 020h		;0276	20 	  
	defb 02fh		;0277	2f 	/ 
	defb 020h		;0278	20 	  
	defb 038h		;0279	38 	8 
	defb 020h		;027a	20 	  
	defb 02fh		;027b	2f 	/ 
	defb 020h		;027c	20 	  
	defb 06fh		;027d	6f 	o 
	defb 074h		;027e	74 	t 
	defb 068h		;027f	68 	h 
	defb 065h		;0280	65 	e 
	defb 072h		;0281	72 	r 
	defb 000h		;0282	00 	. 
l0283h:
	defb 000h		;0283	00 	. 
	defb 0ffh		;0284	ff 	. 
	defb 051h		;0285	51 	Q 
	defb 057h		;0286	57 	W 
	defb 045h		;0287	45 	E 
	defb 052h		;0288	52 	R 
	defb 054h		;0289	54 	T 
	defb 059h		;028a	59 	Y 
	defb 055h		;028b	55 	U 
	defb 041h		;028c	41 	A 
	defb 053h		;028d	53 	S 
	defb 044h		;028e	44 	D 
	defb 046h		;028f	46 	F 
	defb 047h		;0290	47 	G 
	defb 048h		;0291	48 	H 
	defb 04ah		;0292	4a 	J 
	defb 04bh		;0293	4b 	K 
	defb 05ah		;0294	5a 	Z 
	defb 058h		;0295	58 	X 
	defb 043h		;0296	43 	C 
	defb 056h		;0297	56 	V 
	defb 042h		;0298	42 	B 
	defb 04eh		;0299	4e 	N 
	defb 04dh		;029a	4d 	M 
	defb 02ch		;029b	2c 	, 
	defb 0ffh		;029c	ff 	. 
	defb 0ffh		;029d	ff 	. 
	defb 0ffh		;029e	ff 	. 
	defb 0ffh		;029f	ff 	. 
	defb 009h		;02a0	09 	. 
	defb 020h		;02a1	20 	  
	defb 00ah		;02a2	0a 	. 
	defb 00bh		;02a3	0b 	. 
	defb 00eh		;02a4	0e 	. 
	defb 00fh		;02a5	0f 	. 
	defb 0ffh		;02a6	ff 	. 
	defb 030h		;02a7	30 	0 
	defb 02eh		;02a8	2e 	. 
	defb 03dh		;02a9	3d 	= 
	defb 02bh		;02aa	2b 	+ 
	defb 00dh		;02ab	0d 	. 
	defb 04ch		;02ac	4c 	L 
	defb 03bh		;02ad	3b 	; 
	defb 0ffh		;02ae	ff 	. 
	defb 031h		;02af	31 	1 
	defb 032h		;02b0	32 	2 
	defb 033h		;02b1	33 	3 
	defb 02dh		;02b2	2d 	- 
	defb 0ffh		;02b3	ff 	. 
	defb 049h		;02b4	49 	I 
	defb 04fh		;02b5	4f 	O 
	defb 0ffh		;02b6	ff 	. 
	defb 034h		;02b7	34 	4 
	defb 035h		;02b8	35 	5 
	defb 036h		;02b9	36 	6 
	defb 02ah		;02ba	2a 	* 
	defb 0ffh		;02bb	ff 	. 
	defb 050h		;02bc	50 	P 
	defb 008h		;02bd	08 	. 
	defb 0ffh		;02be	ff 	. 
	defb 037h		;02bf	37 	7 
	defb 038h		;02c0	38 	8 
	defb 039h		;02c1	39 	9 
	defb 02fh		;02c2	2f 	/ 
	defb 029h		;02c3	29 	) 
	defb 0ffh		;02c4	ff 	. 
	defb 0ffh		;02c5	ff 	. 
	defb 0ffh		;02c6	ff 	. 
	defb 0ffh		;02c7	ff 	. 
	defb 028h		;02c8	28 	( 
	defb 0ffh		;02c9	ff 	. 
	defb 0ffh		;02ca	ff 	. 
	defb 0ffh		;02cb	ff 	. 
	defb 0ffh		;02cc	ff 	. 
	defb 0ffh		;02cd	ff 	. 
	defb 0ffh		;02ce	ff 	. 
	defb 0ffh		;02cf	ff 	. 
	defb 0ffh		;02d0	ff 	. 
	defb 000h		;02d1	00 	. 
	defb 00ch		;02d2	0c 	. 
	defb 0ffh		;02d3	ff 	. 
l02d4h:
	defb 053h		;02d4	53 	S 
	defb 077h		;02d5	77 	w 
	defb 069h		;02d6	69 	i 
	defb 074h		;02d7	74 	t 
	defb 063h		;02d8	63 	c 
	defb 068h		;02d9	68 	h 
	defb 069h		;02da	69 	i 
	defb 06eh		;02db	6e 	n 
	defb 067h		;02dc	67 	g 
	defb 020h		;02dd	20 	  
	defb 074h		;02de	74 	t 
	defb 06fh		;02df	6f 	o 
	defb 020h		;02e0	20 	  
	defb 038h		;02e1	38 	8 
	defb 020h		;02e2	20 	  
	defb 04dh		;02e3	4d 	M 
	defb 048h		;02e4	48 	H 
	defb 07ah		;02e5	7a 	z 
	defb 000h		;02e6	00 	. 
l02e7h:
	defb 053h		;02e7	53 	S 
	defb 077h		;02e8	77 	w 
	defb 069h		;02e9	69 	i 
	defb 074h		;02ea	74 	t 
	defb 063h		;02eb	63 	c 
	defb 068h		;02ec	68 	h 
	defb 069h		;02ed	69 	i 
	defb 06eh		;02ee	6e 	n 
	defb 067h		;02ef	67 	g 
	defb 020h		;02f0	20 	  
	defb 074h		;02f1	74 	t 
	defb 06fh		;02f2	6f 	o 
	defb 020h		;02f3	20 	  
	defb 034h		;02f4	34 	4 
	defb 020h		;02f5	20 	  
	defb 04dh		;02f6	4d 	M 
	defb 048h		;02f7	48 	H 
	defb 07ah		;02f8	7a 	z 
	defb 000h		;02f9	00 	. 
data_end:
	nop			;02fa	00 	. 
