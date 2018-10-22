;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data
message  BYTE "Unesite pomeraj, n=", 0
messageSize DWORD ($-message)

error  BYTE "Greska! Neispravan unos!", 0
errorSize DWORD ($-error)

key BYTE ? 
keySize WORD ($-key)

consoleHandle HANDLE 0

bytesWritten BYTE ?

n DWORD ?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code
main PROC
     ; Get n from the console using ReadInt
	mov	edx, OFFSET message
	call	WriteString		; display string
	call	ReadInt			; read integer into eax
	mov esi, eax			; store in esi
	mov n, esi               ; store in n

check: ; Check if the n is less than 0 or bigger than 26
	cmp n, 0
	jl err
	cmp n, 26
	jb start
	mov eax, n
	sub eax, 26
	mov n, eax
	jmp check
	
start: ; Start	
	; Get the console output handle
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax

read: ; Read the key
	call	ReadKey ; wait for a keypress
	jz read
	mov n, esi
	cmp al, 65  
	jb stop
	cmp al, 90   
	jbe con2
	cmp al, 97  
	jb stop
	cmp al, 122  
	ja stop

con1: ; Convert the lover-case
	add al, BYTE PTR n
	cmp al, 122
	jbe write
	sub al, 26
	jmp write

con2: ; Convert the upper-case	 
	add al, BYTE PTR n
	cmp al, 90
	jbe write
	sub al, 26

write: ; Display replaced character
	mov key, al
	INVOKE WriteConsole,
	 consoleHandle,
	 ADDR key,
	 keySize,
	 ADDR bytesWritten,
	 0
	jmp read

err: ; Display the error message
	; Get the console output handle
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	
	INVOKE WriteConsole,
	 consoleHandle,
	 ADDR error,
	 errorSize,
	 ADDR bytesWritten,
	 0

stop: ; Exit program
	INVOKE ExitProcess, 0

main ENDP

END main