
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:
#include "kernel/constants.h"
#include "user/user.h"

#define REGION_SZ (1024 * 1024 * 1024)

void sparse_memory(char *s) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	628080e7          	jalr	1576(ra) # 634 <sbrk>
  if (prev_end == (char *)0xffffffffffffffffL) {
  14:	57fd                	li	a5,-1
  16:	02f50c63          	beq	a0,a5,4e <sparse_memory+0x4e>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) *(char **)i = i;
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	400017b7          	lui	a5,0x40001
  22:	00f50733          	add	a4,a0,a5
  26:	87b2                	mv	a5,a2
  28:	000406b7          	lui	a3,0x40
  2c:	e39c                	sd	a5,0(a5)
  2e:	97b6                	add	a5,a5,a3
  30:	fee79ee3          	bne	a5,a4,2c <sparse_memory+0x2c>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  34:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
  38:	621c                	ld	a5,0(a2)
  3a:	02c79763          	bne	a5,a2,68 <sparse_memory+0x68>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  3e:	9636                	add	a2,a2,a3
  40:	fee61ce3          	bne	a2,a4,38 <sparse_memory+0x38>
      printf("failed to read value from memory\n");
      exit(1);
    }
  }

  exit(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	566080e7          	jalr	1382(ra) # 5ac <exit>
    printf("sbrk() failed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	a8250513          	addi	a0,a0,-1406 # ad0 <malloc+0x104>
  56:	00001097          	auipc	ra,0x1
  5a:	8be080e7          	jalr	-1858(ra) # 914 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	54c080e7          	jalr	1356(ra) # 5ac <exit>
      printf("failed to read value from memory\n");
  68:	00001517          	auipc	a0,0x1
  6c:	a7850513          	addi	a0,a0,-1416 # ae0 <malloc+0x114>
  70:	00001097          	auipc	ra,0x1
  74:	8a4080e7          	jalr	-1884(ra) # 914 <printf>
      exit(1);
  78:	4505                	li	a0,1
  7a:	00000097          	auipc	ra,0x0
  7e:	532080e7          	jalr	1330(ra) # 5ac <exit>

0000000000000082 <sparse_memory_unmap>:
}

void sparse_memory_unmap(char *s) {
  82:	7139                	addi	sp,sp,-64
  84:	fc06                	sd	ra,56(sp)
  86:	f822                	sd	s0,48(sp)
  88:	0080                	addi	s0,sp,64
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  8a:	40000537          	lui	a0,0x40000
  8e:	00000097          	auipc	ra,0x0
  92:	5a6080e7          	jalr	1446(ra) # 634 <sbrk>
  if (prev_end == (char *)0xffffffffffffffffL) {
  96:	57fd                	li	a5,-1
  98:	04f50c63          	beq	a0,a5,f0 <sparse_memory_unmap+0x6e>
  9c:	f426                	sd	s1,40(sp)
  9e:	f04a                	sd	s2,32(sp)
  a0:	ec4e                	sd	s3,24(sp)
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  a2:	6905                	lui	s2,0x1
  a4:	992a                	add	s2,s2,a0
  a6:	400017b7          	lui	a5,0x40001
  aa:	00f504b3          	add	s1,a0,a5
  ae:	87ca                	mv	a5,s2
  b0:	01000737          	lui	a4,0x1000
    *(char **)i = i;
  b4:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b6:	97ba                	add	a5,a5,a4
  b8:	fe979ee3          	bne	a5,s1,b4 <sparse_memory_unmap+0x32>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  bc:	010009b7          	lui	s3,0x1000
    pid = fork();
  c0:	00000097          	auipc	ra,0x0
  c4:	4e4080e7          	jalr	1252(ra) # 5a4 <fork>
    if (pid < 0) {
  c8:	04054463          	bltz	a0,110 <sparse_memory_unmap+0x8e>
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
  cc:	cd39                	beqz	a0,12a <sparse_memory_unmap+0xa8>
      sbrk(-1L * REGION_SZ);
      *(char **)i = i;
      exit(0);
    } else {
      int status;
      wait(&status);
  ce:	fcc40513          	addi	a0,s0,-52
  d2:	00000097          	auipc	ra,0x0
  d6:	4e2080e7          	jalr	1250(ra) # 5b4 <wait>
      if (status == 0) {
  da:	fcc42783          	lw	a5,-52(s0)
  de:	c3bd                	beqz	a5,144 <sparse_memory_unmap+0xc2>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  e0:	994e                	add	s2,s2,s3
  e2:	fc991fe3          	bne	s2,s1,c0 <sparse_memory_unmap+0x3e>
        exit(1);
      }
    }
  }

  exit(0);
  e6:	4501                	li	a0,0
  e8:	00000097          	auipc	ra,0x0
  ec:	4c4080e7          	jalr	1220(ra) # 5ac <exit>
  f0:	f426                	sd	s1,40(sp)
  f2:	f04a                	sd	s2,32(sp)
  f4:	ec4e                	sd	s3,24(sp)
    printf("sbrk() failed\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	9da50513          	addi	a0,a0,-1574 # ad0 <malloc+0x104>
  fe:	00001097          	auipc	ra,0x1
 102:	816080e7          	jalr	-2026(ra) # 914 <printf>
    exit(1);
 106:	4505                	li	a0,1
 108:	00000097          	auipc	ra,0x0
 10c:	4a4080e7          	jalr	1188(ra) # 5ac <exit>
      printf("error forking\n");
 110:	00001517          	auipc	a0,0x1
 114:	9f850513          	addi	a0,a0,-1544 # b08 <malloc+0x13c>
 118:	00000097          	auipc	ra,0x0
 11c:	7fc080e7          	jalr	2044(ra) # 914 <printf>
      exit(1);
 120:	4505                	li	a0,1
 122:	00000097          	auipc	ra,0x0
 126:	48a080e7          	jalr	1162(ra) # 5ac <exit>
      sbrk(-1L * REGION_SZ);
 12a:	c0000537          	lui	a0,0xc0000
 12e:	00000097          	auipc	ra,0x0
 132:	506080e7          	jalr	1286(ra) # 634 <sbrk>
      *(char **)i = i;
 136:	01293023          	sd	s2,0(s2) # 1000 <digits+0x360>
      exit(0);
 13a:	4501                	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	470080e7          	jalr	1136(ra) # 5ac <exit>
        printf("memory not unmapped\n");
 144:	00001517          	auipc	a0,0x1
 148:	9d450513          	addi	a0,a0,-1580 # b18 <malloc+0x14c>
 14c:	00000097          	auipc	ra,0x0
 150:	7c8080e7          	jalr	1992(ra) # 914 <printf>
        exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	456080e7          	jalr	1110(ra) # 5ac <exit>

000000000000015e <oom>:
}

void oom(char *s) {
 15e:	7179                	addi	sp,sp,-48
 160:	f406                	sd	ra,40(sp)
 162:	f022                	sd	s0,32(sp)
 164:	ec26                	sd	s1,24(sp)
 166:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid;

  if ((pid = fork()) == 0) {
 168:	00000097          	auipc	ra,0x0
 16c:	43c080e7          	jalr	1084(ra) # 5a4 <fork>
    m1 = 0;
 170:	4481                	li	s1,0
  if ((pid = fork()) == 0) {
 172:	c10d                	beqz	a0,194 <oom+0x36>
      m1 = m2;
    }
    exit(0);
  } else {
    int xstatus;
    wait(&xstatus);
 174:	fdc40513          	addi	a0,s0,-36
 178:	00000097          	auipc	ra,0x0
 17c:	43c080e7          	jalr	1084(ra) # 5b4 <wait>
    exit(xstatus == 0);
 180:	fdc42503          	lw	a0,-36(s0)
 184:	00153513          	seqz	a0,a0
 188:	00000097          	auipc	ra,0x0
 18c:	424080e7          	jalr	1060(ra) # 5ac <exit>
      *(char **)m2 = m1;
 190:	e104                	sd	s1,0(a0)
      m1 = m2;
 192:	84aa                	mv	s1,a0
    while ((m2 = malloc(4096 * 4096)) != 0) {
 194:	01000537          	lui	a0,0x1000
 198:	00001097          	auipc	ra,0x1
 19c:	834080e7          	jalr	-1996(ra) # 9cc <malloc>
 1a0:	f965                	bnez	a0,190 <oom+0x32>
    exit(0);
 1a2:	00000097          	auipc	ra,0x0
 1a6:	40a080e7          	jalr	1034(ra) # 5ac <exit>

00000000000001aa <run>:
  }
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s) {
 1aa:	7179                	addi	sp,sp,-48
 1ac:	f406                	sd	ra,40(sp)
 1ae:	f022                	sd	s0,32(sp)
 1b0:	ec26                	sd	s1,24(sp)
 1b2:	e84a                	sd	s2,16(sp)
 1b4:	1800                	addi	s0,sp,48
 1b6:	892a                	mv	s2,a0
 1b8:	84ae                	mv	s1,a1
  int pid;
  int xstatus;

  printf("running test %s\n", s);
 1ba:	00001517          	auipc	a0,0x1
 1be:	97650513          	addi	a0,a0,-1674 # b30 <malloc+0x164>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	752080e7          	jalr	1874(ra) # 914 <printf>
  if ((pid = fork()) < 0) {
 1ca:	00000097          	auipc	ra,0x0
 1ce:	3da080e7          	jalr	986(ra) # 5a4 <fork>
 1d2:	02054f63          	bltz	a0,210 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
 1d6:	c931                	beqz	a0,22a <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
 1d8:	fdc40513          	addi	a0,s0,-36
 1dc:	00000097          	auipc	ra,0x0
 1e0:	3d8080e7          	jalr	984(ra) # 5b4 <wait>
    if (xstatus != 0)
 1e4:	fdc42783          	lw	a5,-36(s0)
 1e8:	cba1                	beqz	a5,238 <run+0x8e>
      printf("test %s: FAILED\n", s);
 1ea:	85a6                	mv	a1,s1
 1ec:	00001517          	auipc	a0,0x1
 1f0:	97450513          	addi	a0,a0,-1676 # b60 <malloc+0x194>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	720080e7          	jalr	1824(ra) # 914 <printf>
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
 1fc:	fdc42503          	lw	a0,-36(s0)
  }
}
 200:	00153513          	seqz	a0,a0
 204:	70a2                	ld	ra,40(sp)
 206:	7402                	ld	s0,32(sp)
 208:	64e2                	ld	s1,24(sp)
 20a:	6942                	ld	s2,16(sp)
 20c:	6145                	addi	sp,sp,48
 20e:	8082                	ret
    printf("runtest: fork error\n");
 210:	00001517          	auipc	a0,0x1
 214:	93850513          	addi	a0,a0,-1736 # b48 <malloc+0x17c>
 218:	00000097          	auipc	ra,0x0
 21c:	6fc080e7          	jalr	1788(ra) # 914 <printf>
    exit(1);
 220:	4505                	li	a0,1
 222:	00000097          	auipc	ra,0x0
 226:	38a080e7          	jalr	906(ra) # 5ac <exit>
    f(s);
 22a:	8526                	mv	a0,s1
 22c:	9902                	jalr	s2
    exit(0);
 22e:	4501                	li	a0,0
 230:	00000097          	auipc	ra,0x0
 234:	37c080e7          	jalr	892(ra) # 5ac <exit>
      printf("test %s: OK\n", s);
 238:	85a6                	mv	a1,s1
 23a:	00001517          	auipc	a0,0x1
 23e:	93e50513          	addi	a0,a0,-1730 # b78 <malloc+0x1ac>
 242:	00000097          	auipc	ra,0x0
 246:	6d2080e7          	jalr	1746(ra) # 914 <printf>
 24a:	bf4d                	j	1fc <run+0x52>

000000000000024c <main>:

int main(int argc, char *argv[]) {
 24c:	7119                	addi	sp,sp,-128
 24e:	fc86                	sd	ra,120(sp)
 250:	f8a2                	sd	s0,112(sp)
 252:	f4a6                	sd	s1,104(sp)
 254:	f0ca                	sd	s2,96(sp)
 256:	ecce                	sd	s3,88(sp)
 258:	e8d2                	sd	s4,80(sp)
 25a:	e4d6                	sd	s5,72(sp)
 25c:	0100                	addi	s0,sp,128
  char *n = 0;
  if (argc > 1) {
 25e:	4785                	li	a5,1
  char *n = 0;
 260:	4981                	li	s3,0
  if (argc > 1) {
 262:	00a7d463          	bge	a5,a0,26a <main+0x1e>
    n = argv[1];
 266:	0085b983          	ld	s3,8(a1)
  }

  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 26a:	00001797          	auipc	a5,0x1
 26e:	99e78793          	addi	a5,a5,-1634 # c08 <malloc+0x23c>
 272:	0007b883          	ld	a7,0(a5)
 276:	0087b803          	ld	a6,8(a5)
 27a:	6b88                	ld	a0,16(a5)
 27c:	6f8c                	ld	a1,24(a5)
 27e:	7390                	ld	a2,32(a5)
 280:	7794                	ld	a3,40(a5)
 282:	7b98                	ld	a4,48(a5)
 284:	7f9c                	ld	a5,56(a5)
 286:	f9143023          	sd	a7,-128(s0)
 28a:	f9043423          	sd	a6,-120(s0)
 28e:	f8a43823          	sd	a0,-112(s0)
 292:	f8b43c23          	sd	a1,-104(s0)
 296:	fac43023          	sd	a2,-96(s0)
 29a:	fad43423          	sd	a3,-88(s0)
 29e:	fae43823          	sd	a4,-80(s0)
 2a2:	faf43c23          	sd	a5,-72(s0)
      {sparse_memory_unmap, "lazy unmap"},
      {oom, "out of memory"},
      {0, 0},
  };

  printf("lazytests starting\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	8e250513          	addi	a0,a0,-1822 # b88 <malloc+0x1bc>
 2ae:	00000097          	auipc	ra,0x0
 2b2:	666080e7          	jalr	1638(ra) # 914 <printf>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
 2b6:	f8843903          	ld	s2,-120(s0)
 2ba:	04090963          	beqz	s2,30c <main+0xc0>
 2be:	f8040493          	addi	s1,s0,-128
  int fail = 0;
 2c2:	4a01                	li	s4,0
    if ((n == 0) || strcmp(t->s, n) == 0) {
      if (!run(t->f, t->s)) fail = 1;
 2c4:	4a85                	li	s5,1
 2c6:	a031                	j	2d2 <main+0x86>
  for (struct test *t = tests; t->s != 0; t++) {
 2c8:	04c1                	addi	s1,s1,16
 2ca:	0084b903          	ld	s2,8(s1)
 2ce:	02090463          	beqz	s2,2f6 <main+0xaa>
    if ((n == 0) || strcmp(t->s, n) == 0) {
 2d2:	00098963          	beqz	s3,2e4 <main+0x98>
 2d6:	85ce                	mv	a1,s3
 2d8:	854a                	mv	a0,s2
 2da:	00000097          	auipc	ra,0x0
 2de:	082080e7          	jalr	130(ra) # 35c <strcmp>
 2e2:	f17d                	bnez	a0,2c8 <main+0x7c>
      if (!run(t->f, t->s)) fail = 1;
 2e4:	85ca                	mv	a1,s2
 2e6:	6088                	ld	a0,0(s1)
 2e8:	00000097          	auipc	ra,0x0
 2ec:	ec2080e7          	jalr	-318(ra) # 1aa <run>
 2f0:	fd61                	bnez	a0,2c8 <main+0x7c>
 2f2:	8a56                	mv	s4,s5
 2f4:	bfd1                	j	2c8 <main+0x7c>
    }
  }
  if (!fail)
 2f6:	000a0b63          	beqz	s4,30c <main+0xc0>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
 2fa:	00001517          	auipc	a0,0x1
 2fe:	8be50513          	addi	a0,a0,-1858 # bb8 <malloc+0x1ec>
 302:	00000097          	auipc	ra,0x0
 306:	612080e7          	jalr	1554(ra) # 914 <printf>
 30a:	a809                	j	31c <main+0xd0>
    printf("ALL TESTS PASSED\n");
 30c:	00001517          	auipc	a0,0x1
 310:	89450513          	addi	a0,a0,-1900 # ba0 <malloc+0x1d4>
 314:	00000097          	auipc	ra,0x0
 318:	600080e7          	jalr	1536(ra) # 914 <printf>
  exit(1);  // not reached.
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	28e080e7          	jalr	654(ra) # 5ac <exit>

0000000000000326 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 32e:	00000097          	auipc	ra,0x0
 332:	f1e080e7          	jalr	-226(ra) # 24c <main>
  exit(0);
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	274080e7          	jalr	628(ra) # 5ac <exit>

0000000000000340 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 346:	87aa                	mv	a5,a0
 348:	0585                	addi	a1,a1,1
 34a:	0785                	addi	a5,a5,1
 34c:	fff5c703          	lbu	a4,-1(a1)
 350:	fee78fa3          	sb	a4,-1(a5)
 354:	fb75                	bnez	a4,348 <strcpy+0x8>
  return os;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <strcmp>:

int strcmp(const char *p, const char *q) {
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 362:	00054783          	lbu	a5,0(a0)
 366:	cb91                	beqz	a5,37a <strcmp+0x1e>
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00f71763          	bne	a4,a5,37a <strcmp+0x1e>
 370:	0505                	addi	a0,a0,1
 372:	0585                	addi	a1,a1,1
 374:	00054783          	lbu	a5,0(a0)
 378:	fbe5                	bnez	a5,368 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 37a:	0005c503          	lbu	a0,0(a1)
}
 37e:	40a7853b          	subw	a0,a5,a0
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strlen>:

uint strlen(const char *s) {
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 38e:	00054783          	lbu	a5,0(a0)
 392:	cf91                	beqz	a5,3ae <strlen+0x26>
 394:	0505                	addi	a0,a0,1
 396:	87aa                	mv	a5,a0
 398:	86be                	mv	a3,a5
 39a:	0785                	addi	a5,a5,1
 39c:	fff7c703          	lbu	a4,-1(a5)
 3a0:	ff65                	bnez	a4,398 <strlen+0x10>
 3a2:	40a6853b          	subw	a0,a3,a0
 3a6:	2505                	addiw	a0,a0,1
  return n;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  for (n = 0; s[n]; n++);
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <strlen+0x20>

00000000000003b2 <memset>:

void *memset(void *dst, int c, uint n) {
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 3b8:	ca19                	beqz	a2,3ce <memset+0x1c>
 3ba:	87aa                	mv	a5,a0
 3bc:	1602                	slli	a2,a2,0x20
 3be:	9201                	srli	a2,a2,0x20
 3c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3c4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3c8:	0785                	addi	a5,a5,1
 3ca:	fee79de3          	bne	a5,a4,3c4 <memset+0x12>
  }
  return dst;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <strchr>:

char *strchr(const char *s, char c) {
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	cb99                	beqz	a5,3f4 <strchr+0x20>
    if (*s == c) return (char *)s;
 3e0:	00f58763          	beq	a1,a5,3ee <strchr+0x1a>
  for (; *s; s++)
 3e4:	0505                	addi	a0,a0,1
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	fbfd                	bnez	a5,3e0 <strchr+0xc>
  return 0;
 3ec:	4501                	li	a0,0
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	bfe5                	j	3ee <strchr+0x1a>

00000000000003f8 <gets>:

char *gets(char *buf, int max) {
 3f8:	711d                	addi	sp,sp,-96
 3fa:	ec86                	sd	ra,88(sp)
 3fc:	e8a2                	sd	s0,80(sp)
 3fe:	e4a6                	sd	s1,72(sp)
 400:	e0ca                	sd	s2,64(sp)
 402:	fc4e                	sd	s3,56(sp)
 404:	f852                	sd	s4,48(sp)
 406:	f456                	sd	s5,40(sp)
 408:	f05a                	sd	s6,32(sp)
 40a:	ec5e                	sd	s7,24(sp)
 40c:	1080                	addi	s0,sp,96
 40e:	8baa                	mv	s7,a0
 410:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 412:	892a                	mv	s2,a0
 414:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 416:	4aa9                	li	s5,10
 418:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 41a:	89a6                	mv	s3,s1
 41c:	2485                	addiw	s1,s1,1
 41e:	0344d863          	bge	s1,s4,44e <gets+0x56>
    cc = read(0, &c, 1);
 422:	4605                	li	a2,1
 424:	faf40593          	addi	a1,s0,-81
 428:	4501                	li	a0,0
 42a:	00000097          	auipc	ra,0x0
 42e:	19a080e7          	jalr	410(ra) # 5c4 <read>
    if (cc < 1) break;
 432:	00a05e63          	blez	a0,44e <gets+0x56>
    buf[i++] = c;
 436:	faf44783          	lbu	a5,-81(s0)
 43a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 43e:	01578763          	beq	a5,s5,44c <gets+0x54>
 442:	0905                	addi	s2,s2,1
 444:	fd679be3          	bne	a5,s6,41a <gets+0x22>
    buf[i++] = c;
 448:	89a6                	mv	s3,s1
 44a:	a011                	j	44e <gets+0x56>
 44c:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 44e:	99de                	add	s3,s3,s7
 450:	00098023          	sb	zero,0(s3) # 1000000 <base+0xffdff0>
  return buf;
}
 454:	855e                	mv	a0,s7
 456:	60e6                	ld	ra,88(sp)
 458:	6446                	ld	s0,80(sp)
 45a:	64a6                	ld	s1,72(sp)
 45c:	6906                	ld	s2,64(sp)
 45e:	79e2                	ld	s3,56(sp)
 460:	7a42                	ld	s4,48(sp)
 462:	7aa2                	ld	s5,40(sp)
 464:	7b02                	ld	s6,32(sp)
 466:	6be2                	ld	s7,24(sp)
 468:	6125                	addi	sp,sp,96
 46a:	8082                	ret

000000000000046c <stat>:

int stat(const char *n, struct stat *st) {
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	e04a                	sd	s2,0(sp)
 474:	1000                	addi	s0,sp,32
 476:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 478:	4581                	li	a1,0
 47a:	00000097          	auipc	ra,0x0
 47e:	172080e7          	jalr	370(ra) # 5ec <open>
  if (fd < 0) return -1;
 482:	02054663          	bltz	a0,4ae <stat+0x42>
 486:	e426                	sd	s1,8(sp)
 488:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	00000097          	auipc	ra,0x0
 490:	178080e7          	jalr	376(ra) # 604 <fstat>
 494:	892a                	mv	s2,a0
  close(fd);
 496:	8526                	mv	a0,s1
 498:	00000097          	auipc	ra,0x0
 49c:	13c080e7          	jalr	316(ra) # 5d4 <close>
  return r;
 4a0:	64a2                	ld	s1,8(sp)
}
 4a2:	854a                	mv	a0,s2
 4a4:	60e2                	ld	ra,24(sp)
 4a6:	6442                	ld	s0,16(sp)
 4a8:	6902                	ld	s2,0(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret
  if (fd < 0) return -1;
 4ae:	597d                	li	s2,-1
 4b0:	bfcd                	j	4a2 <stat+0x36>

00000000000004b2 <atoi>:

int atoi(const char *s) {
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x3dfc0>
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66863          	bltu	a2,a5,4f6 <atoi+0x44>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4ce:	0705                	addi	a4,a4,1 # 1000001 <base+0xffdff1>
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addiw	a0,a5,-48
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addiw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1c>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x3e>

00000000000004fa <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57463          	bgeu	a0,a1,528 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 504:	00c05f63          	blez	a2,522 <memmove+0x28>
 508:	1602                	slli	a2,a2,0x20
 50a:	9201                	srli	a2,a2,0x20
 50c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 510:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 512:	0585                	addi	a1,a1,1
 514:	0705                	addi	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
 51e:	fef71ae3          	bne	a4,a5,512 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 52e:	fec05ae3          	blez	a2,522 <memmove+0x28>
 532:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x35f>
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
 540:	15fd                	addi	a1,a1,-1
 542:	177d                	addi	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
 54c:	fee79ae3          	bne	a5,a4,540 <memmove+0x46>
 550:	bfc9                	j	522 <memmove+0x28>

0000000000000552 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 558:	ca05                	beqz	a2,588 <memcmp+0x36>
 55a:	fff6069b          	addiw	a3,a2,-1
 55e:	1682                	slli	a3,a3,0x20
 560:	9281                	srli	a3,a3,0x20
 562:	0685                	addi	a3,a3,1
 564:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79863          	bne	a5,a4,57e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	addi	a0,a0,1
    p2++;
 574:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x14>
  }
  return 0;
 57a:	4501                	li	a0,0
 57c:	a019                	j	582 <memcmp+0x30>
      return *p1 - *p2;
 57e:	40e7853b          	subw	a0,a5,a4
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <memcmp+0x30>

000000000000058c <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 58c:	1141                	addi	sp,sp,-16
 58e:	e406                	sd	ra,8(sp)
 590:	e022                	sd	s0,0(sp)
 592:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 594:	00000097          	auipc	ra,0x0
 598:	f66080e7          	jalr	-154(ra) # 4fa <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a4:	4885                	li	a7,1
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ac:	4889                	li	a7,2
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b4:	488d                	li	a7,3
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5bc:	4891                	li	a7,4
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <read>:
.global read
read:
 li a7, SYS_read
 5c4:	4895                	li	a7,5
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <write>:
.global write
write:
 li a7, SYS_write
 5cc:	48c1                	li	a7,16
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <close>:
.global close
close:
 li a7, SYS_close
 5d4:	48d5                	li	a7,21
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5dc:	4899                	li	a7,6
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e4:	489d                	li	a7,7
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <open>:
.global open
open:
 li a7, SYS_open
 5ec:	48bd                	li	a7,15
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f4:	48c5                	li	a7,17
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5fc:	48c9                	li	a7,18
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 604:	48a1                	li	a7,8
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <link>:
.global link
link:
 li a7, SYS_link
 60c:	48cd                	li	a7,19
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 614:	48d1                	li	a7,20
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 61c:	48a5                	li	a7,9
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <dup>:
.global dup
dup:
 li a7, SYS_dup
 624:	48a9                	li	a7,10
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 62c:	48ad                	li	a7,11
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 634:	48b1                	li	a7,12
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 63c:	48b5                	li	a7,13
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 644:	48b9                	li	a7,14
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 64c:	1101                	addi	sp,sp,-32
 64e:	ec06                	sd	ra,24(sp)
 650:	e822                	sd	s0,16(sp)
 652:	1000                	addi	s0,sp,32
 654:	feb407a3          	sb	a1,-17(s0)
 658:	4605                	li	a2,1
 65a:	fef40593          	addi	a1,s0,-17
 65e:	00000097          	auipc	ra,0x0
 662:	f6e080e7          	jalr	-146(ra) # 5cc <write>
 666:	60e2                	ld	ra,24(sp)
 668:	6442                	ld	s0,16(sp)
 66a:	6105                	addi	sp,sp,32
 66c:	8082                	ret

000000000000066e <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 66e:	7139                	addi	sp,sp,-64
 670:	fc06                	sd	ra,56(sp)
 672:	f822                	sd	s0,48(sp)
 674:	f426                	sd	s1,40(sp)
 676:	0080                	addi	s0,sp,64
 678:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 67a:	c299                	beqz	a3,680 <printint+0x12>
 67c:	0805cb63          	bltz	a1,712 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 680:	2581                	sext.w	a1,a1
  neg = 0;
 682:	4881                	li	a7,0
 684:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 688:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 68a:	2601                	sext.w	a2,a2
 68c:	00000517          	auipc	a0,0x0
 690:	61450513          	addi	a0,a0,1556 # ca0 <digits>
 694:	883a                	mv	a6,a4
 696:	2705                	addiw	a4,a4,1
 698:	02c5f7bb          	remuw	a5,a1,a2
 69c:	1782                	slli	a5,a5,0x20
 69e:	9381                	srli	a5,a5,0x20
 6a0:	97aa                	add	a5,a5,a0
 6a2:	0007c783          	lbu	a5,0(a5)
 6a6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 6aa:	0005879b          	sext.w	a5,a1
 6ae:	02c5d5bb          	divuw	a1,a1,a2
 6b2:	0685                	addi	a3,a3,1
 6b4:	fec7f0e3          	bgeu	a5,a2,694 <printint+0x26>
  if (neg) buf[i++] = '-';
 6b8:	00088c63          	beqz	a7,6d0 <printint+0x62>
 6bc:	fd070793          	addi	a5,a4,-48
 6c0:	00878733          	add	a4,a5,s0
 6c4:	02d00793          	li	a5,45
 6c8:	fef70823          	sb	a5,-16(a4)
 6cc:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 6d0:	02e05c63          	blez	a4,708 <printint+0x9a>
 6d4:	f04a                	sd	s2,32(sp)
 6d6:	ec4e                	sd	s3,24(sp)
 6d8:	fc040793          	addi	a5,s0,-64
 6dc:	00e78933          	add	s2,a5,a4
 6e0:	fff78993          	addi	s3,a5,-1
 6e4:	99ba                	add	s3,s3,a4
 6e6:	377d                	addiw	a4,a4,-1
 6e8:	1702                	slli	a4,a4,0x20
 6ea:	9301                	srli	a4,a4,0x20
 6ec:	40e989b3          	sub	s3,s3,a4
 6f0:	fff94583          	lbu	a1,-1(s2)
 6f4:	8526                	mv	a0,s1
 6f6:	00000097          	auipc	ra,0x0
 6fa:	f56080e7          	jalr	-170(ra) # 64c <putc>
 6fe:	197d                	addi	s2,s2,-1
 700:	ff3918e3          	bne	s2,s3,6f0 <printint+0x82>
 704:	7902                	ld	s2,32(sp)
 706:	69e2                	ld	s3,24(sp)
}
 708:	70e2                	ld	ra,56(sp)
 70a:	7442                	ld	s0,48(sp)
 70c:	74a2                	ld	s1,40(sp)
 70e:	6121                	addi	sp,sp,64
 710:	8082                	ret
    x = -xx;
 712:	40b005bb          	negw	a1,a1
    neg = 1;
 716:	4885                	li	a7,1
    x = -xx;
 718:	b7b5                	j	684 <printint+0x16>

000000000000071a <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 71a:	715d                	addi	sp,sp,-80
 71c:	e486                	sd	ra,72(sp)
 71e:	e0a2                	sd	s0,64(sp)
 720:	f84a                	sd	s2,48(sp)
 722:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 724:	0005c903          	lbu	s2,0(a1)
 728:	1a090a63          	beqz	s2,8dc <vprintf+0x1c2>
 72c:	fc26                	sd	s1,56(sp)
 72e:	f44e                	sd	s3,40(sp)
 730:	f052                	sd	s4,32(sp)
 732:	ec56                	sd	s5,24(sp)
 734:	e85a                	sd	s6,16(sp)
 736:	e45e                	sd	s7,8(sp)
 738:	8aaa                	mv	s5,a0
 73a:	8bb2                	mv	s7,a2
 73c:	00158493          	addi	s1,a1,1
  state = 0;
 740:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 742:	02500a13          	li	s4,37
 746:	4b55                	li	s6,21
 748:	a839                	j	766 <vprintf+0x4c>
        putc(fd, c);
 74a:	85ca                	mv	a1,s2
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	efe080e7          	jalr	-258(ra) # 64c <putc>
 756:	a019                	j	75c <vprintf+0x42>
    } else if (state == '%') {
 758:	01498d63          	beq	s3,s4,772 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 75c:	0485                	addi	s1,s1,1
 75e:	fff4c903          	lbu	s2,-1(s1)
 762:	16090763          	beqz	s2,8d0 <vprintf+0x1b6>
    if (state == 0) {
 766:	fe0999e3          	bnez	s3,758 <vprintf+0x3e>
      if (c == '%') {
 76a:	ff4910e3          	bne	s2,s4,74a <vprintf+0x30>
        state = '%';
 76e:	89d2                	mv	s3,s4
 770:	b7f5                	j	75c <vprintf+0x42>
      if (c == 'd') {
 772:	13490463          	beq	s2,s4,89a <vprintf+0x180>
 776:	f9d9079b          	addiw	a5,s2,-99
 77a:	0ff7f793          	zext.b	a5,a5
 77e:	12fb6763          	bltu	s6,a5,8ac <vprintf+0x192>
 782:	f9d9079b          	addiw	a5,s2,-99
 786:	0ff7f713          	zext.b	a4,a5
 78a:	12eb6163          	bltu	s6,a4,8ac <vprintf+0x192>
 78e:	00271793          	slli	a5,a4,0x2
 792:	00000717          	auipc	a4,0x0
 796:	4b670713          	addi	a4,a4,1206 # c48 <malloc+0x27c>
 79a:	97ba                	add	a5,a5,a4
 79c:	439c                	lw	a5,0(a5)
 79e:	97ba                	add	a5,a5,a4
 7a0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	4685                	li	a3,1
 7a8:	4629                	li	a2,10
 7aa:	000ba583          	lw	a1,0(s7)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	ebe080e7          	jalr	-322(ra) # 66e <printint>
 7b8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b745                	j	75c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	ea2080e7          	jalr	-350(ra) # 66e <printint>
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b751                	j	75c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4681                	li	a3,0
 7e0:	4641                	li	a2,16
 7e2:	000ba583          	lw	a1,0(s7)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e86080e7          	jalr	-378(ra) # 66e <printint>
 7f0:	8bca                	mv	s7,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b7a5                	j	75c <vprintf+0x42>
 7f6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7f8:	008b8c13          	addi	s8,s7,8
 7fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 800:	03000593          	li	a1,48
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	e46080e7          	jalr	-442(ra) # 64c <putc>
  putc(fd, 'x');
 80e:	07800593          	li	a1,120
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	e38080e7          	jalr	-456(ra) # 64c <putc>
 81c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81e:	00000b97          	auipc	s7,0x0
 822:	482b8b93          	addi	s7,s7,1154 # ca0 <digits>
 826:	03c9d793          	srli	a5,s3,0x3c
 82a:	97de                	add	a5,a5,s7
 82c:	0007c583          	lbu	a1,0(a5)
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e1a080e7          	jalr	-486(ra) # 64c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 83a:	0992                	slli	s3,s3,0x4
 83c:	397d                	addiw	s2,s2,-1
 83e:	fe0914e3          	bnez	s2,826 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 842:	8be2                	mv	s7,s8
      state = 0;
 844:	4981                	li	s3,0
 846:	6c02                	ld	s8,0(sp)
 848:	bf11                	j	75c <vprintf+0x42>
        s = va_arg(ap, char *);
 84a:	008b8993          	addi	s3,s7,8
 84e:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 852:	02090163          	beqz	s2,874 <vprintf+0x15a>
        while (*s != 0) {
 856:	00094583          	lbu	a1,0(s2)
 85a:	c9a5                	beqz	a1,8ca <vprintf+0x1b0>
          putc(fd, *s);
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	dee080e7          	jalr	-530(ra) # 64c <putc>
          s++;
 866:	0905                	addi	s2,s2,1
        while (*s != 0) {
 868:	00094583          	lbu	a1,0(s2)
 86c:	f9e5                	bnez	a1,85c <vprintf+0x142>
        s = va_arg(ap, char *);
 86e:	8bce                	mv	s7,s3
      state = 0;
 870:	4981                	li	s3,0
 872:	b5ed                	j	75c <vprintf+0x42>
        if (s == 0) s = "(null)";
 874:	00000917          	auipc	s2,0x0
 878:	38c90913          	addi	s2,s2,908 # c00 <malloc+0x234>
        while (*s != 0) {
 87c:	02800593          	li	a1,40
 880:	bff1                	j	85c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 882:	008b8913          	addi	s2,s7,8
 886:	000bc583          	lbu	a1,0(s7)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	dc0080e7          	jalr	-576(ra) # 64c <putc>
 894:	8bca                	mv	s7,s2
      state = 0;
 896:	4981                	li	s3,0
 898:	b5d1                	j	75c <vprintf+0x42>
        putc(fd, c);
 89a:	02500593          	li	a1,37
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	dac080e7          	jalr	-596(ra) # 64c <putc>
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bd4d                	j	75c <vprintf+0x42>
        putc(fd, '%');
 8ac:	02500593          	li	a1,37
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d9a080e7          	jalr	-614(ra) # 64c <putc>
        putc(fd, c);
 8ba:	85ca                	mv	a1,s2
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	d8e080e7          	jalr	-626(ra) # 64c <putc>
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	bd51                	j	75c <vprintf+0x42>
        s = va_arg(ap, char *);
 8ca:	8bce                	mv	s7,s3
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b579                	j	75c <vprintf+0x42>
 8d0:	74e2                	ld	s1,56(sp)
 8d2:	79a2                	ld	s3,40(sp)
 8d4:	7a02                	ld	s4,32(sp)
 8d6:	6ae2                	ld	s5,24(sp)
 8d8:	6b42                	ld	s6,16(sp)
 8da:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8dc:	60a6                	ld	ra,72(sp)
 8de:	6406                	ld	s0,64(sp)
 8e0:	7942                	ld	s2,48(sp)
 8e2:	6161                	addi	sp,sp,80
 8e4:	8082                	ret

00000000000008e6 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 8e6:	715d                	addi	sp,sp,-80
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e010                	sd	a2,0(s0)
 8f0:	e414                	sd	a3,8(s0)
 8f2:	e818                	sd	a4,16(s0)
 8f4:	ec1c                	sd	a5,24(s0)
 8f6:	03043023          	sd	a6,32(s0)
 8fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 902:	8622                	mv	a2,s0
 904:	00000097          	auipc	ra,0x0
 908:	e16080e7          	jalr	-490(ra) # 71a <vprintf>
}
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	6161                	addi	sp,sp,80
 912:	8082                	ret

0000000000000914 <printf>:

void printf(const char *fmt, ...) {
 914:	711d                	addi	sp,sp,-96
 916:	ec06                	sd	ra,24(sp)
 918:	e822                	sd	s0,16(sp)
 91a:	1000                	addi	s0,sp,32
 91c:	e40c                	sd	a1,8(s0)
 91e:	e810                	sd	a2,16(s0)
 920:	ec14                	sd	a3,24(s0)
 922:	f018                	sd	a4,32(s0)
 924:	f41c                	sd	a5,40(s0)
 926:	03043823          	sd	a6,48(s0)
 92a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92e:	00840613          	addi	a2,s0,8
 932:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 936:	85aa                	mv	a1,a0
 938:	4505                	li	a0,1
 93a:	00000097          	auipc	ra,0x0
 93e:	de0080e7          	jalr	-544(ra) # 71a <vprintf>
}
 942:	60e2                	ld	ra,24(sp)
 944:	6442                	ld	s0,16(sp)
 946:	6125                	addi	sp,sp,96
 948:	8082                	ret

000000000000094a <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 94a:	1141                	addi	sp,sp,-16
 94c:	e422                	sd	s0,8(sp)
 94e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 950:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 954:	00001797          	auipc	a5,0x1
 958:	6ac7b783          	ld	a5,1708(a5) # 2000 <freep>
 95c:	a02d                	j	986 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 95e:	4618                	lw	a4,8(a2)
 960:	9f2d                	addw	a4,a4,a1
 962:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	6310                	ld	a2,0(a4)
 96a:	a83d                	j	9a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9f31                	addw	a4,a4,a2
 972:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053683          	ld	a3,-16(a0)
 978:	a091                	j	9bc <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 97a:	6398                	ld	a4,0(a5)
 97c:	00e7e463          	bltu	a5,a4,984 <free+0x3a>
 980:	00e6ea63          	bltu	a3,a4,994 <free+0x4a>
void free(void *ap) {
 984:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 986:	fed7fae3          	bgeu	a5,a3,97a <free+0x30>
 98a:	6398                	ld	a4,0(a5)
 98c:	00e6e463          	bltu	a3,a4,994 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 990:	fee7eae3          	bltu	a5,a4,984 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 994:	ff852583          	lw	a1,-8(a0)
 998:	6390                	ld	a2,0(a5)
 99a:	02059813          	slli	a6,a1,0x20
 99e:	01c85713          	srli	a4,a6,0x1c
 9a2:	9736                	add	a4,a4,a3
 9a4:	fae60de3          	beq	a2,a4,95e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a8:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9ac:	4790                	lw	a2,8(a5)
 9ae:	02061593          	slli	a1,a2,0x20
 9b2:	01c5d713          	srli	a4,a1,0x1c
 9b6:	973e                	add	a4,a4,a5
 9b8:	fae68ae3          	beq	a3,a4,96c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9be:	00001717          	auipc	a4,0x1
 9c2:	64f73123          	sd	a5,1602(a4) # 2000 <freep>
}
 9c6:	6422                	ld	s0,8(sp)
 9c8:	0141                	addi	sp,sp,16
 9ca:	8082                	ret

00000000000009cc <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 9cc:	7139                	addi	sp,sp,-64
 9ce:	fc06                	sd	ra,56(sp)
 9d0:	f822                	sd	s0,48(sp)
 9d2:	f426                	sd	s1,40(sp)
 9d4:	ec4e                	sd	s3,24(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 9e8:	00001517          	auipc	a0,0x1
 9ec:	61853503          	ld	a0,1560(a0) # 2000 <freep>
 9f0:	c915                	beqz	a0,a24 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9f2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9f4:	4798                	lw	a4,8(a5)
 9f6:	08977e63          	bgeu	a4,s1,a92 <malloc+0xc6>
 9fa:	f04a                	sd	s2,32(sp)
 9fc:	e852                	sd	s4,16(sp)
 9fe:	e456                	sd	s5,8(sp)
 a00:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 a02:	8a4e                	mv	s4,s3
 a04:	0009871b          	sext.w	a4,s3
 a08:	6685                	lui	a3,0x1
 a0a:	00d77363          	bgeu	a4,a3,a10 <malloc+0x44>
 a0e:	6a05                	lui	s4,0x1
 a10:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a14:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a18:	00001917          	auipc	s2,0x1
 a1c:	5e890913          	addi	s2,s2,1512 # 2000 <freep>
  if (p == (char *)-1) return 0;
 a20:	5afd                	li	s5,-1
 a22:	a091                	j	a66 <malloc+0x9a>
 a24:	f04a                	sd	s2,32(sp)
 a26:	e852                	sd	s4,16(sp)
 a28:	e456                	sd	s5,8(sp)
 a2a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a2c:	00001797          	auipc	a5,0x1
 a30:	5e478793          	addi	a5,a5,1508 # 2010 <base>
 a34:	00001717          	auipc	a4,0x1
 a38:	5cf73623          	sd	a5,1484(a4) # 2000 <freep>
 a3c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a42:	b7c1                	j	a02 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a44:	6398                	ld	a4,0(a5)
 a46:	e118                	sd	a4,0(a0)
 a48:	a08d                	j	aaa <malloc+0xde>
  hp->s.size = nu;
 a4a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a4e:	0541                	addi	a0,a0,16
 a50:	00000097          	auipc	ra,0x0
 a54:	efa080e7          	jalr	-262(ra) # 94a <free>
  return freep;
 a58:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 a5c:	c13d                	beqz	a0,ac2 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a5e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a60:	4798                	lw	a4,8(a5)
 a62:	02977463          	bgeu	a4,s1,a8a <malloc+0xbe>
    if (p == freep)
 a66:	00093703          	ld	a4,0(s2)
 a6a:	853e                	mv	a0,a5
 a6c:	fef719e3          	bne	a4,a5,a5e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a70:	8552                	mv	a0,s4
 a72:	00000097          	auipc	ra,0x0
 a76:	bc2080e7          	jalr	-1086(ra) # 634 <sbrk>
  if (p == (char *)-1) return 0;
 a7a:	fd5518e3          	bne	a0,s5,a4a <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 a7e:	4501                	li	a0,0
 a80:	7902                	ld	s2,32(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	a03d                	j	ab6 <malloc+0xea>
 a8a:	7902                	ld	s2,32(sp)
 a8c:	6a42                	ld	s4,16(sp)
 a8e:	6aa2                	ld	s5,8(sp)
 a90:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a92:	fae489e3          	beq	s1,a4,a44 <malloc+0x78>
        p->s.size -= nunits;
 a96:	4137073b          	subw	a4,a4,s3
 a9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a9c:	02071693          	slli	a3,a4,0x20
 aa0:	01c6d713          	srli	a4,a3,0x1c
 aa4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aaa:	00001717          	auipc	a4,0x1
 aae:	54a73b23          	sd	a0,1366(a4) # 2000 <freep>
      return (void *)(p + 1);
 ab2:	01078513          	addi	a0,a5,16
  }
}
 ab6:	70e2                	ld	ra,56(sp)
 ab8:	7442                	ld	s0,48(sp)
 aba:	74a2                	ld	s1,40(sp)
 abc:	69e2                	ld	s3,24(sp)
 abe:	6121                	addi	sp,sp,64
 ac0:	8082                	ret
 ac2:	7902                	ld	s2,32(sp)
 ac4:	6a42                	ld	s4,16(sp)
 ac6:	6aa2                	ld	s5,8(sp)
 ac8:	6b02                	ld	s6,0(sp)
 aca:	b7f5                	j	ab6 <malloc+0xea>
