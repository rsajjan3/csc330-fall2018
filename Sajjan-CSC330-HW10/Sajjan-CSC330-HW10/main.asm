;
; Sajjan-CSC330-HW10.asm
;
; Created: 11/5/2018 9:36:12 AM
; Author : Ravi Sajjan
;

;E3.15
;Write a program to set the bit 7 and bit 0 of all the elements of an array to 1.
.cseg
elements: .db 20,21,3,22,5,6,7,8
.equ elements_count = 8
.def loop_counter = r16
.def workhorse = r17
rcall main

main:
	ldi ZL, low(elements<<1)
	ldi ZH, high(elements<<1)
	ldi loop_counter, 0 ; Start from 0
	rjmp loop

loop:
	cpi loop_counter, elements_count+1
	breq done

	lpm workhorse, Z
	ori workhorse, 0b10000001
	st Z+, workhorse

	inc loop_counter
	rjmp loop

done:
	ret nop

;E3.20
;Write a program to find the largest element, the smallest element, and their average of an array of 8-bit elements. Store these three numbers in data memory starting from 0x200
.cseg
elements: .db 20,21,3,22,5,6,7,8
.equ elements_count = 8
.def loop_counter = r16
.def workhorse = r17
.def largest = r18
.def smallest = r19
.def average = r20
rcall main

.macro	set_Pointer
ldi @0, low(@2)
ldi @1, high(@2)
.endmacro

main:
	ldi ZL, low(elements<<1)
	ldi ZH, high(elements<<1)
	ldi loop_counter, 0 ; Start from 0
	ldi largest, 0
	ldi smallest, 255
	set_Pointer YL, YH, 0x200 ;Setup pointer to store at 0x200
	rjmp loop

loop:
	cpi loop_counter, elements_count
	breq done

	lpm workhorse, Z+

	cp workhorse, largest
	brsh bigger ;If workhorse > largest, update largest

	cp workhorse, smallest
	brlo smaller ;If workhorse < smallest, update smallest

	rjmp increment
bigger:
	mov largest, workhorse
	rjmp increment

smaller:
	mov smallest, workhorse
	rjmp increment

increment:
	inc loop_counter
	rjmp loop

done:
	st Y+, largest
	st Y+, smallest

	mov average, largest ;Store largest into average
	add average, smallest ;Add average(largest)+smallest
	lsr average ;Divide by 2 to get the average
	
	st Y, average ;Store average into Y pointer

	ret nop


;3.) The last location is: 0x5F, it is called SREG
;4.) The first location is: 0x60, it is called WDTCSR
;5.)
.org
rjmp setup_stack
setup_stack:
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16
