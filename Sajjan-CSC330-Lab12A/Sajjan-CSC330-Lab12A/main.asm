; CSC-330 Lab 12A: Assembly - Interrupts
; Author: Ravi Sajjan
; Date: 11/13/2018

;Enable specific interrupt, enable global interupts, setup interupt vector, write Interupt Subroutine
.def	io_setup	= r16						; used to set up pins as inputs or outputs
.def	workhorse	= r17						; general-purpose register
.cseg
.org 0x0000
	rjmp setup
.org 0x001C
	rjmp ISR_TIMER0_CPA	
.org 0x0020
	rjmp ISR_TIMER0_OVF ;Setup interupt vector

;setup
.org 0x0100
setup:
	ldi io_setup, 0b11111111
	out DDRD, io_setup

	ldi	workhorse, 0b00000010
	out	TCCR0A, workhorse	
	
	ldi workhorse, 0b00000011
	out TCCR0B, workhorse

	ldi workhorse, 123
	out OCR0A, workhorse

	ldi workhorse, 0b00000010 ;Enable overflow/compare interupt flag
	sts TIMSK0, workhorse

	sei ;Enable global interupt flag

;loop
loop:
	nop
	rjmp loop

;overflow
ISR_TIMER0_OVF:
	sbi	PIND, 0
	reti ;Return from interupt

ISR_TIMER0_CPA:
	sbi	PIND, 0
	reti ;Return from interupt							