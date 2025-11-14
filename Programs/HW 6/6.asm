; variables

; registers:
	; for input:
		; R1: pointer storage
		; R2: counter (decrementing)
		; R3: temporary character storage
		; R4: counter (incrementing)
	; for 1 char find & replace:
		; R1: in str pointer
		; R2: in str length counter
		; R3: find char
		; R4: replace char
		; R5: current working char
	; for 2 char find & replace:
		; R1: in str pointer
		; R2: in str len counter
		; R3: find str pointer
		; R4: replacement str pointer
		; R5: current working character or replacement character
		; R6: current character to compare to

; memory:
	; locations: 
		; START: Start of the program to loop back to at the end

		; RD_LP: Read Loop - Start of the Reading Loop
		; SKP_EX: Skip Exit - Skip checking for # if it's not the first char.
		; RD_EX: Read Exit - Allows for breaking on newline, prints out a newline after

		; FND: Start of FIND input reading logic
		; FD_LP: Find Loop - Start of the Reading Loop for what to find
		; FD_EX: Find Exit - Allows for breaking on newline, prints out a newline after

		; RP: Start of the REPLACE reading logic
		; RP_LP: Replace Loop - Start of the reading loop for the replacement chars
		; RP_EX: Replace Exit - Allows for breaking on a newline, prints out a new line

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

	AND	R4,	R4,	#0 ; reset counters

	; get character input without prompt
RD_LP	TRAP	x20
	; echo the character
	TRAP	x21

	; check if newline
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-10 ; 10 is LF
	BRz	RD_EX ; if newline, continue

	; check if counter == 7
	ADD	R2,	R2,	#-7
	BRn	SKP_EX ; its not the first character, therefore
			; there is no point in checking

	; check if exit character
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-16
	ADD	R3,	R3,	#-16
	ADD	R3,	R3,	#-3
	BRz	EXP2

SKP_EX	ADD	R2,	R2,	#7

	; store the value
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1

	; increment length counter
	ADD	R4,	R4,	#1
	; if >=0, loop again
	ADD	R2,	R2,	#-1
	BRp	RD_LP

	; print a new line for legibility
RD_EX	LEA	R0,	NWLN
	TRAP	x22

	; check if counter is 7
	ADD	R2,	R2,	#-7
	; input holds something, store the length and proceed
	ST	R4,	INP_LEN
	BRn	FND
	; else, tell the user theres nothing here and return to the start
	LEA	R0,	ALTIN
	TRAP	x22
	BRnzp	START


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
	BRz	FD_EX ; if newline, continue

	; store the value
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1

	; inc counter for replace
	ADD	R4,	R4,	#1
	; decrement counter
	ADD	R2,	R2,	#-1
	BRp FD_LP

FD_EX	LEA	R0,	NWLN
	TRAP	x22

	; check if counter is still two
	ADD	R2,	R2,	#-2
	; input holds something, proceed
	BRn	RP

	; else, tell the user theres nothing to find.
	LEA	R0,	ALTFD
	TRAP	x22
	BRnzp	FND

; Replace In Logic

RP	LEA	R0,	PRMTRP
	TRAP	x22

	LEA	R1,	REPLACE

	; set counter to our len of find
	AND	R2,	R2,	#0
	ADD	R2,	R2,	R4

RP_LP	TRAP	x20
	TRAP	x21

	; check if newline
	AND	R3,	R3,	#0
	ADD	R3,	R3,	R0
	ADD	R3,	R3,	#-10 ; 10 is LF
	BRz	RP_EX ; if newline, continue

	; store val
	STR	R0,	R1,	#0

	; increment pointer
	ADD	R1,	R1,	#1
	; dec counter
	ADD	R2,	R2,	#-1
	; repeat if positive
	BRp	RP_LP

RP_EX	LEA	R0,	NWLN
	TRAP	x22

; replacement logic

	; if find len = 1
	ADD	R4,	R4,	#-1
	BRz	FR1
	ADD	R4,	R4,	#1 ; didn't equal 1, check if 2

	; if find len = 2
	ADD	R4,	R4,	#-2
	BRz	FR2

	; if it somehow passed through

	BRnzp	EXP0


; only one char to find & replace
FR1	LD	R2,	INP_LEN ; get length of string and use as counter | I could've also just kept looping until I found the break x0000

LEA	R1,	INPUT ; load pointer to char array input
LD	R3,	FIND ; load first character in find
NOT	R3,	R3 ; prep for subtraction
ADD	R3,	R3,	#1 
LD	R4,	REPLACE ; load first character in replace

; loop through each character in string and see if equal to FIND
FR1_LP	LDR	R5,	R1,	#0 ; load character where R1 is pointing

ADD	R5,	R5,	R3 ; should equal 0 if same

BRnp DC_CNT1 ; if negative or positive, just loop again

STR	R4,	R1,	#0 ; store replacement character if same

DC_CNT1	ADD	R1,	R1,	#1 ; increment pointer
ADD	R2,	R2,	#-1 ; dec counter
BRp	FR1_LP ; repeat if counter is positive

BRnzp	P_FIN



; counter = len(find) (INP_LEN)


; two chars to find & replace
FR2	LD	R2,	INP_LEN ; get len of string and use as counter
LEA	R1,	INPUT ; load pointer
ADD	R1,	R1,	#1 ; offset pointer by 1

LEA	R3,	FIND
LEA	R4,	REPLACE

FR2_LP	LDR	R5,	R1,	#-1 ; load character where R1-1 is pointing

LDR	R6,	R3,	#0 ; check if first character is equal

; compare
NOT	R6,	R6
ADD	R6,	R6,	#1
ADD	R5,	R5,	R6 ; if same = 0

BRnp	DC_CNT2 ; no point in checking 2nd if first doesn't match

; load second character, since first matches
LDR	R5,	R1,	#0

LDR	R6,	R3,	#1

NOT	R6,	R6
ADD	R6,	R6,	#1
ADD	R5,	R5,	R6 

BRnp	DC_CNT2 ; second character doesn't match, dont replace.

; if it does match

; character 1
LDR	R5,	R4,	#0
BRnp	NT_NL
; if null
LD	R5,	NULL_R

NT_NL	STR	R5,	R1,	#-1 ; replace character in final string

; character 2
LDR	R5,	R4,	#1
BRnp	NT_NL2
; if null
LD	R5,	NULL_R

NT_NL2	STR	R5,	R1,	#0 ; replace character in final string


; dec our counter
ADD	R1,	R1,	#1
ADD	R2,	R2,	#-1


DC_CNT2 ADD	R1,	R1,	#1
ADD	R2,	R2,	#-1
BRp	FR2_LP






; printing logic, branch to start after printing
P_FIN	LEA	R0,	INPUT
	TRAP	x22
	LEA	R0,	NWLN
	TRAP	x22
	BRnzp	START ; go back to start when printing final


; Exception Printing

EXP0	LEA	R0,	EXPT0 ; unknown err
	TRAP	x22
	TRAP	x25

EXP1	LEA	R0,	EXPT1 ; unfinished
	TRAP	x22
	TRAP	x25

EXP2	LEA	R0,	EXPT2 ; exit char
	TRAP	x22
	TRAP	x25

; var def
COUNT7	.FILL		x0007
COUNT2	.FILL		x0002


INPUT	.BLKW		8 
FIND	.BLKW		3
REPLACE	.BLKW		3

INP_LEN	.BLKW		1 ; input length

PRMTIN	.STRINGZ	"Input (max 7 chars): "
PRMTFD	.STRINGZ	"Find (max 2 chars): "
PRMTRP	.STRINGZ	"Replace (<= length of find): "

NWLN	.FILL		x0A00 
	.FILL		x0000 ; need this to prevent it printing out the next string

NULL_R	.FILL	x20 ; just replace it with a space

ALTIN	.STRINGZ	"Input empty, nothing to do."
ALTFD	.STRINGZ	"Search query empty, nothing to do."

EXPT0	.STRINGZ	"Uh oh."
EXPT1	.STRINGZ	"Unfinished."
EXPT2	.STRINGZ	"Exit character found... halting."


	.END