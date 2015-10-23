TITLE Lab6, InClassCode1, Mallory Harper, 10/26/15						(main.asm)

INCLUDE Irvine32.inc
.data
input BYTE "Enter a value: ", 0
inputval dd 0
i dd 0



.code
main PROC

call InputValues
call Printoutput



	exit
main ENDP

InputValues PROC
mov edx, offset input
call WriteString
call ReadInt
mov inputval, eax
call crlf

ret
InputValues ENDP


Printoutput PROC
numbersPrint:
cmp i, eax
jg somewhere
jle printval  ;if input in is greater than i, jump here

printval:
	mov eax, i
	call writeint
	call crlf
	inc i
	mov eax, inputval
loop numbersPrint

somewhere:
	call crlf
	exit
	
ret
Printoutput ENDP

END main