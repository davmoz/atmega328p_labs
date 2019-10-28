; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-09-26
;
;   Author:
;        David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 2
;
;   Title: 
;        Task 2, Electronic dice
;    
;   Hardware: 
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function: 
;			Displays "random" dice result when switch is released
;
;   Input ports: PORT D, PIN3.
;
;   Output ports: 
;        LEDs connected to digital pin 8-13, PORTB.
;
;    Subroutines: 
;		switch_pressed	-> Keeps calling the randomize subroutine while the switch is pressed and
;						jumps back to main to display the results when the switch is released.
;		randomize		-> Keeps shifting the traverser and resets it when its value passes 0b1000_0000.
;		reset			-> resets the traverser (shifter)
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Initialize Stack Pointer
ldi r20, HIGH(RAMEND)       ; R20 = high part of RAMEND adress
OUT SPH, R20                ; SPH = high part of Stack Pointer
ldi R20, low(RAMEND)        ; R20 = low part of RAMEND adress
out SPL, R20                ; SPL = low part of Stack Pointer


ldi r16, 0xff
out DDRB, r16
clr r16
out DDRD, r16

ldi r16, 0b0000_0001
ldi r17, 0b0000_0010
ldi r18, 0x00
out PORTB, r16

main:
	out PORTB, r16
	in r18, PIND
	andi r18, 0b0000_1000
	cpi r18, 0b0000_1000
	breq switch_pressed
	rjmp main

switch_pressed:
	ldi r19, 0x00
	out PORTB, r19
	in r18, PIND
	andi r18, 0b0000_1000
	cpi r18, 0b0000_1000	; Check if switch pin 3 is high (pressed)
	breq randomize
	rcall main				; Jump back to main if switch is not pressed (show dice result)

randomize: 
	add r16, r17
	lsl r17
	cpi r17, 0b1000_0000
	breq reset
	rjmp switch_pressed

reset: 
	ldi r16, 0b0000_0001
	ldi r17, 0b0000_0010
	rjmp switch_pressed