;
;This program will test out the functions library to show the user of number formatted output
;

;
;Include our external functions library functions
%include "./functions.inc"

SECTION .data
	welcomePrompt	db	"Welcome to My x86 Array Processing Program", 00h
	array3Prompt	db	"Contents of Array 3 are: ", 00h
	array6Prompt	db	"Contents of Array 6 are: ", 00h
	goodbyePrompt	db	"Program ending, have a great day!", 00h


;Byte arrays
Array1	db	10h, 30h, 0F0h, 20h, 50h, 12h
	.LENGTHOF	equ	($-Array1)/1							;Number of items in the array
	.SIZEOF		equ	($-Array1)								;Number of bytes
	.TYPE		equ	(Array1.SIZEOF/Array1.LENGTHOF)			;
Array2	db	0E0h, 40h, 22h, 0E5h, 40h, 55h
	.LENGTHOF	equ	($-Array2)/1							;Number of items in the array
	.SIZEOF		equ	($-Array2)								;Number of bytes
	.TYPE		equ	(Array2.SIZEOF/Array2.LENGTHOF)			;
Array3	db	0h, 0h, 0h, 0h, 0h, 0h
	.LENGTHOF	equ	($-Array3)/1							;Number of items in the array
	.SIZEOF		equ	($-Array3)								;Number of bytes
	.TYPE		equ	(Array3.SIZEOF/Array3.LENGTHOF)			;
	
;Double word arrays

Array4	dd 11BDh, 3453h, 2FF0h, 6370h, 3350h, 1025h
	.LENGTHOF	equ	($-Array4)/4							;Number of items in the array
	.SIZEOF		equ	($-Array4)								;Number of bytes
	.TYPE		equ	(Array4.SIZEOF/Array4.LENGTHOF)			;
Array5	dd 0FFFh, 0C3Fh, 22FFh, 0EF53h, 400h, 5555h
	.LENGTHOF	equ	($-Array5)/4							;Number of items in the array
	.SIZEOF		equ	($-Array5)								;Number of bytes
	.TYPE		equ	(Array5.SIZEOF/Array5.LENGTHOF)			;
Array6	dd 0h, 0h, 0h, 0h, 0h, 0h
	.LENGTHOF	equ	($-Array6)/4							;Number of items in the array
	.SIZEOF		equ	($-Array6)								;Number of bytes
	.TYPE		equ	(Array6.SIZEOF/Array6.LENGTHOF)			;


SECTION .bss


SECTION     .text
	global      _start

_start:

	push	welcomePrompt
	call	PrintString
	call	Printendl
	call	Printendl

	;Byte array addition using Indirect Operands

	mov		ecx, Array1.LENGTHOF							;Move the total number of items in Array1 to ecx (Counter Register)
	mov		esi, Array1										;Move the address of Array1 into esi for indirect addressing
	mov		edi, Array2										;Move the address of Array2 into edi for indirect addressing
	
	mov		ebx, Array3										;Store the address of Array3 in ebx to use it for temporary address storage
	add		ebx, Array3.SIZEOF								;In order to store the Array3 in reverse order, we need to start at the end
	sub		ebx, Array3.TYPE								;We will decrement in order to go down 1 in Array3 (otherwise we would be
															;1 past the correct index)
	
	Loop1:													
		mov		al, [esi]									;Move the value at current Array1 address into al (8 bit register)
		add		al, [edi]									;Add the value at current Array2 address to Array1 in the al register
		inc		edi											;Increment edi so we have the proper address when restoring Array2 offset
		inc		esi											;Increment esi so we have the proper address of the next Array element
		
		xchg	ebx, edi									;Exchange the current offset of Array2 with ebx to let us work with Array3
															;edi now contains Array3 address
															
		mov		[edi], al									;Move the addition of Array1 and Array2 into Array3's correct offset
		dec		edi											;Decrement the current address of Array3 so we have
															;the proper offset when saving its value during the next xchg.
															
		xchg	edi, ebx									;Restore edi to Array2 previous offset, and restore Array3 new offset back
															;to ebx register
													
	loop Loop1				
	
	mov			eax, 0h										;Clear regs
	mov			ebx, 0h										;
	mov			ecx, 0h										;
	mov			esi, 0h										;
	mov			edi, 0h										;			


	;Double word array addition using Indexed Operands

	mov		esi, 0											;Initialize esi to 0 (This is what we will be adding to our Array offset)
	mov		ecx, Array4.LENGTHOF							;Move the total number of items in Array1 to ecx

	
	Loop2:													
		mov		eax, [Array4 + esi]							;Move the value at current Array1 address into eax (32 bit register)
		add		eax, [Array5 + esi]							;Add the value at current Array2 address to Array1 in the eax register
		
		mov		[Array6 + esi], eax							;Move the addition of Array4 + Array5 to Array6 correct offset
		
		add		esi, Array4.TYPE							;Add doubleword size (4 bytes) to esi using the .TYPE directive
															
	loop Loop2			
	
	mov			eax, 0h										;Clear regs
	mov			esi, 0h										;
	
	
	;Print the values in Array3 and Array6
	
	push	array3Prompt									;Print the Array 3 label
	call	PrintString										;Print PrintString function to print the array 3 prompt
	push 	Array3											;Push array 3 onto the stack
	push	Array3.LENGTHOF									;Push length of array 3 onto the stack
	call	PrintByteArray									;Call PrintByteArray function to print all o the contents in array 3
	call	Printendl
	call	Printendl
	
	push	array6Prompt									;Print the Array 6 label
	call	PrintString										;Call PrintString function to print the array 6 prompt
	push 	Array6											;Push array 6 onto the stack
	push	Array6.LENGTHOF									;Push the length of array 6 onto the stack
	call	PrintDWordArray									;Call PrintDWordArray function to print all of the contents in array 6
	call	Printendl
	call	Printendl
	
	push	goodbyePrompt									;Print the goodbye message
	call	PrintString										;
	call	Printendl										;
	
;
;Setup the registers for exit and poke the kernel
	mov		eax,sys_exit				;What are we going to do? Exit!
	mov		ebx,0						;Return code
	int		80h							;Poke the kernel
