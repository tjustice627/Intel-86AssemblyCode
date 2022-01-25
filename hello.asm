; hello world

.model small        ; defines size of listing
.stack 100h         ; optional - defines a stack size in bytes. By default, stack will reserve 1000 bytes.
.data				; defines where variables are in memory
	prompt db 10,13,"Hello World!","$"	; creates a string variable "prompt"
	reply db 10, 13,10,13, "Result", "$" ; creates a variable "reply"
	char db ?
	
.code				; identifies the beginning of the code
	;house keeping
	mov ax,@data	; load ax register with the address of data segment
	mov ds,ax		; load ds register with the address stored in ax
	; string write
	mov dx,offset prompt	; load dx register with first byte of prompt
	mov ah,09h		; loads high order byte of ax register with 09 hex (DOS string write service
	int 21h			; DOS API interrupt vector
	; read a character
	mov ah,01h		; load the high order byte ax register with 01 hex (DOS read keyboard service)
	int 21h
	mov char,al
	; convert to data type
	; string write
	mov dx,offset prompt	; load dx register with first byte of prompt
	mov ah,09h		; loads high order byte of ax register with 02 hex (DOS string write service
	int 21h			; DOS API interrupt vector
	; char write
	mov dl,char
	mov ah,02h
	int 21h

	mov ah,4ch		; load the high order byte ax register with 4c hex (DOS to return control)
	int 21h
end