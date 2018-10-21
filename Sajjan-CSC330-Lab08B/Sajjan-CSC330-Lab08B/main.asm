; CSC-330 Lab - Assembly - Playing with numbers skeleton.asm
; Date: 10/19/2018
; Author: Ravi Sajjan
; Description:

;---------------------Pre-setup section----------------------
.cseg	
.def				io_setup	= r16
.def				leds_d		= r17
.def				leds_b		= r18
.org				0x0000
rjmp				setup
.org				0x0100

;-----------------------Setup section------------------------
setup:
	ldi io_setup, 0b11111111 ; Set all PORTs to output

	out DDRB, io_setup ; Set all PORTBs to output
	out DDRD, io_setup ; Set all PORTDs to output(Technically only need first 2, but this is easier)
	
	ldi io_setup, 0b00000000

	out PORTB, io_setup ;Set PORTB to off
	out PORTD, io_setup ;Set PORTD to off

	ldi leds_d, 0b00000000 ;Set the registers to 0 before incrementing, Set to 1 for knight_rider
	ldi leds_b, 0b00000000 ; Set to 1 for I0_bit_knight_rider

	cpi leds_d, 0b00000000
	breq loop

	cpi leds_d, 0b00000001
	breq knight_rider_left

;------------------------Loop section------------------------
	
loop:
	inc leds_d ;Add by 1

	tst	leds_d ;Check if 0
	breq carry ;Branch if leds_d is 0

	out PORTD, leds_d
	
	rcall delay_10ms
	rjmp  loop

carry:
	inc leds_b

	cpi leds_b, 0b00000100 ;Check if 4
	breq reset_b ;Branch if 4

	out PORTB, leds_b
	rjmp loop ;return didn't work, so doing rjmp back to main loop

reset_b:
	ldi leds_b, 0b00000000
	out PORTB, leds_b
	rjmp loop ;return didn't work, so doing rjmp back to main loop

;------------------------Bonus section------------------------
knight_rider_left:
	out PORTD, leds_d

	cpi leds_d, 0b00000000
	breq I0_bit_knight_rider_left

	lsl leds_d

	rcall delay_100ms
	rjmp knight_rider_left

knight_rider_right:
	cpi leds_d, 0b00000000
	breq reset_to_1_left

	out PORTD, leds_d
	lsr leds_d

	rcall delay_100ms
	rjmp knight_rider_right

I0_bit_knight_rider_left:
	cpi leds_b, 0b00000100
	breq I0_bit_knight_rider_right

	out PORTB, leds_b
	lsl leds_b

	rcall delay_100ms
	rjmp I0_bit_knight_rider_left

I0_bit_knight_rider_right:
	cpi leds_b, 0b00000000
	breq I0_bit_knight_rider_reset_right

	out PORTB, leds_b
`	lsr leds_b

	rcall delay_100ms
	rjmp I0_bit_knight_rider_right

reset_to_1_left:
	ldi leds_d, 0b00000001
	rjmp knight_rider_left

reset_to_128_right:
	ldi leds_d, 0b10000000
	rjmp knight_rider_right

I0_bit_knight_rider_reset_right:
	out PORTB, leds_b
	ldi leds_b, 0b00000001

	rjmp reset_to_128_right

;--------------------------1s delay--------------------------
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

;------------------------100ms delay-------------------------
delay_100ms:		ldi		r20, 9
					ldi		r21, 30
					ldi		r22, 229
delay_100ms_1:		dec		r22
					brne	delay_100ms_1
					dec		r21
					brne	delay_100ms_1
					dec		r20
					brne	delay_100ms_1
					ret
;------------------------10ms delay--------------------------
delay_10ms:			ldi		r20, 208
					ldi		r21, 202
delay_10ms_1:		dec		r21
					brne	delay_10ms_1
					dec		r20
					brne	delay_10ms_1
					ret