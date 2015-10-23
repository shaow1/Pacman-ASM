TITLE Lab 6,InClassProblem2, Mallory Harper, 10/26/2015					(main.asm)

INCLUDE Irvine32.inc
.data

	hellothere db "Hello there!",0
	AgainString db "Want to go again? ",0
	lowerY db 121
	upperY db 89

.code
main PROC

	call stringInput

main ENDP
	
	
stringInput proc
begin:
		mov edx, offset hellothere
		call writestring
		call crlf
		mov edx, offset againString
		call writestring
		call readchar
		call crlf
		cmp al, upperY
		je begin
		cmp al, lowerY
		je begin
		exit
stringInput endp

END main