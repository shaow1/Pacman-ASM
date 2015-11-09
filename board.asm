TITLE Lab 6, String- Procedures, Mallory Harper, 10/26       	(main.asm)

INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000 

.data
buffer BYTE BUFFER_SIZE DUP(?)
filename  BYTE "FinalBoardGame.txt",0
fileHandle HANDLE ?



.code
 
main PROC

call GameBoardFile

exit
 
main ENDP

GameBoardFile PROC

mov edx, Offset filename
call openinputfile
mov filehandle, eax
mov edx, offset buffer
mov ecx, buffer_size
call ReadFromFile
mov buffer[eax],0
mov edx, offset buffer
call writestring
mov eax, filehandle
call closefile


ret
GameBoardFile ENDP



END main 