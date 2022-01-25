; read and echo character

.model small 		; defining the size of the listing
.stack 100h			; optional - defining a stack size in bytes
.data				; defines where variables are in memory
	prompt db 10,13,"Enter a value: ","$" ; create a variable 
	reply db 10,13,10,13,"Result: ","$" ; create a variable 
	char db ?
	tens db ?
	ones db ?
	value dw ?
	
.code				; identifies the beginning of code
	include myMacros.asm
	proc main
	extrn indec: proc ; link to external procedure indec
	extrn outdec: proc ; link to external procedure outdec
	;house keeping
	mov ax,@data	; load ax register with the address of data segment
	mov ds,ax		; load ds register with the address stored in ax
	scrClear 		; macro call to screen clear macro
	scrColor 1eh	; macro call to screen color macro
	prtStr prompt	; macro call sending prompt 
	call indec		; calling indec procedure - return to the ax register the multi-digit value read from keyboard 
	mov value,ax
	;readCh char		; macro call sending char
	prtStr reply	; macro call sending reply
	mov ax,value
	mov bx,2		; load low order byte of bx with immediate value 2
	mul bx			; ax = ax * bl
	call outdec 	; calling outdec procedure - write the multi-digit value stored in the ax register to screen
	
L1:	mov ah,4ch		; load the high order byte ax register with 4c hex (DOS to return control)
	int 21h
endp
end main



