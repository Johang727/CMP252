		; allocate a block of 7 bytes for the characters
		; allocate a block of 2 bytes for the find input
		; allocate a block of 2 bytes for the replacement input

		; prompt user for input

		; get input
			; set pointer to start of string
			; while not new line or # && counter != 0
				; get character and store it in the INPUT variable
				; have a pointer that increments or something to do this


	.ORIG	x3000

	; print prompt 
	LEA	R0,	PRMTIN
	TRAP	x22 ; PUTS


	; Reading Logic
	LD	R2,	COUNT6 ; load the number 7 into R2 for counting
	LEA	R1,	INPUT ; load address of Input

RD_LP	TRAP	x20

	TRAP	x21

	; TODO check for branching out conditions, else just fall through
	; if is a newline, the continue | if is a #, then halt the program

	; store the value
	STR	R0,	R1,	000000

	ADD	R1,	R1,	#1
	ADD	R2,	R2,	#-1 ; if >0, continue

	BRZP	RD_LP

	; print a new line for simplicity
	LEA	R0,	NWLN
	TRAP	x22
	TRAP	x25


	; Finding Logic
	LD	R2,	COUNT2 ; load the number 7 into R2 for counting
	LEA	R1,	FIND ; load address of Finding Input Storage


	; Replacing Logic


	; Printing Logic


	; Halting script


; var def
INPUT	.BLKW		7
FIND	.BLKW		2
REPLACE	.BLKW		2


PRMTIN	.STRINGZ	"Input string of 7 or less:"
PRMTFD	.STRINGZ	"Find:"
PRMTRP	.STRINGZ	"Replace:"

NWLN	.FILL		x0D0A ; All combinations of CRLF just cause a square character, dunno why

COUNT6	.FILL		x0006
COUNT2	.FILL		x0002



	.END