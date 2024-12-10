# Erklärung der `equ`-Definitionen

## 1. **RCGC_GPIO_R und RCGC_GPIO_PORT_F**

- **`RCGC_GPIO_R`**:
  - Adresse: `0x400FE608`
  - **Funktion**: Das Register für das Aktivieren des Takts für die GPIO-Ports. Über dieses Register werden die Takte für verschiedene GPIO-Ports aktiviert. Es ist ein wichtiges Register zur Initialisierung von GPIO-Peripheriegeräten in ARM Cortex-M Systemen.

- **`RCGC_GPIO_PORT_F`**:
  - Wert: `BIT5`
  - **Funktion**: Ein Wert, der den Takt für den GPIO-Port F aktiviert. Der Wert `BIT5` entspricht dem Bit, das den Port F im `RCGC_GPIO_R` Register aktiviert. Um den Takt für Port F zu aktivieren, wird dieser Wert mit dem Inhalt von `RCGC_GPIO_R` OR-ed.

## 2. **GPIO Port F Adressen**

- **`GPIO_PORT_F_BASE`**:
  - Adresse: `0x40025000`
  - **Funktion**: Basisadresse für den GPIO-Port F. Diese Adresse zeigt auf die Register des Ports F, von denen die einzelnen Register für die GPIO-Steuerung durch Offsets wie `GPIO_DATA_OFF`, `GPIO_DIR_OFF`, und `GPIO_DEN_OFF` abgerufen werden.

- **`GPIO_DATA_OFF`**:
  - Wert: `0x3FC`
  - **Funktion**: Offset zum Datenregister des GPIO-Port F. Dieses Register enthält die Werte für die Pins des Ports F. Über dieses Register können Sie die Werte der GPIO-Pins einlesen oder schreiben.

- **`GPIO_DIR_OFF`**:
  - Wert: `0x400`
  - **Funktion**: Offset zum Richtung-Register des GPIO-Port F. In diesem Register wird festgelegt, ob ein Pin als Eingang oder Ausgang konfiguriert ist. Ein Wert von `1` stellt einen Ausgang dar, während `0` einen Eingang bedeutet.

- **`GPIO_DEN_OFF`**:
  - Wert: `0x51C`
  - **Funktion**: Offset zum Digital Enable Register des GPIO-Port F. In diesem Register wird festgelegt, ob ein Pin als digitaler Pin aktiviert ist oder nicht. Ein Wert von `1` aktiviert den digitalen Modus, während `0` den Pin als analogen Pin definiert.

- **`GPIO_PORT_F_DATA_R`**:
  - Berechnung: `GPIO_PORT_F_BASE + GPIO_DATA_OFF`
  - **Funktion**: Diese Adresse zeigt auf das Datenregister des GPIO-Port F. Es wird verwendet, um die Zustände der Pins zu lesen oder zu schreiben.

- **`GPIO_PORT_F_DIR_R`**:
  - Berechnung: `GPIO_PORT_F_BASE + GPIO_DIR_OFF`
  - **Funktion**: Diese Adresse zeigt auf das Richtung-Register des GPIO-Port F. Es wird verwendet, um die Richtung der Pins festzulegen (Eingang oder Ausgang).

- **`GPIO_PORT_F_DEN_R`**:
  - Berechnung: `GPIO_PORT_F_BASE + GPIO_DEN_OFF`
  - **Funktion**: Diese Adresse zeigt auf das Digital Enable Register des GPIO-Port F. Es wird verwendet, um die digitalen Eingänge/Ausgänge für den Port zu aktivieren oder zu deaktivieren.

## 3. **SysTick Register**

- **`ST_BASE`**:
  - Adresse: `0xE000E000`
  - **Funktion**: Basisadresse für die SysTick-Register. SysTick ist ein 24-Bit-Timer, der für die Erstellung von Perioden und die Messung der Zeit verwendet wird.

- **`ST_CTRL_OFF`**:
  - Wert: `0x10`
  - **Funktion**: Offset für das Control Register des SysTick-Timers. In diesem Register werden die Steuerbits gesetzt, um den SysTick-Timer zu aktivieren, die Taktquelle auszuwählen und den Timer zu starten.

- **`ST_RELOAD_OFF`**:
  - Wert: `0x14`
  - **Funktion**: Offset für das Reload-Register des SysTick-Timers. Dieses Register gibt an, nach wie vielen Zyklen der Timer zurückgesetzt wird. Der Wert im Register bestimmt die Dauer des Timers, bevor er eine Unterbrechung auslöst.

- **`ST_CURRENT_OFF`**:
  - Wert: `0x18`
  - **Funktion**: Offset für das Current-Register des SysTick-Timers. Dieses Register enthält den aktuellen Wert des Timers. Es zählt von der Reload-Wert zurück bis 0 und löst eine Unterbrechung aus, wenn es 0 erreicht.

- **`ST_CTRL_R`**:
  - Berechnung: `ST_BASE + ST_CTRL_OFF`
  - **Funktion**: Adresse des Control Registers des SysTick-Timers. In diesem Register wird der Timer konfiguriert und aktiviert.

- **`ST_RELOAD_R`**:
  - Berechnung: `ST_BASE + ST_RELOAD_OFF`
  - **Funktion**: Adresse des Reload-Registers des SysTick-Timers. Es wird verwendet, um den Reload-Wert für den Timer zu setzen.

- **`ST_CURRENT_R`**:
  - Berechnung: `ST_BASE + ST_CURRENT_OFF`
  - **Funktion**: Adresse des Current-Registers des SysTick-Timers. Es wird verwendet, um den aktuellen Zählerwert des Timers zu lesen.

## 4. **SysTick Control Bits**

- **`ST_CTRL_ENABLE`**:
  - Wert: `BIT0`
  - **Funktion**: Aktiviert den SysTick-Timer. Wird im Control Register gesetzt, um den Timer zu starten.

- **`ST_CTRL_CLK_SRC`**:
  - Wert: `BIT2`
  - **Funktion**: Wählt die Taktquelle für den SysTick-Timer. Wenn `BIT2` gesetzt ist, wird der Systemtakt verwendet. Andernfalls wird der externe Takt verwendet.

- **`ST_CTRL_COUNT`**:
  - Wert: `BIT16`
  - **Funktion**: Setzt das COUNTFLAG im Control Register. Wenn der Timer abgelaufen ist (der Zähler den Wert 0 erreicht hat), wird dieses Bit gesetzt und kann abgefragt werden, um festzustellen, ob der Timer abgelaufen ist.
