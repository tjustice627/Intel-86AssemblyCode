; read and echo character

.model small 		; defining the size of the listing
.stack 100h			; optional - defining a stack size in bytes
.data				; defines where variables are in memory
	prompt db 10,13,"Enter a character: ","$" ; create a variable 
	reply db 10,13,10,13,"Result: ","$" ; create a variable 
	char db ?
	
.code				; identifies the beginning of code
	;house keeping
	mov ax,@data	; load ax register with the address of data segment
	mov ds,ax		; load ds register with the address stored in ax
	;string write
	mov dx,offset prompt ; load dx register with first byte of msg
	mov ah,09h		; load the high order byte ax register with 09 hex (DOS string write service)
	int 21h			; DOS API interrupt vector
	;read a chacter
	mov ah,01h		; load the high order byte ax register with 01 hex (DOS read keyboard service)
	int 21h
	and al,0fh		; convert asci digit to decimal
	mov char,al
	add char,al
	;string write
	mov dx,offset reply ; load dx register with first byte of msg
	mov ah,09h		; load the high order byte ax register with 09 hex (DOS string write service)
	int 21h			; DOS API interrupt vector	
					;character write
	or char,30h		;convert decimal digit to ascii digit
	mov dl,char
	mov ah,02h		; load the high order byte ax register with 02 hex (DOS charcter write service)
	int 21h
	
	
	mov ah,4ch		; load the high order byte ax register with 4c hex (DOS to return control)
	int 21h
end
