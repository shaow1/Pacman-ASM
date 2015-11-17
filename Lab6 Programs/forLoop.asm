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

	;n is where loop starts
	;esi is where loop ends

	forStart:
		mov eax, esi
		call writeint
		cmp n, esi
		jle forEnd
		inc esi
		jmp forStart
	forEnd:

	exit
main ENDP

END main