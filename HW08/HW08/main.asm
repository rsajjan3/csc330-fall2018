;
; HW08.asm
;
; Created: 10/21/2018 3:53:23 PM
; Author : Ravi Sajjan
;


; Replace with your application code
start:
    call question_3

question_1: ;Swap function
	ldi r16, 4
	ldi r17, 26

	mov r18, r16 ;Copy r16 into r18
	mov r16, r17 ;Copy r17 into r16
	mov r17, r18 ;Copy r18(old r16) into r17
	ret

question_2:
	ldi r16, 22
	sts 255, r16 ;Memory spot 255
	ret

question_3:
	ldi r28, 0x00
	ldi r29, 0x10 ;Y points to 256
	
	ldi r16, 254 ; Load 254 into r16
	st Y, r16 ;Put r0 at location Y(256)

	ldi r16, 79 ; Load 79 into r0
	std Y+1, r16 ;Put r0 at location Y+1(257)

question_4:
	ldi r28, 0x02 ;Low
	ldi r29, 0x10 ;Hi; Y= 1002
	ldi r30, 0x10
	ldi r31, 0x20 ;Z= 2010

	ld r0, Y ; Put contents of 0x1002 into r0
	st Z, r0 ; Put contents of r0 into 0x2010

	ldd r0, Y+1
	std Z+1, r0

	ldd r0, Y+2
	std Z+2, r0

	ret

question_5:
	ldi YL, 0x00
	ldi YH, 0x20
	ldi r0, 5

	st Y, r0
	std Y+1, r0
	std Y+2, r0

	ret

question_6:
	ldi r16, 0b11111111
	out DDRD, r16

	ldi r16, 0b10101010 ; 0xAA
	out PORTD, r16

	ret