
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
// Create a zombie process that
// must be reparented at exit.

#include "user/user.h"

int main(void) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (fork() > 0) sleep(5);  // Let child exit before parent.
   8:	00000097          	auipc	ra,0x0
   c:	31a080e7          	jalr	794(ra) # 322 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	314080e7          	jalr	788(ra) # 32a <exit>
  if (fork() > 0) sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	39a080e7          	jalr	922(ra) # 3ba <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2ee080e7          	jalr	750(ra) # 32a <exit>

0000000000000044 <strcpy>:
}

char *strcpy(char *s, const char *t) {
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int strcmp(const char *p, const char *q) {
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint strlen(const char *s) {
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for (n = 0; s[n]; n++);
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void *memset(void *dst, int c, uint n) {
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char *strchr(const char *s, char c) {
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for (; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if (*s == c) return (char *)s;
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for (; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char *gets(char *buf, int max) {
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	214080e7          	jalr	532(ra) # 342 <read>
    if (cc < 1) break;
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int stat(const char *n, struct stat *st) {
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	1ec080e7          	jalr	492(ra) # 36a <open>
  if (fd < 0) return -1;
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	1f2080e7          	jalr	498(ra) # 382 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	1b6080e7          	jalr	438(ra) # 352 <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
  if (fd < 0) return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

int atoi(const char *s) {
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
 222:	fef71ae3          	bne	a4,a5,216 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <strcat>:

char *strcat(char *dst, const char *src) {
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	c385                	beqz	a5,2d2 <strcat+0x2a>
  char *p = dst;
 2b4:	87aa                	mv	a5,a0
  while (*p) p++;
 2b6:	0785                	addi	a5,a5,1
 2b8:	0007c703          	lbu	a4,0(a5)
 2bc:	ff6d                	bnez	a4,2b6 <strcat+0xe>
  while ((*p++ = *src++));
 2be:	0585                	addi	a1,a1,1
 2c0:	0785                	addi	a5,a5,1
 2c2:	fff5c703          	lbu	a4,-1(a1)
 2c6:	fee78fa3          	sb	a4,-1(a5)
 2ca:	fb75                	bnez	a4,2be <strcat+0x16>
  return dst;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  char *p = dst;
 2d2:	87aa                	mv	a5,a0
 2d4:	b7ed                	j	2be <strcat+0x16>

00000000000002d6 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 2dc:	0005c783          	lbu	a5,0(a1)
 2e0:	cf95                	beqz	a5,31c <strstr+0x46>

  for (; *haystack; haystack++) {
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	eb91                	bnez	a5,2fa <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a80d                	j	31c <strstr+0x46>
    if (!*n) return (char *)haystack;
 2ec:	0007c783          	lbu	a5,0(a5)
 2f0:	c795                	beqz	a5,31c <strstr+0x46>
  for (; *haystack; haystack++) {
 2f2:	0505                	addi	a0,a0,1
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	c38d                	beqz	a5,31a <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 2fa:	00054703          	lbu	a4,0(a0)
    n = needle;
 2fe:	87ae                	mv	a5,a1
    h = haystack;
 300:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 302:	db65                	beqz	a4,2f2 <strstr+0x1c>
 304:	0007c683          	lbu	a3,0(a5)
 308:	ca91                	beqz	a3,31c <strstr+0x46>
 30a:	fee691e3          	bne	a3,a4,2ec <strstr+0x16>
      h++;
 30e:	0605                	addi	a2,a2,1
      n++;
 310:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 312:	00064703          	lbu	a4,0(a2)
 316:	f77d                	bnez	a4,304 <strstr+0x2e>
 318:	bfd1                	j	2ec <strstr+0x16>
  return 0;
 31a:	4501                	li	a0,0
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <reg>:
.global reg
reg:
 li a7, SYS_reg
 3ca:	48d9                	li	a7,22
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f66080e7          	jalr	-154(ra) # 34a <write>
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	0080                	addi	s0,sp,64
 3fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 400:	c299                	beqz	a3,406 <printint+0x12>
 402:	0805cb63          	bltz	a1,498 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 406:	2581                	sext.w	a1,a1
  neg = 0;
 408:	4881                	li	a7,0
 40a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 410:	2601                	sext.w	a2,a2
 412:	00000517          	auipc	a0,0x0
 416:	4fe50513          	addi	a0,a0,1278 # 910 <digits>
 41a:	883a                	mv	a6,a4
 41c:	2705                	addiw	a4,a4,1
 41e:	02c5f7bb          	remuw	a5,a1,a2
 422:	1782                	slli	a5,a5,0x20
 424:	9381                	srli	a5,a5,0x20
 426:	97aa                	add	a5,a5,a0
 428:	0007c783          	lbu	a5,0(a5)
 42c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 430:	0005879b          	sext.w	a5,a1
 434:	02c5d5bb          	divuw	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fec7f0e3          	bgeu	a5,a2,41a <printint+0x26>
  if (neg) buf[i++] = '-';
 43e:	00088c63          	beqz	a7,456 <printint+0x62>
 442:	fd070793          	addi	a5,a4,-48
 446:	00878733          	add	a4,a5,s0
 44a:	02d00793          	li	a5,45
 44e:	fef70823          	sb	a5,-16(a4)
 452:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 456:	02e05c63          	blez	a4,48e <printint+0x9a>
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	fc040793          	addi	a5,s0,-64
 462:	00e78933          	add	s2,a5,a4
 466:	fff78993          	addi	s3,a5,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	377d                	addiw	a4,a4,-1
 46e:	1702                	slli	a4,a4,0x20
 470:	9301                	srli	a4,a4,0x20
 472:	40e989b3          	sub	s3,s3,a4
 476:	fff94583          	lbu	a1,-1(s2)
 47a:	8526                	mv	a0,s1
 47c:	00000097          	auipc	ra,0x0
 480:	f56080e7          	jalr	-170(ra) # 3d2 <putc>
 484:	197d                	addi	s2,s2,-1
 486:	ff3918e3          	bne	s2,s3,476 <printint+0x82>
 48a:	7902                	ld	s2,32(sp)
 48c:	69e2                	ld	s3,24(sp)
}
 48e:	70e2                	ld	ra,56(sp)
 490:	7442                	ld	s0,48(sp)
 492:	74a2                	ld	s1,40(sp)
 494:	6121                	addi	sp,sp,64
 496:	8082                	ret
    x = -xx;
 498:	40b005bb          	negw	a1,a1
    neg = 1;
 49c:	4885                	li	a7,1
    x = -xx;
 49e:	b7b5                	j	40a <printint+0x16>

00000000000004a0 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 4a0:	715d                	addi	sp,sp,-80
 4a2:	e486                	sd	ra,72(sp)
 4a4:	e0a2                	sd	s0,64(sp)
 4a6:	f84a                	sd	s2,48(sp)
 4a8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4aa:	0005c903          	lbu	s2,0(a1)
 4ae:	1a090a63          	beqz	s2,662 <vprintf+0x1c2>
 4b2:	fc26                	sd	s1,56(sp)
 4b4:	f44e                	sd	s3,40(sp)
 4b6:	f052                	sd	s4,32(sp)
 4b8:	ec56                	sd	s5,24(sp)
 4ba:	e85a                	sd	s6,16(sp)
 4bc:	e45e                	sd	s7,8(sp)
 4be:	8aaa                	mv	s5,a0
 4c0:	8bb2                	mv	s7,a2
 4c2:	00158493          	addi	s1,a1,1
  state = 0;
 4c6:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 4c8:	02500a13          	li	s4,37
 4cc:	4b55                	li	s6,21
 4ce:	a839                	j	4ec <vprintf+0x4c>
        putc(fd, c);
 4d0:	85ca                	mv	a1,s2
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	efe080e7          	jalr	-258(ra) # 3d2 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x42>
    } else if (state == '%') {
 4de:	01498d63          	beq	s3,s4,4f8 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 4e2:	0485                	addi	s1,s1,1
 4e4:	fff4c903          	lbu	s2,-1(s1)
 4e8:	16090763          	beqz	s2,656 <vprintf+0x1b6>
    if (state == 0) {
 4ec:	fe0999e3          	bnez	s3,4de <vprintf+0x3e>
      if (c == '%') {
 4f0:	ff4910e3          	bne	s2,s4,4d0 <vprintf+0x30>
        state = '%';
 4f4:	89d2                	mv	s3,s4
 4f6:	b7f5                	j	4e2 <vprintf+0x42>
      if (c == 'd') {
 4f8:	13490463          	beq	s2,s4,620 <vprintf+0x180>
 4fc:	f9d9079b          	addiw	a5,s2,-99
 500:	0ff7f793          	zext.b	a5,a5
 504:	12fb6763          	bltu	s6,a5,632 <vprintf+0x192>
 508:	f9d9079b          	addiw	a5,s2,-99
 50c:	0ff7f713          	zext.b	a4,a5
 510:	12eb6163          	bltu	s6,a4,632 <vprintf+0x192>
 514:	00271793          	slli	a5,a4,0x2
 518:	00000717          	auipc	a4,0x0
 51c:	3a070713          	addi	a4,a4,928 # 8b8 <loop+0x12>
 520:	97ba                	add	a5,a5,a4
 522:	439c                	lw	a5,0(a5)
 524:	97ba                	add	a5,a5,a4
 526:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 528:	008b8913          	addi	s2,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	ebe080e7          	jalr	-322(ra) # 3f4 <printint>
 53e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 540:	4981                	li	s3,0
 542:	b745                	j	4e2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 544:	008b8913          	addi	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	ea2080e7          	jalr	-350(ra) # 3f4 <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b751                	j	4e2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 560:	008b8913          	addi	s2,s7,8
 564:	4681                	li	a3,0
 566:	4641                	li	a2,16
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e86080e7          	jalr	-378(ra) # 3f4 <printint>
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	b7a5                	j	4e2 <vprintf+0x42>
 57c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 57e:	008b8c13          	addi	s8,s7,8
 582:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 586:	03000593          	li	a1,48
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e46080e7          	jalr	-442(ra) # 3d2 <putc>
  putc(fd, 'x');
 594:	07800593          	li	a1,120
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e38080e7          	jalr	-456(ra) # 3d2 <putc>
 5a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	00000b97          	auipc	s7,0x0
 5a8:	36cb8b93          	addi	s7,s7,876 # 910 <digits>
 5ac:	03c9d793          	srli	a5,s3,0x3c
 5b0:	97de                	add	a5,a5,s7
 5b2:	0007c583          	lbu	a1,0(a5)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e1a080e7          	jalr	-486(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c0:	0992                	slli	s3,s3,0x4
 5c2:	397d                	addiw	s2,s2,-1
 5c4:	fe0914e3          	bnez	s2,5ac <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5c8:	8be2                	mv	s7,s8
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	6c02                	ld	s8,0(sp)
 5ce:	bf11                	j	4e2 <vprintf+0x42>
        s = va_arg(ap, char *);
 5d0:	008b8993          	addi	s3,s7,8
 5d4:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 5d8:	02090163          	beqz	s2,5fa <vprintf+0x15a>
        while (*s != 0) {
 5dc:	00094583          	lbu	a1,0(s2)
 5e0:	c9a5                	beqz	a1,650 <vprintf+0x1b0>
          putc(fd, *s);
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	dee080e7          	jalr	-530(ra) # 3d2 <putc>
          s++;
 5ec:	0905                	addi	s2,s2,1
        while (*s != 0) {
 5ee:	00094583          	lbu	a1,0(s2)
 5f2:	f9e5                	bnez	a1,5e2 <vprintf+0x142>
        s = va_arg(ap, char *);
 5f4:	8bce                	mv	s7,s3
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b5ed                	j	4e2 <vprintf+0x42>
        if (s == 0) s = "(null)";
 5fa:	00000917          	auipc	s2,0x0
 5fe:	2b690913          	addi	s2,s2,694 # 8b0 <loop+0xa>
        while (*s != 0) {
 602:	02800593          	li	a1,40
 606:	bff1                	j	5e2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 608:	008b8913          	addi	s2,s7,8
 60c:	000bc583          	lbu	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	dc0080e7          	jalr	-576(ra) # 3d2 <putc>
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b5d1                	j	4e2 <vprintf+0x42>
        putc(fd, c);
 620:	02500593          	li	a1,37
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dac080e7          	jalr	-596(ra) # 3d2 <putc>
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd4d                	j	4e2 <vprintf+0x42>
        putc(fd, '%');
 632:	02500593          	li	a1,37
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	d9a080e7          	jalr	-614(ra) # 3d2 <putc>
        putc(fd, c);
 640:	85ca                	mv	a1,s2
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	d8e080e7          	jalr	-626(ra) # 3d2 <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd51                	j	4e2 <vprintf+0x42>
        s = va_arg(ap, char *);
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b579                	j	4e2 <vprintf+0x42>
 656:	74e2                	ld	s1,56(sp)
 658:	79a2                	ld	s3,40(sp)
 65a:	7a02                	ld	s4,32(sp)
 65c:	6ae2                	ld	s5,24(sp)
 65e:	6b42                	ld	s6,16(sp)
 660:	6ba2                	ld	s7,8(sp)
    }
  }
}
 662:	60a6                	ld	ra,72(sp)
 664:	6406                	ld	s0,64(sp)
 666:	7942                	ld	s2,48(sp)
 668:	6161                	addi	sp,sp,80
 66a:	8082                	ret

000000000000066c <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 66c:	715d                	addi	sp,sp,-80
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	e010                	sd	a2,0(s0)
 676:	e414                	sd	a3,8(s0)
 678:	e818                	sd	a4,16(s0)
 67a:	ec1c                	sd	a5,24(s0)
 67c:	03043023          	sd	a6,32(s0)
 680:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 684:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 688:	8622                	mv	a2,s0
 68a:	00000097          	auipc	ra,0x0
 68e:	e16080e7          	jalr	-490(ra) # 4a0 <vprintf>
}
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6161                	addi	sp,sp,80
 698:	8082                	ret

000000000000069a <printf>:

void printf(const char *fmt, ...) {
 69a:	711d                	addi	sp,sp,-96
 69c:	ec06                	sd	ra,24(sp)
 69e:	e822                	sd	s0,16(sp)
 6a0:	1000                	addi	s0,sp,32
 6a2:	e40c                	sd	a1,8(s0)
 6a4:	e810                	sd	a2,16(s0)
 6a6:	ec14                	sd	a3,24(s0)
 6a8:	f018                	sd	a4,32(s0)
 6aa:	f41c                	sd	a5,40(s0)
 6ac:	03043823          	sd	a6,48(s0)
 6b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b4:	00840613          	addi	a2,s0,8
 6b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6bc:	85aa                	mv	a1,a0
 6be:	4505                	li	a0,1
 6c0:	00000097          	auipc	ra,0x0
 6c4:	de0080e7          	jalr	-544(ra) # 4a0 <vprintf>
}
 6c8:	60e2                	ld	ra,24(sp)
 6ca:	6442                	ld	s0,16(sp)
 6cc:	6125                	addi	sp,sp,96
 6ce:	8082                	ret

00000000000006d0 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e422                	sd	s0,8(sp)
 6d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 6d6:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	00001797          	auipc	a5,0x1
 6de:	9267b783          	ld	a5,-1754(a5) # 1000 <freep>
 6e2:	a02d                	j	70c <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 6e4:	4618                	lw	a4,8(a2)
 6e6:	9f2d                	addw	a4,a4,a1
 6e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ec:	6398                	ld	a4,0(a5)
 6ee:	6310                	ld	a2,0(a4)
 6f0:	a83d                	j	72e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 6f2:	ff852703          	lw	a4,-8(a0)
 6f6:	9f31                	addw	a4,a4,a2
 6f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6fa:	ff053683          	ld	a3,-16(a0)
 6fe:	a091                	j	742 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 700:	6398                	ld	a4,0(a5)
 702:	00e7e463          	bltu	a5,a4,70a <free+0x3a>
 706:	00e6ea63          	bltu	a3,a4,71a <free+0x4a>
void free(void *ap) {
 70a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	fed7fae3          	bgeu	a5,a3,700 <free+0x30>
 710:	6398                	ld	a4,0(a5)
 712:	00e6e463          	bltu	a3,a4,71a <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 716:	fee7eae3          	bltu	a5,a4,70a <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 71a:	ff852583          	lw	a1,-8(a0)
 71e:	6390                	ld	a2,0(a5)
 720:	02059813          	slli	a6,a1,0x20
 724:	01c85713          	srli	a4,a6,0x1c
 728:	9736                	add	a4,a4,a3
 72a:	fae60de3          	beq	a2,a4,6e4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 72e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 732:	4790                	lw	a2,8(a5)
 734:	02061593          	slli	a1,a2,0x20
 738:	01c5d713          	srli	a4,a1,0x1c
 73c:	973e                	add	a4,a4,a5
 73e:	fae68ae3          	beq	a3,a4,6f2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 742:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 744:	00001717          	auipc	a4,0x1
 748:	8af73e23          	sd	a5,-1860(a4) # 1000 <freep>
}
 74c:	6422                	ld	s0,8(sp)
 74e:	0141                	addi	sp,sp,16
 750:	8082                	ret

0000000000000752 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 752:	7139                	addi	sp,sp,-64
 754:	fc06                	sd	ra,56(sp)
 756:	f822                	sd	s0,48(sp)
 758:	f426                	sd	s1,40(sp)
 75a:	ec4e                	sd	s3,24(sp)
 75c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 75e:	02051493          	slli	s1,a0,0x20
 762:	9081                	srli	s1,s1,0x20
 764:	04bd                	addi	s1,s1,15
 766:	8091                	srli	s1,s1,0x4
 768:	0014899b          	addiw	s3,s1,1
 76c:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 76e:	00001517          	auipc	a0,0x1
 772:	89253503          	ld	a0,-1902(a0) # 1000 <freep>
 776:	c915                	beqz	a0,7aa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 778:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 77a:	4798                	lw	a4,8(a5)
 77c:	08977e63          	bgeu	a4,s1,818 <malloc+0xc6>
 780:	f04a                	sd	s2,32(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 788:	8a4e                	mv	s4,s3
 78a:	0009871b          	sext.w	a4,s3
 78e:	6685                	lui	a3,0x1
 790:	00d77363          	bgeu	a4,a3,796 <malloc+0x44>
 794:	6a05                	lui	s4,0x1
 796:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 79a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 79e:	00001917          	auipc	s2,0x1
 7a2:	86290913          	addi	s2,s2,-1950 # 1000 <freep>
  if (p == (char *)-1) return 0;
 7a6:	5afd                	li	s5,-1
 7a8:	a091                	j	7ec <malloc+0x9a>
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7b2:	00001797          	auipc	a5,0x1
 7b6:	85e78793          	addi	a5,a5,-1954 # 1010 <base>
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
 7c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 7c8:	b7c1                	j	788 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	e118                	sd	a4,0(a0)
 7ce:	a08d                	j	830 <malloc+0xde>
  hp->s.size = nu;
 7d0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 7d4:	0541                	addi	a0,a0,16
 7d6:	00000097          	auipc	ra,0x0
 7da:	efa080e7          	jalr	-262(ra) # 6d0 <free>
  return freep;
 7de:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 7e2:	c13d                	beqz	a0,848 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7e4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 7e6:	4798                	lw	a4,8(a5)
 7e8:	02977463          	bgeu	a4,s1,810 <malloc+0xbe>
    if (p == freep)
 7ec:	00093703          	ld	a4,0(s2)
 7f0:	853e                	mv	a0,a5
 7f2:	fef719e3          	bne	a4,a5,7e4 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7f6:	8552                	mv	a0,s4
 7f8:	00000097          	auipc	ra,0x0
 7fc:	bba080e7          	jalr	-1094(ra) # 3b2 <sbrk>
  if (p == (char *)-1) return 0;
 800:	fd5518e3          	bne	a0,s5,7d0 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 804:	4501                	li	a0,0
 806:	7902                	ld	s2,32(sp)
 808:	6a42                	ld	s4,16(sp)
 80a:	6aa2                	ld	s5,8(sp)
 80c:	6b02                	ld	s6,0(sp)
 80e:	a03d                	j	83c <malloc+0xea>
 810:	7902                	ld	s2,32(sp)
 812:	6a42                	ld	s4,16(sp)
 814:	6aa2                	ld	s5,8(sp)
 816:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 818:	fae489e3          	beq	s1,a4,7ca <malloc+0x78>
        p->s.size -= nunits;
 81c:	4137073b          	subw	a4,a4,s3
 820:	c798                	sw	a4,8(a5)
        p += p->s.size;
 822:	02071693          	slli	a3,a4,0x20
 826:	01c6d713          	srli	a4,a3,0x1c
 82a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 830:	00000717          	auipc	a4,0x0
 834:	7ca73823          	sd	a0,2000(a4) # 1000 <freep>
      return (void *)(p + 1);
 838:	01078513          	addi	a0,a5,16
  }
}
 83c:	70e2                	ld	ra,56(sp)
 83e:	7442                	ld	s0,48(sp)
 840:	74a2                	ld	s1,40(sp)
 842:	69e2                	ld	s3,24(sp)
 844:	6121                	addi	sp,sp,64
 846:	8082                	ret
 848:	7902                	ld	s2,32(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
 850:	b7f5                	j	83c <malloc+0xea>

0000000000000852 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 852:	4909                	li	s2,2
  li s3, 3
 854:	498d                	li	s3,3
  li s4, 4
 856:	4a11                	li	s4,4
  li s5, 5
 858:	4a95                	li	s5,5
  li s6, 6
 85a:	4b19                	li	s6,6
  li s7, 7
 85c:	4b9d                	li	s7,7
  li s8, 8
 85e:	4c21                	li	s8,8
  li s9, 9
 860:	4ca5                	li	s9,9
  li s10, 10
 862:	4d29                	li	s10,10
  li s11, 11
 864:	4dad                	li	s11,11
  li a7, SYS_write
 866:	48c1                	li	a7,16
  ecall
 868:	00000073          	ecall
  j loop
 86c:	a82d                	j	8a6 <loop>

000000000000086e <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 86e:	4911                	li	s2,4
  li s3, 9
 870:	49a5                	li	s3,9
  li s4, 16
 872:	4a41                	li	s4,16
  li s5, 25
 874:	4ae5                	li	s5,25
  li s6, 36
 876:	02400b13          	li	s6,36
  li s7, 49
 87a:	03100b93          	li	s7,49
  li s8, 64
 87e:	04000c13          	li	s8,64
  li s9, 81
 882:	05100c93          	li	s9,81
  li s10, 100
 886:	06400d13          	li	s10,100
  li s11, 121
 88a:	07900d93          	li	s11,121
  li a7, SYS_write
 88e:	48c1                	li	a7,16
  ecall
 890:	00000073          	ecall
  j loop
 894:	a809                	j	8a6 <loop>

0000000000000896 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 896:	53900913          	li	s2,1337
  mv a2, a1
 89a:	862e                	mv	a2,a1
  li a1, 2
 89c:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 89e:	48d9                	li	a7,22
  ecall
 8a0:	00000073          	ecall
#endif
  ret
 8a4:	8082                	ret

00000000000008a6 <loop>:

loop:
  j loop
 8a6:	a001                	j	8a6 <loop>
  ret
 8a8:	8082                	ret
