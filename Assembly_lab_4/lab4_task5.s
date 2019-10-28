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
;        Task 5, Serial communication using interrupt
;    
;   Hardware: 
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function: 
;			Serial communication using interrupt	
;
;   Input ports: none
;
;   Output ports: 
;        LEDs connected to digital pin 8-13, PORTB.
;
;    Subroutines: 
;		get_char:			-> read character in UDR
;		port_output:		-> write character to PORTB
;		put_char:			-> write character to UDR0
;
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m328pdef.inc"

.org 0x00
	rjmp start
.org URXCaddr
	rjmp get_char

; variable setup:
.DEF char = r16
.DEF temp = r17
.equ UBRR_val = 12

.org 0x50
start:
	; Initialize Stack Pointer
	ldi temp, HIGH(RAMEND)       ; r17 = high part of RAMEND adress
	out SPH, temp                ; SPH = high part of Stack Pointer
	ldi temp, low(RAMEND)        ; r17 = low part of RAMEND adress
	out SPL, temp                ; SPL = low part of Stack Pointer

	ldi temp, 0xFF				; portB outputs
	out DDRB, temp
	ldi temp, 0x55				; initial value to outputs
	out PORTB, temp

	ldi temp, UBRR_val			; store Prescaler value in UBRR0L
	sts UBRR0L, temp
	ldi temp, 0b1001_1000		; RXCIE = 1, RXEN = 1, TXEN = 1
	sts UCSR0B, temp
	sei							; set global interrupt flag

nop_loop:
	nop
	rjmp nop_loop

get_char:
	lds char, UDR0				; read character in UDR

/* This is for task 3, only works with 6 LEDs tho*/
	port_output:
	out PORTB, char			; write character to PORTB

put_char:			
	sts UDR0, char				; write character to UDR0
	reti