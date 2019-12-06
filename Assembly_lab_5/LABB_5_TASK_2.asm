; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology 1
;   Date: 2019-10-17
;
;   Author:
;        David Mozart
;       Marcus Thornemo-Larsson
;
;   Lab number: 5
;
;   Title:
;        Task 2, Electronic bingo machine.
;
;   Hardware:
;        Arduino UNO rev 3, CPU ATmega328p
;
;   Function:
;        Switch that generates a "random" number each time the switch is pushed.
;
;   Input ports:
;		 PORT B
;
;   Output ports:
;        LCD PORT D
;
;    Included files:    None.
;
;   Other information: N/A
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m328pdef.inc"
.def	Temp	= r16
.def	Data	= r17

.def	one	= r20
.def	two	= r21
.def	counter	= r23

.def	RS	= r18
.equ	BITMODE4	= 0b00000010		; 4-bit operation
.equ	CLEAR	= 0b00000001			  ; Clear display
.equ	DISPCTRL	= 0b00001111		; Display on, cursor on, blink on.

.cseg
.org	0x0000				            ; Reset vector
	jmp reset

.org	0x0072

reset:

	ldi Temp, HIGH(RAMEND)	    ; Temp = high byte of ramend address
	out SPH, Temp			          ; sph = Temp
	ldi Temp, LOW(RAMEND)	      ; Temp = low byte of ramend address
	out SPL, Temp			          ; spl = Temp

	ser Temp				            ; r16 = 0b11111111
	out DDRD, Temp			        ; port D = outputs ( Display JHD202A)
	clr Temp				            ; r16 = 0
	out PORTD, Temp

	ldi r16, 0x00
	OUT DDRB, r16


; **
; ** init_display
; **
init_disp:
	rcall power_up_wait		     ; wait for display to power up
	rcall power_up_wait
	rcall power_up_wait
	rcall power_up_wait
	rcall power_up_wait
	ldi Data, BITMODE4		     ; 4-bit operation
	rcall write_nibble		     ; (in 8-bit mode)
	rcall short_wait		       ; wait min. 39 us
	ldi Data, DISPCTRL		     ; disp. on, blink on, curs. On
	rcall write_cmd			       ; send command
	rcall short_wait		       ; wait min. 39 us

;this is where your code starts

ldi one, 0x36
ldi two, 0x2f
rcall clr_disp

loop:
	in r22, PINB
	andi r22, 0x01
	cpi r22, 0x01
	breq randomize
rjmp loop

randomize:
	rcall clr_disp		 ; Clear display

	inc two

	cpi two, 0x3A		   ; Check if two is > 9
	brge reset_two		 ; increment one if true


	cpi two, 0x36		   ; Check if two is > 6
	breq check_two	   ; Reset both to 0 if two is 6 and one is 7

	mov Data, one		   ; Print one
	rcall write_char
	rcall short_wait	 ; Wait 20ms

	mov Data, two		   ; Print two
	rcall write_char
	rcall short_wait	 ; Wait 20ms

rjmp loop

reset_two:
	ldi two, 0x2f
	inc one
rjmp loop

reset_one:
	ldi one, 0x30
	ldi two, 0x30
rjmp loop

check_two:
	cpi one, 0x37
	brge reset_one

	mov Data, one
	rcall write_char
	rcall power_up_wait

	mov Data, two
	rcall write_char
	rcall power_up_wait
rjmp randomize



;this is where your code ends

clr_disp:
	ldi Data, CLEAR			; clr display
	rcall write_cmd			; send command
	rcall long_wait			; wait min. 1.53 ms
	ret

; **
; ** write char/command
; **

write_char:
	ldi RS, 0b00100000		   ; RS = high
	rjmp write
write_cmd:
	clr RS					         ; RS = low
write:
	mov Temp, Data			    ; copy Data
	andi Data, 0b11110000	  ; mask out high nibble
	swap Data				        ; swap nibbles
	or Data, RS				      ; add register select
	rcall write_nibble		  ; send high nibble
	mov Data, Temp			    ; restore Data
	andi Data, 0b00001111	  ; mask out low nibble
	or Data, RS				      ; add register select

write_nibble:
	rcall switch_output		 ; Modify for display JHD202A, port E
	nop						         ; wait 542nS
	sbi PORTD, 5			     ; enable high, JHD202A
	nop
	nop						         ; wait 542nS
	cbi PORTD, 5			     ; enable low, JHD202A
	nop
	nop						         ; wait 542nS
	ret

; **
; ** busy_wait loop
; **
short_wait:
	clr zh					       ; approx 50 us
	ldi zl, 255
	rjmp wait_loop
long_wait:
	ldi zh, HIGH(16000)		; approx 2 ms
	ldi zl, LOW(16000)
	rjmp wait_loop
dbnc_wait:
	ldi zh, HIGH(65536)		; approx 10 ms
	ldi zl, LOW(65536)
	rjmp wait_loop
power_up_wait:
	ldi zh, HIGH(65536)		; approx 20 ms
	ldi zl, LOW(65536)

wait_loop:
	sbiw z, 1				      ; 2 cycles
	brne wait_loop			  ; 2 cycles
	ret

; **
; ** modify output signal to fit LCD JHD202A, connected to port E
; **

switch_output:
	push Temp
	clr Temp
	sbrc Data, 0				     ; D4 = 1?
	ori Temp, 0b00000100		 ; Set pin 2
	sbrc Data, 1				     ; D5 = 1?
	ori Temp, 0b00001000		 ; Set pin 3
	sbrc Data, 2				     ; D6 = 1?
	ori Temp, 0b00000001		 ; Set pin 0
	sbrc Data, 3				     ; D7 = 1?
	ori Temp, 0b00000010		 ; Set pin 1
	sbrc Data, 4				     ; E = 1?
	ori Temp, 0b00100000		 ; Set pin 5
	sbrc Data, 5				     ; RS = 1?
	ori Temp, 0b10000000		 ; Set pin 7 (wrong in previous version)
	out PORTD, Temp
	pop Temp
	ret


delay:

    ldi  r25, 41
    ldi  r26, 150
    ldi  r27, 128
L1: dec  r27
    brne L1
    dec  r26
    brne L1
    dec  r25
    brne L1
ret
