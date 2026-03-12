
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <forktest>:
#include "user/user.h"

#define N 4096
#define NMIN 2560

void forktest(void) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
  int n, pid;

  int fd[2];
  char buf[1];
  if (pipe(fd) != 0) {
   c:	fd840513          	addi	a0,s0,-40
  10:	00000097          	auipc	ra,0x0
  14:	428080e7          	jalr	1064(ra) # 438 <pipe>
  18:	ed39                	bnez	a0,76 <forktest+0x76>
  1a:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }

  printf("forktest\n");
  1c:	00000517          	auipc	a0,0x0
  20:	7c450513          	addi	a0,a0,1988 # 7e0 <printf+0x50>
  24:	00000097          	auipc	ra,0x0
  28:	76c080e7          	jalr	1900(ra) # 790 <printf>

  for (n = 0; n < N; n++) {
  2c:	6905                	lui	s2,0x1
    pid = fork();
  2e:	00000097          	auipc	ra,0x0
  32:	3f2080e7          	jalr	1010(ra) # 420 <fork>
    if (pid < 0) break;
  36:	0c054863          	bltz	a0,106 <forktest+0x106>
    if (pid == 0) {
  3a:	c939                	beqz	a0,90 <forktest+0x90>
  for (n = 0; n < N; n++) {
  3c:	2485                	addiw	s1,s1,1
  3e:	ff2498e3          	bne	s1,s2,2e <forktest+0x2e>
      read(fd[0], buf, 1);
      exit(0);
    }
  }

  close(fd[0]);
  42:	fd842503          	lw	a0,-40(s0)
  46:	00000097          	auipc	ra,0x0
  4a:	40a080e7          	jalr	1034(ra) # 450 <close>
  close(fd[1]);
  4e:	fdc42503          	lw	a0,-36(s0)
  52:	00000097          	auipc	ra,0x0
  56:	3fe080e7          	jalr	1022(ra) # 450 <close>

  if (n == N) {
    // 4096 processes take more space than available RAM
    printf("fork claimed to work %d times!\n", N);
  5a:	6585                	lui	a1,0x1
  5c:	00000517          	auipc	a0,0x0
  60:	7ec50513          	addi	a0,a0,2028 # 848 <printf+0xb8>
  64:	00000097          	auipc	ra,0x0
  68:	72c080e7          	jalr	1836(ra) # 790 <printf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	3ba080e7          	jalr	954(ra) # 428 <exit>
    printf("pipe() failed\n");
  76:	00000517          	auipc	a0,0x0
  7a:	75250513          	addi	a0,a0,1874 # 7c8 <printf+0x38>
  7e:	00000097          	auipc	ra,0x0
  82:	712080e7          	jalr	1810(ra) # 790 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	00000097          	auipc	ra,0x0
  8c:	3a0080e7          	jalr	928(ra) # 428 <exit>
      close(fd[1]);
  90:	fdc42503          	lw	a0,-36(s0)
  94:	00000097          	auipc	ra,0x0
  98:	3bc080e7          	jalr	956(ra) # 450 <close>
      read(fd[0], buf, 1);
  9c:	4605                	li	a2,1
  9e:	fd040593          	addi	a1,s0,-48
  a2:	fd842503          	lw	a0,-40(s0)
  a6:	00000097          	auipc	ra,0x0
  aa:	39a080e7          	jalr	922(ra) # 440 <read>
      exit(0);
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	378080e7          	jalr	888(ra) # 428 <exit>
  }

  printf("forked %d processes", n);
  if (n < NMIN) {
    printf(", not enough\n");
  b8:	00000517          	auipc	a0,0x0
  bc:	73850513          	addi	a0,a0,1848 # 7f0 <printf+0x60>
  c0:	00000097          	auipc	ra,0x0
  c4:	6d0080e7          	jalr	1744(ra) # 790 <printf>
    exit(1);
  c8:	4505                	li	a0,1
  ca:	00000097          	auipc	ra,0x0
  ce:	35e080e7          	jalr	862(ra) # 428 <exit>
  }
  printf("\n");

  for (; n > 0; n--) {
    if (wait(0) < 0) {
      printf("wait stopped early\n");
  d2:	00000517          	auipc	a0,0x0
  d6:	73650513          	addi	a0,a0,1846 # 808 <printf+0x78>
  da:	00000097          	auipc	ra,0x0
  de:	6b6080e7          	jalr	1718(ra) # 790 <printf>
      exit(1);
  e2:	4505                	li	a0,1
  e4:	00000097          	auipc	ra,0x0
  e8:	344080e7          	jalr	836(ra) # 428 <exit>
    }
  }

  if (wait(0) != -1) {
    printf("wait got too many\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	73450513          	addi	a0,a0,1844 # 820 <printf+0x90>
  f4:	00000097          	auipc	ra,0x0
  f8:	69c080e7          	jalr	1692(ra) # 790 <printf>
    exit(1);
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	32a080e7          	jalr	810(ra) # 428 <exit>
  close(fd[0]);
 106:	fd842503          	lw	a0,-40(s0)
 10a:	00000097          	auipc	ra,0x0
 10e:	346080e7          	jalr	838(ra) # 450 <close>
  close(fd[1]);
 112:	fdc42503          	lw	a0,-36(s0)
 116:	00000097          	auipc	ra,0x0
 11a:	33a080e7          	jalr	826(ra) # 450 <close>
  printf("forked %d processes", n);
 11e:	85a6                	mv	a1,s1
 120:	00000517          	auipc	a0,0x0
 124:	74850513          	addi	a0,a0,1864 # 868 <printf+0xd8>
 128:	00000097          	auipc	ra,0x0
 12c:	668080e7          	jalr	1640(ra) # 790 <printf>
  if (n < NMIN) {
 130:	6785                	lui	a5,0x1
 132:	9ff78793          	addi	a5,a5,-1537 # 9ff <digits+0x11f>
 136:	f897d1e3          	bge	a5,s1,b8 <forktest+0xb8>
  printf("\n");
 13a:	00000517          	auipc	a0,0x0
 13e:	6c650513          	addi	a0,a0,1734 # 800 <printf+0x70>
 142:	00000097          	auipc	ra,0x0
 146:	64e080e7          	jalr	1614(ra) # 790 <printf>
    if (wait(0) < 0) {
 14a:	4501                	li	a0,0
 14c:	00000097          	auipc	ra,0x0
 150:	2e4080e7          	jalr	740(ra) # 430 <wait>
 154:	f6054fe3          	bltz	a0,d2 <forktest+0xd2>
  for (; n > 0; n--) {
 158:	34fd                	addiw	s1,s1,-1
 15a:	f8e5                	bnez	s1,14a <forktest+0x14a>
  if (wait(0) != -1) {
 15c:	4501                	li	a0,0
 15e:	00000097          	auipc	ra,0x0
 162:	2d2080e7          	jalr	722(ra) # 430 <wait>
 166:	57fd                	li	a5,-1
 168:	f8f512e3          	bne	a0,a5,ec <forktest+0xec>
  }

  printf("forktest: OK\n");
 16c:	00000517          	auipc	a0,0x0
 170:	6cc50513          	addi	a0,a0,1740 # 838 <printf+0xa8>
 174:	00000097          	auipc	ra,0x0
 178:	61c080e7          	jalr	1564(ra) # 790 <printf>
}
 17c:	70a2                	ld	ra,40(sp)
 17e:	7402                	ld	s0,32(sp)
 180:	64e2                	ld	s1,24(sp)
 182:	6942                	ld	s2,16(sp)
 184:	6145                	addi	sp,sp,48
 186:	8082                	ret

0000000000000188 <main>:

int main(void) {
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  forktest();
 190:	00000097          	auipc	ra,0x0
 194:	e70080e7          	jalr	-400(ra) # 0 <forktest>
  exit(0);
 198:	4501                	li	a0,0
 19a:	00000097          	auipc	ra,0x0
 19e:	28e080e7          	jalr	654(ra) # 428 <exit>

00000000000001a2 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1aa:	00000097          	auipc	ra,0x0
 1ae:	fde080e7          	jalr	-34(ra) # 188 <main>
  exit(0);
 1b2:	4501                	li	a0,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	274080e7          	jalr	628(ra) # 428 <exit>

00000000000001bc <strcpy>:
}

char *strcpy(char *s, const char *t) {
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 1c2:	87aa                	mv	a5,a0
 1c4:	0585                	addi	a1,a1,1 # 1001 <__BSS_END__+0x3a9>
 1c6:	0785                	addi	a5,a5,1
 1c8:	fff5c703          	lbu	a4,-1(a1)
 1cc:	fee78fa3          	sb	a4,-1(a5)
 1d0:	fb75                	bnez	a4,1c4 <strcpy+0x8>
  return os;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strcmp>:

int strcmp(const char *p, const char *q) {
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb91                	beqz	a5,1f6 <strcmp+0x1e>
 1e4:	0005c703          	lbu	a4,0(a1)
 1e8:	00f71763          	bne	a4,a5,1f6 <strcmp+0x1e>
 1ec:	0505                	addi	a0,a0,1
 1ee:	0585                	addi	a1,a1,1
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	fbe5                	bnez	a5,1e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f6:	0005c503          	lbu	a0,0(a1)
}
 1fa:	40a7853b          	subw	a0,a5,a0
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strlen>:

uint strlen(const char *s) {
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cf91                	beqz	a5,22a <strlen+0x26>
 210:	0505                	addi	a0,a0,1
 212:	87aa                	mv	a5,a0
 214:	86be                	mv	a3,a5
 216:	0785                	addi	a5,a5,1
 218:	fff7c703          	lbu	a4,-1(a5)
 21c:	ff65                	bnez	a4,214 <strlen+0x10>
 21e:	40a6853b          	subw	a0,a3,a0
 222:	2505                	addiw	a0,a0,1
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  for (n = 0; s[n]; n++);
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strlen+0x20>

000000000000022e <memset>:

void *memset(void *dst, int c, uint n) {
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 234:	ca19                	beqz	a2,24a <memset+0x1c>
 236:	87aa                	mv	a5,a0
 238:	1602                	slli	a2,a2,0x20
 23a:	9201                	srli	a2,a2,0x20
 23c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 240:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 244:	0785                	addi	a5,a5,1
 246:	fee79de3          	bne	a5,a4,240 <memset+0x12>
  }
  return dst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret

0000000000000250 <strchr>:

char *strchr(const char *s, char c) {
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  for (; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cb99                	beqz	a5,270 <strchr+0x20>
    if (*s == c) return (char *)s;
 25c:	00f58763          	beq	a1,a5,26a <strchr+0x1a>
  for (; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	fbfd                	bnez	a5,25c <strchr+0xc>
  return 0;
 268:	4501                	li	a0,0
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <strchr+0x1a>

0000000000000274 <gets>:

char *gets(char *buf, int max) {
 274:	711d                	addi	sp,sp,-96
 276:	ec86                	sd	ra,88(sp)
 278:	e8a2                	sd	s0,80(sp)
 27a:	e4a6                	sd	s1,72(sp)
 27c:	e0ca                	sd	s2,64(sp)
 27e:	fc4e                	sd	s3,56(sp)
 280:	f852                	sd	s4,48(sp)
 282:	f456                	sd	s5,40(sp)
 284:	f05a                	sd	s6,32(sp)
 286:	ec5e                	sd	s7,24(sp)
 288:	1080                	addi	s0,sp,96
 28a:	8baa                	mv	s7,a0
 28c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 28e:	892a                	mv	s2,a0
 290:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 292:	4aa9                	li	s5,10
 294:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 296:	89a6                	mv	s3,s1
 298:	2485                	addiw	s1,s1,1
 29a:	0344d863          	bge	s1,s4,2ca <gets+0x56>
    cc = read(0, &c, 1);
 29e:	4605                	li	a2,1
 2a0:	faf40593          	addi	a1,s0,-81
 2a4:	4501                	li	a0,0
 2a6:	00000097          	auipc	ra,0x0
 2aa:	19a080e7          	jalr	410(ra) # 440 <read>
    if (cc < 1) break;
 2ae:	00a05e63          	blez	a0,2ca <gets+0x56>
    buf[i++] = c;
 2b2:	faf44783          	lbu	a5,-81(s0)
 2b6:	00f90023          	sb	a5,0(s2) # 1000 <__BSS_END__+0x3a8>
    if (c == '\n' || c == '\r') break;
 2ba:	01578763          	beq	a5,s5,2c8 <gets+0x54>
 2be:	0905                	addi	s2,s2,1
 2c0:	fd679be3          	bne	a5,s6,296 <gets+0x22>
    buf[i++] = c;
 2c4:	89a6                	mv	s3,s1
 2c6:	a011                	j	2ca <gets+0x56>
 2c8:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 2ca:	99de                	add	s3,s3,s7
 2cc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d0:	855e                	mv	a0,s7
 2d2:	60e6                	ld	ra,88(sp)
 2d4:	6446                	ld	s0,80(sp)
 2d6:	64a6                	ld	s1,72(sp)
 2d8:	6906                	ld	s2,64(sp)
 2da:	79e2                	ld	s3,56(sp)
 2dc:	7a42                	ld	s4,48(sp)
 2de:	7aa2                	ld	s5,40(sp)
 2e0:	7b02                	ld	s6,32(sp)
 2e2:	6be2                	ld	s7,24(sp)
 2e4:	6125                	addi	sp,sp,96
 2e6:	8082                	ret

00000000000002e8 <stat>:

int stat(const char *n, struct stat *st) {
 2e8:	1101                	addi	sp,sp,-32
 2ea:	ec06                	sd	ra,24(sp)
 2ec:	e822                	sd	s0,16(sp)
 2ee:	e04a                	sd	s2,0(sp)
 2f0:	1000                	addi	s0,sp,32
 2f2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f4:	4581                	li	a1,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	172080e7          	jalr	370(ra) # 468 <open>
  if (fd < 0) return -1;
 2fe:	02054663          	bltz	a0,32a <stat+0x42>
 302:	e426                	sd	s1,8(sp)
 304:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 306:	85ca                	mv	a1,s2
 308:	00000097          	auipc	ra,0x0
 30c:	178080e7          	jalr	376(ra) # 480 <fstat>
 310:	892a                	mv	s2,a0
  close(fd);
 312:	8526                	mv	a0,s1
 314:	00000097          	auipc	ra,0x0
 318:	13c080e7          	jalr	316(ra) # 450 <close>
  return r;
 31c:	64a2                	ld	s1,8(sp)
}
 31e:	854a                	mv	a0,s2
 320:	60e2                	ld	ra,24(sp)
 322:	6442                	ld	s0,16(sp)
 324:	6902                	ld	s2,0(sp)
 326:	6105                	addi	sp,sp,32
 328:	8082                	ret
  if (fd < 0) return -1;
 32a:	597d                	li	s2,-1
 32c:	bfcd                	j	31e <stat+0x36>

000000000000032e <atoi>:

int atoi(const char *s) {
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 334:	00054683          	lbu	a3,0(a0)
 338:	fd06879b          	addiw	a5,a3,-48
 33c:	0ff7f793          	zext.b	a5,a5
 340:	4625                	li	a2,9
 342:	02f66863          	bltu	a2,a5,372 <atoi+0x44>
 346:	872a                	mv	a4,a0
  n = 0;
 348:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 34a:	0705                	addi	a4,a4,1
 34c:	0025179b          	slliw	a5,a0,0x2
 350:	9fa9                	addw	a5,a5,a0
 352:	0017979b          	slliw	a5,a5,0x1
 356:	9fb5                	addw	a5,a5,a3
 358:	fd07851b          	addiw	a0,a5,-48
 35c:	00074683          	lbu	a3,0(a4)
 360:	fd06879b          	addiw	a5,a3,-48
 364:	0ff7f793          	zext.b	a5,a5
 368:	fef671e3          	bgeu	a2,a5,34a <atoi+0x1c>
  return n;
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  n = 0;
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <atoi+0x3e>

0000000000000376 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 37c:	02b57463          	bgeu	a0,a1,3a4 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 380:	00c05f63          	blez	a2,39e <memmove+0x28>
 384:	1602                	slli	a2,a2,0x20
 386:	9201                	srli	a2,a2,0x20
 388:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 38c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 38e:	0585                	addi	a1,a1,1
 390:	0705                	addi	a4,a4,1
 392:	fff5c683          	lbu	a3,-1(a1)
 396:	fed70fa3          	sb	a3,-1(a4)
 39a:	fef71ae3          	bne	a4,a5,38e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
    dst += n;
 3a4:	00c50733          	add	a4,a0,a2
    src += n;
 3a8:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 3aa:	fec05ae3          	blez	a2,39e <memmove+0x28>
 3ae:	fff6079b          	addiw	a5,a2,-1
 3b2:	1782                	slli	a5,a5,0x20
 3b4:	9381                	srli	a5,a5,0x20
 3b6:	fff7c793          	not	a5,a5
 3ba:	97ba                	add	a5,a5,a4
 3bc:	15fd                	addi	a1,a1,-1
 3be:	177d                	addi	a4,a4,-1
 3c0:	0005c683          	lbu	a3,0(a1)
 3c4:	00d70023          	sb	a3,0(a4)
 3c8:	fee79ae3          	bne	a5,a4,3bc <memmove+0x46>
 3cc:	bfc9                	j	39e <memmove+0x28>

00000000000003ce <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d4:	ca05                	beqz	a2,404 <memcmp+0x36>
 3d6:	fff6069b          	addiw	a3,a2,-1
 3da:	1682                	slli	a3,a3,0x20
 3dc:	9281                	srli	a3,a3,0x20
 3de:	0685                	addi	a3,a3,1
 3e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	0005c703          	lbu	a4,0(a1)
 3ea:	00e79863          	bne	a5,a4,3fa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ee:	0505                	addi	a0,a0,1
    p2++;
 3f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f2:	fed518e3          	bne	a0,a3,3e2 <memcmp+0x14>
  }
  return 0;
 3f6:	4501                	li	a0,0
 3f8:	a019                	j	3fe <memcmp+0x30>
      return *p1 - *p2;
 3fa:	40e7853b          	subw	a0,a5,a4
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret
  return 0;
 404:	4501                	li	a0,0
 406:	bfe5                	j	3fe <memcmp+0x30>

0000000000000408 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 408:	1141                	addi	sp,sp,-16
 40a:	e406                	sd	ra,8(sp)
 40c:	e022                	sd	s0,0(sp)
 40e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 410:	00000097          	auipc	ra,0x0
 414:	f66080e7          	jalr	-154(ra) # 376 <memmove>
}
 418:	60a2                	ld	ra,8(sp)
 41a:	6402                	ld	s0,0(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 420:	4885                	li	a7,1
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <exit>:
.global exit
exit:
 li a7, SYS_exit
 428:	4889                	li	a7,2
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <wait>:
.global wait
wait:
 li a7, SYS_wait
 430:	488d                	li	a7,3
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 438:	4891                	li	a7,4
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <read>:
.global read
read:
 li a7, SYS_read
 440:	4895                	li	a7,5
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <write>:
.global write
write:
 li a7, SYS_write
 448:	48c1                	li	a7,16
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <close>:
.global close
close:
 li a7, SYS_close
 450:	48d5                	li	a7,21
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <kill>:
.global kill
kill:
 li a7, SYS_kill
 458:	4899                	li	a7,6
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <exec>:
.global exec
exec:
 li a7, SYS_exec
 460:	489d                	li	a7,7
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <open>:
.global open
open:
 li a7, SYS_open
 468:	48bd                	li	a7,15
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 470:	48c5                	li	a7,17
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 478:	48c9                	li	a7,18
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 480:	48a1                	li	a7,8
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <link>:
.global link
link:
 li a7, SYS_link
 488:	48cd                	li	a7,19
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 490:	48d1                	li	a7,20
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 498:	48a5                	li	a7,9
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a0:	48a9                	li	a7,10
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a8:	48ad                	li	a7,11
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b0:	48b1                	li	a7,12
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b8:	48b5                	li	a7,13
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c0:	48b9                	li	a7,14
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 4c8:	1101                	addi	sp,sp,-32
 4ca:	ec06                	sd	ra,24(sp)
 4cc:	e822                	sd	s0,16(sp)
 4ce:	1000                	addi	s0,sp,32
 4d0:	feb407a3          	sb	a1,-17(s0)
 4d4:	4605                	li	a2,1
 4d6:	fef40593          	addi	a1,s0,-17
 4da:	00000097          	auipc	ra,0x0
 4de:	f6e080e7          	jalr	-146(ra) # 448 <write>
 4e2:	60e2                	ld	ra,24(sp)
 4e4:	6442                	ld	s0,16(sp)
 4e6:	6105                	addi	sp,sp,32
 4e8:	8082                	ret

00000000000004ea <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 4ea:	7139                	addi	sp,sp,-64
 4ec:	fc06                	sd	ra,56(sp)
 4ee:	f822                	sd	s0,48(sp)
 4f0:	f426                	sd	s1,40(sp)
 4f2:	0080                	addi	s0,sp,64
 4f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 4f6:	c299                	beqz	a3,4fc <printint+0x12>
 4f8:	0805cb63          	bltz	a1,58e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fc:	2581                	sext.w	a1,a1
  neg = 0;
 4fe:	4881                	li	a7,0
 500:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 504:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 506:	2601                	sext.w	a2,a2
 508:	00000517          	auipc	a0,0x0
 50c:	3d850513          	addi	a0,a0,984 # 8e0 <digits>
 510:	883a                	mv	a6,a4
 512:	2705                	addiw	a4,a4,1
 514:	02c5f7bb          	remuw	a5,a1,a2
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	97aa                	add	a5,a5,a0
 51e:	0007c783          	lbu	a5,0(a5)
 522:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 526:	0005879b          	sext.w	a5,a1
 52a:	02c5d5bb          	divuw	a1,a1,a2
 52e:	0685                	addi	a3,a3,1
 530:	fec7f0e3          	bgeu	a5,a2,510 <printint+0x26>
  if (neg) buf[i++] = '-';
 534:	00088c63          	beqz	a7,54c <printint+0x62>
 538:	fd070793          	addi	a5,a4,-48
 53c:	00878733          	add	a4,a5,s0
 540:	02d00793          	li	a5,45
 544:	fef70823          	sb	a5,-16(a4)
 548:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 54c:	02e05c63          	blez	a4,584 <printint+0x9a>
 550:	f04a                	sd	s2,32(sp)
 552:	ec4e                	sd	s3,24(sp)
 554:	fc040793          	addi	a5,s0,-64
 558:	00e78933          	add	s2,a5,a4
 55c:	fff78993          	addi	s3,a5,-1
 560:	99ba                	add	s3,s3,a4
 562:	377d                	addiw	a4,a4,-1
 564:	1702                	slli	a4,a4,0x20
 566:	9301                	srli	a4,a4,0x20
 568:	40e989b3          	sub	s3,s3,a4
 56c:	fff94583          	lbu	a1,-1(s2)
 570:	8526                	mv	a0,s1
 572:	00000097          	auipc	ra,0x0
 576:	f56080e7          	jalr	-170(ra) # 4c8 <putc>
 57a:	197d                	addi	s2,s2,-1
 57c:	ff3918e3          	bne	s2,s3,56c <printint+0x82>
 580:	7902                	ld	s2,32(sp)
 582:	69e2                	ld	s3,24(sp)
}
 584:	70e2                	ld	ra,56(sp)
 586:	7442                	ld	s0,48(sp)
 588:	74a2                	ld	s1,40(sp)
 58a:	6121                	addi	sp,sp,64
 58c:	8082                	ret
    x = -xx;
 58e:	40b005bb          	negw	a1,a1
    neg = 1;
 592:	4885                	li	a7,1
    x = -xx;
 594:	b7b5                	j	500 <printint+0x16>

0000000000000596 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 596:	715d                	addi	sp,sp,-80
 598:	e486                	sd	ra,72(sp)
 59a:	e0a2                	sd	s0,64(sp)
 59c:	f84a                	sd	s2,48(sp)
 59e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5a0:	0005c903          	lbu	s2,0(a1)
 5a4:	1a090a63          	beqz	s2,758 <vprintf+0x1c2>
 5a8:	fc26                	sd	s1,56(sp)
 5aa:	f44e                	sd	s3,40(sp)
 5ac:	f052                	sd	s4,32(sp)
 5ae:	ec56                	sd	s5,24(sp)
 5b0:	e85a                	sd	s6,16(sp)
 5b2:	e45e                	sd	s7,8(sp)
 5b4:	8aaa                	mv	s5,a0
 5b6:	8bb2                	mv	s7,a2
 5b8:	00158493          	addi	s1,a1,1
  state = 0;
 5bc:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 5be:	02500a13          	li	s4,37
 5c2:	4b55                	li	s6,21
 5c4:	a839                	j	5e2 <vprintf+0x4c>
        putc(fd, c);
 5c6:	85ca                	mv	a1,s2
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	efe080e7          	jalr	-258(ra) # 4c8 <putc>
 5d2:	a019                	j	5d8 <vprintf+0x42>
    } else if (state == '%') {
 5d4:	01498d63          	beq	s3,s4,5ee <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 5d8:	0485                	addi	s1,s1,1
 5da:	fff4c903          	lbu	s2,-1(s1)
 5de:	16090763          	beqz	s2,74c <vprintf+0x1b6>
    if (state == 0) {
 5e2:	fe0999e3          	bnez	s3,5d4 <vprintf+0x3e>
      if (c == '%') {
 5e6:	ff4910e3          	bne	s2,s4,5c6 <vprintf+0x30>
        state = '%';
 5ea:	89d2                	mv	s3,s4
 5ec:	b7f5                	j	5d8 <vprintf+0x42>
      if (c == 'd') {
 5ee:	13490463          	beq	s2,s4,716 <vprintf+0x180>
 5f2:	f9d9079b          	addiw	a5,s2,-99
 5f6:	0ff7f793          	zext.b	a5,a5
 5fa:	12fb6763          	bltu	s6,a5,728 <vprintf+0x192>
 5fe:	f9d9079b          	addiw	a5,s2,-99
 602:	0ff7f713          	zext.b	a4,a5
 606:	12eb6163          	bltu	s6,a4,728 <vprintf+0x192>
 60a:	00271793          	slli	a5,a4,0x2
 60e:	00000717          	auipc	a4,0x0
 612:	27a70713          	addi	a4,a4,634 # 888 <printf+0xf8>
 616:	97ba                	add	a5,a5,a4
 618:	439c                	lw	a5,0(a5)
 61a:	97ba                	add	a5,a5,a4
 61c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 61e:	008b8913          	addi	s2,s7,8
 622:	4685                	li	a3,1
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	ebe080e7          	jalr	-322(ra) # 4ea <printint>
 634:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 636:	4981                	li	s3,0
 638:	b745                	j	5d8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	ea2080e7          	jalr	-350(ra) # 4ea <printint>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	b751                	j	5d8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000ba583          	lw	a1,0(s7)
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e86080e7          	jalr	-378(ra) # 4ea <printint>
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
 670:	b7a5                	j	5d8 <vprintf+0x42>
 672:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 674:	008b8c13          	addi	s8,s7,8
 678:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67c:	03000593          	li	a1,48
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e46080e7          	jalr	-442(ra) # 4c8 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e38080e7          	jalr	-456(ra) # 4c8 <putc>
 698:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69a:	00000b97          	auipc	s7,0x0
 69e:	246b8b93          	addi	s7,s7,582 # 8e0 <digits>
 6a2:	03c9d793          	srli	a5,s3,0x3c
 6a6:	97de                	add	a5,a5,s7
 6a8:	0007c583          	lbu	a1,0(a5)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e1a080e7          	jalr	-486(ra) # 4c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b6:	0992                	slli	s3,s3,0x4
 6b8:	397d                	addiw	s2,s2,-1
 6ba:	fe0914e3          	bnez	s2,6a2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6be:	8be2                	mv	s7,s8
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	6c02                	ld	s8,0(sp)
 6c4:	bf11                	j	5d8 <vprintf+0x42>
        s = va_arg(ap, char *);
 6c6:	008b8993          	addi	s3,s7,8
 6ca:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 6ce:	02090163          	beqz	s2,6f0 <vprintf+0x15a>
        while (*s != 0) {
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	c9a5                	beqz	a1,746 <vprintf+0x1b0>
          putc(fd, *s);
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	dee080e7          	jalr	-530(ra) # 4c8 <putc>
          s++;
 6e2:	0905                	addi	s2,s2,1
        while (*s != 0) {
 6e4:	00094583          	lbu	a1,0(s2)
 6e8:	f9e5                	bnez	a1,6d8 <vprintf+0x142>
        s = va_arg(ap, char *);
 6ea:	8bce                	mv	s7,s3
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b5ed                	j	5d8 <vprintf+0x42>
        if (s == 0) s = "(null)";
 6f0:	00000917          	auipc	s2,0x0
 6f4:	19090913          	addi	s2,s2,400 # 880 <printf+0xf0>
        while (*s != 0) {
 6f8:	02800593          	li	a1,40
 6fc:	bff1                	j	6d8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6fe:	008b8913          	addi	s2,s7,8
 702:	000bc583          	lbu	a1,0(s7)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	dc0080e7          	jalr	-576(ra) # 4c8 <putc>
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	b5d1                	j	5d8 <vprintf+0x42>
        putc(fd, c);
 716:	02500593          	li	a1,37
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	dac080e7          	jalr	-596(ra) # 4c8 <putc>
      state = 0;
 724:	4981                	li	s3,0
 726:	bd4d                	j	5d8 <vprintf+0x42>
        putc(fd, '%');
 728:	02500593          	li	a1,37
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	d9a080e7          	jalr	-614(ra) # 4c8 <putc>
        putc(fd, c);
 736:	85ca                	mv	a1,s2
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	d8e080e7          	jalr	-626(ra) # 4c8 <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	bd51                	j	5d8 <vprintf+0x42>
        s = va_arg(ap, char *);
 746:	8bce                	mv	s7,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	b579                	j	5d8 <vprintf+0x42>
 74c:	74e2                	ld	s1,56(sp)
 74e:	79a2                	ld	s3,40(sp)
 750:	7a02                	ld	s4,32(sp)
 752:	6ae2                	ld	s5,24(sp)
 754:	6b42                	ld	s6,16(sp)
 756:	6ba2                	ld	s7,8(sp)
    }
  }
}
 758:	60a6                	ld	ra,72(sp)
 75a:	6406                	ld	s0,64(sp)
 75c:	7942                	ld	s2,48(sp)
 75e:	6161                	addi	sp,sp,80
 760:	8082                	ret

0000000000000762 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 762:	715d                	addi	sp,sp,-80
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e010                	sd	a2,0(s0)
 76c:	e414                	sd	a3,8(s0)
 76e:	e818                	sd	a4,16(s0)
 770:	ec1c                	sd	a5,24(s0)
 772:	03043023          	sd	a6,32(s0)
 776:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77e:	8622                	mv	a2,s0
 780:	00000097          	auipc	ra,0x0
 784:	e16080e7          	jalr	-490(ra) # 596 <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6161                	addi	sp,sp,80
 78e:	8082                	ret

0000000000000790 <printf>:

void printf(const char *fmt, ...) {
 790:	711d                	addi	sp,sp,-96
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	e40c                	sd	a1,8(s0)
 79a:	e810                	sd	a2,16(s0)
 79c:	ec14                	sd	a3,24(s0)
 79e:	f018                	sd	a4,32(s0)
 7a0:	f41c                	sd	a5,40(s0)
 7a2:	03043823          	sd	a6,48(s0)
 7a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7aa:	00840613          	addi	a2,s0,8
 7ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b2:	85aa                	mv	a1,a0
 7b4:	4505                	li	a0,1
 7b6:	00000097          	auipc	ra,0x0
 7ba:	de0080e7          	jalr	-544(ra) # 596 <vprintf>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret
