
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/file.h"
#include "user/user.h"

char *argv[] = {"sh", 0};

int main(void) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if (open("console", O_RDWR) < 0) {
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	97250513          	addi	a0,a0,-1678 # 980 <loop+0xc>
  16:	00000097          	auipc	ra,0x0
  1a:	422080e7          	jalr	1058(ra) # 438 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	44c080e7          	jalr	1100(ra) # 470 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	442080e7          	jalr	1090(ra) # 470 <dup>

  for (;;) {
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	95290913          	addi	s2,s2,-1710 # 988 <loop+0x14>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	728080e7          	jalr	1832(ra) # 768 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	3a8080e7          	jalr	936(ra) # 3f0 <fork>
  50:	84aa                	mv	s1,a0
    if (pid < 0) {
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for (;;) {
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *)0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	3a6080e7          	jalr	934(ra) # 400 <wait>
      if (wpid == pid) {
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if (wpid < 0) {
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	96e50513          	addi	a0,a0,-1682 # 9d8 <loop+0x64>
  72:	00000097          	auipc	ra,0x0
  76:	6f6080e7          	jalr	1782(ra) # 768 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	37c080e7          	jalr	892(ra) # 3f8 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	8f850513          	addi	a0,a0,-1800 # 980 <loop+0xc>
  90:	00000097          	auipc	ra,0x0
  94:	3b0080e7          	jalr	944(ra) # 440 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	8e650513          	addi	a0,a0,-1818 # 980 <loop+0xc>
  a2:	00000097          	auipc	ra,0x0
  a6:	396080e7          	jalr	918(ra) # 438 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	8f450513          	addi	a0,a0,-1804 # 9a0 <loop+0x2c>
  b4:	00000097          	auipc	ra,0x0
  b8:	6b4080e7          	jalr	1716(ra) # 768 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	33a080e7          	jalr	826(ra) # 3f8 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	8ea50513          	addi	a0,a0,-1814 # 9b8 <loop+0x44>
  d6:	00000097          	auipc	ra,0x0
  da:	35a080e7          	jalr	858(ra) # 430 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	8e250513          	addi	a0,a0,-1822 # 9c0 <loop+0x4c>
  e6:	00000097          	auipc	ra,0x0
  ea:	682080e7          	jalr	1666(ra) # 768 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	308080e7          	jalr	776(ra) # 3f8 <exit>

00000000000000f8 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2ee080e7          	jalr	750(ra) # 3f8 <exit>

0000000000000112 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 118:	87aa                	mv	a5,a0
 11a:	0585                	addi	a1,a1,1
 11c:	0785                	addi	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int strcmp(const char *p, const char *q) {
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint strlen(const char *s) {
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addiw	a0,a0,1
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for (n = 0; s[n]; n++);
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void *memset(void *dst, int c, uint n) {
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char *strchr(const char *s, char c) {
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if (*s == c) return (char *)s;
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for (; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char *gets(char *buf, int max) {
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	214080e7          	jalr	532(ra) # 410 <read>
    if (cc < 1) break;
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
    buf[i++] = c;
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int stat(const char *n, struct stat *st) {
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	1ec080e7          	jalr	492(ra) # 438 <open>
  if (fd < 0) return -1;
 254:	02054663          	bltz	a0,280 <stat+0x42>
 258:	e426                	sd	s1,8(sp)
 25a:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	1f2080e7          	jalr	498(ra) # 450 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	1b6080e7          	jalr	438(ra) # 420 <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
  if (fd < 0) return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x36>

0000000000000284 <atoi>:

int atoi(const char *s) {
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0705                	addi	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
 2f0:	fef71ae3          	bne	a4,a5,2e4 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addiw	a5,a2,-1
 308:	1782                	slli	a5,a5,0x20
 30a:	9381                	srli	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
 312:	15fd                	addi	a1,a1,-1
 314:	177d                	addi	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addiw	a3,a2,-1
 330:	1682                	slli	a3,a3,0x20
 332:	9281                	srli	a3,a3,0x20
 334:	0685                	addi	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	addi	a0,a0,1
    p2++;
 346:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <strcat>:

char *strcat(char *dst, const char *src) {
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 37c:	00054783          	lbu	a5,0(a0)
 380:	c385                	beqz	a5,3a0 <strcat+0x2a>
  char *p = dst;
 382:	87aa                	mv	a5,a0
  while (*p) p++;
 384:	0785                	addi	a5,a5,1
 386:	0007c703          	lbu	a4,0(a5)
 38a:	ff6d                	bnez	a4,384 <strcat+0xe>
  while ((*p++ = *src++));
 38c:	0585                	addi	a1,a1,1
 38e:	0785                	addi	a5,a5,1
 390:	fff5c703          	lbu	a4,-1(a1)
 394:	fee78fa3          	sb	a4,-1(a5)
 398:	fb75                	bnez	a4,38c <strcat+0x16>
  return dst;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  char *p = dst;
 3a0:	87aa                	mv	a5,a0
 3a2:	b7ed                	j	38c <strcat+0x16>

00000000000003a4 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 3aa:	0005c783          	lbu	a5,0(a1)
 3ae:	cf95                	beqz	a5,3ea <strstr+0x46>

  for (; *haystack; haystack++) {
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	eb91                	bnez	a5,3c8 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	a80d                	j	3ea <strstr+0x46>
    if (!*n) return (char *)haystack;
 3ba:	0007c783          	lbu	a5,0(a5)
 3be:	c795                	beqz	a5,3ea <strstr+0x46>
  for (; *haystack; haystack++) {
 3c0:	0505                	addi	a0,a0,1
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	c38d                	beqz	a5,3e8 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 3c8:	00054703          	lbu	a4,0(a0)
    n = needle;
 3cc:	87ae                	mv	a5,a1
    h = haystack;
 3ce:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 3d0:	db65                	beqz	a4,3c0 <strstr+0x1c>
 3d2:	0007c683          	lbu	a3,0(a5)
 3d6:	ca91                	beqz	a3,3ea <strstr+0x46>
 3d8:	fee691e3          	bne	a3,a4,3ba <strstr+0x16>
      h++;
 3dc:	0605                	addi	a2,a2,1
      n++;
 3de:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 3e0:	00064703          	lbu	a4,0(a2)
 3e4:	f77d                	bnez	a4,3d2 <strstr+0x2e>
 3e6:	bfd1                	j	3ba <strstr+0x16>
  return 0;
 3e8:	4501                	li	a0,0
}
 3ea:	6422                	ld	s0,8(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f0:	4885                	li	a7,1
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f8:	4889                	li	a7,2
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <wait>:
.global wait
wait:
 li a7, SYS_wait
 400:	488d                	li	a7,3
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 408:	4891                	li	a7,4
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <read>:
.global read
read:
 li a7, SYS_read
 410:	4895                	li	a7,5
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <write>:
.global write
write:
 li a7, SYS_write
 418:	48c1                	li	a7,16
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <close>:
.global close
close:
 li a7, SYS_close
 420:	48d5                	li	a7,21
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <kill>:
.global kill
kill:
 li a7, SYS_kill
 428:	4899                	li	a7,6
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <exec>:
.global exec
exec:
 li a7, SYS_exec
 430:	489d                	li	a7,7
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <open>:
.global open
open:
 li a7, SYS_open
 438:	48bd                	li	a7,15
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 440:	48c5                	li	a7,17
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 448:	48c9                	li	a7,18
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 450:	48a1                	li	a7,8
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <link>:
.global link
link:
 li a7, SYS_link
 458:	48cd                	li	a7,19
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 460:	48d1                	li	a7,20
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 468:	48a5                	li	a7,9
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <dup>:
.global dup
dup:
 li a7, SYS_dup
 470:	48a9                	li	a7,10
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 478:	48ad                	li	a7,11
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 480:	48b1                	li	a7,12
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 488:	48b5                	li	a7,13
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 490:	48b9                	li	a7,14
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <reg>:
.global reg
reg:
 li a7, SYS_reg
 498:	48d9                	li	a7,22
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f66080e7          	jalr	-154(ra) # 418 <write>
 4ba:	60e2                	ld	ra,24(sp)
 4bc:	6442                	ld	s0,16(sp)
 4be:	6105                	addi	sp,sp,32
 4c0:	8082                	ret

00000000000004c2 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 4c2:	7139                	addi	sp,sp,-64
 4c4:	fc06                	sd	ra,56(sp)
 4c6:	f822                	sd	s0,48(sp)
 4c8:	f426                	sd	s1,40(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 4ce:	c299                	beqz	a3,4d4 <printint+0x12>
 4d0:	0805cb63          	bltz	a1,566 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	57850513          	addi	a0,a0,1400 # a58 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x26>
  if (neg) buf[i++] = '-';
 50c:	00088c63          	beqz	a7,524 <printint+0x62>
 510:	fd070793          	addi	a5,a4,-48
 514:	00878733          	add	a4,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 524:	02e05c63          	blez	a4,55c <printint+0x9a>
 528:	f04a                	sd	s2,32(sp)
 52a:	ec4e                	sd	s3,24(sp)
 52c:	fc040793          	addi	a5,s0,-64
 530:	00e78933          	add	s2,a5,a4
 534:	fff78993          	addi	s3,a5,-1
 538:	99ba                	add	s3,s3,a4
 53a:	377d                	addiw	a4,a4,-1
 53c:	1702                	slli	a4,a4,0x20
 53e:	9301                	srli	a4,a4,0x20
 540:	40e989b3          	sub	s3,s3,a4
 544:	fff94583          	lbu	a1,-1(s2)
 548:	8526                	mv	a0,s1
 54a:	00000097          	auipc	ra,0x0
 54e:	f56080e7          	jalr	-170(ra) # 4a0 <putc>
 552:	197d                	addi	s2,s2,-1
 554:	ff3918e3          	bne	s2,s3,544 <printint+0x82>
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	6121                	addi	sp,sp,64
 564:	8082                	ret
    x = -xx;
 566:	40b005bb          	negw	a1,a1
    neg = 1;
 56a:	4885                	li	a7,1
    x = -xx;
 56c:	b7b5                	j	4d8 <printint+0x16>

000000000000056e <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 56e:	715d                	addi	sp,sp,-80
 570:	e486                	sd	ra,72(sp)
 572:	e0a2                	sd	s0,64(sp)
 574:	f84a                	sd	s2,48(sp)
 576:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 578:	0005c903          	lbu	s2,0(a1)
 57c:	1a090a63          	beqz	s2,730 <vprintf+0x1c2>
 580:	fc26                	sd	s1,56(sp)
 582:	f44e                	sd	s3,40(sp)
 584:	f052                	sd	s4,32(sp)
 586:	ec56                	sd	s5,24(sp)
 588:	e85a                	sd	s6,16(sp)
 58a:	e45e                	sd	s7,8(sp)
 58c:	8aaa                	mv	s5,a0
 58e:	8bb2                	mv	s7,a2
 590:	00158493          	addi	s1,a1,1
  state = 0;
 594:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 596:	02500a13          	li	s4,37
 59a:	4b55                	li	s6,21
 59c:	a839                	j	5ba <vprintf+0x4c>
        putc(fd, c);
 59e:	85ca                	mv	a1,s2
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	efe080e7          	jalr	-258(ra) # 4a0 <putc>
 5aa:	a019                	j	5b0 <vprintf+0x42>
    } else if (state == '%') {
 5ac:	01498d63          	beq	s3,s4,5c6 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 5b0:	0485                	addi	s1,s1,1
 5b2:	fff4c903          	lbu	s2,-1(s1)
 5b6:	16090763          	beqz	s2,724 <vprintf+0x1b6>
    if (state == 0) {
 5ba:	fe0999e3          	bnez	s3,5ac <vprintf+0x3e>
      if (c == '%') {
 5be:	ff4910e3          	bne	s2,s4,59e <vprintf+0x30>
        state = '%';
 5c2:	89d2                	mv	s3,s4
 5c4:	b7f5                	j	5b0 <vprintf+0x42>
      if (c == 'd') {
 5c6:	13490463          	beq	s2,s4,6ee <vprintf+0x180>
 5ca:	f9d9079b          	addiw	a5,s2,-99
 5ce:	0ff7f793          	zext.b	a5,a5
 5d2:	12fb6763          	bltu	s6,a5,700 <vprintf+0x192>
 5d6:	f9d9079b          	addiw	a5,s2,-99
 5da:	0ff7f713          	zext.b	a4,a5
 5de:	12eb6163          	bltu	s6,a4,700 <vprintf+0x192>
 5e2:	00271793          	slli	a5,a4,0x2
 5e6:	00000717          	auipc	a4,0x0
 5ea:	41a70713          	addi	a4,a4,1050 # a00 <loop+0x8c>
 5ee:	97ba                	add	a5,a5,a4
 5f0:	439c                	lw	a5,0(a5)
 5f2:	97ba                	add	a5,a5,a4
 5f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	ebe080e7          	jalr	-322(ra) # 4c2 <printint>
 60c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 60e:	4981                	li	s3,0
 610:	b745                	j	5b0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	ea2080e7          	jalr	-350(ra) # 4c2 <printint>
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b751                	j	5b0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 62e:	008b8913          	addi	s2,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000ba583          	lw	a1,0(s7)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e86080e7          	jalr	-378(ra) # 4c2 <printint>
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	b7a5                	j	5b0 <vprintf+0x42>
 64a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 64c:	008b8c13          	addi	s8,s7,8
 650:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 654:	03000593          	li	a1,48
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	e46080e7          	jalr	-442(ra) # 4a0 <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e38080e7          	jalr	-456(ra) # 4a0 <putc>
 670:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	3e6b8b93          	addi	s7,s7,998 # a58 <digits>
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e1a080e7          	jalr	-486(ra) # 4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68e:	0992                	slli	s3,s3,0x4
 690:	397d                	addiw	s2,s2,-1
 692:	fe0914e3          	bnez	s2,67a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 696:	8be2                	mv	s7,s8
      state = 0;
 698:	4981                	li	s3,0
 69a:	6c02                	ld	s8,0(sp)
 69c:	bf11                	j	5b0 <vprintf+0x42>
        s = va_arg(ap, char *);
 69e:	008b8993          	addi	s3,s7,8
 6a2:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 6a6:	02090163          	beqz	s2,6c8 <vprintf+0x15a>
        while (*s != 0) {
 6aa:	00094583          	lbu	a1,0(s2)
 6ae:	c9a5                	beqz	a1,71e <vprintf+0x1b0>
          putc(fd, *s);
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dee080e7          	jalr	-530(ra) # 4a0 <putc>
          s++;
 6ba:	0905                	addi	s2,s2,1
        while (*s != 0) {
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	f9e5                	bnez	a1,6b0 <vprintf+0x142>
        s = va_arg(ap, char *);
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b5ed                	j	5b0 <vprintf+0x42>
        if (s == 0) s = "(null)";
 6c8:	00000917          	auipc	s2,0x0
 6cc:	33090913          	addi	s2,s2,816 # 9f8 <loop+0x84>
        while (*s != 0) {
 6d0:	02800593          	li	a1,40
 6d4:	bff1                	j	6b0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6d6:	008b8913          	addi	s2,s7,8
 6da:	000bc583          	lbu	a1,0(s7)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dc0080e7          	jalr	-576(ra) # 4a0 <putc>
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b5d1                	j	5b0 <vprintf+0x42>
        putc(fd, c);
 6ee:	02500593          	li	a1,37
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dac080e7          	jalr	-596(ra) # 4a0 <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd4d                	j	5b0 <vprintf+0x42>
        putc(fd, '%');
 700:	02500593          	li	a1,37
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d9a080e7          	jalr	-614(ra) # 4a0 <putc>
        putc(fd, c);
 70e:	85ca                	mv	a1,s2
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	d8e080e7          	jalr	-626(ra) # 4a0 <putc>
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bd51                	j	5b0 <vprintf+0x42>
        s = va_arg(ap, char *);
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b579                	j	5b0 <vprintf+0x42>
 724:	74e2                	ld	s1,56(sp)
 726:	79a2                	ld	s3,40(sp)
 728:	7a02                	ld	s4,32(sp)
 72a:	6ae2                	ld	s5,24(sp)
 72c:	6b42                	ld	s6,16(sp)
 72e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 730:	60a6                	ld	ra,72(sp)
 732:	6406                	ld	s0,64(sp)
 734:	7942                	ld	s2,48(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	00000097          	auipc	ra,0x0
 75c:	e16080e7          	jalr	-490(ra) # 56e <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <printf>:

void printf(const char *fmt, ...) {
 768:	711d                	addi	sp,sp,-96
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e40c                	sd	a1,8(s0)
 772:	e810                	sd	a2,16(s0)
 774:	ec14                	sd	a3,24(s0)
 776:	f018                	sd	a4,32(s0)
 778:	f41c                	sd	a5,40(s0)
 77a:	03043823          	sd	a6,48(s0)
 77e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	00840613          	addi	a2,s0,8
 786:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78a:	85aa                	mv	a1,a0
 78c:	4505                	li	a0,1
 78e:	00000097          	auipc	ra,0x0
 792:	de0080e7          	jalr	-544(ra) # 56e <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 79e:	1141                	addi	sp,sp,-16
 7a0:	e422                	sd	s0,8(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8687b783          	ld	a5,-1944(a5) # 1010 <freep>
 7b0:	a02d                	j	7da <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7b2:	4618                	lw	a4,8(a2)
 7b4:	9f2d                	addw	a4,a4,a1
 7b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	6310                	ld	a2,0(a4)
 7be:	a83d                	j	7fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9f31                	addw	a4,a4,a2
 7c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053683          	ld	a3,-16(a0)
 7cc:	a091                	j	810 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e7e463          	bltu	a5,a4,7d8 <free+0x3a>
 7d4:	00e6ea63          	bltu	a3,a4,7e8 <free+0x4a>
void free(void *ap) {
 7d8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	fed7fae3          	bgeu	a5,a3,7ce <free+0x30>
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e6e463          	bltu	a3,a4,7e8 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7e4:	fee7eae3          	bltu	a5,a4,7d8 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 7e8:	ff852583          	lw	a1,-8(a0)
 7ec:	6390                	ld	a2,0(a5)
 7ee:	02059813          	slli	a6,a1,0x20
 7f2:	01c85713          	srli	a4,a6,0x1c
 7f6:	9736                	add	a4,a4,a3
 7f8:	fae60de3          	beq	a2,a4,7b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 800:	4790                	lw	a2,8(a5)
 802:	02061593          	slli	a1,a2,0x20
 806:	01c5d713          	srli	a4,a1,0x1c
 80a:	973e                	add	a4,a4,a5
 80c:	fae68ae3          	beq	a3,a4,7c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 810:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 812:	00000717          	auipc	a4,0x0
 816:	7ef73f23          	sd	a5,2046(a4) # 1010 <freep>
}
 81a:	6422                	ld	s0,8(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret

0000000000000820 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 820:	7139                	addi	sp,sp,-64
 822:	fc06                	sd	ra,56(sp)
 824:	f822                	sd	s0,48(sp)
 826:	f426                	sd	s1,40(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 82c:	02051493          	slli	s1,a0,0x20
 830:	9081                	srli	s1,s1,0x20
 832:	04bd                	addi	s1,s1,15
 834:	8091                	srli	s1,s1,0x4
 836:	0014899b          	addiw	s3,s1,1
 83a:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 83c:	00000517          	auipc	a0,0x0
 840:	7d453503          	ld	a0,2004(a0) # 1010 <freep>
 844:	c915                	beqz	a0,878 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 846:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 848:	4798                	lw	a4,8(a5)
 84a:	08977e63          	bgeu	a4,s1,8e6 <malloc+0xc6>
 84e:	f04a                	sd	s2,32(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 856:	8a4e                	mv	s4,s3
 858:	0009871b          	sext.w	a4,s3
 85c:	6685                	lui	a3,0x1
 85e:	00d77363          	bgeu	a4,a3,864 <malloc+0x44>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 86c:	00000917          	auipc	s2,0x0
 870:	7a490913          	addi	s2,s2,1956 # 1010 <freep>
  if (p == (char *)-1) return 0;
 874:	5afd                	li	s5,-1
 876:	a091                	j	8ba <malloc+0x9a>
 878:	f04a                	sd	s2,32(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	7a078793          	addi	a5,a5,1952 # 1020 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	78f73423          	sd	a5,1928(a4) # 1010 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 896:	b7c1                	j	856 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	a08d                	j	8fe <malloc+0xde>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	00000097          	auipc	ra,0x0
 8a8:	efa080e7          	jalr	-262(ra) # 79e <free>
  return freep;
 8ac:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 8b0:	c13d                	beqz	a0,916 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b4:	4798                	lw	a4,8(a5)
 8b6:	02977463          	bgeu	a4,s1,8de <malloc+0xbe>
    if (p == freep)
 8ba:	00093703          	ld	a4,0(s2)
 8be:	853e                	mv	a0,a5
 8c0:	fef719e3          	bne	a4,a5,8b2 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	00000097          	auipc	ra,0x0
 8ca:	bba080e7          	jalr	-1094(ra) # 480 <sbrk>
  if (p == (char *)-1) return 0;
 8ce:	fd5518e3          	bne	a0,s5,89e <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 8d2:	4501                	li	a0,0
 8d4:	7902                	ld	s2,32(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	a03d                	j	90a <malloc+0xea>
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e6:	fae489e3          	beq	s1,a4,898 <malloc+0x78>
        p->s.size -= nunits;
 8ea:	4137073b          	subw	a4,a4,s3
 8ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f0:	02071693          	slli	a3,a4,0x20
 8f4:	01c6d713          	srli	a4,a3,0x1c
 8f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fe:	00000717          	auipc	a4,0x0
 902:	70a73923          	sd	a0,1810(a4) # 1010 <freep>
      return (void *)(p + 1);
 906:	01078513          	addi	a0,a5,16
  }
}
 90a:	70e2                	ld	ra,56(sp)
 90c:	7442                	ld	s0,48(sp)
 90e:	74a2                	ld	s1,40(sp)
 910:	69e2                	ld	s3,24(sp)
 912:	6121                	addi	sp,sp,64
 914:	8082                	ret
 916:	7902                	ld	s2,32(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	b7f5                	j	90a <malloc+0xea>

0000000000000920 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 920:	4909                	li	s2,2
  li s3, 3
 922:	498d                	li	s3,3
  li s4, 4
 924:	4a11                	li	s4,4
  li s5, 5
 926:	4a95                	li	s5,5
  li s6, 6
 928:	4b19                	li	s6,6
  li s7, 7
 92a:	4b9d                	li	s7,7
  li s8, 8
 92c:	4c21                	li	s8,8
  li s9, 9
 92e:	4ca5                	li	s9,9
  li s10, 10
 930:	4d29                	li	s10,10
  li s11, 11
 932:	4dad                	li	s11,11
  li a7, SYS_write
 934:	48c1                	li	a7,16
  ecall
 936:	00000073          	ecall
  j loop
 93a:	a82d                	j	974 <loop>

000000000000093c <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 93c:	4911                	li	s2,4
  li s3, 9
 93e:	49a5                	li	s3,9
  li s4, 16
 940:	4a41                	li	s4,16
  li s5, 25
 942:	4ae5                	li	s5,25
  li s6, 36
 944:	02400b13          	li	s6,36
  li s7, 49
 948:	03100b93          	li	s7,49
  li s8, 64
 94c:	04000c13          	li	s8,64
  li s9, 81
 950:	05100c93          	li	s9,81
  li s10, 100
 954:	06400d13          	li	s10,100
  li s11, 121
 958:	07900d93          	li	s11,121
  li a7, SYS_write
 95c:	48c1                	li	a7,16
  ecall
 95e:	00000073          	ecall
  j loop
 962:	a809                	j	974 <loop>

0000000000000964 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 964:	53900913          	li	s2,1337
  mv a2, a1
 968:	862e                	mv	a2,a1
  li a1, 2
 96a:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 96c:	48d9                	li	a7,22
  ecall
 96e:	00000073          	ecall
#endif
  ret
 972:	8082                	ret

0000000000000974 <loop>:

loop:
  j loop
 974:	a001                	j	974 <loop>
  ret
 976:	8082                	ret
