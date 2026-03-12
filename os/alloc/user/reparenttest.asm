
user/_reparenttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <allocate>:
// childrens and abandons all of them. Children should be reparented
// to initproc and gracefully waited.

#include "user/user.h"

void allocate(int cnt) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	e84a                	sd	s2,16(sp)
   8:	1800                	addi	s0,sp,48
   a:	892a                	mv	s2,a0
  int n, pid;

  int fd[2];
  char buf[1];
  if (pipe(fd) != 0) {
   c:	fd840513          	addi	a0,s0,-40
  10:	00000097          	auipc	ra,0x0
  14:	5c6080e7          	jalr	1478(ra) # 5d6 <pipe>
  18:	e505                	bnez	a0,40 <allocate+0x40>
  1a:	ec26                	sd	s1,24(sp)
  1c:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }

  for (n = 0; n < cnt; n++) {
  1e:	01205c63          	blez	s2,36 <allocate+0x36>
    pid = fork();
  22:	00000097          	auipc	ra,0x0
  26:	59c080e7          	jalr	1436(ra) # 5be <fork>
    if (pid < 0) break;
  2a:	04054d63          	bltz	a0,84 <allocate+0x84>
    if (pid == 0) {
  2e:	c51d                	beqz	a0,5c <allocate+0x5c>
  for (n = 0; n < cnt; n++) {
  30:	2485                	addiw	s1,s1,1
  32:	fe9918e3          	bne	s2,s1,22 <allocate+0x22>

  if (n < cnt) {
    exit(1);
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	00000097          	auipc	ra,0x0
  3c:	58e080e7          	jalr	1422(ra) # 5c6 <exit>
  40:	ec26                	sd	s1,24(sp)
    printf("pipe() failed\n");
  42:	00001517          	auipc	a0,0x1
  46:	aae50513          	addi	a0,a0,-1362 # af0 <malloc+0x10a>
  4a:	00001097          	auipc	ra,0x1
  4e:	8e4080e7          	jalr	-1820(ra) # 92e <printf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	572080e7          	jalr	1394(ra) # 5c6 <exit>
      close(fd[1]);
  5c:	fdc42503          	lw	a0,-36(s0)
  60:	00000097          	auipc	ra,0x0
  64:	58e080e7          	jalr	1422(ra) # 5ee <close>
      read(fd[0], buf, 1);
  68:	4605                	li	a2,1
  6a:	fd040593          	addi	a1,s0,-48
  6e:	fd842503          	lw	a0,-40(s0)
  72:	00000097          	auipc	ra,0x0
  76:	56c080e7          	jalr	1388(ra) # 5de <read>
      exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	54a080e7          	jalr	1354(ra) # 5c6 <exit>
  if (n < cnt) {
  84:	fb24d9e3          	bge	s1,s2,36 <allocate+0x36>
    exit(1);
  88:	4505                	li	a0,1
  8a:	00000097          	auipc	ra,0x0
  8e:	53c080e7          	jalr	1340(ra) # 5c6 <exit>

0000000000000092 <small>:
}

void small(const char* s) {
  92:	7119                	addi	sp,sp,-128
  94:	fc86                	sd	ra,120(sp)
  96:	f8a2                	sd	s0,112(sp)
  98:	f4a6                	sd	s1,104(sp)
  9a:	f0ca                	sd	s2,96(sp)
  9c:	ecce                	sd	s3,88(sp)
  9e:	e8d2                	sd	s4,80(sp)
  a0:	e4d6                	sd	s5,72(sp)
  a2:	e0da                	sd	s6,64(sp)
  a4:	fc5e                	sd	s7,56(sp)
  a6:	f862                	sd	s8,48(sp)
  a8:	f466                	sd	s9,40(sp)
  aa:	f06a                	sd	s10,32(sp)
  ac:	ec6e                	sd	s11,24(sp)
  ae:	0100                	addi	s0,sp,128
  b0:	8a2a                	mv	s4,a0
  for (int test = 0; test < 20; test++) {
  b2:	4b01                	li	s6,0
    printf("%s: small test %d\n", s, test + 1);
  b4:	00001c97          	auipc	s9,0x1
  b8:	a4cc8c93          	addi	s9,s9,-1460 # b00 <malloc+0x11a>
    // and then quit.

    int i;
    int failed = 0;
    int uncompleted = 0;
    for (i = 0; i < 10; i++) {
  bc:	4aa9                	li	s5,10
      int pid = fork();

      if (pid < 0) {
        printf("%s: could not fork\n", s);
        failed = 1;
  be:	4985                	li	s3,1

    for (int j = 0; j < i; j++) {
      int status;
      int c = wait(&status);
      if (c < 0) {
        printf("%s: lost children\n", s);
  c0:	00001c17          	auipc	s8,0x1
  c4:	a70c0c13          	addi	s8,s8,-1424 # b30 <malloc+0x14a>
        failed = 1;
      }
      if (status != 0 && status != 1) {
        printf("%s: unexpected exit status %d\n", s, status);
  c8:	00001b97          	auipc	s7,0x1
  cc:	a80b8b93          	addi	s7,s7,-1408 # b48 <malloc+0x162>
  d0:	a071                	j	15c <small+0xca>
        printf("%s: could not fork\n", s);
  d2:	85d2                	mv	a1,s4
  d4:	00001517          	auipc	a0,0x1
  d8:	a4450513          	addi	a0,a0,-1468 # b18 <malloc+0x132>
  dc:	00001097          	auipc	ra,0x1
  e0:	852080e7          	jalr	-1966(ra) # 92e <printf>
    for (int j = 0; j < i; j++) {
  e4:	0a905363          	blez	s1,18a <small+0xf8>
        failed = 1;
  e8:	8dce                	mv	s11,s3
  ea:	a869                	j	184 <small+0xf2>
        allocate(32);
  ec:	02000513          	li	a0,32
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <allocate>
        printf("%s: lost children\n", s);
  f8:	85d2                	mv	a1,s4
  fa:	8562                	mv	a0,s8
  fc:	00001097          	auipc	ra,0x1
 100:	832080e7          	jalr	-1998(ra) # 92e <printf>
        failed = 1;
 104:	8dce                	mv	s11,s3
 106:	a03d                	j	134 <small+0xa2>
        printf("%s: unexpected exit status %d\n", s, status);
 108:	85d2                	mv	a1,s4
 10a:	855e                	mv	a0,s7
 10c:	00001097          	auipc	ra,0x1
 110:	822080e7          	jalr	-2014(ra) # 92e <printf>
        failed = 1;
      }
      uncompleted += status;
 114:	f8c42783          	lw	a5,-116(s0)
 118:	01a78d3b          	addw	s10,a5,s10
    for (int j = 0; j < i; j++) {
 11c:	2905                	addiw	s2,s2,1
 11e:	06990663          	beq	s2,s1,18a <small+0xf8>
        failed = 1;
 122:	8dce                	mv	s11,s3
      int c = wait(&status);
 124:	f8c40513          	addi	a0,s0,-116
 128:	00000097          	auipc	ra,0x0
 12c:	4a6080e7          	jalr	1190(ra) # 5ce <wait>
      if (c < 0) {
 130:	fc0544e3          	bltz	a0,f8 <small+0x66>
      if (status != 0 && status != 1) {
 134:	f8c42603          	lw	a2,-116(s0)
 138:	0006079b          	sext.w	a5,a2
 13c:	fcf9e6e3          	bltu	s3,a5,108 <small+0x76>
      uncompleted += status;
 140:	f8c42783          	lw	a5,-116(s0)
 144:	01a78d3b          	addw	s10,a5,s10
    for (int j = 0; j < i; j++) {
 148:	2905                	addiw	s2,s2,1
 14a:	fc991de3          	bne	s2,s1,124 <small+0x92>
    }

    if (failed) {
 14e:	020d9e63          	bnez	s11,18a <small+0xf8>
      exit(1);
    }

    if (uncompleted > 0) {
 152:	05a04163          	bgtz	s10,194 <small+0x102>
  for (int test = 0; test < 20; test++) {
 156:	47d1                	li	a5,20
 158:	04fb0963          	beq	s6,a5,1aa <small+0x118>
    printf("%s: small test %d\n", s, test + 1);
 15c:	2b05                	addiw	s6,s6,1
 15e:	865a                	mv	a2,s6
 160:	85d2                	mv	a1,s4
 162:	8566                	mv	a0,s9
 164:	00000097          	auipc	ra,0x0
 168:	7ca080e7          	jalr	1994(ra) # 92e <printf>
    for (i = 0; i < 10; i++) {
 16c:	4481                	li	s1,0
      int pid = fork();
 16e:	00000097          	auipc	ra,0x0
 172:	450080e7          	jalr	1104(ra) # 5be <fork>
      if (pid < 0) {
 176:	f4054ee3          	bltz	a0,d2 <small+0x40>
      if (pid == 0) {
 17a:	d92d                	beqz	a0,ec <small+0x5a>
    for (i = 0; i < 10; i++) {
 17c:	2485                	addiw	s1,s1,1
 17e:	ff5498e3          	bne	s1,s5,16e <small+0xdc>
    int failed = 0;
 182:	4d81                	li	s11,0
        failed = 1;
 184:	4901                	li	s2,0
 186:	4d01                	li	s10,0
 188:	bf71                	j	124 <small+0x92>
      exit(1);
 18a:	4505                	li	a0,1
 18c:	00000097          	auipc	ra,0x0
 190:	43a080e7          	jalr	1082(ra) # 5c6 <exit>
      printf("%s: %d masters failed to allocate processes\n", s, uncompleted);
 194:	866a                	mv	a2,s10
 196:	85d2                	mv	a1,s4
 198:	00001517          	auipc	a0,0x1
 19c:	9d050513          	addi	a0,a0,-1584 # b68 <malloc+0x182>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	78e080e7          	jalr	1934(ra) # 92e <printf>
 1a8:	b77d                	j	156 <small+0xc4>
    }
  }
}
 1aa:	70e6                	ld	ra,120(sp)
 1ac:	7446                	ld	s0,112(sp)
 1ae:	74a6                	ld	s1,104(sp)
 1b0:	7906                	ld	s2,96(sp)
 1b2:	69e6                	ld	s3,88(sp)
 1b4:	6a46                	ld	s4,80(sp)
 1b6:	6aa6                	ld	s5,72(sp)
 1b8:	6b06                	ld	s6,64(sp)
 1ba:	7be2                	ld	s7,56(sp)
 1bc:	7c42                	ld	s8,48(sp)
 1be:	7ca2                	ld	s9,40(sp)
 1c0:	7d02                	ld	s10,32(sp)
 1c2:	6de2                	ld	s11,24(sp)
 1c4:	6109                	addi	sp,sp,128
 1c6:	8082                	ret

00000000000001c8 <big>:

void big(const char* s) {
 1c8:	7139                	addi	sp,sp,-64
 1ca:	fc06                	sd	ra,56(sp)
 1cc:	f822                	sd	s0,48(sp)
 1ce:	f426                	sd	s1,40(sp)
 1d0:	f04a                	sd	s2,32(sp)
 1d2:	ec4e                	sd	s3,24(sp)
 1d4:	e852                	sd	s4,16(sp)
 1d6:	0080                	addi	s0,sp,64
 1d8:	892a                	mv	s2,a0
  for (int test = 0; test < 3; test++) {
 1da:	4481                	li	s1,0
    printf("%s: large test %d\n", s, test + 1);
 1dc:	00001997          	auipc	s3,0x1
 1e0:	9bc98993          	addi	s3,s3,-1604 # b98 <malloc+0x1b2>
  for (int test = 0; test < 3; test++) {
 1e4:	4a0d                	li	s4,3
    printf("%s: large test %d\n", s, test + 1);
 1e6:	2485                	addiw	s1,s1,1
 1e8:	8626                	mv	a2,s1
 1ea:	85ca                	mv	a1,s2
 1ec:	854e                	mv	a0,s3
 1ee:	00000097          	auipc	ra,0x0
 1f2:	740080e7          	jalr	1856(ra) # 92e <printf>

    // Large test: single master allocates as much processes
    // as it can, then quits.

    int pid = fork();
 1f6:	00000097          	auipc	ra,0x0
 1fa:	3c8080e7          	jalr	968(ra) # 5be <fork>
    if (pid < 0) {
 1fe:	02054d63          	bltz	a0,238 <big+0x70>
      printf("%s: could not fork\n", s);
      exit(1);
    }

    if (pid == 0) {
 202:	c929                	beqz	a0,254 <big+0x8c>
      allocate(5555);
    }

    int status;
    int c = wait(&status);
 204:	fcc40513          	addi	a0,s0,-52
 208:	00000097          	auipc	ra,0x0
 20c:	3c6080e7          	jalr	966(ra) # 5ce <wait>
    if (c < 0) {
 210:	04054963          	bltz	a0,262 <big+0x9a>
      printf("%s: lost children\n", s);
      exit(1);
    }
    if (status == 0) {
 214:	fcc42783          	lw	a5,-52(s0)
 218:	c3bd                	beqz	a5,27e <big+0xb6>
      printf("%s: allocated all processes for big test\n", s);
      exit(1);
    }
    sleep(30);  // sleep a bit to unload some processes
 21a:	4579                	li	a0,30
 21c:	00000097          	auipc	ra,0x0
 220:	43a080e7          	jalr	1082(ra) # 656 <sleep>
  for (int test = 0; test < 3; test++) {
 224:	fd4491e3          	bne	s1,s4,1e6 <big+0x1e>
  }
}
 228:	70e2                	ld	ra,56(sp)
 22a:	7442                	ld	s0,48(sp)
 22c:	74a2                	ld	s1,40(sp)
 22e:	7902                	ld	s2,32(sp)
 230:	69e2                	ld	s3,24(sp)
 232:	6a42                	ld	s4,16(sp)
 234:	6121                	addi	sp,sp,64
 236:	8082                	ret
      printf("%s: could not fork\n", s);
 238:	85ca                	mv	a1,s2
 23a:	00001517          	auipc	a0,0x1
 23e:	8de50513          	addi	a0,a0,-1826 # b18 <malloc+0x132>
 242:	00000097          	auipc	ra,0x0
 246:	6ec080e7          	jalr	1772(ra) # 92e <printf>
      exit(1);
 24a:	4505                	li	a0,1
 24c:	00000097          	auipc	ra,0x0
 250:	37a080e7          	jalr	890(ra) # 5c6 <exit>
      allocate(5555);
 254:	6505                	lui	a0,0x1
 256:	5b350513          	addi	a0,a0,1459 # 15b3 <digits+0x93b>
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <allocate>
      printf("%s: lost children\n", s);
 262:	85ca                	mv	a1,s2
 264:	00001517          	auipc	a0,0x1
 268:	8cc50513          	addi	a0,a0,-1844 # b30 <malloc+0x14a>
 26c:	00000097          	auipc	ra,0x0
 270:	6c2080e7          	jalr	1730(ra) # 92e <printf>
      exit(1);
 274:	4505                	li	a0,1
 276:	00000097          	auipc	ra,0x0
 27a:	350080e7          	jalr	848(ra) # 5c6 <exit>
      printf("%s: allocated all processes for big test\n", s);
 27e:	85ca                	mv	a1,s2
 280:	00001517          	auipc	a0,0x1
 284:	93050513          	addi	a0,a0,-1744 # bb0 <malloc+0x1ca>
 288:	00000097          	auipc	ra,0x0
 28c:	6a6080e7          	jalr	1702(ra) # 92e <printf>
      exit(1);
 290:	4505                	li	a0,1
 292:	00000097          	auipc	ra,0x0
 296:	334080e7          	jalr	820(ra) # 5c6 <exit>

000000000000029a <main>:

int main(int argc, const char** argv) {
 29a:	1101                	addi	sp,sp,-32
 29c:	ec06                	sd	ra,24(sp)
 29e:	e822                	sd	s0,16(sp)
 2a0:	e426                	sd	s1,8(sp)
 2a2:	1000                	addi	s0,sp,32
 2a4:	84ae                	mv	s1,a1
  if (argc != 2) {
 2a6:	4789                	li	a5,2
 2a8:	04f51063          	bne	a0,a5,2e8 <main+0x4e>
    printf("usage: %s (small | big)\n", argv[0]);
    exit(1);
  }

  if (strcmp(argv[1], "small") == 0) {
 2ac:	00001597          	auipc	a1,0x1
 2b0:	95458593          	addi	a1,a1,-1708 # c00 <malloc+0x21a>
 2b4:	6488                	ld	a0,8(s1)
 2b6:	00000097          	auipc	ra,0x0
 2ba:	0c0080e7          	jalr	192(ra) # 376 <strcmp>
 2be:	e139                	bnez	a0,304 <main+0x6a>
    small(argv[0]);
 2c0:	6088                	ld	a0,0(s1)
 2c2:	00000097          	auipc	ra,0x0
 2c6:	dd0080e7          	jalr	-560(ra) # 92 <small>
  } else {
    printf("usage: %s (small | big)\n", argv[0]);
    exit(1);
  }

  printf("%s: OK\n", argv[0]);
 2ca:	608c                	ld	a1,0(s1)
 2cc:	00001517          	auipc	a0,0x1
 2d0:	94450513          	addi	a0,a0,-1724 # c10 <malloc+0x22a>
 2d4:	00000097          	auipc	ra,0x0
 2d8:	65a080e7          	jalr	1626(ra) # 92e <printf>
  return 0;
}
 2dc:	4501                	li	a0,0
 2de:	60e2                	ld	ra,24(sp)
 2e0:	6442                	ld	s0,16(sp)
 2e2:	64a2                	ld	s1,8(sp)
 2e4:	6105                	addi	sp,sp,32
 2e6:	8082                	ret
    printf("usage: %s (small | big)\n", argv[0]);
 2e8:	618c                	ld	a1,0(a1)
 2ea:	00001517          	auipc	a0,0x1
 2ee:	8f650513          	addi	a0,a0,-1802 # be0 <malloc+0x1fa>
 2f2:	00000097          	auipc	ra,0x0
 2f6:	63c080e7          	jalr	1596(ra) # 92e <printf>
    exit(1);
 2fa:	4505                	li	a0,1
 2fc:	00000097          	auipc	ra,0x0
 300:	2ca080e7          	jalr	714(ra) # 5c6 <exit>
  } else if (strcmp(argv[1], "big") == 0) {
 304:	00001597          	auipc	a1,0x1
 308:	90458593          	addi	a1,a1,-1788 # c08 <malloc+0x222>
 30c:	6488                	ld	a0,8(s1)
 30e:	00000097          	auipc	ra,0x0
 312:	068080e7          	jalr	104(ra) # 376 <strcmp>
 316:	e519                	bnez	a0,324 <main+0x8a>
    big(argv[0]);
 318:	6088                	ld	a0,0(s1)
 31a:	00000097          	auipc	ra,0x0
 31e:	eae080e7          	jalr	-338(ra) # 1c8 <big>
 322:	b765                	j	2ca <main+0x30>
    printf("usage: %s (small | big)\n", argv[0]);
 324:	608c                	ld	a1,0(s1)
 326:	00001517          	auipc	a0,0x1
 32a:	8ba50513          	addi	a0,a0,-1862 # be0 <malloc+0x1fa>
 32e:	00000097          	auipc	ra,0x0
 332:	600080e7          	jalr	1536(ra) # 92e <printf>
    exit(1);
 336:	4505                	li	a0,1
 338:	00000097          	auipc	ra,0x0
 33c:	28e080e7          	jalr	654(ra) # 5c6 <exit>

0000000000000340 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  extern int main();
  main();
 348:	00000097          	auipc	ra,0x0
 34c:	f52080e7          	jalr	-174(ra) # 29a <main>
  exit(0);
 350:	4501                	li	a0,0
 352:	00000097          	auipc	ra,0x0
 356:	274080e7          	jalr	628(ra) # 5c6 <exit>

000000000000035a <strcpy>:
}

char *strcpy(char *s, const char *t) {
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 360:	87aa                	mv	a5,a0
 362:	0585                	addi	a1,a1,1
 364:	0785                	addi	a5,a5,1
 366:	fff5c703          	lbu	a4,-1(a1)
 36a:	fee78fa3          	sb	a4,-1(a5)
 36e:	fb75                	bnez	a4,362 <strcpy+0x8>
  return os;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <strcmp>:

int strcmp(const char *p, const char *q) {
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 37c:	00054783          	lbu	a5,0(a0)
 380:	cb91                	beqz	a5,394 <strcmp+0x1e>
 382:	0005c703          	lbu	a4,0(a1)
 386:	00f71763          	bne	a4,a5,394 <strcmp+0x1e>
 38a:	0505                	addi	a0,a0,1
 38c:	0585                	addi	a1,a1,1
 38e:	00054783          	lbu	a5,0(a0)
 392:	fbe5                	bnez	a5,382 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 394:	0005c503          	lbu	a0,0(a1)
}
 398:	40a7853b          	subw	a0,a5,a0
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <strlen>:

uint strlen(const char *s) {
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 3a8:	00054783          	lbu	a5,0(a0)
 3ac:	cf91                	beqz	a5,3c8 <strlen+0x26>
 3ae:	0505                	addi	a0,a0,1
 3b0:	87aa                	mv	a5,a0
 3b2:	86be                	mv	a3,a5
 3b4:	0785                	addi	a5,a5,1
 3b6:	fff7c703          	lbu	a4,-1(a5)
 3ba:	ff65                	bnez	a4,3b2 <strlen+0x10>
 3bc:	40a6853b          	subw	a0,a3,a0
 3c0:	2505                	addiw	a0,a0,1
  return n;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  for (n = 0; s[n]; n++);
 3c8:	4501                	li	a0,0
 3ca:	bfe5                	j	3c2 <strlen+0x20>

00000000000003cc <memset>:

void *memset(void *dst, int c, uint n) {
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 3d2:	ca19                	beqz	a2,3e8 <memset+0x1c>
 3d4:	87aa                	mv	a5,a0
 3d6:	1602                	slli	a2,a2,0x20
 3d8:	9201                	srli	a2,a2,0x20
 3da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3de:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3e2:	0785                	addi	a5,a5,1
 3e4:	fee79de3          	bne	a5,a4,3de <memset+0x12>
  }
  return dst;
}
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <strchr>:

char *strchr(const char *s, char c) {
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3f4:	00054783          	lbu	a5,0(a0)
 3f8:	cb99                	beqz	a5,40e <strchr+0x20>
    if (*s == c) return (char *)s;
 3fa:	00f58763          	beq	a1,a5,408 <strchr+0x1a>
  for (; *s; s++)
 3fe:	0505                	addi	a0,a0,1
 400:	00054783          	lbu	a5,0(a0)
 404:	fbfd                	bnez	a5,3fa <strchr+0xc>
  return 0;
 406:	4501                	li	a0,0
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret
  return 0;
 40e:	4501                	li	a0,0
 410:	bfe5                	j	408 <strchr+0x1a>

0000000000000412 <gets>:

char *gets(char *buf, int max) {
 412:	711d                	addi	sp,sp,-96
 414:	ec86                	sd	ra,88(sp)
 416:	e8a2                	sd	s0,80(sp)
 418:	e4a6                	sd	s1,72(sp)
 41a:	e0ca                	sd	s2,64(sp)
 41c:	fc4e                	sd	s3,56(sp)
 41e:	f852                	sd	s4,48(sp)
 420:	f456                	sd	s5,40(sp)
 422:	f05a                	sd	s6,32(sp)
 424:	ec5e                	sd	s7,24(sp)
 426:	1080                	addi	s0,sp,96
 428:	8baa                	mv	s7,a0
 42a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 42c:	892a                	mv	s2,a0
 42e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 430:	4aa9                	li	s5,10
 432:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 434:	89a6                	mv	s3,s1
 436:	2485                	addiw	s1,s1,1
 438:	0344d863          	bge	s1,s4,468 <gets+0x56>
    cc = read(0, &c, 1);
 43c:	4605                	li	a2,1
 43e:	faf40593          	addi	a1,s0,-81
 442:	4501                	li	a0,0
 444:	00000097          	auipc	ra,0x0
 448:	19a080e7          	jalr	410(ra) # 5de <read>
    if (cc < 1) break;
 44c:	00a05e63          	blez	a0,468 <gets+0x56>
    buf[i++] = c;
 450:	faf44783          	lbu	a5,-81(s0)
 454:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 458:	01578763          	beq	a5,s5,466 <gets+0x54>
 45c:	0905                	addi	s2,s2,1
 45e:	fd679be3          	bne	a5,s6,434 <gets+0x22>
    buf[i++] = c;
 462:	89a6                	mv	s3,s1
 464:	a011                	j	468 <gets+0x56>
 466:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 468:	99de                	add	s3,s3,s7
 46a:	00098023          	sb	zero,0(s3)
  return buf;
}
 46e:	855e                	mv	a0,s7
 470:	60e6                	ld	ra,88(sp)
 472:	6446                	ld	s0,80(sp)
 474:	64a6                	ld	s1,72(sp)
 476:	6906                	ld	s2,64(sp)
 478:	79e2                	ld	s3,56(sp)
 47a:	7a42                	ld	s4,48(sp)
 47c:	7aa2                	ld	s5,40(sp)
 47e:	7b02                	ld	s6,32(sp)
 480:	6be2                	ld	s7,24(sp)
 482:	6125                	addi	sp,sp,96
 484:	8082                	ret

0000000000000486 <stat>:

int stat(const char *n, struct stat *st) {
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	e04a                	sd	s2,0(sp)
 48e:	1000                	addi	s0,sp,32
 490:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 492:	4581                	li	a1,0
 494:	00000097          	auipc	ra,0x0
 498:	172080e7          	jalr	370(ra) # 606 <open>
  if (fd < 0) return -1;
 49c:	02054663          	bltz	a0,4c8 <stat+0x42>
 4a0:	e426                	sd	s1,8(sp)
 4a2:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 4a4:	85ca                	mv	a1,s2
 4a6:	00000097          	auipc	ra,0x0
 4aa:	178080e7          	jalr	376(ra) # 61e <fstat>
 4ae:	892a                	mv	s2,a0
  close(fd);
 4b0:	8526                	mv	a0,s1
 4b2:	00000097          	auipc	ra,0x0
 4b6:	13c080e7          	jalr	316(ra) # 5ee <close>
  return r;
 4ba:	64a2                	ld	s1,8(sp)
}
 4bc:	854a                	mv	a0,s2
 4be:	60e2                	ld	ra,24(sp)
 4c0:	6442                	ld	s0,16(sp)
 4c2:	6902                	ld	s2,0(sp)
 4c4:	6105                	addi	sp,sp,32
 4c6:	8082                	ret
  if (fd < 0) return -1;
 4c8:	597d                	li	s2,-1
 4ca:	bfcd                	j	4bc <stat+0x36>

00000000000004cc <atoi>:

int atoi(const char *s) {
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4d2:	00054683          	lbu	a3,0(a0)
 4d6:	fd06879b          	addiw	a5,a3,-48
 4da:	0ff7f793          	zext.b	a5,a5
 4de:	4625                	li	a2,9
 4e0:	02f66863          	bltu	a2,a5,510 <atoi+0x44>
 4e4:	872a                	mv	a4,a0
  n = 0;
 4e6:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4e8:	0705                	addi	a4,a4,1
 4ea:	0025179b          	slliw	a5,a0,0x2
 4ee:	9fa9                	addw	a5,a5,a0
 4f0:	0017979b          	slliw	a5,a5,0x1
 4f4:	9fb5                	addw	a5,a5,a3
 4f6:	fd07851b          	addiw	a0,a5,-48
 4fa:	00074683          	lbu	a3,0(a4)
 4fe:	fd06879b          	addiw	a5,a3,-48
 502:	0ff7f793          	zext.b	a5,a5
 506:	fef671e3          	bgeu	a2,a5,4e8 <atoi+0x1c>
  return n;
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret
  n = 0;
 510:	4501                	li	a0,0
 512:	bfe5                	j	50a <atoi+0x3e>

0000000000000514 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 514:	1141                	addi	sp,sp,-16
 516:	e422                	sd	s0,8(sp)
 518:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 51a:	02b57463          	bgeu	a0,a1,542 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 51e:	00c05f63          	blez	a2,53c <memmove+0x28>
 522:	1602                	slli	a2,a2,0x20
 524:	9201                	srli	a2,a2,0x20
 526:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 52a:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 52c:	0585                	addi	a1,a1,1
 52e:	0705                	addi	a4,a4,1
 530:	fff5c683          	lbu	a3,-1(a1)
 534:	fed70fa3          	sb	a3,-1(a4)
 538:	fef71ae3          	bne	a4,a5,52c <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
    dst += n;
 542:	00c50733          	add	a4,a0,a2
    src += n;
 546:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 548:	fec05ae3          	blez	a2,53c <memmove+0x28>
 54c:	fff6079b          	addiw	a5,a2,-1
 550:	1782                	slli	a5,a5,0x20
 552:	9381                	srli	a5,a5,0x20
 554:	fff7c793          	not	a5,a5
 558:	97ba                	add	a5,a5,a4
 55a:	15fd                	addi	a1,a1,-1
 55c:	177d                	addi	a4,a4,-1
 55e:	0005c683          	lbu	a3,0(a1)
 562:	00d70023          	sb	a3,0(a4)
 566:	fee79ae3          	bne	a5,a4,55a <memmove+0x46>
 56a:	bfc9                	j	53c <memmove+0x28>

000000000000056c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 56c:	1141                	addi	sp,sp,-16
 56e:	e422                	sd	s0,8(sp)
 570:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 572:	ca05                	beqz	a2,5a2 <memcmp+0x36>
 574:	fff6069b          	addiw	a3,a2,-1
 578:	1682                	slli	a3,a3,0x20
 57a:	9281                	srli	a3,a3,0x20
 57c:	0685                	addi	a3,a3,1
 57e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 580:	00054783          	lbu	a5,0(a0)
 584:	0005c703          	lbu	a4,0(a1)
 588:	00e79863          	bne	a5,a4,598 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 58c:	0505                	addi	a0,a0,1
    p2++;
 58e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 590:	fed518e3          	bne	a0,a3,580 <memcmp+0x14>
  }
  return 0;
 594:	4501                	li	a0,0
 596:	a019                	j	59c <memcmp+0x30>
      return *p1 - *p2;
 598:	40e7853b          	subw	a0,a5,a4
}
 59c:	6422                	ld	s0,8(sp)
 59e:	0141                	addi	sp,sp,16
 5a0:	8082                	ret
  return 0;
 5a2:	4501                	li	a0,0
 5a4:	bfe5                	j	59c <memcmp+0x30>

00000000000005a6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 5a6:	1141                	addi	sp,sp,-16
 5a8:	e406                	sd	ra,8(sp)
 5aa:	e022                	sd	s0,0(sp)
 5ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5ae:	00000097          	auipc	ra,0x0
 5b2:	f66080e7          	jalr	-154(ra) # 514 <memmove>
}
 5b6:	60a2                	ld	ra,8(sp)
 5b8:	6402                	ld	s0,0(sp)
 5ba:	0141                	addi	sp,sp,16
 5bc:	8082                	ret

00000000000005be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5be:	4885                	li	a7,1
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5c6:	4889                	li	a7,2
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ce:	488d                	li	a7,3
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5d6:	4891                	li	a7,4
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <read>:
.global read
read:
 li a7, SYS_read
 5de:	4895                	li	a7,5
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <write>:
.global write
write:
 li a7, SYS_write
 5e6:	48c1                	li	a7,16
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <close>:
.global close
close:
 li a7, SYS_close
 5ee:	48d5                	li	a7,21
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5f6:	4899                	li	a7,6
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 5fe:	489d                	li	a7,7
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <open>:
.global open
open:
 li a7, SYS_open
 606:	48bd                	li	a7,15
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 60e:	48c5                	li	a7,17
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 616:	48c9                	li	a7,18
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 61e:	48a1                	li	a7,8
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <link>:
.global link
link:
 li a7, SYS_link
 626:	48cd                	li	a7,19
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 62e:	48d1                	li	a7,20
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 636:	48a5                	li	a7,9
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <dup>:
.global dup
dup:
 li a7, SYS_dup
 63e:	48a9                	li	a7,10
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 646:	48ad                	li	a7,11
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 64e:	48b1                	li	a7,12
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 656:	48b5                	li	a7,13
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 65e:	48b9                	li	a7,14
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 666:	1101                	addi	sp,sp,-32
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	feb407a3          	sb	a1,-17(s0)
 672:	4605                	li	a2,1
 674:	fef40593          	addi	a1,s0,-17
 678:	00000097          	auipc	ra,0x0
 67c:	f6e080e7          	jalr	-146(ra) # 5e6 <write>
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6105                	addi	sp,sp,32
 686:	8082                	ret

0000000000000688 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 688:	7139                	addi	sp,sp,-64
 68a:	fc06                	sd	ra,56(sp)
 68c:	f822                	sd	s0,48(sp)
 68e:	f426                	sd	s1,40(sp)
 690:	0080                	addi	s0,sp,64
 692:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 694:	c299                	beqz	a3,69a <printint+0x12>
 696:	0805cb63          	bltz	a1,72c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 69a:	2581                	sext.w	a1,a1
  neg = 0;
 69c:	4881                	li	a7,0
 69e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 6a4:	2601                	sext.w	a2,a2
 6a6:	00000517          	auipc	a0,0x0
 6aa:	5d250513          	addi	a0,a0,1490 # c78 <digits>
 6ae:	883a                	mv	a6,a4
 6b0:	2705                	addiw	a4,a4,1
 6b2:	02c5f7bb          	remuw	a5,a1,a2
 6b6:	1782                	slli	a5,a5,0x20
 6b8:	9381                	srli	a5,a5,0x20
 6ba:	97aa                	add	a5,a5,a0
 6bc:	0007c783          	lbu	a5,0(a5)
 6c0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 6c4:	0005879b          	sext.w	a5,a1
 6c8:	02c5d5bb          	divuw	a1,a1,a2
 6cc:	0685                	addi	a3,a3,1
 6ce:	fec7f0e3          	bgeu	a5,a2,6ae <printint+0x26>
  if (neg) buf[i++] = '-';
 6d2:	00088c63          	beqz	a7,6ea <printint+0x62>
 6d6:	fd070793          	addi	a5,a4,-48
 6da:	00878733          	add	a4,a5,s0
 6de:	02d00793          	li	a5,45
 6e2:	fef70823          	sb	a5,-16(a4)
 6e6:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 6ea:	02e05c63          	blez	a4,722 <printint+0x9a>
 6ee:	f04a                	sd	s2,32(sp)
 6f0:	ec4e                	sd	s3,24(sp)
 6f2:	fc040793          	addi	a5,s0,-64
 6f6:	00e78933          	add	s2,a5,a4
 6fa:	fff78993          	addi	s3,a5,-1
 6fe:	99ba                	add	s3,s3,a4
 700:	377d                	addiw	a4,a4,-1
 702:	1702                	slli	a4,a4,0x20
 704:	9301                	srli	a4,a4,0x20
 706:	40e989b3          	sub	s3,s3,a4
 70a:	fff94583          	lbu	a1,-1(s2)
 70e:	8526                	mv	a0,s1
 710:	00000097          	auipc	ra,0x0
 714:	f56080e7          	jalr	-170(ra) # 666 <putc>
 718:	197d                	addi	s2,s2,-1
 71a:	ff3918e3          	bne	s2,s3,70a <printint+0x82>
 71e:	7902                	ld	s2,32(sp)
 720:	69e2                	ld	s3,24(sp)
}
 722:	70e2                	ld	ra,56(sp)
 724:	7442                	ld	s0,48(sp)
 726:	74a2                	ld	s1,40(sp)
 728:	6121                	addi	sp,sp,64
 72a:	8082                	ret
    x = -xx;
 72c:	40b005bb          	negw	a1,a1
    neg = 1;
 730:	4885                	li	a7,1
    x = -xx;
 732:	b7b5                	j	69e <printint+0x16>

0000000000000734 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 734:	715d                	addi	sp,sp,-80
 736:	e486                	sd	ra,72(sp)
 738:	e0a2                	sd	s0,64(sp)
 73a:	f84a                	sd	s2,48(sp)
 73c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 73e:	0005c903          	lbu	s2,0(a1)
 742:	1a090a63          	beqz	s2,8f6 <vprintf+0x1c2>
 746:	fc26                	sd	s1,56(sp)
 748:	f44e                	sd	s3,40(sp)
 74a:	f052                	sd	s4,32(sp)
 74c:	ec56                	sd	s5,24(sp)
 74e:	e85a                	sd	s6,16(sp)
 750:	e45e                	sd	s7,8(sp)
 752:	8aaa                	mv	s5,a0
 754:	8bb2                	mv	s7,a2
 756:	00158493          	addi	s1,a1,1
  state = 0;
 75a:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 75c:	02500a13          	li	s4,37
 760:	4b55                	li	s6,21
 762:	a839                	j	780 <vprintf+0x4c>
        putc(fd, c);
 764:	85ca                	mv	a1,s2
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	efe080e7          	jalr	-258(ra) # 666 <putc>
 770:	a019                	j	776 <vprintf+0x42>
    } else if (state == '%') {
 772:	01498d63          	beq	s3,s4,78c <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 776:	0485                	addi	s1,s1,1
 778:	fff4c903          	lbu	s2,-1(s1)
 77c:	16090763          	beqz	s2,8ea <vprintf+0x1b6>
    if (state == 0) {
 780:	fe0999e3          	bnez	s3,772 <vprintf+0x3e>
      if (c == '%') {
 784:	ff4910e3          	bne	s2,s4,764 <vprintf+0x30>
        state = '%';
 788:	89d2                	mv	s3,s4
 78a:	b7f5                	j	776 <vprintf+0x42>
      if (c == 'd') {
 78c:	13490463          	beq	s2,s4,8b4 <vprintf+0x180>
 790:	f9d9079b          	addiw	a5,s2,-99
 794:	0ff7f793          	zext.b	a5,a5
 798:	12fb6763          	bltu	s6,a5,8c6 <vprintf+0x192>
 79c:	f9d9079b          	addiw	a5,s2,-99
 7a0:	0ff7f713          	zext.b	a4,a5
 7a4:	12eb6163          	bltu	s6,a4,8c6 <vprintf+0x192>
 7a8:	00271793          	slli	a5,a4,0x2
 7ac:	00000717          	auipc	a4,0x0
 7b0:	47470713          	addi	a4,a4,1140 # c20 <malloc+0x23a>
 7b4:	97ba                	add	a5,a5,a4
 7b6:	439c                	lw	a5,0(a5)
 7b8:	97ba                	add	a5,a5,a4
 7ba:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7bc:	008b8913          	addi	s2,s7,8
 7c0:	4685                	li	a3,1
 7c2:	4629                	li	a2,10
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	ebe080e7          	jalr	-322(ra) # 688 <printint>
 7d2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b745                	j	776 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	ea2080e7          	jalr	-350(ra) # 688 <printint>
 7ee:	8bca                	mv	s7,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	b751                	j	776 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7f4:	008b8913          	addi	s2,s7,8
 7f8:	4681                	li	a3,0
 7fa:	4641                	li	a2,16
 7fc:	000ba583          	lw	a1,0(s7)
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	e86080e7          	jalr	-378(ra) # 688 <printint>
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b7a5                	j	776 <vprintf+0x42>
 810:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 812:	008b8c13          	addi	s8,s7,8
 816:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 81a:	03000593          	li	a1,48
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e46080e7          	jalr	-442(ra) # 666 <putc>
  putc(fd, 'x');
 828:	07800593          	li	a1,120
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e38080e7          	jalr	-456(ra) # 666 <putc>
 836:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 838:	00000b97          	auipc	s7,0x0
 83c:	440b8b93          	addi	s7,s7,1088 # c78 <digits>
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e1a080e7          	jalr	-486(ra) # 666 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 854:	0992                	slli	s3,s3,0x4
 856:	397d                	addiw	s2,s2,-1
 858:	fe0914e3          	bnez	s2,840 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 85c:	8be2                	mv	s7,s8
      state = 0;
 85e:	4981                	li	s3,0
 860:	6c02                	ld	s8,0(sp)
 862:	bf11                	j	776 <vprintf+0x42>
        s = va_arg(ap, char *);
 864:	008b8993          	addi	s3,s7,8
 868:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 86c:	02090163          	beqz	s2,88e <vprintf+0x15a>
        while (*s != 0) {
 870:	00094583          	lbu	a1,0(s2)
 874:	c9a5                	beqz	a1,8e4 <vprintf+0x1b0>
          putc(fd, *s);
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	dee080e7          	jalr	-530(ra) # 666 <putc>
          s++;
 880:	0905                	addi	s2,s2,1
        while (*s != 0) {
 882:	00094583          	lbu	a1,0(s2)
 886:	f9e5                	bnez	a1,876 <vprintf+0x142>
        s = va_arg(ap, char *);
 888:	8bce                	mv	s7,s3
      state = 0;
 88a:	4981                	li	s3,0
 88c:	b5ed                	j	776 <vprintf+0x42>
        if (s == 0) s = "(null)";
 88e:	00000917          	auipc	s2,0x0
 892:	38a90913          	addi	s2,s2,906 # c18 <malloc+0x232>
        while (*s != 0) {
 896:	02800593          	li	a1,40
 89a:	bff1                	j	876 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 89c:	008b8913          	addi	s2,s7,8
 8a0:	000bc583          	lbu	a1,0(s7)
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	dc0080e7          	jalr	-576(ra) # 666 <putc>
 8ae:	8bca                	mv	s7,s2
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b5d1                	j	776 <vprintf+0x42>
        putc(fd, c);
 8b4:	02500593          	li	a1,37
 8b8:	8556                	mv	a0,s5
 8ba:	00000097          	auipc	ra,0x0
 8be:	dac080e7          	jalr	-596(ra) # 666 <putc>
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	bd4d                	j	776 <vprintf+0x42>
        putc(fd, '%');
 8c6:	02500593          	li	a1,37
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d9a080e7          	jalr	-614(ra) # 666 <putc>
        putc(fd, c);
 8d4:	85ca                	mv	a1,s2
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	d8e080e7          	jalr	-626(ra) # 666 <putc>
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	bd51                	j	776 <vprintf+0x42>
        s = va_arg(ap, char *);
 8e4:	8bce                	mv	s7,s3
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	b579                	j	776 <vprintf+0x42>
 8ea:	74e2                	ld	s1,56(sp)
 8ec:	79a2                	ld	s3,40(sp)
 8ee:	7a02                	ld	s4,32(sp)
 8f0:	6ae2                	ld	s5,24(sp)
 8f2:	6b42                	ld	s6,16(sp)
 8f4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8f6:	60a6                	ld	ra,72(sp)
 8f8:	6406                	ld	s0,64(sp)
 8fa:	7942                	ld	s2,48(sp)
 8fc:	6161                	addi	sp,sp,80
 8fe:	8082                	ret

0000000000000900 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 900:	715d                	addi	sp,sp,-80
 902:	ec06                	sd	ra,24(sp)
 904:	e822                	sd	s0,16(sp)
 906:	1000                	addi	s0,sp,32
 908:	e010                	sd	a2,0(s0)
 90a:	e414                	sd	a3,8(s0)
 90c:	e818                	sd	a4,16(s0)
 90e:	ec1c                	sd	a5,24(s0)
 910:	03043023          	sd	a6,32(s0)
 914:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 91c:	8622                	mv	a2,s0
 91e:	00000097          	auipc	ra,0x0
 922:	e16080e7          	jalr	-490(ra) # 734 <vprintf>
}
 926:	60e2                	ld	ra,24(sp)
 928:	6442                	ld	s0,16(sp)
 92a:	6161                	addi	sp,sp,80
 92c:	8082                	ret

000000000000092e <printf>:

void printf(const char *fmt, ...) {
 92e:	711d                	addi	sp,sp,-96
 930:	ec06                	sd	ra,24(sp)
 932:	e822                	sd	s0,16(sp)
 934:	1000                	addi	s0,sp,32
 936:	e40c                	sd	a1,8(s0)
 938:	e810                	sd	a2,16(s0)
 93a:	ec14                	sd	a3,24(s0)
 93c:	f018                	sd	a4,32(s0)
 93e:	f41c                	sd	a5,40(s0)
 940:	03043823          	sd	a6,48(s0)
 944:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 948:	00840613          	addi	a2,s0,8
 94c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 950:	85aa                	mv	a1,a0
 952:	4505                	li	a0,1
 954:	00000097          	auipc	ra,0x0
 958:	de0080e7          	jalr	-544(ra) # 734 <vprintf>
}
 95c:	60e2                	ld	ra,24(sp)
 95e:	6442                	ld	s0,16(sp)
 960:	6125                	addi	sp,sp,96
 962:	8082                	ret

0000000000000964 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 964:	1141                	addi	sp,sp,-16
 966:	e422                	sd	s0,8(sp)
 968:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 96a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96e:	00001797          	auipc	a5,0x1
 972:	6927b783          	ld	a5,1682(a5) # 2000 <freep>
 976:	a02d                	j	9a0 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 978:	4618                	lw	a4,8(a2)
 97a:	9f2d                	addw	a4,a4,a1
 97c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	6398                	ld	a4,0(a5)
 982:	6310                	ld	a2,0(a4)
 984:	a83d                	j	9c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 986:	ff852703          	lw	a4,-8(a0)
 98a:	9f31                	addw	a4,a4,a2
 98c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98e:	ff053683          	ld	a3,-16(a0)
 992:	a091                	j	9d6 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 994:	6398                	ld	a4,0(a5)
 996:	00e7e463          	bltu	a5,a4,99e <free+0x3a>
 99a:	00e6ea63          	bltu	a3,a4,9ae <free+0x4a>
void free(void *ap) {
 99e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a0:	fed7fae3          	bgeu	a5,a3,994 <free+0x30>
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e6e463          	bltu	a3,a4,9ae <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 9aa:	fee7eae3          	bltu	a5,a4,99e <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 9ae:	ff852583          	lw	a1,-8(a0)
 9b2:	6390                	ld	a2,0(a5)
 9b4:	02059813          	slli	a6,a1,0x20
 9b8:	01c85713          	srli	a4,a6,0x1c
 9bc:	9736                	add	a4,a4,a3
 9be:	fae60de3          	beq	a2,a4,978 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c2:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9c6:	4790                	lw	a2,8(a5)
 9c8:	02061593          	slli	a1,a2,0x20
 9cc:	01c5d713          	srli	a4,a1,0x1c
 9d0:	973e                	add	a4,a4,a5
 9d2:	fae68ae3          	beq	a3,a4,986 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d8:	00001717          	auipc	a4,0x1
 9dc:	62f73423          	sd	a5,1576(a4) # 2000 <freep>
}
 9e0:	6422                	ld	s0,8(sp)
 9e2:	0141                	addi	sp,sp,16
 9e4:	8082                	ret

00000000000009e6 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 9e6:	7139                	addi	sp,sp,-64
 9e8:	fc06                	sd	ra,56(sp)
 9ea:	f822                	sd	s0,48(sp)
 9ec:	f426                	sd	s1,40(sp)
 9ee:	ec4e                	sd	s3,24(sp)
 9f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9f2:	02051493          	slli	s1,a0,0x20
 9f6:	9081                	srli	s1,s1,0x20
 9f8:	04bd                	addi	s1,s1,15
 9fa:	8091                	srli	s1,s1,0x4
 9fc:	0014899b          	addiw	s3,s1,1
 a00:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 a02:	00001517          	auipc	a0,0x1
 a06:	5fe53503          	ld	a0,1534(a0) # 2000 <freep>
 a0a:	c915                	beqz	a0,a3e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a0c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a0e:	4798                	lw	a4,8(a5)
 a10:	08977e63          	bgeu	a4,s1,aac <malloc+0xc6>
 a14:	f04a                	sd	s2,32(sp)
 a16:	e852                	sd	s4,16(sp)
 a18:	e456                	sd	s5,8(sp)
 a1a:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 a1c:	8a4e                	mv	s4,s3
 a1e:	0009871b          	sext.w	a4,s3
 a22:	6685                	lui	a3,0x1
 a24:	00d77363          	bgeu	a4,a3,a2a <malloc+0x44>
 a28:	6a05                	lui	s4,0x1
 a2a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a32:	00001917          	auipc	s2,0x1
 a36:	5ce90913          	addi	s2,s2,1486 # 2000 <freep>
  if (p == (char *)-1) return 0;
 a3a:	5afd                	li	s5,-1
 a3c:	a091                	j	a80 <malloc+0x9a>
 a3e:	f04a                	sd	s2,32(sp)
 a40:	e852                	sd	s4,16(sp)
 a42:	e456                	sd	s5,8(sp)
 a44:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a46:	00001797          	auipc	a5,0x1
 a4a:	5ca78793          	addi	a5,a5,1482 # 2010 <base>
 a4e:	00001717          	auipc	a4,0x1
 a52:	5af73923          	sd	a5,1458(a4) # 2000 <freep>
 a56:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a58:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a5c:	b7c1                	j	a1c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a5e:	6398                	ld	a4,0(a5)
 a60:	e118                	sd	a4,0(a0)
 a62:	a08d                	j	ac4 <malloc+0xde>
  hp->s.size = nu;
 a64:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a68:	0541                	addi	a0,a0,16
 a6a:	00000097          	auipc	ra,0x0
 a6e:	efa080e7          	jalr	-262(ra) # 964 <free>
  return freep;
 a72:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 a76:	c13d                	beqz	a0,adc <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a78:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a7a:	4798                	lw	a4,8(a5)
 a7c:	02977463          	bgeu	a4,s1,aa4 <malloc+0xbe>
    if (p == freep)
 a80:	00093703          	ld	a4,0(s2)
 a84:	853e                	mv	a0,a5
 a86:	fef719e3          	bne	a4,a5,a78 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	bc2080e7          	jalr	-1086(ra) # 64e <sbrk>
  if (p == (char *)-1) return 0;
 a94:	fd5518e3          	bne	a0,s5,a64 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 a98:	4501                	li	a0,0
 a9a:	7902                	ld	s2,32(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
 aa2:	a03d                	j	ad0 <malloc+0xea>
 aa4:	7902                	ld	s2,32(sp)
 aa6:	6a42                	ld	s4,16(sp)
 aa8:	6aa2                	ld	s5,8(sp)
 aaa:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 aac:	fae489e3          	beq	s1,a4,a5e <malloc+0x78>
        p->s.size -= nunits;
 ab0:	4137073b          	subw	a4,a4,s3
 ab4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab6:	02071693          	slli	a3,a4,0x20
 aba:	01c6d713          	srli	a4,a3,0x1c
 abe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac4:	00001717          	auipc	a4,0x1
 ac8:	52a73e23          	sd	a0,1340(a4) # 2000 <freep>
      return (void *)(p + 1);
 acc:	01078513          	addi	a0,a5,16
  }
}
 ad0:	70e2                	ld	ra,56(sp)
 ad2:	7442                	ld	s0,48(sp)
 ad4:	74a2                	ld	s1,40(sp)
 ad6:	69e2                	ld	s3,24(sp)
 ad8:	6121                	addi	sp,sp,64
 ada:	8082                	ret
 adc:	7902                	ld	s2,32(sp)
 ade:	6a42                	ld	s4,16(sp)
 ae0:	6aa2                	ld	s5,8(sp)
 ae2:	6b02                	ld	s6,0(sp)
 ae4:	b7f5                	j	ad0 <malloc+0xea>
