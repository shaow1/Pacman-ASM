TITLE Lab 6, Parity Checking, Mallory Harper, 10/26/2015

INCLUDE Irvine32.inc 

.data
Array1 db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 
;Array1 db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 
.code
  
main PROC
  call begin
  exit
main ENDP


begin PROC
  call sumArray
  XOR eax, 0
  jp parity
  jnp notparity

  parity:
    mov eax, 1
	jmp Done
  notParity:
    mov eax, 0
  Done:
  call Writeint
  call crlf
  ret
begin ENDP

sumArray PROC
  mov ecx, lengthOf Array1
  mov eax, 0
  mov esi, 0
  mov ebx, 0
  addarray:
    mov bl, Array1[esi]
    add eax, ebx
	inc esi
  loop addarray

  ret
sumArray ENDP

END main