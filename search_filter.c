/* search_filter.c: Filters */

#include "search.h"

#include <errno.h>
#include <string.h>

#include <fnmatch.h>
#include <unistd.h>

/* Internal Filter Functions */

bool        filter_access(const char *path, const struct stat *stat, const Options *options) {
    return options->access && access(path, options->access) != 0;
}

bool        filter_type(const char *path, const struct stat *stat, const Options *options) {
    if (!options->type) return false;
    if ((char)options->type == 'f' && S_ISREG(stat->st_mode))
        return false;
    if ((char)options->type == 'd' && S_ISDIR(stat->st_mode))
        return false;
    return true;
}

bool        filter_empty(const char *path, const struct stat *stat, const Options *options) {
    if (!options->empty) return false;
    if (S_ISDIR(stat->st_mode)) {
        if (is_directory_empty(path))
            return false;
    }
    if (S_ISREG(stat->st_mode)) {
        if ((int)stat->st_size == 0) return false;
    }
    return true;

}

bool        filter_name(const char *path, const struct stat *stat, const Options *options) {
    if (!options->name) return false;
    char* base = strrchr(path, '/');
    base++;
    if (fnmatch(options->name, base, 0) == 0)
        return false;
    return true;
}

bool        filter_path(const char *path, const struct stat *stat, const Options *options) {
    if (!options->path) return false;
    if (fnmatch(options->path, path, FNM_NOESCAPE) == 0)
        return false;
    return true;
}

bool        filter_perm(const char *path, const struct stat *stat, const Options *options) {
    return (options->perm && (((S_IRWXU | S_IRWXG | S_IRWXO) & stat->st_mode) != options->perm));
}

bool        filter_newer(const char *path, const struct stat *stat, const Options *options) {
    if (!options->newer) return false;
    if (get_mtime(path) > options->newer) return false;
    return true;
}

bool        filter_uid(const char *path, const struct stat *stat, const Options *options) {
    if (options->uid == -1) return false;
    if (options->uid == stat->st_uid) return false;
    return true;
    //return options->uid && options->uid != stat->st_uid;
}

bool        filter_gid(const char *path, const struct stat *stat, const Options *options) {
    if (options->gid == -1) return false;
    if (options->gid == stat->st_gid) return false;
    return true;
    //return options->gid && options->gid != stat->st_gid;
}

FilterFunc FILTER_FUNCTIONS[] = {   /* Array of function pointers. */
    filter_access,
    filter_type,
    filter_empty,
    filter_name,
    filter_path,
    filter_perm,
    filter_newer,
    filter_uid,
    filter_gid,
    NULL,
};

/* External Filter Functions */

/**
 * Filter path based options.
 * @param   path        Path to file to filter.
 * @param   options     Pointer to Options structure.
 * @return  Whether or not the path should be filtered out (false means include
 * it in output, true means exclude it from output).
 */
bool	    filter(const char *path, const Options *options) {
    struct stat st;
    if (lstat(path, &st) == -1) {
        fprintf(stderr, "Unable to use lstat %s: %s\n", path, strerror(errno));
        return true;
    }
    bool result = false;

    for (size_t i = 0; FILTER_FUNCTIONS[i]; i++) {
        if (FILTER_FUNCTIONS[i](path, &st, options) || result) {
            result = true;
        }
    }
    return result;
}
/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
