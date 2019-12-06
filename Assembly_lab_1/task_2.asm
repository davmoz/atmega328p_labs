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
;		Task 2, Connect 6 LEDs to 6 switches
;
;   Hardware:
;		Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;		Light corresponding LED when a switch is pressed and turn off when switch is released
;
;   Input ports:
;		PORTD - Digital pins 2-7, to which the switches are connected to
;
;   Output ports:
;		PORTB - Digital pins 8-13 to set the LED, which it's corresponding switch is pressed/released,  to on/off
;
;	Subroutines: None.
;
;	Included files:	None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


ldi r16, 0xff
out DDRB, r16			   ; Set PORTB as output
clr r16
out DDRD, r16			   ; Set PORTD as INPUT
out PORTB, r16		   ; Write to PORTB

my_loop:
    in r16, PIND	   ; Read input from PORTD (which switch of the 6 is pressed?)
    lsr r16				   ; Shift the input from PORTD twice to the right (To match the PORTB pin-layout)
    lsr r16
    out PORTB, r16   ; Write to PORTB
    rjmp my_loop     ; Start over from my_loop
