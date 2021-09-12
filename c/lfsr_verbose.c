#!/usr/bin/tcc -run
/*
 * lfsr.c
 *
 * Author:  Sami Tanskanen
 * Date:    2021/09/12
 * Comment: A 16-, 32-, and 64-bit m-sequence linear-feedback shift register.
 *          I turned this into a monster by adding the option for more verbose
 *          output while not adding a separate branch to the LFSR loop.
 *          I asked if I could, but not if I should.
 */

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <inttypes.h>
#include <getopt.h>

#define N_ASCII(x) (48 + (x))

#define LFSR_LOOP(state, taps, out_bit)					\
total = total ? total : total | (__typeof__(state))~0;			\
if (verbose) {								\
	do {								\
		LFSR_VERBOSE(state, taps, out_bit);			\
	} while (count < total);					\
} else {								\
	do {								\
		LFSR(state, taps, out_bit);				\
	} while (count < total);					\
}									\
putchar('\n');

#define LFSR(state, taps, out_bit)					\
out_bit = (state							\
    ^ (state >> taps[0])						\
    ^ (state >> taps[1])						\
    ^ (state >> taps[2])) & one;					\
state = ((state >> 1) | (out_bit << hbit_i));				\
putchar(N_ASCII(out_bit));						\
count++;

#define LFSR_VERBOSE(state, taps, out_bit)				\
for (int i = hbit_i; i >= 0; i--) {					\
	putchar(N_ASCII((one << i & state) >> i));			\
}									\
putchar(' ');								\
LFSR(state, taps, out_bit);						\
printf(" %" PRIu64 "\n", count);

void die(int code);

int main(int argc, char* argv[])
{
	srand(time(NULL));

	uint64_t total = 0;
	int verbose = 0;
	int bits = 32;

	int opt = 0;
	while ((opt = getopt(argc, argv, "hvc:b:")) != -1) {
		switch (opt) {
		case 'h':
			die(0);
			break;
		case 'v':
			verbose = 1;
			break;
		case 'c':
			total = atol(optarg);
			if (total == 0 && optarg[0] != '0') {
				die(1);
			}
			break;
		case 'b':
			bits = atoi(optarg);
			switch (bits) {
			case 16: break;
			case 32: break;
			case 64: break;
			default: die(1);
			}
			break;
		case '?': // FALLTHROUGH
		default:
			die(1);
			break;
		}
	}

	const int hbit_i = bits - 1;
	const uint64_t one = 1;
	uint64_t count = 0;

	uint64_t state_64 = rand();
	const int taps_64[] = { 1, 3, 4 };
	uint64_t out_bit_64;

	uint32_t state_32 = (uint32_t)state_64;;
	const int taps_32[] = { 2, 6, 7 };
	uint32_t out_bit_32;

	uint16_t state_16 = (uint16_t)state_64;
	const int taps_16[] = { 2, 3, 5 };
	uint16_t out_bit_16;

	switch (bits) {
	case 16:
		LFSR_LOOP(state_16, taps_16, out_bit_16);
		break;
	case 32:
		LFSR_LOOP(state_32, taps_32, out_bit_32);
		break;
	default:
		LFSR_LOOP(state_64, taps_64, out_bit_64);
		break;
	}

	return 0;
}

void die(int code)
{
	puts("\
Usage: \n\
  lsfr [-b 16|32|64] [-c <number>] [-v] [-h] \n\
\n\
Options: \n\
  -b  Bitness (defaults to 32) \n\
  -c  Count (defaults to 2^bitness) \n\
      A count of 0 will cause an infinite loop \n\
  -v  Format output as \"<state in binary> <out bit> <current count>\" \n\
  -h  Show this message \
");
	exit(code);
}
