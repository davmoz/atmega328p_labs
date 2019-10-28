; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-09-17
;
;   Author:
;        David Mozart
;		 Marcus Thornemo-Larsson
;
;   Lab number: 1
;
;   Title: 
;        Task 6, LEDs illustrating a Johnson Counter
;    
;   Hardware: 
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function: 
;        Lights up LEDs consecutivly in order, then turns them off one by one in reverse order (turns off last lighed led)
;
;   Input ports: None.
;
;   Output ports: 
;        Digital pins 8-13 (PORTB) to set the LEDs to either HIGH or LOW, depending on the stage of the program (Incrementing & Decrementing)
;
;    Subroutines: 
;        increment    -> Lights up LEDs in order
;        decrement    -> Turns LEDs off in reverse order
;        delay        -> 0.5 second delay between each LED manipulation
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Initialize Stack Pointer
ldi r20, HIGH(RAMEND)       ; R20 = high part of RAMEND adress
OUT SPH, R20                ; SPH = high part of Stack Pointer
ldi R20, low(RAMEND)        ; R20 = low part of RAMEND adress
out SPL, R20                ; SPL = low part of Stack Pointer
 
ser r16						; Set R16 to output
out DDRB, r16				; PortB as output	
clr r16						; Clear r16
out DDRD, r16
out PORTB, r16				; Write value of r16 to PORTB

ldi r17, 0b0000_0001		; Load 0x01 to R16

increment:					;
    out PORTB, r16			; Write value of r16 to PORTB
    rcall delay				; Call subroutine delay
    add r16, r17			; Add value of r17 to r16
    lsl r17					; Move value of r17 on step to the left
    cpi r17, 0b0100_0000	; Compare if r17's value is 0x80
    brge decrement			; Branch to decrement if r17 is equal to 0x80	
    rjmp increment			; jump to subroutine increment

decrement:					;
    sub r16, r17			; Subtract r17 from r16
    out PORTB, r16			; Write value of r16 to PORTB
    rcall delay				; 
    lsr r17					; Move valute one step to the right in r17
    cpi r16, 0b0000_0000	; Comapre if r16 is equal to 0x00	
    breq increment			; Branch to increment if r16 is equa to 0x00
    rcall decrement			; Go to decrement


ring_counter:				;
    out PORTB, r16			; Write in PORTB
    rcall delay				; 0.5 second delay
    cpi r16, 0b0010_0000	; Compare if counter has reached the last LED
    breq reset				; Reset counter if yes
    lsl r16					; Move on to the next LED (To the LEFT)
    rjmp ring_counter		; Repeat from start


reset:
ldi r16, 0b0000_0001		;
rjmp ring_counter					; Back to the main progra

; Label that creates a 0.5 second delay on a 16 MHz CPU
; Generated at http://www.bretmulvey.com/avrdelay.html
delay:					
    ldi  r18, 41			;
    ldi  r19, 150			;
    ldi  r21, 128			;
L1:							;
    dec  r21				;
    brne L1					;
    dec  r19				;
    brne L1					;
    dec  r18				;
    brne L1					;
reti						;