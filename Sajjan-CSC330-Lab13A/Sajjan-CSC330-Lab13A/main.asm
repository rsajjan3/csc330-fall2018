;
; Sajjan-CSC330-Lab13A.asm
;
; Created: 11/27/2018 8:18:32 AM
; Author : Ravi Sajjan
;


; Replace with your application code
.cseg
.def reg_SPI_data = r17
.def x_location = r18
.def y_location = r19
.def reg_workhorse = r20
	
.org 0x0000
	rjmp start
.org 0x0100

.macro	set_Pointer
ldi @0, low(@2<<1)
ldi @1, high(@2<<1)
.endmacro

start:
	rcall OLED_initialize
	rcall GFX_clear_array
	rcall OLED_refresh_screen
	rjmp loop

loop:
	set_Pointer ZL, ZH, Char_082
	rcall GFX_set_shape

	ldi x_location, 8
	ldi y_location, 8
	rcall GFX_set_array_pos
	rcall GFX_draw_shape
	set_Pointer XL, XH, pixel_array
	rcall OLED_refresh_screen
	rcall delay_100ms
	rjmp loop
	

.include "lib_delay.asm"
.include "lib_SSD1306_OLED.asm"
.include "lib_GFX.asm"
