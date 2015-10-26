TITLE Lab 6, String- Procedures, Mallory Harper, 10/26       	(main.asm)

INCLUDE Irvine32.inc 

.data
inputstring db "Enter a String: ",0
vowelstring db "The number of vowels = ",0
reversedstring db "The String reversed is",0
wordstring db "The total number of words = ",0
stringsize dd 0
vowelval dd 0
wordval dd 1
inputval db ?

.code
 
main PROC
  call StringInput
  exit
main ENDP

StringInput PROC
  mov edx, offset inputstring
  call WriteString

  mov esi, 0
  inputloop:
    call readChar
	call writeChar
	call vowelcount 
	
	mov bl, " " 
	cmp bl, al
	jne notNewWord
	  inc wordval
	notNewWord:

	mov inputval[esi], al 
	inc esi 
	inc stringsize
	cmp al, 13
  jne inputloop
  
  dec esi
  mov inputval[esi], 0
  mov al, inputval[0] 
  cmp al,  97

  jl IsCap
    mov al, inputval[0]
	sub al, 32 
    mov inputval[0], al 
  Iscap:
  
  call crlf
  call crlf

  mov eax, vowelVal
  mov edx, offset vowelstring

  call WriteString
  call WriteInt
  call crlf

  call ReverseString

  mov eax, wordval
  mov edx, offset wordstring

  call WriteString
  call WriteInt
  call crlf
  call crlf

  ret
StringInput ENDP

vowelcount PROC
  mov bl, "a"
  mov bh, "A"
  mov cl, "e"
  mov ch, "E"
  mov dl, "i"
  mov dh, "I"

  cmp bl, al
   je vowel
  cmp bh, al
   je vowel

  cmp cl, al
   je vowel
  cmp ch, al
   je vowel

  cmp dl, al
   je vowel
  cmp dh, al
   je vowel
  
  mov bl, "o"
  mov bh, "O"
  mov cl, "u"
  mov ch, "U"

  cmp bl, al
   je vowel
  cmp bh, al
   je vowel

  cmp cl, al
   je vowel
  cmp ch, al
   je vowel
   
  jmp notVowel
  vowel:
    inc vowelVal
  notVowel:
  ret
vowelcount ENDP

ReverseString PROC
  mov edx, offset reversedstring
  call WriteString

  mov ecx, stringsize

  reverse:
  mov al, inputval[ecx - 1]
  call writeChar
  loop  reverse

  call crlf
  ret
ReverseString ENDP

END main 