
user/_xargstest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <run_xargs>:
#include "kernel/types.h"
#include "user/user.h"

char buf[512];

int run_xargs(char *input, char *args[], int pipe_out[]) {
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	f04a                	sd	s2,32(sp)
       a:	ec4e                	sd	s3,24(sp)
       c:	0080                	addi	s0,sp,64
       e:	84aa                	mv	s1,a0
      10:	89ae                	mv	s3,a1
      12:	8932                	mv	s2,a2
  // Writer process: writes input to pipe (so parent don't block)
  // Xargs process: moves fd[0] to stdin, pipe_out to stdout, execs xargs
  // Parent: returns xargs exit code

  int fds[2];
  if (pipe(fds) != 0) {
      14:	fc840513          	addi	a0,s0,-56
      18:	00001097          	auipc	ra,0x1
      1c:	a7a080e7          	jalr	-1414(ra) # a92 <pipe>
      20:	e935                	bnez	a0,94 <run_xargs+0x94>
    printf("FAILED: pipe failed\n");
    exit(1);
  }

  int pid_xargs = fork();
      22:	00001097          	auipc	ra,0x1
      26:	a58080e7          	jalr	-1448(ra) # a7a <fork>
  if (pid_xargs < 0) {
      2a:	08054263          	bltz	a0,ae <run_xargs+0xae>
    printf("FAILED: fork failed\n");
    exit(1);
  }

  if (pid_xargs == 0) {
      2e:	cd49                	beqz	a0,c8 <run_xargs+0xc8>
    // Shouldn't reach here
    printf("FAILED: exec xargs failed\n");
    exit(1);
  }

  close(fds[0]);
      30:	fc842503          	lw	a0,-56(s0)
      34:	00001097          	auipc	ra,0x1
      38:	a76080e7          	jalr	-1418(ra) # aaa <close>
  if (pipe_out) {
      3c:	00090863          	beqz	s2,4c <run_xargs+0x4c>
    close(pipe_out[1]);
      40:	00492503          	lw	a0,4(s2)
      44:	00001097          	auipc	ra,0x1
      48:	a66080e7          	jalr	-1434(ra) # aaa <close>
  }
  write(fds[1], input, strlen(input));
      4c:	fcc42903          	lw	s2,-52(s0)
      50:	8526                	mv	a0,s1
      52:	00000097          	auipc	ra,0x0
      56:	792080e7          	jalr	1938(ra) # 7e4 <strlen>
      5a:	0005061b          	sext.w	a2,a0
      5e:	85a6                	mv	a1,s1
      60:	854a                	mv	a0,s2
      62:	00001097          	auipc	ra,0x1
      66:	a40080e7          	jalr	-1472(ra) # aa2 <write>
  close(fds[1]);
      6a:	fcc42503          	lw	a0,-52(s0)
      6e:	00001097          	auipc	ra,0x1
      72:	a3c080e7          	jalr	-1476(ra) # aaa <close>

  int status;
  wait(&status);
      76:	fc440513          	addi	a0,s0,-60
      7a:	00001097          	auipc	ra,0x1
      7e:	a10080e7          	jalr	-1520(ra) # a8a <wait>
  return status;
}
      82:	fc442503          	lw	a0,-60(s0)
      86:	70e2                	ld	ra,56(sp)
      88:	7442                	ld	s0,48(sp)
      8a:	74a2                	ld	s1,40(sp)
      8c:	7902                	ld	s2,32(sp)
      8e:	69e2                	ld	s3,24(sp)
      90:	6121                	addi	sp,sp,64
      92:	8082                	ret
    printf("FAILED: pipe failed\n");
      94:	00001517          	auipc	a0,0x1
      98:	f7c50513          	addi	a0,a0,-132 # 1010 <loop+0x12>
      9c:	00001097          	auipc	ra,0x1
      a0:	d56080e7          	jalr	-682(ra) # df2 <printf>
    exit(1);
      a4:	4505                	li	a0,1
      a6:	00001097          	auipc	ra,0x1
      aa:	9dc080e7          	jalr	-1572(ra) # a82 <exit>
    printf("FAILED: fork failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	f8250513          	addi	a0,a0,-126 # 1030 <loop+0x32>
      b6:	00001097          	auipc	ra,0x1
      ba:	d3c080e7          	jalr	-708(ra) # df2 <printf>
    exit(1);
      be:	4505                	li	a0,1
      c0:	00001097          	auipc	ra,0x1
      c4:	9c2080e7          	jalr	-1598(ra) # a82 <exit>
    close(0);
      c8:	00001097          	auipc	ra,0x1
      cc:	9e2080e7          	jalr	-1566(ra) # aaa <close>
    close(fds[1]);
      d0:	fcc42503          	lw	a0,-52(s0)
      d4:	00001097          	auipc	ra,0x1
      d8:	9d6080e7          	jalr	-1578(ra) # aaa <close>
    dup(fds[0]);  // stdin = pipe read
      dc:	fc842503          	lw	a0,-56(s0)
      e0:	00001097          	auipc	ra,0x1
      e4:	a1a080e7          	jalr	-1510(ra) # afa <dup>
    close(fds[0]);
      e8:	fc842503          	lw	a0,-56(s0)
      ec:	00001097          	auipc	ra,0x1
      f0:	9be080e7          	jalr	-1602(ra) # aaa <close>
    if (pipe_out) {
      f4:	02090363          	beqz	s2,11a <run_xargs+0x11a>
      close(1);
      f8:	4505                	li	a0,1
      fa:	00001097          	auipc	ra,0x1
      fe:	9b0080e7          	jalr	-1616(ra) # aaa <close>
      dup(pipe_out[1]);  // stdout = pipe_out write
     102:	00492503          	lw	a0,4(s2)
     106:	00001097          	auipc	ra,0x1
     10a:	9f4080e7          	jalr	-1548(ra) # afa <dup>
      close(pipe_out[1]);
     10e:	00492503          	lw	a0,4(s2)
     112:	00001097          	auipc	ra,0x1
     116:	998080e7          	jalr	-1640(ra) # aaa <close>
    exec("xargs", args);
     11a:	85ce                	mv	a1,s3
     11c:	00001517          	auipc	a0,0x1
     120:	f2c50513          	addi	a0,a0,-212 # 1048 <loop+0x4a>
     124:	00001097          	auipc	ra,0x1
     128:	996080e7          	jalr	-1642(ra) # aba <exec>
    printf("FAILED: exec xargs failed\n");
     12c:	00001517          	auipc	a0,0x1
     130:	f2450513          	addi	a0,a0,-220 # 1050 <loop+0x52>
     134:	00001097          	auipc	ra,0x1
     138:	cbe080e7          	jalr	-834(ra) # df2 <printf>
    exit(1);
     13c:	4505                	li	a0,1
     13e:	00001097          	auipc	ra,0x1
     142:	944080e7          	jalr	-1724(ra) # a82 <exit>

0000000000000146 <basic_test>:

void basic_test(void) {
     146:	7139                	addi	sp,sp,-64
     148:	fc06                	sd	ra,56(sp)
     14a:	f822                	sd	s0,48(sp)
     14c:	0080                	addi	s0,sp,64
  printf("basic test... ");
     14e:	00001517          	auipc	a0,0x1
     152:	f2250513          	addi	a0,a0,-222 # 1070 <loop+0x72>
     156:	00001097          	auipc	ra,0x1
     15a:	c9c080e7          	jalr	-868(ra) # df2 <printf>

  int fds[2];
  if (pipe(fds) != 0) {
     15e:	fe840513          	addi	a0,s0,-24
     162:	00001097          	auipc	ra,0x1
     166:	930080e7          	jalr	-1744(ra) # a92 <pipe>
     16a:	cd11                	beqz	a0,186 <basic_test+0x40>
    printf("FAILED: pipe failed\n");
     16c:	00001517          	auipc	a0,0x1
     170:	ea450513          	addi	a0,a0,-348 # 1010 <loop+0x12>
     174:	00001097          	auipc	ra,0x1
     178:	c7e080e7          	jalr	-898(ra) # df2 <printf>
    exit(1);
     17c:	4505                	li	a0,1
     17e:	00001097          	auipc	ra,0x1
     182:	904080e7          	jalr	-1788(ra) # a82 <exit>
  }

  if (run_xargs("line1\nline2\n", (char *[]){"xargs", "echo", "this", "is", 0},
     186:	00001797          	auipc	a5,0x1
     18a:	32278793          	addi	a5,a5,802 # 14a8 <loop+0x4aa>
     18e:	638c                	ld	a1,0(a5)
     190:	6790                	ld	a2,8(a5)
     192:	6b94                	ld	a3,16(a5)
     194:	6f98                	ld	a4,24(a5)
     196:	739c                	ld	a5,32(a5)
     198:	fcb43023          	sd	a1,-64(s0)
     19c:	fcc43423          	sd	a2,-56(s0)
     1a0:	fcd43823          	sd	a3,-48(s0)
     1a4:	fce43c23          	sd	a4,-40(s0)
     1a8:	fef43023          	sd	a5,-32(s0)
     1ac:	fe840613          	addi	a2,s0,-24
     1b0:	fc040593          	addi	a1,s0,-64
     1b4:	00001517          	auipc	a0,0x1
     1b8:	ecc50513          	addi	a0,a0,-308 # 1080 <loop+0x82>
     1bc:	00000097          	auipc	ra,0x0
     1c0:	e44080e7          	jalr	-444(ra) # 0 <run_xargs>
     1c4:	cd11                	beqz	a0,1e0 <basic_test+0x9a>
                fds) != 0) {
    printf("FAILED: xargs failed\n");
     1c6:	00001517          	auipc	a0,0x1
     1ca:	eca50513          	addi	a0,a0,-310 # 1090 <loop+0x92>
     1ce:	00001097          	auipc	ra,0x1
     1d2:	c24080e7          	jalr	-988(ra) # df2 <printf>
    exit(1);
     1d6:	4505                	li	a0,1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	8aa080e7          	jalr	-1878(ra) # a82 <exit>
  }

  int n = read(fds[0], buf, sizeof(buf) - 1);
     1e0:	1ff00613          	li	a2,511
     1e4:	00002597          	auipc	a1,0x2
     1e8:	e2c58593          	addi	a1,a1,-468 # 2010 <buf>
     1ec:	fe842503          	lw	a0,-24(s0)
     1f0:	00001097          	auipc	ra,0x1
     1f4:	8aa080e7          	jalr	-1878(ra) # a9a <read>
     1f8:	87aa                	mv	a5,a0
  if (n < 0) {
     1fa:	04054363          	bltz	a0,240 <basic_test+0xfa>
    printf("FAILED: read failed\n");
    exit(1);
  }
  buf[n] = 0;
     1fe:	00002517          	auipc	a0,0x2
     202:	e1250513          	addi	a0,a0,-494 # 2010 <buf>
     206:	97aa                	add	a5,a5,a0
     208:	00078023          	sb	zero,0(a5)
  if (strcmp(buf, "this is line1\nthis is line2\n") != 0) {
     20c:	00001597          	auipc	a1,0x1
     210:	eb458593          	addi	a1,a1,-332 # 10c0 <loop+0xc2>
     214:	00000097          	auipc	ra,0x0
     218:	5a4080e7          	jalr	1444(ra) # 7b8 <strcmp>
     21c:	cd1d                	beqz	a0,25a <basic_test+0x114>
    printf("FAILED: unexpected output '%s'\n", buf);
     21e:	00002597          	auipc	a1,0x2
     222:	df258593          	addi	a1,a1,-526 # 2010 <buf>
     226:	00001517          	auipc	a0,0x1
     22a:	eba50513          	addi	a0,a0,-326 # 10e0 <loop+0xe2>
     22e:	00001097          	auipc	ra,0x1
     232:	bc4080e7          	jalr	-1084(ra) # df2 <printf>
    exit(1);
     236:	4505                	li	a0,1
     238:	00001097          	auipc	ra,0x1
     23c:	84a080e7          	jalr	-1974(ra) # a82 <exit>
    printf("FAILED: read failed\n");
     240:	00001517          	auipc	a0,0x1
     244:	e6850513          	addi	a0,a0,-408 # 10a8 <loop+0xaa>
     248:	00001097          	auipc	ra,0x1
     24c:	baa080e7          	jalr	-1110(ra) # df2 <printf>
    exit(1);
     250:	4505                	li	a0,1
     252:	00001097          	auipc	ra,0x1
     256:	830080e7          	jalr	-2000(ra) # a82 <exit>
  }
  close(fds[0]);
     25a:	fe842503          	lw	a0,-24(s0)
     25e:	00001097          	auipc	ra,0x1
     262:	84c080e7          	jalr	-1972(ra) # aaa <close>

  printf("OK\n");
     266:	00001517          	auipc	a0,0x1
     26a:	e9a50513          	addi	a0,a0,-358 # 1100 <loop+0x102>
     26e:	00001097          	auipc	ra,0x1
     272:	b84080e7          	jalr	-1148(ra) # df2 <printf>
  exit(0);
     276:	4501                	li	a0,0
     278:	00001097          	auipc	ra,0x1
     27c:	80a080e7          	jalr	-2038(ra) # a82 <exit>

0000000000000280 <grep_test>:
}

void grep_test(void) {
     280:	715d                	addi	sp,sp,-80
     282:	e486                	sd	ra,72(sp)
     284:	e0a2                	sd	s0,64(sp)
     286:	0880                	addi	s0,sp,80
  printf("grep test... ");
     288:	00001517          	auipc	a0,0x1
     28c:	e8050513          	addi	a0,a0,-384 # 1108 <loop+0x10a>
     290:	00001097          	auipc	ra,0x1
     294:	b62080e7          	jalr	-1182(ra) # df2 <printf>

  if (mkdir("xargstest1") < 0) {
     298:	00001517          	auipc	a0,0x1
     29c:	e8050513          	addi	a0,a0,-384 # 1118 <loop+0x11a>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	84a080e7          	jalr	-1974(ra) # aea <mkdir>
     2a8:	10054463          	bltz	a0,3b0 <grep_test+0x130>
     2ac:	fc26                	sd	s1,56(sp)
    printf("FAILED: mkdir xargstest1 failed\n");
    exit(1);
  }

  int fd;
  fd = open("xargstest1/file1.txt", O_CREATE | O_WRONLY);
     2ae:	20100593          	li	a1,513
     2b2:	00001517          	auipc	a0,0x1
     2b6:	e9e50513          	addi	a0,a0,-354 # 1150 <loop+0x152>
     2ba:	00001097          	auipc	ra,0x1
     2be:	808080e7          	jalr	-2040(ra) # ac2 <open>
     2c2:	84aa                	mv	s1,a0
  if (fd < 0) {
     2c4:	10054463          	bltz	a0,3cc <grep_test+0x14c>
    printf("FAILED: create file1.txt failed\n");
    exit(1);
  }
  write(fd, "hello world\npattern here\n", 25);
     2c8:	4665                	li	a2,25
     2ca:	00001597          	auipc	a1,0x1
     2ce:	ec658593          	addi	a1,a1,-314 # 1190 <loop+0x192>
     2d2:	00000097          	auipc	ra,0x0
     2d6:	7d0080e7          	jalr	2000(ra) # aa2 <write>
  close(fd);
     2da:	8526                	mv	a0,s1
     2dc:	00000097          	auipc	ra,0x0
     2e0:	7ce080e7          	jalr	1998(ra) # aaa <close>

  fd = open("xargstest1/file2.txt", O_CREATE | O_WRONLY);
     2e4:	20100593          	li	a1,513
     2e8:	00001517          	auipc	a0,0x1
     2ec:	ec850513          	addi	a0,a0,-312 # 11b0 <loop+0x1b2>
     2f0:	00000097          	auipc	ra,0x0
     2f4:	7d2080e7          	jalr	2002(ra) # ac2 <open>
     2f8:	84aa                	mv	s1,a0
  if (fd < 0) {
     2fa:	0e054663          	bltz	a0,3e6 <grep_test+0x166>
    printf("FAILED: create file2.txt failed\n");
    exit(1);
  }
  write(fd, "no match here\nother text\n", 25);
     2fe:	4665                	li	a2,25
     300:	00001597          	auipc	a1,0x1
     304:	ef058593          	addi	a1,a1,-272 # 11f0 <loop+0x1f2>
     308:	00000097          	auipc	ra,0x0
     30c:	79a080e7          	jalr	1946(ra) # aa2 <write>
  close(fd);
     310:	8526                	mv	a0,s1
     312:	00000097          	auipc	ra,0x0
     316:	798080e7          	jalr	1944(ra) # aaa <close>

  fd = open("xargstest1/file3.txt", O_CREATE | O_WRONLY);
     31a:	20100593          	li	a1,513
     31e:	00001517          	auipc	a0,0x1
     322:	ef250513          	addi	a0,a0,-270 # 1210 <loop+0x212>
     326:	00000097          	auipc	ra,0x0
     32a:	79c080e7          	jalr	1948(ra) # ac2 <open>
     32e:	84aa                	mv	s1,a0
  if (fd < 0) {
     330:	0c054863          	bltz	a0,400 <grep_test+0x180>
    printf("FAILED: create file3.txt failed\n");
    exit(1);
  }
  write(fd, "pattern found\nmore text\n", 24);
     334:	4661                	li	a2,24
     336:	00001597          	auipc	a1,0x1
     33a:	f1a58593          	addi	a1,a1,-230 # 1250 <loop+0x252>
     33e:	00000097          	auipc	ra,0x0
     342:	764080e7          	jalr	1892(ra) # aa2 <write>
  close(fd);
     346:	8526                	mv	a0,s1
     348:	00000097          	auipc	ra,0x0
     34c:	762080e7          	jalr	1890(ra) # aaa <close>

  fd = open("xargstest1/file4.txt", O_CREATE | O_WRONLY);
     350:	20100593          	li	a1,513
     354:	00001517          	auipc	a0,0x1
     358:	f1c50513          	addi	a0,a0,-228 # 1270 <loop+0x272>
     35c:	00000097          	auipc	ra,0x0
     360:	766080e7          	jalr	1894(ra) # ac2 <open>
     364:	84aa                	mv	s1,a0
  if (fd < 0) {
     366:	0a054a63          	bltz	a0,41a <grep_test+0x19a>
    printf("FAILED: create file4.txt failed\n");
    exit(1);
  }
  write(fd, "this pattern is false\nmore text\n", 32);
     36a:	02000613          	li	a2,32
     36e:	00001597          	auipc	a1,0x1
     372:	f4258593          	addi	a1,a1,-190 # 12b0 <loop+0x2b2>
     376:	00000097          	auipc	ra,0x0
     37a:	72c080e7          	jalr	1836(ra) # aa2 <write>
  close(fd);
     37e:	8526                	mv	a0,s1
     380:	00000097          	auipc	ra,0x0
     384:	72a080e7          	jalr	1834(ra) # aaa <close>

  int pipe_out[2];
  if (pipe(pipe_out) != 0) {
     388:	fd840513          	addi	a0,s0,-40
     38c:	00000097          	auipc	ra,0x0
     390:	706080e7          	jalr	1798(ra) # a92 <pipe>
     394:	c145                	beqz	a0,434 <grep_test+0x1b4>
    printf("FAILED: pipe failed\n");
     396:	00001517          	auipc	a0,0x1
     39a:	c7a50513          	addi	a0,a0,-902 # 1010 <loop+0x12>
     39e:	00001097          	auipc	ra,0x1
     3a2:	a54080e7          	jalr	-1452(ra) # df2 <printf>
    exit(1);
     3a6:	4505                	li	a0,1
     3a8:	00000097          	auipc	ra,0x0
     3ac:	6da080e7          	jalr	1754(ra) # a82 <exit>
     3b0:	fc26                	sd	s1,56(sp)
    printf("FAILED: mkdir xargstest1 failed\n");
     3b2:	00001517          	auipc	a0,0x1
     3b6:	d7650513          	addi	a0,a0,-650 # 1128 <loop+0x12a>
     3ba:	00001097          	auipc	ra,0x1
     3be:	a38080e7          	jalr	-1480(ra) # df2 <printf>
    exit(1);
     3c2:	4505                	li	a0,1
     3c4:	00000097          	auipc	ra,0x0
     3c8:	6be080e7          	jalr	1726(ra) # a82 <exit>
    printf("FAILED: create file1.txt failed\n");
     3cc:	00001517          	auipc	a0,0x1
     3d0:	d9c50513          	addi	a0,a0,-612 # 1168 <loop+0x16a>
     3d4:	00001097          	auipc	ra,0x1
     3d8:	a1e080e7          	jalr	-1506(ra) # df2 <printf>
    exit(1);
     3dc:	4505                	li	a0,1
     3de:	00000097          	auipc	ra,0x0
     3e2:	6a4080e7          	jalr	1700(ra) # a82 <exit>
    printf("FAILED: create file2.txt failed\n");
     3e6:	00001517          	auipc	a0,0x1
     3ea:	de250513          	addi	a0,a0,-542 # 11c8 <loop+0x1ca>
     3ee:	00001097          	auipc	ra,0x1
     3f2:	a04080e7          	jalr	-1532(ra) # df2 <printf>
    exit(1);
     3f6:	4505                	li	a0,1
     3f8:	00000097          	auipc	ra,0x0
     3fc:	68a080e7          	jalr	1674(ra) # a82 <exit>
    printf("FAILED: create file3.txt failed\n");
     400:	00001517          	auipc	a0,0x1
     404:	e2850513          	addi	a0,a0,-472 # 1228 <loop+0x22a>
     408:	00001097          	auipc	ra,0x1
     40c:	9ea080e7          	jalr	-1558(ra) # df2 <printf>
    exit(1);
     410:	4505                	li	a0,1
     412:	00000097          	auipc	ra,0x0
     416:	670080e7          	jalr	1648(ra) # a82 <exit>
    printf("FAILED: create file4.txt failed\n");
     41a:	00001517          	auipc	a0,0x1
     41e:	e6e50513          	addi	a0,a0,-402 # 1288 <loop+0x28a>
     422:	00001097          	auipc	ra,0x1
     426:	9d0080e7          	jalr	-1584(ra) # df2 <printf>
    exit(1);
     42a:	4505                	li	a0,1
     42c:	00000097          	auipc	ra,0x0
     430:	656080e7          	jalr	1622(ra) # a82 <exit>
  }

  if (run_xargs(
          "xargstest1/file1.txt\nxargstest1/file2.txt\nxargstest1/file3.txt\n",
          (char *[]){"xargs", "grep", "pattern", 0}, pipe_out) != 0) {
     434:	00001797          	auipc	a5,0x1
     438:	07478793          	addi	a5,a5,116 # 14a8 <loop+0x4aa>
     43c:	7790                	ld	a2,40(a5)
     43e:	7b94                	ld	a3,48(a5)
     440:	7f98                	ld	a4,56(a5)
     442:	63bc                	ld	a5,64(a5)
     444:	fac43c23          	sd	a2,-72(s0)
     448:	fcd43023          	sd	a3,-64(s0)
     44c:	fce43423          	sd	a4,-56(s0)
     450:	fcf43823          	sd	a5,-48(s0)
  if (run_xargs(
     454:	fd840613          	addi	a2,s0,-40
     458:	fb840593          	addi	a1,s0,-72
     45c:	00001517          	auipc	a0,0x1
     460:	e7c50513          	addi	a0,a0,-388 # 12d8 <loop+0x2da>
     464:	00000097          	auipc	ra,0x0
     468:	b9c080e7          	jalr	-1124(ra) # 0 <run_xargs>
     46c:	cd11                	beqz	a0,488 <grep_test+0x208>
    printf("FAILED: xargs grep failed\n");
     46e:	00001517          	auipc	a0,0x1
     472:	eaa50513          	addi	a0,a0,-342 # 1318 <loop+0x31a>
     476:	00001097          	auipc	ra,0x1
     47a:	97c080e7          	jalr	-1668(ra) # df2 <printf>
    exit(1);
     47e:	4505                	li	a0,1
     480:	00000097          	auipc	ra,0x0
     484:	602080e7          	jalr	1538(ra) # a82 <exit>
  }

  int n = read(pipe_out[0], buf, sizeof(buf) - 1);
     488:	1ff00613          	li	a2,511
     48c:	00002597          	auipc	a1,0x2
     490:	b8458593          	addi	a1,a1,-1148 # 2010 <buf>
     494:	fd842503          	lw	a0,-40(s0)
     498:	00000097          	auipc	ra,0x0
     49c:	602080e7          	jalr	1538(ra) # a9a <read>
  if (n < 0) {
     4a0:	06054063          	bltz	a0,500 <grep_test+0x280>
    printf("FAILED: read failed\n");
    exit(1);
  }
  buf[n] = 0;
     4a4:	00002497          	auipc	s1,0x2
     4a8:	b6c48493          	addi	s1,s1,-1172 # 2010 <buf>
     4ac:	9526                	add	a0,a0,s1
     4ae:	00050023          	sb	zero,0(a0)
  close(pipe_out[0]);
     4b2:	fd842503          	lw	a0,-40(s0)
     4b6:	00000097          	auipc	ra,0x0
     4ba:	5f4080e7          	jalr	1524(ra) # aaa <close>

  if (strstr(buf, "pattern here") == 0 || strstr(buf, "pattern found") == 0) {
     4be:	00001597          	auipc	a1,0x1
     4c2:	e7a58593          	addi	a1,a1,-390 # 1338 <loop+0x33a>
     4c6:	8526                	mv	a0,s1
     4c8:	00000097          	auipc	ra,0x0
     4cc:	566080e7          	jalr	1382(ra) # a2e <strstr>
     4d0:	c529                	beqz	a0,51a <grep_test+0x29a>
     4d2:	00001597          	auipc	a1,0x1
     4d6:	e7658593          	addi	a1,a1,-394 # 1348 <loop+0x34a>
     4da:	8526                	mv	a0,s1
     4dc:	00000097          	auipc	ra,0x0
     4e0:	552080e7          	jalr	1362(ra) # a2e <strstr>
     4e4:	c91d                	beqz	a0,51a <grep_test+0x29a>
    printf("FAILED: pattern not found in expected files, got: '%s'\n", buf);
    exit(1);
  }

  printf("OK\n");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	c1a50513          	addi	a0,a0,-998 # 1100 <loop+0x102>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	904080e7          	jalr	-1788(ra) # df2 <printf>
  exit(0);
     4f6:	4501                	li	a0,0
     4f8:	00000097          	auipc	ra,0x0
     4fc:	58a080e7          	jalr	1418(ra) # a82 <exit>
    printf("FAILED: read failed\n");
     500:	00001517          	auipc	a0,0x1
     504:	ba850513          	addi	a0,a0,-1112 # 10a8 <loop+0xaa>
     508:	00001097          	auipc	ra,0x1
     50c:	8ea080e7          	jalr	-1814(ra) # df2 <printf>
    exit(1);
     510:	4505                	li	a0,1
     512:	00000097          	auipc	ra,0x0
     516:	570080e7          	jalr	1392(ra) # a82 <exit>
    printf("FAILED: pattern not found in expected files, got: '%s'\n", buf);
     51a:	00002597          	auipc	a1,0x2
     51e:	af658593          	addi	a1,a1,-1290 # 2010 <buf>
     522:	00001517          	auipc	a0,0x1
     526:	e3650513          	addi	a0,a0,-458 # 1358 <loop+0x35a>
     52a:	00001097          	auipc	ra,0x1
     52e:	8c8080e7          	jalr	-1848(ra) # df2 <printf>
    exit(1);
     532:	4505                	li	a0,1
     534:	00000097          	auipc	ra,0x0
     538:	54e080e7          	jalr	1358(ra) # a82 <exit>

000000000000053c <exec_error_test>:
}

void exec_error_test(void) {
     53c:	7179                	addi	sp,sp,-48
     53e:	f406                	sd	ra,40(sp)
     540:	f022                	sd	s0,32(sp)
     542:	1800                	addi	s0,sp,48
  printf("exec error test... ");
     544:	00001517          	auipc	a0,0x1
     548:	e4c50513          	addi	a0,a0,-436 # 1390 <loop+0x392>
     54c:	00001097          	auipc	ra,0x1
     550:	8a6080e7          	jalr	-1882(ra) # df2 <printf>

  int status = run_xargs("arg\n", (char *[]){"xargs", "false", 0}, 0);
     554:	00001797          	auipc	a5,0x1
     558:	af478793          	addi	a5,a5,-1292 # 1048 <loop+0x4a>
     55c:	fcf43c23          	sd	a5,-40(s0)
     560:	00001797          	auipc	a5,0x1
     564:	e4878793          	addi	a5,a5,-440 # 13a8 <loop+0x3aa>
     568:	fef43023          	sd	a5,-32(s0)
     56c:	fe043423          	sd	zero,-24(s0)
     570:	4601                	li	a2,0
     572:	fd840593          	addi	a1,s0,-40
     576:	00001517          	auipc	a0,0x1
     57a:	e3a50513          	addi	a0,a0,-454 # 13b0 <loop+0x3b2>
     57e:	00000097          	auipc	ra,0x0
     582:	a82080e7          	jalr	-1406(ra) # 0 <run_xargs>
  if (status == 0) {
     586:	ed11                	bnez	a0,5a2 <exec_error_test+0x66>
    printf("FAILED: expected xargs failure, got success\n");
     588:	00001517          	auipc	a0,0x1
     58c:	e3050513          	addi	a0,a0,-464 # 13b8 <loop+0x3ba>
     590:	00001097          	auipc	ra,0x1
     594:	862080e7          	jalr	-1950(ra) # df2 <printf>
    exit(1);
     598:	4505                	li	a0,1
     59a:	00000097          	auipc	ra,0x0
     59e:	4e8080e7          	jalr	1256(ra) # a82 <exit>
  }

  printf("OK\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	b5e50513          	addi	a0,a0,-1186 # 1100 <loop+0x102>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	848080e7          	jalr	-1976(ra) # df2 <printf>
  exit(0);
     5b2:	4501                	li	a0,0
     5b4:	00000097          	auipc	ra,0x0
     5b8:	4ce080e7          	jalr	1230(ra) # a82 <exit>

00000000000005bc <child_error_test>:
}

void child_error_test(void) {
     5bc:	7179                	addi	sp,sp,-48
     5be:	f406                	sd	ra,40(sp)
     5c0:	f022                	sd	s0,32(sp)
     5c2:	1800                	addi	s0,sp,48
  printf("child error test... ");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e2450513          	addi	a0,a0,-476 # 13e8 <loop+0x3ea>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	826080e7          	jalr	-2010(ra) # df2 <printf>

  int status =
      run_xargs("nonexistentfile.txt\n", (char *[]){"xargs", "wc", 0}, 0);
     5d4:	00001797          	auipc	a5,0x1
     5d8:	a7478793          	addi	a5,a5,-1420 # 1048 <loop+0x4a>
     5dc:	fcf43c23          	sd	a5,-40(s0)
     5e0:	00001797          	auipc	a5,0x1
     5e4:	e2078793          	addi	a5,a5,-480 # 1400 <loop+0x402>
     5e8:	fef43023          	sd	a5,-32(s0)
     5ec:	fe043423          	sd	zero,-24(s0)
     5f0:	4601                	li	a2,0
     5f2:	fd840593          	addi	a1,s0,-40
     5f6:	00001517          	auipc	a0,0x1
     5fa:	e1250513          	addi	a0,a0,-494 # 1408 <loop+0x40a>
     5fe:	00000097          	auipc	ra,0x0
     602:	a02080e7          	jalr	-1534(ra) # 0 <run_xargs>
  if (status == 0) {
     606:	ed11                	bnez	a0,622 <child_error_test+0x66>
    printf("FAILED: expected xargs failure, got success\n");
     608:	00001517          	auipc	a0,0x1
     60c:	db050513          	addi	a0,a0,-592 # 13b8 <loop+0x3ba>
     610:	00000097          	auipc	ra,0x0
     614:	7e2080e7          	jalr	2018(ra) # df2 <printf>
    exit(1);
     618:	4505                	li	a0,1
     61a:	00000097          	auipc	ra,0x0
     61e:	468080e7          	jalr	1128(ra) # a82 <exit>
  }

  printf("OK\n");
     622:	00001517          	auipc	a0,0x1
     626:	ade50513          	addi	a0,a0,-1314 # 1100 <loop+0x102>
     62a:	00000097          	auipc	ra,0x0
     62e:	7c8080e7          	jalr	1992(ra) # df2 <printf>
  exit(0);
     632:	4501                	li	a0,0
     634:	00000097          	auipc	ra,0x0
     638:	44e080e7          	jalr	1102(ra) # a82 <exit>

000000000000063c <cleanup_test_files>:
}

// Clean up test files and directories
void cleanup_test_files(void) {
     63c:	1141                	addi	sp,sp,-16
     63e:	e406                	sd	ra,8(sp)
     640:	e022                	sd	s0,0(sp)
     642:	0800                	addi	s0,sp,16
  unlink("xargstest1/file1.txt");
     644:	00001517          	auipc	a0,0x1
     648:	b0c50513          	addi	a0,a0,-1268 # 1150 <loop+0x152>
     64c:	00000097          	auipc	ra,0x0
     650:	486080e7          	jalr	1158(ra) # ad2 <unlink>
  unlink("xargstest1/file2.txt");
     654:	00001517          	auipc	a0,0x1
     658:	b5c50513          	addi	a0,a0,-1188 # 11b0 <loop+0x1b2>
     65c:	00000097          	auipc	ra,0x0
     660:	476080e7          	jalr	1142(ra) # ad2 <unlink>
  unlink("xargstest1/file3.txt");
     664:	00001517          	auipc	a0,0x1
     668:	bac50513          	addi	a0,a0,-1108 # 1210 <loop+0x212>
     66c:	00000097          	auipc	ra,0x0
     670:	466080e7          	jalr	1126(ra) # ad2 <unlink>
  unlink("xargstest1");
     674:	00001517          	auipc	a0,0x1
     678:	aa450513          	addi	a0,a0,-1372 # 1118 <loop+0x11a>
     67c:	00000097          	auipc	ra,0x0
     680:	456080e7          	jalr	1110(ra) # ad2 <unlink>
}
     684:	60a2                	ld	ra,8(sp)
     686:	6402                	ld	s0,0(sp)
     688:	0141                	addi	sp,sp,16
     68a:	8082                	ret

000000000000068c <main>:

int main(int argc, char *argv[]) {
     68c:	1101                	addi	sp,sp,-32
     68e:	ec06                	sd	ra,24(sp)
     690:	e822                	sd	s0,16(sp)
     692:	1000                	addi	s0,sp,32
  printf("xargstest starting\n");
     694:	00001517          	auipc	a0,0x1
     698:	d8c50513          	addi	a0,a0,-628 # 1420 <loop+0x422>
     69c:	00000097          	auipc	ra,0x0
     6a0:	756080e7          	jalr	1878(ra) # df2 <printf>

  int pid = fork();
     6a4:	00000097          	auipc	ra,0x0
     6a8:	3d6080e7          	jalr	982(ra) # a7a <fork>
  if (pid == 0) {
     6ac:	e509                	bnez	a0,6b6 <main+0x2a>
    basic_test();
     6ae:	00000097          	auipc	ra,0x0
     6b2:	a98080e7          	jalr	-1384(ra) # 146 <basic_test>
  } else {
    int status;
    wait(&status);
     6b6:	fec40513          	addi	a0,s0,-20
     6ba:	00000097          	auipc	ra,0x0
     6be:	3d0080e7          	jalr	976(ra) # a8a <wait>
    if (status != 0) {
     6c2:	fec42783          	lw	a5,-20(s0)
     6c6:	cf91                	beqz	a5,6e2 <main+0x56>
      printf("basic test FAILED\n");
     6c8:	00001517          	auipc	a0,0x1
     6cc:	d7050513          	addi	a0,a0,-656 # 1438 <loop+0x43a>
     6d0:	00000097          	auipc	ra,0x0
     6d4:	722080e7          	jalr	1826(ra) # df2 <printf>
      exit(1);
     6d8:	4505                	li	a0,1
     6da:	00000097          	auipc	ra,0x0
     6de:	3a8080e7          	jalr	936(ra) # a82 <exit>
    }
  }

  pid = fork();
     6e2:	00000097          	auipc	ra,0x0
     6e6:	398080e7          	jalr	920(ra) # a7a <fork>
  if (pid == 0) {
     6ea:	e509                	bnez	a0,6f4 <main+0x68>
    grep_test();
     6ec:	00000097          	auipc	ra,0x0
     6f0:	b94080e7          	jalr	-1132(ra) # 280 <grep_test>
  } else {
    int status;
    wait(&status);
     6f4:	fec40513          	addi	a0,s0,-20
     6f8:	00000097          	auipc	ra,0x0
     6fc:	392080e7          	jalr	914(ra) # a8a <wait>
    if (status != 0) {
     700:	fec42783          	lw	a5,-20(s0)
     704:	c395                	beqz	a5,728 <main+0x9c>
      printf("FAILED\n");
     706:	00001517          	auipc	a0,0x1
     70a:	d4a50513          	addi	a0,a0,-694 # 1450 <loop+0x452>
     70e:	00000097          	auipc	ra,0x0
     712:	6e4080e7          	jalr	1764(ra) # df2 <printf>
      cleanup_test_files();
     716:	00000097          	auipc	ra,0x0
     71a:	f26080e7          	jalr	-218(ra) # 63c <cleanup_test_files>
      exit(1);
     71e:	4505                	li	a0,1
     720:	00000097          	auipc	ra,0x0
     724:	362080e7          	jalr	866(ra) # a82 <exit>
    }
  }
  cleanup_test_files();
     728:	00000097          	auipc	ra,0x0
     72c:	f14080e7          	jalr	-236(ra) # 63c <cleanup_test_files>

  pid = fork();
     730:	00000097          	auipc	ra,0x0
     734:	34a080e7          	jalr	842(ra) # a7a <fork>
  if (pid == 0) {
     738:	e509                	bnez	a0,742 <main+0xb6>
    exec_error_test();
     73a:	00000097          	auipc	ra,0x0
     73e:	e02080e7          	jalr	-510(ra) # 53c <exec_error_test>
  } else {
    wait(0);
     742:	4501                	li	a0,0
     744:	00000097          	auipc	ra,0x0
     748:	346080e7          	jalr	838(ra) # a8a <wait>
  }

  pid = fork();
     74c:	00000097          	auipc	ra,0x0
     750:	32e080e7          	jalr	814(ra) # a7a <fork>
  if (pid == 0) {
     754:	e509                	bnez	a0,75e <main+0xd2>
    child_error_test();
     756:	00000097          	auipc	ra,0x0
     75a:	e66080e7          	jalr	-410(ra) # 5bc <child_error_test>
  } else {
    wait(0);
     75e:	4501                	li	a0,0
     760:	00000097          	auipc	ra,0x0
     764:	32a080e7          	jalr	810(ra) # a8a <wait>
  }

  printf("xargstest: all tests passed\n");
     768:	00001517          	auipc	a0,0x1
     76c:	cf050513          	addi	a0,a0,-784 # 1458 <loop+0x45a>
     770:	00000097          	auipc	ra,0x0
     774:	682080e7          	jalr	1666(ra) # df2 <printf>
  exit(0);
     778:	4501                	li	a0,0
     77a:	00000097          	auipc	ra,0x0
     77e:	308080e7          	jalr	776(ra) # a82 <exit>

0000000000000782 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
     782:	1141                	addi	sp,sp,-16
     784:	e406                	sd	ra,8(sp)
     786:	e022                	sd	s0,0(sp)
     788:	0800                	addi	s0,sp,16
  extern int main();
  main();
     78a:	00000097          	auipc	ra,0x0
     78e:	f02080e7          	jalr	-254(ra) # 68c <main>
  exit(0);
     792:	4501                	li	a0,0
     794:	00000097          	auipc	ra,0x0
     798:	2ee080e7          	jalr	750(ra) # a82 <exit>

000000000000079c <strcpy>:
}

char *strcpy(char *s, const char *t) {
     79c:	1141                	addi	sp,sp,-16
     79e:	e422                	sd	s0,8(sp)
     7a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
     7a2:	87aa                	mv	a5,a0
     7a4:	0585                	addi	a1,a1,1
     7a6:	0785                	addi	a5,a5,1
     7a8:	fff5c703          	lbu	a4,-1(a1)
     7ac:	fee78fa3          	sb	a4,-1(a5)
     7b0:	fb75                	bnez	a4,7a4 <strcpy+0x8>
  return os;
}
     7b2:	6422                	ld	s0,8(sp)
     7b4:	0141                	addi	sp,sp,16
     7b6:	8082                	ret

00000000000007b8 <strcmp>:

int strcmp(const char *p, const char *q) {
     7b8:	1141                	addi	sp,sp,-16
     7ba:	e422                	sd	s0,8(sp)
     7bc:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
     7be:	00054783          	lbu	a5,0(a0)
     7c2:	cb91                	beqz	a5,7d6 <strcmp+0x1e>
     7c4:	0005c703          	lbu	a4,0(a1)
     7c8:	00f71763          	bne	a4,a5,7d6 <strcmp+0x1e>
     7cc:	0505                	addi	a0,a0,1
     7ce:	0585                	addi	a1,a1,1
     7d0:	00054783          	lbu	a5,0(a0)
     7d4:	fbe5                	bnez	a5,7c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     7d6:	0005c503          	lbu	a0,0(a1)
}
     7da:	40a7853b          	subw	a0,a5,a0
     7de:	6422                	ld	s0,8(sp)
     7e0:	0141                	addi	sp,sp,16
     7e2:	8082                	ret

00000000000007e4 <strlen>:

uint strlen(const char *s) {
     7e4:	1141                	addi	sp,sp,-16
     7e6:	e422                	sd	s0,8(sp)
     7e8:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
     7ea:	00054783          	lbu	a5,0(a0)
     7ee:	cf91                	beqz	a5,80a <strlen+0x26>
     7f0:	0505                	addi	a0,a0,1
     7f2:	87aa                	mv	a5,a0
     7f4:	86be                	mv	a3,a5
     7f6:	0785                	addi	a5,a5,1
     7f8:	fff7c703          	lbu	a4,-1(a5)
     7fc:	ff65                	bnez	a4,7f4 <strlen+0x10>
     7fe:	40a6853b          	subw	a0,a3,a0
     802:	2505                	addiw	a0,a0,1
  return n;
}
     804:	6422                	ld	s0,8(sp)
     806:	0141                	addi	sp,sp,16
     808:	8082                	ret
  for (n = 0; s[n]; n++);
     80a:	4501                	li	a0,0
     80c:	bfe5                	j	804 <strlen+0x20>

000000000000080e <memset>:

void *memset(void *dst, int c, uint n) {
     80e:	1141                	addi	sp,sp,-16
     810:	e422                	sd	s0,8(sp)
     812:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     814:	ca19                	beqz	a2,82a <memset+0x1c>
     816:	87aa                	mv	a5,a0
     818:	1602                	slli	a2,a2,0x20
     81a:	9201                	srli	a2,a2,0x20
     81c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     820:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     824:	0785                	addi	a5,a5,1
     826:	fee79de3          	bne	a5,a4,820 <memset+0x12>
  }
  return dst;
}
     82a:	6422                	ld	s0,8(sp)
     82c:	0141                	addi	sp,sp,16
     82e:	8082                	ret

0000000000000830 <strchr>:

char *strchr(const char *s, char c) {
     830:	1141                	addi	sp,sp,-16
     832:	e422                	sd	s0,8(sp)
     834:	0800                	addi	s0,sp,16
  for (; *s; s++)
     836:	00054783          	lbu	a5,0(a0)
     83a:	cb99                	beqz	a5,850 <strchr+0x20>
    if (*s == c) return (char *)s;
     83c:	00f58763          	beq	a1,a5,84a <strchr+0x1a>
  for (; *s; s++)
     840:	0505                	addi	a0,a0,1
     842:	00054783          	lbu	a5,0(a0)
     846:	fbfd                	bnez	a5,83c <strchr+0xc>
  return 0;
     848:	4501                	li	a0,0
}
     84a:	6422                	ld	s0,8(sp)
     84c:	0141                	addi	sp,sp,16
     84e:	8082                	ret
  return 0;
     850:	4501                	li	a0,0
     852:	bfe5                	j	84a <strchr+0x1a>

0000000000000854 <gets>:

char *gets(char *buf, int max) {
     854:	711d                	addi	sp,sp,-96
     856:	ec86                	sd	ra,88(sp)
     858:	e8a2                	sd	s0,80(sp)
     85a:	e4a6                	sd	s1,72(sp)
     85c:	e0ca                	sd	s2,64(sp)
     85e:	fc4e                	sd	s3,56(sp)
     860:	f852                	sd	s4,48(sp)
     862:	f456                	sd	s5,40(sp)
     864:	f05a                	sd	s6,32(sp)
     866:	ec5e                	sd	s7,24(sp)
     868:	1080                	addi	s0,sp,96
     86a:	8baa                	mv	s7,a0
     86c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     86e:	892a                	mv	s2,a0
     870:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
     872:	4aa9                	li	s5,10
     874:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
     876:	89a6                	mv	s3,s1
     878:	2485                	addiw	s1,s1,1
     87a:	0344d863          	bge	s1,s4,8aa <gets+0x56>
    cc = read(0, &c, 1);
     87e:	4605                	li	a2,1
     880:	faf40593          	addi	a1,s0,-81
     884:	4501                	li	a0,0
     886:	00000097          	auipc	ra,0x0
     88a:	214080e7          	jalr	532(ra) # a9a <read>
    if (cc < 1) break;
     88e:	00a05e63          	blez	a0,8aa <gets+0x56>
    buf[i++] = c;
     892:	faf44783          	lbu	a5,-81(s0)
     896:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
     89a:	01578763          	beq	a5,s5,8a8 <gets+0x54>
     89e:	0905                	addi	s2,s2,1
     8a0:	fd679be3          	bne	a5,s6,876 <gets+0x22>
    buf[i++] = c;
     8a4:	89a6                	mv	s3,s1
     8a6:	a011                	j	8aa <gets+0x56>
     8a8:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
     8aa:	99de                	add	s3,s3,s7
     8ac:	00098023          	sb	zero,0(s3)
  return buf;
}
     8b0:	855e                	mv	a0,s7
     8b2:	60e6                	ld	ra,88(sp)
     8b4:	6446                	ld	s0,80(sp)
     8b6:	64a6                	ld	s1,72(sp)
     8b8:	6906                	ld	s2,64(sp)
     8ba:	79e2                	ld	s3,56(sp)
     8bc:	7a42                	ld	s4,48(sp)
     8be:	7aa2                	ld	s5,40(sp)
     8c0:	7b02                	ld	s6,32(sp)
     8c2:	6be2                	ld	s7,24(sp)
     8c4:	6125                	addi	sp,sp,96
     8c6:	8082                	ret

00000000000008c8 <stat>:

int stat(const char *n, struct stat *st) {
     8c8:	1101                	addi	sp,sp,-32
     8ca:	ec06                	sd	ra,24(sp)
     8cc:	e822                	sd	s0,16(sp)
     8ce:	e04a                	sd	s2,0(sp)
     8d0:	1000                	addi	s0,sp,32
     8d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     8d4:	4581                	li	a1,0
     8d6:	00000097          	auipc	ra,0x0
     8da:	1ec080e7          	jalr	492(ra) # ac2 <open>
  if (fd < 0) return -1;
     8de:	02054663          	bltz	a0,90a <stat+0x42>
     8e2:	e426                	sd	s1,8(sp)
     8e4:	84aa                	mv	s1,a0
  r = fstat(fd, st);
     8e6:	85ca                	mv	a1,s2
     8e8:	00000097          	auipc	ra,0x0
     8ec:	1f2080e7          	jalr	498(ra) # ada <fstat>
     8f0:	892a                	mv	s2,a0
  close(fd);
     8f2:	8526                	mv	a0,s1
     8f4:	00000097          	auipc	ra,0x0
     8f8:	1b6080e7          	jalr	438(ra) # aaa <close>
  return r;
     8fc:	64a2                	ld	s1,8(sp)
}
     8fe:	854a                	mv	a0,s2
     900:	60e2                	ld	ra,24(sp)
     902:	6442                	ld	s0,16(sp)
     904:	6902                	ld	s2,0(sp)
     906:	6105                	addi	sp,sp,32
     908:	8082                	ret
  if (fd < 0) return -1;
     90a:	597d                	li	s2,-1
     90c:	bfcd                	j	8fe <stat+0x36>

000000000000090e <atoi>:

int atoi(const char *s) {
     90e:	1141                	addi	sp,sp,-16
     910:	e422                	sd	s0,8(sp)
     912:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
     914:	00054683          	lbu	a3,0(a0)
     918:	fd06879b          	addiw	a5,a3,-48
     91c:	0ff7f793          	zext.b	a5,a5
     920:	4625                	li	a2,9
     922:	02f66863          	bltu	a2,a5,952 <atoi+0x44>
     926:	872a                	mv	a4,a0
  n = 0;
     928:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
     92a:	0705                	addi	a4,a4,1
     92c:	0025179b          	slliw	a5,a0,0x2
     930:	9fa9                	addw	a5,a5,a0
     932:	0017979b          	slliw	a5,a5,0x1
     936:	9fb5                	addw	a5,a5,a3
     938:	fd07851b          	addiw	a0,a5,-48
     93c:	00074683          	lbu	a3,0(a4)
     940:	fd06879b          	addiw	a5,a3,-48
     944:	0ff7f793          	zext.b	a5,a5
     948:	fef671e3          	bgeu	a2,a5,92a <atoi+0x1c>
  return n;
}
     94c:	6422                	ld	s0,8(sp)
     94e:	0141                	addi	sp,sp,16
     950:	8082                	ret
  n = 0;
     952:	4501                	li	a0,0
     954:	bfe5                	j	94c <atoi+0x3e>

0000000000000956 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
     956:	1141                	addi	sp,sp,-16
     958:	e422                	sd	s0,8(sp)
     95a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     95c:	02b57463          	bgeu	a0,a1,984 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
     960:	00c05f63          	blez	a2,97e <memmove+0x28>
     964:	1602                	slli	a2,a2,0x20
     966:	9201                	srli	a2,a2,0x20
     968:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     96c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
     96e:	0585                	addi	a1,a1,1
     970:	0705                	addi	a4,a4,1
     972:	fff5c683          	lbu	a3,-1(a1)
     976:	fed70fa3          	sb	a3,-1(a4)
     97a:	fef71ae3          	bne	a4,a5,96e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
     97e:	6422                	ld	s0,8(sp)
     980:	0141                	addi	sp,sp,16
     982:	8082                	ret
    dst += n;
     984:	00c50733          	add	a4,a0,a2
    src += n;
     988:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
     98a:	fec05ae3          	blez	a2,97e <memmove+0x28>
     98e:	fff6079b          	addiw	a5,a2,-1
     992:	1782                	slli	a5,a5,0x20
     994:	9381                	srli	a5,a5,0x20
     996:	fff7c793          	not	a5,a5
     99a:	97ba                	add	a5,a5,a4
     99c:	15fd                	addi	a1,a1,-1
     99e:	177d                	addi	a4,a4,-1
     9a0:	0005c683          	lbu	a3,0(a1)
     9a4:	00d70023          	sb	a3,0(a4)
     9a8:	fee79ae3          	bne	a5,a4,99c <memmove+0x46>
     9ac:	bfc9                	j	97e <memmove+0x28>

00000000000009ae <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
     9ae:	1141                	addi	sp,sp,-16
     9b0:	e422                	sd	s0,8(sp)
     9b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     9b4:	ca05                	beqz	a2,9e4 <memcmp+0x36>
     9b6:	fff6069b          	addiw	a3,a2,-1
     9ba:	1682                	slli	a3,a3,0x20
     9bc:	9281                	srli	a3,a3,0x20
     9be:	0685                	addi	a3,a3,1
     9c0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     9c2:	00054783          	lbu	a5,0(a0)
     9c6:	0005c703          	lbu	a4,0(a1)
     9ca:	00e79863          	bne	a5,a4,9da <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     9ce:	0505                	addi	a0,a0,1
    p2++;
     9d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     9d2:	fed518e3          	bne	a0,a3,9c2 <memcmp+0x14>
  }
  return 0;
     9d6:	4501                	li	a0,0
     9d8:	a019                	j	9de <memcmp+0x30>
      return *p1 - *p2;
     9da:	40e7853b          	subw	a0,a5,a4
}
     9de:	6422                	ld	s0,8(sp)
     9e0:	0141                	addi	sp,sp,16
     9e2:	8082                	ret
  return 0;
     9e4:	4501                	li	a0,0
     9e6:	bfe5                	j	9de <memcmp+0x30>

00000000000009e8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     9f0:	00000097          	auipc	ra,0x0
     9f4:	f66080e7          	jalr	-154(ra) # 956 <memmove>
}
     9f8:	60a2                	ld	ra,8(sp)
     9fa:	6402                	ld	s0,0(sp)
     9fc:	0141                	addi	sp,sp,16
     9fe:	8082                	ret

0000000000000a00 <strcat>:

char *strcat(char *dst, const char *src) {
     a00:	1141                	addi	sp,sp,-16
     a02:	e422                	sd	s0,8(sp)
     a04:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
     a06:	00054783          	lbu	a5,0(a0)
     a0a:	c385                	beqz	a5,a2a <strcat+0x2a>
  char *p = dst;
     a0c:	87aa                	mv	a5,a0
  while (*p) p++;
     a0e:	0785                	addi	a5,a5,1
     a10:	0007c703          	lbu	a4,0(a5)
     a14:	ff6d                	bnez	a4,a0e <strcat+0xe>
  while ((*p++ = *src++));
     a16:	0585                	addi	a1,a1,1
     a18:	0785                	addi	a5,a5,1
     a1a:	fff5c703          	lbu	a4,-1(a1)
     a1e:	fee78fa3          	sb	a4,-1(a5)
     a22:	fb75                	bnez	a4,a16 <strcat+0x16>
  return dst;
}
     a24:	6422                	ld	s0,8(sp)
     a26:	0141                	addi	sp,sp,16
     a28:	8082                	ret
  char *p = dst;
     a2a:	87aa                	mv	a5,a0
     a2c:	b7ed                	j	a16 <strcat+0x16>

0000000000000a2e <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
     a2e:	1141                	addi	sp,sp,-16
     a30:	e422                	sd	s0,8(sp)
     a32:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
     a34:	0005c783          	lbu	a5,0(a1)
     a38:	cf95                	beqz	a5,a74 <strstr+0x46>

  for (; *haystack; haystack++) {
     a3a:	00054783          	lbu	a5,0(a0)
     a3e:	eb91                	bnez	a5,a52 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
     a40:	4501                	li	a0,0
     a42:	a80d                	j	a74 <strstr+0x46>
    if (!*n) return (char *)haystack;
     a44:	0007c783          	lbu	a5,0(a5)
     a48:	c795                	beqz	a5,a74 <strstr+0x46>
  for (; *haystack; haystack++) {
     a4a:	0505                	addi	a0,a0,1
     a4c:	00054783          	lbu	a5,0(a0)
     a50:	c38d                	beqz	a5,a72 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
     a52:	00054703          	lbu	a4,0(a0)
    n = needle;
     a56:	87ae                	mv	a5,a1
    h = haystack;
     a58:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
     a5a:	db65                	beqz	a4,a4a <strstr+0x1c>
     a5c:	0007c683          	lbu	a3,0(a5)
     a60:	ca91                	beqz	a3,a74 <strstr+0x46>
     a62:	fee691e3          	bne	a3,a4,a44 <strstr+0x16>
      h++;
     a66:	0605                	addi	a2,a2,1
      n++;
     a68:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
     a6a:	00064703          	lbu	a4,0(a2)
     a6e:	f77d                	bnez	a4,a5c <strstr+0x2e>
     a70:	bfd1                	j	a44 <strstr+0x16>
  return 0;
     a72:	4501                	li	a0,0
}
     a74:	6422                	ld	s0,8(sp)
     a76:	0141                	addi	sp,sp,16
     a78:	8082                	ret

0000000000000a7a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     a7a:	4885                	li	a7,1
 ecall
     a7c:	00000073          	ecall
 ret
     a80:	8082                	ret

0000000000000a82 <exit>:
.global exit
exit:
 li a7, SYS_exit
     a82:	4889                	li	a7,2
 ecall
     a84:	00000073          	ecall
 ret
     a88:	8082                	ret

0000000000000a8a <wait>:
.global wait
wait:
 li a7, SYS_wait
     a8a:	488d                	li	a7,3
 ecall
     a8c:	00000073          	ecall
 ret
     a90:	8082                	ret

0000000000000a92 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     a92:	4891                	li	a7,4
 ecall
     a94:	00000073          	ecall
 ret
     a98:	8082                	ret

0000000000000a9a <read>:
.global read
read:
 li a7, SYS_read
     a9a:	4895                	li	a7,5
 ecall
     a9c:	00000073          	ecall
 ret
     aa0:	8082                	ret

0000000000000aa2 <write>:
.global write
write:
 li a7, SYS_write
     aa2:	48c1                	li	a7,16
 ecall
     aa4:	00000073          	ecall
 ret
     aa8:	8082                	ret

0000000000000aaa <close>:
.global close
close:
 li a7, SYS_close
     aaa:	48d5                	li	a7,21
 ecall
     aac:	00000073          	ecall
 ret
     ab0:	8082                	ret

0000000000000ab2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ab2:	4899                	li	a7,6
 ecall
     ab4:	00000073          	ecall
 ret
     ab8:	8082                	ret

0000000000000aba <exec>:
.global exec
exec:
 li a7, SYS_exec
     aba:	489d                	li	a7,7
 ecall
     abc:	00000073          	ecall
 ret
     ac0:	8082                	ret

0000000000000ac2 <open>:
.global open
open:
 li a7, SYS_open
     ac2:	48bd                	li	a7,15
 ecall
     ac4:	00000073          	ecall
 ret
     ac8:	8082                	ret

0000000000000aca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     aca:	48c5                	li	a7,17
 ecall
     acc:	00000073          	ecall
 ret
     ad0:	8082                	ret

0000000000000ad2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ad2:	48c9                	li	a7,18
 ecall
     ad4:	00000073          	ecall
 ret
     ad8:	8082                	ret

0000000000000ada <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ada:	48a1                	li	a7,8
 ecall
     adc:	00000073          	ecall
 ret
     ae0:	8082                	ret

0000000000000ae2 <link>:
.global link
link:
 li a7, SYS_link
     ae2:	48cd                	li	a7,19
 ecall
     ae4:	00000073          	ecall
 ret
     ae8:	8082                	ret

0000000000000aea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     aea:	48d1                	li	a7,20
 ecall
     aec:	00000073          	ecall
 ret
     af0:	8082                	ret

0000000000000af2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     af2:	48a5                	li	a7,9
 ecall
     af4:	00000073          	ecall
 ret
     af8:	8082                	ret

0000000000000afa <dup>:
.global dup
dup:
 li a7, SYS_dup
     afa:	48a9                	li	a7,10
 ecall
     afc:	00000073          	ecall
 ret
     b00:	8082                	ret

0000000000000b02 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b02:	48ad                	li	a7,11
 ecall
     b04:	00000073          	ecall
 ret
     b08:	8082                	ret

0000000000000b0a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b0a:	48b1                	li	a7,12
 ecall
     b0c:	00000073          	ecall
 ret
     b10:	8082                	ret

0000000000000b12 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b12:	48b5                	li	a7,13
 ecall
     b14:	00000073          	ecall
 ret
     b18:	8082                	ret

0000000000000b1a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b1a:	48b9                	li	a7,14
 ecall
     b1c:	00000073          	ecall
 ret
     b20:	8082                	ret

0000000000000b22 <reg>:
.global reg
reg:
 li a7, SYS_reg
     b22:	48d9                	li	a7,22
 ecall
     b24:	00000073          	ecall
 ret
     b28:	8082                	ret

0000000000000b2a <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
     b2a:	1101                	addi	sp,sp,-32
     b2c:	ec06                	sd	ra,24(sp)
     b2e:	e822                	sd	s0,16(sp)
     b30:	1000                	addi	s0,sp,32
     b32:	feb407a3          	sb	a1,-17(s0)
     b36:	4605                	li	a2,1
     b38:	fef40593          	addi	a1,s0,-17
     b3c:	00000097          	auipc	ra,0x0
     b40:	f66080e7          	jalr	-154(ra) # aa2 <write>
     b44:	60e2                	ld	ra,24(sp)
     b46:	6442                	ld	s0,16(sp)
     b48:	6105                	addi	sp,sp,32
     b4a:	8082                	ret

0000000000000b4c <printint>:

static void printint(int fd, int xx, int base, int sgn) {
     b4c:	7139                	addi	sp,sp,-64
     b4e:	fc06                	sd	ra,56(sp)
     b50:	f822                	sd	s0,48(sp)
     b52:	f426                	sd	s1,40(sp)
     b54:	0080                	addi	s0,sp,64
     b56:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
     b58:	c299                	beqz	a3,b5e <printint+0x12>
     b5a:	0805cb63          	bltz	a1,bf0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     b5e:	2581                	sext.w	a1,a1
  neg = 0;
     b60:	4881                	li	a7,0
     b62:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     b66:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
     b68:	2601                	sext.w	a2,a2
     b6a:	00001517          	auipc	a0,0x1
     b6e:	9de50513          	addi	a0,a0,-1570 # 1548 <digits>
     b72:	883a                	mv	a6,a4
     b74:	2705                	addiw	a4,a4,1
     b76:	02c5f7bb          	remuw	a5,a1,a2
     b7a:	1782                	slli	a5,a5,0x20
     b7c:	9381                	srli	a5,a5,0x20
     b7e:	97aa                	add	a5,a5,a0
     b80:	0007c783          	lbu	a5,0(a5)
     b84:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
     b88:	0005879b          	sext.w	a5,a1
     b8c:	02c5d5bb          	divuw	a1,a1,a2
     b90:	0685                	addi	a3,a3,1
     b92:	fec7f0e3          	bgeu	a5,a2,b72 <printint+0x26>
  if (neg) buf[i++] = '-';
     b96:	00088c63          	beqz	a7,bae <printint+0x62>
     b9a:	fd070793          	addi	a5,a4,-48
     b9e:	00878733          	add	a4,a5,s0
     ba2:	02d00793          	li	a5,45
     ba6:	fef70823          	sb	a5,-16(a4)
     baa:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
     bae:	02e05c63          	blez	a4,be6 <printint+0x9a>
     bb2:	f04a                	sd	s2,32(sp)
     bb4:	ec4e                	sd	s3,24(sp)
     bb6:	fc040793          	addi	a5,s0,-64
     bba:	00e78933          	add	s2,a5,a4
     bbe:	fff78993          	addi	s3,a5,-1
     bc2:	99ba                	add	s3,s3,a4
     bc4:	377d                	addiw	a4,a4,-1
     bc6:	1702                	slli	a4,a4,0x20
     bc8:	9301                	srli	a4,a4,0x20
     bca:	40e989b3          	sub	s3,s3,a4
     bce:	fff94583          	lbu	a1,-1(s2)
     bd2:	8526                	mv	a0,s1
     bd4:	00000097          	auipc	ra,0x0
     bd8:	f56080e7          	jalr	-170(ra) # b2a <putc>
     bdc:	197d                	addi	s2,s2,-1
     bde:	ff3918e3          	bne	s2,s3,bce <printint+0x82>
     be2:	7902                	ld	s2,32(sp)
     be4:	69e2                	ld	s3,24(sp)
}
     be6:	70e2                	ld	ra,56(sp)
     be8:	7442                	ld	s0,48(sp)
     bea:	74a2                	ld	s1,40(sp)
     bec:	6121                	addi	sp,sp,64
     bee:	8082                	ret
    x = -xx;
     bf0:	40b005bb          	negw	a1,a1
    neg = 1;
     bf4:	4885                	li	a7,1
    x = -xx;
     bf6:	b7b5                	j	b62 <printint+0x16>

0000000000000bf8 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
     bf8:	715d                	addi	sp,sp,-80
     bfa:	e486                	sd	ra,72(sp)
     bfc:	e0a2                	sd	s0,64(sp)
     bfe:	f84a                	sd	s2,48(sp)
     c00:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     c02:	0005c903          	lbu	s2,0(a1)
     c06:	1a090a63          	beqz	s2,dba <vprintf+0x1c2>
     c0a:	fc26                	sd	s1,56(sp)
     c0c:	f44e                	sd	s3,40(sp)
     c0e:	f052                	sd	s4,32(sp)
     c10:	ec56                	sd	s5,24(sp)
     c12:	e85a                	sd	s6,16(sp)
     c14:	e45e                	sd	s7,8(sp)
     c16:	8aaa                	mv	s5,a0
     c18:	8bb2                	mv	s7,a2
     c1a:	00158493          	addi	s1,a1,1
  state = 0;
     c1e:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
     c20:	02500a13          	li	s4,37
     c24:	4b55                	li	s6,21
     c26:	a839                	j	c44 <vprintf+0x4c>
        putc(fd, c);
     c28:	85ca                	mv	a1,s2
     c2a:	8556                	mv	a0,s5
     c2c:	00000097          	auipc	ra,0x0
     c30:	efe080e7          	jalr	-258(ra) # b2a <putc>
     c34:	a019                	j	c3a <vprintf+0x42>
    } else if (state == '%') {
     c36:	01498d63          	beq	s3,s4,c50 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
     c3a:	0485                	addi	s1,s1,1
     c3c:	fff4c903          	lbu	s2,-1(s1)
     c40:	16090763          	beqz	s2,dae <vprintf+0x1b6>
    if (state == 0) {
     c44:	fe0999e3          	bnez	s3,c36 <vprintf+0x3e>
      if (c == '%') {
     c48:	ff4910e3          	bne	s2,s4,c28 <vprintf+0x30>
        state = '%';
     c4c:	89d2                	mv	s3,s4
     c4e:	b7f5                	j	c3a <vprintf+0x42>
      if (c == 'd') {
     c50:	13490463          	beq	s2,s4,d78 <vprintf+0x180>
     c54:	f9d9079b          	addiw	a5,s2,-99
     c58:	0ff7f793          	zext.b	a5,a5
     c5c:	12fb6763          	bltu	s6,a5,d8a <vprintf+0x192>
     c60:	f9d9079b          	addiw	a5,s2,-99
     c64:	0ff7f713          	zext.b	a4,a5
     c68:	12eb6163          	bltu	s6,a4,d8a <vprintf+0x192>
     c6c:	00271793          	slli	a5,a4,0x2
     c70:	00001717          	auipc	a4,0x1
     c74:	88070713          	addi	a4,a4,-1920 # 14f0 <loop+0x4f2>
     c78:	97ba                	add	a5,a5,a4
     c7a:	439c                	lw	a5,0(a5)
     c7c:	97ba                	add	a5,a5,a4
     c7e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     c80:	008b8913          	addi	s2,s7,8
     c84:	4685                	li	a3,1
     c86:	4629                	li	a2,10
     c88:	000ba583          	lw	a1,0(s7)
     c8c:	8556                	mv	a0,s5
     c8e:	00000097          	auipc	ra,0x0
     c92:	ebe080e7          	jalr	-322(ra) # b4c <printint>
     c96:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     c98:	4981                	li	s3,0
     c9a:	b745                	j	c3a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c9c:	008b8913          	addi	s2,s7,8
     ca0:	4681                	li	a3,0
     ca2:	4629                	li	a2,10
     ca4:	000ba583          	lw	a1,0(s7)
     ca8:	8556                	mv	a0,s5
     caa:	00000097          	auipc	ra,0x0
     cae:	ea2080e7          	jalr	-350(ra) # b4c <printint>
     cb2:	8bca                	mv	s7,s2
      state = 0;
     cb4:	4981                	li	s3,0
     cb6:	b751                	j	c3a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     cb8:	008b8913          	addi	s2,s7,8
     cbc:	4681                	li	a3,0
     cbe:	4641                	li	a2,16
     cc0:	000ba583          	lw	a1,0(s7)
     cc4:	8556                	mv	a0,s5
     cc6:	00000097          	auipc	ra,0x0
     cca:	e86080e7          	jalr	-378(ra) # b4c <printint>
     cce:	8bca                	mv	s7,s2
      state = 0;
     cd0:	4981                	li	s3,0
     cd2:	b7a5                	j	c3a <vprintf+0x42>
     cd4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     cd6:	008b8c13          	addi	s8,s7,8
     cda:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     cde:	03000593          	li	a1,48
     ce2:	8556                	mv	a0,s5
     ce4:	00000097          	auipc	ra,0x0
     ce8:	e46080e7          	jalr	-442(ra) # b2a <putc>
  putc(fd, 'x');
     cec:	07800593          	li	a1,120
     cf0:	8556                	mv	a0,s5
     cf2:	00000097          	auipc	ra,0x0
     cf6:	e38080e7          	jalr	-456(ra) # b2a <putc>
     cfa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     cfc:	00001b97          	auipc	s7,0x1
     d00:	84cb8b93          	addi	s7,s7,-1972 # 1548 <digits>
     d04:	03c9d793          	srli	a5,s3,0x3c
     d08:	97de                	add	a5,a5,s7
     d0a:	0007c583          	lbu	a1,0(a5)
     d0e:	8556                	mv	a0,s5
     d10:	00000097          	auipc	ra,0x0
     d14:	e1a080e7          	jalr	-486(ra) # b2a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d18:	0992                	slli	s3,s3,0x4
     d1a:	397d                	addiw	s2,s2,-1
     d1c:	fe0914e3          	bnez	s2,d04 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     d20:	8be2                	mv	s7,s8
      state = 0;
     d22:	4981                	li	s3,0
     d24:	6c02                	ld	s8,0(sp)
     d26:	bf11                	j	c3a <vprintf+0x42>
        s = va_arg(ap, char *);
     d28:	008b8993          	addi	s3,s7,8
     d2c:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
     d30:	02090163          	beqz	s2,d52 <vprintf+0x15a>
        while (*s != 0) {
     d34:	00094583          	lbu	a1,0(s2)
     d38:	c9a5                	beqz	a1,da8 <vprintf+0x1b0>
          putc(fd, *s);
     d3a:	8556                	mv	a0,s5
     d3c:	00000097          	auipc	ra,0x0
     d40:	dee080e7          	jalr	-530(ra) # b2a <putc>
          s++;
     d44:	0905                	addi	s2,s2,1
        while (*s != 0) {
     d46:	00094583          	lbu	a1,0(s2)
     d4a:	f9e5                	bnez	a1,d3a <vprintf+0x142>
        s = va_arg(ap, char *);
     d4c:	8bce                	mv	s7,s3
      state = 0;
     d4e:	4981                	li	s3,0
     d50:	b5ed                	j	c3a <vprintf+0x42>
        if (s == 0) s = "(null)";
     d52:	00000917          	auipc	s2,0x0
     d56:	74e90913          	addi	s2,s2,1870 # 14a0 <loop+0x4a2>
        while (*s != 0) {
     d5a:	02800593          	li	a1,40
     d5e:	bff1                	j	d3a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     d60:	008b8913          	addi	s2,s7,8
     d64:	000bc583          	lbu	a1,0(s7)
     d68:	8556                	mv	a0,s5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	dc0080e7          	jalr	-576(ra) # b2a <putc>
     d72:	8bca                	mv	s7,s2
      state = 0;
     d74:	4981                	li	s3,0
     d76:	b5d1                	j	c3a <vprintf+0x42>
        putc(fd, c);
     d78:	02500593          	li	a1,37
     d7c:	8556                	mv	a0,s5
     d7e:	00000097          	auipc	ra,0x0
     d82:	dac080e7          	jalr	-596(ra) # b2a <putc>
      state = 0;
     d86:	4981                	li	s3,0
     d88:	bd4d                	j	c3a <vprintf+0x42>
        putc(fd, '%');
     d8a:	02500593          	li	a1,37
     d8e:	8556                	mv	a0,s5
     d90:	00000097          	auipc	ra,0x0
     d94:	d9a080e7          	jalr	-614(ra) # b2a <putc>
        putc(fd, c);
     d98:	85ca                	mv	a1,s2
     d9a:	8556                	mv	a0,s5
     d9c:	00000097          	auipc	ra,0x0
     da0:	d8e080e7          	jalr	-626(ra) # b2a <putc>
      state = 0;
     da4:	4981                	li	s3,0
     da6:	bd51                	j	c3a <vprintf+0x42>
        s = va_arg(ap, char *);
     da8:	8bce                	mv	s7,s3
      state = 0;
     daa:	4981                	li	s3,0
     dac:	b579                	j	c3a <vprintf+0x42>
     dae:	74e2                	ld	s1,56(sp)
     db0:	79a2                	ld	s3,40(sp)
     db2:	7a02                	ld	s4,32(sp)
     db4:	6ae2                	ld	s5,24(sp)
     db6:	6b42                	ld	s6,16(sp)
     db8:	6ba2                	ld	s7,8(sp)
    }
  }
}
     dba:	60a6                	ld	ra,72(sp)
     dbc:	6406                	ld	s0,64(sp)
     dbe:	7942                	ld	s2,48(sp)
     dc0:	6161                	addi	sp,sp,80
     dc2:	8082                	ret

0000000000000dc4 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
     dc4:	715d                	addi	sp,sp,-80
     dc6:	ec06                	sd	ra,24(sp)
     dc8:	e822                	sd	s0,16(sp)
     dca:	1000                	addi	s0,sp,32
     dcc:	e010                	sd	a2,0(s0)
     dce:	e414                	sd	a3,8(s0)
     dd0:	e818                	sd	a4,16(s0)
     dd2:	ec1c                	sd	a5,24(s0)
     dd4:	03043023          	sd	a6,32(s0)
     dd8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ddc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     de0:	8622                	mv	a2,s0
     de2:	00000097          	auipc	ra,0x0
     de6:	e16080e7          	jalr	-490(ra) # bf8 <vprintf>
}
     dea:	60e2                	ld	ra,24(sp)
     dec:	6442                	ld	s0,16(sp)
     dee:	6161                	addi	sp,sp,80
     df0:	8082                	ret

0000000000000df2 <printf>:

void printf(const char *fmt, ...) {
     df2:	711d                	addi	sp,sp,-96
     df4:	ec06                	sd	ra,24(sp)
     df6:	e822                	sd	s0,16(sp)
     df8:	1000                	addi	s0,sp,32
     dfa:	e40c                	sd	a1,8(s0)
     dfc:	e810                	sd	a2,16(s0)
     dfe:	ec14                	sd	a3,24(s0)
     e00:	f018                	sd	a4,32(s0)
     e02:	f41c                	sd	a5,40(s0)
     e04:	03043823          	sd	a6,48(s0)
     e08:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e0c:	00840613          	addi	a2,s0,8
     e10:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e14:	85aa                	mv	a1,a0
     e16:	4505                	li	a0,1
     e18:	00000097          	auipc	ra,0x0
     e1c:	de0080e7          	jalr	-544(ra) # bf8 <vprintf>
}
     e20:	60e2                	ld	ra,24(sp)
     e22:	6442                	ld	s0,16(sp)
     e24:	6125                	addi	sp,sp,96
     e26:	8082                	ret

0000000000000e28 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
     e28:	1141                	addi	sp,sp,-16
     e2a:	e422                	sd	s0,8(sp)
     e2c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
     e2e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e32:	00001797          	auipc	a5,0x1
     e36:	1ce7b783          	ld	a5,462(a5) # 2000 <freep>
     e3a:	a02d                	j	e64 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
     e3c:	4618                	lw	a4,8(a2)
     e3e:	9f2d                	addw	a4,a4,a1
     e40:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e44:	6398                	ld	a4,0(a5)
     e46:	6310                	ld	a2,0(a4)
     e48:	a83d                	j	e86 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
     e4a:	ff852703          	lw	a4,-8(a0)
     e4e:	9f31                	addw	a4,a4,a2
     e50:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e52:	ff053683          	ld	a3,-16(a0)
     e56:	a091                	j	e9a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
     e58:	6398                	ld	a4,0(a5)
     e5a:	00e7e463          	bltu	a5,a4,e62 <free+0x3a>
     e5e:	00e6ea63          	bltu	a3,a4,e72 <free+0x4a>
void free(void *ap) {
     e62:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e64:	fed7fae3          	bgeu	a5,a3,e58 <free+0x30>
     e68:	6398                	ld	a4,0(a5)
     e6a:	00e6e463          	bltu	a3,a4,e72 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
     e6e:	fee7eae3          	bltu	a5,a4,e62 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
     e72:	ff852583          	lw	a1,-8(a0)
     e76:	6390                	ld	a2,0(a5)
     e78:	02059813          	slli	a6,a1,0x20
     e7c:	01c85713          	srli	a4,a6,0x1c
     e80:	9736                	add	a4,a4,a3
     e82:	fae60de3          	beq	a2,a4,e3c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     e86:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
     e8a:	4790                	lw	a2,8(a5)
     e8c:	02061593          	slli	a1,a2,0x20
     e90:	01c5d713          	srli	a4,a1,0x1c
     e94:	973e                	add	a4,a4,a5
     e96:	fae68ae3          	beq	a3,a4,e4a <free+0x22>
    p->s.ptr = bp->s.ptr;
     e9a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     e9c:	00001717          	auipc	a4,0x1
     ea0:	16f73223          	sd	a5,356(a4) # 2000 <freep>
}
     ea4:	6422                	ld	s0,8(sp)
     ea6:	0141                	addi	sp,sp,16
     ea8:	8082                	ret

0000000000000eaa <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
     eaa:	7139                	addi	sp,sp,-64
     eac:	fc06                	sd	ra,56(sp)
     eae:	f822                	sd	s0,48(sp)
     eb0:	f426                	sd	s1,40(sp)
     eb2:	ec4e                	sd	s3,24(sp)
     eb4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     eb6:	02051493          	slli	s1,a0,0x20
     eba:	9081                	srli	s1,s1,0x20
     ebc:	04bd                	addi	s1,s1,15
     ebe:	8091                	srli	s1,s1,0x4
     ec0:	0014899b          	addiw	s3,s1,1
     ec4:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
     ec6:	00001517          	auipc	a0,0x1
     eca:	13a53503          	ld	a0,314(a0) # 2000 <freep>
     ece:	c915                	beqz	a0,f02 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
     ed0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
     ed2:	4798                	lw	a4,8(a5)
     ed4:	08977e63          	bgeu	a4,s1,f70 <malloc+0xc6>
     ed8:	f04a                	sd	s2,32(sp)
     eda:	e852                	sd	s4,16(sp)
     edc:	e456                	sd	s5,8(sp)
     ede:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
     ee0:	8a4e                	mv	s4,s3
     ee2:	0009871b          	sext.w	a4,s3
     ee6:	6685                	lui	a3,0x1
     ee8:	00d77363          	bgeu	a4,a3,eee <malloc+0x44>
     eec:	6a05                	lui	s4,0x1
     eee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     ef2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
     ef6:	00001917          	auipc	s2,0x1
     efa:	10a90913          	addi	s2,s2,266 # 2000 <freep>
  if (p == (char *)-1) return 0;
     efe:	5afd                	li	s5,-1
     f00:	a091                	j	f44 <malloc+0x9a>
     f02:	f04a                	sd	s2,32(sp)
     f04:	e852                	sd	s4,16(sp)
     f06:	e456                	sd	s5,8(sp)
     f08:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     f0a:	00001797          	auipc	a5,0x1
     f0e:	30678793          	addi	a5,a5,774 # 2210 <base>
     f12:	00001717          	auipc	a4,0x1
     f16:	0ef73723          	sd	a5,238(a4) # 2000 <freep>
     f1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     f1c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
     f20:	b7c1                	j	ee0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
     f22:	6398                	ld	a4,0(a5)
     f24:	e118                	sd	a4,0(a0)
     f26:	a08d                	j	f88 <malloc+0xde>
  hp->s.size = nu;
     f28:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
     f2c:	0541                	addi	a0,a0,16
     f2e:	00000097          	auipc	ra,0x0
     f32:	efa080e7          	jalr	-262(ra) # e28 <free>
  return freep;
     f36:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
     f3a:	c13d                	beqz	a0,fa0 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
     f3c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
     f3e:	4798                	lw	a4,8(a5)
     f40:	02977463          	bgeu	a4,s1,f68 <malloc+0xbe>
    if (p == freep)
     f44:	00093703          	ld	a4,0(s2)
     f48:	853e                	mv	a0,a5
     f4a:	fef719e3          	bne	a4,a5,f3c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
     f4e:	8552                	mv	a0,s4
     f50:	00000097          	auipc	ra,0x0
     f54:	bba080e7          	jalr	-1094(ra) # b0a <sbrk>
  if (p == (char *)-1) return 0;
     f58:	fd5518e3          	bne	a0,s5,f28 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
     f5c:	4501                	li	a0,0
     f5e:	7902                	ld	s2,32(sp)
     f60:	6a42                	ld	s4,16(sp)
     f62:	6aa2                	ld	s5,8(sp)
     f64:	6b02                	ld	s6,0(sp)
     f66:	a03d                	j	f94 <malloc+0xea>
     f68:	7902                	ld	s2,32(sp)
     f6a:	6a42                	ld	s4,16(sp)
     f6c:	6aa2                	ld	s5,8(sp)
     f6e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
     f70:	fae489e3          	beq	s1,a4,f22 <malloc+0x78>
        p->s.size -= nunits;
     f74:	4137073b          	subw	a4,a4,s3
     f78:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f7a:	02071693          	slli	a3,a4,0x20
     f7e:	01c6d713          	srli	a4,a3,0x1c
     f82:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     f84:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     f88:	00001717          	auipc	a4,0x1
     f8c:	06a73c23          	sd	a0,120(a4) # 2000 <freep>
      return (void *)(p + 1);
     f90:	01078513          	addi	a0,a5,16
  }
}
     f94:	70e2                	ld	ra,56(sp)
     f96:	7442                	ld	s0,48(sp)
     f98:	74a2                	ld	s1,40(sp)
     f9a:	69e2                	ld	s3,24(sp)
     f9c:	6121                	addi	sp,sp,64
     f9e:	8082                	ret
     fa0:	7902                	ld	s2,32(sp)
     fa2:	6a42                	ld	s4,16(sp)
     fa4:	6aa2                	ld	s5,8(sp)
     fa6:	6b02                	ld	s6,0(sp)
     fa8:	b7f5                	j	f94 <malloc+0xea>

0000000000000faa <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
     faa:	4909                	li	s2,2
  li s3, 3
     fac:	498d                	li	s3,3
  li s4, 4
     fae:	4a11                	li	s4,4
  li s5, 5
     fb0:	4a95                	li	s5,5
  li s6, 6
     fb2:	4b19                	li	s6,6
  li s7, 7
     fb4:	4b9d                	li	s7,7
  li s8, 8
     fb6:	4c21                	li	s8,8
  li s9, 9
     fb8:	4ca5                	li	s9,9
  li s10, 10
     fba:	4d29                	li	s10,10
  li s11, 11
     fbc:	4dad                	li	s11,11
  li a7, SYS_write
     fbe:	48c1                	li	a7,16
  ecall
     fc0:	00000073          	ecall
  j loop
     fc4:	a82d                	j	ffe <loop>

0000000000000fc6 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
     fc6:	4911                	li	s2,4
  li s3, 9
     fc8:	49a5                	li	s3,9
  li s4, 16
     fca:	4a41                	li	s4,16
  li s5, 25
     fcc:	4ae5                	li	s5,25
  li s6, 36
     fce:	02400b13          	li	s6,36
  li s7, 49
     fd2:	03100b93          	li	s7,49
  li s8, 64
     fd6:	04000c13          	li	s8,64
  li s9, 81
     fda:	05100c93          	li	s9,81
  li s10, 100
     fde:	06400d13          	li	s10,100
  li s11, 121
     fe2:	07900d93          	li	s11,121
  li a7, SYS_write
     fe6:	48c1                	li	a7,16
  ecall
     fe8:	00000073          	ecall
  j loop
     fec:	a809                	j	ffe <loop>

0000000000000fee <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
     fee:	53900913          	li	s2,1337
  mv a2, a1
     ff2:	862e                	mv	a2,a1
  li a1, 2
     ff4:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
     ff6:	48d9                	li	a7,22
  ecall
     ff8:	00000073          	ecall
#endif
  ret
     ffc:	8082                	ret

0000000000000ffe <loop>:

loop:
  j loop
     ffe:	a001                	j	ffe <loop>
  ret
    1000:	8082                	ret
