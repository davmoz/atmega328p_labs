; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-10-03
;
;   Author:
;        David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 3
;
;   Title:
;        Task 1, Switch that turns ON/OFF a LED
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;        Switch that turns ON and OFF a LED using interupt
;
;   Input ports:
;		 Switch button connected to digital pin 2, PORTD
;
;   Output ports:
;        LED connected to digital pin 8, PORTB.
;
;    Subroutines:
;         main_program -> Out's PORTB
;		  interrupt_0  -> Toggle the LED when triggered.
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m328pdef.inc"
.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0

.org 0x72

start:
	; Initialize Stack Pointer
	ldi r20, HIGH(RAMEND)       ; R20 = high part of RAMEND adress
	OUT SPH, R20                ; SPH = high part of Stack Pointer
	ldi R20, low(RAMEND)        ; R20 = low part of RAMEND adress
	out SPL, R20                ; SPL = low part of Stack Pointer

	ldi r16, 0x01
	out DDRB, r16				        ; Load r16 as output

	ldi r16, 0b0000_0010		    ; Setting falling edge on interrupt_0
	sts EICRA, r16
	ldi r16, 0b0000_0001		    ; Interrupt_0
	out EIMSK, r16
sei								            ; Set global interrupt enable

ldi r16, 0x01					        ; Set r16 to 1
main_program:
	out PORTB, r16				      ; Send r16 to PORTB
rjmp main_program

interrupt_0:
    com r16						        ; One's complement of r16
reti
