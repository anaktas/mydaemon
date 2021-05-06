#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <sys/syslog.h>

volatile bool debugFlag = false;
void printlog(int logLevel, char *message);

int main(int argc, char *argv[]) {

    if (argc == 2 && !strcmp(argv[1], "-d")) {
        debugFlag = true;
    } else {
        openlog("myservice", 0, LOG_USER);
    }

    int count = 0;

    while (1) {
        char *logMessage = (char *) malloc(sizeof(char) * 80);
        sprintf(logMessage, "Looping: %d", count);
        printlog(LOG_INFO, logMessage);
        count++;

        sleep(1);
        free(logMessage);

        // if (count == 3) {
        //     printlog(LOG_ERR, "Crash!");
        //     return 1;
        // }
    }

    return 0;
}

void printlog(int logLevel, char *message) {
    if (debugFlag) {
        printf("%s\n", message);
    } else {
        syslog(logLevel, "%s", message);
    }
}