.section .data
.syntax unified
.thumb

// Definiert bits von BIT0 bis BIT31
.altmacro
.macro define_bit a
    .equ BIT\a, (1 << \a)
.endm

.set i, 0
.rept 32
    define_bit %i
    .set i, i + 1
.endr

// Definition der Basisadressen und Offsets
.equ RCGC_GPIO_R, 0x400FE608    
.equ RCGC_GPIO_PORT_F, BIT5     

.equ GPIO_PORT_F_BASE, 0x40025000
.equ GPIO_DATA_OFF, 0x3FC       
.equ GPIO_DIR_OFF, 0x400        
.equ GPIO_DEN_OFF, 0x51C       
.equ GPIO_PORT_F_DATA_R, GPIO_PORT_F_BASE + GPIO_DATA_OFF
.equ GPIO_PORT_F_DIR_R, GPIO_PORT_F_BASE + GPIO_DIR_OFF
.equ GPIO_PORT_F_DEN_R, GPIO_PORT_F_BASE + GPIO_DEN_OFF

// SysTick Register
.equ ST_BASE, 0xE000E000
.equ ST_CTRL_OFF, 0x10         
.equ ST_RELOAD_OFF, 0x14       
.equ ST_CURRENT_OFF, 0x18      
.equ ST_CTRL_R, ST_BASE + ST_CTRL_OFF
.equ ST_RELOAD_R, ST_BASE + ST_RELOAD_OFF
.equ ST_CURRENT_R, ST_BASE + ST_CURRENT_OFF

// SysTick Control bits
.equ ST_CTRL_ENABLE, BIT0      
.equ ST_CTRL_CLK_SRC, BIT2   
.equ ST_CTRL_COUNT, BIT16      


s:
.word 0  
ms:
.word 0  

.section .text
.global main
.global sys_tick_handler
.align

init_hardware:
    // GPIO-Takt aktivieren
    ldr r0, =RCGC_GPIO_R
    ldr r1, [r0]
    orr r1, r1, #RCGC_GPIO_PORT_F
    str r1, [r0]

    // GPIO-Pin konfigurieren (Pin 1 als Ausgang)
    ldr r0, =GPIO_PORT_F_DIR_R
    ldr r1, [r0]
    orr r1, r1, #BIT1
    str r1, [r0]

    // GPIO-Pin digital aktivieren
    ldr r0, =GPIO_PORT_F_DEN_R
    ldr r1, [r0]
    orr r1, r1, #BIT1
    str r1, [r0]

    // SysTick konfigurieren
    ldr r0, =ST_RELOAD_R      // Lade SysTick Reload-Register
    ldr r1, =16000            // siehe Rechnung in documents/notes-assemlby.md##Abgabe 2
    str r1, [r0]              // Schreibe Reload-Wert

    ldr r0, =ST_CTRL_R        // Lade SysTick Control Register
    mov r1, #(ST_CTRL_ENABLE | ST_CTRL_CLK_SRC) // Timer aktivieren, Systemtakt verwenden 
    str r1, [r0]              // Schreibe den Wert ins Control Register

    bx lr                     // Rücksprung

main:
    bl init_hardware          // Hardware initialisieren
    bl diff_push_sequence
    bl measure_nop_ldr_str

main_loop:
wait_for_systick_flag:
    // Prüfen, ob SysTick heruntergezählt hat (COUNTFLAG)
    ldr r0, =ST_CTRL_R
    ldr r1, [r0]
    tst r1, #ST_CTRL_COUNT    // COUNTFLAG prüfen (tst: Test)
    beq wait_for_systick_flag // Warten, falls COUNTFLAG nicht gesetzt

    bl sys_tick_handler       // SysTick-Handler aufrufen
    b main_loop               // Hauptschleife fortsetzen

sys_tick_handler:
    // Register sichern
    push {r0, r1, lr}

    // Millisekunden hochzählen
    ldr r0, =ms               // Adresse der ms-Variable
    ldr r1, [r0]              
    add r1, r1, #1            // ms um 1 inkrementieren
    str r1, [r0]              

    // Prüfen, ob 1000 ms erreicht wurden
    cmp r1, #1000             // 1000 ms = 1 Sekunde
    blt end_handler           // Noch nicht 1 Sekunde? Beenden (blt: falls r1 kleiner als 1000)

    // Millisekunden zurücksetzen
    mov r1, #0
    str r1, [r0]

    // Sekunden hochzählen
    ldr r0, =s
    ldr r1, [r0]
    add r1, r1, #1
    str r1, [r0]

    // LED-Zustand umschalten
    ldr r0, =GPIO_PORT_F_DATA_R
    ldr r1, [r0]
    eor r1, r1, #BIT1         // LED umschalten (eor: Exclusiv OR)
    str r1, [r0]

end_handler:
    // Register wiederherstellen
    pop {r0, r1, lr}
    bx lr                     // Rücksprung

// Funktionen um die Aufgabe mit dem Debugger zu lösen
// Funktionen wurden so geschrieben, dass man mit dem debugger einfach nur durchlaufen muss

diff_push_sequence:
    ldr r0, =GPIO_PORT_F_DATA_R
    ldr r1, [r0]
    push {r0, r1}
    push {r1, r0}

measure_nop_ldr_str:
    // Startzeit erfassen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Speichere den aktuellen SysTick-Wert
    mov r4, r0                 // Speichere die Startzeit in r4
    
    // NOP-Befehl messen
    nop
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für NOP
    sub r0, r0, r4             // Berechne die Zyklen
    mov r5, r0                 // Speichere die Anzahl der Zyklen für NOP
    
    // LDR-Befehl messen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Speichere den Startwert für LDR
    ldr r1, [sp]               // Lade den Wert vom Stack in r1 ([sp] stack pointer)
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für LDR
    sub r0, r0, r4             // Berechne die Zyklen für LDR
    mov r6, r0                 // Speichere die Zyklen für LDR
    
    // STR-Befehl messen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Speichere den Startwert für STR
    str r1, [sp, #-4]          // Speichere r1 auf dem Stack (Adresse 4 Bytes unter sp) -> Sp wird nicht verändert
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für STR
    sub r0, r0, r4             // Berechne die Zyklen für STR
    mov r7, r0                 // Speichere die Zyklen für STR
    
    // STR!-Befehl messen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Startwert für STR!
    str r1, [sp, #-4]!         // Speichern von r1 auf Stack (Adresse 4 Bytes unter sp, verschiebung vor dem eingriff) -> sp wird vorher um 4 veringert
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für STR!
    sub r0, r0, r4             // Berechne die Zyklen für STR!
    mov r8, r0                 // Speichere die Zyklen für STR!
    
    // Ergebnisse in den Registern r5 (NOP), r6 (LDR), r7 (STR), r8 (STR!)
    bx lr

measure_mul_sdiv:
    // Startzeit erfassen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Speichere den aktuellen SysTick-Wert
    mov r4, r0                 // Speichere die Startzeit in r4
    
    // MUL-Befehl messen
    mul r1, r2, r3             // Multipliziere r2 und r3 und speichere das Ergebnis in r1
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für MUL
    sub r0, r0, r4             // Berechne die Zyklen für MUL
    mov r5, r0                 // Speichere die Zyklen für MUL
    
    // SDIV-Befehl messen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Startwert für SDIV
    sdiv r1, r2, r3            // Teile r2 durch r3 und speichere das Ergebnis in r1
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für SDIV
    sub r0, r0, r4             // Berechne die Zyklen für SDIV
    mov r6, r0                 // Speichere die Zyklen für SDIV
    
    // Ergebnisse in den Registern r5 (MUL), r6 (SDIV)
    bx lr

measure_push_cycles:
    // Startzeit erfassen
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Speichere den aktuellen SysTick-Wert
    mov r4, r0                 // Speichere die Startzeit in r4
    
    // Push mit einem Register
    push {r1}                  // Speichert r1 auf dem Stack
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für Push 1 Register
    sub r0, r0, r4             // Berechne die Zyklen
    mov r5, r0                 // Speichere die Zyklen für Push 1 Register
    
    // Push mit zwei Registern
    push {r1, r2}              // Speichert r1 und r2 auf dem Stack
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für Push 2 Register
    sub r0, r0, r4             // Berechne die Zyklen
    mov r6, r0                 // Speichere die Zyklen für Push 2 Register
    
    // Push mit vier Registern
    push {r1, r2, r3, r4}      // Speichert r1, r2, r3 und r4 auf dem Stack
    ldr r0, =ST_CURRENT_R
    ldr r0, [r0]               // Ende der Messung für Push 4 Register
    sub r0, r0, r4             // Berechne die Zyklen
    mov r7, r0                 // Speichere die Zyklen für Push 4 Register
    
    // Ergebnisse in den Registern r5 (Push 1 Register), r6 (Push 2 Register), r7 (Push 4 Register)
    bx lr