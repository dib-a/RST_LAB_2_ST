.section .data
.syntax unified
.thumb

// definiert BIT0 bis BIT31
.altmacro
.macro define_bit a
    .equ BIT\a, (1 << \a)
.endm

.set i, 0
.rept 32
    define_bit %i
    .set i,i+1
.endr

.equ RCGC_GPIO_R, 0x400FE608
.equ RCGC_GPIO_PORT_A, BIT0
.equ RCGC_GPIO_PORT_B, BIT1
.equ RCGC_GPIO_PORT_C, BIT2
.equ RCGC_GPIO_PORT_D, BIT3
.equ RCGC_GPIO_PORT_E, BIT4
.equ RCGC_GPIO_PORT_F, BIT5

.equ LED_R, BIT1
.equ LED_B, BIT2
.equ LED_G, BIT3

.equ GPIO_PORT_F_BASE,   0x40025000
.equ GPIO_DATA_OFF,       0x3FC
.equ GPIO_DIR_OFF,        0x400
.equ GPIO_PUR_OFF,        0x510
.equ GPIO_DEN_OFF,        0x51C
.equ GPIO_PORT_F_DATA_R, GPIO_PORT_F_BASE + GPIO_DATA_OFF
.equ GPIO_PORT_F_DIR_R,  GPIO_PORT_F_BASE + GPIO_DIR_OFF
.equ GPIO_PORT_F_PUR_R,  GPIO_PORT_F_BASE + GPIO_PUR_OFF
.equ GPIO_PORT_F_DEN_R,  GPIO_PORT_F_BASE + GPIO_DEN_OFF

.equ ST_BASE,           0xE000E000
.equ ST_CTRL_OFF,       0x10
.equ ST_RELOAD_OFF,     0x14
.equ ST_CURRENT_OFF,    0x18
.equ ST_CTRL_R,         ST_BASE + ST_CTRL_OFF
.equ ST_RELOAD_R,       ST_BASE + ST_RELOAD_OFF
.equ ST_CURRENT_R,      ST_BASE + ST_CURRENT_OFF 
.equ ST_CTRL_ENABLE,    BIT0
.equ ST_CTRL_INTEN,     BIT1
.equ ST_CTRL_CLK_SRC,   BIT2
.equ ST_CTRL_COUNT,     BIT16

s:
.word 0
ms:
.word 0

.section .text
.global main
.global sys_tick_handler
.align

// Hardware initialisieren
init_hardware:
    // GPIO-Clock aktivieren
    LDR R0, =RCGC_GPIO_R
    LDR R1, =RCGC_GPIO_PORT_F
    STR R1, [R0]
    NOP
    NOP

    // Setze GPIO-Pin PF1 (Rot) als Ausgang
    LDR R0, =GPIO_PORT_F_DIR_R
    LDR R1, [R0]
    ORR R1, R1, (LED_R | LED_G | LED_B)
    STR R1, [R0]

    // Digitale Funktion für PF1 aktivieren
    LDR R0, =GPIO_PORT_F_DEN_R
    LDR R1, [R0]
    ORR R1, R1, (LED_R |LED_G | LED_B)
    STR R1, [R0]

    BX LR

// Subroutine: SysTick-Handler
sys_tick_handler:
    PUSH {R4, LR}         // Sicherung von Registern

    // ms++
    LDR R0, =ms
    LDR R1, [R0]
    ADD R1, R1, #1
    STR R1, [R0]

//    CMP R1, #1000         // Eigentlich 1000ms = 1s
    CMP R1, #300
    BNE update_led

    // ms auf 0 setzen und s++
    MOV R1, #0
    STR R1, [R0]
    LDR R0, =s
    LDR R1, [R0]
    ADD R1, R1, #1
    STR R1, [R0]

update_led:
    // Toggle LED basierend auf den aktuellen Sekundenwert (s)
    LDR R0, =s
    LDR R1, [R0]
    ANDS R1, R1, #1         // Prüfen, ob die aktuelle Sekunde ungerade oder gerade ist
    LDR R0, =GPIO_PORT_F_DATA_R
    BEQ turn_off_led

    // LED einschalten
    LDR R1, [R0]
    ORR R1, R1, (LED_R | LED_G | LED_B)	
    STR R1, [R0]
    B end_handler

turn_off_led:
    // LED ausschalten
    LDR R1, [R0]
    BIC R1, R1, (LED_R | LED_G | LED_B)
    STR R1, [R0]

end_handler:
    POP {R4, LR}          // Wiederherstellen der Register
    BX LR                 // Rückkehr zum Aufrufer

// Hauptprogramm
main:
    BL init_hardware       // Hardware initialisieren

main_loop:
    BL sys_tick_handler
    BL delay_1ms
    B main_loop

delay_1ms:
    MOV R0, #16000         // Anzahl der Zyklen für 1 ms (16 MHz)
delay_loop:
    SUBS R0, R0, #1
    BNE delay_loop         // Warten, bis R0 == 0
    BX LR

.end