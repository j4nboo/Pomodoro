;TMR0_COUNTER Setup
    MOVWF   TMR0_COUNTER

    ;Setup T0CON
    ;0 - TMR0 OFF, 0 - T08BIT (16-bit), 0 - T0CS (Clock Source = Instruction Cycle Clock), 
    ;0 - T0SE (T0CKI pin not used, so doesn't matter), 0 - PSA (Prescaler is assigned), PS = 101 (Prescaler = 1:64)
    ;00000101 = 0x05
    MOVLW   B'00000101'
    MOVWF   T0CON

    ;Setup TMR0_PRELOAD
    ;0xC2F7 = 49911, 65536 - 49911 = 15625. 15625 * 64 (1:64 prescaler) =
    ;= 1,000,000 MCs = 1 second
    MOVLW   0xC2
    MOVWF   TMR0_PRELOAD_HIGH
    MOVLW   0xF7
    MOVWF   TMR0_PRELOAD_LOW

    ;TMR0 Setup
    MOVFF   TMR0_PRELOAD_HIGH, TMR0H
    MOVFF   TMR0_PRELOAD_LOW, TMR0L
    
    BCF     INTCON, TMR0IF
    BSF     INTCON, TMR0IE

    ;Start TMR0
    BSF T0CON, TMR0ON