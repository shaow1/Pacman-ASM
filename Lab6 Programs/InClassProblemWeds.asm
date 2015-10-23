TITLE Lab6, InClassCodeWeds, Mallory Harper, 10/26/15						(main.asm)

INCLUDE Irvine32.inc
.data
input BYTE "Enter positive numbers for an array: ", 0
inputPositive BYTE "Last number entered was negative, Please enter positive numbers for an array: ", 0
findmaxormin BYTE "Would you like to find the Maximum (M) or Minimum (m): ", 0
maxString BYTE "Max Value: ", 0
minString BYTE "Min Value: ", 0
doitagainString BYTE "Would you like to do this again?: (Y/N) ", 0
array1 dd 10 dup(?)
zero dd 0-
maxmininput db 0
max dd 77
min dd 109
firstarrayval dd 0
Ycap dd 89
Ylower dd 121
doitagainval db 0


.code
main PROC
call startvalues
call InputValues
call FindMaxorMinInput
call doitagain



	exit
main ENDP

StartValues PROC
mov eax, 0
mov ecx, 10
mov esi, 0
ret
StartValues ENDP

InputValues PROC
loop1:
mov edx, offset input
call WriteString
call ReadInt
call CheckPositiveNum
mov array1[esi], eax
add esi, 4
call crlf
loop loop1
ret
InputValues ENDP

CheckPositiveNum PROC

cmp eax, zero
jl isNegative
jmp somewhere

isNegative:
 mov edx, offset inputPositive
call WriteString
call ReadInt
mov array1[esi], eax
inc esi

somewhere:
	call crlf

ret
CheckPositiveNum ENDP


FindMaxorMinInput PROC
mov edx, offset findmaxormin
call WriteString
call ReadChar
mov maxmininput, al
call CalcMaxorMin

ret
FindMaxorMinInput ENDP

CalcMaxorMin PROC
movzx eax, maxmininput
call crlf
cmp max, eax
je FindMaximum
jne FindMinimum

FindMaximum:
mov eax, 0
mov ecx, 10
mov edi, 0

mov eax, array1[edi]
add edi,4

loop2:
	mov ebx, eax
	cmp ebx, array1[edi]
	jle setNewMax
	jmp keepmax
setNewMax:
	mov eax, array1[edi]

keepmax:
	add edi, 4
loop loop2

mov edx, offset MaxString
call WriteString
call writeint
jmp outside


FindMinimum:
mov ecx, 9
mov edi, 0

mov eax, array1[edi]
add edi,4


loop3:
	mov ebx, eax
	cmp ebx,array1[edi]
	jge setNewLower
	jmp keepLower
setNewLower:
	mov eax, array1[edi]
keepLower:
	add edi, 4
loop loop3

mov edx, offset MinString
call WriteString
call writeint
jmp outside

outside:
	call crlf

ret
CalcMaxorMin ENDP


doitagain PROC
mov edx, offset doitagainstring
call WriteString
call crlf
call ReadChar
mov doitagainval, al
cmp Ycap, eax
movzx eax, doitagainval
cmp Ylower, eax
je again
jmp somewhere

again:
	call startvalues
	call InputValues
	call FindMaxorMinInput
	call doitagain

somewhere:
	call crlf


ret
doitagain ENDP

END main