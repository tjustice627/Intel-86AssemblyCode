;AL4 - Travis Justice

.model small
.stack 100h
.data
	intro1 db 'Enter up to 9 values to be added together.',10,13,'$'
	intro2 db 'Enter a 0 to exit collection at any time.',10,13,'$'
	intro3 db '------------------------------------------',10,13,'$'
	prompt1 db 10,13,'Enter Value ','$'
	prompt2 db ': ','$'
	result db 10,13,'Sum Equals: ','$'
	newline db 10,13,'$'
	count db ?
	val db ?
.code
	extrn indec: proc
	extrn outdec: proc
	include macros.asm
	
	main proc

	mov ax,@data		; mov address of data segment to ax register
	mov ds,ax			; set ds to address stored in ax

	scrClear			; macro call to clear screen macro
	scrColor 02h		; macro call to screen color macro
	
	printStr intro1		; print header
	printStr intro2
	printStr intro3
	mov cl,0			; initialize loop control variable count to zero
	xor bx,bx           ; intialize bx(summation)to zero
	push 0              ; push 0 (sentinel value) on to the stack to mark bottom of stack
collect:                    ; collect: label for start of collection loop
		inc cl			; increment loop control register
		printStr prompt1    ; print prompt1
		mov count,cl			; load cx with count storage variable
		writeChar count      	; print count variable
		printStr prompt2    ; print colon symbol
		call indec			; calls ext indec procedure
		cmp ax,0     	    ; compare value read to zero
		je sum				; jump if equal to sum label
		push ax             ; push ax on to stack
		cmp cl,9            ; compare cx to 9
		jl collect        ; jump if less than 9 back to start of collection loop
sum:                	; sum: label for start of summation loop
		pop dx              ; pop value from stack to dx
		cmp dx,0            ; compare dx to 0 (sentinel value)
		je exit             ; jump if equal to exit label 
		add bx,dx           ; add dx to summation stored in bx
		jmp sum             ; unconditional jump to sum label
exit:	                ; exit: label for start of exit code
		printStr result     ; print result string
		mov ax,bx           ; set ax to summation value (bx)
		call outdec			; calls outdec procedure
		mov ah,4ch			; load high order byte with 4c hex (terminate program/return to dos)
		int 21h				; interrupt to dos
main endp
end main		; end of assembly code segment