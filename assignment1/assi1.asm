; Sean Boonzaier - 61710199

;-----------------------------------------------------------

    org 0x100
main:                   ; this label is documentary only
    call change_col
    call move_curs
    mov  dx, prompt
    call prtstring      ; a very minor subroutine
    call getAnswer      ; a less-minor subroutine
    call convertAnswer
    mov ax, bx
    mov bl, 03h
    div bl
    cmp ah, 0
    JE amLabel

pmLabel:                ; "else" clause starts here
    mov  dx, notDivisible
    call prtstring
    jmp  done           ; finish the "else" clause

amLabel:                ; "then" clause starts here
    mov  dx, divisible
    call prtstring
    jmp  done           ; finish the "then" clause (unneeded instruction!)

done:
    mov  al, 0          ; return code
    mov  ah, 0x4c       ; Alternatively:  "mov ax, 0x4c00"
    int  0x21
;----------------

; Encapsulate use of DOS' string-printing function.
;   Expects:  address of string-to-be-printed, in DX
;   Returns:  nothing
prtstring:
    mov  ah, 9          ; DOS print-string function
    int  0x21
    ret
;----------------

change_col:

				MOV AH, 06h    	; Scroll up function
				XOR AL, AL     	; Clear entire screen
				XOR CX, CX     	; Upper left corner CH=row, CL=column
				MOV DX, 184FH  	; lower right corner DH=row, DL=column 
				MOV BH, 1Fh    	; WhiteOnBlue
				INT 10H
				ret

move_curs:						; Changes color of console
								; The address of the input parameter block is in DX
				MOV AH, 02h    	; Set Cursor position function
				MOV DH, 00h
				MOV DL, 00h
				MOV BH, 00h  
				INT 10H
				ret


; Obtain keyboard input.
;   Expects:  nothing
;   Returns:  first letter of the keyboard input, in AL
getAnswer:
    mov  dx, answer     ; a structured input buffer - see below
    mov  ah, 0x0a       ; DOS input-string function
    int  0x21           ; DOS services interrupt
    mov  al, [answer+2] ; al <-- 3rd position/1st character of buffer
    ret
;----------------

; Obtain keyboard input.
;   Expects:  nothing
;   Returns:  first letter of the keyboard input, in AL
convertAnswer:
    mov  bl, al
    sub  bx, 30h
    ret
;----------------

prompt  db "Enter a value between 1 and 9? $"
divisible      db "Divisible by 3", 0x0d, 0x0a, '$'
notDivisible      db 'Not divisible by 3', 0x0d, 0x0a, "$"

answer  db 20, 0