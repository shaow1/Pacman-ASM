TITLE Lab 6, Encryption Message, Mallory Harper, 10/26/2015

INCLUDE Irvine32.inc 

.data
  key db "ABXmv#7"
  MESSAGE db "Regular Message",0

  encryptstring db "Encrypted Message: ",0
  decryptstring db "Decrypted Message: ",0
.code
  
main PROC
  call begin
  exit
main ENDP


begin PROC
  mov edx, OFFSET encryptstring
  call WriteString
  call crlf
  call encrypt
  call output
  mov edx, OFFSET decryptstring
  call WriteString
  call crlf
  call encrypt
  call output
  ret
begin ENDP


encrypt PROC
  mov ecx, lengthOf MESSAGE
  mov esi, 0
  mov edi, 0
  mov eax, 0

  encryptloop:
    mov al, message[esi]  
	XOR al, key[edi]
	mov message[esi], al

	inc esi
	inc edi

    mov eax, lengthOf KEY
    cmp eax, edi
    jne skip

    mov edi, 0

    skip:

  loop encryptloop

  ret
encrypt ENDP


output PROC
  mov ecx, lengthOf message
  mov esi, 0

  outputval:
    mov al, message[esi]
	call writechar
	inc esi
  Loop outputval

  call crlf

  ret
output ENDP

END main