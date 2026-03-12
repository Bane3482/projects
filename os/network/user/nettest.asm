
user/_nettest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <txone>:
// send a single UDP packet (but don't recv() the reply).
// python3 nettest.py txone can be used to wait for
// this packet, and you can also see what
// happened with tcpdump -XXnr packets.pcap
//
int txone() {
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  printf("txone: sending one packet\n");
       8:	00002517          	auipc	a0,0x2
       c:	6c850513          	addi	a0,a0,1736 # 26d0 <malloc+0x10c>
      10:	00002097          	auipc	ra,0x2
      14:	4fc080e7          	jalr	1276(ra) # 250c <printf>
  uint32 dst = 0x0A000202;  // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  buf[0] = 't';
      18:	07400793          	li	a5,116
      1c:	fef40423          	sb	a5,-24(s0)
  buf[1] = 'x';
      20:	07800793          	li	a5,120
      24:	fef404a3          	sb	a5,-23(s0)
  buf[2] = 'o';
      28:	06f00793          	li	a5,111
      2c:	fef40523          	sb	a5,-22(s0)
  buf[3] = 'n';
      30:	06e00793          	li	a5,110
      34:	fef405a3          	sb	a5,-21(s0)
  buf[4] = 'e';
      38:	06500793          	li	a5,101
      3c:	fef40623          	sb	a5,-20(s0)
  if (send(2003, dst, dport, buf, 5) < 0) {
      40:	4715                	li	a4,5
      42:	fe840693          	addi	a3,s0,-24
      46:	6619                	lui	a2,0x6
      48:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
      4c:	0a0005b7          	lui	a1,0xa000
      50:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
      54:	7d300513          	li	a0,2003
      58:	00002097          	auipc	ra,0x2
      5c:	1dc080e7          	jalr	476(ra) # 2234 <send>
    printf("FAILED txone: send() failed\n");
    return 0;
  }
  return 1;
      60:	4785                	li	a5,1
  if (send(2003, dst, dport, buf, 5) < 0) {
      62:	00054763          	bltz	a0,70 <txone+0x70>
}
      66:	853e                	mv	a0,a5
      68:	60e2                	ld	ra,24(sp)
      6a:	6442                	ld	s0,16(sp)
      6c:	6105                	addi	sp,sp,32
      6e:	8082                	ret
    printf("FAILED txone: send() failed\n");
      70:	00002517          	auipc	a0,0x2
      74:	68050513          	addi	a0,a0,1664 # 26f0 <malloc+0x12c>
      78:	00002097          	auipc	ra,0x2
      7c:	494080e7          	jalr	1172(ra) # 250c <printf>
    return 0;
      80:	4781                	li	a5,0
      82:	b7d5                	j	66 <txone+0x66>

0000000000000084 <rx>:
//
// test just receive.
// outside of qemu, run
//   ./nettest.py rx
//
int rx(char *name) {
      84:	7151                	addi	sp,sp,-240
      86:	f586                	sd	ra,232(sp)
      88:	f1a2                	sd	s0,224(sp)
      8a:	eda6                	sd	s1,216(sp)
      8c:	e9ca                	sd	s2,208(sp)
      8e:	e5ce                	sd	s3,200(sp)
      90:	e1d2                	sd	s4,192(sp)
      92:	fd56                	sd	s5,184(sp)
      94:	f95a                	sd	s6,176(sp)
      96:	f55e                	sd	s7,168(sp)
      98:	f162                	sd	s8,160(sp)
      9a:	ed66                	sd	s9,152(sp)
      9c:	1980                	addi	s0,sp,240
      9e:	84aa                	mv	s1,a0
  bind(FWDPORT1);
      a0:	7d000513          	li	a0,2000
      a4:	00002097          	auipc	ra,0x2
      a8:	180080e7          	jalr	384(ra) # 2224 <bind>
      ac:	4a91                	li	s5,4

  int lastseq = -1;
      ae:	5a7d                	li	s4,-1
    if (cc < 0) {
      printf("FAILED %s: recv() failed\n", name);
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
      b0:	0a000937          	lui	s2,0xa000
      b4:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
      printf("FAILED %s: wrong ip src %x\n", name, src);
      return 0;
    }

    if (cc < strlen("packet 1")) {
      b8:	00002b17          	auipc	s6,0x2
      bc:	698b0b13          	addi	s6,s6,1688 # 2750 <malloc+0x18c>
      printf("FAILED %s: len %d too short\n", name, cc);
      return 0;
    }

    if (cc > strlen("packet xxxxxx")) {
      c0:	00002b97          	auipc	s7,0x2
      c4:	6c0b8b93          	addi	s7,s7,1728 # 2780 <malloc+0x1bc>
      printf("FAILED %s: len %d too long\n", name, cc);
      return 0;
    }

    if (memcmp(ibuf, "packet ", strlen("packet ")) != 0) {
      c8:	00002997          	auipc	s3,0x2
      cc:	6e898993          	addi	s3,s3,1768 # 27b0 <malloc+0x1ec>
    int cc = recv(FWDPORT1, &src, &sport, ibuf, sizeof(ibuf) - 1);
      d0:	07f00713          	li	a4,127
      d4:	f2040693          	addi	a3,s0,-224
      d8:	f1a40613          	addi	a2,s0,-230
      dc:	f1c40593          	addi	a1,s0,-228
      e0:	7d000513          	li	a0,2000
      e4:	00002097          	auipc	ra,0x2
      e8:	158080e7          	jalr	344(ra) # 223c <recv>
      ec:	8caa                	mv	s9,a0
    if (cc < 0) {
      ee:	10054863          	bltz	a0,1fe <rx+0x17a>
    if (src != 0x0A000202) {  // 10.0.2.2
      f2:	f1c42603          	lw	a2,-228(s0)
      f6:	11261e63          	bne	a2,s2,212 <rx+0x18e>
    if (cc < strlen("packet 1")) {
      fa:	855a                	mv	a0,s6
      fc:	00002097          	auipc	ra,0x2
     100:	e64080e7          	jalr	-412(ra) # 1f60 <strlen>
     104:	2501                	sext.w	a0,a0
     106:	000c8c1b          	sext.w	s8,s9
     10a:	10ac6e63          	bltu	s8,a0,226 <rx+0x1a2>
    if (cc > strlen("packet xxxxxx")) {
     10e:	855e                	mv	a0,s7
     110:	00002097          	auipc	ra,0x2
     114:	e50080e7          	jalr	-432(ra) # 1f60 <strlen>
     118:	2501                	sext.w	a0,a0
     11a:	13856163          	bltu	a0,s8,23c <rx+0x1b8>
    if (memcmp(ibuf, "packet ", strlen("packet ")) != 0) {
     11e:	854e                	mv	a0,s3
     120:	00002097          	auipc	ra,0x2
     124:	e40080e7          	jalr	-448(ra) # 1f60 <strlen>
     128:	0005061b          	sext.w	a2,a0
     12c:	85ce                	mv	a1,s3
     12e:	f2040513          	addi	a0,s0,-224
     132:	00002097          	auipc	ra,0x2
     136:	ff8080e7          	jalr	-8(ra) # 212a <memcmp>
     13a:	10051c63          	bnez	a0,252 <rx+0x1ce>
      printf("FAILED %s: packet doesn't start with packet\n", name);
      return 0;
    }

#define isdigit(x) ((x) >= '0' && (x) <= '9')
    if (!isdigit(ibuf[7])) {
     13e:	f2744583          	lbu	a1,-217(s0)
     142:	fd05879b          	addiw	a5,a1,-48
     146:	0ff7f793          	zext.b	a5,a5
     14a:	4725                	li	a4,9
     14c:	10f76d63          	bltu	a4,a5,266 <rx+0x1e2>
      printf("FAILED %s: packet doesn't contain a number\n", name);
      return 0;
    }
    for (int i = 7; i < cc; i++) {
     150:	479d                	li	a5,7
     152:	0397d763          	bge	a5,s9,180 <rx+0xfc>
     156:	f2740713          	addi	a4,s0,-217
     15a:	ff8c069b          	addiw	a3,s8,-8
     15e:	1682                	slli	a3,a3,0x20
     160:	9281                	srli	a3,a3,0x20
     162:	f2840793          	addi	a5,s0,-216
     166:	96be                	add	a3,a3,a5
      if (!isdigit(ibuf[i])) {
     168:	4625                	li	a2,9
     16a:	00074783          	lbu	a5,0(a4)
     16e:	fd07879b          	addiw	a5,a5,-48
     172:	0ff7f793          	zext.b	a5,a5
     176:	10f66263          	bltu	a2,a5,27a <rx+0x1f6>
    for (int i = 7; i < cc; i++) {
     17a:	0705                	addi	a4,a4,1
     17c:	fed717e3          	bne	a4,a3,16a <rx+0xe6>
        printf("FAILED %s: packet contains non-digits in the number\n", name);
        return 0;
      }
    }
    int seq = ibuf[7] - '0';
     180:	fd05859b          	addiw	a1,a1,-48
     184:	00058c1b          	sext.w	s8,a1
    if (isdigit(ibuf[8])) {
     188:	f2844783          	lbu	a5,-216(s0)
     18c:	fd07871b          	addiw	a4,a5,-48
     190:	0ff77713          	zext.b	a4,a4
     194:	46a5                	li	a3,9
     196:	02e6ef63          	bltu	a3,a4,1d4 <rx+0x150>
      seq *= 10;
     19a:	0025971b          	slliw	a4,a1,0x2
     19e:	9f2d                	addw	a4,a4,a1
     1a0:	0017171b          	slliw	a4,a4,0x1
      seq += ibuf[8] - '0';
     1a4:	fd07879b          	addiw	a5,a5,-48
     1a8:	9fb9                	addw	a5,a5,a4
     1aa:	00078c1b          	sext.w	s8,a5
      if (isdigit(ibuf[9])) {
     1ae:	f2944683          	lbu	a3,-215(s0)
     1b2:	fd06871b          	addiw	a4,a3,-48
     1b6:	0ff77713          	zext.b	a4,a4
     1ba:	4625                	li	a2,9
     1bc:	00e66c63          	bltu	a2,a4,1d4 <rx+0x150>
        seq *= 10;
     1c0:	00279c1b          	slliw	s8,a5,0x2
     1c4:	00fc0c3b          	addw	s8,s8,a5
     1c8:	001c1c1b          	slliw	s8,s8,0x1
        seq += ibuf[9] - '0';
     1cc:	fd06869b          	addiw	a3,a3,-48
     1d0:	01868c3b          	addw	s8,a3,s8
      }
    }

    printf("%s: receive one UDP packet %d\n", name, seq);
     1d4:	8662                	mv	a2,s8
     1d6:	85a6                	mv	a1,s1
     1d8:	00002517          	auipc	a0,0x2
     1dc:	67850513          	addi	a0,a0,1656 # 2850 <malloc+0x28c>
     1e0:	00002097          	auipc	ra,0x2
     1e4:	32c080e7          	jalr	812(ra) # 250c <printf>

    if (lastseq != -1) {
     1e8:	57fd                	li	a5,-1
     1ea:	00fa0563          	beq	s4,a5,1f4 <rx+0x170>
      if (seq != lastseq + 1) {
     1ee:	2a05                	addiw	s4,s4,1
     1f0:	0b8a1c63          	bne	s4,s8,2a8 <rx+0x224>
  while (ok < 4) {
     1f4:	3afd                	addiw	s5,s5,-1
     1f6:	0c0a8563          	beqz	s5,2c0 <rx+0x23c>
     1fa:	8a62                	mv	s4,s8
     1fc:	bdd1                	j	d0 <rx+0x4c>
      printf("FAILED %s: recv() failed\n", name);
     1fe:	85a6                	mv	a1,s1
     200:	00002517          	auipc	a0,0x2
     204:	51050513          	addi	a0,a0,1296 # 2710 <malloc+0x14c>
     208:	00002097          	auipc	ra,0x2
     20c:	304080e7          	jalr	772(ra) # 250c <printf>
      return 0;
     210:	a8b5                	j	28c <rx+0x208>
      printf("FAILED %s: wrong ip src %x\n", name, src);
     212:	85a6                	mv	a1,s1
     214:	00002517          	auipc	a0,0x2
     218:	51c50513          	addi	a0,a0,1308 # 2730 <malloc+0x16c>
     21c:	00002097          	auipc	ra,0x2
     220:	2f0080e7          	jalr	752(ra) # 250c <printf>
      return 0;
     224:	a0a5                	j	28c <rx+0x208>
      printf("FAILED %s: len %d too short\n", name, cc);
     226:	8666                	mv	a2,s9
     228:	85a6                	mv	a1,s1
     22a:	00002517          	auipc	a0,0x2
     22e:	53650513          	addi	a0,a0,1334 # 2760 <malloc+0x19c>
     232:	00002097          	auipc	ra,0x2
     236:	2da080e7          	jalr	730(ra) # 250c <printf>
      return 0;
     23a:	a889                	j	28c <rx+0x208>
      printf("FAILED %s: len %d too long\n", name, cc);
     23c:	8666                	mv	a2,s9
     23e:	85a6                	mv	a1,s1
     240:	00002517          	auipc	a0,0x2
     244:	55050513          	addi	a0,a0,1360 # 2790 <malloc+0x1cc>
     248:	00002097          	auipc	ra,0x2
     24c:	2c4080e7          	jalr	708(ra) # 250c <printf>
      return 0;
     250:	a835                	j	28c <rx+0x208>
      printf("FAILED %s: packet doesn't start with packet\n", name);
     252:	85a6                	mv	a1,s1
     254:	00002517          	auipc	a0,0x2
     258:	56450513          	addi	a0,a0,1380 # 27b8 <malloc+0x1f4>
     25c:	00002097          	auipc	ra,0x2
     260:	2b0080e7          	jalr	688(ra) # 250c <printf>
      return 0;
     264:	a025                	j	28c <rx+0x208>
      printf("FAILED %s: packet doesn't contain a number\n", name);
     266:	85a6                	mv	a1,s1
     268:	00002517          	auipc	a0,0x2
     26c:	58050513          	addi	a0,a0,1408 # 27e8 <malloc+0x224>
     270:	00002097          	auipc	ra,0x2
     274:	29c080e7          	jalr	668(ra) # 250c <printf>
      return 0;
     278:	a811                	j	28c <rx+0x208>
        printf("FAILED %s: packet contains non-digits in the number\n", name);
     27a:	85a6                	mv	a1,s1
     27c:	00002517          	auipc	a0,0x2
     280:	59c50513          	addi	a0,a0,1436 # 2818 <malloc+0x254>
     284:	00002097          	auipc	ra,0x2
     288:	288080e7          	jalr	648(ra) # 250c <printf>
      return 0;
     28c:	4501                	li	a0,0

  unbind(FWDPORT1);
  printf("%s: OK\n", name);

  return 1;
}
     28e:	70ae                	ld	ra,232(sp)
     290:	740e                	ld	s0,224(sp)
     292:	64ee                	ld	s1,216(sp)
     294:	694e                	ld	s2,208(sp)
     296:	69ae                	ld	s3,200(sp)
     298:	6a0e                	ld	s4,192(sp)
     29a:	7aea                	ld	s5,184(sp)
     29c:	7b4a                	ld	s6,176(sp)
     29e:	7baa                	ld	s7,168(sp)
     2a0:	7c0a                	ld	s8,160(sp)
     2a2:	6cea                	ld	s9,152(sp)
     2a4:	616d                	addi	sp,sp,240
     2a6:	8082                	ret
        printf("FAILED %s: got seq %d, expecting %d\n", name, seq, lastseq + 1);
     2a8:	86d2                	mv	a3,s4
     2aa:	8662                	mv	a2,s8
     2ac:	85a6                	mv	a1,s1
     2ae:	00002517          	auipc	a0,0x2
     2b2:	5c250513          	addi	a0,a0,1474 # 2870 <malloc+0x2ac>
     2b6:	00002097          	auipc	ra,0x2
     2ba:	256080e7          	jalr	598(ra) # 250c <printf>
        return 0;
     2be:	b7f9                	j	28c <rx+0x208>
  unbind(FWDPORT1);
     2c0:	7d000513          	li	a0,2000
     2c4:	00002097          	auipc	ra,0x2
     2c8:	f68080e7          	jalr	-152(ra) # 222c <unbind>
  printf("%s: OK\n", name);
     2cc:	85a6                	mv	a1,s1
     2ce:	00002517          	auipc	a0,0x2
     2d2:	5ca50513          	addi	a0,a0,1482 # 2898 <malloc+0x2d4>
     2d6:	00002097          	auipc	ra,0x2
     2da:	236080e7          	jalr	566(ra) # 250c <printf>
  return 1;
     2de:	4505                	li	a0,1
     2e0:	b77d                	j	28e <rx+0x20a>

00000000000002e2 <rx2>:
//
// test receive on two different ports, interleaved.
// outside of qemu, run
//   ./nettest.py rx2
//
int rx2(int port1, int port2) {
     2e2:	7151                	addi	sp,sp,-240
     2e4:	f586                	sd	ra,232(sp)
     2e6:	f1a2                	sd	s0,224(sp)
     2e8:	eda6                	sd	s1,216(sp)
     2ea:	e9ca                	sd	s2,208(sp)
     2ec:	e5ce                	sd	s3,200(sp)
     2ee:	fd56                	sd	s5,184(sp)
     2f0:	f95a                	sd	s6,176(sp)
     2f2:	1980                	addi	s0,sp,240
     2f4:	892a                	mv	s2,a0
     2f6:	8b2e                	mv	s6,a1
  int b1r, b2r;
  b1r = bind(port1);
     2f8:	03051993          	slli	s3,a0,0x30
     2fc:	0309d993          	srli	s3,s3,0x30
     300:	854e                	mv	a0,s3
     302:	00002097          	auipc	ra,0x2
     306:	f22080e7          	jalr	-222(ra) # 2224 <bind>
     30a:	84aa                	mv	s1,a0
  b2r = bind(port2);
     30c:	030b1a93          	slli	s5,s6,0x30
     310:	030ada93          	srli	s5,s5,0x30
     314:	8556                	mv	a0,s5
     316:	00002097          	auipc	ra,0x2
     31a:	f0e080e7          	jalr	-242(ra) # 2224 <bind>
  if (b1r != 0) {
     31e:	22049c63          	bnez	s1,556 <rx2+0x274>
     322:	e1d2                	sd	s4,192(sp)
     324:	8a2a                	mv	s4,a0
    printf("FAILED rx2: bind %d\n", port1);
    return 0;
  } else if (b2r != 0) {
     326:	490d                	li	s2,3
     328:	24051263          	bnez	a0,56c <rx2+0x28a>
     32c:	f55e                	sd	s7,168(sp)
     32e:	f162                	sd	s8,160(sp)
     330:	ed66                	sd	s9,152(sp)
     332:	e96a                	sd	s10,144(sp)
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     334:	0a000bb7          	lui	s7,0xa000
     338:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     33c:	00002c17          	auipc	s8,0x2
     340:	5bcc0c13          	addi	s8,s8,1468 # 28f8 <malloc+0x334>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     344:	00002c97          	auipc	s9,0x2
     348:	5dcc8c93          	addi	s9,s9,1500 # 2920 <malloc+0x35c>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     34c:	00002b17          	auipc	s6,0x2
     350:	604b0b13          	addi	s6,s6,1540 # 2950 <malloc+0x38c>
    int cc = recv(port1, &src, &sport, ibuf, sizeof(ibuf) - 1);
     354:	07f00713          	li	a4,127
     358:	f2040693          	addi	a3,s0,-224
     35c:	f1a40613          	addi	a2,s0,-230
     360:	f1c40593          	addi	a1,s0,-228
     364:	854e                	mv	a0,s3
     366:	00002097          	auipc	ra,0x2
     36a:	ed6080e7          	jalr	-298(ra) # 223c <recv>
     36e:	84aa                	mv	s1,a0
    if (cc < 0) {
     370:	20054963          	bltz	a0,582 <rx2+0x2a0>
    ibuf[cc] = '\0';
     374:	fa050793          	addi	a5,a0,-96
     378:	97a2                	add	a5,a5,s0
     37a:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     37e:	f1c42583          	lw	a1,-228(s0)
     382:	21759f63          	bne	a1,s7,5a0 <rx2+0x2be>
    if (cc < strlen("one 1")) {
     386:	8562                	mv	a0,s8
     388:	00002097          	auipc	ra,0x2
     38c:	bd8080e7          	jalr	-1064(ra) # 1f60 <strlen>
     390:	0005079b          	sext.w	a5,a0
     394:	00048d1b          	sext.w	s10,s1
     398:	20fd6d63          	bltu	s10,a5,5b2 <rx2+0x2d0>
    if (cc > strlen("one xxxxxx")) {
     39c:	8566                	mv	a0,s9
     39e:	00002097          	auipc	ra,0x2
     3a2:	bc2080e7          	jalr	-1086(ra) # 1f60 <strlen>
     3a6:	2501                	sext.w	a0,a0
     3a8:	21a56f63          	bltu	a0,s10,5c6 <rx2+0x2e4>
    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     3ac:	855a                	mv	a0,s6
     3ae:	00002097          	auipc	ra,0x2
     3b2:	bb2080e7          	jalr	-1102(ra) # 1f60 <strlen>
     3b6:	0005061b          	sext.w	a2,a0
     3ba:	85da                	mv	a1,s6
     3bc:	f2040513          	addi	a0,s0,-224
     3c0:	00002097          	auipc	ra,0x2
     3c4:	d6a080e7          	jalr	-662(ra) # 212a <memcmp>
     3c8:	84aa                	mv	s1,a0
     3ca:	20051863          	bnez	a0,5da <rx2+0x2f8>
  for (int i = 0; i < 3; i++) {
     3ce:	397d                	addiw	s2,s2,-1
     3d0:	f80912e3          	bnez	s2,354 <rx2+0x72>
     3d4:	4a0d                	li	s4,3
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     3d6:	0a000bb7          	lui	s7,0xa000
     3da:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     3de:	00002c17          	auipc	s8,0x2
     3e2:	51ac0c13          	addi	s8,s8,1306 # 28f8 <malloc+0x334>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     3e6:	00002c97          	auipc	s9,0x2
     3ea:	53ac8c93          	addi	s9,s9,1338 # 2920 <malloc+0x35c>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "two ", strlen("two ")) != 0) {
     3ee:	00002b17          	auipc	s6,0x2
     3f2:	59ab0b13          	addi	s6,s6,1434 # 2988 <malloc+0x3c4>
    int cc = recv(port2, &src, &sport, ibuf, sizeof(ibuf) - 1);
     3f6:	07f00713          	li	a4,127
     3fa:	f2040693          	addi	a3,s0,-224
     3fe:	f1a40613          	addi	a2,s0,-230
     402:	f1c40593          	addi	a1,s0,-228
     406:	8556                	mv	a0,s5
     408:	00002097          	auipc	ra,0x2
     40c:	e34080e7          	jalr	-460(ra) # 223c <recv>
     410:	892a                	mv	s2,a0
    if (cc < 0) {
     412:	1c054d63          	bltz	a0,5ec <rx2+0x30a>
    ibuf[cc] = '\0';
     416:	fa050793          	addi	a5,a0,-96
     41a:	97a2                	add	a5,a5,s0
     41c:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     420:	f1c42583          	lw	a1,-228(s0)
     424:	1f759263          	bne	a1,s7,608 <rx2+0x326>
    if (cc < strlen("one 1")) {
     428:	8562                	mv	a0,s8
     42a:	00002097          	auipc	ra,0x2
     42e:	b36080e7          	jalr	-1226(ra) # 1f60 <strlen>
     432:	2501                	sext.w	a0,a0
     434:	00090d1b          	sext.w	s10,s2
     438:	1ead6663          	bltu	s10,a0,624 <rx2+0x342>
    if (cc > strlen("one xxxxxx")) {
     43c:	8566                	mv	a0,s9
     43e:	00002097          	auipc	ra,0x2
     442:	b22080e7          	jalr	-1246(ra) # 1f60 <strlen>
     446:	2501                	sext.w	a0,a0
     448:	1fa56d63          	bltu	a0,s10,642 <rx2+0x360>
    if (memcmp(ibuf, "two ", strlen("two ")) != 0) {
     44c:	855a                	mv	a0,s6
     44e:	00002097          	auipc	ra,0x2
     452:	b12080e7          	jalr	-1262(ra) # 1f60 <strlen>
     456:	0005061b          	sext.w	a2,a0
     45a:	85da                	mv	a1,s6
     45c:	f2040513          	addi	a0,s0,-224
     460:	00002097          	auipc	ra,0x2
     464:	cca080e7          	jalr	-822(ra) # 212a <memcmp>
     468:	892a                	mv	s2,a0
     46a:	1e051b63          	bnez	a0,660 <rx2+0x37e>
  for (int i = 0; i < 3; i++) {
     46e:	3a7d                	addiw	s4,s4,-1
     470:	f80a13e3          	bnez	s4,3f6 <rx2+0x114>
     474:	4a0d                	li	s4,3
      printf("FAILED rx2: recv() failed\n");
      return 0;
    }
    ibuf[cc] = '\0';

    if (src != 0x0A000202) {  // 10.0.2.2
     476:	0a000bb7          	lui	s7,0xa000
     47a:	202b8b93          	addi	s7,s7,514 # a000202 <base+0x9ffbff2>
      printf("FAILED rx2: wrong ip src %x\n", src);
      return 0;
    }

    if (cc < strlen("one 1")) {
     47e:	00002c17          	auipc	s8,0x2
     482:	47ac0c13          	addi	s8,s8,1146 # 28f8 <malloc+0x334>
      printf("FAILED rx2: len %d too short\n", cc);
      return 0;
    }

    if (cc > strlen("one xxxxxx")) {
     486:	00002c97          	auipc	s9,0x2
     48a:	49ac8c93          	addi	s9,s9,1178 # 2920 <malloc+0x35c>
      printf("FAILED rx2: len %d too long\n", cc);
      return 0;
    }

    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     48e:	00002b17          	auipc	s6,0x2
     492:	4c2b0b13          	addi	s6,s6,1218 # 2950 <malloc+0x38c>
    int cc = recv(port1, &src, &sport, ibuf, sizeof(ibuf) - 1);
     496:	07f00713          	li	a4,127
     49a:	f2040693          	addi	a3,s0,-224
     49e:	f1a40613          	addi	a2,s0,-230
     4a2:	f1c40593          	addi	a1,s0,-228
     4a6:	854e                	mv	a0,s3
     4a8:	00002097          	auipc	ra,0x2
     4ac:	d94080e7          	jalr	-620(ra) # 223c <recv>
     4b0:	84aa                	mv	s1,a0
    if (cc < 0) {
     4b2:	1c054563          	bltz	a0,67c <rx2+0x39a>
    ibuf[cc] = '\0';
     4b6:	fa050793          	addi	a5,a0,-96
     4ba:	97a2                	add	a5,a5,s0
     4bc:	f8078023          	sb	zero,-128(a5)
    if (src != 0x0A000202) {  // 10.0.2.2
     4c0:	f1c42583          	lw	a1,-228(s0)
     4c4:	1d759b63          	bne	a1,s7,69a <rx2+0x3b8>
    if (cc < strlen("one 1")) {
     4c8:	8562                	mv	a0,s8
     4ca:	00002097          	auipc	ra,0x2
     4ce:	a96080e7          	jalr	-1386(ra) # 1f60 <strlen>
     4d2:	2501                	sext.w	a0,a0
     4d4:	00048d1b          	sext.w	s10,s1
     4d8:	1cad6a63          	bltu	s10,a0,6ac <rx2+0x3ca>
    if (cc > strlen("one xxxxxx")) {
     4dc:	8566                	mv	a0,s9
     4de:	00002097          	auipc	ra,0x2
     4e2:	a82080e7          	jalr	-1406(ra) # 1f60 <strlen>
     4e6:	2501                	sext.w	a0,a0
     4e8:	1da56c63          	bltu	a0,s10,6c0 <rx2+0x3de>
    if (memcmp(ibuf, "one ", strlen("one ")) != 0) {
     4ec:	855a                	mv	a0,s6
     4ee:	00002097          	auipc	ra,0x2
     4f2:	a72080e7          	jalr	-1422(ra) # 1f60 <strlen>
     4f6:	0005061b          	sext.w	a2,a0
     4fa:	85da                	mv	a1,s6
     4fc:	f2040513          	addi	a0,s0,-224
     500:	00002097          	auipc	ra,0x2
     504:	c2a080e7          	jalr	-982(ra) # 212a <memcmp>
     508:	1c051663          	bnez	a0,6d4 <rx2+0x3f2>
  for (int i = 0; i < 3; i++) {
     50c:	3a7d                	addiw	s4,s4,-1
     50e:	f80a14e3          	bnez	s4,496 <rx2+0x1b4>
      printf("FAILED rx2: packet doesn't start with one\n");
      return 0;
    }
  }

  unbind(port1);
     512:	854e                	mv	a0,s3
     514:	00002097          	auipc	ra,0x2
     518:	d18080e7          	jalr	-744(ra) # 222c <unbind>
  unbind(port2);
     51c:	8556                	mv	a0,s5
     51e:	00002097          	auipc	ra,0x2
     522:	d0e080e7          	jalr	-754(ra) # 222c <unbind>
  printf("rx2: OK\n");
     526:	00002517          	auipc	a0,0x2
     52a:	49a50513          	addi	a0,a0,1178 # 29c0 <malloc+0x3fc>
     52e:	00002097          	auipc	ra,0x2
     532:	fde080e7          	jalr	-34(ra) # 250c <printf>

  return 1;
     536:	4485                	li	s1,1
     538:	6a0e                	ld	s4,192(sp)
     53a:	7baa                	ld	s7,168(sp)
     53c:	7c0a                	ld	s8,160(sp)
     53e:	6cea                	ld	s9,152(sp)
     540:	6d4a                	ld	s10,144(sp)
}
     542:	8526                	mv	a0,s1
     544:	70ae                	ld	ra,232(sp)
     546:	740e                	ld	s0,224(sp)
     548:	64ee                	ld	s1,216(sp)
     54a:	694e                	ld	s2,208(sp)
     54c:	69ae                	ld	s3,200(sp)
     54e:	7aea                	ld	s5,184(sp)
     550:	7b4a                	ld	s6,176(sp)
     552:	616d                	addi	sp,sp,240
     554:	8082                	ret
    printf("FAILED rx2: bind %d\n", port1);
     556:	85ca                	mv	a1,s2
     558:	00002517          	auipc	a0,0x2
     55c:	34850513          	addi	a0,a0,840 # 28a0 <malloc+0x2dc>
     560:	00002097          	auipc	ra,0x2
     564:	fac080e7          	jalr	-84(ra) # 250c <printf>
    return 0;
     568:	4481                	li	s1,0
     56a:	bfe1                	j	542 <rx2+0x260>
    printf("FAILED rx2: bind %d\n", port2);
     56c:	85da                	mv	a1,s6
     56e:	00002517          	auipc	a0,0x2
     572:	33250513          	addi	a0,a0,818 # 28a0 <malloc+0x2dc>
     576:	00002097          	auipc	ra,0x2
     57a:	f96080e7          	jalr	-106(ra) # 250c <printf>
    return 0;
     57e:	6a0e                	ld	s4,192(sp)
     580:	b7c9                	j	542 <rx2+0x260>
      printf("FAILED rx2: recv() failed\n");
     582:	00002517          	auipc	a0,0x2
     586:	33650513          	addi	a0,a0,822 # 28b8 <malloc+0x2f4>
     58a:	00002097          	auipc	ra,0x2
     58e:	f82080e7          	jalr	-126(ra) # 250c <printf>
      return 0;
     592:	84d2                	mv	s1,s4
     594:	6a0e                	ld	s4,192(sp)
     596:	7baa                	ld	s7,168(sp)
     598:	7c0a                	ld	s8,160(sp)
     59a:	6cea                	ld	s9,152(sp)
     59c:	6d4a                	ld	s10,144(sp)
     59e:	b755                	j	542 <rx2+0x260>
      printf("FAILED rx2: wrong ip src %x\n", src);
     5a0:	00002517          	auipc	a0,0x2
     5a4:	33850513          	addi	a0,a0,824 # 28d8 <malloc+0x314>
     5a8:	00002097          	auipc	ra,0x2
     5ac:	f64080e7          	jalr	-156(ra) # 250c <printf>
      return 0;
     5b0:	b7cd                	j	592 <rx2+0x2b0>
      printf("FAILED rx2: len %d too short\n", cc);
     5b2:	85a6                	mv	a1,s1
     5b4:	00002517          	auipc	a0,0x2
     5b8:	34c50513          	addi	a0,a0,844 # 2900 <malloc+0x33c>
     5bc:	00002097          	auipc	ra,0x2
     5c0:	f50080e7          	jalr	-176(ra) # 250c <printf>
      return 0;
     5c4:	b7f9                	j	592 <rx2+0x2b0>
      printf("FAILED rx2: len %d too long\n", cc);
     5c6:	85a6                	mv	a1,s1
     5c8:	00002517          	auipc	a0,0x2
     5cc:	36850513          	addi	a0,a0,872 # 2930 <malloc+0x36c>
     5d0:	00002097          	auipc	ra,0x2
     5d4:	f3c080e7          	jalr	-196(ra) # 250c <printf>
      return 0;
     5d8:	bf6d                	j	592 <rx2+0x2b0>
      printf("FAILED rx2: packet doesn't start with one\n");
     5da:	00002517          	auipc	a0,0x2
     5de:	37e50513          	addi	a0,a0,894 # 2958 <malloc+0x394>
     5e2:	00002097          	auipc	ra,0x2
     5e6:	f2a080e7          	jalr	-214(ra) # 250c <printf>
      return 0;
     5ea:	b765                	j	592 <rx2+0x2b0>
      printf("FAILED rx2: recv() failed\n");
     5ec:	00002517          	auipc	a0,0x2
     5f0:	2cc50513          	addi	a0,a0,716 # 28b8 <malloc+0x2f4>
     5f4:	00002097          	auipc	ra,0x2
     5f8:	f18080e7          	jalr	-232(ra) # 250c <printf>
      return 0;
     5fc:	6a0e                	ld	s4,192(sp)
     5fe:	7baa                	ld	s7,168(sp)
     600:	7c0a                	ld	s8,160(sp)
     602:	6cea                	ld	s9,152(sp)
     604:	6d4a                	ld	s10,144(sp)
     606:	bf35                	j	542 <rx2+0x260>
      printf("FAILED rx2: wrong ip src %x\n", src);
     608:	00002517          	auipc	a0,0x2
     60c:	2d050513          	addi	a0,a0,720 # 28d8 <malloc+0x314>
     610:	00002097          	auipc	ra,0x2
     614:	efc080e7          	jalr	-260(ra) # 250c <printf>
      return 0;
     618:	6a0e                	ld	s4,192(sp)
     61a:	7baa                	ld	s7,168(sp)
     61c:	7c0a                	ld	s8,160(sp)
     61e:	6cea                	ld	s9,152(sp)
     620:	6d4a                	ld	s10,144(sp)
     622:	b705                	j	542 <rx2+0x260>
      printf("FAILED rx2: len %d too short\n", cc);
     624:	85ca                	mv	a1,s2
     626:	00002517          	auipc	a0,0x2
     62a:	2da50513          	addi	a0,a0,730 # 2900 <malloc+0x33c>
     62e:	00002097          	auipc	ra,0x2
     632:	ede080e7          	jalr	-290(ra) # 250c <printf>
      return 0;
     636:	6a0e                	ld	s4,192(sp)
     638:	7baa                	ld	s7,168(sp)
     63a:	7c0a                	ld	s8,160(sp)
     63c:	6cea                	ld	s9,152(sp)
     63e:	6d4a                	ld	s10,144(sp)
     640:	b709                	j	542 <rx2+0x260>
      printf("FAILED rx2: len %d too long\n", cc);
     642:	85ca                	mv	a1,s2
     644:	00002517          	auipc	a0,0x2
     648:	2ec50513          	addi	a0,a0,748 # 2930 <malloc+0x36c>
     64c:	00002097          	auipc	ra,0x2
     650:	ec0080e7          	jalr	-320(ra) # 250c <printf>
      return 0;
     654:	6a0e                	ld	s4,192(sp)
     656:	7baa                	ld	s7,168(sp)
     658:	7c0a                	ld	s8,160(sp)
     65a:	6cea                	ld	s9,152(sp)
     65c:	6d4a                	ld	s10,144(sp)
     65e:	b5d5                	j	542 <rx2+0x260>
      printf("FAILED rx2: packet doesn't start with two\n");
     660:	00002517          	auipc	a0,0x2
     664:	33050513          	addi	a0,a0,816 # 2990 <malloc+0x3cc>
     668:	00002097          	auipc	ra,0x2
     66c:	ea4080e7          	jalr	-348(ra) # 250c <printf>
      return 0;
     670:	6a0e                	ld	s4,192(sp)
     672:	7baa                	ld	s7,168(sp)
     674:	7c0a                	ld	s8,160(sp)
     676:	6cea                	ld	s9,152(sp)
     678:	6d4a                	ld	s10,144(sp)
     67a:	b5e1                	j	542 <rx2+0x260>
      printf("FAILED rx2: recv() failed\n");
     67c:	00002517          	auipc	a0,0x2
     680:	23c50513          	addi	a0,a0,572 # 28b8 <malloc+0x2f4>
     684:	00002097          	auipc	ra,0x2
     688:	e88080e7          	jalr	-376(ra) # 250c <printf>
      return 0;
     68c:	84ca                	mv	s1,s2
     68e:	6a0e                	ld	s4,192(sp)
     690:	7baa                	ld	s7,168(sp)
     692:	7c0a                	ld	s8,160(sp)
     694:	6cea                	ld	s9,152(sp)
     696:	6d4a                	ld	s10,144(sp)
     698:	b56d                	j	542 <rx2+0x260>
      printf("FAILED rx2: wrong ip src %x\n", src);
     69a:	00002517          	auipc	a0,0x2
     69e:	23e50513          	addi	a0,a0,574 # 28d8 <malloc+0x314>
     6a2:	00002097          	auipc	ra,0x2
     6a6:	e6a080e7          	jalr	-406(ra) # 250c <printf>
      return 0;
     6aa:	b7cd                	j	68c <rx2+0x3aa>
      printf("FAILED rx2: len %d too short\n", cc);
     6ac:	85a6                	mv	a1,s1
     6ae:	00002517          	auipc	a0,0x2
     6b2:	25250513          	addi	a0,a0,594 # 2900 <malloc+0x33c>
     6b6:	00002097          	auipc	ra,0x2
     6ba:	e56080e7          	jalr	-426(ra) # 250c <printf>
      return 0;
     6be:	b7f9                	j	68c <rx2+0x3aa>
      printf("FAILED rx2: len %d too long\n", cc);
     6c0:	85a6                	mv	a1,s1
     6c2:	00002517          	auipc	a0,0x2
     6c6:	26e50513          	addi	a0,a0,622 # 2930 <malloc+0x36c>
     6ca:	00002097          	auipc	ra,0x2
     6ce:	e42080e7          	jalr	-446(ra) # 250c <printf>
      return 0;
     6d2:	bf6d                	j	68c <rx2+0x3aa>
      printf("FAILED rx2: packet doesn't start with one\n");
     6d4:	00002517          	auipc	a0,0x2
     6d8:	28450513          	addi	a0,a0,644 # 2958 <malloc+0x394>
     6dc:	00002097          	auipc	ra,0x2
     6e0:	e30080e7          	jalr	-464(ra) # 250c <printf>
      return 0;
     6e4:	b765                	j	68c <rx2+0x3aa>

00000000000006e6 <tx>:

//
// send some UDP packets to nettest.py tx.
//
int tx() {
     6e6:	715d                	addi	sp,sp,-80
     6e8:	e486                	sd	ra,72(sp)
     6ea:	e0a2                	sd	s0,64(sp)
     6ec:	fc26                	sd	s1,56(sp)
     6ee:	f84a                	sd	s2,48(sp)
     6f0:	f44e                	sd	s3,40(sp)
     6f2:	f052                	sd	s4,32(sp)
     6f4:	ec56                	sd	s5,24(sp)
     6f6:	e85a                	sd	s6,16(sp)
     6f8:	0880                	addi	s0,sp,80
     6fa:	03000493          	li	s1,48
  for (int ii = 0; ii < 5; ii++) {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 't';
     6fe:	07400a93          	li	s5,116
    buf[1] = ' ';
     702:	02000a13          	li	s4,32
    buf[2] = '0' + ii;
    if (send(FWDPORT1, dst, dport, buf, 3) < 0) {
     706:	6999                	lui	s3,0x6
     708:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     70c:	0a000937          	lui	s2,0xa000
     710:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for (int ii = 0; ii < 5; ii++) {
     714:	03500b13          	li	s6,53
    buf[0] = 't';
     718:	fb540c23          	sb	s5,-72(s0)
    buf[1] = ' ';
     71c:	fb440ca3          	sb	s4,-71(s0)
    buf[2] = '0' + ii;
     720:	fa940d23          	sb	s1,-70(s0)
    if (send(FWDPORT1, dst, dport, buf, 3) < 0) {
     724:	470d                	li	a4,3
     726:	fb840693          	addi	a3,s0,-72
     72a:	864e                	mv	a2,s3
     72c:	85ca                	mv	a1,s2
     72e:	7d000513          	li	a0,2000
     732:	00002097          	auipc	ra,0x2
     736:	b02080e7          	jalr	-1278(ra) # 2234 <send>
     73a:	02054763          	bltz	a0,768 <tx+0x82>
      printf("send() failed\n");
      return 0;
    }
    sleep(10);
     73e:	4529                	li	a0,10
     740:	00002097          	auipc	ra,0x2
     744:	ad4080e7          	jalr	-1324(ra) # 2214 <sleep>
  for (int ii = 0; ii < 5; ii++) {
     748:	2485                	addiw	s1,s1,1
     74a:	0ff4f493          	zext.b	s1,s1
     74e:	fd6495e3          	bne	s1,s6,718 <tx+0x32>
  }

  // can't actually tell if the packets arrived.
  return 1;
     752:	4505                	li	a0,1
}
     754:	60a6                	ld	ra,72(sp)
     756:	6406                	ld	s0,64(sp)
     758:	74e2                	ld	s1,56(sp)
     75a:	7942                	ld	s2,48(sp)
     75c:	79a2                	ld	s3,40(sp)
     75e:	7a02                	ld	s4,32(sp)
     760:	6ae2                	ld	s5,24(sp)
     762:	6b42                	ld	s6,16(sp)
     764:	6161                	addi	sp,sp,80
     766:	8082                	ret
      printf("send() failed\n");
     768:	00002517          	auipc	a0,0x2
     76c:	26850513          	addi	a0,a0,616 # 29d0 <malloc+0x40c>
     770:	00002097          	auipc	ra,0x2
     774:	d9c080e7          	jalr	-612(ra) # 250c <printf>
      return 0;
     778:	4501                	li	a0,0
     77a:	bfe9                	j	754 <tx+0x6e>

000000000000077c <ping0>:
//
// send just one UDP packets to nettest.py ping,
// expect a reply.
// nettest.py ping must be started first.
//
int ping0() {
     77c:	7171                	addi	sp,sp,-176
     77e:	f506                	sd	ra,168(sp)
     780:	f122                	sd	s0,160(sp)
     782:	e94a                	sd	s2,144(sp)
     784:	1900                	addi	s0,sp,176
  printf("ping0: starting\n");
     786:	00002517          	auipc	a0,0x2
     78a:	25a50513          	addi	a0,a0,602 # 29e0 <malloc+0x41c>
     78e:	00002097          	auipc	ra,0x2
     792:	d7e080e7          	jalr	-642(ra) # 250c <printf>

  bind(2004);
     796:	7d400513          	li	a0,2004
     79a:	00002097          	auipc	ra,0x2
     79e:	a8a080e7          	jalr	-1398(ra) # 2224 <bind>

  uint32 dst = 0x0A000202;  // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  memcpy(buf, "ping0", sizeof(buf));
     7a2:	4615                	li	a2,5
     7a4:	00002597          	auipc	a1,0x2
     7a8:	25458593          	addi	a1,a1,596 # 29f8 <malloc+0x434>
     7ac:	fd840513          	addi	a0,s0,-40
     7b0:	00002097          	auipc	ra,0x2
     7b4:	9b4080e7          	jalr	-1612(ra) # 2164 <memcpy>
  if (send(2004, dst, dport, buf, sizeof(buf)) < 0) {
     7b8:	4715                	li	a4,5
     7ba:	fd840693          	addi	a3,s0,-40
     7be:	6619                	lui	a2,0x6
     7c0:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     7c4:	0a0005b7          	lui	a1,0xa000
     7c8:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     7cc:	7d400513          	li	a0,2004
     7d0:	00002097          	auipc	ra,0x2
     7d4:	a64080e7          	jalr	-1436(ra) # 2234 <send>
     7d8:	06054e63          	bltz	a0,854 <ping0+0xd8>
     7dc:	ed26                	sd	s1,152(sp)
    printf("ping0: send() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
     7de:	f4042a23          	sw	zero,-172(s0)
  uint16 sport = 0;
     7e2:	f4041923          	sh	zero,-174(s0)
  memset(ibuf, 0, sizeof(ibuf));
     7e6:	08000613          	li	a2,128
     7ea:	4581                	li	a1,0
     7ec:	f5840513          	addi	a0,s0,-168
     7f0:	00001097          	auipc	ra,0x1
     7f4:	79a080e7          	jalr	1946(ra) # 1f8a <memset>
  int cc = recv(2004, &src, &sport, ibuf, sizeof(ibuf) - 1);
     7f8:	07f00713          	li	a4,127
     7fc:	f5840693          	addi	a3,s0,-168
     800:	f5240613          	addi	a2,s0,-174
     804:	f5440593          	addi	a1,s0,-172
     808:	7d400513          	li	a0,2004
     80c:	00002097          	auipc	ra,0x2
     810:	a30080e7          	jalr	-1488(ra) # 223c <recv>
     814:	84aa                	mv	s1,a0
  if (cc < 0) {
     816:	04054e63          	bltz	a0,872 <ping0+0xf6>
    printf("ping0: recv() failed\n");
    return 0;
  }

  if (src != 0x0A000202) {  // 10.0.2.2
     81a:	f5442583          	lw	a1,-172(s0)
     81e:	0a0007b7          	lui	a5,0xa000
     822:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffbff2>
     826:	06f59163          	bne	a1,a5,888 <ping0+0x10c>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
    return 0;
  }

  if (sport != NET_TESTS_PORT) {
     82a:	f5245583          	lhu	a1,-174(s0)
     82e:	0005871b          	sext.w	a4,a1
     832:	6799                	lui	a5,0x6
     834:	5f378793          	addi	a5,a5,1523 # 65f3 <base+0x23e3>
     838:	06f70463          	beq	a4,a5,8a0 <ping0+0x124>
    printf("ping0: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     83c:	863e                	mv	a2,a5
     83e:	00002517          	auipc	a0,0x2
     842:	21a50513          	addi	a0,a0,538 # 2a58 <malloc+0x494>
     846:	00002097          	auipc	ra,0x2
     84a:	cc6080e7          	jalr	-826(ra) # 250c <printf>
    return 0;
     84e:	4901                	li	s2,0
     850:	64ea                	ld	s1,152(sp)
     852:	a811                	j	866 <ping0+0xea>
    printf("ping0: send() failed\n");
     854:	00002517          	auipc	a0,0x2
     858:	1ac50513          	addi	a0,a0,428 # 2a00 <malloc+0x43c>
     85c:	00002097          	auipc	ra,0x2
     860:	cb0080e7          	jalr	-848(ra) # 250c <printf>
    return 0;
     864:	4901                	li	s2,0

  unbind(2004);
  printf("ping0: OK\n");

  return 1;
}
     866:	854a                	mv	a0,s2
     868:	70aa                	ld	ra,168(sp)
     86a:	740a                	ld	s0,160(sp)
     86c:	694a                	ld	s2,144(sp)
     86e:	614d                	addi	sp,sp,176
     870:	8082                	ret
    printf("ping0: recv() failed\n");
     872:	00002517          	auipc	a0,0x2
     876:	1a650513          	addi	a0,a0,422 # 2a18 <malloc+0x454>
     87a:	00002097          	auipc	ra,0x2
     87e:	c92080e7          	jalr	-878(ra) # 250c <printf>
    return 0;
     882:	4901                	li	s2,0
     884:	64ea                	ld	s1,152(sp)
     886:	b7c5                	j	866 <ping0+0xea>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     888:	863e                	mv	a2,a5
     88a:	00002517          	auipc	a0,0x2
     88e:	1a650513          	addi	a0,a0,422 # 2a30 <malloc+0x46c>
     892:	00002097          	auipc	ra,0x2
     896:	c7a080e7          	jalr	-902(ra) # 250c <printf>
    return 0;
     89a:	4901                	li	s2,0
     89c:	64ea                	ld	s1,152(sp)
     89e:	b7e1                	j	866 <ping0+0xea>
  if (memcmp(buf, ibuf, sizeof(buf)) != 0) {
     8a0:	4615                	li	a2,5
     8a2:	f5840593          	addi	a1,s0,-168
     8a6:	fd840513          	addi	a0,s0,-40
     8aa:	00002097          	auipc	ra,0x2
     8ae:	880080e7          	jalr	-1920(ra) # 212a <memcmp>
     8b2:	892a                	mv	s2,a0
     8b4:	e105                	bnez	a0,8d4 <ping0+0x158>
  if (cc != sizeof(buf)) {
     8b6:	4795                	li	a5,5
     8b8:	02f48963          	beq	s1,a5,8ea <ping0+0x16e>
    printf("ping0: wrong length %d, expecting %ld\n", cc, sizeof(buf));
     8bc:	4615                	li	a2,5
     8be:	85a6                	mv	a1,s1
     8c0:	00002517          	auipc	a0,0x2
     8c4:	1d850513          	addi	a0,a0,472 # 2a98 <malloc+0x4d4>
     8c8:	00002097          	auipc	ra,0x2
     8cc:	c44080e7          	jalr	-956(ra) # 250c <printf>
    return 0;
     8d0:	64ea                	ld	s1,152(sp)
     8d2:	bf51                	j	866 <ping0+0xea>
    printf("ping0: wrong content\n");
     8d4:	00002517          	auipc	a0,0x2
     8d8:	1ac50513          	addi	a0,a0,428 # 2a80 <malloc+0x4bc>
     8dc:	00002097          	auipc	ra,0x2
     8e0:	c30080e7          	jalr	-976(ra) # 250c <printf>
    return 0;
     8e4:	4901                	li	s2,0
     8e6:	64ea                	ld	s1,152(sp)
     8e8:	bfbd                	j	866 <ping0+0xea>
  unbind(2004);
     8ea:	7d400513          	li	a0,2004
     8ee:	00002097          	auipc	ra,0x2
     8f2:	93e080e7          	jalr	-1730(ra) # 222c <unbind>
  printf("ping0: OK\n");
     8f6:	00002517          	auipc	a0,0x2
     8fa:	1ca50513          	addi	a0,a0,458 # 2ac0 <malloc+0x4fc>
     8fe:	00002097          	auipc	ra,0x2
     902:	c0e080e7          	jalr	-1010(ra) # 250c <printf>
  return 1;
     906:	4905                	li	s2,1
     908:	64ea                	ld	s1,152(sp)
     90a:	bfb1                	j	866 <ping0+0xea>

000000000000090c <ping1>:
//
// send many UDP packets to nettest.py ping,
// expect a reply to each.
// nettest.py ping must be started first.
//
int ping1() {
     90c:	7155                	addi	sp,sp,-208
     90e:	e586                	sd	ra,200(sp)
     910:	e1a2                	sd	s0,192(sp)
     912:	fd26                	sd	s1,184(sp)
     914:	f94a                	sd	s2,176(sp)
     916:	f54e                	sd	s3,168(sp)
     918:	f152                	sd	s4,160(sp)
     91a:	ed56                	sd	s5,152(sp)
     91c:	e95a                	sd	s6,144(sp)
     91e:	0980                	addi	s0,sp,208
  printf("ping1: starting\n");
     920:	00002517          	auipc	a0,0x2
     924:	1b050513          	addi	a0,a0,432 # 2ad0 <malloc+0x50c>
     928:	00002097          	auipc	ra,0x2
     92c:	be4080e7          	jalr	-1052(ra) # 250c <printf>

  bind(2005);
     930:	7d500513          	li	a0,2005
     934:	00002097          	auipc	ra,0x2
     938:	8f0080e7          	jalr	-1808(ra) # 2224 <bind>
     93c:	03000493          	li	s1,48

  for (int ii = 0; ii < 20; ii++) {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 'p';
     940:	07000b13          	li	s6,112
    buf[1] = ' ';
     944:	02000a93          	li	s5,32
    buf[2] = '0' + ii;
    if (send(2005, dst, dport, buf, 3) < 0) {
     948:	6a19                	lui	s4,0x6
     94a:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
     94e:	0a0009b7          	lui	s3,0xa000
     952:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
    buf[0] = 'p';
     956:	f3640c23          	sb	s6,-200(s0)
    buf[1] = ' ';
     95a:	f3540ca3          	sb	s5,-199(s0)
    buf[2] = '0' + ii;
     95e:	f2940d23          	sb	s1,-198(s0)
    if (send(2005, dst, dport, buf, 3) < 0) {
     962:	470d                	li	a4,3
     964:	f3840693          	addi	a3,s0,-200
     968:	8652                	mv	a2,s4
     96a:	85ce                	mv	a1,s3
     96c:	7d500513          	li	a0,2005
     970:	00002097          	auipc	ra,0x2
     974:	8c4080e7          	jalr	-1852(ra) # 2234 <send>
     978:	08054e63          	bltz	a0,a14 <ping1+0x108>
      printf("FAILED ping1: send() failed\n");
      return 0;
    }

    char ibuf[128];
    uint32 src = 0;
     97c:	f2042e23          	sw	zero,-196(s0)
    uint16 sport = 0;
     980:	f2041b23          	sh	zero,-202(s0)
    memset(ibuf, 0, sizeof(ibuf));
     984:	08000613          	li	a2,128
     988:	4581                	li	a1,0
     98a:	f4040513          	addi	a0,s0,-192
     98e:	00001097          	auipc	ra,0x1
     992:	5fc080e7          	jalr	1532(ra) # 1f8a <memset>
    int cc = recv(2005, &src, &sport, ibuf, sizeof(ibuf) - 1);
     996:	07f00713          	li	a4,127
     99a:	f4040693          	addi	a3,s0,-192
     99e:	f3640613          	addi	a2,s0,-202
     9a2:	f3c40593          	addi	a1,s0,-196
     9a6:	7d500513          	li	a0,2005
     9aa:	00002097          	auipc	ra,0x2
     9ae:	892080e7          	jalr	-1902(ra) # 223c <recv>
     9b2:	892a                	mv	s2,a0
    if (cc < 0) {
     9b4:	08054363          	bltz	a0,a3a <ping1+0x12e>
      printf("FAILED ping1: recv() failed\n");
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
     9b8:	f3c42583          	lw	a1,-196(s0)
     9bc:	09359863          	bne	a1,s3,a4c <ping1+0x140>
      printf("FAILED ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
      return 0;
    }

    if (sport != NET_TESTS_PORT) {
     9c0:	f3645583          	lhu	a1,-202(s0)
     9c4:	0005879b          	sext.w	a5,a1
     9c8:	09479f63          	bne	a5,s4,a66 <ping1+0x15a>
      printf("FAILED ping1: wrong sport %d, expecting %d\n", sport,
             NET_TESTS_PORT);
      return 0;
    }

    if (memcmp(buf, ibuf, 3) != 0) {
     9cc:	460d                	li	a2,3
     9ce:	f4040593          	addi	a1,s0,-192
     9d2:	f3840513          	addi	a0,s0,-200
     9d6:	00001097          	auipc	ra,0x1
     9da:	754080e7          	jalr	1876(ra) # 212a <memcmp>
     9de:	e145                	bnez	a0,a7e <ping1+0x172>
      printf("FAILED ping1: wrong content\n");
      return 0;
    }

    if (cc != 3) {
     9e0:	478d                	li	a5,3
     9e2:	0af91763          	bne	s2,a5,a90 <ping1+0x184>
  for (int ii = 0; ii < 20; ii++) {
     9e6:	2485                	addiw	s1,s1,1
     9e8:	0ff4f493          	zext.b	s1,s1
     9ec:	04400793          	li	a5,68
     9f0:	f6f493e3          	bne	s1,a5,956 <ping1+0x4a>
      printf("FAILED ping1: wrong length %d, expecting 3\n", cc);
      return 0;
    }
  }

  unbind(2005);
     9f4:	7d500513          	li	a0,2005
     9f8:	00002097          	auipc	ra,0x2
     9fc:	834080e7          	jalr	-1996(ra) # 222c <unbind>
  printf("ping1: OK\n");
     a00:	00002517          	auipc	a0,0x2
     a04:	1d850513          	addi	a0,a0,472 # 2bd8 <malloc+0x614>
     a08:	00002097          	auipc	ra,0x2
     a0c:	b04080e7          	jalr	-1276(ra) # 250c <printf>

  return 1;
     a10:	4505                	li	a0,1
     a12:	a811                	j	a26 <ping1+0x11a>
      printf("FAILED ping1: send() failed\n");
     a14:	00002517          	auipc	a0,0x2
     a18:	0d450513          	addi	a0,a0,212 # 2ae8 <malloc+0x524>
     a1c:	00002097          	auipc	ra,0x2
     a20:	af0080e7          	jalr	-1296(ra) # 250c <printf>
      return 0;
     a24:	4501                	li	a0,0
}
     a26:	60ae                	ld	ra,200(sp)
     a28:	640e                	ld	s0,192(sp)
     a2a:	74ea                	ld	s1,184(sp)
     a2c:	794a                	ld	s2,176(sp)
     a2e:	79aa                	ld	s3,168(sp)
     a30:	7a0a                	ld	s4,160(sp)
     a32:	6aea                	ld	s5,152(sp)
     a34:	6b4a                	ld	s6,144(sp)
     a36:	6169                	addi	sp,sp,208
     a38:	8082                	ret
      printf("FAILED ping1: recv() failed\n");
     a3a:	00002517          	auipc	a0,0x2
     a3e:	0ce50513          	addi	a0,a0,206 # 2b08 <malloc+0x544>
     a42:	00002097          	auipc	ra,0x2
     a46:	aca080e7          	jalr	-1334(ra) # 250c <printf>
      return 0;
     a4a:	bfe9                	j	a24 <ping1+0x118>
      printf("FAILED ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     a4c:	0a000637          	lui	a2,0xa000
     a50:	20260613          	addi	a2,a2,514 # a000202 <base+0x9ffbff2>
     a54:	00002517          	auipc	a0,0x2
     a58:	0d450513          	addi	a0,a0,212 # 2b28 <malloc+0x564>
     a5c:	00002097          	auipc	ra,0x2
     a60:	ab0080e7          	jalr	-1360(ra) # 250c <printf>
      return 0;
     a64:	b7c1                	j	a24 <ping1+0x118>
      printf("FAILED ping1: wrong sport %d, expecting %d\n", sport,
     a66:	6619                	lui	a2,0x6
     a68:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     a6c:	00002517          	auipc	a0,0x2
     a70:	0ec50513          	addi	a0,a0,236 # 2b58 <malloc+0x594>
     a74:	00002097          	auipc	ra,0x2
     a78:	a98080e7          	jalr	-1384(ra) # 250c <printf>
      return 0;
     a7c:	b765                	j	a24 <ping1+0x118>
      printf("FAILED ping1: wrong content\n");
     a7e:	00002517          	auipc	a0,0x2
     a82:	10a50513          	addi	a0,a0,266 # 2b88 <malloc+0x5c4>
     a86:	00002097          	auipc	ra,0x2
     a8a:	a86080e7          	jalr	-1402(ra) # 250c <printf>
      return 0;
     a8e:	bf59                	j	a24 <ping1+0x118>
      printf("FAILED ping1: wrong length %d, expecting 3\n", cc);
     a90:	85ca                	mv	a1,s2
     a92:	00002517          	auipc	a0,0x2
     a96:	11650513          	addi	a0,a0,278 # 2ba8 <malloc+0x5e4>
     a9a:	00002097          	auipc	ra,0x2
     a9e:	a72080e7          	jalr	-1422(ra) # 250c <printf>
      return 0;
     aa2:	b749                	j	a24 <ping1+0x118>

0000000000000aa4 <ping2>:
//
// send UDP packets from two different ports to nettest.py ping,
// expect a reply to each to appear on the correct port.
// nettest.py ping must be started first.
//
int ping2() {
     aa4:	7115                	addi	sp,sp,-224
     aa6:	ed86                	sd	ra,216(sp)
     aa8:	e9a2                	sd	s0,208(sp)
     aaa:	e5a6                	sd	s1,200(sp)
     aac:	e1ca                	sd	s2,192(sp)
     aae:	fd4e                	sd	s3,184(sp)
     ab0:	f952                	sd	s4,176(sp)
     ab2:	f556                	sd	s5,168(sp)
     ab4:	f15a                	sd	s6,160(sp)
     ab6:	ed5e                	sd	s7,152(sp)
     ab8:	1180                	addi	s0,sp,224
  printf("ping2: starting\n");
     aba:	00002517          	auipc	a0,0x2
     abe:	12e50513          	addi	a0,a0,302 # 2be8 <malloc+0x624>
     ac2:	00002097          	auipc	ra,0x2
     ac6:	a4a080e7          	jalr	-1462(ra) # 250c <printf>

  bind(2006);
     aca:	7d600513          	li	a0,2006
     ace:	00001097          	auipc	ra,0x1
     ad2:	756080e7          	jalr	1878(ra) # 2224 <bind>
  bind(2007);
     ad6:	7d700513          	li	a0,2007
     ada:	00001097          	auipc	ra,0x1
     ade:	74a080e7          	jalr	1866(ra) # 2224 <bind>
     ae2:	06100493          	li	s1,97
  for (int ii = 0; ii < 5; ii++) {
    for (int port = 2006; port <= 2007; port++) {
      uint32 dst = 0x0A000202;  // 10.0.2.2
      int dport = NET_TESTS_PORT;
      char buf[4];
      buf[0] = 'p';
     ae6:	07000b13          	li	s6,112
      buf[1] = ' ';
     aea:	02000a93          	li	s5,32
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';
     aee:	02100a13          	li	s4,33
      if (send(port, dst, dport, buf, 4) < 0) {
     af2:	6999                	lui	s3,0x6
     af4:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     af8:	0a000937          	lui	s2,0xa000
     afc:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for (int ii = 0; ii < 5; ii++) {
     b00:	06600b93          	li	s7,102
      buf[0] = 'p';
     b04:	f3640823          	sb	s6,-208(s0)
      buf[1] = ' ';
     b08:	f35408a3          	sb	s5,-207(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     b0c:	f2940923          	sb	s1,-206(s0)
      buf[3] = '!';
     b10:	f34409a3          	sb	s4,-205(s0)
      if (send(port, dst, dport, buf, 4) < 0) {
     b14:	4711                	li	a4,4
     b16:	f3040693          	addi	a3,s0,-208
     b1a:	864e                	mv	a2,s3
     b1c:	85ca                	mv	a1,s2
     b1e:	7d600513          	li	a0,2006
     b22:	00001097          	auipc	ra,0x1
     b26:	712080e7          	jalr	1810(ra) # 2234 <send>
     b2a:	14054163          	bltz	a0,c6c <ping2+0x1c8>
      buf[0] = 'p';
     b2e:	f3640823          	sb	s6,-208(s0)
      buf[1] = ' ';
     b32:	f35408a3          	sb	s5,-207(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     b36:	fe04879b          	addiw	a5,s1,-32
     b3a:	f2f40923          	sb	a5,-206(s0)
      buf[3] = '!';
     b3e:	f34409a3          	sb	s4,-205(s0)
      if (send(port, dst, dport, buf, 4) < 0) {
     b42:	4711                	li	a4,4
     b44:	f3040693          	addi	a3,s0,-208
     b48:	864e                	mv	a2,s3
     b4a:	85ca                	mv	a1,s2
     b4c:	7d700513          	li	a0,2007
     b50:	00001097          	auipc	ra,0x1
     b54:	6e4080e7          	jalr	1764(ra) # 2234 <send>
     b58:	10054a63          	bltz	a0,c6c <ping2+0x1c8>
  for (int ii = 0; ii < 5; ii++) {
     b5c:	2485                	addiw	s1,s1,1
     b5e:	0ff4f493          	zext.b	s1,s1
     b62:	fb7491e3          	bne	s1,s7,b04 <ping2+0x60>
        return 0;
      }
    }
  }

  for (int port = 2006; port <= 2007; port++) {
     b66:	7d600a13          	li	s4,2006
      if (cc < 0) {
        printf("ping2: recv() failed\n");
        return 0;
      }

      if (src != 0x0A000202) {  // 10.0.2.2
     b6a:	0a000937          	lui	s2,0xa000
     b6e:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
        printf("FAILED ping2: wrong ip src %x\n", src);
        return 0;
      }

      if (sport != NET_TESTS_PORT) {
     b72:	6999                	lui	s3,0x6
     b74:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
    for (int ii = 0; ii < 5; ii++) {
     b78:	82aa0793          	addi	a5,s4,-2006
     b7c:	04100493          	li	s1,65
     b80:	e399                	bnez	a5,b86 <ping2+0xe2>
     b82:	06100493          	li	s1,97
     b86:	0ff4f493          	zext.b	s1,s1
     b8a:	00548b93          	addi	s7,s1,5
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf) - 1);
     b8e:	030a1a93          	slli	s5,s4,0x30
     b92:	030ada93          	srli	s5,s5,0x30
        printf("FAILED ping2: wrong sport %d\n", sport);
        return 0;
      }

      if (cc != 4) {
     b96:	4b11                	li	s6,4
      uint32 src = 0;
     b98:	f2042623          	sw	zero,-212(s0)
      uint16 sport = 0;
     b9c:	f2041323          	sh	zero,-218(s0)
      memset(ibuf, 0, sizeof(ibuf));
     ba0:	08000613          	li	a2,128
     ba4:	4581                	li	a1,0
     ba6:	f3040513          	addi	a0,s0,-208
     baa:	00001097          	auipc	ra,0x1
     bae:	3e0080e7          	jalr	992(ra) # 1f8a <memset>
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf) - 1);
     bb2:	07f00713          	li	a4,127
     bb6:	f3040693          	addi	a3,s0,-208
     bba:	f2640613          	addi	a2,s0,-218
     bbe:	f2c40593          	addi	a1,s0,-212
     bc2:	8556                	mv	a0,s5
     bc4:	00001097          	auipc	ra,0x1
     bc8:	678080e7          	jalr	1656(ra) # 223c <recv>
      if (cc < 0) {
     bcc:	0a054a63          	bltz	a0,c80 <ping2+0x1dc>
      if (src != 0x0A000202) {  // 10.0.2.2
     bd0:	f2c42583          	lw	a1,-212(s0)
     bd4:	0d259063          	bne	a1,s2,c94 <ping2+0x1f0>
      if (sport != NET_TESTS_PORT) {
     bd8:	f2645583          	lhu	a1,-218(s0)
     bdc:	0005879b          	sext.w	a5,a1
     be0:	0d379363          	bne	a5,s3,ca6 <ping2+0x202>
      if (cc != 4) {
     be4:	0d651a63          	bne	a0,s6,cb8 <ping2+0x214>
      }

      // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

      char buf[4];
      buf[0] = 'p';
     be8:	07000793          	li	a5,112
     bec:	f2f40423          	sb	a5,-216(s0)
      buf[1] = ' ';
     bf0:	02000793          	li	a5,32
     bf4:	f2f404a3          	sb	a5,-215(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     bf8:	f2940523          	sb	s1,-214(s0)
      buf[3] = '!';
     bfc:	02100793          	li	a5,33
     c00:	f2f405a3          	sb	a5,-213(s0)

      if (memcmp(buf, ibuf, 3) != 0) {
     c04:	460d                	li	a2,3
     c06:	f3040593          	addi	a1,s0,-208
     c0a:	f2840513          	addi	a0,s0,-216
     c0e:	00001097          	auipc	ra,0x1
     c12:	51c080e7          	jalr	1308(ra) # 212a <memcmp>
     c16:	e95d                	bnez	a0,ccc <ping2+0x228>
    for (int ii = 0; ii < 5; ii++) {
     c18:	2485                	addiw	s1,s1,1
     c1a:	0ff4f493          	zext.b	s1,s1
     c1e:	f7749de3          	bne	s1,s7,b98 <ping2+0xf4>
  for (int port = 2006; port <= 2007; port++) {
     c22:	2a05                	addiw	s4,s4,1
     c24:	7d800793          	li	a5,2008
     c28:	f4fa18e3          	bne	s4,a5,b78 <ping2+0xd4>
        return 0;
      }
    }
  }

  unbind(2006);
     c2c:	7d600513          	li	a0,2006
     c30:	00001097          	auipc	ra,0x1
     c34:	5fc080e7          	jalr	1532(ra) # 222c <unbind>
  unbind(2007);
     c38:	7d700513          	li	a0,2007
     c3c:	00001097          	auipc	ra,0x1
     c40:	5f0080e7          	jalr	1520(ra) # 222c <unbind>
  printf("ping2: OK\n");
     c44:	00002517          	auipc	a0,0x2
     c48:	07450513          	addi	a0,a0,116 # 2cb8 <malloc+0x6f4>
     c4c:	00002097          	auipc	ra,0x2
     c50:	8c0080e7          	jalr	-1856(ra) # 250c <printf>

  return 1;
     c54:	4505                	li	a0,1
}
     c56:	60ee                	ld	ra,216(sp)
     c58:	644e                	ld	s0,208(sp)
     c5a:	64ae                	ld	s1,200(sp)
     c5c:	690e                	ld	s2,192(sp)
     c5e:	79ea                	ld	s3,184(sp)
     c60:	7a4a                	ld	s4,176(sp)
     c62:	7aaa                	ld	s5,168(sp)
     c64:	7b0a                	ld	s6,160(sp)
     c66:	6bea                	ld	s7,152(sp)
     c68:	612d                	addi	sp,sp,224
     c6a:	8082                	ret
        printf("FAILED ping2: send() failed\n");
     c6c:	00002517          	auipc	a0,0x2
     c70:	f9450513          	addi	a0,a0,-108 # 2c00 <malloc+0x63c>
     c74:	00002097          	auipc	ra,0x2
     c78:	898080e7          	jalr	-1896(ra) # 250c <printf>
        return 0;
     c7c:	4501                	li	a0,0
     c7e:	bfe1                	j	c56 <ping2+0x1b2>
        printf("ping2: recv() failed\n");
     c80:	00002517          	auipc	a0,0x2
     c84:	fa050513          	addi	a0,a0,-96 # 2c20 <malloc+0x65c>
     c88:	00002097          	auipc	ra,0x2
     c8c:	884080e7          	jalr	-1916(ra) # 250c <printf>
        return 0;
     c90:	4501                	li	a0,0
     c92:	b7d1                	j	c56 <ping2+0x1b2>
        printf("FAILED ping2: wrong ip src %x\n", src);
     c94:	00002517          	auipc	a0,0x2
     c98:	fa450513          	addi	a0,a0,-92 # 2c38 <malloc+0x674>
     c9c:	00002097          	auipc	ra,0x2
     ca0:	870080e7          	jalr	-1936(ra) # 250c <printf>
        return 0;
     ca4:	b7f5                	j	c90 <ping2+0x1ec>
        printf("FAILED ping2: wrong sport %d\n", sport);
     ca6:	00002517          	auipc	a0,0x2
     caa:	fb250513          	addi	a0,a0,-78 # 2c58 <malloc+0x694>
     cae:	00002097          	auipc	ra,0x2
     cb2:	85e080e7          	jalr	-1954(ra) # 250c <printf>
        return 0;
     cb6:	bfe9                	j	c90 <ping2+0x1ec>
        printf("FAILED ping2: wrong length %d\n", cc);
     cb8:	85aa                	mv	a1,a0
     cba:	00002517          	auipc	a0,0x2
     cbe:	fbe50513          	addi	a0,a0,-66 # 2c78 <malloc+0x6b4>
     cc2:	00002097          	auipc	ra,0x2
     cc6:	84a080e7          	jalr	-1974(ra) # 250c <printf>
        return 0;
     cca:	b7d9                	j	c90 <ping2+0x1ec>
        printf("FAILED ping2: wrong content\n");
     ccc:	00002517          	auipc	a0,0x2
     cd0:	fcc50513          	addi	a0,a0,-52 # 2c98 <malloc+0x6d4>
     cd4:	00002097          	auipc	ra,0x2
     cd8:	838080e7          	jalr	-1992(ra) # 250c <printf>
        return 0;
     cdc:	bf55                	j	c90 <ping2+0x1ec>

0000000000000cde <ping3>:
// bracketed by two packets from port 2009.
// check that the two packets can be recv()'d on port 2009.
// check that port 2008 had a finite queue length (dropped some).
// nettest.py ping must be started first.
//
int ping3() {
     cde:	7151                	addi	sp,sp,-240
     ce0:	f586                	sd	ra,232(sp)
     ce2:	f1a2                	sd	s0,224(sp)
     ce4:	eda6                	sd	s1,216(sp)
     ce6:	1980                	addi	s0,sp,240
  printf("ping3: starting\n");
     ce8:	00002517          	auipc	a0,0x2
     cec:	fe050513          	addi	a0,a0,-32 # 2cc8 <malloc+0x704>
     cf0:	00002097          	auipc	ra,0x2
     cf4:	81c080e7          	jalr	-2020(ra) # 250c <printf>

  bind(2008);
     cf8:	7d800513          	li	a0,2008
     cfc:	00001097          	auipc	ra,0x1
     d00:	528080e7          	jalr	1320(ra) # 2224 <bind>
  bind(2009);
     d04:	7d900513          	li	a0,2009
     d08:	00001097          	auipc	ra,0x1
     d0c:	51c080e7          	jalr	1308(ra) # 2224 <bind>
  //
  {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     d10:	07000793          	li	a5,112
     d14:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     d18:	02000793          	li	a5,32
     d1c:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'A';
     d20:	04100793          	li	a5,65
     d24:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '?';
     d28:	03f00793          	li	a5,63
     d2c:	f2f405a3          	sb	a5,-213(s0)
    if (send(2009, dst, dport, buf, 4) < 0) {
     d30:	4711                	li	a4,4
     d32:	f2840693          	addi	a3,s0,-216
     d36:	6619                	lui	a2,0x6
     d38:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     d3c:	0a0005b7          	lui	a1,0xa000
     d40:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     d44:	7d900513          	li	a0,2009
     d48:	00001097          	auipc	ra,0x1
     d4c:	4ec080e7          	jalr	1260(ra) # 2234 <send>
     d50:	20054d63          	bltz	a0,f6a <ping3+0x28c>
     d54:	e9ca                	sd	s2,208(sp)
     d56:	e5ce                	sd	s3,200(sp)
     d58:	e1d2                	sd	s4,192(sp)
     d5a:	fd56                	sd	s5,184(sp)
     d5c:	f95a                	sd	s6,176(sp)
     d5e:	f55e                	sd	s7,168(sp)
      printf("FAILED ping3: send() failed\n");
      return 0;
    }
  }
  sleep(1);
     d60:	4505                	li	a0,1
     d62:	00001097          	auipc	ra,0x1
     d66:	4b2080e7          	jalr	1202(ra) # 2214 <sleep>
  //
  // send so many packets from 2008 and 2010 that some of the
  // replies must be dropped due to the requirement
  // for finite maximum queueing.
  //
  for (int ii = 0; ii < 257; ii++) {
     d6a:	4481                	li	s1,0
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     d6c:	07000b13          	li	s6,112
    buf[1] = ' ';
     d70:	02000a93          	li	s5,32
    buf[2] = 'a' + ii;
    buf[3] = '!';
     d74:	02100a13          	li	s4,33
    int port = 2008 + (ii % 2) * 2;
    if (send(port, dst, dport, buf, 4) < 0) {
     d78:	6999                	lui	s3,0x6
     d7a:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     d7e:	0a000937          	lui	s2,0xa000
     d82:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for (int ii = 0; ii < 257; ii++) {
     d86:	10100b93          	li	s7,257
    buf[0] = 'p';
     d8a:	f3640423          	sb	s6,-216(s0)
    buf[1] = ' ';
     d8e:	f35404a3          	sb	s5,-215(s0)
    buf[2] = 'a' + ii;
     d92:	0614879b          	addiw	a5,s1,97
     d96:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     d9a:	f34405a3          	sb	s4,-213(s0)
    int port = 2008 + (ii % 2) * 2;
     d9e:	01f4d79b          	srliw	a5,s1,0x1f
     da2:	0097853b          	addw	a0,a5,s1
     da6:	8905                	andi	a0,a0,1
     da8:	9d1d                	subw	a0,a0,a5
     daa:	3ec5051b          	addiw	a0,a0,1004
     dae:	0015151b          	slliw	a0,a0,0x1
    if (send(port, dst, dport, buf, 4) < 0) {
     db2:	1542                	slli	a0,a0,0x30
     db4:	9141                	srli	a0,a0,0x30
     db6:	4711                	li	a4,4
     db8:	f2840693          	addi	a3,s0,-216
     dbc:	864e                	mv	a2,s3
     dbe:	85ca                	mv	a1,s2
     dc0:	00001097          	auipc	ra,0x1
     dc4:	474080e7          	jalr	1140(ra) # 2234 <send>
     dc8:	1a054b63          	bltz	a0,f7e <ping3+0x2a0>
  for (int ii = 0; ii < 257; ii++) {
     dcc:	2485                	addiw	s1,s1,1
     dce:	fb749ee3          	bne	s1,s7,d8a <ping3+0xac>
      printf("FAILED ping3: send() failed\n");
      return 0;
    }
  }
  sleep(1);
     dd2:	4505                	li	a0,1
     dd4:	00001097          	auipc	ra,0x1
     dd8:	440080e7          	jalr	1088(ra) # 2214 <sleep>
  //
  {
    uint32 dst = 0x0A000202;  // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     ddc:	07000793          	li	a5,112
     de0:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     de4:	02000793          	li	a5,32
     de8:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'B';
     dec:	04200793          	li	a5,66
     df0:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '?';
     df4:	03f00793          	li	a5,63
     df8:	f2f405a3          	sb	a5,-213(s0)
    if (send(2009, dst, dport, buf, 4) < 0) {
     dfc:	4711                	li	a4,4
     dfe:	f2840693          	addi	a3,s0,-216
     e02:	6619                	lui	a2,0x6
     e04:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     e08:	0a0005b7          	lui	a1,0xa000
     e0c:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     e10:	7d900513          	li	a0,2009
     e14:	00001097          	auipc	ra,0x1
     e18:	420080e7          	jalr	1056(ra) # 2234 <send>
     e1c:	04100913          	li	s2,65
     e20:	18054463          	bltz	a0,fa8 <ping3+0x2ca>
    if (cc < 0) {
      printf("FAILED ping3: recv() failed\n");
      return 0;
    }

    if (src != 0x0A000202) {  // 10.0.2.2
     e24:	0a0009b7          	lui	s3,0xa000
     e28:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
      printf("FAILED ping3: wrong ip src %x\n", src);
      return 0;
    }

    if (sport != NET_TESTS_PORT) {
     e2c:	6a19                	lui	s4,0x6
     e2e:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
      printf("FAILED ping3: wrong sport %d\n", sport);
      return 0;
    }

    if (cc != 4) {
     e32:	4b11                	li	s6,4
    }

    // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

    char buf[4];
    buf[0] = 'p';
     e34:	07000a93          	li	s5,112
    uint32 src = 0;
     e38:	f2042223          	sw	zero,-220(s0)
    uint16 sport = 0;
     e3c:	f0041f23          	sh	zero,-226(s0)
    memset(ibuf, 0, sizeof(ibuf));
     e40:	08000613          	li	a2,128
     e44:	4581                	li	a1,0
     e46:	f2840513          	addi	a0,s0,-216
     e4a:	00001097          	auipc	ra,0x1
     e4e:	140080e7          	jalr	320(ra) # 1f8a <memset>
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf) - 1);
     e52:	07f00713          	li	a4,127
     e56:	f2840693          	addi	a3,s0,-216
     e5a:	f1e40613          	addi	a2,s0,-226
     e5e:	f2440593          	addi	a1,s0,-220
     e62:	7d900513          	li	a0,2009
     e66:	00001097          	auipc	ra,0x1
     e6a:	3d6080e7          	jalr	982(ra) # 223c <recv>
    if (cc < 0) {
     e6e:	14054d63          	bltz	a0,fc8 <ping3+0x2ea>
    if (src != 0x0A000202) {  // 10.0.2.2
     e72:	f2442583          	lw	a1,-220(s0)
     e76:	17359963          	bne	a1,s3,fe8 <ping3+0x30a>
    if (sport != NET_TESTS_PORT) {
     e7a:	f1e45583          	lhu	a1,-226(s0)
     e7e:	0005879b          	sext.w	a5,a1
     e82:	17479c63          	bne	a5,s4,ffa <ping3+0x31c>
    if (cc != 4) {
     e86:	19651363          	bne	a0,s6,100c <ping3+0x32e>
    buf[0] = 'p';
     e8a:	f3540023          	sb	s5,-224(s0)
    buf[1] = ' ';
     e8e:	02000793          	li	a5,32
     e92:	f2f400a3          	sb	a5,-223(s0)
    buf[2] = 'A' + ii;
     e96:	f3240123          	sb	s2,-222(s0)
    buf[3] = '?';
     e9a:	03f00793          	li	a5,63
     e9e:	f2f401a3          	sb	a5,-221(s0)

    if (memcmp(buf, ibuf, 3) != 0) {
     ea2:	460d                	li	a2,3
     ea4:	f2840593          	addi	a1,s0,-216
     ea8:	f2040513          	addi	a0,s0,-224
     eac:	00001097          	auipc	ra,0x1
     eb0:	27e080e7          	jalr	638(ra) # 212a <memcmp>
     eb4:	84aa                	mv	s1,a0
     eb6:	16051563          	bnez	a0,1020 <ping3+0x342>
  for (int ii = 0; ii < 2; ii++) {
     eba:	2905                	addiw	s2,s2,1
     ebc:	0ff97913          	zext.b	s2,s2
     ec0:	04300793          	li	a5,67
     ec4:	f6f91ae3          	bne	s2,a5,e38 <ping3+0x15a>

  //
  // now count how many replies were queued for 2008.
  //
  int fds[2];
  pipe(fds);
     ec8:	fa840513          	addi	a0,s0,-88
     ecc:	00001097          	auipc	ra,0x1
     ed0:	2c8080e7          	jalr	712(ra) # 2194 <pipe>
  int pid = fork();
     ed4:	00001097          	auipc	ra,0x1
     ed8:	2a8080e7          	jalr	680(ra) # 217c <fork>
     edc:	89aa                	mv	s3,a0
  if (pid == 0) {
     ede:	14050a63          	beqz	a0,1032 <ping3+0x354>
      }
      write(fds[1], "x", 1);
    }
    exit(0);
  }
  close(fds[1]);
     ee2:	fac42503          	lw	a0,-84(s0)
     ee6:	00001097          	auipc	ra,0x1
     eea:	2c6080e7          	jalr	710(ra) # 21ac <close>

  sleep(5);
     eee:	4515                	li	a0,5
     ef0:	00001097          	auipc	ra,0x1
     ef4:	324080e7          	jalr	804(ra) # 2214 <sleep>
  static char nbuf[512];
  int n = read(fds[0], nbuf, sizeof(nbuf));
     ef8:	20000613          	li	a2,512
     efc:	00003597          	auipc	a1,0x3
     f00:	11458593          	addi	a1,a1,276 # 4010 <nbuf.0>
     f04:	fa842503          	lw	a0,-88(s0)
     f08:	00001097          	auipc	ra,0x1
     f0c:	294080e7          	jalr	660(ra) # 219c <read>
     f10:	892a                	mv	s2,a0
  close(fds[0]);
     f12:	fa842503          	lw	a0,-88(s0)
     f16:	00001097          	auipc	ra,0x1
     f1a:	296080e7          	jalr	662(ra) # 21ac <close>
  kill(pid);
     f1e:	854e                	mv	a0,s3
     f20:	00001097          	auipc	ra,0x1
     f24:	294080e7          	jalr	660(ra) # 21b4 <kill>

  n -= 1;  // the ":"
     f28:	fff9059b          	addiw	a1,s2,-1
  if (n > 16) {
     f2c:	47c1                	li	a5,16
     f2e:	18b7ca63          	blt	a5,a1,10c2 <ping3+0x3e4>
    printf("FAILED ping3: too many packets (%d) were queued on a UDP port\n",
           n);
    return 0;
  }

  unbind(2008);
     f32:	7d800513          	li	a0,2008
     f36:	00001097          	auipc	ra,0x1
     f3a:	2f6080e7          	jalr	758(ra) # 222c <unbind>
  unbind(2009);
     f3e:	7d900513          	li	a0,2009
     f42:	00001097          	auipc	ra,0x1
     f46:	2ea080e7          	jalr	746(ra) # 222c <unbind>
  printf("ping3: OK\n");
     f4a:	00002517          	auipc	a0,0x2
     f4e:	ec650513          	addi	a0,a0,-314 # 2e10 <malloc+0x84c>
     f52:	00001097          	auipc	ra,0x1
     f56:	5ba080e7          	jalr	1466(ra) # 250c <printf>

  return 1;
     f5a:	4485                	li	s1,1
     f5c:	694e                	ld	s2,208(sp)
     f5e:	69ae                	ld	s3,200(sp)
     f60:	6a0e                	ld	s4,192(sp)
     f62:	7aea                	ld	s5,184(sp)
     f64:	7b4a                	ld	s6,176(sp)
     f66:	7baa                	ld	s7,168(sp)
     f68:	a815                	j	f9c <ping3+0x2be>
      printf("FAILED ping3: send() failed\n");
     f6a:	00002517          	auipc	a0,0x2
     f6e:	d7650513          	addi	a0,a0,-650 # 2ce0 <malloc+0x71c>
     f72:	00001097          	auipc	ra,0x1
     f76:	59a080e7          	jalr	1434(ra) # 250c <printf>
      return 0;
     f7a:	4481                	li	s1,0
     f7c:	a005                	j	f9c <ping3+0x2be>
      printf("FAILED ping3: send() failed\n");
     f7e:	00002517          	auipc	a0,0x2
     f82:	d6250513          	addi	a0,a0,-670 # 2ce0 <malloc+0x71c>
     f86:	00001097          	auipc	ra,0x1
     f8a:	586080e7          	jalr	1414(ra) # 250c <printf>
      return 0;
     f8e:	4481                	li	s1,0
     f90:	694e                	ld	s2,208(sp)
     f92:	69ae                	ld	s3,200(sp)
     f94:	6a0e                	ld	s4,192(sp)
     f96:	7aea                	ld	s5,184(sp)
     f98:	7b4a                	ld	s6,176(sp)
     f9a:	7baa                	ld	s7,168(sp)
}
     f9c:	8526                	mv	a0,s1
     f9e:	70ae                	ld	ra,232(sp)
     fa0:	740e                	ld	s0,224(sp)
     fa2:	64ee                	ld	s1,216(sp)
     fa4:	616d                	addi	sp,sp,240
     fa6:	8082                	ret
      printf("FAILED ping3: send() failed\n");
     fa8:	00002517          	auipc	a0,0x2
     fac:	d3850513          	addi	a0,a0,-712 # 2ce0 <malloc+0x71c>
     fb0:	00001097          	auipc	ra,0x1
     fb4:	55c080e7          	jalr	1372(ra) # 250c <printf>
      return 0;
     fb8:	4481                	li	s1,0
     fba:	694e                	ld	s2,208(sp)
     fbc:	69ae                	ld	s3,200(sp)
     fbe:	6a0e                	ld	s4,192(sp)
     fc0:	7aea                	ld	s5,184(sp)
     fc2:	7b4a                	ld	s6,176(sp)
     fc4:	7baa                	ld	s7,168(sp)
     fc6:	bfd9                	j	f9c <ping3+0x2be>
      printf("FAILED ping3: recv() failed\n");
     fc8:	00002517          	auipc	a0,0x2
     fcc:	d3850513          	addi	a0,a0,-712 # 2d00 <malloc+0x73c>
     fd0:	00001097          	auipc	ra,0x1
     fd4:	53c080e7          	jalr	1340(ra) # 250c <printf>
      return 0;
     fd8:	4481                	li	s1,0
     fda:	694e                	ld	s2,208(sp)
     fdc:	69ae                	ld	s3,200(sp)
     fde:	6a0e                	ld	s4,192(sp)
     fe0:	7aea                	ld	s5,184(sp)
     fe2:	7b4a                	ld	s6,176(sp)
     fe4:	7baa                	ld	s7,168(sp)
     fe6:	bf5d                	j	f9c <ping3+0x2be>
      printf("FAILED ping3: wrong ip src %x\n", src);
     fe8:	00002517          	auipc	a0,0x2
     fec:	d3850513          	addi	a0,a0,-712 # 2d20 <malloc+0x75c>
     ff0:	00001097          	auipc	ra,0x1
     ff4:	51c080e7          	jalr	1308(ra) # 250c <printf>
      return 0;
     ff8:	b7c5                	j	fd8 <ping3+0x2fa>
      printf("FAILED ping3: wrong sport %d\n", sport);
     ffa:	00002517          	auipc	a0,0x2
     ffe:	d4650513          	addi	a0,a0,-698 # 2d40 <malloc+0x77c>
    1002:	00001097          	auipc	ra,0x1
    1006:	50a080e7          	jalr	1290(ra) # 250c <printf>
      return 0;
    100a:	b7f9                	j	fd8 <ping3+0x2fa>
      printf("FAILED ping3: wrong length %d\n", cc);
    100c:	85aa                	mv	a1,a0
    100e:	00002517          	auipc	a0,0x2
    1012:	d5250513          	addi	a0,a0,-686 # 2d60 <malloc+0x79c>
    1016:	00001097          	auipc	ra,0x1
    101a:	4f6080e7          	jalr	1270(ra) # 250c <printf>
      return 0;
    101e:	bf6d                	j	fd8 <ping3+0x2fa>
      printf("FAILED ping3: wrong content\n");
    1020:	00002517          	auipc	a0,0x2
    1024:	d6050513          	addi	a0,a0,-672 # 2d80 <malloc+0x7bc>
    1028:	00001097          	auipc	ra,0x1
    102c:	4e4080e7          	jalr	1252(ra) # 250c <printf>
      return 0;
    1030:	b765                	j	fd8 <ping3+0x2fa>
    close(fds[0]);
    1032:	fa842503          	lw	a0,-88(s0)
    1036:	00001097          	auipc	ra,0x1
    103a:	176080e7          	jalr	374(ra) # 21ac <close>
    write(fds[1], ":", 1);  // ensure parent's read() doesn't block
    103e:	4605                	li	a2,1
    1040:	00002597          	auipc	a1,0x2
    1044:	d6058593          	addi	a1,a1,-672 # 2da0 <malloc+0x7dc>
    1048:	fac42503          	lw	a0,-84(s0)
    104c:	00001097          	auipc	ra,0x1
    1050:	158080e7          	jalr	344(ra) # 21a4 <write>
      write(fds[1], "x", 1);
    1054:	00002497          	auipc	s1,0x2
    1058:	d7448493          	addi	s1,s1,-652 # 2dc8 <malloc+0x804>
    105c:	a809                	j	106e <ping3+0x390>
    105e:	4605                	li	a2,1
    1060:	85a6                	mv	a1,s1
    1062:	fac42503          	lw	a0,-84(s0)
    1066:	00001097          	auipc	ra,0x1
    106a:	13e080e7          	jalr	318(ra) # 21a4 <write>
      uint32 src = 0;
    106e:	f2042223          	sw	zero,-220(s0)
      uint16 sport = 0;
    1072:	f2041023          	sh	zero,-224(s0)
      memset(ibuf, 0, sizeof(ibuf));
    1076:	08000613          	li	a2,128
    107a:	4581                	li	a1,0
    107c:	f2840513          	addi	a0,s0,-216
    1080:	00001097          	auipc	ra,0x1
    1084:	f0a080e7          	jalr	-246(ra) # 1f8a <memset>
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf) - 1);
    1088:	07f00713          	li	a4,127
    108c:	f2840693          	addi	a3,s0,-216
    1090:	f2040613          	addi	a2,s0,-224
    1094:	f2440593          	addi	a1,s0,-220
    1098:	7d800513          	li	a0,2008
    109c:	00001097          	auipc	ra,0x1
    10a0:	1a0080e7          	jalr	416(ra) # 223c <recv>
      if (cc < 0) {
    10a4:	fa055de3          	bgez	a0,105e <ping3+0x380>
        printf("FAILED ping3: recv failed\n");
    10a8:	00002517          	auipc	a0,0x2
    10ac:	d0050513          	addi	a0,a0,-768 # 2da8 <malloc+0x7e4>
    10b0:	00001097          	auipc	ra,0x1
    10b4:	45c080e7          	jalr	1116(ra) # 250c <printf>
    exit(0);
    10b8:	4501                	li	a0,0
    10ba:	00001097          	auipc	ra,0x1
    10be:	0ca080e7          	jalr	202(ra) # 2184 <exit>
    printf("FAILED ping3: too many packets (%d) were queued on a UDP port\n",
    10c2:	00002517          	auipc	a0,0x2
    10c6:	d0e50513          	addi	a0,a0,-754 # 2dd0 <malloc+0x80c>
    10ca:	00001097          	auipc	ra,0x1
    10ce:	442080e7          	jalr	1090(ra) # 250c <printf>
    return 0;
    10d2:	694e                	ld	s2,208(sp)
    10d4:	69ae                	ld	s3,200(sp)
    10d6:	6a0e                	ld	s4,192(sp)
    10d8:	7aea                	ld	s5,184(sp)
    10da:	7b4a                	ld	s6,176(sp)
    10dc:	7baa                	ld	s7,168(sp)
    10de:	bd7d                	j	f9c <ping3+0x2be>

00000000000010e0 <encode_qname>:

// Encode a DNS name
void encode_qname(char *qn, char *host) {
    10e0:	7139                	addi	sp,sp,-64
    10e2:	fc06                	sd	ra,56(sp)
    10e4:	f822                	sd	s0,48(sp)
    10e6:	f426                	sd	s1,40(sp)
    10e8:	f04a                	sd	s2,32(sp)
    10ea:	ec4e                	sd	s3,24(sp)
    10ec:	e852                	sd	s4,16(sp)
    10ee:	e456                	sd	s5,8(sp)
    10f0:	0080                	addi	s0,sp,64
    10f2:	8aaa                	mv	s5,a0
    10f4:	892e                	mv	s2,a1
  char *l = host;

  for (char *c = host; c < host + strlen(host) + 1; c++) {
    10f6:	84ae                	mv	s1,a1
  char *l = host;
    10f8:	8a2e                	mv	s4,a1
    if (*c == '.') {
    10fa:	02e00993          	li	s3,46
  for (char *c = host; c < host + strlen(host) + 1; c++) {
    10fe:	a029                	j	1108 <encode_qname+0x28>
      *qn++ = (char)(c - l);
    1100:	8ab2                	mv	s5,a2
      for (char *d = l; d < c; d++) {
        *qn++ = *d;
      }
      l = c + 1;  // skip .
    1102:	00148a13          	addi	s4,s1,1
  for (char *c = host; c < host + strlen(host) + 1; c++) {
    1106:	0485                	addi	s1,s1,1
    1108:	854a                	mv	a0,s2
    110a:	00001097          	auipc	ra,0x1
    110e:	e56080e7          	jalr	-426(ra) # 1f60 <strlen>
    1112:	02051793          	slli	a5,a0,0x20
    1116:	9381                	srli	a5,a5,0x20
    1118:	0785                	addi	a5,a5,1
    111a:	97ca                	add	a5,a5,s2
    111c:	02f4fc63          	bgeu	s1,a5,1154 <encode_qname+0x74>
    if (*c == '.') {
    1120:	0004c783          	lbu	a5,0(s1)
    1124:	ff3791e3          	bne	a5,s3,1106 <encode_qname+0x26>
      *qn++ = (char)(c - l);
    1128:	001a8613          	addi	a2,s5,1
    112c:	414487b3          	sub	a5,s1,s4
    1130:	00fa8023          	sb	a5,0(s5)
      for (char *d = l; d < c; d++) {
    1134:	fc9a76e3          	bgeu	s4,s1,1100 <encode_qname+0x20>
    1138:	87d2                	mv	a5,s4
      *qn++ = (char)(c - l);
    113a:	8732                	mv	a4,a2
        *qn++ = *d;
    113c:	0705                	addi	a4,a4,1
    113e:	0007c683          	lbu	a3,0(a5)
    1142:	fed70fa3          	sb	a3,-1(a4)
      for (char *d = l; d < c; d++) {
    1146:	0785                	addi	a5,a5,1
    1148:	fef49ae3          	bne	s1,a5,113c <encode_qname+0x5c>
    114c:	41448ab3          	sub	s5,s1,s4
    1150:	9ab2                	add	s5,s5,a2
    1152:	bf45                	j	1102 <encode_qname+0x22>
    }
  }
  *qn = '\0';
    1154:	000a8023          	sb	zero,0(s5)
}
    1158:	70e2                	ld	ra,56(sp)
    115a:	7442                	ld	s0,48(sp)
    115c:	74a2                	ld	s1,40(sp)
    115e:	7902                	ld	s2,32(sp)
    1160:	69e2                	ld	s3,24(sp)
    1162:	6a42                	ld	s4,16(sp)
    1164:	6aa2                	ld	s5,8(sp)
    1166:	6121                	addi	sp,sp,64
    1168:	8082                	ret

000000000000116a <decode_qname>:

// Decode a DNS name
void decode_qname(char *qn, int max) {
  char *qnMax = qn + max;
    116a:	95aa                	add	a1,a1,a0
    if (l == 0) break;
    for (int i = 0; i < l; i++) {
      *qn = *(qn + 1);
      qn++;
    }
    *qn++ = '.';
    116c:	02e00813          	li	a6,46
    if (qn >= qnMax) {
    1170:	02b56a63          	bltu	a0,a1,11a4 <decode_qname+0x3a>
void decode_qname(char *qn, int max) {
    1174:	1141                	addi	sp,sp,-16
    1176:	e406                	sd	ra,8(sp)
    1178:	e022                	sd	s0,0(sp)
    117a:	0800                	addi	s0,sp,16
      printf("FAILED dns: invalid DNS reply\n");
    117c:	00002517          	auipc	a0,0x2
    1180:	ca450513          	addi	a0,a0,-860 # 2e20 <malloc+0x85c>
    1184:	00001097          	auipc	ra,0x1
    1188:	388080e7          	jalr	904(ra) # 250c <printf>
      exit(1);
    118c:	4505                	li	a0,1
    118e:	00001097          	auipc	ra,0x1
    1192:	ff6080e7          	jalr	-10(ra) # 2184 <exit>
    *qn++ = '.';
    1196:	00160793          	addi	a5,a2,1
    119a:	953e                	add	a0,a0,a5
    119c:	01068023          	sb	a6,0(a3)
    if (qn >= qnMax) {
    11a0:	fcb57ae3          	bgeu	a0,a1,1174 <decode_qname+0xa>
    int l = *qn;
    11a4:	00054683          	lbu	a3,0(a0)
    if (l == 0) break;
    11a8:	ce89                	beqz	a3,11c2 <decode_qname+0x58>
    for (int i = 0; i < l; i++) {
    11aa:	0006861b          	sext.w	a2,a3
    11ae:	96aa                	add	a3,a3,a0
    if (l == 0) break;
    11b0:	87aa                	mv	a5,a0
      *qn = *(qn + 1);
    11b2:	0017c703          	lbu	a4,1(a5)
    11b6:	00e78023          	sb	a4,0(a5)
      qn++;
    11ba:	0785                	addi	a5,a5,1
    for (int i = 0; i < l; i++) {
    11bc:	fed79be3          	bne	a5,a3,11b2 <decode_qname+0x48>
    11c0:	bfd9                	j	1196 <decode_qname+0x2c>
    11c2:	8082                	ret

00000000000011c4 <dns_req>:
  }
}

// Make a DNS request
int dns_req(uint8 *obuf) {
    11c4:	7179                	addi	sp,sp,-48
    11c6:	f406                	sd	ra,40(sp)
    11c8:	f022                	sd	s0,32(sp)
    11ca:	ec26                	sd	s1,24(sp)
    11cc:	e84a                	sd	s2,16(sp)
    11ce:	e44e                	sd	s3,8(sp)
    11d0:	1800                	addi	s0,sp,48
  int len = 0;

  struct dns *hdr = (struct dns *)obuf;
  hdr->id = htons(6828);
    11d2:	47e9                	li	a5,26
    11d4:	00f50023          	sb	a5,0(a0)
    11d8:	fac00793          	li	a5,-84
    11dc:	00f500a3          	sb	a5,1(a0)
  hdr->rd = 1;
    11e0:	00254783          	lbu	a5,2(a0)
    11e4:	0017e793          	ori	a5,a5,1
    11e8:	00f50123          	sb	a5,2(a0)
  hdr->qdcount = htons(1);
    11ec:	00050223          	sb	zero,4(a0)
    11f0:	4985                	li	s3,1
    11f2:	013502a3          	sb	s3,5(a0)

  len += sizeof(struct dns);

  // qname part of question
  char *qname = (char *)(obuf + sizeof(struct dns));
    11f6:	00c50493          	addi	s1,a0,12
  char *s = "nerc.itmo.ru.";
  encode_qname(qname, s);
    11fa:	00002597          	auipc	a1,0x2
    11fe:	c4658593          	addi	a1,a1,-954 # 2e40 <malloc+0x87c>
    1202:	8526                	mv	a0,s1
    1204:	00000097          	auipc	ra,0x0
    1208:	edc080e7          	jalr	-292(ra) # 10e0 <encode_qname>
  len += strlen(qname) + 1;
    120c:	8526                	mv	a0,s1
    120e:	00001097          	auipc	ra,0x1
    1212:	d52080e7          	jalr	-686(ra) # 1f60 <strlen>
    1216:	0005091b          	sext.w	s2,a0

  // constants part of question
  struct dns_question *h = (struct dns_question *)(qname + strlen(qname) + 1);
    121a:	8526                	mv	a0,s1
    121c:	00001097          	auipc	ra,0x1
    1220:	d44080e7          	jalr	-700(ra) # 1f60 <strlen>
    1224:	02051793          	slli	a5,a0,0x20
    1228:	9381                	srli	a5,a5,0x20
    122a:	0785                	addi	a5,a5,1
    122c:	00f48533          	add	a0,s1,a5
  h->qtype = htons(0x1);
    1230:	00050023          	sb	zero,0(a0)
    1234:	013500a3          	sb	s3,1(a0)
  h->qclass = htons(0x1);
    1238:	00050123          	sb	zero,2(a0)
    123c:	013501a3          	sb	s3,3(a0)

  len += sizeof(struct dns_question);
  return len;
}
    1240:	0119051b          	addiw	a0,s2,17
    1244:	70a2                	ld	ra,40(sp)
    1246:	7402                	ld	s0,32(sp)
    1248:	64e2                	ld	s1,24(sp)
    124a:	6942                	ld	s2,16(sp)
    124c:	69a2                	ld	s3,8(sp)
    124e:	6145                	addi	sp,sp,48
    1250:	8082                	ret

0000000000001252 <dns_rep>:

// Process DNS response
int dns_rep(uint8 *ibuf, int cc) {
    1252:	7119                	addi	sp,sp,-128
    1254:	fc86                	sd	ra,120(sp)
    1256:	f8a2                	sd	s0,112(sp)
    1258:	f862                	sd	s8,48(sp)
    125a:	0100                	addi	s0,sp,128
  struct dns *hdr = (struct dns *)ibuf;
  int len;
  char *qname = 0;
  int record = 0;

  if (cc < sizeof(struct dns)) {
    125c:	47ad                	li	a5,11
    125e:	0cb7fc63          	bgeu	a5,a1,1336 <dns_rep+0xe4>
    1262:	f0ca                	sd	s2,96(sp)
    1264:	e4d6                	sd	s5,72(sp)
    1266:	892a                	mv	s2,a0
    1268:	8aae                	mv	s5,a1
    printf("FAILED dns: reply too short\n");
    return 0;
  }

  if (!hdr->qr) {
    126a:	00250783          	lb	a5,2(a0)
    126e:	0c07de63          	bgez	a5,134a <dns_rep+0xf8>
    printf("FAILED dns: not a reply for %d\n", ntohs(hdr->id));
    return 0;
  }

  if (hdr->id != htons(6828)) {
    1272:	00054703          	lbu	a4,0(a0)
    1276:	00154783          	lbu	a5,1(a0)
    127a:	07a2                	slli	a5,a5,0x8
    127c:	00e7e6b3          	or	a3,a5,a4
    1280:	672d                	lui	a4,0xb
    1282:	c1a70713          	addi	a4,a4,-998 # ac1a <base+0x6a0a>
    1286:	10e69063          	bne	a3,a4,1386 <dns_rep+0x134>
    printf("FAILED dns: wrong id %d\n", ntohs(hdr->id));
    return 0;
  }

  if (hdr->rcode != 0) {
    128a:	00354783          	lbu	a5,3(a0)
    128e:	8bbd                	andi	a5,a5,15
    1290:	10079e63          	bnez	a5,13ac <dns_rep+0x15a>
    1294:	f4a6                	sd	s1,104(sp)
    1296:	ecce                	sd	s3,88(sp)
    1298:	e8d2                	sd	s4,80(sp)
  // printf("nscount: %x\n", ntohs(hdr->nscount));
  // printf("arcount: %x\n", ntohs(hdr->arcount));

  len = sizeof(struct dns);

  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    129a:	00454703          	lbu	a4,4(a0)
    129e:	00554783          	lbu	a5,5(a0)
    12a2:	07a2                	slli	a5,a5,0x8
    12a4:	8fd9                	or	a5,a5,a4
    12a6:	4a01                	li	s4,0
  len = sizeof(struct dns);
    12a8:	44b1                	li	s1,12
  char *qname = 0;
    12aa:	4981                	li	s3,0
  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    12ac:	c3a1                	beqz	a5,12ec <dns_rep+0x9a>
    char *qn = (char *)(ibuf + len);
    12ae:	009909b3          	add	s3,s2,s1
    qname = qn;
    decode_qname(qn, cc - len);
    12b2:	409a85bb          	subw	a1,s5,s1
    12b6:	854e                	mv	a0,s3
    12b8:	00000097          	auipc	ra,0x0
    12bc:	eb2080e7          	jalr	-334(ra) # 116a <decode_qname>
    len += strlen(qn) + 1;
    12c0:	854e                	mv	a0,s3
    12c2:	00001097          	auipc	ra,0x1
    12c6:	c9e080e7          	jalr	-866(ra) # 1f60 <strlen>
    len += sizeof(struct dns_question);
    12ca:	2515                	addiw	a0,a0,5
    12cc:	9ca9                	addw	s1,s1,a0
  for (int i = 0; i < ntohs(hdr->qdcount); i++) {
    12ce:	2a05                	addiw	s4,s4,1
    12d0:	00494703          	lbu	a4,4(s2)
    12d4:	00594783          	lbu	a5,5(s2)
    12d8:	07a2                	slli	a5,a5,0x8
    12da:	8fd9                	or	a5,a5,a4
//

#include "types.h"

static inline uint16 bswaps(uint16 val) {
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    12dc:	0087971b          	slliw	a4,a5,0x8
    12e0:	83a1                	srli	a5,a5,0x8
    12e2:	8fd9                	or	a5,a5,a4
    12e4:	17c2                	slli	a5,a5,0x30
    12e6:	93c1                	srli	a5,a5,0x30
    12e8:	fcfa43e3          	blt	s4,a5,12ae <dns_rep+0x5c>
  }

  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    12ec:	00694703          	lbu	a4,6(s2)
    12f0:	00794783          	lbu	a5,7(s2)
    12f4:	07a2                	slli	a5,a5,0x8
    12f6:	8fd9                	or	a5,a5,a4
    12f8:	28078463          	beqz	a5,1580 <dns_rep+0x32e>
    if (len >= cc) {
    12fc:	0d54dc63          	bge	s1,s5,13d4 <dns_rep+0x182>
    1300:	e0da                	sd	s6,64(sp)
    1302:	fc5e                	sd	s7,56(sp)
    1304:	f466                	sd	s9,40(sp)
    1306:	f06a                	sd	s10,32(sp)
    1308:	ec6e                	sd	s11,24(sp)
    130a:	00002797          	auipc	a5,0x2
    130e:	06678793          	addi	a5,a5,102 # 3370 <malloc+0xdac>
    1312:	00098363          	beqz	s3,1318 <dns_rep+0xc6>
    1316:	87ce                	mv	a5,s3
    1318:	f8f43423          	sd	a5,-120(s0)
  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    131c:	4981                	li	s3,0
  int record = 0;
    131e:	4c01                	li	s8,0
      return 0;
    }

    char *qn = (char *)(ibuf + len);

    if ((int)qn[0] > 63) {  // compression?
    1320:	03f00b93          	li	s7,63

    struct dns_data *d = (struct dns_data *)(ibuf + len);
    len += sizeof(struct dns_data);
    // printf("type %d ttl %d len %d\n", ntohs(d->type), ntohl(d->ttl),
    // ntohs(d->len));
    if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1324:	10000b13          	li	s6,256
    1328:	40000c93          	li	s9,1024
      record = 1;
      printf("dns: arecord for %s is ", qname ? qname : "");
      uint8 *ip = (ibuf + len);
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
      if (ip[0] != 77 || ip[1] != 234 || ip[2] != 215 || ip[3] != 132) {
    132c:	04d00d13          	li	s10,77
    1330:	0ea00d93          	li	s11,234
    1334:	a21d                	j	145a <dns_rep+0x208>
    printf("FAILED dns: reply too short\n");
    1336:	00002517          	auipc	a0,0x2
    133a:	b1a50513          	addi	a0,a0,-1254 # 2e50 <malloc+0x88c>
    133e:	00001097          	auipc	ra,0x1
    1342:	1ce080e7          	jalr	462(ra) # 250c <printf>
    return 0;
    1346:	4c01                	li	s8,0
    1348:	a80d                	j	137a <dns_rep+0x128>
    printf("FAILED dns: not a reply for %d\n", ntohs(hdr->id));
    134a:	00054703          	lbu	a4,0(a0)
    134e:	00154783          	lbu	a5,1(a0)
    1352:	07a2                	slli	a5,a5,0x8
    1354:	8fd9                	or	a5,a5,a4
    1356:	0087971b          	slliw	a4,a5,0x8
    135a:	83a1                	srli	a5,a5,0x8
    135c:	00e7e5b3          	or	a1,a5,a4
    1360:	15c2                	slli	a1,a1,0x30
    1362:	91c1                	srli	a1,a1,0x30
    1364:	00002517          	auipc	a0,0x2
    1368:	b0c50513          	addi	a0,a0,-1268 # 2e70 <malloc+0x8ac>
    136c:	00001097          	auipc	ra,0x1
    1370:	1a0080e7          	jalr	416(ra) # 250c <printf>
    return 0;
    1374:	4c01                	li	s8,0
    1376:	7906                	ld	s2,96(sp)
    1378:	6aa6                	ld	s5,72(sp)
    printf("FAILED dns: didn't receive an arecord\n");
    return 0;
  }

  return 1;
}
    137a:	8562                	mv	a0,s8
    137c:	70e6                	ld	ra,120(sp)
    137e:	7446                	ld	s0,112(sp)
    1380:	7c42                	ld	s8,48(sp)
    1382:	6109                	addi	sp,sp,128
    1384:	8082                	ret
    1386:	0086959b          	slliw	a1,a3,0x8
    138a:	0086d69b          	srliw	a3,a3,0x8
    138e:	8dd5                	or	a1,a1,a3
    printf("FAILED dns: wrong id %d\n", ntohs(hdr->id));
    1390:	15c2                	slli	a1,a1,0x30
    1392:	91c1                	srli	a1,a1,0x30
    1394:	00002517          	auipc	a0,0x2
    1398:	afc50513          	addi	a0,a0,-1284 # 2e90 <malloc+0x8cc>
    139c:	00001097          	auipc	ra,0x1
    13a0:	170080e7          	jalr	368(ra) # 250c <printf>
    return 0;
    13a4:	4c01                	li	s8,0
    13a6:	7906                	ld	s2,96(sp)
    13a8:	6aa6                	ld	s5,72(sp)
    13aa:	bfc1                	j	137a <dns_rep+0x128>
    printf("FAILED dns: rcode error: %x\n", hdr->rcode);
    13ac:	00354583          	lbu	a1,3(a0)
    13b0:	89bd                	andi	a1,a1,15
    13b2:	00002517          	auipc	a0,0x2
    13b6:	afe50513          	addi	a0,a0,-1282 # 2eb0 <malloc+0x8ec>
    13ba:	00001097          	auipc	ra,0x1
    13be:	152080e7          	jalr	338(ra) # 250c <printf>
    return 0;
    13c2:	4c01                	li	s8,0
    13c4:	7906                	ld	s2,96(sp)
    13c6:	6aa6                	ld	s5,72(sp)
    13c8:	bf4d                	j	137a <dns_rep+0x128>
    13ca:	6b06                	ld	s6,64(sp)
    13cc:	7be2                	ld	s7,56(sp)
    13ce:	7ca2                	ld	s9,40(sp)
    13d0:	7d02                	ld	s10,32(sp)
    13d2:	6de2                	ld	s11,24(sp)
      printf("FAILED dns: invalid DNS reply\n");
    13d4:	00002517          	auipc	a0,0x2
    13d8:	a4c50513          	addi	a0,a0,-1460 # 2e20 <malloc+0x85c>
    13dc:	00001097          	auipc	ra,0x1
    13e0:	130080e7          	jalr	304(ra) # 250c <printf>
      return 0;
    13e4:	4c01                	li	s8,0
    13e6:	74a6                	ld	s1,104(sp)
    13e8:	7906                	ld	s2,96(sp)
    13ea:	69e6                	ld	s3,88(sp)
    13ec:	6a46                	ld	s4,80(sp)
    13ee:	6aa6                	ld	s5,72(sp)
    13f0:	b769                	j	137a <dns_rep+0x128>
      decode_qname(qn, cc - len);
    13f2:	409a85bb          	subw	a1,s5,s1
    13f6:	8552                	mv	a0,s4
    13f8:	00000097          	auipc	ra,0x0
    13fc:	d72080e7          	jalr	-654(ra) # 116a <decode_qname>
      len += strlen(qn) + 1;
    1400:	8552                	mv	a0,s4
    1402:	00001097          	auipc	ra,0x1
    1406:	b5e080e7          	jalr	-1186(ra) # 1f60 <strlen>
    140a:	2485                	addiw	s1,s1,1
    140c:	9ca9                	addw	s1,s1,a0
    140e:	a8a9                	j	1468 <dns_rep+0x216>
        printf("FAILED dns: wrong ip address");
    1410:	00002517          	auipc	a0,0x2
    1414:	ae850513          	addi	a0,a0,-1304 # 2ef8 <malloc+0x934>
    1418:	00001097          	auipc	ra,0x1
    141c:	0f4080e7          	jalr	244(ra) # 250c <printf>
        return 0;
    1420:	4c01                	li	s8,0
    1422:	74a6                	ld	s1,104(sp)
    1424:	7906                	ld	s2,96(sp)
    1426:	69e6                	ld	s3,88(sp)
    1428:	6a46                	ld	s4,80(sp)
    142a:	6aa6                	ld	s5,72(sp)
    142c:	6b06                	ld	s6,64(sp)
    142e:	7be2                	ld	s7,56(sp)
    1430:	7ca2                	ld	s9,40(sp)
    1432:	7d02                	ld	s10,32(sp)
    1434:	6de2                	ld	s11,24(sp)
    1436:	b791                	j	137a <dns_rep+0x128>
  for (int i = 0; i < ntohs(hdr->ancount); i++) {
    1438:	2985                	addiw	s3,s3,1
    143a:	00694703          	lbu	a4,6(s2)
    143e:	00794783          	lbu	a5,7(s2)
    1442:	07a2                	slli	a5,a5,0x8
    1444:	8fd9                	or	a5,a5,a4
    1446:	0087971b          	slliw	a4,a5,0x8
    144a:	83a1                	srli	a5,a5,0x8
    144c:	8fd9                	or	a5,a5,a4
    144e:	17c2                	slli	a5,a5,0x30
    1450:	93c1                	srli	a5,a5,0x30
    1452:	0af9d363          	bge	s3,a5,14f8 <dns_rep+0x2a6>
    if (len >= cc) {
    1456:	f754dae3          	bge	s1,s5,13ca <dns_rep+0x178>
    char *qn = (char *)(ibuf + len);
    145a:	00990a33          	add	s4,s2,s1
    if ((int)qn[0] > 63) {  // compression?
    145e:	000a4783          	lbu	a5,0(s4)
    1462:	f8fbf8e3          	bgeu	s7,a5,13f2 <dns_rep+0x1a0>
      len += 2;
    1466:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *)(ibuf + len);
    1468:	00990733          	add	a4,s2,s1
    len += sizeof(struct dns_data);
    146c:	00048a1b          	sext.w	s4,s1
    1470:	24a9                	addiw	s1,s1,10
    if (ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1472:	00074683          	lbu	a3,0(a4)
    1476:	00174783          	lbu	a5,1(a4)
    147a:	07a2                	slli	a5,a5,0x8
    147c:	8fd5                	or	a5,a5,a3
    147e:	fb679de3          	bne	a5,s6,1438 <dns_rep+0x1e6>
    1482:	00874683          	lbu	a3,8(a4)
    1486:	00974783          	lbu	a5,9(a4)
    148a:	07a2                	slli	a5,a5,0x8
    148c:	8fd5                	or	a5,a5,a3
    148e:	fb9795e3          	bne	a5,s9,1438 <dns_rep+0x1e6>
      printf("dns: arecord for %s is ", qname ? qname : "");
    1492:	f8843583          	ld	a1,-120(s0)
    1496:	00002517          	auipc	a0,0x2
    149a:	a3a50513          	addi	a0,a0,-1478 # 2ed0 <malloc+0x90c>
    149e:	00001097          	auipc	ra,0x1
    14a2:	06e080e7          	jalr	110(ra) # 250c <printf>
      uint8 *ip = (ibuf + len);
    14a6:	94ca                	add	s1,s1,s2
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
    14a8:	0034c703          	lbu	a4,3(s1)
    14ac:	0024c683          	lbu	a3,2(s1)
    14b0:	0014c603          	lbu	a2,1(s1)
    14b4:	0004c583          	lbu	a1,0(s1)
    14b8:	00002517          	auipc	a0,0x2
    14bc:	a3050513          	addi	a0,a0,-1488 # 2ee8 <malloc+0x924>
    14c0:	00001097          	auipc	ra,0x1
    14c4:	04c080e7          	jalr	76(ra) # 250c <printf>
      if (ip[0] != 77 || ip[1] != 234 || ip[2] != 215 || ip[3] != 132) {
    14c8:	0004c783          	lbu	a5,0(s1)
    14cc:	f5a792e3          	bne	a5,s10,1410 <dns_rep+0x1be>
    14d0:	0014c783          	lbu	a5,1(s1)
    14d4:	f3b79ee3          	bne	a5,s11,1410 <dns_rep+0x1be>
    14d8:	0024c783          	lbu	a5,2(s1)
    14dc:	0d700713          	li	a4,215
    14e0:	f2e798e3          	bne	a5,a4,1410 <dns_rep+0x1be>
    14e4:	0034c703          	lbu	a4,3(s1)
    14e8:	08400793          	li	a5,132
    14ec:	f2f712e3          	bne	a4,a5,1410 <dns_rep+0x1be>
      len += 4;
    14f0:	00ea049b          	addiw	s1,s4,14
      record = 1;
    14f4:	4c05                	li	s8,1
    14f6:	b789                	j	1438 <dns_rep+0x1e6>
    14f8:	6b06                	ld	s6,64(sp)
    14fa:	7be2                	ld	s7,56(sp)
    14fc:	7ca2                	ld	s9,40(sp)
    14fe:	7d02                	ld	s10,32(sp)
    1500:	6de2                	ld	s11,24(sp)
  for (int i = 0; i < ntohs(hdr->arcount); i++) {
    1502:	00a94703          	lbu	a4,10(s2)
    1506:	00b94783          	lbu	a5,11(s2)
    150a:	07a2                	slli	a5,a5,0x8
    150c:	8fd9                	or	a5,a5,a4
    150e:	0087959b          	slliw	a1,a5,0x8
    1512:	0087d71b          	srliw	a4,a5,0x8
    1516:	8dd9                	or	a1,a1,a4
    1518:	15c2                	slli	a1,a1,0x30
    151a:	91c1                	srli	a1,a1,0x30
    151c:	cba1                	beqz	a5,156c <dns_rep+0x31a>
    151e:	4681                	li	a3,0
    if (ntohs(d->type) != 41) {
    1520:	650d                	lui	a0,0x3
    1522:	90050513          	addi	a0,a0,-1792 # 2900 <malloc+0x33c>
    if (*qn != 0) {
    1526:	009907b3          	add	a5,s2,s1
    152a:	0007c783          	lbu	a5,0(a5)
    152e:	ebb9                	bnez	a5,1584 <dns_rep+0x332>
    struct dns_data *d = (struct dns_data *)(ibuf + len);
    1530:	0014879b          	addiw	a5,s1,1
    1534:	97ca                	add	a5,a5,s2
    len += sizeof(struct dns_data);
    1536:	24ad                	addiw	s1,s1,11
    if (ntohs(d->type) != 41) {
    1538:	0007c603          	lbu	a2,0(a5)
    153c:	0017c703          	lbu	a4,1(a5)
    1540:	0722                	slli	a4,a4,0x8
    1542:	8f51                	or	a4,a4,a2
    1544:	04a71f63          	bne	a4,a0,15a2 <dns_rep+0x350>
    len += ntohs(d->len);
    1548:	0087c703          	lbu	a4,8(a5)
    154c:	0097c783          	lbu	a5,9(a5)
    1550:	07a2                	slli	a5,a5,0x8
    1552:	8fd9                	or	a5,a5,a4
    1554:	0087971b          	slliw	a4,a5,0x8
    1558:	83a1                	srli	a5,a5,0x8
    155a:	8fd9                	or	a5,a5,a4
    155c:	0107979b          	slliw	a5,a5,0x10
    1560:	0107d79b          	srliw	a5,a5,0x10
    1564:	9cbd                	addw	s1,s1,a5
  for (int i = 0; i < ntohs(hdr->arcount); i++) {
    1566:	2685                	addiw	a3,a3,1
    1568:	fab6cfe3          	blt	a3,a1,1526 <dns_rep+0x2d4>
  if (len != cc) {
    156c:	049a9a63          	bne	s5,s1,15c0 <dns_rep+0x36e>
  if (!record) {
    1570:	060c0963          	beqz	s8,15e2 <dns_rep+0x390>
    1574:	74a6                	ld	s1,104(sp)
    1576:	7906                	ld	s2,96(sp)
    1578:	69e6                	ld	s3,88(sp)
    157a:	6a46                	ld	s4,80(sp)
    157c:	6aa6                	ld	s5,72(sp)
    157e:	bbf5                	j	137a <dns_rep+0x128>
  int record = 0;
    1580:	4c01                	li	s8,0
    1582:	b741                	j	1502 <dns_rep+0x2b0>
      printf("FAILED dns: invalid name for EDNS\n");
    1584:	00002517          	auipc	a0,0x2
    1588:	99450513          	addi	a0,a0,-1644 # 2f18 <malloc+0x954>
    158c:	00001097          	auipc	ra,0x1
    1590:	f80080e7          	jalr	-128(ra) # 250c <printf>
      return 0;
    1594:	4c01                	li	s8,0
    1596:	74a6                	ld	s1,104(sp)
    1598:	7906                	ld	s2,96(sp)
    159a:	69e6                	ld	s3,88(sp)
    159c:	6a46                	ld	s4,80(sp)
    159e:	6aa6                	ld	s5,72(sp)
    15a0:	bbe9                	j	137a <dns_rep+0x128>
      printf("FAILED dns: invalid type for EDNS\n");
    15a2:	00002517          	auipc	a0,0x2
    15a6:	99e50513          	addi	a0,a0,-1634 # 2f40 <malloc+0x97c>
    15aa:	00001097          	auipc	ra,0x1
    15ae:	f62080e7          	jalr	-158(ra) # 250c <printf>
      return 0;
    15b2:	4c01                	li	s8,0
    15b4:	74a6                	ld	s1,104(sp)
    15b6:	7906                	ld	s2,96(sp)
    15b8:	69e6                	ld	s3,88(sp)
    15ba:	6a46                	ld	s4,80(sp)
    15bc:	6aa6                	ld	s5,72(sp)
    15be:	bb75                	j	137a <dns_rep+0x128>
    printf("FAILED dns: processed %d data bytes but received %d\n", len, cc);
    15c0:	8656                	mv	a2,s5
    15c2:	85a6                	mv	a1,s1
    15c4:	00002517          	auipc	a0,0x2
    15c8:	9a450513          	addi	a0,a0,-1628 # 2f68 <malloc+0x9a4>
    15cc:	00001097          	auipc	ra,0x1
    15d0:	f40080e7          	jalr	-192(ra) # 250c <printf>
    return 0;
    15d4:	4c01                	li	s8,0
    15d6:	74a6                	ld	s1,104(sp)
    15d8:	7906                	ld	s2,96(sp)
    15da:	69e6                	ld	s3,88(sp)
    15dc:	6a46                	ld	s4,80(sp)
    15de:	6aa6                	ld	s5,72(sp)
    15e0:	bb69                	j	137a <dns_rep+0x128>
    printf("FAILED dns: didn't receive an arecord\n");
    15e2:	00002517          	auipc	a0,0x2
    15e6:	9be50513          	addi	a0,a0,-1602 # 2fa0 <malloc+0x9dc>
    15ea:	00001097          	auipc	ra,0x1
    15ee:	f22080e7          	jalr	-222(ra) # 250c <printf>
    15f2:	74a6                	ld	s1,104(sp)
    15f4:	7906                	ld	s2,96(sp)
    15f6:	69e6                	ld	s3,88(sp)
    15f8:	6a46                	ld	s4,80(sp)
    15fa:	6aa6                	ld	s5,72(sp)
    return 0;
    15fc:	bbbd                	j	137a <dns_rep+0x128>

00000000000015fe <dns>:

int dns() {
    15fe:	1101                	addi	sp,sp,-32
    1600:	ec06                	sd	ra,24(sp)
    1602:	e822                	sd	s0,16(sp)
    1604:	e426                	sd	s1,8(sp)
    1606:	1000                	addi	s0,sp,32
    1608:	82010113          	addi	sp,sp,-2016
  uint8 obuf[N];
  uint8 ibuf[N];
  uint32 dst;
  int len;

  printf("dns: starting\n");
    160c:	00002517          	auipc	a0,0x2
    1610:	9bc50513          	addi	a0,a0,-1604 # 2fc8 <malloc+0xa04>
    1614:	00001097          	auipc	ra,0x1
    1618:	ef8080e7          	jalr	-264(ra) # 250c <printf>

  memset(obuf, 0, N);
    161c:	3e800613          	li	a2,1000
    1620:	4581                	li	a1,0
    1622:	bf840513          	addi	a0,s0,-1032
    1626:	00001097          	auipc	ra,0x1
    162a:	964080e7          	jalr	-1692(ra) # 1f8a <memset>
  memset(ibuf, 0, N);
    162e:	3e800613          	li	a2,1000
    1632:	4581                	li	a1,0
    1634:	81040513          	addi	a0,s0,-2032
    1638:	00001097          	auipc	ra,0x1
    163c:	952080e7          	jalr	-1710(ra) # 1f8a <memset>

  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  len = dns_req(obuf);
    1640:	bf840513          	addi	a0,s0,-1032
    1644:	00000097          	auipc	ra,0x0
    1648:	b80080e7          	jalr	-1152(ra) # 11c4 <dns_req>
    164c:	84aa                	mv	s1,a0

  bind(2011);
    164e:	7db00513          	li	a0,2011
    1652:	00001097          	auipc	ra,0x1
    1656:	bd2080e7          	jalr	-1070(ra) # 2224 <bind>

  if (send(2011, dst, 53, (char *)obuf, len) < 0) {
    165a:	0004871b          	sext.w	a4,s1
    165e:	bf840693          	addi	a3,s0,-1032
    1662:	03500613          	li	a2,53
    1666:	080815b7          	lui	a1,0x8081
    166a:	80858593          	addi	a1,a1,-2040 # 8080808 <base+0x807c5f8>
    166e:	7db00513          	li	a0,2011
    1672:	00001097          	auipc	ra,0x1
    1676:	bc2080e7          	jalr	-1086(ra) # 2234 <send>
    167a:	04054863          	bltz	a0,16ca <dns+0xcc>
    return 0;
  }

  uint32 src;
  uint16 sport;
  int cc = recv(2011, &src, &sport, (char *)ibuf, sizeof(ibuf));
    167e:	3e800713          	li	a4,1000
    1682:	81040693          	addi	a3,s0,-2032
    1686:	80a40613          	addi	a2,s0,-2038
    168a:	80c40593          	addi	a1,s0,-2036
    168e:	7db00513          	li	a0,2011
    1692:	00001097          	auipc	ra,0x1
    1696:	baa080e7          	jalr	-1110(ra) # 223c <recv>
    169a:	84aa                	mv	s1,a0
  if (cc < 0) {
    169c:	04054163          	bltz	a0,16de <dns+0xe0>
    printf("FAILED dns: recv() failed %d\n", cc);
    return 0;
  }

  unbind(2011);
    16a0:	7db00513          	li	a0,2011
    16a4:	00001097          	auipc	ra,0x1
    16a8:	b88080e7          	jalr	-1144(ra) # 222c <unbind>

  if (dns_rep(ibuf, cc)) {
    16ac:	85a6                	mv	a1,s1
    16ae:	81040513          	addi	a0,s0,-2032
    16b2:	00000097          	auipc	ra,0x0
    16b6:	ba0080e7          	jalr	-1120(ra) # 1252 <dns_rep>
    16ba:	ed0d                	bnez	a0,16f4 <dns+0xf6>
    printf("dns: OK\n");
    return 1;
  } else {
    return 0;
  }
}
    16bc:	7e010113          	addi	sp,sp,2016
    16c0:	60e2                	ld	ra,24(sp)
    16c2:	6442                	ld	s0,16(sp)
    16c4:	64a2                	ld	s1,8(sp)
    16c6:	6105                	addi	sp,sp,32
    16c8:	8082                	ret
    printf("FAILED dns: send() failed\n");
    16ca:	00002517          	auipc	a0,0x2
    16ce:	90e50513          	addi	a0,a0,-1778 # 2fd8 <malloc+0xa14>
    16d2:	00001097          	auipc	ra,0x1
    16d6:	e3a080e7          	jalr	-454(ra) # 250c <printf>
    return 0;
    16da:	4501                	li	a0,0
    16dc:	b7c5                	j	16bc <dns+0xbe>
    printf("FAILED dns: recv() failed %d\n", cc);
    16de:	85aa                	mv	a1,a0
    16e0:	00002517          	auipc	a0,0x2
    16e4:	91850513          	addi	a0,a0,-1768 # 2ff8 <malloc+0xa34>
    16e8:	00001097          	auipc	ra,0x1
    16ec:	e24080e7          	jalr	-476(ra) # 250c <printf>
    return 0;
    16f0:	4501                	li	a0,0
    16f2:	b7e9                	j	16bc <dns+0xbe>
    printf("dns: OK\n");
    16f4:	00002517          	auipc	a0,0x2
    16f8:	92450513          	addi	a0,a0,-1756 # 3018 <malloc+0xa54>
    16fc:	00001097          	auipc	ra,0x1
    1700:	e10080e7          	jalr	-496(ra) # 250c <printf>
    return 1;
    1704:	4505                	li	a0,1
    1706:	bf5d                	j	16bc <dns+0xbe>

0000000000001708 <usage>:

void usage() {
    1708:	1141                	addi	sp,sp,-16
    170a:	e406                	sd	ra,8(sp)
    170c:	e022                	sd	s0,0(sp)
    170e:	0800                	addi	s0,sp,16
  printf("Usage: nettest txone\n");
    1710:	00002517          	auipc	a0,0x2
    1714:	91850513          	addi	a0,a0,-1768 # 3028 <malloc+0xa64>
    1718:	00001097          	auipc	ra,0x1
    171c:	df4080e7          	jalr	-524(ra) # 250c <printf>
  printf("       nettest tx\n");
    1720:	00002517          	auipc	a0,0x2
    1724:	92050513          	addi	a0,a0,-1760 # 3040 <malloc+0xa7c>
    1728:	00001097          	auipc	ra,0x1
    172c:	de4080e7          	jalr	-540(ra) # 250c <printf>
  printf("       nettest rx\n");
    1730:	00002517          	auipc	a0,0x2
    1734:	92850513          	addi	a0,a0,-1752 # 3058 <malloc+0xa94>
    1738:	00001097          	auipc	ra,0x1
    173c:	dd4080e7          	jalr	-556(ra) # 250c <printf>
  printf("       nettest rx2\n");
    1740:	00002517          	auipc	a0,0x2
    1744:	93050513          	addi	a0,a0,-1744 # 3070 <malloc+0xaac>
    1748:	00001097          	auipc	ra,0x1
    174c:	dc4080e7          	jalr	-572(ra) # 250c <printf>
  printf("       nettest rxburst\n");
    1750:	00002517          	auipc	a0,0x2
    1754:	93850513          	addi	a0,a0,-1736 # 3088 <malloc+0xac4>
    1758:	00001097          	auipc	ra,0x1
    175c:	db4080e7          	jalr	-588(ra) # 250c <printf>
  printf("       nettest ping1\n");
    1760:	00002517          	auipc	a0,0x2
    1764:	94050513          	addi	a0,a0,-1728 # 30a0 <malloc+0xadc>
    1768:	00001097          	auipc	ra,0x1
    176c:	da4080e7          	jalr	-604(ra) # 250c <printf>
  printf("       nettest ping2\n");
    1770:	00002517          	auipc	a0,0x2
    1774:	94850513          	addi	a0,a0,-1720 # 30b8 <malloc+0xaf4>
    1778:	00001097          	auipc	ra,0x1
    177c:	d94080e7          	jalr	-620(ra) # 250c <printf>
  printf("       nettest ping3\n");
    1780:	00002517          	auipc	a0,0x2
    1784:	95050513          	addi	a0,a0,-1712 # 30d0 <malloc+0xb0c>
    1788:	00001097          	auipc	ra,0x1
    178c:	d84080e7          	jalr	-636(ra) # 250c <printf>
  printf("       nettest dns\n");
    1790:	00002517          	auipc	a0,0x2
    1794:	95850513          	addi	a0,a0,-1704 # 30e8 <malloc+0xb24>
    1798:	00001097          	auipc	ra,0x1
    179c:	d74080e7          	jalr	-652(ra) # 250c <printf>
  printf("       nettest grade\n");
    17a0:	00002517          	auipc	a0,0x2
    17a4:	96050513          	addi	a0,a0,-1696 # 3100 <malloc+0xb3c>
    17a8:	00001097          	auipc	ra,0x1
    17ac:	d64080e7          	jalr	-668(ra) # 250c <printf>
  printf("       nettest unbind\n");
    17b0:	00002517          	auipc	a0,0x2
    17b4:	96850513          	addi	a0,a0,-1688 # 3118 <malloc+0xb54>
    17b8:	00001097          	auipc	ra,0x1
    17bc:	d54080e7          	jalr	-684(ra) # 250c <printf>
  printf("       nettest allports\n");
    17c0:	00002517          	auipc	a0,0x2
    17c4:	97050513          	addi	a0,a0,-1680 # 3130 <malloc+0xb6c>
    17c8:	00001097          	auipc	ra,0x1
    17cc:	d44080e7          	jalr	-700(ra) # 250c <printf>
  exit(1);
    17d0:	4505                	li	a0,1
    17d2:	00001097          	auipc	ra,0x1
    17d6:	9b2080e7          	jalr	-1614(ra) # 2184 <exit>

00000000000017da <countfree>:
// use sbrk() to count how many free physical memory pages there are.
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree() {
    17da:	7139                	addi	sp,sp,-64
    17dc:	fc06                	sd	ra,56(sp)
    17de:	f822                	sd	s0,48(sp)
    17e0:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0) {
    17e2:	fc840513          	addi	a0,s0,-56
    17e6:	00001097          	auipc	ra,0x1
    17ea:	9ae080e7          	jalr	-1618(ra) # 2194 <pipe>
    17ee:	06054a63          	bltz	a0,1862 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    17f2:	00001097          	auipc	ra,0x1
    17f6:	98a080e7          	jalr	-1654(ra) # 217c <fork>

  if (pid < 0) {
    17fa:	08054463          	bltz	a0,1882 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0) {
    17fe:	e55d                	bnez	a0,18ac <countfree+0xd2>
    1800:	f426                	sd	s1,40(sp)
    1802:	f04a                	sd	s2,32(sp)
    1804:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    1806:	fc842503          	lw	a0,-56(s0)
    180a:	00001097          	auipc	ra,0x1
    180e:	9a2080e7          	jalr	-1630(ra) # 21ac <close>

    while (1) {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff) {
    1812:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    1814:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1) {
    1816:	00001997          	auipc	s3,0x1
    181a:	5b298993          	addi	s3,s3,1458 # 2dc8 <malloc+0x804>
      uint64 a = (uint64)sbrk(4096);
    181e:	6505                	lui	a0,0x1
    1820:	00001097          	auipc	ra,0x1
    1824:	9ec080e7          	jalr	-1556(ra) # 220c <sbrk>
      if (a == 0xffffffffffffffff) {
    1828:	07250d63          	beq	a0,s2,18a2 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    182c:	6785                	lui	a5,0x1
    182e:	97aa                	add	a5,a5,a0
    1830:	fe978fa3          	sb	s1,-1(a5) # fff <ping3+0x321>
      if (write(fds[1], "x", 1) != 1) {
    1834:	8626                	mv	a2,s1
    1836:	85ce                	mv	a1,s3
    1838:	fcc42503          	lw	a0,-52(s0)
    183c:	00001097          	auipc	ra,0x1
    1840:	968080e7          	jalr	-1688(ra) # 21a4 <write>
    1844:	fc950de3          	beq	a0,s1,181e <countfree+0x44>
        printf("write() failed in countfree()\n");
    1848:	00002517          	auipc	a0,0x2
    184c:	94850513          	addi	a0,a0,-1720 # 3190 <malloc+0xbcc>
    1850:	00001097          	auipc	ra,0x1
    1854:	cbc080e7          	jalr	-836(ra) # 250c <printf>
        exit(1);
    1858:	4505                	li	a0,1
    185a:	00001097          	auipc	ra,0x1
    185e:	92a080e7          	jalr	-1750(ra) # 2184 <exit>
    1862:	f426                	sd	s1,40(sp)
    1864:	f04a                	sd	s2,32(sp)
    1866:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    1868:	00002517          	auipc	a0,0x2
    186c:	8e850513          	addi	a0,a0,-1816 # 3150 <malloc+0xb8c>
    1870:	00001097          	auipc	ra,0x1
    1874:	c9c080e7          	jalr	-868(ra) # 250c <printf>
    exit(1);
    1878:	4505                	li	a0,1
    187a:	00001097          	auipc	ra,0x1
    187e:	90a080e7          	jalr	-1782(ra) # 2184 <exit>
    1882:	f426                	sd	s1,40(sp)
    1884:	f04a                	sd	s2,32(sp)
    1886:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    1888:	00002517          	auipc	a0,0x2
    188c:	8e850513          	addi	a0,a0,-1816 # 3170 <malloc+0xbac>
    1890:	00001097          	auipc	ra,0x1
    1894:	c7c080e7          	jalr	-900(ra) # 250c <printf>
    exit(1);
    1898:	4505                	li	a0,1
    189a:	00001097          	auipc	ra,0x1
    189e:	8ea080e7          	jalr	-1814(ra) # 2184 <exit>
      }
    }

    exit(0);
    18a2:	4501                	li	a0,0
    18a4:	00001097          	auipc	ra,0x1
    18a8:	8e0080e7          	jalr	-1824(ra) # 2184 <exit>
    18ac:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    18ae:	fcc42503          	lw	a0,-52(s0)
    18b2:	00001097          	auipc	ra,0x1
    18b6:	8fa080e7          	jalr	-1798(ra) # 21ac <close>

  int n = 0;
    18ba:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    18bc:	4605                	li	a2,1
    18be:	fc740593          	addi	a1,s0,-57
    18c2:	fc842503          	lw	a0,-56(s0)
    18c6:	00001097          	auipc	ra,0x1
    18ca:	8d6080e7          	jalr	-1834(ra) # 219c <read>
    if (cc < 0) {
    18ce:	00054563          	bltz	a0,18d8 <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0) break;
    18d2:	c115                	beqz	a0,18f6 <countfree+0x11c>
    n += 1;
    18d4:	2485                	addiw	s1,s1,1
  while (1) {
    18d6:	b7dd                	j	18bc <countfree+0xe2>
    18d8:	f04a                	sd	s2,32(sp)
    18da:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    18dc:	00002517          	auipc	a0,0x2
    18e0:	8d450513          	addi	a0,a0,-1836 # 31b0 <malloc+0xbec>
    18e4:	00001097          	auipc	ra,0x1
    18e8:	c28080e7          	jalr	-984(ra) # 250c <printf>
      exit(1);
    18ec:	4505                	li	a0,1
    18ee:	00001097          	auipc	ra,0x1
    18f2:	896080e7          	jalr	-1898(ra) # 2184 <exit>
  }

  close(fds[0]);
    18f6:	fc842503          	lw	a0,-56(s0)
    18fa:	00001097          	auipc	ra,0x1
    18fe:	8b2080e7          	jalr	-1870(ra) # 21ac <close>
  wait((int *)0);
    1902:	4501                	li	a0,0
    1904:	00001097          	auipc	ra,0x1
    1908:	888080e7          	jalr	-1912(ra) # 218c <wait>

  return n;
}
    190c:	8526                	mv	a0,s1
    190e:	74a2                	ld	s1,40(sp)
    1910:	70e2                	ld	ra,56(sp)
    1912:	7442                	ld	s0,48(sp)
    1914:	6121                	addi	sp,sp,64
    1916:	8082                	ret

0000000000001918 <manyports>:

int manyports(int free1) {
    1918:	7139                	addi	sp,sp,-64
    191a:	fc06                	sd	ra,56(sp)
    191c:	f822                	sd	s0,48(sp)
    191e:	f426                	sd	s1,40(sp)
    1920:	f04a                	sd	s2,32(sp)
    1922:	e456                	sd	s5,8(sp)
    1924:	e05a                	sd	s6,0(sp)
    1926:	0080                	addi	s0,sp,64
    1928:	8aaa                	mv	s5,a0
#define CNT_PORTS 100
#define START_PORT 1001

  int max_port = START_PORT;
    192a:	3e900493          	li	s1,1001
  int ok = 1;

  for (int i = 0; i < CNT_PORTS; ++i) {
    192e:	44d00913          	li	s2,1101
    int br = bind(max_port);
    1932:	03049513          	slli	a0,s1,0x30
    1936:	9141                	srli	a0,a0,0x30
    1938:	00001097          	auipc	ra,0x1
    193c:	8ec080e7          	jalr	-1812(ra) # 2224 <bind>
    if (br != 0) {
    1940:	e901                	bnez	a0,1950 <manyports+0x38>
      printf("FAILED manyports: bind failed for %d : %d\n", max_port, br);
      ok = 0;
      break;
    }
    max_port = START_PORT + i + 1;
    1942:	2485                	addiw	s1,s1,1
  for (int i = 0; i < CNT_PORTS; ++i) {
    1944:	ff2497e3          	bne	s1,s2,1932 <manyports+0x1a>
    1948:	ec4e                	sd	s3,24(sp)
    194a:	e852                	sd	s4,16(sp)
  int ok = 1;
    194c:	4b05                	li	s6,1
    194e:	a015                	j	1972 <manyports+0x5a>
      printf("FAILED manyports: bind failed for %d : %d\n", max_port, br);
    1950:	862a                	mv	a2,a0
    1952:	85a6                	mv	a1,s1
    1954:	00002517          	auipc	a0,0x2
    1958:	87c50513          	addi	a0,a0,-1924 # 31d0 <malloc+0xc0c>
    195c:	00001097          	auipc	ra,0x1
    1960:	bb0080e7          	jalr	-1104(ra) # 250c <printf>
  }

  char *buf = "ping";
  for (int i = START_PORT; i < max_port; ++i) {
    1964:	3e900793          	li	a5,1001
    1968:	4b01                	li	s6,0
    196a:	0497dd63          	bge	a5,s1,19c4 <manyports+0xac>
    196e:	ec4e                	sd	s3,24(sp)
    1970:	e852                	sd	s4,16(sp)
    1972:	3e900913          	li	s2,1001
    if (send(1999, 0x0A000205, i, buf, 5) < 0) {  // 10.0.2.5
    1976:	00002a17          	auipc	s4,0x2
    197a:	88aa0a13          	addi	s4,s4,-1910 # 3200 <malloc+0xc3c>
    197e:	0a0009b7          	lui	s3,0xa000
    1982:	20598993          	addi	s3,s3,517 # a000205 <base+0x9ffbff5>
    1986:	4715                	li	a4,5
    1988:	86d2                	mv	a3,s4
    198a:	03091613          	slli	a2,s2,0x30
    198e:	9241                	srli	a2,a2,0x30
    1990:	85ce                	mv	a1,s3
    1992:	7cf00513          	li	a0,1999
    1996:	00001097          	auipc	ra,0x1
    199a:	89e080e7          	jalr	-1890(ra) # 2234 <send>
    199e:	00054863          	bltz	a0,19ae <manyports+0x96>
  for (int i = START_PORT; i < max_port; ++i) {
    19a2:	2905                	addiw	s2,s2,1
    19a4:	ff2491e3          	bne	s1,s2,1986 <manyports+0x6e>
    19a8:	69e2                	ld	s3,24(sp)
    19aa:	6a42                	ld	s4,16(sp)
    19ac:	a821                	j	19c4 <manyports+0xac>
      printf("FAILED manyports: send() failed for port %d\n", i);
    19ae:	85ca                	mv	a1,s2
    19b0:	00002517          	auipc	a0,0x2
    19b4:	85850513          	addi	a0,a0,-1960 # 3208 <malloc+0xc44>
    19b8:	00001097          	auipc	ra,0x1
    19bc:	b54080e7          	jalr	-1196(ra) # 250c <printf>
      break;
    19c0:	69e2                	ld	s3,24(sp)
    19c2:	6a42                	ld	s4,16(sp)
    }
  }

  int free2 = countfree();
    19c4:	00000097          	auipc	ra,0x0
    19c8:	e16080e7          	jalr	-490(ra) # 17da <countfree>
  if (free2 < free1 - CNT_PORTS / 5) {
    19cc:	feca879b          	addiw	a5,s5,-20
    19d0:	04f55763          	bge	a0,a5,1a1e <manyports+0x106>
    printf("FAILED manyports: lost too many free pages %d > %d\n",
    19d4:	4651                	li	a2,20
    19d6:	40aa85bb          	subw	a1,s5,a0
    19da:	00002517          	auipc	a0,0x2
    19de:	85e50513          	addi	a0,a0,-1954 # 3238 <malloc+0xc74>
    19e2:	00001097          	auipc	ra,0x1
    19e6:	b2a080e7          	jalr	-1238(ra) # 250c <printf>
           free1 - free2, CNT_PORTS / 5);
    ok = 0;
    19ea:	4b01                	li	s6,0
  } else {
    printf("manyports: OK\n");
  }

  for (int i = START_PORT; i < max_port; ++i) {
    19ec:	3e900793          	li	a5,1001
    19f0:	0097de63          	bge	a5,s1,1a0c <manyports+0xf4>
    19f4:	3e900913          	li	s2,1001
    unbind(i);
    19f8:	03091513          	slli	a0,s2,0x30
    19fc:	9141                	srli	a0,a0,0x30
    19fe:	00001097          	auipc	ra,0x1
    1a02:	82e080e7          	jalr	-2002(ra) # 222c <unbind>
  for (int i = START_PORT; i < max_port; ++i) {
    1a06:	2905                	addiw	s2,s2,1
    1a08:	ff2498e3          	bne	s1,s2,19f8 <manyports+0xe0>
  }
  return ok;
}
    1a0c:	855a                	mv	a0,s6
    1a0e:	70e2                	ld	ra,56(sp)
    1a10:	7442                	ld	s0,48(sp)
    1a12:	74a2                	ld	s1,40(sp)
    1a14:	7902                	ld	s2,32(sp)
    1a16:	6aa2                	ld	s5,8(sp)
    1a18:	6b02                	ld	s6,0(sp)
    1a1a:	6121                	addi	sp,sp,64
    1a1c:	8082                	ret
    printf("manyports: OK\n");
    1a1e:	00002517          	auipc	a0,0x2
    1a22:	85250513          	addi	a0,a0,-1966 # 3270 <malloc+0xcac>
    1a26:	00001097          	auipc	ra,0x1
    1a2a:	ae6080e7          	jalr	-1306(ra) # 250c <printf>
    1a2e:	bf7d                	j	19ec <manyports+0xd4>

0000000000001a30 <main>:

int main(int argc, char *argv[]) {
    1a30:	7179                	addi	sp,sp,-48
    1a32:	f406                	sd	ra,40(sp)
    1a34:	f022                	sd	s0,32(sp)
    1a36:	1800                	addi	s0,sp,48
  if (argc != 2) usage();
    1a38:	4789                	li	a5,2
    1a3a:	00f50963          	beq	a0,a5,1a4c <main+0x1c>
    1a3e:	ec26                	sd	s1,24(sp)
    1a40:	e84a                	sd	s2,16(sp)
    1a42:	e44e                	sd	s3,8(sp)
    1a44:	00000097          	auipc	ra,0x0
    1a48:	cc4080e7          	jalr	-828(ra) # 1708 <usage>
    1a4c:	ec26                	sd	s1,24(sp)
    1a4e:	e84a                	sd	s2,16(sp)
    1a50:	e44e                	sd	s3,8(sp)
    1a52:	84ae                	mv	s1,a1

  if (strcmp(argv[1], "txone") == 0) {
    1a54:	00002597          	auipc	a1,0x2
    1a58:	82c58593          	addi	a1,a1,-2004 # 3280 <malloc+0xcbc>
    1a5c:	6488                	ld	a0,8(s1)
    1a5e:	00000097          	auipc	ra,0x0
    1a62:	4d6080e7          	jalr	1238(ra) # 1f34 <strcmp>
    1a66:	e911                	bnez	a0,1a7a <main+0x4a>
    txone();
    1a68:	ffffe097          	auipc	ra,0xffffe
    1a6c:	598080e7          	jalr	1432(ra) # 0 <txone>
    }
  } else {
    usage();
  }

  exit(0);
    1a70:	4501                	li	a0,0
    1a72:	00000097          	auipc	ra,0x0
    1a76:	712080e7          	jalr	1810(ra) # 2184 <exit>
  } else if (strcmp(argv[1], "rx") == 0 || strcmp(argv[1], "rxburst") == 0) {
    1a7a:	00002597          	auipc	a1,0x2
    1a7e:	80e58593          	addi	a1,a1,-2034 # 3288 <malloc+0xcc4>
    1a82:	6488                	ld	a0,8(s1)
    1a84:	00000097          	auipc	ra,0x0
    1a88:	4b0080e7          	jalr	1200(ra) # 1f34 <strcmp>
    1a8c:	c919                	beqz	a0,1aa2 <main+0x72>
    1a8e:	00002597          	auipc	a1,0x2
    1a92:	80258593          	addi	a1,a1,-2046 # 3290 <malloc+0xccc>
    1a96:	6488                	ld	a0,8(s1)
    1a98:	00000097          	auipc	ra,0x0
    1a9c:	49c080e7          	jalr	1180(ra) # 1f34 <strcmp>
    1aa0:	e519                	bnez	a0,1aae <main+0x7e>
    rx(argv[1]);
    1aa2:	6488                	ld	a0,8(s1)
    1aa4:	ffffe097          	auipc	ra,0xffffe
    1aa8:	5e0080e7          	jalr	1504(ra) # 84 <rx>
    1aac:	b7d1                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "rx2") == 0) {
    1aae:	00001597          	auipc	a1,0x1
    1ab2:	7ea58593          	addi	a1,a1,2026 # 3298 <malloc+0xcd4>
    1ab6:	6488                	ld	a0,8(s1)
    1ab8:	00000097          	auipc	ra,0x0
    1abc:	47c080e7          	jalr	1148(ra) # 1f34 <strcmp>
    1ac0:	e911                	bnez	a0,1ad4 <main+0xa4>
    rx2(FWDPORT1, FWDPORT2);
    1ac2:	7d100593          	li	a1,2001
    1ac6:	7d000513          	li	a0,2000
    1aca:	fffff097          	auipc	ra,0xfffff
    1ace:	818080e7          	jalr	-2024(ra) # 2e2 <rx2>
    1ad2:	bf79                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "tx") == 0) {
    1ad4:	00001597          	auipc	a1,0x1
    1ad8:	7cc58593          	addi	a1,a1,1996 # 32a0 <malloc+0xcdc>
    1adc:	6488                	ld	a0,8(s1)
    1ade:	00000097          	auipc	ra,0x0
    1ae2:	456080e7          	jalr	1110(ra) # 1f34 <strcmp>
    1ae6:	e511                	bnez	a0,1af2 <main+0xc2>
    tx();
    1ae8:	fffff097          	auipc	ra,0xfffff
    1aec:	bfe080e7          	jalr	-1026(ra) # 6e6 <tx>
    1af0:	b741                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "ping0") == 0) {
    1af2:	00001597          	auipc	a1,0x1
    1af6:	f0658593          	addi	a1,a1,-250 # 29f8 <malloc+0x434>
    1afa:	6488                	ld	a0,8(s1)
    1afc:	00000097          	auipc	ra,0x0
    1b00:	438080e7          	jalr	1080(ra) # 1f34 <strcmp>
    1b04:	e511                	bnez	a0,1b10 <main+0xe0>
    ping0();
    1b06:	fffff097          	auipc	ra,0xfffff
    1b0a:	c76080e7          	jalr	-906(ra) # 77c <ping0>
    1b0e:	b78d                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "ping1") == 0) {
    1b10:	00001597          	auipc	a1,0x1
    1b14:	79858593          	addi	a1,a1,1944 # 32a8 <malloc+0xce4>
    1b18:	6488                	ld	a0,8(s1)
    1b1a:	00000097          	auipc	ra,0x0
    1b1e:	41a080e7          	jalr	1050(ra) # 1f34 <strcmp>
    1b22:	e511                	bnez	a0,1b2e <main+0xfe>
    ping1();
    1b24:	fffff097          	auipc	ra,0xfffff
    1b28:	de8080e7          	jalr	-536(ra) # 90c <ping1>
    1b2c:	b791                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "ping2") == 0) {
    1b2e:	00001597          	auipc	a1,0x1
    1b32:	78258593          	addi	a1,a1,1922 # 32b0 <malloc+0xcec>
    1b36:	6488                	ld	a0,8(s1)
    1b38:	00000097          	auipc	ra,0x0
    1b3c:	3fc080e7          	jalr	1020(ra) # 1f34 <strcmp>
    1b40:	e511                	bnez	a0,1b4c <main+0x11c>
    ping2();
    1b42:	fffff097          	auipc	ra,0xfffff
    1b46:	f62080e7          	jalr	-158(ra) # aa4 <ping2>
    1b4a:	b71d                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "ping3") == 0) {
    1b4c:	00001597          	auipc	a1,0x1
    1b50:	76c58593          	addi	a1,a1,1900 # 32b8 <malloc+0xcf4>
    1b54:	6488                	ld	a0,8(s1)
    1b56:	00000097          	auipc	ra,0x0
    1b5a:	3de080e7          	jalr	990(ra) # 1f34 <strcmp>
    1b5e:	e511                	bnez	a0,1b6a <main+0x13a>
    ping3();
    1b60:	fffff097          	auipc	ra,0xfffff
    1b64:	17e080e7          	jalr	382(ra) # cde <ping3>
    1b68:	b721                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "grade") == 0) {
    1b6a:	00001597          	auipc	a1,0x1
    1b6e:	75658593          	addi	a1,a1,1878 # 32c0 <malloc+0xcfc>
    1b72:	6488                	ld	a0,8(s1)
    1b74:	00000097          	auipc	ra,0x0
    1b78:	3c0080e7          	jalr	960(ra) # 1f34 <strcmp>
    1b7c:	892a                	mv	s2,a0
    1b7e:	14051363          	bnez	a0,1cc4 <main+0x294>
    int free0 = countfree();
    1b82:	00000097          	auipc	ra,0x0
    1b86:	c58080e7          	jalr	-936(ra) # 17da <countfree>
    1b8a:	84aa                	mv	s1,a0
    sleep(0.5);
    1b8c:	4501                	li	a0,0
    1b8e:	00000097          	auipc	ra,0x0
    1b92:	686080e7          	jalr	1670(ra) # 2214 <sleep>
    ok = ok && txone();
    1b96:	ffffe097          	auipc	ra,0xffffe
    1b9a:	46a080e7          	jalr	1130(ra) # 0 <txone>
    1b9e:	89aa                	mv	s3,a0
    sleep(0.5);
    1ba0:	4501                	li	a0,0
    1ba2:	00000097          	auipc	ra,0x0
    1ba6:	672080e7          	jalr	1650(ra) # 2214 <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1baa:	06099d63          	bnez	s3,1c24 <main+0x1f4>
    sleep(0.5);
    1bae:	4501                	li	a0,0
    1bb0:	00000097          	auipc	ra,0x0
    1bb4:	664080e7          	jalr	1636(ra) # 2214 <sleep>
    sleep(0.5);
    1bb8:	4501                	li	a0,0
    1bba:	00000097          	auipc	ra,0x0
    1bbe:	65a080e7          	jalr	1626(ra) # 2214 <sleep>
    sleep(0.5);
    1bc2:	4501                	li	a0,0
    1bc4:	00000097          	auipc	ra,0x0
    1bc8:	650080e7          	jalr	1616(ra) # 2214 <sleep>
    sleep(0.5);
    1bcc:	4501                	li	a0,0
    1bce:	00000097          	auipc	ra,0x0
    1bd2:	646080e7          	jalr	1606(ra) # 2214 <sleep>
    sleep(0.5);
    1bd6:	4501                	li	a0,0
    1bd8:	00000097          	auipc	ra,0x0
    1bdc:	63c080e7          	jalr	1596(ra) # 2214 <sleep>
    sleep(4);
    1be0:	4511                	li	a0,4
    1be2:	00000097          	auipc	ra,0x0
    1be6:	632080e7          	jalr	1586(ra) # 2214 <sleep>
    if ((free1 = countfree()) + 16 + 16 + 3 < free0) {
    1bea:	00000097          	auipc	ra,0x0
    1bee:	bf0080e7          	jalr	-1040(ra) # 17da <countfree>
    1bf2:	85aa                	mv	a1,a0
    1bf4:	0235079b          	addiw	a5,a0,35
    1bf8:	0a97dd63          	bge	a5,s1,1cb2 <main+0x282>
      printf("lazyport: FAILED -- lost too many free pages %d (out of %d)\n",
    1bfc:	8626                	mv	a2,s1
    1bfe:	00001517          	auipc	a0,0x1
    1c02:	6ca50513          	addi	a0,a0,1738 # 32c8 <malloc+0xd04>
    1c06:	00001097          	auipc	ra,0x1
    1c0a:	906080e7          	jalr	-1786(ra) # 250c <printf>
    if (ok) {
    1c0e:	e60901e3          	beqz	s2,1a70 <main+0x40>
      printf("Tests OK\n");
    1c12:	00001517          	auipc	a0,0x1
    1c16:	70650513          	addi	a0,a0,1798 # 3318 <malloc+0xd54>
    1c1a:	00001097          	auipc	ra,0x1
    1c1e:	8f2080e7          	jalr	-1806(ra) # 250c <printf>
    1c22:	b5b9                	j	1a70 <main+0x40>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1c24:	7d100593          	li	a1,2001
    1c28:	7d000513          	li	a0,2000
    1c2c:	ffffe097          	auipc	ra,0xffffe
    1c30:	6b6080e7          	jalr	1718(ra) # 2e2 <rx2>
    1c34:	89aa                	mv	s3,a0
    sleep(0.5);
    1c36:	4501                	li	a0,0
    1c38:	00000097          	auipc	ra,0x0
    1c3c:	5dc080e7          	jalr	1500(ra) # 2214 <sleep>
    ok = ok && ping0();
    1c40:	f6098ce3          	beqz	s3,1bb8 <main+0x188>
    1c44:	fffff097          	auipc	ra,0xfffff
    1c48:	b38080e7          	jalr	-1224(ra) # 77c <ping0>
    1c4c:	89aa                	mv	s3,a0
    sleep(0.5);
    1c4e:	4501                	li	a0,0
    1c50:	00000097          	auipc	ra,0x0
    1c54:	5c4080e7          	jalr	1476(ra) # 2214 <sleep>
    ok = ok && ping1();
    1c58:	f60985e3          	beqz	s3,1bc2 <main+0x192>
    1c5c:	fffff097          	auipc	ra,0xfffff
    1c60:	cb0080e7          	jalr	-848(ra) # 90c <ping1>
    1c64:	89aa                	mv	s3,a0
    sleep(0.5);
    1c66:	4501                	li	a0,0
    1c68:	00000097          	auipc	ra,0x0
    1c6c:	5ac080e7          	jalr	1452(ra) # 2214 <sleep>
    ok = ok && ping2();
    1c70:	f4098ee3          	beqz	s3,1bcc <main+0x19c>
    1c74:	fffff097          	auipc	ra,0xfffff
    1c78:	e30080e7          	jalr	-464(ra) # aa4 <ping2>
    1c7c:	89aa                	mv	s3,a0
    sleep(0.5);
    1c7e:	4501                	li	a0,0
    1c80:	00000097          	auipc	ra,0x0
    1c84:	594080e7          	jalr	1428(ra) # 2214 <sleep>
    ok = ok && ping3();
    1c88:	f40987e3          	beqz	s3,1bd6 <main+0x1a6>
    1c8c:	fffff097          	auipc	ra,0xfffff
    1c90:	052080e7          	jalr	82(ra) # cde <ping3>
    1c94:	892a                	mv	s2,a0
    sleep(0.5);
    1c96:	4501                	li	a0,0
    1c98:	00000097          	auipc	ra,0x0
    1c9c:	57c080e7          	jalr	1404(ra) # 2214 <sleep>
    ok = ok && dns();
    1ca0:	f40900e3          	beqz	s2,1be0 <main+0x1b0>
    1ca4:	00000097          	auipc	ra,0x0
    1ca8:	95a080e7          	jalr	-1702(ra) # 15fe <dns>
    1cac:	00a03933          	snez	s2,a0
    1cb0:	bf05                	j	1be0 <main+0x1b0>
      printf("free: OK\n");
    1cb2:	00001517          	auipc	a0,0x1
    1cb6:	65650513          	addi	a0,a0,1622 # 3308 <malloc+0xd44>
    1cba:	00001097          	auipc	ra,0x1
    1cbe:	852080e7          	jalr	-1966(ra) # 250c <printf>
    1cc2:	b7b1                	j	1c0e <main+0x1de>
  } else if (strcmp(argv[1], "dns") == 0) {
    1cc4:	00001597          	auipc	a1,0x1
    1cc8:	66458593          	addi	a1,a1,1636 # 3328 <malloc+0xd64>
    1ccc:	6488                	ld	a0,8(s1)
    1cce:	00000097          	auipc	ra,0x0
    1cd2:	266080e7          	jalr	614(ra) # 1f34 <strcmp>
    1cd6:	e511                	bnez	a0,1ce2 <main+0x2b2>
    dns();
    1cd8:	00000097          	auipc	ra,0x0
    1cdc:	926080e7          	jalr	-1754(ra) # 15fe <dns>
    1ce0:	bb41                	j	1a70 <main+0x40>
  } else if (strcmp(argv[1], "unbind") == 0) {
    1ce2:	00001597          	auipc	a1,0x1
    1ce6:	64e58593          	addi	a1,a1,1614 # 3330 <malloc+0xd6c>
    1cea:	6488                	ld	a0,8(s1)
    1cec:	00000097          	auipc	ra,0x0
    1cf0:	248080e7          	jalr	584(ra) # 1f34 <strcmp>
    1cf4:	892a                	mv	s2,a0
    1cf6:	e17d                	bnez	a0,1ddc <main+0x3ac>
    int free0 = countfree();
    1cf8:	00000097          	auipc	ra,0x0
    1cfc:	ae2080e7          	jalr	-1310(ra) # 17da <countfree>
    1d00:	84aa                	mv	s1,a0
    sleep(0.5);
    1d02:	4501                	li	a0,0
    1d04:	00000097          	auipc	ra,0x0
    1d08:	510080e7          	jalr	1296(ra) # 2214 <sleep>
    ok = ok && txone();
    1d0c:	ffffe097          	auipc	ra,0xffffe
    1d10:	2f4080e7          	jalr	756(ra) # 0 <txone>
    1d14:	89aa                	mv	s3,a0
    sleep(0.5);
    1d16:	4501                	li	a0,0
    1d18:	00000097          	auipc	ra,0x0
    1d1c:	4fc080e7          	jalr	1276(ra) # 2214 <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1d20:	04099e63          	bnez	s3,1d7c <main+0x34c>
    sleep(0.5);
    1d24:	4501                	li	a0,0
    1d26:	00000097          	auipc	ra,0x0
    1d2a:	4ee080e7          	jalr	1262(ra) # 2214 <sleep>
    sleep(0.5);
    1d2e:	4501                	li	a0,0
    1d30:	00000097          	auipc	ra,0x0
    1d34:	4e4080e7          	jalr	1252(ra) # 2214 <sleep>
    sleep(1);
    1d38:	4505                	li	a0,1
    1d3a:	00000097          	auipc	ra,0x0
    1d3e:	4da080e7          	jalr	1242(ra) # 2214 <sleep>
    if ((free1 = countfree()) + 16 + 3 + 3 < free0) {
    1d42:	00000097          	auipc	ra,0x0
    1d46:	a98080e7          	jalr	-1384(ra) # 17da <countfree>
    1d4a:	85aa                	mv	a1,a0
    1d4c:	0165079b          	addiw	a5,a0,22
    1d50:	0697dd63          	bge	a5,s1,1dca <main+0x39a>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1,
    1d54:	8626                	mv	a2,s1
    1d56:	00001517          	auipc	a0,0x1
    1d5a:	5e250513          	addi	a0,a0,1506 # 3338 <malloc+0xd74>
    1d5e:	00000097          	auipc	ra,0x0
    1d62:	7ae080e7          	jalr	1966(ra) # 250c <printf>
    if (ok) {
    1d66:	d00905e3          	beqz	s2,1a70 <main+0x40>
      printf("Tests OK\n");
    1d6a:	00001517          	auipc	a0,0x1
    1d6e:	5ae50513          	addi	a0,a0,1454 # 3318 <malloc+0xd54>
    1d72:	00000097          	auipc	ra,0x0
    1d76:	79a080e7          	jalr	1946(ra) # 250c <printf>
    1d7a:	b9dd                	j	1a70 <main+0x40>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1d7c:	7d100593          	li	a1,2001
    1d80:	7d000513          	li	a0,2000
    1d84:	ffffe097          	auipc	ra,0xffffe
    1d88:	55e080e7          	jalr	1374(ra) # 2e2 <rx2>
    1d8c:	89aa                	mv	s3,a0
    sleep(0.5);
    1d8e:	4501                	li	a0,0
    1d90:	00000097          	auipc	ra,0x0
    1d94:	484080e7          	jalr	1156(ra) # 2214 <sleep>
    ok = ok && txone();
    1d98:	f8098be3          	beqz	s3,1d2e <main+0x2fe>
    1d9c:	ffffe097          	auipc	ra,0xffffe
    1da0:	264080e7          	jalr	612(ra) # 0 <txone>
    1da4:	892a                	mv	s2,a0
    sleep(0.5);
    1da6:	4501                	li	a0,0
    1da8:	00000097          	auipc	ra,0x0
    1dac:	46c080e7          	jalr	1132(ra) # 2214 <sleep>
    ok = ok && rx2(FWDPORT1, FWDPORT2);
    1db0:	f80904e3          	beqz	s2,1d38 <main+0x308>
    1db4:	7d100593          	li	a1,2001
    1db8:	7d000513          	li	a0,2000
    1dbc:	ffffe097          	auipc	ra,0xffffe
    1dc0:	526080e7          	jalr	1318(ra) # 2e2 <rx2>
    1dc4:	00a03933          	snez	s2,a0
    1dc8:	bf85                	j	1d38 <main+0x308>
      printf("free: OK\n");
    1dca:	00001517          	auipc	a0,0x1
    1dce:	53e50513          	addi	a0,a0,1342 # 3308 <malloc+0xd44>
    1dd2:	00000097          	auipc	ra,0x0
    1dd6:	73a080e7          	jalr	1850(ra) # 250c <printf>
    1dda:	b771                	j	1d66 <main+0x336>
  } else if (strcmp(argv[1], "allports") == 0) {
    1ddc:	00001597          	auipc	a1,0x1
    1de0:	59c58593          	addi	a1,a1,1436 # 3378 <malloc+0xdb4>
    1de4:	6488                	ld	a0,8(s1)
    1de6:	00000097          	auipc	ra,0x0
    1dea:	14e080e7          	jalr	334(ra) # 1f34 <strcmp>
    1dee:	10051463          	bnez	a0,1ef6 <main+0x4c6>
    int free0 = countfree();
    1df2:	00000097          	auipc	ra,0x0
    1df6:	9e8080e7          	jalr	-1560(ra) # 17da <countfree>
    1dfa:	892a                	mv	s2,a0
    if (free0 < EXPECTED_FREE_PAGES) {
    1dfc:	679d                	lui	a5,0x7
    1dfe:	7ff78793          	addi	a5,a5,2047 # 77ff <base+0x35ef>
    1e02:	08a7cd63          	blt	a5,a0,1e9c <main+0x46c>
      printf(
    1e06:	6621                	lui	a2,0x8
    1e08:	80060613          	addi	a2,a2,-2048 # 7800 <base+0x35f0>
    1e0c:	85aa                	mv	a1,a0
    1e0e:	00001517          	auipc	a0,0x1
    1e12:	57a50513          	addi	a0,a0,1402 # 3388 <malloc+0xdc4>
    1e16:	00000097          	auipc	ra,0x0
    1e1a:	6f6080e7          	jalr	1782(ra) # 250c <printf>
    sleep(0.5);
    1e1e:	4501                	li	a0,0
    1e20:	00000097          	auipc	ra,0x0
    1e24:	3f4080e7          	jalr	1012(ra) # 2214 <sleep>
    ok = ok && txone();
    1e28:	ffffe097          	auipc	ra,0xffffe
    1e2c:	1d8080e7          	jalr	472(ra) # 0 <txone>
    1e30:	84aa                	mv	s1,a0
    sleep(0.5);
    1e32:	4501                	li	a0,0
    1e34:	00000097          	auipc	ra,0x0
    1e38:	3e0080e7          	jalr	992(ra) # 2214 <sleep>
    ok = ok && rx2(FWDPORT3, FWDPORT1);
    1e3c:	e8ad                	bnez	s1,1eae <main+0x47e>
    sleep(0.5);
    1e3e:	4501                	li	a0,0
    1e40:	00000097          	auipc	ra,0x0
    1e44:	3d4080e7          	jalr	980(ra) # 2214 <sleep>
    sleep(0.5);
    1e48:	4501                	li	a0,0
    1e4a:	00000097          	auipc	ra,0x0
    1e4e:	3ca080e7          	jalr	970(ra) # 2214 <sleep>
    if ((free1 = countfree()) + 16 + 3 + 3 < free0) {
    1e52:	00000097          	auipc	ra,0x0
    1e56:	988080e7          	jalr	-1656(ra) # 17da <countfree>
    1e5a:	89aa                	mv	s3,a0
    1e5c:	0165079b          	addiw	a5,a0,22
    1e60:	0927d263          	bge	a5,s2,1ee4 <main+0x4b4>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1,
    1e64:	864a                	mv	a2,s2
    1e66:	85aa                	mv	a1,a0
    1e68:	00001517          	auipc	a0,0x1
    1e6c:	4d050513          	addi	a0,a0,1232 # 3338 <malloc+0xd74>
    1e70:	00000097          	auipc	ra,0x0
    1e74:	69c080e7          	jalr	1692(ra) # 250c <printf>
    ok = ok && manyports(free1);
    1e78:	be048ce3          	beqz	s1,1a70 <main+0x40>
    1e7c:	854e                	mv	a0,s3
    1e7e:	00000097          	auipc	ra,0x0
    1e82:	a9a080e7          	jalr	-1382(ra) # 1918 <manyports>
    1e86:	be0505e3          	beqz	a0,1a70 <main+0x40>
      printf("Tests OK\n");
    1e8a:	00001517          	auipc	a0,0x1
    1e8e:	48e50513          	addi	a0,a0,1166 # 3318 <malloc+0xd54>
    1e92:	00000097          	auipc	ra,0x0
    1e96:	67a080e7          	jalr	1658(ra) # 250c <printf>
    1e9a:	bed9                	j	1a70 <main+0x40>
      printf("lazy alloc ports: OK\n");
    1e9c:	00001517          	auipc	a0,0x1
    1ea0:	53450513          	addi	a0,a0,1332 # 33d0 <malloc+0xe0c>
    1ea4:	00000097          	auipc	ra,0x0
    1ea8:	668080e7          	jalr	1640(ra) # 250c <printf>
    1eac:	bf8d                	j	1e1e <main+0x3ee>
    ok = ok && rx2(FWDPORT3, FWDPORT1);
    1eae:	7d000593          	li	a1,2000
    1eb2:	6541                	lui	a0,0x10
    1eb4:	157d                	addi	a0,a0,-1 # ffff <base+0xbdef>
    1eb6:	ffffe097          	auipc	ra,0xffffe
    1eba:	42c080e7          	jalr	1068(ra) # 2e2 <rx2>
    1ebe:	84aa                	mv	s1,a0
    sleep(0.5);
    1ec0:	4501                	li	a0,0
    1ec2:	00000097          	auipc	ra,0x0
    1ec6:	352080e7          	jalr	850(ra) # 2214 <sleep>
    ok = ok && rx2(FWDPORT4, FWDPORT2);
    1eca:	dcbd                	beqz	s1,1e48 <main+0x418>
    1ecc:	7d100593          	li	a1,2001
    1ed0:	6521                	lui	a0,0x8
    1ed2:	9ff50513          	addi	a0,a0,-1537 # 79ff <base+0x37ef>
    1ed6:	ffffe097          	auipc	ra,0xffffe
    1eda:	40c080e7          	jalr	1036(ra) # 2e2 <rx2>
    1ede:	00a034b3          	snez	s1,a0
    1ee2:	b79d                	j	1e48 <main+0x418>
      printf("free: OK\n");
    1ee4:	00001517          	auipc	a0,0x1
    1ee8:	42450513          	addi	a0,a0,1060 # 3308 <malloc+0xd44>
    1eec:	00000097          	auipc	ra,0x0
    1ef0:	620080e7          	jalr	1568(ra) # 250c <printf>
    1ef4:	b751                	j	1e78 <main+0x448>
    usage();
    1ef6:	00000097          	auipc	ra,0x0
    1efa:	812080e7          	jalr	-2030(ra) # 1708 <usage>

0000000000001efe <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
    1efe:	1141                	addi	sp,sp,-16
    1f00:	e406                	sd	ra,8(sp)
    1f02:	e022                	sd	s0,0(sp)
    1f04:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1f06:	00000097          	auipc	ra,0x0
    1f0a:	b2a080e7          	jalr	-1238(ra) # 1a30 <main>
  exit(0);
    1f0e:	4501                	li	a0,0
    1f10:	00000097          	auipc	ra,0x0
    1f14:	274080e7          	jalr	628(ra) # 2184 <exit>

0000000000001f18 <strcpy>:
}

char *strcpy(char *s, const char *t) {
    1f18:	1141                	addi	sp,sp,-16
    1f1a:	e422                	sd	s0,8(sp)
    1f1c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0);
    1f1e:	87aa                	mv	a5,a0
    1f20:	0585                	addi	a1,a1,1
    1f22:	0785                	addi	a5,a5,1
    1f24:	fff5c703          	lbu	a4,-1(a1)
    1f28:	fee78fa3          	sb	a4,-1(a5)
    1f2c:	fb75                	bnez	a4,1f20 <strcpy+0x8>
  return os;
}
    1f2e:	6422                	ld	s0,8(sp)
    1f30:	0141                	addi	sp,sp,16
    1f32:	8082                	ret

0000000000001f34 <strcmp>:

int strcmp(const char *p, const char *q) {
    1f34:	1141                	addi	sp,sp,-16
    1f36:	e422                	sd	s0,8(sp)
    1f38:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
    1f3a:	00054783          	lbu	a5,0(a0)
    1f3e:	cb91                	beqz	a5,1f52 <strcmp+0x1e>
    1f40:	0005c703          	lbu	a4,0(a1)
    1f44:	00f71763          	bne	a4,a5,1f52 <strcmp+0x1e>
    1f48:	0505                	addi	a0,a0,1
    1f4a:	0585                	addi	a1,a1,1
    1f4c:	00054783          	lbu	a5,0(a0)
    1f50:	fbe5                	bnez	a5,1f40 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1f52:	0005c503          	lbu	a0,0(a1)
}
    1f56:	40a7853b          	subw	a0,a5,a0
    1f5a:	6422                	ld	s0,8(sp)
    1f5c:	0141                	addi	sp,sp,16
    1f5e:	8082                	ret

0000000000001f60 <strlen>:

uint strlen(const char *s) {
    1f60:	1141                	addi	sp,sp,-16
    1f62:	e422                	sd	s0,8(sp)
    1f64:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    1f66:	00054783          	lbu	a5,0(a0)
    1f6a:	cf91                	beqz	a5,1f86 <strlen+0x26>
    1f6c:	0505                	addi	a0,a0,1
    1f6e:	87aa                	mv	a5,a0
    1f70:	86be                	mv	a3,a5
    1f72:	0785                	addi	a5,a5,1
    1f74:	fff7c703          	lbu	a4,-1(a5)
    1f78:	ff65                	bnez	a4,1f70 <strlen+0x10>
    1f7a:	40a6853b          	subw	a0,a3,a0
    1f7e:	2505                	addiw	a0,a0,1
  return n;
}
    1f80:	6422                	ld	s0,8(sp)
    1f82:	0141                	addi	sp,sp,16
    1f84:	8082                	ret
  for (n = 0; s[n]; n++);
    1f86:	4501                	li	a0,0
    1f88:	bfe5                	j	1f80 <strlen+0x20>

0000000000001f8a <memset>:

void *memset(void *dst, int c, uint n) {
    1f8a:	1141                	addi	sp,sp,-16
    1f8c:	e422                	sd	s0,8(sp)
    1f8e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    1f90:	ca19                	beqz	a2,1fa6 <memset+0x1c>
    1f92:	87aa                	mv	a5,a0
    1f94:	1602                	slli	a2,a2,0x20
    1f96:	9201                	srli	a2,a2,0x20
    1f98:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1f9c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    1fa0:	0785                	addi	a5,a5,1
    1fa2:	fee79de3          	bne	a5,a4,1f9c <memset+0x12>
  }
  return dst;
}
    1fa6:	6422                	ld	s0,8(sp)
    1fa8:	0141                	addi	sp,sp,16
    1faa:	8082                	ret

0000000000001fac <strchr>:

char *strchr(const char *s, char c) {
    1fac:	1141                	addi	sp,sp,-16
    1fae:	e422                	sd	s0,8(sp)
    1fb0:	0800                	addi	s0,sp,16
  for (; *s; s++)
    1fb2:	00054783          	lbu	a5,0(a0)
    1fb6:	cb99                	beqz	a5,1fcc <strchr+0x20>
    if (*s == c) return (char *)s;
    1fb8:	00f58763          	beq	a1,a5,1fc6 <strchr+0x1a>
  for (; *s; s++)
    1fbc:	0505                	addi	a0,a0,1
    1fbe:	00054783          	lbu	a5,0(a0)
    1fc2:	fbfd                	bnez	a5,1fb8 <strchr+0xc>
  return 0;
    1fc4:	4501                	li	a0,0
}
    1fc6:	6422                	ld	s0,8(sp)
    1fc8:	0141                	addi	sp,sp,16
    1fca:	8082                	ret
  return 0;
    1fcc:	4501                	li	a0,0
    1fce:	bfe5                	j	1fc6 <strchr+0x1a>

0000000000001fd0 <gets>:

char *gets(char *buf, int max) {
    1fd0:	711d                	addi	sp,sp,-96
    1fd2:	ec86                	sd	ra,88(sp)
    1fd4:	e8a2                	sd	s0,80(sp)
    1fd6:	e4a6                	sd	s1,72(sp)
    1fd8:	e0ca                	sd	s2,64(sp)
    1fda:	fc4e                	sd	s3,56(sp)
    1fdc:	f852                	sd	s4,48(sp)
    1fde:	f456                	sd	s5,40(sp)
    1fe0:	f05a                	sd	s6,32(sp)
    1fe2:	ec5e                	sd	s7,24(sp)
    1fe4:	1080                	addi	s0,sp,96
    1fe6:	8baa                	mv	s7,a0
    1fe8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    1fea:	892a                	mv	s2,a0
    1fec:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
    1fee:	4aa9                	li	s5,10
    1ff0:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
    1ff2:	89a6                	mv	s3,s1
    1ff4:	2485                	addiw	s1,s1,1
    1ff6:	0344d863          	bge	s1,s4,2026 <gets+0x56>
    cc = read(0, &c, 1);
    1ffa:	4605                	li	a2,1
    1ffc:	faf40593          	addi	a1,s0,-81
    2000:	4501                	li	a0,0
    2002:	00000097          	auipc	ra,0x0
    2006:	19a080e7          	jalr	410(ra) # 219c <read>
    if (cc < 1) break;
    200a:	00a05e63          	blez	a0,2026 <gets+0x56>
    buf[i++] = c;
    200e:	faf44783          	lbu	a5,-81(s0)
    2012:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
    2016:	01578763          	beq	a5,s5,2024 <gets+0x54>
    201a:	0905                	addi	s2,s2,1
    201c:	fd679be3          	bne	a5,s6,1ff2 <gets+0x22>
    buf[i++] = c;
    2020:	89a6                	mv	s3,s1
    2022:	a011                	j	2026 <gets+0x56>
    2024:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
    2026:	99de                	add	s3,s3,s7
    2028:	00098023          	sb	zero,0(s3)
  return buf;
}
    202c:	855e                	mv	a0,s7
    202e:	60e6                	ld	ra,88(sp)
    2030:	6446                	ld	s0,80(sp)
    2032:	64a6                	ld	s1,72(sp)
    2034:	6906                	ld	s2,64(sp)
    2036:	79e2                	ld	s3,56(sp)
    2038:	7a42                	ld	s4,48(sp)
    203a:	7aa2                	ld	s5,40(sp)
    203c:	7b02                	ld	s6,32(sp)
    203e:	6be2                	ld	s7,24(sp)
    2040:	6125                	addi	sp,sp,96
    2042:	8082                	ret

0000000000002044 <stat>:

int stat(const char *n, struct stat *st) {
    2044:	1101                	addi	sp,sp,-32
    2046:	ec06                	sd	ra,24(sp)
    2048:	e822                	sd	s0,16(sp)
    204a:	e04a                	sd	s2,0(sp)
    204c:	1000                	addi	s0,sp,32
    204e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2050:	4581                	li	a1,0
    2052:	00000097          	auipc	ra,0x0
    2056:	172080e7          	jalr	370(ra) # 21c4 <open>
  if (fd < 0) return -1;
    205a:	02054663          	bltz	a0,2086 <stat+0x42>
    205e:	e426                	sd	s1,8(sp)
    2060:	84aa                	mv	s1,a0
  r = fstat(fd, st);
    2062:	85ca                	mv	a1,s2
    2064:	00000097          	auipc	ra,0x0
    2068:	178080e7          	jalr	376(ra) # 21dc <fstat>
    206c:	892a                	mv	s2,a0
  close(fd);
    206e:	8526                	mv	a0,s1
    2070:	00000097          	auipc	ra,0x0
    2074:	13c080e7          	jalr	316(ra) # 21ac <close>
  return r;
    2078:	64a2                	ld	s1,8(sp)
}
    207a:	854a                	mv	a0,s2
    207c:	60e2                	ld	ra,24(sp)
    207e:	6442                	ld	s0,16(sp)
    2080:	6902                	ld	s2,0(sp)
    2082:	6105                	addi	sp,sp,32
    2084:	8082                	ret
  if (fd < 0) return -1;
    2086:	597d                	li	s2,-1
    2088:	bfcd                	j	207a <stat+0x36>

000000000000208a <atoi>:

int atoi(const char *s) {
    208a:	1141                	addi	sp,sp,-16
    208c:	e422                	sd	s0,8(sp)
    208e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    2090:	00054683          	lbu	a3,0(a0)
    2094:	fd06879b          	addiw	a5,a3,-48
    2098:	0ff7f793          	zext.b	a5,a5
    209c:	4625                	li	a2,9
    209e:	02f66863          	bltu	a2,a5,20ce <atoi+0x44>
    20a2:	872a                	mv	a4,a0
  n = 0;
    20a4:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    20a6:	0705                	addi	a4,a4,1
    20a8:	0025179b          	slliw	a5,a0,0x2
    20ac:	9fa9                	addw	a5,a5,a0
    20ae:	0017979b          	slliw	a5,a5,0x1
    20b2:	9fb5                	addw	a5,a5,a3
    20b4:	fd07851b          	addiw	a0,a5,-48
    20b8:	00074683          	lbu	a3,0(a4)
    20bc:	fd06879b          	addiw	a5,a3,-48
    20c0:	0ff7f793          	zext.b	a5,a5
    20c4:	fef671e3          	bgeu	a2,a5,20a6 <atoi+0x1c>
  return n;
}
    20c8:	6422                	ld	s0,8(sp)
    20ca:	0141                	addi	sp,sp,16
    20cc:	8082                	ret
  n = 0;
    20ce:	4501                	li	a0,0
    20d0:	bfe5                	j	20c8 <atoi+0x3e>

00000000000020d2 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    20d2:	1141                	addi	sp,sp,-16
    20d4:	e422                	sd	s0,8(sp)
    20d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    20d8:	02b57463          	bgeu	a0,a1,2100 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
    20dc:	00c05f63          	blez	a2,20fa <memmove+0x28>
    20e0:	1602                	slli	a2,a2,0x20
    20e2:	9201                	srli	a2,a2,0x20
    20e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    20e8:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
    20ea:	0585                	addi	a1,a1,1
    20ec:	0705                	addi	a4,a4,1
    20ee:	fff5c683          	lbu	a3,-1(a1)
    20f2:	fed70fa3          	sb	a3,-1(a4)
    20f6:	fef71ae3          	bne	a4,a5,20ea <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
    20fa:	6422                	ld	s0,8(sp)
    20fc:	0141                	addi	sp,sp,16
    20fe:	8082                	ret
    dst += n;
    2100:	00c50733          	add	a4,a0,a2
    src += n;
    2104:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
    2106:	fec05ae3          	blez	a2,20fa <memmove+0x28>
    210a:	fff6079b          	addiw	a5,a2,-1
    210e:	1782                	slli	a5,a5,0x20
    2110:	9381                	srli	a5,a5,0x20
    2112:	fff7c793          	not	a5,a5
    2116:	97ba                	add	a5,a5,a4
    2118:	15fd                	addi	a1,a1,-1
    211a:	177d                	addi	a4,a4,-1
    211c:	0005c683          	lbu	a3,0(a1)
    2120:	00d70023          	sb	a3,0(a4)
    2124:	fee79ae3          	bne	a5,a4,2118 <memmove+0x46>
    2128:	bfc9                	j	20fa <memmove+0x28>

000000000000212a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
    212a:	1141                	addi	sp,sp,-16
    212c:	e422                	sd	s0,8(sp)
    212e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    2130:	ca05                	beqz	a2,2160 <memcmp+0x36>
    2132:	fff6069b          	addiw	a3,a2,-1
    2136:	1682                	slli	a3,a3,0x20
    2138:	9281                	srli	a3,a3,0x20
    213a:	0685                	addi	a3,a3,1
    213c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    213e:	00054783          	lbu	a5,0(a0)
    2142:	0005c703          	lbu	a4,0(a1)
    2146:	00e79863          	bne	a5,a4,2156 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    214a:	0505                	addi	a0,a0,1
    p2++;
    214c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    214e:	fed518e3          	bne	a0,a3,213e <memcmp+0x14>
  }
  return 0;
    2152:	4501                	li	a0,0
    2154:	a019                	j	215a <memcmp+0x30>
      return *p1 - *p2;
    2156:	40e7853b          	subw	a0,a5,a4
}
    215a:	6422                	ld	s0,8(sp)
    215c:	0141                	addi	sp,sp,16
    215e:	8082                	ret
  return 0;
    2160:	4501                	li	a0,0
    2162:	bfe5                	j	215a <memcmp+0x30>

0000000000002164 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
    2164:	1141                	addi	sp,sp,-16
    2166:	e406                	sd	ra,8(sp)
    2168:	e022                	sd	s0,0(sp)
    216a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    216c:	00000097          	auipc	ra,0x0
    2170:	f66080e7          	jalr	-154(ra) # 20d2 <memmove>
}
    2174:	60a2                	ld	ra,8(sp)
    2176:	6402                	ld	s0,0(sp)
    2178:	0141                	addi	sp,sp,16
    217a:	8082                	ret

000000000000217c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    217c:	4885                	li	a7,1
 ecall
    217e:	00000073          	ecall
 ret
    2182:	8082                	ret

0000000000002184 <exit>:
.global exit
exit:
 li a7, SYS_exit
    2184:	4889                	li	a7,2
 ecall
    2186:	00000073          	ecall
 ret
    218a:	8082                	ret

000000000000218c <wait>:
.global wait
wait:
 li a7, SYS_wait
    218c:	488d                	li	a7,3
 ecall
    218e:	00000073          	ecall
 ret
    2192:	8082                	ret

0000000000002194 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    2194:	4891                	li	a7,4
 ecall
    2196:	00000073          	ecall
 ret
    219a:	8082                	ret

000000000000219c <read>:
.global read
read:
 li a7, SYS_read
    219c:	4895                	li	a7,5
 ecall
    219e:	00000073          	ecall
 ret
    21a2:	8082                	ret

00000000000021a4 <write>:
.global write
write:
 li a7, SYS_write
    21a4:	48c1                	li	a7,16
 ecall
    21a6:	00000073          	ecall
 ret
    21aa:	8082                	ret

00000000000021ac <close>:
.global close
close:
 li a7, SYS_close
    21ac:	48d5                	li	a7,21
 ecall
    21ae:	00000073          	ecall
 ret
    21b2:	8082                	ret

00000000000021b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    21b4:	4899                	li	a7,6
 ecall
    21b6:	00000073          	ecall
 ret
    21ba:	8082                	ret

00000000000021bc <exec>:
.global exec
exec:
 li a7, SYS_exec
    21bc:	489d                	li	a7,7
 ecall
    21be:	00000073          	ecall
 ret
    21c2:	8082                	ret

00000000000021c4 <open>:
.global open
open:
 li a7, SYS_open
    21c4:	48bd                	li	a7,15
 ecall
    21c6:	00000073          	ecall
 ret
    21ca:	8082                	ret

00000000000021cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    21cc:	48c5                	li	a7,17
 ecall
    21ce:	00000073          	ecall
 ret
    21d2:	8082                	ret

00000000000021d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    21d4:	48c9                	li	a7,18
 ecall
    21d6:	00000073          	ecall
 ret
    21da:	8082                	ret

00000000000021dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    21dc:	48a1                	li	a7,8
 ecall
    21de:	00000073          	ecall
 ret
    21e2:	8082                	ret

00000000000021e4 <link>:
.global link
link:
 li a7, SYS_link
    21e4:	48cd                	li	a7,19
 ecall
    21e6:	00000073          	ecall
 ret
    21ea:	8082                	ret

00000000000021ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    21ec:	48d1                	li	a7,20
 ecall
    21ee:	00000073          	ecall
 ret
    21f2:	8082                	ret

00000000000021f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    21f4:	48a5                	li	a7,9
 ecall
    21f6:	00000073          	ecall
 ret
    21fa:	8082                	ret

00000000000021fc <dup>:
.global dup
dup:
 li a7, SYS_dup
    21fc:	48a9                	li	a7,10
 ecall
    21fe:	00000073          	ecall
 ret
    2202:	8082                	ret

0000000000002204 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    2204:	48ad                	li	a7,11
 ecall
    2206:	00000073          	ecall
 ret
    220a:	8082                	ret

000000000000220c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    220c:	48b1                	li	a7,12
 ecall
    220e:	00000073          	ecall
 ret
    2212:	8082                	ret

0000000000002214 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    2214:	48b5                	li	a7,13
 ecall
    2216:	00000073          	ecall
 ret
    221a:	8082                	ret

000000000000221c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    221c:	48b9                	li	a7,14
 ecall
    221e:	00000073          	ecall
 ret
    2222:	8082                	ret

0000000000002224 <bind>:
.global bind
bind:
 li a7, SYS_bind
    2224:	48d9                	li	a7,22
 ecall
    2226:	00000073          	ecall
 ret
    222a:	8082                	ret

000000000000222c <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
    222c:	48dd                	li	a7,23
 ecall
    222e:	00000073          	ecall
 ret
    2232:	8082                	ret

0000000000002234 <send>:
.global send
send:
 li a7, SYS_send
    2234:	48e1                	li	a7,24
 ecall
    2236:	00000073          	ecall
 ret
    223a:	8082                	ret

000000000000223c <recv>:
.global recv
recv:
 li a7, SYS_recv
    223c:	48e5                	li	a7,25
 ecall
    223e:	00000073          	ecall
 ret
    2242:	8082                	ret

0000000000002244 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
    2244:	1101                	addi	sp,sp,-32
    2246:	ec06                	sd	ra,24(sp)
    2248:	e822                	sd	s0,16(sp)
    224a:	1000                	addi	s0,sp,32
    224c:	feb407a3          	sb	a1,-17(s0)
    2250:	4605                	li	a2,1
    2252:	fef40593          	addi	a1,s0,-17
    2256:	00000097          	auipc	ra,0x0
    225a:	f4e080e7          	jalr	-178(ra) # 21a4 <write>
    225e:	60e2                	ld	ra,24(sp)
    2260:	6442                	ld	s0,16(sp)
    2262:	6105                	addi	sp,sp,32
    2264:	8082                	ret

0000000000002266 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
    2266:	7139                	addi	sp,sp,-64
    2268:	fc06                	sd	ra,56(sp)
    226a:	f822                	sd	s0,48(sp)
    226c:	f426                	sd	s1,40(sp)
    226e:	0080                	addi	s0,sp,64
    2270:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
    2272:	c299                	beqz	a3,2278 <printint+0x12>
    2274:	0805cb63          	bltz	a1,230a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    2278:	2581                	sext.w	a1,a1
  neg = 0;
    227a:	4881                	li	a7,0
    227c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    2280:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    2282:	2601                	sext.w	a2,a2
    2284:	00001517          	auipc	a0,0x1
    2288:	1c450513          	addi	a0,a0,452 # 3448 <digits>
    228c:	883a                	mv	a6,a4
    228e:	2705                	addiw	a4,a4,1
    2290:	02c5f7bb          	remuw	a5,a1,a2
    2294:	1782                	slli	a5,a5,0x20
    2296:	9381                	srli	a5,a5,0x20
    2298:	97aa                	add	a5,a5,a0
    229a:	0007c783          	lbu	a5,0(a5)
    229e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    22a2:	0005879b          	sext.w	a5,a1
    22a6:	02c5d5bb          	divuw	a1,a1,a2
    22aa:	0685                	addi	a3,a3,1
    22ac:	fec7f0e3          	bgeu	a5,a2,228c <printint+0x26>
  if (neg) buf[i++] = '-';
    22b0:	00088c63          	beqz	a7,22c8 <printint+0x62>
    22b4:	fd070793          	addi	a5,a4,-48
    22b8:	00878733          	add	a4,a5,s0
    22bc:	02d00793          	li	a5,45
    22c0:	fef70823          	sb	a5,-16(a4)
    22c4:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
    22c8:	02e05c63          	blez	a4,2300 <printint+0x9a>
    22cc:	f04a                	sd	s2,32(sp)
    22ce:	ec4e                	sd	s3,24(sp)
    22d0:	fc040793          	addi	a5,s0,-64
    22d4:	00e78933          	add	s2,a5,a4
    22d8:	fff78993          	addi	s3,a5,-1
    22dc:	99ba                	add	s3,s3,a4
    22de:	377d                	addiw	a4,a4,-1
    22e0:	1702                	slli	a4,a4,0x20
    22e2:	9301                	srli	a4,a4,0x20
    22e4:	40e989b3          	sub	s3,s3,a4
    22e8:	fff94583          	lbu	a1,-1(s2)
    22ec:	8526                	mv	a0,s1
    22ee:	00000097          	auipc	ra,0x0
    22f2:	f56080e7          	jalr	-170(ra) # 2244 <putc>
    22f6:	197d                	addi	s2,s2,-1
    22f8:	ff3918e3          	bne	s2,s3,22e8 <printint+0x82>
    22fc:	7902                	ld	s2,32(sp)
    22fe:	69e2                	ld	s3,24(sp)
}
    2300:	70e2                	ld	ra,56(sp)
    2302:	7442                	ld	s0,48(sp)
    2304:	74a2                	ld	s1,40(sp)
    2306:	6121                	addi	sp,sp,64
    2308:	8082                	ret
    x = -xx;
    230a:	40b005bb          	negw	a1,a1
    neg = 1;
    230e:	4885                	li	a7,1
    x = -xx;
    2310:	b7b5                	j	227c <printint+0x16>

0000000000002312 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
    2312:	715d                	addi	sp,sp,-80
    2314:	e486                	sd	ra,72(sp)
    2316:	e0a2                	sd	s0,64(sp)
    2318:	f84a                	sd	s2,48(sp)
    231a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    231c:	0005c903          	lbu	s2,0(a1)
    2320:	1a090a63          	beqz	s2,24d4 <vprintf+0x1c2>
    2324:	fc26                	sd	s1,56(sp)
    2326:	f44e                	sd	s3,40(sp)
    2328:	f052                	sd	s4,32(sp)
    232a:	ec56                	sd	s5,24(sp)
    232c:	e85a                	sd	s6,16(sp)
    232e:	e45e                	sd	s7,8(sp)
    2330:	8aaa                	mv	s5,a0
    2332:	8bb2                	mv	s7,a2
    2334:	00158493          	addi	s1,a1,1
  state = 0;
    2338:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
    233a:	02500a13          	li	s4,37
    233e:	4b55                	li	s6,21
    2340:	a839                	j	235e <vprintf+0x4c>
        putc(fd, c);
    2342:	85ca                	mv	a1,s2
    2344:	8556                	mv	a0,s5
    2346:	00000097          	auipc	ra,0x0
    234a:	efe080e7          	jalr	-258(ra) # 2244 <putc>
    234e:	a019                	j	2354 <vprintf+0x42>
    } else if (state == '%') {
    2350:	01498d63          	beq	s3,s4,236a <vprintf+0x58>
  for (i = 0; fmt[i]; i++) {
    2354:	0485                	addi	s1,s1,1
    2356:	fff4c903          	lbu	s2,-1(s1)
    235a:	16090763          	beqz	s2,24c8 <vprintf+0x1b6>
    if (state == 0) {
    235e:	fe0999e3          	bnez	s3,2350 <vprintf+0x3e>
      if (c == '%') {
    2362:	ff4910e3          	bne	s2,s4,2342 <vprintf+0x30>
        state = '%';
    2366:	89d2                	mv	s3,s4
    2368:	b7f5                	j	2354 <vprintf+0x42>
      if (c == 'd') {
    236a:	13490463          	beq	s2,s4,2492 <vprintf+0x180>
    236e:	f9d9079b          	addiw	a5,s2,-99
    2372:	0ff7f793          	zext.b	a5,a5
    2376:	12fb6763          	bltu	s6,a5,24a4 <vprintf+0x192>
    237a:	f9d9079b          	addiw	a5,s2,-99
    237e:	0ff7f713          	zext.b	a4,a5
    2382:	12eb6163          	bltu	s6,a4,24a4 <vprintf+0x192>
    2386:	00271793          	slli	a5,a4,0x2
    238a:	00001717          	auipc	a4,0x1
    238e:	06670713          	addi	a4,a4,102 # 33f0 <malloc+0xe2c>
    2392:	97ba                	add	a5,a5,a4
    2394:	439c                	lw	a5,0(a5)
    2396:	97ba                	add	a5,a5,a4
    2398:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    239a:	008b8913          	addi	s2,s7,8
    239e:	4685                	li	a3,1
    23a0:	4629                	li	a2,10
    23a2:	000ba583          	lw	a1,0(s7)
    23a6:	8556                	mv	a0,s5
    23a8:	00000097          	auipc	ra,0x0
    23ac:	ebe080e7          	jalr	-322(ra) # 2266 <printint>
    23b0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    23b2:	4981                	li	s3,0
    23b4:	b745                	j	2354 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    23b6:	008b8913          	addi	s2,s7,8
    23ba:	4681                	li	a3,0
    23bc:	4629                	li	a2,10
    23be:	000ba583          	lw	a1,0(s7)
    23c2:	8556                	mv	a0,s5
    23c4:	00000097          	auipc	ra,0x0
    23c8:	ea2080e7          	jalr	-350(ra) # 2266 <printint>
    23cc:	8bca                	mv	s7,s2
      state = 0;
    23ce:	4981                	li	s3,0
    23d0:	b751                	j	2354 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    23d2:	008b8913          	addi	s2,s7,8
    23d6:	4681                	li	a3,0
    23d8:	4641                	li	a2,16
    23da:	000ba583          	lw	a1,0(s7)
    23de:	8556                	mv	a0,s5
    23e0:	00000097          	auipc	ra,0x0
    23e4:	e86080e7          	jalr	-378(ra) # 2266 <printint>
    23e8:	8bca                	mv	s7,s2
      state = 0;
    23ea:	4981                	li	s3,0
    23ec:	b7a5                	j	2354 <vprintf+0x42>
    23ee:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    23f0:	008b8c13          	addi	s8,s7,8
    23f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    23f8:	03000593          	li	a1,48
    23fc:	8556                	mv	a0,s5
    23fe:	00000097          	auipc	ra,0x0
    2402:	e46080e7          	jalr	-442(ra) # 2244 <putc>
  putc(fd, 'x');
    2406:	07800593          	li	a1,120
    240a:	8556                	mv	a0,s5
    240c:	00000097          	auipc	ra,0x0
    2410:	e38080e7          	jalr	-456(ra) # 2244 <putc>
    2414:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    2416:	00001b97          	auipc	s7,0x1
    241a:	032b8b93          	addi	s7,s7,50 # 3448 <digits>
    241e:	03c9d793          	srli	a5,s3,0x3c
    2422:	97de                	add	a5,a5,s7
    2424:	0007c583          	lbu	a1,0(a5)
    2428:	8556                	mv	a0,s5
    242a:	00000097          	auipc	ra,0x0
    242e:	e1a080e7          	jalr	-486(ra) # 2244 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    2432:	0992                	slli	s3,s3,0x4
    2434:	397d                	addiw	s2,s2,-1
    2436:	fe0914e3          	bnez	s2,241e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    243a:	8be2                	mv	s7,s8
      state = 0;
    243c:	4981                	li	s3,0
    243e:	6c02                	ld	s8,0(sp)
    2440:	bf11                	j	2354 <vprintf+0x42>
        s = va_arg(ap, char *);
    2442:	008b8993          	addi	s3,s7,8
    2446:	000bb903          	ld	s2,0(s7)
        if (s == 0) s = "(null)";
    244a:	02090163          	beqz	s2,246c <vprintf+0x15a>
        while (*s != 0) {
    244e:	00094583          	lbu	a1,0(s2)
    2452:	c9a5                	beqz	a1,24c2 <vprintf+0x1b0>
          putc(fd, *s);
    2454:	8556                	mv	a0,s5
    2456:	00000097          	auipc	ra,0x0
    245a:	dee080e7          	jalr	-530(ra) # 2244 <putc>
          s++;
    245e:	0905                	addi	s2,s2,1
        while (*s != 0) {
    2460:	00094583          	lbu	a1,0(s2)
    2464:	f9e5                	bnez	a1,2454 <vprintf+0x142>
        s = va_arg(ap, char *);
    2466:	8bce                	mv	s7,s3
      state = 0;
    2468:	4981                	li	s3,0
    246a:	b5ed                	j	2354 <vprintf+0x42>
        if (s == 0) s = "(null)";
    246c:	00001917          	auipc	s2,0x1
    2470:	f7c90913          	addi	s2,s2,-132 # 33e8 <malloc+0xe24>
        while (*s != 0) {
    2474:	02800593          	li	a1,40
    2478:	bff1                	j	2454 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    247a:	008b8913          	addi	s2,s7,8
    247e:	000bc583          	lbu	a1,0(s7)
    2482:	8556                	mv	a0,s5
    2484:	00000097          	auipc	ra,0x0
    2488:	dc0080e7          	jalr	-576(ra) # 2244 <putc>
    248c:	8bca                	mv	s7,s2
      state = 0;
    248e:	4981                	li	s3,0
    2490:	b5d1                	j	2354 <vprintf+0x42>
        putc(fd, c);
    2492:	02500593          	li	a1,37
    2496:	8556                	mv	a0,s5
    2498:	00000097          	auipc	ra,0x0
    249c:	dac080e7          	jalr	-596(ra) # 2244 <putc>
      state = 0;
    24a0:	4981                	li	s3,0
    24a2:	bd4d                	j	2354 <vprintf+0x42>
        putc(fd, '%');
    24a4:	02500593          	li	a1,37
    24a8:	8556                	mv	a0,s5
    24aa:	00000097          	auipc	ra,0x0
    24ae:	d9a080e7          	jalr	-614(ra) # 2244 <putc>
        putc(fd, c);
    24b2:	85ca                	mv	a1,s2
    24b4:	8556                	mv	a0,s5
    24b6:	00000097          	auipc	ra,0x0
    24ba:	d8e080e7          	jalr	-626(ra) # 2244 <putc>
      state = 0;
    24be:	4981                	li	s3,0
    24c0:	bd51                	j	2354 <vprintf+0x42>
        s = va_arg(ap, char *);
    24c2:	8bce                	mv	s7,s3
      state = 0;
    24c4:	4981                	li	s3,0
    24c6:	b579                	j	2354 <vprintf+0x42>
    24c8:	74e2                	ld	s1,56(sp)
    24ca:	79a2                	ld	s3,40(sp)
    24cc:	7a02                	ld	s4,32(sp)
    24ce:	6ae2                	ld	s5,24(sp)
    24d0:	6b42                	ld	s6,16(sp)
    24d2:	6ba2                	ld	s7,8(sp)
    }
  }
}
    24d4:	60a6                	ld	ra,72(sp)
    24d6:	6406                	ld	s0,64(sp)
    24d8:	7942                	ld	s2,48(sp)
    24da:	6161                	addi	sp,sp,80
    24dc:	8082                	ret

00000000000024de <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
    24de:	715d                	addi	sp,sp,-80
    24e0:	ec06                	sd	ra,24(sp)
    24e2:	e822                	sd	s0,16(sp)
    24e4:	1000                	addi	s0,sp,32
    24e6:	e010                	sd	a2,0(s0)
    24e8:	e414                	sd	a3,8(s0)
    24ea:	e818                	sd	a4,16(s0)
    24ec:	ec1c                	sd	a5,24(s0)
    24ee:	03043023          	sd	a6,32(s0)
    24f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    24f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    24fa:	8622                	mv	a2,s0
    24fc:	00000097          	auipc	ra,0x0
    2500:	e16080e7          	jalr	-490(ra) # 2312 <vprintf>
}
    2504:	60e2                	ld	ra,24(sp)
    2506:	6442                	ld	s0,16(sp)
    2508:	6161                	addi	sp,sp,80
    250a:	8082                	ret

000000000000250c <printf>:

void printf(const char *fmt, ...) {
    250c:	711d                	addi	sp,sp,-96
    250e:	ec06                	sd	ra,24(sp)
    2510:	e822                	sd	s0,16(sp)
    2512:	1000                	addi	s0,sp,32
    2514:	e40c                	sd	a1,8(s0)
    2516:	e810                	sd	a2,16(s0)
    2518:	ec14                	sd	a3,24(s0)
    251a:	f018                	sd	a4,32(s0)
    251c:	f41c                	sd	a5,40(s0)
    251e:	03043823          	sd	a6,48(s0)
    2522:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    2526:	00840613          	addi	a2,s0,8
    252a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    252e:	85aa                	mv	a1,a0
    2530:	4505                	li	a0,1
    2532:	00000097          	auipc	ra,0x0
    2536:	de0080e7          	jalr	-544(ra) # 2312 <vprintf>
}
    253a:	60e2                	ld	ra,24(sp)
    253c:	6442                	ld	s0,16(sp)
    253e:	6125                	addi	sp,sp,96
    2540:	8082                	ret

0000000000002542 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    2542:	1141                	addi	sp,sp,-16
    2544:	e422                	sd	s0,8(sp)
    2546:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    2548:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    254c:	00002797          	auipc	a5,0x2
    2550:	ab47b783          	ld	a5,-1356(a5) # 4000 <freep>
    2554:	a02d                	j	257e <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    2556:	4618                	lw	a4,8(a2)
    2558:	9f2d                	addw	a4,a4,a1
    255a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    255e:	6398                	ld	a4,0(a5)
    2560:	6310                	ld	a2,0(a4)
    2562:	a83d                	j	25a0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    2564:	ff852703          	lw	a4,-8(a0)
    2568:	9f31                	addw	a4,a4,a2
    256a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    256c:	ff053683          	ld	a3,-16(a0)
    2570:	a091                	j	25b4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    2572:	6398                	ld	a4,0(a5)
    2574:	00e7e463          	bltu	a5,a4,257c <free+0x3a>
    2578:	00e6ea63          	bltu	a3,a4,258c <free+0x4a>
void free(void *ap) {
    257c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    257e:	fed7fae3          	bgeu	a5,a3,2572 <free+0x30>
    2582:	6398                	ld	a4,0(a5)
    2584:	00e6e463          	bltu	a3,a4,258c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    2588:	fee7eae3          	bltu	a5,a4,257c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    258c:	ff852583          	lw	a1,-8(a0)
    2590:	6390                	ld	a2,0(a5)
    2592:	02059813          	slli	a6,a1,0x20
    2596:	01c85713          	srli	a4,a6,0x1c
    259a:	9736                	add	a4,a4,a3
    259c:	fae60de3          	beq	a2,a4,2556 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    25a0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    25a4:	4790                	lw	a2,8(a5)
    25a6:	02061593          	slli	a1,a2,0x20
    25aa:	01c5d713          	srli	a4,a1,0x1c
    25ae:	973e                	add	a4,a4,a5
    25b0:	fae68ae3          	beq	a3,a4,2564 <free+0x22>
    p->s.ptr = bp->s.ptr;
    25b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    25b6:	00002717          	auipc	a4,0x2
    25ba:	a4f73523          	sd	a5,-1462(a4) # 4000 <freep>
}
    25be:	6422                	ld	s0,8(sp)
    25c0:	0141                	addi	sp,sp,16
    25c2:	8082                	ret

00000000000025c4 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    25c4:	7139                	addi	sp,sp,-64
    25c6:	fc06                	sd	ra,56(sp)
    25c8:	f822                	sd	s0,48(sp)
    25ca:	f426                	sd	s1,40(sp)
    25cc:	ec4e                	sd	s3,24(sp)
    25ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    25d0:	02051493          	slli	s1,a0,0x20
    25d4:	9081                	srli	s1,s1,0x20
    25d6:	04bd                	addi	s1,s1,15
    25d8:	8091                	srli	s1,s1,0x4
    25da:	0014899b          	addiw	s3,s1,1
    25de:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    25e0:	00002517          	auipc	a0,0x2
    25e4:	a2053503          	ld	a0,-1504(a0) # 4000 <freep>
    25e8:	c915                	beqz	a0,261c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    25ea:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    25ec:	4798                	lw	a4,8(a5)
    25ee:	08977e63          	bgeu	a4,s1,268a <malloc+0xc6>
    25f2:	f04a                	sd	s2,32(sp)
    25f4:	e852                	sd	s4,16(sp)
    25f6:	e456                	sd	s5,8(sp)
    25f8:	e05a                	sd	s6,0(sp)
  if (nu < 4096) nu = 4096;
    25fa:	8a4e                	mv	s4,s3
    25fc:	0009871b          	sext.w	a4,s3
    2600:	6685                	lui	a3,0x1
    2602:	00d77363          	bgeu	a4,a3,2608 <malloc+0x44>
    2606:	6a05                	lui	s4,0x1
    2608:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    260c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    2610:	00002917          	auipc	s2,0x2
    2614:	9f090913          	addi	s2,s2,-1552 # 4000 <freep>
  if (p == (char *)-1) return 0;
    2618:	5afd                	li	s5,-1
    261a:	a091                	j	265e <malloc+0x9a>
    261c:	f04a                	sd	s2,32(sp)
    261e:	e852                	sd	s4,16(sp)
    2620:	e456                	sd	s5,8(sp)
    2622:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    2624:	00002797          	auipc	a5,0x2
    2628:	bec78793          	addi	a5,a5,-1044 # 4210 <base>
    262c:	00002717          	auipc	a4,0x2
    2630:	9cf73a23          	sd	a5,-1580(a4) # 4000 <freep>
    2634:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    2636:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    263a:	b7c1                	j	25fa <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    263c:	6398                	ld	a4,0(a5)
    263e:	e118                	sd	a4,0(a0)
    2640:	a08d                	j	26a2 <malloc+0xde>
  hp->s.size = nu;
    2642:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    2646:	0541                	addi	a0,a0,16
    2648:	00000097          	auipc	ra,0x0
    264c:	efa080e7          	jalr	-262(ra) # 2542 <free>
  return freep;
    2650:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
    2654:	c13d                	beqz	a0,26ba <malloc+0xf6>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    2656:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    2658:	4798                	lw	a4,8(a5)
    265a:	02977463          	bgeu	a4,s1,2682 <malloc+0xbe>
    if (p == freep)
    265e:	00093703          	ld	a4,0(s2)
    2662:	853e                	mv	a0,a5
    2664:	fef719e3          	bne	a4,a5,2656 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    2668:	8552                	mv	a0,s4
    266a:	00000097          	auipc	ra,0x0
    266e:	ba2080e7          	jalr	-1118(ra) # 220c <sbrk>
  if (p == (char *)-1) return 0;
    2672:	fd5518e3          	bne	a0,s5,2642 <malloc+0x7e>
      if ((p = morecore(nunits)) == 0) return 0;
    2676:	4501                	li	a0,0
    2678:	7902                	ld	s2,32(sp)
    267a:	6a42                	ld	s4,16(sp)
    267c:	6aa2                	ld	s5,8(sp)
    267e:	6b02                	ld	s6,0(sp)
    2680:	a03d                	j	26ae <malloc+0xea>
    2682:	7902                	ld	s2,32(sp)
    2684:	6a42                	ld	s4,16(sp)
    2686:	6aa2                	ld	s5,8(sp)
    2688:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    268a:	fae489e3          	beq	s1,a4,263c <malloc+0x78>
        p->s.size -= nunits;
    268e:	4137073b          	subw	a4,a4,s3
    2692:	c798                	sw	a4,8(a5)
        p += p->s.size;
    2694:	02071693          	slli	a3,a4,0x20
    2698:	01c6d713          	srli	a4,a3,0x1c
    269c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    269e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    26a2:	00002717          	auipc	a4,0x2
    26a6:	94a73f23          	sd	a0,-1698(a4) # 4000 <freep>
      return (void *)(p + 1);
    26aa:	01078513          	addi	a0,a5,16
  }
}
    26ae:	70e2                	ld	ra,56(sp)
    26b0:	7442                	ld	s0,48(sp)
    26b2:	74a2                	ld	s1,40(sp)
    26b4:	69e2                	ld	s3,24(sp)
    26b6:	6121                	addi	sp,sp,64
    26b8:	8082                	ret
    26ba:	7902                	ld	s2,32(sp)
    26bc:	6a42                	ld	s4,16(sp)
    26be:	6aa2                	ld	s5,8(sp)
    26c0:	6b02                	ld	s6,0(sp)
    26c2:	b7f5                	j	26ae <malloc+0xea>
