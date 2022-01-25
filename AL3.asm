; AL3 - Travis Justice
; loop and change screen color

.model small
.stack 100h
.data
	intro db "Enter a value: ","$"		; displays intro/instructions to the user
	count db 10,13,"Count: ","$"		; displays the current iteration of the loop
	val dw ?							; stores user input var
.code
	extrn indec: proc
	extrn outdec: proc
	include macros.asm
	
	main proc
		mov ax,@data
		mov ds,ax
		scrClear			; clears screen
		scrColor 02h		; colors screen with black background and green foreground
		printStr intro		; prints intro string
		call indec			; calls ext indec procedure
		mov val,ax			; moves the input value to a variable for storage
		mov cx,0			; set count control to 0
	L1:						; start loop
		printStr count		; print count string
		inc cx				; increment count control register
		mov ax,cx			; mov count control to ax
		call outdec			; call ext outdec procedure to print ax
		mov ax,cx			; mov count control to ax
		cmp ax,val			; compare input value from user to current count control value
		jl L1				; if less, reiterate loop
		mov ah,4ch			; return control to DOS
		int 21h
	endp
end main