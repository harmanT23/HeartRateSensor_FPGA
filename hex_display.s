# A program to display the temperature value onto the hex display

.equ ADDR_7SEG1, 0xFF200020
.equ ADDR_7SEG2, 0xFF200030

.data

.align 1

#A test temperature value

ROOM_TEMPERATURE: .hword 0x0171 	#This corresponds to the value 25.1875 as measured
									#by the sensor, which is roughly room temperature

#Store the decoded values for the hex segments in an array. So index 0 stores the decoded value for
#displaying 0. Since we wish to display temperature as a decimal value we only go from 0 to 9.  

.align 2

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

#Store a LUT for decoding the values of the floating points. Much easier than calculating it in assembly.
							
FLOATING_POINT_LOOKUP:

.word 0
.word 63
.word 125
.word 188
.word 250
.word 313
.word 313
.word 375
.word 438
.word 500
.word 563
.word 625
.word 688
.word 750
.word 813
.word 875
.word 938

.text

.global main

main:

#******************Initialization*****************
movia r10,ADDR_7SEG1
movia r11,ADDR_7SEG2 # Get address bases for the 7 seg displays

movia r12, HEX_LUT # store the address for the LUT for hex decoding
movia r4, FLOATING_POINT_LOOKUP # store the pointer to LUT for decoding floating values
movia r9, ROOM_TEMPERATURE # store a pointer to our measured temperature value
ldw r8, 0(r9) # get the measured temperature
 
#************************************************* 


#***********************MAIN PROGRAM**************************************

#*******************Extracting Decimal Part of the temperature**************
 
andi r2, r8, 0x000F #bit-mask to extract the first 4 bits --> these contain the floating point part
call CONVERT_FLOATING_POINT_TO_DECIMAL_DISPLAY
mov r4, r2 #store this as the argument for the next call(s)
mov r16, r4 #store a copy of r4
#*******************DISPLAYING Bit0 of Decimal Part************************
call extract_digit0
call HEX_DECODE
stwio r2,0(r10) 

#*******************DISPLAYING Bit1 of Decimal Part*************************
mov r17, r2
mov r4, r16
call extract_digit1
call HEX_DECODE
slli r2, r2, 8 
or r2, r2, r17 #concatenate display number
stwio r2, 0(r10)

#*******************DISPLAYING Bit2 of Decimal Part*************************
mov r17, r2
mov r4, r16
call extract_digit2
call HEX_DECODE
slli r2, r2, 16
or r2, r2, r17 #concatenate the display number
stwio r2, 0(r10)

#*******************EXTRACTING THE REAL PART*************************

#*******************DISPLAY B0*****************************************

mov r4, r8
srli r4, r4, 4 
mov r16, r4
call extract_digit0
call HEX_DECODE
mov r17, r2
stwio r2, 0(r11)

#******************DISPLAY B1*******************************************

mov r4, r16 
call extract_digit1
call HEX_DECODE
slli r2, r2, 8
or r2, r2, r17 #concatenate the display number
stwio r2, 0(r11)

#******************END_PROGRAM***********************************************
loop: br loop

#*****************SUBROUTINES*****************************************************

CONVERT_FLOATING_POINT_TO_DECIMAL_DISPLAY:

# A subroutine that converts the floating point part of the temperature value
# to a decimal number. Bits 0-3 of the temperature value measured by the sensor,
# where bit 0 corresponds to 2^(-4) = 0.0625 and bit 3 corresponds to 2^(-1) = 0.25
#r2 is the isolated floating point value, eg = 0x00000003
 
muli r2, r2, 4 #since the LUT is an array of words
add r2, r4, r2 
ldw r2, 0(r2) # accessing the index of the array
ret

HEX_DECODE:

muli r2, r2, 4
add r2, r2, r12
ldw r2, 0(r2) #r2 contains the decoded value of the number
ret



 



