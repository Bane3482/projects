
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:
#include "kernel/fcntl.h"
#include "user/user.h"

char buf[512];

void wc(int fd, char *name) {
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for (i = 0; i < n; i++) {
      c++;
      if (buf[i] == '\n') l++;
  36:	4aa9                	li	s5,10
      if (strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9d8a0a13          	addi	s4,s4,-1576 # a10 <loop+0x4>
        inword = 0;
  40:	4b81                	li	s7,0
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  42:	a805                	j	72 <wc+0x72>
      if (strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for (i = 0; i < n; i++) {
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if (buf[i] == '\n') l++;
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if (!inword) {
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	42c080e7          	jalr	1068(ra) # 4a8 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for (i = 0; i < n; i++) {
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	addi	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if (n < 0) {
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	98a50513          	addi	a0,a0,-1654 # a30 <loop+0x24>
  ae:	00000097          	auipc	ra,0x0
  b2:	752080e7          	jalr	1874(ra) # 800 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	94c50513          	addi	a0,a0,-1716 # a20 <loop+0x14>
  dc:	00000097          	auipc	ra,0x0
  e0:	724080e7          	jalr	1828(ra) # 800 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	3aa080e7          	jalr	938(ra) # 490 <exit>

00000000000000ee <main>:

int main(int argc, char *argv[]) {
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	3b4080e7          	jalr	948(ra) # 4d0 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	380080e7          	jalr	896(ra) # 4b8 <close>
  for (i = 1; i < argc; i++) {
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	348080e7          	jalr	840(ra) # 490 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	8c258593          	addi	a1,a1,-1854 # a18 <loop+0xc>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	326080e7          	jalr	806(ra) # 490 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	8ca50513          	addi	a0,a0,-1846 # a40 <loop+0x34>
 17e:	00000097          	auipc	ra,0x0
 182:	682080e7          	jalr	1666(ra) # 800 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	308080e7          	jalr	776(ra) # 490 <exit>

0000000000000190 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	2ee080e7          	jalr	750(ra) # 490 <exit>

00000000000001aa <strcpy>:
}

char *strcpy(char *s, const char *t) {
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int strcmp(const char *p, const char *q) {
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint strlen(const char *s) {
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	addi	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addiw	a0,a0,1
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for (n = 0; s[n]; n++);
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void *memset(void *dst, int c, uint n) {
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char *strchr(const char *s, char c) {
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for (; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if (*s == c) return (char *)s;
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for (; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char *gets(char *buf, int max) {
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	214080e7          	jalr	532(ra) # 4a8 <read>
    if (cc < 1) break;
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int stat(const char *n, struct stat *st) {
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e04a                	sd	s2,0(sp)
 2de:	1000                	addi	s0,sp,32
 2e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	4581                	li	a1,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	1ec080e7          	jalr	492(ra) # 4d0 <open>
  if (fd < 0) return -1;
 2ec:	02054663          	bltz	a0,318 <stat+0x42>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	1f2080e7          	jalr	498(ra) # 4e8 <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	1b6080e7          	jalr	438(ra) # 4b8 <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
  if (fd < 0) return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x36>

000000000000031c <atoi>:

int atoi(const char *s) {
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 322:	00054683          	lbu	a3,0(a0)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	4625                	li	a2,9
 330:	02f66863          	bltu	a2,a5,360 <atoi+0x44>
 334:	872a                	mv	a4,a0
  n = 0;
 336:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 338:	0705                	addi	a4,a4,1
 33a:	0025179b          	slliw	a5,a0,0x2
 33e:	9fa9                	addw	a5,a5,a0
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb5                	addw	a5,a5,a3
 346:	fd07851b          	addiw	a0,a5,-48
 34a:	00074683          	lbu	a3,0(a4)
 34e:	fd06879b          	addiw	a5,a3,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x1c>
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <atoi+0x3e>

0000000000000364 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36a:	02b57463          	bgeu	a0,a1,392 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 36e:	00c05f63          	blez	a2,38c <memmove+0x28>
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37a:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 37c:	0585                	addi	a1,a1,1
 37e:	0705                	addi	a4,a4,1
 380:	fff5c683          	lbu	a3,-1(a1)
 384:	fed70fa3          	sb	a3,-1(a4)
 388:	fef71ae3          	bne	a4,a5,37c <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
    dst += n;
 392:	00c50733          	add	a4,a0,a2
    src += n;
 396:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 398:	fec05ae3          	blez	a2,38c <memmove+0x28>
 39c:	fff6079b          	addiw	a5,a2,-1
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	fff7c793          	not	a5,a5
 3a8:	97ba                	add	a5,a5,a4
 3aa:	15fd                	addi	a1,a1,-1
 3ac:	177d                	addi	a4,a4,-1
 3ae:	0005c683          	lbu	a3,0(a1)
 3b2:	00d70023          	sb	a3,0(a4)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x46>
 3ba:	bfc9                	j	38c <memmove+0x28>

00000000000003bc <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c2:	ca05                	beqz	a2,3f2 <memcmp+0x36>
 3c4:	fff6069b          	addiw	a3,a2,-1
 3c8:	1682                	slli	a3,a3,0x20
 3ca:	9281                	srli	a3,a3,0x20
 3cc:	0685                	addi	a3,a3,1
 3ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00e79863          	bne	a5,a4,3e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3dc:	0505                	addi	a0,a0,1
    p2++;
 3de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e0:	fed518e3          	bne	a0,a3,3d0 <memcmp+0x14>
  }
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	a019                	j	3ec <memcmp+0x30>
      return *p1 - *p2;
 3e8:	40e7853b          	subw	a0,a5,a4
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <memcmp+0x30>

00000000000003f6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fe:	00000097          	auipc	ra,0x0
 402:	f66080e7          	jalr	-154(ra) # 364 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <strcat>:

char *strcat(char *dst, const char *src) {
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 414:	00054783          	lbu	a5,0(a0)
 418:	c385                	beqz	a5,438 <strcat+0x2a>
  char *p = dst;
 41a:	87aa                	mv	a5,a0
  while (*p) p++;
 41c:	0785                	addi	a5,a5,1
 41e:	0007c703          	lbu	a4,0(a5)
 422:	ff6d                	bnez	a4,41c <strcat+0xe>
  while ((*p++ = *src++));
 424:	0585                	addi	a1,a1,1
 426:	0785                	addi	a5,a5,1
 428:	fff5c703          	lbu	a4,-1(a1)
 42c:	fee78fa3          	sb	a4,-1(a5)
 430:	fb75                	bnez	a4,424 <strcat+0x16>
  return dst;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
  char *p = dst;
 438:	87aa                	mv	a5,a0
 43a:	b7ed                	j	424 <strcat+0x16>

000000000000043c <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 43c:	1141                	addi	sp,sp,-16
 43e:	e422                	sd	s0,8(sp)
 440:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 442:	0005c783          	lbu	a5,0(a1)
 446:	cf95                	beqz	a5,482 <strstr+0x46>

  for (; *haystack; haystack++) {
 448:	00054783          	lbu	a5,0(a0)
 44c:	eb91                	bnez	a5,460 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 44e:	4501                	li	a0,0
 450:	a80d                	j	482 <strstr+0x46>
    if (!*n) return (char *)haystack;
 452:	0007c783          	lbu	a5,0(a5)
 456:	c795                	beqz	a5,482 <strstr+0x46>
  for (; *haystack; haystack++) {
 458:	0505                	addi	a0,a0,1
 45a:	00054783          	lbu	a5,0(a0)
 45e:	c38d                	beqz	a5,480 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 460:	00054703          	lbu	a4,0(a0)
    n = needle;
 464:	87ae                	mv	a5,a1
    h = haystack;
 466:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 468:	db65                	beqz	a4,458 <strstr+0x1c>
 46a:	0007c683          	lbu	a3,0(a5)
 46e:	ca91                	beqz	a3,482 <strstr+0x46>
 470:	fee691e3          	bne	a3,a4,452 <strstr+0x16>
      h++;
 474:	0605                	addi	a2,a2,1
      n++;
 476:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 478:	00064703          	lbu	a4,0(a2)
 47c:	f77d                	bnez	a4,46a <strstr+0x2e>
 47e:	bfd1                	j	452 <strstr+0x16>
  return 0;
 480:	4501                	li	a0,0
}
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret

0000000000000488 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 488:	4885                	li	a7,1
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <exit>:
.global exit
exit:
 li a7, SYS_exit
 490:	4889                	li	a7,2
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <wait>:
.global wait
wait:
 li a7, SYS_wait
 498:	488d                	li	a7,3
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a0:	4891                	li	a7,4
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <read>:
.global read
read:
 li a7, SYS_read
 4a8:	4895                	li	a7,5
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <write>:
.global write
write:
 li a7, SYS_write
 4b0:	48c1                	li	a7,16
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <close>:
.global close
close:
 li a7, SYS_close
 4b8:	48d5                	li	a7,21
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c0:	4899                	li	a7,6
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c8:	489d                	li	a7,7
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <open>:
.global open
open:
 li a7, SYS_open
 4d0:	48bd                	li	a7,15
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d8:	48c5                	li	a7,17
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e0:	48c9                	li	a7,18
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e8:	48a1                	li	a7,8
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <link>:
.global link
link:
 li a7, SYS_link
 4f0:	48cd                	li	a7,19
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f8:	48d1                	li	a7,20
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 500:	48a5                	li	a7,9
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <dup>:
.global dup
dup:
 li a7, SYS_dup
 508:	48a9                	li	a7,10
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 510:	48ad                	li	a7,11
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 518:	48b1                	li	a7,12
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 520:	48b5                	li	a7,13
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 528:	48b9                	li	a7,14
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <reg>:
.global reg
reg:
 li a7, SYS_reg
 530:	48d9                	li	a7,22
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 538:	1101                	addi	sp,sp,-32
 53a:	ec06                	sd	ra,24(sp)
 53c:	e822                	sd	s0,16(sp)
 53e:	1000                	addi	s0,sp,32
 540:	feb407a3          	sb	a1,-17(s0)
 544:	4605                	li	a2,1
 546:	fef40593          	addi	a1,s0,-17
 54a:	00000097          	auipc	ra,0x0
 54e:	f66080e7          	jalr	-154(ra) # 4b0 <write>
 552:	60e2                	ld	ra,24(sp)
 554:	6442                	ld	s0,16(sp)
 556:	6105                	addi	sp,sp,32
 558:	8082                	ret

000000000000055a <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 55a:	7139                	addi	sp,sp,-64
 55c:	fc06                	sd	ra,56(sp)
 55e:	f822                	sd	s0,48(sp)
 560:	f426                	sd	s1,40(sp)
 562:	0080                	addi	s0,sp,64
 564:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 566:	c299                	beqz	a3,56c <printint+0x12>
 568:	0805cb63          	bltz	a1,5fe <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56c:	2581                	sext.w	a1,a1
  neg = 0;
 56e:	4881                	li	a7,0
 570:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 574:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 576:	2601                	sext.w	a2,a2
 578:	00000517          	auipc	a0,0x0
 57c:	54050513          	addi	a0,a0,1344 # ab8 <digits>
 580:	883a                	mv	a6,a4
 582:	2705                	addiw	a4,a4,1
 584:	02c5f7bb          	remuw	a5,a1,a2
 588:	1782                	slli	a5,a5,0x20
 58a:	9381                	srli	a5,a5,0x20
 58c:	97aa                	add	a5,a5,a0
 58e:	0007c783          	lbu	a5,0(a5)
 592:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 596:	0005879b          	sext.w	a5,a1
 59a:	02c5d5bb          	divuw	a1,a1,a2
 59e:	0685                	addi	a3,a3,1
 5a0:	fec7f0e3          	bgeu	a5,a2,580 <printint+0x26>
  if (neg) buf[i++] = '-';
 5a4:	00088c63          	beqz	a7,5bc <printint+0x62>
 5a8:	fd070793          	addi	a5,a4,-48
 5ac:	00878733          	add	a4,a5,s0
 5b0:	02d00793          	li	a5,45
 5b4:	fef70823          	sb	a5,-16(a4)
 5b8:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 5bc:	02e05c63          	blez	a4,5f4 <printint+0x9a>
 5c0:	f04a                	sd	s2,32(sp)
 5c2:	ec4e                	sd	s3,24(sp)
 5c4:	fc040793          	addi	a5,s0,-64
 5c8:	00e78933          	add	s2,a5,a4
 5cc:	fff78993          	addi	s3,a5,-1
 5d0:	99ba                	add	s3,s3,a4
 5d2:	377d                	addiw	a4,a4,-1
 5d4:	1702                	slli	a4,a4,0x20
 5d6:	9301                	srli	a4,a4,0x20
 5d8:	40e989b3          	sub	s3,s3,a4
 5dc:	fff94583          	lbu	a1,-1(s2)
 5e0:	8526                	mv	a0,s1
 5e2:	00000097          	auipc	ra,0x0
 5e6:	f56080e7          	jalr	-170(ra) # 538 <putc>
 5ea:	197d                	addi	s2,s2,-1
 5ec:	ff3918e3          	bne	s2,s3,5dc <printint+0x82>
 5f0:	7902                	ld	s2,32(sp)
 5f2:	69e2                	ld	s3,24(sp)
}
 5f4:	70e2                	ld	ra,56(sp)
 5f6:	7442                	ld	s0,48(sp)
 5f8:	74a2                	ld	s1,40(sp)
 5fa:	6121                	addi	sp,sp,64
 5fc:	8082                	ret
    x = -xx;
 5fe:	40b005bb          	negw	a1,a1
    neg = 1;
 602:	4885                	li	a7,1
    x = -xx;
 604:	b7b5                	j	570 <printint+0x16>

0000000000000606 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 606:	715d                	addi	sp,sp,-80
 608:	e486                	sd	ra,72(sp)
 60a:	e0a2                	sd	s0,64(sp)
 60c:	f84a                	sd	s2,48(sp)
 60e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 610:	0005c903          	lbu	s2,0(a1)
 614:	1a090a63          	beqz	s2,7c8 <vprintf+0x1c2>
 618:	fc26                	sd	s1,56(sp)
 61a:	f44e                	sd	s3,40(sp)
 61c:	f052                	sd	s4,32(sp)
 61e:	ec56                	sd	s5,24(sp)
 620:	e85a                	sd	s6,16(sp)
 622:	e45e                	sd	s7,8(sp)
 624:	8aaa                	mv	s5,a0
 626:	8bb2                	mv	s7,a2
 628:	00158493          	addi	s1,a1,1
  state = 0;
 62c:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 62e:	02500a13          	li	s4,37
 632:	4b55                	li	s6,21
 634:	a839                	j	652 <vprintf+0x4c>
        putc(fd, c);
 636:	85ca                	mv	a1,s2
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	efe080e7          	jalr	-258(ra) # 538 <putc>
 642:	a019                	j	648 <vprintf+0x42>
    } else if (state == '%') {
 644:	01498d63          	beq	s3,s4,65e <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 648:	0485                	addi	s1,s1,1
 64a:	fff4c903          	lbu	s2,-1(s1)
 64e:	16090763          	beqz	s2,7bc <vprintf+0x1b6>
    if (state == 0) {
 652:	fe0999e3          	bnez	s3,644 <vprintf+0x3e>
      if (c == '%') {
 656:	ff4910e3          	bne	s2,s4,636 <vprintf+0x30>
        state = '%';
 65a:	89d2                	mv	s3,s4
 65c:	b7f5                	j	648 <vprintf+0x42>
      if (c == 'd') {
 65e:	13490463          	beq	s2,s4,786 <vprintf+0x180>
 662:	f9d9079b          	addiw	a5,s2,-99
 666:	0ff7f793          	zext.b	a5,a5
 66a:	12fb6763          	bltu	s6,a5,798 <vprintf+0x192>
 66e:	f9d9079b          	addiw	a5,s2,-99
 672:	0ff7f713          	zext.b	a4,a5
 676:	12eb6163          	bltu	s6,a4,798 <vprintf+0x192>
 67a:	00271793          	slli	a5,a4,0x2
 67e:	00000717          	auipc	a4,0x0
 682:	3e270713          	addi	a4,a4,994 # a60 <loop+0x54>
 686:	97ba                	add	a5,a5,a4
 688:	439c                	lw	a5,0(a5)
 68a:	97ba                	add	a5,a5,a4
 68c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 68e:	008b8913          	addi	s2,s7,8
 692:	4685                	li	a3,1
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	ebe080e7          	jalr	-322(ra) # 55a <printint>
 6a4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b745                	j	648 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	ea2080e7          	jalr	-350(ra) # 55a <printint>
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b751                	j	648 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e86080e7          	jalr	-378(ra) # 55a <printint>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b7a5                	j	648 <vprintf+0x42>
 6e2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e4:	008b8c13          	addi	s8,s7,8
 6e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ec:	03000593          	li	a1,48
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e46080e7          	jalr	-442(ra) # 538 <putc>
  putc(fd, 'x');
 6fa:	07800593          	li	a1,120
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e38080e7          	jalr	-456(ra) # 538 <putc>
 708:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	00000b97          	auipc	s7,0x0
 70e:	3aeb8b93          	addi	s7,s7,942 # ab8 <digits>
 712:	03c9d793          	srli	a5,s3,0x3c
 716:	97de                	add	a5,a5,s7
 718:	0007c583          	lbu	a1,0(a5)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e1a080e7          	jalr	-486(ra) # 538 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	397d                	addiw	s2,s2,-1
 72a:	fe0914e3          	bnez	s2,712 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 72e:	8be2                	mv	s7,s8
      state = 0;
 730:	4981                	li	s3,0
 732:	6c02                	ld	s8,0(sp)
 734:	bf11                	j	648 <vprintf+0x42>
        s = va_arg(ap, char *);
 736:	008b8993          	addi	s3,s7,8
 73a:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 73e:	02090163          	beqz	s2,760 <vprintf+0x15a>
        while (*s != 0) {
 742:	00094583          	lbu	a1,0(s2)
 746:	c9a5                	beqz	a1,7b6 <vprintf+0x1b0>
          putc(fd, *s);
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	dee080e7          	jalr	-530(ra) # 538 <putc>
          s++;
 752:	0905                	addi	s2,s2,1
        while (*s != 0) {
 754:	00094583          	lbu	a1,0(s2)
 758:	f9e5                	bnez	a1,748 <vprintf+0x142>
        s = va_arg(ap, char *);
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b5ed                	j	648 <vprintf+0x42>
        if (s == 0) s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	2f890913          	addi	s2,s2,760 # a58 <loop+0x4c>
        while (*s != 0) {
 768:	02800593          	li	a1,40
 76c:	bff1                	j	748 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 76e:	008b8913          	addi	s2,s7,8
 772:	000bc583          	lbu	a1,0(s7)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	dc0080e7          	jalr	-576(ra) # 538 <putc>
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	b5d1                	j	648 <vprintf+0x42>
        putc(fd, c);
 786:	02500593          	li	a1,37
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	dac080e7          	jalr	-596(ra) # 538 <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	bd4d                	j	648 <vprintf+0x42>
        putc(fd, '%');
 798:	02500593          	li	a1,37
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	d9a080e7          	jalr	-614(ra) # 538 <putc>
        putc(fd, c);
 7a6:	85ca                	mv	a1,s2
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	d8e080e7          	jalr	-626(ra) # 538 <putc>
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bd51                	j	648 <vprintf+0x42>
        s = va_arg(ap, char *);
 7b6:	8bce                	mv	s7,s3
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b579                	j	648 <vprintf+0x42>
 7bc:	74e2                	ld	s1,56(sp)
 7be:	79a2                	ld	s3,40(sp)
 7c0:	7a02                	ld	s4,32(sp)
 7c2:	6ae2                	ld	s5,24(sp)
 7c4:	6b42                	ld	s6,16(sp)
 7c6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7c8:	60a6                	ld	ra,72(sp)
 7ca:	6406                	ld	s0,64(sp)
 7cc:	7942                	ld	s2,48(sp)
 7ce:	6161                	addi	sp,sp,80
 7d0:	8082                	ret

00000000000007d2 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 7d2:	715d                	addi	sp,sp,-80
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	addi	s0,sp,32
 7da:	e010                	sd	a2,0(s0)
 7dc:	e414                	sd	a3,8(s0)
 7de:	e818                	sd	a4,16(s0)
 7e0:	ec1c                	sd	a5,24(s0)
 7e2:	03043023          	sd	a6,32(s0)
 7e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ee:	8622                	mv	a2,s0
 7f0:	00000097          	auipc	ra,0x0
 7f4:	e16080e7          	jalr	-490(ra) # 606 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6161                	addi	sp,sp,80
 7fe:	8082                	ret

0000000000000800 <printf>:

void printf(const char *fmt, ...) {
 800:	711d                	addi	sp,sp,-96
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	addi	s0,sp,32
 808:	e40c                	sd	a1,8(s0)
 80a:	e810                	sd	a2,16(s0)
 80c:	ec14                	sd	a3,24(s0)
 80e:	f018                	sd	a4,32(s0)
 810:	f41c                	sd	a5,40(s0)
 812:	03043823          	sd	a6,48(s0)
 816:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	00840613          	addi	a2,s0,8
 81e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 822:	85aa                	mv	a1,a0
 824:	4505                	li	a0,1
 826:	00000097          	auipc	ra,0x0
 82a:	de0080e7          	jalr	-544(ra) # 606 <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6125                	addi	sp,sp,96
 834:	8082                	ret

0000000000000836 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 836:	1141                	addi	sp,sp,-16
 838:	e422                	sd	s0,8(sp)
 83a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 83c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	00000797          	auipc	a5,0x0
 844:	7c07b783          	ld	a5,1984(a5) # 1000 <freep>
 848:	a02d                	j	872 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 84a:	4618                	lw	a4,8(a2)
 84c:	9f2d                	addw	a4,a4,a1
 84e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	6310                	ld	a2,0(a4)
 856:	a83d                	j	894 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9f31                	addw	a4,a4,a2
 85e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053683          	ld	a3,-16(a0)
 864:	a091                	j	8a8 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 866:	6398                	ld	a4,0(a5)
 868:	00e7e463          	bltu	a5,a4,870 <free+0x3a>
 86c:	00e6ea63          	bltu	a3,a4,880 <free+0x4a>
void free(void *ap) {
 870:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	fed7fae3          	bgeu	a5,a3,866 <free+0x30>
 876:	6398                	ld	a4,0(a5)
 878:	00e6e463          	bltu	a3,a4,880 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 87c:	fee7eae3          	bltu	a5,a4,870 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 880:	ff852583          	lw	a1,-8(a0)
 884:	6390                	ld	a2,0(a5)
 886:	02059813          	slli	a6,a1,0x20
 88a:	01c85713          	srli	a4,a6,0x1c
 88e:	9736                	add	a4,a4,a3
 890:	fae60de3          	beq	a2,a4,84a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 898:	4790                	lw	a2,8(a5)
 89a:	02061593          	slli	a1,a2,0x20
 89e:	01c5d713          	srli	a4,a1,0x1c
 8a2:	973e                	add	a4,a4,a5
 8a4:	fae68ae3          	beq	a3,a4,858 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
}
 8b2:	6422                	ld	s0,8(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret

00000000000008b8 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 8b8:	7139                	addi	sp,sp,-64
 8ba:	fc06                	sd	ra,56(sp)
 8bc:	f822                	sd	s0,48(sp)
 8be:	f426                	sd	s1,40(sp)
 8c0:	ec4e                	sd	s3,24(sp)
 8c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8c4:	02051493          	slli	s1,a0,0x20
 8c8:	9081                	srli	s1,s1,0x20
 8ca:	04bd                	addi	s1,s1,15
 8cc:	8091                	srli	s1,s1,0x4
 8ce:	0014899b          	addiw	s3,s1,1
 8d2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8d4:	00000517          	auipc	a0,0x0
 8d8:	72c53503          	ld	a0,1836(a0) # 1000 <freep>
 8dc:	c915                	beqz	a0,910 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8de:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e0:	4798                	lw	a4,8(a5)
 8e2:	08977e63          	bgeu	a4,s1,97e <malloc+0xc6>
 8e6:	f04a                	sd	s2,32(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 8ee:	8a4e                	mv	s4,s3
 8f0:	0009871b          	sext.w	a4,s3
 8f4:	6685                	lui	a3,0x1
 8f6:	00d77363          	bgeu	a4,a3,8fc <malloc+0x44>
 8fa:	6a05                	lui	s4,0x1
 8fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 900:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 904:	00000917          	auipc	s2,0x0
 908:	6fc90913          	addi	s2,s2,1788 # 1000 <freep>
  if (p == (char *)-1) return 0;
 90c:	5afd                	li	s5,-1
 90e:	a091                	j	952 <malloc+0x9a>
 910:	f04a                	sd	s2,32(sp)
 912:	e852                	sd	s4,16(sp)
 914:	e456                	sd	s5,8(sp)
 916:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 918:	00001797          	auipc	a5,0x1
 91c:	8f878793          	addi	a5,a5,-1800 # 1210 <base>
 920:	00000717          	auipc	a4,0x0
 924:	6ef73023          	sd	a5,1760(a4) # 1000 <freep>
 928:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 92e:	b7c1                	j	8ee <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	e118                	sd	a4,0(a0)
 934:	a08d                	j	996 <malloc+0xde>
  hp->s.size = nu;
 936:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 93a:	0541                	addi	a0,a0,16
 93c:	00000097          	auipc	ra,0x0
 940:	efa080e7          	jalr	-262(ra) # 836 <free>
  return freep;
 944:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 948:	c13d                	beqz	a0,9ae <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 94a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 94c:	4798                	lw	a4,8(a5)
 94e:	02977463          	bgeu	a4,s1,976 <malloc+0xbe>
    if (p == freep)
 952:	00093703          	ld	a4,0(s2)
 956:	853e                	mv	a0,a5
 958:	fef719e3          	bne	a4,a5,94a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 95c:	8552                	mv	a0,s4
 95e:	00000097          	auipc	ra,0x0
 962:	bba080e7          	jalr	-1094(ra) # 518 <sbrk>
  if (p == (char *)-1) return 0;
 966:	fd5518e3          	bne	a0,s5,936 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 96a:	4501                	li	a0,0
 96c:	7902                	ld	s2,32(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	a03d                	j	9a2 <malloc+0xea>
 976:	7902                	ld	s2,32(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 97e:	fae489e3          	beq	s1,a4,930 <malloc+0x78>
        p->s.size -= nunits;
 982:	4137073b          	subw	a4,a4,s3
 986:	c798                	sw	a4,8(a5)
        p += p->s.size;
 988:	02071693          	slli	a3,a4,0x20
 98c:	01c6d713          	srli	a4,a3,0x1c
 990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 996:	00000717          	auipc	a4,0x0
 99a:	66a73523          	sd	a0,1642(a4) # 1000 <freep>
      return (void *)(p + 1);
 99e:	01078513          	addi	a0,a5,16
  }
}
 9a2:	70e2                	ld	ra,56(sp)
 9a4:	7442                	ld	s0,48(sp)
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	69e2                	ld	s3,24(sp)
 9aa:	6121                	addi	sp,sp,64
 9ac:	8082                	ret
 9ae:	7902                	ld	s2,32(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	b7f5                	j	9a2 <malloc+0xea>

00000000000009b8 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 9b8:	4909                	li	s2,2
  li s3, 3
 9ba:	498d                	li	s3,3
  li s4, 4
 9bc:	4a11                	li	s4,4
  li s5, 5
 9be:	4a95                	li	s5,5
  li s6, 6
 9c0:	4b19                	li	s6,6
  li s7, 7
 9c2:	4b9d                	li	s7,7
  li s8, 8
 9c4:	4c21                	li	s8,8
  li s9, 9
 9c6:	4ca5                	li	s9,9
  li s10, 10
 9c8:	4d29                	li	s10,10
  li s11, 11
 9ca:	4dad                	li	s11,11
  li a7, SYS_write
 9cc:	48c1                	li	a7,16
  ecall
 9ce:	00000073          	ecall
  j loop
 9d2:	a82d                	j	a0c <loop>

00000000000009d4 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 9d4:	4911                	li	s2,4
  li s3, 9
 9d6:	49a5                	li	s3,9
  li s4, 16
 9d8:	4a41                	li	s4,16
  li s5, 25
 9da:	4ae5                	li	s5,25
  li s6, 36
 9dc:	02400b13          	li	s6,36
  li s7, 49
 9e0:	03100b93          	li	s7,49
  li s8, 64
 9e4:	04000c13          	li	s8,64
  li s9, 81
 9e8:	05100c93          	li	s9,81
  li s10, 100
 9ec:	06400d13          	li	s10,100
  li s11, 121
 9f0:	07900d93          	li	s11,121
  li a7, SYS_write
 9f4:	48c1                	li	a7,16
  ecall
 9f6:	00000073          	ecall
  j loop
 9fa:	a809                	j	a0c <loop>

00000000000009fc <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 9fc:	53900913          	li	s2,1337
  mv a2, a1
 a00:	862e                	mv	a2,a1
  li a1, 2
 a02:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 a04:	48d9                	li	a7,22
  ecall
 a06:	00000073          	ecall
#endif
  ret
 a0a:	8082                	ret

0000000000000a0c <loop>:

loop:
  j loop
 a0c:	a001                	j	a0c <loop>
  ret
 a0e:	8082                	ret
