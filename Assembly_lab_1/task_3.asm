; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;     1DT301, Computer Technology 1
;     Date: 2019-09-17
;
;     Author:
;        David Mozart
;        Marcus Thornemo-Larsson
;
;     Lab number: 1
;     Title:     
;			Task 3, Connect switch 5 to LED 0
;    
;     Hardware: 
;			Arduino UNO rev 3, CPU ATmega328p
;
;     Function: 
;			Light LED0 when pressing switch 5
;
;     Input ports: 
;			On-board switches connected to PORTD
;
;     Output ports: 
;			On-board LEDs connected to PORTB
;
;     Subroutines: None.
;     Included files: None.
;
;     Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



ldi r16, 0b0000_0001p