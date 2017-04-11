#include <stdio.h>

#define CYCLES 276423077
#define BOARD_CYCLES 300000000
#define MIN_TO_SEC 60

int Heart_Rate(void) {
	float period = CYCLES/BOARD_CYCLES;
	int BPM = MIN_TO_SEC/period;
	return BPM;
}

