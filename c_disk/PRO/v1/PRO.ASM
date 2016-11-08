IDEAL
P386
MODEL FLAT, C
ASSUME cs:_TEXT,ds:FLAT,es:FLAT,fs:FLAT,gs:FLAT

;*******************************************************************************
;*                     PROGRAMMEERPROJECT COMPUTERSYSTEMEN                     *
;*                                    PONG                                     *
;*                     By Senne Deproost and Seppe Seghers                     *
;*******************************************************************************




; # =============================================================================
; CODE
; # =============================================================================
CODESEG

;
; Procedure to wait for a v-blank event (synchronizes game loop to 60Hz in mode 13h)
PROC waitVBlank
	USES eax, edx

	mov dx, 03dah
	@@waitVBlank_wait1:
	in al, dx
	and al, 8
	jnz @@waitVBlank_wait1
	@@waitVBlank_wait2:
	in al, dx
	and al, 8
	jz @@waitVBlank_wait2
	ret
ENDP waitVBlank

PROC setupVideo
	USES eax

	mov	ax, 13h
	int	10h

	ret
ENDP setupVideo

PROC unsetupVideo
	USES eax

	mov	ax, 03h
	int	10h

	ret
ENDP unsetupVideo

; Procedure to exit the program
PROC exit
	USES eax

	call unsetupVideo
	mov	eax, 4c00h
	int 21h
	ret
ENDP exit

; Procedure to initialize a new game
PROC initGameState
	ret
ENDP initGameState

PROC moveBlock ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	ARG amount:dword
	USES eax, edx
mov ah, 9     ; Print string on screen
mov edx, offset moveMsg
int 21h
	ret
ENDP moveBlock

PROC rotateBlock
	USES eax, edx
mov ah, 9     ; Print string on screen
mov edx, offset rotateMsg
int 21h
	ret
ENDP rotateBlock

; Procedure to handle user input
PROC handleUserInput
	USES eax
	mov ah, 01h ; function 01h (test key pressed)
	int 16h		; call keyboard BIOS
	jz @@no_key_pressed
	mov ah, 00h
	int 16h
	cmp ah, 01	; scancode for ESCAPE key
	jne	@@n1
	call exit
	jmp @@no_key_pressed
@@n1:
	cmp ah, 77	; arrow right
	jne @@n2
	call moveBlock, 1
	jmp @@no_key_pressed
@@n2:
	cmp ah, 75	; arrow left
	jne @@n3
	call moveBlock, -1
	jmp @@no_key_pressed
@@n3:
	cmp ah, 80	; arrow down
	jne @@n4
	call moveBlock, 10
	jmp @@no_key_pressed
@@n4:
	cmp ah, 72	; arrow up
	jne @@n5
	call rotateBlock
	jmp @@no_key_pressed
@@n5:
@@no_key_pressed:
	ret
ENDP handleUserInput

; Procedure to update the game world status (like enemies, collisions, events, ...)
PROC updateGameState
	USES eax, edx
  inc [gameLoopCounter]
  mov ah, 9
  mov edx, offset pointMsg
  int 21h
	ret
ENDP updateGameState

; Procedure to draw everything on screen
PROC drawAll
	call waitVBlank
	ret
ENDP drawAll

;+-+-+-+-+- ACHTERGROND -+-+-+-+-+

PROC fillBackground
  ARG @@Colour:word         ;fillBackground, @@Colour = Kleur van de achtergrond
  USES eax, ebx, ecx, edx, esi, edi



  ; 2.Adress van het scherm naar edi = destination index
  mov edi, 0A0000h ; Wijst naar destination

  ; 3.Aantal pixels in ecx
  mov eax, [SCREENWIDTH]
  mov ebx, [SCREENHEIGHT]
  mul ebx
  mov ecx, eax

  ; 1.De kleur -> ax
  mov ax, [@@Colour] ; dicht bij stosb



  rep stosb
  ret
ENDP fillBackground

;+-+-+-+-+-+- PALETTE -+-+-+-+-+-+

PROC updatePalette
  ARG @@Ncolours:word ; @@ is lokaal gedefinieerd
  LOCAL @@blabla:dword, @@babab:byte
  USES eax, ebx, ecx, edx, esi ; Welke registers worden in de functie gebruikt

  ; 1.Index eerste kleur naar poort 3C8h
  mov al, 00h       ; Plaats index in al
  mov dx, 03C8h    ; poortnummer (adres) in edx.
  out dx, al

  ; 2.Communiceer palet naar VGA-adapter (kaart)
  mov esi, offset palette ; adres van palet als bron

  mov ax, [@@Ncolours]
  mov ebx, 3
  ;xor ebx, edx
  mul ebx
  mov ecx, eax ; # te communicerende bytes -> ecx

  mov dx, 03C9h ; Poortnummer naar edx

  rep outsb

    ret
ENDP updatePalette                      ; DOS INT 21h

;+-+-+-+-+-+-+- LOOP -+-+-+-+-+-+-+

;+-+-+-+-+-+-+- PPLA -+-+-+-+-+-+-+

; Paddle player

;+-+-+-+-+-+-+- PCOM -+-+-+-+-+-+-+

;Paddle computer

;+-+-+-+-+-+-+- MAIN -+-+-+-+-+-+-+ ; Nog van toepassing?

PROC main

        sti                             ; Set The Interrupt Flag
        cld                             ; Clear The Direction Flag

        push ds 					             	; Put value of DS register on the stack
        pop es 					            		; And write this value to ES






		    ; Schakel naar de grafische mode
      ;  mov ah, 000h                    ; Naar de grafische mode
      ;  mov al, 013h                    ; Video mode flag (AL is de parameter die gegeven wordt aan de grafische mode)
      ;  int 10h                         ; Schakel de grafische mode in (interrupt call)

        ; Updaten palette (aanspreken videokaart)
      ;  call updatePalette, 2           ; Argument zegt hoeveel kleuren wegschrijven

        ; Kleur de achtergrond
      ;  call fillBackground, 1          ; 2 is de code voor groen

        ; Wachten op en toets
        mov ah, 000h ;!!!!!!!!!!!!!!!!!!!!!!!!!!! in al de specifieke cont toets zetten
        int 16h

        ; Terug naar de textmodus
        mov ah, 000h
        mov al, 003h
        int 10h

        ; Afsluiten
        mov ax, 4c00h                  ; AH = 4Ch - Exit To DOS
        int 21h                        ; DOS INT 21h
ENDP main

; MAIN Start of program
start:
    sti                             ; Set The Interrupt Flag
    cld                             ; Clear The Direction Flag

    push ds 						; Put value of DS register on the stack
    pop es 							; And write this value to ES

	; Setup and initialization
	call setupVideo
	call initGameState
  call updatePalette, 2
  call fillBackground, 3

	; Main game (endless) loop
	@@gameLoop:
	call handleUserInput
	call updateGameState
	call drawAll
  call fillBackground, 3
	jmp @@gameLoop

; # =============================================================================
; DATA
; # =============================================================================
DATASEG

  SCREENWIDTH dd 320
  SCREENHEIGHT dd 200
  palette db 0, 0, 0, 63, 63, 63 ;Zwart en wit

  ; Counts the gameloops. Useful for timing and planning events.
	gameLoopCounter		dd 0

	; Debug messages
	moveMsg		db 'moveBlock$'
	rotateMsg	db 'rotateBlock$'
	pointMsg	db '.$'

; # =============================================================================
; STACK
; # =============================================================================
STACK 1000h

END start
