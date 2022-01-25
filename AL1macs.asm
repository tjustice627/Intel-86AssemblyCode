	;macros for AL1
	
	;string write macro
	printStr macro string
		mov dx,offset string	; load dx register with first byte of msg
		mov ah,09h				; load the high order byte ax register with 09 hex (DOS string write service)
		int 21h					; DOS API interrupt vector
	endm
	
	;read an ascii character macro
	readNum macro x
		mov ah,01h				; load the high order byte ax register with 01 hex (DOS read keyboard service)
		int 21h
		and al,0fh				; convert ascii to decimal
		mov x,al				; return value to address x
	endm
	
	;write character macro
	writeChar macro y
		or y,30h		; convert deci to ascii
		mov dl,y
		mov ah,02h		; load high order byte ax register with 02 hex (DOS character write service)
		int 21h
	endm