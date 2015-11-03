TITLE Lab 6, String- Procedures, Mallory Harper, 10/26       	(main.asm)

INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000 

.data
buffer BYTE BUFFER_SIZE DUP(?)
filename  BYTE "truegameboard.txt",0
fileHandle HANDLE ?



.code
 
main PROC

call GameBoardFile




mov edx, Offset filename
call openinputfile
mov filehandle, eax

cmp eax, INVALID_HANDLE_VALUE
jne file_ok
mWrite <"Cannot open file", 0dh,0ah>
jmp quit

file_ok:
mov edx, offset buffer
mov ecx, buffer_size
call ReadFromFile
jnc check_buffer_size
mwrite "Error reading file"
jmp close_file

check_buffer_size:
cmp eax, BUFFER_size
jb buf_size_ok
mwrite <"Error: Buffer too small for the file", 0dh,0ah>
jmp quit

buf_size_ok:
mov buffer[eax],0
mov edx, offset buffer
call writestring


close_file:
mov eax, filehandle
call closefile

quit:
exit



 
main ENDP

GameBoardFile PROC

ret
GameBoardFile ENDP



END main 