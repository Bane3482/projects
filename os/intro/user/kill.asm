
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(int argc, char **argv) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for (i = 1; i < argc; i++) kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1cc080e7          	jalr	460(ra) # 1f4 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	368080e7          	jalr	872(ra) # 398 <kill>
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	328080e7          	jalr	808(ra) # 368 <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	8a458593          	addi	a1,a1,-1884 # 8f0 <loop+0xc>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	654080e7          	jalr	1620(ra) # 6aa <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	308080e7          	jalr	776(ra) # 368 <exit>

0000000000000068 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <main>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	2ee080e7          	jalr	750(ra) # 368 <exit>

0000000000000082 <strcpy>:
}

char *strcpy(char *s, const char *t) {
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int strcmp(const char *p, const char *q) {
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint strlen(const char *s) {
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for (n = 0; s[n]; n++);
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void *memset(void *dst, int c, uint n) {
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char *strchr(const char *s, char c) {
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  for (; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if (*s == c) return (char *)s;
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for (; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char *gets(char *buf, int max) {
 13a:	711d                	addi	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addiw	s1,s1,1
 160:	0344d863          	bge	s1,s4,190 <gets+0x56>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	addi	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	214080e7          	jalr	532(ra) # 380 <read>
    if (cc < 1) break;
 174:	00a05e63          	blez	a0,190 <gets+0x56>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 180:	01578763          	beq	a5,s5,18e <gets+0x54>
 184:	0905                	addi	s2,s2,1
 186:	fd679be3          	bne	a5,s6,15c <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x56>
 18e:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int stat(const char *n, struct stat *st) {
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	1ec080e7          	jalr	492(ra) # 3a8 <open>
  if (fd < 0) return -1;
 1c4:	02054663          	bltz	a0,1f0 <stat+0x42>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	1f2080e7          	jalr	498(ra) # 3c0 <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	00000097          	auipc	ra,0x0
 1de:	1b6080e7          	jalr	438(ra) # 390 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
  if (fd < 0) return -1;
 1f0:	597d                	li	s2,-1
 1f2:	bfcd                	j	1e4 <stat+0x36>

00000000000001f4 <atoi>:

int atoi(const char *s) {
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 1fa:	00054683          	lbu	a3,0(a0)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	4625                	li	a2,9
 208:	02f66863          	bltu	a2,a5,238 <atoi+0x44>
 20c:	872a                	mv	a4,a0
  n = 0;
 20e:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 210:	0705                	addi	a4,a4,1
 212:	0025179b          	slliw	a5,a0,0x2
 216:	9fa9                	addw	a5,a5,a0
 218:	0017979b          	slliw	a5,a5,0x1
 21c:	9fb5                	addw	a5,a5,a3
 21e:	fd07851b          	addiw	a0,a5,-48
 222:	00074683          	lbu	a3,0(a4)
 226:	fd06879b          	addiw	a5,a3,-48
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	fef671e3          	bgeu	a2,a5,210 <atoi+0x1c>
  return n;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  n = 0;
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <atoi+0x3e>

000000000000023c <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57463          	bgeu	a0,a1,26a <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 246:	00c05f63          	blez	a2,264 <memmove+0x28>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
 260:	fef71ae3          	bne	a4,a5,254 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
    dst += n;
 26a:	00c50733          	add	a4,a0,a2
    src += n;
 26e:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 270:	fec05ae3          	blez	a2,264 <memmove+0x28>
 274:	fff6079b          	addiw	a5,a2,-1
 278:	1782                	slli	a5,a5,0x20
 27a:	9381                	srli	a5,a5,0x20
 27c:	fff7c793          	not	a5,a5
 280:	97ba                	add	a5,a5,a4
 282:	15fd                	addi	a1,a1,-1
 284:	177d                	addi	a4,a4,-1
 286:	0005c683          	lbu	a3,0(a1)
 28a:	00d70023          	sb	a3,0(a4)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x46>
 292:	bfc9                	j	264 <memmove+0x28>

0000000000000294 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	ca05                	beqz	a2,2ca <memcmp+0x36>
 29c:	fff6069b          	addiw	a3,a2,-1
 2a0:	1682                	slli	a3,a3,0x20
 2a2:	9281                	srli	a3,a3,0x20
 2a4:	0685                	addi	a3,a3,1
 2a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	0005c703          	lbu	a4,0(a1)
 2b0:	00e79863          	bne	a5,a4,2c0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b4:	0505                	addi	a0,a0,1
    p2++;
 2b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b8:	fed518e3          	bne	a0,a3,2a8 <memcmp+0x14>
  }
  return 0;
 2bc:	4501                	li	a0,0
 2be:	a019                	j	2c4 <memcmp+0x30>
      return *p1 - *p2;
 2c0:	40e7853b          	subw	a0,a5,a4
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <memcmp+0x30>

00000000000002ce <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d6:	00000097          	auipc	ra,0x0
 2da:	f66080e7          	jalr	-154(ra) # 23c <memmove>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strcat>:

char *strcat(char *dst, const char *src) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	c385                	beqz	a5,310 <strcat+0x2a>
  char *p = dst;
 2f2:	87aa                	mv	a5,a0
  while (*p) p++;
 2f4:	0785                	addi	a5,a5,1
 2f6:	0007c703          	lbu	a4,0(a5)
 2fa:	ff6d                	bnez	a4,2f4 <strcat+0xe>
  while ((*p++ = *src++));
 2fc:	0585                	addi	a1,a1,1
 2fe:	0785                	addi	a5,a5,1
 300:	fff5c703          	lbu	a4,-1(a1)
 304:	fee78fa3          	sb	a4,-1(a5)
 308:	fb75                	bnez	a4,2fc <strcat+0x16>
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  char *p = dst;
 310:	87aa                	mv	a5,a0
 312:	b7ed                	j	2fc <strcat+0x16>

0000000000000314 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 31a:	0005c783          	lbu	a5,0(a1)
 31e:	cf95                	beqz	a5,35a <strstr+0x46>

  for (; *haystack; haystack++) {
 320:	00054783          	lbu	a5,0(a0)
 324:	eb91                	bnez	a5,338 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 326:	4501                	li	a0,0
 328:	a80d                	j	35a <strstr+0x46>
    if (!*n) return (char *)haystack;
 32a:	0007c783          	lbu	a5,0(a5)
 32e:	c795                	beqz	a5,35a <strstr+0x46>
  for (; *haystack; haystack++) {
 330:	0505                	addi	a0,a0,1
 332:	00054783          	lbu	a5,0(a0)
 336:	c38d                	beqz	a5,358 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 338:	00054703          	lbu	a4,0(a0)
    n = needle;
 33c:	87ae                	mv	a5,a1
    h = haystack;
 33e:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 340:	db65                	beqz	a4,330 <strstr+0x1c>
 342:	0007c683          	lbu	a3,0(a5)
 346:	ca91                	beqz	a3,35a <strstr+0x46>
 348:	fee691e3          	bne	a3,a4,32a <strstr+0x16>
      h++;
 34c:	0605                	addi	a2,a2,1
      n++;
 34e:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 350:	00064703          	lbu	a4,0(a2)
 354:	f77d                	bnez	a4,342 <strstr+0x2e>
 356:	bfd1                	j	32a <strstr+0x16>
  return 0;
 358:	4501                	li	a0,0
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 360:	4885                	li	a7,1
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exit>:
.global exit
exit:
 li a7, SYS_exit
 368:	4889                	li	a7,2
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <wait>:
.global wait
wait:
 li a7, SYS_wait
 370:	488d                	li	a7,3
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 378:	4891                	li	a7,4
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <read>:
.global read
read:
 li a7, SYS_read
 380:	4895                	li	a7,5
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <write>:
.global write
write:
 li a7, SYS_write
 388:	48c1                	li	a7,16
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <close>:
.global close
close:
 li a7, SYS_close
 390:	48d5                	li	a7,21
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <kill>:
.global kill
kill:
 li a7, SYS_kill
 398:	4899                	li	a7,6
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a0:	489d                	li	a7,7
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <open>:
.global open
open:
 li a7, SYS_open
 3a8:	48bd                	li	a7,15
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b0:	48c5                	li	a7,17
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b8:	48c9                	li	a7,18
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c0:	48a1                	li	a7,8
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <link>:
.global link
link:
 li a7, SYS_link
 3c8:	48cd                	li	a7,19
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d0:	48d1                	li	a7,20
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d8:	48a5                	li	a7,9
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e0:	48a9                	li	a7,10
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e8:	48ad                	li	a7,11
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f0:	48b1                	li	a7,12
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f8:	48b5                	li	a7,13
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 400:	48b9                	li	a7,14
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <reg>:
.global reg
reg:
 li a7, SYS_reg
 408:	48d9                	li	a7,22
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 410:	1101                	addi	sp,sp,-32
 412:	ec06                	sd	ra,24(sp)
 414:	e822                	sd	s0,16(sp)
 416:	1000                	addi	s0,sp,32
 418:	feb407a3          	sb	a1,-17(s0)
 41c:	4605                	li	a2,1
 41e:	fef40593          	addi	a1,s0,-17
 422:	00000097          	auipc	ra,0x0
 426:	f66080e7          	jalr	-154(ra) # 388 <write>
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret

0000000000000432 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 432:	7139                	addi	sp,sp,-64
 434:	fc06                	sd	ra,56(sp)
 436:	f822                	sd	s0,48(sp)
 438:	f426                	sd	s1,40(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 43e:	c299                	beqz	a3,444 <printint+0x12>
 440:	0805cb63          	bltz	a1,4d6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 444:	2581                	sext.w	a1,a1
  neg = 0;
 446:	4881                	li	a7,0
 448:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 44e:	2601                	sext.w	a2,a2
 450:	00000517          	auipc	a0,0x0
 454:	51850513          	addi	a0,a0,1304 # 968 <digits>
 458:	883a                	mv	a6,a4
 45a:	2705                	addiw	a4,a4,1
 45c:	02c5f7bb          	remuw	a5,a1,a2
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	97aa                	add	a5,a5,a0
 466:	0007c783          	lbu	a5,0(a5)
 46a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 46e:	0005879b          	sext.w	a5,a1
 472:	02c5d5bb          	divuw	a1,a1,a2
 476:	0685                	addi	a3,a3,1
 478:	fec7f0e3          	bgeu	a5,a2,458 <printint+0x26>
  if (neg) buf[i++] = '-';
 47c:	00088c63          	beqz	a7,494 <printint+0x62>
 480:	fd070793          	addi	a5,a4,-48
 484:	00878733          	add	a4,a5,s0
 488:	02d00793          	li	a5,45
 48c:	fef70823          	sb	a5,-16(a4)
 490:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 494:	02e05c63          	blez	a4,4cc <printint+0x9a>
 498:	f04a                	sd	s2,32(sp)
 49a:	ec4e                	sd	s3,24(sp)
 49c:	fc040793          	addi	a5,s0,-64
 4a0:	00e78933          	add	s2,a5,a4
 4a4:	fff78993          	addi	s3,a5,-1
 4a8:	99ba                	add	s3,s3,a4
 4aa:	377d                	addiw	a4,a4,-1
 4ac:	1702                	slli	a4,a4,0x20
 4ae:	9301                	srli	a4,a4,0x20
 4b0:	40e989b3          	sub	s3,s3,a4
 4b4:	fff94583          	lbu	a1,-1(s2)
 4b8:	8526                	mv	a0,s1
 4ba:	00000097          	auipc	ra,0x0
 4be:	f56080e7          	jalr	-170(ra) # 410 <putc>
 4c2:	197d                	addi	s2,s2,-1
 4c4:	ff3918e3          	bne	s2,s3,4b4 <printint+0x82>
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
}
 4cc:	70e2                	ld	ra,56(sp)
 4ce:	7442                	ld	s0,48(sp)
 4d0:	74a2                	ld	s1,40(sp)
 4d2:	6121                	addi	sp,sp,64
 4d4:	8082                	ret
    x = -xx;
 4d6:	40b005bb          	negw	a1,a1
    neg = 1;
 4da:	4885                	li	a7,1
    x = -xx;
 4dc:	b7b5                	j	448 <printint+0x16>

00000000000004de <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 4de:	715d                	addi	sp,sp,-80
 4e0:	e486                	sd	ra,72(sp)
 4e2:	e0a2                	sd	s0,64(sp)
 4e4:	f84a                	sd	s2,48(sp)
 4e6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4e8:	0005c903          	lbu	s2,0(a1)
 4ec:	1a090a63          	beqz	s2,6a0 <vprintf+0x1c2>
 4f0:	fc26                	sd	s1,56(sp)
 4f2:	f44e                	sd	s3,40(sp)
 4f4:	f052                	sd	s4,32(sp)
 4f6:	ec56                	sd	s5,24(sp)
 4f8:	e85a                	sd	s6,16(sp)
 4fa:	e45e                	sd	s7,8(sp)
 4fc:	8aaa                	mv	s5,a0
 4fe:	8bb2                	mv	s7,a2
 500:	00158493          	addi	s1,a1,1
  state = 0;
 504:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 506:	02500a13          	li	s4,37
 50a:	4b55                	li	s6,21
 50c:	a839                	j	52a <vprintf+0x4c>
        putc(fd, c);
 50e:	85ca                	mv	a1,s2
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	efe080e7          	jalr	-258(ra) # 410 <putc>
 51a:	a019                	j	520 <vprintf+0x42>
    } else if (state == '%') {
 51c:	01498d63          	beq	s3,s4,536 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 520:	0485                	addi	s1,s1,1
 522:	fff4c903          	lbu	s2,-1(s1)
 526:	16090763          	beqz	s2,694 <vprintf+0x1b6>
    if (state == 0) {
 52a:	fe0999e3          	bnez	s3,51c <vprintf+0x3e>
      if (c == '%') {
 52e:	ff4910e3          	bne	s2,s4,50e <vprintf+0x30>
        state = '%';
 532:	89d2                	mv	s3,s4
 534:	b7f5                	j	520 <vprintf+0x42>
      if (c == 'd') {
 536:	13490463          	beq	s2,s4,65e <vprintf+0x180>
 53a:	f9d9079b          	addiw	a5,s2,-99
 53e:	0ff7f793          	zext.b	a5,a5
 542:	12fb6763          	bltu	s6,a5,670 <vprintf+0x192>
 546:	f9d9079b          	addiw	a5,s2,-99
 54a:	0ff7f713          	zext.b	a4,a5
 54e:	12eb6163          	bltu	s6,a4,670 <vprintf+0x192>
 552:	00271793          	slli	a5,a4,0x2
 556:	00000717          	auipc	a4,0x0
 55a:	3ba70713          	addi	a4,a4,954 # 910 <loop+0x2c>
 55e:	97ba                	add	a5,a5,a4
 560:	439c                	lw	a5,0(a5)
 562:	97ba                	add	a5,a5,a4
 564:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 566:	008b8913          	addi	s2,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	ebe080e7          	jalr	-322(ra) # 432 <printint>
 57c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 57e:	4981                	li	s3,0
 580:	b745                	j	520 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	008b8913          	addi	s2,s7,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000ba583          	lw	a1,0(s7)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	ea2080e7          	jalr	-350(ra) # 432 <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b751                	j	520 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e86080e7          	jalr	-378(ra) # 432 <printint>
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b7a5                	j	520 <vprintf+0x42>
 5ba:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5bc:	008b8c13          	addi	s8,s7,8
 5c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c4:	03000593          	li	a1,48
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e46080e7          	jalr	-442(ra) # 410 <putc>
  putc(fd, 'x');
 5d2:	07800593          	li	a1,120
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e38080e7          	jalr	-456(ra) # 410 <putc>
 5e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	00000b97          	auipc	s7,0x0
 5e6:	386b8b93          	addi	s7,s7,902 # 968 <digits>
 5ea:	03c9d793          	srli	a5,s3,0x3c
 5ee:	97de                	add	a5,a5,s7
 5f0:	0007c583          	lbu	a1,0(a5)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e1a080e7          	jalr	-486(ra) # 410 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fe:	0992                	slli	s3,s3,0x4
 600:	397d                	addiw	s2,s2,-1
 602:	fe0914e3          	bnez	s2,5ea <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 606:	8be2                	mv	s7,s8
      state = 0;
 608:	4981                	li	s3,0
 60a:	6c02                	ld	s8,0(sp)
 60c:	bf11                	j	520 <vprintf+0x42>
        s = va_arg(ap, char *);
 60e:	008b8993          	addi	s3,s7,8
 612:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 616:	02090163          	beqz	s2,638 <vprintf+0x15a>
        while (*s != 0) {
 61a:	00094583          	lbu	a1,0(s2)
 61e:	c9a5                	beqz	a1,68e <vprintf+0x1b0>
          putc(fd, *s);
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	dee080e7          	jalr	-530(ra) # 410 <putc>
          s++;
 62a:	0905                	addi	s2,s2,1
        while (*s != 0) {
 62c:	00094583          	lbu	a1,0(s2)
 630:	f9e5                	bnez	a1,620 <vprintf+0x142>
        s = va_arg(ap, char *);
 632:	8bce                	mv	s7,s3
      state = 0;
 634:	4981                	li	s3,0
 636:	b5ed                	j	520 <vprintf+0x42>
        if (s == 0) s = "(null)";
 638:	00000917          	auipc	s2,0x0
 63c:	2d090913          	addi	s2,s2,720 # 908 <loop+0x24>
        while (*s != 0) {
 640:	02800593          	li	a1,40
 644:	bff1                	j	620 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 646:	008b8913          	addi	s2,s7,8
 64a:	000bc583          	lbu	a1,0(s7)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	dc0080e7          	jalr	-576(ra) # 410 <putc>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b5d1                	j	520 <vprintf+0x42>
        putc(fd, c);
 65e:	02500593          	li	a1,37
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	dac080e7          	jalr	-596(ra) # 410 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd4d                	j	520 <vprintf+0x42>
        putc(fd, '%');
 670:	02500593          	li	a1,37
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	d9a080e7          	jalr	-614(ra) # 410 <putc>
        putc(fd, c);
 67e:	85ca                	mv	a1,s2
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d8e080e7          	jalr	-626(ra) # 410 <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd51                	j	520 <vprintf+0x42>
        s = va_arg(ap, char *);
 68e:	8bce                	mv	s7,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	b579                	j	520 <vprintf+0x42>
 694:	74e2                	ld	s1,56(sp)
 696:	79a2                	ld	s3,40(sp)
 698:	7a02                	ld	s4,32(sp)
 69a:	6ae2                	ld	s5,24(sp)
 69c:	6b42                	ld	s6,16(sp)
 69e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6a0:	60a6                	ld	ra,72(sp)
 6a2:	6406                	ld	s0,64(sp)
 6a4:	7942                	ld	s2,48(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 6aa:	715d                	addi	sp,sp,-80
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e010                	sd	a2,0(s0)
 6b4:	e414                	sd	a3,8(s0)
 6b6:	e818                	sd	a4,16(s0)
 6b8:	ec1c                	sd	a5,24(s0)
 6ba:	03043023          	sd	a6,32(s0)
 6be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c6:	8622                	mv	a2,s0
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e16080e7          	jalr	-490(ra) # 4de <vprintf>
}
 6d0:	60e2                	ld	ra,24(sp)
 6d2:	6442                	ld	s0,16(sp)
 6d4:	6161                	addi	sp,sp,80
 6d6:	8082                	ret

00000000000006d8 <printf>:

void printf(const char *fmt, ...) {
 6d8:	711d                	addi	sp,sp,-96
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e40c                	sd	a1,8(s0)
 6e2:	e810                	sd	a2,16(s0)
 6e4:	ec14                	sd	a3,24(s0)
 6e6:	f018                	sd	a4,32(s0)
 6e8:	f41c                	sd	a5,40(s0)
 6ea:	03043823          	sd	a6,48(s0)
 6ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f2:	00840613          	addi	a2,s0,8
 6f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fa:	85aa                	mv	a1,a0
 6fc:	4505                	li	a0,1
 6fe:	00000097          	auipc	ra,0x0
 702:	de0080e7          	jalr	-544(ra) # 4de <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret

000000000000070e <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 70e:	1141                	addi	sp,sp,-16
 710:	e422                	sd	s0,8(sp)
 712:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 714:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	00001797          	auipc	a5,0x1
 71c:	8e87b783          	ld	a5,-1816(a5) # 1000 <freep>
 720:	a02d                	j	74a <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 722:	4618                	lw	a4,8(a2)
 724:	9f2d                	addw	a4,a4,a1
 726:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72a:	6398                	ld	a4,0(a5)
 72c:	6310                	ld	a2,0(a4)
 72e:	a83d                	j	76c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 730:	ff852703          	lw	a4,-8(a0)
 734:	9f31                	addw	a4,a4,a2
 736:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 738:	ff053683          	ld	a3,-16(a0)
 73c:	a091                	j	780 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 73e:	6398                	ld	a4,0(a5)
 740:	00e7e463          	bltu	a5,a4,748 <free+0x3a>
 744:	00e6ea63          	bltu	a3,a4,758 <free+0x4a>
void free(void *ap) {
 748:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	fed7fae3          	bgeu	a5,a3,73e <free+0x30>
 74e:	6398                	ld	a4,0(a5)
 750:	00e6e463          	bltu	a3,a4,758 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 754:	fee7eae3          	bltu	a5,a4,748 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 758:	ff852583          	lw	a1,-8(a0)
 75c:	6390                	ld	a2,0(a5)
 75e:	02059813          	slli	a6,a1,0x20
 762:	01c85713          	srli	a4,a6,0x1c
 766:	9736                	add	a4,a4,a3
 768:	fae60de3          	beq	a2,a4,722 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 770:	4790                	lw	a2,8(a5)
 772:	02061593          	slli	a1,a2,0x20
 776:	01c5d713          	srli	a4,a1,0x1c
 77a:	973e                	add	a4,a4,a5
 77c:	fae68ae3          	beq	a3,a4,730 <free+0x22>
    p->s.ptr = bp->s.ptr;
 780:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 782:	00001717          	auipc	a4,0x1
 786:	86f73f23          	sd	a5,-1922(a4) # 1000 <freep>
}
 78a:	6422                	ld	s0,8(sp)
 78c:	0141                	addi	sp,sp,16
 78e:	8082                	ret

0000000000000790 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 790:	7139                	addi	sp,sp,-64
 792:	fc06                	sd	ra,56(sp)
 794:	f822                	sd	s0,48(sp)
 796:	f426                	sd	s1,40(sp)
 798:	ec4e                	sd	s3,24(sp)
 79a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 79c:	02051493          	slli	s1,a0,0x20
 7a0:	9081                	srli	s1,s1,0x20
 7a2:	04bd                	addi	s1,s1,15
 7a4:	8091                	srli	s1,s1,0x4
 7a6:	0014899b          	addiw	s3,s1,1
 7aa:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 7ac:	00001517          	auipc	a0,0x1
 7b0:	85453503          	ld	a0,-1964(a0) # 1000 <freep>
 7b4:	c915                	beqz	a0,7e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7b6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 7b8:	4798                	lw	a4,8(a5)
 7ba:	08977e63          	bgeu	a4,s1,856 <malloc+0xc6>
 7be:	f04a                	sd	s2,32(sp)
 7c0:	e852                	sd	s4,16(sp)
 7c2:	e456                	sd	s5,8(sp)
 7c4:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 7c6:	8a4e                	mv	s4,s3
 7c8:	0009871b          	sext.w	a4,s3
 7cc:	6685                	lui	a3,0x1
 7ce:	00d77363          	bgeu	a4,a3,7d4 <malloc+0x44>
 7d2:	6a05                	lui	s4,0x1
 7d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 7dc:	00001917          	auipc	s2,0x1
 7e0:	82490913          	addi	s2,s2,-2012 # 1000 <freep>
  if (p == (char *)-1) return 0;
 7e4:	5afd                	li	s5,-1
 7e6:	a091                	j	82a <malloc+0x9a>
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7f0:	00001797          	auipc	a5,0x1
 7f4:	82078793          	addi	a5,a5,-2016 # 1010 <base>
 7f8:	00001717          	auipc	a4,0x1
 7fc:	80f73423          	sd	a5,-2040(a4) # 1000 <freep>
 800:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 802:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 806:	b7c1                	j	7c6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	e118                	sd	a4,0(a0)
 80c:	a08d                	j	86e <malloc+0xde>
  hp->s.size = nu;
 80e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 812:	0541                	addi	a0,a0,16
 814:	00000097          	auipc	ra,0x0
 818:	efa080e7          	jalr	-262(ra) # 70e <free>
  return freep;
 81c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 820:	c13d                	beqz	a0,886 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 822:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 824:	4798                	lw	a4,8(a5)
 826:	02977463          	bgeu	a4,s1,84e <malloc+0xbe>
    if (p == freep)
 82a:	00093703          	ld	a4,0(s2)
 82e:	853e                	mv	a0,a5
 830:	fef719e3          	bne	a4,a5,822 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 834:	8552                	mv	a0,s4
 836:	00000097          	auipc	ra,0x0
 83a:	bba080e7          	jalr	-1094(ra) # 3f0 <sbrk>
  if (p == (char *)-1) return 0;
 83e:	fd5518e3          	bne	a0,s5,80e <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 842:	4501                	li	a0,0
 844:	7902                	ld	s2,32(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	a03d                	j	87a <malloc+0xea>
 84e:	7902                	ld	s2,32(sp)
 850:	6a42                	ld	s4,16(sp)
 852:	6aa2                	ld	s5,8(sp)
 854:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 856:	fae489e3          	beq	s1,a4,808 <malloc+0x78>
        p->s.size -= nunits;
 85a:	4137073b          	subw	a4,a4,s3
 85e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 860:	02071693          	slli	a3,a4,0x20
 864:	01c6d713          	srli	a4,a3,0x1c
 868:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86e:	00000717          	auipc	a4,0x0
 872:	78a73923          	sd	a0,1938(a4) # 1000 <freep>
      return (void *)(p + 1);
 876:	01078513          	addi	a0,a5,16
  }
}
 87a:	70e2                	ld	ra,56(sp)
 87c:	7442                	ld	s0,48(sp)
 87e:	74a2                	ld	s1,40(sp)
 880:	69e2                	ld	s3,24(sp)
 882:	6121                	addi	sp,sp,64
 884:	8082                	ret
 886:	7902                	ld	s2,32(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	b7f5                	j	87a <malloc+0xea>

0000000000000890 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 890:	4909                	li	s2,2
  li s3, 3
 892:	498d                	li	s3,3
  li s4, 4
 894:	4a11                	li	s4,4
  li s5, 5
 896:	4a95                	li	s5,5
  li s6, 6
 898:	4b19                	li	s6,6
  li s7, 7
 89a:	4b9d                	li	s7,7
  li s8, 8
 89c:	4c21                	li	s8,8
  li s9, 9
 89e:	4ca5                	li	s9,9
  li s10, 10
 8a0:	4d29                	li	s10,10
  li s11, 11
 8a2:	4dad                	li	s11,11
  li a7, SYS_write
 8a4:	48c1                	li	a7,16
  ecall
 8a6:	00000073          	ecall
  j loop
 8aa:	a82d                	j	8e4 <loop>

00000000000008ac <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 8ac:	4911                	li	s2,4
  li s3, 9
 8ae:	49a5                	li	s3,9
  li s4, 16
 8b0:	4a41                	li	s4,16
  li s5, 25
 8b2:	4ae5                	li	s5,25
  li s6, 36
 8b4:	02400b13          	li	s6,36
  li s7, 49
 8b8:	03100b93          	li	s7,49
  li s8, 64
 8bc:	04000c13          	li	s8,64
  li s9, 81
 8c0:	05100c93          	li	s9,81
  li s10, 100
 8c4:	06400d13          	li	s10,100
  li s11, 121
 8c8:	07900d93          	li	s11,121
  li a7, SYS_write
 8cc:	48c1                	li	a7,16
  ecall
 8ce:	00000073          	ecall
  j loop
 8d2:	a809                	j	8e4 <loop>

00000000000008d4 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 8d4:	53900913          	li	s2,1337
  mv a2, a1
 8d8:	862e                	mv	a2,a1
  li a1, 2
 8da:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 8dc:	48d9                	li	a7,22
  ecall
 8de:	00000073          	ecall
#endif
  ret
 8e2:	8082                	ret

00000000000008e4 <loop>:

loop:
  j loop
 8e4:	a001                	j	8e4 <loop>
  ret
 8e6:	8082                	ret
