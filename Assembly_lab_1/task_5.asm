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
;		Task 5, LEDs illustrating a Ring Counter
;
;   Hardware:
;		Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;		Lights LEDs one at a time in order and repeat when last LED is turned off
;
;   Input ports: None.
;
;   Output ports:
;		Digital pins 8-13 (PORTB) to set the current LED to either HIGH or LOW
;
;	Subroutines:
;		reset		-> Resets the ring counter once the last LED in order is lit
;		delay		-> 0.5 second delay between each LED manipulation
;
;	Included files:	None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; Initialize Stack Pointer
ldi r20, HIGH(RAMEND)		; R20 = high part of RAMEND adress
OUT SPH, R20				    ; SPH = high part of Stack Pointer
ldi R20, low(RAMEND)		; R20 = low part of RAMEND adress
out SPL, R20				    ; SPL = low part of Stack Pointer

; Set Data Direction Registers
ldi r16, 0xFF
out DDRB, r16				    ; DDRB = 0x04
ldi r16, 0b0000_0001
out PORTB, r16				  ; Write in PORTB


ring_counter:
    out PORTB, r16		    ; Write in PORTB
    rcall delay				    ; 0.5 second delay
    cpi r16, 0b0010_0000	; Compare if counter has reached the last LED
    breq reset				    ; Reset counter if yes
    lsl r16					      ; Move on to the next LED (To the LEFT)
    rjmp start				    ; Repeat from start


reset:
ldi r16, 0b0000_0001
rjmp ring_counter				  ; Back to the main program

; Label that creates a 0.5 second delay on a 16 MHz CPU
; Generated at http://www.bretmulvey.com/avrdelay.html
delay:
    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
reti
