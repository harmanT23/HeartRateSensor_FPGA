.equ ADC_CH0, 0xFF204000
.equ ADC_CONTROL, 0xFF204004
.equ HEART_THRESHOLD, 0x00008A00
.equ THREE_SECOND_INTERVAL, 0x11E1A300
.equ Timer2, 0xFF202020
.equ CLOCK_CYCLES_PER_SECOND, 0x5F5E100
.equ SIXTY_SECONDS, 0x3C

.global main

main:
	
	#********************Initialize Timer2*******************
	movia r8, Timer2 #Timer 2 address in register 2
	
	movui r9, %lo(THREE_SECOND_INTERVAL) 
	stwio r9, 8(r8)  #Counter start value(low)
	
	movui r9, %hi(THREE_SECOND_INTERVAL) 
	stwio r9, 12(r8) #Counter start value (high)
	#******************************************************
	
	#******************Initialize ADC**********************
	movui r10, 0x1 #Reset value to 0; Used to determine if a heart beat occured
	movia r3, ADC_CONTROL #ADC control address in register 3
	stwio r10, 0(r3) #Set ADC to auto update
	#*****************************************************

	Main_Loop:
		call Get_ADC_CH0 #Get the current ADC value
		mov r4, r2 #Transfer ADC value as argument
		call Heart_Contract
		call Heart_Expand
		mov r4, r2 #Transfer Timer value 
		call Heart_Beat
		br Main_Loop

Get_ADC_CH0:
	movia r7, ADC_CH0  #Store channel 0 address into r7
	ldwio r2, 0(r7) #Read the value from ADC channel 0 into r2
	ret

Heart_Contract:
	movia r7, HEART_THRESHOLD 
	blt r4, r7, Heart_Contract_True #Check if value read is less than threshold value; If so we assume the user heart contracted
	ret
	
Heart_Contract_True:
	#Start the timer and begin counting down from 3
	stwio r0, 0(r8) #Reset timer2
	movui r9, 0b100	#Start Timer
	stwio r9, 4(r8)
	ret

Heart_Expand:
	movia r7, HEART_THRESHOLD
	bgt r4, r7, Heart_Expand_True #Check if value read is more than threshold value; if so we assume the user heart has expanded
	ret
	
Heart_Expand_True:
	#Take snapshot of the time and store it
	movia r8, Timer2 #Timer 2 address in register 2
	stwio r0, 16(r8) #Tell timer to take a snapshot of the time
	ldwio r7, 16(r8) #Read bits 0-15
	ldwio r2, 20(r8) #Read bits 16-31
	slli r2, r2, 16 #Shift left logically
	or r2, r2, r7 #Combine bits 0 through 31
	#stop the timer
	movui r9, 0b1000
	stwio r9, 4(r8)
	ret

Heart_Beat:
	#Check if timer has stopped;
	movia r8, Timer2 #Timer 2 address in register 2
	ldw r9, 4(r8)
	andi r9, r9, 0x00000008 #mask all the bits except stop bits
	movui r8, 0x1
	beq r9, r8, Heart_Beat_True  #If timer has stopped we know a heart beat has occured

	ret

Heart_Beat_True:
	#Compute the period of the heart beat
	#r4 holds timed cycles
	movia r5, THREE_SECOND_INTERVAL
	movia r6, CLOCK_CYCLES_PER_SECOND
	movi r7, SIXTY_SECONDS
	ret



