/*
**
** forksum.c        Benchmark syscall times
**
** To compile:  cc -O -o forksum forksum.c -lm
**
*/

#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define PIPE_READ 0
#define PIPE_WRITE 1


/* function declarations */
void parent(int pipefd[]);
void childPipeHandling(int pipefd[], long int start, long int end);
void forksum(long int start, long int end);
long int read_value(FILE* pipe);


/* main function */
int main(int argc, char **argv) {
    // terminate if the number of parameters do not match
    if(argc-1 != 2) {
        fprintf(stderr, "Wrong number of arguments (%d), expected 2\nUsage: %s <start_number> <end_number>\n", argc-1, argv[0]);
        exit(EXIT_FAILURE);
    }

    // read inputs
    long int start = atol(argv[1]);
    long int end = atol(argv[2]);

    // swap if end is smaller than start
    if(start > end) {
        long int help = start;
        start = end;
        end = help;
    }

    // run script
    forksum(start, end);
}


/* function implementations */
void forksum(long int start, long int end) { // forksum is recursive!
    if(start == end) {
        printf("%ld\n", start);
    } else {
        long int pivot = (end + start) / 2;
        // fprintf(stderr, "pivot point %li\n", pivot);

        // create pipes
        int pipefd[2];
        pipe(pipefd);

        // fork leftside
        pid_t pid = fork();
        if(pid == 0) {                      /* leftside child  */
            childPipeHandling(pipefd, start, pivot);
        } else {                            /* parent          */
            // fork rightside
            pid_t pid2 = fork();
            if(pid2 == 0) {                 /* rightside child */
                childPipeHandling(pipefd, pivot+1, end);
            } else {                        /* still parent    */
                parent(pipefd);
            }
        }
    }
}

void parent(int pipefd[]) {
    close(pipefd[PIPE_WRITE]);
    FILE* pipe = fdopen(pipefd[PIPE_READ], "r");

    // wait for childs and read both values
    wait(NULL);
    long int value_left = read_value(pipe);
    long int value_right = read_value(pipe);

    // print result to stdout (or linked pipe fd)
    printf("%ld\n", value_left + value_right);

    // close rest of pipe fds
    close(pipefd[PIPE_READ]);
}

long int read_value(FILE* pipe) {
    long int value;
    if(fscanf(pipe, "%ld", &value) == EOF) {
        // ignore error (could not read from pipe) and assume 0
        value = 0;
    }
    return value;
}

void childPipeHandling(int pipefd[], long int start, long int end) {
    close(pipefd[PIPE_READ]);
    dup2(pipefd[PIPE_WRITE], STDOUT_FILENO);
    forksum(start, end); // recursion!
    close(pipefd[PIPE_WRITE]);
}