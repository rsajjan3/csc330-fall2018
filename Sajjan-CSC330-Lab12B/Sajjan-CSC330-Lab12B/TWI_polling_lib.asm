; --------------------------------------------------------------------------------------------------------------------------------------
; TWI polling library
; Small library for setting up TWI protocol (without interrupts) in AVR assembly
; Author: Kristof Aldenderfer
; Date: 2018.11.15
; Original date: 2018.04.14
;
; Register usage:
;		- r16: is the data register from which data will be sent or into which data will be loaded.
;		- r19: is the register doing all the heavy lifting.
;		- NOTE: DO NOT USE R19 IN YOUR MAIN CODEBASE
; --------------------------------------------------------------------------------------------------------------------------------------
.equ					TWI_init_chk =	0x08
.equ					TWI_ack_addr =	0x18
.equ					TWI_ack_data =	0x28
; --------------------------------------------------------------------------------------------------------------------------------------
; Sets up TWI protocol
; --------------------------------------------------------------------------------------------------------------------------------------
twi_setup:
						in				r19, DDRC								; set up SDA/SCL as inputs
						andi			r19, 0b00000000
						out				DDRC, r19
						ldi				r19, 0b11111111							; enable pullups on SDA/SCL
						out				PORTC, r19
						lds				r19, TWSR0								; set prescalar to 1 by clearing TWPS1 and TWPS0
						andi			r19, 0b11111100
						sts				TWSR0, r19
						ldi				r19, 12									; set freq to 400kHz
						sts				TWBR0, r19								; TWBR = ((F_CPU / TWI_FREQ) - 16) / 2
						ldi				r19, (1<<TWEN | 1<<TWIE)				; turn on TWI
						sts				TWCR0, r19
						ret
; --------------------------------------------------------------------------------------------------------------------------------------
; Generates a TWI START
; --------------------------------------------------------------------------------------------------------------------------------------
twi_start:
						ldi				r19, (1<<TWINT | 1<<TWSTA | 1<<TWEN)
						sts				TWCR0, r19								; generate START condition
	twi_start_wait:
						lds				r19, TWCR0
						sbrs			r19, TWINT
						rjmp			twi_start_wait
						lds				r19, TWSR0								; check to make sure bus works
						andi			r19, 0b11111000
						cpi				r19, TWI_init_chk
						;brne			twi_error
						ret
; --------------------------------------------------------------------------------------------------------------------------------------
; Generates a TWI STOP
; --------------------------------------------------------------------------------------------------------------------------------------
twi_stop:
						ldi				r19, (1<<TWINT | 1<<TWSTO | 1<<TWEN)
						sts				TWCR0, r19								; generate STOP condition
						ret
; --------------------------------------------------------------------------------------------------------------------------------------
; Sends TWI slave address
; --------------------------------------------------------------------------------------------------------------------------------------
twi_send_slave_addr:
						sts				TWDR0, r16								; write byte
						ldi				r19, (1<<TWINT | 1<<TWEN)
						sts				TWCR0, r19								; start sending
	twi_send_slave_wait:
						lds				r19, TWCR0
						sbrs			r19, TWINT
						rjmp			twi_send_slave_wait
						lds				r19, TWSR0								; did you get ACK?
						andi			r19, 0b11111000
						cpi				r19, TWI_ack_addr
						;brne			twi_error
						ret
; --------------------------------------------------------------------------------------------------------------------------------------
; Sends one byte over TWI (can be command or data)
; --------------------------------------------------------------------------------------------------------------------------------------
twi_send_byte:
						sts				TWDR0, r16								; write byte
						ldi				r19, (1<<TWINT | 1<<TWEN)
						sts				TWCR0, r19								; start sending
	twi_send_byte_wait:
						lds				r19, TWCR0
						sbrs			r19, TWINT
						rjmp			twi_send_byte_wait
						lds				r19, TWSR0								; did you get ACK?
						andi			r19, 0b11111000
						cpi				r19, TWI_ack_data
						;brne			twi_error
						ret
; --------------------------------------------------------------------------------------------------------------------------------------
; When TWI generates an error, end up here (not currently implemented)
; --------------------------------------------------------------------------------------------------------------------------------------
twi_error:				ldi				r19, 0b00000001
						out				PORTD, r19
	twi_error_loop:		rjmp			twi_error_loop
; --------------------------------------------------------------------------------------------------------------------------------------
; End of file
; --------------------------------------------------------------------------------------------------------------------------------------
.exit