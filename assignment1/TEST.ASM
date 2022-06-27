int 20
mov	ax, 0015h
mov cx, 0023h
sub cx, ax
mov	[120h],al
mov	cl,[120h]
nop