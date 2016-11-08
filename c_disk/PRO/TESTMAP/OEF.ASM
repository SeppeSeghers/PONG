IDEAL
P386
MODEL FLAT, C
ASSUME cs:_TEXT,ds:FLAT,es:FLAT,fs:FLAT,gs:FLAT

; # =============================================================================
; CODE
; # =============================================================================
CODESEG

; # =============================================================================
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
; # =============================================================================
start:

        sti                             ; Set The Interrupt Flag
        cld                             ; Clear The Direction Flag

        push ds 					             	; Put value of DS register on the stack
        pop es 					            		; And write this value to ES


        main:
    xor     ax, ax
    mov     es, ax

    cli                         ; update ISR address w/ ints disabled
    push    word ptr es:[9*4+2]     ; preserve ISR address
    push    word ptr es:[9*4]
    mov     word ptr es:[9*4], offset irq1isr
    mov     es:[9*4+2],cs
    sti

    call    test0

    cli                         ; update ISR address w/ ints disabled
    pop     word ptr es:[9*4]   ; restore ISR address
    pop     word ptr es:[9*4+2]
    sti

    ret

test0:
    mov     ah, 9
    mov     dx, offset msg1
    int     21h                 ; print "Press and hold ESC"

test1:
    mov     al, [kbdbuf + 1]    ; check Escape key state (Esc scan code = 1)
    or      al, al
    jz      test1               ; wait until it's nonzero (pressed/held)

    mov     dx, offset msg2
    int     21h                 ; print "ESC pressed, release ESC"

test2:
    mov     al, [kbdbuf + 1]    ; check Escape key state (Esc scan code = 1)
    or      al, al
    jnz     test2               ; wait until it's zero (released/not pressed)

    mov     dx, offset msg3     ; print "ESC released"
    int     21h

    ret

irq1isr:
    pusha

    ; read keyboard scan code
    in      al, 60h

    ; update keyboard state
    xor     bh, bh
    mov     bl, al
    and     bl, 7Fh             ; bx = scan code
    shr     al, 7               ; al = 0 if pressed, 1 if released
    xor     al, 1               ; al = 1 if pressed, 0 if released
    mov     cs:[bx+kbdbuf], al

    ; send EOI to XT keyboard
    in      al, 61h
    mov     ah, al
    or      al, 80h
    out     61h, al
    mov     al, ah
    out     61h, al

    ; send EOI to master PIC
    mov     al, 20h
    out     20h, al

    popa
    iret

kbdbuf      db 128 dup (0)

msg1 db "Press and hold ESC", 13, 10, "$"
msg2 db "ESC pressed, release ESC", 13, 10, "$"
msg3 db "ESC released", 13, 10, "$"

code ends

end main


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
