COMMENT |
Module      :  main.asm
Description :  Point of entry
Copyright   :  (c) 2023 Kamil Kurkiewicz
License     :  NONE

Maintainer  :  Kamil Kurkiewicz <k-kurkiewicz@outlook.com>
Stability   :  experimental

Defines the entry point for the entire application
|

.586P
; Flat memory model
.MODEL FLAT, STDCALL
; Constants
STD_OUTPUT_HANDLE equ -11
; Prototypes of external procedures
EXTERN  GetStdHandle@4:NEAR
EXTERN  WriteConsoleA@20:NEAR
EXTERN  ExitProcess@4:NEAR
; Directives for the linker to link libraries
INCLUDELIB user32.lib
INCLUDELIB kernel32.lib
;------------------------------------------------
; Data segment
_DATA SEGMENT
; DOS-encoded string
    STR1 DB "KEditor 0.1.0.0", 13, 10, 0
    LENS DD ?         ; Number of output characters
    RES  DD ?
_DATA ENDS
; Code segment
_TEXT SEGMENT
START:
; Get the output handle
    PUSH  STD_OUTPUT_HANDLE
    CALL  GetStdHandle@4
; String length
    PUSH  OFFSET STR1
    CALL  LENSTR
; Output the string
    PUSH  OFFSET RES   ; Reserved
    PUSH  OFFSET LENS  ; Symbols displayed
    PUSH  EBX          ; String length
    PUSH  OFFSET STR1  ; String address
    PUSH  EAX          ; Output handle
    CALL  WriteConsoleA@20
    PUSH  0
    CALL  ExitProcess@4
; String - [EBP+08H]
; Length in EBX
LENSTR PROC
    PUSH  EBP
    MOV   EBP, ESP
    PUSH  EAX
;-----------------------
    CLD
    MOV   EDI, DWORD PTR [EBP+08H]
    MOV   EBX, EDI
    MOV   ECX, 100    ; Limit the string length
    XOR   AL, AL
    REPNE SCASB       ; Find the 0 character
    SUB   EDI, EBX    ; String length including 0
    MOV   EBX, EDI
    DEC   EBX
;----------------------------
    POP  EAX
    POP  EBP
    RET  4
LENSTR ENDP
_TEXT ENDS
END START 
