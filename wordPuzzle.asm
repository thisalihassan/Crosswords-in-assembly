.386
.model flat, stdcall
.stack 4096

ExitProcess proto, dwExitCode:dword

GetStdHandle PROTO,         ; get standard handle
    nStdHandle:DWORD        ; type of console handle

GetTickCount PROTO      ; get elapsed milliseconds
                        ; since computer turned on

ReadConsoleA PROTO,
    handle:DWORD,                     ; input handle
    lpBuffer:PTR BYTE,                ; pointer to buffer
    nNumberOfCharsToRead:DWORD,       ; number of chars to read
    lpNumberOfCharsRead:PTR DWORD,    ; number of chars read
    lpReserved:PTR DWORD              ; 0 (not used - reserved)

WriteConsoleA PROTO,                   ; write a buffer to the console
    handle:DWORD,                     ; output handle
    lpBuffer:PTR BYTE,                ; pointer to buffer
    nNumberOfCharsToWrite:DWORD,      ; size of buffer
    lpNumberOfCharsWritten:PTR DWORD, ; number of chars written
    lpReserved:PTR DWORD              ; 0 (not used)

CreateFileA PROTO,           ; create new file
    pFilename:PTR BYTE,     ; ptr to filename
    accessMode:DWORD,       ; access mode
    shareMode:DWORD,        ; share mode
    lpSecurity:DWORD,       ; can be NULL
    howToCreate:DWORD,      ; how to create the file
    attributes:DWORD,       ; file attributes
    htemplate:DWORD         ; handle to template file

ReadFile PROTO,           ; read buffer from input file
    fileHandle:DWORD,     ; handle to file
    pBuffer:PTR BYTE,     ; ptr to buffer
    nBufsize:DWORD,       ; number bytes to read
    pBytesRead:PTR DWORD, ; bytes actually read
    pOverlapped:PTR DWORD ; ptr to asynchronous info

WriteFile PROTO,             ; write buffer to output file
    fileHandle:DWORD,        ; output handle
    pBuffer:PTR BYTE,        ; pointer to buffer
    nBufsize:DWORD,          ; size of buffer
    pBytesWritten:PTR DWORD, ; number of bytes written
    pOverlapped:PTR DWORD    ; ptr to asynchronous info

GetTimeFormatA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

SetConsoleTextAttribute PROTO,     
nStdHandle:DWORD,			  ; console output handle     
nColor:DWORD				  ; color attribute 

SetConsoleCursorPosition PROTO,     
handle:DWORD,       
pos:DWORD


.data
char byte ?
empSpace byte "                                        "
string1 byte "               |----------Welcome to the Puzzle World----------|",0
string2 byte 0dh,0ah, "You have 10 minutes to complete the game. Your time started at: ",0
timeformat byte "hh:mm:ss tt", 0
direction0 byte "Possible Directions:"
direction1 byte "	      0	"
direction2 byte "	      |	"
direction3 byte "	      |			"
direction4 byte " 5  ------o------  1"
direction5 byte "	   /  |  \      "
direction6 byte "	  /   |   \     "
direction7 byte "	 4    3    2    "
systime byte 15 dup (?)
string4 byte 0dh,0ah,"Words to be found:                                            Score:",0
score sword 0
bytescore byte 5 dup(?)
string5 byte 0dh,0ah,"Please enter the word, row no, column no and direction no (e.g. dummyword 1 2 0):",0
chosefile byte 90 dup (?)
filepath byte "C:\Users\Kalicifer\Downloads\wordsa.txt",0
tickPath byte "C:\Users\Kalicifer\Downloads\tick.txt",0
abc byte "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
tempGrid dword 300 dup(?)
buffer byte 5000 dup(?)
Grid byte 705 dup(?)			;================> check getBlocks proc to calculate blocks
ngrid dword 15					;================> adjustable NxN grid size  
x dword ?
checkcount dword ?
seed dword ? 
boolword dword 8 dup(?)
count dword 0
rand dword 0
theWord byte 10 dup (?)
Direction byte ?
colNo byte ?
rowNo byte ?
startTime dword ?
endTime dword ?
checkWord byte 90 dup (?)
wordOff dword 400 dup(?)


.code
;==========================ToChangeGridblocks==============================
;==========================to change blocks first adjust Grid==============
getBlocks proc uses esi
mov eax, ngrid
mul ngrid
mov esi, eax
add esi, esi
add esi, eax
mov eax, esi

mov esi, ngrid
shl esi, 1
add eax, esi

ret
getBlocks endp

;========================== Main Proc==============================
main proc
call loadStart

call WriteToGrid
call hideWords

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset Grid, lengthof Grid, offset x, 0

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset string5, lengthof string5, offset x, 0

call startGame

invoke ExitProcess, 0
main endp

;========================== DisplayDirection==============================
movecursor proc uses eax ebx


mov ebx, 3
rol ebx, 16
mov bx, 36

invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset direction0, lengthof direction0, offset x, 0


mov ebx, 4
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 ;keyboard    input handle
invoke WriteConsoleA, EAX, offset direction1, lengthof direction1, offset x, 0

mov ebx, 5
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 ;keyboard    input handle
invoke WriteConsoleA, EAX, offset direction2, lengthof direction2, offset x, 0

mov ebx, 6
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 
invoke WriteConsoleA, EAX, offset direction3, lengthof direction3, offset x, 0

mov ebx, 7
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 
invoke WriteConsoleA, EAX, offset direction4, lengthof direction4, offset x, 0

mov ebx, 8
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 
invoke WriteConsoleA, EAX, offset direction5, lengthof direction5, offset x, 0

mov ebx, 9
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 
invoke WriteConsoleA, EAX, offset direction6, lengthof direction6, offset x, 0

mov ebx, 10
rol ebx,16
mov bx, 36


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11 
invoke WriteConsoleA, EAX, offset direction7, lengthof direction7, offset x, 0

mov ebx, 12
rol ebx,16
mov bx, 0


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

ret
movecursor endp



;==========================LoadStartProcedures==============================
loadStart proc

invoke GetTickCount
mov seed, eax
mov startTime, eax

invoke GetTimeFormatA, 0800h, 0, 0, offset timeformat, offset systime , lengthof systime

invoke CreateFileA, offset filepath, 1, 0, 0, 3, 128, 0
;eax will be the handle

invoke ReadFile, eax, offset buffer, lengthof buffer, offset x, 0
invoke GetStdHandle, -11

call chooseFile
call shuffleSort


invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset string1, lengthof string1, offset x, 0

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset string2, lengthof string2, offset x, 0

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset systime, lengthof systime, offset x, 0

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset string4, lengthof string4, offset x, 0



mov ebx, 0
mov bl, 7
shl bl, 4
or bl, 0

;mov ebx, 0
;mov bl, 0
;shl bl, 4
;or bl, 7

invoke GetStdHandle, -11
invoke SetConsoleTextAttribute, eax, ebx

mov ebx, 2
rol ebx, 16
mov bx, 69

invoke GetStdHandle, -11
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset bytescore, lengthof bytescore, offset x, 0

mov ebx, 0
mov bl, 0
shl bl, 4
or bl, 7

invoke GetStdHandle, -11
invoke SetConsoleTextAttribute, eax, ebx

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset chosefile, lengthof chosefile, offset x, 0

call movecursor


ret
loadStart endp

;========================== Take Random 8 words==============================
chooseFile proc uses eax ebx ecx esi
mov eax, 486
call generaterandom
mov ecx, eax
mov esi, offset buffer
l1:
	cmp ecx, 0
	je exit
	mov al, [esi]
	inc esi
	cmp al, 0dh
	jne l1
	dec ecx
jmp l1
exit:
mov ecx, 8
mov ebx, offset chosefile
	l2:
		cmp ecx, 0
		je exit2
		mov al, [esi]
		cmp al, 0dh
		je inhere
		checkme:
			cmp al, 0ah
			je inhere
			and al, 11011111b
			inhere:
				mov [ebx], al
				inc esi
				inc ebx
				cmp al, 0dh
				jne l2
				dec ecx
			jmp l2
exit2:
mov cx, 0ah
mov [ebx], cx
inc ebx
mov al, 0
mov [ebx], al
ret
chooseFile endp

;========================== Write Random letters to Grid==============================
WriteToGrid proc uses ebx ecx edx esi ebp
mov eax, lengthof Grid
mov edx, ngrid
shl edx, 1
sub eax, edx
cdq
mov ecx, 3
div ecx
mov ecx, 1
mov edi, eax
inc edi
mov esi, offset Grid
mov eax, 0
mov ah, 32
mov bl, 20h
mov bp, 0d0ah
writeTo:
	cmp edi, ecx
	je endloop
	mov edx, offset abc
	mov eax, 26
	call generaterandom
	add edx, eax
	mov al, [edx]
	mov [esi], al
	inc esi
	mov [esi], bl
	inc esi
	mov [esi], bl
	inc esi
	push ecx
	call CheckGrid
	cmp eax, 0
	jne endhere
	mov [esi], bp
	inc esi
	endhere:
	inc ecx
jmp writeTo
endloop:

ret
WriteToGrid endp

;========================== Generate Random==============================
generaterandom proc uses ebx edx   
mov   ebx, eax  ; maximum value   
mov   eax, 343FDh   
imul  seed   
add   eax, 269EC3h   
mov   seed, eax     ; save the seed for the next call   
ror   eax,8         ; rotate out the lowest digit   
mov   edx,0   
div   ebx   ; divide by max value   
mov   eax, edx  ; return the remainder  
ret 
generaterandom endp 

;==========================CheckForNewLine==============================
CheckGrid proc uses edx esi
mov eax, [esp+12]
cdq
div ngrid
mov eax, edx
ret 4
CheckGrid endp

;==========================hideWords=====================================
hideWords proc uses esi
mov ebx, offset boolword
mov esi, [ebx]
push esi
call horizontalR

mov esi, [ebx+4]
push esi
call horizontalS

mov esi, [ebx+8]
push esi
call hideColU

mov esi, [ebx+12]
push esi
call hideCold

mov esi, [ebx+16]
push esi
call diagnoalS

mov esi, [ebx+20]
push esi
call diagnoalR

mov eax, 3
call generaterandom
cmp eax, 0
je word1

cmp eax, 1
je word2

cmp eax, 2
je word3

word1:
mov esi, [ebx+24]
push esi
call horizontalR

mov esi, [ebx+28]
push esi
call hideColU
jmp exit

word2:
mov esi, [ebx+24]
push esi
call hideCold

mov esi, [ebx+28]
push esi
call diagnoalS
jmp exit

word3:
mov esi, [ebx+24]
push esi
call diagnoalR

mov esi, [ebx+28]
push esi
call horizontalS

exit:



;incomplete
ret
hideWords endp

;==========================MatchOffset=====================================
matchOffset proc uses esi ebx ebp ecx 
mov ecx, lengthof wordOff
mov esi, offset wordOff
loopout:
mov eax, [esi]
mov ebp, offset tempGrid
	loopin:
		mov ebx, [ebp]
		add ebp, 4
		cmp ebx, 0
		je endloop
		cmp eax, ebx
		je break
	jmp loopin
	endloop:
add esi, 4
loop loopout
mov eax, 0
break:


exit:

ret 
matchOffset endp
;==========================DonotRepeatRand=====================================
repeatRand proc uses edx ecx esi
again:
mov eax, 706
call generaterandom
mov edx, offset tempGrid
mov esi, edx
mov ecx, lengthof tempGrid
looped1:
	mov ebp, [esi]
	cmp eax, esi
	je again
	add esi, 4
loop looped1
add edx, rand
mov [edx], eax
add rand, 4

ret
repeatRand endp

;==========================GetOffsetDimension=====================================
getOffsetDim proc uses ecx eax
mov ebx, 0
mov edx, offset tempGrid
again:
	mov esi, offset Grid
	call repeatRand
	add esi, eax
	mov al, [esi]
	cmp al, 20h
	je again
	cmp al, 0dh
	je again
	cmp al, 0ah
	je again
ret
getOffsetDim endp

;==========================Hidein-Str-Horizontal=====================================
horizontalS proc uses esi ebx ecx ebp
mov rand, 0
mov edi, count
again:
call getOffsetDim
mov ecx, 0
mov ebx, [esp+20]
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:

mov eax, offset Grid
add eax, lengthof Grid
dec eax
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 0dh
	je exit
	cmp bl, 0ah
	je exit
	cmp bl, 20h
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	add esi, 3
	inc edx
	cmp esi, eax
	ja exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov eax,offset wordOff
mov ebx, [esp+20]
mov count, edi
mov edx, count
add eax, edx
mov edx, 0
writeword:
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2
	
	mov [eax], esi
	mov [esi],cl
	add edx, 4
	add eax, 4
	add esi, 3
	inc ebx
	jmp writeword
exit2:
add count, edx
ret 4
horizontalS endp


;==========================Hidein-Rev-Horizontal=====================================
horizontalR proc uses esi ebx ecx ebp
mov rand, 0
mov edi, count
again:
call getOffsetDim
mov ecx, 0
mov ebx, [esp+20]
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:

mov eax, offset Grid
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 20h
	je exit
	cmp bl, 0dh
	je exit
	cmp bl, 0ah
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	sub esi, 3
	inc edx
	cmp esi, eax
	jb exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov eax,offset wordOff
mov ebx, [esp+20]
mov count, edi
mov edx, count
add eax, edx
mov edx, 0
writeword:
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2

	mov [eax], esi
	mov [esi],cl
	add eax, 4
	add edx, 4
	
	sub esi, 3
	inc ebx
	jmp writeword
exit2:
add count, edx 
ret 4
horizontalR endp

;==========================Hidein-Str-diagnoal=====================================
diagnoalS proc uses esi ebx ecx ebp
mov edi, count
startover:
mov rand, 0
again:
call getOffsetDim
mov ebx, [esp+20]
mov ecx, 0
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:

mov eax, offset Grid
add eax, lengthof Grid
dec eax
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 0dh
	je exit
	cmp bl, 20h
	je exit
	cmp bl, 0ah
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	add esi, 49
	inc edx
	cmp esi, eax
	ja exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov ebx, [esp+20]
mov edx,offset wordOff
mov ecx, 0
mov count, edi
mov eax, count
add edx, eax
mov eax, 0
writeword:
	cmp ch, 11
	je startover
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2
	
	mov [edx], esi
	mov [esi],cl
	add eax, 4
	add edx, 4

	add esi, 49
	inc ebx
	inc ch
	jmp writeword
exit2:
	add count, eax
ret 4
diagnoalS endp

;==========================Hidein-Rev-diagnoal=====================================
diagnoalR proc uses esi ebx ecx ebp
mov edi, count
startover:
mov rand, 0
again:
call getOffsetDim
mov ebx, [esp+20]
mov ecx, 0
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:

mov eax, offset Grid
add eax, lengthof Grid
sub eax, 20
dec eax
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 0dh
	je exit
	cmp bl, 20h
	je exit
	cmp bl, 0ah
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	add esi, 43
	inc edx
	cmp esi, eax
	ja exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov ebx, [esp+20]
mov edx,offset wordOff
mov count, edi
mov eax, count
add edx, eax
mov ecx, 0
mov eax, 0
writeword:
	cmp ch, 11
	je startover
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2
	
	mov [edx], esi
	mov [esi],cl
	add eax, 4
	add edx, 4

	add esi, 43
	inc ebx
	inc ch
	jmp writeword
exit2:

	add count, eax
ret 4
diagnoalR endp

;==========================HideinUpwardColumn=====================================
hideColU proc uses esi ebx ecx ebp
mov edi, count
mov rand, 0
again:
call getOffsetDim
mov ebx, [esp+20]
mov ecx, 0
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:
 

mov eax, offset Grid
add eax, lengthof Grid
dec eax
sub eax, 55
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 0dh
	je exit
	cmp bl, 20h
	je exit
	cmp bl, 0ah
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	add esi, 46
	inc edx
	cmp esi, eax
	ja exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov eax,offset wordOff
mov ebx, [esp+20]
mov count, edi
mov edx, count
add eax, edx
mov edx, 0
writeword:
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2
	
	mov [eax], esi
	mov [esi],cl
	add edx, 4
	add eax, 4

	add esi, 46
	inc ebx
	jmp writeword
exit2:
add count, edx
ret 4
hideColU endp


;==========================HideinDownwardColumn=====================================
hideCold proc uses esi ebx ecx ebp
mov rand, 0
mov edi, count
again:
call getOffsetDim
mov ebx, [esp+20]
mov ecx, 0
wirtetemp:
	mov al, [ebx]
	cmp al, 0dh
	je notexit
	inc ecx
	inc ebx
	jmp wirtetemp
notexit:

mov eax, offset Grid
add eax, 50
mov edx, 0
mov ebp, offset tempGrid
push esi
loop1:
	mov bl, [esi]
	cmp bl, 0dh
	je exit
	cmp bl, 20h
	je exit
	cmp bl, 0ah
	je exit
	cmp edx, ecx
	je exit
	mov [ebp], esi
	add ebp, 4
	sub esi, 46
	inc edx
	cmp esi, eax
	jb exit
jmp loop1
Exit:
pop esi
call matchOffset
cmp eax, 0
jne again
cmp edx, ecx
jl again

mov eax,offset wordOff
mov ebx, [esp+20]
mov count, edi
mov edx, count
add eax, edx
mov edx, 0
writeword:
	mov cl, [ebx]
	cmp cl, 0dh
	je exit2
	
	mov [eax], esi
	mov [esi],cl
	add edx, 4
	add eax, 4

	sub esi, 46
	inc ebx
	jmp writeword
exit2:
add count, edx
ret 4
hideCold endp


;==========================RandomShuffle=====================================
shuffleSort proc
mov esi, offset chosefile
mov eax, offset boolword
inc esi
mov ebx, 0
mov [eax], esi
charToWord:
	mov bl, [esi]
	inc esi
	cmp bl, 0dh
	jne charToWord
	inc bh
	inc esi
	add eax, 4
	mov [eax], esi
cmp bh, 7
jne charToWord

mov esi, offset boolword
movzx ecx, bh
looprev:
	mov eax, ecx
	call generaterandom
	shl eax, 2
	add eax, esi
	mov ebx, eax

	mov edx, ecx
	shl edx, 2
	add edx, esi
	mov ebp, [edx]
	mov edi, [ebx]
	mov [ebx], ebp
	mov [edx], edi
loop looprev
ret
shuffleSort endp

;==========================CheckWords=====================================
checkWords proc uses ebp
mov esi, offset theWord
mov edx, 0
mov ecx, length theWord
mov edx,0
mov ebx, offset checkWord	
wordhere:
	mov ah, [esi]	
	checkhere:
		cmp dh, 81
		je exit2
		mov al, [ebx]
		inc dh
		inc ebx
		cmp ah, al
		jne checkhere
		inc dl
	inc esi
loop wordhere
mov eax, 1
jmp exit


exit2:
mov eax, offset checkWord

mov ecx, lengthof theWord
mov ebx, offset theWord
mov edx, checkcount
add eax, edx
mov ebp, 0
writeword:
	mov dl, [ebx]
	mov [eax], dl

	add ebp, 4
	inc eax
	inc ebx
loop writeword
add checkcount, ebp
mov eax, 0

exit:
	
ret
checkWords endp

;==========================splitAnswer=====================================
splitAnswer proc
mov esi, offset buffer
mov ebx, offset theWord
mov edx, 0
writeToword:
	mov al, [esi]
	cmp al, 20h
	je writeEnd
	cmp al, 97
	jl noadd
	sub al, 32
	noadd:
	mov [ebx], al
	inc esi
	inc ebx
jmp writeToword

writeEnd:
inc esi
mov ebx, offset rowNo
mov eax, 0
mov ebp, 10

ridSpaces:
	mov cl, [esi]
	cmp cl, 20h
	jne writeToRow
	inc esi
jmp ridSpaces

writeToRow:
	mov cl, [esi]
	cmp cl, 20h
	je writeEnd1
	sub cl, '0'
	mul ebp
	movzx edx, cl
	add eax, edx
	inc esi
jmp writeToRow

writeEnd1:
mov [ebx], al

ridSpaces2:
	mov cl, [esi]
	cmp cl, 20h
	jne jmphere
	inc esi
jmp ridSpaces2

jmphere:
mov ebx, offset colNo
mov eax, 0
mov ebp, 10
writeToCol:
	mov cl, [esi]
	cmp cl, 20h
	je writeEnd2
	sub cl, '0'
	mul ebp
	movzx edx, cl
	add eax, edx
	inc esi
jmp writeToCol

writeEnd2:
mov [ebx], al

ridSpaces3:
	mov cl, [esi]
	cmp cl, 20h
	jne jmphere2
	inc esi
jmp ridSpaces3

jmphere2:
mov ebx, offset Direction
mov eax, 0
mov ebp, 10
writeToDir:
	mov cl, [esi]
	cmp cl, 0dh
	je end1
	sub cl, '0'
	mul ebp
	movzx edx, cl
	add eax, edx
	inc esi
jmp writeToDir

end1:
	mov [ebx], al
ret
splitAnswer endp
;==========================SearchWord=====================================
searchWord proc uses ebp
mov esi, offset buffer
mov ecx, 100
loop1:
	mov al, [esi]
	cmp al, '-'
	je endnow
	inc esi
loop loop1

call splitAnswer
mov dl, Direction

mov al, rowNo
mov ah, colNo

cmp dl, 5
jg endnow

cmp al, 14
jg endnow

cmp ah, 14
jg endnow

lout:
cmp dl, 1													;Horizontal
jne l1		
mov eax, 3
mov ebp, eax
call findWord
jmp exit

l1:
cmp dl, 5													;HorizontalR
jne l2					
mov eax,-3
mov ebp, eax
call findWord
jmp exit

l2:
cmp dl, 3													;VerticalS
jne l3
mov eax, 46
mov ebp, eax
call findWord
jmp exit


l3:
cmp dl, 0													;VerticalR
jne l4
mov eax, -46
mov ebp, eax
call findWord
jmp exit

l4:
cmp dl, 2													;DiagnoalS
jne l5
mov eax, 49
mov ebp, eax
call findWord
jmp exit

l5:															;DiagonalR
cmp dl, 4
jne endnow

mov eax, 43
mov ebp, eax
call findWord

exit:
cmp eax, 1													;ReturnTrue_findWord
jne noWord
call checkWords
cmp eax, 0
jne endnow

call highLight
add score, 10
call adjustScore
mov eax, 1
jmp endnow

noWord:
sub score, 10
call adjustScore


endnow:

ret 
searchWord endp
;==========================Highlight=====================================
highLight proc

movzx ecx, colNo
mov edi, ecx
shl edi, 1
add edi, ecx

mov ebx, offset theWord
mov ecx, 0
checklength:
	mov al, [ebx]
	cmp al, 0
	je preCon
	inc ecx
	inc ebx
jmp checklength

preCon:
mov esi, offset Grid
movzx eax, rowNo
mov edx, 46
mul edx
add esi, eax
mov eax, 2
mul colNo
movzx edx, colNo
add eax, edx
add esi, eax

infLoop:
	cmp ecx, 0
	je exit
	push ecx
	mov ebx, 0
	mov bl, 7
	shl bl, 4
	or bl, 0

	invoke GetStdHandle, -11
	invoke SetConsoleTextAttribute, eax, ebx

	cmp Direction, 1
	jne l1
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		add di, 3
		pop eax
	l1:
	cmp Direction, 5
	jne l2
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		sub di, 3
		pop eax
	l2:
	cmp Direction, 3
	jne l3
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		inc rowNo
		pop eax
	l3:
	cmp Direction, 0
	jne l4
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		dec rowNo
		pop eax
	l4:
	cmp Direction, 2
	jne l5
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		inc rowNo
		add di, 3
		pop eax
	l5:
		cmp Direction, 4
		jne l6
		push eax
		movzx ax, rowNo
		mov ebx, 12
		add bx, ax
		rol ebx, 16
		mov bx, di
		inc rowNo
		sub di, 3
		pop eax
	l6:
	invoke GetStdHandle, -11
	invoke SetConsoleCursorPosition, eax, ebx

	mov dl, [esi]
	mov char, dl
	add esi, ebp

	invoke GetStdHandle, -11
	invoke WriteConsoleA, EAX, offset char, lengthof char, offset x, 0
	
	pop ecx
	dec ecx
jmp infLoop

exit:


mov ebx, offset theWord
mov ecx, 0
checklength1:
	mov al, [ebx]
	cmp al, 0
	je startsearch
	inc ecx
	inc ebx
jmp checklength1

push ecx
startsearch:
mov esi, offset theWord
mov edx,0
mov ebx, offset chosefile
push ecx
wordhere:
	checkhere:
		mov ah, [esi]
		mov al, [ebx]
		inc ebx
		cmp al, 0dh
		jne l12
		inc dh
		l12:
		cmp ah, al
		jne checkhere
		inc dl
		inc esi
loop wordhere
movzx edx, dh

add edx, 3
mov ebx, edx
rol ebx,16
mov bx, 0
mov esi, offset theWord

pop ecx
loopfile:
	push ecx
	invoke GetStdHandle, -11
	invoke SetConsoleCursorPosition, eax, ebx
	inc bx

	mov edx, 0
	mov dl, 7
	shl dl, 4
	or dl, 0

	invoke GetStdHandle, -11
	invoke SetConsoleTextAttribute, eax, edx

	mov dl, [esi]
	mov char, dl
	inc esi

	invoke GetStdHandle, -11
	invoke WriteConsoleA, EAX, offset char, lengthof char, offset x, 0
	pop ecx
loop loopfile


;invoke GetStdHandle, -11
;invoke SetConsoleTextAttribute, eax, ebx


ret
highLight endp
;==========================findWord=====================================
findWord proc uses ebp ecx
mov esi, offset Grid
push eax
movzx eax, rowNo
mov edx, 46
mul edx
add esi, eax
mov eax, 2
mul colNo
movzx edx, colNo
add eax, edx
add esi, eax

mov ebx, offset theWord
mov ecx, 0
checklength:
	mov al, [ebx]
	cmp al, 0
	je startsearch
	inc ecx
	inc ebx
jmp checklength


startsearch:
call substrr
cmp eax, 0
pop eax
je exit

mov edx, 0
mov ebx, offset theWord
checkHere:
	mov dl, [esi]
	mov dh, [ebx]
	cmp dh, dl
	jne exit
	add esi, eax
	inc ebx
loop checkHere
mov eax, 1
exit:

ret
findWord endp

;===========================AdjustScore=====================================
adjustScore proc

mov esi, offset bytescore
mov ecx, lengthof bytescore
loo:
mov al,0
mov [esi],al
inc esi
loop loo
dec esi
mov eax, '0'
mov [esi],al
mov edx,0
mov ax, word ptr score
cmp ax, 0
jnl convertTobyte
mov bx, -1
imul bx
convertTobyte:
mov dx,0
cmp ax,10
jl converted
mov bx,10
div bx
add dx, 48
mov [esi],dl
dec esi
jmp convertTobyte

converted:
add al, 48
mov [esi],al
dec esi
cmp score, 0
jnl donotAddsign
mov al,'-'
mov [esi],al
donotAddsign:

ret
adjustScore endp

;==========================StartGame=====================================
startGame proc
mov eax, 0

checkTime:
cmp endTime, 600000
jge exit

cmp eax, 8
je exit
push eax

mov ebx, 0
mov bl, 7
shl bl, 4
or bl, 0

invoke GetStdHandle, -11
invoke SetConsoleTextAttribute, eax, ebx

mov ebx, 2
rol ebx, 16
mov bx, 69

invoke GetStdHandle, -11
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset bytescore, lengthof bytescore, offset x, 0


mov ebx, 28
rol ebx,16
mov bx, 82


invoke GetStdHandle, -11 ;
invoke SetConsoleCursorPosition, eax, ebx

mov ecx, lengthof theWord
mov edi, offset theWord
mov bl, 0
loopp:
	mov [edi], bl
	inc edi
loop loopp

mov direction, 0
mov colNo, 0
mov rowNo, 0

mov ebx, 0
mov bl, 0
shl bl, 4
or bl, 7

invoke GetStdHandle, -11
invoke SetConsoleTextAttribute, eax, ebx

invoke GetStdHandle, -10
invoke ReadConsoleA, EAX, offset buffer, lengthof buffer, offset x, 0

mov ebx, 28
rol ebx,16
mov bx, 82


invoke GetStdHandle, -11 
invoke SetConsoleCursorPosition, eax, ebx

invoke GetStdHandle, -11
invoke WriteConsoleA, EAX, offset empSpace, lengthof empSpace, offset x, 0

call searchWord
cmp eax, 1
jne l1
pop eax
inc eax
push eax

l1:
invoke GetTickCount
mov endTime, eax
mov ecx, startTime
sub endTime, ecx

pop eax
jmp checkTime

exit:
ret
startGame endp
;==========================SubstringAlgo_MatchwordsToOrignal=====================================
  substrr PROC uses edx esi ecx ebx
	mov	ebx, offset theWord       ;substring
	mov esi, offset chosefile		;orgstr
	mov edx, 0
	mov eax, 0
	mov edi, ecx
	mov ecx, 0
	l1:
		cmp eax, edi
		je succ
		mov cl, [esi]
		cmp cl, 0
		je outt
		mov ch, [ebx+edx]
		cmp ch, cl
		jne l11
		;push ecx
		mov ch, [ebx+edx+1]
		
		;pop ecx
		
		inc esi
		inc edx
		inc eax
		jmp l1
		l11:
			cmp edx, 0
			jna l12
			mov edx, 0
			mov eax, 0
			jmp l1
		l12:
			inc esi
			jmp l1
	succ:
		mov eax, 1
	outt:
 ret
 substrr ENDP


end main
