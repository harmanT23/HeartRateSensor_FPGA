#include <stdio.h>

int Heart_Rate(int timedCycles, int totalTimeCycles, int BoardCycles, int minPerSec) {
	int numCycles = totalTimeCycles - timedCycles;
	float period = numCycles/BoardCycles;
	int BPM = minPerSec/period;
	return BPM;
}

