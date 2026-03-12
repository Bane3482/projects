
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rotest_victim>:
    0x13, 0x05, 0xb0, 0x07,  // li a0, 123
    0x89, 0x48,              // li a7, 2
    0x73, 0x00, 0x00, 0x00   // ecall
};

void rotest_victim() { sleep(5); }
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	4515                	li	a0,5
   a:	00001097          	auipc	ra,0x1
   e:	98c080e7          	jalr	-1652(ra) # 996 <sleep>
  12:	60a2                	ld	ra,8(sp)
  14:	6402                	ld	s0,0(sp)
  16:	0141                	addi	sp,sp,16
  18:	8082                	ret

000000000000001a <simpletest>:
void simpletest() {
  1a:	7179                	addi	sp,sp,-48
  1c:	f406                	sd	ra,40(sp)
  1e:	f022                	sd	s0,32(sp)
  20:	ec26                	sd	s1,24(sp)
  22:	e84a                	sd	s2,16(sp)
  24:	e44e                	sd	s3,8(sp)
  26:	1800                	addi	s0,sp,48
  printf("simple: ");
  28:	00001517          	auipc	a0,0x1
  2c:	e0850513          	addi	a0,a0,-504 # e30 <malloc+0x10a>
  30:	00001097          	auipc	ra,0x1
  34:	c3e080e7          	jalr	-962(ra) # c6e <printf>
  char *p = sbrk(sz);
  38:	05555537          	lui	a0,0x5555
  3c:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x554f544>
  40:	00001097          	auipc	ra,0x1
  44:	94e080e7          	jalr	-1714(ra) # 98e <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
  48:	57fd                	li	a5,-1
  4a:	06f50563          	beq	a0,a5,b4 <simpletest+0x9a>
  4e:	84aa                	mv	s1,a0
  for (char *q = p; q < p + sz; q += 4096) {
  50:	05556937          	lui	s2,0x5556
  54:	992a                	add	s2,s2,a0
  56:	6985                	lui	s3,0x1
    *(int *)q = getpid();
  58:	00001097          	auipc	ra,0x1
  5c:	92e080e7          	jalr	-1746(ra) # 986 <getpid>
  60:	c088                	sw	a0,0(s1)
  for (char *q = p; q < p + sz; q += 4096) {
  62:	94ce                	add	s1,s1,s3
  64:	ff249ae3          	bne	s1,s2,58 <simpletest+0x3e>
  int pid = fork();
  68:	00001097          	auipc	ra,0x1
  6c:	896080e7          	jalr	-1898(ra) # 8fe <fork>
  if (pid < 0) {
  70:	06054363          	bltz	a0,d6 <simpletest+0xbc>
  if (pid == 0) exit(0);
  74:	cd35                	beqz	a0,f0 <simpletest+0xd6>
  wait(0);
  76:	4501                	li	a0,0
  78:	00001097          	auipc	ra,0x1
  7c:	896080e7          	jalr	-1898(ra) # 90e <wait>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
  80:	faaab537          	lui	a0,0xfaaab
  84:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa4a9c>
  88:	00001097          	auipc	ra,0x1
  8c:	906080e7          	jalr	-1786(ra) # 98e <sbrk>
  90:	57fd                	li	a5,-1
  92:	06f50363          	beq	a0,a5,f8 <simpletest+0xde>
  printf("ok\n");
  96:	00001517          	auipc	a0,0x1
  9a:	dea50513          	addi	a0,a0,-534 # e80 <malloc+0x15a>
  9e:	00001097          	auipc	ra,0x1
  a2:	bd0080e7          	jalr	-1072(ra) # c6e <printf>
}
  a6:	70a2                	ld	ra,40(sp)
  a8:	7402                	ld	s0,32(sp)
  aa:	64e2                	ld	s1,24(sp)
  ac:	6942                	ld	s2,16(sp)
  ae:	69a2                	ld	s3,8(sp)
  b0:	6145                	addi	sp,sp,48
  b2:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  b4:	055555b7          	lui	a1,0x5555
  b8:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
  bc:	00001517          	auipc	a0,0x1
  c0:	d8450513          	addi	a0,a0,-636 # e40 <malloc+0x11a>
  c4:	00001097          	auipc	ra,0x1
  c8:	baa080e7          	jalr	-1110(ra) # c6e <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00001097          	auipc	ra,0x1
  d2:	838080e7          	jalr	-1992(ra) # 906 <exit>
    printf("fork() failed\n");
  d6:	00001517          	auipc	a0,0x1
  da:	d8250513          	addi	a0,a0,-638 # e58 <malloc+0x132>
  de:	00001097          	auipc	ra,0x1
  e2:	b90080e7          	jalr	-1136(ra) # c6e <printf>
    exit(-1);
  e6:	557d                	li	a0,-1
  e8:	00001097          	auipc	ra,0x1
  ec:	81e080e7          	jalr	-2018(ra) # 906 <exit>
  if (pid == 0) exit(0);
  f0:	00001097          	auipc	ra,0x1
  f4:	816080e7          	jalr	-2026(ra) # 906 <exit>
    printf("sbrk(-%d) failed\n", sz);
  f8:	055555b7          	lui	a1,0x5555
  fc:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
 100:	00001517          	auipc	a0,0x1
 104:	d6850513          	addi	a0,a0,-664 # e68 <malloc+0x142>
 108:	00001097          	auipc	ra,0x1
 10c:	b66080e7          	jalr	-1178(ra) # c6e <printf>
    exit(-1);
 110:	557d                	li	a0,-1
 112:	00000097          	auipc	ra,0x0
 116:	7f4080e7          	jalr	2036(ra) # 906 <exit>

000000000000011a <threetest>:
void threetest() {
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  printf("three: ");
 12a:	00001517          	auipc	a0,0x1
 12e:	d5e50513          	addi	a0,a0,-674 # e88 <malloc+0x162>
 132:	00001097          	auipc	ra,0x1
 136:	b3c080e7          	jalr	-1220(ra) # c6e <printf>
  char *p = sbrk(sz);
 13a:	02000537          	lui	a0,0x2000
 13e:	00001097          	auipc	ra,0x1
 142:	850080e7          	jalr	-1968(ra) # 98e <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
 146:	57fd                	li	a5,-1
 148:	08f50763          	beq	a0,a5,1d6 <threetest+0xbc>
 14c:	84aa                	mv	s1,a0
  pid1 = fork();
 14e:	00000097          	auipc	ra,0x0
 152:	7b0080e7          	jalr	1968(ra) # 8fe <fork>
  if (pid1 < 0) {
 156:	08054f63          	bltz	a0,1f4 <threetest+0xda>
  if (pid1 == 0) {
 15a:	c955                	beqz	a0,20e <threetest+0xf4>
  for (char *q = p; q < p + sz; q += 4096) {
 15c:	020009b7          	lui	s3,0x2000
 160:	99a6                	add	s3,s3,s1
 162:	8926                	mv	s2,s1
 164:	6a05                	lui	s4,0x1
    *(int *)q = getpid();
 166:	00001097          	auipc	ra,0x1
 16a:	820080e7          	jalr	-2016(ra) # 986 <getpid>
 16e:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x554fff0>
  for (char *q = p; q < p + sz; q += 4096) {
 172:	9952                	add	s2,s2,s4
 174:	ff3919e3          	bne	s2,s3,166 <threetest+0x4c>
  wait(0);
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	794080e7          	jalr	1940(ra) # 90e <wait>
  sleep(1);
 182:	4505                	li	a0,1
 184:	00001097          	auipc	ra,0x1
 188:	812080e7          	jalr	-2030(ra) # 996 <sleep>
  for (char *q = p; q < p + sz; q += 4096) {
 18c:	6a05                	lui	s4,0x1
    if (*(int *)q != getpid()) {
 18e:	0004a903          	lw	s2,0(s1)
 192:	00000097          	auipc	ra,0x0
 196:	7f4080e7          	jalr	2036(ra) # 986 <getpid>
 19a:	10a91a63          	bne	s2,a0,2ae <threetest+0x194>
  for (char *q = p; q < p + sz; q += 4096) {
 19e:	94d2                	add	s1,s1,s4
 1a0:	ff3497e3          	bne	s1,s3,18e <threetest+0x74>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
 1a4:	fe000537          	lui	a0,0xfe000
 1a8:	00000097          	auipc	ra,0x0
 1ac:	7e6080e7          	jalr	2022(ra) # 98e <sbrk>
 1b0:	57fd                	li	a5,-1
 1b2:	10f50b63          	beq	a0,a5,2c8 <threetest+0x1ae>
  printf("ok\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	cca50513          	addi	a0,a0,-822 # e80 <malloc+0x15a>
 1be:	00001097          	auipc	ra,0x1
 1c2:	ab0080e7          	jalr	-1360(ra) # c6e <printf>
}
 1c6:	70a2                	ld	ra,40(sp)
 1c8:	7402                	ld	s0,32(sp)
 1ca:	64e2                	ld	s1,24(sp)
 1cc:	6942                	ld	s2,16(sp)
 1ce:	69a2                	ld	s3,8(sp)
 1d0:	6a02                	ld	s4,0(sp)
 1d2:	6145                	addi	sp,sp,48
 1d4:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1d6:	020005b7          	lui	a1,0x2000
 1da:	00001517          	auipc	a0,0x1
 1de:	c6650513          	addi	a0,a0,-922 # e40 <malloc+0x11a>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	a8c080e7          	jalr	-1396(ra) # c6e <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	71a080e7          	jalr	1818(ra) # 906 <exit>
    printf("fork failed\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	c9c50513          	addi	a0,a0,-868 # e90 <malloc+0x16a>
 1fc:	00001097          	auipc	ra,0x1
 200:	a72080e7          	jalr	-1422(ra) # c6e <printf>
    exit(-1);
 204:	557d                	li	a0,-1
 206:	00000097          	auipc	ra,0x0
 20a:	700080e7          	jalr	1792(ra) # 906 <exit>
    pid2 = fork();
 20e:	00000097          	auipc	ra,0x0
 212:	6f0080e7          	jalr	1776(ra) # 8fe <fork>
    if (pid2 < 0) {
 216:	04054263          	bltz	a0,25a <threetest+0x140>
    if (pid2 == 0) {
 21a:	ed29                	bnez	a0,274 <threetest+0x15a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 21c:	0199a9b7          	lui	s3,0x199a
 220:	99a6                	add	s3,s3,s1
 222:	8926                	mv	s2,s1
 224:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 226:	00000097          	auipc	ra,0x0
 22a:	760080e7          	jalr	1888(ra) # 986 <getpid>
 22e:	00a92023          	sw	a0,0(s2)
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 232:	9952                	add	s2,s2,s4
 234:	ff3919e3          	bne	s2,s3,226 <threetest+0x10c>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 238:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid()) {
 23a:	0004a903          	lw	s2,0(s1)
 23e:	00000097          	auipc	ra,0x0
 242:	748080e7          	jalr	1864(ra) # 986 <getpid>
 246:	04a91763          	bne	s2,a0,294 <threetest+0x17a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 24a:	94d2                	add	s1,s1,s4
 24c:	ff3497e3          	bne	s1,s3,23a <threetest+0x120>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	6b4080e7          	jalr	1716(ra) # 906 <exit>
      printf("fork failed");
 25a:	00001517          	auipc	a0,0x1
 25e:	c4650513          	addi	a0,a0,-954 # ea0 <malloc+0x17a>
 262:	00001097          	auipc	ra,0x1
 266:	a0c080e7          	jalr	-1524(ra) # c6e <printf>
      exit(-1);
 26a:	557d                	li	a0,-1
 26c:	00000097          	auipc	ra,0x0
 270:	69a080e7          	jalr	1690(ra) # 906 <exit>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 274:	01000737          	lui	a4,0x1000
 278:	9726                	add	a4,a4,s1
      *(int *)q = 9999;
 27a:	6789                	lui	a5,0x2
 27c:	70f78793          	addi	a5,a5,1807 # 270f <junk3+0x6ff>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 280:	6685                	lui	a3,0x1
      *(int *)q = 9999;
 282:	c09c                	sw	a5,0(s1)
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 284:	94b6                	add	s1,s1,a3
 286:	fee49ee3          	bne	s1,a4,282 <threetest+0x168>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	67a080e7          	jalr	1658(ra) # 906 <exit>
          printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	c1c50513          	addi	a0,a0,-996 # eb0 <malloc+0x18a>
 29c:	00001097          	auipc	ra,0x1
 2a0:	9d2080e7          	jalr	-1582(ra) # c6e <printf>
          exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	660080e7          	jalr	1632(ra) # 906 <exit>
      printf("wrong content\n");
 2ae:	00001517          	auipc	a0,0x1
 2b2:	c0250513          	addi	a0,a0,-1022 # eb0 <malloc+0x18a>
 2b6:	00001097          	auipc	ra,0x1
 2ba:	9b8080e7          	jalr	-1608(ra) # c6e <printf>
      exit(-1);
 2be:	557d                	li	a0,-1
 2c0:	00000097          	auipc	ra,0x0
 2c4:	646080e7          	jalr	1606(ra) # 906 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2c8:	020005b7          	lui	a1,0x2000
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b9c50513          	addi	a0,a0,-1124 # e68 <malloc+0x142>
 2d4:	00001097          	auipc	ra,0x1
 2d8:	99a080e7          	jalr	-1638(ra) # c6e <printf>
    exit(-1);
 2dc:	557d                	li	a0,-1
 2de:	00000097          	auipc	ra,0x0
 2e2:	628080e7          	jalr	1576(ra) # 906 <exit>

00000000000002e6 <filetest>:
void filetest() {
 2e6:	7179                	addi	sp,sp,-48
 2e8:	f406                	sd	ra,40(sp)
 2ea:	f022                	sd	s0,32(sp)
 2ec:	ec26                	sd	s1,24(sp)
 2ee:	e84a                	sd	s2,16(sp)
 2f0:	1800                	addi	s0,sp,48
  printf("file: ");
 2f2:	00001517          	auipc	a0,0x1
 2f6:	bce50513          	addi	a0,a0,-1074 # ec0 <malloc+0x19a>
 2fa:	00001097          	auipc	ra,0x1
 2fe:	974080e7          	jalr	-1676(ra) # c6e <printf>
  buf[0] = 99;
 302:	06300793          	li	a5,99
 306:	00003717          	auipc	a4,0x3
 30a:	d0f70523          	sb	a5,-758(a4) # 3010 <buf>
  for (int i = 0; i < 4; i++) {
 30e:	fc042c23          	sw	zero,-40(s0)
    if (pipe(fds) != 0) {
 312:	00002497          	auipc	s1,0x2
 316:	cee48493          	addi	s1,s1,-786 # 2000 <fds>
  for (int i = 0; i < 4; i++) {
 31a:	490d                	li	s2,3
    if (pipe(fds) != 0) {
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	5f8080e7          	jalr	1528(ra) # 916 <pipe>
 326:	e149                	bnez	a0,3a8 <filetest+0xc2>
    int pid = fork();
 328:	00000097          	auipc	ra,0x0
 32c:	5d6080e7          	jalr	1494(ra) # 8fe <fork>
    if (pid < 0) {
 330:	08054963          	bltz	a0,3c2 <filetest+0xdc>
    if (pid == 0) {
 334:	c545                	beqz	a0,3dc <filetest+0xf6>
    if (write(fds[1], &i, sizeof(i)) != sizeof(i)) {
 336:	4611                	li	a2,4
 338:	fd840593          	addi	a1,s0,-40
 33c:	40c8                	lw	a0,4(s1)
 33e:	00000097          	auipc	ra,0x0
 342:	5e8080e7          	jalr	1512(ra) # 926 <write>
 346:	4791                	li	a5,4
 348:	10f51b63          	bne	a0,a5,45e <filetest+0x178>
  for (int i = 0; i < 4; i++) {
 34c:	fd842783          	lw	a5,-40(s0)
 350:	2785                	addiw	a5,a5,1
 352:	0007871b          	sext.w	a4,a5
 356:	fcf42c23          	sw	a5,-40(s0)
 35a:	fce951e3          	bge	s2,a4,31c <filetest+0x36>
  int xstatus = 0;
 35e:	fc042e23          	sw	zero,-36(s0)
 362:	4491                	li	s1,4
    wait(&xstatus);
 364:	fdc40513          	addi	a0,s0,-36
 368:	00000097          	auipc	ra,0x0
 36c:	5a6080e7          	jalr	1446(ra) # 90e <wait>
    if (xstatus != 0) {
 370:	fdc42783          	lw	a5,-36(s0)
 374:	10079263          	bnez	a5,478 <filetest+0x192>
  for (int i = 0; i < 4; i++) {
 378:	34fd                	addiw	s1,s1,-1
 37a:	f4ed                	bnez	s1,364 <filetest+0x7e>
  if (buf[0] != 99) {
 37c:	00003717          	auipc	a4,0x3
 380:	c9474703          	lbu	a4,-876(a4) # 3010 <buf>
 384:	06300793          	li	a5,99
 388:	0ef71d63          	bne	a4,a5,482 <filetest+0x19c>
  printf("ok\n");
 38c:	00001517          	auipc	a0,0x1
 390:	af450513          	addi	a0,a0,-1292 # e80 <malloc+0x15a>
 394:	00001097          	auipc	ra,0x1
 398:	8da080e7          	jalr	-1830(ra) # c6e <printf>
}
 39c:	70a2                	ld	ra,40(sp)
 39e:	7402                	ld	s0,32(sp)
 3a0:	64e2                	ld	s1,24(sp)
 3a2:	6942                	ld	s2,16(sp)
 3a4:	6145                	addi	sp,sp,48
 3a6:	8082                	ret
      printf("pipe() failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	b2050513          	addi	a0,a0,-1248 # ec8 <malloc+0x1a2>
 3b0:	00001097          	auipc	ra,0x1
 3b4:	8be080e7          	jalr	-1858(ra) # c6e <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	54c080e7          	jalr	1356(ra) # 906 <exit>
      printf("fork failed\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	ace50513          	addi	a0,a0,-1330 # e90 <malloc+0x16a>
 3ca:	00001097          	auipc	ra,0x1
 3ce:	8a4080e7          	jalr	-1884(ra) # c6e <printf>
      exit(-1);
 3d2:	557d                	li	a0,-1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	532080e7          	jalr	1330(ra) # 906 <exit>
      sleep(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	5b8080e7          	jalr	1464(ra) # 996 <sleep>
      if (read(fds[0], buf, sizeof(i)) != sizeof(i)) {
 3e6:	4611                	li	a2,4
 3e8:	00003597          	auipc	a1,0x3
 3ec:	c2858593          	addi	a1,a1,-984 # 3010 <buf>
 3f0:	00002517          	auipc	a0,0x2
 3f4:	c1052503          	lw	a0,-1008(a0) # 2000 <fds>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	526080e7          	jalr	1318(ra) # 91e <read>
 400:	4791                	li	a5,4
 402:	02f51c63          	bne	a0,a5,43a <filetest+0x154>
      sleep(1);
 406:	4505                	li	a0,1
 408:	00000097          	auipc	ra,0x0
 40c:	58e080e7          	jalr	1422(ra) # 996 <sleep>
      if (j != i) {
 410:	fd842703          	lw	a4,-40(s0)
 414:	00003797          	auipc	a5,0x3
 418:	bfc7a783          	lw	a5,-1028(a5) # 3010 <buf>
 41c:	02f70c63          	beq	a4,a5,454 <filetest+0x16e>
        printf("error: read the wrong value\n");
 420:	00001517          	auipc	a0,0x1
 424:	ad050513          	addi	a0,a0,-1328 # ef0 <malloc+0x1ca>
 428:	00001097          	auipc	ra,0x1
 42c:	846080e7          	jalr	-1978(ra) # c6e <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	4d4080e7          	jalr	1236(ra) # 906 <exit>
        printf("error: read failed\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	a9e50513          	addi	a0,a0,-1378 # ed8 <malloc+0x1b2>
 442:	00001097          	auipc	ra,0x1
 446:	82c080e7          	jalr	-2004(ra) # c6e <printf>
        exit(1);
 44a:	4505                	li	a0,1
 44c:	00000097          	auipc	ra,0x0
 450:	4ba080e7          	jalr	1210(ra) # 906 <exit>
      exit(0);
 454:	4501                	li	a0,0
 456:	00000097          	auipc	ra,0x0
 45a:	4b0080e7          	jalr	1200(ra) # 906 <exit>
      printf("error: write failed\n");
 45e:	00001517          	auipc	a0,0x1
 462:	ab250513          	addi	a0,a0,-1358 # f10 <malloc+0x1ea>
 466:	00001097          	auipc	ra,0x1
 46a:	808080e7          	jalr	-2040(ra) # c6e <printf>
      exit(-1);
 46e:	557d                	li	a0,-1
 470:	00000097          	auipc	ra,0x0
 474:	496080e7          	jalr	1174(ra) # 906 <exit>
      exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	48c080e7          	jalr	1164(ra) # 906 <exit>
    printf("error: child overwrote parent\n");
 482:	00001517          	auipc	a0,0x1
 486:	aa650513          	addi	a0,a0,-1370 # f28 <malloc+0x202>
 48a:	00000097          	auipc	ra,0x0
 48e:	7e4080e7          	jalr	2020(ra) # c6e <printf>
    exit(1);
 492:	4505                	li	a0,1
 494:	00000097          	auipc	ra,0x0
 498:	472080e7          	jalr	1138(ra) # 906 <exit>

000000000000049c <rotest>:

typedef void (*func)();

// Checks that PTE access flags are not overwritten with incorrect values.
void rotest() {
 49c:	7179                	addi	sp,sp,-48
 49e:	f406                	sd	ra,40(sp)
 4a0:	f022                	sd	s0,32(sp)
 4a2:	ec26                	sd	s1,24(sp)
 4a4:	1800                	addi	s0,sp,48
  printf("ro: ");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	aa250513          	addi	a0,a0,-1374 # f48 <malloc+0x222>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	7c0080e7          	jalr	1984(ra) # c6e <printf>

  int pid1 = fork();
 4b6:	00000097          	auipc	ra,0x0
 4ba:	448080e7          	jalr	1096(ra) # 8fe <fork>

  if (pid1 > 0) {
 4be:	0aa05663          	blez	a0,56a <rotest+0xce>
 4c2:	84aa                	mv	s1,a0
    int xstatus;
    if (wait(&xstatus) != pid1) {
 4c4:	fdc40513          	addi	a0,s0,-36
 4c8:	00000097          	auipc	ra,0x0
 4cc:	446080e7          	jalr	1094(ra) # 90e <wait>
 4d0:	02951963          	bne	a0,s1,502 <rotest+0x66>
      printf("error: first child not found\n");
      exit(1);
    }

    if (xstatus == 123) {
 4d4:	fdc42783          	lw	a5,-36(s0)
 4d8:	07b00713          	li	a4,123
 4dc:	04e78063          	beq	a5,a4,51c <rotest+0x80>
      printf("error: parent memory corrupted\n");
      exit(1);
    } else if (xstatus == 1) {
 4e0:	4705                	li	a4,1
 4e2:	04e78a63          	beq	a5,a4,536 <rotest+0x9a>
      printf("failed\n");
      exit(1);
    } else if (xstatus != 0) {
 4e6:	e7ad                	bnez	a5,550 <rotest+0xb4>
      printf("error: unexpected first child exit code %d\n");
      exit(1);
    }

    printf("ok\n");
 4e8:	00001517          	auipc	a0,0x1
 4ec:	99850513          	addi	a0,a0,-1640 # e80 <malloc+0x15a>
 4f0:	00000097          	auipc	ra,0x0
 4f4:	77e080e7          	jalr	1918(ra) # c6e <printf>

  memmove(rotest_victim, HACK, sizeof(HACK));
  rotest_victim();

  exit(0);
}
 4f8:	70a2                	ld	ra,40(sp)
 4fa:	7402                	ld	s0,32(sp)
 4fc:	64e2                	ld	s1,24(sp)
 4fe:	6145                	addi	sp,sp,48
 500:	8082                	ret
      printf("error: first child not found\n");
 502:	00001517          	auipc	a0,0x1
 506:	a4e50513          	addi	a0,a0,-1458 # f50 <malloc+0x22a>
 50a:	00000097          	auipc	ra,0x0
 50e:	764080e7          	jalr	1892(ra) # c6e <printf>
      exit(1);
 512:	4505                	li	a0,1
 514:	00000097          	auipc	ra,0x0
 518:	3f2080e7          	jalr	1010(ra) # 906 <exit>
      printf("error: parent memory corrupted\n");
 51c:	00001517          	auipc	a0,0x1
 520:	a5450513          	addi	a0,a0,-1452 # f70 <malloc+0x24a>
 524:	00000097          	auipc	ra,0x0
 528:	74a080e7          	jalr	1866(ra) # c6e <printf>
      exit(1);
 52c:	4505                	li	a0,1
 52e:	00000097          	auipc	ra,0x0
 532:	3d8080e7          	jalr	984(ra) # 906 <exit>
      printf("failed\n");
 536:	00001517          	auipc	a0,0x1
 53a:	a5a50513          	addi	a0,a0,-1446 # f90 <malloc+0x26a>
 53e:	00000097          	auipc	ra,0x0
 542:	730080e7          	jalr	1840(ra) # c6e <printf>
      exit(1);
 546:	4505                	li	a0,1
 548:	00000097          	auipc	ra,0x0
 54c:	3be080e7          	jalr	958(ra) # 906 <exit>
      printf("error: unexpected first child exit code %d\n");
 550:	00001517          	auipc	a0,0x1
 554:	a4850513          	addi	a0,a0,-1464 # f98 <malloc+0x272>
 558:	00000097          	auipc	ra,0x0
 55c:	716080e7          	jalr	1814(ra) # c6e <printf>
      exit(1);
 560:	4505                	li	a0,1
 562:	00000097          	auipc	ra,0x0
 566:	3a4080e7          	jalr	932(ra) # 906 <exit>
  int pid2 = fork();
 56a:	00000097          	auipc	ra,0x0
 56e:	394080e7          	jalr	916(ra) # 8fe <fork>
 572:	84aa                	mv	s1,a0
  if (pid2 > 0) {
 574:	08a05363          	blez	a0,5fa <rotest+0x15e>
    if (wait(&xstatus) != pid2) {
 578:	fdc40513          	addi	a0,s0,-36
 57c:	00000097          	auipc	ra,0x0
 580:	392080e7          	jalr	914(ra) # 90e <wait>
 584:	02951c63          	bne	a0,s1,5bc <rotest+0x120>
    rotest_victim();
 588:	00000097          	auipc	ra,0x0
 58c:	a78080e7          	jalr	-1416(ra) # 0 <rotest_victim>
    if (xstatus == 123) {
 590:	fdc42583          	lw	a1,-36(s0)
 594:	07b00793          	li	a5,123
 598:	02f58f63          	beq	a1,a5,5d6 <rotest+0x13a>
    } else if (xstatus != -1) {
 59c:	57fd                	li	a5,-1
 59e:	04f58963          	beq	a1,a5,5f0 <rotest+0x154>
      printf("error: unexpected second child exit code %d\n", xstatus);
 5a2:	00001517          	auipc	a0,0x1
 5a6:	a6650513          	addi	a0,a0,-1434 # 1008 <malloc+0x2e2>
 5aa:	00000097          	auipc	ra,0x0
 5ae:	6c4080e7          	jalr	1732(ra) # c6e <printf>
      exit(1);
 5b2:	4505                	li	a0,1
 5b4:	00000097          	auipc	ra,0x0
 5b8:	352080e7          	jalr	850(ra) # 906 <exit>
      printf("error: second child not found\n");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	a0c50513          	addi	a0,a0,-1524 # fc8 <malloc+0x2a2>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	6aa080e7          	jalr	1706(ra) # c6e <printf>
      exit(1);
 5cc:	4505                	li	a0,1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	338080e7          	jalr	824(ra) # 906 <exit>
      printf("error: self memory corrupted\n");
 5d6:	00001517          	auipc	a0,0x1
 5da:	a1250513          	addi	a0,a0,-1518 # fe8 <malloc+0x2c2>
 5de:	00000097          	auipc	ra,0x0
 5e2:	690080e7          	jalr	1680(ra) # c6e <printf>
      exit(1);
 5e6:	4505                	li	a0,1
 5e8:	00000097          	auipc	ra,0x0
 5ec:	31e080e7          	jalr	798(ra) # 906 <exit>
    exit(0);
 5f0:	4501                	li	a0,0
 5f2:	00000097          	auipc	ra,0x0
 5f6:	314080e7          	jalr	788(ra) # 906 <exit>
  memmove(rotest_victim, HACK, sizeof(HACK));
 5fa:	4629                	li	a2,10
 5fc:	00001597          	auipc	a1,0x1
 600:	a5c58593          	addi	a1,a1,-1444 # 1058 <HACK>
 604:	00000517          	auipc	a0,0x0
 608:	9fc50513          	addi	a0,a0,-1540 # 0 <rotest_victim>
 60c:	00000097          	auipc	ra,0x0
 610:	248080e7          	jalr	584(ra) # 854 <memmove>
  rotest_victim();
 614:	00000097          	auipc	ra,0x0
 618:	9ec080e7          	jalr	-1556(ra) # 0 <rotest_victim>
  exit(0);
 61c:	4501                	li	a0,0
 61e:	00000097          	auipc	ra,0x0
 622:	2e8080e7          	jalr	744(ra) # 906 <exit>

0000000000000626 <main>:

int main(int argc, char *argv[]) {
 626:	1141                	addi	sp,sp,-16
 628:	e406                	sd	ra,8(sp)
 62a:	e022                	sd	s0,0(sp)
 62c:	0800                	addi	s0,sp,16
  simpletest();
 62e:	00000097          	auipc	ra,0x0
 632:	9ec080e7          	jalr	-1556(ra) # 1a <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 636:	00000097          	auipc	ra,0x0
 63a:	9e4080e7          	jalr	-1564(ra) # 1a <simpletest>

  threetest();
 63e:	00000097          	auipc	ra,0x0
 642:	adc080e7          	jalr	-1316(ra) # 11a <threetest>
  threetest();
 646:	00000097          	auipc	ra,0x0
 64a:	ad4080e7          	jalr	-1324(ra) # 11a <threetest>
  threetest();
 64e:	00000097          	auipc	ra,0x0
 652:	acc080e7          	jalr	-1332(ra) # 11a <threetest>

  filetest();
 656:	00000097          	auipc	ra,0x0
 65a:	c90080e7          	jalr	-880(ra) # 2e6 <filetest>

  rotest();
 65e:	00000097          	auipc	ra,0x0
 662:	e3e080e7          	jalr	-450(ra) # 49c <rotest>

  printf("ALL COW TESTS PASSED\n");
 666:	00001517          	auipc	a0,0x1
 66a:	9d250513          	addi	a0,a0,-1582 # 1038 <malloc+0x312>
 66e:	00000097          	auipc	ra,0x0
 672:	600080e7          	jalr	1536(ra) # c6e <printf>

  exit(0);
 676:	4501                	li	a0,0
 678:	00000097          	auipc	ra,0x0
 67c:	28e080e7          	jalr	654(ra) # 906 <exit>

0000000000000680 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 680:	1141                	addi	sp,sp,-16
 682:	e406                	sd	ra,8(sp)
 684:	e022                	sd	s0,0(sp)
 686:	0800                	addi	s0,sp,16
  extern int main();
  main();
 688:	00000097          	auipc	ra,0x0
 68c:	f9e080e7          	jalr	-98(ra) # 626 <main>
  exit(0);
 690:	4501                	li	a0,0
 692:	00000097          	auipc	ra,0x0
 696:	274080e7          	jalr	628(ra) # 906 <exit>

000000000000069a <strcpy>:
}

char *strcpy(char *s, const char *t) {
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 6a0:	87aa                	mv	a5,a0
 6a2:	0585                	addi	a1,a1,1
 6a4:	0785                	addi	a5,a5,1
 6a6:	fff5c703          	lbu	a4,-1(a1)
 6aa:	fee78fa3          	sb	a4,-1(a5)
 6ae:	fb75                	bnez	a4,6a2 <strcpy+0x8>
  return os;
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret

00000000000006b6 <strcmp>:

int strcmp(const char *p, const char *q) {
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e422                	sd	s0,8(sp)
 6ba:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 6bc:	00054783          	lbu	a5,0(a0)
 6c0:	cb91                	beqz	a5,6d4 <strcmp+0x1e>
 6c2:	0005c703          	lbu	a4,0(a1)
 6c6:	00f71763          	bne	a4,a5,6d4 <strcmp+0x1e>
 6ca:	0505                	addi	a0,a0,1
 6cc:	0585                	addi	a1,a1,1
 6ce:	00054783          	lbu	a5,0(a0)
 6d2:	fbe5                	bnez	a5,6c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 6d4:	0005c503          	lbu	a0,0(a1)
}
 6d8:	40a7853b          	subw	a0,a5,a0
 6dc:	6422                	ld	s0,8(sp)
 6de:	0141                	addi	sp,sp,16
 6e0:	8082                	ret

00000000000006e2 <strlen>:

uint strlen(const char *s) {
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	cf91                	beqz	a5,708 <strlen+0x26>
 6ee:	0505                	addi	a0,a0,1
 6f0:	87aa                	mv	a5,a0
 6f2:	86be                	mv	a3,a5
 6f4:	0785                	addi	a5,a5,1
 6f6:	fff7c703          	lbu	a4,-1(a5)
 6fa:	ff65                	bnez	a4,6f2 <strlen+0x10>
 6fc:	40a6853b          	subw	a0,a3,a0
 700:	2505                	addiw	a0,a0,1
  return n;
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret
  for (n = 0; s[n]; n++);
 708:	4501                	li	a0,0
 70a:	bfe5                	j	702 <strlen+0x20>

000000000000070c <memset>:

void *memset(void *dst, int c, uint n) {
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 712:	ca19                	beqz	a2,728 <memset+0x1c>
 714:	87aa                	mv	a5,a0
 716:	1602                	slli	a2,a2,0x20
 718:	9201                	srli	a2,a2,0x20
 71a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 71e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 722:	0785                	addi	a5,a5,1
 724:	fee79de3          	bne	a5,a4,71e <memset+0x12>
  }
  return dst;
}
 728:	6422                	ld	s0,8(sp)
 72a:	0141                	addi	sp,sp,16
 72c:	8082                	ret

000000000000072e <strchr>:

char *strchr(const char *s, char c) {
 72e:	1141                	addi	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	addi	s0,sp,16
  for (; *s; s++)
 734:	00054783          	lbu	a5,0(a0)
 738:	cb99                	beqz	a5,74e <strchr+0x20>
    if (*s == c) return (char *)s;
 73a:	00f58763          	beq	a1,a5,748 <strchr+0x1a>
  for (; *s; s++)
 73e:	0505                	addi	a0,a0,1
 740:	00054783          	lbu	a5,0(a0)
 744:	fbfd                	bnez	a5,73a <strchr+0xc>
  return 0;
 746:	4501                	li	a0,0
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	addi	sp,sp,16
 74c:	8082                	ret
  return 0;
 74e:	4501                	li	a0,0
 750:	bfe5                	j	748 <strchr+0x1a>

0000000000000752 <gets>:

char *gets(char *buf, int max) {
 752:	711d                	addi	sp,sp,-96
 754:	ec86                	sd	ra,88(sp)
 756:	e8a2                	sd	s0,80(sp)
 758:	e4a6                	sd	s1,72(sp)
 75a:	e0ca                	sd	s2,64(sp)
 75c:	fc4e                	sd	s3,56(sp)
 75e:	f852                	sd	s4,48(sp)
 760:	f456                	sd	s5,40(sp)
 762:	f05a                	sd	s6,32(sp)
 764:	ec5e                	sd	s7,24(sp)
 766:	1080                	addi	s0,sp,96
 768:	8baa                	mv	s7,a0
 76a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 76c:	892a                	mv	s2,a0
 76e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 770:	4aa9                	li	s5,10
 772:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 774:	89a6                	mv	s3,s1
 776:	2485                	addiw	s1,s1,1
 778:	0344d863          	bge	s1,s4,7a8 <gets+0x56>
    cc = read(0, &c, 1);
 77c:	4605                	li	a2,1
 77e:	faf40593          	addi	a1,s0,-81
 782:	4501                	li	a0,0
 784:	00000097          	auipc	ra,0x0
 788:	19a080e7          	jalr	410(ra) # 91e <read>
    if (cc < 1) break;
 78c:	00a05e63          	blez	a0,7a8 <gets+0x56>
    buf[i++] = c;
 790:	faf44783          	lbu	a5,-81(s0)
 794:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 798:	01578763          	beq	a5,s5,7a6 <gets+0x54>
 79c:	0905                	addi	s2,s2,1
 79e:	fd679be3          	bne	a5,s6,774 <gets+0x22>
    buf[i++] = c;
 7a2:	89a6                	mv	s3,s1
 7a4:	a011                	j	7a8 <gets+0x56>
 7a6:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 7a8:	99de                	add	s3,s3,s7
 7aa:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1993ff0>
  return buf;
}
 7ae:	855e                	mv	a0,s7
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6906                	ld	s2,64(sp)
 7b8:	79e2                	ld	s3,56(sp)
 7ba:	7a42                	ld	s4,48(sp)
 7bc:	7aa2                	ld	s5,40(sp)
 7be:	7b02                	ld	s6,32(sp)
 7c0:	6be2                	ld	s7,24(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret

00000000000007c6 <stat>:

int stat(const char *n, struct stat *st) {
 7c6:	1101                	addi	sp,sp,-32
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	e04a                	sd	s2,0(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7d2:	4581                	li	a1,0
 7d4:	00000097          	auipc	ra,0x0
 7d8:	172080e7          	jalr	370(ra) # 946 <open>
  if (fd < 0) return -1;
 7dc:	02054663          	bltz	a0,808 <stat+0x42>
 7e0:	e426                	sd	s1,8(sp)
 7e2:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 7e4:	85ca                	mv	a1,s2
 7e6:	00000097          	auipc	ra,0x0
 7ea:	178080e7          	jalr	376(ra) # 95e <fstat>
 7ee:	892a                	mv	s2,a0
  close(fd);
 7f0:	8526                	mv	a0,s1
 7f2:	00000097          	auipc	ra,0x0
 7f6:	13c080e7          	jalr	316(ra) # 92e <close>
  return r;
 7fa:	64a2                	ld	s1,8(sp)
}
 7fc:	854a                	mv	a0,s2
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6902                	ld	s2,0(sp)
 804:	6105                	addi	sp,sp,32
 806:	8082                	ret
  if (fd < 0) return -1;
 808:	597d                	li	s2,-1
 80a:	bfcd                	j	7fc <stat+0x36>

000000000000080c <atoi>:

int atoi(const char *s) {
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 812:	00054683          	lbu	a3,0(a0)
 816:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0x2aa>
 81a:	0ff7f793          	zext.b	a5,a5
 81e:	4625                	li	a2,9
 820:	02f66863          	bltu	a2,a5,850 <atoi+0x44>
 824:	872a                	mv	a4,a0
  n = 0;
 826:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 828:	0705                	addi	a4,a4,1
 82a:	0025179b          	slliw	a5,a0,0x2
 82e:	9fa9                	addw	a5,a5,a0
 830:	0017979b          	slliw	a5,a5,0x1
 834:	9fb5                	addw	a5,a5,a3
 836:	fd07851b          	addiw	a0,a5,-48
 83a:	00074683          	lbu	a3,0(a4)
 83e:	fd06879b          	addiw	a5,a3,-48
 842:	0ff7f793          	zext.b	a5,a5
 846:	fef671e3          	bgeu	a2,a5,828 <atoi+0x1c>
  return n;
}
 84a:	6422                	ld	s0,8(sp)
 84c:	0141                	addi	sp,sp,16
 84e:	8082                	ret
  n = 0;
 850:	4501                	li	a0,0
 852:	bfe5                	j	84a <atoi+0x3e>

0000000000000854 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 85a:	02b57463          	bgeu	a0,a1,882 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 85e:	00c05f63          	blez	a2,87c <memmove+0x28>
 862:	1602                	slli	a2,a2,0x20
 864:	9201                	srli	a2,a2,0x20
 866:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 86a:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 86c:	0585                	addi	a1,a1,1
 86e:	0705                	addi	a4,a4,1
 870:	fff5c683          	lbu	a3,-1(a1)
 874:	fed70fa3          	sb	a3,-1(a4)
 878:	fef71ae3          	bne	a4,a5,86c <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret
    dst += n;
 882:	00c50733          	add	a4,a0,a2
    src += n;
 886:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 888:	fec05ae3          	blez	a2,87c <memmove+0x28>
 88c:	fff6079b          	addiw	a5,a2,-1
 890:	1782                	slli	a5,a5,0x20
 892:	9381                	srli	a5,a5,0x20
 894:	fff7c793          	not	a5,a5
 898:	97ba                	add	a5,a5,a4
 89a:	15fd                	addi	a1,a1,-1
 89c:	177d                	addi	a4,a4,-1
 89e:	0005c683          	lbu	a3,0(a1)
 8a2:	00d70023          	sb	a3,0(a4)
 8a6:	fee79ae3          	bne	a5,a4,89a <memmove+0x46>
 8aa:	bfc9                	j	87c <memmove+0x28>

00000000000008ac <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e422                	sd	s0,8(sp)
 8b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8b2:	ca05                	beqz	a2,8e2 <memcmp+0x36>
 8b4:	fff6069b          	addiw	a3,a2,-1
 8b8:	1682                	slli	a3,a3,0x20
 8ba:	9281                	srli	a3,a3,0x20
 8bc:	0685                	addi	a3,a3,1
 8be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8c0:	00054783          	lbu	a5,0(a0)
 8c4:	0005c703          	lbu	a4,0(a1)
 8c8:	00e79863          	bne	a5,a4,8d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8cc:	0505                	addi	a0,a0,1
    p2++;
 8ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8d0:	fed518e3          	bne	a0,a3,8c0 <memcmp+0x14>
  }
  return 0;
 8d4:	4501                	li	a0,0
 8d6:	a019                	j	8dc <memcmp+0x30>
      return *p1 - *p2;
 8d8:	40e7853b          	subw	a0,a5,a4
}
 8dc:	6422                	ld	s0,8(sp)
 8de:	0141                	addi	sp,sp,16
 8e0:	8082                	ret
  return 0;
 8e2:	4501                	li	a0,0
 8e4:	bfe5                	j	8dc <memcmp+0x30>

00000000000008e6 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 8e6:	1141                	addi	sp,sp,-16
 8e8:	e406                	sd	ra,8(sp)
 8ea:	e022                	sd	s0,0(sp)
 8ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8ee:	00000097          	auipc	ra,0x0
 8f2:	f66080e7          	jalr	-154(ra) # 854 <memmove>
}
 8f6:	60a2                	ld	ra,8(sp)
 8f8:	6402                	ld	s0,0(sp)
 8fa:	0141                	addi	sp,sp,16
 8fc:	8082                	ret

00000000000008fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 8fe:	4885                	li	a7,1
 ecall
 900:	00000073          	ecall
 ret
 904:	8082                	ret

0000000000000906 <exit>:
.global exit
exit:
 li a7, SYS_exit
 906:	4889                	li	a7,2
 ecall
 908:	00000073          	ecall
 ret
 90c:	8082                	ret

000000000000090e <wait>:
.global wait
wait:
 li a7, SYS_wait
 90e:	488d                	li	a7,3
 ecall
 910:	00000073          	ecall
 ret
 914:	8082                	ret

0000000000000916 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 916:	4891                	li	a7,4
 ecall
 918:	00000073          	ecall
 ret
 91c:	8082                	ret

000000000000091e <read>:
.global read
read:
 li a7, SYS_read
 91e:	4895                	li	a7,5
 ecall
 920:	00000073          	ecall
 ret
 924:	8082                	ret

0000000000000926 <write>:
.global write
write:
 li a7, SYS_write
 926:	48c1                	li	a7,16
 ecall
 928:	00000073          	ecall
 ret
 92c:	8082                	ret

000000000000092e <close>:
.global close
close:
 li a7, SYS_close
 92e:	48d5                	li	a7,21
 ecall
 930:	00000073          	ecall
 ret
 934:	8082                	ret

0000000000000936 <kill>:
.global kill
kill:
 li a7, SYS_kill
 936:	4899                	li	a7,6
 ecall
 938:	00000073          	ecall
 ret
 93c:	8082                	ret

000000000000093e <exec>:
.global exec
exec:
 li a7, SYS_exec
 93e:	489d                	li	a7,7
 ecall
 940:	00000073          	ecall
 ret
 944:	8082                	ret

0000000000000946 <open>:
.global open
open:
 li a7, SYS_open
 946:	48bd                	li	a7,15
 ecall
 948:	00000073          	ecall
 ret
 94c:	8082                	ret

000000000000094e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 94e:	48c5                	li	a7,17
 ecall
 950:	00000073          	ecall
 ret
 954:	8082                	ret

0000000000000956 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 956:	48c9                	li	a7,18
 ecall
 958:	00000073          	ecall
 ret
 95c:	8082                	ret

000000000000095e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 95e:	48a1                	li	a7,8
 ecall
 960:	00000073          	ecall
 ret
 964:	8082                	ret

0000000000000966 <link>:
.global link
link:
 li a7, SYS_link
 966:	48cd                	li	a7,19
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 96e:	48d1                	li	a7,20
 ecall
 970:	00000073          	ecall
 ret
 974:	8082                	ret

0000000000000976 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 976:	48a5                	li	a7,9
 ecall
 978:	00000073          	ecall
 ret
 97c:	8082                	ret

000000000000097e <dup>:
.global dup
dup:
 li a7, SYS_dup
 97e:	48a9                	li	a7,10
 ecall
 980:	00000073          	ecall
 ret
 984:	8082                	ret

0000000000000986 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 986:	48ad                	li	a7,11
 ecall
 988:	00000073          	ecall
 ret
 98c:	8082                	ret

000000000000098e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 98e:	48b1                	li	a7,12
 ecall
 990:	00000073          	ecall
 ret
 994:	8082                	ret

0000000000000996 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 996:	48b5                	li	a7,13
 ecall
 998:	00000073          	ecall
 ret
 99c:	8082                	ret

000000000000099e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 99e:	48b9                	li	a7,14
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 9a6:	1101                	addi	sp,sp,-32
 9a8:	ec06                	sd	ra,24(sp)
 9aa:	e822                	sd	s0,16(sp)
 9ac:	1000                	addi	s0,sp,32
 9ae:	feb407a3          	sb	a1,-17(s0)
 9b2:	4605                	li	a2,1
 9b4:	fef40593          	addi	a1,s0,-17
 9b8:	00000097          	auipc	ra,0x0
 9bc:	f6e080e7          	jalr	-146(ra) # 926 <write>
 9c0:	60e2                	ld	ra,24(sp)
 9c2:	6442                	ld	s0,16(sp)
 9c4:	6105                	addi	sp,sp,32
 9c6:	8082                	ret

00000000000009c8 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 9c8:	7139                	addi	sp,sp,-64
 9ca:	fc06                	sd	ra,56(sp)
 9cc:	f822                	sd	s0,48(sp)
 9ce:	f426                	sd	s1,40(sp)
 9d0:	0080                	addi	s0,sp,64
 9d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 9d4:	c299                	beqz	a3,9da <printint+0x12>
 9d6:	0805cb63          	bltz	a1,a6c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 9da:	2581                	sext.w	a1,a1
  neg = 0;
 9dc:	4881                	li	a7,0
 9de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 9e2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 9e4:	2601                	sext.w	a2,a2
 9e6:	00000517          	auipc	a0,0x0
 9ea:	6da50513          	addi	a0,a0,1754 # 10c0 <digits>
 9ee:	883a                	mv	a6,a4
 9f0:	2705                	addiw	a4,a4,1
 9f2:	02c5f7bb          	remuw	a5,a1,a2
 9f6:	1782                	slli	a5,a5,0x20
 9f8:	9381                	srli	a5,a5,0x20
 9fa:	97aa                	add	a5,a5,a0
 9fc:	0007c783          	lbu	a5,0(a5)
 a00:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 a04:	0005879b          	sext.w	a5,a1
 a08:	02c5d5bb          	divuw	a1,a1,a2
 a0c:	0685                	addi	a3,a3,1
 a0e:	fec7f0e3          	bgeu	a5,a2,9ee <printint+0x26>
  if (neg) buf[i++] = '-';
 a12:	00088c63          	beqz	a7,a2a <printint+0x62>
 a16:	fd070793          	addi	a5,a4,-48
 a1a:	00878733          	add	a4,a5,s0
 a1e:	02d00793          	li	a5,45
 a22:	fef70823          	sb	a5,-16(a4)
 a26:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 a2a:	02e05c63          	blez	a4,a62 <printint+0x9a>
 a2e:	f04a                	sd	s2,32(sp)
 a30:	ec4e                	sd	s3,24(sp)
 a32:	fc040793          	addi	a5,s0,-64
 a36:	00e78933          	add	s2,a5,a4
 a3a:	fff78993          	addi	s3,a5,-1
 a3e:	99ba                	add	s3,s3,a4
 a40:	377d                	addiw	a4,a4,-1
 a42:	1702                	slli	a4,a4,0x20
 a44:	9301                	srli	a4,a4,0x20
 a46:	40e989b3          	sub	s3,s3,a4
 a4a:	fff94583          	lbu	a1,-1(s2)
 a4e:	8526                	mv	a0,s1
 a50:	00000097          	auipc	ra,0x0
 a54:	f56080e7          	jalr	-170(ra) # 9a6 <putc>
 a58:	197d                	addi	s2,s2,-1
 a5a:	ff3918e3          	bne	s2,s3,a4a <printint+0x82>
 a5e:	7902                	ld	s2,32(sp)
 a60:	69e2                	ld	s3,24(sp)
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	6121                	addi	sp,sp,64
 a6a:	8082                	ret
    x = -xx;
 a6c:	40b005bb          	negw	a1,a1
    neg = 1;
 a70:	4885                	li	a7,1
    x = -xx;
 a72:	b7b5                	j	9de <printint+0x16>

0000000000000a74 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 a74:	715d                	addi	sp,sp,-80
 a76:	e486                	sd	ra,72(sp)
 a78:	e0a2                	sd	s0,64(sp)
 a7a:	f84a                	sd	s2,48(sp)
 a7c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 a7e:	0005c903          	lbu	s2,0(a1)
 a82:	1a090a63          	beqz	s2,c36 <vprintf+0x1c2>
 a86:	fc26                	sd	s1,56(sp)
 a88:	f44e                	sd	s3,40(sp)
 a8a:	f052                	sd	s4,32(sp)
 a8c:	ec56                	sd	s5,24(sp)
 a8e:	e85a                	sd	s6,16(sp)
 a90:	e45e                	sd	s7,8(sp)
 a92:	8aaa                	mv	s5,a0
 a94:	8bb2                	mv	s7,a2
 a96:	00158493          	addi	s1,a1,1
  state = 0;
 a9a:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 a9c:	02500a13          	li	s4,37
 aa0:	4b55                	li	s6,21
 aa2:	a839                	j	ac0 <vprintf+0x4c>
        putc(fd, c);
 aa4:	85ca                	mv	a1,s2
 aa6:	8556                	mv	a0,s5
 aa8:	00000097          	auipc	ra,0x0
 aac:	efe080e7          	jalr	-258(ra) # 9a6 <putc>
 ab0:	a019                	j	ab6 <vprintf+0x42>
    } else if (state == '%') {
 ab2:	01498d63          	beq	s3,s4,acc <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 ab6:	0485                	addi	s1,s1,1
 ab8:	fff4c903          	lbu	s2,-1(s1)
 abc:	16090763          	beqz	s2,c2a <vprintf+0x1b6>
    if (state == 0) {
 ac0:	fe0999e3          	bnez	s3,ab2 <vprintf+0x3e>
      if (c == '%') {
 ac4:	ff4910e3          	bne	s2,s4,aa4 <vprintf+0x30>
        state = '%';
 ac8:	89d2                	mv	s3,s4
 aca:	b7f5                	j	ab6 <vprintf+0x42>
      if (c == 'd') {
 acc:	13490463          	beq	s2,s4,bf4 <vprintf+0x180>
 ad0:	f9d9079b          	addiw	a5,s2,-99
 ad4:	0ff7f793          	zext.b	a5,a5
 ad8:	12fb6763          	bltu	s6,a5,c06 <vprintf+0x192>
 adc:	f9d9079b          	addiw	a5,s2,-99
 ae0:	0ff7f713          	zext.b	a4,a5
 ae4:	12eb6163          	bltu	s6,a4,c06 <vprintf+0x192>
 ae8:	00271793          	slli	a5,a4,0x2
 aec:	00000717          	auipc	a4,0x0
 af0:	57c70713          	addi	a4,a4,1404 # 1068 <HACK+0x10>
 af4:	97ba                	add	a5,a5,a4
 af6:	439c                	lw	a5,0(a5)
 af8:	97ba                	add	a5,a5,a4
 afa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 afc:	008b8913          	addi	s2,s7,8
 b00:	4685                	li	a3,1
 b02:	4629                	li	a2,10
 b04:	000ba583          	lw	a1,0(s7)
 b08:	8556                	mv	a0,s5
 b0a:	00000097          	auipc	ra,0x0
 b0e:	ebe080e7          	jalr	-322(ra) # 9c8 <printint>
 b12:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b14:	4981                	li	s3,0
 b16:	b745                	j	ab6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b18:	008b8913          	addi	s2,s7,8
 b1c:	4681                	li	a3,0
 b1e:	4629                	li	a2,10
 b20:	000ba583          	lw	a1,0(s7)
 b24:	8556                	mv	a0,s5
 b26:	00000097          	auipc	ra,0x0
 b2a:	ea2080e7          	jalr	-350(ra) # 9c8 <printint>
 b2e:	8bca                	mv	s7,s2
      state = 0;
 b30:	4981                	li	s3,0
 b32:	b751                	j	ab6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 b34:	008b8913          	addi	s2,s7,8
 b38:	4681                	li	a3,0
 b3a:	4641                	li	a2,16
 b3c:	000ba583          	lw	a1,0(s7)
 b40:	8556                	mv	a0,s5
 b42:	00000097          	auipc	ra,0x0
 b46:	e86080e7          	jalr	-378(ra) # 9c8 <printint>
 b4a:	8bca                	mv	s7,s2
      state = 0;
 b4c:	4981                	li	s3,0
 b4e:	b7a5                	j	ab6 <vprintf+0x42>
 b50:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b52:	008b8c13          	addi	s8,s7,8
 b56:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b5a:	03000593          	li	a1,48
 b5e:	8556                	mv	a0,s5
 b60:	00000097          	auipc	ra,0x0
 b64:	e46080e7          	jalr	-442(ra) # 9a6 <putc>
  putc(fd, 'x');
 b68:	07800593          	li	a1,120
 b6c:	8556                	mv	a0,s5
 b6e:	00000097          	auipc	ra,0x0
 b72:	e38080e7          	jalr	-456(ra) # 9a6 <putc>
 b76:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b78:	00000b97          	auipc	s7,0x0
 b7c:	548b8b93          	addi	s7,s7,1352 # 10c0 <digits>
 b80:	03c9d793          	srli	a5,s3,0x3c
 b84:	97de                	add	a5,a5,s7
 b86:	0007c583          	lbu	a1,0(a5)
 b8a:	8556                	mv	a0,s5
 b8c:	00000097          	auipc	ra,0x0
 b90:	e1a080e7          	jalr	-486(ra) # 9a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b94:	0992                	slli	s3,s3,0x4
 b96:	397d                	addiw	s2,s2,-1
 b98:	fe0914e3          	bnez	s2,b80 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 b9c:	8be2                	mv	s7,s8
      state = 0;
 b9e:	4981                	li	s3,0
 ba0:	6c02                	ld	s8,0(sp)
 ba2:	bf11                	j	ab6 <vprintf+0x42>
        s = va_arg(ap, char *);
 ba4:	008b8993          	addi	s3,s7,8
 ba8:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 bac:	02090163          	beqz	s2,bce <vprintf+0x15a>
        while (*s != 0) {
 bb0:	00094583          	lbu	a1,0(s2)
 bb4:	c9a5                	beqz	a1,c24 <vprintf+0x1b0>
          putc(fd, *s);
 bb6:	8556                	mv	a0,s5
 bb8:	00000097          	auipc	ra,0x0
 bbc:	dee080e7          	jalr	-530(ra) # 9a6 <putc>
          s++;
 bc0:	0905                	addi	s2,s2,1
        while (*s != 0) {
 bc2:	00094583          	lbu	a1,0(s2)
 bc6:	f9e5                	bnez	a1,bb6 <vprintf+0x142>
        s = va_arg(ap, char *);
 bc8:	8bce                	mv	s7,s3
      state = 0;
 bca:	4981                	li	s3,0
 bcc:	b5ed                	j	ab6 <vprintf+0x42>
        if (s == 0) s = "(null)";
 bce:	00000917          	auipc	s2,0x0
 bd2:	48290913          	addi	s2,s2,1154 # 1050 <malloc+0x32a>
        while (*s != 0) {
 bd6:	02800593          	li	a1,40
 bda:	bff1                	j	bb6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 bdc:	008b8913          	addi	s2,s7,8
 be0:	000bc583          	lbu	a1,0(s7)
 be4:	8556                	mv	a0,s5
 be6:	00000097          	auipc	ra,0x0
 bea:	dc0080e7          	jalr	-576(ra) # 9a6 <putc>
 bee:	8bca                	mv	s7,s2
      state = 0;
 bf0:	4981                	li	s3,0
 bf2:	b5d1                	j	ab6 <vprintf+0x42>
        putc(fd, c);
 bf4:	02500593          	li	a1,37
 bf8:	8556                	mv	a0,s5
 bfa:	00000097          	auipc	ra,0x0
 bfe:	dac080e7          	jalr	-596(ra) # 9a6 <putc>
      state = 0;
 c02:	4981                	li	s3,0
 c04:	bd4d                	j	ab6 <vprintf+0x42>
        putc(fd, '%');
 c06:	02500593          	li	a1,37
 c0a:	8556                	mv	a0,s5
 c0c:	00000097          	auipc	ra,0x0
 c10:	d9a080e7          	jalr	-614(ra) # 9a6 <putc>
        putc(fd, c);
 c14:	85ca                	mv	a1,s2
 c16:	8556                	mv	a0,s5
 c18:	00000097          	auipc	ra,0x0
 c1c:	d8e080e7          	jalr	-626(ra) # 9a6 <putc>
      state = 0;
 c20:	4981                	li	s3,0
 c22:	bd51                	j	ab6 <vprintf+0x42>
        s = va_arg(ap, char *);
 c24:	8bce                	mv	s7,s3
      state = 0;
 c26:	4981                	li	s3,0
 c28:	b579                	j	ab6 <vprintf+0x42>
 c2a:	74e2                	ld	s1,56(sp)
 c2c:	79a2                	ld	s3,40(sp)
 c2e:	7a02                	ld	s4,32(sp)
 c30:	6ae2                	ld	s5,24(sp)
 c32:	6b42                	ld	s6,16(sp)
 c34:	6ba2                	ld	s7,8(sp)
    }
  }
}
 c36:	60a6                	ld	ra,72(sp)
 c38:	6406                	ld	s0,64(sp)
 c3a:	7942                	ld	s2,48(sp)
 c3c:	6161                	addi	sp,sp,80
 c3e:	8082                	ret

0000000000000c40 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 c40:	715d                	addi	sp,sp,-80
 c42:	ec06                	sd	ra,24(sp)
 c44:	e822                	sd	s0,16(sp)
 c46:	1000                	addi	s0,sp,32
 c48:	e010                	sd	a2,0(s0)
 c4a:	e414                	sd	a3,8(s0)
 c4c:	e818                	sd	a4,16(s0)
 c4e:	ec1c                	sd	a5,24(s0)
 c50:	03043023          	sd	a6,32(s0)
 c54:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c58:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c5c:	8622                	mv	a2,s0
 c5e:	00000097          	auipc	ra,0x0
 c62:	e16080e7          	jalr	-490(ra) # a74 <vprintf>
}
 c66:	60e2                	ld	ra,24(sp)
 c68:	6442                	ld	s0,16(sp)
 c6a:	6161                	addi	sp,sp,80
 c6c:	8082                	ret

0000000000000c6e <printf>:

void printf(const char *fmt, ...) {
 c6e:	711d                	addi	sp,sp,-96
 c70:	ec06                	sd	ra,24(sp)
 c72:	e822                	sd	s0,16(sp)
 c74:	1000                	addi	s0,sp,32
 c76:	e40c                	sd	a1,8(s0)
 c78:	e810                	sd	a2,16(s0)
 c7a:	ec14                	sd	a3,24(s0)
 c7c:	f018                	sd	a4,32(s0)
 c7e:	f41c                	sd	a5,40(s0)
 c80:	03043823          	sd	a6,48(s0)
 c84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c88:	00840613          	addi	a2,s0,8
 c8c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c90:	85aa                	mv	a1,a0
 c92:	4505                	li	a0,1
 c94:	00000097          	auipc	ra,0x0
 c98:	de0080e7          	jalr	-544(ra) # a74 <vprintf>
}
 c9c:	60e2                	ld	ra,24(sp)
 c9e:	6442                	ld	s0,16(sp)
 ca0:	6125                	addi	sp,sp,96
 ca2:	8082                	ret

0000000000000ca4 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 ca4:	1141                	addi	sp,sp,-16
 ca6:	e422                	sd	s0,8(sp)
 ca8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 caa:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cae:	00001797          	auipc	a5,0x1
 cb2:	35a7b783          	ld	a5,858(a5) # 2008 <freep>
 cb6:	a02d                	j	ce0 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 cb8:	4618                	lw	a4,8(a2)
 cba:	9f2d                	addw	a4,a4,a1
 cbc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cc0:	6398                	ld	a4,0(a5)
 cc2:	6310                	ld	a2,0(a4)
 cc4:	a83d                	j	d02 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 cc6:	ff852703          	lw	a4,-8(a0)
 cca:	9f31                	addw	a4,a4,a2
 ccc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cce:	ff053683          	ld	a3,-16(a0)
 cd2:	a091                	j	d16 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 cd4:	6398                	ld	a4,0(a5)
 cd6:	00e7e463          	bltu	a5,a4,cde <free+0x3a>
 cda:	00e6ea63          	bltu	a3,a4,cee <free+0x4a>
void free(void *ap) {
 cde:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ce0:	fed7fae3          	bgeu	a5,a3,cd4 <free+0x30>
 ce4:	6398                	ld	a4,0(a5)
 ce6:	00e6e463          	bltu	a3,a4,cee <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 cea:	fee7eae3          	bltu	a5,a4,cde <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 cee:	ff852583          	lw	a1,-8(a0)
 cf2:	6390                	ld	a2,0(a5)
 cf4:	02059813          	slli	a6,a1,0x20
 cf8:	01c85713          	srli	a4,a6,0x1c
 cfc:	9736                	add	a4,a4,a3
 cfe:	fae60de3          	beq	a2,a4,cb8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d02:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 d06:	4790                	lw	a2,8(a5)
 d08:	02061593          	slli	a1,a2,0x20
 d0c:	01c5d713          	srli	a4,a1,0x1c
 d10:	973e                	add	a4,a4,a5
 d12:	fae68ae3          	beq	a3,a4,cc6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d16:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d18:	00001717          	auipc	a4,0x1
 d1c:	2ef73823          	sd	a5,752(a4) # 2008 <freep>
}
 d20:	6422                	ld	s0,8(sp)
 d22:	0141                	addi	sp,sp,16
 d24:	8082                	ret

0000000000000d26 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 d26:	7139                	addi	sp,sp,-64
 d28:	fc06                	sd	ra,56(sp)
 d2a:	f822                	sd	s0,48(sp)
 d2c:	f426                	sd	s1,40(sp)
 d2e:	ec4e                	sd	s3,24(sp)
 d30:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 d32:	02051493          	slli	s1,a0,0x20
 d36:	9081                	srli	s1,s1,0x20
 d38:	04bd                	addi	s1,s1,15
 d3a:	8091                	srli	s1,s1,0x4
 d3c:	0014899b          	addiw	s3,s1,1
 d40:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 d42:	00001517          	auipc	a0,0x1
 d46:	2c653503          	ld	a0,710(a0) # 2008 <freep>
 d4a:	c915                	beqz	a0,d7e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 d4c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 d4e:	4798                	lw	a4,8(a5)
 d50:	08977e63          	bgeu	a4,s1,dec <malloc+0xc6>
 d54:	f04a                	sd	s2,32(sp)
 d56:	e852                	sd	s4,16(sp)
 d58:	e456                	sd	s5,8(sp)
 d5a:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 d5c:	8a4e                	mv	s4,s3
 d5e:	0009871b          	sext.w	a4,s3
 d62:	6685                	lui	a3,0x1
 d64:	00d77363          	bgeu	a4,a3,d6a <malloc+0x44>
 d68:	6a05                	lui	s4,0x1
 d6a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d6e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 d72:	00001917          	auipc	s2,0x1
 d76:	29690913          	addi	s2,s2,662 # 2008 <freep>
  if (p == (char *)-1) return 0;
 d7a:	5afd                	li	s5,-1
 d7c:	a091                	j	dc0 <malloc+0x9a>
 d7e:	f04a                	sd	s2,32(sp)
 d80:	e852                	sd	s4,16(sp)
 d82:	e456                	sd	s5,8(sp)
 d84:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d86:	00005797          	auipc	a5,0x5
 d8a:	28a78793          	addi	a5,a5,650 # 6010 <base>
 d8e:	00001717          	auipc	a4,0x1
 d92:	26f73d23          	sd	a5,634(a4) # 2008 <freep>
 d96:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d98:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 d9c:	b7c1                	j	d5c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 d9e:	6398                	ld	a4,0(a5)
 da0:	e118                	sd	a4,0(a0)
 da2:	a08d                	j	e04 <malloc+0xde>
  hp->s.size = nu;
 da4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 da8:	0541                	addi	a0,a0,16
 daa:	00000097          	auipc	ra,0x0
 dae:	efa080e7          	jalr	-262(ra) # ca4 <free>
  return freep;
 db2:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 db6:	c13d                	beqz	a0,e1c <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 db8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 dba:	4798                	lw	a4,8(a5)
 dbc:	02977463          	bgeu	a4,s1,de4 <malloc+0xbe>
    if (p == freep)
 dc0:	00093703          	ld	a4,0(s2)
 dc4:	853e                	mv	a0,a5
 dc6:	fef719e3          	bne	a4,a5,db8 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 dca:	8552                	mv	a0,s4
 dcc:	00000097          	auipc	ra,0x0
 dd0:	bc2080e7          	jalr	-1086(ra) # 98e <sbrk>
  if (p == (char *)-1) return 0;
 dd4:	fd5518e3          	bne	a0,s5,da4 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 dd8:	4501                	li	a0,0
 dda:	7902                	ld	s2,32(sp)
 ddc:	6a42                	ld	s4,16(sp)
 dde:	6aa2                	ld	s5,8(sp)
 de0:	6b02                	ld	s6,0(sp)
 de2:	a03d                	j	e10 <malloc+0xea>
 de4:	7902                	ld	s2,32(sp)
 de6:	6a42                	ld	s4,16(sp)
 de8:	6aa2                	ld	s5,8(sp)
 dea:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 dec:	fae489e3          	beq	s1,a4,d9e <malloc+0x78>
        p->s.size -= nunits;
 df0:	4137073b          	subw	a4,a4,s3
 df4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 df6:	02071693          	slli	a3,a4,0x20
 dfa:	01c6d713          	srli	a4,a3,0x1c
 dfe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e04:	00001717          	auipc	a4,0x1
 e08:	20a73223          	sd	a0,516(a4) # 2008 <freep>
      return (void *)(p + 1);
 e0c:	01078513          	addi	a0,a5,16
  }
}
 e10:	70e2                	ld	ra,56(sp)
 e12:	7442                	ld	s0,48(sp)
 e14:	74a2                	ld	s1,40(sp)
 e16:	69e2                	ld	s3,24(sp)
 e18:	6121                	addi	sp,sp,64
 e1a:	8082                	ret
 e1c:	7902                	ld	s2,32(sp)
 e1e:	6a42                	ld	s4,16(sp)
 e20:	6aa2                	ld	s5,8(sp)
 e22:	6b02                	ld	s6,0(sp)
 e24:	b7f5                	j	e10 <malloc+0xea>
