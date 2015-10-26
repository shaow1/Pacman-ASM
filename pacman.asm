TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
	nextTick dd 0
	lengthOfFrame dd 250
	lastKeyPressed dw 19712
	upKey word 18432
	rightKey word 19712
	downKey word 20480
	leftKey word 19200

	x byte 0
	y byte 0

.code

main PROC
	call Clrscr
	call gameLoop
	call crlf
	exit
main ENDP

gameLoop proc
	frameStart:
		call getMSeconds
		add eax, lengthOfFrame; add length of frame to current time
		mov nextTick, eax
		

		call handleKey

		keyboardLoop:
			;Get Keyboard Strokes
			call readKey; reads keyboard
			jz noKeyPress; dont store anything if no key was pressed
			mov lastKeyPressed, ax; key pressed store value
			noKeyPress:

			;if length of frame has passed jump to frame start
			call getMSeconds
			cmp eax, nextTick
			jle keyboardLoop; start loop again if framelength hasnt passed
			jmp frameStart; if length of frame has passed jump to frame start
		;end of keyboardLoop

	ret
gameLoop endp

handleKey proc
	;takes last keypress
	mov eax, 0
	mov ax, lastKeyPressed

	mov bx, upkey
	cmp bx, ax
	jz up

	mov bx, rightkey
	cmp bx, ax
	jz right
	
	mov bx, downKey
	cmp bx, ax
	jz down

	mov bx, leftKey
	cmp leftKey, ax
	jz left

	jmp endOf

	up:
		mov eax, 1
		dec y
		jmp endOf

	right:
		mov eax, 2
		inc x
		jmp endOf

	down:
		mov eax, 3
		inc y
		jmp endOf

	left:
		mov eax, 4
		dec x
		jmp endOf

	endOf:

	;Location of game logic
		call Clrscr

		mov dh, y
		mov dl, x
		call gotoXY

		mov al, "#"
		call writeChar
	;yea

	ret
handleKey endp

END main