
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"
#include "kernel/stat.h"
#include "user/user.h"

char *fmtname(char *path) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--);
   c:	00000097          	auipc	ra,0x0
  10:	332080e7          	jalr	818(ra) # 33e <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ) return p;
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	306080e7          	jalr	774(ra) # 33e <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2e4080e7          	jalr	740(ra) # 33e <strlen>
  62:	00002997          	auipc	s3,0x2
  66:	fae98993          	addi	s3,s3,-82 # 2010 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	43e080e7          	jalr	1086(ra) # 4b0 <memmove>
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2c2080e7          	jalr	706(ra) # 33e <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2b4080e7          	jalr	692(ra) # 33e <strlen>
  92:	1902                	slli	s2,s2,0x20
  94:	02095913          	srli	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2c4080e7          	jalr	708(ra) # 368 <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void ls(char *path) {
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	addi	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	552080e7          	jalr	1362(ra) # 61c <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	554080e7          	jalr	1364(ra) # 634 <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type) {
  ec:	da041783          	lh	a5,-608(s0)
  f0:	4705                	li	a4,1
  f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
  f6:	37f9                	addiw	a5,a5,-2
  f8:	17c2                	slli	a5,a5,0x30
  fa:	93c1                	srli	a5,a5,0x30
  fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
    case T_DEVICE:
    case T_FILE:
      printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	da843703          	ld	a4,-600(s0)
 110:	d9c42683          	lw	a3,-612(s0)
 114:	da041603          	lh	a2,-608(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	a7850513          	addi	a0,a0,-1416 # b90 <loop+0x38>
 120:	00001097          	auipc	ra,0x1
 124:	82c080e7          	jalr	-2004(ra) # 94c <printf>
        }
        printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      }
      break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	4da080e7          	jalr	1242(ra) # 604 <close>
 132:	25813483          	ld	s1,600(sp)
}
 136:	26813083          	ld	ra,616(sp)
 13a:	26013403          	ld	s0,608(sp)
 13e:	25013903          	ld	s2,592(sp)
 142:	27010113          	addi	sp,sp,624
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	a1658593          	addi	a1,a1,-1514 # b60 <loop+0x8>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	7ca080e7          	jalr	1994(ra) # 91e <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	a1858593          	addi	a1,a1,-1512 # b78 <loop+0x20>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	7b4080e7          	jalr	1972(ra) # 91e <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	490080e7          	jalr	1168(ra) # 604 <close>
    return;
 17c:	25813483          	ld	s1,600(sp)
 180:	bf5d                	j	136 <ls+0x82>
      if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1ba080e7          	jalr	442(ra) # 33e <strlen>
 18c:	2541                	addiw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
        printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	a0a50513          	addi	a0,a0,-1526 # ba0 <loop+0x48>
 19e:	00000097          	auipc	ra,0x0
 1a2:	7ae080e7          	jalr	1966(ra) # 94c <printf>
        break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	25313423          	sd	s3,584(sp)
 1ac:	25413023          	sd	s4,576(sp)
 1b0:	23513c23          	sd	s5,568(sp)
      strcpy(buf, path);
 1b4:	85ca                	mv	a1,s2
 1b6:	dc040513          	addi	a0,s0,-576
 1ba:	00000097          	auipc	ra,0x0
 1be:	13c080e7          	jalr	316(ra) # 2f6 <strcpy>
      p = buf + strlen(buf);
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	178080e7          	jalr	376(ra) # 33e <strlen>
 1ce:	1502                	slli	a0,a0,0x20
 1d0:	9101                	srli	a0,a0,0x20
 1d2:	dc040793          	addi	a5,s0,-576
 1d6:	00a78933          	add	s2,a5,a0
      *p++ = '/';
 1da:	00190993          	addi	s3,s2,1
 1de:	02f00793          	li	a5,47
 1e2:	00f90023          	sb	a5,0(s2)
        printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e6:	00001a17          	auipc	s4,0x1
 1ea:	9d2a0a13          	addi	s4,s4,-1582 # bb8 <loop+0x60>
          printf("ls: cannot stat %s\n", buf);
 1ee:	00001a97          	auipc	s5,0x1
 1f2:	98aa8a93          	addi	s5,s5,-1654 # b78 <loop+0x20>
      while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1f6:	a801                	j	206 <ls+0x152>
          printf("ls: cannot stat %s\n", buf);
 1f8:	dc040593          	addi	a1,s0,-576
 1fc:	8556                	mv	a0,s5
 1fe:	00000097          	auipc	ra,0x0
 202:	74e080e7          	jalr	1870(ra) # 94c <printf>
      while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 206:	4641                	li	a2,16
 208:	db040593          	addi	a1,s0,-592
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	3e6080e7          	jalr	998(ra) # 5f4 <read>
 216:	47c1                	li	a5,16
 218:	04f51c63          	bne	a0,a5,270 <ls+0x1bc>
        if (de.inum == 0) continue;
 21c:	db045783          	lhu	a5,-592(s0)
 220:	d3fd                	beqz	a5,206 <ls+0x152>
        memmove(p, de.name, DIRSIZ);
 222:	4639                	li	a2,14
 224:	db240593          	addi	a1,s0,-590
 228:	854e                	mv	a0,s3
 22a:	00000097          	auipc	ra,0x0
 22e:	286080e7          	jalr	646(ra) # 4b0 <memmove>
        p[DIRSIZ] = 0;
 232:	000907a3          	sb	zero,15(s2)
        if (stat(buf, &st) < 0) {
 236:	d9840593          	addi	a1,s0,-616
 23a:	dc040513          	addi	a0,s0,-576
 23e:	00000097          	auipc	ra,0x0
 242:	1e4080e7          	jalr	484(ra) # 422 <stat>
 246:	fa0549e3          	bltz	a0,1f8 <ls+0x144>
        printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24a:	dc040513          	addi	a0,s0,-576
 24e:	00000097          	auipc	ra,0x0
 252:	db2080e7          	jalr	-590(ra) # 0 <fmtname>
 256:	85aa                	mv	a1,a0
 258:	da843703          	ld	a4,-600(s0)
 25c:	d9c42683          	lw	a3,-612(s0)
 260:	da041603          	lh	a2,-608(s0)
 264:	8552                	mv	a0,s4
 266:	00000097          	auipc	ra,0x0
 26a:	6e6080e7          	jalr	1766(ra) # 94c <printf>
 26e:	bf61                	j	206 <ls+0x152>
 270:	24813983          	ld	s3,584(sp)
 274:	24013a03          	ld	s4,576(sp)
 278:	23813a83          	ld	s5,568(sp)
 27c:	b575                	j	128 <ls+0x74>

000000000000027e <main>:

int main(int argc, char *argv[]) {
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
 286:	4785                	li	a5,1
 288:	02a7db63          	bge	a5,a0,2be <main+0x40>
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	00858493          	addi	s1,a1,8
 294:	ffe5091b          	addiw	s2,a0,-2
 298:	02091793          	slli	a5,s2,0x20
 29c:	01d7d913          	srli	s2,a5,0x1d
 2a0:	05c1                	addi	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++) ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
 2ae:	04a1                	addi	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	326080e7          	jalr	806(ra) # 5dc <exit>
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	90650513          	addi	a0,a0,-1786 # bc8 <loop+0x70>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dea080e7          	jalr	-534(ra) # b4 <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	308080e7          	jalr	776(ra) # 5dc <exit>

00000000000002dc <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e4:	00000097          	auipc	ra,0x0
 2e8:	f9a080e7          	jalr	-102(ra) # 27e <main>
  exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	2ee080e7          	jalr	750(ra) # 5dc <exit>

00000000000002f6 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
 2fc:	87aa                	mv	a5,a0
 2fe:	0585                	addi	a1,a1,1
 300:	0785                	addi	a5,a5,1
 302:	fff5c703          	lbu	a4,-1(a1)
 306:	fee78fa3          	sb	a4,-1(a5)
 30a:	fb75                	bnez	a4,2fe <strcpy+0x8>
  return os;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strcmp>:

int strcmp(const char *p, const char *q) {
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb91                	beqz	a5,330 <strcmp+0x1e>
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00f71763          	bne	a4,a5,330 <strcmp+0x1e>
 326:	0505                	addi	a0,a0,1
 328:	0585                	addi	a1,a1,1
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbe5                	bnez	a5,31e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 330:	0005c503          	lbu	a0,0(a1)
}
 334:	40a7853b          	subw	a0,a5,a0
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strlen>:

uint strlen(const char *s) {
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
 344:	00054783          	lbu	a5,0(a0)
 348:	cf91                	beqz	a5,364 <strlen+0x26>
 34a:	0505                	addi	a0,a0,1
 34c:	87aa                	mv	a5,a0
 34e:	86be                	mv	a3,a5
 350:	0785                	addi	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	ff65                	bnez	a4,34e <strlen+0x10>
 358:	40a6853b          	subw	a0,a3,a0
 35c:	2505                	addiw	a0,a0,1
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  for (n = 0; s[n]; n++);
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <strlen+0x20>

0000000000000368 <memset>:

void *memset(void *dst, int c, uint n) {
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 36e:	ca19                	beqz	a2,384 <memset+0x1c>
 370:	87aa                	mv	a5,a0
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 37e:	0785                	addi	a5,a5,1
 380:	fee79de3          	bne	a5,a4,37a <memset+0x12>
  }
  return dst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <strchr>:

char *strchr(const char *s, char c) {
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cb99                	beqz	a5,3aa <strchr+0x20>
    if (*s == c) return (char *)s;
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1a>
  for (; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xc>
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <strchr+0x1a>

00000000000003ae <gets>:

char *gets(char *buf, int max) {
 3ae:	711d                	addi	sp,sp,-96
 3b0:	ec86                	sd	ra,88(sp)
 3b2:	e8a2                	sd	s0,80(sp)
 3b4:	e4a6                	sd	s1,72(sp)
 3b6:	e0ca                	sd	s2,64(sp)
 3b8:	fc4e                	sd	s3,56(sp)
 3ba:	f852                	sd	s4,48(sp)
 3bc:	f456                	sd	s5,40(sp)
 3be:	f05a                	sd	s6,32(sp)
 3c0:	ec5e                	sd	s7,24(sp)
 3c2:	1080                	addi	s0,sp,96
 3c4:	8baa                	mv	s7,a0
 3c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 3c8:	892a                	mv	s2,a0
 3ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 3cc:	4aa9                	li	s5,10
 3ce:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 3d0:	89a6                	mv	s3,s1
 3d2:	2485                	addiw	s1,s1,1
 3d4:	0344d863          	bge	s1,s4,404 <gets+0x56>
    cc = read(0, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	faf40593          	addi	a1,s0,-81
 3de:	4501                	li	a0,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	214080e7          	jalr	532(ra) # 5f4 <read>
    if (cc < 1) break;
 3e8:	00a05e63          	blez	a0,404 <gets+0x56>
    buf[i++] = c;
 3ec:	faf44783          	lbu	a5,-81(s0)
 3f0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 3f4:	01578763          	beq	a5,s5,402 <gets+0x54>
 3f8:	0905                	addi	s2,s2,1
 3fa:	fd679be3          	bne	a5,s6,3d0 <gets+0x22>
    buf[i++] = c;
 3fe:	89a6                	mv	s3,s1
 400:	a011                	j	404 <gets+0x56>
 402:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 404:	99de                	add	s3,s3,s7
 406:	00098023          	sb	zero,0(s3)
  return buf;
}
 40a:	855e                	mv	a0,s7
 40c:	60e6                	ld	ra,88(sp)
 40e:	6446                	ld	s0,80(sp)
 410:	64a6                	ld	s1,72(sp)
 412:	6906                	ld	s2,64(sp)
 414:	79e2                	ld	s3,56(sp)
 416:	7a42                	ld	s4,48(sp)
 418:	7aa2                	ld	s5,40(sp)
 41a:	7b02                	ld	s6,32(sp)
 41c:	6be2                	ld	s7,24(sp)
 41e:	6125                	addi	sp,sp,96
 420:	8082                	ret

0000000000000422 <stat>:

int stat(const char *n, struct stat *st) {
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	00000097          	auipc	ra,0x0
 434:	1ec080e7          	jalr	492(ra) # 61c <open>
  if (fd < 0) return -1;
 438:	02054663          	bltz	a0,464 <stat+0x42>
 43c:	e426                	sd	s1,8(sp)
 43e:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 440:	85ca                	mv	a1,s2
 442:	00000097          	auipc	ra,0x0
 446:	1f2080e7          	jalr	498(ra) # 634 <fstat>
 44a:	892a                	mv	s2,a0
  close(fd);
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	1b6080e7          	jalr	438(ra) # 604 <close>
  return r;
 456:	64a2                	ld	s1,8(sp)
}
 458:	854a                	mv	a0,s2
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret
  if (fd < 0) return -1;
 464:	597d                	li	s2,-1
 466:	bfcd                	j	458 <stat+0x36>

0000000000000468 <atoi>:

int atoi(const char *s) {
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 46e:	00054683          	lbu	a3,0(a0)
 472:	fd06879b          	addiw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	4625                	li	a2,9
 47c:	02f66863          	bltu	a2,a5,4ac <atoi+0x44>
 480:	872a                	mv	a4,a0
  n = 0;
 482:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 484:	0705                	addi	a4,a4,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb5                	addw	a5,a5,a3
 492:	fd07851b          	addiw	a0,a5,-48
 496:	00074683          	lbu	a3,0(a4)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	fef671e3          	bgeu	a2,a5,484 <atoi+0x1c>
  return n;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
  n = 0;
 4ac:	4501                	li	a0,0
 4ae:	bfe5                	j	4a6 <atoi+0x3e>

00000000000004b0 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b6:	02b57463          	bgeu	a0,a1,4de <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 4ba:	00c05f63          	blez	a2,4d8 <memmove+0x28>
 4be:	1602                	slli	a2,a2,0x20
 4c0:	9201                	srli	a2,a2,0x20
 4c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4c6:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 4c8:	0585                	addi	a1,a1,1
 4ca:	0705                	addi	a4,a4,1
 4cc:	fff5c683          	lbu	a3,-1(a1)
 4d0:	fed70fa3          	sb	a3,-1(a4)
 4d4:	fef71ae3          	bne	a4,a5,4c8 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
    dst += n;
 4de:	00c50733          	add	a4,a0,a2
    src += n;
 4e2:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 4e4:	fec05ae3          	blez	a2,4d8 <memmove+0x28>
 4e8:	fff6079b          	addiw	a5,a2,-1
 4ec:	1782                	slli	a5,a5,0x20
 4ee:	9381                	srli	a5,a5,0x20
 4f0:	fff7c793          	not	a5,a5
 4f4:	97ba                	add	a5,a5,a4
 4f6:	15fd                	addi	a1,a1,-1
 4f8:	177d                	addi	a4,a4,-1
 4fa:	0005c683          	lbu	a3,0(a1)
 4fe:	00d70023          	sb	a3,0(a4)
 502:	fee79ae3          	bne	a5,a4,4f6 <memmove+0x46>
 506:	bfc9                	j	4d8 <memmove+0x28>

0000000000000508 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50e:	ca05                	beqz	a2,53e <memcmp+0x36>
 510:	fff6069b          	addiw	a3,a2,-1
 514:	1682                	slli	a3,a3,0x20
 516:	9281                	srli	a3,a3,0x20
 518:	0685                	addi	a3,a3,1
 51a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 51c:	00054783          	lbu	a5,0(a0)
 520:	0005c703          	lbu	a4,0(a1)
 524:	00e79863          	bne	a5,a4,534 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 528:	0505                	addi	a0,a0,1
    p2++;
 52a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 52c:	fed518e3          	bne	a0,a3,51c <memcmp+0x14>
  }
  return 0;
 530:	4501                	li	a0,0
 532:	a019                	j	538 <memcmp+0x30>
      return *p1 - *p2;
 534:	40e7853b          	subw	a0,a5,a4
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret
  return 0;
 53e:	4501                	li	a0,0
 540:	bfe5                	j	538 <memcmp+0x30>

0000000000000542 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 54a:	00000097          	auipc	ra,0x0
 54e:	f66080e7          	jalr	-154(ra) # 4b0 <memmove>
}
 552:	60a2                	ld	ra,8(sp)
 554:	6402                	ld	s0,0(sp)
 556:	0141                	addi	sp,sp,16
 558:	8082                	ret

000000000000055a <strcat>:

char *strcat(char *dst, const char *src) {
 55a:	1141                	addi	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	addi	s0,sp,16
  char *p = dst;
  while (*p) p++;
 560:	00054783          	lbu	a5,0(a0)
 564:	c385                	beqz	a5,584 <strcat+0x2a>
  char *p = dst;
 566:	87aa                	mv	a5,a0
  while (*p) p++;
 568:	0785                	addi	a5,a5,1
 56a:	0007c703          	lbu	a4,0(a5)
 56e:	ff6d                	bnez	a4,568 <strcat+0xe>
  while ((*p++ = *src++));
 570:	0585                	addi	a1,a1,1
 572:	0785                	addi	a5,a5,1
 574:	fff5c703          	lbu	a4,-1(a1)
 578:	fee78fa3          	sb	a4,-1(a5)
 57c:	fb75                	bnez	a4,570 <strcat+0x16>
  return dst;
}
 57e:	6422                	ld	s0,8(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret
  char *p = dst;
 584:	87aa                	mv	a5,a0
 586:	b7ed                	j	570 <strcat+0x16>

0000000000000588 <strstr>:

// Warning: this function has O(nm) complexity.
// It's recommended to implement some efficient algorithm here like KMP.
char *strstr(const char *haystack, const char *needle) {
 588:	1141                	addi	sp,sp,-16
 58a:	e422                	sd	s0,8(sp)
 58c:	0800                	addi	s0,sp,16
  const char *h, *n;

  if (!*needle) return (char *)haystack;
 58e:	0005c783          	lbu	a5,0(a1)
 592:	cf95                	beqz	a5,5ce <strstr+0x46>

  for (; *haystack; haystack++) {
 594:	00054783          	lbu	a5,0(a0)
 598:	eb91                	bnez	a5,5ac <strstr+0x24>
      h++;
      n++;
    }
    if (!*n) return (char *)haystack;
  }
  return 0;
 59a:	4501                	li	a0,0
 59c:	a80d                	j	5ce <strstr+0x46>
    if (!*n) return (char *)haystack;
 59e:	0007c783          	lbu	a5,0(a5)
 5a2:	c795                	beqz	a5,5ce <strstr+0x46>
  for (; *haystack; haystack++) {
 5a4:	0505                	addi	a0,a0,1
 5a6:	00054783          	lbu	a5,0(a0)
 5aa:	c38d                	beqz	a5,5cc <strstr+0x44>
    while (*h && *n && (*h == *n)) {
 5ac:	00054703          	lbu	a4,0(a0)
    n = needle;
 5b0:	87ae                	mv	a5,a1
    h = haystack;
 5b2:	862a                	mv	a2,a0
    while (*h && *n && (*h == *n)) {
 5b4:	db65                	beqz	a4,5a4 <strstr+0x1c>
 5b6:	0007c683          	lbu	a3,0(a5)
 5ba:	ca91                	beqz	a3,5ce <strstr+0x46>
 5bc:	fee691e3          	bne	a3,a4,59e <strstr+0x16>
      h++;
 5c0:	0605                	addi	a2,a2,1
      n++;
 5c2:	0785                	addi	a5,a5,1
    while (*h && *n && (*h == *n)) {
 5c4:	00064703          	lbu	a4,0(a2)
 5c8:	f77d                	bnez	a4,5b6 <strstr+0x2e>
 5ca:	bfd1                	j	59e <strstr+0x16>
  return 0;
 5cc:	4501                	li	a0,0
}
 5ce:	6422                	ld	s0,8(sp)
 5d0:	0141                	addi	sp,sp,16
 5d2:	8082                	ret

00000000000005d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5d4:	4885                	li	a7,1
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 5dc:	4889                	li	a7,2
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5e4:	488d                	li	a7,3
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ec:	4891                	li	a7,4
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <read>:
.global read
read:
 li a7, SYS_read
 5f4:	4895                	li	a7,5
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <write>:
.global write
write:
 li a7, SYS_write
 5fc:	48c1                	li	a7,16
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <close>:
.global close
close:
 li a7, SYS_close
 604:	48d5                	li	a7,21
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <kill>:
.global kill
kill:
 li a7, SYS_kill
 60c:	4899                	li	a7,6
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <exec>:
.global exec
exec:
 li a7, SYS_exec
 614:	489d                	li	a7,7
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <open>:
.global open
open:
 li a7, SYS_open
 61c:	48bd                	li	a7,15
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 624:	48c5                	li	a7,17
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 62c:	48c9                	li	a7,18
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 634:	48a1                	li	a7,8
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <link>:
.global link
link:
 li a7, SYS_link
 63c:	48cd                	li	a7,19
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 644:	48d1                	li	a7,20
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 64c:	48a5                	li	a7,9
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <dup>:
.global dup
dup:
 li a7, SYS_dup
 654:	48a9                	li	a7,10
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 65c:	48ad                	li	a7,11
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 664:	48b1                	li	a7,12
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 66c:	48b5                	li	a7,13
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 674:	48b9                	li	a7,14
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <reg>:
.global reg
reg:
 li a7, SYS_reg
 67c:	48d9                	li	a7,22
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 684:	1101                	addi	sp,sp,-32
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	feb407a3          	sb	a1,-17(s0)
 690:	4605                	li	a2,1
 692:	fef40593          	addi	a1,s0,-17
 696:	00000097          	auipc	ra,0x0
 69a:	f66080e7          	jalr	-154(ra) # 5fc <write>
 69e:	60e2                	ld	ra,24(sp)
 6a0:	6442                	ld	s0,16(sp)
 6a2:	6105                	addi	sp,sp,32
 6a4:	8082                	ret

00000000000006a6 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 6a6:	7139                	addi	sp,sp,-64
 6a8:	fc06                	sd	ra,56(sp)
 6aa:	f822                	sd	s0,48(sp)
 6ac:	f426                	sd	s1,40(sp)
 6ae:	0080                	addi	s0,sp,64
 6b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 6b2:	c299                	beqz	a3,6b8 <printint+0x12>
 6b4:	0805cb63          	bltz	a1,74a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6b8:	2581                	sext.w	a1,a1
  neg = 0;
 6ba:	4881                	li	a7,0
 6bc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 6c2:	2601                	sext.w	a2,a2
 6c4:	00000517          	auipc	a0,0x0
 6c8:	56c50513          	addi	a0,a0,1388 # c30 <digits>
 6cc:	883a                	mv	a6,a4
 6ce:	2705                	addiw	a4,a4,1
 6d0:	02c5f7bb          	remuw	a5,a1,a2
 6d4:	1782                	slli	a5,a5,0x20
 6d6:	9381                	srli	a5,a5,0x20
 6d8:	97aa                	add	a5,a5,a0
 6da:	0007c783          	lbu	a5,0(a5)
 6de:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 6e2:	0005879b          	sext.w	a5,a1
 6e6:	02c5d5bb          	divuw	a1,a1,a2
 6ea:	0685                	addi	a3,a3,1
 6ec:	fec7f0e3          	bgeu	a5,a2,6cc <printint+0x26>
  if (neg) buf[i++] = '-';
 6f0:	00088c63          	beqz	a7,708 <printint+0x62>
 6f4:	fd070793          	addi	a5,a4,-48
 6f8:	00878733          	add	a4,a5,s0
 6fc:	02d00793          	li	a5,45
 700:	fef70823          	sb	a5,-16(a4)
 704:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 708:	02e05c63          	blez	a4,740 <printint+0x9a>
 70c:	f04a                	sd	s2,32(sp)
 70e:	ec4e                	sd	s3,24(sp)
 710:	fc040793          	addi	a5,s0,-64
 714:	00e78933          	add	s2,a5,a4
 718:	fff78993          	addi	s3,a5,-1
 71c:	99ba                	add	s3,s3,a4
 71e:	377d                	addiw	a4,a4,-1
 720:	1702                	slli	a4,a4,0x20
 722:	9301                	srli	a4,a4,0x20
 724:	40e989b3          	sub	s3,s3,a4
 728:	fff94583          	lbu	a1,-1(s2)
 72c:	8526                	mv	a0,s1
 72e:	00000097          	auipc	ra,0x0
 732:	f56080e7          	jalr	-170(ra) # 684 <putc>
 736:	197d                	addi	s2,s2,-1
 738:	ff3918e3          	bne	s2,s3,728 <printint+0x82>
 73c:	7902                	ld	s2,32(sp)
 73e:	69e2                	ld	s3,24(sp)
}
 740:	70e2                	ld	ra,56(sp)
 742:	7442                	ld	s0,48(sp)
 744:	74a2                	ld	s1,40(sp)
 746:	6121                	addi	sp,sp,64
 748:	8082                	ret
    x = -xx;
 74a:	40b005bb          	negw	a1,a1
    neg = 1;
 74e:	4885                	li	a7,1
    x = -xx;
 750:	b7b5                	j	6bc <printint+0x16>

0000000000000752 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 752:	715d                	addi	sp,sp,-80
 754:	e486                	sd	ra,72(sp)
 756:	e0a2                	sd	s0,64(sp)
 758:	f84a                	sd	s2,48(sp)
 75a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 75c:	0005c903          	lbu	s2,0(a1)
 760:	1a090a63          	beqz	s2,914 <vprintf+0x1c2>
 764:	fc26                	sd	s1,56(sp)
 766:	f44e                	sd	s3,40(sp)
 768:	f052                	sd	s4,32(sp)
 76a:	ec56                	sd	s5,24(sp)
 76c:	e85a                	sd	s6,16(sp)
 76e:	e45e                	sd	s7,8(sp)
 770:	8aaa                	mv	s5,a0
 772:	8bb2                	mv	s7,a2
 774:	00158493          	addi	s1,a1,1
  state = 0;
 778:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 77a:	02500a13          	li	s4,37
 77e:	4b55                	li	s6,21
 780:	a839                	j	79e <vprintf+0x4c>
        putc(fd, c);
 782:	85ca                	mv	a1,s2
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	efe080e7          	jalr	-258(ra) # 684 <putc>
 78e:	a019                	j	794 <vprintf+0x42>
    } else if (state == '%') {
 790:	01498d63          	beq	s3,s4,7aa <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
 794:	0485                	addi	s1,s1,1
 796:	fff4c903          	lbu	s2,-1(s1)
 79a:	16090763          	beqz	s2,908 <vprintf+0x1b6>
    if (state == 0) {
 79e:	fe0999e3          	bnez	s3,790 <vprintf+0x3e>
      if (c == '%') {
 7a2:	ff4910e3          	bne	s2,s4,782 <vprintf+0x30>
        state = '%';
 7a6:	89d2                	mv	s3,s4
 7a8:	b7f5                	j	794 <vprintf+0x42>
      if (c == 'd') {
 7aa:	13490463          	beq	s2,s4,8d2 <vprintf+0x180>
 7ae:	f9d9079b          	addiw	a5,s2,-99
 7b2:	0ff7f793          	zext.b	a5,a5
 7b6:	12fb6763          	bltu	s6,a5,8e4 <vprintf+0x192>
 7ba:	f9d9079b          	addiw	a5,s2,-99
 7be:	0ff7f713          	zext.b	a4,a5
 7c2:	12eb6163          	bltu	s6,a4,8e4 <vprintf+0x192>
 7c6:	00271793          	slli	a5,a4,0x2
 7ca:	00000717          	auipc	a4,0x0
 7ce:	40e70713          	addi	a4,a4,1038 # bd8 <loop+0x80>
 7d2:	97ba                	add	a5,a5,a4
 7d4:	439c                	lw	a5,0(a5)
 7d6:	97ba                	add	a5,a5,a4
 7d8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4685                	li	a3,1
 7e0:	4629                	li	a2,10
 7e2:	000ba583          	lw	a1,0(s7)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	ebe080e7          	jalr	-322(ra) # 6a6 <printint>
 7f0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b745                	j	794 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	008b8913          	addi	s2,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4629                	li	a2,10
 7fe:	000ba583          	lw	a1,0(s7)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	ea2080e7          	jalr	-350(ra) # 6a6 <printint>
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	b751                	j	794 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 812:	008b8913          	addi	s2,s7,8
 816:	4681                	li	a3,0
 818:	4641                	li	a2,16
 81a:	000ba583          	lw	a1,0(s7)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e86080e7          	jalr	-378(ra) # 6a6 <printint>
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b7a5                	j	794 <vprintf+0x42>
 82e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 830:	008b8c13          	addi	s8,s7,8
 834:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 838:	03000593          	li	a1,48
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	e46080e7          	jalr	-442(ra) # 684 <putc>
  putc(fd, 'x');
 846:	07800593          	li	a1,120
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e38080e7          	jalr	-456(ra) # 684 <putc>
 854:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 856:	00000b97          	auipc	s7,0x0
 85a:	3dab8b93          	addi	s7,s7,986 # c30 <digits>
 85e:	03c9d793          	srli	a5,s3,0x3c
 862:	97de                	add	a5,a5,s7
 864:	0007c583          	lbu	a1,0(a5)
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	e1a080e7          	jalr	-486(ra) # 684 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 872:	0992                	slli	s3,s3,0x4
 874:	397d                	addiw	s2,s2,-1
 876:	fe0914e3          	bnez	s2,85e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 87a:	8be2                	mv	s7,s8
      state = 0;
 87c:	4981                	li	s3,0
 87e:	6c02                	ld	s8,0(sp)
 880:	bf11                	j	794 <vprintf+0x42>
        s = va_arg(ap, char *);
 882:	008b8993          	addi	s3,s7,8
 886:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
 88a:	02090163          	beqz	s2,8ac <vprintf+0x15a>
        while (*s != 0) {
 88e:	00094583          	lbu	a1,0(s2)
 892:	c9a5                	beqz	a1,902 <vprintf+0x1b0>
          putc(fd, *s);
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	dee080e7          	jalr	-530(ra) # 684 <putc>
          s++;
 89e:	0905                	addi	s2,s2,1
        while (*s != 0) {
 8a0:	00094583          	lbu	a1,0(s2)
 8a4:	f9e5                	bnez	a1,894 <vprintf+0x142>
        s = va_arg(ap, char *);
 8a6:	8bce                	mv	s7,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	b5ed                	j	794 <vprintf+0x42>
        if (s == 0) s = "(null)";
 8ac:	00000917          	auipc	s2,0x0
 8b0:	32490913          	addi	s2,s2,804 # bd0 <loop+0x78>
        while (*s != 0) {
 8b4:	02800593          	li	a1,40
 8b8:	bff1                	j	894 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8ba:	008b8913          	addi	s2,s7,8
 8be:	000bc583          	lbu	a1,0(s7)
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	dc0080e7          	jalr	-576(ra) # 684 <putc>
 8cc:	8bca                	mv	s7,s2
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b5d1                	j	794 <vprintf+0x42>
        putc(fd, c);
 8d2:	02500593          	li	a1,37
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	dac080e7          	jalr	-596(ra) # 684 <putc>
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	bd4d                	j	794 <vprintf+0x42>
        putc(fd, '%');
 8e4:	02500593          	li	a1,37
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	d9a080e7          	jalr	-614(ra) # 684 <putc>
        putc(fd, c);
 8f2:	85ca                	mv	a1,s2
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	d8e080e7          	jalr	-626(ra) # 684 <putc>
      state = 0;
 8fe:	4981                	li	s3,0
 900:	bd51                	j	794 <vprintf+0x42>
        s = va_arg(ap, char *);
 902:	8bce                	mv	s7,s3
      state = 0;
 904:	4981                	li	s3,0
 906:	b579                	j	794 <vprintf+0x42>
 908:	74e2                	ld	s1,56(sp)
 90a:	79a2                	ld	s3,40(sp)
 90c:	7a02                	ld	s4,32(sp)
 90e:	6ae2                	ld	s5,24(sp)
 910:	6b42                	ld	s6,16(sp)
 912:	6ba2                	ld	s7,8(sp)
    }
  }
}
 914:	60a6                	ld	ra,72(sp)
 916:	6406                	ld	s0,64(sp)
 918:	7942                	ld	s2,48(sp)
 91a:	6161                	addi	sp,sp,80
 91c:	8082                	ret

000000000000091e <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 91e:	715d                	addi	sp,sp,-80
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	1000                	addi	s0,sp,32
 926:	e010                	sd	a2,0(s0)
 928:	e414                	sd	a3,8(s0)
 92a:	e818                	sd	a4,16(s0)
 92c:	ec1c                	sd	a5,24(s0)
 92e:	03043023          	sd	a6,32(s0)
 932:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 936:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93a:	8622                	mv	a2,s0
 93c:	00000097          	auipc	ra,0x0
 940:	e16080e7          	jalr	-490(ra) # 752 <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6161                	addi	sp,sp,80
 94a:	8082                	ret

000000000000094c <printf>:

void printf(const char *fmt, ...) {
 94c:	711d                	addi	sp,sp,-96
 94e:	ec06                	sd	ra,24(sp)
 950:	e822                	sd	s0,16(sp)
 952:	1000                	addi	s0,sp,32
 954:	e40c                	sd	a1,8(s0)
 956:	e810                	sd	a2,16(s0)
 958:	ec14                	sd	a3,24(s0)
 95a:	f018                	sd	a4,32(s0)
 95c:	f41c                	sd	a5,40(s0)
 95e:	03043823          	sd	a6,48(s0)
 962:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 966:	00840613          	addi	a2,s0,8
 96a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 96e:	85aa                	mv	a1,a0
 970:	4505                	li	a0,1
 972:	00000097          	auipc	ra,0x0
 976:	de0080e7          	jalr	-544(ra) # 752 <vprintf>
}
 97a:	60e2                	ld	ra,24(sp)
 97c:	6442                	ld	s0,16(sp)
 97e:	6125                	addi	sp,sp,96
 980:	8082                	ret

0000000000000982 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 982:	1141                	addi	sp,sp,-16
 984:	e422                	sd	s0,8(sp)
 986:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 988:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	00001797          	auipc	a5,0x1
 990:	6747b783          	ld	a5,1652(a5) # 2000 <freep>
 994:	a02d                	j	9be <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 996:	4618                	lw	a4,8(a2)
 998:	9f2d                	addw	a4,a4,a1
 99a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 99e:	6398                	ld	a4,0(a5)
 9a0:	6310                	ld	a2,0(a4)
 9a2:	a83d                	j	9e0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 9a4:	ff852703          	lw	a4,-8(a0)
 9a8:	9f31                	addw	a4,a4,a2
 9aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9ac:	ff053683          	ld	a3,-16(a0)
 9b0:	a091                	j	9f4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 9b2:	6398                	ld	a4,0(a5)
 9b4:	00e7e463          	bltu	a5,a4,9bc <free+0x3a>
 9b8:	00e6ea63          	bltu	a3,a4,9cc <free+0x4a>
void free(void *ap) {
 9bc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9be:	fed7fae3          	bgeu	a5,a3,9b2 <free+0x30>
 9c2:	6398                	ld	a4,0(a5)
 9c4:	00e6e463          	bltu	a3,a4,9cc <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 9c8:	fee7eae3          	bltu	a5,a4,9bc <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 9cc:	ff852583          	lw	a1,-8(a0)
 9d0:	6390                	ld	a2,0(a5)
 9d2:	02059813          	slli	a6,a1,0x20
 9d6:	01c85713          	srli	a4,a6,0x1c
 9da:	9736                	add	a4,a4,a3
 9dc:	fae60de3          	beq	a2,a4,996 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9e0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9e4:	4790                	lw	a2,8(a5)
 9e6:	02061593          	slli	a1,a2,0x20
 9ea:	01c5d713          	srli	a4,a1,0x1c
 9ee:	973e                	add	a4,a4,a5
 9f0:	fae68ae3          	beq	a3,a4,9a4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f6:	00001717          	auipc	a4,0x1
 9fa:	60f73523          	sd	a5,1546(a4) # 2000 <freep>
}
 9fe:	6422                	ld	s0,8(sp)
 a00:	0141                	addi	sp,sp,16
 a02:	8082                	ret

0000000000000a04 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 a04:	7139                	addi	sp,sp,-64
 a06:	fc06                	sd	ra,56(sp)
 a08:	f822                	sd	s0,48(sp)
 a0a:	f426                	sd	s1,40(sp)
 a0c:	ec4e                	sd	s3,24(sp)
 a0e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a10:	02051493          	slli	s1,a0,0x20
 a14:	9081                	srli	s1,s1,0x20
 a16:	04bd                	addi	s1,s1,15
 a18:	8091                	srli	s1,s1,0x4
 a1a:	0014899b          	addiw	s3,s1,1
 a1e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 a20:	00001517          	auipc	a0,0x1
 a24:	5e053503          	ld	a0,1504(a0) # 2000 <freep>
 a28:	c915                	beqz	a0,a5c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a2a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a2c:	4798                	lw	a4,8(a5)
 a2e:	08977e63          	bgeu	a4,s1,aca <malloc+0xc6>
 a32:	f04a                	sd	s2,32(sp)
 a34:	e852                	sd	s4,16(sp)
 a36:	e456                	sd	s5,8(sp)
 a38:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
 a3a:	8a4e                	mv	s4,s3
 a3c:	0009871b          	sext.w	a4,s3
 a40:	6685                	lui	a3,0x1
 a42:	00d77363          	bgeu	a4,a3,a48 <malloc+0x44>
 a46:	6a05                	lui	s4,0x1
 a48:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a4c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a50:	00001917          	auipc	s2,0x1
 a54:	5b090913          	addi	s2,s2,1456 # 2000 <freep>
  if (p == (char *)-1) return 0;
 a58:	5afd                	li	s5,-1
 a5a:	a091                	j	a9e <malloc+0x9a>
 a5c:	f04a                	sd	s2,32(sp)
 a5e:	e852                	sd	s4,16(sp)
 a60:	e456                	sd	s5,8(sp)
 a62:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a64:	00001797          	auipc	a5,0x1
 a68:	5bc78793          	addi	a5,a5,1468 # 2020 <base>
 a6c:	00001717          	auipc	a4,0x1
 a70:	58f73a23          	sd	a5,1428(a4) # 2000 <freep>
 a74:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a76:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a7a:	b7c1                	j	a3a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a7c:	6398                	ld	a4,0(a5)
 a7e:	e118                	sd	a4,0(a0)
 a80:	a08d                	j	ae2 <malloc+0xde>
  hp->s.size = nu;
 a82:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a86:	0541                	addi	a0,a0,16
 a88:	00000097          	auipc	ra,0x0
 a8c:	efa080e7          	jalr	-262(ra) # 982 <free>
  return freep;
 a90:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 a94:	c13d                	beqz	a0,afa <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a96:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a98:	4798                	lw	a4,8(a5)
 a9a:	02977463          	bgeu	a4,s1,ac2 <malloc+0xbe>
    if (p == freep)
 a9e:	00093703          	ld	a4,0(s2)
 aa2:	853e                	mv	a0,a5
 aa4:	fef719e3          	bne	a4,a5,a96 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 aa8:	8552                	mv	a0,s4
 aaa:	00000097          	auipc	ra,0x0
 aae:	bba080e7          	jalr	-1094(ra) # 664 <sbrk>
  if (p == (char *)-1) return 0;
 ab2:	fd5518e3          	bne	a0,s5,a82 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
 ab6:	4501                	li	a0,0
 ab8:	7902                	ld	s2,32(sp)
 aba:	6a42                	ld	s4,16(sp)
 abc:	6aa2                	ld	s5,8(sp)
 abe:	6b02                	ld	s6,0(sp)
 ac0:	a03d                	j	aee <malloc+0xea>
 ac2:	7902                	ld	s2,32(sp)
 ac4:	6a42                	ld	s4,16(sp)
 ac6:	6aa2                	ld	s5,8(sp)
 ac8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 aca:	fae489e3          	beq	s1,a4,a7c <malloc+0x78>
        p->s.size -= nunits;
 ace:	4137073b          	subw	a4,a4,s3
 ad2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad4:	02071693          	slli	a3,a4,0x20
 ad8:	01c6d713          	srli	a4,a3,0x1c
 adc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ade:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae2:	00001717          	auipc	a4,0x1
 ae6:	50a73f23          	sd	a0,1310(a4) # 2000 <freep>
      return (void *)(p + 1);
 aea:	01078513          	addi	a0,a5,16
  }
}
 aee:	70e2                	ld	ra,56(sp)
 af0:	7442                	ld	s0,48(sp)
 af2:	74a2                	ld	s1,40(sp)
 af4:	69e2                	ld	s3,24(sp)
 af6:	6121                	addi	sp,sp,64
 af8:	8082                	ret
 afa:	7902                	ld	s2,32(sp)
 afc:	6a42                	ld	s4,16(sp)
 afe:	6aa2                	ld	s5,8(sp)
 b00:	6b02                	ld	s6,0(sp)
 b02:	b7f5                	j	aee <malloc+0xea>

0000000000000b04 <reg_test1_asm>:
#include "kernel/syscall.h"
.globl reg_test1_asm
reg_test1_asm:
  li s2, 2
 b04:	4909                	li	s2,2
  li s3, 3
 b06:	498d                	li	s3,3
  li s4, 4
 b08:	4a11                	li	s4,4
  li s5, 5
 b0a:	4a95                	li	s5,5
  li s6, 6
 b0c:	4b19                	li	s6,6
  li s7, 7
 b0e:	4b9d                	li	s7,7
  li s8, 8
 b10:	4c21                	li	s8,8
  li s9, 9
 b12:	4ca5                	li	s9,9
  li s10, 10
 b14:	4d29                	li	s10,10
  li s11, 11
 b16:	4dad                	li	s11,11
  li a7, SYS_write
 b18:	48c1                	li	a7,16
  ecall
 b1a:	00000073          	ecall
  j loop
 b1e:	a82d                	j	b58 <loop>

0000000000000b20 <reg_test2_asm>:

.globl reg_test2_asm
reg_test2_asm:
  li s2, 4
 b20:	4911                	li	s2,4
  li s3, 9
 b22:	49a5                	li	s3,9
  li s4, 16
 b24:	4a41                	li	s4,16
  li s5, 25
 b26:	4ae5                	li	s5,25
  li s6, 36
 b28:	02400b13          	li	s6,36
  li s7, 49
 b2c:	03100b93          	li	s7,49
  li s8, 64
 b30:	04000c13          	li	s8,64
  li s9, 81
 b34:	05100c93          	li	s9,81
  li s10, 100
 b38:	06400d13          	li	s10,100
  li s11, 121
 b3c:	07900d93          	li	s11,121
  li a7, SYS_write
 b40:	48c1                	li	a7,16
  ecall
 b42:	00000073          	ecall
  j loop
 b46:	a809                	j	b58 <loop>

0000000000000b48 <reg_test3_asm>:

.globl reg_test3_asm
reg_test3_asm:
  li s2, 1337
 b48:	53900913          	li	s2,1337
  mv a2, a1
 b4c:	862e                	mv	a2,a1
  li a1, 2
 b4e:	4589                	li	a1,2
#ifdef SYS_reg
  li a7, SYS_reg
 b50:	48d9                	li	a7,22
  ecall
 b52:	00000073          	ecall
#endif
  ret
 b56:	8082                	ret

0000000000000b58 <loop>:

loop:
  j loop
 b58:	a001                	j	b58 <loop>
  ret
 b5a:	8082                	ret
