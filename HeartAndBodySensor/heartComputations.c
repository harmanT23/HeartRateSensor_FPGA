#include <stdio.h>

#define TOTAL_CYCLES 300000000
#define BOARD_CYCLES 100000000.0
#define MIN_TO_SEC 60.0

int Heart_Rate(int timedCycles) {
	int numCycles = TOTAL_CYCLES - timedCycles; 
	float period = numCycles/BOARD_CYCLES;
	int BPM = MIN_TO_SEC/period;
	return BPM;
}

