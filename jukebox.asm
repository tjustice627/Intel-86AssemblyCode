;Play some music, man, Thanks to Randall Hyde and his book "Art of Assembly"
LOCALS ;enables @@ locals
.model small ;small supports one data segment and one code segment
.stack 100h	 ;used to push and pop registers/store return adwress when subroutine called
.386 ;this is required to extend the amount of bytes you can jump
.data ;creates near data segment for frequently used data
	prompt db 10,13,'Enter the number of the song you would like to hear (9 to exit): ','$' ; identifier prompt assigned string followed by null character
	song1 db 10,13, '1. Song of Storms','$'
	song2 db 10,13, '2. Lost Woods','$'
	song3 db 10,13, '3. Mario Theme','$'
	ManualMusic db 10,13, '8. Musical Keyboard','$'
	newline db 10,13,'$'
	choice db ?
	esctoexit db 10,13, 'Press Esc to stop playing music','$'
	color db 7ch ;setting color values, first digit is background, second is text
	
	;note frequencies
	c3 dw 9121
	c3sharp dw 8609
	d3 dw 8126
	d3sharp dw 7670
	e3 dw 7239
	f3 dw 6833
	f3sharp dw 6449
	g3 dw 6087
	g3sharp dw 5746
	a3 dw 5423
	a3sharp dw 5119
	b3 dw 4931
	c4 dw 4560 ;middle c
	c4sharp dw 4304
	d4 dw 4063 
	d4sharp dw 3834
	e4 dw 3619
	f4 dw 3416
	f4sharp dw 3224
	g4 dw 3043
	g4sharp dw 2873
	a4 dw 2711
	a4sharp dw 2559
	b4 dw 2415
	c5 dw 2280
	c5sharp dw 2151 
	d5 dw 2031 
	d5sharp dw 1917
	e5 dw 1809
	f5 dw 1715
	f5sharp dw 1612
	g5 dw 1521
	g5sharp dw 1436
	a5 dw 1355
	a5sharp dw 1292
	b5 dw 1207
	c6 dw 1140
	
	;note lengths
	sixteenth dw 2
	eighth dw 4
	quarter dw 8
	half dw 16
	whole dw 32
	dottedQ dw 12
	dottedH dw 24
	
	
.code ;start of assembly code segment
	include myMacros.asm ;go look at this
	;---testing---
	rtplayback proc
	;ax is used for read/write processes, bx is brought in as the note frequency and dl holds the value of the key press down, dh will be assigned as the key press up
		push ax
		push bx
		push cx
		push dx
		
		mov al,dl
		add al,80h ;always 80h from the keydown
		mov dh,al ;holds the key up value in dl
		
		
		mov al, 182 ;prepares speaker, load value 182
		out 43h,al ;in and out are instructions, out writes to a port, in reads from it. loading 182 into 43h(turns speaker on)
		mov ax, bx ;load the note frequency
		
		out 42h,al ;write note frequency to speaker
		mov al,ah ;get the other part of the frequency stored in the high order
		out 42h,al ;write that too
		
		
		
		in al,61h  ;turn it on
		
		or al, 00000011b ;1 and 0 of port 61h in order to play must be 1 so make them 1
		out 61h,al ;write that or'd value
		
	@@keyloop:
		in al,60h ;60h is the keyboard minicontroller port that reads key ups/downs
		cmp al,dh ;cmp to the key-up, for esc this is 81h, seems to correspond to negative values maybe?
		jne @@keyloop
	
		in al,61h ;turns off the note
		
		and al, 11111100b ;re-mask from the or
		out 61h,al
		 
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	endp
	
	Keyboard macro
	local L1,getout
	push ax
	push bx
	push cx
	push dx
	L1:
		in al,60h
		mov dl,al ;assigning key scan codes from keyboard
		cmp dl,1eh
		je c4play
		cmp dl,11h
		je c4sharpplay
		cmp dl,1fh
		je d4play
		cmp dl,12h
		je d4sharpplay
		cmp dl,20h
		je e4play
		cmp dl,21h
		je f4play
		cmp dl,14h
		je f4sharpplay
		cmp dl,22h
		je g4play
		cmp dl,15h
		je g4sharpplay
		cmp dl,23h
		je a4play
		cmp dl,16h
		je a4sharpplay
		cmp dl,24h
		je b4play
		cmp dl,25h
		je c5play
		
		cmp dl,2ch
		je c3play
		cmp dl,2dh
		je d3play
		cmp dl,2eh
		je e3play
		cmp dl,2fh
		je f3play
		cmp dl,30h
		je g3play
		cmp dl,31h
		je a3play
		cmp dl,32h
		je b3play
		
		cmp dl,1
		je getout
		jmp L1 ;stay in here until esc is pressed (1)


		c4play:
		mov bx,c4
		call rtplayback
		jmp L1
		
		c4sharpplay:
		mov bx,c4sharp
		call rtplayback
		jmp L1
		
		d4play:
		mov bx,d4
		call rtplayback
		jmp L1
		
		d4sharpplay:
		mov bx,d4sharp
		call rtplayback
		jmp L1
		
		e4play:
		mov bx,e4
		call rtplayback
		jmp L1
		
		f4play:
		mov bx,f4
		call rtplayback
		jmp L1
		
		f4sharpplay:
		mov bx,f4sharp
		call rtplayback
		jmp L1
		
		g4play:
		mov bx,g4
		call rtplayback
		jmp L1
		
		g4sharpplay:
		mov bx,g4sharp
		call rtplayback
		jmp L1
		
		a4play:
		mov bx,a4
		call rtplayback
		jmp L1
		
		a4sharpplay:
		mov bx,a4sharp
		call rtplayback
		jmp L1
		
		b4play:
		mov bx,b4
		call rtplayback
		jmp L1
		
		c5play:
		mov bx,c5
		call rtplayback
		jmp L1
		
		c3play:
		mov bx,c3
		call rtplayback  
		jmp L1
		
		d3play:
		mov bx,d3
		call rtplayback
		jmp L1
		
		e3play:
		mov bx,e3
		call rtplayback
		jmp L1
		
		f3play:
		mov bx,f3
		call rtplayback
		jmp L1
		
		g3play:
		mov bx,g3
		call rtplayback
		jmp L1
		
		a3play:
		mov bx,a3
		call rtplayback
		jmp L1
		
		b3play:
		mov bx,b3
		call rtplayback
		jmp L1
		
	getout:
		mov ah,0ch ;clears kb buffer
		mov al,0 
		int 21h
	pop dx
	pop cx
	pop bx
	pop ax
	endm
	
	readkb macro y ;reads keyboard micro controller before it's turned into ascii
		push ax
		in al,60h
		mov y,al
		pop ax
	endm
	;testing end
main proc
	mov ax,@data ;mov address of data segment to ax register
	mov ds,ax ;set ds to ax
	

	SongChoice:
	cls ;clear screen
	scrColor color ;set color
	prtStr song1
	prtStr song2
	prtStr song3
	prtStr ManualMusic
	prtStr prompt
	readChar choice

	cmp choice, 9
	je getout
	
	cmp choice, 8
	je LManualMusic
	
	cmp choice, 1
	je LSong1
	
	cmp choice, 2
	je LSong2
	
	cmp choice, 3
	je LSong3
	jmp getout
	
	LSong1:
	SongOfStorms
	jmp SongChoice
	
	LSong2:
	LostWoods
	jmp SongChoice
	
	LSong3:
	Mario
	jmp SongChoice

	LManualMusic:
	prtStr newline
	prtStr esctoexit
	prtStr newline
	keyboard
	jmp SongChoice
	getout:
	cls
endp
exit
end main