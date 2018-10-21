;
; Sajjan-CSC330-Lab08.asm
;
; Created: 10/16/2018 8:35:07 AM
; Author : Ravi Sajjan
;


; Replace with your application code
setup:
	ldi r16, 0b00000100 ; Set bit 2, clear the rest
	out DDRB, r16 ; store r16 into port B's DDR
	ldi r16, 0b00000000
	out PORTB, r16 ;Set PORTB to off

	ldi r16, 0b00100000 ; Set bit 5, clear the rest
	out DDRD, r16 ; store r16 into port D's DDR
	ldi r16, 0b00000000
	out PORTD, r16 ;Set PORTD to off

loop:
	ldi r16, 0b00000100
	out PORTB, r16
	 
	ldi r16,0b00000000
	out PORTD, r16

	rcall delay_500ms

	ldi r16, 0b00000000
	out PORTB, r16

	ldi r16, 0b00100000
	out PORTD, r16

	rcall delay_500ms

	rjmp loop
delay_500ms:
    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ret