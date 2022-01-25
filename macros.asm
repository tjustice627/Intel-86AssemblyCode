;macros - Travis Justice

;string write macro
printStr macro string
	mov dx,offset string	; load dx register with first byte of msg
	mov ah,09h				; load the high order byte ax register with 09 hex (DOS string write service)
	int 21h					; DOS API interrupt vector
endm

;read an ascii character macro
readChar macro x
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

;clear screen macro
scrClear macro
	mov ax,02h		; loading ax with 02 hex (clear screen service)
	int 10h			; interrupt to the BIOS
endm

;change screen colors macro
scrColor macro color
	mov ah,06h		; load high order byte of ax reg with 06 hex (scroll up service)
	mov al,0h		; load low order byte of ax reg with 0 hex (entire screen)
	mov cx,00h		; paint from row 0, column 0
	mov dx,184fh	; paint to row 24, column 79
	mov bh,color	; set color - background/text (1Eh - blue background, yellow text)
	int 10h			; interrupt to the BIOS
endm