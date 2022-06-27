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

message:		db 'Enter your name please	$'

;

; Input_buffer

in_buf:			db 20				; Lengh of input buffer (20 chars)
len_in:			db 00				; Lenght of input string will be stored here by dos
user:			times 20 db '	'	; Reserve 20 storage positions for the input buffer

cr_lf:			db 0dh, 0ah, '$'	; Carriage return, Line feed

;

out_mess:		db 'Hello $'		; Output message

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

get_chars:							; Accept a string of characters from the keyboard
									; The address of the input parameter block is in DX
				mov ah, 0x0a		; Request - buffered keyboard input
				int 21h				; DOS system call
				ret

;---------------------- Change color of screen -------------

;

change_col:							; Changes color of console
									; The address of the input parameter block is in DX
				mov AX, 06
				mov bh, 14h
				mov cx, 0000h
				mov dx, 14F0h
				int 10h
				ret


; -------------------- Main program ----------------------------
main: 
				call change_col		; Update screen
				mov	dx, message		; Address of prompt
				call display 		; Display prompt
				mov dx, in_buf 		; Address of input buffer
				call get_chars 		; Get buffered keyboard input
				mov dx, cr_lf 		; Address of CR and LF
				call display 		; Send CRLF to screen
				mov dx, out_mess 	; Address of 'Hello'
				call display 		; Display 'Hello'
				mov dx, user 		; Address of user name entered
				mov bx, user 		; Get start of input string
				add bl, [len_in] 	; Add length of string entered to BL to point
									; to 'Enter' (Carriage return) keyed in at the end
									; of the input string by the user
				mov al, 20h			; 20h = space (ascii)
				mov [bx], al		; Overwrite carriage return with a space
				call display 		; Display user name
				int 20h 			; Terminate program

	
