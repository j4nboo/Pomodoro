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