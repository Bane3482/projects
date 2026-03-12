
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if (argc != 3) {
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8e058593          	addi	a1,a1,-1824 # 8f0 <loop+0x12>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	68a080e7          	jalr	1674(ra) # 6a4 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	33e080e7          	jalr	830(ra) # 362 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if (link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	38e080e7          	jalr	910(ra) # 3c2 <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	320080e7          	jalr	800(ra) # 362 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	8ba58593          	addi	a1,a1,-1862 # 908 <loop+0x2a>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	64c080e7          	jalr	1612(ra) # 6a4 <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	2ee080e7          	jalr	750(ra) # 362 <exit>

000000000000007c <strcpy>:
}

char *strcpy(char *s, const char *t) {
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0x8>
  return os;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int strcmp(const char *p, const char *q) {
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x1e>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x1e>
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strlen>:

uint strlen(const char *s) {
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf91                	beqz	a5,ea <strlen+0x26>
  d0:	0505                	addi	a0,a0,1
  d2:	87aa                	mv	a5,a0
  d4:	86be                	mv	a3,a5
  d6:	0785                	addi	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	ff65                	bnez	a4,d4 <strlen+0x10>
  de:	40a6853b          	subw	a0,a3,a0
  e2:	2505                	addiw	a0,a0,1
  return n;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  for (n = 0; s[n]; n++);
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strlen+0x20>

00000000000000ee <memset>:

void *memset(void *dst, int c, uint n) {
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  f4:	ca19                	beqz	a2,10a <memset+0x1c>
  f6:	87aa                	mv	a5,a0
  f8:	1602                	slli	a2,a2,0x20
  fa:	9201                	srli	a2,a2,0x20
  fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x12>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char *strchr(const char *s, char c) {
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  for (; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if (*s == c) return (char *)s;
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for (; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char *gets(char *buf, int max) {
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 156:	89a6                	mv	s3,s1
 158:	2485                	addiw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	addi	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	214080e7          	jalr	532(ra) # 37a <read>
    if (cc < 1) break;
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	addi	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
    buf[i++] = c;
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int stat(const char *n, struct stat *st) {
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	1ec080e7          	jalr	492(ra) # 3a2 <open>
  if (fd < 0) return -1;
 1be:	02054663          	bltz	a0,1ea <stat+0x42>
 1c2:	e426                	sd	s1,8(sp)
 1c4:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	1f2080e7          	jalr	498(ra) # 3ba <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	1b6080e7          	jalr	438(ra) # 38a <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
  if (fd < 0) return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x36>

00000000000001ee <atoi>:

int atoi(const char *s) {
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	00000097          	auipc	ra,0x0
 2d4:	f66080e7          	jalr	-154(ra) # 236 <memmove>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcat>:

char *strcat(char *dst, const char *src) {
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	c385                	beqz	a5,30a <strcat+0x2a>
  char *p = dst;
 2ec:	87aa                	mv	a5,a0
  while (*p) p++;
 2ee:	0785                	addi	a5,a5,1
 2f0:	0007c703          	lbu	a4,0(a5)
 2f4:	ff6d                	bnez	a4,2ee <strcat+0xe>
  while ((*p++ = *src++));
 2f6:	0585                	addi	a1,a1,1
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff5c703          	lbu	a4,-1(a1)
 2fe:	fee78fa3          	sb	a4,-1(a5)
 302:	fb75                	bnez	a4,2f6 <strcat+0x16>
  return dst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  char *p = dst;
 30a:	87aa                	mv	a5,a0
 30c:	b7ed                	j	2f6 <strcat+0x16>

000000000000030e <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 314:	0005c783          	lbu	a5,0(a1)
 318:	cf95                	beqz	a5,354 <strstr+0x46>

  for (; *haystack; haystack++) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	eb91                	bnez	a5,332 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 320:	4501                	li	a0,0
 322:	a80d                	j	354 <strstr+0x46>
    if (!*n) return (char *)haystack;
 324:	0007c783          	lbu	a5,0(a5)
 328:	c795                	beqz	a5,354 <strstr+0x46>
  for (; *haystack; haystack++) {
 32a:	0505                	addi	a0,a0,1
 32c:	00054783          	lbu	a5,0(a0)
 330:	c38d                	beqz	a5,352 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 332:	00054703          	lbu	a4,0(a0)
    n = needle;
 336:	87ae                	mv	a5,a1
    h = haystack;
 338:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 33a:	db65                	beqz	a4,32a <strstr+0x1c>
 33c:	0007c683          	lbu	a3,0(a5)
 340:	ca91                	beqz	a3,354 <strstr+0x46>
 342:	fee691e3          	bne	a3,a4,324 <strstr+0x16>
      h++;
 346:	0605                	addi	a2,a2,1
      n++;
 348:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 34a:	00064703          	lbu	a4,0(a2)
 34e:	f77d                	bnez	a4,33c <strstr+0x2e>
 350:	bfd1                	j	324 <strstr+0x16>
  return 0;
 352:	4501                	li	a0,0
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35a:	4885                	li	a7,1
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exit>:
.global exit
exit:
 li a7, SYS_exit
 362:	4889                	li	a7,2
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <wait>:
.global wait
wait:
 li a7, SYS_wait
 36a:	488d                	li	a7,3
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 372:	4891                	li	a7,4
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <read>:
.global read
read:
 li a7, SYS_read
 37a:	4895                	li	a7,5
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <write>:
.global write
write:
 li a7, SYS_write
 382:	48c1                	li	a7,16
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <close>:
.global close
close:
 li a7, SYS_close
 38a:	48d5                	li	a7,21
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <kill>:
.global kill
kill:
 li a7, SYS_kill
 392:	4899                	li	a7,6
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exec>:
.global exec
exec:
 li a7, SYS_exec
 39a:	489d                	li	a7,7
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <open>:
.global open
open:
 li a7, SYS_open
 3a2:	48bd                	li	a7,15
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3aa:	48c5                	li	a7,17
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b2:	48c9                	li	a7,18
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ba:	48a1                	li	a7,8
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <link>:
.global link
link:
 li a7, SYS_link
 3c2:	48cd                	li	a7,19
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ca:	48d1                	li	a7,20
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d2:	48a5                	li	a7,9
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <dup>:
.global dup
dup:
 li a7, SYS_dup
 3da:	48a9                	li	a7,10
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e2:	48ad                	li	a7,11
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ea:	48b1                	li	a7,12
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f2:	48b5                	li	a7,13
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fa:	48b9                	li	a7,14
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <reg>:
.global reg
reg:
 li a7, SYS_reg
 402:	48d9                	li	a7,22
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	00000097          	auipc	ra,0x0
 420:	f66080e7          	jalr	-154(ra) # 382 <write>
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 42c:	7139                	addi	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	f426                	sd	s1,40(sp)
 434:	0080                	addi	s0,sp,64
 436:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 438:	c299                	beqz	a3,43e <printint+0x12>
 43a:	0805cb63          	bltz	a1,4d0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43e:	2581                	sext.w	a1,a1
  neg = 0;
 440:	4881                	li	a7,0
 442:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 446:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 448:	2601                	sext.w	a2,a2
 44a:	00000517          	auipc	a0,0x0
 44e:	53650513          	addi	a0,a0,1334 # 980 <digits>
 452:	883a                	mv	a6,a4
 454:	2705                	addiw	a4,a4,1
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97aa                	add	a5,a5,a0
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 468:	0005879b          	sext.w	a5,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fec7f0e3          	bgeu	a5,a2,452 <printint+0x26>
  if (neg) buf[i++] = '-';
 476:	00088c63          	beqz	a7,48e <printint+0x62>
 47a:	fd070793          	addi	a5,a4,-48
 47e:	00878733          	add	a4,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef70823          	sb	a5,-16(a4)
 48a:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 48e:	02e05c63          	blez	a4,4c6 <printint+0x9a>
 492:	f04a                	sd	s2,32(sp)
 494:	ec4e                	sd	s3,24(sp)
 496:	fc040793          	addi	a5,s0,-64
 49a:	00e78933          	add	s2,a5,a4
 49e:	fff78993          	addi	s3,a5,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	377d                	addiw	a4,a4,-1
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
 4ae:	fff94583          	lbu	a1,-1(s2)
 4b2:	8526                	mv	a0,s1
 4b4:	00000097          	auipc	ra,0x0
 4b8:	f56080e7          	jalr	-170(ra) # 40a <putc>
 4bc:	197d                	addi	s2,s2,-1
 4be:	ff3918e3          	bne	s2,s3,4ae <printint+0x82>
 4c2:	7902                	ld	s2,32(sp)
 4c4:	69e2                	ld	s3,24(sp)
}
 4c6:	70e2                	ld	ra,56(sp)
 4c8:	7442                	ld	s0,48(sp)
 4ca:	74a2                	ld	s1,40(sp)
 4cc:	6121                	addi	sp,sp,64
 4ce:	8082                	ret
    x = -xx;
 4d0:	40b005bb          	negw	a1,a1
    neg = 1;
 4d4:	4885                	li	a7,1
    x = -xx;
 4d6:	b7b5                	j	442 <printint+0x16>

00000000000004d8 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 4d8:	715d                	addi	sp,sp,-80
 4da:	e486                	sd	ra,72(sp)
 4dc:	e0a2                	sd	s0,64(sp)
 4de:	f84a                	sd	s2,48(sp)
 4e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4e2:	0005c903          	lbu	s2,0(a1)
 4e6:	1a090a63          	beqz	s2,69a <vprintf+0x1c2>
 4ea:	fc26                	sd	s1,56(sp)
 4ec:	f44e                	sd	s3,40(sp)
 4ee:	f052                	sd	s4,32(sp)
 4f0:	ec56                	sd	s5,24(sp)
 4f2:	e85a                	sd	s6,16(sp)
 4f4:	e45e                	sd	s7,8(sp)
 4f6:	8aaa                	mv	s5,a0
 4f8:	8bb2                	mv	s7,a2
 4fa:	00158493          	addi	s1,a1,1
  state = 0;
 4fe:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 500:	02500a13          	li	s4,37
 504:	4b55                	li	s6,21
 506:	a839                	j	524 <vprintf+0x4c>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	efe080e7          	jalr	-258(ra) # 40a <putc>
 514:	a019                	j	51a <vprintf+0x42>
    } else if (state == '%') {
 516:	01498d63          	beq	s3,s4,530 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 51a:	0485                	addi	s1,s1,1
 51c:	fff4c903          	lbu	s2,-1(s1)
 520:	16090763          	beqz	s2,68e <vprintf+0x1b6>
    if (state == 0) {
 524:	fe0999e3          	bnez	s3,516 <vprintf+0x3e>
      if (c == '%') {
 528:	ff4910e3          	bne	s2,s4,508 <vprintf+0x30>
        state = '%';
 52c:	89d2                	mv	s3,s4
 52e:	b7f5                	j	51a <vprintf+0x42>
      if (c == 'd') {
 530:	13490463          	beq	s2,s4,658 <vprintf+0x180>
 534:	f9d9079b          	addiw	a5,s2,-99
 538:	0ff7f793          	zext.b	a5,a5
 53c:	12fb6763          	bltu	s6,a5,66a <vprintf+0x192>
 540:	f9d9079b          	addiw	a5,s2,-99
 544:	0ff7f713          	zext.b	a4,a5
 548:	12eb6163          	bltu	s6,a4,66a <vprintf+0x192>
 54c:	00271793          	slli	a5,a4,0x2
 550:	00000717          	auipc	a4,0x0
 554:	3d870713          	addi	a4,a4,984 # 928 <loop+0x4a>
 558:	97ba                	add	a5,a5,a4
 55a:	439c                	lw	a5,0(a5)
 55c:	97ba                	add	a5,a5,a4
 55e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8913          	addi	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	ebe080e7          	jalr	-322(ra) # 42c <printint>
 576:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 578:	4981                	li	s3,0
 57a:	b745                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	ea2080e7          	jalr	-350(ra) # 42c <printint>
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	b751                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e86080e7          	jalr	-378(ra) # 42c <printint>
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b7a5                	j	51a <vprintf+0x42>
 5b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b6:	008b8c13          	addi	s8,s7,8
 5ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5be:	03000593          	li	a1,48
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e46080e7          	jalr	-442(ra) # 40a <putc>
  putc(fd, 'x');
 5cc:	07800593          	li	a1,120
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e38080e7          	jalr	-456(ra) # 40a <putc>
 5da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5dc:	00000b97          	auipc	s7,0x0
 5e0:	3a4b8b93          	addi	s7,s7,932 # 980 <digits>
 5e4:	03c9d793          	srli	a5,s3,0x3c
 5e8:	97de                	add	a5,a5,s7
 5ea:	0007c583          	lbu	a1,0(a5)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e1a080e7          	jalr	-486(ra) # 40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f8:	0992                	slli	s3,s3,0x4
 5fa:	397d                	addiw	s2,s2,-1
 5fc:	fe0914e3          	bnez	s2,5e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 600:	8be2                	mv	s7,s8
      state = 0;
 602:	4981                	li	s3,0
 604:	6c02                	ld	s8,0(sp)
 606:	bf11                	j	51a <vprintf+0x42>
        s = va_arg(ap, char *);
 608:	008b8993          	addi	s3,s7,8
 60c:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 610:	02090163          	beqz	s2,632 <vprintf+0x15a>
        while (*s != 0) {
 614:	00094583          	lbu	a1,0(s2)
 618:	c9a5                	beqz	a1,688 <vprintf+0x1b0>
          putc(fd, *s);
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	dee080e7          	jalr	-530(ra) # 40a <putc>
          s++;
 624:	0905                	addi	s2,s2,1
        while (*s != 0) {
 626:	00094583          	lbu	a1,0(s2)
 62a:	f9e5                	bnez	a1,61a <vprintf+0x142>
        s = va_arg(ap, char *);
 62c:	8bce                	mv	s7,s3
      state = 0;
 62e:	4981                	li	s3,0
 630:	b5ed                	j	51a <vprintf+0x42>
        if (s == 0) s = "(null)";
 632:	00000917          	auipc	s2,0x0
 636:	2ee90913          	addi	s2,s2,750 # 920 <loop+0x42>
        while (*s != 0) {
 63a:	02800593          	li	a1,40
 63e:	bff1                	j	61a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 640:	008b8913          	addi	s2,s7,8
 644:	000bc583          	lbu	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dc0080e7          	jalr	-576(ra) # 40a <putc>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b5d1                	j	51a <vprintf+0x42>
        putc(fd, c);
 658:	02500593          	li	a1,37
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dac080e7          	jalr	-596(ra) # 40a <putc>
      state = 0;
 666:	4981                	li	s3,0
 668:	bd4d                	j	51a <vprintf+0x42>
        putc(fd, '%');
 66a:	02500593          	li	a1,37
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	d9a080e7          	jalr	-614(ra) # 40a <putc>
        putc(fd, c);
 678:	85ca                	mv	a1,s2
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d8e080e7          	jalr	-626(ra) # 40a <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	bd51                	j	51a <vprintf+0x42>
        s = va_arg(ap, char *);
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b579                	j	51a <vprintf+0x42>
 68e:	74e2                	ld	s1,56(sp)
 690:	79a2                	ld	s3,40(sp)
 692:	7a02                	ld	s4,32(sp)
 694:	6ae2                	ld	s5,24(sp)
 696:	6b42                	ld	s6,16(sp)
 698:	6ba2                	ld	s7,8(sp)
    }
  }
}
 69a:	60a6                	ld	ra,72(sp)
 69c:	6406                	ld	s0,64(sp)
 69e:	7942                	ld	s2,48(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 6a4:	715d                	addi	sp,sp,-80
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e010                	sd	a2,0(s0)
 6ae:	e414                	sd	a3,8(s0)
 6b0:	e818                	sd	a4,16(s0)
 6b2:	ec1c                	sd	a5,24(s0)
 6b4:	03043023          	sd	a6,32(s0)
 6b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c0:	8622                	mv	a2,s0
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e16080e7          	jalr	-490(ra) # 4d8 <vprintf>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6161                	addi	sp,sp,80
 6d0:	8082                	ret

00000000000006d2 <printf>:

void printf(const char *fmt, ...) {
 6d2:	711d                	addi	sp,sp,-96
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e40c                	sd	a1,8(s0)
 6dc:	e810                	sd	a2,16(s0)
 6de:	ec14                	sd	a3,24(s0)
 6e0:	f018                	sd	a4,32(s0)
 6e2:	f41c                	sd	a5,40(s0)
 6e4:	03043823          	sd	a6,48(s0)
 6e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ec:	00840613          	addi	a2,s0,8
 6f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f4:	85aa                	mv	a1,a0
 6f6:	4505                	li	a0,1
 6f8:	00000097          	auipc	ra,0x0
 6fc:	de0080e7          	jalr	-544(ra) # 4d8 <vprintf>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6125                	addi	sp,sp,96
 706:	8082                	ret

0000000000000708 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 708:	1141                	addi	sp,sp,-16
 70a:	e422                	sd	s0,8(sp)
 70c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 70e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	00001797          	auipc	a5,0x1
 716:	8ee7b783          	ld	a5,-1810(a5) # 1000 <freep>
 71a:	a02d                	j	744 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 71c:	4618                	lw	a4,8(a2)
 71e:	9f2d                	addw	a4,a4,a1
 720:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 724:	6398                	ld	a4,0(a5)
 726:	6310                	ld	a2,0(a4)
 728:	a83d                	j	766 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 72a:	ff852703          	lw	a4,-8(a0)
 72e:	9f31                	addw	a4,a4,a2
 730:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 732:	ff053683          	ld	a3,-16(a0)
 736:	a091                	j	77a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 738:	6398                	ld	a4,0(a5)
 73a:	00e7e463          	bltu	a5,a4,742 <free+0x3a>
 73e:	00e6ea63          	bltu	a3,a4,752 <free+0x4a>
void free(void *ap) {
 742:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	fed7fae3          	bgeu	a5,a3,738 <free+0x30>
 748:	6398                	ld	a4,0(a5)
 74a:	00e6e463          	bltu	a3,a4,752 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 74e:	fee7eae3          	bltu	a5,a4,742 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 752:	ff852583          	lw	a1,-8(a0)
 756:	6390                	ld	a2,0(a5)
 758:	02059813          	slli	a6,a1,0x20
 75c:	01c85713          	srli	a4,a6,0x1c
 760:	9736                	add	a4,a4,a3
 762:	fae60de3          	beq	a2,a4,71c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 76a:	4790                	lw	a2,8(a5)
 76c:	02061593          	slli	a1,a2,0x20
 770:	01c5d713          	srli	a4,a1,0x1c
 774:	973e                	add	a4,a4,a5
 776:	fae68ae3          	beq	a3,a4,72a <free+0x22>
    p->s.ptr = bp->s.ptr;
 77a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77c:	00001717          	auipc	a4,0x1
 780:	88f73223          	sd	a5,-1916(a4) # 1000 <freep>
}
 784:	6422                	ld	s0,8(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret

000000000000078a <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 78a:	7139                	addi	sp,sp,-64
 78c:	fc06                	sd	ra,56(sp)
 78e:	f822                	sd	s0,48(sp)
 790:	f426                	sd	s1,40(sp)
 792:	ec4e                	sd	s3,24(sp)
 794:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 796:	02051493          	slli	s1,a0,0x20
 79a:	9081                	srli	s1,s1,0x20
 79c:	04bd                	addi	s1,s1,15
 79e:	8091                	srli	s1,s1,0x4
 7a0:	0014899b          	addiw	s3,s1,1
 7a4:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 7a6:	00001517          	auipc	a0,0x1
 7aa:	85a53503          	ld	a0,-1958(a0) # 1000 <freep>
 7ae:	c915                	beqz	a0,7e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7b0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 7b2:	4798                	lw	a4,8(a5)
 7b4:	08977e63          	bgeu	a4,s1,850 <malloc+0xc6>
 7b8:	f04a                	sd	s2,32(sp)
 7ba:	e852                	sd	s4,16(sp)
 7bc:	e456                	sd	s5,8(sp)
 7be:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 7c0:	8a4e                	mv	s4,s3
 7c2:	0009871b          	sext.w	a4,s3
 7c6:	6685                	lui	a3,0x1
 7c8:	00d77363          	bgeu	a4,a3,7ce <malloc+0x44>
 7cc:	6a05                	lui	s4,0x1
 7ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 7d6:	00001917          	auipc	s2,0x1
 7da:	82a90913          	addi	s2,s2,-2006 # 1000 <freep>
  if (p == (char *)-1) return 0;
 7de:	5afd                	li	s5,-1
 7e0:	a091                	j	824 <malloc+0x9a>
 7e2:	f04a                	sd	s2,32(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ea:	00001797          	auipc	a5,0x1
 7ee:	82678793          	addi	a5,a5,-2010 # 1010 <base>
 7f2:	00001717          	auipc	a4,0x1
 7f6:	80f73723          	sd	a5,-2034(a4) # 1000 <freep>
 7fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 800:	b7c1                	j	7c0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	e118                	sd	a4,0(a0)
 806:	a08d                	j	868 <malloc+0xde>
  hp->s.size = nu;
 808:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 80c:	0541                	addi	a0,a0,16
 80e:	00000097          	auipc	ra,0x0
 812:	efa080e7          	jalr	-262(ra) # 708 <free>
  return freep;
 816:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 81a:	c13d                	beqz	a0,880 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 81c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 81e:	4798                	lw	a4,8(a5)
 820:	02977463          	bgeu	a4,s1,848 <malloc+0xbe>
    if (p == freep)
 824:	00093703          	ld	a4,0(s2)
 828:	853e                	mv	a0,a5
 82a:	fef719e3          	bne	a4,a5,81c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 82e:	8552                	mv	a0,s4
 830:	00000097          	auipc	ra,0x0
 834:	bba080e7          	jalr	-1094(ra) # 3ea <sbrk>
  if (p == (char *)-1) return 0;
 838:	fd5518e3          	bne	a0,s5,808 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 83c:	4501                	li	a0,0
 83e:	7902                	ld	s2,32(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	a03d                	j	874 <malloc+0xea>
 848:	7902                	ld	s2,32(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 850:	fae489e3          	beq	s1,a4,802 <malloc+0x78>
        p->s.size -= nunits;
 854:	4137073b          	subw	a4,a4,s3
 858:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85a:	02071693          	slli	a3,a4,0x20
 85e:	01c6d713          	srli	a4,a3,0x1c
 862:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 864:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 868:	00000717          	auipc	a4,0x0
 86c:	78a73c23          	sd	a0,1944(a4) # 1000 <freep>
      return (void *)(p + 1);
 870:	01078513          	addi	a0,a5,16
  }
}
 874:	70e2                	ld	ra,56(sp)
 876:	7442                	ld	s0,48(sp)
 878:	74a2                	ld	s1,40(sp)
 87a:	69e2                	ld	s3,24(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
 880:	7902                	ld	s2,32(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	b7f5                	j	874 <malloc+0xea>

000000000000088a <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 88a:	4909                	li	s2,2
  li s3, 3
 88c:	498d                	li	s3,3
  li s4, 4
 88e:	4a11                	li	s4,4
  li s5, 5
 890:	4a95                	li	s5,5
  li s6, 6
 892:	4b19                	li	s6,6
  li s7, 7
 894:	4b9d                	li	s7,7
  li s8, 8
 896:	4c21                	li	s8,8
  li s9, 9
 898:	4ca5                	li	s9,9
  li s10, 10
 89a:	4d29                	li	s10,10
  li s11, 11
 89c:	4dad                	li	s11,11
  li a7, SYS_write
 89e:	48c1                	li	a7,16
  ecall
 8a0:	00000073          	ecall
  j loop
 8a4:	a82d                	j	8de <loop>

00000000000008a6 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 8a6:	4911                	li	s2,4
  li s3, 9
 8a8:	49a5                	li	s3,9
  li s4, 16
 8aa:	4a41                	li	s4,16
  li s5, 25
 8ac:	4ae5                	li	s5,25
  li s6, 36
 8ae:	02400b13          	li	s6,36
  li s7, 49
 8b2:	03100b93          	li	s7,49
  li s8, 64
 8b6:	04000c13          	li	s8,64
  li s9, 81
 8ba:	05100c93          	li	s9,81
  li s10, 100
 8be:	06400d13          	li	s10,100
  li s11, 121
 8c2:	07900d93          	li	s11,121
  li a7, SYS_write
 8c6:	48c1                	li	a7,16
  ecall
 8c8:	00000073          	ecall
  j loop
 8cc:	a809                	j	8de <loop>

00000000000008ce <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 8ce:	53900913          	li	s2,1337
  mv a2, a1
 8d2:	862e                	mv	a2,a1
  li a1, 2
 8d4:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 8d6:	48d9                	li	a7,22
  ecall
 8d8:	00000073          	ecall
#endif
  ret
 8dc:	8082                	ret

00000000000008de <loop>:

loop:
  j loop
 8de:	a001                	j	8de <loop>
  ret
 8e0:	8082                	ret
