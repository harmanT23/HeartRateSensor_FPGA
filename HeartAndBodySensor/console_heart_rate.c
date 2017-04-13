#include <stdio.h>

#define MAX_SIZE 4

//Code adopted from: http://www-ug.eecg.toronto.edu/msl/nios.html
#define JTAG_UART_DATA ((volatile int*) 0xFF201000)
#define JTAG_UART_CONTROL ((volatile int*) (0xFF201000+4))

void console_heart_rate(int heartRate) {
	
	if(heartRate !=0) {
	
		unsigned char prompt[] = {'H', 'e', 'a', 'r', 't', ' ', 'R', 'a', 't', 'e', ':', ' ', '\0'};
		unsigned char *prompt_;
		prompt_ = prompt;
		
		//Print the prompt
		while(*prompt_)  {
		 //if room in output buffer
		 if((*JTAG_UART_CONTROL)&0xffff0000  ) 
		 {
			//then write the next character
			*JTAG_UART_DATA = (*prompt_++); 
		 }
		}
		
		
		unsigned char int_string[MAX_SIZE];
		snprintf(int_string, MAX_SIZE, "%d", heartRate);
		unsigned char *charArray;
		charArray = int_string;
		
		//Print the heart rate
		while(*charArray)  {
		 //if room in output buffer
		 if((*JTAG_UART_CONTROL)&0xffff0000  ) 
		 {
			//then write the next character
			*JTAG_UART_DATA = (*charArray++); 
		 }
		}
		
		
		unsigned char newLine[] = {' ', 'B', 'P', 'M', '\n', '\0'};
		unsigned char *newLine_;
		newLine_ = newLine;
		
		//The new line character
		while(*newLine_)  {
		 //if room in output buffer
		 if((*JTAG_UART_CONTROL)&0xffff0000  ) 
		 {
			//then write the next character
			*JTAG_UART_DATA = (*newLine_++); 
		 }
		}
	}
	
	
}