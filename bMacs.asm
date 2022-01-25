	;BIOS screen clear operation macro
	cls macro 
		mov ax,2 ;setting ax register to 2 (BIOS clear screen operation)
		int 10h ;BIOS interruptv
	endm
	
	;BIOS operation to change screen color macro
	scrColor macro color 
		mov ah,6h ;set high byte of ax register to 6(BIOS scroll up operation)
		mov al,0 ;set low byte of ax register to 0 (BIOS default to scroll entire screen)
		mov bh,color ;set high byte of the bx register to two digit hex value stored in color
		mov cx,0 ;seet cx to 0 (ch set to 0 which means the left row; c; set to 0 which means left column)
		mov dx,184fh ;set dx register to 184fh (setting dh to 24 in decimal for rows, setting dl to decimal 79 for columns)
		int 10h ;DOS interrupt
	endm
	
	
	; ASCII String Write macro
	prtStr macro x
		lea dx,x ;set dx to address of string x
		mov ah,9h ;set high byte of ax register to 9 (DOS String Write Operation) essentially saying size = 9
		int 21h ;DOS interrupt
	endm
	
	;read ASCII character macro
	readChar macro y
		mov ah,2h ;set high byte of ax 1(DOS ASCII read operation) essentially saying size = 1
		int 21h ; DOS interrupt
		and al,0fh ;strip ASCII to create decimal
		mov y,al
	
	endm
	
	;read single char macro
	readChar2 macro x
		mov ah, 01h
		int 21h
		mov x,al
	endm
	;ASCII character write macro
	writeChar macro z
		mov al,z
		mov bl,30h ;set low byte of bx to mask 30h (0011 0000)
		or al,bl ;padding from decimal to ASCII 
		mov dl,al ;set value to the ASCII character read
		mov ah,2h ; set high byte of ax register to 2 (DOS ASCII character write operation)
		int 21h ;DOS interrupt
	endm
	
	;random number generator macro (0-9)
	random10 macro rVal 
	   mov ah,0h  	 ; interrupts to get system time        
	   int 1ah       ; CX:DX now hold number of clock ticks since midnight      
	   mov ax,dx
	   xor dx,dx
	   mov cx,9   
	   div cx       ; here dx contains the remainder of the division - from 0 to 9
	   mov rVal,dl	 ; call interrupt to display a value in DL
	endm 
	
	;random number macro (1-6)
	random6 macro rVal
	   mov ah,0h  	 ; interrupts to get system time        
	   int 1ah       ; CX:DX now hold number of clock ticks since midnight      
	   mov ax,dx
	   xor dx,dx
	   mov cx,6    
	   div cx       ; here dx contains the remainder of the division - from 0 to 9
	   add dx,1
	   mov rVal,dl	 ; call interrupt to display a value in DL
	endm

	;exit macro
	exit macro
		mov ah,4ch ;set high byte of ax to 4c (DOS exit operation)
		int 21h ;DOS interrupt
	endm