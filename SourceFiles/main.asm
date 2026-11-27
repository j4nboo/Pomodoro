LIST	    P=18F4520
#include    <P18F4520.INC>
CONFIG	    OSC = XT
CONFIG	    WDT = OFF
CONFIG	    LVP = OFF

CBLOCK 0x000
    #include "../HeaderFiles/timer_cblock.inc"
ENDC

ORG 0000H
    GOTO INIT
ORG 0008H
    #include "../HeaderFiles/timer_interrupt_handling.inc"

    ;s.t. If interrupted in STATUS sensitive instructions, the STATUS register will be restored to its original value
    RETFIE FAST

ORG 00100H
INIT

    ;Digital I/O Configuration
    MOVLW   0x0F
    MOVWF   ADCON1

    ;Setup Port D (8 LEDs)
    CLRF    TRISD

    MOVLW   0xFF
    MOVWF   PORTD

    #include "../HeaderFiles/timer_init.inc"

    BSF     INTCON, GIE

MAIN
    MOVFF TMR0_COUNTER, PORTD
    GOTO MAIN

#include "../HeaderFiles/timer_ISR.inc"

END
