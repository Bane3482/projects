
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:
#include "kernel/fcntl.h"
#include "user/user.h"

char buf[512];

void cat(int fd) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	41a080e7          	jalr	1050(ra) # 43a <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	40e080e7          	jalr	1038(ra) # 442 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	97058593          	addi	a1,a1,-1680 # 9b0 <loop+0x12>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	71a080e7          	jalr	1818(ra) # 764 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	3ce080e7          	jalr	974(ra) # 422 <exit>
    }
  }
  if (n < 0) {
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	95a58593          	addi	a1,a1,-1702 # 9c8 <loop+0x2a>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	6ec080e7          	jalr	1772(ra) # 764 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	3a0080e7          	jalr	928(ra) # 422 <exit>

000000000000008a <main>:

int main(int argc, char *argv[]) {
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2) # 1010 <buf>
  b8:	00000097          	auipc	ra,0x0
  bc:	3aa080e7          	jalr	938(ra) # 462 <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	37a080e7          	jalr	890(ra) # 44a <close>
  for (i = 1; i < argc; i++) {
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	342080e7          	jalr	834(ra) # 422 <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	328080e7          	jalr	808(ra) # 422 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00001597          	auipc	a1,0x1
 10a:	8da58593          	addi	a1,a1,-1830 # 9e0 <loop+0x42>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	654080e7          	jalr	1620(ra) # 764 <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	308080e7          	jalr	776(ra) # 422 <exit>

0000000000000122 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	f60080e7          	jalr	-160(ra) # 8a <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	2ee080e7          	jalr	750(ra) # 422 <exit>

000000000000013c <strcpy>:
}

char *strcpy(char *s, const char *t) {
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int strcmp(const char *p, const char *q) {
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint strlen(const char *s) {
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for (n = 0; s[n]; n++);
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void *memset(void *dst, int c, uint n) {
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char *strchr(const char *s, char c) {
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if (*s == c) return (char *)s;
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for (; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char *gets(char *buf, int max) {
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	214080e7          	jalr	532(ra) # 43a <read>
    if (cc < 1) break;
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	addi	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int stat(const char *n, struct stat *st) {
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	1ec080e7          	jalr	492(ra) # 462 <open>
  if (fd < 0) return -1;
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	1f2080e7          	jalr	498(ra) # 47a <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	1b6080e7          	jalr	438(ra) # 44a <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
  if (fd < 0) return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfcd                	j	29e <stat+0x36>

00000000000002ae <atoi>:

int atoi(const char *s) {
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66863          	bltu	a2,a5,2f2 <atoi+0x44>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1c>
  return n;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  n = 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <atoi+0x3e>

00000000000002f6 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57463          	bgeu	a0,a1,324 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 300:	00c05f63          	blez	a2,31e <memmove+0x28>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 30e:	0585                	addi	a1,a1,1
 310:	0705                	addi	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
    dst += n;
 324:	00c50733          	add	a4,a0,a2
    src += n;
 328:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 32a:	fec05ae3          	blez	a2,31e <memmove+0x28>
 32e:	fff6079b          	addiw	a5,a2,-1
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
 33c:	15fd                	addi	a1,a1,-1
 33e:	177d                	addi	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x46>
 34c:	bfc9                	j	31e <memmove+0x28>

000000000000034e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca05                	beqz	a2,384 <memcmp+0x36>
 356:	fff6069b          	addiw	a3,a2,-1
 35a:	1682                	slli	a3,a3,0x20
 35c:	9281                	srli	a3,a3,0x20
 35e:	0685                	addi	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x14>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x30>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <memcmp+0x30>

0000000000000388 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	00000097          	auipc	ra,0x0
 394:	f66080e7          	jalr	-154(ra) # 2f6 <memmove>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <strcat>:

char *strcat(char *dst, const char *src) {
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	c385                	beqz	a5,3ca <strcat+0x2a>
  char *p = dst;
 3ac:	87aa                	mv	a5,a0
  while (*p) p++;
 3ae:	0785                	addi	a5,a5,1
 3b0:	0007c703          	lbu	a4,0(a5)
 3b4:	ff6d                	bnez	a4,3ae <strcat+0xe>
  while ((*p++ = *src++));
 3b6:	0585                	addi	a1,a1,1
 3b8:	0785                	addi	a5,a5,1
 3ba:	fff5c703          	lbu	a4,-1(a1)
 3be:	fee78fa3          	sb	a4,-1(a5)
 3c2:	fb75                	bnez	a4,3b6 <strcat+0x16>
  return dst;
}
 3c4:	6422                	ld	s0,8(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret
  char *p = dst;
 3ca:	87aa                	mv	a5,a0
 3cc:	b7ed                	j	3b6 <strcat+0x16>

00000000000003ce <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 3d4:	0005c783          	lbu	a5,0(a1)
 3d8:	cf95                	beqz	a5,414 <strstr+0x46>

  for (; *haystack; haystack++) {
 3da:	00054783          	lbu	a5,0(a0)
 3de:	eb91                	bnez	a5,3f2 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 3e0:	4501                	li	a0,0
 3e2:	a80d                	j	414 <strstr+0x46>
    if (!*n) return (char *)haystack;
 3e4:	0007c783          	lbu	a5,0(a5)
 3e8:	c795                	beqz	a5,414 <strstr+0x46>
  for (; *haystack; haystack++) {
 3ea:	0505                	addi	a0,a0,1
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	c38d                	beqz	a5,412 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 3f2:	00054703          	lbu	a4,0(a0)
    n = needle;
 3f6:	87ae                	mv	a5,a1
    h = haystack;
 3f8:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 3fa:	db65                	beqz	a4,3ea <strstr+0x1c>
 3fc:	0007c683          	lbu	a3,0(a5)
 400:	ca91                	beqz	a3,414 <strstr+0x46>
 402:	fee691e3          	bne	a3,a4,3e4 <strstr+0x16>
      h++;
 406:	0605                	addi	a2,a2,1
      n++;
 408:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 40a:	00064703          	lbu	a4,0(a2)
 40e:	f77d                	bnez	a4,3fc <strstr+0x2e>
 410:	bfd1                	j	3e4 <strstr+0x16>
  return 0;
 412:	4501                	li	a0,0
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41a:	4885                	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exit>:
.global exit
exit:
 li a7, SYS_exit
 422:	4889                	li	a7,2
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	4891                	li	a7,4
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	4895                	li	a7,5
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48c1                	li	a7,16
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <close>:
.global close
close:
 li a7, SYS_close
 44a:	48d5                	li	a7,21
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <kill>:
.global kill
kill:
 li a7, SYS_kill
 452:	4899                	li	a7,6
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exec>:
.global exec
exec:
 li a7, SYS_exec
 45a:	489d                	li	a7,7
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <open>:
.global open
open:
 li a7, SYS_open
 462:	48bd                	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46a:	48c5                	li	a7,17
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 472:	48c9                	li	a7,18
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47a:	48a1                	li	a7,8
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <link>:
.global link
link:
 li a7, SYS_link
 482:	48cd                	li	a7,19
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48a:	48d1                	li	a7,20
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 492:	48a5                	li	a7,9
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <dup>:
.global dup
dup:
 li a7, SYS_dup
 49a:	48a9                	li	a7,10
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a2:	48ad                	li	a7,11
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4aa:	48b1                	li	a7,12
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b2:	48b5                	li	a7,13
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ba:	48b9                	li	a7,14
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <reg>:
.global reg
reg:
 li a7, SYS_reg
 4c2:	48d9                	li	a7,22
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 4ca:	1101                	addi	sp,sp,-32
 4cc:	ec06                	sd	ra,24(sp)
 4ce:	e822                	sd	s0,16(sp)
 4d0:	1000                	addi	s0,sp,32
 4d2:	feb407a3          	sb	a1,-17(s0)
 4d6:	4605                	li	a2,1
 4d8:	fef40593          	addi	a1,s0,-17
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f66080e7          	jalr	-154(ra) # 442 <write>
 4e4:	60e2                	ld	ra,24(sp)
 4e6:	6442                	ld	s0,16(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret

00000000000004ec <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 4ec:	7139                	addi	sp,sp,-64
 4ee:	fc06                	sd	ra,56(sp)
 4f0:	f822                	sd	s0,48(sp)
 4f2:	f426                	sd	s1,40(sp)
 4f4:	0080                	addi	s0,sp,64
 4f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 4f8:	c299                	beqz	a3,4fe <printint+0x12>
 4fa:	0805cb63          	bltz	a1,590 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fe:	2581                	sext.w	a1,a1
  neg = 0;
 500:	4881                	li	a7,0
 502:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 506:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 508:	2601                	sext.w	a2,a2
 50a:	00000517          	auipc	a0,0x0
 50e:	54e50513          	addi	a0,a0,1358 # a58 <digits>
 512:	883a                	mv	a6,a4
 514:	2705                	addiw	a4,a4,1
 516:	02c5f7bb          	remuw	a5,a1,a2
 51a:	1782                	slli	a5,a5,0x20
 51c:	9381                	srli	a5,a5,0x20
 51e:	97aa                	add	a5,a5,a0
 520:	0007c783          	lbu	a5,0(a5)
 524:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 528:	0005879b          	sext.w	a5,a1
 52c:	02c5d5bb          	divuw	a1,a1,a2
 530:	0685                	addi	a3,a3,1
 532:	fec7f0e3          	bgeu	a5,a2,512 <printint+0x26>
  if (neg) buf[i++] = '-';
 536:	00088c63          	beqz	a7,54e <printint+0x62>
 53a:	fd070793          	addi	a5,a4,-48
 53e:	00878733          	add	a4,a5,s0
 542:	02d00793          	li	a5,45
 546:	fef70823          	sb	a5,-16(a4)
 54a:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 54e:	02e05c63          	blez	a4,586 <printint+0x9a>
 552:	f04a                	sd	s2,32(sp)
 554:	ec4e                	sd	s3,24(sp)
 556:	fc040793          	addi	a5,s0,-64
 55a:	00e78933          	add	s2,a5,a4
 55e:	fff78993          	addi	s3,a5,-1
 562:	99ba                	add	s3,s3,a4
 564:	377d                	addiw	a4,a4,-1
 566:	1702                	slli	a4,a4,0x20
 568:	9301                	srli	a4,a4,0x20
 56a:	40e989b3          	sub	s3,s3,a4
 56e:	fff94583          	lbu	a1,-1(s2)
 572:	8526                	mv	a0,s1
 574:	00000097          	auipc	ra,0x0
 578:	f56080e7          	jalr	-170(ra) # 4ca <putc>
 57c:	197d                	addi	s2,s2,-1
 57e:	ff3918e3          	bne	s2,s3,56e <printint+0x82>
 582:	7902                	ld	s2,32(sp)
 584:	69e2                	ld	s3,24(sp)
}
 586:	70e2                	ld	ra,56(sp)
 588:	7442                	ld	s0,48(sp)
 58a:	74a2                	ld	s1,40(sp)
 58c:	6121                	addi	sp,sp,64
 58e:	8082                	ret
    x = -xx;
 590:	40b005bb          	negw	a1,a1
    neg = 1;
 594:	4885                	li	a7,1
    x = -xx;
 596:	b7b5                	j	502 <printint+0x16>

0000000000000598 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 598:	715d                	addi	sp,sp,-80
 59a:	e486                	sd	ra,72(sp)
 59c:	e0a2                	sd	s0,64(sp)
 59e:	f84a                	sd	s2,48(sp)
 5a0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5a2:	0005c903          	lbu	s2,0(a1)
 5a6:	1a090a63          	beqz	s2,75a <vprintf+0x1c2>
 5aa:	fc26                	sd	s1,56(sp)
 5ac:	f44e                	sd	s3,40(sp)
 5ae:	f052                	sd	s4,32(sp)
 5b0:	ec56                	sd	s5,24(sp)
 5b2:	e85a                	sd	s6,16(sp)
 5b4:	e45e                	sd	s7,8(sp)
 5b6:	8aaa                	mv	s5,a0
 5b8:	8bb2                	mv	s7,a2
 5ba:	00158493          	addi	s1,a1,1
  state = 0;
 5be:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 5c0:	02500a13          	li	s4,37
 5c4:	4b55                	li	s6,21
 5c6:	a839                	j	5e4 <vprintf+0x4c>
        putc(fd, c);
 5c8:	85ca                	mv	a1,s2
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	efe080e7          	jalr	-258(ra) # 4ca <putc>
 5d4:	a019                	j	5da <vprintf+0x42>
    } else if (state == '%') {
 5d6:	01498d63          	beq	s3,s4,5f0 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 5da:	0485                	addi	s1,s1,1
 5dc:	fff4c903          	lbu	s2,-1(s1)
 5e0:	16090763          	beqz	s2,74e <vprintf+0x1b6>
    if (state == 0) {
 5e4:	fe0999e3          	bnez	s3,5d6 <vprintf+0x3e>
      if (c == '%') {
 5e8:	ff4910e3          	bne	s2,s4,5c8 <vprintf+0x30>
        state = '%';
 5ec:	89d2                	mv	s3,s4
 5ee:	b7f5                	j	5da <vprintf+0x42>
      if (c == 'd') {
 5f0:	13490463          	beq	s2,s4,718 <vprintf+0x180>
 5f4:	f9d9079b          	addiw	a5,s2,-99
 5f8:	0ff7f793          	zext.b	a5,a5
 5fc:	12fb6763          	bltu	s6,a5,72a <vprintf+0x192>
 600:	f9d9079b          	addiw	a5,s2,-99
 604:	0ff7f713          	zext.b	a4,a5
 608:	12eb6163          	bltu	s6,a4,72a <vprintf+0x192>
 60c:	00271793          	slli	a5,a4,0x2
 610:	00000717          	auipc	a4,0x0
 614:	3f070713          	addi	a4,a4,1008 # a00 <loop+0x62>
 618:	97ba                	add	a5,a5,a4
 61a:	439c                	lw	a5,0(a5)
 61c:	97ba                	add	a5,a5,a4
 61e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	ebe080e7          	jalr	-322(ra) # 4ec <printint>
 636:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 638:	4981                	li	s3,0
 63a:	b745                	j	5da <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	ea2080e7          	jalr	-350(ra) # 4ec <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b751                	j	5da <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000ba583          	lw	a1,0(s7)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e86080e7          	jalr	-378(ra) # 4ec <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b7a5                	j	5da <vprintf+0x42>
 674:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 676:	008b8c13          	addi	s8,s7,8
 67a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67e:	03000593          	li	a1,48
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e46080e7          	jalr	-442(ra) # 4ca <putc>
  putc(fd, 'x');
 68c:	07800593          	li	a1,120
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e38080e7          	jalr	-456(ra) # 4ca <putc>
 69a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	00000b97          	auipc	s7,0x0
 6a0:	3bcb8b93          	addi	s7,s7,956 # a58 <digits>
 6a4:	03c9d793          	srli	a5,s3,0x3c
 6a8:	97de                	add	a5,a5,s7
 6aa:	0007c583          	lbu	a1,0(a5)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e1a080e7          	jalr	-486(ra) # 4ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b8:	0992                	slli	s3,s3,0x4
 6ba:	397d                	addiw	s2,s2,-1
 6bc:	fe0914e3          	bnez	s2,6a4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6c0:	8be2                	mv	s7,s8
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	6c02                	ld	s8,0(sp)
 6c6:	bf11                	j	5da <vprintf+0x42>
        s = va_arg(ap, char *);
 6c8:	008b8993          	addi	s3,s7,8
 6cc:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 6d0:	02090163          	beqz	s2,6f2 <vprintf+0x15a>
        while (*s != 0) {
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	c9a5                	beqz	a1,748 <vprintf+0x1b0>
          putc(fd, *s);
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	dee080e7          	jalr	-530(ra) # 4ca <putc>
          s++;
 6e4:	0905                	addi	s2,s2,1
        while (*s != 0) {
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	f9e5                	bnez	a1,6da <vprintf+0x142>
        s = va_arg(ap, char *);
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b5ed                	j	5da <vprintf+0x42>
        if (s == 0) s = "(null)";
 6f2:	00000917          	auipc	s2,0x0
 6f6:	30690913          	addi	s2,s2,774 # 9f8 <loop+0x5a>
        while (*s != 0) {
 6fa:	02800593          	li	a1,40
 6fe:	bff1                	j	6da <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 700:	008b8913          	addi	s2,s7,8
 704:	000bc583          	lbu	a1,0(s7)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	dc0080e7          	jalr	-576(ra) # 4ca <putc>
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	b5d1                	j	5da <vprintf+0x42>
        putc(fd, c);
 718:	02500593          	li	a1,37
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dac080e7          	jalr	-596(ra) # 4ca <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	bd4d                	j	5da <vprintf+0x42>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	d9a080e7          	jalr	-614(ra) # 4ca <putc>
        putc(fd, c);
 738:	85ca                	mv	a1,s2
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	d8e080e7          	jalr	-626(ra) # 4ca <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	bd51                	j	5da <vprintf+0x42>
        s = va_arg(ap, char *);
 748:	8bce                	mv	s7,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b579                	j	5da <vprintf+0x42>
 74e:	74e2                	ld	s1,56(sp)
 750:	79a2                	ld	s3,40(sp)
 752:	7a02                	ld	s4,32(sp)
 754:	6ae2                	ld	s5,24(sp)
 756:	6b42                	ld	s6,16(sp)
 758:	6ba2                	ld	s7,8(sp)
    }
  }
}
 75a:	60a6                	ld	ra,72(sp)
 75c:	6406                	ld	s0,64(sp)
 75e:	7942                	ld	s2,48(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 764:	715d                	addi	sp,sp,-80
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e010                	sd	a2,0(s0)
 76e:	e414                	sd	a3,8(s0)
 770:	e818                	sd	a4,16(s0)
 772:	ec1c                	sd	a5,24(s0)
 774:	03043023          	sd	a6,32(s0)
 778:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	8622                	mv	a2,s0
 782:	00000097          	auipc	ra,0x0
 786:	e16080e7          	jalr	-490(ra) # 598 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6161                	addi	sp,sp,80
 790:	8082                	ret

0000000000000792 <printf>:

void printf(const char *fmt, ...) {
 792:	711d                	addi	sp,sp,-96
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	1000                	addi	s0,sp,32
 79a:	e40c                	sd	a1,8(s0)
 79c:	e810                	sd	a2,16(s0)
 79e:	ec14                	sd	a3,24(s0)
 7a0:	f018                	sd	a4,32(s0)
 7a2:	f41c                	sd	a5,40(s0)
 7a4:	03043823          	sd	a6,48(s0)
 7a8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	00840613          	addi	a2,s0,8
 7b0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b4:	85aa                	mv	a1,a0
 7b6:	4505                	li	a0,1
 7b8:	00000097          	auipc	ra,0x0
 7bc:	de0080e7          	jalr	-544(ra) # 598 <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6125                	addi	sp,sp,96
 7c6:	8082                	ret

00000000000007c8 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 7c8:	1141                	addi	sp,sp,-16
 7ca:	e422                	sd	s0,8(sp)
 7cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7ce:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	00001797          	auipc	a5,0x1
 7d6:	82e7b783          	ld	a5,-2002(a5) # 1000 <freep>
 7da:	a02d                	j	804 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7dc:	4618                	lw	a4,8(a2)
 7de:	9f2d                	addw	a4,a4,a1
 7e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	6310                	ld	a2,0(a4)
 7e8:	a83d                	j	826 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9f31                	addw	a4,a4,a2
 7f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053683          	ld	a3,-16(a0)
 7f6:	a091                	j	83a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e7e463          	bltu	a5,a4,802 <free+0x3a>
 7fe:	00e6ea63          	bltu	a3,a4,812 <free+0x4a>
void free(void *ap) {
 802:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	fed7fae3          	bgeu	a5,a3,7f8 <free+0x30>
 808:	6398                	ld	a4,0(a5)
 80a:	00e6e463          	bltu	a3,a4,812 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 80e:	fee7eae3          	bltu	a5,a4,802 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 812:	ff852583          	lw	a1,-8(a0)
 816:	6390                	ld	a2,0(a5)
 818:	02059813          	slli	a6,a1,0x20
 81c:	01c85713          	srli	a4,a6,0x1c
 820:	9736                	add	a4,a4,a3
 822:	fae60de3          	beq	a2,a4,7dc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 82a:	4790                	lw	a2,8(a5)
 82c:	02061593          	slli	a1,a2,0x20
 830:	01c5d713          	srli	a4,a1,0x1c
 834:	973e                	add	a4,a4,a5
 836:	fae68ae3          	beq	a3,a4,7ea <free+0x22>
    p->s.ptr = bp->s.ptr;
 83a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73223          	sd	a5,1988(a4) # 1000 <freep>
}
 844:	6422                	ld	s0,8(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret

000000000000084a <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 84a:	7139                	addi	sp,sp,-64
 84c:	fc06                	sd	ra,56(sp)
 84e:	f822                	sd	s0,48(sp)
 850:	f426                	sd	s1,40(sp)
 852:	ec4e                	sd	s3,24(sp)
 854:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 856:	02051493          	slli	s1,a0,0x20
 85a:	9081                	srli	s1,s1,0x20
 85c:	04bd                	addi	s1,s1,15
 85e:	8091                	srli	s1,s1,0x4
 860:	0014899b          	addiw	s3,s1,1
 864:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 866:	00000517          	auipc	a0,0x0
 86a:	79a53503          	ld	a0,1946(a0) # 1000 <freep>
 86e:	c915                	beqz	a0,8a2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 870:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 872:	4798                	lw	a4,8(a5)
 874:	08977e63          	bgeu	a4,s1,910 <malloc+0xc6>
 878:	f04a                	sd	s2,32(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 880:	8a4e                	mv	s4,s3
 882:	0009871b          	sext.w	a4,s3
 886:	6685                	lui	a3,0x1
 888:	00d77363          	bgeu	a4,a3,88e <malloc+0x44>
 88c:	6a05                	lui	s4,0x1
 88e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 892:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 896:	00000917          	auipc	s2,0x0
 89a:	76a90913          	addi	s2,s2,1898 # 1000 <freep>
  if (p == (char *)-1) return 0;
 89e:	5afd                	li	s5,-1
 8a0:	a091                	j	8e4 <malloc+0x9a>
 8a2:	f04a                	sd	s2,32(sp)
 8a4:	e852                	sd	s4,16(sp)
 8a6:	e456                	sd	s5,8(sp)
 8a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8aa:	00001797          	auipc	a5,0x1
 8ae:	96678793          	addi	a5,a5,-1690 # 1210 <base>
 8b2:	00000717          	auipc	a4,0x0
 8b6:	74f73723          	sd	a5,1870(a4) # 1000 <freep>
 8ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8bc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8c0:	b7c1                	j	880 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	e118                	sd	a4,0(a0)
 8c6:	a08d                	j	928 <malloc+0xde>
  hp->s.size = nu;
 8c8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8cc:	0541                	addi	a0,a0,16
 8ce:	00000097          	auipc	ra,0x0
 8d2:	efa080e7          	jalr	-262(ra) # 7c8 <free>
  return freep;
 8d6:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 8da:	c13d                	beqz	a0,940 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8dc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8de:	4798                	lw	a4,8(a5)
 8e0:	02977463          	bgeu	a4,s1,908 <malloc+0xbe>
    if (p == freep)
 8e4:	00093703          	ld	a4,0(s2)
 8e8:	853e                	mv	a0,a5
 8ea:	fef719e3          	bne	a4,a5,8dc <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8ee:	8552                	mv	a0,s4
 8f0:	00000097          	auipc	ra,0x0
 8f4:	bba080e7          	jalr	-1094(ra) # 4aa <sbrk>
  if (p == (char *)-1) return 0;
 8f8:	fd5518e3          	bne	a0,s5,8c8 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 8fc:	4501                	li	a0,0
 8fe:	7902                	ld	s2,32(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	a03d                	j	934 <malloc+0xea>
 908:	7902                	ld	s2,32(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 910:	fae489e3          	beq	s1,a4,8c2 <malloc+0x78>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	slli	a3,a4,0x20
 91e:	01c6d713          	srli	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ca73c23          	sd	a0,1752(a4) # 1000 <freep>
      return (void *)(p + 1);
 930:	01078513          	addi	a0,a5,16
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	74a2                	ld	s1,40(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	b7f5                	j	934 <malloc+0xea>

000000000000094a <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 94a:	4909                	li	s2,2
  li s3, 3
 94c:	498d                	li	s3,3
  li s4, 4
 94e:	4a11                	li	s4,4
  li s5, 5
 950:	4a95                	li	s5,5
  li s6, 6
 952:	4b19                	li	s6,6
  li s7, 7
 954:	4b9d                	li	s7,7
  li s8, 8
 956:	4c21                	li	s8,8
  li s9, 9
 958:	4ca5                	li	s9,9
  li s10, 10
 95a:	4d29                	li	s10,10
  li s11, 11
 95c:	4dad                	li	s11,11
  li a7, SYS_write
 95e:	48c1                	li	a7,16
  ecall
 960:	00000073          	ecall
  j loop
 964:	a82d                	j	99e <loop>

0000000000000966 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 966:	4911                	li	s2,4
  li s3, 9
 968:	49a5                	li	s3,9
  li s4, 16
 96a:	4a41                	li	s4,16
  li s5, 25
 96c:	4ae5                	li	s5,25
  li s6, 36
 96e:	02400b13          	li	s6,36
  li s7, 49
 972:	03100b93          	li	s7,49
  li s8, 64
 976:	04000c13          	li	s8,64
  li s9, 81
 97a:	05100c93          	li	s9,81
  li s10, 100
 97e:	06400d13          	li	s10,100
  li s11, 121
 982:	07900d93          	li	s11,121
  li a7, SYS_write
 986:	48c1                	li	a7,16
  ecall
 988:	00000073          	ecall
  j loop
 98c:	a809                	j	99e <loop>

000000000000098e <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 98e:	53900913          	li	s2,1337
  mv a2, a1
 992:	862e                	mv	a2,a1
  li a1, 2
 994:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 996:	48d9                	li	a7,22
  ecall
 998:	00000073          	ecall
#endif
  ret
 99c:	8082                	ret

000000000000099e <loop>:

loop:
  j loop
 99e:	a001                	j	99e <loop>
  ret
 9a0:	8082                	ret
