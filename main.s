; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include <xc.inc>

; CONFIG1L
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC3_PLL4    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = HSPLL_HS      ; Oscillator Selection bits (Internal oscillator, HS oscillator used by USB (INTHS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON          ; Power-up Timer Enable bit (PWRT disabled)
//  CONFIG  BOR = OFF              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF              ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)

PSECT	    udata_acs
	TEMP:
		DS	1
	TIME:	
		DS	1
	TIME_2:
		DS	1
	SPEED:	
		DS	1

;CONSTANT	MASK	0xF
;*************************************************
PSECT	    CODE
ORG	    0x000			;vector de reset 
	    GOTO	MAIN		;goes to main program

INIT:	    
	    MOVLB	0x0F
	    
	    MOVLW	0x0F
	    MOVWF	TEMP, C
	    
	    
	    CLRF	LATD, C
	    SETF	LATB, C
	    
	    CLRF	TRISD, C		
	    BCF		TRISB, 0, C
	    BCF		TRISB, 1, C
	    BCF		TRISB, 2, C
	    BCF		TRISB, 3, C
	    BCF		TRISB, 4, C
	    
	    BSF		TRISB, 6, C
	    BSF		TRISB, 7, C
	    
	    RETURN			;leaving initialization subroutine

			    
MAIN:	    CALL	INIT
			    
LOOP:	
	    //CALL	DELAY
	    MOVLW	0xFF
	    MOVWF	TIME_2, C
	    BTFSC	PORTB, 6, C
	    GOTO	DECREASE
	    BTFSC	PORTB, 7, C
	    GOTO	INCREASE	    
	    GOTO	DELAY_2
	    
DECREASE:
	    CALL	SET_SPEED
	    GOTO	COUNTER
	    
INCREASE:    
	    CALL	SET_SPEED	
	    GOTO	COUNTER
	    
SET_SPEED:
	    RETURN
	    
DELAY:	    
	    NOP
	    NOP
	    NOP
	    NOP
	    NOP
	    NOP
	    NOP
	    NOP
	    DECFSZ	TIME, C
	    GOTO	DELAY
	    GOTO	DELAY_2
	    
DELAY_2:
	    MOVLW	0xFF
	    MOVWF	TIME, C
	    NOP
	    NOP
	    DECFSZ	TIME_2, C
	    GOTO	DELAY
	    GOTO	COUNTER
	    
DELAY_SPEED:	  
	    
COUNTER:
	    MOVLW	0x00
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_0
	    MOVLW	0x01
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_1
	    MOVLW	0x02
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_2
	    MOVLW	0x03
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_3
	    MOVLW	0x04
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_4
	    MOVLW	0x05
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_5
	    MOVLW	0x06
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_6
	    MOVLW	0x07
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_7
	    MOVLW	0x08
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_8
	    MOVLW	0x09
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_9
	    MOVLW	0x0A
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_A
	    MOVLW	0x0B
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_B
	    MOVLW	0x0C
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_C
	    MOVLW	0x0D
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_D
	    MOVLW	0x0E
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_E
	    MOVLW	0x0F
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_F
	    
OUTPUT_0:
	    MOVLW	0b00111111
	    MOVWF	PORTD, C
	    MOVLW	0x0F
	    MOVWF	TEMP, C
	    GOTO	LOOP

OUTPUT_1:
	    MOVLW	0b00000110
	    MOVWF	PORTD, C
	    MOVLW	0x00
	    MOVWF	TEMP, C
	    GOTO	LOOP

OUTPUT_2:
	    MOVLW	0b01011011
	    MOVWF	PORTD, C
	    MOVLW	0x01
	    MOVWF	TEMP, C
	    GOTO	LOOP

OUTPUT_3:
	    MOVLW	0b01001111
	    MOVWF	PORTD, C
	    MOVLW	0x02
	    MOVWF	TEMP, C
	    GOTO	LOOP	
	    
OUTPUT_4:
	    MOVLW	0b01100110
	    MOVWF	PORTD, C
	    MOVLW	0x03
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_5:
	    MOVLW	0b01101101
	    MOVWF	PORTD, C
	    MOVLW	0x04
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_6:
	    MOVLW	0b01111101
	    MOVWF	PORTD, C
	    MOVLW	0x05
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_7:
	    MOVLW	0b00000111
	    MOVWF	PORTD, C
	    MOVLW	0x06
	    MOVWF	TEMP, C
	    GOTO	LOOP	
	    
OUTPUT_8:
	    MOVLW	0b01111111
	    MOVWF	PORTD, C
	    MOVLW	0x07
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_9:
	    MOVLW	0b01101111
	    MOVWF	PORTD, C
	    MOVLW	0x08
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_A:
	    MOVLW	0b01110111
	    MOVWF	PORTD, C
	    MOVLW	0x09
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_B:
	    MOVLW	0b01111100
	    MOVWF	PORTD, C
	    MOVLW	0x0A
	    MOVWF	TEMP, C
	    GOTO	LOOP	    
	    
OUTPUT_C:
	    MOVLW	0b00111001
	    MOVWF	PORTD, C
	    MOVLW	0x0B
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_D:
	    MOVLW	0b01011110
	    MOVWF	PORTD, C
	    MOVLW	0x0C
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_E:
	    MOVLW	0b01111001
	    MOVWF	PORTD, C
	    MOVLW	0x0D
	    MOVWF	TEMP, C
	    GOTO	LOOP
	    
OUTPUT_F:
	    MOVLW	0b01110001
	    MOVWF	PORTD, C
	    MOVLW	0x0E
	    MOVWF	TEMP, C
	    GOTO	LOOP	    
	    
	    END				 ;end of program


