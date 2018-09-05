/* duplicate.h: Duplicate Utility */

#pragma once

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <sys/stat.h>

/* Macros */

#define	    streq(s0, s1)   (strcmp((s0), (s1)) == 0)
#define     debug(M, ...) \
        fprintf(stderr, "DEBUG %s:%d:%s: " M "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__)

/* Constants */

#define DEFAULT_BYTES   512

/* Options Structure */

typedef struct {
    char *  input_file;     /* Path to input file */
    char *  output_file;    /* Path to output file */
    size_t  count;          /* Number of blocks to copy */
    size_t  bytes;          /* Size of each block */
    size_t  seek;           /* Number of blocks to skip in output file */
    size_t  skip;           /* Number of blocks to skip in input file */
} Options;

void        usage(const char *progname, int status);
bool        parse_options(int argc, char **argv, Options *options);

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
