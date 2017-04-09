#What do we need to do? 

#The arduino ADC converts the analog value to digital. Let's say that this coverted signal flows through a wire that connects to a specific pin in the GPIO.
#We need to read the data value coming into this pin. Then we need to parse this data into meaningful output signal, i.e. temperature. Finally we output this number
#onto the hex display. 

#The part that I need to figure out is how to parse the data. So I need to know more about the sensor and what it does, ie. what are the values that the ADC converts to? 


#The analog values read by the temperature sensor are converted to digital values by the arduino's ADC. 
#The resulting digital signal now needs to be 

.equ ADDR_JP1PORT, 0xFF200060
.equ ADDR_JP1PORT_DIR, 0xFF200064

.text

#configure all 32-bits of the GPIO to input

movia r9,ADDR_JP1PORT
stwio r0,4(r9)

#read values of the input. Say we connect the sensor to D0

ldwio r3,(r9)
andi r3, 0x00000001 #bit-mask r3 to reflect only the read in value of the temperature data.

#We have now found the required temperature value. 
 

