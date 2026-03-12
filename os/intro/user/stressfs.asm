
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
//      asm volatile("");

#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	9aa78793          	addi	a5,a5,-1622 # 9c0 <loop+0x38>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	96450513          	addi	a0,a0,-1692 # 990 <loop+0x8>
  34:	00000097          	auipc	ra,0x0
  38:	748080e7          	jalr	1864(ra) # 77c <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0) break;
  54:	00000097          	auipc	ra,0x0
  58:	3b0080e7          	jalr	944(ra) # 404 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for (i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	94050513          	addi	a0,a0,-1728 # 9a8 <loop+0x20>
  70:	00000097          	auipc	ra,0x0
  74:	70c080e7          	jalr	1804(ra) # 77c <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	3c2080e7          	jalr	962(ra) # 44c <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    //    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	38c080e7          	jalr	908(ra) # 42c <write>
  for (i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	386080e7          	jalr	902(ra) # 434 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	90250513          	addi	a0,a0,-1790 # 9b8 <loop+0x30>
  be:	00000097          	auipc	ra,0x0
  c2:	6be080e7          	jalr	1726(ra) # 77c <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	380080e7          	jalr	896(ra) # 44c <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	342080e7          	jalr	834(ra) # 424 <read>
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	344080e7          	jalr	836(ra) # 434 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	31a080e7          	jalr	794(ra) # 414 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	308080e7          	jalr	776(ra) # 40c <exit>

000000000000010c <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	2ee080e7          	jalr	750(ra) # 40c <exit>

0000000000000126 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int strcmp(const char *p, const char *q) {
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint strlen(const char *s) {
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for (n = 0; s[n]; n++);
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void *memset(void *dst, int c, uint n) {
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char *strchr(const char *s, char c) {
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if (*s == c) return (char *)s;
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for (; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char *gets(char *buf, int max) {
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	214080e7          	jalr	532(ra) # 424 <read>
    if (cc < 1) break;
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int stat(const char *n, struct stat *st) {
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	1ec080e7          	jalr	492(ra) # 44c <open>
  if (fd < 0) return -1;
 268:	02054663          	bltz	a0,294 <stat+0x42>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	1f2080e7          	jalr	498(ra) # 464 <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	1b6080e7          	jalr	438(ra) # 434 <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
  if (fd < 0) return -1;
 294:	597d                	li	s2,-1
 296:	bfcd                	j	288 <stat+0x36>

0000000000000298 <atoi>:

int atoi(const char *s) {
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
 304:	fef71ae3          	bne	a4,a5,2f8 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <strcat>:

char *strcat(char *dst, const char *src) {
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 390:	00054783          	lbu	a5,0(a0)
 394:	c385                	beqz	a5,3b4 <strcat+0x2a>
  char *p = dst;
 396:	87aa                	mv	a5,a0
  while (*p) p++;
 398:	0785                	addi	a5,a5,1
 39a:	0007c703          	lbu	a4,0(a5)
 39e:	ff6d                	bnez	a4,398 <strcat+0xe>
  while ((*p++ = *src++));
 3a0:	0585                	addi	a1,a1,1
 3a2:	0785                	addi	a5,a5,1
 3a4:	fff5c703          	lbu	a4,-1(a1)
 3a8:	fee78fa3          	sb	a4,-1(a5)
 3ac:	fb75                	bnez	a4,3a0 <strcat+0x16>
  return dst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  char *p = dst;
 3b4:	87aa                	mv	a5,a0
 3b6:	b7ed                	j	3a0 <strcat+0x16>

00000000000003b8 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 3be:	0005c783          	lbu	a5,0(a1)
 3c2:	cf95                	beqz	a5,3fe <strstr+0x46>

  for (; *haystack; haystack++) {
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	eb91                	bnez	a5,3dc <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	a80d                	j	3fe <strstr+0x46>
    if (!*n) return (char *)haystack;
 3ce:	0007c783          	lbu	a5,0(a5)
 3d2:	c795                	beqz	a5,3fe <strstr+0x46>
  for (; *haystack; haystack++) {
 3d4:	0505                	addi	a0,a0,1
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	c38d                	beqz	a5,3fc <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 3dc:	00054703          	lbu	a4,0(a0)
    n = needle;
 3e0:	87ae                	mv	a5,a1
    h = haystack;
 3e2:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 3e4:	db65                	beqz	a4,3d4 <strstr+0x1c>
 3e6:	0007c683          	lbu	a3,0(a5)
 3ea:	ca91                	beqz	a3,3fe <strstr+0x46>
 3ec:	fee691e3          	bne	a3,a4,3ce <strstr+0x16>
      h++;
 3f0:	0605                	addi	a2,a2,1
      n++;
 3f2:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 3f4:	00064703          	lbu	a4,0(a2)
 3f8:	f77d                	bnez	a4,3e6 <strstr+0x2e>
 3fa:	bfd1                	j	3ce <strstr+0x16>
  return 0;
 3fc:	4501                	li	a0,0
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 404:	4885                	li	a7,1
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <exit>:
.global exit
exit:
 li a7, SYS_exit
 40c:	4889                	li	a7,2
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <wait>:
.global wait
wait:
 li a7, SYS_wait
 414:	488d                	li	a7,3
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41c:	4891                	li	a7,4
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	4895                	li	a7,5
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <write>:
.global write
write:
 li a7, SYS_write
 42c:	48c1                	li	a7,16
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <close>:
.global close
close:
 li a7, SYS_close
 434:	48d5                	li	a7,21
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <kill>:
.global kill
kill:
 li a7, SYS_kill
 43c:	4899                	li	a7,6
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exec>:
.global exec
exec:
 li a7, SYS_exec
 444:	489d                	li	a7,7
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <open>:
.global open
open:
 li a7, SYS_open
 44c:	48bd                	li	a7,15
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 454:	48c5                	li	a7,17
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45c:	48c9                	li	a7,18
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 464:	48a1                	li	a7,8
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <link>:
.global link
link:
 li a7, SYS_link
 46c:	48cd                	li	a7,19
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 474:	48d1                	li	a7,20
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47c:	48a5                	li	a7,9
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dup>:
.global dup
dup:
 li a7, SYS_dup
 484:	48a9                	li	a7,10
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48c:	48ad                	li	a7,11
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 494:	48b1                	li	a7,12
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49c:	48b5                	li	a7,13
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a4:	48b9                	li	a7,14
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <reg>:
.global reg
reg:
 li a7, SYS_reg
 4ac:	48d9                	li	a7,22
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 4b4:	1101                	addi	sp,sp,-32
 4b6:	ec06                	sd	ra,24(sp)
 4b8:	e822                	sd	s0,16(sp)
 4ba:	1000                	addi	s0,sp,32
 4bc:	feb407a3          	sb	a1,-17(s0)
 4c0:	4605                	li	a2,1
 4c2:	fef40593          	addi	a1,s0,-17
 4c6:	00000097          	auipc	ra,0x0
 4ca:	f66080e7          	jalr	-154(ra) # 42c <write>
 4ce:	60e2                	ld	ra,24(sp)
 4d0:	6442                	ld	s0,16(sp)
 4d2:	6105                	addi	sp,sp,32
 4d4:	8082                	ret

00000000000004d6 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 4d6:	7139                	addi	sp,sp,-64
 4d8:	fc06                	sd	ra,56(sp)
 4da:	f822                	sd	s0,48(sp)
 4dc:	f426                	sd	s1,40(sp)
 4de:	0080                	addi	s0,sp,64
 4e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 4e2:	c299                	beqz	a3,4e8 <printint+0x12>
 4e4:	0805cb63          	bltz	a1,57a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e8:	2581                	sext.w	a1,a1
  neg = 0;
 4ea:	4881                	li	a7,0
 4ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4f0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4f2:	2601                	sext.w	a2,a2
 4f4:	00000517          	auipc	a0,0x0
 4f8:	53c50513          	addi	a0,a0,1340 # a30 <digits>
 4fc:	883a                	mv	a6,a4
 4fe:	2705                	addiw	a4,a4,1
 500:	02c5f7bb          	remuw	a5,a1,a2
 504:	1782                	slli	a5,a5,0x20
 506:	9381                	srli	a5,a5,0x20
 508:	97aa                	add	a5,a5,a0
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 512:	0005879b          	sext.w	a5,a1
 516:	02c5d5bb          	divuw	a1,a1,a2
 51a:	0685                	addi	a3,a3,1
 51c:	fec7f0e3          	bgeu	a5,a2,4fc <printint+0x26>
  if (neg) buf[i++] = '-';
 520:	00088c63          	beqz	a7,538 <printint+0x62>
 524:	fd070793          	addi	a5,a4,-48
 528:	00878733          	add	a4,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef70823          	sb	a5,-16(a4)
 534:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 538:	02e05c63          	blez	a4,570 <printint+0x9a>
 53c:	f04a                	sd	s2,32(sp)
 53e:	ec4e                	sd	s3,24(sp)
 540:	fc040793          	addi	a5,s0,-64
 544:	00e78933          	add	s2,a5,a4
 548:	fff78993          	addi	s3,a5,-1
 54c:	99ba                	add	s3,s3,a4
 54e:	377d                	addiw	a4,a4,-1
 550:	1702                	slli	a4,a4,0x20
 552:	9301                	srli	a4,a4,0x20
 554:	40e989b3          	sub	s3,s3,a4
 558:	fff94583          	lbu	a1,-1(s2)
 55c:	8526                	mv	a0,s1
 55e:	00000097          	auipc	ra,0x0
 562:	f56080e7          	jalr	-170(ra) # 4b4 <putc>
 566:	197d                	addi	s2,s2,-1
 568:	ff3918e3          	bne	s2,s3,558 <printint+0x82>
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
}
 570:	70e2                	ld	ra,56(sp)
 572:	7442                	ld	s0,48(sp)
 574:	74a2                	ld	s1,40(sp)
 576:	6121                	addi	sp,sp,64
 578:	8082                	ret
    x = -xx;
 57a:	40b005bb          	negw	a1,a1
    neg = 1;
 57e:	4885                	li	a7,1
    x = -xx;
 580:	b7b5                	j	4ec <printint+0x16>

0000000000000582 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 582:	715d                	addi	sp,sp,-80
 584:	e486                	sd	ra,72(sp)
 586:	e0a2                	sd	s0,64(sp)
 588:	f84a                	sd	s2,48(sp)
 58a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 58c:	0005c903          	lbu	s2,0(a1)
 590:	1a090a63          	beqz	s2,744 <vprintf+0x1c2>
 594:	fc26                	sd	s1,56(sp)
 596:	f44e                	sd	s3,40(sp)
 598:	f052                	sd	s4,32(sp)
 59a:	ec56                	sd	s5,24(sp)
 59c:	e85a                	sd	s6,16(sp)
 59e:	e45e                	sd	s7,8(sp)
 5a0:	8aaa                	mv	s5,a0
 5a2:	8bb2                	mv	s7,a2
 5a4:	00158493          	addi	s1,a1,1
  state = 0;
 5a8:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 5aa:	02500a13          	li	s4,37
 5ae:	4b55                	li	s6,21
 5b0:	a839                	j	5ce <vprintf+0x4c>
        putc(fd, c);
 5b2:	85ca                	mv	a1,s2
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	efe080e7          	jalr	-258(ra) # 4b4 <putc>
 5be:	a019                	j	5c4 <vprintf+0x42>
    } else if (state == '%') {
 5c0:	01498d63          	beq	s3,s4,5da <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 5c4:	0485                	addi	s1,s1,1
 5c6:	fff4c903          	lbu	s2,-1(s1)
 5ca:	16090763          	beqz	s2,738 <vprintf+0x1b6>
    if (state == 0) {
 5ce:	fe0999e3          	bnez	s3,5c0 <vprintf+0x3e>
      if (c == '%') {
 5d2:	ff4910e3          	bne	s2,s4,5b2 <vprintf+0x30>
        state = '%';
 5d6:	89d2                	mv	s3,s4
 5d8:	b7f5                	j	5c4 <vprintf+0x42>
      if (c == 'd') {
 5da:	13490463          	beq	s2,s4,702 <vprintf+0x180>
 5de:	f9d9079b          	addiw	a5,s2,-99
 5e2:	0ff7f793          	zext.b	a5,a5
 5e6:	12fb6763          	bltu	s6,a5,714 <vprintf+0x192>
 5ea:	f9d9079b          	addiw	a5,s2,-99
 5ee:	0ff7f713          	zext.b	a4,a5
 5f2:	12eb6163          	bltu	s6,a4,714 <vprintf+0x192>
 5f6:	00271793          	slli	a5,a4,0x2
 5fa:	00000717          	auipc	a4,0x0
 5fe:	3de70713          	addi	a4,a4,990 # 9d8 <loop+0x50>
 602:	97ba                	add	a5,a5,a4
 604:	439c                	lw	a5,0(a5)
 606:	97ba                	add	a5,a5,a4
 608:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	ebe080e7          	jalr	-322(ra) # 4d6 <printint>
 620:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 622:	4981                	li	s3,0
 624:	b745                	j	5c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	008b8913          	addi	s2,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000ba583          	lw	a1,0(s7)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	ea2080e7          	jalr	-350(ra) # 4d6 <printint>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b751                	j	5c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000ba583          	lw	a1,0(s7)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e86080e7          	jalr	-378(ra) # 4d6 <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b7a5                	j	5c4 <vprintf+0x42>
 65e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 660:	008b8c13          	addi	s8,s7,8
 664:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e46080e7          	jalr	-442(ra) # 4b4 <putc>
  putc(fd, 'x');
 676:	07800593          	li	a1,120
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e38080e7          	jalr	-456(ra) # 4b4 <putc>
 684:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	3aab8b93          	addi	s7,s7,938 # a30 <digits>
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e1a080e7          	jalr	-486(ra) # 4b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8be2                	mv	s7,s8
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6c02                	ld	s8,0(sp)
 6b0:	bf11                	j	5c4 <vprintf+0x42>
        s = va_arg(ap, char *);
 6b2:	008b8993          	addi	s3,s7,8
 6b6:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 6ba:	02090163          	beqz	s2,6dc <vprintf+0x15a>
        while (*s != 0) {
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c9a5                	beqz	a1,732 <vprintf+0x1b0>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dee080e7          	jalr	-530(ra) # 4b4 <putc>
          s++;
 6ce:	0905                	addi	s2,s2,1
        while (*s != 0) {
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x142>
        s = va_arg(ap, char *);
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b5ed                	j	5c4 <vprintf+0x42>
        if (s == 0) s = "(null)";
 6dc:	00000917          	auipc	s2,0x0
 6e0:	2f490913          	addi	s2,s2,756 # 9d0 <loop+0x48>
        while (*s != 0) {
 6e4:	02800593          	li	a1,40
 6e8:	bff1                	j	6c4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dc0080e7          	jalr	-576(ra) # 4b4 <putc>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b5d1                	j	5c4 <vprintf+0x42>
        putc(fd, c);
 702:	02500593          	li	a1,37
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	dac080e7          	jalr	-596(ra) # 4b4 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	bd4d                	j	5c4 <vprintf+0x42>
        putc(fd, '%');
 714:	02500593          	li	a1,37
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	d9a080e7          	jalr	-614(ra) # 4b4 <putc>
        putc(fd, c);
 722:	85ca                	mv	a1,s2
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	d8e080e7          	jalr	-626(ra) # 4b4 <putc>
      state = 0;
 72e:	4981                	li	s3,0
 730:	bd51                	j	5c4 <vprintf+0x42>
        s = va_arg(ap, char *);
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	b579                	j	5c4 <vprintf+0x42>
 738:	74e2                	ld	s1,56(sp)
 73a:	79a2                	ld	s3,40(sp)
 73c:	7a02                	ld	s4,32(sp)
 73e:	6ae2                	ld	s5,24(sp)
 740:	6b42                	ld	s6,16(sp)
 742:	6ba2                	ld	s7,8(sp)
    }
  }
}
 744:	60a6                	ld	ra,72(sp)
 746:	6406                	ld	s0,64(sp)
 748:	7942                	ld	s2,48(sp)
 74a:	6161                	addi	sp,sp,80
 74c:	8082                	ret

000000000000074e <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 74e:	715d                	addi	sp,sp,-80
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e010                	sd	a2,0(s0)
 758:	e414                	sd	a3,8(s0)
 75a:	e818                	sd	a4,16(s0)
 75c:	ec1c                	sd	a5,24(s0)
 75e:	03043023          	sd	a6,32(s0)
 762:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76a:	8622                	mv	a2,s0
 76c:	00000097          	auipc	ra,0x0
 770:	e16080e7          	jalr	-490(ra) # 582 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void printf(const char *fmt, ...) {
 77c:	711d                	addi	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	addi	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	00000097          	auipc	ra,0x0
 7a6:	de0080e7          	jalr	-544(ra) # 582 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a02d                	j	7ee <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	a83d                	j	810 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	a091                	j	824 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x3a>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x4a>
void free(void *ap) {
 7ec:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x30>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	fae60de3          	beq	a2,a4,7c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	fae68ae3          	beq	a3,a4,7d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 840:	02051493          	slli	s1,a0,0x20
 844:	9081                	srli	s1,s1,0x20
 846:	04bd                	addi	s1,s1,15
 848:	8091                	srli	s1,s1,0x4
 84a:	0014899b          	addiw	s3,s1,1
 84e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 850:	00000517          	auipc	a0,0x0
 854:	7b053503          	ld	a0,1968(a0) # 1000 <freep>
 858:	c915                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 85a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 85c:	4798                	lw	a4,8(a5)
 85e:	08977e63          	bgeu	a4,s1,8fa <malloc+0xc6>
 862:	f04a                	sd	s2,32(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	78090913          	addi	s2,s2,1920 # 1000 <freep>
  if (p == (char *)-1) return 0;
 888:	5afd                	li	s5,-1
 88a:	a091                	j	8ce <malloc+0x9a>
 88c:	f04a                	sd	s2,32(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8aa:	b7c1                	j	86a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a08d                	j	912 <malloc+0xde>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	00000097          	auipc	ra,0x0
 8bc:	efa080e7          	jalr	-262(ra) # 7b2 <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 8c4:	c13d                	beqz	a0,92a <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c8:	4798                	lw	a4,8(a5)
 8ca:	02977463          	bgeu	a4,s1,8f2 <malloc+0xbe>
    if (p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	00000097          	auipc	ra,0x0
 8de:	bba080e7          	jalr	-1094(ra) # 494 <sbrk>
  if (p == (char *)-1) return 0;
 8e2:	fd5518e3          	bne	a0,s5,8b2 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 8e6:	4501                	li	a0,0
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	a03d                	j	91e <malloc+0xea>
 8f2:	7902                	ld	s2,32(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8fa:	fae489e3          	beq	s1,a4,8ac <malloc+0x78>
        p->s.size -= nunits;
 8fe:	4137073b          	subw	a4,a4,s3
 902:	c798                	sw	a4,8(a5)
        p += p->s.size;
 904:	02071693          	slli	a3,a4,0x20
 908:	01c6d713          	srli	a4,a3,0x1c
 90c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 912:	00000717          	auipc	a4,0x0
 916:	6ea73723          	sd	a0,1774(a4) # 1000 <freep>
      return (void *)(p + 1);
 91a:	01078513          	addi	a0,a5,16
  }
}
 91e:	70e2                	ld	ra,56(sp)
 920:	7442                	ld	s0,48(sp)
 922:	74a2                	ld	s1,40(sp)
 924:	69e2                	ld	s3,24(sp)
 926:	6121                	addi	sp,sp,64
 928:	8082                	ret
 92a:	7902                	ld	s2,32(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	b7f5                	j	91e <malloc+0xea>

0000000000000934 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 934:	4909                	li	s2,2
  li s3, 3
 936:	498d                	li	s3,3
  li s4, 4
 938:	4a11                	li	s4,4
  li s5, 5
 93a:	4a95                	li	s5,5
  li s6, 6
 93c:	4b19                	li	s6,6
  li s7, 7
 93e:	4b9d                	li	s7,7
  li s8, 8
 940:	4c21                	li	s8,8
  li s9, 9
 942:	4ca5                	li	s9,9
  li s10, 10
 944:	4d29                	li	s10,10
  li s11, 11
 946:	4dad                	li	s11,11
  li a7, SYS_write
 948:	48c1                	li	a7,16
  ecall
 94a:	00000073          	ecall
  j loop
 94e:	a82d                	j	988 <loop>

0000000000000950 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 950:	4911                	li	s2,4
  li s3, 9
 952:	49a5                	li	s3,9
  li s4, 16
 954:	4a41                	li	s4,16
  li s5, 25
 956:	4ae5                	li	s5,25
  li s6, 36
 958:	02400b13          	li	s6,36
  li s7, 49
 95c:	03100b93          	li	s7,49
  li s8, 64
 960:	04000c13          	li	s8,64
  li s9, 81
 964:	05100c93          	li	s9,81
  li s10, 100
 968:	06400d13          	li	s10,100
  li s11, 121
 96c:	07900d93          	li	s11,121
  li a7, SYS_write
 970:	48c1                	li	a7,16
  ecall
 972:	00000073          	ecall
  j loop
 976:	a809                	j	988 <loop>

0000000000000978 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 978:	53900913          	li	s2,1337
  mv a2, a1
 97c:	862e                	mv	a2,a1
  li a1, 2
 97e:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 980:	48d9                	li	a7,22
  ecall
 982:	00000073          	ecall
#endif
  ret
 986:	8082                	ret

0000000000000988 <loop>:

loop:
  j loop
 988:	a001                	j	988 <loop>
  ret
 98a:	8082                	ret
