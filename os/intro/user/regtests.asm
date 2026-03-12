
user/_regtests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test1>:
}

#ifdef SYS_reg
int reg_test1_asm(int pipefd, char *str, int len);

void test1() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	f84a                	sd	s2,48(sp)
   8:	0880                	addi	s0,sp,80
  printf("test 1 started\n");
   a:	00001517          	auipc	a0,0x1
   e:	d9650513          	addi	a0,a0,-618 # da0 <loop+0x12>
  12:	00001097          	auipc	ra,0x1
  16:	b70080e7          	jalr	-1168(ra) # b82 <printf>
  int pipefd[2];
  pipe(pipefd);
  1a:	fc840513          	addi	a0,s0,-56
  1e:	00001097          	auipc	ra,0x1
  22:	804080e7          	jalr	-2044(ra) # 822 <pipe>
  int child_proc = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	7e4080e7          	jalr	2020(ra) # 80a <fork>
  2e:	892a                	mv	s2,a0
  if (child_proc == 0) {
  30:	ed29                	bnez	a0,8a <test1+0x8a>
    uint64 a = 34381;
  32:	67a1                	lui	a5,0x8
  34:	64d78793          	addi	a5,a5,1613 # 864d <base+0x663d>
  38:	fcf43023          	sd	a5,-64(s0)
    reg_test1_asm(pipefd[1], (char *)(&a), 8);
  3c:	4621                	li	a2,8
  3e:	fc040593          	addi	a1,s0,-64
  42:	fcc42503          	lw	a0,-52(s0)
  46:	00001097          	auipc	ra,0x1
  4a:	cf4080e7          	jalr	-780(ra) # d3a <reg_test1_asm>
        printf("[ERROR] expected: %d, found: %d\n", i, value);
        goto failed;
      }
    }
  }
  printf("[SUCCESS] test 1 passed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	dba50513          	addi	a0,a0,-582 # e08 <loop+0x7a>
  56:	00001097          	auipc	ra,0x1
  5a:	b2c080e7          	jalr	-1236(ra) # b82 <printf>
  success++;
  5e:	00002717          	auipc	a4,0x2
  62:	fa270713          	addi	a4,a4,-94 # 2000 <success>
  66:	431c                	lw	a5,0(a4)
  68:	2785                	addiw	a5,a5,1
  6a:	c31c                	sw	a5,0(a4)
failed:
  if (child_proc > 0) kill(child_proc);
  6c:	09204d63          	bgtz	s2,106 <test1+0x106>
  printf("test 1 finished\n");
  70:	00001517          	auipc	a0,0x1
  74:	db850513          	addi	a0,a0,-584 # e28 <loop+0x9a>
  78:	00001097          	auipc	ra,0x1
  7c:	b0a080e7          	jalr	-1270(ra) # b82 <printf>
}
  80:	60a6                	ld	ra,72(sp)
  82:	6406                	ld	s0,64(sp)
  84:	7942                	ld	s2,48(sp)
  86:	6161                	addi	sp,sp,80
  88:	8082                	ret
  8a:	fc26                	sd	s1,56(sp)
  8c:	f44e                	sd	s3,40(sp)
  8e:	f052                	sd	s4,32(sp)
    read(pipefd[0], &a, 8);
  90:	4621                	li	a2,8
  92:	fb840593          	addi	a1,s0,-72
  96:	fc842503          	lw	a0,-56(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	790080e7          	jalr	1936(ra) # 82a <read>
  a2:	4489                	li	s1,2
    for (int i = 2; i < 12; i++) {
  a4:	4a31                	li	s4,12
  a6:	0004899b          	sext.w	s3,s1
      int error = reg(child_proc, i, &value);
  aa:	fc040613          	addi	a2,s0,-64
  ae:	85ce                	mv	a1,s3
  b0:	854a                	mv	a0,s2
  b2:	00001097          	auipc	ra,0x1
  b6:	800080e7          	jalr	-2048(ra) # 8b2 <reg>
      if (error != 0) {
  ba:	ed01                	bnez	a0,d2 <test1+0xd2>
      if (value != i) {
  bc:	fc043603          	ld	a2,-64(s0)
  c0:	02961663          	bne	a2,s1,ec <test1+0xec>
    for (int i = 2; i < 12; i++) {
  c4:	0485                	addi	s1,s1,1
  c6:	ff4490e3          	bne	s1,s4,a6 <test1+0xa6>
  ca:	74e2                	ld	s1,56(sp)
  cc:	79a2                	ld	s3,40(sp)
  ce:	7a02                	ld	s4,32(sp)
  d0:	bfbd                	j	4e <test1+0x4e>
        printf("[ERROR] reg returned unexpected error %d\n", error);
  d2:	85aa                	mv	a1,a0
  d4:	00001517          	auipc	a0,0x1
  d8:	cdc50513          	addi	a0,a0,-804 # db0 <loop+0x22>
  dc:	00001097          	auipc	ra,0x1
  e0:	aa6080e7          	jalr	-1370(ra) # b82 <printf>
        goto failed;
  e4:	74e2                	ld	s1,56(sp)
  e6:	79a2                	ld	s3,40(sp)
  e8:	7a02                	ld	s4,32(sp)
  ea:	b749                	j	6c <test1+0x6c>
        printf("[ERROR] expected: %d, found: %d\n", i, value);
  ec:	85ce                	mv	a1,s3
  ee:	00001517          	auipc	a0,0x1
  f2:	cf250513          	addi	a0,a0,-782 # de0 <loop+0x52>
  f6:	00001097          	auipc	ra,0x1
  fa:	a8c080e7          	jalr	-1396(ra) # b82 <printf>
        goto failed;
  fe:	74e2                	ld	s1,56(sp)
 100:	79a2                	ld	s3,40(sp)
 102:	7a02                	ld	s4,32(sp)
 104:	b7a5                	j	6c <test1+0x6c>
  if (child_proc > 0) kill(child_proc);
 106:	854a                	mv	a0,s2
 108:	00000097          	auipc	ra,0x0
 10c:	73a080e7          	jalr	1850(ra) # 842 <kill>
 110:	b785                	j	70 <test1+0x70>

0000000000000112 <test2>:

int reg_test2_asm(int pipefd, char *str, int len);

void test2() {
 112:	715d                	addi	sp,sp,-80
 114:	e486                	sd	ra,72(sp)
 116:	e0a2                	sd	s0,64(sp)
 118:	f84a                	sd	s2,48(sp)
 11a:	0880                	addi	s0,sp,80
  printf("test 2 started\n");
 11c:	00001517          	auipc	a0,0x1
 120:	d2450513          	addi	a0,a0,-732 # e40 <loop+0xb2>
 124:	00001097          	auipc	ra,0x1
 128:	a5e080e7          	jalr	-1442(ra) # b82 <printf>
  int pipefd[2];
  pipe(pipefd);
 12c:	fc840513          	addi	a0,s0,-56
 130:	00000097          	auipc	ra,0x0
 134:	6f2080e7          	jalr	1778(ra) # 822 <pipe>
  int child_proc = fork();
 138:	00000097          	auipc	ra,0x0
 13c:	6d2080e7          	jalr	1746(ra) # 80a <fork>
 140:	892a                	mv	s2,a0
  if (child_proc == 0) {
 142:	ed29                	bnez	a0,19c <test2+0x8a>
    uint64 a = 34381;
 144:	67a1                	lui	a5,0x8
 146:	64d78793          	addi	a5,a5,1613 # 864d <base+0x663d>
 14a:	fcf43023          	sd	a5,-64(s0)
    reg_test2_asm(pipefd[1], (char *)(&a), 8);
 14e:	4621                	li	a2,8
 150:	fc040593          	addi	a1,s0,-64
 154:	fcc42503          	lw	a0,-52(s0)
 158:	00001097          	auipc	ra,0x1
 15c:	bfe080e7          	jalr	-1026(ra) # d56 <reg_test2_asm>
        printf("[ERROR] expected: %d, found %d\n", i * i, value);
        goto failed;
      }
    }
  }
  printf("[SUCCESS] test 2 passed\n");
 160:	00001517          	auipc	a0,0x1
 164:	d1050513          	addi	a0,a0,-752 # e70 <loop+0xe2>
 168:	00001097          	auipc	ra,0x1
 16c:	a1a080e7          	jalr	-1510(ra) # b82 <printf>
  success++;
 170:	00002717          	auipc	a4,0x2
 174:	e9070713          	addi	a4,a4,-368 # 2000 <success>
 178:	431c                	lw	a5,0(a4)
 17a:	2785                	addiw	a5,a5,1
 17c:	c31c                	sw	a5,0(a4)
failed:
  if (child_proc > 0) kill(child_proc);
 17e:	09204863          	bgtz	s2,20e <test2+0xfc>
  printf("test 2 finished\n");
 182:	00001517          	auipc	a0,0x1
 186:	d0e50513          	addi	a0,a0,-754 # e90 <loop+0x102>
 18a:	00001097          	auipc	ra,0x1
 18e:	9f8080e7          	jalr	-1544(ra) # b82 <printf>
}
 192:	60a6                	ld	ra,72(sp)
 194:	6406                	ld	s0,64(sp)
 196:	7942                	ld	s2,48(sp)
 198:	6161                	addi	sp,sp,80
 19a:	8082                	ret
 19c:	fc26                	sd	s1,56(sp)
 19e:	f44e                	sd	s3,40(sp)
    read(pipefd[0], &a, 8);
 1a0:	4621                	li	a2,8
 1a2:	fb840593          	addi	a1,s0,-72
 1a6:	fc842503          	lw	a0,-56(s0)
 1aa:	00000097          	auipc	ra,0x0
 1ae:	680080e7          	jalr	1664(ra) # 82a <read>
    for (int i = 2; i < 12; i++) {
 1b2:	4489                	li	s1,2
 1b4:	49b1                	li	s3,12
      int error = reg(child_proc, i, &value);
 1b6:	fc040613          	addi	a2,s0,-64
 1ba:	85a6                	mv	a1,s1
 1bc:	854a                	mv	a0,s2
 1be:	00000097          	auipc	ra,0x0
 1c2:	6f4080e7          	jalr	1780(ra) # 8b2 <reg>
      if (error != 0) {
 1c6:	ed09                	bnez	a0,1e0 <test2+0xce>
      if (value != i * i) {
 1c8:	029485bb          	mulw	a1,s1,s1
 1cc:	fc043603          	ld	a2,-64(s0)
 1d0:	02c59463          	bne	a1,a2,1f8 <test2+0xe6>
    for (int i = 2; i < 12; i++) {
 1d4:	2485                	addiw	s1,s1,1
 1d6:	ff3490e3          	bne	s1,s3,1b6 <test2+0xa4>
 1da:	74e2                	ld	s1,56(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	b749                	j	160 <test2+0x4e>
        printf("[ERROR] reg returned unexpected error %d\n", error);
 1e0:	85aa                	mv	a1,a0
 1e2:	00001517          	auipc	a0,0x1
 1e6:	bce50513          	addi	a0,a0,-1074 # db0 <loop+0x22>
 1ea:	00001097          	auipc	ra,0x1
 1ee:	998080e7          	jalr	-1640(ra) # b82 <printf>
        goto failed;
 1f2:	74e2                	ld	s1,56(sp)
 1f4:	79a2                	ld	s3,40(sp)
 1f6:	b761                	j	17e <test2+0x6c>
        printf("[ERROR] expected: %d, found %d\n", i * i, value);
 1f8:	00001517          	auipc	a0,0x1
 1fc:	c5850513          	addi	a0,a0,-936 # e50 <loop+0xc2>
 200:	00001097          	auipc	ra,0x1
 204:	982080e7          	jalr	-1662(ra) # b82 <printf>
        goto failed;
 208:	74e2                	ld	s1,56(sp)
 20a:	79a2                	ld	s3,40(sp)
 20c:	bf8d                	j	17e <test2+0x6c>
  if (child_proc > 0) kill(child_proc);
 20e:	854a                	mv	a0,s2
 210:	00000097          	auipc	ra,0x0
 214:	632080e7          	jalr	1586(ra) # 842 <kill>
 218:	b7ad                	j	182 <test2+0x70>

000000000000021a <test3>:

int reg_test3_asm(int pid, uint64 *ptr);

void test3() {
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
  printf("test 3 started\n");
 222:	00001517          	auipc	a0,0x1
 226:	c8650513          	addi	a0,a0,-890 # ea8 <loop+0x11a>
 22a:	00001097          	auipc	ra,0x1
 22e:	958080e7          	jalr	-1704(ra) # b82 <printf>
  uint64 value;
  int result = reg_test3_asm(getpid(), &value);
 232:	00000097          	auipc	ra,0x0
 236:	660080e7          	jalr	1632(ra) # 892 <getpid>
 23a:	fe840593          	addi	a1,s0,-24
 23e:	00001097          	auipc	ra,0x1
 242:	b40080e7          	jalr	-1216(ra) # d7e <reg_test3_asm>
  if (result != 0) {
 246:	e91d                	bnez	a0,27c <test3+0x62>
    printf("[ERROR] reg returned unexpected error %d\n", result);
    goto failed;
  }
  if (value != 1337) {
 248:	fe843583          	ld	a1,-24(s0)
 24c:	53900793          	li	a5,1337
 250:	04f58063          	beq	a1,a5,290 <test3+0x76>
    printf("[ERROR] expected: 1337, found: %d", value);
 254:	00001517          	auipc	a0,0x1
 258:	c6450513          	addi	a0,a0,-924 # eb8 <loop+0x12a>
 25c:	00001097          	auipc	ra,0x1
 260:	926080e7          	jalr	-1754(ra) # b82 <printf>
    goto failed;
  }
  printf("[SUCCESS] test 3 passed\n");
  success++;
failed:
  printf("test 3 finished\n");
 264:	00001517          	auipc	a0,0x1
 268:	c9c50513          	addi	a0,a0,-868 # f00 <loop+0x172>
 26c:	00001097          	auipc	ra,0x1
 270:	916080e7          	jalr	-1770(ra) # b82 <printf>
}
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    printf("[ERROR] reg returned unexpected error %d\n", result);
 27c:	85aa                	mv	a1,a0
 27e:	00001517          	auipc	a0,0x1
 282:	b3250513          	addi	a0,a0,-1230 # db0 <loop+0x22>
 286:	00001097          	auipc	ra,0x1
 28a:	8fc080e7          	jalr	-1796(ra) # b82 <printf>
    goto failed;
 28e:	bfd9                	j	264 <test3+0x4a>
  printf("[SUCCESS] test 3 passed\n");
 290:	00001517          	auipc	a0,0x1
 294:	c5050513          	addi	a0,a0,-944 # ee0 <loop+0x152>
 298:	00001097          	auipc	ra,0x1
 29c:	8ea080e7          	jalr	-1814(ra) # b82 <printf>
  success++;
 2a0:	00002717          	auipc	a4,0x2
 2a4:	d6070713          	addi	a4,a4,-672 # 2000 <success>
 2a8:	431c                	lw	a5,0(a4)
 2aa:	2785                	addiw	a5,a5,1
 2ac:	c31c                	sw	a5,0(a4)
 2ae:	bf5d                	j	264 <test3+0x4a>

00000000000002b0 <test4>:

void test4() {
 2b0:	7139                	addi	sp,sp,-64
 2b2:	fc06                	sd	ra,56(sp)
 2b4:	f822                	sd	s0,48(sp)
 2b6:	0080                	addi	s0,sp,64
  printf("test 4 started\n");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	c6050513          	addi	a0,a0,-928 # f18 <loop+0x18a>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	8c2080e7          	jalr	-1854(ra) # b82 <printf>
  uint64 a;
  printf("[INFO] testing nonexisting proccess\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	c6050513          	addi	a0,a0,-928 # f28 <loop+0x19a>
 2d0:	00001097          	auipc	ra,0x1
 2d4:	8b2080e7          	jalr	-1870(ra) # b82 <printf>
  int error = reg(2147483647, 10, &a);
 2d8:	fd840613          	addi	a2,s0,-40
 2dc:	45a9                	li	a1,10
 2de:	80000537          	lui	a0,0x80000
 2e2:	fff54513          	not	a0,a0
 2e6:	00000097          	auipc	ra,0x0
 2ea:	5cc080e7          	jalr	1484(ra) # 8b2 <reg>
 2ee:	fca42a23          	sw	a0,-44(s0)
  if (error != -2) {
 2f2:	57f9                	li	a5,-2
 2f4:	02f50763          	beq	a0,a5,322 <test4+0x72>
 2f8:	85aa                	mv	a1,a0
    printf("[ERROR] reg returned unexpected value %d, expected -2\n", error);
 2fa:	00001517          	auipc	a0,0x1
 2fe:	c5650513          	addi	a0,a0,-938 # f50 <loop+0x1c2>
 302:	00001097          	auipc	ra,0x1
 306:	880080e7          	jalr	-1920(ra) # b82 <printf>
  }
  printf("[OK] invalid memory address\n");
  printf("[SUCCESS] test 4 passed\n");
  success++;
failed:
  printf("test 4 finished\n");
 30a:	00001517          	auipc	a0,0x1
 30e:	e5e50513          	addi	a0,a0,-418 # 1168 <loop+0x3da>
 312:	00001097          	auipc	ra,0x1
 316:	870080e7          	jalr	-1936(ra) # b82 <printf>
}
 31a:	70e2                	ld	ra,56(sp)
 31c:	7442                	ld	s0,48(sp)
 31e:	6121                	addi	sp,sp,64
 320:	8082                	ret
 322:	f426                	sd	s1,40(sp)
  printf("[OK] nonexisting proccess\n");
 324:	00001517          	auipc	a0,0x1
 328:	c6450513          	addi	a0,a0,-924 # f88 <loop+0x1fa>
 32c:	00001097          	auipc	ra,0x1
 330:	856080e7          	jalr	-1962(ra) # b82 <printf>
  printf("[INFO] testing illegal access to registers\n");
 334:	00001517          	auipc	a0,0x1
 338:	c7450513          	addi	a0,a0,-908 # fa8 <loop+0x21a>
 33c:	00001097          	auipc	ra,0x1
 340:	846080e7          	jalr	-1978(ra) # b82 <printf>
  pipe(pipefd);
 344:	fc840513          	addi	a0,s0,-56
 348:	00000097          	auipc	ra,0x0
 34c:	4da080e7          	jalr	1242(ra) # 822 <pipe>
  int parent_pid = getpid();
 350:	00000097          	auipc	ra,0x0
 354:	542080e7          	jalr	1346(ra) # 892 <getpid>
 358:	84aa                	mv	s1,a0
  int child_proc = fork();
 35a:	00000097          	auipc	ra,0x0
 35e:	4b0080e7          	jalr	1200(ra) # 80a <fork>
  if (child_proc == 0) {
 362:	c90d                	beqz	a0,394 <test4+0xe4>
    read(pipefd[0], &error, 4);
 364:	4611                	li	a2,4
 366:	fd440593          	addi	a1,s0,-44
 36a:	fc842503          	lw	a0,-56(s0)
 36e:	00000097          	auipc	ra,0x0
 372:	4bc080e7          	jalr	1212(ra) # 82a <read>
    if (error != -1) {
 376:	fd442583          	lw	a1,-44(s0)
 37a:	57fd                	li	a5,-1
 37c:	04f58463          	beq	a1,a5,3c4 <test4+0x114>
      printf("[ERROR] reg returned unexpected value %d, expected -1\n", error);
 380:	00001517          	auipc	a0,0x1
 384:	c5850513          	addi	a0,a0,-936 # fd8 <loop+0x24a>
 388:	00000097          	auipc	ra,0x0
 38c:	7fa080e7          	jalr	2042(ra) # b82 <printf>
      goto failed;
 390:	74a2                	ld	s1,40(sp)
 392:	bfa5                	j	30a <test4+0x5a>
    error = reg(parent_pid, 10, &a);
 394:	fd840613          	addi	a2,s0,-40
 398:	45a9                	li	a1,10
 39a:	8526                	mv	a0,s1
 39c:	00000097          	auipc	ra,0x0
 3a0:	516080e7          	jalr	1302(ra) # 8b2 <reg>
 3a4:	fca42a23          	sw	a0,-44(s0)
    write(pipefd[1], &error, 4);
 3a8:	4611                	li	a2,4
 3aa:	fd440593          	addi	a1,s0,-44
 3ae:	fcc42503          	lw	a0,-52(s0)
 3b2:	00000097          	auipc	ra,0x0
 3b6:	480080e7          	jalr	1152(ra) # 832 <write>
    exit(0);
 3ba:	4501                	li	a0,0
 3bc:	00000097          	auipc	ra,0x0
 3c0:	456080e7          	jalr	1110(ra) # 812 <exit>
  printf("[OK] illegal access to registers\n");
 3c4:	00001517          	auipc	a0,0x1
 3c8:	c4c50513          	addi	a0,a0,-948 # 1010 <loop+0x282>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	7b6080e7          	jalr	1974(ra) # b82 <printf>
  printf("[INFO] testing incorrect number of register\n");
 3d4:	00001517          	auipc	a0,0x1
 3d8:	c6450513          	addi	a0,a0,-924 # 1038 <loop+0x2aa>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	7a6080e7          	jalr	1958(ra) # b82 <printf>
  error = reg(parent_pid, 1337, &a);
 3e4:	fd840613          	addi	a2,s0,-40
 3e8:	53900593          	li	a1,1337
 3ec:	8526                	mv	a0,s1
 3ee:	00000097          	auipc	ra,0x0
 3f2:	4c4080e7          	jalr	1220(ra) # 8b2 <reg>
 3f6:	fca42a23          	sw	a0,-44(s0)
  if (error != -3) {
 3fa:	57f5                	li	a5,-3
 3fc:	00f50d63          	beq	a0,a5,416 <test4+0x166>
    printf("[ERROR] reg returned unexpected value %d, expected -3\n", error);
 400:	85aa                	mv	a1,a0
 402:	00001517          	auipc	a0,0x1
 406:	c6650513          	addi	a0,a0,-922 # 1068 <loop+0x2da>
 40a:	00000097          	auipc	ra,0x0
 40e:	778080e7          	jalr	1912(ra) # b82 <printf>
    goto failed;
 412:	74a2                	ld	s1,40(sp)
 414:	bddd                	j	30a <test4+0x5a>
  printf("[OK] incorrect number of register\n");
 416:	00001517          	auipc	a0,0x1
 41a:	c8a50513          	addi	a0,a0,-886 # 10a0 <loop+0x312>
 41e:	00000097          	auipc	ra,0x0
 422:	764080e7          	jalr	1892(ra) # b82 <printf>
  printf("[INFO] testing invalid memory address\n");
 426:	00001517          	auipc	a0,0x1
 42a:	ca250513          	addi	a0,a0,-862 # 10c8 <loop+0x33a>
 42e:	00000097          	auipc	ra,0x0
 432:	754080e7          	jalr	1876(ra) # b82 <printf>
  error = reg(parent_pid, 10, &a + 123456789);
 436:	3ade7637          	lui	a2,0x3ade7
 43a:	88060793          	addi	a5,a2,-1920 # 3ade6880 <base+0x3ade4870>
 43e:	00878633          	add	a2,a5,s0
 442:	45a9                	li	a1,10
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	46c080e7          	jalr	1132(ra) # 8b2 <reg>
 44e:	85aa                	mv	a1,a0
 450:	fca42a23          	sw	a0,-44(s0)
  if (error != -4) {
 454:	57f1                	li	a5,-4
 456:	00f50c63          	beq	a0,a5,46e <test4+0x1be>
    printf("[ERROR] reg returned unexpected value %d, expected -4\n", error);
 45a:	00001517          	auipc	a0,0x1
 45e:	c9650513          	addi	a0,a0,-874 # 10f0 <loop+0x362>
 462:	00000097          	auipc	ra,0x0
 466:	720080e7          	jalr	1824(ra) # b82 <printf>
    goto failed;
 46a:	74a2                	ld	s1,40(sp)
 46c:	bd79                	j	30a <test4+0x5a>
  printf("[OK] invalid memory address\n");
 46e:	00001517          	auipc	a0,0x1
 472:	cba50513          	addi	a0,a0,-838 # 1128 <loop+0x39a>
 476:	00000097          	auipc	ra,0x0
 47a:	70c080e7          	jalr	1804(ra) # b82 <printf>
  printf("[SUCCESS] test 4 passed\n");
 47e:	00001517          	auipc	a0,0x1
 482:	cca50513          	addi	a0,a0,-822 # 1148 <loop+0x3ba>
 486:	00000097          	auipc	ra,0x0
 48a:	6fc080e7          	jalr	1788(ra) # b82 <printf>
  success++;
 48e:	00002717          	auipc	a4,0x2
 492:	b7270713          	addi	a4,a4,-1166 # 2000 <success>
 496:	431c                	lw	a5,0(a4)
 498:	2785                	addiw	a5,a5,1
 49a:	c31c                	sw	a5,0(a4)
 49c:	74a2                	ld	s1,40(sp)
 49e:	b5b5                	j	30a <test4+0x5a>

00000000000004a0 <main>:
int main(void) {
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	e426                	sd	s1,8(sp)
 4a8:	1000                	addi	s0,sp,32
  printf("reg tests started\n");
 4aa:	00001517          	auipc	a0,0x1
 4ae:	cd650513          	addi	a0,a0,-810 # 1180 <loop+0x3f2>
 4b2:	00000097          	auipc	ra,0x0
 4b6:	6d0080e7          	jalr	1744(ra) # b82 <printf>
  printf("reg syscall found. Start testing\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	cde50513          	addi	a0,a0,-802 # 1198 <loop+0x40a>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	6c0080e7          	jalr	1728(ra) # b82 <printf>
  success = 0;
 4ca:	00002497          	auipc	s1,0x2
 4ce:	b3648493          	addi	s1,s1,-1226 # 2000 <success>
 4d2:	0004a023          	sw	zero,0(s1)
  test1();
 4d6:	00000097          	auipc	ra,0x0
 4da:	b2a080e7          	jalr	-1238(ra) # 0 <test1>
  test2();
 4de:	00000097          	auipc	ra,0x0
 4e2:	c34080e7          	jalr	-972(ra) # 112 <test2>
  test3();
 4e6:	00000097          	auipc	ra,0x0
 4ea:	d34080e7          	jalr	-716(ra) # 21a <test3>
  test4();
 4ee:	00000097          	auipc	ra,0x0
 4f2:	dc2080e7          	jalr	-574(ra) # 2b0 <test4>
  printf("4 tests were run. %d tests passed\n", success);
 4f6:	408c                	lw	a1,0(s1)
 4f8:	00001517          	auipc	a0,0x1
 4fc:	cc850513          	addi	a0,a0,-824 # 11c0 <loop+0x432>
 500:	00000097          	auipc	ra,0x0
 504:	682080e7          	jalr	1666(ra) # b82 <printf>
  exit(0);
 508:	4501                	li	a0,0
 50a:	00000097          	auipc	ra,0x0
 50e:	308080e7          	jalr	776(ra) # 812 <exit>

0000000000000512 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 512:	1141                	addi	sp,sp,-16
 514:	e406                	sd	ra,8(sp)
 516:	e022                	sd	s0,0(sp)
 518:	0800                	addi	s0,sp,16
  extern int main();
  main();
 51a:	00000097          	auipc	ra,0x0
 51e:	f86080e7          	jalr	-122(ra) # 4a0 <main>
  exit(0);
 522:	4501                	li	a0,0
 524:	00000097          	auipc	ra,0x0
 528:	2ee080e7          	jalr	750(ra) # 812 <exit>

000000000000052c <strcpy>:
}

char *strcpy(char *s, const char *t) {
 52c:	1141                	addi	sp,sp,-16
 52e:	e422                	sd	s0,8(sp)
 530:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 532:	87aa                	mv	a5,a0
 534:	0585                	addi	a1,a1,1
 536:	0785                	addi	a5,a5,1
 538:	fff5c703          	lbu	a4,-1(a1)
 53c:	fee78fa3          	sb	a4,-1(a5)
 540:	fb75                	bnez	a4,534 <strcpy+0x8>
  return os;
}
 542:	6422                	ld	s0,8(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret

0000000000000548 <strcmp>:

int strcmp(const char *p, const char *q) {
 548:	1141                	addi	sp,sp,-16
 54a:	e422                	sd	s0,8(sp)
 54c:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 54e:	00054783          	lbu	a5,0(a0)
 552:	cb91                	beqz	a5,566 <strcmp+0x1e>
 554:	0005c703          	lbu	a4,0(a1)
 558:	00f71763          	bne	a4,a5,566 <strcmp+0x1e>
 55c:	0505                	addi	a0,a0,1
 55e:	0585                	addi	a1,a1,1
 560:	00054783          	lbu	a5,0(a0)
 564:	fbe5                	bnez	a5,554 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 566:	0005c503          	lbu	a0,0(a1)
}
 56a:	40a7853b          	subw	a0,a5,a0
 56e:	6422                	ld	s0,8(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret

0000000000000574 <strlen>:

uint strlen(const char *s) {
 574:	1141                	addi	sp,sp,-16
 576:	e422                	sd	s0,8(sp)
 578:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 57a:	00054783          	lbu	a5,0(a0)
 57e:	cf91                	beqz	a5,59a <strlen+0x26>
 580:	0505                	addi	a0,a0,1
 582:	87aa                	mv	a5,a0
 584:	86be                	mv	a3,a5
 586:	0785                	addi	a5,a5,1
 588:	fff7c703          	lbu	a4,-1(a5)
 58c:	ff65                	bnez	a4,584 <strlen+0x10>
 58e:	40a6853b          	subw	a0,a3,a0
 592:	2505                	addiw	a0,a0,1
  return n;
}
 594:	6422                	ld	s0,8(sp)
 596:	0141                	addi	sp,sp,16
 598:	8082                	ret
  for (n = 0; s[n]; n++);
 59a:	4501                	li	a0,0
 59c:	bfe5                	j	594 <strlen+0x20>

000000000000059e <memset>:

void *memset(void *dst, int c, uint n) {
 59e:	1141                	addi	sp,sp,-16
 5a0:	e422                	sd	s0,8(sp)
 5a2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 5a4:	ca19                	beqz	a2,5ba <memset+0x1c>
 5a6:	87aa                	mv	a5,a0
 5a8:	1602                	slli	a2,a2,0x20
 5aa:	9201                	srli	a2,a2,0x20
 5ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5b0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 5b4:	0785                	addi	a5,a5,1
 5b6:	fee79de3          	bne	a5,a4,5b0 <memset+0x12>
  }
  return dst;
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret

00000000000005c0 <strchr>:

char *strchr(const char *s, char c) {
 5c0:	1141                	addi	sp,sp,-16
 5c2:	e422                	sd	s0,8(sp)
 5c4:	0800                	addi	s0,sp,16
  for (; *s; s++)
 5c6:	00054783          	lbu	a5,0(a0)
 5ca:	cb99                	beqz	a5,5e0 <strchr+0x20>
    if (*s == c) return (char *)s;
 5cc:	00f58763          	beq	a1,a5,5da <strchr+0x1a>
  for (; *s; s++)
 5d0:	0505                	addi	a0,a0,1
 5d2:	00054783          	lbu	a5,0(a0)
 5d6:	fbfd                	bnez	a5,5cc <strchr+0xc>
  return 0;
 5d8:	4501                	li	a0,0
}
 5da:	6422                	ld	s0,8(sp)
 5dc:	0141                	addi	sp,sp,16
 5de:	8082                	ret
  return 0;
 5e0:	4501                	li	a0,0
 5e2:	bfe5                	j	5da <strchr+0x1a>

00000000000005e4 <gets>:

char *gets(char *buf, int max) {
 5e4:	711d                	addi	sp,sp,-96
 5e6:	ec86                	sd	ra,88(sp)
 5e8:	e8a2                	sd	s0,80(sp)
 5ea:	e4a6                	sd	s1,72(sp)
 5ec:	e0ca                	sd	s2,64(sp)
 5ee:	fc4e                	sd	s3,56(sp)
 5f0:	f852                	sd	s4,48(sp)
 5f2:	f456                	sd	s5,40(sp)
 5f4:	f05a                	sd	s6,32(sp)
 5f6:	ec5e                	sd	s7,24(sp)
 5f8:	1080                	addi	s0,sp,96
 5fa:	8baa                	mv	s7,a0
 5fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 5fe:	892a                	mv	s2,a0
 600:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 602:	4aa9                	li	s5,10
 604:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 606:	89a6                	mv	s3,s1
 608:	2485                	addiw	s1,s1,1
 60a:	0344d863          	bge	s1,s4,63a <gets+0x56>
    cc = read(0, &c, 1);
 60e:	4605                	li	a2,1
 610:	faf40593          	addi	a1,s0,-81
 614:	4501                	li	a0,0
 616:	00000097          	auipc	ra,0x0
 61a:	214080e7          	jalr	532(ra) # 82a <read>
    if (cc < 1) break;
 61e:	00a05e63          	blez	a0,63a <gets+0x56>
    buf[i++] = c;
 622:	faf44783          	lbu	a5,-81(s0)
 626:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 62a:	01578763          	beq	a5,s5,638 <gets+0x54>
 62e:	0905                	addi	s2,s2,1
 630:	fd679be3          	bne	a5,s6,606 <gets+0x22>
    buf[i++] = c;
 634:	89a6                	mv	s3,s1
 636:	a011                	j	63a <gets+0x56>
 638:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 63a:	99de                	add	s3,s3,s7
 63c:	00098023          	sb	zero,0(s3)
  return buf;
}
 640:	855e                	mv	a0,s7
 642:	60e6                	ld	ra,88(sp)
 644:	6446                	ld	s0,80(sp)
 646:	64a6                	ld	s1,72(sp)
 648:	6906                	ld	s2,64(sp)
 64a:	79e2                	ld	s3,56(sp)
 64c:	7a42                	ld	s4,48(sp)
 64e:	7aa2                	ld	s5,40(sp)
 650:	7b02                	ld	s6,32(sp)
 652:	6be2                	ld	s7,24(sp)
 654:	6125                	addi	sp,sp,96
 656:	8082                	ret

0000000000000658 <stat>:

int stat(const char *n, struct stat *st) {
 658:	1101                	addi	sp,sp,-32
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	e04a                	sd	s2,0(sp)
 660:	1000                	addi	s0,sp,32
 662:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 664:	4581                	li	a1,0
 666:	00000097          	auipc	ra,0x0
 66a:	1ec080e7          	jalr	492(ra) # 852 <open>
  if (fd < 0) return -1;
 66e:	02054663          	bltz	a0,69a <stat+0x42>
 672:	e426                	sd	s1,8(sp)
 674:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 676:	85ca                	mv	a1,s2
 678:	00000097          	auipc	ra,0x0
 67c:	1f2080e7          	jalr	498(ra) # 86a <fstat>
 680:	892a                	mv	s2,a0
  close(fd);
 682:	8526                	mv	a0,s1
 684:	00000097          	auipc	ra,0x0
 688:	1b6080e7          	jalr	438(ra) # 83a <close>
  return r;
 68c:	64a2                	ld	s1,8(sp)
}
 68e:	854a                	mv	a0,s2
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6902                	ld	s2,0(sp)
 696:	6105                	addi	sp,sp,32
 698:	8082                	ret
  if (fd < 0) return -1;
 69a:	597d                	li	s2,-1
 69c:	bfcd                	j	68e <stat+0x36>

000000000000069e <atoi>:

int atoi(const char *s) {
 69e:	1141                	addi	sp,sp,-16
 6a0:	e422                	sd	s0,8(sp)
 6a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 6a4:	00054683          	lbu	a3,0(a0)
 6a8:	fd06879b          	addiw	a5,a3,-48
 6ac:	0ff7f793          	zext.b	a5,a5
 6b0:	4625                	li	a2,9
 6b2:	02f66863          	bltu	a2,a5,6e2 <atoi+0x44>
 6b6:	872a                	mv	a4,a0
  n = 0;
 6b8:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 6ba:	0705                	addi	a4,a4,1
 6bc:	0025179b          	slliw	a5,a0,0x2
 6c0:	9fa9                	addw	a5,a5,a0
 6c2:	0017979b          	slliw	a5,a5,0x1
 6c6:	9fb5                	addw	a5,a5,a3
 6c8:	fd07851b          	addiw	a0,a5,-48
 6cc:	00074683          	lbu	a3,0(a4)
 6d0:	fd06879b          	addiw	a5,a3,-48
 6d4:	0ff7f793          	zext.b	a5,a5
 6d8:	fef671e3          	bgeu	a2,a5,6ba <atoi+0x1c>
  return n;
}
 6dc:	6422                	ld	s0,8(sp)
 6de:	0141                	addi	sp,sp,16
 6e0:	8082                	ret
  n = 0;
 6e2:	4501                	li	a0,0
 6e4:	bfe5                	j	6dc <atoi+0x3e>

00000000000006e6 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e422                	sd	s0,8(sp)
 6ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6ec:	02b57463          	bgeu	a0,a1,714 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 6f0:	00c05f63          	blez	a2,70e <memmove+0x28>
 6f4:	1602                	slli	a2,a2,0x20
 6f6:	9201                	srli	a2,a2,0x20
 6f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6fc:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 6fe:	0585                	addi	a1,a1,1
 700:	0705                	addi	a4,a4,1
 702:	fff5c683          	lbu	a3,-1(a1)
 706:	fed70fa3          	sb	a3,-1(a4)
 70a:	fef71ae3          	bne	a4,a5,6fe <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 70e:	6422                	ld	s0,8(sp)
 710:	0141                	addi	sp,sp,16
 712:	8082                	ret
    dst += n;
 714:	00c50733          	add	a4,a0,a2
    src += n;
 718:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 71a:	fec05ae3          	blez	a2,70e <memmove+0x28>
 71e:	fff6079b          	addiw	a5,a2,-1
 722:	1782                	slli	a5,a5,0x20
 724:	9381                	srli	a5,a5,0x20
 726:	fff7c793          	not	a5,a5
 72a:	97ba                	add	a5,a5,a4
 72c:	15fd                	addi	a1,a1,-1
 72e:	177d                	addi	a4,a4,-1
 730:	0005c683          	lbu	a3,0(a1)
 734:	00d70023          	sb	a3,0(a4)
 738:	fee79ae3          	bne	a5,a4,72c <memmove+0x46>
 73c:	bfc9                	j	70e <memmove+0x28>

000000000000073e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 73e:	1141                	addi	sp,sp,-16
 740:	e422                	sd	s0,8(sp)
 742:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 744:	ca05                	beqz	a2,774 <memcmp+0x36>
 746:	fff6069b          	addiw	a3,a2,-1
 74a:	1682                	slli	a3,a3,0x20
 74c:	9281                	srli	a3,a3,0x20
 74e:	0685                	addi	a3,a3,1
 750:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 752:	00054783          	lbu	a5,0(a0)
 756:	0005c703          	lbu	a4,0(a1)
 75a:	00e79863          	bne	a5,a4,76a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 75e:	0505                	addi	a0,a0,1
    p2++;
 760:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 762:	fed518e3          	bne	a0,a3,752 <memcmp+0x14>
  }
  return 0;
 766:	4501                	li	a0,0
 768:	a019                	j	76e <memcmp+0x30>
      return *p1 - *p2;
 76a:	40e7853b          	subw	a0,a5,a4
}
 76e:	6422                	ld	s0,8(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret
  return 0;
 774:	4501                	li	a0,0
 776:	bfe5                	j	76e <memcmp+0x30>

0000000000000778 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 778:	1141                	addi	sp,sp,-16
 77a:	e406                	sd	ra,8(sp)
 77c:	e022                	sd	s0,0(sp)
 77e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 780:	00000097          	auipc	ra,0x0
 784:	f66080e7          	jalr	-154(ra) # 6e6 <memmove>
}
 788:	60a2                	ld	ra,8(sp)
 78a:	6402                	ld	s0,0(sp)
 78c:	0141                	addi	sp,sp,16
 78e:	8082                	ret

0000000000000790 <strcat>:

char *strcat(char *dst, const char *src) {
 790:	1141                	addi	sp,sp,-16
 792:	e422                	sd	s0,8(sp)
 794:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 796:	00054783          	lbu	a5,0(a0)
 79a:	c385                	beqz	a5,7ba <strcat+0x2a>
  char *p = dst;
 79c:	87aa                	mv	a5,a0
  while (*p) p++;
 79e:	0785                	addi	a5,a5,1
 7a0:	0007c703          	lbu	a4,0(a5)
 7a4:	ff6d                	bnez	a4,79e <strcat+0xe>
  while ((*p++ = *src++));
 7a6:	0585                	addi	a1,a1,1
 7a8:	0785                	addi	a5,a5,1
 7aa:	fff5c703          	lbu	a4,-1(a1)
 7ae:	fee78fa3          	sb	a4,-1(a5)
 7b2:	fb75                	bnez	a4,7a6 <strcat+0x16>
  return dst;
}
 7b4:	6422                	ld	s0,8(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret
  char *p = dst;
 7ba:	87aa                	mv	a5,a0
 7bc:	b7ed                	j	7a6 <strcat+0x16>

00000000000007be <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 7be:	1141                	addi	sp,sp,-16
 7c0:	e422                	sd	s0,8(sp)
 7c2:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 7c4:	0005c783          	lbu	a5,0(a1)
 7c8:	cf95                	beqz	a5,804 <strstr+0x46>

  for (; *haystack; haystack++) {
 7ca:	00054783          	lbu	a5,0(a0)
 7ce:	eb91                	bnez	a5,7e2 <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 7d0:	4501                	li	a0,0
 7d2:	a80d                	j	804 <strstr+0x46>
    if (!*n) return (char *)haystack;
 7d4:	0007c783          	lbu	a5,0(a5)
 7d8:	c795                	beqz	a5,804 <strstr+0x46>
  for (; *haystack; haystack++) {
 7da:	0505                	addi	a0,a0,1
 7dc:	00054783          	lbu	a5,0(a0)
 7e0:	c38d                	beqz	a5,802 <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 7e2:	00054703          	lbu	a4,0(a0)
    n = needle;
 7e6:	87ae                	mv	a5,a1
    h = haystack;
 7e8:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 7ea:	db65                	beqz	a4,7da <strstr+0x1c>
 7ec:	0007c683          	lbu	a3,0(a5)
 7f0:	ca91                	beqz	a3,804 <strstr+0x46>
 7f2:	fee691e3          	bne	a3,a4,7d4 <strstr+0x16>
      h++;
 7f6:	0605                	addi	a2,a2,1
      n++;
 7f8:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 7fa:	00064703          	lbu	a4,0(a2)
 7fe:	f77d                	bnez	a4,7ec <strstr+0x2e>
 800:	bfd1                	j	7d4 <strstr+0x16>
  return 0;
 802:	4501                	li	a0,0
}
 804:	6422                	ld	s0,8(sp)
 806:	0141                	addi	sp,sp,16
 808:	8082                	ret

000000000000080a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 80a:	4885                	li	a7,1
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <exit>:
.global exit
exit:
 li a7, SYS_exit
 812:	4889                	li	a7,2
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <wait>:
.global wait
wait:
 li a7, SYS_wait
 81a:	488d                	li	a7,3
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 822:	4891                	li	a7,4
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <read>:
.global read
read:
 li a7, SYS_read
 82a:	4895                	li	a7,5
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <write>:
.global write
write:
 li a7, SYS_write
 832:	48c1                	li	a7,16
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <close>:
.global close
close:
 li a7, SYS_close
 83a:	48d5                	li	a7,21
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <kill>:
.global kill
kill:
 li a7, SYS_kill
 842:	4899                	li	a7,6
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <exec>:
.global exec
exec:
 li a7, SYS_exec
 84a:	489d                	li	a7,7
 ecall
 84c:	00000073          	ecall
 ret
 850:	8082                	ret

0000000000000852 <open>:
.global open
open:
 li a7, SYS_open
 852:	48bd                	li	a7,15
 ecall
 854:	00000073          	ecall
 ret
 858:	8082                	ret

000000000000085a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 85a:	48c5                	li	a7,17
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 862:	48c9                	li	a7,18
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 86a:	48a1                	li	a7,8
 ecall
 86c:	00000073          	ecall
 ret
 870:	8082                	ret

0000000000000872 <link>:
.global link
link:
 li a7, SYS_link
 872:	48cd                	li	a7,19
 ecall
 874:	00000073          	ecall
 ret
 878:	8082                	ret

000000000000087a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 87a:	48d1                	li	a7,20
 ecall
 87c:	00000073          	ecall
 ret
 880:	8082                	ret

0000000000000882 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 882:	48a5                	li	a7,9
 ecall
 884:	00000073          	ecall
 ret
 888:	8082                	ret

000000000000088a <dup>:
.global dup
dup:
 li a7, SYS_dup
 88a:	48a9                	li	a7,10
 ecall
 88c:	00000073          	ecall
 ret
 890:	8082                	ret

0000000000000892 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 892:	48ad                	li	a7,11
 ecall
 894:	00000073          	ecall
 ret
 898:	8082                	ret

000000000000089a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 89a:	48b1                	li	a7,12
 ecall
 89c:	00000073          	ecall
 ret
 8a0:	8082                	ret

00000000000008a2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8a2:	48b5                	li	a7,13
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	8082                	ret

00000000000008aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8aa:	48b9                	li	a7,14
 ecall
 8ac:	00000073          	ecall
 ret
 8b0:	8082                	ret

00000000000008b2 <reg>:
.global reg
reg:
 li a7, SYS_reg
 8b2:	48d9                	li	a7,22
 ecall
 8b4:	00000073          	ecall
 ret
 8b8:	8082                	ret

00000000000008ba <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 8ba:	1101                	addi	sp,sp,-32
 8bc:	ec06                	sd	ra,24(sp)
 8be:	e822                	sd	s0,16(sp)
 8c0:	1000                	addi	s0,sp,32
 8c2:	feb407a3          	sb	a1,-17(s0)
 8c6:	4605                	li	a2,1
 8c8:	fef40593          	addi	a1,s0,-17
 8cc:	00000097          	auipc	ra,0x0
 8d0:	f66080e7          	jalr	-154(ra) # 832 <write>
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6105                	addi	sp,sp,32
 8da:	8082                	ret

00000000000008dc <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	0080                	addi	s0,sp,64
 8e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 8e8:	c299                	beqz	a3,8ee <printint+0x12>
 8ea:	0805cb63          	bltz	a1,980 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8ee:	2581                	sext.w	a1,a1
  neg = 0;
 8f0:	4881                	li	a7,0
 8f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8f6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 8f8:	2601                	sext.w	a2,a2
 8fa:	00001517          	auipc	a0,0x1
 8fe:	94e50513          	addi	a0,a0,-1714 # 1248 <digits>
 902:	883a                	mv	a6,a4
 904:	2705                	addiw	a4,a4,1
 906:	02c5f7bb          	remuw	a5,a1,a2
 90a:	1782                	slli	a5,a5,0x20
 90c:	9381                	srli	a5,a5,0x20
 90e:	97aa                	add	a5,a5,a0
 910:	0007c783          	lbu	a5,0(a5)
 914:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 918:	0005879b          	sext.w	a5,a1
 91c:	02c5d5bb          	divuw	a1,a1,a2
 920:	0685                	addi	a3,a3,1
 922:	fec7f0e3          	bgeu	a5,a2,902 <printint+0x26>
  if (neg) buf[i++] = '-';
 926:	00088c63          	beqz	a7,93e <printint+0x62>
 92a:	fd070793          	addi	a5,a4,-48
 92e:	00878733          	add	a4,a5,s0
 932:	02d00793          	li	a5,45
 936:	fef70823          	sb	a5,-16(a4)
 93a:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 93e:	02e05c63          	blez	a4,976 <printint+0x9a>
 942:	f04a                	sd	s2,32(sp)
 944:	ec4e                	sd	s3,24(sp)
 946:	fc040793          	addi	a5,s0,-64
 94a:	00e78933          	add	s2,a5,a4
 94e:	fff78993          	addi	s3,a5,-1
 952:	99ba                	add	s3,s3,a4
 954:	377d                	addiw	a4,a4,-1
 956:	1702                	slli	a4,a4,0x20
 958:	9301                	srli	a4,a4,0x20
 95a:	40e989b3          	sub	s3,s3,a4
 95e:	fff94583          	lbu	a1,-1(s2)
 962:	8526                	mv	a0,s1
 964:	00000097          	auipc	ra,0x0
 968:	f56080e7          	jalr	-170(ra) # 8ba <putc>
 96c:	197d                	addi	s2,s2,-1
 96e:	ff3918e3          	bne	s2,s3,95e <printint+0x82>
 972:	7902                	ld	s2,32(sp)
 974:	69e2                	ld	s3,24(sp)
}
 976:	70e2                	ld	ra,56(sp)
 978:	7442                	ld	s0,48(sp)
 97a:	74a2                	ld	s1,40(sp)
 97c:	6121                	addi	sp,sp,64
 97e:	8082                	ret
    x = -xx;
 980:	40b005bb          	negw	a1,a1
    neg = 1;
 984:	4885                	li	a7,1
    x = -xx;
 986:	b7b5                	j	8f2 <printint+0x16>

0000000000000988 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 988:	715d                	addi	sp,sp,-80
 98a:	e486                	sd	ra,72(sp)
 98c:	e0a2                	sd	s0,64(sp)
 98e:	f84a                	sd	s2,48(sp)
 990:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 992:	0005c903          	lbu	s2,0(a1)
 996:	1a090a63          	beqz	s2,b4a <vprintf+0x1c2>
 99a:	fc26                	sd	s1,56(sp)
 99c:	f44e                	sd	s3,40(sp)
 99e:	f052                	sd	s4,32(sp)
 9a0:	ec56                	sd	s5,24(sp)
 9a2:	e85a                	sd	s6,16(sp)
 9a4:	e45e                	sd	s7,8(sp)
 9a6:	8aaa                	mv	s5,a0
 9a8:	8bb2                	mv	s7,a2
 9aa:	00158493          	addi	s1,a1,1
  state = 0;
 9ae:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 9b0:	02500a13          	li	s4,37
 9b4:	4b55                	li	s6,21
 9b6:	a839                	j	9d4 <vprintf+0x4c>
        putc(fd, c);
 9b8:	85ca                	mv	a1,s2
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	efe080e7          	jalr	-258(ra) # 8ba <putc>
 9c4:	a019                	j	9ca <vprintf+0x42>
    } else if (state == '%') {
 9c6:	01498d63          	beq	s3,s4,9e0 <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 9ca:	0485                	addi	s1,s1,1
 9cc:	fff4c903          	lbu	s2,-1(s1)
 9d0:	16090763          	beqz	s2,b3e <vprintf+0x1b6>
    if (state == 0) {
 9d4:	fe0999e3          	bnez	s3,9c6 <vprintf+0x3e>
      if (c == '%') {
 9d8:	ff4910e3          	bne	s2,s4,9b8 <vprintf+0x30>
        state = '%';
 9dc:	89d2                	mv	s3,s4
 9de:	b7f5                	j	9ca <vprintf+0x42>
      if (c == 'd') {
 9e0:	13490463          	beq	s2,s4,b08 <vprintf+0x180>
 9e4:	f9d9079b          	addiw	a5,s2,-99
 9e8:	0ff7f793          	zext.b	a5,a5
 9ec:	12fb6763          	bltu	s6,a5,b1a <vprintf+0x192>
 9f0:	f9d9079b          	addiw	a5,s2,-99
 9f4:	0ff7f713          	zext.b	a4,a5
 9f8:	12eb6163          	bltu	s6,a4,b1a <vprintf+0x192>
 9fc:	00271793          	slli	a5,a4,0x2
 a00:	00000717          	auipc	a4,0x0
 a04:	7f070713          	addi	a4,a4,2032 # 11f0 <loop+0x462>
 a08:	97ba                	add	a5,a5,a4
 a0a:	439c                	lw	a5,0(a5)
 a0c:	97ba                	add	a5,a5,a4
 a0e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 a10:	008b8913          	addi	s2,s7,8
 a14:	4685                	li	a3,1
 a16:	4629                	li	a2,10
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	8556                	mv	a0,s5
 a1e:	00000097          	auipc	ra,0x0
 a22:	ebe080e7          	jalr	-322(ra) # 8dc <printint>
 a26:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	b745                	j	9ca <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a2c:	008b8913          	addi	s2,s7,8
 a30:	4681                	li	a3,0
 a32:	4629                	li	a2,10
 a34:	000ba583          	lw	a1,0(s7)
 a38:	8556                	mv	a0,s5
 a3a:	00000097          	auipc	ra,0x0
 a3e:	ea2080e7          	jalr	-350(ra) # 8dc <printint>
 a42:	8bca                	mv	s7,s2
      state = 0;
 a44:	4981                	li	s3,0
 a46:	b751                	j	9ca <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 a48:	008b8913          	addi	s2,s7,8
 a4c:	4681                	li	a3,0
 a4e:	4641                	li	a2,16
 a50:	000ba583          	lw	a1,0(s7)
 a54:	8556                	mv	a0,s5
 a56:	00000097          	auipc	ra,0x0
 a5a:	e86080e7          	jalr	-378(ra) # 8dc <printint>
 a5e:	8bca                	mv	s7,s2
      state = 0;
 a60:	4981                	li	s3,0
 a62:	b7a5                	j	9ca <vprintf+0x42>
 a64:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a66:	008b8c13          	addi	s8,s7,8
 a6a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a6e:	03000593          	li	a1,48
 a72:	8556                	mv	a0,s5
 a74:	00000097          	auipc	ra,0x0
 a78:	e46080e7          	jalr	-442(ra) # 8ba <putc>
  putc(fd, 'x');
 a7c:	07800593          	li	a1,120
 a80:	8556                	mv	a0,s5
 a82:	00000097          	auipc	ra,0x0
 a86:	e38080e7          	jalr	-456(ra) # 8ba <putc>
 a8a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a8c:	00000b97          	auipc	s7,0x0
 a90:	7bcb8b93          	addi	s7,s7,1980 # 1248 <digits>
 a94:	03c9d793          	srli	a5,s3,0x3c
 a98:	97de                	add	a5,a5,s7
 a9a:	0007c583          	lbu	a1,0(a5)
 a9e:	8556                	mv	a0,s5
 aa0:	00000097          	auipc	ra,0x0
 aa4:	e1a080e7          	jalr	-486(ra) # 8ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 aa8:	0992                	slli	s3,s3,0x4
 aaa:	397d                	addiw	s2,s2,-1
 aac:	fe0914e3          	bnez	s2,a94 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 ab0:	8be2                	mv	s7,s8
      state = 0;
 ab2:	4981                	li	s3,0
 ab4:	6c02                	ld	s8,0(sp)
 ab6:	bf11                	j	9ca <vprintf+0x42>
        s = va_arg(ap, char *);
 ab8:	008b8993          	addi	s3,s7,8
 abc:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 ac0:	02090163          	beqz	s2,ae2 <vprintf+0x15a>
        while (*s != 0) {
 ac4:	00094583          	lbu	a1,0(s2)
 ac8:	c9a5                	beqz	a1,b38 <vprintf+0x1b0>
          putc(fd, *s);
 aca:	8556                	mv	a0,s5
 acc:	00000097          	auipc	ra,0x0
 ad0:	dee080e7          	jalr	-530(ra) # 8ba <putc>
          s++;
 ad4:	0905                	addi	s2,s2,1
        while (*s != 0) {
 ad6:	00094583          	lbu	a1,0(s2)
 ada:	f9e5                	bnez	a1,aca <vprintf+0x142>
        s = va_arg(ap, char *);
 adc:	8bce                	mv	s7,s3
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	b5ed                	j	9ca <vprintf+0x42>
        if (s == 0) s = "(null)";
 ae2:	00000917          	auipc	s2,0x0
 ae6:	70690913          	addi	s2,s2,1798 # 11e8 <loop+0x45a>
        while (*s != 0) {
 aea:	02800593          	li	a1,40
 aee:	bff1                	j	aca <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 af0:	008b8913          	addi	s2,s7,8
 af4:	000bc583          	lbu	a1,0(s7)
 af8:	8556                	mv	a0,s5
 afa:	00000097          	auipc	ra,0x0
 afe:	dc0080e7          	jalr	-576(ra) # 8ba <putc>
 b02:	8bca                	mv	s7,s2
      state = 0;
 b04:	4981                	li	s3,0
 b06:	b5d1                	j	9ca <vprintf+0x42>
        putc(fd, c);
 b08:	02500593          	li	a1,37
 b0c:	8556                	mv	a0,s5
 b0e:	00000097          	auipc	ra,0x0
 b12:	dac080e7          	jalr	-596(ra) # 8ba <putc>
      state = 0;
 b16:	4981                	li	s3,0
 b18:	bd4d                	j	9ca <vprintf+0x42>
        putc(fd, '%');
 b1a:	02500593          	li	a1,37
 b1e:	8556                	mv	a0,s5
 b20:	00000097          	auipc	ra,0x0
 b24:	d9a080e7          	jalr	-614(ra) # 8ba <putc>
        putc(fd, c);
 b28:	85ca                	mv	a1,s2
 b2a:	8556                	mv	a0,s5
 b2c:	00000097          	auipc	ra,0x0
 b30:	d8e080e7          	jalr	-626(ra) # 8ba <putc>
      state = 0;
 b34:	4981                	li	s3,0
 b36:	bd51                	j	9ca <vprintf+0x42>
        s = va_arg(ap, char *);
 b38:	8bce                	mv	s7,s3
      state = 0;
 b3a:	4981                	li	s3,0
 b3c:	b579                	j	9ca <vprintf+0x42>
 b3e:	74e2                	ld	s1,56(sp)
 b40:	79a2                	ld	s3,40(sp)
 b42:	7a02                	ld	s4,32(sp)
 b44:	6ae2                	ld	s5,24(sp)
 b46:	6b42                	ld	s6,16(sp)
 b48:	6ba2                	ld	s7,8(sp)
    }
  }
}
 b4a:	60a6                	ld	ra,72(sp)
 b4c:	6406                	ld	s0,64(sp)
 b4e:	7942                	ld	s2,48(sp)
 b50:	6161                	addi	sp,sp,80
 b52:	8082                	ret

0000000000000b54 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 b54:	715d                	addi	sp,sp,-80
 b56:	ec06                	sd	ra,24(sp)
 b58:	e822                	sd	s0,16(sp)
 b5a:	1000                	addi	s0,sp,32
 b5c:	e010                	sd	a2,0(s0)
 b5e:	e414                	sd	a3,8(s0)
 b60:	e818                	sd	a4,16(s0)
 b62:	ec1c                	sd	a5,24(s0)
 b64:	03043023          	sd	a6,32(s0)
 b68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b70:	8622                	mv	a2,s0
 b72:	00000097          	auipc	ra,0x0
 b76:	e16080e7          	jalr	-490(ra) # 988 <vprintf>
}
 b7a:	60e2                	ld	ra,24(sp)
 b7c:	6442                	ld	s0,16(sp)
 b7e:	6161                	addi	sp,sp,80
 b80:	8082                	ret

0000000000000b82 <printf>:

void printf(const char *fmt, ...) {
 b82:	711d                	addi	sp,sp,-96
 b84:	ec06                	sd	ra,24(sp)
 b86:	e822                	sd	s0,16(sp)
 b88:	1000                	addi	s0,sp,32
 b8a:	e40c                	sd	a1,8(s0)
 b8c:	e810                	sd	a2,16(s0)
 b8e:	ec14                	sd	a3,24(s0)
 b90:	f018                	sd	a4,32(s0)
 b92:	f41c                	sd	a5,40(s0)
 b94:	03043823          	sd	a6,48(s0)
 b98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b9c:	00840613          	addi	a2,s0,8
 ba0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ba4:	85aa                	mv	a1,a0
 ba6:	4505                	li	a0,1
 ba8:	00000097          	auipc	ra,0x0
 bac:	de0080e7          	jalr	-544(ra) # 988 <vprintf>
}
 bb0:	60e2                	ld	ra,24(sp)
 bb2:	6442                	ld	s0,16(sp)
 bb4:	6125                	addi	sp,sp,96
 bb6:	8082                	ret

0000000000000bb8 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 bb8:	1141                	addi	sp,sp,-16
 bba:	e422                	sd	s0,8(sp)
 bbc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 bbe:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc2:	00001797          	auipc	a5,0x1
 bc6:	4467b783          	ld	a5,1094(a5) # 2008 <freep>
 bca:	a02d                	j	bf4 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 bcc:	4618                	lw	a4,8(a2)
 bce:	9f2d                	addw	a4,a4,a1
 bd0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bd4:	6398                	ld	a4,0(a5)
 bd6:	6310                	ld	a2,0(a4)
 bd8:	a83d                	j	c16 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 bda:	ff852703          	lw	a4,-8(a0)
 bde:	9f31                	addw	a4,a4,a2
 be0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 be2:	ff053683          	ld	a3,-16(a0)
 be6:	a091                	j	c2a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 be8:	6398                	ld	a4,0(a5)
 bea:	00e7e463          	bltu	a5,a4,bf2 <free+0x3a>
 bee:	00e6ea63          	bltu	a3,a4,c02 <free+0x4a>
void free(void *ap) {
 bf2:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf4:	fed7fae3          	bgeu	a5,a3,be8 <free+0x30>
 bf8:	6398                	ld	a4,0(a5)
 bfa:	00e6e463          	bltu	a3,a4,c02 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 bfe:	fee7eae3          	bltu	a5,a4,bf2 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 c02:	ff852583          	lw	a1,-8(a0)
 c06:	6390                	ld	a2,0(a5)
 c08:	02059813          	slli	a6,a1,0x20
 c0c:	01c85713          	srli	a4,a6,0x1c
 c10:	9736                	add	a4,a4,a3
 c12:	fae60de3          	beq	a2,a4,bcc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c16:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 c1a:	4790                	lw	a2,8(a5)
 c1c:	02061593          	slli	a1,a2,0x20
 c20:	01c5d713          	srli	a4,a1,0x1c
 c24:	973e                	add	a4,a4,a5
 c26:	fae68ae3          	beq	a3,a4,bda <free+0x22>
    p->s.ptr = bp->s.ptr;
 c2a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c2c:	00001717          	auipc	a4,0x1
 c30:	3cf73e23          	sd	a5,988(a4) # 2008 <freep>
}
 c34:	6422                	ld	s0,8(sp)
 c36:	0141                	addi	sp,sp,16
 c38:	8082                	ret

0000000000000c3a <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 c3a:	7139                	addi	sp,sp,-64
 c3c:	fc06                	sd	ra,56(sp)
 c3e:	f822                	sd	s0,48(sp)
 c40:	f426                	sd	s1,40(sp)
 c42:	ec4e                	sd	s3,24(sp)
 c44:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 c46:	02051493          	slli	s1,a0,0x20
 c4a:	9081                	srli	s1,s1,0x20
 c4c:	04bd                	addi	s1,s1,15
 c4e:	8091                	srli	s1,s1,0x4
 c50:	0014899b          	addiw	s3,s1,1
 c54:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 c56:	00001517          	auipc	a0,0x1
 c5a:	3b253503          	ld	a0,946(a0) # 2008 <freep>
 c5e:	c915                	beqz	a0,c92 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 c60:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c62:	4798                	lw	a4,8(a5)
 c64:	08977e63          	bgeu	a4,s1,d00 <malloc+0xc6>
 c68:	f04a                	sd	s2,32(sp)
 c6a:	e852                	sd	s4,16(sp)
 c6c:	e456                	sd	s5,8(sp)
 c6e:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 c70:	8a4e                	mv	s4,s3
 c72:	0009871b          	sext.w	a4,s3
 c76:	6685                	lui	a3,0x1
 c78:	00d77363          	bgeu	a4,a3,c7e <malloc+0x44>
 c7c:	6a05                	lui	s4,0x1
 c7e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c82:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 c86:	00001917          	auipc	s2,0x1
 c8a:	38290913          	addi	s2,s2,898 # 2008 <freep>
  if (p == (char *)-1) return 0;
 c8e:	5afd                	li	s5,-1
 c90:	a091                	j	cd4 <malloc+0x9a>
 c92:	f04a                	sd	s2,32(sp)
 c94:	e852                	sd	s4,16(sp)
 c96:	e456                	sd	s5,8(sp)
 c98:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c9a:	00001797          	auipc	a5,0x1
 c9e:	37678793          	addi	a5,a5,886 # 2010 <base>
 ca2:	00001717          	auipc	a4,0x1
 ca6:	36f73323          	sd	a5,870(a4) # 2008 <freep>
 caa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cac:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 cb0:	b7c1                	j	c70 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 cb2:	6398                	ld	a4,0(a5)
 cb4:	e118                	sd	a4,0(a0)
 cb6:	a08d                	j	d18 <malloc+0xde>
  hp->s.size = nu;
 cb8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 cbc:	0541                	addi	a0,a0,16
 cbe:	00000097          	auipc	ra,0x0
 cc2:	efa080e7          	jalr	-262(ra) # bb8 <free>
  return freep;
 cc6:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 cca:	c13d                	beqz	a0,d30 <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ccc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 cce:	4798                	lw	a4,8(a5)
 cd0:	02977463          	bgeu	a4,s1,cf8 <malloc+0xbe>
    if (p == freep)
 cd4:	00093703          	ld	a4,0(s2)
 cd8:	853e                	mv	a0,a5
 cda:	fef719e3          	bne	a4,a5,ccc <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 cde:	8552                	mv	a0,s4
 ce0:	00000097          	auipc	ra,0x0
 ce4:	bba080e7          	jalr	-1094(ra) # 89a <sbrk>
  if (p == (char *)-1) return 0;
 ce8:	fd5518e3          	bne	a0,s5,cb8 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 cec:	4501                	li	a0,0
 cee:	7902                	ld	s2,32(sp)
 cf0:	6a42                	ld	s4,16(sp)
 cf2:	6aa2                	ld	s5,8(sp)
 cf4:	6b02                	ld	s6,0(sp)
 cf6:	a03d                	j	d24 <malloc+0xea>
 cf8:	7902                	ld	s2,32(sp)
 cfa:	6a42                	ld	s4,16(sp)
 cfc:	6aa2                	ld	s5,8(sp)
 cfe:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 d00:	fae489e3          	beq	s1,a4,cb2 <malloc+0x78>
        p->s.size -= nunits;
 d04:	4137073b          	subw	a4,a4,s3
 d08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d0a:	02071693          	slli	a3,a4,0x20
 d0e:	01c6d713          	srli	a4,a3,0x1c
 d12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d18:	00001717          	auipc	a4,0x1
 d1c:	2ea73823          	sd	a0,752(a4) # 2008 <freep>
      return (void *)(p + 1);
 d20:	01078513          	addi	a0,a5,16
  }
}
 d24:	70e2                	ld	ra,56(sp)
 d26:	7442                	ld	s0,48(sp)
 d28:	74a2                	ld	s1,40(sp)
 d2a:	69e2                	ld	s3,24(sp)
 d2c:	6121                	addi	sp,sp,64
 d2e:	8082                	ret
 d30:	7902                	ld	s2,32(sp)
 d32:	6a42                	ld	s4,16(sp)
 d34:	6aa2                	ld	s5,8(sp)
 d36:	6b02                	ld	s6,0(sp)
 d38:	b7f5                	j	d24 <malloc+0xea>

0000000000000d3a <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 d3a:	4909                	li	s2,2
  li s3, 3
 d3c:	498d                	li	s3,3
  li s4, 4
 d3e:	4a11                	li	s4,4
  li s5, 5
 d40:	4a95                	li	s5,5
  li s6, 6
 d42:	4b19                	li	s6,6
  li s7, 7
 d44:	4b9d                	li	s7,7
  li s8, 8
 d46:	4c21                	li	s8,8
  li s9, 9
 d48:	4ca5                	li	s9,9
  li s10, 10
 d4a:	4d29                	li	s10,10
  li s11, 11
 d4c:	4dad                	li	s11,11
  li a7, SYS_write
 d4e:	48c1                	li	a7,16
  ecall
 d50:	00000073          	ecall
  j loop
 d54:	a82d                	j	d8e <loop>

0000000000000d56 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 d56:	4911                	li	s2,4
  li s3, 9
 d58:	49a5                	li	s3,9
  li s4, 16
 d5a:	4a41                	li	s4,16
  li s5, 25
 d5c:	4ae5                	li	s5,25
  li s6, 36
 d5e:	02400b13          	li	s6,36
  li s7, 49
 d62:	03100b93          	li	s7,49
  li s8, 64
 d66:	04000c13          	li	s8,64
  li s9, 81
 d6a:	05100c93          	li	s9,81
  li s10, 100
 d6e:	06400d13          	li	s10,100
  li s11, 121
 d72:	07900d93          	li	s11,121
  li a7, SYS_write
 d76:	48c1                	li	a7,16
  ecall
 d78:	00000073          	ecall
  j loop
 d7c:	a809                	j	d8e <loop>

0000000000000d7e <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 d7e:	53900913          	li	s2,1337
  mv a2, a1
 d82:	862e                	mv	a2,a1
  li a1, 2
 d84:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 d86:	48d9                	li	a7,22
  ecall
 d88:	00000073          	ecall
#endif
  ret
 d8c:	8082                	ret

0000000000000d8e <loop>:

loop:
  j loop
 d8e:	a001                	j	d8e <loop>
  ret
 d90:	8082                	ret
