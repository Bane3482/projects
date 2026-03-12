
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#include "user/user.h"

#define N 1000

void print(const char *s) { write(1, s, strlen(s)); }
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
   c:	00000097          	auipc	ra,0x0
  10:	16c080e7          	jalr	364(ra) # 178 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	41a080e7          	jalr	1050(ra) # 436 <write>
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void forktest(void) {
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	48650513          	addi	a0,a0,1158 # 4c0 <reg+0xa>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for (n = 0; n < N; n++) {
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	3be080e7          	jalr	958(ra) # 40e <fork>
    if (pid < 0) break;
  58:	06054163          	bltz	a0,ba <forktest+0x8c>
    if (pid == 0) exit(0);
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for (n = 0; n < N; n++) {
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
  }

  if (n == N) {
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	4ac50513          	addi	a0,a0,1196 # 510 <reg+0x5a>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	3a0080e7          	jalr	928(ra) # 416 <exit>
    if (pid == 0) exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	398080e7          	jalr	920(ra) # 416 <exit>
  }

  for (; n > 0; n--) {
    if (wait(0) < 0) {
      print("wait stopped early\n");
  86:	00000517          	auipc	a0,0x0
  8a:	44a50513          	addi	a0,a0,1098 # 4d0 <reg+0x1a>
  8e:	00000097          	auipc	ra,0x0
  92:	f72080e7          	jalr	-142(ra) # 0 <print>
      exit(1);
  96:	4505                	li	a0,1
  98:	00000097          	auipc	ra,0x0
  9c:	37e080e7          	jalr	894(ra) # 416 <exit>
    }
  }

  if (wait(0) != -1) {
    print("wait got too many\n");
  a0:	00000517          	auipc	a0,0x0
  a4:	44850513          	addi	a0,a0,1096 # 4e8 <reg+0x32>
  a8:	00000097          	auipc	ra,0x0
  ac:	f58080e7          	jalr	-168(ra) # 0 <print>
    exit(1);
  b0:	4505                	li	a0,1
  b2:	00000097          	auipc	ra,0x0
  b6:	364080e7          	jalr	868(ra) # 416 <exit>
  for (; n > 0; n--) {
  ba:	00905b63          	blez	s1,d0 <forktest+0xa2>
    if (wait(0) < 0) {
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	35e080e7          	jalr	862(ra) # 41e <wait>
  c8:	fa054fe3          	bltz	a0,86 <forktest+0x58>
  for (; n > 0; n--) {
  cc:	34fd                	addiw	s1,s1,-1
  ce:	f8e5                	bnez	s1,be <forktest+0x90>
  if (wait(0) != -1) {
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	34c080e7          	jalr	844(ra) # 41e <wait>
  da:	57fd                	li	a5,-1
  dc:	fcf512e3          	bne	a0,a5,a0 <forktest+0x72>
  }

  print("fork test OK\n");
  e0:	00000517          	auipc	a0,0x0
  e4:	42050513          	addi	a0,a0,1056 # 500 <reg+0x4a>
  e8:	00000097          	auipc	ra,0x0
  ec:	f18080e7          	jalr	-232(ra) # 0 <print>
}
  f0:	60e2                	ld	ra,24(sp)
  f2:	6442                	ld	s0,16(sp)
  f4:	64a2                	ld	s1,8(sp)
  f6:	6902                	ld	s2,0(sp)
  f8:	6105                	addi	sp,sp,32
  fa:	8082                	ret

00000000000000fc <main>:

int main(void) {
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  forktest();
 104:	00000097          	auipc	ra,0x0
 108:	f2a080e7          	jalr	-214(ra) # 2e <forktest>
  exit(0);
 10c:	4501                	li	a0,0
 10e:	00000097          	auipc	ra,0x0
 112:	308080e7          	jalr	776(ra) # 416 <exit>

0000000000000116 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 11e:	00000097          	auipc	ra,0x0
 122:	fde080e7          	jalr	-34(ra) # fc <main>
  exit(0);
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	2ee080e7          	jalr	750(ra) # 416 <exit>

0000000000000130 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 136:	87aa                	mv	a5,a0
 138:	0585                	addi	a1,a1,1
 13a:	0785                	addi	a5,a5,1
 13c:	fff5c703          	lbu	a4,-1(a1)
 140:	fee78fa3          	sb	a4,-1(a5)
 144:	fb75                	bnez	a4,138 <strcpy+0x8>
  return os;
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <strcmp>:

int strcmp(const char *p, const char *q) {
 14c:	1141                	addi	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 152:	00054783          	lbu	a5,0(a0)
 156:	cb91                	beqz	a5,16a <strcmp+0x1e>
 158:	0005c703          	lbu	a4,0(a1)
 15c:	00f71763          	bne	a4,a5,16a <strcmp+0x1e>
 160:	0505                	addi	a0,a0,1
 162:	0585                	addi	a1,a1,1
 164:	00054783          	lbu	a5,0(a0)
 168:	fbe5                	bnez	a5,158 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16a:	0005c503          	lbu	a0,0(a1)
}
 16e:	40a7853b          	subw	a0,a5,a0
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strlen>:

uint strlen(const char *s) {
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf91                	beqz	a5,19e <strlen+0x26>
 184:	0505                	addi	a0,a0,1
 186:	87aa                	mv	a5,a0
 188:	86be                	mv	a3,a5
 18a:	0785                	addi	a5,a5,1
 18c:	fff7c703          	lbu	a4,-1(a5)
 190:	ff65                	bnez	a4,188 <strlen+0x10>
 192:	40a6853b          	subw	a0,a3,a0
 196:	2505                	addiw	a0,a0,1
  return n;
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  for (n = 0; s[n]; n++);
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strlen+0x20>

00000000000001a2 <memset>:

void *memset(void *dst, int c, uint n) {
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1a8:	ca19                	beqz	a2,1be <memset+0x1c>
 1aa:	87aa                	mv	a5,a0
 1ac:	1602                	slli	a2,a2,0x20
 1ae:	9201                	srli	a2,a2,0x20
 1b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1b8:	0785                	addi	a5,a5,1
 1ba:	fee79de3          	bne	a5,a4,1b4 <memset+0x12>
  }
  return dst;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strchr>:

char *strchr(const char *s, char c) {
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb99                	beqz	a5,1e4 <strchr+0x20>
    if (*s == c) return (char *)s;
 1d0:	00f58763          	beq	a1,a5,1de <strchr+0x1a>
  for (; *s; s++)
 1d4:	0505                	addi	a0,a0,1
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	fbfd                	bnez	a5,1d0 <strchr+0xc>
  return 0;
 1dc:	4501                	li	a0,0
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  return 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <strchr+0x1a>

00000000000001e8 <gets>:

char *gets(char *buf, int max) {
 1e8:	711d                	addi	sp,sp,-96
 1ea:	ec86                	sd	ra,88(sp)
 1ec:	e8a2                	sd	s0,80(sp)
 1ee:	e4a6                	sd	s1,72(sp)
 1f0:	e0ca                	sd	s2,64(sp)
 1f2:	fc4e                	sd	s3,56(sp)
 1f4:	f852                	sd	s4,48(sp)
 1f6:	f456                	sd	s5,40(sp)
 1f8:	f05a                	sd	s6,32(sp)
 1fa:	ec5e                	sd	s7,24(sp)
 1fc:	1080                	addi	s0,sp,96
 1fe:	8baa                	mv	s7,a0
 200:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 202:	892a                	mv	s2,a0
 204:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 206:	4aa9                	li	s5,10
 208:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 20a:	89a6                	mv	s3,s1
 20c:	2485                	addiw	s1,s1,1
 20e:	0344d863          	bge	s1,s4,23e <gets+0x56>
    cc = read(0, &c, 1);
 212:	4605                	li	a2,1
 214:	faf40593          	addi	a1,s0,-81
 218:	4501                	li	a0,0
 21a:	00000097          	auipc	ra,0x0
 21e:	214080e7          	jalr	532(ra) # 42e <read>
    if (cc < 1) break;
 222:	00a05e63          	blez	a0,23e <gets+0x56>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 22e:	01578763          	beq	a5,s5,23c <gets+0x54>
 232:	0905                	addi	s2,s2,1
 234:	fd679be3          	bne	a5,s6,20a <gets+0x22>
    buf[i++] = c;
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x56>
 23c:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	addi	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int stat(const char *n, struct stat *st) {
 25c:	1101                	addi	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e04a                	sd	s2,0(sp)
 264:	1000                	addi	s0,sp,32
 266:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	4581                	li	a1,0
 26a:	00000097          	auipc	ra,0x0
 26e:	1ec080e7          	jalr	492(ra) # 456 <open>
  if (fd < 0) return -1;
 272:	02054663          	bltz	a0,29e <stat+0x42>
 276:	e426                	sd	s1,8(sp)
 278:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 27a:	85ca                	mv	a1,s2
 27c:	00000097          	auipc	ra,0x0
 280:	1f2080e7          	jalr	498(ra) # 46e <fstat>
 284:	892a                	mv	s2,a0
  close(fd);
 286:	8526                	mv	a0,s1
 288:	00000097          	auipc	ra,0x0
 28c:	1b6080e7          	jalr	438(ra) # 43e <close>
  return r;
 290:	64a2                	ld	s1,8(sp)
}
 292:	854a                	mv	a0,s2
 294:	60e2                	ld	ra,24(sp)
 296:	6442                	ld	s0,16(sp)
 298:	6902                	ld	s2,0(sp)
 29a:	6105                	addi	sp,sp,32
 29c:	8082                	ret
  if (fd < 0) return -1;
 29e:	597d                	li	s2,-1
 2a0:	bfcd                	j	292 <stat+0x36>

00000000000002a2 <atoi>:

int atoi(const char *s) {
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2a8:	00054683          	lbu	a3,0(a0)
 2ac:	fd06879b          	addiw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	4625                	li	a2,9
 2b6:	02f66863          	bltu	a2,a5,2e6 <atoi+0x44>
 2ba:	872a                	mv	a4,a0
  n = 0;
 2bc:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2be:	0705                	addi	a4,a4,1
 2c0:	0025179b          	slliw	a5,a0,0x2
 2c4:	9fa9                	addw	a5,a5,a0
 2c6:	0017979b          	slliw	a5,a5,0x1
 2ca:	9fb5                	addw	a5,a5,a3
 2cc:	fd07851b          	addiw	a0,a5,-48
 2d0:	00074683          	lbu	a3,0(a4)
 2d4:	fd06879b          	addiw	a5,a3,-48
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	fef671e3          	bgeu	a2,a5,2be <atoi+0x1c>
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  n = 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <atoi+0x3e>

00000000000002ea <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f0:	02b57463          	bgeu	a0,a1,318 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 2f4:	00c05f63          	blez	a2,312 <memmove+0x28>
 2f8:	1602                	slli	a2,a2,0x20
 2fa:	9201                	srli	a2,a2,0x20
 2fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 300:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 302:	0585                	addi	a1,a1,1
 304:	0705                	addi	a4,a4,1
 306:	fff5c683          	lbu	a3,-1(a1)
 30a:	fed70fa3          	sb	a3,-1(a4)
 30e:	fef71ae3          	bne	a4,a5,302 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
    dst += n;
 318:	00c50733          	add	a4,a0,a2
    src += n;
 31c:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 31e:	fec05ae3          	blez	a2,312 <memmove+0x28>
 322:	fff6079b          	addiw	a5,a2,-1
 326:	1782                	slli	a5,a5,0x20
 328:	9381                	srli	a5,a5,0x20
 32a:	fff7c793          	not	a5,a5
 32e:	97ba                	add	a5,a5,a4
 330:	15fd                	addi	a1,a1,-1
 332:	177d                	addi	a4,a4,-1
 334:	0005c683          	lbu	a3,0(a1)
 338:	00d70023          	sb	a3,0(a4)
 33c:	fee79ae3          	bne	a5,a4,330 <memmove+0x46>
 340:	bfc9                	j	312 <memmove+0x28>

0000000000000342 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 348:	ca05                	beqz	a2,378 <memcmp+0x36>
 34a:	fff6069b          	addiw	a3,a2,-1
 34e:	1682                	slli	a3,a3,0x20
 350:	9281                	srli	a3,a3,0x20
 352:	0685                	addi	a3,a3,1
 354:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 356:	00054783          	lbu	a5,0(a0)
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	00e79863          	bne	a5,a4,36e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 362:	0505                	addi	a0,a0,1
    p2++;
 364:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 366:	fed518e3          	bne	a0,a3,356 <memcmp+0x14>
  }
  return 0;
 36a:	4501                	li	a0,0
 36c:	a019                	j	372 <memcmp+0x30>
      return *p1 - *p2;
 36e:	40e7853b          	subw	a0,a5,a4
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <memcmp+0x30>

000000000000037c <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 384:	00000097          	auipc	ra,0x0
 388:	f66080e7          	jalr	-154(ra) # 2ea <memmove>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <strcat>:

char *strcat(char *dst, const char *src) {
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 39a:	00054783          	lbu	a5,0(a0)
 39e:	c385                	beqz	a5,3be <strcat+0x2a>
  char *p = dst;
 3a0:	87aa                	mv	a5,a0
  while (*p) p++;
 3a2:	0785                	addi	a5,a5,1
 3a4:	0007c703          	lbu	a4,0(a5)
 3a8:	ff6d                	bnez	a4,3a2 <strcat+0xe>
  while ((*p++ = *src++));
 3aa:	0585                	addi	a1,a1,1
 3ac:	0785                	addi	a5,a5,1
 3ae:	fff5c703          	lbu	a4,-1(a1)
 3b2:	fee78fa3          	sb	a4,-1(a5)
 3b6:	fb75                	bnez	a4,3aa <strcat+0x16>
  return dst;
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
  char *p = dst;
 3be:	87aa                	mv	a5,a0
 3c0:	b7ed                	j	3aa <strcat+0x16>

00000000000003c2 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 3c8:	0005c783          	lbu	a5,0(a1)
 3cc:	cf95                	beqz	a5,408 <strstr+0x46>

  for (; *haystack; haystack++) {
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	eb91                	bnez	a5,3e6 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	a80d                	j	408 <strstr+0x46>
    if (!*n) return (char *)haystack;
 3d8:	0007c783          	lbu	a5,0(a5)
 3dc:	c795                	beqz	a5,408 <strstr+0x46>
  for (; *haystack; haystack++) {
 3de:	0505                	addi	a0,a0,1
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	c38d                	beqz	a5,406 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 3e6:	00054703          	lbu	a4,0(a0)
    n = needle;
 3ea:	87ae                	mv	a5,a1
    h = haystack;
 3ec:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 3ee:	db65                	beqz	a4,3de <strstr+0x1c>
 3f0:	0007c683          	lbu	a3,0(a5)
 3f4:	ca91                	beqz	a3,408 <strstr+0x46>
 3f6:	fee691e3          	bne	a3,a4,3d8 <strstr+0x16>
      h++;
 3fa:	0605                	addi	a2,a2,1
      n++;
 3fc:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 3fe:	00064703          	lbu	a4,0(a2)
 402:	f77d                	bnez	a4,3f0 <strstr+0x2e>
 404:	bfd1                	j	3d8 <strstr+0x16>
  return 0;
 406:	4501                	li	a0,0
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40e:	4885                	li	a7,1
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exit>:
.global exit
exit:
 li a7, SYS_exit
 416:	4889                	li	a7,2
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <wait>:
.global wait
wait:
 li a7, SYS_wait
 41e:	488d                	li	a7,3
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 426:	4891                	li	a7,4
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <read>:
.global read
read:
 li a7, SYS_read
 42e:	4895                	li	a7,5
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <write>:
.global write
write:
 li a7, SYS_write
 436:	48c1                	li	a7,16
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <close>:
.global close
close:
 li a7, SYS_close
 43e:	48d5                	li	a7,21
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <kill>:
.global kill
kill:
 li a7, SYS_kill
 446:	4899                	li	a7,6
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exec>:
.global exec
exec:
 li a7, SYS_exec
 44e:	489d                	li	a7,7
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <open>:
.global open
open:
 li a7, SYS_open
 456:	48bd                	li	a7,15
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45e:	48c5                	li	a7,17
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 466:	48c9                	li	a7,18
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46e:	48a1                	li	a7,8
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <link>:
.global link
link:
 li a7, SYS_link
 476:	48cd                	li	a7,19
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47e:	48d1                	li	a7,20
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 486:	48a5                	li	a7,9
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <dup>:
.global dup
dup:
 li a7, SYS_dup
 48e:	48a9                	li	a7,10
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 496:	48ad                	li	a7,11
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49e:	48b1                	li	a7,12
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a6:	48b5                	li	a7,13
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ae:	48b9                	li	a7,14
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <reg>:
.global reg
reg:
 li a7, SYS_reg
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret
