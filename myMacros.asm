
	;----macros begin------
	
	;BIOS screen clear macro
	cls macro 
		mov ax,2 ;load into ax not just ah, really loads 0ah 2al
		int 10h ;BIOS interrupt
	endm
	
	;BIOS change screen color macro
	scrColor macro color
		mov ah,6h ;6=bios scroll up operation
		mov al,0 ;0 always clears the screen
		mov bh,color ;moves the color value (2 digit hex) into the color slot
		mov cx,0 ;zeroes both bytes high/low (top row, left column)
		mov dx,184fh ;sets to 184f hex with is 24 and 79 in decimal. This covers the default size of the dosbox window
		int 10h ;BIOS Interrupt
	endm
	
	;ASCII String write macros
	prtStr macro x
		lea dx,x ;set dx to adwress of string x
		mov ah,9h ;set high byte of ax register to 9 (DOS String Write Operation)
		int 21h ;DOS interrupt
	endm

	;read ASCII character macro
	readChar macro y
		mov ah,1h ;set high byte of ax 1 (DOS ASCII read operation)
		int 21h ;DOS interrupt
		and al,0fh ;strip ascii to create decimal
		mov y,al
	endm	
	
	;ASCII character write macro
	writeChar macro z
		mov al,z
		mov bl,30h ;set low byte of bx to mask 30h (0011 0000)
		or al,bl ;padwing from dec to ASCII
		mov dl,al ;set low byte of dx to ASCII character stored in value
		mov ah,2h ;set high byte of ax to 2 (DOS ASCII character write operation)
		int 21h ;DOS interrupt
	endm
	
	;exit macro
	exit macro
		mov ah,4ch ;set high byte of ax to 4c (DOS exit operation)
		int 21h ;DOS interrupt
	endm
	
	sound macro noteFreq, noteLength
	local .pause1, .pause2, .notespace1, .notespace2
		mov al, 182 ;prepares speaker, load value 182
		out 43h,al ;in and out are instructions, out writes to a port, in reads from it. loading 182 into 43h(turns speaker on)
		mov ax, noteFreq ;load the note frequency
		
		out 42h,al ;write note frequency to speaker
		mov al,ah ;get the other part of the frequency stored in the high order
		out 42h,al ;write that too
		in al,61h  ;turn it on
		
		or al, 00000011b ;1 and 0 of port 61h in order to play must be 1 so make them 1
		out 61h,al ;write that or'd value
		mov bx, noteLength ;load bx with duration of note
	.pause1:
		mov cx,65535 ;set cx to maximum value
	.pause2:
		dec cx ;decrease cx
		jnz .pause2 ;until it is 0
		dec bx ;decrease bx
		jnz .pause1 ;until it is 0
		in al,61h ;turns off the note
		

		
		and al, 11111100b ;re-mask from the or
		out 61h,al
		
		mov bx, 1 ;creates space for notes to breathe
	.notespace1: 
		mov cx,65535
	.notespace2:
		dec cx
		jnz .notespace2
		dec bx
		jnz .notespace1		
	endm
	
	resting macro noteLength ;macro for rests
	local .notespace1, .notespace2
		mov bx, noteLength ;determines time
	.notespace1: 
		mov cx,65535 
	.notespace2:
		dec cx 
		jnz .notespace2
		dec bx ;decreased bx until matches cx, i think
		jnz .notespace1	
	endm
	
	LostWoods macro
		sound f4 eighth
		sound a4 eighth
		sound b4 quarter
		
		sound f4 eighth
		sound a4 eighth
		sound b4 quarter
		
		sound f4 eighth
		sound a4 eighth
		sound b4 eighth
		sound e5 eighth
		
		sound d5 quarter
		sound b4 eighth
		sound c5 eighth
		
		sound b4 eighth
		sound g4 eighth
		sound e4 half
		
		resting quarter
		sound d4 eighth
		
		sound e4 eighth
		sound g4 eighth
		sound e4 dottedH
		
		sound f4 eighth
		sound a4 eighth
		sound b4 quarter
		
		sound f4 eighth
		sound a4 eighth
		sound b4 quarter
		
		sound f4 eighth
		sound a4 eighth
		sound b4 eighth
		sound e5 eighth
		
		sound d5 quarter
		sound b4 eighth
		sound c5 eighth
		
		sound e5 eighth
		sound b4 eighth
		sound g4 half
		
		resting quarter
		sound b4 quarter
		
		sound g4 eighth
		sound d4 eighth
		sound e4 half
	endm
	
	SongOfStorms macro
		sound d4 eighth
		sound f4 eighth
		sound d5 half
		
		sound d4 eighth
		sound f4 eighth
		sound d5 half
		
		sound e5 dottedQ
		sound f5 eighth
		sound e5 eighth
		sound f5 eighth
		
		sound e5 eighth
		sound c5 eighth
		sound a4 half
		
		sound a4 quarter
		sound d4 quarter
		sound f4 eighth
		sound g4 eighth
		
		sound a4 dottedH

		sound a4 quarter
		sound d4 quarter
		sound f4 eighth
		sound g4 eighth
		
		sound e4 dottedH
	endm
	
	Mario macro
		sound e5 eighth
		sound e5 eighth
		resting eighth
		sound e5 eighth
		resting eighth
		sound c5 eighth
		sound e5 quarter
		
		sound g5 quarter
		resting quarter
		sound g4 quarter
		resting quarter
		
		sound c5 quarter
		resting eighth
		sound g4 quarter
		resting eighth
		sound e4 quarter
		
		resting eighth
		sound a4 quarter
		sound b4 quarter
		sound a4sharp eighth
		sound a4 quarter
		
		sound g4 5 ;this is a 1-off triplet... could build code for triplet support if needed, math is total beat allotment/3, then rmdr round up on 2 and down 1
		sound e5 5
		sound g5 5
		sound a5 quarter
		sound f5 eighth
		sound g5 eighth
		
		resting eighth
		sound e5 quarter
		sound c5 eighth
		sound d5 eighth
		sound b4 quarter
		resting eighth
		
		resting quarter
		sound g5 eighth
		sound f5sharp eighth
		sound f5 eighth
		sound d5sharp quarter
		sound e5 eighth
		
		;death transition
		sound c5 sixteenth
		sound c5sharp sixteenth
		sound d5 eighth
		resting quarter
		
		sound b4 eighth
		sound f5 eighth
		resting eighth
		sound f5 eighth
		
		sound f5 6 ;mario triplets
		sound e5 6
		sound d5 6
		
		sound c5 eighth
		sound e4 eighth
		sound g3 eighth
		sound e4 eighth
		
		sound c4 eighth
		
	endm
	;----macros end -------