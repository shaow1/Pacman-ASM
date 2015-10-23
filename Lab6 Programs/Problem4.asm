TITLE Lab6,College Registration, Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	regString db "The Student can Register ",0
	NonregString db "The Student cannot Register ",0
	creditString db "Enter Number of Credits (1-30): ",0
	gradeString db "Enter Grade (0-400): ",0
	creditnum dd 0
	gradenum dd 0


.code
main PROC
	call inputValues
	call RegistrationStatus
	
exit
main ENDP

inputValues PROC
creditstart:
	mov edx, offset creditString
	call writestring
	call readint
	cmp eax, 0
	jle creditstart
	cmp eax, 30
	jg creditstart
	mov creditnum, eax
	call crlf

	gradestart:
	mov edx, offset gradeString
	call writestring
	call readint
	cmp eax, 0
	jl gradestart
	cmp eax, 400
	jg gradestart
	mov gradenum, eax
	call crlf	

ret
inputValues ENDP

registrationStatus PROC

mov eax, gradenum
cmp eax, 300
jg canregister
mov eax, gradenum
cmp eax, 250
jg checkcredits 


canregister:
mov edx, offset regString
call WriteString
jmp somewhere

checkcredits:
mov eax, creditnum
cmp eax, 16
jle canregister
mov eax, creditnum
cmp eax, 12
jle canregister
jmp cannotregister

cannotregister:
mov edx, offset nonregString
call WriteString
jmp somewhere

somewhere:
call crlf



ret
registrationStatus ENDP

END main