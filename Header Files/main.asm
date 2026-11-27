LIST	    P=18F4520
#include    <P18F4520.INC>
CONFIG	    OSC = XT
CONFIG	    WDT = OFF
CONFIG	    LVP = OFF

CBLOCK 0x000
    TMR0_PRELOAD_HIGH
    TMR0_PRELOAD_LOW
    TMR0_COUNTER
ENDC

ORG 0000H
    GOTO INIT
ORG 0008H
    BTFSC INTCON,TMR0IF
    CALL TMR0_ISR

    ;s.t. If interrupted in STATUS sensitive instructions, the STATUS register will be restored to its original value
    RETFIE FAST

ORG 00100H
INIT
    ;Setup TMR0_PRELOAD
    ;0xC2F7 = 49911, 65536 - 49911 = 15625. 15625 * 64 (1:64 prescaler) =
    ;= 1,000,000 MCs = 1 second
    MOVLW   0xC2
    MOVWF   TMR0_PRELOAD_HIGH
    MOVLW   0xF7
    MOVWF   TMR0_PRELOAD_LOW

    ;Digital I/O Configuration
    MOVLW   0x0F
    MOVWF   ADCON1

    ;Setup Port D (8 LEDs)
    CLRF    TRISD

    MOVLW   0xFF
    MOVWF   PORTD

    ;TMR0_COUNTER Setup
    MOVWF   TMR0_COUNTER

    ;Setup T0CON
    ;0 - TMR0 OFF, 0 - T08BIT (16-bit), 0 - T0CS (Clock Source = Instruction Cycle Clock), 
    ;0 - T0SE (T0CKI pin not used, so doesn't matter), 0 - PSA (Prescaler is assigned), PS = 101 (Prescaler = 1:64)
    ;00000101 = 0x05
    MOVLW   B'00000101'
    MOVWF   T0CON

    ;TMR0 Setup
    MOVFF   TMR0_PRELOAD_HIGH, TMR0H
    MOVFF   TMR0_PRELOAD_LOW, TMR0L
    
    BCF     INTCON, TMR0IF
    BSF     INTCON, TMR0IE
    BSF     INTCON, GIE

    ;Start TMR0
    BSF T0CON, TMR0ON

MAIN
    MOVFF TMR0_COUNTER, PORTD
    GOTO MAIN

TMR0_ISR
    ;Don't stop the timer for precision, just reload it with the initial value
    ;(it will not have enough time to update, 64 MCs will have to pass
    ;before TMR0 updates, assuming 64 prescaler was used for external 4MHz OSC).
    ;The 2 instructions below will take only 4 Mcs, which is lower than 64 Mcs.

    ;Reload TMR0 with initial value
    MOVFF TMR0_PRELOAD_HIGH, TMR0H
    MOVFF TMR0_PRELOAD_LOW, TMR0L

    ;Decrement TMR0_COUNTER
    DECF TMR0_COUNTER, F

    ;Clear TMR0 Interrupt Flag
    BCF INTCON,TMR0IF

    RETURN

END
