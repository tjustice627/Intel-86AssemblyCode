; add two numbers

.model small		; defining the size of the listing
.stack 100h			; optional - defining the stack size in bytes
.data				; defines where variables are in memory
	prompt1 db 10,13,"Enter a number: ","$" ;create a variable
	prompt2 db 10,13,"Enter another number: ","$" ;create another variable
	result db 10,13,"The sum is: ","$"
	number1 db ?
	number2 db ?
	char db ?
	tens db ?
	ones db ?

.code				; identifies the beginning of code
	include macros.asm
	
	mov ax,@data			; load ax register with the address of data segment
	mov ds,ax				; load ds register with the address stored in ax
	scrClear				; macro call to clear screen
	scrColor 02h			; macro call to screen color macro
	printStr prompt1		; macro call sending prompt1
	readChar number1		; macro call sending number1
	printStr prompt2		; macro call sending prompt2
	readChar number2		; macro call sending number2
	printStr result			; macro call sending result
	
	;decision structure
	mov al,number1
	mov bl,number2
	add al,bl
	cmp al,10		; compare sum to 10 decimal
	jl L2			; jump to L2 if sum is less than 10
	xor ah,ah		; clears ah
	mov bl,10		; load low order byte of bx with immediate value 10
	div bl			; al ah = al / bl (10)
	mov tens,al		; load quotient into tens
	mov ones,ah		; load remainder into ones
	writeChar tens	; macro call sending tens
	writeChar ones	; macro call sending ones	
	jmp L1
	
	L2:	mov char,al		; load low order byte of bx with value stored in al
		writeChar char	; macro call sending char

	L1:	mov ah,4ch		; load the high order byte ax register with 4c hex
		int 21h
end