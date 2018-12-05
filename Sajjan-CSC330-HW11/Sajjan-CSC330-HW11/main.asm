;
; Sajjan-CSC330-HW11.asm
;
; Created: 11/13/2018 11:35:49 AM
; Author : Ravi Sajjan
;


.cseg
.def io_set	= r16
.def workhorse = r17
.def adc_value_low = r18
.def adc_value_high	= r19
.org 0x0000
	rjmp setup
.org 0x002A
	rjmp ADC_COMP_CONV			

; ---------------- setup sequence ----------------
setup:			
	ldi	io_set, 0xFF
	out	DDRB, io_set
	out	DDRD, io_set

	ldi	workhorse, 0b01000101 ;ADC5
	sts	ADMUX, workhorse

	ldi	workhorse, 0b11001111
	sts	ADCSRA, workhorse

	sei ;Global interrupt

; ---------------- loop sequence -----------------
loop:			
	out PORTD, adc_value_low
	out PORTB, adc_value_high
	
	rjmp loop

ADC_COMP_CONV:
	mov r19, workhorse ;Copy workhorse
	in workhorse, SREG ;Store SREG

	lds adc_value_low, ADCL
	lds adc_value_high, ADCH

	out SREG, workhorse ;Restore SREG
	mov workhorse, r19 ;Restore workhorse
	reti
