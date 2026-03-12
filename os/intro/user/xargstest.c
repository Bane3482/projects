/*
Possible tests:

- basic test: two input lines, xargs echo this is
- create directory xargstest1, put some files, some with certain pattern, others
without; do xargs grep among subset of files, check that all required files
found
- do xargs such 32 arguments, expect error
- do xargs sleep, expect that test run at least n secs
- do xargs false, expect error exitcode (this program doesn't exist)
- do xargs wc on nonexistent file, expect error
*/

#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/types.h"
#include "user/user.h"

char buf[512];

int run_xargs(char *input, char *args[], int pipe_out[]) {
  // Writer process: writes input to pipe (so parent don't block)
  // Xargs process: moves fd[0] to stdin, pipe_out to stdout, execs xargs
  // Parent: returns xargs exit code

  int fds[2];
  if (pipe(fds) != 0) {
    printf("FAILED: pipe failed\n");
    exit(1);
  }

  int pid_xargs = fork();
  if (pid_xargs < 0) {
    printf("FAILED: fork failed\n");
    exit(1);
  }

  if (pid_xargs == 0) {
    close(0);
    close(fds[1]);
    dup(fds[0]);  // stdin = pipe read
    close(fds[0]);

    if (pipe_out) {
      close(1);
      dup(pipe_out[1]);  // stdout = pipe_out write
      close(pipe_out[1]);
    }

    exec("xargs", args);
    // Shouldn't reach here
    printf("FAILED: exec xargs failed\n");
    exit(1);
  }

  close(fds[0]);
  if (pipe_out) {
    close(pipe_out[1]);
  }
  write(fds[1], input, strlen(input));
  close(fds[1]);

  int status;
  wait(&status);
  return status;
}

void basic_test(void) {
  printf("basic test... ");

  int fds[2];
  if (pipe(fds) != 0) {
    printf("FAILED: pipe failed\n");
    exit(1);
  }

  if (run_xargs("line1\nline2\n", (char *[]){"xargs", "echo", "this", "is", 0},
                fds) != 0) {
    printf("FAILED: xargs failed\n");
    exit(1);
  }

  int n = read(fds[0], buf, sizeof(buf) - 1);
  if (n < 0) {
    printf("FAILED: read failed\n");
    exit(1);
  }
  buf[n] = 0;
  if (strcmp(buf, "this is line1\nthis is line2\n") != 0) {
    printf("FAILED: unexpected output '%s'\n", buf);
    exit(1);
  }
  close(fds[0]);

  printf("OK\n");
  exit(0);
}

void grep_test(void) {
  printf("grep test... ");

  if (mkdir("xargstest1") < 0) {
    printf("FAILED: mkdir xargstest1 failed\n");
    exit(1);
  }

  int fd;
  fd = open("xargstest1/file1.txt", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf("FAILED: create file1.txt failed\n");
    exit(1);
  }
  write(fd, "hello world\npattern here\n", 25);
  close(fd);

  fd = open("xargstest1/file2.txt", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf("FAILED: create file2.txt failed\n");
    exit(1);
  }
  write(fd, "no match here\nother text\n", 25);
  close(fd);

  fd = open("xargstest1/file3.txt", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf("FAILED: create file3.txt failed\n");
    exit(1);
  }
  write(fd, "pattern found\nmore text\n", 24);
  close(fd);

  fd = open("xargstest1/file4.txt", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf("FAILED: create file4.txt failed\n");
    exit(1);
  }
  write(fd, "this pattern is false\nmore text\n", 32);
  close(fd);

  int pipe_out[2];
  if (pipe(pipe_out) != 0) {
    printf("FAILED: pipe failed\n");
    exit(1);
  }

  if (run_xargs(
          "xargstest1/file1.txt\nxargstest1/file2.txt\nxargstest1/file3.txt\n",
          (char *[]){"xargs", "grep", "pattern", 0}, pipe_out) != 0) {
    printf("FAILED: xargs grep failed\n");
    exit(1);
  }

  int n = read(pipe_out[0], buf, sizeof(buf) - 1);
  if (n < 0) {
    printf("FAILED: read failed\n");
    exit(1);
  }
  buf[n] = 0;
  close(pipe_out[0]);

  if (strstr(buf, "pattern here") == 0 || strstr(buf, "pattern found") == 0) {
    printf("FAILED: pattern not found in expected files, got: '%s'\n", buf);
    exit(1);
  }

  printf("OK\n");
  exit(0);
}

void exec_error_test(void) {
  printf("exec error test... ");

  int status = run_xargs("arg\n", (char *[]){"xargs", "false", 0}, 0);
  if (status == 0) {
    printf("FAILED: expected xargs failure, got success\n");
    exit(1);
  }

  printf("OK\n");
  exit(0);
}

void child_error_test(void) {
  printf("child error test... ");

  int status =
      run_xargs("nonexistentfile.txt\n", (char *[]){"xargs", "wc", 0}, 0);
  if (status == 0) {
    printf("FAILED: expected xargs failure, got success\n");
    exit(1);
  }

  printf("OK\n");
  exit(0);
}

// Clean up test files and directories
void cleanup_test_files(void) {
  unlink("xargstest1/file1.txt");
  unlink("xargstest1/file2.txt");
  unlink("xargstest1/file3.txt");
  unlink("xargstest1");
}

int main(int argc, char *argv[]) {
  printf("xargstest starting\n");

  int pid = fork();
  if (pid == 0) {
    basic_test();
  } else {
    int status;
    wait(&status);
    if (status != 0) {
      printf("basic test FAILED\n");
      exit(1);
    }
  }

  pid = fork();
  if (pid == 0) {
    grep_test();
  } else {
    int status;
    wait(&status);
    if (status != 0) {
      printf("FAILED\n");
      cleanup_test_files();
      exit(1);
    }
  }
  cleanup_test_files();

  pid = fork();
  if (pid == 0) {
    exec_error_test();
  } else {
    wait(0);
  }

  pid = fork();
  if (pid == 0) {
    child_error_test();
  } else {
    wait(0);
  }

  printf("xargstest: all tests passed\n");
  exit(0);
}
