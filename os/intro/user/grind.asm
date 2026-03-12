
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/stat.h"
#include "kernel/types.h"
#include "user/user.h"

// from FreeBSD.
int do_rand(unsigned long *ctx) {
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
   * October 1988, p. 1195.
   */
  long hi, lo, x;

  /* Transform to [1, 0x7ffffffe] range. */
  x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
  hi = x / 127773;
  lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
  x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
  hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
  x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
  if (x < 0) x += 0x7fffffff;
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
  /* Transform to [0, 0x7ffffffd] range. */
  x--;
      3e:	17fd                	addi	a5,a5,-1
  *ctx = x;
      40:	e11c                	sd	a5,0(a0)
  return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
  if (x < 0) x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int rand(void) { return (do_rand(&rand_next)); }
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void go(int which_child) {
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	fc56                	sd	s5,56(sp)
      82:	1880                	addi	s0,sp,112
      84:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	eba080e7          	jalr	-326(ra) # f42 <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	3ae50513          	addi	a0,a0,942 # 1440 <loop+0xa>
      9a:	00001097          	auipc	ra,0x1
      9e:	e88080e7          	jalr	-376(ra) # f22 <mkdir>
  if (chdir("grindir") != 0) {
      a2:	00001517          	auipc	a0,0x1
      a6:	39e50513          	addi	a0,a0,926 # 1440 <loop+0xa>
      aa:	00001097          	auipc	ra,0x1
      ae:	e80080e7          	jalr	-384(ra) # f2a <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	38c50513          	addi	a0,a0,908 # 1448 <loop+0x12>
      c4:	00001097          	auipc	ra,0x1
      c8:	166080e7          	jalr	358(ra) # 122a <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	dec080e7          	jalr	-532(ra) # eba <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	39250513          	addi	a0,a0,914 # 1470 <loop+0x3a>
      e6:	00001097          	auipc	ra,0x1
      ea:	e44080e7          	jalr	-444(ra) # f2a <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	39298993          	addi	s3,s3,914 # 1480 <loop+0x4a>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	38098993          	addi	s3,s3,896 # 1478 <loop+0x42>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00001917          	auipc	s2,0x1
     108:	64c90913          	addi	s2,s2,1612 # 1750 <loop+0x31a>
     10c:	a839                	j	12a <go+0xb2>
  while (1) {
    iters++;
    if ((iters % 500) == 0) write(1, which_child ? "B" : "A", 1);
    int what = rand() % 23;
    if (what == 1) {
      close(open("grindir/../a", O_CREATE | O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	37650513          	addi	a0,a0,886 # 1488 <loop+0x52>
     11a:	00001097          	auipc	ra,0x1
     11e:	de0080e7          	jalr	-544(ra) # efa <open>
     122:	00001097          	auipc	ra,0x1
     126:	dc0080e7          	jalr	-576(ra) # ee2 <close>
    iters++;
     12a:	0485                	addi	s1,s1,1
    if ((iters % 500) == 0) write(1, which_child ? "B" : "A", 1);
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	d9e080e7          	jalr	-610(ra) # eda <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
     152:	0005071b          	sext.w	a4,a0
     156:	47d9                	li	a5,22
     158:	fce7e9e3          	bltu	a5,a4,12a <go+0xb2>
     15c:	02051793          	slli	a5,a0,0x20
     160:	01e7d513          	srli	a0,a5,0x1e
     164:	954a                	add	a0,a0,s2
     166:	411c                	lw	a5,0(a0)
     168:	97ca                	add	a5,a5,s2
     16a:	8782                	jr	a5
    } else if (what == 2) {
      close(open("grindir/../grindir/../b", O_CREATE | O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	32850513          	addi	a0,a0,808 # 1498 <loop+0x62>
     178:	00001097          	auipc	ra,0x1
     17c:	d82080e7          	jalr	-638(ra) # efa <open>
     180:	00001097          	auipc	ra,0x1
     184:	d62080e7          	jalr	-670(ra) # ee2 <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if (what == 3) {
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	2fe50513          	addi	a0,a0,766 # 1488 <loop+0x52>
     192:	00001097          	auipc	ra,0x1
     196:	d78080e7          	jalr	-648(ra) # f0a <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if (what == 4) {
      if (chdir("grindir") != 0) {
     19c:	00001517          	auipc	a0,0x1
     1a0:	2a450513          	addi	a0,a0,676 # 1440 <loop+0xa>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	d86080e7          	jalr	-634(ra) # f2a <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	30250513          	addi	a0,a0,770 # 14b0 <loop+0x7a>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	d54080e7          	jalr	-684(ra) # f0a <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	2b250513          	addi	a0,a0,690 # 1470 <loop+0x3a>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	d64080e7          	jalr	-668(ra) # f2a <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	27850513          	addi	a0,a0,632 # 1448 <loop+0x12>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	052080e7          	jalr	82(ra) # 122a <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	cd8080e7          	jalr	-808(ra) # eba <exit>
    } else if (what == 5) {
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	cf6080e7          	jalr	-778(ra) # ee2 <close>
      fd = open("/grindir/../a", O_CREATE | O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	2c050513          	addi	a0,a0,704 # 14b8 <loop+0x82>
     200:	00001097          	auipc	ra,0x1
     204:	cfa080e7          	jalr	-774(ra) # efa <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if (what == 6) {
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	cd4080e7          	jalr	-812(ra) # ee2 <close>
      fd = open("/./grindir/./../b", O_CREATE | O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	2ae50513          	addi	a0,a0,686 # 14c8 <loop+0x92>
     222:	00001097          	auipc	ra,0x1
     226:	cd8080e7          	jalr	-808(ra) # efa <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if (what == 7) {
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	dee58593          	addi	a1,a1,-530 # 2020 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	c9e080e7          	jalr	-866(ra) # eda <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if (what == 8) {
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	dd658593          	addi	a1,a1,-554 # 2020 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	c7e080e7          	jalr	-898(ra) # ed2 <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if (what == 9) {
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	22a50513          	addi	a0,a0,554 # 1488 <loop+0x52>
     266:	00001097          	auipc	ra,0x1
     26a:	cbc080e7          	jalr	-836(ra) # f22 <mkdir>
      close(open("a/../a/./a", O_CREATE | O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	26e50513          	addi	a0,a0,622 # 14e0 <loop+0xaa>
     27a:	00001097          	auipc	ra,0x1
     27e:	c80080e7          	jalr	-896(ra) # efa <open>
     282:	00001097          	auipc	ra,0x1
     286:	c60080e7          	jalr	-928(ra) # ee2 <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	26650513          	addi	a0,a0,614 # 14f0 <loop+0xba>
     292:	00001097          	auipc	ra,0x1
     296:	c78080e7          	jalr	-904(ra) # f0a <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if (what == 10) {
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	25c50513          	addi	a0,a0,604 # 14f8 <loop+0xc2>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	c7e080e7          	jalr	-898(ra) # f22 <mkdir>
      close(open("grindir/../b/b", O_CREATE | O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	25050513          	addi	a0,a0,592 # 1500 <loop+0xca>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	c42080e7          	jalr	-958(ra) # efa <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	c22080e7          	jalr	-990(ra) # ee2 <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	24850513          	addi	a0,a0,584 # 1510 <loop+0xda>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	c3a080e7          	jalr	-966(ra) # f0a <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if (what == 11) {
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	23e50513          	addi	a0,a0,574 # 1518 <loop+0xe2>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	c28080e7          	jalr	-984(ra) # f0a <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	1c658593          	addi	a1,a1,454 # 14b0 <loop+0x7a>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	22e50513          	addi	a0,a0,558 # 1520 <loop+0xea>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	c20080e7          	jalr	-992(ra) # f1a <link>
     302:	b525                	j	12a <go+0xb2>
    } else if (what == 12) {
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	23450513          	addi	a0,a0,564 # 1538 <loop+0x102>
     30c:	00001097          	auipc	ra,0x1
     310:	bfe080e7          	jalr	-1026(ra) # f0a <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	1a458593          	addi	a1,a1,420 # 14b8 <loop+0x82>
     31c:	00001517          	auipc	a0,0x1
     320:	22c50513          	addi	a0,a0,556 # 1548 <loop+0x112>
     324:	00001097          	auipc	ra,0x1
     328:	bf6080e7          	jalr	-1034(ra) # f1a <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if (what == 13) {
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	b84080e7          	jalr	-1148(ra) # eb2 <fork>
      if (pid == 0) {
     336:	c909                	beqz	a0,348 <go+0x2d0>
        exit(0);
      } else if (pid < 0) {
     338:	00054c63          	bltz	a0,350 <go+0x2d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	b84080e7          	jalr	-1148(ra) # ec2 <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	b72080e7          	jalr	-1166(ra) # eba <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	20050513          	addi	a0,a0,512 # 1550 <loop+0x11a>
     358:	00001097          	auipc	ra,0x1
     35c:	ed2080e7          	jalr	-302(ra) # 122a <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	b58080e7          	jalr	-1192(ra) # eba <exit>
    } else if (what == 14) {
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	b48080e7          	jalr	-1208(ra) # eb2 <fork>
      if (pid == 0) {
     372:	c909                	beqz	a0,384 <go+0x30c>
        fork();
        fork();
        exit(0);
      } else if (pid < 0) {
     374:	02054563          	bltz	a0,39e <go+0x326>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	4501                	li	a0,0
     37a:	00001097          	auipc	ra,0x1
     37e:	b48080e7          	jalr	-1208(ra) # ec2 <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	b2e080e7          	jalr	-1234(ra) # eb2 <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	b26080e7          	jalr	-1242(ra) # eb2 <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	b24080e7          	jalr	-1244(ra) # eba <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	1b250513          	addi	a0,a0,434 # 1550 <loop+0x11a>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	e84080e7          	jalr	-380(ra) # 122a <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	b0a080e7          	jalr	-1270(ra) # eba <exit>
    } else if (what == 15) {
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	addi	a0,a0,1915 # 177b <loop+0x345>
     3be:	00001097          	auipc	ra,0x1
     3c2:	b84080e7          	jalr	-1148(ra) # f42 <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if (what == 16) {
      if (sbrk(0) > break0) sbrk(-(sbrk(0) - break0));
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b78080e7          	jalr	-1160(ra) # f42 <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	b6a080e7          	jalr	-1174(ra) # f42 <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	b5e080e7          	jalr	-1186(ra) # f42 <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if (what == 17) {
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	ac4080e7          	jalr	-1340(ra) # eb2 <fork>
     3f6:	8b2a                	mv	s6,a0
      if (pid == 0) {
     3f8:	c51d                	beqz	a0,426 <go+0x3ae>
        close(open("a", O_CREATE | O_RDWR));
        exit(0);
      } else if (pid < 0) {
     3fa:	04054963          	bltz	a0,44c <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      if (chdir("../grindir/..") != 0) {
     3fe:	00001517          	auipc	a0,0x1
     402:	17250513          	addi	a0,a0,370 # 1570 <loop+0x13a>
     406:	00001097          	auipc	ra,0x1
     40a:	b24080e7          	jalr	-1244(ra) # f2a <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	ad8080e7          	jalr	-1320(ra) # eea <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	aa6080e7          	jalr	-1370(ra) # ec2 <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE | O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	13e50513          	addi	a0,a0,318 # 1568 <loop+0x132>
     432:	00001097          	auipc	ra,0x1
     436:	ac8080e7          	jalr	-1336(ra) # efa <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	aa8080e7          	jalr	-1368(ra) # ee2 <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	a76080e7          	jalr	-1418(ra) # eba <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	10450513          	addi	a0,a0,260 # 1550 <loop+0x11a>
     454:	00001097          	auipc	ra,0x1
     458:	dd6080e7          	jalr	-554(ra) # 122a <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	a5c080e7          	jalr	-1444(ra) # eba <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	11a50513          	addi	a0,a0,282 # 1580 <loop+0x14a>
     46e:	00001097          	auipc	ra,0x1
     472:	dbc080e7          	jalr	-580(ra) # 122a <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	a42080e7          	jalr	-1470(ra) # eba <exit>
    } else if (what == 18) {
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	a32080e7          	jalr	-1486(ra) # eb2 <fork>
      if (pid == 0) {
     488:	c909                	beqz	a0,49a <go+0x422>
        kill(getpid());
        exit(0);
      } else if (pid < 0) {
     48a:	02054563          	bltz	a0,4b4 <go+0x43c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     48e:	4501                	li	a0,0
     490:	00001097          	auipc	ra,0x1
     494:	a32080e7          	jalr	-1486(ra) # ec2 <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	aa0080e7          	jalr	-1376(ra) # f3a <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	a48080e7          	jalr	-1464(ra) # eea <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	a0e080e7          	jalr	-1522(ra) # eba <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	09c50513          	addi	a0,a0,156 # 1550 <loop+0x11a>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d6e080e7          	jalr	-658(ra) # 122a <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	9f4080e7          	jalr	-1548(ra) # eba <exit>
    } else if (what == 19) {
      int fds[2];
      if (pipe(fds) < 0) {
     4ce:	fa840513          	addi	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	9f8080e7          	jalr	-1544(ra) # eca <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	9d4080e7          	jalr	-1580(ra) # eb2 <fork>
      if (pid == 0) {
     4e6:	c131                	beqz	a0,52a <go+0x4b2>
        fork();
        if (write(fds[1], "x", 1) != 1) printf("grind: pipe write failed\n");
        char c;
        if (read(fds[0], &c, 1) != 1) printf("grind: pipe read failed\n");
        exit(0);
      } else if (pid < 0) {
     4e8:	0a054a63          	bltz	a0,59c <go+0x524>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	9f2080e7          	jalr	-1550(ra) # ee2 <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	9e6080e7          	jalr	-1562(ra) # ee2 <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	9bc080e7          	jalr	-1604(ra) # ec2 <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	08850513          	addi	a0,a0,136 # 1598 <loop+0x162>
     518:	00001097          	auipc	ra,0x1
     51c:	d12080e7          	jalr	-750(ra) # 122a <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	998080e7          	jalr	-1640(ra) # eba <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	988080e7          	jalr	-1656(ra) # eb2 <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	980080e7          	jalr	-1664(ra) # eb2 <fork>
        if (write(fds[1], "x", 1) != 1) printf("grind: pipe write failed\n");
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	07458593          	addi	a1,a1,116 # 15b0 <loop+0x17a>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	992080e7          	jalr	-1646(ra) # eda <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if (read(fds[0], &c, 1) != 1) printf("grind: pipe read failed\n");
     556:	4605                	li	a2,1
     558:	fa040593          	addi	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	972080e7          	jalr	-1678(ra) # ed2 <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	94a080e7          	jalr	-1718(ra) # eba <exit>
        if (write(fds[1], "x", 1) != 1) printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	04050513          	addi	a0,a0,64 # 15b8 <loop+0x182>
     580:	00001097          	auipc	ra,0x1
     584:	caa080e7          	jalr	-854(ra) # 122a <printf>
     588:	b7f9                	j	556 <go+0x4de>
        if (read(fds[0], &c, 1) != 1) printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	04e50513          	addi	a0,a0,78 # 15d8 <loop+0x1a2>
     592:	00001097          	auipc	ra,0x1
     596:	c98080e7          	jalr	-872(ra) # 122a <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	fb450513          	addi	a0,a0,-76 # 1550 <loop+0x11a>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	c86080e7          	jalr	-890(ra) # 122a <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	90c080e7          	jalr	-1780(ra) # eba <exit>
    } else if (what == 20) {
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	8fc080e7          	jalr	-1796(ra) # eb2 <fork>
      if (pid == 0) {
     5be:	c909                	beqz	a0,5d0 <go+0x558>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE | O_RDWR);
        unlink("x");
        exit(0);
      } else if (pid < 0) {
     5c0:	06054f63          	bltz	a0,63e <go+0x5c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5c4:	4501                	li	a0,0
     5c6:	00001097          	auipc	ra,0x1
     5ca:	8fc080e7          	jalr	-1796(ra) # ec2 <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	f9850513          	addi	a0,a0,-104 # 1568 <loop+0x132>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	932080e7          	jalr	-1742(ra) # f0a <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	f8850513          	addi	a0,a0,-120 # 1568 <loop+0x132>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	93a080e7          	jalr	-1734(ra) # f22 <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	f7850513          	addi	a0,a0,-136 # 1568 <loop+0x132>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	932080e7          	jalr	-1742(ra) # f2a <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	ff850513          	addi	a0,a0,-8 # 15f8 <loop+0x1c2>
     608:	00001097          	auipc	ra,0x1
     60c:	902080e7          	jalr	-1790(ra) # f0a <unlink>
        fd = open("x", O_CREATE | O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	f9c50513          	addi	a0,a0,-100 # 15b0 <loop+0x17a>
     61c:	00001097          	auipc	ra,0x1
     620:	8de080e7          	jalr	-1826(ra) # efa <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	f8c50513          	addi	a0,a0,-116 # 15b0 <loop+0x17a>
     62c:	00001097          	auipc	ra,0x1
     630:	8de080e7          	jalr	-1826(ra) # f0a <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00001097          	auipc	ra,0x1
     63a:	884080e7          	jalr	-1916(ra) # eba <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	f1250513          	addi	a0,a0,-238 # 1550 <loop+0x11a>
     646:	00001097          	auipc	ra,0x1
     64a:	be4080e7          	jalr	-1052(ra) # 122a <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00001097          	auipc	ra,0x1
     654:	86a080e7          	jalr	-1942(ra) # eba <exit>
    } else if (what == 21) {
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	fa850513          	addi	a0,a0,-88 # 1600 <loop+0x1ca>
     660:	00001097          	auipc	ra,0x1
     664:	8aa080e7          	jalr	-1878(ra) # f0a <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE | O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	f9450513          	addi	a0,a0,-108 # 1600 <loop+0x1ca>
     674:	00001097          	auipc	ra,0x1
     678:	886080e7          	jalr	-1914(ra) # efa <open>
     67c:	8b2a                	mv	s6,a0
      if (fd1 < 0) {
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if (write(fd1, "x", 1) != 1) {
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	f2c58593          	addi	a1,a1,-212 # 15b0 <loop+0x17a>
     68c:	00001097          	auipc	ra,0x1
     690:	84e080e7          	jalr	-1970(ra) # eda <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if (fstat(fd1, &st) != 0) {
     69a:	fa840593          	addi	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00001097          	auipc	ra,0x1
     6a4:	872080e7          	jalr	-1934(ra) # f12 <fstat>
     6a8:	e525                	bnez	a0,710 <go+0x698>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if (st.size != 1) {
     6aa:	fb843583          	ld	a1,-72(s0)
     6ae:	4785                	li	a5,1
     6b0:	06f59d63          	bne	a1,a5,72a <go+0x6b2>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if (st.ino > 200) {
     6b4:	fac42583          	lw	a1,-84(s0)
     6b8:	0c800793          	li	a5,200
     6bc:	08b7e563          	bltu	a5,a1,746 <go+0x6ce>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6c0:	855a                	mv	a0,s6
     6c2:	00001097          	auipc	ra,0x1
     6c6:	820080e7          	jalr	-2016(ra) # ee2 <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	f3650513          	addi	a0,a0,-202 # 1600 <loop+0x1ca>
     6d2:	00001097          	auipc	ra,0x1
     6d6:	838080e7          	jalr	-1992(ra) # f0a <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	f2c50513          	addi	a0,a0,-212 # 1608 <loop+0x1d2>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	b46080e7          	jalr	-1210(ra) # 122a <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	7cc080e7          	jalr	1996(ra) # eba <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	f2a50513          	addi	a0,a0,-214 # 1620 <loop+0x1ea>
     6fe:	00001097          	auipc	ra,0x1
     702:	b2c080e7          	jalr	-1236(ra) # 122a <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00000097          	auipc	ra,0x0
     70c:	7b2080e7          	jalr	1970(ra) # eba <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	f2850513          	addi	a0,a0,-216 # 1638 <loop+0x202>
     718:	00001097          	auipc	ra,0x1
     71c:	b12080e7          	jalr	-1262(ra) # 122a <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00000097          	auipc	ra,0x0
     726:	798080e7          	jalr	1944(ra) # eba <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	f2450513          	addi	a0,a0,-220 # 1650 <loop+0x21a>
     734:	00001097          	auipc	ra,0x1
     738:	af6080e7          	jalr	-1290(ra) # 122a <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00000097          	auipc	ra,0x0
     742:	77c080e7          	jalr	1916(ra) # eba <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	f3250513          	addi	a0,a0,-206 # 1678 <loop+0x242>
     74e:	00001097          	auipc	ra,0x1
     752:	adc080e7          	jalr	-1316(ra) # 122a <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	762080e7          	jalr	1890(ra) # eba <exit>
    } else if (what == 22) {
      // echo hi | cat
      int aa[2], bb[2];
      if (pipe(aa) < 0) {
     760:	f9840513          	addi	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	766080e7          	jalr	1894(ra) # eca <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if (pipe(bb) < 0) {
     770:	fa040513          	addi	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	756080e7          	jalr	1878(ra) # eca <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	732080e7          	jalr	1842(ra) # eb2 <fork>
      if (pid1 == 0) {
     788:	10050e63          	beqz	a0,8a4 <go+0x82c>
        close(aa[1]);
        char *args[3] = {"echo", "hi", 0};
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if (pid1 < 0) {
     78c:	1c054663          	bltz	a0,958 <go+0x8e0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     790:	00000097          	auipc	ra,0x0
     794:	722080e7          	jalr	1826(ra) # eb2 <fork>
      if (pid2 == 0) {
     798:	1c050e63          	beqz	a0,974 <go+0x8fc>
        close(bb[1]);
        char *args[2] = {"cat", 0};
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if (pid2 < 0) {
     79c:	2a054a63          	bltz	a0,a50 <go+0x9d8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     7a0:	f9842503          	lw	a0,-104(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	73e080e7          	jalr	1854(ra) # ee2 <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	732080e7          	jalr	1842(ra) # ee2 <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	726080e7          	jalr	1830(ra) # ee2 <close>
      char buf[4] = {0, 0, 0, 0};
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf + 0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	addi	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	700080e7          	jalr	1792(ra) # ed2 <read>
      read(bb[0], buf + 1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	addi	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	6ee080e7          	jalr	1774(ra) # ed2 <read>
      read(bb[0], buf + 2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	addi	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	6dc080e7          	jalr	1756(ra) # ed2 <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	6e0080e7          	jalr	1760(ra) # ee2 <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	addi	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	6b4080e7          	jalr	1716(ra) # ec2 <wait>
      wait(&st2);
     816:	fa840513          	addi	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	6a8080e7          	jalr	1704(ra) # ec2 <wait>
      if (st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0) {
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	eea58593          	addi	a1,a1,-278 # 1718 <loop+0x2e2>
     836:	f9040513          	addi	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	3b6080e7          	jalr	950(ra) # bf0 <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	addi	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	ece50513          	addi	a0,a0,-306 # 1720 <loop+0x2ea>
     85a:	00001097          	auipc	ra,0x1
     85e:	9d0080e7          	jalr	-1584(ra) # 122a <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	656080e7          	jalr	1622(ra) # eba <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	d2c58593          	addi	a1,a1,-724 # 1598 <loop+0x162>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	986080e7          	jalr	-1658(ra) # 11fc <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	63a080e7          	jalr	1594(ra) # eba <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	d1058593          	addi	a1,a1,-752 # 1598 <loop+0x162>
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	96a080e7          	jalr	-1686(ra) # 11fc <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	61e080e7          	jalr	1566(ra) # eba <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	63a080e7          	jalr	1594(ra) # ee2 <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	62e080e7          	jalr	1582(ra) # ee2 <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	622080e7          	jalr	1570(ra) # ee2 <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	618080e7          	jalr	1560(ra) # ee2 <close>
        if (dup(aa[1]) != 1) {
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	65c080e7          	jalr	1628(ra) # f32 <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	dbc58593          	addi	a1,a1,-580 # 16a0 <loop+0x26a>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	90e080e7          	jalr	-1778(ra) # 11fc <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	5c2080e7          	jalr	1474(ra) # eba <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	5de080e7          	jalr	1502(ra) # ee2 <close>
        char *args[3] = {"echo", "hi", 0};
     90c:	00001797          	auipc	a5,0x1
     910:	dac78793          	addi	a5,a5,-596 # 16b8 <loop+0x282>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	da878793          	addi	a5,a5,-600 # 16c0 <loop+0x28a>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	addi	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	d9c50513          	addi	a0,a0,-612 # 16c8 <loop+0x292>
     934:	00000097          	auipc	ra,0x0
     938:	5be080e7          	jalr	1470(ra) # ef2 <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	d9c58593          	addi	a1,a1,-612 # 16d8 <loop+0x2a2>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	8b6080e7          	jalr	-1866(ra) # 11fc <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	56a080e7          	jalr	1386(ra) # eba <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	bf858593          	addi	a1,a1,-1032 # 1550 <loop+0x11a>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	89a080e7          	jalr	-1894(ra) # 11fc <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	54e080e7          	jalr	1358(ra) # eba <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	56a080e7          	jalr	1386(ra) # ee2 <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	55e080e7          	jalr	1374(ra) # ee2 <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	554080e7          	jalr	1364(ra) # ee2 <close>
        if (dup(aa[0]) != 0) {
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	598080e7          	jalr	1432(ra) # f32 <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	cfc58593          	addi	a1,a1,-772 # 16a0 <loop+0x26a>
     9ac:	4509                	li	a0,2
     9ae:	00001097          	auipc	ra,0x1
     9b2:	84e080e7          	jalr	-1970(ra) # 11fc <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	502080e7          	jalr	1282(ra) # eba <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	51e080e7          	jalr	1310(ra) # ee2 <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	514080e7          	jalr	1300(ra) # ee2 <close>
        if (dup(bb[1]) != 1) {
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	558080e7          	jalr	1368(ra) # f32 <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	cb858593          	addi	a1,a1,-840 # 16a0 <loop+0x26a>
     9f0:	4509                	li	a0,2
     9f2:	00001097          	auipc	ra,0x1
     9f6:	80a080e7          	jalr	-2038(ra) # 11fc <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	4be080e7          	jalr	1214(ra) # eba <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	4da080e7          	jalr	1242(ra) # ee2 <close>
        char *args[2] = {"cat", 0};
     a10:	00001797          	auipc	a5,0x1
     a14:	ce078793          	addi	a5,a5,-800 # 16f0 <loop+0x2ba>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	addi	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	cd450513          	addi	a0,a0,-812 # 16f8 <loop+0x2c2>
     a2c:	00000097          	auipc	ra,0x0
     a30:	4c6080e7          	jalr	1222(ra) # ef2 <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	ccc58593          	addi	a1,a1,-820 # 1700 <loop+0x2ca>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	7be080e7          	jalr	1982(ra) # 11fc <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	472080e7          	jalr	1138(ra) # eba <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	b0058593          	addi	a1,a1,-1280 # 1550 <loop+0x11a>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	7a2080e7          	jalr	1954(ra) # 11fc <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	456080e7          	jalr	1110(ra) # eba <exit>

0000000000000a6c <iter>:
      }
    }
  }
}

void iter() {
     a6c:	7179                	addi	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	1800                	addi	s0,sp,48
  unlink("a");
     a74:	00001517          	auipc	a0,0x1
     a78:	af450513          	addi	a0,a0,-1292 # 1568 <loop+0x132>
     a7c:	00000097          	auipc	ra,0x0
     a80:	48e080e7          	jalr	1166(ra) # f0a <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	a9450513          	addi	a0,a0,-1388 # 1518 <loop+0xe2>
     a8c:	00000097          	auipc	ra,0x0
     a90:	47e080e7          	jalr	1150(ra) # f0a <unlink>

  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	41e080e7          	jalr	1054(ra) # eb2 <fork>
  if (pid1 < 0) {
     a9c:	02054363          	bltz	a0,ac2 <iter+0x56>
     aa0:	ec26                	sd	s1,24(sp)
     aa2:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid1 == 0) {
     aa4:	ed15                	bnez	a0,ae0 <iter+0x74>
     aa6:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     aa8:	00001717          	auipc	a4,0x1
     aac:	55870713          	addi	a4,a4,1368 # 2000 <rand_next>
     ab0:	631c                	ld	a5,0(a4)
     ab2:	01f7c793          	xori	a5,a5,31
     ab6:	e31c                	sd	a5,0(a4)
    go(0);
     ab8:	4501                	li	a0,0
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5be080e7          	jalr	1470(ra) # 78 <go>
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     ac6:	00001517          	auipc	a0,0x1
     aca:	a8a50513          	addi	a0,a0,-1398 # 1550 <loop+0x11a>
     ace:	00000097          	auipc	ra,0x0
     ad2:	75c080e7          	jalr	1884(ra) # 122a <printf>
    exit(1);
     ad6:	4505                	li	a0,1
     ad8:	00000097          	auipc	ra,0x0
     adc:	3e2080e7          	jalr	994(ra) # eba <exit>
     ae0:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     ae2:	00000097          	auipc	ra,0x0
     ae6:	3d0080e7          	jalr	976(ra) # eb2 <fork>
     aea:	892a                	mv	s2,a0
  if (pid2 < 0) {
     aec:	02054263          	bltz	a0,b10 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid2 == 0) {
     af0:	ed0d                	bnez	a0,b2a <iter+0xbe>
    rand_next ^= 7177;
     af2:	00001697          	auipc	a3,0x1
     af6:	50e68693          	addi	a3,a3,1294 # 2000 <rand_next>
     afa:	629c                	ld	a5,0(a3)
     afc:	6709                	lui	a4,0x2
     afe:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x401>
     b02:	8fb9                	xor	a5,a5,a4
     b04:	e29c                	sd	a5,0(a3)
    go(1);
     b06:	4505                	li	a0,1
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	a4050513          	addi	a0,a0,-1472 # 1550 <loop+0x11a>
     b18:	00000097          	auipc	ra,0x0
     b1c:	712080e7          	jalr	1810(ra) # 122a <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	398080e7          	jalr	920(ra) # eba <exit>
    exit(0);
  }

  int st1 = -1;
     b2a:	57fd                	li	a5,-1
     b2c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b30:	fdc40513          	addi	a0,s0,-36
     b34:	00000097          	auipc	ra,0x0
     b38:	38e080e7          	jalr	910(ra) # ec2 <wait>
  if (st1 != 0) {
     b3c:	fdc42783          	lw	a5,-36(s0)
     b40:	ef99                	bnez	a5,b5e <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b42:	57fd                	li	a5,-1
     b44:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b48:	fd840513          	addi	a0,s0,-40
     b4c:	00000097          	auipc	ra,0x0
     b50:	376080e7          	jalr	886(ra) # ec2 <wait>

  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	364080e7          	jalr	868(ra) # eba <exit>
    kill(pid1);
     b5e:	8526                	mv	a0,s1
     b60:	00000097          	auipc	ra,0x0
     b64:	38a080e7          	jalr	906(ra) # eea <kill>
    kill(pid2);
     b68:	854a                	mv	a0,s2
     b6a:	00000097          	auipc	ra,0x0
     b6e:	380080e7          	jalr	896(ra) # eea <kill>
     b72:	bfc1                	j	b42 <iter+0xd6>

0000000000000b74 <main>:
}

int main() {
     b74:	1101                	addi	sp,sp,-32
     b76:	ec06                	sd	ra,24(sp)
     b78:	e822                	sd	s0,16(sp)
     b7a:	e426                	sd	s1,8(sp)
     b7c:	1000                	addi	s0,sp,32
    }
    if (pid > 0) {
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b7e:	00001497          	auipc	s1,0x1
     b82:	48248493          	addi	s1,s1,1154 # 2000 <rand_next>
     b86:	a829                	j	ba0 <main+0x2c>
      iter();
     b88:	00000097          	auipc	ra,0x0
     b8c:	ee4080e7          	jalr	-284(ra) # a6c <iter>
    sleep(20);
     b90:	4551                	li	a0,20
     b92:	00000097          	auipc	ra,0x0
     b96:	3b8080e7          	jalr	952(ra) # f4a <sleep>
    rand_next += 1;
     b9a:	609c                	ld	a5,0(s1)
     b9c:	0785                	addi	a5,a5,1
     b9e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     ba0:	00000097          	auipc	ra,0x0
     ba4:	312080e7          	jalr	786(ra) # eb2 <fork>
    if (pid == 0) {
     ba8:	d165                	beqz	a0,b88 <main+0x14>
    if (pid > 0) {
     baa:	fea053e3          	blez	a0,b90 <main+0x1c>
      wait(0);
     bae:	4501                	li	a0,0
     bb0:	00000097          	auipc	ra,0x0
     bb4:	312080e7          	jalr	786(ra) # ec2 <wait>
     bb8:	bfe1                	j	b90 <main+0x1c>

0000000000000bba <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
     bba:	1141                	addi	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bc2:	00000097          	auipc	ra,0x0
     bc6:	fb2080e7          	jalr	-78(ra) # b74 <main>
  exit(0);
     bca:	4501                	li	a0,0
     bcc:	00000097          	auipc	ra,0x0
     bd0:	2ee080e7          	jalr	750(ra) # eba <exit>

0000000000000bd4 <strcpy>:
}

char *strcpy(char *s, const char *t) {
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
     bda:	87aa                	mv	a5,a0
     bdc:	0585                	addi	a1,a1,1
     bde:	0785                	addi	a5,a5,1
     be0:	fff5c703          	lbu	a4,-1(a1)
     be4:	fee78fa3          	sb	a4,-1(a5)
     be8:	fb75                	bnez	a4,bdc <strcpy+0x8>
  return os;
}
     bea:	6422                	ld	s0,8(sp)
     bec:	0141                	addi	sp,sp,16
     bee:	8082                	ret

0000000000000bf0 <strcmp>:

int strcmp(const char *p, const char *q) {
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	cb91                	beqz	a5,c0e <strcmp+0x1e>
     bfc:	0005c703          	lbu	a4,0(a1)
     c00:	00f71763          	bne	a4,a5,c0e <strcmp+0x1e>
     c04:	0505                	addi	a0,a0,1
     c06:	0585                	addi	a1,a1,1
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	fbe5                	bnez	a5,bfc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c0e:	0005c503          	lbu	a0,0(a1)
}
     c12:	40a7853b          	subw	a0,a5,a0
     c16:	6422                	ld	s0,8(sp)
     c18:	0141                	addi	sp,sp,16
     c1a:	8082                	ret

0000000000000c1c <strlen>:

uint strlen(const char *s) {
     c1c:	1141                	addi	sp,sp,-16
     c1e:	e422                	sd	s0,8(sp)
     c20:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
     c22:	00054783          	lbu	a5,0(a0)
     c26:	cf91                	beqz	a5,c42 <strlen+0x26>
     c28:	0505                	addi	a0,a0,1
     c2a:	87aa                	mv	a5,a0
     c2c:	86be                	mv	a3,a5
     c2e:	0785                	addi	a5,a5,1
     c30:	fff7c703          	lbu	a4,-1(a5)
     c34:	ff65                	bnez	a4,c2c <strlen+0x10>
     c36:	40a6853b          	subw	a0,a3,a0
     c3a:	2505                	addiw	a0,a0,1
  return n;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	addi	sp,sp,16
     c40:	8082                	ret
  for (n = 0; s[n]; n++);
     c42:	4501                	li	a0,0
     c44:	bfe5                	j	c3c <strlen+0x20>

0000000000000c46 <memset>:

void *memset(void *dst, int c, uint n) {
     c46:	1141                	addi	sp,sp,-16
     c48:	e422                	sd	s0,8(sp)
     c4a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     c4c:	ca19                	beqz	a2,c62 <memset+0x1c>
     c4e:	87aa                	mv	a5,a0
     c50:	1602                	slli	a2,a2,0x20
     c52:	9201                	srli	a2,a2,0x20
     c54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c58:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     c5c:	0785                	addi	a5,a5,1
     c5e:	fee79de3          	bne	a5,a4,c58 <memset+0x12>
  }
  return dst;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	addi	sp,sp,16
     c66:	8082                	ret

0000000000000c68 <strchr>:

char *strchr(const char *s, char c) {
     c68:	1141                	addi	sp,sp,-16
     c6a:	e422                	sd	s0,8(sp)
     c6c:	0800                	addi	s0,sp,16
  for (; *s; s++)
     c6e:	00054783          	lbu	a5,0(a0)
     c72:	cb99                	beqz	a5,c88 <strchr+0x20>
    if (*s == c) return (char *)s;
     c74:	00f58763          	beq	a1,a5,c82 <strchr+0x1a>
  for (; *s; s++)
     c78:	0505                	addi	a0,a0,1
     c7a:	00054783          	lbu	a5,0(a0)
     c7e:	fbfd                	bnez	a5,c74 <strchr+0xc>
  return 0;
     c80:	4501                	li	a0,0
}
     c82:	6422                	ld	s0,8(sp)
     c84:	0141                	addi	sp,sp,16
     c86:	8082                	ret
  return 0;
     c88:	4501                	li	a0,0
     c8a:	bfe5                	j	c82 <strchr+0x1a>

0000000000000c8c <gets>:

char *gets(char *buf, int max) {
     c8c:	711d                	addi	sp,sp,-96
     c8e:	ec86                	sd	ra,88(sp)
     c90:	e8a2                	sd	s0,80(sp)
     c92:	e4a6                	sd	s1,72(sp)
     c94:	e0ca                	sd	s2,64(sp)
     c96:	fc4e                	sd	s3,56(sp)
     c98:	f852                	sd	s4,48(sp)
     c9a:	f456                	sd	s5,40(sp)
     c9c:	f05a                	sd	s6,32(sp)
     c9e:	ec5e                	sd	s7,24(sp)
     ca0:	1080                	addi	s0,sp,96
     ca2:	8baa                	mv	s7,a0
     ca4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     ca6:	892a                	mv	s2,a0
     ca8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
     caa:	4aa9                	li	s5,10
     cac:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
     cae:	89a6                	mv	s3,s1
     cb0:	2485                	addiw	s1,s1,1
     cb2:	0344d863          	bge	s1,s4,ce2 <gets+0x56>
    cc = read(0, &c, 1);
     cb6:	4605                	li	a2,1
     cb8:	faf40593          	addi	a1,s0,-81
     cbc:	4501                	li	a0,0
     cbe:	00000097          	auipc	ra,0x0
     cc2:	214080e7          	jalr	532(ra) # ed2 <read>
    if (cc < 1) break;
     cc6:	00a05e63          	blez	a0,ce2 <gets+0x56>
    buf[i++] = c;
     cca:	faf44783          	lbu	a5,-81(s0)
     cce:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
     cd2:	01578763          	beq	a5,s5,ce0 <gets+0x54>
     cd6:	0905                	addi	s2,s2,1
     cd8:	fd679be3          	bne	a5,s6,cae <gets+0x22>
    buf[i++] = c;
     cdc:	89a6                	mv	s3,s1
     cde:	a011                	j	ce2 <gets+0x56>
     ce0:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
     ce2:	99de                	add	s3,s3,s7
     ce4:	00098023          	sb	zero,0(s3)
  return buf;
}
     ce8:	855e                	mv	a0,s7
     cea:	60e6                	ld	ra,88(sp)
     cec:	6446                	ld	s0,80(sp)
     cee:	64a6                	ld	s1,72(sp)
     cf0:	6906                	ld	s2,64(sp)
     cf2:	79e2                	ld	s3,56(sp)
     cf4:	7a42                	ld	s4,48(sp)
     cf6:	7aa2                	ld	s5,40(sp)
     cf8:	7b02                	ld	s6,32(sp)
     cfa:	6be2                	ld	s7,24(sp)
     cfc:	6125                	addi	sp,sp,96
     cfe:	8082                	ret

0000000000000d00 <stat>:

int stat(const char *n, struct stat *st) {
     d00:	1101                	addi	sp,sp,-32
     d02:	ec06                	sd	ra,24(sp)
     d04:	e822                	sd	s0,16(sp)
     d06:	e04a                	sd	s2,0(sp)
     d08:	1000                	addi	s0,sp,32
     d0a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d0c:	4581                	li	a1,0
     d0e:	00000097          	auipc	ra,0x0
     d12:	1ec080e7          	jalr	492(ra) # efa <open>
  if (fd < 0) return -1;
     d16:	02054663          	bltz	a0,d42 <stat+0x42>
     d1a:	e426                	sd	s1,8(sp)
     d1c:	84aa                	mv	s1,a0
  r = fstat(fd, st);
     d1e:	85ca                	mv	a1,s2
     d20:	00000097          	auipc	ra,0x0
     d24:	1f2080e7          	jalr	498(ra) # f12 <fstat>
     d28:	892a                	mv	s2,a0
  close(fd);
     d2a:	8526                	mv	a0,s1
     d2c:	00000097          	auipc	ra,0x0
     d30:	1b6080e7          	jalr	438(ra) # ee2 <close>
  return r;
     d34:	64a2                	ld	s1,8(sp)
}
     d36:	854a                	mv	a0,s2
     d38:	60e2                	ld	ra,24(sp)
     d3a:	6442                	ld	s0,16(sp)
     d3c:	6902                	ld	s2,0(sp)
     d3e:	6105                	addi	sp,sp,32
     d40:	8082                	ret
  if (fd < 0) return -1;
     d42:	597d                	li	s2,-1
     d44:	bfcd                	j	d36 <stat+0x36>

0000000000000d46 <atoi>:

int atoi(const char *s) {
     d46:	1141                	addi	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
     d4c:	00054683          	lbu	a3,0(a0)
     d50:	fd06879b          	addiw	a5,a3,-48
     d54:	0ff7f793          	zext.b	a5,a5
     d58:	4625                	li	a2,9
     d5a:	02f66863          	bltu	a2,a5,d8a <atoi+0x44>
     d5e:	872a                	mv	a4,a0
  n = 0;
     d60:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
     d62:	0705                	addi	a4,a4,1
     d64:	0025179b          	slliw	a5,a0,0x2
     d68:	9fa9                	addw	a5,a5,a0
     d6a:	0017979b          	slliw	a5,a5,0x1
     d6e:	9fb5                	addw	a5,a5,a3
     d70:	fd07851b          	addiw	a0,a5,-48
     d74:	00074683          	lbu	a3,0(a4)
     d78:	fd06879b          	addiw	a5,a3,-48
     d7c:	0ff7f793          	zext.b	a5,a5
     d80:	fef671e3          	bgeu	a2,a5,d62 <atoi+0x1c>
  return n;
}
     d84:	6422                	ld	s0,8(sp)
     d86:	0141                	addi	sp,sp,16
     d88:	8082                	ret
  n = 0;
     d8a:	4501                	li	a0,0
     d8c:	bfe5                	j	d84 <atoi+0x3e>

0000000000000d8e <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
     d8e:	1141                	addi	sp,sp,-16
     d90:	e422                	sd	s0,8(sp)
     d92:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d94:	02b57463          	bgeu	a0,a1,dbc <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
     d98:	00c05f63          	blez	a2,db6 <memmove+0x28>
     d9c:	1602                	slli	a2,a2,0x20
     d9e:	9201                	srli	a2,a2,0x20
     da0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     da4:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
     da6:	0585                	addi	a1,a1,1
     da8:	0705                	addi	a4,a4,1
     daa:	fff5c683          	lbu	a3,-1(a1)
     dae:	fed70fa3          	sb	a3,-1(a4)
     db2:	fef71ae3          	bne	a4,a5,da6 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
     db6:	6422                	ld	s0,8(sp)
     db8:	0141                	addi	sp,sp,16
     dba:	8082                	ret
    dst += n;
     dbc:	00c50733          	add	a4,a0,a2
    src += n;
     dc0:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
     dc2:	fec05ae3          	blez	a2,db6 <memmove+0x28>
     dc6:	fff6079b          	addiw	a5,a2,-1
     dca:	1782                	slli	a5,a5,0x20
     dcc:	9381                	srli	a5,a5,0x20
     dce:	fff7c793          	not	a5,a5
     dd2:	97ba                	add	a5,a5,a4
     dd4:	15fd                	addi	a1,a1,-1
     dd6:	177d                	addi	a4,a4,-1
     dd8:	0005c683          	lbu	a3,0(a1)
     ddc:	00d70023          	sb	a3,0(a4)
     de0:	fee79ae3          	bne	a5,a4,dd4 <memmove+0x46>
     de4:	bfc9                	j	db6 <memmove+0x28>

0000000000000de6 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
     de6:	1141                	addi	sp,sp,-16
     de8:	e422                	sd	s0,8(sp)
     dea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dec:	ca05                	beqz	a2,e1c <memcmp+0x36>
     dee:	fff6069b          	addiw	a3,a2,-1
     df2:	1682                	slli	a3,a3,0x20
     df4:	9281                	srli	a3,a3,0x20
     df6:	0685                	addi	a3,a3,1
     df8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dfa:	00054783          	lbu	a5,0(a0)
     dfe:	0005c703          	lbu	a4,0(a1)
     e02:	00e79863          	bne	a5,a4,e12 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e06:	0505                	addi	a0,a0,1
    p2++;
     e08:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e0a:	fed518e3          	bne	a0,a3,dfa <memcmp+0x14>
  }
  return 0;
     e0e:	4501                	li	a0,0
     e10:	a019                	j	e16 <memcmp+0x30>
      return *p1 - *p2;
     e12:	40e7853b          	subw	a0,a5,a4
}
     e16:	6422                	ld	s0,8(sp)
     e18:	0141                	addi	sp,sp,16
     e1a:	8082                	ret
  return 0;
     e1c:	4501                	li	a0,0
     e1e:	bfe5                	j	e16 <memcmp+0x30>

0000000000000e20 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
     e20:	1141                	addi	sp,sp,-16
     e22:	e406                	sd	ra,8(sp)
     e24:	e022                	sd	s0,0(sp)
     e26:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e28:	00000097          	auipc	ra,0x0
     e2c:	f66080e7          	jalr	-154(ra) # d8e <memmove>
}
     e30:	60a2                	ld	ra,8(sp)
     e32:	6402                	ld	s0,0(sp)
     e34:	0141                	addi	sp,sp,16
     e36:	8082                	ret

0000000000000e38 <strcat>:

char *strcat(char *dst, const char *src) {
     e38:	1141                	addi	sp,sp,-16
     e3a:	e422                	sd	s0,8(sp)
     e3c:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
     e3e:	00054783          	lbu	a5,0(a0)
     e42:	c385                	beqz	a5,e62 <strcat+0x2a>
  char *p = dst;
     e44:	87aa                	mv	a5,a0
  while (*p) p++;
     e46:	0785                	addi	a5,a5,1
     e48:	0007c703          	lbu	a4,0(a5)
     e4c:	ff6d                	bnez	a4,e46 <strcat+0xe>
  while ((*p++ = *src++));
     e4e:	0585                	addi	a1,a1,1
     e50:	0785                	addi	a5,a5,1
     e52:	fff5c703          	lbu	a4,-1(a1)
     e56:	fee78fa3          	sb	a4,-1(a5)
     e5a:	fb75                	bnez	a4,e4e <strcat+0x16>
  return dst;
}
     e5c:	6422                	ld	s0,8(sp)
     e5e:	0141                	addi	sp,sp,16
     e60:	8082                	ret
  char *p = dst;
     e62:	87aa                	mv	a5,a0
     e64:	b7ed                	j	e4e <strcat+0x16>

0000000000000e66 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
     e66:	1141                	addi	sp,sp,-16
     e68:	e422                	sd	s0,8(sp)
     e6a:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
     e6c:	0005c783          	lbu	a5,0(a1)
     e70:	cf95                	beqz	a5,eac <strstr+0x46>

  for (; *haystack; haystack++) {
     e72:	00054783          	lbu	a5,0(a0)
     e76:	eb91                	bnez	a5,e8a <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
     e78:	4501                	li	a0,0
     e7a:	a80d                	j	eac <strstr+0x46>
    if (!*n) return (char *)haystack;
     e7c:	0007c783          	lbu	a5,0(a5)
     e80:	c795                	beqz	a5,eac <strstr+0x46>
  for (; *haystack; haystack++) {
     e82:	0505                	addi	a0,a0,1
     e84:	00054783          	lbu	a5,0(a0)
     e88:	c38d                	beqz	a5,eaa <strstr+0x44>
    while (*h && *n && (*h == *n)) {
     e8a:	00054703          	lbu	a4,0(a0)
    n = needle;
     e8e:	87ae                	mv	a5,a1
    h = haystack;
     e90:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
     e92:	db65                	beqz	a4,e82 <strstr+0x1c>
     e94:	0007c683          	lbu	a3,0(a5)
     e98:	ca91                	beqz	a3,eac <strstr+0x46>
     e9a:	fee691e3          	bne	a3,a4,e7c <strstr+0x16>
      h++;
     e9e:	0605                	addi	a2,a2,1
      n++;
     ea0:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
     ea2:	00064703          	lbu	a4,0(a2)
     ea6:	f77d                	bnez	a4,e94 <strstr+0x2e>
     ea8:	bfd1                	j	e7c <strstr+0x16>
  return 0;
     eaa:	4501                	li	a0,0
}
     eac:	6422                	ld	s0,8(sp)
     eae:	0141                	addi	sp,sp,16
     eb0:	8082                	ret

0000000000000eb2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     eb2:	4885                	li	a7,1
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <exit>:
.global exit
exit:
 li a7, SYS_exit
     eba:	4889                	li	a7,2
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ec2:	488d                	li	a7,3
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     eca:	4891                	li	a7,4
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <read>:
.global read
read:
 li a7, SYS_read
     ed2:	4895                	li	a7,5
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <write>:
.global write
write:
 li a7, SYS_write
     eda:	48c1                	li	a7,16
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <close>:
.global close
close:
 li a7, SYS_close
     ee2:	48d5                	li	a7,21
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <kill>:
.global kill
kill:
 li a7, SYS_kill
     eea:	4899                	li	a7,6
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ef2:	489d                	li	a7,7
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <open>:
.global open
open:
 li a7, SYS_open
     efa:	48bd                	li	a7,15
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f02:	48c5                	li	a7,17
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f0a:	48c9                	li	a7,18
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f12:	48a1                	li	a7,8
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <link>:
.global link
link:
 li a7, SYS_link
     f1a:	48cd                	li	a7,19
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f22:	48d1                	li	a7,20
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f2a:	48a5                	li	a7,9
 ecall
     f2c:	00000073          	ecall
 ret
     f30:	8082                	ret

0000000000000f32 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f32:	48a9                	li	a7,10
 ecall
     f34:	00000073          	ecall
 ret
     f38:	8082                	ret

0000000000000f3a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f3a:	48ad                	li	a7,11
 ecall
     f3c:	00000073          	ecall
 ret
     f40:	8082                	ret

0000000000000f42 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f42:	48b1                	li	a7,12
 ecall
     f44:	00000073          	ecall
 ret
     f48:	8082                	ret

0000000000000f4a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f4a:	48b5                	li	a7,13
 ecall
     f4c:	00000073          	ecall
 ret
     f50:	8082                	ret

0000000000000f52 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f52:	48b9                	li	a7,14
 ecall
     f54:	00000073          	ecall
 ret
     f58:	8082                	ret

0000000000000f5a <reg>:
.global reg
reg:
 li a7, SYS_reg
     f5a:	48d9                	li	a7,22
 ecall
     f5c:	00000073          	ecall
 ret
     f60:	8082                	ret

0000000000000f62 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
     f62:	1101                	addi	sp,sp,-32
     f64:	ec06                	sd	ra,24(sp)
     f66:	e822                	sd	s0,16(sp)
     f68:	1000                	addi	s0,sp,32
     f6a:	feb407a3          	sb	a1,-17(s0)
     f6e:	4605                	li	a2,1
     f70:	fef40593          	addi	a1,s0,-17
     f74:	00000097          	auipc	ra,0x0
     f78:	f66080e7          	jalr	-154(ra) # eda <write>
     f7c:	60e2                	ld	ra,24(sp)
     f7e:	6442                	ld	s0,16(sp)
     f80:	6105                	addi	sp,sp,32
     f82:	8082                	ret

0000000000000f84 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
     f84:	7139                	addi	sp,sp,-64
     f86:	fc06                	sd	ra,56(sp)
     f88:	f822                	sd	s0,48(sp)
     f8a:	f426                	sd	s1,40(sp)
     f8c:	0080                	addi	s0,sp,64
     f8e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
     f90:	c299                	beqz	a3,f96 <printint+0x12>
     f92:	0805cb63          	bltz	a1,1028 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f96:	2581                	sext.w	a1,a1
  neg = 0;
     f98:	4881                	li	a7,0
     f9a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f9e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
     fa0:	2601                	sext.w	a2,a2
     fa2:	00001517          	auipc	a0,0x1
     fa6:	86650513          	addi	a0,a0,-1946 # 1808 <digits>
     faa:	883a                	mv	a6,a4
     fac:	2705                	addiw	a4,a4,1
     fae:	02c5f7bb          	remuw	a5,a1,a2
     fb2:	1782                	slli	a5,a5,0x20
     fb4:	9381                	srli	a5,a5,0x20
     fb6:	97aa                	add	a5,a5,a0
     fb8:	0007c783          	lbu	a5,0(a5)
     fbc:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
     fc0:	0005879b          	sext.w	a5,a1
     fc4:	02c5d5bb          	divuw	a1,a1,a2
     fc8:	0685                	addi	a3,a3,1
     fca:	fec7f0e3          	bgeu	a5,a2,faa <printint+0x26>
  if (neg) buf[i++] = '-';
     fce:	00088c63          	beqz	a7,fe6 <printint+0x62>
     fd2:	fd070793          	addi	a5,a4,-48
     fd6:	00878733          	add	a4,a5,s0
     fda:	02d00793          	li	a5,45
     fde:	fef70823          	sb	a5,-16(a4)
     fe2:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
     fe6:	02e05c63          	blez	a4,101e <printint+0x9a>
     fea:	f04a                	sd	s2,32(sp)
     fec:	ec4e                	sd	s3,24(sp)
     fee:	fc040793          	addi	a5,s0,-64
     ff2:	00e78933          	add	s2,a5,a4
     ff6:	fff78993          	addi	s3,a5,-1
     ffa:	99ba                	add	s3,s3,a4
     ffc:	377d                	addiw	a4,a4,-1
     ffe:	1702                	slli	a4,a4,0x20
    1000:	9301                	srli	a4,a4,0x20
    1002:	40e989b3          	sub	s3,s3,a4
    1006:	fff94583          	lbu	a1,-1(s2)
    100a:	8526                	mv	a0,s1
    100c:	00000097          	auipc	ra,0x0
    1010:	f56080e7          	jalr	-170(ra) # f62 <putc>
    1014:	197d                	addi	s2,s2,-1
    1016:	ff3918e3          	bne	s2,s3,1006 <printint+0x82>
    101a:	7902                	ld	s2,32(sp)
    101c:	69e2                	ld	s3,24(sp)
}
    101e:	70e2                	ld	ra,56(sp)
    1020:	7442                	ld	s0,48(sp)
    1022:	74a2                	ld	s1,40(sp)
    1024:	6121                	addi	sp,sp,64
    1026:	8082                	ret
    x = -xx;
    1028:	40b005bb          	negw	a1,a1
    neg = 1;
    102c:	4885                	li	a7,1
    x = -xx;
    102e:	b7b5                	j	f9a <printint+0x16>

0000000000001030 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
    1030:	715d                	addi	sp,sp,-80
    1032:	e486                	sd	ra,72(sp)
    1034:	e0a2                	sd	s0,64(sp)
    1036:	f84a                	sd	s2,48(sp)
    1038:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    103a:	0005c903          	lbu	s2,0(a1)
    103e:	1a090a63          	beqz	s2,11f2 <vprintf+0x1c2>
    1042:	fc26                	sd	s1,56(sp)
    1044:	f44e                	sd	s3,40(sp)
    1046:	f052                	sd	s4,32(sp)
    1048:	ec56                	sd	s5,24(sp)
    104a:	e85a                	sd	s6,16(sp)
    104c:	e45e                	sd	s7,8(sp)
    104e:	8aaa                	mv	s5,a0
    1050:	8bb2                	mv	s7,a2
    1052:	00158493          	addi	s1,a1,1
  state = 0;
    1056:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
    1058:	02500a13          	li	s4,37
    105c:	4b55                	li	s6,21
    105e:	a839                	j	107c <vprintf+0x4c>
        putc(fd, c);
    1060:	85ca                	mv	a1,s2
    1062:	8556                	mv	a0,s5
    1064:	00000097          	auipc	ra,0x0
    1068:	efe080e7          	jalr	-258(ra) # f62 <putc>
    106c:	a019                	j	1072 <vprintf+0x42>
    } else if (state == '%') {
    106e:	01498d63          	beq	s3,s4,1088 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
    1072:	0485                	addi	s1,s1,1
    1074:	fff4c903          	lbu	s2,-1(s1)
    1078:	16090763          	beqz	s2,11e6 <vprintf+0x1b6>
    if (state == 0) {
    107c:	fe0999e3          	bnez	s3,106e <vprintf+0x3e>
      if (c == '%') {
    1080:	ff4910e3          	bne	s2,s4,1060 <vprintf+0x30>
        state = '%';
    1084:	89d2                	mv	s3,s4
    1086:	b7f5                	j	1072 <vprintf+0x42>
      if (c == 'd') {
    1088:	13490463          	beq	s2,s4,11b0 <vprintf+0x180>
    108c:	f9d9079b          	addiw	a5,s2,-99
    1090:	0ff7f793          	zext.b	a5,a5
    1094:	12fb6763          	bltu	s6,a5,11c2 <vprintf+0x192>
    1098:	f9d9079b          	addiw	a5,s2,-99
    109c:	0ff7f713          	zext.b	a4,a5
    10a0:	12eb6163          	bltu	s6,a4,11c2 <vprintf+0x192>
    10a4:	00271793          	slli	a5,a4,0x2
    10a8:	00000717          	auipc	a4,0x0
    10ac:	70870713          	addi	a4,a4,1800 # 17b0 <loop+0x37a>
    10b0:	97ba                	add	a5,a5,a4
    10b2:	439c                	lw	a5,0(a5)
    10b4:	97ba                	add	a5,a5,a4
    10b6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    10b8:	008b8913          	addi	s2,s7,8
    10bc:	4685                	li	a3,1
    10be:	4629                	li	a2,10
    10c0:	000ba583          	lw	a1,0(s7)
    10c4:	8556                	mv	a0,s5
    10c6:	00000097          	auipc	ra,0x0
    10ca:	ebe080e7          	jalr	-322(ra) # f84 <printint>
    10ce:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    10d0:	4981                	li	s3,0
    10d2:	b745                	j	1072 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10d4:	008b8913          	addi	s2,s7,8
    10d8:	4681                	li	a3,0
    10da:	4629                	li	a2,10
    10dc:	000ba583          	lw	a1,0(s7)
    10e0:	8556                	mv	a0,s5
    10e2:	00000097          	auipc	ra,0x0
    10e6:	ea2080e7          	jalr	-350(ra) # f84 <printint>
    10ea:	8bca                	mv	s7,s2
      state = 0;
    10ec:	4981                	li	s3,0
    10ee:	b751                	j	1072 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    10f0:	008b8913          	addi	s2,s7,8
    10f4:	4681                	li	a3,0
    10f6:	4641                	li	a2,16
    10f8:	000ba583          	lw	a1,0(s7)
    10fc:	8556                	mv	a0,s5
    10fe:	00000097          	auipc	ra,0x0
    1102:	e86080e7          	jalr	-378(ra) # f84 <printint>
    1106:	8bca                	mv	s7,s2
      state = 0;
    1108:	4981                	li	s3,0
    110a:	b7a5                	j	1072 <vprintf+0x42>
    110c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    110e:	008b8c13          	addi	s8,s7,8
    1112:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1116:	03000593          	li	a1,48
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	e46080e7          	jalr	-442(ra) # f62 <putc>
  putc(fd, 'x');
    1124:	07800593          	li	a1,120
    1128:	8556                	mv	a0,s5
    112a:	00000097          	auipc	ra,0x0
    112e:	e38080e7          	jalr	-456(ra) # f62 <putc>
    1132:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1134:	00000b97          	auipc	s7,0x0
    1138:	6d4b8b93          	addi	s7,s7,1748 # 1808 <digits>
    113c:	03c9d793          	srli	a5,s3,0x3c
    1140:	97de                	add	a5,a5,s7
    1142:	0007c583          	lbu	a1,0(a5)
    1146:	8556                	mv	a0,s5
    1148:	00000097          	auipc	ra,0x0
    114c:	e1a080e7          	jalr	-486(ra) # f62 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1150:	0992                	slli	s3,s3,0x4
    1152:	397d                	addiw	s2,s2,-1
    1154:	fe0914e3          	bnez	s2,113c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1158:	8be2                	mv	s7,s8
      state = 0;
    115a:	4981                	li	s3,0
    115c:	6c02                	ld	s8,0(sp)
    115e:	bf11                	j	1072 <vprintf+0x42>
        s = va_arg(ap, char *);
    1160:	008b8993          	addi	s3,s7,8
    1164:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
    1168:	02090163          	beqz	s2,118a <vprintf+0x15a>
        while (*s != 0) {
    116c:	00094583          	lbu	a1,0(s2)
    1170:	c9a5                	beqz	a1,11e0 <vprintf+0x1b0>
          putc(fd, *s);
    1172:	8556                	mv	a0,s5
    1174:	00000097          	auipc	ra,0x0
    1178:	dee080e7          	jalr	-530(ra) # f62 <putc>
          s++;
    117c:	0905                	addi	s2,s2,1
        while (*s != 0) {
    117e:	00094583          	lbu	a1,0(s2)
    1182:	f9e5                	bnez	a1,1172 <vprintf+0x142>
        s = va_arg(ap, char *);
    1184:	8bce                	mv	s7,s3
      state = 0;
    1186:	4981                	li	s3,0
    1188:	b5ed                	j	1072 <vprintf+0x42>
        if (s == 0) s = "(null)";
    118a:	00000917          	auipc	s2,0x0
    118e:	5be90913          	addi	s2,s2,1470 # 1748 <loop+0x312>
        while (*s != 0) {
    1192:	02800593          	li	a1,40
    1196:	bff1                	j	1172 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1198:	008b8913          	addi	s2,s7,8
    119c:	000bc583          	lbu	a1,0(s7)
    11a0:	8556                	mv	a0,s5
    11a2:	00000097          	auipc	ra,0x0
    11a6:	dc0080e7          	jalr	-576(ra) # f62 <putc>
    11aa:	8bca                	mv	s7,s2
      state = 0;
    11ac:	4981                	li	s3,0
    11ae:	b5d1                	j	1072 <vprintf+0x42>
        putc(fd, c);
    11b0:	02500593          	li	a1,37
    11b4:	8556                	mv	a0,s5
    11b6:	00000097          	auipc	ra,0x0
    11ba:	dac080e7          	jalr	-596(ra) # f62 <putc>
      state = 0;
    11be:	4981                	li	s3,0
    11c0:	bd4d                	j	1072 <vprintf+0x42>
        putc(fd, '%');
    11c2:	02500593          	li	a1,37
    11c6:	8556                	mv	a0,s5
    11c8:	00000097          	auipc	ra,0x0
    11cc:	d9a080e7          	jalr	-614(ra) # f62 <putc>
        putc(fd, c);
    11d0:	85ca                	mv	a1,s2
    11d2:	8556                	mv	a0,s5
    11d4:	00000097          	auipc	ra,0x0
    11d8:	d8e080e7          	jalr	-626(ra) # f62 <putc>
      state = 0;
    11dc:	4981                	li	s3,0
    11de:	bd51                	j	1072 <vprintf+0x42>
        s = va_arg(ap, char *);
    11e0:	8bce                	mv	s7,s3
      state = 0;
    11e2:	4981                	li	s3,0
    11e4:	b579                	j	1072 <vprintf+0x42>
    11e6:	74e2                	ld	s1,56(sp)
    11e8:	79a2                	ld	s3,40(sp)
    11ea:	7a02                	ld	s4,32(sp)
    11ec:	6ae2                	ld	s5,24(sp)
    11ee:	6b42                	ld	s6,16(sp)
    11f0:	6ba2                	ld	s7,8(sp)
    }
  }
}
    11f2:	60a6                	ld	ra,72(sp)
    11f4:	6406                	ld	s0,64(sp)
    11f6:	7942                	ld	s2,48(sp)
    11f8:	6161                	addi	sp,sp,80
    11fa:	8082                	ret

00000000000011fc <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
    11fc:	715d                	addi	sp,sp,-80
    11fe:	ec06                	sd	ra,24(sp)
    1200:	e822                	sd	s0,16(sp)
    1202:	1000                	addi	s0,sp,32
    1204:	e010                	sd	a2,0(s0)
    1206:	e414                	sd	a3,8(s0)
    1208:	e818                	sd	a4,16(s0)
    120a:	ec1c                	sd	a5,24(s0)
    120c:	03043023          	sd	a6,32(s0)
    1210:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1214:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1218:	8622                	mv	a2,s0
    121a:	00000097          	auipc	ra,0x0
    121e:	e16080e7          	jalr	-490(ra) # 1030 <vprintf>
}
    1222:	60e2                	ld	ra,24(sp)
    1224:	6442                	ld	s0,16(sp)
    1226:	6161                	addi	sp,sp,80
    1228:	8082                	ret

000000000000122a <printf>:

void printf(const char *fmt, ...) {
    122a:	711d                	addi	sp,sp,-96
    122c:	ec06                	sd	ra,24(sp)
    122e:	e822                	sd	s0,16(sp)
    1230:	1000                	addi	s0,sp,32
    1232:	e40c                	sd	a1,8(s0)
    1234:	e810                	sd	a2,16(s0)
    1236:	ec14                	sd	a3,24(s0)
    1238:	f018                	sd	a4,32(s0)
    123a:	f41c                	sd	a5,40(s0)
    123c:	03043823          	sd	a6,48(s0)
    1240:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1244:	00840613          	addi	a2,s0,8
    1248:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    124c:	85aa                	mv	a1,a0
    124e:	4505                	li	a0,1
    1250:	00000097          	auipc	ra,0x0
    1254:	de0080e7          	jalr	-544(ra) # 1030 <vprintf>
}
    1258:	60e2                	ld	ra,24(sp)
    125a:	6442                	ld	s0,16(sp)
    125c:	6125                	addi	sp,sp,96
    125e:	8082                	ret

0000000000001260 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    1260:	1141                	addi	sp,sp,-16
    1262:	e422                	sd	s0,8(sp)
    1264:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    1266:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    126a:	00001797          	auipc	a5,0x1
    126e:	da67b783          	ld	a5,-602(a5) # 2010 <freep>
    1272:	a02d                	j	129c <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    1274:	4618                	lw	a4,8(a2)
    1276:	9f2d                	addw	a4,a4,a1
    1278:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    127c:	6398                	ld	a4,0(a5)
    127e:	6310                	ld	a2,0(a4)
    1280:	a83d                	j	12be <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    1282:	ff852703          	lw	a4,-8(a0)
    1286:	9f31                	addw	a4,a4,a2
    1288:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    128a:	ff053683          	ld	a3,-16(a0)
    128e:	a091                	j	12d2 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    1290:	6398                	ld	a4,0(a5)
    1292:	00e7e463          	bltu	a5,a4,129a <free+0x3a>
    1296:	00e6ea63          	bltu	a3,a4,12aa <free+0x4a>
void free(void *ap) {
    129a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    129c:	fed7fae3          	bgeu	a5,a3,1290 <free+0x30>
    12a0:	6398                	ld	a4,0(a5)
    12a2:	00e6e463          	bltu	a3,a4,12aa <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    12a6:	fee7eae3          	bltu	a5,a4,129a <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    12aa:	ff852583          	lw	a1,-8(a0)
    12ae:	6390                	ld	a2,0(a5)
    12b0:	02059813          	slli	a6,a1,0x20
    12b4:	01c85713          	srli	a4,a6,0x1c
    12b8:	9736                	add	a4,a4,a3
    12ba:	fae60de3          	beq	a2,a4,1274 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    12be:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    12c2:	4790                	lw	a2,8(a5)
    12c4:	02061593          	slli	a1,a2,0x20
    12c8:	01c5d713          	srli	a4,a1,0x1c
    12cc:	973e                	add	a4,a4,a5
    12ce:	fae68ae3          	beq	a3,a4,1282 <free+0x22>
    p->s.ptr = bp->s.ptr;
    12d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12d4:	00001717          	auipc	a4,0x1
    12d8:	d2f73e23          	sd	a5,-708(a4) # 2010 <freep>
}
    12dc:	6422                	ld	s0,8(sp)
    12de:	0141                	addi	sp,sp,16
    12e0:	8082                	ret

00000000000012e2 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    12e2:	7139                	addi	sp,sp,-64
    12e4:	fc06                	sd	ra,56(sp)
    12e6:	f822                	sd	s0,48(sp)
    12e8:	f426                	sd	s1,40(sp)
    12ea:	ec4e                	sd	s3,24(sp)
    12ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    12ee:	02051493          	slli	s1,a0,0x20
    12f2:	9081                	srli	s1,s1,0x20
    12f4:	04bd                	addi	s1,s1,15
    12f6:	8091                	srli	s1,s1,0x4
    12f8:	0014899b          	addiw	s3,s1,1
    12fc:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    12fe:	00001517          	auipc	a0,0x1
    1302:	d1253503          	ld	a0,-750(a0) # 2010 <freep>
    1306:	c915                	beqz	a0,133a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1308:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    130a:	4798                	lw	a4,8(a5)
    130c:	08977e63          	bgeu	a4,s1,13a8 <malloc+0xc6>
    1310:	f04a                	sd	s2,32(sp)
    1312:	e852                	sd	s4,16(sp)
    1314:	e456                	sd	s5,8(sp)
    1316:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
    1318:	8a4e                	mv	s4,s3
    131a:	0009871b          	sext.w	a4,s3
    131e:	6685                	lui	a3,0x1
    1320:	00d77363          	bgeu	a4,a3,1326 <malloc+0x44>
    1324:	6a05                	lui	s4,0x1
    1326:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    132a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    132e:	00001917          	auipc	s2,0x1
    1332:	ce290913          	addi	s2,s2,-798 # 2010 <freep>
  if (p == (char *)-1) return 0;
    1336:	5afd                	li	s5,-1
    1338:	a091                	j	137c <malloc+0x9a>
    133a:	f04a                	sd	s2,32(sp)
    133c:	e852                	sd	s4,16(sp)
    133e:	e456                	sd	s5,8(sp)
    1340:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1342:	00001797          	auipc	a5,0x1
    1346:	0c678793          	addi	a5,a5,198 # 2408 <base>
    134a:	00001717          	auipc	a4,0x1
    134e:	ccf73323          	sd	a5,-826(a4) # 2010 <freep>
    1352:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1354:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    1358:	b7c1                	j	1318 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    135a:	6398                	ld	a4,0(a5)
    135c:	e118                	sd	a4,0(a0)
    135e:	a08d                	j	13c0 <malloc+0xde>
  hp->s.size = nu;
    1360:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    1364:	0541                	addi	a0,a0,16
    1366:	00000097          	auipc	ra,0x0
    136a:	efa080e7          	jalr	-262(ra) # 1260 <free>
  return freep;
    136e:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
    1372:	c13d                	beqz	a0,13d8 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1374:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    1376:	4798                	lw	a4,8(a5)
    1378:	02977463          	bgeu	a4,s1,13a0 <malloc+0xbe>
    if (p == freep)
    137c:	00093703          	ld	a4,0(s2)
    1380:	853e                	mv	a0,a5
    1382:	fef719e3          	bne	a4,a5,1374 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    1386:	8552                	mv	a0,s4
    1388:	00000097          	auipc	ra,0x0
    138c:	bba080e7          	jalr	-1094(ra) # f42 <sbrk>
  if (p == (char *)-1) return 0;
    1390:	fd5518e3          	bne	a0,s5,1360 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
    1394:	4501                	li	a0,0
    1396:	7902                	ld	s2,32(sp)
    1398:	6a42                	ld	s4,16(sp)
    139a:	6aa2                	ld	s5,8(sp)
    139c:	6b02                	ld	s6,0(sp)
    139e:	a03d                	j	13cc <malloc+0xea>
    13a0:	7902                	ld	s2,32(sp)
    13a2:	6a42                	ld	s4,16(sp)
    13a4:	6aa2                	ld	s5,8(sp)
    13a6:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    13a8:	fae489e3          	beq	s1,a4,135a <malloc+0x78>
        p->s.size -= nunits;
    13ac:	4137073b          	subw	a4,a4,s3
    13b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13b2:	02071693          	slli	a3,a4,0x20
    13b6:	01c6d713          	srli	a4,a3,0x1c
    13ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13c0:	00001717          	auipc	a4,0x1
    13c4:	c4a73823          	sd	a0,-944(a4) # 2010 <freep>
      return (void *)(p + 1);
    13c8:	01078513          	addi	a0,a5,16
  }
}
    13cc:	70e2                	ld	ra,56(sp)
    13ce:	7442                	ld	s0,48(sp)
    13d0:	74a2                	ld	s1,40(sp)
    13d2:	69e2                	ld	s3,24(sp)
    13d4:	6121                	addi	sp,sp,64
    13d6:	8082                	ret
    13d8:	7902                	ld	s2,32(sp)
    13da:	6a42                	ld	s4,16(sp)
    13dc:	6aa2                	ld	s5,8(sp)
    13de:	6b02                	ld	s6,0(sp)
    13e0:	b7f5                	j	13cc <malloc+0xea>

00000000000013e2 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
    13e2:	4909                	li	s2,2
  li s3, 3
    13e4:	498d                	li	s3,3
  li s4, 4
    13e6:	4a11                	li	s4,4
  li s5, 5
    13e8:	4a95                	li	s5,5
  li s6, 6
    13ea:	4b19                	li	s6,6
  li s7, 7
    13ec:	4b9d                	li	s7,7
  li s8, 8
    13ee:	4c21                	li	s8,8
  li s9, 9
    13f0:	4ca5                	li	s9,9
  li s10, 10
    13f2:	4d29                	li	s10,10
  li s11, 11
    13f4:	4dad                	li	s11,11
  li a7, SYS_write
    13f6:	48c1                	li	a7,16
  ecall
    13f8:	00000073          	ecall
  j loop
    13fc:	a82d                	j	1436 <loop>

00000000000013fe <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
    13fe:	4911                	li	s2,4
  li s3, 9
    1400:	49a5                	li	s3,9
  li s4, 16
    1402:	4a41                	li	s4,16
  li s5, 25
    1404:	4ae5                	li	s5,25
  li s6, 36
    1406:	02400b13          	li	s6,36
  li s7, 49
    140a:	03100b93          	li	s7,49
  li s8, 64
    140e:	04000c13          	li	s8,64
  li s9, 81
    1412:	05100c93          	li	s9,81
  li s10, 100
    1416:	06400d13          	li	s10,100
  li s11, 121
    141a:	07900d93          	li	s11,121
  li a7, SYS_write
    141e:	48c1                	li	a7,16
  ecall
    1420:	00000073          	ecall
  j loop
    1424:	a809                	j	1436 <loop>

0000000000001426 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
    1426:	53900913          	li	s2,1337
  mv a2, a1
    142a:	862e                	mv	a2,a1
  li a1, 2
    142c:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
    142e:	48d9                	li	a7,22
  ecall
    1430:	00000073          	ecall
#endif
  ret
    1434:	8082                	ret

0000000000001436 <loop>:

loop:
  j loop
    1436:	a001                	j	1436 <loop>
  ret
    1438:	8082                	ret
