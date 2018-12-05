;
; Sajjan-CSC330-Lab12B.asm
;
; Created: 11/16/2018 10:22:52 AM
; Author : Ravi Sajjan
;
.equ L = 0b0000000000111000
.equ M = 0b0000010100110110
.equ A = 0b0000000011110111
.equ O = 0b0000000000111111

.cseg
.def data_handler = r16		
.def slave_addr = r17
.org 0x0000
	rjmp setup
	.include "TWI_polling_lib.asm"
.org 0x0100

setup:
	ldi slave_addr, 0b11100000
	rcall twi_setup

enable_clock:
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr ;Uses r16
	ldi data_handler, 0b00100001 ;Enable oscillator
	rcall twi_send_byte
	rcall twi_stop

row_int:
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr
	ldi data_handler, 0b10100000
	rcall twi_send_byte
	rcall twi_stop

dimming:
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr
	ldi data_handler, 0b11101111
	rcall twi_send_byte
	rcall twi_stop

blinking:
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr
	ldi data_handler, 0b10000001
	rcall twi_send_byte
	rcall twi_stop

.macro output_stuff
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr
	ldi data_handler, @0 ;Memory location
	rcall twi_send_byte
	ldi data_handler, @1 ;Actual data
	rcall twi_send_byte
	rcall twi_stop

.endmacro

setup_output:
	output_stuff 0x00, low(L)
	output_stuff 0x01, high(L)
	output_stuff 0x02, low(M)
	output_stuff 0x03, high(M)
	output_stuff 0x04, low(A)
	output_stuff 0x05, high(A)
	output_stuff 0x06, low(O)
	output_stuff 0x07, high(O)
	rcall display

display:
	rcall twi_start
	mov data_handler, slave_addr
	rcall twi_send_slave_addr
	ldi data_handler, 0b10000001
	rcall twi_send_byte
	rcall twi_stop
	ret
