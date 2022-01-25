;AL5 - Travis Justice
;Using 3 internal procedures
;1) Read five values into an array
;2) Write the contents of the array
;3) Find the largest value in the array

.model small ;small supports one data segment and one code segment
.stack 100h	 ;used to push and pop registers/store return address when subroutine called
.data ;creates near data segment for frequently used data
	intro db 10,13,'Enter five values into an array.',10,13,10,13,'$'
	prompt db 'Enter a value: ','$' 
	replyA db 10,13,'The array is: ','$'
	replyB db 10,13,'The largest value in the array is: ','$'
	comma db ', $'
	newline db 10,13,'$'
	highVal dw ?
	data dw 5 dup (?)
	color  db 02h ;set value to black (0) background and green (2) foreground
	index dw ?	;used to specify the current working index
.code 			;start of assembly code segment
	extrn indec: proc
	extrn outdec: proc
	include macros.asm

main proc
	mov ax,@data ;mov address of data segment to ax register
	mov ds,ax ;set ds to ax
	scrClear				; clear screen
	scrColor color			; color screen
	printStr intro			; print intro string
	call getInput			; call getInput procedure
	printStr replyA			; print replyA string
	call pArray				; call pArray procedure
	printStr replyB			; print replyB string
	call findHigh			; call findHigh procedure
	call outdec				; call outdec procedure
	printStr newline		; print newline string
	mov ah,4ch				; send control back to DOS
	int 21h
main endp
	
getInput proc
	mov cx,0		; count control var
L1:					; L1: start count-controlled loop
	push ax
	printStr prompt	; prints prompt for user to enter a value
	pop ax
	call indec		; calls procedure for multi-character value to be entered (stores to ax!)
	mov index,cx
	mov bx,index
	mov [data+bx],ax	; load value into array
	add cx,2			; increment count control reg
	cmp cx,10		; compares count control register to 5
	jl L1			; if less than 5 iterations have occurred, reiterate loop
exitL1:
	ret
getInput endp

pArray proc
	xor bx,bx		; clears bx register
	lea si,data
L2:					; start loop through array values
	mov ax,[si+bx]
	call outdec
	push ax
	printStr comma
	pop ax
	add bx,2		; adds 2 to bx so that the next value can be read from the array
	cmp bx,10		; compare bx to 10 (the full array is 10 bytes)
	jl L2			; if array has values remaining, reiterate loop
	ret
pArray endp

findHigh proc
	lea si,data
	xor bx,bx		; clears bx register
	xor ax,ax		; clears ax register
	mov highVal,bx	; moves value from bx to highVal
L3:					; findHigh loop
	mov ax,[si+bx]	; move current 
	cmp ax,highVal	; compare ax register to current high value
	jg replace		; if greater, jump to replace
	add bx,2		; add 2 to bx register
	cmp bx,10		; compare bx to 10
	jl L3			; if less, reiterate loop
	jmp exitL3		; jump unconditionally to exit otherwise
replace:			; replace directive
	mov highVal,ax	; move current value to high value location
	jmp L3			; jump back to findHigh loop
exitL3:				; exit loop directive
	mov ax,highVal	; move high value to ax register
	ret				; return from procedure
findHigh endp
end main ; end of assembly code segment