
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "kernel/param.h"
#include "user/user.h"

void test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10 };
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	a0e50513          	addi	a0,a0,-1522 # a20 <malloc+0x108>
  1a:	00001097          	auipc	ra,0x1
  1e:	846080e7          	jalr	-1978(ra) # 860 <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	4ca080e7          	jalr	1226(ra) # 4f0 <fork>
    if (pid < 0) {
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if (pid == 0) {
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for (int i = 0; i < NCHILD; i++) {
    int xstatus;
    wait(&xstatus);
    if (xstatus != 0) {
      if (all_ok == 1) printf("filetest: FAILED\n");
  3e:	4985                	li	s3,1
  40:	00001a97          	auipc	s5,0x1
  44:	a18a8a93          	addi	s5,s5,-1512 # a58 <malloc+0x140>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a8b1                	j	a6 <test0+0xa6>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	9ec50513          	addi	a0,a0,-1556 # a38 <malloc+0x120>
  54:	00001097          	auipc	ra,0x1
  58:	80c080e7          	jalr	-2036(ra) # 860 <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	49a080e7          	jalr	1178(ra) # 4f8 <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("xv6-readme", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	9e090913          	addi	s2,s2,-1568 # a48 <malloc+0x130>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	4c4080e7          	jalr	1220(ra) # 538 <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for (j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	502080e7          	jalr	1282(ra) # 588 <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	468080e7          	jalr	1128(ra) # 4f8 <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	45e080e7          	jalr	1118(ra) # 4f8 <exit>
  for (int i = 0; i < NCHILD; i++) {
  a2:	34fd                	addiw	s1,s1,-1
  a4:	c09d                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  a6:	fbc40513          	addi	a0,s0,-68
  aa:	00000097          	auipc	ra,0x0
  ae:	456080e7          	jalr	1110(ra) # 500 <wait>
    if (xstatus != 0) {
  b2:	fbc42783          	lw	a5,-68(s0)
  b6:	d7f5                	beqz	a5,a2 <test0+0xa2>
      if (all_ok == 1) printf("filetest: FAILED\n");
  b8:	ff3915e3          	bne	s2,s3,a2 <test0+0xa2>
  bc:	8556                	mv	a0,s5
  be:	00000097          	auipc	ra,0x0
  c2:	7a2080e7          	jalr	1954(ra) # 860 <printf>
      all_ok = 0;
  c6:	8952                	mv	s2,s4
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if (all_ok) printf("filetest: OK\n");
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
  if (all_ok) printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	99050513          	addi	a0,a0,-1648 # a70 <malloc+0x158>
  e8:	00000097          	auipc	ra,0x0
  ec:	778080e7          	jalr	1912(ra) # 860 <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1() {
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];

  printf("memtest: start\n");
  fa:	00001517          	auipc	a0,0x1
  fe:	98650513          	addi	a0,a0,-1658 # a80 <malloc+0x168>
 102:	00000097          	auipc	ra,0x0
 106:	75e080e7          	jalr	1886(ra) # 860 <printf>
  if (pipe(fds) != 0) {
 10a:	fc040513          	addi	a0,s0,-64
 10e:	00000097          	auipc	ra,0x0
 112:	3fa080e7          	jalr	1018(ra) # 508 <pipe>
 116:	e53d                	bnez	a0,184 <test1+0x92>
 118:	f426                	sd	s1,40(sp)
 11a:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 11c:	00000097          	auipc	ra,0x0
 120:	3d4080e7          	jalr	980(ra) # 4f0 <fork>
  if (pid < 0) {
 124:	08054063          	bltz	a0,1a4 <test1+0xb2>
    printf("fork failed");
    exit(1);
  }
  if (pid == 0) {
 128:	e155                	bnez	a0,1cc <test1+0xda>
 12a:	f04a                	sd	s2,32(sp)
 12c:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	3ee080e7          	jalr	1006(ra) # 520 <close>
    while (1) {
      a = sbrk(PGSIZE);
      if (a == (char *)0xffffffffffffffffL) exit(0);
 13a:	597d                	li	s2,-1
      *(int *)(a + 4) = 1;
 13c:	4485                	li	s1,1
      if (write(fds[1], "x", 1) != 1) {
 13e:	00001997          	auipc	s3,0x1
 142:	96298993          	addi	s3,s3,-1694 # aa0 <malloc+0x188>
      a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	438080e7          	jalr	1080(ra) # 580 <sbrk>
      if (a == (char *)0xffffffffffffffffL) exit(0);
 150:	07250963          	beq	a0,s2,1c2 <test1+0xd0>
      *(int *)(a + 4) = 1;
 154:	c144                	sw	s1,4(a0)
      if (write(fds[1], "x", 1) != 1) {
 156:	8626                	mv	a2,s1
 158:	85ce                	mv	a1,s3
 15a:	fc442503          	lw	a0,-60(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	3ba080e7          	jalr	954(ra) # 518 <write>
 166:	fe9500e3          	beq	a0,s1,146 <test1+0x54>
        printf("write failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	93e50513          	addi	a0,a0,-1730 # aa8 <malloc+0x190>
 172:	00000097          	auipc	ra,0x0
 176:	6ee080e7          	jalr	1774(ra) # 860 <printf>
        exit(1);
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	37c080e7          	jalr	892(ra) # 4f8 <exit>
 184:	f426                	sd	s1,40(sp)
 186:	f04a                	sd	s2,32(sp)
 188:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	90650513          	addi	a0,a0,-1786 # a90 <malloc+0x178>
 192:	00000097          	auipc	ra,0x0
 196:	6ce080e7          	jalr	1742(ra) # 860 <printf>
    exit(1);
 19a:	4505                	li	a0,1
 19c:	00000097          	auipc	ra,0x0
 1a0:	35c080e7          	jalr	860(ra) # 4f8 <exit>
 1a4:	f04a                	sd	s2,32(sp)
 1a6:	ec4e                	sd	s3,24(sp)
    printf("fork failed");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	89050513          	addi	a0,a0,-1904 # a38 <malloc+0x120>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	6b0080e7          	jalr	1712(ra) # 860 <printf>
    exit(1);
 1b8:	4505                	li	a0,1
 1ba:	00000097          	auipc	ra,0x0
 1be:	33e080e7          	jalr	830(ra) # 4f8 <exit>
      if (a == (char *)0xffffffffffffffffL) exit(0);
 1c2:	4501                	li	a0,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	334080e7          	jalr	820(ra) # 4f8 <exit>
      }
    }
    exit(0);
  }
  close(fds[1]);
 1cc:	fc442503          	lw	a0,-60(s0)
 1d0:	00000097          	auipc	ra,0x0
 1d4:	350080e7          	jalr	848(ra) # 520 <close>
  while (1) {
    if (read(fds[0], buf, 1) != 1) {
 1d8:	4605                	li	a2,1
 1da:	fc840593          	addi	a1,s0,-56
 1de:	fc042503          	lw	a0,-64(s0)
 1e2:	00000097          	auipc	ra,0x0
 1e6:	32e080e7          	jalr	814(ra) # 510 <read>
 1ea:	4785                	li	a5,1
 1ec:	00f51463          	bne	a0,a5,1f4 <test1+0x102>
      break;
    } else {
      tot += 1;
 1f0:	2485                	addiw	s1,s1,1
    if (read(fds[0], buf, 1) != 1) {
 1f2:	b7dd                	j	1d8 <test1+0xe6>
    }
  }
  int n = (PHYSTOP - KERNBASE) / PGSIZE;
  printf("allocated %d out of %d pages\n", tot, n);
 1f4:	6621                	lui	a2,0x8
 1f6:	85a6                	mv	a1,s1
 1f8:	00001517          	auipc	a0,0x1
 1fc:	8c050513          	addi	a0,a0,-1856 # ab8 <malloc+0x1a0>
 200:	00000097          	auipc	ra,0x0
 204:	660080e7          	jalr	1632(ra) # 860 <printf>
  if (tot < 31950) {
 208:	67a1                	lui	a5,0x8
 20a:	ccd78793          	addi	a5,a5,-819 # 7ccd <base+0x5cbd>
 20e:	0297c863          	blt	a5,s1,23e <test1+0x14c>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 212:	85a6                	mv	a1,s1
 214:	00001517          	auipc	a0,0x1
 218:	8c450513          	addi	a0,a0,-1852 # ad8 <malloc+0x1c0>
 21c:	00000097          	auipc	ra,0x0
 220:	644080e7          	jalr	1604(ra) # 860 <printf>
    printf("memtest: FAILED\n");
 224:	00001517          	auipc	a0,0x1
 228:	8ec50513          	addi	a0,a0,-1812 # b10 <malloc+0x1f8>
 22c:	00000097          	auipc	ra,0x0
 230:	634080e7          	jalr	1588(ra) # 860 <printf>
 234:	74a2                	ld	s1,40(sp)
  } else {
    printf("memtest: OK\n");
  }
}
 236:	70e2                	ld	ra,56(sp)
 238:	7442                	ld	s0,48(sp)
 23a:	6121                	addi	sp,sp,64
 23c:	8082                	ret
    printf("memtest: OK\n");
 23e:	00001517          	auipc	a0,0x1
 242:	8ea50513          	addi	a0,a0,-1814 # b28 <malloc+0x210>
 246:	00000097          	auipc	ra,0x0
 24a:	61a080e7          	jalr	1562(ra) # 860 <printf>
}
 24e:	b7dd                	j	234 <test1+0x142>

0000000000000250 <main>:

int main(int argc, char *argv[]) {
 250:	1141                	addi	sp,sp,-16
 252:	e406                	sd	ra,8(sp)
 254:	e022                	sd	s0,0(sp)
 256:	0800                	addi	s0,sp,16
  test0();
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <test0>
  test1();
 260:	00000097          	auipc	ra,0x0
 264:	e92080e7          	jalr	-366(ra) # f2 <test1>
  exit(0);
 268:	4501                	li	a0,0
 26a:	00000097          	auipc	ra,0x0
 26e:	28e080e7          	jalr	654(ra) # 4f8 <exit>

0000000000000272 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  extern int main();
  main();
 27a:	00000097          	auipc	ra,0x0
 27e:	fd6080e7          	jalr	-42(ra) # 250 <main>
  exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	274080e7          	jalr	628(ra) # 4f8 <exit>

000000000000028c <strcpy>:
}

char *strcpy(char *s, const char *t) {
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 292:	87aa                	mv	a5,a0
 294:	0585                	addi	a1,a1,1
 296:	0785                	addi	a5,a5,1
 298:	fff5c703          	lbu	a4,-1(a1)
 29c:	fee78fa3          	sb	a4,-1(a5)
 2a0:	fb75                	bnez	a4,294 <strcpy+0x8>
  return os;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <strcmp>:

int strcmp(const char *p, const char *q) {
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	cb91                	beqz	a5,2c6 <strcmp+0x1e>
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00f71763          	bne	a4,a5,2c6 <strcmp+0x1e>
 2bc:	0505                	addi	a0,a0,1
 2be:	0585                	addi	a1,a1,1
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	fbe5                	bnez	a5,2b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c6:	0005c503          	lbu	a0,0(a1)
}
 2ca:	40a7853b          	subw	a0,a5,a0
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <strlen>:

uint strlen(const char *s) {
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 2da:	00054783          	lbu	a5,0(a0)
 2de:	cf91                	beqz	a5,2fa <strlen+0x26>
 2e0:	0505                	addi	a0,a0,1
 2e2:	87aa                	mv	a5,a0
 2e4:	86be                	mv	a3,a5
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff7c703          	lbu	a4,-1(a5)
 2ec:	ff65                	bnez	a4,2e4 <strlen+0x10>
 2ee:	40a6853b          	subw	a0,a3,a0
 2f2:	2505                	addiw	a0,a0,1
  return n;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  for (n = 0; s[n]; n++);
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <strlen+0x20>

00000000000002fe <memset>:

void *memset(void *dst, int c, uint n) {
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 304:	ca19                	beqz	a2,31a <memset+0x1c>
 306:	87aa                	mv	a5,a0
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 310:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 314:	0785                	addi	a5,a5,1
 316:	fee79de3          	bne	a5,a4,310 <memset+0x12>
  }
  return dst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strchr>:

char *strchr(const char *s, char c) {
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  for (; *s; s++)
 326:	00054783          	lbu	a5,0(a0)
 32a:	cb99                	beqz	a5,340 <strchr+0x20>
    if (*s == c) return (char *)s;
 32c:	00f58763          	beq	a1,a5,33a <strchr+0x1a>
  for (; *s; s++)
 330:	0505                	addi	a0,a0,1
 332:	00054783          	lbu	a5,0(a0)
 336:	fbfd                	bnez	a5,32c <strchr+0xc>
  return 0;
 338:	4501                	li	a0,0
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <strchr+0x1a>

0000000000000344 <gets>:

char *gets(char *buf, int max) {
 344:	711d                	addi	sp,sp,-96
 346:	ec86                	sd	ra,88(sp)
 348:	e8a2                	sd	s0,80(sp)
 34a:	e4a6                	sd	s1,72(sp)
 34c:	e0ca                	sd	s2,64(sp)
 34e:	fc4e                	sd	s3,56(sp)
 350:	f852                	sd	s4,48(sp)
 352:	f456                	sd	s5,40(sp)
 354:	f05a                	sd	s6,32(sp)
 356:	ec5e                	sd	s7,24(sp)
 358:	1080                	addi	s0,sp,96
 35a:	8baa                	mv	s7,a0
 35c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 35e:	892a                	mv	s2,a0
 360:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 362:	4aa9                	li	s5,10
 364:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 366:	89a6                	mv	s3,s1
 368:	2485                	addiw	s1,s1,1
 36a:	0344d863          	bge	s1,s4,39a <gets+0x56>
    cc = read(0, &c, 1);
 36e:	4605                	li	a2,1
 370:	faf40593          	addi	a1,s0,-81
 374:	4501                	li	a0,0
 376:	00000097          	auipc	ra,0x0
 37a:	19a080e7          	jalr	410(ra) # 510 <read>
    if (cc < 1) break;
 37e:	00a05e63          	blez	a0,39a <gets+0x56>
    buf[i++] = c;
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 38a:	01578763          	beq	a5,s5,398 <gets+0x54>
 38e:	0905                	addi	s2,s2,1
 390:	fd679be3          	bne	a5,s6,366 <gets+0x22>
    buf[i++] = c;
 394:	89a6                	mv	s3,s1
 396:	a011                	j	39a <gets+0x56>
 398:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 39a:	99de                	add	s3,s3,s7
 39c:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a0:	855e                	mv	a0,s7
 3a2:	60e6                	ld	ra,88(sp)
 3a4:	6446                	ld	s0,80(sp)
 3a6:	64a6                	ld	s1,72(sp)
 3a8:	6906                	ld	s2,64(sp)
 3aa:	79e2                	ld	s3,56(sp)
 3ac:	7a42                	ld	s4,48(sp)
 3ae:	7aa2                	ld	s5,40(sp)
 3b0:	7b02                	ld	s6,32(sp)
 3b2:	6be2                	ld	s7,24(sp)
 3b4:	6125                	addi	sp,sp,96
 3b6:	8082                	ret

00000000000003b8 <stat>:

int stat(const char *n, struct stat *st) {
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c4:	4581                	li	a1,0
 3c6:	00000097          	auipc	ra,0x0
 3ca:	172080e7          	jalr	370(ra) # 538 <open>
  if (fd < 0) return -1;
 3ce:	02054663          	bltz	a0,3fa <stat+0x42>
 3d2:	e426                	sd	s1,8(sp)
 3d4:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 3d6:	85ca                	mv	a1,s2
 3d8:	00000097          	auipc	ra,0x0
 3dc:	178080e7          	jalr	376(ra) # 550 <fstat>
 3e0:	892a                	mv	s2,a0
  close(fd);
 3e2:	8526                	mv	a0,s1
 3e4:	00000097          	auipc	ra,0x0
 3e8:	13c080e7          	jalr	316(ra) # 520 <close>
  return r;
 3ec:	64a2                	ld	s1,8(sp)
}
 3ee:	854a                	mv	a0,s2
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6902                	ld	s2,0(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret
  if (fd < 0) return -1;
 3fa:	597d                	li	s2,-1
 3fc:	bfcd                	j	3ee <stat+0x36>

00000000000003fe <atoi>:

int atoi(const char *s) {
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 404:	00054683          	lbu	a3,0(a0)
 408:	fd06879b          	addiw	a5,a3,-48
 40c:	0ff7f793          	zext.b	a5,a5
 410:	4625                	li	a2,9
 412:	02f66863          	bltu	a2,a5,442 <atoi+0x44>
 416:	872a                	mv	a4,a0
  n = 0;
 418:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 41a:	0705                	addi	a4,a4,1
 41c:	0025179b          	slliw	a5,a0,0x2
 420:	9fa9                	addw	a5,a5,a0
 422:	0017979b          	slliw	a5,a5,0x1
 426:	9fb5                	addw	a5,a5,a3
 428:	fd07851b          	addiw	a0,a5,-48
 42c:	00074683          	lbu	a3,0(a4)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	fef671e3          	bgeu	a2,a5,41a <atoi+0x1c>
  return n;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
  n = 0;
 442:	4501                	li	a0,0
 444:	bfe5                	j	43c <atoi+0x3e>

0000000000000446 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 44c:	02b57463          	bgeu	a0,a1,474 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 450:	00c05f63          	blez	a2,46e <memmove+0x28>
 454:	1602                	slli	a2,a2,0x20
 456:	9201                	srli	a2,a2,0x20
 458:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 45c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 45e:	0585                	addi	a1,a1,1
 460:	0705                	addi	a4,a4,1
 462:	fff5c683          	lbu	a3,-1(a1)
 466:	fed70fa3          	sb	a3,-1(a4)
 46a:	fef71ae3          	bne	a4,a5,45e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 46e:	6422                	ld	s0,8(sp)
 470:	0141                	addi	sp,sp,16
 472:	8082                	ret
    dst += n;
 474:	00c50733          	add	a4,a0,a2
    src += n;
 478:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 47a:	fec05ae3          	blez	a2,46e <memmove+0x28>
 47e:	fff6079b          	addiw	a5,a2,-1 # 7fff <base+0x5fef>
 482:	1782                	slli	a5,a5,0x20
 484:	9381                	srli	a5,a5,0x20
 486:	fff7c793          	not	a5,a5
 48a:	97ba                	add	a5,a5,a4
 48c:	15fd                	addi	a1,a1,-1
 48e:	177d                	addi	a4,a4,-1
 490:	0005c683          	lbu	a3,0(a1)
 494:	00d70023          	sb	a3,0(a4)
 498:	fee79ae3          	bne	a5,a4,48c <memmove+0x46>
 49c:	bfc9                	j	46e <memmove+0x28>

000000000000049e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 49e:	1141                	addi	sp,sp,-16
 4a0:	e422                	sd	s0,8(sp)
 4a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a4:	ca05                	beqz	a2,4d4 <memcmp+0x36>
 4a6:	fff6069b          	addiw	a3,a2,-1
 4aa:	1682                	slli	a3,a3,0x20
 4ac:	9281                	srli	a3,a3,0x20
 4ae:	0685                	addi	a3,a3,1
 4b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b2:	00054783          	lbu	a5,0(a0)
 4b6:	0005c703          	lbu	a4,0(a1)
 4ba:	00e79863          	bne	a5,a4,4ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4be:	0505                	addi	a0,a0,1
    p2++;
 4c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c2:	fed518e3          	bne	a0,a3,4b2 <memcmp+0x14>
  }
  return 0;
 4c6:	4501                	li	a0,0
 4c8:	a019                	j	4ce <memcmp+0x30>
      return *p1 - *p2;
 4ca:	40e7853b          	subw	a0,a5,a4
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret
  return 0;
 4d4:	4501                	li	a0,0
 4d6:	bfe5                	j	4ce <memcmp+0x30>

00000000000004d8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 4d8:	1141                	addi	sp,sp,-16
 4da:	e406                	sd	ra,8(sp)
 4dc:	e022                	sd	s0,0(sp)
 4de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f66080e7          	jalr	-154(ra) # 446 <memmove>
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f0:	4885                	li	a7,1
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f8:	4889                	li	a7,2
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <wait>:
.global wait
wait:
 li a7, SYS_wait
 500:	488d                	li	a7,3
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 508:	4891                	li	a7,4
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <read>:
.global read
read:
 li a7, SYS_read
 510:	4895                	li	a7,5
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <write>:
.global write
write:
 li a7, SYS_write
 518:	48c1                	li	a7,16
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <close>:
.global close
close:
 li a7, SYS_close
 520:	48d5                	li	a7,21
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <kill>:
.global kill
kill:
 li a7, SYS_kill
 528:	4899                	li	a7,6
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exec>:
.global exec
exec:
 li a7, SYS_exec
 530:	489d                	li	a7,7
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <open>:
.global open
open:
 li a7, SYS_open
 538:	48bd                	li	a7,15
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 540:	48c5                	li	a7,17
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 548:	48c9                	li	a7,18
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 550:	48a1                	li	a7,8
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <link>:
.global link
link:
 li a7, SYS_link
 558:	48cd                	li	a7,19
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 560:	48d1                	li	a7,20
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 568:	48a5                	li	a7,9
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <dup>:
.global dup
dup:
 li a7, SYS_dup
 570:	48a9                	li	a7,10
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 578:	48ad                	li	a7,11
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 580:	48b1                	li	a7,12
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 588:	48b5                	li	a7,13
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 590:	48b9                	li	a7,14
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	feb407a3          	sb	a1,-17(s0)
 5a4:	4605                	li	a2,1
 5a6:	fef40593          	addi	a1,s0,-17
 5aa:	00000097          	auipc	ra,0x0
 5ae:	f6e080e7          	jalr	-146(ra) # 518 <write>
 5b2:	60e2                	ld	ra,24(sp)
 5b4:	6442                	ld	s0,16(sp)
 5b6:	6105                	addi	sp,sp,32
 5b8:	8082                	ret

00000000000005ba <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 5ba:	7139                	addi	sp,sp,-64
 5bc:	fc06                	sd	ra,56(sp)
 5be:	f822                	sd	s0,48(sp)
 5c0:	f426                	sd	s1,40(sp)
 5c2:	0080                	addi	s0,sp,64
 5c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 5c6:	c299                	beqz	a3,5cc <printint+0x12>
 5c8:	0805cb63          	bltz	a1,65e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5cc:	2581                	sext.w	a1,a1
  neg = 0;
 5ce:	4881                	li	a7,0
 5d0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5d6:	2601                	sext.w	a2,a2
 5d8:	00000517          	auipc	a0,0x0
 5dc:	5c050513          	addi	a0,a0,1472 # b98 <digits>
 5e0:	883a                	mv	a6,a4
 5e2:	2705                	addiw	a4,a4,1
 5e4:	02c5f7bb          	remuw	a5,a1,a2
 5e8:	1782                	slli	a5,a5,0x20
 5ea:	9381                	srli	a5,a5,0x20
 5ec:	97aa                	add	a5,a5,a0
 5ee:	0007c783          	lbu	a5,0(a5)
 5f2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5f6:	0005879b          	sext.w	a5,a1
 5fa:	02c5d5bb          	divuw	a1,a1,a2
 5fe:	0685                	addi	a3,a3,1
 600:	fec7f0e3          	bgeu	a5,a2,5e0 <printint+0x26>
  if (neg) buf[i++] = '-';
 604:	00088c63          	beqz	a7,61c <printint+0x62>
 608:	fd070793          	addi	a5,a4,-48
 60c:	00878733          	add	a4,a5,s0
 610:	02d00793          	li	a5,45
 614:	fef70823          	sb	a5,-16(a4)
 618:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 61c:	02e05c63          	blez	a4,654 <printint+0x9a>
 620:	f04a                	sd	s2,32(sp)
 622:	ec4e                	sd	s3,24(sp)
 624:	fc040793          	addi	a5,s0,-64
 628:	00e78933          	add	s2,a5,a4
 62c:	fff78993          	addi	s3,a5,-1
 630:	99ba                	add	s3,s3,a4
 632:	377d                	addiw	a4,a4,-1
 634:	1702                	slli	a4,a4,0x20
 636:	9301                	srli	a4,a4,0x20
 638:	40e989b3          	sub	s3,s3,a4
 63c:	fff94583          	lbu	a1,-1(s2)
 640:	8526                	mv	a0,s1
 642:	00000097          	auipc	ra,0x0
 646:	f56080e7          	jalr	-170(ra) # 598 <putc>
 64a:	197d                	addi	s2,s2,-1
 64c:	ff3918e3          	bne	s2,s3,63c <printint+0x82>
 650:	7902                	ld	s2,32(sp)
 652:	69e2                	ld	s3,24(sp)
}
 654:	70e2                	ld	ra,56(sp)
 656:	7442                	ld	s0,48(sp)
 658:	74a2                	ld	s1,40(sp)
 65a:	6121                	addi	sp,sp,64
 65c:	8082                	ret
    x = -xx;
 65e:	40b005bb          	negw	a1,a1
    neg = 1;
 662:	4885                	li	a7,1
    x = -xx;
 664:	b7b5                	j	5d0 <printint+0x16>

0000000000000666 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 666:	715d                	addi	sp,sp,-80
 668:	e486                	sd	ra,72(sp)
 66a:	e0a2                	sd	s0,64(sp)
 66c:	f84a                	sd	s2,48(sp)
 66e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 670:	0005c903          	lbu	s2,0(a1)
 674:	1a090a63          	beqz	s2,828 <vprintf+0x1c2>
 678:	fc26                	sd	s1,56(sp)
 67a:	f44e                	sd	s3,40(sp)
 67c:	f052                	sd	s4,32(sp)
 67e:	ec56                	sd	s5,24(sp)
 680:	e85a                	sd	s6,16(sp)
 682:	e45e                	sd	s7,8(sp)
 684:	8aaa                	mv	s5,a0
 686:	8bb2                	mv	s7,a2
 688:	00158493          	addi	s1,a1,1
  state = 0;
 68c:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 68e:	02500a13          	li	s4,37
 692:	4b55                	li	s6,21
 694:	a839                	j	6b2 <vprintf+0x4c>
        putc(fd, c);
 696:	85ca                	mv	a1,s2
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	efe080e7          	jalr	-258(ra) # 598 <putc>
 6a2:	a019                	j	6a8 <vprintf+0x42>
    } else if (state == '%') {
 6a4:	01498d63          	beq	s3,s4,6be <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 6a8:	0485                	addi	s1,s1,1
 6aa:	fff4c903          	lbu	s2,-1(s1)
 6ae:	16090763          	beqz	s2,81c <vprintf+0x1b6>
    if (state == 0) {
 6b2:	fe0999e3          	bnez	s3,6a4 <vprintf+0x3e>
      if (c == '%') {
 6b6:	ff4910e3          	bne	s2,s4,696 <vprintf+0x30>
        state = '%';
 6ba:	89d2                	mv	s3,s4
 6bc:	b7f5                	j	6a8 <vprintf+0x42>
      if (c == 'd') {
 6be:	13490463          	beq	s2,s4,7e6 <vprintf+0x180>
 6c2:	f9d9079b          	addiw	a5,s2,-99
 6c6:	0ff7f793          	zext.b	a5,a5
 6ca:	12fb6763          	bltu	s6,a5,7f8 <vprintf+0x192>
 6ce:	f9d9079b          	addiw	a5,s2,-99
 6d2:	0ff7f713          	zext.b	a4,a5
 6d6:	12eb6163          	bltu	s6,a4,7f8 <vprintf+0x192>
 6da:	00271793          	slli	a5,a4,0x2
 6de:	00000717          	auipc	a4,0x0
 6e2:	46270713          	addi	a4,a4,1122 # b40 <malloc+0x228>
 6e6:	97ba                	add	a5,a5,a4
 6e8:	439c                	lw	a5,0(a5)
 6ea:	97ba                	add	a5,a5,a4
 6ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	ebe080e7          	jalr	-322(ra) # 5ba <printint>
 704:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 706:	4981                	li	s3,0
 708:	b745                	j	6a8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	ea2080e7          	jalr	-350(ra) # 5ba <printint>
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	b751                	j	6a8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4641                	li	a2,16
 72e:	000ba583          	lw	a1,0(s7)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e86080e7          	jalr	-378(ra) # 5ba <printint>
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	b7a5                	j	6a8 <vprintf+0x42>
 742:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 744:	008b8c13          	addi	s8,s7,8
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e46080e7          	jalr	-442(ra) # 598 <putc>
  putc(fd, 'x');
 75a:	07800593          	li	a1,120
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e38080e7          	jalr	-456(ra) # 598 <putc>
 768:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	00000b97          	auipc	s7,0x0
 76e:	42eb8b93          	addi	s7,s7,1070 # b98 <digits>
 772:	03c9d793          	srli	a5,s3,0x3c
 776:	97de                	add	a5,a5,s7
 778:	0007c583          	lbu	a1,0(a5)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e1a080e7          	jalr	-486(ra) # 598 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 786:	0992                	slli	s3,s3,0x4
 788:	397d                	addiw	s2,s2,-1
 78a:	fe0914e3          	bnez	s2,772 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 78e:	8be2                	mv	s7,s8
      state = 0;
 790:	4981                	li	s3,0
 792:	6c02                	ld	s8,0(sp)
 794:	bf11                	j	6a8 <vprintf+0x42>
        s = va_arg(ap, char *);
 796:	008b8993          	addi	s3,s7,8
 79a:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 79e:	02090163          	beqz	s2,7c0 <vprintf+0x15a>
        while (*s != 0) {
 7a2:	00094583          	lbu	a1,0(s2)
 7a6:	c9a5                	beqz	a1,816 <vprintf+0x1b0>
          putc(fd, *s);
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	dee080e7          	jalr	-530(ra) # 598 <putc>
          s++;
 7b2:	0905                	addi	s2,s2,1
        while (*s != 0) {
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	f9e5                	bnez	a1,7a8 <vprintf+0x142>
        s = va_arg(ap, char *);
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b5ed                	j	6a8 <vprintf+0x42>
        if (s == 0) s = "(null)";
 7c0:	00000917          	auipc	s2,0x0
 7c4:	37890913          	addi	s2,s2,888 # b38 <malloc+0x220>
        while (*s != 0) {
 7c8:	02800593          	li	a1,40
 7cc:	bff1                	j	7a8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	000bc583          	lbu	a1,0(s7)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dc0080e7          	jalr	-576(ra) # 598 <putc>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b5d1                	j	6a8 <vprintf+0x42>
        putc(fd, c);
 7e6:	02500593          	li	a1,37
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	dac080e7          	jalr	-596(ra) # 598 <putc>
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bd4d                	j	6a8 <vprintf+0x42>
        putc(fd, '%');
 7f8:	02500593          	li	a1,37
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	d9a080e7          	jalr	-614(ra) # 598 <putc>
        putc(fd, c);
 806:	85ca                	mv	a1,s2
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	d8e080e7          	jalr	-626(ra) # 598 <putc>
      state = 0;
 812:	4981                	li	s3,0
 814:	bd51                	j	6a8 <vprintf+0x42>
        s = va_arg(ap, char *);
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	b579                	j	6a8 <vprintf+0x42>
 81c:	74e2                	ld	s1,56(sp)
 81e:	79a2                	ld	s3,40(sp)
 820:	7a02                	ld	s4,32(sp)
 822:	6ae2                	ld	s5,24(sp)
 824:	6b42                	ld	s6,16(sp)
 826:	6ba2                	ld	s7,8(sp)
    }
  }
}
 828:	60a6                	ld	ra,72(sp)
 82a:	6406                	ld	s0,64(sp)
 82c:	7942                	ld	s2,48(sp)
 82e:	6161                	addi	sp,sp,80
 830:	8082                	ret

0000000000000832 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 832:	715d                	addi	sp,sp,-80
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e010                	sd	a2,0(s0)
 83c:	e414                	sd	a3,8(s0)
 83e:	e818                	sd	a4,16(s0)
 840:	ec1c                	sd	a5,24(s0)
 842:	03043023          	sd	a6,32(s0)
 846:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84e:	8622                	mv	a2,s0
 850:	00000097          	auipc	ra,0x0
 854:	e16080e7          	jalr	-490(ra) # 666 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:

void printf(const char *fmt, ...) {
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	00000097          	auipc	ra,0x0
 88a:	de0080e7          	jalr	-544(ra) # 666 <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6125                	addi	sp,sp,96
 894:	8082                	ret

0000000000000896 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 896:	1141                	addi	sp,sp,-16
 898:	e422                	sd	s0,8(sp)
 89a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 89c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	00001797          	auipc	a5,0x1
 8a4:	7607b783          	ld	a5,1888(a5) # 2000 <freep>
 8a8:	a02d                	j	8d2 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 8aa:	4618                	lw	a4,8(a2)
 8ac:	9f2d                	addw	a4,a4,a1
 8ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	6310                	ld	a2,0(a4)
 8b6:	a83d                	j	8f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8b8:	ff852703          	lw	a4,-8(a0)
 8bc:	9f31                	addw	a4,a4,a2
 8be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c0:	ff053683          	ld	a3,-16(a0)
 8c4:	a091                	j	908 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00e7e463          	bltu	a5,a4,8d0 <free+0x3a>
 8cc:	00e6ea63          	bltu	a3,a4,8e0 <free+0x4a>
void free(void *ap) {
 8d0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d2:	fed7fae3          	bgeu	a5,a3,8c6 <free+0x30>
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e6e463          	bltu	a3,a4,8e0 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8dc:	fee7eae3          	bltu	a5,a4,8d0 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8e0:	ff852583          	lw	a1,-8(a0)
 8e4:	6390                	ld	a2,0(a5)
 8e6:	02059813          	slli	a6,a1,0x20
 8ea:	01c85713          	srli	a4,a6,0x1c
 8ee:	9736                	add	a4,a4,a3
 8f0:	fae60de3          	beq	a2,a4,8aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8f8:	4790                	lw	a2,8(a5)
 8fa:	02061593          	slli	a1,a2,0x20
 8fe:	01c5d713          	srli	a4,a1,0x1c
 902:	973e                	add	a4,a4,a5
 904:	fae68ae3          	beq	a3,a4,8b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 908:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90a:	00001717          	auipc	a4,0x1
 90e:	6ef73b23          	sd	a5,1782(a4) # 2000 <freep>
}
 912:	6422                	ld	s0,8(sp)
 914:	0141                	addi	sp,sp,16
 916:	8082                	ret

0000000000000918 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 918:	7139                	addi	sp,sp,-64
 91a:	fc06                	sd	ra,56(sp)
 91c:	f822                	sd	s0,48(sp)
 91e:	f426                	sd	s1,40(sp)
 920:	ec4e                	sd	s3,24(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 934:	00001517          	auipc	a0,0x1
 938:	6cc53503          	ld	a0,1740(a0) # 2000 <freep>
 93c:	c915                	beqz	a0,970 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 93e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 940:	4798                	lw	a4,8(a5)
 942:	08977e63          	bgeu	a4,s1,9de <malloc+0xc6>
 946:	f04a                	sd	s2,32(sp)
 948:	e852                	sd	s4,16(sp)
 94a:	e456                	sd	s5,8(sp)
 94c:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 94e:	8a4e                	mv	s4,s3
 950:	0009871b          	sext.w	a4,s3
 954:	6685                	lui	a3,0x1
 956:	00d77363          	bgeu	a4,a3,95c <malloc+0x44>
 95a:	6a05                	lui	s4,0x1
 95c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 960:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 964:	00001917          	auipc	s2,0x1
 968:	69c90913          	addi	s2,s2,1692 # 2000 <freep>
  if (p == (char *)-1) return 0;
 96c:	5afd                	li	s5,-1
 96e:	a091                	j	9b2 <malloc+0x9a>
 970:	f04a                	sd	s2,32(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 978:	00001797          	auipc	a5,0x1
 97c:	69878793          	addi	a5,a5,1688 # 2010 <base>
 980:	00001717          	auipc	a4,0x1
 984:	68f73023          	sd	a5,1664(a4) # 2000 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 98e:	b7c1                	j	94e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	e118                	sd	a4,0(a0)
 994:	a08d                	j	9f6 <malloc+0xde>
  hp->s.size = nu;
 996:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 99a:	0541                	addi	a0,a0,16
 99c:	00000097          	auipc	ra,0x0
 9a0:	efa080e7          	jalr	-262(ra) # 896 <free>
  return freep;
 9a4:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 9a8:	c13d                	beqz	a0,a0e <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9aa:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9ac:	4798                	lw	a4,8(a5)
 9ae:	02977463          	bgeu	a4,s1,9d6 <malloc+0xbe>
    if (p == freep)
 9b2:	00093703          	ld	a4,0(s2)
 9b6:	853e                	mv	a0,a5
 9b8:	fef719e3          	bne	a4,a5,9aa <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 9bc:	8552                	mv	a0,s4
 9be:	00000097          	auipc	ra,0x0
 9c2:	bc2080e7          	jalr	-1086(ra) # 580 <sbrk>
  if (p == (char *)-1) return 0;
 9c6:	fd5518e3          	bne	a0,s5,996 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 9ca:	4501                	li	a0,0
 9cc:	7902                	ld	s2,32(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	a03d                	j	a02 <malloc+0xea>
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9de:	fae489e3          	beq	s1,a4,990 <malloc+0x78>
        p->s.size -= nunits;
 9e2:	4137073b          	subw	a4,a4,s3
 9e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e8:	02071693          	slli	a3,a4,0x20
 9ec:	01c6d713          	srli	a4,a3,0x1c
 9f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f6:	00001717          	auipc	a4,0x1
 9fa:	60a73523          	sd	a0,1546(a4) # 2000 <freep>
      return (void *)(p + 1);
 9fe:	01078513          	addi	a0,a5,16
  }
}
 a02:	70e2                	ld	ra,56(sp)
 a04:	7442                	ld	s0,48(sp)
 a06:	74a2                	ld	s1,40(sp)
 a08:	69e2                	ld	s3,24(sp)
 a0a:	6121                	addi	sp,sp,64
 a0c:	8082                	ret
 a0e:	7902                	ld	s2,32(sp)
 a10:	6a42                	ld	s4,16(sp)
 a12:	6aa2                	ld	s5,8(sp)
 a14:	6b02                	ld	s6,0(sp)
 a16:	b7f5                	j	a02 <malloc+0xea>
