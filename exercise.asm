global main
extern printf, scanf
; 
; Author:  Steven Jordaan
; Date:    2023
; Purpose: Lecture 3 Exercise on Branching and Looping
; 
; For more information and free learning resources, follow the link:
;   https://www.youtube.com/watch?v=dQw4w9WgXcQ
; 
; Debugger Cheatsheet:
; 
; Expressions in the watch window in VSCode:
; - (type)(source) : Display 'source' interpreted as 'type'
; - (type)(source >> N) & 0xff : Display Nth byte of 'source' interpreted as 'type'
; 
; 'type' can be basic data types like char, int, etc.
; 'source' can be registers like rax, rbx, etc., or memory addresses.
; 'N' is the number of bytes to shift to the right to get to the desired byte.
;
; Examples:
; - (char)(rax & 0xff) : Display least significant byte of rax as char
; - (char)((rax >> 8) & 0xff) : Display second byte of rax as char
; 
; Working with byte strings:
; *(char*)0x12345678 : Display byte at address 0x12345678 as char
; *(char*)label : Display byte at address of label as char
; *(char*)(label + N) : Display Nth byte after label as char
; *(char*)label@N : Display N bytes after label as char
; 
; For hex | oct:
; (value),h
; (value),o
section .data
  prompt db "Enter an object: ", 0
  isPlaneStr db "plane", 0
  userInputFmt db "%s", 0
  format1 db "Character 1: Is it a plane?", 10, 0
  correctResponse db "Character 2: Yes, it's a plane!", 10, 0
  incorrectResponse db "Character 2: No, it's a %s!", 10, 0

section .bss
  userInput resb 100

section .text

main:
  push rbp
  mov rbp, rsp

  mov rdi, prompt
  call printf

  ; Get user input
  mov rdi, userInputFmt
  lea rsi, [userInput]
  call scanf

  ; Print the meme conversation
  mov rdi, format1
  call printf
  
  ; Compare user input with "plane"
  mov rdi, isPlaneStr    ; RDI points to the destination string (isPlaneStr)
  mov rsi, userInput     ; RSI points to the source string (userInput)
  cld                    ; Clear the direction flag for forward movement

.compareLoop:
    lodsb                  ; Load byte from RSI (user input) into AL
    scasb                  ; Compare AL with byte at RDI (isPlaneStr); RDI and RSI are automatically incremented
    jne .notPlane          ; If not equal, jump to .notPlane

    test al, al            ; Check for end of string (null-terminator)
    jnz .compareLoop       ; If not end of string, continue loop

    ; If we've reached this point, the strings are the same
    mov rdi, correctResponse
    call printf
    jmp .endProgram

.notPlane:
    mov rdi, incorrectResponse
    lea rsi, [userInput]
    call printf

.endProgram:
  xor rax, rax
  leave
  ret