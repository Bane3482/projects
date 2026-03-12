#include "user/user.h"

void get_msg(int fd) {
  char buf[512];
  int n;
  printf("%d: got ", getpid());
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      fprintf(2, "Error in writing msg\n");
      exit(1);
    }
  }
  write(1, "\n", 1);
}

int main() {
  int fd1[2];
  int fd2[2];
  if (pipe(fd1) == -1 || pipe(fd2) == -1) {
    fprintf(2, "Error in pipe");
    exit(1);
  }
  int pid = fork();
  if (pid > 0) {
    close(fd1[0]);
    close(fd2[1]);

    write(fd1[1], "ping", 4);
    close(fd1[1]);

    wait(0);

    get_msg(fd2[0]);
    close(fd2[0]);
  } else if (pid == 0) {
    close(fd1[1]);
    close(fd2[0]);

    get_msg(fd1[0]);
    close(fd1[0]);

    write(fd2[1], "pong", 4);
    close(fd2[1]);
  } else {
    fprintf(2, "Fork error\n");
    exit(1);
  }
  exit(0);
}