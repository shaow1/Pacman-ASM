TITLE Lab6, InClassCode2, Mallory Harper, 10/26/15						(main.asm)

INCLUDE Irvine32.inc
.data
input BYTE "Want To Continute? (Y/y): ", 0
response BYTE "Yay", 0
otherwise BYTE "You said no.", 0
inputval db 0
Ycap dd 89
Ylower dd 121



.code
main PROC

call InputValues
call Printoutput



	exit
main ENDP

InputValues PROC
mov eax, 0
mov edx, offset input
call WriteString
call ReadChar
mov inputval, al
call crlf

ret
InputValues ENDP


Printoutput PROC
loop1:
cmp Ycap, eax
movzx eax, inputval
cmp Ylower, eax
je printStatement
jne closeOutput
jmp somewhere

closeOutput:
	mov edx, offset otherwise
	call WriteString
	call crlf
	jmp somewhere


somewhere:
	call crlf
	exit

printStatement:
	mov edx, offset response
	call WriteString
	call crlf
	call InputValues

loop loop1	
ret
Printoutput ENDP

END main