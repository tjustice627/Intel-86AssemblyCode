;AL3
;Loop & Screen color change
;Grant Finn

.model small		; defining the size of the listing
.stack 100h			; optional - defining the stack size in bytes
.data				; defines where variables are in

prompt1 db 10,13,"Enter a value: ","$" ;create a variable
result db 10,13,"Count: ","$"
num dw ?
var dw ?

.code
  include myMacros.asm
  proc main
  extrn indec: proc
  extrn outdec: proc




;house Keeping
	mov ax,@data ;mov address of data segment to ax register
	mov ds,ax ;set ds to ax
  scrClear    ;Clears the screen
  scrColor    ;Pints the screen and txt
  prtStr prompt1  ;Message to the user to input value
  call indec      ;Call indec procedure - returns the multi-digit value from user tp AX reg
  mov var,ax      ;put user input into the var variable

;mov cx,0      ;initialixe a loop control variable
xor cx,cx       ;set cx to 0
L1: prtStr result
    inc cx    ; ++ - increment by 1
    mov ax,cx
    call outdec     ;write the value stored in the ax reg to screen (multidigit)
    mov ax,cx
    cmp ax,var
    jl L1
    jg L2

;returtn control to DOS
L2:  mov ah,4ch ;set high byte of ax to 4c (DOS exit operation)
  int 21h ;DOS interrupt

endp

end main