TITLE Lab6, Truth Table, Mallory Harper, 10/26                 	(main.asm)

INCLUDE Irvine32.inc 

.data
  header db " x | y | z | table",0
  tablestring db "------------------",0
  divide db "  | ",0
  x db 0
  y db 0
  z db 0

  outp db ?
.code
  
main PROC
  call Start
  exit
main ENDP

start PROC
  mov eax, 0
  mov edx, offset header
  call WriteString
  call crlf
  mov edx, offset tablestring
  call WriteString
  call crlf
  mov ecx, 8

 truthtableLoop:
   call truthTable   
   inc z
   mov al, 2
   cmp al, Z
   jg cont   
   changey:
     mov z, 0
	 inc y
     mov al, 2
     cmp al, y
	 jg cont
   changex:
     mov y, 0
	 inc x
   cont:
  
  loop truthtableLoop
  ret
start ENDP  

truthTable PROC uses ecx
  mov al, x
  mov bl, y
  mov cl, z
  mov dl, 0
  not cl
  or bl, cl
  and al, bl
  mov outp, al
  call output
  ret
truthTable ENDP

output PROC
  movzx eax, x
  call writeint 
  mov eax, " "
  call writechar
  movzx eax, y
  call writeint 
  mov eax, " "
  call writechar
  movzx eax, z
  call writeint 
  mov edx, offset divide
  call WriteString
  movzx eax, outp
  call writeint
  call crlf
  ret
output ENDP

END main