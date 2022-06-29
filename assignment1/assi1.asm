; Sean Boonzaier - 61710199

;-----------------------------------------------------------

    org 0x100

; Main section of program
main:                   
    call change_col
    call move_curs
    mov  dx, prompt
    call prtstring      
    call getAnswer      
    call convertToInt
    mov ax, bx
    mov bl, 03h        ; stores 3 into bl for division on next line 
    div bl             ; divides value in ax which is the input value by 3
    cmp ah, 0          ; checks if the remainder of the division is 0
    JE isMultiLabel

notMultiLabel:                ; Runs if there is a remainder (not a multiple)
    mov dx, cr_lf
    call prtstring
    mov  dx, notDivisible
    call prtstring
    jmp  done           

isMultiLabel:                ; Runs if there is no remainder (is a multiple)
    mov dx, cr_lf
    call prtstring
    mov  dx, divisible
    call prtstring
    jmp  done           
;----------------

; Function to terminate program when called
done:
    mov  al, 0          
    mov  ah, 0x4c       
    int  0x21
;----------------

; Function to print string passed into dx
prtstring:
    mov  ah, 9          ; DOS print-string function
    int  0x21
    ret
;----------------

; Changes console color to White on Blue
change_col:

				MOV AH, 06h    	; Scroll up function
				XOR AL, AL     	; Clear entire screen
				XOR CX, CX     	; Upper left corner CH=row, CL=column
				MOV DX, 184FH  	; lower right corner DH=row, DL=column 
				MOV BH, 1Fh    	; WhiteOnBlue
				INT 10H
				ret
;----------------

; Moves the cursor to start of console when program runs
move_curs:						
								; The address of the input parameter block is in DX
				MOV AH, 02h    	; Set Cursor position function
				MOV DH, 00h
				MOV DL, 00h
				MOV BH, 00h  
				INT 10H
				ret
;----------------


; Obtains the keyboard input by the user
getAnswer:
    mov  dx, answer     
    mov  ah, 0x0a       
    int  0x21           
    mov  al, [answer+2] ; 3rd position/1st character of buffer stored in al
    ret
;----------------

; converts input ascii string to workable integer
convertToInt:
    mov  bl, al
    sub  bx, 30h
    ret
;----------------

; various declared variables for the code
prompt  db "Enter a value between 1 and 9: $"
divisible      db "The number is divisible by 3", 0x0d, 0x0a, "$"
notDivisible      db "The number is not divisible by 3", 0x0d, 0x0a, "$"
cr_lf			db 0dh, 0ah, "$"
answer  db 20, 0