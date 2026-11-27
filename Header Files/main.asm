LIST	    P=18F4520
#include    <P18F4520.INC>
CONFIG	    OSC = XT
CONFIG	    WDT = OFF
CONFIG	    LVP = OFF

ORG 0000H
GOTO MAIN
ORG 0008H
BTFSC INTCON,INT0IF
call INT0_ISR
RETFIE

ORG 00100H
MAIN
    ;Digital I/O Configuration
    MOVLW 0x0F
    MOVWF ADCON1

    ;Interrupt Configuration
    ;CALL INIT_INTERRUPT




INIT_INTERRUPT
    ;Enable Global Interrupts
    BSF INTCON, GIE
    ;Clear External Interrupt 0 Flag
    BCF INTCON,INT0IF
    ;Enable External Interrupt 0
    BSF INTCON,INT0IE
    ;Set External Interrupt 0 to trigger on rising edge
    BCF INTCON2,INTEDG0
    RETURN

END
