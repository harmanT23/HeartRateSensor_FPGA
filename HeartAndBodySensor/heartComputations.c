#include <stdio.h>

#define TOTAL_CYCLES 300000000
#define BOARD_CYCLES 100000000.0
#define MIN_TO_SEC 60.0
#define MIN_HR 0
#define MAX_HR 170

int Heart_Rate(int timedCycles) {
	int numCycles = TOTAL_CYCLES - timedCycles; 
	float period = numCycles/BOARD_CYCLES;
	
	if(period < 0.1) //To account for hypersensitivity of sensor
		period = 1 - period;
	
	int BPM = MIN_TO_SEC/period;
	
	if((BPM > MIN_HR) && (BPM < MAX_HR))
		return BPM;
	
	return 0;
}

