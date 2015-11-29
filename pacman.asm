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
	buffer BYTE BUFFER_SIZE DUP(?)
	filename  BYTE "FinalBoardGame.txt",0
	directionfile BYTE "DirectionFile.txt", 0
	scoreString  BYTE "Score: ",0
	levelString  BYTE "Level: ",0
	wincaption  BYTE "WINNER!",0
	winnermsg  BYTE "Congrats! You have beaten all 6 levels. You are Pac Man Camp.",0
	fileHandle HANDLE ?

	nextTick dd 0
	lengthOfFrame dd 200
	lastKeyPressed dw 19712

	x byte 1
	y byte 1
	intendedX byte 2
	intendedY byte 1

	MessBoxTitle db "Level Complete",0
	MessBox db "Level Complete: Do you wish to continute?",0 

	MessBoxTitle1 db "Fail",0
	MessBox1 db "You have fallen in a hole! Do you wish to restart?",0 

	Welcome db "Welcome To the Best Pac Man Game Ever!", 0
	CreatedBy db "Created By: Mallory Harper, Chris Chevalier, Greg Shao",0
	NextStep db "Begin Playing (1) or Need Directions (2)? ", 0
	directionContinue db "Now that you read the directions would you like to play? Yes (1) or No (2)?: ",0
	invalidnumber db "Invalid Number, Please enter either 1 or 2", 0

	score dd 0
	level dd 1
	yvalue db 20
	xvalue db 25
	inputnumber dd 0
	directionumber dd 0
	fuckyou dd 0
	

;---------------------------------------------------------------------------
;Main Game Logic & Loop

.code

main PROC
	call splashscreen

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

	;ret
gameLoop endp
;-------------------------------------------------------------------------------------------
;Splash Screen
splashscreen PROC


	mov edx, 0
	mov dh, yvalue
	mov dl, xvalue
	call Gotoxy
	mov edx, offset Welcome
	mov eax,lightGreen
	call SetTextColor
	call WriteString

	call crlf
	inc yvalue
	mov dh, yvalue
	mov dl,15
	call Gotoxy
	mov edx, offset CreatedBy
	mov eax,magenta
	call SetTextColor
	call WriteString

	call crlf
	inc yvalue
	mov dh, yvalue
	mov dl,23
	call Gotoxy
	mov edx, offset NextStep
	mov eax,cyan
	call SetTextColor
	call WriteString
	call Readint
	mov inputnumber, eax

	mov eax, 15 ;changes color back to normal
	call SetTextColor

	cmp inputnumber, 1
	je beginplaying
	cmp inputnumber, 2
	je directions
	jmp invalidnum

	beginplaying:
		call clrscr
		call LoadGameBoardFile
		call drawscreen
		call gameLoop
		call crlf
		ret

	directions:
		call clrscr
		call printdirections

		mov edx, offset directionContinue
		call WriteString
		call Readint
		mov directionumber, eax

		cmp directionumber, 1
		je beginplaying
		cmp directionumber, 2
		je quitgame
		jmp invalidnum


		quitgame:
			exit
		ret

	invalidnum:
		call clrscr
		mov dh, 19
		mov dl, 24
		call Gotoxy
		mov edx, offset invalidnumber
		call WriteString
		call splashscreen
		call crlf

		ret

splashscreen ENDP

printdirections PROC
	
	mov edx, Offset directionfile
	call openinputfile
	mov filehandle, eax
	mov edx, offset buffer
	mov ecx, buffer_size
	call ReadFromFile
	mov buffer[eax],0
	mov edx, offset buffer
	call writestring
	call crlf
	mov eax, filehandle
	call closefile


ret
printdirections ENDP

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
	je hole

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
		call nextlevel

		call movePacMan
		jmp endof
	wall:
		jmp endof
	hole:
		jmp endGame
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
	endgame:
		INVOKE MessageBox, NULL, ADDR Messbox1,
		ADDR MessBoxTitle1, MB_YESNO + MB_ICONQUESTION
		cmp eax,IDYES
		je restartgame
		jmp endgamecompletely
	endgamecompletely:
		exit

	restartgame:
		mov score,0 ;puts score back at zero for the beginning level
		mov level, 1

		
		call clrscr
		call LoadGameBoardFile
		call drawscreen
		call updateScore
	
		jmp somewhere

	endof:
		ret
		

	somewhere:
		

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
	mov dh, 25
	call gotoxy
	mov edx, offset scoreString
	call WriteString
	mov eax, score
	call writedec
	mov dl, 0
	mov dh, 24
	call gotoxy
	mov edx, offset levelString
	call WriteString
	mov eax, level
	call writedec
	cmp eax, 7
	je levelscomplete
	ret

	levelscomplete:
		mov ebx,OFFSET wincaption
		mov edx,OFFSET winnermsg
		call MsgBox
		exit
		

updateScore endp

nextlevel Proc

;cmp score, 21300
cmp score, 600
je printmessage
jmp somewhere

printmessage:
	INVOKE MessageBox, NULL, ADDR Messbox,
	ADDR MessBoxTitle, MB_YESNO + MB_ICONQUESTION
	cmp eax,IDYES
	je increaselevel
	jmp somewhere

increaselevel:
	mov score,0 ;puts score back at zero for the next level
	inc level

	call clrscr	
	call LoadGameBoardFile
	call drawscreen
	call gameLoop
	call updateScore

somewhere:
	ret


nextlevel ENDP

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
