; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-09-17
;
;   Author:
;		David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 1
;
;   Title: 
;		Task 1, A bare minimum program to ligh LED 2 on the board
;    
;   Hardware: 
;		Arduino UNO rev 3, CPU ATmega328p
;
;   Function: 
;		Lights up LED connected to pin 11 on board
;		
;
;   Input ports: 
;		None
;
;   Output ports: 
;		PORTB, Digital pin 10
;
;	Subroutines: None.
;
;	Included files:	None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


	ldi r16, 0b0000_0100	;
	out DDRB, r16			; Setting Data Direction Register
	out PORTB, r16			; Write to PORTB
