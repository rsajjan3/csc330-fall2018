;
; Sajjan-CSC330-Lab10A.asm
;
; Created: 10/30/2018 8:35:21 AM
; Author : Ravi Sajjan
;


.cseg
.org 0x0200
digits: .db 0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000
.def loop_counter = r16
rjmp main

.macro set_pointer
	ldi @0, low(@2)
	ldi @1, high(@2)
.endmacro

main:
	ldi r23, 0b11111111
	out DDRD, r23
	out DDRB, r23
	out PORTB, r23

	set_pointer ZL, ZH, digits
	
	ldi loop_counter, 0
	rjmp loop

loop:
	cpi loop_counter, 10 ;10 elements
	breq main ;Reset variables and go

	lpm r18, Z+
	out	PORTD, r18
	
	inc loop_counter
	rcall	delay_1s
	rjmp	loop

delay_1s:			ldi		R20, 0x53
delay_1s_1:			ldi		R21, 0xFB
delay_1s_2:			ldi		R22, 0xFF
delay_1s_3:			dec		R22
					brne	delay_1s_3
					dec		R21
					brne	delay_1s_2
					dec		R20
					brne	delay_1s_1
					ldi		R20, 0x02
delay_1s_4:			dec		R20
					brne	delay_1s_4
					nop
					ret