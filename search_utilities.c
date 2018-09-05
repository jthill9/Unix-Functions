/* search_utilities.c: Utilities */

#include "search.h"

#include <errno.h>
#include <dirent.h>

/* Utility Functions */

/**
 * Checks whether or not the directory is empty.
 * @param   path    Path to directory.
 * @return  Whether or not the path is an empty directory.
 */
bool        is_directory_empty(const char *path) {
    DIR *d = opendir(path);     // Open directory
    if (!d) {
        fprintf(stderr, "Unable to opendir on %s: %s\n", path, strerror(errno));
        return false;
    }

    int dirs = 0;
    // Loop through directory entries
    for (struct dirent *e = readdir(d); e; e = readdir(d)) {
         if (streq(e->d_name, ".") || streq(e->d_name, ".."))
             continue;           // Skip current and parent directories
         else
            dirs++;
    }
    closedir(d);
    if (dirs == 0) return true;
    return false;
}

/**
 * Retrieves modification time of file.
 * @param   path    Path to file.
 * @return  The modification time of the file.
 */
time_t      get_mtime(const char *path) {

    struct stat st;
    if (lstat(path, &st) == 0)
        return st.st_mtime;
    return 0;
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
