; CSC267 Final project: Travis Justice
; Winter 2021
; Rock, paper, scissors game

.model small
.stack 100h
.386
.data

	; string vars
	header db 10,13,'  Welcome to Rock, Paper, Scissors!',10,13,'-------------------------------------','$'		; header to be displayed at the top of the screen
	intro db 10,13,'Two out of three rounds wins the game!',10,13,'The winner of this game will be decided in glorious (simulated) combat!',10,13,'Choose your weapon, and your opponent will choose one at random:','$'		; rules to be printed after the header
	wins db 10,13,'You have won: ','$'	; tells the player how many wins they currently have
	losses db 10,13,'Opponent has won: ','$'	; tells the player how many losses they currently have
	options db 10,13,'1: Rock',10,13,'2: Paper',10,13,'3: Scissors','$'		; options of what the player can choose
	prompt db 10,13,'Enter your choice: ','$'	; prompt for user input
	rock db 'Rock','$'
	paper db 'Paper','$'
	scissors db 'Scissors','$'
	playerChoice db 10,13,'You chose: ','$'		; prints weapon chosen by the player to the screen
	opponentChoice db 10,13,'Opponent chose: ','$'		; prints random 'weapon' chosen by the program to the screen
	youwin db 10,13,'You won this round! Press any key to continue...','$'	; informs the user that they won the current round
	youlose db 10,13,'Your opponent won this round! Press any key to continue...','$'	; informs the user that they lost the current round
	tie db 10,13,"It's a tie! Press any key to continue...","$"	; informs the user of a tie
	invalid db 10,13,'That character is invalid. Try again.','$'	; tells the user to enter a valid character before exiting the program
	victory db 10,13,'Congratulations! You win!','$'	; tells the user they won the game
	defeat db 10,13,'You were defeated. Better luck next time.','$'	; tells the user they lost the game
	
	; int vars
	playerInput db ?	; stores value input by player
	playerWins db 0
	opponentInput db ?		; stores opponent's randomly generated number
	opponentWins db 0
	cont db ?
.code
	include RPSMacs.asm
	
	pickedRock proc		; procedure for player picking rock
		rand opponentInput	; random number gen for opponent choice value
		mov bl,opponentInput	; move opponent choice to bl
		printStr rock	; prints the player's choice
		printStr opponentChoice ; call printStr macro to print opponent's choice
		cmp bl,2		; compare value from rand to 2
		jl X1			; jump to X1 if opponent chose rock
		je X2			; jump to X2 if opponent chose paper
		jg X3			; jump to X3 if opponent chose scissors
		X1:		; player chose rock, opponent chose rock
			printStr rock	; print opponent's choice of rock
			printStr tie	; print "it's a tie" message
			continue cont	; wait for user to enter a key to continue
			jmp X4			; jumps to return statement
			
		X2:		; player chose rock, opponent chose paper
			printStr paper	; prints opponents choice of paper
			printStr youlose	; prints "you lose" msg
			continue cont	; continue prompt
			add opponentWins,1	; increment wins
			jmp X4			; jump to return statement
			
		X3:		; player chose rock, opponent chose scissors
			printStr scissors
			printStr youwin
			continue cont
			add playerWins,1
			jmp X4
			
		X4:
			ret
	endp
	
	pickedPaper proc
		rand opponentInput
		mov bl,opponentInput
		printStr paper
		printStr opponentChoice ; call printStr macro to print opponent's choice
		cmp bl,2		; compare sum to 2 decimal
		jl Y1			; jump to Y1 if opponent chooses rock
		je Y2			; jump to Y2 if opponent chooses paper
		jg Y3			; jump to Y3 if opponent chooses scissors
		Y1:		; player chose paper, opponent chose rock
			printStr rock
			printStr youwin
			continue cont
			add playerWins,1
			jmp Y4
			
		Y2:		; player chose paper, opponent chose paper
			printStr paper
			printStr tie
			continue cont
			jmp Y4
			
		Y3:		; player chose paper, opponent chose scissors
			printStr scissors
			printStr youlose
			continue cont
			add opponentWins,1
			jmp Y4
			
		Y4:
			ret
	endp
	
	pickedScissors proc
		rand opponentInput
		mov bl,opponentInput
		printStr scissors
		printStr opponentChoice ; call printStr macro to print opponent's choice
		cmp bl,2		; compare sum to 2 decimal
		jl Z1			; jump to Z1 if opponent chooses rock
		je Z2			; jump to Z2 if opponent chooses paper
		jg Z3			; jump to Z3 if opponent chooses scissors
		Z1:		; player chose scissors, opponent chose rock
			printStr rock
			printStr youlose
			continue cont
			add opponentWins,1
			jmp Z4

		Z2:		; player chose scissors, opponent chose paper
			printStr paper
			printStr youwin
			continue cont
			add playerWins,1
			jmp Z4

		Z3:		; player chose scissors, opponent chose scissors
			printStr scissors
			printStr tie
			continue cont
			jmp Z4

		Z4:
			ret
	endp
	
	
	main proc
		mov ax,@data				; load ax register with the address of data segment
		mov ds,ax					; load ds register with the address stored in ax
		game:
			scrClear				; call clear screen macro
			scrColor 02h			; call screen color macro
			printStr header			; prints header to screen
			printStr intro			; prints rules to screen
			printStr wins			; prints user's current wins
			writeChar playerWins	; prints number of wins
			printStr losses			; prints user's current losses
			writeChar opponentWins	; prints number of losses
			printStr options		; prints options to screen
			printStr prompt			; prints prompt for user input
			readChar playerInput	; call read character macro
			mov al,playerInput		; move player input to al register
			printStr playerChoice	; print the player choice string
			; decision structure
			cmp al,1		; compare input to 1 decimal
			je P1			; jump to P1 if input is equal to 1
			cmp al,2		; compare input to 2 decimal
			je P2			; jump to P2 if input is equal to 2
			cmp al,3		; compare input to 3 decimal
			je P3			; jump to P3 if input is equal to 3
			jmp P4			; otherwise, jump to P4
			P1:		; player chose rock
				call pickedRock
				mov ah,playerWins
				cmp ah,'2'
				je exit1
				mov bh,opponentWins
				cmp bh,'2'
				je exit2
				jmp game	; restarts game if nobody has won 2 of 3 games
				
			P2:		; player chose paper
				call pickedPaper
				mov ah,playerWins
				cmp ah,'2'
				je exit1
				mov bh,opponentWins
				cmp bh,'2'
				je exit2
				jmp game	; restarts game if nobody has won 2 of 3 games
			P3:		; player chose scissors
				call pickedScissors
				mov ah,playerWins
				cmp ah,'2'
				je exit1
				mov bh,opponentWins
				cmp bh,'2'
				je exit2
				jmp game	; restarts game if nobody has won 2 of 3 games
			P4:
				scrClear
				scrColor 02h
				printStr invalid
				return

			exit1:
				scrClear				; call clear screen macro
				scrColor 02h			; call screen color macro
				printStr header			; prints header to screen
				printStr intro			; prints rules to screen
				printStr wins			; prints user's current wins
				writeChar playerWins	; prints number of wins
				printStr losses			; prints user's current losses
				writeChar opponentWins	; prints number of losses
				printStr victory
				return
			
			exit2:
				scrClear				; call clear screen macro
				scrColor 02h			; call screen color macro
				printStr header			; prints header to screen
				printStr intro			; prints rules to screen
				printStr wins			; prints user's current wins
				writeChar playerWins	; prints number of wins
				printStr losses			; prints user's current losses
				writeChar opponentWins	; prints number of losses
				printStr defeat
				return
	endp
end main