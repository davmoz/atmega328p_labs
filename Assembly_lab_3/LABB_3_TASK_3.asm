.include "m328pdef.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_right

.org INT1addr
rjmp interrupt_left

.org 0x72

start:
	ldi r20, HIGH(RAMEND)
	out SPH, R20
	ldi R20, low(RAMEND)
	out SPL, R20

	ldi r16, 0xff
	out DDRB, r16			     ; Set Data Direction Register B
	clr r16
	out PORTB, r16

	ldi r16, 0b0000_1010	 ; Setting falling edge on interrupt 0 and 1
	sts EICRA, r16

	ldi r16, 0b0000_0011	 ; Enabling interrupt 0 and 1
	out EIMSK, r16

	ldi r16, 0b0011_0011	 ; Initial rear light state
	ldi r22, 0x00
	ldi r23, 0x00
sei							         ; set global interrupt enable

main:
	ldi r16, 0b0011_0011   ; Reset to initial rear light state
	out PORTB, r16
	cpi r22, 0xff
	breq turning_left
	cpi r23, 0xff
	breq turning_right
rjmp main

turning_left:
	cpi r17, 0b0000_0100	; r17 has a chance to be 4 when entering this routing from turning_right
	breq reset_left
	ldi r16, 0b0000_0011	; Light right lights when turning left
	add r16, r17
	out PORTB, r16
	rcall delay
	sub r16, r17
	lsl r17
	cpi r17, 0b0100_0000
	breq reset_left
	cpi r22, 0x00
	breq main
rjmp turning_left

reset_left:
	ldi r17, 0b0000_1000
rjmp turning_left

turning_right:
	cpi r17, 0b0000_1000	; r17 has a chance to be 8 when entering this routing from turning_left
	breq reset_right
	ldi r16, 0b0011_0000	; Light left lights when turning right
	add r16, r17
	out PORTB, r16
	rcall delay
	sub r16, r17
	lsr r17
	cpi r17, 0b0000_0000
	breq reset_right
	cpi r23, 0x00
	breq main
rjmp turning_right

reset_right:
	ldi r17, 0b0000_0100
rjmp turning_right

interrupt_left:
	com r22					      ; Toggles r22
	clr r23					      ; Change state of turning right to inactive
	ldi r16, 0b0000_1011	; Sets the starting state of the turn
	ldi r17, 0b0000_1000	; Sets the traverser for the ring counter
reti

interrupt_right:
	com r23					      ; Toggles r23
	clr r22					      ; Change state of turning left to inactive
	ldi r16, 0b0011_0100	; Sets the starting state of the turn
	ldi r17, 0b0000_0100	; Sets the traverser for the ring counter
reti

delay:
	ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1:
	dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
reti
