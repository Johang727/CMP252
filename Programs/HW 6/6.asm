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

	; Reading Logic

	; print prompt
	LEA	R0,	PRMTIN
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
	BRNZP	HT


	; Finding Logic
	LEA	R0,	PRMTFD
	TRAP	x22 ; PUTS

	LD	R2,	COUNT2 ; load the number 2 into R2 for counting
	LEA	R1,	FIND ; load pointer of Finding Input Storage

	; get character input without prompt
FD_LP	TRAP	x20
	; echo input
	TRAP	x21


	; Replacing Logic


	; Printing Logic


	; Halting script

HT	TRAP x25


; var def
INPUT	.BLKW		7
FIND	.BLKW		2
REPLACE	.BLKW		2


PRMTIN	.STRINGZ	"Input string of 7 or less characters: "
PRMTFD	.STRINGZ	"Find: "
PRMTRP	.STRINGZ	"Replace: "

NWLN	.FILL		x0D0A ; All combinations of CRLF just cause a square character, dunno why

COUNT7	.FILL		x0007
COUNT2	.FILL		x0002

	.END