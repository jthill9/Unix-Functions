/* search.h: Search Utility */

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

/* Options Structure */

typedef struct {
    int     access;     /* Access modes (-executable, -readable, -writable) */
    int     type;       /* File type (-type); */
    bool    empty;      /* Empty files and directories (-empty) */
    char   *name;       /* Base of file name matches shell pattern (-name) */
    char   *path;       /* Path of file matches shell pattern (-path) */
    int     perm;       /* File's permission bits are exactly octal mode (-perm) */
    time_t  newer;      /* File was modified more recently than file (-newer) */
    int     uid;        /* File's numeric user ID is n */
    int     gid;        /* File's numeric group ID is n */
} Options;

void        options_usage(const char *prognam, int status);
bool        options_parse(int argc, char **argv, char **root, Options *options);

/* Filter Functions */

typedef bool (*FilterFunc)(const char *path, const struct stat *stat, const Options *options);

bool	    filter(const char *path, const Options *options);

/* Utility Functions */

bool        is_directory_empty(const char *path);
time_t      get_mtime(const char *path);

/* Walk Functions */

int         walk(const char *root, const Options *options);

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
