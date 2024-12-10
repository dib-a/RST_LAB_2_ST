# Assembly

## Variable Assignment

| Symbol | Description                                          |
|--------|------------------------------------------------------|
| `=`    | Wird verwendet, um Konstanten zu definieren und in Register zu laden. |
| `[]`   | Kennzeichnet Speicheradressen für das Lesen oder Schreiben von Daten. |

## Instructions

### Load/Store Operations

| Instruction | Description                                      |
|-------------|--------------------------------------------------|
| `LDR`       | Lädt einen Wert aus einem Register in eine Variable. |
| `STR`       | Speichert einen Wert in ein Register.            |
| `MOV`       | Bewegt einen Wert von einem Register in ein anderes. (8-bit + rotation) |
| `MOVW`      | Bewegt einen Wert von einem Register in ein anderes. (16-bit)|
| `B`         | Springt zu einer bestimmten Adresse (Label).     |

### Logical Operations

| Instruction | Description                                      |
|-------------|--------------------------------------------------|
| `AND`       | Führt eine bitweise AND-Operation durch.        |
| `OR`        | Führt eine bitweise OR-Operation durch.         |
| `BIC`       | Führt eine bitweise AND-Operation mit dem Komplement durch. |
| `LSL`       | Verschiebt die Bits eines Registers nach links (multipliziert den Wert mit 2). |

### Comparison Operations

| Instruction | Description                                      |
|-------------|--------------------------------------------------|
| `CMP`       | Vergleicht zwei Werte, indem es eine Subtraktion durchführt und die Flags setzt. |
| `BEQ`       | Springt zu einer bestimmten Adresse (Label), wenn die vorherige CMP-Operation gleich ist (d.h. die Null-Flag gesetzt ist). |
| `BNE`       | Springt zu einer bestimmten Adresse (Label), wenn die vorherige CMP-Operation ungleich ist (d.h. die Null-Flag nicht gesetzt ist). |

### Arithmetic Operations

| Instruction | Description                                      |
|-------------|--------------------------------------------------|
| `SUB`       | Subtrahiert zwei Werte.                          |
| `SUBS`      | Subtrahiert zwei Werte und setzt die Flags.     |
| `ADD`       | Addiert zwei Werte.                              |
| `ADDS`      | Addiert zwei Werte und setzt die Flags.         |

## TM4C123G Microcontroller

### Ports

| **Bezeichnung**               | **Adresse**     | **Beschreibung**                                         |
|-------------------------------|------------------|---------------------------------------------------------|
| `RCGC_GPIO_R`                   | 0x400FE608       | Run-Mode Clock Gating Control Register für GPIO         |
| `RCGC_GPIO_PORT_A`              | 0x01             | Aktiviert GPIO Port A                                   |
| `RCGC_GPIO_PORT_B`              | 0x02             | Aktiviert GPIO Port B                                   |
| `RCGC_GPIO_PORT_C`              | 0x04             | Aktiviert GPIO Port C                                   |
| `RCGC_GPIO_PORT_D`              | 0x08             | Aktiviert GPIO Port D                                   |
| `RCGC_GPIO_PORT_E`              | 0x10             | Aktiviert GPIO Port E                                   |
| `RCGC_GPIO_PORT_F`              | 0x20             | Aktiviert GPIO Port F                                   |

#### Erläuterung der Ports

- **Port A**: Wird häufig für allgemeine digitale Ein-/Ausgabe verwendet und kann auch spezielle Funktionen wie UART unterstützen.
- **Port B**: Ähnlich wie Port A, bietet er Unterstützung für digitale Ein-/Ausgabe und kann für spezielle Funktionen wie I²C verwendet werden.
- **Port C**: Wird oft für digitale Ein-/Ausgabe verwendet und kann auch Funktionen wie PWM (Pulsweitenmodulation) unterstützen.
- **Port D**: Unterstützt ebenfalls digitale Ein-/Ausgabe und kann für serielle Kommunikation (UART) oder SPI verwendet werden.
- **Port E**: Kann für digitale Ein-/Ausgabe sowie für spezielle Funktionen wie ADC (Analog-Digital-Wandler) genutzt werden.
- **Port F**: Besonders wichtig für die Steuerung von LEDs und Tasten. Port F hat typischerweise die folgenden Aufgaben:
  - Steuerung von Benutzer-LEDs für Statusanzeigen.
  - Verwendung von Tasten als Eingabemöglichkeiten.
  - Implementierung von Interrupts für schnelle Reaktionen auf Benutzereingaben.
  
Die Pins von Port F sind häufig für die Verwendung in Embedded-Systemen und Mikrocontroller-Projekten von entscheidender Bedeutung, da sie einfache Schnittstellen für die Interaktion mit Benutzern bieten.

### Register

| **Bezeichnung**               | **Adresse**     | **Beschreibung**                                         |
|-------------------------------|------------------|---------------------------------------------------------|
| `GPIO_PORT_F_DATA_R`            | 0x400253FC       | Datenregister für GPIO Port F                           |
| `GPIO_PORT_F_DEN_R`             | 0x4002551C       | Digital Enable Register für Port F                      |
| `GPIO_PORT_F_DIR_R`             | 0x40025400       | Richtungsregister für Port F                            |
| `GPIO_PORT_F_PUR_R`             | 0x40025510       | Pull-Up Resistor Register für Port F                   |

### Pinout

| Pin (PDx) | Standard-GPIO | Spezialfunktion         | Beschreibung                          |
|-----------|----------------|-------------------------|---------------------------------------|
| PD0       | GPIO           | SSI1Clk                 | Takt für SPI-Modul 1                 |
| PD1       | GPIO           | SSI1Fss                 | Frame-Select für SPI-Modul 1         |
| PD2       | GPIO           | SSI1Rx / UART2Rx       | SPI-Datenempfang oder UART2 Empfang   |
| PD3       | GPIO           | SSI1Tx / UART2Tx       | SPI-Datensenden oder UART2 Senden     |
| PD4       | GPIO           | CAN0Rx                  | Datenempfang für CAN-Bus              |
| PD5       | GPIO           | CAN0Tx                  | Datensenden für CAN-Bus               |
| PD6       | GPIO           | USB Fault Indicator      | USB-Fehleranzeige                     |
| PD7       | GPIO           | NMI (Non-Maskable Interrupt) | Externer Interrupt                  |

### Allgemeines

- Anzahl der Register: 12
- Anzahl der Pins: 8

| Pin (PDx) | Standard-GPIO | Beschreibung |
|-----------|----------------|---|
| PD0       | GPIO           | SW2 Switch 2|
| PD1       | GPIO           | RGB LED Red|
| PD2       | GPIO           | RGB LED Blue|
| PD3       | GPIO           | RGB LED Green|
| PD4       | GPIO           | SW 1 Switch 1|
| PD5       | GPIO           | |
| PD6       | GPIO           | |
| PD7       | GPIO           | |

## Fragen Open-Lab

1. Warum Zeile 75 Takt auf 15999? Habe ich oft bei anderen gesehen

## Abgabe 2

Beispiel: 16 MHz Taktfrequenz

$$ \text{Anzahl der Taktzyklen} = \text{Taktfrequenz} \times \text{Zeit in Sekunden}$$

Zeit in Sekunden: 1 ms = 0,001 Sekunden

Taktfrequenz: 16 MHz = 16.000.000 Taktfrequenz

Berechnung der Taktzyklen: $$\text{Anzahl der Taktzyklen} = 16,000,000, \text{Hz} \times 0,001, \text{s} = 16,000$$

### Aufgabe a

- Rückkehr an den Aufrufer:
  - `sys_tick_handler` hat am Ende `bx lr` (Branch Exchange to Link Register) dadurch springt es zurück an den Aufrufer
  - Zeile: 131
- Schutz der Registerinhalte
  - Am Anfang von `sys_tick_handler` wird mit `push {r0, r1, lr}` der Wert von `r0`, `r1` und `lr` auf den Stack geschrieben
    - Zeile 103
  - Am Ende von `sys_tick_handler` wird mit `pop {r0, r1, lr}` der Wert von `r0`, `r1` und `lr` vom Stack geladen
    - Zeile 130
  - im `sys_tick_handler` wird dann nur `r0` und `r1` verwendet und Veränderungen werden durch s und ms festgehalten
- Warum keine Interupts?
  - Bei Interupts wird nicht direkt ersichtlich wie oft diese aufgerufen werden
  - keine feste Sequenz
  - Können zu Interupt-Konflikten führen

### Aufgabe b

DATA -> 4 Bit
DIR -> 16 Bit

Memory und Peripherals zeigen beide das gleiche an

#### Stack

Bei push {r1, r2} wird der Wert von r2 zuerst (an die höhere Adresse) und dann der Wert von r1 (an die niedrigere Adresse) auf den Stack geschrieben.

Bei push {r2, r1} wird der Wert von r1 zuerst (an die höhere Adresse) und dann der Wert von r2 (an die niedrigere Adresse) geschrieben. Der Speicherinhalt wird also anders angeordnet.

Dies liegt daran, dass der Stack im ARM-Architektur-Modell abwärts wächst.

### Aufgabe c

`sdiv` : division mit vorzeichen
