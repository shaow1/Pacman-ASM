TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
	array dd 20 dup(?)
	n dd 20
	j dd 10
	k dd 1000

.code
main PROC
	call Clrscr
	call Randomize

	call fillArray
	call printDoublesArray

	exit
main ENDP

fillArray proc uses esi ecx ebx
	;pass pointer to aray in eax
	mov esi, offset array
	mov ecx, n

	loopFill:
		mov eax, k
		mov ebx, j
		call betterRandomRange
		mov [esi], eax
		add esi, type array
	loop loopFill
	ret
fillArray endp

printDoublesArray proc
	mov eax, 0
	mov ecx, lengthof array
	mov esi, 0
	printloop:
		mov eax, array[esi]
		call writeint
		call crlf
		add esi, 4
	loop printloop
printDoublesArray endp

BetterRandomRange proc
	;ebx lowerbound
	;eax upperBound
	;returns random in eax
	sub eax, ebx
	call randomRange
	add eax, ebx
	ret
BetterRandomRange endp

END main