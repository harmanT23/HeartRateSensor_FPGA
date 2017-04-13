.equ ADC_CH0, 0xFF204000
.equ ADC_CONTROL, 0xFF204004
.equ HEART_THRESHOLD, 0x000015D0
.equ MAX_VAL_LIMIT, 0x00007530
.equ THREE_SECOND_INTERVAL, 0x11E1A300
.equ ONE_SECOND_INTERVAL, 0x05F5E100
.equ Timer2, 0xFF202020
.equ Timer1, 0xFF202000 
.equ CLOCK_CYCLES_PER_SECOND, 0x5F5E100
.equ SIXTY_SECONDS, 0x3C
.equ AUDIO_CORE, 0xFF203040
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ VERTICAL_LENGTH, 50
.equ HORIZONTAL_LENGTH, 0x64 
.equ END_ADDRESS_VERTICAL, 0x0803900A
.equ END_ADDRESS_HORIZTONAL, 0x0803926A
.equ WHITE, 0xFFFF  #White pixel 
.equ HORIZ_AXIS_LABEL, 0x09001D23
.equ VERT_AXIS_LABEL,0x09000F00
.equ ORIGIN, 0x08038C0C

.global main

main:
	
	#******************Initialize ADC**********************
	movui r10, 0x1 #set auto-update on ADC to on
	movia r3, ADC_CONTROL #ADC control address in register 3
	stwio r10, 0(r3) #Set ADC to auto update
	#*****************************************************
	
	#****DRAW INITIAL EMPTY GRAPH**************************
	call PrintTitle
	call PrintHorizAxis_Title
	call PrintVertAxis_Title
	call DrawVerticalAxis
	call DrawHoriztonalAxis
	#******************************************************
	
	Main_Loop:
		call Heart_Contract
		call Heart_Expand
		br Main_Loop

PrintTitle:
	movia r2, ADDR_CHAR
	movi r5, 0x48 #H
	stbio r5, 33(r2)
	movi r5, 0x65 #e
	stbio r5, 34(r2)
	movi r5, 0x61 #a
	stbio r5, 35(r2)
	movi r5, 0x72 #r
	stbio r5, 36(r2)
	movi r5, 0x74 #t
	stbio r5, 37(r2)
	movi r5, 0x20 #' '
	stbio r5, 38(r2)
	movi r5, 0x52 #R
	stbio r5, 39(r2)
	movi r5, 0x61 #a
	stbio r5, 40(r2)
	movi r5, 0x74 #t
	stbio r5, 41(r2)
	movi r5, 0x65 #e
	stbio r5, 42(r2)
	ret

PrintHorizAxis_Title:
	movia r2, HORIZ_AXIS_LABEL
	movi  r5, 0x53 #S
	stbio r5, 0(r2)
	addi r2, r2, 1
	movi  r5, 0x61 #a
	stbio r5, 0(r2)
	addi r2, r2, 1
	movi  r5, 0x6D #m
	stbio r5, 0(r2)
	addi r2, r2, 1
	movi  r5, 0x70 #p
	stbio r5, 0(r2)
	addi r2, r2, 1
	movi  r5, 0x6C #l
	stbio r5, 0(r2)
	addi r2, r2, 1
	movi  r5, 0x65 #e
	stbio r5, 0(r2)
	ret

PrintVertAxis_Title:
	movia r2, VERT_AXIS_LABEL
	movi  r5, 0x42 #B
	stbio r5, 0(r2)
	addi r2, r2, 128
	movi  r5, 0x50 #P
	stbio r5, 0(r2)
	addi r2, r2, 128
	movi  r5, 0x4D #M
	stbio r5, 0(r2)

DrawVerticalAxis:
	movui r6, WHITE
	movia r4, ADDR_VGA
	addi r4, r4,0x140A
	movia r5, END_ADDRESS_VERTICAL
	VerticalAxis:
		sthio r6, 0(r4)
		addi r4, r4, 0x400
		blt r4, r5, VerticalAxis
	ret

	
DrawHoriztonalAxis:
	movui r6, WHITE
	movia r4, END_ADDRESS_VERTICAL
	movia r5, END_ADDRESS_HORIZTONAL
	HorizontalAxis:
		sthio r6, 0(r4)
		addi r4, r4, 0x1
		blt r4, r5, HorizontalAxis
	ret
	
Get_ADC_CH0:
	movia r7, ADC_CH0  #Store channel 0 address into r7
	ldwio r4, 0(r7) #Read the value from ADC channel 0 into r2
	ret

Heart_Contract:
	addi sp, sp, -4
	stw ra, 0(sp)
	
	Heart_Contract_Loop:
		call Get_ADC_CH0 #Get latest sensor value which is stored in r4
		movi r7, HEART_THRESHOLD
		addi r7, r7, MAX_VAL_LIMIT
		bgt r4, r7, Heart_Contract_Loop #Keep calling heart contract until the value is less than the threshold, in which case, the heart has contracted.
	
	call Heart_Contract_True
	
	ldw ra, 0(sp)
	addi sp, sp, 4
	ret
	
Heart_Contract_True:
	#Initialize timer2 and have it count down from 3 seconds
	movia r8, Timer2 #Timer 2 address in register 2
	
	movui r9, %lo(THREE_SECOND_INTERVAL) 
	stwio r9, 8(r8)  #Counter start value(low)
	
	movui r9, %hi(THREE_SECOND_INTERVAL) 
	stwio r9, 12(r8) #Counter start value (high)
	#******************************************************
	stwio r0, 0(r8) #Clear timer2 settings 
	
	movui r9, 0b0101	#Start Timer2; Enable interrupts
	stwio r9, 4(r8)
	
	#Enable interrupts
	movui r9, 0x4
	wrctl ienable, r9 
	
	#Set interrupt enable to 12
	movui r9, 0x1
	wrctl status, r9
	ret

Heart_Expand:
	addi sp, sp, -4
	stw ra, 0(sp)
	
	Heart_Expand_Loop:
		call Get_ADC_CH0 #Get latest sensor value which is stored in r4	
		movi r7, HEART_THRESHOLD
		addi r7, r7, MAX_VAL_LIMIT
		blt r4, r7, Heart_Expand_Loop #Keep calling heart expand until the value is greater than the threshold, in which case, the heart has expanded.
	
	call Heart_Expand_True
	
	ldw ra, 0(sp)
	addi sp, sp, 4
	
	ret	

Heart_Expand_True:
	#Check if timer2 is on
	movia r8, Timer2 #Timer 2 address in register 2
	ldw r9, 0(r8)
	andi r9, r9, 0x00000001 #mask all the bits except timeout bit
	movui r8, 0x1
	bne r9, r8, Heart_Beat #if timeout bit is 0; then the timer is on
	ret 
	
Heart_Beat:
	addi sp, sp, -4
	stw ra, 0(sp)
	#Take snapshot of the time and store it
	movia r8, Timer2 #Timer 2 address in register 8
	stwio r0, 16(r8) #Tell timer to take a snapshot of the time
	ldwio r7, 16(r8) #Read bits 0-15
	ldwio r2, 20(r8) #Read bits 16-31
	slli r2, r2, 16 #Shift left logically
	or r2, r2, r7 #Combine bits 0 through 31
	#stop the timer
	movui r9, 0b1000
	stwio r9, 4(r8)
	
	mov r4, r2 #move number of elapsed cycles from starting time to r4
	
	call Heart_Rate #compute heart rate
	
	mov r4, r2 #move heart rate from r2 to r4
	
	call console_heart_rate #Print to console the heart rate
	
	call Delay #Create a one second delay
	
	ldw ra, 0(sp)
	addi sp, sp, 4
	ret


Delay:
	
	#********************Initialize Timer1*******************
	movia r8, Timer1 #Timer 1 address in register 2
	
	movui r9, %lo(ONE_SECOND_INTERVAL) 
	stwio r9, 8(r8)  #Counter start value(low)
	
	movui r9, %hi(ONE_SECOND_INTERVAL) 
	stwio r9, 12(r8) #Counter start value (high)
	#******************************************************
	stwio r0, 0(r8) #Clear Timer1 settings
	movui r9, 0b0101 #Start Timer1; Enable interrupts
	stwio r9, 4(r8)
	
	#Enable interrupts for timer 1
	movui r9, 0x1
	wrctl ienable, r9 
	
	#Set interrupt enable to 1
	movui r9, 0x1
	wrctl status, r9
	
	movi r15, 0x0
	
	Wait_Till_Interrupt:
		beq r15, r0,  Wait_Till_Interrupt
	
	ret
	

#**************************TIMER ISR*****************************************
	.section .exceptions, "ax" 
	
TIMER_ISR:
	rdctl et, ipending #checking ipending 
	andi r14, et, 0x4 #Check if IRQ Line 2 caused the interrupt
	beq r14, r0, checkTimer1
	
	#Print out: Heart Arythmia detected 
	call heart_warning
	
	
	#*************Heart Flatline Wav Sound*******************
	movia r10, END_SOUND_FL
	movia r6, AUDIO_CORE
	movia r4, Heart_FLATLINE_SOUND
	movi r7, 48
	mov r8, r7
	#****************************************************
	#The following code is a modified version of the Audio Output test example on
	#http://nios.stuffedcow.net/
	
	WaitForWriteSpace_FL:
		ldwio r2, 4(r6)
		andhi r3, r2, 0xFF00 
		beq r3, r0, WaitForWriteSpace_FL
		andhi r3, r2, 0x00FF
		beq r3, r2, WaitForWriteSpace_FL
		
	WriteTwoSamples_FL:
		ldh r5, 0(r4) #Load a byte of data from r4
		slli r5, r5, 16 #shift left 16 bits
		stwio r5, 8(r6) #Send to left channel

		addi r4, r4, 2 #Shift r4 to the next half word of audio
		beq r4, r10, Acknowledge_2 #Check if we have hit end of audio

		ldh r5, 0(r4) #Load a half word of data from r4
		slli r5, r5, 16 #shift left 16 bits
		stwio r5, 12(r6) #Send to right channel

		addi r4, r4, 2 #Shift r4 to the next half word of audio
		beq r4, r10, Acknowledge_2 #Check if we have hit end of audio

		subi r8, r8, -1
		bne r8, zero, WaitForWriteSpace_FL
			
	
	#Acknowledge interrupt timer 2
	Acknowledge_2:
	movia et, Timer2
	stwio r0, 0(et) #Reset timer 
	br exit
	
	
	#TIMER1 ISR*********************************************************
	checkTimer1:
		andi r14, et, 0x1 #Check if IRQ Line 1 caused the interrupt
		beq r14, r0, exit #Exit if timer1 didn't cause it
		
		#*************Heart Beat Wav Sound*******************
		movia r10, END_SOUND
		movia r6, AUDIO_CORE
		movia r4, HEART_BEAT_SOUND
		movi r7, 48
		mov r8, r7
		#****************************************************
		#The following code is a modified version of the Audio Output test example on
		#http://nios.stuffedcow.net/
		
		WaitForWriteSpace:
			ldwio r2, 4(r6)
			andhi r3, r2, 0xFF00 
			beq r3, r0, WaitForWriteSpace
			andhi r3, r2, 0x00FF
			beq r3, r2, WaitForWriteSpace
	
		WriteTwoSamples:
			ldh r5, 0(r4) #Load a byte of data from r4
			slli r5, r5, 16 #shift left 16 bits
			stwio r5, 8(r6) #Send to left channel
	
			addi r4, r4, 2 #Shift r4 to the next half word of audio
			beq r4, r10, SOUND_COMPLETE #Check if we have hit end of audio
	
			ldh r5, 0(r4) #Load a half word of data from r4
			slli r5, r5, 16 #shift left 16 bits
			stwio r5, 12(r6) #Send to right channel
	
			addi r4, r4, 2 #Shift r4 to the next half word of audio
			beq r4, r10, SOUND_COMPLETE #Check if we have hit end of audio
	
			subi r8, r8, -1
			bne r8, zero, WaitForWriteSpace
			br SOUND_COMPLETE
		
		SOUND_COMPLETE:
			br Acknowledge
			
		Acknowledge:
			movia et, Timer1
			stwio r0, 0(et) #Reset timer
			movi r15, 0x1
			br exit
			
exit:
	subi ea, ea, 4
	eret
#****************DATA*************************************
	.section .data

Heart_FLATLINE_SOUND: .incbin "heartFlatLine.wav"
END_SOUND_FL:	
	
HEART_BEAT_SOUND: .incbin "HeartBeat_1_Second.wav" 
END_SOUND:
