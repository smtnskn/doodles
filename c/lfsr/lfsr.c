/* #!/usr/bin/tcc -run */
/*
 * lfsr.c v0.0.2
 *
 * Author:  Sami Tanskanen
 * Date:    2021/09/13
 * Comment: A 16-, 32-, and 64-bit m-sequence linear-feedback shift register
 */

#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <unistd.h>
#include <string.h>

#define LFSR					  \
out_bit = (state				  \
    ^ (state >> taps[0])			  \
    ^ (state >> taps[1])			  \
    ^ (state >> taps[2])) & 1LLU;		  \
state = ((state >> 1) | (out_bit << (bits - 1))); \
count++;					  \
putchar(48 + out_bit)

void die(int);

int main(int argc, char* argv[])
{
	uint64_t total = 0;
	uint64_t count = 0;
	uint64_t state;
	uint64_t out_bit;
	int taps[3] = { 0 };
	int bits = 32;
	int verbose = 0;

	int opt = 0;
	while ((opt = getopt(argc, argv, "hvn:b:")) != -1) {
		switch (opt) {
		case 'h':
			die(0);
			break;
		case 'v':
			verbose = 1;
			break;
		case 'n':
			total = atol(optarg);
			if (total == 0 && optarg[0] != '0') { // invalid input
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
	// Initialize state from stdin if the final argument is '-'
	if (argc > optind && strcmp(argv[optind], "-") == 0) {
		read(0, &state, 8);
	} else {
		uint64_t seed = (uint64_t)&state;
		state = ~seed ^ seed << 32; // any n >0 will do
	}

	switch (bits) {
	case 16:
		taps[0] = 2; taps[1] = 3; taps[2] = 5;
		total = total ? total : total | (uint16_t)~0;
		break;
	case 32:
		taps[0] = 2; taps[1] = 6; taps[2] = 7;
		total = total ? total : total | (uint32_t)~0;
		break;
	case 64:
		taps[0] = 1; taps[1] = 3; taps[2] = 4;
		total = total ? total : total | (uint64_t)~0;
		break;
	}

	if (verbose) {
		do {
			for (int i = bits - 1; i >= 0; i--) {
				putchar(48 + ((1LLU << i & state) >> i));
			}
			putchar(' ');
			LFSR;
			printf(" %" PRIu64 "\n", count);
		} while (count < total);
	} else {
		do {
			LFSR;
		} while (count < total);
		putchar('\n');
	}

	return 0;
}

void die(int code)
{
	puts("\
Usage:                                                                 \n\
  lsfr [-hv] [-b 16|32|64] [-n <number>] [-]                           \n\
                                                                       \n\
Options:                                                               \n\
  -h  Show this message                                                \n\
  -v  Format output as \"<state in binary> <out bit> <current count>\" \n\
  -b  Bitness (defaults to 32)                                         \n\
  -n  Number of bits to produce                                        \n\
        Defaults to the full period of 2^bitness                       \n\
        A value of 0 will cause an infinite loop                       \n\
  -   Initialise state from stdin (must be given last)                 \
");
	exit(code);
}
