; read and echo character

.model small		; defining the size of the listing
.stack 100h			; optional - defining the stack size in bytes
.data				; defines where variables are in memory
	prompt db 10,13,"Enter a character: ","$" ;create a variable
	reply db 10,13,10,13,"Result: ","$" ;create a variable
	char db ?
	tens db ?
	ones db ?
	
.code				; identifies the beginning of code
	include macros.asm
	
	;house keeping
	mov ax,@data	; load ax register with the address of data segment
	mov ds, ax		; load ds register with the address stored in ax
	printStr prompt	; macro call sending prompt
	readChar char	; macro call sending char
	printStr reply 	; macro call sending reply
	mov bl,2		; load low order byte of bx with immediate value 2
	mul bl 			; al = al * bl
	
	;decision structure
	cmp al,10		; compare al to 10 decimal
	jl L2			; jump to L2 if al is less than 10
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