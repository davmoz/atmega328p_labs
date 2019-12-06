; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-09-26
;
;   Author:
;        David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 2
;
;   Title:
;        Task 4, Delay subroutine with variable delay time
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;        Change delay time in a ring counter using a register pair.
;
;   Input ports: None.
;
;   Output ports:
;        LEDs connected to digital pin 8-13, PORTB.
;
;    Subroutines:
;         reset				   -> Resets the ringcounter so it starts over when all LEDs have been lit.
;         delay_milliseconds   -> Compare if the counter have reached the same value as the register pair.
;         delay                -> 0.001 second delay between each LED manipulation
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


ldi r16, 0xff
out DDRB, r16
ldi r16, 0b0000_0001

; millisecond input goes into register pair r25:r24
ldi r25, 0x00				; High end in register pair
ldi r24, 0x10				; Low end in register pair

; Counter that counts delays done, resets when it is equal to milliseond input
ldi r27, 0x00				; Counter for high register pair
ldi r26, 0x00				; Counter for low register pair.


ring_counter:
    out PORTB, r16
    cpi r16, 0b0100_0000
    brge reset
    lsl r16
    rcall wait_milliseconds
    rjmp ring_counter


reset:
    ldi r16, 0b0000_0001
    rjmp ring_counter


; Runs delay (1-millisecond) as many times as requested in register pair r25:r24
wait_milliseconds:
    cp r26, r24				; Compare least significant parts of the registerpairs
    cpc r27, r25			; Compare most significant parts of the registerpairs
    brne delay
    clr r26
    clr r27
reti


delay:
    adiw r27:r26, 1			; Counter for wait_milliseconds
    ldi  r18, 21
    ldi  r19, 199
L1: dec  r19
    brne L1
    dec  r18
    brne L1
rjmp wait_milliseconds
