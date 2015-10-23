TITLE Lab6,Probabilies and Colors, Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	array1 db 20 dup(?)
	string1 db "This is a string",0

.code
main PROC
	call randomize
	call findrandomnums
	call SetTextColorLine

	
exit
main ENDP

findRandomNums PROC
mov eax,0
mov ecx, 20
mov esi, 0
multiple:
	mov eax, 9
	call randomrange
	mov array1[esi], al
	inc esi
loop multiple

ret
findRandomNums ENDP

SetTextColorLine PROC
mov ecx, 20
mov esi, 0

color:

	mov al, array1[esi]
	cmp al, 2
	jle setWhite
	mov al, array1[esi]
	cmp al, 3
	je setBlue
	jmp setgreen

setWhite:
	mov eax, white
	jmp somewhere

setGreen:
	mov eax, green
	jmp somewhere

setBlue:
	mov eax, blue

somewhere:
	call settextcolor
	mov edx, offset String1
	call writestring
	call crlf
	inc esi
loop color



ret
SetTextColorLine ENDP



END main