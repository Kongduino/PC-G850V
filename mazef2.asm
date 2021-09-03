; Maze implementation in Z80 Assembler
; by HWR0 aka @r0_hw
; Sept '2021
; ------------------------------------

    ORG 0x100
home_screen:
    ld A, 0x40
	out (0x40), A
; clear vvram
maze_start:
    call vclear
    ld A, R
	ld H, A
	ld A, R
	ld L, A
	call randomize
; draw the box (42=0x2e, 142=0x8e)
box_draw:
    ld DE, 0x0000
	ld BC, 0x008e
    call line
    ld DE, 0x008e
	ld BC, 0x2e8e
    call line
    ld DE, 0x2e8e
	ld BC, 0x2e00
    call line
    ld DE, 0x2e00
	ld BC, 0x0000
    call line

main_loop:
    ld E, 0x8c
lp1:
    ld D, 0x2c
lp2:
    push de
    push de
    push de
    call vaddress
    or (HL)
    ld (HL), A ; pointset(x,y)
    pop de
while:
    call prng
    cp 0
    jp Z, c1
    cp 1
    jp Z, c2
    cp 2
    jp Z, c3
    cp 3
    jp Z, c1
next:
;   ld DE, 0x0000
;	ld BC, 0x2f8f
;	call vupdate
    pop de
    dec d
    dec d
    jp NZ, lp2
    
    dec e
    dec e
    jp NZ, lp1
    jp maze_update
d2:
d3:
    pop de
    jp next
c1:
    pop de
    dec e
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x,y-1)
    jp next 
c2:
    pop de
    inc e
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x,y+1)
    jp next 
c3:
    pop de
    inc d
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x+1,y)
    jp next 

;final screen update
maze_update:
    ; ld D, 0x0
    ; ld E, 0x0
    ; call vaddress
    ld DE, 0x0000
	ld BC, 0x2f8f
	call vupdate
    ; ld A, 0x40
	; out (0x40), A
getchr:   
    call INKEY
    cp 'Q' ; actually, the [ON] Key without translation matrix
    jp NZ, getchr
	ret

;
; vvram disp
;

vupdate:
	ld A, 0x40
	out (0x40), A
	; Find the start and end ROW
	srl B
	srl B
	srl B
	srl D
	srl D
	srl D
	ld A, B
	sub D
	jr NC, skip1
	ld D, B
	neg
skip1:
	add D
	ld L, A
	; Find the start x-coordinate and length.
	ld A, C
	sub E
	ld B, A
	ld A, C
	cp E
	jr NC, skip2
	ld A, E
	sub C
	ld B, A
	ld E, C
skip2:
	inc B
	ld C, L

	; Find the start virtual VRAM
	push BC
	ld B, 0
	ld C, E
	ld HL, vram
	add HL, BC
	ld C, WIDTH
	ld A, D
	or A
loop6:
	jr Z, skip3
	add HL, BC
	dec A
	jr loop6
skip3:
	pop BC

loop1:
	; Set the drawing ROW
	push BC
	ld C, 0x40
	ld A, D
	or 0xb0
loop2:
	in B, (C)
	rlc B
	jr C, loop2
	out (C), A

	; Set the drawing COL(L)
	ld A, E
	and 0x0f
loop3:
	in B, (C)
	rlc B
	jr C, loop3
	out (C), A

	; Set the drawing COL(H)
	ld A, E
	rra
	rra
	rra
	rra
	and 0x0f
	or 0x10
loop4:
	in B, (C)
	jr C, loop4
	out (C), A
	pop BC

	; Draw one line
	push BC
	push HL
loop5:
	ld A, (HL)
	inc HL
	out (0x41), A
	djnz loop5
	pop HL
	ld BC, WIDTH
	add HL, BC
	pop BC

	; Moving on to the next ROW
	inc D
	ld A, C
	sub D
	jr NC, loop1

	ret

; Erase vvram

vclear:
	ld DE, vram
	ld BC, WIDTH
	ld HL, blank
	ldir
	ld BC, WIDTH
	ld HL, vram
	ldir
	ld BC, WIDTH * 2
	ld HL, vram
	ldir
	ld BC, WIDTH * 2
	ld HL, vram
	ldir
	ret
blank:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0

; Get point(x,y) address in vvram
vaddress:
	push BC
	ld A, D
	and 0x07
	ld B, 0
	ld C, A
	ld HL, vmask_table
	add HL, BC
	ld A, (HL)
vaddress0:
	ld HL, vram
	ld BC, WIDTH
	srl D
	srl D
	srl D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	rst 0x30
vaddress_skip1:
	add HL, DE
	pop BC
	ret
vmask_table:
	db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80

; line(x,y,x,y)

line:
	; dx = abs(x2 - x1)
	ld A, C
	sub E
	jr NC, skip_dx
	ld A, E
	sub C
skip_dx:
	jr Z, vert
	ld L, A
	ld A, B
	sub D
	jr NC, skip_dy
	ld A, D
	sub B
skip_dy:
	jr Z, horiz
	ld H, A
	ld A, L
	cp H
	jr C, steep
	jr gentle
steep:
gentle:
    ret

vert:
	; if y1 > y2 then swap(y1,y2)
	ld A, B
	sub D
	jr NC, skip_swap_y1_y2
	ld D, B
	neg
skip_swap_y1_y2:
	ld B, A
	inc B
	call vaddress
loop_horiz:
	; pset(x,y)
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	; y++
	rlc A
	jr NC, sk
	ld DE, WIDTH
	add HL, DE
sk:
	djnz loop_horiz
	ret

horiz:
	ld A, C
	sub E
	jr NC, skip_swap_x1_x2
	ld E, C
	neg
skip_swap_x1_x2:
	ld B, A
	inc B
	call vaddress
loop_vert:
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	inc HL
	djnz loop_vert
	ret

; change Seed value for LCM PRNG
prng:
    push DE
    push HL
    ; ld a,(HL)
    ld DE, (rand_value16)
    ld H, E
    ld L, 1
    add HL, DE
    add HL, DE
    add HL, DE
    add HL, DE
    add HL, DE
    ld A, H
    ld (rand_value16), HL
    pop HL
    pop DE
    ld a, (rand_value8)
    ld C, 3
    and C
    ; ld (HL),a
	ret
randomize:
	ld (rand_value16), HL
	ret

rand_value16:
	db 0xf0
rand_value8:
	db 0xf1

G850    equ 1
COLS    equ 24
ROWS    equ 6
WIDTH   equ 144
HEIGHT  equ 48
HWR0    equ 1
INKEY equ 0x0BE53

; vvram
vram:
vram0:
	ds 144
vram1:
	ds 144
vram2:
	ds 144
vram3:
	ds 144
vram4:
	ds 144
vram5:
	ds 144
