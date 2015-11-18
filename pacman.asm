TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
INCLUDE macros.inc

;---------------------------------------------------------------------------

BUFFER_SIZE = (30*24)
boardWidth = 30

upKey = 18432
rightKey = 19712
downKey = 20480
leftKey = 19200

.data
	boardgame BYTE BUFFER_SIZE DUP(?)
	filename  BYTE "FinalBoardGame.txt",0
	fileHandle HANDLE ?

	nextTick dd 0
	lengthOfFrame dd 200
	lastKeyPressed dw 19712

	x byte 1
	y byte 1
	intendedX byte 2
	intendedY byte 1

	score dd 0

;---------------------------------------------------------------------------
;Main Game Logic & Loop

.code

main PROC
	call LoadGameBoardFile
	call drawscreen
	call gameLoop
	call crlf
	exit
main ENDP

gameLoop proc
	frameStart:
		call getMSeconds
		add eax, lengthOfFrame	;add length of frame to current time
		mov nextTick, eax

		call handleKey
		call moveCharacter

		keyboardLoop:
			call getKeyStroke

			call getMSeconds	
			cmp eax, nextTick	;if length of frame has passed jump to frame start

			jle keyboardLoop	;start loop again if framelength hasnt passed

			jmp frameStart		;if length of frame has passed jump to frame start
		;end of keyboardLoop

	ret
gameLoop endp

;---------------------------------------------------------------------------
;User Input

getKeyStroke proc
	call readKey
	jz noKeyPress	;dont store anything if no key was pressed (readkey returns 0 if no key pressed)
		mov lastKeyPressed, ax	;key pressed, store value in variable
	noKeyPress:
	ret
getKeyStroke endp

handleKey proc
	mov eax, 0
	mov ax, lastKeyPressed	;takes last keypress

	mov cl, x
	mov ch, y

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
	cmp bx, ax
	jz left

	up:
		dec ch
		jmp endOf

	right:
		inc cl
		jmp endOf

	down:
		inc ch
		jmp endOf

	left:
		dec cl
		jmp endOf

	endOf:

	mov intendedX, cl
	mov intendedY, ch

	ret
handleKey endp

;---------------------------------------------------------------------------
;Move Pacman Around

moveCharacter proc
	;takes intended next position in intendedX, intendedY
	mov eax, 0

	mov al, intendedX
	mov ah, intendedY

	mov bx, 0b00h	;left tunnel pos in hex
	cmp ax, bx
	jz leftTunnel

	mov bx, 0b1ah	;left tunnel pos in hex
	cmp ax, bx
	jz rightTunnel

	call readarray	;reads array to determine material of next intended position. Returns char in al

	;mov bx, 0b1bh	;right tunnel
	;cmp ax, bx
	;jz leftTunnel

	mov bl, ' '
	cmp al, bl
	jz free

	mov bl, '.'
	cmp al, bl
	jz dot
	
	mov bl, '#'
	cmp al, bl
	jz wall

	mov bl, 'O'
	cmp al, bl
	jz hole

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

		mov eax, score
		add eax, 100
		mov score, eax
		call updateScore

		call movePacMan
		jmp endof
	wall:
		jmp endof
	hole:
		;endGame
		jmp endof
	leftTunnel:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray
		mov intendedX, 26
		mov intendedY, 11
		call movePacMan
		jmp endof
	rightTunnel:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray
		mov intendedX, 1
		mov intendedY, 11
		call movePacMan
		jmp endof
	endof:
	ret
moveCharacter endp

movePacMan proc
	;move pacmans x and y to intended x and y
	mov dl, intendedX
	mov dh, intendedY
	mov al, "@"
	call writeToScreen	;draw pacman

	mov dl, x
	mov dh, y
	mov al, " "
	call writeToScreen	;clear last position pacman

	mov al, intendedX
	mov ah, intendedY
	mov x, al
	mov y, ah

	;update array with his char
	mov al, x
	mov ah, y
	mov bl, '@'
	call writeToArray

	ret
movePacMan endp

writeToScreen proc
	;dl x, dh y
	; al char
	call gotoxy
	call writeChar
	ret
writeToScreen endp

;---------------------------------------------------------------------------
;Gameboard Loading, Displaying & Score

LoadGameBoardFile PROC
	mov edx, Offset filename
	call openinputfile
	mov filehandle, eax
	mov edx, offset boardgame
	mov ecx, buffer_size
	call ReadFromFile
	mov boardgame[eax],0

	mov eax, filehandle
	call closefile

	ret
LoadGameBoardFile ENDP

drawScreen proc
	mov edi,0
	mov ecx, lengthof boardgame

	printcharacters:
		mov bl, boardgame[edi]
		cmp bl, "#"
		je changecolor
		jmp somewhere

		changecolor:
			mov eax, 10
			call SetTextColor
			mov al,bl
			call writechar
			jmp keepgoing
		somewhere:
			mov eax, 15
			call SetTextColor
			mov al, boardgame[edi]
			call writechar
		keepgoing:
	inc edi
	loop printcharacters
	call updateScore
drawScreen endp

updateScore proc
	mov dl, 0
	mov dh, 24
	call gotoxy
	mov eax, score
	call writeInt
	ret
updateScore endp

;---------------------------------------------------------------------------
;Gameboard Array Procedures

readArray proc
	;al: x, ah: y
	;returns value in al
	mov esi, offset boardGame
	mov ecx, eax
	mov eax, 0	;use ax to store position
	;determine position
		mov al, boardWidth
		mul ch
		;cx = boardwidth * y
		mov ch, 0	;make cx equal to cl only
		add ax, cx	;add the x to the sum. Ax is now the offset from the begining of the array
	add esi, eax; add the offset off the array to its position in the array
	mov al, [esi]
	ret
readArray endp

writeToArray proc
	;al: x, ah: y
	;bl char
	mov esi, offset boardGame
	mov ecx, eax
	mov eax, 0	;use ax to store position
	;determine position
		mov al, boardWidth
		mul ch
		;cx = boardwidth * y
		mov ch, 0	;make cx equal to cl only
		add ax, cx	;add the x to the sum. Ax is now the offset from the begining of the array
	add esi, eax; add the offset off the array to its position in the array
	mov [esi], bl
	ret
writeToArray endp

;---------------------------------------------------------------------------

END main
