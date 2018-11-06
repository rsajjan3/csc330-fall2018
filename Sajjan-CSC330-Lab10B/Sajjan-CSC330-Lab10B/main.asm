; CSC-330 Lab 10 B
; ADC Basics
; This program will show the basic functionality of the Analog-to-Digital Converter (ADC)
; using the "Wait for Conversion" method. The input should come from ADC2, and the
; conversion will output on PORTD (ADCL) and PORTB (ADCH).

.cseg													; start of code segment
.def			io_set			= r16					; used to set up the outputs on ports B and D
.def			workhorse		= r17					; multi-purpose register used to move bytes to/from ADCSRA and ADMUX
.def			adc_value_low	= r18					; used to manipulate the low byte of the result of the ADC conversion
.def			adc_value_high	= r19					; used to manipulate the high byte of the result of the ADC conversion
.org			0x0000									; change target program memory address to 0x000
				rjmp		setup						; jump over the reserved interrupt veector locations
.org			0x0100									; begin storing program at location 0x0100

; ---------------- setup sequence ----------------
setup:			ldi			io_set, 0xFF				; load all 1s into io_set
				out			DDRB, io_set				; use io_set to set all pins in ports B and D to outputs
				out			DDRD, io_set
														; use workhorse to store values into ADMUX by:
				ldi			workhorse, 0b01000010		;	[1] using ADC2 (MUX3 through MUX0)
				sts			ADMUX, workhorse			;	[2] using the voltage ref of AVCC (REFS1 and REFS0)

; ---------------- loop sequence -----------------
loop:			
				ldi			workhorse, 0b11000111		;	[1] enabling the ADC (ADEN) & [2] starting the conversion (ADSC) & [3] using a prescalar of 128 (ADPS1 and ADPS0)
				sts			ADCSRA, workhorse

	; --------- wait for adc to finish ----------		; check to see if the ADC conversion is done by:
	wait_adc:	lds			workhorse, ADCSRA			;	[1] loading into workhorse the value of ADCSRA
				andi		workhorse, 0b00010000		;	[2] testing against the interrupt flag of ADCSRA (ADIF)
				breq		wait_adc					;	[3] if the flag is not set, keep waiting

	; -------------- output values --------------
	show:
				lds			adc_value_low, ADCL			;	[1] ADCL into adc_value_low
				lds			adc_value_high, ADCH		;	[2] ADCH into adc_value_high

				out			PORTD, adc_value_low		; 	output the values to their respective ports
				out			PORTB, adc_value_high
				rjmp		loop