TITLE Integer Accumulator     (Int_Accum.asm)

; Author: Carlos Lopez-Molina
; CS 271 / Program 3            Date: 2/12/17
; Description: MASM program that outputs intro and asks and saves the users name. Instructions are printed and input from the user is taken. Non-negative numbers are only accepted and number of numbers entered is outputed along with the sum and average of these numbers.
;**EC: Number the lines during user input.

	;Note: This program will validate the users input to be in [-100, -1] and as a positive number is entered, this will end the list.

INCLUDE Irvine32.inc

UPPER = -1		;upper limit
LOWER = -100	;lower limit 

.data

intro_1		BYTE	"Welcome to the Integer Accumulator by Carlos Lopez-Molina.", 0
urname		BYTE	"What is your name? ",0
extra		BYTE	"**EC: Number the lines during user input.",0
hello		BYTE	"Hello, ",0 
prompt_1	BYTE	"Please enter numbers in [-100, -1]. ",0
prompt_2	BYTE	"Enter a non-negative number when you are finished to see the results.",0
prompt_3	BYTE	"Enter a number: ",0
prompt_4	BYTE	"You entered ",0
prompt_5	BYTE	" valid numbers.",0
prompt_6	BYTE	"The sum of your valid numbers is ",0
prompt_7	BYTE	"The rounded average is ",0
prompt_8	BYTE	"You did not enter any valid numbers! ",0
bye			BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0 

name1		BYTE	50 DUP(0)
nameSize	DWORD	?
number		SDWORD	?
sum			SDWORD	0
average		SDWORD	?
validNum	DWORD	?
line		DWORD	1

.code
main PROC

;Intro
	call	Clrscr
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra
	call	WriteString
	call	CrLf

	;get and save name
	mov		edx, OFFSET urname
	call	WriteString
	mov		edx, OFFSET name1
	mov		ecx, SIZEOF name1
	call	ReadString
	mov		nameSize, eax
	call	Crlf
	
	;output name
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET name1
	call	WriteString
	call	CrLf
	call	CrLf

;Gather Inputs (main loop) - while checking the value during this time
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf

	;print line number
	mov		eax, line
	call	WriteDec
	mov		al, ' '
	call	WriteChar
	
	;first input
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt	
	mov		number, eax
	
	;.while ((number >= LOWER) && (number <= UPPER)) ;loop while number is between -1 and -100
_start:
	CMP		number, LOWER		
	JNGE	_out
	CMP		number, UPPER
	JNLE	_out
	mov		eax, number
	mov		ebx, sum
	add		eax, ebx
	mov		sum, eax
		
	;print line number
	mov		eax, line
	add		eax, 1
	mov		line, eax
	call	WriteDec
	mov		al, ' '
	call	WriteChar

	;prompt for another number
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt	
	mov		number, eax
		
	;increment the number of valid numbers entered
	mov		eax, validNum
	add		eax, 1
	mov		validNum, eax

	loop	_start
	
	call	CrLf
_out:
.if validNum != 0
	call	CrLf;------------------------------------------

	;calculate average
	mov		eax, sum
	cdq						;"convert double word to quad word" extend/expands the sign from eax into edx - avoids overflow issue
	mov		ebx, validNum
	idiv	ebx				;div for signed ints - quotient in eax remainder in edx
	mov		average, eax

;Prompts with information - results
	;valid numbers
	mov		edx, OFFSET prompt_4			
	call	WriteString
	mov		eax, validNum			
	call	WriteDec
	mov		edx, OFFSET prompt_5			
	call	WriteString
	call	CrLf
	
	;sum
	mov		edx, OFFSET prompt_6			
	call	WriteString
	mov		eax, sum			
	call	WriteInt
	call	CrLf

	;average
	mov		edx, OFFSET prompt_7			
	call	WriteString
	mov		eax, average			
	call	WriteInt
	call	CrLf
.else 
	mov		edx, OFFSET prompt_8			
	call	WriteString
.endif

	call	CrLf;------------------------------------------
;Outro
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET name1
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
