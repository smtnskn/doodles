#!/usr/bin/tcc -run

/*
 * lfsr.c
 *
 * Author:  Sami Tanskanen
 * Date:    2021/09/11
 * Comment: A 16-, 32-, and 64-bit m-sequence linear-feedback shift register
 */

#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <inttypes.h>

#define N_ASCII(x) (48 + (x))

// TODO: make string in printloop and and print once?
#define LFSR(init_state, state, taps, out_bit)				\
do {									\
	for (int i = hbit_i; i >= 0; i--) {				\
		putchar(N_ASCII((one << i & state) >> i));		\
	}								\
	putchar(' ');							\
	out_bit = (state						\
	    ^ (state >> taps[0])					\
	    ^ (state >> taps[1])					\
	    ^ (state >> taps[2])) & one;				\
	state = ((state >> 1) | (out_bit << hbit_i));			\
	iter++;								\
	putchar(N_ASCII(out_bit));					\
	printf(" %" PRIu64 "\n", iter);					\
} while (init_state != state);

int main(int argc, char* argv[])
{
	srand(time(NULL));

	int bits = 32;

	// TODO: getopts:
	//  -v to print with PRINT_BITS
	//  -b to choose size
	//  -c to exit when iter == c

	const int hbit_i = bits - 1;
	const uint64_t one = 1;
	uint64_t iter = 0;

	const uint64_t init_state_64 = rand();
	uint64_t state_64 = init_state_64;
	const int taps_64[] = { 1, 3, 4 };
	uint64_t out_bit_64;

	const uint32_t init_state_32 = (uint32_t)init_state_64;
	uint32_t state_32 = init_state_32;
	const int taps_32[] = { 2, 6, 7 };
	uint32_t out_bit_32;

	const uint16_t init_state_16 = (uint16_t)init_state_64;
	uint16_t state_16 = init_state_16;
	const int taps_16[] = { 2, 3, 5 };
	uint16_t out_bit_16;

	switch (bits) {
	case 16:
		LFSR(init_state_16, state_16, taps_16, out_bit_16);
		break;
	case 32:
		LFSR(init_state_32, state_32, taps_32, out_bit_32);
		break;
	default:
		LFSR(init_state_64, state_64, taps_64, out_bit_64);
		break;
	}

	return 0;
}
