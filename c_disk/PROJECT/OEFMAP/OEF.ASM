IDEAL
P386
MODEL FLAT, C
ASSUME cs:_TEXT,ds:FLAT,es:FLAT,fs:FLAT,gs:FLAT

;*******************************************************************************
;*                     PROGRAMMEERPROJECT COMPUTERSYSTEMEN                     *
;*                                    PONG                                     *
;*                      By Senne Deproost and Seppe Seghers                    *
;*******************************************************************************


; # =============================================================================
; CODE
; # =============================================================================
CODESEG


start:

        sti                             ; Set The Interrupt Flag
        cld                             ; Clear The Direction Flag

        push ds 					             	; Put value of DS register on the stack
        pop es 					            		; And write this value to ES


		    ; Your code comes here


        mov eax, 4c00h                  ; AH = 4Ch - Exit To DOS
        int 21h                         ; DOS INT 21h

; # =============================================================================
; DATA
; # =============================================================================
DATASEG


; # =============================================================================
; STACK
; # =============================================================================
STACK 1000h

END start
