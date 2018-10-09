;
; Sajjan_Yu_Blinker.asm
;
; Created: 10/5/2018 8:19:24 AM
; Author : Ravi Sajjan
;


; Replace with your application code
.cseg
.def	indicate = R16
.org	0x0000
		rjmp setup
.org	0x0100

setup:
	ldi indicate, 0xFF
	out DDRD, indicate

loop: ldi indicate, 0xFF
	out PORTD, indicate
	rcall delay_1s_0
	ldi indicate, 0x00
	out PORTD, indicate
	rcall delay_1s_0
	rjmp loop

delay_1s_0: ldi R20, 0x55
delay_1s_1: ldi R21, 0xFB
delay_1s_2: ldi R22, 0xFF
delay_1s_3: dec R22
			brne delay_1s_3
			dec R21
			brne delay_1s_2
			dec R20
			brne delay_1s_1
			ldi R20, 0x02
delay_1s_4: dec R20
			brne delay_1s_4
			nop
			ret