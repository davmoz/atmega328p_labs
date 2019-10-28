; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-10-10	
;
;   Author:
;        David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 4
;
;   Title: 
;        Task 1, Square wave generator
;    
;   Hardware: 
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function: 
;			Program that creates a square wave, one LED switch from on and off.
;
;   Input ports: none
;
;   Output ports: 
;        LEDs connected to digital pin 8, PORTB.
;
;    Subroutines: 
;		loop:			-> Checks when state_var reached 50 and branche to light
;		light:			-> One complement to r16 and send to PORTB, also reset state_var
;		timer0_int:		-> The timer interrupt that increase state_var. Set to 96 due to 16MHz processor. 
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m328pdef.inc"

.org 0x00
rjmp start

.org OVF0addr
jmp timer0_int

.org 0x72

start:
	; variable setup:
	.DEF state_var = r17
	ldi state_var, 0
	.DEF temp = r21

	; Initialize Stack Pointer
	ldi r20, HIGH(RAMEND)       ; R20 = high part of RAMEND adress
	OUT SPH, R20                ; SPH = high part of Stack Pointer
	ldi R20, low(RAMEND)        ; R20 = low part of RAMEND adress
	out SPL, R20                ; SPL = low part of Stack Pointer
	
	ldi r16, 0x01				; Initialize DDRB
	out DDRB, r16

	ldi temp, 0x05				; prescaler value to TCCR0 , 1024
    out TCCR0B, temp			; CS2 - CS2 = 101, osc.clock , 1024

    ldi temp, (1<<TOIE0)		; Timer 0 enable flag, TOIE0 
	sts TIMSK0, temp			; to register TIMSK
	ldi temp, 96				; starting value for counter
    out TCNT0, temp				; counter register
	ldi r16, 0x00
    sei

loop:
	cpi state_var, 50
	breq light
rjmp loop

light: 
	com r16
	out PORTB, r16
	clr state_var
jmp loop


timer0_int:
	push temp					; timer interrupt routine
	in temp, SREG				; save sreg on stack
	push temp
	ldi temp, 96				; startvalue for counter
	out TCNT0, temp

	inc state_var				; increase state_var

	pop temp					; restore sreg
	out SREG, temp				
	pop temp

reti