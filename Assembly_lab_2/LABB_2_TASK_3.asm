; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;     1DT301, Computer Technology 1
;     Date: 2019-09-25
;
;     Author:
;        David Mozart
;        Marcus Thornemo-Larsson
;
;     Lab number: 2
;     Title:	  Task 3, Change counter
;
;     Hardware: Arduino UNO rev 3, CPU ATmega328p
;
;     Function: Counter that increase when push a button and release the button. Disply counter with LEDs in binary form.
;
;     Input ports: Switch, PORTD, PIN 3
;
;     Output ports: LEDs, PORTB, PIN 8-13
;
;     Subroutines: pushed	- increase counter when switch is pressed
;				   loop		- waiting for switch to be released
;				   released - increase coutner when switch is released
;     Included files:
;
;     Other information:
;							Arduino only have 6 outputs, but the counter continue in the
;							register up till 255 and after that the register resets to 0. (Our tests confirmed that)
;
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


ldi r16, 0xff
out DDRB, r16
clr r16

ldi r17, 0x00
out DDRD, r17

start:
	in r17, PIND
	andi r17, 0b0000_1000
	cpi r17, 0b0000_1000
	breq pushed
	rjmp start

pushed:						     ; increment r16, display its value and go to loop
	inc r16
	out PORTB, r16
	rjmp loop

loop:
	in r17, PIND
	andi r17, 0b0000_1000
	cpi r17, 0b0000_0000
	breq released			   ; jump if pin 2 is not pressed (Not 1)
	rjmp loop

released:					     ; increment r16, display its value and go to start
	inc r16
	out PORTB, r16
	rjmp start
