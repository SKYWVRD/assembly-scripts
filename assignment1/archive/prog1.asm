			bits	16
			org		0x100						; Start program at offset 100h
			jmp		main						; Jump to main program
message:	db 'Hello World', 0ah, 0dh, '$'
main:		mov dx, message						; Start address of message
			mov ah, 09							; Prepare for screen display
			int 21h								; DOS intterupt 21h
			int 20h								; Terminate Program
