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
;        Task 1, Switch - Ring counter / Johnson counter
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;			Initially runs Johnson counter, then changes to ring counter when switch is pressed and
;			continues switching between the two each time the switch is pressed.
;
;   Input ports: PORT D, PIN2.
;
;   Output ports:
;        LEDs connected to digital pin 8-13, PORTB.
;
;    Subroutines:
;		ring_counter		-> Runs ring counter
;		reset_ring_counter	-> Resets the counter in ring counter
;		johnson_counter_inc	-> Runs Johnson counter
;		johnson_counter_dec	-> --==--
;		switch_pressed		-> Runs toggle_flag is the switch is pressed
;		toggle_flag			-> Flips between 1 and 0, depending on the state of the flag
;		set_low				-> Sets flag to low  (runs ring_counter)
;		set_high			-> Sets flag to high (runs johnson_counter)
;       reset				-> Resets the ringcounter so it starts over when all LEDs have been lit.
;       delay               -> ~0.5 second delay between each LED manipulation
;       switch_delay		-> delay after switch is pressed to avoid multiple inputs while pressing
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
clr r16
out DDRD, r16

ldi r16, 0b0000_0000
ldi r17, 0b0000_0001
out PORTB, r16
ldi r23, 0x00

main:
	rcall johnson_counter_inc

ring_counter:
	out PORTB, r17
	rcall delay
	cpi r17, 0b0010_0000
	breq reset_ring_counter
	lsl r17
	rjmp ring_counter

reset_ring_counter:
	ldi r17, 0b0000_0001
	rjmp ring_counter


johnson_counter_inc:
	add r16, r17
	out PORTB, r16
	cpi r17, 0b0100_0000
	breq johnson_counter_dec
	lsl r17
	rcall delay
	rjmp johnson_counter_inc

johnson_counter_dec:
	lsr r17
	sub r16, r17
	out PORTB, r16
	rcall delay
	cpi r17, 0b0000_0001
	breq johnson_counter_inc
	rjmp johnson_counter_dec


switch_pressed:
	clr r24
	in r24, PIND
	andi r24, 0b0000_1100
	brne toggle_flag
	reti

toggle_flag:
	cpi r23, 0x00
	breq set_high
	rcall set_low
	reti

set_low:
	rcall switch_delay
	ldi r23, 0x00
	ldi r16, 0b0000_0000
	ldi r17, 0b0000_0001
	jmp ring_counter

set_high:
	rcall switch_delay
	ldi r23, 0xff
	ldi r16, 0b0000_0000
	ldi r17, 0b0000_0001
	jmp johnson_counter_inc

; In this delay, we also check for switch activity
delay:
	ldi r18, 4
	ldi r19, 5
	ldi r20, 50
L1:
	rcall switch_pressed
	dec r20
	brne L1
	rcall switch_pressed
	dec r19
	brne L1
	rcall switch_pressed
	dec r18
	brne L1
reti

; This routine is called once the switch is pressed, to avoid multiple flaggings
switch_delay:
    ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
reti
