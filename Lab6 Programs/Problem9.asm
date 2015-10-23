TITLE Lab6,Validating a Pin, Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	array1 db 20 dup(?)
	string1 db "Enter First Num: ",0
	string2 db "Enter 2nd Num: ",0
	string3 db "Enter 3rd Num: ",0
	string4 db "Enter 4th Num: ",0
	string5 db "Enter 5th Num: ",0
	validString db "Valid",0
	invalidString db "Invalid ",0
	num1 dd 0
	num2 dd 0
	num3 dd 0
	num4 dd 0
	num5 dd 0

.code
main PROC
	call inputnum
	call validatepin


	
exit
main ENDP

inputnum PROC
	mov edx, offset string1
	call writestring
	call readint
	mov num1, eax
	mov edx, offset string2
	call writestring
	call readint
	mov num2, eax
	mov edx, offset string3
	call writestring
	call readint
	mov num3, eax
	mov edx, offset string4
	call writestring
	call readint
	mov num4, eax
	mov edx, offset string5
	call writestring
	call readint
	mov num5, eax

ret
inputnum ENDP

validatepin PROC

mov eax, num1
cmp eax, 5
jge checknum1
jl invalid
mov eax, num2
cmp eax, 2
jge checknum2
jl invalid
mov eax, num3
cmp eax, 4
jge checknum3
jl invalid
mov eax, num4
cmp eax, 1
jge checknum4
jl invalid
mov eax, num5
cmp eax, 3
jge checknum5
jl invalid

checknum1:
	mov eax, num1
	cmp eax, 9
	jle valid
	jg invalid
	jmp somewhere
checknum2:
	mov eax, num2
	cmp eax, 5
	jle valid
	jg invalid
	jmp somewhere
checknum3:
	mov eax, num3
	cmp eax, 8
	jle valid
	jg invalid
	jmp somewhere
checknum4:
	mov eax, num4
	cmp eax, 4
	jle valid
	jg invalid
	jmp somewhere
checknum5:
	mov eax, num5
	cmp eax, 6
	jle valid
	jg invalid
	jmp somewhere

invalid:
	mov edx, offset invalidString
	call writestring
	jmp somewhere

valid:
	mov edx, offset validString
	call writestring

somewhere:
	call crlf


ret
validatepin ENDP





END main