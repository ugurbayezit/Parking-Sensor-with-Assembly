LIST P=16F877A
INCLUDE "P16f877A.INC"
__CONFIG _HS_OSC & _WDT_OFF & _PWRTE_OFF & _CP_OFF & _LVP_OFF & _BODEN_OFF
;org 0x00;
;goto start
;org 0x04; 
trig EQU h'20'
Counter equ 0x27;
Counter_Outer equ 0x25 ; free RAM location 12
Counter_Inner equ 0x26 ; free RAM location 13
SAYAC EQU 0x28
BIRLER_BASAMAGI EQU 0x21
ONLAR_BASAMAGI EQU 0x22
YUZLER_BASAMAGI EQU 0x4B
deger equ 0x5A
N equ .16;
CLRF PORTB
CLRF PORTD
;BANKSEL TRISB

;BANKSEL PORTB
;MOVLW h'07'
;MOVWF CMCON
;BCF PORTD,0
;start
 
; movlw .0;
 ;movwf TMR0;
 
 bsf STATUS, RP0;
MOVLW b'00000000'
MOVWF TRISB
MOVLW b'00000000'
MOVWF TRISD
 bcf OPTION_REG, T0CS; At each clock cycle, timer value will be incremented
 bcf OPTION_REG, PSA; Prescalar value is assigned to TMR0 register
 bsf OPTION_REG, PS2;
 bsf OPTION_REG, PS1;
 bsf OPTION_REG, PS0;
 ; TMR0 rate is 1:2 which means that every 2 clock cycles timer value will be incremented
 ; For the other prescalar values see the lecture notes

 bcf STATUS, RP0;
; bsf INTCON, GIE;
; bsf INTCON, TMR0IE;
; bcf INTCON, TMR0IF;

LOOP 


movlw .123
movwf SAYAC
CALL BIRLER_BAS_GOSTER
CALL DELAY_50_MSEC
CALL ONLAR_BAS_GOSTER 
CALL DELAY_50_MSEC
CALL ONLAR_BAS_GOSTER 
CALL DELAY_50_MSEC
CALL YUZLER_BAS_GOSTER
CALL DELAY_50_MSEC
GOTO LOOP

	;bsf PORTD,0
;	CALL Gecikme
;	bcf PORTD,0
;echo
;	clrf PORTB;
;	bsf STATUS,RP0;
;	clrf TRISB;
;	bsf PIE1,0
;	bcf STATUS,RP0;
;	bsf INTCON,7;
;	bsf INTCON,6;
;	bcf TMR1L,1;
;	bsf TMR1L,0;
;goto echo
;veri
;btfss PORTD,1;
;goto veri
;clrf TMR1L;
;main
;btfsc PORTD,1;
;goto main
;movlw TMR1L;
;movlw .10
;movwf SAYAC

;btfss timer,7
;goto SEVEN_SEGMENT
;btfss timer,6
;goto SEVEN_SEGMENT
;btfss timer,5
;goto SEVEN_SEGMENT
;btfss timer,4
;goto SEVEN_SEGMENT
;btfss timer,3
;goto SEVEN_SEGMENT
;btfss timer,2
;goto SEVEN_SEGMENT
;btfss timer,1
;goto SEVEN_SEGMENT
;btfss timer,0
;goto SEVEN_SEGMENT
;decfsz deger,F;
;goto hesaplama
;
;SEVEN_SEGMENT
;;LOOP_2
;; CALL YUZLER_BAS_GOSTER
;; CALL DELAY_50_MSEC
; ;INCF SAYAC,F
; ;MOVLW .100; SAYA? 100E ULASTI MI?
; ;SUBWF SAYAC,W; SAYA? 100E ULASTI MI?
; ;BTFSS STATUS,2; SAYA? 100E ULASTI MI?
; ;GOTO LOOP_2
;;GOTO SEVEN_SEGMENT
;goto LOOP
;
;;ISR_TOCKI
;
;;bcf INTCON, TMR0IF;
;;nop;
;;nop;
;;nop;
;
;;retfie; 
BIRLER_BAS_GOSTER
 BSF PORTD,2
 BCF PORTD,3
 BCF PORTD,4
 CALL BIRLER_BASAMAGINI_BUL
 MOVF BIRLER_BASAMAGI,W
 CALL my_lookUP_table;
 MOVWF PORTB;
 COMF PORTB,F
RETURN
;
ONLAR_BAS_GOSTER
 BCF PORTD,2
 BSF PORTD,3
 BCF PORTD,4
 CALL ONLAR_BASAMAGINI_BUL
 MOVF ONLAR_BASAMAGI,W
 CALL my_lookUP_table;
 MOVWF PORTB;
 COMF PORTB,F
RETURN

YUZLER_BAS_GOSTER
BCF PORTD,2
BCF PORTD,3
BSF PORTD,4
CALL YUZLER_BASAMAGINI_BUL
MOVF YUZLER_BASAMAGI,W
CALL my_lookUP_table;
MOVWF PORTB;
COMF PORTB,F
RETURN

BIRLER_BASAMAGINI_BUL ;MOD 10 YAPILACAK 
MOVF SAYAC,W
MOVWF BIRLER_BASAMAGI
LOOP_BIRLER
MOVLW .10
SUBWF BIRLER_BASAMAGI,F
BTFSC STATUS,0;BORROW kontrol ediliyor
GOTO LOOP_BIRLER
MOVLW .10; Eksiye d?st?g? i?in toplama yaptik.
ADDWF BIRLER_BASAMAGI,F
RETURN
;
ONLAR_BASAMAGINI_BUL ;10'A BOLME YAPILACAK 
MOVF SAYAC,W
MOVWF 0X23
MOVLW .255; ONLAR BASAMAGI 0'DAN BASLASIN ISTEDIK 255+1=0
MOVWF ONLAR_BASAMAGI
LOOP_ONLAR
INCF ONLAR_BASAMAGI,F
MOVLW .10
SUBWF 0X23,F
BTFSC STATUS,0;BORROW kontrol ediliyor
GOTO LOOP_ONLAR
LOOP_Onlar
MOVLW .10
SUBWF ONLAR_BASAMAGI,F
BTFSC STATUS,0
GOTO LOOP_Onlar
MOVLW .10
ADDWF ONLAR_BASAMAGI,F
RETURN

YUZLER_BASAMAGINI_BUL
MOVF SAYAC,F
MOVWF 0X24
MOVLW .255
MOVWF YUZLER_BASAMAGI
LOOP_YUZLER
INCF YUZLER_BASAMAGI,F
MOVLW .100
SUBWF 0X24,F
BTFSC STATUS,0
GOTO LOOP_YUZLER
RETURN

my_lookUP_table
 addwf PCL, F;
 retlw 0x3F;0
 retlw 0x06;1
 retlw 0x5B;2
 retlw 0x4F;3
 retlw 0x66;4
 retlw 0x6D;5
 retlw 0x7D;6
 retlw 0x07;7
 retlw 0x7F;8
 retlw 0x6F;9
 retlw 0x77;A
 retlw 0x7C;b
 retlw 0x39;C
 retlw 0x5E;d
 retlw 0x79;E
 retlw 0x71;F
 retlw 0x80;.
 

DELAY_50_MSEC
movlw .80;
movwf Counter_Outer;
movlw .197;
movwf Counter_Inner;
Loop_Outer
 movwf Counter_Inner;
 Loop_Inner
 decfsz Counter_Inner, F;
 goto Loop_Inner;
 decfsz Counter_Outer, F;
goto Loop_Outer;
RETURN

;
;Gecikme 
;movlw N;
;movwf Counter;
;;bsf PORTB,0;
;nop;
;nop;
;LOOOP
;decfsz Counter,F;
;goto LOOOP;
;;bcf PORTB,0;
;return
end