; read and echo character

.model small 		; defining the size of the listing
.stack 100h			; optional - defining a stack size in bytes
.data				; defines where variables are in memory
	set1 dw 8 dup (?)	; created blank 8-element array with 16-bit addresses
	set2 dw 5,10,15,20,25,30,35,40,45,50
	comma db ',$'
	newline db 10,13,'$'
.code				; identifies the beginning of code
	include macros.asm
	proc main
	extrn indec: proc ; link to external procedure indec
	extrn outdec: proc ; link to external procedure outdec
	;house keeping
	mov ax,@data	; load ax register with the address of data segment
	mov ds,ax		; load ds register with the address stored in ax
	scrClear 		; macro call to screen clear macro
	scrColor 02h	; macro call to screen color macro

	xor bx,bx
	lea si,set2
L1:	
	mov ax,[si+bx]
	call outdec 	; calling outdec procedure - write the multi-digit value stored in the ax register to screen
	printStr comma
	add bx,2
	cmp bx,20
	jl L1
	
	
	mov ah,4ch		; load the high order byte ax register with 4c hex (DOS to return control)
	int 21h
endp
end main