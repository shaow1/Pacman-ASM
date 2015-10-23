TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data
	array dd 1,2,3,10, 101, 100
	j	dd	10
	k	dd	100

.code
main PROC
	call Clrscr

	mov esi, offset array
	mov ecx, lengthOf array

	call rangedSum
	call writeint

	call crlf
	exit
main ENDP

rangedSum proc
	;esi pointer to array
	;ecx length of array
	mov eax, 0

	sumLoop:
		mov ebx, [esi]

		cmp ebx, j
		jl notInRange
		
		cmp ebx, k
		jg notInRange

		;inRange
		add eax, ebx
	
		notInRange:
		add esi, 4

	loop sumLoop

	ret
rangedSum endp

END main