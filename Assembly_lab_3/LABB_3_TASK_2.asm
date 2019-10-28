.include "m328pdef.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0

.org 0x72

start:
	ldi r20, HIGH(RAMEND)
	out SPH, R20
	ldi R20, low(RAMEND)
	out SPL, R20

	ldi r16, 0xff
	out DDRB, r16
	clr r16
	out DDRD, r16
	out PORTB, r16

	ldi r16, 0b0000_0010
	sts EICRA, r16

	ldi r16, 0b0000_0001
	out EIMSK, r16

	ldi r16, 0b0000_0001
	mov r17, r16
	ldi r23, 0x00
sei 

ring_counter:
	cpi r23, 0xff
	breq johnson_counter_inc
	out PORTB, r16
	rcall delay
	cpi r23, 0xff
	breq johnson_counter_inc
	cpi r16, 0b0010_0000
	breq reset_ring_counter
	lsl r16
	jmp ring_counter

reset_ring_counter:
	ldi r16, 0b0000_0001
	jmp ring_counter 


johnson_counter_inc:
	out PORTB, r16
	rcall delay
	cpi r23, 0x00
	breq ring_counter
	add r16, r17
	cpi r17, 0b0100_0000
	breq johnson_counter_dec
	lsl r17
	jmp johnson_counter_inc

johnson_counter_dec:
	lsr r17
	sub r16, r17
	out PORTB, r16
	cpi r17, 0b0000_0001
	breq johnson_counter_inc
	rcall delay
	cpi r23, 0x00
	breq ring_counter
	jmp johnson_counter_dec


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

interrupt_0:
	com r23    
	ldi r16, 0b0000_0001
	ldi r17, 0b0000_0010
reti