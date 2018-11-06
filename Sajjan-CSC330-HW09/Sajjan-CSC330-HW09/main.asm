;
; Sajjan-CSC330-HW09.asm
;
; Created: 10/31/2018 10:49:08 AM
; Author : Ayy
;


;CSC330: HW09


;E3.1
.cseg
ASCII: .DB 97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122

;E3.2
.cseg
.org 0x1000
ASCII_NUM: .DB 48,49,50,51,52,53,54,55,56,57

;E3.3
.cseg

.macro	set_Pointer
ldi @0, low(@2)
ldi @1, high(@2)
.endmacro

set_Pointer YL, YH, 0x3000

;E3.4
.cseg

set_Pointer XL, XH, 0x210 ; num_a
set_Pointer YL, YH, 0x220 ; num_b
set_Pointer ZL, ZH, 0x230 ; result

ld r17, X+ ;210->211
ld r16, X  ;211
ld r19, Y+ ;220->221
ld r18, Y  ;221

add r16, r18 ; X (+) Y
add r17, r19 ; X+ (+) Y+

st Z+, r16 ; Z+ = X+ (+) Y+
st Z, r16 ; Z = X (+) Y

;E3.6
.cseg

set_Pointer XL, XH, 0x200 ; num_a
set_Pointer YL, YH, 0x204 ; num_b
set_Pointer ZL, ZH, 0x208 ; result

ld r17, X+ ;200->201
ld r18, X+ ;201->202
ld r19, X+ ;202->203
ld r16, X  ;203

ld r21, Y+ ;204->205
ld r22, Y+ ;205->206
ld r23, Y+ ;206->207
ld r20, Y  ;207

add r17, r21 ;0x200, 0x204
add r18, r22 ;0x201, 0x205
add r19, r23 ;0x202, 0x206
add r16, r20 ;0x203, 0x207

st Z+, r17 ;0x208
st Z+, r18 ;0x209
st Z+, r19 ;0x20A
st Z, r16  ;0x20B

;E3.7
set_Pointer XL, XH, 0x200
set_Pointer YL, YH, 0x202
set_Pointer ZL, ZH, 0x204

ld r17, X+
ld r16, X

ld r19, Y+
ld r18, Y

sub r16, r18
sub r17, r19

st Z+, r17
st Z, r16

;E3.10
.cseg

elements: .db 1,2,28,42,56,12,128,220
.equ elements_count = 8
.def bit_counter = r16
.def loop_counter = r17

main:
	ldi bit_counter, 0
	ldi loop_counter, elements_count

	ldi ZL, low(elements<<1)
	ldi ZH, high(elements<<1)

	rcall counter

counter:
	lpm r18, Z+ ;Increments the Z pointer by 1 everytime
	rcall check_bits
	
	dec loop_counter
	tst loop_counter ;Test for zero
	brne counter

	rcall done

check_bits:
	andi r18, 0b00011100
	cpi r18, 0b00011100
	breq increment
	ret

increment:
	inc bit_counter
	ret

done:
	nop

;E3.12
.cseg
elements: .db 20,21,3,22,5,6,7,8
.equ elements_count = 8
.def bigger_counter = r16
.def loop_counter = r17
rcall main

main:
	ldi ZL, low(elements<<1)
	ldi ZH, high(elements<<1)
	ldi loop_counter, 0 ; Start from 0
	rjmp loop
loop:
	cpi loop_counter, elements_count+1
	breq done

	lpm r18, Z+
	cpi r18, 20 ;Check if 20
	brge increment

	inc loop_counter
	rjmp loop

increment:
	inc bigger_counter
	inc loop_counter
	rjmp loop

done:
	nop

