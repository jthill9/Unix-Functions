/* duplicate_main.c: Main Execution */

#include "duplicate.h"
#include <errno.h>
#include <limits.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

/* Main Execution */

int         main(int argc, char *argv[]) {
    char* std_in = "/dev/stdin";
    char* std_out = "/dev/stdout";
    Options options = {std_in, std_out, INT_MAX, DEFAULT_BYTES, 0, 0};
    int status = EXIT_FAILURE;
    int rfd = -1;
    int wfd = -1;
    int nread;

    if (!parse_options(argc, argv, &options))
        goto CLEANUP;

    char* buffer = malloc(options.bytes);
    if (!buffer){
        return EXIT_FAILURE;
    }

    char *src = options.input_file;
    char *dst = options.output_file;

    /* Open source file for reading */
    rfd = open(src, O_RDONLY, 0666);
    if (rfd < 0) {
       fprintf(stderr, "Unable to open %s: %s\n", src, strerror(errno));
       goto CLEANUP;
    }

    /* Open destination file for writing */
    wfd = open(dst, O_CREAT|O_WRONLY, 0644);
    if (wfd < 0) {
	      fprintf(stderr, "Unable to open %s: %s\n", dst, strerror(errno));
	      goto CLEANUP;
    }

    /* Copy from source to destination */
    if (options.skip != 0)
        if (!lseek(rfd, options.skip * options.bytes, SEEK_SET)) {
            goto CLEANUP;
        }
    if (options.seek != 0)
        if (!lseek(wfd, options.seek * options.bytes, SEEK_SET)) {
            goto CLEANUP;
        }

    ssize_t total_read = 0;
    while (total_read < (options.bytes * options.count) && ((nread = read(rfd, buffer, options.bytes)) > 0)) {
        total_read += nread;
        int nwritten = write(wfd, buffer, nread);
        while (nwritten != nread) {
            int written = write(wfd, buffer + nwritten, nread - nwritten);
            if (written < 0){
                goto CLEANUP;
            }
            else{
                nwritten += written;
            }
        }
    }

    status = EXIT_SUCCESS;

    /* Cleanup */
    CLEANUP:
        free(buffer);
        if (rfd >= 0) close(rfd);
        if (wfd >= 0) close(wfd);
        return status;
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
