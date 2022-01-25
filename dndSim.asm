.model small
.stack 100h
.386
.data
	intro db 10,13,'Youve been tasked with fighting off a Kobold whos been destroying nearby villages.','$'
	intro2 db 10,13,'After resting and making preparations,you head to the cave in which it resides.','$'
	preCombat db 10,13,'You walk into its small cave and the Kobold has its back to you.. ','$'
	beginCombat db 10,13,'Press enter to begin combat with the Kobold... ','$'
	
	msg1 db 10,13,' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!','$'
	msg2 db 10,13,' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!   COMBAT BEGINS   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!','$'
	msg3 db 10,13,' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!','$'
	
	roll db 10,13,'Press enter to roll for attack...','$'
	roll2 db 10,13,'Press enter to roll for damage...','$'
	
	newline db 10,13, '$'
	color db 40h
	char db ?
	atkRoll db ?
	atkRoll2 db ?
	dmgRoll db ?
	dmgRoll2 db ?
	youRolled db 10,13, 'You rolled a: ','$'
	;koRolled db 10,13,'Kobold attack roll: ','$'
	koRolled2 db 10,13,'Kobold damage roll: ','$'
	endBattle db 10,13,'The battle had ended.','$'
	;health db 10,13,'The kobolds health now: ','$'
	health2 db 10,13,'Your health is now: ','$'
	hp db ' HP',10,13,'$'
	enemyHp db ?
	myHp db ?
	koHits db 10,13,'The kobold rolls.. and hits!','$'
	koMiss db 10,13,'The kobold rolls... and misses!','$'
	divider db 10,13,'--------------------------------','$'
	divider2 db 10,13,'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~','$'
	youHit db 10,13,'You hit!','$'
	youMiss db 10,13,'You miss!','$'
	
	myWin db 10,13,'You did it, you won in your fight against the Kobold!','$'
	myWin2 db 10,13,'You go back to collect your reward and recieve praise from nearby villages.','$'
	koWin db 10,13,'You lost to the Kobold.. it has overthrown you in battle.','$'
	koWin2 db 10,13,'The quest giver looks for another fighter to take your place.','$'
	theEnd db 10,13,'                                  THE END','$'
	continue db 10,13,'****   The kobolds hp is now 0. Press enter to continue... ****','$'
	continue2 db 10,13,'********  Your hp is now 0. Press enter to continue... ********','$'
	
.code
	
	include bMacs.asm
	
	fight proc
	
		mov enemyHp,8 ;move 8 into enemyHp (enemyHp = 8)
		mov bh,enemyHp ;move enemyHp into bh
		mov myHp,9 ; move 9 into myHp (myHp = 9)
		
		pRoll:
			prtStr divider
			prtStr roll ; enter to roll..
			readChar2 char ; read the enter

			random10 atkRoll ; get random roll (0-9)
			mov al,atkRoll ; move roll into al
			prtStr youRolled ;print you rolled a..
			writeChar atkRoll ; print value
			
			cmp atkRoll,0h ; if al = 0 (which represents a 10) it is a critical hit, no need to check kobold's AC
			je hit1 ; continue to damage
			
			mov bl,4h ;move kobold's AC into bl
			cmp atkRoll,bl ; else if al (attack roll) is greater than bl(kobold's AC)
			jge hit1 ; continue to damage roll
			jmp miss1; else, it is the kobold's turn to attack.
			
		pDmg:
			prtStr roll2 ; press enter to roll
			readChar2 char ; read enter key
			
			random6 dmgRoll ; get random roll for damage
			prtStr youRolled ; you rolled a..
			writeChar dmgRoll ; print random num
			prtStr divider
			prtStr newline
			
			mov ah, dmgRoll	; move roll into ah
			sub bh,ah ; subtract the damageRoll(ah) from the kobold's HP(bh)
			cmp bh,0h ;if the kobold's HP(bh)= 0
			jle done ;the fight is over, and you won.. continue to the end 
			mov enemyHp, bh ; else, move the new value into enemyHp
			jmp kRoll; it is the kobold's turn to attack..
			;prtStr health ; the kobold's health is..
			;writeChar enemyHp ; display the new value
			;prtStr hp
			
		kRoll:
			prtStr newline
			random10 atkRoll2 ; get random roll
			mov cl, atkRoll2 ; move atkRoll into cl
			cmp cl,0 ; if al = 0 (which represents a 10) it is a critical hit, no need to check ac
			je hit2 ; continue to damage
			
			cmp atkRoll2, dl ; else if the atkRoll is ge to the player's AC, it hits
			jge hit2 ;continue to damage roll
			
			mov dl,6h ; move player's AC into dl
			cmp cl,dl ;else, atkRoll is less than the player's AC..
			jl miss2 ;it is the player's turn to attack
			
		kDmg:
			random6 dmgRoll2 ; get random roll for damage
			prtStr koRolled2
			writeChar dmgRoll2
			
			mov dh,dmgRoll2 ; move roll into ah
			mov ch, myHp ; move the player's HP into ch
			sub ch,dh ; subtract the damageRoll from the player's HP
			cmp ch,0h ;if the player's HP(myHp)= 0
			jle done ;the fight is over, you lost. Continue to the end.
			
			mov myHp,ch ; move the new value of ch into myHp (update myHp)
		
			prtStr health2 ; your health is..
			writeChar myHp ; print new hp
			prtStr hp
			prtStr divider2
			prtStr newline
			
			jmp pRoll ; since the player's health is not 0, loop combat again
		
		miss1:
			prtStr youMiss
			prtStr divider
			prtStr newline
			jmp kRoll 
			
		miss2:
			prtStr divider2
			prtStr koMiss
			prtStr divider2
			prtStr newline
			jmp pRoll
		
		hit1:
			prtStr youHit
			prtStr newline
			jmp pDmg
		
		hit2:
			prtStr divider2
			prtStr koHits
			jmp kDmg
		done:
		ret
	endp

	main proc
	mov ax,@data 
	mov ds,ax 
	
	;pre-combat display
	cls 
	scrColor color
	prtStr intro
	prtStr newline
	prtStr intro2
	prtStr newline
	prtStr preCombat
	prtStr newline
	prtStr beginCombat
	readChar2 char
	cls
	
	;combat section
	prtStr msg1
	prtStr msg2
	prtStr msg3
	prtStr newline
	call fight
	
	;post combat section
	cmp bh,0h ; if the kobold's HP = 0
	jle end1 ; you get the good ending, end1. (you win)
	cmp ch,0h ; else your HP = 0
	jle end2 ; you get the bad ending, end2. (you lose)

	end1:
		prtStr newline
		prtStr continue
		readChar2 char
		
		cls
		scrColor color
		prtStr myWin
		prtStr newline
		prtStr myWin2
		prtStr newline
		prtStr theEnd
		exit
		
	end2: 
		prtStr newline
		prtStr continue2
		readChar2 char
		
		cls 
		scrColor color
		prtStr koWin
		prtStr newline
		prtStr koWin2
		prtStr newline
		prtStr theEnd
		exit
	endp
end main