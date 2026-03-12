
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <get_msg>:
#include "user/user.h"

void get_msg(int fd) {
   0:	de010113          	addi	sp,sp,-544
   4:	20113c23          	sd	ra,536(sp)
   8:	20813823          	sd	s0,528(sp)
   c:	20913423          	sd	s1,520(sp)
  10:	21213023          	sd	s2,512(sp)
  14:	1400                	addi	s0,sp,544
  16:	892a                	mv	s2,a0
  char buf[512];
  int n;
  printf("%d: got ", getpid());
  18:	00000097          	auipc	ra,0x0
  1c:	538080e7          	jalr	1336(ra) # 550 <getpid>
  20:	85aa                	mv	a1,a0
  22:	00001517          	auipc	a0,0x1
  26:	a2e50513          	addi	a0,a0,-1490 # a50 <loop+0x4>
  2a:	00001097          	auipc	ra,0x1
  2e:	816080e7          	jalr	-2026(ra) # 840 <printf>
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  32:	20000613          	li	a2,512
  36:	de040593          	addi	a1,s0,-544
  3a:	854a                	mv	a0,s2
  3c:	00000097          	auipc	ra,0x0
  40:	4ac080e7          	jalr	1196(ra) # 4e8 <read>
  44:	84aa                	mv	s1,a0
  46:	02a05a63          	blez	a0,7a <get_msg+0x7a>
    if (write(1, buf, n) != n) {
  4a:	8626                	mv	a2,s1
  4c:	de040593          	addi	a1,s0,-544
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	49e080e7          	jalr	1182(ra) # 4f0 <write>
  5a:	fc950ce3          	beq	a0,s1,32 <get_msg+0x32>
      fprintf(2, "Error in writing msg\n");
  5e:	00001597          	auipc	a1,0x1
  62:	a0258593          	addi	a1,a1,-1534 # a60 <loop+0x14>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	7aa080e7          	jalr	1962(ra) # 812 <fprintf>
      exit(1);
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	45e080e7          	jalr	1118(ra) # 4d0 <exit>
    }
  }
  write(1, "\n", 1);
  7a:	4605                	li	a2,1
  7c:	00001597          	auipc	a1,0x1
  80:	9fc58593          	addi	a1,a1,-1540 # a78 <loop+0x2c>
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	46a080e7          	jalr	1130(ra) # 4f0 <write>
}
  8e:	21813083          	ld	ra,536(sp)
  92:	21013403          	ld	s0,528(sp)
  96:	20813483          	ld	s1,520(sp)
  9a:	20013903          	ld	s2,512(sp)
  9e:	22010113          	addi	sp,sp,544
  a2:	8082                	ret

00000000000000a4 <main>:

int main() {
  a4:	1101                	addi	sp,sp,-32
  a6:	ec06                	sd	ra,24(sp)
  a8:	e822                	sd	s0,16(sp)
  aa:	1000                	addi	s0,sp,32
  int fd1[2];
  int fd2[2];
  if (pipe(fd1) == -1 || pipe(fd2) == -1) {
  ac:	fe840513          	addi	a0,s0,-24
  b0:	00000097          	auipc	ra,0x0
  b4:	430080e7          	jalr	1072(ra) # 4e0 <pipe>
  b8:	57fd                	li	a5,-1
  ba:	00f50b63          	beq	a0,a5,d0 <main+0x2c>
  be:	fe040513          	addi	a0,s0,-32
  c2:	00000097          	auipc	ra,0x0
  c6:	41e080e7          	jalr	1054(ra) # 4e0 <pipe>
  ca:	57fd                	li	a5,-1
  cc:	02f51063          	bne	a0,a5,ec <main+0x48>
    fprintf(2, "Error in pipe");
  d0:	00001597          	auipc	a1,0x1
  d4:	9b058593          	addi	a1,a1,-1616 # a80 <loop+0x34>
  d8:	4509                	li	a0,2
  da:	00000097          	auipc	ra,0x0
  de:	738080e7          	jalr	1848(ra) # 812 <fprintf>
    exit(1);
  e2:	4505                	li	a0,1
  e4:	00000097          	auipc	ra,0x0
  e8:	3ec080e7          	jalr	1004(ra) # 4d0 <exit>
  }
  int pid = fork();
  ec:	00000097          	auipc	ra,0x0
  f0:	3dc080e7          	jalr	988(ra) # 4c8 <fork>
  if (pid > 0) {
  f4:	04a04d63          	bgtz	a0,14e <main+0xaa>

    wait(0);

    get_msg(fd2[0]);
    close(fd2[0]);
  } else if (pid == 0) {
  f8:	ed55                	bnez	a0,1b4 <main+0x110>
    close(fd1[1]);
  fa:	fec42503          	lw	a0,-20(s0)
  fe:	00000097          	auipc	ra,0x0
 102:	3fa080e7          	jalr	1018(ra) # 4f8 <close>
    close(fd2[0]);
 106:	fe042503          	lw	a0,-32(s0)
 10a:	00000097          	auipc	ra,0x0
 10e:	3ee080e7          	jalr	1006(ra) # 4f8 <close>

    get_msg(fd1[0]);
 112:	fe842503          	lw	a0,-24(s0)
 116:	00000097          	auipc	ra,0x0
 11a:	eea080e7          	jalr	-278(ra) # 0 <get_msg>
    close(fd1[0]);
 11e:	fe842503          	lw	a0,-24(s0)
 122:	00000097          	auipc	ra,0x0
 126:	3d6080e7          	jalr	982(ra) # 4f8 <close>

    write(fd2[1], "pong", 4);
 12a:	4611                	li	a2,4
 12c:	00001597          	auipc	a1,0x1
 130:	96c58593          	addi	a1,a1,-1684 # a98 <loop+0x4c>
 134:	fe442503          	lw	a0,-28(s0)
 138:	00000097          	auipc	ra,0x0
 13c:	3b8080e7          	jalr	952(ra) # 4f0 <write>
    close(fd2[1]);
 140:	fe442503          	lw	a0,-28(s0)
 144:	00000097          	auipc	ra,0x0
 148:	3b4080e7          	jalr	948(ra) # 4f8 <close>
 14c:	a8b9                	j	1aa <main+0x106>
    close(fd1[0]);
 14e:	fe842503          	lw	a0,-24(s0)
 152:	00000097          	auipc	ra,0x0
 156:	3a6080e7          	jalr	934(ra) # 4f8 <close>
    close(fd2[1]);
 15a:	fe442503          	lw	a0,-28(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	39a080e7          	jalr	922(ra) # 4f8 <close>
    write(fd1[1], "ping", 4);
 166:	4611                	li	a2,4
 168:	00001597          	auipc	a1,0x1
 16c:	92858593          	addi	a1,a1,-1752 # a90 <loop+0x44>
 170:	fec42503          	lw	a0,-20(s0)
 174:	00000097          	auipc	ra,0x0
 178:	37c080e7          	jalr	892(ra) # 4f0 <write>
    close(fd1[1]);
 17c:	fec42503          	lw	a0,-20(s0)
 180:	00000097          	auipc	ra,0x0
 184:	378080e7          	jalr	888(ra) # 4f8 <close>
    wait(0);
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	34e080e7          	jalr	846(ra) # 4d8 <wait>
    get_msg(fd2[0]);
 192:	fe042503          	lw	a0,-32(s0)
 196:	00000097          	auipc	ra,0x0
 19a:	e6a080e7          	jalr	-406(ra) # 0 <get_msg>
    close(fd2[0]);
 19e:	fe042503          	lw	a0,-32(s0)
 1a2:	00000097          	auipc	ra,0x0
 1a6:	356080e7          	jalr	854(ra) # 4f8 <close>
  } else {
    fprintf(2, "Fork error\n");
    exit(1);
  }
  exit(0);
 1aa:	4501                	li	a0,0
 1ac:	00000097          	auipc	ra,0x0
 1b0:	324080e7          	jalr	804(ra) # 4d0 <exit>
    fprintf(2, "Fork error\n");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	8ec58593          	addi	a1,a1,-1812 # aa0 <loop+0x54>
 1bc:	4509                	li	a0,2
 1be:	00000097          	auipc	ra,0x0
 1c2:	654080e7          	jalr	1620(ra) # 812 <fprintf>
    exit(1);
 1c6:	4505                	li	a0,1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	308080e7          	jalr	776(ra) # 4d0 <exit>

00000000000001d0 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e406                	sd	ra,8(sp)
 1d4:	e022                	sd	s0,0(sp)
 1d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1d8:	00000097          	auipc	ra,0x0
 1dc:	ecc080e7          	jalr	-308(ra) # a4 <main>
  exit(0);
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	2ee080e7          	jalr	750(ra) # 4d0 <exit>

00000000000001ea <strcpy>:
}

char *strcpy(char *s, const char *t) {
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 1f0:	87aa                	mv	a5,a0
 1f2:	0585                	addi	a1,a1,1
 1f4:	0785                	addi	a5,a5,1
 1f6:	fff5c703          	lbu	a4,-1(a1)
 1fa:	fee78fa3          	sb	a4,-1(a5)
 1fe:	fb75                	bnez	a4,1f2 <strcpy+0x8>
  return os;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strcmp>:

int strcmp(const char *p, const char *q) {
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 20c:	00054783          	lbu	a5,0(a0)
 210:	cb91                	beqz	a5,224 <strcmp+0x1e>
 212:	0005c703          	lbu	a4,0(a1)
 216:	00f71763          	bne	a4,a5,224 <strcmp+0x1e>
 21a:	0505                	addi	a0,a0,1
 21c:	0585                	addi	a1,a1,1
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbe5                	bnez	a5,212 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 224:	0005c503          	lbu	a0,0(a1)
}
 228:	40a7853b          	subw	a0,a5,a0
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strlen>:

uint strlen(const char *s) {
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 238:	00054783          	lbu	a5,0(a0)
 23c:	cf91                	beqz	a5,258 <strlen+0x26>
 23e:	0505                	addi	a0,a0,1
 240:	87aa                	mv	a5,a0
 242:	86be                	mv	a3,a5
 244:	0785                	addi	a5,a5,1
 246:	fff7c703          	lbu	a4,-1(a5)
 24a:	ff65                	bnez	a4,242 <strlen+0x10>
 24c:	40a6853b          	subw	a0,a3,a0
 250:	2505                	addiw	a0,a0,1
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  for (n = 0; s[n]; n++);
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strlen+0x20>

000000000000025c <memset>:

void *memset(void *dst, int c, uint n) {
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 262:	ca19                	beqz	a2,278 <memset+0x1c>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x12>
  }
  return dst;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <strchr>:

char *strchr(const char *s, char c) {
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  for (; *s; s++)
 284:	00054783          	lbu	a5,0(a0)
 288:	cb99                	beqz	a5,29e <strchr+0x20>
    if (*s == c) return (char *)s;
 28a:	00f58763          	beq	a1,a5,298 <strchr+0x1a>
  for (; *s; s++)
 28e:	0505                	addi	a0,a0,1
 290:	00054783          	lbu	a5,0(a0)
 294:	fbfd                	bnez	a5,28a <strchr+0xc>
  return 0;
 296:	4501                	li	a0,0
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <strchr+0x1a>

00000000000002a2 <gets>:

char *gets(char *buf, int max) {
 2a2:	711d                	addi	sp,sp,-96
 2a4:	ec86                	sd	ra,88(sp)
 2a6:	e8a2                	sd	s0,80(sp)
 2a8:	e4a6                	sd	s1,72(sp)
 2aa:	e0ca                	sd	s2,64(sp)
 2ac:	fc4e                	sd	s3,56(sp)
 2ae:	f852                	sd	s4,48(sp)
 2b0:	f456                	sd	s5,40(sp)
 2b2:	f05a                	sd	s6,32(sp)
 2b4:	ec5e                	sd	s7,24(sp)
 2b6:	1080                	addi	s0,sp,96
 2b8:	8baa                	mv	s7,a0
 2ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 2bc:	892a                	mv	s2,a0
 2be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 2c0:	4aa9                	li	s5,10
 2c2:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 2c4:	89a6                	mv	s3,s1
 2c6:	2485                	addiw	s1,s1,1
 2c8:	0344d863          	bge	s1,s4,2f8 <gets+0x56>
    cc = read(0, &c, 1);
 2cc:	4605                	li	a2,1
 2ce:	faf40593          	addi	a1,s0,-81
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	214080e7          	jalr	532(ra) # 4e8 <read>
    if (cc < 1) break;
 2dc:	00a05e63          	blez	a0,2f8 <gets+0x56>
    buf[i++] = c;
 2e0:	faf44783          	lbu	a5,-81(s0)
 2e4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 2e8:	01578763          	beq	a5,s5,2f6 <gets+0x54>
 2ec:	0905                	addi	s2,s2,1
 2ee:	fd679be3          	bne	a5,s6,2c4 <gets+0x22>
    buf[i++] = c;
 2f2:	89a6                	mv	s3,s1
 2f4:	a011                	j	2f8 <gets+0x56>
 2f6:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 2f8:	99de                	add	s3,s3,s7
 2fa:	00098023          	sb	zero,0(s3)
  return buf;
}
 2fe:	855e                	mv	a0,s7
 300:	60e6                	ld	ra,88(sp)
 302:	6446                	ld	s0,80(sp)
 304:	64a6                	ld	s1,72(sp)
 306:	6906                	ld	s2,64(sp)
 308:	79e2                	ld	s3,56(sp)
 30a:	7a42                	ld	s4,48(sp)
 30c:	7aa2                	ld	s5,40(sp)
 30e:	7b02                	ld	s6,32(sp)
 310:	6be2                	ld	s7,24(sp)
 312:	6125                	addi	sp,sp,96
 314:	8082                	ret

0000000000000316 <stat>:

int stat(const char *n, struct stat *st) {
 316:	1101                	addi	sp,sp,-32
 318:	ec06                	sd	ra,24(sp)
 31a:	e822                	sd	s0,16(sp)
 31c:	e04a                	sd	s2,0(sp)
 31e:	1000                	addi	s0,sp,32
 320:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 322:	4581                	li	a1,0
 324:	00000097          	auipc	ra,0x0
 328:	1ec080e7          	jalr	492(ra) # 510 <open>
  if (fd < 0) return -1;
 32c:	02054663          	bltz	a0,358 <stat+0x42>
 330:	e426                	sd	s1,8(sp)
 332:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 334:	85ca                	mv	a1,s2
 336:	00000097          	auipc	ra,0x0
 33a:	1f2080e7          	jalr	498(ra) # 528 <fstat>
 33e:	892a                	mv	s2,a0
  close(fd);
 340:	8526                	mv	a0,s1
 342:	00000097          	auipc	ra,0x0
 346:	1b6080e7          	jalr	438(ra) # 4f8 <close>
  return r;
 34a:	64a2                	ld	s1,8(sp)
}
 34c:	854a                	mv	a0,s2
 34e:	60e2                	ld	ra,24(sp)
 350:	6442                	ld	s0,16(sp)
 352:	6902                	ld	s2,0(sp)
 354:	6105                	addi	sp,sp,32
 356:	8082                	ret
  if (fd < 0) return -1;
 358:	597d                	li	s2,-1
 35a:	bfcd                	j	34c <stat+0x36>

000000000000035c <atoi>:

int atoi(const char *s) {
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 362:	00054683          	lbu	a3,0(a0)
 366:	fd06879b          	addiw	a5,a3,-48
 36a:	0ff7f793          	zext.b	a5,a5
 36e:	4625                	li	a2,9
 370:	02f66863          	bltu	a2,a5,3a0 <atoi+0x44>
 374:	872a                	mv	a4,a0
  n = 0;
 376:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 378:	0705                	addi	a4,a4,1
 37a:	0025179b          	slliw	a5,a0,0x2
 37e:	9fa9                	addw	a5,a5,a0
 380:	0017979b          	slliw	a5,a5,0x1
 384:	9fb5                	addw	a5,a5,a3
 386:	fd07851b          	addiw	a0,a5,-48
 38a:	00074683          	lbu	a3,0(a4)
 38e:	fd06879b          	addiw	a5,a3,-48
 392:	0ff7f793          	zext.b	a5,a5
 396:	fef671e3          	bgeu	a2,a5,378 <atoi+0x1c>
  return n;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  n = 0;
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <atoi+0x3e>

00000000000003a4 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3aa:	02b57463          	bgeu	a0,a1,3d2 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 3ae:	00c05f63          	blez	a2,3cc <memmove+0x28>
 3b2:	1602                	slli	a2,a2,0x20
 3b4:	9201                	srli	a2,a2,0x20
 3b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ba:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 3bc:	0585                	addi	a1,a1,1
 3be:	0705                	addi	a4,a4,1
 3c0:	fff5c683          	lbu	a3,-1(a1)
 3c4:	fed70fa3          	sb	a3,-1(a4)
 3c8:	fef71ae3          	bne	a4,a5,3bc <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret
    dst += n;
 3d2:	00c50733          	add	a4,a0,a2
    src += n;
 3d6:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 3d8:	fec05ae3          	blez	a2,3cc <memmove+0x28>
 3dc:	fff6079b          	addiw	a5,a2,-1
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	fff7c793          	not	a5,a5
 3e8:	97ba                	add	a5,a5,a4
 3ea:	15fd                	addi	a1,a1,-1
 3ec:	177d                	addi	a4,a4,-1
 3ee:	0005c683          	lbu	a3,0(a1)
 3f2:	00d70023          	sb	a3,0(a4)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x46>
 3fa:	bfc9                	j	3cc <memmove+0x28>

00000000000003fc <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e422                	sd	s0,8(sp)
 400:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 402:	ca05                	beqz	a2,432 <memcmp+0x36>
 404:	fff6069b          	addiw	a3,a2,-1
 408:	1682                	slli	a3,a3,0x20
 40a:	9281                	srli	a3,a3,0x20
 40c:	0685                	addi	a3,a3,1
 40e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 410:	00054783          	lbu	a5,0(a0)
 414:	0005c703          	lbu	a4,0(a1)
 418:	00e79863          	bne	a5,a4,428 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 41c:	0505                	addi	a0,a0,1
    p2++;
 41e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 420:	fed518e3          	bne	a0,a3,410 <memcmp+0x14>
  }
  return 0;
 424:	4501                	li	a0,0
 426:	a019                	j	42c <memcmp+0x30>
      return *p1 - *p2;
 428:	40e7853b          	subw	a0,a5,a4
}
 42c:	6422                	ld	s0,8(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
  return 0;
 432:	4501                	li	a0,0
 434:	bfe5                	j	42c <memcmp+0x30>

0000000000000436 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 436:	1141                	addi	sp,sp,-16
 438:	e406                	sd	ra,8(sp)
 43a:	e022                	sd	s0,0(sp)
 43c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 43e:	00000097          	auipc	ra,0x0
 442:	f66080e7          	jalr	-154(ra) # 3a4 <memmove>
}
 446:	60a2                	ld	ra,8(sp)
 448:	6402                	ld	s0,0(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret

000000000000044e <strcat>:

char *strcat(char *dst, const char *src) {
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 454:	00054783          	lbu	a5,0(a0)
 458:	c385                	beqz	a5,478 <strcat+0x2a>
  char *p = dst;
 45a:	87aa                	mv	a5,a0
  while (*p) p++;
 45c:	0785                	addi	a5,a5,1
 45e:	0007c703          	lbu	a4,0(a5)
 462:	ff6d                	bnez	a4,45c <strcat+0xe>
  while ((*p++ = *src++));
 464:	0585                	addi	a1,a1,1
 466:	0785                	addi	a5,a5,1
 468:	fff5c703          	lbu	a4,-1(a1)
 46c:	fee78fa3          	sb	a4,-1(a5)
 470:	fb75                	bnez	a4,464 <strcat+0x16>
  return dst;
}
 472:	6422                	ld	s0,8(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret
  char *p = dst;
 478:	87aa                	mv	a5,a0
 47a:	b7ed                	j	464 <strcat+0x16>

000000000000047c <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 482:	0005c783          	lbu	a5,0(a1)
 486:	cf95                	beqz	a5,4c2 <strstr+0x46>

  for (; *haystack; haystack++) {
 488:	00054783          	lbu	a5,0(a0)
 48c:	eb91                	bnez	a5,4a0 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 48e:	4501                	li	a0,0
 490:	a80d                	j	4c2 <strstr+0x46>
    if (!*n) return (char *)haystack;
 492:	0007c783          	lbu	a5,0(a5)
 496:	c795                	beqz	a5,4c2 <strstr+0x46>
  for (; *haystack; haystack++) {
 498:	0505                	addi	a0,a0,1
 49a:	00054783          	lbu	a5,0(a0)
 49e:	c38d                	beqz	a5,4c0 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 4a0:	00054703          	lbu	a4,0(a0)
    n = needle;
 4a4:	87ae                	mv	a5,a1
    h = haystack;
 4a6:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 4a8:	db65                	beqz	a4,498 <strstr+0x1c>
 4aa:	0007c683          	lbu	a3,0(a5)
 4ae:	ca91                	beqz	a3,4c2 <strstr+0x46>
 4b0:	fee691e3          	bne	a3,a4,492 <strstr+0x16>
      h++;
 4b4:	0605                	addi	a2,a2,1
      n++;
 4b6:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 4b8:	00064703          	lbu	a4,0(a2)
 4bc:	f77d                	bnez	a4,4aa <strstr+0x2e>
 4be:	bfd1                	j	492 <strstr+0x16>
  return 0;
 4c0:	4501                	li	a0,0
}
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret

00000000000004c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c8:	4885                	li	a7,1
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d0:	4889                	li	a7,2
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d8:	488d                	li	a7,3
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e0:	4891                	li	a7,4
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <read>:
.global read
read:
 li a7, SYS_read
 4e8:	4895                	li	a7,5
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <write>:
.global write
write:
 li a7, SYS_write
 4f0:	48c1                	li	a7,16
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <close>:
.global close
close:
 li a7, SYS_close
 4f8:	48d5                	li	a7,21
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <kill>:
.global kill
kill:
 li a7, SYS_kill
 500:	4899                	li	a7,6
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <exec>:
.global exec
exec:
 li a7, SYS_exec
 508:	489d                	li	a7,7
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <open>:
.global open
open:
 li a7, SYS_open
 510:	48bd                	li	a7,15
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 518:	48c5                	li	a7,17
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 520:	48c9                	li	a7,18
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 528:	48a1                	li	a7,8
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <link>:
.global link
link:
 li a7, SYS_link
 530:	48cd                	li	a7,19
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 538:	48d1                	li	a7,20
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 540:	48a5                	li	a7,9
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <dup>:
.global dup
dup:
 li a7, SYS_dup
 548:	48a9                	li	a7,10
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 550:	48ad                	li	a7,11
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 558:	48b1                	li	a7,12
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 560:	48b5                	li	a7,13
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 568:	48b9                	li	a7,14
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <reg>:
.global reg
reg:
 li a7, SYS_reg
 570:	48d9                	li	a7,22
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	00000097          	auipc	ra,0x0
 58e:	f66080e7          	jalr	-154(ra) # 4f0 <write>
 592:	60e2                	ld	ra,24(sp)
 594:	6442                	ld	s0,16(sp)
 596:	6105                	addi	sp,sp,32
 598:	8082                	ret

000000000000059a <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 59a:	7139                	addi	sp,sp,-64
 59c:	fc06                	sd	ra,56(sp)
 59e:	f822                	sd	s0,48(sp)
 5a0:	f426                	sd	s1,40(sp)
 5a2:	0080                	addi	s0,sp,64
 5a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 5a6:	c299                	beqz	a3,5ac <printint+0x12>
 5a8:	0805cb63          	bltz	a1,63e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ac:	2581                	sext.w	a1,a1
  neg = 0;
 5ae:	4881                	li	a7,0
 5b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5b6:	2601                	sext.w	a2,a2
 5b8:	00000517          	auipc	a0,0x0
 5bc:	55850513          	addi	a0,a0,1368 # b10 <digits>
 5c0:	883a                	mv	a6,a4
 5c2:	2705                	addiw	a4,a4,1
 5c4:	02c5f7bb          	remuw	a5,a1,a2
 5c8:	1782                	slli	a5,a5,0x20
 5ca:	9381                	srli	a5,a5,0x20
 5cc:	97aa                	add	a5,a5,a0
 5ce:	0007c783          	lbu	a5,0(a5)
 5d2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5d6:	0005879b          	sext.w	a5,a1
 5da:	02c5d5bb          	divuw	a1,a1,a2
 5de:	0685                	addi	a3,a3,1
 5e0:	fec7f0e3          	bgeu	a5,a2,5c0 <printint+0x26>
  if (neg) buf[i++] = '-';
 5e4:	00088c63          	beqz	a7,5fc <printint+0x62>
 5e8:	fd070793          	addi	a5,a4,-48
 5ec:	00878733          	add	a4,a5,s0
 5f0:	02d00793          	li	a5,45
 5f4:	fef70823          	sb	a5,-16(a4)
 5f8:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 5fc:	02e05c63          	blez	a4,634 <printint+0x9a>
 600:	f04a                	sd	s2,32(sp)
 602:	ec4e                	sd	s3,24(sp)
 604:	fc040793          	addi	a5,s0,-64
 608:	00e78933          	add	s2,a5,a4
 60c:	fff78993          	addi	s3,a5,-1
 610:	99ba                	add	s3,s3,a4
 612:	377d                	addiw	a4,a4,-1
 614:	1702                	slli	a4,a4,0x20
 616:	9301                	srli	a4,a4,0x20
 618:	40e989b3          	sub	s3,s3,a4
 61c:	fff94583          	lbu	a1,-1(s2)
 620:	8526                	mv	a0,s1
 622:	00000097          	auipc	ra,0x0
 626:	f56080e7          	jalr	-170(ra) # 578 <putc>
 62a:	197d                	addi	s2,s2,-1
 62c:	ff3918e3          	bne	s2,s3,61c <printint+0x82>
 630:	7902                	ld	s2,32(sp)
 632:	69e2                	ld	s3,24(sp)
}
 634:	70e2                	ld	ra,56(sp)
 636:	7442                	ld	s0,48(sp)
 638:	74a2                	ld	s1,40(sp)
 63a:	6121                	addi	sp,sp,64
 63c:	8082                	ret
    x = -xx;
 63e:	40b005bb          	negw	a1,a1
    neg = 1;
 642:	4885                	li	a7,1
    x = -xx;
 644:	b7b5                	j	5b0 <printint+0x16>

0000000000000646 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 646:	715d                	addi	sp,sp,-80
 648:	e486                	sd	ra,72(sp)
 64a:	e0a2                	sd	s0,64(sp)
 64c:	f84a                	sd	s2,48(sp)
 64e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 650:	0005c903          	lbu	s2,0(a1)
 654:	1a090a63          	beqz	s2,808 <vprintf+0x1c2>
 658:	fc26                	sd	s1,56(sp)
 65a:	f44e                	sd	s3,40(sp)
 65c:	f052                	sd	s4,32(sp)
 65e:	ec56                	sd	s5,24(sp)
 660:	e85a                	sd	s6,16(sp)
 662:	e45e                	sd	s7,8(sp)
 664:	8aaa                	mv	s5,a0
 666:	8bb2                	mv	s7,a2
 668:	00158493          	addi	s1,a1,1
  state = 0;
 66c:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 66e:	02500a13          	li	s4,37
 672:	4b55                	li	s6,21
 674:	a839                	j	692 <vprintf+0x4c>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	efe080e7          	jalr	-258(ra) # 578 <putc>
 682:	a019                	j	688 <vprintf+0x42>
    } else if (state == '%') {
 684:	01498d63          	beq	s3,s4,69e <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 688:	0485                	addi	s1,s1,1
 68a:	fff4c903          	lbu	s2,-1(s1)
 68e:	16090763          	beqz	s2,7fc <vprintf+0x1b6>
    if (state == 0) {
 692:	fe0999e3          	bnez	s3,684 <vprintf+0x3e>
      if (c == '%') {
 696:	ff4910e3          	bne	s2,s4,676 <vprintf+0x30>
        state = '%';
 69a:	89d2                	mv	s3,s4
 69c:	b7f5                	j	688 <vprintf+0x42>
      if (c == 'd') {
 69e:	13490463          	beq	s2,s4,7c6 <vprintf+0x180>
 6a2:	f9d9079b          	addiw	a5,s2,-99
 6a6:	0ff7f793          	zext.b	a5,a5
 6aa:	12fb6763          	bltu	s6,a5,7d8 <vprintf+0x192>
 6ae:	f9d9079b          	addiw	a5,s2,-99
 6b2:	0ff7f713          	zext.b	a4,a5
 6b6:	12eb6163          	bltu	s6,a4,7d8 <vprintf+0x192>
 6ba:	00271793          	slli	a5,a4,0x2
 6be:	00000717          	auipc	a4,0x0
 6c2:	3fa70713          	addi	a4,a4,1018 # ab8 <loop+0x6c>
 6c6:	97ba                	add	a5,a5,a4
 6c8:	439c                	lw	a5,0(a5)
 6ca:	97ba                	add	a5,a5,a4
 6cc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4685                	li	a3,1
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	ebe080e7          	jalr	-322(ra) # 59a <printint>
 6e4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b745                	j	688 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4629                	li	a2,10
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	ea2080e7          	jalr	-350(ra) # 59a <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	b751                	j	688 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 706:	008b8913          	addi	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4641                	li	a2,16
 70e:	000ba583          	lw	a1,0(s7)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e86080e7          	jalr	-378(ra) # 59a <printint>
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b7a5                	j	688 <vprintf+0x42>
 722:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 724:	008b8c13          	addi	s8,s7,8
 728:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72c:	03000593          	li	a1,48
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e46080e7          	jalr	-442(ra) # 578 <putc>
  putc(fd, 'x');
 73a:	07800593          	li	a1,120
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e38080e7          	jalr	-456(ra) # 578 <putc>
 748:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	00000b97          	auipc	s7,0x0
 74e:	3c6b8b93          	addi	s7,s7,966 # b10 <digits>
 752:	03c9d793          	srli	a5,s3,0x3c
 756:	97de                	add	a5,a5,s7
 758:	0007c583          	lbu	a1,0(a5)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e1a080e7          	jalr	-486(ra) # 578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 766:	0992                	slli	s3,s3,0x4
 768:	397d                	addiw	s2,s2,-1
 76a:	fe0914e3          	bnez	s2,752 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 76e:	8be2                	mv	s7,s8
      state = 0;
 770:	4981                	li	s3,0
 772:	6c02                	ld	s8,0(sp)
 774:	bf11                	j	688 <vprintf+0x42>
        s = va_arg(ap, char *);
 776:	008b8993          	addi	s3,s7,8
 77a:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 77e:	02090163          	beqz	s2,7a0 <vprintf+0x15a>
        while (*s != 0) {
 782:	00094583          	lbu	a1,0(s2)
 786:	c9a5                	beqz	a1,7f6 <vprintf+0x1b0>
          putc(fd, *s);
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	dee080e7          	jalr	-530(ra) # 578 <putc>
          s++;
 792:	0905                	addi	s2,s2,1
        while (*s != 0) {
 794:	00094583          	lbu	a1,0(s2)
 798:	f9e5                	bnez	a1,788 <vprintf+0x142>
        s = va_arg(ap, char *);
 79a:	8bce                	mv	s7,s3
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b5ed                	j	688 <vprintf+0x42>
        if (s == 0) s = "(null)";
 7a0:	00000917          	auipc	s2,0x0
 7a4:	31090913          	addi	s2,s2,784 # ab0 <loop+0x64>
        while (*s != 0) {
 7a8:	02800593          	li	a1,40
 7ac:	bff1                	j	788 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	000bc583          	lbu	a1,0(s7)
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	dc0080e7          	jalr	-576(ra) # 578 <putc>
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b5d1                	j	688 <vprintf+0x42>
        putc(fd, c);
 7c6:	02500593          	li	a1,37
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	dac080e7          	jalr	-596(ra) # 578 <putc>
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	bd4d                	j	688 <vprintf+0x42>
        putc(fd, '%');
 7d8:	02500593          	li	a1,37
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	d9a080e7          	jalr	-614(ra) # 578 <putc>
        putc(fd, c);
 7e6:	85ca                	mv	a1,s2
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	d8e080e7          	jalr	-626(ra) # 578 <putc>
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bd51                	j	688 <vprintf+0x42>
        s = va_arg(ap, char *);
 7f6:	8bce                	mv	s7,s3
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b579                	j	688 <vprintf+0x42>
 7fc:	74e2                	ld	s1,56(sp)
 7fe:	79a2                	ld	s3,40(sp)
 800:	7a02                	ld	s4,32(sp)
 802:	6ae2                	ld	s5,24(sp)
 804:	6b42                	ld	s6,16(sp)
 806:	6ba2                	ld	s7,8(sp)
    }
  }
}
 808:	60a6                	ld	ra,72(sp)
 80a:	6406                	ld	s0,64(sp)
 80c:	7942                	ld	s2,48(sp)
 80e:	6161                	addi	sp,sp,80
 810:	8082                	ret

0000000000000812 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 812:	715d                	addi	sp,sp,-80
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e010                	sd	a2,0(s0)
 81c:	e414                	sd	a3,8(s0)
 81e:	e818                	sd	a4,16(s0)
 820:	ec1c                	sd	a5,24(s0)
 822:	03043023          	sd	a6,32(s0)
 826:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82e:	8622                	mv	a2,s0
 830:	00000097          	auipc	ra,0x0
 834:	e16080e7          	jalr	-490(ra) # 646 <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6161                	addi	sp,sp,80
 83e:	8082                	ret

0000000000000840 <printf>:

void printf(const char *fmt, ...) {
 840:	711d                	addi	sp,sp,-96
 842:	ec06                	sd	ra,24(sp)
 844:	e822                	sd	s0,16(sp)
 846:	1000                	addi	s0,sp,32
 848:	e40c                	sd	a1,8(s0)
 84a:	e810                	sd	a2,16(s0)
 84c:	ec14                	sd	a3,24(s0)
 84e:	f018                	sd	a4,32(s0)
 850:	f41c                	sd	a5,40(s0)
 852:	03043823          	sd	a6,48(s0)
 856:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85a:	00840613          	addi	a2,s0,8
 85e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 862:	85aa                	mv	a1,a0
 864:	4505                	li	a0,1
 866:	00000097          	auipc	ra,0x0
 86a:	de0080e7          	jalr	-544(ra) # 646 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6125                	addi	sp,sp,96
 874:	8082                	ret

0000000000000876 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 876:	1141                	addi	sp,sp,-16
 878:	e422                	sd	s0,8(sp)
 87a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 87c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 880:	00000797          	auipc	a5,0x0
 884:	7807b783          	ld	a5,1920(a5) # 1000 <freep>
 888:	a02d                	j	8b2 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 88a:	4618                	lw	a4,8(a2)
 88c:	9f2d                	addw	a4,a4,a1
 88e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	6310                	ld	a2,0(a4)
 896:	a83d                	j	8d4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9f31                	addw	a4,a4,a2
 89e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a0:	ff053683          	ld	a3,-16(a0)
 8a4:	a091                	j	8e8 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e7e463          	bltu	a5,a4,8b0 <free+0x3a>
 8ac:	00e6ea63          	bltu	a3,a4,8c0 <free+0x4a>
void free(void *ap) {
 8b0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	fed7fae3          	bgeu	a5,a3,8a6 <free+0x30>
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e6e463          	bltu	a3,a4,8c0 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8bc:	fee7eae3          	bltu	a5,a4,8b0 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8c0:	ff852583          	lw	a1,-8(a0)
 8c4:	6390                	ld	a2,0(a5)
 8c6:	02059813          	slli	a6,a1,0x20
 8ca:	01c85713          	srli	a4,a6,0x1c
 8ce:	9736                	add	a4,a4,a3
 8d0:	fae60de3          	beq	a2,a4,88a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8d8:	4790                	lw	a2,8(a5)
 8da:	02061593          	slli	a1,a2,0x20
 8de:	01c5d713          	srli	a4,a1,0x1c
 8e2:	973e                	add	a4,a4,a5
 8e4:	fae68ae3          	beq	a3,a4,898 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
}
 8f2:	6422                	ld	s0,8(sp)
 8f4:	0141                	addi	sp,sp,16
 8f6:	8082                	ret

00000000000008f8 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 8f8:	7139                	addi	sp,sp,-64
 8fa:	fc06                	sd	ra,56(sp)
 8fc:	f822                	sd	s0,48(sp)
 8fe:	f426                	sd	s1,40(sp)
 900:	ec4e                	sd	s3,24(sp)
 902:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 904:	02051493          	slli	s1,a0,0x20
 908:	9081                	srli	s1,s1,0x20
 90a:	04bd                	addi	s1,s1,15
 90c:	8091                	srli	s1,s1,0x4
 90e:	0014899b          	addiw	s3,s1,1
 912:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 914:	00000517          	auipc	a0,0x0
 918:	6ec53503          	ld	a0,1772(a0) # 1000 <freep>
 91c:	c915                	beqz	a0,950 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 91e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 920:	4798                	lw	a4,8(a5)
 922:	08977e63          	bgeu	a4,s1,9be <malloc+0xc6>
 926:	f04a                	sd	s2,32(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 92e:	8a4e                	mv	s4,s3
 930:	0009871b          	sext.w	a4,s3
 934:	6685                	lui	a3,0x1
 936:	00d77363          	bgeu	a4,a3,93c <malloc+0x44>
 93a:	6a05                	lui	s4,0x1
 93c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 940:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 944:	00000917          	auipc	s2,0x0
 948:	6bc90913          	addi	s2,s2,1724 # 1000 <freep>
  if (p == (char *)-1) return 0;
 94c:	5afd                	li	s5,-1
 94e:	a091                	j	992 <malloc+0x9a>
 950:	f04a                	sd	s2,32(sp)
 952:	e852                	sd	s4,16(sp)
 954:	e456                	sd	s5,8(sp)
 956:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 958:	00000797          	auipc	a5,0x0
 95c:	6b878793          	addi	a5,a5,1720 # 1010 <base>
 960:	00000717          	auipc	a4,0x0
 964:	6af73023          	sd	a5,1696(a4) # 1000 <freep>
 968:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 96e:	b7c1                	j	92e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	e118                	sd	a4,0(a0)
 974:	a08d                	j	9d6 <malloc+0xde>
  hp->s.size = nu;
 976:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 97a:	0541                	addi	a0,a0,16
 97c:	00000097          	auipc	ra,0x0
 980:	efa080e7          	jalr	-262(ra) # 876 <free>
  return freep;
 984:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 988:	c13d                	beqz	a0,9ee <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 98a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 98c:	4798                	lw	a4,8(a5)
 98e:	02977463          	bgeu	a4,s1,9b6 <malloc+0xbe>
    if (p == freep)
 992:	00093703          	ld	a4,0(s2)
 996:	853e                	mv	a0,a5
 998:	fef719e3          	bne	a4,a5,98a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 99c:	8552                	mv	a0,s4
 99e:	00000097          	auipc	ra,0x0
 9a2:	bba080e7          	jalr	-1094(ra) # 558 <sbrk>
  if (p == (char *)-1) return 0;
 9a6:	fd5518e3          	bne	a0,s5,976 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 9aa:	4501                	li	a0,0
 9ac:	7902                	ld	s2,32(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	a03d                	j	9e2 <malloc+0xea>
 9b6:	7902                	ld	s2,32(sp)
 9b8:	6a42                	ld	s4,16(sp)
 9ba:	6aa2                	ld	s5,8(sp)
 9bc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9be:	fae489e3          	beq	s1,a4,970 <malloc+0x78>
        p->s.size -= nunits;
 9c2:	4137073b          	subw	a4,a4,s3
 9c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c8:	02071693          	slli	a3,a4,0x20
 9cc:	01c6d713          	srli	a4,a3,0x1c
 9d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d6:	00000717          	auipc	a4,0x0
 9da:	62a73523          	sd	a0,1578(a4) # 1000 <freep>
      return (void *)(p + 1);
 9de:	01078513          	addi	a0,a5,16
  }
}
 9e2:	70e2                	ld	ra,56(sp)
 9e4:	7442                	ld	s0,48(sp)
 9e6:	74a2                	ld	s1,40(sp)
 9e8:	69e2                	ld	s3,24(sp)
 9ea:	6121                	addi	sp,sp,64
 9ec:	8082                	ret
 9ee:	7902                	ld	s2,32(sp)
 9f0:	6a42                	ld	s4,16(sp)
 9f2:	6aa2                	ld	s5,8(sp)
 9f4:	6b02                	ld	s6,0(sp)
 9f6:	b7f5                	j	9e2 <malloc+0xea>

00000000000009f8 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 9f8:	4909                	li	s2,2
  li s3, 3
 9fa:	498d                	li	s3,3
  li s4, 4
 9fc:	4a11                	li	s4,4
  li s5, 5
 9fe:	4a95                	li	s5,5
  li s6, 6
 a00:	4b19                	li	s6,6
  li s7, 7
 a02:	4b9d                	li	s7,7
  li s8, 8
 a04:	4c21                	li	s8,8
  li s9, 9
 a06:	4ca5                	li	s9,9
  li s10, 10
 a08:	4d29                	li	s10,10
  li s11, 11
 a0a:	4dad                	li	s11,11
  li a7, SYS_write
 a0c:	48c1                	li	a7,16
  ecall
 a0e:	00000073          	ecall
  j loop
 a12:	a82d                	j	a4c <loop>

0000000000000a14 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 a14:	4911                	li	s2,4
  li s3, 9
 a16:	49a5                	li	s3,9
  li s4, 16
 a18:	4a41                	li	s4,16
  li s5, 25
 a1a:	4ae5                	li	s5,25
  li s6, 36
 a1c:	02400b13          	li	s6,36
  li s7, 49
 a20:	03100b93          	li	s7,49
  li s8, 64
 a24:	04000c13          	li	s8,64
  li s9, 81
 a28:	05100c93          	li	s9,81
  li s10, 100
 a2c:	06400d13          	li	s10,100
  li s11, 121
 a30:	07900d93          	li	s11,121
  li a7, SYS_write
 a34:	48c1                	li	a7,16
  ecall
 a36:	00000073          	ecall
  j loop
 a3a:	a809                	j	a4c <loop>

0000000000000a3c <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 a3c:	53900913          	li	s2,1337
  mv a2, a1
 a40:	862e                	mv	a2,a1
  li a1, 2
 a42:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 a44:	48d9                	li	a7,22
  ecall
 a46:	00000073          	ecall
#endif
  ret
 a4a:	8082                	ret

0000000000000a4c <loop>:

loop:
  j loop
 a4c:	a001                	j	a4c <loop>
  ret
 a4e:	8082                	ret
