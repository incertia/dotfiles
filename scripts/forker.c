#include <errno.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  if (argc < 2) {
    fprintf(stderr, "usage: %s <program> [args]\n", argv[0]);
    return 1;
  } else {
    pid_t pid = fork();
    if (pid == -1) {
      perror("fork");
      return errno;
    } else if (pid == 0) {
      close(0);
      close(1);
      close(2);
      execvp(argv[1], argv + 1);
      perror("exec");
      return errno;
    }
  }
  return 0;
}
