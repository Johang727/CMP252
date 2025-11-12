; variables

; registers:
	; R1: pointer storage
	; R2: counter (char limit)
	; R3: temporary character storage
	; R4: counter (replacement char limit)
		; this has to be equal to find to not overflow

; memory:
	; locations: 
		; START: Start of the program to loop back to at the end

		; RD_LP: Read Loop - Start of the Reading Loop
		; SKP_EX: Skip Exit - Skip checking for # if it's not the first char.
		; RD_EX: Read Exit - Allows for continuing on newline, prints out a newline after

		; FND: Start of FIND input reading logic
		; FD_LP: Find Loop - Start of the Reading Loop for what to find


		; HT: Halt - In case I want to do something before halting.

	; variables
		; INPUT: A block of 8 memory locations to hold the string to be modified
		; FIND: A blk of 3 mem locs to hold what needs to be found in INPUT
		; REPLACE: A blk of 3 mem locs to hold what needs to be replaced 
			; Each of these have an extra location so that PUTS always finds an exit char x0000

		; PRMTIN: Prompt In: Custom input prompt (for INPUT)
		; PRMTFD: Prompt Find: Custom input prompt (for FIND)
		; PRMTRP: Prompt Replace: Custom input prompt (for REPLACE)
		
		; ALTIN: Alert In: Tell the user that nothing will be done
		;			because their input was empty.
		; ALTFD: Alert Find: Tell the user that nothing will be searched for if
		; 		query is empty

		; NWLN: Holds a newline character

		; COUNT7: Holds the number 7 to init a counter
		; COUNT2: Holds the number 2 to init a counter


	.ORIG	x3000

; Reading Logic

	; print prompt
START	LEA	R0,	PRMTIN
	TRAP	x22 ; PUTS

	LD	R2,	COUNT7 ; load the number 7 into R2 for counting
	LEA	R1,	INPUT ; load pointer of input storage

	; get character input without prompt
RD_LP	TRAP	x20
	; echo the character
	TRAP	x21

	; check if newline
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-10 ; 10 is LF
	BRZ	RD_EX ; if newline, continue

	; check if counter == 7
	ADD	R2,	R2,	#-7
	BRN	SKP_EX ; its not the first character, therefore
			; there is no point in checking

	; check if exit character
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-16
	ADD	R3,	R3,	#-16
	ADD	R3,	R3,	#-3
	BRZ	HT

SKP_EX	ADD	R2,	R2,	#7

	; store the value
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1
	; if >=0, loop again
	ADD	R2,	R2,	#-1
	BRP	RD_LP

	; print a new line for legibility
RD_EX	LEA	R0,	NWLN
	TRAP	x22

	; check if counter is 7
	ADD	R2,	R2,	#-7
	; input holds something, proceed
	BRN	FND
	; else, tell the user theres nothing here and return to the start
	LEA	R0,	ALTIN
	TRAP	x22
	BRNZP	START


; Find Input Logic
FND	LEA	R0,	PRMTFD
	TRAP	x22 ; PUTS

	LD	R2,	COUNT2 ; load the number 2 into R2 for counting
	LEA	R1,	FIND ; load pointer of Finding Input Storage

	; init. R4 (this will be our counter for the next one)
	AND	R4,	R4,	#0

	; get character input without prompt
FD_LP	TRAP	x20
	; echo character
	TRAP	x21

	; check if newline
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-10 ; 10 is LF
	BRZ	FD_EX ; if newline, continue

	; store the value
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1

	; inc counter for replace
	ADD	R4,	R4,	#1
	; decrement counter
	ADD	R2,	R2,	#-1
	BRP FD_LP

FD_EX	LEA	R0,	NWLN
	TRAP	x22

	; check if counter is still two
	ADD	R2,	R2,	#-2
	; input holds something, proceed
	BRN	RP

	; else, tell the user theres nothing to find.
	LEA	R0,	ALTFD
	TRAP	x22
	BRNZP	START

; Replace In Logic

RP	LEA	R0,	PRMTRP
	TRAP	x22

	LEA	R1,	REPLACE

RP_LP	TRAP	x20
	TRAP	x21

	; check if newline
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-10 ; 10 is LF
	BRZ	RP_EX ; if newline, continue

	; store val
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1
	; dec counter
	ADD	R4,	R4,	#-1
	; repeat if positive
	BRP	RP_LP

RP_EX	LEA	R0,	NWLN
	TRAP	x22
	BRNZP	START


; replacement logic

; printing logic


; Halting script
HT	TRAP x25


; var def
INPUT	.BLKW		8 
FIND	.BLKW		3
REPLACE	.BLKW		3


PRMTIN	.STRINGZ	"Input (max 7 chars): "
PRMTFD	.STRINGZ	"Find (max 2 chars): "
PRMTRP	.STRINGZ	"Replace (<= length of find): "

ALTIN	.STRINGZ	"Input empty, nothing to do."
ALTFD	.STRINGZ	"Search query empty, nothing to do."


NWLN	.FILL		x0D0A ; All combinations of CR and LF just cause a square character, dunno why

COUNT7	.FILL		x0007
COUNT2	.FILL		x0002

	.END