.equ Timer2, 0xFF202020
.equ THREE_SECOND_INTERVAL, 0x11E1A300

.global main

main:


	#********************Initialize Timer2*******************
	movia r8, Timer2 #Timer 2 address in register 2
	
	movui r9, %lo(THREE_SECOND_INTERVAL) 
	stwio r9, 8(r8)  #Counter start value(low)
	
	movui r9, %hi(THREE_SECOND_INTERVAL) 
	stwio r9, 12(r8) #Counter start value (high)
	#******************************************************
	
	movui r9, 0b0100	#Start Timer2
	stwio r9, 4(r8)
	call Get_timer_value
	
	
Get_timer_value:
	#Take snapshot of the time and store it
	movia r8, Timer2 #Timer 2 address in register 8
	stwio r0, 16(r8) #Tell timer to take a snapshot of the time
	ldwio r7, 16(r8) #Read bits 0-15
	ldwio r2, 20(r8) #Read bits 16-31
	slli r2, r2, 16 #Shift left logically
	or r2, r2, r7 #Combine bits 0 through 31
	br Get_timer_value
	

	
