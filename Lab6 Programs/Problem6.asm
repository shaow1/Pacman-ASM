TITLE Lab6,Boolean Calc (2), Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	inputString db "Pick from the following: 1. x AND y 2. x OR y 3. NOT x 4.x XOR y 5. Exit Program ",0
	xyand db "x AND y",0
	xyor db "x OR y",0
	notx db " NOT x",0
	xyxor db "x XOR y",0
	exitprog db "Exit Program",0
	num1 db "Enter a number: ",0
	num2 db "Enter another number: ",0
	inputnum dd 0
	num1val dd 0
	num2val dd 0


.code
main PROC
	call inputValues
	call operatorStatus
	
exit
main ENDP

inputValues PROC
	mov edx, offset inputString
	call writestring
	call readint
	mov inputnum, eax

ret
inputValues ENDP

operatorStatus PROC

mov eax, inputnum
cmp eax, 1
je input1
mov eax, inputnum
cmp eax, 2
je input2
mov eax, inputnum
cmp eax, 3
je input3
mov eax, inputnum
cmp eax, 4
je input4
mov eax, inputnum
cmp eax, 5
je inputexit
jmp somewhere

input1:
	mov edx, offset xyand
	call writestring
	call Addition
	jmp somewhere
input2:
	mov edx, offset xyor
	call writestring
	call OrProc
	jmp somewhere
input3:
	mov edx, offset notx
	call writestring
	call NotProg
	jmp somewhere
input4:
	mov edx, offset xyxor
	call writestring
	call XorProg
	jmp somewhere
inputexit:
	mov edx, offset exitprog
	call writestring
	jmp somewhere
somewhere:
	call crlf


ret
operatorStatus ENDP

Addition PROC
call crlf
	mov edx, offset num1
	call writestring
	call Readint
	mov num1val, eax
	mov edx, offset num2
	call writestring
	call Readint
	mov num2val, eax
	and eax, num1val
	call writeint

ret
Addition ENDP

orProc PROC
call crlf
	mov edx, offset num1
	call writestring
	call Readint
	mov num1val, eax
	mov edx, offset num2
	call writestring
	call Readint
	mov num2val, eax
	or eax, num1val
	call writeint

ret
orProc ENDP

Notprog PROC
call crlf
	mov edx, offset num1
	call writestring
	call Readint
	mov num1val, eax
	not eax
	call writeint

ret
NotProg ENDP

XorProg PROC
call crlf
	mov edx, offset num1
	call writestring
	call Readint
	mov num1val, eax
	mov edx, offset num2
	call writestring
	call Readint
	mov num2val, eax
	xor eax, num1val
	call writeint

ret
XorProg ENDP

END main