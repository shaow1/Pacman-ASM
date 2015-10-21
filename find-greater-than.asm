TITLE Lab#, Pgm name, authors(s), date						(main.asm)

INCLUDE Irvine32.inc
.data
aInput BYTE "Enter value for a: ", 0
bInput BYTE "Enter value for b: ", 0
cInput BYTE "Enter value for c: ", 0
aLargest BYTE "a is the largest value", 0
bLargest BYTE "b is the largest value", 0
cLargest BYTE "c is the largest value", 0
avalue dd 0
bvalue dd 0
cvalue dd 0


.code
main PROC

call InputValues
call FindGreatest



	exit
main ENDP

InputValues PROC
mov edx, offset aInput
call WriteString
call ReadInt
mov avalue, eax
mov edx, offset bInput
call WriteString
call ReadInt
mov bvalue, eax
mov edx, offset cInput
call WriteString
call ReadInt
mov cvalue, eax
call crlf

ret
InputValues ENDP


FindGreatest PROC
mov eax, avalue
cmp eax, bvalue
mov eax, avalue
cmp eax, cvalue
jge aisgreater  ;if true jump here, therefore a is greatest

mov eax, bvalue
cmp eax, cvalue
jge bisgreater ;if b>=c jump here, therefore b is greatest
jle cisgreater; if b<=c jump here, therefore c is greatest
jmp somewhere

aisgreater:
	mov edx, offset aLargest
	call WriteString
	jmp somewhere
bisgreater:
	mov edx, offset bLargest
	call WriteString
	jmp somewhere
cisgreater:
	mov edx, offset cLargest
	call WriteString
	jmp somewhere

somewhere:
	call crlf
	


ret
FindGreatest ENDP

END main