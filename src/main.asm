COMMENT |
Module      :  main.asm
Description :  Point of entry
Copyright   :  (c) 2024 Kamil Kurkiewicz
License     :  NONE

Maintainer  :  Kamil Kurkiewicz <k-kurkiewicz@outlook.com>
Stability   :  experimental
Portability :  non-portable (Win32)

Defines the entry point for the entire application
|

; Intel Pentium I
.586P

; Flat memory model, standard calling convention
.MODEL FLAT, STDCALL

; Constants
STD_OUTPUT_HANDLE EQU -11

; Prototypes of external procedures
EXTERN GetStdHandle@4:NEAR
EXTERN WriteConsoleA@20:NEAR
EXTERN ExitProcess@4:NEAR

; Instruct the linker to search the appropriate libraries
INCLUDELIB KERNEL32.LIB
INCLUDELIB USER32.LIB

;-----------------------------------------------------------

; Data segment
_DATA SEGMENT
    STR1  DB  "KEditor 0.1.0.0", 13, 10, 0
    LENS  DD  ?                             ; Number of output characters
    RES   DD  ?
_DATA ENDS

; Code segment
_TEXT SEGMENT
START:
; Get the output handle
    PUSH   STD_OUTPUT_HANDLE
    CALL   GetStdHandle@4
; Determine the length of STR1
    PUSH   OFFSET STR1
    CALL   LENSTR
; Output the string and exit
    PUSH   OFFSET RES
    PUSH   OFFSET LENS
    PUSH   EBX
    PUSH   OFFSET STR1
    PUSH   EAX
    CALL   WriteConsoleA@20
    PUSH   0
    CALL   ExitProcess@4

; Measures string lengths
; 
; String - [EBP+8]
; Length in EBX
; 
LENSTR PROC
    PUSH   EBP
    MOV    EBP, ESP
    PUSH   EAX
    CLD
    MOV    EDI, DWORD PTR [EBP+8]
    MOV    EBX, EDI
    MOV    ECX, 100
    XOR    AL, AL
    REPNE  SCASB
    SUB    EDI, EBX
    MOV    EBX, EDI
    DEC    EBX
    POP    EAX
    POP    EBP
    RET    4
LENSTR ENDP

_TEXT ENDS
END START 
