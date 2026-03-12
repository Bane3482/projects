
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	87013103          	ld	sp,-1936(sp) # 8000b870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	45a060ef          	jal	80006470 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kinit>:
#include "types.h"

extern char end[];  // first address after kernel.
                    // defined by kernel.ld.

void kinit() {
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
  char *p = (char *)PGROUNDUP((uint64)end);
  bd_init(p, (void *)PHYSTOP);
    80000024:	45c5                	li	a1,17
    80000026:	05ee                	slli	a1,a1,0x1b
    80000028:	00025517          	auipc	a0,0x25
    8000002c:	d6750513          	addi	a0,a0,-665 # 80024d8f <end+0xfff>
    80000030:	77fd                	lui	a5,0xfffff
    80000032:	8d7d                	and	a0,a0,a5
    80000034:	00006097          	auipc	ra,0x6
    80000038:	0c2080e7          	jalr	194(ra) # 800060f6 <bd_init>
}
    8000003c:	60a2                	ld	ra,8(sp)
    8000003e:	6402                	ld	s0,0(sp)
    80000040:	0141                	addi	sp,sp,16
    80000042:	8082                	ret

0000000080000044 <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().
void kfree(void *pa) { bd_free(pa); }
    80000044:	1141                	addi	sp,sp,-16
    80000046:	e406                	sd	ra,8(sp)
    80000048:	e022                	sd	s0,0(sp)
    8000004a:	0800                	addi	s0,sp,16
    8000004c:	00006097          	auipc	ra,0x6
    80000050:	ba8080e7          	jalr	-1112(ra) # 80005bf4 <bd_free>
    80000054:	60a2                	ld	ra,8(sp)
    80000056:	6402                	ld	s0,0(sp)
    80000058:	0141                	addi	sp,sp,16
    8000005a:	8082                	ret

000000008000005c <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) { return bd_malloc(PGSIZE); }
    8000005c:	1141                	addi	sp,sp,-16
    8000005e:	e406                	sd	ra,8(sp)
    80000060:	e022                	sd	s0,0(sp)
    80000062:	0800                	addi	s0,sp,16
    80000064:	6505                	lui	a0,0x1
    80000066:	00006097          	auipc	ra,0x6
    8000006a:	97e080e7          	jalr	-1666(ra) # 800059e4 <bd_malloc>
    8000006e:	60a2                	ld	ra,8(sp)
    80000070:	6402                	ld	s0,0(sp)
    80000072:	0141                	addi	sp,sp,16
    80000074:	8082                	ret

0000000080000076 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80000076:	1141                	addi	sp,sp,-16
    80000078:	e422                	sd	s0,8(sp)
    8000007a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    8000007c:	ca19                	beqz	a2,80000092 <memset+0x1c>
    8000007e:	87aa                	mv	a5,a0
    80000080:	1602                	slli	a2,a2,0x20
    80000082:	9201                	srli	a2,a2,0x20
    80000084:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000088:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb270>
  for (i = 0; i < n; i++) {
    8000008c:	0785                	addi	a5,a5,1
    8000008e:	fee79de3          	bne	a5,a4,80000088 <memset+0x12>
  }
  return dst;
}
    80000092:	6422                	ld	s0,8(sp)
    80000094:	0141                	addi	sp,sp,16
    80000096:	8082                	ret

0000000080000098 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    80000098:	1141                	addi	sp,sp,-16
    8000009a:	e422                	sd	s0,8(sp)
    8000009c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    8000009e:	ca05                	beqz	a2,800000ce <memcmp+0x36>
    800000a0:	fff6069b          	addiw	a3,a2,-1
    800000a4:	1682                	slli	a3,a3,0x20
    800000a6:	9281                	srli	a3,a3,0x20
    800000a8:	0685                	addi	a3,a3,1
    800000aa:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800000ac:	00054783          	lbu	a5,0(a0) # 1000 <_entry-0x7ffff000>
    800000b0:	0005c703          	lbu	a4,0(a1)
    800000b4:	00e79863          	bne	a5,a4,800000c4 <memcmp+0x2c>
    s1++, s2++;
    800000b8:	0505                	addi	a0,a0,1
    800000ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800000bc:	fed518e3          	bne	a0,a3,800000ac <memcmp+0x14>
  }

  return 0;
    800000c0:	4501                	li	a0,0
    800000c2:	a019                	j	800000c8 <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800000c4:	40e7853b          	subw	a0,a5,a4
}
    800000c8:	6422                	ld	s0,8(sp)
    800000ca:	0141                	addi	sp,sp,16
    800000cc:	8082                	ret
  return 0;
    800000ce:	4501                	li	a0,0
    800000d0:	bfe5                	j	800000c8 <memcmp+0x30>

00000000800000d2 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800000d2:	1141                	addi	sp,sp,-16
    800000d4:	e422                	sd	s0,8(sp)
    800000d6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800000d8:	c205                	beqz	a2,800000f8 <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800000da:	02a5e263          	bltu	a1,a0,800000fe <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800000de:	1602                	slli	a2,a2,0x20
    800000e0:	9201                	srli	a2,a2,0x20
    800000e2:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800000e6:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800000e8:	0585                	addi	a1,a1,1
    800000ea:	0705                	addi	a4,a4,1
    800000ec:	fff5c683          	lbu	a3,-1(a1)
    800000f0:	fed70fa3          	sb	a3,-1(a4)
    800000f4:	feb79ae3          	bne	a5,a1,800000e8 <memmove+0x16>

  return dst;
}
    800000f8:	6422                	ld	s0,8(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret
  if (s < d && s + n > d) {
    800000fe:	02061693          	slli	a3,a2,0x20
    80000102:	9281                	srli	a3,a3,0x20
    80000104:	00d58733          	add	a4,a1,a3
    80000108:	fce57be3          	bgeu	a0,a4,800000de <memmove+0xc>
    d += n;
    8000010c:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    8000010e:	fff6079b          	addiw	a5,a2,-1
    80000112:	1782                	slli	a5,a5,0x20
    80000114:	9381                	srli	a5,a5,0x20
    80000116:	fff7c793          	not	a5,a5
    8000011a:	97ba                	add	a5,a5,a4
    8000011c:	177d                	addi	a4,a4,-1
    8000011e:	16fd                	addi	a3,a3,-1
    80000120:	00074603          	lbu	a2,0(a4)
    80000124:	00c68023          	sb	a2,0(a3)
    80000128:	fef71ae3          	bne	a4,a5,8000011c <memmove+0x4a>
    8000012c:	b7f1                	j	800000f8 <memmove+0x26>

000000008000012e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    8000012e:	1141                	addi	sp,sp,-16
    80000130:	e406                	sd	ra,8(sp)
    80000132:	e022                	sd	s0,0(sp)
    80000134:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	f9c080e7          	jalr	-100(ra) # 800000d2 <memmove>
}
    8000013e:	60a2                	ld	ra,8(sp)
    80000140:	6402                	ld	s0,0(sp)
    80000142:	0141                	addi	sp,sp,16
    80000144:	8082                	ret

0000000080000146 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    80000146:	1141                	addi	sp,sp,-16
    80000148:	e422                	sd	s0,8(sp)
    8000014a:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    8000014c:	ce11                	beqz	a2,80000168 <strncmp+0x22>
    8000014e:	00054783          	lbu	a5,0(a0)
    80000152:	cf89                	beqz	a5,8000016c <strncmp+0x26>
    80000154:	0005c703          	lbu	a4,0(a1)
    80000158:	00f71a63          	bne	a4,a5,8000016c <strncmp+0x26>
    8000015c:	367d                	addiw	a2,a2,-1
    8000015e:	0505                	addi	a0,a0,1
    80000160:	0585                	addi	a1,a1,1
    80000162:	f675                	bnez	a2,8000014e <strncmp+0x8>
  if (n == 0) return 0;
    80000164:	4501                	li	a0,0
    80000166:	a801                	j	80000176 <strncmp+0x30>
    80000168:	4501                	li	a0,0
    8000016a:	a031                	j	80000176 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    8000016c:	00054503          	lbu	a0,0(a0)
    80000170:	0005c783          	lbu	a5,0(a1)
    80000174:	9d1d                	subw	a0,a0,a5
}
    80000176:	6422                	ld	s0,8(sp)
    80000178:	0141                	addi	sp,sp,16
    8000017a:	8082                	ret

000000008000017c <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    8000017c:	1141                	addi	sp,sp,-16
    8000017e:	e422                	sd	s0,8(sp)
    80000180:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0);
    80000182:	87aa                	mv	a5,a0
    80000184:	86b2                	mv	a3,a2
    80000186:	367d                	addiw	a2,a2,-1
    80000188:	02d05563          	blez	a3,800001b2 <strncpy+0x36>
    8000018c:	0785                	addi	a5,a5,1
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	fee78fa3          	sb	a4,-1(a5)
    80000196:	0585                	addi	a1,a1,1
    80000198:	f775                	bnez	a4,80000184 <strncpy+0x8>
  while (n-- > 0) *s++ = 0;
    8000019a:	873e                	mv	a4,a5
    8000019c:	9fb5                	addw	a5,a5,a3
    8000019e:	37fd                	addiw	a5,a5,-1
    800001a0:	00c05963          	blez	a2,800001b2 <strncpy+0x36>
    800001a4:	0705                	addi	a4,a4,1
    800001a6:	fe070fa3          	sb	zero,-1(a4)
    800001aa:	40e786bb          	subw	a3,a5,a4
    800001ae:	fed04be3          	bgtz	a3,800001a4 <strncpy+0x28>
  return os;
}
    800001b2:	6422                	ld	s0,8(sp)
    800001b4:	0141                	addi	sp,sp,16
    800001b6:	8082                	ret

00000000800001b8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800001b8:	1141                	addi	sp,sp,-16
    800001ba:	e422                	sd	s0,8(sp)
    800001bc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800001be:	02c05363          	blez	a2,800001e4 <safestrcpy+0x2c>
    800001c2:	fff6069b          	addiw	a3,a2,-1
    800001c6:	1682                	slli	a3,a3,0x20
    800001c8:	9281                	srli	a3,a3,0x20
    800001ca:	96ae                	add	a3,a3,a1
    800001cc:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0);
    800001ce:	00d58963          	beq	a1,a3,800001e0 <safestrcpy+0x28>
    800001d2:	0585                	addi	a1,a1,1
    800001d4:	0785                	addi	a5,a5,1
    800001d6:	fff5c703          	lbu	a4,-1(a1)
    800001da:	fee78fa3          	sb	a4,-1(a5)
    800001de:	fb65                	bnez	a4,800001ce <safestrcpy+0x16>
  *s = 0;
    800001e0:	00078023          	sb	zero,0(a5)
  return os;
}
    800001e4:	6422                	ld	s0,8(sp)
    800001e6:	0141                	addi	sp,sp,16
    800001e8:	8082                	ret

00000000800001ea <strlen>:

int strlen(const char *s) {
    800001ea:	1141                	addi	sp,sp,-16
    800001ec:	e422                	sd	s0,8(sp)
    800001ee:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    800001f0:	00054783          	lbu	a5,0(a0)
    800001f4:	cf91                	beqz	a5,80000210 <strlen+0x26>
    800001f6:	0505                	addi	a0,a0,1
    800001f8:	87aa                	mv	a5,a0
    800001fa:	86be                	mv	a3,a5
    800001fc:	0785                	addi	a5,a5,1
    800001fe:	fff7c703          	lbu	a4,-1(a5)
    80000202:	ff65                	bnez	a4,800001fa <strlen+0x10>
    80000204:	40a6853b          	subw	a0,a3,a0
    80000208:	2505                	addiw	a0,a0,1
  return n;
}
    8000020a:	6422                	ld	s0,8(sp)
    8000020c:	0141                	addi	sp,sp,16
    8000020e:	8082                	ret
  for (n = 0; s[n]; n++);
    80000210:	4501                	li	a0,0
    80000212:	bfe5                	j	8000020a <strlen+0x20>

0000000080000214 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000214:	1141                	addi	sp,sp,-16
    80000216:	e406                	sd	ra,8(sp)
    80000218:	e022                	sd	s0,0(sp)
    8000021a:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    8000021c:	00001097          	auipc	ra,0x1
    80000220:	bba080e7          	jalr	-1094(ra) # 80000dd6 <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    80000224:	0000b717          	auipc	a4,0xb
    80000228:	66c70713          	addi	a4,a4,1644 # 8000b890 <started>
  if (cpuid() == 0) {
    8000022c:	c139                	beqz	a0,80000272 <main+0x5e>
    while (started == 0);
    8000022e:	431c                	lw	a5,0(a4)
    80000230:	2781                	sext.w	a5,a5
    80000232:	dff5                	beqz	a5,8000022e <main+0x1a>
    __sync_synchronize();
    80000234:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000238:	00001097          	auipc	ra,0x1
    8000023c:	b9e080e7          	jalr	-1122(ra) # 80000dd6 <cpuid>
    80000240:	85aa                	mv	a1,a0
    80000242:	00008517          	auipc	a0,0x8
    80000246:	dde50513          	addi	a0,a0,-546 # 80008020 <etext+0x20>
    8000024a:	00006097          	auipc	ra,0x6
    8000024e:	744080e7          	jalr	1860(ra) # 8000698e <printf>
    kvminithart();   // turn on paging
    80000252:	00000097          	auipc	ra,0x0
    80000256:	0d8080e7          	jalr	216(ra) # 8000032a <kvminithart>
    trapinithart();  // install kernel trap vector
    8000025a:	00002097          	auipc	ra,0x2
    8000025e:	84e080e7          	jalr	-1970(ra) # 80001aa8 <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    80000262:	00005097          	auipc	ra,0x5
    80000266:	e62080e7          	jalr	-414(ra) # 800050c4 <plicinithart>
  }

  scheduler();
    8000026a:	00001097          	auipc	ra,0x1
    8000026e:	094080e7          	jalr	148(ra) # 800012fe <scheduler>
    consoleinit();
    80000272:	00006097          	auipc	ra,0x6
    80000276:	5e2080e7          	jalr	1506(ra) # 80006854 <consoleinit>
    printfinit();
    8000027a:	00007097          	auipc	ra,0x7
    8000027e:	91c080e7          	jalr	-1764(ra) # 80006b96 <printfinit>
    printf("\n");
    80000282:	00008517          	auipc	a0,0x8
    80000286:	d7e50513          	addi	a0,a0,-642 # 80008000 <etext>
    8000028a:	00006097          	auipc	ra,0x6
    8000028e:	704080e7          	jalr	1796(ra) # 8000698e <printf>
    printf("xv6 kernel is booting\n");
    80000292:	00008517          	auipc	a0,0x8
    80000296:	d7650513          	addi	a0,a0,-650 # 80008008 <etext+0x8>
    8000029a:	00006097          	auipc	ra,0x6
    8000029e:	6f4080e7          	jalr	1780(ra) # 8000698e <printf>
    printf("\n");
    800002a2:	00008517          	auipc	a0,0x8
    800002a6:	d5e50513          	addi	a0,a0,-674 # 80008000 <etext>
    800002aa:	00006097          	auipc	ra,0x6
    800002ae:	6e4080e7          	jalr	1764(ra) # 8000698e <printf>
    kinit();             // physical page allocator
    800002b2:	00000097          	auipc	ra,0x0
    800002b6:	d6a080e7          	jalr	-662(ra) # 8000001c <kinit>
    kvminit();           // create kernel page table
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	34a080e7          	jalr	842(ra) # 80000604 <kvminit>
    kvminithart();       // turn on paging
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	068080e7          	jalr	104(ra) # 8000032a <kvminithart>
    procinit();          // process table
    800002ca:	00001097          	auipc	ra,0x1
    800002ce:	a4a080e7          	jalr	-1462(ra) # 80000d14 <procinit>
    trapinit();          // trap vectors
    800002d2:	00001097          	auipc	ra,0x1
    800002d6:	7ae080e7          	jalr	1966(ra) # 80001a80 <trapinit>
    trapinithart();      // install kernel trap vector
    800002da:	00001097          	auipc	ra,0x1
    800002de:	7ce080e7          	jalr	1998(ra) # 80001aa8 <trapinithart>
    plicinit();          // set up interrupt controller
    800002e2:	00005097          	auipc	ra,0x5
    800002e6:	dc8080e7          	jalr	-568(ra) # 800050aa <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800002ea:	00005097          	auipc	ra,0x5
    800002ee:	dda080e7          	jalr	-550(ra) # 800050c4 <plicinithart>
    binit();             // buffer cache
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	f0c080e7          	jalr	-244(ra) # 800021fe <binit>
    iinit();             // inode table
    800002fa:	00002097          	auipc	ra,0x2
    800002fe:	5c2080e7          	jalr	1474(ra) # 800028bc <iinit>
    fileinit();          // file table
    80000302:	00003097          	auipc	ra,0x3
    80000306:	572080e7          	jalr	1394(ra) # 80003874 <fileinit>
    virtio_disk_init();  // emulated hard disk
    8000030a:	00005097          	auipc	ra,0x5
    8000030e:	ec2080e7          	jalr	-318(ra) # 800051cc <virtio_disk_init>
    userinit();          // first user process
    80000312:	00001097          	auipc	ra,0x1
    80000316:	dcc080e7          	jalr	-564(ra) # 800010de <userinit>
    __sync_synchronize();
    8000031a:	0330000f          	fence	rw,rw
    started = 1;
    8000031e:	4785                	li	a5,1
    80000320:	0000b717          	auipc	a4,0xb
    80000324:	56f72823          	sw	a5,1392(a4) # 8000b890 <started>
    80000328:	b789                	j	8000026a <main+0x56>

000000008000032a <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    8000032a:	1141                	addi	sp,sp,-16
    8000032c:	e422                	sd	s0,8(sp)
    8000032e:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000330:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000334:	0000b797          	auipc	a5,0xb
    80000338:	5647b783          	ld	a5,1380(a5) # 8000b898 <kernel_pagetable>
    8000033c:	83b1                	srli	a5,a5,0xc
    8000033e:	577d                	li	a4,-1
    80000340:	177e                	slli	a4,a4,0x3f
    80000342:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000344:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000348:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000034c:	6422                	ld	s0,8(sp)
    8000034e:	0141                	addi	sp,sp,16
    80000350:	8082                	ret

0000000080000352 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000352:	7139                	addi	sp,sp,-64
    80000354:	fc06                	sd	ra,56(sp)
    80000356:	f822                	sd	s0,48(sp)
    80000358:	f426                	sd	s1,40(sp)
    8000035a:	f04a                	sd	s2,32(sp)
    8000035c:	ec4e                	sd	s3,24(sp)
    8000035e:	e852                	sd	s4,16(sp)
    80000360:	e456                	sd	s5,8(sp)
    80000362:	e05a                	sd	s6,0(sp)
    80000364:	0080                	addi	s0,sp,64
    80000366:	84aa                	mv	s1,a0
    80000368:	89ae                	mv	s3,a1
    8000036a:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    8000036c:	57fd                	li	a5,-1
    8000036e:	83e9                	srli	a5,a5,0x1a
    80000370:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    80000372:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000374:	04b7f263          	bgeu	a5,a1,800003b8 <walk+0x66>
    80000378:	00008517          	auipc	a0,0x8
    8000037c:	cc050513          	addi	a0,a0,-832 # 80008038 <etext+0x38>
    80000380:	00006097          	auipc	ra,0x6
    80000384:	5c4080e7          	jalr	1476(ra) # 80006944 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000388:	060a8663          	beqz	s5,800003f4 <walk+0xa2>
    8000038c:	00000097          	auipc	ra,0x0
    80000390:	cd0080e7          	jalr	-816(ra) # 8000005c <kalloc>
    80000394:	84aa                	mv	s1,a0
    80000396:	c529                	beqz	a0,800003e0 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000398:	6605                	lui	a2,0x1
    8000039a:	4581                	li	a1,0
    8000039c:	00000097          	auipc	ra,0x0
    800003a0:	cda080e7          	jalr	-806(ra) # 80000076 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003a4:	00c4d793          	srli	a5,s1,0xc
    800003a8:	07aa                	slli	a5,a5,0xa
    800003aa:	0017e793          	ori	a5,a5,1
    800003ae:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800003b2:	3a5d                	addiw	s4,s4,-9
    800003b4:	036a0063          	beq	s4,s6,800003d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800003b8:	0149d933          	srl	s2,s3,s4
    800003bc:	1ff97913          	andi	s2,s2,511
    800003c0:	090e                	slli	s2,s2,0x3
    800003c2:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800003c4:	00093483          	ld	s1,0(s2)
    800003c8:	0014f793          	andi	a5,s1,1
    800003cc:	dfd5                	beqz	a5,80000388 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800003ce:	80a9                	srli	s1,s1,0xa
    800003d0:	04b2                	slli	s1,s1,0xc
    800003d2:	b7c5                	j	800003b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800003d4:	00c9d513          	srli	a0,s3,0xc
    800003d8:	1ff57513          	andi	a0,a0,511
    800003dc:	050e                	slli	a0,a0,0x3
    800003de:	9526                	add	a0,a0,s1
}
    800003e0:	70e2                	ld	ra,56(sp)
    800003e2:	7442                	ld	s0,48(sp)
    800003e4:	74a2                	ld	s1,40(sp)
    800003e6:	7902                	ld	s2,32(sp)
    800003e8:	69e2                	ld	s3,24(sp)
    800003ea:	6a42                	ld	s4,16(sp)
    800003ec:	6aa2                	ld	s5,8(sp)
    800003ee:	6b02                	ld	s6,0(sp)
    800003f0:	6121                	addi	sp,sp,64
    800003f2:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800003f4:	4501                	li	a0,0
    800003f6:	b7ed                	j	800003e0 <walk+0x8e>

00000000800003f8 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    800003f8:	57fd                	li	a5,-1
    800003fa:	83e9                	srli	a5,a5,0x1a
    800003fc:	00b7f463          	bgeu	a5,a1,80000404 <walkaddr+0xc>
    80000400:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000402:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000404:	1141                	addi	sp,sp,-16
    80000406:	e406                	sd	ra,8(sp)
    80000408:	e022                	sd	s0,0(sp)
    8000040a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000040c:	4601                	li	a2,0
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	f44080e7          	jalr	-188(ra) # 80000352 <walk>
  if (pte == 0) return 0;
    80000416:	c105                	beqz	a0,80000436 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000418:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    8000041a:	0117f693          	andi	a3,a5,17
    8000041e:	4745                	li	a4,17
    80000420:	4501                	li	a0,0
    80000422:	00e68663          	beq	a3,a4,8000042e <walkaddr+0x36>
}
    80000426:	60a2                	ld	ra,8(sp)
    80000428:	6402                	ld	s0,0(sp)
    8000042a:	0141                	addi	sp,sp,16
    8000042c:	8082                	ret
  pa = PTE2PA(*pte);
    8000042e:	83a9                	srli	a5,a5,0xa
    80000430:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000434:	bfcd                	j	80000426 <walkaddr+0x2e>
  if (pte == 0) return 0;
    80000436:	4501                	li	a0,0
    80000438:	b7fd                	j	80000426 <walkaddr+0x2e>

000000008000043a <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000043a:	715d                	addi	sp,sp,-80
    8000043c:	e486                	sd	ra,72(sp)
    8000043e:	e0a2                	sd	s0,64(sp)
    80000440:	fc26                	sd	s1,56(sp)
    80000442:	f84a                	sd	s2,48(sp)
    80000444:	f44e                	sd	s3,40(sp)
    80000446:	f052                	sd	s4,32(sp)
    80000448:	ec56                	sd	s5,24(sp)
    8000044a:	e85a                	sd	s6,16(sp)
    8000044c:	e45e                	sd	s7,8(sp)
    8000044e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    80000450:	03459793          	slli	a5,a1,0x34
    80000454:	e7b9                	bnez	a5,800004a2 <mappages+0x68>
    80000456:	8aaa                	mv	s5,a0
    80000458:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    8000045a:	03461793          	slli	a5,a2,0x34
    8000045e:	ebb1                	bnez	a5,800004b2 <mappages+0x78>

  if (size == 0) panic("mappages: size");
    80000460:	c22d                	beqz	a2,800004c2 <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    80000462:	77fd                	lui	a5,0xfffff
    80000464:	963e                	add	a2,a2,a5
    80000466:	00b609b3          	add	s3,a2,a1
  a = va;
    8000046a:	892e                	mv	s2,a1
    8000046c:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000470:	6b85                	lui	s7,0x1
    80000472:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000476:	4605                	li	a2,1
    80000478:	85ca                	mv	a1,s2
    8000047a:	8556                	mv	a0,s5
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	ed6080e7          	jalr	-298(ra) # 80000352 <walk>
    80000484:	cd39                	beqz	a0,800004e2 <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    80000486:	611c                	ld	a5,0(a0)
    80000488:	8b85                	andi	a5,a5,1
    8000048a:	e7a1                	bnez	a5,800004d2 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000048c:	80b1                	srli	s1,s1,0xc
    8000048e:	04aa                	slli	s1,s1,0xa
    80000490:	0164e4b3          	or	s1,s1,s6
    80000494:	0014e493          	ori	s1,s1,1
    80000498:	e104                	sd	s1,0(a0)
    if (a == last) break;
    8000049a:	07390063          	beq	s2,s3,800004fa <mappages+0xc0>
    a += PGSIZE;
    8000049e:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800004a0:	bfc9                	j	80000472 <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800004a2:	00008517          	auipc	a0,0x8
    800004a6:	b9e50513          	addi	a0,a0,-1122 # 80008040 <etext+0x40>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	49a080e7          	jalr	1178(ra) # 80006944 <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    800004b2:	00008517          	auipc	a0,0x8
    800004b6:	bae50513          	addi	a0,a0,-1106 # 80008060 <etext+0x60>
    800004ba:	00006097          	auipc	ra,0x6
    800004be:	48a080e7          	jalr	1162(ra) # 80006944 <panic>
  if (size == 0) panic("mappages: size");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	bbe50513          	addi	a0,a0,-1090 # 80008080 <etext+0x80>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	47a080e7          	jalr	1146(ra) # 80006944 <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800004d2:	00008517          	auipc	a0,0x8
    800004d6:	bbe50513          	addi	a0,a0,-1090 # 80008090 <etext+0x90>
    800004da:	00006097          	auipc	ra,0x6
    800004de:	46a080e7          	jalr	1130(ra) # 80006944 <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800004e2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800004e4:	60a6                	ld	ra,72(sp)
    800004e6:	6406                	ld	s0,64(sp)
    800004e8:	74e2                	ld	s1,56(sp)
    800004ea:	7942                	ld	s2,48(sp)
    800004ec:	79a2                	ld	s3,40(sp)
    800004ee:	7a02                	ld	s4,32(sp)
    800004f0:	6ae2                	ld	s5,24(sp)
    800004f2:	6b42                	ld	s6,16(sp)
    800004f4:	6ba2                	ld	s7,8(sp)
    800004f6:	6161                	addi	sp,sp,80
    800004f8:	8082                	ret
  return 0;
    800004fa:	4501                	li	a0,0
    800004fc:	b7e5                	j	800004e4 <mappages+0xaa>

00000000800004fe <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800004fe:	1141                	addi	sp,sp,-16
    80000500:	e406                	sd	ra,8(sp)
    80000502:	e022                	sd	s0,0(sp)
    80000504:	0800                	addi	s0,sp,16
    80000506:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000508:	86b2                	mv	a3,a2
    8000050a:	863e                	mv	a2,a5
    8000050c:	00000097          	auipc	ra,0x0
    80000510:	f2e080e7          	jalr	-210(ra) # 8000043a <mappages>
    80000514:	e509                	bnez	a0,8000051e <kvmmap+0x20>
}
    80000516:	60a2                	ld	ra,8(sp)
    80000518:	6402                	ld	s0,0(sp)
    8000051a:	0141                	addi	sp,sp,16
    8000051c:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    8000051e:	00008517          	auipc	a0,0x8
    80000522:	b8250513          	addi	a0,a0,-1150 # 800080a0 <etext+0xa0>
    80000526:	00006097          	auipc	ra,0x6
    8000052a:	41e080e7          	jalr	1054(ra) # 80006944 <panic>

000000008000052e <kvmmake>:
pagetable_t kvmmake(void) {
    8000052e:	1101                	addi	sp,sp,-32
    80000530:	ec06                	sd	ra,24(sp)
    80000532:	e822                	sd	s0,16(sp)
    80000534:	e426                	sd	s1,8(sp)
    80000536:	e04a                	sd	s2,0(sp)
    80000538:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000053a:	00000097          	auipc	ra,0x0
    8000053e:	b22080e7          	jalr	-1246(ra) # 8000005c <kalloc>
    80000542:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000544:	6605                	lui	a2,0x1
    80000546:	4581                	li	a1,0
    80000548:	00000097          	auipc	ra,0x0
    8000054c:	b2e080e7          	jalr	-1234(ra) # 80000076 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000550:	4719                	li	a4,6
    80000552:	6685                	lui	a3,0x1
    80000554:	10000637          	lui	a2,0x10000
    80000558:	100005b7          	lui	a1,0x10000
    8000055c:	8526                	mv	a0,s1
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	fa0080e7          	jalr	-96(ra) # 800004fe <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000566:	4719                	li	a4,6
    80000568:	6685                	lui	a3,0x1
    8000056a:	10001637          	lui	a2,0x10001
    8000056e:	100015b7          	lui	a1,0x10001
    80000572:	8526                	mv	a0,s1
    80000574:	00000097          	auipc	ra,0x0
    80000578:	f8a080e7          	jalr	-118(ra) # 800004fe <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000057c:	4719                	li	a4,6
    8000057e:	004006b7          	lui	a3,0x400
    80000582:	0c000637          	lui	a2,0xc000
    80000586:	0c0005b7          	lui	a1,0xc000
    8000058a:	8526                	mv	a0,s1
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	f72080e7          	jalr	-142(ra) # 800004fe <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000594:	00008917          	auipc	s2,0x8
    80000598:	a6c90913          	addi	s2,s2,-1428 # 80008000 <etext>
    8000059c:	4729                	li	a4,10
    8000059e:	80008697          	auipc	a3,0x80008
    800005a2:	a6268693          	addi	a3,a3,-1438 # 8000 <_entry-0x7fff8000>
    800005a6:	4605                	li	a2,1
    800005a8:	067e                	slli	a2,a2,0x1f
    800005aa:	85b2                	mv	a1,a2
    800005ac:	8526                	mv	a0,s1
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	f50080e7          	jalr	-176(ra) # 800004fe <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800005b6:	46c5                	li	a3,17
    800005b8:	06ee                	slli	a3,a3,0x1b
    800005ba:	4719                	li	a4,6
    800005bc:	412686b3          	sub	a3,a3,s2
    800005c0:	864a                	mv	a2,s2
    800005c2:	85ca                	mv	a1,s2
    800005c4:	8526                	mv	a0,s1
    800005c6:	00000097          	auipc	ra,0x0
    800005ca:	f38080e7          	jalr	-200(ra) # 800004fe <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005ce:	4729                	li	a4,10
    800005d0:	6685                	lui	a3,0x1
    800005d2:	00007617          	auipc	a2,0x7
    800005d6:	a2e60613          	addi	a2,a2,-1490 # 80007000 <_trampoline>
    800005da:	040005b7          	lui	a1,0x4000
    800005de:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005e0:	05b2                	slli	a1,a1,0xc
    800005e2:	8526                	mv	a0,s1
    800005e4:	00000097          	auipc	ra,0x0
    800005e8:	f1a080e7          	jalr	-230(ra) # 800004fe <kvmmap>
  proc_mapstacks(kpgtbl);
    800005ec:	8526                	mv	a0,s1
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	682080e7          	jalr	1666(ra) # 80000c70 <proc_mapstacks>
}
    800005f6:	8526                	mv	a0,s1
    800005f8:	60e2                	ld	ra,24(sp)
    800005fa:	6442                	ld	s0,16(sp)
    800005fc:	64a2                	ld	s1,8(sp)
    800005fe:	6902                	ld	s2,0(sp)
    80000600:	6105                	addi	sp,sp,32
    80000602:	8082                	ret

0000000080000604 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    80000604:	1141                	addi	sp,sp,-16
    80000606:	e406                	sd	ra,8(sp)
    80000608:	e022                	sd	s0,0(sp)
    8000060a:	0800                	addi	s0,sp,16
    8000060c:	00000097          	auipc	ra,0x0
    80000610:	f22080e7          	jalr	-222(ra) # 8000052e <kvmmake>
    80000614:	0000b797          	auipc	a5,0xb
    80000618:	28a7b223          	sd	a0,644(a5) # 8000b898 <kernel_pagetable>
    8000061c:	60a2                	ld	ra,8(sp)
    8000061e:	6402                	ld	s0,0(sp)
    80000620:	0141                	addi	sp,sp,16
    80000622:	8082                	ret

0000000080000624 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80000624:	715d                	addi	sp,sp,-80
    80000626:	e486                	sd	ra,72(sp)
    80000628:	e0a2                	sd	s0,64(sp)
    8000062a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    8000062c:	03459793          	slli	a5,a1,0x34
    80000630:	e39d                	bnez	a5,80000656 <uvmunmap+0x32>
    80000632:	f84a                	sd	s2,48(sp)
    80000634:	f44e                	sd	s3,40(sp)
    80000636:	f052                	sd	s4,32(sp)
    80000638:	ec56                	sd	s5,24(sp)
    8000063a:	e85a                	sd	s6,16(sp)
    8000063c:	e45e                	sd	s7,8(sp)
    8000063e:	8a2a                	mv	s4,a0
    80000640:	892e                	mv	s2,a1
    80000642:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000644:	0632                	slli	a2,a2,0xc
    80000646:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000064a:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000064c:	6b05                	lui	s6,0x1
    8000064e:	0935fb63          	bgeu	a1,s3,800006e4 <uvmunmap+0xc0>
    80000652:	fc26                	sd	s1,56(sp)
    80000654:	a8a9                	j	800006ae <uvmunmap+0x8a>
    80000656:	fc26                	sd	s1,56(sp)
    80000658:	f84a                	sd	s2,48(sp)
    8000065a:	f44e                	sd	s3,40(sp)
    8000065c:	f052                	sd	s4,32(sp)
    8000065e:	ec56                	sd	s5,24(sp)
    80000660:	e85a                	sd	s6,16(sp)
    80000662:	e45e                	sd	s7,8(sp)
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000664:	00008517          	auipc	a0,0x8
    80000668:	a4450513          	addi	a0,a0,-1468 # 800080a8 <etext+0xa8>
    8000066c:	00006097          	auipc	ra,0x6
    80000670:	2d8080e7          	jalr	728(ra) # 80006944 <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000674:	00008517          	auipc	a0,0x8
    80000678:	a4c50513          	addi	a0,a0,-1460 # 800080c0 <etext+0xc0>
    8000067c:	00006097          	auipc	ra,0x6
    80000680:	2c8080e7          	jalr	712(ra) # 80006944 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000684:	00008517          	auipc	a0,0x8
    80000688:	a4c50513          	addi	a0,a0,-1460 # 800080d0 <etext+0xd0>
    8000068c:	00006097          	auipc	ra,0x6
    80000690:	2b8080e7          	jalr	696(ra) # 80006944 <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000694:	00008517          	auipc	a0,0x8
    80000698:	a5450513          	addi	a0,a0,-1452 # 800080e8 <etext+0xe8>
    8000069c:	00006097          	auipc	ra,0x6
    800006a0:	2a8080e7          	jalr	680(ra) # 80006944 <panic>
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800006a4:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800006a8:	995a                	add	s2,s2,s6
    800006aa:	03397c63          	bgeu	s2,s3,800006e2 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    800006ae:	4601                	li	a2,0
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8552                	mv	a0,s4
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	c9e080e7          	jalr	-866(ra) # 80000352 <walk>
    800006bc:	84aa                	mv	s1,a0
    800006be:	d95d                	beqz	a0,80000674 <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800006c0:	6108                	ld	a0,0(a0)
    800006c2:	00157793          	andi	a5,a0,1
    800006c6:	dfdd                	beqz	a5,80000684 <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800006c8:	3ff57793          	andi	a5,a0,1023
    800006cc:	fd7784e3          	beq	a5,s7,80000694 <uvmunmap+0x70>
    if (do_free) {
    800006d0:	fc0a8ae3          	beqz	s5,800006a4 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800006d4:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800006d6:	0532                	slli	a0,a0,0xc
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	96c080e7          	jalr	-1684(ra) # 80000044 <kfree>
    800006e0:	b7d1                	j	800006a4 <uvmunmap+0x80>
    800006e2:	74e2                	ld	s1,56(sp)
    800006e4:	7942                	ld	s2,48(sp)
    800006e6:	79a2                	ld	s3,40(sp)
    800006e8:	7a02                	ld	s4,32(sp)
    800006ea:	6ae2                	ld	s5,24(sp)
    800006ec:	6b42                	ld	s6,16(sp)
    800006ee:	6ba2                	ld	s7,8(sp)
  }
}
    800006f0:	60a6                	ld	ra,72(sp)
    800006f2:	6406                	ld	s0,64(sp)
    800006f4:	6161                	addi	sp,sp,80
    800006f6:	8082                	ret

00000000800006f8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800006f8:	1101                	addi	sp,sp,-32
    800006fa:	ec06                	sd	ra,24(sp)
    800006fc:	e822                	sd	s0,16(sp)
    800006fe:	e426                	sd	s1,8(sp)
    80000700:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000702:	00000097          	auipc	ra,0x0
    80000706:	95a080e7          	jalr	-1702(ra) # 8000005c <kalloc>
    8000070a:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    8000070c:	c519                	beqz	a0,8000071a <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    8000070e:	6605                	lui	a2,0x1
    80000710:	4581                	li	a1,0
    80000712:	00000097          	auipc	ra,0x0
    80000716:	964080e7          	jalr	-1692(ra) # 80000076 <memset>
  return pagetable;
}
    8000071a:	8526                	mv	a0,s1
    8000071c:	60e2                	ld	ra,24(sp)
    8000071e:	6442                	ld	s0,16(sp)
    80000720:	64a2                	ld	s1,8(sp)
    80000722:	6105                	addi	sp,sp,32
    80000724:	8082                	ret

0000000080000726 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    80000726:	7179                	addi	sp,sp,-48
    80000728:	f406                	sd	ra,40(sp)
    8000072a:	f022                	sd	s0,32(sp)
    8000072c:	ec26                	sd	s1,24(sp)
    8000072e:	e84a                	sd	s2,16(sp)
    80000730:	e44e                	sd	s3,8(sp)
    80000732:	e052                	sd	s4,0(sp)
    80000734:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000736:	6785                	lui	a5,0x1
    80000738:	04f67863          	bgeu	a2,a5,80000788 <uvmfirst+0x62>
    8000073c:	8a2a                	mv	s4,a0
    8000073e:	89ae                	mv	s3,a1
    80000740:	84b2                	mv	s1,a2
  mem = kalloc();
    80000742:	00000097          	auipc	ra,0x0
    80000746:	91a080e7          	jalr	-1766(ra) # 8000005c <kalloc>
    8000074a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000074c:	6605                	lui	a2,0x1
    8000074e:	4581                	li	a1,0
    80000750:	00000097          	auipc	ra,0x0
    80000754:	926080e7          	jalr	-1754(ra) # 80000076 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000758:	4779                	li	a4,30
    8000075a:	86ca                	mv	a3,s2
    8000075c:	6605                	lui	a2,0x1
    8000075e:	4581                	li	a1,0
    80000760:	8552                	mv	a0,s4
    80000762:	00000097          	auipc	ra,0x0
    80000766:	cd8080e7          	jalr	-808(ra) # 8000043a <mappages>
  memmove(mem, src, sz);
    8000076a:	8626                	mv	a2,s1
    8000076c:	85ce                	mv	a1,s3
    8000076e:	854a                	mv	a0,s2
    80000770:	00000097          	auipc	ra,0x0
    80000774:	962080e7          	jalr	-1694(ra) # 800000d2 <memmove>
}
    80000778:	70a2                	ld	ra,40(sp)
    8000077a:	7402                	ld	s0,32(sp)
    8000077c:	64e2                	ld	s1,24(sp)
    8000077e:	6942                	ld	s2,16(sp)
    80000780:	69a2                	ld	s3,8(sp)
    80000782:	6a02                	ld	s4,0(sp)
    80000784:	6145                	addi	sp,sp,48
    80000786:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	97850513          	addi	a0,a0,-1672 # 80008100 <etext+0x100>
    80000790:	00006097          	auipc	ra,0x6
    80000794:	1b4080e7          	jalr	436(ra) # 80006944 <panic>

0000000080000798 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000798:	1101                	addi	sp,sp,-32
    8000079a:	ec06                	sd	ra,24(sp)
    8000079c:	e822                	sd	s0,16(sp)
    8000079e:	e426                	sd	s1,8(sp)
    800007a0:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    800007a2:	84ae                	mv	s1,a1
    800007a4:	00b67d63          	bgeu	a2,a1,800007be <uvmdealloc+0x26>
    800007a8:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800007aa:	6785                	lui	a5,0x1
    800007ac:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ae:	00f60733          	add	a4,a2,a5
    800007b2:	76fd                	lui	a3,0xfffff
    800007b4:	8f75                	and	a4,a4,a3
    800007b6:	97ae                	add	a5,a5,a1
    800007b8:	8ff5                	and	a5,a5,a3
    800007ba:	00f76863          	bltu	a4,a5,800007ca <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007be:	8526                	mv	a0,s1
    800007c0:	60e2                	ld	ra,24(sp)
    800007c2:	6442                	ld	s0,16(sp)
    800007c4:	64a2                	ld	s1,8(sp)
    800007c6:	6105                	addi	sp,sp,32
    800007c8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007ca:	8f99                	sub	a5,a5,a4
    800007cc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ce:	4685                	li	a3,1
    800007d0:	0007861b          	sext.w	a2,a5
    800007d4:	85ba                	mv	a1,a4
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	e4e080e7          	jalr	-434(ra) # 80000624 <uvmunmap>
    800007de:	b7c5                	j	800007be <uvmdealloc+0x26>

00000000800007e0 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800007e0:	0ab66b63          	bltu	a2,a1,80000896 <uvmalloc+0xb6>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800007e4:	7139                	addi	sp,sp,-64
    800007e6:	fc06                	sd	ra,56(sp)
    800007e8:	f822                	sd	s0,48(sp)
    800007ea:	ec4e                	sd	s3,24(sp)
    800007ec:	e852                	sd	s4,16(sp)
    800007ee:	e456                	sd	s5,8(sp)
    800007f0:	0080                	addi	s0,sp,64
    800007f2:	8aaa                	mv	s5,a0
    800007f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007f6:	6785                	lui	a5,0x1
    800007f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fa:	95be                	add	a1,a1,a5
    800007fc:	77fd                	lui	a5,0xfffff
    800007fe:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000802:	08c9fc63          	bgeu	s3,a2,8000089a <uvmalloc+0xba>
    80000806:	f426                	sd	s1,40(sp)
    80000808:	f04a                	sd	s2,32(sp)
    8000080a:	e05a                	sd	s6,0(sp)
    8000080c:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000080e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	84a080e7          	jalr	-1974(ra) # 8000005c <kalloc>
    8000081a:	84aa                	mv	s1,a0
    if (mem == 0) {
    8000081c:	c915                	beqz	a0,80000850 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	854080e7          	jalr	-1964(ra) # 80000076 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000082a:	875a                	mv	a4,s6
    8000082c:	86a6                	mv	a3,s1
    8000082e:	6605                	lui	a2,0x1
    80000830:	85ca                	mv	a1,s2
    80000832:	8556                	mv	a0,s5
    80000834:	00000097          	auipc	ra,0x0
    80000838:	c06080e7          	jalr	-1018(ra) # 8000043a <mappages>
    8000083c:	ed05                	bnez	a0,80000874 <uvmalloc+0x94>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000083e:	6785                	lui	a5,0x1
    80000840:	993e                	add	s2,s2,a5
    80000842:	fd4968e3          	bltu	s2,s4,80000812 <uvmalloc+0x32>
  return newsz;
    80000846:	8552                	mv	a0,s4
    80000848:	74a2                	ld	s1,40(sp)
    8000084a:	7902                	ld	s2,32(sp)
    8000084c:	6b02                	ld	s6,0(sp)
    8000084e:	a821                	j	80000866 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000850:	864e                	mv	a2,s3
    80000852:	85ca                	mv	a1,s2
    80000854:	8556                	mv	a0,s5
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	f42080e7          	jalr	-190(ra) # 80000798 <uvmdealloc>
      return 0;
    8000085e:	4501                	li	a0,0
    80000860:	74a2                	ld	s1,40(sp)
    80000862:	7902                	ld	s2,32(sp)
    80000864:	6b02                	ld	s6,0(sp)
}
    80000866:	70e2                	ld	ra,56(sp)
    80000868:	7442                	ld	s0,48(sp)
    8000086a:	69e2                	ld	s3,24(sp)
    8000086c:	6a42                	ld	s4,16(sp)
    8000086e:	6aa2                	ld	s5,8(sp)
    80000870:	6121                	addi	sp,sp,64
    80000872:	8082                	ret
      kfree(mem);
    80000874:	8526                	mv	a0,s1
    80000876:	fffff097          	auipc	ra,0xfffff
    8000087a:	7ce080e7          	jalr	1998(ra) # 80000044 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000087e:	864e                	mv	a2,s3
    80000880:	85ca                	mv	a1,s2
    80000882:	8556                	mv	a0,s5
    80000884:	00000097          	auipc	ra,0x0
    80000888:	f14080e7          	jalr	-236(ra) # 80000798 <uvmdealloc>
      return 0;
    8000088c:	4501                	li	a0,0
    8000088e:	74a2                	ld	s1,40(sp)
    80000890:	7902                	ld	s2,32(sp)
    80000892:	6b02                	ld	s6,0(sp)
    80000894:	bfc9                	j	80000866 <uvmalloc+0x86>
  if (newsz < oldsz) return oldsz;
    80000896:	852e                	mv	a0,a1
}
    80000898:	8082                	ret
  return newsz;
    8000089a:	8532                	mv	a0,a2
    8000089c:	b7e9                	j	80000866 <uvmalloc+0x86>

000000008000089e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    8000089e:	7179                	addi	sp,sp,-48
    800008a0:	f406                	sd	ra,40(sp)
    800008a2:	f022                	sd	s0,32(sp)
    800008a4:	ec26                	sd	s1,24(sp)
    800008a6:	e84a                	sd	s2,16(sp)
    800008a8:	e44e                	sd	s3,8(sp)
    800008aa:	e052                	sd	s4,0(sp)
    800008ac:	1800                	addi	s0,sp,48
    800008ae:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800008b0:	84aa                	mv	s1,a0
    800008b2:	6905                	lui	s2,0x1
    800008b4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800008b6:	4985                	li	s3,1
    800008b8:	a829                	j	800008d2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008ba:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008bc:	00c79513          	slli	a0,a5,0xc
    800008c0:	00000097          	auipc	ra,0x0
    800008c4:	fde080e7          	jalr	-34(ra) # 8000089e <freewalk>
      pagetable[i] = 0;
    800008c8:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    800008cc:	04a1                	addi	s1,s1,8
    800008ce:	03248163          	beq	s1,s2,800008f0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800008d2:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800008d4:	00f7f713          	andi	a4,a5,15
    800008d8:	ff3701e3          	beq	a4,s3,800008ba <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800008dc:	8b85                	andi	a5,a5,1
    800008de:	d7fd                	beqz	a5,800008cc <freewalk+0x2e>
      panic("freewalk: leaf");
    800008e0:	00008517          	auipc	a0,0x8
    800008e4:	84050513          	addi	a0,a0,-1984 # 80008120 <etext+0x120>
    800008e8:	00006097          	auipc	ra,0x6
    800008ec:	05c080e7          	jalr	92(ra) # 80006944 <panic>
    }
  }
  kfree((void *)pagetable);
    800008f0:	8552                	mv	a0,s4
    800008f2:	fffff097          	auipc	ra,0xfffff
    800008f6:	752080e7          	jalr	1874(ra) # 80000044 <kfree>
}
    800008fa:	70a2                	ld	ra,40(sp)
    800008fc:	7402                	ld	s0,32(sp)
    800008fe:	64e2                	ld	s1,24(sp)
    80000900:	6942                	ld	s2,16(sp)
    80000902:	69a2                	ld	s3,8(sp)
    80000904:	6a02                	ld	s4,0(sp)
    80000906:	6145                	addi	sp,sp,48
    80000908:	8082                	ret

000000008000090a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    8000090a:	1101                	addi	sp,sp,-32
    8000090c:	ec06                	sd	ra,24(sp)
    8000090e:	e822                	sd	s0,16(sp)
    80000910:	e426                	sd	s1,8(sp)
    80000912:	1000                	addi	s0,sp,32
    80000914:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000916:	e999                	bnez	a1,8000092c <uvmfree+0x22>
  freewalk(pagetable);
    80000918:	8526                	mv	a0,s1
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	f84080e7          	jalr	-124(ra) # 8000089e <freewalk>
}
    80000922:	60e2                	ld	ra,24(sp)
    80000924:	6442                	ld	s0,16(sp)
    80000926:	64a2                	ld	s1,8(sp)
    80000928:	6105                	addi	sp,sp,32
    8000092a:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    8000092c:	6785                	lui	a5,0x1
    8000092e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000930:	95be                	add	a1,a1,a5
    80000932:	4685                	li	a3,1
    80000934:	00c5d613          	srli	a2,a1,0xc
    80000938:	4581                	li	a1,0
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	cea080e7          	jalr	-790(ra) # 80000624 <uvmunmap>
    80000942:	bfd9                	j	80000918 <uvmfree+0xe>

0000000080000944 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000944:	c679                	beqz	a2,80000a12 <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000946:	715d                	addi	sp,sp,-80
    80000948:	e486                	sd	ra,72(sp)
    8000094a:	e0a2                	sd	s0,64(sp)
    8000094c:	fc26                	sd	s1,56(sp)
    8000094e:	f84a                	sd	s2,48(sp)
    80000950:	f44e                	sd	s3,40(sp)
    80000952:	f052                	sd	s4,32(sp)
    80000954:	ec56                	sd	s5,24(sp)
    80000956:	e85a                	sd	s6,16(sp)
    80000958:	e45e                	sd	s7,8(sp)
    8000095a:	0880                	addi	s0,sp,80
    8000095c:	8b2a                	mv	s6,a0
    8000095e:	8aae                	mv	s5,a1
    80000960:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000962:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000964:	4601                	li	a2,0
    80000966:	85ce                	mv	a1,s3
    80000968:	855a                	mv	a0,s6
    8000096a:	00000097          	auipc	ra,0x0
    8000096e:	9e8080e7          	jalr	-1560(ra) # 80000352 <walk>
    80000972:	c531                	beqz	a0,800009be <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000974:	6118                	ld	a4,0(a0)
    80000976:	00177793          	andi	a5,a4,1
    8000097a:	cbb1                	beqz	a5,800009ce <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    8000097c:	00a75593          	srli	a1,a4,0xa
    80000980:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000984:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000988:	fffff097          	auipc	ra,0xfffff
    8000098c:	6d4080e7          	jalr	1748(ra) # 8000005c <kalloc>
    80000990:	892a                	mv	s2,a0
    80000992:	c939                	beqz	a0,800009e8 <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000994:	6605                	lui	a2,0x1
    80000996:	85de                	mv	a1,s7
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	73a080e7          	jalr	1850(ra) # 800000d2 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    800009a0:	8726                	mv	a4,s1
    800009a2:	86ca                	mv	a3,s2
    800009a4:	6605                	lui	a2,0x1
    800009a6:	85ce                	mv	a1,s3
    800009a8:	8556                	mv	a0,s5
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	a90080e7          	jalr	-1392(ra) # 8000043a <mappages>
    800009b2:	e515                	bnez	a0,800009de <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    800009b4:	6785                	lui	a5,0x1
    800009b6:	99be                	add	s3,s3,a5
    800009b8:	fb49e6e3          	bltu	s3,s4,80000964 <uvmcopy+0x20>
    800009bc:	a081                	j	800009fc <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    800009be:	00007517          	auipc	a0,0x7
    800009c2:	77250513          	addi	a0,a0,1906 # 80008130 <etext+0x130>
    800009c6:	00006097          	auipc	ra,0x6
    800009ca:	f7e080e7          	jalr	-130(ra) # 80006944 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    800009ce:	00007517          	auipc	a0,0x7
    800009d2:	78250513          	addi	a0,a0,1922 # 80008150 <etext+0x150>
    800009d6:	00006097          	auipc	ra,0x6
    800009da:	f6e080e7          	jalr	-146(ra) # 80006944 <panic>
      kfree(mem);
    800009de:	854a                	mv	a0,s2
    800009e0:	fffff097          	auipc	ra,0xfffff
    800009e4:	664080e7          	jalr	1636(ra) # 80000044 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009e8:	4685                	li	a3,1
    800009ea:	00c9d613          	srli	a2,s3,0xc
    800009ee:	4581                	li	a1,0
    800009f0:	8556                	mv	a0,s5
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	c32080e7          	jalr	-974(ra) # 80000624 <uvmunmap>
  return -1;
    800009fa:	557d                	li	a0,-1
}
    800009fc:	60a6                	ld	ra,72(sp)
    800009fe:	6406                	ld	s0,64(sp)
    80000a00:	74e2                	ld	s1,56(sp)
    80000a02:	7942                	ld	s2,48(sp)
    80000a04:	79a2                	ld	s3,40(sp)
    80000a06:	7a02                	ld	s4,32(sp)
    80000a08:	6ae2                	ld	s5,24(sp)
    80000a0a:	6b42                	ld	s6,16(sp)
    80000a0c:	6ba2                	ld	s7,8(sp)
    80000a0e:	6161                	addi	sp,sp,80
    80000a10:	8082                	ret
  return 0;
    80000a12:	4501                	li	a0,0
}
    80000a14:	8082                	ret

0000000080000a16 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000a16:	1141                	addi	sp,sp,-16
    80000a18:	e406                	sd	ra,8(sp)
    80000a1a:	e022                	sd	s0,0(sp)
    80000a1c:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000a1e:	4601                	li	a2,0
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	932080e7          	jalr	-1742(ra) # 80000352 <walk>
  if (pte == 0) panic("uvmclear");
    80000a28:	c901                	beqz	a0,80000a38 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000a2a:	611c                	ld	a5,0(a0)
    80000a2c:	9bbd                	andi	a5,a5,-17
    80000a2e:	e11c                	sd	a5,0(a0)
}
    80000a30:	60a2                	ld	ra,8(sp)
    80000a32:	6402                	ld	s0,0(sp)
    80000a34:	0141                	addi	sp,sp,16
    80000a36:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000a38:	00007517          	auipc	a0,0x7
    80000a3c:	73850513          	addi	a0,a0,1848 # 80008170 <etext+0x170>
    80000a40:	00006097          	auipc	ra,0x6
    80000a44:	f04080e7          	jalr	-252(ra) # 80006944 <panic>

0000000080000a48 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0) {
    80000a48:	ced1                	beqz	a3,80000ae4 <copyout+0x9c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000a4a:	711d                	addi	sp,sp,-96
    80000a4c:	ec86                	sd	ra,88(sp)
    80000a4e:	e8a2                	sd	s0,80(sp)
    80000a50:	e4a6                	sd	s1,72(sp)
    80000a52:	fc4e                	sd	s3,56(sp)
    80000a54:	f456                	sd	s5,40(sp)
    80000a56:	f05a                	sd	s6,32(sp)
    80000a58:	ec5e                	sd	s7,24(sp)
    80000a5a:	1080                	addi	s0,sp,96
    80000a5c:	8baa                	mv	s7,a0
    80000a5e:	8aae                	mv	s5,a1
    80000a60:	8b32                	mv	s6,a2
    80000a62:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a64:	74fd                	lui	s1,0xfffff
    80000a66:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000a68:	57fd                	li	a5,-1
    80000a6a:	83e9                	srli	a5,a5,0x1a
    80000a6c:	0697ee63          	bltu	a5,s1,80000ae8 <copyout+0xa0>
    80000a70:	e0ca                	sd	s2,64(sp)
    80000a72:	f852                	sd	s4,48(sp)
    80000a74:	e862                	sd	s8,16(sp)
    80000a76:	e466                	sd	s9,8(sp)
    80000a78:	e06a                	sd	s10,0(sp)
    pte = walk(pagetable, va0, 0);
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a7a:	4cd5                	li	s9,21
    80000a7c:	6d05                	lui	s10,0x1
    if (va0 >= MAXVA) return -1;
    80000a7e:	8c3e                	mv	s8,a5
    80000a80:	a035                	j	80000aac <copyout+0x64>
        (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a82:	83a9                	srli	a5,a5,0xa
    80000a84:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a86:	409a8533          	sub	a0,s5,s1
    80000a8a:	0009061b          	sext.w	a2,s2
    80000a8e:	85da                	mv	a1,s6
    80000a90:	953e                	add	a0,a0,a5
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	640080e7          	jalr	1600(ra) # 800000d2 <memmove>

    len -= n;
    80000a9a:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a9e:	9b4a                	add	s6,s6,s2
  while (len > 0) {
    80000aa0:	02098b63          	beqz	s3,80000ad6 <copyout+0x8e>
    if (va0 >= MAXVA) return -1;
    80000aa4:	054c6463          	bltu	s8,s4,80000aec <copyout+0xa4>
    80000aa8:	84d2                	mv	s1,s4
    80000aaa:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000aac:	4601                	li	a2,0
    80000aae:	85a6                	mv	a1,s1
    80000ab0:	855e                	mv	a0,s7
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	8a0080e7          	jalr	-1888(ra) # 80000352 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000aba:	c121                	beqz	a0,80000afa <copyout+0xb2>
    80000abc:	611c                	ld	a5,0(a0)
    80000abe:	0157f713          	andi	a4,a5,21
    80000ac2:	05971b63          	bne	a4,s9,80000b18 <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000ac6:	01a48a33          	add	s4,s1,s10
    80000aca:	415a0933          	sub	s2,s4,s5
    if (n > len) n = len;
    80000ace:	fb29fae3          	bgeu	s3,s2,80000a82 <copyout+0x3a>
    80000ad2:	894e                	mv	s2,s3
    80000ad4:	b77d                	j	80000a82 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000ad6:	4501                	li	a0,0
    80000ad8:	6906                	ld	s2,64(sp)
    80000ada:	7a42                	ld	s4,48(sp)
    80000adc:	6c42                	ld	s8,16(sp)
    80000ade:	6ca2                	ld	s9,8(sp)
    80000ae0:	6d02                	ld	s10,0(sp)
    80000ae2:	a015                	j	80000b06 <copyout+0xbe>
    80000ae4:	4501                	li	a0,0
}
    80000ae6:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000ae8:	557d                	li	a0,-1
    80000aea:	a831                	j	80000b06 <copyout+0xbe>
    80000aec:	557d                	li	a0,-1
    80000aee:	6906                	ld	s2,64(sp)
    80000af0:	7a42                	ld	s4,48(sp)
    80000af2:	6c42                	ld	s8,16(sp)
    80000af4:	6ca2                	ld	s9,8(sp)
    80000af6:	6d02                	ld	s10,0(sp)
    80000af8:	a039                	j	80000b06 <copyout+0xbe>
      return -1;
    80000afa:	557d                	li	a0,-1
    80000afc:	6906                	ld	s2,64(sp)
    80000afe:	7a42                	ld	s4,48(sp)
    80000b00:	6c42                	ld	s8,16(sp)
    80000b02:	6ca2                	ld	s9,8(sp)
    80000b04:	6d02                	ld	s10,0(sp)
}
    80000b06:	60e6                	ld	ra,88(sp)
    80000b08:	6446                	ld	s0,80(sp)
    80000b0a:	64a6                	ld	s1,72(sp)
    80000b0c:	79e2                	ld	s3,56(sp)
    80000b0e:	7aa2                	ld	s5,40(sp)
    80000b10:	7b02                	ld	s6,32(sp)
    80000b12:	6be2                	ld	s7,24(sp)
    80000b14:	6125                	addi	sp,sp,96
    80000b16:	8082                	ret
      return -1;
    80000b18:	557d                	li	a0,-1
    80000b1a:	6906                	ld	s2,64(sp)
    80000b1c:	7a42                	ld	s4,48(sp)
    80000b1e:	6c42                	ld	s8,16(sp)
    80000b20:	6ca2                	ld	s9,8(sp)
    80000b22:	6d02                	ld	s10,0(sp)
    80000b24:	b7cd                	j	80000b06 <copyout+0xbe>

0000000080000b26 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000b26:	caa5                	beqz	a3,80000b96 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000b28:	715d                	addi	sp,sp,-80
    80000b2a:	e486                	sd	ra,72(sp)
    80000b2c:	e0a2                	sd	s0,64(sp)
    80000b2e:	fc26                	sd	s1,56(sp)
    80000b30:	f84a                	sd	s2,48(sp)
    80000b32:	f44e                	sd	s3,40(sp)
    80000b34:	f052                	sd	s4,32(sp)
    80000b36:	ec56                	sd	s5,24(sp)
    80000b38:	e85a                	sd	s6,16(sp)
    80000b3a:	e45e                	sd	s7,8(sp)
    80000b3c:	e062                	sd	s8,0(sp)
    80000b3e:	0880                	addi	s0,sp,80
    80000b40:	8b2a                	mv	s6,a0
    80000b42:	8a2e                	mv	s4,a1
    80000b44:	8c32                	mv	s8,a2
    80000b46:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b48:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000b4a:	6a85                	lui	s5,0x1
    80000b4c:	a01d                	j	80000b72 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b4e:	018505b3          	add	a1,a0,s8
    80000b52:	0004861b          	sext.w	a2,s1
    80000b56:	412585b3          	sub	a1,a1,s2
    80000b5a:	8552                	mv	a0,s4
    80000b5c:	fffff097          	auipc	ra,0xfffff
    80000b60:	576080e7          	jalr	1398(ra) # 800000d2 <memmove>

    len -= n;
    80000b64:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b68:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b6a:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000b6e:	02098263          	beqz	s3,80000b92 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000b72:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b76:	85ca                	mv	a1,s2
    80000b78:	855a                	mv	a0,s6
    80000b7a:	00000097          	auipc	ra,0x0
    80000b7e:	87e080e7          	jalr	-1922(ra) # 800003f8 <walkaddr>
    if (pa0 == 0) return -1;
    80000b82:	cd01                	beqz	a0,80000b9a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000b84:	418904b3          	sub	s1,s2,s8
    80000b88:	94d6                	add	s1,s1,s5
    if (n > len) n = len;
    80000b8a:	fc99f2e3          	bgeu	s3,s1,80000b4e <copyin+0x28>
    80000b8e:	84ce                	mv	s1,s3
    80000b90:	bf7d                	j	80000b4e <copyin+0x28>
  }
  return 0;
    80000b92:	4501                	li	a0,0
    80000b94:	a021                	j	80000b9c <copyin+0x76>
    80000b96:	4501                	li	a0,0
}
    80000b98:	8082                	ret
    if (pa0 == 0) return -1;
    80000b9a:	557d                	li	a0,-1
}
    80000b9c:	60a6                	ld	ra,72(sp)
    80000b9e:	6406                	ld	s0,64(sp)
    80000ba0:	74e2                	ld	s1,56(sp)
    80000ba2:	7942                	ld	s2,48(sp)
    80000ba4:	79a2                	ld	s3,40(sp)
    80000ba6:	7a02                	ld	s4,32(sp)
    80000ba8:	6ae2                	ld	s5,24(sp)
    80000baa:	6b42                	ld	s6,16(sp)
    80000bac:	6ba2                	ld	s7,8(sp)
    80000bae:	6c02                	ld	s8,0(sp)
    80000bb0:	6161                	addi	sp,sp,80
    80000bb2:	8082                	ret

0000000080000bb4 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000bb4:	cacd                	beqz	a3,80000c66 <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000bb6:	715d                	addi	sp,sp,-80
    80000bb8:	e486                	sd	ra,72(sp)
    80000bba:	e0a2                	sd	s0,64(sp)
    80000bbc:	fc26                	sd	s1,56(sp)
    80000bbe:	f84a                	sd	s2,48(sp)
    80000bc0:	f44e                	sd	s3,40(sp)
    80000bc2:	f052                	sd	s4,32(sp)
    80000bc4:	ec56                	sd	s5,24(sp)
    80000bc6:	e85a                	sd	s6,16(sp)
    80000bc8:	e45e                	sd	s7,8(sp)
    80000bca:	0880                	addi	s0,sp,80
    80000bcc:	8a2a                	mv	s4,a0
    80000bce:	8b2e                	mv	s6,a1
    80000bd0:	8bb2                	mv	s7,a2
    80000bd2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000bd4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000bd6:	6985                	lui	s3,0x1
    80000bd8:	a825                	j	80000c10 <copyinstr+0x5c>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000bda:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000bde:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000be0:	37fd                	addiw	a5,a5,-1
    80000be2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000be6:	60a6                	ld	ra,72(sp)
    80000be8:	6406                	ld	s0,64(sp)
    80000bea:	74e2                	ld	s1,56(sp)
    80000bec:	7942                	ld	s2,48(sp)
    80000bee:	79a2                	ld	s3,40(sp)
    80000bf0:	7a02                	ld	s4,32(sp)
    80000bf2:	6ae2                	ld	s5,24(sp)
    80000bf4:	6b42                	ld	s6,16(sp)
    80000bf6:	6ba2                	ld	s7,8(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
    80000bfc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c00:	9742                	add	a4,a4,a6
      --max;
    80000c02:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c06:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0) {
    80000c0a:	04e58663          	beq	a1,a4,80000c56 <copyinstr+0xa2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000c0e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c10:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c14:	85a6                	mv	a1,s1
    80000c16:	8552                	mv	a0,s4
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	7e0080e7          	jalr	2016(ra) # 800003f8 <walkaddr>
    if (pa0 == 0) return -1;
    80000c20:	cd0d                	beqz	a0,80000c5a <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000c22:	417486b3          	sub	a3,s1,s7
    80000c26:	96ce                	add	a3,a3,s3
    if (n > max) n = max;
    80000c28:	00d97363          	bgeu	s2,a3,80000c2e <copyinstr+0x7a>
    80000c2c:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80000c2e:	955e                	add	a0,a0,s7
    80000c30:	8d05                	sub	a0,a0,s1
    while (n > 0) {
    80000c32:	c695                	beqz	a3,80000c5e <copyinstr+0xaa>
    80000c34:	87da                	mv	a5,s6
    80000c36:	885a                	mv	a6,s6
      if (*p == '\0') {
    80000c38:	41650633          	sub	a2,a0,s6
    while (n > 0) {
    80000c3c:	96da                	add	a3,a3,s6
    80000c3e:	85be                	mv	a1,a5
      if (*p == '\0') {
    80000c40:	00f60733          	add	a4,a2,a5
    80000c44:	00074703          	lbu	a4,0(a4)
    80000c48:	db49                	beqz	a4,80000bda <copyinstr+0x26>
        *dst = *p;
    80000c4a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c4e:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000c50:	fed797e3          	bne	a5,a3,80000c3e <copyinstr+0x8a>
    80000c54:	b765                	j	80000bfc <copyinstr+0x48>
    80000c56:	4781                	li	a5,0
    80000c58:	b761                	j	80000be0 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000c5a:	557d                	li	a0,-1
    80000c5c:	b769                	j	80000be6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c5e:	6b85                	lui	s7,0x1
    80000c60:	9ba6                	add	s7,s7,s1
    80000c62:	87da                	mv	a5,s6
    80000c64:	b76d                	j	80000c0e <copyinstr+0x5a>
  int got_null = 0;
    80000c66:	4781                	li	a5,0
  if (got_null) {
    80000c68:	37fd                	addiw	a5,a5,-1
    80000c6a:	0007851b          	sext.w	a0,a5
}
    80000c6e:	8082                	ret

0000000080000c70 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000c70:	7139                	addi	sp,sp,-64
    80000c72:	fc06                	sd	ra,56(sp)
    80000c74:	f822                	sd	s0,48(sp)
    80000c76:	f426                	sd	s1,40(sp)
    80000c78:	f04a                	sd	s2,32(sp)
    80000c7a:	ec4e                	sd	s3,24(sp)
    80000c7c:	e852                	sd	s4,16(sp)
    80000c7e:	e456                	sd	s5,8(sp)
    80000c80:	e05a                	sd	s6,0(sp)
    80000c82:	0080                	addi	s0,sp,64
    80000c84:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000c86:	0000b497          	auipc	s1,0xb
    80000c8a:	08a48493          	addi	s1,s1,138 # 8000bd10 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000c8e:	8b26                	mv	s6,s1
    80000c90:	04fa5937          	lui	s2,0x4fa5
    80000c94:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c98:	0932                	slli	s2,s2,0xc
    80000c9a:	fa590913          	addi	s2,s2,-91
    80000c9e:	0932                	slli	s2,s2,0xc
    80000ca0:	fa590913          	addi	s2,s2,-91
    80000ca4:	0932                	slli	s2,s2,0xc
    80000ca6:	fa590913          	addi	s2,s2,-91
    80000caa:	040009b7          	lui	s3,0x4000
    80000cae:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cb0:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000cb2:	00011a97          	auipc	s5,0x11
    80000cb6:	a5ea8a93          	addi	s5,s5,-1442 # 80011710 <tickslock>
    char *pa = kalloc();
    80000cba:	fffff097          	auipc	ra,0xfffff
    80000cbe:	3a2080e7          	jalr	930(ra) # 8000005c <kalloc>
    80000cc2:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000cc4:	c121                	beqz	a0,80000d04 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80000cc6:	416485b3          	sub	a1,s1,s6
    80000cca:	858d                	srai	a1,a1,0x3
    80000ccc:	032585b3          	mul	a1,a1,s2
    80000cd0:	2585                	addiw	a1,a1,1
    80000cd2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cd6:	4719                	li	a4,6
    80000cd8:	6685                	lui	a3,0x1
    80000cda:	40b985b3          	sub	a1,s3,a1
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	81e080e7          	jalr	-2018(ra) # 800004fe <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	16848493          	addi	s1,s1,360
    80000cec:	fd5497e3          	bne	s1,s5,80000cba <proc_mapstacks+0x4a>
  }
}
    80000cf0:	70e2                	ld	ra,56(sp)
    80000cf2:	7442                	ld	s0,48(sp)
    80000cf4:	74a2                	ld	s1,40(sp)
    80000cf6:	7902                	ld	s2,32(sp)
    80000cf8:	69e2                	ld	s3,24(sp)
    80000cfa:	6a42                	ld	s4,16(sp)
    80000cfc:	6aa2                	ld	s5,8(sp)
    80000cfe:	6b02                	ld	s6,0(sp)
    80000d00:	6121                	addi	sp,sp,64
    80000d02:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000d04:	00007517          	auipc	a0,0x7
    80000d08:	47c50513          	addi	a0,a0,1148 # 80008180 <etext+0x180>
    80000d0c:	00006097          	auipc	ra,0x6
    80000d10:	c38080e7          	jalr	-968(ra) # 80006944 <panic>

0000000080000d14 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000d14:	7139                	addi	sp,sp,-64
    80000d16:	fc06                	sd	ra,56(sp)
    80000d18:	f822                	sd	s0,48(sp)
    80000d1a:	f426                	sd	s1,40(sp)
    80000d1c:	f04a                	sd	s2,32(sp)
    80000d1e:	ec4e                	sd	s3,24(sp)
    80000d20:	e852                	sd	s4,16(sp)
    80000d22:	e456                	sd	s5,8(sp)
    80000d24:	e05a                	sd	s6,0(sp)
    80000d26:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d28:	00007597          	auipc	a1,0x7
    80000d2c:	46058593          	addi	a1,a1,1120 # 80008188 <etext+0x188>
    80000d30:	0000b517          	auipc	a0,0xb
    80000d34:	bb050513          	addi	a0,a0,-1104 # 8000b8e0 <pid_lock>
    80000d38:	00006097          	auipc	ra,0x6
    80000d3c:	0f6080e7          	jalr	246(ra) # 80006e2e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d40:	00007597          	auipc	a1,0x7
    80000d44:	45058593          	addi	a1,a1,1104 # 80008190 <etext+0x190>
    80000d48:	0000b517          	auipc	a0,0xb
    80000d4c:	bb050513          	addi	a0,a0,-1104 # 8000b8f8 <wait_lock>
    80000d50:	00006097          	auipc	ra,0x6
    80000d54:	0de080e7          	jalr	222(ra) # 80006e2e <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d58:	0000b497          	auipc	s1,0xb
    80000d5c:	fb848493          	addi	s1,s1,-72 # 8000bd10 <proc>
    initlock(&p->lock, "proc");
    80000d60:	00007b17          	auipc	s6,0x7
    80000d64:	440b0b13          	addi	s6,s6,1088 # 800081a0 <etext+0x1a0>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000d68:	8aa6                	mv	s5,s1
    80000d6a:	04fa5937          	lui	s2,0x4fa5
    80000d6e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d72:	0932                	slli	s2,s2,0xc
    80000d74:	fa590913          	addi	s2,s2,-91
    80000d78:	0932                	slli	s2,s2,0xc
    80000d7a:	fa590913          	addi	s2,s2,-91
    80000d7e:	0932                	slli	s2,s2,0xc
    80000d80:	fa590913          	addi	s2,s2,-91
    80000d84:	040009b7          	lui	s3,0x4000
    80000d88:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d8a:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	00011a17          	auipc	s4,0x11
    80000d90:	984a0a13          	addi	s4,s4,-1660 # 80011710 <tickslock>
    initlock(&p->lock, "proc");
    80000d94:	85da                	mv	a1,s6
    80000d96:	8526                	mv	a0,s1
    80000d98:	00006097          	auipc	ra,0x6
    80000d9c:	096080e7          	jalr	150(ra) # 80006e2e <initlock>
    p->state = UNUSED;
    80000da0:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000da4:	415487b3          	sub	a5,s1,s5
    80000da8:	878d                	srai	a5,a5,0x3
    80000daa:	032787b3          	mul	a5,a5,s2
    80000dae:	2785                	addiw	a5,a5,1
    80000db0:	00d7979b          	slliw	a5,a5,0xd
    80000db4:	40f987b3          	sub	a5,s3,a5
    80000db8:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000dba:	16848493          	addi	s1,s1,360
    80000dbe:	fd449be3          	bne	s1,s4,80000d94 <procinit+0x80>
  }
}
    80000dc2:	70e2                	ld	ra,56(sp)
    80000dc4:	7442                	ld	s0,48(sp)
    80000dc6:	74a2                	ld	s1,40(sp)
    80000dc8:	7902                	ld	s2,32(sp)
    80000dca:	69e2                	ld	s3,24(sp)
    80000dcc:	6a42                	ld	s4,16(sp)
    80000dce:	6aa2                	ld	s5,8(sp)
    80000dd0:	6b02                	ld	s6,0(sp)
    80000dd2:	6121                	addi	sp,sp,64
    80000dd4:	8082                	ret

0000000080000dd6 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000dd6:	1141                	addi	sp,sp,-16
    80000dd8:	e422                	sd	s0,8(sp)
    80000dda:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000ddc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000dde:	2501                	sext.w	a0,a0
    80000de0:	6422                	ld	s0,8(sp)
    80000de2:	0141                	addi	sp,sp,16
    80000de4:	8082                	ret

0000000080000de6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000de6:	1141                	addi	sp,sp,-16
    80000de8:	e422                	sd	s0,8(sp)
    80000dea:	0800                	addi	s0,sp,16
    80000dec:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000dee:	2781                	sext.w	a5,a5
    80000df0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000df2:	0000b517          	auipc	a0,0xb
    80000df6:	b1e50513          	addi	a0,a0,-1250 # 8000b910 <cpus>
    80000dfa:	953e                	add	a0,a0,a5
    80000dfc:	6422                	ld	s0,8(sp)
    80000dfe:	0141                	addi	sp,sp,16
    80000e00:	8082                	ret

0000000080000e02 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000e02:	1101                	addi	sp,sp,-32
    80000e04:	ec06                	sd	ra,24(sp)
    80000e06:	e822                	sd	s0,16(sp)
    80000e08:	e426                	sd	s1,8(sp)
    80000e0a:	1000                	addi	s0,sp,32
  push_off();
    80000e0c:	00006097          	auipc	ra,0x6
    80000e10:	066080e7          	jalr	102(ra) # 80006e72 <push_off>
    80000e14:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e16:	2781                	sext.w	a5,a5
    80000e18:	079e                	slli	a5,a5,0x7
    80000e1a:	0000b717          	auipc	a4,0xb
    80000e1e:	ac670713          	addi	a4,a4,-1338 # 8000b8e0 <pid_lock>
    80000e22:	97ba                	add	a5,a5,a4
    80000e24:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e26:	00006097          	auipc	ra,0x6
    80000e2a:	0ec080e7          	jalr	236(ra) # 80006f12 <pop_off>
  return p;
}
    80000e2e:	8526                	mv	a0,s1
    80000e30:	60e2                	ld	ra,24(sp)
    80000e32:	6442                	ld	s0,16(sp)
    80000e34:	64a2                	ld	s1,8(sp)
    80000e36:	6105                	addi	sp,sp,32
    80000e38:	8082                	ret

0000000080000e3a <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e406                	sd	ra,8(sp)
    80000e3e:	e022                	sd	s0,0(sp)
    80000e40:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e42:	00000097          	auipc	ra,0x0
    80000e46:	fc0080e7          	jalr	-64(ra) # 80000e02 <myproc>
    80000e4a:	00006097          	auipc	ra,0x6
    80000e4e:	128080e7          	jalr	296(ra) # 80006f72 <release>

  if (first) {
    80000e52:	0000b797          	auipc	a5,0xb
    80000e56:	9ce7a783          	lw	a5,-1586(a5) # 8000b820 <first.1>
    80000e5a:	eb89                	bnez	a5,80000e6c <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000e5c:	00001097          	auipc	ra,0x1
    80000e60:	c64080e7          	jalr	-924(ra) # 80001ac0 <usertrapret>
}
    80000e64:	60a2                	ld	ra,8(sp)
    80000e66:	6402                	ld	s0,0(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret
    fsinit(ROOTDEV);
    80000e6c:	4505                	li	a0,1
    80000e6e:	00002097          	auipc	ra,0x2
    80000e72:	9ce080e7          	jalr	-1586(ra) # 8000283c <fsinit>
    first = 0;
    80000e76:	0000b797          	auipc	a5,0xb
    80000e7a:	9a07a523          	sw	zero,-1622(a5) # 8000b820 <first.1>
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    80000e82:	bfe9                	j	80000e5c <forkret+0x22>

0000000080000e84 <allocpid>:
int allocpid() {
    80000e84:	1101                	addi	sp,sp,-32
    80000e86:	ec06                	sd	ra,24(sp)
    80000e88:	e822                	sd	s0,16(sp)
    80000e8a:	e426                	sd	s1,8(sp)
    80000e8c:	e04a                	sd	s2,0(sp)
    80000e8e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e90:	0000b917          	auipc	s2,0xb
    80000e94:	a5090913          	addi	s2,s2,-1456 # 8000b8e0 <pid_lock>
    80000e98:	854a                	mv	a0,s2
    80000e9a:	00006097          	auipc	ra,0x6
    80000e9e:	024080e7          	jalr	36(ra) # 80006ebe <acquire>
  pid = nextpid;
    80000ea2:	0000b797          	auipc	a5,0xb
    80000ea6:	98278793          	addi	a5,a5,-1662 # 8000b824 <nextpid>
    80000eaa:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eac:	0014871b          	addiw	a4,s1,1
    80000eb0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eb2:	854a                	mv	a0,s2
    80000eb4:	00006097          	auipc	ra,0x6
    80000eb8:	0be080e7          	jalr	190(ra) # 80006f72 <release>
}
    80000ebc:	8526                	mv	a0,s1
    80000ebe:	60e2                	ld	ra,24(sp)
    80000ec0:	6442                	ld	s0,16(sp)
    80000ec2:	64a2                	ld	s1,8(sp)
    80000ec4:	6902                	ld	s2,0(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000eca:	1101                	addi	sp,sp,-32
    80000ecc:	ec06                	sd	ra,24(sp)
    80000ece:	e822                	sd	s0,16(sp)
    80000ed0:	e426                	sd	s1,8(sp)
    80000ed2:	e04a                	sd	s2,0(sp)
    80000ed4:	1000                	addi	s0,sp,32
    80000ed6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	820080e7          	jalr	-2016(ra) # 800006f8 <uvmcreate>
    80000ee0:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000ee2:	c121                	beqz	a0,80000f22 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000ee4:	4729                	li	a4,10
    80000ee6:	00006697          	auipc	a3,0x6
    80000eea:	11a68693          	addi	a3,a3,282 # 80007000 <_trampoline>
    80000eee:	6605                	lui	a2,0x1
    80000ef0:	040005b7          	lui	a1,0x4000
    80000ef4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef6:	05b2                	slli	a1,a1,0xc
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	542080e7          	jalr	1346(ra) # 8000043a <mappages>
    80000f00:	02054863          	bltz	a0,80000f30 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80000f04:	4719                	li	a4,6
    80000f06:	05893683          	ld	a3,88(s2)
    80000f0a:	6605                	lui	a2,0x1
    80000f0c:	020005b7          	lui	a1,0x2000
    80000f10:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f12:	05b6                	slli	a1,a1,0xd
    80000f14:	8526                	mv	a0,s1
    80000f16:	fffff097          	auipc	ra,0xfffff
    80000f1a:	524080e7          	jalr	1316(ra) # 8000043a <mappages>
    80000f1e:	02054163          	bltz	a0,80000f40 <proc_pagetable+0x76>
}
    80000f22:	8526                	mv	a0,s1
    80000f24:	60e2                	ld	ra,24(sp)
    80000f26:	6442                	ld	s0,16(sp)
    80000f28:	64a2                	ld	s1,8(sp)
    80000f2a:	6902                	ld	s2,0(sp)
    80000f2c:	6105                	addi	sp,sp,32
    80000f2e:	8082                	ret
    uvmfree(pagetable, 0);
    80000f30:	4581                	li	a1,0
    80000f32:	8526                	mv	a0,s1
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	9d6080e7          	jalr	-1578(ra) # 8000090a <uvmfree>
    return 0;
    80000f3c:	4481                	li	s1,0
    80000f3e:	b7d5                	j	80000f22 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f40:	4681                	li	a3,0
    80000f42:	4605                	li	a2,1
    80000f44:	040005b7          	lui	a1,0x4000
    80000f48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f4a:	05b2                	slli	a1,a1,0xc
    80000f4c:	8526                	mv	a0,s1
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	6d6080e7          	jalr	1750(ra) # 80000624 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f56:	4581                	li	a1,0
    80000f58:	8526                	mv	a0,s1
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	9b0080e7          	jalr	-1616(ra) # 8000090a <uvmfree>
    return 0;
    80000f62:	4481                	li	s1,0
    80000f64:	bf7d                	j	80000f22 <proc_pagetable+0x58>

0000000080000f66 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80000f66:	1101                	addi	sp,sp,-32
    80000f68:	ec06                	sd	ra,24(sp)
    80000f6a:	e822                	sd	s0,16(sp)
    80000f6c:	e426                	sd	s1,8(sp)
    80000f6e:	e04a                	sd	s2,0(sp)
    80000f70:	1000                	addi	s0,sp,32
    80000f72:	84aa                	mv	s1,a0
    80000f74:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f76:	4681                	li	a3,0
    80000f78:	4605                	li	a2,1
    80000f7a:	040005b7          	lui	a1,0x4000
    80000f7e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f80:	05b2                	slli	a1,a1,0xc
    80000f82:	fffff097          	auipc	ra,0xfffff
    80000f86:	6a2080e7          	jalr	1698(ra) # 80000624 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f8a:	4681                	li	a3,0
    80000f8c:	4605                	li	a2,1
    80000f8e:	020005b7          	lui	a1,0x2000
    80000f92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f94:	05b6                	slli	a1,a1,0xd
    80000f96:	8526                	mv	a0,s1
    80000f98:	fffff097          	auipc	ra,0xfffff
    80000f9c:	68c080e7          	jalr	1676(ra) # 80000624 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fa0:	85ca                	mv	a1,s2
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	00000097          	auipc	ra,0x0
    80000fa8:	966080e7          	jalr	-1690(ra) # 8000090a <uvmfree>
}
    80000fac:	60e2                	ld	ra,24(sp)
    80000fae:	6442                	ld	s0,16(sp)
    80000fb0:	64a2                	ld	s1,8(sp)
    80000fb2:	6902                	ld	s2,0(sp)
    80000fb4:	6105                	addi	sp,sp,32
    80000fb6:	8082                	ret

0000000080000fb8 <freeproc>:
static void freeproc(struct proc *p) {
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	1000                	addi	s0,sp,32
    80000fc2:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80000fc4:	6d28                	ld	a0,88(a0)
    80000fc6:	c509                	beqz	a0,80000fd0 <freeproc+0x18>
    80000fc8:	fffff097          	auipc	ra,0xfffff
    80000fcc:	07c080e7          	jalr	124(ra) # 80000044 <kfree>
  p->trapframe = 0;
    80000fd0:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80000fd4:	68a8                	ld	a0,80(s1)
    80000fd6:	c511                	beqz	a0,80000fe2 <freeproc+0x2a>
    80000fd8:	64ac                	ld	a1,72(s1)
    80000fda:	00000097          	auipc	ra,0x0
    80000fde:	f8c080e7          	jalr	-116(ra) # 80000f66 <proc_freepagetable>
  p->pagetable = 0;
    80000fe2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000fe6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fea:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000fee:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000ff2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000ff6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000ffa:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000ffe:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001002:	0004ac23          	sw	zero,24(s1)
}
    80001006:	60e2                	ld	ra,24(sp)
    80001008:	6442                	ld	s0,16(sp)
    8000100a:	64a2                	ld	s1,8(sp)
    8000100c:	6105                	addi	sp,sp,32
    8000100e:	8082                	ret

0000000080001010 <allocproc>:
static struct proc *allocproc(void) {
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	e04a                	sd	s2,0(sp)
    8000101a:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    8000101c:	0000b497          	auipc	s1,0xb
    80001020:	cf448493          	addi	s1,s1,-780 # 8000bd10 <proc>
    80001024:	00010917          	auipc	s2,0x10
    80001028:	6ec90913          	addi	s2,s2,1772 # 80011710 <tickslock>
    acquire(&p->lock);
    8000102c:	8526                	mv	a0,s1
    8000102e:	00006097          	auipc	ra,0x6
    80001032:	e90080e7          	jalr	-368(ra) # 80006ebe <acquire>
    if (p->state == UNUSED) {
    80001036:	4c9c                	lw	a5,24(s1)
    80001038:	cf81                	beqz	a5,80001050 <allocproc+0x40>
      release(&p->lock);
    8000103a:	8526                	mv	a0,s1
    8000103c:	00006097          	auipc	ra,0x6
    80001040:	f36080e7          	jalr	-202(ra) # 80006f72 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001044:	16848493          	addi	s1,s1,360
    80001048:	ff2492e3          	bne	s1,s2,8000102c <allocproc+0x1c>
  return 0;
    8000104c:	4481                	li	s1,0
    8000104e:	a889                	j	800010a0 <allocproc+0x90>
  p->pid = allocpid();
    80001050:	00000097          	auipc	ra,0x0
    80001054:	e34080e7          	jalr	-460(ra) # 80000e84 <allocpid>
    80001058:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000105a:	4785                	li	a5,1
    8000105c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	ffe080e7          	jalr	-2(ra) # 8000005c <kalloc>
    80001066:	892a                	mv	s2,a0
    80001068:	eca8                	sd	a0,88(s1)
    8000106a:	c131                	beqz	a0,800010ae <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00000097          	auipc	ra,0x0
    80001072:	e5c080e7          	jalr	-420(ra) # 80000eca <proc_pagetable>
    80001076:	892a                	mv	s2,a0
    80001078:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    8000107a:	c531                	beqz	a0,800010c6 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000107c:	07000613          	li	a2,112
    80001080:	4581                	li	a1,0
    80001082:	06048513          	addi	a0,s1,96
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	ff0080e7          	jalr	-16(ra) # 80000076 <memset>
  p->context.ra = (uint64)forkret;
    8000108e:	00000797          	auipc	a5,0x0
    80001092:	dac78793          	addi	a5,a5,-596 # 80000e3a <forkret>
    80001096:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001098:	60bc                	ld	a5,64(s1)
    8000109a:	6705                	lui	a4,0x1
    8000109c:	97ba                	add	a5,a5,a4
    8000109e:	f4bc                	sd	a5,104(s1)
}
    800010a0:	8526                	mv	a0,s1
    800010a2:	60e2                	ld	ra,24(sp)
    800010a4:	6442                	ld	s0,16(sp)
    800010a6:	64a2                	ld	s1,8(sp)
    800010a8:	6902                	ld	s2,0(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret
    freeproc(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	f08080e7          	jalr	-248(ra) # 80000fb8 <freeproc>
    release(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00006097          	auipc	ra,0x6
    800010be:	eb8080e7          	jalr	-328(ra) # 80006f72 <release>
    return 0;
    800010c2:	84ca                	mv	s1,s2
    800010c4:	bff1                	j	800010a0 <allocproc+0x90>
    freeproc(p);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	ef0080e7          	jalr	-272(ra) # 80000fb8 <freeproc>
    release(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00006097          	auipc	ra,0x6
    800010d6:	ea0080e7          	jalr	-352(ra) # 80006f72 <release>
    return 0;
    800010da:	84ca                	mv	s1,s2
    800010dc:	b7d1                	j	800010a0 <allocproc+0x90>

00000000800010de <userinit>:
void userinit(void) {
    800010de:	1101                	addi	sp,sp,-32
    800010e0:	ec06                	sd	ra,24(sp)
    800010e2:	e822                	sd	s0,16(sp)
    800010e4:	e426                	sd	s1,8(sp)
    800010e6:	1000                	addi	s0,sp,32
  p = allocproc();
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	f28080e7          	jalr	-216(ra) # 80001010 <allocproc>
    800010f0:	84aa                	mv	s1,a0
  initproc = p;
    800010f2:	0000a797          	auipc	a5,0xa
    800010f6:	7aa7b723          	sd	a0,1966(a5) # 8000b8a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800010fa:	03400613          	li	a2,52
    800010fe:	0000a597          	auipc	a1,0xa
    80001102:	73258593          	addi	a1,a1,1842 # 8000b830 <initcode>
    80001106:	6928                	ld	a0,80(a0)
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	61e080e7          	jalr	1566(ra) # 80000726 <uvmfirst>
  p->sz = PGSIZE;
    80001110:	6785                	lui	a5,0x1
    80001112:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001114:	6cb8                	ld	a4,88(s1)
    80001116:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000111a:	6cb8                	ld	a4,88(s1)
    8000111c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000111e:	4641                	li	a2,16
    80001120:	00007597          	auipc	a1,0x7
    80001124:	08858593          	addi	a1,a1,136 # 800081a8 <etext+0x1a8>
    80001128:	15848513          	addi	a0,s1,344
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	08c080e7          	jalr	140(ra) # 800001b8 <safestrcpy>
  p->cwd = namei("/");
    80001134:	00007517          	auipc	a0,0x7
    80001138:	08450513          	addi	a0,a0,132 # 800081b8 <etext+0x1b8>
    8000113c:	00002097          	auipc	ra,0x2
    80001140:	152080e7          	jalr	338(ra) # 8000328e <namei>
    80001144:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001148:	478d                	li	a5,3
    8000114a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00006097          	auipc	ra,0x6
    80001152:	e24080e7          	jalr	-476(ra) # 80006f72 <release>
}
    80001156:	60e2                	ld	ra,24(sp)
    80001158:	6442                	ld	s0,16(sp)
    8000115a:	64a2                	ld	s1,8(sp)
    8000115c:	6105                	addi	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <growproc>:
int growproc(int n) {
    80001160:	1101                	addi	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	e04a                	sd	s2,0(sp)
    8000116a:	1000                	addi	s0,sp,32
    8000116c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	c94080e7          	jalr	-876(ra) # 80000e02 <myproc>
    80001176:	84aa                	mv	s1,a0
  sz = p->sz;
    80001178:	652c                	ld	a1,72(a0)
  if (n > 0) {
    8000117a:	01204c63          	bgtz	s2,80001192 <growproc+0x32>
  } else if (n < 0) {
    8000117e:	02094663          	bltz	s2,800011aa <growproc+0x4a>
  p->sz = sz;
    80001182:	e4ac                	sd	a1,72(s1)
  return 0;
    80001184:	4501                	li	a0,0
}
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6902                	ld	s2,0(sp)
    8000118e:	6105                	addi	sp,sp,32
    80001190:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001192:	4691                	li	a3,4
    80001194:	00b90633          	add	a2,s2,a1
    80001198:	6928                	ld	a0,80(a0)
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	646080e7          	jalr	1606(ra) # 800007e0 <uvmalloc>
    800011a2:	85aa                	mv	a1,a0
    800011a4:	fd79                	bnez	a0,80001182 <growproc+0x22>
      return -1;
    800011a6:	557d                	li	a0,-1
    800011a8:	bff9                	j	80001186 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011aa:	00b90633          	add	a2,s2,a1
    800011ae:	6928                	ld	a0,80(a0)
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	5e8080e7          	jalr	1512(ra) # 80000798 <uvmdealloc>
    800011b8:	85aa                	mv	a1,a0
    800011ba:	b7e1                	j	80001182 <growproc+0x22>

00000000800011bc <fork>:
int fork(void) {
    800011bc:	7139                	addi	sp,sp,-64
    800011be:	fc06                	sd	ra,56(sp)
    800011c0:	f822                	sd	s0,48(sp)
    800011c2:	f04a                	sd	s2,32(sp)
    800011c4:	e456                	sd	s5,8(sp)
    800011c6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	c3a080e7          	jalr	-966(ra) # 80000e02 <myproc>
    800011d0:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	e3e080e7          	jalr	-450(ra) # 80001010 <allocproc>
    800011da:	12050063          	beqz	a0,800012fa <fork+0x13e>
    800011de:	e852                	sd	s4,16(sp)
    800011e0:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800011e2:	048ab603          	ld	a2,72(s5)
    800011e6:	692c                	ld	a1,80(a0)
    800011e8:	050ab503          	ld	a0,80(s5)
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	758080e7          	jalr	1880(ra) # 80000944 <uvmcopy>
    800011f4:	04054a63          	bltz	a0,80001248 <fork+0x8c>
    800011f8:	f426                	sd	s1,40(sp)
    800011fa:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011fc:	048ab783          	ld	a5,72(s5)
    80001200:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001204:	058ab683          	ld	a3,88(s5)
    80001208:	87b6                	mv	a5,a3
    8000120a:	058a3703          	ld	a4,88(s4)
    8000120e:	12068693          	addi	a3,a3,288
    80001212:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001216:	6788                	ld	a0,8(a5)
    80001218:	6b8c                	ld	a1,16(a5)
    8000121a:	6f90                	ld	a2,24(a5)
    8000121c:	01073023          	sd	a6,0(a4)
    80001220:	e708                	sd	a0,8(a4)
    80001222:	eb0c                	sd	a1,16(a4)
    80001224:	ef10                	sd	a2,24(a4)
    80001226:	02078793          	addi	a5,a5,32
    8000122a:	02070713          	addi	a4,a4,32
    8000122e:	fed792e3          	bne	a5,a3,80001212 <fork+0x56>
  np->trapframe->a0 = 0;
    80001232:	058a3783          	ld	a5,88(s4)
    80001236:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000123a:	0d0a8493          	addi	s1,s5,208
    8000123e:	0d0a0913          	addi	s2,s4,208
    80001242:	150a8993          	addi	s3,s5,336
    80001246:	a015                	j	8000126a <fork+0xae>
    freeproc(np);
    80001248:	8552                	mv	a0,s4
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	d6e080e7          	jalr	-658(ra) # 80000fb8 <freeproc>
    release(&np->lock);
    80001252:	8552                	mv	a0,s4
    80001254:	00006097          	auipc	ra,0x6
    80001258:	d1e080e7          	jalr	-738(ra) # 80006f72 <release>
    return -1;
    8000125c:	597d                	li	s2,-1
    8000125e:	6a42                	ld	s4,16(sp)
    80001260:	a071                	j	800012ec <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80001262:	04a1                	addi	s1,s1,8
    80001264:	0921                	addi	s2,s2,8
    80001266:	01348b63          	beq	s1,s3,8000127c <fork+0xc0>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    8000126a:	6088                	ld	a0,0(s1)
    8000126c:	d97d                	beqz	a0,80001262 <fork+0xa6>
    8000126e:	00002097          	auipc	ra,0x2
    80001272:	65e080e7          	jalr	1630(ra) # 800038cc <filedup>
    80001276:	00a93023          	sd	a0,0(s2)
    8000127a:	b7e5                	j	80001262 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000127c:	150ab503          	ld	a0,336(s5)
    80001280:	00002097          	auipc	ra,0x2
    80001284:	802080e7          	jalr	-2046(ra) # 80002a82 <idup>
    80001288:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000128c:	4641                	li	a2,16
    8000128e:	158a8593          	addi	a1,s5,344
    80001292:	158a0513          	addi	a0,s4,344
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	f22080e7          	jalr	-222(ra) # 800001b8 <safestrcpy>
  pid = np->pid;
    8000129e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012a2:	8552                	mv	a0,s4
    800012a4:	00006097          	auipc	ra,0x6
    800012a8:	cce080e7          	jalr	-818(ra) # 80006f72 <release>
  acquire(&wait_lock);
    800012ac:	0000a497          	auipc	s1,0xa
    800012b0:	64c48493          	addi	s1,s1,1612 # 8000b8f8 <wait_lock>
    800012b4:	8526                	mv	a0,s1
    800012b6:	00006097          	auipc	ra,0x6
    800012ba:	c08080e7          	jalr	-1016(ra) # 80006ebe <acquire>
  np->parent = p;
    800012be:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800012c2:	8526                	mv	a0,s1
    800012c4:	00006097          	auipc	ra,0x6
    800012c8:	cae080e7          	jalr	-850(ra) # 80006f72 <release>
  acquire(&np->lock);
    800012cc:	8552                	mv	a0,s4
    800012ce:	00006097          	auipc	ra,0x6
    800012d2:	bf0080e7          	jalr	-1040(ra) # 80006ebe <acquire>
  np->state = RUNNABLE;
    800012d6:	478d                	li	a5,3
    800012d8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800012dc:	8552                	mv	a0,s4
    800012de:	00006097          	auipc	ra,0x6
    800012e2:	c94080e7          	jalr	-876(ra) # 80006f72 <release>
  return pid;
    800012e6:	74a2                	ld	s1,40(sp)
    800012e8:	69e2                	ld	s3,24(sp)
    800012ea:	6a42                	ld	s4,16(sp)
}
    800012ec:	854a                	mv	a0,s2
    800012ee:	70e2                	ld	ra,56(sp)
    800012f0:	7442                	ld	s0,48(sp)
    800012f2:	7902                	ld	s2,32(sp)
    800012f4:	6aa2                	ld	s5,8(sp)
    800012f6:	6121                	addi	sp,sp,64
    800012f8:	8082                	ret
    return -1;
    800012fa:	597d                	li	s2,-1
    800012fc:	bfc5                	j	800012ec <fork+0x130>

00000000800012fe <scheduler>:
void scheduler(void) {
    800012fe:	7139                	addi	sp,sp,-64
    80001300:	fc06                	sd	ra,56(sp)
    80001302:	f822                	sd	s0,48(sp)
    80001304:	f426                	sd	s1,40(sp)
    80001306:	f04a                	sd	s2,32(sp)
    80001308:	ec4e                	sd	s3,24(sp)
    8000130a:	e852                	sd	s4,16(sp)
    8000130c:	e456                	sd	s5,8(sp)
    8000130e:	e05a                	sd	s6,0(sp)
    80001310:	0080                	addi	s0,sp,64
    80001312:	8792                	mv	a5,tp
  int id = r_tp();
    80001314:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001316:	00779a93          	slli	s5,a5,0x7
    8000131a:	0000a717          	auipc	a4,0xa
    8000131e:	5c670713          	addi	a4,a4,1478 # 8000b8e0 <pid_lock>
    80001322:	9756                	add	a4,a4,s5
    80001324:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001328:	0000a717          	auipc	a4,0xa
    8000132c:	5f070713          	addi	a4,a4,1520 # 8000b918 <cpus+0x8>
    80001330:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001332:	498d                	li	s3,3
        p->state = RUNNING;
    80001334:	4b11                	li	s6,4
        c->proc = p;
    80001336:	079e                	slli	a5,a5,0x7
    80001338:	0000aa17          	auipc	s4,0xa
    8000133c:	5a8a0a13          	addi	s4,s4,1448 # 8000b8e0 <pid_lock>
    80001340:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80001342:	00010917          	auipc	s2,0x10
    80001346:	3ce90913          	addi	s2,s2,974 # 80011710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000134a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000134e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001352:	10079073          	csrw	sstatus,a5
    80001356:	0000b497          	auipc	s1,0xb
    8000135a:	9ba48493          	addi	s1,s1,-1606 # 8000bd10 <proc>
    8000135e:	a811                	j	80001372 <scheduler+0x74>
      release(&p->lock);
    80001360:	8526                	mv	a0,s1
    80001362:	00006097          	auipc	ra,0x6
    80001366:	c10080e7          	jalr	-1008(ra) # 80006f72 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000136a:	16848493          	addi	s1,s1,360
    8000136e:	fd248ee3          	beq	s1,s2,8000134a <scheduler+0x4c>
      acquire(&p->lock);
    80001372:	8526                	mv	a0,s1
    80001374:	00006097          	auipc	ra,0x6
    80001378:	b4a080e7          	jalr	-1206(ra) # 80006ebe <acquire>
      if (p->state == RUNNABLE) {
    8000137c:	4c9c                	lw	a5,24(s1)
    8000137e:	ff3791e3          	bne	a5,s3,80001360 <scheduler+0x62>
        p->state = RUNNING;
    80001382:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001386:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000138a:	06048593          	addi	a1,s1,96
    8000138e:	8556                	mv	a0,s5
    80001390:	00000097          	auipc	ra,0x0
    80001394:	686080e7          	jalr	1670(ra) # 80001a16 <swtch>
        c->proc = 0;
    80001398:	020a3823          	sd	zero,48(s4)
    8000139c:	b7d1                	j	80001360 <scheduler+0x62>

000000008000139e <sched>:
void sched(void) {
    8000139e:	7179                	addi	sp,sp,-48
    800013a0:	f406                	sd	ra,40(sp)
    800013a2:	f022                	sd	s0,32(sp)
    800013a4:	ec26                	sd	s1,24(sp)
    800013a6:	e84a                	sd	s2,16(sp)
    800013a8:	e44e                	sd	s3,8(sp)
    800013aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	a56080e7          	jalr	-1450(ra) # 80000e02 <myproc>
    800013b4:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    800013b6:	00006097          	auipc	ra,0x6
    800013ba:	a8e080e7          	jalr	-1394(ra) # 80006e44 <holding>
    800013be:	c93d                	beqz	a0,80001434 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800013c0:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    800013c2:	2781                	sext.w	a5,a5
    800013c4:	079e                	slli	a5,a5,0x7
    800013c6:	0000a717          	auipc	a4,0xa
    800013ca:	51a70713          	addi	a4,a4,1306 # 8000b8e0 <pid_lock>
    800013ce:	97ba                	add	a5,a5,a4
    800013d0:	0a87a703          	lw	a4,168(a5)
    800013d4:	4785                	li	a5,1
    800013d6:	06f71763          	bne	a4,a5,80001444 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    800013da:	4c98                	lw	a4,24(s1)
    800013dc:	4791                	li	a5,4
    800013de:	06f70b63          	beq	a4,a5,80001454 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800013e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800013e6:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    800013e8:	efb5                	bnez	a5,80001464 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800013ea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800013ec:	0000a917          	auipc	s2,0xa
    800013f0:	4f490913          	addi	s2,s2,1268 # 8000b8e0 <pid_lock>
    800013f4:	2781                	sext.w	a5,a5
    800013f6:	079e                	slli	a5,a5,0x7
    800013f8:	97ca                	add	a5,a5,s2
    800013fa:	0ac7a983          	lw	s3,172(a5)
    800013fe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001400:	2781                	sext.w	a5,a5
    80001402:	079e                	slli	a5,a5,0x7
    80001404:	0000a597          	auipc	a1,0xa
    80001408:	51458593          	addi	a1,a1,1300 # 8000b918 <cpus+0x8>
    8000140c:	95be                	add	a1,a1,a5
    8000140e:	06048513          	addi	a0,s1,96
    80001412:	00000097          	auipc	ra,0x0
    80001416:	604080e7          	jalr	1540(ra) # 80001a16 <swtch>
    8000141a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000141c:	2781                	sext.w	a5,a5
    8000141e:	079e                	slli	a5,a5,0x7
    80001420:	993e                	add	s2,s2,a5
    80001422:	0b392623          	sw	s3,172(s2)
}
    80001426:	70a2                	ld	ra,40(sp)
    80001428:	7402                	ld	s0,32(sp)
    8000142a:	64e2                	ld	s1,24(sp)
    8000142c:	6942                	ld	s2,16(sp)
    8000142e:	69a2                	ld	s3,8(sp)
    80001430:	6145                	addi	sp,sp,48
    80001432:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001434:	00007517          	auipc	a0,0x7
    80001438:	d8c50513          	addi	a0,a0,-628 # 800081c0 <etext+0x1c0>
    8000143c:	00005097          	auipc	ra,0x5
    80001440:	508080e7          	jalr	1288(ra) # 80006944 <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001444:	00007517          	auipc	a0,0x7
    80001448:	d8c50513          	addi	a0,a0,-628 # 800081d0 <etext+0x1d0>
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	4f8080e7          	jalr	1272(ra) # 80006944 <panic>
  if (p->state == RUNNING) panic("sched running");
    80001454:	00007517          	auipc	a0,0x7
    80001458:	d8c50513          	addi	a0,a0,-628 # 800081e0 <etext+0x1e0>
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	4e8080e7          	jalr	1256(ra) # 80006944 <panic>
  if (intr_get()) panic("sched interruptible");
    80001464:	00007517          	auipc	a0,0x7
    80001468:	d8c50513          	addi	a0,a0,-628 # 800081f0 <etext+0x1f0>
    8000146c:	00005097          	auipc	ra,0x5
    80001470:	4d8080e7          	jalr	1240(ra) # 80006944 <panic>

0000000080001474 <yield>:
void yield(void) {
    80001474:	1101                	addi	sp,sp,-32
    80001476:	ec06                	sd	ra,24(sp)
    80001478:	e822                	sd	s0,16(sp)
    8000147a:	e426                	sd	s1,8(sp)
    8000147c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	984080e7          	jalr	-1660(ra) # 80000e02 <myproc>
    80001486:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001488:	00006097          	auipc	ra,0x6
    8000148c:	a36080e7          	jalr	-1482(ra) # 80006ebe <acquire>
  p->state = RUNNABLE;
    80001490:	478d                	li	a5,3
    80001492:	cc9c                	sw	a5,24(s1)
  sched();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	f0a080e7          	jalr	-246(ra) # 8000139e <sched>
  release(&p->lock);
    8000149c:	8526                	mv	a0,s1
    8000149e:	00006097          	auipc	ra,0x6
    800014a2:	ad4080e7          	jalr	-1324(ra) # 80006f72 <release>
}
    800014a6:	60e2                	ld	ra,24(sp)
    800014a8:	6442                	ld	s0,16(sp)
    800014aa:	64a2                	ld	s1,8(sp)
    800014ac:	6105                	addi	sp,sp,32
    800014ae:	8082                	ret

00000000800014b0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800014b0:	7179                	addi	sp,sp,-48
    800014b2:	f406                	sd	ra,40(sp)
    800014b4:	f022                	sd	s0,32(sp)
    800014b6:	ec26                	sd	s1,24(sp)
    800014b8:	e84a                	sd	s2,16(sp)
    800014ba:	e44e                	sd	s3,8(sp)
    800014bc:	1800                	addi	s0,sp,48
    800014be:	89aa                	mv	s3,a0
    800014c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800014c2:	00000097          	auipc	ra,0x0
    800014c6:	940080e7          	jalr	-1728(ra) # 80000e02 <myproc>
    800014ca:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    800014cc:	00006097          	auipc	ra,0x6
    800014d0:	9f2080e7          	jalr	-1550(ra) # 80006ebe <acquire>
  release(lk);
    800014d4:	854a                	mv	a0,s2
    800014d6:	00006097          	auipc	ra,0x6
    800014da:	a9c080e7          	jalr	-1380(ra) # 80006f72 <release>

  // Go to sleep.
  p->chan = chan;
    800014de:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800014e2:	4789                	li	a5,2
    800014e4:	cc9c                	sw	a5,24(s1)

  sched();
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	eb8080e7          	jalr	-328(ra) # 8000139e <sched>

  // Tidy up.
  p->chan = 0;
    800014ee:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00006097          	auipc	ra,0x6
    800014f8:	a7e080e7          	jalr	-1410(ra) # 80006f72 <release>
  acquire(lk);
    800014fc:	854a                	mv	a0,s2
    800014fe:	00006097          	auipc	ra,0x6
    80001502:	9c0080e7          	jalr	-1600(ra) # 80006ebe <acquire>
}
    80001506:	70a2                	ld	ra,40(sp)
    80001508:	7402                	ld	s0,32(sp)
    8000150a:	64e2                	ld	s1,24(sp)
    8000150c:	6942                	ld	s2,16(sp)
    8000150e:	69a2                	ld	s3,8(sp)
    80001510:	6145                	addi	sp,sp,48
    80001512:	8082                	ret

0000000080001514 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001514:	7139                	addi	sp,sp,-64
    80001516:	fc06                	sd	ra,56(sp)
    80001518:	f822                	sd	s0,48(sp)
    8000151a:	f426                	sd	s1,40(sp)
    8000151c:	f04a                	sd	s2,32(sp)
    8000151e:	ec4e                	sd	s3,24(sp)
    80001520:	e852                	sd	s4,16(sp)
    80001522:	e456                	sd	s5,8(sp)
    80001524:	0080                	addi	s0,sp,64
    80001526:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001528:	0000a497          	auipc	s1,0xa
    8000152c:	7e848493          	addi	s1,s1,2024 # 8000bd10 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001530:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001532:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001534:	00010917          	auipc	s2,0x10
    80001538:	1dc90913          	addi	s2,s2,476 # 80011710 <tickslock>
    8000153c:	a811                	j	80001550 <wakeup+0x3c>
      }
      release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00006097          	auipc	ra,0x6
    80001544:	a32080e7          	jalr	-1486(ra) # 80006f72 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001548:	16848493          	addi	s1,s1,360
    8000154c:	03248663          	beq	s1,s2,80001578 <wakeup+0x64>
    if (p != myproc()) {
    80001550:	00000097          	auipc	ra,0x0
    80001554:	8b2080e7          	jalr	-1870(ra) # 80000e02 <myproc>
    80001558:	fea488e3          	beq	s1,a0,80001548 <wakeup+0x34>
      acquire(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	00006097          	auipc	ra,0x6
    80001562:	960080e7          	jalr	-1696(ra) # 80006ebe <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001566:	4c9c                	lw	a5,24(s1)
    80001568:	fd379be3          	bne	a5,s3,8000153e <wakeup+0x2a>
    8000156c:	709c                	ld	a5,32(s1)
    8000156e:	fd4798e3          	bne	a5,s4,8000153e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001572:	0154ac23          	sw	s5,24(s1)
    80001576:	b7e1                	j	8000153e <wakeup+0x2a>
    }
  }
}
    80001578:	70e2                	ld	ra,56(sp)
    8000157a:	7442                	ld	s0,48(sp)
    8000157c:	74a2                	ld	s1,40(sp)
    8000157e:	7902                	ld	s2,32(sp)
    80001580:	69e2                	ld	s3,24(sp)
    80001582:	6a42                	ld	s4,16(sp)
    80001584:	6aa2                	ld	s5,8(sp)
    80001586:	6121                	addi	sp,sp,64
    80001588:	8082                	ret

000000008000158a <reparent>:
void reparent(struct proc *p) {
    8000158a:	7179                	addi	sp,sp,-48
    8000158c:	f406                	sd	ra,40(sp)
    8000158e:	f022                	sd	s0,32(sp)
    80001590:	ec26                	sd	s1,24(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e44e                	sd	s3,8(sp)
    80001596:	e052                	sd	s4,0(sp)
    80001598:	1800                	addi	s0,sp,48
    8000159a:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000159c:	0000a497          	auipc	s1,0xa
    800015a0:	77448493          	addi	s1,s1,1908 # 8000bd10 <proc>
      pp->parent = initproc;
    800015a4:	0000aa17          	auipc	s4,0xa
    800015a8:	2fca0a13          	addi	s4,s4,764 # 8000b8a0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015ac:	00010997          	auipc	s3,0x10
    800015b0:	16498993          	addi	s3,s3,356 # 80011710 <tickslock>
    800015b4:	a029                	j	800015be <reparent+0x34>
    800015b6:	16848493          	addi	s1,s1,360
    800015ba:	01348d63          	beq	s1,s3,800015d4 <reparent+0x4a>
    if (pp->parent == p) {
    800015be:	7c9c                	ld	a5,56(s1)
    800015c0:	ff279be3          	bne	a5,s2,800015b6 <reparent+0x2c>
      pp->parent = initproc;
    800015c4:	000a3503          	ld	a0,0(s4)
    800015c8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	f4a080e7          	jalr	-182(ra) # 80001514 <wakeup>
    800015d2:	b7d5                	j	800015b6 <reparent+0x2c>
}
    800015d4:	70a2                	ld	ra,40(sp)
    800015d6:	7402                	ld	s0,32(sp)
    800015d8:	64e2                	ld	s1,24(sp)
    800015da:	6942                	ld	s2,16(sp)
    800015dc:	69a2                	ld	s3,8(sp)
    800015de:	6a02                	ld	s4,0(sp)
    800015e0:	6145                	addi	sp,sp,48
    800015e2:	8082                	ret

00000000800015e4 <exit>:
void exit(int status) {
    800015e4:	7179                	addi	sp,sp,-48
    800015e6:	f406                	sd	ra,40(sp)
    800015e8:	f022                	sd	s0,32(sp)
    800015ea:	ec26                	sd	s1,24(sp)
    800015ec:	e84a                	sd	s2,16(sp)
    800015ee:	e44e                	sd	s3,8(sp)
    800015f0:	e052                	sd	s4,0(sp)
    800015f2:	1800                	addi	s0,sp,48
    800015f4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	80c080e7          	jalr	-2036(ra) # 80000e02 <myproc>
    800015fe:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001600:	0000a797          	auipc	a5,0xa
    80001604:	2a07b783          	ld	a5,672(a5) # 8000b8a0 <initproc>
    80001608:	0d050493          	addi	s1,a0,208
    8000160c:	15050913          	addi	s2,a0,336
    80001610:	02a79363          	bne	a5,a0,80001636 <exit+0x52>
    80001614:	00007517          	auipc	a0,0x7
    80001618:	bf450513          	addi	a0,a0,-1036 # 80008208 <etext+0x208>
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	328080e7          	jalr	808(ra) # 80006944 <panic>
      fileclose(f);
    80001624:	00002097          	auipc	ra,0x2
    80001628:	2f8080e7          	jalr	760(ra) # 8000391c <fileclose>
      p->ofile[fd] = 0;
    8000162c:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001630:	04a1                	addi	s1,s1,8
    80001632:	01248563          	beq	s1,s2,8000163c <exit+0x58>
    if (p->ofile[fd]) {
    80001636:	6088                	ld	a0,0(s1)
    80001638:	f575                	bnez	a0,80001624 <exit+0x40>
    8000163a:	bfdd                	j	80001630 <exit+0x4c>
  begin_op();
    8000163c:	00002097          	auipc	ra,0x2
    80001640:	e52080e7          	jalr	-430(ra) # 8000348e <begin_op>
  iput(p->cwd);
    80001644:	1509b503          	ld	a0,336(s3)
    80001648:	00001097          	auipc	ra,0x1
    8000164c:	636080e7          	jalr	1590(ra) # 80002c7e <iput>
  end_op();
    80001650:	00002097          	auipc	ra,0x2
    80001654:	eb8080e7          	jalr	-328(ra) # 80003508 <end_op>
  p->cwd = 0;
    80001658:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000165c:	0000a497          	auipc	s1,0xa
    80001660:	29c48493          	addi	s1,s1,668 # 8000b8f8 <wait_lock>
    80001664:	8526                	mv	a0,s1
    80001666:	00006097          	auipc	ra,0x6
    8000166a:	858080e7          	jalr	-1960(ra) # 80006ebe <acquire>
  reparent(p);
    8000166e:	854e                	mv	a0,s3
    80001670:	00000097          	auipc	ra,0x0
    80001674:	f1a080e7          	jalr	-230(ra) # 8000158a <reparent>
  wakeup(p->parent);
    80001678:	0389b503          	ld	a0,56(s3)
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	e98080e7          	jalr	-360(ra) # 80001514 <wakeup>
  acquire(&p->lock);
    80001684:	854e                	mv	a0,s3
    80001686:	00006097          	auipc	ra,0x6
    8000168a:	838080e7          	jalr	-1992(ra) # 80006ebe <acquire>
  p->xstate = status;
    8000168e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001692:	4795                	li	a5,5
    80001694:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001698:	8526                	mv	a0,s1
    8000169a:	00006097          	auipc	ra,0x6
    8000169e:	8d8080e7          	jalr	-1832(ra) # 80006f72 <release>
  sched();
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	cfc080e7          	jalr	-772(ra) # 8000139e <sched>
  panic("zombie exit");
    800016aa:	00007517          	auipc	a0,0x7
    800016ae:	b6e50513          	addi	a0,a0,-1170 # 80008218 <etext+0x218>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	292080e7          	jalr	658(ra) # 80006944 <panic>

00000000800016ba <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800016ba:	7179                	addi	sp,sp,-48
    800016bc:	f406                	sd	ra,40(sp)
    800016be:	f022                	sd	s0,32(sp)
    800016c0:	ec26                	sd	s1,24(sp)
    800016c2:	e84a                	sd	s2,16(sp)
    800016c4:	e44e                	sd	s3,8(sp)
    800016c6:	1800                	addi	s0,sp,48
    800016c8:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800016ca:	0000a497          	auipc	s1,0xa
    800016ce:	64648493          	addi	s1,s1,1606 # 8000bd10 <proc>
    800016d2:	00010997          	auipc	s3,0x10
    800016d6:	03e98993          	addi	s3,s3,62 # 80011710 <tickslock>
    acquire(&p->lock);
    800016da:	8526                	mv	a0,s1
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	7e2080e7          	jalr	2018(ra) # 80006ebe <acquire>
    if (p->pid == pid) {
    800016e4:	589c                	lw	a5,48(s1)
    800016e6:	01278d63          	beq	a5,s2,80001700 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00006097          	auipc	ra,0x6
    800016f0:	886080e7          	jalr	-1914(ra) # 80006f72 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800016f4:	16848493          	addi	s1,s1,360
    800016f8:	ff3491e3          	bne	s1,s3,800016da <kill+0x20>
  }
  return -1;
    800016fc:	557d                	li	a0,-1
    800016fe:	a829                	j	80001718 <kill+0x5e>
      p->killed = 1;
    80001700:	4785                	li	a5,1
    80001702:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001704:	4c98                	lw	a4,24(s1)
    80001706:	4789                	li	a5,2
    80001708:	00f70f63          	beq	a4,a5,80001726 <kill+0x6c>
      release(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00006097          	auipc	ra,0x6
    80001712:	864080e7          	jalr	-1948(ra) # 80006f72 <release>
      return 0;
    80001716:	4501                	li	a0,0
}
    80001718:	70a2                	ld	ra,40(sp)
    8000171a:	7402                	ld	s0,32(sp)
    8000171c:	64e2                	ld	s1,24(sp)
    8000171e:	6942                	ld	s2,16(sp)
    80001720:	69a2                	ld	s3,8(sp)
    80001722:	6145                	addi	sp,sp,48
    80001724:	8082                	ret
        p->state = RUNNABLE;
    80001726:	478d                	li	a5,3
    80001728:	cc9c                	sw	a5,24(s1)
    8000172a:	b7cd                	j	8000170c <kill+0x52>

000000008000172c <setkilled>:

void setkilled(struct proc *p) {
    8000172c:	1101                	addi	sp,sp,-32
    8000172e:	ec06                	sd	ra,24(sp)
    80001730:	e822                	sd	s0,16(sp)
    80001732:	e426                	sd	s1,8(sp)
    80001734:	1000                	addi	s0,sp,32
    80001736:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	786080e7          	jalr	1926(ra) # 80006ebe <acquire>
  p->killed = 1;
    80001740:	4785                	li	a5,1
    80001742:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	00006097          	auipc	ra,0x6
    8000174a:	82c080e7          	jalr	-2004(ra) # 80006f72 <release>
}
    8000174e:	60e2                	ld	ra,24(sp)
    80001750:	6442                	ld	s0,16(sp)
    80001752:	64a2                	ld	s1,8(sp)
    80001754:	6105                	addi	sp,sp,32
    80001756:	8082                	ret

0000000080001758 <killed>:

int killed(struct proc *p) {
    80001758:	1101                	addi	sp,sp,-32
    8000175a:	ec06                	sd	ra,24(sp)
    8000175c:	e822                	sd	s0,16(sp)
    8000175e:	e426                	sd	s1,8(sp)
    80001760:	e04a                	sd	s2,0(sp)
    80001762:	1000                	addi	s0,sp,32
    80001764:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	758080e7          	jalr	1880(ra) # 80006ebe <acquire>
  k = p->killed;
    8000176e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001772:	8526                	mv	a0,s1
    80001774:	00005097          	auipc	ra,0x5
    80001778:	7fe080e7          	jalr	2046(ra) # 80006f72 <release>
  return k;
}
    8000177c:	854a                	mv	a0,s2
    8000177e:	60e2                	ld	ra,24(sp)
    80001780:	6442                	ld	s0,16(sp)
    80001782:	64a2                	ld	s1,8(sp)
    80001784:	6902                	ld	s2,0(sp)
    80001786:	6105                	addi	sp,sp,32
    80001788:	8082                	ret

000000008000178a <wait>:
int wait(uint64 addr) {
    8000178a:	715d                	addi	sp,sp,-80
    8000178c:	e486                	sd	ra,72(sp)
    8000178e:	e0a2                	sd	s0,64(sp)
    80001790:	fc26                	sd	s1,56(sp)
    80001792:	f84a                	sd	s2,48(sp)
    80001794:	f44e                	sd	s3,40(sp)
    80001796:	f052                	sd	s4,32(sp)
    80001798:	ec56                	sd	s5,24(sp)
    8000179a:	e85a                	sd	s6,16(sp)
    8000179c:	e45e                	sd	s7,8(sp)
    8000179e:	e062                	sd	s8,0(sp)
    800017a0:	0880                	addi	s0,sp,80
    800017a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	65e080e7          	jalr	1630(ra) # 80000e02 <myproc>
    800017ac:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017ae:	0000a517          	auipc	a0,0xa
    800017b2:	14a50513          	addi	a0,a0,330 # 8000b8f8 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	708080e7          	jalr	1800(ra) # 80006ebe <acquire>
    havekids = 0;
    800017be:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    800017c0:	4a15                	li	s4,5
        havekids = 1;
    800017c2:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800017c4:	00010997          	auipc	s3,0x10
    800017c8:	f4c98993          	addi	s3,s3,-180 # 80011710 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800017cc:	0000ac17          	auipc	s8,0xa
    800017d0:	12cc0c13          	addi	s8,s8,300 # 8000b8f8 <wait_lock>
    800017d4:	a0d1                	j	80001898 <wait+0x10e>
          pid = pp->pid;
    800017d6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800017da:	000b0e63          	beqz	s6,800017f6 <wait+0x6c>
    800017de:	4691                	li	a3,4
    800017e0:	02c48613          	addi	a2,s1,44
    800017e4:	85da                	mv	a1,s6
    800017e6:	05093503          	ld	a0,80(s2)
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	25e080e7          	jalr	606(ra) # 80000a48 <copyout>
    800017f2:	04054163          	bltz	a0,80001834 <wait+0xaa>
          freeproc(pp);
    800017f6:	8526                	mv	a0,s1
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	7c0080e7          	jalr	1984(ra) # 80000fb8 <freeproc>
          release(&pp->lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	770080e7          	jalr	1904(ra) # 80006f72 <release>
          release(&wait_lock);
    8000180a:	0000a517          	auipc	a0,0xa
    8000180e:	0ee50513          	addi	a0,a0,238 # 8000b8f8 <wait_lock>
    80001812:	00005097          	auipc	ra,0x5
    80001816:	760080e7          	jalr	1888(ra) # 80006f72 <release>
}
    8000181a:	854e                	mv	a0,s3
    8000181c:	60a6                	ld	ra,72(sp)
    8000181e:	6406                	ld	s0,64(sp)
    80001820:	74e2                	ld	s1,56(sp)
    80001822:	7942                	ld	s2,48(sp)
    80001824:	79a2                	ld	s3,40(sp)
    80001826:	7a02                	ld	s4,32(sp)
    80001828:	6ae2                	ld	s5,24(sp)
    8000182a:	6b42                	ld	s6,16(sp)
    8000182c:	6ba2                	ld	s7,8(sp)
    8000182e:	6c02                	ld	s8,0(sp)
    80001830:	6161                	addi	sp,sp,80
    80001832:	8082                	ret
            release(&pp->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	73c080e7          	jalr	1852(ra) # 80006f72 <release>
            release(&wait_lock);
    8000183e:	0000a517          	auipc	a0,0xa
    80001842:	0ba50513          	addi	a0,a0,186 # 8000b8f8 <wait_lock>
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	72c080e7          	jalr	1836(ra) # 80006f72 <release>
            return -1;
    8000184e:	59fd                	li	s3,-1
    80001850:	b7e9                	j	8000181a <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001852:	16848493          	addi	s1,s1,360
    80001856:	03348463          	beq	s1,s3,8000187e <wait+0xf4>
      if (pp->parent == p) {
    8000185a:	7c9c                	ld	a5,56(s1)
    8000185c:	ff279be3          	bne	a5,s2,80001852 <wait+0xc8>
        acquire(&pp->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	65c080e7          	jalr	1628(ra) # 80006ebe <acquire>
        if (pp->state == ZOMBIE) {
    8000186a:	4c9c                	lw	a5,24(s1)
    8000186c:	f74785e3          	beq	a5,s4,800017d6 <wait+0x4c>
        release(&pp->lock);
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	700080e7          	jalr	1792(ra) # 80006f72 <release>
        havekids = 1;
    8000187a:	8756                	mv	a4,s5
    8000187c:	bfd9                	j	80001852 <wait+0xc8>
    if (!havekids || killed(p)) {
    8000187e:	c31d                	beqz	a4,800018a4 <wait+0x11a>
    80001880:	854a                	mv	a0,s2
    80001882:	00000097          	auipc	ra,0x0
    80001886:	ed6080e7          	jalr	-298(ra) # 80001758 <killed>
    8000188a:	ed09                	bnez	a0,800018a4 <wait+0x11a>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    8000188c:	85e2                	mv	a1,s8
    8000188e:	854a                	mv	a0,s2
    80001890:	00000097          	auipc	ra,0x0
    80001894:	c20080e7          	jalr	-992(ra) # 800014b0 <sleep>
    havekids = 0;
    80001898:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000189a:	0000a497          	auipc	s1,0xa
    8000189e:	47648493          	addi	s1,s1,1142 # 8000bd10 <proc>
    800018a2:	bf65                	j	8000185a <wait+0xd0>
      release(&wait_lock);
    800018a4:	0000a517          	auipc	a0,0xa
    800018a8:	05450513          	addi	a0,a0,84 # 8000b8f8 <wait_lock>
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	6c6080e7          	jalr	1734(ra) # 80006f72 <release>
      return -1;
    800018b4:	59fd                	li	s3,-1
    800018b6:	b795                	j	8000181a <wait+0x90>

00000000800018b8 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800018b8:	7179                	addi	sp,sp,-48
    800018ba:	f406                	sd	ra,40(sp)
    800018bc:	f022                	sd	s0,32(sp)
    800018be:	ec26                	sd	s1,24(sp)
    800018c0:	e84a                	sd	s2,16(sp)
    800018c2:	e44e                	sd	s3,8(sp)
    800018c4:	e052                	sd	s4,0(sp)
    800018c6:	1800                	addi	s0,sp,48
    800018c8:	84aa                	mv	s1,a0
    800018ca:	892e                	mv	s2,a1
    800018cc:	89b2                	mv	s3,a2
    800018ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	532080e7          	jalr	1330(ra) # 80000e02 <myproc>
  if (user_dst) {
    800018d8:	c08d                	beqz	s1,800018fa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018da:	86d2                	mv	a3,s4
    800018dc:	864e                	mv	a2,s3
    800018de:	85ca                	mv	a1,s2
    800018e0:	6928                	ld	a0,80(a0)
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	166080e7          	jalr	358(ra) # 80000a48 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6a02                	ld	s4,0(sp)
    800018f6:	6145                	addi	sp,sp,48
    800018f8:	8082                	ret
    memmove((char *)dst, src, len);
    800018fa:	000a061b          	sext.w	a2,s4
    800018fe:	85ce                	mv	a1,s3
    80001900:	854a                	mv	a0,s2
    80001902:	ffffe097          	auipc	ra,0xffffe
    80001906:	7d0080e7          	jalr	2000(ra) # 800000d2 <memmove>
    return 0;
    8000190a:	8526                	mv	a0,s1
    8000190c:	bff9                	j	800018ea <either_copyout+0x32>

000000008000190e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000190e:	7179                	addi	sp,sp,-48
    80001910:	f406                	sd	ra,40(sp)
    80001912:	f022                	sd	s0,32(sp)
    80001914:	ec26                	sd	s1,24(sp)
    80001916:	e84a                	sd	s2,16(sp)
    80001918:	e44e                	sd	s3,8(sp)
    8000191a:	e052                	sd	s4,0(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	892a                	mv	s2,a0
    80001920:	84ae                	mv	s1,a1
    80001922:	89b2                	mv	s3,a2
    80001924:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	4dc080e7          	jalr	1244(ra) # 80000e02 <myproc>
  if (user_src) {
    8000192e:	c08d                	beqz	s1,80001950 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001930:	86d2                	mv	a3,s4
    80001932:	864e                	mv	a2,s3
    80001934:	85ca                	mv	a1,s2
    80001936:	6928                	ld	a0,80(a0)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	1ee080e7          	jalr	494(ra) # 80000b26 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001940:	70a2                	ld	ra,40(sp)
    80001942:	7402                	ld	s0,32(sp)
    80001944:	64e2                	ld	s1,24(sp)
    80001946:	6942                	ld	s2,16(sp)
    80001948:	69a2                	ld	s3,8(sp)
    8000194a:	6a02                	ld	s4,0(sp)
    8000194c:	6145                	addi	sp,sp,48
    8000194e:	8082                	ret
    memmove(dst, (char *)src, len);
    80001950:	000a061b          	sext.w	a2,s4
    80001954:	85ce                	mv	a1,s3
    80001956:	854a                	mv	a0,s2
    80001958:	ffffe097          	auipc	ra,0xffffe
    8000195c:	77a080e7          	jalr	1914(ra) # 800000d2 <memmove>
    return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	bff9                	j	80001940 <either_copyin+0x32>

0000000080001964 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001964:	715d                	addi	sp,sp,-80
    80001966:	e486                	sd	ra,72(sp)
    80001968:	e0a2                	sd	s0,64(sp)
    8000196a:	fc26                	sd	s1,56(sp)
    8000196c:	f84a                	sd	s2,48(sp)
    8000196e:	f44e                	sd	s3,40(sp)
    80001970:	f052                	sd	s4,32(sp)
    80001972:	ec56                	sd	s5,24(sp)
    80001974:	e85a                	sd	s6,16(sp)
    80001976:	e45e                	sd	s7,8(sp)
    80001978:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    8000197a:	00006517          	auipc	a0,0x6
    8000197e:	68650513          	addi	a0,a0,1670 # 80008000 <etext>
    80001982:	00005097          	auipc	ra,0x5
    80001986:	00c080e7          	jalr	12(ra) # 8000698e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000198a:	0000a497          	auipc	s1,0xa
    8000198e:	38648493          	addi	s1,s1,902 # 8000bd10 <proc>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001992:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001994:	00007997          	auipc	s3,0x7
    80001998:	89498993          	addi	s3,s3,-1900 # 80008228 <etext+0x228>
    printf("%p %p %d %s %s", p->parent, p, p->pid, state, p->name);
    8000199c:	00007a97          	auipc	s5,0x7
    800019a0:	894a8a93          	addi	s5,s5,-1900 # 80008230 <etext+0x230>
    printf("\n");
    800019a4:	00006a17          	auipc	s4,0x6
    800019a8:	65ca0a13          	addi	s4,s4,1628 # 80008000 <etext>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ac:	00007b97          	auipc	s7,0x7
    800019b0:	ee4b8b93          	addi	s7,s7,-284 # 80008890 <states.0>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019b4:	00010917          	auipc	s2,0x10
    800019b8:	d5c90913          	addi	s2,s2,-676 # 80011710 <tickslock>
    800019bc:	a025                	j	800019e4 <procdump+0x80>
    printf("%p %p %d %s %s", p->parent, p, p->pid, state, p->name);
    800019be:	15848793          	addi	a5,s1,344
    800019c2:	5894                	lw	a3,48(s1)
    800019c4:	8626                	mv	a2,s1
    800019c6:	7c8c                	ld	a1,56(s1)
    800019c8:	8556                	mv	a0,s5
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	fc4080e7          	jalr	-60(ra) # 8000698e <printf>
    printf("\n");
    800019d2:	8552                	mv	a0,s4
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	fba080e7          	jalr	-70(ra) # 8000698e <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019dc:	16848493          	addi	s1,s1,360
    800019e0:	03248063          	beq	s1,s2,80001a00 <procdump+0x9c>
    if (p->state == UNUSED) continue;
    800019e4:	4c9c                	lw	a5,24(s1)
    800019e6:	dbfd                	beqz	a5,800019dc <procdump+0x78>
      state = "???";
    800019e8:	874e                	mv	a4,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ea:	fcfb6ae3          	bltu	s6,a5,800019be <procdump+0x5a>
    800019ee:	02079713          	slli	a4,a5,0x20
    800019f2:	01d75793          	srli	a5,a4,0x1d
    800019f6:	97de                	add	a5,a5,s7
    800019f8:	6398                	ld	a4,0(a5)
    800019fa:	f371                	bnez	a4,800019be <procdump+0x5a>
      state = "???";
    800019fc:	874e                	mv	a4,s3
    800019fe:	b7c1                	j	800019be <procdump+0x5a>
  }
}
    80001a00:	60a6                	ld	ra,72(sp)
    80001a02:	6406                	ld	s0,64(sp)
    80001a04:	74e2                	ld	s1,56(sp)
    80001a06:	7942                	ld	s2,48(sp)
    80001a08:	79a2                	ld	s3,40(sp)
    80001a0a:	7a02                	ld	s4,32(sp)
    80001a0c:	6ae2                	ld	s5,24(sp)
    80001a0e:	6b42                	ld	s6,16(sp)
    80001a10:	6ba2                	ld	s7,8(sp)
    80001a12:	6161                	addi	sp,sp,80
    80001a14:	8082                	ret

0000000080001a16 <swtch>:
    80001a16:	00153023          	sd	ra,0(a0)
    80001a1a:	00253423          	sd	sp,8(a0)
    80001a1e:	e900                	sd	s0,16(a0)
    80001a20:	ed04                	sd	s1,24(a0)
    80001a22:	03253023          	sd	s2,32(a0)
    80001a26:	03353423          	sd	s3,40(a0)
    80001a2a:	03453823          	sd	s4,48(a0)
    80001a2e:	03553c23          	sd	s5,56(a0)
    80001a32:	05653023          	sd	s6,64(a0)
    80001a36:	05753423          	sd	s7,72(a0)
    80001a3a:	05853823          	sd	s8,80(a0)
    80001a3e:	05953c23          	sd	s9,88(a0)
    80001a42:	07a53023          	sd	s10,96(a0)
    80001a46:	07b53423          	sd	s11,104(a0)
    80001a4a:	0005b083          	ld	ra,0(a1)
    80001a4e:	0085b103          	ld	sp,8(a1)
    80001a52:	6980                	ld	s0,16(a1)
    80001a54:	6d84                	ld	s1,24(a1)
    80001a56:	0205b903          	ld	s2,32(a1)
    80001a5a:	0285b983          	ld	s3,40(a1)
    80001a5e:	0305ba03          	ld	s4,48(a1)
    80001a62:	0385ba83          	ld	s5,56(a1)
    80001a66:	0405bb03          	ld	s6,64(a1)
    80001a6a:	0485bb83          	ld	s7,72(a1)
    80001a6e:	0505bc03          	ld	s8,80(a1)
    80001a72:	0585bc83          	ld	s9,88(a1)
    80001a76:	0605bd03          	ld	s10,96(a1)
    80001a7a:	0685bd83          	ld	s11,104(a1)
    80001a7e:	8082                	ret

0000000080001a80 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001a80:	1141                	addi	sp,sp,-16
    80001a82:	e406                	sd	ra,8(sp)
    80001a84:	e022                	sd	s0,0(sp)
    80001a86:	0800                	addi	s0,sp,16
    80001a88:	00006597          	auipc	a1,0x6
    80001a8c:	7e858593          	addi	a1,a1,2024 # 80008270 <etext+0x270>
    80001a90:	00010517          	auipc	a0,0x10
    80001a94:	c8050513          	addi	a0,a0,-896 # 80011710 <tickslock>
    80001a98:	00005097          	auipc	ra,0x5
    80001a9c:	396080e7          	jalr	918(ra) # 80006e2e <initlock>
    80001aa0:	60a2                	ld	ra,8(sp)
    80001aa2:	6402                	ld	s0,0(sp)
    80001aa4:	0141                	addi	sp,sp,16
    80001aa6:	8082                	ret

0000000080001aa8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e422                	sd	s0,8(sp)
    80001aac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001aae:	00003797          	auipc	a5,0x3
    80001ab2:	54278793          	addi	a5,a5,1346 # 80004ff0 <kernelvec>
    80001ab6:	10579073          	csrw	stvec,a5
    80001aba:	6422                	ld	s0,8(sp)
    80001abc:	0141                	addi	sp,sp,16
    80001abe:	8082                	ret

0000000080001ac0 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001ac0:	1141                	addi	sp,sp,-16
    80001ac2:	e406                	sd	ra,8(sp)
    80001ac4:	e022                	sd	s0,0(sp)
    80001ac6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	33a080e7          	jalr	826(ra) # 80000e02 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ad0:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001ad4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ad6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ada:	00005697          	auipc	a3,0x5
    80001ade:	52668693          	addi	a3,a3,1318 # 80007000 <_trampoline>
    80001ae2:	00005717          	auipc	a4,0x5
    80001ae6:	51e70713          	addi	a4,a4,1310 # 80007000 <_trampoline>
    80001aea:	8f15                	sub	a4,a4,a3
    80001aec:	040007b7          	lui	a5,0x4000
    80001af0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001af2:	07b2                	slli	a5,a5,0xc
    80001af4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001af6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001afa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001afc:	18002673          	csrr	a2,satp
    80001b00:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001b02:	6d30                	ld	a2,88(a0)
    80001b04:	6138                	ld	a4,64(a0)
    80001b06:	6585                	lui	a1,0x1
    80001b08:	972e                	add	a4,a4,a1
    80001b0a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b0c:	6d38                	ld	a4,88(a0)
    80001b0e:	00000617          	auipc	a2,0x0
    80001b12:	13860613          	addi	a2,a2,312 # 80001c46 <usertrap>
    80001b16:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001b18:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001b1a:	8612                	mv	a2,tp
    80001b1c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b1e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001b22:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001b26:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b2a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001b30:	6f18                	ld	a4,24(a4)
    80001b32:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b36:	6928                	ld	a0,80(a0)
    80001b38:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b3a:	00005717          	auipc	a4,0x5
    80001b3e:	56270713          	addi	a4,a4,1378 # 8000709c <userret>
    80001b42:	8f15                	sub	a4,a4,a3
    80001b44:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b46:	577d                	li	a4,-1
    80001b48:	177e                	slli	a4,a4,0x3f
    80001b4a:	8d59                	or	a0,a0,a4
    80001b4c:	9782                	jalr	a5
}
    80001b4e:	60a2                	ld	ra,8(sp)
    80001b50:	6402                	ld	s0,0(sp)
    80001b52:	0141                	addi	sp,sp,16
    80001b54:	8082                	ret

0000000080001b56 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b60:	00010497          	auipc	s1,0x10
    80001b64:	bb048493          	addi	s1,s1,-1104 # 80011710 <tickslock>
    80001b68:	8526                	mv	a0,s1
    80001b6a:	00005097          	auipc	ra,0x5
    80001b6e:	354080e7          	jalr	852(ra) # 80006ebe <acquire>
  ticks++;
    80001b72:	0000a517          	auipc	a0,0xa
    80001b76:	d3650513          	addi	a0,a0,-714 # 8000b8a8 <ticks>
    80001b7a:	411c                	lw	a5,0(a0)
    80001b7c:	2785                	addiw	a5,a5,1
    80001b7e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	994080e7          	jalr	-1644(ra) # 80001514 <wakeup>
  release(&tickslock);
    80001b88:	8526                	mv	a0,s1
    80001b8a:	00005097          	auipc	ra,0x5
    80001b8e:	3e8080e7          	jalr	1000(ra) # 80006f72 <release>
}
    80001b92:	60e2                	ld	ra,24(sp)
    80001b94:	6442                	ld	s0,16(sp)
    80001b96:	64a2                	ld	s1,8(sp)
    80001b98:	6105                	addi	sp,sp,32
    80001b9a:	8082                	ret

0000000080001b9c <devintr>:
  asm volatile("csrr %0, scause" : "=r"(x));
    80001b9c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba0:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001ba2:	0a07d163          	bgez	a5,80001c44 <devintr+0xa8>
int devintr() {
    80001ba6:	1101                	addi	sp,sp,-32
    80001ba8:	ec06                	sd	ra,24(sp)
    80001baa:	e822                	sd	s0,16(sp)
    80001bac:	1000                	addi	s0,sp,32
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001bae:	0ff7f713          	zext.b	a4,a5
    80001bb2:	46a5                	li	a3,9
    80001bb4:	00d70c63          	beq	a4,a3,80001bcc <devintr+0x30>
  } else if (scause == 0x8000000000000001L) {
    80001bb8:	577d                	li	a4,-1
    80001bba:	177e                	slli	a4,a4,0x3f
    80001bbc:	0705                	addi	a4,a4,1
    return 0;
    80001bbe:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001bc0:	06e78163          	beq	a5,a4,80001c22 <devintr+0x86>
  }
}
    80001bc4:	60e2                	ld	ra,24(sp)
    80001bc6:	6442                	ld	s0,16(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret
    80001bcc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001bce:	00003097          	auipc	ra,0x3
    80001bd2:	52e080e7          	jalr	1326(ra) # 800050fc <plic_claim>
    80001bd6:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001bd8:	47a9                	li	a5,10
    80001bda:	00f50963          	beq	a0,a5,80001bec <devintr+0x50>
    } else if (irq == VIRTIO0_IRQ) {
    80001bde:	4785                	li	a5,1
    80001be0:	00f50b63          	beq	a0,a5,80001bf6 <devintr+0x5a>
    return 1;
    80001be4:	4505                	li	a0,1
    } else if (irq) {
    80001be6:	ec89                	bnez	s1,80001c00 <devintr+0x64>
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	bfe9                	j	80001bc4 <devintr+0x28>
      uartintr();
    80001bec:	00005097          	auipc	ra,0x5
    80001bf0:	1f2080e7          	jalr	498(ra) # 80006dde <uartintr>
    if (irq) plic_complete(irq);
    80001bf4:	a839                	j	80001c12 <devintr+0x76>
      virtio_disk_intr();
    80001bf6:	00004097          	auipc	ra,0x4
    80001bfa:	a30080e7          	jalr	-1488(ra) # 80005626 <virtio_disk_intr>
    if (irq) plic_complete(irq);
    80001bfe:	a811                	j	80001c12 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c00:	85a6                	mv	a1,s1
    80001c02:	00006517          	auipc	a0,0x6
    80001c06:	67650513          	addi	a0,a0,1654 # 80008278 <etext+0x278>
    80001c0a:	00005097          	auipc	ra,0x5
    80001c0e:	d84080e7          	jalr	-636(ra) # 8000698e <printf>
    if (irq) plic_complete(irq);
    80001c12:	8526                	mv	a0,s1
    80001c14:	00003097          	auipc	ra,0x3
    80001c18:	50c080e7          	jalr	1292(ra) # 80005120 <plic_complete>
    return 1;
    80001c1c:	4505                	li	a0,1
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	b755                	j	80001bc4 <devintr+0x28>
    if (cpuid() == 0) {
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	1b4080e7          	jalr	436(ra) # 80000dd6 <cpuid>
    80001c2a:	c901                	beqz	a0,80001c3a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001c2c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c30:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001c32:	14479073          	csrw	sip,a5
    return 2;
    80001c36:	4509                	li	a0,2
    80001c38:	b771                	j	80001bc4 <devintr+0x28>
      clockintr();
    80001c3a:	00000097          	auipc	ra,0x0
    80001c3e:	f1c080e7          	jalr	-228(ra) # 80001b56 <clockintr>
    80001c42:	b7ed                	j	80001c2c <devintr+0x90>
}
    80001c44:	8082                	ret

0000000080001c46 <usertrap>:
void usertrap(void) {
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	e04a                	sd	s2,0(sp)
    80001c50:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c52:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001c56:	1007f793          	andi	a5,a5,256
    80001c5a:	e3b1                	bnez	a5,80001c9e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c5c:	00003797          	auipc	a5,0x3
    80001c60:	39478793          	addi	a5,a5,916 # 80004ff0 <kernelvec>
    80001c64:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	19a080e7          	jalr	410(ra) # 80000e02 <myproc>
    80001c70:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c72:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001c74:	14102773          	csrr	a4,sepc
    80001c78:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001c7a:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001c7e:	47a1                	li	a5,8
    80001c80:	02f70763          	beq	a4,a5,80001cae <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001c84:	00000097          	auipc	ra,0x0
    80001c88:	f18080e7          	jalr	-232(ra) # 80001b9c <devintr>
    80001c8c:	892a                	mv	s2,a0
    80001c8e:	c151                	beqz	a0,80001d12 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001c90:	8526                	mv	a0,s1
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	ac6080e7          	jalr	-1338(ra) # 80001758 <killed>
    80001c9a:	c929                	beqz	a0,80001cec <usertrap+0xa6>
    80001c9c:	a099                	j	80001ce2 <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001c9e:	00006517          	auipc	a0,0x6
    80001ca2:	5fa50513          	addi	a0,a0,1530 # 80008298 <etext+0x298>
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	c9e080e7          	jalr	-866(ra) # 80006944 <panic>
    if (killed(p)) exit(-1);
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	aaa080e7          	jalr	-1366(ra) # 80001758 <killed>
    80001cb6:	e921                	bnez	a0,80001d06 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cb8:	6cb8                	ld	a4,88(s1)
    80001cba:	6f1c                	ld	a5,24(a4)
    80001cbc:	0791                	addi	a5,a5,4
    80001cbe:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001cc0:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001cc4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001cc8:	10079073          	csrw	sstatus,a5
    syscall();
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	2d4080e7          	jalr	724(ra) # 80001fa0 <syscall>
  if (killed(p)) exit(-1);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	a82080e7          	jalr	-1406(ra) # 80001758 <killed>
    80001cde:	c911                	beqz	a0,80001cf2 <usertrap+0xac>
    80001ce0:	4901                	li	s2,0
    80001ce2:	557d                	li	a0,-1
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	900080e7          	jalr	-1792(ra) # 800015e4 <exit>
  if (which_dev == 2) yield();
    80001cec:	4789                	li	a5,2
    80001cee:	04f90f63          	beq	s2,a5,80001d4c <usertrap+0x106>
  usertrapret();
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	dce080e7          	jalr	-562(ra) # 80001ac0 <usertrapret>
}
    80001cfa:	60e2                	ld	ra,24(sp)
    80001cfc:	6442                	ld	s0,16(sp)
    80001cfe:	64a2                	ld	s1,8(sp)
    80001d00:	6902                	ld	s2,0(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret
    if (killed(p)) exit(-1);
    80001d06:	557d                	li	a0,-1
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	8dc080e7          	jalr	-1828(ra) # 800015e4 <exit>
    80001d10:	b765                	j	80001cb8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d12:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d16:	5890                	lw	a2,48(s1)
    80001d18:	00006517          	auipc	a0,0x6
    80001d1c:	5a050513          	addi	a0,a0,1440 # 800082b8 <etext+0x2b8>
    80001d20:	00005097          	auipc	ra,0x5
    80001d24:	c6e080e7          	jalr	-914(ra) # 8000698e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d28:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001d2c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d30:	00006517          	auipc	a0,0x6
    80001d34:	5b850513          	addi	a0,a0,1464 # 800082e8 <etext+0x2e8>
    80001d38:	00005097          	auipc	ra,0x5
    80001d3c:	c56080e7          	jalr	-938(ra) # 8000698e <printf>
    setkilled(p);
    80001d40:	8526                	mv	a0,s1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	9ea080e7          	jalr	-1558(ra) # 8000172c <setkilled>
    80001d4a:	b769                	j	80001cd4 <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001d4c:	fffff097          	auipc	ra,0xfffff
    80001d50:	728080e7          	jalr	1832(ra) # 80001474 <yield>
    80001d54:	bf79                	j	80001cf2 <usertrap+0xac>

0000000080001d56 <kerneltrap>:
void kerneltrap() {
    80001d56:	7179                	addi	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	e84a                	sd	s2,16(sp)
    80001d60:	e44e                	sd	s3,8(sp)
    80001d62:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d64:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d68:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d6c:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001d70:	1004f793          	andi	a5,s1,256
    80001d74:	cb85                	beqz	a5,80001da4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d76:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d7a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001d7c:	ef85                	bnez	a5,80001db4 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	e1e080e7          	jalr	-482(ra) # 80001b9c <devintr>
    80001d86:	cd1d                	beqz	a0,80001dc4 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001d88:	4789                	li	a5,2
    80001d8a:	06f50a63          	beq	a0,a5,80001dfe <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001d8e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d92:	10049073          	csrw	sstatus,s1
}
    80001d96:	70a2                	ld	ra,40(sp)
    80001d98:	7402                	ld	s0,32(sp)
    80001d9a:	64e2                	ld	s1,24(sp)
    80001d9c:	6942                	ld	s2,16(sp)
    80001d9e:	69a2                	ld	s3,8(sp)
    80001da0:	6145                	addi	sp,sp,48
    80001da2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	56450513          	addi	a0,a0,1380 # 80008308 <etext+0x308>
    80001dac:	00005097          	auipc	ra,0x5
    80001db0:	b98080e7          	jalr	-1128(ra) # 80006944 <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	57c50513          	addi	a0,a0,1404 # 80008330 <etext+0x330>
    80001dbc:	00005097          	auipc	ra,0x5
    80001dc0:	b88080e7          	jalr	-1144(ra) # 80006944 <panic>
    printf("scause %p\n", scause);
    80001dc4:	85ce                	mv	a1,s3
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	58a50513          	addi	a0,a0,1418 # 80008350 <etext+0x350>
    80001dce:	00005097          	auipc	ra,0x5
    80001dd2:	bc0080e7          	jalr	-1088(ra) # 8000698e <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001dd6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001dda:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dde:	00006517          	auipc	a0,0x6
    80001de2:	58250513          	addi	a0,a0,1410 # 80008360 <etext+0x360>
    80001de6:	00005097          	auipc	ra,0x5
    80001dea:	ba8080e7          	jalr	-1112(ra) # 8000698e <printf>
    panic("kerneltrap");
    80001dee:	00006517          	auipc	a0,0x6
    80001df2:	58a50513          	addi	a0,a0,1418 # 80008378 <etext+0x378>
    80001df6:	00005097          	auipc	ra,0x5
    80001dfa:	b4e080e7          	jalr	-1202(ra) # 80006944 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	004080e7          	jalr	4(ra) # 80000e02 <myproc>
    80001e06:	d541                	beqz	a0,80001d8e <kerneltrap+0x38>
    80001e08:	fffff097          	auipc	ra,0xfffff
    80001e0c:	ffa080e7          	jalr	-6(ra) # 80000e02 <myproc>
    80001e10:	4d18                	lw	a4,24(a0)
    80001e12:	4791                	li	a5,4
    80001e14:	f6f71de3          	bne	a4,a5,80001d8e <kerneltrap+0x38>
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	65c080e7          	jalr	1628(ra) # 80001474 <yield>
    80001e20:	b7bd                	j	80001d8e <kerneltrap+0x38>

0000000080001e22 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001e22:	1101                	addi	sp,sp,-32
    80001e24:	ec06                	sd	ra,24(sp)
    80001e26:	e822                	sd	s0,16(sp)
    80001e28:	e426                	sd	s1,8(sp)
    80001e2a:	1000                	addi	s0,sp,32
    80001e2c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	fd4080e7          	jalr	-44(ra) # 80000e02 <myproc>
  switch (n) {
    80001e36:	4795                	li	a5,5
    80001e38:	0497e163          	bltu	a5,s1,80001e7a <argraw+0x58>
    80001e3c:	048a                	slli	s1,s1,0x2
    80001e3e:	00007717          	auipc	a4,0x7
    80001e42:	a8270713          	addi	a4,a4,-1406 # 800088c0 <states.0+0x30>
    80001e46:	94ba                	add	s1,s1,a4
    80001e48:	409c                	lw	a5,0(s1)
    80001e4a:	97ba                	add	a5,a5,a4
    80001e4c:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001e4e:	6d3c                	ld	a5,88(a0)
    80001e50:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e52:	60e2                	ld	ra,24(sp)
    80001e54:	6442                	ld	s0,16(sp)
    80001e56:	64a2                	ld	s1,8(sp)
    80001e58:	6105                	addi	sp,sp,32
    80001e5a:	8082                	ret
      return p->trapframe->a1;
    80001e5c:	6d3c                	ld	a5,88(a0)
    80001e5e:	7fa8                	ld	a0,120(a5)
    80001e60:	bfcd                	j	80001e52 <argraw+0x30>
      return p->trapframe->a2;
    80001e62:	6d3c                	ld	a5,88(a0)
    80001e64:	63c8                	ld	a0,128(a5)
    80001e66:	b7f5                	j	80001e52 <argraw+0x30>
      return p->trapframe->a3;
    80001e68:	6d3c                	ld	a5,88(a0)
    80001e6a:	67c8                	ld	a0,136(a5)
    80001e6c:	b7dd                	j	80001e52 <argraw+0x30>
      return p->trapframe->a4;
    80001e6e:	6d3c                	ld	a5,88(a0)
    80001e70:	6bc8                	ld	a0,144(a5)
    80001e72:	b7c5                	j	80001e52 <argraw+0x30>
      return p->trapframe->a5;
    80001e74:	6d3c                	ld	a5,88(a0)
    80001e76:	6fc8                	ld	a0,152(a5)
    80001e78:	bfe9                	j	80001e52 <argraw+0x30>
  panic("argraw");
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	50e50513          	addi	a0,a0,1294 # 80008388 <etext+0x388>
    80001e82:	00005097          	auipc	ra,0x5
    80001e86:	ac2080e7          	jalr	-1342(ra) # 80006944 <panic>

0000000080001e8a <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001e8a:	1101                	addi	sp,sp,-32
    80001e8c:	ec06                	sd	ra,24(sp)
    80001e8e:	e822                	sd	s0,16(sp)
    80001e90:	e426                	sd	s1,8(sp)
    80001e92:	e04a                	sd	s2,0(sp)
    80001e94:	1000                	addi	s0,sp,32
    80001e96:	84aa                	mv	s1,a0
    80001e98:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	f68080e7          	jalr	-152(ra) # 80000e02 <myproc>
  if (addr >= p->sz ||
    80001ea2:	653c                	ld	a5,72(a0)
    80001ea4:	02f4f863          	bgeu	s1,a5,80001ed4 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001ea8:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80001eac:	02e7e663          	bltu	a5,a4,80001ed8 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80001eb0:	46a1                	li	a3,8
    80001eb2:	8626                	mv	a2,s1
    80001eb4:	85ca                	mv	a1,s2
    80001eb6:	6928                	ld	a0,80(a0)
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	c6e080e7          	jalr	-914(ra) # 80000b26 <copyin>
    80001ec0:	00a03533          	snez	a0,a0
    80001ec4:	40a00533          	neg	a0,a0
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6902                	ld	s2,0(sp)
    80001ed0:	6105                	addi	sp,sp,32
    80001ed2:	8082                	ret
    return -1;
    80001ed4:	557d                	li	a0,-1
    80001ed6:	bfcd                	j	80001ec8 <fetchaddr+0x3e>
    80001ed8:	557d                	li	a0,-1
    80001eda:	b7fd                	j	80001ec8 <fetchaddr+0x3e>

0000000080001edc <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80001edc:	7179                	addi	sp,sp,-48
    80001ede:	f406                	sd	ra,40(sp)
    80001ee0:	f022                	sd	s0,32(sp)
    80001ee2:	ec26                	sd	s1,24(sp)
    80001ee4:	e84a                	sd	s2,16(sp)
    80001ee6:	e44e                	sd	s3,8(sp)
    80001ee8:	1800                	addi	s0,sp,48
    80001eea:	892a                	mv	s2,a0
    80001eec:	84ae                	mv	s1,a1
    80001eee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f12080e7          	jalr	-238(ra) # 80000e02 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80001ef8:	86ce                	mv	a3,s3
    80001efa:	864a                	mv	a2,s2
    80001efc:	85a6                	mv	a1,s1
    80001efe:	6928                	ld	a0,80(a0)
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	cb4080e7          	jalr	-844(ra) # 80000bb4 <copyinstr>
    80001f08:	00054e63          	bltz	a0,80001f24 <fetchstr+0x48>
  return strlen(buf);
    80001f0c:	8526                	mv	a0,s1
    80001f0e:	ffffe097          	auipc	ra,0xffffe
    80001f12:	2dc080e7          	jalr	732(ra) # 800001ea <strlen>
}
    80001f16:	70a2                	ld	ra,40(sp)
    80001f18:	7402                	ld	s0,32(sp)
    80001f1a:	64e2                	ld	s1,24(sp)
    80001f1c:	6942                	ld	s2,16(sp)
    80001f1e:	69a2                	ld	s3,8(sp)
    80001f20:	6145                	addi	sp,sp,48
    80001f22:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80001f24:	557d                	li	a0,-1
    80001f26:	bfc5                	j	80001f16 <fetchstr+0x3a>

0000000080001f28 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	e426                	sd	s1,8(sp)
    80001f30:	1000                	addi	s0,sp,32
    80001f32:	84ae                	mv	s1,a1
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	eee080e7          	jalr	-274(ra) # 80001e22 <argraw>
    80001f3c:	c088                	sw	a0,0(s1)
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6105                	addi	sp,sp,32
    80001f46:	8082                	ret

0000000080001f48 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    80001f48:	1101                	addi	sp,sp,-32
    80001f4a:	ec06                	sd	ra,24(sp)
    80001f4c:	e822                	sd	s0,16(sp)
    80001f4e:	e426                	sd	s1,8(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84ae                	mv	s1,a1
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	ece080e7          	jalr	-306(ra) # 80001e22 <argraw>
    80001f5c:	e088                	sd	a0,0(s1)
    80001f5e:	60e2                	ld	ra,24(sp)
    80001f60:	6442                	ld	s0,16(sp)
    80001f62:	64a2                	ld	s1,8(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80001f68:	7179                	addi	sp,sp,-48
    80001f6a:	f406                	sd	ra,40(sp)
    80001f6c:	f022                	sd	s0,32(sp)
    80001f6e:	ec26                	sd	s1,24(sp)
    80001f70:	e84a                	sd	s2,16(sp)
    80001f72:	1800                	addi	s0,sp,48
    80001f74:	84ae                	mv	s1,a1
    80001f76:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001f78:	fd840593          	addi	a1,s0,-40
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	fcc080e7          	jalr	-52(ra) # 80001f48 <argaddr>
  return fetchstr(addr, buf, max);
    80001f84:	864a                	mv	a2,s2
    80001f86:	85a6                	mv	a1,s1
    80001f88:	fd843503          	ld	a0,-40(s0)
    80001f8c:	00000097          	auipc	ra,0x0
    80001f90:	f50080e7          	jalr	-176(ra) # 80001edc <fetchstr>
}
    80001f94:	70a2                	ld	ra,40(sp)
    80001f96:	7402                	ld	s0,32(sp)
    80001f98:	64e2                	ld	s1,24(sp)
    80001f9a:	6942                	ld	s2,16(sp)
    80001f9c:	6145                	addi	sp,sp,48
    80001f9e:	8082                	ret

0000000080001fa0 <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,
};

void syscall(void) {
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	e04a                	sd	s2,0(sp)
    80001faa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	e56080e7          	jalr	-426(ra) # 80000e02 <myproc>
    80001fb4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fb6:	05853903          	ld	s2,88(a0)
    80001fba:	0a893783          	ld	a5,168(s2)
    80001fbe:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fc2:	37fd                	addiw	a5,a5,-1
    80001fc4:	4751                	li	a4,20
    80001fc6:	00f76f63          	bltu	a4,a5,80001fe4 <syscall+0x44>
    80001fca:	00369713          	slli	a4,a3,0x3
    80001fce:	00007797          	auipc	a5,0x7
    80001fd2:	90a78793          	addi	a5,a5,-1782 # 800088d8 <syscalls>
    80001fd6:	97ba                	add	a5,a5,a4
    80001fd8:	639c                	ld	a5,0(a5)
    80001fda:	c789                	beqz	a5,80001fe4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001fdc:	9782                	jalr	a5
    80001fde:	06a93823          	sd	a0,112(s2)
    80001fe2:	a839                	j	80002000 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001fe4:	15848613          	addi	a2,s1,344
    80001fe8:	588c                	lw	a1,48(s1)
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	3a650513          	addi	a0,a0,934 # 80008390 <etext+0x390>
    80001ff2:	00005097          	auipc	ra,0x5
    80001ff6:	99c080e7          	jalr	-1636(ra) # 8000698e <printf>
    p->trapframe->a0 = -1;
    80001ffa:	6cbc                	ld	a5,88(s1)
    80001ffc:	577d                	li	a4,-1
    80001ffe:	fbb8                	sd	a4,112(a5)
  }
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6902                	ld	s2,0(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002014:	fec40593          	addi	a1,s0,-20
    80002018:	4501                	li	a0,0
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	f0e080e7          	jalr	-242(ra) # 80001f28 <argint>
  exit(n);
    80002022:	fec42503          	lw	a0,-20(s0)
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	5be080e7          	jalr	1470(ra) # 800015e4 <exit>
  return 0;  // not reached
}
    8000202e:	4501                	li	a0,0
    80002030:	60e2                	ld	ra,24(sp)
    80002032:	6442                	ld	s0,16(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002038:	1141                	addi	sp,sp,-16
    8000203a:	e406                	sd	ra,8(sp)
    8000203c:	e022                	sd	s0,0(sp)
    8000203e:	0800                	addi	s0,sp,16
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	dc2080e7          	jalr	-574(ra) # 80000e02 <myproc>
    80002048:	5908                	lw	a0,48(a0)
    8000204a:	60a2                	ld	ra,8(sp)
    8000204c:	6402                	ld	s0,0(sp)
    8000204e:	0141                	addi	sp,sp,16
    80002050:	8082                	ret

0000000080002052 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002052:	1141                	addi	sp,sp,-16
    80002054:	e406                	sd	ra,8(sp)
    80002056:	e022                	sd	s0,0(sp)
    80002058:	0800                	addi	s0,sp,16
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	162080e7          	jalr	354(ra) # 800011bc <fork>
    80002062:	60a2                	ld	ra,8(sp)
    80002064:	6402                	ld	s0,0(sp)
    80002066:	0141                	addi	sp,sp,16
    80002068:	8082                	ret

000000008000206a <sys_wait>:

uint64 sys_wait(void) {
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002072:	fe840593          	addi	a1,s0,-24
    80002076:	4501                	li	a0,0
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	ed0080e7          	jalr	-304(ra) # 80001f48 <argaddr>
  return wait(p);
    80002080:	fe843503          	ld	a0,-24(s0)
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	706080e7          	jalr	1798(ra) # 8000178a <wait>
}
    8000208c:	60e2                	ld	ra,24(sp)
    8000208e:	6442                	ld	s0,16(sp)
    80002090:	6105                	addi	sp,sp,32
    80002092:	8082                	ret

0000000080002094 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002094:	7179                	addi	sp,sp,-48
    80002096:	f406                	sd	ra,40(sp)
    80002098:	f022                	sd	s0,32(sp)
    8000209a:	ec26                	sd	s1,24(sp)
    8000209c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000209e:	fdc40593          	addi	a1,s0,-36
    800020a2:	4501                	li	a0,0
    800020a4:	00000097          	auipc	ra,0x0
    800020a8:	e84080e7          	jalr	-380(ra) # 80001f28 <argint>
  addr = myproc()->sz;
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	d56080e7          	jalr	-682(ra) # 80000e02 <myproc>
    800020b4:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    800020b6:	fdc42503          	lw	a0,-36(s0)
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	0a6080e7          	jalr	166(ra) # 80001160 <growproc>
    800020c2:	00054863          	bltz	a0,800020d2 <sys_sbrk+0x3e>
  return addr;
}
    800020c6:	8526                	mv	a0,s1
    800020c8:	70a2                	ld	ra,40(sp)
    800020ca:	7402                	ld	s0,32(sp)
    800020cc:	64e2                	ld	s1,24(sp)
    800020ce:	6145                	addi	sp,sp,48
    800020d0:	8082                	ret
  if (growproc(n) < 0) return -1;
    800020d2:	54fd                	li	s1,-1
    800020d4:	bfcd                	j	800020c6 <sys_sbrk+0x32>

00000000800020d6 <sys_sleep>:

uint64 sys_sleep(void) {
    800020d6:	7139                	addi	sp,sp,-64
    800020d8:	fc06                	sd	ra,56(sp)
    800020da:	f822                	sd	s0,48(sp)
    800020dc:	f04a                	sd	s2,32(sp)
    800020de:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800020e0:	fcc40593          	addi	a1,s0,-52
    800020e4:	4501                	li	a0,0
    800020e6:	00000097          	auipc	ra,0x0
    800020ea:	e42080e7          	jalr	-446(ra) # 80001f28 <argint>
  if (n < 0) n = 0;
    800020ee:	fcc42783          	lw	a5,-52(s0)
    800020f2:	0807c163          	bltz	a5,80002174 <sys_sleep+0x9e>
  acquire(&tickslock);
    800020f6:	0000f517          	auipc	a0,0xf
    800020fa:	61a50513          	addi	a0,a0,1562 # 80011710 <tickslock>
    800020fe:	00005097          	auipc	ra,0x5
    80002102:	dc0080e7          	jalr	-576(ra) # 80006ebe <acquire>
  ticks0 = ticks;
    80002106:	00009917          	auipc	s2,0x9
    8000210a:	7a292903          	lw	s2,1954(s2) # 8000b8a8 <ticks>
  while (ticks - ticks0 < n) {
    8000210e:	fcc42783          	lw	a5,-52(s0)
    80002112:	c3b9                	beqz	a5,80002158 <sys_sleep+0x82>
    80002114:	f426                	sd	s1,40(sp)
    80002116:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002118:	0000f997          	auipc	s3,0xf
    8000211c:	5f898993          	addi	s3,s3,1528 # 80011710 <tickslock>
    80002120:	00009497          	auipc	s1,0x9
    80002124:	78848493          	addi	s1,s1,1928 # 8000b8a8 <ticks>
    if (killed(myproc())) {
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	cda080e7          	jalr	-806(ra) # 80000e02 <myproc>
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	628080e7          	jalr	1576(ra) # 80001758 <killed>
    80002138:	e129                	bnez	a0,8000217a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000213a:	85ce                	mv	a1,s3
    8000213c:	8526                	mv	a0,s1
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	372080e7          	jalr	882(ra) # 800014b0 <sleep>
  while (ticks - ticks0 < n) {
    80002146:	409c                	lw	a5,0(s1)
    80002148:	412787bb          	subw	a5,a5,s2
    8000214c:	fcc42703          	lw	a4,-52(s0)
    80002150:	fce7ece3          	bltu	a5,a4,80002128 <sys_sleep+0x52>
    80002154:	74a2                	ld	s1,40(sp)
    80002156:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002158:	0000f517          	auipc	a0,0xf
    8000215c:	5b850513          	addi	a0,a0,1464 # 80011710 <tickslock>
    80002160:	00005097          	auipc	ra,0x5
    80002164:	e12080e7          	jalr	-494(ra) # 80006f72 <release>
  return 0;
    80002168:	4501                	li	a0,0
}
    8000216a:	70e2                	ld	ra,56(sp)
    8000216c:	7442                	ld	s0,48(sp)
    8000216e:	7902                	ld	s2,32(sp)
    80002170:	6121                	addi	sp,sp,64
    80002172:	8082                	ret
  if (n < 0) n = 0;
    80002174:	fc042623          	sw	zero,-52(s0)
    80002178:	bfbd                	j	800020f6 <sys_sleep+0x20>
      release(&tickslock);
    8000217a:	0000f517          	auipc	a0,0xf
    8000217e:	59650513          	addi	a0,a0,1430 # 80011710 <tickslock>
    80002182:	00005097          	auipc	ra,0x5
    80002186:	df0080e7          	jalr	-528(ra) # 80006f72 <release>
      return -1;
    8000218a:	557d                	li	a0,-1
    8000218c:	74a2                	ld	s1,40(sp)
    8000218e:	69e2                	ld	s3,24(sp)
    80002190:	bfe9                	j	8000216a <sys_sleep+0x94>

0000000080002192 <sys_kill>:

uint64 sys_kill(void) {
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000219a:	fec40593          	addi	a1,s0,-20
    8000219e:	4501                	li	a0,0
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	d88080e7          	jalr	-632(ra) # 80001f28 <argint>
  return kill(pid);
    800021a8:	fec42503          	lw	a0,-20(s0)
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	50e080e7          	jalr	1294(ra) # 800016ba <kill>
}
    800021b4:	60e2                	ld	ra,24(sp)
    800021b6:	6442                	ld	s0,16(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret

00000000800021bc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800021bc:	1101                	addi	sp,sp,-32
    800021be:	ec06                	sd	ra,24(sp)
    800021c0:	e822                	sd	s0,16(sp)
    800021c2:	e426                	sd	s1,8(sp)
    800021c4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021c6:	0000f517          	auipc	a0,0xf
    800021ca:	54a50513          	addi	a0,a0,1354 # 80011710 <tickslock>
    800021ce:	00005097          	auipc	ra,0x5
    800021d2:	cf0080e7          	jalr	-784(ra) # 80006ebe <acquire>
  xticks = ticks;
    800021d6:	00009497          	auipc	s1,0x9
    800021da:	6d24a483          	lw	s1,1746(s1) # 8000b8a8 <ticks>
  release(&tickslock);
    800021de:	0000f517          	auipc	a0,0xf
    800021e2:	53250513          	addi	a0,a0,1330 # 80011710 <tickslock>
    800021e6:	00005097          	auipc	ra,0x5
    800021ea:	d8c080e7          	jalr	-628(ra) # 80006f72 <release>
  return xticks;
}
    800021ee:	02049513          	slli	a0,s1,0x20
    800021f2:	9101                	srli	a0,a0,0x20
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6105                	addi	sp,sp,32
    800021fc:	8082                	ret

00000000800021fe <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    800021fe:	7179                	addi	sp,sp,-48
    80002200:	f406                	sd	ra,40(sp)
    80002202:	f022                	sd	s0,32(sp)
    80002204:	ec26                	sd	s1,24(sp)
    80002206:	e84a                	sd	s2,16(sp)
    80002208:	e44e                	sd	s3,8(sp)
    8000220a:	e052                	sd	s4,0(sp)
    8000220c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000220e:	00006597          	auipc	a1,0x6
    80002212:	1a258593          	addi	a1,a1,418 # 800083b0 <etext+0x3b0>
    80002216:	0000f517          	auipc	a0,0xf
    8000221a:	51250513          	addi	a0,a0,1298 # 80011728 <bcache>
    8000221e:	00005097          	auipc	ra,0x5
    80002222:	c10080e7          	jalr	-1008(ra) # 80006e2e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002226:	00017797          	auipc	a5,0x17
    8000222a:	50278793          	addi	a5,a5,1282 # 80019728 <bcache+0x8000>
    8000222e:	00017717          	auipc	a4,0x17
    80002232:	76270713          	addi	a4,a4,1890 # 80019990 <bcache+0x8268>
    80002236:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000223a:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    8000223e:	0000f497          	auipc	s1,0xf
    80002242:	50248493          	addi	s1,s1,1282 # 80011740 <bcache+0x18>
    b->next = bcache.head.next;
    80002246:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002248:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000224a:	00006a17          	auipc	s4,0x6
    8000224e:	16ea0a13          	addi	s4,s4,366 # 800083b8 <etext+0x3b8>
    b->next = bcache.head.next;
    80002252:	2b893783          	ld	a5,696(s2)
    80002256:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002258:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000225c:	85d2                	mv	a1,s4
    8000225e:	01048513          	addi	a0,s1,16
    80002262:	00001097          	auipc	ra,0x1
    80002266:	4e8080e7          	jalr	1256(ra) # 8000374a <initsleeplock>
    bcache.head.next->prev = b;
    8000226a:	2b893783          	ld	a5,696(s2)
    8000226e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002270:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002274:	45848493          	addi	s1,s1,1112
    80002278:	fd349de3          	bne	s1,s3,80002252 <binit+0x54>
  }
}
    8000227c:	70a2                	ld	ra,40(sp)
    8000227e:	7402                	ld	s0,32(sp)
    80002280:	64e2                	ld	s1,24(sp)
    80002282:	6942                	ld	s2,16(sp)
    80002284:	69a2                	ld	s3,8(sp)
    80002286:	6a02                	ld	s4,0(sp)
    80002288:	6145                	addi	sp,sp,48
    8000228a:	8082                	ret

000000008000228c <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    8000228c:	7179                	addi	sp,sp,-48
    8000228e:	f406                	sd	ra,40(sp)
    80002290:	f022                	sd	s0,32(sp)
    80002292:	ec26                	sd	s1,24(sp)
    80002294:	e84a                	sd	s2,16(sp)
    80002296:	e44e                	sd	s3,8(sp)
    80002298:	1800                	addi	s0,sp,48
    8000229a:	892a                	mv	s2,a0
    8000229c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000229e:	0000f517          	auipc	a0,0xf
    800022a2:	48a50513          	addi	a0,a0,1162 # 80011728 <bcache>
    800022a6:	00005097          	auipc	ra,0x5
    800022aa:	c18080e7          	jalr	-1000(ra) # 80006ebe <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    800022ae:	00017497          	auipc	s1,0x17
    800022b2:	7324b483          	ld	s1,1842(s1) # 800199e0 <bcache+0x82b8>
    800022b6:	00017797          	auipc	a5,0x17
    800022ba:	6da78793          	addi	a5,a5,1754 # 80019990 <bcache+0x8268>
    800022be:	02f48f63          	beq	s1,a5,800022fc <bread+0x70>
    800022c2:	873e                	mv	a4,a5
    800022c4:	a021                	j	800022cc <bread+0x40>
    800022c6:	68a4                	ld	s1,80(s1)
    800022c8:	02e48a63          	beq	s1,a4,800022fc <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    800022cc:	449c                	lw	a5,8(s1)
    800022ce:	ff279ce3          	bne	a5,s2,800022c6 <bread+0x3a>
    800022d2:	44dc                	lw	a5,12(s1)
    800022d4:	ff3799e3          	bne	a5,s3,800022c6 <bread+0x3a>
      b->refcnt++;
    800022d8:	40bc                	lw	a5,64(s1)
    800022da:	2785                	addiw	a5,a5,1
    800022dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022de:	0000f517          	auipc	a0,0xf
    800022e2:	44a50513          	addi	a0,a0,1098 # 80011728 <bcache>
    800022e6:	00005097          	auipc	ra,0x5
    800022ea:	c8c080e7          	jalr	-884(ra) # 80006f72 <release>
      acquiresleep(&b->lock);
    800022ee:	01048513          	addi	a0,s1,16
    800022f2:	00001097          	auipc	ra,0x1
    800022f6:	492080e7          	jalr	1170(ra) # 80003784 <acquiresleep>
      return b;
    800022fa:	a8b9                	j	80002358 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800022fc:	00017497          	auipc	s1,0x17
    80002300:	6dc4b483          	ld	s1,1756(s1) # 800199d8 <bcache+0x82b0>
    80002304:	00017797          	auipc	a5,0x17
    80002308:	68c78793          	addi	a5,a5,1676 # 80019990 <bcache+0x8268>
    8000230c:	00f48863          	beq	s1,a5,8000231c <bread+0x90>
    80002310:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002312:	40bc                	lw	a5,64(s1)
    80002314:	cf81                	beqz	a5,8000232c <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002316:	64a4                	ld	s1,72(s1)
    80002318:	fee49de3          	bne	s1,a4,80002312 <bread+0x86>
  panic("bget: no buffers");
    8000231c:	00006517          	auipc	a0,0x6
    80002320:	0a450513          	addi	a0,a0,164 # 800083c0 <etext+0x3c0>
    80002324:	00004097          	auipc	ra,0x4
    80002328:	620080e7          	jalr	1568(ra) # 80006944 <panic>
      b->dev = dev;
    8000232c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002330:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002334:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002338:	4785                	li	a5,1
    8000233a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000233c:	0000f517          	auipc	a0,0xf
    80002340:	3ec50513          	addi	a0,a0,1004 # 80011728 <bcache>
    80002344:	00005097          	auipc	ra,0x5
    80002348:	c2e080e7          	jalr	-978(ra) # 80006f72 <release>
      acquiresleep(&b->lock);
    8000234c:	01048513          	addi	a0,s1,16
    80002350:	00001097          	auipc	ra,0x1
    80002354:	434080e7          	jalr	1076(ra) # 80003784 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002358:	409c                	lw	a5,0(s1)
    8000235a:	cb89                	beqz	a5,8000236c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000235c:	8526                	mv	a0,s1
    8000235e:	70a2                	ld	ra,40(sp)
    80002360:	7402                	ld	s0,32(sp)
    80002362:	64e2                	ld	s1,24(sp)
    80002364:	6942                	ld	s2,16(sp)
    80002366:	69a2                	ld	s3,8(sp)
    80002368:	6145                	addi	sp,sp,48
    8000236a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000236c:	4581                	li	a1,0
    8000236e:	8526                	mv	a0,s1
    80002370:	00003097          	auipc	ra,0x3
    80002374:	088080e7          	jalr	136(ra) # 800053f8 <virtio_disk_rw>
    b->valid = 1;
    80002378:	4785                	li	a5,1
    8000237a:	c09c                	sw	a5,0(s1)
  return b;
    8000237c:	b7c5                	j	8000235c <bread+0xd0>

000000008000237e <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    8000237e:	1101                	addi	sp,sp,-32
    80002380:	ec06                	sd	ra,24(sp)
    80002382:	e822                	sd	s0,16(sp)
    80002384:	e426                	sd	s1,8(sp)
    80002386:	1000                	addi	s0,sp,32
    80002388:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    8000238a:	0541                	addi	a0,a0,16
    8000238c:	00001097          	auipc	ra,0x1
    80002390:	492080e7          	jalr	1170(ra) # 8000381e <holdingsleep>
    80002394:	cd01                	beqz	a0,800023ac <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    80002396:	4585                	li	a1,1
    80002398:	8526                	mv	a0,s1
    8000239a:	00003097          	auipc	ra,0x3
    8000239e:	05e080e7          	jalr	94(ra) # 800053f8 <virtio_disk_rw>
}
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	64a2                	ld	s1,8(sp)
    800023a8:	6105                	addi	sp,sp,32
    800023aa:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800023ac:	00006517          	auipc	a0,0x6
    800023b0:	02c50513          	addi	a0,a0,44 # 800083d8 <etext+0x3d8>
    800023b4:	00004097          	auipc	ra,0x4
    800023b8:	590080e7          	jalr	1424(ra) # 80006944 <panic>

00000000800023bc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    800023bc:	1101                	addi	sp,sp,-32
    800023be:	ec06                	sd	ra,24(sp)
    800023c0:	e822                	sd	s0,16(sp)
    800023c2:	e426                	sd	s1,8(sp)
    800023c4:	e04a                	sd	s2,0(sp)
    800023c6:	1000                	addi	s0,sp,32
    800023c8:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    800023ca:	01050913          	addi	s2,a0,16
    800023ce:	854a                	mv	a0,s2
    800023d0:	00001097          	auipc	ra,0x1
    800023d4:	44e080e7          	jalr	1102(ra) # 8000381e <holdingsleep>
    800023d8:	c925                	beqz	a0,80002448 <brelse+0x8c>

  releasesleep(&b->lock);
    800023da:	854a                	mv	a0,s2
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	3fe080e7          	jalr	1022(ra) # 800037da <releasesleep>

  acquire(&bcache.lock);
    800023e4:	0000f517          	auipc	a0,0xf
    800023e8:	34450513          	addi	a0,a0,836 # 80011728 <bcache>
    800023ec:	00005097          	auipc	ra,0x5
    800023f0:	ad2080e7          	jalr	-1326(ra) # 80006ebe <acquire>
  b->refcnt--;
    800023f4:	40bc                	lw	a5,64(s1)
    800023f6:	37fd                	addiw	a5,a5,-1
    800023f8:	0007871b          	sext.w	a4,a5
    800023fc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023fe:	e71d                	bnez	a4,8000242c <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002400:	68b8                	ld	a4,80(s1)
    80002402:	64bc                	ld	a5,72(s1)
    80002404:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002406:	68b8                	ld	a4,80(s1)
    80002408:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000240a:	00017797          	auipc	a5,0x17
    8000240e:	31e78793          	addi	a5,a5,798 # 80019728 <bcache+0x8000>
    80002412:	2b87b703          	ld	a4,696(a5)
    80002416:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002418:	00017717          	auipc	a4,0x17
    8000241c:	57870713          	addi	a4,a4,1400 # 80019990 <bcache+0x8268>
    80002420:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002422:	2b87b703          	ld	a4,696(a5)
    80002426:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002428:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    8000242c:	0000f517          	auipc	a0,0xf
    80002430:	2fc50513          	addi	a0,a0,764 # 80011728 <bcache>
    80002434:	00005097          	auipc	ra,0x5
    80002438:	b3e080e7          	jalr	-1218(ra) # 80006f72 <release>
}
    8000243c:	60e2                	ld	ra,24(sp)
    8000243e:	6442                	ld	s0,16(sp)
    80002440:	64a2                	ld	s1,8(sp)
    80002442:	6902                	ld	s2,0(sp)
    80002444:	6105                	addi	sp,sp,32
    80002446:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002448:	00006517          	auipc	a0,0x6
    8000244c:	f9850513          	addi	a0,a0,-104 # 800083e0 <etext+0x3e0>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	4f4080e7          	jalr	1268(ra) # 80006944 <panic>

0000000080002458 <bpin>:

void bpin(struct buf *b) {
    80002458:	1101                	addi	sp,sp,-32
    8000245a:	ec06                	sd	ra,24(sp)
    8000245c:	e822                	sd	s0,16(sp)
    8000245e:	e426                	sd	s1,8(sp)
    80002460:	1000                	addi	s0,sp,32
    80002462:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002464:	0000f517          	auipc	a0,0xf
    80002468:	2c450513          	addi	a0,a0,708 # 80011728 <bcache>
    8000246c:	00005097          	auipc	ra,0x5
    80002470:	a52080e7          	jalr	-1454(ra) # 80006ebe <acquire>
  b->refcnt++;
    80002474:	40bc                	lw	a5,64(s1)
    80002476:	2785                	addiw	a5,a5,1
    80002478:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000247a:	0000f517          	auipc	a0,0xf
    8000247e:	2ae50513          	addi	a0,a0,686 # 80011728 <bcache>
    80002482:	00005097          	auipc	ra,0x5
    80002486:	af0080e7          	jalr	-1296(ra) # 80006f72 <release>
}
    8000248a:	60e2                	ld	ra,24(sp)
    8000248c:	6442                	ld	s0,16(sp)
    8000248e:	64a2                	ld	s1,8(sp)
    80002490:	6105                	addi	sp,sp,32
    80002492:	8082                	ret

0000000080002494 <bunpin>:

void bunpin(struct buf *b) {
    80002494:	1101                	addi	sp,sp,-32
    80002496:	ec06                	sd	ra,24(sp)
    80002498:	e822                	sd	s0,16(sp)
    8000249a:	e426                	sd	s1,8(sp)
    8000249c:	1000                	addi	s0,sp,32
    8000249e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024a0:	0000f517          	auipc	a0,0xf
    800024a4:	28850513          	addi	a0,a0,648 # 80011728 <bcache>
    800024a8:	00005097          	auipc	ra,0x5
    800024ac:	a16080e7          	jalr	-1514(ra) # 80006ebe <acquire>
  b->refcnt--;
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	37fd                	addiw	a5,a5,-1
    800024b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b6:	0000f517          	auipc	a0,0xf
    800024ba:	27250513          	addi	a0,a0,626 # 80011728 <bcache>
    800024be:	00005097          	auipc	ra,0x5
    800024c2:	ab4080e7          	jalr	-1356(ra) # 80006f72 <release>
}
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret

00000000800024d0 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	e04a                	sd	s2,0(sp)
    800024da:	1000                	addi	s0,sp,32
    800024dc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024de:	00d5d59b          	srliw	a1,a1,0xd
    800024e2:	00018797          	auipc	a5,0x18
    800024e6:	9227a783          	lw	a5,-1758(a5) # 80019e04 <sb+0x1c>
    800024ea:	9dbd                	addw	a1,a1,a5
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	da0080e7          	jalr	-608(ra) # 8000228c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024f4:	0074f713          	andi	a4,s1,7
    800024f8:	4785                	li	a5,1
    800024fa:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800024fe:	14ce                	slli	s1,s1,0x33
    80002500:	90d9                	srli	s1,s1,0x36
    80002502:	00950733          	add	a4,a0,s1
    80002506:	05874703          	lbu	a4,88(a4)
    8000250a:	00e7f6b3          	and	a3,a5,a4
    8000250e:	c69d                	beqz	a3,8000253c <bfree+0x6c>
    80002510:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002512:	94aa                	add	s1,s1,a0
    80002514:	fff7c793          	not	a5,a5
    80002518:	8f7d                	and	a4,a4,a5
    8000251a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000251e:	00001097          	auipc	ra,0x1
    80002522:	148080e7          	jalr	328(ra) # 80003666 <log_write>
  brelse(bp);
    80002526:	854a                	mv	a0,s2
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	e94080e7          	jalr	-364(ra) # 800023bc <brelse>
}
    80002530:	60e2                	ld	ra,24(sp)
    80002532:	6442                	ld	s0,16(sp)
    80002534:	64a2                	ld	s1,8(sp)
    80002536:	6902                	ld	s2,0(sp)
    80002538:	6105                	addi	sp,sp,32
    8000253a:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    8000253c:	00006517          	auipc	a0,0x6
    80002540:	eac50513          	addi	a0,a0,-340 # 800083e8 <etext+0x3e8>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	400080e7          	jalr	1024(ra) # 80006944 <panic>

000000008000254c <balloc>:
static uint balloc(uint dev) {
    8000254c:	711d                	addi	sp,sp,-96
    8000254e:	ec86                	sd	ra,88(sp)
    80002550:	e8a2                	sd	s0,80(sp)
    80002552:	e4a6                	sd	s1,72(sp)
    80002554:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80002556:	00018797          	auipc	a5,0x18
    8000255a:	8967a783          	lw	a5,-1898(a5) # 80019dec <sb+0x4>
    8000255e:	10078f63          	beqz	a5,8000267c <balloc+0x130>
    80002562:	e0ca                	sd	s2,64(sp)
    80002564:	fc4e                	sd	s3,56(sp)
    80002566:	f852                	sd	s4,48(sp)
    80002568:	f456                	sd	s5,40(sp)
    8000256a:	f05a                	sd	s6,32(sp)
    8000256c:	ec5e                	sd	s7,24(sp)
    8000256e:	e862                	sd	s8,16(sp)
    80002570:	e466                	sd	s9,8(sp)
    80002572:	8baa                	mv	s7,a0
    80002574:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002576:	00018b17          	auipc	s6,0x18
    8000257a:	872b0b13          	addi	s6,s6,-1934 # 80019de8 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000257e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002580:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002582:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002584:	6c89                	lui	s9,0x2
    80002586:	a061                	j	8000260e <balloc+0xc2>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002588:	97ca                	add	a5,a5,s2
    8000258a:	8e55                	or	a2,a2,a3
    8000258c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002590:	854a                	mv	a0,s2
    80002592:	00001097          	auipc	ra,0x1
    80002596:	0d4080e7          	jalr	212(ra) # 80003666 <log_write>
        brelse(bp);
    8000259a:	854a                	mv	a0,s2
    8000259c:	00000097          	auipc	ra,0x0
    800025a0:	e20080e7          	jalr	-480(ra) # 800023bc <brelse>
  bp = bread(dev, bno);
    800025a4:	85a6                	mv	a1,s1
    800025a6:	855e                	mv	a0,s7
    800025a8:	00000097          	auipc	ra,0x0
    800025ac:	ce4080e7          	jalr	-796(ra) # 8000228c <bread>
    800025b0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025b2:	40000613          	li	a2,1024
    800025b6:	4581                	li	a1,0
    800025b8:	05850513          	addi	a0,a0,88
    800025bc:	ffffe097          	auipc	ra,0xffffe
    800025c0:	aba080e7          	jalr	-1350(ra) # 80000076 <memset>
  log_write(bp);
    800025c4:	854a                	mv	a0,s2
    800025c6:	00001097          	auipc	ra,0x1
    800025ca:	0a0080e7          	jalr	160(ra) # 80003666 <log_write>
  brelse(bp);
    800025ce:	854a                	mv	a0,s2
    800025d0:	00000097          	auipc	ra,0x0
    800025d4:	dec080e7          	jalr	-532(ra) # 800023bc <brelse>
}
    800025d8:	6906                	ld	s2,64(sp)
    800025da:	79e2                	ld	s3,56(sp)
    800025dc:	7a42                	ld	s4,48(sp)
    800025de:	7aa2                	ld	s5,40(sp)
    800025e0:	7b02                	ld	s6,32(sp)
    800025e2:	6be2                	ld	s7,24(sp)
    800025e4:	6c42                	ld	s8,16(sp)
    800025e6:	6ca2                	ld	s9,8(sp)
}
    800025e8:	8526                	mv	a0,s1
    800025ea:	60e6                	ld	ra,88(sp)
    800025ec:	6446                	ld	s0,80(sp)
    800025ee:	64a6                	ld	s1,72(sp)
    800025f0:	6125                	addi	sp,sp,96
    800025f2:	8082                	ret
    brelse(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	dc6080e7          	jalr	-570(ra) # 800023bc <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800025fe:	015c87bb          	addw	a5,s9,s5
    80002602:	00078a9b          	sext.w	s5,a5
    80002606:	004b2703          	lw	a4,4(s6)
    8000260a:	06eaf163          	bgeu	s5,a4,8000266c <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    8000260e:	41fad79b          	sraiw	a5,s5,0x1f
    80002612:	0137d79b          	srliw	a5,a5,0x13
    80002616:	015787bb          	addw	a5,a5,s5
    8000261a:	40d7d79b          	sraiw	a5,a5,0xd
    8000261e:	01cb2583          	lw	a1,28(s6)
    80002622:	9dbd                	addw	a1,a1,a5
    80002624:	855e                	mv	a0,s7
    80002626:	00000097          	auipc	ra,0x0
    8000262a:	c66080e7          	jalr	-922(ra) # 8000228c <bread>
    8000262e:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002630:	004b2503          	lw	a0,4(s6)
    80002634:	000a849b          	sext.w	s1,s5
    80002638:	8762                	mv	a4,s8
    8000263a:	faa4fde3          	bgeu	s1,a0,800025f4 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000263e:	00777693          	andi	a3,a4,7
    80002642:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    80002646:	41f7579b          	sraiw	a5,a4,0x1f
    8000264a:	01d7d79b          	srliw	a5,a5,0x1d
    8000264e:	9fb9                	addw	a5,a5,a4
    80002650:	4037d79b          	sraiw	a5,a5,0x3
    80002654:	00f90633          	add	a2,s2,a5
    80002658:	05864603          	lbu	a2,88(a2)
    8000265c:	00c6f5b3          	and	a1,a3,a2
    80002660:	d585                	beqz	a1,80002588 <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002662:	2705                	addiw	a4,a4,1
    80002664:	2485                	addiw	s1,s1,1
    80002666:	fd471ae3          	bne	a4,s4,8000263a <balloc+0xee>
    8000266a:	b769                	j	800025f4 <balloc+0xa8>
    8000266c:	6906                	ld	s2,64(sp)
    8000266e:	79e2                	ld	s3,56(sp)
    80002670:	7a42                	ld	s4,48(sp)
    80002672:	7aa2                	ld	s5,40(sp)
    80002674:	7b02                	ld	s6,32(sp)
    80002676:	6be2                	ld	s7,24(sp)
    80002678:	6c42                	ld	s8,16(sp)
    8000267a:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000267c:	00006517          	auipc	a0,0x6
    80002680:	d8450513          	addi	a0,a0,-636 # 80008400 <etext+0x400>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	30a080e7          	jalr	778(ra) # 8000698e <printf>
  return 0;
    8000268c:	4481                	li	s1,0
    8000268e:	bfa9                	j	800025e8 <balloc+0x9c>

0000000080002690 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    80002690:	7179                	addi	sp,sp,-48
    80002692:	f406                	sd	ra,40(sp)
    80002694:	f022                	sd	s0,32(sp)
    80002696:	ec26                	sd	s1,24(sp)
    80002698:	e84a                	sd	s2,16(sp)
    8000269a:	e44e                	sd	s3,8(sp)
    8000269c:	1800                	addi	s0,sp,48
    8000269e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800026a0:	47ad                	li	a5,11
    800026a2:	02b7e863          	bltu	a5,a1,800026d2 <bmap+0x42>
    if ((addr = ip->addrs[bn]) == 0) {
    800026a6:	02059793          	slli	a5,a1,0x20
    800026aa:	01e7d593          	srli	a1,a5,0x1e
    800026ae:	00b504b3          	add	s1,a0,a1
    800026b2:	0504a903          	lw	s2,80(s1)
    800026b6:	08091263          	bnez	s2,8000273a <bmap+0xaa>
      addr = balloc(ip->dev);
    800026ba:	4108                	lw	a0,0(a0)
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	e90080e7          	jalr	-368(ra) # 8000254c <balloc>
    800026c4:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800026c8:	06090963          	beqz	s2,8000273a <bmap+0xaa>
      ip->addrs[bn] = addr;
    800026cc:	0524a823          	sw	s2,80(s1)
    800026d0:	a0ad                	j	8000273a <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026d2:	ff45849b          	addiw	s1,a1,-12
    800026d6:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    800026da:	0ff00793          	li	a5,255
    800026de:	08e7e863          	bltu	a5,a4,8000276e <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800026e2:	08052903          	lw	s2,128(a0)
    800026e6:	00091f63          	bnez	s2,80002704 <bmap+0x74>
      addr = balloc(ip->dev);
    800026ea:	4108                	lw	a0,0(a0)
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e60080e7          	jalr	-416(ra) # 8000254c <balloc>
    800026f4:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800026f8:	04090163          	beqz	s2,8000273a <bmap+0xaa>
    800026fc:	e052                	sd	s4,0(sp)
      ip->addrs[NDIRECT] = addr;
    800026fe:	0929a023          	sw	s2,128(s3)
    80002702:	a011                	j	80002706 <bmap+0x76>
    80002704:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002706:	85ca                	mv	a1,s2
    80002708:	0009a503          	lw	a0,0(s3)
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	b80080e7          	jalr	-1152(ra) # 8000228c <bread>
    80002714:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002716:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000271a:	02049713          	slli	a4,s1,0x20
    8000271e:	01e75593          	srli	a1,a4,0x1e
    80002722:	00b784b3          	add	s1,a5,a1
    80002726:	0004a903          	lw	s2,0(s1)
    8000272a:	02090063          	beqz	s2,8000274a <bmap+0xba>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000272e:	8552                	mv	a0,s4
    80002730:	00000097          	auipc	ra,0x0
    80002734:	c8c080e7          	jalr	-884(ra) # 800023bc <brelse>
    return addr;
    80002738:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000273a:	854a                	mv	a0,s2
    8000273c:	70a2                	ld	ra,40(sp)
    8000273e:	7402                	ld	s0,32(sp)
    80002740:	64e2                	ld	s1,24(sp)
    80002742:	6942                	ld	s2,16(sp)
    80002744:	69a2                	ld	s3,8(sp)
    80002746:	6145                	addi	sp,sp,48
    80002748:	8082                	ret
      addr = balloc(ip->dev);
    8000274a:	0009a503          	lw	a0,0(s3)
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	dfe080e7          	jalr	-514(ra) # 8000254c <balloc>
    80002756:	0005091b          	sext.w	s2,a0
      if (addr) {
    8000275a:	fc090ae3          	beqz	s2,8000272e <bmap+0x9e>
        a[bn] = addr;
    8000275e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002762:	8552                	mv	a0,s4
    80002764:	00001097          	auipc	ra,0x1
    80002768:	f02080e7          	jalr	-254(ra) # 80003666 <log_write>
    8000276c:	b7c9                	j	8000272e <bmap+0x9e>
    8000276e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002770:	00006517          	auipc	a0,0x6
    80002774:	ca850513          	addi	a0,a0,-856 # 80008418 <etext+0x418>
    80002778:	00004097          	auipc	ra,0x4
    8000277c:	1cc080e7          	jalr	460(ra) # 80006944 <panic>

0000000080002780 <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002780:	7179                	addi	sp,sp,-48
    80002782:	f406                	sd	ra,40(sp)
    80002784:	f022                	sd	s0,32(sp)
    80002786:	ec26                	sd	s1,24(sp)
    80002788:	e84a                	sd	s2,16(sp)
    8000278a:	e44e                	sd	s3,8(sp)
    8000278c:	e052                	sd	s4,0(sp)
    8000278e:	1800                	addi	s0,sp,48
    80002790:	89aa                	mv	s3,a0
    80002792:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002794:	00017517          	auipc	a0,0x17
    80002798:	67450513          	addi	a0,a0,1652 # 80019e08 <itable>
    8000279c:	00004097          	auipc	ra,0x4
    800027a0:	722080e7          	jalr	1826(ra) # 80006ebe <acquire>
  empty = 0;
    800027a4:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800027a6:	00017497          	auipc	s1,0x17
    800027aa:	67a48493          	addi	s1,s1,1658 # 80019e20 <itable+0x18>
    800027ae:	00019697          	auipc	a3,0x19
    800027b2:	10268693          	addi	a3,a3,258 # 8001b8b0 <log>
    800027b6:	a039                	j	800027c4 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    800027b8:	02090b63          	beqz	s2,800027ee <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800027bc:	08848493          	addi	s1,s1,136
    800027c0:	02d48a63          	beq	s1,a3,800027f4 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800027c4:	449c                	lw	a5,8(s1)
    800027c6:	fef059e3          	blez	a5,800027b8 <iget+0x38>
    800027ca:	4098                	lw	a4,0(s1)
    800027cc:	ff3716e3          	bne	a4,s3,800027b8 <iget+0x38>
    800027d0:	40d8                	lw	a4,4(s1)
    800027d2:	ff4713e3          	bne	a4,s4,800027b8 <iget+0x38>
      ip->ref++;
    800027d6:	2785                	addiw	a5,a5,1
    800027d8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027da:	00017517          	auipc	a0,0x17
    800027de:	62e50513          	addi	a0,a0,1582 # 80019e08 <itable>
    800027e2:	00004097          	auipc	ra,0x4
    800027e6:	790080e7          	jalr	1936(ra) # 80006f72 <release>
      return ip;
    800027ea:	8926                	mv	s2,s1
    800027ec:	a03d                	j	8000281a <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    800027ee:	f7f9                	bnez	a5,800027bc <iget+0x3c>
      empty = ip;
    800027f0:	8926                	mv	s2,s1
    800027f2:	b7e9                	j	800027bc <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    800027f4:	02090c63          	beqz	s2,8000282c <iget+0xac>
  ip->dev = dev;
    800027f8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027fc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002800:	4785                	li	a5,1
    80002802:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002806:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000280a:	00017517          	auipc	a0,0x17
    8000280e:	5fe50513          	addi	a0,a0,1534 # 80019e08 <itable>
    80002812:	00004097          	auipc	ra,0x4
    80002816:	760080e7          	jalr	1888(ra) # 80006f72 <release>
}
    8000281a:	854a                	mv	a0,s2
    8000281c:	70a2                	ld	ra,40(sp)
    8000281e:	7402                	ld	s0,32(sp)
    80002820:	64e2                	ld	s1,24(sp)
    80002822:	6942                	ld	s2,16(sp)
    80002824:	69a2                	ld	s3,8(sp)
    80002826:	6a02                	ld	s4,0(sp)
    80002828:	6145                	addi	sp,sp,48
    8000282a:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    8000282c:	00006517          	auipc	a0,0x6
    80002830:	c0450513          	addi	a0,a0,-1020 # 80008430 <etext+0x430>
    80002834:	00004097          	auipc	ra,0x4
    80002838:	110080e7          	jalr	272(ra) # 80006944 <panic>

000000008000283c <fsinit>:
void fsinit(int dev) {
    8000283c:	7179                	addi	sp,sp,-48
    8000283e:	f406                	sd	ra,40(sp)
    80002840:	f022                	sd	s0,32(sp)
    80002842:	ec26                	sd	s1,24(sp)
    80002844:	e84a                	sd	s2,16(sp)
    80002846:	e44e                	sd	s3,8(sp)
    80002848:	1800                	addi	s0,sp,48
    8000284a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000284c:	4585                	li	a1,1
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	a3e080e7          	jalr	-1474(ra) # 8000228c <bread>
    80002856:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002858:	00017997          	auipc	s3,0x17
    8000285c:	59098993          	addi	s3,s3,1424 # 80019de8 <sb>
    80002860:	02000613          	li	a2,32
    80002864:	05850593          	addi	a1,a0,88
    80002868:	854e                	mv	a0,s3
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	868080e7          	jalr	-1944(ra) # 800000d2 <memmove>
  brelse(bp);
    80002872:	8526                	mv	a0,s1
    80002874:	00000097          	auipc	ra,0x0
    80002878:	b48080e7          	jalr	-1208(ra) # 800023bc <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    8000287c:	0009a703          	lw	a4,0(s3)
    80002880:	102037b7          	lui	a5,0x10203
    80002884:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002888:	02f71263          	bne	a4,a5,800028ac <fsinit+0x70>
  initlog(dev, &sb);
    8000288c:	00017597          	auipc	a1,0x17
    80002890:	55c58593          	addi	a1,a1,1372 # 80019de8 <sb>
    80002894:	854a                	mv	a0,s2
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	b60080e7          	jalr	-1184(ra) # 800033f6 <initlog>
}
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6145                	addi	sp,sp,48
    800028aa:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    800028ac:	00006517          	auipc	a0,0x6
    800028b0:	b9450513          	addi	a0,a0,-1132 # 80008440 <etext+0x440>
    800028b4:	00004097          	auipc	ra,0x4
    800028b8:	090080e7          	jalr	144(ra) # 80006944 <panic>

00000000800028bc <iinit>:
void iinit() {
    800028bc:	7179                	addi	sp,sp,-48
    800028be:	f406                	sd	ra,40(sp)
    800028c0:	f022                	sd	s0,32(sp)
    800028c2:	ec26                	sd	s1,24(sp)
    800028c4:	e84a                	sd	s2,16(sp)
    800028c6:	e44e                	sd	s3,8(sp)
    800028c8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028ca:	00006597          	auipc	a1,0x6
    800028ce:	b8e58593          	addi	a1,a1,-1138 # 80008458 <etext+0x458>
    800028d2:	00017517          	auipc	a0,0x17
    800028d6:	53650513          	addi	a0,a0,1334 # 80019e08 <itable>
    800028da:	00004097          	auipc	ra,0x4
    800028de:	554080e7          	jalr	1364(ra) # 80006e2e <initlock>
  for (i = 0; i < NINODE; i++) {
    800028e2:	00017497          	auipc	s1,0x17
    800028e6:	54e48493          	addi	s1,s1,1358 # 80019e30 <itable+0x28>
    800028ea:	00019997          	auipc	s3,0x19
    800028ee:	fd698993          	addi	s3,s3,-42 # 8001b8c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028f2:	00006917          	auipc	s2,0x6
    800028f6:	b6e90913          	addi	s2,s2,-1170 # 80008460 <etext+0x460>
    800028fa:	85ca                	mv	a1,s2
    800028fc:	8526                	mv	a0,s1
    800028fe:	00001097          	auipc	ra,0x1
    80002902:	e4c080e7          	jalr	-436(ra) # 8000374a <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002906:	08848493          	addi	s1,s1,136
    8000290a:	ff3498e3          	bne	s1,s3,800028fa <iinit+0x3e>
}
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6145                	addi	sp,sp,48
    8000291a:	8082                	ret

000000008000291c <ialloc>:
struct inode *ialloc(uint dev, short type) {
    8000291c:	7139                	addi	sp,sp,-64
    8000291e:	fc06                	sd	ra,56(sp)
    80002920:	f822                	sd	s0,48(sp)
    80002922:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002924:	00017717          	auipc	a4,0x17
    80002928:	4d072703          	lw	a4,1232(a4) # 80019df4 <sb+0xc>
    8000292c:	4785                	li	a5,1
    8000292e:	06e7f463          	bgeu	a5,a4,80002996 <ialloc+0x7a>
    80002932:	f426                	sd	s1,40(sp)
    80002934:	f04a                	sd	s2,32(sp)
    80002936:	ec4e                	sd	s3,24(sp)
    80002938:	e852                	sd	s4,16(sp)
    8000293a:	e456                	sd	s5,8(sp)
    8000293c:	e05a                	sd	s6,0(sp)
    8000293e:	8aaa                	mv	s5,a0
    80002940:	8b2e                	mv	s6,a1
    80002942:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002944:	00017a17          	auipc	s4,0x17
    80002948:	4a4a0a13          	addi	s4,s4,1188 # 80019de8 <sb>
    8000294c:	00495593          	srli	a1,s2,0x4
    80002950:	018a2783          	lw	a5,24(s4)
    80002954:	9dbd                	addw	a1,a1,a5
    80002956:	8556                	mv	a0,s5
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	934080e7          	jalr	-1740(ra) # 8000228c <bread>
    80002960:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002962:	05850993          	addi	s3,a0,88
    80002966:	00f97793          	andi	a5,s2,15
    8000296a:	079a                	slli	a5,a5,0x6
    8000296c:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    8000296e:	00099783          	lh	a5,0(s3)
    80002972:	cf9d                	beqz	a5,800029b0 <ialloc+0x94>
    brelse(bp);
    80002974:	00000097          	auipc	ra,0x0
    80002978:	a48080e7          	jalr	-1464(ra) # 800023bc <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    8000297c:	0905                	addi	s2,s2,1
    8000297e:	00ca2703          	lw	a4,12(s4)
    80002982:	0009079b          	sext.w	a5,s2
    80002986:	fce7e3e3          	bltu	a5,a4,8000294c <ialloc+0x30>
    8000298a:	74a2                	ld	s1,40(sp)
    8000298c:	7902                	ld	s2,32(sp)
    8000298e:	69e2                	ld	s3,24(sp)
    80002990:	6a42                	ld	s4,16(sp)
    80002992:	6aa2                	ld	s5,8(sp)
    80002994:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	ad250513          	addi	a0,a0,-1326 # 80008468 <etext+0x468>
    8000299e:	00004097          	auipc	ra,0x4
    800029a2:	ff0080e7          	jalr	-16(ra) # 8000698e <printf>
  return 0;
    800029a6:	4501                	li	a0,0
}
    800029a8:	70e2                	ld	ra,56(sp)
    800029aa:	7442                	ld	s0,48(sp)
    800029ac:	6121                	addi	sp,sp,64
    800029ae:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029b0:	04000613          	li	a2,64
    800029b4:	4581                	li	a1,0
    800029b6:	854e                	mv	a0,s3
    800029b8:	ffffd097          	auipc	ra,0xffffd
    800029bc:	6be080e7          	jalr	1726(ra) # 80000076 <memset>
      dip->type = type;
    800029c0:	01699023          	sh	s6,0(s3)
      log_write(bp);  // mark it allocated on the disk
    800029c4:	8526                	mv	a0,s1
    800029c6:	00001097          	auipc	ra,0x1
    800029ca:	ca0080e7          	jalr	-864(ra) # 80003666 <log_write>
      brelse(bp);
    800029ce:	8526                	mv	a0,s1
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	9ec080e7          	jalr	-1556(ra) # 800023bc <brelse>
      return iget(dev, inum);
    800029d8:	0009059b          	sext.w	a1,s2
    800029dc:	8556                	mv	a0,s5
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	da2080e7          	jalr	-606(ra) # 80002780 <iget>
    800029e6:	74a2                	ld	s1,40(sp)
    800029e8:	7902                	ld	s2,32(sp)
    800029ea:	69e2                	ld	s3,24(sp)
    800029ec:	6a42                	ld	s4,16(sp)
    800029ee:	6aa2                	ld	s5,8(sp)
    800029f0:	6b02                	ld	s6,0(sp)
    800029f2:	bf5d                	j	800029a8 <ialloc+0x8c>

00000000800029f4 <iupdate>:
void iupdate(struct inode *ip) {
    800029f4:	1101                	addi	sp,sp,-32
    800029f6:	ec06                	sd	ra,24(sp)
    800029f8:	e822                	sd	s0,16(sp)
    800029fa:	e426                	sd	s1,8(sp)
    800029fc:	e04a                	sd	s2,0(sp)
    800029fe:	1000                	addi	s0,sp,32
    80002a00:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a02:	415c                	lw	a5,4(a0)
    80002a04:	0047d79b          	srliw	a5,a5,0x4
    80002a08:	00017597          	auipc	a1,0x17
    80002a0c:	3f85a583          	lw	a1,1016(a1) # 80019e00 <sb+0x18>
    80002a10:	9dbd                	addw	a1,a1,a5
    80002a12:	4108                	lw	a0,0(a0)
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	878080e7          	jalr	-1928(ra) # 8000228c <bread>
    80002a1c:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002a1e:	05850793          	addi	a5,a0,88
    80002a22:	40d8                	lw	a4,4(s1)
    80002a24:	8b3d                	andi	a4,a4,15
    80002a26:	071a                	slli	a4,a4,0x6
    80002a28:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a2a:	04449703          	lh	a4,68(s1)
    80002a2e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a32:	04649703          	lh	a4,70(s1)
    80002a36:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a3a:	04849703          	lh	a4,72(s1)
    80002a3e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a42:	04a49703          	lh	a4,74(s1)
    80002a46:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a4a:	44f8                	lw	a4,76(s1)
    80002a4c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a4e:	03400613          	li	a2,52
    80002a52:	05048593          	addi	a1,s1,80
    80002a56:	00c78513          	addi	a0,a5,12
    80002a5a:	ffffd097          	auipc	ra,0xffffd
    80002a5e:	678080e7          	jalr	1656(ra) # 800000d2 <memmove>
  log_write(bp);
    80002a62:	854a                	mv	a0,s2
    80002a64:	00001097          	auipc	ra,0x1
    80002a68:	c02080e7          	jalr	-1022(ra) # 80003666 <log_write>
  brelse(bp);
    80002a6c:	854a                	mv	a0,s2
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	94e080e7          	jalr	-1714(ra) # 800023bc <brelse>
}
    80002a76:	60e2                	ld	ra,24(sp)
    80002a78:	6442                	ld	s0,16(sp)
    80002a7a:	64a2                	ld	s1,8(sp)
    80002a7c:	6902                	ld	s2,0(sp)
    80002a7e:	6105                	addi	sp,sp,32
    80002a80:	8082                	ret

0000000080002a82 <idup>:
struct inode *idup(struct inode *ip) {
    80002a82:	1101                	addi	sp,sp,-32
    80002a84:	ec06                	sd	ra,24(sp)
    80002a86:	e822                	sd	s0,16(sp)
    80002a88:	e426                	sd	s1,8(sp)
    80002a8a:	1000                	addi	s0,sp,32
    80002a8c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a8e:	00017517          	auipc	a0,0x17
    80002a92:	37a50513          	addi	a0,a0,890 # 80019e08 <itable>
    80002a96:	00004097          	auipc	ra,0x4
    80002a9a:	428080e7          	jalr	1064(ra) # 80006ebe <acquire>
  ip->ref++;
    80002a9e:	449c                	lw	a5,8(s1)
    80002aa0:	2785                	addiw	a5,a5,1
    80002aa2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002aa4:	00017517          	auipc	a0,0x17
    80002aa8:	36450513          	addi	a0,a0,868 # 80019e08 <itable>
    80002aac:	00004097          	auipc	ra,0x4
    80002ab0:	4c6080e7          	jalr	1222(ra) # 80006f72 <release>
}
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	60e2                	ld	ra,24(sp)
    80002ab8:	6442                	ld	s0,16(sp)
    80002aba:	64a2                	ld	s1,8(sp)
    80002abc:	6105                	addi	sp,sp,32
    80002abe:	8082                	ret

0000000080002ac0 <ilock>:
void ilock(struct inode *ip) {
    80002ac0:	1101                	addi	sp,sp,-32
    80002ac2:	ec06                	sd	ra,24(sp)
    80002ac4:	e822                	sd	s0,16(sp)
    80002ac6:	e426                	sd	s1,8(sp)
    80002ac8:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002aca:	c10d                	beqz	a0,80002aec <ilock+0x2c>
    80002acc:	84aa                	mv	s1,a0
    80002ace:	451c                	lw	a5,8(a0)
    80002ad0:	00f05e63          	blez	a5,80002aec <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ad4:	0541                	addi	a0,a0,16
    80002ad6:	00001097          	auipc	ra,0x1
    80002ada:	cae080e7          	jalr	-850(ra) # 80003784 <acquiresleep>
  if (ip->valid == 0) {
    80002ade:	40bc                	lw	a5,64(s1)
    80002ae0:	cf99                	beqz	a5,80002afe <ilock+0x3e>
}
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6105                	addi	sp,sp,32
    80002aea:	8082                	ret
    80002aec:	e04a                	sd	s2,0(sp)
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002aee:	00006517          	auipc	a0,0x6
    80002af2:	99250513          	addi	a0,a0,-1646 # 80008480 <etext+0x480>
    80002af6:	00004097          	auipc	ra,0x4
    80002afa:	e4e080e7          	jalr	-434(ra) # 80006944 <panic>
    80002afe:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b00:	40dc                	lw	a5,4(s1)
    80002b02:	0047d79b          	srliw	a5,a5,0x4
    80002b06:	00017597          	auipc	a1,0x17
    80002b0a:	2fa5a583          	lw	a1,762(a1) # 80019e00 <sb+0x18>
    80002b0e:	9dbd                	addw	a1,a1,a5
    80002b10:	4088                	lw	a0,0(s1)
    80002b12:	fffff097          	auipc	ra,0xfffff
    80002b16:	77a080e7          	jalr	1914(ra) # 8000228c <bread>
    80002b1a:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b1c:	05850593          	addi	a1,a0,88
    80002b20:	40dc                	lw	a5,4(s1)
    80002b22:	8bbd                	andi	a5,a5,15
    80002b24:	079a                	slli	a5,a5,0x6
    80002b26:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b28:	00059783          	lh	a5,0(a1)
    80002b2c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b30:	00259783          	lh	a5,2(a1)
    80002b34:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b38:	00459783          	lh	a5,4(a1)
    80002b3c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b40:	00659783          	lh	a5,6(a1)
    80002b44:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b48:	459c                	lw	a5,8(a1)
    80002b4a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b4c:	03400613          	li	a2,52
    80002b50:	05b1                	addi	a1,a1,12
    80002b52:	05048513          	addi	a0,s1,80
    80002b56:	ffffd097          	auipc	ra,0xffffd
    80002b5a:	57c080e7          	jalr	1404(ra) # 800000d2 <memmove>
    brelse(bp);
    80002b5e:	854a                	mv	a0,s2
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	85c080e7          	jalr	-1956(ra) # 800023bc <brelse>
    ip->valid = 1;
    80002b68:	4785                	li	a5,1
    80002b6a:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002b6c:	04449783          	lh	a5,68(s1)
    80002b70:	c399                	beqz	a5,80002b76 <ilock+0xb6>
    80002b72:	6902                	ld	s2,0(sp)
    80002b74:	b7bd                	j	80002ae2 <ilock+0x22>
    80002b76:	00006517          	auipc	a0,0x6
    80002b7a:	91250513          	addi	a0,a0,-1774 # 80008488 <etext+0x488>
    80002b7e:	00004097          	auipc	ra,0x4
    80002b82:	dc6080e7          	jalr	-570(ra) # 80006944 <panic>

0000000080002b86 <iunlock>:
void iunlock(struct inode *ip) {
    80002b86:	1101                	addi	sp,sp,-32
    80002b88:	ec06                	sd	ra,24(sp)
    80002b8a:	e822                	sd	s0,16(sp)
    80002b8c:	e426                	sd	s1,8(sp)
    80002b8e:	e04a                	sd	s2,0(sp)
    80002b90:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002b92:	c905                	beqz	a0,80002bc2 <iunlock+0x3c>
    80002b94:	84aa                	mv	s1,a0
    80002b96:	01050913          	addi	s2,a0,16
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	00001097          	auipc	ra,0x1
    80002ba0:	c82080e7          	jalr	-894(ra) # 8000381e <holdingsleep>
    80002ba4:	cd19                	beqz	a0,80002bc2 <iunlock+0x3c>
    80002ba6:	449c                	lw	a5,8(s1)
    80002ba8:	00f05d63          	blez	a5,80002bc2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bac:	854a                	mv	a0,s2
    80002bae:	00001097          	auipc	ra,0x1
    80002bb2:	c2c080e7          	jalr	-980(ra) # 800037da <releasesleep>
}
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6902                	ld	s2,0(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002bc2:	00006517          	auipc	a0,0x6
    80002bc6:	8d650513          	addi	a0,a0,-1834 # 80008498 <etext+0x498>
    80002bca:	00004097          	auipc	ra,0x4
    80002bce:	d7a080e7          	jalr	-646(ra) # 80006944 <panic>

0000000080002bd2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002bd2:	7179                	addi	sp,sp,-48
    80002bd4:	f406                	sd	ra,40(sp)
    80002bd6:	f022                	sd	s0,32(sp)
    80002bd8:	ec26                	sd	s1,24(sp)
    80002bda:	e84a                	sd	s2,16(sp)
    80002bdc:	e44e                	sd	s3,8(sp)
    80002bde:	1800                	addi	s0,sp,48
    80002be0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002be2:	05050493          	addi	s1,a0,80
    80002be6:	08050913          	addi	s2,a0,128
    80002bea:	a021                	j	80002bf2 <itrunc+0x20>
    80002bec:	0491                	addi	s1,s1,4
    80002bee:	01248d63          	beq	s1,s2,80002c08 <itrunc+0x36>
    if (ip->addrs[i]) {
    80002bf2:	408c                	lw	a1,0(s1)
    80002bf4:	dde5                	beqz	a1,80002bec <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002bf6:	0009a503          	lw	a0,0(s3)
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	8d6080e7          	jalr	-1834(ra) # 800024d0 <bfree>
      ip->addrs[i] = 0;
    80002c02:	0004a023          	sw	zero,0(s1)
    80002c06:	b7dd                	j	80002bec <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002c08:	0809a583          	lw	a1,128(s3)
    80002c0c:	ed99                	bnez	a1,80002c2a <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c0e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c12:	854e                	mv	a0,s3
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	de0080e7          	jalr	-544(ra) # 800029f4 <iupdate>
}
    80002c1c:	70a2                	ld	ra,40(sp)
    80002c1e:	7402                	ld	s0,32(sp)
    80002c20:	64e2                	ld	s1,24(sp)
    80002c22:	6942                	ld	s2,16(sp)
    80002c24:	69a2                	ld	s3,8(sp)
    80002c26:	6145                	addi	sp,sp,48
    80002c28:	8082                	ret
    80002c2a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c2c:	0009a503          	lw	a0,0(s3)
    80002c30:	fffff097          	auipc	ra,0xfffff
    80002c34:	65c080e7          	jalr	1628(ra) # 8000228c <bread>
    80002c38:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002c3a:	05850493          	addi	s1,a0,88
    80002c3e:	45850913          	addi	s2,a0,1112
    80002c42:	a021                	j	80002c4a <itrunc+0x78>
    80002c44:	0491                	addi	s1,s1,4
    80002c46:	01248b63          	beq	s1,s2,80002c5c <itrunc+0x8a>
      if (a[j]) bfree(ip->dev, a[j]);
    80002c4a:	408c                	lw	a1,0(s1)
    80002c4c:	dde5                	beqz	a1,80002c44 <itrunc+0x72>
    80002c4e:	0009a503          	lw	a0,0(s3)
    80002c52:	00000097          	auipc	ra,0x0
    80002c56:	87e080e7          	jalr	-1922(ra) # 800024d0 <bfree>
    80002c5a:	b7ed                	j	80002c44 <itrunc+0x72>
    brelse(bp);
    80002c5c:	8552                	mv	a0,s4
    80002c5e:	fffff097          	auipc	ra,0xfffff
    80002c62:	75e080e7          	jalr	1886(ra) # 800023bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c66:	0809a583          	lw	a1,128(s3)
    80002c6a:	0009a503          	lw	a0,0(s3)
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	862080e7          	jalr	-1950(ra) # 800024d0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c76:	0809a023          	sw	zero,128(s3)
    80002c7a:	6a02                	ld	s4,0(sp)
    80002c7c:	bf49                	j	80002c0e <itrunc+0x3c>

0000000080002c7e <iput>:
void iput(struct inode *ip) {
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	1000                	addi	s0,sp,32
    80002c88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c8a:	00017517          	auipc	a0,0x17
    80002c8e:	17e50513          	addi	a0,a0,382 # 80019e08 <itable>
    80002c92:	00004097          	auipc	ra,0x4
    80002c96:	22c080e7          	jalr	556(ra) # 80006ebe <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002c9a:	4498                	lw	a4,8(s1)
    80002c9c:	4785                	li	a5,1
    80002c9e:	02f70263          	beq	a4,a5,80002cc2 <iput+0x44>
  ip->ref--;
    80002ca2:	449c                	lw	a5,8(s1)
    80002ca4:	37fd                	addiw	a5,a5,-1
    80002ca6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ca8:	00017517          	auipc	a0,0x17
    80002cac:	16050513          	addi	a0,a0,352 # 80019e08 <itable>
    80002cb0:	00004097          	auipc	ra,0x4
    80002cb4:	2c2080e7          	jalr	706(ra) # 80006f72 <release>
}
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002cc2:	40bc                	lw	a5,64(s1)
    80002cc4:	dff9                	beqz	a5,80002ca2 <iput+0x24>
    80002cc6:	04a49783          	lh	a5,74(s1)
    80002cca:	ffe1                	bnez	a5,80002ca2 <iput+0x24>
    80002ccc:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002cce:	01048913          	addi	s2,s1,16
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	ab0080e7          	jalr	-1360(ra) # 80003784 <acquiresleep>
    release(&itable.lock);
    80002cdc:	00017517          	auipc	a0,0x17
    80002ce0:	12c50513          	addi	a0,a0,300 # 80019e08 <itable>
    80002ce4:	00004097          	auipc	ra,0x4
    80002ce8:	28e080e7          	jalr	654(ra) # 80006f72 <release>
    itrunc(ip);
    80002cec:	8526                	mv	a0,s1
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	ee4080e7          	jalr	-284(ra) # 80002bd2 <itrunc>
    ip->type = 0;
    80002cf6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002cfa:	8526                	mv	a0,s1
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	cf8080e7          	jalr	-776(ra) # 800029f4 <iupdate>
    ip->valid = 0;
    80002d04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00001097          	auipc	ra,0x1
    80002d0e:	ad0080e7          	jalr	-1328(ra) # 800037da <releasesleep>
    acquire(&itable.lock);
    80002d12:	00017517          	auipc	a0,0x17
    80002d16:	0f650513          	addi	a0,a0,246 # 80019e08 <itable>
    80002d1a:	00004097          	auipc	ra,0x4
    80002d1e:	1a4080e7          	jalr	420(ra) # 80006ebe <acquire>
    80002d22:	6902                	ld	s2,0(sp)
    80002d24:	bfbd                	j	80002ca2 <iput+0x24>

0000000080002d26 <iunlockput>:
void iunlockput(struct inode *ip) {
    80002d26:	1101                	addi	sp,sp,-32
    80002d28:	ec06                	sd	ra,24(sp)
    80002d2a:	e822                	sd	s0,16(sp)
    80002d2c:	e426                	sd	s1,8(sp)
    80002d2e:	1000                	addi	s0,sp,32
    80002d30:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	e54080e7          	jalr	-428(ra) # 80002b86 <iunlock>
  iput(ip);
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	f42080e7          	jalr	-190(ra) # 80002c7e <iput>
}
    80002d44:	60e2                	ld	ra,24(sp)
    80002d46:	6442                	ld	s0,16(sp)
    80002d48:	64a2                	ld	s1,8(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret

0000000080002d4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002d4e:	1141                	addi	sp,sp,-16
    80002d50:	e422                	sd	s0,8(sp)
    80002d52:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d54:	411c                	lw	a5,0(a0)
    80002d56:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d58:	415c                	lw	a5,4(a0)
    80002d5a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d5c:	04451783          	lh	a5,68(a0)
    80002d60:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d64:	04a51783          	lh	a5,74(a0)
    80002d68:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d6c:	04c56783          	lwu	a5,76(a0)
    80002d70:	e99c                	sd	a5,16(a1)
}
    80002d72:	6422                	ld	s0,8(sp)
    80002d74:	0141                	addi	sp,sp,16
    80002d76:	8082                	ret

0000000080002d78 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002d78:	457c                	lw	a5,76(a0)
    80002d7a:	10d7e563          	bltu	a5,a3,80002e84 <readi+0x10c>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002d7e:	7159                	addi	sp,sp,-112
    80002d80:	f486                	sd	ra,104(sp)
    80002d82:	f0a2                	sd	s0,96(sp)
    80002d84:	eca6                	sd	s1,88(sp)
    80002d86:	e0d2                	sd	s4,64(sp)
    80002d88:	fc56                	sd	s5,56(sp)
    80002d8a:	f85a                	sd	s6,48(sp)
    80002d8c:	f45e                	sd	s7,40(sp)
    80002d8e:	1880                	addi	s0,sp,112
    80002d90:	8b2a                	mv	s6,a0
    80002d92:	8bae                	mv	s7,a1
    80002d94:	8a32                	mv	s4,a2
    80002d96:	84b6                	mv	s1,a3
    80002d98:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002d9a:	9f35                	addw	a4,a4,a3
    80002d9c:	4501                	li	a0,0
    80002d9e:	0cd76a63          	bltu	a4,a3,80002e72 <readi+0xfa>
    80002da2:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size) n = ip->size - off;
    80002da4:	00e7f463          	bgeu	a5,a4,80002dac <readi+0x34>
    80002da8:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002dac:	0a0a8963          	beqz	s5,80002e5e <readi+0xe6>
    80002db0:	e8ca                	sd	s2,80(sp)
    80002db2:	f062                	sd	s8,32(sp)
    80002db4:	ec66                	sd	s9,24(sp)
    80002db6:	e86a                	sd	s10,16(sp)
    80002db8:	e46e                	sd	s11,8(sp)
    80002dba:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002dbc:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dc0:	5c7d                	li	s8,-1
    80002dc2:	a82d                	j	80002dfc <readi+0x84>
    80002dc4:	020d1d93          	slli	s11,s10,0x20
    80002dc8:	020ddd93          	srli	s11,s11,0x20
    80002dcc:	05890613          	addi	a2,s2,88
    80002dd0:	86ee                	mv	a3,s11
    80002dd2:	963a                	add	a2,a2,a4
    80002dd4:	85d2                	mv	a1,s4
    80002dd6:	855e                	mv	a0,s7
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	ae0080e7          	jalr	-1312(ra) # 800018b8 <either_copyout>
    80002de0:	05850d63          	beq	a0,s8,80002e3a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002de4:	854a                	mv	a0,s2
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	5d6080e7          	jalr	1494(ra) # 800023bc <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002dee:	013d09bb          	addw	s3,s10,s3
    80002df2:	009d04bb          	addw	s1,s10,s1
    80002df6:	9a6e                	add	s4,s4,s11
    80002df8:	0559fd63          	bgeu	s3,s5,80002e52 <readi+0xda>
    uint addr = bmap(ip, off / BSIZE);
    80002dfc:	00a4d59b          	srliw	a1,s1,0xa
    80002e00:	855a                	mv	a0,s6
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	88e080e7          	jalr	-1906(ra) # 80002690 <bmap>
    80002e0a:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002e0e:	c9b1                	beqz	a1,80002e62 <readi+0xea>
    bp = bread(ip->dev, addr);
    80002e10:	000b2503          	lw	a0,0(s6)
    80002e14:	fffff097          	auipc	ra,0xfffff
    80002e18:	478080e7          	jalr	1144(ra) # 8000228c <bread>
    80002e1c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002e1e:	3ff4f713          	andi	a4,s1,1023
    80002e22:	40ec87bb          	subw	a5,s9,a4
    80002e26:	413a86bb          	subw	a3,s5,s3
    80002e2a:	8d3e                	mv	s10,a5
    80002e2c:	2781                	sext.w	a5,a5
    80002e2e:	0006861b          	sext.w	a2,a3
    80002e32:	f8f679e3          	bgeu	a2,a5,80002dc4 <readi+0x4c>
    80002e36:	8d36                	mv	s10,a3
    80002e38:	b771                	j	80002dc4 <readi+0x4c>
      brelse(bp);
    80002e3a:	854a                	mv	a0,s2
    80002e3c:	fffff097          	auipc	ra,0xfffff
    80002e40:	580080e7          	jalr	1408(ra) # 800023bc <brelse>
      tot = -1;
    80002e44:	59fd                	li	s3,-1
      break;
    80002e46:	6946                	ld	s2,80(sp)
    80002e48:	7c02                	ld	s8,32(sp)
    80002e4a:	6ce2                	ld	s9,24(sp)
    80002e4c:	6d42                	ld	s10,16(sp)
    80002e4e:	6da2                	ld	s11,8(sp)
    80002e50:	a831                	j	80002e6c <readi+0xf4>
    80002e52:	6946                	ld	s2,80(sp)
    80002e54:	7c02                	ld	s8,32(sp)
    80002e56:	6ce2                	ld	s9,24(sp)
    80002e58:	6d42                	ld	s10,16(sp)
    80002e5a:	6da2                	ld	s11,8(sp)
    80002e5c:	a801                	j	80002e6c <readi+0xf4>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002e5e:	89d6                	mv	s3,s5
    80002e60:	a031                	j	80002e6c <readi+0xf4>
    80002e62:	6946                	ld	s2,80(sp)
    80002e64:	7c02                	ld	s8,32(sp)
    80002e66:	6ce2                	ld	s9,24(sp)
    80002e68:	6d42                	ld	s10,16(sp)
    80002e6a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002e6c:	0009851b          	sext.w	a0,s3
    80002e70:	69a6                	ld	s3,72(sp)
}
    80002e72:	70a6                	ld	ra,104(sp)
    80002e74:	7406                	ld	s0,96(sp)
    80002e76:	64e6                	ld	s1,88(sp)
    80002e78:	6a06                	ld	s4,64(sp)
    80002e7a:	7ae2                	ld	s5,56(sp)
    80002e7c:	7b42                	ld	s6,48(sp)
    80002e7e:	7ba2                	ld	s7,40(sp)
    80002e80:	6165                	addi	sp,sp,112
    80002e82:	8082                	ret
  if (off > ip->size || off + n < off) return 0;
    80002e84:	4501                	li	a0,0
}
    80002e86:	8082                	ret

0000000080002e88 <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002e88:	457c                	lw	a5,76(a0)
    80002e8a:	10d7ee63          	bltu	a5,a3,80002fa6 <writei+0x11e>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002e8e:	7159                	addi	sp,sp,-112
    80002e90:	f486                	sd	ra,104(sp)
    80002e92:	f0a2                	sd	s0,96(sp)
    80002e94:	e8ca                	sd	s2,80(sp)
    80002e96:	e0d2                	sd	s4,64(sp)
    80002e98:	fc56                	sd	s5,56(sp)
    80002e9a:	f85a                	sd	s6,48(sp)
    80002e9c:	f45e                	sd	s7,40(sp)
    80002e9e:	1880                	addi	s0,sp,112
    80002ea0:	8aaa                	mv	s5,a0
    80002ea2:	8bae                	mv	s7,a1
    80002ea4:	8a32                	mv	s4,a2
    80002ea6:	8936                	mv	s2,a3
    80002ea8:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002eaa:	00e687bb          	addw	a5,a3,a4
    80002eae:	0ed7ee63          	bltu	a5,a3,80002faa <writei+0x122>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002eb2:	00043737          	lui	a4,0x43
    80002eb6:	0ef76c63          	bltu	a4,a5,80002fae <writei+0x126>
    80002eba:	e4ce                	sd	s3,72(sp)

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002ebc:	0c0b0d63          	beqz	s6,80002f96 <writei+0x10e>
    80002ec0:	eca6                	sd	s1,88(sp)
    80002ec2:	f062                	sd	s8,32(sp)
    80002ec4:	ec66                	sd	s9,24(sp)
    80002ec6:	e86a                	sd	s10,16(sp)
    80002ec8:	e46e                	sd	s11,8(sp)
    80002eca:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002ecc:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed0:	5c7d                	li	s8,-1
    80002ed2:	a091                	j	80002f16 <writei+0x8e>
    80002ed4:	020d1d93          	slli	s11,s10,0x20
    80002ed8:	020ddd93          	srli	s11,s11,0x20
    80002edc:	05848513          	addi	a0,s1,88
    80002ee0:	86ee                	mv	a3,s11
    80002ee2:	8652                	mv	a2,s4
    80002ee4:	85de                	mv	a1,s7
    80002ee6:	953a                	add	a0,a0,a4
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	a26080e7          	jalr	-1498(ra) # 8000190e <either_copyin>
    80002ef0:	07850263          	beq	a0,s8,80002f54 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	770080e7          	jalr	1904(ra) # 80003666 <log_write>
    brelse(bp);
    80002efe:	8526                	mv	a0,s1
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	4bc080e7          	jalr	1212(ra) # 800023bc <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002f08:	013d09bb          	addw	s3,s10,s3
    80002f0c:	012d093b          	addw	s2,s10,s2
    80002f10:	9a6e                	add	s4,s4,s11
    80002f12:	0569f663          	bgeu	s3,s6,80002f5e <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80002f16:	00a9559b          	srliw	a1,s2,0xa
    80002f1a:	8556                	mv	a0,s5
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	774080e7          	jalr	1908(ra) # 80002690 <bmap>
    80002f24:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002f28:	c99d                	beqz	a1,80002f5e <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f2a:	000aa503          	lw	a0,0(s5)
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	35e080e7          	jalr	862(ra) # 8000228c <bread>
    80002f36:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f38:	3ff97713          	andi	a4,s2,1023
    80002f3c:	40ec87bb          	subw	a5,s9,a4
    80002f40:	413b06bb          	subw	a3,s6,s3
    80002f44:	8d3e                	mv	s10,a5
    80002f46:	2781                	sext.w	a5,a5
    80002f48:	0006861b          	sext.w	a2,a3
    80002f4c:	f8f674e3          	bgeu	a2,a5,80002ed4 <writei+0x4c>
    80002f50:	8d36                	mv	s10,a3
    80002f52:	b749                	j	80002ed4 <writei+0x4c>
      brelse(bp);
    80002f54:	8526                	mv	a0,s1
    80002f56:	fffff097          	auipc	ra,0xfffff
    80002f5a:	466080e7          	jalr	1126(ra) # 800023bc <brelse>
  }

  if (off > ip->size) ip->size = off;
    80002f5e:	04caa783          	lw	a5,76(s5)
    80002f62:	0327fc63          	bgeu	a5,s2,80002f9a <writei+0x112>
    80002f66:	052aa623          	sw	s2,76(s5)
    80002f6a:	64e6                	ld	s1,88(sp)
    80002f6c:	7c02                	ld	s8,32(sp)
    80002f6e:	6ce2                	ld	s9,24(sp)
    80002f70:	6d42                	ld	s10,16(sp)
    80002f72:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f74:	8556                	mv	a0,s5
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	a7e080e7          	jalr	-1410(ra) # 800029f4 <iupdate>

  return tot;
    80002f7e:	0009851b          	sext.w	a0,s3
    80002f82:	69a6                	ld	s3,72(sp)
}
    80002f84:	70a6                	ld	ra,104(sp)
    80002f86:	7406                	ld	s0,96(sp)
    80002f88:	6946                	ld	s2,80(sp)
    80002f8a:	6a06                	ld	s4,64(sp)
    80002f8c:	7ae2                	ld	s5,56(sp)
    80002f8e:	7b42                	ld	s6,48(sp)
    80002f90:	7ba2                	ld	s7,40(sp)
    80002f92:	6165                	addi	sp,sp,112
    80002f94:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002f96:	89da                	mv	s3,s6
    80002f98:	bff1                	j	80002f74 <writei+0xec>
    80002f9a:	64e6                	ld	s1,88(sp)
    80002f9c:	7c02                	ld	s8,32(sp)
    80002f9e:	6ce2                	ld	s9,24(sp)
    80002fa0:	6d42                	ld	s10,16(sp)
    80002fa2:	6da2                	ld	s11,8(sp)
    80002fa4:	bfc1                	j	80002f74 <writei+0xec>
  if (off > ip->size || off + n < off) return -1;
    80002fa6:	557d                	li	a0,-1
}
    80002fa8:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    80002faa:	557d                	li	a0,-1
    80002fac:	bfe1                	j	80002f84 <writei+0xfc>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002fae:	557d                	li	a0,-1
    80002fb0:	bfd1                	j	80002f84 <writei+0xfc>

0000000080002fb2 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80002fb2:	1141                	addi	sp,sp,-16
    80002fb4:	e406                	sd	ra,8(sp)
    80002fb6:	e022                	sd	s0,0(sp)
    80002fb8:	0800                	addi	s0,sp,16
    80002fba:	4639                	li	a2,14
    80002fbc:	ffffd097          	auipc	ra,0xffffd
    80002fc0:	18a080e7          	jalr	394(ra) # 80000146 <strncmp>
    80002fc4:	60a2                	ld	ra,8(sp)
    80002fc6:	6402                	ld	s0,0(sp)
    80002fc8:	0141                	addi	sp,sp,16
    80002fca:	8082                	ret

0000000080002fcc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80002fcc:	7139                	addi	sp,sp,-64
    80002fce:	fc06                	sd	ra,56(sp)
    80002fd0:	f822                	sd	s0,48(sp)
    80002fd2:	f426                	sd	s1,40(sp)
    80002fd4:	f04a                	sd	s2,32(sp)
    80002fd6:	ec4e                	sd	s3,24(sp)
    80002fd8:	e852                	sd	s4,16(sp)
    80002fda:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80002fdc:	04451703          	lh	a4,68(a0)
    80002fe0:	4785                	li	a5,1
    80002fe2:	00f71a63          	bne	a4,a5,80002ff6 <dirlookup+0x2a>
    80002fe6:	892a                	mv	s2,a0
    80002fe8:	89ae                	mv	s3,a1
    80002fea:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80002fec:	457c                	lw	a5,76(a0)
    80002fee:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff0:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80002ff2:	e79d                	bnez	a5,80003020 <dirlookup+0x54>
    80002ff4:	a8a5                	j	8000306c <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80002ff6:	00005517          	auipc	a0,0x5
    80002ffa:	4aa50513          	addi	a0,a0,1194 # 800084a0 <etext+0x4a0>
    80002ffe:	00004097          	auipc	ra,0x4
    80003002:	946080e7          	jalr	-1722(ra) # 80006944 <panic>
      panic("dirlookup read");
    80003006:	00005517          	auipc	a0,0x5
    8000300a:	4b250513          	addi	a0,a0,1202 # 800084b8 <etext+0x4b8>
    8000300e:	00004097          	auipc	ra,0x4
    80003012:	936080e7          	jalr	-1738(ra) # 80006944 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003016:	24c1                	addiw	s1,s1,16
    80003018:	04c92783          	lw	a5,76(s2)
    8000301c:	04f4f763          	bgeu	s1,a5,8000306a <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003020:	4741                	li	a4,16
    80003022:	86a6                	mv	a3,s1
    80003024:	fc040613          	addi	a2,s0,-64
    80003028:	4581                	li	a1,0
    8000302a:	854a                	mv	a0,s2
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	d4c080e7          	jalr	-692(ra) # 80002d78 <readi>
    80003034:	47c1                	li	a5,16
    80003036:	fcf518e3          	bne	a0,a5,80003006 <dirlookup+0x3a>
    if (de.inum == 0) continue;
    8000303a:	fc045783          	lhu	a5,-64(s0)
    8000303e:	dfe1                	beqz	a5,80003016 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80003040:	fc240593          	addi	a1,s0,-62
    80003044:	854e                	mv	a0,s3
    80003046:	00000097          	auipc	ra,0x0
    8000304a:	f6c080e7          	jalr	-148(ra) # 80002fb2 <namecmp>
    8000304e:	f561                	bnez	a0,80003016 <dirlookup+0x4a>
      if (poff) *poff = off;
    80003050:	000a0463          	beqz	s4,80003058 <dirlookup+0x8c>
    80003054:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003058:	fc045583          	lhu	a1,-64(s0)
    8000305c:	00092503          	lw	a0,0(s2)
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	720080e7          	jalr	1824(ra) # 80002780 <iget>
    80003068:	a011                	j	8000306c <dirlookup+0xa0>
  return 0;
    8000306a:	4501                	li	a0,0
}
    8000306c:	70e2                	ld	ra,56(sp)
    8000306e:	7442                	ld	s0,48(sp)
    80003070:	74a2                	ld	s1,40(sp)
    80003072:	7902                	ld	s2,32(sp)
    80003074:	69e2                	ld	s3,24(sp)
    80003076:	6a42                	ld	s4,16(sp)
    80003078:	6121                	addi	sp,sp,64
    8000307a:	8082                	ret

000000008000307c <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    8000307c:	711d                	addi	sp,sp,-96
    8000307e:	ec86                	sd	ra,88(sp)
    80003080:	e8a2                	sd	s0,80(sp)
    80003082:	e4a6                	sd	s1,72(sp)
    80003084:	e0ca                	sd	s2,64(sp)
    80003086:	fc4e                	sd	s3,56(sp)
    80003088:	f852                	sd	s4,48(sp)
    8000308a:	f456                	sd	s5,40(sp)
    8000308c:	f05a                	sd	s6,32(sp)
    8000308e:	ec5e                	sd	s7,24(sp)
    80003090:	e862                	sd	s8,16(sp)
    80003092:	e466                	sd	s9,8(sp)
    80003094:	1080                	addi	s0,sp,96
    80003096:	84aa                	mv	s1,a0
    80003098:	8b2e                	mv	s6,a1
    8000309a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    8000309c:	00054703          	lbu	a4,0(a0)
    800030a0:	02f00793          	li	a5,47
    800030a4:	02f70263          	beq	a4,a5,800030c8 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030a8:	ffffe097          	auipc	ra,0xffffe
    800030ac:	d5a080e7          	jalr	-678(ra) # 80000e02 <myproc>
    800030b0:	15053503          	ld	a0,336(a0)
    800030b4:	00000097          	auipc	ra,0x0
    800030b8:	9ce080e7          	jalr	-1586(ra) # 80002a82 <idup>
    800030bc:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    800030be:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800030c2:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800030c4:	4b85                	li	s7,1
    800030c6:	a875                	j	80003182 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800030c8:	4585                	li	a1,1
    800030ca:	4505                	li	a0,1
    800030cc:	fffff097          	auipc	ra,0xfffff
    800030d0:	6b4080e7          	jalr	1716(ra) # 80002780 <iget>
    800030d4:	8a2a                	mv	s4,a0
    800030d6:	b7e5                	j	800030be <namex+0x42>
      iunlockput(ip);
    800030d8:	8552                	mv	a0,s4
    800030da:	00000097          	auipc	ra,0x0
    800030de:	c4c080e7          	jalr	-948(ra) # 80002d26 <iunlockput>
      return 0;
    800030e2:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800030e4:	8552                	mv	a0,s4
    800030e6:	60e6                	ld	ra,88(sp)
    800030e8:	6446                	ld	s0,80(sp)
    800030ea:	64a6                	ld	s1,72(sp)
    800030ec:	6906                	ld	s2,64(sp)
    800030ee:	79e2                	ld	s3,56(sp)
    800030f0:	7a42                	ld	s4,48(sp)
    800030f2:	7aa2                	ld	s5,40(sp)
    800030f4:	7b02                	ld	s6,32(sp)
    800030f6:	6be2                	ld	s7,24(sp)
    800030f8:	6c42                	ld	s8,16(sp)
    800030fa:	6ca2                	ld	s9,8(sp)
    800030fc:	6125                	addi	sp,sp,96
    800030fe:	8082                	ret
      iunlock(ip);
    80003100:	8552                	mv	a0,s4
    80003102:	00000097          	auipc	ra,0x0
    80003106:	a84080e7          	jalr	-1404(ra) # 80002b86 <iunlock>
      return ip;
    8000310a:	bfe9                	j	800030e4 <namex+0x68>
      iunlockput(ip);
    8000310c:	8552                	mv	a0,s4
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	c18080e7          	jalr	-1000(ra) # 80002d26 <iunlockput>
      return 0;
    80003116:	8a4e                	mv	s4,s3
    80003118:	b7f1                	j	800030e4 <namex+0x68>
  len = path - s;
    8000311a:	40998633          	sub	a2,s3,s1
    8000311e:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80003122:	099c5863          	bge	s8,s9,800031b2 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003126:	4639                	li	a2,14
    80003128:	85a6                	mv	a1,s1
    8000312a:	8556                	mv	a0,s5
    8000312c:	ffffd097          	auipc	ra,0xffffd
    80003130:	fa6080e7          	jalr	-90(ra) # 800000d2 <memmove>
    80003134:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    80003136:	0004c783          	lbu	a5,0(s1)
    8000313a:	01279763          	bne	a5,s2,80003148 <namex+0xcc>
    8000313e:	0485                	addi	s1,s1,1
    80003140:	0004c783          	lbu	a5,0(s1)
    80003144:	ff278de3          	beq	a5,s2,8000313e <namex+0xc2>
    ilock(ip);
    80003148:	8552                	mv	a0,s4
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	976080e7          	jalr	-1674(ra) # 80002ac0 <ilock>
    if (ip->type != T_DIR) {
    80003152:	044a1783          	lh	a5,68(s4)
    80003156:	f97791e3          	bne	a5,s7,800030d8 <namex+0x5c>
    if (nameiparent && *path == '\0') {
    8000315a:	000b0563          	beqz	s6,80003164 <namex+0xe8>
    8000315e:	0004c783          	lbu	a5,0(s1)
    80003162:	dfd9                	beqz	a5,80003100 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003164:	4601                	li	a2,0
    80003166:	85d6                	mv	a1,s5
    80003168:	8552                	mv	a0,s4
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	e62080e7          	jalr	-414(ra) # 80002fcc <dirlookup>
    80003172:	89aa                	mv	s3,a0
    80003174:	dd41                	beqz	a0,8000310c <namex+0x90>
    iunlockput(ip);
    80003176:	8552                	mv	a0,s4
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	bae080e7          	jalr	-1106(ra) # 80002d26 <iunlockput>
    ip = next;
    80003180:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    80003182:	0004c783          	lbu	a5,0(s1)
    80003186:	01279763          	bne	a5,s2,80003194 <namex+0x118>
    8000318a:	0485                	addi	s1,s1,1
    8000318c:	0004c783          	lbu	a5,0(s1)
    80003190:	ff278de3          	beq	a5,s2,8000318a <namex+0x10e>
  if (*path == 0) return 0;
    80003194:	cb9d                	beqz	a5,800031ca <namex+0x14e>
  while (*path != '/' && *path != 0) path++;
    80003196:	0004c783          	lbu	a5,0(s1)
    8000319a:	89a6                	mv	s3,s1
  len = path - s;
    8000319c:	4c81                	li	s9,0
    8000319e:	4601                	li	a2,0
  while (*path != '/' && *path != 0) path++;
    800031a0:	01278963          	beq	a5,s2,800031b2 <namex+0x136>
    800031a4:	dbbd                	beqz	a5,8000311a <namex+0x9e>
    800031a6:	0985                	addi	s3,s3,1
    800031a8:	0009c783          	lbu	a5,0(s3)
    800031ac:	ff279ce3          	bne	a5,s2,800031a4 <namex+0x128>
    800031b0:	b7ad                	j	8000311a <namex+0x9e>
    memmove(name, s, len);
    800031b2:	2601                	sext.w	a2,a2
    800031b4:	85a6                	mv	a1,s1
    800031b6:	8556                	mv	a0,s5
    800031b8:	ffffd097          	auipc	ra,0xffffd
    800031bc:	f1a080e7          	jalr	-230(ra) # 800000d2 <memmove>
    name[len] = 0;
    800031c0:	9cd6                	add	s9,s9,s5
    800031c2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031c6:	84ce                	mv	s1,s3
    800031c8:	b7bd                	j	80003136 <namex+0xba>
  if (nameiparent) {
    800031ca:	f00b0de3          	beqz	s6,800030e4 <namex+0x68>
    iput(ip);
    800031ce:	8552                	mv	a0,s4
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	aae080e7          	jalr	-1362(ra) # 80002c7e <iput>
    return 0;
    800031d8:	4a01                	li	s4,0
    800031da:	b729                	j	800030e4 <namex+0x68>

00000000800031dc <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800031dc:	7139                	addi	sp,sp,-64
    800031de:	fc06                	sd	ra,56(sp)
    800031e0:	f822                	sd	s0,48(sp)
    800031e2:	f04a                	sd	s2,32(sp)
    800031e4:	ec4e                	sd	s3,24(sp)
    800031e6:	e852                	sd	s4,16(sp)
    800031e8:	0080                	addi	s0,sp,64
    800031ea:	892a                	mv	s2,a0
    800031ec:	8a2e                	mv	s4,a1
    800031ee:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800031f0:	4601                	li	a2,0
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	dda080e7          	jalr	-550(ra) # 80002fcc <dirlookup>
    800031fa:	ed25                	bnez	a0,80003272 <dirlink+0x96>
    800031fc:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800031fe:	04c92483          	lw	s1,76(s2)
    80003202:	c49d                	beqz	s1,80003230 <dirlink+0x54>
    80003204:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003206:	4741                	li	a4,16
    80003208:	86a6                	mv	a3,s1
    8000320a:	fc040613          	addi	a2,s0,-64
    8000320e:	4581                	li	a1,0
    80003210:	854a                	mv	a0,s2
    80003212:	00000097          	auipc	ra,0x0
    80003216:	b66080e7          	jalr	-1178(ra) # 80002d78 <readi>
    8000321a:	47c1                	li	a5,16
    8000321c:	06f51163          	bne	a0,a5,8000327e <dirlink+0xa2>
    if (de.inum == 0) break;
    80003220:	fc045783          	lhu	a5,-64(s0)
    80003224:	c791                	beqz	a5,80003230 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003226:	24c1                	addiw	s1,s1,16
    80003228:	04c92783          	lw	a5,76(s2)
    8000322c:	fcf4ede3          	bltu	s1,a5,80003206 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003230:	4639                	li	a2,14
    80003232:	85d2                	mv	a1,s4
    80003234:	fc240513          	addi	a0,s0,-62
    80003238:	ffffd097          	auipc	ra,0xffffd
    8000323c:	f44080e7          	jalr	-188(ra) # 8000017c <strncpy>
  de.inum = inum;
    80003240:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    80003244:	4741                	li	a4,16
    80003246:	86a6                	mv	a3,s1
    80003248:	fc040613          	addi	a2,s0,-64
    8000324c:	4581                	li	a1,0
    8000324e:	854a                	mv	a0,s2
    80003250:	00000097          	auipc	ra,0x0
    80003254:	c38080e7          	jalr	-968(ra) # 80002e88 <writei>
    80003258:	1541                	addi	a0,a0,-16
    8000325a:	00a03533          	snez	a0,a0
    8000325e:	40a00533          	neg	a0,a0
    80003262:	74a2                	ld	s1,40(sp)
}
    80003264:	70e2                	ld	ra,56(sp)
    80003266:	7442                	ld	s0,48(sp)
    80003268:	7902                	ld	s2,32(sp)
    8000326a:	69e2                	ld	s3,24(sp)
    8000326c:	6a42                	ld	s4,16(sp)
    8000326e:	6121                	addi	sp,sp,64
    80003270:	8082                	ret
    iput(ip);
    80003272:	00000097          	auipc	ra,0x0
    80003276:	a0c080e7          	jalr	-1524(ra) # 80002c7e <iput>
    return -1;
    8000327a:	557d                	li	a0,-1
    8000327c:	b7e5                	j	80003264 <dirlink+0x88>
      panic("dirlink read");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	24a50513          	addi	a0,a0,586 # 800084c8 <etext+0x4c8>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	6be080e7          	jalr	1726(ra) # 80006944 <panic>

000000008000328e <namei>:

struct inode *namei(char *path) {
    8000328e:	1101                	addi	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003296:	fe040613          	addi	a2,s0,-32
    8000329a:	4581                	li	a1,0
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	de0080e7          	jalr	-544(ra) # 8000307c <namex>
}
    800032a4:	60e2                	ld	ra,24(sp)
    800032a6:	6442                	ld	s0,16(sp)
    800032a8:	6105                	addi	sp,sp,32
    800032aa:	8082                	ret

00000000800032ac <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800032ac:	1141                	addi	sp,sp,-16
    800032ae:	e406                	sd	ra,8(sp)
    800032b0:	e022                	sd	s0,0(sp)
    800032b2:	0800                	addi	s0,sp,16
    800032b4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b6:	4585                	li	a1,1
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	dc4080e7          	jalr	-572(ra) # 8000307c <namex>
}
    800032c0:	60a2                	ld	ra,8(sp)
    800032c2:	6402                	ld	s0,0(sp)
    800032c4:	0141                	addi	sp,sp,16
    800032c6:	8082                	ret

00000000800032c8 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032d4:	00018917          	auipc	s2,0x18
    800032d8:	5dc90913          	addi	s2,s2,1500 # 8001b8b0 <log>
    800032dc:	01892583          	lw	a1,24(s2)
    800032e0:	02892503          	lw	a0,40(s2)
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	fa8080e7          	jalr	-88(ra) # 8000228c <bread>
    800032ec:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    800032ee:	02c92603          	lw	a2,44(s2)
    800032f2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032f4:	00c05f63          	blez	a2,80003312 <write_head+0x4a>
    800032f8:	00018717          	auipc	a4,0x18
    800032fc:	5e870713          	addi	a4,a4,1512 # 8001b8e0 <log+0x30>
    80003300:	87aa                	mv	a5,a0
    80003302:	060a                	slli	a2,a2,0x2
    80003304:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003306:	4314                	lw	a3,0(a4)
    80003308:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000330a:	0711                	addi	a4,a4,4
    8000330c:	0791                	addi	a5,a5,4
    8000330e:	fec79ce3          	bne	a5,a2,80003306 <write_head+0x3e>
  }
  bwrite(buf);
    80003312:	8526                	mv	a0,s1
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	06a080e7          	jalr	106(ra) # 8000237e <bwrite>
  brelse(buf);
    8000331c:	8526                	mv	a0,s1
    8000331e:	fffff097          	auipc	ra,0xfffff
    80003322:	09e080e7          	jalr	158(ra) # 800023bc <brelse>
}
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	64a2                	ld	s1,8(sp)
    8000332c:	6902                	ld	s2,0(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003332:	00018797          	auipc	a5,0x18
    80003336:	5aa7a783          	lw	a5,1450(a5) # 8001b8dc <log+0x2c>
    8000333a:	0af05d63          	blez	a5,800033f4 <install_trans+0xc2>
static void install_trans(int recovering) {
    8000333e:	7139                	addi	sp,sp,-64
    80003340:	fc06                	sd	ra,56(sp)
    80003342:	f822                	sd	s0,48(sp)
    80003344:	f426                	sd	s1,40(sp)
    80003346:	f04a                	sd	s2,32(sp)
    80003348:	ec4e                	sd	s3,24(sp)
    8000334a:	e852                	sd	s4,16(sp)
    8000334c:	e456                	sd	s5,8(sp)
    8000334e:	e05a                	sd	s6,0(sp)
    80003350:	0080                	addi	s0,sp,64
    80003352:	8b2a                	mv	s6,a0
    80003354:	00018a97          	auipc	s5,0x18
    80003358:	58ca8a93          	addi	s5,s5,1420 # 8001b8e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000335c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    8000335e:	00018997          	auipc	s3,0x18
    80003362:	55298993          	addi	s3,s3,1362 # 8001b8b0 <log>
    80003366:	a00d                	j	80003388 <install_trans+0x56>
    brelse(lbuf);
    80003368:	854a                	mv	a0,s2
    8000336a:	fffff097          	auipc	ra,0xfffff
    8000336e:	052080e7          	jalr	82(ra) # 800023bc <brelse>
    brelse(dbuf);
    80003372:	8526                	mv	a0,s1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	048080e7          	jalr	72(ra) # 800023bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337c:	2a05                	addiw	s4,s4,1
    8000337e:	0a91                	addi	s5,s5,4
    80003380:	02c9a783          	lw	a5,44(s3)
    80003384:	04fa5e63          	bge	s4,a5,800033e0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003388:	0189a583          	lw	a1,24(s3)
    8000338c:	014585bb          	addw	a1,a1,s4
    80003390:	2585                	addiw	a1,a1,1
    80003392:	0289a503          	lw	a0,40(s3)
    80003396:	fffff097          	auipc	ra,0xfffff
    8000339a:	ef6080e7          	jalr	-266(ra) # 8000228c <bread>
    8000339e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800033a0:	000aa583          	lw	a1,0(s5)
    800033a4:	0289a503          	lw	a0,40(s3)
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	ee4080e7          	jalr	-284(ra) # 8000228c <bread>
    800033b0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033b2:	40000613          	li	a2,1024
    800033b6:	05890593          	addi	a1,s2,88
    800033ba:	05850513          	addi	a0,a0,88
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	d14080e7          	jalr	-748(ra) # 800000d2 <memmove>
    bwrite(dbuf);                            // write dst to disk
    800033c6:	8526                	mv	a0,s1
    800033c8:	fffff097          	auipc	ra,0xfffff
    800033cc:	fb6080e7          	jalr	-74(ra) # 8000237e <bwrite>
    if (recovering == 0) bunpin(dbuf);
    800033d0:	f80b1ce3          	bnez	s6,80003368 <install_trans+0x36>
    800033d4:	8526                	mv	a0,s1
    800033d6:	fffff097          	auipc	ra,0xfffff
    800033da:	0be080e7          	jalr	190(ra) # 80002494 <bunpin>
    800033de:	b769                	j	80003368 <install_trans+0x36>
}
    800033e0:	70e2                	ld	ra,56(sp)
    800033e2:	7442                	ld	s0,48(sp)
    800033e4:	74a2                	ld	s1,40(sp)
    800033e6:	7902                	ld	s2,32(sp)
    800033e8:	69e2                	ld	s3,24(sp)
    800033ea:	6a42                	ld	s4,16(sp)
    800033ec:	6aa2                	ld	s5,8(sp)
    800033ee:	6b02                	ld	s6,0(sp)
    800033f0:	6121                	addi	sp,sp,64
    800033f2:	8082                	ret
    800033f4:	8082                	ret

00000000800033f6 <initlog>:
void initlog(int dev, struct superblock *sb) {
    800033f6:	7179                	addi	sp,sp,-48
    800033f8:	f406                	sd	ra,40(sp)
    800033fa:	f022                	sd	s0,32(sp)
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	e84a                	sd	s2,16(sp)
    80003400:	e44e                	sd	s3,8(sp)
    80003402:	1800                	addi	s0,sp,48
    80003404:	892a                	mv	s2,a0
    80003406:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003408:	00018497          	auipc	s1,0x18
    8000340c:	4a848493          	addi	s1,s1,1192 # 8001b8b0 <log>
    80003410:	00005597          	auipc	a1,0x5
    80003414:	0c858593          	addi	a1,a1,200 # 800084d8 <etext+0x4d8>
    80003418:	8526                	mv	a0,s1
    8000341a:	00004097          	auipc	ra,0x4
    8000341e:	a14080e7          	jalr	-1516(ra) # 80006e2e <initlock>
  log.start = sb->logstart;
    80003422:	0149a583          	lw	a1,20(s3)
    80003426:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003428:	0109a783          	lw	a5,16(s3)
    8000342c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000342e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003432:	854a                	mv	a0,s2
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	e58080e7          	jalr	-424(ra) # 8000228c <bread>
  log.lh.n = lh->n;
    8000343c:	4d30                	lw	a2,88(a0)
    8000343e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003440:	00c05f63          	blez	a2,8000345e <initlog+0x68>
    80003444:	87aa                	mv	a5,a0
    80003446:	00018717          	auipc	a4,0x18
    8000344a:	49a70713          	addi	a4,a4,1178 # 8001b8e0 <log+0x30>
    8000344e:	060a                	slli	a2,a2,0x2
    80003450:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003452:	4ff4                	lw	a3,92(a5)
    80003454:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003456:	0791                	addi	a5,a5,4
    80003458:	0711                	addi	a4,a4,4
    8000345a:	fec79ce3          	bne	a5,a2,80003452 <initlog+0x5c>
  brelse(buf);
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	f5e080e7          	jalr	-162(ra) # 800023bc <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    80003466:	4505                	li	a0,1
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	eca080e7          	jalr	-310(ra) # 80003332 <install_trans>
  log.lh.n = 0;
    80003470:	00018797          	auipc	a5,0x18
    80003474:	4607a623          	sw	zero,1132(a5) # 8001b8dc <log+0x2c>
  write_head();  // clear the log
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	e50080e7          	jalr	-432(ra) # 800032c8 <write_head>
}
    80003480:	70a2                	ld	ra,40(sp)
    80003482:	7402                	ld	s0,32(sp)
    80003484:	64e2                	ld	s1,24(sp)
    80003486:	6942                	ld	s2,16(sp)
    80003488:	69a2                	ld	s3,8(sp)
    8000348a:	6145                	addi	sp,sp,48
    8000348c:	8082                	ret

000000008000348e <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    8000348e:	1101                	addi	sp,sp,-32
    80003490:	ec06                	sd	ra,24(sp)
    80003492:	e822                	sd	s0,16(sp)
    80003494:	e426                	sd	s1,8(sp)
    80003496:	e04a                	sd	s2,0(sp)
    80003498:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000349a:	00018517          	auipc	a0,0x18
    8000349e:	41650513          	addi	a0,a0,1046 # 8001b8b0 <log>
    800034a2:	00004097          	auipc	ra,0x4
    800034a6:	a1c080e7          	jalr	-1508(ra) # 80006ebe <acquire>
  while (1) {
    if (log.committing) {
    800034aa:	00018497          	auipc	s1,0x18
    800034ae:	40648493          	addi	s1,s1,1030 # 8001b8b0 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800034b2:	4979                	li	s2,30
    800034b4:	a039                	j	800034c2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034b6:	85a6                	mv	a1,s1
    800034b8:	8526                	mv	a0,s1
    800034ba:	ffffe097          	auipc	ra,0xffffe
    800034be:	ff6080e7          	jalr	-10(ra) # 800014b0 <sleep>
    if (log.committing) {
    800034c2:	50dc                	lw	a5,36(s1)
    800034c4:	fbed                	bnez	a5,800034b6 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800034c6:	5098                	lw	a4,32(s1)
    800034c8:	2705                	addiw	a4,a4,1
    800034ca:	0027179b          	slliw	a5,a4,0x2
    800034ce:	9fb9                	addw	a5,a5,a4
    800034d0:	0017979b          	slliw	a5,a5,0x1
    800034d4:	54d4                	lw	a3,44(s1)
    800034d6:	9fb5                	addw	a5,a5,a3
    800034d8:	00f95963          	bge	s2,a5,800034ea <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034dc:	85a6                	mv	a1,s1
    800034de:	8526                	mv	a0,s1
    800034e0:	ffffe097          	auipc	ra,0xffffe
    800034e4:	fd0080e7          	jalr	-48(ra) # 800014b0 <sleep>
    800034e8:	bfe9                	j	800034c2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034ea:	00018517          	auipc	a0,0x18
    800034ee:	3c650513          	addi	a0,a0,966 # 8001b8b0 <log>
    800034f2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034f4:	00004097          	auipc	ra,0x4
    800034f8:	a7e080e7          	jalr	-1410(ra) # 80006f72 <release>
      break;
    }
  }
}
    800034fc:	60e2                	ld	ra,24(sp)
    800034fe:	6442                	ld	s0,16(sp)
    80003500:	64a2                	ld	s1,8(sp)
    80003502:	6902                	ld	s2,0(sp)
    80003504:	6105                	addi	sp,sp,32
    80003506:	8082                	ret

0000000080003508 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80003508:	7139                	addi	sp,sp,-64
    8000350a:	fc06                	sd	ra,56(sp)
    8000350c:	f822                	sd	s0,48(sp)
    8000350e:	f426                	sd	s1,40(sp)
    80003510:	f04a                	sd	s2,32(sp)
    80003512:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003514:	00018497          	auipc	s1,0x18
    80003518:	39c48493          	addi	s1,s1,924 # 8001b8b0 <log>
    8000351c:	8526                	mv	a0,s1
    8000351e:	00004097          	auipc	ra,0x4
    80003522:	9a0080e7          	jalr	-1632(ra) # 80006ebe <acquire>
  log.outstanding -= 1;
    80003526:	509c                	lw	a5,32(s1)
    80003528:	37fd                	addiw	a5,a5,-1
    8000352a:	0007891b          	sext.w	s2,a5
    8000352e:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    80003530:	50dc                	lw	a5,36(s1)
    80003532:	e7b9                	bnez	a5,80003580 <end_op+0x78>
  if (log.outstanding == 0) {
    80003534:	06091163          	bnez	s2,80003596 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003538:	00018497          	auipc	s1,0x18
    8000353c:	37848493          	addi	s1,s1,888 # 8001b8b0 <log>
    80003540:	4785                	li	a5,1
    80003542:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003544:	8526                	mv	a0,s1
    80003546:	00004097          	auipc	ra,0x4
    8000354a:	a2c080e7          	jalr	-1492(ra) # 80006f72 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    8000354e:	54dc                	lw	a5,44(s1)
    80003550:	06f04763          	bgtz	a5,800035be <end_op+0xb6>
    acquire(&log.lock);
    80003554:	00018497          	auipc	s1,0x18
    80003558:	35c48493          	addi	s1,s1,860 # 8001b8b0 <log>
    8000355c:	8526                	mv	a0,s1
    8000355e:	00004097          	auipc	ra,0x4
    80003562:	960080e7          	jalr	-1696(ra) # 80006ebe <acquire>
    log.committing = 0;
    80003566:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000356a:	8526                	mv	a0,s1
    8000356c:	ffffe097          	auipc	ra,0xffffe
    80003570:	fa8080e7          	jalr	-88(ra) # 80001514 <wakeup>
    release(&log.lock);
    80003574:	8526                	mv	a0,s1
    80003576:	00004097          	auipc	ra,0x4
    8000357a:	9fc080e7          	jalr	-1540(ra) # 80006f72 <release>
}
    8000357e:	a815                	j	800035b2 <end_op+0xaa>
    80003580:	ec4e                	sd	s3,24(sp)
    80003582:	e852                	sd	s4,16(sp)
    80003584:	e456                	sd	s5,8(sp)
  if (log.committing) panic("log.committing");
    80003586:	00005517          	auipc	a0,0x5
    8000358a:	f5a50513          	addi	a0,a0,-166 # 800084e0 <etext+0x4e0>
    8000358e:	00003097          	auipc	ra,0x3
    80003592:	3b6080e7          	jalr	950(ra) # 80006944 <panic>
    wakeup(&log);
    80003596:	00018497          	auipc	s1,0x18
    8000359a:	31a48493          	addi	s1,s1,794 # 8001b8b0 <log>
    8000359e:	8526                	mv	a0,s1
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	f74080e7          	jalr	-140(ra) # 80001514 <wakeup>
  release(&log.lock);
    800035a8:	8526                	mv	a0,s1
    800035aa:	00004097          	auipc	ra,0x4
    800035ae:	9c8080e7          	jalr	-1592(ra) # 80006f72 <release>
}
    800035b2:	70e2                	ld	ra,56(sp)
    800035b4:	7442                	ld	s0,48(sp)
    800035b6:	74a2                	ld	s1,40(sp)
    800035b8:	7902                	ld	s2,32(sp)
    800035ba:	6121                	addi	sp,sp,64
    800035bc:	8082                	ret
    800035be:	ec4e                	sd	s3,24(sp)
    800035c0:	e852                	sd	s4,16(sp)
    800035c2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c4:	00018a97          	auipc	s5,0x18
    800035c8:	31ca8a93          	addi	s5,s5,796 # 8001b8e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    800035cc:	00018a17          	auipc	s4,0x18
    800035d0:	2e4a0a13          	addi	s4,s4,740 # 8001b8b0 <log>
    800035d4:	018a2583          	lw	a1,24(s4)
    800035d8:	012585bb          	addw	a1,a1,s2
    800035dc:	2585                	addiw	a1,a1,1
    800035de:	028a2503          	lw	a0,40(s4)
    800035e2:	fffff097          	auipc	ra,0xfffff
    800035e6:	caa080e7          	jalr	-854(ra) # 8000228c <bread>
    800035ea:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    800035ec:	000aa583          	lw	a1,0(s5)
    800035f0:	028a2503          	lw	a0,40(s4)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	c98080e7          	jalr	-872(ra) # 8000228c <bread>
    800035fc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035fe:	40000613          	li	a2,1024
    80003602:	05850593          	addi	a1,a0,88
    80003606:	05848513          	addi	a0,s1,88
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	ac8080e7          	jalr	-1336(ra) # 800000d2 <memmove>
    bwrite(to);  // write the log
    80003612:	8526                	mv	a0,s1
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	d6a080e7          	jalr	-662(ra) # 8000237e <bwrite>
    brelse(from);
    8000361c:	854e                	mv	a0,s3
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	d9e080e7          	jalr	-610(ra) # 800023bc <brelse>
    brelse(to);
    80003626:	8526                	mv	a0,s1
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	d94080e7          	jalr	-620(ra) # 800023bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003630:	2905                	addiw	s2,s2,1
    80003632:	0a91                	addi	s5,s5,4
    80003634:	02ca2783          	lw	a5,44(s4)
    80003638:	f8f94ee3          	blt	s2,a5,800035d4 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	c8c080e7          	jalr	-884(ra) # 800032c8 <write_head>
    install_trans(0);  // Now install writes to home locations
    80003644:	4501                	li	a0,0
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	cec080e7          	jalr	-788(ra) # 80003332 <install_trans>
    log.lh.n = 0;
    8000364e:	00018797          	auipc	a5,0x18
    80003652:	2807a723          	sw	zero,654(a5) # 8001b8dc <log+0x2c>
    write_head();  // Erase the transaction from the log
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	c72080e7          	jalr	-910(ra) # 800032c8 <write_head>
    8000365e:	69e2                	ld	s3,24(sp)
    80003660:	6a42                	ld	s4,16(sp)
    80003662:	6aa2                	ld	s5,8(sp)
    80003664:	bdc5                	j	80003554 <end_op+0x4c>

0000000080003666 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80003666:	1101                	addi	sp,sp,-32
    80003668:	ec06                	sd	ra,24(sp)
    8000366a:	e822                	sd	s0,16(sp)
    8000366c:	e426                	sd	s1,8(sp)
    8000366e:	e04a                	sd	s2,0(sp)
    80003670:	1000                	addi	s0,sp,32
    80003672:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003674:	00018917          	auipc	s2,0x18
    80003678:	23c90913          	addi	s2,s2,572 # 8001b8b0 <log>
    8000367c:	854a                	mv	a0,s2
    8000367e:	00004097          	auipc	ra,0x4
    80003682:	840080e7          	jalr	-1984(ra) # 80006ebe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003686:	02c92603          	lw	a2,44(s2)
    8000368a:	47f5                	li	a5,29
    8000368c:	06c7c563          	blt	a5,a2,800036f6 <log_write+0x90>
    80003690:	00018797          	auipc	a5,0x18
    80003694:	23c7a783          	lw	a5,572(a5) # 8001b8cc <log+0x1c>
    80003698:	37fd                	addiw	a5,a5,-1
    8000369a:	04f65e63          	bge	a2,a5,800036f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    8000369e:	00018797          	auipc	a5,0x18
    800036a2:	2327a783          	lw	a5,562(a5) # 8001b8d0 <log+0x20>
    800036a6:	06f05063          	blez	a5,80003706 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    800036aa:	4781                	li	a5,0
    800036ac:	06c05563          	blez	a2,80003716 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    800036b0:	44cc                	lw	a1,12(s1)
    800036b2:	00018717          	auipc	a4,0x18
    800036b6:	22e70713          	addi	a4,a4,558 # 8001b8e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    800036bc:	4314                	lw	a3,0(a4)
    800036be:	04b68c63          	beq	a3,a1,80003716 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036c2:	2785                	addiw	a5,a5,1
    800036c4:	0711                	addi	a4,a4,4
    800036c6:	fef61be3          	bne	a2,a5,800036bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036ca:	0621                	addi	a2,a2,8
    800036cc:	060a                	slli	a2,a2,0x2
    800036ce:	00018797          	auipc	a5,0x18
    800036d2:	1e278793          	addi	a5,a5,482 # 8001b8b0 <log>
    800036d6:	97b2                	add	a5,a5,a2
    800036d8:	44d8                	lw	a4,12(s1)
    800036da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036dc:	8526                	mv	a0,s1
    800036de:	fffff097          	auipc	ra,0xfffff
    800036e2:	d7a080e7          	jalr	-646(ra) # 80002458 <bpin>
    log.lh.n++;
    800036e6:	00018717          	auipc	a4,0x18
    800036ea:	1ca70713          	addi	a4,a4,458 # 8001b8b0 <log>
    800036ee:	575c                	lw	a5,44(a4)
    800036f0:	2785                	addiw	a5,a5,1
    800036f2:	d75c                	sw	a5,44(a4)
    800036f4:	a82d                	j	8000372e <log_write+0xc8>
    panic("too big a transaction");
    800036f6:	00005517          	auipc	a0,0x5
    800036fa:	dfa50513          	addi	a0,a0,-518 # 800084f0 <etext+0x4f0>
    800036fe:	00003097          	auipc	ra,0x3
    80003702:	246080e7          	jalr	582(ra) # 80006944 <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003706:	00005517          	auipc	a0,0x5
    8000370a:	e0250513          	addi	a0,a0,-510 # 80008508 <etext+0x508>
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	236080e7          	jalr	566(ra) # 80006944 <panic>
  log.lh.block[i] = b->blockno;
    80003716:	00878693          	addi	a3,a5,8
    8000371a:	068a                	slli	a3,a3,0x2
    8000371c:	00018717          	auipc	a4,0x18
    80003720:	19470713          	addi	a4,a4,404 # 8001b8b0 <log>
    80003724:	9736                	add	a4,a4,a3
    80003726:	44d4                	lw	a3,12(s1)
    80003728:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000372a:	faf609e3          	beq	a2,a5,800036dc <log_write+0x76>
  }
  release(&log.lock);
    8000372e:	00018517          	auipc	a0,0x18
    80003732:	18250513          	addi	a0,a0,386 # 8001b8b0 <log>
    80003736:	00004097          	auipc	ra,0x4
    8000373a:	83c080e7          	jalr	-1988(ra) # 80006f72 <release>
}
    8000373e:	60e2                	ld	ra,24(sp)
    80003740:	6442                	ld	s0,16(sp)
    80003742:	64a2                	ld	s1,8(sp)
    80003744:	6902                	ld	s2,0(sp)
    80003746:	6105                	addi	sp,sp,32
    80003748:	8082                	ret

000000008000374a <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    8000374a:	1101                	addi	sp,sp,-32
    8000374c:	ec06                	sd	ra,24(sp)
    8000374e:	e822                	sd	s0,16(sp)
    80003750:	e426                	sd	s1,8(sp)
    80003752:	e04a                	sd	s2,0(sp)
    80003754:	1000                	addi	s0,sp,32
    80003756:	84aa                	mv	s1,a0
    80003758:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000375a:	00005597          	auipc	a1,0x5
    8000375e:	dce58593          	addi	a1,a1,-562 # 80008528 <etext+0x528>
    80003762:	0521                	addi	a0,a0,8
    80003764:	00003097          	auipc	ra,0x3
    80003768:	6ca080e7          	jalr	1738(ra) # 80006e2e <initlock>
  lk->name = name;
    8000376c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003770:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003774:	0204a423          	sw	zero,40(s1)
}
    80003778:	60e2                	ld	ra,24(sp)
    8000377a:	6442                	ld	s0,16(sp)
    8000377c:	64a2                	ld	s1,8(sp)
    8000377e:	6902                	ld	s2,0(sp)
    80003780:	6105                	addi	sp,sp,32
    80003782:	8082                	ret

0000000080003784 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003784:	1101                	addi	sp,sp,-32
    80003786:	ec06                	sd	ra,24(sp)
    80003788:	e822                	sd	s0,16(sp)
    8000378a:	e426                	sd	s1,8(sp)
    8000378c:	e04a                	sd	s2,0(sp)
    8000378e:	1000                	addi	s0,sp,32
    80003790:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003792:	00850913          	addi	s2,a0,8
    80003796:	854a                	mv	a0,s2
    80003798:	00003097          	auipc	ra,0x3
    8000379c:	726080e7          	jalr	1830(ra) # 80006ebe <acquire>
  while (lk->locked) {
    800037a0:	409c                	lw	a5,0(s1)
    800037a2:	cb89                	beqz	a5,800037b4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037a4:	85ca                	mv	a1,s2
    800037a6:	8526                	mv	a0,s1
    800037a8:	ffffe097          	auipc	ra,0xffffe
    800037ac:	d08080e7          	jalr	-760(ra) # 800014b0 <sleep>
  while (lk->locked) {
    800037b0:	409c                	lw	a5,0(s1)
    800037b2:	fbed                	bnez	a5,800037a4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037b4:	4785                	li	a5,1
    800037b6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	64a080e7          	jalr	1610(ra) # 80000e02 <myproc>
    800037c0:	591c                	lw	a5,48(a0)
    800037c2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037c4:	854a                	mv	a0,s2
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	7ac080e7          	jalr	1964(ra) # 80006f72 <release>
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	64a2                	ld	s1,8(sp)
    800037d4:	6902                	ld	s2,0(sp)
    800037d6:	6105                	addi	sp,sp,32
    800037d8:	8082                	ret

00000000800037da <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
    800037e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037e8:	00850913          	addi	s2,a0,8
    800037ec:	854a                	mv	a0,s2
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	6d0080e7          	jalr	1744(ra) # 80006ebe <acquire>
  lk->locked = 0;
    800037f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037fa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037fe:	8526                	mv	a0,s1
    80003800:	ffffe097          	auipc	ra,0xffffe
    80003804:	d14080e7          	jalr	-748(ra) # 80001514 <wakeup>
  release(&lk->lk);
    80003808:	854a                	mv	a0,s2
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	768080e7          	jalr	1896(ra) # 80006f72 <release>
}
    80003812:	60e2                	ld	ra,24(sp)
    80003814:	6442                	ld	s0,16(sp)
    80003816:	64a2                	ld	s1,8(sp)
    80003818:	6902                	ld	s2,0(sp)
    8000381a:	6105                	addi	sp,sp,32
    8000381c:	8082                	ret

000000008000381e <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    8000381e:	7179                	addi	sp,sp,-48
    80003820:	f406                	sd	ra,40(sp)
    80003822:	f022                	sd	s0,32(sp)
    80003824:	ec26                	sd	s1,24(sp)
    80003826:	e84a                	sd	s2,16(sp)
    80003828:	1800                	addi	s0,sp,48
    8000382a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000382c:	00850913          	addi	s2,a0,8
    80003830:	854a                	mv	a0,s2
    80003832:	00003097          	auipc	ra,0x3
    80003836:	68c080e7          	jalr	1676(ra) # 80006ebe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000383a:	409c                	lw	a5,0(s1)
    8000383c:	ef91                	bnez	a5,80003858 <holdingsleep+0x3a>
    8000383e:	4481                	li	s1,0
  release(&lk->lk);
    80003840:	854a                	mv	a0,s2
    80003842:	00003097          	auipc	ra,0x3
    80003846:	730080e7          	jalr	1840(ra) # 80006f72 <release>
  return r;
}
    8000384a:	8526                	mv	a0,s1
    8000384c:	70a2                	ld	ra,40(sp)
    8000384e:	7402                	ld	s0,32(sp)
    80003850:	64e2                	ld	s1,24(sp)
    80003852:	6942                	ld	s2,16(sp)
    80003854:	6145                	addi	sp,sp,48
    80003856:	8082                	ret
    80003858:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000385a:	0284a983          	lw	s3,40(s1)
    8000385e:	ffffd097          	auipc	ra,0xffffd
    80003862:	5a4080e7          	jalr	1444(ra) # 80000e02 <myproc>
    80003866:	5904                	lw	s1,48(a0)
    80003868:	413484b3          	sub	s1,s1,s3
    8000386c:	0014b493          	seqz	s1,s1
    80003870:	69a2                	ld	s3,8(sp)
    80003872:	b7f9                	j	80003840 <holdingsleep+0x22>

0000000080003874 <fileinit>:
#include "stat.h"
#include "types.h"

struct devsw devsw[NDEV];

void fileinit(void) {}
    80003874:	1141                	addi	sp,sp,-16
    80003876:	e422                	sd	s0,8(sp)
    80003878:	0800                	addi	s0,sp,16
    8000387a:	6422                	ld	s0,8(sp)
    8000387c:	0141                	addi	sp,sp,16
    8000387e:	8082                	ret

0000000080003880 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003880:	1101                	addi	sp,sp,-32
    80003882:	ec06                	sd	ra,24(sp)
    80003884:	e822                	sd	s0,16(sp)
    80003886:	e426                	sd	s1,8(sp)
    80003888:	1000                	addi	s0,sp,32
  struct file *new_file = (struct file *)bd_malloc(sizeof(struct file));
    8000388a:	04000513          	li	a0,64
    8000388e:	00002097          	auipc	ra,0x2
    80003892:	156080e7          	jalr	342(ra) # 800059e4 <bd_malloc>
    80003896:	84aa                	mv	s1,a0
  if (new_file == 0) {
    80003898:	c505                	beqz	a0,800038c0 <filealloc+0x40>
    return 0;
  }
  memset(new_file, 0, sizeof(struct file));
    8000389a:	04000613          	li	a2,64
    8000389e:	4581                	li	a1,0
    800038a0:	ffffc097          	auipc	ra,0xffffc
    800038a4:	7d6080e7          	jalr	2006(ra) # 80000076 <memset>
  initlock(&new_file->lock, "file");
    800038a8:	00005597          	auipc	a1,0x5
    800038ac:	c9058593          	addi	a1,a1,-880 # 80008538 <etext+0x538>
    800038b0:	00848513          	addi	a0,s1,8
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	57a080e7          	jalr	1402(ra) # 80006e2e <initlock>
  new_file->ref = 1;
    800038bc:	4785                	li	a5,1
    800038be:	d09c                	sw	a5,32(s1)
  return new_file;
}
    800038c0:	8526                	mv	a0,s1
    800038c2:	60e2                	ld	ra,24(sp)
    800038c4:	6442                	ld	s0,16(sp)
    800038c6:	64a2                	ld	s1,8(sp)
    800038c8:	6105                	addi	sp,sp,32
    800038ca:	8082                	ret

00000000800038cc <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	e426                	sd	s1,8(sp)
    800038d4:	e04a                	sd	s2,0(sp)
    800038d6:	1000                	addi	s0,sp,32
    800038d8:	84aa                	mv	s1,a0
  acquire(&f->lock);
    800038da:	00850913          	addi	s2,a0,8
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	5de080e7          	jalr	1502(ra) # 80006ebe <acquire>
  if (f == 0) {
    800038e8:	c899                	beqz	s1,800038fe <filedup+0x32>
    return 0;
  }
  if (f->ref < 1) panic("filedup");
    800038ea:	509c                	lw	a5,32(s1)
    800038ec:	02f05063          	blez	a5,8000390c <filedup+0x40>
  f->ref++;
    800038f0:	2785                	addiw	a5,a5,1
    800038f2:	d09c                	sw	a5,32(s1)
  release(&f->lock);
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	67c080e7          	jalr	1660(ra) # 80006f72 <release>
  return f;
}
    800038fe:	8526                	mv	a0,s1
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret
  if (f->ref < 1) panic("filedup");
    8000390c:	00005517          	auipc	a0,0x5
    80003910:	c3450513          	addi	a0,a0,-972 # 80008540 <etext+0x540>
    80003914:	00003097          	auipc	ra,0x3
    80003918:	030080e7          	jalr	48(ra) # 80006944 <panic>

000000008000391c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
  if (f == 0) {
    8000391c:	c545                	beqz	a0,800039c4 <fileclose+0xa8>
void fileclose(struct file *f) {
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	e426                	sd	s1,8(sp)
    80003926:	e04a                	sd	s2,0(sp)
    80003928:	1000                	addi	s0,sp,32
    8000392a:	84aa                	mv	s1,a0
    return;
  }
  acquire(&f->lock);
    8000392c:	00850913          	addi	s2,a0,8
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	58c080e7          	jalr	1420(ra) # 80006ebe <acquire>
  if (f->ref < 1) panic("fileclose");
    8000393a:	509c                	lw	a5,32(s1)
    8000393c:	04f05063          	blez	a5,8000397c <fileclose+0x60>
  if (--f->ref > 0) {
    80003940:	37fd                	addiw	a5,a5,-1
    80003942:	0007871b          	sext.w	a4,a5
    80003946:	d09c                	sw	a5,32(s1)
    80003948:	04e04263          	bgtz	a4,8000398c <fileclose+0x70>
    release(&f->lock);
    return;
  }
  release(&f->lock);
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	624080e7          	jalr	1572(ra) # 80006f72 <release>
  if (f->type == FD_PIPE) {
    80003956:	409c                	lw	a5,0(s1)
    80003958:	4705                	li	a4,1
    8000395a:	02e78f63          	beq	a5,a4,80003998 <fileclose+0x7c>
    pipeclose(f->pipe, f->writable);
  } else if (f->type == FD_INODE || f->type == FD_DEVICE) {
    8000395e:	37f9                	addiw	a5,a5,-2
    80003960:	4705                	li	a4,1
    80003962:	04f77363          	bgeu	a4,a5,800039a8 <fileclose+0x8c>
    begin_op();
    iput(f->ip);
    end_op();
  }
  bd_free(f);
    80003966:	8526                	mv	a0,s1
    80003968:	00002097          	auipc	ra,0x2
    8000396c:	28c080e7          	jalr	652(ra) # 80005bf4 <bd_free>
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret
  if (f->ref < 1) panic("fileclose");
    8000397c:	00005517          	auipc	a0,0x5
    80003980:	bcc50513          	addi	a0,a0,-1076 # 80008548 <etext+0x548>
    80003984:	00003097          	auipc	ra,0x3
    80003988:	fc0080e7          	jalr	-64(ra) # 80006944 <panic>
    release(&f->lock);
    8000398c:	854a                	mv	a0,s2
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	5e4080e7          	jalr	1508(ra) # 80006f72 <release>
    return;
    80003996:	bfe9                	j	80003970 <fileclose+0x54>
    pipeclose(f->pipe, f->writable);
    80003998:	0254c583          	lbu	a1,37(s1)
    8000399c:	7488                	ld	a0,40(s1)
    8000399e:	00000097          	auipc	ra,0x0
    800039a2:	3a0080e7          	jalr	928(ra) # 80003d3e <pipeclose>
    800039a6:	b7c1                	j	80003966 <fileclose+0x4a>
    begin_op();
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	ae6080e7          	jalr	-1306(ra) # 8000348e <begin_op>
    iput(f->ip);
    800039b0:	7888                	ld	a0,48(s1)
    800039b2:	fffff097          	auipc	ra,0xfffff
    800039b6:	2cc080e7          	jalr	716(ra) # 80002c7e <iput>
    end_op();
    800039ba:	00000097          	auipc	ra,0x0
    800039be:	b4e080e7          	jalr	-1202(ra) # 80003508 <end_op>
    800039c2:	b755                	j	80003966 <fileclose+0x4a>
    800039c4:	8082                	ret

00000000800039c6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
  if (f == 0) {
    800039c6:	c925                	beqz	a0,80003a36 <filestat+0x70>
int filestat(struct file *f, uint64 addr) {
    800039c8:	715d                	addi	sp,sp,-80
    800039ca:	e486                	sd	ra,72(sp)
    800039cc:	e0a2                	sd	s0,64(sp)
    800039ce:	fc26                	sd	s1,56(sp)
    800039d0:	f84a                	sd	s2,48(sp)
    800039d2:	f44e                	sd	s3,40(sp)
    800039d4:	0880                	addi	s0,sp,80
    800039d6:	84aa                	mv	s1,a0
    800039d8:	892e                	mv	s2,a1
    return -1;
  }

  struct proc *p = myproc();
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	428080e7          	jalr	1064(ra) # 80000e02 <myproc>
    800039e2:	89aa                	mv	s3,a0
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	37f9                	addiw	a5,a5,-2
    800039e8:	4705                	li	a4,1
    800039ea:	04f76863          	bltu	a4,a5,80003a3a <filestat+0x74>
    ilock(f->ip);
    800039ee:	7888                	ld	a0,48(s1)
    800039f0:	fffff097          	auipc	ra,0xfffff
    800039f4:	0d0080e7          	jalr	208(ra) # 80002ac0 <ilock>
    stati(f->ip, &st);
    800039f8:	fb840593          	addi	a1,s0,-72
    800039fc:	7888                	ld	a0,48(s1)
    800039fe:	fffff097          	auipc	ra,0xfffff
    80003a02:	350080e7          	jalr	848(ra) # 80002d4e <stati>
    iunlock(f->ip);
    80003a06:	7888                	ld	a0,48(s1)
    80003a08:	fffff097          	auipc	ra,0xfffff
    80003a0c:	17e080e7          	jalr	382(ra) # 80002b86 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003a10:	46e1                	li	a3,24
    80003a12:	fb840613          	addi	a2,s0,-72
    80003a16:	85ca                	mv	a1,s2
    80003a18:	0509b503          	ld	a0,80(s3)
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	02c080e7          	jalr	44(ra) # 80000a48 <copyout>
    80003a24:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003a28:	60a6                	ld	ra,72(sp)
    80003a2a:	6406                	ld	s0,64(sp)
    80003a2c:	74e2                	ld	s1,56(sp)
    80003a2e:	7942                	ld	s2,48(sp)
    80003a30:	79a2                	ld	s3,40(sp)
    80003a32:	6161                	addi	sp,sp,80
    80003a34:	8082                	ret
    return -1;
    80003a36:	557d                	li	a0,-1
}
    80003a38:	8082                	ret
  return -1;
    80003a3a:	557d                	li	a0,-1
    80003a3c:	b7f5                	j	80003a28 <filestat+0x62>

0000000080003a3e <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003a3e:	7179                	addi	sp,sp,-48
    80003a40:	f406                	sd	ra,40(sp)
    80003a42:	f022                	sd	s0,32(sp)
    80003a44:	e84a                	sd	s2,16(sp)
    80003a46:	1800                	addi	s0,sp,48
  if (f == 0) {
    80003a48:	c95d                	beqz	a0,80003afe <fileread+0xc0>
    80003a4a:	ec26                	sd	s1,24(sp)
    80003a4c:	e44e                	sd	s3,8(sp)
    80003a4e:	84aa                	mv	s1,a0
    80003a50:	89ae                	mv	s3,a1
    80003a52:	8932                	mv	s2,a2
    return 0;
  }

  int r = 0;

  if (f->readable == 0) return -1;
    80003a54:	02454783          	lbu	a5,36(a0)
    80003a58:	c7cd                	beqz	a5,80003b02 <fileread+0xc4>

  if (f->type == FD_PIPE) {
    80003a5a:	411c                	lw	a5,0(a0)
    80003a5c:	4705                	li	a4,1
    80003a5e:	04e78963          	beq	a5,a4,80003ab0 <fileread+0x72>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003a62:	470d                	li	a4,3
    80003a64:	04e78f63          	beq	a5,a4,80003ac2 <fileread+0x84>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003a68:	4709                	li	a4,2
    80003a6a:	08e79263          	bne	a5,a4,80003aee <fileread+0xb0>
    ilock(f->ip);
    80003a6e:	7908                	ld	a0,48(a0)
    80003a70:	fffff097          	auipc	ra,0xfffff
    80003a74:	050080e7          	jalr	80(ra) # 80002ac0 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003a78:	874a                	mv	a4,s2
    80003a7a:	5c94                	lw	a3,56(s1)
    80003a7c:	864e                	mv	a2,s3
    80003a7e:	4585                	li	a1,1
    80003a80:	7888                	ld	a0,48(s1)
    80003a82:	fffff097          	auipc	ra,0xfffff
    80003a86:	2f6080e7          	jalr	758(ra) # 80002d78 <readi>
    80003a8a:	892a                	mv	s2,a0
    80003a8c:	00a05563          	blez	a0,80003a96 <fileread+0x58>
    80003a90:	5c9c                	lw	a5,56(s1)
    80003a92:	9fa9                	addw	a5,a5,a0
    80003a94:	dc9c                	sw	a5,56(s1)
    iunlock(f->ip);
    80003a96:	7888                	ld	a0,48(s1)
    80003a98:	fffff097          	auipc	ra,0xfffff
    80003a9c:	0ee080e7          	jalr	238(ra) # 80002b86 <iunlock>
    80003aa0:	64e2                	ld	s1,24(sp)
    80003aa2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }
  return r;
}
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	70a2                	ld	ra,40(sp)
    80003aa8:	7402                	ld	s0,32(sp)
    80003aaa:	6942                	ld	s2,16(sp)
    80003aac:	6145                	addi	sp,sp,48
    80003aae:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ab0:	7508                	ld	a0,40(a0)
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	404080e7          	jalr	1028(ra) # 80003eb6 <piperead>
    80003aba:	892a                	mv	s2,a0
    80003abc:	64e2                	ld	s1,24(sp)
    80003abe:	69a2                	ld	s3,8(sp)
    80003ac0:	b7d5                	j	80003aa4 <fileread+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003ac2:	03c51783          	lh	a5,60(a0)
    80003ac6:	03079693          	slli	a3,a5,0x30
    80003aca:	92c1                	srli	a3,a3,0x30
    80003acc:	4725                	li	a4,9
    80003ace:	02d76e63          	bltu	a4,a3,80003b0a <fileread+0xcc>
    80003ad2:	0792                	slli	a5,a5,0x4
    80003ad4:	00018717          	auipc	a4,0x18
    80003ad8:	e8470713          	addi	a4,a4,-380 # 8001b958 <devsw>
    80003adc:	97ba                	add	a5,a5,a4
    80003ade:	639c                	ld	a5,0(a5)
    80003ae0:	cb8d                	beqz	a5,80003b12 <fileread+0xd4>
    r = devsw[f->major].read(1, addr, n);
    80003ae2:	4505                	li	a0,1
    80003ae4:	9782                	jalr	a5
    80003ae6:	892a                	mv	s2,a0
    80003ae8:	64e2                	ld	s1,24(sp)
    80003aea:	69a2                	ld	s3,8(sp)
    80003aec:	bf65                	j	80003aa4 <fileread+0x66>
    panic("fileread");
    80003aee:	00005517          	auipc	a0,0x5
    80003af2:	a6a50513          	addi	a0,a0,-1430 # 80008558 <etext+0x558>
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	e4e080e7          	jalr	-434(ra) # 80006944 <panic>
    return 0;
    80003afe:	4901                	li	s2,0
    80003b00:	b755                	j	80003aa4 <fileread+0x66>
  if (f->readable == 0) return -1;
    80003b02:	597d                	li	s2,-1
    80003b04:	64e2                	ld	s1,24(sp)
    80003b06:	69a2                	ld	s3,8(sp)
    80003b08:	bf71                	j	80003aa4 <fileread+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003b0a:	597d                	li	s2,-1
    80003b0c:	64e2                	ld	s1,24(sp)
    80003b0e:	69a2                	ld	s3,8(sp)
    80003b10:	bf51                	j	80003aa4 <fileread+0x66>
    80003b12:	597d                	li	s2,-1
    80003b14:	64e2                	ld	s1,24(sp)
    80003b16:	69a2                	ld	s3,8(sp)
    80003b18:	b771                	j	80003aa4 <fileread+0x66>

0000000080003b1a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
  if (f == 0) {
    80003b1a:	12050763          	beqz	a0,80003c48 <filewrite+0x12e>
int filewrite(struct file *f, uint64 addr, int n) {
    80003b1e:	715d                	addi	sp,sp,-80
    80003b20:	e486                	sd	ra,72(sp)
    80003b22:	e0a2                	sd	s0,64(sp)
    80003b24:	fc26                	sd	s1,56(sp)
    80003b26:	f052                	sd	s4,32(sp)
    80003b28:	e85a                	sd	s6,16(sp)
    80003b2a:	0880                	addi	s0,sp,80
    80003b2c:	84aa                	mv	s1,a0
    80003b2e:	8b2e                	mv	s6,a1
    80003b30:	8a32                	mv	s4,a2
    return -1;
  }

  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003b32:	02554783          	lbu	a5,37(a0)
    80003b36:	10078b63          	beqz	a5,80003c4c <filewrite+0x132>

  if (f->type == FD_PIPE) {
    80003b3a:	411c                	lw	a5,0(a0)
    80003b3c:	4705                	li	a4,1
    80003b3e:	02e78763          	beq	a5,a4,80003b6c <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003b42:	470d                	li	a4,3
    80003b44:	02e78a63          	beq	a5,a4,80003b78 <filewrite+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) {
      return -1;
    }
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003b48:	4709                	li	a4,2
    80003b4a:	0ee79263          	bne	a5,a4,80003c2e <filewrite+0x114>
    80003b4e:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003b50:	0ac05e63          	blez	a2,80003c0c <filewrite+0xf2>
    80003b54:	f84a                	sd	s2,48(sp)
    80003b56:	ec56                	sd	s5,24(sp)
    80003b58:	e45e                	sd	s7,8(sp)
    80003b5a:	e062                	sd	s8,0(sp)
    int i = 0;
    80003b5c:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max) n1 = max;
    80003b5e:	6b85                	lui	s7,0x1
    80003b60:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003b64:	6c05                	lui	s8,0x1
    80003b66:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003b6a:	a061                	j	80003bf2 <filewrite+0xd8>
    ret = pipewrite(f->pipe, addr, n);
    80003b6c:	7508                	ld	a0,40(a0)
    80003b6e:	00000097          	auipc	ra,0x0
    80003b72:	240080e7          	jalr	576(ra) # 80003dae <pipewrite>
    80003b76:	a06d                	j	80003c20 <filewrite+0x106>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) {
    80003b78:	03c51783          	lh	a5,60(a0)
    80003b7c:	03079693          	slli	a3,a5,0x30
    80003b80:	92c1                	srli	a3,a3,0x30
    80003b82:	4725                	li	a4,9
    80003b84:	0cd76663          	bltu	a4,a3,80003c50 <filewrite+0x136>
    80003b88:	0792                	slli	a5,a5,0x4
    80003b8a:	00018717          	auipc	a4,0x18
    80003b8e:	dce70713          	addi	a4,a4,-562 # 8001b958 <devsw>
    80003b92:	97ba                	add	a5,a5,a4
    80003b94:	679c                	ld	a5,8(a5)
    80003b96:	cfdd                	beqz	a5,80003c54 <filewrite+0x13a>
    ret = devsw[f->major].write(1, addr, n);
    80003b98:	4505                	li	a0,1
    80003b9a:	9782                	jalr	a5
    80003b9c:	a051                	j	80003c20 <filewrite+0x106>
      if (n1 > max) n1 = max;
    80003b9e:	00090a9b          	sext.w	s5,s2
      begin_op();
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	8ec080e7          	jalr	-1812(ra) # 8000348e <begin_op>
      ilock(f->ip);
    80003baa:	7888                	ld	a0,48(s1)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	f14080e7          	jalr	-236(ra) # 80002ac0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003bb4:	8756                	mv	a4,s5
    80003bb6:	5c94                	lw	a3,56(s1)
    80003bb8:	01698633          	add	a2,s3,s6
    80003bbc:	4585                	li	a1,1
    80003bbe:	7888                	ld	a0,48(s1)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	2c8080e7          	jalr	712(ra) # 80002e88 <writei>
    80003bc8:	892a                	mv	s2,a0
    80003bca:	00a05563          	blez	a0,80003bd4 <filewrite+0xba>
    80003bce:	5c9c                	lw	a5,56(s1)
    80003bd0:	9fa9                	addw	a5,a5,a0
    80003bd2:	dc9c                	sw	a5,56(s1)
      iunlock(f->ip);
    80003bd4:	7888                	ld	a0,48(s1)
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	fb0080e7          	jalr	-80(ra) # 80002b86 <iunlock>
      end_op();
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	92a080e7          	jalr	-1750(ra) # 80003508 <end_op>

      if (r != n1) {
    80003be6:	032a9563          	bne	s5,s2,80003c10 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003bea:	013909bb          	addw	s3,s2,s3
    while (i < n) {
    80003bee:	0149da63          	bge	s3,s4,80003c02 <filewrite+0xe8>
      int n1 = n - i;
    80003bf2:	413a093b          	subw	s2,s4,s3
      if (n1 > max) n1 = max;
    80003bf6:	0009079b          	sext.w	a5,s2
    80003bfa:	fafbd2e3          	bge	s7,a5,80003b9e <filewrite+0x84>
    80003bfe:	8962                	mv	s2,s8
    80003c00:	bf79                	j	80003b9e <filewrite+0x84>
    80003c02:	7942                	ld	s2,48(sp)
    80003c04:	6ae2                	ld	s5,24(sp)
    80003c06:	6ba2                	ld	s7,8(sp)
    80003c08:	6c02                	ld	s8,0(sp)
    80003c0a:	a039                	j	80003c18 <filewrite+0xfe>
    int i = 0;
    80003c0c:	4981                	li	s3,0
    80003c0e:	a029                	j	80003c18 <filewrite+0xfe>
    80003c10:	7942                	ld	s2,48(sp)
    80003c12:	6ae2                	ld	s5,24(sp)
    80003c14:	6ba2                	ld	s7,8(sp)
    80003c16:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003c18:	053a1063          	bne	s4,s3,80003c58 <filewrite+0x13e>
    80003c1c:	8552                	mv	a0,s4
    80003c1e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }
  return ret;
}
    80003c20:	60a6                	ld	ra,72(sp)
    80003c22:	6406                	ld	s0,64(sp)
    80003c24:	74e2                	ld	s1,56(sp)
    80003c26:	7a02                	ld	s4,32(sp)
    80003c28:	6b42                	ld	s6,16(sp)
    80003c2a:	6161                	addi	sp,sp,80
    80003c2c:	8082                	ret
    80003c2e:	f84a                	sd	s2,48(sp)
    80003c30:	f44e                	sd	s3,40(sp)
    80003c32:	ec56                	sd	s5,24(sp)
    80003c34:	e45e                	sd	s7,8(sp)
    80003c36:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	93050513          	addi	a0,a0,-1744 # 80008568 <etext+0x568>
    80003c40:	00003097          	auipc	ra,0x3
    80003c44:	d04080e7          	jalr	-764(ra) # 80006944 <panic>
    return -1;
    80003c48:	557d                	li	a0,-1
}
    80003c4a:	8082                	ret
  if (f->writable == 0) return -1;
    80003c4c:	557d                	li	a0,-1
    80003c4e:	bfc9                	j	80003c20 <filewrite+0x106>
      return -1;
    80003c50:	557d                	li	a0,-1
    80003c52:	b7f9                	j	80003c20 <filewrite+0x106>
    80003c54:	557d                	li	a0,-1
    80003c56:	b7e9                	j	80003c20 <filewrite+0x106>
    ret = (i == n ? n : -1);
    80003c58:	557d                	li	a0,-1
    80003c5a:	79a2                	ld	s3,40(sp)
    80003c5c:	b7d1                	j	80003c20 <filewrite+0x106>

0000000080003c5e <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003c5e:	7179                	addi	sp,sp,-48
    80003c60:	f406                	sd	ra,40(sp)
    80003c62:	f022                	sd	s0,32(sp)
    80003c64:	ec26                	sd	s1,24(sp)
    80003c66:	e052                	sd	s4,0(sp)
    80003c68:	1800                	addi	s0,sp,48
    80003c6a:	84aa                	mv	s1,a0
    80003c6c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c6e:	0005b023          	sd	zero,0(a1)
    80003c72:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003c76:	00000097          	auipc	ra,0x0
    80003c7a:	c0a080e7          	jalr	-1014(ra) # 80003880 <filealloc>
    80003c7e:	e088                	sd	a0,0(s1)
    80003c80:	cd49                	beqz	a0,80003d1a <pipealloc+0xbc>
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	bfe080e7          	jalr	-1026(ra) # 80003880 <filealloc>
    80003c8a:	00aa3023          	sd	a0,0(s4)
    80003c8e:	c141                	beqz	a0,80003d0e <pipealloc+0xb0>
    80003c90:	e84a                	sd	s2,16(sp)
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003c92:	ffffc097          	auipc	ra,0xffffc
    80003c96:	3ca080e7          	jalr	970(ra) # 8000005c <kalloc>
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	c13d                	beqz	a0,80003d02 <pipealloc+0xa4>
    80003c9e:	e44e                	sd	s3,8(sp)
  pi->readopen = 1;
    80003ca0:	4985                	li	s3,1
    80003ca2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ca6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003caa:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cae:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cb2:	00005597          	auipc	a1,0x5
    80003cb6:	8c658593          	addi	a1,a1,-1850 # 80008578 <etext+0x578>
    80003cba:	00003097          	auipc	ra,0x3
    80003cbe:	174080e7          	jalr	372(ra) # 80006e2e <initlock>
  (*f0)->type = FD_PIPE;
    80003cc2:	609c                	ld	a5,0(s1)
    80003cc4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003cc8:	609c                	ld	a5,0(s1)
    80003cca:	03378223          	sb	s3,36(a5)
  (*f0)->writable = 0;
    80003cce:	609c                	ld	a5,0(s1)
    80003cd0:	020782a3          	sb	zero,37(a5)
  (*f0)->pipe = pi;
    80003cd4:	609c                	ld	a5,0(s1)
    80003cd6:	0327b423          	sd	s2,40(a5)
  (*f1)->type = FD_PIPE;
    80003cda:	000a3783          	ld	a5,0(s4)
    80003cde:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ce2:	000a3783          	ld	a5,0(s4)
    80003ce6:	02078223          	sb	zero,36(a5)
  (*f1)->writable = 1;
    80003cea:	000a3783          	ld	a5,0(s4)
    80003cee:	033782a3          	sb	s3,37(a5)
  (*f1)->pipe = pi;
    80003cf2:	000a3783          	ld	a5,0(s4)
    80003cf6:	0327b423          	sd	s2,40(a5)
  return 0;
    80003cfa:	4501                	li	a0,0
    80003cfc:	6942                	ld	s2,16(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	a03d                	j	80003d2e <pipealloc+0xd0>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003d02:	6088                	ld	a0,0(s1)
    80003d04:	c119                	beqz	a0,80003d0a <pipealloc+0xac>
    80003d06:	6942                	ld	s2,16(sp)
    80003d08:	a029                	j	80003d12 <pipealloc+0xb4>
    80003d0a:	6942                	ld	s2,16(sp)
    80003d0c:	a039                	j	80003d1a <pipealloc+0xbc>
    80003d0e:	6088                	ld	a0,0(s1)
    80003d10:	c50d                	beqz	a0,80003d3a <pipealloc+0xdc>
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	c0a080e7          	jalr	-1014(ra) # 8000391c <fileclose>
  if (*f1) fileclose(*f1);
    80003d1a:	000a3783          	ld	a5,0(s4)
  return -1;
    80003d1e:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003d20:	c799                	beqz	a5,80003d2e <pipealloc+0xd0>
    80003d22:	853e                	mv	a0,a5
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	bf8080e7          	jalr	-1032(ra) # 8000391c <fileclose>
  return -1;
    80003d2c:	557d                	li	a0,-1
}
    80003d2e:	70a2                	ld	ra,40(sp)
    80003d30:	7402                	ld	s0,32(sp)
    80003d32:	64e2                	ld	s1,24(sp)
    80003d34:	6a02                	ld	s4,0(sp)
    80003d36:	6145                	addi	sp,sp,48
    80003d38:	8082                	ret
  return -1;
    80003d3a:	557d                	li	a0,-1
    80003d3c:	bfcd                	j	80003d2e <pipealloc+0xd0>

0000000080003d3e <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003d3e:	1101                	addi	sp,sp,-32
    80003d40:	ec06                	sd	ra,24(sp)
    80003d42:	e822                	sd	s0,16(sp)
    80003d44:	e426                	sd	s1,8(sp)
    80003d46:	e04a                	sd	s2,0(sp)
    80003d48:	1000                	addi	s0,sp,32
    80003d4a:	84aa                	mv	s1,a0
    80003d4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d4e:	00003097          	auipc	ra,0x3
    80003d52:	170080e7          	jalr	368(ra) # 80006ebe <acquire>
  if (writable) {
    80003d56:	02090d63          	beqz	s2,80003d90 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d5a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d5e:	21848513          	addi	a0,s1,536
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	7b2080e7          	jalr	1970(ra) # 80001514 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003d6a:	2204b783          	ld	a5,544(s1)
    80003d6e:	eb95                	bnez	a5,80003da2 <pipeclose+0x64>
    release(&pi->lock);
    80003d70:	8526                	mv	a0,s1
    80003d72:	00003097          	auipc	ra,0x3
    80003d76:	200080e7          	jalr	512(ra) # 80006f72 <release>
    kfree((char *)pi);
    80003d7a:	8526                	mv	a0,s1
    80003d7c:	ffffc097          	auipc	ra,0xffffc
    80003d80:	2c8080e7          	jalr	712(ra) # 80000044 <kfree>
  } else
    release(&pi->lock);
}
    80003d84:	60e2                	ld	ra,24(sp)
    80003d86:	6442                	ld	s0,16(sp)
    80003d88:	64a2                	ld	s1,8(sp)
    80003d8a:	6902                	ld	s2,0(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret
    pi->readopen = 0;
    80003d90:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d94:	21c48513          	addi	a0,s1,540
    80003d98:	ffffd097          	auipc	ra,0xffffd
    80003d9c:	77c080e7          	jalr	1916(ra) # 80001514 <wakeup>
    80003da0:	b7e9                	j	80003d6a <pipeclose+0x2c>
    release(&pi->lock);
    80003da2:	8526                	mv	a0,s1
    80003da4:	00003097          	auipc	ra,0x3
    80003da8:	1ce080e7          	jalr	462(ra) # 80006f72 <release>
}
    80003dac:	bfe1                	j	80003d84 <pipeclose+0x46>

0000000080003dae <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003dae:	711d                	addi	sp,sp,-96
    80003db0:	ec86                	sd	ra,88(sp)
    80003db2:	e8a2                	sd	s0,80(sp)
    80003db4:	e4a6                	sd	s1,72(sp)
    80003db6:	e0ca                	sd	s2,64(sp)
    80003db8:	fc4e                	sd	s3,56(sp)
    80003dba:	f852                	sd	s4,48(sp)
    80003dbc:	f456                	sd	s5,40(sp)
    80003dbe:	1080                	addi	s0,sp,96
    80003dc0:	84aa                	mv	s1,a0
    80003dc2:	8aae                	mv	s5,a1
    80003dc4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003dc6:	ffffd097          	auipc	ra,0xffffd
    80003dca:	03c080e7          	jalr	60(ra) # 80000e02 <myproc>
    80003dce:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003dd0:	8526                	mv	a0,s1
    80003dd2:	00003097          	auipc	ra,0x3
    80003dd6:	0ec080e7          	jalr	236(ra) # 80006ebe <acquire>
  while (i < n) {
    80003dda:	0d405863          	blez	s4,80003eaa <pipewrite+0xfc>
    80003dde:	f05a                	sd	s6,32(sp)
    80003de0:	ec5e                	sd	s7,24(sp)
    80003de2:	e862                	sd	s8,16(sp)
  int i = 0;
    80003de4:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003de6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003de8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003dec:	21c48b93          	addi	s7,s1,540
    80003df0:	a089                	j	80003e32 <pipewrite+0x84>
      release(&pi->lock);
    80003df2:	8526                	mv	a0,s1
    80003df4:	00003097          	auipc	ra,0x3
    80003df8:	17e080e7          	jalr	382(ra) # 80006f72 <release>
      return -1;
    80003dfc:	597d                	li	s2,-1
    80003dfe:	7b02                	ld	s6,32(sp)
    80003e00:	6be2                	ld	s7,24(sp)
    80003e02:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e04:	854a                	mv	a0,s2
    80003e06:	60e6                	ld	ra,88(sp)
    80003e08:	6446                	ld	s0,80(sp)
    80003e0a:	64a6                	ld	s1,72(sp)
    80003e0c:	6906                	ld	s2,64(sp)
    80003e0e:	79e2                	ld	s3,56(sp)
    80003e10:	7a42                	ld	s4,48(sp)
    80003e12:	7aa2                	ld	s5,40(sp)
    80003e14:	6125                	addi	sp,sp,96
    80003e16:	8082                	ret
      wakeup(&pi->nread);
    80003e18:	8562                	mv	a0,s8
    80003e1a:	ffffd097          	auipc	ra,0xffffd
    80003e1e:	6fa080e7          	jalr	1786(ra) # 80001514 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e22:	85a6                	mv	a1,s1
    80003e24:	855e                	mv	a0,s7
    80003e26:	ffffd097          	auipc	ra,0xffffd
    80003e2a:	68a080e7          	jalr	1674(ra) # 800014b0 <sleep>
  while (i < n) {
    80003e2e:	05495f63          	bge	s2,s4,80003e8c <pipewrite+0xde>
    if (pi->readopen == 0 || killed(pr)) {
    80003e32:	2204a783          	lw	a5,544(s1)
    80003e36:	dfd5                	beqz	a5,80003df2 <pipewrite+0x44>
    80003e38:	854e                	mv	a0,s3
    80003e3a:	ffffe097          	auipc	ra,0xffffe
    80003e3e:	91e080e7          	jalr	-1762(ra) # 80001758 <killed>
    80003e42:	f945                	bnez	a0,80003df2 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80003e44:	2184a783          	lw	a5,536(s1)
    80003e48:	21c4a703          	lw	a4,540(s1)
    80003e4c:	2007879b          	addiw	a5,a5,512
    80003e50:	fcf704e3          	beq	a4,a5,80003e18 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003e54:	4685                	li	a3,1
    80003e56:	01590633          	add	a2,s2,s5
    80003e5a:	faf40593          	addi	a1,s0,-81
    80003e5e:	0509b503          	ld	a0,80(s3)
    80003e62:	ffffd097          	auipc	ra,0xffffd
    80003e66:	cc4080e7          	jalr	-828(ra) # 80000b26 <copyin>
    80003e6a:	05650263          	beq	a0,s6,80003eae <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e6e:	21c4a783          	lw	a5,540(s1)
    80003e72:	0017871b          	addiw	a4,a5,1
    80003e76:	20e4ae23          	sw	a4,540(s1)
    80003e7a:	1ff7f793          	andi	a5,a5,511
    80003e7e:	97a6                	add	a5,a5,s1
    80003e80:	faf44703          	lbu	a4,-81(s0)
    80003e84:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e88:	2905                	addiw	s2,s2,1
    80003e8a:	b755                	j	80003e2e <pipewrite+0x80>
    80003e8c:	7b02                	ld	s6,32(sp)
    80003e8e:	6be2                	ld	s7,24(sp)
    80003e90:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003e92:	21848513          	addi	a0,s1,536
    80003e96:	ffffd097          	auipc	ra,0xffffd
    80003e9a:	67e080e7          	jalr	1662(ra) # 80001514 <wakeup>
  release(&pi->lock);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	00003097          	auipc	ra,0x3
    80003ea4:	0d2080e7          	jalr	210(ra) # 80006f72 <release>
  return i;
    80003ea8:	bfb1                	j	80003e04 <pipewrite+0x56>
  int i = 0;
    80003eaa:	4901                	li	s2,0
    80003eac:	b7dd                	j	80003e92 <pipewrite+0xe4>
    80003eae:	7b02                	ld	s6,32(sp)
    80003eb0:	6be2                	ld	s7,24(sp)
    80003eb2:	6c42                	ld	s8,16(sp)
    80003eb4:	bff9                	j	80003e92 <pipewrite+0xe4>

0000000080003eb6 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80003eb6:	715d                	addi	sp,sp,-80
    80003eb8:	e486                	sd	ra,72(sp)
    80003eba:	e0a2                	sd	s0,64(sp)
    80003ebc:	fc26                	sd	s1,56(sp)
    80003ebe:	f84a                	sd	s2,48(sp)
    80003ec0:	f44e                	sd	s3,40(sp)
    80003ec2:	f052                	sd	s4,32(sp)
    80003ec4:	ec56                	sd	s5,24(sp)
    80003ec6:	0880                	addi	s0,sp,80
    80003ec8:	84aa                	mv	s1,a0
    80003eca:	892e                	mv	s2,a1
    80003ecc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	f34080e7          	jalr	-204(ra) # 80000e02 <myproc>
    80003ed6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	00003097          	auipc	ra,0x3
    80003ede:	fe4080e7          	jalr	-28(ra) # 80006ebe <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003ee2:	2184a703          	lw	a4,536(s1)
    80003ee6:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003eea:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003eee:	02f71963          	bne	a4,a5,80003f20 <piperead+0x6a>
    80003ef2:	2244a783          	lw	a5,548(s1)
    80003ef6:	cf95                	beqz	a5,80003f32 <piperead+0x7c>
    if (killed(pr)) {
    80003ef8:	8552                	mv	a0,s4
    80003efa:	ffffe097          	auipc	ra,0xffffe
    80003efe:	85e080e7          	jalr	-1954(ra) # 80001758 <killed>
    80003f02:	e10d                	bnez	a0,80003f24 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003f04:	85a6                	mv	a1,s1
    80003f06:	854e                	mv	a0,s3
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	5a8080e7          	jalr	1448(ra) # 800014b0 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003f10:	2184a703          	lw	a4,536(s1)
    80003f14:	21c4a783          	lw	a5,540(s1)
    80003f18:	fcf70de3          	beq	a4,a5,80003ef2 <piperead+0x3c>
    80003f1c:	e85a                	sd	s6,16(sp)
    80003f1e:	a819                	j	80003f34 <piperead+0x7e>
    80003f20:	e85a                	sd	s6,16(sp)
    80003f22:	a809                	j	80003f34 <piperead+0x7e>
      release(&pi->lock);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00003097          	auipc	ra,0x3
    80003f2a:	04c080e7          	jalr	76(ra) # 80006f72 <release>
      return -1;
    80003f2e:	59fd                	li	s3,-1
    80003f30:	a0a5                	j	80003f98 <piperead+0xe2>
    80003f32:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003f34:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80003f36:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003f38:	05505463          	blez	s5,80003f80 <piperead+0xca>
    if (pi->nread == pi->nwrite) break;
    80003f3c:	2184a783          	lw	a5,536(s1)
    80003f40:	21c4a703          	lw	a4,540(s1)
    80003f44:	02f70e63          	beq	a4,a5,80003f80 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f48:	0017871b          	addiw	a4,a5,1
    80003f4c:	20e4ac23          	sw	a4,536(s1)
    80003f50:	1ff7f793          	andi	a5,a5,511
    80003f54:	97a6                	add	a5,a5,s1
    80003f56:	0187c783          	lbu	a5,24(a5)
    80003f5a:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80003f5e:	4685                	li	a3,1
    80003f60:	fbf40613          	addi	a2,s0,-65
    80003f64:	85ca                	mv	a1,s2
    80003f66:	050a3503          	ld	a0,80(s4)
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	ade080e7          	jalr	-1314(ra) # 80000a48 <copyout>
    80003f72:	01650763          	beq	a0,s6,80003f80 <piperead+0xca>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003f76:	2985                	addiw	s3,s3,1
    80003f78:	0905                	addi	s2,s2,1
    80003f7a:	fd3a91e3          	bne	s5,s3,80003f3c <piperead+0x86>
    80003f7e:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    80003f80:	21c48513          	addi	a0,s1,540
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	590080e7          	jalr	1424(ra) # 80001514 <wakeup>
  release(&pi->lock);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	00003097          	auipc	ra,0x3
    80003f92:	fe4080e7          	jalr	-28(ra) # 80006f72 <release>
    80003f96:	6b42                	ld	s6,16(sp)
  return i;
}
    80003f98:	854e                	mv	a0,s3
    80003f9a:	60a6                	ld	ra,72(sp)
    80003f9c:	6406                	ld	s0,64(sp)
    80003f9e:	74e2                	ld	s1,56(sp)
    80003fa0:	7942                	ld	s2,48(sp)
    80003fa2:	79a2                	ld	s3,40(sp)
    80003fa4:	7a02                	ld	s4,32(sp)
    80003fa6:	6ae2                	ld	s5,24(sp)
    80003fa8:	6161                	addi	sp,sp,80
    80003faa:	8082                	ret

0000000080003fac <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80003fac:	1141                	addi	sp,sp,-16
    80003fae:	e422                	sd	s0,8(sp)
    80003fb0:	0800                	addi	s0,sp,16
    80003fb2:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80003fb4:	8905                	andi	a0,a0,1
    80003fb6:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80003fb8:	8b89                	andi	a5,a5,2
    80003fba:	c399                	beqz	a5,80003fc0 <flags2perm+0x14>
    80003fbc:	00456513          	ori	a0,a0,4
  return perm;
}
    80003fc0:	6422                	ld	s0,8(sp)
    80003fc2:	0141                	addi	sp,sp,16
    80003fc4:	8082                	ret

0000000080003fc6 <exec>:

int exec(char *path, char **argv) {
    80003fc6:	df010113          	addi	sp,sp,-528
    80003fca:	20113423          	sd	ra,520(sp)
    80003fce:	20813023          	sd	s0,512(sp)
    80003fd2:	ffa6                	sd	s1,504(sp)
    80003fd4:	fbca                	sd	s2,496(sp)
    80003fd6:	0c00                	addi	s0,sp,528
    80003fd8:	892a                	mv	s2,a0
    80003fda:	dea43c23          	sd	a0,-520(s0)
    80003fde:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	e20080e7          	jalr	-480(ra) # 80000e02 <myproc>
    80003fea:	84aa                	mv	s1,a0

  begin_op();
    80003fec:	fffff097          	auipc	ra,0xfffff
    80003ff0:	4a2080e7          	jalr	1186(ra) # 8000348e <begin_op>

  if ((ip = namei(path)) == 0) {
    80003ff4:	854a                	mv	a0,s2
    80003ff6:	fffff097          	auipc	ra,0xfffff
    80003ffa:	298080e7          	jalr	664(ra) # 8000328e <namei>
    80003ffe:	c135                	beqz	a0,80004062 <exec+0x9c>
    80004000:	f3d2                	sd	s4,480(sp)
    80004002:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004004:	fffff097          	auipc	ra,0xfffff
    80004008:	abc080e7          	jalr	-1348(ra) # 80002ac0 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    8000400c:	04000713          	li	a4,64
    80004010:	4681                	li	a3,0
    80004012:	e5040613          	addi	a2,s0,-432
    80004016:	4581                	li	a1,0
    80004018:	8552                	mv	a0,s4
    8000401a:	fffff097          	auipc	ra,0xfffff
    8000401e:	d5e080e7          	jalr	-674(ra) # 80002d78 <readi>
    80004022:	04000793          	li	a5,64
    80004026:	00f51a63          	bne	a0,a5,8000403a <exec+0x74>

  if (elf.magic != ELF_MAGIC) goto bad;
    8000402a:	e5042703          	lw	a4,-432(s0)
    8000402e:	464c47b7          	lui	a5,0x464c4
    80004032:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004036:	02f70c63          	beq	a4,a5,8000406e <exec+0xa8>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000403a:	8552                	mv	a0,s4
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	cea080e7          	jalr	-790(ra) # 80002d26 <iunlockput>
    end_op();
    80004044:	fffff097          	auipc	ra,0xfffff
    80004048:	4c4080e7          	jalr	1220(ra) # 80003508 <end_op>
  }
  return -1;
    8000404c:	557d                	li	a0,-1
    8000404e:	7a1e                	ld	s4,480(sp)
}
    80004050:	20813083          	ld	ra,520(sp)
    80004054:	20013403          	ld	s0,512(sp)
    80004058:	74fe                	ld	s1,504(sp)
    8000405a:	795e                	ld	s2,496(sp)
    8000405c:	21010113          	addi	sp,sp,528
    80004060:	8082                	ret
    end_op();
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	4a6080e7          	jalr	1190(ra) # 80003508 <end_op>
    return -1;
    8000406a:	557d                	li	a0,-1
    8000406c:	b7d5                	j	80004050 <exec+0x8a>
    8000406e:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    80004070:	8526                	mv	a0,s1
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	e58080e7          	jalr	-424(ra) # 80000eca <proc_pagetable>
    8000407a:	8b2a                	mv	s6,a0
    8000407c:	30050f63          	beqz	a0,8000439a <exec+0x3d4>
    80004080:	f7ce                	sd	s3,488(sp)
    80004082:	efd6                	sd	s5,472(sp)
    80004084:	e7de                	sd	s7,456(sp)
    80004086:	e3e2                	sd	s8,448(sp)
    80004088:	ff66                	sd	s9,440(sp)
    8000408a:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000408c:	e7042d03          	lw	s10,-400(s0)
    80004090:	e8845783          	lhu	a5,-376(s0)
    80004094:	14078d63          	beqz	a5,800041ee <exec+0x228>
    80004098:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000409a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000409c:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000409e:	6c85                	lui	s9,0x1
    800040a0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040a4:	def43823          	sd	a5,-528(s0)
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800040a8:	6a85                	lui	s5,0x1
    800040aa:	a0b5                	j	80004116 <exec+0x150>
    if (pa == 0) panic("loadseg: address should exist");
    800040ac:	00004517          	auipc	a0,0x4
    800040b0:	4d450513          	addi	a0,a0,1236 # 80008580 <etext+0x580>
    800040b4:	00003097          	auipc	ra,0x3
    800040b8:	890080e7          	jalr	-1904(ra) # 80006944 <panic>
    if (sz - i < PGSIZE)
    800040bc:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    800040be:	8726                	mv	a4,s1
    800040c0:	012c06bb          	addw	a3,s8,s2
    800040c4:	4581                	li	a1,0
    800040c6:	8552                	mv	a0,s4
    800040c8:	fffff097          	auipc	ra,0xfffff
    800040cc:	cb0080e7          	jalr	-848(ra) # 80002d78 <readi>
    800040d0:	2501                	sext.w	a0,a0
    800040d2:	28a49863          	bne	s1,a0,80004362 <exec+0x39c>
  for (i = 0; i < sz; i += PGSIZE) {
    800040d6:	012a893b          	addw	s2,s5,s2
    800040da:	03397563          	bgeu	s2,s3,80004104 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800040de:	02091593          	slli	a1,s2,0x20
    800040e2:	9181                	srli	a1,a1,0x20
    800040e4:	95de                	add	a1,a1,s7
    800040e6:	855a                	mv	a0,s6
    800040e8:	ffffc097          	auipc	ra,0xffffc
    800040ec:	310080e7          	jalr	784(ra) # 800003f8 <walkaddr>
    800040f0:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    800040f2:	dd4d                	beqz	a0,800040ac <exec+0xe6>
    if (sz - i < PGSIZE)
    800040f4:	412984bb          	subw	s1,s3,s2
    800040f8:	0004879b          	sext.w	a5,s1
    800040fc:	fcfcf0e3          	bgeu	s9,a5,800040bc <exec+0xf6>
    80004100:	84d6                	mv	s1,s5
    80004102:	bf6d                	j	800040bc <exec+0xf6>
    sz = sz1;
    80004104:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004108:	2d85                	addiw	s11,s11,1
    8000410a:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000410e:	e8845783          	lhu	a5,-376(s0)
    80004112:	08fdd663          	bge	s11,a5,8000419e <exec+0x1d8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    80004116:	2d01                	sext.w	s10,s10
    80004118:	03800713          	li	a4,56
    8000411c:	86ea                	mv	a3,s10
    8000411e:	e1840613          	addi	a2,s0,-488
    80004122:	4581                	li	a1,0
    80004124:	8552                	mv	a0,s4
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	c52080e7          	jalr	-942(ra) # 80002d78 <readi>
    8000412e:	03800793          	li	a5,56
    80004132:	20f51063          	bne	a0,a5,80004332 <exec+0x36c>
    if (ph.type != ELF_PROG_LOAD) continue;
    80004136:	e1842783          	lw	a5,-488(s0)
    8000413a:	4705                	li	a4,1
    8000413c:	fce796e3          	bne	a5,a4,80004108 <exec+0x142>
    if (ph.memsz < ph.filesz) goto bad;
    80004140:	e4043483          	ld	s1,-448(s0)
    80004144:	e3843783          	ld	a5,-456(s0)
    80004148:	1ef4e963          	bltu	s1,a5,8000433a <exec+0x374>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    8000414c:	e2843783          	ld	a5,-472(s0)
    80004150:	94be                	add	s1,s1,a5
    80004152:	1ef4e863          	bltu	s1,a5,80004342 <exec+0x37c>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004156:	df043703          	ld	a4,-528(s0)
    8000415a:	8ff9                	and	a5,a5,a4
    8000415c:	1e079763          	bnez	a5,8000434a <exec+0x384>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004160:	e1c42503          	lw	a0,-484(s0)
    80004164:	00000097          	auipc	ra,0x0
    80004168:	e48080e7          	jalr	-440(ra) # 80003fac <flags2perm>
    8000416c:	86aa                	mv	a3,a0
    8000416e:	8626                	mv	a2,s1
    80004170:	85ca                	mv	a1,s2
    80004172:	855a                	mv	a0,s6
    80004174:	ffffc097          	auipc	ra,0xffffc
    80004178:	66c080e7          	jalr	1644(ra) # 800007e0 <uvmalloc>
    8000417c:	e0a43423          	sd	a0,-504(s0)
    80004180:	1c050963          	beqz	a0,80004352 <exec+0x38c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    80004184:	e2843b83          	ld	s7,-472(s0)
    80004188:	e2042c03          	lw	s8,-480(s0)
    8000418c:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004190:	00098463          	beqz	s3,80004198 <exec+0x1d2>
    80004194:	4901                	li	s2,0
    80004196:	b7a1                	j	800040de <exec+0x118>
    sz = sz1;
    80004198:	e0843903          	ld	s2,-504(s0)
    8000419c:	b7b5                	j	80004108 <exec+0x142>
    8000419e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800041a0:	8552                	mv	a0,s4
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	b84080e7          	jalr	-1148(ra) # 80002d26 <iunlockput>
  end_op();
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	35e080e7          	jalr	862(ra) # 80003508 <end_op>
  p = myproc();
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	c50080e7          	jalr	-944(ra) # 80000e02 <myproc>
    800041ba:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041bc:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800041c0:	6985                	lui	s3,0x1
    800041c2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800041c4:	99ca                	add	s3,s3,s2
    800041c6:	77fd                	lui	a5,0xfffff
    800041c8:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800041cc:	4691                	li	a3,4
    800041ce:	6609                	lui	a2,0x2
    800041d0:	964e                	add	a2,a2,s3
    800041d2:	85ce                	mv	a1,s3
    800041d4:	855a                	mv	a0,s6
    800041d6:	ffffc097          	auipc	ra,0xffffc
    800041da:	60a080e7          	jalr	1546(ra) # 800007e0 <uvmalloc>
    800041de:	892a                	mv	s2,a0
    800041e0:	e0a43423          	sd	a0,-504(s0)
    800041e4:	e519                	bnez	a0,800041f2 <exec+0x22c>
  if (pagetable) proc_freepagetable(pagetable, sz);
    800041e6:	e1343423          	sd	s3,-504(s0)
    800041ea:	4a01                	li	s4,0
    800041ec:	aaa5                	j	80004364 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ee:	4901                	li	s2,0
    800041f0:	bf45                	j	800041a0 <exec+0x1da>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800041f2:	75f9                	lui	a1,0xffffe
    800041f4:	95aa                	add	a1,a1,a0
    800041f6:	855a                	mv	a0,s6
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	81e080e7          	jalr	-2018(ra) # 80000a16 <uvmclear>
  stackbase = sp - PGSIZE;
    80004200:	7bfd                	lui	s7,0xfffff
    80004202:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++) {
    80004204:	e0043783          	ld	a5,-512(s0)
    80004208:	6388                	ld	a0,0(a5)
    8000420a:	c52d                	beqz	a0,80004274 <exec+0x2ae>
    8000420c:	e9040993          	addi	s3,s0,-368
    80004210:	f9040c13          	addi	s8,s0,-112
    80004214:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004216:	ffffc097          	auipc	ra,0xffffc
    8000421a:	fd4080e7          	jalr	-44(ra) # 800001ea <strlen>
    8000421e:	0015079b          	addiw	a5,a0,1
    80004222:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80004226:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    8000422a:	13796863          	bltu	s2,s7,8000435a <exec+0x394>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000422e:	e0043d03          	ld	s10,-512(s0)
    80004232:	000d3a03          	ld	s4,0(s10)
    80004236:	8552                	mv	a0,s4
    80004238:	ffffc097          	auipc	ra,0xffffc
    8000423c:	fb2080e7          	jalr	-78(ra) # 800001ea <strlen>
    80004240:	0015069b          	addiw	a3,a0,1
    80004244:	8652                	mv	a2,s4
    80004246:	85ca                	mv	a1,s2
    80004248:	855a                	mv	a0,s6
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	7fe080e7          	jalr	2046(ra) # 80000a48 <copyout>
    80004252:	10054663          	bltz	a0,8000435e <exec+0x398>
    ustack[argc] = sp;
    80004256:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000425a:	0485                	addi	s1,s1,1
    8000425c:	008d0793          	addi	a5,s10,8
    80004260:	e0f43023          	sd	a5,-512(s0)
    80004264:	008d3503          	ld	a0,8(s10)
    80004268:	c909                	beqz	a0,8000427a <exec+0x2b4>
    if (argc >= MAXARG) goto bad;
    8000426a:	09a1                	addi	s3,s3,8
    8000426c:	fb8995e3          	bne	s3,s8,80004216 <exec+0x250>
  ip = 0;
    80004270:	4a01                	li	s4,0
    80004272:	a8cd                	j	80004364 <exec+0x39e>
  sp = sz;
    80004274:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    80004278:	4481                	li	s1,0
  ustack[argc] = 0;
    8000427a:	00349793          	slli	a5,s1,0x3
    8000427e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb200>
    80004282:	97a2                	add	a5,a5,s0
    80004284:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004288:	00148693          	addi	a3,s1,1
    8000428c:	068e                	slli	a3,a3,0x3
    8000428e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004292:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004296:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase) goto bad;
    8000429a:	f57966e3          	bltu	s2,s7,800041e6 <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000429e:	e9040613          	addi	a2,s0,-368
    800042a2:	85ca                	mv	a1,s2
    800042a4:	855a                	mv	a0,s6
    800042a6:	ffffc097          	auipc	ra,0xffffc
    800042aa:	7a2080e7          	jalr	1954(ra) # 80000a48 <copyout>
    800042ae:	0e054863          	bltz	a0,8000439e <exec+0x3d8>
  p->trapframe->a1 = sp;
    800042b2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800042b6:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800042ba:	df843783          	ld	a5,-520(s0)
    800042be:	0007c703          	lbu	a4,0(a5)
    800042c2:	cf11                	beqz	a4,800042de <exec+0x318>
    800042c4:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    800042c6:	02f00693          	li	a3,47
    800042ca:	a039                	j	800042d8 <exec+0x312>
    800042cc:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    800042d0:	0785                	addi	a5,a5,1
    800042d2:	fff7c703          	lbu	a4,-1(a5)
    800042d6:	c701                	beqz	a4,800042de <exec+0x318>
    if (*s == '/') last = s + 1;
    800042d8:	fed71ce3          	bne	a4,a3,800042d0 <exec+0x30a>
    800042dc:	bfc5                	j	800042cc <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800042de:	4641                	li	a2,16
    800042e0:	df843583          	ld	a1,-520(s0)
    800042e4:	158a8513          	addi	a0,s5,344
    800042e8:	ffffc097          	auipc	ra,0xffffc
    800042ec:	ed0080e7          	jalr	-304(ra) # 800001b8 <safestrcpy>
  oldpagetable = p->pagetable;
    800042f0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042f4:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800042f8:	e0843783          	ld	a5,-504(s0)
    800042fc:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004300:	058ab783          	ld	a5,88(s5)
    80004304:	e6843703          	ld	a4,-408(s0)
    80004308:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    8000430a:	058ab783          	ld	a5,88(s5)
    8000430e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004312:	85e6                	mv	a1,s9
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	c52080e7          	jalr	-942(ra) # 80000f66 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    8000431c:	0004851b          	sext.w	a0,s1
    80004320:	79be                	ld	s3,488(sp)
    80004322:	7a1e                	ld	s4,480(sp)
    80004324:	6afe                	ld	s5,472(sp)
    80004326:	6b5e                	ld	s6,464(sp)
    80004328:	6bbe                	ld	s7,456(sp)
    8000432a:	6c1e                	ld	s8,448(sp)
    8000432c:	7cfa                	ld	s9,440(sp)
    8000432e:	7d5a                	ld	s10,432(sp)
    80004330:	b305                	j	80004050 <exec+0x8a>
    80004332:	e1243423          	sd	s2,-504(s0)
    80004336:	7dba                	ld	s11,424(sp)
    80004338:	a035                	j	80004364 <exec+0x39e>
    8000433a:	e1243423          	sd	s2,-504(s0)
    8000433e:	7dba                	ld	s11,424(sp)
    80004340:	a015                	j	80004364 <exec+0x39e>
    80004342:	e1243423          	sd	s2,-504(s0)
    80004346:	7dba                	ld	s11,424(sp)
    80004348:	a831                	j	80004364 <exec+0x39e>
    8000434a:	e1243423          	sd	s2,-504(s0)
    8000434e:	7dba                	ld	s11,424(sp)
    80004350:	a811                	j	80004364 <exec+0x39e>
    80004352:	e1243423          	sd	s2,-504(s0)
    80004356:	7dba                	ld	s11,424(sp)
    80004358:	a031                	j	80004364 <exec+0x39e>
  ip = 0;
    8000435a:	4a01                	li	s4,0
    8000435c:	a021                	j	80004364 <exec+0x39e>
    8000435e:	4a01                	li	s4,0
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004360:	a011                	j	80004364 <exec+0x39e>
    80004362:	7dba                	ld	s11,424(sp)
    80004364:	e0843583          	ld	a1,-504(s0)
    80004368:	855a                	mv	a0,s6
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	bfc080e7          	jalr	-1028(ra) # 80000f66 <proc_freepagetable>
  return -1;
    80004372:	557d                	li	a0,-1
  if (ip) {
    80004374:	000a1b63          	bnez	s4,8000438a <exec+0x3c4>
    80004378:	79be                	ld	s3,488(sp)
    8000437a:	7a1e                	ld	s4,480(sp)
    8000437c:	6afe                	ld	s5,472(sp)
    8000437e:	6b5e                	ld	s6,464(sp)
    80004380:	6bbe                	ld	s7,456(sp)
    80004382:	6c1e                	ld	s8,448(sp)
    80004384:	7cfa                	ld	s9,440(sp)
    80004386:	7d5a                	ld	s10,432(sp)
    80004388:	b1e1                	j	80004050 <exec+0x8a>
    8000438a:	79be                	ld	s3,488(sp)
    8000438c:	6afe                	ld	s5,472(sp)
    8000438e:	6b5e                	ld	s6,464(sp)
    80004390:	6bbe                	ld	s7,456(sp)
    80004392:	6c1e                	ld	s8,448(sp)
    80004394:	7cfa                	ld	s9,440(sp)
    80004396:	7d5a                	ld	s10,432(sp)
    80004398:	b14d                	j	8000403a <exec+0x74>
    8000439a:	6b5e                	ld	s6,464(sp)
    8000439c:	b979                	j	8000403a <exec+0x74>
  sz = sz1;
    8000439e:	e0843983          	ld	s3,-504(s0)
    800043a2:	b591                	j	800041e6 <exec+0x220>

00000000800043a4 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800043a4:	7179                	addi	sp,sp,-48
    800043a6:	f406                	sd	ra,40(sp)
    800043a8:	f022                	sd	s0,32(sp)
    800043aa:	ec26                	sd	s1,24(sp)
    800043ac:	e84a                	sd	s2,16(sp)
    800043ae:	1800                	addi	s0,sp,48
    800043b0:	892e                	mv	s2,a1
    800043b2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043b4:	fdc40593          	addi	a1,s0,-36
    800043b8:	ffffe097          	auipc	ra,0xffffe
    800043bc:	b70080e7          	jalr	-1168(ra) # 80001f28 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800043c0:	fdc42703          	lw	a4,-36(s0)
    800043c4:	47bd                	li	a5,15
    800043c6:	02e7eb63          	bltu	a5,a4,800043fc <argfd+0x58>
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	a38080e7          	jalr	-1480(ra) # 80000e02 <myproc>
    800043d2:	fdc42703          	lw	a4,-36(s0)
    800043d6:	01a70793          	addi	a5,a4,26
    800043da:	078e                	slli	a5,a5,0x3
    800043dc:	953e                	add	a0,a0,a5
    800043de:	611c                	ld	a5,0(a0)
    800043e0:	c385                	beqz	a5,80004400 <argfd+0x5c>
  if (pfd) *pfd = fd;
    800043e2:	00090463          	beqz	s2,800043ea <argfd+0x46>
    800043e6:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    800043ea:	4501                	li	a0,0
  if (pf) *pf = f;
    800043ec:	c091                	beqz	s1,800043f0 <argfd+0x4c>
    800043ee:	e09c                	sd	a5,0(s1)
}
    800043f0:	70a2                	ld	ra,40(sp)
    800043f2:	7402                	ld	s0,32(sp)
    800043f4:	64e2                	ld	s1,24(sp)
    800043f6:	6942                	ld	s2,16(sp)
    800043f8:	6145                	addi	sp,sp,48
    800043fa:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800043fc:	557d                	li	a0,-1
    800043fe:	bfcd                	j	800043f0 <argfd+0x4c>
    80004400:	557d                	li	a0,-1
    80004402:	b7fd                	j	800043f0 <argfd+0x4c>

0000000080004404 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    80004404:	1101                	addi	sp,sp,-32
    80004406:	ec06                	sd	ra,24(sp)
    80004408:	e822                	sd	s0,16(sp)
    8000440a:	e426                	sd	s1,8(sp)
    8000440c:	1000                	addi	s0,sp,32
    8000440e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	9f2080e7          	jalr	-1550(ra) # 80000e02 <myproc>
    80004418:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    8000441a:	0d050793          	addi	a5,a0,208
    8000441e:	4501                	li	a0,0
    80004420:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004422:	6398                	ld	a4,0(a5)
    80004424:	cb19                	beqz	a4,8000443a <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    80004426:	2505                	addiw	a0,a0,1
    80004428:	07a1                	addi	a5,a5,8
    8000442a:	fed51ce3          	bne	a0,a3,80004422 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000442e:	557d                	li	a0,-1
}
    80004430:	60e2                	ld	ra,24(sp)
    80004432:	6442                	ld	s0,16(sp)
    80004434:	64a2                	ld	s1,8(sp)
    80004436:	6105                	addi	sp,sp,32
    80004438:	8082                	ret
      p->ofile[fd] = f;
    8000443a:	01a50793          	addi	a5,a0,26
    8000443e:	078e                	slli	a5,a5,0x3
    80004440:	963e                	add	a2,a2,a5
    80004442:	e204                	sd	s1,0(a2)
      return fd;
    80004444:	b7f5                	j	80004430 <fdalloc+0x2c>

0000000080004446 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    80004446:	715d                	addi	sp,sp,-80
    80004448:	e486                	sd	ra,72(sp)
    8000444a:	e0a2                	sd	s0,64(sp)
    8000444c:	fc26                	sd	s1,56(sp)
    8000444e:	f84a                	sd	s2,48(sp)
    80004450:	f44e                	sd	s3,40(sp)
    80004452:	ec56                	sd	s5,24(sp)
    80004454:	e85a                	sd	s6,16(sp)
    80004456:	0880                	addi	s0,sp,80
    80004458:	8b2e                	mv	s6,a1
    8000445a:	89b2                	mv	s3,a2
    8000445c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    8000445e:	fb040593          	addi	a1,s0,-80
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	e4a080e7          	jalr	-438(ra) # 800032ac <nameiparent>
    8000446a:	84aa                	mv	s1,a0
    8000446c:	14050e63          	beqz	a0,800045c8 <create+0x182>

  ilock(dp);
    80004470:	ffffe097          	auipc	ra,0xffffe
    80004474:	650080e7          	jalr	1616(ra) # 80002ac0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004478:	4601                	li	a2,0
    8000447a:	fb040593          	addi	a1,s0,-80
    8000447e:	8526                	mv	a0,s1
    80004480:	fffff097          	auipc	ra,0xfffff
    80004484:	b4c080e7          	jalr	-1204(ra) # 80002fcc <dirlookup>
    80004488:	8aaa                	mv	s5,a0
    8000448a:	c539                	beqz	a0,800044d8 <create+0x92>
    iunlockput(dp);
    8000448c:	8526                	mv	a0,s1
    8000448e:	fffff097          	auipc	ra,0xfffff
    80004492:	898080e7          	jalr	-1896(ra) # 80002d26 <iunlockput>
    ilock(ip);
    80004496:	8556                	mv	a0,s5
    80004498:	ffffe097          	auipc	ra,0xffffe
    8000449c:	628080e7          	jalr	1576(ra) # 80002ac0 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044a0:	4789                	li	a5,2
    800044a2:	02fb1463          	bne	s6,a5,800044ca <create+0x84>
    800044a6:	044ad783          	lhu	a5,68(s5)
    800044aa:	37f9                	addiw	a5,a5,-2
    800044ac:	17c2                	slli	a5,a5,0x30
    800044ae:	93c1                	srli	a5,a5,0x30
    800044b0:	4705                	li	a4,1
    800044b2:	00f76c63          	bltu	a4,a5,800044ca <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044b6:	8556                	mv	a0,s5
    800044b8:	60a6                	ld	ra,72(sp)
    800044ba:	6406                	ld	s0,64(sp)
    800044bc:	74e2                	ld	s1,56(sp)
    800044be:	7942                	ld	s2,48(sp)
    800044c0:	79a2                	ld	s3,40(sp)
    800044c2:	6ae2                	ld	s5,24(sp)
    800044c4:	6b42                	ld	s6,16(sp)
    800044c6:	6161                	addi	sp,sp,80
    800044c8:	8082                	ret
    iunlockput(ip);
    800044ca:	8556                	mv	a0,s5
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	85a080e7          	jalr	-1958(ra) # 80002d26 <iunlockput>
    return 0;
    800044d4:	4a81                	li	s5,0
    800044d6:	b7c5                	j	800044b6 <create+0x70>
    800044d8:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    800044da:	85da                	mv	a1,s6
    800044dc:	4088                	lw	a0,0(s1)
    800044de:	ffffe097          	auipc	ra,0xffffe
    800044e2:	43e080e7          	jalr	1086(ra) # 8000291c <ialloc>
    800044e6:	8a2a                	mv	s4,a0
    800044e8:	c531                	beqz	a0,80004534 <create+0xee>
  ilock(ip);
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	5d6080e7          	jalr	1494(ra) # 80002ac0 <ilock>
  ip->major = major;
    800044f2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044f6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044fa:	4905                	li	s2,1
    800044fc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004500:	8552                	mv	a0,s4
    80004502:	ffffe097          	auipc	ra,0xffffe
    80004506:	4f2080e7          	jalr	1266(ra) # 800029f4 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    8000450a:	032b0d63          	beq	s6,s2,80004544 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    8000450e:	004a2603          	lw	a2,4(s4)
    80004512:	fb040593          	addi	a1,s0,-80
    80004516:	8526                	mv	a0,s1
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	cc4080e7          	jalr	-828(ra) # 800031dc <dirlink>
    80004520:	08054163          	bltz	a0,800045a2 <create+0x15c>
  iunlockput(dp);
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	800080e7          	jalr	-2048(ra) # 80002d26 <iunlockput>
  return ip;
    8000452e:	8ad2                	mv	s5,s4
    80004530:	7a02                	ld	s4,32(sp)
    80004532:	b751                	j	800044b6 <create+0x70>
    iunlockput(dp);
    80004534:	8526                	mv	a0,s1
    80004536:	ffffe097          	auipc	ra,0xffffe
    8000453a:	7f0080e7          	jalr	2032(ra) # 80002d26 <iunlockput>
    return 0;
    8000453e:	8ad2                	mv	s5,s4
    80004540:	7a02                	ld	s4,32(sp)
    80004542:	bf95                	j	800044b6 <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004544:	004a2603          	lw	a2,4(s4)
    80004548:	00004597          	auipc	a1,0x4
    8000454c:	05858593          	addi	a1,a1,88 # 800085a0 <etext+0x5a0>
    80004550:	8552                	mv	a0,s4
    80004552:	fffff097          	auipc	ra,0xfffff
    80004556:	c8a080e7          	jalr	-886(ra) # 800031dc <dirlink>
    8000455a:	04054463          	bltz	a0,800045a2 <create+0x15c>
    8000455e:	40d0                	lw	a2,4(s1)
    80004560:	00004597          	auipc	a1,0x4
    80004564:	04858593          	addi	a1,a1,72 # 800085a8 <etext+0x5a8>
    80004568:	8552                	mv	a0,s4
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	c72080e7          	jalr	-910(ra) # 800031dc <dirlink>
    80004572:	02054863          	bltz	a0,800045a2 <create+0x15c>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004576:	004a2603          	lw	a2,4(s4)
    8000457a:	fb040593          	addi	a1,s0,-80
    8000457e:	8526                	mv	a0,s1
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	c5c080e7          	jalr	-932(ra) # 800031dc <dirlink>
    80004588:	00054d63          	bltz	a0,800045a2 <create+0x15c>
    dp->nlink++;  // for ".."
    8000458c:	04a4d783          	lhu	a5,74(s1)
    80004590:	2785                	addiw	a5,a5,1
    80004592:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004596:	8526                	mv	a0,s1
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	45c080e7          	jalr	1116(ra) # 800029f4 <iupdate>
    800045a0:	b751                	j	80004524 <create+0xde>
  ip->nlink = 0;
    800045a2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045a6:	8552                	mv	a0,s4
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	44c080e7          	jalr	1100(ra) # 800029f4 <iupdate>
  iunlockput(ip);
    800045b0:	8552                	mv	a0,s4
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	774080e7          	jalr	1908(ra) # 80002d26 <iunlockput>
  iunlockput(dp);
    800045ba:	8526                	mv	a0,s1
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	76a080e7          	jalr	1898(ra) # 80002d26 <iunlockput>
  return 0;
    800045c4:	7a02                	ld	s4,32(sp)
    800045c6:	bdc5                	j	800044b6 <create+0x70>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    800045c8:	8aaa                	mv	s5,a0
    800045ca:	b5f5                	j	800044b6 <create+0x70>

00000000800045cc <sys_dup>:
uint64 sys_dup(void) {
    800045cc:	7179                	addi	sp,sp,-48
    800045ce:	f406                	sd	ra,40(sp)
    800045d0:	f022                	sd	s0,32(sp)
    800045d2:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    800045d4:	fd840613          	addi	a2,s0,-40
    800045d8:	4581                	li	a1,0
    800045da:	4501                	li	a0,0
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	dc8080e7          	jalr	-568(ra) # 800043a4 <argfd>
    800045e4:	57fd                	li	a5,-1
    800045e6:	02054763          	bltz	a0,80004614 <sys_dup+0x48>
    800045ea:	ec26                	sd	s1,24(sp)
    800045ec:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0) return -1;
    800045ee:	fd843903          	ld	s2,-40(s0)
    800045f2:	854a                	mv	a0,s2
    800045f4:	00000097          	auipc	ra,0x0
    800045f8:	e10080e7          	jalr	-496(ra) # 80004404 <fdalloc>
    800045fc:	84aa                	mv	s1,a0
    800045fe:	57fd                	li	a5,-1
    80004600:	00054f63          	bltz	a0,8000461e <sys_dup+0x52>
  filedup(f);
    80004604:	854a                	mv	a0,s2
    80004606:	fffff097          	auipc	ra,0xfffff
    8000460a:	2c6080e7          	jalr	710(ra) # 800038cc <filedup>
  return fd;
    8000460e:	87a6                	mv	a5,s1
    80004610:	64e2                	ld	s1,24(sp)
    80004612:	6942                	ld	s2,16(sp)
}
    80004614:	853e                	mv	a0,a5
    80004616:	70a2                	ld	ra,40(sp)
    80004618:	7402                	ld	s0,32(sp)
    8000461a:	6145                	addi	sp,sp,48
    8000461c:	8082                	ret
    8000461e:	64e2                	ld	s1,24(sp)
    80004620:	6942                	ld	s2,16(sp)
    80004622:	bfcd                	j	80004614 <sys_dup+0x48>

0000000080004624 <sys_read>:
uint64 sys_read(void) {
    80004624:	7179                	addi	sp,sp,-48
    80004626:	f406                	sd	ra,40(sp)
    80004628:	f022                	sd	s0,32(sp)
    8000462a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000462c:	fd840593          	addi	a1,s0,-40
    80004630:	4505                	li	a0,1
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	916080e7          	jalr	-1770(ra) # 80001f48 <argaddr>
  argint(2, &n);
    8000463a:	fe440593          	addi	a1,s0,-28
    8000463e:	4509                	li	a0,2
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	8e8080e7          	jalr	-1816(ra) # 80001f28 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004648:	fe840613          	addi	a2,s0,-24
    8000464c:	4581                	li	a1,0
    8000464e:	4501                	li	a0,0
    80004650:	00000097          	auipc	ra,0x0
    80004654:	d54080e7          	jalr	-684(ra) # 800043a4 <argfd>
    80004658:	87aa                	mv	a5,a0
    8000465a:	557d                	li	a0,-1
    8000465c:	0007cc63          	bltz	a5,80004674 <sys_read+0x50>
  return fileread(f, p, n);
    80004660:	fe442603          	lw	a2,-28(s0)
    80004664:	fd843583          	ld	a1,-40(s0)
    80004668:	fe843503          	ld	a0,-24(s0)
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	3d2080e7          	jalr	978(ra) # 80003a3e <fileread>
}
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	6145                	addi	sp,sp,48
    8000467a:	8082                	ret

000000008000467c <sys_write>:
uint64 sys_write(void) {
    8000467c:	7179                	addi	sp,sp,-48
    8000467e:	f406                	sd	ra,40(sp)
    80004680:	f022                	sd	s0,32(sp)
    80004682:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004684:	fd840593          	addi	a1,s0,-40
    80004688:	4505                	li	a0,1
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	8be080e7          	jalr	-1858(ra) # 80001f48 <argaddr>
  argint(2, &n);
    80004692:	fe440593          	addi	a1,s0,-28
    80004696:	4509                	li	a0,2
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	890080e7          	jalr	-1904(ra) # 80001f28 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800046a0:	fe840613          	addi	a2,s0,-24
    800046a4:	4581                	li	a1,0
    800046a6:	4501                	li	a0,0
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	cfc080e7          	jalr	-772(ra) # 800043a4 <argfd>
    800046b0:	87aa                	mv	a5,a0
    800046b2:	557d                	li	a0,-1
    800046b4:	0007cc63          	bltz	a5,800046cc <sys_write+0x50>
  return filewrite(f, p, n);
    800046b8:	fe442603          	lw	a2,-28(s0)
    800046bc:	fd843583          	ld	a1,-40(s0)
    800046c0:	fe843503          	ld	a0,-24(s0)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	456080e7          	jalr	1110(ra) # 80003b1a <filewrite>
}
    800046cc:	70a2                	ld	ra,40(sp)
    800046ce:	7402                	ld	s0,32(sp)
    800046d0:	6145                	addi	sp,sp,48
    800046d2:	8082                	ret

00000000800046d4 <sys_close>:
uint64 sys_close(void) {
    800046d4:	1101                	addi	sp,sp,-32
    800046d6:	ec06                	sd	ra,24(sp)
    800046d8:	e822                	sd	s0,16(sp)
    800046da:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    800046dc:	fe040613          	addi	a2,s0,-32
    800046e0:	fec40593          	addi	a1,s0,-20
    800046e4:	4501                	li	a0,0
    800046e6:	00000097          	auipc	ra,0x0
    800046ea:	cbe080e7          	jalr	-834(ra) # 800043a4 <argfd>
    800046ee:	57fd                	li	a5,-1
    800046f0:	02054463          	bltz	a0,80004718 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046f4:	ffffc097          	auipc	ra,0xffffc
    800046f8:	70e080e7          	jalr	1806(ra) # 80000e02 <myproc>
    800046fc:	fec42783          	lw	a5,-20(s0)
    80004700:	07e9                	addi	a5,a5,26
    80004702:	078e                	slli	a5,a5,0x3
    80004704:	953e                	add	a0,a0,a5
    80004706:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000470a:	fe043503          	ld	a0,-32(s0)
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	20e080e7          	jalr	526(ra) # 8000391c <fileclose>
  return 0;
    80004716:	4781                	li	a5,0
}
    80004718:	853e                	mv	a0,a5
    8000471a:	60e2                	ld	ra,24(sp)
    8000471c:	6442                	ld	s0,16(sp)
    8000471e:	6105                	addi	sp,sp,32
    80004720:	8082                	ret

0000000080004722 <sys_fstat>:
uint64 sys_fstat(void) {
    80004722:	1101                	addi	sp,sp,-32
    80004724:	ec06                	sd	ra,24(sp)
    80004726:	e822                	sd	s0,16(sp)
    80004728:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000472a:	fe040593          	addi	a1,s0,-32
    8000472e:	4505                	li	a0,1
    80004730:	ffffe097          	auipc	ra,0xffffe
    80004734:	818080e7          	jalr	-2024(ra) # 80001f48 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004738:	fe840613          	addi	a2,s0,-24
    8000473c:	4581                	li	a1,0
    8000473e:	4501                	li	a0,0
    80004740:	00000097          	auipc	ra,0x0
    80004744:	c64080e7          	jalr	-924(ra) # 800043a4 <argfd>
    80004748:	87aa                	mv	a5,a0
    8000474a:	557d                	li	a0,-1
    8000474c:	0007ca63          	bltz	a5,80004760 <sys_fstat+0x3e>
  return filestat(f, st);
    80004750:	fe043583          	ld	a1,-32(s0)
    80004754:	fe843503          	ld	a0,-24(s0)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	26e080e7          	jalr	622(ra) # 800039c6 <filestat>
}
    80004760:	60e2                	ld	ra,24(sp)
    80004762:	6442                	ld	s0,16(sp)
    80004764:	6105                	addi	sp,sp,32
    80004766:	8082                	ret

0000000080004768 <sys_link>:
uint64 sys_link(void) {
    80004768:	7169                	addi	sp,sp,-304
    8000476a:	f606                	sd	ra,296(sp)
    8000476c:	f222                	sd	s0,288(sp)
    8000476e:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004770:	08000613          	li	a2,128
    80004774:	ed040593          	addi	a1,s0,-304
    80004778:	4501                	li	a0,0
    8000477a:	ffffd097          	auipc	ra,0xffffd
    8000477e:	7ee080e7          	jalr	2030(ra) # 80001f68 <argstr>
    80004782:	57fd                	li	a5,-1
    80004784:	12054663          	bltz	a0,800048b0 <sys_link+0x148>
    80004788:	08000613          	li	a2,128
    8000478c:	f5040593          	addi	a1,s0,-176
    80004790:	4505                	li	a0,1
    80004792:	ffffd097          	auipc	ra,0xffffd
    80004796:	7d6080e7          	jalr	2006(ra) # 80001f68 <argstr>
    8000479a:	57fd                	li	a5,-1
    8000479c:	10054a63          	bltz	a0,800048b0 <sys_link+0x148>
    800047a0:	ee26                	sd	s1,280(sp)
  begin_op();
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	cec080e7          	jalr	-788(ra) # 8000348e <begin_op>
  if ((ip = namei(old)) == 0) {
    800047aa:	ed040513          	addi	a0,s0,-304
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	ae0080e7          	jalr	-1312(ra) # 8000328e <namei>
    800047b6:	84aa                	mv	s1,a0
    800047b8:	c949                	beqz	a0,8000484a <sys_link+0xe2>
  ilock(ip);
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	306080e7          	jalr	774(ra) # 80002ac0 <ilock>
  if (ip->type == T_DIR) {
    800047c2:	04449703          	lh	a4,68(s1)
    800047c6:	4785                	li	a5,1
    800047c8:	08f70863          	beq	a4,a5,80004858 <sys_link+0xf0>
    800047cc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800047ce:	04a4d783          	lhu	a5,74(s1)
    800047d2:	2785                	addiw	a5,a5,1
    800047d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d8:	8526                	mv	a0,s1
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	21a080e7          	jalr	538(ra) # 800029f4 <iupdate>
  iunlock(ip);
    800047e2:	8526                	mv	a0,s1
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	3a2080e7          	jalr	930(ra) # 80002b86 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    800047ec:	fd040593          	addi	a1,s0,-48
    800047f0:	f5040513          	addi	a0,s0,-176
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	ab8080e7          	jalr	-1352(ra) # 800032ac <nameiparent>
    800047fc:	892a                	mv	s2,a0
    800047fe:	cd35                	beqz	a0,8000487a <sys_link+0x112>
  ilock(dp);
    80004800:	ffffe097          	auipc	ra,0xffffe
    80004804:	2c0080e7          	jalr	704(ra) # 80002ac0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004808:	00092703          	lw	a4,0(s2)
    8000480c:	409c                	lw	a5,0(s1)
    8000480e:	06f71163          	bne	a4,a5,80004870 <sys_link+0x108>
    80004812:	40d0                	lw	a2,4(s1)
    80004814:	fd040593          	addi	a1,s0,-48
    80004818:	854a                	mv	a0,s2
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	9c2080e7          	jalr	-1598(ra) # 800031dc <dirlink>
    80004822:	04054763          	bltz	a0,80004870 <sys_link+0x108>
  iunlockput(dp);
    80004826:	854a                	mv	a0,s2
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	4fe080e7          	jalr	1278(ra) # 80002d26 <iunlockput>
  iput(ip);
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	44c080e7          	jalr	1100(ra) # 80002c7e <iput>
  end_op();
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	cce080e7          	jalr	-818(ra) # 80003508 <end_op>
  return 0;
    80004842:	4781                	li	a5,0
    80004844:	64f2                	ld	s1,280(sp)
    80004846:	6952                	ld	s2,272(sp)
    80004848:	a0a5                	j	800048b0 <sys_link+0x148>
    end_op();
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	cbe080e7          	jalr	-834(ra) # 80003508 <end_op>
    return -1;
    80004852:	57fd                	li	a5,-1
    80004854:	64f2                	ld	s1,280(sp)
    80004856:	a8a9                	j	800048b0 <sys_link+0x148>
    iunlockput(ip);
    80004858:	8526                	mv	a0,s1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	4cc080e7          	jalr	1228(ra) # 80002d26 <iunlockput>
    end_op();
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	ca6080e7          	jalr	-858(ra) # 80003508 <end_op>
    return -1;
    8000486a:	57fd                	li	a5,-1
    8000486c:	64f2                	ld	s1,280(sp)
    8000486e:	a089                	j	800048b0 <sys_link+0x148>
    iunlockput(dp);
    80004870:	854a                	mv	a0,s2
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	4b4080e7          	jalr	1204(ra) # 80002d26 <iunlockput>
  ilock(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	244080e7          	jalr	580(ra) # 80002ac0 <ilock>
  ip->nlink--;
    80004884:	04a4d783          	lhu	a5,74(s1)
    80004888:	37fd                	addiw	a5,a5,-1
    8000488a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	164080e7          	jalr	356(ra) # 800029f4 <iupdate>
  iunlockput(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	48c080e7          	jalr	1164(ra) # 80002d26 <iunlockput>
  end_op();
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	c66080e7          	jalr	-922(ra) # 80003508 <end_op>
  return -1;
    800048aa:	57fd                	li	a5,-1
    800048ac:	64f2                	ld	s1,280(sp)
    800048ae:	6952                	ld	s2,272(sp)
}
    800048b0:	853e                	mv	a0,a5
    800048b2:	70b2                	ld	ra,296(sp)
    800048b4:	7412                	ld	s0,288(sp)
    800048b6:	6155                	addi	sp,sp,304
    800048b8:	8082                	ret

00000000800048ba <sys_unlink>:
uint64 sys_unlink(void) {
    800048ba:	7151                	addi	sp,sp,-240
    800048bc:	f586                	sd	ra,232(sp)
    800048be:	f1a2                	sd	s0,224(sp)
    800048c0:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    800048c2:	08000613          	li	a2,128
    800048c6:	f3040593          	addi	a1,s0,-208
    800048ca:	4501                	li	a0,0
    800048cc:	ffffd097          	auipc	ra,0xffffd
    800048d0:	69c080e7          	jalr	1692(ra) # 80001f68 <argstr>
    800048d4:	1a054a63          	bltz	a0,80004a88 <sys_unlink+0x1ce>
    800048d8:	eda6                	sd	s1,216(sp)
  begin_op();
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	bb4080e7          	jalr	-1100(ra) # 8000348e <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800048e2:	fb040593          	addi	a1,s0,-80
    800048e6:	f3040513          	addi	a0,s0,-208
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	9c2080e7          	jalr	-1598(ra) # 800032ac <nameiparent>
    800048f2:	84aa                	mv	s1,a0
    800048f4:	cd71                	beqz	a0,800049d0 <sys_unlink+0x116>
  ilock(dp);
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	1ca080e7          	jalr	458(ra) # 80002ac0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    800048fe:	00004597          	auipc	a1,0x4
    80004902:	ca258593          	addi	a1,a1,-862 # 800085a0 <etext+0x5a0>
    80004906:	fb040513          	addi	a0,s0,-80
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	6a8080e7          	jalr	1704(ra) # 80002fb2 <namecmp>
    80004912:	14050c63          	beqz	a0,80004a6a <sys_unlink+0x1b0>
    80004916:	00004597          	auipc	a1,0x4
    8000491a:	c9258593          	addi	a1,a1,-878 # 800085a8 <etext+0x5a8>
    8000491e:	fb040513          	addi	a0,s0,-80
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	690080e7          	jalr	1680(ra) # 80002fb2 <namecmp>
    8000492a:	14050063          	beqz	a0,80004a6a <sys_unlink+0x1b0>
    8000492e:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004930:	f2c40613          	addi	a2,s0,-212
    80004934:	fb040593          	addi	a1,s0,-80
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	692080e7          	jalr	1682(ra) # 80002fcc <dirlookup>
    80004942:	892a                	mv	s2,a0
    80004944:	12050263          	beqz	a0,80004a68 <sys_unlink+0x1ae>
  ilock(ip);
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	178080e7          	jalr	376(ra) # 80002ac0 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004950:	04a91783          	lh	a5,74(s2)
    80004954:	08f05563          	blez	a5,800049de <sys_unlink+0x124>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004958:	04491703          	lh	a4,68(s2)
    8000495c:	4785                	li	a5,1
    8000495e:	08f70963          	beq	a4,a5,800049f0 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004962:	4641                	li	a2,16
    80004964:	4581                	li	a1,0
    80004966:	fc040513          	addi	a0,s0,-64
    8000496a:	ffffb097          	auipc	ra,0xffffb
    8000496e:	70c080e7          	jalr	1804(ra) # 80000076 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004972:	4741                	li	a4,16
    80004974:	f2c42683          	lw	a3,-212(s0)
    80004978:	fc040613          	addi	a2,s0,-64
    8000497c:	4581                	li	a1,0
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	508080e7          	jalr	1288(ra) # 80002e88 <writei>
    80004988:	47c1                	li	a5,16
    8000498a:	0af51b63          	bne	a0,a5,80004a40 <sys_unlink+0x186>
  if (ip->type == T_DIR) {
    8000498e:	04491703          	lh	a4,68(s2)
    80004992:	4785                	li	a5,1
    80004994:	0af70f63          	beq	a4,a5,80004a52 <sys_unlink+0x198>
  iunlockput(dp);
    80004998:	8526                	mv	a0,s1
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	38c080e7          	jalr	908(ra) # 80002d26 <iunlockput>
  ip->nlink--;
    800049a2:	04a95783          	lhu	a5,74(s2)
    800049a6:	37fd                	addiw	a5,a5,-1
    800049a8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049ac:	854a                	mv	a0,s2
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	046080e7          	jalr	70(ra) # 800029f4 <iupdate>
  iunlockput(ip);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	36e080e7          	jalr	878(ra) # 80002d26 <iunlockput>
  end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	b48080e7          	jalr	-1208(ra) # 80003508 <end_op>
  return 0;
    800049c8:	4501                	li	a0,0
    800049ca:	64ee                	ld	s1,216(sp)
    800049cc:	694e                	ld	s2,208(sp)
    800049ce:	a84d                	j	80004a80 <sys_unlink+0x1c6>
    end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	b38080e7          	jalr	-1224(ra) # 80003508 <end_op>
    return -1;
    800049d8:	557d                	li	a0,-1
    800049da:	64ee                	ld	s1,216(sp)
    800049dc:	a055                	j	80004a80 <sys_unlink+0x1c6>
    800049de:	e5ce                	sd	s3,200(sp)
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    800049e0:	00004517          	auipc	a0,0x4
    800049e4:	bd050513          	addi	a0,a0,-1072 # 800085b0 <etext+0x5b0>
    800049e8:	00002097          	auipc	ra,0x2
    800049ec:	f5c080e7          	jalr	-164(ra) # 80006944 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800049f0:	04c92703          	lw	a4,76(s2)
    800049f4:	02000793          	li	a5,32
    800049f8:	f6e7f5e3          	bgeu	a5,a4,80004962 <sys_unlink+0xa8>
    800049fc:	e5ce                	sd	s3,200(sp)
    800049fe:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a02:	4741                	li	a4,16
    80004a04:	86ce                	mv	a3,s3
    80004a06:	f1840613          	addi	a2,s0,-232
    80004a0a:	4581                	li	a1,0
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	36a080e7          	jalr	874(ra) # 80002d78 <readi>
    80004a16:	47c1                	li	a5,16
    80004a18:	00f51c63          	bne	a0,a5,80004a30 <sys_unlink+0x176>
    if (de.inum != 0) return 0;
    80004a1c:	f1845783          	lhu	a5,-232(s0)
    80004a20:	e7b5                	bnez	a5,80004a8c <sys_unlink+0x1d2>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004a22:	29c1                	addiw	s3,s3,16
    80004a24:	04c92783          	lw	a5,76(s2)
    80004a28:	fcf9ede3          	bltu	s3,a5,80004a02 <sys_unlink+0x148>
    80004a2c:	69ae                	ld	s3,200(sp)
    80004a2e:	bf15                	j	80004962 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004a30:	00004517          	auipc	a0,0x4
    80004a34:	b9850513          	addi	a0,a0,-1128 # 800085c8 <etext+0x5c8>
    80004a38:	00002097          	auipc	ra,0x2
    80004a3c:	f0c080e7          	jalr	-244(ra) # 80006944 <panic>
    80004a40:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004a42:	00004517          	auipc	a0,0x4
    80004a46:	b9e50513          	addi	a0,a0,-1122 # 800085e0 <etext+0x5e0>
    80004a4a:	00002097          	auipc	ra,0x2
    80004a4e:	efa080e7          	jalr	-262(ra) # 80006944 <panic>
    dp->nlink--;
    80004a52:	04a4d783          	lhu	a5,74(s1)
    80004a56:	37fd                	addiw	a5,a5,-1
    80004a58:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	f96080e7          	jalr	-106(ra) # 800029f4 <iupdate>
    80004a66:	bf0d                	j	80004998 <sys_unlink+0xde>
    80004a68:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	2ba080e7          	jalr	698(ra) # 80002d26 <iunlockput>
  end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	a94080e7          	jalr	-1388(ra) # 80003508 <end_op>
  return -1;
    80004a7c:	557d                	li	a0,-1
    80004a7e:	64ee                	ld	s1,216(sp)
}
    80004a80:	70ae                	ld	ra,232(sp)
    80004a82:	740e                	ld	s0,224(sp)
    80004a84:	616d                	addi	sp,sp,240
    80004a86:	8082                	ret
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004a88:	557d                	li	a0,-1
    80004a8a:	bfdd                	j	80004a80 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004a8c:	854a                	mv	a0,s2
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	298080e7          	jalr	664(ra) # 80002d26 <iunlockput>
    goto bad;
    80004a96:	694e                	ld	s2,208(sp)
    80004a98:	69ae                	ld	s3,200(sp)
    80004a9a:	bfc1                	j	80004a6a <sys_unlink+0x1b0>

0000000080004a9c <sys_open>:

uint64 sys_open(void) {
    80004a9c:	7131                	addi	sp,sp,-192
    80004a9e:	fd06                	sd	ra,184(sp)
    80004aa0:	f922                	sd	s0,176(sp)
    80004aa2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004aa4:	f4c40593          	addi	a1,s0,-180
    80004aa8:	4505                	li	a0,1
    80004aaa:	ffffd097          	auipc	ra,0xffffd
    80004aae:	47e080e7          	jalr	1150(ra) # 80001f28 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004ab2:	08000613          	li	a2,128
    80004ab6:	f5040593          	addi	a1,s0,-176
    80004aba:	4501                	li	a0,0
    80004abc:	ffffd097          	auipc	ra,0xffffd
    80004ac0:	4ac080e7          	jalr	1196(ra) # 80001f68 <argstr>
    80004ac4:	87aa                	mv	a5,a0
    80004ac6:	557d                	li	a0,-1
    80004ac8:	0a07ce63          	bltz	a5,80004b84 <sys_open+0xe8>
    80004acc:	f526                	sd	s1,168(sp)

  begin_op();
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	9c0080e7          	jalr	-1600(ra) # 8000348e <begin_op>

  if (omode & O_CREATE) {
    80004ad6:	f4c42783          	lw	a5,-180(s0)
    80004ada:	2007f793          	andi	a5,a5,512
    80004ade:	cfd5                	beqz	a5,80004b9a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ae0:	4681                	li	a3,0
    80004ae2:	4601                	li	a2,0
    80004ae4:	4589                	li	a1,2
    80004ae6:	f5040513          	addi	a0,s0,-176
    80004aea:	00000097          	auipc	ra,0x0
    80004aee:	95c080e7          	jalr	-1700(ra) # 80004446 <create>
    80004af2:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004af4:	cd41                	beqz	a0,80004b8c <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004af6:	04449703          	lh	a4,68(s1)
    80004afa:	478d                	li	a5,3
    80004afc:	00f71763          	bne	a4,a5,80004b0a <sys_open+0x6e>
    80004b00:	0464d703          	lhu	a4,70(s1)
    80004b04:	47a5                	li	a5,9
    80004b06:	0ee7e163          	bltu	a5,a4,80004be8 <sys_open+0x14c>
    80004b0a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	d74080e7          	jalr	-652(ra) # 80003880 <filealloc>
    80004b14:	892a                	mv	s2,a0
    80004b16:	c97d                	beqz	a0,80004c0c <sys_open+0x170>
    80004b18:	ed4e                	sd	s3,152(sp)
    80004b1a:	00000097          	auipc	ra,0x0
    80004b1e:	8ea080e7          	jalr	-1814(ra) # 80004404 <fdalloc>
    80004b22:	89aa                	mv	s3,a0
    80004b24:	0c054e63          	bltz	a0,80004c00 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004b28:	04449703          	lh	a4,68(s1)
    80004b2c:	478d                	li	a5,3
    80004b2e:	0ef70c63          	beq	a4,a5,80004c26 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b32:	4789                	li	a5,2
    80004b34:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b38:	02092c23          	sw	zero,56(s2)
  }
  f->ip = ip;
    80004b3c:	02993823          	sd	s1,48(s2)
  f->readable = !(omode & O_WRONLY);
    80004b40:	f4c42783          	lw	a5,-180(s0)
    80004b44:	0017c713          	xori	a4,a5,1
    80004b48:	8b05                	andi	a4,a4,1
    80004b4a:	02e90223          	sb	a4,36(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b4e:	0037f713          	andi	a4,a5,3
    80004b52:	00e03733          	snez	a4,a4
    80004b56:	02e902a3          	sb	a4,37(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004b5a:	4007f793          	andi	a5,a5,1024
    80004b5e:	c791                	beqz	a5,80004b6a <sys_open+0xce>
    80004b60:	04449703          	lh	a4,68(s1)
    80004b64:	4789                	li	a5,2
    80004b66:	0cf70763          	beq	a4,a5,80004c34 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	01a080e7          	jalr	26(ra) # 80002b86 <iunlock>
  end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	994080e7          	jalr	-1644(ra) # 80003508 <end_op>

  return fd;
    80004b7c:	854e                	mv	a0,s3
    80004b7e:	74aa                	ld	s1,168(sp)
    80004b80:	790a                	ld	s2,160(sp)
    80004b82:	69ea                	ld	s3,152(sp)
}
    80004b84:	70ea                	ld	ra,184(sp)
    80004b86:	744a                	ld	s0,176(sp)
    80004b88:	6129                	addi	sp,sp,192
    80004b8a:	8082                	ret
      end_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	97c080e7          	jalr	-1668(ra) # 80003508 <end_op>
      return -1;
    80004b94:	557d                	li	a0,-1
    80004b96:	74aa                	ld	s1,168(sp)
    80004b98:	b7f5                	j	80004b84 <sys_open+0xe8>
    if ((ip = namei(path)) == 0) {
    80004b9a:	f5040513          	addi	a0,s0,-176
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	6f0080e7          	jalr	1776(ra) # 8000328e <namei>
    80004ba6:	84aa                	mv	s1,a0
    80004ba8:	c90d                	beqz	a0,80004bda <sys_open+0x13e>
    ilock(ip);
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	f16080e7          	jalr	-234(ra) # 80002ac0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004bb2:	04449703          	lh	a4,68(s1)
    80004bb6:	4785                	li	a5,1
    80004bb8:	f2f71fe3          	bne	a4,a5,80004af6 <sys_open+0x5a>
    80004bbc:	f4c42783          	lw	a5,-180(s0)
    80004bc0:	d7a9                	beqz	a5,80004b0a <sys_open+0x6e>
      iunlockput(ip);
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	162080e7          	jalr	354(ra) # 80002d26 <iunlockput>
      end_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	93c080e7          	jalr	-1732(ra) # 80003508 <end_op>
      return -1;
    80004bd4:	557d                	li	a0,-1
    80004bd6:	74aa                	ld	s1,168(sp)
    80004bd8:	b775                	j	80004b84 <sys_open+0xe8>
      end_op();
    80004bda:	fffff097          	auipc	ra,0xfffff
    80004bde:	92e080e7          	jalr	-1746(ra) # 80003508 <end_op>
      return -1;
    80004be2:	557d                	li	a0,-1
    80004be4:	74aa                	ld	s1,168(sp)
    80004be6:	bf79                	j	80004b84 <sys_open+0xe8>
    iunlockput(ip);
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	13c080e7          	jalr	316(ra) # 80002d26 <iunlockput>
    end_op();
    80004bf2:	fffff097          	auipc	ra,0xfffff
    80004bf6:	916080e7          	jalr	-1770(ra) # 80003508 <end_op>
    return -1;
    80004bfa:	557d                	li	a0,-1
    80004bfc:	74aa                	ld	s1,168(sp)
    80004bfe:	b759                	j	80004b84 <sys_open+0xe8>
    if (f) fileclose(f);
    80004c00:	854a                	mv	a0,s2
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	d1a080e7          	jalr	-742(ra) # 8000391c <fileclose>
    80004c0a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	118080e7          	jalr	280(ra) # 80002d26 <iunlockput>
    end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	8f2080e7          	jalr	-1806(ra) # 80003508 <end_op>
    return -1;
    80004c1e:	557d                	li	a0,-1
    80004c20:	74aa                	ld	s1,168(sp)
    80004c22:	790a                	ld	s2,160(sp)
    80004c24:	b785                	j	80004b84 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004c26:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c2a:	04649783          	lh	a5,70(s1)
    80004c2e:	02f91e23          	sh	a5,60(s2)
    80004c32:	b729                	j	80004b3c <sys_open+0xa0>
    itrunc(ip);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	f9c080e7          	jalr	-100(ra) # 80002bd2 <itrunc>
    80004c3e:	b735                	j	80004b6a <sys_open+0xce>

0000000080004c40 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004c40:	7175                	addi	sp,sp,-144
    80004c42:	e506                	sd	ra,136(sp)
    80004c44:	e122                	sd	s0,128(sp)
    80004c46:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	846080e7          	jalr	-1978(ra) # 8000348e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004c50:	08000613          	li	a2,128
    80004c54:	f7040593          	addi	a1,s0,-144
    80004c58:	4501                	li	a0,0
    80004c5a:	ffffd097          	auipc	ra,0xffffd
    80004c5e:	30e080e7          	jalr	782(ra) # 80001f68 <argstr>
    80004c62:	02054963          	bltz	a0,80004c94 <sys_mkdir+0x54>
    80004c66:	4681                	li	a3,0
    80004c68:	4601                	li	a2,0
    80004c6a:	4585                	li	a1,1
    80004c6c:	f7040513          	addi	a0,s0,-144
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	7d6080e7          	jalr	2006(ra) # 80004446 <create>
    80004c78:	cd11                	beqz	a0,80004c94 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	0ac080e7          	jalr	172(ra) # 80002d26 <iunlockput>
  end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	886080e7          	jalr	-1914(ra) # 80003508 <end_op>
  return 0;
    80004c8a:	4501                	li	a0,0
}
    80004c8c:	60aa                	ld	ra,136(sp)
    80004c8e:	640a                	ld	s0,128(sp)
    80004c90:	6149                	addi	sp,sp,144
    80004c92:	8082                	ret
    end_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	874080e7          	jalr	-1932(ra) # 80003508 <end_op>
    return -1;
    80004c9c:	557d                	li	a0,-1
    80004c9e:	b7fd                	j	80004c8c <sys_mkdir+0x4c>

0000000080004ca0 <sys_mknod>:

uint64 sys_mknod(void) {
    80004ca0:	7135                	addi	sp,sp,-160
    80004ca2:	ed06                	sd	ra,152(sp)
    80004ca4:	e922                	sd	s0,144(sp)
    80004ca6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	7e6080e7          	jalr	2022(ra) # 8000348e <begin_op>
  argint(1, &major);
    80004cb0:	f6c40593          	addi	a1,s0,-148
    80004cb4:	4505                	li	a0,1
    80004cb6:	ffffd097          	auipc	ra,0xffffd
    80004cba:	272080e7          	jalr	626(ra) # 80001f28 <argint>
  argint(2, &minor);
    80004cbe:	f6840593          	addi	a1,s0,-152
    80004cc2:	4509                	li	a0,2
    80004cc4:	ffffd097          	auipc	ra,0xffffd
    80004cc8:	264080e7          	jalr	612(ra) # 80001f28 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004ccc:	08000613          	li	a2,128
    80004cd0:	f7040593          	addi	a1,s0,-144
    80004cd4:	4501                	li	a0,0
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	292080e7          	jalr	658(ra) # 80001f68 <argstr>
    80004cde:	02054b63          	bltz	a0,80004d14 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004ce2:	f6841683          	lh	a3,-152(s0)
    80004ce6:	f6c41603          	lh	a2,-148(s0)
    80004cea:	458d                	li	a1,3
    80004cec:	f7040513          	addi	a0,s0,-144
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	756080e7          	jalr	1878(ra) # 80004446 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004cf8:	cd11                	beqz	a0,80004d14 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	02c080e7          	jalr	44(ra) # 80002d26 <iunlockput>
  end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	806080e7          	jalr	-2042(ra) # 80003508 <end_op>
  return 0;
    80004d0a:	4501                	li	a0,0
}
    80004d0c:	60ea                	ld	ra,152(sp)
    80004d0e:	644a                	ld	s0,144(sp)
    80004d10:	610d                	addi	sp,sp,160
    80004d12:	8082                	ret
    end_op();
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	7f4080e7          	jalr	2036(ra) # 80003508 <end_op>
    return -1;
    80004d1c:	557d                	li	a0,-1
    80004d1e:	b7fd                	j	80004d0c <sys_mknod+0x6c>

0000000080004d20 <sys_chdir>:

uint64 sys_chdir(void) {
    80004d20:	7135                	addi	sp,sp,-160
    80004d22:	ed06                	sd	ra,152(sp)
    80004d24:	e922                	sd	s0,144(sp)
    80004d26:	e14a                	sd	s2,128(sp)
    80004d28:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d2a:	ffffc097          	auipc	ra,0xffffc
    80004d2e:	0d8080e7          	jalr	216(ra) # 80000e02 <myproc>
    80004d32:	892a                	mv	s2,a0

  begin_op();
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	75a080e7          	jalr	1882(ra) # 8000348e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004d3c:	08000613          	li	a2,128
    80004d40:	f6040593          	addi	a1,s0,-160
    80004d44:	4501                	li	a0,0
    80004d46:	ffffd097          	auipc	ra,0xffffd
    80004d4a:	222080e7          	jalr	546(ra) # 80001f68 <argstr>
    80004d4e:	04054d63          	bltz	a0,80004da8 <sys_chdir+0x88>
    80004d52:	e526                	sd	s1,136(sp)
    80004d54:	f6040513          	addi	a0,s0,-160
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	536080e7          	jalr	1334(ra) # 8000328e <namei>
    80004d60:	84aa                	mv	s1,a0
    80004d62:	c131                	beqz	a0,80004da6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	d5c080e7          	jalr	-676(ra) # 80002ac0 <ilock>
  if (ip->type != T_DIR) {
    80004d6c:	04449703          	lh	a4,68(s1)
    80004d70:	4785                	li	a5,1
    80004d72:	04f71163          	bne	a4,a5,80004db4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	e0e080e7          	jalr	-498(ra) # 80002b86 <iunlock>
  iput(p->cwd);
    80004d80:	15093503          	ld	a0,336(s2)
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	efa080e7          	jalr	-262(ra) # 80002c7e <iput>
  end_op();
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	77c080e7          	jalr	1916(ra) # 80003508 <end_op>
  p->cwd = ip;
    80004d94:	14993823          	sd	s1,336(s2)
  return 0;
    80004d98:	4501                	li	a0,0
    80004d9a:	64aa                	ld	s1,136(sp)
}
    80004d9c:	60ea                	ld	ra,152(sp)
    80004d9e:	644a                	ld	s0,144(sp)
    80004da0:	690a                	ld	s2,128(sp)
    80004da2:	610d                	addi	sp,sp,160
    80004da4:	8082                	ret
    80004da6:	64aa                	ld	s1,136(sp)
    end_op();
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	760080e7          	jalr	1888(ra) # 80003508 <end_op>
    return -1;
    80004db0:	557d                	li	a0,-1
    80004db2:	b7ed                	j	80004d9c <sys_chdir+0x7c>
    iunlockput(ip);
    80004db4:	8526                	mv	a0,s1
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	f70080e7          	jalr	-144(ra) # 80002d26 <iunlockput>
    end_op();
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	74a080e7          	jalr	1866(ra) # 80003508 <end_op>
    return -1;
    80004dc6:	557d                	li	a0,-1
    80004dc8:	64aa                	ld	s1,136(sp)
    80004dca:	bfc9                	j	80004d9c <sys_chdir+0x7c>

0000000080004dcc <sys_exec>:

uint64 sys_exec(void) {
    80004dcc:	7121                	addi	sp,sp,-448
    80004dce:	ff06                	sd	ra,440(sp)
    80004dd0:	fb22                	sd	s0,432(sp)
    80004dd2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004dd4:	e4840593          	addi	a1,s0,-440
    80004dd8:	4505                	li	a0,1
    80004dda:	ffffd097          	auipc	ra,0xffffd
    80004dde:	16e080e7          	jalr	366(ra) # 80001f48 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004de2:	08000613          	li	a2,128
    80004de6:	f5040593          	addi	a1,s0,-176
    80004dea:	4501                	li	a0,0
    80004dec:	ffffd097          	auipc	ra,0xffffd
    80004df0:	17c080e7          	jalr	380(ra) # 80001f68 <argstr>
    80004df4:	87aa                	mv	a5,a0
    return -1;
    80004df6:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004df8:	0e07c263          	bltz	a5,80004edc <sys_exec+0x110>
    80004dfc:	f726                	sd	s1,424(sp)
    80004dfe:	f34a                	sd	s2,416(sp)
    80004e00:	ef4e                	sd	s3,408(sp)
    80004e02:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e04:	10000613          	li	a2,256
    80004e08:	4581                	li	a1,0
    80004e0a:	e5040513          	addi	a0,s0,-432
    80004e0e:	ffffb097          	auipc	ra,0xffffb
    80004e12:	268080e7          	jalr	616(ra) # 80000076 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004e16:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e1a:	89a6                	mv	s3,s1
    80004e1c:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004e1e:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004e22:	00391513          	slli	a0,s2,0x3
    80004e26:	e4040593          	addi	a1,s0,-448
    80004e2a:	e4843783          	ld	a5,-440(s0)
    80004e2e:	953e                	add	a0,a0,a5
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	05a080e7          	jalr	90(ra) # 80001e8a <fetchaddr>
    80004e38:	02054a63          	bltz	a0,80004e6c <sys_exec+0xa0>
      goto bad;
    }
    if (uarg == 0) {
    80004e3c:	e4043783          	ld	a5,-448(s0)
    80004e40:	c7b9                	beqz	a5,80004e8e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e42:	ffffb097          	auipc	ra,0xffffb
    80004e46:	21a080e7          	jalr	538(ra) # 8000005c <kalloc>
    80004e4a:	85aa                	mv	a1,a0
    80004e4c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80004e50:	cd11                	beqz	a0,80004e6c <sys_exec+0xa0>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80004e52:	6605                	lui	a2,0x1
    80004e54:	e4043503          	ld	a0,-448(s0)
    80004e58:	ffffd097          	auipc	ra,0xffffd
    80004e5c:	084080e7          	jalr	132(ra) # 80001edc <fetchstr>
    80004e60:	00054663          	bltz	a0,80004e6c <sys_exec+0xa0>
    if (i >= NELEM(argv)) {
    80004e64:	0905                	addi	s2,s2,1
    80004e66:	09a1                	addi	s3,s3,8
    80004e68:	fb491de3          	bne	s2,s4,80004e22 <sys_exec+0x56>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004e6c:	f5040913          	addi	s2,s0,-176
    80004e70:	6088                	ld	a0,0(s1)
    80004e72:	c125                	beqz	a0,80004ed2 <sys_exec+0x106>
    80004e74:	ffffb097          	auipc	ra,0xffffb
    80004e78:	1d0080e7          	jalr	464(ra) # 80000044 <kfree>
    80004e7c:	04a1                	addi	s1,s1,8
    80004e7e:	ff2499e3          	bne	s1,s2,80004e70 <sys_exec+0xa4>
  return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	74ba                	ld	s1,424(sp)
    80004e86:	791a                	ld	s2,416(sp)
    80004e88:	69fa                	ld	s3,408(sp)
    80004e8a:	6a5a                	ld	s4,400(sp)
    80004e8c:	a881                	j	80004edc <sys_exec+0x110>
      argv[i] = 0;
    80004e8e:	0009079b          	sext.w	a5,s2
    80004e92:	078e                	slli	a5,a5,0x3
    80004e94:	fd078793          	addi	a5,a5,-48
    80004e98:	97a2                	add	a5,a5,s0
    80004e9a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004e9e:	e5040593          	addi	a1,s0,-432
    80004ea2:	f5040513          	addi	a0,s0,-176
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	120080e7          	jalr	288(ra) # 80003fc6 <exec>
    80004eae:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004eb0:	f5040993          	addi	s3,s0,-176
    80004eb4:	6088                	ld	a0,0(s1)
    80004eb6:	c901                	beqz	a0,80004ec6 <sys_exec+0xfa>
    80004eb8:	ffffb097          	auipc	ra,0xffffb
    80004ebc:	18c080e7          	jalr	396(ra) # 80000044 <kfree>
    80004ec0:	04a1                	addi	s1,s1,8
    80004ec2:	ff3499e3          	bne	s1,s3,80004eb4 <sys_exec+0xe8>
  return ret;
    80004ec6:	854a                	mv	a0,s2
    80004ec8:	74ba                	ld	s1,424(sp)
    80004eca:	791a                	ld	s2,416(sp)
    80004ecc:	69fa                	ld	s3,408(sp)
    80004ece:	6a5a                	ld	s4,400(sp)
    80004ed0:	a031                	j	80004edc <sys_exec+0x110>
  return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	74ba                	ld	s1,424(sp)
    80004ed6:	791a                	ld	s2,416(sp)
    80004ed8:	69fa                	ld	s3,408(sp)
    80004eda:	6a5a                	ld	s4,400(sp)
}
    80004edc:	70fa                	ld	ra,440(sp)
    80004ede:	745a                	ld	s0,432(sp)
    80004ee0:	6139                	addi	sp,sp,448
    80004ee2:	8082                	ret

0000000080004ee4 <sys_pipe>:

uint64 sys_pipe(void) {
    80004ee4:	7139                	addi	sp,sp,-64
    80004ee6:	fc06                	sd	ra,56(sp)
    80004ee8:	f822                	sd	s0,48(sp)
    80004eea:	f426                	sd	s1,40(sp)
    80004eec:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eee:	ffffc097          	auipc	ra,0xffffc
    80004ef2:	f14080e7          	jalr	-236(ra) # 80000e02 <myproc>
    80004ef6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ef8:	fd840593          	addi	a1,s0,-40
    80004efc:	4501                	li	a0,0
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	04a080e7          	jalr	74(ra) # 80001f48 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80004f06:	fc840593          	addi	a1,s0,-56
    80004f0a:	fd040513          	addi	a0,s0,-48
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	d50080e7          	jalr	-688(ra) # 80003c5e <pipealloc>
    80004f16:	57fd                	li	a5,-1
    80004f18:	0c054463          	bltz	a0,80004fe0 <sys_pipe+0xfc>
  fd0 = -1;
    80004f1c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80004f20:	fd043503          	ld	a0,-48(s0)
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	4e0080e7          	jalr	1248(ra) # 80004404 <fdalloc>
    80004f2c:	fca42223          	sw	a0,-60(s0)
    80004f30:	08054b63          	bltz	a0,80004fc6 <sys_pipe+0xe2>
    80004f34:	fc843503          	ld	a0,-56(s0)
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	4cc080e7          	jalr	1228(ra) # 80004404 <fdalloc>
    80004f40:	fca42023          	sw	a0,-64(s0)
    80004f44:	06054863          	bltz	a0,80004fb4 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004f48:	4691                	li	a3,4
    80004f4a:	fc440613          	addi	a2,s0,-60
    80004f4e:	fd843583          	ld	a1,-40(s0)
    80004f52:	68a8                	ld	a0,80(s1)
    80004f54:	ffffc097          	auipc	ra,0xffffc
    80004f58:	af4080e7          	jalr	-1292(ra) # 80000a48 <copyout>
    80004f5c:	02054063          	bltz	a0,80004f7c <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80004f60:	4691                	li	a3,4
    80004f62:	fc040613          	addi	a2,s0,-64
    80004f66:	fd843583          	ld	a1,-40(s0)
    80004f6a:	0591                	addi	a1,a1,4
    80004f6c:	68a8                	ld	a0,80(s1)
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	ada080e7          	jalr	-1318(ra) # 80000a48 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f76:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004f78:	06055463          	bgez	a0,80004fe0 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f7c:	fc442783          	lw	a5,-60(s0)
    80004f80:	07e9                	addi	a5,a5,26
    80004f82:	078e                	slli	a5,a5,0x3
    80004f84:	97a6                	add	a5,a5,s1
    80004f86:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f8a:	fc042783          	lw	a5,-64(s0)
    80004f8e:	07e9                	addi	a5,a5,26
    80004f90:	078e                	slli	a5,a5,0x3
    80004f92:	94be                	add	s1,s1,a5
    80004f94:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f98:	fd043503          	ld	a0,-48(s0)
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	980080e7          	jalr	-1664(ra) # 8000391c <fileclose>
    fileclose(wf);
    80004fa4:	fc843503          	ld	a0,-56(s0)
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	974080e7          	jalr	-1676(ra) # 8000391c <fileclose>
    return -1;
    80004fb0:	57fd                	li	a5,-1
    80004fb2:	a03d                	j	80004fe0 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80004fb4:	fc442783          	lw	a5,-60(s0)
    80004fb8:	0007c763          	bltz	a5,80004fc6 <sys_pipe+0xe2>
    80004fbc:	07e9                	addi	a5,a5,26
    80004fbe:	078e                	slli	a5,a5,0x3
    80004fc0:	97a6                	add	a5,a5,s1
    80004fc2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004fc6:	fd043503          	ld	a0,-48(s0)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	952080e7          	jalr	-1710(ra) # 8000391c <fileclose>
    fileclose(wf);
    80004fd2:	fc843503          	ld	a0,-56(s0)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	946080e7          	jalr	-1722(ra) # 8000391c <fileclose>
    return -1;
    80004fde:	57fd                	li	a5,-1
}
    80004fe0:	853e                	mv	a0,a5
    80004fe2:	70e2                	ld	ra,56(sp)
    80004fe4:	7442                	ld	s0,48(sp)
    80004fe6:	74a2                	ld	s1,40(sp)
    80004fe8:	6121                	addi	sp,sp,64
    80004fea:	8082                	ret
    80004fec:	0000                	unimp
	...

0000000080004ff0 <kernelvec>:
    80004ff0:	7111                	addi	sp,sp,-256
    80004ff2:	e006                	sd	ra,0(sp)
    80004ff4:	e40a                	sd	sp,8(sp)
    80004ff6:	e80e                	sd	gp,16(sp)
    80004ff8:	ec12                	sd	tp,24(sp)
    80004ffa:	f016                	sd	t0,32(sp)
    80004ffc:	f41a                	sd	t1,40(sp)
    80004ffe:	f81e                	sd	t2,48(sp)
    80005000:	fc22                	sd	s0,56(sp)
    80005002:	e0a6                	sd	s1,64(sp)
    80005004:	e4aa                	sd	a0,72(sp)
    80005006:	e8ae                	sd	a1,80(sp)
    80005008:	ecb2                	sd	a2,88(sp)
    8000500a:	f0b6                	sd	a3,96(sp)
    8000500c:	f4ba                	sd	a4,104(sp)
    8000500e:	f8be                	sd	a5,112(sp)
    80005010:	fcc2                	sd	a6,120(sp)
    80005012:	e146                	sd	a7,128(sp)
    80005014:	e54a                	sd	s2,136(sp)
    80005016:	e94e                	sd	s3,144(sp)
    80005018:	ed52                	sd	s4,152(sp)
    8000501a:	f156                	sd	s5,160(sp)
    8000501c:	f55a                	sd	s6,168(sp)
    8000501e:	f95e                	sd	s7,176(sp)
    80005020:	fd62                	sd	s8,184(sp)
    80005022:	e1e6                	sd	s9,192(sp)
    80005024:	e5ea                	sd	s10,200(sp)
    80005026:	e9ee                	sd	s11,208(sp)
    80005028:	edf2                	sd	t3,216(sp)
    8000502a:	f1f6                	sd	t4,224(sp)
    8000502c:	f5fa                	sd	t5,232(sp)
    8000502e:	f9fe                	sd	t6,240(sp)
    80005030:	d27fc0ef          	jal	80001d56 <kerneltrap>
    80005034:	6082                	ld	ra,0(sp)
    80005036:	6122                	ld	sp,8(sp)
    80005038:	61c2                	ld	gp,16(sp)
    8000503a:	7282                	ld	t0,32(sp)
    8000503c:	7322                	ld	t1,40(sp)
    8000503e:	73c2                	ld	t2,48(sp)
    80005040:	7462                	ld	s0,56(sp)
    80005042:	6486                	ld	s1,64(sp)
    80005044:	6526                	ld	a0,72(sp)
    80005046:	65c6                	ld	a1,80(sp)
    80005048:	6666                	ld	a2,88(sp)
    8000504a:	7686                	ld	a3,96(sp)
    8000504c:	7726                	ld	a4,104(sp)
    8000504e:	77c6                	ld	a5,112(sp)
    80005050:	7866                	ld	a6,120(sp)
    80005052:	688a                	ld	a7,128(sp)
    80005054:	692a                	ld	s2,136(sp)
    80005056:	69ca                	ld	s3,144(sp)
    80005058:	6a6a                	ld	s4,152(sp)
    8000505a:	7a8a                	ld	s5,160(sp)
    8000505c:	7b2a                	ld	s6,168(sp)
    8000505e:	7bca                	ld	s7,176(sp)
    80005060:	7c6a                	ld	s8,184(sp)
    80005062:	6c8e                	ld	s9,192(sp)
    80005064:	6d2e                	ld	s10,200(sp)
    80005066:	6dce                	ld	s11,208(sp)
    80005068:	6e6e                	ld	t3,216(sp)
    8000506a:	7e8e                	ld	t4,224(sp)
    8000506c:	7f2e                	ld	t5,232(sp)
    8000506e:	7fce                	ld	t6,240(sp)
    80005070:	6111                	addi	sp,sp,256
    80005072:	10200073          	sret
    80005076:	00000013          	nop
    8000507a:	00000013          	nop
    8000507e:	0001                	nop

0000000080005080 <timervec>:
    80005080:	34051573          	csrrw	a0,mscratch,a0
    80005084:	e10c                	sd	a1,0(a0)
    80005086:	e510                	sd	a2,8(a0)
    80005088:	e914                	sd	a3,16(a0)
    8000508a:	6d0c                	ld	a1,24(a0)
    8000508c:	7110                	ld	a2,32(a0)
    8000508e:	6194                	ld	a3,0(a1)
    80005090:	96b2                	add	a3,a3,a2
    80005092:	e194                	sd	a3,0(a1)
    80005094:	4589                	li	a1,2
    80005096:	14459073          	csrw	sip,a1
    8000509a:	6914                	ld	a3,16(a0)
    8000509c:	6510                	ld	a2,8(a0)
    8000509e:	610c                	ld	a1,0(a0)
    800050a0:	34051573          	csrrw	a0,mscratch,a0
    800050a4:	30200073          	mret
	...

00000000800050aa <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    800050aa:	1141                	addi	sp,sp,-16
    800050ac:	e422                	sd	s0,8(sp)
    800050ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    800050b0:	0c0007b7          	lui	a5,0xc000
    800050b4:	4705                	li	a4,1
    800050b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800050b8:	0c0007b7          	lui	a5,0xc000
    800050bc:	c3d8                	sw	a4,4(a5)
}
    800050be:	6422                	ld	s0,8(sp)
    800050c0:	0141                	addi	sp,sp,16
    800050c2:	8082                	ret

00000000800050c4 <plicinithart>:

void plicinithart(void) {
    800050c4:	1141                	addi	sp,sp,-16
    800050c6:	e406                	sd	ra,8(sp)
    800050c8:	e022                	sd	s0,0(sp)
    800050ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050cc:	ffffc097          	auipc	ra,0xffffc
    800050d0:	d0a080e7          	jalr	-758(ra) # 80000dd6 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050d4:	0085171b          	slliw	a4,a0,0x8
    800050d8:	0c0027b7          	lui	a5,0xc002
    800050dc:	97ba                	add	a5,a5,a4
    800050de:	40200713          	li	a4,1026
    800050e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050e6:	00d5151b          	slliw	a0,a0,0xd
    800050ea:	0c2017b7          	lui	a5,0xc201
    800050ee:	97aa                	add	a5,a5,a0
    800050f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050f4:	60a2                	ld	ra,8(sp)
    800050f6:	6402                	ld	s0,0(sp)
    800050f8:	0141                	addi	sp,sp,16
    800050fa:	8082                	ret

00000000800050fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    800050fc:	1141                	addi	sp,sp,-16
    800050fe:	e406                	sd	ra,8(sp)
    80005100:	e022                	sd	s0,0(sp)
    80005102:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005104:	ffffc097          	auipc	ra,0xffffc
    80005108:	cd2080e7          	jalr	-814(ra) # 80000dd6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000510c:	00d5151b          	slliw	a0,a0,0xd
    80005110:	0c2017b7          	lui	a5,0xc201
    80005114:	97aa                	add	a5,a5,a0
  return irq;
}
    80005116:	43c8                	lw	a0,4(a5)
    80005118:	60a2                	ld	ra,8(sp)
    8000511a:	6402                	ld	s0,0(sp)
    8000511c:	0141                	addi	sp,sp,16
    8000511e:	8082                	ret

0000000080005120 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    80005120:	1101                	addi	sp,sp,-32
    80005122:	ec06                	sd	ra,24(sp)
    80005124:	e822                	sd	s0,16(sp)
    80005126:	e426                	sd	s1,8(sp)
    80005128:	1000                	addi	s0,sp,32
    8000512a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	caa080e7          	jalr	-854(ra) # 80000dd6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005134:	00d5151b          	slliw	a0,a0,0xd
    80005138:	0c2017b7          	lui	a5,0xc201
    8000513c:	97aa                	add	a5,a5,a0
    8000513e:	c3c4                	sw	s1,4(a5)
}
    80005140:	60e2                	ld	ra,24(sp)
    80005142:	6442                	ld	s0,16(sp)
    80005144:	64a2                	ld	s1,8(sp)
    80005146:	6105                	addi	sp,sp,32
    80005148:	8082                	ret

000000008000514a <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e406                	sd	ra,8(sp)
    8000514e:	e022                	sd	s0,0(sp)
    80005150:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    80005152:	479d                	li	a5,7
    80005154:	04a7cc63          	blt	a5,a0,800051ac <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005158:	00017797          	auipc	a5,0x17
    8000515c:	8a078793          	addi	a5,a5,-1888 # 8001b9f8 <disk>
    80005160:	97aa                	add	a5,a5,a0
    80005162:	0187c783          	lbu	a5,24(a5)
    80005166:	ebb9                	bnez	a5,800051bc <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005168:	00451693          	slli	a3,a0,0x4
    8000516c:	00017797          	auipc	a5,0x17
    80005170:	88c78793          	addi	a5,a5,-1908 # 8001b9f8 <disk>
    80005174:	6398                	ld	a4,0(a5)
    80005176:	9736                	add	a4,a4,a3
    80005178:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000517c:	6398                	ld	a4,0(a5)
    8000517e:	9736                	add	a4,a4,a3
    80005180:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005184:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005188:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000518c:	97aa                	add	a5,a5,a0
    8000518e:	4705                	li	a4,1
    80005190:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005194:	00017517          	auipc	a0,0x17
    80005198:	87c50513          	addi	a0,a0,-1924 # 8001ba10 <disk+0x18>
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	378080e7          	jalr	888(ra) # 80001514 <wakeup>
}
    800051a4:	60a2                	ld	ra,8(sp)
    800051a6:	6402                	ld	s0,0(sp)
    800051a8:	0141                	addi	sp,sp,16
    800051aa:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    800051ac:	00003517          	auipc	a0,0x3
    800051b0:	44450513          	addi	a0,a0,1092 # 800085f0 <etext+0x5f0>
    800051b4:	00001097          	auipc	ra,0x1
    800051b8:	790080e7          	jalr	1936(ra) # 80006944 <panic>
  if (disk.free[i]) panic("free_desc 2");
    800051bc:	00003517          	auipc	a0,0x3
    800051c0:	44450513          	addi	a0,a0,1092 # 80008600 <etext+0x600>
    800051c4:	00001097          	auipc	ra,0x1
    800051c8:	780080e7          	jalr	1920(ra) # 80006944 <panic>

00000000800051cc <virtio_disk_init>:
void virtio_disk_init(void) {
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	e04a                	sd	s2,0(sp)
    800051d6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051d8:	00003597          	auipc	a1,0x3
    800051dc:	43858593          	addi	a1,a1,1080 # 80008610 <etext+0x610>
    800051e0:	00017517          	auipc	a0,0x17
    800051e4:	94050513          	addi	a0,a0,-1728 # 8001bb20 <disk+0x128>
    800051e8:	00002097          	auipc	ra,0x2
    800051ec:	c46080e7          	jalr	-954(ra) # 80006e2e <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051f0:	100017b7          	lui	a5,0x10001
    800051f4:	4398                	lw	a4,0(a5)
    800051f6:	2701                	sext.w	a4,a4
    800051f8:	747277b7          	lui	a5,0x74727
    800051fc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005200:	18f71c63          	bne	a4,a5,80005398 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005204:	100017b7          	lui	a5,0x10001
    80005208:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000520a:	439c                	lw	a5,0(a5)
    8000520c:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000520e:	4709                	li	a4,2
    80005210:	18e79463          	bne	a5,a4,80005398 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005214:	100017b7          	lui	a5,0x10001
    80005218:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000521a:	439c                	lw	a5,0(a5)
    8000521c:	2781                	sext.w	a5,a5
    8000521e:	16e79d63          	bne	a5,a4,80005398 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005222:	100017b7          	lui	a5,0x10001
    80005226:	47d8                	lw	a4,12(a5)
    80005228:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000522a:	554d47b7          	lui	a5,0x554d4
    8000522e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005232:	16f71363          	bne	a4,a5,80005398 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005236:	100017b7          	lui	a5,0x10001
    8000523a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000523e:	4705                	li	a4,1
    80005240:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005242:	470d                	li	a4,3
    80005244:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005246:	10001737          	lui	a4,0x10001
    8000524a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000524c:	c7ffe737          	lui	a4,0xc7ffe
    80005250:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda9cf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005254:	8ef9                	and	a3,a3,a4
    80005256:	10001737          	lui	a4,0x10001
    8000525a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000525c:	472d                	li	a4,11
    8000525e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005260:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005264:	439c                	lw	a5,0(a5)
    80005266:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000526a:	8ba1                	andi	a5,a5,8
    8000526c:	12078e63          	beqz	a5,800053a8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005270:	100017b7          	lui	a5,0x10001
    80005274:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005278:	100017b7          	lui	a5,0x10001
    8000527c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005280:	439c                	lw	a5,0(a5)
    80005282:	2781                	sext.w	a5,a5
    80005284:	12079a63          	bnez	a5,800053b8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005290:	439c                	lw	a5,0(a5)
    80005292:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005294:	12078a63          	beqz	a5,800053c8 <virtio_disk_init+0x1fc>
  if (max < NUM) panic("virtio disk max queue too short");
    80005298:	471d                	li	a4,7
    8000529a:	12f77f63          	bgeu	a4,a5,800053d8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000529e:	ffffb097          	auipc	ra,0xffffb
    800052a2:	dbe080e7          	jalr	-578(ra) # 8000005c <kalloc>
    800052a6:	00016497          	auipc	s1,0x16
    800052aa:	75248493          	addi	s1,s1,1874 # 8001b9f8 <disk>
    800052ae:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	dac080e7          	jalr	-596(ra) # 8000005c <kalloc>
    800052b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052ba:	ffffb097          	auipc	ra,0xffffb
    800052be:	da2080e7          	jalr	-606(ra) # 8000005c <kalloc>
    800052c2:	87aa                	mv	a5,a0
    800052c4:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800052c6:	6088                	ld	a0,0(s1)
    800052c8:	12050063          	beqz	a0,800053e8 <virtio_disk_init+0x21c>
    800052cc:	00016717          	auipc	a4,0x16
    800052d0:	73473703          	ld	a4,1844(a4) # 8001ba00 <disk+0x8>
    800052d4:	10070a63          	beqz	a4,800053e8 <virtio_disk_init+0x21c>
    800052d8:	10078863          	beqz	a5,800053e8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800052dc:	6605                	lui	a2,0x1
    800052de:	4581                	li	a1,0
    800052e0:	ffffb097          	auipc	ra,0xffffb
    800052e4:	d96080e7          	jalr	-618(ra) # 80000076 <memset>
  memset(disk.avail, 0, PGSIZE);
    800052e8:	00016497          	auipc	s1,0x16
    800052ec:	71048493          	addi	s1,s1,1808 # 8001b9f8 <disk>
    800052f0:	6605                	lui	a2,0x1
    800052f2:	4581                	li	a1,0
    800052f4:	6488                	ld	a0,8(s1)
    800052f6:	ffffb097          	auipc	ra,0xffffb
    800052fa:	d80080e7          	jalr	-640(ra) # 80000076 <memset>
  memset(disk.used, 0, PGSIZE);
    800052fe:	6605                	lui	a2,0x1
    80005300:	4581                	li	a1,0
    80005302:	6888                	ld	a0,16(s1)
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	d72080e7          	jalr	-654(ra) # 80000076 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000530c:	100017b7          	lui	a5,0x10001
    80005310:	4721                	li	a4,8
    80005312:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005314:	4098                	lw	a4,0(s1)
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000531e:	40d8                	lw	a4,4(s1)
    80005320:	100017b7          	lui	a5,0x10001
    80005324:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005328:	649c                	ld	a5,8(s1)
    8000532a:	0007869b          	sext.w	a3,a5
    8000532e:	10001737          	lui	a4,0x10001
    80005332:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005336:	9781                	srai	a5,a5,0x20
    80005338:	10001737          	lui	a4,0x10001
    8000533c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005340:	689c                	ld	a5,16(s1)
    80005342:	0007869b          	sext.w	a3,a5
    80005346:	10001737          	lui	a4,0x10001
    8000534a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000534e:	9781                	srai	a5,a5,0x20
    80005350:	10001737          	lui	a4,0x10001
    80005354:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005358:	10001737          	lui	a4,0x10001
    8000535c:	4785                	li	a5,1
    8000535e:	c37c                	sw	a5,68(a4)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    80005360:	00f48c23          	sb	a5,24(s1)
    80005364:	00f48ca3          	sb	a5,25(s1)
    80005368:	00f48d23          	sb	a5,26(s1)
    8000536c:	00f48da3          	sb	a5,27(s1)
    80005370:	00f48e23          	sb	a5,28(s1)
    80005374:	00f48ea3          	sb	a5,29(s1)
    80005378:	00f48f23          	sb	a5,30(s1)
    8000537c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005380:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6902                	ld	s2,0(sp)
    80005394:	6105                	addi	sp,sp,32
    80005396:	8082                	ret
    panic("could not find virtio disk");
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	28850513          	addi	a0,a0,648 # 80008620 <etext+0x620>
    800053a0:	00001097          	auipc	ra,0x1
    800053a4:	5a4080e7          	jalr	1444(ra) # 80006944 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	29850513          	addi	a0,a0,664 # 80008640 <etext+0x640>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	594080e7          	jalr	1428(ra) # 80006944 <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	2a850513          	addi	a0,a0,680 # 80008660 <etext+0x660>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	584080e7          	jalr	1412(ra) # 80006944 <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	2b850513          	addi	a0,a0,696 # 80008680 <etext+0x680>
    800053d0:	00001097          	auipc	ra,0x1
    800053d4:	574080e7          	jalr	1396(ra) # 80006944 <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	2c850513          	addi	a0,a0,712 # 800086a0 <etext+0x6a0>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	564080e7          	jalr	1380(ra) # 80006944 <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	2d850513          	addi	a0,a0,728 # 800086c0 <etext+0x6c0>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	554080e7          	jalr	1364(ra) # 80006944 <panic>

00000000800053f8 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800053f8:	7159                	addi	sp,sp,-112
    800053fa:	f486                	sd	ra,104(sp)
    800053fc:	f0a2                	sd	s0,96(sp)
    800053fe:	eca6                	sd	s1,88(sp)
    80005400:	e8ca                	sd	s2,80(sp)
    80005402:	e4ce                	sd	s3,72(sp)
    80005404:	e0d2                	sd	s4,64(sp)
    80005406:	fc56                	sd	s5,56(sp)
    80005408:	f85a                	sd	s6,48(sp)
    8000540a:	f45e                	sd	s7,40(sp)
    8000540c:	f062                	sd	s8,32(sp)
    8000540e:	ec66                	sd	s9,24(sp)
    80005410:	1880                	addi	s0,sp,112
    80005412:	8a2a                	mv	s4,a0
    80005414:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005416:	00c52c83          	lw	s9,12(a0)
    8000541a:	001c9c9b          	slliw	s9,s9,0x1
    8000541e:	1c82                	slli	s9,s9,0x20
    80005420:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005424:	00016517          	auipc	a0,0x16
    80005428:	6fc50513          	addi	a0,a0,1788 # 8001bb20 <disk+0x128>
    8000542c:	00002097          	auipc	ra,0x2
    80005430:	a92080e7          	jalr	-1390(ra) # 80006ebe <acquire>
  for (int i = 0; i < 3; i++) {
    80005434:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005436:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005438:	00016b17          	auipc	s6,0x16
    8000543c:	5c0b0b13          	addi	s6,s6,1472 # 8001b9f8 <disk>
  for (int i = 0; i < 3; i++) {
    80005440:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005442:	00016c17          	auipc	s8,0x16
    80005446:	6dec0c13          	addi	s8,s8,1758 # 8001bb20 <disk+0x128>
    8000544a:	a0ad                	j	800054b4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000544c:	00fb0733          	add	a4,s6,a5
    80005450:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005454:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005456:	0207c563          	bltz	a5,80005480 <virtio_disk_rw+0x88>
  for (int i = 0; i < 3; i++) {
    8000545a:	2905                	addiw	s2,s2,1
    8000545c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000545e:	05590f63          	beq	s2,s5,800054bc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005462:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005464:	00016717          	auipc	a4,0x16
    80005468:	59470713          	addi	a4,a4,1428 # 8001b9f8 <disk>
    8000546c:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000546e:	01874683          	lbu	a3,24(a4)
    80005472:	fee9                	bnez	a3,8000544c <virtio_disk_rw+0x54>
  for (int i = 0; i < NUM; i++) {
    80005474:	2785                	addiw	a5,a5,1
    80005476:	0705                	addi	a4,a4,1
    80005478:	fe979be3          	bne	a5,s1,8000546e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000547c:	57fd                	li	a5,-1
    8000547e:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    80005480:	03205163          	blez	s2,800054a2 <virtio_disk_rw+0xaa>
    80005484:	f9042503          	lw	a0,-112(s0)
    80005488:	00000097          	auipc	ra,0x0
    8000548c:	cc2080e7          	jalr	-830(ra) # 8000514a <free_desc>
    80005490:	4785                	li	a5,1
    80005492:	0127d863          	bge	a5,s2,800054a2 <virtio_disk_rw+0xaa>
    80005496:	f9442503          	lw	a0,-108(s0)
    8000549a:	00000097          	auipc	ra,0x0
    8000549e:	cb0080e7          	jalr	-848(ra) # 8000514a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a2:	85e2                	mv	a1,s8
    800054a4:	00016517          	auipc	a0,0x16
    800054a8:	56c50513          	addi	a0,a0,1388 # 8001ba10 <disk+0x18>
    800054ac:	ffffc097          	auipc	ra,0xffffc
    800054b0:	004080e7          	jalr	4(ra) # 800014b0 <sleep>
  for (int i = 0; i < 3; i++) {
    800054b4:	f9040613          	addi	a2,s0,-112
    800054b8:	894e                	mv	s2,s3
    800054ba:	b765                	j	80005462 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054bc:	f9042503          	lw	a0,-112(s0)
    800054c0:	00451693          	slli	a3,a0,0x4

  if (write)
    800054c4:	00016797          	auipc	a5,0x16
    800054c8:	53478793          	addi	a5,a5,1332 # 8001b9f8 <disk>
    800054cc:	00a50713          	addi	a4,a0,10
    800054d0:	0712                	slli	a4,a4,0x4
    800054d2:	973e                	add	a4,a4,a5
    800054d4:	01703633          	snez	a2,s7
    800054d8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    800054da:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800054de:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800054e2:	6398                	ld	a4,0(a5)
    800054e4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054e6:	0a868613          	addi	a2,a3,168
    800054ea:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    800054ec:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054ee:	6390                	ld	a2,0(a5)
    800054f0:	00d605b3          	add	a1,a2,a3
    800054f4:	4741                	li	a4,16
    800054f6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054f8:	4805                	li	a6,1
    800054fa:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800054fe:	f9442703          	lw	a4,-108(s0)
    80005502:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005506:	0712                	slli	a4,a4,0x4
    80005508:	963a                	add	a2,a2,a4
    8000550a:	058a0593          	addi	a1,s4,88
    8000550e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005510:	0007b883          	ld	a7,0(a5)
    80005514:	9746                	add	a4,a4,a7
    80005516:	40000613          	li	a2,1024
    8000551a:	c710                	sw	a2,8(a4)
  if (write)
    8000551c:	001bb613          	seqz	a2,s7
    80005520:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005524:	00166613          	ori	a2,a2,1
    80005528:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000552c:	f9842583          	lw	a1,-104(s0)
    80005530:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80005534:	00250613          	addi	a2,a0,2
    80005538:	0612                	slli	a2,a2,0x4
    8000553a:	963e                	add	a2,a2,a5
    8000553c:	577d                	li	a4,-1
    8000553e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005542:	0592                	slli	a1,a1,0x4
    80005544:	98ae                	add	a7,a7,a1
    80005546:	03068713          	addi	a4,a3,48
    8000554a:	973e                	add	a4,a4,a5
    8000554c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005550:	6398                	ld	a4,0(a5)
    80005552:	972e                	add	a4,a4,a1
    80005554:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005558:	4689                	li	a3,2
    8000555a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000555e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005562:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005566:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000556a:	6794                	ld	a3,8(a5)
    8000556c:	0026d703          	lhu	a4,2(a3)
    80005570:	8b1d                	andi	a4,a4,7
    80005572:	0706                	slli	a4,a4,0x1
    80005574:	96ba                	add	a3,a3,a4
    80005576:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000557a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    8000557e:	6798                	ld	a4,8(a5)
    80005580:	00275783          	lhu	a5,2(a4)
    80005584:	2785                	addiw	a5,a5,1
    80005586:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000558a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    8000558e:	100017b7          	lui	a5,0x10001
    80005592:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005596:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000559a:	00016917          	auipc	s2,0x16
    8000559e:	58690913          	addi	s2,s2,1414 # 8001bb20 <disk+0x128>
  while (b->disk == 1) {
    800055a2:	4485                	li	s1,1
    800055a4:	01079c63          	bne	a5,a6,800055bc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055a8:	85ca                	mv	a1,s2
    800055aa:	8552                	mv	a0,s4
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	f04080e7          	jalr	-252(ra) # 800014b0 <sleep>
  while (b->disk == 1) {
    800055b4:	004a2783          	lw	a5,4(s4)
    800055b8:	fe9788e3          	beq	a5,s1,800055a8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800055bc:	f9042903          	lw	s2,-112(s0)
    800055c0:	00290713          	addi	a4,s2,2
    800055c4:	0712                	slli	a4,a4,0x4
    800055c6:	00016797          	auipc	a5,0x16
    800055ca:	43278793          	addi	a5,a5,1074 # 8001b9f8 <disk>
    800055ce:	97ba                	add	a5,a5,a4
    800055d0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055d4:	00016997          	auipc	s3,0x16
    800055d8:	42498993          	addi	s3,s3,1060 # 8001b9f8 <disk>
    800055dc:	00491713          	slli	a4,s2,0x4
    800055e0:	0009b783          	ld	a5,0(s3)
    800055e4:	97ba                	add	a5,a5,a4
    800055e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055ea:	854a                	mv	a0,s2
    800055ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f0:	00000097          	auipc	ra,0x0
    800055f4:	b5a080e7          	jalr	-1190(ra) # 8000514a <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800055f8:	8885                	andi	s1,s1,1
    800055fa:	f0ed                	bnez	s1,800055dc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055fc:	00016517          	auipc	a0,0x16
    80005600:	52450513          	addi	a0,a0,1316 # 8001bb20 <disk+0x128>
    80005604:	00002097          	auipc	ra,0x2
    80005608:	96e080e7          	jalr	-1682(ra) # 80006f72 <release>
}
    8000560c:	70a6                	ld	ra,104(sp)
    8000560e:	7406                	ld	s0,96(sp)
    80005610:	64e6                	ld	s1,88(sp)
    80005612:	6946                	ld	s2,80(sp)
    80005614:	69a6                	ld	s3,72(sp)
    80005616:	6a06                	ld	s4,64(sp)
    80005618:	7ae2                	ld	s5,56(sp)
    8000561a:	7b42                	ld	s6,48(sp)
    8000561c:	7ba2                	ld	s7,40(sp)
    8000561e:	7c02                	ld	s8,32(sp)
    80005620:	6ce2                	ld	s9,24(sp)
    80005622:	6165                	addi	sp,sp,112
    80005624:	8082                	ret

0000000080005626 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005626:	1101                	addi	sp,sp,-32
    80005628:	ec06                	sd	ra,24(sp)
    8000562a:	e822                	sd	s0,16(sp)
    8000562c:	e426                	sd	s1,8(sp)
    8000562e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005630:	00016497          	auipc	s1,0x16
    80005634:	3c848493          	addi	s1,s1,968 # 8001b9f8 <disk>
    80005638:	00016517          	auipc	a0,0x16
    8000563c:	4e850513          	addi	a0,a0,1256 # 8001bb20 <disk+0x128>
    80005640:	00002097          	auipc	ra,0x2
    80005644:	87e080e7          	jalr	-1922(ra) # 80006ebe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005648:	100017b7          	lui	a5,0x10001
    8000564c:	53b8                	lw	a4,96(a5)
    8000564e:	8b0d                	andi	a4,a4,3
    80005650:	100017b7          	lui	a5,0x10001
    80005654:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005656:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    8000565a:	689c                	ld	a5,16(s1)
    8000565c:	0204d703          	lhu	a4,32(s1)
    80005660:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005664:	04f70863          	beq	a4,a5,800056b4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005668:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000566c:	6898                	ld	a4,16(s1)
    8000566e:	0204d783          	lhu	a5,32(s1)
    80005672:	8b9d                	andi	a5,a5,7
    80005674:	078e                	slli	a5,a5,0x3
    80005676:	97ba                	add	a5,a5,a4
    80005678:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    8000567a:	00278713          	addi	a4,a5,2
    8000567e:	0712                	slli	a4,a4,0x4
    80005680:	9726                	add	a4,a4,s1
    80005682:	01074703          	lbu	a4,16(a4)
    80005686:	e721                	bnez	a4,800056ce <virtio_disk_intr+0xa8>

    struct buf *b = disk.info[id].b;
    80005688:	0789                	addi	a5,a5,2
    8000568a:	0792                	slli	a5,a5,0x4
    8000568c:	97a6                	add	a5,a5,s1
    8000568e:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    80005690:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005694:	ffffc097          	auipc	ra,0xffffc
    80005698:	e80080e7          	jalr	-384(ra) # 80001514 <wakeup>

    disk.used_idx += 1;
    8000569c:	0204d783          	lhu	a5,32(s1)
    800056a0:	2785                	addiw	a5,a5,1
    800056a2:	17c2                	slli	a5,a5,0x30
    800056a4:	93c1                	srli	a5,a5,0x30
    800056a6:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800056aa:	6898                	ld	a4,16(s1)
    800056ac:	00275703          	lhu	a4,2(a4)
    800056b0:	faf71ce3          	bne	a4,a5,80005668 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800056b4:	00016517          	auipc	a0,0x16
    800056b8:	46c50513          	addi	a0,a0,1132 # 8001bb20 <disk+0x128>
    800056bc:	00002097          	auipc	ra,0x2
    800056c0:	8b6080e7          	jalr	-1866(ra) # 80006f72 <release>
}
    800056c4:	60e2                	ld	ra,24(sp)
    800056c6:	6442                	ld	s0,16(sp)
    800056c8:	64a2                	ld	s1,8(sp)
    800056ca:	6105                	addi	sp,sp,32
    800056cc:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800056ce:	00003517          	auipc	a0,0x3
    800056d2:	00a50513          	addi	a0,a0,10 # 800086d8 <etext+0x6d8>
    800056d6:	00001097          	auipc	ra,0x1
    800056da:	26e080e7          	jalr	622(ra) # 80006944 <panic>

00000000800056de <bit_isset>:
static Sz_info *bd_sizes;
static void *bd_base;  // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    800056de:	1141                	addi	sp,sp,-16
    800056e0:	e422                	sd	s0,8(sp)
    800056e2:	0800                	addi	s0,sp,16
  char b = array[index / 8];
  char m = (1 << (index % 8));
    800056e4:	0075f793          	andi	a5,a1,7
    800056e8:	4705                	li	a4,1
    800056ea:	00f7173b          	sllw	a4,a4,a5
  char b = array[index / 8];
    800056ee:	41f5d79b          	sraiw	a5,a1,0x1f
    800056f2:	01d7d79b          	srliw	a5,a5,0x1d
    800056f6:	9fad                	addw	a5,a5,a1
    800056f8:	4037d79b          	sraiw	a5,a5,0x3
    800056fc:	953e                	add	a0,a0,a5
  return (b & m) == m;
    800056fe:	00054503          	lbu	a0,0(a0)
    80005702:	8d79                	and	a0,a0,a4
    80005704:	0ff77713          	zext.b	a4,a4
    80005708:	8d19                	sub	a0,a0,a4
}
    8000570a:	00153513          	seqz	a0,a0
    8000570e:	6422                	ld	s0,8(sp)
    80005710:	0141                	addi	sp,sp,16
    80005712:	8082                	ret

0000000080005714 <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    80005714:	1141                	addi	sp,sp,-16
    80005716:	e422                	sd	s0,8(sp)
    80005718:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    8000571a:	41f5d79b          	sraiw	a5,a1,0x1f
    8000571e:	01d7d79b          	srliw	a5,a5,0x1d
    80005722:	9fad                	addw	a5,a5,a1
    80005724:	4037d79b          	sraiw	a5,a5,0x3
    80005728:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    8000572a:	899d                	andi	a1,a1,7
    8000572c:	4705                	li	a4,1
    8000572e:	00b7173b          	sllw	a4,a4,a1
  array[index / 8] = (b | m);
    80005732:	00054783          	lbu	a5,0(a0)
    80005736:	8fd9                	or	a5,a5,a4
    80005738:	00f50023          	sb	a5,0(a0)
}
    8000573c:	6422                	ld	s0,8(sp)
    8000573e:	0141                	addi	sp,sp,16
    80005740:	8082                	ret

0000000080005742 <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    80005742:	1141                	addi	sp,sp,-16
    80005744:	e422                	sd	s0,8(sp)
    80005746:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    80005748:	41f5d79b          	sraiw	a5,a1,0x1f
    8000574c:	01d7d79b          	srliw	a5,a5,0x1d
    80005750:	9fad                	addw	a5,a5,a1
    80005752:	4037d79b          	sraiw	a5,a5,0x3
    80005756:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    80005758:	899d                	andi	a1,a1,7
    8000575a:	4785                	li	a5,1
    8000575c:	00b797bb          	sllw	a5,a5,a1
  array[index / 8] = (b & ~m);
    80005760:	fff7c793          	not	a5,a5
    80005764:	00054703          	lbu	a4,0(a0)
    80005768:	8ff9                	and	a5,a5,a4
    8000576a:	00f50023          	sb	a5,0(a0)
}
    8000576e:	6422                	ld	s0,8(sp)
    80005770:	0141                	addi	sp,sp,16
    80005772:	8082                	ret

0000000080005774 <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void bd_print_vector(char *vector, int len) {
    80005774:	715d                	addi	sp,sp,-80
    80005776:	e486                	sd	ra,72(sp)
    80005778:	e0a2                	sd	s0,64(sp)
    8000577a:	f052                	sd	s4,32(sp)
    8000577c:	ec56                	sd	s5,24(sp)
    8000577e:	0880                	addi	s0,sp,80
    80005780:	8a2e                	mv	s4,a1
  int last, lb;

  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    80005782:	0ab05663          	blez	a1,8000582e <bd_print_vector+0xba>
    80005786:	fc26                	sd	s1,56(sp)
    80005788:	f84a                	sd	s2,48(sp)
    8000578a:	f44e                	sd	s3,40(sp)
    8000578c:	e85a                	sd	s6,16(sp)
    8000578e:	e45e                	sd	s7,8(sp)
    80005790:	89aa                	mv	s3,a0
    80005792:	4481                	li	s1,0
  lb = 0;
    80005794:	4a81                	li	s5,0
  last = 1;
    80005796:	4905                	li	s2,1
    if (last == bit_isset(vector, b)) continue;
    if (last == 1) printf(" [%d, %d)", lb, b);
    80005798:	4b05                	li	s6,1
    8000579a:	00003b97          	auipc	s7,0x3
    8000579e:	f56b8b93          	addi	s7,s7,-170 # 800086f0 <etext+0x6f0>
    800057a2:	a821                	j	800057ba <bd_print_vector+0x46>
    lb = b;
    last = bit_isset(vector, b);
    800057a4:	85a6                	mv	a1,s1
    800057a6:	854e                	mv	a0,s3
    800057a8:	00000097          	auipc	ra,0x0
    800057ac:	f36080e7          	jalr	-202(ra) # 800056de <bit_isset>
    800057b0:	892a                	mv	s2,a0
    lb = b;
    800057b2:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    800057b4:	2485                	addiw	s1,s1,1
    800057b6:	029a0463          	beq	s4,s1,800057de <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b)) continue;
    800057ba:	85a6                	mv	a1,s1
    800057bc:	854e                	mv	a0,s3
    800057be:	00000097          	auipc	ra,0x0
    800057c2:	f20080e7          	jalr	-224(ra) # 800056de <bit_isset>
    800057c6:	ff2507e3          	beq	a0,s2,800057b4 <bd_print_vector+0x40>
    if (last == 1) printf(" [%d, %d)", lb, b);
    800057ca:	fd691de3          	bne	s2,s6,800057a4 <bd_print_vector+0x30>
    800057ce:	8626                	mv	a2,s1
    800057d0:	85d6                	mv	a1,s5
    800057d2:	855e                	mv	a0,s7
    800057d4:	00001097          	auipc	ra,0x1
    800057d8:	1ba080e7          	jalr	442(ra) # 8000698e <printf>
    800057dc:	b7e1                	j	800057a4 <bd_print_vector+0x30>
  }
  if (lb == 0 || last == 1) {
    800057de:	040a8a63          	beqz	s5,80005832 <bd_print_vector+0xbe>
    800057e2:	4785                	li	a5,1
    800057e4:	00f90863          	beq	s2,a5,800057f4 <bd_print_vector+0x80>
    800057e8:	74e2                	ld	s1,56(sp)
    800057ea:	7942                	ld	s2,48(sp)
    800057ec:	79a2                	ld	s3,40(sp)
    800057ee:	6b42                	ld	s6,16(sp)
    800057f0:	6ba2                	ld	s7,8(sp)
    800057f2:	a005                	j	80005812 <bd_print_vector+0x9e>
    800057f4:	74e2                	ld	s1,56(sp)
    800057f6:	7942                	ld	s2,48(sp)
    800057f8:	79a2                	ld	s3,40(sp)
    800057fa:	6b42                	ld	s6,16(sp)
    800057fc:	6ba2                	ld	s7,8(sp)
    printf(" [%d, %d)", lb, len);
    800057fe:	8652                	mv	a2,s4
    80005800:	85d6                	mv	a1,s5
    80005802:	00003517          	auipc	a0,0x3
    80005806:	eee50513          	addi	a0,a0,-274 # 800086f0 <etext+0x6f0>
    8000580a:	00001097          	auipc	ra,0x1
    8000580e:	184080e7          	jalr	388(ra) # 8000698e <printf>
  }
  printf("\n");
    80005812:	00002517          	auipc	a0,0x2
    80005816:	7ee50513          	addi	a0,a0,2030 # 80008000 <etext>
    8000581a:	00001097          	auipc	ra,0x1
    8000581e:	174080e7          	jalr	372(ra) # 8000698e <printf>
}
    80005822:	60a6                	ld	ra,72(sp)
    80005824:	6406                	ld	s0,64(sp)
    80005826:	7a02                	ld	s4,32(sp)
    80005828:	6ae2                	ld	s5,24(sp)
    8000582a:	6161                	addi	sp,sp,80
    8000582c:	8082                	ret
  lb = 0;
    8000582e:	4a81                	li	s5,0
    80005830:	b7f9                	j	800057fe <bd_print_vector+0x8a>
    80005832:	74e2                	ld	s1,56(sp)
    80005834:	7942                	ld	s2,48(sp)
    80005836:	79a2                	ld	s3,40(sp)
    80005838:	6b42                	ld	s6,16(sp)
    8000583a:	6ba2                	ld	s7,8(sp)
    8000583c:	b7c9                	j	800057fe <bd_print_vector+0x8a>

000000008000583e <bd_print>:

// Print buddy's data structures
void bd_print() {
  for (int k = 0; k < nsizes; k++) {
    8000583e:	00006697          	auipc	a3,0x6
    80005842:	0826a683          	lw	a3,130(a3) # 8000b8c0 <nsizes>
    80005846:	10d05463          	blez	a3,8000594e <bd_print+0x110>
void bd_print() {
    8000584a:	711d                	addi	sp,sp,-96
    8000584c:	ec86                	sd	ra,88(sp)
    8000584e:	e8a2                	sd	s0,80(sp)
    80005850:	e4a6                	sd	s1,72(sp)
    80005852:	e0ca                	sd	s2,64(sp)
    80005854:	fc4e                	sd	s3,56(sp)
    80005856:	f852                	sd	s4,48(sp)
    80005858:	f456                	sd	s5,40(sp)
    8000585a:	f05a                	sd	s6,32(sp)
    8000585c:	ec5e                	sd	s7,24(sp)
    8000585e:	e862                	sd	s8,16(sp)
    80005860:	e466                	sd	s9,8(sp)
    80005862:	e06a                	sd	s10,0(sp)
    80005864:	1080                	addi	s0,sp,96
  for (int k = 0; k < nsizes; k++) {
    80005866:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    80005868:	4b05                	li	s6,1
    8000586a:	4cc1                	li	s9,16
    8000586c:	00003c17          	auipc	s8,0x3
    80005870:	e94c0c13          	addi	s8,s8,-364 # 80008700 <etext+0x700>
    lst_print(&bd_sizes[k].free);
    80005874:	00006a97          	auipc	s5,0x6
    80005878:	044a8a93          	addi	s5,s5,68 # 8000b8b8 <bd_sizes>
    printf("  alloc:");
    8000587c:	00003b97          	auipc	s7,0x3
    80005880:	eacb8b93          	addi	s7,s7,-340 # 80008728 <etext+0x728>
    bd_print_vector(bd_sizes[k].buddy_xor, NBLK(k) / 2);
    80005884:	00006a17          	auipc	s4,0x6
    80005888:	03ca0a13          	addi	s4,s4,60 # 8000b8c0 <nsizes>
    if (k > 0) {
      printf("  split:");
    8000588c:	00003d17          	auipc	s10,0x3
    80005890:	eacd0d13          	addi	s10,s10,-340 # 80008738 <etext+0x738>
    80005894:	a801                	j	800058a4 <bd_print+0x66>
  for (int k = 0; k < nsizes; k++) {
    80005896:	000a2683          	lw	a3,0(s4)
    8000589a:	0485                	addi	s1,s1,1
    8000589c:	0004879b          	sext.w	a5,s1
    800058a0:	08d7d963          	bge	a5,a3,80005932 <bd_print+0xf4>
    800058a4:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    800058a8:	36fd                	addiw	a3,a3,-1
    800058aa:	9e85                	subw	a3,a3,s1
    800058ac:	00db16bb          	sllw	a3,s6,a3
    800058b0:	009c9633          	sll	a2,s9,s1
    800058b4:	85ca                	mv	a1,s2
    800058b6:	8562                	mv	a0,s8
    800058b8:	00001097          	auipc	ra,0x1
    800058bc:	0d6080e7          	jalr	214(ra) # 8000698e <printf>
    lst_print(&bd_sizes[k].free);
    800058c0:	00549993          	slli	s3,s1,0x5
    800058c4:	000ab503          	ld	a0,0(s5)
    800058c8:	954e                	add	a0,a0,s3
    800058ca:	00001097          	auipc	ra,0x1
    800058ce:	ae8080e7          	jalr	-1304(ra) # 800063b2 <lst_print>
    printf("  alloc:");
    800058d2:	855e                	mv	a0,s7
    800058d4:	00001097          	auipc	ra,0x1
    800058d8:	0ba080e7          	jalr	186(ra) # 8000698e <printf>
    bd_print_vector(bd_sizes[k].buddy_xor, NBLK(k) / 2);
    800058dc:	000a2783          	lw	a5,0(s4)
    800058e0:	37fd                	addiw	a5,a5,-1
    800058e2:	412787bb          	subw	a5,a5,s2
    800058e6:	00fb17bb          	sllw	a5,s6,a5
    800058ea:	01f7d59b          	srliw	a1,a5,0x1f
    800058ee:	9dbd                	addw	a1,a1,a5
    800058f0:	000ab783          	ld	a5,0(s5)
    800058f4:	97ce                	add	a5,a5,s3
    800058f6:	4015d59b          	sraiw	a1,a1,0x1
    800058fa:	6b88                	ld	a0,16(a5)
    800058fc:	00000097          	auipc	ra,0x0
    80005900:	e78080e7          	jalr	-392(ra) # 80005774 <bd_print_vector>
    if (k > 0) {
    80005904:	f92059e3          	blez	s2,80005896 <bd_print+0x58>
      printf("  split:");
    80005908:	856a                	mv	a0,s10
    8000590a:	00001097          	auipc	ra,0x1
    8000590e:	084080e7          	jalr	132(ra) # 8000698e <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    80005912:	000a2583          	lw	a1,0(s4)
    80005916:	35fd                	addiw	a1,a1,-1
    80005918:	412585bb          	subw	a1,a1,s2
    8000591c:	000ab783          	ld	a5,0(s5)
    80005920:	97ce                	add	a5,a5,s3
    80005922:	00bb15bb          	sllw	a1,s6,a1
    80005926:	6f88                	ld	a0,24(a5)
    80005928:	00000097          	auipc	ra,0x0
    8000592c:	e4c080e7          	jalr	-436(ra) # 80005774 <bd_print_vector>
    80005930:	b79d                	j	80005896 <bd_print+0x58>
    }
  }
}
    80005932:	60e6                	ld	ra,88(sp)
    80005934:	6446                	ld	s0,80(sp)
    80005936:	64a6                	ld	s1,72(sp)
    80005938:	6906                	ld	s2,64(sp)
    8000593a:	79e2                	ld	s3,56(sp)
    8000593c:	7a42                	ld	s4,48(sp)
    8000593e:	7aa2                	ld	s5,40(sp)
    80005940:	7b02                	ld	s6,32(sp)
    80005942:	6be2                	ld	s7,24(sp)
    80005944:	6c42                	ld	s8,16(sp)
    80005946:	6ca2                	ld	s9,8(sp)
    80005948:	6d02                	ld	s10,0(sp)
    8000594a:	6125                	addi	sp,sp,96
    8000594c:	8082                	ret
    8000594e:	8082                	ret

0000000080005950 <firstk>:

// What is the first k such that 2^k >= n?
int firstk(uint64 n) {
    80005950:	1141                	addi	sp,sp,-16
    80005952:	e422                	sd	s0,8(sp)
    80005954:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    80005956:	47c1                	li	a5,16
    80005958:	00a7fb63          	bgeu	a5,a0,8000596e <firstk+0x1e>
    8000595c:	872a                	mv	a4,a0
  int k = 0;
    8000595e:	4501                	li	a0,0
    k++;
    80005960:	2505                	addiw	a0,a0,1
    size *= 2;
    80005962:	0786                	slli	a5,a5,0x1
  while (size < n) {
    80005964:	fee7eee3          	bltu	a5,a4,80005960 <firstk+0x10>
  }
  return k;
}
    80005968:	6422                	ld	s0,8(sp)
    8000596a:	0141                	addi	sp,sp,16
    8000596c:	8082                	ret
  int k = 0;
    8000596e:	4501                	li	a0,0
    80005970:	bfe5                	j	80005968 <firstk+0x18>

0000000080005972 <blk_index>:

// Compute the block index for address p at size k
int blk_index(int k, char *p) {
    80005972:	1141                	addi	sp,sp,-16
    80005974:	e422                	sd	s0,8(sp)
    80005976:	0800                	addi	s0,sp,16
  int n = p - (char *)bd_base;
  return n / BLK_SIZE(k);
    80005978:	00006797          	auipc	a5,0x6
    8000597c:	f387b783          	ld	a5,-200(a5) # 8000b8b0 <bd_base>
    80005980:	9d9d                	subw	a1,a1,a5
    80005982:	47c1                	li	a5,16
    80005984:	00a797b3          	sll	a5,a5,a0
    80005988:	02f5c5b3          	div	a1,a1,a5
}
    8000598c:	0005851b          	sext.w	a0,a1
    80005990:	6422                	ld	s0,8(sp)
    80005992:	0141                	addi	sp,sp,16
    80005994:	8082                	ret

0000000080005996 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    80005996:	1141                	addi	sp,sp,-16
    80005998:	e422                	sd	s0,8(sp)
    8000599a:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    8000599c:	47c1                	li	a5,16
    8000599e:	00a797b3          	sll	a5,a5,a0
  return (char *)bd_base + n;
    800059a2:	02b787bb          	mulw	a5,a5,a1
}
    800059a6:	00006517          	auipc	a0,0x6
    800059aa:	f0a53503          	ld	a0,-246(a0) # 8000b8b0 <bd_base>
    800059ae:	953e                	add	a0,a0,a5
    800059b0:	6422                	ld	s0,8(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret

00000000800059b6 <bit_flip>:

void bit_flip(char *array, int index) {
    800059b6:	1141                	addi	sp,sp,-16
    800059b8:	e422                	sd	s0,8(sp)
    800059ba:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    800059bc:	41f5d79b          	sraiw	a5,a1,0x1f
    800059c0:	01d7d79b          	srliw	a5,a5,0x1d
    800059c4:	9fad                	addw	a5,a5,a1
    800059c6:	4037d79b          	sraiw	a5,a5,0x3
    800059ca:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    800059cc:	899d                	andi	a1,a1,7
    800059ce:	4705                	li	a4,1
    800059d0:	00b7173b          	sllw	a4,a4,a1
  array[index / 8] = (b ^ m);
    800059d4:	00054783          	lbu	a5,0(a0)
    800059d8:	8fb9                	xor	a5,a5,a4
    800059da:	00f50023          	sb	a5,0(a0)
}
    800059de:	6422                	ld	s0,8(sp)
    800059e0:	0141                	addi	sp,sp,16
    800059e2:	8082                	ret

00000000800059e4 <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *bd_malloc(uint64 nbytes) {
    800059e4:	7159                	addi	sp,sp,-112
    800059e6:	f486                	sd	ra,104(sp)
    800059e8:	f0a2                	sd	s0,96(sp)
    800059ea:	eca6                	sd	s1,88(sp)
    800059ec:	fc56                	sd	s5,56(sp)
    800059ee:	1880                	addi	s0,sp,112
    800059f0:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    800059f2:	00016517          	auipc	a0,0x16
    800059f6:	14650513          	addi	a0,a0,326 # 8001bb38 <lock>
    800059fa:	00001097          	auipc	ra,0x1
    800059fe:	4c4080e7          	jalr	1220(ra) # 80006ebe <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    80005a02:	8526                	mv	a0,s1
    80005a04:	00000097          	auipc	ra,0x0
    80005a08:	f4c080e7          	jalr	-180(ra) # 80005950 <firstk>
  for (k = fk; k < nsizes; k++) {
    80005a0c:	00006797          	auipc	a5,0x6
    80005a10:	eb47a783          	lw	a5,-332(a5) # 8000b8c0 <nsizes>
    80005a14:	04f55563          	bge	a0,a5,80005a5e <bd_malloc+0x7a>
    80005a18:	e8ca                	sd	s2,80(sp)
    80005a1a:	e4ce                	sd	s3,72(sp)
    80005a1c:	e0d2                	sd	s4,64(sp)
    80005a1e:	f45e                	sd	s7,40(sp)
    80005a20:	8baa                	mv	s7,a0
    80005a22:	00551913          	slli	s2,a0,0x5
    80005a26:	84aa                	mv	s1,a0
    if (!lst_empty(&bd_sizes[k].free)) break;
    80005a28:	00006997          	auipc	s3,0x6
    80005a2c:	e9098993          	addi	s3,s3,-368 # 8000b8b8 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    80005a30:	00006a17          	auipc	s4,0x6
    80005a34:	e90a0a13          	addi	s4,s4,-368 # 8000b8c0 <nsizes>
    if (!lst_empty(&bd_sizes[k].free)) break;
    80005a38:	0009b503          	ld	a0,0(s3)
    80005a3c:	954a                	add	a0,a0,s2
    80005a3e:	00001097          	auipc	ra,0x1
    80005a42:	8fa080e7          	jalr	-1798(ra) # 80006338 <lst_empty>
    80005a46:	c515                	beqz	a0,80005a72 <bd_malloc+0x8e>
  for (k = fk; k < nsizes; k++) {
    80005a48:	2485                	addiw	s1,s1,1
    80005a4a:	02090913          	addi	s2,s2,32
    80005a4e:	000a2783          	lw	a5,0(s4)
    80005a52:	fef4c3e3          	blt	s1,a5,80005a38 <bd_malloc+0x54>
    80005a56:	6946                	ld	s2,80(sp)
    80005a58:	69a6                	ld	s3,72(sp)
    80005a5a:	6a06                	ld	s4,64(sp)
    80005a5c:	7ba2                	ld	s7,40(sp)
  }
  if (k >= nsizes) {  // No free blocks?
    release(&lock);
    80005a5e:	00016517          	auipc	a0,0x16
    80005a62:	0da50513          	addi	a0,a0,218 # 8001bb38 <lock>
    80005a66:	00001097          	auipc	ra,0x1
    80005a6a:	50c080e7          	jalr	1292(ra) # 80006f72 <release>
    return 0;
    80005a6e:	4a81                	li	s5,0
    80005a70:	a8dd                	j	80005b66 <bd_malloc+0x182>
  if (k >= nsizes) {  // No free blocks?
    80005a72:	00006797          	auipc	a5,0x6
    80005a76:	e4e7a783          	lw	a5,-434(a5) # 8000b8c0 <nsizes>
    80005a7a:	0ef4dd63          	bge	s1,a5,80005b74 <bd_malloc+0x190>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    80005a7e:	00549993          	slli	s3,s1,0x5
    80005a82:	00006917          	auipc	s2,0x6
    80005a86:	e3690913          	addi	s2,s2,-458 # 8000b8b8 <bd_sizes>
    80005a8a:	00093503          	ld	a0,0(s2)
    80005a8e:	954e                	add	a0,a0,s3
    80005a90:	00001097          	auipc	ra,0x1
    80005a94:	8d4080e7          	jalr	-1836(ra) # 80006364 <lst_pop>
    80005a98:	8aaa                	mv	s5,a0
  return n / BLK_SIZE(k);
    80005a9a:	00006797          	auipc	a5,0x6
    80005a9e:	e167b783          	ld	a5,-490(a5) # 8000b8b0 <bd_base>
    80005aa2:	40f507bb          	subw	a5,a0,a5
    80005aa6:	4741                	li	a4,16
    80005aa8:	00971733          	sll	a4,a4,s1
    80005aac:	02e7c7b3          	div	a5,a5,a4
  bit_flip(bd_sizes[k].buddy_xor, blk_index(k, p) / 2);
    80005ab0:	01f7d59b          	srliw	a1,a5,0x1f
    80005ab4:	9dbd                	addw	a1,a1,a5
    80005ab6:	00093783          	ld	a5,0(s2)
    80005aba:	97ce                	add	a5,a5,s3
    80005abc:	4015d59b          	sraiw	a1,a1,0x1
    80005ac0:	6b88                	ld	a0,16(a5)
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	ef4080e7          	jalr	-268(ra) # 800059b6 <bit_flip>
  for (; k > fk; k--) {
    80005aca:	089bd263          	bge	s7,s1,80005b4e <bd_malloc+0x16a>
    80005ace:	f85a                	sd	s6,48(sp)
    80005ad0:	f062                	sd	s8,32(sp)
    80005ad2:	ec66                	sd	s9,24(sp)
    80005ad4:	e86a                	sd	s10,16(sp)
    80005ad6:	e46e                	sd	s11,8(sp)
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k - 1);  // p's buddy
    80005ad8:	4b41                	li	s6,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80005ada:	8d4a                	mv	s10,s2
  int n = p - (char *)bd_base;
    80005adc:	00006c97          	auipc	s9,0x6
    80005ae0:	dd4c8c93          	addi	s9,s9,-556 # 8000b8b0 <bd_base>
    char *q = p + BLK_SIZE(k - 1);  // p's buddy
    80005ae4:	85a6                	mv	a1,s1
    80005ae6:	34fd                	addiw	s1,s1,-1
    80005ae8:	009b1db3          	sll	s11,s6,s1
    80005aec:	01ba8c33          	add	s8,s5,s11
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80005af0:	000d3a03          	ld	s4,0(s10)
  int n = p - (char *)bd_base;
    80005af4:	000cb903          	ld	s2,0(s9)
  return n / BLK_SIZE(k);
    80005af8:	412a893b          	subw	s2,s5,s2
    80005afc:	00bb15b3          	sll	a1,s6,a1
    80005b00:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80005b04:	013a07b3          	add	a5,s4,s3
    80005b08:	2581                	sext.w	a1,a1
    80005b0a:	6f88                	ld	a0,24(a5)
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	c08080e7          	jalr	-1016(ra) # 80005714 <bit_set>
    bit_flip(bd_sizes[k - 1].buddy_xor, blk_index(k - 1, p) / 2);
    80005b14:	1981                	addi	s3,s3,-32
    80005b16:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    80005b18:	03b94933          	div	s2,s2,s11
    bit_flip(bd_sizes[k - 1].buddy_xor, blk_index(k - 1, p) / 2);
    80005b1c:	01f9559b          	srliw	a1,s2,0x1f
    80005b20:	012585bb          	addw	a1,a1,s2
    80005b24:	4015d59b          	sraiw	a1,a1,0x1
    80005b28:	010a3503          	ld	a0,16(s4)
    80005b2c:	00000097          	auipc	ra,0x0
    80005b30:	e8a080e7          	jalr	-374(ra) # 800059b6 <bit_flip>
    lst_push(&bd_sizes[k - 1].free, q);
    80005b34:	85e2                	mv	a1,s8
    80005b36:	8552                	mv	a0,s4
    80005b38:	00001097          	auipc	ra,0x1
    80005b3c:	862080e7          	jalr	-1950(ra) # 8000639a <lst_push>
  for (; k > fk; k--) {
    80005b40:	fb7492e3          	bne	s1,s7,80005ae4 <bd_malloc+0x100>
    80005b44:	7b42                	ld	s6,48(sp)
    80005b46:	7c02                	ld	s8,32(sp)
    80005b48:	6ce2                	ld	s9,24(sp)
    80005b4a:	6d42                	ld	s10,16(sp)
    80005b4c:	6da2                	ld	s11,8(sp)
  }
  release(&lock);
    80005b4e:	00016517          	auipc	a0,0x16
    80005b52:	fea50513          	addi	a0,a0,-22 # 8001bb38 <lock>
    80005b56:	00001097          	auipc	ra,0x1
    80005b5a:	41c080e7          	jalr	1052(ra) # 80006f72 <release>
    80005b5e:	6946                	ld	s2,80(sp)
    80005b60:	69a6                	ld	s3,72(sp)
    80005b62:	6a06                	ld	s4,64(sp)
    80005b64:	7ba2                	ld	s7,40(sp)

  return p;
}
    80005b66:	8556                	mv	a0,s5
    80005b68:	70a6                	ld	ra,104(sp)
    80005b6a:	7406                	ld	s0,96(sp)
    80005b6c:	64e6                	ld	s1,88(sp)
    80005b6e:	7ae2                	ld	s5,56(sp)
    80005b70:	6165                	addi	sp,sp,112
    80005b72:	8082                	ret
    80005b74:	6946                	ld	s2,80(sp)
    80005b76:	69a6                	ld	s3,72(sp)
    80005b78:	6a06                	ld	s4,64(sp)
    80005b7a:	7ba2                	ld	s7,40(sp)
    80005b7c:	b5cd                	j	80005a5e <bd_malloc+0x7a>

0000000080005b7e <size>:

// Find the size of the block that p points to.
int size(char *p) {
    80005b7e:	7139                	addi	sp,sp,-64
    80005b80:	fc06                	sd	ra,56(sp)
    80005b82:	f822                	sd	s0,48(sp)
    80005b84:	f426                	sd	s1,40(sp)
    80005b86:	f04a                	sd	s2,32(sp)
    80005b88:	ec4e                	sd	s3,24(sp)
    80005b8a:	e852                	sd	s4,16(sp)
    80005b8c:	e456                	sd	s5,8(sp)
    80005b8e:	e05a                	sd	s6,0(sp)
    80005b90:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    80005b92:	00006a97          	auipc	s5,0x6
    80005b96:	d2eaaa83          	lw	s5,-722(s5) # 8000b8c0 <nsizes>
  return n / BLK_SIZE(k);
    80005b9a:	00006797          	auipc	a5,0x6
    80005b9e:	d167b783          	ld	a5,-746(a5) # 8000b8b0 <bd_base>
    80005ba2:	40f50a3b          	subw	s4,a0,a5
    80005ba6:	00006497          	auipc	s1,0x6
    80005baa:	d124b483          	ld	s1,-750(s1) # 8000b8b8 <bd_sizes>
    80005bae:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    80005bb2:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    80005bb4:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    80005bb6:	03595363          	bge	s2,s5,80005bdc <size+0x5e>
    if (bit_isset(bd_sizes[k + 1].split, blk_index(k + 1, p))) {
    80005bba:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80005bbe:	013b15b3          	sll	a1,s6,s3
    80005bc2:	02ba45b3          	div	a1,s4,a1
    if (bit_isset(bd_sizes[k + 1].split, blk_index(k + 1, p))) {
    80005bc6:	2581                	sext.w	a1,a1
    80005bc8:	6088                	ld	a0,0(s1)
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	b14080e7          	jalr	-1260(ra) # 800056de <bit_isset>
    80005bd2:	02048493          	addi	s1,s1,32
    80005bd6:	e501                	bnez	a0,80005bde <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80005bd8:	894e                	mv	s2,s3
    80005bda:	bff1                	j	80005bb6 <size+0x38>
      return k;
    }
  }
  return 0;
    80005bdc:	4901                	li	s2,0
}
    80005bde:	854a                	mv	a0,s2
    80005be0:	70e2                	ld	ra,56(sp)
    80005be2:	7442                	ld	s0,48(sp)
    80005be4:	74a2                	ld	s1,40(sp)
    80005be6:	7902                	ld	s2,32(sp)
    80005be8:	69e2                	ld	s3,24(sp)
    80005bea:	6a42                	ld	s4,16(sp)
    80005bec:	6aa2                	ld	s5,8(sp)
    80005bee:	6b02                	ld	s6,0(sp)
    80005bf0:	6121                	addi	sp,sp,64
    80005bf2:	8082                	ret

0000000080005bf4 <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void bd_free(void *p) {
    80005bf4:	7159                	addi	sp,sp,-112
    80005bf6:	f486                	sd	ra,104(sp)
    80005bf8:	f0a2                	sd	s0,96(sp)
    80005bfa:	e4ce                	sd	s3,72(sp)
    80005bfc:	f062                	sd	s8,32(sp)
    80005bfe:	1880                	addi	s0,sp,112
    80005c00:	8c2a                	mv	s8,a0
  void *q;
  int k;

  acquire(&lock);
    80005c02:	00016517          	auipc	a0,0x16
    80005c06:	f3650513          	addi	a0,a0,-202 # 8001bb38 <lock>
    80005c0a:	00001097          	auipc	ra,0x1
    80005c0e:	2b4080e7          	jalr	692(ra) # 80006ebe <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    80005c12:	8562                	mv	a0,s8
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	f6a080e7          	jalr	-150(ra) # 80005b7e <size>
    80005c1c:	89aa                	mv	s3,a0
    80005c1e:	00006797          	auipc	a5,0x6
    80005c22:	ca27a783          	lw	a5,-862(a5) # 8000b8c0 <nsizes>
    80005c26:	37fd                	addiw	a5,a5,-1
    80005c28:	0ef55c63          	bge	a0,a5,80005d20 <bd_free+0x12c>
    80005c2c:	eca6                	sd	s1,88(sp)
    80005c2e:	e8ca                	sd	s2,80(sp)
    80005c30:	e0d2                	sd	s4,64(sp)
    80005c32:	fc56                	sd	s5,56(sp)
    80005c34:	f85a                	sd	s6,48(sp)
    80005c36:	f45e                	sd	s7,40(sp)
    80005c38:	ec66                	sd	s9,24(sp)
    80005c3a:	e86a                	sd	s10,16(sp)
    80005c3c:	e46e                	sd	s11,8(sp)
    80005c3e:	00150b93          	addi	s7,a0,1
    80005c42:	0b96                	slli	s7,s7,0x5
  int n = p - (char *)bd_base;
    80005c44:	00006d97          	auipc	s11,0x6
    80005c48:	c6cd8d93          	addi	s11,s11,-916 # 8000b8b0 <bd_base>
  return n / BLK_SIZE(k);
    80005c4c:	4d41                	li	s10,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    bit_flip(bd_sizes[k].buddy_xor, buddy / 2);         // free p at size k
    80005c4e:	00006c97          	auipc	s9,0x6
    80005c52:	c6ac8c93          	addi	s9,s9,-918 # 8000b8b8 <bd_sizes>
    80005c56:	a83d                	j	80005c94 <bd_free+0xa0>
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005c58:	34fd                	addiw	s1,s1,-1
    80005c5a:	a891                	j	80005cae <bd_free+0xba>
    if (buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k + 1].split, blk_index(k + 1, p));
    80005c5c:	2985                	addiw	s3,s3,1
  int n = p - (char *)bd_base;
    80005c5e:	000db583          	ld	a1,0(s11)
  return n / BLK_SIZE(k);
    80005c62:	40bc05bb          	subw	a1,s8,a1
    80005c66:	013d17b3          	sll	a5,s10,s3
    80005c6a:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k + 1].split, blk_index(k + 1, p));
    80005c6e:	000cb783          	ld	a5,0(s9)
    80005c72:	97de                	add	a5,a5,s7
    80005c74:	2581                	sext.w	a1,a1
    80005c76:	6f88                	ld	a0,24(a5)
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	aca080e7          	jalr	-1334(ra) # 80005742 <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    80005c80:	020b8b93          	addi	s7,s7,32
    80005c84:	00006797          	auipc	a5,0x6
    80005c88:	c3c78793          	addi	a5,a5,-964 # 8000b8c0 <nsizes>
    80005c8c:	439c                	lw	a5,0(a5)
    80005c8e:	37fd                	addiw	a5,a5,-1
    80005c90:	06f9d563          	bge	s3,a5,80005cfa <bd_free+0x106>
  int n = p - (char *)bd_base;
    80005c94:	000dba03          	ld	s4,0(s11)
  return n / BLK_SIZE(k);
    80005c98:	013d1b33          	sll	s6,s10,s3
    80005c9c:	414c07bb          	subw	a5,s8,s4
    80005ca0:	0367c7b3          	div	a5,a5,s6
    80005ca4:	0007849b          	sext.w	s1,a5
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005ca8:	8b85                	andi	a5,a5,1
    80005caa:	f7dd                	bnez	a5,80005c58 <bd_free+0x64>
    80005cac:	2485                	addiw	s1,s1,1
    bit_flip(bd_sizes[k].buddy_xor, buddy / 2);         // free p at size k
    80005cae:	fe0b8793          	addi	a5,s7,-32
    80005cb2:	000cba83          	ld	s5,0(s9)
    80005cb6:	9abe                	add	s5,s5,a5
    80005cb8:	01f4d91b          	srliw	s2,s1,0x1f
    80005cbc:	0099093b          	addw	s2,s2,s1
    80005cc0:	4019591b          	sraiw	s2,s2,0x1
    80005cc4:	85ca                	mv	a1,s2
    80005cc6:	010ab503          	ld	a0,16(s5)
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	cec080e7          	jalr	-788(ra) # 800059b6 <bit_flip>
    if (bit_isset(bd_sizes[k].buddy_xor, buddy / 2)) {  // is buddy allocated?
    80005cd2:	85ca                	mv	a1,s2
    80005cd4:	010ab503          	ld	a0,16(s5)
    80005cd8:	00000097          	auipc	ra,0x0
    80005cdc:	a06080e7          	jalr	-1530(ra) # 800056de <bit_isset>
    80005ce0:	e51d                	bnez	a0,80005d0e <bd_free+0x11a>
  return (char *)bd_base + n;
    80005ce2:	029b0b3b          	mulw	s6,s6,s1
    80005ce6:	9a5a                	add	s4,s4,s6
    lst_remove(q);  // remove buddy from free list
    80005ce8:	8552                	mv	a0,s4
    80005cea:	00000097          	auipc	ra,0x0
    80005cee:	664080e7          	jalr	1636(ra) # 8000634e <lst_remove>
    if (buddy % 2 == 0) {
    80005cf2:	8885                	andi	s1,s1,1
    80005cf4:	f4a5                	bnez	s1,80005c5c <bd_free+0x68>
      p = q;
    80005cf6:	8c52                	mv	s8,s4
    80005cf8:	b795                	j	80005c5c <bd_free+0x68>
    80005cfa:	64e6                	ld	s1,88(sp)
    80005cfc:	6946                	ld	s2,80(sp)
    80005cfe:	6a06                	ld	s4,64(sp)
    80005d00:	7ae2                	ld	s5,56(sp)
    80005d02:	7b42                	ld	s6,48(sp)
    80005d04:	7ba2                	ld	s7,40(sp)
    80005d06:	6ce2                	ld	s9,24(sp)
    80005d08:	6d42                	ld	s10,16(sp)
    80005d0a:	6da2                	ld	s11,8(sp)
    80005d0c:	a811                	j	80005d20 <bd_free+0x12c>
    80005d0e:	64e6                	ld	s1,88(sp)
    80005d10:	6946                	ld	s2,80(sp)
    80005d12:	6a06                	ld	s4,64(sp)
    80005d14:	7ae2                	ld	s5,56(sp)
    80005d16:	7b42                	ld	s6,48(sp)
    80005d18:	7ba2                	ld	s7,40(sp)
    80005d1a:	6ce2                	ld	s9,24(sp)
    80005d1c:	6d42                	ld	s10,16(sp)
    80005d1e:	6da2                	ld	s11,8(sp)
  }
  lst_push(&bd_sizes[k].free, p);
    80005d20:	0996                	slli	s3,s3,0x5
    80005d22:	85e2                	mv	a1,s8
    80005d24:	00006517          	auipc	a0,0x6
    80005d28:	b9453503          	ld	a0,-1132(a0) # 8000b8b8 <bd_sizes>
    80005d2c:	954e                	add	a0,a0,s3
    80005d2e:	00000097          	auipc	ra,0x0
    80005d32:	66c080e7          	jalr	1644(ra) # 8000639a <lst_push>
  release(&lock);
    80005d36:	00016517          	auipc	a0,0x16
    80005d3a:	e0250513          	addi	a0,a0,-510 # 8001bb38 <lock>
    80005d3e:	00001097          	auipc	ra,0x1
    80005d42:	234080e7          	jalr	564(ra) # 80006f72 <release>
}
    80005d46:	70a6                	ld	ra,104(sp)
    80005d48:	7406                	ld	s0,96(sp)
    80005d4a:	69a6                	ld	s3,72(sp)
    80005d4c:	7c02                	ld	s8,32(sp)
    80005d4e:	6165                	addi	sp,sp,112
    80005d50:	8082                	ret

0000000080005d52 <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int blk_index_next(int k, char *p) {
    80005d52:	1141                	addi	sp,sp,-16
    80005d54:	e422                	sd	s0,8(sp)
    80005d56:	0800                	addi	s0,sp,16
  int n = (p - (char *)bd_base) / BLK_SIZE(k);
    80005d58:	00006797          	auipc	a5,0x6
    80005d5c:	b587b783          	ld	a5,-1192(a5) # 8000b8b0 <bd_base>
    80005d60:	8d9d                	sub	a1,a1,a5
    80005d62:	47c1                	li	a5,16
    80005d64:	00a797b3          	sll	a5,a5,a0
    80005d68:	02f5c533          	div	a0,a1,a5
    80005d6c:	2501                	sext.w	a0,a0
  if ((p - (char *)bd_base) % BLK_SIZE(k) != 0) n++;
    80005d6e:	02f5e5b3          	rem	a1,a1,a5
    80005d72:	c191                	beqz	a1,80005d76 <blk_index_next+0x24>
    80005d74:	2505                	addiw	a0,a0,1
  return n;
}
    80005d76:	6422                	ld	s0,8(sp)
    80005d78:	0141                	addi	sp,sp,16
    80005d7a:	8082                	ret

0000000080005d7c <log2>:

int log2(uint64 n) {
    80005d7c:	1141                	addi	sp,sp,-16
    80005d7e:	e422                	sd	s0,8(sp)
    80005d80:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80005d82:	4705                	li	a4,1
    80005d84:	00a77b63          	bgeu	a4,a0,80005d9a <log2+0x1e>
    80005d88:	87aa                	mv	a5,a0
  int k = 0;
    80005d8a:	4501                	li	a0,0
    k++;
    80005d8c:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80005d8e:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80005d90:	fef76ee3          	bltu	a4,a5,80005d8c <log2+0x10>
  }
  return k;
}
    80005d94:	6422                	ld	s0,8(sp)
    80005d96:	0141                	addi	sp,sp,16
    80005d98:	8082                	ret
  int k = 0;
    80005d9a:	4501                	li	a0,0
    80005d9c:	bfe5                	j	80005d94 <log2+0x18>

0000000080005d9e <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated.
void bd_mark(void *start, void *stop) {
    80005d9e:	711d                	addi	sp,sp,-96
    80005da0:	ec86                	sd	ra,88(sp)
    80005da2:	e8a2                	sd	s0,80(sp)
    80005da4:	e0ca                	sd	s2,64(sp)
    80005da6:	1080                	addi	s0,sp,96
  int bi, bj;

  if (((uint64)start % LEAF_SIZE != 0) || ((uint64)stop % LEAF_SIZE != 0))
    80005da8:	00b56933          	or	s2,a0,a1
    80005dac:	00f97913          	andi	s2,s2,15
    80005db0:	02091e63          	bnez	s2,80005dec <bd_mark+0x4e>
    80005db4:	fc4e                	sd	s3,56(sp)
    80005db6:	f456                	sd	s5,40(sp)
    80005db8:	f05a                	sd	s6,32(sp)
    80005dba:	ec5e                	sd	s7,24(sp)
    80005dbc:	e862                	sd	s8,16(sp)
    80005dbe:	e466                	sd	s9,8(sp)
    80005dc0:	e06a                	sd	s10,0(sp)
    80005dc2:	8b2a                	mv	s6,a0
    80005dc4:	8bae                	mv	s7,a1
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80005dc6:	00006c17          	auipc	s8,0x6
    80005dca:	afac2c03          	lw	s8,-1286(s8) # 8000b8c0 <nsizes>
    80005dce:	4981                	li	s3,0
  int n = p - (char *)bd_base;
    80005dd0:	00006d17          	auipc	s10,0x6
    80005dd4:	ae0d0d13          	addi	s10,s10,-1312 # 8000b8b0 <bd_base>
  return n / BLK_SIZE(k);
    80005dd8:	4cc1                	li	s9,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for (; bi < bj; bi++) {
      if (k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80005dda:	00006a97          	auipc	s5,0x6
    80005dde:	adea8a93          	addi	s5,s5,-1314 # 8000b8b8 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80005de2:	09805c63          	blez	s8,80005e7a <bd_mark+0xdc>
    80005de6:	e4a6                	sd	s1,72(sp)
    80005de8:	f852                	sd	s4,48(sp)
    80005dea:	a09d                	j	80005e50 <bd_mark+0xb2>
    80005dec:	e4a6                	sd	s1,72(sp)
    80005dee:	fc4e                	sd	s3,56(sp)
    80005df0:	f852                	sd	s4,48(sp)
    80005df2:	f456                	sd	s5,40(sp)
    80005df4:	f05a                	sd	s6,32(sp)
    80005df6:	ec5e                	sd	s7,24(sp)
    80005df8:	e862                	sd	s8,16(sp)
    80005dfa:	e466                	sd	s9,8(sp)
    80005dfc:	e06a                	sd	s10,0(sp)
    panic("bd_mark");
    80005dfe:	00003517          	auipc	a0,0x3
    80005e02:	94a50513          	addi	a0,a0,-1718 # 80008748 <etext+0x748>
    80005e06:	00001097          	auipc	ra,0x1
    80005e0a:	b3e080e7          	jalr	-1218(ra) # 80006944 <panic>
      }
      bit_flip(bd_sizes[k].buddy_xor, bi / 2);
    80005e0e:	01f4d59b          	srliw	a1,s1,0x1f
    80005e12:	9da5                	addw	a1,a1,s1
    80005e14:	000ab783          	ld	a5,0(s5)
    80005e18:	97ca                	add	a5,a5,s2
    80005e1a:	4015d59b          	sraiw	a1,a1,0x1
    80005e1e:	6b88                	ld	a0,16(a5)
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	b96080e7          	jalr	-1130(ra) # 800059b6 <bit_flip>
    for (; bi < bj; bi++) {
    80005e28:	2485                	addiw	s1,s1,1
    80005e2a:	009a0e63          	beq	s4,s1,80005e46 <bd_mark+0xa8>
      if (k > 0) {
    80005e2e:	ff3050e3          	blez	s3,80005e0e <bd_mark+0x70>
        bit_set(bd_sizes[k].split, bi);
    80005e32:	000ab783          	ld	a5,0(s5)
    80005e36:	97ca                	add	a5,a5,s2
    80005e38:	85a6                	mv	a1,s1
    80005e3a:	6f88                	ld	a0,24(a5)
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	8d8080e7          	jalr	-1832(ra) # 80005714 <bit_set>
    80005e44:	b7e9                	j	80005e0e <bd_mark+0x70>
  for (int k = 0; k < nsizes; k++) {
    80005e46:	2985                	addiw	s3,s3,1
    80005e48:	02090913          	addi	s2,s2,32
    80005e4c:	03898563          	beq	s3,s8,80005e76 <bd_mark+0xd8>
  int n = p - (char *)bd_base;
    80005e50:	000d3483          	ld	s1,0(s10)
  return n / BLK_SIZE(k);
    80005e54:	409b04bb          	subw	s1,s6,s1
    80005e58:	013c97b3          	sll	a5,s9,s3
    80005e5c:	02f4c4b3          	div	s1,s1,a5
    80005e60:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80005e62:	85de                	mv	a1,s7
    80005e64:	854e                	mv	a0,s3
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	eec080e7          	jalr	-276(ra) # 80005d52 <blk_index_next>
    80005e6e:	8a2a                	mv	s4,a0
    for (; bi < bj; bi++) {
    80005e70:	faa4cfe3          	blt	s1,a0,80005e2e <bd_mark+0x90>
    80005e74:	bfc9                	j	80005e46 <bd_mark+0xa8>
    80005e76:	64a6                	ld	s1,72(sp)
    80005e78:	7a42                	ld	s4,48(sp)
    80005e7a:	79e2                	ld	s3,56(sp)
    80005e7c:	7aa2                	ld	s5,40(sp)
    80005e7e:	7b02                	ld	s6,32(sp)
    80005e80:	6be2                	ld	s7,24(sp)
    80005e82:	6c42                	ld	s8,16(sp)
    80005e84:	6ca2                	ld	s9,8(sp)
    80005e86:	6d02                	ld	s10,0(sp)
    }
  }
}
    80005e88:	60e6                	ld	ra,88(sp)
    80005e8a:	6446                	ld	s0,80(sp)
    80005e8c:	6906                	ld	s2,64(sp)
    80005e8e:	6125                	addi	sp,sp,96
    80005e90:	8082                	ret

0000000080005e92 <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int bd_initfree_pair(int k, int bi, char left) {
    80005e92:	7139                	addi	sp,sp,-64
    80005e94:	fc06                	sd	ra,56(sp)
    80005e96:	f822                	sd	s0,48(sp)
    80005e98:	f426                	sd	s1,40(sp)
    80005e9a:	f04a                	sd	s2,32(sp)
    80005e9c:	ec4e                	sd	s3,24(sp)
    80005e9e:	e852                	sd	s4,16(sp)
    80005ea0:	e456                	sd	s5,8(sp)
    80005ea2:	e05a                	sd	s6,0(sp)
    80005ea4:	0080                	addi	s0,sp,64
    80005ea6:	8a2a                	mv	s4,a0
    80005ea8:	84ae                	mv	s1,a1
    80005eaa:	8ab2                	mv	s5,a2
  int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005eac:	0015f793          	andi	a5,a1,1
    80005eb0:	e7ad                	bnez	a5,80005f1a <bd_initfree_pair+0x88>
    80005eb2:	00158b1b          	addiw	s6,a1,1
  int free = 0;
  if (bit_isset(bd_sizes[k].buddy_xor, bi / 2)) {
    80005eb6:	005a1793          	slli	a5,s4,0x5
    80005eba:	00006997          	auipc	s3,0x6
    80005ebe:	9fe9b983          	ld	s3,-1538(s3) # 8000b8b8 <bd_sizes>
    80005ec2:	99be                	add	s3,s3,a5
    80005ec4:	01f4d59b          	srliw	a1,s1,0x1f
    80005ec8:	9da5                	addw	a1,a1,s1
    80005eca:	4015d59b          	sraiw	a1,a1,0x1
    80005ece:	0109b503          	ld	a0,16(s3)
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	80c080e7          	jalr	-2036(ra) # 800056de <bit_isset>
    80005eda:	892a                	mv	s2,a0
    80005edc:	c505                	beqz	a0,80005f04 <bd_initfree_pair+0x72>
    // one of the pair is free
    free = BLK_SIZE(k);
    80005ede:	45c1                	li	a1,16
    80005ee0:	014595b3          	sll	a1,a1,s4
    80005ee4:	0005891b          	sext.w	s2,a1
    if (!left)
    80005ee8:	020a9c63          	bnez	s5,80005f20 <bd_initfree_pair+0x8e>
  return (char *)bd_base + n;
    80005eec:	036585bb          	mulw	a1,a1,s6
      lst_push(&bd_sizes[k].free, addr(k, buddy));  // put buddy on free list
    80005ef0:	00006797          	auipc	a5,0x6
    80005ef4:	9c07b783          	ld	a5,-1600(a5) # 8000b8b0 <bd_base>
    80005ef8:	95be                	add	a1,a1,a5
    80005efa:	854e                	mv	a0,s3
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	49e080e7          	jalr	1182(ra) # 8000639a <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));  // put bi on free list
  }
  return free;
}
    80005f04:	854a                	mv	a0,s2
    80005f06:	70e2                	ld	ra,56(sp)
    80005f08:	7442                	ld	s0,48(sp)
    80005f0a:	74a2                	ld	s1,40(sp)
    80005f0c:	7902                	ld	s2,32(sp)
    80005f0e:	69e2                	ld	s3,24(sp)
    80005f10:	6a42                	ld	s4,16(sp)
    80005f12:	6aa2                	ld	s5,8(sp)
    80005f14:	6b02                	ld	s6,0(sp)
    80005f16:	6121                	addi	sp,sp,64
    80005f18:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005f1a:	fff58b1b          	addiw	s6,a1,-1
    80005f1e:	bf61                	j	80005eb6 <bd_initfree_pair+0x24>
  return (char *)bd_base + n;
    80005f20:	029585bb          	mulw	a1,a1,s1
      lst_push(&bd_sizes[k].free, addr(k, bi));  // put bi on free list
    80005f24:	00006797          	auipc	a5,0x6
    80005f28:	98c7b783          	ld	a5,-1652(a5) # 8000b8b0 <bd_base>
    80005f2c:	95be                	add	a1,a1,a5
    80005f2e:	854e                	mv	a0,s3
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	46a080e7          	jalr	1130(ra) # 8000639a <lst_push>
    80005f38:	b7f1                	j	80005f04 <bd_initfree_pair+0x72>

0000000080005f3a <bd_initfree>:

// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int bd_initfree(void *bd_left, void *bd_right) {
    80005f3a:	711d                	addi	sp,sp,-96
    80005f3c:	ec86                	sd	ra,88(sp)
    80005f3e:	e8a2                	sd	s0,80(sp)
    80005f40:	f852                	sd	s4,48(sp)
    80005f42:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {  // skip max size
    80005f44:	00006717          	auipc	a4,0x6
    80005f48:	97c72703          	lw	a4,-1668(a4) # 8000b8c0 <nsizes>
    80005f4c:	4785                	li	a5,1
    80005f4e:	0ce7d063          	bge	a5,a4,8000600e <bd_initfree+0xd4>
    80005f52:	e4a6                	sd	s1,72(sp)
    80005f54:	e0ca                	sd	s2,64(sp)
    80005f56:	fc4e                	sd	s3,56(sp)
    80005f58:	f456                	sd	s5,40(sp)
    80005f5a:	f05a                	sd	s6,32(sp)
    80005f5c:	ec5e                	sd	s7,24(sp)
    80005f5e:	e862                	sd	s8,16(sp)
    80005f60:	e466                	sd	s9,8(sp)
    80005f62:	e06a                	sd	s10,0(sp)
    80005f64:	8aaa                	mv	s5,a0
    80005f66:	8b2e                	mv	s6,a1
    80005f68:	4901                	li	s2,0
  int free = 0;
    80005f6a:	4a01                	li	s4,0
  int n = p - (char *)bd_base;
    80005f6c:	00006c97          	auipc	s9,0x6
    80005f70:	944c8c93          	addi	s9,s9,-1724 # 8000b8b0 <bd_base>
  return n / BLK_SIZE(k);
    80005f74:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {  // skip max size
    80005f76:	00006b97          	auipc	s7,0x6
    80005f7a:	94ab8b93          	addi	s7,s7,-1718 # 8000b8c0 <nsizes>
    80005f7e:	a005                	j	80005f9e <bd_initfree+0x64>
    int left = blk_index_next(k, bd_left);
    int right = blk_index(k, bd_right);
    if (left == right) {
      free += bd_initfree_pair(k, right, 0);
    80005f80:	4601                	li	a2,0
    80005f82:	85a6                	mv	a1,s1
    80005f84:	854a                	mv	a0,s2
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	f0c080e7          	jalr	-244(ra) # 80005e92 <bd_initfree_pair>
    80005f8e:	01450a3b          	addw	s4,a0,s4
  for (int k = 0; k < MAXSIZE; k++) {  // skip max size
    80005f92:	2905                	addiw	s2,s2,1
    80005f94:	000ba783          	lw	a5,0(s7)
    80005f98:	37fd                	addiw	a5,a5,-1
    80005f9a:	04f95b63          	bge	s2,a5,80005ff0 <bd_initfree+0xb6>
    int left = blk_index_next(k, bd_left);
    80005f9e:	85d6                	mv	a1,s5
    80005fa0:	854a                	mv	a0,s2
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	db0080e7          	jalr	-592(ra) # 80005d52 <blk_index_next>
    80005faa:	89aa                	mv	s3,a0
  int n = p - (char *)bd_base;
    80005fac:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80005fb0:	409b04bb          	subw	s1,s6,s1
    80005fb4:	012c17b3          	sll	a5,s8,s2
    80005fb8:	02f4c4b3          	div	s1,s1,a5
    80005fbc:	2481                	sext.w	s1,s1
    if (left == right) {
    80005fbe:	fc9501e3          	beq	a0,s1,80005f80 <bd_initfree+0x46>
    } else {
      free += bd_initfree_pair(k, left, 1);
    80005fc2:	4605                	li	a2,1
    80005fc4:	85aa                	mv	a1,a0
    80005fc6:	854a                	mv	a0,s2
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	eca080e7          	jalr	-310(ra) # 80005e92 <bd_initfree_pair>
    80005fd0:	01450d3b          	addw	s10,a0,s4
    80005fd4:	000d0a1b          	sext.w	s4,s10
      if (right < left) continue;
    80005fd8:	fb34cde3          	blt	s1,s3,80005f92 <bd_initfree+0x58>
      free += bd_initfree_pair(k, right, 0);
    80005fdc:	4601                	li	a2,0
    80005fde:	85a6                	mv	a1,s1
    80005fe0:	854a                	mv	a0,s2
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	eb0080e7          	jalr	-336(ra) # 80005e92 <bd_initfree_pair>
    80005fea:	00ad0a3b          	addw	s4,s10,a0
    80005fee:	b755                	j	80005f92 <bd_initfree+0x58>
    80005ff0:	64a6                	ld	s1,72(sp)
    80005ff2:	6906                	ld	s2,64(sp)
    80005ff4:	79e2                	ld	s3,56(sp)
    80005ff6:	7aa2                	ld	s5,40(sp)
    80005ff8:	7b02                	ld	s6,32(sp)
    80005ffa:	6be2                	ld	s7,24(sp)
    80005ffc:	6c42                	ld	s8,16(sp)
    80005ffe:	6ca2                	ld	s9,8(sp)
    80006000:	6d02                	ld	s10,0(sp)
    }
  }
  return free;
}
    80006002:	8552                	mv	a0,s4
    80006004:	60e6                	ld	ra,88(sp)
    80006006:	6446                	ld	s0,80(sp)
    80006008:	7a42                	ld	s4,48(sp)
    8000600a:	6125                	addi	sp,sp,96
    8000600c:	8082                	ret
  int free = 0;
    8000600e:	4a01                	li	s4,0
    80006010:	bfcd                	j	80006002 <bd_initfree+0xc8>

0000000080006012 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int bd_mark_data_structures(char *p) {
    80006012:	7179                	addi	sp,sp,-48
    80006014:	f406                	sd	ra,40(sp)
    80006016:	f022                	sd	s0,32(sp)
    80006018:	ec26                	sd	s1,24(sp)
    8000601a:	e84a                	sd	s2,16(sp)
    8000601c:	e44e                	sd	s3,8(sp)
    8000601e:	1800                	addi	s0,sp,48
    80006020:	892a                	mv	s2,a0
  int meta = p - (char *)bd_base;
    80006022:	00006997          	auipc	s3,0x6
    80006026:	88e98993          	addi	s3,s3,-1906 # 8000b8b0 <bd_base>
    8000602a:	0009b483          	ld	s1,0(s3)
    8000602e:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta,
         BLK_SIZE(MAXSIZE));
    80006032:	00006797          	auipc	a5,0x6
    80006036:	88e7a783          	lw	a5,-1906(a5) # 8000b8c0 <nsizes>
    8000603a:	37fd                	addiw	a5,a5,-1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta,
    8000603c:	4641                	li	a2,16
    8000603e:	00f61633          	sll	a2,a2,a5
    80006042:	85a6                	mv	a1,s1
    80006044:	00002517          	auipc	a0,0x2
    80006048:	70c50513          	addi	a0,a0,1804 # 80008750 <etext+0x750>
    8000604c:	00001097          	auipc	ra,0x1
    80006050:	942080e7          	jalr	-1726(ra) # 8000698e <printf>
  bd_mark(bd_base, p);
    80006054:	85ca                	mv	a1,s2
    80006056:	0009b503          	ld	a0,0(s3)
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	d44080e7          	jalr	-700(ra) # 80005d9e <bd_mark>
  return meta;
}
    80006062:	8526                	mv	a0,s1
    80006064:	70a2                	ld	ra,40(sp)
    80006066:	7402                	ld	s0,32(sp)
    80006068:	64e2                	ld	s1,24(sp)
    8000606a:	6942                	ld	s2,16(sp)
    8000606c:	69a2                	ld	s3,8(sp)
    8000606e:	6145                	addi	sp,sp,48
    80006070:	8082                	ret

0000000080006072 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int bd_mark_unavailable(void *end, void *left) {
    80006072:	1101                	addi	sp,sp,-32
    80006074:	ec06                	sd	ra,24(sp)
    80006076:	e822                	sd	s0,16(sp)
    80006078:	e426                	sd	s1,8(sp)
    8000607a:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE) - (end - bd_base);
    8000607c:	00006717          	auipc	a4,0x6
    80006080:	84472703          	lw	a4,-1980(a4) # 8000b8c0 <nsizes>
    80006084:	377d                	addiw	a4,a4,-1
    80006086:	47c1                	li	a5,16
    80006088:	00e797b3          	sll	a5,a5,a4
    8000608c:	00006717          	auipc	a4,0x6
    80006090:	82473703          	ld	a4,-2012(a4) # 8000b8b0 <bd_base>
    80006094:	8d19                	sub	a0,a0,a4
    80006096:	9f89                	subw	a5,a5,a0
    80006098:	0007849b          	sext.w	s1,a5
  if (unavailable > 0) unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    8000609c:	00905a63          	blez	s1,800060b0 <bd_mark_unavailable+0x3e>
    800060a0:	37fd                	addiw	a5,a5,-1
    800060a2:	41f7d49b          	sraiw	s1,a5,0x1f
    800060a6:	01c4d49b          	srliw	s1,s1,0x1c
    800060aa:	9cbd                	addw	s1,s1,a5
    800060ac:	98c1                	andi	s1,s1,-16
    800060ae:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    800060b0:	85a6                	mv	a1,s1
    800060b2:	00002517          	auipc	a0,0x2
    800060b6:	6d650513          	addi	a0,a0,1750 # 80008788 <etext+0x788>
    800060ba:	00001097          	auipc	ra,0x1
    800060be:	8d4080e7          	jalr	-1836(ra) # 8000698e <printf>

  void *bd_end = bd_base + BLK_SIZE(MAXSIZE) - unavailable;
    800060c2:	00005717          	auipc	a4,0x5
    800060c6:	7ee73703          	ld	a4,2030(a4) # 8000b8b0 <bd_base>
    800060ca:	00005797          	auipc	a5,0x5
    800060ce:	7f67a783          	lw	a5,2038(a5) # 8000b8c0 <nsizes>
    800060d2:	37fd                	addiw	a5,a5,-1
    800060d4:	45c1                	li	a1,16
    800060d6:	00f595b3          	sll	a1,a1,a5
    800060da:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base + BLK_SIZE(MAXSIZE));
    800060de:	95ba                	add	a1,a1,a4
    800060e0:	953a                	add	a0,a0,a4
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	cbc080e7          	jalr	-836(ra) # 80005d9e <bd_mark>
  return unavailable;
}
    800060ea:	8526                	mv	a0,s1
    800060ec:	60e2                	ld	ra,24(sp)
    800060ee:	6442                	ld	s0,16(sp)
    800060f0:	64a2                	ld	s1,8(sp)
    800060f2:	6105                	addi	sp,sp,32
    800060f4:	8082                	ret

00000000800060f6 <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void bd_init(void *base, void *end) {
    800060f6:	715d                	addi	sp,sp,-80
    800060f8:	e486                	sd	ra,72(sp)
    800060fa:	e0a2                	sd	s0,64(sp)
    800060fc:	fc26                	sd	s1,56(sp)
    800060fe:	f84a                	sd	s2,48(sp)
    80006100:	f44e                	sd	s3,40(sp)
    80006102:	f052                	sd	s4,32(sp)
    80006104:	ec56                	sd	s5,24(sp)
    80006106:	e45e                	sd	s7,8(sp)
    80006108:	0880                	addi	s0,sp,80
    8000610a:	8bae                	mv	s7,a1
  char *p = (char *)ROUNDUP((uint64)base, LEAF_SIZE);
    8000610c:	fff50913          	addi	s2,a0,-1
    80006110:	ff097913          	andi	s2,s2,-16
    80006114:	0941                	addi	s2,s2,16
  int sz;

  initlock(&lock, "buddy");
    80006116:	00002597          	auipc	a1,0x2
    8000611a:	69258593          	addi	a1,a1,1682 # 800087a8 <etext+0x7a8>
    8000611e:	00016517          	auipc	a0,0x16
    80006122:	a1a50513          	addi	a0,a0,-1510 # 8001bb38 <lock>
    80006126:	00001097          	auipc	ra,0x1
    8000612a:	d08080e7          	jalr	-760(ra) # 80006e2e <initlock>
  bd_base = (void *)p;

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end - p) / LEAF_SIZE) + 1;
    8000612e:	412b84b3          	sub	s1,s7,s2
    80006132:	43f4d513          	srai	a0,s1,0x3f
    80006136:	893d                	andi	a0,a0,15
    80006138:	9526                	add	a0,a0,s1
    8000613a:	8511                	srai	a0,a0,0x4
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	c40080e7          	jalr	-960(ra) # 80005d7c <log2>
  if ((char *)end - p > BLK_SIZE(MAXSIZE)) {
    80006144:	47c1                	li	a5,16
    80006146:	00a797b3          	sll	a5,a5,a0
    8000614a:	1a97c663          	blt	a5,s1,800062f6 <bd_init+0x200>
  nsizes = log2(((char *)end - p) / LEAF_SIZE) + 1;
    8000614e:	0015061b          	addiw	a2,a0,1
  bd_base = (void *)p;
    80006152:	00005797          	auipc	a5,0x5
    80006156:	7527bf23          	sd	s2,1886(a5) # 8000b8b0 <bd_base>
  nsizes = log2(((char *)end - p) / LEAF_SIZE) + 1;
    8000615a:	00005997          	auipc	s3,0x5
    8000615e:	76698993          	addi	s3,s3,1894 # 8000b8c0 <nsizes>
    80006162:	00c9a023          	sw	a2,0(s3)
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    80006166:	85a6                	mv	a1,s1
    80006168:	00002517          	auipc	a0,0x2
    8000616c:	64850513          	addi	a0,a0,1608 # 800087b0 <etext+0x7b0>
    80006170:	00001097          	auipc	ra,0x1
    80006174:	81e080e7          	jalr	-2018(ra) # 8000698e <printf>
         (char *)end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *)p;
    80006178:	00005797          	auipc	a5,0x5
    8000617c:	7527b023          	sd	s2,1856(a5) # 8000b8b8 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80006180:	0009a603          	lw	a2,0(s3)
    80006184:	00561493          	slli	s1,a2,0x5
    80006188:	94ca                	add	s1,s1,s2
  memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    8000618a:	0056161b          	slliw	a2,a2,0x5
    8000618e:	4581                	li	a1,0
    80006190:	854a                	mv	a0,s2
    80006192:	ffffa097          	auipc	ra,0xffffa
    80006196:	ee4080e7          	jalr	-284(ra) # 80000076 <memset>

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    8000619a:	0009a783          	lw	a5,0(s3)
    8000619e:	0ef05263          	blez	a5,80006282 <bd_init+0x18c>
    800061a2:	e85a                	sd	s6,16(sp)
    800061a4:	e062                	sd	s8,0(sp)
    800061a6:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    800061a8:	00005a97          	auipc	s5,0x5
    800061ac:	710a8a93          	addi	s5,s5,1808 # 8000b8b8 <bd_sizes>
    sz = sizeof(char) * ROUNDUP(NBLK(k), 16) / 16;
    800061b0:	00005a17          	auipc	s4,0x5
    800061b4:	710a0a13          	addi	s4,s4,1808 # 8000b8c0 <nsizes>
    800061b8:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    800061ba:	00599c13          	slli	s8,s3,0x5
    800061be:	000ab503          	ld	a0,0(s5)
    800061c2:	9562                	add	a0,a0,s8
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	164080e7          	jalr	356(ra) # 80006328 <lst_init>
    sz = sizeof(char) * ROUNDUP(NBLK(k), 16) / 16;
    800061cc:	000a2783          	lw	a5,0(s4)
    800061d0:	37fd                	addiw	a5,a5,-1
    800061d2:	413787bb          	subw	a5,a5,s3
    800061d6:	00fb17bb          	sllw	a5,s6,a5
    800061da:	37fd                	addiw	a5,a5,-1
    800061dc:	41f7d91b          	sraiw	s2,a5,0x1f
    800061e0:	01c9591b          	srliw	s2,s2,0x1c
    800061e4:	00f9093b          	addw	s2,s2,a5
    800061e8:	ff097913          	andi	s2,s2,-16
    800061ec:	2941                	addiw	s2,s2,16
    bd_sizes[k].buddy_xor = p;
    800061ee:	000ab783          	ld	a5,0(s5)
    800061f2:	97e2                	add	a5,a5,s8
    800061f4:	eb84                	sd	s1,16(a5)
    memset(bd_sizes[k].buddy_xor, 0, sz);
    800061f6:	40495913          	srai	s2,s2,0x4
    800061fa:	864a                	mv	a2,s2
    800061fc:	4581                	li	a1,0
    800061fe:	8526                	mv	a0,s1
    80006200:	ffffa097          	auipc	ra,0xffffa
    80006204:	e76080e7          	jalr	-394(ra) # 80000076 <memset>
    p += sz;
    80006208:	94ca                	add	s1,s1,s2
  for (int k = 0; k < nsizes; k++) {
    8000620a:	000a2783          	lw	a5,0(s4)
    8000620e:	0985                	addi	s3,s3,1
    80006210:	0009871b          	sext.w	a4,s3
    80006214:	faf743e3          	blt	a4,a5,800061ba <bd_init+0xc4>
  }

  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    80006218:	4705                	li	a4,1
    8000621a:	0ef75163          	bge	a4,a5,800062fc <bd_init+0x206>
    8000621e:	02000993          	li	s3,32
    80006222:	4905                	li	s2,1
    sz = sizeof(char) * (ROUNDUP(NBLK(k), 8)) / 8;
    80006224:	4b05                	li	s6,1
    bd_sizes[k].split = p;
    80006226:	00005a97          	auipc	s5,0x5
    8000622a:	692a8a93          	addi	s5,s5,1682 # 8000b8b8 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    8000622e:	00005a17          	auipc	s4,0x5
    80006232:	692a0a13          	addi	s4,s4,1682 # 8000b8c0 <nsizes>
    sz = sizeof(char) * (ROUNDUP(NBLK(k), 8)) / 8;
    80006236:	37fd                	addiw	a5,a5,-1
    80006238:	412787bb          	subw	a5,a5,s2
    8000623c:	00fb17bb          	sllw	a5,s6,a5
    80006240:	37fd                	addiw	a5,a5,-1
    80006242:	41f7dc1b          	sraiw	s8,a5,0x1f
    80006246:	01dc5c1b          	srliw	s8,s8,0x1d
    8000624a:	00fc0c3b          	addw	s8,s8,a5
    8000624e:	ff8c7c13          	andi	s8,s8,-8
    80006252:	2c21                	addiw	s8,s8,8
    bd_sizes[k].split = p;
    80006254:	000ab783          	ld	a5,0(s5)
    80006258:	97ce                	add	a5,a5,s3
    8000625a:	ef84                	sd	s1,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    8000625c:	403c5c13          	srai	s8,s8,0x3
    80006260:	8662                	mv	a2,s8
    80006262:	4581                	li	a1,0
    80006264:	8526                	mv	a0,s1
    80006266:	ffffa097          	auipc	ra,0xffffa
    8000626a:	e10080e7          	jalr	-496(ra) # 80000076 <memset>
    p += sz;
    8000626e:	94e2                	add	s1,s1,s8
  for (int k = 1; k < nsizes; k++) {
    80006270:	2905                	addiw	s2,s2,1
    80006272:	000a2783          	lw	a5,0(s4)
    80006276:	02098993          	addi	s3,s3,32
    8000627a:	faf94ee3          	blt	s2,a5,80006236 <bd_init+0x140>
    8000627e:	6b42                	ld	s6,16(sp)
    80006280:	6c02                	ld	s8,0(sp)
  }
  p = (char *)ROUNDUP((uint64)p, LEAF_SIZE);
    80006282:	14fd                	addi	s1,s1,-1
    80006284:	98c1                	andi	s1,s1,-16
    80006286:	04c1                	addi	s1,s1,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    80006288:	8526                	mv	a0,s1
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	d88080e7          	jalr	-632(ra) # 80006012 <bd_mark_data_structures>
    80006292:	8a2a                	mv	s4,a0

  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80006294:	85a6                	mv	a1,s1
    80006296:	855e                	mv	a0,s7
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	dda080e7          	jalr	-550(ra) # 80006072 <bd_mark_unavailable>
    800062a0:	89aa                	mv	s3,a0
  void *bd_end = bd_base + BLK_SIZE(MAXSIZE) - unavailable;
    800062a2:	00005a97          	auipc	s5,0x5
    800062a6:	61ea8a93          	addi	s5,s5,1566 # 8000b8c0 <nsizes>
    800062aa:	000aa783          	lw	a5,0(s5)
    800062ae:	37fd                	addiw	a5,a5,-1
    800062b0:	4941                	li	s2,16
    800062b2:	00f917b3          	sll	a5,s2,a5
    800062b6:	8f89                	sub	a5,a5,a0

  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    800062b8:	00005597          	auipc	a1,0x5
    800062bc:	5f85b583          	ld	a1,1528(a1) # 8000b8b0 <bd_base>
    800062c0:	95be                	add	a1,a1,a5
    800062c2:	8526                	mv	a0,s1
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	c76080e7          	jalr	-906(ra) # 80005f3a <bd_initfree>

  // check if the amount that is free is what we expect
  if (free != BLK_SIZE(MAXSIZE) - meta - unavailable) {
    800062cc:	000aa783          	lw	a5,0(s5)
    800062d0:	37fd                	addiw	a5,a5,-1
    800062d2:	00f91633          	sll	a2,s2,a5
    800062d6:	41460633          	sub	a2,a2,s4
    800062da:	41360633          	sub	a2,a2,s3
    800062de:	02c51263          	bne	a0,a2,80006302 <bd_init+0x20c>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE) - meta - unavailable);
    panic("bd_init: free mem");
  }
}
    800062e2:	60a6                	ld	ra,72(sp)
    800062e4:	6406                	ld	s0,64(sp)
    800062e6:	74e2                	ld	s1,56(sp)
    800062e8:	7942                	ld	s2,48(sp)
    800062ea:	79a2                	ld	s3,40(sp)
    800062ec:	7a02                	ld	s4,32(sp)
    800062ee:	6ae2                	ld	s5,24(sp)
    800062f0:	6ba2                	ld	s7,8(sp)
    800062f2:	6161                	addi	sp,sp,80
    800062f4:	8082                	ret
    nsizes++;  // round up to the next power of 2
    800062f6:	0025061b          	addiw	a2,a0,2
    800062fa:	bda1                	j	80006152 <bd_init+0x5c>
    800062fc:	6b42                	ld	s6,16(sp)
    800062fe:	6c02                	ld	s8,0(sp)
    80006300:	b749                	j	80006282 <bd_init+0x18c>
    80006302:	e85a                	sd	s6,16(sp)
    80006304:	e062                	sd	s8,0(sp)
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE) - meta - unavailable);
    80006306:	85aa                	mv	a1,a0
    80006308:	00002517          	auipc	a0,0x2
    8000630c:	4e850513          	addi	a0,a0,1256 # 800087f0 <etext+0x7f0>
    80006310:	00000097          	auipc	ra,0x0
    80006314:	67e080e7          	jalr	1662(ra) # 8000698e <printf>
    panic("bd_init: free mem");
    80006318:	00002517          	auipc	a0,0x2
    8000631c:	4e850513          	addi	a0,a0,1256 # 80008800 <etext+0x800>
    80006320:	00000097          	auipc	ra,0x0
    80006324:	624080e7          	jalr	1572(ra) # 80006944 <panic>

0000000080006328 <lst_init>:

// double-linked, circular list. double-linked makes remove
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void lst_init(struct list *lst) {
    80006328:	1141                	addi	sp,sp,-16
    8000632a:	e422                	sd	s0,8(sp)
    8000632c:	0800                	addi	s0,sp,16
  lst->next = lst;
    8000632e:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    80006330:	e508                	sd	a0,8(a0)
}
    80006332:	6422                	ld	s0,8(sp)
    80006334:	0141                	addi	sp,sp,16
    80006336:	8082                	ret

0000000080006338 <lst_empty>:

int lst_empty(struct list *lst) { return lst->next == lst; }
    80006338:	1141                	addi	sp,sp,-16
    8000633a:	e422                	sd	s0,8(sp)
    8000633c:	0800                	addi	s0,sp,16
    8000633e:	611c                	ld	a5,0(a0)
    80006340:	40a78533          	sub	a0,a5,a0
    80006344:	00153513          	seqz	a0,a0
    80006348:	6422                	ld	s0,8(sp)
    8000634a:	0141                	addi	sp,sp,16
    8000634c:	8082                	ret

000000008000634e <lst_remove>:

void lst_remove(struct list *e) {
    8000634e:	1141                	addi	sp,sp,-16
    80006350:	e422                	sd	s0,8(sp)
    80006352:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    80006354:	6518                	ld	a4,8(a0)
    80006356:	611c                	ld	a5,0(a0)
    80006358:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    8000635a:	6518                	ld	a4,8(a0)
    8000635c:	e798                	sd	a4,8(a5)
}
    8000635e:	6422                	ld	s0,8(sp)
    80006360:	0141                	addi	sp,sp,16
    80006362:	8082                	ret

0000000080006364 <lst_pop>:

void *lst_pop(struct list *lst) {
    80006364:	1101                	addi	sp,sp,-32
    80006366:	ec06                	sd	ra,24(sp)
    80006368:	e822                	sd	s0,16(sp)
    8000636a:	e426                	sd	s1,8(sp)
    8000636c:	1000                	addi	s0,sp,32
  if (lst->next == lst) panic("lst_pop");
    8000636e:	6104                	ld	s1,0(a0)
    80006370:	00a48d63          	beq	s1,a0,8000638a <lst_pop+0x26>
  struct list *p = lst->next;
  lst_remove(p);
    80006374:	8526                	mv	a0,s1
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	fd8080e7          	jalr	-40(ra) # 8000634e <lst_remove>
  return (void *)p;
}
    8000637e:	8526                	mv	a0,s1
    80006380:	60e2                	ld	ra,24(sp)
    80006382:	6442                	ld	s0,16(sp)
    80006384:	64a2                	ld	s1,8(sp)
    80006386:	6105                	addi	sp,sp,32
    80006388:	8082                	ret
  if (lst->next == lst) panic("lst_pop");
    8000638a:	00002517          	auipc	a0,0x2
    8000638e:	48e50513          	addi	a0,a0,1166 # 80008818 <etext+0x818>
    80006392:	00000097          	auipc	ra,0x0
    80006396:	5b2080e7          	jalr	1458(ra) # 80006944 <panic>

000000008000639a <lst_push>:

void lst_push(struct list *lst, void *p) {
    8000639a:	1141                	addi	sp,sp,-16
    8000639c:	e422                	sd	s0,8(sp)
    8000639e:	0800                	addi	s0,sp,16
  struct list *e = (struct list *)p;
  e->next = lst->next;
    800063a0:	611c                	ld	a5,0(a0)
    800063a2:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    800063a4:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    800063a6:	611c                	ld	a5,0(a0)
    800063a8:	e78c                	sd	a1,8(a5)
  lst->next = e;
    800063aa:	e10c                	sd	a1,0(a0)
}
    800063ac:	6422                	ld	s0,8(sp)
    800063ae:	0141                	addi	sp,sp,16
    800063b0:	8082                	ret

00000000800063b2 <lst_print>:

void lst_print(struct list *lst) {
    800063b2:	7179                	addi	sp,sp,-48
    800063b4:	f406                	sd	ra,40(sp)
    800063b6:	f022                	sd	s0,32(sp)
    800063b8:	ec26                	sd	s1,24(sp)
    800063ba:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800063bc:	6104                	ld	s1,0(a0)
    800063be:	02950463          	beq	a0,s1,800063e6 <lst_print+0x34>
    800063c2:	e84a                	sd	s2,16(sp)
    800063c4:	e44e                	sd	s3,8(sp)
    800063c6:	892a                	mv	s2,a0
    printf(" %p", p);
    800063c8:	00002997          	auipc	s3,0x2
    800063cc:	45898993          	addi	s3,s3,1112 # 80008820 <etext+0x820>
    800063d0:	85a6                	mv	a1,s1
    800063d2:	854e                	mv	a0,s3
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	5ba080e7          	jalr	1466(ra) # 8000698e <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800063dc:	6084                	ld	s1,0(s1)
    800063de:	fe9919e3          	bne	s2,s1,800063d0 <lst_print+0x1e>
    800063e2:	6942                	ld	s2,16(sp)
    800063e4:	69a2                	ld	s3,8(sp)
  }
  printf("\n");
    800063e6:	00002517          	auipc	a0,0x2
    800063ea:	c1a50513          	addi	a0,a0,-998 # 80008000 <etext>
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	5a0080e7          	jalr	1440(ra) # 8000698e <printf>
}
    800063f6:	70a2                	ld	ra,40(sp)
    800063f8:	7402                	ld	s0,32(sp)
    800063fa:	64e2                	ld	s1,24(sp)
    800063fc:	6145                	addi	sp,sp,48
    800063fe:	8082                	ret

0000000080006400 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    80006400:	1141                	addi	sp,sp,-16
    80006402:	e422                	sd	s0,8(sp)
    80006404:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80006406:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000640a:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    8000640e:	0037979b          	slliw	a5,a5,0x3
    80006412:	02004737          	lui	a4,0x2004
    80006416:	97ba                	add	a5,a5,a4
    80006418:	0200c737          	lui	a4,0x200c
    8000641c:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000641e:	6318                	ld	a4,0(a4)
    80006420:	000f4637          	lui	a2,0xf4
    80006424:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006428:	9732                	add	a4,a4,a2
    8000642a:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000642c:	00259693          	slli	a3,a1,0x2
    80006430:	96ae                	add	a3,a3,a1
    80006432:	068e                	slli	a3,a3,0x3
    80006434:	00015717          	auipc	a4,0x15
    80006438:	71c70713          	addi	a4,a4,1820 # 8001bb50 <timer_scratch>
    8000643c:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000643e:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80006440:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80006442:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80006446:	fffff797          	auipc	a5,0xfffff
    8000644a:	c3a78793          	addi	a5,a5,-966 # 80005080 <timervec>
    8000644e:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80006452:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006456:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    8000645a:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    8000645e:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80006462:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80006466:	30479073          	csrw	mie,a5
}
    8000646a:	6422                	ld	s0,8(sp)
    8000646c:	0141                	addi	sp,sp,16
    8000646e:	8082                	ret

0000000080006470 <start>:
void start() {
    80006470:	1141                	addi	sp,sp,-16
    80006472:	e406                	sd	ra,8(sp)
    80006474:	e022                	sd	s0,0(sp)
    80006476:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80006478:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000647c:	7779                	lui	a4,0xffffe
    8000647e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaa6f>
    80006482:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80006484:	6705                	lui	a4,0x1
    80006486:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000648a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    8000648c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80006490:	ffffa797          	auipc	a5,0xffffa
    80006494:	d8478793          	addi	a5,a5,-636 # 80000214 <main>
    80006498:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    8000649c:	4781                	li	a5,0
    8000649e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    800064a2:	67c1                	lui	a5,0x10
    800064a4:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800064a6:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    800064aa:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    800064ae:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800064b2:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    800064b6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800064ba:	57fd                	li	a5,-1
    800064bc:	83a9                	srli	a5,a5,0xa
    800064be:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800064c2:	47bd                	li	a5,15
    800064c4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800064c8:	00000097          	auipc	ra,0x0
    800064cc:	f38080e7          	jalr	-200(ra) # 80006400 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800064d0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800064d4:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    800064d6:	823e                	mv	tp,a5
  asm volatile("mret");
    800064d8:	30200073          	mret
}
    800064dc:	60a2                	ld	ra,8(sp)
    800064de:	6402                	ld	s0,0(sp)
    800064e0:	0141                	addi	sp,sp,16
    800064e2:	8082                	ret

00000000800064e4 <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    800064e4:	715d                	addi	sp,sp,-80
    800064e6:	e486                	sd	ra,72(sp)
    800064e8:	e0a2                	sd	s0,64(sp)
    800064ea:	f84a                	sd	s2,48(sp)
    800064ec:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    800064ee:	04c05663          	blez	a2,8000653a <consolewrite+0x56>
    800064f2:	fc26                	sd	s1,56(sp)
    800064f4:	f44e                	sd	s3,40(sp)
    800064f6:	f052                	sd	s4,32(sp)
    800064f8:	ec56                	sd	s5,24(sp)
    800064fa:	8a2a                	mv	s4,a0
    800064fc:	84ae                	mv	s1,a1
    800064fe:	89b2                	mv	s3,a2
    80006500:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80006502:	5afd                	li	s5,-1
    80006504:	4685                	li	a3,1
    80006506:	8626                	mv	a2,s1
    80006508:	85d2                	mv	a1,s4
    8000650a:	fbf40513          	addi	a0,s0,-65
    8000650e:	ffffb097          	auipc	ra,0xffffb
    80006512:	400080e7          	jalr	1024(ra) # 8000190e <either_copyin>
    80006516:	03550463          	beq	a0,s5,8000653e <consolewrite+0x5a>
    uartputc(c);
    8000651a:	fbf44503          	lbu	a0,-65(s0)
    8000651e:	00000097          	auipc	ra,0x0
    80006522:	7e4080e7          	jalr	2020(ra) # 80006d02 <uartputc>
  for (i = 0; i < n; i++) {
    80006526:	2905                	addiw	s2,s2,1
    80006528:	0485                	addi	s1,s1,1
    8000652a:	fd299de3          	bne	s3,s2,80006504 <consolewrite+0x20>
    8000652e:	894e                	mv	s2,s3
    80006530:	74e2                	ld	s1,56(sp)
    80006532:	79a2                	ld	s3,40(sp)
    80006534:	7a02                	ld	s4,32(sp)
    80006536:	6ae2                	ld	s5,24(sp)
    80006538:	a039                	j	80006546 <consolewrite+0x62>
    8000653a:	4901                	li	s2,0
    8000653c:	a029                	j	80006546 <consolewrite+0x62>
    8000653e:	74e2                	ld	s1,56(sp)
    80006540:	79a2                	ld	s3,40(sp)
    80006542:	7a02                	ld	s4,32(sp)
    80006544:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80006546:	854a                	mv	a0,s2
    80006548:	60a6                	ld	ra,72(sp)
    8000654a:	6406                	ld	s0,64(sp)
    8000654c:	7942                	ld	s2,48(sp)
    8000654e:	6161                	addi	sp,sp,80
    80006550:	8082                	ret

0000000080006552 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80006552:	711d                	addi	sp,sp,-96
    80006554:	ec86                	sd	ra,88(sp)
    80006556:	e8a2                	sd	s0,80(sp)
    80006558:	e4a6                	sd	s1,72(sp)
    8000655a:	e0ca                	sd	s2,64(sp)
    8000655c:	fc4e                	sd	s3,56(sp)
    8000655e:	f852                	sd	s4,48(sp)
    80006560:	f456                	sd	s5,40(sp)
    80006562:	f05a                	sd	s6,32(sp)
    80006564:	1080                	addi	s0,sp,96
    80006566:	8aaa                	mv	s5,a0
    80006568:	8a2e                	mv	s4,a1
    8000656a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000656c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80006570:	0001d517          	auipc	a0,0x1d
    80006574:	72050513          	addi	a0,a0,1824 # 80023c90 <cons>
    80006578:	00001097          	auipc	ra,0x1
    8000657c:	946080e7          	jalr	-1722(ra) # 80006ebe <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80006580:	0001d497          	auipc	s1,0x1d
    80006584:	71048493          	addi	s1,s1,1808 # 80023c90 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006588:	0001d917          	auipc	s2,0x1d
    8000658c:	7a090913          	addi	s2,s2,1952 # 80023d28 <cons+0x98>
  while (n > 0) {
    80006590:	0d305763          	blez	s3,8000665e <consoleread+0x10c>
    while (cons.r == cons.w) {
    80006594:	0984a783          	lw	a5,152(s1)
    80006598:	09c4a703          	lw	a4,156(s1)
    8000659c:	0af71c63          	bne	a4,a5,80006654 <consoleread+0x102>
      if (killed(myproc())) {
    800065a0:	ffffb097          	auipc	ra,0xffffb
    800065a4:	862080e7          	jalr	-1950(ra) # 80000e02 <myproc>
    800065a8:	ffffb097          	auipc	ra,0xffffb
    800065ac:	1b0080e7          	jalr	432(ra) # 80001758 <killed>
    800065b0:	e52d                	bnez	a0,8000661a <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800065b2:	85a6                	mv	a1,s1
    800065b4:	854a                	mv	a0,s2
    800065b6:	ffffb097          	auipc	ra,0xffffb
    800065ba:	efa080e7          	jalr	-262(ra) # 800014b0 <sleep>
    while (cons.r == cons.w) {
    800065be:	0984a783          	lw	a5,152(s1)
    800065c2:	09c4a703          	lw	a4,156(s1)
    800065c6:	fcf70de3          	beq	a4,a5,800065a0 <consoleread+0x4e>
    800065ca:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800065cc:	0001d717          	auipc	a4,0x1d
    800065d0:	6c470713          	addi	a4,a4,1732 # 80023c90 <cons>
    800065d4:	0017869b          	addiw	a3,a5,1
    800065d8:	08d72c23          	sw	a3,152(a4)
    800065dc:	07f7f693          	andi	a3,a5,127
    800065e0:	9736                	add	a4,a4,a3
    800065e2:	01874703          	lbu	a4,24(a4)
    800065e6:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) {  // end-of-file
    800065ea:	4691                	li	a3,4
    800065ec:	04db8a63          	beq	s7,a3,80006640 <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800065f0:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    800065f4:	4685                	li	a3,1
    800065f6:	faf40613          	addi	a2,s0,-81
    800065fa:	85d2                	mv	a1,s4
    800065fc:	8556                	mv	a0,s5
    800065fe:	ffffb097          	auipc	ra,0xffffb
    80006602:	2ba080e7          	jalr	698(ra) # 800018b8 <either_copyout>
    80006606:	57fd                	li	a5,-1
    80006608:	04f50a63          	beq	a0,a5,8000665c <consoleread+0x10a>

    dst++;
    8000660c:	0a05                	addi	s4,s4,1
    --n;
    8000660e:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80006610:	47a9                	li	a5,10
    80006612:	06fb8163          	beq	s7,a5,80006674 <consoleread+0x122>
    80006616:	6be2                	ld	s7,24(sp)
    80006618:	bfa5                	j	80006590 <consoleread+0x3e>
        release(&cons.lock);
    8000661a:	0001d517          	auipc	a0,0x1d
    8000661e:	67650513          	addi	a0,a0,1654 # 80023c90 <cons>
    80006622:	00001097          	auipc	ra,0x1
    80006626:	950080e7          	jalr	-1712(ra) # 80006f72 <release>
        return -1;
    8000662a:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000662c:	60e6                	ld	ra,88(sp)
    8000662e:	6446                	ld	s0,80(sp)
    80006630:	64a6                	ld	s1,72(sp)
    80006632:	6906                	ld	s2,64(sp)
    80006634:	79e2                	ld	s3,56(sp)
    80006636:	7a42                	ld	s4,48(sp)
    80006638:	7aa2                	ld	s5,40(sp)
    8000663a:	7b02                	ld	s6,32(sp)
    8000663c:	6125                	addi	sp,sp,96
    8000663e:	8082                	ret
      if (n < target) {
    80006640:	0009871b          	sext.w	a4,s3
    80006644:	01677a63          	bgeu	a4,s6,80006658 <consoleread+0x106>
        cons.r--;
    80006648:	0001d717          	auipc	a4,0x1d
    8000664c:	6ef72023          	sw	a5,1760(a4) # 80023d28 <cons+0x98>
    80006650:	6be2                	ld	s7,24(sp)
    80006652:	a031                	j	8000665e <consoleread+0x10c>
    80006654:	ec5e                	sd	s7,24(sp)
    80006656:	bf9d                	j	800065cc <consoleread+0x7a>
    80006658:	6be2                	ld	s7,24(sp)
    8000665a:	a011                	j	8000665e <consoleread+0x10c>
    8000665c:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000665e:	0001d517          	auipc	a0,0x1d
    80006662:	63250513          	addi	a0,a0,1586 # 80023c90 <cons>
    80006666:	00001097          	auipc	ra,0x1
    8000666a:	90c080e7          	jalr	-1780(ra) # 80006f72 <release>
  return target - n;
    8000666e:	413b053b          	subw	a0,s6,s3
    80006672:	bf6d                	j	8000662c <consoleread+0xda>
    80006674:	6be2                	ld	s7,24(sp)
    80006676:	b7e5                	j	8000665e <consoleread+0x10c>

0000000080006678 <consputc>:
void consputc(int c) {
    80006678:	1141                	addi	sp,sp,-16
    8000667a:	e406                	sd	ra,8(sp)
    8000667c:	e022                	sd	s0,0(sp)
    8000667e:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80006680:	10000793          	li	a5,256
    80006684:	00f50a63          	beq	a0,a5,80006698 <consputc+0x20>
    uartputc_sync(c);
    80006688:	00000097          	auipc	ra,0x0
    8000668c:	59c080e7          	jalr	1436(ra) # 80006c24 <uartputc_sync>
}
    80006690:	60a2                	ld	ra,8(sp)
    80006692:	6402                	ld	s0,0(sp)
    80006694:	0141                	addi	sp,sp,16
    80006696:	8082                	ret
    uartputc_sync('\b');
    80006698:	4521                	li	a0,8
    8000669a:	00000097          	auipc	ra,0x0
    8000669e:	58a080e7          	jalr	1418(ra) # 80006c24 <uartputc_sync>
    uartputc_sync(' ');
    800066a2:	02000513          	li	a0,32
    800066a6:	00000097          	auipc	ra,0x0
    800066aa:	57e080e7          	jalr	1406(ra) # 80006c24 <uartputc_sync>
    uartputc_sync('\b');
    800066ae:	4521                	li	a0,8
    800066b0:	00000097          	auipc	ra,0x0
    800066b4:	574080e7          	jalr	1396(ra) # 80006c24 <uartputc_sync>
    800066b8:	bfe1                	j	80006690 <consputc+0x18>

00000000800066ba <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    800066ba:	1101                	addi	sp,sp,-32
    800066bc:	ec06                	sd	ra,24(sp)
    800066be:	e822                	sd	s0,16(sp)
    800066c0:	e426                	sd	s1,8(sp)
    800066c2:	1000                	addi	s0,sp,32
    800066c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800066c6:	0001d517          	auipc	a0,0x1d
    800066ca:	5ca50513          	addi	a0,a0,1482 # 80023c90 <cons>
    800066ce:	00000097          	auipc	ra,0x0
    800066d2:	7f0080e7          	jalr	2032(ra) # 80006ebe <acquire>

  switch (c) {
    800066d6:	47d5                	li	a5,21
    800066d8:	0af48563          	beq	s1,a5,80006782 <consoleintr+0xc8>
    800066dc:	0297c963          	blt	a5,s1,8000670e <consoleintr+0x54>
    800066e0:	47a1                	li	a5,8
    800066e2:	0ef48c63          	beq	s1,a5,800067da <consoleintr+0x120>
    800066e6:	47c1                	li	a5,16
    800066e8:	10f49f63          	bne	s1,a5,80006806 <consoleintr+0x14c>
    case C('P'):  // Print process list.
      procdump();
    800066ec:	ffffb097          	auipc	ra,0xffffb
    800066f0:	278080e7          	jalr	632(ra) # 80001964 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    800066f4:	0001d517          	auipc	a0,0x1d
    800066f8:	59c50513          	addi	a0,a0,1436 # 80023c90 <cons>
    800066fc:	00001097          	auipc	ra,0x1
    80006700:	876080e7          	jalr	-1930(ra) # 80006f72 <release>
}
    80006704:	60e2                	ld	ra,24(sp)
    80006706:	6442                	ld	s0,16(sp)
    80006708:	64a2                	ld	s1,8(sp)
    8000670a:	6105                	addi	sp,sp,32
    8000670c:	8082                	ret
  switch (c) {
    8000670e:	07f00793          	li	a5,127
    80006712:	0cf48463          	beq	s1,a5,800067da <consoleintr+0x120>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80006716:	0001d717          	auipc	a4,0x1d
    8000671a:	57a70713          	addi	a4,a4,1402 # 80023c90 <cons>
    8000671e:	0a072783          	lw	a5,160(a4)
    80006722:	09872703          	lw	a4,152(a4)
    80006726:	9f99                	subw	a5,a5,a4
    80006728:	07f00713          	li	a4,127
    8000672c:	fcf764e3          	bltu	a4,a5,800066f4 <consoleintr+0x3a>
        c = (c == '\r') ? '\n' : c;
    80006730:	47b5                	li	a5,13
    80006732:	0cf48d63          	beq	s1,a5,8000680c <consoleintr+0x152>
        consputc(c);
    80006736:	8526                	mv	a0,s1
    80006738:	00000097          	auipc	ra,0x0
    8000673c:	f40080e7          	jalr	-192(ra) # 80006678 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006740:	0001d797          	auipc	a5,0x1d
    80006744:	55078793          	addi	a5,a5,1360 # 80023c90 <cons>
    80006748:	0a07a683          	lw	a3,160(a5)
    8000674c:	0016871b          	addiw	a4,a3,1
    80006750:	0007061b          	sext.w	a2,a4
    80006754:	0ae7a023          	sw	a4,160(a5)
    80006758:	07f6f693          	andi	a3,a3,127
    8000675c:	97b6                	add	a5,a5,a3
    8000675e:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80006762:	47a9                	li	a5,10
    80006764:	0cf48b63          	beq	s1,a5,8000683a <consoleintr+0x180>
    80006768:	4791                	li	a5,4
    8000676a:	0cf48863          	beq	s1,a5,8000683a <consoleintr+0x180>
    8000676e:	0001d797          	auipc	a5,0x1d
    80006772:	5ba7a783          	lw	a5,1466(a5) # 80023d28 <cons+0x98>
    80006776:	9f1d                	subw	a4,a4,a5
    80006778:	08000793          	li	a5,128
    8000677c:	f6f71ce3          	bne	a4,a5,800066f4 <consoleintr+0x3a>
    80006780:	a86d                	j	8000683a <consoleintr+0x180>
    80006782:	e04a                	sd	s2,0(sp)
      while (cons.e != cons.w &&
    80006784:	0001d717          	auipc	a4,0x1d
    80006788:	50c70713          	addi	a4,a4,1292 # 80023c90 <cons>
    8000678c:	0a072783          	lw	a5,160(a4)
    80006790:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80006794:	0001d497          	auipc	s1,0x1d
    80006798:	4fc48493          	addi	s1,s1,1276 # 80023c90 <cons>
      while (cons.e != cons.w &&
    8000679c:	4929                	li	s2,10
    8000679e:	02f70a63          	beq	a4,a5,800067d2 <consoleintr+0x118>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    800067a2:	37fd                	addiw	a5,a5,-1
    800067a4:	07f7f713          	andi	a4,a5,127
    800067a8:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    800067aa:	01874703          	lbu	a4,24(a4)
    800067ae:	03270463          	beq	a4,s2,800067d6 <consoleintr+0x11c>
        cons.e--;
    800067b2:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    800067b6:	10000513          	li	a0,256
    800067ba:	00000097          	auipc	ra,0x0
    800067be:	ebe080e7          	jalr	-322(ra) # 80006678 <consputc>
      while (cons.e != cons.w &&
    800067c2:	0a04a783          	lw	a5,160(s1)
    800067c6:	09c4a703          	lw	a4,156(s1)
    800067ca:	fcf71ce3          	bne	a4,a5,800067a2 <consoleintr+0xe8>
    800067ce:	6902                	ld	s2,0(sp)
    800067d0:	b715                	j	800066f4 <consoleintr+0x3a>
    800067d2:	6902                	ld	s2,0(sp)
    800067d4:	b705                	j	800066f4 <consoleintr+0x3a>
    800067d6:	6902                	ld	s2,0(sp)
    800067d8:	bf31                	j	800066f4 <consoleintr+0x3a>
      if (cons.e != cons.w) {
    800067da:	0001d717          	auipc	a4,0x1d
    800067de:	4b670713          	addi	a4,a4,1206 # 80023c90 <cons>
    800067e2:	0a072783          	lw	a5,160(a4)
    800067e6:	09c72703          	lw	a4,156(a4)
    800067ea:	f0f705e3          	beq	a4,a5,800066f4 <consoleintr+0x3a>
        cons.e--;
    800067ee:	37fd                	addiw	a5,a5,-1
    800067f0:	0001d717          	auipc	a4,0x1d
    800067f4:	54f72023          	sw	a5,1344(a4) # 80023d30 <cons+0xa0>
        consputc(BACKSPACE);
    800067f8:	10000513          	li	a0,256
    800067fc:	00000097          	auipc	ra,0x0
    80006800:	e7c080e7          	jalr	-388(ra) # 80006678 <consputc>
    80006804:	bdc5                	j	800066f4 <consoleintr+0x3a>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80006806:	ee0487e3          	beqz	s1,800066f4 <consoleintr+0x3a>
    8000680a:	b731                	j	80006716 <consoleintr+0x5c>
        consputc(c);
    8000680c:	4529                	li	a0,10
    8000680e:	00000097          	auipc	ra,0x0
    80006812:	e6a080e7          	jalr	-406(ra) # 80006678 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006816:	0001d797          	auipc	a5,0x1d
    8000681a:	47a78793          	addi	a5,a5,1146 # 80023c90 <cons>
    8000681e:	0a07a703          	lw	a4,160(a5)
    80006822:	0017069b          	addiw	a3,a4,1
    80006826:	0006861b          	sext.w	a2,a3
    8000682a:	0ad7a023          	sw	a3,160(a5)
    8000682e:	07f77713          	andi	a4,a4,127
    80006832:	97ba                	add	a5,a5,a4
    80006834:	4729                	li	a4,10
    80006836:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    8000683a:	0001d797          	auipc	a5,0x1d
    8000683e:	4ec7a923          	sw	a2,1266(a5) # 80023d2c <cons+0x9c>
          wakeup(&cons.r);
    80006842:	0001d517          	auipc	a0,0x1d
    80006846:	4e650513          	addi	a0,a0,1254 # 80023d28 <cons+0x98>
    8000684a:	ffffb097          	auipc	ra,0xffffb
    8000684e:	cca080e7          	jalr	-822(ra) # 80001514 <wakeup>
    80006852:	b54d                	j	800066f4 <consoleintr+0x3a>

0000000080006854 <consoleinit>:

void consoleinit(void) {
    80006854:	1141                	addi	sp,sp,-16
    80006856:	e406                	sd	ra,8(sp)
    80006858:	e022                	sd	s0,0(sp)
    8000685a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000685c:	00002597          	auipc	a1,0x2
    80006860:	fcc58593          	addi	a1,a1,-52 # 80008828 <etext+0x828>
    80006864:	0001d517          	auipc	a0,0x1d
    80006868:	42c50513          	addi	a0,a0,1068 # 80023c90 <cons>
    8000686c:	00000097          	auipc	ra,0x0
    80006870:	5c2080e7          	jalr	1474(ra) # 80006e2e <initlock>

  uartinit();
    80006874:	00000097          	auipc	ra,0x0
    80006878:	354080e7          	jalr	852(ra) # 80006bc8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000687c:	00015797          	auipc	a5,0x15
    80006880:	0dc78793          	addi	a5,a5,220 # 8001b958 <devsw>
    80006884:	00000717          	auipc	a4,0x0
    80006888:	cce70713          	addi	a4,a4,-818 # 80006552 <consoleread>
    8000688c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000688e:	00000717          	auipc	a4,0x0
    80006892:	c5670713          	addi	a4,a4,-938 # 800064e4 <consolewrite>
    80006896:	ef98                	sd	a4,24(a5)
}
    80006898:	60a2                	ld	ra,8(sp)
    8000689a:	6402                	ld	s0,0(sp)
    8000689c:	0141                	addi	sp,sp,16
    8000689e:	8082                	ret

00000000800068a0 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    800068a0:	7179                	addi	sp,sp,-48
    800068a2:	f406                	sd	ra,40(sp)
    800068a4:	f022                	sd	s0,32(sp)
    800068a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800068a8:	c219                	beqz	a2,800068ae <printint+0xe>
    800068aa:	08054963          	bltz	a0,8000693c <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800068ae:	2501                	sext.w	a0,a0
    800068b0:	4881                	li	a7,0
    800068b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800068b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800068b8:	2581                	sext.w	a1,a1
    800068ba:	00002617          	auipc	a2,0x2
    800068be:	0ce60613          	addi	a2,a2,206 # 80008988 <digits>
    800068c2:	883a                	mv	a6,a4
    800068c4:	2705                	addiw	a4,a4,1
    800068c6:	02b577bb          	remuw	a5,a0,a1
    800068ca:	1782                	slli	a5,a5,0x20
    800068cc:	9381                	srli	a5,a5,0x20
    800068ce:	97b2                	add	a5,a5,a2
    800068d0:	0007c783          	lbu	a5,0(a5)
    800068d4:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800068d8:	0005079b          	sext.w	a5,a0
    800068dc:	02b5553b          	divuw	a0,a0,a1
    800068e0:	0685                	addi	a3,a3,1
    800068e2:	feb7f0e3          	bgeu	a5,a1,800068c2 <printint+0x22>

  if (sign) buf[i++] = '-';
    800068e6:	00088c63          	beqz	a7,800068fe <printint+0x5e>
    800068ea:	fe070793          	addi	a5,a4,-32
    800068ee:	00878733          	add	a4,a5,s0
    800068f2:	02d00793          	li	a5,45
    800068f6:	fef70823          	sb	a5,-16(a4)
    800068fa:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    800068fe:	02e05b63          	blez	a4,80006934 <printint+0x94>
    80006902:	ec26                	sd	s1,24(sp)
    80006904:	e84a                	sd	s2,16(sp)
    80006906:	fd040793          	addi	a5,s0,-48
    8000690a:	00e784b3          	add	s1,a5,a4
    8000690e:	fff78913          	addi	s2,a5,-1
    80006912:	993a                	add	s2,s2,a4
    80006914:	377d                	addiw	a4,a4,-1
    80006916:	1702                	slli	a4,a4,0x20
    80006918:	9301                	srli	a4,a4,0x20
    8000691a:	40e90933          	sub	s2,s2,a4
    8000691e:	fff4c503          	lbu	a0,-1(s1)
    80006922:	00000097          	auipc	ra,0x0
    80006926:	d56080e7          	jalr	-682(ra) # 80006678 <consputc>
    8000692a:	14fd                	addi	s1,s1,-1
    8000692c:	ff2499e3          	bne	s1,s2,8000691e <printint+0x7e>
    80006930:	64e2                	ld	s1,24(sp)
    80006932:	6942                	ld	s2,16(sp)
}
    80006934:	70a2                	ld	ra,40(sp)
    80006936:	7402                	ld	s0,32(sp)
    80006938:	6145                	addi	sp,sp,48
    8000693a:	8082                	ret
    x = -xx;
    8000693c:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80006940:	4885                	li	a7,1
    x = -xx;
    80006942:	bf85                	j	800068b2 <printint+0x12>

0000000080006944 <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80006944:	1101                	addi	sp,sp,-32
    80006946:	ec06                	sd	ra,24(sp)
    80006948:	e822                	sd	s0,16(sp)
    8000694a:	e426                	sd	s1,8(sp)
    8000694c:	1000                	addi	s0,sp,32
    8000694e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006950:	0001d797          	auipc	a5,0x1d
    80006954:	4007a023          	sw	zero,1024(a5) # 80023d50 <pr+0x18>
  printf("panic: ");
    80006958:	00002517          	auipc	a0,0x2
    8000695c:	ed850513          	addi	a0,a0,-296 # 80008830 <etext+0x830>
    80006960:	00000097          	auipc	ra,0x0
    80006964:	02e080e7          	jalr	46(ra) # 8000698e <printf>
  printf(s);
    80006968:	8526                	mv	a0,s1
    8000696a:	00000097          	auipc	ra,0x0
    8000696e:	024080e7          	jalr	36(ra) # 8000698e <printf>
  printf("\n");
    80006972:	00001517          	auipc	a0,0x1
    80006976:	68e50513          	addi	a0,a0,1678 # 80008000 <etext>
    8000697a:	00000097          	auipc	ra,0x0
    8000697e:	014080e7          	jalr	20(ra) # 8000698e <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80006982:	4785                	li	a5,1
    80006984:	00005717          	auipc	a4,0x5
    80006988:	f4f72023          	sw	a5,-192(a4) # 8000b8c4 <panicked>
  for (;;);
    8000698c:	a001                	j	8000698c <panic+0x48>

000000008000698e <printf>:
void printf(char *fmt, ...) {
    8000698e:	7131                	addi	sp,sp,-192
    80006990:	fc86                	sd	ra,120(sp)
    80006992:	f8a2                	sd	s0,112(sp)
    80006994:	e8d2                	sd	s4,80(sp)
    80006996:	f06a                	sd	s10,32(sp)
    80006998:	0100                	addi	s0,sp,128
    8000699a:	8a2a                	mv	s4,a0
    8000699c:	e40c                	sd	a1,8(s0)
    8000699e:	e810                	sd	a2,16(s0)
    800069a0:	ec14                	sd	a3,24(s0)
    800069a2:	f018                	sd	a4,32(s0)
    800069a4:	f41c                	sd	a5,40(s0)
    800069a6:	03043823          	sd	a6,48(s0)
    800069aa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800069ae:	0001dd17          	auipc	s10,0x1d
    800069b2:	3a2d2d03          	lw	s10,930(s10) # 80023d50 <pr+0x18>
  if (locking) acquire(&pr.lock);
    800069b6:	040d1463          	bnez	s10,800069fe <printf+0x70>
  if (fmt == 0) panic("null fmt");
    800069ba:	040a0b63          	beqz	s4,80006a10 <printf+0x82>
  va_start(ap, fmt);
    800069be:	00840793          	addi	a5,s0,8
    800069c2:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    800069c6:	000a4503          	lbu	a0,0(s4)
    800069ca:	18050b63          	beqz	a0,80006b60 <printf+0x1d2>
    800069ce:	f4a6                	sd	s1,104(sp)
    800069d0:	f0ca                	sd	s2,96(sp)
    800069d2:	ecce                	sd	s3,88(sp)
    800069d4:	e4d6                	sd	s5,72(sp)
    800069d6:	e0da                	sd	s6,64(sp)
    800069d8:	fc5e                	sd	s7,56(sp)
    800069da:	f862                	sd	s8,48(sp)
    800069dc:	f466                	sd	s9,40(sp)
    800069de:	ec6e                	sd	s11,24(sp)
    800069e0:	4981                	li	s3,0
    if (c != '%') {
    800069e2:	02500b13          	li	s6,37
    switch (c) {
    800069e6:	07000b93          	li	s7,112
  consputc('x');
    800069ea:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800069ec:	00002a97          	auipc	s5,0x2
    800069f0:	f9ca8a93          	addi	s5,s5,-100 # 80008988 <digits>
    switch (c) {
    800069f4:	07300c13          	li	s8,115
    800069f8:	06400d93          	li	s11,100
    800069fc:	a0b1                	j	80006a48 <printf+0xba>
  if (locking) acquire(&pr.lock);
    800069fe:	0001d517          	auipc	a0,0x1d
    80006a02:	33a50513          	addi	a0,a0,826 # 80023d38 <pr>
    80006a06:	00000097          	auipc	ra,0x0
    80006a0a:	4b8080e7          	jalr	1208(ra) # 80006ebe <acquire>
    80006a0e:	b775                	j	800069ba <printf+0x2c>
    80006a10:	f4a6                	sd	s1,104(sp)
    80006a12:	f0ca                	sd	s2,96(sp)
    80006a14:	ecce                	sd	s3,88(sp)
    80006a16:	e4d6                	sd	s5,72(sp)
    80006a18:	e0da                	sd	s6,64(sp)
    80006a1a:	fc5e                	sd	s7,56(sp)
    80006a1c:	f862                	sd	s8,48(sp)
    80006a1e:	f466                	sd	s9,40(sp)
    80006a20:	ec6e                	sd	s11,24(sp)
  if (fmt == 0) panic("null fmt");
    80006a22:	00002517          	auipc	a0,0x2
    80006a26:	e1e50513          	addi	a0,a0,-482 # 80008840 <etext+0x840>
    80006a2a:	00000097          	auipc	ra,0x0
    80006a2e:	f1a080e7          	jalr	-230(ra) # 80006944 <panic>
      consputc(c);
    80006a32:	00000097          	auipc	ra,0x0
    80006a36:	c46080e7          	jalr	-954(ra) # 80006678 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006a3a:	2985                	addiw	s3,s3,1
    80006a3c:	013a07b3          	add	a5,s4,s3
    80006a40:	0007c503          	lbu	a0,0(a5)
    80006a44:	10050563          	beqz	a0,80006b4e <printf+0x1c0>
    if (c != '%') {
    80006a48:	ff6515e3          	bne	a0,s6,80006a32 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006a4c:	2985                	addiw	s3,s3,1
    80006a4e:	013a07b3          	add	a5,s4,s3
    80006a52:	0007c783          	lbu	a5,0(a5)
    80006a56:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006a5a:	10078b63          	beqz	a5,80006b70 <printf+0x1e2>
    switch (c) {
    80006a5e:	05778a63          	beq	a5,s7,80006ab2 <printf+0x124>
    80006a62:	02fbf663          	bgeu	s7,a5,80006a8e <printf+0x100>
    80006a66:	09878863          	beq	a5,s8,80006af6 <printf+0x168>
    80006a6a:	07800713          	li	a4,120
    80006a6e:	0ce79563          	bne	a5,a4,80006b38 <printf+0x1aa>
        printint(va_arg(ap, int), 16, 1);
    80006a72:	f8843783          	ld	a5,-120(s0)
    80006a76:	00878713          	addi	a4,a5,8
    80006a7a:	f8e43423          	sd	a4,-120(s0)
    80006a7e:	4605                	li	a2,1
    80006a80:	85e6                	mv	a1,s9
    80006a82:	4388                	lw	a0,0(a5)
    80006a84:	00000097          	auipc	ra,0x0
    80006a88:	e1c080e7          	jalr	-484(ra) # 800068a0 <printint>
        break;
    80006a8c:	b77d                	j	80006a3a <printf+0xac>
    switch (c) {
    80006a8e:	09678f63          	beq	a5,s6,80006b2c <printf+0x19e>
    80006a92:	0bb79363          	bne	a5,s11,80006b38 <printf+0x1aa>
        printint(va_arg(ap, int), 10, 1);
    80006a96:	f8843783          	ld	a5,-120(s0)
    80006a9a:	00878713          	addi	a4,a5,8
    80006a9e:	f8e43423          	sd	a4,-120(s0)
    80006aa2:	4605                	li	a2,1
    80006aa4:	45a9                	li	a1,10
    80006aa6:	4388                	lw	a0,0(a5)
    80006aa8:	00000097          	auipc	ra,0x0
    80006aac:	df8080e7          	jalr	-520(ra) # 800068a0 <printint>
        break;
    80006ab0:	b769                	j	80006a3a <printf+0xac>
        printptr(va_arg(ap, uint64));
    80006ab2:	f8843783          	ld	a5,-120(s0)
    80006ab6:	00878713          	addi	a4,a5,8
    80006aba:	f8e43423          	sd	a4,-120(s0)
    80006abe:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006ac2:	03000513          	li	a0,48
    80006ac6:	00000097          	auipc	ra,0x0
    80006aca:	bb2080e7          	jalr	-1102(ra) # 80006678 <consputc>
  consputc('x');
    80006ace:	07800513          	li	a0,120
    80006ad2:	00000097          	auipc	ra,0x0
    80006ad6:	ba6080e7          	jalr	-1114(ra) # 80006678 <consputc>
    80006ada:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006adc:	03c95793          	srli	a5,s2,0x3c
    80006ae0:	97d6                	add	a5,a5,s5
    80006ae2:	0007c503          	lbu	a0,0(a5)
    80006ae6:	00000097          	auipc	ra,0x0
    80006aea:	b92080e7          	jalr	-1134(ra) # 80006678 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006aee:	0912                	slli	s2,s2,0x4
    80006af0:	34fd                	addiw	s1,s1,-1
    80006af2:	f4ed                	bnez	s1,80006adc <printf+0x14e>
    80006af4:	b799                	j	80006a3a <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006af6:	f8843783          	ld	a5,-120(s0)
    80006afa:	00878713          	addi	a4,a5,8
    80006afe:	f8e43423          	sd	a4,-120(s0)
    80006b02:	6384                	ld	s1,0(a5)
    80006b04:	cc89                	beqz	s1,80006b1e <printf+0x190>
        for (; *s; s++) consputc(*s);
    80006b06:	0004c503          	lbu	a0,0(s1)
    80006b0a:	d905                	beqz	a0,80006a3a <printf+0xac>
    80006b0c:	00000097          	auipc	ra,0x0
    80006b10:	b6c080e7          	jalr	-1172(ra) # 80006678 <consputc>
    80006b14:	0485                	addi	s1,s1,1
    80006b16:	0004c503          	lbu	a0,0(s1)
    80006b1a:	f96d                	bnez	a0,80006b0c <printf+0x17e>
    80006b1c:	bf39                	j	80006a3a <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006b1e:	00002497          	auipc	s1,0x2
    80006b22:	d1a48493          	addi	s1,s1,-742 # 80008838 <etext+0x838>
        for (; *s; s++) consputc(*s);
    80006b26:	02800513          	li	a0,40
    80006b2a:	b7cd                	j	80006b0c <printf+0x17e>
        consputc('%');
    80006b2c:	855a                	mv	a0,s6
    80006b2e:	00000097          	auipc	ra,0x0
    80006b32:	b4a080e7          	jalr	-1206(ra) # 80006678 <consputc>
        break;
    80006b36:	b711                	j	80006a3a <printf+0xac>
        consputc('%');
    80006b38:	855a                	mv	a0,s6
    80006b3a:	00000097          	auipc	ra,0x0
    80006b3e:	b3e080e7          	jalr	-1218(ra) # 80006678 <consputc>
        consputc(c);
    80006b42:	8526                	mv	a0,s1
    80006b44:	00000097          	auipc	ra,0x0
    80006b48:	b34080e7          	jalr	-1228(ra) # 80006678 <consputc>
        break;
    80006b4c:	b5fd                	j	80006a3a <printf+0xac>
    80006b4e:	74a6                	ld	s1,104(sp)
    80006b50:	7906                	ld	s2,96(sp)
    80006b52:	69e6                	ld	s3,88(sp)
    80006b54:	6aa6                	ld	s5,72(sp)
    80006b56:	6b06                	ld	s6,64(sp)
    80006b58:	7be2                	ld	s7,56(sp)
    80006b5a:	7c42                	ld	s8,48(sp)
    80006b5c:	7ca2                	ld	s9,40(sp)
    80006b5e:	6de2                	ld	s11,24(sp)
  if (locking) release(&pr.lock);
    80006b60:	020d1263          	bnez	s10,80006b84 <printf+0x1f6>
}
    80006b64:	70e6                	ld	ra,120(sp)
    80006b66:	7446                	ld	s0,112(sp)
    80006b68:	6a46                	ld	s4,80(sp)
    80006b6a:	7d02                	ld	s10,32(sp)
    80006b6c:	6129                	addi	sp,sp,192
    80006b6e:	8082                	ret
    80006b70:	74a6                	ld	s1,104(sp)
    80006b72:	7906                	ld	s2,96(sp)
    80006b74:	69e6                	ld	s3,88(sp)
    80006b76:	6aa6                	ld	s5,72(sp)
    80006b78:	6b06                	ld	s6,64(sp)
    80006b7a:	7be2                	ld	s7,56(sp)
    80006b7c:	7c42                	ld	s8,48(sp)
    80006b7e:	7ca2                	ld	s9,40(sp)
    80006b80:	6de2                	ld	s11,24(sp)
    80006b82:	bff9                	j	80006b60 <printf+0x1d2>
  if (locking) release(&pr.lock);
    80006b84:	0001d517          	auipc	a0,0x1d
    80006b88:	1b450513          	addi	a0,a0,436 # 80023d38 <pr>
    80006b8c:	00000097          	auipc	ra,0x0
    80006b90:	3e6080e7          	jalr	998(ra) # 80006f72 <release>
}
    80006b94:	bfc1                	j	80006b64 <printf+0x1d6>

0000000080006b96 <printfinit>:
}

void printfinit(void) {
    80006b96:	1101                	addi	sp,sp,-32
    80006b98:	ec06                	sd	ra,24(sp)
    80006b9a:	e822                	sd	s0,16(sp)
    80006b9c:	e426                	sd	s1,8(sp)
    80006b9e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006ba0:	0001d497          	auipc	s1,0x1d
    80006ba4:	19848493          	addi	s1,s1,408 # 80023d38 <pr>
    80006ba8:	00002597          	auipc	a1,0x2
    80006bac:	ca858593          	addi	a1,a1,-856 # 80008850 <etext+0x850>
    80006bb0:	8526                	mv	a0,s1
    80006bb2:	00000097          	auipc	ra,0x0
    80006bb6:	27c080e7          	jalr	636(ra) # 80006e2e <initlock>
  pr.locking = 1;
    80006bba:	4785                	li	a5,1
    80006bbc:	cc9c                	sw	a5,24(s1)
}
    80006bbe:	60e2                	ld	ra,24(sp)
    80006bc0:	6442                	ld	s0,16(sp)
    80006bc2:	64a2                	ld	s1,8(sp)
    80006bc4:	6105                	addi	sp,sp,32
    80006bc6:	8082                	ret

0000000080006bc8 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006bc8:	1141                	addi	sp,sp,-16
    80006bca:	e406                	sd	ra,8(sp)
    80006bcc:	e022                	sd	s0,0(sp)
    80006bce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006bd0:	100007b7          	lui	a5,0x10000
    80006bd4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006bd8:	10000737          	lui	a4,0x10000
    80006bdc:	f8000693          	li	a3,-128
    80006be0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006be4:	468d                	li	a3,3
    80006be6:	10000637          	lui	a2,0x10000
    80006bea:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006bee:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006bf2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006bf6:	10000737          	lui	a4,0x10000
    80006bfa:	461d                	li	a2,7
    80006bfc:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006c00:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006c04:	00002597          	auipc	a1,0x2
    80006c08:	c5458593          	addi	a1,a1,-940 # 80008858 <etext+0x858>
    80006c0c:	0001d517          	auipc	a0,0x1d
    80006c10:	14c50513          	addi	a0,a0,332 # 80023d58 <uart_tx_lock>
    80006c14:	00000097          	auipc	ra,0x0
    80006c18:	21a080e7          	jalr	538(ra) # 80006e2e <initlock>
}
    80006c1c:	60a2                	ld	ra,8(sp)
    80006c1e:	6402                	ld	s0,0(sp)
    80006c20:	0141                	addi	sp,sp,16
    80006c22:	8082                	ret

0000000080006c24 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006c24:	1101                	addi	sp,sp,-32
    80006c26:	ec06                	sd	ra,24(sp)
    80006c28:	e822                	sd	s0,16(sp)
    80006c2a:	e426                	sd	s1,8(sp)
    80006c2c:	1000                	addi	s0,sp,32
    80006c2e:	84aa                	mv	s1,a0
  push_off();
    80006c30:	00000097          	auipc	ra,0x0
    80006c34:	242080e7          	jalr	578(ra) # 80006e72 <push_off>

  if (panicked) {
    80006c38:	00005797          	auipc	a5,0x5
    80006c3c:	c8c7a783          	lw	a5,-884(a5) # 8000b8c4 <panicked>
    80006c40:	eb85                	bnez	a5,80006c70 <uartputc_sync+0x4c>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006c42:	10000737          	lui	a4,0x10000
    80006c46:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006c48:	00074783          	lbu	a5,0(a4)
    80006c4c:	0207f793          	andi	a5,a5,32
    80006c50:	dfe5                	beqz	a5,80006c48 <uartputc_sync+0x24>
  WriteReg(THR, c);
    80006c52:	0ff4f513          	zext.b	a0,s1
    80006c56:	100007b7          	lui	a5,0x10000
    80006c5a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006c5e:	00000097          	auipc	ra,0x0
    80006c62:	2b4080e7          	jalr	692(ra) # 80006f12 <pop_off>
}
    80006c66:	60e2                	ld	ra,24(sp)
    80006c68:	6442                	ld	s0,16(sp)
    80006c6a:	64a2                	ld	s1,8(sp)
    80006c6c:	6105                	addi	sp,sp,32
    80006c6e:	8082                	ret
    for (;;);
    80006c70:	a001                	j	80006c70 <uartputc_sync+0x4c>

0000000080006c72 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80006c72:	00005797          	auipc	a5,0x5
    80006c76:	c567b783          	ld	a5,-938(a5) # 8000b8c8 <uart_tx_r>
    80006c7a:	00005717          	auipc	a4,0x5
    80006c7e:	c5673703          	ld	a4,-938(a4) # 8000b8d0 <uart_tx_w>
    80006c82:	06f70f63          	beq	a4,a5,80006d00 <uartstart+0x8e>
void uartstart() {
    80006c86:	7139                	addi	sp,sp,-64
    80006c88:	fc06                	sd	ra,56(sp)
    80006c8a:	f822                	sd	s0,48(sp)
    80006c8c:	f426                	sd	s1,40(sp)
    80006c8e:	f04a                	sd	s2,32(sp)
    80006c90:	ec4e                	sd	s3,24(sp)
    80006c92:	e852                	sd	s4,16(sp)
    80006c94:	e456                	sd	s5,8(sp)
    80006c96:	e05a                	sd	s6,0(sp)
    80006c98:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006c9a:	10000937          	lui	s2,0x10000
    80006c9e:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006ca0:	0001da97          	auipc	s5,0x1d
    80006ca4:	0b8a8a93          	addi	s5,s5,184 # 80023d58 <uart_tx_lock>
    uart_tx_r += 1;
    80006ca8:	00005497          	auipc	s1,0x5
    80006cac:	c2048493          	addi	s1,s1,-992 # 8000b8c8 <uart_tx_r>

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);

    WriteReg(THR, c);
    80006cb0:	10000a37          	lui	s4,0x10000
    if (uart_tx_w == uart_tx_r) {
    80006cb4:	00005997          	auipc	s3,0x5
    80006cb8:	c1c98993          	addi	s3,s3,-996 # 8000b8d0 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006cbc:	00094703          	lbu	a4,0(s2)
    80006cc0:	02077713          	andi	a4,a4,32
    80006cc4:	c705                	beqz	a4,80006cec <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006cc6:	01f7f713          	andi	a4,a5,31
    80006cca:	9756                	add	a4,a4,s5
    80006ccc:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006cd0:	0785                	addi	a5,a5,1
    80006cd2:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006cd4:	8526                	mv	a0,s1
    80006cd6:	ffffb097          	auipc	ra,0xffffb
    80006cda:	83e080e7          	jalr	-1986(ra) # 80001514 <wakeup>
    WriteReg(THR, c);
    80006cde:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if (uart_tx_w == uart_tx_r) {
    80006ce2:	609c                	ld	a5,0(s1)
    80006ce4:	0009b703          	ld	a4,0(s3)
    80006ce8:	fcf71ae3          	bne	a4,a5,80006cbc <uartstart+0x4a>
  }
}
    80006cec:	70e2                	ld	ra,56(sp)
    80006cee:	7442                	ld	s0,48(sp)
    80006cf0:	74a2                	ld	s1,40(sp)
    80006cf2:	7902                	ld	s2,32(sp)
    80006cf4:	69e2                	ld	s3,24(sp)
    80006cf6:	6a42                	ld	s4,16(sp)
    80006cf8:	6aa2                	ld	s5,8(sp)
    80006cfa:	6b02                	ld	s6,0(sp)
    80006cfc:	6121                	addi	sp,sp,64
    80006cfe:	8082                	ret
    80006d00:	8082                	ret

0000000080006d02 <uartputc>:
void uartputc(int c) {
    80006d02:	7179                	addi	sp,sp,-48
    80006d04:	f406                	sd	ra,40(sp)
    80006d06:	f022                	sd	s0,32(sp)
    80006d08:	ec26                	sd	s1,24(sp)
    80006d0a:	e84a                	sd	s2,16(sp)
    80006d0c:	e44e                	sd	s3,8(sp)
    80006d0e:	e052                	sd	s4,0(sp)
    80006d10:	1800                	addi	s0,sp,48
    80006d12:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006d14:	0001d517          	auipc	a0,0x1d
    80006d18:	04450513          	addi	a0,a0,68 # 80023d58 <uart_tx_lock>
    80006d1c:	00000097          	auipc	ra,0x0
    80006d20:	1a2080e7          	jalr	418(ra) # 80006ebe <acquire>
  if (panicked) {
    80006d24:	00005797          	auipc	a5,0x5
    80006d28:	ba07a783          	lw	a5,-1120(a5) # 8000b8c4 <panicked>
    80006d2c:	e7c9                	bnez	a5,80006db6 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006d2e:	00005717          	auipc	a4,0x5
    80006d32:	ba273703          	ld	a4,-1118(a4) # 8000b8d0 <uart_tx_w>
    80006d36:	00005797          	auipc	a5,0x5
    80006d3a:	b927b783          	ld	a5,-1134(a5) # 8000b8c8 <uart_tx_r>
    80006d3e:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006d42:	0001d997          	auipc	s3,0x1d
    80006d46:	01698993          	addi	s3,s3,22 # 80023d58 <uart_tx_lock>
    80006d4a:	00005497          	auipc	s1,0x5
    80006d4e:	b7e48493          	addi	s1,s1,-1154 # 8000b8c8 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006d52:	00005917          	auipc	s2,0x5
    80006d56:	b7e90913          	addi	s2,s2,-1154 # 8000b8d0 <uart_tx_w>
    80006d5a:	00e79f63          	bne	a5,a4,80006d78 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006d5e:	85ce                	mv	a1,s3
    80006d60:	8526                	mv	a0,s1
    80006d62:	ffffa097          	auipc	ra,0xffffa
    80006d66:	74e080e7          	jalr	1870(ra) # 800014b0 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006d6a:	00093703          	ld	a4,0(s2)
    80006d6e:	609c                	ld	a5,0(s1)
    80006d70:	02078793          	addi	a5,a5,32
    80006d74:	fee785e3          	beq	a5,a4,80006d5e <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006d78:	0001d497          	auipc	s1,0x1d
    80006d7c:	fe048493          	addi	s1,s1,-32 # 80023d58 <uart_tx_lock>
    80006d80:	01f77793          	andi	a5,a4,31
    80006d84:	97a6                	add	a5,a5,s1
    80006d86:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006d8a:	0705                	addi	a4,a4,1
    80006d8c:	00005797          	auipc	a5,0x5
    80006d90:	b4e7b223          	sd	a4,-1212(a5) # 8000b8d0 <uart_tx_w>
  uartstart();
    80006d94:	00000097          	auipc	ra,0x0
    80006d98:	ede080e7          	jalr	-290(ra) # 80006c72 <uartstart>
  release(&uart_tx_lock);
    80006d9c:	8526                	mv	a0,s1
    80006d9e:	00000097          	auipc	ra,0x0
    80006da2:	1d4080e7          	jalr	468(ra) # 80006f72 <release>
}
    80006da6:	70a2                	ld	ra,40(sp)
    80006da8:	7402                	ld	s0,32(sp)
    80006daa:	64e2                	ld	s1,24(sp)
    80006dac:	6942                	ld	s2,16(sp)
    80006dae:	69a2                	ld	s3,8(sp)
    80006db0:	6a02                	ld	s4,0(sp)
    80006db2:	6145                	addi	sp,sp,48
    80006db4:	8082                	ret
    for (;;);
    80006db6:	a001                	j	80006db6 <uartputc+0xb4>

0000000080006db8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006db8:	1141                	addi	sp,sp,-16
    80006dba:	e422                	sd	s0,8(sp)
    80006dbc:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006dbe:	100007b7          	lui	a5,0x10000
    80006dc2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006dc4:	0007c783          	lbu	a5,0(a5)
    80006dc8:	8b85                	andi	a5,a5,1
    80006dca:	cb81                	beqz	a5,80006dda <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006dcc:	100007b7          	lui	a5,0x10000
    80006dd0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006dd4:	6422                	ld	s0,8(sp)
    80006dd6:	0141                	addi	sp,sp,16
    80006dd8:	8082                	ret
    return -1;
    80006dda:	557d                	li	a0,-1
    80006ddc:	bfe5                	j	80006dd4 <uartgetc+0x1c>

0000000080006dde <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006dde:	1101                	addi	sp,sp,-32
    80006de0:	ec06                	sd	ra,24(sp)
    80006de2:	e822                	sd	s0,16(sp)
    80006de4:	e426                	sd	s1,8(sp)
    80006de6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006de8:	54fd                	li	s1,-1
    80006dea:	a029                	j	80006df4 <uartintr+0x16>
    consoleintr(c);
    80006dec:	00000097          	auipc	ra,0x0
    80006df0:	8ce080e7          	jalr	-1842(ra) # 800066ba <consoleintr>
    int c = uartgetc();
    80006df4:	00000097          	auipc	ra,0x0
    80006df8:	fc4080e7          	jalr	-60(ra) # 80006db8 <uartgetc>
    if (c == -1) break;
    80006dfc:	fe9518e3          	bne	a0,s1,80006dec <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006e00:	0001d497          	auipc	s1,0x1d
    80006e04:	f5848493          	addi	s1,s1,-168 # 80023d58 <uart_tx_lock>
    80006e08:	8526                	mv	a0,s1
    80006e0a:	00000097          	auipc	ra,0x0
    80006e0e:	0b4080e7          	jalr	180(ra) # 80006ebe <acquire>
  uartstart();
    80006e12:	00000097          	auipc	ra,0x0
    80006e16:	e60080e7          	jalr	-416(ra) # 80006c72 <uartstart>
  release(&uart_tx_lock);
    80006e1a:	8526                	mv	a0,s1
    80006e1c:	00000097          	auipc	ra,0x0
    80006e20:	156080e7          	jalr	342(ra) # 80006f72 <release>
}
    80006e24:	60e2                	ld	ra,24(sp)
    80006e26:	6442                	ld	s0,16(sp)
    80006e28:	64a2                	ld	s1,8(sp)
    80006e2a:	6105                	addi	sp,sp,32
    80006e2c:	8082                	ret

0000000080006e2e <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    80006e2e:	1141                	addi	sp,sp,-16
    80006e30:	e422                	sd	s0,8(sp)
    80006e32:	0800                	addi	s0,sp,16
  lk->name = name;
    80006e34:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006e36:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006e3a:	00053823          	sd	zero,16(a0)
}
    80006e3e:	6422                	ld	s0,8(sp)
    80006e40:	0141                	addi	sp,sp,16
    80006e42:	8082                	ret

0000000080006e44 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006e44:	411c                	lw	a5,0(a0)
    80006e46:	e399                	bnez	a5,80006e4c <holding+0x8>
    80006e48:	4501                	li	a0,0
  return r;
}
    80006e4a:	8082                	ret
int holding(struct spinlock *lk) {
    80006e4c:	1101                	addi	sp,sp,-32
    80006e4e:	ec06                	sd	ra,24(sp)
    80006e50:	e822                	sd	s0,16(sp)
    80006e52:	e426                	sd	s1,8(sp)
    80006e54:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006e56:	6904                	ld	s1,16(a0)
    80006e58:	ffffa097          	auipc	ra,0xffffa
    80006e5c:	f8e080e7          	jalr	-114(ra) # 80000de6 <mycpu>
    80006e60:	40a48533          	sub	a0,s1,a0
    80006e64:	00153513          	seqz	a0,a0
}
    80006e68:	60e2                	ld	ra,24(sp)
    80006e6a:	6442                	ld	s0,16(sp)
    80006e6c:	64a2                	ld	s1,8(sp)
    80006e6e:	6105                	addi	sp,sp,32
    80006e70:	8082                	ret

0000000080006e72 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    80006e72:	1101                	addi	sp,sp,-32
    80006e74:	ec06                	sd	ra,24(sp)
    80006e76:	e822                	sd	s0,16(sp)
    80006e78:	e426                	sd	s1,8(sp)
    80006e7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006e7c:	100024f3          	csrr	s1,sstatus
    80006e80:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80006e84:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006e86:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006e8a:	ffffa097          	auipc	ra,0xffffa
    80006e8e:	f5c080e7          	jalr	-164(ra) # 80000de6 <mycpu>
    80006e92:	5d3c                	lw	a5,120(a0)
    80006e94:	cf89                	beqz	a5,80006eae <push_off+0x3c>
  mycpu()->noff += 1;
    80006e96:	ffffa097          	auipc	ra,0xffffa
    80006e9a:	f50080e7          	jalr	-176(ra) # 80000de6 <mycpu>
    80006e9e:	5d3c                	lw	a5,120(a0)
    80006ea0:	2785                	addiw	a5,a5,1
    80006ea2:	dd3c                	sw	a5,120(a0)
}
    80006ea4:	60e2                	ld	ra,24(sp)
    80006ea6:	6442                	ld	s0,16(sp)
    80006ea8:	64a2                	ld	s1,8(sp)
    80006eaa:	6105                	addi	sp,sp,32
    80006eac:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006eae:	ffffa097          	auipc	ra,0xffffa
    80006eb2:	f38080e7          	jalr	-200(ra) # 80000de6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006eb6:	8085                	srli	s1,s1,0x1
    80006eb8:	8885                	andi	s1,s1,1
    80006eba:	dd64                	sw	s1,124(a0)
    80006ebc:	bfe9                	j	80006e96 <push_off+0x24>

0000000080006ebe <acquire>:
void acquire(struct spinlock *lk) {
    80006ebe:	1101                	addi	sp,sp,-32
    80006ec0:	ec06                	sd	ra,24(sp)
    80006ec2:	e822                	sd	s0,16(sp)
    80006ec4:	e426                	sd	s1,8(sp)
    80006ec6:	1000                	addi	s0,sp,32
    80006ec8:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006eca:	00000097          	auipc	ra,0x0
    80006ece:	fa8080e7          	jalr	-88(ra) # 80006e72 <push_off>
  if (holding(lk)) panic("acquire");
    80006ed2:	8526                	mv	a0,s1
    80006ed4:	00000097          	auipc	ra,0x0
    80006ed8:	f70080e7          	jalr	-144(ra) # 80006e44 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006edc:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006ede:	e115                	bnez	a0,80006f02 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80006ee0:	87ba                	mv	a5,a4
    80006ee2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006ee6:	2781                	sext.w	a5,a5
    80006ee8:	ffe5                	bnez	a5,80006ee0 <acquire+0x22>
  __sync_synchronize();
    80006eea:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006eee:	ffffa097          	auipc	ra,0xffffa
    80006ef2:	ef8080e7          	jalr	-264(ra) # 80000de6 <mycpu>
    80006ef6:	e888                	sd	a0,16(s1)
}
    80006ef8:	60e2                	ld	ra,24(sp)
    80006efa:	6442                	ld	s0,16(sp)
    80006efc:	64a2                	ld	s1,8(sp)
    80006efe:	6105                	addi	sp,sp,32
    80006f00:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006f02:	00002517          	auipc	a0,0x2
    80006f06:	95e50513          	addi	a0,a0,-1698 # 80008860 <etext+0x860>
    80006f0a:	00000097          	auipc	ra,0x0
    80006f0e:	a3a080e7          	jalr	-1478(ra) # 80006944 <panic>

0000000080006f12 <pop_off>:

void pop_off(void) {
    80006f12:	1141                	addi	sp,sp,-16
    80006f14:	e406                	sd	ra,8(sp)
    80006f16:	e022                	sd	s0,0(sp)
    80006f18:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006f1a:	ffffa097          	auipc	ra,0xffffa
    80006f1e:	ecc080e7          	jalr	-308(ra) # 80000de6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006f22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006f26:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80006f28:	e78d                	bnez	a5,80006f52 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006f2a:	5d3c                	lw	a5,120(a0)
    80006f2c:	02f05b63          	blez	a5,80006f62 <pop_off+0x50>
  c->noff -= 1;
    80006f30:	37fd                	addiw	a5,a5,-1
    80006f32:	0007871b          	sext.w	a4,a5
    80006f36:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    80006f38:	eb09                	bnez	a4,80006f4a <pop_off+0x38>
    80006f3a:	5d7c                	lw	a5,124(a0)
    80006f3c:	c799                	beqz	a5,80006f4a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006f3e:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006f42:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006f46:	10079073          	csrw	sstatus,a5
}
    80006f4a:	60a2                	ld	ra,8(sp)
    80006f4c:	6402                	ld	s0,0(sp)
    80006f4e:	0141                	addi	sp,sp,16
    80006f50:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006f52:	00002517          	auipc	a0,0x2
    80006f56:	91650513          	addi	a0,a0,-1770 # 80008868 <etext+0x868>
    80006f5a:	00000097          	auipc	ra,0x0
    80006f5e:	9ea080e7          	jalr	-1558(ra) # 80006944 <panic>
  if (c->noff < 1) panic("pop_off");
    80006f62:	00002517          	auipc	a0,0x2
    80006f66:	91e50513          	addi	a0,a0,-1762 # 80008880 <etext+0x880>
    80006f6a:	00000097          	auipc	ra,0x0
    80006f6e:	9da080e7          	jalr	-1574(ra) # 80006944 <panic>

0000000080006f72 <release>:
void release(struct spinlock *lk) {
    80006f72:	1101                	addi	sp,sp,-32
    80006f74:	ec06                	sd	ra,24(sp)
    80006f76:	e822                	sd	s0,16(sp)
    80006f78:	e426                	sd	s1,8(sp)
    80006f7a:	1000                	addi	s0,sp,32
    80006f7c:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    80006f7e:	00000097          	auipc	ra,0x0
    80006f82:	ec6080e7          	jalr	-314(ra) # 80006e44 <holding>
    80006f86:	c115                	beqz	a0,80006faa <release+0x38>
  lk->cpu = 0;
    80006f88:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006f8c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006f90:	0310000f          	fence	rw,w
    80006f94:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006f98:	00000097          	auipc	ra,0x0
    80006f9c:	f7a080e7          	jalr	-134(ra) # 80006f12 <pop_off>
}
    80006fa0:	60e2                	ld	ra,24(sp)
    80006fa2:	6442                	ld	s0,16(sp)
    80006fa4:	64a2                	ld	s1,8(sp)
    80006fa6:	6105                	addi	sp,sp,32
    80006fa8:	8082                	ret
  if (!holding(lk)) panic("release");
    80006faa:	00002517          	auipc	a0,0x2
    80006fae:	8de50513          	addi	a0,a0,-1826 # 80008888 <etext+0x888>
    80006fb2:	00000097          	auipc	ra,0x0
    80006fb6:	992080e7          	jalr	-1646(ra) # 80006944 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
