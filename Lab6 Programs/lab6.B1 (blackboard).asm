TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
	n	dd	10

.code
main PROC
	call Clrscr
	mov esi, 0

	call forLoop
	call writeint
	exit
main ENDP

oddEven proc uses ebx
	;eax: value checking
	mov ebx, 0
	mov bl, 0001b
	and eax, ebx
	ret ;returns 1 if odd, 0 if even. Can use conJmp with result.
oddEven endp

forLoop proc
	;n is where loop ends
	;esi is where loop starts
	;using ebx for sum
	;returns sum in eax register
	mov ebx, 0

	forStart:
		cmp n, esi
		jle forEnd

		;body of for-loop
			mov eax, esi
			call oddEven
			cmp eax, 0
			jne odd
			add ebx, esi
			odd:
		;endOf body of for-loop

		inc esi
		jmp forStart
	forEnd:
	mov eax, ebx
	ret
forLoop endp

END main