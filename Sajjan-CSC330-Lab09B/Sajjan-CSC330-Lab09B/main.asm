;
; Sajjan-CSC330-Lab09B.asm
;
; Created: 10/26/2018 8:26:55 AM
; Author : Ravi Sajjan
;


;---------------------Pre-setup section----------------------
.cseg	
.def				io_setup	= r16
.def				counter		= r17
.def				num_a		= r18
.def				num_b		= r19
.def				result		= r20
.def				temp_a		= r24
.org				0x0000
rjmp				setup
.org				0x0100
;-----------------------Setup section------------------------
setup:
	ldi io_setup, 0b00000000 ; Set all PORTs to input
	out DDRD, io_setup ; Set all PORTD to input

	ldi io_setup, 0b11111111 ;Set to high to enable pull-up resistors
	out PORTD, io_setup ;Enable pull-up resistors on PIND

	out DDRB, io_setup ; Set all PORTB to output

	ldi counter, 1

	rjmp main

main:
	rcall sub_swap

	rcall subrout_multi2 ;Call whatever function

	out PORTB, result ;Output the results of the operation
	
	rjmp main ;Loop

sub_swap:
	in r21, PIND ;Load PORTD into r21
	mov r22, r21 ;Copy r21 into r22

	andi r21, 0b11110000 ;High nibble
	andi r22, 0b00001111 ;Low nibble

	swap r21 ;Swap the high nibble into the low nibble so we can perform math

	mov num_a, r21 ;Load 'high nibble' into num_a
	mov num_b, r22 ;Load low nibble into num_b
	ret

subrout_add:
	add num_a, num_b
	mov result, num_a
	ret

subrout_subtract:
	sub num_a, num_b
	mov result, num_a
	ret

subrout_sub2:
	ldi r23, 0b11111111 ;Setup XOR
	eor num_b, r23 ;XOR to flip all the bits
	inc num_b ;Add one to make it negative
	add num_a, num_b ;Add them to subtract them
	mov result, num_a
	ret

subrout_multi:
	mul num_a, num_b
	mov result, num_a
	ret

subrout_multi2:
	mov temp_a, num_a ; temp_a = num_a
	rjmp multi_helper ; multi_helper()

multi_helper:
	cp counter, num_b	; if(counter == num_b)
	breq done				;done()
						; else
	add num_a, temp_a	; num_a = num_a + temp_a
	inc counter			; counter++
	rjmp multi_helper	; multi_helper()

done:
	mov result, num_a
	ret ;return to main