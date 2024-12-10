# Übersicht der Kommentare und Funktionen

## 1. **Initialisierung der Hardware: `init_hardware`**

- **GPIO-Takt aktivieren**:
  - Lädt den Wert des Register `RCGC_GPIO_R`.
  - Aktiviert den Takt für Port F (bit 5).

- **GPIO-Pin konfigurieren (Pin 1 als Ausgang)**:
  - Lädt das Register `GPIO_PORT_F_DIR_R`.
  - Setzt den Wert für Pin 1 als Ausgang.

- **GPIO-Pin digital aktivieren**:
  - Lädt das Register `GPIO_PORT_F_DEN_R`.
  - Aktiviert den Pin 1 als digitalen Pin.

- **SysTick konfigurieren**:
  - Lädt das Register `ST_RELOAD_R` und setzt es auf `16000` (entsprechend einer Millisekunde bei 16 MHz Systemtakt).
  - Aktiviert den SysTick Timer mit `ST_CTRL_R` und setzt `ST_CTRL_ENABLE | ST_CTRL_CLK_SRC` (Systemtakt verwenden).

---

## 2. **Hauptprogramm: `main`**

- **Hardware initialisieren**: Ruft `init_hardware` auf.
- **Messfunktionen aufrufen**: Ruft `diff_push_sequence` und `measure_nop_ldr_str` auf.

---

## 3. **SysTick-Handler: `sys_tick_handler`**

- **Register sichern**: Sichert die Register `r0`, `r1`, und `lr` auf dem Stack.
- **Millisekunden zählen**:
  - Liest den Wert von `ms` und inkrementiert ihn.
  - Wenn `ms` 1000 erreicht, setzt es zurück und zählt Sekunden hoch.
- **LED umschalten**:
  - Liest den Wert von `GPIO_PORT_F_DATA_R` und schaltet die LED um, indem das bit für Pin 1 (LED) mit `eor` invertiert wird.
- **Register wiederherstellen**: Stellt die gesicherten Register wieder her.
- **Rückkehr**: Springt zurück zum Aufrufer.

---

## 4. **Messfunktionen**

### 4.1 **`diff_push_sequence`**

- **Unterschiede im `push` Befehl**:
  - `push {r0, r1}`: Push von `r0` und `r1`.
  - `push {r1, r0}`: Push von `r1` und `r0`.
- **Unterschied beobachten**: Einfach nur durchlaufen, um Unterschiede im Speicherbereich zu sehen.

### 4.2 **`measure_nop_ldr_str`**

- **NOP Befehl messen**:
  - Startzeit messen (SysTick).
  - Führe `nop` aus und berechne die Zyklen.
- **LDR Befehl messen**:
  - Lade einen Wert von `sp` (Stack Pointer) und berechne die Zyklen.
- **STR Befehl messen**:
  - Speichere `r1` auf den Stack (`str r1, [sp, #-4]`) und berechne die Zyklen.
- **STR! Befehl messen**:
  - Speichere `r1` auf den Stack mit `str r1, [sp, #-4]!` und berechne die Zyklen.
- **Ergebnisse**:
  - Ergebnisse in den Registern `r5` (NOP), `r6` (LDR), `r7` (STR), `r8` (STR!) speichern.

### 4.3 **`measure_mul_sdiv`**

- **MUL Befehl messen**:
  - Multipliziere `r2` und `r3` und berechne die Zyklen.
- **SDIV Befehl messen**:
  - Teile `r2` durch `r3` und berechne die Zyklen.
- **Ergebnisse**:
  - Ergebnisse in den Registern `r5` (MUL), `r6` (SDIV) speichern.

### 4.4 **`measure_push_cycles`**

- **Push mit 1 Register messen**:
  - Speicher `r1` auf dem Stack und berechne die Zyklen.
- **Push mit 2 Registern messen**:
  - Speicher `r1` und `r2` auf dem Stack und berechne die Zyklen.
- **Push mit 4 Registern messen**:
  - Speicher `r1`, `r2`, `r3`, `r4` auf dem Stack und berechne die Zyklen.
- **Ergebnisse**:
  - Ergebnisse in den Registern `r5` (1 Register), `r6` (2 Register), `r7` (4 Register) speichern.

---

## 5. **SysTick Register und Kontrolle**

- **ST_CTRL_R**:
  - Steuert die Aktivierung und den Takt von SysTick.
  - Aktivierung erfolgt mit `ST_CTRL_ENABLE`.
  - Taktquelle ist der Systemtakt, konfiguriert durch `ST_CTRL_CLK_SRC`.
  - **COUNTFLAG** prüft, ob der Timer abgelaufen ist.

- **ST_RELOAD_R**:
  - Setzt den Reload-Wert, der nach Ablauf des Timers neu geladen wird.

- **ST_CURRENT_R**:
  - Zeigt den aktuellen Wert des SysTick-Timers an. Wird zum Berechnen von Zyklen genutzt.

---

## 6. **Stack und Register**

- **Push und Pop**:
  - `push {r1, r2}` speichert `r1` und `r2` auf dem Stack.
  - `pop {r1, r2}` stellt `r1` und `r2` vom Stack wieder her.
- **Stack Pointer (SP)**:
  - Zeigt auf die oberste Adresse des Stacks. `sp` wird beim Speichern von Werten auf dem Stack verändert.

---

## 7. **Bit-Definitionen und Adressen**

- **Bit-Definitionen**:
  - `define_bit a`: Definiert die Bits von `BIT0` bis `BIT31`.

- **GPIO und SysTick Adressen**:
  - Die Basisadressen für GPIO-Ports und SysTick-Register sind definiert und werden verwendet, um auf Peripherie zuzugreifen.
  - `RCGC_GPIO_R` aktiviert den GPIO-Takt.
  - `GPIO_PORT_F_BASE` definiert die Basisadresse des GPIO-Port F.
  - SysTick-Register: `ST_RELOAD_R`, `ST_CTRL_R`, `ST_CURRENT_R`.
