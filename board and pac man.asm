TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
.data

	buffer BYTE BUFFER_SIZE DUP(?)
	filename  BYTE "FinalBoardGame.txt",0
	fileHandle HANDLE ?
	boardgame BYTE ?

	nextTick dd 0
	lengthOfFrame dd 250

	lastKeyPressed dw 19712

	upKey word 18432
	rightKey word 19712
	downKey word 20480
	leftKey word 19200

	x byte 0
	y byte 0

	score byte 0

	intendedX byte 0
	intendedY byte 0

	tempLevel byte "@                                                                                      ",0

.code

main PROC
	;call Clrscr
	call GameBoardFile
	call gameLoop
	call crlf
	exit
main ENDP

GameBoardFile PROC

mov edx, Offset filename
call openinputfile
mov filehandle, eax
mov edx, offset buffer
mov ecx, buffer_size
call ReadFromFile
mov buffer[eax],0
mov edx, offset buffer
call writestring
mov eax, filehandle
call closefile


ret
GameBoardFile ENDP


gameLoop proc
	frameStart:
		call getMSeconds
		add eax, lengthOfFrame	;add length of frame to current time
		mov nextTick, eax

		call handleKey
		call moveCharacter
		call drawscreen

		keyboardLoop:
			call getKeyStroke

			call getMSeconds	;if length of frame has passed jump to frame start
			cmp eax, nextTick
			jle keyboardLoop	;start loop again if framelength hasnt passed
			jmp frameStart		;if length of frame has passed jump to frame start
		;end of keyboardLoop

	ret
gameLoop endp

getKeyStroke proc
	call readKey
	jz noKeyPress	;dont store anything if no key was pressed
	mov lastKeyPressed, ax	;key pressed store value
	noKeyPress:

	ret
getKeyStroke endp

handleKey proc
	mov eax, 0
	mov ax, lastKeyPressed	;takes last keypress

	;determine what keys was pressed
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

	jmp endOf	;failsafe

	up:
		mov ah, y
		dec ah
		mov intendedY, ah
		jmp endOf

	right:
		mov ah, x
		inc ah
		mov intendedx, ah
		jmp endOf

	down:
		mov ah, y
		inc ah
		mov intendedY, ah
		jmp endOf

	left:
		mov ah, x
		dec ah
		mov intendedX, ah

	endOf:

	ret
handleKey endp

moveCharacter proc
	;takes intended next position in intendedX, intendedY

	mov eax, 0

	mov al, intendedX
	mov ah, intendedY
	call readarray	;reads array to determine material of next intended position. Returns char in al

	mov bl, ' '
	cmp al, bl
	jz free

	mov bl, '*'
	cmp al, bl
	jz dot
	
	mov bl, '#'
	cmp al, bl
	jz wall

	mov bl, 'O'
	cmp al, bl
	jz hole

	jmp endof

	free:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray

		call movePacMan

		jmp endof
	dot:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray

		mov al, score
		inc al
		mov score, al

		call movePacMan

		jmp endof
	wall:
		;nothing
		jmp endof
	hole:
		;endGame
		jmp endof

	endof:
	
	ret
moveCharacter endp

readArray proc
	;takes position in ax. al: x, ah: y
	;returns value in al
	mov esi, offset tempLevel

	mov ecx, 0
	mov cl, al
	add esi, ecx

	mov al, [esi]

	ret
readArray endp

writeToArray proc
	;ax position. al: x, ah: y
	;bl char
	mov esi, offset tempLevel

	mov ecx, 0
	mov cl, al
	add esi, ecx

	mov [esi], bl

	ret
writeToArray endp

movePacMan proc
	;move pacmans x and y to intended x and y
	mov al, intendedX
	mov ah, intendedY
	mov x, al
	mov y, ah

	;update array with his char
	mov al, x
	mov bl, '@'
	call writeToArray

	ret
movePacMan endp

drawScreen proc
	;draws screen
	;call Clrscr

	mov dh, 0
	mov dl, 0
	call gotoXY

	mov edx, offset tempLevel
	call writeString

	mov dh, y
	mov dl, x
	call gotoXY

	mov al, "@"
	;call writeChar

	ret
drawScreen endp

END main

;check