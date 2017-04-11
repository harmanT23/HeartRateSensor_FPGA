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
	
	br END

END:
	br END
	