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
;        Task 2, Pulse width modulation (PWM)
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;			Program that controlls a square wave, with two buttons. Increase with 5% and decrease with 5%
;
;   Input ports: PORTD, PIN 2 and 3 (interrupts 0 and 1).
;
;   Output ports:
;        LEDs connected to digital pin 8, PORTB.
;
;    Subroutines:
;		loop:					-> Turns on the LED as long as the counter_var is less then state_var ( our duty cycle variable )
;		reset_counter_var:		-> Reset/clear counter_var
;		on:						-> One complement on r16
;		timer0_int:				-> The timer interrupt that increase counter_var. Set to 96 due to 16MHz processor. (10ms)
;		interrupt_0:			-> Increase state_var that controlls the duty cycle. Increase in steps of 5. Also checks if state_var = 100, then skip next command.
;		interrupt_1:			-> Decrease state_var that controlls the duty cycle. Decrease in steps of 5. Also checks if state_var = 0, then skip next command.
;
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

.org INT0addr
rjmp interrupt_0

.org INT1addr
rjmp interrupt_1

.org 0x72

start:
	; variable setup:
	.DEF state_var = r17
	ldi state_var, 5
	.DEF counter_var = r18
	ldi counter_var, 0
	.DEF temp = r21

	; Initialize Stack Pointer
	ldi r20, HIGH(RAMEND)       ; R20 = high part of RAMEND adress
	OUT SPH, R20                ; SPH = high part of Stack Pointer
	ldi R20, low(RAMEND)        ; R20 = low part of RAMEND adress
	out SPL, R20                ; SPL = low part of Stack Pointer

	ldi r16, 0x01				        ; Initialize DDRB
	out DDRB, r16

	ldi temp, 0x05				      ; prescaler value to TCCR0 , 1024
    out TCCR0B, temp			    ; CS2 - CS2 = 101, osc.clock , 1024

    ldi temp, (1<<TOIE0)		  ; Timer 0 enable flag, TOIE0
	sts TIMSK0, temp			      ; to register TIMSK
	ldi temp, 96				        ; starting value for counter
    out TCNT0, temp				    ; counter register
	ldi r16, 0x00
    sei

	ldi r16, 0b0000_1010
    sts EICRA, r16

    ldi r16, 0b0000_0011
    out EIMSK, r16
	clr r16

loop:
	out PORTB, r16
	cpi counter_var, 100
	breq reset_counter_var
	cp counter_var, state_var
	brlt on
	clr r16
rjmp loop

reset_counter_var:
	clr counter_var
jmp loop

on:
	com r16
rjmp loop

timer0_int:
	push temp					   ; timer interrupt routine
	in temp, SREG				 ; save sreg on stack
	push temp
	ldi temp, 96				 ; startvalue for counter
	out TCNT0, temp

	inc counter_var

	pop temp					   ; restore sreg
	out SREG, temp
	pop temp

reti

interrupt_0:
	ldi r24, 100
	ldi r19, 5
	cpse state_var, r24
	add state_var, r19
reti

interrupt_1:
	ldi r24, 0
	ldi r19, 5
	cpse state_var, r24
	sub state_var, r19
reti
