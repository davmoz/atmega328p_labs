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
;        Task 3-4, Serial communication /with ECHO
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;			Program that lights LEDs in binary ( not all because we are retards and have to use arduino, so only 6 leds ) when we type in a character.
;			Also shows this in the terminal, where it shows ascii code for that character.
;
;   Input ports: none.
;
;   Output ports:
;        LEDs connected to digital pin 8-13, PORTB.
;
;    Subroutines:
;		getChar:			-> read character in UDR
;		port_output:		-> Lights LEDs
;		putChar:			-> write character to UDR0
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m328pdef.inc"

.org 0x00
	rjmp start

.org 0x30

; variable setup:
.DEF char = r16
.DEF temp = r17
.equ UBRR_val = 12

start:
	ldi temp, 0xFF			  ; portB outputs
	out DDRB, temp
	ldi temp, 0x55			  ; initial value to outputs
	out PORTB, temp

	ldi temp, UBRR_val		; stor Prescaler value in UBRR1L
	sts UBRR0L, temp

	ldi temp, (1<<TXEN0) | (1<<RXEN0)
	sts UCSR0B, temp		 ; Set TX and RX enable flags

getChar:
	lds temp, UCSR0A		 ; read UCSR0A I/O register to r20
	sbrs temp, RXC0			 ; RXC1=1 -> new character
	rjmp getChar			   ; RXC1=0 -> no character recived
	lds char, UDR0			 ; read character in UDR

/* This is for task 3, only works with 6 LEDs tho*/
/*
port_output:
	out PORTB, char			; write character to PORTB
*/

putChar:
	lds temp, UCSR0A		 ; read UCSR1a I/O register to r20
	sbrs temp, UDRE0		 ; UDRE1=1 -> buffer is empty
	rjmp putChar			   ; UDRE1=0 -> buffer is not empty
	sts UDR0, char			 ; write character to UDR0
	rjmp getChar
