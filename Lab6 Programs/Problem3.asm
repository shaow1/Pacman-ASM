TITLE Lab6,Test Score Evaluation, Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	gradeString db "Your grade is: ",0
	array1 db 10 dup(?)
	letterA db "A",0
	letterB db "B",0
	letterC db "C",0
	letterD db "D",0
	letterF db "F",0


.code
main PROC
	call randomize
	call findRandomNums
	call findLetterGrade
exit
main ENDP
	
	

findRandomNums PROC
mov eax,0
mov ecx, 10
mov esi, 0
multiple:
	mov eax, 100
	sub eax, 50
	call randomrange
	add eax, 50
	call writeint
	mov array1[esi], al
	inc esi
	call crlf
loop multiple

ret
findRandomNums ENDP

FindLetterGrade PROC
mov ecx, 10
mov esi, 0

arrayloop:
	mov bl, array1[esi]
	cmp bl, 59
	jle gradeF
	mov bl, array1[esi]
	cmp bl, 69
	jle graded
	mov bl, array1[esi]
	cmp bl, 79
	jle gradec
	mov bl, array1[esi]
	cmp bl, 89
	jle gradeb
	jmp gradea
	jmp somewhere
	call crlf

gradef:
	mov edx, offset gradeString
	call WriteString
	mov edx, offset letterf
	call WriteString
	call crlf
	jmp somewhere
graded:
	mov edx, offset gradeString
	call WriteString
	mov edx, offset letterd
	call WriteString
	call crlf
	jmp somewhere
gradec:
	mov edx, offset gradeString
	call WriteString
	mov edx, offset letterc
	call WriteString
	call crlf
	jmp somewhere
gradeb:
	mov edx, offset gradeString
	call WriteString
	mov edx, offset letterb
	call WriteString
	call crlf
	jmp somewhere
gradea:
	mov edx, offset gradeString
	call WriteString
	mov edx, offset lettera
	call WriteString
	call crlf
	jmp somewhere

somewhere:
	inc esi

dec ecx
jnz arrayloop

ret
FindLetterGrade ENDP

END main