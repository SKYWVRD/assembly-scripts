; Assemble as:
;   nasm  -f bin  -o ampm.com  ampmExample.asm
;
; 2005-10-25
;-----------------------------------------------------------

    section .text

;  DOS' .com executable format: entry point must be at 0x100
    org 0x100
main:                   ; this label is documentary only
    mov  dx, prompt
    call prtstring      ; a very minor subroutine

    call getAnswer      ; a less-minor subroutine
    call convertAnswer
    cmp bl, '2'
    JE amLabel

pmLabel:                ; "else" clause starts here
    mov  dx, pm
    call prtstring
    jmp  done           ; finish the "else" clause

amLabel:                ; "then" clause starts here
    mov  dx, am
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
    add  bx, 01h
    add  bx, 30h
    ret
;----------------


; the data - not a separate section in .COM files

prompt  db "am or pm? $"
am      db "You did it!", 0x0d, 0x0a, '$'     ; Either single-quotes or
pm      db 'You failed!', 0x0d, 0x0a, "$"   ; ...double-quotes work.

; DOS' input-string function requires a buffer structured like this:
;       struct input-buffer {
;           BYTE8 maxLength = N;  /* N is 20 in this case */
;           BYTE8 usedLength;
;           BYTE8 buffer[ N ];
;       }
answer  db 20, 0
;resb 20, 0
;-----------------------------------------------------------
