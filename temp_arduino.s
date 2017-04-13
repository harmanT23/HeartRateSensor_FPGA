.equ ADDR_JP1PORT, 		0xFF200060 			# JP1 Base Address
.equ JP1_DR_OFFSET,   	0x0             	# DR is at PIT1_BASE + PIT_DR_OFFSET
.equ JP1_DIR_OFFSET,  	0x4         		# DIR at PIT1_BASE + PIT_DIR_OFFSET 
.equ Timer1, 0xFF202000 
  
  .global _start
  
  _start:  
  
movia r7, ADDR_JP1PORT
movia r11, 0xFFFFFFFF
stwio r11, JP1_DIR_OFFSET(r7)

stwio r11, JP1_DR_OFFSET(r7)