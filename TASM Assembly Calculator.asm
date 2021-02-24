.model small
.stack 100h

;Group Members
;Kehli Cousins 1602962
;Brittaney Anderson 1603708
;Gabrielle Watson 1603805

; ---------- Data Segment ----------
.data
    num1F db 0  ;NUM1 FIRST DIGIT
    num1S db 0  ;NUM1 SECOND DIGIT
    num2F db 0  ;NUM2 FIRST DIGIT
    num2S db 0  ;NUM2 SECOND DIGIT
    mult_by_ten_num1 db 0
    mult_by_ten_num2 db 0
    ten db 10
    q db ?
    r db ?
    DIFF db ?
    DIFFu db ?

    welcome db 13,10,"Welcome to our Assembly Calculator :)"
            db 13,10,13,10,"Enter two numbers and it will perform Addition, Multiplication, Subtaction and Division at the same time!"
            db 13,10,"Please ensure your first number is larger than the second and in the form '00, 01, 02 etc'"
            db 13,10,"This calculator can only accept two digit numbers at the moment",'$'
    val1 db 13,10,13,10,"Enter first number:",'$'
    val2 db 10,13,"Enter second number:",'$'

    mult_resultmsg db 10,13,10,13,"Product:",'$'
    add_resultmsg db 10,13,10,13,"Sum:",'$'

    quotient_msg db 10,13,10,13,"Quotient: ",'$'
    remainder_msg db 10,13,"Remainder: ",'$'

    sub_resultmsg db 10,13,10,13,"Difference: $"

; ---------- Code Segment ----------
.code
main proc
    MOV AX,@data
    MOV DS,AX
    
    mov DX, OFFSET welcome
    mov AH, 09H 
    int 21H 
    
    mov DX, OFFSET val1 
    mov AH, 09H 
    int 21H 
    
   ;reads the first digit of first number 
    mov AH, 01H 
    int 21H
    sub AL, 30H 
    mov num1F, AL 
    
   ;reads the second digit of first number 
    mov AH, 01H 
    int 21H 
    ;adjusts second digit ASCII to decimal value and moves it into BL 
    sub AL, 30H 
    mov num1S, AL  
     
    mov DX, OFFSET val2
    mov AH, 09H 
    int 21H 
     
    ;reads the first digit of second number 
    mov AH, 01H 
    int 21H
    sub AL, 30H 
    mov num2F, AL 
     
    ;reads the second digit of second number 
    mov AH, 01H 
    int 21H
    sub AL, 30H 
    mov num2S, AL
    
    xor ax,ax ;clear AX
    xor bx,bx ;clear BX
    
    call mult_ten ;call function that multiplies digits by ten
    
    ; ---------- Division ----------
    mov AL, mult_by_ten_num1 ; The dividend
    mov BL, mult_by_ten_num2 ; The divisor
    
    div BL ; Diving Time

    mov q, AL ; The quotient
    mov r, AH ; The remainder

    ; Display the Quotient
    mov DX, OFFSET quotient_msg
    mov AH, 09H 
    int 21H

    mov DL, q
    add DL, 48
    mov AH, 02H
    int 21H

    ; Display the Remainder
    mov DX, OFFSET remainder_msg
    mov AH, 09H 
    int 21H

    mov DL, r
    add DL, 48
    mov AH, 02H
    int 21H
    
    xor ax,ax ;clear AX
    xor bx,bx ;clear BX
    
    ; ---------- ADDITION ----------
    mov BH,num1F
    mov BL,num1S
    
    mov CH,num2F
    mov CL,num2S
     
    ;addition of BL and CL
    add BL, CL 
     
    mov AL, BL 
    mov AH, 00H 
    aaa 
     
    mov CL, AL ; LAST DIGIT OF ANSWER 
    mov BL, AH 
     
    add BL, BH 
    add BL, CH 
     
    mov AL, BL 
    mov AH, 00H 
    aaa 
     
    mov BX, AX
    
    mov DX, OFFSET add_resultmsg
    mov AH, 09H 
    int 21H 
     
    mov DL, BH 
    add DL, 30H 
    mov AH, 02H 
    int 21H 
     
    mov DL, BL 
    add DL, 30H 
    mov AH, 02H 
    int 21H 
     
    mov DL, CL 
    add DL, 30H 
    mov AH, 02H 
    int 21H
    ;end of addition
    
    xor ax,ax ;clear AX
    xor bx,bx ;clear BX
    
    ; ---------- SUBTRACTION ----------
    mov BH,num1F
    mov BL,num1S
    
    mov CH,num2F
    mov CL,num2S
    
    
    ;subtract one place digit
    sub BL, CL
    
    jnc  NOOVF  ;if 25 - 16 (if ones digit of first number lower) DONT JUMP
                ;if 25 -24 (if ones digit of first number higher) JUMP to NOOVF
    
    sub  BH,1   ;subtracts one from tens place first number
    add  BL,10  ;adds 10 to ones place first number ; if (ones place) 5 - 6 = -1 -> -1+10 = 9
    
    NOOVF:      ;function when borrowing from 10s place is not necessary (if ones digit of first number higher)
       SUB  BH, CH  ;subtracts second number 10s digits from first number 10s digit
       
    MOV DIFF, BH ; that's the TENS digit of the result
    MOV DIFFu, BL ; That's the UNITS digit of the result
       
    mov DX, OFFSET sub_resultmsg
    mov AH, 09H 
    int 21H 
    
    xor dx,dx 
    mov DL, DIFF 
    add DL, 30H 
    mov AH, 02H 
    int 21H 
         
    mov DL, DIFFu 
    add DL, 30H
    mov AH, 02H 
    int 21H 
     
    ; ---------- MULTIPLICATION ----------
    
    ;Multiply num2 by num1. Product is in AX
    mov al,mult_by_ten_num1
    mul mult_by_ten_num2
    
    mov cx,ax   ;move product into cx as AH is often manipulated

    ;print Product/Result
    mov DX,offset mult_resultmsg 
    mov AH,9 
    int 21H

    ;prints digit in 1000's position
    ;Clears dx register and moves Product back into AX, BX is initialized with 1000
    xor dx,dx 
    mov ax,cx
    mov bx,03E8h
    div bx
    call printdig 

    ;prints digit in 100's position
    mov ax,dx
    xor dx,dx
    mov bx,0064h
    div bx
    call printdig

    ;prints digit in 10's position
    mov ax,dx
    xor dx,dx
    mov bx,00Ah
    div bx
    call printdig

    ;remainder from last div still in dx
    mov al,dl
    call printdig

    ;terminates multiplication
    mov AH,04ch
    int 21H
     
main endp

printdig proc ;prints digits individually
    push dx
    mov dl,al
    add dl,30h
    mov ah,02h
    int 21h
    pop dx
    ret
printdig endp

mult_ten proc ;multiplies digits entered by ten

    ;moves first digit of first number into AL multiplies by 10 and stores it in mult_num1 variable
    mov AL,num1F
    mul ten
    mov mult_by_ten_num1,AL 
    
    ;moves first digit of first number into AL multiplies by 10 and stores it in mult_num1 variable
    mov AL,num1S
    add mult_by_ten_num1,AL 

    ;moves first digit of second number into AL multiplies by 10 and stores it in mult_num2 variable
    mov AL,num2F
    mul ten
    mov mult_by_ten_num2,AL 

    ;read the second digit of second number
    mov AL,num2S
    add mult_by_ten_num2,AL
    ret
mult_ten endp

end main