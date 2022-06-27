				bits 16
				org 0x100			; Star program at offset 100

; This program accepts a user name from the keyboard			
; and displays the message 'Hello user_name' on the screen
;



;--------------------- Jump over data declarations ------------------


				jmp main			; Jump to main program


;

;--------------------- Data declarations ----------------------------

; prompt

message:		db 'Enter a number (1-9):	$'

;

; Input_buffer

in_buf:			db 2				; Lengh of input buffer (20 chars)
len_in:			db 0				; Length of input string will be stored here by dos
user:			times 1 db ' '	; Reserve 20 storage positions for the input buffer

cr_lf:			db 0dh, 0ah, '$'	; Carriage return, Line feed

;

out_mess:		db '$'		; Output message

;

;---------------------- Display routine --------------------------

;

display: 							; Display a message on the screen
									; The address of the message must be in DX
				mov ah, 09h			; Request - Display message
				int 21h				; DOS System call
				ret

;----------------------Get characters that are input by user -------------

;

get_num:							; Accept a string of characters from the keyboard
									; The address of the input parameter block is in DX
				mov ah, 0x0a		; Request - buffered keyboard input
				int 21h				; DOS system call
				ret

;---------------------- Change colour of screen -------------

;

change_col:

				MOV AH, 06h    	; Scroll up function
				XOR AL, AL     	; Clear entire screen
				XOR CX, CX     	; Upper left corner CH=row, CL=column
				MOV DX, 184FH  	; lower right corner DH=row, DL=column 
				MOV BH, 1Fh    	; WhiteOnBlue
				INT 10H
				ret

;---------------------- Move cursour to start screen -------------

;

move_curs:						; Changes color of console
								; The address of the input parameter block is in DX
				MOV AH, 02h    	; Set Cursor position function
				MOV DH, 00h  	;
				MOV DL, 00h
				MOV BH, 00h    	; YellowOnBlue
				INT 10H
				ret


; -------------------- Main program ----------------------------
main: 
				call change_col		; Scroll, clear and change color
				call move_curs		; move cursor to start
				mov	dx, message		; Address of prompt
				call display 		; Display prompt
				mov dx, in_buf		; Move point to input buffer
				call get_num 		; Get buffered keyboard input
				mov bx, dx
				mov cx, 30
				sub bx, cx
				add bx, 1
				add bx, 30

				mov dx, cr_lf 		; Address of CR and LF
				call display 		; Send CRLF to screen
				mov dx, 36h
				;mov ah, 0h
				;sub ax, 30h
				;mov dx, 0h
				;mov bx, 3h
				;div bx
				;add ax, 30h
				;mov dx, ax
				call display
				

				int 20h 			; Terminate program

	
