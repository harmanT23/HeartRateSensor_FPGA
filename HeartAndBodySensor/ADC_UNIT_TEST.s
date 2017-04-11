.equ ADC_CH0, 0xFF204000
.equ ADC_CONTROL, 0xFF204004

.global main

main:

	#******************Initialize ADC**********************
	movui r10, 0x1 #set auto-update on ADC to on
	movia r3, ADC_CONTROL #ADC control address in register 3
	stwio r10, 0(r3) #Set ADC to auto update
	#*****************************************************
	
	call Get_ADC_CH0

	br END
	
Get_ADC_CH0:
	movia r7, ADC_CH0  #Store channel 0 address into r7
	ldwio r4, 0(r7) #Read the value from ADC channel 0 into r2
	br Get_ADC_CH0
	
END:
	br END
	