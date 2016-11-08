;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
; 32-bit Assembly Example
;
; Empty asm example.
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
IDEAL
P386
MODEL FLAT, C
ASSUME cs:_TEXT,ds:FLAT,es:FLAT,fs:FLAT,gs:FLAT

;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
; CODE
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
CODESEG

;鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍?
; Entry To ASM Code
; In:
;   CS - Code Selector    Base: 00000000h - Limit: 4G
;   DS - Data Selector    Base: 00000000h - Limit: 4G
;   ES - PSP Selector     Base: PSP Seg   - Limit: 100h
;   FS - ?
;   GS - ?
;   SS - Data Selector    Base: 00000000h - Limit: 4G
;   ESP -> STACK segment
;   Direction Flag - ?
;   Interrupt Flag - ?
;
;   All Other Registers Are Undefined!
;鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍鞍?
start:

        sti                             ; Set The Interrupt Flag
        cld                             ; Clear The Direction Flag

        push ds 						; Put value of DS register on the stack
        pop es 							; And write this value to ES


		; Your code comes here


        mov eax, 4c00h                  ; AH = 4Ch - Exit To DOS
        int 21h                         ; DOS INT 21h

;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
; DATA
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
DATASEG


;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
; STACK
;北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
STACK 1000h

END start

