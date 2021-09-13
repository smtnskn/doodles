#!/usr/bin/tcc -run
/*
 * lfsr.c v0.1.1
 *
 * Author:  Sami Tanskanen
 * Date:    2021/09/13
 * Comment: A 16-, 32-, and 64-bit m-sequence linear-feedback shift register
 */

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <inttypes.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

void die(int);

int main(int argc, char* argv[])
{
	uint64_t total = 0;
	uint64_t count = 0;
	uint64_t state;
	uint64_t out_bit;
	int taps[3] = { 0 };
	int bits = 32;

	int opt = 0;
	while ((opt = getopt(argc, argv, "hc:b:")) != -1) {
		switch (opt) {
		case 'h':
			die(0);
			break;
		case 'c':
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
		srand(time(NULL));
		state = rand(); // any non-zero value will do
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

	do {
		// if verbose, print1 and print2 point to a no-op.
		// else, point to proper functions
		// print1();

		out_bit = (state
		    ^ (state >> taps[0])
		    ^ (state >> taps[1])
		    ^ (state >> taps[2])) & 1LLU;
		state = ((state >> 1) | (out_bit << (bits - 1)));
		count++;
		putchar(48 + out_bit);

		//print2();
	} while (count < total);
	putchar('\n');

	return 0;
}

void die(int code)
{
	puts("\
Usage:                                                 \n\
  lsfr [-b 16|32|64] [-c <number>] [-h] [-]            \n\
                                                       \n\
Options:                                               \n\
  -h  Show this message                                \n\
  -b  Bitness (defaults to 32)                         \n\
  -c  Count (defaults to 2^bitness)                    \n\
      A count of 0 will cause an infinite loop         \n\
  -   Initialise state from stdin (must be given last) \
");
	exit(code);
}
