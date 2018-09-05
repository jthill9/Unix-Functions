/* search_main.c: Main Execution */

#include "search.h"

/* Main Execution */

int main(int argc, char *argv[]) {
    Options options = {0, 0, false, NULL, NULL, 0, 0, -1, -1};
    char* root;

    /* Parse options */
    if (!(options_parse(argc, argv, &root, &options)))
        return EXIT_FAILURE;
    //printf("%s", options.name);
    /* Check root */
    if (root) {
        if (!filter(root, &options))
            printf("%s\n", root);
    }
    else
        return EXIT_FAILURE;

    /* Walk root */
    if (walk(root, &options) == 1) return EXIT_FAILURE;
    return EXIT_SUCCESS;
}

/* vim: set sts=4 sw=4 ts=8 expandtab ft=c: */
