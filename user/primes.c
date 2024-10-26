#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Prototype with consistent type
void sieve(int input_pipe[]) __attribute__((noreturn));

void sieve(int input_pipe[]) {
  close(input_pipe[1]);
  int prime, number;
  
  if (read(input_pipe[0], &prime, sizeof(int)) != sizeof(int)) {
    close(input_pipe[0]);
    exit(0);
  }

  printf("prime %d\n", prime);

  int output_pipe[2];
  pipe(output_pipe);

  while (read(input_pipe[0], &number, sizeof(int)) == sizeof(int)) {
    if (number % prime != 0) {
      write(output_pipe[1], &number, sizeof(int));
    }
  }

  close(input_pipe[0]);
  close(output_pipe[1]);

  if (fork() == 0) {
    sieve(output_pipe);
  } else {
    close(output_pipe[0]);
    wait(0);
  }

  exit(0);
}

int main(int argc, char *argv[]) {
  int p[2];
  pipe(p);

  for (int i = 2; i <= 35; i++) {
    write(p[1], &i, sizeof(int));
  }

  if (fork() == 0) {
    sieve(p);
  } else {
    close(p[0]);
    close(p[1]);
    wait(0);
  }

  exit(0);
}

