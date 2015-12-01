TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
INCLUDE macros.inc

INCLUDE macros.inc
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB Winmm.lib

NULL                                 equ 0
SND_ASYNC                            equ 1h
SND_FILENAME                         equ 20000h

PlaySound PROTO STDCALL :DWORD,:DWORD,:DWORD
ExitProcess PROTO STDCALL :DWORD


;---------------------------------------------------------------------------

BUFFER_SIZE = (30*24)
boardWidth = 30

upKey = 18432
rightKey = 19712
downKey = 20480
leftKey = 19200

maxScore = 21400

.data
	;sound
		introfile db "pacman_beginning",0
		SoundFile db "pacman_death",0 
		chompFile db "pacman_chomp",0 

	;gameboard
		boardgame BYTE BUFFER_SIZE DUP(?)
		buffer BYTE BUFFER_SIZE DUP(?)
		filename  BYTE "FinalBoardGame.txt",0
		fileHandle HANDLE ?
	
	;game strings
		scoreString  BYTE "Score: ",0
		levelString  BYTE "Level: ",0
		wincaption  BYTE "WINNER!",0
		winnermsg  BYTE "Congrats! You have beaten all 6 levels. You are Pac Man Camp.",0

		MessBoxTitle db "Level Complete",0
		MessBox db "Level Complete: Do you wish to continute?",0 

		MessBoxTitle1 db "Fail",0
		MessBox1 db "You have fallen in a hole! Do you wish to restart?", 0 
	
	;game variables
		nextTick dd 0
		lengthOfFrame dd 250
		lastKeyPressed dw 19712
		score dd 0
		level dd 1

	;charachter variable
		x byte 1
		y byte 1
		intendedX byte 2
		intendedY byte 1

	;monster variable
		mX byte 14
		mY byte 11
		mIntendedX byte 14
		mIntendedY byte 10
		mDirection dw 0

	;splashScreen Variables
		buffer1 BYTE BUFFER_SIZE DUP(?)
		directionfile BYTE "DirectionFile.txt", 0
		splashfile BYTE "asciipacmanart.txt",0

		Welcome db "Welcome To the Best Pac Man Game Ever!", 0
		CreatedBy db "Created By: Mallory Harper, Chris Chevalier, Greg Shao",0
		NextStep db "Begin Playing (1) or Need Directions (2)? ", 0
		directionContinue db "Now that you read the directions would you like to play? Yes (1) or No (2)?: ",0
		invalidnumber db "Invalid Number, Please enter either 1 or 2", 0

		yvalue db 20
		xvalue db 25
		inputnumber dd 0
		directionumber dd 0

;---------------------------------------------------------------------------
;Main Game Logic & Loop

.code

main PROC
	call randomize
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
		call ghostUpdate
		call checkScore

		keyboardLoop:
			call getKeyStroke

			call getMSeconds	
			cmp eax, nextTick	;if length of frame has passed jump to frame start

			jle keyboardLoop	;start loop again if framelength hasnt passed

			jmp frameStart		;if length of frame has passed jump to frame start
		;end of keyboardLoop

	;ret
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
;Generate Random Holes
generateholes PROC
	
	mov ecx, level

	multipleholes:

		mov eax, 22
		Call RandomRange
		mov dl, al
		
		mov eax, 28
		Call RandomRange
		mov ah,dl 

		mov bl, 'O'
		push ecx
		Call writetoarray
		pop ecx
	loop multipleholes
	ret
generateholes ENDP

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
		ret
	dot:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray

		mov eax, score
		add eax, 100
		mov score, eax
		call updateScore
		invoke PlaySound, ADDR chompFile, NULL, SND_FILENAME or SND_ASYNC
		call movePacMan
		ret
	wall:
		ret
	hole:
		call endGame
		ret
	leftTunnel:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray
		mov intendedX, 26
		mov intendedY, 11
		call movePacMan
		ret
	rightTunnel:
		mov al, x
		mov ah, y
		mov bl, ' '
		call writeToArray
		mov intendedX, 1
		mov intendedY, 11
		call movePacMan
		ret
	
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
;Game States***

checkScore proc
	cmp score, maxScore
	je levelComplete
	ret

	levelComplete:
		;print message asking user if they want to move to next level
		INVOKE MessageBox, NULL, ADDR Messbox,
		ADDR MessBoxTitle, MB_YESNO + MB_ICONQUESTION
		cmp eax, IDYES
		je increaselevel	;increase level if they say yes
		;otherwise exit
		call resetBoard
		call splashScreen
		mov lengthOfFrame, 250
	ret

	increaselevel:
		call newLevel
	ret

checkScore endp

newLevel PROC
	;check if last level
	mov eax, level
	cmp eax, 7
	je levelscomplete
	jmp nextLevel


	levelscomplete:	;if youv complete all levels
		mov ebx,OFFSET wincaption
		mov edx,OFFSET winnermsg
		call MsgBox
		
	ret

	nextLevel:
		mov score,0 ;puts score back at zero for the next level
		inc level
		mov eax, 50
		sub lengthOfFrame, eax
		call resetBoard
	ret

newLevel ENDP

endGame PROC
	invoke PlaySound, ADDR SoundFile, NULL, SND_FILENAME or SND_ASYNC
	INVOKE MessageBox, NULL, ADDR Messbox1,
	ADDR MessBoxTitle1, MB_YESNO + MB_ICONQUESTION
	cmp eax, IDYES
	jnz startScreen
	restartGamee:
		call restartGame
		jmp endOf
	startScreen:
		call resetBoard
		call splashScreen
		mov lengthOfFrame, 250
	endOf:
	ret
endGame ENDP

restartGame PROC
	mov score, 0 ;puts score back at zero for the beginning level
	mov level, 1
	call resetBoard
	ret
restartGame endp

resetBoard PROC
	mov score, 0
	mov x, 1
	mov y, 1
	mov intendedX, 2
	mov intendedY, 1
	mov lastKeyPressed, 19712

	call clrscr
	call LoadGameBoardFile
	call drawscreen
	call updateScore

	mov dl, x
	mov dh, y
	mov al, "@"
	call writeToScreen	;draw pacman

	ret
resetBoard endp

;---------------------------------------------------------------------------
;Ghost Logic

ghostUpdate PROC
	;check for free direction recurrsivly
	
	mov cl, mX
	mov ch, mY

	mov ax, mDirection

	mov bx, 0
	cmp bx, ax
	jz up

	mov bx, 1
	cmp bx, ax
	jz right
	
	mov bx, 2
	cmp bx, ax
	jz down

	mov bx, 3
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

	mov  mIntendedX, cl
	mov  mIntendedY, ch

	mov al, cl
	mov ah, ch
	call readarray	;reads array to determine material of next intended position. Returns char in al

	mov bl, ' '
	cmp al, bl
	jz free

	mov bl, '.'
	cmp al, bl
	jz free

	mov bl, '@'
	cmp al, bl
	jz pacman

	jmp wall	;else not free wall

	free:
		call moveGhost
		ret
	wall:
		mov eax, 4
		Call RandomRange
		mov mDirection, ax

		call ghostUpdate
		ret
	pacman:
		call endGame
ghostUpdate endp

moveGhost PROC
		mov dl, mX
		mov dh, mY

		call writeToScreen	;clear last position ghost

		mov dl, mIntendedX
		mov dh, mIntendedY
		mov al, "O"
		call writeToScreen	;draw ghost

		mov mX, dl	;update cordinates
		mov mY, dh
	ret
moveGhost endp

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
	;score
	mov dl, 0
	mov dh, 25
	call gotoxy
	mov edx, offset scoreString
	call WriteString
	mov eax, score
	call writedec

	;level
	mov dl, 0
	mov dh, 24
	call gotoxy
	mov edx, offset levelString
	call WriteString
	mov eax, level
	call writedec

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

;-------------------------------------------------------------------------------------------
;Splash Screen
splashscreen PROC

	call clrscr

	mov edx, 0
	mov dh, 15
	call Gotoxy
	mov edx, Offset splashfile
	call openinputfile
	mov filehandle, eax
	mov edx, offset buffer1
	mov ecx, buffer_size
	call ReadFromFile
	mov buffer1[eax],0
	mov edx, offset buffer1
	mov eax,lightblue
	call SetTextColor
	call writestring
	call crlf
	mov eax, filehandle
	call closefile

	mov edx, 0
	mov dh, 23
	call Gotoxy
	mov edx, Offset splashfile
	call openinputfile
	mov filehandle, eax
	mov edx, offset buffer1
	mov ecx, buffer_size
	call ReadFromFile
	mov buffer1[eax],0
	mov edx, offset buffer1
	mov eax,lightblue
	call SetTextColor
	call writestring
	call crlf
	mov eax, filehandle
	call closefile


	mov edx, 0
	mov dh, yvalue
	mov dl, xvalue
	call Gotoxy
	mov edx, offset Welcome
	mov eax,lightGreen
	call SetTextColor
	call WriteString

	call crlf
	mov dh, 21
	mov dl,15
	call Gotoxy
	mov edx, offset CreatedBy
	mov eax,magenta
	call SetTextColor
	call WriteString

	call crlf
	mov dh, 22
	mov dl,23
	call Gotoxy
	mov edx, offset NextStep
	mov eax,cyan
	call SetTextColor
	call WriteString
	invoke PlaySound, ADDR introFile, NULL, SND_FILENAME or SND_ASYNC
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

END main
