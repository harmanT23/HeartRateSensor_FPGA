#include <stdio.h>

//Code adopted from: http://www-ug.eecg.toronto.edu/msl/nios.html
#define JTAG_UART_DATA ((volatile int*) 0xFF201000)
#define JTAG_UART_CONTROL ((volatile int*) (0xFF201000+4))


void heart_warning(void) {
	
	unsigned char prompt[] = {'H', 'e', 'a', 'r', 't', ' ', 'A', 'r', 'r', 'h', 'y', 't', 'h', 'm', 'i', 'a', ' ', 'd', 'e', 't', 'e', 'c', 't', 'e', 'd', '\n', '\0'};
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
}