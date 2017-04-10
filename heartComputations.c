#include <stdio.h>

int Heart_Rate(int timedCycles, int totalTimeCycles, int BoardCycles, int minPerSec) {
	int numCycles = totalTimeCycles - timedCycles;
	int period = numCycles/BoardCycles;
	int BPM = minPerSec/period;
	return BPM;
}

