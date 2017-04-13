.equ ADDR_7SEG1, 		0xFF200020			# Hex Display 0-3 Base Address
.equ ADDR_7SEG2, 		0xFF200030			# Hex Display 4-5 Base Address
.equ Heart_Rate, 72

.data 

.align 2

DECIMAL_DOT : .word 0x0000005C 

HEX_LUT:

.word 0x0000003F #0 
.word 0x00000006 #1
.word 0x0000005B #2
.word 0x0000004F #3
.word 0x00000066 #4
.word 0x0000006D #5
.word 0x0000007D #6
.word 0x00000007 #7
.word 0x0000007F #8
.word 0x00000067 #9

SEDENTARY: .word 4

MODERATE: .word 6

ATHLETIC: .word 9

.text 

.global main

main:

#*******************HEX DISPLAY SETUP*************

movia r10,ADDR_7SEG1
movia r11,ADDR_7SEG2 # Get address bases for the 7 seg displays

movia r12, HEX_LUT # store the address for the LUT for hex decoding
 
#************************************************* 

#********************FLUSH/RESET HEX DISPLAY*******************************

movia r19,0x00000000 
stwio r19,0(r10)
stwio r19,0(r11) 

#*******************MAIN********************


movui r4, Heart_Rate
call Calculate_Calories
mov r18, r4 
call extract_digit0
call HEX_DECODE
stwio r2, 0(r11)

mov r4, r18
mov r18, r2
call extract_digit1
call HEX_DECODE
slli r2, r2, 8
or r2, r2, r17 #concatenate the display number
stwio r2, 0(r11)



Calculate_Calories:

movui r5, 85
bgt r4, r5, CHECK_MODERATE_OR_ATHLETIC

movui r2, SEDENTARY

ret

CHECK_MODERATE_OR_ATHLETIC:

movui r6, 100
bgt r4, r6, DECLARE_ATHLETIC

movui r2, MODERATE

ret

DECLARE_ATHLETIC:

movui r2, ATHLETIC

ret

HEX_DECODE:

muli r2, r2, 4
add r2, r2, r12
ldw r2, 0(r2) #r2 contains the decoded value of the number
ret

	

 