TITLE Lab6,Boolean Calc (1), Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	inputString db "Pick from the following: 1. x AND y 2. x OR y 3. NOT x 4.x XOR y 5. Exit Program ",0
	xyand db "x AND y",0
	xyor db "x OR y",0
	notx db " NOT x",0
	xyxor db "x XOR y",0
	exitprog db "Exit Program",0
	inputnum dd 0


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
	jmp somewhere
input2:
	mov edx, offset xyor
	call writestring
	jmp somewhere
input3:
	mov edx, offset notx
	call writestring
	jmp somewhere
input4:
	mov edx, offset xyxor
	call writestring
	jmp somewhere
inputexit:
	mov edx, offset exitprog
	call writestring
	jmp somewhere
somewhere:
	call crlf



ret
operatorStatus ENDP

END main