;Name: Jacob Eckroth
;Date: October 18, 2020
;Program Number Three
;Program Description: This program asks the user for negative numbers in the range
;[-100 - -1]. It keeps asking for new numbers until the user enters something not in the range.
;When an invalid number is entered, the program displays the total numbers entered, the 
;sum of the numbers, and the average of the numbers. It then exits the program.
TITLE Integer Accumulator

 .386
 .model flat,stdcall
 .stack 4096
 ExitProcess PROTO, dwExitCode:DWORD

INCLUDE Irvine32.inc


.data				;Messages initialized here
programTitle BYTE "Welcome to the Integer Accumulator by Jacob Eckroth",13,10,0

noNumbers BYTE "No numbers entered!",13,10,0
usernamePrompt BYTE "What's your name? ",0
helloGreeting BYTE "Hello, ", 0

enterNumberPrompt BYTE "Please enter numbers in [-100, -1].",13,10,0
finishPrompt BYTE "Enter a non-negative number when you are finished to see results.",13,10,0

enterNumber BYTE "Enter number: ",0


goodbyePrompt BYTE "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0

youEntered BYTE "You entered ",0
validNumbers BYTE " valid numbers.",13,10,0

sumOfNumbersPrompt BYTE "The sum of your valid numbers is ",0

roundedAveragePrompt BYTE "The rounded average is ",0

period BYTE ".",0

validNumberCount DWORD 0
totalNumberSum DWORD 0


;Color Declarations
defaultColor = 7
userInputColor = 11
errorColor = 4

;constants:
lowerLimit = -100
upperLimit = -1

.data?
userName BYTE 64 DUP(?)

averageResult DWORD ?

userInputNumber DWORD ?
remainder DWORD ?
halfNumberCount DWORD ?

.code
main PROC
;WELCOME SECTION

;Prints Program Information
    mov     edx, offset programTitle
    call    WriteString
   
;USER INFO SECTION

;Gets userName
    mov     edx, offset usernamePrompt
    call    WriteString
    mov     edx, offset userName
    mov     ecx, 63                                 ;63 because it's the max amount they can enter


    mov     eax, userInputColor
    call    SetTextColor
    call    ReadString
    
    mov     eax, defaultColor
    call    setTextColor

    
;USER GREETING
    mov     edx, offset helloGreeting
    call    WriteString
    mov     eax, userInputColor
    call    SetTextColor
    mov     edx, offset userName

    call    WriteString
    mov     eax, defaultColor
    call    SetTextColor
    call    crlf
    call    crlf
   

    mov     edx, offset enterNumberPrompt
    call    WriteString
    mov     edx, offset finishPrompt
    call    WriteString
    jmp     getUserInput


;reprints the range, if the user enters a number not in the range. 
notInRange:
    mov     edx, offset enterNumberPrompt
    call    WriteString



;ALL USER INPUT NUMBERS
getUserInput:
    mov     edx, offset enterNumber
    call    WriteString

    call    ReadInt
    mov     userInputNumber, eax

;Compares the value of the user input to see if it's in the right range.
;Jumps out if it's not negative
    jns     notNegative



;Checks that it's in the range.
    cmp     eax, lowerLimit
    jl      notInRange
    cmp     eax, upperLimit
    jg      notInRange


;If we get here the number is valid, add it to the sum, and increase the amount of numbers.
   
    add     totalNumberSum, eax
    inc     validNumberCount

    call    crlf
    jmp     getUserInput




;CALCULATION SECTION

notNegative:
;Tests if there are 0 numbers entered.
    cmp     validNumberCount, 0
    je      noNumber


;Print info about what the user entered.
    mov     edx, offset youEntered
    call    WriteString
    mov     eax, validNumberCount
    call    WriteDec

    mov     edx, offset validNumbers
    call    WriteString

    mov     edx, offset sumOfNumbersPrompt
    call    WriteString

    mov     eax, totalNumberSum
    call    WriteInt

    call    crlf

    mov     edx, offset roundedAveragePrompt
    call    WriteString


;Calculating the average
    mov     eax, totalNumberSum
    cdq
    idiv    validNumberCount
    mov     averageResult, eax
    mov     remainder, edx



;if you divide X by Y and get "A remainder B", then if 2B>=Y, round up

    neg     remainder                       ;We neg to get it out of twos complement form
    mov     eax, remainder
    add     eax, remainder                  
    cmp     eax, validNumberCount
    jl      roundDown                        ;JL because if it's equal then we round down, i.e. -20.5 rounds to -21

    dec     averageResult
    
   
    

roundDown:
    mov     eax, averageResult
    call    WriteInt
    call    crlf
    jmp     endProgram


;Jump here if there were no numbers entered.
noNumber:
    mov     edx, offset noNumbers
    call    WriteString

;GOODBYE PROMPT
endProgram:
    mov     edx, offset goodbyePrompt
    call    WriteString

    mov     eax, userInputColor
    call    SetTextColor
    mov     edx, offset userName
    call    WriteString

    mov     eax, defaultColor
    call    SetTextColor

    mov     edx, offset period
    call    WriteString




INVOKE ExitProcess, 0
main ENDP
END main