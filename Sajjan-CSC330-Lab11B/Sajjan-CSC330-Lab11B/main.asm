;; CSC 330 Lab 21: Assembly - The hardware timer
; Author: Ravi Sajjan
; Date: 11/09/2018

.def			io_setup	= r16						; used to set up pins as inputs or outputs
.def			workhorse	= r17						; general-purpose register
.cseg													; start of code segment
.org			0x0000									; reset vector
				rjmp		setup						; jump over interrupt vectors
.org			0x0100									; start of non-reserved program memory

setup:			ser			io_setup					; set all bits in register
				out			DDRD, io_setup				; use all pins in PORTD as outputs

				ldi			workhorse, 0b00000000		; Timer0, normal mode
				out			TCCR0A, workhorse			
				
				ldi			workhorse, 0b00000101		;[b] use a prescaler of 1024
				out			TCCR0B, workhorse	

loop:			sbi			PIND, 0						; neat trick: when a pin is used as an output, writing a 1 to
														;	its corresponding PIN register toggles its output value!
				rcall		wait_t0_overflow
				rjmp		loop

wait_t0_overflow:
				in workhorse, TIFR0
				andi workhorse, 0b00000001				;	[1] wait for the correct interrupt flag to be set
				breq wait_t0_overflow
				
				cbr workhorse, 0b00000000
				out TIFR0, workhorse
				ret 																							