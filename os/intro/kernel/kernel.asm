
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	25013103          	ld	sp,592(sp) # 8000b250 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1d9050ef          	jal	800059ee <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	6e078793          	addi	a5,a5,1760 # 80024710 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	25090913          	addi	s2,s2,592 # 8000b2a0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3e2080e7          	jalr	994(ra) # 8000643c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	482080e7          	jalr	1154(ra) # 800064f0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e38080e7          	jalr	-456(ra) # 80005ec2 <panic>

0000000080000092 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    800000b8:	7a7d                	lui	s4,0xfffff
    800000ba:	6985                	lui	s3,0x1
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
void kinit() {
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000b517          	auipc	a0,0xb
    800000f2:	1b250513          	addi	a0,a0,434 # 8000b2a0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2b6080e7          	jalr	694(ra) # 800063ac <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00024517          	auipc	a0,0x24
    80000106:	60e50513          	addi	a0,a0,1550 # 80024710 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000b497          	auipc	s1,0xb
    80000128:	17c48493          	addi	s1,s1,380 # 8000b2a0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	30e080e7          	jalr	782(ra) # 8000643c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	16450513          	addi	a0,a0,356 # 8000b2a0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3aa080e7          	jalr	938(ra) # 800064f0 <release>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000b517          	auipc	a0,0xb
    8000016c:	13850513          	addi	a0,a0,312 # 8000b2a0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	380080e7          	jalr	896(ra) # 800064f0 <release>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800001ea:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda8f1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if (s < d && s + n > d) {
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if (n == 0) return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0);
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
  while (n-- > 0) *s++ = 0;
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0);
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int strlen(const char *s) {
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for (n = 0; s[n]; n++);
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000320:	00001097          	auipc	ra,0x1
    80000324:	bba080e7          	jalr	-1094(ra) # 80000eda <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    80000328:	0000b717          	auipc	a4,0xb
    8000032c:	f4870713          	addi	a4,a4,-184 # 8000b270 <started>
  if (cpuid() == 0) {
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while (started == 0);
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b9e080e7          	jalr	-1122(ra) # 80000eda <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	bbe080e7          	jalr	-1090(ra) # 80005f0c <printf>
    kvminithart();   // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();  // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	930080e7          	jalr	-1744(ra) # 80001c8e <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	ffe080e7          	jalr	-2(ra) # 80005364 <plicinithart>
  }

  scheduler();
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	094080e7          	jalr	148(ra) # 80001402 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	a5c080e7          	jalr	-1444(ra) # 80005dd2 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	d96080e7          	jalr	-618(ra) # 80006114 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	b7e080e7          	jalr	-1154(ra) # 80005f0c <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	b6e080e7          	jalr	-1170(ra) # 80005f0c <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	b5e080e7          	jalr	-1186(ra) # 80005f0c <printf>
    kinit();             // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();       // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();          // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	a4a080e7          	jalr	-1462(ra) # 80000e18 <procinit>
    trapinit();          // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	890080e7          	jalr	-1904(ra) # 80001c66 <trapinit>
    trapinithart();      // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	8b0080e7          	jalr	-1872(ra) # 80001c8e <trapinithart>
    plicinit();          // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	f64080e7          	jalr	-156(ra) # 8000534a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	f76080e7          	jalr	-138(ra) # 80005364 <plicinithart>
    binit();             // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	03c080e7          	jalr	60(ra) # 80002432 <binit>
    iinit();             // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	6f2080e7          	jalr	1778(ra) # 80002af0 <iinit>
    fileinit();          // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	6a2080e7          	jalr	1698(ra) # 80003aa8 <fileinit>
    virtio_disk_init();  // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	05e080e7          	jalr	94(ra) # 8000546c <virtio_disk_init>
    userinit();          // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	dcc080e7          	jalr	-564(ra) # 800011e2 <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000b717          	auipc	a4,0xb
    80000428:	e4f72623          	sw	a5,-436(a4) # 8000b270 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	0000b797          	auipc	a5,0xb
    8000043c:	e407b783          	ld	a5,-448(a5) # 8000b278 <kernel_pagetable>
    80000440:	83b1                	srli	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	slli	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000456:	7139                	addi	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	addi	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srli	a5,a5,0x1a
    80000474:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    80000476:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	addi	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	a3e080e7          	jalr	-1474(ra) # 80005ec2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srli	a5,s1,0xc
    800004ac:	07aa                	slli	a5,a5,0xa
    800004ae:	0017e793          	ori	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004b6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda8e7>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	andi	s2,s2,511
    800004c4:	090e                	slli	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	andi	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srli	s1,s1,0xa
    800004d4:	04b2                	slli	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srli	a0,s3,0xc
    800004dc:	1ff57513          	andi	a0,a0,511
    800004e0:	050e                	slli	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	addi	sp,sp,64
    800004f6:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srli	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    80000504:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if (pte == 0) return 0;
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    8000051c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    8000051e:	0117f693          	andi	a3,a5,17
    80000522:	4745                	li	a4,17
    80000524:	4501                	li	a0,0
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	addi	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srli	a5,a5,0xa
    80000534:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
  if (pte == 0) return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000053e:	715d                	addi	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    80000554:	03459793          	slli	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    8000055e:	03461793          	slli	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>

  if (size == 0) panic("mappages: size");
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if (a == last) break;
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	914080e7          	jalr	-1772(ra) # 80005ec2 <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	addi	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	904080e7          	jalr	-1788(ra) # 80005ec2 <panic>
  if (size == 0) panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	addi	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	8f4080e7          	jalr	-1804(ra) # 80005ec2 <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	addi	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	8e4080e7          	jalr	-1820(ra) # 80005ec2 <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	addi	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    80000602:	1141                	addi	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	addi	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	addi	sp,sp,16
    80000620:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	addi	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	898080e7          	jalr	-1896(ra) # 80005ec2 <panic>

0000000080000632 <kvmmake>:
pagetable_t kvmmake(void) {
    80000632:	1101                	addi	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	addi	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	addi	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	slli	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	slli	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	addi	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	slli	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	682080e7          	jalr	1666(ra) # 80000d74 <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	addi	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	0000b797          	auipc	a5,0xb
    8000071c:	b6a7b023          	sd	a0,-1184(a5) # 8000b278 <kernel_pagetable>
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	addi	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80000728:	715d                	addi	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000730:	03459793          	slli	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000748:	0632                	slli	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000074e:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	addi	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	752080e7          	jalr	1874(ra) # 80005ec2 <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	addi	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	742080e7          	jalr	1858(ra) # 80005ec2 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	addi	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	732080e7          	jalr	1842(ra) # 80005ec2 <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	addi	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	722080e7          	jalr	1826(ra) # 80005ec2 <panic>
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	andi	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007cc:	3ff57793          	andi	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if (do_free) {
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800007da:	0532                	slli	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	addi	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800007fc:	1101                	addi	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	addi	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	addi	sp,sp,48
    8000088a:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	addi	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	62e080e7          	jalr	1582(ra) # 80005ec2 <panic>

000000008000089c <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    8000089c:	1101                	addi	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    800008a6:	84ae                	mv	s1,a1
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800008e8:	7139                	addi	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000912:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	addi	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
  if (newsz < oldsz) return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    800009a2:	7179                	addi	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	addi	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	slli	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    800009d0:	04a1                	addi	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009d8:	00f7f713          	andi	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800009e0:	8b85                	andi	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	addi	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	4d6080e7          	jalr	1238(ra) # 80005ec2 <panic>
    }
  }
  kfree((void *)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	addi	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000a0e:	1101                	addi	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	addi	s0,sp,32
    80000a18:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a1a:	e999                	bnez	a1,80000a30 <uvmfree+0x22>
  freewalk(pagetable);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f84080e7          	jalr	-124(ra) # 800009a2 <freewalk>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	4685                	li	a3,1
    80000a38:	00c5d613          	srli	a2,a1,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	cea080e7          	jalr	-790(ra) # 80000728 <uvmunmap>
    80000a46:	bfd9                	j	80000a1c <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000a4a:	715d                	addi	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000a66:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	9e8080e7          	jalr	-1560(ra) # 80000456 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	andi	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srli	a1,a4,0xa
    80000a84:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68e080e7          	jalr	1678(ra) # 8000011a <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	a90080e7          	jalr	-1392(ra) # 8000053e <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	68650513          	addi	a0,a0,1670 # 80008148 <etext+0x148>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	3f8080e7          	jalr	1016(ra) # 80005ec2 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	addi	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	3e8080e7          	jalr	1000(ra) # 80005ec2 <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c32080e7          	jalr	-974(ra) # 80000728 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	addi	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	932080e7          	jalr	-1742(ra) # 80000456 <walk>
  if (pte == 0) panic("uvmclear");
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	andi	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	64c50513          	addi	a0,a0,1612 # 80008188 <etext+0x188>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	37e080e7          	jalr	894(ra) # 80005ec2 <panic>

0000000080000b4c <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0) {
    80000b4c:	ced1                	beqz	a3,80000be8 <copyout+0x9c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000b4e:	711d                	addi	sp,sp,-96
    80000b50:	ec86                	sd	ra,88(sp)
    80000b52:	e8a2                	sd	s0,80(sp)
    80000b54:	e4a6                	sd	s1,72(sp)
    80000b56:	fc4e                	sd	s3,56(sp)
    80000b58:	f456                	sd	s5,40(sp)
    80000b5a:	f05a                	sd	s6,32(sp)
    80000b5c:	ec5e                	sd	s7,24(sp)
    80000b5e:	1080                	addi	s0,sp,96
    80000b60:	8baa                	mv	s7,a0
    80000b62:	8aae                	mv	s5,a1
    80000b64:	8b32                	mv	s6,a2
    80000b66:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b68:	74fd                	lui	s1,0xfffff
    80000b6a:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000b6c:	57fd                	li	a5,-1
    80000b6e:	83e9                	srli	a5,a5,0x1a
    80000b70:	0697ee63          	bltu	a5,s1,80000bec <copyout+0xa0>
    80000b74:	e0ca                	sd	s2,64(sp)
    80000b76:	f852                	sd	s4,48(sp)
    80000b78:	e862                	sd	s8,16(sp)
    80000b7a:	e466                	sd	s9,8(sp)
    80000b7c:	e06a                	sd	s10,0(sp)
    pte = walk(pagetable, va0, 0);
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b7e:	4cd5                	li	s9,21
    80000b80:	6d05                	lui	s10,0x1
    if (va0 >= MAXVA) return -1;
    80000b82:	8c3e                	mv	s8,a5
    80000b84:	a035                	j	80000bb0 <copyout+0x64>
        (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b86:	83a9                	srli	a5,a5,0xa
    80000b88:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	409a8533          	sub	a0,s5,s1
    80000b8e:	0009061b          	sext.w	a2,s2
    80000b92:	85da                	mv	a1,s6
    80000b94:	953e                	add	a0,a0,a5
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>

    len -= n;
    80000b9e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000ba2:	9b4a                	add	s6,s6,s2
  while (len > 0) {
    80000ba4:	02098b63          	beqz	s3,80000bda <copyout+0x8e>
    if (va0 >= MAXVA) return -1;
    80000ba8:	054c6463          	bltu	s8,s4,80000bf0 <copyout+0xa4>
    80000bac:	84d2                	mv	s1,s4
    80000bae:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bb0:	4601                	li	a2,0
    80000bb2:	85a6                	mv	a1,s1
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	8a0080e7          	jalr	-1888(ra) # 80000456 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	c121                	beqz	a0,80000bfe <copyout+0xb2>
    80000bc0:	611c                	ld	a5,0(a0)
    80000bc2:	0157f713          	andi	a4,a5,21
    80000bc6:	05971b63          	bne	a4,s9,80000c1c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000bca:	01a48a33          	add	s4,s1,s10
    80000bce:	415a0933          	sub	s2,s4,s5
    if (n > len) n = len;
    80000bd2:	fb29fae3          	bgeu	s3,s2,80000b86 <copyout+0x3a>
    80000bd6:	894e                	mv	s2,s3
    80000bd8:	b77d                	j	80000b86 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	7a42                	ld	s4,48(sp)
    80000be0:	6c42                	ld	s8,16(sp)
    80000be2:	6ca2                	ld	s9,8(sp)
    80000be4:	6d02                	ld	s10,0(sp)
    80000be6:	a015                	j	80000c0a <copyout+0xbe>
    80000be8:	4501                	li	a0,0
}
    80000bea:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000bec:	557d                	li	a0,-1
    80000bee:	a831                	j	80000c0a <copyout+0xbe>
    80000bf0:	557d                	li	a0,-1
    80000bf2:	6906                	ld	s2,64(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	6c42                	ld	s8,16(sp)
    80000bf8:	6ca2                	ld	s9,8(sp)
    80000bfa:	6d02                	ld	s10,0(sp)
    80000bfc:	a039                	j	80000c0a <copyout+0xbe>
      return -1;
    80000bfe:	557d                	li	a0,-1
    80000c00:	6906                	ld	s2,64(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	6c42                	ld	s8,16(sp)
    80000c06:	6ca2                	ld	s9,8(sp)
    80000c08:	6d02                	ld	s10,0(sp)
}
    80000c0a:	60e6                	ld	ra,88(sp)
    80000c0c:	6446                	ld	s0,80(sp)
    80000c0e:	64a6                	ld	s1,72(sp)
    80000c10:	79e2                	ld	s3,56(sp)
    80000c12:	7aa2                	ld	s5,40(sp)
    80000c14:	7b02                	ld	s6,32(sp)
    80000c16:	6be2                	ld	s7,24(sp)
    80000c18:	6125                	addi	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	7a42                	ld	s4,48(sp)
    80000c22:	6c42                	ld	s8,16(sp)
    80000c24:	6ca2                	ld	s9,8(sp)
    80000c26:	6d02                	ld	s10,0(sp)
    80000c28:	b7cd                	j	80000c0a <copyout+0xbe>

0000000080000c2a <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000c2a:	caa5                	beqz	a3,80000c9a <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000c2c:	715d                	addi	sp,sp,-80
    80000c2e:	e486                	sd	ra,72(sp)
    80000c30:	e0a2                	sd	s0,64(sp)
    80000c32:	fc26                	sd	s1,56(sp)
    80000c34:	f84a                	sd	s2,48(sp)
    80000c36:	f44e                	sd	s3,40(sp)
    80000c38:	f052                	sd	s4,32(sp)
    80000c3a:	ec56                	sd	s5,24(sp)
    80000c3c:	e85a                	sd	s6,16(sp)
    80000c3e:	e45e                	sd	s7,8(sp)
    80000c40:	e062                	sd	s8,0(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8b2a                	mv	s6,a0
    80000c46:	8a2e                	mv	s4,a1
    80000c48:	8c32                	mv	s8,a2
    80000c4a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6a85                	lui	s5,0x1
    80000c50:	a01d                	j	80000c76 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c52:	018505b3          	add	a1,a0,s8
    80000c56:	0004861b          	sext.w	a2,s1
    80000c5a:	412585b3          	sub	a1,a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>

    len -= n;
    80000c68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6e:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000c72:	02098263          	beqz	s3,80000c96 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7a:	85ca                	mv	a1,s2
    80000c7c:	855a                	mv	a0,s6
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87e080e7          	jalr	-1922(ra) # 800004fc <walkaddr>
    if (pa0 == 0) return -1;
    80000c86:	cd01                	beqz	a0,80000c9e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c88:	418904b3          	sub	s1,s2,s8
    80000c8c:	94d6                	add	s1,s1,s5
    if (n > len) n = len;
    80000c8e:	fc99f2e3          	bgeu	s3,s1,80000c52 <copyin+0x28>
    80000c92:	84ce                	mv	s1,s3
    80000c94:	bf7d                	j	80000c52 <copyin+0x28>
  }
  return 0;
    80000c96:	4501                	li	a0,0
    80000c98:	a021                	j	80000ca0 <copyin+0x76>
    80000c9a:	4501                	li	a0,0
}
    80000c9c:	8082                	ret
    if (pa0 == 0) return -1;
    80000c9e:	557d                	li	a0,-1
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6c02                	ld	s8,0(sp)
    80000cb4:	6161                	addi	sp,sp,80
    80000cb6:	8082                	ret

0000000080000cb8 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000cb8:	cacd                	beqz	a3,80000d6a <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000cba:	715d                	addi	sp,sp,-80
    80000cbc:	e486                	sd	ra,72(sp)
    80000cbe:	e0a2                	sd	s0,64(sp)
    80000cc0:	fc26                	sd	s1,56(sp)
    80000cc2:	f84a                	sd	s2,48(sp)
    80000cc4:	f44e                	sd	s3,40(sp)
    80000cc6:	f052                	sd	s4,32(sp)
    80000cc8:	ec56                	sd	s5,24(sp)
    80000cca:	e85a                	sd	s6,16(sp)
    80000ccc:	e45e                	sd	s7,8(sp)
    80000cce:	0880                	addi	s0,sp,80
    80000cd0:	8a2a                	mv	s4,a0
    80000cd2:	8b2e                	mv	s6,a1
    80000cd4:	8bb2                	mv	s7,a2
    80000cd6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000cda:	6985                	lui	s3,0x1
    80000cdc:	a825                	j	80000d14 <copyinstr+0x5c>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000cde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000ce4:	37fd                	addiw	a5,a5,-1
    80000ce6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6161                	addi	sp,sp,80
    80000cfe:	8082                	ret
    80000d00:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d04:	9742                	add	a4,a4,a6
      --max;
    80000d06:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d0a:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0) {
    80000d0e:	04e58663          	beq	a1,a4,80000d5a <copyinstr+0xa2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000d12:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7e0080e7          	jalr	2016(ra) # 800004fc <walkaddr>
    if (pa0 == 0) return -1;
    80000d24:	cd0d                	beqz	a0,80000d5e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d26:	417486b3          	sub	a3,s1,s7
    80000d2a:	96ce                	add	a3,a3,s3
    if (n > max) n = max;
    80000d2c:	00d97363          	bgeu	s2,a3,80000d32 <copyinstr+0x7a>
    80000d30:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	8d05                	sub	a0,a0,s1
    while (n > 0) {
    80000d36:	c695                	beqz	a3,80000d62 <copyinstr+0xaa>
    80000d38:	87da                	mv	a5,s6
    80000d3a:	885a                	mv	a6,s6
      if (*p == '\0') {
    80000d3c:	41650633          	sub	a2,a0,s6
    while (n > 0) {
    80000d40:	96da                	add	a3,a3,s6
    80000d42:	85be                	mv	a1,a5
      if (*p == '\0') {
    80000d44:	00f60733          	add	a4,a2,a5
    80000d48:	00074703          	lbu	a4,0(a4)
    80000d4c:	db49                	beqz	a4,80000cde <copyinstr+0x26>
        *dst = *p;
    80000d4e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d52:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000d54:	fed797e3          	bne	a5,a3,80000d42 <copyinstr+0x8a>
    80000d58:	b765                	j	80000d00 <copyinstr+0x48>
    80000d5a:	4781                	li	a5,0
    80000d5c:	b761                	j	80000ce4 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000d5e:	557d                	li	a0,-1
    80000d60:	b769                	j	80000cea <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d62:	6b85                	lui	s7,0x1
    80000d64:	9ba6                	add	s7,s7,s1
    80000d66:	87da                	mv	a5,s6
    80000d68:	b76d                	j	80000d12 <copyinstr+0x5a>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if (got_null) {
    80000d6c:	37fd                	addiw	a5,a5,-1
    80000d6e:	0007851b          	sext.w	a0,a5
}
    80000d72:	8082                	ret

0000000080000d74 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
    80000d88:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	0000b497          	auipc	s1,0xb
    80000d8e:	96648493          	addi	s1,s1,-1690 # 8000b6f0 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000d92:	8b26                	mv	s6,s1
    80000d94:	04fa5937          	lui	s2,0x4fa5
    80000d98:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d9c:	0932                	slli	s2,s2,0xc
    80000d9e:	fa590913          	addi	s2,s2,-91
    80000da2:	0932                	slli	s2,s2,0xc
    80000da4:	fa590913          	addi	s2,s2,-91
    80000da8:	0932                	slli	s2,s2,0xc
    80000daa:	fa590913          	addi	s2,s2,-91
    80000dae:	040009b7          	lui	s3,0x4000
    80000db2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000db4:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00010a97          	auipc	s5,0x10
    80000dba:	33aa8a93          	addi	s5,s5,826 # 800110f0 <tickslock>
    char *pa = kalloc();
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80000dc6:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000dc8:	c121                	beqz	a0,80000e08 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80000dca:	416485b3          	sub	a1,s1,s6
    80000dce:	858d                	srai	a1,a1,0x3
    80000dd0:	032585b3          	mul	a1,a1,s2
    80000dd4:	2585                	addiw	a1,a1,1
    80000dd6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dda:	4719                	li	a4,6
    80000ddc:	6685                	lui	a3,0x1
    80000dde:	40b985b3          	sub	a1,s3,a1
    80000de2:	8552                	mv	a0,s4
    80000de4:	00000097          	auipc	ra,0x0
    80000de8:	81e080e7          	jalr	-2018(ra) # 80000602 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000dec:	16848493          	addi	s1,s1,360
    80000df0:	fd5497e3          	bne	s1,s5,80000dbe <proc_mapstacks+0x4a>
  }
}
    80000df4:	70e2                	ld	ra,56(sp)
    80000df6:	7442                	ld	s0,48(sp)
    80000df8:	74a2                	ld	s1,40(sp)
    80000dfa:	7902                	ld	s2,32(sp)
    80000dfc:	69e2                	ld	s3,24(sp)
    80000dfe:	6a42                	ld	s4,16(sp)
    80000e00:	6aa2                	ld	s5,8(sp)
    80000e02:	6b02                	ld	s6,0(sp)
    80000e04:	6121                	addi	sp,sp,64
    80000e06:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000e08:	00007517          	auipc	a0,0x7
    80000e0c:	39050513          	addi	a0,a0,912 # 80008198 <etext+0x198>
    80000e10:	00005097          	auipc	ra,0x5
    80000e14:	0b2080e7          	jalr	178(ra) # 80005ec2 <panic>

0000000080000e18 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000e18:	7139                	addi	sp,sp,-64
    80000e1a:	fc06                	sd	ra,56(sp)
    80000e1c:	f822                	sd	s0,48(sp)
    80000e1e:	f426                	sd	s1,40(sp)
    80000e20:	f04a                	sd	s2,32(sp)
    80000e22:	ec4e                	sd	s3,24(sp)
    80000e24:	e852                	sd	s4,16(sp)
    80000e26:	e456                	sd	s5,8(sp)
    80000e28:	e05a                	sd	s6,0(sp)
    80000e2a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000e2c:	00007597          	auipc	a1,0x7
    80000e30:	37458593          	addi	a1,a1,884 # 800081a0 <etext+0x1a0>
    80000e34:	0000a517          	auipc	a0,0xa
    80000e38:	48c50513          	addi	a0,a0,1164 # 8000b2c0 <pid_lock>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	570080e7          	jalr	1392(ra) # 800063ac <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e44:	00007597          	auipc	a1,0x7
    80000e48:	36458593          	addi	a1,a1,868 # 800081a8 <etext+0x1a8>
    80000e4c:	0000a517          	auipc	a0,0xa
    80000e50:	48c50513          	addi	a0,a0,1164 # 8000b2d8 <wait_lock>
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	558080e7          	jalr	1368(ra) # 800063ac <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e5c:	0000b497          	auipc	s1,0xb
    80000e60:	89448493          	addi	s1,s1,-1900 # 8000b6f0 <proc>
    initlock(&p->lock, "proc");
    80000e64:	00007b17          	auipc	s6,0x7
    80000e68:	354b0b13          	addi	s6,s6,852 # 800081b8 <etext+0x1b8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000e6c:	8aa6                	mv	s5,s1
    80000e6e:	04fa5937          	lui	s2,0x4fa5
    80000e72:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e76:	0932                	slli	s2,s2,0xc
    80000e78:	fa590913          	addi	s2,s2,-91
    80000e7c:	0932                	slli	s2,s2,0xc
    80000e7e:	fa590913          	addi	s2,s2,-91
    80000e82:	0932                	slli	s2,s2,0xc
    80000e84:	fa590913          	addi	s2,s2,-91
    80000e88:	040009b7          	lui	s3,0x4000
    80000e8c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e8e:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e90:	00010a17          	auipc	s4,0x10
    80000e94:	260a0a13          	addi	s4,s4,608 # 800110f0 <tickslock>
    initlock(&p->lock, "proc");
    80000e98:	85da                	mv	a1,s6
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	510080e7          	jalr	1296(ra) # 800063ac <initlock>
    p->state = UNUSED;
    80000ea4:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000ea8:	415487b3          	sub	a5,s1,s5
    80000eac:	878d                	srai	a5,a5,0x3
    80000eae:	032787b3          	mul	a5,a5,s2
    80000eb2:	2785                	addiw	a5,a5,1
    80000eb4:	00d7979b          	slliw	a5,a5,0xd
    80000eb8:	40f987b3          	sub	a5,s3,a5
    80000ebc:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ebe:	16848493          	addi	s1,s1,360
    80000ec2:	fd449be3          	bne	s1,s4,80000e98 <procinit+0x80>
  }
}
    80000ec6:	70e2                	ld	ra,56(sp)
    80000ec8:	7442                	ld	s0,48(sp)
    80000eca:	74a2                	ld	s1,40(sp)
    80000ecc:	7902                	ld	s2,32(sp)
    80000ece:	69e2                	ld	s3,24(sp)
    80000ed0:	6a42                	ld	s4,16(sp)
    80000ed2:	6aa2                	ld	s5,8(sp)
    80000ed4:	6b02                	ld	s6,0(sp)
    80000ed6:	6121                	addi	sp,sp,64
    80000ed8:	8082                	ret

0000000080000eda <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000ee0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ee2:	2501                	sext.w	a0,a0
    80000ee4:	6422                	ld	s0,8(sp)
    80000ee6:	0141                	addi	sp,sp,16
    80000ee8:	8082                	ret

0000000080000eea <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e422                	sd	s0,8(sp)
    80000eee:	0800                	addi	s0,sp,16
    80000ef0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ef2:	2781                	sext.w	a5,a5
    80000ef4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ef6:	0000a517          	auipc	a0,0xa
    80000efa:	3fa50513          	addi	a0,a0,1018 # 8000b2f0 <cpus>
    80000efe:	953e                	add	a0,a0,a5
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	1000                	addi	s0,sp,32
  push_off();
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	4e0080e7          	jalr	1248(ra) # 800063f0 <push_off>
    80000f18:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f1a:	2781                	sext.w	a5,a5
    80000f1c:	079e                	slli	a5,a5,0x7
    80000f1e:	0000a717          	auipc	a4,0xa
    80000f22:	3a270713          	addi	a4,a4,930 # 8000b2c0 <pid_lock>
    80000f26:	97ba                	add	a5,a5,a4
    80000f28:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	566080e7          	jalr	1382(ra) # 80006490 <pop_off>
  return p;
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6105                	addi	sp,sp,32
    80000f3c:	8082                	ret

0000000080000f3e <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e406                	sd	ra,8(sp)
    80000f42:	e022                	sd	s0,0(sp)
    80000f44:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f46:	00000097          	auipc	ra,0x0
    80000f4a:	fc0080e7          	jalr	-64(ra) # 80000f06 <myproc>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	5a2080e7          	jalr	1442(ra) # 800064f0 <release>

  if (first) {
    80000f56:	0000a797          	auipc	a5,0xa
    80000f5a:	2aa7a783          	lw	a5,682(a5) # 8000b200 <first.1>
    80000f5e:	eb89                	bnez	a5,80000f70 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	d46080e7          	jalr	-698(ra) # 80001ca6 <usertrapret>
}
    80000f68:	60a2                	ld	ra,8(sp)
    80000f6a:	6402                	ld	s0,0(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret
    fsinit(ROOTDEV);
    80000f70:	4505                	li	a0,1
    80000f72:	00002097          	auipc	ra,0x2
    80000f76:	afe080e7          	jalr	-1282(ra) # 80002a70 <fsinit>
    first = 0;
    80000f7a:	0000a797          	auipc	a5,0xa
    80000f7e:	2807a323          	sw	zero,646(a5) # 8000b200 <first.1>
    __sync_synchronize();
    80000f82:	0330000f          	fence	rw,rw
    80000f86:	bfe9                	j	80000f60 <forkret+0x22>

0000000080000f88 <allocpid>:
int allocpid() {
    80000f88:	1101                	addi	sp,sp,-32
    80000f8a:	ec06                	sd	ra,24(sp)
    80000f8c:	e822                	sd	s0,16(sp)
    80000f8e:	e426                	sd	s1,8(sp)
    80000f90:	e04a                	sd	s2,0(sp)
    80000f92:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f94:	0000a917          	auipc	s2,0xa
    80000f98:	32c90913          	addi	s2,s2,812 # 8000b2c0 <pid_lock>
    80000f9c:	854a                	mv	a0,s2
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	49e080e7          	jalr	1182(ra) # 8000643c <acquire>
  pid = nextpid;
    80000fa6:	0000a797          	auipc	a5,0xa
    80000faa:	25e78793          	addi	a5,a5,606 # 8000b204 <nextpid>
    80000fae:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fb0:	0014871b          	addiw	a4,s1,1
    80000fb4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fb6:	854a                	mv	a0,s2
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	538080e7          	jalr	1336(ra) # 800064f0 <release>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret

0000000080000fce <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	e04a                	sd	s2,0(sp)
    80000fd8:	1000                	addi	s0,sp,32
    80000fda:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	820080e7          	jalr	-2016(ra) # 800007fc <uvmcreate>
    80000fe4:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000fe6:	c121                	beqz	a0,80001026 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000fe8:	4729                	li	a4,10
    80000fea:	00006697          	auipc	a3,0x6
    80000fee:	01668693          	addi	a3,a3,22 # 80007000 <_trampoline>
    80000ff2:	6605                	lui	a2,0x1
    80000ff4:	040005b7          	lui	a1,0x4000
    80000ff8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ffa:	05b2                	slli	a1,a1,0xc
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	542080e7          	jalr	1346(ra) # 8000053e <mappages>
    80001004:	02054863          	bltz	a0,80001034 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001008:	4719                	li	a4,6
    8000100a:	05893683          	ld	a3,88(s2)
    8000100e:	6605                	lui	a2,0x1
    80001010:	020005b7          	lui	a1,0x2000
    80001014:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001016:	05b6                	slli	a1,a1,0xd
    80001018:	8526                	mv	a0,s1
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	524080e7          	jalr	1316(ra) # 8000053e <mappages>
    80001022:	02054163          	bltz	a0,80001044 <proc_pagetable+0x76>
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret
    uvmfree(pagetable, 0);
    80001034:	4581                	li	a1,0
    80001036:	8526                	mv	a0,s1
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	9d6080e7          	jalr	-1578(ra) # 80000a0e <uvmfree>
    return 0;
    80001040:	4481                	li	s1,0
    80001042:	b7d5                	j	80001026 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	040005b7          	lui	a1,0x4000
    8000104c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104e:	05b2                	slli	a1,a1,0xc
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	6d6080e7          	jalr	1750(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    8000105a:	4581                	li	a1,0
    8000105c:	8526                	mv	a0,s1
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	9b0080e7          	jalr	-1616(ra) # 80000a0e <uvmfree>
    return 0;
    80001066:	4481                	li	s1,0
    80001068:	bf7d                	j	80001026 <proc_pagetable+0x58>

000000008000106a <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	addi	s0,sp,32
    80001076:	84aa                	mv	s1,a0
    80001078:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000107a:	4681                	li	a3,0
    8000107c:	4605                	li	a2,1
    8000107e:	040005b7          	lui	a1,0x4000
    80001082:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001084:	05b2                	slli	a1,a1,0xc
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	6a2080e7          	jalr	1698(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	020005b7          	lui	a1,0x2000
    80001096:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001098:	05b6                	slli	a1,a1,0xd
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	68c080e7          	jalr	1676(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    800010a4:	85ca                	mv	a1,s2
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	966080e7          	jalr	-1690(ra) # 80000a0e <uvmfree>
}
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6902                	ld	s2,0(sp)
    800010b8:	6105                	addi	sp,sp,32
    800010ba:	8082                	ret

00000000800010bc <freeproc>:
static void freeproc(struct proc *p) {
    800010bc:	1101                	addi	sp,sp,-32
    800010be:	ec06                	sd	ra,24(sp)
    800010c0:	e822                	sd	s0,16(sp)
    800010c2:	e426                	sd	s1,8(sp)
    800010c4:	1000                	addi	s0,sp,32
    800010c6:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    800010c8:	6d28                	ld	a0,88(a0)
    800010ca:	c509                	beqz	a0,800010d4 <freeproc+0x18>
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	f50080e7          	jalr	-176(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010d4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    800010d8:	68a8                	ld	a0,80(s1)
    800010da:	c511                	beqz	a0,800010e6 <freeproc+0x2a>
    800010dc:	64ac                	ld	a1,72(s1)
    800010de:	00000097          	auipc	ra,0x0
    800010e2:	f8c080e7          	jalr	-116(ra) # 8000106a <proc_freepagetable>
  p->pagetable = 0;
    800010e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010f6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001102:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001106:	0004ac23          	sw	zero,24(s1)
}
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6105                	addi	sp,sp,32
    80001112:	8082                	ret

0000000080001114 <allocproc>:
static struct proc *allocproc(void) {
    80001114:	1101                	addi	sp,sp,-32
    80001116:	ec06                	sd	ra,24(sp)
    80001118:	e822                	sd	s0,16(sp)
    8000111a:	e426                	sd	s1,8(sp)
    8000111c:	e04a                	sd	s2,0(sp)
    8000111e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001120:	0000a497          	auipc	s1,0xa
    80001124:	5d048493          	addi	s1,s1,1488 # 8000b6f0 <proc>
    80001128:	00010917          	auipc	s2,0x10
    8000112c:	fc890913          	addi	s2,s2,-56 # 800110f0 <tickslock>
    acquire(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	00005097          	auipc	ra,0x5
    80001136:	30a080e7          	jalr	778(ra) # 8000643c <acquire>
    if (p->state == UNUSED) {
    8000113a:	4c9c                	lw	a5,24(s1)
    8000113c:	cf81                	beqz	a5,80001154 <allocproc+0x40>
      release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	3b0080e7          	jalr	944(ra) # 800064f0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001148:	16848493          	addi	s1,s1,360
    8000114c:	ff2492e3          	bne	s1,s2,80001130 <allocproc+0x1c>
  return 0;
    80001150:	4481                	li	s1,0
    80001152:	a889                	j	800011a4 <allocproc+0x90>
  p->pid = allocpid();
    80001154:	00000097          	auipc	ra,0x0
    80001158:	e34080e7          	jalr	-460(ra) # 80000f88 <allocpid>
    8000115c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000115e:	4785                	li	a5,1
    80001160:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	fb8080e7          	jalr	-72(ra) # 8000011a <kalloc>
    8000116a:	892a                	mv	s2,a0
    8000116c:	eca8                	sd	a0,88(s1)
    8000116e:	c131                	beqz	a0,800011b2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001170:	8526                	mv	a0,s1
    80001172:	00000097          	auipc	ra,0x0
    80001176:	e5c080e7          	jalr	-420(ra) # 80000fce <proc_pagetable>
    8000117a:	892a                	mv	s2,a0
    8000117c:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    8000117e:	c531                	beqz	a0,800011ca <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001180:	07000613          	li	a2,112
    80001184:	4581                	li	a1,0
    80001186:	06048513          	addi	a0,s1,96
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	ff0080e7          	jalr	-16(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001192:	00000797          	auipc	a5,0x0
    80001196:	dac78793          	addi	a5,a5,-596 # 80000f3e <forkret>
    8000119a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000119c:	60bc                	ld	a5,64(s1)
    8000119e:	6705                	lui	a4,0x1
    800011a0:	97ba                	add	a5,a5,a4
    800011a2:	f4bc                	sd	a5,104(s1)
}
    800011a4:	8526                	mv	a0,s1
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6902                	ld	s2,0(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret
    freeproc(p);
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f08080e7          	jalr	-248(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011bc:	8526                	mv	a0,s1
    800011be:	00005097          	auipc	ra,0x5
    800011c2:	332080e7          	jalr	818(ra) # 800064f0 <release>
    return 0;
    800011c6:	84ca                	mv	s1,s2
    800011c8:	bff1                	j	800011a4 <allocproc+0x90>
    freeproc(p);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	ef0080e7          	jalr	-272(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	31a080e7          	jalr	794(ra) # 800064f0 <release>
    return 0;
    800011de:	84ca                	mv	s1,s2
    800011e0:	b7d1                	j	800011a4 <allocproc+0x90>

00000000800011e2 <userinit>:
void userinit(void) {
    800011e2:	1101                	addi	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f28080e7          	jalr	-216(ra) # 80001114 <allocproc>
    800011f4:	84aa                	mv	s1,a0
  initproc = p;
    800011f6:	0000a797          	auipc	a5,0xa
    800011fa:	08a7b523          	sd	a0,138(a5) # 8000b280 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011fe:	03400613          	li	a2,52
    80001202:	0000a597          	auipc	a1,0xa
    80001206:	00e58593          	addi	a1,a1,14 # 8000b210 <initcode>
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	61e080e7          	jalr	1566(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    80001214:	6785                	lui	a5,0x1
    80001216:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001218:	6cb8                	ld	a4,88(s1)
    8000121a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000121e:	6cb8                	ld	a4,88(s1)
    80001220:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001222:	4641                	li	a2,16
    80001224:	00007597          	auipc	a1,0x7
    80001228:	f9c58593          	addi	a1,a1,-100 # 800081c0 <etext+0x1c0>
    8000122c:	15848513          	addi	a0,s1,344
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	08c080e7          	jalr	140(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001238:	00007517          	auipc	a0,0x7
    8000123c:	f9850513          	addi	a0,a0,-104 # 800081d0 <etext+0x1d0>
    80001240:	00002097          	auipc	ra,0x2
    80001244:	282080e7          	jalr	642(ra) # 800034c2 <namei>
    80001248:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000124c:	478d                	li	a5,3
    8000124e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	00005097          	auipc	ra,0x5
    80001256:	29e080e7          	jalr	670(ra) # 800064f0 <release>
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <growproc>:
int growproc(int n) {
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	e04a                	sd	s2,0(sp)
    8000126e:	1000                	addi	s0,sp,32
    80001270:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c94080e7          	jalr	-876(ra) # 80000f06 <myproc>
    8000127a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000127c:	652c                	ld	a1,72(a0)
  if (n > 0) {
    8000127e:	01204c63          	bgtz	s2,80001296 <growproc+0x32>
  } else if (n < 0) {
    80001282:	02094663          	bltz	s2,800012ae <growproc+0x4a>
  p->sz = sz;
    80001286:	e4ac                	sd	a1,72(s1)
  return 0;
    80001288:	4501                	li	a0,0
}
    8000128a:	60e2                	ld	ra,24(sp)
    8000128c:	6442                	ld	s0,16(sp)
    8000128e:	64a2                	ld	s1,8(sp)
    80001290:	6902                	ld	s2,0(sp)
    80001292:	6105                	addi	sp,sp,32
    80001294:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001296:	4691                	li	a3,4
    80001298:	00b90633          	add	a2,s2,a1
    8000129c:	6928                	ld	a0,80(a0)
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	646080e7          	jalr	1606(ra) # 800008e4 <uvmalloc>
    800012a6:	85aa                	mv	a1,a0
    800012a8:	fd79                	bnez	a0,80001286 <growproc+0x22>
      return -1;
    800012aa:	557d                	li	a0,-1
    800012ac:	bff9                	j	8000128a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ae:	00b90633          	add	a2,s2,a1
    800012b2:	6928                	ld	a0,80(a0)
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	5e8080e7          	jalr	1512(ra) # 8000089c <uvmdealloc>
    800012bc:	85aa                	mv	a1,a0
    800012be:	b7e1                	j	80001286 <growproc+0x22>

00000000800012c0 <fork>:
int fork(void) {
    800012c0:	7139                	addi	sp,sp,-64
    800012c2:	fc06                	sd	ra,56(sp)
    800012c4:	f822                	sd	s0,48(sp)
    800012c6:	f04a                	sd	s2,32(sp)
    800012c8:	e456                	sd	s5,8(sp)
    800012ca:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	c3a080e7          	jalr	-966(ra) # 80000f06 <myproc>
    800012d4:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	e3e080e7          	jalr	-450(ra) # 80001114 <allocproc>
    800012de:	12050063          	beqz	a0,800013fe <fork+0x13e>
    800012e2:	e852                	sd	s4,16(sp)
    800012e4:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800012e6:	048ab603          	ld	a2,72(s5)
    800012ea:	692c                	ld	a1,80(a0)
    800012ec:	050ab503          	ld	a0,80(s5)
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	758080e7          	jalr	1880(ra) # 80000a48 <uvmcopy>
    800012f8:	04054a63          	bltz	a0,8000134c <fork+0x8c>
    800012fc:	f426                	sd	s1,40(sp)
    800012fe:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001300:	048ab783          	ld	a5,72(s5)
    80001304:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001308:	058ab683          	ld	a3,88(s5)
    8000130c:	87b6                	mv	a5,a3
    8000130e:	058a3703          	ld	a4,88(s4)
    80001312:	12068693          	addi	a3,a3,288
    80001316:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000131a:	6788                	ld	a0,8(a5)
    8000131c:	6b8c                	ld	a1,16(a5)
    8000131e:	6f90                	ld	a2,24(a5)
    80001320:	01073023          	sd	a6,0(a4)
    80001324:	e708                	sd	a0,8(a4)
    80001326:	eb0c                	sd	a1,16(a4)
    80001328:	ef10                	sd	a2,24(a4)
    8000132a:	02078793          	addi	a5,a5,32
    8000132e:	02070713          	addi	a4,a4,32
    80001332:	fed792e3          	bne	a5,a3,80001316 <fork+0x56>
  np->trapframe->a0 = 0;
    80001336:	058a3783          	ld	a5,88(s4)
    8000133a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000133e:	0d0a8493          	addi	s1,s5,208
    80001342:	0d0a0913          	addi	s2,s4,208
    80001346:	150a8993          	addi	s3,s5,336
    8000134a:	a015                	j	8000136e <fork+0xae>
    freeproc(np);
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	d6e080e7          	jalr	-658(ra) # 800010bc <freeproc>
    release(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	198080e7          	jalr	408(ra) # 800064f0 <release>
    return -1;
    80001360:	597d                	li	s2,-1
    80001362:	6a42                	ld	s4,16(sp)
    80001364:	a071                	j	800013f0 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80001366:	04a1                	addi	s1,s1,8
    80001368:	0921                	addi	s2,s2,8
    8000136a:	01348b63          	beq	s1,s3,80001380 <fork+0xc0>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    8000136e:	6088                	ld	a0,0(s1)
    80001370:	d97d                	beqz	a0,80001366 <fork+0xa6>
    80001372:	00002097          	auipc	ra,0x2
    80001376:	7c8080e7          	jalr	1992(ra) # 80003b3a <filedup>
    8000137a:	00a93023          	sd	a0,0(s2)
    8000137e:	b7e5                	j	80001366 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001380:	150ab503          	ld	a0,336(s5)
    80001384:	00002097          	auipc	ra,0x2
    80001388:	932080e7          	jalr	-1742(ra) # 80002cb6 <idup>
    8000138c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001390:	4641                	li	a2,16
    80001392:	158a8593          	addi	a1,s5,344
    80001396:	158a0513          	addi	a0,s4,344
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	f22080e7          	jalr	-222(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800013a2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013a6:	8552                	mv	a0,s4
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	148080e7          	jalr	328(ra) # 800064f0 <release>
  acquire(&wait_lock);
    800013b0:	0000a497          	auipc	s1,0xa
    800013b4:	f2848493          	addi	s1,s1,-216 # 8000b2d8 <wait_lock>
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	082080e7          	jalr	130(ra) # 8000643c <acquire>
  np->parent = p;
    800013c2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00005097          	auipc	ra,0x5
    800013cc:	128080e7          	jalr	296(ra) # 800064f0 <release>
  acquire(&np->lock);
    800013d0:	8552                	mv	a0,s4
    800013d2:	00005097          	auipc	ra,0x5
    800013d6:	06a080e7          	jalr	106(ra) # 8000643c <acquire>
  np->state = RUNNABLE;
    800013da:	478d                	li	a5,3
    800013dc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013e0:	8552                	mv	a0,s4
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	10e080e7          	jalr	270(ra) # 800064f0 <release>
  return pid;
    800013ea:	74a2                	ld	s1,40(sp)
    800013ec:	69e2                	ld	s3,24(sp)
    800013ee:	6a42                	ld	s4,16(sp)
}
    800013f0:	854a                	mv	a0,s2
    800013f2:	70e2                	ld	ra,56(sp)
    800013f4:	7442                	ld	s0,48(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6aa2                	ld	s5,8(sp)
    800013fa:	6121                	addi	sp,sp,64
    800013fc:	8082                	ret
    return -1;
    800013fe:	597d                	li	s2,-1
    80001400:	bfc5                	j	800013f0 <fork+0x130>

0000000080001402 <scheduler>:
void scheduler(void) {
    80001402:	7139                	addi	sp,sp,-64
    80001404:	fc06                	sd	ra,56(sp)
    80001406:	f822                	sd	s0,48(sp)
    80001408:	f426                	sd	s1,40(sp)
    8000140a:	f04a                	sd	s2,32(sp)
    8000140c:	ec4e                	sd	s3,24(sp)
    8000140e:	e852                	sd	s4,16(sp)
    80001410:	e456                	sd	s5,8(sp)
    80001412:	e05a                	sd	s6,0(sp)
    80001414:	0080                	addi	s0,sp,64
    80001416:	8792                	mv	a5,tp
  int id = r_tp();
    80001418:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000141a:	00779a93          	slli	s5,a5,0x7
    8000141e:	0000a717          	auipc	a4,0xa
    80001422:	ea270713          	addi	a4,a4,-350 # 8000b2c0 <pid_lock>
    80001426:	9756                	add	a4,a4,s5
    80001428:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000142c:	0000a717          	auipc	a4,0xa
    80001430:	ecc70713          	addi	a4,a4,-308 # 8000b2f8 <cpus+0x8>
    80001434:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001436:	498d                	li	s3,3
        p->state = RUNNING;
    80001438:	4b11                	li	s6,4
        c->proc = p;
    8000143a:	079e                	slli	a5,a5,0x7
    8000143c:	0000aa17          	auipc	s4,0xa
    80001440:	e84a0a13          	addi	s4,s4,-380 # 8000b2c0 <pid_lock>
    80001444:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80001446:	00010917          	auipc	s2,0x10
    8000144a:	caa90913          	addi	s2,s2,-854 # 800110f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000144e:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001452:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001456:	10079073          	csrw	sstatus,a5
    8000145a:	0000a497          	auipc	s1,0xa
    8000145e:	29648493          	addi	s1,s1,662 # 8000b6f0 <proc>
    80001462:	a811                	j	80001476 <scheduler+0x74>
      release(&p->lock);
    80001464:	8526                	mv	a0,s1
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	08a080e7          	jalr	138(ra) # 800064f0 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000146e:	16848493          	addi	s1,s1,360
    80001472:	fd248ee3          	beq	s1,s2,8000144e <scheduler+0x4c>
      acquire(&p->lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	fc4080e7          	jalr	-60(ra) # 8000643c <acquire>
      if (p->state == RUNNABLE) {
    80001480:	4c9c                	lw	a5,24(s1)
    80001482:	ff3791e3          	bne	a5,s3,80001464 <scheduler+0x62>
        p->state = RUNNING;
    80001486:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000148a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000148e:	06048593          	addi	a1,s1,96
    80001492:	8556                	mv	a0,s5
    80001494:	00000097          	auipc	ra,0x0
    80001498:	768080e7          	jalr	1896(ra) # 80001bfc <swtch>
        c->proc = 0;
    8000149c:	020a3823          	sd	zero,48(s4)
    800014a0:	b7d1                	j	80001464 <scheduler+0x62>

00000000800014a2 <sched>:
void sched(void) {
    800014a2:	7179                	addi	sp,sp,-48
    800014a4:	f406                	sd	ra,40(sp)
    800014a6:	f022                	sd	s0,32(sp)
    800014a8:	ec26                	sd	s1,24(sp)
    800014aa:	e84a                	sd	s2,16(sp)
    800014ac:	e44e                	sd	s3,8(sp)
    800014ae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	a56080e7          	jalr	-1450(ra) # 80000f06 <myproc>
    800014b8:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	f08080e7          	jalr	-248(ra) # 800063c2 <holding>
    800014c2:	c93d                	beqz	a0,80001538 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    800014c4:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	0000a717          	auipc	a4,0xa
    800014ce:	df670713          	addi	a4,a4,-522 # 8000b2c0 <pid_lock>
    800014d2:	97ba                	add	a5,a5,a4
    800014d4:	0a87a703          	lw	a4,168(a5)
    800014d8:	4785                	li	a5,1
    800014da:	06f71763          	bne	a4,a5,80001548 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    800014de:	4c98                	lw	a4,24(s1)
    800014e0:	4791                	li	a5,4
    800014e2:	06f70b63          	beq	a4,a5,80001558 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800014e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ea:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    800014ec:	efb5                	bnez	a5,80001568 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    800014ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014f0:	0000a917          	auipc	s2,0xa
    800014f4:	dd090913          	addi	s2,s2,-560 # 8000b2c0 <pid_lock>
    800014f8:	2781                	sext.w	a5,a5
    800014fa:	079e                	slli	a5,a5,0x7
    800014fc:	97ca                	add	a5,a5,s2
    800014fe:	0ac7a983          	lw	s3,172(a5)
    80001502:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	0000a597          	auipc	a1,0xa
    8000150c:	df058593          	addi	a1,a1,-528 # 8000b2f8 <cpus+0x8>
    80001510:	95be                	add	a1,a1,a5
    80001512:	06048513          	addi	a0,s1,96
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	6e6080e7          	jalr	1766(ra) # 80001bfc <swtch>
    8000151e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001520:	2781                	sext.w	a5,a5
    80001522:	079e                	slli	a5,a5,0x7
    80001524:	993e                	add	s2,s2,a5
    80001526:	0b392623          	sw	s3,172(s2)
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	addi	sp,sp,48
    80001536:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	ca050513          	addi	a0,a0,-864 # 800081d8 <etext+0x1d8>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	982080e7          	jalr	-1662(ra) # 80005ec2 <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001548:	00007517          	auipc	a0,0x7
    8000154c:	ca050513          	addi	a0,a0,-864 # 800081e8 <etext+0x1e8>
    80001550:	00005097          	auipc	ra,0x5
    80001554:	972080e7          	jalr	-1678(ra) # 80005ec2 <panic>
  if (p->state == RUNNING) panic("sched running");
    80001558:	00007517          	auipc	a0,0x7
    8000155c:	ca050513          	addi	a0,a0,-864 # 800081f8 <etext+0x1f8>
    80001560:	00005097          	auipc	ra,0x5
    80001564:	962080e7          	jalr	-1694(ra) # 80005ec2 <panic>
  if (intr_get()) panic("sched interruptible");
    80001568:	00007517          	auipc	a0,0x7
    8000156c:	ca050513          	addi	a0,a0,-864 # 80008208 <etext+0x208>
    80001570:	00005097          	auipc	ra,0x5
    80001574:	952080e7          	jalr	-1710(ra) # 80005ec2 <panic>

0000000080001578 <yield>:
void yield(void) {
    80001578:	1101                	addi	sp,sp,-32
    8000157a:	ec06                	sd	ra,24(sp)
    8000157c:	e822                	sd	s0,16(sp)
    8000157e:	e426                	sd	s1,8(sp)
    80001580:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	984080e7          	jalr	-1660(ra) # 80000f06 <myproc>
    8000158a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	eb0080e7          	jalr	-336(ra) # 8000643c <acquire>
  p->state = RUNNABLE;
    80001594:	478d                	li	a5,3
    80001596:	cc9c                	sw	a5,24(s1)
  sched();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	f0a080e7          	jalr	-246(ra) # 800014a2 <sched>
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	f4e080e7          	jalr	-178(ra) # 800064f0 <release>
}
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	64a2                	ld	s1,8(sp)
    800015b0:	6105                	addi	sp,sp,32
    800015b2:	8082                	ret

00000000800015b4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800015b4:	7179                	addi	sp,sp,-48
    800015b6:	f406                	sd	ra,40(sp)
    800015b8:	f022                	sd	s0,32(sp)
    800015ba:	ec26                	sd	s1,24(sp)
    800015bc:	e84a                	sd	s2,16(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	1800                	addi	s0,sp,48
    800015c2:	89aa                	mv	s3,a0
    800015c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	940080e7          	jalr	-1728(ra) # 80000f06 <myproc>
    800015ce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	e6c080e7          	jalr	-404(ra) # 8000643c <acquire>
  release(lk);
    800015d8:	854a                	mv	a0,s2
    800015da:	00005097          	auipc	ra,0x5
    800015de:	f16080e7          	jalr	-234(ra) # 800064f0 <release>

  // Go to sleep.
  p->chan = chan;
    800015e2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015e6:	4789                	li	a5,2
    800015e8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	eb8080e7          	jalr	-328(ra) # 800014a2 <sched>

  // Tidy up.
  p->chan = 0;
    800015f2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	ef8080e7          	jalr	-264(ra) # 800064f0 <release>
  acquire(lk);
    80001600:	854a                	mv	a0,s2
    80001602:	00005097          	auipc	ra,0x5
    80001606:	e3a080e7          	jalr	-454(ra) # 8000643c <acquire>
}
    8000160a:	70a2                	ld	ra,40(sp)
    8000160c:	7402                	ld	s0,32(sp)
    8000160e:	64e2                	ld	s1,24(sp)
    80001610:	6942                	ld	s2,16(sp)
    80001612:	69a2                	ld	s3,8(sp)
    80001614:	6145                	addi	sp,sp,48
    80001616:	8082                	ret

0000000080001618 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001618:	7139                	addi	sp,sp,-64
    8000161a:	fc06                	sd	ra,56(sp)
    8000161c:	f822                	sd	s0,48(sp)
    8000161e:	f426                	sd	s1,40(sp)
    80001620:	f04a                	sd	s2,32(sp)
    80001622:	ec4e                	sd	s3,24(sp)
    80001624:	e852                	sd	s4,16(sp)
    80001626:	e456                	sd	s5,8(sp)
    80001628:	0080                	addi	s0,sp,64
    8000162a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000162c:	0000a497          	auipc	s1,0xa
    80001630:	0c448493          	addi	s1,s1,196 # 8000b6f0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001634:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001636:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001638:	00010917          	auipc	s2,0x10
    8000163c:	ab890913          	addi	s2,s2,-1352 # 800110f0 <tickslock>
    80001640:	a811                	j	80001654 <wakeup+0x3c>
      }
      release(&p->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	eac080e7          	jalr	-340(ra) # 800064f0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000164c:	16848493          	addi	s1,s1,360
    80001650:	03248663          	beq	s1,s2,8000167c <wakeup+0x64>
    if (p != myproc()) {
    80001654:	00000097          	auipc	ra,0x0
    80001658:	8b2080e7          	jalr	-1870(ra) # 80000f06 <myproc>
    8000165c:	fea488e3          	beq	s1,a0,8000164c <wakeup+0x34>
      acquire(&p->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	dda080e7          	jalr	-550(ra) # 8000643c <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    8000166a:	4c9c                	lw	a5,24(s1)
    8000166c:	fd379be3          	bne	a5,s3,80001642 <wakeup+0x2a>
    80001670:	709c                	ld	a5,32(s1)
    80001672:	fd4798e3          	bne	a5,s4,80001642 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001676:	0154ac23          	sw	s5,24(s1)
    8000167a:	b7e1                	j	80001642 <wakeup+0x2a>
    }
  }
}
    8000167c:	70e2                	ld	ra,56(sp)
    8000167e:	7442                	ld	s0,48(sp)
    80001680:	74a2                	ld	s1,40(sp)
    80001682:	7902                	ld	s2,32(sp)
    80001684:	69e2                	ld	s3,24(sp)
    80001686:	6a42                	ld	s4,16(sp)
    80001688:	6aa2                	ld	s5,8(sp)
    8000168a:	6121                	addi	sp,sp,64
    8000168c:	8082                	ret

000000008000168e <reparent>:
void reparent(struct proc *p) {
    8000168e:	7179                	addi	sp,sp,-48
    80001690:	f406                	sd	ra,40(sp)
    80001692:	f022                	sd	s0,32(sp)
    80001694:	ec26                	sd	s1,24(sp)
    80001696:	e84a                	sd	s2,16(sp)
    80001698:	e44e                	sd	s3,8(sp)
    8000169a:	e052                	sd	s4,0(sp)
    8000169c:	1800                	addi	s0,sp,48
    8000169e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800016a0:	0000a497          	auipc	s1,0xa
    800016a4:	05048493          	addi	s1,s1,80 # 8000b6f0 <proc>
      pp->parent = initproc;
    800016a8:	0000aa17          	auipc	s4,0xa
    800016ac:	bd8a0a13          	addi	s4,s4,-1064 # 8000b280 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800016b0:	00010997          	auipc	s3,0x10
    800016b4:	a4098993          	addi	s3,s3,-1472 # 800110f0 <tickslock>
    800016b8:	a029                	j	800016c2 <reparent+0x34>
    800016ba:	16848493          	addi	s1,s1,360
    800016be:	01348d63          	beq	s1,s3,800016d8 <reparent+0x4a>
    if (pp->parent == p) {
    800016c2:	7c9c                	ld	a5,56(s1)
    800016c4:	ff279be3          	bne	a5,s2,800016ba <reparent+0x2c>
      pp->parent = initproc;
    800016c8:	000a3503          	ld	a0,0(s4)
    800016cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	f4a080e7          	jalr	-182(ra) # 80001618 <wakeup>
    800016d6:	b7d5                	j	800016ba <reparent+0x2c>
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6a02                	ld	s4,0(sp)
    800016e4:	6145                	addi	sp,sp,48
    800016e6:	8082                	ret

00000000800016e8 <exit>:
void exit(int status) {
    800016e8:	7179                	addi	sp,sp,-48
    800016ea:	f406                	sd	ra,40(sp)
    800016ec:	f022                	sd	s0,32(sp)
    800016ee:	ec26                	sd	s1,24(sp)
    800016f0:	e84a                	sd	s2,16(sp)
    800016f2:	e44e                	sd	s3,8(sp)
    800016f4:	e052                	sd	s4,0(sp)
    800016f6:	1800                	addi	s0,sp,48
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	80c080e7          	jalr	-2036(ra) # 80000f06 <myproc>
    80001702:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001704:	0000a797          	auipc	a5,0xa
    80001708:	b7c7b783          	ld	a5,-1156(a5) # 8000b280 <initproc>
    8000170c:	0d050493          	addi	s1,a0,208
    80001710:	15050913          	addi	s2,a0,336
    80001714:	02a79363          	bne	a5,a0,8000173a <exit+0x52>
    80001718:	00007517          	auipc	a0,0x7
    8000171c:	b0850513          	addi	a0,a0,-1272 # 80008220 <etext+0x220>
    80001720:	00004097          	auipc	ra,0x4
    80001724:	7a2080e7          	jalr	1954(ra) # 80005ec2 <panic>
      fileclose(f);
    80001728:	00002097          	auipc	ra,0x2
    8000172c:	464080e7          	jalr	1124(ra) # 80003b8c <fileclose>
      p->ofile[fd] = 0;
    80001730:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001734:	04a1                	addi	s1,s1,8
    80001736:	01248563          	beq	s1,s2,80001740 <exit+0x58>
    if (p->ofile[fd]) {
    8000173a:	6088                	ld	a0,0(s1)
    8000173c:	f575                	bnez	a0,80001728 <exit+0x40>
    8000173e:	bfdd                	j	80001734 <exit+0x4c>
  begin_op();
    80001740:	00002097          	auipc	ra,0x2
    80001744:	f82080e7          	jalr	-126(ra) # 800036c2 <begin_op>
  iput(p->cwd);
    80001748:	1509b503          	ld	a0,336(s3)
    8000174c:	00001097          	auipc	ra,0x1
    80001750:	766080e7          	jalr	1894(ra) # 80002eb2 <iput>
  end_op();
    80001754:	00002097          	auipc	ra,0x2
    80001758:	fe8080e7          	jalr	-24(ra) # 8000373c <end_op>
  p->cwd = 0;
    8000175c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001760:	0000a497          	auipc	s1,0xa
    80001764:	b7848493          	addi	s1,s1,-1160 # 8000b2d8 <wait_lock>
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	cd2080e7          	jalr	-814(ra) # 8000643c <acquire>
  reparent(p);
    80001772:	854e                	mv	a0,s3
    80001774:	00000097          	auipc	ra,0x0
    80001778:	f1a080e7          	jalr	-230(ra) # 8000168e <reparent>
  wakeup(p->parent);
    8000177c:	0389b503          	ld	a0,56(s3)
    80001780:	00000097          	auipc	ra,0x0
    80001784:	e98080e7          	jalr	-360(ra) # 80001618 <wakeup>
  acquire(&p->lock);
    80001788:	854e                	mv	a0,s3
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	cb2080e7          	jalr	-846(ra) # 8000643c <acquire>
  p->xstate = status;
    80001792:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001796:	4795                	li	a5,5
    80001798:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	d52080e7          	jalr	-686(ra) # 800064f0 <release>
  sched();
    800017a6:	00000097          	auipc	ra,0x0
    800017aa:	cfc080e7          	jalr	-772(ra) # 800014a2 <sched>
  panic("zombie exit");
    800017ae:	00007517          	auipc	a0,0x7
    800017b2:	a8250513          	addi	a0,a0,-1406 # 80008230 <etext+0x230>
    800017b6:	00004097          	auipc	ra,0x4
    800017ba:	70c080e7          	jalr	1804(ra) # 80005ec2 <panic>

00000000800017be <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800017be:	7179                	addi	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	1800                	addi	s0,sp,48
    800017cc:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800017ce:	0000a497          	auipc	s1,0xa
    800017d2:	f2248493          	addi	s1,s1,-222 # 8000b6f0 <proc>
    800017d6:	00010997          	auipc	s3,0x10
    800017da:	91a98993          	addi	s3,s3,-1766 # 800110f0 <tickslock>
    acquire(&p->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	c5c080e7          	jalr	-932(ra) # 8000643c <acquire>
    if (p->pid == pid) {
    800017e8:	589c                	lw	a5,48(s1)
    800017ea:	01278d63          	beq	a5,s2,80001804 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	d00080e7          	jalr	-768(ra) # 800064f0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017f8:	16848493          	addi	s1,s1,360
    800017fc:	ff3491e3          	bne	s1,s3,800017de <kill+0x20>
  }
  return -1;
    80001800:	557d                	li	a0,-1
    80001802:	a829                	j	8000181c <kill+0x5e>
      p->killed = 1;
    80001804:	4785                	li	a5,1
    80001806:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001808:	4c98                	lw	a4,24(s1)
    8000180a:	4789                	li	a5,2
    8000180c:	00f70f63          	beq	a4,a5,8000182a <kill+0x6c>
      release(&p->lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	cde080e7          	jalr	-802(ra) # 800064f0 <release>
      return 0;
    8000181a:	4501                	li	a0,0
}
    8000181c:	70a2                	ld	ra,40(sp)
    8000181e:	7402                	ld	s0,32(sp)
    80001820:	64e2                	ld	s1,24(sp)
    80001822:	6942                	ld	s2,16(sp)
    80001824:	69a2                	ld	s3,8(sp)
    80001826:	6145                	addi	sp,sp,48
    80001828:	8082                	ret
        p->state = RUNNABLE;
    8000182a:	478d                	li	a5,3
    8000182c:	cc9c                	sw	a5,24(s1)
    8000182e:	b7cd                	j	80001810 <kill+0x52>

0000000080001830 <setkilled>:

void setkilled(struct proc *p) {
    80001830:	1101                	addi	sp,sp,-32
    80001832:	ec06                	sd	ra,24(sp)
    80001834:	e822                	sd	s0,16(sp)
    80001836:	e426                	sd	s1,8(sp)
    80001838:	1000                	addi	s0,sp,32
    8000183a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	c00080e7          	jalr	-1024(ra) # 8000643c <acquire>
  p->killed = 1;
    80001844:	4785                	li	a5,1
    80001846:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001848:	8526                	mv	a0,s1
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	ca6080e7          	jalr	-858(ra) # 800064f0 <release>
}
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6105                	addi	sp,sp,32
    8000185a:	8082                	ret

000000008000185c <killed>:

int killed(struct proc *p) {
    8000185c:	1101                	addi	sp,sp,-32
    8000185e:	ec06                	sd	ra,24(sp)
    80001860:	e822                	sd	s0,16(sp)
    80001862:	e426                	sd	s1,8(sp)
    80001864:	e04a                	sd	s2,0(sp)
    80001866:	1000                	addi	s0,sp,32
    80001868:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	bd2080e7          	jalr	-1070(ra) # 8000643c <acquire>
  k = p->killed;
    80001872:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	c78080e7          	jalr	-904(ra) # 800064f0 <release>
  return k;
}
    80001880:	854a                	mv	a0,s2
    80001882:	60e2                	ld	ra,24(sp)
    80001884:	6442                	ld	s0,16(sp)
    80001886:	64a2                	ld	s1,8(sp)
    80001888:	6902                	ld	s2,0(sp)
    8000188a:	6105                	addi	sp,sp,32
    8000188c:	8082                	ret

000000008000188e <wait>:
int wait(uint64 addr) {
    8000188e:	715d                	addi	sp,sp,-80
    80001890:	e486                	sd	ra,72(sp)
    80001892:	e0a2                	sd	s0,64(sp)
    80001894:	fc26                	sd	s1,56(sp)
    80001896:	f84a                	sd	s2,48(sp)
    80001898:	f44e                	sd	s3,40(sp)
    8000189a:	f052                	sd	s4,32(sp)
    8000189c:	ec56                	sd	s5,24(sp)
    8000189e:	e85a                	sd	s6,16(sp)
    800018a0:	e45e                	sd	s7,8(sp)
    800018a2:	e062                	sd	s8,0(sp)
    800018a4:	0880                	addi	s0,sp,80
    800018a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018a8:	fffff097          	auipc	ra,0xfffff
    800018ac:	65e080e7          	jalr	1630(ra) # 80000f06 <myproc>
    800018b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018b2:	0000a517          	auipc	a0,0xa
    800018b6:	a2650513          	addi	a0,a0,-1498 # 8000b2d8 <wait_lock>
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	b82080e7          	jalr	-1150(ra) # 8000643c <acquire>
    havekids = 0;
    800018c2:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    800018c4:	4a15                	li	s4,5
        havekids = 1;
    800018c6:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018c8:	00010997          	auipc	s3,0x10
    800018cc:	82898993          	addi	s3,s3,-2008 # 800110f0 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800018d0:	0000ac17          	auipc	s8,0xa
    800018d4:	a08c0c13          	addi	s8,s8,-1528 # 8000b2d8 <wait_lock>
    800018d8:	a0d1                	j	8000199c <wait+0x10e>
          pid = pp->pid;
    800018da:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018de:	000b0e63          	beqz	s6,800018fa <wait+0x6c>
    800018e2:	4691                	li	a3,4
    800018e4:	02c48613          	addi	a2,s1,44
    800018e8:	85da                	mv	a1,s6
    800018ea:	05093503          	ld	a0,80(s2)
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	25e080e7          	jalr	606(ra) # 80000b4c <copyout>
    800018f6:	04054163          	bltz	a0,80001938 <wait+0xaa>
          freeproc(pp);
    800018fa:	8526                	mv	a0,s1
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	7c0080e7          	jalr	1984(ra) # 800010bc <freeproc>
          release(&pp->lock);
    80001904:	8526                	mv	a0,s1
    80001906:	00005097          	auipc	ra,0x5
    8000190a:	bea080e7          	jalr	-1046(ra) # 800064f0 <release>
          release(&wait_lock);
    8000190e:	0000a517          	auipc	a0,0xa
    80001912:	9ca50513          	addi	a0,a0,-1590 # 8000b2d8 <wait_lock>
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	bda080e7          	jalr	-1062(ra) # 800064f0 <release>
}
    8000191e:	854e                	mv	a0,s3
    80001920:	60a6                	ld	ra,72(sp)
    80001922:	6406                	ld	s0,64(sp)
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	7942                	ld	s2,48(sp)
    80001928:	79a2                	ld	s3,40(sp)
    8000192a:	7a02                	ld	s4,32(sp)
    8000192c:	6ae2                	ld	s5,24(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	6ba2                	ld	s7,8(sp)
    80001932:	6c02                	ld	s8,0(sp)
    80001934:	6161                	addi	sp,sp,80
    80001936:	8082                	ret
            release(&pp->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	bb6080e7          	jalr	-1098(ra) # 800064f0 <release>
            release(&wait_lock);
    80001942:	0000a517          	auipc	a0,0xa
    80001946:	99650513          	addi	a0,a0,-1642 # 8000b2d8 <wait_lock>
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	ba6080e7          	jalr	-1114(ra) # 800064f0 <release>
            return -1;
    80001952:	59fd                	li	s3,-1
    80001954:	b7e9                	j	8000191e <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001956:	16848493          	addi	s1,s1,360
    8000195a:	03348463          	beq	s1,s3,80001982 <wait+0xf4>
      if (pp->parent == p) {
    8000195e:	7c9c                	ld	a5,56(s1)
    80001960:	ff279be3          	bne	a5,s2,80001956 <wait+0xc8>
        acquire(&pp->lock);
    80001964:	8526                	mv	a0,s1
    80001966:	00005097          	auipc	ra,0x5
    8000196a:	ad6080e7          	jalr	-1322(ra) # 8000643c <acquire>
        if (pp->state == ZOMBIE) {
    8000196e:	4c9c                	lw	a5,24(s1)
    80001970:	f74785e3          	beq	a5,s4,800018da <wait+0x4c>
        release(&pp->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	b7a080e7          	jalr	-1158(ra) # 800064f0 <release>
        havekids = 1;
    8000197e:	8756                	mv	a4,s5
    80001980:	bfd9                	j	80001956 <wait+0xc8>
    if (!havekids || killed(p)) {
    80001982:	c31d                	beqz	a4,800019a8 <wait+0x11a>
    80001984:	854a                	mv	a0,s2
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	ed6080e7          	jalr	-298(ra) # 8000185c <killed>
    8000198e:	ed09                	bnez	a0,800019a8 <wait+0x11a>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001990:	85e2                	mv	a1,s8
    80001992:	854a                	mv	a0,s2
    80001994:	00000097          	auipc	ra,0x0
    80001998:	c20080e7          	jalr	-992(ra) # 800015b4 <sleep>
    havekids = 0;
    8000199c:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000199e:	0000a497          	auipc	s1,0xa
    800019a2:	d5248493          	addi	s1,s1,-686 # 8000b6f0 <proc>
    800019a6:	bf65                	j	8000195e <wait+0xd0>
      release(&wait_lock);
    800019a8:	0000a517          	auipc	a0,0xa
    800019ac:	93050513          	addi	a0,a0,-1744 # 8000b2d8 <wait_lock>
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	b40080e7          	jalr	-1216(ra) # 800064f0 <release>
      return -1;
    800019b8:	59fd                	li	s3,-1
    800019ba:	b795                	j	8000191e <wait+0x90>

00000000800019bc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800019bc:	7179                	addi	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	addi	s0,sp,48
    800019cc:	84aa                	mv	s1,a0
    800019ce:	892e                	mv	s2,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	532080e7          	jalr	1330(ra) # 80000f06 <myproc>
  if (user_dst) {
    800019dc:	c08d                	beqz	s1,800019fe <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	166080e7          	jalr	358(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
    memmove((char *)dst, src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyout+0x32>

0000000080001a12 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001a12:	7179                	addi	sp,sp,-48
    80001a14:	f406                	sd	ra,40(sp)
    80001a16:	f022                	sd	s0,32(sp)
    80001a18:	ec26                	sd	s1,24(sp)
    80001a1a:	e84a                	sd	s2,16(sp)
    80001a1c:	e44e                	sd	s3,8(sp)
    80001a1e:	e052                	sd	s4,0(sp)
    80001a20:	1800                	addi	s0,sp,48
    80001a22:	892a                	mv	s2,a0
    80001a24:	84ae                	mv	s1,a1
    80001a26:	89b2                	mv	s3,a2
    80001a28:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	4dc080e7          	jalr	1244(ra) # 80000f06 <myproc>
  if (user_src) {
    80001a32:	c08d                	beqz	s1,80001a54 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a34:	86d2                	mv	a3,s4
    80001a36:	864e                	mv	a2,s3
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	6928                	ld	a0,80(a0)
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	1ee080e7          	jalr	494(ra) # 80000c2a <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001a44:	70a2                	ld	ra,40(sp)
    80001a46:	7402                	ld	s0,32(sp)
    80001a48:	64e2                	ld	s1,24(sp)
    80001a4a:	6942                	ld	s2,16(sp)
    80001a4c:	69a2                	ld	s3,8(sp)
    80001a4e:	6a02                	ld	s4,0(sp)
    80001a50:	6145                	addi	sp,sp,48
    80001a52:	8082                	ret
    memmove(dst, (char *)src, len);
    80001a54:	000a061b          	sext.w	a2,s4
    80001a58:	85ce                	mv	a1,s3
    80001a5a:	854a                	mv	a0,s2
    80001a5c:	ffffe097          	auipc	ra,0xffffe
    80001a60:	77a080e7          	jalr	1914(ra) # 800001d6 <memmove>
    return 0;
    80001a64:	8526                	mv	a0,s1
    80001a66:	bff9                	j	80001a44 <either_copyin+0x32>

0000000080001a68 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001a68:	715d                	addi	sp,sp,-80
    80001a6a:	e486                	sd	ra,72(sp)
    80001a6c:	e0a2                	sd	s0,64(sp)
    80001a6e:	fc26                	sd	s1,56(sp)
    80001a70:	f84a                	sd	s2,48(sp)
    80001a72:	f44e                	sd	s3,40(sp)
    80001a74:	f052                	sd	s4,32(sp)
    80001a76:	ec56                	sd	s5,24(sp)
    80001a78:	e85a                	sd	s6,16(sp)
    80001a7a:	e45e                	sd	s7,8(sp)
    80001a7c:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001a7e:	00006517          	auipc	a0,0x6
    80001a82:	59a50513          	addi	a0,a0,1434 # 80008018 <etext+0x18>
    80001a86:	00004097          	auipc	ra,0x4
    80001a8a:	486080e7          	jalr	1158(ra) # 80005f0c <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a8e:	0000a497          	auipc	s1,0xa
    80001a92:	dba48493          	addi	s1,s1,-582 # 8000b848 <proc+0x158>
    80001a96:	0000f917          	auipc	s2,0xf
    80001a9a:	7b290913          	addi	s2,s2,1970 # 80011248 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a9e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa0:	00006997          	auipc	s3,0x6
    80001aa4:	7a098993          	addi	s3,s3,1952 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001aa8:	00006a97          	auipc	s5,0x6
    80001aac:	7a0a8a93          	addi	s5,s5,1952 # 80008248 <etext+0x248>
    printf("\n");
    80001ab0:	00006a17          	auipc	s4,0x6
    80001ab4:	568a0a13          	addi	s4,s4,1384 # 80008018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab8:	00007b97          	auipc	s7,0x7
    80001abc:	cb8b8b93          	addi	s7,s7,-840 # 80008770 <states.0>
    80001ac0:	a00d                	j	80001ae2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac2:	ed86a583          	lw	a1,-296(a3)
    80001ac6:	8556                	mv	a0,s5
    80001ac8:	00004097          	auipc	ra,0x4
    80001acc:	444080e7          	jalr	1092(ra) # 80005f0c <printf>
    printf("\n");
    80001ad0:	8552                	mv	a0,s4
    80001ad2:	00004097          	auipc	ra,0x4
    80001ad6:	43a080e7          	jalr	1082(ra) # 80005f0c <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ada:	16848493          	addi	s1,s1,360
    80001ade:	03248263          	beq	s1,s2,80001b02 <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001ae2:	86a6                	mv	a3,s1
    80001ae4:	ec04a783          	lw	a5,-320(s1)
    80001ae8:	dbed                	beqz	a5,80001ada <procdump+0x72>
      state = "???";
    80001aea:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aec:	fcfb6be3          	bltu	s6,a5,80001ac2 <procdump+0x5a>
    80001af0:	02079713          	slli	a4,a5,0x20
    80001af4:	01d75793          	srli	a5,a4,0x1d
    80001af8:	97de                	add	a5,a5,s7
    80001afa:	6390                	ld	a2,0(a5)
    80001afc:	f279                	bnez	a2,80001ac2 <procdump+0x5a>
      state = "???";
    80001afe:	864e                	mv	a2,s3
    80001b00:	b7c9                	j	80001ac2 <procdump+0x5a>
  }
}
    80001b02:	60a6                	ld	ra,72(sp)
    80001b04:	6406                	ld	s0,64(sp)
    80001b06:	74e2                	ld	s1,56(sp)
    80001b08:	7942                	ld	s2,48(sp)
    80001b0a:	79a2                	ld	s3,40(sp)
    80001b0c:	7a02                	ld	s4,32(sp)
    80001b0e:	6ae2                	ld	s5,24(sp)
    80001b10:	6b42                	ld	s6,16(sp)
    80001b12:	6ba2                	ld	s7,8(sp)
    80001b14:	6161                	addi	sp,sp,80
    80001b16:	8082                	ret

0000000080001b18 <reg>:

int reg(int pid, int register_num, uint64 *return_value) {
  if (register_num < 2 || register_num > 11) {
    80001b18:	ffe5871b          	addiw	a4,a1,-2
    80001b1c:	47a5                	li	a5,9
    80001b1e:	0ce7e963          	bltu	a5,a4,80001bf0 <reg+0xd8>
int reg(int pid, int register_num, uint64 *return_value) {
    80001b22:	715d                	addi	sp,sp,-80
    80001b24:	e486                	sd	ra,72(sp)
    80001b26:	e0a2                	sd	s0,64(sp)
    80001b28:	fc26                	sd	s1,56(sp)
    80001b2a:	f84a                	sd	s2,48(sp)
    80001b2c:	f44e                	sd	s3,40(sp)
    80001b2e:	f052                	sd	s4,32(sp)
    80001b30:	ec56                	sd	s5,24(sp)
    80001b32:	e85a                	sd	s6,16(sp)
    80001b34:	0880                	addi	s0,sp,80
    80001b36:	892a                	mv	s2,a0
    80001b38:	8a2e                	mv	s4,a1
    80001b3a:	8ab2                	mv	s5,a2
    return -3;
  }
  struct proc *this_proc = myproc();
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	3ca080e7          	jalr	970(ra) # 80000f06 <myproc>
    80001b44:	8b2a                	mv	s6,a0
  struct proc *target = proc;
    80001b46:	0000a497          	auipc	s1,0xa
    80001b4a:	baa48493          	addi	s1,s1,-1110 # 8000b6f0 <proc>
  for (; target < proc + NPROC; ++target) {
    80001b4e:	0000f997          	auipc	s3,0xf
    80001b52:	5a298993          	addi	s3,s3,1442 # 800110f0 <tickslock>
    acquire(&target->lock);
    80001b56:	8526                	mv	a0,s1
    80001b58:	00005097          	auipc	ra,0x5
    80001b5c:	8e4080e7          	jalr	-1820(ra) # 8000643c <acquire>
    if (target->pid == pid) {
    80001b60:	589c                	lw	a5,48(s1)
    80001b62:	01278d63          	beq	a5,s2,80001b7c <reg+0x64>
      break;
    }
    release(&target->lock);
    80001b66:	8526                	mv	a0,s1
    80001b68:	00005097          	auipc	ra,0x5
    80001b6c:	988080e7          	jalr	-1656(ra) # 800064f0 <release>
  for (; target < proc + NPROC; ++target) {
    80001b70:	16848493          	addi	s1,s1,360
    80001b74:	ff3491e3          	bne	s1,s3,80001b56 <reg+0x3e>
  }
  if (target == proc + NPROC) {
    return -2;
    80001b78:	5579                	li	a0,-2
    80001b7a:	a891                	j	80001bce <reg+0xb6>
  if (target == proc + NPROC) {
    80001b7c:	0000f797          	auipc	a5,0xf
    80001b80:	57478793          	addi	a5,a5,1396 # 800110f0 <tickslock>
    80001b84:	06f48863          	beq	s1,a5,80001bf4 <reg+0xdc>
  }
  if (target->pid != this_proc->pid && target->parent != this_proc) {
    80001b88:	5898                	lw	a4,48(s1)
    80001b8a:	030b2783          	lw	a5,48(s6)
    80001b8e:	00f70563          	beq	a4,a5,80001b98 <reg+0x80>
    80001b92:	7c9c                	ld	a5,56(s1)
    80001b94:	05679763          	bne	a5,s6,80001be2 <reg+0xca>
    release(&target->lock);
    return -1;
  }
  uint64 val = (&(target->trapframe->s2))[register_num - 2];
    80001b98:	6cbc                	ld	a5,88(s1)
    80001b9a:	003a1593          	slli	a1,s4,0x3
    80001b9e:	97ae                	add	a5,a5,a1
    80001ba0:	73dc                	ld	a5,160(a5)
    80001ba2:	faf43c23          	sd	a5,-72(s0)
  release(&target->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	00005097          	auipc	ra,0x5
    80001bac:	948080e7          	jalr	-1720(ra) # 800064f0 <release>
  if (copyout(this_proc->pagetable, *return_value, (char *)(&val),
    80001bb0:	46a1                	li	a3,8
    80001bb2:	fb840613          	addi	a2,s0,-72
    80001bb6:	000ab583          	ld	a1,0(s5)
    80001bba:	050b3503          	ld	a0,80(s6)
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	f8e080e7          	jalr	-114(ra) # 80000b4c <copyout>
    80001bc6:	57fd                	li	a5,-1
    80001bc8:	02f50863          	beq	a0,a5,80001bf8 <reg+0xe0>
              sizeof(val)) == -1) {
    return -4;
  }
  return 0;
    80001bcc:	4501                	li	a0,0
}
    80001bce:	60a6                	ld	ra,72(sp)
    80001bd0:	6406                	ld	s0,64(sp)
    80001bd2:	74e2                	ld	s1,56(sp)
    80001bd4:	7942                	ld	s2,48(sp)
    80001bd6:	79a2                	ld	s3,40(sp)
    80001bd8:	7a02                	ld	s4,32(sp)
    80001bda:	6ae2                	ld	s5,24(sp)
    80001bdc:	6b42                	ld	s6,16(sp)
    80001bde:	6161                	addi	sp,sp,80
    80001be0:	8082                	ret
    release(&target->lock);
    80001be2:	8526                	mv	a0,s1
    80001be4:	00005097          	auipc	ra,0x5
    80001be8:	90c080e7          	jalr	-1780(ra) # 800064f0 <release>
    return -1;
    80001bec:	557d                	li	a0,-1
    80001bee:	b7c5                	j	80001bce <reg+0xb6>
    return -3;
    80001bf0:	5575                	li	a0,-3
}
    80001bf2:	8082                	ret
    return -2;
    80001bf4:	5579                	li	a0,-2
    80001bf6:	bfe1                	j	80001bce <reg+0xb6>
    return -4;
    80001bf8:	5571                	li	a0,-4
    80001bfa:	bfd1                	j	80001bce <reg+0xb6>

0000000080001bfc <swtch>:
    80001bfc:	00153023          	sd	ra,0(a0)
    80001c00:	00253423          	sd	sp,8(a0)
    80001c04:	e900                	sd	s0,16(a0)
    80001c06:	ed04                	sd	s1,24(a0)
    80001c08:	03253023          	sd	s2,32(a0)
    80001c0c:	03353423          	sd	s3,40(a0)
    80001c10:	03453823          	sd	s4,48(a0)
    80001c14:	03553c23          	sd	s5,56(a0)
    80001c18:	05653023          	sd	s6,64(a0)
    80001c1c:	05753423          	sd	s7,72(a0)
    80001c20:	05853823          	sd	s8,80(a0)
    80001c24:	05953c23          	sd	s9,88(a0)
    80001c28:	07a53023          	sd	s10,96(a0)
    80001c2c:	07b53423          	sd	s11,104(a0)
    80001c30:	0005b083          	ld	ra,0(a1)
    80001c34:	0085b103          	ld	sp,8(a1)
    80001c38:	6980                	ld	s0,16(a1)
    80001c3a:	6d84                	ld	s1,24(a1)
    80001c3c:	0205b903          	ld	s2,32(a1)
    80001c40:	0285b983          	ld	s3,40(a1)
    80001c44:	0305ba03          	ld	s4,48(a1)
    80001c48:	0385ba83          	ld	s5,56(a1)
    80001c4c:	0405bb03          	ld	s6,64(a1)
    80001c50:	0485bb83          	ld	s7,72(a1)
    80001c54:	0505bc03          	ld	s8,80(a1)
    80001c58:	0585bc83          	ld	s9,88(a1)
    80001c5c:	0605bd03          	ld	s10,96(a1)
    80001c60:	0685bd83          	ld	s11,104(a1)
    80001c64:	8082                	ret

0000000080001c66 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001c66:	1141                	addi	sp,sp,-16
    80001c68:	e406                	sd	ra,8(sp)
    80001c6a:	e022                	sd	s0,0(sp)
    80001c6c:	0800                	addi	s0,sp,16
    80001c6e:	00006597          	auipc	a1,0x6
    80001c72:	61a58593          	addi	a1,a1,1562 # 80008288 <etext+0x288>
    80001c76:	0000f517          	auipc	a0,0xf
    80001c7a:	47a50513          	addi	a0,a0,1146 # 800110f0 <tickslock>
    80001c7e:	00004097          	auipc	ra,0x4
    80001c82:	72e080e7          	jalr	1838(ra) # 800063ac <initlock>
    80001c86:	60a2                	ld	ra,8(sp)
    80001c88:	6402                	ld	s0,0(sp)
    80001c8a:	0141                	addi	sp,sp,16
    80001c8c:	8082                	ret

0000000080001c8e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001c8e:	1141                	addi	sp,sp,-16
    80001c90:	e422                	sd	s0,8(sp)
    80001c92:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c94:	00003797          	auipc	a5,0x3
    80001c98:	5fc78793          	addi	a5,a5,1532 # 80005290 <kernelvec>
    80001c9c:	10579073          	csrw	stvec,a5
    80001ca0:	6422                	ld	s0,8(sp)
    80001ca2:	0141                	addi	sp,sp,16
    80001ca4:	8082                	ret

0000000080001ca6 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001ca6:	1141                	addi	sp,sp,-16
    80001ca8:	e406                	sd	ra,8(sp)
    80001caa:	e022                	sd	s0,0(sp)
    80001cac:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	258080e7          	jalr	600(ra) # 80000f06 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001cb6:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001cba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001cbc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cc0:	00005697          	auipc	a3,0x5
    80001cc4:	34068693          	addi	a3,a3,832 # 80007000 <_trampoline>
    80001cc8:	00005717          	auipc	a4,0x5
    80001ccc:	33870713          	addi	a4,a4,824 # 80007000 <_trampoline>
    80001cd0:	8f15                	sub	a4,a4,a3
    80001cd2:	040007b7          	lui	a5,0x4000
    80001cd6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cd8:	07b2                	slli	a5,a5,0xc
    80001cda:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001cdc:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001ce0:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001ce2:	18002673          	csrr	a2,satp
    80001ce6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001ce8:	6d30                	ld	a2,88(a0)
    80001cea:	6138                	ld	a4,64(a0)
    80001cec:	6585                	lui	a1,0x1
    80001cee:	972e                	add	a4,a4,a1
    80001cf0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cf2:	6d38                	ld	a4,88(a0)
    80001cf4:	00000617          	auipc	a2,0x0
    80001cf8:	13860613          	addi	a2,a2,312 # 80001e2c <usertrap>
    80001cfc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001cfe:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001d00:	8612                	mv	a2,tp
    80001d02:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d04:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001d08:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001d0c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d10:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d14:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001d16:	6f18                	ld	a4,24(a4)
    80001d18:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d1c:	6928                	ld	a0,80(a0)
    80001d1e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d20:	00005717          	auipc	a4,0x5
    80001d24:	37c70713          	addi	a4,a4,892 # 8000709c <userret>
    80001d28:	8f15                	sub	a4,a4,a3
    80001d2a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d2c:	577d                	li	a4,-1
    80001d2e:	177e                	slli	a4,a4,0x3f
    80001d30:	8d59                	or	a0,a0,a4
    80001d32:	9782                	jalr	a5
}
    80001d34:	60a2                	ld	ra,8(sp)
    80001d36:	6402                	ld	s0,0(sp)
    80001d38:	0141                	addi	sp,sp,16
    80001d3a:	8082                	ret

0000000080001d3c <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001d3c:	1101                	addi	sp,sp,-32
    80001d3e:	ec06                	sd	ra,24(sp)
    80001d40:	e822                	sd	s0,16(sp)
    80001d42:	e426                	sd	s1,8(sp)
    80001d44:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d46:	0000f497          	auipc	s1,0xf
    80001d4a:	3aa48493          	addi	s1,s1,938 # 800110f0 <tickslock>
    80001d4e:	8526                	mv	a0,s1
    80001d50:	00004097          	auipc	ra,0x4
    80001d54:	6ec080e7          	jalr	1772(ra) # 8000643c <acquire>
  ticks++;
    80001d58:	00009517          	auipc	a0,0x9
    80001d5c:	53050513          	addi	a0,a0,1328 # 8000b288 <ticks>
    80001d60:	411c                	lw	a5,0(a0)
    80001d62:	2785                	addiw	a5,a5,1
    80001d64:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	8b2080e7          	jalr	-1870(ra) # 80001618 <wakeup>
  release(&tickslock);
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	780080e7          	jalr	1920(ra) # 800064f0 <release>
}
    80001d78:	60e2                	ld	ra,24(sp)
    80001d7a:	6442                	ld	s0,16(sp)
    80001d7c:	64a2                	ld	s1,8(sp)
    80001d7e:	6105                	addi	sp,sp,32
    80001d80:	8082                	ret

0000000080001d82 <devintr>:
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d82:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d86:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001d88:	0a07d163          	bgez	a5,80001e2a <devintr+0xa8>
int devintr() {
    80001d8c:	1101                	addi	sp,sp,-32
    80001d8e:	ec06                	sd	ra,24(sp)
    80001d90:	e822                	sd	s0,16(sp)
    80001d92:	1000                	addi	s0,sp,32
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001d94:	0ff7f713          	zext.b	a4,a5
    80001d98:	46a5                	li	a3,9
    80001d9a:	00d70c63          	beq	a4,a3,80001db2 <devintr+0x30>
  } else if (scause == 0x8000000000000001L) {
    80001d9e:	577d                	li	a4,-1
    80001da0:	177e                	slli	a4,a4,0x3f
    80001da2:	0705                	addi	a4,a4,1
    return 0;
    80001da4:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001da6:	06e78163          	beq	a5,a4,80001e08 <devintr+0x86>
  }
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret
    80001db2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001db4:	00003097          	auipc	ra,0x3
    80001db8:	5e8080e7          	jalr	1512(ra) # 8000539c <plic_claim>
    80001dbc:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001dbe:	47a9                	li	a5,10
    80001dc0:	00f50963          	beq	a0,a5,80001dd2 <devintr+0x50>
    } else if (irq == VIRTIO0_IRQ) {
    80001dc4:	4785                	li	a5,1
    80001dc6:	00f50b63          	beq	a0,a5,80001ddc <devintr+0x5a>
    return 1;
    80001dca:	4505                	li	a0,1
    } else if (irq) {
    80001dcc:	ec89                	bnez	s1,80001de6 <devintr+0x64>
    80001dce:	64a2                	ld	s1,8(sp)
    80001dd0:	bfe9                	j	80001daa <devintr+0x28>
      uartintr();
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	58a080e7          	jalr	1418(ra) # 8000635c <uartintr>
    if (irq) plic_complete(irq);
    80001dda:	a839                	j	80001df8 <devintr+0x76>
      virtio_disk_intr();
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	aea080e7          	jalr	-1302(ra) # 800058c6 <virtio_disk_intr>
    if (irq) plic_complete(irq);
    80001de4:	a811                	j	80001df8 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001de6:	85a6                	mv	a1,s1
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	4a850513          	addi	a0,a0,1192 # 80008290 <etext+0x290>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	11c080e7          	jalr	284(ra) # 80005f0c <printf>
    if (irq) plic_complete(irq);
    80001df8:	8526                	mv	a0,s1
    80001dfa:	00003097          	auipc	ra,0x3
    80001dfe:	5c6080e7          	jalr	1478(ra) # 800053c0 <plic_complete>
    return 1;
    80001e02:	4505                	li	a0,1
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	b755                	j	80001daa <devintr+0x28>
    if (cpuid() == 0) {
    80001e08:	fffff097          	auipc	ra,0xfffff
    80001e0c:	0d2080e7          	jalr	210(ra) # 80000eda <cpuid>
    80001e10:	c901                	beqz	a0,80001e20 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001e12:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e16:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001e18:	14479073          	csrw	sip,a5
    return 2;
    80001e1c:	4509                	li	a0,2
    80001e1e:	b771                	j	80001daa <devintr+0x28>
      clockintr();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	f1c080e7          	jalr	-228(ra) # 80001d3c <clockintr>
    80001e28:	b7ed                	j	80001e12 <devintr+0x90>
}
    80001e2a:	8082                	ret

0000000080001e2c <usertrap>:
void usertrap(void) {
    80001e2c:	1101                	addi	sp,sp,-32
    80001e2e:	ec06                	sd	ra,24(sp)
    80001e30:	e822                	sd	s0,16(sp)
    80001e32:	e426                	sd	s1,8(sp)
    80001e34:	e04a                	sd	s2,0(sp)
    80001e36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e38:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001e3c:	1007f793          	andi	a5,a5,256
    80001e40:	e3b1                	bnez	a5,80001e84 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e42:	00003797          	auipc	a5,0x3
    80001e46:	44e78793          	addi	a5,a5,1102 # 80005290 <kernelvec>
    80001e4a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	0b8080e7          	jalr	184(ra) # 80000f06 <myproc>
    80001e56:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e58:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e5a:	14102773          	csrr	a4,sepc
    80001e5e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e60:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001e64:	47a1                	li	a5,8
    80001e66:	02f70763          	beq	a4,a5,80001e94 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	f18080e7          	jalr	-232(ra) # 80001d82 <devintr>
    80001e72:	892a                	mv	s2,a0
    80001e74:	c151                	beqz	a0,80001ef8 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001e76:	8526                	mv	a0,s1
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	9e4080e7          	jalr	-1564(ra) # 8000185c <killed>
    80001e80:	c929                	beqz	a0,80001ed2 <usertrap+0xa6>
    80001e82:	a099                	j	80001ec8 <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	42c50513          	addi	a0,a0,1068 # 800082b0 <etext+0x2b0>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	036080e7          	jalr	54(ra) # 80005ec2 <panic>
    if (killed(p)) exit(-1);
    80001e94:	00000097          	auipc	ra,0x0
    80001e98:	9c8080e7          	jalr	-1592(ra) # 8000185c <killed>
    80001e9c:	e921                	bnez	a0,80001eec <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e9e:	6cb8                	ld	a4,88(s1)
    80001ea0:	6f1c                	ld	a5,24(a4)
    80001ea2:	0791                	addi	a5,a5,4
    80001ea4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ea6:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001eaa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001eae:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	2d4080e7          	jalr	724(ra) # 80002186 <syscall>
  if (killed(p)) exit(-1);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	9a0080e7          	jalr	-1632(ra) # 8000185c <killed>
    80001ec4:	c911                	beqz	a0,80001ed8 <usertrap+0xac>
    80001ec6:	4901                	li	s2,0
    80001ec8:	557d                	li	a0,-1
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	81e080e7          	jalr	-2018(ra) # 800016e8 <exit>
  if (which_dev == 2) yield();
    80001ed2:	4789                	li	a5,2
    80001ed4:	04f90f63          	beq	s2,a5,80001f32 <usertrap+0x106>
  usertrapret();
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	dce080e7          	jalr	-562(ra) # 80001ca6 <usertrapret>
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6902                	ld	s2,0(sp)
    80001ee8:	6105                	addi	sp,sp,32
    80001eea:	8082                	ret
    if (killed(p)) exit(-1);
    80001eec:	557d                	li	a0,-1
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	7fa080e7          	jalr	2042(ra) # 800016e8 <exit>
    80001ef6:	b765                	j	80001e9e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001ef8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001efc:	5890                	lw	a2,48(s1)
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	3d250513          	addi	a0,a0,978 # 800082d0 <etext+0x2d0>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	006080e7          	jalr	6(ra) # 80005f0c <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001f12:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	3ea50513          	addi	a0,a0,1002 # 80008300 <etext+0x300>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	fee080e7          	jalr	-18(ra) # 80005f0c <printf>
    setkilled(p);
    80001f26:	8526                	mv	a0,s1
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	908080e7          	jalr	-1784(ra) # 80001830 <setkilled>
    80001f30:	b769                	j	80001eba <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	646080e7          	jalr	1606(ra) # 80001578 <yield>
    80001f3a:	bf79                	j	80001ed8 <usertrap+0xac>

0000000080001f3c <kerneltrap>:
void kerneltrap() {
    80001f3c:	7179                	addi	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f52:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001f56:	1004f793          	andi	a5,s1,256
    80001f5a:	cb85                	beqz	a5,80001f8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f60:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001f62:	ef85                	bnez	a5,80001f9a <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	e1e080e7          	jalr	-482(ra) # 80001d82 <devintr>
    80001f6c:	cd1d                	beqz	a0,80001faa <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001f6e:	4789                	li	a5,2
    80001f70:	06f50a63          	beq	a0,a5,80001fe4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001f74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001f78:	10049073          	csrw	sstatus,s1
}
    80001f7c:	70a2                	ld	ra,40(sp)
    80001f7e:	7402                	ld	s0,32(sp)
    80001f80:	64e2                	ld	s1,24(sp)
    80001f82:	6942                	ld	s2,16(sp)
    80001f84:	69a2                	ld	s3,8(sp)
    80001f86:	6145                	addi	sp,sp,48
    80001f88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f8a:	00006517          	auipc	a0,0x6
    80001f8e:	39650513          	addi	a0,a0,918 # 80008320 <etext+0x320>
    80001f92:	00004097          	auipc	ra,0x4
    80001f96:	f30080e7          	jalr	-208(ra) # 80005ec2 <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001f9a:	00006517          	auipc	a0,0x6
    80001f9e:	3ae50513          	addi	a0,a0,942 # 80008348 <etext+0x348>
    80001fa2:	00004097          	auipc	ra,0x4
    80001fa6:	f20080e7          	jalr	-224(ra) # 80005ec2 <panic>
    printf("scause %p\n", scause);
    80001faa:	85ce                	mv	a1,s3
    80001fac:	00006517          	auipc	a0,0x6
    80001fb0:	3bc50513          	addi	a0,a0,956 # 80008368 <etext+0x368>
    80001fb4:	00004097          	auipc	ra,0x4
    80001fb8:	f58080e7          	jalr	-168(ra) # 80005f0c <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001fbc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001fc0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	3b450513          	addi	a0,a0,948 # 80008378 <etext+0x378>
    80001fcc:	00004097          	auipc	ra,0x4
    80001fd0:	f40080e7          	jalr	-192(ra) # 80005f0c <printf>
    panic("kerneltrap");
    80001fd4:	00006517          	auipc	a0,0x6
    80001fd8:	3bc50513          	addi	a0,a0,956 # 80008390 <etext+0x390>
    80001fdc:	00004097          	auipc	ra,0x4
    80001fe0:	ee6080e7          	jalr	-282(ra) # 80005ec2 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	f22080e7          	jalr	-222(ra) # 80000f06 <myproc>
    80001fec:	d541                	beqz	a0,80001f74 <kerneltrap+0x38>
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	f18080e7          	jalr	-232(ra) # 80000f06 <myproc>
    80001ff6:	4d18                	lw	a4,24(a0)
    80001ff8:	4791                	li	a5,4
    80001ffa:	f6f71de3          	bne	a4,a5,80001f74 <kerneltrap+0x38>
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	57a080e7          	jalr	1402(ra) # 80001578 <yield>
    80002006:	b7bd                	j	80001f74 <kerneltrap+0x38>

0000000080002008 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80002008:	1101                	addi	sp,sp,-32
    8000200a:	ec06                	sd	ra,24(sp)
    8000200c:	e822                	sd	s0,16(sp)
    8000200e:	e426                	sd	s1,8(sp)
    80002010:	1000                	addi	s0,sp,32
    80002012:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	ef2080e7          	jalr	-270(ra) # 80000f06 <myproc>
  switch (n) {
    8000201c:	4795                	li	a5,5
    8000201e:	0497e163          	bltu	a5,s1,80002060 <argraw+0x58>
    80002022:	048a                	slli	s1,s1,0x2
    80002024:	00006717          	auipc	a4,0x6
    80002028:	77c70713          	addi	a4,a4,1916 # 800087a0 <states.0+0x30>
    8000202c:	94ba                	add	s1,s1,a4
    8000202e:	409c                	lw	a5,0(s1)
    80002030:	97ba                	add	a5,a5,a4
    80002032:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80002034:	6d3c                	ld	a5,88(a0)
    80002036:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	64a2                	ld	s1,8(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret
      return p->trapframe->a1;
    80002042:	6d3c                	ld	a5,88(a0)
    80002044:	7fa8                	ld	a0,120(a5)
    80002046:	bfcd                	j	80002038 <argraw+0x30>
      return p->trapframe->a2;
    80002048:	6d3c                	ld	a5,88(a0)
    8000204a:	63c8                	ld	a0,128(a5)
    8000204c:	b7f5                	j	80002038 <argraw+0x30>
      return p->trapframe->a3;
    8000204e:	6d3c                	ld	a5,88(a0)
    80002050:	67c8                	ld	a0,136(a5)
    80002052:	b7dd                	j	80002038 <argraw+0x30>
      return p->trapframe->a4;
    80002054:	6d3c                	ld	a5,88(a0)
    80002056:	6bc8                	ld	a0,144(a5)
    80002058:	b7c5                	j	80002038 <argraw+0x30>
      return p->trapframe->a5;
    8000205a:	6d3c                	ld	a5,88(a0)
    8000205c:	6fc8                	ld	a0,152(a5)
    8000205e:	bfe9                	j	80002038 <argraw+0x30>
  panic("argraw");
    80002060:	00006517          	auipc	a0,0x6
    80002064:	34050513          	addi	a0,a0,832 # 800083a0 <etext+0x3a0>
    80002068:	00004097          	auipc	ra,0x4
    8000206c:	e5a080e7          	jalr	-422(ra) # 80005ec2 <panic>

0000000080002070 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	e426                	sd	s1,8(sp)
    80002078:	e04a                	sd	s2,0(sp)
    8000207a:	1000                	addi	s0,sp,32
    8000207c:	84aa                	mv	s1,a0
    8000207e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	e86080e7          	jalr	-378(ra) # 80000f06 <myproc>
  if (addr >= p->sz ||
    80002088:	653c                	ld	a5,72(a0)
    8000208a:	02f4f863          	bgeu	s1,a5,800020ba <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    8000208e:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002092:	02e7e663          	bltu	a5,a4,800020be <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80002096:	46a1                	li	a3,8
    80002098:	8626                	mv	a2,s1
    8000209a:	85ca                	mv	a1,s2
    8000209c:	6928                	ld	a0,80(a0)
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	b8c080e7          	jalr	-1140(ra) # 80000c2a <copyin>
    800020a6:	00a03533          	snez	a0,a0
    800020aa:	40a00533          	neg	a0,a0
}
    800020ae:	60e2                	ld	ra,24(sp)
    800020b0:	6442                	ld	s0,16(sp)
    800020b2:	64a2                	ld	s1,8(sp)
    800020b4:	6902                	ld	s2,0(sp)
    800020b6:	6105                	addi	sp,sp,32
    800020b8:	8082                	ret
    return -1;
    800020ba:	557d                	li	a0,-1
    800020bc:	bfcd                	j	800020ae <fetchaddr+0x3e>
    800020be:	557d                	li	a0,-1
    800020c0:	b7fd                	j	800020ae <fetchaddr+0x3e>

00000000800020c2 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    800020c2:	7179                	addi	sp,sp,-48
    800020c4:	f406                	sd	ra,40(sp)
    800020c6:	f022                	sd	s0,32(sp)
    800020c8:	ec26                	sd	s1,24(sp)
    800020ca:	e84a                	sd	s2,16(sp)
    800020cc:	e44e                	sd	s3,8(sp)
    800020ce:	1800                	addi	s0,sp,48
    800020d0:	892a                	mv	s2,a0
    800020d2:	84ae                	mv	s1,a1
    800020d4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	e30080e7          	jalr	-464(ra) # 80000f06 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800020de:	86ce                	mv	a3,s3
    800020e0:	864a                	mv	a2,s2
    800020e2:	85a6                	mv	a1,s1
    800020e4:	6928                	ld	a0,80(a0)
    800020e6:	fffff097          	auipc	ra,0xfffff
    800020ea:	bd2080e7          	jalr	-1070(ra) # 80000cb8 <copyinstr>
    800020ee:	00054e63          	bltz	a0,8000210a <fetchstr+0x48>
  return strlen(buf);
    800020f2:	8526                	mv	a0,s1
    800020f4:	ffffe097          	auipc	ra,0xffffe
    800020f8:	1fa080e7          	jalr	506(ra) # 800002ee <strlen>
}
    800020fc:	70a2                	ld	ra,40(sp)
    800020fe:	7402                	ld	s0,32(sp)
    80002100:	64e2                	ld	s1,24(sp)
    80002102:	6942                	ld	s2,16(sp)
    80002104:	69a2                	ld	s3,8(sp)
    80002106:	6145                	addi	sp,sp,48
    80002108:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000210a:	557d                	li	a0,-1
    8000210c:	bfc5                	j	800020fc <fetchstr+0x3a>

000000008000210e <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	1000                	addi	s0,sp,32
    80002118:	84ae                	mv	s1,a1
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	eee080e7          	jalr	-274(ra) # 80002008 <argraw>
    80002122:	c088                	sw	a0,0(s1)
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	64a2                	ld	s1,8(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    8000212e:	1101                	addi	sp,sp,-32
    80002130:	ec06                	sd	ra,24(sp)
    80002132:	e822                	sd	s0,16(sp)
    80002134:	e426                	sd	s1,8(sp)
    80002136:	1000                	addi	s0,sp,32
    80002138:	84ae                	mv	s1,a1
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	ece080e7          	jalr	-306(ra) # 80002008 <argraw>
    80002142:	e088                	sd	a0,0(s1)
    80002144:	60e2                	ld	ra,24(sp)
    80002146:	6442                	ld	s0,16(sp)
    80002148:	64a2                	ld	s1,8(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret

000000008000214e <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    8000214e:	7179                	addi	sp,sp,-48
    80002150:	f406                	sd	ra,40(sp)
    80002152:	f022                	sd	s0,32(sp)
    80002154:	ec26                	sd	s1,24(sp)
    80002156:	e84a                	sd	s2,16(sp)
    80002158:	1800                	addi	s0,sp,48
    8000215a:	84ae                	mv	s1,a1
    8000215c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000215e:	fd840593          	addi	a1,s0,-40
    80002162:	00000097          	auipc	ra,0x0
    80002166:	fcc080e7          	jalr	-52(ra) # 8000212e <argaddr>
  return fetchstr(addr, buf, max);
    8000216a:	864a                	mv	a2,s2
    8000216c:	85a6                	mv	a1,s1
    8000216e:	fd843503          	ld	a0,-40(s0)
    80002172:	00000097          	auipc	ra,0x0
    80002176:	f50080e7          	jalr	-176(ra) # 800020c2 <fetchstr>
}
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	64e2                	ld	s1,24(sp)
    80002180:	6942                	ld	s2,16(sp)
    80002182:	6145                	addi	sp,sp,48
    80002184:	8082                	ret

0000000080002186 <syscall>:
    [SYS_open] = sys_open,     [SYS_write] = sys_write,
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_reg] = sys_reg};

void syscall(void) {
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	e04a                	sd	s2,0(sp)
    80002190:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	d74080e7          	jalr	-652(ra) # 80000f06 <myproc>
    8000219a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000219c:	05853903          	ld	s2,88(a0)
    800021a0:	0a893783          	ld	a5,168(s2)
    800021a4:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a8:	37fd                	addiw	a5,a5,-1
    800021aa:	4755                	li	a4,21
    800021ac:	00f76f63          	bltu	a4,a5,800021ca <syscall+0x44>
    800021b0:	00369713          	slli	a4,a3,0x3
    800021b4:	00006797          	auipc	a5,0x6
    800021b8:	60478793          	addi	a5,a5,1540 # 800087b8 <syscalls>
    800021bc:	97ba                	add	a5,a5,a4
    800021be:	639c                	ld	a5,0(a5)
    800021c0:	c789                	beqz	a5,800021ca <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021c2:	9782                	jalr	a5
    800021c4:	06a93823          	sd	a0,112(s2)
    800021c8:	a839                	j	800021e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800021ca:	15848613          	addi	a2,s1,344
    800021ce:	588c                	lw	a1,48(s1)
    800021d0:	00006517          	auipc	a0,0x6
    800021d4:	1d850513          	addi	a0,a0,472 # 800083a8 <etext+0x3a8>
    800021d8:	00004097          	auipc	ra,0x4
    800021dc:	d34080e7          	jalr	-716(ra) # 80005f0c <printf>
    p->trapframe->a0 = -1;
    800021e0:	6cbc                	ld	a5,88(s1)
    800021e2:	577d                	li	a4,-1
    800021e4:	fbb8                	sd	a4,112(a5)
  }
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6902                	ld	s2,0(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021fa:	fec40593          	addi	a1,s0,-20
    800021fe:	4501                	li	a0,0
    80002200:	00000097          	auipc	ra,0x0
    80002204:	f0e080e7          	jalr	-242(ra) # 8000210e <argint>
  exit(n);
    80002208:	fec42503          	lw	a0,-20(s0)
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	4dc080e7          	jalr	1244(ra) # 800016e8 <exit>
  return 0;  // not reached
}
    80002214:	4501                	li	a0,0
    80002216:	60e2                	ld	ra,24(sp)
    80002218:	6442                	ld	s0,16(sp)
    8000221a:	6105                	addi	sp,sp,32
    8000221c:	8082                	ret

000000008000221e <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000221e:	1141                	addi	sp,sp,-16
    80002220:	e406                	sd	ra,8(sp)
    80002222:	e022                	sd	s0,0(sp)
    80002224:	0800                	addi	s0,sp,16
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	ce0080e7          	jalr	-800(ra) # 80000f06 <myproc>
    8000222e:	5908                	lw	a0,48(a0)
    80002230:	60a2                	ld	ra,8(sp)
    80002232:	6402                	ld	s0,0(sp)
    80002234:	0141                	addi	sp,sp,16
    80002236:	8082                	ret

0000000080002238 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002238:	1141                	addi	sp,sp,-16
    8000223a:	e406                	sd	ra,8(sp)
    8000223c:	e022                	sd	s0,0(sp)
    8000223e:	0800                	addi	s0,sp,16
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	080080e7          	jalr	128(ra) # 800012c0 <fork>
    80002248:	60a2                	ld	ra,8(sp)
    8000224a:	6402                	ld	s0,0(sp)
    8000224c:	0141                	addi	sp,sp,16
    8000224e:	8082                	ret

0000000080002250 <sys_wait>:

uint64 sys_wait(void) {
    80002250:	1101                	addi	sp,sp,-32
    80002252:	ec06                	sd	ra,24(sp)
    80002254:	e822                	sd	s0,16(sp)
    80002256:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002258:	fe840593          	addi	a1,s0,-24
    8000225c:	4501                	li	a0,0
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	ed0080e7          	jalr	-304(ra) # 8000212e <argaddr>
  return wait(p);
    80002266:	fe843503          	ld	a0,-24(s0)
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	624080e7          	jalr	1572(ra) # 8000188e <wait>
}
    80002272:	60e2                	ld	ra,24(sp)
    80002274:	6442                	ld	s0,16(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <sys_sbrk>:

uint64 sys_sbrk(void) {
    8000227a:	7179                	addi	sp,sp,-48
    8000227c:	f406                	sd	ra,40(sp)
    8000227e:	f022                	sd	s0,32(sp)
    80002280:	ec26                	sd	s1,24(sp)
    80002282:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002284:	fdc40593          	addi	a1,s0,-36
    80002288:	4501                	li	a0,0
    8000228a:	00000097          	auipc	ra,0x0
    8000228e:	e84080e7          	jalr	-380(ra) # 8000210e <argint>
  addr = myproc()->sz;
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	c74080e7          	jalr	-908(ra) # 80000f06 <myproc>
    8000229a:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    8000229c:	fdc42503          	lw	a0,-36(s0)
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	fc4080e7          	jalr	-60(ra) # 80001264 <growproc>
    800022a8:	00054863          	bltz	a0,800022b8 <sys_sbrk+0x3e>
  return addr;
}
    800022ac:	8526                	mv	a0,s1
    800022ae:	70a2                	ld	ra,40(sp)
    800022b0:	7402                	ld	s0,32(sp)
    800022b2:	64e2                	ld	s1,24(sp)
    800022b4:	6145                	addi	sp,sp,48
    800022b6:	8082                	ret
  if (growproc(n) < 0) return -1;
    800022b8:	54fd                	li	s1,-1
    800022ba:	bfcd                	j	800022ac <sys_sbrk+0x32>

00000000800022bc <sys_sleep>:

uint64 sys_sleep(void) {
    800022bc:	7139                	addi	sp,sp,-64
    800022be:	fc06                	sd	ra,56(sp)
    800022c0:	f822                	sd	s0,48(sp)
    800022c2:	f04a                	sd	s2,32(sp)
    800022c4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800022c6:	fcc40593          	addi	a1,s0,-52
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	e42080e7          	jalr	-446(ra) # 8000210e <argint>
  if (n < 0) n = 0;
    800022d4:	fcc42783          	lw	a5,-52(s0)
    800022d8:	0807c163          	bltz	a5,8000235a <sys_sleep+0x9e>
  acquire(&tickslock);
    800022dc:	0000f517          	auipc	a0,0xf
    800022e0:	e1450513          	addi	a0,a0,-492 # 800110f0 <tickslock>
    800022e4:	00004097          	auipc	ra,0x4
    800022e8:	158080e7          	jalr	344(ra) # 8000643c <acquire>
  ticks0 = ticks;
    800022ec:	00009917          	auipc	s2,0x9
    800022f0:	f9c92903          	lw	s2,-100(s2) # 8000b288 <ticks>
  while (ticks - ticks0 < n) {
    800022f4:	fcc42783          	lw	a5,-52(s0)
    800022f8:	c3b9                	beqz	a5,8000233e <sys_sleep+0x82>
    800022fa:	f426                	sd	s1,40(sp)
    800022fc:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022fe:	0000f997          	auipc	s3,0xf
    80002302:	df298993          	addi	s3,s3,-526 # 800110f0 <tickslock>
    80002306:	00009497          	auipc	s1,0x9
    8000230a:	f8248493          	addi	s1,s1,-126 # 8000b288 <ticks>
    if (killed(myproc())) {
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	bf8080e7          	jalr	-1032(ra) # 80000f06 <myproc>
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	546080e7          	jalr	1350(ra) # 8000185c <killed>
    8000231e:	e129                	bnez	a0,80002360 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002320:	85ce                	mv	a1,s3
    80002322:	8526                	mv	a0,s1
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	290080e7          	jalr	656(ra) # 800015b4 <sleep>
  while (ticks - ticks0 < n) {
    8000232c:	409c                	lw	a5,0(s1)
    8000232e:	412787bb          	subw	a5,a5,s2
    80002332:	fcc42703          	lw	a4,-52(s0)
    80002336:	fce7ece3          	bltu	a5,a4,8000230e <sys_sleep+0x52>
    8000233a:	74a2                	ld	s1,40(sp)
    8000233c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000233e:	0000f517          	auipc	a0,0xf
    80002342:	db250513          	addi	a0,a0,-590 # 800110f0 <tickslock>
    80002346:	00004097          	auipc	ra,0x4
    8000234a:	1aa080e7          	jalr	426(ra) # 800064f0 <release>
  return 0;
    8000234e:	4501                	li	a0,0
}
    80002350:	70e2                	ld	ra,56(sp)
    80002352:	7442                	ld	s0,48(sp)
    80002354:	7902                	ld	s2,32(sp)
    80002356:	6121                	addi	sp,sp,64
    80002358:	8082                	ret
  if (n < 0) n = 0;
    8000235a:	fc042623          	sw	zero,-52(s0)
    8000235e:	bfbd                	j	800022dc <sys_sleep+0x20>
      release(&tickslock);
    80002360:	0000f517          	auipc	a0,0xf
    80002364:	d9050513          	addi	a0,a0,-624 # 800110f0 <tickslock>
    80002368:	00004097          	auipc	ra,0x4
    8000236c:	188080e7          	jalr	392(ra) # 800064f0 <release>
      return -1;
    80002370:	557d                	li	a0,-1
    80002372:	74a2                	ld	s1,40(sp)
    80002374:	69e2                	ld	s3,24(sp)
    80002376:	bfe9                	j	80002350 <sys_sleep+0x94>

0000000080002378 <sys_kill>:

uint64 sys_kill(void) {
    80002378:	1101                	addi	sp,sp,-32
    8000237a:	ec06                	sd	ra,24(sp)
    8000237c:	e822                	sd	s0,16(sp)
    8000237e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002380:	fec40593          	addi	a1,s0,-20
    80002384:	4501                	li	a0,0
    80002386:	00000097          	auipc	ra,0x0
    8000238a:	d88080e7          	jalr	-632(ra) # 8000210e <argint>
  return kill(pid);
    8000238e:	fec42503          	lw	a0,-20(s0)
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	42c080e7          	jalr	1068(ra) # 800017be <kill>
}
    8000239a:	60e2                	ld	ra,24(sp)
    8000239c:	6442                	ld	s0,16(sp)
    8000239e:	6105                	addi	sp,sp,32
    800023a0:	8082                	ret

00000000800023a2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800023a2:	1101                	addi	sp,sp,-32
    800023a4:	ec06                	sd	ra,24(sp)
    800023a6:	e822                	sd	s0,16(sp)
    800023a8:	e426                	sd	s1,8(sp)
    800023aa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023ac:	0000f517          	auipc	a0,0xf
    800023b0:	d4450513          	addi	a0,a0,-700 # 800110f0 <tickslock>
    800023b4:	00004097          	auipc	ra,0x4
    800023b8:	088080e7          	jalr	136(ra) # 8000643c <acquire>
  xticks = ticks;
    800023bc:	00009497          	auipc	s1,0x9
    800023c0:	ecc4a483          	lw	s1,-308(s1) # 8000b288 <ticks>
  release(&tickslock);
    800023c4:	0000f517          	auipc	a0,0xf
    800023c8:	d2c50513          	addi	a0,a0,-724 # 800110f0 <tickslock>
    800023cc:	00004097          	auipc	ra,0x4
    800023d0:	124080e7          	jalr	292(ra) # 800064f0 <release>
  return xticks;
}
    800023d4:	02049513          	slli	a0,s1,0x20
    800023d8:	9101                	srli	a0,a0,0x20
    800023da:	60e2                	ld	ra,24(sp)
    800023dc:	6442                	ld	s0,16(sp)
    800023de:	64a2                	ld	s1,8(sp)
    800023e0:	6105                	addi	sp,sp,32
    800023e2:	8082                	ret

00000000800023e4 <sys_reg>:

uint64 sys_reg(void) {
    800023e4:	1101                	addi	sp,sp,-32
    800023e6:	ec06                	sd	ra,24(sp)
    800023e8:	e822                	sd	s0,16(sp)
    800023ea:	1000                	addi	s0,sp,32
  int pid;
  argint(0, &pid);
    800023ec:	fec40593          	addi	a1,s0,-20
    800023f0:	4501                	li	a0,0
    800023f2:	00000097          	auipc	ra,0x0
    800023f6:	d1c080e7          	jalr	-740(ra) # 8000210e <argint>
  int register_num;
  argint(1, &register_num);
    800023fa:	fe840593          	addi	a1,s0,-24
    800023fe:	4505                	li	a0,1
    80002400:	00000097          	auipc	ra,0x0
    80002404:	d0e080e7          	jalr	-754(ra) # 8000210e <argint>
  uint64 return_value;
  argaddr(2, &return_value);
    80002408:	fe040593          	addi	a1,s0,-32
    8000240c:	4509                	li	a0,2
    8000240e:	00000097          	auipc	ra,0x0
    80002412:	d20080e7          	jalr	-736(ra) # 8000212e <argaddr>
  return reg(pid, register_num, &return_value);
    80002416:	fe040613          	addi	a2,s0,-32
    8000241a:	fe842583          	lw	a1,-24(s0)
    8000241e:	fec42503          	lw	a0,-20(s0)
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	6f6080e7          	jalr	1782(ra) # 80001b18 <reg>
}
    8000242a:	60e2                	ld	ra,24(sp)
    8000242c:	6442                	ld	s0,16(sp)
    8000242e:	6105                	addi	sp,sp,32
    80002430:	8082                	ret

0000000080002432 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    80002432:	7179                	addi	sp,sp,-48
    80002434:	f406                	sd	ra,40(sp)
    80002436:	f022                	sd	s0,32(sp)
    80002438:	ec26                	sd	s1,24(sp)
    8000243a:	e84a                	sd	s2,16(sp)
    8000243c:	e44e                	sd	s3,8(sp)
    8000243e:	e052                	sd	s4,0(sp)
    80002440:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002442:	00006597          	auipc	a1,0x6
    80002446:	f8658593          	addi	a1,a1,-122 # 800083c8 <etext+0x3c8>
    8000244a:	0000f517          	auipc	a0,0xf
    8000244e:	cbe50513          	addi	a0,a0,-834 # 80011108 <bcache>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	f5a080e7          	jalr	-166(ra) # 800063ac <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000245a:	00017797          	auipc	a5,0x17
    8000245e:	cae78793          	addi	a5,a5,-850 # 80019108 <bcache+0x8000>
    80002462:	00017717          	auipc	a4,0x17
    80002466:	f0e70713          	addi	a4,a4,-242 # 80019370 <bcache+0x8268>
    8000246a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000246e:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002472:	0000f497          	auipc	s1,0xf
    80002476:	cae48493          	addi	s1,s1,-850 # 80011120 <bcache+0x18>
    b->next = bcache.head.next;
    8000247a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000247c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000247e:	00006a17          	auipc	s4,0x6
    80002482:	f52a0a13          	addi	s4,s4,-174 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    80002486:	2b893783          	ld	a5,696(s2)
    8000248a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000248c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002490:	85d2                	mv	a1,s4
    80002492:	01048513          	addi	a0,s1,16
    80002496:	00001097          	auipc	ra,0x1
    8000249a:	4e8080e7          	jalr	1256(ra) # 8000397e <initsleeplock>
    bcache.head.next->prev = b;
    8000249e:	2b893783          	ld	a5,696(s2)
    800024a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024a4:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800024a8:	45848493          	addi	s1,s1,1112
    800024ac:	fd349de3          	bne	s1,s3,80002486 <binit+0x54>
  }
}
    800024b0:	70a2                	ld	ra,40(sp)
    800024b2:	7402                	ld	s0,32(sp)
    800024b4:	64e2                	ld	s1,24(sp)
    800024b6:	6942                	ld	s2,16(sp)
    800024b8:	69a2                	ld	s3,8(sp)
    800024ba:	6a02                	ld	s4,0(sp)
    800024bc:	6145                	addi	sp,sp,48
    800024be:	8082                	ret

00000000800024c0 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    800024c0:	7179                	addi	sp,sp,-48
    800024c2:	f406                	sd	ra,40(sp)
    800024c4:	f022                	sd	s0,32(sp)
    800024c6:	ec26                	sd	s1,24(sp)
    800024c8:	e84a                	sd	s2,16(sp)
    800024ca:	e44e                	sd	s3,8(sp)
    800024cc:	1800                	addi	s0,sp,48
    800024ce:	892a                	mv	s2,a0
    800024d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024d2:	0000f517          	auipc	a0,0xf
    800024d6:	c3650513          	addi	a0,a0,-970 # 80011108 <bcache>
    800024da:	00004097          	auipc	ra,0x4
    800024de:	f62080e7          	jalr	-158(ra) # 8000643c <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    800024e2:	00017497          	auipc	s1,0x17
    800024e6:	ede4b483          	ld	s1,-290(s1) # 800193c0 <bcache+0x82b8>
    800024ea:	00017797          	auipc	a5,0x17
    800024ee:	e8678793          	addi	a5,a5,-378 # 80019370 <bcache+0x8268>
    800024f2:	02f48f63          	beq	s1,a5,80002530 <bread+0x70>
    800024f6:	873e                	mv	a4,a5
    800024f8:	a021                	j	80002500 <bread+0x40>
    800024fa:	68a4                	ld	s1,80(s1)
    800024fc:	02e48a63          	beq	s1,a4,80002530 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002500:	449c                	lw	a5,8(s1)
    80002502:	ff279ce3          	bne	a5,s2,800024fa <bread+0x3a>
    80002506:	44dc                	lw	a5,12(s1)
    80002508:	ff3799e3          	bne	a5,s3,800024fa <bread+0x3a>
      b->refcnt++;
    8000250c:	40bc                	lw	a5,64(s1)
    8000250e:	2785                	addiw	a5,a5,1
    80002510:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002512:	0000f517          	auipc	a0,0xf
    80002516:	bf650513          	addi	a0,a0,-1034 # 80011108 <bcache>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	fd6080e7          	jalr	-42(ra) # 800064f0 <release>
      acquiresleep(&b->lock);
    80002522:	01048513          	addi	a0,s1,16
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	492080e7          	jalr	1170(ra) # 800039b8 <acquiresleep>
      return b;
    8000252e:	a8b9                	j	8000258c <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002530:	00017497          	auipc	s1,0x17
    80002534:	e884b483          	ld	s1,-376(s1) # 800193b8 <bcache+0x82b0>
    80002538:	00017797          	auipc	a5,0x17
    8000253c:	e3878793          	addi	a5,a5,-456 # 80019370 <bcache+0x8268>
    80002540:	00f48863          	beq	s1,a5,80002550 <bread+0x90>
    80002544:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002546:	40bc                	lw	a5,64(s1)
    80002548:	cf81                	beqz	a5,80002560 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000254a:	64a4                	ld	s1,72(s1)
    8000254c:	fee49de3          	bne	s1,a4,80002546 <bread+0x86>
  panic("bget: no buffers");
    80002550:	00006517          	auipc	a0,0x6
    80002554:	e8850513          	addi	a0,a0,-376 # 800083d8 <etext+0x3d8>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	96a080e7          	jalr	-1686(ra) # 80005ec2 <panic>
      b->dev = dev;
    80002560:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002564:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002568:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000256c:	4785                	li	a5,1
    8000256e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002570:	0000f517          	auipc	a0,0xf
    80002574:	b9850513          	addi	a0,a0,-1128 # 80011108 <bcache>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	f78080e7          	jalr	-136(ra) # 800064f0 <release>
      acquiresleep(&b->lock);
    80002580:	01048513          	addi	a0,s1,16
    80002584:	00001097          	auipc	ra,0x1
    80002588:	434080e7          	jalr	1076(ra) # 800039b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    8000258c:	409c                	lw	a5,0(s1)
    8000258e:	cb89                	beqz	a5,800025a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002590:	8526                	mv	a0,s1
    80002592:	70a2                	ld	ra,40(sp)
    80002594:	7402                	ld	s0,32(sp)
    80002596:	64e2                	ld	s1,24(sp)
    80002598:	6942                	ld	s2,16(sp)
    8000259a:	69a2                	ld	s3,8(sp)
    8000259c:	6145                	addi	sp,sp,48
    8000259e:	8082                	ret
    virtio_disk_rw(b, 0);
    800025a0:	4581                	li	a1,0
    800025a2:	8526                	mv	a0,s1
    800025a4:	00003097          	auipc	ra,0x3
    800025a8:	0f4080e7          	jalr	244(ra) # 80005698 <virtio_disk_rw>
    b->valid = 1;
    800025ac:	4785                	li	a5,1
    800025ae:	c09c                	sw	a5,0(s1)
  return b;
    800025b0:	b7c5                	j	80002590 <bread+0xd0>

00000000800025b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	1000                	addi	s0,sp,32
    800025bc:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800025be:	0541                	addi	a0,a0,16
    800025c0:	00001097          	auipc	ra,0x1
    800025c4:	492080e7          	jalr	1170(ra) # 80003a52 <holdingsleep>
    800025c8:	cd01                	beqz	a0,800025e0 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    800025ca:	4585                	li	a1,1
    800025cc:	8526                	mv	a0,s1
    800025ce:	00003097          	auipc	ra,0x3
    800025d2:	0ca080e7          	jalr	202(ra) # 80005698 <virtio_disk_rw>
}
    800025d6:	60e2                	ld	ra,24(sp)
    800025d8:	6442                	ld	s0,16(sp)
    800025da:	64a2                	ld	s1,8(sp)
    800025dc:	6105                	addi	sp,sp,32
    800025de:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800025e0:	00006517          	auipc	a0,0x6
    800025e4:	e1050513          	addi	a0,a0,-496 # 800083f0 <etext+0x3f0>
    800025e8:	00004097          	auipc	ra,0x4
    800025ec:	8da080e7          	jalr	-1830(ra) # 80005ec2 <panic>

00000000800025f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    800025f0:	1101                	addi	sp,sp,-32
    800025f2:	ec06                	sd	ra,24(sp)
    800025f4:	e822                	sd	s0,16(sp)
    800025f6:	e426                	sd	s1,8(sp)
    800025f8:	e04a                	sd	s2,0(sp)
    800025fa:	1000                	addi	s0,sp,32
    800025fc:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    800025fe:	01050913          	addi	s2,a0,16
    80002602:	854a                	mv	a0,s2
    80002604:	00001097          	auipc	ra,0x1
    80002608:	44e080e7          	jalr	1102(ra) # 80003a52 <holdingsleep>
    8000260c:	c925                	beqz	a0,8000267c <brelse+0x8c>

  releasesleep(&b->lock);
    8000260e:	854a                	mv	a0,s2
    80002610:	00001097          	auipc	ra,0x1
    80002614:	3fe080e7          	jalr	1022(ra) # 80003a0e <releasesleep>

  acquire(&bcache.lock);
    80002618:	0000f517          	auipc	a0,0xf
    8000261c:	af050513          	addi	a0,a0,-1296 # 80011108 <bcache>
    80002620:	00004097          	auipc	ra,0x4
    80002624:	e1c080e7          	jalr	-484(ra) # 8000643c <acquire>
  b->refcnt--;
    80002628:	40bc                	lw	a5,64(s1)
    8000262a:	37fd                	addiw	a5,a5,-1
    8000262c:	0007871b          	sext.w	a4,a5
    80002630:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002632:	e71d                	bnez	a4,80002660 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002634:	68b8                	ld	a4,80(s1)
    80002636:	64bc                	ld	a5,72(s1)
    80002638:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000263a:	68b8                	ld	a4,80(s1)
    8000263c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000263e:	00017797          	auipc	a5,0x17
    80002642:	aca78793          	addi	a5,a5,-1334 # 80019108 <bcache+0x8000>
    80002646:	2b87b703          	ld	a4,696(a5)
    8000264a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000264c:	00017717          	auipc	a4,0x17
    80002650:	d2470713          	addi	a4,a4,-732 # 80019370 <bcache+0x8268>
    80002654:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002656:	2b87b703          	ld	a4,696(a5)
    8000265a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000265c:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002660:	0000f517          	auipc	a0,0xf
    80002664:	aa850513          	addi	a0,a0,-1368 # 80011108 <bcache>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	e88080e7          	jalr	-376(ra) # 800064f0 <release>
}
    80002670:	60e2                	ld	ra,24(sp)
    80002672:	6442                	ld	s0,16(sp)
    80002674:	64a2                	ld	s1,8(sp)
    80002676:	6902                	ld	s2,0(sp)
    80002678:	6105                	addi	sp,sp,32
    8000267a:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    8000267c:	00006517          	auipc	a0,0x6
    80002680:	d7c50513          	addi	a0,a0,-644 # 800083f8 <etext+0x3f8>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	83e080e7          	jalr	-1986(ra) # 80005ec2 <panic>

000000008000268c <bpin>:

void bpin(struct buf *b) {
    8000268c:	1101                	addi	sp,sp,-32
    8000268e:	ec06                	sd	ra,24(sp)
    80002690:	e822                	sd	s0,16(sp)
    80002692:	e426                	sd	s1,8(sp)
    80002694:	1000                	addi	s0,sp,32
    80002696:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002698:	0000f517          	auipc	a0,0xf
    8000269c:	a7050513          	addi	a0,a0,-1424 # 80011108 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	d9c080e7          	jalr	-612(ra) # 8000643c <acquire>
  b->refcnt++;
    800026a8:	40bc                	lw	a5,64(s1)
    800026aa:	2785                	addiw	a5,a5,1
    800026ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ae:	0000f517          	auipc	a0,0xf
    800026b2:	a5a50513          	addi	a0,a0,-1446 # 80011108 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	e3a080e7          	jalr	-454(ra) # 800064f0 <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <bunpin>:

void bunpin(struct buf *b) {
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	1000                	addi	s0,sp,32
    800026d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026d4:	0000f517          	auipc	a0,0xf
    800026d8:	a3450513          	addi	a0,a0,-1484 # 80011108 <bcache>
    800026dc:	00004097          	auipc	ra,0x4
    800026e0:	d60080e7          	jalr	-672(ra) # 8000643c <acquire>
  b->refcnt--;
    800026e4:	40bc                	lw	a5,64(s1)
    800026e6:	37fd                	addiw	a5,a5,-1
    800026e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ea:	0000f517          	auipc	a0,0xf
    800026ee:	a1e50513          	addi	a0,a0,-1506 # 80011108 <bcache>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	dfe080e7          	jalr	-514(ra) # 800064f0 <release>
}
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6105                	addi	sp,sp,32
    80002702:	8082                	ret

0000000080002704 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80002704:	1101                	addi	sp,sp,-32
    80002706:	ec06                	sd	ra,24(sp)
    80002708:	e822                	sd	s0,16(sp)
    8000270a:	e426                	sd	s1,8(sp)
    8000270c:	e04a                	sd	s2,0(sp)
    8000270e:	1000                	addi	s0,sp,32
    80002710:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002712:	00d5d59b          	srliw	a1,a1,0xd
    80002716:	00017797          	auipc	a5,0x17
    8000271a:	0ce7a783          	lw	a5,206(a5) # 800197e4 <sb+0x1c>
    8000271e:	9dbd                	addw	a1,a1,a5
    80002720:	00000097          	auipc	ra,0x0
    80002724:	da0080e7          	jalr	-608(ra) # 800024c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002728:	0074f713          	andi	a4,s1,7
    8000272c:	4785                	li	a5,1
    8000272e:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002732:	14ce                	slli	s1,s1,0x33
    80002734:	90d9                	srli	s1,s1,0x36
    80002736:	00950733          	add	a4,a0,s1
    8000273a:	05874703          	lbu	a4,88(a4)
    8000273e:	00e7f6b3          	and	a3,a5,a4
    80002742:	c69d                	beqz	a3,80002770 <bfree+0x6c>
    80002744:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002746:	94aa                	add	s1,s1,a0
    80002748:	fff7c793          	not	a5,a5
    8000274c:	8f7d                	and	a4,a4,a5
    8000274e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002752:	00001097          	auipc	ra,0x1
    80002756:	148080e7          	jalr	328(ra) # 8000389a <log_write>
  brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	e94080e7          	jalr	-364(ra) # 800025f0 <brelse>
}
    80002764:	60e2                	ld	ra,24(sp)
    80002766:	6442                	ld	s0,16(sp)
    80002768:	64a2                	ld	s1,8(sp)
    8000276a:	6902                	ld	s2,0(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002770:	00006517          	auipc	a0,0x6
    80002774:	c9050513          	addi	a0,a0,-880 # 80008400 <etext+0x400>
    80002778:	00003097          	auipc	ra,0x3
    8000277c:	74a080e7          	jalr	1866(ra) # 80005ec2 <panic>

0000000080002780 <balloc>:
static uint balloc(uint dev) {
    80002780:	711d                	addi	sp,sp,-96
    80002782:	ec86                	sd	ra,88(sp)
    80002784:	e8a2                	sd	s0,80(sp)
    80002786:	e4a6                	sd	s1,72(sp)
    80002788:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    8000278a:	00017797          	auipc	a5,0x17
    8000278e:	0427a783          	lw	a5,66(a5) # 800197cc <sb+0x4>
    80002792:	10078f63          	beqz	a5,800028b0 <balloc+0x130>
    80002796:	e0ca                	sd	s2,64(sp)
    80002798:	fc4e                	sd	s3,56(sp)
    8000279a:	f852                	sd	s4,48(sp)
    8000279c:	f456                	sd	s5,40(sp)
    8000279e:	f05a                	sd	s6,32(sp)
    800027a0:	ec5e                	sd	s7,24(sp)
    800027a2:	e862                	sd	s8,16(sp)
    800027a4:	e466                	sd	s9,8(sp)
    800027a6:	8baa                	mv	s7,a0
    800027a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027aa:	00017b17          	auipc	s6,0x17
    800027ae:	01eb0b13          	addi	s6,s6,30 # 800197c8 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027b4:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027b6:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800027b8:	6c89                	lui	s9,0x2
    800027ba:	a061                	j	80002842 <balloc+0xc2>
        bp->data[bi / 8] |= m;            // Mark block in use.
    800027bc:	97ca                	add	a5,a5,s2
    800027be:	8e55                	or	a2,a2,a3
    800027c0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00001097          	auipc	ra,0x1
    800027ca:	0d4080e7          	jalr	212(ra) # 8000389a <log_write>
        brelse(bp);
    800027ce:	854a                	mv	a0,s2
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	e20080e7          	jalr	-480(ra) # 800025f0 <brelse>
  bp = bread(dev, bno);
    800027d8:	85a6                	mv	a1,s1
    800027da:	855e                	mv	a0,s7
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	ce4080e7          	jalr	-796(ra) # 800024c0 <bread>
    800027e4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027e6:	40000613          	li	a2,1024
    800027ea:	4581                	li	a1,0
    800027ec:	05850513          	addi	a0,a0,88
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	98a080e7          	jalr	-1654(ra) # 8000017a <memset>
  log_write(bp);
    800027f8:	854a                	mv	a0,s2
    800027fa:	00001097          	auipc	ra,0x1
    800027fe:	0a0080e7          	jalr	160(ra) # 8000389a <log_write>
  brelse(bp);
    80002802:	854a                	mv	a0,s2
    80002804:	00000097          	auipc	ra,0x0
    80002808:	dec080e7          	jalr	-532(ra) # 800025f0 <brelse>
}
    8000280c:	6906                	ld	s2,64(sp)
    8000280e:	79e2                	ld	s3,56(sp)
    80002810:	7a42                	ld	s4,48(sp)
    80002812:	7aa2                	ld	s5,40(sp)
    80002814:	7b02                	ld	s6,32(sp)
    80002816:	6be2                	ld	s7,24(sp)
    80002818:	6c42                	ld	s8,16(sp)
    8000281a:	6ca2                	ld	s9,8(sp)
}
    8000281c:	8526                	mv	a0,s1
    8000281e:	60e6                	ld	ra,88(sp)
    80002820:	6446                	ld	s0,80(sp)
    80002822:	64a6                	ld	s1,72(sp)
    80002824:	6125                	addi	sp,sp,96
    80002826:	8082                	ret
    brelse(bp);
    80002828:	854a                	mv	a0,s2
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	dc6080e7          	jalr	-570(ra) # 800025f0 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002832:	015c87bb          	addw	a5,s9,s5
    80002836:	00078a9b          	sext.w	s5,a5
    8000283a:	004b2703          	lw	a4,4(s6)
    8000283e:	06eaf163          	bgeu	s5,a4,800028a0 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002842:	41fad79b          	sraiw	a5,s5,0x1f
    80002846:	0137d79b          	srliw	a5,a5,0x13
    8000284a:	015787bb          	addw	a5,a5,s5
    8000284e:	40d7d79b          	sraiw	a5,a5,0xd
    80002852:	01cb2583          	lw	a1,28(s6)
    80002856:	9dbd                	addw	a1,a1,a5
    80002858:	855e                	mv	a0,s7
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	c66080e7          	jalr	-922(ra) # 800024c0 <bread>
    80002862:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002864:	004b2503          	lw	a0,4(s6)
    80002868:	000a849b          	sext.w	s1,s5
    8000286c:	8762                	mv	a4,s8
    8000286e:	faa4fde3          	bgeu	s1,a0,80002828 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002872:	00777693          	andi	a3,a4,7
    80002876:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    8000287a:	41f7579b          	sraiw	a5,a4,0x1f
    8000287e:	01d7d79b          	srliw	a5,a5,0x1d
    80002882:	9fb9                	addw	a5,a5,a4
    80002884:	4037d79b          	sraiw	a5,a5,0x3
    80002888:	00f90633          	add	a2,s2,a5
    8000288c:	05864603          	lbu	a2,88(a2)
    80002890:	00c6f5b3          	and	a1,a3,a2
    80002894:	d585                	beqz	a1,800027bc <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002896:	2705                	addiw	a4,a4,1
    80002898:	2485                	addiw	s1,s1,1
    8000289a:	fd471ae3          	bne	a4,s4,8000286e <balloc+0xee>
    8000289e:	b769                	j	80002828 <balloc+0xa8>
    800028a0:	6906                	ld	s2,64(sp)
    800028a2:	79e2                	ld	s3,56(sp)
    800028a4:	7a42                	ld	s4,48(sp)
    800028a6:	7aa2                	ld	s5,40(sp)
    800028a8:	7b02                	ld	s6,32(sp)
    800028aa:	6be2                	ld	s7,24(sp)
    800028ac:	6c42                	ld	s8,16(sp)
    800028ae:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	b6850513          	addi	a0,a0,-1176 # 80008418 <etext+0x418>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	654080e7          	jalr	1620(ra) # 80005f0c <printf>
  return 0;
    800028c0:	4481                	li	s1,0
    800028c2:	bfa9                	j	8000281c <balloc+0x9c>

00000000800028c4 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	1800                	addi	s0,sp,48
    800028d2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800028d4:	47ad                	li	a5,11
    800028d6:	02b7e863          	bltu	a5,a1,80002906 <bmap+0x42>
    if ((addr = ip->addrs[bn]) == 0) {
    800028da:	02059793          	slli	a5,a1,0x20
    800028de:	01e7d593          	srli	a1,a5,0x1e
    800028e2:	00b504b3          	add	s1,a0,a1
    800028e6:	0504a903          	lw	s2,80(s1)
    800028ea:	08091263          	bnez	s2,8000296e <bmap+0xaa>
      addr = balloc(ip->dev);
    800028ee:	4108                	lw	a0,0(a0)
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	e90080e7          	jalr	-368(ra) # 80002780 <balloc>
    800028f8:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800028fc:	06090963          	beqz	s2,8000296e <bmap+0xaa>
      ip->addrs[bn] = addr;
    80002900:	0524a823          	sw	s2,80(s1)
    80002904:	a0ad                	j	8000296e <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002906:	ff45849b          	addiw	s1,a1,-12
    8000290a:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    8000290e:	0ff00793          	li	a5,255
    80002912:	08e7e863          	bltu	a5,a4,800029a2 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002916:	08052903          	lw	s2,128(a0)
    8000291a:	00091f63          	bnez	s2,80002938 <bmap+0x74>
      addr = balloc(ip->dev);
    8000291e:	4108                	lw	a0,0(a0)
    80002920:	00000097          	auipc	ra,0x0
    80002924:	e60080e7          	jalr	-416(ra) # 80002780 <balloc>
    80002928:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    8000292c:	04090163          	beqz	s2,8000296e <bmap+0xaa>
    80002930:	e052                	sd	s4,0(sp)
      ip->addrs[NDIRECT] = addr;
    80002932:	0929a023          	sw	s2,128(s3)
    80002936:	a011                	j	8000293a <bmap+0x76>
    80002938:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000293a:	85ca                	mv	a1,s2
    8000293c:	0009a503          	lw	a0,0(s3)
    80002940:	00000097          	auipc	ra,0x0
    80002944:	b80080e7          	jalr	-1152(ra) # 800024c0 <bread>
    80002948:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000294a:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000294e:	02049713          	slli	a4,s1,0x20
    80002952:	01e75593          	srli	a1,a4,0x1e
    80002956:	00b784b3          	add	s1,a5,a1
    8000295a:	0004a903          	lw	s2,0(s1)
    8000295e:	02090063          	beqz	s2,8000297e <bmap+0xba>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002962:	8552                	mv	a0,s4
    80002964:	00000097          	auipc	ra,0x0
    80002968:	c8c080e7          	jalr	-884(ra) # 800025f0 <brelse>
    return addr;
    8000296c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000296e:	854a                	mv	a0,s2
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6145                	addi	sp,sp,48
    8000297c:	8082                	ret
      addr = balloc(ip->dev);
    8000297e:	0009a503          	lw	a0,0(s3)
    80002982:	00000097          	auipc	ra,0x0
    80002986:	dfe080e7          	jalr	-514(ra) # 80002780 <balloc>
    8000298a:	0005091b          	sext.w	s2,a0
      if (addr) {
    8000298e:	fc090ae3          	beqz	s2,80002962 <bmap+0x9e>
        a[bn] = addr;
    80002992:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002996:	8552                	mv	a0,s4
    80002998:	00001097          	auipc	ra,0x1
    8000299c:	f02080e7          	jalr	-254(ra) # 8000389a <log_write>
    800029a0:	b7c9                	j	80002962 <bmap+0x9e>
    800029a2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800029a4:	00006517          	auipc	a0,0x6
    800029a8:	a8c50513          	addi	a0,a0,-1396 # 80008430 <etext+0x430>
    800029ac:	00003097          	auipc	ra,0x3
    800029b0:	516080e7          	jalr	1302(ra) # 80005ec2 <panic>

00000000800029b4 <iget>:
static struct inode *iget(uint dev, uint inum) {
    800029b4:	7179                	addi	sp,sp,-48
    800029b6:	f406                	sd	ra,40(sp)
    800029b8:	f022                	sd	s0,32(sp)
    800029ba:	ec26                	sd	s1,24(sp)
    800029bc:	e84a                	sd	s2,16(sp)
    800029be:	e44e                	sd	s3,8(sp)
    800029c0:	e052                	sd	s4,0(sp)
    800029c2:	1800                	addi	s0,sp,48
    800029c4:	89aa                	mv	s3,a0
    800029c6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029c8:	00017517          	auipc	a0,0x17
    800029cc:	e2050513          	addi	a0,a0,-480 # 800197e8 <itable>
    800029d0:	00004097          	auipc	ra,0x4
    800029d4:	a6c080e7          	jalr	-1428(ra) # 8000643c <acquire>
  empty = 0;
    800029d8:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800029da:	00017497          	auipc	s1,0x17
    800029de:	e2648493          	addi	s1,s1,-474 # 80019800 <itable+0x18>
    800029e2:	00019697          	auipc	a3,0x19
    800029e6:	8ae68693          	addi	a3,a3,-1874 # 8001b290 <log>
    800029ea:	a039                	j	800029f8 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    800029ec:	02090b63          	beqz	s2,80002a22 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800029f0:	08848493          	addi	s1,s1,136
    800029f4:	02d48a63          	beq	s1,a3,80002a28 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800029f8:	449c                	lw	a5,8(s1)
    800029fa:	fef059e3          	blez	a5,800029ec <iget+0x38>
    800029fe:	4098                	lw	a4,0(s1)
    80002a00:	ff3716e3          	bne	a4,s3,800029ec <iget+0x38>
    80002a04:	40d8                	lw	a4,4(s1)
    80002a06:	ff4713e3          	bne	a4,s4,800029ec <iget+0x38>
      ip->ref++;
    80002a0a:	2785                	addiw	a5,a5,1
    80002a0c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a0e:	00017517          	auipc	a0,0x17
    80002a12:	dda50513          	addi	a0,a0,-550 # 800197e8 <itable>
    80002a16:	00004097          	auipc	ra,0x4
    80002a1a:	ada080e7          	jalr	-1318(ra) # 800064f0 <release>
      return ip;
    80002a1e:	8926                	mv	s2,s1
    80002a20:	a03d                	j	80002a4e <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002a22:	f7f9                	bnez	a5,800029f0 <iget+0x3c>
      empty = ip;
    80002a24:	8926                	mv	s2,s1
    80002a26:	b7e9                	j	800029f0 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002a28:	02090c63          	beqz	s2,80002a60 <iget+0xac>
  ip->dev = dev;
    80002a2c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a30:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a34:	4785                	li	a5,1
    80002a36:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a3a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a3e:	00017517          	auipc	a0,0x17
    80002a42:	daa50513          	addi	a0,a0,-598 # 800197e8 <itable>
    80002a46:	00004097          	auipc	ra,0x4
    80002a4a:	aaa080e7          	jalr	-1366(ra) # 800064f0 <release>
}
    80002a4e:	854a                	mv	a0,s2
    80002a50:	70a2                	ld	ra,40(sp)
    80002a52:	7402                	ld	s0,32(sp)
    80002a54:	64e2                	ld	s1,24(sp)
    80002a56:	6942                	ld	s2,16(sp)
    80002a58:	69a2                	ld	s3,8(sp)
    80002a5a:	6a02                	ld	s4,0(sp)
    80002a5c:	6145                	addi	sp,sp,48
    80002a5e:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002a60:	00006517          	auipc	a0,0x6
    80002a64:	9e850513          	addi	a0,a0,-1560 # 80008448 <etext+0x448>
    80002a68:	00003097          	auipc	ra,0x3
    80002a6c:	45a080e7          	jalr	1114(ra) # 80005ec2 <panic>

0000000080002a70 <fsinit>:
void fsinit(int dev) {
    80002a70:	7179                	addi	sp,sp,-48
    80002a72:	f406                	sd	ra,40(sp)
    80002a74:	f022                	sd	s0,32(sp)
    80002a76:	ec26                	sd	s1,24(sp)
    80002a78:	e84a                	sd	s2,16(sp)
    80002a7a:	e44e                	sd	s3,8(sp)
    80002a7c:	1800                	addi	s0,sp,48
    80002a7e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a80:	4585                	li	a1,1
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	a3e080e7          	jalr	-1474(ra) # 800024c0 <bread>
    80002a8a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a8c:	00017997          	auipc	s3,0x17
    80002a90:	d3c98993          	addi	s3,s3,-708 # 800197c8 <sb>
    80002a94:	02000613          	li	a2,32
    80002a98:	05850593          	addi	a1,a0,88
    80002a9c:	854e                	mv	a0,s3
    80002a9e:	ffffd097          	auipc	ra,0xffffd
    80002aa2:	738080e7          	jalr	1848(ra) # 800001d6 <memmove>
  brelse(bp);
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	b48080e7          	jalr	-1208(ra) # 800025f0 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002ab0:	0009a703          	lw	a4,0(s3)
    80002ab4:	102037b7          	lui	a5,0x10203
    80002ab8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002abc:	02f71263          	bne	a4,a5,80002ae0 <fsinit+0x70>
  initlog(dev, &sb);
    80002ac0:	00017597          	auipc	a1,0x17
    80002ac4:	d0858593          	addi	a1,a1,-760 # 800197c8 <sb>
    80002ac8:	854a                	mv	a0,s2
    80002aca:	00001097          	auipc	ra,0x1
    80002ace:	b60080e7          	jalr	-1184(ra) # 8000362a <initlog>
}
    80002ad2:	70a2                	ld	ra,40(sp)
    80002ad4:	7402                	ld	s0,32(sp)
    80002ad6:	64e2                	ld	s1,24(sp)
    80002ad8:	6942                	ld	s2,16(sp)
    80002ada:	69a2                	ld	s3,8(sp)
    80002adc:	6145                	addi	sp,sp,48
    80002ade:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002ae0:	00006517          	auipc	a0,0x6
    80002ae4:	97850513          	addi	a0,a0,-1672 # 80008458 <etext+0x458>
    80002ae8:	00003097          	auipc	ra,0x3
    80002aec:	3da080e7          	jalr	986(ra) # 80005ec2 <panic>

0000000080002af0 <iinit>:
void iinit() {
    80002af0:	7179                	addi	sp,sp,-48
    80002af2:	f406                	sd	ra,40(sp)
    80002af4:	f022                	sd	s0,32(sp)
    80002af6:	ec26                	sd	s1,24(sp)
    80002af8:	e84a                	sd	s2,16(sp)
    80002afa:	e44e                	sd	s3,8(sp)
    80002afc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002afe:	00006597          	auipc	a1,0x6
    80002b02:	97258593          	addi	a1,a1,-1678 # 80008470 <etext+0x470>
    80002b06:	00017517          	auipc	a0,0x17
    80002b0a:	ce250513          	addi	a0,a0,-798 # 800197e8 <itable>
    80002b0e:	00004097          	auipc	ra,0x4
    80002b12:	89e080e7          	jalr	-1890(ra) # 800063ac <initlock>
  for (i = 0; i < NINODE; i++) {
    80002b16:	00017497          	auipc	s1,0x17
    80002b1a:	cfa48493          	addi	s1,s1,-774 # 80019810 <itable+0x28>
    80002b1e:	00018997          	auipc	s3,0x18
    80002b22:	78298993          	addi	s3,s3,1922 # 8001b2a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b26:	00006917          	auipc	s2,0x6
    80002b2a:	95290913          	addi	s2,s2,-1710 # 80008478 <etext+0x478>
    80002b2e:	85ca                	mv	a1,s2
    80002b30:	8526                	mv	a0,s1
    80002b32:	00001097          	auipc	ra,0x1
    80002b36:	e4c080e7          	jalr	-436(ra) # 8000397e <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002b3a:	08848493          	addi	s1,s1,136
    80002b3e:	ff3498e3          	bne	s1,s3,80002b2e <iinit+0x3e>
}
    80002b42:	70a2                	ld	ra,40(sp)
    80002b44:	7402                	ld	s0,32(sp)
    80002b46:	64e2                	ld	s1,24(sp)
    80002b48:	6942                	ld	s2,16(sp)
    80002b4a:	69a2                	ld	s3,8(sp)
    80002b4c:	6145                	addi	sp,sp,48
    80002b4e:	8082                	ret

0000000080002b50 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002b50:	7139                	addi	sp,sp,-64
    80002b52:	fc06                	sd	ra,56(sp)
    80002b54:	f822                	sd	s0,48(sp)
    80002b56:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002b58:	00017717          	auipc	a4,0x17
    80002b5c:	c7c72703          	lw	a4,-900(a4) # 800197d4 <sb+0xc>
    80002b60:	4785                	li	a5,1
    80002b62:	06e7f463          	bgeu	a5,a4,80002bca <ialloc+0x7a>
    80002b66:	f426                	sd	s1,40(sp)
    80002b68:	f04a                	sd	s2,32(sp)
    80002b6a:	ec4e                	sd	s3,24(sp)
    80002b6c:	e852                	sd	s4,16(sp)
    80002b6e:	e456                	sd	s5,8(sp)
    80002b70:	e05a                	sd	s6,0(sp)
    80002b72:	8aaa                	mv	s5,a0
    80002b74:	8b2e                	mv	s6,a1
    80002b76:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b78:	00017a17          	auipc	s4,0x17
    80002b7c:	c50a0a13          	addi	s4,s4,-944 # 800197c8 <sb>
    80002b80:	00495593          	srli	a1,s2,0x4
    80002b84:	018a2783          	lw	a5,24(s4)
    80002b88:	9dbd                	addw	a1,a1,a5
    80002b8a:	8556                	mv	a0,s5
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	934080e7          	jalr	-1740(ra) # 800024c0 <bread>
    80002b94:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002b96:	05850993          	addi	s3,a0,88
    80002b9a:	00f97793          	andi	a5,s2,15
    80002b9e:	079a                	slli	a5,a5,0x6
    80002ba0:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002ba2:	00099783          	lh	a5,0(s3)
    80002ba6:	cf9d                	beqz	a5,80002be4 <ialloc+0x94>
    brelse(bp);
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	a48080e7          	jalr	-1464(ra) # 800025f0 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002bb0:	0905                	addi	s2,s2,1
    80002bb2:	00ca2703          	lw	a4,12(s4)
    80002bb6:	0009079b          	sext.w	a5,s2
    80002bba:	fce7e3e3          	bltu	a5,a4,80002b80 <ialloc+0x30>
    80002bbe:	74a2                	ld	s1,40(sp)
    80002bc0:	7902                	ld	s2,32(sp)
    80002bc2:	69e2                	ld	s3,24(sp)
    80002bc4:	6a42                	ld	s4,16(sp)
    80002bc6:	6aa2                	ld	s5,8(sp)
    80002bc8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002bca:	00006517          	auipc	a0,0x6
    80002bce:	8b650513          	addi	a0,a0,-1866 # 80008480 <etext+0x480>
    80002bd2:	00003097          	auipc	ra,0x3
    80002bd6:	33a080e7          	jalr	826(ra) # 80005f0c <printf>
  return 0;
    80002bda:	4501                	li	a0,0
}
    80002bdc:	70e2                	ld	ra,56(sp)
    80002bde:	7442                	ld	s0,48(sp)
    80002be0:	6121                	addi	sp,sp,64
    80002be2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002be4:	04000613          	li	a2,64
    80002be8:	4581                	li	a1,0
    80002bea:	854e                	mv	a0,s3
    80002bec:	ffffd097          	auipc	ra,0xffffd
    80002bf0:	58e080e7          	jalr	1422(ra) # 8000017a <memset>
      dip->type = type;
    80002bf4:	01699023          	sh	s6,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	00001097          	auipc	ra,0x1
    80002bfe:	ca0080e7          	jalr	-864(ra) # 8000389a <log_write>
      brelse(bp);
    80002c02:	8526                	mv	a0,s1
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	9ec080e7          	jalr	-1556(ra) # 800025f0 <brelse>
      return iget(dev, inum);
    80002c0c:	0009059b          	sext.w	a1,s2
    80002c10:	8556                	mv	a0,s5
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	da2080e7          	jalr	-606(ra) # 800029b4 <iget>
    80002c1a:	74a2                	ld	s1,40(sp)
    80002c1c:	7902                	ld	s2,32(sp)
    80002c1e:	69e2                	ld	s3,24(sp)
    80002c20:	6a42                	ld	s4,16(sp)
    80002c22:	6aa2                	ld	s5,8(sp)
    80002c24:	6b02                	ld	s6,0(sp)
    80002c26:	bf5d                	j	80002bdc <ialloc+0x8c>

0000000080002c28 <iupdate>:
void iupdate(struct inode *ip) {
    80002c28:	1101                	addi	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	e04a                	sd	s2,0(sp)
    80002c32:	1000                	addi	s0,sp,32
    80002c34:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c36:	415c                	lw	a5,4(a0)
    80002c38:	0047d79b          	srliw	a5,a5,0x4
    80002c3c:	00017597          	auipc	a1,0x17
    80002c40:	ba45a583          	lw	a1,-1116(a1) # 800197e0 <sb+0x18>
    80002c44:	9dbd                	addw	a1,a1,a5
    80002c46:	4108                	lw	a0,0(a0)
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	878080e7          	jalr	-1928(ra) # 800024c0 <bread>
    80002c50:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c52:	05850793          	addi	a5,a0,88
    80002c56:	40d8                	lw	a4,4(s1)
    80002c58:	8b3d                	andi	a4,a4,15
    80002c5a:	071a                	slli	a4,a4,0x6
    80002c5c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c5e:	04449703          	lh	a4,68(s1)
    80002c62:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c66:	04649703          	lh	a4,70(s1)
    80002c6a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c6e:	04849703          	lh	a4,72(s1)
    80002c72:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c76:	04a49703          	lh	a4,74(s1)
    80002c7a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c7e:	44f8                	lw	a4,76(s1)
    80002c80:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c82:	03400613          	li	a2,52
    80002c86:	05048593          	addi	a1,s1,80
    80002c8a:	00c78513          	addi	a0,a5,12
    80002c8e:	ffffd097          	auipc	ra,0xffffd
    80002c92:	548080e7          	jalr	1352(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c96:	854a                	mv	a0,s2
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	c02080e7          	jalr	-1022(ra) # 8000389a <log_write>
  brelse(bp);
    80002ca0:	854a                	mv	a0,s2
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	94e080e7          	jalr	-1714(ra) # 800025f0 <brelse>
}
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	64a2                	ld	s1,8(sp)
    80002cb0:	6902                	ld	s2,0(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret

0000000080002cb6 <idup>:
struct inode *idup(struct inode *ip) {
    80002cb6:	1101                	addi	sp,sp,-32
    80002cb8:	ec06                	sd	ra,24(sp)
    80002cba:	e822                	sd	s0,16(sp)
    80002cbc:	e426                	sd	s1,8(sp)
    80002cbe:	1000                	addi	s0,sp,32
    80002cc0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cc2:	00017517          	auipc	a0,0x17
    80002cc6:	b2650513          	addi	a0,a0,-1242 # 800197e8 <itable>
    80002cca:	00003097          	auipc	ra,0x3
    80002cce:	772080e7          	jalr	1906(ra) # 8000643c <acquire>
  ip->ref++;
    80002cd2:	449c                	lw	a5,8(s1)
    80002cd4:	2785                	addiw	a5,a5,1
    80002cd6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd8:	00017517          	auipc	a0,0x17
    80002cdc:	b1050513          	addi	a0,a0,-1264 # 800197e8 <itable>
    80002ce0:	00004097          	auipc	ra,0x4
    80002ce4:	810080e7          	jalr	-2032(ra) # 800064f0 <release>
}
    80002ce8:	8526                	mv	a0,s1
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6105                	addi	sp,sp,32
    80002cf2:	8082                	ret

0000000080002cf4 <ilock>:
void ilock(struct inode *ip) {
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002cfe:	c10d                	beqz	a0,80002d20 <ilock+0x2c>
    80002d00:	84aa                	mv	s1,a0
    80002d02:	451c                	lw	a5,8(a0)
    80002d04:	00f05e63          	blez	a5,80002d20 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d08:	0541                	addi	a0,a0,16
    80002d0a:	00001097          	auipc	ra,0x1
    80002d0e:	cae080e7          	jalr	-850(ra) # 800039b8 <acquiresleep>
  if (ip->valid == 0) {
    80002d12:	40bc                	lw	a5,64(s1)
    80002d14:	cf99                	beqz	a5,80002d32 <ilock+0x3e>
}
    80002d16:	60e2                	ld	ra,24(sp)
    80002d18:	6442                	ld	s0,16(sp)
    80002d1a:	64a2                	ld	s1,8(sp)
    80002d1c:	6105                	addi	sp,sp,32
    80002d1e:	8082                	ret
    80002d20:	e04a                	sd	s2,0(sp)
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002d22:	00005517          	auipc	a0,0x5
    80002d26:	77650513          	addi	a0,a0,1910 # 80008498 <etext+0x498>
    80002d2a:	00003097          	auipc	ra,0x3
    80002d2e:	198080e7          	jalr	408(ra) # 80005ec2 <panic>
    80002d32:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d34:	40dc                	lw	a5,4(s1)
    80002d36:	0047d79b          	srliw	a5,a5,0x4
    80002d3a:	00017597          	auipc	a1,0x17
    80002d3e:	aa65a583          	lw	a1,-1370(a1) # 800197e0 <sb+0x18>
    80002d42:	9dbd                	addw	a1,a1,a5
    80002d44:	4088                	lw	a0,0(s1)
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	77a080e7          	jalr	1914(ra) # 800024c0 <bread>
    80002d4e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002d50:	05850593          	addi	a1,a0,88
    80002d54:	40dc                	lw	a5,4(s1)
    80002d56:	8bbd                	andi	a5,a5,15
    80002d58:	079a                	slli	a5,a5,0x6
    80002d5a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d5c:	00059783          	lh	a5,0(a1)
    80002d60:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d64:	00259783          	lh	a5,2(a1)
    80002d68:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d6c:	00459783          	lh	a5,4(a1)
    80002d70:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d74:	00659783          	lh	a5,6(a1)
    80002d78:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d7c:	459c                	lw	a5,8(a1)
    80002d7e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d80:	03400613          	li	a2,52
    80002d84:	05b1                	addi	a1,a1,12
    80002d86:	05048513          	addi	a0,s1,80
    80002d8a:	ffffd097          	auipc	ra,0xffffd
    80002d8e:	44c080e7          	jalr	1100(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d92:	854a                	mv	a0,s2
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	85c080e7          	jalr	-1956(ra) # 800025f0 <brelse>
    ip->valid = 1;
    80002d9c:	4785                	li	a5,1
    80002d9e:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002da0:	04449783          	lh	a5,68(s1)
    80002da4:	c399                	beqz	a5,80002daa <ilock+0xb6>
    80002da6:	6902                	ld	s2,0(sp)
    80002da8:	b7bd                	j	80002d16 <ilock+0x22>
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	6f650513          	addi	a0,a0,1782 # 800084a0 <etext+0x4a0>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	110080e7          	jalr	272(ra) # 80005ec2 <panic>

0000000080002dba <iunlock>:
void iunlock(struct inode *ip) {
    80002dba:	1101                	addi	sp,sp,-32
    80002dbc:	ec06                	sd	ra,24(sp)
    80002dbe:	e822                	sd	s0,16(sp)
    80002dc0:	e426                	sd	s1,8(sp)
    80002dc2:	e04a                	sd	s2,0(sp)
    80002dc4:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002dc6:	c905                	beqz	a0,80002df6 <iunlock+0x3c>
    80002dc8:	84aa                	mv	s1,a0
    80002dca:	01050913          	addi	s2,a0,16
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	c82080e7          	jalr	-894(ra) # 80003a52 <holdingsleep>
    80002dd8:	cd19                	beqz	a0,80002df6 <iunlock+0x3c>
    80002dda:	449c                	lw	a5,8(s1)
    80002ddc:	00f05d63          	blez	a5,80002df6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002de0:	854a                	mv	a0,s2
    80002de2:	00001097          	auipc	ra,0x1
    80002de6:	c2c080e7          	jalr	-980(ra) # 80003a0e <releasesleep>
}
    80002dea:	60e2                	ld	ra,24(sp)
    80002dec:	6442                	ld	s0,16(sp)
    80002dee:	64a2                	ld	s1,8(sp)
    80002df0:	6902                	ld	s2,0(sp)
    80002df2:	6105                	addi	sp,sp,32
    80002df4:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002df6:	00005517          	auipc	a0,0x5
    80002dfa:	6ba50513          	addi	a0,a0,1722 # 800084b0 <etext+0x4b0>
    80002dfe:	00003097          	auipc	ra,0x3
    80002e02:	0c4080e7          	jalr	196(ra) # 80005ec2 <panic>

0000000080002e06 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002e06:	7179                	addi	sp,sp,-48
    80002e08:	f406                	sd	ra,40(sp)
    80002e0a:	f022                	sd	s0,32(sp)
    80002e0c:	ec26                	sd	s1,24(sp)
    80002e0e:	e84a                	sd	s2,16(sp)
    80002e10:	e44e                	sd	s3,8(sp)
    80002e12:	1800                	addi	s0,sp,48
    80002e14:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002e16:	05050493          	addi	s1,a0,80
    80002e1a:	08050913          	addi	s2,a0,128
    80002e1e:	a021                	j	80002e26 <itrunc+0x20>
    80002e20:	0491                	addi	s1,s1,4
    80002e22:	01248d63          	beq	s1,s2,80002e3c <itrunc+0x36>
    if (ip->addrs[i]) {
    80002e26:	408c                	lw	a1,0(s1)
    80002e28:	dde5                	beqz	a1,80002e20 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e2a:	0009a503          	lw	a0,0(s3)
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	8d6080e7          	jalr	-1834(ra) # 80002704 <bfree>
      ip->addrs[i] = 0;
    80002e36:	0004a023          	sw	zero,0(s1)
    80002e3a:	b7dd                	j	80002e20 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002e3c:	0809a583          	lw	a1,128(s3)
    80002e40:	ed99                	bnez	a1,80002e5e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e42:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e46:	854e                	mv	a0,s3
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	de0080e7          	jalr	-544(ra) # 80002c28 <iupdate>
}
    80002e50:	70a2                	ld	ra,40(sp)
    80002e52:	7402                	ld	s0,32(sp)
    80002e54:	64e2                	ld	s1,24(sp)
    80002e56:	6942                	ld	s2,16(sp)
    80002e58:	69a2                	ld	s3,8(sp)
    80002e5a:	6145                	addi	sp,sp,48
    80002e5c:	8082                	ret
    80002e5e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	fffff097          	auipc	ra,0xfffff
    80002e68:	65c080e7          	jalr	1628(ra) # 800024c0 <bread>
    80002e6c:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002e6e:	05850493          	addi	s1,a0,88
    80002e72:	45850913          	addi	s2,a0,1112
    80002e76:	a021                	j	80002e7e <itrunc+0x78>
    80002e78:	0491                	addi	s1,s1,4
    80002e7a:	01248b63          	beq	s1,s2,80002e90 <itrunc+0x8a>
      if (a[j]) bfree(ip->dev, a[j]);
    80002e7e:	408c                	lw	a1,0(s1)
    80002e80:	dde5                	beqz	a1,80002e78 <itrunc+0x72>
    80002e82:	0009a503          	lw	a0,0(s3)
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	87e080e7          	jalr	-1922(ra) # 80002704 <bfree>
    80002e8e:	b7ed                	j	80002e78 <itrunc+0x72>
    brelse(bp);
    80002e90:	8552                	mv	a0,s4
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	75e080e7          	jalr	1886(ra) # 800025f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e9a:	0809a583          	lw	a1,128(s3)
    80002e9e:	0009a503          	lw	a0,0(s3)
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	862080e7          	jalr	-1950(ra) # 80002704 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eaa:	0809a023          	sw	zero,128(s3)
    80002eae:	6a02                	ld	s4,0(sp)
    80002eb0:	bf49                	j	80002e42 <itrunc+0x3c>

0000000080002eb2 <iput>:
void iput(struct inode *ip) {
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	1000                	addi	s0,sp,32
    80002ebc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ebe:	00017517          	auipc	a0,0x17
    80002ec2:	92a50513          	addi	a0,a0,-1750 # 800197e8 <itable>
    80002ec6:	00003097          	auipc	ra,0x3
    80002eca:	576080e7          	jalr	1398(ra) # 8000643c <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002ece:	4498                	lw	a4,8(s1)
    80002ed0:	4785                	li	a5,1
    80002ed2:	02f70263          	beq	a4,a5,80002ef6 <iput+0x44>
  ip->ref--;
    80002ed6:	449c                	lw	a5,8(s1)
    80002ed8:	37fd                	addiw	a5,a5,-1
    80002eda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002edc:	00017517          	auipc	a0,0x17
    80002ee0:	90c50513          	addi	a0,a0,-1780 # 800197e8 <itable>
    80002ee4:	00003097          	auipc	ra,0x3
    80002ee8:	60c080e7          	jalr	1548(ra) # 800064f0 <release>
}
    80002eec:	60e2                	ld	ra,24(sp)
    80002eee:	6442                	ld	s0,16(sp)
    80002ef0:	64a2                	ld	s1,8(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002ef6:	40bc                	lw	a5,64(s1)
    80002ef8:	dff9                	beqz	a5,80002ed6 <iput+0x24>
    80002efa:	04a49783          	lh	a5,74(s1)
    80002efe:	ffe1                	bnez	a5,80002ed6 <iput+0x24>
    80002f00:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f02:	01048913          	addi	s2,s1,16
    80002f06:	854a                	mv	a0,s2
    80002f08:	00001097          	auipc	ra,0x1
    80002f0c:	ab0080e7          	jalr	-1360(ra) # 800039b8 <acquiresleep>
    release(&itable.lock);
    80002f10:	00017517          	auipc	a0,0x17
    80002f14:	8d850513          	addi	a0,a0,-1832 # 800197e8 <itable>
    80002f18:	00003097          	auipc	ra,0x3
    80002f1c:	5d8080e7          	jalr	1496(ra) # 800064f0 <release>
    itrunc(ip);
    80002f20:	8526                	mv	a0,s1
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	ee4080e7          	jalr	-284(ra) # 80002e06 <itrunc>
    ip->type = 0;
    80002f2a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f2e:	8526                	mv	a0,s1
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	cf8080e7          	jalr	-776(ra) # 80002c28 <iupdate>
    ip->valid = 0;
    80002f38:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	00001097          	auipc	ra,0x1
    80002f42:	ad0080e7          	jalr	-1328(ra) # 80003a0e <releasesleep>
    acquire(&itable.lock);
    80002f46:	00017517          	auipc	a0,0x17
    80002f4a:	8a250513          	addi	a0,a0,-1886 # 800197e8 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	4ee080e7          	jalr	1262(ra) # 8000643c <acquire>
    80002f56:	6902                	ld	s2,0(sp)
    80002f58:	bfbd                	j	80002ed6 <iput+0x24>

0000000080002f5a <iunlockput>:
void iunlockput(struct inode *ip) {
    80002f5a:	1101                	addi	sp,sp,-32
    80002f5c:	ec06                	sd	ra,24(sp)
    80002f5e:	e822                	sd	s0,16(sp)
    80002f60:	e426                	sd	s1,8(sp)
    80002f62:	1000                	addi	s0,sp,32
    80002f64:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	e54080e7          	jalr	-428(ra) # 80002dba <iunlock>
  iput(ip);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	f42080e7          	jalr	-190(ra) # 80002eb2 <iput>
}
    80002f78:	60e2                	ld	ra,24(sp)
    80002f7a:	6442                	ld	s0,16(sp)
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	6105                	addi	sp,sp,32
    80002f80:	8082                	ret

0000000080002f82 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002f82:	1141                	addi	sp,sp,-16
    80002f84:	e422                	sd	s0,8(sp)
    80002f86:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f88:	411c                	lw	a5,0(a0)
    80002f8a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f8c:	415c                	lw	a5,4(a0)
    80002f8e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f90:	04451783          	lh	a5,68(a0)
    80002f94:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f98:	04a51783          	lh	a5,74(a0)
    80002f9c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fa0:	04c56783          	lwu	a5,76(a0)
    80002fa4:	e99c                	sd	a5,16(a1)
}
    80002fa6:	6422                	ld	s0,8(sp)
    80002fa8:	0141                	addi	sp,sp,16
    80002faa:	8082                	ret

0000000080002fac <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002fac:	457c                	lw	a5,76(a0)
    80002fae:	10d7e563          	bltu	a5,a3,800030b8 <readi+0x10c>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002fb2:	7159                	addi	sp,sp,-112
    80002fb4:	f486                	sd	ra,104(sp)
    80002fb6:	f0a2                	sd	s0,96(sp)
    80002fb8:	eca6                	sd	s1,88(sp)
    80002fba:	e0d2                	sd	s4,64(sp)
    80002fbc:	fc56                	sd	s5,56(sp)
    80002fbe:	f85a                	sd	s6,48(sp)
    80002fc0:	f45e                	sd	s7,40(sp)
    80002fc2:	1880                	addi	s0,sp,112
    80002fc4:	8b2a                	mv	s6,a0
    80002fc6:	8bae                	mv	s7,a1
    80002fc8:	8a32                	mv	s4,a2
    80002fca:	84b6                	mv	s1,a3
    80002fcc:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002fce:	9f35                	addw	a4,a4,a3
    80002fd0:	4501                	li	a0,0
    80002fd2:	0cd76a63          	bltu	a4,a3,800030a6 <readi+0xfa>
    80002fd6:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size) n = ip->size - off;
    80002fd8:	00e7f463          	bgeu	a5,a4,80002fe0 <readi+0x34>
    80002fdc:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002fe0:	0a0a8963          	beqz	s5,80003092 <readi+0xe6>
    80002fe4:	e8ca                	sd	s2,80(sp)
    80002fe6:	f062                	sd	s8,32(sp)
    80002fe8:	ec66                	sd	s9,24(sp)
    80002fea:	e86a                	sd	s10,16(sp)
    80002fec:	e46e                	sd	s11,8(sp)
    80002fee:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002ff0:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ff4:	5c7d                	li	s8,-1
    80002ff6:	a82d                	j	80003030 <readi+0x84>
    80002ff8:	020d1d93          	slli	s11,s10,0x20
    80002ffc:	020ddd93          	srli	s11,s11,0x20
    80003000:	05890613          	addi	a2,s2,88
    80003004:	86ee                	mv	a3,s11
    80003006:	963a                	add	a2,a2,a4
    80003008:	85d2                	mv	a1,s4
    8000300a:	855e                	mv	a0,s7
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	9b0080e7          	jalr	-1616(ra) # 800019bc <either_copyout>
    80003014:	05850d63          	beq	a0,s8,8000306e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003018:	854a                	mv	a0,s2
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	5d6080e7          	jalr	1494(ra) # 800025f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003022:	013d09bb          	addw	s3,s10,s3
    80003026:	009d04bb          	addw	s1,s10,s1
    8000302a:	9a6e                	add	s4,s4,s11
    8000302c:	0559fd63          	bgeu	s3,s5,80003086 <readi+0xda>
    uint addr = bmap(ip, off / BSIZE);
    80003030:	00a4d59b          	srliw	a1,s1,0xa
    80003034:	855a                	mv	a0,s6
    80003036:	00000097          	auipc	ra,0x0
    8000303a:	88e080e7          	jalr	-1906(ra) # 800028c4 <bmap>
    8000303e:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003042:	c9b1                	beqz	a1,80003096 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003044:	000b2503          	lw	a0,0(s6)
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	478080e7          	jalr	1144(ra) # 800024c0 <bread>
    80003050:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003052:	3ff4f713          	andi	a4,s1,1023
    80003056:	40ec87bb          	subw	a5,s9,a4
    8000305a:	413a86bb          	subw	a3,s5,s3
    8000305e:	8d3e                	mv	s10,a5
    80003060:	2781                	sext.w	a5,a5
    80003062:	0006861b          	sext.w	a2,a3
    80003066:	f8f679e3          	bgeu	a2,a5,80002ff8 <readi+0x4c>
    8000306a:	8d36                	mv	s10,a3
    8000306c:	b771                	j	80002ff8 <readi+0x4c>
      brelse(bp);
    8000306e:	854a                	mv	a0,s2
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	580080e7          	jalr	1408(ra) # 800025f0 <brelse>
      tot = -1;
    80003078:	59fd                	li	s3,-1
      break;
    8000307a:	6946                	ld	s2,80(sp)
    8000307c:	7c02                	ld	s8,32(sp)
    8000307e:	6ce2                	ld	s9,24(sp)
    80003080:	6d42                	ld	s10,16(sp)
    80003082:	6da2                	ld	s11,8(sp)
    80003084:	a831                	j	800030a0 <readi+0xf4>
    80003086:	6946                	ld	s2,80(sp)
    80003088:	7c02                	ld	s8,32(sp)
    8000308a:	6ce2                	ld	s9,24(sp)
    8000308c:	6d42                	ld	s10,16(sp)
    8000308e:	6da2                	ld	s11,8(sp)
    80003090:	a801                	j	800030a0 <readi+0xf4>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003092:	89d6                	mv	s3,s5
    80003094:	a031                	j	800030a0 <readi+0xf4>
    80003096:	6946                	ld	s2,80(sp)
    80003098:	7c02                	ld	s8,32(sp)
    8000309a:	6ce2                	ld	s9,24(sp)
    8000309c:	6d42                	ld	s10,16(sp)
    8000309e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030a0:	0009851b          	sext.w	a0,s3
    800030a4:	69a6                	ld	s3,72(sp)
}
    800030a6:	70a6                	ld	ra,104(sp)
    800030a8:	7406                	ld	s0,96(sp)
    800030aa:	64e6                	ld	s1,88(sp)
    800030ac:	6a06                	ld	s4,64(sp)
    800030ae:	7ae2                	ld	s5,56(sp)
    800030b0:	7b42                	ld	s6,48(sp)
    800030b2:	7ba2                	ld	s7,40(sp)
    800030b4:	6165                	addi	sp,sp,112
    800030b6:	8082                	ret
  if (off > ip->size || off + n < off) return 0;
    800030b8:	4501                	li	a0,0
}
    800030ba:	8082                	ret

00000000800030bc <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    800030bc:	457c                	lw	a5,76(a0)
    800030be:	10d7ee63          	bltu	a5,a3,800031da <writei+0x11e>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    800030c2:	7159                	addi	sp,sp,-112
    800030c4:	f486                	sd	ra,104(sp)
    800030c6:	f0a2                	sd	s0,96(sp)
    800030c8:	e8ca                	sd	s2,80(sp)
    800030ca:	e0d2                	sd	s4,64(sp)
    800030cc:	fc56                	sd	s5,56(sp)
    800030ce:	f85a                	sd	s6,48(sp)
    800030d0:	f45e                	sd	s7,40(sp)
    800030d2:	1880                	addi	s0,sp,112
    800030d4:	8aaa                	mv	s5,a0
    800030d6:	8bae                	mv	s7,a1
    800030d8:	8a32                	mv	s4,a2
    800030da:	8936                	mv	s2,a3
    800030dc:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    800030de:	00e687bb          	addw	a5,a3,a4
    800030e2:	0ed7ee63          	bltu	a5,a3,800031de <writei+0x122>
  if (off + n > MAXFILE * BSIZE) return -1;
    800030e6:	00043737          	lui	a4,0x43
    800030ea:	0ef76c63          	bltu	a4,a5,800031e2 <writei+0x126>
    800030ee:	e4ce                	sd	s3,72(sp)

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800030f0:	0c0b0d63          	beqz	s6,800031ca <writei+0x10e>
    800030f4:	eca6                	sd	s1,88(sp)
    800030f6:	f062                	sd	s8,32(sp)
    800030f8:	ec66                	sd	s9,24(sp)
    800030fa:	e86a                	sd	s10,16(sp)
    800030fc:	e46e                	sd	s11,8(sp)
    800030fe:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003100:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003104:	5c7d                	li	s8,-1
    80003106:	a091                	j	8000314a <writei+0x8e>
    80003108:	020d1d93          	slli	s11,s10,0x20
    8000310c:	020ddd93          	srli	s11,s11,0x20
    80003110:	05848513          	addi	a0,s1,88
    80003114:	86ee                	mv	a3,s11
    80003116:	8652                	mv	a2,s4
    80003118:	85de                	mv	a1,s7
    8000311a:	953a                	add	a0,a0,a4
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	8f6080e7          	jalr	-1802(ra) # 80001a12 <either_copyin>
    80003124:	07850263          	beq	a0,s8,80003188 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003128:	8526                	mv	a0,s1
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	770080e7          	jalr	1904(ra) # 8000389a <log_write>
    brelse(bp);
    80003132:	8526                	mv	a0,s1
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	4bc080e7          	jalr	1212(ra) # 800025f0 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000313c:	013d09bb          	addw	s3,s10,s3
    80003140:	012d093b          	addw	s2,s10,s2
    80003144:	9a6e                	add	s4,s4,s11
    80003146:	0569f663          	bgeu	s3,s6,80003192 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    8000314a:	00a9559b          	srliw	a1,s2,0xa
    8000314e:	8556                	mv	a0,s5
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	774080e7          	jalr	1908(ra) # 800028c4 <bmap>
    80003158:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    8000315c:	c99d                	beqz	a1,80003192 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000315e:	000aa503          	lw	a0,0(s5)
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	35e080e7          	jalr	862(ra) # 800024c0 <bread>
    8000316a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000316c:	3ff97713          	andi	a4,s2,1023
    80003170:	40ec87bb          	subw	a5,s9,a4
    80003174:	413b06bb          	subw	a3,s6,s3
    80003178:	8d3e                	mv	s10,a5
    8000317a:	2781                	sext.w	a5,a5
    8000317c:	0006861b          	sext.w	a2,a3
    80003180:	f8f674e3          	bgeu	a2,a5,80003108 <writei+0x4c>
    80003184:	8d36                	mv	s10,a3
    80003186:	b749                	j	80003108 <writei+0x4c>
      brelse(bp);
    80003188:	8526                	mv	a0,s1
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	466080e7          	jalr	1126(ra) # 800025f0 <brelse>
  }

  if (off > ip->size) ip->size = off;
    80003192:	04caa783          	lw	a5,76(s5)
    80003196:	0327fc63          	bgeu	a5,s2,800031ce <writei+0x112>
    8000319a:	052aa623          	sw	s2,76(s5)
    8000319e:	64e6                	ld	s1,88(sp)
    800031a0:	7c02                	ld	s8,32(sp)
    800031a2:	6ce2                	ld	s9,24(sp)
    800031a4:	6d42                	ld	s10,16(sp)
    800031a6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031a8:	8556                	mv	a0,s5
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	a7e080e7          	jalr	-1410(ra) # 80002c28 <iupdate>

  return tot;
    800031b2:	0009851b          	sext.w	a0,s3
    800031b6:	69a6                	ld	s3,72(sp)
}
    800031b8:	70a6                	ld	ra,104(sp)
    800031ba:	7406                	ld	s0,96(sp)
    800031bc:	6946                	ld	s2,80(sp)
    800031be:	6a06                	ld	s4,64(sp)
    800031c0:	7ae2                	ld	s5,56(sp)
    800031c2:	7b42                	ld	s6,48(sp)
    800031c4:	7ba2                	ld	s7,40(sp)
    800031c6:	6165                	addi	sp,sp,112
    800031c8:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800031ca:	89da                	mv	s3,s6
    800031cc:	bff1                	j	800031a8 <writei+0xec>
    800031ce:	64e6                	ld	s1,88(sp)
    800031d0:	7c02                	ld	s8,32(sp)
    800031d2:	6ce2                	ld	s9,24(sp)
    800031d4:	6d42                	ld	s10,16(sp)
    800031d6:	6da2                	ld	s11,8(sp)
    800031d8:	bfc1                	j	800031a8 <writei+0xec>
  if (off > ip->size || off + n < off) return -1;
    800031da:	557d                	li	a0,-1
}
    800031dc:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800031de:	557d                	li	a0,-1
    800031e0:	bfe1                	j	800031b8 <writei+0xfc>
  if (off + n > MAXFILE * BSIZE) return -1;
    800031e2:	557d                	li	a0,-1
    800031e4:	bfd1                	j	800031b8 <writei+0xfc>

00000000800031e6 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    800031e6:	1141                	addi	sp,sp,-16
    800031e8:	e406                	sd	ra,8(sp)
    800031ea:	e022                	sd	s0,0(sp)
    800031ec:	0800                	addi	s0,sp,16
    800031ee:	4639                	li	a2,14
    800031f0:	ffffd097          	auipc	ra,0xffffd
    800031f4:	05a080e7          	jalr	90(ra) # 8000024a <strncmp>
    800031f8:	60a2                	ld	ra,8(sp)
    800031fa:	6402                	ld	s0,0(sp)
    800031fc:	0141                	addi	sp,sp,16
    800031fe:	8082                	ret

0000000080003200 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003200:	7139                	addi	sp,sp,-64
    80003202:	fc06                	sd	ra,56(sp)
    80003204:	f822                	sd	s0,48(sp)
    80003206:	f426                	sd	s1,40(sp)
    80003208:	f04a                	sd	s2,32(sp)
    8000320a:	ec4e                	sd	s3,24(sp)
    8000320c:	e852                	sd	s4,16(sp)
    8000320e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003210:	04451703          	lh	a4,68(a0)
    80003214:	4785                	li	a5,1
    80003216:	00f71a63          	bne	a4,a5,8000322a <dirlookup+0x2a>
    8000321a:	892a                	mv	s2,a0
    8000321c:	89ae                	mv	s3,a1
    8000321e:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003220:	457c                	lw	a5,76(a0)
    80003222:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003224:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003226:	e79d                	bnez	a5,80003254 <dirlookup+0x54>
    80003228:	a8a5                	j	800032a0 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000322a:	00005517          	auipc	a0,0x5
    8000322e:	28e50513          	addi	a0,a0,654 # 800084b8 <etext+0x4b8>
    80003232:	00003097          	auipc	ra,0x3
    80003236:	c90080e7          	jalr	-880(ra) # 80005ec2 <panic>
      panic("dirlookup read");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	29650513          	addi	a0,a0,662 # 800084d0 <etext+0x4d0>
    80003242:	00003097          	auipc	ra,0x3
    80003246:	c80080e7          	jalr	-896(ra) # 80005ec2 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000324a:	24c1                	addiw	s1,s1,16
    8000324c:	04c92783          	lw	a5,76(s2)
    80003250:	04f4f763          	bgeu	s1,a5,8000329e <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003254:	4741                	li	a4,16
    80003256:	86a6                	mv	a3,s1
    80003258:	fc040613          	addi	a2,s0,-64
    8000325c:	4581                	li	a1,0
    8000325e:	854a                	mv	a0,s2
    80003260:	00000097          	auipc	ra,0x0
    80003264:	d4c080e7          	jalr	-692(ra) # 80002fac <readi>
    80003268:	47c1                	li	a5,16
    8000326a:	fcf518e3          	bne	a0,a5,8000323a <dirlookup+0x3a>
    if (de.inum == 0) continue;
    8000326e:	fc045783          	lhu	a5,-64(s0)
    80003272:	dfe1                	beqz	a5,8000324a <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80003274:	fc240593          	addi	a1,s0,-62
    80003278:	854e                	mv	a0,s3
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	f6c080e7          	jalr	-148(ra) # 800031e6 <namecmp>
    80003282:	f561                	bnez	a0,8000324a <dirlookup+0x4a>
      if (poff) *poff = off;
    80003284:	000a0463          	beqz	s4,8000328c <dirlookup+0x8c>
    80003288:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000328c:	fc045583          	lhu	a1,-64(s0)
    80003290:	00092503          	lw	a0,0(s2)
    80003294:	fffff097          	auipc	ra,0xfffff
    80003298:	720080e7          	jalr	1824(ra) # 800029b4 <iget>
    8000329c:	a011                	j	800032a0 <dirlookup+0xa0>
  return 0;
    8000329e:	4501                	li	a0,0
}
    800032a0:	70e2                	ld	ra,56(sp)
    800032a2:	7442                	ld	s0,48(sp)
    800032a4:	74a2                	ld	s1,40(sp)
    800032a6:	7902                	ld	s2,32(sp)
    800032a8:	69e2                	ld	s3,24(sp)
    800032aa:	6a42                	ld	s4,16(sp)
    800032ac:	6121                	addi	sp,sp,64
    800032ae:	8082                	ret

00000000800032b0 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800032b0:	711d                	addi	sp,sp,-96
    800032b2:	ec86                	sd	ra,88(sp)
    800032b4:	e8a2                	sd	s0,80(sp)
    800032b6:	e4a6                	sd	s1,72(sp)
    800032b8:	e0ca                	sd	s2,64(sp)
    800032ba:	fc4e                	sd	s3,56(sp)
    800032bc:	f852                	sd	s4,48(sp)
    800032be:	f456                	sd	s5,40(sp)
    800032c0:	f05a                	sd	s6,32(sp)
    800032c2:	ec5e                	sd	s7,24(sp)
    800032c4:	e862                	sd	s8,16(sp)
    800032c6:	e466                	sd	s9,8(sp)
    800032c8:	1080                	addi	s0,sp,96
    800032ca:	84aa                	mv	s1,a0
    800032cc:	8b2e                	mv	s6,a1
    800032ce:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800032d0:	00054703          	lbu	a4,0(a0)
    800032d4:	02f00793          	li	a5,47
    800032d8:	02f70263          	beq	a4,a5,800032fc <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	c2a080e7          	jalr	-982(ra) # 80000f06 <myproc>
    800032e4:	15053503          	ld	a0,336(a0)
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	9ce080e7          	jalr	-1586(ra) # 80002cb6 <idup>
    800032f0:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    800032f2:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800032f6:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800032f8:	4b85                	li	s7,1
    800032fa:	a875                	j	800033b6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800032fc:	4585                	li	a1,1
    800032fe:	4505                	li	a0,1
    80003300:	fffff097          	auipc	ra,0xfffff
    80003304:	6b4080e7          	jalr	1716(ra) # 800029b4 <iget>
    80003308:	8a2a                	mv	s4,a0
    8000330a:	b7e5                	j	800032f2 <namex+0x42>
      iunlockput(ip);
    8000330c:	8552                	mv	a0,s4
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	c4c080e7          	jalr	-948(ra) # 80002f5a <iunlockput>
      return 0;
    80003316:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003318:	8552                	mv	a0,s4
    8000331a:	60e6                	ld	ra,88(sp)
    8000331c:	6446                	ld	s0,80(sp)
    8000331e:	64a6                	ld	s1,72(sp)
    80003320:	6906                	ld	s2,64(sp)
    80003322:	79e2                	ld	s3,56(sp)
    80003324:	7a42                	ld	s4,48(sp)
    80003326:	7aa2                	ld	s5,40(sp)
    80003328:	7b02                	ld	s6,32(sp)
    8000332a:	6be2                	ld	s7,24(sp)
    8000332c:	6c42                	ld	s8,16(sp)
    8000332e:	6ca2                	ld	s9,8(sp)
    80003330:	6125                	addi	sp,sp,96
    80003332:	8082                	ret
      iunlock(ip);
    80003334:	8552                	mv	a0,s4
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	a84080e7          	jalr	-1404(ra) # 80002dba <iunlock>
      return ip;
    8000333e:	bfe9                	j	80003318 <namex+0x68>
      iunlockput(ip);
    80003340:	8552                	mv	a0,s4
    80003342:	00000097          	auipc	ra,0x0
    80003346:	c18080e7          	jalr	-1000(ra) # 80002f5a <iunlockput>
      return 0;
    8000334a:	8a4e                	mv	s4,s3
    8000334c:	b7f1                	j	80003318 <namex+0x68>
  len = path - s;
    8000334e:	40998633          	sub	a2,s3,s1
    80003352:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80003356:	099c5863          	bge	s8,s9,800033e6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000335a:	4639                	li	a2,14
    8000335c:	85a6                	mv	a1,s1
    8000335e:	8556                	mv	a0,s5
    80003360:	ffffd097          	auipc	ra,0xffffd
    80003364:	e76080e7          	jalr	-394(ra) # 800001d6 <memmove>
    80003368:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	01279763          	bne	a5,s2,8000337c <namex+0xcc>
    80003372:	0485                	addi	s1,s1,1
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	ff278de3          	beq	a5,s2,80003372 <namex+0xc2>
    ilock(ip);
    8000337c:	8552                	mv	a0,s4
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	976080e7          	jalr	-1674(ra) # 80002cf4 <ilock>
    if (ip->type != T_DIR) {
    80003386:	044a1783          	lh	a5,68(s4)
    8000338a:	f97791e3          	bne	a5,s7,8000330c <namex+0x5c>
    if (nameiparent && *path == '\0') {
    8000338e:	000b0563          	beqz	s6,80003398 <namex+0xe8>
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	dfd9                	beqz	a5,80003334 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003398:	4601                	li	a2,0
    8000339a:	85d6                	mv	a1,s5
    8000339c:	8552                	mv	a0,s4
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	e62080e7          	jalr	-414(ra) # 80003200 <dirlookup>
    800033a6:	89aa                	mv	s3,a0
    800033a8:	dd41                	beqz	a0,80003340 <namex+0x90>
    iunlockput(ip);
    800033aa:	8552                	mv	a0,s4
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	bae080e7          	jalr	-1106(ra) # 80002f5a <iunlockput>
    ip = next;
    800033b4:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	01279763          	bne	a5,s2,800033c8 <namex+0x118>
    800033be:	0485                	addi	s1,s1,1
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	ff278de3          	beq	a5,s2,800033be <namex+0x10e>
  if (*path == 0) return 0;
    800033c8:	cb9d                	beqz	a5,800033fe <namex+0x14e>
  while (*path != '/' && *path != 0) path++;
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	89a6                	mv	s3,s1
  len = path - s;
    800033d0:	4c81                	li	s9,0
    800033d2:	4601                	li	a2,0
  while (*path != '/' && *path != 0) path++;
    800033d4:	01278963          	beq	a5,s2,800033e6 <namex+0x136>
    800033d8:	dbbd                	beqz	a5,8000334e <namex+0x9e>
    800033da:	0985                	addi	s3,s3,1
    800033dc:	0009c783          	lbu	a5,0(s3)
    800033e0:	ff279ce3          	bne	a5,s2,800033d8 <namex+0x128>
    800033e4:	b7ad                	j	8000334e <namex+0x9e>
    memmove(name, s, len);
    800033e6:	2601                	sext.w	a2,a2
    800033e8:	85a6                	mv	a1,s1
    800033ea:	8556                	mv	a0,s5
    800033ec:	ffffd097          	auipc	ra,0xffffd
    800033f0:	dea080e7          	jalr	-534(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033f4:	9cd6                	add	s9,s9,s5
    800033f6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800033fa:	84ce                	mv	s1,s3
    800033fc:	b7bd                	j	8000336a <namex+0xba>
  if (nameiparent) {
    800033fe:	f00b0de3          	beqz	s6,80003318 <namex+0x68>
    iput(ip);
    80003402:	8552                	mv	a0,s4
    80003404:	00000097          	auipc	ra,0x0
    80003408:	aae080e7          	jalr	-1362(ra) # 80002eb2 <iput>
    return 0;
    8000340c:	4a01                	li	s4,0
    8000340e:	b729                	j	80003318 <namex+0x68>

0000000080003410 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80003410:	7139                	addi	sp,sp,-64
    80003412:	fc06                	sd	ra,56(sp)
    80003414:	f822                	sd	s0,48(sp)
    80003416:	f04a                	sd	s2,32(sp)
    80003418:	ec4e                	sd	s3,24(sp)
    8000341a:	e852                	sd	s4,16(sp)
    8000341c:	0080                	addi	s0,sp,64
    8000341e:	892a                	mv	s2,a0
    80003420:	8a2e                	mv	s4,a1
    80003422:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003424:	4601                	li	a2,0
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	dda080e7          	jalr	-550(ra) # 80003200 <dirlookup>
    8000342e:	ed25                	bnez	a0,800034a6 <dirlink+0x96>
    80003430:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003432:	04c92483          	lw	s1,76(s2)
    80003436:	c49d                	beqz	s1,80003464 <dirlink+0x54>
    80003438:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000343a:	4741                	li	a4,16
    8000343c:	86a6                	mv	a3,s1
    8000343e:	fc040613          	addi	a2,s0,-64
    80003442:	4581                	li	a1,0
    80003444:	854a                	mv	a0,s2
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	b66080e7          	jalr	-1178(ra) # 80002fac <readi>
    8000344e:	47c1                	li	a5,16
    80003450:	06f51163          	bne	a0,a5,800034b2 <dirlink+0xa2>
    if (de.inum == 0) break;
    80003454:	fc045783          	lhu	a5,-64(s0)
    80003458:	c791                	beqz	a5,80003464 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000345a:	24c1                	addiw	s1,s1,16
    8000345c:	04c92783          	lw	a5,76(s2)
    80003460:	fcf4ede3          	bltu	s1,a5,8000343a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003464:	4639                	li	a2,14
    80003466:	85d2                	mv	a1,s4
    80003468:	fc240513          	addi	a0,s0,-62
    8000346c:	ffffd097          	auipc	ra,0xffffd
    80003470:	e14080e7          	jalr	-492(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003474:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    80003478:	4741                	li	a4,16
    8000347a:	86a6                	mv	a3,s1
    8000347c:	fc040613          	addi	a2,s0,-64
    80003480:	4581                	li	a1,0
    80003482:	854a                	mv	a0,s2
    80003484:	00000097          	auipc	ra,0x0
    80003488:	c38080e7          	jalr	-968(ra) # 800030bc <writei>
    8000348c:	1541                	addi	a0,a0,-16
    8000348e:	00a03533          	snez	a0,a0
    80003492:	40a00533          	neg	a0,a0
    80003496:	74a2                	ld	s1,40(sp)
}
    80003498:	70e2                	ld	ra,56(sp)
    8000349a:	7442                	ld	s0,48(sp)
    8000349c:	7902                	ld	s2,32(sp)
    8000349e:	69e2                	ld	s3,24(sp)
    800034a0:	6a42                	ld	s4,16(sp)
    800034a2:	6121                	addi	sp,sp,64
    800034a4:	8082                	ret
    iput(ip);
    800034a6:	00000097          	auipc	ra,0x0
    800034aa:	a0c080e7          	jalr	-1524(ra) # 80002eb2 <iput>
    return -1;
    800034ae:	557d                	li	a0,-1
    800034b0:	b7e5                	j	80003498 <dirlink+0x88>
      panic("dirlink read");
    800034b2:	00005517          	auipc	a0,0x5
    800034b6:	02e50513          	addi	a0,a0,46 # 800084e0 <etext+0x4e0>
    800034ba:	00003097          	auipc	ra,0x3
    800034be:	a08080e7          	jalr	-1528(ra) # 80005ec2 <panic>

00000000800034c2 <namei>:

struct inode *namei(char *path) {
    800034c2:	1101                	addi	sp,sp,-32
    800034c4:	ec06                	sd	ra,24(sp)
    800034c6:	e822                	sd	s0,16(sp)
    800034c8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034ca:	fe040613          	addi	a2,s0,-32
    800034ce:	4581                	li	a1,0
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	de0080e7          	jalr	-544(ra) # 800032b0 <namex>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	6105                	addi	sp,sp,32
    800034de:	8082                	ret

00000000800034e0 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800034e0:	1141                	addi	sp,sp,-16
    800034e2:	e406                	sd	ra,8(sp)
    800034e4:	e022                	sd	s0,0(sp)
    800034e6:	0800                	addi	s0,sp,16
    800034e8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034ea:	4585                	li	a1,1
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	dc4080e7          	jalr	-572(ra) # 800032b0 <namex>
}
    800034f4:	60a2                	ld	ra,8(sp)
    800034f6:	6402                	ld	s0,0(sp)
    800034f8:	0141                	addi	sp,sp,16
    800034fa:	8082                	ret

00000000800034fc <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	e426                	sd	s1,8(sp)
    80003504:	e04a                	sd	s2,0(sp)
    80003506:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003508:	00018917          	auipc	s2,0x18
    8000350c:	d8890913          	addi	s2,s2,-632 # 8001b290 <log>
    80003510:	01892583          	lw	a1,24(s2)
    80003514:	02892503          	lw	a0,40(s2)
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	fa8080e7          	jalr	-88(ra) # 800024c0 <bread>
    80003520:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003522:	02c92603          	lw	a2,44(s2)
    80003526:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003528:	00c05f63          	blez	a2,80003546 <write_head+0x4a>
    8000352c:	00018717          	auipc	a4,0x18
    80003530:	d9470713          	addi	a4,a4,-620 # 8001b2c0 <log+0x30>
    80003534:	87aa                	mv	a5,a0
    80003536:	060a                	slli	a2,a2,0x2
    80003538:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000353a:	4314                	lw	a3,0(a4)
    8000353c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	0711                	addi	a4,a4,4
    80003540:	0791                	addi	a5,a5,4
    80003542:	fec79ce3          	bne	a5,a2,8000353a <write_head+0x3e>
  }
  bwrite(buf);
    80003546:	8526                	mv	a0,s1
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	06a080e7          	jalr	106(ra) # 800025b2 <bwrite>
  brelse(buf);
    80003550:	8526                	mv	a0,s1
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	09e080e7          	jalr	158(ra) # 800025f0 <brelse>
}
    8000355a:	60e2                	ld	ra,24(sp)
    8000355c:	6442                	ld	s0,16(sp)
    8000355e:	64a2                	ld	s1,8(sp)
    80003560:	6902                	ld	s2,0(sp)
    80003562:	6105                	addi	sp,sp,32
    80003564:	8082                	ret

0000000080003566 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003566:	00018797          	auipc	a5,0x18
    8000356a:	d567a783          	lw	a5,-682(a5) # 8001b2bc <log+0x2c>
    8000356e:	0af05d63          	blez	a5,80003628 <install_trans+0xc2>
static void install_trans(int recovering) {
    80003572:	7139                	addi	sp,sp,-64
    80003574:	fc06                	sd	ra,56(sp)
    80003576:	f822                	sd	s0,48(sp)
    80003578:	f426                	sd	s1,40(sp)
    8000357a:	f04a                	sd	s2,32(sp)
    8000357c:	ec4e                	sd	s3,24(sp)
    8000357e:	e852                	sd	s4,16(sp)
    80003580:	e456                	sd	s5,8(sp)
    80003582:	e05a                	sd	s6,0(sp)
    80003584:	0080                	addi	s0,sp,64
    80003586:	8b2a                	mv	s6,a0
    80003588:	00018a97          	auipc	s5,0x18
    8000358c:	d38a8a93          	addi	s5,s5,-712 # 8001b2c0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003590:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003592:	00018997          	auipc	s3,0x18
    80003596:	cfe98993          	addi	s3,s3,-770 # 8001b290 <log>
    8000359a:	a00d                	j	800035bc <install_trans+0x56>
    brelse(lbuf);
    8000359c:	854a                	mv	a0,s2
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	052080e7          	jalr	82(ra) # 800025f0 <brelse>
    brelse(dbuf);
    800035a6:	8526                	mv	a0,s1
    800035a8:	fffff097          	auipc	ra,0xfffff
    800035ac:	048080e7          	jalr	72(ra) # 800025f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b0:	2a05                	addiw	s4,s4,1
    800035b2:	0a91                	addi	s5,s5,4
    800035b4:	02c9a783          	lw	a5,44(s3)
    800035b8:	04fa5e63          	bge	s4,a5,80003614 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800035bc:	0189a583          	lw	a1,24(s3)
    800035c0:	014585bb          	addw	a1,a1,s4
    800035c4:	2585                	addiw	a1,a1,1
    800035c6:	0289a503          	lw	a0,40(s3)
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	ef6080e7          	jalr	-266(ra) # 800024c0 <bread>
    800035d2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800035d4:	000aa583          	lw	a1,0(s5)
    800035d8:	0289a503          	lw	a0,40(s3)
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	ee4080e7          	jalr	-284(ra) # 800024c0 <bread>
    800035e4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e6:	40000613          	li	a2,1024
    800035ea:	05890593          	addi	a1,s2,88
    800035ee:	05850513          	addi	a0,a0,88
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	be4080e7          	jalr	-1052(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    800035fa:	8526                	mv	a0,s1
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	fb6080e7          	jalr	-74(ra) # 800025b2 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003604:	f80b1ce3          	bnez	s6,8000359c <install_trans+0x36>
    80003608:	8526                	mv	a0,s1
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	0be080e7          	jalr	190(ra) # 800026c8 <bunpin>
    80003612:	b769                	j	8000359c <install_trans+0x36>
}
    80003614:	70e2                	ld	ra,56(sp)
    80003616:	7442                	ld	s0,48(sp)
    80003618:	74a2                	ld	s1,40(sp)
    8000361a:	7902                	ld	s2,32(sp)
    8000361c:	69e2                	ld	s3,24(sp)
    8000361e:	6a42                	ld	s4,16(sp)
    80003620:	6aa2                	ld	s5,8(sp)
    80003622:	6b02                	ld	s6,0(sp)
    80003624:	6121                	addi	sp,sp,64
    80003626:	8082                	ret
    80003628:	8082                	ret

000000008000362a <initlog>:
void initlog(int dev, struct superblock *sb) {
    8000362a:	7179                	addi	sp,sp,-48
    8000362c:	f406                	sd	ra,40(sp)
    8000362e:	f022                	sd	s0,32(sp)
    80003630:	ec26                	sd	s1,24(sp)
    80003632:	e84a                	sd	s2,16(sp)
    80003634:	e44e                	sd	s3,8(sp)
    80003636:	1800                	addi	s0,sp,48
    80003638:	892a                	mv	s2,a0
    8000363a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000363c:	00018497          	auipc	s1,0x18
    80003640:	c5448493          	addi	s1,s1,-940 # 8001b290 <log>
    80003644:	00005597          	auipc	a1,0x5
    80003648:	eac58593          	addi	a1,a1,-340 # 800084f0 <etext+0x4f0>
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	d5e080e7          	jalr	-674(ra) # 800063ac <initlock>
  log.start = sb->logstart;
    80003656:	0149a583          	lw	a1,20(s3)
    8000365a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000365c:	0109a783          	lw	a5,16(s3)
    80003660:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003662:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003666:	854a                	mv	a0,s2
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	e58080e7          	jalr	-424(ra) # 800024c0 <bread>
  log.lh.n = lh->n;
    80003670:	4d30                	lw	a2,88(a0)
    80003672:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003674:	00c05f63          	blez	a2,80003692 <initlog+0x68>
    80003678:	87aa                	mv	a5,a0
    8000367a:	00018717          	auipc	a4,0x18
    8000367e:	c4670713          	addi	a4,a4,-954 # 8001b2c0 <log+0x30>
    80003682:	060a                	slli	a2,a2,0x2
    80003684:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003686:	4ff4                	lw	a3,92(a5)
    80003688:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000368a:	0791                	addi	a5,a5,4
    8000368c:	0711                	addi	a4,a4,4
    8000368e:	fec79ce3          	bne	a5,a2,80003686 <initlog+0x5c>
  brelse(buf);
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	f5e080e7          	jalr	-162(ra) # 800025f0 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    8000369a:	4505                	li	a0,1
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	eca080e7          	jalr	-310(ra) # 80003566 <install_trans>
  log.lh.n = 0;
    800036a4:	00018797          	auipc	a5,0x18
    800036a8:	c007ac23          	sw	zero,-1000(a5) # 8001b2bc <log+0x2c>
  write_head();  // clear the log
    800036ac:	00000097          	auipc	ra,0x0
    800036b0:	e50080e7          	jalr	-432(ra) # 800034fc <write_head>
}
    800036b4:	70a2                	ld	ra,40(sp)
    800036b6:	7402                	ld	s0,32(sp)
    800036b8:	64e2                	ld	s1,24(sp)
    800036ba:	6942                	ld	s2,16(sp)
    800036bc:	69a2                	ld	s3,8(sp)
    800036be:	6145                	addi	sp,sp,48
    800036c0:	8082                	ret

00000000800036c2 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800036c2:	1101                	addi	sp,sp,-32
    800036c4:	ec06                	sd	ra,24(sp)
    800036c6:	e822                	sd	s0,16(sp)
    800036c8:	e426                	sd	s1,8(sp)
    800036ca:	e04a                	sd	s2,0(sp)
    800036cc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036ce:	00018517          	auipc	a0,0x18
    800036d2:	bc250513          	addi	a0,a0,-1086 # 8001b290 <log>
    800036d6:	00003097          	auipc	ra,0x3
    800036da:	d66080e7          	jalr	-666(ra) # 8000643c <acquire>
  while (1) {
    if (log.committing) {
    800036de:	00018497          	auipc	s1,0x18
    800036e2:	bb248493          	addi	s1,s1,-1102 # 8001b290 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800036e6:	4979                	li	s2,30
    800036e8:	a039                	j	800036f6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036ea:	85a6                	mv	a1,s1
    800036ec:	8526                	mv	a0,s1
    800036ee:	ffffe097          	auipc	ra,0xffffe
    800036f2:	ec6080e7          	jalr	-314(ra) # 800015b4 <sleep>
    if (log.committing) {
    800036f6:	50dc                	lw	a5,36(s1)
    800036f8:	fbed                	bnez	a5,800036ea <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800036fa:	5098                	lw	a4,32(s1)
    800036fc:	2705                	addiw	a4,a4,1
    800036fe:	0027179b          	slliw	a5,a4,0x2
    80003702:	9fb9                	addw	a5,a5,a4
    80003704:	0017979b          	slliw	a5,a5,0x1
    80003708:	54d4                	lw	a3,44(s1)
    8000370a:	9fb5                	addw	a5,a5,a3
    8000370c:	00f95963          	bge	s2,a5,8000371e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003710:	85a6                	mv	a1,s1
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	ea0080e7          	jalr	-352(ra) # 800015b4 <sleep>
    8000371c:	bfe9                	j	800036f6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000371e:	00018517          	auipc	a0,0x18
    80003722:	b7250513          	addi	a0,a0,-1166 # 8001b290 <log>
    80003726:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	dc8080e7          	jalr	-568(ra) # 800064f0 <release>
      break;
    }
  }
}
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6902                	ld	s2,0(sp)
    80003738:	6105                	addi	sp,sp,32
    8000373a:	8082                	ret

000000008000373c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    8000373c:	7139                	addi	sp,sp,-64
    8000373e:	fc06                	sd	ra,56(sp)
    80003740:	f822                	sd	s0,48(sp)
    80003742:	f426                	sd	s1,40(sp)
    80003744:	f04a                	sd	s2,32(sp)
    80003746:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003748:	00018497          	auipc	s1,0x18
    8000374c:	b4848493          	addi	s1,s1,-1208 # 8001b290 <log>
    80003750:	8526                	mv	a0,s1
    80003752:	00003097          	auipc	ra,0x3
    80003756:	cea080e7          	jalr	-790(ra) # 8000643c <acquire>
  log.outstanding -= 1;
    8000375a:	509c                	lw	a5,32(s1)
    8000375c:	37fd                	addiw	a5,a5,-1
    8000375e:	0007891b          	sext.w	s2,a5
    80003762:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    80003764:	50dc                	lw	a5,36(s1)
    80003766:	e7b9                	bnez	a5,800037b4 <end_op+0x78>
  if (log.outstanding == 0) {
    80003768:	06091163          	bnez	s2,800037ca <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000376c:	00018497          	auipc	s1,0x18
    80003770:	b2448493          	addi	s1,s1,-1244 # 8001b290 <log>
    80003774:	4785                	li	a5,1
    80003776:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003778:	8526                	mv	a0,s1
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	d76080e7          	jalr	-650(ra) # 800064f0 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    80003782:	54dc                	lw	a5,44(s1)
    80003784:	06f04763          	bgtz	a5,800037f2 <end_op+0xb6>
    acquire(&log.lock);
    80003788:	00018497          	auipc	s1,0x18
    8000378c:	b0848493          	addi	s1,s1,-1272 # 8001b290 <log>
    80003790:	8526                	mv	a0,s1
    80003792:	00003097          	auipc	ra,0x3
    80003796:	caa080e7          	jalr	-854(ra) # 8000643c <acquire>
    log.committing = 0;
    8000379a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000379e:	8526                	mv	a0,s1
    800037a0:	ffffe097          	auipc	ra,0xffffe
    800037a4:	e78080e7          	jalr	-392(ra) # 80001618 <wakeup>
    release(&log.lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	d46080e7          	jalr	-698(ra) # 800064f0 <release>
}
    800037b2:	a815                	j	800037e6 <end_op+0xaa>
    800037b4:	ec4e                	sd	s3,24(sp)
    800037b6:	e852                	sd	s4,16(sp)
    800037b8:	e456                	sd	s5,8(sp)
  if (log.committing) panic("log.committing");
    800037ba:	00005517          	auipc	a0,0x5
    800037be:	d3e50513          	addi	a0,a0,-706 # 800084f8 <etext+0x4f8>
    800037c2:	00002097          	auipc	ra,0x2
    800037c6:	700080e7          	jalr	1792(ra) # 80005ec2 <panic>
    wakeup(&log);
    800037ca:	00018497          	auipc	s1,0x18
    800037ce:	ac648493          	addi	s1,s1,-1338 # 8001b290 <log>
    800037d2:	8526                	mv	a0,s1
    800037d4:	ffffe097          	auipc	ra,0xffffe
    800037d8:	e44080e7          	jalr	-444(ra) # 80001618 <wakeup>
  release(&log.lock);
    800037dc:	8526                	mv	a0,s1
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	d12080e7          	jalr	-750(ra) # 800064f0 <release>
}
    800037e6:	70e2                	ld	ra,56(sp)
    800037e8:	7442                	ld	s0,48(sp)
    800037ea:	74a2                	ld	s1,40(sp)
    800037ec:	7902                	ld	s2,32(sp)
    800037ee:	6121                	addi	sp,sp,64
    800037f0:	8082                	ret
    800037f2:	ec4e                	sd	s3,24(sp)
    800037f4:	e852                	sd	s4,16(sp)
    800037f6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f8:	00018a97          	auipc	s5,0x18
    800037fc:	ac8a8a93          	addi	s5,s5,-1336 # 8001b2c0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    80003800:	00018a17          	auipc	s4,0x18
    80003804:	a90a0a13          	addi	s4,s4,-1392 # 8001b290 <log>
    80003808:	018a2583          	lw	a1,24(s4)
    8000380c:	012585bb          	addw	a1,a1,s2
    80003810:	2585                	addiw	a1,a1,1
    80003812:	028a2503          	lw	a0,40(s4)
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	caa080e7          	jalr	-854(ra) # 800024c0 <bread>
    8000381e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003820:	000aa583          	lw	a1,0(s5)
    80003824:	028a2503          	lw	a0,40(s4)
    80003828:	fffff097          	auipc	ra,0xfffff
    8000382c:	c98080e7          	jalr	-872(ra) # 800024c0 <bread>
    80003830:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003832:	40000613          	li	a2,1024
    80003836:	05850593          	addi	a1,a0,88
    8000383a:	05848513          	addi	a0,s1,88
    8000383e:	ffffd097          	auipc	ra,0xffffd
    80003842:	998080e7          	jalr	-1640(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003846:	8526                	mv	a0,s1
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	d6a080e7          	jalr	-662(ra) # 800025b2 <bwrite>
    brelse(from);
    80003850:	854e                	mv	a0,s3
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	d9e080e7          	jalr	-610(ra) # 800025f0 <brelse>
    brelse(to);
    8000385a:	8526                	mv	a0,s1
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	d94080e7          	jalr	-620(ra) # 800025f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003864:	2905                	addiw	s2,s2,1
    80003866:	0a91                	addi	s5,s5,4
    80003868:	02ca2783          	lw	a5,44(s4)
    8000386c:	f8f94ee3          	blt	s2,a5,80003808 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    80003870:	00000097          	auipc	ra,0x0
    80003874:	c8c080e7          	jalr	-884(ra) # 800034fc <write_head>
    install_trans(0);  // Now install writes to home locations
    80003878:	4501                	li	a0,0
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	cec080e7          	jalr	-788(ra) # 80003566 <install_trans>
    log.lh.n = 0;
    80003882:	00018797          	auipc	a5,0x18
    80003886:	a207ad23          	sw	zero,-1478(a5) # 8001b2bc <log+0x2c>
    write_head();  // Erase the transaction from the log
    8000388a:	00000097          	auipc	ra,0x0
    8000388e:	c72080e7          	jalr	-910(ra) # 800034fc <write_head>
    80003892:	69e2                	ld	s3,24(sp)
    80003894:	6a42                	ld	s4,16(sp)
    80003896:	6aa2                	ld	s5,8(sp)
    80003898:	bdc5                	j	80003788 <end_op+0x4c>

000000008000389a <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	e04a                	sd	s2,0(sp)
    800038a4:	1000                	addi	s0,sp,32
    800038a6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038a8:	00018917          	auipc	s2,0x18
    800038ac:	9e890913          	addi	s2,s2,-1560 # 8001b290 <log>
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	b8a080e7          	jalr	-1142(ra) # 8000643c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ba:	02c92603          	lw	a2,44(s2)
    800038be:	47f5                	li	a5,29
    800038c0:	06c7c563          	blt	a5,a2,8000392a <log_write+0x90>
    800038c4:	00018797          	auipc	a5,0x18
    800038c8:	9e87a783          	lw	a5,-1560(a5) # 8001b2ac <log+0x1c>
    800038cc:	37fd                	addiw	a5,a5,-1
    800038ce:	04f65e63          	bge	a2,a5,8000392a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    800038d2:	00018797          	auipc	a5,0x18
    800038d6:	9de7a783          	lw	a5,-1570(a5) # 8001b2b0 <log+0x20>
    800038da:	06f05063          	blez	a5,8000393a <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    800038de:	4781                	li	a5,0
    800038e0:	06c05563          	blez	a2,8000394a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    800038e4:	44cc                	lw	a1,12(s1)
    800038e6:	00018717          	auipc	a4,0x18
    800038ea:	9da70713          	addi	a4,a4,-1574 # 8001b2c0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038ee:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    800038f0:	4314                	lw	a3,0(a4)
    800038f2:	04b68c63          	beq	a3,a1,8000394a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038f6:	2785                	addiw	a5,a5,1
    800038f8:	0711                	addi	a4,a4,4
    800038fa:	fef61be3          	bne	a2,a5,800038f0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038fe:	0621                	addi	a2,a2,8
    80003900:	060a                	slli	a2,a2,0x2
    80003902:	00018797          	auipc	a5,0x18
    80003906:	98e78793          	addi	a5,a5,-1650 # 8001b290 <log>
    8000390a:	97b2                	add	a5,a5,a2
    8000390c:	44d8                	lw	a4,12(s1)
    8000390e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003910:	8526                	mv	a0,s1
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	d7a080e7          	jalr	-646(ra) # 8000268c <bpin>
    log.lh.n++;
    8000391a:	00018717          	auipc	a4,0x18
    8000391e:	97670713          	addi	a4,a4,-1674 # 8001b290 <log>
    80003922:	575c                	lw	a5,44(a4)
    80003924:	2785                	addiw	a5,a5,1
    80003926:	d75c                	sw	a5,44(a4)
    80003928:	a82d                	j	80003962 <log_write+0xc8>
    panic("too big a transaction");
    8000392a:	00005517          	auipc	a0,0x5
    8000392e:	bde50513          	addi	a0,a0,-1058 # 80008508 <etext+0x508>
    80003932:	00002097          	auipc	ra,0x2
    80003936:	590080e7          	jalr	1424(ra) # 80005ec2 <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	be650513          	addi	a0,a0,-1050 # 80008520 <etext+0x520>
    80003942:	00002097          	auipc	ra,0x2
    80003946:	580080e7          	jalr	1408(ra) # 80005ec2 <panic>
  log.lh.block[i] = b->blockno;
    8000394a:	00878693          	addi	a3,a5,8
    8000394e:	068a                	slli	a3,a3,0x2
    80003950:	00018717          	auipc	a4,0x18
    80003954:	94070713          	addi	a4,a4,-1728 # 8001b290 <log>
    80003958:	9736                	add	a4,a4,a3
    8000395a:	44d4                	lw	a3,12(s1)
    8000395c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000395e:	faf609e3          	beq	a2,a5,80003910 <log_write+0x76>
  }
  release(&log.lock);
    80003962:	00018517          	auipc	a0,0x18
    80003966:	92e50513          	addi	a0,a0,-1746 # 8001b290 <log>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	b86080e7          	jalr	-1146(ra) # 800064f0 <release>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    8000397e:	1101                	addi	sp,sp,-32
    80003980:	ec06                	sd	ra,24(sp)
    80003982:	e822                	sd	s0,16(sp)
    80003984:	e426                	sd	s1,8(sp)
    80003986:	e04a                	sd	s2,0(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
    8000398c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000398e:	00005597          	auipc	a1,0x5
    80003992:	bb258593          	addi	a1,a1,-1102 # 80008540 <etext+0x540>
    80003996:	0521                	addi	a0,a0,8
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	a14080e7          	jalr	-1516(ra) # 800063ac <initlock>
  lk->name = name;
    800039a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a8:	0204a423          	sw	zero,40(s1)
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c6:	00850913          	addi	s2,a0,8
    800039ca:	854a                	mv	a0,s2
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	a70080e7          	jalr	-1424(ra) # 8000643c <acquire>
  while (lk->locked) {
    800039d4:	409c                	lw	a5,0(s1)
    800039d6:	cb89                	beqz	a5,800039e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039d8:	85ca                	mv	a1,s2
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffe097          	auipc	ra,0xffffe
    800039e0:	bd8080e7          	jalr	-1064(ra) # 800015b4 <sleep>
  while (lk->locked) {
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	fbed                	bnez	a5,800039d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039e8:	4785                	li	a5,1
    800039ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ec:	ffffd097          	auipc	ra,0xffffd
    800039f0:	51a080e7          	jalr	1306(ra) # 80000f06 <myproc>
    800039f4:	591c                	lw	a5,48(a0)
    800039f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039f8:	854a                	mv	a0,s2
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	af6080e7          	jalr	-1290(ra) # 800064f0 <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	e04a                	sd	s2,0(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1c:	00850913          	addi	s2,a0,8
    80003a20:	854a                	mv	a0,s2
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	a1a080e7          	jalr	-1510(ra) # 8000643c <acquire>
  lk->locked = 0;
    80003a2a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a2e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffe097          	auipc	ra,0xffffe
    80003a38:	be4080e7          	jalr	-1052(ra) # 80001618 <wakeup>
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	ab2080e7          	jalr	-1358(ra) # 800064f0 <release>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6902                	ld	s2,0(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003a52:	7179                	addi	sp,sp,-48
    80003a54:	f406                	sd	ra,40(sp)
    80003a56:	f022                	sd	s0,32(sp)
    80003a58:	ec26                	sd	s1,24(sp)
    80003a5a:	e84a                	sd	s2,16(sp)
    80003a5c:	1800                	addi	s0,sp,48
    80003a5e:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003a60:	00850913          	addi	s2,a0,8
    80003a64:	854a                	mv	a0,s2
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	9d6080e7          	jalr	-1578(ra) # 8000643c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a6e:	409c                	lw	a5,0(s1)
    80003a70:	ef91                	bnez	a5,80003a8c <holdingsleep+0x3a>
    80003a72:	4481                	li	s1,0
  release(&lk->lk);
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	a7a080e7          	jalr	-1414(ra) # 800064f0 <release>
  return r;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	70a2                	ld	ra,40(sp)
    80003a82:	7402                	ld	s0,32(sp)
    80003a84:	64e2                	ld	s1,24(sp)
    80003a86:	6942                	ld	s2,16(sp)
    80003a88:	6145                	addi	sp,sp,48
    80003a8a:	8082                	ret
    80003a8c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a8e:	0284a983          	lw	s3,40(s1)
    80003a92:	ffffd097          	auipc	ra,0xffffd
    80003a96:	474080e7          	jalr	1140(ra) # 80000f06 <myproc>
    80003a9a:	5904                	lw	s1,48(a0)
    80003a9c:	413484b3          	sub	s1,s1,s3
    80003aa0:	0014b493          	seqz	s1,s1
    80003aa4:	69a2                	ld	s3,8(sp)
    80003aa6:	b7f9                	j	80003a74 <holdingsleep+0x22>

0000000080003aa8 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003aa8:	1141                	addi	sp,sp,-16
    80003aaa:	e406                	sd	ra,8(sp)
    80003aac:	e022                	sd	s0,0(sp)
    80003aae:	0800                	addi	s0,sp,16
    80003ab0:	00005597          	auipc	a1,0x5
    80003ab4:	aa058593          	addi	a1,a1,-1376 # 80008550 <etext+0x550>
    80003ab8:	00018517          	auipc	a0,0x18
    80003abc:	92050513          	addi	a0,a0,-1760 # 8001b3d8 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	8ec080e7          	jalr	-1812(ra) # 800063ac <initlock>
    80003ac8:	60a2                	ld	ra,8(sp)
    80003aca:	6402                	ld	s0,0(sp)
    80003acc:	0141                	addi	sp,sp,16
    80003ace:	8082                	ret

0000000080003ad0 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003ad0:	1101                	addi	sp,sp,-32
    80003ad2:	ec06                	sd	ra,24(sp)
    80003ad4:	e822                	sd	s0,16(sp)
    80003ad6:	e426                	sd	s1,8(sp)
    80003ad8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ada:	00018517          	auipc	a0,0x18
    80003ade:	8fe50513          	addi	a0,a0,-1794 # 8001b3d8 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	95a080e7          	jalr	-1702(ra) # 8000643c <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003aea:	00018497          	auipc	s1,0x18
    80003aee:	90648493          	addi	s1,s1,-1786 # 8001b3f0 <ftable+0x18>
    80003af2:	00019717          	auipc	a4,0x19
    80003af6:	89e70713          	addi	a4,a4,-1890 # 8001c390 <disk>
    if (f->ref == 0) {
    80003afa:	40dc                	lw	a5,4(s1)
    80003afc:	cf99                	beqz	a5,80003b1a <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003afe:	02848493          	addi	s1,s1,40
    80003b02:	fee49ce3          	bne	s1,a4,80003afa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b06:	00018517          	auipc	a0,0x18
    80003b0a:	8d250513          	addi	a0,a0,-1838 # 8001b3d8 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	9e2080e7          	jalr	-1566(ra) # 800064f0 <release>
  return 0;
    80003b16:	4481                	li	s1,0
    80003b18:	a819                	j	80003b2e <filealloc+0x5e>
      f->ref = 1;
    80003b1a:	4785                	li	a5,1
    80003b1c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b1e:	00018517          	auipc	a0,0x18
    80003b22:	8ba50513          	addi	a0,a0,-1862 # 8001b3d8 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	9ca080e7          	jalr	-1590(ra) # 800064f0 <release>
}
    80003b2e:	8526                	mv	a0,s1
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret

0000000080003b3a <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	e426                	sd	s1,8(sp)
    80003b42:	1000                	addi	s0,sp,32
    80003b44:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b46:	00018517          	auipc	a0,0x18
    80003b4a:	89250513          	addi	a0,a0,-1902 # 8001b3d8 <ftable>
    80003b4e:	00003097          	auipc	ra,0x3
    80003b52:	8ee080e7          	jalr	-1810(ra) # 8000643c <acquire>
  if (f->ref < 1) panic("filedup");
    80003b56:	40dc                	lw	a5,4(s1)
    80003b58:	02f05263          	blez	a5,80003b7c <filedup+0x42>
  f->ref++;
    80003b5c:	2785                	addiw	a5,a5,1
    80003b5e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b60:	00018517          	auipc	a0,0x18
    80003b64:	87850513          	addi	a0,a0,-1928 # 8001b3d8 <ftable>
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	988080e7          	jalr	-1656(ra) # 800064f0 <release>
  return f;
}
    80003b70:	8526                	mv	a0,s1
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	64a2                	ld	s1,8(sp)
    80003b78:	6105                	addi	sp,sp,32
    80003b7a:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	9dc50513          	addi	a0,a0,-1572 # 80008558 <etext+0x558>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	33e080e7          	jalr	830(ra) # 80005ec2 <panic>

0000000080003b8c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003b8c:	7139                	addi	sp,sp,-64
    80003b8e:	fc06                	sd	ra,56(sp)
    80003b90:	f822                	sd	s0,48(sp)
    80003b92:	f426                	sd	s1,40(sp)
    80003b94:	0080                	addi	s0,sp,64
    80003b96:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b98:	00018517          	auipc	a0,0x18
    80003b9c:	84050513          	addi	a0,a0,-1984 # 8001b3d8 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	89c080e7          	jalr	-1892(ra) # 8000643c <acquire>
  if (f->ref < 1) panic("fileclose");
    80003ba8:	40dc                	lw	a5,4(s1)
    80003baa:	04f05c63          	blez	a5,80003c02 <fileclose+0x76>
  if (--f->ref > 0) {
    80003bae:	37fd                	addiw	a5,a5,-1
    80003bb0:	0007871b          	sext.w	a4,a5
    80003bb4:	c0dc                	sw	a5,4(s1)
    80003bb6:	06e04263          	bgtz	a4,80003c1a <fileclose+0x8e>
    80003bba:	f04a                	sd	s2,32(sp)
    80003bbc:	ec4e                	sd	s3,24(sp)
    80003bbe:	e852                	sd	s4,16(sp)
    80003bc0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bc2:	0004a903          	lw	s2,0(s1)
    80003bc6:	0094ca83          	lbu	s5,9(s1)
    80003bca:	0104ba03          	ld	s4,16(s1)
    80003bce:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bd2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bd6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bda:	00017517          	auipc	a0,0x17
    80003bde:	7fe50513          	addi	a0,a0,2046 # 8001b3d8 <ftable>
    80003be2:	00003097          	auipc	ra,0x3
    80003be6:	90e080e7          	jalr	-1778(ra) # 800064f0 <release>

  if (ff.type == FD_PIPE) {
    80003bea:	4785                	li	a5,1
    80003bec:	04f90463          	beq	s2,a5,80003c34 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003bf0:	3979                	addiw	s2,s2,-2
    80003bf2:	4785                	li	a5,1
    80003bf4:	0527fb63          	bgeu	a5,s2,80003c4a <fileclose+0xbe>
    80003bf8:	7902                	ld	s2,32(sp)
    80003bfa:	69e2                	ld	s3,24(sp)
    80003bfc:	6a42                	ld	s4,16(sp)
    80003bfe:	6aa2                	ld	s5,8(sp)
    80003c00:	a02d                	j	80003c2a <fileclose+0x9e>
    80003c02:	f04a                	sd	s2,32(sp)
    80003c04:	ec4e                	sd	s3,24(sp)
    80003c06:	e852                	sd	s4,16(sp)
    80003c08:	e456                	sd	s5,8(sp)
  if (f->ref < 1) panic("fileclose");
    80003c0a:	00005517          	auipc	a0,0x5
    80003c0e:	95650513          	addi	a0,a0,-1706 # 80008560 <etext+0x560>
    80003c12:	00002097          	auipc	ra,0x2
    80003c16:	2b0080e7          	jalr	688(ra) # 80005ec2 <panic>
    release(&ftable.lock);
    80003c1a:	00017517          	auipc	a0,0x17
    80003c1e:	7be50513          	addi	a0,a0,1982 # 8001b3d8 <ftable>
    80003c22:	00003097          	auipc	ra,0x3
    80003c26:	8ce080e7          	jalr	-1842(ra) # 800064f0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c2a:	70e2                	ld	ra,56(sp)
    80003c2c:	7442                	ld	s0,48(sp)
    80003c2e:	74a2                	ld	s1,40(sp)
    80003c30:	6121                	addi	sp,sp,64
    80003c32:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c34:	85d6                	mv	a1,s5
    80003c36:	8552                	mv	a0,s4
    80003c38:	00000097          	auipc	ra,0x0
    80003c3c:	3a2080e7          	jalr	930(ra) # 80003fda <pipeclose>
    80003c40:	7902                	ld	s2,32(sp)
    80003c42:	69e2                	ld	s3,24(sp)
    80003c44:	6a42                	ld	s4,16(sp)
    80003c46:	6aa2                	ld	s5,8(sp)
    80003c48:	b7cd                	j	80003c2a <fileclose+0x9e>
    begin_op();
    80003c4a:	00000097          	auipc	ra,0x0
    80003c4e:	a78080e7          	jalr	-1416(ra) # 800036c2 <begin_op>
    iput(ff.ip);
    80003c52:	854e                	mv	a0,s3
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	25e080e7          	jalr	606(ra) # 80002eb2 <iput>
    end_op();
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	ae0080e7          	jalr	-1312(ra) # 8000373c <end_op>
    80003c64:	7902                	ld	s2,32(sp)
    80003c66:	69e2                	ld	s3,24(sp)
    80003c68:	6a42                	ld	s4,16(sp)
    80003c6a:	6aa2                	ld	s5,8(sp)
    80003c6c:	bf7d                	j	80003c2a <fileclose+0x9e>

0000000080003c6e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003c6e:	715d                	addi	sp,sp,-80
    80003c70:	e486                	sd	ra,72(sp)
    80003c72:	e0a2                	sd	s0,64(sp)
    80003c74:	fc26                	sd	s1,56(sp)
    80003c76:	f44e                	sd	s3,40(sp)
    80003c78:	0880                	addi	s0,sp,80
    80003c7a:	84aa                	mv	s1,a0
    80003c7c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c7e:	ffffd097          	auipc	ra,0xffffd
    80003c82:	288080e7          	jalr	648(ra) # 80000f06 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003c86:	409c                	lw	a5,0(s1)
    80003c88:	37f9                	addiw	a5,a5,-2
    80003c8a:	4705                	li	a4,1
    80003c8c:	04f76863          	bltu	a4,a5,80003cdc <filestat+0x6e>
    80003c90:	f84a                	sd	s2,48(sp)
    80003c92:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c94:	6c88                	ld	a0,24(s1)
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	05e080e7          	jalr	94(ra) # 80002cf4 <ilock>
    stati(f->ip, &st);
    80003c9e:	fb840593          	addi	a1,s0,-72
    80003ca2:	6c88                	ld	a0,24(s1)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	2de080e7          	jalr	734(ra) # 80002f82 <stati>
    iunlock(f->ip);
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	10c080e7          	jalr	268(ra) # 80002dba <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003cb6:	46e1                	li	a3,24
    80003cb8:	fb840613          	addi	a2,s0,-72
    80003cbc:	85ce                	mv	a1,s3
    80003cbe:	05093503          	ld	a0,80(s2)
    80003cc2:	ffffd097          	auipc	ra,0xffffd
    80003cc6:	e8a080e7          	jalr	-374(ra) # 80000b4c <copyout>
    80003cca:	41f5551b          	sraiw	a0,a0,0x1f
    80003cce:	7942                	ld	s2,48(sp)
    return 0;
  }
  return -1;
}
    80003cd0:	60a6                	ld	ra,72(sp)
    80003cd2:	6406                	ld	s0,64(sp)
    80003cd4:	74e2                	ld	s1,56(sp)
    80003cd6:	79a2                	ld	s3,40(sp)
    80003cd8:	6161                	addi	sp,sp,80
    80003cda:	8082                	ret
  return -1;
    80003cdc:	557d                	li	a0,-1
    80003cde:	bfcd                	j	80003cd0 <filestat+0x62>

0000000080003ce0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003ce0:	7179                	addi	sp,sp,-48
    80003ce2:	f406                	sd	ra,40(sp)
    80003ce4:	f022                	sd	s0,32(sp)
    80003ce6:	e84a                	sd	s2,16(sp)
    80003ce8:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003cea:	00854783          	lbu	a5,8(a0)
    80003cee:	cbc5                	beqz	a5,80003d9e <fileread+0xbe>
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e44e                	sd	s3,8(sp)
    80003cf4:	84aa                	mv	s1,a0
    80003cf6:	89ae                	mv	s3,a1
    80003cf8:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003cfa:	411c                	lw	a5,0(a0)
    80003cfc:	4705                	li	a4,1
    80003cfe:	04e78963          	beq	a5,a4,80003d50 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003d02:	470d                	li	a4,3
    80003d04:	04e78f63          	beq	a5,a4,80003d62 <fileread+0x82>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003d08:	4709                	li	a4,2
    80003d0a:	08e79263          	bne	a5,a4,80003d8e <fileread+0xae>
    ilock(f->ip);
    80003d0e:	6d08                	ld	a0,24(a0)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	fe4080e7          	jalr	-28(ra) # 80002cf4 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003d18:	874a                	mv	a4,s2
    80003d1a:	5094                	lw	a3,32(s1)
    80003d1c:	864e                	mv	a2,s3
    80003d1e:	4585                	li	a1,1
    80003d20:	6c88                	ld	a0,24(s1)
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	28a080e7          	jalr	650(ra) # 80002fac <readi>
    80003d2a:	892a                	mv	s2,a0
    80003d2c:	00a05563          	blez	a0,80003d36 <fileread+0x56>
    80003d30:	509c                	lw	a5,32(s1)
    80003d32:	9fa9                	addw	a5,a5,a0
    80003d34:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d36:	6c88                	ld	a0,24(s1)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	082080e7          	jalr	130(ra) # 80002dba <iunlock>
    80003d40:	64e2                	ld	s1,24(sp)
    80003d42:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d44:	854a                	mv	a0,s2
    80003d46:	70a2                	ld	ra,40(sp)
    80003d48:	7402                	ld	s0,32(sp)
    80003d4a:	6942                	ld	s2,16(sp)
    80003d4c:	6145                	addi	sp,sp,48
    80003d4e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d50:	6908                	ld	a0,16(a0)
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	400080e7          	jalr	1024(ra) # 80004152 <piperead>
    80003d5a:	892a                	mv	s2,a0
    80003d5c:	64e2                	ld	s1,24(sp)
    80003d5e:	69a2                	ld	s3,8(sp)
    80003d60:	b7d5                	j	80003d44 <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003d62:	02451783          	lh	a5,36(a0)
    80003d66:	03079693          	slli	a3,a5,0x30
    80003d6a:	92c1                	srli	a3,a3,0x30
    80003d6c:	4725                	li	a4,9
    80003d6e:	02d76a63          	bltu	a4,a3,80003da2 <fileread+0xc2>
    80003d72:	0792                	slli	a5,a5,0x4
    80003d74:	00017717          	auipc	a4,0x17
    80003d78:	5c470713          	addi	a4,a4,1476 # 8001b338 <devsw>
    80003d7c:	97ba                	add	a5,a5,a4
    80003d7e:	639c                	ld	a5,0(a5)
    80003d80:	c78d                	beqz	a5,80003daa <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d82:	4505                	li	a0,1
    80003d84:	9782                	jalr	a5
    80003d86:	892a                	mv	s2,a0
    80003d88:	64e2                	ld	s1,24(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
    80003d8c:	bf65                	j	80003d44 <fileread+0x64>
    panic("fileread");
    80003d8e:	00004517          	auipc	a0,0x4
    80003d92:	7e250513          	addi	a0,a0,2018 # 80008570 <etext+0x570>
    80003d96:	00002097          	auipc	ra,0x2
    80003d9a:	12c080e7          	jalr	300(ra) # 80005ec2 <panic>
  if (f->readable == 0) return -1;
    80003d9e:	597d                	li	s2,-1
    80003da0:	b755                	j	80003d44 <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003da2:	597d                	li	s2,-1
    80003da4:	64e2                	ld	s1,24(sp)
    80003da6:	69a2                	ld	s3,8(sp)
    80003da8:	bf71                	j	80003d44 <fileread+0x64>
    80003daa:	597d                	li	s2,-1
    80003dac:	64e2                	ld	s1,24(sp)
    80003dae:	69a2                	ld	s3,8(sp)
    80003db0:	bf51                	j	80003d44 <fileread+0x64>

0000000080003db2 <filewrite>:
// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003db2:	00954783          	lbu	a5,9(a0)
    80003db6:	12078963          	beqz	a5,80003ee8 <filewrite+0x136>
int filewrite(struct file *f, uint64 addr, int n) {
    80003dba:	715d                	addi	sp,sp,-80
    80003dbc:	e486                	sd	ra,72(sp)
    80003dbe:	e0a2                	sd	s0,64(sp)
    80003dc0:	f84a                	sd	s2,48(sp)
    80003dc2:	f052                	sd	s4,32(sp)
    80003dc4:	e85a                	sd	s6,16(sp)
    80003dc6:	0880                	addi	s0,sp,80
    80003dc8:	892a                	mv	s2,a0
    80003dca:	8b2e                	mv	s6,a1
    80003dcc:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003dce:	411c                	lw	a5,0(a0)
    80003dd0:	4705                	li	a4,1
    80003dd2:	02e78763          	beq	a5,a4,80003e00 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003dd6:	470d                	li	a4,3
    80003dd8:	02e78a63          	beq	a5,a4,80003e0c <filewrite+0x5a>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003ddc:	4709                	li	a4,2
    80003dde:	0ee79863          	bne	a5,a4,80003ece <filewrite+0x11c>
    80003de2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003de4:	0cc05463          	blez	a2,80003eac <filewrite+0xfa>
    80003de8:	fc26                	sd	s1,56(sp)
    80003dea:	ec56                	sd	s5,24(sp)
    80003dec:	e45e                	sd	s7,8(sp)
    80003dee:	e062                	sd	s8,0(sp)
    int i = 0;
    80003df0:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max) n1 = max;
    80003df2:	6b85                	lui	s7,0x1
    80003df4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003df8:	6c05                	lui	s8,0x1
    80003dfa:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003dfe:	a851                	j	80003e92 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e00:	6908                	ld	a0,16(a0)
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	248080e7          	jalr	584(ra) # 8000404a <pipewrite>
    80003e0a:	a85d                	j	80003ec0 <filewrite+0x10e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003e0c:	02451783          	lh	a5,36(a0)
    80003e10:	03079693          	slli	a3,a5,0x30
    80003e14:	92c1                	srli	a3,a3,0x30
    80003e16:	4725                	li	a4,9
    80003e18:	0cd76a63          	bltu	a4,a3,80003eec <filewrite+0x13a>
    80003e1c:	0792                	slli	a5,a5,0x4
    80003e1e:	00017717          	auipc	a4,0x17
    80003e22:	51a70713          	addi	a4,a4,1306 # 8001b338 <devsw>
    80003e26:	97ba                	add	a5,a5,a4
    80003e28:	679c                	ld	a5,8(a5)
    80003e2a:	c3f9                	beqz	a5,80003ef0 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003e2c:	4505                	li	a0,1
    80003e2e:	9782                	jalr	a5
    80003e30:	a841                	j	80003ec0 <filewrite+0x10e>
      if (n1 > max) n1 = max;
    80003e32:	00048a9b          	sext.w	s5,s1

      begin_op();
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	88c080e7          	jalr	-1908(ra) # 800036c2 <begin_op>
      ilock(f->ip);
    80003e3e:	01893503          	ld	a0,24(s2)
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	eb2080e7          	jalr	-334(ra) # 80002cf4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003e4a:	8756                	mv	a4,s5
    80003e4c:	02092683          	lw	a3,32(s2)
    80003e50:	01698633          	add	a2,s3,s6
    80003e54:	4585                	li	a1,1
    80003e56:	01893503          	ld	a0,24(s2)
    80003e5a:	fffff097          	auipc	ra,0xfffff
    80003e5e:	262080e7          	jalr	610(ra) # 800030bc <writei>
    80003e62:	84aa                	mv	s1,a0
    80003e64:	00a05763          	blez	a0,80003e72 <filewrite+0xc0>
    80003e68:	02092783          	lw	a5,32(s2)
    80003e6c:	9fa9                	addw	a5,a5,a0
    80003e6e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e72:	01893503          	ld	a0,24(s2)
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	f44080e7          	jalr	-188(ra) # 80002dba <iunlock>
      end_op();
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	8be080e7          	jalr	-1858(ra) # 8000373c <end_op>

      if (r != n1) {
    80003e86:	029a9563          	bne	s5,s1,80003eb0 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e8a:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003e8e:	0149da63          	bge	s3,s4,80003ea2 <filewrite+0xf0>
      int n1 = n - i;
    80003e92:	413a04bb          	subw	s1,s4,s3
      if (n1 > max) n1 = max;
    80003e96:	0004879b          	sext.w	a5,s1
    80003e9a:	f8fbdce3          	bge	s7,a5,80003e32 <filewrite+0x80>
    80003e9e:	84e2                	mv	s1,s8
    80003ea0:	bf49                	j	80003e32 <filewrite+0x80>
    80003ea2:	74e2                	ld	s1,56(sp)
    80003ea4:	6ae2                	ld	s5,24(sp)
    80003ea6:	6ba2                	ld	s7,8(sp)
    80003ea8:	6c02                	ld	s8,0(sp)
    80003eaa:	a039                	j	80003eb8 <filewrite+0x106>
    int i = 0;
    80003eac:	4981                	li	s3,0
    80003eae:	a029                	j	80003eb8 <filewrite+0x106>
    80003eb0:	74e2                	ld	s1,56(sp)
    80003eb2:	6ae2                	ld	s5,24(sp)
    80003eb4:	6ba2                	ld	s7,8(sp)
    80003eb6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003eb8:	033a1e63          	bne	s4,s3,80003ef4 <filewrite+0x142>
    80003ebc:	8552                	mv	a0,s4
    80003ebe:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ec0:	60a6                	ld	ra,72(sp)
    80003ec2:	6406                	ld	s0,64(sp)
    80003ec4:	7942                	ld	s2,48(sp)
    80003ec6:	7a02                	ld	s4,32(sp)
    80003ec8:	6b42                	ld	s6,16(sp)
    80003eca:	6161                	addi	sp,sp,80
    80003ecc:	8082                	ret
    80003ece:	fc26                	sd	s1,56(sp)
    80003ed0:	f44e                	sd	s3,40(sp)
    80003ed2:	ec56                	sd	s5,24(sp)
    80003ed4:	e45e                	sd	s7,8(sp)
    80003ed6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003ed8:	00004517          	auipc	a0,0x4
    80003edc:	6a850513          	addi	a0,a0,1704 # 80008580 <etext+0x580>
    80003ee0:	00002097          	auipc	ra,0x2
    80003ee4:	fe2080e7          	jalr	-30(ra) # 80005ec2 <panic>
  if (f->writable == 0) return -1;
    80003ee8:	557d                	li	a0,-1
}
    80003eea:	8082                	ret
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003eec:	557d                	li	a0,-1
    80003eee:	bfc9                	j	80003ec0 <filewrite+0x10e>
    80003ef0:	557d                	li	a0,-1
    80003ef2:	b7f9                	j	80003ec0 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003ef4:	557d                	li	a0,-1
    80003ef6:	79a2                	ld	s3,40(sp)
    80003ef8:	b7e1                	j	80003ec0 <filewrite+0x10e>

0000000080003efa <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003efa:	7179                	addi	sp,sp,-48
    80003efc:	f406                	sd	ra,40(sp)
    80003efe:	f022                	sd	s0,32(sp)
    80003f00:	ec26                	sd	s1,24(sp)
    80003f02:	e052                	sd	s4,0(sp)
    80003f04:	1800                	addi	s0,sp,48
    80003f06:	84aa                	mv	s1,a0
    80003f08:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f0a:	0005b023          	sd	zero,0(a1)
    80003f0e:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003f12:	00000097          	auipc	ra,0x0
    80003f16:	bbe080e7          	jalr	-1090(ra) # 80003ad0 <filealloc>
    80003f1a:	e088                	sd	a0,0(s1)
    80003f1c:	cd49                	beqz	a0,80003fb6 <pipealloc+0xbc>
    80003f1e:	00000097          	auipc	ra,0x0
    80003f22:	bb2080e7          	jalr	-1102(ra) # 80003ad0 <filealloc>
    80003f26:	00aa3023          	sd	a0,0(s4)
    80003f2a:	c141                	beqz	a0,80003faa <pipealloc+0xb0>
    80003f2c:	e84a                	sd	s2,16(sp)
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	1ec080e7          	jalr	492(ra) # 8000011a <kalloc>
    80003f36:	892a                	mv	s2,a0
    80003f38:	c13d                	beqz	a0,80003f9e <pipealloc+0xa4>
    80003f3a:	e44e                	sd	s3,8(sp)
  pi->readopen = 1;
    80003f3c:	4985                	li	s3,1
    80003f3e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f42:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f46:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f4a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f4e:	00004597          	auipc	a1,0x4
    80003f52:	64258593          	addi	a1,a1,1602 # 80008590 <etext+0x590>
    80003f56:	00002097          	auipc	ra,0x2
    80003f5a:	456080e7          	jalr	1110(ra) # 800063ac <initlock>
  (*f0)->type = FD_PIPE;
    80003f5e:	609c                	ld	a5,0(s1)
    80003f60:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f64:	609c                	ld	a5,0(s1)
    80003f66:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f6a:	609c                	ld	a5,0(s1)
    80003f6c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f70:	609c                	ld	a5,0(s1)
    80003f72:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f76:	000a3783          	ld	a5,0(s4)
    80003f7a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f7e:	000a3783          	ld	a5,0(s4)
    80003f82:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f86:	000a3783          	ld	a5,0(s4)
    80003f8a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f8e:	000a3783          	ld	a5,0(s4)
    80003f92:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f96:	4501                	li	a0,0
    80003f98:	6942                	ld	s2,16(sp)
    80003f9a:	69a2                	ld	s3,8(sp)
    80003f9c:	a03d                	j	80003fca <pipealloc+0xd0>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003f9e:	6088                	ld	a0,0(s1)
    80003fa0:	c119                	beqz	a0,80003fa6 <pipealloc+0xac>
    80003fa2:	6942                	ld	s2,16(sp)
    80003fa4:	a029                	j	80003fae <pipealloc+0xb4>
    80003fa6:	6942                	ld	s2,16(sp)
    80003fa8:	a039                	j	80003fb6 <pipealloc+0xbc>
    80003faa:	6088                	ld	a0,0(s1)
    80003fac:	c50d                	beqz	a0,80003fd6 <pipealloc+0xdc>
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	bde080e7          	jalr	-1058(ra) # 80003b8c <fileclose>
  if (*f1) fileclose(*f1);
    80003fb6:	000a3783          	ld	a5,0(s4)
  return -1;
    80003fba:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003fbc:	c799                	beqz	a5,80003fca <pipealloc+0xd0>
    80003fbe:	853e                	mv	a0,a5
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	bcc080e7          	jalr	-1076(ra) # 80003b8c <fileclose>
  return -1;
    80003fc8:	557d                	li	a0,-1
}
    80003fca:	70a2                	ld	ra,40(sp)
    80003fcc:	7402                	ld	s0,32(sp)
    80003fce:	64e2                	ld	s1,24(sp)
    80003fd0:	6a02                	ld	s4,0(sp)
    80003fd2:	6145                	addi	sp,sp,48
    80003fd4:	8082                	ret
  return -1;
    80003fd6:	557d                	li	a0,-1
    80003fd8:	bfcd                	j	80003fca <pipealloc+0xd0>

0000000080003fda <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003fda:	1101                	addi	sp,sp,-32
    80003fdc:	ec06                	sd	ra,24(sp)
    80003fde:	e822                	sd	s0,16(sp)
    80003fe0:	e426                	sd	s1,8(sp)
    80003fe2:	e04a                	sd	s2,0(sp)
    80003fe4:	1000                	addi	s0,sp,32
    80003fe6:	84aa                	mv	s1,a0
    80003fe8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	452080e7          	jalr	1106(ra) # 8000643c <acquire>
  if (writable) {
    80003ff2:	02090d63          	beqz	s2,8000402c <pipeclose+0x52>
    pi->writeopen = 0;
    80003ff6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ffa:	21848513          	addi	a0,s1,536
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	61a080e7          	jalr	1562(ra) # 80001618 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004006:	2204b783          	ld	a5,544(s1)
    8000400a:	eb95                	bnez	a5,8000403e <pipeclose+0x64>
    release(&pi->lock);
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	4e2080e7          	jalr	1250(ra) # 800064f0 <release>
    kfree((char *)pi);
    80004016:	8526                	mv	a0,s1
    80004018:	ffffc097          	auipc	ra,0xffffc
    8000401c:	004080e7          	jalr	4(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004020:	60e2                	ld	ra,24(sp)
    80004022:	6442                	ld	s0,16(sp)
    80004024:	64a2                	ld	s1,8(sp)
    80004026:	6902                	ld	s2,0(sp)
    80004028:	6105                	addi	sp,sp,32
    8000402a:	8082                	ret
    pi->readopen = 0;
    8000402c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004030:	21c48513          	addi	a0,s1,540
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	5e4080e7          	jalr	1508(ra) # 80001618 <wakeup>
    8000403c:	b7e9                	j	80004006 <pipeclose+0x2c>
    release(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	4b0080e7          	jalr	1200(ra) # 800064f0 <release>
}
    80004048:	bfe1                	j	80004020 <pipeclose+0x46>

000000008000404a <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    8000404a:	711d                	addi	sp,sp,-96
    8000404c:	ec86                	sd	ra,88(sp)
    8000404e:	e8a2                	sd	s0,80(sp)
    80004050:	e4a6                	sd	s1,72(sp)
    80004052:	e0ca                	sd	s2,64(sp)
    80004054:	fc4e                	sd	s3,56(sp)
    80004056:	f852                	sd	s4,48(sp)
    80004058:	f456                	sd	s5,40(sp)
    8000405a:	1080                	addi	s0,sp,96
    8000405c:	84aa                	mv	s1,a0
    8000405e:	8aae                	mv	s5,a1
    80004060:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	ea4080e7          	jalr	-348(ra) # 80000f06 <myproc>
    8000406a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	3ce080e7          	jalr	974(ra) # 8000643c <acquire>
  while (i < n) {
    80004076:	0d405863          	blez	s4,80004146 <pipewrite+0xfc>
    8000407a:	f05a                	sd	s6,32(sp)
    8000407c:	ec5e                	sd	s7,24(sp)
    8000407e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004080:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80004082:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004084:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004088:	21c48b93          	addi	s7,s1,540
    8000408c:	a089                	j	800040ce <pipewrite+0x84>
      release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	460080e7          	jalr	1120(ra) # 800064f0 <release>
      return -1;
    80004098:	597d                	li	s2,-1
    8000409a:	7b02                	ld	s6,32(sp)
    8000409c:	6be2                	ld	s7,24(sp)
    8000409e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040a0:	854a                	mv	a0,s2
    800040a2:	60e6                	ld	ra,88(sp)
    800040a4:	6446                	ld	s0,80(sp)
    800040a6:	64a6                	ld	s1,72(sp)
    800040a8:	6906                	ld	s2,64(sp)
    800040aa:	79e2                	ld	s3,56(sp)
    800040ac:	7a42                	ld	s4,48(sp)
    800040ae:	7aa2                	ld	s5,40(sp)
    800040b0:	6125                	addi	sp,sp,96
    800040b2:	8082                	ret
      wakeup(&pi->nread);
    800040b4:	8562                	mv	a0,s8
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	562080e7          	jalr	1378(ra) # 80001618 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040be:	85a6                	mv	a1,s1
    800040c0:	855e                	mv	a0,s7
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	4f2080e7          	jalr	1266(ra) # 800015b4 <sleep>
  while (i < n) {
    800040ca:	05495f63          	bge	s2,s4,80004128 <pipewrite+0xde>
    if (pi->readopen == 0 || killed(pr)) {
    800040ce:	2204a783          	lw	a5,544(s1)
    800040d2:	dfd5                	beqz	a5,8000408e <pipewrite+0x44>
    800040d4:	854e                	mv	a0,s3
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	786080e7          	jalr	1926(ra) # 8000185c <killed>
    800040de:	f945                	bnez	a0,8000408e <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    800040e0:	2184a783          	lw	a5,536(s1)
    800040e4:	21c4a703          	lw	a4,540(s1)
    800040e8:	2007879b          	addiw	a5,a5,512
    800040ec:	fcf704e3          	beq	a4,a5,800040b4 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    800040f0:	4685                	li	a3,1
    800040f2:	01590633          	add	a2,s2,s5
    800040f6:	faf40593          	addi	a1,s0,-81
    800040fa:	0509b503          	ld	a0,80(s3)
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	b2c080e7          	jalr	-1236(ra) # 80000c2a <copyin>
    80004106:	05650263          	beq	a0,s6,8000414a <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000410a:	21c4a783          	lw	a5,540(s1)
    8000410e:	0017871b          	addiw	a4,a5,1
    80004112:	20e4ae23          	sw	a4,540(s1)
    80004116:	1ff7f793          	andi	a5,a5,511
    8000411a:	97a6                	add	a5,a5,s1
    8000411c:	faf44703          	lbu	a4,-81(s0)
    80004120:	00e78c23          	sb	a4,24(a5)
      i++;
    80004124:	2905                	addiw	s2,s2,1
    80004126:	b755                	j	800040ca <pipewrite+0x80>
    80004128:	7b02                	ld	s6,32(sp)
    8000412a:	6be2                	ld	s7,24(sp)
    8000412c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000412e:	21848513          	addi	a0,s1,536
    80004132:	ffffd097          	auipc	ra,0xffffd
    80004136:	4e6080e7          	jalr	1254(ra) # 80001618 <wakeup>
  release(&pi->lock);
    8000413a:	8526                	mv	a0,s1
    8000413c:	00002097          	auipc	ra,0x2
    80004140:	3b4080e7          	jalr	948(ra) # 800064f0 <release>
  return i;
    80004144:	bfb1                	j	800040a0 <pipewrite+0x56>
  int i = 0;
    80004146:	4901                	li	s2,0
    80004148:	b7dd                	j	8000412e <pipewrite+0xe4>
    8000414a:	7b02                	ld	s6,32(sp)
    8000414c:	6be2                	ld	s7,24(sp)
    8000414e:	6c42                	ld	s8,16(sp)
    80004150:	bff9                	j	8000412e <pipewrite+0xe4>

0000000080004152 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80004152:	715d                	addi	sp,sp,-80
    80004154:	e486                	sd	ra,72(sp)
    80004156:	e0a2                	sd	s0,64(sp)
    80004158:	fc26                	sd	s1,56(sp)
    8000415a:	f84a                	sd	s2,48(sp)
    8000415c:	f44e                	sd	s3,40(sp)
    8000415e:	f052                	sd	s4,32(sp)
    80004160:	ec56                	sd	s5,24(sp)
    80004162:	0880                	addi	s0,sp,80
    80004164:	84aa                	mv	s1,a0
    80004166:	892e                	mv	s2,a1
    80004168:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	d9c080e7          	jalr	-612(ra) # 80000f06 <myproc>
    80004172:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004174:	8526                	mv	a0,s1
    80004176:	00002097          	auipc	ra,0x2
    8000417a:	2c6080e7          	jalr	710(ra) # 8000643c <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000417e:	2184a703          	lw	a4,536(s1)
    80004182:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004186:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000418a:	02f71963          	bne	a4,a5,800041bc <piperead+0x6a>
    8000418e:	2244a783          	lw	a5,548(s1)
    80004192:	cf95                	beqz	a5,800041ce <piperead+0x7c>
    if (killed(pr)) {
    80004194:	8552                	mv	a0,s4
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	6c6080e7          	jalr	1734(ra) # 8000185c <killed>
    8000419e:	e10d                	bnez	a0,800041c0 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    800041a0:	85a6                	mv	a1,s1
    800041a2:	854e                	mv	a0,s3
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	410080e7          	jalr	1040(ra) # 800015b4 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    800041ac:	2184a703          	lw	a4,536(s1)
    800041b0:	21c4a783          	lw	a5,540(s1)
    800041b4:	fcf70de3          	beq	a4,a5,8000418e <piperead+0x3c>
    800041b8:	e85a                	sd	s6,16(sp)
    800041ba:	a819                	j	800041d0 <piperead+0x7e>
    800041bc:	e85a                	sd	s6,16(sp)
    800041be:	a809                	j	800041d0 <piperead+0x7e>
      release(&pi->lock);
    800041c0:	8526                	mv	a0,s1
    800041c2:	00002097          	auipc	ra,0x2
    800041c6:	32e080e7          	jalr	814(ra) # 800064f0 <release>
      return -1;
    800041ca:	59fd                	li	s3,-1
    800041cc:	a0a5                	j	80004234 <piperead+0xe2>
    800041ce:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800041d0:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800041d2:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800041d4:	05505463          	blez	s5,8000421c <piperead+0xca>
    if (pi->nread == pi->nwrite) break;
    800041d8:	2184a783          	lw	a5,536(s1)
    800041dc:	21c4a703          	lw	a4,540(s1)
    800041e0:	02f70e63          	beq	a4,a5,8000421c <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041e4:	0017871b          	addiw	a4,a5,1
    800041e8:	20e4ac23          	sw	a4,536(s1)
    800041ec:	1ff7f793          	andi	a5,a5,511
    800041f0:	97a6                	add	a5,a5,s1
    800041f2:	0187c783          	lbu	a5,24(a5)
    800041f6:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800041fa:	4685                	li	a3,1
    800041fc:	fbf40613          	addi	a2,s0,-65
    80004200:	85ca                	mv	a1,s2
    80004202:	050a3503          	ld	a0,80(s4)
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	946080e7          	jalr	-1722(ra) # 80000b4c <copyout>
    8000420e:	01650763          	beq	a0,s6,8000421c <piperead+0xca>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004212:	2985                	addiw	s3,s3,1
    80004214:	0905                	addi	s2,s2,1
    80004216:	fd3a91e3          	bne	s5,s3,800041d8 <piperead+0x86>
    8000421a:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    8000421c:	21c48513          	addi	a0,s1,540
    80004220:	ffffd097          	auipc	ra,0xffffd
    80004224:	3f8080e7          	jalr	1016(ra) # 80001618 <wakeup>
  release(&pi->lock);
    80004228:	8526                	mv	a0,s1
    8000422a:	00002097          	auipc	ra,0x2
    8000422e:	2c6080e7          	jalr	710(ra) # 800064f0 <release>
    80004232:	6b42                	ld	s6,16(sp)
  return i;
}
    80004234:	854e                	mv	a0,s3
    80004236:	60a6                	ld	ra,72(sp)
    80004238:	6406                	ld	s0,64(sp)
    8000423a:	74e2                	ld	s1,56(sp)
    8000423c:	7942                	ld	s2,48(sp)
    8000423e:	79a2                	ld	s3,40(sp)
    80004240:	7a02                	ld	s4,32(sp)
    80004242:	6ae2                	ld	s5,24(sp)
    80004244:	6161                	addi	sp,sp,80
    80004246:	8082                	ret

0000000080004248 <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004248:	1141                	addi	sp,sp,-16
    8000424a:	e422                	sd	s0,8(sp)
    8000424c:	0800                	addi	s0,sp,16
    8000424e:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80004250:	8905                	andi	a0,a0,1
    80004252:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80004254:	8b89                	andi	a5,a5,2
    80004256:	c399                	beqz	a5,8000425c <flags2perm+0x14>
    80004258:	00456513          	ori	a0,a0,4
  return perm;
}
    8000425c:	6422                	ld	s0,8(sp)
    8000425e:	0141                	addi	sp,sp,16
    80004260:	8082                	ret

0000000080004262 <exec>:

int exec(char *path, char **argv) {
    80004262:	df010113          	addi	sp,sp,-528
    80004266:	20113423          	sd	ra,520(sp)
    8000426a:	20813023          	sd	s0,512(sp)
    8000426e:	ffa6                	sd	s1,504(sp)
    80004270:	fbca                	sd	s2,496(sp)
    80004272:	0c00                	addi	s0,sp,528
    80004274:	892a                	mv	s2,a0
    80004276:	dea43c23          	sd	a0,-520(s0)
    8000427a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	c88080e7          	jalr	-888(ra) # 80000f06 <myproc>
    80004286:	84aa                	mv	s1,a0

  begin_op();
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	43a080e7          	jalr	1082(ra) # 800036c2 <begin_op>

  if ((ip = namei(path)) == 0) {
    80004290:	854a                	mv	a0,s2
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	230080e7          	jalr	560(ra) # 800034c2 <namei>
    8000429a:	c135                	beqz	a0,800042fe <exec+0x9c>
    8000429c:	f3d2                	sd	s4,480(sp)
    8000429e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	a54080e7          	jalr	-1452(ra) # 80002cf4 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    800042a8:	04000713          	li	a4,64
    800042ac:	4681                	li	a3,0
    800042ae:	e5040613          	addi	a2,s0,-432
    800042b2:	4581                	li	a1,0
    800042b4:	8552                	mv	a0,s4
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	cf6080e7          	jalr	-778(ra) # 80002fac <readi>
    800042be:	04000793          	li	a5,64
    800042c2:	00f51a63          	bne	a0,a5,800042d6 <exec+0x74>

  if (elf.magic != ELF_MAGIC) goto bad;
    800042c6:	e5042703          	lw	a4,-432(s0)
    800042ca:	464c47b7          	lui	a5,0x464c4
    800042ce:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042d2:	02f70c63          	beq	a4,a5,8000430a <exec+0xa8>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800042d6:	8552                	mv	a0,s4
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	c82080e7          	jalr	-894(ra) # 80002f5a <iunlockput>
    end_op();
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	45c080e7          	jalr	1116(ra) # 8000373c <end_op>
  }
  return -1;
    800042e8:	557d                	li	a0,-1
    800042ea:	7a1e                	ld	s4,480(sp)
}
    800042ec:	20813083          	ld	ra,520(sp)
    800042f0:	20013403          	ld	s0,512(sp)
    800042f4:	74fe                	ld	s1,504(sp)
    800042f6:	795e                	ld	s2,496(sp)
    800042f8:	21010113          	addi	sp,sp,528
    800042fc:	8082                	ret
    end_op();
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	43e080e7          	jalr	1086(ra) # 8000373c <end_op>
    return -1;
    80004306:	557d                	li	a0,-1
    80004308:	b7d5                	j	800042ec <exec+0x8a>
    8000430a:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    8000430c:	8526                	mv	a0,s1
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	cc0080e7          	jalr	-832(ra) # 80000fce <proc_pagetable>
    80004316:	8b2a                	mv	s6,a0
    80004318:	30050f63          	beqz	a0,80004636 <exec+0x3d4>
    8000431c:	f7ce                	sd	s3,488(sp)
    8000431e:	efd6                	sd	s5,472(sp)
    80004320:	e7de                	sd	s7,456(sp)
    80004322:	e3e2                	sd	s8,448(sp)
    80004324:	ff66                	sd	s9,440(sp)
    80004326:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004328:	e7042d03          	lw	s10,-400(s0)
    8000432c:	e8845783          	lhu	a5,-376(s0)
    80004330:	14078d63          	beqz	a5,8000448a <exec+0x228>
    80004334:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004336:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004338:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000433a:	6c85                	lui	s9,0x1
    8000433c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004340:	def43823          	sd	a5,-528(s0)
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004344:	6a85                	lui	s5,0x1
    80004346:	a0b5                	j	800043b2 <exec+0x150>
    if (pa == 0) panic("loadseg: address should exist");
    80004348:	00004517          	auipc	a0,0x4
    8000434c:	25050513          	addi	a0,a0,592 # 80008598 <etext+0x598>
    80004350:	00002097          	auipc	ra,0x2
    80004354:	b72080e7          	jalr	-1166(ra) # 80005ec2 <panic>
    if (sz - i < PGSIZE)
    80004358:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    8000435a:	8726                	mv	a4,s1
    8000435c:	012c06bb          	addw	a3,s8,s2
    80004360:	4581                	li	a1,0
    80004362:	8552                	mv	a0,s4
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	c48080e7          	jalr	-952(ra) # 80002fac <readi>
    8000436c:	2501                	sext.w	a0,a0
    8000436e:	28a49863          	bne	s1,a0,800045fe <exec+0x39c>
  for (i = 0; i < sz; i += PGSIZE) {
    80004372:	012a893b          	addw	s2,s5,s2
    80004376:	03397563          	bgeu	s2,s3,800043a0 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000437a:	02091593          	slli	a1,s2,0x20
    8000437e:	9181                	srli	a1,a1,0x20
    80004380:	95de                	add	a1,a1,s7
    80004382:	855a                	mv	a0,s6
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	178080e7          	jalr	376(ra) # 800004fc <walkaddr>
    8000438c:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    8000438e:	dd4d                	beqz	a0,80004348 <exec+0xe6>
    if (sz - i < PGSIZE)
    80004390:	412984bb          	subw	s1,s3,s2
    80004394:	0004879b          	sext.w	a5,s1
    80004398:	fcfcf0e3          	bgeu	s9,a5,80004358 <exec+0xf6>
    8000439c:	84d6                	mv	s1,s5
    8000439e:	bf6d                	j	80004358 <exec+0xf6>
    sz = sz1;
    800043a0:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800043a4:	2d85                	addiw	s11,s11,1
    800043a6:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800043aa:	e8845783          	lhu	a5,-376(s0)
    800043ae:	08fdd663          	bge	s11,a5,8000443a <exec+0x1d8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    800043b2:	2d01                	sext.w	s10,s10
    800043b4:	03800713          	li	a4,56
    800043b8:	86ea                	mv	a3,s10
    800043ba:	e1840613          	addi	a2,s0,-488
    800043be:	4581                	li	a1,0
    800043c0:	8552                	mv	a0,s4
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	bea080e7          	jalr	-1046(ra) # 80002fac <readi>
    800043ca:	03800793          	li	a5,56
    800043ce:	20f51063          	bne	a0,a5,800045ce <exec+0x36c>
    if (ph.type != ELF_PROG_LOAD) continue;
    800043d2:	e1842783          	lw	a5,-488(s0)
    800043d6:	4705                	li	a4,1
    800043d8:	fce796e3          	bne	a5,a4,800043a4 <exec+0x142>
    if (ph.memsz < ph.filesz) goto bad;
    800043dc:	e4043483          	ld	s1,-448(s0)
    800043e0:	e3843783          	ld	a5,-456(s0)
    800043e4:	1ef4e963          	bltu	s1,a5,800045d6 <exec+0x374>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    800043e8:	e2843783          	ld	a5,-472(s0)
    800043ec:	94be                	add	s1,s1,a5
    800043ee:	1ef4e863          	bltu	s1,a5,800045de <exec+0x37c>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800043f2:	df043703          	ld	a4,-528(s0)
    800043f6:	8ff9                	and	a5,a5,a4
    800043f8:	1e079763          	bnez	a5,800045e6 <exec+0x384>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800043fc:	e1c42503          	lw	a0,-484(s0)
    80004400:	00000097          	auipc	ra,0x0
    80004404:	e48080e7          	jalr	-440(ra) # 80004248 <flags2perm>
    80004408:	86aa                	mv	a3,a0
    8000440a:	8626                	mv	a2,s1
    8000440c:	85ca                	mv	a1,s2
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	4d4080e7          	jalr	1236(ra) # 800008e4 <uvmalloc>
    80004418:	e0a43423          	sd	a0,-504(s0)
    8000441c:	1c050963          	beqz	a0,800045ee <exec+0x38c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    80004420:	e2843b83          	ld	s7,-472(s0)
    80004424:	e2042c03          	lw	s8,-480(s0)
    80004428:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000442c:	00098463          	beqz	s3,80004434 <exec+0x1d2>
    80004430:	4901                	li	s2,0
    80004432:	b7a1                	j	8000437a <exec+0x118>
    sz = sz1;
    80004434:	e0843903          	ld	s2,-504(s0)
    80004438:	b7b5                	j	800043a4 <exec+0x142>
    8000443a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000443c:	8552                	mv	a0,s4
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	b1c080e7          	jalr	-1252(ra) # 80002f5a <iunlockput>
  end_op();
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	2f6080e7          	jalr	758(ra) # 8000373c <end_op>
  p = myproc();
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	ab8080e7          	jalr	-1352(ra) # 80000f06 <myproc>
    80004456:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004458:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000445c:	6985                	lui	s3,0x1
    8000445e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004460:	99ca                	add	s3,s3,s2
    80004462:	77fd                	lui	a5,0xfffff
    80004464:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004468:	4691                	li	a3,4
    8000446a:	6609                	lui	a2,0x2
    8000446c:	964e                	add	a2,a2,s3
    8000446e:	85ce                	mv	a1,s3
    80004470:	855a                	mv	a0,s6
    80004472:	ffffc097          	auipc	ra,0xffffc
    80004476:	472080e7          	jalr	1138(ra) # 800008e4 <uvmalloc>
    8000447a:	892a                	mv	s2,a0
    8000447c:	e0a43423          	sd	a0,-504(s0)
    80004480:	e519                	bnez	a0,8000448e <exec+0x22c>
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004482:	e1343423          	sd	s3,-504(s0)
    80004486:	4a01                	li	s4,0
    80004488:	aaa5                	j	80004600 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000448a:	4901                	li	s2,0
    8000448c:	bf45                	j	8000443c <exec+0x1da>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    8000448e:	75f9                	lui	a1,0xffffe
    80004490:	95aa                	add	a1,a1,a0
    80004492:	855a                	mv	a0,s6
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	686080e7          	jalr	1670(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    8000449c:	7bfd                	lui	s7,0xfffff
    8000449e:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++) {
    800044a0:	e0043783          	ld	a5,-512(s0)
    800044a4:	6388                	ld	a0,0(a5)
    800044a6:	c52d                	beqz	a0,80004510 <exec+0x2ae>
    800044a8:	e9040993          	addi	s3,s0,-368
    800044ac:	f9040c13          	addi	s8,s0,-112
    800044b0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	e3c080e7          	jalr	-452(ra) # 800002ee <strlen>
    800044ba:	0015079b          	addiw	a5,a0,1
    800044be:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    800044c2:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    800044c6:	13796863          	bltu	s2,s7,800045f6 <exec+0x394>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044ca:	e0043d03          	ld	s10,-512(s0)
    800044ce:	000d3a03          	ld	s4,0(s10)
    800044d2:	8552                	mv	a0,s4
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	e1a080e7          	jalr	-486(ra) # 800002ee <strlen>
    800044dc:	0015069b          	addiw	a3,a0,1
    800044e0:	8652                	mv	a2,s4
    800044e2:	85ca                	mv	a1,s2
    800044e4:	855a                	mv	a0,s6
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	666080e7          	jalr	1638(ra) # 80000b4c <copyout>
    800044ee:	10054663          	bltz	a0,800045fa <exec+0x398>
    ustack[argc] = sp;
    800044f2:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    800044f6:	0485                	addi	s1,s1,1
    800044f8:	008d0793          	addi	a5,s10,8
    800044fc:	e0f43023          	sd	a5,-512(s0)
    80004500:	008d3503          	ld	a0,8(s10)
    80004504:	c909                	beqz	a0,80004516 <exec+0x2b4>
    if (argc >= MAXARG) goto bad;
    80004506:	09a1                	addi	s3,s3,8
    80004508:	fb8995e3          	bne	s3,s8,800044b2 <exec+0x250>
  ip = 0;
    8000450c:	4a01                	li	s4,0
    8000450e:	a8cd                	j	80004600 <exec+0x39e>
  sp = sz;
    80004510:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    80004514:	4481                	li	s1,0
  ustack[argc] = 0;
    80004516:	00349793          	slli	a5,s1,0x3
    8000451a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda880>
    8000451e:	97a2                	add	a5,a5,s0
    80004520:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004524:	00148693          	addi	a3,s1,1
    80004528:	068e                	slli	a3,a3,0x3
    8000452a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000452e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004532:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase) goto bad;
    80004536:	f57966e3          	bltu	s2,s7,80004482 <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000453a:	e9040613          	addi	a2,s0,-368
    8000453e:	85ca                	mv	a1,s2
    80004540:	855a                	mv	a0,s6
    80004542:	ffffc097          	auipc	ra,0xffffc
    80004546:	60a080e7          	jalr	1546(ra) # 80000b4c <copyout>
    8000454a:	0e054863          	bltz	a0,8000463a <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000454e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004552:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004556:	df843783          	ld	a5,-520(s0)
    8000455a:	0007c703          	lbu	a4,0(a5)
    8000455e:	cf11                	beqz	a4,8000457a <exec+0x318>
    80004560:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    80004562:	02f00693          	li	a3,47
    80004566:	a039                	j	80004574 <exec+0x312>
    80004568:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    8000456c:	0785                	addi	a5,a5,1
    8000456e:	fff7c703          	lbu	a4,-1(a5)
    80004572:	c701                	beqz	a4,8000457a <exec+0x318>
    if (*s == '/') last = s + 1;
    80004574:	fed71ce3          	bne	a4,a3,8000456c <exec+0x30a>
    80004578:	bfc5                	j	80004568 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    8000457a:	4641                	li	a2,16
    8000457c:	df843583          	ld	a1,-520(s0)
    80004580:	158a8513          	addi	a0,s5,344
    80004584:	ffffc097          	auipc	ra,0xffffc
    80004588:	d38080e7          	jalr	-712(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000458c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004590:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004594:	e0843783          	ld	a5,-504(s0)
    80004598:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000459c:	058ab783          	ld	a5,88(s5)
    800045a0:	e6843703          	ld	a4,-408(s0)
    800045a4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800045a6:	058ab783          	ld	a5,88(s5)
    800045aa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045ae:	85e6                	mv	a1,s9
    800045b0:	ffffd097          	auipc	ra,0xffffd
    800045b4:	aba080e7          	jalr	-1350(ra) # 8000106a <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800045b8:	0004851b          	sext.w	a0,s1
    800045bc:	79be                	ld	s3,488(sp)
    800045be:	7a1e                	ld	s4,480(sp)
    800045c0:	6afe                	ld	s5,472(sp)
    800045c2:	6b5e                	ld	s6,464(sp)
    800045c4:	6bbe                	ld	s7,456(sp)
    800045c6:	6c1e                	ld	s8,448(sp)
    800045c8:	7cfa                	ld	s9,440(sp)
    800045ca:	7d5a                	ld	s10,432(sp)
    800045cc:	b305                	j	800042ec <exec+0x8a>
    800045ce:	e1243423          	sd	s2,-504(s0)
    800045d2:	7dba                	ld	s11,424(sp)
    800045d4:	a035                	j	80004600 <exec+0x39e>
    800045d6:	e1243423          	sd	s2,-504(s0)
    800045da:	7dba                	ld	s11,424(sp)
    800045dc:	a015                	j	80004600 <exec+0x39e>
    800045de:	e1243423          	sd	s2,-504(s0)
    800045e2:	7dba                	ld	s11,424(sp)
    800045e4:	a831                	j	80004600 <exec+0x39e>
    800045e6:	e1243423          	sd	s2,-504(s0)
    800045ea:	7dba                	ld	s11,424(sp)
    800045ec:	a811                	j	80004600 <exec+0x39e>
    800045ee:	e1243423          	sd	s2,-504(s0)
    800045f2:	7dba                	ld	s11,424(sp)
    800045f4:	a031                	j	80004600 <exec+0x39e>
  ip = 0;
    800045f6:	4a01                	li	s4,0
    800045f8:	a021                	j	80004600 <exec+0x39e>
    800045fa:	4a01                	li	s4,0
  if (pagetable) proc_freepagetable(pagetable, sz);
    800045fc:	a011                	j	80004600 <exec+0x39e>
    800045fe:	7dba                	ld	s11,424(sp)
    80004600:	e0843583          	ld	a1,-504(s0)
    80004604:	855a                	mv	a0,s6
    80004606:	ffffd097          	auipc	ra,0xffffd
    8000460a:	a64080e7          	jalr	-1436(ra) # 8000106a <proc_freepagetable>
  return -1;
    8000460e:	557d                	li	a0,-1
  if (ip) {
    80004610:	000a1b63          	bnez	s4,80004626 <exec+0x3c4>
    80004614:	79be                	ld	s3,488(sp)
    80004616:	7a1e                	ld	s4,480(sp)
    80004618:	6afe                	ld	s5,472(sp)
    8000461a:	6b5e                	ld	s6,464(sp)
    8000461c:	6bbe                	ld	s7,456(sp)
    8000461e:	6c1e                	ld	s8,448(sp)
    80004620:	7cfa                	ld	s9,440(sp)
    80004622:	7d5a                	ld	s10,432(sp)
    80004624:	b1e1                	j	800042ec <exec+0x8a>
    80004626:	79be                	ld	s3,488(sp)
    80004628:	6afe                	ld	s5,472(sp)
    8000462a:	6b5e                	ld	s6,464(sp)
    8000462c:	6bbe                	ld	s7,456(sp)
    8000462e:	6c1e                	ld	s8,448(sp)
    80004630:	7cfa                	ld	s9,440(sp)
    80004632:	7d5a                	ld	s10,432(sp)
    80004634:	b14d                	j	800042d6 <exec+0x74>
    80004636:	6b5e                	ld	s6,464(sp)
    80004638:	b979                	j	800042d6 <exec+0x74>
  sz = sz1;
    8000463a:	e0843983          	ld	s3,-504(s0)
    8000463e:	b591                	j	80004482 <exec+0x220>

0000000080004640 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80004640:	7179                	addi	sp,sp,-48
    80004642:	f406                	sd	ra,40(sp)
    80004644:	f022                	sd	s0,32(sp)
    80004646:	ec26                	sd	s1,24(sp)
    80004648:	e84a                	sd	s2,16(sp)
    8000464a:	1800                	addi	s0,sp,48
    8000464c:	892e                	mv	s2,a1
    8000464e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004650:	fdc40593          	addi	a1,s0,-36
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	aba080e7          	jalr	-1350(ra) # 8000210e <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    8000465c:	fdc42703          	lw	a4,-36(s0)
    80004660:	47bd                	li	a5,15
    80004662:	02e7eb63          	bltu	a5,a4,80004698 <argfd+0x58>
    80004666:	ffffd097          	auipc	ra,0xffffd
    8000466a:	8a0080e7          	jalr	-1888(ra) # 80000f06 <myproc>
    8000466e:	fdc42703          	lw	a4,-36(s0)
    80004672:	01a70793          	addi	a5,a4,26
    80004676:	078e                	slli	a5,a5,0x3
    80004678:	953e                	add	a0,a0,a5
    8000467a:	611c                	ld	a5,0(a0)
    8000467c:	c385                	beqz	a5,8000469c <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000467e:	00090463          	beqz	s2,80004686 <argfd+0x46>
    80004682:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    80004686:	4501                	li	a0,0
  if (pf) *pf = f;
    80004688:	c091                	beqz	s1,8000468c <argfd+0x4c>
    8000468a:	e09c                	sd	a5,0(s1)
}
    8000468c:	70a2                	ld	ra,40(sp)
    8000468e:	7402                	ld	s0,32(sp)
    80004690:	64e2                	ld	s1,24(sp)
    80004692:	6942                	ld	s2,16(sp)
    80004694:	6145                	addi	sp,sp,48
    80004696:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004698:	557d                	li	a0,-1
    8000469a:	bfcd                	j	8000468c <argfd+0x4c>
    8000469c:	557d                	li	a0,-1
    8000469e:	b7fd                	j	8000468c <argfd+0x4c>

00000000800046a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	e426                	sd	s1,8(sp)
    800046a8:	1000                	addi	s0,sp,32
    800046aa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046ac:	ffffd097          	auipc	ra,0xffffd
    800046b0:	85a080e7          	jalr	-1958(ra) # 80000f06 <myproc>
    800046b4:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    800046b6:	0d050793          	addi	a5,a0,208
    800046ba:	4501                	li	a0,0
    800046bc:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    800046be:	6398                	ld	a4,0(a5)
    800046c0:	cb19                	beqz	a4,800046d6 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    800046c2:	2505                	addiw	a0,a0,1
    800046c4:	07a1                	addi	a5,a5,8
    800046c6:	fed51ce3          	bne	a0,a3,800046be <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046ca:	557d                	li	a0,-1
}
    800046cc:	60e2                	ld	ra,24(sp)
    800046ce:	6442                	ld	s0,16(sp)
    800046d0:	64a2                	ld	s1,8(sp)
    800046d2:	6105                	addi	sp,sp,32
    800046d4:	8082                	ret
      p->ofile[fd] = f;
    800046d6:	01a50793          	addi	a5,a0,26
    800046da:	078e                	slli	a5,a5,0x3
    800046dc:	963e                	add	a2,a2,a5
    800046de:	e204                	sd	s1,0(a2)
      return fd;
    800046e0:	b7f5                	j	800046cc <fdalloc+0x2c>

00000000800046e2 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800046e2:	715d                	addi	sp,sp,-80
    800046e4:	e486                	sd	ra,72(sp)
    800046e6:	e0a2                	sd	s0,64(sp)
    800046e8:	fc26                	sd	s1,56(sp)
    800046ea:	f84a                	sd	s2,48(sp)
    800046ec:	f44e                	sd	s3,40(sp)
    800046ee:	ec56                	sd	s5,24(sp)
    800046f0:	e85a                	sd	s6,16(sp)
    800046f2:	0880                	addi	s0,sp,80
    800046f4:	8b2e                	mv	s6,a1
    800046f6:	89b2                	mv	s3,a2
    800046f8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    800046fa:	fb040593          	addi	a1,s0,-80
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	de2080e7          	jalr	-542(ra) # 800034e0 <nameiparent>
    80004706:	84aa                	mv	s1,a0
    80004708:	14050e63          	beqz	a0,80004864 <create+0x182>

  ilock(dp);
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	5e8080e7          	jalr	1512(ra) # 80002cf4 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004714:	4601                	li	a2,0
    80004716:	fb040593          	addi	a1,s0,-80
    8000471a:	8526                	mv	a0,s1
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	ae4080e7          	jalr	-1308(ra) # 80003200 <dirlookup>
    80004724:	8aaa                	mv	s5,a0
    80004726:	c539                	beqz	a0,80004774 <create+0x92>
    iunlockput(dp);
    80004728:	8526                	mv	a0,s1
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	830080e7          	jalr	-2000(ra) # 80002f5a <iunlockput>
    ilock(ip);
    80004732:	8556                	mv	a0,s5
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	5c0080e7          	jalr	1472(ra) # 80002cf4 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000473c:	4789                	li	a5,2
    8000473e:	02fb1463          	bne	s6,a5,80004766 <create+0x84>
    80004742:	044ad783          	lhu	a5,68(s5)
    80004746:	37f9                	addiw	a5,a5,-2
    80004748:	17c2                	slli	a5,a5,0x30
    8000474a:	93c1                	srli	a5,a5,0x30
    8000474c:	4705                	li	a4,1
    8000474e:	00f76c63          	bltu	a4,a5,80004766 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004752:	8556                	mv	a0,s5
    80004754:	60a6                	ld	ra,72(sp)
    80004756:	6406                	ld	s0,64(sp)
    80004758:	74e2                	ld	s1,56(sp)
    8000475a:	7942                	ld	s2,48(sp)
    8000475c:	79a2                	ld	s3,40(sp)
    8000475e:	6ae2                	ld	s5,24(sp)
    80004760:	6b42                	ld	s6,16(sp)
    80004762:	6161                	addi	sp,sp,80
    80004764:	8082                	ret
    iunlockput(ip);
    80004766:	8556                	mv	a0,s5
    80004768:	ffffe097          	auipc	ra,0xffffe
    8000476c:	7f2080e7          	jalr	2034(ra) # 80002f5a <iunlockput>
    return 0;
    80004770:	4a81                	li	s5,0
    80004772:	b7c5                	j	80004752 <create+0x70>
    80004774:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004776:	85da                	mv	a1,s6
    80004778:	4088                	lw	a0,0(s1)
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	3d6080e7          	jalr	982(ra) # 80002b50 <ialloc>
    80004782:	8a2a                	mv	s4,a0
    80004784:	c531                	beqz	a0,800047d0 <create+0xee>
  ilock(ip);
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	56e080e7          	jalr	1390(ra) # 80002cf4 <ilock>
  ip->major = major;
    8000478e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004792:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004796:	4905                	li	s2,1
    80004798:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000479c:	8552                	mv	a0,s4
    8000479e:	ffffe097          	auipc	ra,0xffffe
    800047a2:	48a080e7          	jalr	1162(ra) # 80002c28 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    800047a6:	032b0d63          	beq	s6,s2,800047e0 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800047aa:	004a2603          	lw	a2,4(s4)
    800047ae:	fb040593          	addi	a1,s0,-80
    800047b2:	8526                	mv	a0,s1
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	c5c080e7          	jalr	-932(ra) # 80003410 <dirlink>
    800047bc:	08054163          	bltz	a0,8000483e <create+0x15c>
  iunlockput(dp);
    800047c0:	8526                	mv	a0,s1
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	798080e7          	jalr	1944(ra) # 80002f5a <iunlockput>
  return ip;
    800047ca:	8ad2                	mv	s5,s4
    800047cc:	7a02                	ld	s4,32(sp)
    800047ce:	b751                	j	80004752 <create+0x70>
    iunlockput(dp);
    800047d0:	8526                	mv	a0,s1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	788080e7          	jalr	1928(ra) # 80002f5a <iunlockput>
    return 0;
    800047da:	8ad2                	mv	s5,s4
    800047dc:	7a02                	ld	s4,32(sp)
    800047de:	bf95                	j	80004752 <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047e0:	004a2603          	lw	a2,4(s4)
    800047e4:	00004597          	auipc	a1,0x4
    800047e8:	dd458593          	addi	a1,a1,-556 # 800085b8 <etext+0x5b8>
    800047ec:	8552                	mv	a0,s4
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	c22080e7          	jalr	-990(ra) # 80003410 <dirlink>
    800047f6:	04054463          	bltz	a0,8000483e <create+0x15c>
    800047fa:	40d0                	lw	a2,4(s1)
    800047fc:	00004597          	auipc	a1,0x4
    80004800:	dc458593          	addi	a1,a1,-572 # 800085c0 <etext+0x5c0>
    80004804:	8552                	mv	a0,s4
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	c0a080e7          	jalr	-1014(ra) # 80003410 <dirlink>
    8000480e:	02054863          	bltz	a0,8000483e <create+0x15c>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004812:	004a2603          	lw	a2,4(s4)
    80004816:	fb040593          	addi	a1,s0,-80
    8000481a:	8526                	mv	a0,s1
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	bf4080e7          	jalr	-1036(ra) # 80003410 <dirlink>
    80004824:	00054d63          	bltz	a0,8000483e <create+0x15c>
    dp->nlink++;  // for ".."
    80004828:	04a4d783          	lhu	a5,74(s1)
    8000482c:	2785                	addiw	a5,a5,1
    8000482e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004832:	8526                	mv	a0,s1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	3f4080e7          	jalr	1012(ra) # 80002c28 <iupdate>
    8000483c:	b751                	j	800047c0 <create+0xde>
  ip->nlink = 0;
    8000483e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004842:	8552                	mv	a0,s4
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	3e4080e7          	jalr	996(ra) # 80002c28 <iupdate>
  iunlockput(ip);
    8000484c:	8552                	mv	a0,s4
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	70c080e7          	jalr	1804(ra) # 80002f5a <iunlockput>
  iunlockput(dp);
    80004856:	8526                	mv	a0,s1
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	702080e7          	jalr	1794(ra) # 80002f5a <iunlockput>
  return 0;
    80004860:	7a02                	ld	s4,32(sp)
    80004862:	bdc5                	j	80004752 <create+0x70>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004864:	8aaa                	mv	s5,a0
    80004866:	b5f5                	j	80004752 <create+0x70>

0000000080004868 <sys_dup>:
uint64 sys_dup(void) {
    80004868:	7179                	addi	sp,sp,-48
    8000486a:	f406                	sd	ra,40(sp)
    8000486c:	f022                	sd	s0,32(sp)
    8000486e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004870:	fd840613          	addi	a2,s0,-40
    80004874:	4581                	li	a1,0
    80004876:	4501                	li	a0,0
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	dc8080e7          	jalr	-568(ra) # 80004640 <argfd>
    80004880:	57fd                	li	a5,-1
    80004882:	02054763          	bltz	a0,800048b0 <sys_dup+0x48>
    80004886:	ec26                	sd	s1,24(sp)
    80004888:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0) return -1;
    8000488a:	fd843903          	ld	s2,-40(s0)
    8000488e:	854a                	mv	a0,s2
    80004890:	00000097          	auipc	ra,0x0
    80004894:	e10080e7          	jalr	-496(ra) # 800046a0 <fdalloc>
    80004898:	84aa                	mv	s1,a0
    8000489a:	57fd                	li	a5,-1
    8000489c:	00054f63          	bltz	a0,800048ba <sys_dup+0x52>
  filedup(f);
    800048a0:	854a                	mv	a0,s2
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	298080e7          	jalr	664(ra) # 80003b3a <filedup>
  return fd;
    800048aa:	87a6                	mv	a5,s1
    800048ac:	64e2                	ld	s1,24(sp)
    800048ae:	6942                	ld	s2,16(sp)
}
    800048b0:	853e                	mv	a0,a5
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	6145                	addi	sp,sp,48
    800048b8:	8082                	ret
    800048ba:	64e2                	ld	s1,24(sp)
    800048bc:	6942                	ld	s2,16(sp)
    800048be:	bfcd                	j	800048b0 <sys_dup+0x48>

00000000800048c0 <sys_read>:
uint64 sys_read(void) {
    800048c0:	7179                	addi	sp,sp,-48
    800048c2:	f406                	sd	ra,40(sp)
    800048c4:	f022                	sd	s0,32(sp)
    800048c6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048c8:	fd840593          	addi	a1,s0,-40
    800048cc:	4505                	li	a0,1
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	860080e7          	jalr	-1952(ra) # 8000212e <argaddr>
  argint(2, &n);
    800048d6:	fe440593          	addi	a1,s0,-28
    800048da:	4509                	li	a0,2
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	832080e7          	jalr	-1998(ra) # 8000210e <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800048e4:	fe840613          	addi	a2,s0,-24
    800048e8:	4581                	li	a1,0
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	d54080e7          	jalr	-684(ra) # 80004640 <argfd>
    800048f4:	87aa                	mv	a5,a0
    800048f6:	557d                	li	a0,-1
    800048f8:	0007cc63          	bltz	a5,80004910 <sys_read+0x50>
  return fileread(f, p, n);
    800048fc:	fe442603          	lw	a2,-28(s0)
    80004900:	fd843583          	ld	a1,-40(s0)
    80004904:	fe843503          	ld	a0,-24(s0)
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	3d8080e7          	jalr	984(ra) # 80003ce0 <fileread>
}
    80004910:	70a2                	ld	ra,40(sp)
    80004912:	7402                	ld	s0,32(sp)
    80004914:	6145                	addi	sp,sp,48
    80004916:	8082                	ret

0000000080004918 <sys_write>:
uint64 sys_write(void) {
    80004918:	7179                	addi	sp,sp,-48
    8000491a:	f406                	sd	ra,40(sp)
    8000491c:	f022                	sd	s0,32(sp)
    8000491e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004920:	fd840593          	addi	a1,s0,-40
    80004924:	4505                	li	a0,1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	808080e7          	jalr	-2040(ra) # 8000212e <argaddr>
  argint(2, &n);
    8000492e:	fe440593          	addi	a1,s0,-28
    80004932:	4509                	li	a0,2
    80004934:	ffffd097          	auipc	ra,0xffffd
    80004938:	7da080e7          	jalr	2010(ra) # 8000210e <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    8000493c:	fe840613          	addi	a2,s0,-24
    80004940:	4581                	li	a1,0
    80004942:	4501                	li	a0,0
    80004944:	00000097          	auipc	ra,0x0
    80004948:	cfc080e7          	jalr	-772(ra) # 80004640 <argfd>
    8000494c:	87aa                	mv	a5,a0
    8000494e:	557d                	li	a0,-1
    80004950:	0007cc63          	bltz	a5,80004968 <sys_write+0x50>
  return filewrite(f, p, n);
    80004954:	fe442603          	lw	a2,-28(s0)
    80004958:	fd843583          	ld	a1,-40(s0)
    8000495c:	fe843503          	ld	a0,-24(s0)
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	452080e7          	jalr	1106(ra) # 80003db2 <filewrite>
}
    80004968:	70a2                	ld	ra,40(sp)
    8000496a:	7402                	ld	s0,32(sp)
    8000496c:	6145                	addi	sp,sp,48
    8000496e:	8082                	ret

0000000080004970 <sys_close>:
uint64 sys_close(void) {
    80004970:	1101                	addi	sp,sp,-32
    80004972:	ec06                	sd	ra,24(sp)
    80004974:	e822                	sd	s0,16(sp)
    80004976:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004978:	fe040613          	addi	a2,s0,-32
    8000497c:	fec40593          	addi	a1,s0,-20
    80004980:	4501                	li	a0,0
    80004982:	00000097          	auipc	ra,0x0
    80004986:	cbe080e7          	jalr	-834(ra) # 80004640 <argfd>
    8000498a:	57fd                	li	a5,-1
    8000498c:	02054463          	bltz	a0,800049b4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004990:	ffffc097          	auipc	ra,0xffffc
    80004994:	576080e7          	jalr	1398(ra) # 80000f06 <myproc>
    80004998:	fec42783          	lw	a5,-20(s0)
    8000499c:	07e9                	addi	a5,a5,26
    8000499e:	078e                	slli	a5,a5,0x3
    800049a0:	953e                	add	a0,a0,a5
    800049a2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049a6:	fe043503          	ld	a0,-32(s0)
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	1e2080e7          	jalr	482(ra) # 80003b8c <fileclose>
  return 0;
    800049b2:	4781                	li	a5,0
}
    800049b4:	853e                	mv	a0,a5
    800049b6:	60e2                	ld	ra,24(sp)
    800049b8:	6442                	ld	s0,16(sp)
    800049ba:	6105                	addi	sp,sp,32
    800049bc:	8082                	ret

00000000800049be <sys_fstat>:
uint64 sys_fstat(void) {
    800049be:	1101                	addi	sp,sp,-32
    800049c0:	ec06                	sd	ra,24(sp)
    800049c2:	e822                	sd	s0,16(sp)
    800049c4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049c6:	fe040593          	addi	a1,s0,-32
    800049ca:	4505                	li	a0,1
    800049cc:	ffffd097          	auipc	ra,0xffffd
    800049d0:	762080e7          	jalr	1890(ra) # 8000212e <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    800049d4:	fe840613          	addi	a2,s0,-24
    800049d8:	4581                	li	a1,0
    800049da:	4501                	li	a0,0
    800049dc:	00000097          	auipc	ra,0x0
    800049e0:	c64080e7          	jalr	-924(ra) # 80004640 <argfd>
    800049e4:	87aa                	mv	a5,a0
    800049e6:	557d                	li	a0,-1
    800049e8:	0007ca63          	bltz	a5,800049fc <sys_fstat+0x3e>
  return filestat(f, st);
    800049ec:	fe043583          	ld	a1,-32(s0)
    800049f0:	fe843503          	ld	a0,-24(s0)
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	27a080e7          	jalr	634(ra) # 80003c6e <filestat>
}
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	6105                	addi	sp,sp,32
    80004a02:	8082                	ret

0000000080004a04 <sys_link>:
uint64 sys_link(void) {
    80004a04:	7169                	addi	sp,sp,-304
    80004a06:	f606                	sd	ra,296(sp)
    80004a08:	f222                	sd	s0,288(sp)
    80004a0a:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004a0c:	08000613          	li	a2,128
    80004a10:	ed040593          	addi	a1,s0,-304
    80004a14:	4501                	li	a0,0
    80004a16:	ffffd097          	auipc	ra,0xffffd
    80004a1a:	738080e7          	jalr	1848(ra) # 8000214e <argstr>
    80004a1e:	57fd                	li	a5,-1
    80004a20:	12054663          	bltz	a0,80004b4c <sys_link+0x148>
    80004a24:	08000613          	li	a2,128
    80004a28:	f5040593          	addi	a1,s0,-176
    80004a2c:	4505                	li	a0,1
    80004a2e:	ffffd097          	auipc	ra,0xffffd
    80004a32:	720080e7          	jalr	1824(ra) # 8000214e <argstr>
    80004a36:	57fd                	li	a5,-1
    80004a38:	10054a63          	bltz	a0,80004b4c <sys_link+0x148>
    80004a3c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	c84080e7          	jalr	-892(ra) # 800036c2 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004a46:	ed040513          	addi	a0,s0,-304
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	a78080e7          	jalr	-1416(ra) # 800034c2 <namei>
    80004a52:	84aa                	mv	s1,a0
    80004a54:	c949                	beqz	a0,80004ae6 <sys_link+0xe2>
  ilock(ip);
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	29e080e7          	jalr	670(ra) # 80002cf4 <ilock>
  if (ip->type == T_DIR) {
    80004a5e:	04449703          	lh	a4,68(s1)
    80004a62:	4785                	li	a5,1
    80004a64:	08f70863          	beq	a4,a5,80004af4 <sys_link+0xf0>
    80004a68:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a6a:	04a4d783          	lhu	a5,74(s1)
    80004a6e:	2785                	addiw	a5,a5,1
    80004a70:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	1b2080e7          	jalr	434(ra) # 80002c28 <iupdate>
  iunlock(ip);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	33a080e7          	jalr	826(ra) # 80002dba <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004a88:	fd040593          	addi	a1,s0,-48
    80004a8c:	f5040513          	addi	a0,s0,-176
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	a50080e7          	jalr	-1456(ra) # 800034e0 <nameiparent>
    80004a98:	892a                	mv	s2,a0
    80004a9a:	cd35                	beqz	a0,80004b16 <sys_link+0x112>
  ilock(dp);
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	258080e7          	jalr	600(ra) # 80002cf4 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004aa4:	00092703          	lw	a4,0(s2)
    80004aa8:	409c                	lw	a5,0(s1)
    80004aaa:	06f71163          	bne	a4,a5,80004b0c <sys_link+0x108>
    80004aae:	40d0                	lw	a2,4(s1)
    80004ab0:	fd040593          	addi	a1,s0,-48
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	95a080e7          	jalr	-1702(ra) # 80003410 <dirlink>
    80004abe:	04054763          	bltz	a0,80004b0c <sys_link+0x108>
  iunlockput(dp);
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	496080e7          	jalr	1174(ra) # 80002f5a <iunlockput>
  iput(ip);
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	3e4080e7          	jalr	996(ra) # 80002eb2 <iput>
  end_op();
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	c66080e7          	jalr	-922(ra) # 8000373c <end_op>
  return 0;
    80004ade:	4781                	li	a5,0
    80004ae0:	64f2                	ld	s1,280(sp)
    80004ae2:	6952                	ld	s2,272(sp)
    80004ae4:	a0a5                	j	80004b4c <sys_link+0x148>
    end_op();
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	c56080e7          	jalr	-938(ra) # 8000373c <end_op>
    return -1;
    80004aee:	57fd                	li	a5,-1
    80004af0:	64f2                	ld	s1,280(sp)
    80004af2:	a8a9                	j	80004b4c <sys_link+0x148>
    iunlockput(ip);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	464080e7          	jalr	1124(ra) # 80002f5a <iunlockput>
    end_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	c3e080e7          	jalr	-962(ra) # 8000373c <end_op>
    return -1;
    80004b06:	57fd                	li	a5,-1
    80004b08:	64f2                	ld	s1,280(sp)
    80004b0a:	a089                	j	80004b4c <sys_link+0x148>
    iunlockput(dp);
    80004b0c:	854a                	mv	a0,s2
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	44c080e7          	jalr	1100(ra) # 80002f5a <iunlockput>
  ilock(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	1dc080e7          	jalr	476(ra) # 80002cf4 <ilock>
  ip->nlink--;
    80004b20:	04a4d783          	lhu	a5,74(s1)
    80004b24:	37fd                	addiw	a5,a5,-1
    80004b26:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	0fc080e7          	jalr	252(ra) # 80002c28 <iupdate>
  iunlockput(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	424080e7          	jalr	1060(ra) # 80002f5a <iunlockput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	bfe080e7          	jalr	-1026(ra) # 8000373c <end_op>
  return -1;
    80004b46:	57fd                	li	a5,-1
    80004b48:	64f2                	ld	s1,280(sp)
    80004b4a:	6952                	ld	s2,272(sp)
}
    80004b4c:	853e                	mv	a0,a5
    80004b4e:	70b2                	ld	ra,296(sp)
    80004b50:	7412                	ld	s0,288(sp)
    80004b52:	6155                	addi	sp,sp,304
    80004b54:	8082                	ret

0000000080004b56 <sys_unlink>:
uint64 sys_unlink(void) {
    80004b56:	7151                	addi	sp,sp,-240
    80004b58:	f586                	sd	ra,232(sp)
    80004b5a:	f1a2                	sd	s0,224(sp)
    80004b5c:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004b5e:	08000613          	li	a2,128
    80004b62:	f3040593          	addi	a1,s0,-208
    80004b66:	4501                	li	a0,0
    80004b68:	ffffd097          	auipc	ra,0xffffd
    80004b6c:	5e6080e7          	jalr	1510(ra) # 8000214e <argstr>
    80004b70:	1a054a63          	bltz	a0,80004d24 <sys_unlink+0x1ce>
    80004b74:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	b4c080e7          	jalr	-1204(ra) # 800036c2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004b7e:	fb040593          	addi	a1,s0,-80
    80004b82:	f3040513          	addi	a0,s0,-208
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	95a080e7          	jalr	-1702(ra) # 800034e0 <nameiparent>
    80004b8e:	84aa                	mv	s1,a0
    80004b90:	cd71                	beqz	a0,80004c6c <sys_unlink+0x116>
  ilock(dp);
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	162080e7          	jalr	354(ra) # 80002cf4 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004b9a:	00004597          	auipc	a1,0x4
    80004b9e:	a1e58593          	addi	a1,a1,-1506 # 800085b8 <etext+0x5b8>
    80004ba2:	fb040513          	addi	a0,s0,-80
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	640080e7          	jalr	1600(ra) # 800031e6 <namecmp>
    80004bae:	14050c63          	beqz	a0,80004d06 <sys_unlink+0x1b0>
    80004bb2:	00004597          	auipc	a1,0x4
    80004bb6:	a0e58593          	addi	a1,a1,-1522 # 800085c0 <etext+0x5c0>
    80004bba:	fb040513          	addi	a0,s0,-80
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	628080e7          	jalr	1576(ra) # 800031e6 <namecmp>
    80004bc6:	14050063          	beqz	a0,80004d06 <sys_unlink+0x1b0>
    80004bca:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004bcc:	f2c40613          	addi	a2,s0,-212
    80004bd0:	fb040593          	addi	a1,s0,-80
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	62a080e7          	jalr	1578(ra) # 80003200 <dirlookup>
    80004bde:	892a                	mv	s2,a0
    80004be0:	12050263          	beqz	a0,80004d04 <sys_unlink+0x1ae>
  ilock(ip);
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	110080e7          	jalr	272(ra) # 80002cf4 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004bec:	04a91783          	lh	a5,74(s2)
    80004bf0:	08f05563          	blez	a5,80004c7a <sys_unlink+0x124>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004bf4:	04491703          	lh	a4,68(s2)
    80004bf8:	4785                	li	a5,1
    80004bfa:	08f70963          	beq	a4,a5,80004c8c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004bfe:	4641                	li	a2,16
    80004c00:	4581                	li	a1,0
    80004c02:	fc040513          	addi	a0,s0,-64
    80004c06:	ffffb097          	auipc	ra,0xffffb
    80004c0a:	574080e7          	jalr	1396(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c0e:	4741                	li	a4,16
    80004c10:	f2c42683          	lw	a3,-212(s0)
    80004c14:	fc040613          	addi	a2,s0,-64
    80004c18:	4581                	li	a1,0
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	4a0080e7          	jalr	1184(ra) # 800030bc <writei>
    80004c24:	47c1                	li	a5,16
    80004c26:	0af51b63          	bne	a0,a5,80004cdc <sys_unlink+0x186>
  if (ip->type == T_DIR) {
    80004c2a:	04491703          	lh	a4,68(s2)
    80004c2e:	4785                	li	a5,1
    80004c30:	0af70f63          	beq	a4,a5,80004cee <sys_unlink+0x198>
  iunlockput(dp);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	324080e7          	jalr	804(ra) # 80002f5a <iunlockput>
  ip->nlink--;
    80004c3e:	04a95783          	lhu	a5,74(s2)
    80004c42:	37fd                	addiw	a5,a5,-1
    80004c44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	fde080e7          	jalr	-34(ra) # 80002c28 <iupdate>
  iunlockput(ip);
    80004c52:	854a                	mv	a0,s2
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	306080e7          	jalr	774(ra) # 80002f5a <iunlockput>
  end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	ae0080e7          	jalr	-1312(ra) # 8000373c <end_op>
  return 0;
    80004c64:	4501                	li	a0,0
    80004c66:	64ee                	ld	s1,216(sp)
    80004c68:	694e                	ld	s2,208(sp)
    80004c6a:	a84d                	j	80004d1c <sys_unlink+0x1c6>
    end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	ad0080e7          	jalr	-1328(ra) # 8000373c <end_op>
    return -1;
    80004c74:	557d                	li	a0,-1
    80004c76:	64ee                	ld	s1,216(sp)
    80004c78:	a055                	j	80004d1c <sys_unlink+0x1c6>
    80004c7a:	e5ce                	sd	s3,200(sp)
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004c7c:	00004517          	auipc	a0,0x4
    80004c80:	94c50513          	addi	a0,a0,-1716 # 800085c8 <etext+0x5c8>
    80004c84:	00001097          	auipc	ra,0x1
    80004c88:	23e080e7          	jalr	574(ra) # 80005ec2 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004c8c:	04c92703          	lw	a4,76(s2)
    80004c90:	02000793          	li	a5,32
    80004c94:	f6e7f5e3          	bgeu	a5,a4,80004bfe <sys_unlink+0xa8>
    80004c98:	e5ce                	sd	s3,200(sp)
    80004c9a:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c9e:	4741                	li	a4,16
    80004ca0:	86ce                	mv	a3,s3
    80004ca2:	f1840613          	addi	a2,s0,-232
    80004ca6:	4581                	li	a1,0
    80004ca8:	854a                	mv	a0,s2
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	302080e7          	jalr	770(ra) # 80002fac <readi>
    80004cb2:	47c1                	li	a5,16
    80004cb4:	00f51c63          	bne	a0,a5,80004ccc <sys_unlink+0x176>
    if (de.inum != 0) return 0;
    80004cb8:	f1845783          	lhu	a5,-232(s0)
    80004cbc:	e7b5                	bnez	a5,80004d28 <sys_unlink+0x1d2>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004cbe:	29c1                	addiw	s3,s3,16
    80004cc0:	04c92783          	lw	a5,76(s2)
    80004cc4:	fcf9ede3          	bltu	s3,a5,80004c9e <sys_unlink+0x148>
    80004cc8:	69ae                	ld	s3,200(sp)
    80004cca:	bf15                	j	80004bfe <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004ccc:	00004517          	auipc	a0,0x4
    80004cd0:	91450513          	addi	a0,a0,-1772 # 800085e0 <etext+0x5e0>
    80004cd4:	00001097          	auipc	ra,0x1
    80004cd8:	1ee080e7          	jalr	494(ra) # 80005ec2 <panic>
    80004cdc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004cde:	00004517          	auipc	a0,0x4
    80004ce2:	91a50513          	addi	a0,a0,-1766 # 800085f8 <etext+0x5f8>
    80004ce6:	00001097          	auipc	ra,0x1
    80004cea:	1dc080e7          	jalr	476(ra) # 80005ec2 <panic>
    dp->nlink--;
    80004cee:	04a4d783          	lhu	a5,74(s1)
    80004cf2:	37fd                	addiw	a5,a5,-1
    80004cf4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	f2e080e7          	jalr	-210(ra) # 80002c28 <iupdate>
    80004d02:	bf0d                	j	80004c34 <sys_unlink+0xde>
    80004d04:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d06:	8526                	mv	a0,s1
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	252080e7          	jalr	594(ra) # 80002f5a <iunlockput>
  end_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	a2c080e7          	jalr	-1492(ra) # 8000373c <end_op>
  return -1;
    80004d18:	557d                	li	a0,-1
    80004d1a:	64ee                	ld	s1,216(sp)
}
    80004d1c:	70ae                	ld	ra,232(sp)
    80004d1e:	740e                	ld	s0,224(sp)
    80004d20:	616d                	addi	sp,sp,240
    80004d22:	8082                	ret
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004d24:	557d                	li	a0,-1
    80004d26:	bfdd                	j	80004d1c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d28:	854a                	mv	a0,s2
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	230080e7          	jalr	560(ra) # 80002f5a <iunlockput>
    goto bad;
    80004d32:	694e                	ld	s2,208(sp)
    80004d34:	69ae                	ld	s3,200(sp)
    80004d36:	bfc1                	j	80004d06 <sys_unlink+0x1b0>

0000000080004d38 <sys_open>:

uint64 sys_open(void) {
    80004d38:	7131                	addi	sp,sp,-192
    80004d3a:	fd06                	sd	ra,184(sp)
    80004d3c:	f922                	sd	s0,176(sp)
    80004d3e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d40:	f4c40593          	addi	a1,s0,-180
    80004d44:	4505                	li	a0,1
    80004d46:	ffffd097          	auipc	ra,0xffffd
    80004d4a:	3c8080e7          	jalr	968(ra) # 8000210e <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004d4e:	08000613          	li	a2,128
    80004d52:	f5040593          	addi	a1,s0,-176
    80004d56:	4501                	li	a0,0
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	3f6080e7          	jalr	1014(ra) # 8000214e <argstr>
    80004d60:	87aa                	mv	a5,a0
    80004d62:	557d                	li	a0,-1
    80004d64:	0a07ce63          	bltz	a5,80004e20 <sys_open+0xe8>
    80004d68:	f526                	sd	s1,168(sp)

  begin_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	958080e7          	jalr	-1704(ra) # 800036c2 <begin_op>

  if (omode & O_CREATE) {
    80004d72:	f4c42783          	lw	a5,-180(s0)
    80004d76:	2007f793          	andi	a5,a5,512
    80004d7a:	cfd5                	beqz	a5,80004e36 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d7c:	4681                	li	a3,0
    80004d7e:	4601                	li	a2,0
    80004d80:	4589                	li	a1,2
    80004d82:	f5040513          	addi	a0,s0,-176
    80004d86:	00000097          	auipc	ra,0x0
    80004d8a:	95c080e7          	jalr	-1700(ra) # 800046e2 <create>
    80004d8e:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004d90:	cd41                	beqz	a0,80004e28 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004d92:	04449703          	lh	a4,68(s1)
    80004d96:	478d                	li	a5,3
    80004d98:	00f71763          	bne	a4,a5,80004da6 <sys_open+0x6e>
    80004d9c:	0464d703          	lhu	a4,70(s1)
    80004da0:	47a5                	li	a5,9
    80004da2:	0ee7e163          	bltu	a5,a4,80004e84 <sys_open+0x14c>
    80004da6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	d28080e7          	jalr	-728(ra) # 80003ad0 <filealloc>
    80004db0:	892a                	mv	s2,a0
    80004db2:	c97d                	beqz	a0,80004ea8 <sys_open+0x170>
    80004db4:	ed4e                	sd	s3,152(sp)
    80004db6:	00000097          	auipc	ra,0x0
    80004dba:	8ea080e7          	jalr	-1814(ra) # 800046a0 <fdalloc>
    80004dbe:	89aa                	mv	s3,a0
    80004dc0:	0c054e63          	bltz	a0,80004e9c <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004dc4:	04449703          	lh	a4,68(s1)
    80004dc8:	478d                	li	a5,3
    80004dca:	0ef70c63          	beq	a4,a5,80004ec2 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dce:	4789                	li	a5,2
    80004dd0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004dd4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004dd8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ddc:	f4c42783          	lw	a5,-180(s0)
    80004de0:	0017c713          	xori	a4,a5,1
    80004de4:	8b05                	andi	a4,a4,1
    80004de6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dea:	0037f713          	andi	a4,a5,3
    80004dee:	00e03733          	snez	a4,a4
    80004df2:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004df6:	4007f793          	andi	a5,a5,1024
    80004dfa:	c791                	beqz	a5,80004e06 <sys_open+0xce>
    80004dfc:	04449703          	lh	a4,68(s1)
    80004e00:	4789                	li	a5,2
    80004e02:	0cf70763          	beq	a4,a5,80004ed0 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004e06:	8526                	mv	a0,s1
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	fb2080e7          	jalr	-78(ra) # 80002dba <iunlock>
  end_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	92c080e7          	jalr	-1748(ra) # 8000373c <end_op>

  return fd;
    80004e18:	854e                	mv	a0,s3
    80004e1a:	74aa                	ld	s1,168(sp)
    80004e1c:	790a                	ld	s2,160(sp)
    80004e1e:	69ea                	ld	s3,152(sp)
}
    80004e20:	70ea                	ld	ra,184(sp)
    80004e22:	744a                	ld	s0,176(sp)
    80004e24:	6129                	addi	sp,sp,192
    80004e26:	8082                	ret
      end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	914080e7          	jalr	-1772(ra) # 8000373c <end_op>
      return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	74aa                	ld	s1,168(sp)
    80004e34:	b7f5                	j	80004e20 <sys_open+0xe8>
    if ((ip = namei(path)) == 0) {
    80004e36:	f5040513          	addi	a0,s0,-176
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	688080e7          	jalr	1672(ra) # 800034c2 <namei>
    80004e42:	84aa                	mv	s1,a0
    80004e44:	c90d                	beqz	a0,80004e76 <sys_open+0x13e>
    ilock(ip);
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	eae080e7          	jalr	-338(ra) # 80002cf4 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004e4e:	04449703          	lh	a4,68(s1)
    80004e52:	4785                	li	a5,1
    80004e54:	f2f71fe3          	bne	a4,a5,80004d92 <sys_open+0x5a>
    80004e58:	f4c42783          	lw	a5,-180(s0)
    80004e5c:	d7a9                	beqz	a5,80004da6 <sys_open+0x6e>
      iunlockput(ip);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	0fa080e7          	jalr	250(ra) # 80002f5a <iunlockput>
      end_op();
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	8d4080e7          	jalr	-1836(ra) # 8000373c <end_op>
      return -1;
    80004e70:	557d                	li	a0,-1
    80004e72:	74aa                	ld	s1,168(sp)
    80004e74:	b775                	j	80004e20 <sys_open+0xe8>
      end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	8c6080e7          	jalr	-1850(ra) # 8000373c <end_op>
      return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	74aa                	ld	s1,168(sp)
    80004e82:	bf79                	j	80004e20 <sys_open+0xe8>
    iunlockput(ip);
    80004e84:	8526                	mv	a0,s1
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	0d4080e7          	jalr	212(ra) # 80002f5a <iunlockput>
    end_op();
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	8ae080e7          	jalr	-1874(ra) # 8000373c <end_op>
    return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	74aa                	ld	s1,168(sp)
    80004e9a:	b759                	j	80004e20 <sys_open+0xe8>
    if (f) fileclose(f);
    80004e9c:	854a                	mv	a0,s2
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	cee080e7          	jalr	-786(ra) # 80003b8c <fileclose>
    80004ea6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	0b0080e7          	jalr	176(ra) # 80002f5a <iunlockput>
    end_op();
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	88a080e7          	jalr	-1910(ra) # 8000373c <end_op>
    return -1;
    80004eba:	557d                	li	a0,-1
    80004ebc:	74aa                	ld	s1,168(sp)
    80004ebe:	790a                	ld	s2,160(sp)
    80004ec0:	b785                	j	80004e20 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004ec2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ec6:	04649783          	lh	a5,70(s1)
    80004eca:	02f91223          	sh	a5,36(s2)
    80004ece:	b729                	j	80004dd8 <sys_open+0xa0>
    itrunc(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	ffffe097          	auipc	ra,0xffffe
    80004ed6:	f34080e7          	jalr	-204(ra) # 80002e06 <itrunc>
    80004eda:	b735                	j	80004e06 <sys_open+0xce>

0000000080004edc <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004edc:	7175                	addi	sp,sp,-144
    80004ede:	e506                	sd	ra,136(sp)
    80004ee0:	e122                	sd	s0,128(sp)
    80004ee2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	7de080e7          	jalr	2014(ra) # 800036c2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004eec:	08000613          	li	a2,128
    80004ef0:	f7040593          	addi	a1,s0,-144
    80004ef4:	4501                	li	a0,0
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	258080e7          	jalr	600(ra) # 8000214e <argstr>
    80004efe:	02054963          	bltz	a0,80004f30 <sys_mkdir+0x54>
    80004f02:	4681                	li	a3,0
    80004f04:	4601                	li	a2,0
    80004f06:	4585                	li	a1,1
    80004f08:	f7040513          	addi	a0,s0,-144
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	7d6080e7          	jalr	2006(ra) # 800046e2 <create>
    80004f14:	cd11                	beqz	a0,80004f30 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	044080e7          	jalr	68(ra) # 80002f5a <iunlockput>
  end_op();
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	81e080e7          	jalr	-2018(ra) # 8000373c <end_op>
  return 0;
    80004f26:	4501                	li	a0,0
}
    80004f28:	60aa                	ld	ra,136(sp)
    80004f2a:	640a                	ld	s0,128(sp)
    80004f2c:	6149                	addi	sp,sp,144
    80004f2e:	8082                	ret
    end_op();
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	80c080e7          	jalr	-2036(ra) # 8000373c <end_op>
    return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	b7fd                	j	80004f28 <sys_mkdir+0x4c>

0000000080004f3c <sys_mknod>:

uint64 sys_mknod(void) {
    80004f3c:	7135                	addi	sp,sp,-160
    80004f3e:	ed06                	sd	ra,152(sp)
    80004f40:	e922                	sd	s0,144(sp)
    80004f42:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	77e080e7          	jalr	1918(ra) # 800036c2 <begin_op>
  argint(1, &major);
    80004f4c:	f6c40593          	addi	a1,s0,-148
    80004f50:	4505                	li	a0,1
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	1bc080e7          	jalr	444(ra) # 8000210e <argint>
  argint(2, &minor);
    80004f5a:	f6840593          	addi	a1,s0,-152
    80004f5e:	4509                	li	a0,2
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	1ae080e7          	jalr	430(ra) # 8000210e <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004f68:	08000613          	li	a2,128
    80004f6c:	f7040593          	addi	a1,s0,-144
    80004f70:	4501                	li	a0,0
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	1dc080e7          	jalr	476(ra) # 8000214e <argstr>
    80004f7a:	02054b63          	bltz	a0,80004fb0 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004f7e:	f6841683          	lh	a3,-152(s0)
    80004f82:	f6c41603          	lh	a2,-148(s0)
    80004f86:	458d                	li	a1,3
    80004f88:	f7040513          	addi	a0,s0,-144
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	756080e7          	jalr	1878(ra) # 800046e2 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004f94:	cd11                	beqz	a0,80004fb0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	fc4080e7          	jalr	-60(ra) # 80002f5a <iunlockput>
  end_op();
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	79e080e7          	jalr	1950(ra) # 8000373c <end_op>
  return 0;
    80004fa6:	4501                	li	a0,0
}
    80004fa8:	60ea                	ld	ra,152(sp)
    80004faa:	644a                	ld	s0,144(sp)
    80004fac:	610d                	addi	sp,sp,160
    80004fae:	8082                	ret
    end_op();
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	78c080e7          	jalr	1932(ra) # 8000373c <end_op>
    return -1;
    80004fb8:	557d                	li	a0,-1
    80004fba:	b7fd                	j	80004fa8 <sys_mknod+0x6c>

0000000080004fbc <sys_chdir>:

uint64 sys_chdir(void) {
    80004fbc:	7135                	addi	sp,sp,-160
    80004fbe:	ed06                	sd	ra,152(sp)
    80004fc0:	e922                	sd	s0,144(sp)
    80004fc2:	e14a                	sd	s2,128(sp)
    80004fc4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fc6:	ffffc097          	auipc	ra,0xffffc
    80004fca:	f40080e7          	jalr	-192(ra) # 80000f06 <myproc>
    80004fce:	892a                	mv	s2,a0

  begin_op();
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	6f2080e7          	jalr	1778(ra) # 800036c2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004fd8:	08000613          	li	a2,128
    80004fdc:	f6040593          	addi	a1,s0,-160
    80004fe0:	4501                	li	a0,0
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	16c080e7          	jalr	364(ra) # 8000214e <argstr>
    80004fea:	04054d63          	bltz	a0,80005044 <sys_chdir+0x88>
    80004fee:	e526                	sd	s1,136(sp)
    80004ff0:	f6040513          	addi	a0,s0,-160
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	4ce080e7          	jalr	1230(ra) # 800034c2 <namei>
    80004ffc:	84aa                	mv	s1,a0
    80004ffe:	c131                	beqz	a0,80005042 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	cf4080e7          	jalr	-780(ra) # 80002cf4 <ilock>
  if (ip->type != T_DIR) {
    80005008:	04449703          	lh	a4,68(s1)
    8000500c:	4785                	li	a5,1
    8000500e:	04f71163          	bne	a4,a5,80005050 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005012:	8526                	mv	a0,s1
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	da6080e7          	jalr	-602(ra) # 80002dba <iunlock>
  iput(p->cwd);
    8000501c:	15093503          	ld	a0,336(s2)
    80005020:	ffffe097          	auipc	ra,0xffffe
    80005024:	e92080e7          	jalr	-366(ra) # 80002eb2 <iput>
  end_op();
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	714080e7          	jalr	1812(ra) # 8000373c <end_op>
  p->cwd = ip;
    80005030:	14993823          	sd	s1,336(s2)
  return 0;
    80005034:	4501                	li	a0,0
    80005036:	64aa                	ld	s1,136(sp)
}
    80005038:	60ea                	ld	ra,152(sp)
    8000503a:	644a                	ld	s0,144(sp)
    8000503c:	690a                	ld	s2,128(sp)
    8000503e:	610d                	addi	sp,sp,160
    80005040:	8082                	ret
    80005042:	64aa                	ld	s1,136(sp)
    end_op();
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	6f8080e7          	jalr	1784(ra) # 8000373c <end_op>
    return -1;
    8000504c:	557d                	li	a0,-1
    8000504e:	b7ed                	j	80005038 <sys_chdir+0x7c>
    iunlockput(ip);
    80005050:	8526                	mv	a0,s1
    80005052:	ffffe097          	auipc	ra,0xffffe
    80005056:	f08080e7          	jalr	-248(ra) # 80002f5a <iunlockput>
    end_op();
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	6e2080e7          	jalr	1762(ra) # 8000373c <end_op>
    return -1;
    80005062:	557d                	li	a0,-1
    80005064:	64aa                	ld	s1,136(sp)
    80005066:	bfc9                	j	80005038 <sys_chdir+0x7c>

0000000080005068 <sys_exec>:

uint64 sys_exec(void) {
    80005068:	7121                	addi	sp,sp,-448
    8000506a:	ff06                	sd	ra,440(sp)
    8000506c:	fb22                	sd	s0,432(sp)
    8000506e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005070:	e4840593          	addi	a1,s0,-440
    80005074:	4505                	li	a0,1
    80005076:	ffffd097          	auipc	ra,0xffffd
    8000507a:	0b8080e7          	jalr	184(ra) # 8000212e <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000507e:	08000613          	li	a2,128
    80005082:	f5040593          	addi	a1,s0,-176
    80005086:	4501                	li	a0,0
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	0c6080e7          	jalr	198(ra) # 8000214e <argstr>
    80005090:	87aa                	mv	a5,a0
    return -1;
    80005092:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005094:	0e07c263          	bltz	a5,80005178 <sys_exec+0x110>
    80005098:	f726                	sd	s1,424(sp)
    8000509a:	f34a                	sd	s2,416(sp)
    8000509c:	ef4e                	sd	s3,408(sp)
    8000509e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050a0:	10000613          	li	a2,256
    800050a4:	4581                	li	a1,0
    800050a6:	e5040513          	addi	a0,s0,-432
    800050aa:	ffffb097          	auipc	ra,0xffffb
    800050ae:	0d0080e7          	jalr	208(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800050b2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050b6:	89a6                	mv	s3,s1
    800050b8:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    800050ba:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800050be:	00391513          	slli	a0,s2,0x3
    800050c2:	e4040593          	addi	a1,s0,-448
    800050c6:	e4843783          	ld	a5,-440(s0)
    800050ca:	953e                	add	a0,a0,a5
    800050cc:	ffffd097          	auipc	ra,0xffffd
    800050d0:	fa4080e7          	jalr	-92(ra) # 80002070 <fetchaddr>
    800050d4:	02054a63          	bltz	a0,80005108 <sys_exec+0xa0>
      goto bad;
    }
    if (uarg == 0) {
    800050d8:	e4043783          	ld	a5,-448(s0)
    800050dc:	c7b9                	beqz	a5,8000512a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050de:	ffffb097          	auipc	ra,0xffffb
    800050e2:	03c080e7          	jalr	60(ra) # 8000011a <kalloc>
    800050e6:	85aa                	mv	a1,a0
    800050e8:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    800050ec:	cd11                	beqz	a0,80005108 <sys_exec+0xa0>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    800050ee:	6605                	lui	a2,0x1
    800050f0:	e4043503          	ld	a0,-448(s0)
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	fce080e7          	jalr	-50(ra) # 800020c2 <fetchstr>
    800050fc:	00054663          	bltz	a0,80005108 <sys_exec+0xa0>
    if (i >= NELEM(argv)) {
    80005100:	0905                	addi	s2,s2,1
    80005102:	09a1                	addi	s3,s3,8
    80005104:	fb491de3          	bne	s2,s4,800050be <sys_exec+0x56>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80005108:	f5040913          	addi	s2,s0,-176
    8000510c:	6088                	ld	a0,0(s1)
    8000510e:	c125                	beqz	a0,8000516e <sys_exec+0x106>
    80005110:	ffffb097          	auipc	ra,0xffffb
    80005114:	f0c080e7          	jalr	-244(ra) # 8000001c <kfree>
    80005118:	04a1                	addi	s1,s1,8
    8000511a:	ff2499e3          	bne	s1,s2,8000510c <sys_exec+0xa4>
  return -1;
    8000511e:	557d                	li	a0,-1
    80005120:	74ba                	ld	s1,424(sp)
    80005122:	791a                	ld	s2,416(sp)
    80005124:	69fa                	ld	s3,408(sp)
    80005126:	6a5a                	ld	s4,400(sp)
    80005128:	a881                	j	80005178 <sys_exec+0x110>
      argv[i] = 0;
    8000512a:	0009079b          	sext.w	a5,s2
    8000512e:	078e                	slli	a5,a5,0x3
    80005130:	fd078793          	addi	a5,a5,-48
    80005134:	97a2                	add	a5,a5,s0
    80005136:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000513a:	e5040593          	addi	a1,s0,-432
    8000513e:	f5040513          	addi	a0,s0,-176
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	120080e7          	jalr	288(ra) # 80004262 <exec>
    8000514a:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    8000514c:	f5040993          	addi	s3,s0,-176
    80005150:	6088                	ld	a0,0(s1)
    80005152:	c901                	beqz	a0,80005162 <sys_exec+0xfa>
    80005154:	ffffb097          	auipc	ra,0xffffb
    80005158:	ec8080e7          	jalr	-312(ra) # 8000001c <kfree>
    8000515c:	04a1                	addi	s1,s1,8
    8000515e:	ff3499e3          	bne	s1,s3,80005150 <sys_exec+0xe8>
  return ret;
    80005162:	854a                	mv	a0,s2
    80005164:	74ba                	ld	s1,424(sp)
    80005166:	791a                	ld	s2,416(sp)
    80005168:	69fa                	ld	s3,408(sp)
    8000516a:	6a5a                	ld	s4,400(sp)
    8000516c:	a031                	j	80005178 <sys_exec+0x110>
  return -1;
    8000516e:	557d                	li	a0,-1
    80005170:	74ba                	ld	s1,424(sp)
    80005172:	791a                	ld	s2,416(sp)
    80005174:	69fa                	ld	s3,408(sp)
    80005176:	6a5a                	ld	s4,400(sp)
}
    80005178:	70fa                	ld	ra,440(sp)
    8000517a:	745a                	ld	s0,432(sp)
    8000517c:	6139                	addi	sp,sp,448
    8000517e:	8082                	ret

0000000080005180 <sys_pipe>:

uint64 sys_pipe(void) {
    80005180:	7139                	addi	sp,sp,-64
    80005182:	fc06                	sd	ra,56(sp)
    80005184:	f822                	sd	s0,48(sp)
    80005186:	f426                	sd	s1,40(sp)
    80005188:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	d7c080e7          	jalr	-644(ra) # 80000f06 <myproc>
    80005192:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005194:	fd840593          	addi	a1,s0,-40
    80005198:	4501                	li	a0,0
    8000519a:	ffffd097          	auipc	ra,0xffffd
    8000519e:	f94080e7          	jalr	-108(ra) # 8000212e <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    800051a2:	fc840593          	addi	a1,s0,-56
    800051a6:	fd040513          	addi	a0,s0,-48
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	d50080e7          	jalr	-688(ra) # 80003efa <pipealloc>
    800051b2:	57fd                	li	a5,-1
    800051b4:	0c054463          	bltz	a0,8000527c <sys_pipe+0xfc>
  fd0 = -1;
    800051b8:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800051bc:	fd043503          	ld	a0,-48(s0)
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	4e0080e7          	jalr	1248(ra) # 800046a0 <fdalloc>
    800051c8:	fca42223          	sw	a0,-60(s0)
    800051cc:	08054b63          	bltz	a0,80005262 <sys_pipe+0xe2>
    800051d0:	fc843503          	ld	a0,-56(s0)
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	4cc080e7          	jalr	1228(ra) # 800046a0 <fdalloc>
    800051dc:	fca42023          	sw	a0,-64(s0)
    800051e0:	06054863          	bltz	a0,80005250 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800051e4:	4691                	li	a3,4
    800051e6:	fc440613          	addi	a2,s0,-60
    800051ea:	fd843583          	ld	a1,-40(s0)
    800051ee:	68a8                	ld	a0,80(s1)
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	95c080e7          	jalr	-1700(ra) # 80000b4c <copyout>
    800051f8:	02054063          	bltz	a0,80005218 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800051fc:	4691                	li	a3,4
    800051fe:	fc040613          	addi	a2,s0,-64
    80005202:	fd843583          	ld	a1,-40(s0)
    80005206:	0591                	addi	a1,a1,4
    80005208:	68a8                	ld	a0,80(s1)
    8000520a:	ffffc097          	auipc	ra,0xffffc
    8000520e:	942080e7          	jalr	-1726(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005212:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005214:	06055463          	bgez	a0,8000527c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005218:	fc442783          	lw	a5,-60(s0)
    8000521c:	07e9                	addi	a5,a5,26
    8000521e:	078e                	slli	a5,a5,0x3
    80005220:	97a6                	add	a5,a5,s1
    80005222:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005226:	fc042783          	lw	a5,-64(s0)
    8000522a:	07e9                	addi	a5,a5,26
    8000522c:	078e                	slli	a5,a5,0x3
    8000522e:	94be                	add	s1,s1,a5
    80005230:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005234:	fd043503          	ld	a0,-48(s0)
    80005238:	fffff097          	auipc	ra,0xfffff
    8000523c:	954080e7          	jalr	-1708(ra) # 80003b8c <fileclose>
    fileclose(wf);
    80005240:	fc843503          	ld	a0,-56(s0)
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	948080e7          	jalr	-1720(ra) # 80003b8c <fileclose>
    return -1;
    8000524c:	57fd                	li	a5,-1
    8000524e:	a03d                	j	8000527c <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80005250:	fc442783          	lw	a5,-60(s0)
    80005254:	0007c763          	bltz	a5,80005262 <sys_pipe+0xe2>
    80005258:	07e9                	addi	a5,a5,26
    8000525a:	078e                	slli	a5,a5,0x3
    8000525c:	97a6                	add	a5,a5,s1
    8000525e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005262:	fd043503          	ld	a0,-48(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	926080e7          	jalr	-1754(ra) # 80003b8c <fileclose>
    fileclose(wf);
    8000526e:	fc843503          	ld	a0,-56(s0)
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	91a080e7          	jalr	-1766(ra) # 80003b8c <fileclose>
    return -1;
    8000527a:	57fd                	li	a5,-1
}
    8000527c:	853e                	mv	a0,a5
    8000527e:	70e2                	ld	ra,56(sp)
    80005280:	7442                	ld	s0,48(sp)
    80005282:	74a2                	ld	s1,40(sp)
    80005284:	6121                	addi	sp,sp,64
    80005286:	8082                	ret
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	c6dfc0ef          	jal	80001f3c <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005358:	0c0007b7          	lui	a5,0xc000
    8000535c:	c3d8                	sw	a4,4(a5)
}
    8000535e:	6422                	ld	s0,8(sp)
    80005360:	0141                	addi	sp,sp,16
    80005362:	8082                	ret

0000000080005364 <plicinithart>:

void plicinithart(void) {
    80005364:	1141                	addi	sp,sp,-16
    80005366:	e406                	sd	ra,8(sp)
    80005368:	e022                	sd	s0,0(sp)
    8000536a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	b6e080e7          	jalr	-1170(ra) # 80000eda <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005374:	0085171b          	slliw	a4,a0,0x8
    80005378:	0c0027b7          	lui	a5,0xc002
    8000537c:	97ba                	add	a5,a5,a4
    8000537e:	40200713          	li	a4,1026
    80005382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005386:	00d5151b          	slliw	a0,a0,0xd
    8000538a:	0c2017b7          	lui	a5,0xc201
    8000538e:	97aa                	add	a5,a5,a0
    80005390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    8000539c:	1141                	addi	sp,sp,-16
    8000539e:	e406                	sd	ra,8(sp)
    800053a0:	e022                	sd	s0,0(sp)
    800053a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a4:	ffffc097          	auipc	ra,0xffffc
    800053a8:	b36080e7          	jalr	-1226(ra) # 80000eda <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053ac:	00d5151b          	slliw	a0,a0,0xd
    800053b0:	0c2017b7          	lui	a5,0xc201
    800053b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053b6:	43c8                	lw	a0,4(a5)
    800053b8:	60a2                	ld	ra,8(sp)
    800053ba:	6402                	ld	s0,0(sp)
    800053bc:	0141                	addi	sp,sp,16
    800053be:	8082                	ret

00000000800053c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    800053c0:	1101                	addi	sp,sp,-32
    800053c2:	ec06                	sd	ra,24(sp)
    800053c4:	e822                	sd	s0,16(sp)
    800053c6:	e426                	sd	s1,8(sp)
    800053c8:	1000                	addi	s0,sp,32
    800053ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	b0e080e7          	jalr	-1266(ra) # 80000eda <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d4:	00d5151b          	slliw	a0,a0,0xd
    800053d8:	0c2017b7          	lui	a5,0xc201
    800053dc:	97aa                	add	a5,a5,a0
    800053de:	c3c4                	sw	s1,4(a5)
}
    800053e0:	60e2                	ld	ra,24(sp)
    800053e2:	6442                	ld	s0,16(sp)
    800053e4:	64a2                	ld	s1,8(sp)
    800053e6:	6105                	addi	sp,sp,32
    800053e8:	8082                	ret

00000000800053ea <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    800053ea:	1141                	addi	sp,sp,-16
    800053ec:	e406                	sd	ra,8(sp)
    800053ee:	e022                	sd	s0,0(sp)
    800053f0:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    800053f2:	479d                	li	a5,7
    800053f4:	04a7cc63          	blt	a5,a0,8000544c <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    800053f8:	00017797          	auipc	a5,0x17
    800053fc:	f9878793          	addi	a5,a5,-104 # 8001c390 <disk>
    80005400:	97aa                	add	a5,a5,a0
    80005402:	0187c783          	lbu	a5,24(a5)
    80005406:	ebb9                	bnez	a5,8000545c <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005408:	00451693          	slli	a3,a0,0x4
    8000540c:	00017797          	auipc	a5,0x17
    80005410:	f8478793          	addi	a5,a5,-124 # 8001c390 <disk>
    80005414:	6398                	ld	a4,0(a5)
    80005416:	9736                	add	a4,a4,a3
    80005418:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000541c:	6398                	ld	a4,0(a5)
    8000541e:	9736                	add	a4,a4,a3
    80005420:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005424:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005428:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000542c:	97aa                	add	a5,a5,a0
    8000542e:	4705                	li	a4,1
    80005430:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005434:	00017517          	auipc	a0,0x17
    80005438:	f7450513          	addi	a0,a0,-140 # 8001c3a8 <disk+0x18>
    8000543c:	ffffc097          	auipc	ra,0xffffc
    80005440:	1dc080e7          	jalr	476(ra) # 80001618 <wakeup>
}
    80005444:	60a2                	ld	ra,8(sp)
    80005446:	6402                	ld	s0,0(sp)
    80005448:	0141                	addi	sp,sp,16
    8000544a:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    8000544c:	00003517          	auipc	a0,0x3
    80005450:	1bc50513          	addi	a0,a0,444 # 80008608 <etext+0x608>
    80005454:	00001097          	auipc	ra,0x1
    80005458:	a6e080e7          	jalr	-1426(ra) # 80005ec2 <panic>
  if (disk.free[i]) panic("free_desc 2");
    8000545c:	00003517          	auipc	a0,0x3
    80005460:	1bc50513          	addi	a0,a0,444 # 80008618 <etext+0x618>
    80005464:	00001097          	auipc	ra,0x1
    80005468:	a5e080e7          	jalr	-1442(ra) # 80005ec2 <panic>

000000008000546c <virtio_disk_init>:
void virtio_disk_init(void) {
    8000546c:	1101                	addi	sp,sp,-32
    8000546e:	ec06                	sd	ra,24(sp)
    80005470:	e822                	sd	s0,16(sp)
    80005472:	e426                	sd	s1,8(sp)
    80005474:	e04a                	sd	s2,0(sp)
    80005476:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005478:	00003597          	auipc	a1,0x3
    8000547c:	1b058593          	addi	a1,a1,432 # 80008628 <etext+0x628>
    80005480:	00017517          	auipc	a0,0x17
    80005484:	03850513          	addi	a0,a0,56 # 8001c4b8 <disk+0x128>
    80005488:	00001097          	auipc	ra,0x1
    8000548c:	f24080e7          	jalr	-220(ra) # 800063ac <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	4398                	lw	a4,0(a5)
    80005496:	2701                	sext.w	a4,a4
    80005498:	747277b7          	lui	a5,0x74727
    8000549c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054a0:	18f71c63          	bne	a4,a5,80005638 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054aa:	439c                	lw	a5,0(a5)
    800054ac:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054ae:	4709                	li	a4,2
    800054b0:	18e79463          	bne	a5,a4,80005638 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054b4:	100017b7          	lui	a5,0x10001
    800054b8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054ba:	439c                	lw	a5,0(a5)
    800054bc:	2781                	sext.w	a5,a5
    800054be:	16e79d63          	bne	a5,a4,80005638 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800054c2:	100017b7          	lui	a5,0x10001
    800054c6:	47d8                	lw	a4,12(a5)
    800054c8:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ca:	554d47b7          	lui	a5,0x554d4
    800054ce:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054d2:	16f71363          	bne	a4,a5,80005638 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054d6:	100017b7          	lui	a5,0x10001
    800054da:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054de:	4705                	li	a4,1
    800054e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e2:	470d                	li	a4,3
    800054e4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054e6:	10001737          	lui	a4,0x10001
    800054ea:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054ec:	c7ffe737          	lui	a4,0xc7ffe
    800054f0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda04f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054f4:	8ef9                	and	a3,a3,a4
    800054f6:	10001737          	lui	a4,0x10001
    800054fa:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fc:	472d                	li	a4,11
    800054fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005500:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005504:	439c                	lw	a5,0(a5)
    80005506:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000550a:	8ba1                	andi	a5,a5,8
    8000550c:	12078e63          	beqz	a5,80005648 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005510:	100017b7          	lui	a5,0x10001
    80005514:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005520:	439c                	lw	a5,0(a5)
    80005522:	2781                	sext.w	a5,a5
    80005524:	12079a63          	bnez	a5,80005658 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005530:	439c                	lw	a5,0(a5)
    80005532:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005534:	12078a63          	beqz	a5,80005668 <virtio_disk_init+0x1fc>
  if (max < NUM) panic("virtio disk max queue too short");
    80005538:	471d                	li	a4,7
    8000553a:	12f77f63          	bgeu	a4,a5,80005678 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000553e:	ffffb097          	auipc	ra,0xffffb
    80005542:	bdc080e7          	jalr	-1060(ra) # 8000011a <kalloc>
    80005546:	00017497          	auipc	s1,0x17
    8000554a:	e4a48493          	addi	s1,s1,-438 # 8001c390 <disk>
    8000554e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005550:	ffffb097          	auipc	ra,0xffffb
    80005554:	bca080e7          	jalr	-1078(ra) # 8000011a <kalloc>
    80005558:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000555a:	ffffb097          	auipc	ra,0xffffb
    8000555e:	bc0080e7          	jalr	-1088(ra) # 8000011a <kalloc>
    80005562:	87aa                	mv	a5,a0
    80005564:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005566:	6088                	ld	a0,0(s1)
    80005568:	12050063          	beqz	a0,80005688 <virtio_disk_init+0x21c>
    8000556c:	00017717          	auipc	a4,0x17
    80005570:	e2c73703          	ld	a4,-468(a4) # 8001c398 <disk+0x8>
    80005574:	10070a63          	beqz	a4,80005688 <virtio_disk_init+0x21c>
    80005578:	10078863          	beqz	a5,80005688 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000557c:	6605                	lui	a2,0x1
    8000557e:	4581                	li	a1,0
    80005580:	ffffb097          	auipc	ra,0xffffb
    80005584:	bfa080e7          	jalr	-1030(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005588:	00017497          	auipc	s1,0x17
    8000558c:	e0848493          	addi	s1,s1,-504 # 8001c390 <disk>
    80005590:	6605                	lui	a2,0x1
    80005592:	4581                	li	a1,0
    80005594:	6488                	ld	a0,8(s1)
    80005596:	ffffb097          	auipc	ra,0xffffb
    8000559a:	be4080e7          	jalr	-1052(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    8000559e:	6605                	lui	a2,0x1
    800055a0:	4581                	li	a1,0
    800055a2:	6888                	ld	a0,16(s1)
    800055a4:	ffffb097          	auipc	ra,0xffffb
    800055a8:	bd6080e7          	jalr	-1066(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ac:	100017b7          	lui	a5,0x10001
    800055b0:	4721                	li	a4,8
    800055b2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055b4:	4098                	lw	a4,0(s1)
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055be:	40d8                	lw	a4,4(s1)
    800055c0:	100017b7          	lui	a5,0x10001
    800055c4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055c8:	649c                	ld	a5,8(s1)
    800055ca:	0007869b          	sext.w	a3,a5
    800055ce:	10001737          	lui	a4,0x10001
    800055d2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055d6:	9781                	srai	a5,a5,0x20
    800055d8:	10001737          	lui	a4,0x10001
    800055dc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055e0:	689c                	ld	a5,16(s1)
    800055e2:	0007869b          	sext.w	a3,a5
    800055e6:	10001737          	lui	a4,0x10001
    800055ea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055ee:	9781                	srai	a5,a5,0x20
    800055f0:	10001737          	lui	a4,0x10001
    800055f4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055f8:	10001737          	lui	a4,0x10001
    800055fc:	4785                	li	a5,1
    800055fe:	c37c                	sw	a5,68(a4)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    80005600:	00f48c23          	sb	a5,24(s1)
    80005604:	00f48ca3          	sb	a5,25(s1)
    80005608:	00f48d23          	sb	a5,26(s1)
    8000560c:	00f48da3          	sb	a5,27(s1)
    80005610:	00f48e23          	sb	a5,28(s1)
    80005614:	00f48ea3          	sb	a5,29(s1)
    80005618:	00f48f23          	sb	a5,30(s1)
    8000561c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005620:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005624:	100017b7          	lui	a5,0x10001
    80005628:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000562c:	60e2                	ld	ra,24(sp)
    8000562e:	6442                	ld	s0,16(sp)
    80005630:	64a2                	ld	s1,8(sp)
    80005632:	6902                	ld	s2,0(sp)
    80005634:	6105                	addi	sp,sp,32
    80005636:	8082                	ret
    panic("could not find virtio disk");
    80005638:	00003517          	auipc	a0,0x3
    8000563c:	00050513          	mv	a0,a0
    80005640:	00001097          	auipc	ra,0x1
    80005644:	882080e7          	jalr	-1918(ra) # 80005ec2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005648:	00003517          	auipc	a0,0x3
    8000564c:	01050513          	addi	a0,a0,16 # 80008658 <etext+0x658>
    80005650:	00001097          	auipc	ra,0x1
    80005654:	872080e7          	jalr	-1934(ra) # 80005ec2 <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	02050513          	addi	a0,a0,32 # 80008678 <etext+0x678>
    80005660:	00001097          	auipc	ra,0x1
    80005664:	862080e7          	jalr	-1950(ra) # 80005ec2 <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    80005668:	00003517          	auipc	a0,0x3
    8000566c:	03050513          	addi	a0,a0,48 # 80008698 <etext+0x698>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	852080e7          	jalr	-1966(ra) # 80005ec2 <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    80005678:	00003517          	auipc	a0,0x3
    8000567c:	04050513          	addi	a0,a0,64 # 800086b8 <etext+0x6b8>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	842080e7          	jalr	-1982(ra) # 80005ec2 <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005688:	00003517          	auipc	a0,0x3
    8000568c:	05050513          	addi	a0,a0,80 # 800086d8 <etext+0x6d8>
    80005690:	00001097          	auipc	ra,0x1
    80005694:	832080e7          	jalr	-1998(ra) # 80005ec2 <panic>

0000000080005698 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    80005698:	7159                	addi	sp,sp,-112
    8000569a:	f486                	sd	ra,104(sp)
    8000569c:	f0a2                	sd	s0,96(sp)
    8000569e:	eca6                	sd	s1,88(sp)
    800056a0:	e8ca                	sd	s2,80(sp)
    800056a2:	e4ce                	sd	s3,72(sp)
    800056a4:	e0d2                	sd	s4,64(sp)
    800056a6:	fc56                	sd	s5,56(sp)
    800056a8:	f85a                	sd	s6,48(sp)
    800056aa:	f45e                	sd	s7,40(sp)
    800056ac:	f062                	sd	s8,32(sp)
    800056ae:	ec66                	sd	s9,24(sp)
    800056b0:	1880                	addi	s0,sp,112
    800056b2:	8a2a                	mv	s4,a0
    800056b4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056b6:	00c52c83          	lw	s9,12(a0)
    800056ba:	001c9c9b          	slliw	s9,s9,0x1
    800056be:	1c82                	slli	s9,s9,0x20
    800056c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056c4:	00017517          	auipc	a0,0x17
    800056c8:	df450513          	addi	a0,a0,-524 # 8001c4b8 <disk+0x128>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	d70080e7          	jalr	-656(ra) # 8000643c <acquire>
  for (int i = 0; i < 3; i++) {
    800056d4:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    800056d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056d8:	00017b17          	auipc	s6,0x17
    800056dc:	cb8b0b13          	addi	s6,s6,-840 # 8001c390 <disk>
  for (int i = 0; i < 3; i++) {
    800056e0:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056e2:	00017c17          	auipc	s8,0x17
    800056e6:	dd6c0c13          	addi	s8,s8,-554 # 8001c4b8 <disk+0x128>
    800056ea:	a0ad                	j	80005754 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800056ec:	00fb0733          	add	a4,s6,a5
    800056f0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800056f4:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800056f6:	0207c563          	bltz	a5,80005720 <virtio_disk_rw+0x88>
  for (int i = 0; i < 3; i++) {
    800056fa:	2905                	addiw	s2,s2,1
    800056fc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056fe:	05590f63          	beq	s2,s5,8000575c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005702:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005704:	00017717          	auipc	a4,0x17
    80005708:	c8c70713          	addi	a4,a4,-884 # 8001c390 <disk>
    8000570c:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000570e:	01874683          	lbu	a3,24(a4)
    80005712:	fee9                	bnez	a3,800056ec <virtio_disk_rw+0x54>
  for (int i = 0; i < NUM; i++) {
    80005714:	2785                	addiw	a5,a5,1
    80005716:	0705                	addi	a4,a4,1
    80005718:	fe979be3          	bne	a5,s1,8000570e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000571c:	57fd                	li	a5,-1
    8000571e:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    80005720:	03205163          	blez	s2,80005742 <virtio_disk_rw+0xaa>
    80005724:	f9042503          	lw	a0,-112(s0)
    80005728:	00000097          	auipc	ra,0x0
    8000572c:	cc2080e7          	jalr	-830(ra) # 800053ea <free_desc>
    80005730:	4785                	li	a5,1
    80005732:	0127d863          	bge	a5,s2,80005742 <virtio_disk_rw+0xaa>
    80005736:	f9442503          	lw	a0,-108(s0)
    8000573a:	00000097          	auipc	ra,0x0
    8000573e:	cb0080e7          	jalr	-848(ra) # 800053ea <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005742:	85e2                	mv	a1,s8
    80005744:	00017517          	auipc	a0,0x17
    80005748:	c6450513          	addi	a0,a0,-924 # 8001c3a8 <disk+0x18>
    8000574c:	ffffc097          	auipc	ra,0xffffc
    80005750:	e68080e7          	jalr	-408(ra) # 800015b4 <sleep>
  for (int i = 0; i < 3; i++) {
    80005754:	f9040613          	addi	a2,s0,-112
    80005758:	894e                	mv	s2,s3
    8000575a:	b765                	j	80005702 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000575c:	f9042503          	lw	a0,-112(s0)
    80005760:	00451693          	slli	a3,a0,0x4

  if (write)
    80005764:	00017797          	auipc	a5,0x17
    80005768:	c2c78793          	addi	a5,a5,-980 # 8001c390 <disk>
    8000576c:	00a50713          	addi	a4,a0,10
    80005770:	0712                	slli	a4,a4,0x4
    80005772:	973e                	add	a4,a4,a5
    80005774:	01703633          	snez	a2,s7
    80005778:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    8000577a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000577e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005782:	6398                	ld	a4,0(a5)
    80005784:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005786:	0a868613          	addi	a2,a3,168
    8000578a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    8000578c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000578e:	6390                	ld	a2,0(a5)
    80005790:	00d605b3          	add	a1,a2,a3
    80005794:	4741                	li	a4,16
    80005796:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005798:	4805                	li	a6,1
    8000579a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000579e:	f9442703          	lw	a4,-108(s0)
    800057a2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800057a6:	0712                	slli	a4,a4,0x4
    800057a8:	963a                	add	a2,a2,a4
    800057aa:	058a0593          	addi	a1,s4,88
    800057ae:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057b0:	0007b883          	ld	a7,0(a5)
    800057b4:	9746                	add	a4,a4,a7
    800057b6:	40000613          	li	a2,1024
    800057ba:	c710                	sw	a2,8(a4)
  if (write)
    800057bc:	001bb613          	seqz	a2,s7
    800057c0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057c4:	00166613          	ori	a2,a2,1
    800057c8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800057cc:	f9842583          	lw	a1,-104(s0)
    800057d0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    800057d4:	00250613          	addi	a2,a0,2
    800057d8:	0612                	slli	a2,a2,0x4
    800057da:	963e                	add	a2,a2,a5
    800057dc:	577d                	li	a4,-1
    800057de:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800057e2:	0592                	slli	a1,a1,0x4
    800057e4:	98ae                	add	a7,a7,a1
    800057e6:	03068713          	addi	a4,a3,48
    800057ea:	973e                	add	a4,a4,a5
    800057ec:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800057f0:	6398                	ld	a4,0(a5)
    800057f2:	972e                	add	a4,a4,a1
    800057f4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    800057f8:	4689                	li	a3,2
    800057fa:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800057fe:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005802:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005806:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000580a:	6794                	ld	a3,8(a5)
    8000580c:	0026d703          	lhu	a4,2(a3)
    80005810:	8b1d                	andi	a4,a4,7
    80005812:	0706                	slli	a4,a4,0x1
    80005814:	96ba                	add	a3,a3,a4
    80005816:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000581a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    8000581e:	6798                	ld	a4,8(a5)
    80005820:	00275783          	lhu	a5,2(a4)
    80005824:	2785                	addiw	a5,a5,1
    80005826:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000582a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    8000582e:	100017b7          	lui	a5,0x10001
    80005832:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005836:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000583a:	00017917          	auipc	s2,0x17
    8000583e:	c7e90913          	addi	s2,s2,-898 # 8001c4b8 <disk+0x128>
  while (b->disk == 1) {
    80005842:	4485                	li	s1,1
    80005844:	01079c63          	bne	a5,a6,8000585c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005848:	85ca                	mv	a1,s2
    8000584a:	8552                	mv	a0,s4
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	d68080e7          	jalr	-664(ra) # 800015b4 <sleep>
  while (b->disk == 1) {
    80005854:	004a2783          	lw	a5,4(s4)
    80005858:	fe9788e3          	beq	a5,s1,80005848 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000585c:	f9042903          	lw	s2,-112(s0)
    80005860:	00290713          	addi	a4,s2,2
    80005864:	0712                	slli	a4,a4,0x4
    80005866:	00017797          	auipc	a5,0x17
    8000586a:	b2a78793          	addi	a5,a5,-1238 # 8001c390 <disk>
    8000586e:	97ba                	add	a5,a5,a4
    80005870:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005874:	00017997          	auipc	s3,0x17
    80005878:	b1c98993          	addi	s3,s3,-1252 # 8001c390 <disk>
    8000587c:	00491713          	slli	a4,s2,0x4
    80005880:	0009b783          	ld	a5,0(s3)
    80005884:	97ba                	add	a5,a5,a4
    80005886:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000588a:	854a                	mv	a0,s2
    8000588c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005890:	00000097          	auipc	ra,0x0
    80005894:	b5a080e7          	jalr	-1190(ra) # 800053ea <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005898:	8885                	andi	s1,s1,1
    8000589a:	f0ed                	bnez	s1,8000587c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000589c:	00017517          	auipc	a0,0x17
    800058a0:	c1c50513          	addi	a0,a0,-996 # 8001c4b8 <disk+0x128>
    800058a4:	00001097          	auipc	ra,0x1
    800058a8:	c4c080e7          	jalr	-948(ra) # 800064f0 <release>
}
    800058ac:	70a6                	ld	ra,104(sp)
    800058ae:	7406                	ld	s0,96(sp)
    800058b0:	64e6                	ld	s1,88(sp)
    800058b2:	6946                	ld	s2,80(sp)
    800058b4:	69a6                	ld	s3,72(sp)
    800058b6:	6a06                	ld	s4,64(sp)
    800058b8:	7ae2                	ld	s5,56(sp)
    800058ba:	7b42                	ld	s6,48(sp)
    800058bc:	7ba2                	ld	s7,40(sp)
    800058be:	7c02                	ld	s8,32(sp)
    800058c0:	6ce2                	ld	s9,24(sp)
    800058c2:	6165                	addi	sp,sp,112
    800058c4:	8082                	ret

00000000800058c6 <virtio_disk_intr>:

void virtio_disk_intr() {
    800058c6:	1101                	addi	sp,sp,-32
    800058c8:	ec06                	sd	ra,24(sp)
    800058ca:	e822                	sd	s0,16(sp)
    800058cc:	e426                	sd	s1,8(sp)
    800058ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058d0:	00017497          	auipc	s1,0x17
    800058d4:	ac048493          	addi	s1,s1,-1344 # 8001c390 <disk>
    800058d8:	00017517          	auipc	a0,0x17
    800058dc:	be050513          	addi	a0,a0,-1056 # 8001c4b8 <disk+0x128>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	b5c080e7          	jalr	-1188(ra) # 8000643c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058e8:	100017b7          	lui	a5,0x10001
    800058ec:	53b8                	lw	a4,96(a5)
    800058ee:	8b0d                	andi	a4,a4,3
    800058f0:	100017b7          	lui	a5,0x10001
    800058f4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058f6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    800058fa:	689c                	ld	a5,16(s1)
    800058fc:	0204d703          	lhu	a4,32(s1)
    80005900:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005904:	04f70863          	beq	a4,a5,80005954 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005908:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000590c:	6898                	ld	a4,16(s1)
    8000590e:	0204d783          	lhu	a5,32(s1)
    80005912:	8b9d                	andi	a5,a5,7
    80005914:	078e                	slli	a5,a5,0x3
    80005916:	97ba                	add	a5,a5,a4
    80005918:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    8000591a:	00278713          	addi	a4,a5,2
    8000591e:	0712                	slli	a4,a4,0x4
    80005920:	9726                	add	a4,a4,s1
    80005922:	01074703          	lbu	a4,16(a4)
    80005926:	e721                	bnez	a4,8000596e <virtio_disk_intr+0xa8>

    struct buf *b = disk.info[id].b;
    80005928:	0789                	addi	a5,a5,2
    8000592a:	0792                	slli	a5,a5,0x4
    8000592c:	97a6                	add	a5,a5,s1
    8000592e:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    80005930:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	ce4080e7          	jalr	-796(ra) # 80001618 <wakeup>

    disk.used_idx += 1;
    8000593c:	0204d783          	lhu	a5,32(s1)
    80005940:	2785                	addiw	a5,a5,1
    80005942:	17c2                	slli	a5,a5,0x30
    80005944:	93c1                	srli	a5,a5,0x30
    80005946:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    8000594a:	6898                	ld	a4,16(s1)
    8000594c:	00275703          	lhu	a4,2(a4)
    80005950:	faf71ce3          	bne	a4,a5,80005908 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005954:	00017517          	auipc	a0,0x17
    80005958:	b6450513          	addi	a0,a0,-1180 # 8001c4b8 <disk+0x128>
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	b94080e7          	jalr	-1132(ra) # 800064f0 <release>
}
    80005964:	60e2                	ld	ra,24(sp)
    80005966:	6442                	ld	s0,16(sp)
    80005968:	64a2                	ld	s1,8(sp)
    8000596a:	6105                	addi	sp,sp,32
    8000596c:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    8000596e:	00003517          	auipc	a0,0x3
    80005972:	d8250513          	addi	a0,a0,-638 # 800086f0 <etext+0x6f0>
    80005976:	00000097          	auipc	ra,0x0
    8000597a:	54c080e7          	jalr	1356(ra) # 80005ec2 <panic>

000000008000597e <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    8000597e:	1141                	addi	sp,sp,-16
    80005980:	e422                	sd	s0,8(sp)
    80005982:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005984:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005988:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    8000598c:	0037979b          	slliw	a5,a5,0x3
    80005990:	02004737          	lui	a4,0x2004
    80005994:	97ba                	add	a5,a5,a4
    80005996:	0200c737          	lui	a4,0x200c
    8000599a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000599c:	6318                	ld	a4,0(a4)
    8000599e:	000f4637          	lui	a2,0xf4
    800059a2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059a6:	9732                	add	a4,a4,a2
    800059a8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059aa:	00259693          	slli	a3,a1,0x2
    800059ae:	96ae                	add	a3,a3,a1
    800059b0:	068e                	slli	a3,a3,0x3
    800059b2:	00017717          	auipc	a4,0x17
    800059b6:	b1e70713          	addi	a4,a4,-1250 # 8001c4d0 <timer_scratch>
    800059ba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059bc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059be:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800059c0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    800059c4:	00000797          	auipc	a5,0x0
    800059c8:	95c78793          	addi	a5,a5,-1700 # 80005320 <timervec>
    800059cc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800059d0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059d4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800059d8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    800059dc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059e0:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    800059e4:	30479073          	csrw	mie,a5
}
    800059e8:	6422                	ld	s0,8(sp)
    800059ea:	0141                	addi	sp,sp,16
    800059ec:	8082                	ret

00000000800059ee <start>:
void start() {
    800059ee:	1141                	addi	sp,sp,-16
    800059f0:	e406                	sd	ra,8(sp)
    800059f2:	e022                	sd	s0,0(sp)
    800059f4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800059f6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059fa:	7779                	lui	a4,0xffffe
    800059fc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda0ef>
    80005a00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a02:	6705                	lui	a4,0x1
    80005a04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005a0e:	ffffb797          	auipc	a5,0xffffb
    80005a12:	90a78793          	addi	a5,a5,-1782 # 80000318 <main>
    80005a16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005a1a:	4781                	li	a5,0
    80005a1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80005a20:	67c1                	lui	a5,0x10
    80005a22:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005a28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005a2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a30:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80005a34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005a38:	57fd                	li	a5,-1
    80005a3a:	83a9                	srli	a5,a5,0xa
    80005a3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005a40:	47bd                	li	a5,15
    80005a42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	f38080e7          	jalr	-200(ra) # 8000597e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a4e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a52:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80005a54:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a56:	30200073          	mret
}
    80005a5a:	60a2                	ld	ra,8(sp)
    80005a5c:	6402                	ld	s0,0(sp)
    80005a5e:	0141                	addi	sp,sp,16
    80005a60:	8082                	ret

0000000080005a62 <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80005a62:	715d                	addi	sp,sp,-80
    80005a64:	e486                	sd	ra,72(sp)
    80005a66:	e0a2                	sd	s0,64(sp)
    80005a68:	f84a                	sd	s2,48(sp)
    80005a6a:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80005a6c:	04c05663          	blez	a2,80005ab8 <consolewrite+0x56>
    80005a70:	fc26                	sd	s1,56(sp)
    80005a72:	f44e                	sd	s3,40(sp)
    80005a74:	f052                	sd	s4,32(sp)
    80005a76:	ec56                	sd	s5,24(sp)
    80005a78:	8a2a                	mv	s4,a0
    80005a7a:	84ae                	mv	s1,a1
    80005a7c:	89b2                	mv	s3,a2
    80005a7e:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80005a80:	5afd                	li	s5,-1
    80005a82:	4685                	li	a3,1
    80005a84:	8626                	mv	a2,s1
    80005a86:	85d2                	mv	a1,s4
    80005a88:	fbf40513          	addi	a0,s0,-65
    80005a8c:	ffffc097          	auipc	ra,0xffffc
    80005a90:	f86080e7          	jalr	-122(ra) # 80001a12 <either_copyin>
    80005a94:	03550463          	beq	a0,s5,80005abc <consolewrite+0x5a>
    uartputc(c);
    80005a98:	fbf44503          	lbu	a0,-65(s0)
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	7e4080e7          	jalr	2020(ra) # 80006280 <uartputc>
  for (i = 0; i < n; i++) {
    80005aa4:	2905                	addiw	s2,s2,1
    80005aa6:	0485                	addi	s1,s1,1
    80005aa8:	fd299de3          	bne	s3,s2,80005a82 <consolewrite+0x20>
    80005aac:	894e                	mv	s2,s3
    80005aae:	74e2                	ld	s1,56(sp)
    80005ab0:	79a2                	ld	s3,40(sp)
    80005ab2:	7a02                	ld	s4,32(sp)
    80005ab4:	6ae2                	ld	s5,24(sp)
    80005ab6:	a039                	j	80005ac4 <consolewrite+0x62>
    80005ab8:	4901                	li	s2,0
    80005aba:	a029                	j	80005ac4 <consolewrite+0x62>
    80005abc:	74e2                	ld	s1,56(sp)
    80005abe:	79a2                	ld	s3,40(sp)
    80005ac0:	7a02                	ld	s4,32(sp)
    80005ac2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005ac4:	854a                	mv	a0,s2
    80005ac6:	60a6                	ld	ra,72(sp)
    80005ac8:	6406                	ld	s0,64(sp)
    80005aca:	7942                	ld	s2,48(sp)
    80005acc:	6161                	addi	sp,sp,80
    80005ace:	8082                	ret

0000000080005ad0 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005ad0:	711d                	addi	sp,sp,-96
    80005ad2:	ec86                	sd	ra,88(sp)
    80005ad4:	e8a2                	sd	s0,80(sp)
    80005ad6:	e4a6                	sd	s1,72(sp)
    80005ad8:	e0ca                	sd	s2,64(sp)
    80005ada:	fc4e                	sd	s3,56(sp)
    80005adc:	f852                	sd	s4,48(sp)
    80005ade:	f456                	sd	s5,40(sp)
    80005ae0:	f05a                	sd	s6,32(sp)
    80005ae2:	1080                	addi	s0,sp,96
    80005ae4:	8aaa                	mv	s5,a0
    80005ae6:	8a2e                	mv	s4,a1
    80005ae8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005aee:	0001f517          	auipc	a0,0x1f
    80005af2:	b2250513          	addi	a0,a0,-1246 # 80024610 <cons>
    80005af6:	00001097          	auipc	ra,0x1
    80005afa:	946080e7          	jalr	-1722(ra) # 8000643c <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005afe:	0001f497          	auipc	s1,0x1f
    80005b02:	b1248493          	addi	s1,s1,-1262 # 80024610 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b06:	0001f917          	auipc	s2,0x1f
    80005b0a:	ba290913          	addi	s2,s2,-1118 # 800246a8 <cons+0x98>
  while (n > 0) {
    80005b0e:	0d305763          	blez	s3,80005bdc <consoleread+0x10c>
    while (cons.r == cons.w) {
    80005b12:	0984a783          	lw	a5,152(s1)
    80005b16:	09c4a703          	lw	a4,156(s1)
    80005b1a:	0af71c63          	bne	a4,a5,80005bd2 <consoleread+0x102>
      if (killed(myproc())) {
    80005b1e:	ffffb097          	auipc	ra,0xffffb
    80005b22:	3e8080e7          	jalr	1000(ra) # 80000f06 <myproc>
    80005b26:	ffffc097          	auipc	ra,0xffffc
    80005b2a:	d36080e7          	jalr	-714(ra) # 8000185c <killed>
    80005b2e:	e52d                	bnez	a0,80005b98 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005b30:	85a6                	mv	a1,s1
    80005b32:	854a                	mv	a0,s2
    80005b34:	ffffc097          	auipc	ra,0xffffc
    80005b38:	a80080e7          	jalr	-1408(ra) # 800015b4 <sleep>
    while (cons.r == cons.w) {
    80005b3c:	0984a783          	lw	a5,152(s1)
    80005b40:	09c4a703          	lw	a4,156(s1)
    80005b44:	fcf70de3          	beq	a4,a5,80005b1e <consoleread+0x4e>
    80005b48:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b4a:	0001f717          	auipc	a4,0x1f
    80005b4e:	ac670713          	addi	a4,a4,-1338 # 80024610 <cons>
    80005b52:	0017869b          	addiw	a3,a5,1
    80005b56:	08d72c23          	sw	a3,152(a4)
    80005b5a:	07f7f693          	andi	a3,a5,127
    80005b5e:	9736                	add	a4,a4,a3
    80005b60:	01874703          	lbu	a4,24(a4)
    80005b64:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) {  // end-of-file
    80005b68:	4691                	li	a3,4
    80005b6a:	04db8a63          	beq	s7,a3,80005bbe <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b6e:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005b72:	4685                	li	a3,1
    80005b74:	faf40613          	addi	a2,s0,-81
    80005b78:	85d2                	mv	a1,s4
    80005b7a:	8556                	mv	a0,s5
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	e40080e7          	jalr	-448(ra) # 800019bc <either_copyout>
    80005b84:	57fd                	li	a5,-1
    80005b86:	04f50a63          	beq	a0,a5,80005bda <consoleread+0x10a>

    dst++;
    80005b8a:	0a05                	addi	s4,s4,1
    --n;
    80005b8c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80005b8e:	47a9                	li	a5,10
    80005b90:	06fb8163          	beq	s7,a5,80005bf2 <consoleread+0x122>
    80005b94:	6be2                	ld	s7,24(sp)
    80005b96:	bfa5                	j	80005b0e <consoleread+0x3e>
        release(&cons.lock);
    80005b98:	0001f517          	auipc	a0,0x1f
    80005b9c:	a7850513          	addi	a0,a0,-1416 # 80024610 <cons>
    80005ba0:	00001097          	auipc	ra,0x1
    80005ba4:	950080e7          	jalr	-1712(ra) # 800064f0 <release>
        return -1;
    80005ba8:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005baa:	60e6                	ld	ra,88(sp)
    80005bac:	6446                	ld	s0,80(sp)
    80005bae:	64a6                	ld	s1,72(sp)
    80005bb0:	6906                	ld	s2,64(sp)
    80005bb2:	79e2                	ld	s3,56(sp)
    80005bb4:	7a42                	ld	s4,48(sp)
    80005bb6:	7aa2                	ld	s5,40(sp)
    80005bb8:	7b02                	ld	s6,32(sp)
    80005bba:	6125                	addi	sp,sp,96
    80005bbc:	8082                	ret
      if (n < target) {
    80005bbe:	0009871b          	sext.w	a4,s3
    80005bc2:	01677a63          	bgeu	a4,s6,80005bd6 <consoleread+0x106>
        cons.r--;
    80005bc6:	0001f717          	auipc	a4,0x1f
    80005bca:	aef72123          	sw	a5,-1310(a4) # 800246a8 <cons+0x98>
    80005bce:	6be2                	ld	s7,24(sp)
    80005bd0:	a031                	j	80005bdc <consoleread+0x10c>
    80005bd2:	ec5e                	sd	s7,24(sp)
    80005bd4:	bf9d                	j	80005b4a <consoleread+0x7a>
    80005bd6:	6be2                	ld	s7,24(sp)
    80005bd8:	a011                	j	80005bdc <consoleread+0x10c>
    80005bda:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005bdc:	0001f517          	auipc	a0,0x1f
    80005be0:	a3450513          	addi	a0,a0,-1484 # 80024610 <cons>
    80005be4:	00001097          	auipc	ra,0x1
    80005be8:	90c080e7          	jalr	-1780(ra) # 800064f0 <release>
  return target - n;
    80005bec:	413b053b          	subw	a0,s6,s3
    80005bf0:	bf6d                	j	80005baa <consoleread+0xda>
    80005bf2:	6be2                	ld	s7,24(sp)
    80005bf4:	b7e5                	j	80005bdc <consoleread+0x10c>

0000000080005bf6 <consputc>:
void consputc(int c) {
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e406                	sd	ra,8(sp)
    80005bfa:	e022                	sd	s0,0(sp)
    80005bfc:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005bfe:	10000793          	li	a5,256
    80005c02:	00f50a63          	beq	a0,a5,80005c16 <consputc+0x20>
    uartputc_sync(c);
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	59c080e7          	jalr	1436(ra) # 800061a2 <uartputc_sync>
}
    80005c0e:	60a2                	ld	ra,8(sp)
    80005c10:	6402                	ld	s0,0(sp)
    80005c12:	0141                	addi	sp,sp,16
    80005c14:	8082                	ret
    uartputc_sync('\b');
    80005c16:	4521                	li	a0,8
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	58a080e7          	jalr	1418(ra) # 800061a2 <uartputc_sync>
    uartputc_sync(' ');
    80005c20:	02000513          	li	a0,32
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	57e080e7          	jalr	1406(ra) # 800061a2 <uartputc_sync>
    uartputc_sync('\b');
    80005c2c:	4521                	li	a0,8
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	574080e7          	jalr	1396(ra) # 800061a2 <uartputc_sync>
    80005c36:	bfe1                	j	80005c0e <consputc+0x18>

0000000080005c38 <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005c38:	1101                	addi	sp,sp,-32
    80005c3a:	ec06                	sd	ra,24(sp)
    80005c3c:	e822                	sd	s0,16(sp)
    80005c3e:	e426                	sd	s1,8(sp)
    80005c40:	1000                	addi	s0,sp,32
    80005c42:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c44:	0001f517          	auipc	a0,0x1f
    80005c48:	9cc50513          	addi	a0,a0,-1588 # 80024610 <cons>
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	7f0080e7          	jalr	2032(ra) # 8000643c <acquire>

  switch (c) {
    80005c54:	47d5                	li	a5,21
    80005c56:	0af48563          	beq	s1,a5,80005d00 <consoleintr+0xc8>
    80005c5a:	0297c963          	blt	a5,s1,80005c8c <consoleintr+0x54>
    80005c5e:	47a1                	li	a5,8
    80005c60:	0ef48c63          	beq	s1,a5,80005d58 <consoleintr+0x120>
    80005c64:	47c1                	li	a5,16
    80005c66:	10f49f63          	bne	s1,a5,80005d84 <consoleintr+0x14c>
    case C('P'):  // Print process list.
      procdump();
    80005c6a:	ffffc097          	auipc	ra,0xffffc
    80005c6e:	dfe080e7          	jalr	-514(ra) # 80001a68 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005c72:	0001f517          	auipc	a0,0x1f
    80005c76:	99e50513          	addi	a0,a0,-1634 # 80024610 <cons>
    80005c7a:	00001097          	auipc	ra,0x1
    80005c7e:	876080e7          	jalr	-1930(ra) # 800064f0 <release>
}
    80005c82:	60e2                	ld	ra,24(sp)
    80005c84:	6442                	ld	s0,16(sp)
    80005c86:	64a2                	ld	s1,8(sp)
    80005c88:	6105                	addi	sp,sp,32
    80005c8a:	8082                	ret
  switch (c) {
    80005c8c:	07f00793          	li	a5,127
    80005c90:	0cf48463          	beq	s1,a5,80005d58 <consoleintr+0x120>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005c94:	0001f717          	auipc	a4,0x1f
    80005c98:	97c70713          	addi	a4,a4,-1668 # 80024610 <cons>
    80005c9c:	0a072783          	lw	a5,160(a4)
    80005ca0:	09872703          	lw	a4,152(a4)
    80005ca4:	9f99                	subw	a5,a5,a4
    80005ca6:	07f00713          	li	a4,127
    80005caa:	fcf764e3          	bltu	a4,a5,80005c72 <consoleintr+0x3a>
        c = (c == '\r') ? '\n' : c;
    80005cae:	47b5                	li	a5,13
    80005cb0:	0cf48d63          	beq	s1,a5,80005d8a <consoleintr+0x152>
        consputc(c);
    80005cb4:	8526                	mv	a0,s1
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	f40080e7          	jalr	-192(ra) # 80005bf6 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cbe:	0001f797          	auipc	a5,0x1f
    80005cc2:	95278793          	addi	a5,a5,-1710 # 80024610 <cons>
    80005cc6:	0a07a683          	lw	a3,160(a5)
    80005cca:	0016871b          	addiw	a4,a3,1
    80005cce:	0007061b          	sext.w	a2,a4
    80005cd2:	0ae7a023          	sw	a4,160(a5)
    80005cd6:	07f6f693          	andi	a3,a3,127
    80005cda:	97b6                	add	a5,a5,a3
    80005cdc:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005ce0:	47a9                	li	a5,10
    80005ce2:	0cf48b63          	beq	s1,a5,80005db8 <consoleintr+0x180>
    80005ce6:	4791                	li	a5,4
    80005ce8:	0cf48863          	beq	s1,a5,80005db8 <consoleintr+0x180>
    80005cec:	0001f797          	auipc	a5,0x1f
    80005cf0:	9bc7a783          	lw	a5,-1604(a5) # 800246a8 <cons+0x98>
    80005cf4:	9f1d                	subw	a4,a4,a5
    80005cf6:	08000793          	li	a5,128
    80005cfa:	f6f71ce3          	bne	a4,a5,80005c72 <consoleintr+0x3a>
    80005cfe:	a86d                	j	80005db8 <consoleintr+0x180>
    80005d00:	e04a                	sd	s2,0(sp)
      while (cons.e != cons.w &&
    80005d02:	0001f717          	auipc	a4,0x1f
    80005d06:	90e70713          	addi	a4,a4,-1778 # 80024610 <cons>
    80005d0a:	0a072783          	lw	a5,160(a4)
    80005d0e:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d12:	0001f497          	auipc	s1,0x1f
    80005d16:	8fe48493          	addi	s1,s1,-1794 # 80024610 <cons>
      while (cons.e != cons.w &&
    80005d1a:	4929                	li	s2,10
    80005d1c:	02f70a63          	beq	a4,a5,80005d50 <consoleintr+0x118>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d20:	37fd                	addiw	a5,a5,-1
    80005d22:	07f7f713          	andi	a4,a5,127
    80005d26:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005d28:	01874703          	lbu	a4,24(a4)
    80005d2c:	03270463          	beq	a4,s2,80005d54 <consoleintr+0x11c>
        cons.e--;
    80005d30:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005d34:	10000513          	li	a0,256
    80005d38:	00000097          	auipc	ra,0x0
    80005d3c:	ebe080e7          	jalr	-322(ra) # 80005bf6 <consputc>
      while (cons.e != cons.w &&
    80005d40:	0a04a783          	lw	a5,160(s1)
    80005d44:	09c4a703          	lw	a4,156(s1)
    80005d48:	fcf71ce3          	bne	a4,a5,80005d20 <consoleintr+0xe8>
    80005d4c:	6902                	ld	s2,0(sp)
    80005d4e:	b715                	j	80005c72 <consoleintr+0x3a>
    80005d50:	6902                	ld	s2,0(sp)
    80005d52:	b705                	j	80005c72 <consoleintr+0x3a>
    80005d54:	6902                	ld	s2,0(sp)
    80005d56:	bf31                	j	80005c72 <consoleintr+0x3a>
      if (cons.e != cons.w) {
    80005d58:	0001f717          	auipc	a4,0x1f
    80005d5c:	8b870713          	addi	a4,a4,-1864 # 80024610 <cons>
    80005d60:	0a072783          	lw	a5,160(a4)
    80005d64:	09c72703          	lw	a4,156(a4)
    80005d68:	f0f705e3          	beq	a4,a5,80005c72 <consoleintr+0x3a>
        cons.e--;
    80005d6c:	37fd                	addiw	a5,a5,-1
    80005d6e:	0001f717          	auipc	a4,0x1f
    80005d72:	94f72123          	sw	a5,-1726(a4) # 800246b0 <cons+0xa0>
        consputc(BACKSPACE);
    80005d76:	10000513          	li	a0,256
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	e7c080e7          	jalr	-388(ra) # 80005bf6 <consputc>
    80005d82:	bdc5                	j	80005c72 <consoleintr+0x3a>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005d84:	ee0487e3          	beqz	s1,80005c72 <consoleintr+0x3a>
    80005d88:	b731                	j	80005c94 <consoleintr+0x5c>
        consputc(c);
    80005d8a:	4529                	li	a0,10
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	e6a080e7          	jalr	-406(ra) # 80005bf6 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d94:	0001f797          	auipc	a5,0x1f
    80005d98:	87c78793          	addi	a5,a5,-1924 # 80024610 <cons>
    80005d9c:	0a07a703          	lw	a4,160(a5)
    80005da0:	0017069b          	addiw	a3,a4,1
    80005da4:	0006861b          	sext.w	a2,a3
    80005da8:	0ad7a023          	sw	a3,160(a5)
    80005dac:	07f77713          	andi	a4,a4,127
    80005db0:	97ba                	add	a5,a5,a4
    80005db2:	4729                	li	a4,10
    80005db4:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005db8:	0001f797          	auipc	a5,0x1f
    80005dbc:	8ec7aa23          	sw	a2,-1804(a5) # 800246ac <cons+0x9c>
          wakeup(&cons.r);
    80005dc0:	0001f517          	auipc	a0,0x1f
    80005dc4:	8e850513          	addi	a0,a0,-1816 # 800246a8 <cons+0x98>
    80005dc8:	ffffc097          	auipc	ra,0xffffc
    80005dcc:	850080e7          	jalr	-1968(ra) # 80001618 <wakeup>
    80005dd0:	b54d                	j	80005c72 <consoleintr+0x3a>

0000000080005dd2 <consoleinit>:

void consoleinit(void) {
    80005dd2:	1141                	addi	sp,sp,-16
    80005dd4:	e406                	sd	ra,8(sp)
    80005dd6:	e022                	sd	s0,0(sp)
    80005dd8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dda:	00003597          	auipc	a1,0x3
    80005dde:	92e58593          	addi	a1,a1,-1746 # 80008708 <etext+0x708>
    80005de2:	0001f517          	auipc	a0,0x1f
    80005de6:	82e50513          	addi	a0,a0,-2002 # 80024610 <cons>
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	5c2080e7          	jalr	1474(ra) # 800063ac <initlock>

  uartinit();
    80005df2:	00000097          	auipc	ra,0x0
    80005df6:	354080e7          	jalr	852(ra) # 80006146 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dfa:	00015797          	auipc	a5,0x15
    80005dfe:	53e78793          	addi	a5,a5,1342 # 8001b338 <devsw>
    80005e02:	00000717          	auipc	a4,0x0
    80005e06:	cce70713          	addi	a4,a4,-818 # 80005ad0 <consoleread>
    80005e0a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e0c:	00000717          	auipc	a4,0x0
    80005e10:	c5670713          	addi	a4,a4,-938 # 80005a62 <consolewrite>
    80005e14:	ef98                	sd	a4,24(a5)
}
    80005e16:	60a2                	ld	ra,8(sp)
    80005e18:	6402                	ld	s0,0(sp)
    80005e1a:	0141                	addi	sp,sp,16
    80005e1c:	8082                	ret

0000000080005e1e <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005e1e:	7179                	addi	sp,sp,-48
    80005e20:	f406                	sd	ra,40(sp)
    80005e22:	f022                	sd	s0,32(sp)
    80005e24:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005e26:	c219                	beqz	a2,80005e2c <printint+0xe>
    80005e28:	08054963          	bltz	a0,80005eba <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e2c:	2501                	sext.w	a0,a0
    80005e2e:	4881                	li	a7,0
    80005e30:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e34:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e36:	2581                	sext.w	a1,a1
    80005e38:	00003617          	auipc	a2,0x3
    80005e3c:	a3860613          	addi	a2,a2,-1480 # 80008870 <digits>
    80005e40:	883a                	mv	a6,a4
    80005e42:	2705                	addiw	a4,a4,1
    80005e44:	02b577bb          	remuw	a5,a0,a1
    80005e48:	1782                	slli	a5,a5,0x20
    80005e4a:	9381                	srli	a5,a5,0x20
    80005e4c:	97b2                	add	a5,a5,a2
    80005e4e:	0007c783          	lbu	a5,0(a5)
    80005e52:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005e56:	0005079b          	sext.w	a5,a0
    80005e5a:	02b5553b          	divuw	a0,a0,a1
    80005e5e:	0685                	addi	a3,a3,1
    80005e60:	feb7f0e3          	bgeu	a5,a1,80005e40 <printint+0x22>

  if (sign) buf[i++] = '-';
    80005e64:	00088c63          	beqz	a7,80005e7c <printint+0x5e>
    80005e68:	fe070793          	addi	a5,a4,-32
    80005e6c:	00878733          	add	a4,a5,s0
    80005e70:	02d00793          	li	a5,45
    80005e74:	fef70823          	sb	a5,-16(a4)
    80005e78:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005e7c:	02e05b63          	blez	a4,80005eb2 <printint+0x94>
    80005e80:	ec26                	sd	s1,24(sp)
    80005e82:	e84a                	sd	s2,16(sp)
    80005e84:	fd040793          	addi	a5,s0,-48
    80005e88:	00e784b3          	add	s1,a5,a4
    80005e8c:	fff78913          	addi	s2,a5,-1
    80005e90:	993a                	add	s2,s2,a4
    80005e92:	377d                	addiw	a4,a4,-1
    80005e94:	1702                	slli	a4,a4,0x20
    80005e96:	9301                	srli	a4,a4,0x20
    80005e98:	40e90933          	sub	s2,s2,a4
    80005e9c:	fff4c503          	lbu	a0,-1(s1)
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	d56080e7          	jalr	-682(ra) # 80005bf6 <consputc>
    80005ea8:	14fd                	addi	s1,s1,-1
    80005eaa:	ff2499e3          	bne	s1,s2,80005e9c <printint+0x7e>
    80005eae:	64e2                	ld	s1,24(sp)
    80005eb0:	6942                	ld	s2,16(sp)
}
    80005eb2:	70a2                	ld	ra,40(sp)
    80005eb4:	7402                	ld	s0,32(sp)
    80005eb6:	6145                	addi	sp,sp,48
    80005eb8:	8082                	ret
    x = -xx;
    80005eba:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005ebe:	4885                	li	a7,1
    x = -xx;
    80005ec0:	bf85                	j	80005e30 <printint+0x12>

0000000080005ec2 <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005ec2:	1101                	addi	sp,sp,-32
    80005ec4:	ec06                	sd	ra,24(sp)
    80005ec6:	e822                	sd	s0,16(sp)
    80005ec8:	e426                	sd	s1,8(sp)
    80005eca:	1000                	addi	s0,sp,32
    80005ecc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ece:	0001f797          	auipc	a5,0x1f
    80005ed2:	8007a123          	sw	zero,-2046(a5) # 800246d0 <pr+0x18>
  printf("panic: ");
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	83a50513          	addi	a0,a0,-1990 # 80008710 <etext+0x710>
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	02e080e7          	jalr	46(ra) # 80005f0c <printf>
  printf(s);
    80005ee6:	8526                	mv	a0,s1
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	024080e7          	jalr	36(ra) # 80005f0c <printf>
  printf("\n");
    80005ef0:	00002517          	auipc	a0,0x2
    80005ef4:	12850513          	addi	a0,a0,296 # 80008018 <etext+0x18>
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	014080e7          	jalr	20(ra) # 80005f0c <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005f00:	4785                	li	a5,1
    80005f02:	00005717          	auipc	a4,0x5
    80005f06:	38f72523          	sw	a5,906(a4) # 8000b28c <panicked>
  for (;;);
    80005f0a:	a001                	j	80005f0a <panic+0x48>

0000000080005f0c <printf>:
void printf(char *fmt, ...) {
    80005f0c:	7131                	addi	sp,sp,-192
    80005f0e:	fc86                	sd	ra,120(sp)
    80005f10:	f8a2                	sd	s0,112(sp)
    80005f12:	e8d2                	sd	s4,80(sp)
    80005f14:	f06a                	sd	s10,32(sp)
    80005f16:	0100                	addi	s0,sp,128
    80005f18:	8a2a                	mv	s4,a0
    80005f1a:	e40c                	sd	a1,8(s0)
    80005f1c:	e810                	sd	a2,16(s0)
    80005f1e:	ec14                	sd	a3,24(s0)
    80005f20:	f018                	sd	a4,32(s0)
    80005f22:	f41c                	sd	a5,40(s0)
    80005f24:	03043823          	sd	a6,48(s0)
    80005f28:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f2c:	0001ed17          	auipc	s10,0x1e
    80005f30:	7a4d2d03          	lw	s10,1956(s10) # 800246d0 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005f34:	040d1463          	bnez	s10,80005f7c <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005f38:	040a0b63          	beqz	s4,80005f8e <printf+0x82>
  va_start(ap, fmt);
    80005f3c:	00840793          	addi	a5,s0,8
    80005f40:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005f44:	000a4503          	lbu	a0,0(s4)
    80005f48:	18050b63          	beqz	a0,800060de <printf+0x1d2>
    80005f4c:	f4a6                	sd	s1,104(sp)
    80005f4e:	f0ca                	sd	s2,96(sp)
    80005f50:	ecce                	sd	s3,88(sp)
    80005f52:	e4d6                	sd	s5,72(sp)
    80005f54:	e0da                	sd	s6,64(sp)
    80005f56:	fc5e                	sd	s7,56(sp)
    80005f58:	f862                	sd	s8,48(sp)
    80005f5a:	f466                	sd	s9,40(sp)
    80005f5c:	ec6e                	sd	s11,24(sp)
    80005f5e:	4981                	li	s3,0
    if (c != '%') {
    80005f60:	02500b13          	li	s6,37
    switch (c) {
    80005f64:	07000b93          	li	s7,112
  consputc('x');
    80005f68:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f6a:	00003a97          	auipc	s5,0x3
    80005f6e:	906a8a93          	addi	s5,s5,-1786 # 80008870 <digits>
    switch (c) {
    80005f72:	07300c13          	li	s8,115
    80005f76:	06400d93          	li	s11,100
    80005f7a:	a0b1                	j	80005fc6 <printf+0xba>
  if (locking) acquire(&pr.lock);
    80005f7c:	0001e517          	auipc	a0,0x1e
    80005f80:	73c50513          	addi	a0,a0,1852 # 800246b8 <pr>
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	4b8080e7          	jalr	1208(ra) # 8000643c <acquire>
    80005f8c:	b775                	j	80005f38 <printf+0x2c>
    80005f8e:	f4a6                	sd	s1,104(sp)
    80005f90:	f0ca                	sd	s2,96(sp)
    80005f92:	ecce                	sd	s3,88(sp)
    80005f94:	e4d6                	sd	s5,72(sp)
    80005f96:	e0da                	sd	s6,64(sp)
    80005f98:	fc5e                	sd	s7,56(sp)
    80005f9a:	f862                	sd	s8,48(sp)
    80005f9c:	f466                	sd	s9,40(sp)
    80005f9e:	ec6e                	sd	s11,24(sp)
  if (fmt == 0) panic("null fmt");
    80005fa0:	00002517          	auipc	a0,0x2
    80005fa4:	78050513          	addi	a0,a0,1920 # 80008720 <etext+0x720>
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	f1a080e7          	jalr	-230(ra) # 80005ec2 <panic>
      consputc(c);
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	c46080e7          	jalr	-954(ra) # 80005bf6 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005fb8:	2985                	addiw	s3,s3,1
    80005fba:	013a07b3          	add	a5,s4,s3
    80005fbe:	0007c503          	lbu	a0,0(a5)
    80005fc2:	10050563          	beqz	a0,800060cc <printf+0x1c0>
    if (c != '%') {
    80005fc6:	ff6515e3          	bne	a0,s6,80005fb0 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005fca:	2985                	addiw	s3,s3,1
    80005fcc:	013a07b3          	add	a5,s4,s3
    80005fd0:	0007c783          	lbu	a5,0(a5)
    80005fd4:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80005fd8:	10078b63          	beqz	a5,800060ee <printf+0x1e2>
    switch (c) {
    80005fdc:	05778a63          	beq	a5,s7,80006030 <printf+0x124>
    80005fe0:	02fbf663          	bgeu	s7,a5,8000600c <printf+0x100>
    80005fe4:	09878863          	beq	a5,s8,80006074 <printf+0x168>
    80005fe8:	07800713          	li	a4,120
    80005fec:	0ce79563          	bne	a5,a4,800060b6 <printf+0x1aa>
        printint(va_arg(ap, int), 16, 1);
    80005ff0:	f8843783          	ld	a5,-120(s0)
    80005ff4:	00878713          	addi	a4,a5,8
    80005ff8:	f8e43423          	sd	a4,-120(s0)
    80005ffc:	4605                	li	a2,1
    80005ffe:	85e6                	mv	a1,s9
    80006000:	4388                	lw	a0,0(a5)
    80006002:	00000097          	auipc	ra,0x0
    80006006:	e1c080e7          	jalr	-484(ra) # 80005e1e <printint>
        break;
    8000600a:	b77d                	j	80005fb8 <printf+0xac>
    switch (c) {
    8000600c:	09678f63          	beq	a5,s6,800060aa <printf+0x19e>
    80006010:	0bb79363          	bne	a5,s11,800060b6 <printf+0x1aa>
        printint(va_arg(ap, int), 10, 1);
    80006014:	f8843783          	ld	a5,-120(s0)
    80006018:	00878713          	addi	a4,a5,8
    8000601c:	f8e43423          	sd	a4,-120(s0)
    80006020:	4605                	li	a2,1
    80006022:	45a9                	li	a1,10
    80006024:	4388                	lw	a0,0(a5)
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	df8080e7          	jalr	-520(ra) # 80005e1e <printint>
        break;
    8000602e:	b769                	j	80005fb8 <printf+0xac>
        printptr(va_arg(ap, uint64));
    80006030:	f8843783          	ld	a5,-120(s0)
    80006034:	00878713          	addi	a4,a5,8
    80006038:	f8e43423          	sd	a4,-120(s0)
    8000603c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006040:	03000513          	li	a0,48
    80006044:	00000097          	auipc	ra,0x0
    80006048:	bb2080e7          	jalr	-1102(ra) # 80005bf6 <consputc>
  consputc('x');
    8000604c:	07800513          	li	a0,120
    80006050:	00000097          	auipc	ra,0x0
    80006054:	ba6080e7          	jalr	-1114(ra) # 80005bf6 <consputc>
    80006058:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000605a:	03c95793          	srli	a5,s2,0x3c
    8000605e:	97d6                	add	a5,a5,s5
    80006060:	0007c503          	lbu	a0,0(a5)
    80006064:	00000097          	auipc	ra,0x0
    80006068:	b92080e7          	jalr	-1134(ra) # 80005bf6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000606c:	0912                	slli	s2,s2,0x4
    8000606e:	34fd                	addiw	s1,s1,-1
    80006070:	f4ed                	bnez	s1,8000605a <printf+0x14e>
    80006072:	b799                	j	80005fb8 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006074:	f8843783          	ld	a5,-120(s0)
    80006078:	00878713          	addi	a4,a5,8
    8000607c:	f8e43423          	sd	a4,-120(s0)
    80006080:	6384                	ld	s1,0(a5)
    80006082:	cc89                	beqz	s1,8000609c <printf+0x190>
        for (; *s; s++) consputc(*s);
    80006084:	0004c503          	lbu	a0,0(s1)
    80006088:	d905                	beqz	a0,80005fb8 <printf+0xac>
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	b6c080e7          	jalr	-1172(ra) # 80005bf6 <consputc>
    80006092:	0485                	addi	s1,s1,1
    80006094:	0004c503          	lbu	a0,0(s1)
    80006098:	f96d                	bnez	a0,8000608a <printf+0x17e>
    8000609a:	bf39                	j	80005fb8 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    8000609c:	00002497          	auipc	s1,0x2
    800060a0:	67c48493          	addi	s1,s1,1660 # 80008718 <etext+0x718>
        for (; *s; s++) consputc(*s);
    800060a4:	02800513          	li	a0,40
    800060a8:	b7cd                	j	8000608a <printf+0x17e>
        consputc('%');
    800060aa:	855a                	mv	a0,s6
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	b4a080e7          	jalr	-1206(ra) # 80005bf6 <consputc>
        break;
    800060b4:	b711                	j	80005fb8 <printf+0xac>
        consputc('%');
    800060b6:	855a                	mv	a0,s6
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	b3e080e7          	jalr	-1218(ra) # 80005bf6 <consputc>
        consputc(c);
    800060c0:	8526                	mv	a0,s1
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	b34080e7          	jalr	-1228(ra) # 80005bf6 <consputc>
        break;
    800060ca:	b5fd                	j	80005fb8 <printf+0xac>
    800060cc:	74a6                	ld	s1,104(sp)
    800060ce:	7906                	ld	s2,96(sp)
    800060d0:	69e6                	ld	s3,88(sp)
    800060d2:	6aa6                	ld	s5,72(sp)
    800060d4:	6b06                	ld	s6,64(sp)
    800060d6:	7be2                	ld	s7,56(sp)
    800060d8:	7c42                	ld	s8,48(sp)
    800060da:	7ca2                	ld	s9,40(sp)
    800060dc:	6de2                	ld	s11,24(sp)
  if (locking) release(&pr.lock);
    800060de:	020d1263          	bnez	s10,80006102 <printf+0x1f6>
}
    800060e2:	70e6                	ld	ra,120(sp)
    800060e4:	7446                	ld	s0,112(sp)
    800060e6:	6a46                	ld	s4,80(sp)
    800060e8:	7d02                	ld	s10,32(sp)
    800060ea:	6129                	addi	sp,sp,192
    800060ec:	8082                	ret
    800060ee:	74a6                	ld	s1,104(sp)
    800060f0:	7906                	ld	s2,96(sp)
    800060f2:	69e6                	ld	s3,88(sp)
    800060f4:	6aa6                	ld	s5,72(sp)
    800060f6:	6b06                	ld	s6,64(sp)
    800060f8:	7be2                	ld	s7,56(sp)
    800060fa:	7c42                	ld	s8,48(sp)
    800060fc:	7ca2                	ld	s9,40(sp)
    800060fe:	6de2                	ld	s11,24(sp)
    80006100:	bff9                	j	800060de <printf+0x1d2>
  if (locking) release(&pr.lock);
    80006102:	0001e517          	auipc	a0,0x1e
    80006106:	5b650513          	addi	a0,a0,1462 # 800246b8 <pr>
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	3e6080e7          	jalr	998(ra) # 800064f0 <release>
}
    80006112:	bfc1                	j	800060e2 <printf+0x1d6>

0000000080006114 <printfinit>:
}

void printfinit(void) {
    80006114:	1101                	addi	sp,sp,-32
    80006116:	ec06                	sd	ra,24(sp)
    80006118:	e822                	sd	s0,16(sp)
    8000611a:	e426                	sd	s1,8(sp)
    8000611c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000611e:	0001e497          	auipc	s1,0x1e
    80006122:	59a48493          	addi	s1,s1,1434 # 800246b8 <pr>
    80006126:	00002597          	auipc	a1,0x2
    8000612a:	60a58593          	addi	a1,a1,1546 # 80008730 <etext+0x730>
    8000612e:	8526                	mv	a0,s1
    80006130:	00000097          	auipc	ra,0x0
    80006134:	27c080e7          	jalr	636(ra) # 800063ac <initlock>
  pr.locking = 1;
    80006138:	4785                	li	a5,1
    8000613a:	cc9c                	sw	a5,24(s1)
}
    8000613c:	60e2                	ld	ra,24(sp)
    8000613e:	6442                	ld	s0,16(sp)
    80006140:	64a2                	ld	s1,8(sp)
    80006142:	6105                	addi	sp,sp,32
    80006144:	8082                	ret

0000000080006146 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006146:	1141                	addi	sp,sp,-16
    80006148:	e406                	sd	ra,8(sp)
    8000614a:	e022                	sd	s0,0(sp)
    8000614c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000614e:	100007b7          	lui	a5,0x10000
    80006152:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006156:	10000737          	lui	a4,0x10000
    8000615a:	f8000693          	li	a3,-128
    8000615e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006162:	468d                	li	a3,3
    80006164:	10000637          	lui	a2,0x10000
    80006168:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000616c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006170:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006174:	10000737          	lui	a4,0x10000
    80006178:	461d                	li	a2,7
    8000617a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000617e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006182:	00002597          	auipc	a1,0x2
    80006186:	5b658593          	addi	a1,a1,1462 # 80008738 <etext+0x738>
    8000618a:	0001e517          	auipc	a0,0x1e
    8000618e:	54e50513          	addi	a0,a0,1358 # 800246d8 <uart_tx_lock>
    80006192:	00000097          	auipc	ra,0x0
    80006196:	21a080e7          	jalr	538(ra) # 800063ac <initlock>
}
    8000619a:	60a2                	ld	ra,8(sp)
    8000619c:	6402                	ld	s0,0(sp)
    8000619e:	0141                	addi	sp,sp,16
    800061a0:	8082                	ret

00000000800061a2 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    800061a2:	1101                	addi	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	addi	s0,sp,32
    800061ac:	84aa                	mv	s1,a0
  push_off();
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	242080e7          	jalr	578(ra) # 800063f0 <push_off>

  if (panicked) {
    800061b6:	00005797          	auipc	a5,0x5
    800061ba:	0d67a783          	lw	a5,214(a5) # 8000b28c <panicked>
    800061be:	eb85                	bnez	a5,800061ee <uartputc_sync+0x4c>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    800061c0:	10000737          	lui	a4,0x10000
    800061c4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800061c6:	00074783          	lbu	a5,0(a4)
    800061ca:	0207f793          	andi	a5,a5,32
    800061ce:	dfe5                	beqz	a5,800061c6 <uartputc_sync+0x24>
  WriteReg(THR, c);
    800061d0:	0ff4f513          	zext.b	a0,s1
    800061d4:	100007b7          	lui	a5,0x10000
    800061d8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	2b4080e7          	jalr	692(ra) # 80006490 <pop_off>
}
    800061e4:	60e2                	ld	ra,24(sp)
    800061e6:	6442                	ld	s0,16(sp)
    800061e8:	64a2                	ld	s1,8(sp)
    800061ea:	6105                	addi	sp,sp,32
    800061ec:	8082                	ret
    for (;;);
    800061ee:	a001                	j	800061ee <uartputc_sync+0x4c>

00000000800061f0 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    800061f0:	00005797          	auipc	a5,0x5
    800061f4:	0a07b783          	ld	a5,160(a5) # 8000b290 <uart_tx_r>
    800061f8:	00005717          	auipc	a4,0x5
    800061fc:	0a073703          	ld	a4,160(a4) # 8000b298 <uart_tx_w>
    80006200:	06f70f63          	beq	a4,a5,8000627e <uartstart+0x8e>
void uartstart() {
    80006204:	7139                	addi	sp,sp,-64
    80006206:	fc06                	sd	ra,56(sp)
    80006208:	f822                	sd	s0,48(sp)
    8000620a:	f426                	sd	s1,40(sp)
    8000620c:	f04a                	sd	s2,32(sp)
    8000620e:	ec4e                	sd	s3,24(sp)
    80006210:	e852                	sd	s4,16(sp)
    80006212:	e456                	sd	s5,8(sp)
    80006214:	e05a                	sd	s6,0(sp)
    80006216:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006218:	10000937          	lui	s2,0x10000
    8000621c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000621e:	0001ea97          	auipc	s5,0x1e
    80006222:	4baa8a93          	addi	s5,s5,1210 # 800246d8 <uart_tx_lock>
    uart_tx_r += 1;
    80006226:	00005497          	auipc	s1,0x5
    8000622a:	06a48493          	addi	s1,s1,106 # 8000b290 <uart_tx_r>

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);

    WriteReg(THR, c);
    8000622e:	10000a37          	lui	s4,0x10000
    if (uart_tx_w == uart_tx_r) {
    80006232:	00005997          	auipc	s3,0x5
    80006236:	06698993          	addi	s3,s3,102 # 8000b298 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    8000623a:	00094703          	lbu	a4,0(s2)
    8000623e:	02077713          	andi	a4,a4,32
    80006242:	c705                	beqz	a4,8000626a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006244:	01f7f713          	andi	a4,a5,31
    80006248:	9756                	add	a4,a4,s5
    8000624a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000624e:	0785                	addi	a5,a5,1
    80006250:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006252:	8526                	mv	a0,s1
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	3c4080e7          	jalr	964(ra) # 80001618 <wakeup>
    WriteReg(THR, c);
    8000625c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if (uart_tx_w == uart_tx_r) {
    80006260:	609c                	ld	a5,0(s1)
    80006262:	0009b703          	ld	a4,0(s3)
    80006266:	fcf71ae3          	bne	a4,a5,8000623a <uartstart+0x4a>
  }
}
    8000626a:	70e2                	ld	ra,56(sp)
    8000626c:	7442                	ld	s0,48(sp)
    8000626e:	74a2                	ld	s1,40(sp)
    80006270:	7902                	ld	s2,32(sp)
    80006272:	69e2                	ld	s3,24(sp)
    80006274:	6a42                	ld	s4,16(sp)
    80006276:	6aa2                	ld	s5,8(sp)
    80006278:	6b02                	ld	s6,0(sp)
    8000627a:	6121                	addi	sp,sp,64
    8000627c:	8082                	ret
    8000627e:	8082                	ret

0000000080006280 <uartputc>:
void uartputc(int c) {
    80006280:	7179                	addi	sp,sp,-48
    80006282:	f406                	sd	ra,40(sp)
    80006284:	f022                	sd	s0,32(sp)
    80006286:	ec26                	sd	s1,24(sp)
    80006288:	e84a                	sd	s2,16(sp)
    8000628a:	e44e                	sd	s3,8(sp)
    8000628c:	e052                	sd	s4,0(sp)
    8000628e:	1800                	addi	s0,sp,48
    80006290:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006292:	0001e517          	auipc	a0,0x1e
    80006296:	44650513          	addi	a0,a0,1094 # 800246d8 <uart_tx_lock>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	1a2080e7          	jalr	418(ra) # 8000643c <acquire>
  if (panicked) {
    800062a2:	00005797          	auipc	a5,0x5
    800062a6:	fea7a783          	lw	a5,-22(a5) # 8000b28c <panicked>
    800062aa:	e7c9                	bnez	a5,80006334 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062ac:	00005717          	auipc	a4,0x5
    800062b0:	fec73703          	ld	a4,-20(a4) # 8000b298 <uart_tx_w>
    800062b4:	00005797          	auipc	a5,0x5
    800062b8:	fdc7b783          	ld	a5,-36(a5) # 8000b290 <uart_tx_r>
    800062bc:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800062c0:	0001e997          	auipc	s3,0x1e
    800062c4:	41898993          	addi	s3,s3,1048 # 800246d8 <uart_tx_lock>
    800062c8:	00005497          	auipc	s1,0x5
    800062cc:	fc848493          	addi	s1,s1,-56 # 8000b290 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062d0:	00005917          	auipc	s2,0x5
    800062d4:	fc890913          	addi	s2,s2,-56 # 8000b298 <uart_tx_w>
    800062d8:	00e79f63          	bne	a5,a4,800062f6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062dc:	85ce                	mv	a1,s3
    800062de:	8526                	mv	a0,s1
    800062e0:	ffffb097          	auipc	ra,0xffffb
    800062e4:	2d4080e7          	jalr	724(ra) # 800015b4 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062e8:	00093703          	ld	a4,0(s2)
    800062ec:	609c                	ld	a5,0(s1)
    800062ee:	02078793          	addi	a5,a5,32
    800062f2:	fee785e3          	beq	a5,a4,800062dc <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062f6:	0001e497          	auipc	s1,0x1e
    800062fa:	3e248493          	addi	s1,s1,994 # 800246d8 <uart_tx_lock>
    800062fe:	01f77793          	andi	a5,a4,31
    80006302:	97a6                	add	a5,a5,s1
    80006304:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006308:	0705                	addi	a4,a4,1
    8000630a:	00005797          	auipc	a5,0x5
    8000630e:	f8e7b723          	sd	a4,-114(a5) # 8000b298 <uart_tx_w>
  uartstart();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	ede080e7          	jalr	-290(ra) # 800061f0 <uartstart>
  release(&uart_tx_lock);
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	1d4080e7          	jalr	468(ra) # 800064f0 <release>
}
    80006324:	70a2                	ld	ra,40(sp)
    80006326:	7402                	ld	s0,32(sp)
    80006328:	64e2                	ld	s1,24(sp)
    8000632a:	6942                	ld	s2,16(sp)
    8000632c:	69a2                	ld	s3,8(sp)
    8000632e:	6a02                	ld	s4,0(sp)
    80006330:	6145                	addi	sp,sp,48
    80006332:	8082                	ret
    for (;;);
    80006334:	a001                	j	80006334 <uartputc+0xb4>

0000000080006336 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006336:	1141                	addi	sp,sp,-16
    80006338:	e422                	sd	s0,8(sp)
    8000633a:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    8000633c:	100007b7          	lui	a5,0x10000
    80006340:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006342:	0007c783          	lbu	a5,0(a5)
    80006346:	8b85                	andi	a5,a5,1
    80006348:	cb81                	beqz	a5,80006358 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000634a:	100007b7          	lui	a5,0x10000
    8000634e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006352:	6422                	ld	s0,8(sp)
    80006354:	0141                	addi	sp,sp,16
    80006356:	8082                	ret
    return -1;
    80006358:	557d                	li	a0,-1
    8000635a:	bfe5                	j	80006352 <uartgetc+0x1c>

000000008000635c <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    8000635c:	1101                	addi	sp,sp,-32
    8000635e:	ec06                	sd	ra,24(sp)
    80006360:	e822                	sd	s0,16(sp)
    80006362:	e426                	sd	s1,8(sp)
    80006364:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006366:	54fd                	li	s1,-1
    80006368:	a029                	j	80006372 <uartintr+0x16>
    consoleintr(c);
    8000636a:	00000097          	auipc	ra,0x0
    8000636e:	8ce080e7          	jalr	-1842(ra) # 80005c38 <consoleintr>
    int c = uartgetc();
    80006372:	00000097          	auipc	ra,0x0
    80006376:	fc4080e7          	jalr	-60(ra) # 80006336 <uartgetc>
    if (c == -1) break;
    8000637a:	fe9518e3          	bne	a0,s1,8000636a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000637e:	0001e497          	auipc	s1,0x1e
    80006382:	35a48493          	addi	s1,s1,858 # 800246d8 <uart_tx_lock>
    80006386:	8526                	mv	a0,s1
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	0b4080e7          	jalr	180(ra) # 8000643c <acquire>
  uartstart();
    80006390:	00000097          	auipc	ra,0x0
    80006394:	e60080e7          	jalr	-416(ra) # 800061f0 <uartstart>
  release(&uart_tx_lock);
    80006398:	8526                	mv	a0,s1
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	156080e7          	jalr	342(ra) # 800064f0 <release>
}
    800063a2:	60e2                	ld	ra,24(sp)
    800063a4:	6442                	ld	s0,16(sp)
    800063a6:	64a2                	ld	s1,8(sp)
    800063a8:	6105                	addi	sp,sp,32
    800063aa:	8082                	ret

00000000800063ac <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    800063ac:	1141                	addi	sp,sp,-16
    800063ae:	e422                	sd	s0,8(sp)
    800063b0:	0800                	addi	s0,sp,16
  lk->name = name;
    800063b2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063b4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063b8:	00053823          	sd	zero,16(a0)
}
    800063bc:	6422                	ld	s0,8(sp)
    800063be:	0141                	addi	sp,sp,16
    800063c0:	8082                	ret

00000000800063c2 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063c2:	411c                	lw	a5,0(a0)
    800063c4:	e399                	bnez	a5,800063ca <holding+0x8>
    800063c6:	4501                	li	a0,0
  return r;
}
    800063c8:	8082                	ret
int holding(struct spinlock *lk) {
    800063ca:	1101                	addi	sp,sp,-32
    800063cc:	ec06                	sd	ra,24(sp)
    800063ce:	e822                	sd	s0,16(sp)
    800063d0:	e426                	sd	s1,8(sp)
    800063d2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063d4:	6904                	ld	s1,16(a0)
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	b14080e7          	jalr	-1260(ra) # 80000eea <mycpu>
    800063de:	40a48533          	sub	a0,s1,a0
    800063e2:	00153513          	seqz	a0,a0
}
    800063e6:	60e2                	ld	ra,24(sp)
    800063e8:	6442                	ld	s0,16(sp)
    800063ea:	64a2                	ld	s1,8(sp)
    800063ec:	6105                	addi	sp,sp,32
    800063ee:	8082                	ret

00000000800063f0 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    800063f0:	1101                	addi	sp,sp,-32
    800063f2:	ec06                	sd	ra,24(sp)
    800063f4:	e822                	sd	s0,16(sp)
    800063f6:	e426                	sd	s1,8(sp)
    800063f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800063fa:	100024f3          	csrr	s1,sstatus
    800063fe:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80006402:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006404:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006408:	ffffb097          	auipc	ra,0xffffb
    8000640c:	ae2080e7          	jalr	-1310(ra) # 80000eea <mycpu>
    80006410:	5d3c                	lw	a5,120(a0)
    80006412:	cf89                	beqz	a5,8000642c <push_off+0x3c>
  mycpu()->noff += 1;
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	ad6080e7          	jalr	-1322(ra) # 80000eea <mycpu>
    8000641c:	5d3c                	lw	a5,120(a0)
    8000641e:	2785                	addiw	a5,a5,1
    80006420:	dd3c                	sw	a5,120(a0)
}
    80006422:	60e2                	ld	ra,24(sp)
    80006424:	6442                	ld	s0,16(sp)
    80006426:	64a2                	ld	s1,8(sp)
    80006428:	6105                	addi	sp,sp,32
    8000642a:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    8000642c:	ffffb097          	auipc	ra,0xffffb
    80006430:	abe080e7          	jalr	-1346(ra) # 80000eea <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006434:	8085                	srli	s1,s1,0x1
    80006436:	8885                	andi	s1,s1,1
    80006438:	dd64                	sw	s1,124(a0)
    8000643a:	bfe9                	j	80006414 <push_off+0x24>

000000008000643c <acquire>:
void acquire(struct spinlock *lk) {
    8000643c:	1101                	addi	sp,sp,-32
    8000643e:	ec06                	sd	ra,24(sp)
    80006440:	e822                	sd	s0,16(sp)
    80006442:	e426                	sd	s1,8(sp)
    80006444:	1000                	addi	s0,sp,32
    80006446:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006448:	00000097          	auipc	ra,0x0
    8000644c:	fa8080e7          	jalr	-88(ra) # 800063f0 <push_off>
  if (holding(lk)) panic("acquire");
    80006450:	8526                	mv	a0,s1
    80006452:	00000097          	auipc	ra,0x0
    80006456:	f70080e7          	jalr	-144(ra) # 800063c2 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000645a:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    8000645c:	e115                	bnez	a0,80006480 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000645e:	87ba                	mv	a5,a4
    80006460:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006464:	2781                	sext.w	a5,a5
    80006466:	ffe5                	bnez	a5,8000645e <acquire+0x22>
  __sync_synchronize();
    80006468:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000646c:	ffffb097          	auipc	ra,0xffffb
    80006470:	a7e080e7          	jalr	-1410(ra) # 80000eea <mycpu>
    80006474:	e888                	sd	a0,16(s1)
}
    80006476:	60e2                	ld	ra,24(sp)
    80006478:	6442                	ld	s0,16(sp)
    8000647a:	64a2                	ld	s1,8(sp)
    8000647c:	6105                	addi	sp,sp,32
    8000647e:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006480:	00002517          	auipc	a0,0x2
    80006484:	2c050513          	addi	a0,a0,704 # 80008740 <etext+0x740>
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	a3a080e7          	jalr	-1478(ra) # 80005ec2 <panic>

0000000080006490 <pop_off>:

void pop_off(void) {
    80006490:	1141                	addi	sp,sp,-16
    80006492:	e406                	sd	ra,8(sp)
    80006494:	e022                	sd	s0,0(sp)
    80006496:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006498:	ffffb097          	auipc	ra,0xffffb
    8000649c:	a52080e7          	jalr	-1454(ra) # 80000eea <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800064a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064a4:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    800064a6:	e78d                	bnez	a5,800064d0 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    800064a8:	5d3c                	lw	a5,120(a0)
    800064aa:	02f05b63          	blez	a5,800064e0 <pop_off+0x50>
  c->noff -= 1;
    800064ae:	37fd                	addiw	a5,a5,-1
    800064b0:	0007871b          	sext.w	a4,a5
    800064b4:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    800064b6:	eb09                	bnez	a4,800064c8 <pop_off+0x38>
    800064b8:	5d7c                	lw	a5,124(a0)
    800064ba:	c799                	beqz	a5,800064c8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800064bc:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800064c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800064c4:	10079073          	csrw	sstatus,a5
}
    800064c8:	60a2                	ld	ra,8(sp)
    800064ca:	6402                	ld	s0,0(sp)
    800064cc:	0141                	addi	sp,sp,16
    800064ce:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	27850513          	addi	a0,a0,632 # 80008748 <etext+0x748>
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	9ea080e7          	jalr	-1558(ra) # 80005ec2 <panic>
  if (c->noff < 1) panic("pop_off");
    800064e0:	00002517          	auipc	a0,0x2
    800064e4:	28050513          	addi	a0,a0,640 # 80008760 <etext+0x760>
    800064e8:	00000097          	auipc	ra,0x0
    800064ec:	9da080e7          	jalr	-1574(ra) # 80005ec2 <panic>

00000000800064f0 <release>:
void release(struct spinlock *lk) {
    800064f0:	1101                	addi	sp,sp,-32
    800064f2:	ec06                	sd	ra,24(sp)
    800064f4:	e822                	sd	s0,16(sp)
    800064f6:	e426                	sd	s1,8(sp)
    800064f8:	1000                	addi	s0,sp,32
    800064fa:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800064fc:	00000097          	auipc	ra,0x0
    80006500:	ec6080e7          	jalr	-314(ra) # 800063c2 <holding>
    80006504:	c115                	beqz	a0,80006528 <release+0x38>
  lk->cpu = 0;
    80006506:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000650a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000650e:	0310000f          	fence	rw,w
    80006512:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006516:	00000097          	auipc	ra,0x0
    8000651a:	f7a080e7          	jalr	-134(ra) # 80006490 <pop_off>
}
    8000651e:	60e2                	ld	ra,24(sp)
    80006520:	6442                	ld	s0,16(sp)
    80006522:	64a2                	ld	s1,8(sp)
    80006524:	6105                	addi	sp,sp,32
    80006526:	8082                	ret
  if (!holding(lk)) panic("release");
    80006528:	00002517          	auipc	a0,0x2
    8000652c:	24050513          	addi	a0,a0,576 # 80008768 <etext+0x768>
    80006530:	00000097          	auipc	ra,0x0
    80006534:	992080e7          	jalr	-1646(ra) # 80005ec2 <panic>
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
