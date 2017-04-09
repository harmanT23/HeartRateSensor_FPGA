.equ ADC_CH0, 0xFF204000
.equ ADC_CONTROL, 0xFF204004
.equ JTAG_UART, 0xFF201000


.global _start
_start:
	
	movui r2, 0x1 
	stwio r2, 0(ADC_CONTROL) #Set ADC to auto update

	Main_Loop:
		call Poll_ADC_CH0 #Get the current ADC value
		mov r4, r2
		call Print_Raw_Value




Poll_ADC_CH0:
	ldw r2, 0(ADC_CH0) #Read the value from ADC channel 0 
	ret #return 

Print_Raw_Value:
	movia r7, 0xFF201000 #The base Address for the JTAG UART
	stwio r4, 0(r7) #send 1 bit of information to JTAG UART
	srli r4, 1 #Shift r4 by 1 bit to the right until it is all 0's
	bne r4, r0, Print_Raw_Value
	ret
