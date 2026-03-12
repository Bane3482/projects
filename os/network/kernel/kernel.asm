
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	5b013103          	ld	sp,1456(sp) # 8000c5b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	634060ef          	jal	8000664a <start>

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
    80000030:	00076797          	auipc	a5,0x76
    80000034:	d5078793          	addi	a5,a5,-688 # 80075d80 <end>
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
    80000050:	0000c917          	auipc	s2,0xc
    80000054:	5d090913          	addi	s2,s2,1488 # 8000c620 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	03e080e7          	jalr	62(ra) # 80007098 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	0de080e7          	jalr	222(ra) # 8000714c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f7e50513          	addi	a0,a0,-130 # 80009000 <etext>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	a94080e7          	jalr	-1388(ra) # 80006b1e <panic>

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
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80009010 <etext+0x10>
    800000ee:	0000c517          	auipc	a0,0xc
    800000f2:	53250513          	addi	a0,a0,1330 # 8000c620 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	f12080e7          	jalr	-238(ra) # 80007008 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00076517          	auipc	a0,0x76
    80000106:	c7e50513          	addi	a0,a0,-898 # 80075d80 <end>
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
    80000124:	0000c497          	auipc	s1,0xc
    80000128:	4fc48493          	addi	s1,s1,1276 # 8000c620 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	f6a080e7          	jalr	-150(ra) # 80007098 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000c517          	auipc	a0,0xc
    80000140:	4e450513          	addi	a0,a0,1252 # 8000c620 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	006080e7          	jalr	6(ra) # 8000714c <release>

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
    80000168:	0000c517          	auipc	a0,0xc
    8000016c:	4b850513          	addi	a0,a0,1208 # 8000c620 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	fdc080e7          	jalr	-36(ra) # 8000714c <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ff89281>
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
    80000324:	bfa080e7          	jalr	-1030(ra) # 80000f1a <cpuid>
    netinit();
    userinit();  // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    80000328:	0000c717          	auipc	a4,0xc
    8000032c:	2a870713          	addi	a4,a4,680 # 8000c5d0 <started>
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
    80000340:	bde080e7          	jalr	-1058(ra) # 80000f1a <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00009517          	auipc	a0,0x9
    8000034a:	cf250513          	addi	a0,a0,-782 # 80009038 <etext+0x38>
    8000034e:	00007097          	auipc	ra,0x7
    80000352:	81a080e7          	jalr	-2022(ra) # 80006b68 <printf>
    kvminithart();   // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0e8080e7          	jalr	232(ra) # 8000043e <kvminithart>
    trapinithart();  // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	88c080e7          	jalr	-1908(ra) # 80001bea <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	f32080e7          	jalr	-206(ra) # 80005298 <plicinithart>
  }

  scheduler();
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	0d4080e7          	jalr	212(ra) # 80001442 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	6b8080e7          	jalr	1720(ra) # 80006a2e <consoleinit>
    printfinit();
    8000037e:	00007097          	auipc	ra,0x7
    80000382:	9f2080e7          	jalr	-1550(ra) # 80006d70 <printfinit>
    printf("\n");
    80000386:	00009517          	auipc	a0,0x9
    8000038a:	c9250513          	addi	a0,a0,-878 # 80009018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	7da080e7          	jalr	2010(ra) # 80006b68 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00009517          	auipc	a0,0x9
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80009020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	7ca080e7          	jalr	1994(ra) # 80006b68 <printf>
    printf("\n");
    800003a6:	00009517          	auipc	a0,0x9
    800003aa:	c7250513          	addi	a0,a0,-910 # 80009018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	7ba080e7          	jalr	1978(ra) # 80006b68 <printf>
    kinit();             // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	38a080e7          	jalr	906(ra) # 80000748 <kvminit>
    kvminithart();       // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	078080e7          	jalr	120(ra) # 8000043e <kvminithart>
    procinit();          // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	a8a080e7          	jalr	-1398(ra) # 80000e58 <procinit>
    trapinit();          // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	7ec080e7          	jalr	2028(ra) # 80001bc2 <trapinit>
    trapinithart();      // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	80c080e7          	jalr	-2036(ra) # 80001bea <trapinithart>
    plicinit();          // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	e84080e7          	jalr	-380(ra) # 8000526a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	eaa080e7          	jalr	-342(ra) # 80005298 <plicinithart>
    binit();             // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f5c080e7          	jalr	-164(ra) # 80002352 <binit>
    iinit();             // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	612080e7          	jalr	1554(ra) # 80002a10 <iinit>
    fileinit();          // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5c2080e7          	jalr	1474(ra) # 800039c8 <fileinit>
    virtio_disk_init();  // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f98080e7          	jalr	-104(ra) # 800053a6 <virtio_disk_init>
    pci_init();
    80000416:	00006097          	auipc	ra,0x6
    8000041a:	138080e7          	jalr	312(ra) # 8000654e <pci_init>
    netinit();
    8000041e:	00005097          	auipc	ra,0x5
    80000422:	7f0080e7          	jalr	2032(ra) # 80005c0e <netinit>
    userinit();  // first user process
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	dfc080e7          	jalr	-516(ra) # 80001222 <userinit>
    __sync_synchronize();
    8000042e:	0330000f          	fence	rw,rw
    started = 1;
    80000432:	4785                	li	a5,1
    80000434:	0000c717          	auipc	a4,0xc
    80000438:	18f72e23          	sw	a5,412(a4) # 8000c5d0 <started>
    8000043c:	bf0d                	j	8000036e <main+0x56>

000000008000043e <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    8000043e:	1141                	addi	sp,sp,-16
    80000440:	e422                	sd	s0,8(sp)
    80000442:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000444:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000448:	0000c797          	auipc	a5,0xc
    8000044c:	1907b783          	ld	a5,400(a5) # 8000c5d8 <kernel_pagetable>
    80000450:	83b1                	srli	a5,a5,0xc
    80000452:	577d                	li	a4,-1
    80000454:	177e                	slli	a4,a4,0x3f
    80000456:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000458:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000460:	6422                	ld	s0,8(sp)
    80000462:	0141                	addi	sp,sp,16
    80000464:	8082                	ret

0000000080000466 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000466:	7139                	addi	sp,sp,-64
    80000468:	fc06                	sd	ra,56(sp)
    8000046a:	f822                	sd	s0,48(sp)
    8000046c:	f426                	sd	s1,40(sp)
    8000046e:	f04a                	sd	s2,32(sp)
    80000470:	ec4e                	sd	s3,24(sp)
    80000472:	e852                	sd	s4,16(sp)
    80000474:	e456                	sd	s5,8(sp)
    80000476:	e05a                	sd	s6,0(sp)
    80000478:	0080                	addi	s0,sp,64
    8000047a:	84aa                	mv	s1,a0
    8000047c:	89ae                	mv	s3,a1
    8000047e:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000480:	57fd                	li	a5,-1
    80000482:	83e9                	srli	a5,a5,0x1a
    80000484:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    80000486:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000488:	04b7f263          	bgeu	a5,a1,800004cc <walk+0x66>
    8000048c:	00009517          	auipc	a0,0x9
    80000490:	bc450513          	addi	a0,a0,-1084 # 80009050 <etext+0x50>
    80000494:	00006097          	auipc	ra,0x6
    80000498:	68a080e7          	jalr	1674(ra) # 80006b1e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    8000049c:	060a8663          	beqz	s5,80000508 <walk+0xa2>
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	c7a080e7          	jalr	-902(ra) # 8000011a <kalloc>
    800004a8:	84aa                	mv	s1,a0
    800004aa:	c529                	beqz	a0,800004f4 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800004ac:	6605                	lui	a2,0x1
    800004ae:	4581                	li	a1,0
    800004b0:	00000097          	auipc	ra,0x0
    800004b4:	cca080e7          	jalr	-822(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b8:	00c4d793          	srli	a5,s1,0xc
    800004bc:	07aa                	slli	a5,a5,0xa
    800004be:	0017e793          	ori	a5,a5,1
    800004c2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004c6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff89277>
    800004c8:	036a0063          	beq	s4,s6,800004e8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004cc:	0149d933          	srl	s2,s3,s4
    800004d0:	1ff97913          	andi	s2,s2,511
    800004d4:	090e                	slli	s2,s2,0x3
    800004d6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800004d8:	00093483          	ld	s1,0(s2)
    800004dc:	0014f793          	andi	a5,s1,1
    800004e0:	dfd5                	beqz	a5,8000049c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e2:	80a9                	srli	s1,s1,0xa
    800004e4:	04b2                	slli	s1,s1,0xc
    800004e6:	b7c5                	j	800004c6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e8:	00c9d513          	srli	a0,s3,0xc
    800004ec:	1ff57513          	andi	a0,a0,511
    800004f0:	050e                	slli	a0,a0,0x3
    800004f2:	9526                	add	a0,a0,s1
}
    800004f4:	70e2                	ld	ra,56(sp)
    800004f6:	7442                	ld	s0,48(sp)
    800004f8:	74a2                	ld	s1,40(sp)
    800004fa:	7902                	ld	s2,32(sp)
    800004fc:	69e2                	ld	s3,24(sp)
    800004fe:	6a42                	ld	s4,16(sp)
    80000500:	6aa2                	ld	s5,8(sp)
    80000502:	6b02                	ld	s6,0(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000508:	4501                	li	a0,0
    8000050a:	b7ed                	j	800004f4 <walk+0x8e>

000000008000050c <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    8000050c:	57fd                	li	a5,-1
    8000050e:	83e9                	srli	a5,a5,0x1a
    80000510:	00b7f463          	bgeu	a5,a1,80000518 <walkaddr+0xc>
    80000514:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000516:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000518:	1141                	addi	sp,sp,-16
    8000051a:	e406                	sd	ra,8(sp)
    8000051c:	e022                	sd	s0,0(sp)
    8000051e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000520:	4601                	li	a2,0
    80000522:	00000097          	auipc	ra,0x0
    80000526:	f44080e7          	jalr	-188(ra) # 80000466 <walk>
  if (pte == 0) return 0;
    8000052a:	c105                	beqz	a0,8000054a <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    8000052c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    8000052e:	0117f693          	andi	a3,a5,17
    80000532:	4745                	li	a4,17
    80000534:	4501                	li	a0,0
    80000536:	00e68663          	beq	a3,a4,80000542 <walkaddr+0x36>
}
    8000053a:	60a2                	ld	ra,8(sp)
    8000053c:	6402                	ld	s0,0(sp)
    8000053e:	0141                	addi	sp,sp,16
    80000540:	8082                	ret
  pa = PTE2PA(*pte);
    80000542:	83a9                	srli	a5,a5,0xa
    80000544:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000548:	bfcd                	j	8000053a <walkaddr+0x2e>
  if (pte == 0) return 0;
    8000054a:	4501                	li	a0,0
    8000054c:	b7fd                	j	8000053a <walkaddr+0x2e>

000000008000054e <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000054e:	715d                	addi	sp,sp,-80
    80000550:	e486                	sd	ra,72(sp)
    80000552:	e0a2                	sd	s0,64(sp)
    80000554:	fc26                	sd	s1,56(sp)
    80000556:	f84a                	sd	s2,48(sp)
    80000558:	f44e                	sd	s3,40(sp)
    8000055a:	f052                	sd	s4,32(sp)
    8000055c:	ec56                	sd	s5,24(sp)
    8000055e:	e85a                	sd	s6,16(sp)
    80000560:	e45e                	sd	s7,8(sp)
    80000562:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    80000564:	03459793          	slli	a5,a1,0x34
    80000568:	e7b9                	bnez	a5,800005b6 <mappages+0x68>
    8000056a:	8aaa                	mv	s5,a0
    8000056c:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    8000056e:	03461793          	slli	a5,a2,0x34
    80000572:	ebb1                	bnez	a5,800005c6 <mappages+0x78>

  if (size == 0) panic("mappages: size");
    80000574:	c22d                	beqz	a2,800005d6 <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    80000576:	77fd                	lui	a5,0xfffff
    80000578:	963e                	add	a2,a2,a5
    8000057a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000057e:	892e                	mv	s2,a1
    80000580:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000584:	6b85                	lui	s7,0x1
    80000586:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000058a:	4605                	li	a2,1
    8000058c:	85ca                	mv	a1,s2
    8000058e:	8556                	mv	a0,s5
    80000590:	00000097          	auipc	ra,0x0
    80000594:	ed6080e7          	jalr	-298(ra) # 80000466 <walk>
    80000598:	cd39                	beqz	a0,800005f6 <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    8000059a:	611c                	ld	a5,0(a0)
    8000059c:	8b85                	andi	a5,a5,1
    8000059e:	e7a1                	bnez	a5,800005e6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005a0:	80b1                	srli	s1,s1,0xc
    800005a2:	04aa                	slli	s1,s1,0xa
    800005a4:	0164e4b3          	or	s1,s1,s6
    800005a8:	0014e493          	ori	s1,s1,1
    800005ac:	e104                	sd	s1,0(a0)
    if (a == last) break;
    800005ae:	07390063          	beq	s2,s3,8000060e <mappages+0xc0>
    a += PGSIZE;
    800005b2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005b4:	bfc9                	j	80000586 <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800005b6:	00009517          	auipc	a0,0x9
    800005ba:	aa250513          	addi	a0,a0,-1374 # 80009058 <etext+0x58>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	560080e7          	jalr	1376(ra) # 80006b1e <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    800005c6:	00009517          	auipc	a0,0x9
    800005ca:	ab250513          	addi	a0,a0,-1358 # 80009078 <etext+0x78>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	550080e7          	jalr	1360(ra) # 80006b1e <panic>
  if (size == 0) panic("mappages: size");
    800005d6:	00009517          	auipc	a0,0x9
    800005da:	ac250513          	addi	a0,a0,-1342 # 80009098 <etext+0x98>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	540080e7          	jalr	1344(ra) # 80006b1e <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800005e6:	00009517          	auipc	a0,0x9
    800005ea:	ac250513          	addi	a0,a0,-1342 # 800090a8 <etext+0xa8>
    800005ee:	00006097          	auipc	ra,0x6
    800005f2:	530080e7          	jalr	1328(ra) # 80006b1e <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005f6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005f8:	60a6                	ld	ra,72(sp)
    800005fa:	6406                	ld	s0,64(sp)
    800005fc:	74e2                	ld	s1,56(sp)
    800005fe:	7942                	ld	s2,48(sp)
    80000600:	79a2                	ld	s3,40(sp)
    80000602:	7a02                	ld	s4,32(sp)
    80000604:	6ae2                	ld	s5,24(sp)
    80000606:	6b42                	ld	s6,16(sp)
    80000608:	6ba2                	ld	s7,8(sp)
    8000060a:	6161                	addi	sp,sp,80
    8000060c:	8082                	ret
  return 0;
    8000060e:	4501                	li	a0,0
    80000610:	b7e5                	j	800005f8 <mappages+0xaa>

0000000080000612 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    80000612:	1141                	addi	sp,sp,-16
    80000614:	e406                	sd	ra,8(sp)
    80000616:	e022                	sd	s0,0(sp)
    80000618:	0800                	addi	s0,sp,16
    8000061a:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    8000061c:	86b2                	mv	a3,a2
    8000061e:	863e                	mv	a2,a5
    80000620:	00000097          	auipc	ra,0x0
    80000624:	f2e080e7          	jalr	-210(ra) # 8000054e <mappages>
    80000628:	e509                	bnez	a0,80000632 <kvmmap+0x20>
}
    8000062a:	60a2                	ld	ra,8(sp)
    8000062c:	6402                	ld	s0,0(sp)
    8000062e:	0141                	addi	sp,sp,16
    80000630:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000632:	00009517          	auipc	a0,0x9
    80000636:	a8650513          	addi	a0,a0,-1402 # 800090b8 <etext+0xb8>
    8000063a:	00006097          	auipc	ra,0x6
    8000063e:	4e4080e7          	jalr	1252(ra) # 80006b1e <panic>

0000000080000642 <kvmmake>:
pagetable_t kvmmake(void) {
    80000642:	1101                	addi	sp,sp,-32
    80000644:	ec06                	sd	ra,24(sp)
    80000646:	e822                	sd	s0,16(sp)
    80000648:	e426                	sd	s1,8(sp)
    8000064a:	e04a                	sd	s2,0(sp)
    8000064c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	acc080e7          	jalr	-1332(ra) # 8000011a <kalloc>
    80000656:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000658:	6605                	lui	a2,0x1
    8000065a:	4581                	li	a1,0
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	b1e080e7          	jalr	-1250(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	6685                	lui	a3,0x1
    80000668:	10000637          	lui	a2,0x10000
    8000066c:	100005b7          	lui	a1,0x10000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	fa0080e7          	jalr	-96(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000067a:	4719                	li	a4,6
    8000067c:	6685                	lui	a3,0x1
    8000067e:	10001637          	lui	a2,0x10001
    80000682:	100015b7          	lui	a1,0x10001
    80000686:	8526                	mv	a0,s1
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	f8a080e7          	jalr	-118(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000690:	4719                	li	a4,6
    80000692:	100006b7          	lui	a3,0x10000
    80000696:	30000637          	lui	a2,0x30000
    8000069a:	300005b7          	lui	a1,0x30000
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f72080e7          	jalr	-142(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    800006a8:	4719                	li	a4,6
    800006aa:	000206b7          	lui	a3,0x20
    800006ae:	40000637          	lui	a2,0x40000
    800006b2:	400005b7          	lui	a1,0x40000
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f5a080e7          	jalr	-166(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006c0:	4719                	li	a4,6
    800006c2:	004006b7          	lui	a3,0x400
    800006c6:	0c000637          	lui	a2,0xc000
    800006ca:	0c0005b7          	lui	a1,0xc000
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	f42080e7          	jalr	-190(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800006d8:	00009917          	auipc	s2,0x9
    800006dc:	92890913          	addi	s2,s2,-1752 # 80009000 <etext>
    800006e0:	4729                	li	a4,10
    800006e2:	80009697          	auipc	a3,0x80009
    800006e6:	91e68693          	addi	a3,a3,-1762 # 9000 <_entry-0x7fff7000>
    800006ea:	4605                	li	a2,1
    800006ec:	067e                	slli	a2,a2,0x1f
    800006ee:	85b2                	mv	a1,a2
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f20080e7          	jalr	-224(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800006fa:	46c5                	li	a3,17
    800006fc:	06ee                	slli	a3,a3,0x1b
    800006fe:	4719                	li	a4,6
    80000700:	412686b3          	sub	a3,a3,s2
    80000704:	864a                	mv	a2,s2
    80000706:	85ca                	mv	a1,s2
    80000708:	8526                	mv	a0,s1
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	f08080e7          	jalr	-248(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000712:	4729                	li	a4,10
    80000714:	6685                	lui	a3,0x1
    80000716:	00008617          	auipc	a2,0x8
    8000071a:	8ea60613          	addi	a2,a2,-1814 # 80008000 <_trampoline>
    8000071e:	040005b7          	lui	a1,0x4000
    80000722:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000724:	05b2                	slli	a1,a1,0xc
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	eea080e7          	jalr	-278(ra) # 80000612 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	682080e7          	jalr	1666(ra) # 80000db4 <proc_mapstacks>
}
    8000073a:	8526                	mv	a0,s1
    8000073c:	60e2                	ld	ra,24(sp)
    8000073e:	6442                	ld	s0,16(sp)
    80000740:	64a2                	ld	s1,8(sp)
    80000742:	6902                	ld	s2,0(sp)
    80000744:	6105                	addi	sp,sp,32
    80000746:	8082                	ret

0000000080000748 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    80000748:	1141                	addi	sp,sp,-16
    8000074a:	e406                	sd	ra,8(sp)
    8000074c:	e022                	sd	s0,0(sp)
    8000074e:	0800                	addi	s0,sp,16
    80000750:	00000097          	auipc	ra,0x0
    80000754:	ef2080e7          	jalr	-270(ra) # 80000642 <kvmmake>
    80000758:	0000c797          	auipc	a5,0xc
    8000075c:	e8a7b023          	sd	a0,-384(a5) # 8000c5d8 <kernel_pagetable>
    80000760:	60a2                	ld	ra,8(sp)
    80000762:	6402                	ld	s0,0(sp)
    80000764:	0141                	addi	sp,sp,16
    80000766:	8082                	ret

0000000080000768 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80000768:	715d                	addi	sp,sp,-80
    8000076a:	e486                	sd	ra,72(sp)
    8000076c:	e0a2                	sd	s0,64(sp)
    8000076e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000770:	03459793          	slli	a5,a1,0x34
    80000774:	e39d                	bnez	a5,8000079a <uvmunmap+0x32>
    80000776:	f84a                	sd	s2,48(sp)
    80000778:	f44e                	sd	s3,40(sp)
    8000077a:	f052                	sd	s4,32(sp)
    8000077c:	ec56                	sd	s5,24(sp)
    8000077e:	e85a                	sd	s6,16(sp)
    80000780:	e45e                	sd	s7,8(sp)
    80000782:	8a2a                	mv	s4,a0
    80000784:	892e                	mv	s2,a1
    80000786:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000788:	0632                	slli	a2,a2,0xc
    8000078a:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000078e:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000790:	6b05                	lui	s6,0x1
    80000792:	0935fb63          	bgeu	a1,s3,80000828 <uvmunmap+0xc0>
    80000796:	fc26                	sd	s1,56(sp)
    80000798:	a8a9                	j	800007f2 <uvmunmap+0x8a>
    8000079a:	fc26                	sd	s1,56(sp)
    8000079c:	f84a                	sd	s2,48(sp)
    8000079e:	f44e                	sd	s3,40(sp)
    800007a0:	f052                	sd	s4,32(sp)
    800007a2:	ec56                	sd	s5,24(sp)
    800007a4:	e85a                	sd	s6,16(sp)
    800007a6:	e45e                	sd	s7,8(sp)
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    800007a8:	00009517          	auipc	a0,0x9
    800007ac:	91850513          	addi	a0,a0,-1768 # 800090c0 <etext+0xc0>
    800007b0:	00006097          	auipc	ra,0x6
    800007b4:	36e080e7          	jalr	878(ra) # 80006b1e <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    800007b8:	00009517          	auipc	a0,0x9
    800007bc:	92050513          	addi	a0,a0,-1760 # 800090d8 <etext+0xd8>
    800007c0:	00006097          	auipc	ra,0x6
    800007c4:	35e080e7          	jalr	862(ra) # 80006b1e <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800007c8:	00009517          	auipc	a0,0x9
    800007cc:	92050513          	addi	a0,a0,-1760 # 800090e8 <etext+0xe8>
    800007d0:	00006097          	auipc	ra,0x6
    800007d4:	34e080e7          	jalr	846(ra) # 80006b1e <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007d8:	00009517          	auipc	a0,0x9
    800007dc:	92850513          	addi	a0,a0,-1752 # 80009100 <etext+0x100>
    800007e0:	00006097          	auipc	ra,0x6
    800007e4:	33e080e7          	jalr	830(ra) # 80006b1e <panic>
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800007e8:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007ec:	995a                	add	s2,s2,s6
    800007ee:	03397c63          	bgeu	s2,s3,80000826 <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    800007f2:	4601                	li	a2,0
    800007f4:	85ca                	mv	a1,s2
    800007f6:	8552                	mv	a0,s4
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	c6e080e7          	jalr	-914(ra) # 80000466 <walk>
    80000800:	84aa                	mv	s1,a0
    80000802:	d95d                	beqz	a0,800007b8 <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000804:	6108                	ld	a0,0(a0)
    80000806:	00157793          	andi	a5,a0,1
    8000080a:	dfdd                	beqz	a5,800007c8 <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000080c:	3ff57793          	andi	a5,a0,1023
    80000810:	fd7784e3          	beq	a5,s7,800007d8 <uvmunmap+0x70>
    if (do_free) {
    80000814:	fc0a8ae3          	beqz	s5,800007e8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000818:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    8000081a:	0532                	slli	a0,a0,0xc
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	800080e7          	jalr	-2048(ra) # 8000001c <kfree>
    80000824:	b7d1                	j	800007e8 <uvmunmap+0x80>
    80000826:	74e2                	ld	s1,56(sp)
    80000828:	7942                	ld	s2,48(sp)
    8000082a:	79a2                	ld	s3,40(sp)
    8000082c:	7a02                	ld	s4,32(sp)
    8000082e:	6ae2                	ld	s5,24(sp)
    80000830:	6b42                	ld	s6,16(sp)
    80000832:	6ba2                	ld	s7,8(sp)
  }
}
    80000834:	60a6                	ld	ra,72(sp)
    80000836:	6406                	ld	s0,64(sp)
    80000838:	6161                	addi	sp,sp,80
    8000083a:	8082                	ret

000000008000083c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    8000083c:	1101                	addi	sp,sp,-32
    8000083e:	ec06                	sd	ra,24(sp)
    80000840:	e822                	sd	s0,16(sp)
    80000842:	e426                	sd	s1,8(sp)
    80000844:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000850:	c519                	beqz	a0,8000085e <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    80000852:	6605                	lui	a2,0x1
    80000854:	4581                	li	a1,0
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	924080e7          	jalr	-1756(ra) # 8000017a <memset>
  return pagetable;
}
    8000085e:	8526                	mv	a0,s1
    80000860:	60e2                	ld	ra,24(sp)
    80000862:	6442                	ld	s0,16(sp)
    80000864:	64a2                	ld	s1,8(sp)
    80000866:	6105                	addi	sp,sp,32
    80000868:	8082                	ret

000000008000086a <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    8000086a:	7179                	addi	sp,sp,-48
    8000086c:	f406                	sd	ra,40(sp)
    8000086e:	f022                	sd	s0,32(sp)
    80000870:	ec26                	sd	s1,24(sp)
    80000872:	e84a                	sd	s2,16(sp)
    80000874:	e44e                	sd	s3,8(sp)
    80000876:	e052                	sd	s4,0(sp)
    80000878:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000087a:	6785                	lui	a5,0x1
    8000087c:	04f67863          	bgeu	a2,a5,800008cc <uvmfirst+0x62>
    80000880:	8a2a                	mv	s4,a0
    80000882:	89ae                	mv	s3,a1
    80000884:	84b2                	mv	s1,a2
  mem = kalloc();
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	894080e7          	jalr	-1900(ra) # 8000011a <kalloc>
    8000088e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000890:	6605                	lui	a2,0x1
    80000892:	4581                	li	a1,0
    80000894:	00000097          	auipc	ra,0x0
    80000898:	8e6080e7          	jalr	-1818(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000089c:	4779                	li	a4,30
    8000089e:	86ca                	mv	a3,s2
    800008a0:	6605                	lui	a2,0x1
    800008a2:	4581                	li	a1,0
    800008a4:	8552                	mv	a0,s4
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	ca8080e7          	jalr	-856(ra) # 8000054e <mappages>
  memmove(mem, src, sz);
    800008ae:	8626                	mv	a2,s1
    800008b0:	85ce                	mv	a1,s3
    800008b2:	854a                	mv	a0,s2
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	922080e7          	jalr	-1758(ra) # 800001d6 <memmove>
}
    800008bc:	70a2                	ld	ra,40(sp)
    800008be:	7402                	ld	s0,32(sp)
    800008c0:	64e2                	ld	s1,24(sp)
    800008c2:	6942                	ld	s2,16(sp)
    800008c4:	69a2                	ld	s3,8(sp)
    800008c6:	6a02                	ld	s4,0(sp)
    800008c8:	6145                	addi	sp,sp,48
    800008ca:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    800008cc:	00009517          	auipc	a0,0x9
    800008d0:	84c50513          	addi	a0,a0,-1972 # 80009118 <etext+0x118>
    800008d4:	00006097          	auipc	ra,0x6
    800008d8:	24a080e7          	jalr	586(ra) # 80006b1e <panic>

00000000800008dc <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    800008dc:	1101                	addi	sp,sp,-32
    800008de:	ec06                	sd	ra,24(sp)
    800008e0:	e822                	sd	s0,16(sp)
    800008e2:	e426                	sd	s1,8(sp)
    800008e4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    800008e6:	84ae                	mv	s1,a1
    800008e8:	00b67d63          	bgeu	a2,a1,80000902 <uvmdealloc+0x26>
    800008ec:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800008ee:	6785                	lui	a5,0x1
    800008f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008f2:	00f60733          	add	a4,a2,a5
    800008f6:	76fd                	lui	a3,0xfffff
    800008f8:	8f75                	and	a4,a4,a3
    800008fa:	97ae                	add	a5,a5,a1
    800008fc:	8ff5                	and	a5,a5,a3
    800008fe:	00f76863          	bltu	a4,a5,8000090e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000902:	8526                	mv	a0,s1
    80000904:	60e2                	ld	ra,24(sp)
    80000906:	6442                	ld	s0,16(sp)
    80000908:	64a2                	ld	s1,8(sp)
    8000090a:	6105                	addi	sp,sp,32
    8000090c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000090e:	8f99                	sub	a5,a5,a4
    80000910:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000912:	4685                	li	a3,1
    80000914:	0007861b          	sext.w	a2,a5
    80000918:	85ba                	mv	a1,a4
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	e4e080e7          	jalr	-434(ra) # 80000768 <uvmunmap>
    80000922:	b7c5                	j	80000902 <uvmdealloc+0x26>

0000000080000924 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    80000924:	0ab66b63          	bltu	a2,a1,800009da <uvmalloc+0xb6>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    80000928:	7139                	addi	sp,sp,-64
    8000092a:	fc06                	sd	ra,56(sp)
    8000092c:	f822                	sd	s0,48(sp)
    8000092e:	ec4e                	sd	s3,24(sp)
    80000930:	e852                	sd	s4,16(sp)
    80000932:	e456                	sd	s5,8(sp)
    80000934:	0080                	addi	s0,sp,64
    80000936:	8aaa                	mv	s5,a0
    80000938:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000093a:	6785                	lui	a5,0x1
    8000093c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000093e:	95be                	add	a1,a1,a5
    80000940:	77fd                	lui	a5,0xfffff
    80000942:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000946:	08c9fc63          	bgeu	s3,a2,800009de <uvmalloc+0xba>
    8000094a:	f426                	sd	s1,40(sp)
    8000094c:	f04a                	sd	s2,32(sp)
    8000094e:	e05a                	sd	s6,0(sp)
    80000950:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000952:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000956:	fffff097          	auipc	ra,0xfffff
    8000095a:	7c4080e7          	jalr	1988(ra) # 8000011a <kalloc>
    8000095e:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000960:	c915                	beqz	a0,80000994 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000962:	6605                	lui	a2,0x1
    80000964:	4581                	li	a1,0
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	814080e7          	jalr	-2028(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000096e:	875a                	mv	a4,s6
    80000970:	86a6                	mv	a3,s1
    80000972:	6605                	lui	a2,0x1
    80000974:	85ca                	mv	a1,s2
    80000976:	8556                	mv	a0,s5
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	bd6080e7          	jalr	-1066(ra) # 8000054e <mappages>
    80000980:	ed05                	bnez	a0,800009b8 <uvmalloc+0x94>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000982:	6785                	lui	a5,0x1
    80000984:	993e                	add	s2,s2,a5
    80000986:	fd4968e3          	bltu	s2,s4,80000956 <uvmalloc+0x32>
  return newsz;
    8000098a:	8552                	mv	a0,s4
    8000098c:	74a2                	ld	s1,40(sp)
    8000098e:	7902                	ld	s2,32(sp)
    80000990:	6b02                	ld	s6,0(sp)
    80000992:	a821                	j	800009aa <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f42080e7          	jalr	-190(ra) # 800008dc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	74a2                	ld	s1,40(sp)
    800009a6:	7902                	ld	s2,32(sp)
    800009a8:	6b02                	ld	s6,0(sp)
}
    800009aa:	70e2                	ld	ra,56(sp)
    800009ac:	7442                	ld	s0,48(sp)
    800009ae:	69e2                	ld	s3,24(sp)
    800009b0:	6a42                	ld	s4,16(sp)
    800009b2:	6aa2                	ld	s5,8(sp)
    800009b4:	6121                	addi	sp,sp,64
    800009b6:	8082                	ret
      kfree(mem);
    800009b8:	8526                	mv	a0,s1
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	662080e7          	jalr	1634(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009c2:	864e                	mv	a2,s3
    800009c4:	85ca                	mv	a1,s2
    800009c6:	8556                	mv	a0,s5
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	f14080e7          	jalr	-236(ra) # 800008dc <uvmdealloc>
      return 0;
    800009d0:	4501                	li	a0,0
    800009d2:	74a2                	ld	s1,40(sp)
    800009d4:	7902                	ld	s2,32(sp)
    800009d6:	6b02                	ld	s6,0(sp)
    800009d8:	bfc9                	j	800009aa <uvmalloc+0x86>
  if (newsz < oldsz) return oldsz;
    800009da:	852e                	mv	a0,a1
}
    800009dc:	8082                	ret
  return newsz;
    800009de:	8532                	mv	a0,a2
    800009e0:	b7e9                	j	800009aa <uvmalloc+0x86>

00000000800009e2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    800009e2:	7179                	addi	sp,sp,-48
    800009e4:	f406                	sd	ra,40(sp)
    800009e6:	f022                	sd	s0,32(sp)
    800009e8:	ec26                	sd	s1,24(sp)
    800009ea:	e84a                	sd	s2,16(sp)
    800009ec:	e44e                	sd	s3,8(sp)
    800009ee:	e052                	sd	s4,0(sp)
    800009f0:	1800                	addi	s0,sp,48
    800009f2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800009f4:	84aa                	mv	s1,a0
    800009f6:	6905                	lui	s2,0x1
    800009f8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009fa:	4985                	li	s3,1
    800009fc:	a829                	j	80000a16 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009fe:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a00:	00c79513          	slli	a0,a5,0xc
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	fde080e7          	jalr	-34(ra) # 800009e2 <freewalk>
      pagetable[i] = 0;
    80000a0c:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000a10:	04a1                	addi	s1,s1,8
    80000a12:	03248163          	beq	s1,s2,80000a34 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a16:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a18:	00f7f713          	andi	a4,a5,15
    80000a1c:	ff3701e3          	beq	a4,s3,800009fe <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000a20:	8b85                	andi	a5,a5,1
    80000a22:	d7fd                	beqz	a5,80000a10 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a24:	00008517          	auipc	a0,0x8
    80000a28:	71450513          	addi	a0,a0,1812 # 80009138 <etext+0x138>
    80000a2c:	00006097          	auipc	ra,0x6
    80000a30:	0f2080e7          	jalr	242(ra) # 80006b1e <panic>
    }
  }
  kfree((void *)pagetable);
    80000a34:	8552                	mv	a0,s4
    80000a36:	fffff097          	auipc	ra,0xfffff
    80000a3a:	5e6080e7          	jalr	1510(ra) # 8000001c <kfree>
}
    80000a3e:	70a2                	ld	ra,40(sp)
    80000a40:	7402                	ld	s0,32(sp)
    80000a42:	64e2                	ld	s1,24(sp)
    80000a44:	6942                	ld	s2,16(sp)
    80000a46:	69a2                	ld	s3,8(sp)
    80000a48:	6a02                	ld	s4,0(sp)
    80000a4a:	6145                	addi	sp,sp,48
    80000a4c:	8082                	ret

0000000080000a4e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000a4e:	1101                	addi	sp,sp,-32
    80000a50:	ec06                	sd	ra,24(sp)
    80000a52:	e822                	sd	s0,16(sp)
    80000a54:	e426                	sd	s1,8(sp)
    80000a56:	1000                	addi	s0,sp,32
    80000a58:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a5a:	e999                	bnez	a1,80000a70 <uvmfree+0x22>
  freewalk(pagetable);
    80000a5c:	8526                	mv	a0,s1
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	f84080e7          	jalr	-124(ra) # 800009e2 <freewalk>
}
    80000a66:	60e2                	ld	ra,24(sp)
    80000a68:	6442                	ld	s0,16(sp)
    80000a6a:	64a2                	ld	s1,8(sp)
    80000a6c:	6105                	addi	sp,sp,32
    80000a6e:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a70:	6785                	lui	a5,0x1
    80000a72:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	95be                	add	a1,a1,a5
    80000a76:	4685                	li	a3,1
    80000a78:	00c5d613          	srli	a2,a1,0xc
    80000a7c:	4581                	li	a1,0
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	cea080e7          	jalr	-790(ra) # 80000768 <uvmunmap>
    80000a86:	bfd9                	j	80000a5c <uvmfree+0xe>

0000000080000a88 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000a88:	c679                	beqz	a2,80000b56 <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000a8a:	715d                	addi	sp,sp,-80
    80000a8c:	e486                	sd	ra,72(sp)
    80000a8e:	e0a2                	sd	s0,64(sp)
    80000a90:	fc26                	sd	s1,56(sp)
    80000a92:	f84a                	sd	s2,48(sp)
    80000a94:	f44e                	sd	s3,40(sp)
    80000a96:	f052                	sd	s4,32(sp)
    80000a98:	ec56                	sd	s5,24(sp)
    80000a9a:	e85a                	sd	s6,16(sp)
    80000a9c:	e45e                	sd	s7,8(sp)
    80000a9e:	0880                	addi	s0,sp,80
    80000aa0:	8b2a                	mv	s6,a0
    80000aa2:	8aae                	mv	s5,a1
    80000aa4:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000aa6:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000aa8:	4601                	li	a2,0
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	855a                	mv	a0,s6
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	9b8080e7          	jalr	-1608(ra) # 80000466 <walk>
    80000ab6:	c531                	beqz	a0,80000b02 <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000ab8:	6118                	ld	a4,0(a0)
    80000aba:	00177793          	andi	a5,a4,1
    80000abe:	cbb1                	beqz	a5,80000b12 <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000ac0:	00a75593          	srli	a1,a4,0xa
    80000ac4:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ac8:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000acc:	fffff097          	auipc	ra,0xfffff
    80000ad0:	64e080e7          	jalr	1614(ra) # 8000011a <kalloc>
    80000ad4:	892a                	mv	s2,a0
    80000ad6:	c939                	beqz	a0,80000b2c <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000ad8:	6605                	lui	a2,0x1
    80000ada:	85de                	mv	a1,s7
    80000adc:	fffff097          	auipc	ra,0xfffff
    80000ae0:	6fa080e7          	jalr	1786(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000ae4:	8726                	mv	a4,s1
    80000ae6:	86ca                	mv	a3,s2
    80000ae8:	6605                	lui	a2,0x1
    80000aea:	85ce                	mv	a1,s3
    80000aec:	8556                	mv	a0,s5
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	a60080e7          	jalr	-1440(ra) # 8000054e <mappages>
    80000af6:	e515                	bnez	a0,80000b22 <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    80000af8:	6785                	lui	a5,0x1
    80000afa:	99be                	add	s3,s3,a5
    80000afc:	fb49e6e3          	bltu	s3,s4,80000aa8 <uvmcopy+0x20>
    80000b00:	a081                	j	80000b40 <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000b02:	00008517          	auipc	a0,0x8
    80000b06:	64650513          	addi	a0,a0,1606 # 80009148 <etext+0x148>
    80000b0a:	00006097          	auipc	ra,0x6
    80000b0e:	014080e7          	jalr	20(ra) # 80006b1e <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000b12:	00008517          	auipc	a0,0x8
    80000b16:	65650513          	addi	a0,a0,1622 # 80009168 <etext+0x168>
    80000b1a:	00006097          	auipc	ra,0x6
    80000b1e:	004080e7          	jalr	4(ra) # 80006b1e <panic>
      kfree(mem);
    80000b22:	854a                	mv	a0,s2
    80000b24:	fffff097          	auipc	ra,0xfffff
    80000b28:	4f8080e7          	jalr	1272(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b2c:	4685                	li	a3,1
    80000b2e:	00c9d613          	srli	a2,s3,0xc
    80000b32:	4581                	li	a1,0
    80000b34:	8556                	mv	a0,s5
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	c32080e7          	jalr	-974(ra) # 80000768 <uvmunmap>
  return -1;
    80000b3e:	557d                	li	a0,-1
}
    80000b40:	60a6                	ld	ra,72(sp)
    80000b42:	6406                	ld	s0,64(sp)
    80000b44:	74e2                	ld	s1,56(sp)
    80000b46:	7942                	ld	s2,48(sp)
    80000b48:	79a2                	ld	s3,40(sp)
    80000b4a:	7a02                	ld	s4,32(sp)
    80000b4c:	6ae2                	ld	s5,24(sp)
    80000b4e:	6b42                	ld	s6,16(sp)
    80000b50:	6ba2                	ld	s7,8(sp)
    80000b52:	6161                	addi	sp,sp,80
    80000b54:	8082                	ret
  return 0;
    80000b56:	4501                	li	a0,0
}
    80000b58:	8082                	ret

0000000080000b5a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000b5a:	1141                	addi	sp,sp,-16
    80000b5c:	e406                	sd	ra,8(sp)
    80000b5e:	e022                	sd	s0,0(sp)
    80000b60:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b62:	4601                	li	a2,0
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	902080e7          	jalr	-1790(ra) # 80000466 <walk>
  if (pte == 0) panic("uvmclear");
    80000b6c:	c901                	beqz	a0,80000b7c <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000b6e:	611c                	ld	a5,0(a0)
    80000b70:	9bbd                	andi	a5,a5,-17
    80000b72:	e11c                	sd	a5,0(a0)
}
    80000b74:	60a2                	ld	ra,8(sp)
    80000b76:	6402                	ld	s0,0(sp)
    80000b78:	0141                	addi	sp,sp,16
    80000b7a:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000b7c:	00008517          	auipc	a0,0x8
    80000b80:	60c50513          	addi	a0,a0,1548 # 80009188 <etext+0x188>
    80000b84:	00006097          	auipc	ra,0x6
    80000b88:	f9a080e7          	jalr	-102(ra) # 80006b1e <panic>

0000000080000b8c <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0) {
    80000b8c:	ced1                	beqz	a3,80000c28 <copyout+0x9c>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000b8e:	711d                	addi	sp,sp,-96
    80000b90:	ec86                	sd	ra,88(sp)
    80000b92:	e8a2                	sd	s0,80(sp)
    80000b94:	e4a6                	sd	s1,72(sp)
    80000b96:	fc4e                	sd	s3,56(sp)
    80000b98:	f456                	sd	s5,40(sp)
    80000b9a:	f05a                	sd	s6,32(sp)
    80000b9c:	ec5e                	sd	s7,24(sp)
    80000b9e:	1080                	addi	s0,sp,96
    80000ba0:	8baa                	mv	s7,a0
    80000ba2:	8aae                	mv	s5,a1
    80000ba4:	8b32                	mv	s6,a2
    80000ba6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000ba8:	74fd                	lui	s1,0xfffff
    80000baa:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000bac:	57fd                	li	a5,-1
    80000bae:	83e9                	srli	a5,a5,0x1a
    80000bb0:	0697ee63          	bltu	a5,s1,80000c2c <copyout+0xa0>
    80000bb4:	e0ca                	sd	s2,64(sp)
    80000bb6:	f852                	sd	s4,48(sp)
    80000bb8:	e862                	sd	s8,16(sp)
    80000bba:	e466                	sd	s9,8(sp)
    80000bbc:	e06a                	sd	s10,0(sp)
    pte = walk(pagetable, va0, 0);
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	4cd5                	li	s9,21
    80000bc0:	6d05                	lui	s10,0x1
    if (va0 >= MAXVA) return -1;
    80000bc2:	8c3e                	mv	s8,a5
    80000bc4:	a035                	j	80000bf0 <copyout+0x64>
        (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000bc6:	83a9                	srli	a5,a5,0xa
    80000bc8:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bca:	409a8533          	sub	a0,s5,s1
    80000bce:	0009061b          	sext.w	a2,s2
    80000bd2:	85da                	mv	a1,s6
    80000bd4:	953e                	add	a0,a0,a5
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	412989b3          	sub	s3,s3,s2
    src += n;
    80000be2:	9b4a                	add	s6,s6,s2
  while (len > 0) {
    80000be4:	02098b63          	beqz	s3,80000c1a <copyout+0x8e>
    if (va0 >= MAXVA) return -1;
    80000be8:	054c6463          	bltu	s8,s4,80000c30 <copyout+0xa4>
    80000bec:	84d2                	mv	s1,s4
    80000bee:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bf0:	4601                	li	a2,0
    80000bf2:	85a6                	mv	a1,s1
    80000bf4:	855e                	mv	a0,s7
    80000bf6:	00000097          	auipc	ra,0x0
    80000bfa:	870080e7          	jalr	-1936(ra) # 80000466 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bfe:	c121                	beqz	a0,80000c3e <copyout+0xb2>
    80000c00:	611c                	ld	a5,0(a0)
    80000c02:	0157f713          	andi	a4,a5,21
    80000c06:	05971b63          	bne	a4,s9,80000c5c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000c0a:	01a48a33          	add	s4,s1,s10
    80000c0e:	415a0933          	sub	s2,s4,s5
    if (n > len) n = len;
    80000c12:	fb29fae3          	bgeu	s3,s2,80000bc6 <copyout+0x3a>
    80000c16:	894e                	mv	s2,s3
    80000c18:	b77d                	j	80000bc6 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000c1a:	4501                	li	a0,0
    80000c1c:	6906                	ld	s2,64(sp)
    80000c1e:	7a42                	ld	s4,48(sp)
    80000c20:	6c42                	ld	s8,16(sp)
    80000c22:	6ca2                	ld	s9,8(sp)
    80000c24:	6d02                	ld	s10,0(sp)
    80000c26:	a015                	j	80000c4a <copyout+0xbe>
    80000c28:	4501                	li	a0,0
}
    80000c2a:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000c2c:	557d                	li	a0,-1
    80000c2e:	a831                	j	80000c4a <copyout+0xbe>
    80000c30:	557d                	li	a0,-1
    80000c32:	6906                	ld	s2,64(sp)
    80000c34:	7a42                	ld	s4,48(sp)
    80000c36:	6c42                	ld	s8,16(sp)
    80000c38:	6ca2                	ld	s9,8(sp)
    80000c3a:	6d02                	ld	s10,0(sp)
    80000c3c:	a039                	j	80000c4a <copyout+0xbe>
      return -1;
    80000c3e:	557d                	li	a0,-1
    80000c40:	6906                	ld	s2,64(sp)
    80000c42:	7a42                	ld	s4,48(sp)
    80000c44:	6c42                	ld	s8,16(sp)
    80000c46:	6ca2                	ld	s9,8(sp)
    80000c48:	6d02                	ld	s10,0(sp)
}
    80000c4a:	60e6                	ld	ra,88(sp)
    80000c4c:	6446                	ld	s0,80(sp)
    80000c4e:	64a6                	ld	s1,72(sp)
    80000c50:	79e2                	ld	s3,56(sp)
    80000c52:	7aa2                	ld	s5,40(sp)
    80000c54:	7b02                	ld	s6,32(sp)
    80000c56:	6be2                	ld	s7,24(sp)
    80000c58:	6125                	addi	sp,sp,96
    80000c5a:	8082                	ret
      return -1;
    80000c5c:	557d                	li	a0,-1
    80000c5e:	6906                	ld	s2,64(sp)
    80000c60:	7a42                	ld	s4,48(sp)
    80000c62:	6c42                	ld	s8,16(sp)
    80000c64:	6ca2                	ld	s9,8(sp)
    80000c66:	6d02                	ld	s10,0(sp)
    80000c68:	b7cd                	j	80000c4a <copyout+0xbe>

0000000080000c6a <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000c6a:	caa5                	beqz	a3,80000cda <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000c6c:	715d                	addi	sp,sp,-80
    80000c6e:	e486                	sd	ra,72(sp)
    80000c70:	e0a2                	sd	s0,64(sp)
    80000c72:	fc26                	sd	s1,56(sp)
    80000c74:	f84a                	sd	s2,48(sp)
    80000c76:	f44e                	sd	s3,40(sp)
    80000c78:	f052                	sd	s4,32(sp)
    80000c7a:	ec56                	sd	s5,24(sp)
    80000c7c:	e85a                	sd	s6,16(sp)
    80000c7e:	e45e                	sd	s7,8(sp)
    80000c80:	e062                	sd	s8,0(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8b2a                	mv	s6,a0
    80000c86:	8a2e                	mv	s4,a1
    80000c88:	8c32                	mv	s8,a2
    80000c8a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6a85                	lui	s5,0x1
    80000c90:	a01d                	j	80000cb6 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c92:	018505b3          	add	a1,a0,s8
    80000c96:	0004861b          	sext.w	a2,s1
    80000c9a:	412585b3          	sub	a1,a1,s2
    80000c9e:	8552                	mv	a0,s4
    80000ca0:	fffff097          	auipc	ra,0xfffff
    80000ca4:	536080e7          	jalr	1334(ra) # 800001d6 <memmove>

    len -= n;
    80000ca8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cac:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cae:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000cb2:	02098263          	beqz	s3,80000cd6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cb6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cba:	85ca                	mv	a1,s2
    80000cbc:	855a                	mv	a0,s6
    80000cbe:	00000097          	auipc	ra,0x0
    80000cc2:	84e080e7          	jalr	-1970(ra) # 8000050c <walkaddr>
    if (pa0 == 0) return -1;
    80000cc6:	cd01                	beqz	a0,80000cde <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cc8:	418904b3          	sub	s1,s2,s8
    80000ccc:	94d6                	add	s1,s1,s5
    if (n > len) n = len;
    80000cce:	fc99f2e3          	bgeu	s3,s1,80000c92 <copyin+0x28>
    80000cd2:	84ce                	mv	s1,s3
    80000cd4:	bf7d                	j	80000c92 <copyin+0x28>
  }
  return 0;
    80000cd6:	4501                	li	a0,0
    80000cd8:	a021                	j	80000ce0 <copyin+0x76>
    80000cda:	4501                	li	a0,0
}
    80000cdc:	8082                	ret
    if (pa0 == 0) return -1;
    80000cde:	557d                	li	a0,-1
}
    80000ce0:	60a6                	ld	ra,72(sp)
    80000ce2:	6406                	ld	s0,64(sp)
    80000ce4:	74e2                	ld	s1,56(sp)
    80000ce6:	7942                	ld	s2,48(sp)
    80000ce8:	79a2                	ld	s3,40(sp)
    80000cea:	7a02                	ld	s4,32(sp)
    80000cec:	6ae2                	ld	s5,24(sp)
    80000cee:	6b42                	ld	s6,16(sp)
    80000cf0:	6ba2                	ld	s7,8(sp)
    80000cf2:	6c02                	ld	s8,0(sp)
    80000cf4:	6161                	addi	sp,sp,80
    80000cf6:	8082                	ret

0000000080000cf8 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000cf8:	cacd                	beqz	a3,80000daa <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000cfa:	715d                	addi	sp,sp,-80
    80000cfc:	e486                	sd	ra,72(sp)
    80000cfe:	e0a2                	sd	s0,64(sp)
    80000d00:	fc26                	sd	s1,56(sp)
    80000d02:	f84a                	sd	s2,48(sp)
    80000d04:	f44e                	sd	s3,40(sp)
    80000d06:	f052                	sd	s4,32(sp)
    80000d08:	ec56                	sd	s5,24(sp)
    80000d0a:	e85a                	sd	s6,16(sp)
    80000d0c:	e45e                	sd	s7,8(sp)
    80000d0e:	0880                	addi	s0,sp,80
    80000d10:	8a2a                	mv	s4,a0
    80000d12:	8b2e                	mv	s6,a1
    80000d14:	8bb2                	mv	s7,a2
    80000d16:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d18:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000d1a:	6985                	lui	s3,0x1
    80000d1c:	a825                	j	80000d54 <copyinstr+0x5c>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000d1e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d22:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000d24:	37fd                	addiw	a5,a5,-1
    80000d26:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d2a:	60a6                	ld	ra,72(sp)
    80000d2c:	6406                	ld	s0,64(sp)
    80000d2e:	74e2                	ld	s1,56(sp)
    80000d30:	7942                	ld	s2,48(sp)
    80000d32:	79a2                	ld	s3,40(sp)
    80000d34:	7a02                	ld	s4,32(sp)
    80000d36:	6ae2                	ld	s5,24(sp)
    80000d38:	6b42                	ld	s6,16(sp)
    80000d3a:	6ba2                	ld	s7,8(sp)
    80000d3c:	6161                	addi	sp,sp,80
    80000d3e:	8082                	ret
    80000d40:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d44:	9742                	add	a4,a4,a6
      --max;
    80000d46:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d4a:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0) {
    80000d4e:	04e58663          	beq	a1,a4,80000d9a <copyinstr+0xa2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000d52:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d54:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d58:	85a6                	mv	a1,s1
    80000d5a:	8552                	mv	a0,s4
    80000d5c:	fffff097          	auipc	ra,0xfffff
    80000d60:	7b0080e7          	jalr	1968(ra) # 8000050c <walkaddr>
    if (pa0 == 0) return -1;
    80000d64:	cd0d                	beqz	a0,80000d9e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d66:	417486b3          	sub	a3,s1,s7
    80000d6a:	96ce                	add	a3,a3,s3
    if (n > max) n = max;
    80000d6c:	00d97363          	bgeu	s2,a3,80000d72 <copyinstr+0x7a>
    80000d70:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80000d72:	955e                	add	a0,a0,s7
    80000d74:	8d05                	sub	a0,a0,s1
    while (n > 0) {
    80000d76:	c695                	beqz	a3,80000da2 <copyinstr+0xaa>
    80000d78:	87da                	mv	a5,s6
    80000d7a:	885a                	mv	a6,s6
      if (*p == '\0') {
    80000d7c:	41650633          	sub	a2,a0,s6
    while (n > 0) {
    80000d80:	96da                	add	a3,a3,s6
    80000d82:	85be                	mv	a1,a5
      if (*p == '\0') {
    80000d84:	00f60733          	add	a4,a2,a5
    80000d88:	00074703          	lbu	a4,0(a4)
    80000d8c:	db49                	beqz	a4,80000d1e <copyinstr+0x26>
        *dst = *p;
    80000d8e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d92:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000d94:	fed797e3          	bne	a5,a3,80000d82 <copyinstr+0x8a>
    80000d98:	b765                	j	80000d40 <copyinstr+0x48>
    80000d9a:	4781                	li	a5,0
    80000d9c:	b761                	j	80000d24 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000d9e:	557d                	li	a0,-1
    80000da0:	b769                	j	80000d2a <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000da2:	6b85                	lui	s7,0x1
    80000da4:	9ba6                	add	s7,s7,s1
    80000da6:	87da                	mv	a5,s6
    80000da8:	b76d                	j	80000d52 <copyinstr+0x5a>
  int got_null = 0;
    80000daa:	4781                	li	a5,0
  if (got_null) {
    80000dac:	37fd                	addiw	a5,a5,-1
    80000dae:	0007851b          	sext.w	a0,a5
}
    80000db2:	8082                	ret

0000000080000db4 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000db4:	7139                	addi	sp,sp,-64
    80000db6:	fc06                	sd	ra,56(sp)
    80000db8:	f822                	sd	s0,48(sp)
    80000dba:	f426                	sd	s1,40(sp)
    80000dbc:	f04a                	sd	s2,32(sp)
    80000dbe:	ec4e                	sd	s3,24(sp)
    80000dc0:	e852                	sd	s4,16(sp)
    80000dc2:	e456                	sd	s5,8(sp)
    80000dc4:	e05a                	sd	s6,0(sp)
    80000dc6:	0080                	addi	s0,sp,64
    80000dc8:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000dca:	0000c497          	auipc	s1,0xc
    80000dce:	ca648493          	addi	s1,s1,-858 # 8000ca70 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000dd2:	8b26                	mv	s6,s1
    80000dd4:	04fa5937          	lui	s2,0x4fa5
    80000dd8:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000ddc:	0932                	slli	s2,s2,0xc
    80000dde:	fa590913          	addi	s2,s2,-91
    80000de2:	0932                	slli	s2,s2,0xc
    80000de4:	fa590913          	addi	s2,s2,-91
    80000de8:	0932                	slli	s2,s2,0xc
    80000dea:	fa590913          	addi	s2,s2,-91
    80000dee:	040009b7          	lui	s3,0x4000
    80000df2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000df4:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000df6:	00011a97          	auipc	s5,0x11
    80000dfa:	67aa8a93          	addi	s5,s5,1658 # 80012470 <tickslock>
    char *pa = kalloc();
    80000dfe:	fffff097          	auipc	ra,0xfffff
    80000e02:	31c080e7          	jalr	796(ra) # 8000011a <kalloc>
    80000e06:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000e08:	c121                	beqz	a0,80000e48 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80000e0a:	416485b3          	sub	a1,s1,s6
    80000e0e:	858d                	srai	a1,a1,0x3
    80000e10:	032585b3          	mul	a1,a1,s2
    80000e14:	2585                	addiw	a1,a1,1
    80000e16:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e1a:	4719                	li	a4,6
    80000e1c:	6685                	lui	a3,0x1
    80000e1e:	40b985b3          	sub	a1,s3,a1
    80000e22:	8552                	mv	a0,s4
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	7ee080e7          	jalr	2030(ra) # 80000612 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e2c:	16848493          	addi	s1,s1,360
    80000e30:	fd5497e3          	bne	s1,s5,80000dfe <proc_mapstacks+0x4a>
  }
}
    80000e34:	70e2                	ld	ra,56(sp)
    80000e36:	7442                	ld	s0,48(sp)
    80000e38:	74a2                	ld	s1,40(sp)
    80000e3a:	7902                	ld	s2,32(sp)
    80000e3c:	69e2                	ld	s3,24(sp)
    80000e3e:	6a42                	ld	s4,16(sp)
    80000e40:	6aa2                	ld	s5,8(sp)
    80000e42:	6b02                	ld	s6,0(sp)
    80000e44:	6121                	addi	sp,sp,64
    80000e46:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000e48:	00008517          	auipc	a0,0x8
    80000e4c:	35050513          	addi	a0,a0,848 # 80009198 <etext+0x198>
    80000e50:	00006097          	auipc	ra,0x6
    80000e54:	cce080e7          	jalr	-818(ra) # 80006b1e <panic>

0000000080000e58 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000e58:	7139                	addi	sp,sp,-64
    80000e5a:	fc06                	sd	ra,56(sp)
    80000e5c:	f822                	sd	s0,48(sp)
    80000e5e:	f426                	sd	s1,40(sp)
    80000e60:	f04a                	sd	s2,32(sp)
    80000e62:	ec4e                	sd	s3,24(sp)
    80000e64:	e852                	sd	s4,16(sp)
    80000e66:	e456                	sd	s5,8(sp)
    80000e68:	e05a                	sd	s6,0(sp)
    80000e6a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000e6c:	00008597          	auipc	a1,0x8
    80000e70:	33458593          	addi	a1,a1,820 # 800091a0 <etext+0x1a0>
    80000e74:	0000b517          	auipc	a0,0xb
    80000e78:	7cc50513          	addi	a0,a0,1996 # 8000c640 <pid_lock>
    80000e7c:	00006097          	auipc	ra,0x6
    80000e80:	18c080e7          	jalr	396(ra) # 80007008 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e84:	00008597          	auipc	a1,0x8
    80000e88:	32458593          	addi	a1,a1,804 # 800091a8 <etext+0x1a8>
    80000e8c:	0000b517          	auipc	a0,0xb
    80000e90:	7cc50513          	addi	a0,a0,1996 # 8000c658 <wait_lock>
    80000e94:	00006097          	auipc	ra,0x6
    80000e98:	174080e7          	jalr	372(ra) # 80007008 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e9c:	0000c497          	auipc	s1,0xc
    80000ea0:	bd448493          	addi	s1,s1,-1068 # 8000ca70 <proc>
    initlock(&p->lock, "proc");
    80000ea4:	00008b17          	auipc	s6,0x8
    80000ea8:	314b0b13          	addi	s6,s6,788 # 800091b8 <etext+0x1b8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000eac:	8aa6                	mv	s5,s1
    80000eae:	04fa5937          	lui	s2,0x4fa5
    80000eb2:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000eb6:	0932                	slli	s2,s2,0xc
    80000eb8:	fa590913          	addi	s2,s2,-91
    80000ebc:	0932                	slli	s2,s2,0xc
    80000ebe:	fa590913          	addi	s2,s2,-91
    80000ec2:	0932                	slli	s2,s2,0xc
    80000ec4:	fa590913          	addi	s2,s2,-91
    80000ec8:	040009b7          	lui	s3,0x4000
    80000ecc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ece:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	00011a17          	auipc	s4,0x11
    80000ed4:	5a0a0a13          	addi	s4,s4,1440 # 80012470 <tickslock>
    initlock(&p->lock, "proc");
    80000ed8:	85da                	mv	a1,s6
    80000eda:	8526                	mv	a0,s1
    80000edc:	00006097          	auipc	ra,0x6
    80000ee0:	12c080e7          	jalr	300(ra) # 80007008 <initlock>
    p->state = UNUSED;
    80000ee4:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000ee8:	415487b3          	sub	a5,s1,s5
    80000eec:	878d                	srai	a5,a5,0x3
    80000eee:	032787b3          	mul	a5,a5,s2
    80000ef2:	2785                	addiw	a5,a5,1
    80000ef4:	00d7979b          	slliw	a5,a5,0xd
    80000ef8:	40f987b3          	sub	a5,s3,a5
    80000efc:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000efe:	16848493          	addi	s1,s1,360
    80000f02:	fd449be3          	bne	s1,s4,80000ed8 <procinit+0x80>
  }
}
    80000f06:	70e2                	ld	ra,56(sp)
    80000f08:	7442                	ld	s0,48(sp)
    80000f0a:	74a2                	ld	s1,40(sp)
    80000f0c:	7902                	ld	s2,32(sp)
    80000f0e:	69e2                	ld	s3,24(sp)
    80000f10:	6a42                	ld	s4,16(sp)
    80000f12:	6aa2                	ld	s5,8(sp)
    80000f14:	6b02                	ld	s6,0(sp)
    80000f16:	6121                	addi	sp,sp,64
    80000f18:	8082                	ret

0000000080000f1a <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000f1a:	1141                	addi	sp,sp,-16
    80000f1c:	e422                	sd	s0,8(sp)
    80000f1e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000f20:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f22:	2501                	sext.w	a0,a0
    80000f24:	6422                	ld	s0,8(sp)
    80000f26:	0141                	addi	sp,sp,16
    80000f28:	8082                	ret

0000000080000f2a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000f2a:	1141                	addi	sp,sp,-16
    80000f2c:	e422                	sd	s0,8(sp)
    80000f2e:	0800                	addi	s0,sp,16
    80000f30:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f32:	2781                	sext.w	a5,a5
    80000f34:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f36:	0000b517          	auipc	a0,0xb
    80000f3a:	73a50513          	addi	a0,a0,1850 # 8000c670 <cpus>
    80000f3e:	953e                	add	a0,a0,a5
    80000f40:	6422                	ld	s0,8(sp)
    80000f42:	0141                	addi	sp,sp,16
    80000f44:	8082                	ret

0000000080000f46 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000f46:	1101                	addi	sp,sp,-32
    80000f48:	ec06                	sd	ra,24(sp)
    80000f4a:	e822                	sd	s0,16(sp)
    80000f4c:	e426                	sd	s1,8(sp)
    80000f4e:	1000                	addi	s0,sp,32
  push_off();
    80000f50:	00006097          	auipc	ra,0x6
    80000f54:	0fc080e7          	jalr	252(ra) # 8000704c <push_off>
    80000f58:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f5a:	2781                	sext.w	a5,a5
    80000f5c:	079e                	slli	a5,a5,0x7
    80000f5e:	0000b717          	auipc	a4,0xb
    80000f62:	6e270713          	addi	a4,a4,1762 # 8000c640 <pid_lock>
    80000f66:	97ba                	add	a5,a5,a4
    80000f68:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f6a:	00006097          	auipc	ra,0x6
    80000f6e:	182080e7          	jalr	386(ra) # 800070ec <pop_off>
  return p;
}
    80000f72:	8526                	mv	a0,s1
    80000f74:	60e2                	ld	ra,24(sp)
    80000f76:	6442                	ld	s0,16(sp)
    80000f78:	64a2                	ld	s1,8(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret

0000000080000f7e <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000f7e:	1141                	addi	sp,sp,-16
    80000f80:	e406                	sd	ra,8(sp)
    80000f82:	e022                	sd	s0,0(sp)
    80000f84:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	fc0080e7          	jalr	-64(ra) # 80000f46 <myproc>
    80000f8e:	00006097          	auipc	ra,0x6
    80000f92:	1be080e7          	jalr	446(ra) # 8000714c <release>

  if (first) {
    80000f96:	0000b797          	auipc	a5,0xb
    80000f9a:	5ba7a783          	lw	a5,1466(a5) # 8000c550 <first.1>
    80000f9e:	eb89                	bnez	a5,80000fb0 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000fa0:	00001097          	auipc	ra,0x1
    80000fa4:	c62080e7          	jalr	-926(ra) # 80001c02 <usertrapret>
}
    80000fa8:	60a2                	ld	ra,8(sp)
    80000faa:	6402                	ld	s0,0(sp)
    80000fac:	0141                	addi	sp,sp,16
    80000fae:	8082                	ret
    fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	9de080e7          	jalr	-1570(ra) # 80002990 <fsinit>
    first = 0;
    80000fba:	0000b797          	auipc	a5,0xb
    80000fbe:	5807ab23          	sw	zero,1430(a5) # 8000c550 <first.1>
    __sync_synchronize();
    80000fc2:	0330000f          	fence	rw,rw
    80000fc6:	bfe9                	j	80000fa0 <forkret+0x22>

0000000080000fc8 <allocpid>:
int allocpid() {
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	e04a                	sd	s2,0(sp)
    80000fd2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fd4:	0000b917          	auipc	s2,0xb
    80000fd8:	66c90913          	addi	s2,s2,1644 # 8000c640 <pid_lock>
    80000fdc:	854a                	mv	a0,s2
    80000fde:	00006097          	auipc	ra,0x6
    80000fe2:	0ba080e7          	jalr	186(ra) # 80007098 <acquire>
  pid = nextpid;
    80000fe6:	0000b797          	auipc	a5,0xb
    80000fea:	56e78793          	addi	a5,a5,1390 # 8000c554 <nextpid>
    80000fee:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ff0:	0014871b          	addiw	a4,s1,1
    80000ff4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ff6:	854a                	mv	a0,s2
    80000ff8:	00006097          	auipc	ra,0x6
    80000ffc:	154080e7          	jalr	340(ra) # 8000714c <release>
}
    80001000:	8526                	mv	a0,s1
    80001002:	60e2                	ld	ra,24(sp)
    80001004:	6442                	ld	s0,16(sp)
    80001006:	64a2                	ld	s1,8(sp)
    80001008:	6902                	ld	s2,0(sp)
    8000100a:	6105                	addi	sp,sp,32
    8000100c:	8082                	ret

000000008000100e <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    8000100e:	1101                	addi	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	e04a                	sd	s2,0(sp)
    80001018:	1000                	addi	s0,sp,32
    8000101a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	820080e7          	jalr	-2016(ra) # 8000083c <uvmcreate>
    80001024:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001026:	c121                	beqz	a0,80001066 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001028:	4729                	li	a4,10
    8000102a:	00007697          	auipc	a3,0x7
    8000102e:	fd668693          	addi	a3,a3,-42 # 80008000 <_trampoline>
    80001032:	6605                	lui	a2,0x1
    80001034:	040005b7          	lui	a1,0x4000
    80001038:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000103a:	05b2                	slli	a1,a1,0xc
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	512080e7          	jalr	1298(ra) # 8000054e <mappages>
    80001044:	02054863          	bltz	a0,80001074 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001048:	4719                	li	a4,6
    8000104a:	05893683          	ld	a3,88(s2)
    8000104e:	6605                	lui	a2,0x1
    80001050:	020005b7          	lui	a1,0x2000
    80001054:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001056:	05b6                	slli	a1,a1,0xd
    80001058:	8526                	mv	a0,s1
    8000105a:	fffff097          	auipc	ra,0xfffff
    8000105e:	4f4080e7          	jalr	1268(ra) # 8000054e <mappages>
    80001062:	02054163          	bltz	a0,80001084 <proc_pagetable+0x76>
}
    80001066:	8526                	mv	a0,s1
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6902                	ld	s2,0(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret
    uvmfree(pagetable, 0);
    80001074:	4581                	li	a1,0
    80001076:	8526                	mv	a0,s1
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	9d6080e7          	jalr	-1578(ra) # 80000a4e <uvmfree>
    return 0;
    80001080:	4481                	li	s1,0
    80001082:	b7d5                	j	80001066 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001084:	4681                	li	a3,0
    80001086:	4605                	li	a2,1
    80001088:	040005b7          	lui	a1,0x4000
    8000108c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000108e:	05b2                	slli	a1,a1,0xc
    80001090:	8526                	mv	a0,s1
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	6d6080e7          	jalr	1750(ra) # 80000768 <uvmunmap>
    uvmfree(pagetable, 0);
    8000109a:	4581                	li	a1,0
    8000109c:	8526                	mv	a0,s1
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	9b0080e7          	jalr	-1616(ra) # 80000a4e <uvmfree>
    return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	bf7d                	j	80001066 <proc_pagetable+0x58>

00000000800010aa <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    800010aa:	1101                	addi	sp,sp,-32
    800010ac:	ec06                	sd	ra,24(sp)
    800010ae:	e822                	sd	s0,16(sp)
    800010b0:	e426                	sd	s1,8(sp)
    800010b2:	e04a                	sd	s2,0(sp)
    800010b4:	1000                	addi	s0,sp,32
    800010b6:	84aa                	mv	s1,a0
    800010b8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ba:	4681                	li	a3,0
    800010bc:	4605                	li	a2,1
    800010be:	040005b7          	lui	a1,0x4000
    800010c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c4:	05b2                	slli	a1,a1,0xc
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	6a2080e7          	jalr	1698(ra) # 80000768 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010ce:	4681                	li	a3,0
    800010d0:	4605                	li	a2,1
    800010d2:	020005b7          	lui	a1,0x2000
    800010d6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010d8:	05b6                	slli	a1,a1,0xd
    800010da:	8526                	mv	a0,s1
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	68c080e7          	jalr	1676(ra) # 80000768 <uvmunmap>
  uvmfree(pagetable, sz);
    800010e4:	85ca                	mv	a1,s2
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	966080e7          	jalr	-1690(ra) # 80000a4e <uvmfree>
}
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret

00000000800010fc <freeproc>:
static void freeproc(struct proc *p) {
    800010fc:	1101                	addi	sp,sp,-32
    800010fe:	ec06                	sd	ra,24(sp)
    80001100:	e822                	sd	s0,16(sp)
    80001102:	e426                	sd	s1,8(sp)
    80001104:	1000                	addi	s0,sp,32
    80001106:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001108:	6d28                	ld	a0,88(a0)
    8000110a:	c509                	beqz	a0,80001114 <freeproc+0x18>
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	f10080e7          	jalr	-240(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001114:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001118:	68a8                	ld	a0,80(s1)
    8000111a:	c511                	beqz	a0,80001126 <freeproc+0x2a>
    8000111c:	64ac                	ld	a1,72(s1)
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	f8c080e7          	jalr	-116(ra) # 800010aa <proc_freepagetable>
  p->pagetable = 0;
    80001126:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000112a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000112e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001132:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001136:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000113a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000113e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001142:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001146:	0004ac23          	sw	zero,24(s1)
}
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6105                	addi	sp,sp,32
    80001152:	8082                	ret

0000000080001154 <allocproc>:
static struct proc *allocproc(void) {
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	e04a                	sd	s2,0(sp)
    8000115e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001160:	0000c497          	auipc	s1,0xc
    80001164:	91048493          	addi	s1,s1,-1776 # 8000ca70 <proc>
    80001168:	00011917          	auipc	s2,0x11
    8000116c:	30890913          	addi	s2,s2,776 # 80012470 <tickslock>
    acquire(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00006097          	auipc	ra,0x6
    80001176:	f26080e7          	jalr	-218(ra) # 80007098 <acquire>
    if (p->state == UNUSED) {
    8000117a:	4c9c                	lw	a5,24(s1)
    8000117c:	cf81                	beqz	a5,80001194 <allocproc+0x40>
      release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00006097          	auipc	ra,0x6
    80001184:	fcc080e7          	jalr	-52(ra) # 8000714c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001188:	16848493          	addi	s1,s1,360
    8000118c:	ff2492e3          	bne	s1,s2,80001170 <allocproc+0x1c>
  return 0;
    80001190:	4481                	li	s1,0
    80001192:	a889                	j	800011e4 <allocproc+0x90>
  p->pid = allocpid();
    80001194:	00000097          	auipc	ra,0x0
    80001198:	e34080e7          	jalr	-460(ra) # 80000fc8 <allocpid>
    8000119c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000119e:	4785                	li	a5,1
    800011a0:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	f78080e7          	jalr	-136(ra) # 8000011a <kalloc>
    800011aa:	892a                	mv	s2,a0
    800011ac:	eca8                	sd	a0,88(s1)
    800011ae:	c131                	beqz	a0,800011f2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	e5c080e7          	jalr	-420(ra) # 8000100e <proc_pagetable>
    800011ba:	892a                	mv	s2,a0
    800011bc:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800011be:	c531                	beqz	a0,8000120a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011c0:	07000613          	li	a2,112
    800011c4:	4581                	li	a1,0
    800011c6:	06048513          	addi	a0,s1,96
    800011ca:	fffff097          	auipc	ra,0xfffff
    800011ce:	fb0080e7          	jalr	-80(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800011d2:	00000797          	auipc	a5,0x0
    800011d6:	dac78793          	addi	a5,a5,-596 # 80000f7e <forkret>
    800011da:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011dc:	60bc                	ld	a5,64(s1)
    800011de:	6705                	lui	a4,0x1
    800011e0:	97ba                	add	a5,a5,a4
    800011e2:	f4bc                	sd	a5,104(s1)
}
    800011e4:	8526                	mv	a0,s1
    800011e6:	60e2                	ld	ra,24(sp)
    800011e8:	6442                	ld	s0,16(sp)
    800011ea:	64a2                	ld	s1,8(sp)
    800011ec:	6902                	ld	s2,0(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret
    freeproc(p);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	f08080e7          	jalr	-248(ra) # 800010fc <freeproc>
    release(&p->lock);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00006097          	auipc	ra,0x6
    80001202:	f4e080e7          	jalr	-178(ra) # 8000714c <release>
    return 0;
    80001206:	84ca                	mv	s1,s2
    80001208:	bff1                	j	800011e4 <allocproc+0x90>
    freeproc(p);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	ef0080e7          	jalr	-272(ra) # 800010fc <freeproc>
    release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00006097          	auipc	ra,0x6
    8000121a:	f36080e7          	jalr	-202(ra) # 8000714c <release>
    return 0;
    8000121e:	84ca                	mv	s1,s2
    80001220:	b7d1                	j	800011e4 <allocproc+0x90>

0000000080001222 <userinit>:
void userinit(void) {
    80001222:	1101                	addi	sp,sp,-32
    80001224:	ec06                	sd	ra,24(sp)
    80001226:	e822                	sd	s0,16(sp)
    80001228:	e426                	sd	s1,8(sp)
    8000122a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	f28080e7          	jalr	-216(ra) # 80001154 <allocproc>
    80001234:	84aa                	mv	s1,a0
  initproc = p;
    80001236:	0000b797          	auipc	a5,0xb
    8000123a:	3aa7b523          	sd	a0,938(a5) # 8000c5e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000123e:	03400613          	li	a2,52
    80001242:	0000b597          	auipc	a1,0xb
    80001246:	32e58593          	addi	a1,a1,814 # 8000c570 <initcode>
    8000124a:	6928                	ld	a0,80(a0)
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	61e080e7          	jalr	1566(ra) # 8000086a <uvmfirst>
  p->sz = PGSIZE;
    80001254:	6785                	lui	a5,0x1
    80001256:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001258:	6cb8                	ld	a4,88(s1)
    8000125a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000125e:	6cb8                	ld	a4,88(s1)
    80001260:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001262:	4641                	li	a2,16
    80001264:	00008597          	auipc	a1,0x8
    80001268:	f5c58593          	addi	a1,a1,-164 # 800091c0 <etext+0x1c0>
    8000126c:	15848513          	addi	a0,s1,344
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	04c080e7          	jalr	76(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001278:	00008517          	auipc	a0,0x8
    8000127c:	f5850513          	addi	a0,a0,-168 # 800091d0 <etext+0x1d0>
    80001280:	00002097          	auipc	ra,0x2
    80001284:	162080e7          	jalr	354(ra) # 800033e2 <namei>
    80001288:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000128c:	478d                	li	a5,3
    8000128e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00006097          	auipc	ra,0x6
    80001296:	eba080e7          	jalr	-326(ra) # 8000714c <release>
}
    8000129a:	60e2                	ld	ra,24(sp)
    8000129c:	6442                	ld	s0,16(sp)
    8000129e:	64a2                	ld	s1,8(sp)
    800012a0:	6105                	addi	sp,sp,32
    800012a2:	8082                	ret

00000000800012a4 <growproc>:
int growproc(int n) {
    800012a4:	1101                	addi	sp,sp,-32
    800012a6:	ec06                	sd	ra,24(sp)
    800012a8:	e822                	sd	s0,16(sp)
    800012aa:	e426                	sd	s1,8(sp)
    800012ac:	e04a                	sd	s2,0(sp)
    800012ae:	1000                	addi	s0,sp,32
    800012b0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	c94080e7          	jalr	-876(ra) # 80000f46 <myproc>
    800012ba:	84aa                	mv	s1,a0
  sz = p->sz;
    800012bc:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800012be:	01204c63          	bgtz	s2,800012d6 <growproc+0x32>
  } else if (n < 0) {
    800012c2:	02094663          	bltz	s2,800012ee <growproc+0x4a>
  p->sz = sz;
    800012c6:	e4ac                	sd	a1,72(s1)
  return 0;
    800012c8:	4501                	li	a0,0
}
    800012ca:	60e2                	ld	ra,24(sp)
    800012cc:	6442                	ld	s0,16(sp)
    800012ce:	64a2                	ld	s1,8(sp)
    800012d0:	6902                	ld	s2,0(sp)
    800012d2:	6105                	addi	sp,sp,32
    800012d4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012d6:	4691                	li	a3,4
    800012d8:	00b90633          	add	a2,s2,a1
    800012dc:	6928                	ld	a0,80(a0)
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	646080e7          	jalr	1606(ra) # 80000924 <uvmalloc>
    800012e6:	85aa                	mv	a1,a0
    800012e8:	fd79                	bnez	a0,800012c6 <growproc+0x22>
      return -1;
    800012ea:	557d                	li	a0,-1
    800012ec:	bff9                	j	800012ca <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ee:	00b90633          	add	a2,s2,a1
    800012f2:	6928                	ld	a0,80(a0)
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	5e8080e7          	jalr	1512(ra) # 800008dc <uvmdealloc>
    800012fc:	85aa                	mv	a1,a0
    800012fe:	b7e1                	j	800012c6 <growproc+0x22>

0000000080001300 <fork>:
int fork(void) {
    80001300:	7139                	addi	sp,sp,-64
    80001302:	fc06                	sd	ra,56(sp)
    80001304:	f822                	sd	s0,48(sp)
    80001306:	f04a                	sd	s2,32(sp)
    80001308:	e456                	sd	s5,8(sp)
    8000130a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	c3a080e7          	jalr	-966(ra) # 80000f46 <myproc>
    80001314:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	e3e080e7          	jalr	-450(ra) # 80001154 <allocproc>
    8000131e:	12050063          	beqz	a0,8000143e <fork+0x13e>
    80001322:	e852                	sd	s4,16(sp)
    80001324:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001326:	048ab603          	ld	a2,72(s5)
    8000132a:	692c                	ld	a1,80(a0)
    8000132c:	050ab503          	ld	a0,80(s5)
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	758080e7          	jalr	1880(ra) # 80000a88 <uvmcopy>
    80001338:	04054a63          	bltz	a0,8000138c <fork+0x8c>
    8000133c:	f426                	sd	s1,40(sp)
    8000133e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001340:	048ab783          	ld	a5,72(s5)
    80001344:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001348:	058ab683          	ld	a3,88(s5)
    8000134c:	87b6                	mv	a5,a3
    8000134e:	058a3703          	ld	a4,88(s4)
    80001352:	12068693          	addi	a3,a3,288
    80001356:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000135a:	6788                	ld	a0,8(a5)
    8000135c:	6b8c                	ld	a1,16(a5)
    8000135e:	6f90                	ld	a2,24(a5)
    80001360:	01073023          	sd	a6,0(a4)
    80001364:	e708                	sd	a0,8(a4)
    80001366:	eb0c                	sd	a1,16(a4)
    80001368:	ef10                	sd	a2,24(a4)
    8000136a:	02078793          	addi	a5,a5,32
    8000136e:	02070713          	addi	a4,a4,32
    80001372:	fed792e3          	bne	a5,a3,80001356 <fork+0x56>
  np->trapframe->a0 = 0;
    80001376:	058a3783          	ld	a5,88(s4)
    8000137a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000137e:	0d0a8493          	addi	s1,s5,208
    80001382:	0d0a0913          	addi	s2,s4,208
    80001386:	150a8993          	addi	s3,s5,336
    8000138a:	a015                	j	800013ae <fork+0xae>
    freeproc(np);
    8000138c:	8552                	mv	a0,s4
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	d6e080e7          	jalr	-658(ra) # 800010fc <freeproc>
    release(&np->lock);
    80001396:	8552                	mv	a0,s4
    80001398:	00006097          	auipc	ra,0x6
    8000139c:	db4080e7          	jalr	-588(ra) # 8000714c <release>
    return -1;
    800013a0:	597d                	li	s2,-1
    800013a2:	6a42                	ld	s4,16(sp)
    800013a4:	a071                	j	80001430 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    800013a6:	04a1                	addi	s1,s1,8
    800013a8:	0921                	addi	s2,s2,8
    800013aa:	01348b63          	beq	s1,s3,800013c0 <fork+0xc0>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    800013ae:	6088                	ld	a0,0(s1)
    800013b0:	d97d                	beqz	a0,800013a6 <fork+0xa6>
    800013b2:	00002097          	auipc	ra,0x2
    800013b6:	6a8080e7          	jalr	1704(ra) # 80003a5a <filedup>
    800013ba:	00a93023          	sd	a0,0(s2)
    800013be:	b7e5                	j	800013a6 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800013c0:	150ab503          	ld	a0,336(s5)
    800013c4:	00002097          	auipc	ra,0x2
    800013c8:	812080e7          	jalr	-2030(ra) # 80002bd6 <idup>
    800013cc:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013d0:	4641                	li	a2,16
    800013d2:	158a8593          	addi	a1,s5,344
    800013d6:	158a0513          	addi	a0,s4,344
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	ee2080e7          	jalr	-286(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800013e2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013e6:	8552                	mv	a0,s4
    800013e8:	00006097          	auipc	ra,0x6
    800013ec:	d64080e7          	jalr	-668(ra) # 8000714c <release>
  acquire(&wait_lock);
    800013f0:	0000b497          	auipc	s1,0xb
    800013f4:	26848493          	addi	s1,s1,616 # 8000c658 <wait_lock>
    800013f8:	8526                	mv	a0,s1
    800013fa:	00006097          	auipc	ra,0x6
    800013fe:	c9e080e7          	jalr	-866(ra) # 80007098 <acquire>
  np->parent = p;
    80001402:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00006097          	auipc	ra,0x6
    8000140c:	d44080e7          	jalr	-700(ra) # 8000714c <release>
  acquire(&np->lock);
    80001410:	8552                	mv	a0,s4
    80001412:	00006097          	auipc	ra,0x6
    80001416:	c86080e7          	jalr	-890(ra) # 80007098 <acquire>
  np->state = RUNNABLE;
    8000141a:	478d                	li	a5,3
    8000141c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001420:	8552                	mv	a0,s4
    80001422:	00006097          	auipc	ra,0x6
    80001426:	d2a080e7          	jalr	-726(ra) # 8000714c <release>
  return pid;
    8000142a:	74a2                	ld	s1,40(sp)
    8000142c:	69e2                	ld	s3,24(sp)
    8000142e:	6a42                	ld	s4,16(sp)
}
    80001430:	854a                	mv	a0,s2
    80001432:	70e2                	ld	ra,56(sp)
    80001434:	7442                	ld	s0,48(sp)
    80001436:	7902                	ld	s2,32(sp)
    80001438:	6aa2                	ld	s5,8(sp)
    8000143a:	6121                	addi	sp,sp,64
    8000143c:	8082                	ret
    return -1;
    8000143e:	597d                	li	s2,-1
    80001440:	bfc5                	j	80001430 <fork+0x130>

0000000080001442 <scheduler>:
void scheduler(void) {
    80001442:	7139                	addi	sp,sp,-64
    80001444:	fc06                	sd	ra,56(sp)
    80001446:	f822                	sd	s0,48(sp)
    80001448:	f426                	sd	s1,40(sp)
    8000144a:	f04a                	sd	s2,32(sp)
    8000144c:	ec4e                	sd	s3,24(sp)
    8000144e:	e852                	sd	s4,16(sp)
    80001450:	e456                	sd	s5,8(sp)
    80001452:	e05a                	sd	s6,0(sp)
    80001454:	0080                	addi	s0,sp,64
    80001456:	8792                	mv	a5,tp
  int id = r_tp();
    80001458:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000145a:	00779a93          	slli	s5,a5,0x7
    8000145e:	0000b717          	auipc	a4,0xb
    80001462:	1e270713          	addi	a4,a4,482 # 8000c640 <pid_lock>
    80001466:	9756                	add	a4,a4,s5
    80001468:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000146c:	0000b717          	auipc	a4,0xb
    80001470:	20c70713          	addi	a4,a4,524 # 8000c678 <cpus+0x8>
    80001474:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001476:	498d                	li	s3,3
        p->state = RUNNING;
    80001478:	4b11                	li	s6,4
        c->proc = p;
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	0000ba17          	auipc	s4,0xb
    80001480:	1c4a0a13          	addi	s4,s4,452 # 8000c640 <pid_lock>
    80001484:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80001486:	00011917          	auipc	s2,0x11
    8000148a:	fea90913          	addi	s2,s2,-22 # 80012470 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000148e:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001492:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001496:	10079073          	csrw	sstatus,a5
    8000149a:	0000b497          	auipc	s1,0xb
    8000149e:	5d648493          	addi	s1,s1,1494 # 8000ca70 <proc>
    800014a2:	a811                	j	800014b6 <scheduler+0x74>
      release(&p->lock);
    800014a4:	8526                	mv	a0,s1
    800014a6:	00006097          	auipc	ra,0x6
    800014aa:	ca6080e7          	jalr	-858(ra) # 8000714c <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800014ae:	16848493          	addi	s1,s1,360
    800014b2:	fd248ee3          	beq	s1,s2,8000148e <scheduler+0x4c>
      acquire(&p->lock);
    800014b6:	8526                	mv	a0,s1
    800014b8:	00006097          	auipc	ra,0x6
    800014bc:	be0080e7          	jalr	-1056(ra) # 80007098 <acquire>
      if (p->state == RUNNABLE) {
    800014c0:	4c9c                	lw	a5,24(s1)
    800014c2:	ff3791e3          	bne	a5,s3,800014a4 <scheduler+0x62>
        p->state = RUNNING;
    800014c6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014ca:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014ce:	06048593          	addi	a1,s1,96
    800014d2:	8556                	mv	a0,s5
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	684080e7          	jalr	1668(ra) # 80001b58 <swtch>
        c->proc = 0;
    800014dc:	020a3823          	sd	zero,48(s4)
    800014e0:	b7d1                	j	800014a4 <scheduler+0x62>

00000000800014e2 <sched>:
void sched(void) {
    800014e2:	7179                	addi	sp,sp,-48
    800014e4:	f406                	sd	ra,40(sp)
    800014e6:	f022                	sd	s0,32(sp)
    800014e8:	ec26                	sd	s1,24(sp)
    800014ea:	e84a                	sd	s2,16(sp)
    800014ec:	e44e                	sd	s3,8(sp)
    800014ee:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	a56080e7          	jalr	-1450(ra) # 80000f46 <myproc>
    800014f8:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    800014fa:	00006097          	auipc	ra,0x6
    800014fe:	b24080e7          	jalr	-1244(ra) # 8000701e <holding>
    80001502:	c93d                	beqz	a0,80001578 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001504:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    80001506:	2781                	sext.w	a5,a5
    80001508:	079e                	slli	a5,a5,0x7
    8000150a:	0000b717          	auipc	a4,0xb
    8000150e:	13670713          	addi	a4,a4,310 # 8000c640 <pid_lock>
    80001512:	97ba                	add	a5,a5,a4
    80001514:	0a87a703          	lw	a4,168(a5)
    80001518:	4785                	li	a5,1
    8000151a:	06f71763          	bne	a4,a5,80001588 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    8000151e:	4c98                	lw	a4,24(s1)
    80001520:	4791                	li	a5,4
    80001522:	06f70b63          	beq	a4,a5,80001598 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001526:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000152a:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    8000152c:	efb5                	bnez	a5,800015a8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000152e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001530:	0000b917          	auipc	s2,0xb
    80001534:	11090913          	addi	s2,s2,272 # 8000c640 <pid_lock>
    80001538:	2781                	sext.w	a5,a5
    8000153a:	079e                	slli	a5,a5,0x7
    8000153c:	97ca                	add	a5,a5,s2
    8000153e:	0ac7a983          	lw	s3,172(a5)
    80001542:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001544:	2781                	sext.w	a5,a5
    80001546:	079e                	slli	a5,a5,0x7
    80001548:	0000b597          	auipc	a1,0xb
    8000154c:	13058593          	addi	a1,a1,304 # 8000c678 <cpus+0x8>
    80001550:	95be                	add	a1,a1,a5
    80001552:	06048513          	addi	a0,s1,96
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	602080e7          	jalr	1538(ra) # 80001b58 <swtch>
    8000155e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001560:	2781                	sext.w	a5,a5
    80001562:	079e                	slli	a5,a5,0x7
    80001564:	993e                	add	s2,s2,a5
    80001566:	0b392623          	sw	s3,172(s2)
}
    8000156a:	70a2                	ld	ra,40(sp)
    8000156c:	7402                	ld	s0,32(sp)
    8000156e:	64e2                	ld	s1,24(sp)
    80001570:	6942                	ld	s2,16(sp)
    80001572:	69a2                	ld	s3,8(sp)
    80001574:	6145                	addi	sp,sp,48
    80001576:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001578:	00008517          	auipc	a0,0x8
    8000157c:	c6050513          	addi	a0,a0,-928 # 800091d8 <etext+0x1d8>
    80001580:	00005097          	auipc	ra,0x5
    80001584:	59e080e7          	jalr	1438(ra) # 80006b1e <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001588:	00008517          	auipc	a0,0x8
    8000158c:	c6050513          	addi	a0,a0,-928 # 800091e8 <etext+0x1e8>
    80001590:	00005097          	auipc	ra,0x5
    80001594:	58e080e7          	jalr	1422(ra) # 80006b1e <panic>
  if (p->state == RUNNING) panic("sched running");
    80001598:	00008517          	auipc	a0,0x8
    8000159c:	c6050513          	addi	a0,a0,-928 # 800091f8 <etext+0x1f8>
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	57e080e7          	jalr	1406(ra) # 80006b1e <panic>
  if (intr_get()) panic("sched interruptible");
    800015a8:	00008517          	auipc	a0,0x8
    800015ac:	c6050513          	addi	a0,a0,-928 # 80009208 <etext+0x208>
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	56e080e7          	jalr	1390(ra) # 80006b1e <panic>

00000000800015b8 <yield>:
void yield(void) {
    800015b8:	1101                	addi	sp,sp,-32
    800015ba:	ec06                	sd	ra,24(sp)
    800015bc:	e822                	sd	s0,16(sp)
    800015be:	e426                	sd	s1,8(sp)
    800015c0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	984080e7          	jalr	-1660(ra) # 80000f46 <myproc>
    800015ca:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015cc:	00006097          	auipc	ra,0x6
    800015d0:	acc080e7          	jalr	-1332(ra) # 80007098 <acquire>
  p->state = RUNNABLE;
    800015d4:	478d                	li	a5,3
    800015d6:	cc9c                	sw	a5,24(s1)
  sched();
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	f0a080e7          	jalr	-246(ra) # 800014e2 <sched>
  release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00006097          	auipc	ra,0x6
    800015e6:	b6a080e7          	jalr	-1174(ra) # 8000714c <release>
}
    800015ea:	60e2                	ld	ra,24(sp)
    800015ec:	6442                	ld	s0,16(sp)
    800015ee:	64a2                	ld	s1,8(sp)
    800015f0:	6105                	addi	sp,sp,32
    800015f2:	8082                	ret

00000000800015f4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800015f4:	7179                	addi	sp,sp,-48
    800015f6:	f406                	sd	ra,40(sp)
    800015f8:	f022                	sd	s0,32(sp)
    800015fa:	ec26                	sd	s1,24(sp)
    800015fc:	e84a                	sd	s2,16(sp)
    800015fe:	e44e                	sd	s3,8(sp)
    80001600:	1800                	addi	s0,sp,48
    80001602:	89aa                	mv	s3,a0
    80001604:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	940080e7          	jalr	-1728(ra) # 80000f46 <myproc>
    8000160e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    80001610:	00006097          	auipc	ra,0x6
    80001614:	a88080e7          	jalr	-1400(ra) # 80007098 <acquire>
  release(lk);
    80001618:	854a                	mv	a0,s2
    8000161a:	00006097          	auipc	ra,0x6
    8000161e:	b32080e7          	jalr	-1230(ra) # 8000714c <release>

  // Go to sleep.
  p->chan = chan;
    80001622:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001626:	4789                	li	a5,2
    80001628:	cc9c                	sw	a5,24(s1)

  sched();
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	eb8080e7          	jalr	-328(ra) # 800014e2 <sched>

  // Tidy up.
  p->chan = 0;
    80001632:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001636:	8526                	mv	a0,s1
    80001638:	00006097          	auipc	ra,0x6
    8000163c:	b14080e7          	jalr	-1260(ra) # 8000714c <release>
  acquire(lk);
    80001640:	854a                	mv	a0,s2
    80001642:	00006097          	auipc	ra,0x6
    80001646:	a56080e7          	jalr	-1450(ra) # 80007098 <acquire>
}
    8000164a:	70a2                	ld	ra,40(sp)
    8000164c:	7402                	ld	s0,32(sp)
    8000164e:	64e2                	ld	s1,24(sp)
    80001650:	6942                	ld	s2,16(sp)
    80001652:	69a2                	ld	s3,8(sp)
    80001654:	6145                	addi	sp,sp,48
    80001656:	8082                	ret

0000000080001658 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001658:	7139                	addi	sp,sp,-64
    8000165a:	fc06                	sd	ra,56(sp)
    8000165c:	f822                	sd	s0,48(sp)
    8000165e:	f426                	sd	s1,40(sp)
    80001660:	f04a                	sd	s2,32(sp)
    80001662:	ec4e                	sd	s3,24(sp)
    80001664:	e852                	sd	s4,16(sp)
    80001666:	e456                	sd	s5,8(sp)
    80001668:	0080                	addi	s0,sp,64
    8000166a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000166c:	0000b497          	auipc	s1,0xb
    80001670:	40448493          	addi	s1,s1,1028 # 8000ca70 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001674:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001676:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001678:	00011917          	auipc	s2,0x11
    8000167c:	df890913          	addi	s2,s2,-520 # 80012470 <tickslock>
    80001680:	a811                	j	80001694 <wakeup+0x3c>
      }
      release(&p->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00006097          	auipc	ra,0x6
    80001688:	ac8080e7          	jalr	-1336(ra) # 8000714c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000168c:	16848493          	addi	s1,s1,360
    80001690:	03248663          	beq	s1,s2,800016bc <wakeup+0x64>
    if (p != myproc()) {
    80001694:	00000097          	auipc	ra,0x0
    80001698:	8b2080e7          	jalr	-1870(ra) # 80000f46 <myproc>
    8000169c:	fea488e3          	beq	s1,a0,8000168c <wakeup+0x34>
      acquire(&p->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00006097          	auipc	ra,0x6
    800016a6:	9f6080e7          	jalr	-1546(ra) # 80007098 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800016aa:	4c9c                	lw	a5,24(s1)
    800016ac:	fd379be3          	bne	a5,s3,80001682 <wakeup+0x2a>
    800016b0:	709c                	ld	a5,32(s1)
    800016b2:	fd4798e3          	bne	a5,s4,80001682 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016b6:	0154ac23          	sw	s5,24(s1)
    800016ba:	b7e1                	j	80001682 <wakeup+0x2a>
    }
  }
}
    800016bc:	70e2                	ld	ra,56(sp)
    800016be:	7442                	ld	s0,48(sp)
    800016c0:	74a2                	ld	s1,40(sp)
    800016c2:	7902                	ld	s2,32(sp)
    800016c4:	69e2                	ld	s3,24(sp)
    800016c6:	6a42                	ld	s4,16(sp)
    800016c8:	6aa2                	ld	s5,8(sp)
    800016ca:	6121                	addi	sp,sp,64
    800016cc:	8082                	ret

00000000800016ce <reparent>:
void reparent(struct proc *p) {
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800016e0:	0000b497          	auipc	s1,0xb
    800016e4:	39048493          	addi	s1,s1,912 # 8000ca70 <proc>
      pp->parent = initproc;
    800016e8:	0000ba17          	auipc	s4,0xb
    800016ec:	ef8a0a13          	addi	s4,s4,-264 # 8000c5e0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800016f0:	00011997          	auipc	s3,0x11
    800016f4:	d8098993          	addi	s3,s3,-640 # 80012470 <tickslock>
    800016f8:	a029                	j	80001702 <reparent+0x34>
    800016fa:	16848493          	addi	s1,s1,360
    800016fe:	01348d63          	beq	s1,s3,80001718 <reparent+0x4a>
    if (pp->parent == p) {
    80001702:	7c9c                	ld	a5,56(s1)
    80001704:	ff279be3          	bne	a5,s2,800016fa <reparent+0x2c>
      pp->parent = initproc;
    80001708:	000a3503          	ld	a0,0(s4)
    8000170c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	f4a080e7          	jalr	-182(ra) # 80001658 <wakeup>
    80001716:	b7d5                	j	800016fa <reparent+0x2c>
}
    80001718:	70a2                	ld	ra,40(sp)
    8000171a:	7402                	ld	s0,32(sp)
    8000171c:	64e2                	ld	s1,24(sp)
    8000171e:	6942                	ld	s2,16(sp)
    80001720:	69a2                	ld	s3,8(sp)
    80001722:	6a02                	ld	s4,0(sp)
    80001724:	6145                	addi	sp,sp,48
    80001726:	8082                	ret

0000000080001728 <exit>:
void exit(int status) {
    80001728:	7179                	addi	sp,sp,-48
    8000172a:	f406                	sd	ra,40(sp)
    8000172c:	f022                	sd	s0,32(sp)
    8000172e:	ec26                	sd	s1,24(sp)
    80001730:	e84a                	sd	s2,16(sp)
    80001732:	e44e                	sd	s3,8(sp)
    80001734:	e052                	sd	s4,0(sp)
    80001736:	1800                	addi	s0,sp,48
    80001738:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	80c080e7          	jalr	-2036(ra) # 80000f46 <myproc>
    80001742:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001744:	0000b797          	auipc	a5,0xb
    80001748:	e9c7b783          	ld	a5,-356(a5) # 8000c5e0 <initproc>
    8000174c:	0d050493          	addi	s1,a0,208
    80001750:	15050913          	addi	s2,a0,336
    80001754:	02a79363          	bne	a5,a0,8000177a <exit+0x52>
    80001758:	00008517          	auipc	a0,0x8
    8000175c:	ac850513          	addi	a0,a0,-1336 # 80009220 <etext+0x220>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	3be080e7          	jalr	958(ra) # 80006b1e <panic>
      fileclose(f);
    80001768:	00002097          	auipc	ra,0x2
    8000176c:	344080e7          	jalr	836(ra) # 80003aac <fileclose>
      p->ofile[fd] = 0;
    80001770:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001774:	04a1                	addi	s1,s1,8
    80001776:	01248563          	beq	s1,s2,80001780 <exit+0x58>
    if (p->ofile[fd]) {
    8000177a:	6088                	ld	a0,0(s1)
    8000177c:	f575                	bnez	a0,80001768 <exit+0x40>
    8000177e:	bfdd                	j	80001774 <exit+0x4c>
  begin_op();
    80001780:	00002097          	auipc	ra,0x2
    80001784:	e62080e7          	jalr	-414(ra) # 800035e2 <begin_op>
  iput(p->cwd);
    80001788:	1509b503          	ld	a0,336(s3)
    8000178c:	00001097          	auipc	ra,0x1
    80001790:	646080e7          	jalr	1606(ra) # 80002dd2 <iput>
  end_op();
    80001794:	00002097          	auipc	ra,0x2
    80001798:	ec8080e7          	jalr	-312(ra) # 8000365c <end_op>
  p->cwd = 0;
    8000179c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017a0:	0000b497          	auipc	s1,0xb
    800017a4:	eb848493          	addi	s1,s1,-328 # 8000c658 <wait_lock>
    800017a8:	8526                	mv	a0,s1
    800017aa:	00006097          	auipc	ra,0x6
    800017ae:	8ee080e7          	jalr	-1810(ra) # 80007098 <acquire>
  reparent(p);
    800017b2:	854e                	mv	a0,s3
    800017b4:	00000097          	auipc	ra,0x0
    800017b8:	f1a080e7          	jalr	-230(ra) # 800016ce <reparent>
  wakeup(p->parent);
    800017bc:	0389b503          	ld	a0,56(s3)
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	e98080e7          	jalr	-360(ra) # 80001658 <wakeup>
  acquire(&p->lock);
    800017c8:	854e                	mv	a0,s3
    800017ca:	00006097          	auipc	ra,0x6
    800017ce:	8ce080e7          	jalr	-1842(ra) # 80007098 <acquire>
  p->xstate = status;
    800017d2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017d6:	4795                	li	a5,5
    800017d8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00006097          	auipc	ra,0x6
    800017e2:	96e080e7          	jalr	-1682(ra) # 8000714c <release>
  sched();
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	cfc080e7          	jalr	-772(ra) # 800014e2 <sched>
  panic("zombie exit");
    800017ee:	00008517          	auipc	a0,0x8
    800017f2:	a4250513          	addi	a0,a0,-1470 # 80009230 <etext+0x230>
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	328080e7          	jalr	808(ra) # 80006b1e <panic>

00000000800017fe <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800017fe:	7179                	addi	sp,sp,-48
    80001800:	f406                	sd	ra,40(sp)
    80001802:	f022                	sd	s0,32(sp)
    80001804:	ec26                	sd	s1,24(sp)
    80001806:	e84a                	sd	s2,16(sp)
    80001808:	e44e                	sd	s3,8(sp)
    8000180a:	1800                	addi	s0,sp,48
    8000180c:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000180e:	0000b497          	auipc	s1,0xb
    80001812:	26248493          	addi	s1,s1,610 # 8000ca70 <proc>
    80001816:	00011997          	auipc	s3,0x11
    8000181a:	c5a98993          	addi	s3,s3,-934 # 80012470 <tickslock>
    acquire(&p->lock);
    8000181e:	8526                	mv	a0,s1
    80001820:	00006097          	auipc	ra,0x6
    80001824:	878080e7          	jalr	-1928(ra) # 80007098 <acquire>
    if (p->pid == pid) {
    80001828:	589c                	lw	a5,48(s1)
    8000182a:	01278d63          	beq	a5,s2,80001844 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000182e:	8526                	mv	a0,s1
    80001830:	00006097          	auipc	ra,0x6
    80001834:	91c080e7          	jalr	-1764(ra) # 8000714c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001838:	16848493          	addi	s1,s1,360
    8000183c:	ff3491e3          	bne	s1,s3,8000181e <kill+0x20>
  }
  return -1;
    80001840:	557d                	li	a0,-1
    80001842:	a829                	j	8000185c <kill+0x5e>
      p->killed = 1;
    80001844:	4785                	li	a5,1
    80001846:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001848:	4c98                	lw	a4,24(s1)
    8000184a:	4789                	li	a5,2
    8000184c:	00f70f63          	beq	a4,a5,8000186a <kill+0x6c>
      release(&p->lock);
    80001850:	8526                	mv	a0,s1
    80001852:	00006097          	auipc	ra,0x6
    80001856:	8fa080e7          	jalr	-1798(ra) # 8000714c <release>
      return 0;
    8000185a:	4501                	li	a0,0
}
    8000185c:	70a2                	ld	ra,40(sp)
    8000185e:	7402                	ld	s0,32(sp)
    80001860:	64e2                	ld	s1,24(sp)
    80001862:	6942                	ld	s2,16(sp)
    80001864:	69a2                	ld	s3,8(sp)
    80001866:	6145                	addi	sp,sp,48
    80001868:	8082                	ret
        p->state = RUNNABLE;
    8000186a:	478d                	li	a5,3
    8000186c:	cc9c                	sw	a5,24(s1)
    8000186e:	b7cd                	j	80001850 <kill+0x52>

0000000080001870 <setkilled>:

void setkilled(struct proc *p) {
    80001870:	1101                	addi	sp,sp,-32
    80001872:	ec06                	sd	ra,24(sp)
    80001874:	e822                	sd	s0,16(sp)
    80001876:	e426                	sd	s1,8(sp)
    80001878:	1000                	addi	s0,sp,32
    8000187a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000187c:	00006097          	auipc	ra,0x6
    80001880:	81c080e7          	jalr	-2020(ra) # 80007098 <acquire>
  p->killed = 1;
    80001884:	4785                	li	a5,1
    80001886:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001888:	8526                	mv	a0,s1
    8000188a:	00006097          	auipc	ra,0x6
    8000188e:	8c2080e7          	jalr	-1854(ra) # 8000714c <release>
}
    80001892:	60e2                	ld	ra,24(sp)
    80001894:	6442                	ld	s0,16(sp)
    80001896:	64a2                	ld	s1,8(sp)
    80001898:	6105                	addi	sp,sp,32
    8000189a:	8082                	ret

000000008000189c <killed>:

int killed(struct proc *p) {
    8000189c:	1101                	addi	sp,sp,-32
    8000189e:	ec06                	sd	ra,24(sp)
    800018a0:	e822                	sd	s0,16(sp)
    800018a2:	e426                	sd	s1,8(sp)
    800018a4:	e04a                	sd	s2,0(sp)
    800018a6:	1000                	addi	s0,sp,32
    800018a8:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	7ee080e7          	jalr	2030(ra) # 80007098 <acquire>
  k = p->killed;
    800018b2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00006097          	auipc	ra,0x6
    800018bc:	894080e7          	jalr	-1900(ra) # 8000714c <release>
  return k;
}
    800018c0:	854a                	mv	a0,s2
    800018c2:	60e2                	ld	ra,24(sp)
    800018c4:	6442                	ld	s0,16(sp)
    800018c6:	64a2                	ld	s1,8(sp)
    800018c8:	6902                	ld	s2,0(sp)
    800018ca:	6105                	addi	sp,sp,32
    800018cc:	8082                	ret

00000000800018ce <wait>:
int wait(uint64 addr) {
    800018ce:	715d                	addi	sp,sp,-80
    800018d0:	e486                	sd	ra,72(sp)
    800018d2:	e0a2                	sd	s0,64(sp)
    800018d4:	fc26                	sd	s1,56(sp)
    800018d6:	f84a                	sd	s2,48(sp)
    800018d8:	f44e                	sd	s3,40(sp)
    800018da:	f052                	sd	s4,32(sp)
    800018dc:	ec56                	sd	s5,24(sp)
    800018de:	e85a                	sd	s6,16(sp)
    800018e0:	e45e                	sd	s7,8(sp)
    800018e2:	e062                	sd	s8,0(sp)
    800018e4:	0880                	addi	s0,sp,80
    800018e6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018e8:	fffff097          	auipc	ra,0xfffff
    800018ec:	65e080e7          	jalr	1630(ra) # 80000f46 <myproc>
    800018f0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018f2:	0000b517          	auipc	a0,0xb
    800018f6:	d6650513          	addi	a0,a0,-666 # 8000c658 <wait_lock>
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	79e080e7          	jalr	1950(ra) # 80007098 <acquire>
    havekids = 0;
    80001902:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80001904:	4a15                	li	s4,5
        havekids = 1;
    80001906:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001908:	00011997          	auipc	s3,0x11
    8000190c:	b6898993          	addi	s3,s3,-1176 # 80012470 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001910:	0000bc17          	auipc	s8,0xb
    80001914:	d48c0c13          	addi	s8,s8,-696 # 8000c658 <wait_lock>
    80001918:	a0d1                	j	800019dc <wait+0x10e>
          pid = pp->pid;
    8000191a:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000191e:	000b0e63          	beqz	s6,8000193a <wait+0x6c>
    80001922:	4691                	li	a3,4
    80001924:	02c48613          	addi	a2,s1,44
    80001928:	85da                	mv	a1,s6
    8000192a:	05093503          	ld	a0,80(s2)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	25e080e7          	jalr	606(ra) # 80000b8c <copyout>
    80001936:	04054163          	bltz	a0,80001978 <wait+0xaa>
          freeproc(pp);
    8000193a:	8526                	mv	a0,s1
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	7c0080e7          	jalr	1984(ra) # 800010fc <freeproc>
          release(&pp->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00006097          	auipc	ra,0x6
    8000194a:	806080e7          	jalr	-2042(ra) # 8000714c <release>
          release(&wait_lock);
    8000194e:	0000b517          	auipc	a0,0xb
    80001952:	d0a50513          	addi	a0,a0,-758 # 8000c658 <wait_lock>
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	7f6080e7          	jalr	2038(ra) # 8000714c <release>
}
    8000195e:	854e                	mv	a0,s3
    80001960:	60a6                	ld	ra,72(sp)
    80001962:	6406                	ld	s0,64(sp)
    80001964:	74e2                	ld	s1,56(sp)
    80001966:	7942                	ld	s2,48(sp)
    80001968:	79a2                	ld	s3,40(sp)
    8000196a:	7a02                	ld	s4,32(sp)
    8000196c:	6ae2                	ld	s5,24(sp)
    8000196e:	6b42                	ld	s6,16(sp)
    80001970:	6ba2                	ld	s7,8(sp)
    80001972:	6c02                	ld	s8,0(sp)
    80001974:	6161                	addi	sp,sp,80
    80001976:	8082                	ret
            release(&pp->lock);
    80001978:	8526                	mv	a0,s1
    8000197a:	00005097          	auipc	ra,0x5
    8000197e:	7d2080e7          	jalr	2002(ra) # 8000714c <release>
            release(&wait_lock);
    80001982:	0000b517          	auipc	a0,0xb
    80001986:	cd650513          	addi	a0,a0,-810 # 8000c658 <wait_lock>
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	7c2080e7          	jalr	1986(ra) # 8000714c <release>
            return -1;
    80001992:	59fd                	li	s3,-1
    80001994:	b7e9                	j	8000195e <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001996:	16848493          	addi	s1,s1,360
    8000199a:	03348463          	beq	s1,s3,800019c2 <wait+0xf4>
      if (pp->parent == p) {
    8000199e:	7c9c                	ld	a5,56(s1)
    800019a0:	ff279be3          	bne	a5,s2,80001996 <wait+0xc8>
        acquire(&pp->lock);
    800019a4:	8526                	mv	a0,s1
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	6f2080e7          	jalr	1778(ra) # 80007098 <acquire>
        if (pp->state == ZOMBIE) {
    800019ae:	4c9c                	lw	a5,24(s1)
    800019b0:	f74785e3          	beq	a5,s4,8000191a <wait+0x4c>
        release(&pp->lock);
    800019b4:	8526                	mv	a0,s1
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	796080e7          	jalr	1942(ra) # 8000714c <release>
        havekids = 1;
    800019be:	8756                	mv	a4,s5
    800019c0:	bfd9                	j	80001996 <wait+0xc8>
    if (!havekids || killed(p)) {
    800019c2:	c31d                	beqz	a4,800019e8 <wait+0x11a>
    800019c4:	854a                	mv	a0,s2
    800019c6:	00000097          	auipc	ra,0x0
    800019ca:	ed6080e7          	jalr	-298(ra) # 8000189c <killed>
    800019ce:	ed09                	bnez	a0,800019e8 <wait+0x11a>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800019d0:	85e2                	mv	a1,s8
    800019d2:	854a                	mv	a0,s2
    800019d4:	00000097          	auipc	ra,0x0
    800019d8:	c20080e7          	jalr	-992(ra) # 800015f4 <sleep>
    havekids = 0;
    800019dc:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800019de:	0000b497          	auipc	s1,0xb
    800019e2:	09248493          	addi	s1,s1,146 # 8000ca70 <proc>
    800019e6:	bf65                	j	8000199e <wait+0xd0>
      release(&wait_lock);
    800019e8:	0000b517          	auipc	a0,0xb
    800019ec:	c7050513          	addi	a0,a0,-912 # 8000c658 <wait_lock>
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	75c080e7          	jalr	1884(ra) # 8000714c <release>
      return -1;
    800019f8:	59fd                	li	s3,-1
    800019fa:	b795                	j	8000195e <wait+0x90>

00000000800019fc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    800019fc:	7179                	addi	sp,sp,-48
    800019fe:	f406                	sd	ra,40(sp)
    80001a00:	f022                	sd	s0,32(sp)
    80001a02:	ec26                	sd	s1,24(sp)
    80001a04:	e84a                	sd	s2,16(sp)
    80001a06:	e44e                	sd	s3,8(sp)
    80001a08:	e052                	sd	s4,0(sp)
    80001a0a:	1800                	addi	s0,sp,48
    80001a0c:	84aa                	mv	s1,a0
    80001a0e:	892e                	mv	s2,a1
    80001a10:	89b2                	mv	s3,a2
    80001a12:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	532080e7          	jalr	1330(ra) # 80000f46 <myproc>
  if (user_dst) {
    80001a1c:	c08d                	beqz	s1,80001a3e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a1e:	86d2                	mv	a3,s4
    80001a20:	864e                	mv	a2,s3
    80001a22:	85ca                	mv	a1,s2
    80001a24:	6928                	ld	a0,80(a0)
    80001a26:	fffff097          	auipc	ra,0xfffff
    80001a2a:	166080e7          	jalr	358(ra) # 80000b8c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a2e:	70a2                	ld	ra,40(sp)
    80001a30:	7402                	ld	s0,32(sp)
    80001a32:	64e2                	ld	s1,24(sp)
    80001a34:	6942                	ld	s2,16(sp)
    80001a36:	69a2                	ld	s3,8(sp)
    80001a38:	6a02                	ld	s4,0(sp)
    80001a3a:	6145                	addi	sp,sp,48
    80001a3c:	8082                	ret
    memmove((char *)dst, src, len);
    80001a3e:	000a061b          	sext.w	a2,s4
    80001a42:	85ce                	mv	a1,s3
    80001a44:	854a                	mv	a0,s2
    80001a46:	ffffe097          	auipc	ra,0xffffe
    80001a4a:	790080e7          	jalr	1936(ra) # 800001d6 <memmove>
    return 0;
    80001a4e:	8526                	mv	a0,s1
    80001a50:	bff9                	j	80001a2e <either_copyout+0x32>

0000000080001a52 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001a52:	7179                	addi	sp,sp,-48
    80001a54:	f406                	sd	ra,40(sp)
    80001a56:	f022                	sd	s0,32(sp)
    80001a58:	ec26                	sd	s1,24(sp)
    80001a5a:	e84a                	sd	s2,16(sp)
    80001a5c:	e44e                	sd	s3,8(sp)
    80001a5e:	e052                	sd	s4,0(sp)
    80001a60:	1800                	addi	s0,sp,48
    80001a62:	892a                	mv	s2,a0
    80001a64:	84ae                	mv	s1,a1
    80001a66:	89b2                	mv	s3,a2
    80001a68:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	4dc080e7          	jalr	1244(ra) # 80000f46 <myproc>
  if (user_src) {
    80001a72:	c08d                	beqz	s1,80001a94 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a74:	86d2                	mv	a3,s4
    80001a76:	864e                	mv	a2,s3
    80001a78:	85ca                	mv	a1,s2
    80001a7a:	6928                	ld	a0,80(a0)
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	1ee080e7          	jalr	494(ra) # 80000c6a <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001a84:	70a2                	ld	ra,40(sp)
    80001a86:	7402                	ld	s0,32(sp)
    80001a88:	64e2                	ld	s1,24(sp)
    80001a8a:	6942                	ld	s2,16(sp)
    80001a8c:	69a2                	ld	s3,8(sp)
    80001a8e:	6a02                	ld	s4,0(sp)
    80001a90:	6145                	addi	sp,sp,48
    80001a92:	8082                	ret
    memmove(dst, (char *)src, len);
    80001a94:	000a061b          	sext.w	a2,s4
    80001a98:	85ce                	mv	a1,s3
    80001a9a:	854a                	mv	a0,s2
    80001a9c:	ffffe097          	auipc	ra,0xffffe
    80001aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    return 0;
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	bff9                	j	80001a84 <either_copyin+0x32>

0000000080001aa8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001aa8:	715d                	addi	sp,sp,-80
    80001aaa:	e486                	sd	ra,72(sp)
    80001aac:	e0a2                	sd	s0,64(sp)
    80001aae:	fc26                	sd	s1,56(sp)
    80001ab0:	f84a                	sd	s2,48(sp)
    80001ab2:	f44e                	sd	s3,40(sp)
    80001ab4:	f052                	sd	s4,32(sp)
    80001ab6:	ec56                	sd	s5,24(sp)
    80001ab8:	e85a                	sd	s6,16(sp)
    80001aba:	e45e                	sd	s7,8(sp)
    80001abc:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001abe:	00007517          	auipc	a0,0x7
    80001ac2:	55a50513          	addi	a0,a0,1370 # 80009018 <etext+0x18>
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	0a2080e7          	jalr	162(ra) # 80006b68 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ace:	0000b497          	auipc	s1,0xb
    80001ad2:	0fa48493          	addi	s1,s1,250 # 8000cbc8 <proc+0x158>
    80001ad6:	00011917          	auipc	s2,0x11
    80001ada:	af290913          	addi	s2,s2,-1294 # 800125c8 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ade:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ae0:	00007997          	auipc	s3,0x7
    80001ae4:	76098993          	addi	s3,s3,1888 # 80009240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae8:	00007a97          	auipc	s5,0x7
    80001aec:	760a8a93          	addi	s5,s5,1888 # 80009248 <etext+0x248>
    printf("\n");
    80001af0:	00007a17          	auipc	s4,0x7
    80001af4:	528a0a13          	addi	s4,s4,1320 # 80009018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af8:	00008b97          	auipc	s7,0x8
    80001afc:	d40b8b93          	addi	s7,s7,-704 # 80009838 <states.0>
    80001b00:	a00d                	j	80001b22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b02:	ed86a583          	lw	a1,-296(a3)
    80001b06:	8556                	mv	a0,s5
    80001b08:	00005097          	auipc	ra,0x5
    80001b0c:	060080e7          	jalr	96(ra) # 80006b68 <printf>
    printf("\n");
    80001b10:	8552                	mv	a0,s4
    80001b12:	00005097          	auipc	ra,0x5
    80001b16:	056080e7          	jalr	86(ra) # 80006b68 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b1a:	16848493          	addi	s1,s1,360
    80001b1e:	03248263          	beq	s1,s2,80001b42 <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001b22:	86a6                	mv	a3,s1
    80001b24:	ec04a783          	lw	a5,-320(s1)
    80001b28:	dbed                	beqz	a5,80001b1a <procdump+0x72>
      state = "???";
    80001b2a:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b2c:	fcfb6be3          	bltu	s6,a5,80001b02 <procdump+0x5a>
    80001b30:	02079713          	slli	a4,a5,0x20
    80001b34:	01d75793          	srli	a5,a4,0x1d
    80001b38:	97de                	add	a5,a5,s7
    80001b3a:	6390                	ld	a2,0(a5)
    80001b3c:	f279                	bnez	a2,80001b02 <procdump+0x5a>
      state = "???";
    80001b3e:	864e                	mv	a2,s3
    80001b40:	b7c9                	j	80001b02 <procdump+0x5a>
  }
}
    80001b42:	60a6                	ld	ra,72(sp)
    80001b44:	6406                	ld	s0,64(sp)
    80001b46:	74e2                	ld	s1,56(sp)
    80001b48:	7942                	ld	s2,48(sp)
    80001b4a:	79a2                	ld	s3,40(sp)
    80001b4c:	7a02                	ld	s4,32(sp)
    80001b4e:	6ae2                	ld	s5,24(sp)
    80001b50:	6b42                	ld	s6,16(sp)
    80001b52:	6ba2                	ld	s7,8(sp)
    80001b54:	6161                	addi	sp,sp,80
    80001b56:	8082                	ret

0000000080001b58 <swtch>:
    80001b58:	00153023          	sd	ra,0(a0)
    80001b5c:	00253423          	sd	sp,8(a0)
    80001b60:	e900                	sd	s0,16(a0)
    80001b62:	ed04                	sd	s1,24(a0)
    80001b64:	03253023          	sd	s2,32(a0)
    80001b68:	03353423          	sd	s3,40(a0)
    80001b6c:	03453823          	sd	s4,48(a0)
    80001b70:	03553c23          	sd	s5,56(a0)
    80001b74:	05653023          	sd	s6,64(a0)
    80001b78:	05753423          	sd	s7,72(a0)
    80001b7c:	05853823          	sd	s8,80(a0)
    80001b80:	05953c23          	sd	s9,88(a0)
    80001b84:	07a53023          	sd	s10,96(a0)
    80001b88:	07b53423          	sd	s11,104(a0)
    80001b8c:	0005b083          	ld	ra,0(a1)
    80001b90:	0085b103          	ld	sp,8(a1)
    80001b94:	6980                	ld	s0,16(a1)
    80001b96:	6d84                	ld	s1,24(a1)
    80001b98:	0205b903          	ld	s2,32(a1)
    80001b9c:	0285b983          	ld	s3,40(a1)
    80001ba0:	0305ba03          	ld	s4,48(a1)
    80001ba4:	0385ba83          	ld	s5,56(a1)
    80001ba8:	0405bb03          	ld	s6,64(a1)
    80001bac:	0485bb83          	ld	s7,72(a1)
    80001bb0:	0505bc03          	ld	s8,80(a1)
    80001bb4:	0585bc83          	ld	s9,88(a1)
    80001bb8:	0605bd03          	ld	s10,96(a1)
    80001bbc:	0685bd83          	ld	s11,104(a1)
    80001bc0:	8082                	ret

0000000080001bc2 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001bc2:	1141                	addi	sp,sp,-16
    80001bc4:	e406                	sd	ra,8(sp)
    80001bc6:	e022                	sd	s0,0(sp)
    80001bc8:	0800                	addi	s0,sp,16
    80001bca:	00007597          	auipc	a1,0x7
    80001bce:	6be58593          	addi	a1,a1,1726 # 80009288 <etext+0x288>
    80001bd2:	00011517          	auipc	a0,0x11
    80001bd6:	89e50513          	addi	a0,a0,-1890 # 80012470 <tickslock>
    80001bda:	00005097          	auipc	ra,0x5
    80001bde:	42e080e7          	jalr	1070(ra) # 80007008 <initlock>
    80001be2:	60a2                	ld	ra,8(sp)
    80001be4:	6402                	ld	s0,0(sp)
    80001be6:	0141                	addi	sp,sp,16
    80001be8:	8082                	ret

0000000080001bea <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001bea:	1141                	addi	sp,sp,-16
    80001bec:	e422                	sd	s0,8(sp)
    80001bee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001bf0:	00003797          	auipc	a5,0x3
    80001bf4:	5c078793          	addi	a5,a5,1472 # 800051b0 <kernelvec>
    80001bf8:	10579073          	csrw	stvec,a5
    80001bfc:	6422                	ld	s0,8(sp)
    80001bfe:	0141                	addi	sp,sp,16
    80001c00:	8082                	ret

0000000080001c02 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001c02:	1141                	addi	sp,sp,-16
    80001c04:	e406                	sd	ra,8(sp)
    80001c06:	e022                	sd	s0,0(sp)
    80001c08:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	33c080e7          	jalr	828(ra) # 80000f46 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c12:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001c16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c18:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c1c:	00006697          	auipc	a3,0x6
    80001c20:	3e468693          	addi	a3,a3,996 # 80008000 <_trampoline>
    80001c24:	00006717          	auipc	a4,0x6
    80001c28:	3dc70713          	addi	a4,a4,988 # 80008000 <_trampoline>
    80001c2c:	8f15                	sub	a4,a4,a3
    80001c2e:	040007b7          	lui	a5,0x4000
    80001c32:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c34:	07b2                	slli	a5,a5,0xc
    80001c36:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c38:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001c3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001c3e:	18002673          	csrr	a2,satp
    80001c42:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001c44:	6d30                	ld	a2,88(a0)
    80001c46:	6138                	ld	a4,64(a0)
    80001c48:	6585                	lui	a1,0x1
    80001c4a:	972e                	add	a4,a4,a1
    80001c4c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c4e:	6d38                	ld	a4,88(a0)
    80001c50:	00000617          	auipc	a2,0x0
    80001c54:	14a60613          	addi	a2,a2,330 # 80001d9a <usertrap>
    80001c58:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001c5a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001c5c:	8612                	mv	a2,tp
    80001c5e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c60:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001c64:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001c68:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c6c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c70:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001c72:	6f18                	ld	a4,24(a4)
    80001c74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c78:	6928                	ld	a0,80(a0)
    80001c7a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c7c:	00006717          	auipc	a4,0x6
    80001c80:	42070713          	addi	a4,a4,1056 # 8000809c <userret>
    80001c84:	8f15                	sub	a4,a4,a3
    80001c86:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c88:	577d                	li	a4,-1
    80001c8a:	177e                	slli	a4,a4,0x3f
    80001c8c:	8d59                	or	a0,a0,a4
    80001c8e:	9782                	jalr	a5
}
    80001c90:	60a2                	ld	ra,8(sp)
    80001c92:	6402                	ld	s0,0(sp)
    80001c94:	0141                	addi	sp,sp,16
    80001c96:	8082                	ret

0000000080001c98 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ca2:	00010497          	auipc	s1,0x10
    80001ca6:	7ce48493          	addi	s1,s1,1998 # 80012470 <tickslock>
    80001caa:	8526                	mv	a0,s1
    80001cac:	00005097          	auipc	ra,0x5
    80001cb0:	3ec080e7          	jalr	1004(ra) # 80007098 <acquire>
  ticks++;
    80001cb4:	0000b517          	auipc	a0,0xb
    80001cb8:	93450513          	addi	a0,a0,-1740 # 8000c5e8 <ticks>
    80001cbc:	411c                	lw	a5,0(a0)
    80001cbe:	2785                	addiw	a5,a5,1
    80001cc0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	996080e7          	jalr	-1642(ra) # 80001658 <wakeup>
  release(&tickslock);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00005097          	auipc	ra,0x5
    80001cd0:	480080e7          	jalr	1152(ra) # 8000714c <release>
}
    80001cd4:	60e2                	ld	ra,24(sp)
    80001cd6:	6442                	ld	s0,16(sp)
    80001cd8:	64a2                	ld	s1,8(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret

0000000080001cde <devintr>:
  asm volatile("csrr %0, scause" : "=r"(x));
    80001cde:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ce2:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001ce4:	0a07da63          	bgez	a5,80001d98 <devintr+0xba>
int devintr() {
    80001ce8:	1101                	addi	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	1000                	addi	s0,sp,32
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001cf0:	0ff7f713          	zext.b	a4,a5
    80001cf4:	46a5                	li	a3,9
    80001cf6:	00d70c63          	beq	a4,a3,80001d0e <devintr+0x30>
  } else if (scause == 0x8000000000000001L) {
    80001cfa:	577d                	li	a4,-1
    80001cfc:	177e                	slli	a4,a4,0x3f
    80001cfe:	0705                	addi	a4,a4,1
    return 0;
    80001d00:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001d02:	06e78a63          	beq	a5,a4,80001d76 <devintr+0x98>
  }
}
    80001d06:	60e2                	ld	ra,24(sp)
    80001d08:	6442                	ld	s0,16(sp)
    80001d0a:	6105                	addi	sp,sp,32
    80001d0c:	8082                	ret
    80001d0e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d10:	00003097          	auipc	ra,0x3
    80001d14:	5c6080e7          	jalr	1478(ra) # 800052d6 <plic_claim>
    80001d18:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001d1a:	47a9                	li	a5,10
    80001d1c:	00f50d63          	beq	a0,a5,80001d36 <devintr+0x58>
    } else if (irq == VIRTIO0_IRQ) {
    80001d20:	4785                	li	a5,1
    80001d22:	02f50663          	beq	a0,a5,80001d4e <devintr+0x70>
    } else if (irq == E1000_IRQ) {
    80001d26:	02100793          	li	a5,33
    80001d2a:	02f50763          	beq	a0,a5,80001d58 <devintr+0x7a>
    return 1;
    80001d2e:	4505                	li	a0,1
    } else if (irq) {
    80001d30:	e88d                	bnez	s1,80001d62 <devintr+0x84>
    80001d32:	64a2                	ld	s1,8(sp)
    80001d34:	bfc9                	j	80001d06 <devintr+0x28>
      uartintr();
    80001d36:	00005097          	auipc	ra,0x5
    80001d3a:	282080e7          	jalr	642(ra) # 80006fb8 <uartintr>
    if (irq) plic_complete(irq);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00003097          	auipc	ra,0x3
    80001d44:	5ba080e7          	jalr	1466(ra) # 800052fa <plic_complete>
    return 1;
    80001d48:	4505                	li	a0,1
    80001d4a:	64a2                	ld	s1,8(sp)
    80001d4c:	bf6d                	j	80001d06 <devintr+0x28>
      virtio_disk_intr();
    80001d4e:	00004097          	auipc	ra,0x4
    80001d52:	ab2080e7          	jalr	-1358(ra) # 80005800 <virtio_disk_intr>
    if (irq) plic_complete(irq);
    80001d56:	b7e5                	j	80001d3e <devintr+0x60>
      e1000_intr();
    80001d58:	00004097          	auipc	ra,0x4
    80001d5c:	dc8080e7          	jalr	-568(ra) # 80005b20 <e1000_intr>
    if (irq) plic_complete(irq);
    80001d60:	bff9                	j	80001d3e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d62:	85a6                	mv	a1,s1
    80001d64:	00007517          	auipc	a0,0x7
    80001d68:	52c50513          	addi	a0,a0,1324 # 80009290 <etext+0x290>
    80001d6c:	00005097          	auipc	ra,0x5
    80001d70:	dfc080e7          	jalr	-516(ra) # 80006b68 <printf>
    if (irq) plic_complete(irq);
    80001d74:	b7e9                	j	80001d3e <devintr+0x60>
    if (cpuid() == 0) {
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	1a4080e7          	jalr	420(ra) # 80000f1a <cpuid>
    80001d7e:	c901                	beqz	a0,80001d8e <devintr+0xb0>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001d80:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d84:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001d86:	14479073          	csrw	sip,a5
    return 2;
    80001d8a:	4509                	li	a0,2
    80001d8c:	bfad                	j	80001d06 <devintr+0x28>
      clockintr();
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	f0a080e7          	jalr	-246(ra) # 80001c98 <clockintr>
    80001d96:	b7ed                	j	80001d80 <devintr+0xa2>
}
    80001d98:	8082                	ret

0000000080001d9a <usertrap>:
void usertrap(void) {
    80001d9a:	1101                	addi	sp,sp,-32
    80001d9c:	ec06                	sd	ra,24(sp)
    80001d9e:	e822                	sd	s0,16(sp)
    80001da0:	e426                	sd	s1,8(sp)
    80001da2:	e04a                	sd	s2,0(sp)
    80001da4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001da6:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001daa:	1007f793          	andi	a5,a5,256
    80001dae:	e3b1                	bnez	a5,80001df2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001db0:	00003797          	auipc	a5,0x3
    80001db4:	40078793          	addi	a5,a5,1024 # 800051b0 <kernelvec>
    80001db8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	18a080e7          	jalr	394(ra) # 80000f46 <myproc>
    80001dc4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dc6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001dc8:	14102773          	csrr	a4,sepc
    80001dcc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001dce:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001dd2:	47a1                	li	a5,8
    80001dd4:	02f70763          	beq	a4,a5,80001e02 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	f06080e7          	jalr	-250(ra) # 80001cde <devintr>
    80001de0:	892a                	mv	s2,a0
    80001de2:	c151                	beqz	a0,80001e66 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001de4:	8526                	mv	a0,s1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	ab6080e7          	jalr	-1354(ra) # 8000189c <killed>
    80001dee:	c929                	beqz	a0,80001e40 <usertrap+0xa6>
    80001df0:	a099                	j	80001e36 <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001df2:	00007517          	auipc	a0,0x7
    80001df6:	4be50513          	addi	a0,a0,1214 # 800092b0 <etext+0x2b0>
    80001dfa:	00005097          	auipc	ra,0x5
    80001dfe:	d24080e7          	jalr	-732(ra) # 80006b1e <panic>
    if (killed(p)) exit(-1);
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	a9a080e7          	jalr	-1382(ra) # 8000189c <killed>
    80001e0a:	e921                	bnez	a0,80001e5a <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e0c:	6cb8                	ld	a4,88(s1)
    80001e0e:	6f1c                	ld	a5,24(a4)
    80001e10:	0791                	addi	a5,a5,4
    80001e12:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e14:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001e18:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e1c:	10079073          	csrw	sstatus,a5
    syscall();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	2d4080e7          	jalr	724(ra) # 800020f4 <syscall>
  if (killed(p)) exit(-1);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	a72080e7          	jalr	-1422(ra) # 8000189c <killed>
    80001e32:	c911                	beqz	a0,80001e46 <usertrap+0xac>
    80001e34:	4901                	li	s2,0
    80001e36:	557d                	li	a0,-1
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	8f0080e7          	jalr	-1808(ra) # 80001728 <exit>
  if (which_dev == 2) yield();
    80001e40:	4789                	li	a5,2
    80001e42:	04f90f63          	beq	s2,a5,80001ea0 <usertrap+0x106>
  usertrapret();
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	dbc080e7          	jalr	-580(ra) # 80001c02 <usertrapret>
}
    80001e4e:	60e2                	ld	ra,24(sp)
    80001e50:	6442                	ld	s0,16(sp)
    80001e52:	64a2                	ld	s1,8(sp)
    80001e54:	6902                	ld	s2,0(sp)
    80001e56:	6105                	addi	sp,sp,32
    80001e58:	8082                	ret
    if (killed(p)) exit(-1);
    80001e5a:	557d                	li	a0,-1
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	8cc080e7          	jalr	-1844(ra) # 80001728 <exit>
    80001e64:	b765                	j	80001e0c <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e66:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e6a:	5890                	lw	a2,48(s1)
    80001e6c:	00007517          	auipc	a0,0x7
    80001e70:	46450513          	addi	a0,a0,1124 # 800092d0 <etext+0x2d0>
    80001e74:	00005097          	auipc	ra,0x5
    80001e78:	cf4080e7          	jalr	-780(ra) # 80006b68 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e80:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e84:	00007517          	auipc	a0,0x7
    80001e88:	47c50513          	addi	a0,a0,1148 # 80009300 <etext+0x300>
    80001e8c:	00005097          	auipc	ra,0x5
    80001e90:	cdc080e7          	jalr	-804(ra) # 80006b68 <printf>
    setkilled(p);
    80001e94:	8526                	mv	a0,s1
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	9da080e7          	jalr	-1574(ra) # 80001870 <setkilled>
    80001e9e:	b769                	j	80001e28 <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	718080e7          	jalr	1816(ra) # 800015b8 <yield>
    80001ea8:	bf79                	j	80001e46 <usertrap+0xac>

0000000080001eaa <kerneltrap>:
void kerneltrap() {
    80001eaa:	7179                	addi	sp,sp,-48
    80001eac:	f406                	sd	ra,40(sp)
    80001eae:	f022                	sd	s0,32(sp)
    80001eb0:	ec26                	sd	s1,24(sp)
    80001eb2:	e84a                	sd	s2,16(sp)
    80001eb4:	e44e                	sd	s3,8(sp)
    80001eb6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001eb8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ebc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001ec0:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001ec4:	1004f793          	andi	a5,s1,256
    80001ec8:	cb85                	beqz	a5,80001ef8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001eca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ece:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001ed0:	ef85                	bnez	a5,80001f08 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001ed2:	00000097          	auipc	ra,0x0
    80001ed6:	e0c080e7          	jalr	-500(ra) # 80001cde <devintr>
    80001eda:	cd1d                	beqz	a0,80001f18 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001edc:	4789                	li	a5,2
    80001ede:	06f50a63          	beq	a0,a5,80001f52 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001ee2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ee6:	10049073          	csrw	sstatus,s1
}
    80001eea:	70a2                	ld	ra,40(sp)
    80001eec:	7402                	ld	s0,32(sp)
    80001eee:	64e2                	ld	s1,24(sp)
    80001ef0:	6942                	ld	s2,16(sp)
    80001ef2:	69a2                	ld	s3,8(sp)
    80001ef4:	6145                	addi	sp,sp,48
    80001ef6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ef8:	00007517          	auipc	a0,0x7
    80001efc:	42850513          	addi	a0,a0,1064 # 80009320 <etext+0x320>
    80001f00:	00005097          	auipc	ra,0x5
    80001f04:	c1e080e7          	jalr	-994(ra) # 80006b1e <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001f08:	00007517          	auipc	a0,0x7
    80001f0c:	44050513          	addi	a0,a0,1088 # 80009348 <etext+0x348>
    80001f10:	00005097          	auipc	ra,0x5
    80001f14:	c0e080e7          	jalr	-1010(ra) # 80006b1e <panic>
    printf("scause %p\n", scause);
    80001f18:	85ce                	mv	a1,s3
    80001f1a:	00007517          	auipc	a0,0x7
    80001f1e:	44e50513          	addi	a0,a0,1102 # 80009368 <etext+0x368>
    80001f22:	00005097          	auipc	ra,0x5
    80001f26:	c46080e7          	jalr	-954(ra) # 80006b68 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f2a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001f2e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f32:	00007517          	auipc	a0,0x7
    80001f36:	44650513          	addi	a0,a0,1094 # 80009378 <etext+0x378>
    80001f3a:	00005097          	auipc	ra,0x5
    80001f3e:	c2e080e7          	jalr	-978(ra) # 80006b68 <printf>
    panic("kerneltrap");
    80001f42:	00007517          	auipc	a0,0x7
    80001f46:	44e50513          	addi	a0,a0,1102 # 80009390 <etext+0x390>
    80001f4a:	00005097          	auipc	ra,0x5
    80001f4e:	bd4080e7          	jalr	-1068(ra) # 80006b1e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	ff4080e7          	jalr	-12(ra) # 80000f46 <myproc>
    80001f5a:	d541                	beqz	a0,80001ee2 <kerneltrap+0x38>
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	fea080e7          	jalr	-22(ra) # 80000f46 <myproc>
    80001f64:	4d18                	lw	a4,24(a0)
    80001f66:	4791                	li	a5,4
    80001f68:	f6f71de3          	bne	a4,a5,80001ee2 <kerneltrap+0x38>
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	64c080e7          	jalr	1612(ra) # 800015b8 <yield>
    80001f74:	b7bd                	j	80001ee2 <kerneltrap+0x38>

0000000080001f76 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	e426                	sd	s1,8(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	fc4080e7          	jalr	-60(ra) # 80000f46 <myproc>
  switch (n) {
    80001f8a:	4795                	li	a5,5
    80001f8c:	0497e163          	bltu	a5,s1,80001fce <argraw+0x58>
    80001f90:	048a                	slli	s1,s1,0x2
    80001f92:	00008717          	auipc	a4,0x8
    80001f96:	8d670713          	addi	a4,a4,-1834 # 80009868 <states.0+0x30>
    80001f9a:	94ba                	add	s1,s1,a4
    80001f9c:	409c                	lw	a5,0(s1)
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001fa2:	6d3c                	ld	a5,88(a0)
    80001fa4:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fa6:	60e2                	ld	ra,24(sp)
    80001fa8:	6442                	ld	s0,16(sp)
    80001faa:	64a2                	ld	s1,8(sp)
    80001fac:	6105                	addi	sp,sp,32
    80001fae:	8082                	ret
      return p->trapframe->a1;
    80001fb0:	6d3c                	ld	a5,88(a0)
    80001fb2:	7fa8                	ld	a0,120(a5)
    80001fb4:	bfcd                	j	80001fa6 <argraw+0x30>
      return p->trapframe->a2;
    80001fb6:	6d3c                	ld	a5,88(a0)
    80001fb8:	63c8                	ld	a0,128(a5)
    80001fba:	b7f5                	j	80001fa6 <argraw+0x30>
      return p->trapframe->a3;
    80001fbc:	6d3c                	ld	a5,88(a0)
    80001fbe:	67c8                	ld	a0,136(a5)
    80001fc0:	b7dd                	j	80001fa6 <argraw+0x30>
      return p->trapframe->a4;
    80001fc2:	6d3c                	ld	a5,88(a0)
    80001fc4:	6bc8                	ld	a0,144(a5)
    80001fc6:	b7c5                	j	80001fa6 <argraw+0x30>
      return p->trapframe->a5;
    80001fc8:	6d3c                	ld	a5,88(a0)
    80001fca:	6fc8                	ld	a0,152(a5)
    80001fcc:	bfe9                	j	80001fa6 <argraw+0x30>
  panic("argraw");
    80001fce:	00007517          	auipc	a0,0x7
    80001fd2:	3d250513          	addi	a0,a0,978 # 800093a0 <etext+0x3a0>
    80001fd6:	00005097          	auipc	ra,0x5
    80001fda:	b48080e7          	jalr	-1208(ra) # 80006b1e <panic>

0000000080001fde <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
    80001fea:	84aa                	mv	s1,a0
    80001fec:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	f58080e7          	jalr	-168(ra) # 80000f46 <myproc>
  if (addr >= p->sz ||
    80001ff6:	653c                	ld	a5,72(a0)
    80001ff8:	02f4f863          	bgeu	s1,a5,80002028 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001ffc:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002000:	02e7e663          	bltu	a5,a4,8000202c <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80002004:	46a1                	li	a3,8
    80002006:	8626                	mv	a2,s1
    80002008:	85ca                	mv	a1,s2
    8000200a:	6928                	ld	a0,80(a0)
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	c5e080e7          	jalr	-930(ra) # 80000c6a <copyin>
    80002014:	00a03533          	snez	a0,a0
    80002018:	40a00533          	neg	a0,a0
}
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6902                	ld	s2,0(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret
    return -1;
    80002028:	557d                	li	a0,-1
    8000202a:	bfcd                	j	8000201c <fetchaddr+0x3e>
    8000202c:	557d                	li	a0,-1
    8000202e:	b7fd                	j	8000201c <fetchaddr+0x3e>

0000000080002030 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002030:	7179                	addi	sp,sp,-48
    80002032:	f406                	sd	ra,40(sp)
    80002034:	f022                	sd	s0,32(sp)
    80002036:	ec26                	sd	s1,24(sp)
    80002038:	e84a                	sd	s2,16(sp)
    8000203a:	e44e                	sd	s3,8(sp)
    8000203c:	1800                	addi	s0,sp,48
    8000203e:	892a                	mv	s2,a0
    80002040:	84ae                	mv	s1,a1
    80002042:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	f02080e7          	jalr	-254(ra) # 80000f46 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000204c:	86ce                	mv	a3,s3
    8000204e:	864a                	mv	a2,s2
    80002050:	85a6                	mv	a1,s1
    80002052:	6928                	ld	a0,80(a0)
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	ca4080e7          	jalr	-860(ra) # 80000cf8 <copyinstr>
    8000205c:	00054e63          	bltz	a0,80002078 <fetchstr+0x48>
  return strlen(buf);
    80002060:	8526                	mv	a0,s1
    80002062:	ffffe097          	auipc	ra,0xffffe
    80002066:	28c080e7          	jalr	652(ra) # 800002ee <strlen>
}
    8000206a:	70a2                	ld	ra,40(sp)
    8000206c:	7402                	ld	s0,32(sp)
    8000206e:	64e2                	ld	s1,24(sp)
    80002070:	6942                	ld	s2,16(sp)
    80002072:	69a2                	ld	s3,8(sp)
    80002074:	6145                	addi	sp,sp,48
    80002076:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002078:	557d                	li	a0,-1
    8000207a:	bfc5                	j	8000206a <fetchstr+0x3a>

000000008000207c <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84ae                	mv	s1,a1
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	eee080e7          	jalr	-274(ra) # 80001f76 <argraw>
    80002090:	c088                	sw	a0,0(s1)
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	64a2                	ld	s1,8(sp)
    80002098:	6105                	addi	sp,sp,32
    8000209a:	8082                	ret

000000008000209c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	e426                	sd	s1,8(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84ae                	mv	s1,a1
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	ece080e7          	jalr	-306(ra) # 80001f76 <argraw>
    800020b0:	e088                	sd	a0,0(s1)
    800020b2:	60e2                	ld	ra,24(sp)
    800020b4:	6442                	ld	s0,16(sp)
    800020b6:	64a2                	ld	s1,8(sp)
    800020b8:	6105                	addi	sp,sp,32
    800020ba:	8082                	ret

00000000800020bc <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800020bc:	7179                	addi	sp,sp,-48
    800020be:	f406                	sd	ra,40(sp)
    800020c0:	f022                	sd	s0,32(sp)
    800020c2:	ec26                	sd	s1,24(sp)
    800020c4:	e84a                	sd	s2,16(sp)
    800020c6:	1800                	addi	s0,sp,48
    800020c8:	84ae                	mv	s1,a1
    800020ca:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020cc:	fd840593          	addi	a1,s0,-40
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	fcc080e7          	jalr	-52(ra) # 8000209c <argaddr>
  return fetchstr(addr, buf, max);
    800020d8:	864a                	mv	a2,s2
    800020da:	85a6                	mv	a1,s1
    800020dc:	fd843503          	ld	a0,-40(s0)
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	f50080e7          	jalr	-176(ra) # 80002030 <fetchstr>
}
    800020e8:	70a2                	ld	ra,40(sp)
    800020ea:	7402                	ld	s0,32(sp)
    800020ec:	64e2                	ld	s1,24(sp)
    800020ee:	6942                	ld	s2,16(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret

00000000800020f4 <syscall>:
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,   [SYS_bind] sys_bind,
    [SYS_unbind] sys_unbind,   [SYS_send] sys_send,
    [SYS_recv] sys_recv};

void syscall(void) {
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	e04a                	sd	s2,0(sp)
    800020fe:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	e46080e7          	jalr	-442(ra) # 80000f46 <myproc>
    80002108:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000210a:	05853903          	ld	s2,88(a0)
    8000210e:	0a893783          	ld	a5,168(s2)
    80002112:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002116:	37fd                	addiw	a5,a5,-1
    80002118:	4761                	li	a4,24
    8000211a:	00f76f63          	bltu	a4,a5,80002138 <syscall+0x44>
    8000211e:	00369713          	slli	a4,a3,0x3
    80002122:	00007797          	auipc	a5,0x7
    80002126:	75e78793          	addi	a5,a5,1886 # 80009880 <syscalls>
    8000212a:	97ba                	add	a5,a5,a4
    8000212c:	639c                	ld	a5,0(a5)
    8000212e:	c789                	beqz	a5,80002138 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002130:	9782                	jalr	a5
    80002132:	06a93823          	sd	a0,112(s2)
    80002136:	a839                	j	80002154 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002138:	15848613          	addi	a2,s1,344
    8000213c:	588c                	lw	a1,48(s1)
    8000213e:	00007517          	auipc	a0,0x7
    80002142:	26a50513          	addi	a0,a0,618 # 800093a8 <etext+0x3a8>
    80002146:	00005097          	auipc	ra,0x5
    8000214a:	a22080e7          	jalr	-1502(ra) # 80006b68 <printf>
    p->trapframe->a0 = -1;
    8000214e:	6cbc                	ld	a5,88(s1)
    80002150:	577d                	li	a4,-1
    80002152:	fbb8                	sd	a4,112(a5)
  }
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret

0000000080002160 <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    80002160:	1101                	addi	sp,sp,-32
    80002162:	ec06                	sd	ra,24(sp)
    80002164:	e822                	sd	s0,16(sp)
    80002166:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002168:	fec40593          	addi	a1,s0,-20
    8000216c:	4501                	li	a0,0
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f0e080e7          	jalr	-242(ra) # 8000207c <argint>
  exit(n);
    80002176:	fec42503          	lw	a0,-20(s0)
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	5ae080e7          	jalr	1454(ra) # 80001728 <exit>
  return 0;  // not reached
}
    80002182:	4501                	li	a0,0
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	6105                	addi	sp,sp,32
    8000218a:	8082                	ret

000000008000218c <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000218c:	1141                	addi	sp,sp,-16
    8000218e:	e406                	sd	ra,8(sp)
    80002190:	e022                	sd	s0,0(sp)
    80002192:	0800                	addi	s0,sp,16
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	db2080e7          	jalr	-590(ra) # 80000f46 <myproc>
    8000219c:	5908                	lw	a0,48(a0)
    8000219e:	60a2                	ld	ra,8(sp)
    800021a0:	6402                	ld	s0,0(sp)
    800021a2:	0141                	addi	sp,sp,16
    800021a4:	8082                	ret

00000000800021a6 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800021a6:	1141                	addi	sp,sp,-16
    800021a8:	e406                	sd	ra,8(sp)
    800021aa:	e022                	sd	s0,0(sp)
    800021ac:	0800                	addi	s0,sp,16
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	152080e7          	jalr	338(ra) # 80001300 <fork>
    800021b6:	60a2                	ld	ra,8(sp)
    800021b8:	6402                	ld	s0,0(sp)
    800021ba:	0141                	addi	sp,sp,16
    800021bc:	8082                	ret

00000000800021be <sys_wait>:

uint64 sys_wait(void) {
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021c6:	fe840593          	addi	a1,s0,-24
    800021ca:	4501                	li	a0,0
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	ed0080e7          	jalr	-304(ra) # 8000209c <argaddr>
  return wait(p);
    800021d4:	fe843503          	ld	a0,-24(s0)
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	6f6080e7          	jalr	1782(ra) # 800018ce <wait>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <sys_sbrk>:

uint64 sys_sbrk(void) {
    800021e8:	7179                	addi	sp,sp,-48
    800021ea:	f406                	sd	ra,40(sp)
    800021ec:	f022                	sd	s0,32(sp)
    800021ee:	ec26                	sd	s1,24(sp)
    800021f0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021f2:	fdc40593          	addi	a1,s0,-36
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	e84080e7          	jalr	-380(ra) # 8000207c <argint>
  addr = myproc()->sz;
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	d46080e7          	jalr	-698(ra) # 80000f46 <myproc>
    80002208:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    8000220a:	fdc42503          	lw	a0,-36(s0)
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	096080e7          	jalr	150(ra) # 800012a4 <growproc>
    80002216:	00054863          	bltz	a0,80002226 <sys_sbrk+0x3e>
  return addr;
}
    8000221a:	8526                	mv	a0,s1
    8000221c:	70a2                	ld	ra,40(sp)
    8000221e:	7402                	ld	s0,32(sp)
    80002220:	64e2                	ld	s1,24(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret
  if (growproc(n) < 0) return -1;
    80002226:	54fd                	li	s1,-1
    80002228:	bfcd                	j	8000221a <sys_sbrk+0x32>

000000008000222a <sys_sleep>:

uint64 sys_sleep(void) {
    8000222a:	7139                	addi	sp,sp,-64
    8000222c:	fc06                	sd	ra,56(sp)
    8000222e:	f822                	sd	s0,48(sp)
    80002230:	f04a                	sd	s2,32(sp)
    80002232:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002234:	fcc40593          	addi	a1,s0,-52
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	e42080e7          	jalr	-446(ra) # 8000207c <argint>
  if (n < 0) n = 0;
    80002242:	fcc42783          	lw	a5,-52(s0)
    80002246:	0807c163          	bltz	a5,800022c8 <sys_sleep+0x9e>
  acquire(&tickslock);
    8000224a:	00010517          	auipc	a0,0x10
    8000224e:	22650513          	addi	a0,a0,550 # 80012470 <tickslock>
    80002252:	00005097          	auipc	ra,0x5
    80002256:	e46080e7          	jalr	-442(ra) # 80007098 <acquire>
  ticks0 = ticks;
    8000225a:	0000a917          	auipc	s2,0xa
    8000225e:	38e92903          	lw	s2,910(s2) # 8000c5e8 <ticks>
  while (ticks - ticks0 < n) {
    80002262:	fcc42783          	lw	a5,-52(s0)
    80002266:	c3b9                	beqz	a5,800022ac <sys_sleep+0x82>
    80002268:	f426                	sd	s1,40(sp)
    8000226a:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000226c:	00010997          	auipc	s3,0x10
    80002270:	20498993          	addi	s3,s3,516 # 80012470 <tickslock>
    80002274:	0000a497          	auipc	s1,0xa
    80002278:	37448493          	addi	s1,s1,884 # 8000c5e8 <ticks>
    if (killed(myproc())) {
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	cca080e7          	jalr	-822(ra) # 80000f46 <myproc>
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	618080e7          	jalr	1560(ra) # 8000189c <killed>
    8000228c:	e129                	bnez	a0,800022ce <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000228e:	85ce                	mv	a1,s3
    80002290:	8526                	mv	a0,s1
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	362080e7          	jalr	866(ra) # 800015f4 <sleep>
  while (ticks - ticks0 < n) {
    8000229a:	409c                	lw	a5,0(s1)
    8000229c:	412787bb          	subw	a5,a5,s2
    800022a0:	fcc42703          	lw	a4,-52(s0)
    800022a4:	fce7ece3          	bltu	a5,a4,8000227c <sys_sleep+0x52>
    800022a8:	74a2                	ld	s1,40(sp)
    800022aa:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022ac:	00010517          	auipc	a0,0x10
    800022b0:	1c450513          	addi	a0,a0,452 # 80012470 <tickslock>
    800022b4:	00005097          	auipc	ra,0x5
    800022b8:	e98080e7          	jalr	-360(ra) # 8000714c <release>
  return 0;
    800022bc:	4501                	li	a0,0
}
    800022be:	70e2                	ld	ra,56(sp)
    800022c0:	7442                	ld	s0,48(sp)
    800022c2:	7902                	ld	s2,32(sp)
    800022c4:	6121                	addi	sp,sp,64
    800022c6:	8082                	ret
  if (n < 0) n = 0;
    800022c8:	fc042623          	sw	zero,-52(s0)
    800022cc:	bfbd                	j	8000224a <sys_sleep+0x20>
      release(&tickslock);
    800022ce:	00010517          	auipc	a0,0x10
    800022d2:	1a250513          	addi	a0,a0,418 # 80012470 <tickslock>
    800022d6:	00005097          	auipc	ra,0x5
    800022da:	e76080e7          	jalr	-394(ra) # 8000714c <release>
      return -1;
    800022de:	557d                	li	a0,-1
    800022e0:	74a2                	ld	s1,40(sp)
    800022e2:	69e2                	ld	s3,24(sp)
    800022e4:	bfe9                	j	800022be <sys_sleep+0x94>

00000000800022e6 <sys_kill>:

uint64 sys_kill(void) {
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ee:	fec40593          	addi	a1,s0,-20
    800022f2:	4501                	li	a0,0
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	d88080e7          	jalr	-632(ra) # 8000207c <argint>
  return kill(pid);
    800022fc:	fec42503          	lw	a0,-20(s0)
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	4fe080e7          	jalr	1278(ra) # 800017fe <kill>
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	6105                	addi	sp,sp,32
    8000230e:	8082                	ret

0000000080002310 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002310:	1101                	addi	sp,sp,-32
    80002312:	ec06                	sd	ra,24(sp)
    80002314:	e822                	sd	s0,16(sp)
    80002316:	e426                	sd	s1,8(sp)
    80002318:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000231a:	00010517          	auipc	a0,0x10
    8000231e:	15650513          	addi	a0,a0,342 # 80012470 <tickslock>
    80002322:	00005097          	auipc	ra,0x5
    80002326:	d76080e7          	jalr	-650(ra) # 80007098 <acquire>
  xticks = ticks;
    8000232a:	0000a497          	auipc	s1,0xa
    8000232e:	2be4a483          	lw	s1,702(s1) # 8000c5e8 <ticks>
  release(&tickslock);
    80002332:	00010517          	auipc	a0,0x10
    80002336:	13e50513          	addi	a0,a0,318 # 80012470 <tickslock>
    8000233a:	00005097          	auipc	ra,0x5
    8000233e:	e12080e7          	jalr	-494(ra) # 8000714c <release>
  return xticks;
}
    80002342:	02049513          	slli	a0,s1,0x20
    80002346:	9101                	srli	a0,a0,0x20
    80002348:	60e2                	ld	ra,24(sp)
    8000234a:	6442                	ld	s0,16(sp)
    8000234c:	64a2                	ld	s1,8(sp)
    8000234e:	6105                	addi	sp,sp,32
    80002350:	8082                	ret

0000000080002352 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    80002352:	7179                	addi	sp,sp,-48
    80002354:	f406                	sd	ra,40(sp)
    80002356:	f022                	sd	s0,32(sp)
    80002358:	ec26                	sd	s1,24(sp)
    8000235a:	e84a                	sd	s2,16(sp)
    8000235c:	e44e                	sd	s3,8(sp)
    8000235e:	e052                	sd	s4,0(sp)
    80002360:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002362:	00007597          	auipc	a1,0x7
    80002366:	06658593          	addi	a1,a1,102 # 800093c8 <etext+0x3c8>
    8000236a:	00010517          	auipc	a0,0x10
    8000236e:	11e50513          	addi	a0,a0,286 # 80012488 <bcache>
    80002372:	00005097          	auipc	ra,0x5
    80002376:	c96080e7          	jalr	-874(ra) # 80007008 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237a:	00018797          	auipc	a5,0x18
    8000237e:	10e78793          	addi	a5,a5,270 # 8001a488 <bcache+0x8000>
    80002382:	00018717          	auipc	a4,0x18
    80002386:	36e70713          	addi	a4,a4,878 # 8001a6f0 <bcache+0x8268>
    8000238a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000238e:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002392:	00010497          	auipc	s1,0x10
    80002396:	10e48493          	addi	s1,s1,270 # 800124a0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000239c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000239e:	00007a17          	auipc	s4,0x7
    800023a2:	032a0a13          	addi	s4,s4,50 # 800093d0 <etext+0x3d0>
    b->next = bcache.head.next;
    800023a6:	2b893783          	ld	a5,696(s2)
    800023aa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ac:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b0:	85d2                	mv	a1,s4
    800023b2:	01048513          	addi	a0,s1,16
    800023b6:	00001097          	auipc	ra,0x1
    800023ba:	4e8080e7          	jalr	1256(ra) # 8000389e <initsleeplock>
    bcache.head.next->prev = b;
    800023be:	2b893783          	ld	a5,696(s2)
    800023c2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c4:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800023c8:	45848493          	addi	s1,s1,1112
    800023cc:	fd349de3          	bne	s1,s3,800023a6 <binit+0x54>
  }
}
    800023d0:	70a2                	ld	ra,40(sp)
    800023d2:	7402                	ld	s0,32(sp)
    800023d4:	64e2                	ld	s1,24(sp)
    800023d6:	6942                	ld	s2,16(sp)
    800023d8:	69a2                	ld	s3,8(sp)
    800023da:	6a02                	ld	s4,0(sp)
    800023dc:	6145                	addi	sp,sp,48
    800023de:	8082                	ret

00000000800023e0 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    800023e0:	7179                	addi	sp,sp,-48
    800023e2:	f406                	sd	ra,40(sp)
    800023e4:	f022                	sd	s0,32(sp)
    800023e6:	ec26                	sd	s1,24(sp)
    800023e8:	e84a                	sd	s2,16(sp)
    800023ea:	e44e                	sd	s3,8(sp)
    800023ec:	1800                	addi	s0,sp,48
    800023ee:	892a                	mv	s2,a0
    800023f0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f2:	00010517          	auipc	a0,0x10
    800023f6:	09650513          	addi	a0,a0,150 # 80012488 <bcache>
    800023fa:	00005097          	auipc	ra,0x5
    800023fe:	c9e080e7          	jalr	-866(ra) # 80007098 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002402:	00018497          	auipc	s1,0x18
    80002406:	33e4b483          	ld	s1,830(s1) # 8001a740 <bcache+0x82b8>
    8000240a:	00018797          	auipc	a5,0x18
    8000240e:	2e678793          	addi	a5,a5,742 # 8001a6f0 <bcache+0x8268>
    80002412:	02f48f63          	beq	s1,a5,80002450 <bread+0x70>
    80002416:	873e                	mv	a4,a5
    80002418:	a021                	j	80002420 <bread+0x40>
    8000241a:	68a4                	ld	s1,80(s1)
    8000241c:	02e48a63          	beq	s1,a4,80002450 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002420:	449c                	lw	a5,8(s1)
    80002422:	ff279ce3          	bne	a5,s2,8000241a <bread+0x3a>
    80002426:	44dc                	lw	a5,12(s1)
    80002428:	ff3799e3          	bne	a5,s3,8000241a <bread+0x3a>
      b->refcnt++;
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	2785                	addiw	a5,a5,1
    80002430:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002432:	00010517          	auipc	a0,0x10
    80002436:	05650513          	addi	a0,a0,86 # 80012488 <bcache>
    8000243a:	00005097          	auipc	ra,0x5
    8000243e:	d12080e7          	jalr	-750(ra) # 8000714c <release>
      acquiresleep(&b->lock);
    80002442:	01048513          	addi	a0,s1,16
    80002446:	00001097          	auipc	ra,0x1
    8000244a:	492080e7          	jalr	1170(ra) # 800038d8 <acquiresleep>
      return b;
    8000244e:	a8b9                	j	800024ac <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002450:	00018497          	auipc	s1,0x18
    80002454:	2e84b483          	ld	s1,744(s1) # 8001a738 <bcache+0x82b0>
    80002458:	00018797          	auipc	a5,0x18
    8000245c:	29878793          	addi	a5,a5,664 # 8001a6f0 <bcache+0x8268>
    80002460:	00f48863          	beq	s1,a5,80002470 <bread+0x90>
    80002464:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002466:	40bc                	lw	a5,64(s1)
    80002468:	cf81                	beqz	a5,80002480 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000246a:	64a4                	ld	s1,72(s1)
    8000246c:	fee49de3          	bne	s1,a4,80002466 <bread+0x86>
  panic("bget: no buffers");
    80002470:	00007517          	auipc	a0,0x7
    80002474:	f6850513          	addi	a0,a0,-152 # 800093d8 <etext+0x3d8>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	6a6080e7          	jalr	1702(ra) # 80006b1e <panic>
      b->dev = dev;
    80002480:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002484:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002488:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000248c:	4785                	li	a5,1
    8000248e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002490:	00010517          	auipc	a0,0x10
    80002494:	ff850513          	addi	a0,a0,-8 # 80012488 <bcache>
    80002498:	00005097          	auipc	ra,0x5
    8000249c:	cb4080e7          	jalr	-844(ra) # 8000714c <release>
      acquiresleep(&b->lock);
    800024a0:	01048513          	addi	a0,s1,16
    800024a4:	00001097          	auipc	ra,0x1
    800024a8:	434080e7          	jalr	1076(ra) # 800038d8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    800024ac:	409c                	lw	a5,0(s1)
    800024ae:	cb89                	beqz	a5,800024c0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b0:	8526                	mv	a0,s1
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6145                	addi	sp,sp,48
    800024be:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c0:	4581                	li	a1,0
    800024c2:	8526                	mv	a0,s1
    800024c4:	00003097          	auipc	ra,0x3
    800024c8:	10e080e7          	jalr	270(ra) # 800055d2 <virtio_disk_rw>
    b->valid = 1;
    800024cc:	4785                	li	a5,1
    800024ce:	c09c                	sw	a5,0(s1)
  return b;
    800024d0:	b7c5                	j	800024b0 <bread+0xd0>

00000000800024d2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    800024d2:	1101                	addi	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	1000                	addi	s0,sp,32
    800024dc:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    800024de:	0541                	addi	a0,a0,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	492080e7          	jalr	1170(ra) # 80003972 <holdingsleep>
    800024e8:	cd01                	beqz	a0,80002500 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    800024ea:	4585                	li	a1,1
    800024ec:	8526                	mv	a0,s1
    800024ee:	00003097          	auipc	ra,0x3
    800024f2:	0e4080e7          	jalr	228(ra) # 800055d2 <virtio_disk_rw>
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	64a2                	ld	s1,8(sp)
    800024fc:	6105                	addi	sp,sp,32
    800024fe:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002500:	00007517          	auipc	a0,0x7
    80002504:	ef050513          	addi	a0,a0,-272 # 800093f0 <etext+0x3f0>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	616080e7          	jalr	1558(ra) # 80006b1e <panic>

0000000080002510 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002510:	1101                	addi	sp,sp,-32
    80002512:	ec06                	sd	ra,24(sp)
    80002514:	e822                	sd	s0,16(sp)
    80002516:	e426                	sd	s1,8(sp)
    80002518:	e04a                	sd	s2,0(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    8000251e:	01050913          	addi	s2,a0,16
    80002522:	854a                	mv	a0,s2
    80002524:	00001097          	auipc	ra,0x1
    80002528:	44e080e7          	jalr	1102(ra) # 80003972 <holdingsleep>
    8000252c:	c925                	beqz	a0,8000259c <brelse+0x8c>

  releasesleep(&b->lock);
    8000252e:	854a                	mv	a0,s2
    80002530:	00001097          	auipc	ra,0x1
    80002534:	3fe080e7          	jalr	1022(ra) # 8000392e <releasesleep>

  acquire(&bcache.lock);
    80002538:	00010517          	auipc	a0,0x10
    8000253c:	f5050513          	addi	a0,a0,-176 # 80012488 <bcache>
    80002540:	00005097          	auipc	ra,0x5
    80002544:	b58080e7          	jalr	-1192(ra) # 80007098 <acquire>
  b->refcnt--;
    80002548:	40bc                	lw	a5,64(s1)
    8000254a:	37fd                	addiw	a5,a5,-1
    8000254c:	0007871b          	sext.w	a4,a5
    80002550:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002552:	e71d                	bnez	a4,80002580 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002554:	68b8                	ld	a4,80(s1)
    80002556:	64bc                	ld	a5,72(s1)
    80002558:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000255a:	68b8                	ld	a4,80(s1)
    8000255c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000255e:	00018797          	auipc	a5,0x18
    80002562:	f2a78793          	addi	a5,a5,-214 # 8001a488 <bcache+0x8000>
    80002566:	2b87b703          	ld	a4,696(a5)
    8000256a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256c:	00018717          	auipc	a4,0x18
    80002570:	18470713          	addi	a4,a4,388 # 8001a6f0 <bcache+0x8268>
    80002574:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002576:	2b87b703          	ld	a4,696(a5)
    8000257a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257c:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002580:	00010517          	auipc	a0,0x10
    80002584:	f0850513          	addi	a0,a0,-248 # 80012488 <bcache>
    80002588:	00005097          	auipc	ra,0x5
    8000258c:	bc4080e7          	jalr	-1084(ra) # 8000714c <release>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6902                	ld	s2,0(sp)
    80002598:	6105                	addi	sp,sp,32
    8000259a:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    8000259c:	00007517          	auipc	a0,0x7
    800025a0:	e5c50513          	addi	a0,a0,-420 # 800093f8 <etext+0x3f8>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	57a080e7          	jalr	1402(ra) # 80006b1e <panic>

00000000800025ac <bpin>:

void bpin(struct buf *b) {
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	00010517          	auipc	a0,0x10
    800025bc:	ed050513          	addi	a0,a0,-304 # 80012488 <bcache>
    800025c0:	00005097          	auipc	ra,0x5
    800025c4:	ad8080e7          	jalr	-1320(ra) # 80007098 <acquire>
  b->refcnt++;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	2785                	addiw	a5,a5,1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	00010517          	auipc	a0,0x10
    800025d2:	eba50513          	addi	a0,a0,-326 # 80012488 <bcache>
    800025d6:	00005097          	auipc	ra,0x5
    800025da:	b76080e7          	jalr	-1162(ra) # 8000714c <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bunpin>:

void bunpin(struct buf *b) {
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	addi	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	00010517          	auipc	a0,0x10
    800025f8:	e9450513          	addi	a0,a0,-364 # 80012488 <bcache>
    800025fc:	00005097          	auipc	ra,0x5
    80002600:	a9c080e7          	jalr	-1380(ra) # 80007098 <acquire>
  b->refcnt--;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	37fd                	addiw	a5,a5,-1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	00010517          	auipc	a0,0x10
    8000260e:	e7e50513          	addi	a0,a0,-386 # 80012488 <bcache>
    80002612:	00005097          	auipc	ra,0x5
    80002616:	b3a080e7          	jalr	-1222(ra) # 8000714c <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	e04a                	sd	s2,0(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002632:	00d5d59b          	srliw	a1,a1,0xd
    80002636:	00018797          	auipc	a5,0x18
    8000263a:	52e7a783          	lw	a5,1326(a5) # 8001ab64 <sb+0x1c>
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	00000097          	auipc	ra,0x0
    80002644:	da0080e7          	jalr	-608(ra) # 800023e0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002648:	0074f713          	andi	a4,s1,7
    8000264c:	4785                	li	a5,1
    8000264e:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002652:	14ce                	slli	s1,s1,0x33
    80002654:	90d9                	srli	s1,s1,0x36
    80002656:	00950733          	add	a4,a0,s1
    8000265a:	05874703          	lbu	a4,88(a4)
    8000265e:	00e7f6b3          	and	a3,a5,a4
    80002662:	c69d                	beqz	a3,80002690 <bfree+0x6c>
    80002664:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    80002666:	94aa                	add	s1,s1,a0
    80002668:	fff7c793          	not	a5,a5
    8000266c:	8f7d                	and	a4,a4,a5
    8000266e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002672:	00001097          	auipc	ra,0x1
    80002676:	148080e7          	jalr	328(ra) # 800037ba <log_write>
  brelse(bp);
    8000267a:	854a                	mv	a0,s2
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	e94080e7          	jalr	-364(ra) # 80002510 <brelse>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002690:	00007517          	auipc	a0,0x7
    80002694:	d7050513          	addi	a0,a0,-656 # 80009400 <etext+0x400>
    80002698:	00004097          	auipc	ra,0x4
    8000269c:	486080e7          	jalr	1158(ra) # 80006b1e <panic>

00000000800026a0 <balloc>:
static uint balloc(uint dev) {
    800026a0:	711d                	addi	sp,sp,-96
    800026a2:	ec86                	sd	ra,88(sp)
    800026a4:	e8a2                	sd	s0,80(sp)
    800026a6:	e4a6                	sd	s1,72(sp)
    800026a8:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    800026aa:	00018797          	auipc	a5,0x18
    800026ae:	4a27a783          	lw	a5,1186(a5) # 8001ab4c <sb+0x4>
    800026b2:	10078f63          	beqz	a5,800027d0 <balloc+0x130>
    800026b6:	e0ca                	sd	s2,64(sp)
    800026b8:	fc4e                	sd	s3,56(sp)
    800026ba:	f852                	sd	s4,48(sp)
    800026bc:	f456                	sd	s5,40(sp)
    800026be:	f05a                	sd	s6,32(sp)
    800026c0:	ec5e                	sd	s7,24(sp)
    800026c2:	e862                	sd	s8,16(sp)
    800026c4:	e466                	sd	s9,8(sp)
    800026c6:	8baa                	mv	s7,a0
    800026c8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ca:	00018b17          	auipc	s6,0x18
    800026ce:	47eb0b13          	addi	s6,s6,1150 # 8001ab48 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026d2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d4:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026d6:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800026d8:	6c89                	lui	s9,0x2
    800026da:	a061                	j	80002762 <balloc+0xc2>
        bp->data[bi / 8] |= m;            // Mark block in use.
    800026dc:	97ca                	add	a5,a5,s2
    800026de:	8e55                	or	a2,a2,a3
    800026e0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026e4:	854a                	mv	a0,s2
    800026e6:	00001097          	auipc	ra,0x1
    800026ea:	0d4080e7          	jalr	212(ra) # 800037ba <log_write>
        brelse(bp);
    800026ee:	854a                	mv	a0,s2
    800026f0:	00000097          	auipc	ra,0x0
    800026f4:	e20080e7          	jalr	-480(ra) # 80002510 <brelse>
  bp = bread(dev, bno);
    800026f8:	85a6                	mv	a1,s1
    800026fa:	855e                	mv	a0,s7
    800026fc:	00000097          	auipc	ra,0x0
    80002700:	ce4080e7          	jalr	-796(ra) # 800023e0 <bread>
    80002704:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002706:	40000613          	li	a2,1024
    8000270a:	4581                	li	a1,0
    8000270c:	05850513          	addi	a0,a0,88
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	a6a080e7          	jalr	-1430(ra) # 8000017a <memset>
  log_write(bp);
    80002718:	854a                	mv	a0,s2
    8000271a:	00001097          	auipc	ra,0x1
    8000271e:	0a0080e7          	jalr	160(ra) # 800037ba <log_write>
  brelse(bp);
    80002722:	854a                	mv	a0,s2
    80002724:	00000097          	auipc	ra,0x0
    80002728:	dec080e7          	jalr	-532(ra) # 80002510 <brelse>
}
    8000272c:	6906                	ld	s2,64(sp)
    8000272e:	79e2                	ld	s3,56(sp)
    80002730:	7a42                	ld	s4,48(sp)
    80002732:	7aa2                	ld	s5,40(sp)
    80002734:	7b02                	ld	s6,32(sp)
    80002736:	6be2                	ld	s7,24(sp)
    80002738:	6c42                	ld	s8,16(sp)
    8000273a:	6ca2                	ld	s9,8(sp)
}
    8000273c:	8526                	mv	a0,s1
    8000273e:	60e6                	ld	ra,88(sp)
    80002740:	6446                	ld	s0,80(sp)
    80002742:	64a6                	ld	s1,72(sp)
    80002744:	6125                	addi	sp,sp,96
    80002746:	8082                	ret
    brelse(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	dc6080e7          	jalr	-570(ra) # 80002510 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002752:	015c87bb          	addw	a5,s9,s5
    80002756:	00078a9b          	sext.w	s5,a5
    8000275a:	004b2703          	lw	a4,4(s6)
    8000275e:	06eaf163          	bgeu	s5,a4,800027c0 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002762:	41fad79b          	sraiw	a5,s5,0x1f
    80002766:	0137d79b          	srliw	a5,a5,0x13
    8000276a:	015787bb          	addw	a5,a5,s5
    8000276e:	40d7d79b          	sraiw	a5,a5,0xd
    80002772:	01cb2583          	lw	a1,28(s6)
    80002776:	9dbd                	addw	a1,a1,a5
    80002778:	855e                	mv	a0,s7
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	c66080e7          	jalr	-922(ra) # 800023e0 <bread>
    80002782:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002784:	004b2503          	lw	a0,4(s6)
    80002788:	000a849b          	sext.w	s1,s5
    8000278c:	8762                	mv	a4,s8
    8000278e:	faa4fde3          	bgeu	s1,a0,80002748 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002792:	00777693          	andi	a3,a4,7
    80002796:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    8000279a:	41f7579b          	sraiw	a5,a4,0x1f
    8000279e:	01d7d79b          	srliw	a5,a5,0x1d
    800027a2:	9fb9                	addw	a5,a5,a4
    800027a4:	4037d79b          	sraiw	a5,a5,0x3
    800027a8:	00f90633          	add	a2,s2,a5
    800027ac:	05864603          	lbu	a2,88(a2)
    800027b0:	00c6f5b3          	and	a1,a3,a2
    800027b4:	d585                	beqz	a1,800026dc <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027b6:	2705                	addiw	a4,a4,1
    800027b8:	2485                	addiw	s1,s1,1
    800027ba:	fd471ae3          	bne	a4,s4,8000278e <balloc+0xee>
    800027be:	b769                	j	80002748 <balloc+0xa8>
    800027c0:	6906                	ld	s2,64(sp)
    800027c2:	79e2                	ld	s3,56(sp)
    800027c4:	7a42                	ld	s4,48(sp)
    800027c6:	7aa2                	ld	s5,40(sp)
    800027c8:	7b02                	ld	s6,32(sp)
    800027ca:	6be2                	ld	s7,24(sp)
    800027cc:	6c42                	ld	s8,16(sp)
    800027ce:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800027d0:	00007517          	auipc	a0,0x7
    800027d4:	c4850513          	addi	a0,a0,-952 # 80009418 <etext+0x418>
    800027d8:	00004097          	auipc	ra,0x4
    800027dc:	390080e7          	jalr	912(ra) # 80006b68 <printf>
  return 0;
    800027e0:	4481                	li	s1,0
    800027e2:	bfa9                	j	8000273c <balloc+0x9c>

00000000800027e4 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    800027e4:	7179                	addi	sp,sp,-48
    800027e6:	f406                	sd	ra,40(sp)
    800027e8:	f022                	sd	s0,32(sp)
    800027ea:	ec26                	sd	s1,24(sp)
    800027ec:	e84a                	sd	s2,16(sp)
    800027ee:	e44e                	sd	s3,8(sp)
    800027f0:	1800                	addi	s0,sp,48
    800027f2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800027f4:	47ad                	li	a5,11
    800027f6:	02b7e863          	bltu	a5,a1,80002826 <bmap+0x42>
    if ((addr = ip->addrs[bn]) == 0) {
    800027fa:	02059793          	slli	a5,a1,0x20
    800027fe:	01e7d593          	srli	a1,a5,0x1e
    80002802:	00b504b3          	add	s1,a0,a1
    80002806:	0504a903          	lw	s2,80(s1)
    8000280a:	08091263          	bnez	s2,8000288e <bmap+0xaa>
      addr = balloc(ip->dev);
    8000280e:	4108                	lw	a0,0(a0)
    80002810:	00000097          	auipc	ra,0x0
    80002814:	e90080e7          	jalr	-368(ra) # 800026a0 <balloc>
    80002818:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    8000281c:	06090963          	beqz	s2,8000288e <bmap+0xaa>
      ip->addrs[bn] = addr;
    80002820:	0524a823          	sw	s2,80(s1)
    80002824:	a0ad                	j	8000288e <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002826:	ff45849b          	addiw	s1,a1,-12
    8000282a:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    8000282e:	0ff00793          	li	a5,255
    80002832:	08e7e863          	bltu	a5,a4,800028c2 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002836:	08052903          	lw	s2,128(a0)
    8000283a:	00091f63          	bnez	s2,80002858 <bmap+0x74>
      addr = balloc(ip->dev);
    8000283e:	4108                	lw	a0,0(a0)
    80002840:	00000097          	auipc	ra,0x0
    80002844:	e60080e7          	jalr	-416(ra) # 800026a0 <balloc>
    80002848:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    8000284c:	04090163          	beqz	s2,8000288e <bmap+0xaa>
    80002850:	e052                	sd	s4,0(sp)
      ip->addrs[NDIRECT] = addr;
    80002852:	0929a023          	sw	s2,128(s3)
    80002856:	a011                	j	8000285a <bmap+0x76>
    80002858:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000285a:	85ca                	mv	a1,s2
    8000285c:	0009a503          	lw	a0,0(s3)
    80002860:	00000097          	auipc	ra,0x0
    80002864:	b80080e7          	jalr	-1152(ra) # 800023e0 <bread>
    80002868:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000286a:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000286e:	02049713          	slli	a4,s1,0x20
    80002872:	01e75593          	srli	a1,a4,0x1e
    80002876:	00b784b3          	add	s1,a5,a1
    8000287a:	0004a903          	lw	s2,0(s1)
    8000287e:	02090063          	beqz	s2,8000289e <bmap+0xba>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002882:	8552                	mv	a0,s4
    80002884:	00000097          	auipc	ra,0x0
    80002888:	c8c080e7          	jalr	-884(ra) # 80002510 <brelse>
    return addr;
    8000288c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000288e:	854a                	mv	a0,s2
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6145                	addi	sp,sp,48
    8000289c:	8082                	ret
      addr = balloc(ip->dev);
    8000289e:	0009a503          	lw	a0,0(s3)
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	dfe080e7          	jalr	-514(ra) # 800026a0 <balloc>
    800028aa:	0005091b          	sext.w	s2,a0
      if (addr) {
    800028ae:	fc090ae3          	beqz	s2,80002882 <bmap+0x9e>
        a[bn] = addr;
    800028b2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028b6:	8552                	mv	a0,s4
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	f02080e7          	jalr	-254(ra) # 800037ba <log_write>
    800028c0:	b7c9                	j	80002882 <bmap+0x9e>
    800028c2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800028c4:	00007517          	auipc	a0,0x7
    800028c8:	b6c50513          	addi	a0,a0,-1172 # 80009430 <etext+0x430>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	252080e7          	jalr	594(ra) # 80006b1e <panic>

00000000800028d4 <iget>:
static struct inode *iget(uint dev, uint inum) {
    800028d4:	7179                	addi	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	e052                	sd	s4,0(sp)
    800028e2:	1800                	addi	s0,sp,48
    800028e4:	89aa                	mv	s3,a0
    800028e6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028e8:	00018517          	auipc	a0,0x18
    800028ec:	28050513          	addi	a0,a0,640 # 8001ab68 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	7a8080e7          	jalr	1960(ra) # 80007098 <acquire>
  empty = 0;
    800028f8:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800028fa:	00018497          	auipc	s1,0x18
    800028fe:	28648493          	addi	s1,s1,646 # 8001ab80 <itable+0x18>
    80002902:	0001a697          	auipc	a3,0x1a
    80002906:	d0e68693          	addi	a3,a3,-754 # 8001c610 <log>
    8000290a:	a039                	j	80002918 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    8000290c:	02090b63          	beqz	s2,80002942 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002910:	08848493          	addi	s1,s1,136
    80002914:	02d48a63          	beq	s1,a3,80002948 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002918:	449c                	lw	a5,8(s1)
    8000291a:	fef059e3          	blez	a5,8000290c <iget+0x38>
    8000291e:	4098                	lw	a4,0(s1)
    80002920:	ff3716e3          	bne	a4,s3,8000290c <iget+0x38>
    80002924:	40d8                	lw	a4,4(s1)
    80002926:	ff4713e3          	bne	a4,s4,8000290c <iget+0x38>
      ip->ref++;
    8000292a:	2785                	addiw	a5,a5,1
    8000292c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000292e:	00018517          	auipc	a0,0x18
    80002932:	23a50513          	addi	a0,a0,570 # 8001ab68 <itable>
    80002936:	00005097          	auipc	ra,0x5
    8000293a:	816080e7          	jalr	-2026(ra) # 8000714c <release>
      return ip;
    8000293e:	8926                	mv	s2,s1
    80002940:	a03d                	j	8000296e <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002942:	f7f9                	bnez	a5,80002910 <iget+0x3c>
      empty = ip;
    80002944:	8926                	mv	s2,s1
    80002946:	b7e9                	j	80002910 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002948:	02090c63          	beqz	s2,80002980 <iget+0xac>
  ip->dev = dev;
    8000294c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002950:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002954:	4785                	li	a5,1
    80002956:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000295a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000295e:	00018517          	auipc	a0,0x18
    80002962:	20a50513          	addi	a0,a0,522 # 8001ab68 <itable>
    80002966:	00004097          	auipc	ra,0x4
    8000296a:	7e6080e7          	jalr	2022(ra) # 8000714c <release>
}
    8000296e:	854a                	mv	a0,s2
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6a02                	ld	s4,0(sp)
    8000297c:	6145                	addi	sp,sp,48
    8000297e:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002980:	00007517          	auipc	a0,0x7
    80002984:	ac850513          	addi	a0,a0,-1336 # 80009448 <etext+0x448>
    80002988:	00004097          	auipc	ra,0x4
    8000298c:	196080e7          	jalr	406(ra) # 80006b1e <panic>

0000000080002990 <fsinit>:
void fsinit(int dev) {
    80002990:	7179                	addi	sp,sp,-48
    80002992:	f406                	sd	ra,40(sp)
    80002994:	f022                	sd	s0,32(sp)
    80002996:	ec26                	sd	s1,24(sp)
    80002998:	e84a                	sd	s2,16(sp)
    8000299a:	e44e                	sd	s3,8(sp)
    8000299c:	1800                	addi	s0,sp,48
    8000299e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029a0:	4585                	li	a1,1
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a3e080e7          	jalr	-1474(ra) # 800023e0 <bread>
    800029aa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029ac:	00018997          	auipc	s3,0x18
    800029b0:	19c98993          	addi	s3,s3,412 # 8001ab48 <sb>
    800029b4:	02000613          	li	a2,32
    800029b8:	05850593          	addi	a1,a0,88
    800029bc:	854e                	mv	a0,s3
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	818080e7          	jalr	-2024(ra) # 800001d6 <memmove>
  brelse(bp);
    800029c6:	8526                	mv	a0,s1
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	b48080e7          	jalr	-1208(ra) # 80002510 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    800029d0:	0009a703          	lw	a4,0(s3)
    800029d4:	102037b7          	lui	a5,0x10203
    800029d8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029dc:	02f71263          	bne	a4,a5,80002a00 <fsinit+0x70>
  initlog(dev, &sb);
    800029e0:	00018597          	auipc	a1,0x18
    800029e4:	16858593          	addi	a1,a1,360 # 8001ab48 <sb>
    800029e8:	854a                	mv	a0,s2
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	b60080e7          	jalr	-1184(ra) # 8000354a <initlog>
}
    800029f2:	70a2                	ld	ra,40(sp)
    800029f4:	7402                	ld	s0,32(sp)
    800029f6:	64e2                	ld	s1,24(sp)
    800029f8:	6942                	ld	s2,16(sp)
    800029fa:	69a2                	ld	s3,8(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002a00:	00007517          	auipc	a0,0x7
    80002a04:	a5850513          	addi	a0,a0,-1448 # 80009458 <etext+0x458>
    80002a08:	00004097          	auipc	ra,0x4
    80002a0c:	116080e7          	jalr	278(ra) # 80006b1e <panic>

0000000080002a10 <iinit>:
void iinit() {
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a1e:	00007597          	auipc	a1,0x7
    80002a22:	a5258593          	addi	a1,a1,-1454 # 80009470 <etext+0x470>
    80002a26:	00018517          	auipc	a0,0x18
    80002a2a:	14250513          	addi	a0,a0,322 # 8001ab68 <itable>
    80002a2e:	00004097          	auipc	ra,0x4
    80002a32:	5da080e7          	jalr	1498(ra) # 80007008 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002a36:	00018497          	auipc	s1,0x18
    80002a3a:	15a48493          	addi	s1,s1,346 # 8001ab90 <itable+0x28>
    80002a3e:	0001a997          	auipc	s3,0x1a
    80002a42:	be298993          	addi	s3,s3,-1054 # 8001c620 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a46:	00007917          	auipc	s2,0x7
    80002a4a:	a3290913          	addi	s2,s2,-1486 # 80009478 <etext+0x478>
    80002a4e:	85ca                	mv	a1,s2
    80002a50:	8526                	mv	a0,s1
    80002a52:	00001097          	auipc	ra,0x1
    80002a56:	e4c080e7          	jalr	-436(ra) # 8000389e <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002a5a:	08848493          	addi	s1,s1,136
    80002a5e:	ff3498e3          	bne	s1,s3,80002a4e <iinit+0x3e>
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6145                	addi	sp,sp,48
    80002a6e:	8082                	ret

0000000080002a70 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002a70:	7139                	addi	sp,sp,-64
    80002a72:	fc06                	sd	ra,56(sp)
    80002a74:	f822                	sd	s0,48(sp)
    80002a76:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a78:	00018717          	auipc	a4,0x18
    80002a7c:	0dc72703          	lw	a4,220(a4) # 8001ab54 <sb+0xc>
    80002a80:	4785                	li	a5,1
    80002a82:	06e7f463          	bgeu	a5,a4,80002aea <ialloc+0x7a>
    80002a86:	f426                	sd	s1,40(sp)
    80002a88:	f04a                	sd	s2,32(sp)
    80002a8a:	ec4e                	sd	s3,24(sp)
    80002a8c:	e852                	sd	s4,16(sp)
    80002a8e:	e456                	sd	s5,8(sp)
    80002a90:	e05a                	sd	s6,0(sp)
    80002a92:	8aaa                	mv	s5,a0
    80002a94:	8b2e                	mv	s6,a1
    80002a96:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a98:	00018a17          	auipc	s4,0x18
    80002a9c:	0b0a0a13          	addi	s4,s4,176 # 8001ab48 <sb>
    80002aa0:	00495593          	srli	a1,s2,0x4
    80002aa4:	018a2783          	lw	a5,24(s4)
    80002aa8:	9dbd                	addw	a1,a1,a5
    80002aaa:	8556                	mv	a0,s5
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	934080e7          	jalr	-1740(ra) # 800023e0 <bread>
    80002ab4:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002ab6:	05850993          	addi	s3,a0,88
    80002aba:	00f97793          	andi	a5,s2,15
    80002abe:	079a                	slli	a5,a5,0x6
    80002ac0:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002ac2:	00099783          	lh	a5,0(s3)
    80002ac6:	cf9d                	beqz	a5,80002b04 <ialloc+0x94>
    brelse(bp);
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	a48080e7          	jalr	-1464(ra) # 80002510 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002ad0:	0905                	addi	s2,s2,1
    80002ad2:	00ca2703          	lw	a4,12(s4)
    80002ad6:	0009079b          	sext.w	a5,s2
    80002ada:	fce7e3e3          	bltu	a5,a4,80002aa0 <ialloc+0x30>
    80002ade:	74a2                	ld	s1,40(sp)
    80002ae0:	7902                	ld	s2,32(sp)
    80002ae2:	69e2                	ld	s3,24(sp)
    80002ae4:	6a42                	ld	s4,16(sp)
    80002ae6:	6aa2                	ld	s5,8(sp)
    80002ae8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002aea:	00007517          	auipc	a0,0x7
    80002aee:	99650513          	addi	a0,a0,-1642 # 80009480 <etext+0x480>
    80002af2:	00004097          	auipc	ra,0x4
    80002af6:	076080e7          	jalr	118(ra) # 80006b68 <printf>
  return 0;
    80002afa:	4501                	li	a0,0
}
    80002afc:	70e2                	ld	ra,56(sp)
    80002afe:	7442                	ld	s0,48(sp)
    80002b00:	6121                	addi	sp,sp,64
    80002b02:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b04:	04000613          	li	a2,64
    80002b08:	4581                	li	a1,0
    80002b0a:	854e                	mv	a0,s3
    80002b0c:	ffffd097          	auipc	ra,0xffffd
    80002b10:	66e080e7          	jalr	1646(ra) # 8000017a <memset>
      dip->type = type;
    80002b14:	01699023          	sh	s6,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002b18:	8526                	mv	a0,s1
    80002b1a:	00001097          	auipc	ra,0x1
    80002b1e:	ca0080e7          	jalr	-864(ra) # 800037ba <log_write>
      brelse(bp);
    80002b22:	8526                	mv	a0,s1
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	9ec080e7          	jalr	-1556(ra) # 80002510 <brelse>
      return iget(dev, inum);
    80002b2c:	0009059b          	sext.w	a1,s2
    80002b30:	8556                	mv	a0,s5
    80002b32:	00000097          	auipc	ra,0x0
    80002b36:	da2080e7          	jalr	-606(ra) # 800028d4 <iget>
    80002b3a:	74a2                	ld	s1,40(sp)
    80002b3c:	7902                	ld	s2,32(sp)
    80002b3e:	69e2                	ld	s3,24(sp)
    80002b40:	6a42                	ld	s4,16(sp)
    80002b42:	6aa2                	ld	s5,8(sp)
    80002b44:	6b02                	ld	s6,0(sp)
    80002b46:	bf5d                	j	80002afc <ialloc+0x8c>

0000000080002b48 <iupdate>:
void iupdate(struct inode *ip) {
    80002b48:	1101                	addi	sp,sp,-32
    80002b4a:	ec06                	sd	ra,24(sp)
    80002b4c:	e822                	sd	s0,16(sp)
    80002b4e:	e426                	sd	s1,8(sp)
    80002b50:	e04a                	sd	s2,0(sp)
    80002b52:	1000                	addi	s0,sp,32
    80002b54:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b56:	415c                	lw	a5,4(a0)
    80002b58:	0047d79b          	srliw	a5,a5,0x4
    80002b5c:	00018597          	auipc	a1,0x18
    80002b60:	0045a583          	lw	a1,4(a1) # 8001ab60 <sb+0x18>
    80002b64:	9dbd                	addw	a1,a1,a5
    80002b66:	4108                	lw	a0,0(a0)
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	878080e7          	jalr	-1928(ra) # 800023e0 <bread>
    80002b70:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b72:	05850793          	addi	a5,a0,88
    80002b76:	40d8                	lw	a4,4(s1)
    80002b78:	8b3d                	andi	a4,a4,15
    80002b7a:	071a                	slli	a4,a4,0x6
    80002b7c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b7e:	04449703          	lh	a4,68(s1)
    80002b82:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b86:	04649703          	lh	a4,70(s1)
    80002b8a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b8e:	04849703          	lh	a4,72(s1)
    80002b92:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b96:	04a49703          	lh	a4,74(s1)
    80002b9a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b9e:	44f8                	lw	a4,76(s1)
    80002ba0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ba2:	03400613          	li	a2,52
    80002ba6:	05048593          	addi	a1,s1,80
    80002baa:	00c78513          	addi	a0,a5,12
    80002bae:	ffffd097          	auipc	ra,0xffffd
    80002bb2:	628080e7          	jalr	1576(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	c02080e7          	jalr	-1022(ra) # 800037ba <log_write>
  brelse(bp);
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	94e080e7          	jalr	-1714(ra) # 80002510 <brelse>
}
    80002bca:	60e2                	ld	ra,24(sp)
    80002bcc:	6442                	ld	s0,16(sp)
    80002bce:	64a2                	ld	s1,8(sp)
    80002bd0:	6902                	ld	s2,0(sp)
    80002bd2:	6105                	addi	sp,sp,32
    80002bd4:	8082                	ret

0000000080002bd6 <idup>:
struct inode *idup(struct inode *ip) {
    80002bd6:	1101                	addi	sp,sp,-32
    80002bd8:	ec06                	sd	ra,24(sp)
    80002bda:	e822                	sd	s0,16(sp)
    80002bdc:	e426                	sd	s1,8(sp)
    80002bde:	1000                	addi	s0,sp,32
    80002be0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002be2:	00018517          	auipc	a0,0x18
    80002be6:	f8650513          	addi	a0,a0,-122 # 8001ab68 <itable>
    80002bea:	00004097          	auipc	ra,0x4
    80002bee:	4ae080e7          	jalr	1198(ra) # 80007098 <acquire>
  ip->ref++;
    80002bf2:	449c                	lw	a5,8(s1)
    80002bf4:	2785                	addiw	a5,a5,1
    80002bf6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bf8:	00018517          	auipc	a0,0x18
    80002bfc:	f7050513          	addi	a0,a0,-144 # 8001ab68 <itable>
    80002c00:	00004097          	auipc	ra,0x4
    80002c04:	54c080e7          	jalr	1356(ra) # 8000714c <release>
}
    80002c08:	8526                	mv	a0,s1
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	64a2                	ld	s1,8(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret

0000000080002c14 <ilock>:
void ilock(struct inode *ip) {
    80002c14:	1101                	addi	sp,sp,-32
    80002c16:	ec06                	sd	ra,24(sp)
    80002c18:	e822                	sd	s0,16(sp)
    80002c1a:	e426                	sd	s1,8(sp)
    80002c1c:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c1e:	c10d                	beqz	a0,80002c40 <ilock+0x2c>
    80002c20:	84aa                	mv	s1,a0
    80002c22:	451c                	lw	a5,8(a0)
    80002c24:	00f05e63          	blez	a5,80002c40 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c28:	0541                	addi	a0,a0,16
    80002c2a:	00001097          	auipc	ra,0x1
    80002c2e:	cae080e7          	jalr	-850(ra) # 800038d8 <acquiresleep>
  if (ip->valid == 0) {
    80002c32:	40bc                	lw	a5,64(s1)
    80002c34:	cf99                	beqz	a5,80002c52 <ilock+0x3e>
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6105                	addi	sp,sp,32
    80002c3e:	8082                	ret
    80002c40:	e04a                	sd	s2,0(sp)
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c42:	00007517          	auipc	a0,0x7
    80002c46:	85650513          	addi	a0,a0,-1962 # 80009498 <etext+0x498>
    80002c4a:	00004097          	auipc	ra,0x4
    80002c4e:	ed4080e7          	jalr	-300(ra) # 80006b1e <panic>
    80002c52:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c54:	40dc                	lw	a5,4(s1)
    80002c56:	0047d79b          	srliw	a5,a5,0x4
    80002c5a:	00018597          	auipc	a1,0x18
    80002c5e:	f065a583          	lw	a1,-250(a1) # 8001ab60 <sb+0x18>
    80002c62:	9dbd                	addw	a1,a1,a5
    80002c64:	4088                	lw	a0,0(s1)
    80002c66:	fffff097          	auipc	ra,0xfffff
    80002c6a:	77a080e7          	jalr	1914(ra) # 800023e0 <bread>
    80002c6e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c70:	05850593          	addi	a1,a0,88
    80002c74:	40dc                	lw	a5,4(s1)
    80002c76:	8bbd                	andi	a5,a5,15
    80002c78:	079a                	slli	a5,a5,0x6
    80002c7a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c7c:	00059783          	lh	a5,0(a1)
    80002c80:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c84:	00259783          	lh	a5,2(a1)
    80002c88:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c8c:	00459783          	lh	a5,4(a1)
    80002c90:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c94:	00659783          	lh	a5,6(a1)
    80002c98:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c9c:	459c                	lw	a5,8(a1)
    80002c9e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ca0:	03400613          	li	a2,52
    80002ca4:	05b1                	addi	a1,a1,12
    80002ca6:	05048513          	addi	a0,s1,80
    80002caa:	ffffd097          	auipc	ra,0xffffd
    80002cae:	52c080e7          	jalr	1324(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cb2:	854a                	mv	a0,s2
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	85c080e7          	jalr	-1956(ra) # 80002510 <brelse>
    ip->valid = 1;
    80002cbc:	4785                	li	a5,1
    80002cbe:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002cc0:	04449783          	lh	a5,68(s1)
    80002cc4:	c399                	beqz	a5,80002cca <ilock+0xb6>
    80002cc6:	6902                	ld	s2,0(sp)
    80002cc8:	b7bd                	j	80002c36 <ilock+0x22>
    80002cca:	00006517          	auipc	a0,0x6
    80002cce:	7d650513          	addi	a0,a0,2006 # 800094a0 <etext+0x4a0>
    80002cd2:	00004097          	auipc	ra,0x4
    80002cd6:	e4c080e7          	jalr	-436(ra) # 80006b1e <panic>

0000000080002cda <iunlock>:
void iunlock(struct inode *ip) {
    80002cda:	1101                	addi	sp,sp,-32
    80002cdc:	ec06                	sd	ra,24(sp)
    80002cde:	e822                	sd	s0,16(sp)
    80002ce0:	e426                	sd	s1,8(sp)
    80002ce2:	e04a                	sd	s2,0(sp)
    80002ce4:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002ce6:	c905                	beqz	a0,80002d16 <iunlock+0x3c>
    80002ce8:	84aa                	mv	s1,a0
    80002cea:	01050913          	addi	s2,a0,16
    80002cee:	854a                	mv	a0,s2
    80002cf0:	00001097          	auipc	ra,0x1
    80002cf4:	c82080e7          	jalr	-894(ra) # 80003972 <holdingsleep>
    80002cf8:	cd19                	beqz	a0,80002d16 <iunlock+0x3c>
    80002cfa:	449c                	lw	a5,8(s1)
    80002cfc:	00f05d63          	blez	a5,80002d16 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d00:	854a                	mv	a0,s2
    80002d02:	00001097          	auipc	ra,0x1
    80002d06:	c2c080e7          	jalr	-980(ra) # 8000392e <releasesleep>
}
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	64a2                	ld	s1,8(sp)
    80002d10:	6902                	ld	s2,0(sp)
    80002d12:	6105                	addi	sp,sp,32
    80002d14:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002d16:	00006517          	auipc	a0,0x6
    80002d1a:	79a50513          	addi	a0,a0,1946 # 800094b0 <etext+0x4b0>
    80002d1e:	00004097          	auipc	ra,0x4
    80002d22:	e00080e7          	jalr	-512(ra) # 80006b1e <panic>

0000000080002d26 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002d26:	7179                	addi	sp,sp,-48
    80002d28:	f406                	sd	ra,40(sp)
    80002d2a:	f022                	sd	s0,32(sp)
    80002d2c:	ec26                	sd	s1,24(sp)
    80002d2e:	e84a                	sd	s2,16(sp)
    80002d30:	e44e                	sd	s3,8(sp)
    80002d32:	1800                	addi	s0,sp,48
    80002d34:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002d36:	05050493          	addi	s1,a0,80
    80002d3a:	08050913          	addi	s2,a0,128
    80002d3e:	a021                	j	80002d46 <itrunc+0x20>
    80002d40:	0491                	addi	s1,s1,4
    80002d42:	01248d63          	beq	s1,s2,80002d5c <itrunc+0x36>
    if (ip->addrs[i]) {
    80002d46:	408c                	lw	a1,0(s1)
    80002d48:	dde5                	beqz	a1,80002d40 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d4a:	0009a503          	lw	a0,0(s3)
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	8d6080e7          	jalr	-1834(ra) # 80002624 <bfree>
      ip->addrs[i] = 0;
    80002d56:	0004a023          	sw	zero,0(s1)
    80002d5a:	b7dd                	j	80002d40 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002d5c:	0809a583          	lw	a1,128(s3)
    80002d60:	ed99                	bnez	a1,80002d7e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d62:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d66:	854e                	mv	a0,s3
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	de0080e7          	jalr	-544(ra) # 80002b48 <iupdate>
}
    80002d70:	70a2                	ld	ra,40(sp)
    80002d72:	7402                	ld	s0,32(sp)
    80002d74:	64e2                	ld	s1,24(sp)
    80002d76:	6942                	ld	s2,16(sp)
    80002d78:	69a2                	ld	s3,8(sp)
    80002d7a:	6145                	addi	sp,sp,48
    80002d7c:	8082                	ret
    80002d7e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d80:	0009a503          	lw	a0,0(s3)
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	65c080e7          	jalr	1628(ra) # 800023e0 <bread>
    80002d8c:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002d8e:	05850493          	addi	s1,a0,88
    80002d92:	45850913          	addi	s2,a0,1112
    80002d96:	a021                	j	80002d9e <itrunc+0x78>
    80002d98:	0491                	addi	s1,s1,4
    80002d9a:	01248b63          	beq	s1,s2,80002db0 <itrunc+0x8a>
      if (a[j]) bfree(ip->dev, a[j]);
    80002d9e:	408c                	lw	a1,0(s1)
    80002da0:	dde5                	beqz	a1,80002d98 <itrunc+0x72>
    80002da2:	0009a503          	lw	a0,0(s3)
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	87e080e7          	jalr	-1922(ra) # 80002624 <bfree>
    80002dae:	b7ed                	j	80002d98 <itrunc+0x72>
    brelse(bp);
    80002db0:	8552                	mv	a0,s4
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	75e080e7          	jalr	1886(ra) # 80002510 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dba:	0809a583          	lw	a1,128(s3)
    80002dbe:	0009a503          	lw	a0,0(s3)
    80002dc2:	00000097          	auipc	ra,0x0
    80002dc6:	862080e7          	jalr	-1950(ra) # 80002624 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dca:	0809a023          	sw	zero,128(s3)
    80002dce:	6a02                	ld	s4,0(sp)
    80002dd0:	bf49                	j	80002d62 <itrunc+0x3c>

0000000080002dd2 <iput>:
void iput(struct inode *ip) {
    80002dd2:	1101                	addi	sp,sp,-32
    80002dd4:	ec06                	sd	ra,24(sp)
    80002dd6:	e822                	sd	s0,16(sp)
    80002dd8:	e426                	sd	s1,8(sp)
    80002dda:	1000                	addi	s0,sp,32
    80002ddc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dde:	00018517          	auipc	a0,0x18
    80002de2:	d8a50513          	addi	a0,a0,-630 # 8001ab68 <itable>
    80002de6:	00004097          	auipc	ra,0x4
    80002dea:	2b2080e7          	jalr	690(ra) # 80007098 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002dee:	4498                	lw	a4,8(s1)
    80002df0:	4785                	li	a5,1
    80002df2:	02f70263          	beq	a4,a5,80002e16 <iput+0x44>
  ip->ref--;
    80002df6:	449c                	lw	a5,8(s1)
    80002df8:	37fd                	addiw	a5,a5,-1
    80002dfa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dfc:	00018517          	auipc	a0,0x18
    80002e00:	d6c50513          	addi	a0,a0,-660 # 8001ab68 <itable>
    80002e04:	00004097          	auipc	ra,0x4
    80002e08:	348080e7          	jalr	840(ra) # 8000714c <release>
}
    80002e0c:	60e2                	ld	ra,24(sp)
    80002e0e:	6442                	ld	s0,16(sp)
    80002e10:	64a2                	ld	s1,8(sp)
    80002e12:	6105                	addi	sp,sp,32
    80002e14:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002e16:	40bc                	lw	a5,64(s1)
    80002e18:	dff9                	beqz	a5,80002df6 <iput+0x24>
    80002e1a:	04a49783          	lh	a5,74(s1)
    80002e1e:	ffe1                	bnez	a5,80002df6 <iput+0x24>
    80002e20:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e22:	01048913          	addi	s2,s1,16
    80002e26:	854a                	mv	a0,s2
    80002e28:	00001097          	auipc	ra,0x1
    80002e2c:	ab0080e7          	jalr	-1360(ra) # 800038d8 <acquiresleep>
    release(&itable.lock);
    80002e30:	00018517          	auipc	a0,0x18
    80002e34:	d3850513          	addi	a0,a0,-712 # 8001ab68 <itable>
    80002e38:	00004097          	auipc	ra,0x4
    80002e3c:	314080e7          	jalr	788(ra) # 8000714c <release>
    itrunc(ip);
    80002e40:	8526                	mv	a0,s1
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	ee4080e7          	jalr	-284(ra) # 80002d26 <itrunc>
    ip->type = 0;
    80002e4a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e4e:	8526                	mv	a0,s1
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	cf8080e7          	jalr	-776(ra) # 80002b48 <iupdate>
    ip->valid = 0;
    80002e58:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e5c:	854a                	mv	a0,s2
    80002e5e:	00001097          	auipc	ra,0x1
    80002e62:	ad0080e7          	jalr	-1328(ra) # 8000392e <releasesleep>
    acquire(&itable.lock);
    80002e66:	00018517          	auipc	a0,0x18
    80002e6a:	d0250513          	addi	a0,a0,-766 # 8001ab68 <itable>
    80002e6e:	00004097          	auipc	ra,0x4
    80002e72:	22a080e7          	jalr	554(ra) # 80007098 <acquire>
    80002e76:	6902                	ld	s2,0(sp)
    80002e78:	bfbd                	j	80002df6 <iput+0x24>

0000000080002e7a <iunlockput>:
void iunlockput(struct inode *ip) {
    80002e7a:	1101                	addi	sp,sp,-32
    80002e7c:	ec06                	sd	ra,24(sp)
    80002e7e:	e822                	sd	s0,16(sp)
    80002e80:	e426                	sd	s1,8(sp)
    80002e82:	1000                	addi	s0,sp,32
    80002e84:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	e54080e7          	jalr	-428(ra) # 80002cda <iunlock>
  iput(ip);
    80002e8e:	8526                	mv	a0,s1
    80002e90:	00000097          	auipc	ra,0x0
    80002e94:	f42080e7          	jalr	-190(ra) # 80002dd2 <iput>
}
    80002e98:	60e2                	ld	ra,24(sp)
    80002e9a:	6442                	ld	s0,16(sp)
    80002e9c:	64a2                	ld	s1,8(sp)
    80002e9e:	6105                	addi	sp,sp,32
    80002ea0:	8082                	ret

0000000080002ea2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002ea2:	1141                	addi	sp,sp,-16
    80002ea4:	e422                	sd	s0,8(sp)
    80002ea6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ea8:	411c                	lw	a5,0(a0)
    80002eaa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eac:	415c                	lw	a5,4(a0)
    80002eae:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eb0:	04451783          	lh	a5,68(a0)
    80002eb4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eb8:	04a51783          	lh	a5,74(a0)
    80002ebc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ec0:	04c56783          	lwu	a5,76(a0)
    80002ec4:	e99c                	sd	a5,16(a1)
}
    80002ec6:	6422                	ld	s0,8(sp)
    80002ec8:	0141                	addi	sp,sp,16
    80002eca:	8082                	ret

0000000080002ecc <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002ecc:	457c                	lw	a5,76(a0)
    80002ece:	10d7e563          	bltu	a5,a3,80002fd8 <readi+0x10c>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002ed2:	7159                	addi	sp,sp,-112
    80002ed4:	f486                	sd	ra,104(sp)
    80002ed6:	f0a2                	sd	s0,96(sp)
    80002ed8:	eca6                	sd	s1,88(sp)
    80002eda:	e0d2                	sd	s4,64(sp)
    80002edc:	fc56                	sd	s5,56(sp)
    80002ede:	f85a                	sd	s6,48(sp)
    80002ee0:	f45e                	sd	s7,40(sp)
    80002ee2:	1880                	addi	s0,sp,112
    80002ee4:	8b2a                	mv	s6,a0
    80002ee6:	8bae                	mv	s7,a1
    80002ee8:	8a32                	mv	s4,a2
    80002eea:	84b6                	mv	s1,a3
    80002eec:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002eee:	9f35                	addw	a4,a4,a3
    80002ef0:	4501                	li	a0,0
    80002ef2:	0cd76a63          	bltu	a4,a3,80002fc6 <readi+0xfa>
    80002ef6:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size) n = ip->size - off;
    80002ef8:	00e7f463          	bgeu	a5,a4,80002f00 <readi+0x34>
    80002efc:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f00:	0a0a8963          	beqz	s5,80002fb2 <readi+0xe6>
    80002f04:	e8ca                	sd	s2,80(sp)
    80002f06:	f062                	sd	s8,32(sp)
    80002f08:	ec66                	sd	s9,24(sp)
    80002f0a:	e86a                	sd	s10,16(sp)
    80002f0c:	e46e                	sd	s11,8(sp)
    80002f0e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f10:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f14:	5c7d                	li	s8,-1
    80002f16:	a82d                	j	80002f50 <readi+0x84>
    80002f18:	020d1d93          	slli	s11,s10,0x20
    80002f1c:	020ddd93          	srli	s11,s11,0x20
    80002f20:	05890613          	addi	a2,s2,88
    80002f24:	86ee                	mv	a3,s11
    80002f26:	963a                	add	a2,a2,a4
    80002f28:	85d2                	mv	a1,s4
    80002f2a:	855e                	mv	a0,s7
    80002f2c:	fffff097          	auipc	ra,0xfffff
    80002f30:	ad0080e7          	jalr	-1328(ra) # 800019fc <either_copyout>
    80002f34:	05850d63          	beq	a0,s8,80002f8e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	5d6080e7          	jalr	1494(ra) # 80002510 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f42:	013d09bb          	addw	s3,s10,s3
    80002f46:	009d04bb          	addw	s1,s10,s1
    80002f4a:	9a6e                	add	s4,s4,s11
    80002f4c:	0559fd63          	bgeu	s3,s5,80002fa6 <readi+0xda>
    uint addr = bmap(ip, off / BSIZE);
    80002f50:	00a4d59b          	srliw	a1,s1,0xa
    80002f54:	855a                	mv	a0,s6
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	88e080e7          	jalr	-1906(ra) # 800027e4 <bmap>
    80002f5e:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002f62:	c9b1                	beqz	a1,80002fb6 <readi+0xea>
    bp = bread(ip->dev, addr);
    80002f64:	000b2503          	lw	a0,0(s6)
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	478080e7          	jalr	1144(ra) # 800023e0 <bread>
    80002f70:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f72:	3ff4f713          	andi	a4,s1,1023
    80002f76:	40ec87bb          	subw	a5,s9,a4
    80002f7a:	413a86bb          	subw	a3,s5,s3
    80002f7e:	8d3e                	mv	s10,a5
    80002f80:	2781                	sext.w	a5,a5
    80002f82:	0006861b          	sext.w	a2,a3
    80002f86:	f8f679e3          	bgeu	a2,a5,80002f18 <readi+0x4c>
    80002f8a:	8d36                	mv	s10,a3
    80002f8c:	b771                	j	80002f18 <readi+0x4c>
      brelse(bp);
    80002f8e:	854a                	mv	a0,s2
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	580080e7          	jalr	1408(ra) # 80002510 <brelse>
      tot = -1;
    80002f98:	59fd                	li	s3,-1
      break;
    80002f9a:	6946                	ld	s2,80(sp)
    80002f9c:	7c02                	ld	s8,32(sp)
    80002f9e:	6ce2                	ld	s9,24(sp)
    80002fa0:	6d42                	ld	s10,16(sp)
    80002fa2:	6da2                	ld	s11,8(sp)
    80002fa4:	a831                	j	80002fc0 <readi+0xf4>
    80002fa6:	6946                	ld	s2,80(sp)
    80002fa8:	7c02                	ld	s8,32(sp)
    80002faa:	6ce2                	ld	s9,24(sp)
    80002fac:	6d42                	ld	s10,16(sp)
    80002fae:	6da2                	ld	s11,8(sp)
    80002fb0:	a801                	j	80002fc0 <readi+0xf4>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002fb2:	89d6                	mv	s3,s5
    80002fb4:	a031                	j	80002fc0 <readi+0xf4>
    80002fb6:	6946                	ld	s2,80(sp)
    80002fb8:	7c02                	ld	s8,32(sp)
    80002fba:	6ce2                	ld	s9,24(sp)
    80002fbc:	6d42                	ld	s10,16(sp)
    80002fbe:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fc0:	0009851b          	sext.w	a0,s3
    80002fc4:	69a6                	ld	s3,72(sp)
}
    80002fc6:	70a6                	ld	ra,104(sp)
    80002fc8:	7406                	ld	s0,96(sp)
    80002fca:	64e6                	ld	s1,88(sp)
    80002fcc:	6a06                	ld	s4,64(sp)
    80002fce:	7ae2                	ld	s5,56(sp)
    80002fd0:	7b42                	ld	s6,48(sp)
    80002fd2:	7ba2                	ld	s7,40(sp)
    80002fd4:	6165                	addi	sp,sp,112
    80002fd6:	8082                	ret
  if (off > ip->size || off + n < off) return 0;
    80002fd8:	4501                	li	a0,0
}
    80002fda:	8082                	ret

0000000080002fdc <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002fdc:	457c                	lw	a5,76(a0)
    80002fde:	10d7ee63          	bltu	a5,a3,800030fa <writei+0x11e>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002fe2:	7159                	addi	sp,sp,-112
    80002fe4:	f486                	sd	ra,104(sp)
    80002fe6:	f0a2                	sd	s0,96(sp)
    80002fe8:	e8ca                	sd	s2,80(sp)
    80002fea:	e0d2                	sd	s4,64(sp)
    80002fec:	fc56                	sd	s5,56(sp)
    80002fee:	f85a                	sd	s6,48(sp)
    80002ff0:	f45e                	sd	s7,40(sp)
    80002ff2:	1880                	addi	s0,sp,112
    80002ff4:	8aaa                	mv	s5,a0
    80002ff6:	8bae                	mv	s7,a1
    80002ff8:	8a32                	mv	s4,a2
    80002ffa:	8936                	mv	s2,a3
    80002ffc:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002ffe:	00e687bb          	addw	a5,a3,a4
    80003002:	0ed7ee63          	bltu	a5,a3,800030fe <writei+0x122>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003006:	00043737          	lui	a4,0x43
    8000300a:	0ef76c63          	bltu	a4,a5,80003102 <writei+0x126>
    8000300e:	e4ce                	sd	s3,72(sp)

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003010:	0c0b0d63          	beqz	s6,800030ea <writei+0x10e>
    80003014:	eca6                	sd	s1,88(sp)
    80003016:	f062                	sd	s8,32(sp)
    80003018:	ec66                	sd	s9,24(sp)
    8000301a:	e86a                	sd	s10,16(sp)
    8000301c:	e46e                	sd	s11,8(sp)
    8000301e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003020:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003024:	5c7d                	li	s8,-1
    80003026:	a091                	j	8000306a <writei+0x8e>
    80003028:	020d1d93          	slli	s11,s10,0x20
    8000302c:	020ddd93          	srli	s11,s11,0x20
    80003030:	05848513          	addi	a0,s1,88
    80003034:	86ee                	mv	a3,s11
    80003036:	8652                	mv	a2,s4
    80003038:	85de                	mv	a1,s7
    8000303a:	953a                	add	a0,a0,a4
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	a16080e7          	jalr	-1514(ra) # 80001a52 <either_copyin>
    80003044:	07850263          	beq	a0,s8,800030a8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003048:	8526                	mv	a0,s1
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	770080e7          	jalr	1904(ra) # 800037ba <log_write>
    brelse(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	4bc080e7          	jalr	1212(ra) # 80002510 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000305c:	013d09bb          	addw	s3,s10,s3
    80003060:	012d093b          	addw	s2,s10,s2
    80003064:	9a6e                	add	s4,s4,s11
    80003066:	0569f663          	bgeu	s3,s6,800030b2 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    8000306a:	00a9559b          	srliw	a1,s2,0xa
    8000306e:	8556                	mv	a0,s5
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	774080e7          	jalr	1908(ra) # 800027e4 <bmap>
    80003078:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    8000307c:	c99d                	beqz	a1,800030b2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000307e:	000aa503          	lw	a0,0(s5)
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	35e080e7          	jalr	862(ra) # 800023e0 <bread>
    8000308a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000308c:	3ff97713          	andi	a4,s2,1023
    80003090:	40ec87bb          	subw	a5,s9,a4
    80003094:	413b06bb          	subw	a3,s6,s3
    80003098:	8d3e                	mv	s10,a5
    8000309a:	2781                	sext.w	a5,a5
    8000309c:	0006861b          	sext.w	a2,a3
    800030a0:	f8f674e3          	bgeu	a2,a5,80003028 <writei+0x4c>
    800030a4:	8d36                	mv	s10,a3
    800030a6:	b749                	j	80003028 <writei+0x4c>
      brelse(bp);
    800030a8:	8526                	mv	a0,s1
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	466080e7          	jalr	1126(ra) # 80002510 <brelse>
  }

  if (off > ip->size) ip->size = off;
    800030b2:	04caa783          	lw	a5,76(s5)
    800030b6:	0327fc63          	bgeu	a5,s2,800030ee <writei+0x112>
    800030ba:	052aa623          	sw	s2,76(s5)
    800030be:	64e6                	ld	s1,88(sp)
    800030c0:	7c02                	ld	s8,32(sp)
    800030c2:	6ce2                	ld	s9,24(sp)
    800030c4:	6d42                	ld	s10,16(sp)
    800030c6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030c8:	8556                	mv	a0,s5
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	a7e080e7          	jalr	-1410(ra) # 80002b48 <iupdate>

  return tot;
    800030d2:	0009851b          	sext.w	a0,s3
    800030d6:	69a6                	ld	s3,72(sp)
}
    800030d8:	70a6                	ld	ra,104(sp)
    800030da:	7406                	ld	s0,96(sp)
    800030dc:	6946                	ld	s2,80(sp)
    800030de:	6a06                	ld	s4,64(sp)
    800030e0:	7ae2                	ld	s5,56(sp)
    800030e2:	7b42                	ld	s6,48(sp)
    800030e4:	7ba2                	ld	s7,40(sp)
    800030e6:	6165                	addi	sp,sp,112
    800030e8:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800030ea:	89da                	mv	s3,s6
    800030ec:	bff1                	j	800030c8 <writei+0xec>
    800030ee:	64e6                	ld	s1,88(sp)
    800030f0:	7c02                	ld	s8,32(sp)
    800030f2:	6ce2                	ld	s9,24(sp)
    800030f4:	6d42                	ld	s10,16(sp)
    800030f6:	6da2                	ld	s11,8(sp)
    800030f8:	bfc1                	j	800030c8 <writei+0xec>
  if (off > ip->size || off + n < off) return -1;
    800030fa:	557d                	li	a0,-1
}
    800030fc:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800030fe:	557d                	li	a0,-1
    80003100:	bfe1                	j	800030d8 <writei+0xfc>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003102:	557d                	li	a0,-1
    80003104:	bfd1                	j	800030d8 <writei+0xfc>

0000000080003106 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80003106:	1141                	addi	sp,sp,-16
    80003108:	e406                	sd	ra,8(sp)
    8000310a:	e022                	sd	s0,0(sp)
    8000310c:	0800                	addi	s0,sp,16
    8000310e:	4639                	li	a2,14
    80003110:	ffffd097          	auipc	ra,0xffffd
    80003114:	13a080e7          	jalr	314(ra) # 8000024a <strncmp>
    80003118:	60a2                	ld	ra,8(sp)
    8000311a:	6402                	ld	s0,0(sp)
    8000311c:	0141                	addi	sp,sp,16
    8000311e:	8082                	ret

0000000080003120 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003120:	7139                	addi	sp,sp,-64
    80003122:	fc06                	sd	ra,56(sp)
    80003124:	f822                	sd	s0,48(sp)
    80003126:	f426                	sd	s1,40(sp)
    80003128:	f04a                	sd	s2,32(sp)
    8000312a:	ec4e                	sd	s3,24(sp)
    8000312c:	e852                	sd	s4,16(sp)
    8000312e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003130:	04451703          	lh	a4,68(a0)
    80003134:	4785                	li	a5,1
    80003136:	00f71a63          	bne	a4,a5,8000314a <dirlookup+0x2a>
    8000313a:	892a                	mv	s2,a0
    8000313c:	89ae                	mv	s3,a1
    8000313e:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003140:	457c                	lw	a5,76(a0)
    80003142:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003144:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003146:	e79d                	bnez	a5,80003174 <dirlookup+0x54>
    80003148:	a8a5                	j	800031c0 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000314a:	00006517          	auipc	a0,0x6
    8000314e:	36e50513          	addi	a0,a0,878 # 800094b8 <etext+0x4b8>
    80003152:	00004097          	auipc	ra,0x4
    80003156:	9cc080e7          	jalr	-1588(ra) # 80006b1e <panic>
      panic("dirlookup read");
    8000315a:	00006517          	auipc	a0,0x6
    8000315e:	37650513          	addi	a0,a0,886 # 800094d0 <etext+0x4d0>
    80003162:	00004097          	auipc	ra,0x4
    80003166:	9bc080e7          	jalr	-1604(ra) # 80006b1e <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000316a:	24c1                	addiw	s1,s1,16
    8000316c:	04c92783          	lw	a5,76(s2)
    80003170:	04f4f763          	bgeu	s1,a5,800031be <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003174:	4741                	li	a4,16
    80003176:	86a6                	mv	a3,s1
    80003178:	fc040613          	addi	a2,s0,-64
    8000317c:	4581                	li	a1,0
    8000317e:	854a                	mv	a0,s2
    80003180:	00000097          	auipc	ra,0x0
    80003184:	d4c080e7          	jalr	-692(ra) # 80002ecc <readi>
    80003188:	47c1                	li	a5,16
    8000318a:	fcf518e3          	bne	a0,a5,8000315a <dirlookup+0x3a>
    if (de.inum == 0) continue;
    8000318e:	fc045783          	lhu	a5,-64(s0)
    80003192:	dfe1                	beqz	a5,8000316a <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80003194:	fc240593          	addi	a1,s0,-62
    80003198:	854e                	mv	a0,s3
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	f6c080e7          	jalr	-148(ra) # 80003106 <namecmp>
    800031a2:	f561                	bnez	a0,8000316a <dirlookup+0x4a>
      if (poff) *poff = off;
    800031a4:	000a0463          	beqz	s4,800031ac <dirlookup+0x8c>
    800031a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ac:	fc045583          	lhu	a1,-64(s0)
    800031b0:	00092503          	lw	a0,0(s2)
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	720080e7          	jalr	1824(ra) # 800028d4 <iget>
    800031bc:	a011                	j	800031c0 <dirlookup+0xa0>
  return 0;
    800031be:	4501                	li	a0,0
}
    800031c0:	70e2                	ld	ra,56(sp)
    800031c2:	7442                	ld	s0,48(sp)
    800031c4:	74a2                	ld	s1,40(sp)
    800031c6:	7902                	ld	s2,32(sp)
    800031c8:	69e2                	ld	s3,24(sp)
    800031ca:	6a42                	ld	s4,16(sp)
    800031cc:	6121                	addi	sp,sp,64
    800031ce:	8082                	ret

00000000800031d0 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800031d0:	711d                	addi	sp,sp,-96
    800031d2:	ec86                	sd	ra,88(sp)
    800031d4:	e8a2                	sd	s0,80(sp)
    800031d6:	e4a6                	sd	s1,72(sp)
    800031d8:	e0ca                	sd	s2,64(sp)
    800031da:	fc4e                	sd	s3,56(sp)
    800031dc:	f852                	sd	s4,48(sp)
    800031de:	f456                	sd	s5,40(sp)
    800031e0:	f05a                	sd	s6,32(sp)
    800031e2:	ec5e                	sd	s7,24(sp)
    800031e4:	e862                	sd	s8,16(sp)
    800031e6:	e466                	sd	s9,8(sp)
    800031e8:	1080                	addi	s0,sp,96
    800031ea:	84aa                	mv	s1,a0
    800031ec:	8b2e                	mv	s6,a1
    800031ee:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800031f0:	00054703          	lbu	a4,0(a0)
    800031f4:	02f00793          	li	a5,47
    800031f8:	02f70263          	beq	a4,a5,8000321c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031fc:	ffffe097          	auipc	ra,0xffffe
    80003200:	d4a080e7          	jalr	-694(ra) # 80000f46 <myproc>
    80003204:	15053503          	ld	a0,336(a0)
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	9ce080e7          	jalr	-1586(ra) # 80002bd6 <idup>
    80003210:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    80003212:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    80003216:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003218:	4b85                	li	s7,1
    8000321a:	a875                	j	800032d6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000321c:	4585                	li	a1,1
    8000321e:	4505                	li	a0,1
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	6b4080e7          	jalr	1716(ra) # 800028d4 <iget>
    80003228:	8a2a                	mv	s4,a0
    8000322a:	b7e5                	j	80003212 <namex+0x42>
      iunlockput(ip);
    8000322c:	8552                	mv	a0,s4
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	c4c080e7          	jalr	-948(ra) # 80002e7a <iunlockput>
      return 0;
    80003236:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003238:	8552                	mv	a0,s4
    8000323a:	60e6                	ld	ra,88(sp)
    8000323c:	6446                	ld	s0,80(sp)
    8000323e:	64a6                	ld	s1,72(sp)
    80003240:	6906                	ld	s2,64(sp)
    80003242:	79e2                	ld	s3,56(sp)
    80003244:	7a42                	ld	s4,48(sp)
    80003246:	7aa2                	ld	s5,40(sp)
    80003248:	7b02                	ld	s6,32(sp)
    8000324a:	6be2                	ld	s7,24(sp)
    8000324c:	6c42                	ld	s8,16(sp)
    8000324e:	6ca2                	ld	s9,8(sp)
    80003250:	6125                	addi	sp,sp,96
    80003252:	8082                	ret
      iunlock(ip);
    80003254:	8552                	mv	a0,s4
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	a84080e7          	jalr	-1404(ra) # 80002cda <iunlock>
      return ip;
    8000325e:	bfe9                	j	80003238 <namex+0x68>
      iunlockput(ip);
    80003260:	8552                	mv	a0,s4
    80003262:	00000097          	auipc	ra,0x0
    80003266:	c18080e7          	jalr	-1000(ra) # 80002e7a <iunlockput>
      return 0;
    8000326a:	8a4e                	mv	s4,s3
    8000326c:	b7f1                	j	80003238 <namex+0x68>
  len = path - s;
    8000326e:	40998633          	sub	a2,s3,s1
    80003272:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80003276:	099c5863          	bge	s8,s9,80003306 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000327a:	4639                	li	a2,14
    8000327c:	85a6                	mv	a1,s1
    8000327e:	8556                	mv	a0,s5
    80003280:	ffffd097          	auipc	ra,0xffffd
    80003284:	f56080e7          	jalr	-170(ra) # 800001d6 <memmove>
    80003288:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	01279763          	bne	a5,s2,8000329c <namex+0xcc>
    80003292:	0485                	addi	s1,s1,1
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	ff278de3          	beq	a5,s2,80003292 <namex+0xc2>
    ilock(ip);
    8000329c:	8552                	mv	a0,s4
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	976080e7          	jalr	-1674(ra) # 80002c14 <ilock>
    if (ip->type != T_DIR) {
    800032a6:	044a1783          	lh	a5,68(s4)
    800032aa:	f97791e3          	bne	a5,s7,8000322c <namex+0x5c>
    if (nameiparent && *path == '\0') {
    800032ae:	000b0563          	beqz	s6,800032b8 <namex+0xe8>
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	dfd9                	beqz	a5,80003254 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800032b8:	4601                	li	a2,0
    800032ba:	85d6                	mv	a1,s5
    800032bc:	8552                	mv	a0,s4
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	e62080e7          	jalr	-414(ra) # 80003120 <dirlookup>
    800032c6:	89aa                	mv	s3,a0
    800032c8:	dd41                	beqz	a0,80003260 <namex+0x90>
    iunlockput(ip);
    800032ca:	8552                	mv	a0,s4
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	bae080e7          	jalr	-1106(ra) # 80002e7a <iunlockput>
    ip = next;
    800032d4:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	01279763          	bne	a5,s2,800032e8 <namex+0x118>
    800032de:	0485                	addi	s1,s1,1
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	ff278de3          	beq	a5,s2,800032de <namex+0x10e>
  if (*path == 0) return 0;
    800032e8:	cb9d                	beqz	a5,8000331e <namex+0x14e>
  while (*path != '/' && *path != 0) path++;
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	89a6                	mv	s3,s1
  len = path - s;
    800032f0:	4c81                	li	s9,0
    800032f2:	4601                	li	a2,0
  while (*path != '/' && *path != 0) path++;
    800032f4:	01278963          	beq	a5,s2,80003306 <namex+0x136>
    800032f8:	dbbd                	beqz	a5,8000326e <namex+0x9e>
    800032fa:	0985                	addi	s3,s3,1
    800032fc:	0009c783          	lbu	a5,0(s3)
    80003300:	ff279ce3          	bne	a5,s2,800032f8 <namex+0x128>
    80003304:	b7ad                	j	8000326e <namex+0x9e>
    memmove(name, s, len);
    80003306:	2601                	sext.w	a2,a2
    80003308:	85a6                	mv	a1,s1
    8000330a:	8556                	mv	a0,s5
    8000330c:	ffffd097          	auipc	ra,0xffffd
    80003310:	eca080e7          	jalr	-310(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003314:	9cd6                	add	s9,s9,s5
    80003316:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000331a:	84ce                	mv	s1,s3
    8000331c:	b7bd                	j	8000328a <namex+0xba>
  if (nameiparent) {
    8000331e:	f00b0de3          	beqz	s6,80003238 <namex+0x68>
    iput(ip);
    80003322:	8552                	mv	a0,s4
    80003324:	00000097          	auipc	ra,0x0
    80003328:	aae080e7          	jalr	-1362(ra) # 80002dd2 <iput>
    return 0;
    8000332c:	4a01                	li	s4,0
    8000332e:	b729                	j	80003238 <namex+0x68>

0000000080003330 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80003330:	7139                	addi	sp,sp,-64
    80003332:	fc06                	sd	ra,56(sp)
    80003334:	f822                	sd	s0,48(sp)
    80003336:	f04a                	sd	s2,32(sp)
    80003338:	ec4e                	sd	s3,24(sp)
    8000333a:	e852                	sd	s4,16(sp)
    8000333c:	0080                	addi	s0,sp,64
    8000333e:	892a                	mv	s2,a0
    80003340:	8a2e                	mv	s4,a1
    80003342:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003344:	4601                	li	a2,0
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	dda080e7          	jalr	-550(ra) # 80003120 <dirlookup>
    8000334e:	ed25                	bnez	a0,800033c6 <dirlink+0x96>
    80003350:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003352:	04c92483          	lw	s1,76(s2)
    80003356:	c49d                	beqz	s1,80003384 <dirlink+0x54>
    80003358:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335a:	4741                	li	a4,16
    8000335c:	86a6                	mv	a3,s1
    8000335e:	fc040613          	addi	a2,s0,-64
    80003362:	4581                	li	a1,0
    80003364:	854a                	mv	a0,s2
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	b66080e7          	jalr	-1178(ra) # 80002ecc <readi>
    8000336e:	47c1                	li	a5,16
    80003370:	06f51163          	bne	a0,a5,800033d2 <dirlink+0xa2>
    if (de.inum == 0) break;
    80003374:	fc045783          	lhu	a5,-64(s0)
    80003378:	c791                	beqz	a5,80003384 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000337a:	24c1                	addiw	s1,s1,16
    8000337c:	04c92783          	lw	a5,76(s2)
    80003380:	fcf4ede3          	bltu	s1,a5,8000335a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003384:	4639                	li	a2,14
    80003386:	85d2                	mv	a1,s4
    80003388:	fc240513          	addi	a0,s0,-62
    8000338c:	ffffd097          	auipc	ra,0xffffd
    80003390:	ef4080e7          	jalr	-268(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003394:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    80003398:	4741                	li	a4,16
    8000339a:	86a6                	mv	a3,s1
    8000339c:	fc040613          	addi	a2,s0,-64
    800033a0:	4581                	li	a1,0
    800033a2:	854a                	mv	a0,s2
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	c38080e7          	jalr	-968(ra) # 80002fdc <writei>
    800033ac:	1541                	addi	a0,a0,-16
    800033ae:	00a03533          	snez	a0,a0
    800033b2:	40a00533          	neg	a0,a0
    800033b6:	74a2                	ld	s1,40(sp)
}
    800033b8:	70e2                	ld	ra,56(sp)
    800033ba:	7442                	ld	s0,48(sp)
    800033bc:	7902                	ld	s2,32(sp)
    800033be:	69e2                	ld	s3,24(sp)
    800033c0:	6a42                	ld	s4,16(sp)
    800033c2:	6121                	addi	sp,sp,64
    800033c4:	8082                	ret
    iput(ip);
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	a0c080e7          	jalr	-1524(ra) # 80002dd2 <iput>
    return -1;
    800033ce:	557d                	li	a0,-1
    800033d0:	b7e5                	j	800033b8 <dirlink+0x88>
      panic("dirlink read");
    800033d2:	00006517          	auipc	a0,0x6
    800033d6:	10e50513          	addi	a0,a0,270 # 800094e0 <etext+0x4e0>
    800033da:	00003097          	auipc	ra,0x3
    800033de:	744080e7          	jalr	1860(ra) # 80006b1e <panic>

00000000800033e2 <namei>:

struct inode *namei(char *path) {
    800033e2:	1101                	addi	sp,sp,-32
    800033e4:	ec06                	sd	ra,24(sp)
    800033e6:	e822                	sd	s0,16(sp)
    800033e8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ea:	fe040613          	addi	a2,s0,-32
    800033ee:	4581                	li	a1,0
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	de0080e7          	jalr	-544(ra) # 800031d0 <namex>
}
    800033f8:	60e2                	ld	ra,24(sp)
    800033fa:	6442                	ld	s0,16(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret

0000000080003400 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80003400:	1141                	addi	sp,sp,-16
    80003402:	e406                	sd	ra,8(sp)
    80003404:	e022                	sd	s0,0(sp)
    80003406:	0800                	addi	s0,sp,16
    80003408:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000340a:	4585                	li	a1,1
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	dc4080e7          	jalr	-572(ra) # 800031d0 <namex>
}
    80003414:	60a2                	ld	ra,8(sp)
    80003416:	6402                	ld	s0,0(sp)
    80003418:	0141                	addi	sp,sp,16
    8000341a:	8082                	ret

000000008000341c <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    8000341c:	1101                	addi	sp,sp,-32
    8000341e:	ec06                	sd	ra,24(sp)
    80003420:	e822                	sd	s0,16(sp)
    80003422:	e426                	sd	s1,8(sp)
    80003424:	e04a                	sd	s2,0(sp)
    80003426:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003428:	00019917          	auipc	s2,0x19
    8000342c:	1e890913          	addi	s2,s2,488 # 8001c610 <log>
    80003430:	01892583          	lw	a1,24(s2)
    80003434:	02892503          	lw	a0,40(s2)
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	fa8080e7          	jalr	-88(ra) # 800023e0 <bread>
    80003440:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003442:	02c92603          	lw	a2,44(s2)
    80003446:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003448:	00c05f63          	blez	a2,80003466 <write_head+0x4a>
    8000344c:	00019717          	auipc	a4,0x19
    80003450:	1f470713          	addi	a4,a4,500 # 8001c640 <log+0x30>
    80003454:	87aa                	mv	a5,a0
    80003456:	060a                	slli	a2,a2,0x2
    80003458:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000345a:	4314                	lw	a3,0(a4)
    8000345c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000345e:	0711                	addi	a4,a4,4
    80003460:	0791                	addi	a5,a5,4
    80003462:	fec79ce3          	bne	a5,a2,8000345a <write_head+0x3e>
  }
  bwrite(buf);
    80003466:	8526                	mv	a0,s1
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	06a080e7          	jalr	106(ra) # 800024d2 <bwrite>
  brelse(buf);
    80003470:	8526                	mv	a0,s1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	09e080e7          	jalr	158(ra) # 80002510 <brelse>
}
    8000347a:	60e2                	ld	ra,24(sp)
    8000347c:	6442                	ld	s0,16(sp)
    8000347e:	64a2                	ld	s1,8(sp)
    80003480:	6902                	ld	s2,0(sp)
    80003482:	6105                	addi	sp,sp,32
    80003484:	8082                	ret

0000000080003486 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003486:	00019797          	auipc	a5,0x19
    8000348a:	1b67a783          	lw	a5,438(a5) # 8001c63c <log+0x2c>
    8000348e:	0af05d63          	blez	a5,80003548 <install_trans+0xc2>
static void install_trans(int recovering) {
    80003492:	7139                	addi	sp,sp,-64
    80003494:	fc06                	sd	ra,56(sp)
    80003496:	f822                	sd	s0,48(sp)
    80003498:	f426                	sd	s1,40(sp)
    8000349a:	f04a                	sd	s2,32(sp)
    8000349c:	ec4e                	sd	s3,24(sp)
    8000349e:	e852                	sd	s4,16(sp)
    800034a0:	e456                	sd	s5,8(sp)
    800034a2:	e05a                	sd	s6,0(sp)
    800034a4:	0080                	addi	s0,sp,64
    800034a6:	8b2a                	mv	s6,a0
    800034a8:	00019a97          	auipc	s5,0x19
    800034ac:	198a8a93          	addi	s5,s5,408 # 8001c640 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034b2:	00019997          	auipc	s3,0x19
    800034b6:	15e98993          	addi	s3,s3,350 # 8001c610 <log>
    800034ba:	a00d                	j	800034dc <install_trans+0x56>
    brelse(lbuf);
    800034bc:	854a                	mv	a0,s2
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	052080e7          	jalr	82(ra) # 80002510 <brelse>
    brelse(dbuf);
    800034c6:	8526                	mv	a0,s1
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	048080e7          	jalr	72(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d0:	2a05                	addiw	s4,s4,1
    800034d2:	0a91                	addi	s5,s5,4
    800034d4:	02c9a783          	lw	a5,44(s3)
    800034d8:	04fa5e63          	bge	s4,a5,80003534 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034dc:	0189a583          	lw	a1,24(s3)
    800034e0:	014585bb          	addw	a1,a1,s4
    800034e4:	2585                	addiw	a1,a1,1
    800034e6:	0289a503          	lw	a0,40(s3)
    800034ea:	fffff097          	auipc	ra,0xfffff
    800034ee:	ef6080e7          	jalr	-266(ra) # 800023e0 <bread>
    800034f2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800034f4:	000aa583          	lw	a1,0(s5)
    800034f8:	0289a503          	lw	a0,40(s3)
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	ee4080e7          	jalr	-284(ra) # 800023e0 <bread>
    80003504:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003506:	40000613          	li	a2,1024
    8000350a:	05890593          	addi	a1,s2,88
    8000350e:	05850513          	addi	a0,a0,88
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	cc4080e7          	jalr	-828(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    8000351a:	8526                	mv	a0,s1
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	fb6080e7          	jalr	-74(ra) # 800024d2 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003524:	f80b1ce3          	bnez	s6,800034bc <install_trans+0x36>
    80003528:	8526                	mv	a0,s1
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	0be080e7          	jalr	190(ra) # 800025e8 <bunpin>
    80003532:	b769                	j	800034bc <install_trans+0x36>
}
    80003534:	70e2                	ld	ra,56(sp)
    80003536:	7442                	ld	s0,48(sp)
    80003538:	74a2                	ld	s1,40(sp)
    8000353a:	7902                	ld	s2,32(sp)
    8000353c:	69e2                	ld	s3,24(sp)
    8000353e:	6a42                	ld	s4,16(sp)
    80003540:	6aa2                	ld	s5,8(sp)
    80003542:	6b02                	ld	s6,0(sp)
    80003544:	6121                	addi	sp,sp,64
    80003546:	8082                	ret
    80003548:	8082                	ret

000000008000354a <initlog>:
void initlog(int dev, struct superblock *sb) {
    8000354a:	7179                	addi	sp,sp,-48
    8000354c:	f406                	sd	ra,40(sp)
    8000354e:	f022                	sd	s0,32(sp)
    80003550:	ec26                	sd	s1,24(sp)
    80003552:	e84a                	sd	s2,16(sp)
    80003554:	e44e                	sd	s3,8(sp)
    80003556:	1800                	addi	s0,sp,48
    80003558:	892a                	mv	s2,a0
    8000355a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355c:	00019497          	auipc	s1,0x19
    80003560:	0b448493          	addi	s1,s1,180 # 8001c610 <log>
    80003564:	00006597          	auipc	a1,0x6
    80003568:	f8c58593          	addi	a1,a1,-116 # 800094f0 <etext+0x4f0>
    8000356c:	8526                	mv	a0,s1
    8000356e:	00004097          	auipc	ra,0x4
    80003572:	a9a080e7          	jalr	-1382(ra) # 80007008 <initlock>
  log.start = sb->logstart;
    80003576:	0149a583          	lw	a1,20(s3)
    8000357a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357c:	0109a783          	lw	a5,16(s3)
    80003580:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003582:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003586:	854a                	mv	a0,s2
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	e58080e7          	jalr	-424(ra) # 800023e0 <bread>
  log.lh.n = lh->n;
    80003590:	4d30                	lw	a2,88(a0)
    80003592:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003594:	00c05f63          	blez	a2,800035b2 <initlog+0x68>
    80003598:	87aa                	mv	a5,a0
    8000359a:	00019717          	auipc	a4,0x19
    8000359e:	0a670713          	addi	a4,a4,166 # 8001c640 <log+0x30>
    800035a2:	060a                	slli	a2,a2,0x2
    800035a4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035a6:	4ff4                	lw	a3,92(a5)
    800035a8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035aa:	0791                	addi	a5,a5,4
    800035ac:	0711                	addi	a4,a4,4
    800035ae:	fec79ce3          	bne	a5,a2,800035a6 <initlog+0x5c>
  brelse(buf);
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	f5e080e7          	jalr	-162(ra) # 80002510 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    800035ba:	4505                	li	a0,1
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	eca080e7          	jalr	-310(ra) # 80003486 <install_trans>
  log.lh.n = 0;
    800035c4:	00019797          	auipc	a5,0x19
    800035c8:	0607ac23          	sw	zero,120(a5) # 8001c63c <log+0x2c>
  write_head();  // clear the log
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	e50080e7          	jalr	-432(ra) # 8000341c <write_head>
}
    800035d4:	70a2                	ld	ra,40(sp)
    800035d6:	7402                	ld	s0,32(sp)
    800035d8:	64e2                	ld	s1,24(sp)
    800035da:	6942                	ld	s2,16(sp)
    800035dc:	69a2                	ld	s3,8(sp)
    800035de:	6145                	addi	sp,sp,48
    800035e0:	8082                	ret

00000000800035e2 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800035e2:	1101                	addi	sp,sp,-32
    800035e4:	ec06                	sd	ra,24(sp)
    800035e6:	e822                	sd	s0,16(sp)
    800035e8:	e426                	sd	s1,8(sp)
    800035ea:	e04a                	sd	s2,0(sp)
    800035ec:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ee:	00019517          	auipc	a0,0x19
    800035f2:	02250513          	addi	a0,a0,34 # 8001c610 <log>
    800035f6:	00004097          	auipc	ra,0x4
    800035fa:	aa2080e7          	jalr	-1374(ra) # 80007098 <acquire>
  while (1) {
    if (log.committing) {
    800035fe:	00019497          	auipc	s1,0x19
    80003602:	01248493          	addi	s1,s1,18 # 8001c610 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003606:	4979                	li	s2,30
    80003608:	a039                	j	80003616 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000360a:	85a6                	mv	a1,s1
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	fe6080e7          	jalr	-26(ra) # 800015f4 <sleep>
    if (log.committing) {
    80003616:	50dc                	lw	a5,36(s1)
    80003618:	fbed                	bnez	a5,8000360a <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    8000361a:	5098                	lw	a4,32(s1)
    8000361c:	2705                	addiw	a4,a4,1
    8000361e:	0027179b          	slliw	a5,a4,0x2
    80003622:	9fb9                	addw	a5,a5,a4
    80003624:	0017979b          	slliw	a5,a5,0x1
    80003628:	54d4                	lw	a3,44(s1)
    8000362a:	9fb5                	addw	a5,a5,a3
    8000362c:	00f95963          	bge	s2,a5,8000363e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003630:	85a6                	mv	a1,s1
    80003632:	8526                	mv	a0,s1
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	fc0080e7          	jalr	-64(ra) # 800015f4 <sleep>
    8000363c:	bfe9                	j	80003616 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000363e:	00019517          	auipc	a0,0x19
    80003642:	fd250513          	addi	a0,a0,-46 # 8001c610 <log>
    80003646:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003648:	00004097          	auipc	ra,0x4
    8000364c:	b04080e7          	jalr	-1276(ra) # 8000714c <release>
      break;
    }
  }
}
    80003650:	60e2                	ld	ra,24(sp)
    80003652:	6442                	ld	s0,16(sp)
    80003654:	64a2                	ld	s1,8(sp)
    80003656:	6902                	ld	s2,0(sp)
    80003658:	6105                	addi	sp,sp,32
    8000365a:	8082                	ret

000000008000365c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    8000365c:	7139                	addi	sp,sp,-64
    8000365e:	fc06                	sd	ra,56(sp)
    80003660:	f822                	sd	s0,48(sp)
    80003662:	f426                	sd	s1,40(sp)
    80003664:	f04a                	sd	s2,32(sp)
    80003666:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003668:	00019497          	auipc	s1,0x19
    8000366c:	fa848493          	addi	s1,s1,-88 # 8001c610 <log>
    80003670:	8526                	mv	a0,s1
    80003672:	00004097          	auipc	ra,0x4
    80003676:	a26080e7          	jalr	-1498(ra) # 80007098 <acquire>
  log.outstanding -= 1;
    8000367a:	509c                	lw	a5,32(s1)
    8000367c:	37fd                	addiw	a5,a5,-1
    8000367e:	0007891b          	sext.w	s2,a5
    80003682:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    80003684:	50dc                	lw	a5,36(s1)
    80003686:	e7b9                	bnez	a5,800036d4 <end_op+0x78>
  if (log.outstanding == 0) {
    80003688:	06091163          	bnez	s2,800036ea <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000368c:	00019497          	auipc	s1,0x19
    80003690:	f8448493          	addi	s1,s1,-124 # 8001c610 <log>
    80003694:	4785                	li	a5,1
    80003696:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003698:	8526                	mv	a0,s1
    8000369a:	00004097          	auipc	ra,0x4
    8000369e:	ab2080e7          	jalr	-1358(ra) # 8000714c <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800036a2:	54dc                	lw	a5,44(s1)
    800036a4:	06f04763          	bgtz	a5,80003712 <end_op+0xb6>
    acquire(&log.lock);
    800036a8:	00019497          	auipc	s1,0x19
    800036ac:	f6848493          	addi	s1,s1,-152 # 8001c610 <log>
    800036b0:	8526                	mv	a0,s1
    800036b2:	00004097          	auipc	ra,0x4
    800036b6:	9e6080e7          	jalr	-1562(ra) # 80007098 <acquire>
    log.committing = 0;
    800036ba:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	f98080e7          	jalr	-104(ra) # 80001658 <wakeup>
    release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00004097          	auipc	ra,0x4
    800036ce:	a82080e7          	jalr	-1406(ra) # 8000714c <release>
}
    800036d2:	a815                	j	80003706 <end_op+0xaa>
    800036d4:	ec4e                	sd	s3,24(sp)
    800036d6:	e852                	sd	s4,16(sp)
    800036d8:	e456                	sd	s5,8(sp)
  if (log.committing) panic("log.committing");
    800036da:	00006517          	auipc	a0,0x6
    800036de:	e1e50513          	addi	a0,a0,-482 # 800094f8 <etext+0x4f8>
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	43c080e7          	jalr	1084(ra) # 80006b1e <panic>
    wakeup(&log);
    800036ea:	00019497          	auipc	s1,0x19
    800036ee:	f2648493          	addi	s1,s1,-218 # 8001c610 <log>
    800036f2:	8526                	mv	a0,s1
    800036f4:	ffffe097          	auipc	ra,0xffffe
    800036f8:	f64080e7          	jalr	-156(ra) # 80001658 <wakeup>
  release(&log.lock);
    800036fc:	8526                	mv	a0,s1
    800036fe:	00004097          	auipc	ra,0x4
    80003702:	a4e080e7          	jalr	-1458(ra) # 8000714c <release>
}
    80003706:	70e2                	ld	ra,56(sp)
    80003708:	7442                	ld	s0,48(sp)
    8000370a:	74a2                	ld	s1,40(sp)
    8000370c:	7902                	ld	s2,32(sp)
    8000370e:	6121                	addi	sp,sp,64
    80003710:	8082                	ret
    80003712:	ec4e                	sd	s3,24(sp)
    80003714:	e852                	sd	s4,16(sp)
    80003716:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003718:	00019a97          	auipc	s5,0x19
    8000371c:	f28a8a93          	addi	s5,s5,-216 # 8001c640 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    80003720:	00019a17          	auipc	s4,0x19
    80003724:	ef0a0a13          	addi	s4,s4,-272 # 8001c610 <log>
    80003728:	018a2583          	lw	a1,24(s4)
    8000372c:	012585bb          	addw	a1,a1,s2
    80003730:	2585                	addiw	a1,a1,1
    80003732:	028a2503          	lw	a0,40(s4)
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	caa080e7          	jalr	-854(ra) # 800023e0 <bread>
    8000373e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003740:	000aa583          	lw	a1,0(s5)
    80003744:	028a2503          	lw	a0,40(s4)
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	c98080e7          	jalr	-872(ra) # 800023e0 <bread>
    80003750:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003752:	40000613          	li	a2,1024
    80003756:	05850593          	addi	a1,a0,88
    8000375a:	05848513          	addi	a0,s1,88
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	a78080e7          	jalr	-1416(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003766:	8526                	mv	a0,s1
    80003768:	fffff097          	auipc	ra,0xfffff
    8000376c:	d6a080e7          	jalr	-662(ra) # 800024d2 <bwrite>
    brelse(from);
    80003770:	854e                	mv	a0,s3
    80003772:	fffff097          	auipc	ra,0xfffff
    80003776:	d9e080e7          	jalr	-610(ra) # 80002510 <brelse>
    brelse(to);
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	d94080e7          	jalr	-620(ra) # 80002510 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003784:	2905                	addiw	s2,s2,1
    80003786:	0a91                	addi	s5,s5,4
    80003788:	02ca2783          	lw	a5,44(s4)
    8000378c:	f8f94ee3          	blt	s2,a5,80003728 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    80003790:	00000097          	auipc	ra,0x0
    80003794:	c8c080e7          	jalr	-884(ra) # 8000341c <write_head>
    install_trans(0);  // Now install writes to home locations
    80003798:	4501                	li	a0,0
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	cec080e7          	jalr	-788(ra) # 80003486 <install_trans>
    log.lh.n = 0;
    800037a2:	00019797          	auipc	a5,0x19
    800037a6:	e807ad23          	sw	zero,-358(a5) # 8001c63c <log+0x2c>
    write_head();  // Erase the transaction from the log
    800037aa:	00000097          	auipc	ra,0x0
    800037ae:	c72080e7          	jalr	-910(ra) # 8000341c <write_head>
    800037b2:	69e2                	ld	s3,24(sp)
    800037b4:	6a42                	ld	s4,16(sp)
    800037b6:	6aa2                	ld	s5,8(sp)
    800037b8:	bdc5                	j	800036a8 <end_op+0x4c>

00000000800037ba <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037c8:	00019917          	auipc	s2,0x19
    800037cc:	e4890913          	addi	s2,s2,-440 # 8001c610 <log>
    800037d0:	854a                	mv	a0,s2
    800037d2:	00004097          	auipc	ra,0x4
    800037d6:	8c6080e7          	jalr	-1850(ra) # 80007098 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037da:	02c92603          	lw	a2,44(s2)
    800037de:	47f5                	li	a5,29
    800037e0:	06c7c563          	blt	a5,a2,8000384a <log_write+0x90>
    800037e4:	00019797          	auipc	a5,0x19
    800037e8:	e487a783          	lw	a5,-440(a5) # 8001c62c <log+0x1c>
    800037ec:	37fd                	addiw	a5,a5,-1
    800037ee:	04f65e63          	bge	a2,a5,8000384a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    800037f2:	00019797          	auipc	a5,0x19
    800037f6:	e3e7a783          	lw	a5,-450(a5) # 8001c630 <log+0x20>
    800037fa:	06f05063          	blez	a5,8000385a <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    800037fe:	4781                	li	a5,0
    80003800:	06c05563          	blez	a2,8000386a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003804:	44cc                	lw	a1,12(s1)
    80003806:	00019717          	auipc	a4,0x19
    8000380a:	e3a70713          	addi	a4,a4,-454 # 8001c640 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000380e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003810:	4314                	lw	a3,0(a4)
    80003812:	04b68c63          	beq	a3,a1,8000386a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003816:	2785                	addiw	a5,a5,1
    80003818:	0711                	addi	a4,a4,4
    8000381a:	fef61be3          	bne	a2,a5,80003810 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000381e:	0621                	addi	a2,a2,8
    80003820:	060a                	slli	a2,a2,0x2
    80003822:	00019797          	auipc	a5,0x19
    80003826:	dee78793          	addi	a5,a5,-530 # 8001c610 <log>
    8000382a:	97b2                	add	a5,a5,a2
    8000382c:	44d8                	lw	a4,12(s1)
    8000382e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003830:	8526                	mv	a0,s1
    80003832:	fffff097          	auipc	ra,0xfffff
    80003836:	d7a080e7          	jalr	-646(ra) # 800025ac <bpin>
    log.lh.n++;
    8000383a:	00019717          	auipc	a4,0x19
    8000383e:	dd670713          	addi	a4,a4,-554 # 8001c610 <log>
    80003842:	575c                	lw	a5,44(a4)
    80003844:	2785                	addiw	a5,a5,1
    80003846:	d75c                	sw	a5,44(a4)
    80003848:	a82d                	j	80003882 <log_write+0xc8>
    panic("too big a transaction");
    8000384a:	00006517          	auipc	a0,0x6
    8000384e:	cbe50513          	addi	a0,a0,-834 # 80009508 <etext+0x508>
    80003852:	00003097          	auipc	ra,0x3
    80003856:	2cc080e7          	jalr	716(ra) # 80006b1e <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    8000385a:	00006517          	auipc	a0,0x6
    8000385e:	cc650513          	addi	a0,a0,-826 # 80009520 <etext+0x520>
    80003862:	00003097          	auipc	ra,0x3
    80003866:	2bc080e7          	jalr	700(ra) # 80006b1e <panic>
  log.lh.block[i] = b->blockno;
    8000386a:	00878693          	addi	a3,a5,8
    8000386e:	068a                	slli	a3,a3,0x2
    80003870:	00019717          	auipc	a4,0x19
    80003874:	da070713          	addi	a4,a4,-608 # 8001c610 <log>
    80003878:	9736                	add	a4,a4,a3
    8000387a:	44d4                	lw	a3,12(s1)
    8000387c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000387e:	faf609e3          	beq	a2,a5,80003830 <log_write+0x76>
  }
  release(&log.lock);
    80003882:	00019517          	auipc	a0,0x19
    80003886:	d8e50513          	addi	a0,a0,-626 # 8001c610 <log>
    8000388a:	00004097          	auipc	ra,0x4
    8000388e:	8c2080e7          	jalr	-1854(ra) # 8000714c <release>
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	6105                	addi	sp,sp,32
    8000389c:	8082                	ret

000000008000389e <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
    800038ac:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038ae:	00006597          	auipc	a1,0x6
    800038b2:	c9258593          	addi	a1,a1,-878 # 80009540 <etext+0x540>
    800038b6:	0521                	addi	a0,a0,8
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	750080e7          	jalr	1872(ra) # 80007008 <initlock>
  lk->name = name;
    800038c0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038c8:	0204a423          	sw	zero,40(s1)
}
    800038cc:	60e2                	ld	ra,24(sp)
    800038ce:	6442                	ld	s0,16(sp)
    800038d0:	64a2                	ld	s1,8(sp)
    800038d2:	6902                	ld	s2,0(sp)
    800038d4:	6105                	addi	sp,sp,32
    800038d6:	8082                	ret

00000000800038d8 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    800038d8:	1101                	addi	sp,sp,-32
    800038da:	ec06                	sd	ra,24(sp)
    800038dc:	e822                	sd	s0,16(sp)
    800038de:	e426                	sd	s1,8(sp)
    800038e0:	e04a                	sd	s2,0(sp)
    800038e2:	1000                	addi	s0,sp,32
    800038e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e6:	00850913          	addi	s2,a0,8
    800038ea:	854a                	mv	a0,s2
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	7ac080e7          	jalr	1964(ra) # 80007098 <acquire>
  while (lk->locked) {
    800038f4:	409c                	lw	a5,0(s1)
    800038f6:	cb89                	beqz	a5,80003908 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038f8:	85ca                	mv	a1,s2
    800038fa:	8526                	mv	a0,s1
    800038fc:	ffffe097          	auipc	ra,0xffffe
    80003900:	cf8080e7          	jalr	-776(ra) # 800015f4 <sleep>
  while (lk->locked) {
    80003904:	409c                	lw	a5,0(s1)
    80003906:	fbed                	bnez	a5,800038f8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003908:	4785                	li	a5,1
    8000390a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	63a080e7          	jalr	1594(ra) # 80000f46 <myproc>
    80003914:	591c                	lw	a5,48(a0)
    80003916:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003918:	854a                	mv	a0,s2
    8000391a:	00004097          	auipc	ra,0x4
    8000391e:	832080e7          	jalr	-1998(ra) # 8000714c <release>
}
    80003922:	60e2                	ld	ra,24(sp)
    80003924:	6442                	ld	s0,16(sp)
    80003926:	64a2                	ld	s1,8(sp)
    80003928:	6902                	ld	s2,0(sp)
    8000392a:	6105                	addi	sp,sp,32
    8000392c:	8082                	ret

000000008000392e <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    8000392e:	1101                	addi	sp,sp,-32
    80003930:	ec06                	sd	ra,24(sp)
    80003932:	e822                	sd	s0,16(sp)
    80003934:	e426                	sd	s1,8(sp)
    80003936:	e04a                	sd	s2,0(sp)
    80003938:	1000                	addi	s0,sp,32
    8000393a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000393c:	00850913          	addi	s2,a0,8
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	756080e7          	jalr	1878(ra) # 80007098 <acquire>
  lk->locked = 0;
    8000394a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000394e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003952:	8526                	mv	a0,s1
    80003954:	ffffe097          	auipc	ra,0xffffe
    80003958:	d04080e7          	jalr	-764(ra) # 80001658 <wakeup>
  release(&lk->lk);
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	7ee080e7          	jalr	2030(ra) # 8000714c <release>
}
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6902                	ld	s2,0(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret

0000000080003972 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003972:	7179                	addi	sp,sp,-48
    80003974:	f406                	sd	ra,40(sp)
    80003976:	f022                	sd	s0,32(sp)
    80003978:	ec26                	sd	s1,24(sp)
    8000397a:	e84a                	sd	s2,16(sp)
    8000397c:	1800                	addi	s0,sp,48
    8000397e:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003980:	00850913          	addi	s2,a0,8
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	712080e7          	jalr	1810(ra) # 80007098 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398e:	409c                	lw	a5,0(s1)
    80003990:	ef91                	bnez	a5,800039ac <holdingsleep+0x3a>
    80003992:	4481                	li	s1,0
  release(&lk->lk);
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	7b6080e7          	jalr	1974(ra) # 8000714c <release>
  return r;
}
    8000399e:	8526                	mv	a0,s1
    800039a0:	70a2                	ld	ra,40(sp)
    800039a2:	7402                	ld	s0,32(sp)
    800039a4:	64e2                	ld	s1,24(sp)
    800039a6:	6942                	ld	s2,16(sp)
    800039a8:	6145                	addi	sp,sp,48
    800039aa:	8082                	ret
    800039ac:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ae:	0284a983          	lw	s3,40(s1)
    800039b2:	ffffd097          	auipc	ra,0xffffd
    800039b6:	594080e7          	jalr	1428(ra) # 80000f46 <myproc>
    800039ba:	5904                	lw	s1,48(a0)
    800039bc:	413484b3          	sub	s1,s1,s3
    800039c0:	0014b493          	seqz	s1,s1
    800039c4:	69a2                	ld	s3,8(sp)
    800039c6:	b7f9                	j	80003994 <holdingsleep+0x22>

00000000800039c8 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    800039c8:	1141                	addi	sp,sp,-16
    800039ca:	e406                	sd	ra,8(sp)
    800039cc:	e022                	sd	s0,0(sp)
    800039ce:	0800                	addi	s0,sp,16
    800039d0:	00006597          	auipc	a1,0x6
    800039d4:	b8058593          	addi	a1,a1,-1152 # 80009550 <etext+0x550>
    800039d8:	00019517          	auipc	a0,0x19
    800039dc:	d8050513          	addi	a0,a0,-640 # 8001c758 <ftable>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	628080e7          	jalr	1576(ra) # 80007008 <initlock>
    800039e8:	60a2                	ld	ra,8(sp)
    800039ea:	6402                	ld	s0,0(sp)
    800039ec:	0141                	addi	sp,sp,16
    800039ee:	8082                	ret

00000000800039f0 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039fa:	00019517          	auipc	a0,0x19
    800039fe:	d5e50513          	addi	a0,a0,-674 # 8001c758 <ftable>
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	696080e7          	jalr	1686(ra) # 80007098 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a0a:	00019497          	auipc	s1,0x19
    80003a0e:	d6648493          	addi	s1,s1,-666 # 8001c770 <ftable+0x18>
    80003a12:	0001a717          	auipc	a4,0x1a
    80003a16:	cfe70713          	addi	a4,a4,-770 # 8001d710 <disk>
    if (f->ref == 0) {
    80003a1a:	40dc                	lw	a5,4(s1)
    80003a1c:	cf99                	beqz	a5,80003a3a <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a1e:	02848493          	addi	s1,s1,40
    80003a22:	fee49ce3          	bne	s1,a4,80003a1a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a26:	00019517          	auipc	a0,0x19
    80003a2a:	d3250513          	addi	a0,a0,-718 # 8001c758 <ftable>
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	71e080e7          	jalr	1822(ra) # 8000714c <release>
  return 0;
    80003a36:	4481                	li	s1,0
    80003a38:	a819                	j	80003a4e <filealloc+0x5e>
      f->ref = 1;
    80003a3a:	4785                	li	a5,1
    80003a3c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a3e:	00019517          	auipc	a0,0x19
    80003a42:	d1a50513          	addi	a0,a0,-742 # 8001c758 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	706080e7          	jalr	1798(ra) # 8000714c <release>
}
    80003a4e:	8526                	mv	a0,s1
    80003a50:	60e2                	ld	ra,24(sp)
    80003a52:	6442                	ld	s0,16(sp)
    80003a54:	64a2                	ld	s1,8(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret

0000000080003a5a <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003a5a:	1101                	addi	sp,sp,-32
    80003a5c:	ec06                	sd	ra,24(sp)
    80003a5e:	e822                	sd	s0,16(sp)
    80003a60:	e426                	sd	s1,8(sp)
    80003a62:	1000                	addi	s0,sp,32
    80003a64:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a66:	00019517          	auipc	a0,0x19
    80003a6a:	cf250513          	addi	a0,a0,-782 # 8001c758 <ftable>
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	62a080e7          	jalr	1578(ra) # 80007098 <acquire>
  if (f->ref < 1) panic("filedup");
    80003a76:	40dc                	lw	a5,4(s1)
    80003a78:	02f05263          	blez	a5,80003a9c <filedup+0x42>
  f->ref++;
    80003a7c:	2785                	addiw	a5,a5,1
    80003a7e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a80:	00019517          	auipc	a0,0x19
    80003a84:	cd850513          	addi	a0,a0,-808 # 8001c758 <ftable>
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	6c4080e7          	jalr	1732(ra) # 8000714c <release>
  return f;
}
    80003a90:	8526                	mv	a0,s1
    80003a92:	60e2                	ld	ra,24(sp)
    80003a94:	6442                	ld	s0,16(sp)
    80003a96:	64a2                	ld	s1,8(sp)
    80003a98:	6105                	addi	sp,sp,32
    80003a9a:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003a9c:	00006517          	auipc	a0,0x6
    80003aa0:	abc50513          	addi	a0,a0,-1348 # 80009558 <etext+0x558>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	07a080e7          	jalr	122(ra) # 80006b1e <panic>

0000000080003aac <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003aac:	7139                	addi	sp,sp,-64
    80003aae:	fc06                	sd	ra,56(sp)
    80003ab0:	f822                	sd	s0,48(sp)
    80003ab2:	f426                	sd	s1,40(sp)
    80003ab4:	0080                	addi	s0,sp,64
    80003ab6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ab8:	00019517          	auipc	a0,0x19
    80003abc:	ca050513          	addi	a0,a0,-864 # 8001c758 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	5d8080e7          	jalr	1496(ra) # 80007098 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003ac8:	40dc                	lw	a5,4(s1)
    80003aca:	04f05c63          	blez	a5,80003b22 <fileclose+0x76>
  if (--f->ref > 0) {
    80003ace:	37fd                	addiw	a5,a5,-1
    80003ad0:	0007871b          	sext.w	a4,a5
    80003ad4:	c0dc                	sw	a5,4(s1)
    80003ad6:	06e04263          	bgtz	a4,80003b3a <fileclose+0x8e>
    80003ada:	f04a                	sd	s2,32(sp)
    80003adc:	ec4e                	sd	s3,24(sp)
    80003ade:	e852                	sd	s4,16(sp)
    80003ae0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ae2:	0004a903          	lw	s2,0(s1)
    80003ae6:	0094ca83          	lbu	s5,9(s1)
    80003aea:	0104ba03          	ld	s4,16(s1)
    80003aee:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003af2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003af6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003afa:	00019517          	auipc	a0,0x19
    80003afe:	c5e50513          	addi	a0,a0,-930 # 8001c758 <ftable>
    80003b02:	00003097          	auipc	ra,0x3
    80003b06:	64a080e7          	jalr	1610(ra) # 8000714c <release>

  if (ff.type == FD_PIPE) {
    80003b0a:	4785                	li	a5,1
    80003b0c:	04f90463          	beq	s2,a5,80003b54 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003b10:	3979                	addiw	s2,s2,-2
    80003b12:	4785                	li	a5,1
    80003b14:	0527fb63          	bgeu	a5,s2,80003b6a <fileclose+0xbe>
    80003b18:	7902                	ld	s2,32(sp)
    80003b1a:	69e2                	ld	s3,24(sp)
    80003b1c:	6a42                	ld	s4,16(sp)
    80003b1e:	6aa2                	ld	s5,8(sp)
    80003b20:	a02d                	j	80003b4a <fileclose+0x9e>
    80003b22:	f04a                	sd	s2,32(sp)
    80003b24:	ec4e                	sd	s3,24(sp)
    80003b26:	e852                	sd	s4,16(sp)
    80003b28:	e456                	sd	s5,8(sp)
  if (f->ref < 1) panic("fileclose");
    80003b2a:	00006517          	auipc	a0,0x6
    80003b2e:	a3650513          	addi	a0,a0,-1482 # 80009560 <etext+0x560>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	fec080e7          	jalr	-20(ra) # 80006b1e <panic>
    release(&ftable.lock);
    80003b3a:	00019517          	auipc	a0,0x19
    80003b3e:	c1e50513          	addi	a0,a0,-994 # 8001c758 <ftable>
    80003b42:	00003097          	auipc	ra,0x3
    80003b46:	60a080e7          	jalr	1546(ra) # 8000714c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b4a:	70e2                	ld	ra,56(sp)
    80003b4c:	7442                	ld	s0,48(sp)
    80003b4e:	74a2                	ld	s1,40(sp)
    80003b50:	6121                	addi	sp,sp,64
    80003b52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b54:	85d6                	mv	a1,s5
    80003b56:	8552                	mv	a0,s4
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	3a2080e7          	jalr	930(ra) # 80003efa <pipeclose>
    80003b60:	7902                	ld	s2,32(sp)
    80003b62:	69e2                	ld	s3,24(sp)
    80003b64:	6a42                	ld	s4,16(sp)
    80003b66:	6aa2                	ld	s5,8(sp)
    80003b68:	b7cd                	j	80003b4a <fileclose+0x9e>
    begin_op();
    80003b6a:	00000097          	auipc	ra,0x0
    80003b6e:	a78080e7          	jalr	-1416(ra) # 800035e2 <begin_op>
    iput(ff.ip);
    80003b72:	854e                	mv	a0,s3
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	25e080e7          	jalr	606(ra) # 80002dd2 <iput>
    end_op();
    80003b7c:	00000097          	auipc	ra,0x0
    80003b80:	ae0080e7          	jalr	-1312(ra) # 8000365c <end_op>
    80003b84:	7902                	ld	s2,32(sp)
    80003b86:	69e2                	ld	s3,24(sp)
    80003b88:	6a42                	ld	s4,16(sp)
    80003b8a:	6aa2                	ld	s5,8(sp)
    80003b8c:	bf7d                	j	80003b4a <fileclose+0x9e>

0000000080003b8e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003b8e:	715d                	addi	sp,sp,-80
    80003b90:	e486                	sd	ra,72(sp)
    80003b92:	e0a2                	sd	s0,64(sp)
    80003b94:	fc26                	sd	s1,56(sp)
    80003b96:	f44e                	sd	s3,40(sp)
    80003b98:	0880                	addi	s0,sp,80
    80003b9a:	84aa                	mv	s1,a0
    80003b9c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	3a8080e7          	jalr	936(ra) # 80000f46 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003ba6:	409c                	lw	a5,0(s1)
    80003ba8:	37f9                	addiw	a5,a5,-2
    80003baa:	4705                	li	a4,1
    80003bac:	04f76863          	bltu	a4,a5,80003bfc <filestat+0x6e>
    80003bb0:	f84a                	sd	s2,48(sp)
    80003bb2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	05e080e7          	jalr	94(ra) # 80002c14 <ilock>
    stati(f->ip, &st);
    80003bbe:	fb840593          	addi	a1,s0,-72
    80003bc2:	6c88                	ld	a0,24(s1)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	2de080e7          	jalr	734(ra) # 80002ea2 <stati>
    iunlock(f->ip);
    80003bcc:	6c88                	ld	a0,24(s1)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	10c080e7          	jalr	268(ra) # 80002cda <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003bd6:	46e1                	li	a3,24
    80003bd8:	fb840613          	addi	a2,s0,-72
    80003bdc:	85ce                	mv	a1,s3
    80003bde:	05093503          	ld	a0,80(s2)
    80003be2:	ffffd097          	auipc	ra,0xffffd
    80003be6:	faa080e7          	jalr	-86(ra) # 80000b8c <copyout>
    80003bea:	41f5551b          	sraiw	a0,a0,0x1f
    80003bee:	7942                	ld	s2,48(sp)
    return 0;
  }
  return -1;
}
    80003bf0:	60a6                	ld	ra,72(sp)
    80003bf2:	6406                	ld	s0,64(sp)
    80003bf4:	74e2                	ld	s1,56(sp)
    80003bf6:	79a2                	ld	s3,40(sp)
    80003bf8:	6161                	addi	sp,sp,80
    80003bfa:	8082                	ret
  return -1;
    80003bfc:	557d                	li	a0,-1
    80003bfe:	bfcd                	j	80003bf0 <filestat+0x62>

0000000080003c00 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003c00:	7179                	addi	sp,sp,-48
    80003c02:	f406                	sd	ra,40(sp)
    80003c04:	f022                	sd	s0,32(sp)
    80003c06:	e84a                	sd	s2,16(sp)
    80003c08:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003c0a:	00854783          	lbu	a5,8(a0)
    80003c0e:	cbc5                	beqz	a5,80003cbe <fileread+0xbe>
    80003c10:	ec26                	sd	s1,24(sp)
    80003c12:	e44e                	sd	s3,8(sp)
    80003c14:	84aa                	mv	s1,a0
    80003c16:	89ae                	mv	s3,a1
    80003c18:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003c1a:	411c                	lw	a5,0(a0)
    80003c1c:	4705                	li	a4,1
    80003c1e:	04e78963          	beq	a5,a4,80003c70 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003c22:	470d                	li	a4,3
    80003c24:	04e78f63          	beq	a5,a4,80003c82 <fileread+0x82>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003c28:	4709                	li	a4,2
    80003c2a:	08e79263          	bne	a5,a4,80003cae <fileread+0xae>
    ilock(f->ip);
    80003c2e:	6d08                	ld	a0,24(a0)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	fe4080e7          	jalr	-28(ra) # 80002c14 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003c38:	874a                	mv	a4,s2
    80003c3a:	5094                	lw	a3,32(s1)
    80003c3c:	864e                	mv	a2,s3
    80003c3e:	4585                	li	a1,1
    80003c40:	6c88                	ld	a0,24(s1)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	28a080e7          	jalr	650(ra) # 80002ecc <readi>
    80003c4a:	892a                	mv	s2,a0
    80003c4c:	00a05563          	blez	a0,80003c56 <fileread+0x56>
    80003c50:	509c                	lw	a5,32(s1)
    80003c52:	9fa9                	addw	a5,a5,a0
    80003c54:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c56:	6c88                	ld	a0,24(s1)
    80003c58:	fffff097          	auipc	ra,0xfffff
    80003c5c:	082080e7          	jalr	130(ra) # 80002cda <iunlock>
    80003c60:	64e2                	ld	s1,24(sp)
    80003c62:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c64:	854a                	mv	a0,s2
    80003c66:	70a2                	ld	ra,40(sp)
    80003c68:	7402                	ld	s0,32(sp)
    80003c6a:	6942                	ld	s2,16(sp)
    80003c6c:	6145                	addi	sp,sp,48
    80003c6e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c70:	6908                	ld	a0,16(a0)
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	400080e7          	jalr	1024(ra) # 80004072 <piperead>
    80003c7a:	892a                	mv	s2,a0
    80003c7c:	64e2                	ld	s1,24(sp)
    80003c7e:	69a2                	ld	s3,8(sp)
    80003c80:	b7d5                	j	80003c64 <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003c82:	02451783          	lh	a5,36(a0)
    80003c86:	03079693          	slli	a3,a5,0x30
    80003c8a:	92c1                	srli	a3,a3,0x30
    80003c8c:	4725                	li	a4,9
    80003c8e:	02d76a63          	bltu	a4,a3,80003cc2 <fileread+0xc2>
    80003c92:	0792                	slli	a5,a5,0x4
    80003c94:	00019717          	auipc	a4,0x19
    80003c98:	a2470713          	addi	a4,a4,-1500 # 8001c6b8 <devsw>
    80003c9c:	97ba                	add	a5,a5,a4
    80003c9e:	639c                	ld	a5,0(a5)
    80003ca0:	c78d                	beqz	a5,80003cca <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ca2:	4505                	li	a0,1
    80003ca4:	9782                	jalr	a5
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	64e2                	ld	s1,24(sp)
    80003caa:	69a2                	ld	s3,8(sp)
    80003cac:	bf65                	j	80003c64 <fileread+0x64>
    panic("fileread");
    80003cae:	00006517          	auipc	a0,0x6
    80003cb2:	8c250513          	addi	a0,a0,-1854 # 80009570 <etext+0x570>
    80003cb6:	00003097          	auipc	ra,0x3
    80003cba:	e68080e7          	jalr	-408(ra) # 80006b1e <panic>
  if (f->readable == 0) return -1;
    80003cbe:	597d                	li	s2,-1
    80003cc0:	b755                	j	80003c64 <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003cc2:	597d                	li	s2,-1
    80003cc4:	64e2                	ld	s1,24(sp)
    80003cc6:	69a2                	ld	s3,8(sp)
    80003cc8:	bf71                	j	80003c64 <fileread+0x64>
    80003cca:	597d                	li	s2,-1
    80003ccc:	64e2                	ld	s1,24(sp)
    80003cce:	69a2                	ld	s3,8(sp)
    80003cd0:	bf51                	j	80003c64 <fileread+0x64>

0000000080003cd2 <filewrite>:
// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003cd2:	00954783          	lbu	a5,9(a0)
    80003cd6:	12078963          	beqz	a5,80003e08 <filewrite+0x136>
int filewrite(struct file *f, uint64 addr, int n) {
    80003cda:	715d                	addi	sp,sp,-80
    80003cdc:	e486                	sd	ra,72(sp)
    80003cde:	e0a2                	sd	s0,64(sp)
    80003ce0:	f84a                	sd	s2,48(sp)
    80003ce2:	f052                	sd	s4,32(sp)
    80003ce4:	e85a                	sd	s6,16(sp)
    80003ce6:	0880                	addi	s0,sp,80
    80003ce8:	892a                	mv	s2,a0
    80003cea:	8b2e                	mv	s6,a1
    80003cec:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003cee:	411c                	lw	a5,0(a0)
    80003cf0:	4705                	li	a4,1
    80003cf2:	02e78763          	beq	a5,a4,80003d20 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003cf6:	470d                	li	a4,3
    80003cf8:	02e78a63          	beq	a5,a4,80003d2c <filewrite+0x5a>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003cfc:	4709                	li	a4,2
    80003cfe:	0ee79863          	bne	a5,a4,80003dee <filewrite+0x11c>
    80003d02:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003d04:	0cc05463          	blez	a2,80003dcc <filewrite+0xfa>
    80003d08:	fc26                	sd	s1,56(sp)
    80003d0a:	ec56                	sd	s5,24(sp)
    80003d0c:	e45e                	sd	s7,8(sp)
    80003d0e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d10:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max) n1 = max;
    80003d12:	6b85                	lui	s7,0x1
    80003d14:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d18:	6c05                	lui	s8,0x1
    80003d1a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d1e:	a851                	j	80003db2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d20:	6908                	ld	a0,16(a0)
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	248080e7          	jalr	584(ra) # 80003f6a <pipewrite>
    80003d2a:	a85d                	j	80003de0 <filewrite+0x10e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003d2c:	02451783          	lh	a5,36(a0)
    80003d30:	03079693          	slli	a3,a5,0x30
    80003d34:	92c1                	srli	a3,a3,0x30
    80003d36:	4725                	li	a4,9
    80003d38:	0cd76a63          	bltu	a4,a3,80003e0c <filewrite+0x13a>
    80003d3c:	0792                	slli	a5,a5,0x4
    80003d3e:	00019717          	auipc	a4,0x19
    80003d42:	97a70713          	addi	a4,a4,-1670 # 8001c6b8 <devsw>
    80003d46:	97ba                	add	a5,a5,a4
    80003d48:	679c                	ld	a5,8(a5)
    80003d4a:	c3f9                	beqz	a5,80003e10 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d4c:	4505                	li	a0,1
    80003d4e:	9782                	jalr	a5
    80003d50:	a841                	j	80003de0 <filewrite+0x10e>
      if (n1 > max) n1 = max;
    80003d52:	00048a9b          	sext.w	s5,s1

      begin_op();
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	88c080e7          	jalr	-1908(ra) # 800035e2 <begin_op>
      ilock(f->ip);
    80003d5e:	01893503          	ld	a0,24(s2)
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	eb2080e7          	jalr	-334(ra) # 80002c14 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003d6a:	8756                	mv	a4,s5
    80003d6c:	02092683          	lw	a3,32(s2)
    80003d70:	01698633          	add	a2,s3,s6
    80003d74:	4585                	li	a1,1
    80003d76:	01893503          	ld	a0,24(s2)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	262080e7          	jalr	610(ra) # 80002fdc <writei>
    80003d82:	84aa                	mv	s1,a0
    80003d84:	00a05763          	blez	a0,80003d92 <filewrite+0xc0>
    80003d88:	02092783          	lw	a5,32(s2)
    80003d8c:	9fa9                	addw	a5,a5,a0
    80003d8e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d92:	01893503          	ld	a0,24(s2)
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	f44080e7          	jalr	-188(ra) # 80002cda <iunlock>
      end_op();
    80003d9e:	00000097          	auipc	ra,0x0
    80003da2:	8be080e7          	jalr	-1858(ra) # 8000365c <end_op>

      if (r != n1) {
    80003da6:	029a9563          	bne	s5,s1,80003dd0 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003daa:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003dae:	0149da63          	bge	s3,s4,80003dc2 <filewrite+0xf0>
      int n1 = n - i;
    80003db2:	413a04bb          	subw	s1,s4,s3
      if (n1 > max) n1 = max;
    80003db6:	0004879b          	sext.w	a5,s1
    80003dba:	f8fbdce3          	bge	s7,a5,80003d52 <filewrite+0x80>
    80003dbe:	84e2                	mv	s1,s8
    80003dc0:	bf49                	j	80003d52 <filewrite+0x80>
    80003dc2:	74e2                	ld	s1,56(sp)
    80003dc4:	6ae2                	ld	s5,24(sp)
    80003dc6:	6ba2                	ld	s7,8(sp)
    80003dc8:	6c02                	ld	s8,0(sp)
    80003dca:	a039                	j	80003dd8 <filewrite+0x106>
    int i = 0;
    80003dcc:	4981                	li	s3,0
    80003dce:	a029                	j	80003dd8 <filewrite+0x106>
    80003dd0:	74e2                	ld	s1,56(sp)
    80003dd2:	6ae2                	ld	s5,24(sp)
    80003dd4:	6ba2                	ld	s7,8(sp)
    80003dd6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dd8:	033a1e63          	bne	s4,s3,80003e14 <filewrite+0x142>
    80003ddc:	8552                	mv	a0,s4
    80003dde:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003de0:	60a6                	ld	ra,72(sp)
    80003de2:	6406                	ld	s0,64(sp)
    80003de4:	7942                	ld	s2,48(sp)
    80003de6:	7a02                	ld	s4,32(sp)
    80003de8:	6b42                	ld	s6,16(sp)
    80003dea:	6161                	addi	sp,sp,80
    80003dec:	8082                	ret
    80003dee:	fc26                	sd	s1,56(sp)
    80003df0:	f44e                	sd	s3,40(sp)
    80003df2:	ec56                	sd	s5,24(sp)
    80003df4:	e45e                	sd	s7,8(sp)
    80003df6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003df8:	00005517          	auipc	a0,0x5
    80003dfc:	78850513          	addi	a0,a0,1928 # 80009580 <etext+0x580>
    80003e00:	00003097          	auipc	ra,0x3
    80003e04:	d1e080e7          	jalr	-738(ra) # 80006b1e <panic>
  if (f->writable == 0) return -1;
    80003e08:	557d                	li	a0,-1
}
    80003e0a:	8082                	ret
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003e0c:	557d                	li	a0,-1
    80003e0e:	bfc9                	j	80003de0 <filewrite+0x10e>
    80003e10:	557d                	li	a0,-1
    80003e12:	b7f9                	j	80003de0 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e14:	557d                	li	a0,-1
    80003e16:	79a2                	ld	s3,40(sp)
    80003e18:	b7e1                	j	80003de0 <filewrite+0x10e>

0000000080003e1a <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003e1a:	7179                	addi	sp,sp,-48
    80003e1c:	f406                	sd	ra,40(sp)
    80003e1e:	f022                	sd	s0,32(sp)
    80003e20:	ec26                	sd	s1,24(sp)
    80003e22:	e052                	sd	s4,0(sp)
    80003e24:	1800                	addi	s0,sp,48
    80003e26:	84aa                	mv	s1,a0
    80003e28:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e2a:	0005b023          	sd	zero,0(a1)
    80003e2e:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	bbe080e7          	jalr	-1090(ra) # 800039f0 <filealloc>
    80003e3a:	e088                	sd	a0,0(s1)
    80003e3c:	cd49                	beqz	a0,80003ed6 <pipealloc+0xbc>
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	bb2080e7          	jalr	-1102(ra) # 800039f0 <filealloc>
    80003e46:	00aa3023          	sd	a0,0(s4)
    80003e4a:	c141                	beqz	a0,80003eca <pipealloc+0xb0>
    80003e4c:	e84a                	sd	s2,16(sp)
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003e4e:	ffffc097          	auipc	ra,0xffffc
    80003e52:	2cc080e7          	jalr	716(ra) # 8000011a <kalloc>
    80003e56:	892a                	mv	s2,a0
    80003e58:	c13d                	beqz	a0,80003ebe <pipealloc+0xa4>
    80003e5a:	e44e                	sd	s3,8(sp)
  pi->readopen = 1;
    80003e5c:	4985                	li	s3,1
    80003e5e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e62:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e66:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e6a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e6e:	00005597          	auipc	a1,0x5
    80003e72:	72258593          	addi	a1,a1,1826 # 80009590 <etext+0x590>
    80003e76:	00003097          	auipc	ra,0x3
    80003e7a:	192080e7          	jalr	402(ra) # 80007008 <initlock>
  (*f0)->type = FD_PIPE;
    80003e7e:	609c                	ld	a5,0(s1)
    80003e80:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e84:	609c                	ld	a5,0(s1)
    80003e86:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e8a:	609c                	ld	a5,0(s1)
    80003e8c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e90:	609c                	ld	a5,0(s1)
    80003e92:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e96:	000a3783          	ld	a5,0(s4)
    80003e9a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e9e:	000a3783          	ld	a5,0(s4)
    80003ea2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ea6:	000a3783          	ld	a5,0(s4)
    80003eaa:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eae:	000a3783          	ld	a5,0(s4)
    80003eb2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eb6:	4501                	li	a0,0
    80003eb8:	6942                	ld	s2,16(sp)
    80003eba:	69a2                	ld	s3,8(sp)
    80003ebc:	a03d                	j	80003eea <pipealloc+0xd0>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003ebe:	6088                	ld	a0,0(s1)
    80003ec0:	c119                	beqz	a0,80003ec6 <pipealloc+0xac>
    80003ec2:	6942                	ld	s2,16(sp)
    80003ec4:	a029                	j	80003ece <pipealloc+0xb4>
    80003ec6:	6942                	ld	s2,16(sp)
    80003ec8:	a039                	j	80003ed6 <pipealloc+0xbc>
    80003eca:	6088                	ld	a0,0(s1)
    80003ecc:	c50d                	beqz	a0,80003ef6 <pipealloc+0xdc>
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	bde080e7          	jalr	-1058(ra) # 80003aac <fileclose>
  if (*f1) fileclose(*f1);
    80003ed6:	000a3783          	ld	a5,0(s4)
  return -1;
    80003eda:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003edc:	c799                	beqz	a5,80003eea <pipealloc+0xd0>
    80003ede:	853e                	mv	a0,a5
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	bcc080e7          	jalr	-1076(ra) # 80003aac <fileclose>
  return -1;
    80003ee8:	557d                	li	a0,-1
}
    80003eea:	70a2                	ld	ra,40(sp)
    80003eec:	7402                	ld	s0,32(sp)
    80003eee:	64e2                	ld	s1,24(sp)
    80003ef0:	6a02                	ld	s4,0(sp)
    80003ef2:	6145                	addi	sp,sp,48
    80003ef4:	8082                	ret
  return -1;
    80003ef6:	557d                	li	a0,-1
    80003ef8:	bfcd                	j	80003eea <pipealloc+0xd0>

0000000080003efa <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003efa:	1101                	addi	sp,sp,-32
    80003efc:	ec06                	sd	ra,24(sp)
    80003efe:	e822                	sd	s0,16(sp)
    80003f00:	e426                	sd	s1,8(sp)
    80003f02:	e04a                	sd	s2,0(sp)
    80003f04:	1000                	addi	s0,sp,32
    80003f06:	84aa                	mv	s1,a0
    80003f08:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f0a:	00003097          	auipc	ra,0x3
    80003f0e:	18e080e7          	jalr	398(ra) # 80007098 <acquire>
  if (writable) {
    80003f12:	02090d63          	beqz	s2,80003f4c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f16:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f1a:	21848513          	addi	a0,s1,536
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	73a080e7          	jalr	1850(ra) # 80001658 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003f26:	2204b783          	ld	a5,544(s1)
    80003f2a:	eb95                	bnez	a5,80003f5e <pipeclose+0x64>
    release(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00003097          	auipc	ra,0x3
    80003f32:	21e080e7          	jalr	542(ra) # 8000714c <release>
    kfree((char *)pi);
    80003f36:	8526                	mv	a0,s1
    80003f38:	ffffc097          	auipc	ra,0xffffc
    80003f3c:	0e4080e7          	jalr	228(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f40:	60e2                	ld	ra,24(sp)
    80003f42:	6442                	ld	s0,16(sp)
    80003f44:	64a2                	ld	s1,8(sp)
    80003f46:	6902                	ld	s2,0(sp)
    80003f48:	6105                	addi	sp,sp,32
    80003f4a:	8082                	ret
    pi->readopen = 0;
    80003f4c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f50:	21c48513          	addi	a0,s1,540
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	704080e7          	jalr	1796(ra) # 80001658 <wakeup>
    80003f5c:	b7e9                	j	80003f26 <pipeclose+0x2c>
    release(&pi->lock);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	00003097          	auipc	ra,0x3
    80003f64:	1ec080e7          	jalr	492(ra) # 8000714c <release>
}
    80003f68:	bfe1                	j	80003f40 <pipeclose+0x46>

0000000080003f6a <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003f6a:	711d                	addi	sp,sp,-96
    80003f6c:	ec86                	sd	ra,88(sp)
    80003f6e:	e8a2                	sd	s0,80(sp)
    80003f70:	e4a6                	sd	s1,72(sp)
    80003f72:	e0ca                	sd	s2,64(sp)
    80003f74:	fc4e                	sd	s3,56(sp)
    80003f76:	f852                	sd	s4,48(sp)
    80003f78:	f456                	sd	s5,40(sp)
    80003f7a:	1080                	addi	s0,sp,96
    80003f7c:	84aa                	mv	s1,a0
    80003f7e:	8aae                	mv	s5,a1
    80003f80:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	fc4080e7          	jalr	-60(ra) # 80000f46 <myproc>
    80003f8a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	00003097          	auipc	ra,0x3
    80003f92:	10a080e7          	jalr	266(ra) # 80007098 <acquire>
  while (i < n) {
    80003f96:	0d405863          	blez	s4,80004066 <pipewrite+0xfc>
    80003f9a:	f05a                	sd	s6,32(sp)
    80003f9c:	ec5e                	sd	s7,24(sp)
    80003f9e:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fa0:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003fa2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fa4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fa8:	21c48b93          	addi	s7,s1,540
    80003fac:	a089                	j	80003fee <pipewrite+0x84>
      release(&pi->lock);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00003097          	auipc	ra,0x3
    80003fb4:	19c080e7          	jalr	412(ra) # 8000714c <release>
      return -1;
    80003fb8:	597d                	li	s2,-1
    80003fba:	7b02                	ld	s6,32(sp)
    80003fbc:	6be2                	ld	s7,24(sp)
    80003fbe:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fc0:	854a                	mv	a0,s2
    80003fc2:	60e6                	ld	ra,88(sp)
    80003fc4:	6446                	ld	s0,80(sp)
    80003fc6:	64a6                	ld	s1,72(sp)
    80003fc8:	6906                	ld	s2,64(sp)
    80003fca:	79e2                	ld	s3,56(sp)
    80003fcc:	7a42                	ld	s4,48(sp)
    80003fce:	7aa2                	ld	s5,40(sp)
    80003fd0:	6125                	addi	sp,sp,96
    80003fd2:	8082                	ret
      wakeup(&pi->nread);
    80003fd4:	8562                	mv	a0,s8
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	682080e7          	jalr	1666(ra) # 80001658 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fde:	85a6                	mv	a1,s1
    80003fe0:	855e                	mv	a0,s7
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	612080e7          	jalr	1554(ra) # 800015f4 <sleep>
  while (i < n) {
    80003fea:	05495f63          	bge	s2,s4,80004048 <pipewrite+0xde>
    if (pi->readopen == 0 || killed(pr)) {
    80003fee:	2204a783          	lw	a5,544(s1)
    80003ff2:	dfd5                	beqz	a5,80003fae <pipewrite+0x44>
    80003ff4:	854e                	mv	a0,s3
    80003ff6:	ffffe097          	auipc	ra,0xffffe
    80003ffa:	8a6080e7          	jalr	-1882(ra) # 8000189c <killed>
    80003ffe:	f945                	bnez	a0,80003fae <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80004000:	2184a783          	lw	a5,536(s1)
    80004004:	21c4a703          	lw	a4,540(s1)
    80004008:	2007879b          	addiw	a5,a5,512
    8000400c:	fcf704e3          	beq	a4,a5,80003fd4 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80004010:	4685                	li	a3,1
    80004012:	01590633          	add	a2,s2,s5
    80004016:	faf40593          	addi	a1,s0,-81
    8000401a:	0509b503          	ld	a0,80(s3)
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	c4c080e7          	jalr	-948(ra) # 80000c6a <copyin>
    80004026:	05650263          	beq	a0,s6,8000406a <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000402a:	21c4a783          	lw	a5,540(s1)
    8000402e:	0017871b          	addiw	a4,a5,1
    80004032:	20e4ae23          	sw	a4,540(s1)
    80004036:	1ff7f793          	andi	a5,a5,511
    8000403a:	97a6                	add	a5,a5,s1
    8000403c:	faf44703          	lbu	a4,-81(s0)
    80004040:	00e78c23          	sb	a4,24(a5)
      i++;
    80004044:	2905                	addiw	s2,s2,1
    80004046:	b755                	j	80003fea <pipewrite+0x80>
    80004048:	7b02                	ld	s6,32(sp)
    8000404a:	6be2                	ld	s7,24(sp)
    8000404c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000404e:	21848513          	addi	a0,s1,536
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	606080e7          	jalr	1542(ra) # 80001658 <wakeup>
  release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00003097          	auipc	ra,0x3
    80004060:	0f0080e7          	jalr	240(ra) # 8000714c <release>
  return i;
    80004064:	bfb1                	j	80003fc0 <pipewrite+0x56>
  int i = 0;
    80004066:	4901                	li	s2,0
    80004068:	b7dd                	j	8000404e <pipewrite+0xe4>
    8000406a:	7b02                	ld	s6,32(sp)
    8000406c:	6be2                	ld	s7,24(sp)
    8000406e:	6c42                	ld	s8,16(sp)
    80004070:	bff9                	j	8000404e <pipewrite+0xe4>

0000000080004072 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80004072:	715d                	addi	sp,sp,-80
    80004074:	e486                	sd	ra,72(sp)
    80004076:	e0a2                	sd	s0,64(sp)
    80004078:	fc26                	sd	s1,56(sp)
    8000407a:	f84a                	sd	s2,48(sp)
    8000407c:	f44e                	sd	s3,40(sp)
    8000407e:	f052                	sd	s4,32(sp)
    80004080:	ec56                	sd	s5,24(sp)
    80004082:	0880                	addi	s0,sp,80
    80004084:	84aa                	mv	s1,a0
    80004086:	892e                	mv	s2,a1
    80004088:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	ebc080e7          	jalr	-324(ra) # 80000f46 <myproc>
    80004092:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004094:	8526                	mv	a0,s1
    80004096:	00003097          	auipc	ra,0x3
    8000409a:	002080e7          	jalr	2(ra) # 80007098 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000409e:	2184a703          	lw	a4,536(s1)
    800040a2:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    800040a6:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    800040aa:	02f71963          	bne	a4,a5,800040dc <piperead+0x6a>
    800040ae:	2244a783          	lw	a5,548(s1)
    800040b2:	cf95                	beqz	a5,800040ee <piperead+0x7c>
    if (killed(pr)) {
    800040b4:	8552                	mv	a0,s4
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	7e6080e7          	jalr	2022(ra) # 8000189c <killed>
    800040be:	e10d                	bnez	a0,800040e0 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    800040c0:	85a6                	mv	a1,s1
    800040c2:	854e                	mv	a0,s3
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	530080e7          	jalr	1328(ra) # 800015f4 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    800040cc:	2184a703          	lw	a4,536(s1)
    800040d0:	21c4a783          	lw	a5,540(s1)
    800040d4:	fcf70de3          	beq	a4,a5,800040ae <piperead+0x3c>
    800040d8:	e85a                	sd	s6,16(sp)
    800040da:	a819                	j	800040f0 <piperead+0x7e>
    800040dc:	e85a                	sd	s6,16(sp)
    800040de:	a809                	j	800040f0 <piperead+0x7e>
      release(&pi->lock);
    800040e0:	8526                	mv	a0,s1
    800040e2:	00003097          	auipc	ra,0x3
    800040e6:	06a080e7          	jalr	106(ra) # 8000714c <release>
      return -1;
    800040ea:	59fd                	li	s3,-1
    800040ec:	a0a5                	j	80004154 <piperead+0xe2>
    800040ee:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800040f0:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800040f2:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800040f4:	05505463          	blez	s5,8000413c <piperead+0xca>
    if (pi->nread == pi->nwrite) break;
    800040f8:	2184a783          	lw	a5,536(s1)
    800040fc:	21c4a703          	lw	a4,540(s1)
    80004100:	02f70e63          	beq	a4,a5,8000413c <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004104:	0017871b          	addiw	a4,a5,1
    80004108:	20e4ac23          	sw	a4,536(s1)
    8000410c:	1ff7f793          	andi	a5,a5,511
    80004110:	97a6                	add	a5,a5,s1
    80004112:	0187c783          	lbu	a5,24(a5)
    80004116:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    8000411a:	4685                	li	a3,1
    8000411c:	fbf40613          	addi	a2,s0,-65
    80004120:	85ca                	mv	a1,s2
    80004122:	050a3503          	ld	a0,80(s4)
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	a66080e7          	jalr	-1434(ra) # 80000b8c <copyout>
    8000412e:	01650763          	beq	a0,s6,8000413c <piperead+0xca>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004132:	2985                	addiw	s3,s3,1
    80004134:	0905                	addi	s2,s2,1
    80004136:	fd3a91e3          	bne	s5,s3,800040f8 <piperead+0x86>
    8000413a:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    8000413c:	21c48513          	addi	a0,s1,540
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	518080e7          	jalr	1304(ra) # 80001658 <wakeup>
  release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00003097          	auipc	ra,0x3
    8000414e:	002080e7          	jalr	2(ra) # 8000714c <release>
    80004152:	6b42                	ld	s6,16(sp)
  return i;
}
    80004154:	854e                	mv	a0,s3
    80004156:	60a6                	ld	ra,72(sp)
    80004158:	6406                	ld	s0,64(sp)
    8000415a:	74e2                	ld	s1,56(sp)
    8000415c:	7942                	ld	s2,48(sp)
    8000415e:	79a2                	ld	s3,40(sp)
    80004160:	7a02                	ld	s4,32(sp)
    80004162:	6ae2                	ld	s5,24(sp)
    80004164:	6161                	addi	sp,sp,80
    80004166:	8082                	ret

0000000080004168 <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004168:	1141                	addi	sp,sp,-16
    8000416a:	e422                	sd	s0,8(sp)
    8000416c:	0800                	addi	s0,sp,16
    8000416e:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80004170:	8905                	andi	a0,a0,1
    80004172:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80004174:	8b89                	andi	a5,a5,2
    80004176:	c399                	beqz	a5,8000417c <flags2perm+0x14>
    80004178:	00456513          	ori	a0,a0,4
  return perm;
}
    8000417c:	6422                	ld	s0,8(sp)
    8000417e:	0141                	addi	sp,sp,16
    80004180:	8082                	ret

0000000080004182 <exec>:

int exec(char *path, char **argv) {
    80004182:	df010113          	addi	sp,sp,-528
    80004186:	20113423          	sd	ra,520(sp)
    8000418a:	20813023          	sd	s0,512(sp)
    8000418e:	ffa6                	sd	s1,504(sp)
    80004190:	fbca                	sd	s2,496(sp)
    80004192:	0c00                	addi	s0,sp,528
    80004194:	892a                	mv	s2,a0
    80004196:	dea43c23          	sd	a0,-520(s0)
    8000419a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	da8080e7          	jalr	-600(ra) # 80000f46 <myproc>
    800041a6:	84aa                	mv	s1,a0

  begin_op();
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	43a080e7          	jalr	1082(ra) # 800035e2 <begin_op>

  if ((ip = namei(path)) == 0) {
    800041b0:	854a                	mv	a0,s2
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	230080e7          	jalr	560(ra) # 800033e2 <namei>
    800041ba:	c135                	beqz	a0,8000421e <exec+0x9c>
    800041bc:	f3d2                	sd	s4,480(sp)
    800041be:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	a54080e7          	jalr	-1452(ra) # 80002c14 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    800041c8:	04000713          	li	a4,64
    800041cc:	4681                	li	a3,0
    800041ce:	e5040613          	addi	a2,s0,-432
    800041d2:	4581                	li	a1,0
    800041d4:	8552                	mv	a0,s4
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	cf6080e7          	jalr	-778(ra) # 80002ecc <readi>
    800041de:	04000793          	li	a5,64
    800041e2:	00f51a63          	bne	a0,a5,800041f6 <exec+0x74>

  if (elf.magic != ELF_MAGIC) goto bad;
    800041e6:	e5042703          	lw	a4,-432(s0)
    800041ea:	464c47b7          	lui	a5,0x464c4
    800041ee:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041f2:	02f70c63          	beq	a4,a5,8000422a <exec+0xa8>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800041f6:	8552                	mv	a0,s4
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	c82080e7          	jalr	-894(ra) # 80002e7a <iunlockput>
    end_op();
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	45c080e7          	jalr	1116(ra) # 8000365c <end_op>
  }
  return -1;
    80004208:	557d                	li	a0,-1
    8000420a:	7a1e                	ld	s4,480(sp)
}
    8000420c:	20813083          	ld	ra,520(sp)
    80004210:	20013403          	ld	s0,512(sp)
    80004214:	74fe                	ld	s1,504(sp)
    80004216:	795e                	ld	s2,496(sp)
    80004218:	21010113          	addi	sp,sp,528
    8000421c:	8082                	ret
    end_op();
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	43e080e7          	jalr	1086(ra) # 8000365c <end_op>
    return -1;
    80004226:	557d                	li	a0,-1
    80004228:	b7d5                	j	8000420c <exec+0x8a>
    8000422a:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    8000422c:	8526                	mv	a0,s1
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	de0080e7          	jalr	-544(ra) # 8000100e <proc_pagetable>
    80004236:	8b2a                	mv	s6,a0
    80004238:	30050f63          	beqz	a0,80004556 <exec+0x3d4>
    8000423c:	f7ce                	sd	s3,488(sp)
    8000423e:	efd6                	sd	s5,472(sp)
    80004240:	e7de                	sd	s7,456(sp)
    80004242:	e3e2                	sd	s8,448(sp)
    80004244:	ff66                	sd	s9,440(sp)
    80004246:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004248:	e7042d03          	lw	s10,-400(s0)
    8000424c:	e8845783          	lhu	a5,-376(s0)
    80004250:	14078d63          	beqz	a5,800043aa <exec+0x228>
    80004254:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004256:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004258:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000425a:	6c85                	lui	s9,0x1
    8000425c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004260:	def43823          	sd	a5,-528(s0)
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004264:	6a85                	lui	s5,0x1
    80004266:	a0b5                	j	800042d2 <exec+0x150>
    if (pa == 0) panic("loadseg: address should exist");
    80004268:	00005517          	auipc	a0,0x5
    8000426c:	33050513          	addi	a0,a0,816 # 80009598 <etext+0x598>
    80004270:	00003097          	auipc	ra,0x3
    80004274:	8ae080e7          	jalr	-1874(ra) # 80006b1e <panic>
    if (sz - i < PGSIZE)
    80004278:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    8000427a:	8726                	mv	a4,s1
    8000427c:	012c06bb          	addw	a3,s8,s2
    80004280:	4581                	li	a1,0
    80004282:	8552                	mv	a0,s4
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	c48080e7          	jalr	-952(ra) # 80002ecc <readi>
    8000428c:	2501                	sext.w	a0,a0
    8000428e:	28a49863          	bne	s1,a0,8000451e <exec+0x39c>
  for (i = 0; i < sz; i += PGSIZE) {
    80004292:	012a893b          	addw	s2,s5,s2
    80004296:	03397563          	bgeu	s2,s3,800042c0 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000429a:	02091593          	slli	a1,s2,0x20
    8000429e:	9181                	srli	a1,a1,0x20
    800042a0:	95de                	add	a1,a1,s7
    800042a2:	855a                	mv	a0,s6
    800042a4:	ffffc097          	auipc	ra,0xffffc
    800042a8:	268080e7          	jalr	616(ra) # 8000050c <walkaddr>
    800042ac:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    800042ae:	dd4d                	beqz	a0,80004268 <exec+0xe6>
    if (sz - i < PGSIZE)
    800042b0:	412984bb          	subw	s1,s3,s2
    800042b4:	0004879b          	sext.w	a5,s1
    800042b8:	fcfcf0e3          	bgeu	s9,a5,80004278 <exec+0xf6>
    800042bc:	84d6                	mv	s1,s5
    800042be:	bf6d                	j	80004278 <exec+0xf6>
    sz = sz1;
    800042c0:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800042c4:	2d85                	addiw	s11,s11,1
    800042c6:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800042ca:	e8845783          	lhu	a5,-376(s0)
    800042ce:	08fdd663          	bge	s11,a5,8000435a <exec+0x1d8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    800042d2:	2d01                	sext.w	s10,s10
    800042d4:	03800713          	li	a4,56
    800042d8:	86ea                	mv	a3,s10
    800042da:	e1840613          	addi	a2,s0,-488
    800042de:	4581                	li	a1,0
    800042e0:	8552                	mv	a0,s4
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	bea080e7          	jalr	-1046(ra) # 80002ecc <readi>
    800042ea:	03800793          	li	a5,56
    800042ee:	20f51063          	bne	a0,a5,800044ee <exec+0x36c>
    if (ph.type != ELF_PROG_LOAD) continue;
    800042f2:	e1842783          	lw	a5,-488(s0)
    800042f6:	4705                	li	a4,1
    800042f8:	fce796e3          	bne	a5,a4,800042c4 <exec+0x142>
    if (ph.memsz < ph.filesz) goto bad;
    800042fc:	e4043483          	ld	s1,-448(s0)
    80004300:	e3843783          	ld	a5,-456(s0)
    80004304:	1ef4e963          	bltu	s1,a5,800044f6 <exec+0x374>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    80004308:	e2843783          	ld	a5,-472(s0)
    8000430c:	94be                	add	s1,s1,a5
    8000430e:	1ef4e863          	bltu	s1,a5,800044fe <exec+0x37c>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004312:	df043703          	ld	a4,-528(s0)
    80004316:	8ff9                	and	a5,a5,a4
    80004318:	1e079763          	bnez	a5,80004506 <exec+0x384>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000431c:	e1c42503          	lw	a0,-484(s0)
    80004320:	00000097          	auipc	ra,0x0
    80004324:	e48080e7          	jalr	-440(ra) # 80004168 <flags2perm>
    80004328:	86aa                	mv	a3,a0
    8000432a:	8626                	mv	a2,s1
    8000432c:	85ca                	mv	a1,s2
    8000432e:	855a                	mv	a0,s6
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	5f4080e7          	jalr	1524(ra) # 80000924 <uvmalloc>
    80004338:	e0a43423          	sd	a0,-504(s0)
    8000433c:	1c050963          	beqz	a0,8000450e <exec+0x38c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    80004340:	e2843b83          	ld	s7,-472(s0)
    80004344:	e2042c03          	lw	s8,-480(s0)
    80004348:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000434c:	00098463          	beqz	s3,80004354 <exec+0x1d2>
    80004350:	4901                	li	s2,0
    80004352:	b7a1                	j	8000429a <exec+0x118>
    sz = sz1;
    80004354:	e0843903          	ld	s2,-504(s0)
    80004358:	b7b5                	j	800042c4 <exec+0x142>
    8000435a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000435c:	8552                	mv	a0,s4
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	b1c080e7          	jalr	-1252(ra) # 80002e7a <iunlockput>
  end_op();
    80004366:	fffff097          	auipc	ra,0xfffff
    8000436a:	2f6080e7          	jalr	758(ra) # 8000365c <end_op>
  p = myproc();
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	bd8080e7          	jalr	-1064(ra) # 80000f46 <myproc>
    80004376:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004378:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000437c:	6985                	lui	s3,0x1
    8000437e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004380:	99ca                	add	s3,s3,s2
    80004382:	77fd                	lui	a5,0xfffff
    80004384:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004388:	4691                	li	a3,4
    8000438a:	6609                	lui	a2,0x2
    8000438c:	964e                	add	a2,a2,s3
    8000438e:	85ce                	mv	a1,s3
    80004390:	855a                	mv	a0,s6
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	592080e7          	jalr	1426(ra) # 80000924 <uvmalloc>
    8000439a:	892a                	mv	s2,a0
    8000439c:	e0a43423          	sd	a0,-504(s0)
    800043a0:	e519                	bnez	a0,800043ae <exec+0x22c>
  if (pagetable) proc_freepagetable(pagetable, sz);
    800043a2:	e1343423          	sd	s3,-504(s0)
    800043a6:	4a01                	li	s4,0
    800043a8:	aaa5                	j	80004520 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043aa:	4901                	li	s2,0
    800043ac:	bf45                	j	8000435c <exec+0x1da>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800043ae:	75f9                	lui	a1,0xffffe
    800043b0:	95aa                	add	a1,a1,a0
    800043b2:	855a                	mv	a0,s6
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	7a6080e7          	jalr	1958(ra) # 80000b5a <uvmclear>
  stackbase = sp - PGSIZE;
    800043bc:	7bfd                	lui	s7,0xfffff
    800043be:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++) {
    800043c0:	e0043783          	ld	a5,-512(s0)
    800043c4:	6388                	ld	a0,0(a5)
    800043c6:	c52d                	beqz	a0,80004430 <exec+0x2ae>
    800043c8:	e9040993          	addi	s3,s0,-368
    800043cc:	f9040c13          	addi	s8,s0,-112
    800043d0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	f1c080e7          	jalr	-228(ra) # 800002ee <strlen>
    800043da:	0015079b          	addiw	a5,a0,1
    800043de:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    800043e2:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    800043e6:	13796863          	bltu	s2,s7,80004516 <exec+0x394>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043ea:	e0043d03          	ld	s10,-512(s0)
    800043ee:	000d3a03          	ld	s4,0(s10)
    800043f2:	8552                	mv	a0,s4
    800043f4:	ffffc097          	auipc	ra,0xffffc
    800043f8:	efa080e7          	jalr	-262(ra) # 800002ee <strlen>
    800043fc:	0015069b          	addiw	a3,a0,1
    80004400:	8652                	mv	a2,s4
    80004402:	85ca                	mv	a1,s2
    80004404:	855a                	mv	a0,s6
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	786080e7          	jalr	1926(ra) # 80000b8c <copyout>
    8000440e:	10054663          	bltz	a0,8000451a <exec+0x398>
    ustack[argc] = sp;
    80004412:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    80004416:	0485                	addi	s1,s1,1
    80004418:	008d0793          	addi	a5,s10,8
    8000441c:	e0f43023          	sd	a5,-512(s0)
    80004420:	008d3503          	ld	a0,8(s10)
    80004424:	c909                	beqz	a0,80004436 <exec+0x2b4>
    if (argc >= MAXARG) goto bad;
    80004426:	09a1                	addi	s3,s3,8
    80004428:	fb8995e3          	bne	s3,s8,800043d2 <exec+0x250>
  ip = 0;
    8000442c:	4a01                	li	s4,0
    8000442e:	a8cd                	j	80004520 <exec+0x39e>
  sp = sz;
    80004430:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    80004434:	4481                	li	s1,0
  ustack[argc] = 0;
    80004436:	00349793          	slli	a5,s1,0x3
    8000443a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ff89210>
    8000443e:	97a2                	add	a5,a5,s0
    80004440:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004444:	00148693          	addi	a3,s1,1
    80004448:	068e                	slli	a3,a3,0x3
    8000444a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000444e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004452:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase) goto bad;
    80004456:	f57966e3          	bltu	s2,s7,800043a2 <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000445a:	e9040613          	addi	a2,s0,-368
    8000445e:	85ca                	mv	a1,s2
    80004460:	855a                	mv	a0,s6
    80004462:	ffffc097          	auipc	ra,0xffffc
    80004466:	72a080e7          	jalr	1834(ra) # 80000b8c <copyout>
    8000446a:	0e054863          	bltz	a0,8000455a <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000446e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004472:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004476:	df843783          	ld	a5,-520(s0)
    8000447a:	0007c703          	lbu	a4,0(a5)
    8000447e:	cf11                	beqz	a4,8000449a <exec+0x318>
    80004480:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    80004482:	02f00693          	li	a3,47
    80004486:	a039                	j	80004494 <exec+0x312>
    80004488:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    8000448c:	0785                	addi	a5,a5,1
    8000448e:	fff7c703          	lbu	a4,-1(a5)
    80004492:	c701                	beqz	a4,8000449a <exec+0x318>
    if (*s == '/') last = s + 1;
    80004494:	fed71ce3          	bne	a4,a3,8000448c <exec+0x30a>
    80004498:	bfc5                	j	80004488 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    8000449a:	4641                	li	a2,16
    8000449c:	df843583          	ld	a1,-520(s0)
    800044a0:	158a8513          	addi	a0,s5,344
    800044a4:	ffffc097          	auipc	ra,0xffffc
    800044a8:	e18080e7          	jalr	-488(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800044ac:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044b0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800044b4:	e0843783          	ld	a5,-504(s0)
    800044b8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044bc:	058ab783          	ld	a5,88(s5)
    800044c0:	e6843703          	ld	a4,-408(s0)
    800044c4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800044c6:	058ab783          	ld	a5,88(s5)
    800044ca:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ce:	85e6                	mv	a1,s9
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	bda080e7          	jalr	-1062(ra) # 800010aa <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800044d8:	0004851b          	sext.w	a0,s1
    800044dc:	79be                	ld	s3,488(sp)
    800044de:	7a1e                	ld	s4,480(sp)
    800044e0:	6afe                	ld	s5,472(sp)
    800044e2:	6b5e                	ld	s6,464(sp)
    800044e4:	6bbe                	ld	s7,456(sp)
    800044e6:	6c1e                	ld	s8,448(sp)
    800044e8:	7cfa                	ld	s9,440(sp)
    800044ea:	7d5a                	ld	s10,432(sp)
    800044ec:	b305                	j	8000420c <exec+0x8a>
    800044ee:	e1243423          	sd	s2,-504(s0)
    800044f2:	7dba                	ld	s11,424(sp)
    800044f4:	a035                	j	80004520 <exec+0x39e>
    800044f6:	e1243423          	sd	s2,-504(s0)
    800044fa:	7dba                	ld	s11,424(sp)
    800044fc:	a015                	j	80004520 <exec+0x39e>
    800044fe:	e1243423          	sd	s2,-504(s0)
    80004502:	7dba                	ld	s11,424(sp)
    80004504:	a831                	j	80004520 <exec+0x39e>
    80004506:	e1243423          	sd	s2,-504(s0)
    8000450a:	7dba                	ld	s11,424(sp)
    8000450c:	a811                	j	80004520 <exec+0x39e>
    8000450e:	e1243423          	sd	s2,-504(s0)
    80004512:	7dba                	ld	s11,424(sp)
    80004514:	a031                	j	80004520 <exec+0x39e>
  ip = 0;
    80004516:	4a01                	li	s4,0
    80004518:	a021                	j	80004520 <exec+0x39e>
    8000451a:	4a01                	li	s4,0
  if (pagetable) proc_freepagetable(pagetable, sz);
    8000451c:	a011                	j	80004520 <exec+0x39e>
    8000451e:	7dba                	ld	s11,424(sp)
    80004520:	e0843583          	ld	a1,-504(s0)
    80004524:	855a                	mv	a0,s6
    80004526:	ffffd097          	auipc	ra,0xffffd
    8000452a:	b84080e7          	jalr	-1148(ra) # 800010aa <proc_freepagetable>
  return -1;
    8000452e:	557d                	li	a0,-1
  if (ip) {
    80004530:	000a1b63          	bnez	s4,80004546 <exec+0x3c4>
    80004534:	79be                	ld	s3,488(sp)
    80004536:	7a1e                	ld	s4,480(sp)
    80004538:	6afe                	ld	s5,472(sp)
    8000453a:	6b5e                	ld	s6,464(sp)
    8000453c:	6bbe                	ld	s7,456(sp)
    8000453e:	6c1e                	ld	s8,448(sp)
    80004540:	7cfa                	ld	s9,440(sp)
    80004542:	7d5a                	ld	s10,432(sp)
    80004544:	b1e1                	j	8000420c <exec+0x8a>
    80004546:	79be                	ld	s3,488(sp)
    80004548:	6afe                	ld	s5,472(sp)
    8000454a:	6b5e                	ld	s6,464(sp)
    8000454c:	6bbe                	ld	s7,456(sp)
    8000454e:	6c1e                	ld	s8,448(sp)
    80004550:	7cfa                	ld	s9,440(sp)
    80004552:	7d5a                	ld	s10,432(sp)
    80004554:	b14d                	j	800041f6 <exec+0x74>
    80004556:	6b5e                	ld	s6,464(sp)
    80004558:	b979                	j	800041f6 <exec+0x74>
  sz = sz1;
    8000455a:	e0843983          	ld	s3,-504(s0)
    8000455e:	b591                	j	800043a2 <exec+0x220>

0000000080004560 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80004560:	7179                	addi	sp,sp,-48
    80004562:	f406                	sd	ra,40(sp)
    80004564:	f022                	sd	s0,32(sp)
    80004566:	ec26                	sd	s1,24(sp)
    80004568:	e84a                	sd	s2,16(sp)
    8000456a:	1800                	addi	s0,sp,48
    8000456c:	892e                	mv	s2,a1
    8000456e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004570:	fdc40593          	addi	a1,s0,-36
    80004574:	ffffe097          	auipc	ra,0xffffe
    80004578:	b08080e7          	jalr	-1272(ra) # 8000207c <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    8000457c:	fdc42703          	lw	a4,-36(s0)
    80004580:	47bd                	li	a5,15
    80004582:	02e7eb63          	bltu	a5,a4,800045b8 <argfd+0x58>
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	9c0080e7          	jalr	-1600(ra) # 80000f46 <myproc>
    8000458e:	fdc42703          	lw	a4,-36(s0)
    80004592:	01a70793          	addi	a5,a4,26
    80004596:	078e                	slli	a5,a5,0x3
    80004598:	953e                	add	a0,a0,a5
    8000459a:	611c                	ld	a5,0(a0)
    8000459c:	c385                	beqz	a5,800045bc <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000459e:	00090463          	beqz	s2,800045a6 <argfd+0x46>
    800045a2:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    800045a6:	4501                	li	a0,0
  if (pf) *pf = f;
    800045a8:	c091                	beqz	s1,800045ac <argfd+0x4c>
    800045aa:	e09c                	sd	a5,0(s1)
}
    800045ac:	70a2                	ld	ra,40(sp)
    800045ae:	7402                	ld	s0,32(sp)
    800045b0:	64e2                	ld	s1,24(sp)
    800045b2:	6942                	ld	s2,16(sp)
    800045b4:	6145                	addi	sp,sp,48
    800045b6:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800045b8:	557d                	li	a0,-1
    800045ba:	bfcd                	j	800045ac <argfd+0x4c>
    800045bc:	557d                	li	a0,-1
    800045be:	b7fd                	j	800045ac <argfd+0x4c>

00000000800045c0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    800045c0:	1101                	addi	sp,sp,-32
    800045c2:	ec06                	sd	ra,24(sp)
    800045c4:	e822                	sd	s0,16(sp)
    800045c6:	e426                	sd	s1,8(sp)
    800045c8:	1000                	addi	s0,sp,32
    800045ca:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045cc:	ffffd097          	auipc	ra,0xffffd
    800045d0:	97a080e7          	jalr	-1670(ra) # 80000f46 <myproc>
    800045d4:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    800045d6:	0d050793          	addi	a5,a0,208
    800045da:	4501                	li	a0,0
    800045dc:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    800045de:	6398                	ld	a4,0(a5)
    800045e0:	cb19                	beqz	a4,800045f6 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    800045e2:	2505                	addiw	a0,a0,1
    800045e4:	07a1                	addi	a5,a5,8
    800045e6:	fed51ce3          	bne	a0,a3,800045de <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045ea:	557d                	li	a0,-1
}
    800045ec:	60e2                	ld	ra,24(sp)
    800045ee:	6442                	ld	s0,16(sp)
    800045f0:	64a2                	ld	s1,8(sp)
    800045f2:	6105                	addi	sp,sp,32
    800045f4:	8082                	ret
      p->ofile[fd] = f;
    800045f6:	01a50793          	addi	a5,a0,26
    800045fa:	078e                	slli	a5,a5,0x3
    800045fc:	963e                	add	a2,a2,a5
    800045fe:	e204                	sd	s1,0(a2)
      return fd;
    80004600:	b7f5                	j	800045ec <fdalloc+0x2c>

0000000080004602 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    80004602:	715d                	addi	sp,sp,-80
    80004604:	e486                	sd	ra,72(sp)
    80004606:	e0a2                	sd	s0,64(sp)
    80004608:	fc26                	sd	s1,56(sp)
    8000460a:	f84a                	sd	s2,48(sp)
    8000460c:	f44e                	sd	s3,40(sp)
    8000460e:	ec56                	sd	s5,24(sp)
    80004610:	e85a                	sd	s6,16(sp)
    80004612:	0880                	addi	s0,sp,80
    80004614:	8b2e                	mv	s6,a1
    80004616:	89b2                	mv	s3,a2
    80004618:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    8000461a:	fb040593          	addi	a1,s0,-80
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	de2080e7          	jalr	-542(ra) # 80003400 <nameiparent>
    80004626:	84aa                	mv	s1,a0
    80004628:	14050e63          	beqz	a0,80004784 <create+0x182>

  ilock(dp);
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	5e8080e7          	jalr	1512(ra) # 80002c14 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004634:	4601                	li	a2,0
    80004636:	fb040593          	addi	a1,s0,-80
    8000463a:	8526                	mv	a0,s1
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	ae4080e7          	jalr	-1308(ra) # 80003120 <dirlookup>
    80004644:	8aaa                	mv	s5,a0
    80004646:	c539                	beqz	a0,80004694 <create+0x92>
    iunlockput(dp);
    80004648:	8526                	mv	a0,s1
    8000464a:	fffff097          	auipc	ra,0xfffff
    8000464e:	830080e7          	jalr	-2000(ra) # 80002e7a <iunlockput>
    ilock(ip);
    80004652:	8556                	mv	a0,s5
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	5c0080e7          	jalr	1472(ra) # 80002c14 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000465c:	4789                	li	a5,2
    8000465e:	02fb1463          	bne	s6,a5,80004686 <create+0x84>
    80004662:	044ad783          	lhu	a5,68(s5)
    80004666:	37f9                	addiw	a5,a5,-2
    80004668:	17c2                	slli	a5,a5,0x30
    8000466a:	93c1                	srli	a5,a5,0x30
    8000466c:	4705                	li	a4,1
    8000466e:	00f76c63          	bltu	a4,a5,80004686 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004672:	8556                	mv	a0,s5
    80004674:	60a6                	ld	ra,72(sp)
    80004676:	6406                	ld	s0,64(sp)
    80004678:	74e2                	ld	s1,56(sp)
    8000467a:	7942                	ld	s2,48(sp)
    8000467c:	79a2                	ld	s3,40(sp)
    8000467e:	6ae2                	ld	s5,24(sp)
    80004680:	6b42                	ld	s6,16(sp)
    80004682:	6161                	addi	sp,sp,80
    80004684:	8082                	ret
    iunlockput(ip);
    80004686:	8556                	mv	a0,s5
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	7f2080e7          	jalr	2034(ra) # 80002e7a <iunlockput>
    return 0;
    80004690:	4a81                	li	s5,0
    80004692:	b7c5                	j	80004672 <create+0x70>
    80004694:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004696:	85da                	mv	a1,s6
    80004698:	4088                	lw	a0,0(s1)
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	3d6080e7          	jalr	982(ra) # 80002a70 <ialloc>
    800046a2:	8a2a                	mv	s4,a0
    800046a4:	c531                	beqz	a0,800046f0 <create+0xee>
  ilock(ip);
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	56e080e7          	jalr	1390(ra) # 80002c14 <ilock>
  ip->major = major;
    800046ae:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046b2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046b6:	4905                	li	s2,1
    800046b8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046bc:	8552                	mv	a0,s4
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	48a080e7          	jalr	1162(ra) # 80002b48 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    800046c6:	032b0d63          	beq	s6,s2,80004700 <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800046ca:	004a2603          	lw	a2,4(s4)
    800046ce:	fb040593          	addi	a1,s0,-80
    800046d2:	8526                	mv	a0,s1
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c5c080e7          	jalr	-932(ra) # 80003330 <dirlink>
    800046dc:	08054163          	bltz	a0,8000475e <create+0x15c>
  iunlockput(dp);
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	798080e7          	jalr	1944(ra) # 80002e7a <iunlockput>
  return ip;
    800046ea:	8ad2                	mv	s5,s4
    800046ec:	7a02                	ld	s4,32(sp)
    800046ee:	b751                	j	80004672 <create+0x70>
    iunlockput(dp);
    800046f0:	8526                	mv	a0,s1
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	788080e7          	jalr	1928(ra) # 80002e7a <iunlockput>
    return 0;
    800046fa:	8ad2                	mv	s5,s4
    800046fc:	7a02                	ld	s4,32(sp)
    800046fe:	bf95                	j	80004672 <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004700:	004a2603          	lw	a2,4(s4)
    80004704:	00005597          	auipc	a1,0x5
    80004708:	eb458593          	addi	a1,a1,-332 # 800095b8 <etext+0x5b8>
    8000470c:	8552                	mv	a0,s4
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	c22080e7          	jalr	-990(ra) # 80003330 <dirlink>
    80004716:	04054463          	bltz	a0,8000475e <create+0x15c>
    8000471a:	40d0                	lw	a2,4(s1)
    8000471c:	00005597          	auipc	a1,0x5
    80004720:	ea458593          	addi	a1,a1,-348 # 800095c0 <etext+0x5c0>
    80004724:	8552                	mv	a0,s4
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	c0a080e7          	jalr	-1014(ra) # 80003330 <dirlink>
    8000472e:	02054863          	bltz	a0,8000475e <create+0x15c>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004732:	004a2603          	lw	a2,4(s4)
    80004736:	fb040593          	addi	a1,s0,-80
    8000473a:	8526                	mv	a0,s1
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	bf4080e7          	jalr	-1036(ra) # 80003330 <dirlink>
    80004744:	00054d63          	bltz	a0,8000475e <create+0x15c>
    dp->nlink++;  // for ".."
    80004748:	04a4d783          	lhu	a5,74(s1)
    8000474c:	2785                	addiw	a5,a5,1
    8000474e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004752:	8526                	mv	a0,s1
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	3f4080e7          	jalr	1012(ra) # 80002b48 <iupdate>
    8000475c:	b751                	j	800046e0 <create+0xde>
  ip->nlink = 0;
    8000475e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004762:	8552                	mv	a0,s4
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	3e4080e7          	jalr	996(ra) # 80002b48 <iupdate>
  iunlockput(ip);
    8000476c:	8552                	mv	a0,s4
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	70c080e7          	jalr	1804(ra) # 80002e7a <iunlockput>
  iunlockput(dp);
    80004776:	8526                	mv	a0,s1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	702080e7          	jalr	1794(ra) # 80002e7a <iunlockput>
  return 0;
    80004780:	7a02                	ld	s4,32(sp)
    80004782:	bdc5                	j	80004672 <create+0x70>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004784:	8aaa                	mv	s5,a0
    80004786:	b5f5                	j	80004672 <create+0x70>

0000000080004788 <sys_dup>:
uint64 sys_dup(void) {
    80004788:	7179                	addi	sp,sp,-48
    8000478a:	f406                	sd	ra,40(sp)
    8000478c:	f022                	sd	s0,32(sp)
    8000478e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004790:	fd840613          	addi	a2,s0,-40
    80004794:	4581                	li	a1,0
    80004796:	4501                	li	a0,0
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	dc8080e7          	jalr	-568(ra) # 80004560 <argfd>
    800047a0:	57fd                	li	a5,-1
    800047a2:	02054763          	bltz	a0,800047d0 <sys_dup+0x48>
    800047a6:	ec26                	sd	s1,24(sp)
    800047a8:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0) return -1;
    800047aa:	fd843903          	ld	s2,-40(s0)
    800047ae:	854a                	mv	a0,s2
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	e10080e7          	jalr	-496(ra) # 800045c0 <fdalloc>
    800047b8:	84aa                	mv	s1,a0
    800047ba:	57fd                	li	a5,-1
    800047bc:	00054f63          	bltz	a0,800047da <sys_dup+0x52>
  filedup(f);
    800047c0:	854a                	mv	a0,s2
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	298080e7          	jalr	664(ra) # 80003a5a <filedup>
  return fd;
    800047ca:	87a6                	mv	a5,s1
    800047cc:	64e2                	ld	s1,24(sp)
    800047ce:	6942                	ld	s2,16(sp)
}
    800047d0:	853e                	mv	a0,a5
    800047d2:	70a2                	ld	ra,40(sp)
    800047d4:	7402                	ld	s0,32(sp)
    800047d6:	6145                	addi	sp,sp,48
    800047d8:	8082                	ret
    800047da:	64e2                	ld	s1,24(sp)
    800047dc:	6942                	ld	s2,16(sp)
    800047de:	bfcd                	j	800047d0 <sys_dup+0x48>

00000000800047e0 <sys_read>:
uint64 sys_read(void) {
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047e8:	fd840593          	addi	a1,s0,-40
    800047ec:	4505                	li	a0,1
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	8ae080e7          	jalr	-1874(ra) # 8000209c <argaddr>
  argint(2, &n);
    800047f6:	fe440593          	addi	a1,s0,-28
    800047fa:	4509                	li	a0,2
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	880080e7          	jalr	-1920(ra) # 8000207c <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004804:	fe840613          	addi	a2,s0,-24
    80004808:	4581                	li	a1,0
    8000480a:	4501                	li	a0,0
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	d54080e7          	jalr	-684(ra) # 80004560 <argfd>
    80004814:	87aa                	mv	a5,a0
    80004816:	557d                	li	a0,-1
    80004818:	0007cc63          	bltz	a5,80004830 <sys_read+0x50>
  return fileread(f, p, n);
    8000481c:	fe442603          	lw	a2,-28(s0)
    80004820:	fd843583          	ld	a1,-40(s0)
    80004824:	fe843503          	ld	a0,-24(s0)
    80004828:	fffff097          	auipc	ra,0xfffff
    8000482c:	3d8080e7          	jalr	984(ra) # 80003c00 <fileread>
}
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	6145                	addi	sp,sp,48
    80004836:	8082                	ret

0000000080004838 <sys_write>:
uint64 sys_write(void) {
    80004838:	7179                	addi	sp,sp,-48
    8000483a:	f406                	sd	ra,40(sp)
    8000483c:	f022                	sd	s0,32(sp)
    8000483e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004840:	fd840593          	addi	a1,s0,-40
    80004844:	4505                	li	a0,1
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	856080e7          	jalr	-1962(ra) # 8000209c <argaddr>
  argint(2, &n);
    8000484e:	fe440593          	addi	a1,s0,-28
    80004852:	4509                	li	a0,2
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	828080e7          	jalr	-2008(ra) # 8000207c <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    8000485c:	fe840613          	addi	a2,s0,-24
    80004860:	4581                	li	a1,0
    80004862:	4501                	li	a0,0
    80004864:	00000097          	auipc	ra,0x0
    80004868:	cfc080e7          	jalr	-772(ra) # 80004560 <argfd>
    8000486c:	87aa                	mv	a5,a0
    8000486e:	557d                	li	a0,-1
    80004870:	0007cc63          	bltz	a5,80004888 <sys_write+0x50>
  return filewrite(f, p, n);
    80004874:	fe442603          	lw	a2,-28(s0)
    80004878:	fd843583          	ld	a1,-40(s0)
    8000487c:	fe843503          	ld	a0,-24(s0)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	452080e7          	jalr	1106(ra) # 80003cd2 <filewrite>
}
    80004888:	70a2                	ld	ra,40(sp)
    8000488a:	7402                	ld	s0,32(sp)
    8000488c:	6145                	addi	sp,sp,48
    8000488e:	8082                	ret

0000000080004890 <sys_close>:
uint64 sys_close(void) {
    80004890:	1101                	addi	sp,sp,-32
    80004892:	ec06                	sd	ra,24(sp)
    80004894:	e822                	sd	s0,16(sp)
    80004896:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004898:	fe040613          	addi	a2,s0,-32
    8000489c:	fec40593          	addi	a1,s0,-20
    800048a0:	4501                	li	a0,0
    800048a2:	00000097          	auipc	ra,0x0
    800048a6:	cbe080e7          	jalr	-834(ra) # 80004560 <argfd>
    800048aa:	57fd                	li	a5,-1
    800048ac:	02054463          	bltz	a0,800048d4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	696080e7          	jalr	1686(ra) # 80000f46 <myproc>
    800048b8:	fec42783          	lw	a5,-20(s0)
    800048bc:	07e9                	addi	a5,a5,26
    800048be:	078e                	slli	a5,a5,0x3
    800048c0:	953e                	add	a0,a0,a5
    800048c2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048c6:	fe043503          	ld	a0,-32(s0)
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	1e2080e7          	jalr	482(ra) # 80003aac <fileclose>
  return 0;
    800048d2:	4781                	li	a5,0
}
    800048d4:	853e                	mv	a0,a5
    800048d6:	60e2                	ld	ra,24(sp)
    800048d8:	6442                	ld	s0,16(sp)
    800048da:	6105                	addi	sp,sp,32
    800048dc:	8082                	ret

00000000800048de <sys_fstat>:
uint64 sys_fstat(void) {
    800048de:	1101                	addi	sp,sp,-32
    800048e0:	ec06                	sd	ra,24(sp)
    800048e2:	e822                	sd	s0,16(sp)
    800048e4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048e6:	fe040593          	addi	a1,s0,-32
    800048ea:	4505                	li	a0,1
    800048ec:	ffffd097          	auipc	ra,0xffffd
    800048f0:	7b0080e7          	jalr	1968(ra) # 8000209c <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    800048f4:	fe840613          	addi	a2,s0,-24
    800048f8:	4581                	li	a1,0
    800048fa:	4501                	li	a0,0
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	c64080e7          	jalr	-924(ra) # 80004560 <argfd>
    80004904:	87aa                	mv	a5,a0
    80004906:	557d                	li	a0,-1
    80004908:	0007ca63          	bltz	a5,8000491c <sys_fstat+0x3e>
  return filestat(f, st);
    8000490c:	fe043583          	ld	a1,-32(s0)
    80004910:	fe843503          	ld	a0,-24(s0)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	27a080e7          	jalr	634(ra) # 80003b8e <filestat>
}
    8000491c:	60e2                	ld	ra,24(sp)
    8000491e:	6442                	ld	s0,16(sp)
    80004920:	6105                	addi	sp,sp,32
    80004922:	8082                	ret

0000000080004924 <sys_link>:
uint64 sys_link(void) {
    80004924:	7169                	addi	sp,sp,-304
    80004926:	f606                	sd	ra,296(sp)
    80004928:	f222                	sd	s0,288(sp)
    8000492a:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    8000492c:	08000613          	li	a2,128
    80004930:	ed040593          	addi	a1,s0,-304
    80004934:	4501                	li	a0,0
    80004936:	ffffd097          	auipc	ra,0xffffd
    8000493a:	786080e7          	jalr	1926(ra) # 800020bc <argstr>
    8000493e:	57fd                	li	a5,-1
    80004940:	12054663          	bltz	a0,80004a6c <sys_link+0x148>
    80004944:	08000613          	li	a2,128
    80004948:	f5040593          	addi	a1,s0,-176
    8000494c:	4505                	li	a0,1
    8000494e:	ffffd097          	auipc	ra,0xffffd
    80004952:	76e080e7          	jalr	1902(ra) # 800020bc <argstr>
    80004956:	57fd                	li	a5,-1
    80004958:	10054a63          	bltz	a0,80004a6c <sys_link+0x148>
    8000495c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	c84080e7          	jalr	-892(ra) # 800035e2 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004966:	ed040513          	addi	a0,s0,-304
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	a78080e7          	jalr	-1416(ra) # 800033e2 <namei>
    80004972:	84aa                	mv	s1,a0
    80004974:	c949                	beqz	a0,80004a06 <sys_link+0xe2>
  ilock(ip);
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	29e080e7          	jalr	670(ra) # 80002c14 <ilock>
  if (ip->type == T_DIR) {
    8000497e:	04449703          	lh	a4,68(s1)
    80004982:	4785                	li	a5,1
    80004984:	08f70863          	beq	a4,a5,80004a14 <sys_link+0xf0>
    80004988:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000498a:	04a4d783          	lhu	a5,74(s1)
    8000498e:	2785                	addiw	a5,a5,1
    80004990:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	1b2080e7          	jalr	434(ra) # 80002b48 <iupdate>
  iunlock(ip);
    8000499e:	8526                	mv	a0,s1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	33a080e7          	jalr	826(ra) # 80002cda <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    800049a8:	fd040593          	addi	a1,s0,-48
    800049ac:	f5040513          	addi	a0,s0,-176
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	a50080e7          	jalr	-1456(ra) # 80003400 <nameiparent>
    800049b8:	892a                	mv	s2,a0
    800049ba:	cd35                	beqz	a0,80004a36 <sys_link+0x112>
  ilock(dp);
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	258080e7          	jalr	600(ra) # 80002c14 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    800049c4:	00092703          	lw	a4,0(s2)
    800049c8:	409c                	lw	a5,0(s1)
    800049ca:	06f71163          	bne	a4,a5,80004a2c <sys_link+0x108>
    800049ce:	40d0                	lw	a2,4(s1)
    800049d0:	fd040593          	addi	a1,s0,-48
    800049d4:	854a                	mv	a0,s2
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	95a080e7          	jalr	-1702(ra) # 80003330 <dirlink>
    800049de:	04054763          	bltz	a0,80004a2c <sys_link+0x108>
  iunlockput(dp);
    800049e2:	854a                	mv	a0,s2
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	496080e7          	jalr	1174(ra) # 80002e7a <iunlockput>
  iput(ip);
    800049ec:	8526                	mv	a0,s1
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	3e4080e7          	jalr	996(ra) # 80002dd2 <iput>
  end_op();
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	c66080e7          	jalr	-922(ra) # 8000365c <end_op>
  return 0;
    800049fe:	4781                	li	a5,0
    80004a00:	64f2                	ld	s1,280(sp)
    80004a02:	6952                	ld	s2,272(sp)
    80004a04:	a0a5                	j	80004a6c <sys_link+0x148>
    end_op();
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	c56080e7          	jalr	-938(ra) # 8000365c <end_op>
    return -1;
    80004a0e:	57fd                	li	a5,-1
    80004a10:	64f2                	ld	s1,280(sp)
    80004a12:	a8a9                	j	80004a6c <sys_link+0x148>
    iunlockput(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	464080e7          	jalr	1124(ra) # 80002e7a <iunlockput>
    end_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	c3e080e7          	jalr	-962(ra) # 8000365c <end_op>
    return -1;
    80004a26:	57fd                	li	a5,-1
    80004a28:	64f2                	ld	s1,280(sp)
    80004a2a:	a089                	j	80004a6c <sys_link+0x148>
    iunlockput(dp);
    80004a2c:	854a                	mv	a0,s2
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	44c080e7          	jalr	1100(ra) # 80002e7a <iunlockput>
  ilock(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	1dc080e7          	jalr	476(ra) # 80002c14 <ilock>
  ip->nlink--;
    80004a40:	04a4d783          	lhu	a5,74(s1)
    80004a44:	37fd                	addiw	a5,a5,-1
    80004a46:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	0fc080e7          	jalr	252(ra) # 80002b48 <iupdate>
  iunlockput(ip);
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	424080e7          	jalr	1060(ra) # 80002e7a <iunlockput>
  end_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	bfe080e7          	jalr	-1026(ra) # 8000365c <end_op>
  return -1;
    80004a66:	57fd                	li	a5,-1
    80004a68:	64f2                	ld	s1,280(sp)
    80004a6a:	6952                	ld	s2,272(sp)
}
    80004a6c:	853e                	mv	a0,a5
    80004a6e:	70b2                	ld	ra,296(sp)
    80004a70:	7412                	ld	s0,288(sp)
    80004a72:	6155                	addi	sp,sp,304
    80004a74:	8082                	ret

0000000080004a76 <sys_unlink>:
uint64 sys_unlink(void) {
    80004a76:	7151                	addi	sp,sp,-240
    80004a78:	f586                	sd	ra,232(sp)
    80004a7a:	f1a2                	sd	s0,224(sp)
    80004a7c:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004a7e:	08000613          	li	a2,128
    80004a82:	f3040593          	addi	a1,s0,-208
    80004a86:	4501                	li	a0,0
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	634080e7          	jalr	1588(ra) # 800020bc <argstr>
    80004a90:	1a054a63          	bltz	a0,80004c44 <sys_unlink+0x1ce>
    80004a94:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	b4c080e7          	jalr	-1204(ra) # 800035e2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004a9e:	fb040593          	addi	a1,s0,-80
    80004aa2:	f3040513          	addi	a0,s0,-208
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	95a080e7          	jalr	-1702(ra) # 80003400 <nameiparent>
    80004aae:	84aa                	mv	s1,a0
    80004ab0:	cd71                	beqz	a0,80004b8c <sys_unlink+0x116>
  ilock(dp);
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	162080e7          	jalr	354(ra) # 80002c14 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004aba:	00005597          	auipc	a1,0x5
    80004abe:	afe58593          	addi	a1,a1,-1282 # 800095b8 <etext+0x5b8>
    80004ac2:	fb040513          	addi	a0,s0,-80
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	640080e7          	jalr	1600(ra) # 80003106 <namecmp>
    80004ace:	14050c63          	beqz	a0,80004c26 <sys_unlink+0x1b0>
    80004ad2:	00005597          	auipc	a1,0x5
    80004ad6:	aee58593          	addi	a1,a1,-1298 # 800095c0 <etext+0x5c0>
    80004ada:	fb040513          	addi	a0,s0,-80
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	628080e7          	jalr	1576(ra) # 80003106 <namecmp>
    80004ae6:	14050063          	beqz	a0,80004c26 <sys_unlink+0x1b0>
    80004aea:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004aec:	f2c40613          	addi	a2,s0,-212
    80004af0:	fb040593          	addi	a1,s0,-80
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	62a080e7          	jalr	1578(ra) # 80003120 <dirlookup>
    80004afe:	892a                	mv	s2,a0
    80004b00:	12050263          	beqz	a0,80004c24 <sys_unlink+0x1ae>
  ilock(ip);
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	110080e7          	jalr	272(ra) # 80002c14 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004b0c:	04a91783          	lh	a5,74(s2)
    80004b10:	08f05563          	blez	a5,80004b9a <sys_unlink+0x124>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004b14:	04491703          	lh	a4,68(s2)
    80004b18:	4785                	li	a5,1
    80004b1a:	08f70963          	beq	a4,a5,80004bac <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b1e:	4641                	li	a2,16
    80004b20:	4581                	li	a1,0
    80004b22:	fc040513          	addi	a0,s0,-64
    80004b26:	ffffb097          	auipc	ra,0xffffb
    80004b2a:	654080e7          	jalr	1620(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b2e:	4741                	li	a4,16
    80004b30:	f2c42683          	lw	a3,-212(s0)
    80004b34:	fc040613          	addi	a2,s0,-64
    80004b38:	4581                	li	a1,0
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	4a0080e7          	jalr	1184(ra) # 80002fdc <writei>
    80004b44:	47c1                	li	a5,16
    80004b46:	0af51b63          	bne	a0,a5,80004bfc <sys_unlink+0x186>
  if (ip->type == T_DIR) {
    80004b4a:	04491703          	lh	a4,68(s2)
    80004b4e:	4785                	li	a5,1
    80004b50:	0af70f63          	beq	a4,a5,80004c0e <sys_unlink+0x198>
  iunlockput(dp);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	324080e7          	jalr	804(ra) # 80002e7a <iunlockput>
  ip->nlink--;
    80004b5e:	04a95783          	lhu	a5,74(s2)
    80004b62:	37fd                	addiw	a5,a5,-1
    80004b64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	fde080e7          	jalr	-34(ra) # 80002b48 <iupdate>
  iunlockput(ip);
    80004b72:	854a                	mv	a0,s2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	306080e7          	jalr	774(ra) # 80002e7a <iunlockput>
  end_op();
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	ae0080e7          	jalr	-1312(ra) # 8000365c <end_op>
  return 0;
    80004b84:	4501                	li	a0,0
    80004b86:	64ee                	ld	s1,216(sp)
    80004b88:	694e                	ld	s2,208(sp)
    80004b8a:	a84d                	j	80004c3c <sys_unlink+0x1c6>
    end_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	ad0080e7          	jalr	-1328(ra) # 8000365c <end_op>
    return -1;
    80004b94:	557d                	li	a0,-1
    80004b96:	64ee                	ld	s1,216(sp)
    80004b98:	a055                	j	80004c3c <sys_unlink+0x1c6>
    80004b9a:	e5ce                	sd	s3,200(sp)
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004b9c:	00005517          	auipc	a0,0x5
    80004ba0:	a2c50513          	addi	a0,a0,-1492 # 800095c8 <etext+0x5c8>
    80004ba4:	00002097          	auipc	ra,0x2
    80004ba8:	f7a080e7          	jalr	-134(ra) # 80006b1e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004bac:	04c92703          	lw	a4,76(s2)
    80004bb0:	02000793          	li	a5,32
    80004bb4:	f6e7f5e3          	bgeu	a5,a4,80004b1e <sys_unlink+0xa8>
    80004bb8:	e5ce                	sd	s3,200(sp)
    80004bba:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bbe:	4741                	li	a4,16
    80004bc0:	86ce                	mv	a3,s3
    80004bc2:	f1840613          	addi	a2,s0,-232
    80004bc6:	4581                	li	a1,0
    80004bc8:	854a                	mv	a0,s2
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	302080e7          	jalr	770(ra) # 80002ecc <readi>
    80004bd2:	47c1                	li	a5,16
    80004bd4:	00f51c63          	bne	a0,a5,80004bec <sys_unlink+0x176>
    if (de.inum != 0) return 0;
    80004bd8:	f1845783          	lhu	a5,-232(s0)
    80004bdc:	e7b5                	bnez	a5,80004c48 <sys_unlink+0x1d2>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004bde:	29c1                	addiw	s3,s3,16
    80004be0:	04c92783          	lw	a5,76(s2)
    80004be4:	fcf9ede3          	bltu	s3,a5,80004bbe <sys_unlink+0x148>
    80004be8:	69ae                	ld	s3,200(sp)
    80004bea:	bf15                	j	80004b1e <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bec:	00005517          	auipc	a0,0x5
    80004bf0:	9f450513          	addi	a0,a0,-1548 # 800095e0 <etext+0x5e0>
    80004bf4:	00002097          	auipc	ra,0x2
    80004bf8:	f2a080e7          	jalr	-214(ra) # 80006b1e <panic>
    80004bfc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bfe:	00005517          	auipc	a0,0x5
    80004c02:	9fa50513          	addi	a0,a0,-1542 # 800095f8 <etext+0x5f8>
    80004c06:	00002097          	auipc	ra,0x2
    80004c0a:	f18080e7          	jalr	-232(ra) # 80006b1e <panic>
    dp->nlink--;
    80004c0e:	04a4d783          	lhu	a5,74(s1)
    80004c12:	37fd                	addiw	a5,a5,-1
    80004c14:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	f2e080e7          	jalr	-210(ra) # 80002b48 <iupdate>
    80004c22:	bf0d                	j	80004b54 <sys_unlink+0xde>
    80004c24:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	252080e7          	jalr	594(ra) # 80002e7a <iunlockput>
  end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	a2c080e7          	jalr	-1492(ra) # 8000365c <end_op>
  return -1;
    80004c38:	557d                	li	a0,-1
    80004c3a:	64ee                	ld	s1,216(sp)
}
    80004c3c:	70ae                	ld	ra,232(sp)
    80004c3e:	740e                	ld	s0,224(sp)
    80004c40:	616d                	addi	sp,sp,240
    80004c42:	8082                	ret
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004c44:	557d                	li	a0,-1
    80004c46:	bfdd                	j	80004c3c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	230080e7          	jalr	560(ra) # 80002e7a <iunlockput>
    goto bad;
    80004c52:	694e                	ld	s2,208(sp)
    80004c54:	69ae                	ld	s3,200(sp)
    80004c56:	bfc1                	j	80004c26 <sys_unlink+0x1b0>

0000000080004c58 <sys_open>:

uint64 sys_open(void) {
    80004c58:	7131                	addi	sp,sp,-192
    80004c5a:	fd06                	sd	ra,184(sp)
    80004c5c:	f922                	sd	s0,176(sp)
    80004c5e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c60:	f4c40593          	addi	a1,s0,-180
    80004c64:	4505                	li	a0,1
    80004c66:	ffffd097          	auipc	ra,0xffffd
    80004c6a:	416080e7          	jalr	1046(ra) # 8000207c <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004c6e:	08000613          	li	a2,128
    80004c72:	f5040593          	addi	a1,s0,-176
    80004c76:	4501                	li	a0,0
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	444080e7          	jalr	1092(ra) # 800020bc <argstr>
    80004c80:	87aa                	mv	a5,a0
    80004c82:	557d                	li	a0,-1
    80004c84:	0a07ce63          	bltz	a5,80004d40 <sys_open+0xe8>
    80004c88:	f526                	sd	s1,168(sp)

  begin_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	958080e7          	jalr	-1704(ra) # 800035e2 <begin_op>

  if (omode & O_CREATE) {
    80004c92:	f4c42783          	lw	a5,-180(s0)
    80004c96:	2007f793          	andi	a5,a5,512
    80004c9a:	cfd5                	beqz	a5,80004d56 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c9c:	4681                	li	a3,0
    80004c9e:	4601                	li	a2,0
    80004ca0:	4589                	li	a1,2
    80004ca2:	f5040513          	addi	a0,s0,-176
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	95c080e7          	jalr	-1700(ra) # 80004602 <create>
    80004cae:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004cb0:	cd41                	beqz	a0,80004d48 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004cb2:	04449703          	lh	a4,68(s1)
    80004cb6:	478d                	li	a5,3
    80004cb8:	00f71763          	bne	a4,a5,80004cc6 <sys_open+0x6e>
    80004cbc:	0464d703          	lhu	a4,70(s1)
    80004cc0:	47a5                	li	a5,9
    80004cc2:	0ee7e163          	bltu	a5,a4,80004da4 <sys_open+0x14c>
    80004cc6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	d28080e7          	jalr	-728(ra) # 800039f0 <filealloc>
    80004cd0:	892a                	mv	s2,a0
    80004cd2:	c97d                	beqz	a0,80004dc8 <sys_open+0x170>
    80004cd4:	ed4e                	sd	s3,152(sp)
    80004cd6:	00000097          	auipc	ra,0x0
    80004cda:	8ea080e7          	jalr	-1814(ra) # 800045c0 <fdalloc>
    80004cde:	89aa                	mv	s3,a0
    80004ce0:	0c054e63          	bltz	a0,80004dbc <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004ce4:	04449703          	lh	a4,68(s1)
    80004ce8:	478d                	li	a5,3
    80004cea:	0ef70c63          	beq	a4,a5,80004de2 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cee:	4789                	li	a5,2
    80004cf0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004cf4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004cf8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004cfc:	f4c42783          	lw	a5,-180(s0)
    80004d00:	0017c713          	xori	a4,a5,1
    80004d04:	8b05                	andi	a4,a4,1
    80004d06:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d0a:	0037f713          	andi	a4,a5,3
    80004d0e:	00e03733          	snez	a4,a4
    80004d12:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004d16:	4007f793          	andi	a5,a5,1024
    80004d1a:	c791                	beqz	a5,80004d26 <sys_open+0xce>
    80004d1c:	04449703          	lh	a4,68(s1)
    80004d20:	4789                	li	a5,2
    80004d22:	0cf70763          	beq	a4,a5,80004df0 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004d26:	8526                	mv	a0,s1
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	fb2080e7          	jalr	-78(ra) # 80002cda <iunlock>
  end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	92c080e7          	jalr	-1748(ra) # 8000365c <end_op>

  return fd;
    80004d38:	854e                	mv	a0,s3
    80004d3a:	74aa                	ld	s1,168(sp)
    80004d3c:	790a                	ld	s2,160(sp)
    80004d3e:	69ea                	ld	s3,152(sp)
}
    80004d40:	70ea                	ld	ra,184(sp)
    80004d42:	744a                	ld	s0,176(sp)
    80004d44:	6129                	addi	sp,sp,192
    80004d46:	8082                	ret
      end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	914080e7          	jalr	-1772(ra) # 8000365c <end_op>
      return -1;
    80004d50:	557d                	li	a0,-1
    80004d52:	74aa                	ld	s1,168(sp)
    80004d54:	b7f5                	j	80004d40 <sys_open+0xe8>
    if ((ip = namei(path)) == 0) {
    80004d56:	f5040513          	addi	a0,s0,-176
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	688080e7          	jalr	1672(ra) # 800033e2 <namei>
    80004d62:	84aa                	mv	s1,a0
    80004d64:	c90d                	beqz	a0,80004d96 <sys_open+0x13e>
    ilock(ip);
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	eae080e7          	jalr	-338(ra) # 80002c14 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004d6e:	04449703          	lh	a4,68(s1)
    80004d72:	4785                	li	a5,1
    80004d74:	f2f71fe3          	bne	a4,a5,80004cb2 <sys_open+0x5a>
    80004d78:	f4c42783          	lw	a5,-180(s0)
    80004d7c:	d7a9                	beqz	a5,80004cc6 <sys_open+0x6e>
      iunlockput(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	0fa080e7          	jalr	250(ra) # 80002e7a <iunlockput>
      end_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	8d4080e7          	jalr	-1836(ra) # 8000365c <end_op>
      return -1;
    80004d90:	557d                	li	a0,-1
    80004d92:	74aa                	ld	s1,168(sp)
    80004d94:	b775                	j	80004d40 <sys_open+0xe8>
      end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	8c6080e7          	jalr	-1850(ra) # 8000365c <end_op>
      return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	74aa                	ld	s1,168(sp)
    80004da2:	bf79                	j	80004d40 <sys_open+0xe8>
    iunlockput(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	0d4080e7          	jalr	212(ra) # 80002e7a <iunlockput>
    end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	8ae080e7          	jalr	-1874(ra) # 8000365c <end_op>
    return -1;
    80004db6:	557d                	li	a0,-1
    80004db8:	74aa                	ld	s1,168(sp)
    80004dba:	b759                	j	80004d40 <sys_open+0xe8>
    if (f) fileclose(f);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	cee080e7          	jalr	-786(ra) # 80003aac <fileclose>
    80004dc6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	0b0080e7          	jalr	176(ra) # 80002e7a <iunlockput>
    end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	88a080e7          	jalr	-1910(ra) # 8000365c <end_op>
    return -1;
    80004dda:	557d                	li	a0,-1
    80004ddc:	74aa                	ld	s1,168(sp)
    80004dde:	790a                	ld	s2,160(sp)
    80004de0:	b785                	j	80004d40 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004de2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004de6:	04649783          	lh	a5,70(s1)
    80004dea:	02f91223          	sh	a5,36(s2)
    80004dee:	b729                	j	80004cf8 <sys_open+0xa0>
    itrunc(ip);
    80004df0:	8526                	mv	a0,s1
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	f34080e7          	jalr	-204(ra) # 80002d26 <itrunc>
    80004dfa:	b735                	j	80004d26 <sys_open+0xce>

0000000080004dfc <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004dfc:	7175                	addi	sp,sp,-144
    80004dfe:	e506                	sd	ra,136(sp)
    80004e00:	e122                	sd	s0,128(sp)
    80004e02:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	7de080e7          	jalr	2014(ra) # 800035e2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004e0c:	08000613          	li	a2,128
    80004e10:	f7040593          	addi	a1,s0,-144
    80004e14:	4501                	li	a0,0
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	2a6080e7          	jalr	678(ra) # 800020bc <argstr>
    80004e1e:	02054963          	bltz	a0,80004e50 <sys_mkdir+0x54>
    80004e22:	4681                	li	a3,0
    80004e24:	4601                	li	a2,0
    80004e26:	4585                	li	a1,1
    80004e28:	f7040513          	addi	a0,s0,-144
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	7d6080e7          	jalr	2006(ra) # 80004602 <create>
    80004e34:	cd11                	beqz	a0,80004e50 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	044080e7          	jalr	68(ra) # 80002e7a <iunlockput>
  end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	81e080e7          	jalr	-2018(ra) # 8000365c <end_op>
  return 0;
    80004e46:	4501                	li	a0,0
}
    80004e48:	60aa                	ld	ra,136(sp)
    80004e4a:	640a                	ld	s0,128(sp)
    80004e4c:	6149                	addi	sp,sp,144
    80004e4e:	8082                	ret
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	80c080e7          	jalr	-2036(ra) # 8000365c <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	b7fd                	j	80004e48 <sys_mkdir+0x4c>

0000000080004e5c <sys_mknod>:

uint64 sys_mknod(void) {
    80004e5c:	7135                	addi	sp,sp,-160
    80004e5e:	ed06                	sd	ra,152(sp)
    80004e60:	e922                	sd	s0,144(sp)
    80004e62:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	77e080e7          	jalr	1918(ra) # 800035e2 <begin_op>
  argint(1, &major);
    80004e6c:	f6c40593          	addi	a1,s0,-148
    80004e70:	4505                	li	a0,1
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	20a080e7          	jalr	522(ra) # 8000207c <argint>
  argint(2, &minor);
    80004e7a:	f6840593          	addi	a1,s0,-152
    80004e7e:	4509                	li	a0,2
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	1fc080e7          	jalr	508(ra) # 8000207c <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e88:	08000613          	li	a2,128
    80004e8c:	f7040593          	addi	a1,s0,-144
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	22a080e7          	jalr	554(ra) # 800020bc <argstr>
    80004e9a:	02054b63          	bltz	a0,80004ed0 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004e9e:	f6841683          	lh	a3,-152(s0)
    80004ea2:	f6c41603          	lh	a2,-148(s0)
    80004ea6:	458d                	li	a1,3
    80004ea8:	f7040513          	addi	a0,s0,-144
    80004eac:	fffff097          	auipc	ra,0xfffff
    80004eb0:	756080e7          	jalr	1878(ra) # 80004602 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004eb4:	cd11                	beqz	a0,80004ed0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	fc4080e7          	jalr	-60(ra) # 80002e7a <iunlockput>
  end_op();
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	79e080e7          	jalr	1950(ra) # 8000365c <end_op>
  return 0;
    80004ec6:	4501                	li	a0,0
}
    80004ec8:	60ea                	ld	ra,152(sp)
    80004eca:	644a                	ld	s0,144(sp)
    80004ecc:	610d                	addi	sp,sp,160
    80004ece:	8082                	ret
    end_op();
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	78c080e7          	jalr	1932(ra) # 8000365c <end_op>
    return -1;
    80004ed8:	557d                	li	a0,-1
    80004eda:	b7fd                	j	80004ec8 <sys_mknod+0x6c>

0000000080004edc <sys_chdir>:

uint64 sys_chdir(void) {
    80004edc:	7135                	addi	sp,sp,-160
    80004ede:	ed06                	sd	ra,152(sp)
    80004ee0:	e922                	sd	s0,144(sp)
    80004ee2:	e14a                	sd	s2,128(sp)
    80004ee4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ee6:	ffffc097          	auipc	ra,0xffffc
    80004eea:	060080e7          	jalr	96(ra) # 80000f46 <myproc>
    80004eee:	892a                	mv	s2,a0

  begin_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	6f2080e7          	jalr	1778(ra) # 800035e2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004ef8:	08000613          	li	a2,128
    80004efc:	f6040593          	addi	a1,s0,-160
    80004f00:	4501                	li	a0,0
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	1ba080e7          	jalr	442(ra) # 800020bc <argstr>
    80004f0a:	04054d63          	bltz	a0,80004f64 <sys_chdir+0x88>
    80004f0e:	e526                	sd	s1,136(sp)
    80004f10:	f6040513          	addi	a0,s0,-160
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	4ce080e7          	jalr	1230(ra) # 800033e2 <namei>
    80004f1c:	84aa                	mv	s1,a0
    80004f1e:	c131                	beqz	a0,80004f62 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	cf4080e7          	jalr	-780(ra) # 80002c14 <ilock>
  if (ip->type != T_DIR) {
    80004f28:	04449703          	lh	a4,68(s1)
    80004f2c:	4785                	li	a5,1
    80004f2e:	04f71163          	bne	a4,a5,80004f70 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f32:	8526                	mv	a0,s1
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	da6080e7          	jalr	-602(ra) # 80002cda <iunlock>
  iput(p->cwd);
    80004f3c:	15093503          	ld	a0,336(s2)
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	e92080e7          	jalr	-366(ra) # 80002dd2 <iput>
  end_op();
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	714080e7          	jalr	1812(ra) # 8000365c <end_op>
  p->cwd = ip;
    80004f50:	14993823          	sd	s1,336(s2)
  return 0;
    80004f54:	4501                	li	a0,0
    80004f56:	64aa                	ld	s1,136(sp)
}
    80004f58:	60ea                	ld	ra,152(sp)
    80004f5a:	644a                	ld	s0,144(sp)
    80004f5c:	690a                	ld	s2,128(sp)
    80004f5e:	610d                	addi	sp,sp,160
    80004f60:	8082                	ret
    80004f62:	64aa                	ld	s1,136(sp)
    end_op();
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	6f8080e7          	jalr	1784(ra) # 8000365c <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	b7ed                	j	80004f58 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f70:	8526                	mv	a0,s1
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	f08080e7          	jalr	-248(ra) # 80002e7a <iunlockput>
    end_op();
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	6e2080e7          	jalr	1762(ra) # 8000365c <end_op>
    return -1;
    80004f82:	557d                	li	a0,-1
    80004f84:	64aa                	ld	s1,136(sp)
    80004f86:	bfc9                	j	80004f58 <sys_chdir+0x7c>

0000000080004f88 <sys_exec>:

uint64 sys_exec(void) {
    80004f88:	7121                	addi	sp,sp,-448
    80004f8a:	ff06                	sd	ra,440(sp)
    80004f8c:	fb22                	sd	s0,432(sp)
    80004f8e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f90:	e4840593          	addi	a1,s0,-440
    80004f94:	4505                	li	a0,1
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	106080e7          	jalr	262(ra) # 8000209c <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004f9e:	08000613          	li	a2,128
    80004fa2:	f5040593          	addi	a1,s0,-176
    80004fa6:	4501                	li	a0,0
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	114080e7          	jalr	276(ra) # 800020bc <argstr>
    80004fb0:	87aa                	mv	a5,a0
    return -1;
    80004fb2:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004fb4:	0e07c263          	bltz	a5,80005098 <sys_exec+0x110>
    80004fb8:	f726                	sd	s1,424(sp)
    80004fba:	f34a                	sd	s2,416(sp)
    80004fbc:	ef4e                	sd	s3,408(sp)
    80004fbe:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004fc0:	10000613          	li	a2,256
    80004fc4:	4581                	li	a1,0
    80004fc6:	e5040513          	addi	a0,s0,-432
    80004fca:	ffffb097          	auipc	ra,0xffffb
    80004fce:	1b0080e7          	jalr	432(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004fd2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fd6:	89a6                	mv	s3,s1
    80004fd8:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004fda:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004fde:	00391513          	slli	a0,s2,0x3
    80004fe2:	e4040593          	addi	a1,s0,-448
    80004fe6:	e4843783          	ld	a5,-440(s0)
    80004fea:	953e                	add	a0,a0,a5
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	ff2080e7          	jalr	-14(ra) # 80001fde <fetchaddr>
    80004ff4:	02054a63          	bltz	a0,80005028 <sys_exec+0xa0>
      goto bad;
    }
    if (uarg == 0) {
    80004ff8:	e4043783          	ld	a5,-448(s0)
    80004ffc:	c7b9                	beqz	a5,8000504a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ffe:	ffffb097          	auipc	ra,0xffffb
    80005002:	11c080e7          	jalr	284(ra) # 8000011a <kalloc>
    80005006:	85aa                	mv	a1,a0
    80005008:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    8000500c:	cd11                	beqz	a0,80005028 <sys_exec+0xa0>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    8000500e:	6605                	lui	a2,0x1
    80005010:	e4043503          	ld	a0,-448(s0)
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	01c080e7          	jalr	28(ra) # 80002030 <fetchstr>
    8000501c:	00054663          	bltz	a0,80005028 <sys_exec+0xa0>
    if (i >= NELEM(argv)) {
    80005020:	0905                	addi	s2,s2,1
    80005022:	09a1                	addi	s3,s3,8
    80005024:	fb491de3          	bne	s2,s4,80004fde <sys_exec+0x56>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80005028:	f5040913          	addi	s2,s0,-176
    8000502c:	6088                	ld	a0,0(s1)
    8000502e:	c125                	beqz	a0,8000508e <sys_exec+0x106>
    80005030:	ffffb097          	auipc	ra,0xffffb
    80005034:	fec080e7          	jalr	-20(ra) # 8000001c <kfree>
    80005038:	04a1                	addi	s1,s1,8
    8000503a:	ff2499e3          	bne	s1,s2,8000502c <sys_exec+0xa4>
  return -1;
    8000503e:	557d                	li	a0,-1
    80005040:	74ba                	ld	s1,424(sp)
    80005042:	791a                	ld	s2,416(sp)
    80005044:	69fa                	ld	s3,408(sp)
    80005046:	6a5a                	ld	s4,400(sp)
    80005048:	a881                	j	80005098 <sys_exec+0x110>
      argv[i] = 0;
    8000504a:	0009079b          	sext.w	a5,s2
    8000504e:	078e                	slli	a5,a5,0x3
    80005050:	fd078793          	addi	a5,a5,-48
    80005054:	97a2                	add	a5,a5,s0
    80005056:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000505a:	e5040593          	addi	a1,s0,-432
    8000505e:	f5040513          	addi	a0,s0,-176
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	120080e7          	jalr	288(ra) # 80004182 <exec>
    8000506a:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    8000506c:	f5040993          	addi	s3,s0,-176
    80005070:	6088                	ld	a0,0(s1)
    80005072:	c901                	beqz	a0,80005082 <sys_exec+0xfa>
    80005074:	ffffb097          	auipc	ra,0xffffb
    80005078:	fa8080e7          	jalr	-88(ra) # 8000001c <kfree>
    8000507c:	04a1                	addi	s1,s1,8
    8000507e:	ff3499e3          	bne	s1,s3,80005070 <sys_exec+0xe8>
  return ret;
    80005082:	854a                	mv	a0,s2
    80005084:	74ba                	ld	s1,424(sp)
    80005086:	791a                	ld	s2,416(sp)
    80005088:	69fa                	ld	s3,408(sp)
    8000508a:	6a5a                	ld	s4,400(sp)
    8000508c:	a031                	j	80005098 <sys_exec+0x110>
  return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	74ba                	ld	s1,424(sp)
    80005092:	791a                	ld	s2,416(sp)
    80005094:	69fa                	ld	s3,408(sp)
    80005096:	6a5a                	ld	s4,400(sp)
}
    80005098:	70fa                	ld	ra,440(sp)
    8000509a:	745a                	ld	s0,432(sp)
    8000509c:	6139                	addi	sp,sp,448
    8000509e:	8082                	ret

00000000800050a0 <sys_pipe>:

uint64 sys_pipe(void) {
    800050a0:	7139                	addi	sp,sp,-64
    800050a2:	fc06                	sd	ra,56(sp)
    800050a4:	f822                	sd	s0,48(sp)
    800050a6:	f426                	sd	s1,40(sp)
    800050a8:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050aa:	ffffc097          	auipc	ra,0xffffc
    800050ae:	e9c080e7          	jalr	-356(ra) # 80000f46 <myproc>
    800050b2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050b4:	fd840593          	addi	a1,s0,-40
    800050b8:	4501                	li	a0,0
    800050ba:	ffffd097          	auipc	ra,0xffffd
    800050be:	fe2080e7          	jalr	-30(ra) # 8000209c <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    800050c2:	fc840593          	addi	a1,s0,-56
    800050c6:	fd040513          	addi	a0,s0,-48
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	d50080e7          	jalr	-688(ra) # 80003e1a <pipealloc>
    800050d2:	57fd                	li	a5,-1
    800050d4:	0c054463          	bltz	a0,8000519c <sys_pipe+0xfc>
  fd0 = -1;
    800050d8:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800050dc:	fd043503          	ld	a0,-48(s0)
    800050e0:	fffff097          	auipc	ra,0xfffff
    800050e4:	4e0080e7          	jalr	1248(ra) # 800045c0 <fdalloc>
    800050e8:	fca42223          	sw	a0,-60(s0)
    800050ec:	08054b63          	bltz	a0,80005182 <sys_pipe+0xe2>
    800050f0:	fc843503          	ld	a0,-56(s0)
    800050f4:	fffff097          	auipc	ra,0xfffff
    800050f8:	4cc080e7          	jalr	1228(ra) # 800045c0 <fdalloc>
    800050fc:	fca42023          	sw	a0,-64(s0)
    80005100:	06054863          	bltz	a0,80005170 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005104:	4691                	li	a3,4
    80005106:	fc440613          	addi	a2,s0,-60
    8000510a:	fd843583          	ld	a1,-40(s0)
    8000510e:	68a8                	ld	a0,80(s1)
    80005110:	ffffc097          	auipc	ra,0xffffc
    80005114:	a7c080e7          	jalr	-1412(ra) # 80000b8c <copyout>
    80005118:	02054063          	bltz	a0,80005138 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    8000511c:	4691                	li	a3,4
    8000511e:	fc040613          	addi	a2,s0,-64
    80005122:	fd843583          	ld	a1,-40(s0)
    80005126:	0591                	addi	a1,a1,4
    80005128:	68a8                	ld	a0,80(s1)
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	a62080e7          	jalr	-1438(ra) # 80000b8c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005132:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005134:	06055463          	bgez	a0,8000519c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005138:	fc442783          	lw	a5,-60(s0)
    8000513c:	07e9                	addi	a5,a5,26
    8000513e:	078e                	slli	a5,a5,0x3
    80005140:	97a6                	add	a5,a5,s1
    80005142:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005146:	fc042783          	lw	a5,-64(s0)
    8000514a:	07e9                	addi	a5,a5,26
    8000514c:	078e                	slli	a5,a5,0x3
    8000514e:	94be                	add	s1,s1,a5
    80005150:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005154:	fd043503          	ld	a0,-48(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	954080e7          	jalr	-1708(ra) # 80003aac <fileclose>
    fileclose(wf);
    80005160:	fc843503          	ld	a0,-56(s0)
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	948080e7          	jalr	-1720(ra) # 80003aac <fileclose>
    return -1;
    8000516c:	57fd                	li	a5,-1
    8000516e:	a03d                	j	8000519c <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80005170:	fc442783          	lw	a5,-60(s0)
    80005174:	0007c763          	bltz	a5,80005182 <sys_pipe+0xe2>
    80005178:	07e9                	addi	a5,a5,26
    8000517a:	078e                	slli	a5,a5,0x3
    8000517c:	97a6                	add	a5,a5,s1
    8000517e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	926080e7          	jalr	-1754(ra) # 80003aac <fileclose>
    fileclose(wf);
    8000518e:	fc843503          	ld	a0,-56(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	91a080e7          	jalr	-1766(ra) # 80003aac <fileclose>
    return -1;
    8000519a:	57fd                	li	a5,-1
}
    8000519c:	853e                	mv	a0,a5
    8000519e:	70e2                	ld	ra,56(sp)
    800051a0:	7442                	ld	s0,48(sp)
    800051a2:	74a2                	ld	s1,40(sp)
    800051a4:	6121                	addi	sp,sp,64
    800051a6:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	cbbfc0ef          	jal	80001eaa <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e422                	sd	s0,8(sp)
    8000526e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80005270:	0c0007b7          	lui	a5,0xc000
    80005274:	4705                	li	a4,1
    80005276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005278:	0c0007b7          	lui	a5,0xc000
    8000527c:	c3d8                	sw	a4,4(a5)
    8000527e:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>

  for (int irq = 1; irq < 0x35; irq++) {
    *(uint32*)(PLIC + irq * 4) = 1;
    80005280:	4685                	li	a3,1
  for (int irq = 1; irq < 0x35; irq++) {
    80005282:	0c000737          	lui	a4,0xc000
    80005286:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq * 4) = 1;
    8000528a:	c394                	sw	a3,0(a5)
  for (int irq = 1; irq < 0x35; irq++) {
    8000528c:	0791                	addi	a5,a5,4
    8000528e:	fee79ee3          	bne	a5,a4,8000528a <plicinit+0x20>
  }
}
    80005292:	6422                	ld	s0,8(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <plicinithart>:

void plicinithart(void) {
    80005298:	1141                	addi	sp,sp,-16
    8000529a:	e406                	sd	ra,8(sp)
    8000529c:	e022                	sd	s0,0(sp)
    8000529e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	c7a080e7          	jalr	-902(ra) # 80000f1a <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052a8:	0085171b          	slliw	a4,a0,0x8
    800052ac:	0c0027b7          	lui	a5,0xc002
    800052b0:	97ba                	add	a5,a5,a4
    800052b2:	40200713          	li	a4,1026
    800052b6:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  *(uint32*)(PLIC_SENABLE(hart) + 4) = 0xffffffff;
    800052ba:	577d                	li	a4,-1
    800052bc:	08e7a223          	sw	a4,132(a5)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c0:	00d5151b          	slliw	a0,a0,0xd
    800052c4:	0c2017b7          	lui	a5,0xc201
    800052c8:	97aa                	add	a5,a5,a0
    800052ca:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052ce:	60a2                	ld	ra,8(sp)
    800052d0:	6402                	ld	s0,0(sp)
    800052d2:	0141                	addi	sp,sp,16
    800052d4:	8082                	ret

00000000800052d6 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    800052d6:	1141                	addi	sp,sp,-16
    800052d8:	e406                	sd	ra,8(sp)
    800052da:	e022                	sd	s0,0(sp)
    800052dc:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	c3c080e7          	jalr	-964(ra) # 80000f1a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e6:	00d5151b          	slliw	a0,a0,0xd
    800052ea:	0c2017b7          	lui	a5,0xc201
    800052ee:	97aa                	add	a5,a5,a0
  return irq;
}
    800052f0:	43c8                	lw	a0,4(a5)
    800052f2:	60a2                	ld	ra,8(sp)
    800052f4:	6402                	ld	s0,0(sp)
    800052f6:	0141                	addi	sp,sp,16
    800052f8:	8082                	ret

00000000800052fa <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    800052fa:	1101                	addi	sp,sp,-32
    800052fc:	ec06                	sd	ra,24(sp)
    800052fe:	e822                	sd	s0,16(sp)
    80005300:	e426                	sd	s1,8(sp)
    80005302:	1000                	addi	s0,sp,32
    80005304:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005306:	ffffc097          	auipc	ra,0xffffc
    8000530a:	c14080e7          	jalr	-1004(ra) # 80000f1a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000530e:	00d5151b          	slliw	a0,a0,0xd
    80005312:	0c2017b7          	lui	a5,0xc201
    80005316:	97aa                	add	a5,a5,a0
    80005318:	c3c4                	sw	s1,4(a5)
}
    8000531a:	60e2                	ld	ra,24(sp)
    8000531c:	6442                	ld	s0,16(sp)
    8000531e:	64a2                	ld	s1,8(sp)
    80005320:	6105                	addi	sp,sp,32
    80005322:	8082                	ret

0000000080005324 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80005324:	1141                	addi	sp,sp,-16
    80005326:	e406                	sd	ra,8(sp)
    80005328:	e022                	sd	s0,0(sp)
    8000532a:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    8000532c:	479d                	li	a5,7
    8000532e:	04a7cc63          	blt	a5,a0,80005386 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005332:	00018797          	auipc	a5,0x18
    80005336:	3de78793          	addi	a5,a5,990 # 8001d710 <disk>
    8000533a:	97aa                	add	a5,a5,a0
    8000533c:	0187c783          	lbu	a5,24(a5)
    80005340:	ebb9                	bnez	a5,80005396 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005342:	00451693          	slli	a3,a0,0x4
    80005346:	00018797          	auipc	a5,0x18
    8000534a:	3ca78793          	addi	a5,a5,970 # 8001d710 <disk>
    8000534e:	6398                	ld	a4,0(a5)
    80005350:	9736                	add	a4,a4,a3
    80005352:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005356:	6398                	ld	a4,0(a5)
    80005358:	9736                	add	a4,a4,a3
    8000535a:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000535e:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005362:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005366:	97aa                	add	a5,a5,a0
    80005368:	4705                	li	a4,1
    8000536a:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000536e:	00018517          	auipc	a0,0x18
    80005372:	3ba50513          	addi	a0,a0,954 # 8001d728 <disk+0x18>
    80005376:	ffffc097          	auipc	ra,0xffffc
    8000537a:	2e2080e7          	jalr	738(ra) # 80001658 <wakeup>
}
    8000537e:	60a2                	ld	ra,8(sp)
    80005380:	6402                	ld	s0,0(sp)
    80005382:	0141                	addi	sp,sp,16
    80005384:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    80005386:	00004517          	auipc	a0,0x4
    8000538a:	28250513          	addi	a0,a0,642 # 80009608 <etext+0x608>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	790080e7          	jalr	1936(ra) # 80006b1e <panic>
  if (disk.free[i]) panic("free_desc 2");
    80005396:	00004517          	auipc	a0,0x4
    8000539a:	28250513          	addi	a0,a0,642 # 80009618 <etext+0x618>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	780080e7          	jalr	1920(ra) # 80006b1e <panic>

00000000800053a6 <virtio_disk_init>:
void virtio_disk_init(void) {
    800053a6:	1101                	addi	sp,sp,-32
    800053a8:	ec06                	sd	ra,24(sp)
    800053aa:	e822                	sd	s0,16(sp)
    800053ac:	e426                	sd	s1,8(sp)
    800053ae:	e04a                	sd	s2,0(sp)
    800053b0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053b2:	00004597          	auipc	a1,0x4
    800053b6:	27658593          	addi	a1,a1,630 # 80009628 <etext+0x628>
    800053ba:	00018517          	auipc	a0,0x18
    800053be:	47e50513          	addi	a0,a0,1150 # 8001d838 <disk+0x128>
    800053c2:	00002097          	auipc	ra,0x2
    800053c6:	c46080e7          	jalr	-954(ra) # 80007008 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053ca:	100017b7          	lui	a5,0x10001
    800053ce:	4398                	lw	a4,0(a5)
    800053d0:	2701                	sext.w	a4,a4
    800053d2:	747277b7          	lui	a5,0x74727
    800053d6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053da:	18f71c63          	bne	a4,a5,80005572 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053de:	100017b7          	lui	a5,0x10001
    800053e2:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053e4:	439c                	lw	a5,0(a5)
    800053e6:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e8:	4709                	li	a4,2
    800053ea:	18e79463          	bne	a5,a4,80005572 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ee:	100017b7          	lui	a5,0x10001
    800053f2:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053f4:	439c                	lw	a5,0(a5)
    800053f6:	2781                	sext.w	a5,a5
    800053f8:	16e79d63          	bne	a5,a4,80005572 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800053fc:	100017b7          	lui	a5,0x10001
    80005400:	47d8                	lw	a4,12(a5)
    80005402:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005404:	554d47b7          	lui	a5,0x554d4
    80005408:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000540c:	16f71363          	bne	a4,a5,80005572 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005410:	100017b7          	lui	a5,0x10001
    80005414:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005418:	4705                	li	a4,1
    8000541a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000541c:	470d                	li	a4,3
    8000541e:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005420:	10001737          	lui	a4,0x10001
    80005424:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005426:	c7ffe737          	lui	a4,0xc7ffe
    8000542a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f889df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000542e:	8ef9                	and	a3,a3,a4
    80005430:	10001737          	lui	a4,0x10001
    80005434:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	472d                	li	a4,11
    80005438:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543a:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000543e:	439c                	lw	a5,0(a5)
    80005440:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005444:	8ba1                	andi	a5,a5,8
    80005446:	12078e63          	beqz	a5,80005582 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005452:	100017b7          	lui	a5,0x10001
    80005456:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    8000545a:	439c                	lw	a5,0(a5)
    8000545c:	2781                	sext.w	a5,a5
    8000545e:	12079a63          	bnez	a5,80005592 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005462:	100017b7          	lui	a5,0x10001
    80005466:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000546a:	439c                	lw	a5,0(a5)
    8000546c:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    8000546e:	12078a63          	beqz	a5,800055a2 <virtio_disk_init+0x1fc>
  if (max < NUM) panic("virtio disk max queue too short");
    80005472:	471d                	li	a4,7
    80005474:	12f77f63          	bgeu	a4,a5,800055b2 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    80005478:	ffffb097          	auipc	ra,0xffffb
    8000547c:	ca2080e7          	jalr	-862(ra) # 8000011a <kalloc>
    80005480:	00018497          	auipc	s1,0x18
    80005484:	29048493          	addi	s1,s1,656 # 8001d710 <disk>
    80005488:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    8000548a:	ffffb097          	auipc	ra,0xffffb
    8000548e:	c90080e7          	jalr	-880(ra) # 8000011a <kalloc>
    80005492:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005494:	ffffb097          	auipc	ra,0xffffb
    80005498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000549c:	87aa                	mv	a5,a0
    8000549e:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800054a0:	6088                	ld	a0,0(s1)
    800054a2:	12050063          	beqz	a0,800055c2 <virtio_disk_init+0x21c>
    800054a6:	00018717          	auipc	a4,0x18
    800054aa:	27273703          	ld	a4,626(a4) # 8001d718 <disk+0x8>
    800054ae:	10070a63          	beqz	a4,800055c2 <virtio_disk_init+0x21c>
    800054b2:	10078863          	beqz	a5,800055c2 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800054b6:	6605                	lui	a2,0x1
    800054b8:	4581                	li	a1,0
    800054ba:	ffffb097          	auipc	ra,0xffffb
    800054be:	cc0080e7          	jalr	-832(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800054c2:	00018497          	auipc	s1,0x18
    800054c6:	24e48493          	addi	s1,s1,590 # 8001d710 <disk>
    800054ca:	6605                	lui	a2,0x1
    800054cc:	4581                	li	a1,0
    800054ce:	6488                	ld	a0,8(s1)
    800054d0:	ffffb097          	auipc	ra,0xffffb
    800054d4:	caa080e7          	jalr	-854(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800054d8:	6605                	lui	a2,0x1
    800054da:	4581                	li	a1,0
    800054dc:	6888                	ld	a0,16(s1)
    800054de:	ffffb097          	auipc	ra,0xffffb
    800054e2:	c9c080e7          	jalr	-868(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	4721                	li	a4,8
    800054ec:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054ee:	4098                	lw	a4,0(s1)
    800054f0:	100017b7          	lui	a5,0x10001
    800054f4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054f8:	40d8                	lw	a4,4(s1)
    800054fa:	100017b7          	lui	a5,0x10001
    800054fe:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005502:	649c                	ld	a5,8(s1)
    80005504:	0007869b          	sext.w	a3,a5
    80005508:	10001737          	lui	a4,0x10001
    8000550c:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005510:	9781                	srai	a5,a5,0x20
    80005512:	10001737          	lui	a4,0x10001
    80005516:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000551a:	689c                	ld	a5,16(s1)
    8000551c:	0007869b          	sext.w	a3,a5
    80005520:	10001737          	lui	a4,0x10001
    80005524:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005528:	9781                	srai	a5,a5,0x20
    8000552a:	10001737          	lui	a4,0x10001
    8000552e:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005532:	10001737          	lui	a4,0x10001
    80005536:	4785                	li	a5,1
    80005538:	c37c                	sw	a5,68(a4)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    8000553a:	00f48c23          	sb	a5,24(s1)
    8000553e:	00f48ca3          	sb	a5,25(s1)
    80005542:	00f48d23          	sb	a5,26(s1)
    80005546:	00f48da3          	sb	a5,27(s1)
    8000554a:	00f48e23          	sb	a5,28(s1)
    8000554e:	00f48ea3          	sb	a5,29(s1)
    80005552:	00f48f23          	sb	a5,30(s1)
    80005556:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000555a:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555e:	100017b7          	lui	a5,0x10001
    80005562:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005566:	60e2                	ld	ra,24(sp)
    80005568:	6442                	ld	s0,16(sp)
    8000556a:	64a2                	ld	s1,8(sp)
    8000556c:	6902                	ld	s2,0(sp)
    8000556e:	6105                	addi	sp,sp,32
    80005570:	8082                	ret
    panic("could not find virtio disk");
    80005572:	00004517          	auipc	a0,0x4
    80005576:	0c650513          	addi	a0,a0,198 # 80009638 <etext+0x638>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	5a4080e7          	jalr	1444(ra) # 80006b1e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005582:	00004517          	auipc	a0,0x4
    80005586:	0d650513          	addi	a0,a0,214 # 80009658 <etext+0x658>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	594080e7          	jalr	1428(ra) # 80006b1e <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005592:	00004517          	auipc	a0,0x4
    80005596:	0e650513          	addi	a0,a0,230 # 80009678 <etext+0x678>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	584080e7          	jalr	1412(ra) # 80006b1e <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    800055a2:	00004517          	auipc	a0,0x4
    800055a6:	0f650513          	addi	a0,a0,246 # 80009698 <etext+0x698>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	574080e7          	jalr	1396(ra) # 80006b1e <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    800055b2:	00004517          	auipc	a0,0x4
    800055b6:	10650513          	addi	a0,a0,262 # 800096b8 <etext+0x6b8>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	564080e7          	jalr	1380(ra) # 80006b1e <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800055c2:	00004517          	auipc	a0,0x4
    800055c6:	11650513          	addi	a0,a0,278 # 800096d8 <etext+0x6d8>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	554080e7          	jalr	1364(ra) # 80006b1e <panic>

00000000800055d2 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800055d2:	7159                	addi	sp,sp,-112
    800055d4:	f486                	sd	ra,104(sp)
    800055d6:	f0a2                	sd	s0,96(sp)
    800055d8:	eca6                	sd	s1,88(sp)
    800055da:	e8ca                	sd	s2,80(sp)
    800055dc:	e4ce                	sd	s3,72(sp)
    800055de:	e0d2                	sd	s4,64(sp)
    800055e0:	fc56                	sd	s5,56(sp)
    800055e2:	f85a                	sd	s6,48(sp)
    800055e4:	f45e                	sd	s7,40(sp)
    800055e6:	f062                	sd	s8,32(sp)
    800055e8:	ec66                	sd	s9,24(sp)
    800055ea:	1880                	addi	s0,sp,112
    800055ec:	8a2a                	mv	s4,a0
    800055ee:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055f0:	00c52c83          	lw	s9,12(a0)
    800055f4:	001c9c9b          	slliw	s9,s9,0x1
    800055f8:	1c82                	slli	s9,s9,0x20
    800055fa:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055fe:	00018517          	auipc	a0,0x18
    80005602:	23a50513          	addi	a0,a0,570 # 8001d838 <disk+0x128>
    80005606:	00002097          	auipc	ra,0x2
    8000560a:	a92080e7          	jalr	-1390(ra) # 80007098 <acquire>
  for (int i = 0; i < 3; i++) {
    8000560e:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005610:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005612:	00018b17          	auipc	s6,0x18
    80005616:	0feb0b13          	addi	s6,s6,254 # 8001d710 <disk>
  for (int i = 0; i < 3; i++) {
    8000561a:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000561c:	00018c17          	auipc	s8,0x18
    80005620:	21cc0c13          	addi	s8,s8,540 # 8001d838 <disk+0x128>
    80005624:	a0ad                	j	8000568e <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005626:	00fb0733          	add	a4,s6,a5
    8000562a:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    8000562e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005630:	0207c563          	bltz	a5,8000565a <virtio_disk_rw+0x88>
  for (int i = 0; i < 3; i++) {
    80005634:	2905                	addiw	s2,s2,1
    80005636:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005638:	05590f63          	beq	s2,s5,80005696 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    8000563c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    8000563e:	00018717          	auipc	a4,0x18
    80005642:	0d270713          	addi	a4,a4,210 # 8001d710 <disk>
    80005646:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    80005648:	01874683          	lbu	a3,24(a4)
    8000564c:	fee9                	bnez	a3,80005626 <virtio_disk_rw+0x54>
  for (int i = 0; i < NUM; i++) {
    8000564e:	2785                	addiw	a5,a5,1
    80005650:	0705                	addi	a4,a4,1
    80005652:	fe979be3          	bne	a5,s1,80005648 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005656:	57fd                	li	a5,-1
    80005658:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8000565a:	03205163          	blez	s2,8000567c <virtio_disk_rw+0xaa>
    8000565e:	f9042503          	lw	a0,-112(s0)
    80005662:	00000097          	auipc	ra,0x0
    80005666:	cc2080e7          	jalr	-830(ra) # 80005324 <free_desc>
    8000566a:	4785                	li	a5,1
    8000566c:	0127d863          	bge	a5,s2,8000567c <virtio_disk_rw+0xaa>
    80005670:	f9442503          	lw	a0,-108(s0)
    80005674:	00000097          	auipc	ra,0x0
    80005678:	cb0080e7          	jalr	-848(ra) # 80005324 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000567c:	85e2                	mv	a1,s8
    8000567e:	00018517          	auipc	a0,0x18
    80005682:	0aa50513          	addi	a0,a0,170 # 8001d728 <disk+0x18>
    80005686:	ffffc097          	auipc	ra,0xffffc
    8000568a:	f6e080e7          	jalr	-146(ra) # 800015f4 <sleep>
  for (int i = 0; i < 3; i++) {
    8000568e:	f9040613          	addi	a2,s0,-112
    80005692:	894e                	mv	s2,s3
    80005694:	b765                	j	8000563c <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005696:	f9042503          	lw	a0,-112(s0)
    8000569a:	00451693          	slli	a3,a0,0x4

  if (write)
    8000569e:	00018797          	auipc	a5,0x18
    800056a2:	07278793          	addi	a5,a5,114 # 8001d710 <disk>
    800056a6:	00a50713          	addi	a4,a0,10
    800056aa:	0712                	slli	a4,a4,0x4
    800056ac:	973e                	add	a4,a4,a5
    800056ae:	01703633          	snez	a2,s7
    800056b2:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    800056b4:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056b8:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800056bc:	6398                	ld	a4,0(a5)
    800056be:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c0:	0a868613          	addi	a2,a3,168
    800056c4:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    800056c6:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056c8:	6390                	ld	a2,0(a5)
    800056ca:	00d605b3          	add	a1,a2,a3
    800056ce:	4741                	li	a4,16
    800056d0:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056d2:	4805                	li	a6,1
    800056d4:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800056d8:	f9442703          	lw	a4,-108(s0)
    800056dc:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800056e0:	0712                	slli	a4,a4,0x4
    800056e2:	963a                	add	a2,a2,a4
    800056e4:	058a0593          	addi	a1,s4,88
    800056e8:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056ea:	0007b883          	ld	a7,0(a5)
    800056ee:	9746                	add	a4,a4,a7
    800056f0:	40000613          	li	a2,1024
    800056f4:	c710                	sw	a2,8(a4)
  if (write)
    800056f6:	001bb613          	seqz	a2,s7
    800056fa:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056fe:	00166613          	ori	a2,a2,1
    80005702:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005706:	f9842583          	lw	a1,-104(s0)
    8000570a:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    8000570e:	00250613          	addi	a2,a0,2
    80005712:	0612                	slli	a2,a2,0x4
    80005714:	963e                	add	a2,a2,a5
    80005716:	577d                	li	a4,-1
    80005718:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000571c:	0592                	slli	a1,a1,0x4
    8000571e:	98ae                	add	a7,a7,a1
    80005720:	03068713          	addi	a4,a3,48
    80005724:	973e                	add	a4,a4,a5
    80005726:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000572a:	6398                	ld	a4,0(a5)
    8000572c:	972e                	add	a4,a4,a1
    8000572e:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005732:	4689                	li	a3,2
    80005734:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005738:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000573c:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005740:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005744:	6794                	ld	a3,8(a5)
    80005746:	0026d703          	lhu	a4,2(a3)
    8000574a:	8b1d                	andi	a4,a4,7
    8000574c:	0706                	slli	a4,a4,0x1
    8000574e:	96ba                	add	a3,a3,a4
    80005750:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005754:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    80005758:	6798                	ld	a4,8(a5)
    8000575a:	00275783          	lhu	a5,2(a4)
    8000575e:	2785                	addiw	a5,a5,1
    80005760:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005764:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80005768:	100017b7          	lui	a5,0x10001
    8000576c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005770:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005774:	00018917          	auipc	s2,0x18
    80005778:	0c490913          	addi	s2,s2,196 # 8001d838 <disk+0x128>
  while (b->disk == 1) {
    8000577c:	4485                	li	s1,1
    8000577e:	01079c63          	bne	a5,a6,80005796 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005782:	85ca                	mv	a1,s2
    80005784:	8552                	mv	a0,s4
    80005786:	ffffc097          	auipc	ra,0xffffc
    8000578a:	e6e080e7          	jalr	-402(ra) # 800015f4 <sleep>
  while (b->disk == 1) {
    8000578e:	004a2783          	lw	a5,4(s4)
    80005792:	fe9788e3          	beq	a5,s1,80005782 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005796:	f9042903          	lw	s2,-112(s0)
    8000579a:	00290713          	addi	a4,s2,2
    8000579e:	0712                	slli	a4,a4,0x4
    800057a0:	00018797          	auipc	a5,0x18
    800057a4:	f7078793          	addi	a5,a5,-144 # 8001d710 <disk>
    800057a8:	97ba                	add	a5,a5,a4
    800057aa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ae:	00018997          	auipc	s3,0x18
    800057b2:	f6298993          	addi	s3,s3,-158 # 8001d710 <disk>
    800057b6:	00491713          	slli	a4,s2,0x4
    800057ba:	0009b783          	ld	a5,0(s3)
    800057be:	97ba                	add	a5,a5,a4
    800057c0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057c4:	854a                	mv	a0,s2
    800057c6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057ca:	00000097          	auipc	ra,0x0
    800057ce:	b5a080e7          	jalr	-1190(ra) # 80005324 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800057d2:	8885                	andi	s1,s1,1
    800057d4:	f0ed                	bnez	s1,800057b6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057d6:	00018517          	auipc	a0,0x18
    800057da:	06250513          	addi	a0,a0,98 # 8001d838 <disk+0x128>
    800057de:	00002097          	auipc	ra,0x2
    800057e2:	96e080e7          	jalr	-1682(ra) # 8000714c <release>
}
    800057e6:	70a6                	ld	ra,104(sp)
    800057e8:	7406                	ld	s0,96(sp)
    800057ea:	64e6                	ld	s1,88(sp)
    800057ec:	6946                	ld	s2,80(sp)
    800057ee:	69a6                	ld	s3,72(sp)
    800057f0:	6a06                	ld	s4,64(sp)
    800057f2:	7ae2                	ld	s5,56(sp)
    800057f4:	7b42                	ld	s6,48(sp)
    800057f6:	7ba2                	ld	s7,40(sp)
    800057f8:	7c02                	ld	s8,32(sp)
    800057fa:	6ce2                	ld	s9,24(sp)
    800057fc:	6165                	addi	sp,sp,112
    800057fe:	8082                	ret

0000000080005800 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005800:	1101                	addi	sp,sp,-32
    80005802:	ec06                	sd	ra,24(sp)
    80005804:	e822                	sd	s0,16(sp)
    80005806:	e426                	sd	s1,8(sp)
    80005808:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000580a:	00018497          	auipc	s1,0x18
    8000580e:	f0648493          	addi	s1,s1,-250 # 8001d710 <disk>
    80005812:	00018517          	auipc	a0,0x18
    80005816:	02650513          	addi	a0,a0,38 # 8001d838 <disk+0x128>
    8000581a:	00002097          	auipc	ra,0x2
    8000581e:	87e080e7          	jalr	-1922(ra) # 80007098 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005822:	100017b7          	lui	a5,0x10001
    80005826:	53b8                	lw	a4,96(a5)
    80005828:	8b0d                	andi	a4,a4,3
    8000582a:	100017b7          	lui	a5,0x10001
    8000582e:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005830:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005834:	689c                	ld	a5,16(s1)
    80005836:	0204d703          	lhu	a4,32(s1)
    8000583a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000583e:	04f70863          	beq	a4,a5,8000588e <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005842:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005846:	6898                	ld	a4,16(s1)
    80005848:	0204d783          	lhu	a5,32(s1)
    8000584c:	8b9d                	andi	a5,a5,7
    8000584e:	078e                	slli	a5,a5,0x3
    80005850:	97ba                	add	a5,a5,a4
    80005852:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005854:	00278713          	addi	a4,a5,2
    80005858:	0712                	slli	a4,a4,0x4
    8000585a:	9726                	add	a4,a4,s1
    8000585c:	01074703          	lbu	a4,16(a4)
    80005860:	e721                	bnez	a4,800058a8 <virtio_disk_intr+0xa8>

    struct buf *b = disk.info[id].b;
    80005862:	0789                	addi	a5,a5,2
    80005864:	0792                	slli	a5,a5,0x4
    80005866:	97a6                	add	a5,a5,s1
    80005868:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000586a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000586e:	ffffc097          	auipc	ra,0xffffc
    80005872:	dea080e7          	jalr	-534(ra) # 80001658 <wakeup>

    disk.used_idx += 1;
    80005876:	0204d783          	lhu	a5,32(s1)
    8000587a:	2785                	addiw	a5,a5,1
    8000587c:	17c2                	slli	a5,a5,0x30
    8000587e:	93c1                	srli	a5,a5,0x30
    80005880:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005884:	6898                	ld	a4,16(s1)
    80005886:	00275703          	lhu	a4,2(a4)
    8000588a:	faf71ce3          	bne	a4,a5,80005842 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    8000588e:	00018517          	auipc	a0,0x18
    80005892:	faa50513          	addi	a0,a0,-86 # 8001d838 <disk+0x128>
    80005896:	00002097          	auipc	ra,0x2
    8000589a:	8b6080e7          	jalr	-1866(ra) # 8000714c <release>
}
    8000589e:	60e2                	ld	ra,24(sp)
    800058a0:	6442                	ld	s0,16(sp)
    800058a2:	64a2                	ld	s1,8(sp)
    800058a4:	6105                	addi	sp,sp,32
    800058a6:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800058a8:	00004517          	auipc	a0,0x4
    800058ac:	e4850513          	addi	a0,a0,-440 # 800096f0 <etext+0x6f0>
    800058b0:	00001097          	auipc	ra,0x1
    800058b4:	26e080e7          	jalr	622(ra) # 80006b1e <panic>

00000000800058b8 <e1000_init>:
void net_rx(char *buf, int len);

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void e1000_init(uint32 *xregs) {
    800058b8:	1101                	addi	sp,sp,-32
    800058ba:	ec06                	sd	ra,24(sp)
    800058bc:	e822                	sd	s0,16(sp)
    800058be:	e426                	sd	s1,8(sp)
    800058c0:	e04a                	sd	s2,0(sp)
    800058c2:	1000                	addi	s0,sp,32
    800058c4:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_tx_lock, "e1000_tx");
    800058c6:	00004597          	auipc	a1,0x4
    800058ca:	e4258593          	addi	a1,a1,-446 # 80009708 <etext+0x708>
    800058ce:	00018517          	auipc	a0,0x18
    800058d2:	f8250513          	addi	a0,a0,-126 # 8001d850 <e1000_tx_lock>
    800058d6:	00001097          	auipc	ra,0x1
    800058da:	732080e7          	jalr	1842(ra) # 80007008 <initlock>
  initlock(&e1000_rx_lock, "e1000_rx");
    800058de:	00004597          	auipc	a1,0x4
    800058e2:	e3a58593          	addi	a1,a1,-454 # 80009718 <etext+0x718>
    800058e6:	00018517          	auipc	a0,0x18
    800058ea:	f8250513          	addi	a0,a0,-126 # 8001d868 <e1000_rx_lock>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	71a080e7          	jalr	1818(ra) # 80007008 <initlock>

  regs = xregs;
    800058f6:	00007797          	auipc	a5,0x7
    800058fa:	ce97bd23          	sd	s1,-774(a5) # 8000c5f0 <regs>

  // Reset the device
  regs[E1000_IMS] = 0;  // disable interrupts
    800058fe:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80005902:	409c                	lw	a5,0(s1)
    80005904:	04000737          	lui	a4,0x4000
    80005908:	8fd9                	or	a5,a5,a4
    8000590a:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0;  // redisable interrupts
    8000590c:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80005910:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80005914:	10000613          	li	a2,256
    80005918:	4581                	li	a1,0
    8000591a:	00018517          	auipc	a0,0x18
    8000591e:	f6650513          	addi	a0,a0,-154 # 8001d880 <tx_ring>
    80005922:	ffffb097          	auipc	ra,0xffffb
    80005926:	858080e7          	jalr	-1960(ra) # 8000017a <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    8000592a:	00018797          	auipc	a5,0x18
    8000592e:	f6278793          	addi	a5,a5,-158 # 8001d88c <tx_ring+0xc>
    80005932:	00018697          	auipc	a3,0x18
    80005936:	05a68693          	addi	a3,a3,90 # 8001d98c <rx_ring+0xc>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    8000593a:	4705                	li	a4,1
    8000593c:	00e78023          	sb	a4,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80005940:	07c1                	addi	a5,a5,16
    80005942:	fed79de3          	bne	a5,a3,8000593c <e1000_init+0x84>
    tx_bufs[i] = 0;
  }
  regs[E1000_TDBAL] = (uint64)tx_ring;
    80005946:	00018717          	auipc	a4,0x18
    8000594a:	f3a70713          	addi	a4,a4,-198 # 8001d880 <tx_ring>
    8000594e:	00007797          	auipc	a5,0x7
    80005952:	ca27b783          	ld	a5,-862(a5) # 8000c5f0 <regs>
    80005956:	6691                	lui	a3,0x4
    80005958:	97b6                	add	a5,a5,a3
    8000595a:	80e7a023          	sw	a4,-2048(a5)
  if (sizeof(tx_ring) % 128 != 0) panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    8000595e:	10000713          	li	a4,256
    80005962:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80005966:	8007ac23          	sw	zero,-2024(a5)
    8000596a:	8007a823          	sw	zero,-2032(a5)

  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    8000596e:	00018497          	auipc	s1,0x18
    80005972:	01248493          	addi	s1,s1,18 # 8001d980 <rx_ring>
    80005976:	10000613          	li	a2,256
    8000597a:	4581                	li	a1,0
    8000597c:	8526                	mv	a0,s1
    8000597e:	ffffa097          	auipc	ra,0xffffa
    80005982:	7fc080e7          	jalr	2044(ra) # 8000017a <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005986:	00018917          	auipc	s2,0x18
    8000598a:	0fa90913          	addi	s2,s2,250 # 8001da80 <netlock>
    rx_bufs[i] = kalloc();
    8000598e:	ffffa097          	auipc	ra,0xffffa
    80005992:	78c080e7          	jalr	1932(ra) # 8000011a <kalloc>
    if (!rx_bufs[i]) panic("e1000");
    80005996:	c54d                	beqz	a0,80005a40 <e1000_init+0x188>
    rx_ring[i].addr = (uint64)rx_bufs[i];
    80005998:	e088                	sd	a0,0(s1)
  for (i = 0; i < RX_RING_SIZE; i++) {
    8000599a:	04c1                	addi	s1,s1,16
    8000599c:	ff2499e3          	bne	s1,s2,8000598e <e1000_init+0xd6>
  }
  regs[E1000_RDBAL] = (uint64)rx_ring;
    800059a0:	00007697          	auipc	a3,0x7
    800059a4:	c506b683          	ld	a3,-944(a3) # 8000c5f0 <regs>
    800059a8:	00018717          	auipc	a4,0x18
    800059ac:	fd870713          	addi	a4,a4,-40 # 8001d980 <rx_ring>
    800059b0:	678d                	lui	a5,0x3
    800059b2:	97b6                	add	a5,a5,a3
    800059b4:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if (sizeof(rx_ring) % 128 != 0) panic("e1000");
  regs[E1000_RDH] = 0;
    800059b8:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    800059bc:	473d                	li	a4,15
    800059be:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    800059c2:	10000713          	li	a4,256
    800059c6:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    800059ca:	6795                	lui	a5,0x5
    800059cc:	97b6                	add	a5,a5,a3
    800059ce:	12005737          	lui	a4,0x12005
    800059d2:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    800059d6:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA + 1] = 0x5634 | (1 << 31);
    800059da:	80005737          	lui	a4,0x80005
    800059de:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefff8f8b4>
    800059e2:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096 / 32; i++) regs[E1000_MTA + i] = 0;
    800059e6:	6795                	lui	a5,0x5
    800059e8:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    800059ec:	97b6                	add	a5,a5,a3
    800059ee:	6715                	lui	a4,0x5
    800059f0:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    800059f4:	9736                	add	a4,a4,a3
    800059f6:	0007a023          	sw	zero,0(a5)
    800059fa:	0791                	addi	a5,a5,4
    800059fc:	fee79de3          	bne	a5,a4,800059f6 <e1000_init+0x13e>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |                  // enable
    80005a00:	000407b7          	lui	a5,0x40
    80005a04:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80005a08:	40f6a023          	sw	a5,1024(a3)
                     E1000_TCTL_PSP |                 // pad short packets
                     (0x10 << E1000_TCTL_CT_SHIFT) |  // collision stuff
                     (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8 << 10) | (6 << 20);  // inter-pkt gap
    80005a0c:	006027b7          	lui	a5,0x602
    80005a10:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    80005a12:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN |       // enable receiver
    80005a16:	040087b7          	lui	a5,0x4008
    80005a1a:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80005a1c:	10f6a023          	sw	a5,256(a3)
                     E1000_RCTL_BAM |      // enable broadcast
                     E1000_RCTL_SZ_2048 |  // 2048-byte rx buffers
                     E1000_RCTL_SECRC;     // strip CRC

  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0;  // interrupt after every received packet (no timer)
    80005a20:	678d                	lui	a5,0x3
    80005a22:	97b6                	add	a5,a5,a3
    80005a24:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0;  // interrupt after every packet (no timer)
    80005a28:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7);  // RXDW -- Receiver Descriptor Write Back
    80005a2c:	08000793          	li	a5,128
    80005a30:	0cf6a823          	sw	a5,208(a3)
}
    80005a34:	60e2                	ld	ra,24(sp)
    80005a36:	6442                	ld	s0,16(sp)
    80005a38:	64a2                	ld	s1,8(sp)
    80005a3a:	6902                	ld	s2,0(sp)
    80005a3c:	6105                	addi	sp,sp,32
    80005a3e:	8082                	ret
    if (!rx_bufs[i]) panic("e1000");
    80005a40:	00004517          	auipc	a0,0x4
    80005a44:	ce850513          	addi	a0,a0,-792 # 80009728 <etext+0x728>
    80005a48:	00001097          	auipc	ra,0x1
    80005a4c:	0d6080e7          	jalr	214(ra) # 80006b1e <panic>

0000000080005a50 <e1000_transmit>:

int e1000_transmit(char *buf, int len) {
    80005a50:	7179                	addi	sp,sp,-48
    80005a52:	f406                	sd	ra,40(sp)
    80005a54:	f022                	sd	s0,32(sp)
    80005a56:	ec26                	sd	s1,24(sp)
    80005a58:	e84a                	sd	s2,16(sp)
    80005a5a:	e44e                	sd	s3,8(sp)
    80005a5c:	e052                	sd	s4,0(sp)
    80005a5e:	1800                	addi	s0,sp,48
    80005a60:	8a2a                	mv	s4,a0
    80005a62:	89ae                	mv	s3,a1
  acquire(&e1000_tx_lock);
    80005a64:	00018917          	auipc	s2,0x18
    80005a68:	dec90913          	addi	s2,s2,-532 # 8001d850 <e1000_tx_lock>
    80005a6c:	854a                	mv	a0,s2
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	62a080e7          	jalr	1578(ra) # 80007098 <acquire>

  int ind = regs[E1000_TDT];
    80005a76:	00007797          	auipc	a5,0x7
    80005a7a:	b7a7b783          	ld	a5,-1158(a5) # 8000c5f0 <regs>
    80005a7e:	6711                	lui	a4,0x4
    80005a80:	97ba                	add	a5,a5,a4
    80005a82:	8187a483          	lw	s1,-2024(a5)

  if (!(tx_ring[ind].status & E1000_TXD_STAT_DD)) {
    80005a86:	00449793          	slli	a5,s1,0x4
    80005a8a:	993e                	add	s2,s2,a5
    80005a8c:	03c94783          	lbu	a5,60(s2)
    80005a90:	8b85                	andi	a5,a5,1
    80005a92:	cba5                	beqz	a5,80005b02 <e1000_transmit+0xb2>
    release(&e1000_tx_lock);
    return -1;
  } else if (tx_ring[ind].addr) {
    80005a94:	00449713          	slli	a4,s1,0x4
    80005a98:	00018797          	auipc	a5,0x18
    80005a9c:	db878793          	addi	a5,a5,-584 # 8001d850 <e1000_tx_lock>
    80005aa0:	97ba                	add	a5,a5,a4
    80005aa2:	7b88                	ld	a0,48(a5)
    80005aa4:	e92d                	bnez	a0,80005b16 <e1000_transmit+0xc6>
    kfree((void *)tx_ring[ind].addr);
  }

  tx_ring[ind].addr = (uint64)buf;
    80005aa6:	00018517          	auipc	a0,0x18
    80005aaa:	daa50513          	addi	a0,a0,-598 # 8001d850 <e1000_tx_lock>
    80005aae:	00449793          	slli	a5,s1,0x4
    80005ab2:	97aa                	add	a5,a5,a0
    80005ab4:	0347b823          	sd	s4,48(a5)
  tx_ring[ind].length = (uint16)len;
    80005ab8:	03379c23          	sh	s3,56(a5)
  tx_bufs[ind] = buf;

  tx_ring[ind].cmd |= E1000_TXD_CMD_EOP;
  tx_ring[ind].cmd |= E1000_TXD_CMD_RS;
    80005abc:	03b7c703          	lbu	a4,59(a5)
    80005ac0:	00976713          	ori	a4,a4,9
    80005ac4:	02e78da3          	sb	a4,59(a5)

  regs[E1000_TDT] = (ind + 1) % TX_RING_SIZE;
    80005ac8:	2485                	addiw	s1,s1,1
    80005aca:	41f4d79b          	sraiw	a5,s1,0x1f
    80005ace:	01c7d79b          	srliw	a5,a5,0x1c
    80005ad2:	9cbd                	addw	s1,s1,a5
    80005ad4:	88bd                	andi	s1,s1,15
    80005ad6:	9c9d                	subw	s1,s1,a5
    80005ad8:	00007797          	auipc	a5,0x7
    80005adc:	b187b783          	ld	a5,-1256(a5) # 8000c5f0 <regs>
    80005ae0:	6711                	lui	a4,0x4
    80005ae2:	97ba                	add	a5,a5,a4
    80005ae4:	8097ac23          	sw	s1,-2024(a5)

  release(&e1000_tx_lock);
    80005ae8:	00001097          	auipc	ra,0x1
    80005aec:	664080e7          	jalr	1636(ra) # 8000714c <release>

  return 0;
    80005af0:	4501                	li	a0,0
}
    80005af2:	70a2                	ld	ra,40(sp)
    80005af4:	7402                	ld	s0,32(sp)
    80005af6:	64e2                	ld	s1,24(sp)
    80005af8:	6942                	ld	s2,16(sp)
    80005afa:	69a2                	ld	s3,8(sp)
    80005afc:	6a02                	ld	s4,0(sp)
    80005afe:	6145                	addi	sp,sp,48
    80005b00:	8082                	ret
    release(&e1000_tx_lock);
    80005b02:	00018517          	auipc	a0,0x18
    80005b06:	d4e50513          	addi	a0,a0,-690 # 8001d850 <e1000_tx_lock>
    80005b0a:	00001097          	auipc	ra,0x1
    80005b0e:	642080e7          	jalr	1602(ra) # 8000714c <release>
    return -1;
    80005b12:	557d                	li	a0,-1
    80005b14:	bff9                	j	80005af2 <e1000_transmit+0xa2>
    kfree((void *)tx_ring[ind].addr);
    80005b16:	ffffa097          	auipc	ra,0xffffa
    80005b1a:	506080e7          	jalr	1286(ra) # 8000001c <kfree>
    80005b1e:	b761                	j	80005aa6 <e1000_transmit+0x56>

0000000080005b20 <e1000_intr>:
  }

  release(&e1000_rx_lock);
}

void e1000_intr(void) {
    80005b20:	7139                	addi	sp,sp,-64
    80005b22:	fc06                	sd	ra,56(sp)
    80005b24:	f822                	sd	s0,48(sp)
    80005b26:	f426                	sd	s1,40(sp)
    80005b28:	e456                	sd	s5,8(sp)
    80005b2a:	0080                	addi	s0,sp,64
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005b2c:	00007497          	auipc	s1,0x7
    80005b30:	ac448493          	addi	s1,s1,-1340 # 8000c5f0 <regs>
    80005b34:	609c                	ld	a5,0(s1)
    80005b36:	577d                	li	a4,-1
    80005b38:	0ce7a023          	sw	a4,192(a5)
  acquire(&e1000_rx_lock);
    80005b3c:	00018517          	auipc	a0,0x18
    80005b40:	d2c50513          	addi	a0,a0,-724 # 8001d868 <e1000_rx_lock>
    80005b44:	00001097          	auipc	ra,0x1
    80005b48:	554080e7          	jalr	1364(ra) # 80007098 <acquire>
    int ind = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005b4c:	609c                	ld	a5,0(s1)
    80005b4e:	670d                	lui	a4,0x3
    80005b50:	97ba                	add	a5,a5,a4
    80005b52:	8187a483          	lw	s1,-2024(a5)
    80005b56:	2485                	addiw	s1,s1,1
    80005b58:	00f4fa93          	andi	s5,s1,15
    if (!(rx_ring[ind].status & E1000_RXD_STAT_DD)) {
    80005b5c:	004a9713          	slli	a4,s5,0x4
    80005b60:	00018797          	auipc	a5,0x18
    80005b64:	cf078793          	addi	a5,a5,-784 # 8001d850 <e1000_tx_lock>
    80005b68:	97ba                	add	a5,a5,a4
    80005b6a:	13c7c783          	lbu	a5,316(a5)
    80005b6e:	8b85                	andi	a5,a5,1
    80005b70:	cbad                	beqz	a5,80005be2 <e1000_intr+0xc2>
    80005b72:	f04a                	sd	s2,32(sp)
    80005b74:	ec4e                	sd	s3,24(sp)
    80005b76:	e852                	sd	s4,16(sp)
    80005b78:	84d6                	mv	s1,s5
    net_rx((char *)rx_ring[ind].addr, rx_ring[ind].length);
    80005b7a:	00018917          	auipc	s2,0x18
    80005b7e:	cd690913          	addi	s2,s2,-810 # 8001d850 <e1000_tx_lock>
    regs[E1000_RDT] = ind;
    80005b82:	00007a17          	auipc	s4,0x7
    80005b86:	a6ea0a13          	addi	s4,s4,-1426 # 8000c5f0 <regs>
    80005b8a:	698d                	lui	s3,0x3
    net_rx((char *)rx_ring[ind].addr, rx_ring[ind].length);
    80005b8c:	00449793          	slli	a5,s1,0x4
    80005b90:	97ca                	add	a5,a5,s2
    80005b92:	1387d583          	lhu	a1,312(a5)
    80005b96:	1307b503          	ld	a0,304(a5)
    80005b9a:	00001097          	auipc	ra,0x1
    80005b9e:	944080e7          	jalr	-1724(ra) # 800064de <net_rx>
    rx_bufs[ind] = kalloc();
    80005ba2:	ffffa097          	auipc	ra,0xffffa
    80005ba6:	578080e7          	jalr	1400(ra) # 8000011a <kalloc>
    if (!rx_bufs[ind]) panic("e1000");
    80005baa:	c931                	beqz	a0,80005bfe <e1000_intr+0xde>
    rx_ring[ind].addr = (uint64)rx_bufs[ind];
    80005bac:	0492                	slli	s1,s1,0x4
    80005bae:	94ca                	add	s1,s1,s2
    80005bb0:	12a4b823          	sd	a0,304(s1)
    rx_ring[ind].status = 0;
    80005bb4:	12048e23          	sb	zero,316(s1)
    regs[E1000_RDT] = ind;
    80005bb8:	000a3783          	ld	a5,0(s4)
    80005bbc:	97ce                	add	a5,a5,s3
    80005bbe:	8157ac23          	sw	s5,-2024(a5)
    int ind = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005bc2:	8187a483          	lw	s1,-2024(a5)
    80005bc6:	2485                	addiw	s1,s1,1
    80005bc8:	00f4fa93          	andi	s5,s1,15
    80005bcc:	84d6                	mv	s1,s5
    if (!(rx_ring[ind].status & E1000_RXD_STAT_DD)) {
    80005bce:	004a9793          	slli	a5,s5,0x4
    80005bd2:	97ca                	add	a5,a5,s2
    80005bd4:	13c7c783          	lbu	a5,316(a5)
    80005bd8:	8b85                	andi	a5,a5,1
    80005bda:	fbcd                	bnez	a5,80005b8c <e1000_intr+0x6c>
    80005bdc:	7902                	ld	s2,32(sp)
    80005bde:	69e2                	ld	s3,24(sp)
    80005be0:	6a42                	ld	s4,16(sp)
  release(&e1000_rx_lock);
    80005be2:	00018517          	auipc	a0,0x18
    80005be6:	c8650513          	addi	a0,a0,-890 # 8001d868 <e1000_rx_lock>
    80005bea:	00001097          	auipc	ra,0x1
    80005bee:	562080e7          	jalr	1378(ra) # 8000714c <release>

  e1000_recv();
}
    80005bf2:	70e2                	ld	ra,56(sp)
    80005bf4:	7442                	ld	s0,48(sp)
    80005bf6:	74a2                	ld	s1,40(sp)
    80005bf8:	6aa2                	ld	s5,8(sp)
    80005bfa:	6121                	addi	sp,sp,64
    80005bfc:	8082                	ret
    if (!rx_bufs[ind]) panic("e1000");
    80005bfe:	00004517          	auipc	a0,0x4
    80005c02:	b2a50513          	addi	a0,a0,-1238 # 80009728 <etext+0x728>
    80005c06:	00001097          	auipc	ra,0x1
    80005c0a:	f18080e7          	jalr	-232(ra) # 80006b1e <panic>

0000000080005c0e <netinit>:
// qemu host's ethernet address.
static uint8 host_mac[ETHADDR_LEN] = {0x52, 0x55, 0x0a, 0x00, 0x02, 0x02};

static struct spinlock netlock;

void netinit(void) {
    80005c0e:	7179                	addi	sp,sp,-48
    80005c10:	f406                	sd	ra,40(sp)
    80005c12:	f022                	sd	s0,32(sp)
    80005c14:	ec26                	sd	s1,24(sp)
    80005c16:	e84a                	sd	s2,16(sp)
    80005c18:	e44e                	sd	s3,8(sp)
    80005c1a:	1800                	addi	s0,sp,48
  // initialize network here
  initlock(&netlock, "netlock");
    80005c1c:	00004597          	auipc	a1,0x4
    80005c20:	b1458593          	addi	a1,a1,-1260 # 80009730 <etext+0x730>
    80005c24:	00018517          	auipc	a0,0x18
    80005c28:	e5c50513          	addi	a0,a0,-420 # 8001da80 <netlock>
    80005c2c:	00001097          	auipc	ra,0x1
    80005c30:	3dc080e7          	jalr	988(ra) # 80007008 <initlock>

  memset(portList, 0, sizeof(portList));
    80005c34:	00050637          	lui	a2,0x50
    80005c38:	0a060613          	addi	a2,a2,160 # 500a0 <_entry-0x7ffaff60>
    80005c3c:	4581                	li	a1,0
    80005c3e:	00018517          	auipc	a0,0x18
    80005c42:	e5a50513          	addi	a0,a0,-422 # 8001da98 <portList>
    80005c46:	ffffa097          	auipc	ra,0xffffa
    80005c4a:	534080e7          	jalr	1332(ra) # 8000017a <memset>

  for (int i = 0; i <= 2048; ++i) {
    80005c4e:	00018497          	auipc	s1,0x18
    80005c52:	e4a48493          	addi	s1,s1,-438 # 8001da98 <portList>
    80005c56:	00068997          	auipc	s3,0x68
    80005c5a:	ee298993          	addi	s3,s3,-286 # 8006db38 <portList+0x500a0>
    initlock(&portList[i].lock, "portlock");
    80005c5e:	00004917          	auipc	s2,0x4
    80005c62:	ada90913          	addi	s2,s2,-1318 # 80009738 <etext+0x738>
    80005c66:	85ca                	mv	a1,s2
    80005c68:	8526                	mv	a0,s1
    80005c6a:	00001097          	auipc	ra,0x1
    80005c6e:	39e080e7          	jalr	926(ra) # 80007008 <initlock>
  for (int i = 0; i <= 2048; ++i) {
    80005c72:	0a048493          	addi	s1,s1,160
    80005c76:	ff3498e3          	bne	s1,s3,80005c66 <netinit+0x58>
  }
}
    80005c7a:	70a2                	ld	ra,40(sp)
    80005c7c:	7402                	ld	s0,32(sp)
    80005c7e:	64e2                	ld	s1,24(sp)
    80005c80:	6942                	ld	s2,16(sp)
    80005c82:	69a2                	ld	s3,8(sp)
    80005c84:	6145                	addi	sp,sp,48
    80005c86:	8082                	ret

0000000080005c88 <sys_bind>:
//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64 sys_bind(void) {
    80005c88:	7179                	addi	sp,sp,-48
    80005c8a:	f406                	sd	ra,40(sp)
    80005c8c:	f022                	sd	s0,32(sp)
    80005c8e:	ec26                	sd	s1,24(sp)
    80005c90:	1800                	addi	s0,sp,48
  int port;

  argint(0, &port);
    80005c92:	fdc40593          	addi	a1,s0,-36
    80005c96:	4501                	li	a0,0
    80005c98:	ffffc097          	auipc	ra,0xffffc
    80005c9c:	3e4080e7          	jalr	996(ra) # 8000207c <argint>

  acquire(&portList[port].lock);
    80005ca0:	fdc42783          	lw	a5,-36(s0)
    80005ca4:	00279513          	slli	a0,a5,0x2
    80005ca8:	953e                	add	a0,a0,a5
    80005caa:	0516                	slli	a0,a0,0x5
    80005cac:	00018497          	auipc	s1,0x18
    80005cb0:	dec48493          	addi	s1,s1,-532 # 8001da98 <portList>
    80005cb4:	9526                	add	a0,a0,s1
    80005cb6:	00001097          	auipc	ra,0x1
    80005cba:	3e2080e7          	jalr	994(ra) # 80007098 <acquire>

  if (portList[port].init != 0) {
    80005cbe:	fdc42703          	lw	a4,-36(s0)
    80005cc2:	00271793          	slli	a5,a4,0x2
    80005cc6:	97ba                	add	a5,a5,a4
    80005cc8:	0796                	slli	a5,a5,0x5
    80005cca:	94be                	add	s1,s1,a5
    80005ccc:	09a4c783          	lbu	a5,154(s1)
    80005cd0:	eb8d                	bnez	a5,80005d02 <sys_bind+0x7a>
    release(&portList[port].lock);
    return -1;
  }

  portList[port].init = 1;
    80005cd2:	00018517          	auipc	a0,0x18
    80005cd6:	dc650513          	addi	a0,a0,-570 # 8001da98 <portList>
    80005cda:	00271793          	slli	a5,a4,0x2
    80005cde:	00e786b3          	add	a3,a5,a4
    80005ce2:	0696                	slli	a3,a3,0x5
    80005ce4:	96aa                	add	a3,a3,a0
    80005ce6:	4605                	li	a2,1
    80005ce8:	08c68d23          	sb	a2,154(a3)

  release(&portList[port].lock);
    80005cec:	8536                	mv	a0,a3
    80005cee:	00001097          	auipc	ra,0x1
    80005cf2:	45e080e7          	jalr	1118(ra) # 8000714c <release>

  return 0;
    80005cf6:	4501                	li	a0,0
}
    80005cf8:	70a2                	ld	ra,40(sp)
    80005cfa:	7402                	ld	s0,32(sp)
    80005cfc:	64e2                	ld	s1,24(sp)
    80005cfe:	6145                	addi	sp,sp,48
    80005d00:	8082                	ret
    release(&portList[port].lock);
    80005d02:	8526                	mv	a0,s1
    80005d04:	00001097          	auipc	ra,0x1
    80005d08:	448080e7          	jalr	1096(ra) # 8000714c <release>
    return -1;
    80005d0c:	557d                	li	a0,-1
    80005d0e:	b7ed                	j	80005cf8 <sys_bind+0x70>

0000000080005d10 <sys_unbind>:
//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64 sys_unbind(void) {
    80005d10:	7179                	addi	sp,sp,-48
    80005d12:	f406                	sd	ra,40(sp)
    80005d14:	f022                	sd	s0,32(sp)
    80005d16:	ec26                	sd	s1,24(sp)
    80005d18:	1800                	addi	s0,sp,48
  int port;

  argint(0, &port);
    80005d1a:	fdc40593          	addi	a1,s0,-36
    80005d1e:	4501                	li	a0,0
    80005d20:	ffffc097          	auipc	ra,0xffffc
    80005d24:	35c080e7          	jalr	860(ra) # 8000207c <argint>

  acquire(&portList[port].lock);
    80005d28:	fdc42783          	lw	a5,-36(s0)
    80005d2c:	00279513          	slli	a0,a5,0x2
    80005d30:	953e                	add	a0,a0,a5
    80005d32:	0516                	slli	a0,a0,0x5
    80005d34:	00018497          	auipc	s1,0x18
    80005d38:	d6448493          	addi	s1,s1,-668 # 8001da98 <portList>
    80005d3c:	9526                	add	a0,a0,s1
    80005d3e:	00001097          	auipc	ra,0x1
    80005d42:	35a080e7          	jalr	858(ra) # 80007098 <acquire>

  portList[port].init = 0;
    80005d46:	fdc42683          	lw	a3,-36(s0)
    80005d4a:	00269793          	slli	a5,a3,0x2
    80005d4e:	97b6                	add	a5,a5,a3
    80005d50:	0796                	slli	a5,a5,0x5
    80005d52:	94be                	add	s1,s1,a5
    80005d54:	08048d23          	sb	zero,154(s1)
  while (portList[port].count > 0) {
    80005d58:	0994c783          	lbu	a5,153(s1)
    80005d5c:	cfa9                	beqz	a5,80005db6 <sys_unbind+0xa6>
    kfree(portList[port].buf[portList[port].p]);
    80005d5e:	00018497          	auipc	s1,0x18
    80005d62:	d3a48493          	addi	s1,s1,-710 # 8001da98 <portList>
    80005d66:	00269793          	slli	a5,a3,0x2
    80005d6a:	00d78733          	add	a4,a5,a3
    80005d6e:	0716                	slli	a4,a4,0x5
    80005d70:	9726                	add	a4,a4,s1
    80005d72:	09874703          	lbu	a4,152(a4) # 3098 <_entry-0x7fffcf68>
    80005d76:	97b6                	add	a5,a5,a3
    80005d78:	078a                	slli	a5,a5,0x2
    80005d7a:	97ba                	add	a5,a5,a4
    80005d7c:	0789                	addi	a5,a5,2
    80005d7e:	078e                	slli	a5,a5,0x3
    80005d80:	97a6                	add	a5,a5,s1
    80005d82:	6788                	ld	a0,8(a5)
    80005d84:	ffffa097          	auipc	ra,0xffffa
    80005d88:	298080e7          	jalr	664(ra) # 8000001c <kfree>
    portList[port].p = (portList[port].p + 1) % PORT_QUEUE_SIZE;
    80005d8c:	fdc42683          	lw	a3,-36(s0)
    80005d90:	00269793          	slli	a5,a3,0x2
    80005d94:	97b6                	add	a5,a5,a3
    80005d96:	0796                	slli	a5,a5,0x5
    80005d98:	97a6                	add	a5,a5,s1
    80005d9a:	0987c703          	lbu	a4,152(a5)
    80005d9e:	2705                	addiw	a4,a4,1
    80005da0:	8b3d                	andi	a4,a4,15
    80005da2:	08e78c23          	sb	a4,152(a5)
    portList[port].count--;
    80005da6:	0997c703          	lbu	a4,153(a5)
    80005daa:	377d                	addiw	a4,a4,-1
    80005dac:	0ff77713          	zext.b	a4,a4
    80005db0:	08e78ca3          	sb	a4,153(a5)
  while (portList[port].count > 0) {
    80005db4:	fb4d                	bnez	a4,80005d66 <sys_unbind+0x56>
  }

  portList[port].p = 0;
    80005db6:	00018517          	auipc	a0,0x18
    80005dba:	ce250513          	addi	a0,a0,-798 # 8001da98 <portList>
    80005dbe:	00269793          	slli	a5,a3,0x2
    80005dc2:	00d78733          	add	a4,a5,a3
    80005dc6:	0716                	slli	a4,a4,0x5
    80005dc8:	972a                	add	a4,a4,a0
    80005dca:	08070c23          	sb	zero,152(a4)

  release(&portList[port].lock);
    80005dce:	853a                	mv	a0,a4
    80005dd0:	00001097          	auipc	ra,0x1
    80005dd4:	37c080e7          	jalr	892(ra) # 8000714c <release>

  return 0;
}
    80005dd8:	4501                	li	a0,0
    80005dda:	70a2                	ld	ra,40(sp)
    80005ddc:	7402                	ld	s0,32(sp)
    80005dde:	64e2                	ld	s1,24(sp)
    80005de0:	6145                	addi	sp,sp,48
    80005de2:	8082                	ret

0000000080005de4 <sys_recv>:
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64 sys_recv(void) {
    80005de4:	7159                	addi	sp,sp,-112
    80005de6:	f486                	sd	ra,104(sp)
    80005de8:	f0a2                	sd	s0,96(sp)
    80005dea:	eca6                	sd	s1,88(sp)
    80005dec:	e8ca                	sd	s2,80(sp)
    80005dee:	e4ce                	sd	s3,72(sp)
    80005df0:	1880                	addi	s0,sp,112
  struct proc *p = myproc();
    80005df2:	ffffb097          	auipc	ra,0xffffb
    80005df6:	154080e7          	jalr	340(ra) # 80000f46 <myproc>
    80005dfa:	892a                	mv	s2,a0
  uint64 src;
  uint64 sport;
  uint64 buf;
  int maxlen;

  argint(0, &dport);
    80005dfc:	fcc40593          	addi	a1,s0,-52
    80005e00:	4501                	li	a0,0
    80005e02:	ffffc097          	auipc	ra,0xffffc
    80005e06:	27a080e7          	jalr	634(ra) # 8000207c <argint>
  argaddr(1, &src);
    80005e0a:	fc040593          	addi	a1,s0,-64
    80005e0e:	4505                	li	a0,1
    80005e10:	ffffc097          	auipc	ra,0xffffc
    80005e14:	28c080e7          	jalr	652(ra) # 8000209c <argaddr>
  argaddr(2, &sport);
    80005e18:	fb840593          	addi	a1,s0,-72
    80005e1c:	4509                	li	a0,2
    80005e1e:	ffffc097          	auipc	ra,0xffffc
    80005e22:	27e080e7          	jalr	638(ra) # 8000209c <argaddr>
  argaddr(3, &buf);
    80005e26:	fb040593          	addi	a1,s0,-80
    80005e2a:	450d                	li	a0,3
    80005e2c:	ffffc097          	auipc	ra,0xffffc
    80005e30:	270080e7          	jalr	624(ra) # 8000209c <argaddr>
  argint(4, &maxlen);
    80005e34:	fac40593          	addi	a1,s0,-84
    80005e38:	4511                	li	a0,4
    80005e3a:	ffffc097          	auipc	ra,0xffffc
    80005e3e:	242080e7          	jalr	578(ra) # 8000207c <argint>

  acquire(&portList[dport].lock);
    80005e42:	fcc42783          	lw	a5,-52(s0)
    80005e46:	00279513          	slli	a0,a5,0x2
    80005e4a:	953e                	add	a0,a0,a5
    80005e4c:	0516                	slli	a0,a0,0x5
    80005e4e:	00018497          	auipc	s1,0x18
    80005e52:	c4a48493          	addi	s1,s1,-950 # 8001da98 <portList>
    80005e56:	9526                	add	a0,a0,s1
    80005e58:	00001097          	auipc	ra,0x1
    80005e5c:	240080e7          	jalr	576(ra) # 80007098 <acquire>

  if (!portList[dport].init) {
    80005e60:	fcc42703          	lw	a4,-52(s0)
    80005e64:	00271793          	slli	a5,a4,0x2
    80005e68:	97ba                	add	a5,a5,a4
    80005e6a:	0796                	slli	a5,a5,0x5
    80005e6c:	94be                	add	s1,s1,a5
    80005e6e:	09a4c783          	lbu	a5,154(s1)
    80005e72:	18078163          	beqz	a5,80005ff4 <sys_recv+0x210>
    80005e76:	e0d2                	sd	s4,64(sp)
    release(&portList[dport].lock);
    return -1;
  }

  while (portList[dport].count == 0) {
    80005e78:	00018697          	auipc	a3,0x18
    80005e7c:	c2068693          	addi	a3,a3,-992 # 8001da98 <portList>
    80005e80:	0994c783          	lbu	a5,153(s1)
    sleep(&portList[dport], &portList[dport].lock);
    80005e84:	84b6                	mv	s1,a3
  while (portList[dport].count == 0) {
    80005e86:	e78d                	bnez	a5,80005eb0 <sys_recv+0xcc>
    sleep(&portList[dport], &portList[dport].lock);
    80005e88:	00271513          	slli	a0,a4,0x2
    80005e8c:	953a                	add	a0,a0,a4
    80005e8e:	0516                	slli	a0,a0,0x5
    80005e90:	9526                	add	a0,a0,s1
    80005e92:	85aa                	mv	a1,a0
    80005e94:	ffffb097          	auipc	ra,0xffffb
    80005e98:	760080e7          	jalr	1888(ra) # 800015f4 <sleep>
  while (portList[dport].count == 0) {
    80005e9c:	fcc42703          	lw	a4,-52(s0)
    80005ea0:	00271793          	slli	a5,a4,0x2
    80005ea4:	97ba                	add	a5,a5,a4
    80005ea6:	0796                	slli	a5,a5,0x5
    80005ea8:	97a6                	add	a5,a5,s1
    80005eaa:	0997c783          	lbu	a5,153(a5)
    80005eae:	dfe9                	beqz	a5,80005e88 <sys_recv+0xa4>
  }

  char *packet = portList[dport].buf[portList[dport].p];
    80005eb0:	00018617          	auipc	a2,0x18
    80005eb4:	be860613          	addi	a2,a2,-1048 # 8001da98 <portList>
    80005eb8:	00271793          	slli	a5,a4,0x2
    80005ebc:	00e786b3          	add	a3,a5,a4
    80005ec0:	0696                	slli	a3,a3,0x5
    80005ec2:	96b2                	add	a3,a3,a2
    80005ec4:	0986c683          	lbu	a3,152(a3)
    80005ec8:	97ba                	add	a5,a5,a4
    80005eca:	078a                	slli	a5,a5,0x2
    80005ecc:	97b6                	add	a5,a5,a3
    80005ece:	0789                	addi	a5,a5,2
    80005ed0:	078e                	slli	a5,a5,0x3
    80005ed2:	963e                	add	a2,a2,a5
    80005ed4:	6604                	ld	s1,8(a2)

  struct ip *ip = (struct ip *)((struct eth *)packet + 1);
  uint64 ips = htonl(ip->ip_src);
    80005ed6:	01a4a703          	lw	a4,26(s1)
static inline uint16 bswaps(uint16 val) {
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val) {
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80005eda:	0187179b          	slliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80005ede:	0187569b          	srliw	a3,a4,0x18
    80005ee2:	8fd5                	or	a5,a5,a3
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80005ee4:	0087169b          	slliw	a3,a4,0x8
    80005ee8:	00ff0637          	lui	a2,0xff0
    80005eec:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    80005eee:	8fd5                	or	a5,a5,a3
    80005ef0:	0087571b          	srliw	a4,a4,0x8
    80005ef4:	66c1                	lui	a3,0x10
    80005ef6:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005efa:	8f75                	and	a4,a4,a3
    80005efc:	8fd9                	or	a5,a5,a4
    80005efe:	1782                	slli	a5,a5,0x20
    80005f00:	9381                	srli	a5,a5,0x20
    80005f02:	faf43023          	sd	a5,-96(s0)
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    80005f06:	0224d783          	lhu	a5,34(s1)
    80005f0a:	0087971b          	slliw	a4,a5,0x8
    80005f0e:	83a1                	srli	a5,a5,0x8
    80005f10:	8fd9                	or	a5,a5,a4

  struct udp *udp = (struct udp *)(ip + 1);
  uint64 udps = htons(udp->sport);
    80005f12:	17c2                	slli	a5,a5,0x30
    80005f14:	93c1                	srli	a5,a5,0x30
    80005f16:	f8f43c23          	sd	a5,-104(s0)
    80005f1a:	0264d783          	lhu	a5,38(s1)
    80005f1e:	0087971b          	slliw	a4,a5,0x8
    80005f22:	83a1                	srli	a5,a5,0x8
    80005f24:	8fd9                	or	a5,a5,a4

  int len = (htons(udp->ulen) - 8 < maxlen) ? htons(udp->ulen) - 8 : maxlen;
    80005f26:	0107979b          	slliw	a5,a5,0x10
    80005f2a:	0107d79b          	srliw	a5,a5,0x10
    80005f2e:	fac42a03          	lw	s4,-84(s0)
    80005f32:	ff97871b          	addiw	a4,a5,-7
    80005f36:	00ea4463          	blt	s4,a4,80005f3e <sys_recv+0x15a>
    80005f3a:	ff878a1b          	addiw	s4,a5,-8

  char *payload = (char *)(udp + 1);
  if (copyout(p->pagetable, src, (char *)(&ips), 4) < 0 ||
    80005f3e:	4691                	li	a3,4
    80005f40:	fa040613          	addi	a2,s0,-96
    80005f44:	fc043583          	ld	a1,-64(s0)
    80005f48:	05093503          	ld	a0,80(s2)
    80005f4c:	ffffb097          	auipc	ra,0xffffb
    80005f50:	c40080e7          	jalr	-960(ra) # 80000b8c <copyout>
    80005f54:	0a054f63          	bltz	a0,80006012 <sys_recv+0x22e>
      copyout(p->pagetable, sport, (char *)(&udps), 2) < 0 ||
    80005f58:	4689                	li	a3,2
    80005f5a:	f9840613          	addi	a2,s0,-104
    80005f5e:	fb843583          	ld	a1,-72(s0)
    80005f62:	05093503          	ld	a0,80(s2)
    80005f66:	ffffb097          	auipc	ra,0xffffb
    80005f6a:	c26080e7          	jalr	-986(ra) # 80000b8c <copyout>
  if (copyout(p->pagetable, src, (char *)(&ips), 4) < 0 ||
    80005f6e:	0a054263          	bltz	a0,80006012 <sys_recv+0x22e>
      copyout(p->pagetable, buf, payload, len) < 0) {
    80005f72:	89d2                	mv	s3,s4
    80005f74:	86d2                	mv	a3,s4
    80005f76:	02a48613          	addi	a2,s1,42
    80005f7a:	fb043583          	ld	a1,-80(s0)
    80005f7e:	05093503          	ld	a0,80(s2)
    80005f82:	ffffb097          	auipc	ra,0xffffb
    80005f86:	c0a080e7          	jalr	-1014(ra) # 80000b8c <copyout>
      copyout(p->pagetable, sport, (char *)(&udps), 2) < 0 ||
    80005f8a:	08054463          	bltz	a0,80006012 <sys_recv+0x22e>
    release(&portList[dport].lock);
    return -1;
  }

  kfree(portList[dport].buf[portList[dport].p]);
    80005f8e:	fcc42683          	lw	a3,-52(s0)
    80005f92:	00018497          	auipc	s1,0x18
    80005f96:	b0648493          	addi	s1,s1,-1274 # 8001da98 <portList>
    80005f9a:	00269793          	slli	a5,a3,0x2
    80005f9e:	00d78733          	add	a4,a5,a3
    80005fa2:	0716                	slli	a4,a4,0x5
    80005fa4:	9726                	add	a4,a4,s1
    80005fa6:	09874703          	lbu	a4,152(a4)
    80005faa:	97b6                	add	a5,a5,a3
    80005fac:	078a                	slli	a5,a5,0x2
    80005fae:	97ba                	add	a5,a5,a4
    80005fb0:	0789                	addi	a5,a5,2
    80005fb2:	078e                	slli	a5,a5,0x3
    80005fb4:	97a6                	add	a5,a5,s1
    80005fb6:	6788                	ld	a0,8(a5)
    80005fb8:	ffffa097          	auipc	ra,0xffffa
    80005fbc:	064080e7          	jalr	100(ra) # 8000001c <kfree>
  portList[dport].p = (portList[dport].p + 1) % PORT_QUEUE_SIZE;
    80005fc0:	fcc42603          	lw	a2,-52(s0)
    80005fc4:	00261713          	slli	a4,a2,0x2
    80005fc8:	00c707b3          	add	a5,a4,a2
    80005fcc:	0796                	slli	a5,a5,0x5
    80005fce:	97a6                	add	a5,a5,s1
    80005fd0:	0987c683          	lbu	a3,152(a5)
    80005fd4:	2685                	addiw	a3,a3,1
    80005fd6:	8abd                	andi	a3,a3,15
    80005fd8:	08d78c23          	sb	a3,152(a5)
  portList[dport].count--;
    80005fdc:	0997c683          	lbu	a3,153(a5)
    80005fe0:	36fd                	addiw	a3,a3,-1
    80005fe2:	08d78ca3          	sb	a3,153(a5)

  release(&portList[dport].lock);
    80005fe6:	853e                	mv	a0,a5
    80005fe8:	00001097          	auipc	ra,0x1
    80005fec:	164080e7          	jalr	356(ra) # 8000714c <release>
    80005ff0:	6a06                	ld	s4,64(sp)

  return len;
    80005ff2:	a089                	j	80006034 <sys_recv+0x250>
    release(&portList[dport].lock);
    80005ff4:	00271793          	slli	a5,a4,0x2
    80005ff8:	97ba                	add	a5,a5,a4
    80005ffa:	0796                	slli	a5,a5,0x5
    80005ffc:	00018517          	auipc	a0,0x18
    80006000:	a9c50513          	addi	a0,a0,-1380 # 8001da98 <portList>
    80006004:	953e                	add	a0,a0,a5
    80006006:	00001097          	auipc	ra,0x1
    8000600a:	146080e7          	jalr	326(ra) # 8000714c <release>
    return -1;
    8000600e:	59fd                	li	s3,-1
    80006010:	a015                	j	80006034 <sys_recv+0x250>
    release(&portList[dport].lock);
    80006012:	fcc42703          	lw	a4,-52(s0)
    80006016:	00271793          	slli	a5,a4,0x2
    8000601a:	97ba                	add	a5,a5,a4
    8000601c:	0796                	slli	a5,a5,0x5
    8000601e:	00018517          	auipc	a0,0x18
    80006022:	a7a50513          	addi	a0,a0,-1414 # 8001da98 <portList>
    80006026:	953e                	add	a0,a0,a5
    80006028:	00001097          	auipc	ra,0x1
    8000602c:	124080e7          	jalr	292(ra) # 8000714c <release>
    return -1;
    80006030:	59fd                	li	s3,-1
    80006032:	6a06                	ld	s4,64(sp)
}
    80006034:	854e                	mv	a0,s3
    80006036:	70a6                	ld	ra,104(sp)
    80006038:	7406                	ld	s0,96(sp)
    8000603a:	64e6                	ld	s1,88(sp)
    8000603c:	6946                	ld	s2,80(sp)
    8000603e:	69a6                	ld	s3,72(sp)
    80006040:	6165                	addi	sp,sp,112
    80006042:	8082                	ret

0000000080006044 <sys_send>:
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64 sys_send(void) {
    80006044:	715d                	addi	sp,sp,-80
    80006046:	e486                	sd	ra,72(sp)
    80006048:	e0a2                	sd	s0,64(sp)
    8000604a:	f84a                	sd	s2,48(sp)
    8000604c:	f44e                	sd	s3,40(sp)
    8000604e:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80006050:	ffffb097          	auipc	ra,0xffffb
    80006054:	ef6080e7          	jalr	-266(ra) # 80000f46 <myproc>
    80006058:	89aa                	mv	s3,a0
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
    8000605a:	fcc40593          	addi	a1,s0,-52
    8000605e:	4501                	li	a0,0
    80006060:	ffffc097          	auipc	ra,0xffffc
    80006064:	01c080e7          	jalr	28(ra) # 8000207c <argint>
  argint(1, &dst);
    80006068:	fc840593          	addi	a1,s0,-56
    8000606c:	4505                	li	a0,1
    8000606e:	ffffc097          	auipc	ra,0xffffc
    80006072:	00e080e7          	jalr	14(ra) # 8000207c <argint>
  argint(2, &dport);
    80006076:	fc440593          	addi	a1,s0,-60
    8000607a:	4509                	li	a0,2
    8000607c:	ffffc097          	auipc	ra,0xffffc
    80006080:	000080e7          	jalr	ra # 8000207c <argint>
  argaddr(3, &bufaddr);
    80006084:	fb840593          	addi	a1,s0,-72
    80006088:	450d                	li	a0,3
    8000608a:	ffffc097          	auipc	ra,0xffffc
    8000608e:	012080e7          	jalr	18(ra) # 8000209c <argaddr>
  argint(4, &len);
    80006092:	fb440593          	addi	a1,s0,-76
    80006096:	4511                	li	a0,4
    80006098:	ffffc097          	auipc	ra,0xffffc
    8000609c:	fe4080e7          	jalr	-28(ra) # 8000207c <argint>

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    800060a0:	fb442903          	lw	s2,-76(s0)
    800060a4:	02a9091b          	addiw	s2,s2,42
  if (total > PGSIZE) return -1;
    800060a8:	6785                	lui	a5,0x1
    800060aa:	557d                	li	a0,-1
    800060ac:	1727ce63          	blt	a5,s2,80006228 <sys_send+0x1e4>
    800060b0:	fc26                	sd	s1,56(sp)

  char *buf = kalloc();
    800060b2:	ffffa097          	auipc	ra,0xffffa
    800060b6:	068080e7          	jalr	104(ra) # 8000011a <kalloc>
    800060ba:	84aa                	mv	s1,a0
  if (buf == 0) {
    800060bc:	16050c63          	beqz	a0,80006234 <sys_send+0x1f0>
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);
    800060c0:	6605                	lui	a2,0x1
    800060c2:	4581                	li	a1,0
    800060c4:	ffffa097          	auipc	ra,0xffffa
    800060c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    800060cc:	4619                	li	a2,6
    800060ce:	00006597          	auipc	a1,0x6
    800060d2:	48a58593          	addi	a1,a1,1162 # 8000c558 <host_mac>
    800060d6:	8526                	mv	a0,s1
    800060d8:	ffffa097          	auipc	ra,0xffffa
    800060dc:	0fe080e7          	jalr	254(ra) # 800001d6 <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    800060e0:	4619                	li	a2,6
    800060e2:	00006597          	auipc	a1,0x6
    800060e6:	47e58593          	addi	a1,a1,1150 # 8000c560 <local_mac>
    800060ea:	00648513          	addi	a0,s1,6
    800060ee:	ffffa097          	auipc	ra,0xffffa
    800060f2:	0e8080e7          	jalr	232(ra) # 800001d6 <memmove>
  eth->type = htons(ETHTYPE_IP);
    800060f6:	47a1                	li	a5,8
    800060f8:	00f48623          	sb	a5,12(s1)
    800060fc:	000486a3          	sb	zero,13(s1)

  struct ip *ip = (struct ip *)(eth + 1);
    80006100:	00e48713          	addi	a4,s1,14
  ip->ip_vhl = 0x45;  // version 4, header length 4*5
    80006104:	04500793          	li	a5,69
    80006108:	00f48723          	sb	a5,14(s1)
  ip->ip_tos = 0;
    8000610c:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    80006110:	fb442683          	lw	a3,-76(s0)
    80006114:	03069813          	slli	a6,a3,0x30
    80006118:	03085813          	srli	a6,a6,0x30
    8000611c:	01c8079b          	addiw	a5,a6,28
    80006120:	0087961b          	slliw	a2,a5,0x8
    80006124:	0107979b          	slliw	a5,a5,0x10
    80006128:	0107d79b          	srliw	a5,a5,0x10
    8000612c:	0087d79b          	srliw	a5,a5,0x8
    80006130:	8fd1                	or	a5,a5,a2
    80006132:	00f49823          	sh	a5,16(s1)
  ip->ip_id = 0;
    80006136:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    8000613a:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    8000613e:	06400793          	li	a5,100
    80006142:	00f48b23          	sb	a5,22(s1)
  ip->ip_p = IPPROTO_UDP;
    80006146:	47c5                	li	a5,17
    80006148:	00f48ba3          	sb	a5,23(s1)
  ip->ip_src = htonl(local_ip);
    8000614c:	0f0207b7          	lui	a5,0xf020
    80006150:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80006152:	00f4ad23          	sw	a5,26(s1)
  ip->ip_dst = htonl(dst);
    80006156:	fc842783          	lw	a5,-56(s0)
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    8000615a:	0187961b          	slliw	a2,a5,0x18
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    8000615e:	0187d59b          	srliw	a1,a5,0x18
    80006162:	8e4d                	or	a2,a2,a1
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
    80006164:	0087959b          	slliw	a1,a5,0x8
    80006168:	00ff0537          	lui	a0,0xff0
    8000616c:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
    8000616e:	8e4d                	or	a2,a2,a1
    80006170:	0087d79b          	srliw	a5,a5,0x8
    80006174:	65c1                	lui	a1,0x10
    80006176:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    8000617a:	8fed                	and	a5,a5,a1
    8000617c:	8fd1                	or	a5,a5,a2
    8000617e:	00f4af23          	sw	a5,30(s1)
  while (nleft > 1) {
    80006182:	02248593          	addi	a1,s1,34
  unsigned int sum = 0;
    80006186:	4601                	li	a2,0
    sum += *w++;
    80006188:	0709                	addi	a4,a4,2
    8000618a:	ffe75783          	lhu	a5,-2(a4)
    8000618e:	9fb1                	addw	a5,a5,a2
    80006190:	0007861b          	sext.w	a2,a5
  while (nleft > 1) {
    80006194:	feb71ae3          	bne	a4,a1,80006188 <sys_send+0x144>
  sum = (sum & 0xffff) + (sum >> 16);
    80006198:	03079713          	slli	a4,a5,0x30
    8000619c:	9341                	srli	a4,a4,0x30
    8000619e:	0107d79b          	srliw	a5,a5,0x10
    800061a2:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    800061a4:	0107d71b          	srliw	a4,a5,0x10
    800061a8:	9fb9                	addw	a5,a5,a4
  answer = ~sum; /* truncate to 16 bits */
    800061aa:	fff7c793          	not	a5,a5
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    800061ae:	00f49c23          	sh	a5,24(s1)

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
    800061b2:	fcc42783          	lw	a5,-52(s0)
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
    800061b6:	0087971b          	slliw	a4,a5,0x8
    800061ba:	0107979b          	slliw	a5,a5,0x10
    800061be:	0107d79b          	srliw	a5,a5,0x10
    800061c2:	0087d79b          	srliw	a5,a5,0x8
    800061c6:	8fd9                	or	a5,a5,a4
    800061c8:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    800061cc:	fc442783          	lw	a5,-60(s0)
    800061d0:	0087971b          	slliw	a4,a5,0x8
    800061d4:	0107979b          	slliw	a5,a5,0x10
    800061d8:	0107d79b          	srliw	a5,a5,0x10
    800061dc:	0087d79b          	srliw	a5,a5,0x8
    800061e0:	8fd9                	or	a5,a5,a4
    800061e2:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    800061e6:	0088079b          	addiw	a5,a6,8
    800061ea:	0087971b          	slliw	a4,a5,0x8
    800061ee:	0107979b          	slliw	a5,a5,0x10
    800061f2:	0107d79b          	srliw	a5,a5,0x10
    800061f6:	0087d79b          	srliw	a5,a5,0x8
    800061fa:	8fd9                	or	a5,a5,a4
    800061fc:	02f49323          	sh	a5,38(s1)

  char *payload = (char *)(udp + 1);
  if (copyin(p->pagetable, payload, bufaddr, len) < 0) {
    80006200:	fb843603          	ld	a2,-72(s0)
    80006204:	02a48593          	addi	a1,s1,42
    80006208:	0509b503          	ld	a0,80(s3)
    8000620c:	ffffb097          	auipc	ra,0xffffb
    80006210:	a5e080e7          	jalr	-1442(ra) # 80000c6a <copyin>
    80006214:	02054b63          	bltz	a0,8000624a <sys_send+0x206>
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);
    80006218:	85ca                	mv	a1,s2
    8000621a:	8526                	mv	a0,s1
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	834080e7          	jalr	-1996(ra) # 80005a50 <e1000_transmit>

  return 0;
    80006224:	4501                	li	a0,0
    80006226:	74e2                	ld	s1,56(sp)
}
    80006228:	60a6                	ld	ra,72(sp)
    8000622a:	6406                	ld	s0,64(sp)
    8000622c:	7942                	ld	s2,48(sp)
    8000622e:	79a2                	ld	s3,40(sp)
    80006230:	6161                	addi	sp,sp,80
    80006232:	8082                	ret
    printf("sys_send: kalloc failed\n");
    80006234:	00003517          	auipc	a0,0x3
    80006238:	51450513          	addi	a0,a0,1300 # 80009748 <etext+0x748>
    8000623c:	00001097          	auipc	ra,0x1
    80006240:	92c080e7          	jalr	-1748(ra) # 80006b68 <printf>
    return -1;
    80006244:	557d                	li	a0,-1
    80006246:	74e2                	ld	s1,56(sp)
    80006248:	b7c5                	j	80006228 <sys_send+0x1e4>
    kfree(buf);
    8000624a:	8526                	mv	a0,s1
    8000624c:	ffffa097          	auipc	ra,0xffffa
    80006250:	dd0080e7          	jalr	-560(ra) # 8000001c <kfree>
    printf("send: copyin failed\n");
    80006254:	00003517          	auipc	a0,0x3
    80006258:	51450513          	addi	a0,a0,1300 # 80009768 <etext+0x768>
    8000625c:	00001097          	auipc	ra,0x1
    80006260:	90c080e7          	jalr	-1780(ra) # 80006b68 <printf>
    return -1;
    80006264:	557d                	li	a0,-1
    80006266:	74e2                	ld	s1,56(sp)
    80006268:	b7c1                	j	80006228 <sys_send+0x1e4>

000000008000626a <ip_rx>:

void ip_rx(char *buf, int len) {
    8000626a:	7139                	addi	sp,sp,-64
    8000626c:	fc06                	sd	ra,56(sp)
    8000626e:	f822                	sd	s0,48(sp)
    80006270:	f426                	sd	s1,40(sp)
    80006272:	ec4e                	sd	s3,24(sp)
    80006274:	0080                	addi	s0,sp,64
    80006276:	84aa                	mv	s1,a0
    80006278:	89ae                	mv	s3,a1
  // don't delete this printf
  static int seen_ip = 0;
  if (seen_ip == 0) printf("ip_rx: received an IP packet\n");
    8000627a:	00006797          	auipc	a5,0x6
    8000627e:	3827a783          	lw	a5,898(a5) # 8000c5fc <seen_ip.1>
    80006282:	c795                	beqz	a5,800062ae <ip_rx+0x44>
  seen_ip = 1;
    80006284:	4785                	li	a5,1
    80006286:	00006717          	auipc	a4,0x6
    8000628a:	36f72b23          	sw	a5,886(a4) # 8000c5fc <seen_ip.1>

  struct ip *ip = (struct ip *)((struct eth *)buf + 1);

  if (ip->ip_p != IPPROTO_UDP) {
    8000628e:	0174c703          	lbu	a4,23(s1)
    80006292:	47c5                	li	a5,17
    80006294:	02f70663          	beq	a4,a5,800062c0 <ip_rx+0x56>
    kfree(buf);
    80006298:	8526                	mv	a0,s1
    8000629a:	ffffa097          	auipc	ra,0xffffa
    8000629e:	d82080e7          	jalr	-638(ra) # 8000001c <kfree>
      new_buf;

  wakeup(&portList[uport]);

  release(&portList[uport].lock);
}
    800062a2:	70e2                	ld	ra,56(sp)
    800062a4:	7442                	ld	s0,48(sp)
    800062a6:	74a2                	ld	s1,40(sp)
    800062a8:	69e2                	ld	s3,24(sp)
    800062aa:	6121                	addi	sp,sp,64
    800062ac:	8082                	ret
  if (seen_ip == 0) printf("ip_rx: received an IP packet\n");
    800062ae:	00003517          	auipc	a0,0x3
    800062b2:	4d250513          	addi	a0,a0,1234 # 80009780 <etext+0x780>
    800062b6:	00001097          	auipc	ra,0x1
    800062ba:	8b2080e7          	jalr	-1870(ra) # 80006b68 <printf>
    800062be:	b7d9                	j	80006284 <ip_rx+0x1a>
    800062c0:	f04a                	sd	s2,32(sp)
    800062c2:	e852                	sd	s4,16(sp)
    800062c4:	e456                	sd	s5,8(sp)
    800062c6:	0244d783          	lhu	a5,36(s1)
    800062ca:	0087971b          	slliw	a4,a5,0x8
    800062ce:	83a1                	srli	a5,a5,0x8
    800062d0:	8fd9                	or	a5,a5,a4
    800062d2:	17c2                	slli	a5,a5,0x30
    800062d4:	93c1                	srli	a5,a5,0x30
  acquire(&portList[uport].lock);
    800062d6:	00078a1b          	sext.w	s4,a5
    800062da:	00279913          	slli	s2,a5,0x2
    800062de:	993e                	add	s2,s2,a5
    800062e0:	0916                	slli	s2,s2,0x5
    800062e2:	00017a97          	auipc	s5,0x17
    800062e6:	7b6a8a93          	addi	s5,s5,1974 # 8001da98 <portList>
    800062ea:	9956                	add	s2,s2,s5
    800062ec:	854a                	mv	a0,s2
    800062ee:	00001097          	auipc	ra,0x1
    800062f2:	daa080e7          	jalr	-598(ra) # 80007098 <acquire>
  if (portList[uport].init == 0 || portList[uport].count == 16) {
    800062f6:	002a1793          	slli	a5,s4,0x2
    800062fa:	97d2                	add	a5,a5,s4
    800062fc:	0796                	slli	a5,a5,0x5
    800062fe:	9abe                	add	s5,s5,a5
    80006300:	09aac783          	lbu	a5,154(s5)
    80006304:	cfad                	beqz	a5,8000637e <ip_rx+0x114>
    80006306:	099ac703          	lbu	a4,153(s5)
    8000630a:	47c1                	li	a5,16
    8000630c:	06f70963          	beq	a4,a5,8000637e <ip_rx+0x114>
  char *new_buf = kalloc();
    80006310:	ffffa097          	auipc	ra,0xffffa
    80006314:	e0a080e7          	jalr	-502(ra) # 8000011a <kalloc>
    80006318:	8aaa                	mv	s5,a0
  if (new_buf == 0) {
    8000631a:	c93d                	beqz	a0,80006390 <ip_rx+0x126>
  memmove((void *)new_buf, (void *)buf, len);
    8000631c:	864e                	mv	a2,s3
    8000631e:	85a6                	mv	a1,s1
    80006320:	ffffa097          	auipc	ra,0xffffa
    80006324:	eb6080e7          	jalr	-330(ra) # 800001d6 <memmove>
      .buf[(portList[uport].p + portList[uport].count++) % PORT_QUEUE_SIZE] =
    80006328:	00017617          	auipc	a2,0x17
    8000632c:	77060613          	addi	a2,a2,1904 # 8001da98 <portList>
    80006330:	002a1793          	slli	a5,s4,0x2
    80006334:	01478733          	add	a4,a5,s4
    80006338:	0716                	slli	a4,a4,0x5
    8000633a:	9732                	add	a4,a4,a2
    8000633c:	09874683          	lbu	a3,152(a4)
    80006340:	09974583          	lbu	a1,153(a4)
    80006344:	0015851b          	addiw	a0,a1,1
    80006348:	08a70ca3          	sb	a0,153(a4)
    8000634c:	00b6873b          	addw	a4,a3,a1
    80006350:	8b3d                	andi	a4,a4,15
    80006352:	97d2                	add	a5,a5,s4
    80006354:	078a                	slli	a5,a5,0x2
    80006356:	97ba                	add	a5,a5,a4
    80006358:	0789                	addi	a5,a5,2
    8000635a:	078e                	slli	a5,a5,0x3
    8000635c:	963e                	add	a2,a2,a5
    8000635e:	01563423          	sd	s5,8(a2)
  wakeup(&portList[uport]);
    80006362:	854a                	mv	a0,s2
    80006364:	ffffb097          	auipc	ra,0xffffb
    80006368:	2f4080e7          	jalr	756(ra) # 80001658 <wakeup>
  release(&portList[uport].lock);
    8000636c:	854a                	mv	a0,s2
    8000636e:	00001097          	auipc	ra,0x1
    80006372:	dde080e7          	jalr	-546(ra) # 8000714c <release>
    80006376:	7902                	ld	s2,32(sp)
    80006378:	6a42                	ld	s4,16(sp)
    8000637a:	6aa2                	ld	s5,8(sp)
    8000637c:	b71d                	j	800062a2 <ip_rx+0x38>
    release(&portList[uport].lock);
    8000637e:	854a                	mv	a0,s2
    80006380:	00001097          	auipc	ra,0x1
    80006384:	dcc080e7          	jalr	-564(ra) # 8000714c <release>
    return;
    80006388:	7902                	ld	s2,32(sp)
    8000638a:	6a42                	ld	s4,16(sp)
    8000638c:	6aa2                	ld	s5,8(sp)
    8000638e:	bf11                	j	800062a2 <ip_rx+0x38>
    release(&portList[uport].lock);
    80006390:	854a                	mv	a0,s2
    80006392:	00001097          	auipc	ra,0x1
    80006396:	dba080e7          	jalr	-582(ra) # 8000714c <release>
    return;
    8000639a:	7902                	ld	s2,32(sp)
    8000639c:	6a42                	ld	s4,16(sp)
    8000639e:	6aa2                	ld	s5,8(sp)
    800063a0:	b709                	j	800062a2 <ip_rx+0x38>

00000000800063a2 <arp_rx>:
// protocol is more complex.
//
void arp_rx(char *inbuf) {
  static int seen_arp = 0;

  if (seen_arp) {
    800063a2:	00006797          	auipc	a5,0x6
    800063a6:	2567a783          	lw	a5,598(a5) # 8000c5f8 <seen_arp.0>
    800063aa:	c391                	beqz	a5,800063ae <arp_rx+0xc>
    800063ac:	8082                	ret
void arp_rx(char *inbuf) {
    800063ae:	7179                	addi	sp,sp,-48
    800063b0:	f406                	sd	ra,40(sp)
    800063b2:	f022                	sd	s0,32(sp)
    800063b4:	ec26                	sd	s1,24(sp)
    800063b6:	e84a                	sd	s2,16(sp)
    800063b8:	e44e                	sd	s3,8(sp)
    800063ba:	e052                	sd	s4,0(sp)
    800063bc:	1800                	addi	s0,sp,48
    800063be:	892a                	mv	s2,a0
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    800063c0:	00003517          	auipc	a0,0x3
    800063c4:	3e050513          	addi	a0,a0,992 # 800097a0 <etext+0x7a0>
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	7a0080e7          	jalr	1952(ra) # 80006b68 <printf>
  seen_arp = 1;
    800063d0:	4785                	li	a5,1
    800063d2:	00006717          	auipc	a4,0x6
    800063d6:	22f72323          	sw	a5,550(a4) # 8000c5f8 <seen_arp.0>

  struct eth *ineth = (struct eth *)inbuf;
  struct arp *inarp = (struct arp *)(ineth + 1);

  char *buf = kalloc();
    800063da:	ffffa097          	auipc	ra,0xffffa
    800063de:	d40080e7          	jalr	-704(ra) # 8000011a <kalloc>
    800063e2:	84aa                	mv	s1,a0
  if (buf == 0) panic("send_arp_reply");
    800063e4:	c56d                	beqz	a0,800064ce <arp_rx+0x12c>

  struct eth *eth = (struct eth *)buf;
  memmove(eth->dhost, ineth->shost,
    800063e6:	00690993          	addi	s3,s2,6
    800063ea:	4619                	li	a2,6
    800063ec:	85ce                	mv	a1,s3
    800063ee:	ffffa097          	auipc	ra,0xffffa
    800063f2:	de8080e7          	jalr	-536(ra) # 800001d6 <memmove>
          ETHADDR_LEN);  // ethernet destination = query source
  memmove(eth->shost, local_mac,
    800063f6:	4619                	li	a2,6
    800063f8:	00006597          	auipc	a1,0x6
    800063fc:	16858593          	addi	a1,a1,360 # 8000c560 <local_mac>
    80006400:	00648513          	addi	a0,s1,6
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	dd2080e7          	jalr	-558(ra) # 800001d6 <memmove>
          ETHADDR_LEN);  // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);
    8000640c:	47a1                	li	a5,8
    8000640e:	00f48623          	sb	a5,12(s1)
    80006412:	4719                	li	a4,6
    80006414:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    80006418:	00048723          	sb	zero,14(s1)
    8000641c:	4705                	li	a4,1
    8000641e:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    80006422:	00f48823          	sb	a5,16(s1)
    80006426:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    8000642a:	4799                	li	a5,6
    8000642c:	00f48923          	sb	a5,18(s1)
  arp->pln = sizeof(uint32);
    80006430:	4791                	li	a5,4
    80006432:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    80006436:	00048a23          	sb	zero,20(s1)
    8000643a:	4a09                	li	s4,2
    8000643c:	01448aa3          	sb	s4,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80006440:	4619                	li	a2,6
    80006442:	00006597          	auipc	a1,0x6
    80006446:	11e58593          	addi	a1,a1,286 # 8000c560 <local_mac>
    8000644a:	01648513          	addi	a0,s1,22
    8000644e:	ffffa097          	auipc	ra,0xffffa
    80006452:	d88080e7          	jalr	-632(ra) # 800001d6 <memmove>
  arp->sip = htonl(local_ip);
    80006456:	47a9                	li	a5,10
    80006458:	00f48e23          	sb	a5,28(s1)
    8000645c:	00048ea3          	sb	zero,29(s1)
    80006460:	01448f23          	sb	s4,30(s1)
    80006464:	47bd                	li	a5,15
    80006466:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    8000646a:	4619                	li	a2,6
    8000646c:	85ce                	mv	a1,s3
    8000646e:	02048513          	addi	a0,s1,32
    80006472:	ffffa097          	auipc	ra,0xffffa
    80006476:	d64080e7          	jalr	-668(ra) # 800001d6 <memmove>
  arp->tip = inarp->sip;
    8000647a:	01c94703          	lbu	a4,28(s2)
    8000647e:	01d94783          	lbu	a5,29(s2)
    80006482:	07a2                	slli	a5,a5,0x8
    80006484:	8fd9                	or	a5,a5,a4
    80006486:	01e94703          	lbu	a4,30(s2)
    8000648a:	0742                	slli	a4,a4,0x10
    8000648c:	8f5d                	or	a4,a4,a5
    8000648e:	01f94783          	lbu	a5,31(s2)
    80006492:	07e2                	slli	a5,a5,0x18
    80006494:	8fd9                	or	a5,a5,a4
    80006496:	02f48323          	sb	a5,38(s1)
    8000649a:	0087d713          	srli	a4,a5,0x8
    8000649e:	02e483a3          	sb	a4,39(s1)
    800064a2:	0107d713          	srli	a4,a5,0x10
    800064a6:	02e48423          	sb	a4,40(s1)
    800064aa:	83e1                	srli	a5,a5,0x18
    800064ac:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    800064b0:	02a00593          	li	a1,42
    800064b4:	8526                	mv	a0,s1
    800064b6:	fffff097          	auipc	ra,0xfffff
    800064ba:	59a080e7          	jalr	1434(ra) # 80005a50 <e1000_transmit>
}
    800064be:	70a2                	ld	ra,40(sp)
    800064c0:	7402                	ld	s0,32(sp)
    800064c2:	64e2                	ld	s1,24(sp)
    800064c4:	6942                	ld	s2,16(sp)
    800064c6:	69a2                	ld	s3,8(sp)
    800064c8:	6a02                	ld	s4,0(sp)
    800064ca:	6145                	addi	sp,sp,48
    800064cc:	8082                	ret
  if (buf == 0) panic("send_arp_reply");
    800064ce:	00003517          	auipc	a0,0x3
    800064d2:	2f250513          	addi	a0,a0,754 # 800097c0 <etext+0x7c0>
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	648080e7          	jalr	1608(ra) # 80006b1e <panic>

00000000800064de <net_rx>:

void net_rx(char *buf, int len) {
    800064de:	1101                	addi	sp,sp,-32
    800064e0:	ec06                	sd	ra,24(sp)
    800064e2:	e822                	sd	s0,16(sp)
    800064e4:	e426                	sd	s1,8(sp)
    800064e6:	1000                	addi	s0,sp,32
    800064e8:	84aa                	mv	s1,a0
  struct eth *eth = (struct eth *)buf;

  if (len >= sizeof(struct eth) + sizeof(struct arp) &&
    800064ea:	0005879b          	sext.w	a5,a1
    800064ee:	02900713          	li	a4,41
    800064f2:	04f77063          	bgeu	a4,a5,80006532 <net_rx+0x54>
      ntohs(eth->type) == ETHTYPE_ARP) {
    800064f6:	00c54703          	lbu	a4,12(a0)
    800064fa:	00d54783          	lbu	a5,13(a0)
    800064fe:	07a2                	slli	a5,a5,0x8
  if (len >= sizeof(struct eth) + sizeof(struct arp) &&
    80006500:	8fd9                	or	a5,a5,a4
    80006502:	60800713          	li	a4,1544
    80006506:	02e78163          	beq	a5,a4,80006528 <net_rx+0x4a>
    arp_rx(buf);
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
             ntohs(eth->type) == ETHTYPE_IP) {
    8000650a:	00c4c703          	lbu	a4,12(s1)
    8000650e:	00d4c783          	lbu	a5,13(s1)
    80006512:	07a2                	slli	a5,a5,0x8
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
    80006514:	8fd9                	or	a5,a5,a4
    80006516:	4721                	li	a4,8
    80006518:	02e79163          	bne	a5,a4,8000653a <net_rx+0x5c>
    ip_rx(buf, len);
    8000651c:	8526                	mv	a0,s1
    8000651e:	00000097          	auipc	ra,0x0
    80006522:	d4c080e7          	jalr	-692(ra) # 8000626a <ip_rx>
    80006526:	a811                	j	8000653a <net_rx+0x5c>
    arp_rx(buf);
    80006528:	00000097          	auipc	ra,0x0
    8000652c:	e7a080e7          	jalr	-390(ra) # 800063a2 <arp_rx>
    80006530:	a029                	j	8000653a <net_rx+0x5c>
  } else if (len >= sizeof(struct eth) + sizeof(struct ip) &&
    80006532:	02100713          	li	a4,33
    80006536:	fcf76ae3          	bltu	a4,a5,8000650a <net_rx+0x2c>
  }
  kfree(buf);
    8000653a:	8526                	mv	a0,s1
    8000653c:	ffffa097          	auipc	ra,0xffffa
    80006540:	ae0080e7          	jalr	-1312(ra) # 8000001c <kfree>
}
    80006544:	60e2                	ld	ra,24(sp)
    80006546:	6442                	ld	s0,16(sp)
    80006548:	64a2                	ld	s1,8(sp)
    8000654a:	6105                	addi	sp,sp,32
    8000654c:	8082                	ret

000000008000654e <pci_init>:
#include "proc.h"
#include "riscv.h"
#include "spinlock.h"
#include "types.h"

void pci_init() {
    8000654e:	715d                	addi	sp,sp,-80
    80006550:	e486                	sd	ra,72(sp)
    80006552:	e0a2                	sd	s0,64(sp)
    80006554:	fc26                	sd	s1,56(sp)
    80006556:	f84a                	sd	s2,48(sp)
    80006558:	f44e                	sd	s3,40(sp)
    8000655a:	f052                	sd	s4,32(sp)
    8000655c:	ec56                	sd	s5,24(sp)
    8000655e:	e85a                	sd	s6,16(sp)
    80006560:	e45e                	sd	s7,8(sp)
    80006562:	0880                	addi	s0,sp,80
    80006564:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];

    // 100e:8086 is an e1000
    if (id == 0x100e8086) {
    80006568:	100e8937          	lui	s2,0x100e8
    8000656c:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006570:	4b9d                	li	s7,7
      for (int i = 0; i < 6; i++) {
        uint32 old = base[4 + i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4 + i] = 0xffffffff;
    80006572:	5afd                	li	s5,-1
        base[4 + i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4 + 0] = e1000_regs;
    80006574:	40000b37          	lui	s6,0x40000
  for (int dev = 0; dev < 32; dev++) {
    80006578:	6a09                	lui	s4,0x2
    8000657a:	300409b7          	lui	s3,0x30040
    8000657e:	a819                	j	80006594 <pci_init+0x46>
      base[4 + 0] = e1000_regs;
    80006580:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32 *)e1000_regs);
    80006584:	855a                	mv	a0,s6
    80006586:	fffff097          	auipc	ra,0xfffff
    8000658a:	332080e7          	jalr	818(ra) # 800058b8 <e1000_init>
  for (int dev = 0; dev < 32; dev++) {
    8000658e:	94d2                	add	s1,s1,s4
    80006590:	03348a63          	beq	s1,s3,800065c4 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006594:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80006596:	409c                	lw	a5,0(s1)
    80006598:	2781                	sext.w	a5,a5
    if (id == 0x100e8086) {
    8000659a:	ff279ae3          	bne	a5,s2,8000658e <pci_init+0x40>
      base[1] = 7;
    8000659e:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    800065a2:	0330000f          	fence	rw,rw
      for (int i = 0; i < 6; i++) {
    800065a6:	01048793          	addi	a5,s1,16
    800065aa:	02848613          	addi	a2,s1,40
        uint32 old = base[4 + i];
    800065ae:	4398                	lw	a4,0(a5)
    800065b0:	2701                	sext.w	a4,a4
        base[4 + i] = 0xffffffff;
    800065b2:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    800065b6:	0330000f          	fence	rw,rw
        base[4 + i] = old;
    800065ba:	c398                	sw	a4,0(a5)
      for (int i = 0; i < 6; i++) {
    800065bc:	0791                	addi	a5,a5,4
    800065be:	fec798e3          	bne	a5,a2,800065ae <pci_init+0x60>
    800065c2:	bf7d                	j	80006580 <pci_init+0x32>
    }
  }
}
    800065c4:	60a6                	ld	ra,72(sp)
    800065c6:	6406                	ld	s0,64(sp)
    800065c8:	74e2                	ld	s1,56(sp)
    800065ca:	7942                	ld	s2,48(sp)
    800065cc:	79a2                	ld	s3,40(sp)
    800065ce:	7a02                	ld	s4,32(sp)
    800065d0:	6ae2                	ld	s5,24(sp)
    800065d2:	6b42                	ld	s6,16(sp)
    800065d4:	6ba2                	ld	s7,8(sp)
    800065d6:	6161                	addi	sp,sp,80
    800065d8:	8082                	ret

00000000800065da <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    800065da:	1141                	addi	sp,sp,-16
    800065dc:	e422                	sd	s0,8(sp)
    800065de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800065e0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800065e4:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800065e8:	0037979b          	slliw	a5,a5,0x3
    800065ec:	02004737          	lui	a4,0x2004
    800065f0:	97ba                	add	a5,a5,a4
    800065f2:	0200c737          	lui	a4,0x200c
    800065f6:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800065f8:	6318                	ld	a4,0(a4)
    800065fa:	000f4637          	lui	a2,0xf4
    800065fe:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006602:	9732                	add	a4,a4,a2
    80006604:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80006606:	00259693          	slli	a3,a1,0x2
    8000660a:	96ae                	add	a3,a3,a1
    8000660c:	068e                	slli	a3,a3,0x3
    8000660e:	00067717          	auipc	a4,0x67
    80006612:	53270713          	addi	a4,a4,1330 # 8006db40 <timer_scratch>
    80006616:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80006618:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000661a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    8000661c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80006620:	fffff797          	auipc	a5,0xfffff
    80006624:	c2078793          	addi	a5,a5,-992 # 80005240 <timervec>
    80006628:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000662c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006630:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80006634:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80006638:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000663c:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80006640:	30479073          	csrw	mie,a5
}
    80006644:	6422                	ld	s0,8(sp)
    80006646:	0141                	addi	sp,sp,16
    80006648:	8082                	ret

000000008000664a <start>:
void start() {
    8000664a:	1141                	addi	sp,sp,-16
    8000664c:	e406                	sd	ra,8(sp)
    8000664e:	e022                	sd	s0,0(sp)
    80006650:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80006652:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006656:	7779                	lui	a4,0xffffe
    80006658:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff88a7f>
    8000665c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000665e:	6705                	lui	a4,0x1
    80006660:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006664:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80006666:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    8000666a:	ffffa797          	auipc	a5,0xffffa
    8000666e:	cae78793          	addi	a5,a5,-850 # 80000318 <main>
    80006672:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80006676:	4781                	li	a5,0
    80006678:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000667c:	67c1                	lui	a5,0x10
    8000667e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006680:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80006684:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80006688:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000668c:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80006690:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80006694:	57fd                	li	a5,-1
    80006696:	83a9                	srli	a5,a5,0xa
    80006698:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000669c:	47bd                	li	a5,15
    8000669e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800066a2:	00000097          	auipc	ra,0x0
    800066a6:	f38080e7          	jalr	-200(ra) # 800065da <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800066aa:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800066ae:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    800066b0:	823e                	mv	tp,a5
  asm volatile("mret");
    800066b2:	30200073          	mret
}
    800066b6:	60a2                	ld	ra,8(sp)
    800066b8:	6402                	ld	s0,0(sp)
    800066ba:	0141                	addi	sp,sp,16
    800066bc:	8082                	ret

00000000800066be <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    800066be:	715d                	addi	sp,sp,-80
    800066c0:	e486                	sd	ra,72(sp)
    800066c2:	e0a2                	sd	s0,64(sp)
    800066c4:	f84a                	sd	s2,48(sp)
    800066c6:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    800066c8:	04c05663          	blez	a2,80006714 <consolewrite+0x56>
    800066cc:	fc26                	sd	s1,56(sp)
    800066ce:	f44e                	sd	s3,40(sp)
    800066d0:	f052                	sd	s4,32(sp)
    800066d2:	ec56                	sd	s5,24(sp)
    800066d4:	8a2a                	mv	s4,a0
    800066d6:	84ae                	mv	s1,a1
    800066d8:	89b2                	mv	s3,a2
    800066da:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    800066dc:	5afd                	li	s5,-1
    800066de:	4685                	li	a3,1
    800066e0:	8626                	mv	a2,s1
    800066e2:	85d2                	mv	a1,s4
    800066e4:	fbf40513          	addi	a0,s0,-65
    800066e8:	ffffb097          	auipc	ra,0xffffb
    800066ec:	36a080e7          	jalr	874(ra) # 80001a52 <either_copyin>
    800066f0:	03550463          	beq	a0,s5,80006718 <consolewrite+0x5a>
    uartputc(c);
    800066f4:	fbf44503          	lbu	a0,-65(s0)
    800066f8:	00000097          	auipc	ra,0x0
    800066fc:	7e4080e7          	jalr	2020(ra) # 80006edc <uartputc>
  for (i = 0; i < n; i++) {
    80006700:	2905                	addiw	s2,s2,1
    80006702:	0485                	addi	s1,s1,1
    80006704:	fd299de3          	bne	s3,s2,800066de <consolewrite+0x20>
    80006708:	894e                	mv	s2,s3
    8000670a:	74e2                	ld	s1,56(sp)
    8000670c:	79a2                	ld	s3,40(sp)
    8000670e:	7a02                	ld	s4,32(sp)
    80006710:	6ae2                	ld	s5,24(sp)
    80006712:	a039                	j	80006720 <consolewrite+0x62>
    80006714:	4901                	li	s2,0
    80006716:	a029                	j	80006720 <consolewrite+0x62>
    80006718:	74e2                	ld	s1,56(sp)
    8000671a:	79a2                	ld	s3,40(sp)
    8000671c:	7a02                	ld	s4,32(sp)
    8000671e:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80006720:	854a                	mv	a0,s2
    80006722:	60a6                	ld	ra,72(sp)
    80006724:	6406                	ld	s0,64(sp)
    80006726:	7942                	ld	s2,48(sp)
    80006728:	6161                	addi	sp,sp,80
    8000672a:	8082                	ret

000000008000672c <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    8000672c:	711d                	addi	sp,sp,-96
    8000672e:	ec86                	sd	ra,88(sp)
    80006730:	e8a2                	sd	s0,80(sp)
    80006732:	e4a6                	sd	s1,72(sp)
    80006734:	e0ca                	sd	s2,64(sp)
    80006736:	fc4e                	sd	s3,56(sp)
    80006738:	f852                	sd	s4,48(sp)
    8000673a:	f456                	sd	s5,40(sp)
    8000673c:	f05a                	sd	s6,32(sp)
    8000673e:	1080                	addi	s0,sp,96
    80006740:	8aaa                	mv	s5,a0
    80006742:	8a2e                	mv	s4,a1
    80006744:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80006746:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000674a:	0006f517          	auipc	a0,0x6f
    8000674e:	53650513          	addi	a0,a0,1334 # 80075c80 <cons>
    80006752:	00001097          	auipc	ra,0x1
    80006756:	946080e7          	jalr	-1722(ra) # 80007098 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    8000675a:	0006f497          	auipc	s1,0x6f
    8000675e:	52648493          	addi	s1,s1,1318 # 80075c80 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80006762:	0006f917          	auipc	s2,0x6f
    80006766:	5b690913          	addi	s2,s2,1462 # 80075d18 <cons+0x98>
  while (n > 0) {
    8000676a:	0d305763          	blez	s3,80006838 <consoleread+0x10c>
    while (cons.r == cons.w) {
    8000676e:	0984a783          	lw	a5,152(s1)
    80006772:	09c4a703          	lw	a4,156(s1)
    80006776:	0af71c63          	bne	a4,a5,8000682e <consoleread+0x102>
      if (killed(myproc())) {
    8000677a:	ffffa097          	auipc	ra,0xffffa
    8000677e:	7cc080e7          	jalr	1996(ra) # 80000f46 <myproc>
    80006782:	ffffb097          	auipc	ra,0xffffb
    80006786:	11a080e7          	jalr	282(ra) # 8000189c <killed>
    8000678a:	e52d                	bnez	a0,800067f4 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    8000678c:	85a6                	mv	a1,s1
    8000678e:	854a                	mv	a0,s2
    80006790:	ffffb097          	auipc	ra,0xffffb
    80006794:	e64080e7          	jalr	-412(ra) # 800015f4 <sleep>
    while (cons.r == cons.w) {
    80006798:	0984a783          	lw	a5,152(s1)
    8000679c:	09c4a703          	lw	a4,156(s1)
    800067a0:	fcf70de3          	beq	a4,a5,8000677a <consoleread+0x4e>
    800067a4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800067a6:	0006f717          	auipc	a4,0x6f
    800067aa:	4da70713          	addi	a4,a4,1242 # 80075c80 <cons>
    800067ae:	0017869b          	addiw	a3,a5,1
    800067b2:	08d72c23          	sw	a3,152(a4)
    800067b6:	07f7f693          	andi	a3,a5,127
    800067ba:	9736                	add	a4,a4,a3
    800067bc:	01874703          	lbu	a4,24(a4)
    800067c0:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) {  // end-of-file
    800067c4:	4691                	li	a3,4
    800067c6:	04db8a63          	beq	s7,a3,8000681a <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800067ca:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    800067ce:	4685                	li	a3,1
    800067d0:	faf40613          	addi	a2,s0,-81
    800067d4:	85d2                	mv	a1,s4
    800067d6:	8556                	mv	a0,s5
    800067d8:	ffffb097          	auipc	ra,0xffffb
    800067dc:	224080e7          	jalr	548(ra) # 800019fc <either_copyout>
    800067e0:	57fd                	li	a5,-1
    800067e2:	04f50a63          	beq	a0,a5,80006836 <consoleread+0x10a>

    dst++;
    800067e6:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    800067e8:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if (c == '\n') {
    800067ea:	47a9                	li	a5,10
    800067ec:	06fb8163          	beq	s7,a5,8000684e <consoleread+0x122>
    800067f0:	6be2                	ld	s7,24(sp)
    800067f2:	bfa5                	j	8000676a <consoleread+0x3e>
        release(&cons.lock);
    800067f4:	0006f517          	auipc	a0,0x6f
    800067f8:	48c50513          	addi	a0,a0,1164 # 80075c80 <cons>
    800067fc:	00001097          	auipc	ra,0x1
    80006800:	950080e7          	jalr	-1712(ra) # 8000714c <release>
        return -1;
    80006804:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80006806:	60e6                	ld	ra,88(sp)
    80006808:	6446                	ld	s0,80(sp)
    8000680a:	64a6                	ld	s1,72(sp)
    8000680c:	6906                	ld	s2,64(sp)
    8000680e:	79e2                	ld	s3,56(sp)
    80006810:	7a42                	ld	s4,48(sp)
    80006812:	7aa2                	ld	s5,40(sp)
    80006814:	7b02                	ld	s6,32(sp)
    80006816:	6125                	addi	sp,sp,96
    80006818:	8082                	ret
      if (n < target) {
    8000681a:	0009871b          	sext.w	a4,s3
    8000681e:	01677a63          	bgeu	a4,s6,80006832 <consoleread+0x106>
        cons.r--;
    80006822:	0006f717          	auipc	a4,0x6f
    80006826:	4ef72b23          	sw	a5,1270(a4) # 80075d18 <cons+0x98>
    8000682a:	6be2                	ld	s7,24(sp)
    8000682c:	a031                	j	80006838 <consoleread+0x10c>
    8000682e:	ec5e                	sd	s7,24(sp)
    80006830:	bf9d                	j	800067a6 <consoleread+0x7a>
    80006832:	6be2                	ld	s7,24(sp)
    80006834:	a011                	j	80006838 <consoleread+0x10c>
    80006836:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80006838:	0006f517          	auipc	a0,0x6f
    8000683c:	44850513          	addi	a0,a0,1096 # 80075c80 <cons>
    80006840:	00001097          	auipc	ra,0x1
    80006844:	90c080e7          	jalr	-1780(ra) # 8000714c <release>
  return target - n;
    80006848:	413b053b          	subw	a0,s6,s3
    8000684c:	bf6d                	j	80006806 <consoleread+0xda>
    8000684e:	6be2                	ld	s7,24(sp)
    80006850:	b7e5                	j	80006838 <consoleread+0x10c>

0000000080006852 <consputc>:
void consputc(int c) {
    80006852:	1141                	addi	sp,sp,-16
    80006854:	e406                	sd	ra,8(sp)
    80006856:	e022                	sd	s0,0(sp)
    80006858:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    8000685a:	10000793          	li	a5,256
    8000685e:	00f50a63          	beq	a0,a5,80006872 <consputc+0x20>
    uartputc_sync(c);
    80006862:	00000097          	auipc	ra,0x0
    80006866:	59c080e7          	jalr	1436(ra) # 80006dfe <uartputc_sync>
}
    8000686a:	60a2                	ld	ra,8(sp)
    8000686c:	6402                	ld	s0,0(sp)
    8000686e:	0141                	addi	sp,sp,16
    80006870:	8082                	ret
    uartputc_sync('\b');
    80006872:	4521                	li	a0,8
    80006874:	00000097          	auipc	ra,0x0
    80006878:	58a080e7          	jalr	1418(ra) # 80006dfe <uartputc_sync>
    uartputc_sync(' ');
    8000687c:	02000513          	li	a0,32
    80006880:	00000097          	auipc	ra,0x0
    80006884:	57e080e7          	jalr	1406(ra) # 80006dfe <uartputc_sync>
    uartputc_sync('\b');
    80006888:	4521                	li	a0,8
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	574080e7          	jalr	1396(ra) # 80006dfe <uartputc_sync>
    80006892:	bfe1                	j	8000686a <consputc+0x18>

0000000080006894 <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80006894:	1101                	addi	sp,sp,-32
    80006896:	ec06                	sd	ra,24(sp)
    80006898:	e822                	sd	s0,16(sp)
    8000689a:	e426                	sd	s1,8(sp)
    8000689c:	1000                	addi	s0,sp,32
    8000689e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800068a0:	0006f517          	auipc	a0,0x6f
    800068a4:	3e050513          	addi	a0,a0,992 # 80075c80 <cons>
    800068a8:	00000097          	auipc	ra,0x0
    800068ac:	7f0080e7          	jalr	2032(ra) # 80007098 <acquire>

  switch (c) {
    800068b0:	47d5                	li	a5,21
    800068b2:	0af48563          	beq	s1,a5,8000695c <consoleintr+0xc8>
    800068b6:	0297c963          	blt	a5,s1,800068e8 <consoleintr+0x54>
    800068ba:	47a1                	li	a5,8
    800068bc:	0ef48c63          	beq	s1,a5,800069b4 <consoleintr+0x120>
    800068c0:	47c1                	li	a5,16
    800068c2:	10f49f63          	bne	s1,a5,800069e0 <consoleintr+0x14c>
    case C('P'):  // Print process list.
      procdump();
    800068c6:	ffffb097          	auipc	ra,0xffffb
    800068ca:	1e2080e7          	jalr	482(ra) # 80001aa8 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    800068ce:	0006f517          	auipc	a0,0x6f
    800068d2:	3b250513          	addi	a0,a0,946 # 80075c80 <cons>
    800068d6:	00001097          	auipc	ra,0x1
    800068da:	876080e7          	jalr	-1930(ra) # 8000714c <release>
}
    800068de:	60e2                	ld	ra,24(sp)
    800068e0:	6442                	ld	s0,16(sp)
    800068e2:	64a2                	ld	s1,8(sp)
    800068e4:	6105                	addi	sp,sp,32
    800068e6:	8082                	ret
  switch (c) {
    800068e8:	07f00793          	li	a5,127
    800068ec:	0cf48463          	beq	s1,a5,800069b4 <consoleintr+0x120>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800068f0:	0006f717          	auipc	a4,0x6f
    800068f4:	39070713          	addi	a4,a4,912 # 80075c80 <cons>
    800068f8:	0a072783          	lw	a5,160(a4)
    800068fc:	09872703          	lw	a4,152(a4)
    80006900:	9f99                	subw	a5,a5,a4
    80006902:	07f00713          	li	a4,127
    80006906:	fcf764e3          	bltu	a4,a5,800068ce <consoleintr+0x3a>
        c = (c == '\r') ? '\n' : c;
    8000690a:	47b5                	li	a5,13
    8000690c:	0cf48d63          	beq	s1,a5,800069e6 <consoleintr+0x152>
        consputc(c);
    80006910:	8526                	mv	a0,s1
    80006912:	00000097          	auipc	ra,0x0
    80006916:	f40080e7          	jalr	-192(ra) # 80006852 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000691a:	0006f797          	auipc	a5,0x6f
    8000691e:	36678793          	addi	a5,a5,870 # 80075c80 <cons>
    80006922:	0a07a683          	lw	a3,160(a5)
    80006926:	0016871b          	addiw	a4,a3,1
    8000692a:	0007061b          	sext.w	a2,a4
    8000692e:	0ae7a023          	sw	a4,160(a5)
    80006932:	07f6f693          	andi	a3,a3,127
    80006936:	97b6                	add	a5,a5,a3
    80006938:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    8000693c:	47a9                	li	a5,10
    8000693e:	0cf48b63          	beq	s1,a5,80006a14 <consoleintr+0x180>
    80006942:	4791                	li	a5,4
    80006944:	0cf48863          	beq	s1,a5,80006a14 <consoleintr+0x180>
    80006948:	0006f797          	auipc	a5,0x6f
    8000694c:	3d07a783          	lw	a5,976(a5) # 80075d18 <cons+0x98>
    80006950:	9f1d                	subw	a4,a4,a5
    80006952:	08000793          	li	a5,128
    80006956:	f6f71ce3          	bne	a4,a5,800068ce <consoleintr+0x3a>
    8000695a:	a86d                	j	80006a14 <consoleintr+0x180>
    8000695c:	e04a                	sd	s2,0(sp)
      while (cons.e != cons.w &&
    8000695e:	0006f717          	auipc	a4,0x6f
    80006962:	32270713          	addi	a4,a4,802 # 80075c80 <cons>
    80006966:	0a072783          	lw	a5,160(a4)
    8000696a:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000696e:	0006f497          	auipc	s1,0x6f
    80006972:	31248493          	addi	s1,s1,786 # 80075c80 <cons>
      while (cons.e != cons.w &&
    80006976:	4929                	li	s2,10
    80006978:	02f70a63          	beq	a4,a5,800069ac <consoleintr+0x118>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000697c:	37fd                	addiw	a5,a5,-1
    8000697e:	07f7f713          	andi	a4,a5,127
    80006982:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80006984:	01874703          	lbu	a4,24(a4)
    80006988:	03270463          	beq	a4,s2,800069b0 <consoleintr+0x11c>
        cons.e--;
    8000698c:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80006990:	10000513          	li	a0,256
    80006994:	00000097          	auipc	ra,0x0
    80006998:	ebe080e7          	jalr	-322(ra) # 80006852 <consputc>
      while (cons.e != cons.w &&
    8000699c:	0a04a783          	lw	a5,160(s1)
    800069a0:	09c4a703          	lw	a4,156(s1)
    800069a4:	fcf71ce3          	bne	a4,a5,8000697c <consoleintr+0xe8>
    800069a8:	6902                	ld	s2,0(sp)
    800069aa:	b715                	j	800068ce <consoleintr+0x3a>
    800069ac:	6902                	ld	s2,0(sp)
    800069ae:	b705                	j	800068ce <consoleintr+0x3a>
    800069b0:	6902                	ld	s2,0(sp)
    800069b2:	bf31                	j	800068ce <consoleintr+0x3a>
      if (cons.e != cons.w) {
    800069b4:	0006f717          	auipc	a4,0x6f
    800069b8:	2cc70713          	addi	a4,a4,716 # 80075c80 <cons>
    800069bc:	0a072783          	lw	a5,160(a4)
    800069c0:	09c72703          	lw	a4,156(a4)
    800069c4:	f0f705e3          	beq	a4,a5,800068ce <consoleintr+0x3a>
        cons.e--;
    800069c8:	37fd                	addiw	a5,a5,-1
    800069ca:	0006f717          	auipc	a4,0x6f
    800069ce:	34f72b23          	sw	a5,854(a4) # 80075d20 <cons+0xa0>
        consputc(BACKSPACE);
    800069d2:	10000513          	li	a0,256
    800069d6:	00000097          	auipc	ra,0x0
    800069da:	e7c080e7          	jalr	-388(ra) # 80006852 <consputc>
    800069de:	bdc5                	j	800068ce <consoleintr+0x3a>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800069e0:	ee0487e3          	beqz	s1,800068ce <consoleintr+0x3a>
    800069e4:	b731                	j	800068f0 <consoleintr+0x5c>
        consputc(c);
    800069e6:	4529                	li	a0,10
    800069e8:	00000097          	auipc	ra,0x0
    800069ec:	e6a080e7          	jalr	-406(ra) # 80006852 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800069f0:	0006f797          	auipc	a5,0x6f
    800069f4:	29078793          	addi	a5,a5,656 # 80075c80 <cons>
    800069f8:	0a07a703          	lw	a4,160(a5)
    800069fc:	0017069b          	addiw	a3,a4,1
    80006a00:	0006861b          	sext.w	a2,a3
    80006a04:	0ad7a023          	sw	a3,160(a5)
    80006a08:	07f77713          	andi	a4,a4,127
    80006a0c:	97ba                	add	a5,a5,a4
    80006a0e:	4729                	li	a4,10
    80006a10:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80006a14:	0006f797          	auipc	a5,0x6f
    80006a18:	30c7a423          	sw	a2,776(a5) # 80075d1c <cons+0x9c>
          wakeup(&cons.r);
    80006a1c:	0006f517          	auipc	a0,0x6f
    80006a20:	2fc50513          	addi	a0,a0,764 # 80075d18 <cons+0x98>
    80006a24:	ffffb097          	auipc	ra,0xffffb
    80006a28:	c34080e7          	jalr	-972(ra) # 80001658 <wakeup>
    80006a2c:	b54d                	j	800068ce <consoleintr+0x3a>

0000000080006a2e <consoleinit>:

void consoleinit(void) {
    80006a2e:	1141                	addi	sp,sp,-16
    80006a30:	e406                	sd	ra,8(sp)
    80006a32:	e022                	sd	s0,0(sp)
    80006a34:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006a36:	00003597          	auipc	a1,0x3
    80006a3a:	d9a58593          	addi	a1,a1,-614 # 800097d0 <etext+0x7d0>
    80006a3e:	0006f517          	auipc	a0,0x6f
    80006a42:	24250513          	addi	a0,a0,578 # 80075c80 <cons>
    80006a46:	00000097          	auipc	ra,0x0
    80006a4a:	5c2080e7          	jalr	1474(ra) # 80007008 <initlock>

  uartinit();
    80006a4e:	00000097          	auipc	ra,0x0
    80006a52:	354080e7          	jalr	852(ra) # 80006da2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006a56:	00016797          	auipc	a5,0x16
    80006a5a:	c6278793          	addi	a5,a5,-926 # 8001c6b8 <devsw>
    80006a5e:	00000717          	auipc	a4,0x0
    80006a62:	cce70713          	addi	a4,a4,-818 # 8000672c <consoleread>
    80006a66:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006a68:	00000717          	auipc	a4,0x0
    80006a6c:	c5670713          	addi	a4,a4,-938 # 800066be <consolewrite>
    80006a70:	ef98                	sd	a4,24(a5)
}
    80006a72:	60a2                	ld	ra,8(sp)
    80006a74:	6402                	ld	s0,0(sp)
    80006a76:	0141                	addi	sp,sp,16
    80006a78:	8082                	ret

0000000080006a7a <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80006a7a:	7179                	addi	sp,sp,-48
    80006a7c:	f406                	sd	ra,40(sp)
    80006a7e:	f022                	sd	s0,32(sp)
    80006a80:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80006a82:	c219                	beqz	a2,80006a88 <printint+0xe>
    80006a84:	08054963          	bltz	a0,80006b16 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006a88:	2501                	sext.w	a0,a0
    80006a8a:	4881                	li	a7,0
    80006a8c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006a90:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006a92:	2581                	sext.w	a1,a1
    80006a94:	00003617          	auipc	a2,0x3
    80006a98:	ebc60613          	addi	a2,a2,-324 # 80009950 <digits>
    80006a9c:	883a                	mv	a6,a4
    80006a9e:	2705                	addiw	a4,a4,1
    80006aa0:	02b577bb          	remuw	a5,a0,a1
    80006aa4:	1782                	slli	a5,a5,0x20
    80006aa6:	9381                	srli	a5,a5,0x20
    80006aa8:	97b2                	add	a5,a5,a2
    80006aaa:	0007c783          	lbu	a5,0(a5)
    80006aae:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80006ab2:	0005079b          	sext.w	a5,a0
    80006ab6:	02b5553b          	divuw	a0,a0,a1
    80006aba:	0685                	addi	a3,a3,1
    80006abc:	feb7f0e3          	bgeu	a5,a1,80006a9c <printint+0x22>

  if (sign) buf[i++] = '-';
    80006ac0:	00088c63          	beqz	a7,80006ad8 <printint+0x5e>
    80006ac4:	fe070793          	addi	a5,a4,-32
    80006ac8:	00878733          	add	a4,a5,s0
    80006acc:	02d00793          	li	a5,45
    80006ad0:	fef70823          	sb	a5,-16(a4)
    80006ad4:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80006ad8:	02e05b63          	blez	a4,80006b0e <printint+0x94>
    80006adc:	ec26                	sd	s1,24(sp)
    80006ade:	e84a                	sd	s2,16(sp)
    80006ae0:	fd040793          	addi	a5,s0,-48
    80006ae4:	00e784b3          	add	s1,a5,a4
    80006ae8:	fff78913          	addi	s2,a5,-1
    80006aec:	993a                	add	s2,s2,a4
    80006aee:	377d                	addiw	a4,a4,-1
    80006af0:	1702                	slli	a4,a4,0x20
    80006af2:	9301                	srli	a4,a4,0x20
    80006af4:	40e90933          	sub	s2,s2,a4
    80006af8:	fff4c503          	lbu	a0,-1(s1)
    80006afc:	00000097          	auipc	ra,0x0
    80006b00:	d56080e7          	jalr	-682(ra) # 80006852 <consputc>
    80006b04:	14fd                	addi	s1,s1,-1
    80006b06:	ff2499e3          	bne	s1,s2,80006af8 <printint+0x7e>
    80006b0a:	64e2                	ld	s1,24(sp)
    80006b0c:	6942                	ld	s2,16(sp)
}
    80006b0e:	70a2                	ld	ra,40(sp)
    80006b10:	7402                	ld	s0,32(sp)
    80006b12:	6145                	addi	sp,sp,48
    80006b14:	8082                	ret
    x = -xx;
    80006b16:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80006b1a:	4885                	li	a7,1
    x = -xx;
    80006b1c:	bf85                	j	80006a8c <printint+0x12>

0000000080006b1e <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80006b1e:	1101                	addi	sp,sp,-32
    80006b20:	ec06                	sd	ra,24(sp)
    80006b22:	e822                	sd	s0,16(sp)
    80006b24:	e426                	sd	s1,8(sp)
    80006b26:	1000                	addi	s0,sp,32
    80006b28:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006b2a:	0006f797          	auipc	a5,0x6f
    80006b2e:	2007ab23          	sw	zero,534(a5) # 80075d40 <pr+0x18>
  printf("panic: ");
    80006b32:	00003517          	auipc	a0,0x3
    80006b36:	ca650513          	addi	a0,a0,-858 # 800097d8 <etext+0x7d8>
    80006b3a:	00000097          	auipc	ra,0x0
    80006b3e:	02e080e7          	jalr	46(ra) # 80006b68 <printf>
  printf(s);
    80006b42:	8526                	mv	a0,s1
    80006b44:	00000097          	auipc	ra,0x0
    80006b48:	024080e7          	jalr	36(ra) # 80006b68 <printf>
  printf("\n");
    80006b4c:	00002517          	auipc	a0,0x2
    80006b50:	4cc50513          	addi	a0,a0,1228 # 80009018 <etext+0x18>
    80006b54:	00000097          	auipc	ra,0x0
    80006b58:	014080e7          	jalr	20(ra) # 80006b68 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80006b5c:	4785                	li	a5,1
    80006b5e:	00006717          	auipc	a4,0x6
    80006b62:	aaf72123          	sw	a5,-1374(a4) # 8000c600 <panicked>
  for (;;);
    80006b66:	a001                	j	80006b66 <panic+0x48>

0000000080006b68 <printf>:
void printf(char *fmt, ...) {
    80006b68:	7131                	addi	sp,sp,-192
    80006b6a:	fc86                	sd	ra,120(sp)
    80006b6c:	f8a2                	sd	s0,112(sp)
    80006b6e:	e8d2                	sd	s4,80(sp)
    80006b70:	f06a                	sd	s10,32(sp)
    80006b72:	0100                	addi	s0,sp,128
    80006b74:	8a2a                	mv	s4,a0
    80006b76:	e40c                	sd	a1,8(s0)
    80006b78:	e810                	sd	a2,16(s0)
    80006b7a:	ec14                	sd	a3,24(s0)
    80006b7c:	f018                	sd	a4,32(s0)
    80006b7e:	f41c                	sd	a5,40(s0)
    80006b80:	03043823          	sd	a6,48(s0)
    80006b84:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006b88:	0006fd17          	auipc	s10,0x6f
    80006b8c:	1b8d2d03          	lw	s10,440(s10) # 80075d40 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80006b90:	040d1463          	bnez	s10,80006bd8 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80006b94:	040a0b63          	beqz	s4,80006bea <printf+0x82>
  va_start(ap, fmt);
    80006b98:	00840793          	addi	a5,s0,8
    80006b9c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006ba0:	000a4503          	lbu	a0,0(s4)
    80006ba4:	18050b63          	beqz	a0,80006d3a <printf+0x1d2>
    80006ba8:	f4a6                	sd	s1,104(sp)
    80006baa:	f0ca                	sd	s2,96(sp)
    80006bac:	ecce                	sd	s3,88(sp)
    80006bae:	e4d6                	sd	s5,72(sp)
    80006bb0:	e0da                	sd	s6,64(sp)
    80006bb2:	fc5e                	sd	s7,56(sp)
    80006bb4:	f862                	sd	s8,48(sp)
    80006bb6:	f466                	sd	s9,40(sp)
    80006bb8:	ec6e                	sd	s11,24(sp)
    80006bba:	4981                	li	s3,0
    if (c != '%') {
    80006bbc:	02500b13          	li	s6,37
    switch (c) {
    80006bc0:	07000b93          	li	s7,112
  consputc('x');
    80006bc4:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006bc6:	00003a97          	auipc	s5,0x3
    80006bca:	d8aa8a93          	addi	s5,s5,-630 # 80009950 <digits>
    switch (c) {
    80006bce:	07300c13          	li	s8,115
    80006bd2:	06400d93          	li	s11,100
    80006bd6:	a0b1                	j	80006c22 <printf+0xba>
  if (locking) acquire(&pr.lock);
    80006bd8:	0006f517          	auipc	a0,0x6f
    80006bdc:	15050513          	addi	a0,a0,336 # 80075d28 <pr>
    80006be0:	00000097          	auipc	ra,0x0
    80006be4:	4b8080e7          	jalr	1208(ra) # 80007098 <acquire>
    80006be8:	b775                	j	80006b94 <printf+0x2c>
    80006bea:	f4a6                	sd	s1,104(sp)
    80006bec:	f0ca                	sd	s2,96(sp)
    80006bee:	ecce                	sd	s3,88(sp)
    80006bf0:	e4d6                	sd	s5,72(sp)
    80006bf2:	e0da                	sd	s6,64(sp)
    80006bf4:	fc5e                	sd	s7,56(sp)
    80006bf6:	f862                	sd	s8,48(sp)
    80006bf8:	f466                	sd	s9,40(sp)
    80006bfa:	ec6e                	sd	s11,24(sp)
  if (fmt == 0) panic("null fmt");
    80006bfc:	00003517          	auipc	a0,0x3
    80006c00:	bec50513          	addi	a0,a0,-1044 # 800097e8 <etext+0x7e8>
    80006c04:	00000097          	auipc	ra,0x0
    80006c08:	f1a080e7          	jalr	-230(ra) # 80006b1e <panic>
      consputc(c);
    80006c0c:	00000097          	auipc	ra,0x0
    80006c10:	c46080e7          	jalr	-954(ra) # 80006852 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006c14:	2985                	addiw	s3,s3,1
    80006c16:	013a07b3          	add	a5,s4,s3
    80006c1a:	0007c503          	lbu	a0,0(a5)
    80006c1e:	10050563          	beqz	a0,80006d28 <printf+0x1c0>
    if (c != '%') {
    80006c22:	ff6515e3          	bne	a0,s6,80006c0c <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006c26:	2985                	addiw	s3,s3,1
    80006c28:	013a07b3          	add	a5,s4,s3
    80006c2c:	0007c783          	lbu	a5,0(a5)
    80006c30:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006c34:	10078b63          	beqz	a5,80006d4a <printf+0x1e2>
    switch (c) {
    80006c38:	05778a63          	beq	a5,s7,80006c8c <printf+0x124>
    80006c3c:	02fbf663          	bgeu	s7,a5,80006c68 <printf+0x100>
    80006c40:	09878863          	beq	a5,s8,80006cd0 <printf+0x168>
    80006c44:	07800713          	li	a4,120
    80006c48:	0ce79563          	bne	a5,a4,80006d12 <printf+0x1aa>
        printint(va_arg(ap, int), 16, 1);
    80006c4c:	f8843783          	ld	a5,-120(s0)
    80006c50:	00878713          	addi	a4,a5,8
    80006c54:	f8e43423          	sd	a4,-120(s0)
    80006c58:	4605                	li	a2,1
    80006c5a:	85e6                	mv	a1,s9
    80006c5c:	4388                	lw	a0,0(a5)
    80006c5e:	00000097          	auipc	ra,0x0
    80006c62:	e1c080e7          	jalr	-484(ra) # 80006a7a <printint>
        break;
    80006c66:	b77d                	j	80006c14 <printf+0xac>
    switch (c) {
    80006c68:	09678f63          	beq	a5,s6,80006d06 <printf+0x19e>
    80006c6c:	0bb79363          	bne	a5,s11,80006d12 <printf+0x1aa>
        printint(va_arg(ap, int), 10, 1);
    80006c70:	f8843783          	ld	a5,-120(s0)
    80006c74:	00878713          	addi	a4,a5,8
    80006c78:	f8e43423          	sd	a4,-120(s0)
    80006c7c:	4605                	li	a2,1
    80006c7e:	45a9                	li	a1,10
    80006c80:	4388                	lw	a0,0(a5)
    80006c82:	00000097          	auipc	ra,0x0
    80006c86:	df8080e7          	jalr	-520(ra) # 80006a7a <printint>
        break;
    80006c8a:	b769                	j	80006c14 <printf+0xac>
        printptr(va_arg(ap, uint64));
    80006c8c:	f8843783          	ld	a5,-120(s0)
    80006c90:	00878713          	addi	a4,a5,8
    80006c94:	f8e43423          	sd	a4,-120(s0)
    80006c98:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006c9c:	03000513          	li	a0,48
    80006ca0:	00000097          	auipc	ra,0x0
    80006ca4:	bb2080e7          	jalr	-1102(ra) # 80006852 <consputc>
  consputc('x');
    80006ca8:	07800513          	li	a0,120
    80006cac:	00000097          	auipc	ra,0x0
    80006cb0:	ba6080e7          	jalr	-1114(ra) # 80006852 <consputc>
    80006cb4:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006cb6:	03c95793          	srli	a5,s2,0x3c
    80006cba:	97d6                	add	a5,a5,s5
    80006cbc:	0007c503          	lbu	a0,0(a5)
    80006cc0:	00000097          	auipc	ra,0x0
    80006cc4:	b92080e7          	jalr	-1134(ra) # 80006852 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006cc8:	0912                	slli	s2,s2,0x4
    80006cca:	34fd                	addiw	s1,s1,-1
    80006ccc:	f4ed                	bnez	s1,80006cb6 <printf+0x14e>
    80006cce:	b799                	j	80006c14 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006cd0:	f8843783          	ld	a5,-120(s0)
    80006cd4:	00878713          	addi	a4,a5,8
    80006cd8:	f8e43423          	sd	a4,-120(s0)
    80006cdc:	6384                	ld	s1,0(a5)
    80006cde:	cc89                	beqz	s1,80006cf8 <printf+0x190>
        for (; *s; s++) consputc(*s);
    80006ce0:	0004c503          	lbu	a0,0(s1)
    80006ce4:	d905                	beqz	a0,80006c14 <printf+0xac>
    80006ce6:	00000097          	auipc	ra,0x0
    80006cea:	b6c080e7          	jalr	-1172(ra) # 80006852 <consputc>
    80006cee:	0485                	addi	s1,s1,1
    80006cf0:	0004c503          	lbu	a0,0(s1)
    80006cf4:	f96d                	bnez	a0,80006ce6 <printf+0x17e>
    80006cf6:	bf39                	j	80006c14 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006cf8:	00003497          	auipc	s1,0x3
    80006cfc:	ae848493          	addi	s1,s1,-1304 # 800097e0 <etext+0x7e0>
        for (; *s; s++) consputc(*s);
    80006d00:	02800513          	li	a0,40
    80006d04:	b7cd                	j	80006ce6 <printf+0x17e>
        consputc('%');
    80006d06:	855a                	mv	a0,s6
    80006d08:	00000097          	auipc	ra,0x0
    80006d0c:	b4a080e7          	jalr	-1206(ra) # 80006852 <consputc>
        break;
    80006d10:	b711                	j	80006c14 <printf+0xac>
        consputc('%');
    80006d12:	855a                	mv	a0,s6
    80006d14:	00000097          	auipc	ra,0x0
    80006d18:	b3e080e7          	jalr	-1218(ra) # 80006852 <consputc>
        consputc(c);
    80006d1c:	8526                	mv	a0,s1
    80006d1e:	00000097          	auipc	ra,0x0
    80006d22:	b34080e7          	jalr	-1228(ra) # 80006852 <consputc>
        break;
    80006d26:	b5fd                	j	80006c14 <printf+0xac>
    80006d28:	74a6                	ld	s1,104(sp)
    80006d2a:	7906                	ld	s2,96(sp)
    80006d2c:	69e6                	ld	s3,88(sp)
    80006d2e:	6aa6                	ld	s5,72(sp)
    80006d30:	6b06                	ld	s6,64(sp)
    80006d32:	7be2                	ld	s7,56(sp)
    80006d34:	7c42                	ld	s8,48(sp)
    80006d36:	7ca2                	ld	s9,40(sp)
    80006d38:	6de2                	ld	s11,24(sp)
  if (locking) release(&pr.lock);
    80006d3a:	020d1263          	bnez	s10,80006d5e <printf+0x1f6>
}
    80006d3e:	70e6                	ld	ra,120(sp)
    80006d40:	7446                	ld	s0,112(sp)
    80006d42:	6a46                	ld	s4,80(sp)
    80006d44:	7d02                	ld	s10,32(sp)
    80006d46:	6129                	addi	sp,sp,192
    80006d48:	8082                	ret
    80006d4a:	74a6                	ld	s1,104(sp)
    80006d4c:	7906                	ld	s2,96(sp)
    80006d4e:	69e6                	ld	s3,88(sp)
    80006d50:	6aa6                	ld	s5,72(sp)
    80006d52:	6b06                	ld	s6,64(sp)
    80006d54:	7be2                	ld	s7,56(sp)
    80006d56:	7c42                	ld	s8,48(sp)
    80006d58:	7ca2                	ld	s9,40(sp)
    80006d5a:	6de2                	ld	s11,24(sp)
    80006d5c:	bff9                	j	80006d3a <printf+0x1d2>
  if (locking) release(&pr.lock);
    80006d5e:	0006f517          	auipc	a0,0x6f
    80006d62:	fca50513          	addi	a0,a0,-54 # 80075d28 <pr>
    80006d66:	00000097          	auipc	ra,0x0
    80006d6a:	3e6080e7          	jalr	998(ra) # 8000714c <release>
}
    80006d6e:	bfc1                	j	80006d3e <printf+0x1d6>

0000000080006d70 <printfinit>:
}

void printfinit(void) {
    80006d70:	1101                	addi	sp,sp,-32
    80006d72:	ec06                	sd	ra,24(sp)
    80006d74:	e822                	sd	s0,16(sp)
    80006d76:	e426                	sd	s1,8(sp)
    80006d78:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006d7a:	0006f497          	auipc	s1,0x6f
    80006d7e:	fae48493          	addi	s1,s1,-82 # 80075d28 <pr>
    80006d82:	00003597          	auipc	a1,0x3
    80006d86:	a7658593          	addi	a1,a1,-1418 # 800097f8 <etext+0x7f8>
    80006d8a:	8526                	mv	a0,s1
    80006d8c:	00000097          	auipc	ra,0x0
    80006d90:	27c080e7          	jalr	636(ra) # 80007008 <initlock>
  pr.locking = 1;
    80006d94:	4785                	li	a5,1
    80006d96:	cc9c                	sw	a5,24(s1)
}
    80006d98:	60e2                	ld	ra,24(sp)
    80006d9a:	6442                	ld	s0,16(sp)
    80006d9c:	64a2                	ld	s1,8(sp)
    80006d9e:	6105                	addi	sp,sp,32
    80006da0:	8082                	ret

0000000080006da2 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006da2:	1141                	addi	sp,sp,-16
    80006da4:	e406                	sd	ra,8(sp)
    80006da6:	e022                	sd	s0,0(sp)
    80006da8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006daa:	100007b7          	lui	a5,0x10000
    80006dae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006db2:	10000737          	lui	a4,0x10000
    80006db6:	f8000693          	li	a3,-128
    80006dba:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006dbe:	468d                	li	a3,3
    80006dc0:	10000637          	lui	a2,0x10000
    80006dc4:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006dc8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006dcc:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006dd0:	10000737          	lui	a4,0x10000
    80006dd4:	461d                	li	a2,7
    80006dd6:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006dda:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006dde:	00003597          	auipc	a1,0x3
    80006de2:	a2258593          	addi	a1,a1,-1502 # 80009800 <etext+0x800>
    80006de6:	0006f517          	auipc	a0,0x6f
    80006dea:	f6250513          	addi	a0,a0,-158 # 80075d48 <uart_tx_lock>
    80006dee:	00000097          	auipc	ra,0x0
    80006df2:	21a080e7          	jalr	538(ra) # 80007008 <initlock>
}
    80006df6:	60a2                	ld	ra,8(sp)
    80006df8:	6402                	ld	s0,0(sp)
    80006dfa:	0141                	addi	sp,sp,16
    80006dfc:	8082                	ret

0000000080006dfe <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006dfe:	1101                	addi	sp,sp,-32
    80006e00:	ec06                	sd	ra,24(sp)
    80006e02:	e822                	sd	s0,16(sp)
    80006e04:	e426                	sd	s1,8(sp)
    80006e06:	1000                	addi	s0,sp,32
    80006e08:	84aa                	mv	s1,a0
  push_off();
    80006e0a:	00000097          	auipc	ra,0x0
    80006e0e:	242080e7          	jalr	578(ra) # 8000704c <push_off>

  if (panicked) {
    80006e12:	00005797          	auipc	a5,0x5
    80006e16:	7ee7a783          	lw	a5,2030(a5) # 8000c600 <panicked>
    80006e1a:	eb85                	bnez	a5,80006e4a <uartputc_sync+0x4c>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006e1c:	10000737          	lui	a4,0x10000
    80006e20:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006e22:	00074783          	lbu	a5,0(a4)
    80006e26:	0207f793          	andi	a5,a5,32
    80006e2a:	dfe5                	beqz	a5,80006e22 <uartputc_sync+0x24>
  WriteReg(THR, c);
    80006e2c:	0ff4f513          	zext.b	a0,s1
    80006e30:	100007b7          	lui	a5,0x10000
    80006e34:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006e38:	00000097          	auipc	ra,0x0
    80006e3c:	2b4080e7          	jalr	692(ra) # 800070ec <pop_off>
}
    80006e40:	60e2                	ld	ra,24(sp)
    80006e42:	6442                	ld	s0,16(sp)
    80006e44:	64a2                	ld	s1,8(sp)
    80006e46:	6105                	addi	sp,sp,32
    80006e48:	8082                	ret
    for (;;);
    80006e4a:	a001                	j	80006e4a <uartputc_sync+0x4c>

0000000080006e4c <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80006e4c:	00005797          	auipc	a5,0x5
    80006e50:	7bc7b783          	ld	a5,1980(a5) # 8000c608 <uart_tx_r>
    80006e54:	00005717          	auipc	a4,0x5
    80006e58:	7bc73703          	ld	a4,1980(a4) # 8000c610 <uart_tx_w>
    80006e5c:	06f70f63          	beq	a4,a5,80006eda <uartstart+0x8e>
void uartstart() {
    80006e60:	7139                	addi	sp,sp,-64
    80006e62:	fc06                	sd	ra,56(sp)
    80006e64:	f822                	sd	s0,48(sp)
    80006e66:	f426                	sd	s1,40(sp)
    80006e68:	f04a                	sd	s2,32(sp)
    80006e6a:	ec4e                	sd	s3,24(sp)
    80006e6c:	e852                	sd	s4,16(sp)
    80006e6e:	e456                	sd	s5,8(sp)
    80006e70:	e05a                	sd	s6,0(sp)
    80006e72:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006e74:	10000937          	lui	s2,0x10000
    80006e78:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006e7a:	0006fa97          	auipc	s5,0x6f
    80006e7e:	ecea8a93          	addi	s5,s5,-306 # 80075d48 <uart_tx_lock>
    uart_tx_r += 1;
    80006e82:	00005497          	auipc	s1,0x5
    80006e86:	78648493          	addi	s1,s1,1926 # 8000c608 <uart_tx_r>

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);

    WriteReg(THR, c);
    80006e8a:	10000a37          	lui	s4,0x10000
    if (uart_tx_w == uart_tx_r) {
    80006e8e:	00005997          	auipc	s3,0x5
    80006e92:	78298993          	addi	s3,s3,1922 # 8000c610 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006e96:	00094703          	lbu	a4,0(s2)
    80006e9a:	02077713          	andi	a4,a4,32
    80006e9e:	c705                	beqz	a4,80006ec6 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006ea0:	01f7f713          	andi	a4,a5,31
    80006ea4:	9756                	add	a4,a4,s5
    80006ea6:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006eaa:	0785                	addi	a5,a5,1
    80006eac:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006eae:	8526                	mv	a0,s1
    80006eb0:	ffffa097          	auipc	ra,0xffffa
    80006eb4:	7a8080e7          	jalr	1960(ra) # 80001658 <wakeup>
    WriteReg(THR, c);
    80006eb8:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if (uart_tx_w == uart_tx_r) {
    80006ebc:	609c                	ld	a5,0(s1)
    80006ebe:	0009b703          	ld	a4,0(s3)
    80006ec2:	fcf71ae3          	bne	a4,a5,80006e96 <uartstart+0x4a>
  }
}
    80006ec6:	70e2                	ld	ra,56(sp)
    80006ec8:	7442                	ld	s0,48(sp)
    80006eca:	74a2                	ld	s1,40(sp)
    80006ecc:	7902                	ld	s2,32(sp)
    80006ece:	69e2                	ld	s3,24(sp)
    80006ed0:	6a42                	ld	s4,16(sp)
    80006ed2:	6aa2                	ld	s5,8(sp)
    80006ed4:	6b02                	ld	s6,0(sp)
    80006ed6:	6121                	addi	sp,sp,64
    80006ed8:	8082                	ret
    80006eda:	8082                	ret

0000000080006edc <uartputc>:
void uartputc(int c) {
    80006edc:	7179                	addi	sp,sp,-48
    80006ede:	f406                	sd	ra,40(sp)
    80006ee0:	f022                	sd	s0,32(sp)
    80006ee2:	ec26                	sd	s1,24(sp)
    80006ee4:	e84a                	sd	s2,16(sp)
    80006ee6:	e44e                	sd	s3,8(sp)
    80006ee8:	e052                	sd	s4,0(sp)
    80006eea:	1800                	addi	s0,sp,48
    80006eec:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006eee:	0006f517          	auipc	a0,0x6f
    80006ef2:	e5a50513          	addi	a0,a0,-422 # 80075d48 <uart_tx_lock>
    80006ef6:	00000097          	auipc	ra,0x0
    80006efa:	1a2080e7          	jalr	418(ra) # 80007098 <acquire>
  if (panicked) {
    80006efe:	00005797          	auipc	a5,0x5
    80006f02:	7027a783          	lw	a5,1794(a5) # 8000c600 <panicked>
    80006f06:	e7c9                	bnez	a5,80006f90 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006f08:	00005717          	auipc	a4,0x5
    80006f0c:	70873703          	ld	a4,1800(a4) # 8000c610 <uart_tx_w>
    80006f10:	00005797          	auipc	a5,0x5
    80006f14:	6f87b783          	ld	a5,1784(a5) # 8000c608 <uart_tx_r>
    80006f18:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006f1c:	0006f997          	auipc	s3,0x6f
    80006f20:	e2c98993          	addi	s3,s3,-468 # 80075d48 <uart_tx_lock>
    80006f24:	00005497          	auipc	s1,0x5
    80006f28:	6e448493          	addi	s1,s1,1764 # 8000c608 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006f2c:	00005917          	auipc	s2,0x5
    80006f30:	6e490913          	addi	s2,s2,1764 # 8000c610 <uart_tx_w>
    80006f34:	00e79f63          	bne	a5,a4,80006f52 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006f38:	85ce                	mv	a1,s3
    80006f3a:	8526                	mv	a0,s1
    80006f3c:	ffffa097          	auipc	ra,0xffffa
    80006f40:	6b8080e7          	jalr	1720(ra) # 800015f4 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006f44:	00093703          	ld	a4,0(s2)
    80006f48:	609c                	ld	a5,0(s1)
    80006f4a:	02078793          	addi	a5,a5,32
    80006f4e:	fee785e3          	beq	a5,a4,80006f38 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006f52:	0006f497          	auipc	s1,0x6f
    80006f56:	df648493          	addi	s1,s1,-522 # 80075d48 <uart_tx_lock>
    80006f5a:	01f77793          	andi	a5,a4,31
    80006f5e:	97a6                	add	a5,a5,s1
    80006f60:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006f64:	0705                	addi	a4,a4,1
    80006f66:	00005797          	auipc	a5,0x5
    80006f6a:	6ae7b523          	sd	a4,1706(a5) # 8000c610 <uart_tx_w>
  uartstart();
    80006f6e:	00000097          	auipc	ra,0x0
    80006f72:	ede080e7          	jalr	-290(ra) # 80006e4c <uartstart>
  release(&uart_tx_lock);
    80006f76:	8526                	mv	a0,s1
    80006f78:	00000097          	auipc	ra,0x0
    80006f7c:	1d4080e7          	jalr	468(ra) # 8000714c <release>
}
    80006f80:	70a2                	ld	ra,40(sp)
    80006f82:	7402                	ld	s0,32(sp)
    80006f84:	64e2                	ld	s1,24(sp)
    80006f86:	6942                	ld	s2,16(sp)
    80006f88:	69a2                	ld	s3,8(sp)
    80006f8a:	6a02                	ld	s4,0(sp)
    80006f8c:	6145                	addi	sp,sp,48
    80006f8e:	8082                	ret
    for (;;);
    80006f90:	a001                	j	80006f90 <uartputc+0xb4>

0000000080006f92 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006f92:	1141                	addi	sp,sp,-16
    80006f94:	e422                	sd	s0,8(sp)
    80006f96:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006f98:	100007b7          	lui	a5,0x10000
    80006f9c:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006f9e:	0007c783          	lbu	a5,0(a5)
    80006fa2:	8b85                	andi	a5,a5,1
    80006fa4:	cb81                	beqz	a5,80006fb4 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006fa6:	100007b7          	lui	a5,0x10000
    80006faa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006fae:	6422                	ld	s0,8(sp)
    80006fb0:	0141                	addi	sp,sp,16
    80006fb2:	8082                	ret
    return -1;
    80006fb4:	557d                	li	a0,-1
    80006fb6:	bfe5                	j	80006fae <uartgetc+0x1c>

0000000080006fb8 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006fb8:	1101                	addi	sp,sp,-32
    80006fba:	ec06                	sd	ra,24(sp)
    80006fbc:	e822                	sd	s0,16(sp)
    80006fbe:	e426                	sd	s1,8(sp)
    80006fc0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006fc2:	54fd                	li	s1,-1
    80006fc4:	a029                	j	80006fce <uartintr+0x16>
    consoleintr(c);
    80006fc6:	00000097          	auipc	ra,0x0
    80006fca:	8ce080e7          	jalr	-1842(ra) # 80006894 <consoleintr>
    int c = uartgetc();
    80006fce:	00000097          	auipc	ra,0x0
    80006fd2:	fc4080e7          	jalr	-60(ra) # 80006f92 <uartgetc>
    if (c == -1) break;
    80006fd6:	fe9518e3          	bne	a0,s1,80006fc6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006fda:	0006f497          	auipc	s1,0x6f
    80006fde:	d6e48493          	addi	s1,s1,-658 # 80075d48 <uart_tx_lock>
    80006fe2:	8526                	mv	a0,s1
    80006fe4:	00000097          	auipc	ra,0x0
    80006fe8:	0b4080e7          	jalr	180(ra) # 80007098 <acquire>
  uartstart();
    80006fec:	00000097          	auipc	ra,0x0
    80006ff0:	e60080e7          	jalr	-416(ra) # 80006e4c <uartstart>
  release(&uart_tx_lock);
    80006ff4:	8526                	mv	a0,s1
    80006ff6:	00000097          	auipc	ra,0x0
    80006ffa:	156080e7          	jalr	342(ra) # 8000714c <release>
}
    80006ffe:	60e2                	ld	ra,24(sp)
    80007000:	6442                	ld	s0,16(sp)
    80007002:	64a2                	ld	s1,8(sp)
    80007004:	6105                	addi	sp,sp,32
    80007006:	8082                	ret

0000000080007008 <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    80007008:	1141                	addi	sp,sp,-16
    8000700a:	e422                	sd	s0,8(sp)
    8000700c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000700e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80007010:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80007014:	00053823          	sd	zero,16(a0)
}
    80007018:	6422                	ld	s0,8(sp)
    8000701a:	0141                	addi	sp,sp,16
    8000701c:	8082                	ret

000000008000701e <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000701e:	411c                	lw	a5,0(a0)
    80007020:	e399                	bnez	a5,80007026 <holding+0x8>
    80007022:	4501                	li	a0,0
  return r;
}
    80007024:	8082                	ret
int holding(struct spinlock *lk) {
    80007026:	1101                	addi	sp,sp,-32
    80007028:	ec06                	sd	ra,24(sp)
    8000702a:	e822                	sd	s0,16(sp)
    8000702c:	e426                	sd	s1,8(sp)
    8000702e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80007030:	6904                	ld	s1,16(a0)
    80007032:	ffffa097          	auipc	ra,0xffffa
    80007036:	ef8080e7          	jalr	-264(ra) # 80000f2a <mycpu>
    8000703a:	40a48533          	sub	a0,s1,a0
    8000703e:	00153513          	seqz	a0,a0
}
    80007042:	60e2                	ld	ra,24(sp)
    80007044:	6442                	ld	s0,16(sp)
    80007046:	64a2                	ld	s1,8(sp)
    80007048:	6105                	addi	sp,sp,32
    8000704a:	8082                	ret

000000008000704c <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    8000704c:	1101                	addi	sp,sp,-32
    8000704e:	ec06                	sd	ra,24(sp)
    80007050:	e822                	sd	s0,16(sp)
    80007052:	e426                	sd	s1,8(sp)
    80007054:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80007056:	100024f3          	csrr	s1,sstatus
    8000705a:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    8000705e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80007060:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80007064:	ffffa097          	auipc	ra,0xffffa
    80007068:	ec6080e7          	jalr	-314(ra) # 80000f2a <mycpu>
    8000706c:	5d3c                	lw	a5,120(a0)
    8000706e:	cf89                	beqz	a5,80007088 <push_off+0x3c>
  mycpu()->noff += 1;
    80007070:	ffffa097          	auipc	ra,0xffffa
    80007074:	eba080e7          	jalr	-326(ra) # 80000f2a <mycpu>
    80007078:	5d3c                	lw	a5,120(a0)
    8000707a:	2785                	addiw	a5,a5,1
    8000707c:	dd3c                	sw	a5,120(a0)
}
    8000707e:	60e2                	ld	ra,24(sp)
    80007080:	6442                	ld	s0,16(sp)
    80007082:	64a2                	ld	s1,8(sp)
    80007084:	6105                	addi	sp,sp,32
    80007086:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80007088:	ffffa097          	auipc	ra,0xffffa
    8000708c:	ea2080e7          	jalr	-350(ra) # 80000f2a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80007090:	8085                	srli	s1,s1,0x1
    80007092:	8885                	andi	s1,s1,1
    80007094:	dd64                	sw	s1,124(a0)
    80007096:	bfe9                	j	80007070 <push_off+0x24>

0000000080007098 <acquire>:
void acquire(struct spinlock *lk) {
    80007098:	1101                	addi	sp,sp,-32
    8000709a:	ec06                	sd	ra,24(sp)
    8000709c:	e822                	sd	s0,16(sp)
    8000709e:	e426                	sd	s1,8(sp)
    800070a0:	1000                	addi	s0,sp,32
    800070a2:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    800070a4:	00000097          	auipc	ra,0x0
    800070a8:	fa8080e7          	jalr	-88(ra) # 8000704c <push_off>
  if (holding(lk)) panic("acquire");
    800070ac:	8526                	mv	a0,s1
    800070ae:	00000097          	auipc	ra,0x0
    800070b2:	f70080e7          	jalr	-144(ra) # 8000701e <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800070b6:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    800070b8:	e115                	bnez	a0,800070dc <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800070ba:	87ba                	mv	a5,a4
    800070bc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800070c0:	2781                	sext.w	a5,a5
    800070c2:	ffe5                	bnez	a5,800070ba <acquire+0x22>
  __sync_synchronize();
    800070c4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800070c8:	ffffa097          	auipc	ra,0xffffa
    800070cc:	e62080e7          	jalr	-414(ra) # 80000f2a <mycpu>
    800070d0:	e888                	sd	a0,16(s1)
}
    800070d2:	60e2                	ld	ra,24(sp)
    800070d4:	6442                	ld	s0,16(sp)
    800070d6:	64a2                	ld	s1,8(sp)
    800070d8:	6105                	addi	sp,sp,32
    800070da:	8082                	ret
  if (holding(lk)) panic("acquire");
    800070dc:	00002517          	auipc	a0,0x2
    800070e0:	72c50513          	addi	a0,a0,1836 # 80009808 <etext+0x808>
    800070e4:	00000097          	auipc	ra,0x0
    800070e8:	a3a080e7          	jalr	-1478(ra) # 80006b1e <panic>

00000000800070ec <pop_off>:

void pop_off(void) {
    800070ec:	1141                	addi	sp,sp,-16
    800070ee:	e406                	sd	ra,8(sp)
    800070f0:	e022                	sd	s0,0(sp)
    800070f2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800070f4:	ffffa097          	auipc	ra,0xffffa
    800070f8:	e36080e7          	jalr	-458(ra) # 80000f2a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800070fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80007100:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80007102:	e78d                	bnez	a5,8000712c <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80007104:	5d3c                	lw	a5,120(a0)
    80007106:	02f05b63          	blez	a5,8000713c <pop_off+0x50>
  c->noff -= 1;
    8000710a:	37fd                	addiw	a5,a5,-1
    8000710c:	0007871b          	sext.w	a4,a5
    80007110:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    80007112:	eb09                	bnez	a4,80007124 <pop_off+0x38>
    80007114:	5d7c                	lw	a5,124(a0)
    80007116:	c799                	beqz	a5,80007124 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80007118:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000711c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80007120:	10079073          	csrw	sstatus,a5
}
    80007124:	60a2                	ld	ra,8(sp)
    80007126:	6402                	ld	s0,0(sp)
    80007128:	0141                	addi	sp,sp,16
    8000712a:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    8000712c:	00002517          	auipc	a0,0x2
    80007130:	6e450513          	addi	a0,a0,1764 # 80009810 <etext+0x810>
    80007134:	00000097          	auipc	ra,0x0
    80007138:	9ea080e7          	jalr	-1558(ra) # 80006b1e <panic>
  if (c->noff < 1) panic("pop_off");
    8000713c:	00002517          	auipc	a0,0x2
    80007140:	6ec50513          	addi	a0,a0,1772 # 80009828 <etext+0x828>
    80007144:	00000097          	auipc	ra,0x0
    80007148:	9da080e7          	jalr	-1574(ra) # 80006b1e <panic>

000000008000714c <release>:
void release(struct spinlock *lk) {
    8000714c:	1101                	addi	sp,sp,-32
    8000714e:	ec06                	sd	ra,24(sp)
    80007150:	e822                	sd	s0,16(sp)
    80007152:	e426                	sd	s1,8(sp)
    80007154:	1000                	addi	s0,sp,32
    80007156:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    80007158:	00000097          	auipc	ra,0x0
    8000715c:	ec6080e7          	jalr	-314(ra) # 8000701e <holding>
    80007160:	c115                	beqz	a0,80007184 <release+0x38>
  lk->cpu = 0;
    80007162:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80007166:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000716a:	0310000f          	fence	rw,w
    8000716e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80007172:	00000097          	auipc	ra,0x0
    80007176:	f7a080e7          	jalr	-134(ra) # 800070ec <pop_off>
}
    8000717a:	60e2                	ld	ra,24(sp)
    8000717c:	6442                	ld	s0,16(sp)
    8000717e:	64a2                	ld	s1,8(sp)
    80007180:	6105                	addi	sp,sp,32
    80007182:	8082                	ret
  if (!holding(lk)) panic("release");
    80007184:	00002517          	auipc	a0,0x2
    80007188:	6ac50513          	addi	a0,a0,1708 # 80009830 <etext+0x830>
    8000718c:	00000097          	auipc	ra,0x0
    80007190:	992080e7          	jalr	-1646(ra) # 80006b1e <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
