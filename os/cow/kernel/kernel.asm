
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	34013103          	ld	sp,832(sp) # 8000b340 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	399050ef          	jal	80005bae <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <change_and_get_ref>:
  initlock(&kmem.lock, "kmem");
  initlock(&ref.lock, "ref");
  freerange(end, (void *)PHYSTOP);
}

int change_and_get_ref(uint64 ind, int value) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
    80000028:	84aa                	mv	s1,a0
    8000002a:	892e                	mv	s2,a1
  acquire(&ref.lock);
    8000002c:	0000b517          	auipc	a0,0xb
    80000030:	38450513          	addi	a0,a0,900 # 8000b3b0 <ref>
    80000034:	00006097          	auipc	ra,0x6
    80000038:	5c8080e7          	jalr	1480(ra) # 800065fc <acquire>
  ref.ref_count[ind] += value;
    8000003c:	0000b517          	auipc	a0,0xb
    80000040:	37450513          	addi	a0,a0,884 # 8000b3b0 <ref>
    80000044:	00448793          	addi	a5,s1,4
    80000048:	078a                	slli	a5,a5,0x2
    8000004a:	97aa                	add	a5,a5,a0
    8000004c:	4798                	lw	a4,8(a5)
    8000004e:	012705bb          	addw	a1,a4,s2
    80000052:	0005849b          	sext.w	s1,a1
    80000056:	c78c                	sw	a1,8(a5)
  int res = ref.ref_count[ind];
  release(&ref.lock);
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	658080e7          	jalr	1624(ra) # 800066b0 <release>
  return res;
}
    80000060:	8526                	mv	a0,s1
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret

000000008000006e <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000006e:	1101                	addi	sp,sp,-32
    80000070:	ec06                	sd	ra,24(sp)
    80000072:	e822                	sd	s0,16(sp)
    80000074:	e426                	sd	s1,8(sp)
    80000076:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000078:	03451793          	slli	a5,a0,0x34
    8000007c:	ef95                	bnez	a5,800000b8 <kfree+0x4a>
    8000007e:	84aa                	mv	s1,a0
    80000080:	00044797          	auipc	a5,0x44
    80000084:	7a078793          	addi	a5,a5,1952 # 80044820 <end>
    80000088:	02f56863          	bltu	a0,a5,800000b8 <kfree+0x4a>
    8000008c:	47c5                	li	a5,17
    8000008e:	07ee                	slli	a5,a5,0x1b
    80000090:	02f57463          	bgeu	a0,a5,800000b8 <kfree+0x4a>
    panic("kfree");

  if (change_and_get_ref(P_IND((uint64)pa), -1) > 0) {
    80000094:	757d                	lui	a0,0xfffff
    80000096:	8d65                	and	a0,a0,s1
    80000098:	800007b7          	lui	a5,0x80000
    8000009c:	953e                	add	a0,a0,a5
    8000009e:	55fd                	li	a1,-1
    800000a0:	8131                	srli	a0,a0,0xc
    800000a2:	00000097          	auipc	ra,0x0
    800000a6:	f7a080e7          	jalr	-134(ra) # 8000001c <change_and_get_ref>
    800000aa:	02a05063          	blez	a0,800000ca <kfree+0x5c>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000ae:	60e2                	ld	ra,24(sp)
    800000b0:	6442                	ld	s0,16(sp)
    800000b2:	64a2                	ld	s1,8(sp)
    800000b4:	6105                	addi	sp,sp,32
    800000b6:	8082                	ret
    800000b8:	e04a                	sd	s2,0(sp)
    panic("kfree");
    800000ba:	00008517          	auipc	a0,0x8
    800000be:	f4650513          	addi	a0,a0,-186 # 80008000 <etext>
    800000c2:	00006097          	auipc	ra,0x6
    800000c6:	fc0080e7          	jalr	-64(ra) # 80006082 <panic>
    800000ca:	e04a                	sd	s2,0(sp)
  memset(pa, 1, PGSIZE);
    800000cc:	6605                	lui	a2,0x1
    800000ce:	4585                	li	a1,1
    800000d0:	8526                	mv	a0,s1
    800000d2:	00000097          	auipc	ra,0x0
    800000d6:	14c080e7          	jalr	332(ra) # 8000021e <memset>
  acquire(&kmem.lock);
    800000da:	0000b917          	auipc	s2,0xb
    800000de:	2b690913          	addi	s2,s2,694 # 8000b390 <kmem>
    800000e2:	854a                	mv	a0,s2
    800000e4:	00006097          	auipc	ra,0x6
    800000e8:	518080e7          	jalr	1304(ra) # 800065fc <acquire>
  r->next = kmem.freelist;
    800000ec:	01893783          	ld	a5,24(s2)
    800000f0:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000f2:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000f6:	854a                	mv	a0,s2
    800000f8:	00006097          	auipc	ra,0x6
    800000fc:	5b8080e7          	jalr	1464(ra) # 800066b0 <release>
    80000100:	6902                	ld	s2,0(sp)
    80000102:	b775                	j	800000ae <kfree+0x40>

0000000080000104 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000104:	7179                	addi	sp,sp,-48
    80000106:	f406                	sd	ra,40(sp)
    80000108:	f022                	sd	s0,32(sp)
    8000010a:	ec26                	sd	s1,24(sp)
    8000010c:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    8000010e:	6785                	lui	a5,0x1
    80000110:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000114:	00e504b3          	add	s1,a0,a4
    80000118:	777d                	lui	a4,0xfffff
    8000011a:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    8000011c:	94be                	add	s1,s1,a5
    8000011e:	0295e463          	bltu	a1,s1,80000146 <freerange+0x42>
    80000122:	e84a                	sd	s2,16(sp)
    80000124:	e44e                	sd	s3,8(sp)
    80000126:	e052                	sd	s4,0(sp)
    80000128:	892e                	mv	s2,a1
    8000012a:	7a7d                	lui	s4,0xfffff
    8000012c:	6985                	lui	s3,0x1
    8000012e:	01448533          	add	a0,s1,s4
    80000132:	00000097          	auipc	ra,0x0
    80000136:	f3c080e7          	jalr	-196(ra) # 8000006e <kfree>
    8000013a:	94ce                	add	s1,s1,s3
    8000013c:	fe9979e3          	bgeu	s2,s1,8000012e <freerange+0x2a>
    80000140:	6942                	ld	s2,16(sp)
    80000142:	69a2                	ld	s3,8(sp)
    80000144:	6a02                	ld	s4,0(sp)
}
    80000146:	70a2                	ld	ra,40(sp)
    80000148:	7402                	ld	s0,32(sp)
    8000014a:	64e2                	ld	s1,24(sp)
    8000014c:	6145                	addi	sp,sp,48
    8000014e:	8082                	ret

0000000080000150 <kinit>:
void kinit() {
    80000150:	1141                	addi	sp,sp,-16
    80000152:	e406                	sd	ra,8(sp)
    80000154:	e022                	sd	s0,0(sp)
    80000156:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000158:	00008597          	auipc	a1,0x8
    8000015c:	eb858593          	addi	a1,a1,-328 # 80008010 <etext+0x10>
    80000160:	0000b517          	auipc	a0,0xb
    80000164:	23050513          	addi	a0,a0,560 # 8000b390 <kmem>
    80000168:	00006097          	auipc	ra,0x6
    8000016c:	404080e7          	jalr	1028(ra) # 8000656c <initlock>
  initlock(&ref.lock, "ref");
    80000170:	00008597          	auipc	a1,0x8
    80000174:	ea858593          	addi	a1,a1,-344 # 80008018 <etext+0x18>
    80000178:	0000b517          	auipc	a0,0xb
    8000017c:	23850513          	addi	a0,a0,568 # 8000b3b0 <ref>
    80000180:	00006097          	auipc	ra,0x6
    80000184:	3ec080e7          	jalr	1004(ra) # 8000656c <initlock>
  freerange(end, (void *)PHYSTOP);
    80000188:	45c5                	li	a1,17
    8000018a:	05ee                	slli	a1,a1,0x1b
    8000018c:	00044517          	auipc	a0,0x44
    80000190:	69450513          	addi	a0,a0,1684 # 80044820 <end>
    80000194:	00000097          	auipc	ra,0x0
    80000198:	f70080e7          	jalr	-144(ra) # 80000104 <freerange>
}
    8000019c:	60a2                	ld	ra,8(sp)
    8000019e:	6402                	ld	s0,0(sp)
    800001a0:	0141                	addi	sp,sp,16
    800001a2:	8082                	ret

00000000800001a4 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    800001a4:	1101                	addi	sp,sp,-32
    800001a6:	ec06                	sd	ra,24(sp)
    800001a8:	e822                	sd	s0,16(sp)
    800001aa:	e426                	sd	s1,8(sp)
    800001ac:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001ae:	0000b497          	auipc	s1,0xb
    800001b2:	1e248493          	addi	s1,s1,482 # 8000b390 <kmem>
    800001b6:	8526                	mv	a0,s1
    800001b8:	00006097          	auipc	ra,0x6
    800001bc:	444080e7          	jalr	1092(ra) # 800065fc <acquire>
  r = kmem.freelist;
    800001c0:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    800001c2:	c4a9                	beqz	s1,8000020c <kalloc+0x68>
    800001c4:	609c                	ld	a5,0(s1)
    800001c6:	0000b517          	auipc	a0,0xb
    800001ca:	1ca50513          	addi	a0,a0,458 # 8000b390 <kmem>
    800001ce:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001d0:	00006097          	auipc	ra,0x6
    800001d4:	4e0080e7          	jalr	1248(ra) # 800066b0 <release>

  if (r) {
    memset((char *)r, 5, PGSIZE);
    800001d8:	6605                	lui	a2,0x1
    800001da:	4595                	li	a1,5
    800001dc:	8526                	mv	a0,s1
    800001de:	00000097          	auipc	ra,0x0
    800001e2:	040080e7          	jalr	64(ra) # 8000021e <memset>
    ref.ref_count[P_IND((uint64)r)] = 1;
    800001e6:	77fd                	lui	a5,0xfffff
    800001e8:	8fe5                	and	a5,a5,s1
    800001ea:	80000737          	lui	a4,0x80000
    800001ee:	97ba                	add	a5,a5,a4
    800001f0:	83a9                	srli	a5,a5,0xa
    800001f2:	0000b717          	auipc	a4,0xb
    800001f6:	1ce70713          	addi	a4,a4,462 # 8000b3c0 <ref+0x10>
    800001fa:	97ba                	add	a5,a5,a4
    800001fc:	4705                	li	a4,1
    800001fe:	c798                	sw	a4,8(a5)
  }
  return (void *)r;
}
    80000200:	8526                	mv	a0,s1
    80000202:	60e2                	ld	ra,24(sp)
    80000204:	6442                	ld	s0,16(sp)
    80000206:	64a2                	ld	s1,8(sp)
    80000208:	6105                	addi	sp,sp,32
    8000020a:	8082                	ret
  release(&kmem.lock);
    8000020c:	0000b517          	auipc	a0,0xb
    80000210:	18450513          	addi	a0,a0,388 # 8000b390 <kmem>
    80000214:	00006097          	auipc	ra,0x6
    80000218:	49c080e7          	jalr	1180(ra) # 800066b0 <release>
  if (r) {
    8000021c:	b7d5                	j	80000200 <kalloc+0x5c>

000000008000021e <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e422                	sd	s0,8(sp)
    80000222:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000224:	ca19                	beqz	a2,8000023a <memset+0x1c>
    80000226:	87aa                	mv	a5,a0
    80000228:	1602                	slli	a2,a2,0x20
    8000022a:	9201                	srli	a2,a2,0x20
    8000022c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000230:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffba7e0>
  for (i = 0; i < n; i++) {
    80000234:	0785                	addi	a5,a5,1
    80000236:	fee79de3          	bne	a5,a4,80000230 <memset+0x12>
  }
  return dst;
}
    8000023a:	6422                	ld	s0,8(sp)
    8000023c:	0141                	addi	sp,sp,16
    8000023e:	8082                	ret

0000000080000240 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e422                	sd	s0,8(sp)
    80000244:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000246:	ca05                	beqz	a2,80000276 <memcmp+0x36>
    80000248:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000024c:	1682                	slli	a3,a3,0x20
    8000024e:	9281                	srli	a3,a3,0x20
    80000250:	0685                	addi	a3,a3,1
    80000252:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    80000254:	00054783          	lbu	a5,0(a0)
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00e79863          	bne	a5,a4,8000026c <memcmp+0x2c>
    s1++, s2++;
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000264:	fed518e3          	bne	a0,a3,80000254 <memcmp+0x14>
  }

  return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a019                	j	80000270 <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    8000026c:	40e7853b          	subw	a0,a5,a4
}
    80000270:	6422                	ld	s0,8(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret
  return 0;
    80000276:	4501                	li	a0,0
    80000278:	bfe5                	j	80000270 <memcmp+0x30>

000000008000027a <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e422                	sd	s0,8(sp)
    8000027e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    80000280:	c205                	beqz	a2,800002a0 <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000282:	02a5e263          	bltu	a1,a0,800002a6 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    80000286:	1602                	slli	a2,a2,0x20
    80000288:	9201                	srli	a2,a2,0x20
    8000028a:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    8000028e:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    80000290:	0585                	addi	a1,a1,1
    80000292:	0705                	addi	a4,a4,1
    80000294:	fff5c683          	lbu	a3,-1(a1)
    80000298:	fed70fa3          	sb	a3,-1(a4)
    8000029c:	feb79ae3          	bne	a5,a1,80000290 <memmove+0x16>

  return dst;
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
  if (s < d && s + n > d) {
    800002a6:	02061693          	slli	a3,a2,0x20
    800002aa:	9281                	srli	a3,a3,0x20
    800002ac:	00d58733          	add	a4,a1,a3
    800002b0:	fce57be3          	bgeu	a0,a4,80000286 <memmove+0xc>
    d += n;
    800002b4:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    800002b6:	fff6079b          	addiw	a5,a2,-1
    800002ba:	1782                	slli	a5,a5,0x20
    800002bc:	9381                	srli	a5,a5,0x20
    800002be:	fff7c793          	not	a5,a5
    800002c2:	97ba                	add	a5,a5,a4
    800002c4:	177d                	addi	a4,a4,-1
    800002c6:	16fd                	addi	a3,a3,-1
    800002c8:	00074603          	lbu	a2,0(a4)
    800002cc:	00c68023          	sb	a2,0(a3)
    800002d0:	fef71ae3          	bne	a4,a5,800002c4 <memmove+0x4a>
    800002d4:	b7f1                	j	800002a0 <memmove+0x26>

00000000800002d6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002de:	00000097          	auipc	ra,0x0
    800002e2:	f9c080e7          	jalr	-100(ra) # 8000027a <memmove>
}
    800002e6:	60a2                	ld	ra,8(sp)
    800002e8:	6402                	ld	s0,0(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    800002f4:	ce11                	beqz	a2,80000310 <strncmp+0x22>
    800002f6:	00054783          	lbu	a5,0(a0)
    800002fa:	cf89                	beqz	a5,80000314 <strncmp+0x26>
    800002fc:	0005c703          	lbu	a4,0(a1)
    80000300:	00f71a63          	bne	a4,a5,80000314 <strncmp+0x26>
    80000304:	367d                	addiw	a2,a2,-1
    80000306:	0505                	addi	a0,a0,1
    80000308:	0585                	addi	a1,a1,1
    8000030a:	f675                	bnez	a2,800002f6 <strncmp+0x8>
  if (n == 0) return 0;
    8000030c:	4501                	li	a0,0
    8000030e:	a801                	j	8000031e <strncmp+0x30>
    80000310:	4501                	li	a0,0
    80000312:	a031                	j	8000031e <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000314:	00054503          	lbu	a0,0(a0)
    80000318:	0005c783          	lbu	a5,0(a1)
    8000031c:	9d1d                	subw	a0,a0,a5
}
    8000031e:	6422                	ld	s0,8(sp)
    80000320:	0141                	addi	sp,sp,16
    80000322:	8082                	ret

0000000080000324 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000324:	1141                	addi	sp,sp,-16
    80000326:	e422                	sd	s0,8(sp)
    80000328:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0);
    8000032a:	87aa                	mv	a5,a0
    8000032c:	86b2                	mv	a3,a2
    8000032e:	367d                	addiw	a2,a2,-1
    80000330:	02d05563          	blez	a3,8000035a <strncpy+0x36>
    80000334:	0785                	addi	a5,a5,1
    80000336:	0005c703          	lbu	a4,0(a1)
    8000033a:	fee78fa3          	sb	a4,-1(a5)
    8000033e:	0585                	addi	a1,a1,1
    80000340:	f775                	bnez	a4,8000032c <strncpy+0x8>
  while (n-- > 0) *s++ = 0;
    80000342:	873e                	mv	a4,a5
    80000344:	9fb5                	addw	a5,a5,a3
    80000346:	37fd                	addiw	a5,a5,-1
    80000348:	00c05963          	blez	a2,8000035a <strncpy+0x36>
    8000034c:	0705                	addi	a4,a4,1
    8000034e:	fe070fa3          	sb	zero,-1(a4)
    80000352:	40e786bb          	subw	a3,a5,a4
    80000356:	fed04be3          	bgtz	a3,8000034c <strncpy+0x28>
  return os;
}
    8000035a:	6422                	ld	s0,8(sp)
    8000035c:	0141                	addi	sp,sp,16
    8000035e:	8082                	ret

0000000080000360 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    80000360:	1141                	addi	sp,sp,-16
    80000362:	e422                	sd	s0,8(sp)
    80000364:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    80000366:	02c05363          	blez	a2,8000038c <safestrcpy+0x2c>
    8000036a:	fff6069b          	addiw	a3,a2,-1
    8000036e:	1682                	slli	a3,a3,0x20
    80000370:	9281                	srli	a3,a3,0x20
    80000372:	96ae                	add	a3,a3,a1
    80000374:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0);
    80000376:	00d58963          	beq	a1,a3,80000388 <safestrcpy+0x28>
    8000037a:	0585                	addi	a1,a1,1
    8000037c:	0785                	addi	a5,a5,1
    8000037e:	fff5c703          	lbu	a4,-1(a1)
    80000382:	fee78fa3          	sb	a4,-1(a5)
    80000386:	fb65                	bnez	a4,80000376 <safestrcpy+0x16>
  *s = 0;
    80000388:	00078023          	sb	zero,0(a5)
  return os;
}
    8000038c:	6422                	ld	s0,8(sp)
    8000038e:	0141                	addi	sp,sp,16
    80000390:	8082                	ret

0000000080000392 <strlen>:

int strlen(const char *s) {
    80000392:	1141                	addi	sp,sp,-16
    80000394:	e422                	sd	s0,8(sp)
    80000396:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++);
    80000398:	00054783          	lbu	a5,0(a0)
    8000039c:	cf91                	beqz	a5,800003b8 <strlen+0x26>
    8000039e:	0505                	addi	a0,a0,1
    800003a0:	87aa                	mv	a5,a0
    800003a2:	86be                	mv	a3,a5
    800003a4:	0785                	addi	a5,a5,1
    800003a6:	fff7c703          	lbu	a4,-1(a5)
    800003aa:	ff65                	bnez	a4,800003a2 <strlen+0x10>
    800003ac:	40a6853b          	subw	a0,a3,a0
    800003b0:	2505                	addiw	a0,a0,1
  return n;
}
    800003b2:	6422                	ld	s0,8(sp)
    800003b4:	0141                	addi	sp,sp,16
    800003b6:	8082                	ret
  for (n = 0; s[n]; n++);
    800003b8:	4501                	li	a0,0
    800003ba:	bfe5                	j	800003b2 <strlen+0x20>

00000000800003bc <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    800003bc:	1141                	addi	sp,sp,-16
    800003be:	e406                	sd	ra,8(sp)
    800003c0:	e022                	sd	s0,0(sp)
    800003c2:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800003c4:	00001097          	auipc	ra,0x1
    800003c8:	cb2080e7          	jalr	-846(ra) # 80001076 <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0);
    800003cc:	0000b717          	auipc	a4,0xb
    800003d0:	f9470713          	addi	a4,a4,-108 # 8000b360 <started>
  if (cpuid() == 0) {
    800003d4:	c139                	beqz	a0,8000041a <main+0x5e>
    while (started == 0);
    800003d6:	431c                	lw	a5,0(a4)
    800003d8:	2781                	sext.w	a5,a5
    800003da:	dff5                	beqz	a5,800003d6 <main+0x1a>
    __sync_synchronize();
    800003dc:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800003e0:	00001097          	auipc	ra,0x1
    800003e4:	c96080e7          	jalr	-874(ra) # 80001076 <cpuid>
    800003e8:	85aa                	mv	a1,a0
    800003ea:	00008517          	auipc	a0,0x8
    800003ee:	c5650513          	addi	a0,a0,-938 # 80008040 <etext+0x40>
    800003f2:	00006097          	auipc	ra,0x6
    800003f6:	cda080e7          	jalr	-806(ra) # 800060cc <printf>
    kvminithart();   // turn on paging
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	0d8080e7          	jalr	216(ra) # 800004d2 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000402:	00002097          	auipc	ra,0x2
    80000406:	944080e7          	jalr	-1724(ra) # 80001d46 <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	11a080e7          	jalr	282(ra) # 80005524 <plicinithart>
  }

  scheduler();
    80000412:	00001097          	auipc	ra,0x1
    80000416:	18c080e7          	jalr	396(ra) # 8000159e <scheduler>
    consoleinit();
    8000041a:	00006097          	auipc	ra,0x6
    8000041e:	b78080e7          	jalr	-1160(ra) # 80005f92 <consoleinit>
    printfinit();
    80000422:	00006097          	auipc	ra,0x6
    80000426:	eb2080e7          	jalr	-334(ra) # 800062d4 <printfinit>
    printf("\n");
    8000042a:	00008517          	auipc	a0,0x8
    8000042e:	bf650513          	addi	a0,a0,-1034 # 80008020 <etext+0x20>
    80000432:	00006097          	auipc	ra,0x6
    80000436:	c9a080e7          	jalr	-870(ra) # 800060cc <printf>
    printf("xv6 kernel is booting\n");
    8000043a:	00008517          	auipc	a0,0x8
    8000043e:	bee50513          	addi	a0,a0,-1042 # 80008028 <etext+0x28>
    80000442:	00006097          	auipc	ra,0x6
    80000446:	c8a080e7          	jalr	-886(ra) # 800060cc <printf>
    printf("\n");
    8000044a:	00008517          	auipc	a0,0x8
    8000044e:	bd650513          	addi	a0,a0,-1066 # 80008020 <etext+0x20>
    80000452:	00006097          	auipc	ra,0x6
    80000456:	c7a080e7          	jalr	-902(ra) # 800060cc <printf>
    kinit();             // physical page allocator
    8000045a:	00000097          	auipc	ra,0x0
    8000045e:	cf6080e7          	jalr	-778(ra) # 80000150 <kinit>
    kvminit();           // create kernel page table
    80000462:	00000097          	auipc	ra,0x0
    80000466:	34a080e7          	jalr	842(ra) # 800007ac <kvminit>
    kvminithart();       // turn on paging
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	068080e7          	jalr	104(ra) # 800004d2 <kvminithart>
    procinit();          // process table
    80000472:	00001097          	auipc	ra,0x1
    80000476:	b42080e7          	jalr	-1214(ra) # 80000fb4 <procinit>
    trapinit();          // trap vectors
    8000047a:	00002097          	auipc	ra,0x2
    8000047e:	8a4080e7          	jalr	-1884(ra) # 80001d1e <trapinit>
    trapinithart();      // install kernel trap vector
    80000482:	00002097          	auipc	ra,0x2
    80000486:	8c4080e7          	jalr	-1852(ra) # 80001d46 <trapinithart>
    plicinit();          // set up interrupt controller
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	080080e7          	jalr	128(ra) # 8000550a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    80000492:	00005097          	auipc	ra,0x5
    80000496:	092080e7          	jalr	146(ra) # 80005524 <plicinithart>
    binit();             // buffer cache
    8000049a:	00002097          	auipc	ra,0x2
    8000049e:	13e080e7          	jalr	318(ra) # 800025d8 <binit>
    iinit();             // inode table
    800004a2:	00002097          	auipc	ra,0x2
    800004a6:	7f4080e7          	jalr	2036(ra) # 80002c96 <iinit>
    fileinit();          // file table
    800004aa:	00003097          	auipc	ra,0x3
    800004ae:	7a4080e7          	jalr	1956(ra) # 80003c4e <fileinit>
    virtio_disk_init();  // emulated hard disk
    800004b2:	00005097          	auipc	ra,0x5
    800004b6:	17a080e7          	jalr	378(ra) # 8000562c <virtio_disk_init>
    userinit();          // first user process
    800004ba:	00001097          	auipc	ra,0x1
    800004be:	ec4080e7          	jalr	-316(ra) # 8000137e <userinit>
    __sync_synchronize();
    800004c2:	0330000f          	fence	rw,rw
    started = 1;
    800004c6:	4785                	li	a5,1
    800004c8:	0000b717          	auipc	a4,0xb
    800004cc:	e8f72c23          	sw	a5,-360(a4) # 8000b360 <started>
    800004d0:	b789                	j	80000412 <main+0x56>

00000000800004d2 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    800004d2:	1141                	addi	sp,sp,-16
    800004d4:	e422                	sd	s0,8(sp)
    800004d6:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004d8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004dc:	0000b797          	auipc	a5,0xb
    800004e0:	e8c7b783          	ld	a5,-372(a5) # 8000b368 <kernel_pagetable>
    800004e4:	83b1                	srli	a5,a5,0xc
    800004e6:	577d                	li	a4,-1
    800004e8:	177e                	slli	a4,a4,0x3f
    800004ea:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    800004ec:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004f0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004f4:	6422                	ld	s0,8(sp)
    800004f6:	0141                	addi	sp,sp,16
    800004f8:	8082                	ret

00000000800004fa <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    800004fa:	7139                	addi	sp,sp,-64
    800004fc:	fc06                	sd	ra,56(sp)
    800004fe:	f822                	sd	s0,48(sp)
    80000500:	f426                	sd	s1,40(sp)
    80000502:	f04a                	sd	s2,32(sp)
    80000504:	ec4e                	sd	s3,24(sp)
    80000506:	e852                	sd	s4,16(sp)
    80000508:	e456                	sd	s5,8(sp)
    8000050a:	e05a                	sd	s6,0(sp)
    8000050c:	0080                	addi	s0,sp,64
    8000050e:	84aa                	mv	s1,a0
    80000510:	89ae                	mv	s3,a1
    80000512:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000514:	57fd                	li	a5,-1
    80000516:	83e9                	srli	a5,a5,0x1a
    80000518:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    8000051a:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    8000051c:	04b7f263          	bgeu	a5,a1,80000560 <walk+0x66>
    80000520:	00008517          	auipc	a0,0x8
    80000524:	b3850513          	addi	a0,a0,-1224 # 80008058 <etext+0x58>
    80000528:	00006097          	auipc	ra,0x6
    8000052c:	b5a080e7          	jalr	-1190(ra) # 80006082 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000530:	060a8663          	beqz	s5,8000059c <walk+0xa2>
    80000534:	00000097          	auipc	ra,0x0
    80000538:	c70080e7          	jalr	-912(ra) # 800001a4 <kalloc>
    8000053c:	84aa                	mv	s1,a0
    8000053e:	c529                	beqz	a0,80000588 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000540:	6605                	lui	a2,0x1
    80000542:	4581                	li	a1,0
    80000544:	00000097          	auipc	ra,0x0
    80000548:	cda080e7          	jalr	-806(ra) # 8000021e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000054c:	00c4d793          	srli	a5,s1,0xc
    80000550:	07aa                	slli	a5,a5,0xa
    80000552:	0017e793          	ori	a5,a5,1
    80000556:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    8000055a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffba7d7>
    8000055c:	036a0063          	beq	s4,s6,8000057c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000560:	0149d933          	srl	s2,s3,s4
    80000564:	1ff97913          	andi	s2,s2,511
    80000568:	090e                	slli	s2,s2,0x3
    8000056a:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    8000056c:	00093483          	ld	s1,0(s2)
    80000570:	0014f793          	andi	a5,s1,1
    80000574:	dfd5                	beqz	a5,80000530 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000576:	80a9                	srli	s1,s1,0xa
    80000578:	04b2                	slli	s1,s1,0xc
    8000057a:	b7c5                	j	8000055a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000057c:	00c9d513          	srli	a0,s3,0xc
    80000580:	1ff57513          	andi	a0,a0,511
    80000584:	050e                	slli	a0,a0,0x3
    80000586:	9526                	add	a0,a0,s1
}
    80000588:	70e2                	ld	ra,56(sp)
    8000058a:	7442                	ld	s0,48(sp)
    8000058c:	74a2                	ld	s1,40(sp)
    8000058e:	7902                	ld	s2,32(sp)
    80000590:	69e2                	ld	s3,24(sp)
    80000592:	6a42                	ld	s4,16(sp)
    80000594:	6aa2                	ld	s5,8(sp)
    80000596:	6b02                	ld	s6,0(sp)
    80000598:	6121                	addi	sp,sp,64
    8000059a:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    8000059c:	4501                	li	a0,0
    8000059e:	b7ed                	j	80000588 <walk+0x8e>

00000000800005a0 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    800005a0:	57fd                	li	a5,-1
    800005a2:	83e9                	srli	a5,a5,0x1a
    800005a4:	00b7f463          	bgeu	a5,a1,800005ac <walkaddr+0xc>
    800005a8:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005aa:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    800005ac:	1141                	addi	sp,sp,-16
    800005ae:	e406                	sd	ra,8(sp)
    800005b0:	e022                	sd	s0,0(sp)
    800005b2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005b4:	4601                	li	a2,0
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	f44080e7          	jalr	-188(ra) # 800004fa <walk>
  if (pte == 0) return 0;
    800005be:	c105                	beqz	a0,800005de <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    800005c0:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    800005c2:	0117f693          	andi	a3,a5,17
    800005c6:	4745                	li	a4,17
    800005c8:	4501                	li	a0,0
    800005ca:	00e68663          	beq	a3,a4,800005d6 <walkaddr+0x36>
}
    800005ce:	60a2                	ld	ra,8(sp)
    800005d0:	6402                	ld	s0,0(sp)
    800005d2:	0141                	addi	sp,sp,16
    800005d4:	8082                	ret
  pa = PTE2PA(*pte);
    800005d6:	83a9                	srli	a5,a5,0xa
    800005d8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005dc:	bfcd                	j	800005ce <walkaddr+0x2e>
  if (pte == 0) return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7fd                	j	800005ce <walkaddr+0x2e>

00000000800005e2 <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    800005e2:	715d                	addi	sp,sp,-80
    800005e4:	e486                	sd	ra,72(sp)
    800005e6:	e0a2                	sd	s0,64(sp)
    800005e8:	fc26                	sd	s1,56(sp)
    800005ea:	f84a                	sd	s2,48(sp)
    800005ec:	f44e                	sd	s3,40(sp)
    800005ee:	f052                	sd	s4,32(sp)
    800005f0:	ec56                	sd	s5,24(sp)
    800005f2:	e85a                	sd	s6,16(sp)
    800005f4:	e45e                	sd	s7,8(sp)
    800005f6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    800005f8:	03459793          	slli	a5,a1,0x34
    800005fc:	e7b9                	bnez	a5,8000064a <mappages+0x68>
    800005fe:	8aaa                	mv	s5,a0
    80000600:	8b3a                	mv	s6,a4

  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    80000602:	03461793          	slli	a5,a2,0x34
    80000606:	ebb1                	bnez	a5,8000065a <mappages+0x78>

  if (size == 0) panic("mappages: size");
    80000608:	c22d                	beqz	a2,8000066a <mappages+0x88>

  a = va;
  last = va + size - PGSIZE;
    8000060a:	77fd                	lui	a5,0xfffff
    8000060c:	963e                	add	a2,a2,a5
    8000060e:	00b609b3          	add	s3,a2,a1
  a = va;
    80000612:	892e                	mv	s2,a1
    80000614:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000618:	6b85                	lui	s7,0x1
    8000061a:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000061e:	4605                	li	a2,1
    80000620:	85ca                	mv	a1,s2
    80000622:	8556                	mv	a0,s5
    80000624:	00000097          	auipc	ra,0x0
    80000628:	ed6080e7          	jalr	-298(ra) # 800004fa <walk>
    8000062c:	cd39                	beqz	a0,8000068a <mappages+0xa8>
    if (*pte & PTE_V) panic("mappages: remap");
    8000062e:	611c                	ld	a5,0(a0)
    80000630:	8b85                	andi	a5,a5,1
    80000632:	e7a1                	bnez	a5,8000067a <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000634:	80b1                	srli	s1,s1,0xc
    80000636:	04aa                	slli	s1,s1,0xa
    80000638:	0164e4b3          	or	s1,s1,s6
    8000063c:	0014e493          	ori	s1,s1,1
    80000640:	e104                	sd	s1,0(a0)
    if (a == last) break;
    80000642:	07390063          	beq	s2,s3,800006a2 <mappages+0xc0>
    a += PGSIZE;
    80000646:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000648:	bfc9                	j	8000061a <mappages+0x38>
  if ((va % PGSIZE) != 0) panic("mappages: va not aligned");
    8000064a:	00008517          	auipc	a0,0x8
    8000064e:	a1650513          	addi	a0,a0,-1514 # 80008060 <etext+0x60>
    80000652:	00006097          	auipc	ra,0x6
    80000656:	a30080e7          	jalr	-1488(ra) # 80006082 <panic>
  if ((size % PGSIZE) != 0) panic("mappages: size not aligned");
    8000065a:	00008517          	auipc	a0,0x8
    8000065e:	a2650513          	addi	a0,a0,-1498 # 80008080 <etext+0x80>
    80000662:	00006097          	auipc	ra,0x6
    80000666:	a20080e7          	jalr	-1504(ra) # 80006082 <panic>
  if (size == 0) panic("mappages: size");
    8000066a:	00008517          	auipc	a0,0x8
    8000066e:	a3650513          	addi	a0,a0,-1482 # 800080a0 <etext+0xa0>
    80000672:	00006097          	auipc	ra,0x6
    80000676:	a10080e7          	jalr	-1520(ra) # 80006082 <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    8000067a:	00008517          	auipc	a0,0x8
    8000067e:	a3650513          	addi	a0,a0,-1482 # 800080b0 <etext+0xb0>
    80000682:	00006097          	auipc	ra,0x6
    80000686:	a00080e7          	jalr	-1536(ra) # 80006082 <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000068a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000068c:	60a6                	ld	ra,72(sp)
    8000068e:	6406                	ld	s0,64(sp)
    80000690:	74e2                	ld	s1,56(sp)
    80000692:	7942                	ld	s2,48(sp)
    80000694:	79a2                	ld	s3,40(sp)
    80000696:	7a02                	ld	s4,32(sp)
    80000698:	6ae2                	ld	s5,24(sp)
    8000069a:	6b42                	ld	s6,16(sp)
    8000069c:	6ba2                	ld	s7,8(sp)
    8000069e:	6161                	addi	sp,sp,80
    800006a0:	8082                	ret
  return 0;
    800006a2:	4501                	li	a0,0
    800006a4:	b7e5                	j	8000068c <mappages+0xaa>

00000000800006a6 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800006a6:	1141                	addi	sp,sp,-16
    800006a8:	e406                	sd	ra,8(sp)
    800006aa:	e022                	sd	s0,0(sp)
    800006ac:	0800                	addi	s0,sp,16
    800006ae:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006b0:	86b2                	mv	a3,a2
    800006b2:	863e                	mv	a2,a5
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f2e080e7          	jalr	-210(ra) # 800005e2 <mappages>
    800006bc:	e509                	bnez	a0,800006c6 <kvmmap+0x20>
}
    800006be:	60a2                	ld	ra,8(sp)
    800006c0:	6402                	ld	s0,0(sp)
    800006c2:	0141                	addi	sp,sp,16
    800006c4:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006c6:	00008517          	auipc	a0,0x8
    800006ca:	9fa50513          	addi	a0,a0,-1542 # 800080c0 <etext+0xc0>
    800006ce:	00006097          	auipc	ra,0x6
    800006d2:	9b4080e7          	jalr	-1612(ra) # 80006082 <panic>

00000000800006d6 <kvmmake>:
pagetable_t kvmmake(void) {
    800006d6:	1101                	addi	sp,sp,-32
    800006d8:	ec06                	sd	ra,24(sp)
    800006da:	e822                	sd	s0,16(sp)
    800006dc:	e426                	sd	s1,8(sp)
    800006de:	e04a                	sd	s2,0(sp)
    800006e0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	ac2080e7          	jalr	-1342(ra) # 800001a4 <kalloc>
    800006ea:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006ec:	6605                	lui	a2,0x1
    800006ee:	4581                	li	a1,0
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	b2e080e7          	jalr	-1234(ra) # 8000021e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006f8:	4719                	li	a4,6
    800006fa:	6685                	lui	a3,0x1
    800006fc:	10000637          	lui	a2,0x10000
    80000700:	100005b7          	lui	a1,0x10000
    80000704:	8526                	mv	a0,s1
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	fa0080e7          	jalr	-96(ra) # 800006a6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000070e:	4719                	li	a4,6
    80000710:	6685                	lui	a3,0x1
    80000712:	10001637          	lui	a2,0x10001
    80000716:	100015b7          	lui	a1,0x10001
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f8a080e7          	jalr	-118(ra) # 800006a6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000724:	4719                	li	a4,6
    80000726:	004006b7          	lui	a3,0x400
    8000072a:	0c000637          	lui	a2,0xc000
    8000072e:	0c0005b7          	lui	a1,0xc000
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	f72080e7          	jalr	-142(ra) # 800006a6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000073c:	00008917          	auipc	s2,0x8
    80000740:	8c490913          	addi	s2,s2,-1852 # 80008000 <etext>
    80000744:	4729                	li	a4,10
    80000746:	80008697          	auipc	a3,0x80008
    8000074a:	8ba68693          	addi	a3,a3,-1862 # 8000 <_entry-0x7fff8000>
    8000074e:	4605                	li	a2,1
    80000750:	067e                	slli	a2,a2,0x1f
    80000752:	85b2                	mv	a1,a2
    80000754:	8526                	mv	a0,s1
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	f50080e7          	jalr	-176(ra) # 800006a6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000075e:	46c5                	li	a3,17
    80000760:	06ee                	slli	a3,a3,0x1b
    80000762:	4719                	li	a4,6
    80000764:	412686b3          	sub	a3,a3,s2
    80000768:	864a                	mv	a2,s2
    8000076a:	85ca                	mv	a1,s2
    8000076c:	8526                	mv	a0,s1
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	f38080e7          	jalr	-200(ra) # 800006a6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000776:	4729                	li	a4,10
    80000778:	6685                	lui	a3,0x1
    8000077a:	00007617          	auipc	a2,0x7
    8000077e:	88660613          	addi	a2,a2,-1914 # 80007000 <_trampoline>
    80000782:	040005b7          	lui	a1,0x4000
    80000786:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000788:	05b2                	slli	a1,a1,0xc
    8000078a:	8526                	mv	a0,s1
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	f1a080e7          	jalr	-230(ra) # 800006a6 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000794:	8526                	mv	a0,s1
    80000796:	00000097          	auipc	ra,0x0
    8000079a:	77a080e7          	jalr	1914(ra) # 80000f10 <proc_mapstacks>
}
    8000079e:	8526                	mv	a0,s1
    800007a0:	60e2                	ld	ra,24(sp)
    800007a2:	6442                	ld	s0,16(sp)
    800007a4:	64a2                	ld	s1,8(sp)
    800007a6:	6902                	ld	s2,0(sp)
    800007a8:	6105                	addi	sp,sp,32
    800007aa:	8082                	ret

00000000800007ac <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800007ac:	1141                	addi	sp,sp,-16
    800007ae:	e406                	sd	ra,8(sp)
    800007b0:	e022                	sd	s0,0(sp)
    800007b2:	0800                	addi	s0,sp,16
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	f22080e7          	jalr	-222(ra) # 800006d6 <kvmmake>
    800007bc:	0000b797          	auipc	a5,0xb
    800007c0:	baa7b623          	sd	a0,-1108(a5) # 8000b368 <kernel_pagetable>
    800007c4:	60a2                	ld	ra,8(sp)
    800007c6:	6402                	ld	s0,0(sp)
    800007c8:	0141                	addi	sp,sp,16
    800007ca:	8082                	ret

00000000800007cc <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    800007cc:	715d                	addi	sp,sp,-80
    800007ce:	e486                	sd	ra,72(sp)
    800007d0:	e0a2                	sd	s0,64(sp)
    800007d2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    800007d4:	03459793          	slli	a5,a1,0x34
    800007d8:	e39d                	bnez	a5,800007fe <uvmunmap+0x32>
    800007da:	f84a                	sd	s2,48(sp)
    800007dc:	f44e                	sd	s3,40(sp)
    800007de:	f052                	sd	s4,32(sp)
    800007e0:	ec56                	sd	s5,24(sp)
    800007e2:	e85a                	sd	s6,16(sp)
    800007e4:	e45e                	sd	s7,8(sp)
    800007e6:	8a2a                	mv	s4,a0
    800007e8:	892e                	mv	s2,a1
    800007ea:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007ec:	0632                	slli	a2,a2,0xc
    800007ee:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007f2:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800007f4:	6b05                	lui	s6,0x1
    800007f6:	0935fb63          	bgeu	a1,s3,8000088c <uvmunmap+0xc0>
    800007fa:	fc26                	sd	s1,56(sp)
    800007fc:	a8a9                	j	80000856 <uvmunmap+0x8a>
    800007fe:	fc26                	sd	s1,56(sp)
    80000800:	f84a                	sd	s2,48(sp)
    80000802:	f44e                	sd	s3,40(sp)
    80000804:	f052                	sd	s4,32(sp)
    80000806:	ec56                	sd	s5,24(sp)
    80000808:	e85a                	sd	s6,16(sp)
    8000080a:	e45e                	sd	s7,8(sp)
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    8000080c:	00008517          	auipc	a0,0x8
    80000810:	8bc50513          	addi	a0,a0,-1860 # 800080c8 <etext+0xc8>
    80000814:	00006097          	auipc	ra,0x6
    80000818:	86e080e7          	jalr	-1938(ra) # 80006082 <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    8000081c:	00008517          	auipc	a0,0x8
    80000820:	8c450513          	addi	a0,a0,-1852 # 800080e0 <etext+0xe0>
    80000824:	00006097          	auipc	ra,0x6
    80000828:	85e080e7          	jalr	-1954(ra) # 80006082 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    8000082c:	00008517          	auipc	a0,0x8
    80000830:	8c450513          	addi	a0,a0,-1852 # 800080f0 <etext+0xf0>
    80000834:	00006097          	auipc	ra,0x6
    80000838:	84e080e7          	jalr	-1970(ra) # 80006082 <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000083c:	00008517          	auipc	a0,0x8
    80000840:	8cc50513          	addi	a0,a0,-1844 # 80008108 <etext+0x108>
    80000844:	00006097          	auipc	ra,0x6
    80000848:	83e080e7          	jalr	-1986(ra) # 80006082 <panic>
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000084c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000850:	995a                	add	s2,s2,s6
    80000852:	03397c63          	bgeu	s2,s3,8000088a <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000856:	4601                	li	a2,0
    80000858:	85ca                	mv	a1,s2
    8000085a:	8552                	mv	a0,s4
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	c9e080e7          	jalr	-866(ra) # 800004fa <walk>
    80000864:	84aa                	mv	s1,a0
    80000866:	d95d                	beqz	a0,8000081c <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000868:	6108                	ld	a0,0(a0)
    8000086a:	00157793          	andi	a5,a0,1
    8000086e:	dfdd                	beqz	a5,8000082c <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000870:	3ff57793          	andi	a5,a0,1023
    80000874:	fd7784e3          	beq	a5,s7,8000083c <uvmunmap+0x70>
    if (do_free) {
    80000878:	fc0a8ae3          	beqz	s5,8000084c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000087c:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    8000087e:	0532                	slli	a0,a0,0xc
    80000880:	fffff097          	auipc	ra,0xfffff
    80000884:	7ee080e7          	jalr	2030(ra) # 8000006e <kfree>
    80000888:	b7d1                	j	8000084c <uvmunmap+0x80>
    8000088a:	74e2                	ld	s1,56(sp)
    8000088c:	7942                	ld	s2,48(sp)
    8000088e:	79a2                	ld	s3,40(sp)
    80000890:	7a02                	ld	s4,32(sp)
    80000892:	6ae2                	ld	s5,24(sp)
    80000894:	6b42                	ld	s6,16(sp)
    80000896:	6ba2                	ld	s7,8(sp)
  }
}
    80000898:	60a6                	ld	ra,72(sp)
    8000089a:	6406                	ld	s0,64(sp)
    8000089c:	6161                	addi	sp,sp,80
    8000089e:	8082                	ret

00000000800008a0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800008a0:	1101                	addi	sp,sp,-32
    800008a2:	ec06                	sd	ra,24(sp)
    800008a4:	e822                	sd	s0,16(sp)
    800008a6:	e426                	sd	s1,8(sp)
    800008a8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	8fa080e7          	jalr	-1798(ra) # 800001a4 <kalloc>
    800008b2:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800008b4:	c519                	beqz	a0,800008c2 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800008b6:	6605                	lui	a2,0x1
    800008b8:	4581                	li	a1,0
    800008ba:	00000097          	auipc	ra,0x0
    800008be:	964080e7          	jalr	-1692(ra) # 8000021e <memset>
  return pagetable;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret

00000000800008ce <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800008ce:	7179                	addi	sp,sp,-48
    800008d0:	f406                	sd	ra,40(sp)
    800008d2:	f022                	sd	s0,32(sp)
    800008d4:	ec26                	sd	s1,24(sp)
    800008d6:	e84a                	sd	s2,16(sp)
    800008d8:	e44e                	sd	s3,8(sp)
    800008da:	e052                	sd	s4,0(sp)
    800008dc:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    800008de:	6785                	lui	a5,0x1
    800008e0:	04f67863          	bgeu	a2,a5,80000930 <uvmfirst+0x62>
    800008e4:	8a2a                	mv	s4,a0
    800008e6:	89ae                	mv	s3,a1
    800008e8:	84b2                	mv	s1,a2
  mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	8ba080e7          	jalr	-1862(ra) # 800001a4 <kalloc>
    800008f2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	926080e7          	jalr	-1754(ra) # 8000021e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000900:	4779                	li	a4,30
    80000902:	86ca                	mv	a3,s2
    80000904:	6605                	lui	a2,0x1
    80000906:	4581                	li	a1,0
    80000908:	8552                	mv	a0,s4
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	cd8080e7          	jalr	-808(ra) # 800005e2 <mappages>
  memmove(mem, src, sz);
    80000912:	8626                	mv	a2,s1
    80000914:	85ce                	mv	a1,s3
    80000916:	854a                	mv	a0,s2
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	962080e7          	jalr	-1694(ra) # 8000027a <memmove>
}
    80000920:	70a2                	ld	ra,40(sp)
    80000922:	7402                	ld	s0,32(sp)
    80000924:	64e2                	ld	s1,24(sp)
    80000926:	6942                	ld	s2,16(sp)
    80000928:	69a2                	ld	s3,8(sp)
    8000092a:	6a02                	ld	s4,0(sp)
    8000092c:	6145                	addi	sp,sp,48
    8000092e:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000930:	00007517          	auipc	a0,0x7
    80000934:	7f050513          	addi	a0,a0,2032 # 80008120 <etext+0x120>
    80000938:	00005097          	auipc	ra,0x5
    8000093c:	74a080e7          	jalr	1866(ra) # 80006082 <panic>

0000000080000940 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000940:	1101                	addi	sp,sp,-32
    80000942:	ec06                	sd	ra,24(sp)
    80000944:	e822                	sd	s0,16(sp)
    80000946:	e426                	sd	s1,8(sp)
    80000948:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    8000094a:	84ae                	mv	s1,a1
    8000094c:	00b67d63          	bgeu	a2,a1,80000966 <uvmdealloc+0x26>
    80000950:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000952:	6785                	lui	a5,0x1
    80000954:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000956:	00f60733          	add	a4,a2,a5
    8000095a:	76fd                	lui	a3,0xfffff
    8000095c:	8f75                	and	a4,a4,a3
    8000095e:	97ae                	add	a5,a5,a1
    80000960:	8ff5                	and	a5,a5,a3
    80000962:	00f76863          	bltu	a4,a5,80000972 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000966:	8526                	mv	a0,s1
    80000968:	60e2                	ld	ra,24(sp)
    8000096a:	6442                	ld	s0,16(sp)
    8000096c:	64a2                	ld	s1,8(sp)
    8000096e:	6105                	addi	sp,sp,32
    80000970:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000972:	8f99                	sub	a5,a5,a4
    80000974:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000976:	4685                	li	a3,1
    80000978:	0007861b          	sext.w	a2,a5
    8000097c:	85ba                	mv	a1,a4
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	e4e080e7          	jalr	-434(ra) # 800007cc <uvmunmap>
    80000986:	b7c5                	j	80000966 <uvmdealloc+0x26>

0000000080000988 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    80000988:	0ab66b63          	bltu	a2,a1,80000a3e <uvmalloc+0xb6>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    8000098c:	7139                	addi	sp,sp,-64
    8000098e:	fc06                	sd	ra,56(sp)
    80000990:	f822                	sd	s0,48(sp)
    80000992:	ec4e                	sd	s3,24(sp)
    80000994:	e852                	sd	s4,16(sp)
    80000996:	e456                	sd	s5,8(sp)
    80000998:	0080                	addi	s0,sp,64
    8000099a:	8aaa                	mv	s5,a0
    8000099c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000099e:	6785                	lui	a5,0x1
    800009a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009a2:	95be                	add	a1,a1,a5
    800009a4:	77fd                	lui	a5,0xfffff
    800009a6:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800009aa:	08c9fc63          	bgeu	s3,a2,80000a42 <uvmalloc+0xba>
    800009ae:	f426                	sd	s1,40(sp)
    800009b0:	f04a                	sd	s2,32(sp)
    800009b2:	e05a                	sd	s6,0(sp)
    800009b4:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009b6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	7ea080e7          	jalr	2026(ra) # 800001a4 <kalloc>
    800009c2:	84aa                	mv	s1,a0
    if (mem == 0) {
    800009c4:	c915                	beqz	a0,800009f8 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800009c6:	6605                	lui	a2,0x1
    800009c8:	4581                	li	a1,0
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	854080e7          	jalr	-1964(ra) # 8000021e <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009d2:	875a                	mv	a4,s6
    800009d4:	86a6                	mv	a3,s1
    800009d6:	6605                	lui	a2,0x1
    800009d8:	85ca                	mv	a1,s2
    800009da:	8556                	mv	a0,s5
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	c06080e7          	jalr	-1018(ra) # 800005e2 <mappages>
    800009e4:	ed05                	bnez	a0,80000a1c <uvmalloc+0x94>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800009e6:	6785                	lui	a5,0x1
    800009e8:	993e                	add	s2,s2,a5
    800009ea:	fd4968e3          	bltu	s2,s4,800009ba <uvmalloc+0x32>
  return newsz;
    800009ee:	8552                	mv	a0,s4
    800009f0:	74a2                	ld	s1,40(sp)
    800009f2:	7902                	ld	s2,32(sp)
    800009f4:	6b02                	ld	s6,0(sp)
    800009f6:	a821                	j	80000a0e <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800009f8:	864e                	mv	a2,s3
    800009fa:	85ca                	mv	a1,s2
    800009fc:	8556                	mv	a0,s5
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	f42080e7          	jalr	-190(ra) # 80000940 <uvmdealloc>
      return 0;
    80000a06:	4501                	li	a0,0
    80000a08:	74a2                	ld	s1,40(sp)
    80000a0a:	7902                	ld	s2,32(sp)
    80000a0c:	6b02                	ld	s6,0(sp)
}
    80000a0e:	70e2                	ld	ra,56(sp)
    80000a10:	7442                	ld	s0,48(sp)
    80000a12:	69e2                	ld	s3,24(sp)
    80000a14:	6a42                	ld	s4,16(sp)
    80000a16:	6aa2                	ld	s5,8(sp)
    80000a18:	6121                	addi	sp,sp,64
    80000a1a:	8082                	ret
      kfree(mem);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	fffff097          	auipc	ra,0xfffff
    80000a22:	650080e7          	jalr	1616(ra) # 8000006e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a26:	864e                	mv	a2,s3
    80000a28:	85ca                	mv	a1,s2
    80000a2a:	8556                	mv	a0,s5
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	f14080e7          	jalr	-236(ra) # 80000940 <uvmdealloc>
      return 0;
    80000a34:	4501                	li	a0,0
    80000a36:	74a2                	ld	s1,40(sp)
    80000a38:	7902                	ld	s2,32(sp)
    80000a3a:	6b02                	ld	s6,0(sp)
    80000a3c:	bfc9                	j	80000a0e <uvmalloc+0x86>
  if (newsz < oldsz) return oldsz;
    80000a3e:	852e                	mv	a0,a1
}
    80000a40:	8082                	ret
  return newsz;
    80000a42:	8532                	mv	a0,a2
    80000a44:	b7e9                	j	80000a0e <uvmalloc+0x86>

0000000080000a46 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80000a46:	7179                	addi	sp,sp,-48
    80000a48:	f406                	sd	ra,40(sp)
    80000a4a:	f022                	sd	s0,32(sp)
    80000a4c:	ec26                	sd	s1,24(sp)
    80000a4e:	e84a                	sd	s2,16(sp)
    80000a50:	e44e                	sd	s3,8(sp)
    80000a52:	e052                	sd	s4,0(sp)
    80000a54:	1800                	addi	s0,sp,48
    80000a56:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000a58:	84aa                	mv	s1,a0
    80000a5a:	6905                	lui	s2,0x1
    80000a5c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a5e:	4985                	li	s3,1
    80000a60:	a829                	j	80000a7a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a62:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a64:	00c79513          	slli	a0,a5,0xc
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	fde080e7          	jalr	-34(ra) # 80000a46 <freewalk>
      pagetable[i] = 0;
    80000a70:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000a74:	04a1                	addi	s1,s1,8
    80000a76:	03248163          	beq	s1,s2,80000a98 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a7a:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a7c:	00f7f713          	andi	a4,a5,15
    80000a80:	ff3701e3          	beq	a4,s3,80000a62 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000a84:	8b85                	andi	a5,a5,1
    80000a86:	d7fd                	beqz	a5,80000a74 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6b850513          	addi	a0,a0,1720 # 80008140 <etext+0x140>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	5f2080e7          	jalr	1522(ra) # 80006082 <panic>
    }
  }
  kfree((void *)pagetable);
    80000a98:	8552                	mv	a0,s4
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	5d4080e7          	jalr	1492(ra) # 8000006e <kfree>
}
    80000aa2:	70a2                	ld	ra,40(sp)
    80000aa4:	7402                	ld	s0,32(sp)
    80000aa6:	64e2                	ld	s1,24(sp)
    80000aa8:	6942                	ld	s2,16(sp)
    80000aaa:	69a2                	ld	s3,8(sp)
    80000aac:	6a02                	ld	s4,0(sp)
    80000aae:	6145                	addi	sp,sp,48
    80000ab0:	8082                	ret

0000000080000ab2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000ab2:	1101                	addi	sp,sp,-32
    80000ab4:	ec06                	sd	ra,24(sp)
    80000ab6:	e822                	sd	s0,16(sp)
    80000ab8:	e426                	sd	s1,8(sp)
    80000aba:	1000                	addi	s0,sp,32
    80000abc:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000abe:	e999                	bnez	a1,80000ad4 <uvmfree+0x22>
  freewalk(pagetable);
    80000ac0:	8526                	mv	a0,s1
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f84080e7          	jalr	-124(ra) # 80000a46 <freewalk>
}
    80000aca:	60e2                	ld	ra,24(sp)
    80000acc:	6442                	ld	s0,16(sp)
    80000ace:	64a2                	ld	s1,8(sp)
    80000ad0:	6105                	addi	sp,sp,32
    80000ad2:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000ad4:	6785                	lui	a5,0x1
    80000ad6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	95be                	add	a1,a1,a5
    80000ada:	4685                	li	a3,1
    80000adc:	00c5d613          	srli	a2,a1,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	cea080e7          	jalr	-790(ra) # 800007cc <uvmunmap>
    80000aea:	bfd9                	j	80000ac0 <uvmfree+0xe>

0000000080000aec <uvmcopy>:
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000aec:	715d                	addi	sp,sp,-80
    80000aee:	e486                	sd	ra,72(sp)
    80000af0:	e0a2                	sd	s0,64(sp)
    80000af2:	e45e                	sd	s7,8(sp)
    80000af4:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000af6:	ca79                	beqz	a2,80000bcc <uvmcopy+0xe0>
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	8aaa                	mv	s5,a0
    80000b06:	8a2e                	mv	s4,a1
    80000b08:	89b2                	mv	s3,a2
    80000b0a:	4901                	li	s2,0
    // memmove(mem, (char *)pa, PGSIZE);
    if (mappages(new, i, PGSIZE, pa, flags) != 0) {
      // kfree(mem);
      goto err;
    }
    change_and_get_ref(P_IND(pa), 1);
    80000b0c:	80000b37          	lui	s6,0x80000
    80000b10:	a8a9                	j	80000b6a <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000b12:	00007517          	auipc	a0,0x7
    80000b16:	63e50513          	addi	a0,a0,1598 # 80008150 <etext+0x150>
    80000b1a:	00005097          	auipc	ra,0x5
    80000b1e:	568080e7          	jalr	1384(ra) # 80006082 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000b22:	00007517          	auipc	a0,0x7
    80000b26:	64e50513          	addi	a0,a0,1614 # 80008170 <etext+0x170>
    80000b2a:	00005097          	auipc	ra,0x5
    80000b2e:	558080e7          	jalr	1368(ra) # 80006082 <panic>
    pa = PTE2PA(*pte);
    80000b32:	6118                	ld	a4,0(a0)
    80000b34:	00a75493          	srli	s1,a4,0xa
    80000b38:	04b2                	slli	s1,s1,0xc
    if (mappages(new, i, PGSIZE, pa, flags) != 0) {
    80000b3a:	3ff77713          	andi	a4,a4,1023
    80000b3e:	86a6                	mv	a3,s1
    80000b40:	6605                	lui	a2,0x1
    80000b42:	85ca                	mv	a1,s2
    80000b44:	8552                	mv	a0,s4
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	a9c080e7          	jalr	-1380(ra) # 800005e2 <mappages>
    80000b4e:	8baa                	mv	s7,a0
    80000b50:	e129                	bnez	a0,80000b92 <uvmcopy+0xa6>
    change_and_get_ref(P_IND(pa), 1);
    80000b52:	94da                	add	s1,s1,s6
    80000b54:	4585                	li	a1,1
    80000b56:	00c4d513          	srli	a0,s1,0xc
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	4c2080e7          	jalr	1218(ra) # 8000001c <change_and_get_ref>
  for (i = 0; i < sz; i += PGSIZE) {
    80000b62:	6785                	lui	a5,0x1
    80000b64:	993e                	add	s2,s2,a5
    80000b66:	05397c63          	bgeu	s2,s3,80000bbe <uvmcopy+0xd2>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000b6a:	4601                	li	a2,0
    80000b6c:	85ca                	mv	a1,s2
    80000b6e:	8556                	mv	a0,s5
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	98a080e7          	jalr	-1654(ra) # 800004fa <walk>
    80000b78:	dd49                	beqz	a0,80000b12 <uvmcopy+0x26>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000b7a:	611c                	ld	a5,0(a0)
    80000b7c:	0017f713          	andi	a4,a5,1
    80000b80:	d34d                	beqz	a4,80000b22 <uvmcopy+0x36>
    if (*pte & PTE_W) {
    80000b82:	0047f713          	andi	a4,a5,4
    80000b86:	d755                	beqz	a4,80000b32 <uvmcopy+0x46>
      *pte &= (~PTE_W);
    80000b88:	9bed                	andi	a5,a5,-5
      *pte |= PTE_C;
    80000b8a:	1007e793          	ori	a5,a5,256
    80000b8e:	e11c                	sd	a5,0(a0)
    80000b90:	b74d                	j	80000b32 <uvmcopy+0x46>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b92:	4685                	li	a3,1
    80000b94:	00c95613          	srli	a2,s2,0xc
    80000b98:	4581                	li	a1,0
    80000b9a:	8552                	mv	a0,s4
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	c30080e7          	jalr	-976(ra) # 800007cc <uvmunmap>
  return -1;
    80000ba4:	5bfd                	li	s7,-1
    80000ba6:	74e2                	ld	s1,56(sp)
    80000ba8:	7942                	ld	s2,48(sp)
    80000baa:	79a2                	ld	s3,40(sp)
    80000bac:	7a02                	ld	s4,32(sp)
    80000bae:	6ae2                	ld	s5,24(sp)
    80000bb0:	6b42                	ld	s6,16(sp)
}
    80000bb2:	855e                	mv	a0,s7
    80000bb4:	60a6                	ld	ra,72(sp)
    80000bb6:	6406                	ld	s0,64(sp)
    80000bb8:	6ba2                	ld	s7,8(sp)
    80000bba:	6161                	addi	sp,sp,80
    80000bbc:	8082                	ret
    80000bbe:	74e2                	ld	s1,56(sp)
    80000bc0:	7942                	ld	s2,48(sp)
    80000bc2:	79a2                	ld	s3,40(sp)
    80000bc4:	7a02                	ld	s4,32(sp)
    80000bc6:	6ae2                	ld	s5,24(sp)
    80000bc8:	6b42                	ld	s6,16(sp)
    80000bca:	b7e5                	j	80000bb2 <uvmcopy+0xc6>
  return 0;
    80000bcc:	4b81                	li	s7,0
    80000bce:	b7d5                	j	80000bb2 <uvmcopy+0xc6>

0000000080000bd0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000bd0:	1141                	addi	sp,sp,-16
    80000bd2:	e406                	sd	ra,8(sp)
    80000bd4:	e022                	sd	s0,0(sp)
    80000bd6:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000bd8:	4601                	li	a2,0
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	920080e7          	jalr	-1760(ra) # 800004fa <walk>
  if (pte == 0) panic("uvmclear");
    80000be2:	c901                	beqz	a0,80000bf2 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000be4:	611c                	ld	a5,0(a0)
    80000be6:	9bbd                	andi	a5,a5,-17
    80000be8:	e11c                	sd	a5,0(a0)
}
    80000bea:	60a2                	ld	ra,8(sp)
    80000bec:	6402                	ld	s0,0(sp)
    80000bee:	0141                	addi	sp,sp,16
    80000bf0:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000bf2:	00007517          	auipc	a0,0x7
    80000bf6:	59e50513          	addi	a0,a0,1438 # 80008190 <etext+0x190>
    80000bfa:	00005097          	auipc	ra,0x5
    80000bfe:	488080e7          	jalr	1160(ra) # 80006082 <panic>

0000000080000c02 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0) {
    80000c02:	c2d5                	beqz	a3,80000ca6 <copyout+0xa4>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000c04:	711d                	addi	sp,sp,-96
    80000c06:	ec86                	sd	ra,88(sp)
    80000c08:	e8a2                	sd	s0,80(sp)
    80000c0a:	e4a6                	sd	s1,72(sp)
    80000c0c:	fc4e                	sd	s3,56(sp)
    80000c0e:	f456                	sd	s5,40(sp)
    80000c10:	f05a                	sd	s6,32(sp)
    80000c12:	ec5e                	sd	s7,24(sp)
    80000c14:	1080                	addi	s0,sp,96
    80000c16:	8baa                	mv	s7,a0
    80000c18:	8aae                	mv	s5,a1
    80000c1a:	8b32                	mv	s6,a2
    80000c1c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c1e:	74fd                	lui	s1,0xfffff
    80000c20:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000c22:	57fd                	li	a5,-1
    80000c24:	83e9                	srli	a5,a5,0x1a
    80000c26:	0897e263          	bltu	a5,s1,80000caa <copyout+0xa8>
    80000c2a:	e0ca                	sd	s2,64(sp)
    80000c2c:	f852                	sd	s4,48(sp)
    80000c2e:	e862                	sd	s8,16(sp)
    80000c30:	e466                	sd	s9,8(sp)
    80000c32:	e06a                	sd	s10,0(sp)

    if (copyonwrite(pagetable, va0) == -1) {
    80000c34:	5c7d                	li	s8,-1
    80000c36:	6c85                	lui	s9,0x1
    if (va0 >= MAXVA) return -1;
    80000c38:	8d3e                	mv	s10,a5
    80000c3a:	a03d                	j	80000c68 <copyout+0x66>

    if ((pte = walk(pagetable, va0, 0)) == 0) {
      return -1;
    }

    pa0 = PTE2PA(*pte);
    80000c3c:	611c                	ld	a5,0(a0)
    80000c3e:	83a9                	srli	a5,a5,0xa
    80000c40:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c42:	409a8533          	sub	a0,s5,s1
    80000c46:	0009061b          	sext.w	a2,s2
    80000c4a:	85da                	mv	a1,s6
    80000c4c:	953e                	add	a0,a0,a5
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	62c080e7          	jalr	1580(ra) # 8000027a <memmove>

    len -= n;
    80000c56:	412989b3          	sub	s3,s3,s2
    src += n;
    80000c5a:	9b4a                	add	s6,s6,s2
  while (len > 0) {
    80000c5c:	02098e63          	beqz	s3,80000c98 <copyout+0x96>
    if (va0 >= MAXVA) return -1;
    80000c60:	054d6763          	bltu	s10,s4,80000cae <copyout+0xac>
    80000c64:	84d2                	mv	s1,s4
    80000c66:	8ad2                	mv	s5,s4
    if (copyonwrite(pagetable, va0) == -1) {
    80000c68:	85a6                	mv	a1,s1
    80000c6a:	855e                	mv	a0,s7
    80000c6c:	00001097          	auipc	ra,0x1
    80000c70:	0f2080e7          	jalr	242(ra) # 80001d5e <copyonwrite>
    80000c74:	05850b63          	beq	a0,s8,80000cca <copyout+0xc8>
    if ((pte = walk(pagetable, va0, 0)) == 0) {
    80000c78:	4601                	li	a2,0
    80000c7a:	85a6                	mv	a1,s1
    80000c7c:	855e                	mv	a0,s7
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87c080e7          	jalr	-1924(ra) # 800004fa <walk>
    80000c86:	c91d                	beqz	a0,80000cbc <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000c88:	01948a33          	add	s4,s1,s9
    80000c8c:	415a0933          	sub	s2,s4,s5
    if (n > len) n = len;
    80000c90:	fb29f6e3          	bgeu	s3,s2,80000c3c <copyout+0x3a>
    80000c94:	894e                	mv	s2,s3
    80000c96:	b75d                	j	80000c3c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000c98:	4501                	li	a0,0
    80000c9a:	6906                	ld	s2,64(sp)
    80000c9c:	7a42                	ld	s4,48(sp)
    80000c9e:	6c42                	ld	s8,16(sp)
    80000ca0:	6ca2                	ld	s9,8(sp)
    80000ca2:	6d02                	ld	s10,0(sp)
    80000ca4:	a805                	j	80000cd4 <copyout+0xd2>
    80000ca6:	4501                	li	a0,0
}
    80000ca8:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000caa:	557d                	li	a0,-1
    80000cac:	a025                	j	80000cd4 <copyout+0xd2>
    80000cae:	557d                	li	a0,-1
    80000cb0:	6906                	ld	s2,64(sp)
    80000cb2:	7a42                	ld	s4,48(sp)
    80000cb4:	6c42                	ld	s8,16(sp)
    80000cb6:	6ca2                	ld	s9,8(sp)
    80000cb8:	6d02                	ld	s10,0(sp)
    80000cba:	a829                	j	80000cd4 <copyout+0xd2>
      return -1;
    80000cbc:	557d                	li	a0,-1
    80000cbe:	6906                	ld	s2,64(sp)
    80000cc0:	7a42                	ld	s4,48(sp)
    80000cc2:	6c42                	ld	s8,16(sp)
    80000cc4:	6ca2                	ld	s9,8(sp)
    80000cc6:	6d02                	ld	s10,0(sp)
    80000cc8:	a031                	j	80000cd4 <copyout+0xd2>
    80000cca:	6906                	ld	s2,64(sp)
    80000ccc:	7a42                	ld	s4,48(sp)
    80000cce:	6c42                	ld	s8,16(sp)
    80000cd0:	6ca2                	ld	s9,8(sp)
    80000cd2:	6d02                	ld	s10,0(sp)
}
    80000cd4:	60e6                	ld	ra,88(sp)
    80000cd6:	6446                	ld	s0,80(sp)
    80000cd8:	64a6                	ld	s1,72(sp)
    80000cda:	79e2                	ld	s3,56(sp)
    80000cdc:	7aa2                	ld	s5,40(sp)
    80000cde:	7b02                	ld	s6,32(sp)
    80000ce0:	6be2                	ld	s7,24(sp)
    80000ce2:	6125                	addi	sp,sp,96
    80000ce4:	8082                	ret

0000000080000ce6 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000ce6:	caa5                	beqz	a3,80000d56 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000ce8:	715d                	addi	sp,sp,-80
    80000cea:	e486                	sd	ra,72(sp)
    80000cec:	e0a2                	sd	s0,64(sp)
    80000cee:	fc26                	sd	s1,56(sp)
    80000cf0:	f84a                	sd	s2,48(sp)
    80000cf2:	f44e                	sd	s3,40(sp)
    80000cf4:	f052                	sd	s4,32(sp)
    80000cf6:	ec56                	sd	s5,24(sp)
    80000cf8:	e85a                	sd	s6,16(sp)
    80000cfa:	e45e                	sd	s7,8(sp)
    80000cfc:	e062                	sd	s8,0(sp)
    80000cfe:	0880                	addi	s0,sp,80
    80000d00:	8b2a                	mv	s6,a0
    80000d02:	8a2e                	mv	s4,a1
    80000d04:	8c32                	mv	s8,a2
    80000d06:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d08:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000d0a:	6a85                	lui	s5,0x1
    80000d0c:	a01d                	j	80000d32 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d0e:	018505b3          	add	a1,a0,s8
    80000d12:	0004861b          	sext.w	a2,s1
    80000d16:	412585b3          	sub	a1,a1,s2
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	55e080e7          	jalr	1374(ra) # 8000027a <memmove>

    len -= n;
    80000d24:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d28:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d2a:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000d2e:	02098263          	beqz	s3,80000d52 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d32:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d36:	85ca                	mv	a1,s2
    80000d38:	855a                	mv	a0,s6
    80000d3a:	00000097          	auipc	ra,0x0
    80000d3e:	866080e7          	jalr	-1946(ra) # 800005a0 <walkaddr>
    if (pa0 == 0) return -1;
    80000d42:	cd01                	beqz	a0,80000d5a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d44:	418904b3          	sub	s1,s2,s8
    80000d48:	94d6                	add	s1,s1,s5
    if (n > len) n = len;
    80000d4a:	fc99f2e3          	bgeu	s3,s1,80000d0e <copyin+0x28>
    80000d4e:	84ce                	mv	s1,s3
    80000d50:	bf7d                	j	80000d0e <copyin+0x28>
  }
  return 0;
    80000d52:	4501                	li	a0,0
    80000d54:	a021                	j	80000d5c <copyin+0x76>
    80000d56:	4501                	li	a0,0
}
    80000d58:	8082                	ret
    if (pa0 == 0) return -1;
    80000d5a:	557d                	li	a0,-1
}
    80000d5c:	60a6                	ld	ra,72(sp)
    80000d5e:	6406                	ld	s0,64(sp)
    80000d60:	74e2                	ld	s1,56(sp)
    80000d62:	7942                	ld	s2,48(sp)
    80000d64:	79a2                	ld	s3,40(sp)
    80000d66:	7a02                	ld	s4,32(sp)
    80000d68:	6ae2                	ld	s5,24(sp)
    80000d6a:	6b42                	ld	s6,16(sp)
    80000d6c:	6ba2                	ld	s7,8(sp)
    80000d6e:	6c02                	ld	s8,0(sp)
    80000d70:	6161                	addi	sp,sp,80
    80000d72:	8082                	ret

0000000080000d74 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000d74:	cacd                	beqz	a3,80000e26 <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000d76:	715d                	addi	sp,sp,-80
    80000d78:	e486                	sd	ra,72(sp)
    80000d7a:	e0a2                	sd	s0,64(sp)
    80000d7c:	fc26                	sd	s1,56(sp)
    80000d7e:	f84a                	sd	s2,48(sp)
    80000d80:	f44e                	sd	s3,40(sp)
    80000d82:	f052                	sd	s4,32(sp)
    80000d84:	ec56                	sd	s5,24(sp)
    80000d86:	e85a                	sd	s6,16(sp)
    80000d88:	e45e                	sd	s7,8(sp)
    80000d8a:	0880                	addi	s0,sp,80
    80000d8c:	8a2a                	mv	s4,a0
    80000d8e:	8b2e                	mv	s6,a1
    80000d90:	8bb2                	mv	s7,a2
    80000d92:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d94:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000d96:	6985                	lui	s3,0x1
    80000d98:	a825                	j	80000dd0 <copyinstr+0x5c>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000d9a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d9e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000da0:	37fd                	addiw	a5,a5,-1
    80000da2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000da6:	60a6                	ld	ra,72(sp)
    80000da8:	6406                	ld	s0,64(sp)
    80000daa:	74e2                	ld	s1,56(sp)
    80000dac:	7942                	ld	s2,48(sp)
    80000dae:	79a2                	ld	s3,40(sp)
    80000db0:	7a02                	ld	s4,32(sp)
    80000db2:	6ae2                	ld	s5,24(sp)
    80000db4:	6b42                	ld	s6,16(sp)
    80000db6:	6ba2                	ld	s7,8(sp)
    80000db8:	6161                	addi	sp,sp,80
    80000dba:	8082                	ret
    80000dbc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000dc0:	9742                	add	a4,a4,a6
      --max;
    80000dc2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000dc6:	01348bb3          	add	s7,s1,s3
  while (got_null == 0 && max > 0) {
    80000dca:	04e58663          	beq	a1,a4,80000e16 <copyinstr+0xa2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000dce:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000dd0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dd4:	85a6                	mv	a1,s1
    80000dd6:	8552                	mv	a0,s4
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	7c8080e7          	jalr	1992(ra) # 800005a0 <walkaddr>
    if (pa0 == 0) return -1;
    80000de0:	cd0d                	beqz	a0,80000e1a <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000de2:	417486b3          	sub	a3,s1,s7
    80000de6:	96ce                	add	a3,a3,s3
    if (n > max) n = max;
    80000de8:	00d97363          	bgeu	s2,a3,80000dee <copyinstr+0x7a>
    80000dec:	86ca                	mv	a3,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80000dee:	955e                	add	a0,a0,s7
    80000df0:	8d05                	sub	a0,a0,s1
    while (n > 0) {
    80000df2:	c695                	beqz	a3,80000e1e <copyinstr+0xaa>
    80000df4:	87da                	mv	a5,s6
    80000df6:	885a                	mv	a6,s6
      if (*p == '\0') {
    80000df8:	41650633          	sub	a2,a0,s6
    while (n > 0) {
    80000dfc:	96da                	add	a3,a3,s6
    80000dfe:	85be                	mv	a1,a5
      if (*p == '\0') {
    80000e00:	00f60733          	add	a4,a2,a5
    80000e04:	00074703          	lbu	a4,0(a4)
    80000e08:	db49                	beqz	a4,80000d9a <copyinstr+0x26>
        *dst = *p;
    80000e0a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000e0e:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000e10:	fed797e3          	bne	a5,a3,80000dfe <copyinstr+0x8a>
    80000e14:	b765                	j	80000dbc <copyinstr+0x48>
    80000e16:	4781                	li	a5,0
    80000e18:	b761                	j	80000da0 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000e1a:	557d                	li	a0,-1
    80000e1c:	b769                	j	80000da6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000e1e:	6b85                	lui	s7,0x1
    80000e20:	9ba6                	add	s7,s7,s1
    80000e22:	87da                	mv	a5,s6
    80000e24:	b76d                	j	80000dce <copyinstr+0x5a>
  int got_null = 0;
    80000e26:	4781                	li	a5,0
  if (got_null) {
    80000e28:	37fd                	addiw	a5,a5,-1
    80000e2a:	0007851b          	sext.w	a0,a5
}
    80000e2e:	8082                	ret

0000000080000e30 <pte_print>:

void pte_print(pagetable_t pagetable, int level) {
    80000e30:	711d                	addi	sp,sp,-96
    80000e32:	ec86                	sd	ra,88(sp)
    80000e34:	e8a2                	sd	s0,80(sp)
    80000e36:	e4a6                	sd	s1,72(sp)
    80000e38:	e0ca                	sd	s2,64(sp)
    80000e3a:	fc4e                	sd	s3,56(sp)
    80000e3c:	f852                	sd	s4,48(sp)
    80000e3e:	f456                	sd	s5,40(sp)
    80000e40:	f05a                	sd	s6,32(sp)
    80000e42:	ec5e                	sd	s7,24(sp)
    80000e44:	e862                	sd	s8,16(sp)
    80000e46:	e466                	sd	s9,8(sp)
    80000e48:	e06a                	sd	s10,0(sp)
    80000e4a:	1080                	addi	s0,sp,96
    80000e4c:	8aae                	mv	s5,a1
  for (int i = 0; i < 512; i++) {
    80000e4e:	8a2a                	mv	s4,a0
    80000e50:	4981                	li	s3,0
    if (pte & PTE_V) {
      uint64 child = PTE2PA(pte);
      for (int j = 0; j < level; j++) {
        printf(" ..");
      }
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000e52:	00007c17          	auipc	s8,0x7
    80000e56:	356c0c13          	addi	s8,s8,854 # 800081a8 <etext+0x1a8>
      for (int j = 0; j < level; j++) {
    80000e5a:	4c81                	li	s9,0
        printf(" ..");
    80000e5c:	00007b17          	auipc	s6,0x7
    80000e60:	344b0b13          	addi	s6,s6,836 # 800081a0 <etext+0x1a0>
  for (int i = 0; i < 512; i++) {
    80000e64:	20000b93          	li	s7,512
    80000e68:	a029                	j	80000e72 <pte_print+0x42>
    80000e6a:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000e6c:	0a21                	addi	s4,s4,8
    80000e6e:	05798963          	beq	s3,s7,80000ec0 <pte_print+0x90>
    pte_t pte = pagetable[i];
    80000e72:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V) {
    80000e76:	00197793          	andi	a5,s2,1
    80000e7a:	dbe5                	beqz	a5,80000e6a <pte_print+0x3a>
      uint64 child = PTE2PA(pte);
    80000e7c:	00a95d13          	srli	s10,s2,0xa
    80000e80:	0d32                	slli	s10,s10,0xc
      for (int j = 0; j < level; j++) {
    80000e82:	01505b63          	blez	s5,80000e98 <pte_print+0x68>
    80000e86:	84e6                	mv	s1,s9
        printf(" ..");
    80000e88:	855a                	mv	a0,s6
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	242080e7          	jalr	578(ra) # 800060cc <printf>
      for (int j = 0; j < level; j++) {
    80000e92:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffba7e1>
    80000e94:	fe9a9ae3          	bne	s5,s1,80000e88 <pte_print+0x58>
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000e98:	86ea                	mv	a3,s10
    80000e9a:	864a                	mv	a2,s2
    80000e9c:	85ce                	mv	a1,s3
    80000e9e:	8562                	mv	a0,s8
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	22c080e7          	jalr	556(ra) # 800060cc <printf>
      if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000ea8:	00e97913          	andi	s2,s2,14
    80000eac:	fa091fe3          	bnez	s2,80000e6a <pte_print+0x3a>
        pte_print((pagetable_t)child, level + 1);
    80000eb0:	001a859b          	addiw	a1,s5,1 # fffffffffffff001 <end+0xffffffff7ffba7e1>
    80000eb4:	856a                	mv	a0,s10
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	f7a080e7          	jalr	-134(ra) # 80000e30 <pte_print>
    80000ebe:	b775                	j	80000e6a <pte_print+0x3a>
      }
    }
  }
}
    80000ec0:	60e6                	ld	ra,88(sp)
    80000ec2:	6446                	ld	s0,80(sp)
    80000ec4:	64a6                	ld	s1,72(sp)
    80000ec6:	6906                	ld	s2,64(sp)
    80000ec8:	79e2                	ld	s3,56(sp)
    80000eca:	7a42                	ld	s4,48(sp)
    80000ecc:	7aa2                	ld	s5,40(sp)
    80000ece:	7b02                	ld	s6,32(sp)
    80000ed0:	6be2                	ld	s7,24(sp)
    80000ed2:	6c42                	ld	s8,16(sp)
    80000ed4:	6ca2                	ld	s9,8(sp)
    80000ed6:	6d02                	ld	s10,0(sp)
    80000ed8:	6125                	addi	sp,sp,96
    80000eda:	8082                	ret

0000000080000edc <vmprint>:

void vmprint(pagetable_t pagetable) {
    80000edc:	1101                	addi	sp,sp,-32
    80000ede:	ec06                	sd	ra,24(sp)
    80000ee0:	e822                	sd	s0,16(sp)
    80000ee2:	e426                	sd	s1,8(sp)
    80000ee4:	1000                	addi	s0,sp,32
    80000ee6:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000ee8:	85aa                	mv	a1,a0
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	2d650513          	addi	a0,a0,726 # 800081c0 <etext+0x1c0>
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	1da080e7          	jalr	474(ra) # 800060cc <printf>
  pte_print(pagetable, 1);
    80000efa:	4585                	li	a1,1
    80000efc:	8526                	mv	a0,s1
    80000efe:	00000097          	auipc	ra,0x0
    80000f02:	f32080e7          	jalr	-206(ra) # 80000e30 <pte_print>
}
    80000f06:	60e2                	ld	ra,24(sp)
    80000f08:	6442                	ld	s0,16(sp)
    80000f0a:	64a2                	ld	s1,8(sp)
    80000f0c:	6105                	addi	sp,sp,32
    80000f0e:	8082                	ret

0000000080000f10 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000f10:	7139                	addi	sp,sp,-64
    80000f12:	fc06                	sd	ra,56(sp)
    80000f14:	f822                	sd	s0,48(sp)
    80000f16:	f426                	sd	s1,40(sp)
    80000f18:	f04a                	sd	s2,32(sp)
    80000f1a:	ec4e                	sd	s3,24(sp)
    80000f1c:	e852                	sd	s4,16(sp)
    80000f1e:	e456                	sd	s5,8(sp)
    80000f20:	e05a                	sd	s6,0(sp)
    80000f22:	0080                	addi	s0,sp,64
    80000f24:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000f26:	0002b497          	auipc	s1,0x2b
    80000f2a:	8d248493          	addi	s1,s1,-1838 # 8002b7f8 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000f2e:	8b26                	mv	s6,s1
    80000f30:	04fa5937          	lui	s2,0x4fa5
    80000f34:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000f38:	0932                	slli	s2,s2,0xc
    80000f3a:	fa590913          	addi	s2,s2,-91
    80000f3e:	0932                	slli	s2,s2,0xc
    80000f40:	fa590913          	addi	s2,s2,-91
    80000f44:	0932                	slli	s2,s2,0xc
    80000f46:	fa590913          	addi	s2,s2,-91
    80000f4a:	040009b7          	lui	s3,0x4000
    80000f4e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f50:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000f52:	00030a97          	auipc	s5,0x30
    80000f56:	2a6a8a93          	addi	s5,s5,678 # 800311f8 <tickslock>
    char *pa = kalloc();
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	24a080e7          	jalr	586(ra) # 800001a4 <kalloc>
    80000f62:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000f64:	c121                	beqz	a0,80000fa4 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80000f66:	416485b3          	sub	a1,s1,s6
    80000f6a:	858d                	srai	a1,a1,0x3
    80000f6c:	032585b3          	mul	a1,a1,s2
    80000f70:	2585                	addiw	a1,a1,1
    80000f72:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f76:	4719                	li	a4,6
    80000f78:	6685                	lui	a3,0x1
    80000f7a:	40b985b3          	sub	a1,s3,a1
    80000f7e:	8552                	mv	a0,s4
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	726080e7          	jalr	1830(ra) # 800006a6 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000f88:	16848493          	addi	s1,s1,360
    80000f8c:	fd5497e3          	bne	s1,s5,80000f5a <proc_mapstacks+0x4a>
  }
}
    80000f90:	70e2                	ld	ra,56(sp)
    80000f92:	7442                	ld	s0,48(sp)
    80000f94:	74a2                	ld	s1,40(sp)
    80000f96:	7902                	ld	s2,32(sp)
    80000f98:	69e2                	ld	s3,24(sp)
    80000f9a:	6a42                	ld	s4,16(sp)
    80000f9c:	6aa2                	ld	s5,8(sp)
    80000f9e:	6b02                	ld	s6,0(sp)
    80000fa0:	6121                	addi	sp,sp,64
    80000fa2:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000fa4:	00007517          	auipc	a0,0x7
    80000fa8:	22c50513          	addi	a0,a0,556 # 800081d0 <etext+0x1d0>
    80000fac:	00005097          	auipc	ra,0x5
    80000fb0:	0d6080e7          	jalr	214(ra) # 80006082 <panic>

0000000080000fb4 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000fb4:	7139                	addi	sp,sp,-64
    80000fb6:	fc06                	sd	ra,56(sp)
    80000fb8:	f822                	sd	s0,48(sp)
    80000fba:	f426                	sd	s1,40(sp)
    80000fbc:	f04a                	sd	s2,32(sp)
    80000fbe:	ec4e                	sd	s3,24(sp)
    80000fc0:	e852                	sd	s4,16(sp)
    80000fc2:	e456                	sd	s5,8(sp)
    80000fc4:	e05a                	sd	s6,0(sp)
    80000fc6:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000fc8:	00007597          	auipc	a1,0x7
    80000fcc:	21058593          	addi	a1,a1,528 # 800081d8 <etext+0x1d8>
    80000fd0:	0002a517          	auipc	a0,0x2a
    80000fd4:	3f850513          	addi	a0,a0,1016 # 8002b3c8 <pid_lock>
    80000fd8:	00005097          	auipc	ra,0x5
    80000fdc:	594080e7          	jalr	1428(ra) # 8000656c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fe0:	00007597          	auipc	a1,0x7
    80000fe4:	20058593          	addi	a1,a1,512 # 800081e0 <etext+0x1e0>
    80000fe8:	0002a517          	auipc	a0,0x2a
    80000fec:	3f850513          	addi	a0,a0,1016 # 8002b3e0 <wait_lock>
    80000ff0:	00005097          	auipc	ra,0x5
    80000ff4:	57c080e7          	jalr	1404(ra) # 8000656c <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ff8:	0002b497          	auipc	s1,0x2b
    80000ffc:	80048493          	addi	s1,s1,-2048 # 8002b7f8 <proc>
    initlock(&p->lock, "proc");
    80001000:	00007b17          	auipc	s6,0x7
    80001004:	1f0b0b13          	addi	s6,s6,496 # 800081f0 <etext+0x1f0>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001008:	8aa6                	mv	s5,s1
    8000100a:	04fa5937          	lui	s2,0x4fa5
    8000100e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001012:	0932                	slli	s2,s2,0xc
    80001014:	fa590913          	addi	s2,s2,-91
    80001018:	0932                	slli	s2,s2,0xc
    8000101a:	fa590913          	addi	s2,s2,-91
    8000101e:	0932                	slli	s2,s2,0xc
    80001020:	fa590913          	addi	s2,s2,-91
    80001024:	040009b7          	lui	s3,0x4000
    80001028:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000102a:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000102c:	00030a17          	auipc	s4,0x30
    80001030:	1cca0a13          	addi	s4,s4,460 # 800311f8 <tickslock>
    initlock(&p->lock, "proc");
    80001034:	85da                	mv	a1,s6
    80001036:	8526                	mv	a0,s1
    80001038:	00005097          	auipc	ra,0x5
    8000103c:	534080e7          	jalr	1332(ra) # 8000656c <initlock>
    p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001044:	415487b3          	sub	a5,s1,s5
    80001048:	878d                	srai	a5,a5,0x3
    8000104a:	032787b3          	mul	a5,a5,s2
    8000104e:	2785                	addiw	a5,a5,1
    80001050:	00d7979b          	slliw	a5,a5,0xd
    80001054:	40f987b3          	sub	a5,s3,a5
    80001058:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000105a:	16848493          	addi	s1,s1,360
    8000105e:	fd449be3          	bne	s1,s4,80001034 <procinit+0x80>
  }
}
    80001062:	70e2                	ld	ra,56(sp)
    80001064:	7442                	ld	s0,48(sp)
    80001066:	74a2                	ld	s1,40(sp)
    80001068:	7902                	ld	s2,32(sp)
    8000106a:	69e2                	ld	s3,24(sp)
    8000106c:	6a42                	ld	s4,16(sp)
    8000106e:	6aa2                	ld	s5,8(sp)
    80001070:	6b02                	ld	s6,0(sp)
    80001072:	6121                	addi	sp,sp,64
    80001074:	8082                	ret

0000000080001076 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80001076:	1141                	addi	sp,sp,-16
    80001078:	e422                	sd	s0,8(sp)
    8000107a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    8000107c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000107e:	2501                	sext.w	a0,a0
    80001080:	6422                	ld	s0,8(sp)
    80001082:	0141                	addi	sp,sp,16
    80001084:	8082                	ret

0000000080001086 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80001086:	1141                	addi	sp,sp,-16
    80001088:	e422                	sd	s0,8(sp)
    8000108a:	0800                	addi	s0,sp,16
    8000108c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000108e:	2781                	sext.w	a5,a5
    80001090:	079e                	slli	a5,a5,0x7
  return c;
}
    80001092:	0002a517          	auipc	a0,0x2a
    80001096:	36650513          	addi	a0,a0,870 # 8002b3f8 <cpus>
    8000109a:	953e                	add	a0,a0,a5
    8000109c:	6422                	ld	s0,8(sp)
    8000109e:	0141                	addi	sp,sp,16
    800010a0:	8082                	ret

00000000800010a2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    800010a2:	1101                	addi	sp,sp,-32
    800010a4:	ec06                	sd	ra,24(sp)
    800010a6:	e822                	sd	s0,16(sp)
    800010a8:	e426                	sd	s1,8(sp)
    800010aa:	1000                	addi	s0,sp,32
  push_off();
    800010ac:	00005097          	auipc	ra,0x5
    800010b0:	504080e7          	jalr	1284(ra) # 800065b0 <push_off>
    800010b4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010b6:	2781                	sext.w	a5,a5
    800010b8:	079e                	slli	a5,a5,0x7
    800010ba:	0002a717          	auipc	a4,0x2a
    800010be:	30e70713          	addi	a4,a4,782 # 8002b3c8 <pid_lock>
    800010c2:	97ba                	add	a5,a5,a4
    800010c4:	7b84                	ld	s1,48(a5)
  pop_off();
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	58a080e7          	jalr	1418(ra) # 80006650 <pop_off>
  return p;
}
    800010ce:	8526                	mv	a0,s1
    800010d0:	60e2                	ld	ra,24(sp)
    800010d2:	6442                	ld	s0,16(sp)
    800010d4:	64a2                	ld	s1,8(sp)
    800010d6:	6105                	addi	sp,sp,32
    800010d8:	8082                	ret

00000000800010da <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    800010da:	1141                	addi	sp,sp,-16
    800010dc:	e406                	sd	ra,8(sp)
    800010de:	e022                	sd	s0,0(sp)
    800010e0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	fc0080e7          	jalr	-64(ra) # 800010a2 <myproc>
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	5c6080e7          	jalr	1478(ra) # 800066b0 <release>

  if (first) {
    800010f2:	0000a797          	auipc	a5,0xa
    800010f6:	1fe7a783          	lw	a5,510(a5) # 8000b2f0 <first.1>
    800010fa:	eb89                	bnez	a5,8000110c <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800010fc:	00001097          	auipc	ra,0x1
    80001100:	d74080e7          	jalr	-652(ra) # 80001e70 <usertrapret>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    fsinit(ROOTDEV);
    8000110c:	4505                	li	a0,1
    8000110e:	00002097          	auipc	ra,0x2
    80001112:	b08080e7          	jalr	-1272(ra) # 80002c16 <fsinit>
    first = 0;
    80001116:	0000a797          	auipc	a5,0xa
    8000111a:	1c07ad23          	sw	zero,474(a5) # 8000b2f0 <first.1>
    __sync_synchronize();
    8000111e:	0330000f          	fence	rw,rw
    80001122:	bfe9                	j	800010fc <forkret+0x22>

0000000080001124 <allocpid>:
int allocpid() {
    80001124:	1101                	addi	sp,sp,-32
    80001126:	ec06                	sd	ra,24(sp)
    80001128:	e822                	sd	s0,16(sp)
    8000112a:	e426                	sd	s1,8(sp)
    8000112c:	e04a                	sd	s2,0(sp)
    8000112e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001130:	0002a917          	auipc	s2,0x2a
    80001134:	29890913          	addi	s2,s2,664 # 8002b3c8 <pid_lock>
    80001138:	854a                	mv	a0,s2
    8000113a:	00005097          	auipc	ra,0x5
    8000113e:	4c2080e7          	jalr	1218(ra) # 800065fc <acquire>
  pid = nextpid;
    80001142:	0000a797          	auipc	a5,0xa
    80001146:	1b278793          	addi	a5,a5,434 # 8000b2f4 <nextpid>
    8000114a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000114c:	0014871b          	addiw	a4,s1,1
    80001150:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001152:	854a                	mv	a0,s2
    80001154:	00005097          	auipc	ra,0x5
    80001158:	55c080e7          	jalr	1372(ra) # 800066b0 <release>
}
    8000115c:	8526                	mv	a0,s1
    8000115e:	60e2                	ld	ra,24(sp)
    80001160:	6442                	ld	s0,16(sp)
    80001162:	64a2                	ld	s1,8(sp)
    80001164:	6902                	ld	s2,0(sp)
    80001166:	6105                	addi	sp,sp,32
    80001168:	8082                	ret

000000008000116a <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	e04a                	sd	s2,0(sp)
    80001174:	1000                	addi	s0,sp,32
    80001176:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	728080e7          	jalr	1832(ra) # 800008a0 <uvmcreate>
    80001180:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001182:	c121                	beqz	a0,800011c2 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001184:	4729                	li	a4,10
    80001186:	00006697          	auipc	a3,0x6
    8000118a:	e7a68693          	addi	a3,a3,-390 # 80007000 <_trampoline>
    8000118e:	6605                	lui	a2,0x1
    80001190:	040005b7          	lui	a1,0x4000
    80001194:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001196:	05b2                	slli	a1,a1,0xc
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	44a080e7          	jalr	1098(ra) # 800005e2 <mappages>
    800011a0:	02054863          	bltz	a0,800011d0 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    800011a4:	4719                	li	a4,6
    800011a6:	05893683          	ld	a3,88(s2)
    800011aa:	6605                	lui	a2,0x1
    800011ac:	020005b7          	lui	a1,0x2000
    800011b0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011b2:	05b6                	slli	a1,a1,0xd
    800011b4:	8526                	mv	a0,s1
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	42c080e7          	jalr	1068(ra) # 800005e2 <mappages>
    800011be:	02054163          	bltz	a0,800011e0 <proc_pagetable+0x76>
}
    800011c2:	8526                	mv	a0,s1
    800011c4:	60e2                	ld	ra,24(sp)
    800011c6:	6442                	ld	s0,16(sp)
    800011c8:	64a2                	ld	s1,8(sp)
    800011ca:	6902                	ld	s2,0(sp)
    800011cc:	6105                	addi	sp,sp,32
    800011ce:	8082                	ret
    uvmfree(pagetable, 0);
    800011d0:	4581                	li	a1,0
    800011d2:	8526                	mv	a0,s1
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	8de080e7          	jalr	-1826(ra) # 80000ab2 <uvmfree>
    return 0;
    800011dc:	4481                	li	s1,0
    800011de:	b7d5                	j	800011c2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011e0:	4681                	li	a3,0
    800011e2:	4605                	li	a2,1
    800011e4:	040005b7          	lui	a1,0x4000
    800011e8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ea:	05b2                	slli	a1,a1,0xc
    800011ec:	8526                	mv	a0,s1
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	5de080e7          	jalr	1502(ra) # 800007cc <uvmunmap>
    uvmfree(pagetable, 0);
    800011f6:	4581                	li	a1,0
    800011f8:	8526                	mv	a0,s1
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	8b8080e7          	jalr	-1864(ra) # 80000ab2 <uvmfree>
    return 0;
    80001202:	4481                	li	s1,0
    80001204:	bf7d                	j	800011c2 <proc_pagetable+0x58>

0000000080001206 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	e04a                	sd	s2,0(sp)
    80001210:	1000                	addi	s0,sp,32
    80001212:	84aa                	mv	s1,a0
    80001214:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001216:	4681                	li	a3,0
    80001218:	4605                	li	a2,1
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	5aa080e7          	jalr	1450(ra) # 800007cc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000122a:	4681                	li	a3,0
    8000122c:	4605                	li	a2,1
    8000122e:	020005b7          	lui	a1,0x2000
    80001232:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001234:	05b6                	slli	a1,a1,0xd
    80001236:	8526                	mv	a0,s1
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	594080e7          	jalr	1428(ra) # 800007cc <uvmunmap>
  uvmfree(pagetable, sz);
    80001240:	85ca                	mv	a1,s2
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	86e080e7          	jalr	-1938(ra) # 80000ab2 <uvmfree>
}
    8000124c:	60e2                	ld	ra,24(sp)
    8000124e:	6442                	ld	s0,16(sp)
    80001250:	64a2                	ld	s1,8(sp)
    80001252:	6902                	ld	s2,0(sp)
    80001254:	6105                	addi	sp,sp,32
    80001256:	8082                	ret

0000000080001258 <freeproc>:
static void freeproc(struct proc *p) {
    80001258:	1101                	addi	sp,sp,-32
    8000125a:	ec06                	sd	ra,24(sp)
    8000125c:	e822                	sd	s0,16(sp)
    8000125e:	e426                	sd	s1,8(sp)
    80001260:	1000                	addi	s0,sp,32
    80001262:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001264:	6d28                	ld	a0,88(a0)
    80001266:	c509                	beqz	a0,80001270 <freeproc+0x18>
    80001268:	fffff097          	auipc	ra,0xfffff
    8000126c:	e06080e7          	jalr	-506(ra) # 8000006e <kfree>
  p->trapframe = 0;
    80001270:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001274:	68a8                	ld	a0,80(s1)
    80001276:	c511                	beqz	a0,80001282 <freeproc+0x2a>
    80001278:	64ac                	ld	a1,72(s1)
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	f8c080e7          	jalr	-116(ra) # 80001206 <proc_freepagetable>
  p->pagetable = 0;
    80001282:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001286:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000128a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000128e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001292:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001296:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000129a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000129e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800012a2:	0004ac23          	sw	zero,24(s1)
}
    800012a6:	60e2                	ld	ra,24(sp)
    800012a8:	6442                	ld	s0,16(sp)
    800012aa:	64a2                	ld	s1,8(sp)
    800012ac:	6105                	addi	sp,sp,32
    800012ae:	8082                	ret

00000000800012b0 <allocproc>:
static struct proc *allocproc(void) {
    800012b0:	1101                	addi	sp,sp,-32
    800012b2:	ec06                	sd	ra,24(sp)
    800012b4:	e822                	sd	s0,16(sp)
    800012b6:	e426                	sd	s1,8(sp)
    800012b8:	e04a                	sd	s2,0(sp)
    800012ba:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    800012bc:	0002a497          	auipc	s1,0x2a
    800012c0:	53c48493          	addi	s1,s1,1340 # 8002b7f8 <proc>
    800012c4:	00030917          	auipc	s2,0x30
    800012c8:	f3490913          	addi	s2,s2,-204 # 800311f8 <tickslock>
    acquire(&p->lock);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00005097          	auipc	ra,0x5
    800012d2:	32e080e7          	jalr	814(ra) # 800065fc <acquire>
    if (p->state == UNUSED) {
    800012d6:	4c9c                	lw	a5,24(s1)
    800012d8:	cf81                	beqz	a5,800012f0 <allocproc+0x40>
      release(&p->lock);
    800012da:	8526                	mv	a0,s1
    800012dc:	00005097          	auipc	ra,0x5
    800012e0:	3d4080e7          	jalr	980(ra) # 800066b0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800012e4:	16848493          	addi	s1,s1,360
    800012e8:	ff2492e3          	bne	s1,s2,800012cc <allocproc+0x1c>
  return 0;
    800012ec:	4481                	li	s1,0
    800012ee:	a889                	j	80001340 <allocproc+0x90>
  p->pid = allocpid();
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	e34080e7          	jalr	-460(ra) # 80001124 <allocpid>
    800012f8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012fa:	4785                	li	a5,1
    800012fc:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	ea6080e7          	jalr	-346(ra) # 800001a4 <kalloc>
    80001306:	892a                	mv	s2,a0
    80001308:	eca8                	sd	a0,88(s1)
    8000130a:	c131                	beqz	a0,8000134e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	e5c080e7          	jalr	-420(ra) # 8000116a <proc_pagetable>
    80001316:	892a                	mv	s2,a0
    80001318:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    8000131a:	c531                	beqz	a0,80001366 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000131c:	07000613          	li	a2,112
    80001320:	4581                	li	a1,0
    80001322:	06048513          	addi	a0,s1,96
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	ef8080e7          	jalr	-264(ra) # 8000021e <memset>
  p->context.ra = (uint64)forkret;
    8000132e:	00000797          	auipc	a5,0x0
    80001332:	dac78793          	addi	a5,a5,-596 # 800010da <forkret>
    80001336:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001338:	60bc                	ld	a5,64(s1)
    8000133a:	6705                	lui	a4,0x1
    8000133c:	97ba                	add	a5,a5,a4
    8000133e:	f4bc                	sd	a5,104(s1)
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6902                	ld	s2,0(sp)
    8000134a:	6105                	addi	sp,sp,32
    8000134c:	8082                	ret
    freeproc(p);
    8000134e:	8526                	mv	a0,s1
    80001350:	00000097          	auipc	ra,0x0
    80001354:	f08080e7          	jalr	-248(ra) # 80001258 <freeproc>
    release(&p->lock);
    80001358:	8526                	mv	a0,s1
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	356080e7          	jalr	854(ra) # 800066b0 <release>
    return 0;
    80001362:	84ca                	mv	s1,s2
    80001364:	bff1                	j	80001340 <allocproc+0x90>
    freeproc(p);
    80001366:	8526                	mv	a0,s1
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	ef0080e7          	jalr	-272(ra) # 80001258 <freeproc>
    release(&p->lock);
    80001370:	8526                	mv	a0,s1
    80001372:	00005097          	auipc	ra,0x5
    80001376:	33e080e7          	jalr	830(ra) # 800066b0 <release>
    return 0;
    8000137a:	84ca                	mv	s1,s2
    8000137c:	b7d1                	j	80001340 <allocproc+0x90>

000000008000137e <userinit>:
void userinit(void) {
    8000137e:	1101                	addi	sp,sp,-32
    80001380:	ec06                	sd	ra,24(sp)
    80001382:	e822                	sd	s0,16(sp)
    80001384:	e426                	sd	s1,8(sp)
    80001386:	1000                	addi	s0,sp,32
  p = allocproc();
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	f28080e7          	jalr	-216(ra) # 800012b0 <allocproc>
    80001390:	84aa                	mv	s1,a0
  initproc = p;
    80001392:	0000a797          	auipc	a5,0xa
    80001396:	fca7bf23          	sd	a0,-34(a5) # 8000b370 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000139a:	03400613          	li	a2,52
    8000139e:	0000a597          	auipc	a1,0xa
    800013a2:	f6258593          	addi	a1,a1,-158 # 8000b300 <initcode>
    800013a6:	6928                	ld	a0,80(a0)
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	526080e7          	jalr	1318(ra) # 800008ce <uvmfirst>
  p->sz = PGSIZE;
    800013b0:	6785                	lui	a5,0x1
    800013b2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013b4:	6cb8                	ld	a4,88(s1)
    800013b6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013ba:	6cb8                	ld	a4,88(s1)
    800013bc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013be:	4641                	li	a2,16
    800013c0:	00007597          	auipc	a1,0x7
    800013c4:	e3858593          	addi	a1,a1,-456 # 800081f8 <etext+0x1f8>
    800013c8:	15848513          	addi	a0,s1,344
    800013cc:	fffff097          	auipc	ra,0xfffff
    800013d0:	f94080e7          	jalr	-108(ra) # 80000360 <safestrcpy>
  p->cwd = namei("/");
    800013d4:	00007517          	auipc	a0,0x7
    800013d8:	e3450513          	addi	a0,a0,-460 # 80008208 <etext+0x208>
    800013dc:	00002097          	auipc	ra,0x2
    800013e0:	28c080e7          	jalr	652(ra) # 80003668 <namei>
    800013e4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013e8:	478d                	li	a5,3
    800013ea:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013ec:	8526                	mv	a0,s1
    800013ee:	00005097          	auipc	ra,0x5
    800013f2:	2c2080e7          	jalr	706(ra) # 800066b0 <release>
}
    800013f6:	60e2                	ld	ra,24(sp)
    800013f8:	6442                	ld	s0,16(sp)
    800013fa:	64a2                	ld	s1,8(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret

0000000080001400 <growproc>:
int growproc(int n) {
    80001400:	1101                	addi	sp,sp,-32
    80001402:	ec06                	sd	ra,24(sp)
    80001404:	e822                	sd	s0,16(sp)
    80001406:	e426                	sd	s1,8(sp)
    80001408:	e04a                	sd	s2,0(sp)
    8000140a:	1000                	addi	s0,sp,32
    8000140c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	c94080e7          	jalr	-876(ra) # 800010a2 <myproc>
    80001416:	84aa                	mv	s1,a0
  sz = p->sz;
    80001418:	652c                	ld	a1,72(a0)
  if (n > 0) {
    8000141a:	01204c63          	bgtz	s2,80001432 <growproc+0x32>
  } else if (n < 0) {
    8000141e:	02094663          	bltz	s2,8000144a <growproc+0x4a>
  p->sz = sz;
    80001422:	e4ac                	sd	a1,72(s1)
  return 0;
    80001424:	4501                	li	a0,0
}
    80001426:	60e2                	ld	ra,24(sp)
    80001428:	6442                	ld	s0,16(sp)
    8000142a:	64a2                	ld	s1,8(sp)
    8000142c:	6902                	ld	s2,0(sp)
    8000142e:	6105                	addi	sp,sp,32
    80001430:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001432:	4691                	li	a3,4
    80001434:	00b90633          	add	a2,s2,a1
    80001438:	6928                	ld	a0,80(a0)
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	54e080e7          	jalr	1358(ra) # 80000988 <uvmalloc>
    80001442:	85aa                	mv	a1,a0
    80001444:	fd79                	bnez	a0,80001422 <growproc+0x22>
      return -1;
    80001446:	557d                	li	a0,-1
    80001448:	bff9                	j	80001426 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000144a:	00b90633          	add	a2,s2,a1
    8000144e:	6928                	ld	a0,80(a0)
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	4f0080e7          	jalr	1264(ra) # 80000940 <uvmdealloc>
    80001458:	85aa                	mv	a1,a0
    8000145a:	b7e1                	j	80001422 <growproc+0x22>

000000008000145c <fork>:
int fork(void) {
    8000145c:	7139                	addi	sp,sp,-64
    8000145e:	fc06                	sd	ra,56(sp)
    80001460:	f822                	sd	s0,48(sp)
    80001462:	f04a                	sd	s2,32(sp)
    80001464:	e456                	sd	s5,8(sp)
    80001466:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	c3a080e7          	jalr	-966(ra) # 800010a2 <myproc>
    80001470:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001472:	00000097          	auipc	ra,0x0
    80001476:	e3e080e7          	jalr	-450(ra) # 800012b0 <allocproc>
    8000147a:	12050063          	beqz	a0,8000159a <fork+0x13e>
    8000147e:	e852                	sd	s4,16(sp)
    80001480:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001482:	048ab603          	ld	a2,72(s5)
    80001486:	692c                	ld	a1,80(a0)
    80001488:	050ab503          	ld	a0,80(s5)
    8000148c:	fffff097          	auipc	ra,0xfffff
    80001490:	660080e7          	jalr	1632(ra) # 80000aec <uvmcopy>
    80001494:	04054a63          	bltz	a0,800014e8 <fork+0x8c>
    80001498:	f426                	sd	s1,40(sp)
    8000149a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000149c:	048ab783          	ld	a5,72(s5)
    800014a0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014a4:	058ab683          	ld	a3,88(s5)
    800014a8:	87b6                	mv	a5,a3
    800014aa:	058a3703          	ld	a4,88(s4)
    800014ae:	12068693          	addi	a3,a3,288
    800014b2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014b6:	6788                	ld	a0,8(a5)
    800014b8:	6b8c                	ld	a1,16(a5)
    800014ba:	6f90                	ld	a2,24(a5)
    800014bc:	01073023          	sd	a6,0(a4)
    800014c0:	e708                	sd	a0,8(a4)
    800014c2:	eb0c                	sd	a1,16(a4)
    800014c4:	ef10                	sd	a2,24(a4)
    800014c6:	02078793          	addi	a5,a5,32
    800014ca:	02070713          	addi	a4,a4,32
    800014ce:	fed792e3          	bne	a5,a3,800014b2 <fork+0x56>
  np->trapframe->a0 = 0;
    800014d2:	058a3783          	ld	a5,88(s4)
    800014d6:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800014da:	0d0a8493          	addi	s1,s5,208
    800014de:	0d0a0913          	addi	s2,s4,208
    800014e2:	150a8993          	addi	s3,s5,336
    800014e6:	a015                	j	8000150a <fork+0xae>
    freeproc(np);
    800014e8:	8552                	mv	a0,s4
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	d6e080e7          	jalr	-658(ra) # 80001258 <freeproc>
    release(&np->lock);
    800014f2:	8552                	mv	a0,s4
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	1bc080e7          	jalr	444(ra) # 800066b0 <release>
    return -1;
    800014fc:	597d                	li	s2,-1
    800014fe:	6a42                	ld	s4,16(sp)
    80001500:	a071                	j	8000158c <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80001502:	04a1                	addi	s1,s1,8
    80001504:	0921                	addi	s2,s2,8
    80001506:	01348b63          	beq	s1,s3,8000151c <fork+0xc0>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    8000150a:	6088                	ld	a0,0(s1)
    8000150c:	d97d                	beqz	a0,80001502 <fork+0xa6>
    8000150e:	00002097          	auipc	ra,0x2
    80001512:	7d2080e7          	jalr	2002(ra) # 80003ce0 <filedup>
    80001516:	00a93023          	sd	a0,0(s2)
    8000151a:	b7e5                	j	80001502 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000151c:	150ab503          	ld	a0,336(s5)
    80001520:	00002097          	auipc	ra,0x2
    80001524:	93c080e7          	jalr	-1732(ra) # 80002e5c <idup>
    80001528:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000152c:	4641                	li	a2,16
    8000152e:	158a8593          	addi	a1,s5,344
    80001532:	158a0513          	addi	a0,s4,344
    80001536:	fffff097          	auipc	ra,0xfffff
    8000153a:	e2a080e7          	jalr	-470(ra) # 80000360 <safestrcpy>
  pid = np->pid;
    8000153e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001542:	8552                	mv	a0,s4
    80001544:	00005097          	auipc	ra,0x5
    80001548:	16c080e7          	jalr	364(ra) # 800066b0 <release>
  acquire(&wait_lock);
    8000154c:	0002a497          	auipc	s1,0x2a
    80001550:	e9448493          	addi	s1,s1,-364 # 8002b3e0 <wait_lock>
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	0a6080e7          	jalr	166(ra) # 800065fc <acquire>
  np->parent = p;
    8000155e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001562:	8526                	mv	a0,s1
    80001564:	00005097          	auipc	ra,0x5
    80001568:	14c080e7          	jalr	332(ra) # 800066b0 <release>
  acquire(&np->lock);
    8000156c:	8552                	mv	a0,s4
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	08e080e7          	jalr	142(ra) # 800065fc <acquire>
  np->state = RUNNABLE;
    80001576:	478d                	li	a5,3
    80001578:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000157c:	8552                	mv	a0,s4
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	132080e7          	jalr	306(ra) # 800066b0 <release>
  return pid;
    80001586:	74a2                	ld	s1,40(sp)
    80001588:	69e2                	ld	s3,24(sp)
    8000158a:	6a42                	ld	s4,16(sp)
}
    8000158c:	854a                	mv	a0,s2
    8000158e:	70e2                	ld	ra,56(sp)
    80001590:	7442                	ld	s0,48(sp)
    80001592:	7902                	ld	s2,32(sp)
    80001594:	6aa2                	ld	s5,8(sp)
    80001596:	6121                	addi	sp,sp,64
    80001598:	8082                	ret
    return -1;
    8000159a:	597d                	li	s2,-1
    8000159c:	bfc5                	j	8000158c <fork+0x130>

000000008000159e <scheduler>:
void scheduler(void) {
    8000159e:	7139                	addi	sp,sp,-64
    800015a0:	fc06                	sd	ra,56(sp)
    800015a2:	f822                	sd	s0,48(sp)
    800015a4:	f426                	sd	s1,40(sp)
    800015a6:	f04a                	sd	s2,32(sp)
    800015a8:	ec4e                	sd	s3,24(sp)
    800015aa:	e852                	sd	s4,16(sp)
    800015ac:	e456                	sd	s5,8(sp)
    800015ae:	e05a                	sd	s6,0(sp)
    800015b0:	0080                	addi	s0,sp,64
    800015b2:	8792                	mv	a5,tp
  int id = r_tp();
    800015b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015b6:	00779a93          	slli	s5,a5,0x7
    800015ba:	0002a717          	auipc	a4,0x2a
    800015be:	e0e70713          	addi	a4,a4,-498 # 8002b3c8 <pid_lock>
    800015c2:	9756                	add	a4,a4,s5
    800015c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015c8:	0002a717          	auipc	a4,0x2a
    800015cc:	e3870713          	addi	a4,a4,-456 # 8002b400 <cpus+0x8>
    800015d0:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    800015d2:	498d                	li	s3,3
        p->state = RUNNING;
    800015d4:	4b11                	li	s6,4
        c->proc = p;
    800015d6:	079e                	slli	a5,a5,0x7
    800015d8:	0002aa17          	auipc	s4,0x2a
    800015dc:	df0a0a13          	addi	s4,s4,-528 # 8002b3c8 <pid_lock>
    800015e0:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800015e2:	00030917          	auipc	s2,0x30
    800015e6:	c1690913          	addi	s2,s2,-1002 # 800311f8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800015ea:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800015ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800015f2:	10079073          	csrw	sstatus,a5
    800015f6:	0002a497          	auipc	s1,0x2a
    800015fa:	20248493          	addi	s1,s1,514 # 8002b7f8 <proc>
    800015fe:	a811                	j	80001612 <scheduler+0x74>
      release(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	0ae080e7          	jalr	174(ra) # 800066b0 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000160a:	16848493          	addi	s1,s1,360
    8000160e:	fd248ee3          	beq	s1,s2,800015ea <scheduler+0x4c>
      acquire(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	fe8080e7          	jalr	-24(ra) # 800065fc <acquire>
      if (p->state == RUNNABLE) {
    8000161c:	4c9c                	lw	a5,24(s1)
    8000161e:	ff3791e3          	bne	a5,s3,80001600 <scheduler+0x62>
        p->state = RUNNING;
    80001622:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001626:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000162a:	06048593          	addi	a1,s1,96
    8000162e:	8556                	mv	a0,s5
    80001630:	00000097          	auipc	ra,0x0
    80001634:	684080e7          	jalr	1668(ra) # 80001cb4 <swtch>
        c->proc = 0;
    80001638:	020a3823          	sd	zero,48(s4)
    8000163c:	b7d1                	j	80001600 <scheduler+0x62>

000000008000163e <sched>:
void sched(void) {
    8000163e:	7179                	addi	sp,sp,-48
    80001640:	f406                	sd	ra,40(sp)
    80001642:	f022                	sd	s0,32(sp)
    80001644:	ec26                	sd	s1,24(sp)
    80001646:	e84a                	sd	s2,16(sp)
    80001648:	e44e                	sd	s3,8(sp)
    8000164a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	a56080e7          	jalr	-1450(ra) # 800010a2 <myproc>
    80001654:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	f2c080e7          	jalr	-212(ra) # 80006582 <holding>
    8000165e:	c93d                	beqz	a0,800016d4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001660:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    80001662:	2781                	sext.w	a5,a5
    80001664:	079e                	slli	a5,a5,0x7
    80001666:	0002a717          	auipc	a4,0x2a
    8000166a:	d6270713          	addi	a4,a4,-670 # 8002b3c8 <pid_lock>
    8000166e:	97ba                	add	a5,a5,a4
    80001670:	0a87a703          	lw	a4,168(a5)
    80001674:	4785                	li	a5,1
    80001676:	06f71763          	bne	a4,a5,800016e4 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    8000167a:	4c98                	lw	a4,24(s1)
    8000167c:	4791                	li	a5,4
    8000167e:	06f70b63          	beq	a4,a5,800016f4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001682:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001686:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001688:	efb5                	bnez	a5,80001704 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000168a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000168c:	0002a917          	auipc	s2,0x2a
    80001690:	d3c90913          	addi	s2,s2,-708 # 8002b3c8 <pid_lock>
    80001694:	2781                	sext.w	a5,a5
    80001696:	079e                	slli	a5,a5,0x7
    80001698:	97ca                	add	a5,a5,s2
    8000169a:	0ac7a983          	lw	s3,172(a5)
    8000169e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016a0:	2781                	sext.w	a5,a5
    800016a2:	079e                	slli	a5,a5,0x7
    800016a4:	0002a597          	auipc	a1,0x2a
    800016a8:	d5c58593          	addi	a1,a1,-676 # 8002b400 <cpus+0x8>
    800016ac:	95be                	add	a1,a1,a5
    800016ae:	06048513          	addi	a0,s1,96
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	602080e7          	jalr	1538(ra) # 80001cb4 <swtch>
    800016ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016bc:	2781                	sext.w	a5,a5
    800016be:	079e                	slli	a5,a5,0x7
    800016c0:	993e                	add	s2,s2,a5
    800016c2:	0b392623          	sw	s3,172(s2)
}
    800016c6:	70a2                	ld	ra,40(sp)
    800016c8:	7402                	ld	s0,32(sp)
    800016ca:	64e2                	ld	s1,24(sp)
    800016cc:	6942                	ld	s2,16(sp)
    800016ce:	69a2                	ld	s3,8(sp)
    800016d0:	6145                	addi	sp,sp,48
    800016d2:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    800016d4:	00007517          	auipc	a0,0x7
    800016d8:	b3c50513          	addi	a0,a0,-1220 # 80008210 <etext+0x210>
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	9a6080e7          	jalr	-1626(ra) # 80006082 <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    800016e4:	00007517          	auipc	a0,0x7
    800016e8:	b3c50513          	addi	a0,a0,-1220 # 80008220 <etext+0x220>
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	996080e7          	jalr	-1642(ra) # 80006082 <panic>
  if (p->state == RUNNING) panic("sched running");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	b3c50513          	addi	a0,a0,-1220 # 80008230 <etext+0x230>
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	986080e7          	jalr	-1658(ra) # 80006082 <panic>
  if (intr_get()) panic("sched interruptible");
    80001704:	00007517          	auipc	a0,0x7
    80001708:	b3c50513          	addi	a0,a0,-1220 # 80008240 <etext+0x240>
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	976080e7          	jalr	-1674(ra) # 80006082 <panic>

0000000080001714 <yield>:
void yield(void) {
    80001714:	1101                	addi	sp,sp,-32
    80001716:	ec06                	sd	ra,24(sp)
    80001718:	e822                	sd	s0,16(sp)
    8000171a:	e426                	sd	s1,8(sp)
    8000171c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	984080e7          	jalr	-1660(ra) # 800010a2 <myproc>
    80001726:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	ed4080e7          	jalr	-300(ra) # 800065fc <acquire>
  p->state = RUNNABLE;
    80001730:	478d                	li	a5,3
    80001732:	cc9c                	sw	a5,24(s1)
  sched();
    80001734:	00000097          	auipc	ra,0x0
    80001738:	f0a080e7          	jalr	-246(ra) # 8000163e <sched>
  release(&p->lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	f72080e7          	jalr	-142(ra) # 800066b0 <release>
}
    80001746:	60e2                	ld	ra,24(sp)
    80001748:	6442                	ld	s0,16(sp)
    8000174a:	64a2                	ld	s1,8(sp)
    8000174c:	6105                	addi	sp,sp,32
    8000174e:	8082                	ret

0000000080001750 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    80001750:	7179                	addi	sp,sp,-48
    80001752:	f406                	sd	ra,40(sp)
    80001754:	f022                	sd	s0,32(sp)
    80001756:	ec26                	sd	s1,24(sp)
    80001758:	e84a                	sd	s2,16(sp)
    8000175a:	e44e                	sd	s3,8(sp)
    8000175c:	1800                	addi	s0,sp,48
    8000175e:	89aa                	mv	s3,a0
    80001760:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001762:	00000097          	auipc	ra,0x0
    80001766:	940080e7          	jalr	-1728(ra) # 800010a2 <myproc>
    8000176a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	e90080e7          	jalr	-368(ra) # 800065fc <acquire>
  release(lk);
    80001774:	854a                	mv	a0,s2
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	f3a080e7          	jalr	-198(ra) # 800066b0 <release>

  // Go to sleep.
  p->chan = chan;
    8000177e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001782:	4789                	li	a5,2
    80001784:	cc9c                	sw	a5,24(s1)

  sched();
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	eb8080e7          	jalr	-328(ra) # 8000163e <sched>

  // Tidy up.
  p->chan = 0;
    8000178e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001792:	8526                	mv	a0,s1
    80001794:	00005097          	auipc	ra,0x5
    80001798:	f1c080e7          	jalr	-228(ra) # 800066b0 <release>
  acquire(lk);
    8000179c:	854a                	mv	a0,s2
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	e5e080e7          	jalr	-418(ra) # 800065fc <acquire>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6145                	addi	sp,sp,48
    800017b2:	8082                	ret

00000000800017b4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800017b4:	7139                	addi	sp,sp,-64
    800017b6:	fc06                	sd	ra,56(sp)
    800017b8:	f822                	sd	s0,48(sp)
    800017ba:	f426                	sd	s1,40(sp)
    800017bc:	f04a                	sd	s2,32(sp)
    800017be:	ec4e                	sd	s3,24(sp)
    800017c0:	e852                	sd	s4,16(sp)
    800017c2:	e456                	sd	s5,8(sp)
    800017c4:	0080                	addi	s0,sp,64
    800017c6:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800017c8:	0002a497          	auipc	s1,0x2a
    800017cc:	03048493          	addi	s1,s1,48 # 8002b7f8 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    800017d0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017d2:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800017d4:	00030917          	auipc	s2,0x30
    800017d8:	a2490913          	addi	s2,s2,-1500 # 800311f8 <tickslock>
    800017dc:	a811                	j	800017f0 <wakeup+0x3c>
      }
      release(&p->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	ed0080e7          	jalr	-304(ra) # 800066b0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017e8:	16848493          	addi	s1,s1,360
    800017ec:	03248663          	beq	s1,s2,80001818 <wakeup+0x64>
    if (p != myproc()) {
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	8b2080e7          	jalr	-1870(ra) # 800010a2 <myproc>
    800017f8:	fea488e3          	beq	s1,a0,800017e8 <wakeup+0x34>
      acquire(&p->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	dfe080e7          	jalr	-514(ra) # 800065fc <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001806:	4c9c                	lw	a5,24(s1)
    80001808:	fd379be3          	bne	a5,s3,800017de <wakeup+0x2a>
    8000180c:	709c                	ld	a5,32(s1)
    8000180e:	fd4798e3          	bne	a5,s4,800017de <wakeup+0x2a>
        p->state = RUNNABLE;
    80001812:	0154ac23          	sw	s5,24(s1)
    80001816:	b7e1                	j	800017de <wakeup+0x2a>
    }
  }
}
    80001818:	70e2                	ld	ra,56(sp)
    8000181a:	7442                	ld	s0,48(sp)
    8000181c:	74a2                	ld	s1,40(sp)
    8000181e:	7902                	ld	s2,32(sp)
    80001820:	69e2                	ld	s3,24(sp)
    80001822:	6a42                	ld	s4,16(sp)
    80001824:	6aa2                	ld	s5,8(sp)
    80001826:	6121                	addi	sp,sp,64
    80001828:	8082                	ret

000000008000182a <reparent>:
void reparent(struct proc *p) {
    8000182a:	7179                	addi	sp,sp,-48
    8000182c:	f406                	sd	ra,40(sp)
    8000182e:	f022                	sd	s0,32(sp)
    80001830:	ec26                	sd	s1,24(sp)
    80001832:	e84a                	sd	s2,16(sp)
    80001834:	e44e                	sd	s3,8(sp)
    80001836:	e052                	sd	s4,0(sp)
    80001838:	1800                	addi	s0,sp,48
    8000183a:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000183c:	0002a497          	auipc	s1,0x2a
    80001840:	fbc48493          	addi	s1,s1,-68 # 8002b7f8 <proc>
      pp->parent = initproc;
    80001844:	0000aa17          	auipc	s4,0xa
    80001848:	b2ca0a13          	addi	s4,s4,-1236 # 8000b370 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000184c:	00030997          	auipc	s3,0x30
    80001850:	9ac98993          	addi	s3,s3,-1620 # 800311f8 <tickslock>
    80001854:	a029                	j	8000185e <reparent+0x34>
    80001856:	16848493          	addi	s1,s1,360
    8000185a:	01348d63          	beq	s1,s3,80001874 <reparent+0x4a>
    if (pp->parent == p) {
    8000185e:	7c9c                	ld	a5,56(s1)
    80001860:	ff279be3          	bne	a5,s2,80001856 <reparent+0x2c>
      pp->parent = initproc;
    80001864:	000a3503          	ld	a0,0(s4)
    80001868:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000186a:	00000097          	auipc	ra,0x0
    8000186e:	f4a080e7          	jalr	-182(ra) # 800017b4 <wakeup>
    80001872:	b7d5                	j	80001856 <reparent+0x2c>
}
    80001874:	70a2                	ld	ra,40(sp)
    80001876:	7402                	ld	s0,32(sp)
    80001878:	64e2                	ld	s1,24(sp)
    8000187a:	6942                	ld	s2,16(sp)
    8000187c:	69a2                	ld	s3,8(sp)
    8000187e:	6a02                	ld	s4,0(sp)
    80001880:	6145                	addi	sp,sp,48
    80001882:	8082                	ret

0000000080001884 <exit>:
void exit(int status) {
    80001884:	7179                	addi	sp,sp,-48
    80001886:	f406                	sd	ra,40(sp)
    80001888:	f022                	sd	s0,32(sp)
    8000188a:	ec26                	sd	s1,24(sp)
    8000188c:	e84a                	sd	s2,16(sp)
    8000188e:	e44e                	sd	s3,8(sp)
    80001890:	e052                	sd	s4,0(sp)
    80001892:	1800                	addi	s0,sp,48
    80001894:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001896:	00000097          	auipc	ra,0x0
    8000189a:	80c080e7          	jalr	-2036(ra) # 800010a2 <myproc>
    8000189e:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    800018a0:	0000a797          	auipc	a5,0xa
    800018a4:	ad07b783          	ld	a5,-1328(a5) # 8000b370 <initproc>
    800018a8:	0d050493          	addi	s1,a0,208
    800018ac:	15050913          	addi	s2,a0,336
    800018b0:	02a79363          	bne	a5,a0,800018d6 <exit+0x52>
    800018b4:	00007517          	auipc	a0,0x7
    800018b8:	9a450513          	addi	a0,a0,-1628 # 80008258 <etext+0x258>
    800018bc:	00004097          	auipc	ra,0x4
    800018c0:	7c6080e7          	jalr	1990(ra) # 80006082 <panic>
      fileclose(f);
    800018c4:	00002097          	auipc	ra,0x2
    800018c8:	46e080e7          	jalr	1134(ra) # 80003d32 <fileclose>
      p->ofile[fd] = 0;
    800018cc:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800018d0:	04a1                	addi	s1,s1,8
    800018d2:	01248563          	beq	s1,s2,800018dc <exit+0x58>
    if (p->ofile[fd]) {
    800018d6:	6088                	ld	a0,0(s1)
    800018d8:	f575                	bnez	a0,800018c4 <exit+0x40>
    800018da:	bfdd                	j	800018d0 <exit+0x4c>
  begin_op();
    800018dc:	00002097          	auipc	ra,0x2
    800018e0:	f8c080e7          	jalr	-116(ra) # 80003868 <begin_op>
  iput(p->cwd);
    800018e4:	1509b503          	ld	a0,336(s3)
    800018e8:	00001097          	auipc	ra,0x1
    800018ec:	770080e7          	jalr	1904(ra) # 80003058 <iput>
  end_op();
    800018f0:	00002097          	auipc	ra,0x2
    800018f4:	ff2080e7          	jalr	-14(ra) # 800038e2 <end_op>
  p->cwd = 0;
    800018f8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018fc:	0002a497          	auipc	s1,0x2a
    80001900:	ae448493          	addi	s1,s1,-1308 # 8002b3e0 <wait_lock>
    80001904:	8526                	mv	a0,s1
    80001906:	00005097          	auipc	ra,0x5
    8000190a:	cf6080e7          	jalr	-778(ra) # 800065fc <acquire>
  reparent(p);
    8000190e:	854e                	mv	a0,s3
    80001910:	00000097          	auipc	ra,0x0
    80001914:	f1a080e7          	jalr	-230(ra) # 8000182a <reparent>
  wakeup(p->parent);
    80001918:	0389b503          	ld	a0,56(s3)
    8000191c:	00000097          	auipc	ra,0x0
    80001920:	e98080e7          	jalr	-360(ra) # 800017b4 <wakeup>
  acquire(&p->lock);
    80001924:	854e                	mv	a0,s3
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	cd6080e7          	jalr	-810(ra) # 800065fc <acquire>
  p->xstate = status;
    8000192e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001932:	4795                	li	a5,5
    80001934:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	d76080e7          	jalr	-650(ra) # 800066b0 <release>
  sched();
    80001942:	00000097          	auipc	ra,0x0
    80001946:	cfc080e7          	jalr	-772(ra) # 8000163e <sched>
  panic("zombie exit");
    8000194a:	00007517          	auipc	a0,0x7
    8000194e:	91e50513          	addi	a0,a0,-1762 # 80008268 <etext+0x268>
    80001952:	00004097          	auipc	ra,0x4
    80001956:	730080e7          	jalr	1840(ra) # 80006082 <panic>

000000008000195a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000196a:	0002a497          	auipc	s1,0x2a
    8000196e:	e8e48493          	addi	s1,s1,-370 # 8002b7f8 <proc>
    80001972:	00030997          	auipc	s3,0x30
    80001976:	88698993          	addi	s3,s3,-1914 # 800311f8 <tickslock>
    acquire(&p->lock);
    8000197a:	8526                	mv	a0,s1
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	c80080e7          	jalr	-896(ra) # 800065fc <acquire>
    if (p->pid == pid) {
    80001984:	589c                	lw	a5,48(s1)
    80001986:	01278d63          	beq	a5,s2,800019a0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000198a:	8526                	mv	a0,s1
    8000198c:	00005097          	auipc	ra,0x5
    80001990:	d24080e7          	jalr	-732(ra) # 800066b0 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001994:	16848493          	addi	s1,s1,360
    80001998:	ff3491e3          	bne	s1,s3,8000197a <kill+0x20>
  }
  return -1;
    8000199c:	557d                	li	a0,-1
    8000199e:	a829                	j	800019b8 <kill+0x5e>
      p->killed = 1;
    800019a0:	4785                	li	a5,1
    800019a2:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800019a4:	4c98                	lw	a4,24(s1)
    800019a6:	4789                	li	a5,2
    800019a8:	00f70f63          	beq	a4,a5,800019c6 <kill+0x6c>
      release(&p->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	d02080e7          	jalr	-766(ra) # 800066b0 <release>
      return 0;
    800019b6:	4501                	li	a0,0
}
    800019b8:	70a2                	ld	ra,40(sp)
    800019ba:	7402                	ld	s0,32(sp)
    800019bc:	64e2                	ld	s1,24(sp)
    800019be:	6942                	ld	s2,16(sp)
    800019c0:	69a2                	ld	s3,8(sp)
    800019c2:	6145                	addi	sp,sp,48
    800019c4:	8082                	ret
        p->state = RUNNABLE;
    800019c6:	478d                	li	a5,3
    800019c8:	cc9c                	sw	a5,24(s1)
    800019ca:	b7cd                	j	800019ac <kill+0x52>

00000000800019cc <setkilled>:

void setkilled(struct proc *p) {
    800019cc:	1101                	addi	sp,sp,-32
    800019ce:	ec06                	sd	ra,24(sp)
    800019d0:	e822                	sd	s0,16(sp)
    800019d2:	e426                	sd	s1,8(sp)
    800019d4:	1000                	addi	s0,sp,32
    800019d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019d8:	00005097          	auipc	ra,0x5
    800019dc:	c24080e7          	jalr	-988(ra) # 800065fc <acquire>
  p->killed = 1;
    800019e0:	4785                	li	a5,1
    800019e2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019e4:	8526                	mv	a0,s1
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	cca080e7          	jalr	-822(ra) # 800066b0 <release>
}
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6105                	addi	sp,sp,32
    800019f6:	8082                	ret

00000000800019f8 <killed>:

int killed(struct proc *p) {
    800019f8:	1101                	addi	sp,sp,-32
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	e822                	sd	s0,16(sp)
    800019fe:	e426                	sd	s1,8(sp)
    80001a00:	e04a                	sd	s2,0(sp)
    80001a02:	1000                	addi	s0,sp,32
    80001a04:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001a06:	00005097          	auipc	ra,0x5
    80001a0a:	bf6080e7          	jalr	-1034(ra) # 800065fc <acquire>
  k = p->killed;
    80001a0e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	c9c080e7          	jalr	-868(ra) # 800066b0 <release>
  return k;
}
    80001a1c:	854a                	mv	a0,s2
    80001a1e:	60e2                	ld	ra,24(sp)
    80001a20:	6442                	ld	s0,16(sp)
    80001a22:	64a2                	ld	s1,8(sp)
    80001a24:	6902                	ld	s2,0(sp)
    80001a26:	6105                	addi	sp,sp,32
    80001a28:	8082                	ret

0000000080001a2a <wait>:
int wait(uint64 addr) {
    80001a2a:	715d                	addi	sp,sp,-80
    80001a2c:	e486                	sd	ra,72(sp)
    80001a2e:	e0a2                	sd	s0,64(sp)
    80001a30:	fc26                	sd	s1,56(sp)
    80001a32:	f84a                	sd	s2,48(sp)
    80001a34:	f44e                	sd	s3,40(sp)
    80001a36:	f052                	sd	s4,32(sp)
    80001a38:	ec56                	sd	s5,24(sp)
    80001a3a:	e85a                	sd	s6,16(sp)
    80001a3c:	e45e                	sd	s7,8(sp)
    80001a3e:	e062                	sd	s8,0(sp)
    80001a40:	0880                	addi	s0,sp,80
    80001a42:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	65e080e7          	jalr	1630(ra) # 800010a2 <myproc>
    80001a4c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a4e:	0002a517          	auipc	a0,0x2a
    80001a52:	99250513          	addi	a0,a0,-1646 # 8002b3e0 <wait_lock>
    80001a56:	00005097          	auipc	ra,0x5
    80001a5a:	ba6080e7          	jalr	-1114(ra) # 800065fc <acquire>
    havekids = 0;
    80001a5e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80001a60:	4a15                	li	s4,5
        havekids = 1;
    80001a62:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001a64:	0002f997          	auipc	s3,0x2f
    80001a68:	79498993          	addi	s3,s3,1940 # 800311f8 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001a6c:	0002ac17          	auipc	s8,0x2a
    80001a70:	974c0c13          	addi	s8,s8,-1676 # 8002b3e0 <wait_lock>
    80001a74:	a0d1                	j	80001b38 <wait+0x10e>
          pid = pp->pid;
    80001a76:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a7a:	000b0e63          	beqz	s6,80001a96 <wait+0x6c>
    80001a7e:	4691                	li	a3,4
    80001a80:	02c48613          	addi	a2,s1,44
    80001a84:	85da                	mv	a1,s6
    80001a86:	05093503          	ld	a0,80(s2)
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	178080e7          	jalr	376(ra) # 80000c02 <copyout>
    80001a92:	04054163          	bltz	a0,80001ad4 <wait+0xaa>
          freeproc(pp);
    80001a96:	8526                	mv	a0,s1
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	7c0080e7          	jalr	1984(ra) # 80001258 <freeproc>
          release(&pp->lock);
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	00005097          	auipc	ra,0x5
    80001aa6:	c0e080e7          	jalr	-1010(ra) # 800066b0 <release>
          release(&wait_lock);
    80001aaa:	0002a517          	auipc	a0,0x2a
    80001aae:	93650513          	addi	a0,a0,-1738 # 8002b3e0 <wait_lock>
    80001ab2:	00005097          	auipc	ra,0x5
    80001ab6:	bfe080e7          	jalr	-1026(ra) # 800066b0 <release>
}
    80001aba:	854e                	mv	a0,s3
    80001abc:	60a6                	ld	ra,72(sp)
    80001abe:	6406                	ld	s0,64(sp)
    80001ac0:	74e2                	ld	s1,56(sp)
    80001ac2:	7942                	ld	s2,48(sp)
    80001ac4:	79a2                	ld	s3,40(sp)
    80001ac6:	7a02                	ld	s4,32(sp)
    80001ac8:	6ae2                	ld	s5,24(sp)
    80001aca:	6b42                	ld	s6,16(sp)
    80001acc:	6ba2                	ld	s7,8(sp)
    80001ace:	6c02                	ld	s8,0(sp)
    80001ad0:	6161                	addi	sp,sp,80
    80001ad2:	8082                	ret
            release(&pp->lock);
    80001ad4:	8526                	mv	a0,s1
    80001ad6:	00005097          	auipc	ra,0x5
    80001ada:	bda080e7          	jalr	-1062(ra) # 800066b0 <release>
            release(&wait_lock);
    80001ade:	0002a517          	auipc	a0,0x2a
    80001ae2:	90250513          	addi	a0,a0,-1790 # 8002b3e0 <wait_lock>
    80001ae6:	00005097          	auipc	ra,0x5
    80001aea:	bca080e7          	jalr	-1078(ra) # 800066b0 <release>
            return -1;
    80001aee:	59fd                	li	s3,-1
    80001af0:	b7e9                	j	80001aba <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001af2:	16848493          	addi	s1,s1,360
    80001af6:	03348463          	beq	s1,s3,80001b1e <wait+0xf4>
      if (pp->parent == p) {
    80001afa:	7c9c                	ld	a5,56(s1)
    80001afc:	ff279be3          	bne	a5,s2,80001af2 <wait+0xc8>
        acquire(&pp->lock);
    80001b00:	8526                	mv	a0,s1
    80001b02:	00005097          	auipc	ra,0x5
    80001b06:	afa080e7          	jalr	-1286(ra) # 800065fc <acquire>
        if (pp->state == ZOMBIE) {
    80001b0a:	4c9c                	lw	a5,24(s1)
    80001b0c:	f74785e3          	beq	a5,s4,80001a76 <wait+0x4c>
        release(&pp->lock);
    80001b10:	8526                	mv	a0,s1
    80001b12:	00005097          	auipc	ra,0x5
    80001b16:	b9e080e7          	jalr	-1122(ra) # 800066b0 <release>
        havekids = 1;
    80001b1a:	8756                	mv	a4,s5
    80001b1c:	bfd9                	j	80001af2 <wait+0xc8>
    if (!havekids || killed(p)) {
    80001b1e:	c31d                	beqz	a4,80001b44 <wait+0x11a>
    80001b20:	854a                	mv	a0,s2
    80001b22:	00000097          	auipc	ra,0x0
    80001b26:	ed6080e7          	jalr	-298(ra) # 800019f8 <killed>
    80001b2a:	ed09                	bnez	a0,80001b44 <wait+0x11a>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001b2c:	85e2                	mv	a1,s8
    80001b2e:	854a                	mv	a0,s2
    80001b30:	00000097          	auipc	ra,0x0
    80001b34:	c20080e7          	jalr	-992(ra) # 80001750 <sleep>
    havekids = 0;
    80001b38:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b3a:	0002a497          	auipc	s1,0x2a
    80001b3e:	cbe48493          	addi	s1,s1,-834 # 8002b7f8 <proc>
    80001b42:	bf65                	j	80001afa <wait+0xd0>
      release(&wait_lock);
    80001b44:	0002a517          	auipc	a0,0x2a
    80001b48:	89c50513          	addi	a0,a0,-1892 # 8002b3e0 <wait_lock>
    80001b4c:	00005097          	auipc	ra,0x5
    80001b50:	b64080e7          	jalr	-1180(ra) # 800066b0 <release>
      return -1;
    80001b54:	59fd                	li	s3,-1
    80001b56:	b795                	j	80001aba <wait+0x90>

0000000080001b58 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001b58:	7179                	addi	sp,sp,-48
    80001b5a:	f406                	sd	ra,40(sp)
    80001b5c:	f022                	sd	s0,32(sp)
    80001b5e:	ec26                	sd	s1,24(sp)
    80001b60:	e84a                	sd	s2,16(sp)
    80001b62:	e44e                	sd	s3,8(sp)
    80001b64:	e052                	sd	s4,0(sp)
    80001b66:	1800                	addi	s0,sp,48
    80001b68:	84aa                	mv	s1,a0
    80001b6a:	892e                	mv	s2,a1
    80001b6c:	89b2                	mv	s3,a2
    80001b6e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	532080e7          	jalr	1330(ra) # 800010a2 <myproc>
  if (user_dst) {
    80001b78:	c08d                	beqz	s1,80001b9a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b7a:	86d2                	mv	a3,s4
    80001b7c:	864e                	mv	a2,s3
    80001b7e:	85ca                	mv	a1,s2
    80001b80:	6928                	ld	a0,80(a0)
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	080080e7          	jalr	128(ra) # 80000c02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b8a:	70a2                	ld	ra,40(sp)
    80001b8c:	7402                	ld	s0,32(sp)
    80001b8e:	64e2                	ld	s1,24(sp)
    80001b90:	6942                	ld	s2,16(sp)
    80001b92:	69a2                	ld	s3,8(sp)
    80001b94:	6a02                	ld	s4,0(sp)
    80001b96:	6145                	addi	sp,sp,48
    80001b98:	8082                	ret
    memmove((char *)dst, src, len);
    80001b9a:	000a061b          	sext.w	a2,s4
    80001b9e:	85ce                	mv	a1,s3
    80001ba0:	854a                	mv	a0,s2
    80001ba2:	ffffe097          	auipc	ra,0xffffe
    80001ba6:	6d8080e7          	jalr	1752(ra) # 8000027a <memmove>
    return 0;
    80001baa:	8526                	mv	a0,s1
    80001bac:	bff9                	j	80001b8a <either_copyout+0x32>

0000000080001bae <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001bae:	7179                	addi	sp,sp,-48
    80001bb0:	f406                	sd	ra,40(sp)
    80001bb2:	f022                	sd	s0,32(sp)
    80001bb4:	ec26                	sd	s1,24(sp)
    80001bb6:	e84a                	sd	s2,16(sp)
    80001bb8:	e44e                	sd	s3,8(sp)
    80001bba:	e052                	sd	s4,0(sp)
    80001bbc:	1800                	addi	s0,sp,48
    80001bbe:	892a                	mv	s2,a0
    80001bc0:	84ae                	mv	s1,a1
    80001bc2:	89b2                	mv	s3,a2
    80001bc4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bc6:	fffff097          	auipc	ra,0xfffff
    80001bca:	4dc080e7          	jalr	1244(ra) # 800010a2 <myproc>
  if (user_src) {
    80001bce:	c08d                	beqz	s1,80001bf0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bd0:	86d2                	mv	a3,s4
    80001bd2:	864e                	mv	a2,s3
    80001bd4:	85ca                	mv	a1,s2
    80001bd6:	6928                	ld	a0,80(a0)
    80001bd8:	fffff097          	auipc	ra,0xfffff
    80001bdc:	10e080e7          	jalr	270(ra) # 80000ce6 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001be0:	70a2                	ld	ra,40(sp)
    80001be2:	7402                	ld	s0,32(sp)
    80001be4:	64e2                	ld	s1,24(sp)
    80001be6:	6942                	ld	s2,16(sp)
    80001be8:	69a2                	ld	s3,8(sp)
    80001bea:	6a02                	ld	s4,0(sp)
    80001bec:	6145                	addi	sp,sp,48
    80001bee:	8082                	ret
    memmove(dst, (char *)src, len);
    80001bf0:	000a061b          	sext.w	a2,s4
    80001bf4:	85ce                	mv	a1,s3
    80001bf6:	854a                	mv	a0,s2
    80001bf8:	ffffe097          	auipc	ra,0xffffe
    80001bfc:	682080e7          	jalr	1666(ra) # 8000027a <memmove>
    return 0;
    80001c00:	8526                	mv	a0,s1
    80001c02:	bff9                	j	80001be0 <either_copyin+0x32>

0000000080001c04 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001c04:	715d                	addi	sp,sp,-80
    80001c06:	e486                	sd	ra,72(sp)
    80001c08:	e0a2                	sd	s0,64(sp)
    80001c0a:	fc26                	sd	s1,56(sp)
    80001c0c:	f84a                	sd	s2,48(sp)
    80001c0e:	f44e                	sd	s3,40(sp)
    80001c10:	f052                	sd	s4,32(sp)
    80001c12:	ec56                	sd	s5,24(sp)
    80001c14:	e85a                	sd	s6,16(sp)
    80001c16:	e45e                	sd	s7,8(sp)
    80001c18:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001c1a:	00006517          	auipc	a0,0x6
    80001c1e:	40650513          	addi	a0,a0,1030 # 80008020 <etext+0x20>
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	4aa080e7          	jalr	1194(ra) # 800060cc <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c2a:	0002a497          	auipc	s1,0x2a
    80001c2e:	d2648493          	addi	s1,s1,-730 # 8002b950 <proc+0x158>
    80001c32:	0002f917          	auipc	s2,0x2f
    80001c36:	71e90913          	addi	s2,s2,1822 # 80031350 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c3a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c3c:	00006997          	auipc	s3,0x6
    80001c40:	63c98993          	addi	s3,s3,1596 # 80008278 <etext+0x278>
    printf("%d %s %s", p->pid, state, p->name);
    80001c44:	00006a97          	auipc	s5,0x6
    80001c48:	63ca8a93          	addi	s5,s5,1596 # 80008280 <etext+0x280>
    printf("\n");
    80001c4c:	00006a17          	auipc	s4,0x6
    80001c50:	3d4a0a13          	addi	s4,s4,980 # 80008020 <etext+0x20>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c54:	00007b97          	auipc	s7,0x7
    80001c58:	b54b8b93          	addi	s7,s7,-1196 # 800087a8 <states.0>
    80001c5c:	a00d                	j	80001c7e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c5e:	ed86a583          	lw	a1,-296(a3)
    80001c62:	8556                	mv	a0,s5
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	468080e7          	jalr	1128(ra) # 800060cc <printf>
    printf("\n");
    80001c6c:	8552                	mv	a0,s4
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	45e080e7          	jalr	1118(ra) # 800060cc <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001c76:	16848493          	addi	s1,s1,360
    80001c7a:	03248263          	beq	s1,s2,80001c9e <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001c7e:	86a6                	mv	a3,s1
    80001c80:	ec04a783          	lw	a5,-320(s1)
    80001c84:	dbed                	beqz	a5,80001c76 <procdump+0x72>
      state = "???";
    80001c86:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c88:	fcfb6be3          	bltu	s6,a5,80001c5e <procdump+0x5a>
    80001c8c:	02079713          	slli	a4,a5,0x20
    80001c90:	01d75793          	srli	a5,a4,0x1d
    80001c94:	97de                	add	a5,a5,s7
    80001c96:	6390                	ld	a2,0(a5)
    80001c98:	f279                	bnez	a2,80001c5e <procdump+0x5a>
      state = "???";
    80001c9a:	864e                	mv	a2,s3
    80001c9c:	b7c9                	j	80001c5e <procdump+0x5a>
  }
}
    80001c9e:	60a6                	ld	ra,72(sp)
    80001ca0:	6406                	ld	s0,64(sp)
    80001ca2:	74e2                	ld	s1,56(sp)
    80001ca4:	7942                	ld	s2,48(sp)
    80001ca6:	79a2                	ld	s3,40(sp)
    80001ca8:	7a02                	ld	s4,32(sp)
    80001caa:	6ae2                	ld	s5,24(sp)
    80001cac:	6b42                	ld	s6,16(sp)
    80001cae:	6ba2                	ld	s7,8(sp)
    80001cb0:	6161                	addi	sp,sp,80
    80001cb2:	8082                	ret

0000000080001cb4 <swtch>:
    80001cb4:	00153023          	sd	ra,0(a0)
    80001cb8:	00253423          	sd	sp,8(a0)
    80001cbc:	e900                	sd	s0,16(a0)
    80001cbe:	ed04                	sd	s1,24(a0)
    80001cc0:	03253023          	sd	s2,32(a0)
    80001cc4:	03353423          	sd	s3,40(a0)
    80001cc8:	03453823          	sd	s4,48(a0)
    80001ccc:	03553c23          	sd	s5,56(a0)
    80001cd0:	05653023          	sd	s6,64(a0)
    80001cd4:	05753423          	sd	s7,72(a0)
    80001cd8:	05853823          	sd	s8,80(a0)
    80001cdc:	05953c23          	sd	s9,88(a0)
    80001ce0:	07a53023          	sd	s10,96(a0)
    80001ce4:	07b53423          	sd	s11,104(a0)
    80001ce8:	0005b083          	ld	ra,0(a1)
    80001cec:	0085b103          	ld	sp,8(a1)
    80001cf0:	6980                	ld	s0,16(a1)
    80001cf2:	6d84                	ld	s1,24(a1)
    80001cf4:	0205b903          	ld	s2,32(a1)
    80001cf8:	0285b983          	ld	s3,40(a1)
    80001cfc:	0305ba03          	ld	s4,48(a1)
    80001d00:	0385ba83          	ld	s5,56(a1)
    80001d04:	0405bb03          	ld	s6,64(a1)
    80001d08:	0485bb83          	ld	s7,72(a1)
    80001d0c:	0505bc03          	ld	s8,80(a1)
    80001d10:	0585bc83          	ld	s9,88(a1)
    80001d14:	0605bd03          	ld	s10,96(a1)
    80001d18:	0685bd83          	ld	s11,104(a1)
    80001d1c:	8082                	ret

0000000080001d1e <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001d1e:	1141                	addi	sp,sp,-16
    80001d20:	e406                	sd	ra,8(sp)
    80001d22:	e022                	sd	s0,0(sp)
    80001d24:	0800                	addi	s0,sp,16
    80001d26:	00006597          	auipc	a1,0x6
    80001d2a:	59a58593          	addi	a1,a1,1434 # 800082c0 <etext+0x2c0>
    80001d2e:	0002f517          	auipc	a0,0x2f
    80001d32:	4ca50513          	addi	a0,a0,1226 # 800311f8 <tickslock>
    80001d36:	00005097          	auipc	ra,0x5
    80001d3a:	836080e7          	jalr	-1994(ra) # 8000656c <initlock>
    80001d3e:	60a2                	ld	ra,8(sp)
    80001d40:	6402                	ld	s0,0(sp)
    80001d42:	0141                	addi	sp,sp,16
    80001d44:	8082                	ret

0000000080001d46 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001d46:	1141                	addi	sp,sp,-16
    80001d48:	e422                	sd	s0,8(sp)
    80001d4a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d4c:	00003797          	auipc	a5,0x3
    80001d50:	70478793          	addi	a5,a5,1796 # 80005450 <kernelvec>
    80001d54:	10579073          	csrw	stvec,a5
    80001d58:	6422                	ld	s0,8(sp)
    80001d5a:	0141                	addi	sp,sp,16
    80001d5c:	8082                	ret

0000000080001d5e <copyonwrite>:

int copyonwrite(pagetable_t pagetable, uint64 addr) {
    80001d5e:	7139                	addi	sp,sp,-64
    80001d60:	fc06                	sd	ra,56(sp)
    80001d62:	f822                	sd	s0,48(sp)
    80001d64:	f04a                	sd	s2,32(sp)
    80001d66:	0080                	addi	s0,sp,64
  uint64 va = PGROUNDDOWN(addr);
    80001d68:	77fd                	lui	a5,0xfffff
    80001d6a:	00f5f933          	and	s2,a1,a5
  if (va >= MAXVA) {
    80001d6e:	57fd                	li	a5,-1
    80001d70:	83e9                	srli	a5,a5,0x1a
    80001d72:	0d27eb63          	bltu	a5,s2,80001e48 <copyonwrite+0xea>
    80001d76:	ec4e                	sd	s3,24(sp)
    80001d78:	e852                	sd	s4,16(sp)
    80001d7a:	8a2a                	mv	s4,a0
    return -1;
  }
  pte_t *pte;
  if ((pte = walk(pagetable, va, 0)) == 0) {
    80001d7c:	4601                	li	a2,0
    80001d7e:	85ca                	mv	a1,s2
    80001d80:	ffffe097          	auipc	ra,0xffffe
    80001d84:	77a080e7          	jalr	1914(ra) # 800004fa <walk>
    80001d88:	89aa                	mv	s3,a0
    80001d8a:	c169                	beqz	a0,80001e4c <copyonwrite+0xee>
    return -1;
  }

  if (!(*pte & PTE_V) || !(*pte & PTE_U) ||
    80001d8c:	611c                	ld	a5,0(a0)
    80001d8e:	0117f693          	andi	a3,a5,17
    80001d92:	4745                	li	a4,17
    80001d94:	0ce69063          	bne	a3,a4,80001e54 <copyonwrite+0xf6>
      (!(*pte & PTE_W) && !(*pte & PTE_C))) {
    80001d98:	1047f713          	andi	a4,a5,260
  if (!(*pte & PTE_V) || !(*pte & PTE_U) ||
    80001d9c:	c361                	beqz	a4,80001e5c <copyonwrite+0xfe>
    80001d9e:	f426                	sd	s1,40(sp)
    return -1;
  }

  uint64 pa = PTE2PA(*pte);
    80001da0:	83a9                	srli	a5,a5,0xa
    80001da2:	00c79493          	slli	s1,a5,0xc

  if (change_and_get_ref(P_IND(pa), 0) == 1) {
    80001da6:	80000537          	lui	a0,0x80000
    80001daa:	9526                	add	a0,a0,s1
    80001dac:	4581                	li	a1,0
    80001dae:	8131                	srli	a0,a0,0xc
    80001db0:	ffffe097          	auipc	ra,0xffffe
    80001db4:	26c080e7          	jalr	620(ra) # 8000001c <change_and_get_ref>
    80001db8:	4785                	li	a5,1
    80001dba:	04f50f63          	beq	a0,a5,80001e18 <copyonwrite+0xba>
    80001dbe:	e456                	sd	s5,8(sp)
    *pte &= (~PTE_C);
    return 0;
  }

  char *mem;
  if ((mem = kalloc()) == 0) {
    80001dc0:	ffffe097          	auipc	ra,0xffffe
    80001dc4:	3e4080e7          	jalr	996(ra) # 800001a4 <kalloc>
    80001dc8:	8aaa                	mv	s5,a0
    80001dca:	cd49                	beqz	a0,80001e64 <copyonwrite+0x106>
    return -1;
  }

  uint flags = PTE_FLAGS(*pte);
    80001dcc:	0009a983          	lw	s3,0(s3)
  memmove(mem, (char *)pa, PGSIZE);
    80001dd0:	6605                	lui	a2,0x1
    80001dd2:	85a6                	mv	a1,s1
    80001dd4:	ffffe097          	auipc	ra,0xffffe
    80001dd8:	4a6080e7          	jalr	1190(ra) # 8000027a <memmove>
  uvmunmap(pagetable, va, 1, 1);
    80001ddc:	4685                	li	a3,1
    80001dde:	4605                	li	a2,1
    80001de0:	85ca                	mv	a1,s2
    80001de2:	8552                	mv	a0,s4
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	9e8080e7          	jalr	-1560(ra) # 800007cc <uvmunmap>

  flags &= (~PTE_C);
    80001dec:	2ff9f713          	andi	a4,s3,767
  flags |= PTE_W;

  if (mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0) {
    80001df0:	00476713          	ori	a4,a4,4
    80001df4:	86d6                	mv	a3,s5
    80001df6:	6605                	lui	a2,0x1
    80001df8:	85ca                	mv	a1,s2
    80001dfa:	8552                	mv	a0,s4
    80001dfc:	ffffe097          	auipc	ra,0xffffe
    80001e00:	7e6080e7          	jalr	2022(ra) # 800005e2 <mappages>
    80001e04:	e51d                	bnez	a0,80001e32 <copyonwrite+0xd4>
    80001e06:	74a2                	ld	s1,40(sp)
    80001e08:	69e2                	ld	s3,24(sp)
    80001e0a:	6a42                	ld	s4,16(sp)
    80001e0c:	6aa2                	ld	s5,8(sp)
    kfree(mem);
    return -1;
  }
  return 0;
}
    80001e0e:	70e2                	ld	ra,56(sp)
    80001e10:	7442                	ld	s0,48(sp)
    80001e12:	7902                	ld	s2,32(sp)
    80001e14:	6121                	addi	sp,sp,64
    80001e16:	8082                	ret
    *pte &= (~PTE_C);
    80001e18:	0009b783          	ld	a5,0(s3)
    80001e1c:	eff7f793          	andi	a5,a5,-257
    80001e20:	0047e793          	ori	a5,a5,4
    80001e24:	00f9b023          	sd	a5,0(s3)
    return 0;
    80001e28:	4501                	li	a0,0
    80001e2a:	74a2                	ld	s1,40(sp)
    80001e2c:	69e2                	ld	s3,24(sp)
    80001e2e:	6a42                	ld	s4,16(sp)
    80001e30:	bff9                	j	80001e0e <copyonwrite+0xb0>
    kfree(mem);
    80001e32:	8556                	mv	a0,s5
    80001e34:	ffffe097          	auipc	ra,0xffffe
    80001e38:	23a080e7          	jalr	570(ra) # 8000006e <kfree>
    return -1;
    80001e3c:	557d                	li	a0,-1
    80001e3e:	74a2                	ld	s1,40(sp)
    80001e40:	69e2                	ld	s3,24(sp)
    80001e42:	6a42                	ld	s4,16(sp)
    80001e44:	6aa2                	ld	s5,8(sp)
    80001e46:	b7e1                	j	80001e0e <copyonwrite+0xb0>
    return -1;
    80001e48:	557d                	li	a0,-1
    80001e4a:	b7d1                	j	80001e0e <copyonwrite+0xb0>
    return -1;
    80001e4c:	557d                	li	a0,-1
    80001e4e:	69e2                	ld	s3,24(sp)
    80001e50:	6a42                	ld	s4,16(sp)
    80001e52:	bf75                	j	80001e0e <copyonwrite+0xb0>
    return -1;
    80001e54:	557d                	li	a0,-1
    80001e56:	69e2                	ld	s3,24(sp)
    80001e58:	6a42                	ld	s4,16(sp)
    80001e5a:	bf55                	j	80001e0e <copyonwrite+0xb0>
    80001e5c:	557d                	li	a0,-1
    80001e5e:	69e2                	ld	s3,24(sp)
    80001e60:	6a42                	ld	s4,16(sp)
    80001e62:	b775                	j	80001e0e <copyonwrite+0xb0>
    return -1;
    80001e64:	557d                	li	a0,-1
    80001e66:	74a2                	ld	s1,40(sp)
    80001e68:	69e2                	ld	s3,24(sp)
    80001e6a:	6a42                	ld	s4,16(sp)
    80001e6c:	6aa2                	ld	s5,8(sp)
    80001e6e:	b745                	j	80001e0e <copyonwrite+0xb0>

0000000080001e70 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001e70:	1141                	addi	sp,sp,-16
    80001e72:	e406                	sd	ra,8(sp)
    80001e74:	e022                	sd	s0,0(sp)
    80001e76:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	22a080e7          	jalr	554(ra) # 800010a2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e80:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001e84:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e86:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001e8a:	00005697          	auipc	a3,0x5
    80001e8e:	17668693          	addi	a3,a3,374 # 80007000 <_trampoline>
    80001e92:	00005717          	auipc	a4,0x5
    80001e96:	16e70713          	addi	a4,a4,366 # 80007000 <_trampoline>
    80001e9a:	8f15                	sub	a4,a4,a3
    80001e9c:	040007b7          	lui	a5,0x4000
    80001ea0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ea2:	07b2                	slli	a5,a5,0xc
    80001ea4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001ea6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001eaa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001eac:	18002673          	csrr	a2,satp
    80001eb0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001eb2:	6d30                	ld	a2,88(a0)
    80001eb4:	6138                	ld	a4,64(a0)
    80001eb6:	6585                	lui	a1,0x1
    80001eb8:	972e                	add	a4,a4,a1
    80001eba:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ebc:	6d38                	ld	a4,88(a0)
    80001ebe:	00000617          	auipc	a2,0x0
    80001ec2:	13860613          	addi	a2,a2,312 # 80001ff6 <usertrap>
    80001ec6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001ec8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001eca:	8612                	mv	a2,tp
    80001ecc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ece:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001ed2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001ed6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001eda:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ede:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001ee0:	6f18                	ld	a4,24(a4)
    80001ee2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ee6:	6928                	ld	a0,80(a0)
    80001ee8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001eea:	00005717          	auipc	a4,0x5
    80001eee:	1b270713          	addi	a4,a4,434 # 8000709c <userret>
    80001ef2:	8f15                	sub	a4,a4,a3
    80001ef4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001ef6:	577d                	li	a4,-1
    80001ef8:	177e                	slli	a4,a4,0x3f
    80001efa:	8d59                	or	a0,a0,a4
    80001efc:	9782                	jalr	a5
}
    80001efe:	60a2                	ld	ra,8(sp)
    80001f00:	6402                	ld	s0,0(sp)
    80001f02:	0141                	addi	sp,sp,16
    80001f04:	8082                	ret

0000000080001f06 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001f06:	1101                	addi	sp,sp,-32
    80001f08:	ec06                	sd	ra,24(sp)
    80001f0a:	e822                	sd	s0,16(sp)
    80001f0c:	e426                	sd	s1,8(sp)
    80001f0e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001f10:	0002f497          	auipc	s1,0x2f
    80001f14:	2e848493          	addi	s1,s1,744 # 800311f8 <tickslock>
    80001f18:	8526                	mv	a0,s1
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	6e2080e7          	jalr	1762(ra) # 800065fc <acquire>
  ticks++;
    80001f22:	00009517          	auipc	a0,0x9
    80001f26:	45650513          	addi	a0,a0,1110 # 8000b378 <ticks>
    80001f2a:	411c                	lw	a5,0(a0)
    80001f2c:	2785                	addiw	a5,a5,1
    80001f2e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	884080e7          	jalr	-1916(ra) # 800017b4 <wakeup>
  release(&tickslock);
    80001f38:	8526                	mv	a0,s1
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	776080e7          	jalr	1910(ra) # 800066b0 <release>
}
    80001f42:	60e2                	ld	ra,24(sp)
    80001f44:	6442                	ld	s0,16(sp)
    80001f46:	64a2                	ld	s1,8(sp)
    80001f48:	6105                	addi	sp,sp,32
    80001f4a:	8082                	ret

0000000080001f4c <devintr>:
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f4c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001f50:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001f52:	0a07d163          	bgez	a5,80001ff4 <devintr+0xa8>
int devintr() {
    80001f56:	1101                	addi	sp,sp,-32
    80001f58:	ec06                	sd	ra,24(sp)
    80001f5a:	e822                	sd	s0,16(sp)
    80001f5c:	1000                	addi	s0,sp,32
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001f5e:	0ff7f713          	zext.b	a4,a5
    80001f62:	46a5                	li	a3,9
    80001f64:	00d70c63          	beq	a4,a3,80001f7c <devintr+0x30>
  } else if (scause == 0x8000000000000001L) {
    80001f68:	577d                	li	a4,-1
    80001f6a:	177e                	slli	a4,a4,0x3f
    80001f6c:	0705                	addi	a4,a4,1
    return 0;
    80001f6e:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001f70:	06e78163          	beq	a5,a4,80001fd2 <devintr+0x86>
  }
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	6105                	addi	sp,sp,32
    80001f7a:	8082                	ret
    80001f7c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001f7e:	00003097          	auipc	ra,0x3
    80001f82:	5de080e7          	jalr	1502(ra) # 8000555c <plic_claim>
    80001f86:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001f88:	47a9                	li	a5,10
    80001f8a:	00f50963          	beq	a0,a5,80001f9c <devintr+0x50>
    } else if (irq == VIRTIO0_IRQ) {
    80001f8e:	4785                	li	a5,1
    80001f90:	00f50b63          	beq	a0,a5,80001fa6 <devintr+0x5a>
    return 1;
    80001f94:	4505                	li	a0,1
    } else if (irq) {
    80001f96:	ec89                	bnez	s1,80001fb0 <devintr+0x64>
    80001f98:	64a2                	ld	s1,8(sp)
    80001f9a:	bfe9                	j	80001f74 <devintr+0x28>
      uartintr();
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	580080e7          	jalr	1408(ra) # 8000651c <uartintr>
    if (irq) plic_complete(irq);
    80001fa4:	a839                	j	80001fc2 <devintr+0x76>
      virtio_disk_intr();
    80001fa6:	00004097          	auipc	ra,0x4
    80001faa:	ae0080e7          	jalr	-1312(ra) # 80005a86 <virtio_disk_intr>
    if (irq) plic_complete(irq);
    80001fae:	a811                	j	80001fc2 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001fb0:	85a6                	mv	a1,s1
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	31650513          	addi	a0,a0,790 # 800082c8 <etext+0x2c8>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	112080e7          	jalr	274(ra) # 800060cc <printf>
    if (irq) plic_complete(irq);
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	00003097          	auipc	ra,0x3
    80001fc8:	5bc080e7          	jalr	1468(ra) # 80005580 <plic_complete>
    return 1;
    80001fcc:	4505                	li	a0,1
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	b755                	j	80001f74 <devintr+0x28>
    if (cpuid() == 0) {
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	0a4080e7          	jalr	164(ra) # 80001076 <cpuid>
    80001fda:	c901                	beqz	a0,80001fea <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001fdc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001fe0:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001fe2:	14479073          	csrw	sip,a5
    return 2;
    80001fe6:	4509                	li	a0,2
    80001fe8:	b771                	j	80001f74 <devintr+0x28>
      clockintr();
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	f1c080e7          	jalr	-228(ra) # 80001f06 <clockintr>
    80001ff2:	b7ed                	j	80001fdc <devintr+0x90>
}
    80001ff4:	8082                	ret

0000000080001ff6 <usertrap>:
void usertrap(void) {
    80001ff6:	1101                	addi	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	e04a                	sd	s2,0(sp)
    80002000:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002002:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002006:	1007f793          	andi	a5,a5,256
    8000200a:	e7b9                	bnez	a5,80002058 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000200c:	00003797          	auipc	a5,0x3
    80002010:	44478793          	addi	a5,a5,1092 # 80005450 <kernelvec>
    80002014:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	08a080e7          	jalr	138(ra) # 800010a2 <myproc>
    80002020:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002022:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002024:	14102773          	csrr	a4,sepc
    80002028:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    8000202a:	14202773          	csrr	a4,scause
  if (r_scause() == 15) {
    8000202e:	47bd                	li	a5,15
    80002030:	02f70c63          	beq	a4,a5,80002068 <usertrap+0x72>
    80002034:	14202773          	csrr	a4,scause
  } else if (r_scause() == 8) {
    80002038:	47a1                	li	a5,8
    8000203a:	04f70763          	beq	a4,a5,80002088 <usertrap+0x92>
  } else if ((which_dev = devintr()) != 0) {
    8000203e:	00000097          	auipc	ra,0x0
    80002042:	f0e080e7          	jalr	-242(ra) # 80001f4c <devintr>
    80002046:	892a                	mv	s2,a0
    80002048:	c949                	beqz	a0,800020da <usertrap+0xe4>
  if (killed(p)) exit(-1);
    8000204a:	8526                	mv	a0,s1
    8000204c:	00000097          	auipc	ra,0x0
    80002050:	9ac080e7          	jalr	-1620(ra) # 800019f8 <killed>
    80002054:	c571                	beqz	a0,80002120 <usertrap+0x12a>
    80002056:	a0c1                	j	80002116 <usertrap+0x120>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	29050513          	addi	a0,a0,656 # 800082e8 <etext+0x2e8>
    80002060:	00004097          	auipc	ra,0x4
    80002064:	022080e7          	jalr	34(ra) # 80006082 <panic>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002068:	143025f3          	csrr	a1,stval
    if (copyonwrite(p->pagetable, r_stval()) == -1) {
    8000206c:	6928                	ld	a0,80(a0)
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	cf0080e7          	jalr	-784(ra) # 80001d5e <copyonwrite>
    80002076:	57fd                	li	a5,-1
    80002078:	02f51b63          	bne	a0,a5,800020ae <usertrap+0xb8>
      setkilled(p);
    8000207c:	8526                	mv	a0,s1
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	94e080e7          	jalr	-1714(ra) # 800019cc <setkilled>
    80002086:	a025                	j	800020ae <usertrap+0xb8>
    if (killed(p)) exit(-1);
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	970080e7          	jalr	-1680(ra) # 800019f8 <killed>
    80002090:	ed1d                	bnez	a0,800020ce <usertrap+0xd8>
    p->trapframe->epc += 4;
    80002092:	6cb8                	ld	a4,88(s1)
    80002094:	6f1c                	ld	a5,24(a4)
    80002096:	0791                	addi	a5,a5,4
    80002098:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000209a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000209e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800020a2:	10079073          	csrw	sstatus,a5
    syscall();
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	2d4080e7          	jalr	724(ra) # 8000237a <syscall>
  if (killed(p)) exit(-1);
    800020ae:	8526                	mv	a0,s1
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	948080e7          	jalr	-1720(ra) # 800019f8 <killed>
    800020b8:	ed31                	bnez	a0,80002114 <usertrap+0x11e>
  usertrapret();
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	db6080e7          	jalr	-586(ra) # 80001e70 <usertrapret>
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret
    if (killed(p)) exit(-1);
    800020ce:	557d                	li	a0,-1
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	7b4080e7          	jalr	1972(ra) # 80001884 <exit>
    800020d8:	bf6d                	j	80002092 <usertrap+0x9c>
  asm volatile("csrr %0, scause" : "=r"(x));
    800020da:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800020de:	5890                	lw	a2,48(s1)
    800020e0:	00006517          	auipc	a0,0x6
    800020e4:	22850513          	addi	a0,a0,552 # 80008308 <etext+0x308>
    800020e8:	00004097          	auipc	ra,0x4
    800020ec:	fe4080e7          	jalr	-28(ra) # 800060cc <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020f0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800020f4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	24050513          	addi	a0,a0,576 # 80008338 <etext+0x338>
    80002100:	00004097          	auipc	ra,0x4
    80002104:	fcc080e7          	jalr	-52(ra) # 800060cc <printf>
    setkilled(p);
    80002108:	8526                	mv	a0,s1
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	8c2080e7          	jalr	-1854(ra) # 800019cc <setkilled>
    80002112:	bf71                	j	800020ae <usertrap+0xb8>
  if (killed(p)) exit(-1);
    80002114:	4901                	li	s2,0
    80002116:	557d                	li	a0,-1
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	76c080e7          	jalr	1900(ra) # 80001884 <exit>
  if (which_dev == 2) yield();
    80002120:	4789                	li	a5,2
    80002122:	f8f91ce3          	bne	s2,a5,800020ba <usertrap+0xc4>
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	5ee080e7          	jalr	1518(ra) # 80001714 <yield>
    8000212e:	b771                	j	800020ba <usertrap+0xc4>

0000000080002130 <kerneltrap>:
void kerneltrap() {
    80002130:	7179                	addi	sp,sp,-48
    80002132:	f406                	sd	ra,40(sp)
    80002134:	f022                	sd	s0,32(sp)
    80002136:	ec26                	sd	s1,24(sp)
    80002138:	e84a                	sd	s2,16(sp)
    8000213a:	e44e                	sd	s3,8(sp)
    8000213c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000213e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002142:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002146:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    8000214a:	1004f793          	andi	a5,s1,256
    8000214e:	cb85                	beqz	a5,8000217e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002150:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002154:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80002156:	ef85                	bnez	a5,8000218e <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	df4080e7          	jalr	-524(ra) # 80001f4c <devintr>
    80002160:	cd1d                	beqz	a0,8000219e <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80002162:	4789                	li	a5,2
    80002164:	06f50a63          	beq	a0,a5,800021d8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002168:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000216c:	10049073          	csrw	sstatus,s1
}
    80002170:	70a2                	ld	ra,40(sp)
    80002172:	7402                	ld	s0,32(sp)
    80002174:	64e2                	ld	s1,24(sp)
    80002176:	6942                	ld	s2,16(sp)
    80002178:	69a2                	ld	s3,8(sp)
    8000217a:	6145                	addi	sp,sp,48
    8000217c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000217e:	00006517          	auipc	a0,0x6
    80002182:	1da50513          	addi	a0,a0,474 # 80008358 <etext+0x358>
    80002186:	00004097          	auipc	ra,0x4
    8000218a:	efc080e7          	jalr	-260(ra) # 80006082 <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	1f250513          	addi	a0,a0,498 # 80008380 <etext+0x380>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	eec080e7          	jalr	-276(ra) # 80006082 <panic>
    printf("scause %p\n", scause);
    8000219e:	85ce                	mv	a1,s3
    800021a0:	00006517          	auipc	a0,0x6
    800021a4:	20050513          	addi	a0,a0,512 # 800083a0 <etext+0x3a0>
    800021a8:	00004097          	auipc	ra,0x4
    800021ac:	f24080e7          	jalr	-220(ra) # 800060cc <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800021b0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800021b4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	1f850513          	addi	a0,a0,504 # 800083b0 <etext+0x3b0>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	f0c080e7          	jalr	-244(ra) # 800060cc <printf>
    panic("kerneltrap");
    800021c8:	00006517          	auipc	a0,0x6
    800021cc:	20050513          	addi	a0,a0,512 # 800083c8 <etext+0x3c8>
    800021d0:	00004097          	auipc	ra,0x4
    800021d4:	eb2080e7          	jalr	-334(ra) # 80006082 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	eca080e7          	jalr	-310(ra) # 800010a2 <myproc>
    800021e0:	d541                	beqz	a0,80002168 <kerneltrap+0x38>
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	ec0080e7          	jalr	-320(ra) # 800010a2 <myproc>
    800021ea:	4d18                	lw	a4,24(a0)
    800021ec:	4791                	li	a5,4
    800021ee:	f6f71de3          	bne	a4,a5,80002168 <kerneltrap+0x38>
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	522080e7          	jalr	1314(ra) # 80001714 <yield>
    800021fa:	b7bd                	j	80002168 <kerneltrap+0x38>

00000000800021fc <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	1000                	addi	s0,sp,32
    80002206:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	e9a080e7          	jalr	-358(ra) # 800010a2 <myproc>
  switch (n) {
    80002210:	4795                	li	a5,5
    80002212:	0497e163          	bltu	a5,s1,80002254 <argraw+0x58>
    80002216:	048a                	slli	s1,s1,0x2
    80002218:	00006717          	auipc	a4,0x6
    8000221c:	5c070713          	addi	a4,a4,1472 # 800087d8 <states.0+0x30>
    80002220:	94ba                	add	s1,s1,a4
    80002222:	409c                	lw	a5,0(s1)
    80002224:	97ba                	add	a5,a5,a4
    80002226:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80002228:	6d3c                	ld	a5,88(a0)
    8000222a:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6105                	addi	sp,sp,32
    80002234:	8082                	ret
      return p->trapframe->a1;
    80002236:	6d3c                	ld	a5,88(a0)
    80002238:	7fa8                	ld	a0,120(a5)
    8000223a:	bfcd                	j	8000222c <argraw+0x30>
      return p->trapframe->a2;
    8000223c:	6d3c                	ld	a5,88(a0)
    8000223e:	63c8                	ld	a0,128(a5)
    80002240:	b7f5                	j	8000222c <argraw+0x30>
      return p->trapframe->a3;
    80002242:	6d3c                	ld	a5,88(a0)
    80002244:	67c8                	ld	a0,136(a5)
    80002246:	b7dd                	j	8000222c <argraw+0x30>
      return p->trapframe->a4;
    80002248:	6d3c                	ld	a5,88(a0)
    8000224a:	6bc8                	ld	a0,144(a5)
    8000224c:	b7c5                	j	8000222c <argraw+0x30>
      return p->trapframe->a5;
    8000224e:	6d3c                	ld	a5,88(a0)
    80002250:	6fc8                	ld	a0,152(a5)
    80002252:	bfe9                	j	8000222c <argraw+0x30>
  panic("argraw");
    80002254:	00006517          	auipc	a0,0x6
    80002258:	18450513          	addi	a0,a0,388 # 800083d8 <etext+0x3d8>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	e26080e7          	jalr	-474(ra) # 80006082 <panic>

0000000080002264 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	e04a                	sd	s2,0(sp)
    8000226e:	1000                	addi	s0,sp,32
    80002270:	84aa                	mv	s1,a0
    80002272:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	e2e080e7          	jalr	-466(ra) # 800010a2 <myproc>
  if (addr >= p->sz ||
    8000227c:	653c                	ld	a5,72(a0)
    8000227e:	02f4f863          	bgeu	s1,a5,800022ae <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80002282:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002286:	02e7e663          	bltu	a5,a4,800022b2 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    8000228a:	46a1                	li	a3,8
    8000228c:	8626                	mv	a2,s1
    8000228e:	85ca                	mv	a1,s2
    80002290:	6928                	ld	a0,80(a0)
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	a54080e7          	jalr	-1452(ra) # 80000ce6 <copyin>
    8000229a:	00a03533          	snez	a0,a0
    8000229e:	40a00533          	neg	a0,a0
}
    800022a2:	60e2                	ld	ra,24(sp)
    800022a4:	6442                	ld	s0,16(sp)
    800022a6:	64a2                	ld	s1,8(sp)
    800022a8:	6902                	ld	s2,0(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret
    return -1;
    800022ae:	557d                	li	a0,-1
    800022b0:	bfcd                	j	800022a2 <fetchaddr+0x3e>
    800022b2:	557d                	li	a0,-1
    800022b4:	b7fd                	j	800022a2 <fetchaddr+0x3e>

00000000800022b6 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    800022b6:	7179                	addi	sp,sp,-48
    800022b8:	f406                	sd	ra,40(sp)
    800022ba:	f022                	sd	s0,32(sp)
    800022bc:	ec26                	sd	s1,24(sp)
    800022be:	e84a                	sd	s2,16(sp)
    800022c0:	e44e                	sd	s3,8(sp)
    800022c2:	1800                	addi	s0,sp,48
    800022c4:	892a                	mv	s2,a0
    800022c6:	84ae                	mv	s1,a1
    800022c8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	dd8080e7          	jalr	-552(ra) # 800010a2 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800022d2:	86ce                	mv	a3,s3
    800022d4:	864a                	mv	a2,s2
    800022d6:	85a6                	mv	a1,s1
    800022d8:	6928                	ld	a0,80(a0)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	a9a080e7          	jalr	-1382(ra) # 80000d74 <copyinstr>
    800022e2:	00054e63          	bltz	a0,800022fe <fetchstr+0x48>
  return strlen(buf);
    800022e6:	8526                	mv	a0,s1
    800022e8:	ffffe097          	auipc	ra,0xffffe
    800022ec:	0aa080e7          	jalr	170(ra) # 80000392 <strlen>
}
    800022f0:	70a2                	ld	ra,40(sp)
    800022f2:	7402                	ld	s0,32(sp)
    800022f4:	64e2                	ld	s1,24(sp)
    800022f6:	6942                	ld	s2,16(sp)
    800022f8:	69a2                	ld	s3,8(sp)
    800022fa:	6145                	addi	sp,sp,48
    800022fc:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800022fe:	557d                	li	a0,-1
    80002300:	bfc5                	j	800022f0 <fetchstr+0x3a>

0000000080002302 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    80002302:	1101                	addi	sp,sp,-32
    80002304:	ec06                	sd	ra,24(sp)
    80002306:	e822                	sd	s0,16(sp)
    80002308:	e426                	sd	s1,8(sp)
    8000230a:	1000                	addi	s0,sp,32
    8000230c:	84ae                	mv	s1,a1
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	eee080e7          	jalr	-274(ra) # 800021fc <argraw>
    80002316:	c088                	sw	a0,0(s1)
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	64a2                	ld	s1,8(sp)
    8000231e:	6105                	addi	sp,sp,32
    80002320:	8082                	ret

0000000080002322 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    80002322:	1101                	addi	sp,sp,-32
    80002324:	ec06                	sd	ra,24(sp)
    80002326:	e822                	sd	s0,16(sp)
    80002328:	e426                	sd	s1,8(sp)
    8000232a:	1000                	addi	s0,sp,32
    8000232c:	84ae                	mv	s1,a1
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	ece080e7          	jalr	-306(ra) # 800021fc <argraw>
    80002336:	e088                	sd	a0,0(s1)
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	64a2                	ld	s1,8(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80002342:	7179                	addi	sp,sp,-48
    80002344:	f406                	sd	ra,40(sp)
    80002346:	f022                	sd	s0,32(sp)
    80002348:	ec26                	sd	s1,24(sp)
    8000234a:	e84a                	sd	s2,16(sp)
    8000234c:	1800                	addi	s0,sp,48
    8000234e:	84ae                	mv	s1,a1
    80002350:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002352:	fd840593          	addi	a1,s0,-40
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	fcc080e7          	jalr	-52(ra) # 80002322 <argaddr>
  return fetchstr(addr, buf, max);
    8000235e:	864a                	mv	a2,s2
    80002360:	85a6                	mv	a1,s1
    80002362:	fd843503          	ld	a0,-40(s0)
    80002366:	00000097          	auipc	ra,0x0
    8000236a:	f50080e7          	jalr	-176(ra) # 800022b6 <fetchstr>
}
    8000236e:	70a2                	ld	ra,40(sp)
    80002370:	7402                	ld	s0,32(sp)
    80002372:	64e2                	ld	s1,24(sp)
    80002374:	6942                	ld	s2,16(sp)
    80002376:	6145                	addi	sp,sp,48
    80002378:	8082                	ret

000000008000237a <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,
};

void syscall(void) {
    8000237a:	1101                	addi	sp,sp,-32
    8000237c:	ec06                	sd	ra,24(sp)
    8000237e:	e822                	sd	s0,16(sp)
    80002380:	e426                	sd	s1,8(sp)
    80002382:	e04a                	sd	s2,0(sp)
    80002384:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	d1c080e7          	jalr	-740(ra) # 800010a2 <myproc>
    8000238e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002390:	05853903          	ld	s2,88(a0)
    80002394:	0a893783          	ld	a5,168(s2)
    80002398:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000239c:	37fd                	addiw	a5,a5,-1
    8000239e:	4751                	li	a4,20
    800023a0:	00f76f63          	bltu	a4,a5,800023be <syscall+0x44>
    800023a4:	00369713          	slli	a4,a3,0x3
    800023a8:	00006797          	auipc	a5,0x6
    800023ac:	44878793          	addi	a5,a5,1096 # 800087f0 <syscalls>
    800023b0:	97ba                	add	a5,a5,a4
    800023b2:	639c                	ld	a5,0(a5)
    800023b4:	c789                	beqz	a5,800023be <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800023b6:	9782                	jalr	a5
    800023b8:	06a93823          	sd	a0,112(s2)
    800023bc:	a839                	j	800023da <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800023be:	15848613          	addi	a2,s1,344
    800023c2:	588c                	lw	a1,48(s1)
    800023c4:	00006517          	auipc	a0,0x6
    800023c8:	01c50513          	addi	a0,a0,28 # 800083e0 <etext+0x3e0>
    800023cc:	00004097          	auipc	ra,0x4
    800023d0:	d00080e7          	jalr	-768(ra) # 800060cc <printf>
    p->trapframe->a0 = -1;
    800023d4:	6cbc                	ld	a5,88(s1)
    800023d6:	577d                	li	a4,-1
    800023d8:	fbb8                	sd	a4,112(a5)
  }
}
    800023da:	60e2                	ld	ra,24(sp)
    800023dc:	6442                	ld	s0,16(sp)
    800023de:	64a2                	ld	s1,8(sp)
    800023e0:	6902                	ld	s2,0(sp)
    800023e2:	6105                	addi	sp,sp,32
    800023e4:	8082                	ret

00000000800023e6 <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    800023e6:	1101                	addi	sp,sp,-32
    800023e8:	ec06                	sd	ra,24(sp)
    800023ea:	e822                	sd	s0,16(sp)
    800023ec:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800023ee:	fec40593          	addi	a1,s0,-20
    800023f2:	4501                	li	a0,0
    800023f4:	00000097          	auipc	ra,0x0
    800023f8:	f0e080e7          	jalr	-242(ra) # 80002302 <argint>
  exit(n);
    800023fc:	fec42503          	lw	a0,-20(s0)
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	484080e7          	jalr	1156(ra) # 80001884 <exit>
  return 0;  // not reached
}
    80002408:	4501                	li	a0,0
    8000240a:	60e2                	ld	ra,24(sp)
    8000240c:	6442                	ld	s0,16(sp)
    8000240e:	6105                	addi	sp,sp,32
    80002410:	8082                	ret

0000000080002412 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002412:	1141                	addi	sp,sp,-16
    80002414:	e406                	sd	ra,8(sp)
    80002416:	e022                	sd	s0,0(sp)
    80002418:	0800                	addi	s0,sp,16
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	c88080e7          	jalr	-888(ra) # 800010a2 <myproc>
    80002422:	5908                	lw	a0,48(a0)
    80002424:	60a2                	ld	ra,8(sp)
    80002426:	6402                	ld	s0,0(sp)
    80002428:	0141                	addi	sp,sp,16
    8000242a:	8082                	ret

000000008000242c <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000242c:	1141                	addi	sp,sp,-16
    8000242e:	e406                	sd	ra,8(sp)
    80002430:	e022                	sd	s0,0(sp)
    80002432:	0800                	addi	s0,sp,16
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	028080e7          	jalr	40(ra) # 8000145c <fork>
    8000243c:	60a2                	ld	ra,8(sp)
    8000243e:	6402                	ld	s0,0(sp)
    80002440:	0141                	addi	sp,sp,16
    80002442:	8082                	ret

0000000080002444 <sys_wait>:

uint64 sys_wait(void) {
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000244c:	fe840593          	addi	a1,s0,-24
    80002450:	4501                	li	a0,0
    80002452:	00000097          	auipc	ra,0x0
    80002456:	ed0080e7          	jalr	-304(ra) # 80002322 <argaddr>
  return wait(p);
    8000245a:	fe843503          	ld	a0,-24(s0)
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	5cc080e7          	jalr	1484(ra) # 80001a2a <wait>
}
    80002466:	60e2                	ld	ra,24(sp)
    80002468:	6442                	ld	s0,16(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <sys_sbrk>:

uint64 sys_sbrk(void) {
    8000246e:	7179                	addi	sp,sp,-48
    80002470:	f406                	sd	ra,40(sp)
    80002472:	f022                	sd	s0,32(sp)
    80002474:	ec26                	sd	s1,24(sp)
    80002476:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002478:	fdc40593          	addi	a1,s0,-36
    8000247c:	4501                	li	a0,0
    8000247e:	00000097          	auipc	ra,0x0
    80002482:	e84080e7          	jalr	-380(ra) # 80002302 <argint>
  addr = myproc()->sz;
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	c1c080e7          	jalr	-996(ra) # 800010a2 <myproc>
    8000248e:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    80002490:	fdc42503          	lw	a0,-36(s0)
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	f6c080e7          	jalr	-148(ra) # 80001400 <growproc>
    8000249c:	00054863          	bltz	a0,800024ac <sys_sbrk+0x3e>
  return addr;
}
    800024a0:	8526                	mv	a0,s1
    800024a2:	70a2                	ld	ra,40(sp)
    800024a4:	7402                	ld	s0,32(sp)
    800024a6:	64e2                	ld	s1,24(sp)
    800024a8:	6145                	addi	sp,sp,48
    800024aa:	8082                	ret
  if (growproc(n) < 0) return -1;
    800024ac:	54fd                	li	s1,-1
    800024ae:	bfcd                	j	800024a0 <sys_sbrk+0x32>

00000000800024b0 <sys_sleep>:

uint64 sys_sleep(void) {
    800024b0:	7139                	addi	sp,sp,-64
    800024b2:	fc06                	sd	ra,56(sp)
    800024b4:	f822                	sd	s0,48(sp)
    800024b6:	f04a                	sd	s2,32(sp)
    800024b8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800024ba:	fcc40593          	addi	a1,s0,-52
    800024be:	4501                	li	a0,0
    800024c0:	00000097          	auipc	ra,0x0
    800024c4:	e42080e7          	jalr	-446(ra) # 80002302 <argint>
  if (n < 0) n = 0;
    800024c8:	fcc42783          	lw	a5,-52(s0)
    800024cc:	0807c163          	bltz	a5,8000254e <sys_sleep+0x9e>
  acquire(&tickslock);
    800024d0:	0002f517          	auipc	a0,0x2f
    800024d4:	d2850513          	addi	a0,a0,-728 # 800311f8 <tickslock>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	124080e7          	jalr	292(ra) # 800065fc <acquire>
  ticks0 = ticks;
    800024e0:	00009917          	auipc	s2,0x9
    800024e4:	e9892903          	lw	s2,-360(s2) # 8000b378 <ticks>
  while (ticks - ticks0 < n) {
    800024e8:	fcc42783          	lw	a5,-52(s0)
    800024ec:	c3b9                	beqz	a5,80002532 <sys_sleep+0x82>
    800024ee:	f426                	sd	s1,40(sp)
    800024f0:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024f2:	0002f997          	auipc	s3,0x2f
    800024f6:	d0698993          	addi	s3,s3,-762 # 800311f8 <tickslock>
    800024fa:	00009497          	auipc	s1,0x9
    800024fe:	e7e48493          	addi	s1,s1,-386 # 8000b378 <ticks>
    if (killed(myproc())) {
    80002502:	fffff097          	auipc	ra,0xfffff
    80002506:	ba0080e7          	jalr	-1120(ra) # 800010a2 <myproc>
    8000250a:	fffff097          	auipc	ra,0xfffff
    8000250e:	4ee080e7          	jalr	1262(ra) # 800019f8 <killed>
    80002512:	e129                	bnez	a0,80002554 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002514:	85ce                	mv	a1,s3
    80002516:	8526                	mv	a0,s1
    80002518:	fffff097          	auipc	ra,0xfffff
    8000251c:	238080e7          	jalr	568(ra) # 80001750 <sleep>
  while (ticks - ticks0 < n) {
    80002520:	409c                	lw	a5,0(s1)
    80002522:	412787bb          	subw	a5,a5,s2
    80002526:	fcc42703          	lw	a4,-52(s0)
    8000252a:	fce7ece3          	bltu	a5,a4,80002502 <sys_sleep+0x52>
    8000252e:	74a2                	ld	s1,40(sp)
    80002530:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002532:	0002f517          	auipc	a0,0x2f
    80002536:	cc650513          	addi	a0,a0,-826 # 800311f8 <tickslock>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	176080e7          	jalr	374(ra) # 800066b0 <release>
  return 0;
    80002542:	4501                	li	a0,0
}
    80002544:	70e2                	ld	ra,56(sp)
    80002546:	7442                	ld	s0,48(sp)
    80002548:	7902                	ld	s2,32(sp)
    8000254a:	6121                	addi	sp,sp,64
    8000254c:	8082                	ret
  if (n < 0) n = 0;
    8000254e:	fc042623          	sw	zero,-52(s0)
    80002552:	bfbd                	j	800024d0 <sys_sleep+0x20>
      release(&tickslock);
    80002554:	0002f517          	auipc	a0,0x2f
    80002558:	ca450513          	addi	a0,a0,-860 # 800311f8 <tickslock>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	154080e7          	jalr	340(ra) # 800066b0 <release>
      return -1;
    80002564:	557d                	li	a0,-1
    80002566:	74a2                	ld	s1,40(sp)
    80002568:	69e2                	ld	s3,24(sp)
    8000256a:	bfe9                	j	80002544 <sys_sleep+0x94>

000000008000256c <sys_kill>:

uint64 sys_kill(void) {
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002574:	fec40593          	addi	a1,s0,-20
    80002578:	4501                	li	a0,0
    8000257a:	00000097          	auipc	ra,0x0
    8000257e:	d88080e7          	jalr	-632(ra) # 80002302 <argint>
  return kill(pid);
    80002582:	fec42503          	lw	a0,-20(s0)
    80002586:	fffff097          	auipc	ra,0xfffff
    8000258a:	3d4080e7          	jalr	980(ra) # 8000195a <kill>
}
    8000258e:	60e2                	ld	ra,24(sp)
    80002590:	6442                	ld	s0,16(sp)
    80002592:	6105                	addi	sp,sp,32
    80002594:	8082                	ret

0000000080002596 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800025a0:	0002f517          	auipc	a0,0x2f
    800025a4:	c5850513          	addi	a0,a0,-936 # 800311f8 <tickslock>
    800025a8:	00004097          	auipc	ra,0x4
    800025ac:	054080e7          	jalr	84(ra) # 800065fc <acquire>
  xticks = ticks;
    800025b0:	00009497          	auipc	s1,0x9
    800025b4:	dc84a483          	lw	s1,-568(s1) # 8000b378 <ticks>
  release(&tickslock);
    800025b8:	0002f517          	auipc	a0,0x2f
    800025bc:	c4050513          	addi	a0,a0,-960 # 800311f8 <tickslock>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	0f0080e7          	jalr	240(ra) # 800066b0 <release>
  return xticks;
}
    800025c8:	02049513          	slli	a0,s1,0x20
    800025cc:	9101                	srli	a0,a0,0x20
    800025ce:	60e2                	ld	ra,24(sp)
    800025d0:	6442                	ld	s0,16(sp)
    800025d2:	64a2                	ld	s1,8(sp)
    800025d4:	6105                	addi	sp,sp,32
    800025d6:	8082                	ret

00000000800025d8 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    800025d8:	7179                	addi	sp,sp,-48
    800025da:	f406                	sd	ra,40(sp)
    800025dc:	f022                	sd	s0,32(sp)
    800025de:	ec26                	sd	s1,24(sp)
    800025e0:	e84a                	sd	s2,16(sp)
    800025e2:	e44e                	sd	s3,8(sp)
    800025e4:	e052                	sd	s4,0(sp)
    800025e6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025e8:	00006597          	auipc	a1,0x6
    800025ec:	e1858593          	addi	a1,a1,-488 # 80008400 <etext+0x400>
    800025f0:	0002f517          	auipc	a0,0x2f
    800025f4:	c2050513          	addi	a0,a0,-992 # 80031210 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	f74080e7          	jalr	-140(ra) # 8000656c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002600:	00037797          	auipc	a5,0x37
    80002604:	c1078793          	addi	a5,a5,-1008 # 80039210 <bcache+0x8000>
    80002608:	00037717          	auipc	a4,0x37
    8000260c:	e7070713          	addi	a4,a4,-400 # 80039478 <bcache+0x8268>
    80002610:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002614:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002618:	0002f497          	auipc	s1,0x2f
    8000261c:	c1048493          	addi	s1,s1,-1008 # 80031228 <bcache+0x18>
    b->next = bcache.head.next;
    80002620:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002622:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002624:	00006a17          	auipc	s4,0x6
    80002628:	de4a0a13          	addi	s4,s4,-540 # 80008408 <etext+0x408>
    b->next = bcache.head.next;
    8000262c:	2b893783          	ld	a5,696(s2)
    80002630:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002632:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002636:	85d2                	mv	a1,s4
    80002638:	01048513          	addi	a0,s1,16
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	4e8080e7          	jalr	1256(ra) # 80003b24 <initsleeplock>
    bcache.head.next->prev = b;
    80002644:	2b893783          	ld	a5,696(s2)
    80002648:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000264a:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    8000264e:	45848493          	addi	s1,s1,1112
    80002652:	fd349de3          	bne	s1,s3,8000262c <binit+0x54>
  }
}
    80002656:	70a2                	ld	ra,40(sp)
    80002658:	7402                	ld	s0,32(sp)
    8000265a:	64e2                	ld	s1,24(sp)
    8000265c:	6942                	ld	s2,16(sp)
    8000265e:	69a2                	ld	s3,8(sp)
    80002660:	6a02                	ld	s4,0(sp)
    80002662:	6145                	addi	sp,sp,48
    80002664:	8082                	ret

0000000080002666 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002666:	7179                	addi	sp,sp,-48
    80002668:	f406                	sd	ra,40(sp)
    8000266a:	f022                	sd	s0,32(sp)
    8000266c:	ec26                	sd	s1,24(sp)
    8000266e:	e84a                	sd	s2,16(sp)
    80002670:	e44e                	sd	s3,8(sp)
    80002672:	1800                	addi	s0,sp,48
    80002674:	892a                	mv	s2,a0
    80002676:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002678:	0002f517          	auipc	a0,0x2f
    8000267c:	b9850513          	addi	a0,a0,-1128 # 80031210 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	f7c080e7          	jalr	-132(ra) # 800065fc <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002688:	00037497          	auipc	s1,0x37
    8000268c:	e404b483          	ld	s1,-448(s1) # 800394c8 <bcache+0x82b8>
    80002690:	00037797          	auipc	a5,0x37
    80002694:	de878793          	addi	a5,a5,-536 # 80039478 <bcache+0x8268>
    80002698:	02f48f63          	beq	s1,a5,800026d6 <bread+0x70>
    8000269c:	873e                	mv	a4,a5
    8000269e:	a021                	j	800026a6 <bread+0x40>
    800026a0:	68a4                	ld	s1,80(s1)
    800026a2:	02e48a63          	beq	s1,a4,800026d6 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    800026a6:	449c                	lw	a5,8(s1)
    800026a8:	ff279ce3          	bne	a5,s2,800026a0 <bread+0x3a>
    800026ac:	44dc                	lw	a5,12(s1)
    800026ae:	ff3799e3          	bne	a5,s3,800026a0 <bread+0x3a>
      b->refcnt++;
    800026b2:	40bc                	lw	a5,64(s1)
    800026b4:	2785                	addiw	a5,a5,1
    800026b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026b8:	0002f517          	auipc	a0,0x2f
    800026bc:	b5850513          	addi	a0,a0,-1192 # 80031210 <bcache>
    800026c0:	00004097          	auipc	ra,0x4
    800026c4:	ff0080e7          	jalr	-16(ra) # 800066b0 <release>
      acquiresleep(&b->lock);
    800026c8:	01048513          	addi	a0,s1,16
    800026cc:	00001097          	auipc	ra,0x1
    800026d0:	492080e7          	jalr	1170(ra) # 80003b5e <acquiresleep>
      return b;
    800026d4:	a8b9                	j	80002732 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800026d6:	00037497          	auipc	s1,0x37
    800026da:	dea4b483          	ld	s1,-534(s1) # 800394c0 <bcache+0x82b0>
    800026de:	00037797          	auipc	a5,0x37
    800026e2:	d9a78793          	addi	a5,a5,-614 # 80039478 <bcache+0x8268>
    800026e6:	00f48863          	beq	s1,a5,800026f6 <bread+0x90>
    800026ea:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    800026ec:	40bc                	lw	a5,64(s1)
    800026ee:	cf81                	beqz	a5,80002706 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800026f0:	64a4                	ld	s1,72(s1)
    800026f2:	fee49de3          	bne	s1,a4,800026ec <bread+0x86>
  panic("bget: no buffers");
    800026f6:	00006517          	auipc	a0,0x6
    800026fa:	d1a50513          	addi	a0,a0,-742 # 80008410 <etext+0x410>
    800026fe:	00004097          	auipc	ra,0x4
    80002702:	984080e7          	jalr	-1660(ra) # 80006082 <panic>
      b->dev = dev;
    80002706:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000270a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000270e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002712:	4785                	li	a5,1
    80002714:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002716:	0002f517          	auipc	a0,0x2f
    8000271a:	afa50513          	addi	a0,a0,-1286 # 80031210 <bcache>
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	f92080e7          	jalr	-110(ra) # 800066b0 <release>
      acquiresleep(&b->lock);
    80002726:	01048513          	addi	a0,s1,16
    8000272a:	00001097          	auipc	ra,0x1
    8000272e:	434080e7          	jalr	1076(ra) # 80003b5e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002732:	409c                	lw	a5,0(s1)
    80002734:	cb89                	beqz	a5,80002746 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002736:	8526                	mv	a0,s1
    80002738:	70a2                	ld	ra,40(sp)
    8000273a:	7402                	ld	s0,32(sp)
    8000273c:	64e2                	ld	s1,24(sp)
    8000273e:	6942                	ld	s2,16(sp)
    80002740:	69a2                	ld	s3,8(sp)
    80002742:	6145                	addi	sp,sp,48
    80002744:	8082                	ret
    virtio_disk_rw(b, 0);
    80002746:	4581                	li	a1,0
    80002748:	8526                	mv	a0,s1
    8000274a:	00003097          	auipc	ra,0x3
    8000274e:	10e080e7          	jalr	270(ra) # 80005858 <virtio_disk_rw>
    b->valid = 1;
    80002752:	4785                	li	a5,1
    80002754:	c09c                	sw	a5,0(s1)
  return b;
    80002756:	b7c5                	j	80002736 <bread+0xd0>

0000000080002758 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    80002758:	1101                	addi	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	1000                	addi	s0,sp,32
    80002762:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002764:	0541                	addi	a0,a0,16
    80002766:	00001097          	auipc	ra,0x1
    8000276a:	492080e7          	jalr	1170(ra) # 80003bf8 <holdingsleep>
    8000276e:	cd01                	beqz	a0,80002786 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    80002770:	4585                	li	a1,1
    80002772:	8526                	mv	a0,s1
    80002774:	00003097          	auipc	ra,0x3
    80002778:	0e4080e7          	jalr	228(ra) # 80005858 <virtio_disk_rw>
}
    8000277c:	60e2                	ld	ra,24(sp)
    8000277e:	6442                	ld	s0,16(sp)
    80002780:	64a2                	ld	s1,8(sp)
    80002782:	6105                	addi	sp,sp,32
    80002784:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002786:	00006517          	auipc	a0,0x6
    8000278a:	ca250513          	addi	a0,a0,-862 # 80008428 <etext+0x428>
    8000278e:	00004097          	auipc	ra,0x4
    80002792:	8f4080e7          	jalr	-1804(ra) # 80006082 <panic>

0000000080002796 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002796:	1101                	addi	sp,sp,-32
    80002798:	ec06                	sd	ra,24(sp)
    8000279a:	e822                	sd	s0,16(sp)
    8000279c:	e426                	sd	s1,8(sp)
    8000279e:	e04a                	sd	s2,0(sp)
    800027a0:	1000                	addi	s0,sp,32
    800027a2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    800027a4:	01050913          	addi	s2,a0,16
    800027a8:	854a                	mv	a0,s2
    800027aa:	00001097          	auipc	ra,0x1
    800027ae:	44e080e7          	jalr	1102(ra) # 80003bf8 <holdingsleep>
    800027b2:	c925                	beqz	a0,80002822 <brelse+0x8c>

  releasesleep(&b->lock);
    800027b4:	854a                	mv	a0,s2
    800027b6:	00001097          	auipc	ra,0x1
    800027ba:	3fe080e7          	jalr	1022(ra) # 80003bb4 <releasesleep>

  acquire(&bcache.lock);
    800027be:	0002f517          	auipc	a0,0x2f
    800027c2:	a5250513          	addi	a0,a0,-1454 # 80031210 <bcache>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	e36080e7          	jalr	-458(ra) # 800065fc <acquire>
  b->refcnt--;
    800027ce:	40bc                	lw	a5,64(s1)
    800027d0:	37fd                	addiw	a5,a5,-1
    800027d2:	0007871b          	sext.w	a4,a5
    800027d6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027d8:	e71d                	bnez	a4,80002806 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800027da:	68b8                	ld	a4,80(s1)
    800027dc:	64bc                	ld	a5,72(s1)
    800027de:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800027e0:	68b8                	ld	a4,80(s1)
    800027e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027e4:	00037797          	auipc	a5,0x37
    800027e8:	a2c78793          	addi	a5,a5,-1492 # 80039210 <bcache+0x8000>
    800027ec:	2b87b703          	ld	a4,696(a5)
    800027f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027f2:	00037717          	auipc	a4,0x37
    800027f6:	c8670713          	addi	a4,a4,-890 # 80039478 <bcache+0x8268>
    800027fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027fc:	2b87b703          	ld	a4,696(a5)
    80002800:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002802:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002806:	0002f517          	auipc	a0,0x2f
    8000280a:	a0a50513          	addi	a0,a0,-1526 # 80031210 <bcache>
    8000280e:	00004097          	auipc	ra,0x4
    80002812:	ea2080e7          	jalr	-350(ra) # 800066b0 <release>
}
    80002816:	60e2                	ld	ra,24(sp)
    80002818:	6442                	ld	s0,16(sp)
    8000281a:	64a2                	ld	s1,8(sp)
    8000281c:	6902                	ld	s2,0(sp)
    8000281e:	6105                	addi	sp,sp,32
    80002820:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002822:	00006517          	auipc	a0,0x6
    80002826:	c0e50513          	addi	a0,a0,-1010 # 80008430 <etext+0x430>
    8000282a:	00004097          	auipc	ra,0x4
    8000282e:	858080e7          	jalr	-1960(ra) # 80006082 <panic>

0000000080002832 <bpin>:

void bpin(struct buf *b) {
    80002832:	1101                	addi	sp,sp,-32
    80002834:	ec06                	sd	ra,24(sp)
    80002836:	e822                	sd	s0,16(sp)
    80002838:	e426                	sd	s1,8(sp)
    8000283a:	1000                	addi	s0,sp,32
    8000283c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000283e:	0002f517          	auipc	a0,0x2f
    80002842:	9d250513          	addi	a0,a0,-1582 # 80031210 <bcache>
    80002846:	00004097          	auipc	ra,0x4
    8000284a:	db6080e7          	jalr	-586(ra) # 800065fc <acquire>
  b->refcnt++;
    8000284e:	40bc                	lw	a5,64(s1)
    80002850:	2785                	addiw	a5,a5,1
    80002852:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002854:	0002f517          	auipc	a0,0x2f
    80002858:	9bc50513          	addi	a0,a0,-1604 # 80031210 <bcache>
    8000285c:	00004097          	auipc	ra,0x4
    80002860:	e54080e7          	jalr	-428(ra) # 800066b0 <release>
}
    80002864:	60e2                	ld	ra,24(sp)
    80002866:	6442                	ld	s0,16(sp)
    80002868:	64a2                	ld	s1,8(sp)
    8000286a:	6105                	addi	sp,sp,32
    8000286c:	8082                	ret

000000008000286e <bunpin>:

void bunpin(struct buf *b) {
    8000286e:	1101                	addi	sp,sp,-32
    80002870:	ec06                	sd	ra,24(sp)
    80002872:	e822                	sd	s0,16(sp)
    80002874:	e426                	sd	s1,8(sp)
    80002876:	1000                	addi	s0,sp,32
    80002878:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000287a:	0002f517          	auipc	a0,0x2f
    8000287e:	99650513          	addi	a0,a0,-1642 # 80031210 <bcache>
    80002882:	00004097          	auipc	ra,0x4
    80002886:	d7a080e7          	jalr	-646(ra) # 800065fc <acquire>
  b->refcnt--;
    8000288a:	40bc                	lw	a5,64(s1)
    8000288c:	37fd                	addiw	a5,a5,-1
    8000288e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002890:	0002f517          	auipc	a0,0x2f
    80002894:	98050513          	addi	a0,a0,-1664 # 80031210 <bcache>
    80002898:	00004097          	auipc	ra,0x4
    8000289c:	e18080e7          	jalr	-488(ra) # 800066b0 <release>
}
    800028a0:	60e2                	ld	ra,24(sp)
    800028a2:	6442                	ld	s0,16(sp)
    800028a4:	64a2                	ld	s1,8(sp)
    800028a6:	6105                	addi	sp,sp,32
    800028a8:	8082                	ret

00000000800028aa <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    800028aa:	1101                	addi	sp,sp,-32
    800028ac:	ec06                	sd	ra,24(sp)
    800028ae:	e822                	sd	s0,16(sp)
    800028b0:	e426                	sd	s1,8(sp)
    800028b2:	e04a                	sd	s2,0(sp)
    800028b4:	1000                	addi	s0,sp,32
    800028b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028b8:	00d5d59b          	srliw	a1,a1,0xd
    800028bc:	00037797          	auipc	a5,0x37
    800028c0:	0307a783          	lw	a5,48(a5) # 800398ec <sb+0x1c>
    800028c4:	9dbd                	addw	a1,a1,a5
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	da0080e7          	jalr	-608(ra) # 80002666 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028ce:	0074f713          	andi	a4,s1,7
    800028d2:	4785                	li	a5,1
    800028d4:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800028d8:	14ce                	slli	s1,s1,0x33
    800028da:	90d9                	srli	s1,s1,0x36
    800028dc:	00950733          	add	a4,a0,s1
    800028e0:	05874703          	lbu	a4,88(a4)
    800028e4:	00e7f6b3          	and	a3,a5,a4
    800028e8:	c69d                	beqz	a3,80002916 <bfree+0x6c>
    800028ea:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    800028ec:	94aa                	add	s1,s1,a0
    800028ee:	fff7c793          	not	a5,a5
    800028f2:	8f7d                	and	a4,a4,a5
    800028f4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028f8:	00001097          	auipc	ra,0x1
    800028fc:	148080e7          	jalr	328(ra) # 80003a40 <log_write>
  brelse(bp);
    80002900:	854a                	mv	a0,s2
    80002902:	00000097          	auipc	ra,0x0
    80002906:	e94080e7          	jalr	-364(ra) # 80002796 <brelse>
}
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	64a2                	ld	s1,8(sp)
    80002910:	6902                	ld	s2,0(sp)
    80002912:	6105                	addi	sp,sp,32
    80002914:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	b2250513          	addi	a0,a0,-1246 # 80008438 <etext+0x438>
    8000291e:	00003097          	auipc	ra,0x3
    80002922:	764080e7          	jalr	1892(ra) # 80006082 <panic>

0000000080002926 <balloc>:
static uint balloc(uint dev) {
    80002926:	711d                	addi	sp,sp,-96
    80002928:	ec86                	sd	ra,88(sp)
    8000292a:	e8a2                	sd	s0,80(sp)
    8000292c:	e4a6                	sd	s1,72(sp)
    8000292e:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80002930:	00037797          	auipc	a5,0x37
    80002934:	fa47a783          	lw	a5,-92(a5) # 800398d4 <sb+0x4>
    80002938:	10078f63          	beqz	a5,80002a56 <balloc+0x130>
    8000293c:	e0ca                	sd	s2,64(sp)
    8000293e:	fc4e                	sd	s3,56(sp)
    80002940:	f852                	sd	s4,48(sp)
    80002942:	f456                	sd	s5,40(sp)
    80002944:	f05a                	sd	s6,32(sp)
    80002946:	ec5e                	sd	s7,24(sp)
    80002948:	e862                	sd	s8,16(sp)
    8000294a:	e466                	sd	s9,8(sp)
    8000294c:	8baa                	mv	s7,a0
    8000294e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002950:	00037b17          	auipc	s6,0x37
    80002954:	f80b0b13          	addi	s6,s6,-128 # 800398d0 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002958:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000295a:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000295c:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    8000295e:	6c89                	lui	s9,0x2
    80002960:	a061                	j	800029e8 <balloc+0xc2>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002962:	97ca                	add	a5,a5,s2
    80002964:	8e55                	or	a2,a2,a3
    80002966:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000296a:	854a                	mv	a0,s2
    8000296c:	00001097          	auipc	ra,0x1
    80002970:	0d4080e7          	jalr	212(ra) # 80003a40 <log_write>
        brelse(bp);
    80002974:	854a                	mv	a0,s2
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	e20080e7          	jalr	-480(ra) # 80002796 <brelse>
  bp = bread(dev, bno);
    8000297e:	85a6                	mv	a1,s1
    80002980:	855e                	mv	a0,s7
    80002982:	00000097          	auipc	ra,0x0
    80002986:	ce4080e7          	jalr	-796(ra) # 80002666 <bread>
    8000298a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000298c:	40000613          	li	a2,1024
    80002990:	4581                	li	a1,0
    80002992:	05850513          	addi	a0,a0,88
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	888080e7          	jalr	-1912(ra) # 8000021e <memset>
  log_write(bp);
    8000299e:	854a                	mv	a0,s2
    800029a0:	00001097          	auipc	ra,0x1
    800029a4:	0a0080e7          	jalr	160(ra) # 80003a40 <log_write>
  brelse(bp);
    800029a8:	854a                	mv	a0,s2
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	dec080e7          	jalr	-532(ra) # 80002796 <brelse>
}
    800029b2:	6906                	ld	s2,64(sp)
    800029b4:	79e2                	ld	s3,56(sp)
    800029b6:	7a42                	ld	s4,48(sp)
    800029b8:	7aa2                	ld	s5,40(sp)
    800029ba:	7b02                	ld	s6,32(sp)
    800029bc:	6be2                	ld	s7,24(sp)
    800029be:	6c42                	ld	s8,16(sp)
    800029c0:	6ca2                	ld	s9,8(sp)
}
    800029c2:	8526                	mv	a0,s1
    800029c4:	60e6                	ld	ra,88(sp)
    800029c6:	6446                	ld	s0,80(sp)
    800029c8:	64a6                	ld	s1,72(sp)
    800029ca:	6125                	addi	sp,sp,96
    800029cc:	8082                	ret
    brelse(bp);
    800029ce:	854a                	mv	a0,s2
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	dc6080e7          	jalr	-570(ra) # 80002796 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800029d8:	015c87bb          	addw	a5,s9,s5
    800029dc:	00078a9b          	sext.w	s5,a5
    800029e0:	004b2703          	lw	a4,4(s6)
    800029e4:	06eaf163          	bgeu	s5,a4,80002a46 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800029e8:	41fad79b          	sraiw	a5,s5,0x1f
    800029ec:	0137d79b          	srliw	a5,a5,0x13
    800029f0:	015787bb          	addw	a5,a5,s5
    800029f4:	40d7d79b          	sraiw	a5,a5,0xd
    800029f8:	01cb2583          	lw	a1,28(s6)
    800029fc:	9dbd                	addw	a1,a1,a5
    800029fe:	855e                	mv	a0,s7
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	c66080e7          	jalr	-922(ra) # 80002666 <bread>
    80002a08:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002a0a:	004b2503          	lw	a0,4(s6)
    80002a0e:	000a849b          	sext.w	s1,s5
    80002a12:	8762                	mv	a4,s8
    80002a14:	faa4fde3          	bgeu	s1,a0,800029ce <balloc+0xa8>
      m = 1 << (bi % 8);
    80002a18:	00777693          	andi	a3,a4,7
    80002a1c:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    80002a20:	41f7579b          	sraiw	a5,a4,0x1f
    80002a24:	01d7d79b          	srliw	a5,a5,0x1d
    80002a28:	9fb9                	addw	a5,a5,a4
    80002a2a:	4037d79b          	sraiw	a5,a5,0x3
    80002a2e:	00f90633          	add	a2,s2,a5
    80002a32:	05864603          	lbu	a2,88(a2)
    80002a36:	00c6f5b3          	and	a1,a3,a2
    80002a3a:	d585                	beqz	a1,80002962 <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002a3c:	2705                	addiw	a4,a4,1
    80002a3e:	2485                	addiw	s1,s1,1
    80002a40:	fd471ae3          	bne	a4,s4,80002a14 <balloc+0xee>
    80002a44:	b769                	j	800029ce <balloc+0xa8>
    80002a46:	6906                	ld	s2,64(sp)
    80002a48:	79e2                	ld	s3,56(sp)
    80002a4a:	7a42                	ld	s4,48(sp)
    80002a4c:	7aa2                	ld	s5,40(sp)
    80002a4e:	7b02                	ld	s6,32(sp)
    80002a50:	6be2                	ld	s7,24(sp)
    80002a52:	6c42                	ld	s8,16(sp)
    80002a54:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002a56:	00006517          	auipc	a0,0x6
    80002a5a:	9fa50513          	addi	a0,a0,-1542 # 80008450 <etext+0x450>
    80002a5e:	00003097          	auipc	ra,0x3
    80002a62:	66e080e7          	jalr	1646(ra) # 800060cc <printf>
  return 0;
    80002a66:	4481                	li	s1,0
    80002a68:	bfa9                	j	800029c2 <balloc+0x9c>

0000000080002a6a <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    80002a6a:	7179                	addi	sp,sp,-48
    80002a6c:	f406                	sd	ra,40(sp)
    80002a6e:	f022                	sd	s0,32(sp)
    80002a70:	ec26                	sd	s1,24(sp)
    80002a72:	e84a                	sd	s2,16(sp)
    80002a74:	e44e                	sd	s3,8(sp)
    80002a76:	1800                	addi	s0,sp,48
    80002a78:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002a7a:	47ad                	li	a5,11
    80002a7c:	02b7e863          	bltu	a5,a1,80002aac <bmap+0x42>
    if ((addr = ip->addrs[bn]) == 0) {
    80002a80:	02059793          	slli	a5,a1,0x20
    80002a84:	01e7d593          	srli	a1,a5,0x1e
    80002a88:	00b504b3          	add	s1,a0,a1
    80002a8c:	0504a903          	lw	s2,80(s1)
    80002a90:	08091263          	bnez	s2,80002b14 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002a94:	4108                	lw	a0,0(a0)
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	e90080e7          	jalr	-368(ra) # 80002926 <balloc>
    80002a9e:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002aa2:	06090963          	beqz	s2,80002b14 <bmap+0xaa>
      ip->addrs[bn] = addr;
    80002aa6:	0524a823          	sw	s2,80(s1)
    80002aaa:	a0ad                	j	80002b14 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002aac:	ff45849b          	addiw	s1,a1,-12
    80002ab0:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002ab4:	0ff00793          	li	a5,255
    80002ab8:	08e7e863          	bltu	a5,a4,80002b48 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002abc:	08052903          	lw	s2,128(a0)
    80002ac0:	00091f63          	bnez	s2,80002ade <bmap+0x74>
      addr = balloc(ip->dev);
    80002ac4:	4108                	lw	a0,0(a0)
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	e60080e7          	jalr	-416(ra) # 80002926 <balloc>
    80002ace:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002ad2:	04090163          	beqz	s2,80002b14 <bmap+0xaa>
    80002ad6:	e052                	sd	s4,0(sp)
      ip->addrs[NDIRECT] = addr;
    80002ad8:	0929a023          	sw	s2,128(s3)
    80002adc:	a011                	j	80002ae0 <bmap+0x76>
    80002ade:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002ae0:	85ca                	mv	a1,s2
    80002ae2:	0009a503          	lw	a0,0(s3)
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	b80080e7          	jalr	-1152(ra) # 80002666 <bread>
    80002aee:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002af0:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002af4:	02049713          	slli	a4,s1,0x20
    80002af8:	01e75593          	srli	a1,a4,0x1e
    80002afc:	00b784b3          	add	s1,a5,a1
    80002b00:	0004a903          	lw	s2,0(s1)
    80002b04:	02090063          	beqz	s2,80002b24 <bmap+0xba>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002b08:	8552                	mv	a0,s4
    80002b0a:	00000097          	auipc	ra,0x0
    80002b0e:	c8c080e7          	jalr	-884(ra) # 80002796 <brelse>
    return addr;
    80002b12:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002b14:	854a                	mv	a0,s2
    80002b16:	70a2                	ld	ra,40(sp)
    80002b18:	7402                	ld	s0,32(sp)
    80002b1a:	64e2                	ld	s1,24(sp)
    80002b1c:	6942                	ld	s2,16(sp)
    80002b1e:	69a2                	ld	s3,8(sp)
    80002b20:	6145                	addi	sp,sp,48
    80002b22:	8082                	ret
      addr = balloc(ip->dev);
    80002b24:	0009a503          	lw	a0,0(s3)
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	dfe080e7          	jalr	-514(ra) # 80002926 <balloc>
    80002b30:	0005091b          	sext.w	s2,a0
      if (addr) {
    80002b34:	fc090ae3          	beqz	s2,80002b08 <bmap+0x9e>
        a[bn] = addr;
    80002b38:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b3c:	8552                	mv	a0,s4
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	f02080e7          	jalr	-254(ra) # 80003a40 <log_write>
    80002b46:	b7c9                	j	80002b08 <bmap+0x9e>
    80002b48:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	91e50513          	addi	a0,a0,-1762 # 80008468 <etext+0x468>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	530080e7          	jalr	1328(ra) # 80006082 <panic>

0000000080002b5a <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002b5a:	7179                	addi	sp,sp,-48
    80002b5c:	f406                	sd	ra,40(sp)
    80002b5e:	f022                	sd	s0,32(sp)
    80002b60:	ec26                	sd	s1,24(sp)
    80002b62:	e84a                	sd	s2,16(sp)
    80002b64:	e44e                	sd	s3,8(sp)
    80002b66:	e052                	sd	s4,0(sp)
    80002b68:	1800                	addi	s0,sp,48
    80002b6a:	89aa                	mv	s3,a0
    80002b6c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b6e:	00037517          	auipc	a0,0x37
    80002b72:	d8250513          	addi	a0,a0,-638 # 800398f0 <itable>
    80002b76:	00004097          	auipc	ra,0x4
    80002b7a:	a86080e7          	jalr	-1402(ra) # 800065fc <acquire>
  empty = 0;
    80002b7e:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b80:	00037497          	auipc	s1,0x37
    80002b84:	d8848493          	addi	s1,s1,-632 # 80039908 <itable+0x18>
    80002b88:	00039697          	auipc	a3,0x39
    80002b8c:	81068693          	addi	a3,a3,-2032 # 8003b398 <log>
    80002b90:	a039                	j	80002b9e <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b92:	02090b63          	beqz	s2,80002bc8 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b96:	08848493          	addi	s1,s1,136
    80002b9a:	02d48a63          	beq	s1,a3,80002bce <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002b9e:	449c                	lw	a5,8(s1)
    80002ba0:	fef059e3          	blez	a5,80002b92 <iget+0x38>
    80002ba4:	4098                	lw	a4,0(s1)
    80002ba6:	ff3716e3          	bne	a4,s3,80002b92 <iget+0x38>
    80002baa:	40d8                	lw	a4,4(s1)
    80002bac:	ff4713e3          	bne	a4,s4,80002b92 <iget+0x38>
      ip->ref++;
    80002bb0:	2785                	addiw	a5,a5,1
    80002bb2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002bb4:	00037517          	auipc	a0,0x37
    80002bb8:	d3c50513          	addi	a0,a0,-708 # 800398f0 <itable>
    80002bbc:	00004097          	auipc	ra,0x4
    80002bc0:	af4080e7          	jalr	-1292(ra) # 800066b0 <release>
      return ip;
    80002bc4:	8926                	mv	s2,s1
    80002bc6:	a03d                	j	80002bf4 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002bc8:	f7f9                	bnez	a5,80002b96 <iget+0x3c>
      empty = ip;
    80002bca:	8926                	mv	s2,s1
    80002bcc:	b7e9                	j	80002b96 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002bce:	02090c63          	beqz	s2,80002c06 <iget+0xac>
  ip->dev = dev;
    80002bd2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002bd6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002bda:	4785                	li	a5,1
    80002bdc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002be0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002be4:	00037517          	auipc	a0,0x37
    80002be8:	d0c50513          	addi	a0,a0,-756 # 800398f0 <itable>
    80002bec:	00004097          	auipc	ra,0x4
    80002bf0:	ac4080e7          	jalr	-1340(ra) # 800066b0 <release>
}
    80002bf4:	854a                	mv	a0,s2
    80002bf6:	70a2                	ld	ra,40(sp)
    80002bf8:	7402                	ld	s0,32(sp)
    80002bfa:	64e2                	ld	s1,24(sp)
    80002bfc:	6942                	ld	s2,16(sp)
    80002bfe:	69a2                	ld	s3,8(sp)
    80002c00:	6a02                	ld	s4,0(sp)
    80002c02:	6145                	addi	sp,sp,48
    80002c04:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	87a50513          	addi	a0,a0,-1926 # 80008480 <etext+0x480>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	474080e7          	jalr	1140(ra) # 80006082 <panic>

0000000080002c16 <fsinit>:
void fsinit(int dev) {
    80002c16:	7179                	addi	sp,sp,-48
    80002c18:	f406                	sd	ra,40(sp)
    80002c1a:	f022                	sd	s0,32(sp)
    80002c1c:	ec26                	sd	s1,24(sp)
    80002c1e:	e84a                	sd	s2,16(sp)
    80002c20:	e44e                	sd	s3,8(sp)
    80002c22:	1800                	addi	s0,sp,48
    80002c24:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c26:	4585                	li	a1,1
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	a3e080e7          	jalr	-1474(ra) # 80002666 <bread>
    80002c30:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c32:	00037997          	auipc	s3,0x37
    80002c36:	c9e98993          	addi	s3,s3,-866 # 800398d0 <sb>
    80002c3a:	02000613          	li	a2,32
    80002c3e:	05850593          	addi	a1,a0,88
    80002c42:	854e                	mv	a0,s3
    80002c44:	ffffd097          	auipc	ra,0xffffd
    80002c48:	636080e7          	jalr	1590(ra) # 8000027a <memmove>
  brelse(bp);
    80002c4c:	8526                	mv	a0,s1
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	b48080e7          	jalr	-1208(ra) # 80002796 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002c56:	0009a703          	lw	a4,0(s3)
    80002c5a:	102037b7          	lui	a5,0x10203
    80002c5e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c62:	02f71263          	bne	a4,a5,80002c86 <fsinit+0x70>
  initlog(dev, &sb);
    80002c66:	00037597          	auipc	a1,0x37
    80002c6a:	c6a58593          	addi	a1,a1,-918 # 800398d0 <sb>
    80002c6e:	854a                	mv	a0,s2
    80002c70:	00001097          	auipc	ra,0x1
    80002c74:	b60080e7          	jalr	-1184(ra) # 800037d0 <initlog>
}
    80002c78:	70a2                	ld	ra,40(sp)
    80002c7a:	7402                	ld	s0,32(sp)
    80002c7c:	64e2                	ld	s1,24(sp)
    80002c7e:	6942                	ld	s2,16(sp)
    80002c80:	69a2                	ld	s3,8(sp)
    80002c82:	6145                	addi	sp,sp,48
    80002c84:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002c86:	00006517          	auipc	a0,0x6
    80002c8a:	80a50513          	addi	a0,a0,-2038 # 80008490 <etext+0x490>
    80002c8e:	00003097          	auipc	ra,0x3
    80002c92:	3f4080e7          	jalr	1012(ra) # 80006082 <panic>

0000000080002c96 <iinit>:
void iinit() {
    80002c96:	7179                	addi	sp,sp,-48
    80002c98:	f406                	sd	ra,40(sp)
    80002c9a:	f022                	sd	s0,32(sp)
    80002c9c:	ec26                	sd	s1,24(sp)
    80002c9e:	e84a                	sd	s2,16(sp)
    80002ca0:	e44e                	sd	s3,8(sp)
    80002ca2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ca4:	00006597          	auipc	a1,0x6
    80002ca8:	80458593          	addi	a1,a1,-2044 # 800084a8 <etext+0x4a8>
    80002cac:	00037517          	auipc	a0,0x37
    80002cb0:	c4450513          	addi	a0,a0,-956 # 800398f0 <itable>
    80002cb4:	00004097          	auipc	ra,0x4
    80002cb8:	8b8080e7          	jalr	-1864(ra) # 8000656c <initlock>
  for (i = 0; i < NINODE; i++) {
    80002cbc:	00037497          	auipc	s1,0x37
    80002cc0:	c5c48493          	addi	s1,s1,-932 # 80039918 <itable+0x28>
    80002cc4:	00038997          	auipc	s3,0x38
    80002cc8:	6e498993          	addi	s3,s3,1764 # 8003b3a8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ccc:	00005917          	auipc	s2,0x5
    80002cd0:	7e490913          	addi	s2,s2,2020 # 800084b0 <etext+0x4b0>
    80002cd4:	85ca                	mv	a1,s2
    80002cd6:	8526                	mv	a0,s1
    80002cd8:	00001097          	auipc	ra,0x1
    80002cdc:	e4c080e7          	jalr	-436(ra) # 80003b24 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002ce0:	08848493          	addi	s1,s1,136
    80002ce4:	ff3498e3          	bne	s1,s3,80002cd4 <iinit+0x3e>
}
    80002ce8:	70a2                	ld	ra,40(sp)
    80002cea:	7402                	ld	s0,32(sp)
    80002cec:	64e2                	ld	s1,24(sp)
    80002cee:	6942                	ld	s2,16(sp)
    80002cf0:	69a2                	ld	s3,8(sp)
    80002cf2:	6145                	addi	sp,sp,48
    80002cf4:	8082                	ret

0000000080002cf6 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002cf6:	7139                	addi	sp,sp,-64
    80002cf8:	fc06                	sd	ra,56(sp)
    80002cfa:	f822                	sd	s0,48(sp)
    80002cfc:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002cfe:	00037717          	auipc	a4,0x37
    80002d02:	bde72703          	lw	a4,-1058(a4) # 800398dc <sb+0xc>
    80002d06:	4785                	li	a5,1
    80002d08:	06e7f463          	bgeu	a5,a4,80002d70 <ialloc+0x7a>
    80002d0c:	f426                	sd	s1,40(sp)
    80002d0e:	f04a                	sd	s2,32(sp)
    80002d10:	ec4e                	sd	s3,24(sp)
    80002d12:	e852                	sd	s4,16(sp)
    80002d14:	e456                	sd	s5,8(sp)
    80002d16:	e05a                	sd	s6,0(sp)
    80002d18:	8aaa                	mv	s5,a0
    80002d1a:	8b2e                	mv	s6,a1
    80002d1c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d1e:	00037a17          	auipc	s4,0x37
    80002d22:	bb2a0a13          	addi	s4,s4,-1102 # 800398d0 <sb>
    80002d26:	00495593          	srli	a1,s2,0x4
    80002d2a:	018a2783          	lw	a5,24(s4)
    80002d2e:	9dbd                	addw	a1,a1,a5
    80002d30:	8556                	mv	a0,s5
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	934080e7          	jalr	-1740(ra) # 80002666 <bread>
    80002d3a:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002d3c:	05850993          	addi	s3,a0,88
    80002d40:	00f97793          	andi	a5,s2,15
    80002d44:	079a                	slli	a5,a5,0x6
    80002d46:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002d48:	00099783          	lh	a5,0(s3)
    80002d4c:	cf9d                	beqz	a5,80002d8a <ialloc+0x94>
    brelse(bp);
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	a48080e7          	jalr	-1464(ra) # 80002796 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002d56:	0905                	addi	s2,s2,1
    80002d58:	00ca2703          	lw	a4,12(s4)
    80002d5c:	0009079b          	sext.w	a5,s2
    80002d60:	fce7e3e3          	bltu	a5,a4,80002d26 <ialloc+0x30>
    80002d64:	74a2                	ld	s1,40(sp)
    80002d66:	7902                	ld	s2,32(sp)
    80002d68:	69e2                	ld	s3,24(sp)
    80002d6a:	6a42                	ld	s4,16(sp)
    80002d6c:	6aa2                	ld	s5,8(sp)
    80002d6e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002d70:	00005517          	auipc	a0,0x5
    80002d74:	74850513          	addi	a0,a0,1864 # 800084b8 <etext+0x4b8>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	354080e7          	jalr	852(ra) # 800060cc <printf>
  return 0;
    80002d80:	4501                	li	a0,0
}
    80002d82:	70e2                	ld	ra,56(sp)
    80002d84:	7442                	ld	s0,48(sp)
    80002d86:	6121                	addi	sp,sp,64
    80002d88:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d8a:	04000613          	li	a2,64
    80002d8e:	4581                	li	a1,0
    80002d90:	854e                	mv	a0,s3
    80002d92:	ffffd097          	auipc	ra,0xffffd
    80002d96:	48c080e7          	jalr	1164(ra) # 8000021e <memset>
      dip->type = type;
    80002d9a:	01699023          	sh	s6,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002d9e:	8526                	mv	a0,s1
    80002da0:	00001097          	auipc	ra,0x1
    80002da4:	ca0080e7          	jalr	-864(ra) # 80003a40 <log_write>
      brelse(bp);
    80002da8:	8526                	mv	a0,s1
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	9ec080e7          	jalr	-1556(ra) # 80002796 <brelse>
      return iget(dev, inum);
    80002db2:	0009059b          	sext.w	a1,s2
    80002db6:	8556                	mv	a0,s5
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	da2080e7          	jalr	-606(ra) # 80002b5a <iget>
    80002dc0:	74a2                	ld	s1,40(sp)
    80002dc2:	7902                	ld	s2,32(sp)
    80002dc4:	69e2                	ld	s3,24(sp)
    80002dc6:	6a42                	ld	s4,16(sp)
    80002dc8:	6aa2                	ld	s5,8(sp)
    80002dca:	6b02                	ld	s6,0(sp)
    80002dcc:	bf5d                	j	80002d82 <ialloc+0x8c>

0000000080002dce <iupdate>:
void iupdate(struct inode *ip) {
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	e04a                	sd	s2,0(sp)
    80002dd8:	1000                	addi	s0,sp,32
    80002dda:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ddc:	415c                	lw	a5,4(a0)
    80002dde:	0047d79b          	srliw	a5,a5,0x4
    80002de2:	00037597          	auipc	a1,0x37
    80002de6:	b065a583          	lw	a1,-1274(a1) # 800398e8 <sb+0x18>
    80002dea:	9dbd                	addw	a1,a1,a5
    80002dec:	4108                	lw	a0,0(a0)
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	878080e7          	jalr	-1928(ra) # 80002666 <bread>
    80002df6:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002df8:	05850793          	addi	a5,a0,88
    80002dfc:	40d8                	lw	a4,4(s1)
    80002dfe:	8b3d                	andi	a4,a4,15
    80002e00:	071a                	slli	a4,a4,0x6
    80002e02:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002e04:	04449703          	lh	a4,68(s1)
    80002e08:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002e0c:	04649703          	lh	a4,70(s1)
    80002e10:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002e14:	04849703          	lh	a4,72(s1)
    80002e18:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002e1c:	04a49703          	lh	a4,74(s1)
    80002e20:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e24:	44f8                	lw	a4,76(s1)
    80002e26:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e28:	03400613          	li	a2,52
    80002e2c:	05048593          	addi	a1,s1,80
    80002e30:	00c78513          	addi	a0,a5,12
    80002e34:	ffffd097          	auipc	ra,0xffffd
    80002e38:	446080e7          	jalr	1094(ra) # 8000027a <memmove>
  log_write(bp);
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	00001097          	auipc	ra,0x1
    80002e42:	c02080e7          	jalr	-1022(ra) # 80003a40 <log_write>
  brelse(bp);
    80002e46:	854a                	mv	a0,s2
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	94e080e7          	jalr	-1714(ra) # 80002796 <brelse>
}
    80002e50:	60e2                	ld	ra,24(sp)
    80002e52:	6442                	ld	s0,16(sp)
    80002e54:	64a2                	ld	s1,8(sp)
    80002e56:	6902                	ld	s2,0(sp)
    80002e58:	6105                	addi	sp,sp,32
    80002e5a:	8082                	ret

0000000080002e5c <idup>:
struct inode *idup(struct inode *ip) {
    80002e5c:	1101                	addi	sp,sp,-32
    80002e5e:	ec06                	sd	ra,24(sp)
    80002e60:	e822                	sd	s0,16(sp)
    80002e62:	e426                	sd	s1,8(sp)
    80002e64:	1000                	addi	s0,sp,32
    80002e66:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e68:	00037517          	auipc	a0,0x37
    80002e6c:	a8850513          	addi	a0,a0,-1400 # 800398f0 <itable>
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	78c080e7          	jalr	1932(ra) # 800065fc <acquire>
  ip->ref++;
    80002e78:	449c                	lw	a5,8(s1)
    80002e7a:	2785                	addiw	a5,a5,1
    80002e7c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e7e:	00037517          	auipc	a0,0x37
    80002e82:	a7250513          	addi	a0,a0,-1422 # 800398f0 <itable>
    80002e86:	00004097          	auipc	ra,0x4
    80002e8a:	82a080e7          	jalr	-2006(ra) # 800066b0 <release>
}
    80002e8e:	8526                	mv	a0,s1
    80002e90:	60e2                	ld	ra,24(sp)
    80002e92:	6442                	ld	s0,16(sp)
    80002e94:	64a2                	ld	s1,8(sp)
    80002e96:	6105                	addi	sp,sp,32
    80002e98:	8082                	ret

0000000080002e9a <ilock>:
void ilock(struct inode *ip) {
    80002e9a:	1101                	addi	sp,sp,-32
    80002e9c:	ec06                	sd	ra,24(sp)
    80002e9e:	e822                	sd	s0,16(sp)
    80002ea0:	e426                	sd	s1,8(sp)
    80002ea2:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002ea4:	c10d                	beqz	a0,80002ec6 <ilock+0x2c>
    80002ea6:	84aa                	mv	s1,a0
    80002ea8:	451c                	lw	a5,8(a0)
    80002eaa:	00f05e63          	blez	a5,80002ec6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002eae:	0541                	addi	a0,a0,16
    80002eb0:	00001097          	auipc	ra,0x1
    80002eb4:	cae080e7          	jalr	-850(ra) # 80003b5e <acquiresleep>
  if (ip->valid == 0) {
    80002eb8:	40bc                	lw	a5,64(s1)
    80002eba:	cf99                	beqz	a5,80002ed8 <ilock+0x3e>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret
    80002ec6:	e04a                	sd	s2,0(sp)
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	60850513          	addi	a0,a0,1544 # 800084d0 <etext+0x4d0>
    80002ed0:	00003097          	auipc	ra,0x3
    80002ed4:	1b2080e7          	jalr	434(ra) # 80006082 <panic>
    80002ed8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002eda:	40dc                	lw	a5,4(s1)
    80002edc:	0047d79b          	srliw	a5,a5,0x4
    80002ee0:	00037597          	auipc	a1,0x37
    80002ee4:	a085a583          	lw	a1,-1528(a1) # 800398e8 <sb+0x18>
    80002ee8:	9dbd                	addw	a1,a1,a5
    80002eea:	4088                	lw	a0,0(s1)
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	77a080e7          	jalr	1914(ra) # 80002666 <bread>
    80002ef4:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002ef6:	05850593          	addi	a1,a0,88
    80002efa:	40dc                	lw	a5,4(s1)
    80002efc:	8bbd                	andi	a5,a5,15
    80002efe:	079a                	slli	a5,a5,0x6
    80002f00:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f02:	00059783          	lh	a5,0(a1)
    80002f06:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f0a:	00259783          	lh	a5,2(a1)
    80002f0e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002f12:	00459783          	lh	a5,4(a1)
    80002f16:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002f1a:	00659783          	lh	a5,6(a1)
    80002f1e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f22:	459c                	lw	a5,8(a1)
    80002f24:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f26:	03400613          	li	a2,52
    80002f2a:	05b1                	addi	a1,a1,12
    80002f2c:	05048513          	addi	a0,s1,80
    80002f30:	ffffd097          	auipc	ra,0xffffd
    80002f34:	34a080e7          	jalr	842(ra) # 8000027a <memmove>
    brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	85c080e7          	jalr	-1956(ra) # 80002796 <brelse>
    ip->valid = 1;
    80002f42:	4785                	li	a5,1
    80002f44:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002f46:	04449783          	lh	a5,68(s1)
    80002f4a:	c399                	beqz	a5,80002f50 <ilock+0xb6>
    80002f4c:	6902                	ld	s2,0(sp)
    80002f4e:	b7bd                	j	80002ebc <ilock+0x22>
    80002f50:	00005517          	auipc	a0,0x5
    80002f54:	58850513          	addi	a0,a0,1416 # 800084d8 <etext+0x4d8>
    80002f58:	00003097          	auipc	ra,0x3
    80002f5c:	12a080e7          	jalr	298(ra) # 80006082 <panic>

0000000080002f60 <iunlock>:
void iunlock(struct inode *ip) {
    80002f60:	1101                	addi	sp,sp,-32
    80002f62:	ec06                	sd	ra,24(sp)
    80002f64:	e822                	sd	s0,16(sp)
    80002f66:	e426                	sd	s1,8(sp)
    80002f68:	e04a                	sd	s2,0(sp)
    80002f6a:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002f6c:	c905                	beqz	a0,80002f9c <iunlock+0x3c>
    80002f6e:	84aa                	mv	s1,a0
    80002f70:	01050913          	addi	s2,a0,16
    80002f74:	854a                	mv	a0,s2
    80002f76:	00001097          	auipc	ra,0x1
    80002f7a:	c82080e7          	jalr	-894(ra) # 80003bf8 <holdingsleep>
    80002f7e:	cd19                	beqz	a0,80002f9c <iunlock+0x3c>
    80002f80:	449c                	lw	a5,8(s1)
    80002f82:	00f05d63          	blez	a5,80002f9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f86:	854a                	mv	a0,s2
    80002f88:	00001097          	auipc	ra,0x1
    80002f8c:	c2c080e7          	jalr	-980(ra) # 80003bb4 <releasesleep>
}
    80002f90:	60e2                	ld	ra,24(sp)
    80002f92:	6442                	ld	s0,16(sp)
    80002f94:	64a2                	ld	s1,8(sp)
    80002f96:	6902                	ld	s2,0(sp)
    80002f98:	6105                	addi	sp,sp,32
    80002f9a:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002f9c:	00005517          	auipc	a0,0x5
    80002fa0:	54c50513          	addi	a0,a0,1356 # 800084e8 <etext+0x4e8>
    80002fa4:	00003097          	auipc	ra,0x3
    80002fa8:	0de080e7          	jalr	222(ra) # 80006082 <panic>

0000000080002fac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002fac:	7179                	addi	sp,sp,-48
    80002fae:	f406                	sd	ra,40(sp)
    80002fb0:	f022                	sd	s0,32(sp)
    80002fb2:	ec26                	sd	s1,24(sp)
    80002fb4:	e84a                	sd	s2,16(sp)
    80002fb6:	e44e                	sd	s3,8(sp)
    80002fb8:	1800                	addi	s0,sp,48
    80002fba:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002fbc:	05050493          	addi	s1,a0,80
    80002fc0:	08050913          	addi	s2,a0,128
    80002fc4:	a021                	j	80002fcc <itrunc+0x20>
    80002fc6:	0491                	addi	s1,s1,4
    80002fc8:	01248d63          	beq	s1,s2,80002fe2 <itrunc+0x36>
    if (ip->addrs[i]) {
    80002fcc:	408c                	lw	a1,0(s1)
    80002fce:	dde5                	beqz	a1,80002fc6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002fd0:	0009a503          	lw	a0,0(s3)
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	8d6080e7          	jalr	-1834(ra) # 800028aa <bfree>
      ip->addrs[i] = 0;
    80002fdc:	0004a023          	sw	zero,0(s1)
    80002fe0:	b7dd                	j	80002fc6 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002fe2:	0809a583          	lw	a1,128(s3)
    80002fe6:	ed99                	bnez	a1,80003004 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fe8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002fec:	854e                	mv	a0,s3
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	de0080e7          	jalr	-544(ra) # 80002dce <iupdate>
}
    80002ff6:	70a2                	ld	ra,40(sp)
    80002ff8:	7402                	ld	s0,32(sp)
    80002ffa:	64e2                	ld	s1,24(sp)
    80002ffc:	6942                	ld	s2,16(sp)
    80002ffe:	69a2                	ld	s3,8(sp)
    80003000:	6145                	addi	sp,sp,48
    80003002:	8082                	ret
    80003004:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003006:	0009a503          	lw	a0,0(s3)
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	65c080e7          	jalr	1628(ra) # 80002666 <bread>
    80003012:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003014:	05850493          	addi	s1,a0,88
    80003018:	45850913          	addi	s2,a0,1112
    8000301c:	a021                	j	80003024 <itrunc+0x78>
    8000301e:	0491                	addi	s1,s1,4
    80003020:	01248b63          	beq	s1,s2,80003036 <itrunc+0x8a>
      if (a[j]) bfree(ip->dev, a[j]);
    80003024:	408c                	lw	a1,0(s1)
    80003026:	dde5                	beqz	a1,8000301e <itrunc+0x72>
    80003028:	0009a503          	lw	a0,0(s3)
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	87e080e7          	jalr	-1922(ra) # 800028aa <bfree>
    80003034:	b7ed                	j	8000301e <itrunc+0x72>
    brelse(bp);
    80003036:	8552                	mv	a0,s4
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	75e080e7          	jalr	1886(ra) # 80002796 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003040:	0809a583          	lw	a1,128(s3)
    80003044:	0009a503          	lw	a0,0(s3)
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	862080e7          	jalr	-1950(ra) # 800028aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80003050:	0809a023          	sw	zero,128(s3)
    80003054:	6a02                	ld	s4,0(sp)
    80003056:	bf49                	j	80002fe8 <itrunc+0x3c>

0000000080003058 <iput>:
void iput(struct inode *ip) {
    80003058:	1101                	addi	sp,sp,-32
    8000305a:	ec06                	sd	ra,24(sp)
    8000305c:	e822                	sd	s0,16(sp)
    8000305e:	e426                	sd	s1,8(sp)
    80003060:	1000                	addi	s0,sp,32
    80003062:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003064:	00037517          	auipc	a0,0x37
    80003068:	88c50513          	addi	a0,a0,-1908 # 800398f0 <itable>
    8000306c:	00003097          	auipc	ra,0x3
    80003070:	590080e7          	jalr	1424(ra) # 800065fc <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003074:	4498                	lw	a4,8(s1)
    80003076:	4785                	li	a5,1
    80003078:	02f70263          	beq	a4,a5,8000309c <iput+0x44>
  ip->ref--;
    8000307c:	449c                	lw	a5,8(s1)
    8000307e:	37fd                	addiw	a5,a5,-1
    80003080:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003082:	00037517          	auipc	a0,0x37
    80003086:	86e50513          	addi	a0,a0,-1938 # 800398f0 <itable>
    8000308a:	00003097          	auipc	ra,0x3
    8000308e:	626080e7          	jalr	1574(ra) # 800066b0 <release>
}
    80003092:	60e2                	ld	ra,24(sp)
    80003094:	6442                	ld	s0,16(sp)
    80003096:	64a2                	ld	s1,8(sp)
    80003098:	6105                	addi	sp,sp,32
    8000309a:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000309c:	40bc                	lw	a5,64(s1)
    8000309e:	dff9                	beqz	a5,8000307c <iput+0x24>
    800030a0:	04a49783          	lh	a5,74(s1)
    800030a4:	ffe1                	bnez	a5,8000307c <iput+0x24>
    800030a6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800030a8:	01048913          	addi	s2,s1,16
    800030ac:	854a                	mv	a0,s2
    800030ae:	00001097          	auipc	ra,0x1
    800030b2:	ab0080e7          	jalr	-1360(ra) # 80003b5e <acquiresleep>
    release(&itable.lock);
    800030b6:	00037517          	auipc	a0,0x37
    800030ba:	83a50513          	addi	a0,a0,-1990 # 800398f0 <itable>
    800030be:	00003097          	auipc	ra,0x3
    800030c2:	5f2080e7          	jalr	1522(ra) # 800066b0 <release>
    itrunc(ip);
    800030c6:	8526                	mv	a0,s1
    800030c8:	00000097          	auipc	ra,0x0
    800030cc:	ee4080e7          	jalr	-284(ra) # 80002fac <itrunc>
    ip->type = 0;
    800030d0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800030d4:	8526                	mv	a0,s1
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	cf8080e7          	jalr	-776(ra) # 80002dce <iupdate>
    ip->valid = 0;
    800030de:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800030e2:	854a                	mv	a0,s2
    800030e4:	00001097          	auipc	ra,0x1
    800030e8:	ad0080e7          	jalr	-1328(ra) # 80003bb4 <releasesleep>
    acquire(&itable.lock);
    800030ec:	00037517          	auipc	a0,0x37
    800030f0:	80450513          	addi	a0,a0,-2044 # 800398f0 <itable>
    800030f4:	00003097          	auipc	ra,0x3
    800030f8:	508080e7          	jalr	1288(ra) # 800065fc <acquire>
    800030fc:	6902                	ld	s2,0(sp)
    800030fe:	bfbd                	j	8000307c <iput+0x24>

0000000080003100 <iunlockput>:
void iunlockput(struct inode *ip) {
    80003100:	1101                	addi	sp,sp,-32
    80003102:	ec06                	sd	ra,24(sp)
    80003104:	e822                	sd	s0,16(sp)
    80003106:	e426                	sd	s1,8(sp)
    80003108:	1000                	addi	s0,sp,32
    8000310a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	e54080e7          	jalr	-428(ra) # 80002f60 <iunlock>
  iput(ip);
    80003114:	8526                	mv	a0,s1
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	f42080e7          	jalr	-190(ra) # 80003058 <iput>
}
    8000311e:	60e2                	ld	ra,24(sp)
    80003120:	6442                	ld	s0,16(sp)
    80003122:	64a2                	ld	s1,8(sp)
    80003124:	6105                	addi	sp,sp,32
    80003126:	8082                	ret

0000000080003128 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80003128:	1141                	addi	sp,sp,-16
    8000312a:	e422                	sd	s0,8(sp)
    8000312c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000312e:	411c                	lw	a5,0(a0)
    80003130:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003132:	415c                	lw	a5,4(a0)
    80003134:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003136:	04451783          	lh	a5,68(a0)
    8000313a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000313e:	04a51783          	lh	a5,74(a0)
    80003142:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003146:	04c56783          	lwu	a5,76(a0)
    8000314a:	e99c                	sd	a5,16(a1)
}
    8000314c:	6422                	ld	s0,8(sp)
    8000314e:	0141                	addi	sp,sp,16
    80003150:	8082                	ret

0000000080003152 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80003152:	457c                	lw	a5,76(a0)
    80003154:	10d7e563          	bltu	a5,a3,8000325e <readi+0x10c>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80003158:	7159                	addi	sp,sp,-112
    8000315a:	f486                	sd	ra,104(sp)
    8000315c:	f0a2                	sd	s0,96(sp)
    8000315e:	eca6                	sd	s1,88(sp)
    80003160:	e0d2                	sd	s4,64(sp)
    80003162:	fc56                	sd	s5,56(sp)
    80003164:	f85a                	sd	s6,48(sp)
    80003166:	f45e                	sd	s7,40(sp)
    80003168:	1880                	addi	s0,sp,112
    8000316a:	8b2a                	mv	s6,a0
    8000316c:	8bae                	mv	s7,a1
    8000316e:	8a32                	mv	s4,a2
    80003170:	84b6                	mv	s1,a3
    80003172:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80003174:	9f35                	addw	a4,a4,a3
    80003176:	4501                	li	a0,0
    80003178:	0cd76a63          	bltu	a4,a3,8000324c <readi+0xfa>
    8000317c:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size) n = ip->size - off;
    8000317e:	00e7f463          	bgeu	a5,a4,80003186 <readi+0x34>
    80003182:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003186:	0a0a8963          	beqz	s5,80003238 <readi+0xe6>
    8000318a:	e8ca                	sd	s2,80(sp)
    8000318c:	f062                	sd	s8,32(sp)
    8000318e:	ec66                	sd	s9,24(sp)
    80003190:	e86a                	sd	s10,16(sp)
    80003192:	e46e                	sd	s11,8(sp)
    80003194:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003196:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000319a:	5c7d                	li	s8,-1
    8000319c:	a82d                	j	800031d6 <readi+0x84>
    8000319e:	020d1d93          	slli	s11,s10,0x20
    800031a2:	020ddd93          	srli	s11,s11,0x20
    800031a6:	05890613          	addi	a2,s2,88
    800031aa:	86ee                	mv	a3,s11
    800031ac:	963a                	add	a2,a2,a4
    800031ae:	85d2                	mv	a1,s4
    800031b0:	855e                	mv	a0,s7
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	9a6080e7          	jalr	-1626(ra) # 80001b58 <either_copyout>
    800031ba:	05850d63          	beq	a0,s8,80003214 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031be:	854a                	mv	a0,s2
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	5d6080e7          	jalr	1494(ra) # 80002796 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800031c8:	013d09bb          	addw	s3,s10,s3
    800031cc:	009d04bb          	addw	s1,s10,s1
    800031d0:	9a6e                	add	s4,s4,s11
    800031d2:	0559fd63          	bgeu	s3,s5,8000322c <readi+0xda>
    uint addr = bmap(ip, off / BSIZE);
    800031d6:	00a4d59b          	srliw	a1,s1,0xa
    800031da:	855a                	mv	a0,s6
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	88e080e7          	jalr	-1906(ra) # 80002a6a <bmap>
    800031e4:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    800031e8:	c9b1                	beqz	a1,8000323c <readi+0xea>
    bp = bread(ip->dev, addr);
    800031ea:	000b2503          	lw	a0,0(s6)
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	478080e7          	jalr	1144(ra) # 80002666 <bread>
    800031f6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800031f8:	3ff4f713          	andi	a4,s1,1023
    800031fc:	40ec87bb          	subw	a5,s9,a4
    80003200:	413a86bb          	subw	a3,s5,s3
    80003204:	8d3e                	mv	s10,a5
    80003206:	2781                	sext.w	a5,a5
    80003208:	0006861b          	sext.w	a2,a3
    8000320c:	f8f679e3          	bgeu	a2,a5,8000319e <readi+0x4c>
    80003210:	8d36                	mv	s10,a3
    80003212:	b771                	j	8000319e <readi+0x4c>
      brelse(bp);
    80003214:	854a                	mv	a0,s2
    80003216:	fffff097          	auipc	ra,0xfffff
    8000321a:	580080e7          	jalr	1408(ra) # 80002796 <brelse>
      tot = -1;
    8000321e:	59fd                	li	s3,-1
      break;
    80003220:	6946                	ld	s2,80(sp)
    80003222:	7c02                	ld	s8,32(sp)
    80003224:	6ce2                	ld	s9,24(sp)
    80003226:	6d42                	ld	s10,16(sp)
    80003228:	6da2                	ld	s11,8(sp)
    8000322a:	a831                	j	80003246 <readi+0xf4>
    8000322c:	6946                	ld	s2,80(sp)
    8000322e:	7c02                	ld	s8,32(sp)
    80003230:	6ce2                	ld	s9,24(sp)
    80003232:	6d42                	ld	s10,16(sp)
    80003234:	6da2                	ld	s11,8(sp)
    80003236:	a801                	j	80003246 <readi+0xf4>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003238:	89d6                	mv	s3,s5
    8000323a:	a031                	j	80003246 <readi+0xf4>
    8000323c:	6946                	ld	s2,80(sp)
    8000323e:	7c02                	ld	s8,32(sp)
    80003240:	6ce2                	ld	s9,24(sp)
    80003242:	6d42                	ld	s10,16(sp)
    80003244:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003246:	0009851b          	sext.w	a0,s3
    8000324a:	69a6                	ld	s3,72(sp)
}
    8000324c:	70a6                	ld	ra,104(sp)
    8000324e:	7406                	ld	s0,96(sp)
    80003250:	64e6                	ld	s1,88(sp)
    80003252:	6a06                	ld	s4,64(sp)
    80003254:	7ae2                	ld	s5,56(sp)
    80003256:	7b42                	ld	s6,48(sp)
    80003258:	7ba2                	ld	s7,40(sp)
    8000325a:	6165                	addi	sp,sp,112
    8000325c:	8082                	ret
  if (off > ip->size || off + n < off) return 0;
    8000325e:	4501                	li	a0,0
}
    80003260:	8082                	ret

0000000080003262 <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80003262:	457c                	lw	a5,76(a0)
    80003264:	10d7ee63          	bltu	a5,a3,80003380 <writei+0x11e>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80003268:	7159                	addi	sp,sp,-112
    8000326a:	f486                	sd	ra,104(sp)
    8000326c:	f0a2                	sd	s0,96(sp)
    8000326e:	e8ca                	sd	s2,80(sp)
    80003270:	e0d2                	sd	s4,64(sp)
    80003272:	fc56                	sd	s5,56(sp)
    80003274:	f85a                	sd	s6,48(sp)
    80003276:	f45e                	sd	s7,40(sp)
    80003278:	1880                	addi	s0,sp,112
    8000327a:	8aaa                	mv	s5,a0
    8000327c:	8bae                	mv	s7,a1
    8000327e:	8a32                	mv	s4,a2
    80003280:	8936                	mv	s2,a3
    80003282:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80003284:	00e687bb          	addw	a5,a3,a4
    80003288:	0ed7ee63          	bltu	a5,a3,80003384 <writei+0x122>
  if (off + n > MAXFILE * BSIZE) return -1;
    8000328c:	00043737          	lui	a4,0x43
    80003290:	0ef76c63          	bltu	a4,a5,80003388 <writei+0x126>
    80003294:	e4ce                	sd	s3,72(sp)

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003296:	0c0b0d63          	beqz	s6,80003370 <writei+0x10e>
    8000329a:	eca6                	sd	s1,88(sp)
    8000329c:	f062                	sd	s8,32(sp)
    8000329e:	ec66                	sd	s9,24(sp)
    800032a0:	e86a                	sd	s10,16(sp)
    800032a2:	e46e                	sd	s11,8(sp)
    800032a4:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800032a6:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800032aa:	5c7d                	li	s8,-1
    800032ac:	a091                	j	800032f0 <writei+0x8e>
    800032ae:	020d1d93          	slli	s11,s10,0x20
    800032b2:	020ddd93          	srli	s11,s11,0x20
    800032b6:	05848513          	addi	a0,s1,88
    800032ba:	86ee                	mv	a3,s11
    800032bc:	8652                	mv	a2,s4
    800032be:	85de                	mv	a1,s7
    800032c0:	953a                	add	a0,a0,a4
    800032c2:	fffff097          	auipc	ra,0xfffff
    800032c6:	8ec080e7          	jalr	-1812(ra) # 80001bae <either_copyin>
    800032ca:	07850263          	beq	a0,s8,8000332e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032ce:	8526                	mv	a0,s1
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	770080e7          	jalr	1904(ra) # 80003a40 <log_write>
    brelse(bp);
    800032d8:	8526                	mv	a0,s1
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	4bc080e7          	jalr	1212(ra) # 80002796 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800032e2:	013d09bb          	addw	s3,s10,s3
    800032e6:	012d093b          	addw	s2,s10,s2
    800032ea:	9a6e                	add	s4,s4,s11
    800032ec:	0569f663          	bgeu	s3,s6,80003338 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    800032f0:	00a9559b          	srliw	a1,s2,0xa
    800032f4:	8556                	mv	a0,s5
    800032f6:	fffff097          	auipc	ra,0xfffff
    800032fa:	774080e7          	jalr	1908(ra) # 80002a6a <bmap>
    800032fe:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003302:	c99d                	beqz	a1,80003338 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003304:	000aa503          	lw	a0,0(s5)
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	35e080e7          	jalr	862(ra) # 80002666 <bread>
    80003310:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003312:	3ff97713          	andi	a4,s2,1023
    80003316:	40ec87bb          	subw	a5,s9,a4
    8000331a:	413b06bb          	subw	a3,s6,s3
    8000331e:	8d3e                	mv	s10,a5
    80003320:	2781                	sext.w	a5,a5
    80003322:	0006861b          	sext.w	a2,a3
    80003326:	f8f674e3          	bgeu	a2,a5,800032ae <writei+0x4c>
    8000332a:	8d36                	mv	s10,a3
    8000332c:	b749                	j	800032ae <writei+0x4c>
      brelse(bp);
    8000332e:	8526                	mv	a0,s1
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	466080e7          	jalr	1126(ra) # 80002796 <brelse>
  }

  if (off > ip->size) ip->size = off;
    80003338:	04caa783          	lw	a5,76(s5)
    8000333c:	0327fc63          	bgeu	a5,s2,80003374 <writei+0x112>
    80003340:	052aa623          	sw	s2,76(s5)
    80003344:	64e6                	ld	s1,88(sp)
    80003346:	7c02                	ld	s8,32(sp)
    80003348:	6ce2                	ld	s9,24(sp)
    8000334a:	6d42                	ld	s10,16(sp)
    8000334c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000334e:	8556                	mv	a0,s5
    80003350:	00000097          	auipc	ra,0x0
    80003354:	a7e080e7          	jalr	-1410(ra) # 80002dce <iupdate>

  return tot;
    80003358:	0009851b          	sext.w	a0,s3
    8000335c:	69a6                	ld	s3,72(sp)
}
    8000335e:	70a6                	ld	ra,104(sp)
    80003360:	7406                	ld	s0,96(sp)
    80003362:	6946                	ld	s2,80(sp)
    80003364:	6a06                	ld	s4,64(sp)
    80003366:	7ae2                	ld	s5,56(sp)
    80003368:	7b42                	ld	s6,48(sp)
    8000336a:	7ba2                	ld	s7,40(sp)
    8000336c:	6165                	addi	sp,sp,112
    8000336e:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003370:	89da                	mv	s3,s6
    80003372:	bff1                	j	8000334e <writei+0xec>
    80003374:	64e6                	ld	s1,88(sp)
    80003376:	7c02                	ld	s8,32(sp)
    80003378:	6ce2                	ld	s9,24(sp)
    8000337a:	6d42                	ld	s10,16(sp)
    8000337c:	6da2                	ld	s11,8(sp)
    8000337e:	bfc1                	j	8000334e <writei+0xec>
  if (off > ip->size || off + n < off) return -1;
    80003380:	557d                	li	a0,-1
}
    80003382:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    80003384:	557d                	li	a0,-1
    80003386:	bfe1                	j	8000335e <writei+0xfc>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003388:	557d                	li	a0,-1
    8000338a:	bfd1                	j	8000335e <writei+0xfc>

000000008000338c <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    8000338c:	1141                	addi	sp,sp,-16
    8000338e:	e406                	sd	ra,8(sp)
    80003390:	e022                	sd	s0,0(sp)
    80003392:	0800                	addi	s0,sp,16
    80003394:	4639                	li	a2,14
    80003396:	ffffd097          	auipc	ra,0xffffd
    8000339a:	f58080e7          	jalr	-168(ra) # 800002ee <strncmp>
    8000339e:	60a2                	ld	ra,8(sp)
    800033a0:	6402                	ld	s0,0(sp)
    800033a2:	0141                	addi	sp,sp,16
    800033a4:	8082                	ret

00000000800033a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    800033a6:	7139                	addi	sp,sp,-64
    800033a8:	fc06                	sd	ra,56(sp)
    800033aa:	f822                	sd	s0,48(sp)
    800033ac:	f426                	sd	s1,40(sp)
    800033ae:	f04a                	sd	s2,32(sp)
    800033b0:	ec4e                	sd	s3,24(sp)
    800033b2:	e852                	sd	s4,16(sp)
    800033b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    800033b6:	04451703          	lh	a4,68(a0)
    800033ba:	4785                	li	a5,1
    800033bc:	00f71a63          	bne	a4,a5,800033d0 <dirlookup+0x2a>
    800033c0:	892a                	mv	s2,a0
    800033c2:	89ae                	mv	s3,a1
    800033c4:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800033c6:	457c                	lw	a5,76(a0)
    800033c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033ca:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800033cc:	e79d                	bnez	a5,800033fa <dirlookup+0x54>
    800033ce:	a8a5                	j	80003446 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    800033d0:	00005517          	auipc	a0,0x5
    800033d4:	12050513          	addi	a0,a0,288 # 800084f0 <etext+0x4f0>
    800033d8:	00003097          	auipc	ra,0x3
    800033dc:	caa080e7          	jalr	-854(ra) # 80006082 <panic>
      panic("dirlookup read");
    800033e0:	00005517          	auipc	a0,0x5
    800033e4:	12850513          	addi	a0,a0,296 # 80008508 <etext+0x508>
    800033e8:	00003097          	auipc	ra,0x3
    800033ec:	c9a080e7          	jalr	-870(ra) # 80006082 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800033f0:	24c1                	addiw	s1,s1,16
    800033f2:	04c92783          	lw	a5,76(s2)
    800033f6:	04f4f763          	bgeu	s1,a5,80003444 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033fa:	4741                	li	a4,16
    800033fc:	86a6                	mv	a3,s1
    800033fe:	fc040613          	addi	a2,s0,-64
    80003402:	4581                	li	a1,0
    80003404:	854a                	mv	a0,s2
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	d4c080e7          	jalr	-692(ra) # 80003152 <readi>
    8000340e:	47c1                	li	a5,16
    80003410:	fcf518e3          	bne	a0,a5,800033e0 <dirlookup+0x3a>
    if (de.inum == 0) continue;
    80003414:	fc045783          	lhu	a5,-64(s0)
    80003418:	dfe1                	beqz	a5,800033f0 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    8000341a:	fc240593          	addi	a1,s0,-62
    8000341e:	854e                	mv	a0,s3
    80003420:	00000097          	auipc	ra,0x0
    80003424:	f6c080e7          	jalr	-148(ra) # 8000338c <namecmp>
    80003428:	f561                	bnez	a0,800033f0 <dirlookup+0x4a>
      if (poff) *poff = off;
    8000342a:	000a0463          	beqz	s4,80003432 <dirlookup+0x8c>
    8000342e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003432:	fc045583          	lhu	a1,-64(s0)
    80003436:	00092503          	lw	a0,0(s2)
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	720080e7          	jalr	1824(ra) # 80002b5a <iget>
    80003442:	a011                	j	80003446 <dirlookup+0xa0>
  return 0;
    80003444:	4501                	li	a0,0
}
    80003446:	70e2                	ld	ra,56(sp)
    80003448:	7442                	ld	s0,48(sp)
    8000344a:	74a2                	ld	s1,40(sp)
    8000344c:	7902                	ld	s2,32(sp)
    8000344e:	69e2                	ld	s3,24(sp)
    80003450:	6a42                	ld	s4,16(sp)
    80003452:	6121                	addi	sp,sp,64
    80003454:	8082                	ret

0000000080003456 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    80003456:	711d                	addi	sp,sp,-96
    80003458:	ec86                	sd	ra,88(sp)
    8000345a:	e8a2                	sd	s0,80(sp)
    8000345c:	e4a6                	sd	s1,72(sp)
    8000345e:	e0ca                	sd	s2,64(sp)
    80003460:	fc4e                	sd	s3,56(sp)
    80003462:	f852                	sd	s4,48(sp)
    80003464:	f456                	sd	s5,40(sp)
    80003466:	f05a                	sd	s6,32(sp)
    80003468:	ec5e                	sd	s7,24(sp)
    8000346a:	e862                	sd	s8,16(sp)
    8000346c:	e466                	sd	s9,8(sp)
    8000346e:	1080                	addi	s0,sp,96
    80003470:	84aa                	mv	s1,a0
    80003472:	8b2e                	mv	s6,a1
    80003474:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003476:	00054703          	lbu	a4,0(a0)
    8000347a:	02f00793          	li	a5,47
    8000347e:	02f70263          	beq	a4,a5,800034a2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	c20080e7          	jalr	-992(ra) # 800010a2 <myproc>
    8000348a:	15053503          	ld	a0,336(a0)
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	9ce080e7          	jalr	-1586(ra) # 80002e5c <idup>
    80003496:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    80003498:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    8000349c:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    8000349e:	4b85                	li	s7,1
    800034a0:	a875                	j	8000355c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800034a2:	4585                	li	a1,1
    800034a4:	4505                	li	a0,1
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	6b4080e7          	jalr	1716(ra) # 80002b5a <iget>
    800034ae:	8a2a                	mv	s4,a0
    800034b0:	b7e5                	j	80003498 <namex+0x42>
      iunlockput(ip);
    800034b2:	8552                	mv	a0,s4
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	c4c080e7          	jalr	-948(ra) # 80003100 <iunlockput>
      return 0;
    800034bc:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800034be:	8552                	mv	a0,s4
    800034c0:	60e6                	ld	ra,88(sp)
    800034c2:	6446                	ld	s0,80(sp)
    800034c4:	64a6                	ld	s1,72(sp)
    800034c6:	6906                	ld	s2,64(sp)
    800034c8:	79e2                	ld	s3,56(sp)
    800034ca:	7a42                	ld	s4,48(sp)
    800034cc:	7aa2                	ld	s5,40(sp)
    800034ce:	7b02                	ld	s6,32(sp)
    800034d0:	6be2                	ld	s7,24(sp)
    800034d2:	6c42                	ld	s8,16(sp)
    800034d4:	6ca2                	ld	s9,8(sp)
    800034d6:	6125                	addi	sp,sp,96
    800034d8:	8082                	ret
      iunlock(ip);
    800034da:	8552                	mv	a0,s4
    800034dc:	00000097          	auipc	ra,0x0
    800034e0:	a84080e7          	jalr	-1404(ra) # 80002f60 <iunlock>
      return ip;
    800034e4:	bfe9                	j	800034be <namex+0x68>
      iunlockput(ip);
    800034e6:	8552                	mv	a0,s4
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	c18080e7          	jalr	-1000(ra) # 80003100 <iunlockput>
      return 0;
    800034f0:	8a4e                	mv	s4,s3
    800034f2:	b7f1                	j	800034be <namex+0x68>
  len = path - s;
    800034f4:	40998633          	sub	a2,s3,s1
    800034f8:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    800034fc:	099c5863          	bge	s8,s9,8000358c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003500:	4639                	li	a2,14
    80003502:	85a6                	mv	a1,s1
    80003504:	8556                	mv	a0,s5
    80003506:	ffffd097          	auipc	ra,0xffffd
    8000350a:	d74080e7          	jalr	-652(ra) # 8000027a <memmove>
    8000350e:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    80003510:	0004c783          	lbu	a5,0(s1)
    80003514:	01279763          	bne	a5,s2,80003522 <namex+0xcc>
    80003518:	0485                	addi	s1,s1,1
    8000351a:	0004c783          	lbu	a5,0(s1)
    8000351e:	ff278de3          	beq	a5,s2,80003518 <namex+0xc2>
    ilock(ip);
    80003522:	8552                	mv	a0,s4
    80003524:	00000097          	auipc	ra,0x0
    80003528:	976080e7          	jalr	-1674(ra) # 80002e9a <ilock>
    if (ip->type != T_DIR) {
    8000352c:	044a1783          	lh	a5,68(s4)
    80003530:	f97791e3          	bne	a5,s7,800034b2 <namex+0x5c>
    if (nameiparent && *path == '\0') {
    80003534:	000b0563          	beqz	s6,8000353e <namex+0xe8>
    80003538:	0004c783          	lbu	a5,0(s1)
    8000353c:	dfd9                	beqz	a5,800034da <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    8000353e:	4601                	li	a2,0
    80003540:	85d6                	mv	a1,s5
    80003542:	8552                	mv	a0,s4
    80003544:	00000097          	auipc	ra,0x0
    80003548:	e62080e7          	jalr	-414(ra) # 800033a6 <dirlookup>
    8000354c:	89aa                	mv	s3,a0
    8000354e:	dd41                	beqz	a0,800034e6 <namex+0x90>
    iunlockput(ip);
    80003550:	8552                	mv	a0,s4
    80003552:	00000097          	auipc	ra,0x0
    80003556:	bae080e7          	jalr	-1106(ra) # 80003100 <iunlockput>
    ip = next;
    8000355a:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    8000355c:	0004c783          	lbu	a5,0(s1)
    80003560:	01279763          	bne	a5,s2,8000356e <namex+0x118>
    80003564:	0485                	addi	s1,s1,1
    80003566:	0004c783          	lbu	a5,0(s1)
    8000356a:	ff278de3          	beq	a5,s2,80003564 <namex+0x10e>
  if (*path == 0) return 0;
    8000356e:	cb9d                	beqz	a5,800035a4 <namex+0x14e>
  while (*path != '/' && *path != 0) path++;
    80003570:	0004c783          	lbu	a5,0(s1)
    80003574:	89a6                	mv	s3,s1
  len = path - s;
    80003576:	4c81                	li	s9,0
    80003578:	4601                	li	a2,0
  while (*path != '/' && *path != 0) path++;
    8000357a:	01278963          	beq	a5,s2,8000358c <namex+0x136>
    8000357e:	dbbd                	beqz	a5,800034f4 <namex+0x9e>
    80003580:	0985                	addi	s3,s3,1
    80003582:	0009c783          	lbu	a5,0(s3)
    80003586:	ff279ce3          	bne	a5,s2,8000357e <namex+0x128>
    8000358a:	b7ad                	j	800034f4 <namex+0x9e>
    memmove(name, s, len);
    8000358c:	2601                	sext.w	a2,a2
    8000358e:	85a6                	mv	a1,s1
    80003590:	8556                	mv	a0,s5
    80003592:	ffffd097          	auipc	ra,0xffffd
    80003596:	ce8080e7          	jalr	-792(ra) # 8000027a <memmove>
    name[len] = 0;
    8000359a:	9cd6                	add	s9,s9,s5
    8000359c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800035a0:	84ce                	mv	s1,s3
    800035a2:	b7bd                	j	80003510 <namex+0xba>
  if (nameiparent) {
    800035a4:	f00b0de3          	beqz	s6,800034be <namex+0x68>
    iput(ip);
    800035a8:	8552                	mv	a0,s4
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	aae080e7          	jalr	-1362(ra) # 80003058 <iput>
    return 0;
    800035b2:	4a01                	li	s4,0
    800035b4:	b729                	j	800034be <namex+0x68>

00000000800035b6 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800035b6:	7139                	addi	sp,sp,-64
    800035b8:	fc06                	sd	ra,56(sp)
    800035ba:	f822                	sd	s0,48(sp)
    800035bc:	f04a                	sd	s2,32(sp)
    800035be:	ec4e                	sd	s3,24(sp)
    800035c0:	e852                	sd	s4,16(sp)
    800035c2:	0080                	addi	s0,sp,64
    800035c4:	892a                	mv	s2,a0
    800035c6:	8a2e                	mv	s4,a1
    800035c8:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800035ca:	4601                	li	a2,0
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	dda080e7          	jalr	-550(ra) # 800033a6 <dirlookup>
    800035d4:	ed25                	bnez	a0,8000364c <dirlink+0x96>
    800035d6:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800035d8:	04c92483          	lw	s1,76(s2)
    800035dc:	c49d                	beqz	s1,8000360a <dirlink+0x54>
    800035de:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035e0:	4741                	li	a4,16
    800035e2:	86a6                	mv	a3,s1
    800035e4:	fc040613          	addi	a2,s0,-64
    800035e8:	4581                	li	a1,0
    800035ea:	854a                	mv	a0,s2
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	b66080e7          	jalr	-1178(ra) # 80003152 <readi>
    800035f4:	47c1                	li	a5,16
    800035f6:	06f51163          	bne	a0,a5,80003658 <dirlink+0xa2>
    if (de.inum == 0) break;
    800035fa:	fc045783          	lhu	a5,-64(s0)
    800035fe:	c791                	beqz	a5,8000360a <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003600:	24c1                	addiw	s1,s1,16
    80003602:	04c92783          	lw	a5,76(s2)
    80003606:	fcf4ede3          	bltu	s1,a5,800035e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000360a:	4639                	li	a2,14
    8000360c:	85d2                	mv	a1,s4
    8000360e:	fc240513          	addi	a0,s0,-62
    80003612:	ffffd097          	auipc	ra,0xffffd
    80003616:	d12080e7          	jalr	-750(ra) # 80000324 <strncpy>
  de.inum = inum;
    8000361a:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    8000361e:	4741                	li	a4,16
    80003620:	86a6                	mv	a3,s1
    80003622:	fc040613          	addi	a2,s0,-64
    80003626:	4581                	li	a1,0
    80003628:	854a                	mv	a0,s2
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	c38080e7          	jalr	-968(ra) # 80003262 <writei>
    80003632:	1541                	addi	a0,a0,-16
    80003634:	00a03533          	snez	a0,a0
    80003638:	40a00533          	neg	a0,a0
    8000363c:	74a2                	ld	s1,40(sp)
}
    8000363e:	70e2                	ld	ra,56(sp)
    80003640:	7442                	ld	s0,48(sp)
    80003642:	7902                	ld	s2,32(sp)
    80003644:	69e2                	ld	s3,24(sp)
    80003646:	6a42                	ld	s4,16(sp)
    80003648:	6121                	addi	sp,sp,64
    8000364a:	8082                	ret
    iput(ip);
    8000364c:	00000097          	auipc	ra,0x0
    80003650:	a0c080e7          	jalr	-1524(ra) # 80003058 <iput>
    return -1;
    80003654:	557d                	li	a0,-1
    80003656:	b7e5                	j	8000363e <dirlink+0x88>
      panic("dirlink read");
    80003658:	00005517          	auipc	a0,0x5
    8000365c:	ec050513          	addi	a0,a0,-320 # 80008518 <etext+0x518>
    80003660:	00003097          	auipc	ra,0x3
    80003664:	a22080e7          	jalr	-1502(ra) # 80006082 <panic>

0000000080003668 <namei>:

struct inode *namei(char *path) {
    80003668:	1101                	addi	sp,sp,-32
    8000366a:	ec06                	sd	ra,24(sp)
    8000366c:	e822                	sd	s0,16(sp)
    8000366e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003670:	fe040613          	addi	a2,s0,-32
    80003674:	4581                	li	a1,0
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	de0080e7          	jalr	-544(ra) # 80003456 <namex>
}
    8000367e:	60e2                	ld	ra,24(sp)
    80003680:	6442                	ld	s0,16(sp)
    80003682:	6105                	addi	sp,sp,32
    80003684:	8082                	ret

0000000080003686 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80003686:	1141                	addi	sp,sp,-16
    80003688:	e406                	sd	ra,8(sp)
    8000368a:	e022                	sd	s0,0(sp)
    8000368c:	0800                	addi	s0,sp,16
    8000368e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003690:	4585                	li	a1,1
    80003692:	00000097          	auipc	ra,0x0
    80003696:	dc4080e7          	jalr	-572(ra) # 80003456 <namex>
}
    8000369a:	60a2                	ld	ra,8(sp)
    8000369c:	6402                	ld	s0,0(sp)
    8000369e:	0141                	addi	sp,sp,16
    800036a0:	8082                	ret

00000000800036a2 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    800036a2:	1101                	addi	sp,sp,-32
    800036a4:	ec06                	sd	ra,24(sp)
    800036a6:	e822                	sd	s0,16(sp)
    800036a8:	e426                	sd	s1,8(sp)
    800036aa:	e04a                	sd	s2,0(sp)
    800036ac:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800036ae:	00038917          	auipc	s2,0x38
    800036b2:	cea90913          	addi	s2,s2,-790 # 8003b398 <log>
    800036b6:	01892583          	lw	a1,24(s2)
    800036ba:	02892503          	lw	a0,40(s2)
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	fa8080e7          	jalr	-88(ra) # 80002666 <bread>
    800036c6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    800036c8:	02c92603          	lw	a2,44(s2)
    800036cc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800036ce:	00c05f63          	blez	a2,800036ec <write_head+0x4a>
    800036d2:	00038717          	auipc	a4,0x38
    800036d6:	cf670713          	addi	a4,a4,-778 # 8003b3c8 <log+0x30>
    800036da:	87aa                	mv	a5,a0
    800036dc:	060a                	slli	a2,a2,0x2
    800036de:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800036e0:	4314                	lw	a3,0(a4)
    800036e2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800036e4:	0711                	addi	a4,a4,4
    800036e6:	0791                	addi	a5,a5,4
    800036e8:	fec79ce3          	bne	a5,a2,800036e0 <write_head+0x3e>
  }
  bwrite(buf);
    800036ec:	8526                	mv	a0,s1
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	06a080e7          	jalr	106(ra) # 80002758 <bwrite>
  brelse(buf);
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	09e080e7          	jalr	158(ra) # 80002796 <brelse>
}
    80003700:	60e2                	ld	ra,24(sp)
    80003702:	6442                	ld	s0,16(sp)
    80003704:	64a2                	ld	s1,8(sp)
    80003706:	6902                	ld	s2,0(sp)
    80003708:	6105                	addi	sp,sp,32
    8000370a:	8082                	ret

000000008000370c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	00038797          	auipc	a5,0x38
    80003710:	cb87a783          	lw	a5,-840(a5) # 8003b3c4 <log+0x2c>
    80003714:	0af05d63          	blez	a5,800037ce <install_trans+0xc2>
static void install_trans(int recovering) {
    80003718:	7139                	addi	sp,sp,-64
    8000371a:	fc06                	sd	ra,56(sp)
    8000371c:	f822                	sd	s0,48(sp)
    8000371e:	f426                	sd	s1,40(sp)
    80003720:	f04a                	sd	s2,32(sp)
    80003722:	ec4e                	sd	s3,24(sp)
    80003724:	e852                	sd	s4,16(sp)
    80003726:	e456                	sd	s5,8(sp)
    80003728:	e05a                	sd	s6,0(sp)
    8000372a:	0080                	addi	s0,sp,64
    8000372c:	8b2a                	mv	s6,a0
    8000372e:	00038a97          	auipc	s5,0x38
    80003732:	c9aa8a93          	addi	s5,s5,-870 # 8003b3c8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003736:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003738:	00038997          	auipc	s3,0x38
    8000373c:	c6098993          	addi	s3,s3,-928 # 8003b398 <log>
    80003740:	a00d                	j	80003762 <install_trans+0x56>
    brelse(lbuf);
    80003742:	854a                	mv	a0,s2
    80003744:	fffff097          	auipc	ra,0xfffff
    80003748:	052080e7          	jalr	82(ra) # 80002796 <brelse>
    brelse(dbuf);
    8000374c:	8526                	mv	a0,s1
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	048080e7          	jalr	72(ra) # 80002796 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003756:	2a05                	addiw	s4,s4,1
    80003758:	0a91                	addi	s5,s5,4
    8000375a:	02c9a783          	lw	a5,44(s3)
    8000375e:	04fa5e63          	bge	s4,a5,800037ba <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003762:	0189a583          	lw	a1,24(s3)
    80003766:	014585bb          	addw	a1,a1,s4
    8000376a:	2585                	addiw	a1,a1,1
    8000376c:	0289a503          	lw	a0,40(s3)
    80003770:	fffff097          	auipc	ra,0xfffff
    80003774:	ef6080e7          	jalr	-266(ra) # 80002666 <bread>
    80003778:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    8000377a:	000aa583          	lw	a1,0(s5)
    8000377e:	0289a503          	lw	a0,40(s3)
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	ee4080e7          	jalr	-284(ra) # 80002666 <bread>
    8000378a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000378c:	40000613          	li	a2,1024
    80003790:	05890593          	addi	a1,s2,88
    80003794:	05850513          	addi	a0,a0,88
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	ae2080e7          	jalr	-1310(ra) # 8000027a <memmove>
    bwrite(dbuf);                            // write dst to disk
    800037a0:	8526                	mv	a0,s1
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	fb6080e7          	jalr	-74(ra) # 80002758 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    800037aa:	f80b1ce3          	bnez	s6,80003742 <install_trans+0x36>
    800037ae:	8526                	mv	a0,s1
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	0be080e7          	jalr	190(ra) # 8000286e <bunpin>
    800037b8:	b769                	j	80003742 <install_trans+0x36>
}
    800037ba:	70e2                	ld	ra,56(sp)
    800037bc:	7442                	ld	s0,48(sp)
    800037be:	74a2                	ld	s1,40(sp)
    800037c0:	7902                	ld	s2,32(sp)
    800037c2:	69e2                	ld	s3,24(sp)
    800037c4:	6a42                	ld	s4,16(sp)
    800037c6:	6aa2                	ld	s5,8(sp)
    800037c8:	6b02                	ld	s6,0(sp)
    800037ca:	6121                	addi	sp,sp,64
    800037cc:	8082                	ret
    800037ce:	8082                	ret

00000000800037d0 <initlog>:
void initlog(int dev, struct superblock *sb) {
    800037d0:	7179                	addi	sp,sp,-48
    800037d2:	f406                	sd	ra,40(sp)
    800037d4:	f022                	sd	s0,32(sp)
    800037d6:	ec26                	sd	s1,24(sp)
    800037d8:	e84a                	sd	s2,16(sp)
    800037da:	e44e                	sd	s3,8(sp)
    800037dc:	1800                	addi	s0,sp,48
    800037de:	892a                	mv	s2,a0
    800037e0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800037e2:	00038497          	auipc	s1,0x38
    800037e6:	bb648493          	addi	s1,s1,-1098 # 8003b398 <log>
    800037ea:	00005597          	auipc	a1,0x5
    800037ee:	d3e58593          	addi	a1,a1,-706 # 80008528 <etext+0x528>
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	d78080e7          	jalr	-648(ra) # 8000656c <initlock>
  log.start = sb->logstart;
    800037fc:	0149a583          	lw	a1,20(s3)
    80003800:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003802:	0109a783          	lw	a5,16(s3)
    80003806:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003808:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000380c:	854a                	mv	a0,s2
    8000380e:	fffff097          	auipc	ra,0xfffff
    80003812:	e58080e7          	jalr	-424(ra) # 80002666 <bread>
  log.lh.n = lh->n;
    80003816:	4d30                	lw	a2,88(a0)
    80003818:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000381a:	00c05f63          	blez	a2,80003838 <initlog+0x68>
    8000381e:	87aa                	mv	a5,a0
    80003820:	00038717          	auipc	a4,0x38
    80003824:	ba870713          	addi	a4,a4,-1112 # 8003b3c8 <log+0x30>
    80003828:	060a                	slli	a2,a2,0x2
    8000382a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000382c:	4ff4                	lw	a3,92(a5)
    8000382e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003830:	0791                	addi	a5,a5,4
    80003832:	0711                	addi	a4,a4,4
    80003834:	fec79ce3          	bne	a5,a2,8000382c <initlog+0x5c>
  brelse(buf);
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	f5e080e7          	jalr	-162(ra) # 80002796 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    80003840:	4505                	li	a0,1
    80003842:	00000097          	auipc	ra,0x0
    80003846:	eca080e7          	jalr	-310(ra) # 8000370c <install_trans>
  log.lh.n = 0;
    8000384a:	00038797          	auipc	a5,0x38
    8000384e:	b607ad23          	sw	zero,-1158(a5) # 8003b3c4 <log+0x2c>
  write_head();  // clear the log
    80003852:	00000097          	auipc	ra,0x0
    80003856:	e50080e7          	jalr	-432(ra) # 800036a2 <write_head>
}
    8000385a:	70a2                	ld	ra,40(sp)
    8000385c:	7402                	ld	s0,32(sp)
    8000385e:	64e2                	ld	s1,24(sp)
    80003860:	6942                	ld	s2,16(sp)
    80003862:	69a2                	ld	s3,8(sp)
    80003864:	6145                	addi	sp,sp,48
    80003866:	8082                	ret

0000000080003868 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	e04a                	sd	s2,0(sp)
    80003872:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003874:	00038517          	auipc	a0,0x38
    80003878:	b2450513          	addi	a0,a0,-1244 # 8003b398 <log>
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	d80080e7          	jalr	-640(ra) # 800065fc <acquire>
  while (1) {
    if (log.committing) {
    80003884:	00038497          	auipc	s1,0x38
    80003888:	b1448493          	addi	s1,s1,-1260 # 8003b398 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    8000388c:	4979                	li	s2,30
    8000388e:	a039                	j	8000389c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003890:	85a6                	mv	a1,s1
    80003892:	8526                	mv	a0,s1
    80003894:	ffffe097          	auipc	ra,0xffffe
    80003898:	ebc080e7          	jalr	-324(ra) # 80001750 <sleep>
    if (log.committing) {
    8000389c:	50dc                	lw	a5,36(s1)
    8000389e:	fbed                	bnez	a5,80003890 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    800038a0:	5098                	lw	a4,32(s1)
    800038a2:	2705                	addiw	a4,a4,1
    800038a4:	0027179b          	slliw	a5,a4,0x2
    800038a8:	9fb9                	addw	a5,a5,a4
    800038aa:	0017979b          	slliw	a5,a5,0x1
    800038ae:	54d4                	lw	a3,44(s1)
    800038b0:	9fb5                	addw	a5,a5,a3
    800038b2:	00f95963          	bge	s2,a5,800038c4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038b6:	85a6                	mv	a1,s1
    800038b8:	8526                	mv	a0,s1
    800038ba:	ffffe097          	auipc	ra,0xffffe
    800038be:	e96080e7          	jalr	-362(ra) # 80001750 <sleep>
    800038c2:	bfe9                	j	8000389c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800038c4:	00038517          	auipc	a0,0x38
    800038c8:	ad450513          	addi	a0,a0,-1324 # 8003b398 <log>
    800038cc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	de2080e7          	jalr	-542(ra) # 800066b0 <release>
      break;
    }
  }
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    800038e2:	7139                	addi	sp,sp,-64
    800038e4:	fc06                	sd	ra,56(sp)
    800038e6:	f822                	sd	s0,48(sp)
    800038e8:	f426                	sd	s1,40(sp)
    800038ea:	f04a                	sd	s2,32(sp)
    800038ec:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038ee:	00038497          	auipc	s1,0x38
    800038f2:	aaa48493          	addi	s1,s1,-1366 # 8003b398 <log>
    800038f6:	8526                	mv	a0,s1
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	d04080e7          	jalr	-764(ra) # 800065fc <acquire>
  log.outstanding -= 1;
    80003900:	509c                	lw	a5,32(s1)
    80003902:	37fd                	addiw	a5,a5,-1
    80003904:	0007891b          	sext.w	s2,a5
    80003908:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    8000390a:	50dc                	lw	a5,36(s1)
    8000390c:	e7b9                	bnez	a5,8000395a <end_op+0x78>
  if (log.outstanding == 0) {
    8000390e:	06091163          	bnez	s2,80003970 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003912:	00038497          	auipc	s1,0x38
    80003916:	a8648493          	addi	s1,s1,-1402 # 8003b398 <log>
    8000391a:	4785                	li	a5,1
    8000391c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000391e:	8526                	mv	a0,s1
    80003920:	00003097          	auipc	ra,0x3
    80003924:	d90080e7          	jalr	-624(ra) # 800066b0 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    80003928:	54dc                	lw	a5,44(s1)
    8000392a:	06f04763          	bgtz	a5,80003998 <end_op+0xb6>
    acquire(&log.lock);
    8000392e:	00038497          	auipc	s1,0x38
    80003932:	a6a48493          	addi	s1,s1,-1430 # 8003b398 <log>
    80003936:	8526                	mv	a0,s1
    80003938:	00003097          	auipc	ra,0x3
    8000393c:	cc4080e7          	jalr	-828(ra) # 800065fc <acquire>
    log.committing = 0;
    80003940:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003944:	8526                	mv	a0,s1
    80003946:	ffffe097          	auipc	ra,0xffffe
    8000394a:	e6e080e7          	jalr	-402(ra) # 800017b4 <wakeup>
    release(&log.lock);
    8000394e:	8526                	mv	a0,s1
    80003950:	00003097          	auipc	ra,0x3
    80003954:	d60080e7          	jalr	-672(ra) # 800066b0 <release>
}
    80003958:	a815                	j	8000398c <end_op+0xaa>
    8000395a:	ec4e                	sd	s3,24(sp)
    8000395c:	e852                	sd	s4,16(sp)
    8000395e:	e456                	sd	s5,8(sp)
  if (log.committing) panic("log.committing");
    80003960:	00005517          	auipc	a0,0x5
    80003964:	bd050513          	addi	a0,a0,-1072 # 80008530 <etext+0x530>
    80003968:	00002097          	auipc	ra,0x2
    8000396c:	71a080e7          	jalr	1818(ra) # 80006082 <panic>
    wakeup(&log);
    80003970:	00038497          	auipc	s1,0x38
    80003974:	a2848493          	addi	s1,s1,-1496 # 8003b398 <log>
    80003978:	8526                	mv	a0,s1
    8000397a:	ffffe097          	auipc	ra,0xffffe
    8000397e:	e3a080e7          	jalr	-454(ra) # 800017b4 <wakeup>
  release(&log.lock);
    80003982:	8526                	mv	a0,s1
    80003984:	00003097          	auipc	ra,0x3
    80003988:	d2c080e7          	jalr	-724(ra) # 800066b0 <release>
}
    8000398c:	70e2                	ld	ra,56(sp)
    8000398e:	7442                	ld	s0,48(sp)
    80003990:	74a2                	ld	s1,40(sp)
    80003992:	7902                	ld	s2,32(sp)
    80003994:	6121                	addi	sp,sp,64
    80003996:	8082                	ret
    80003998:	ec4e                	sd	s3,24(sp)
    8000399a:	e852                	sd	s4,16(sp)
    8000399c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000399e:	00038a97          	auipc	s5,0x38
    800039a2:	a2aa8a93          	addi	s5,s5,-1494 # 8003b3c8 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    800039a6:	00038a17          	auipc	s4,0x38
    800039aa:	9f2a0a13          	addi	s4,s4,-1550 # 8003b398 <log>
    800039ae:	018a2583          	lw	a1,24(s4)
    800039b2:	012585bb          	addw	a1,a1,s2
    800039b6:	2585                	addiw	a1,a1,1
    800039b8:	028a2503          	lw	a0,40(s4)
    800039bc:	fffff097          	auipc	ra,0xfffff
    800039c0:	caa080e7          	jalr	-854(ra) # 80002666 <bread>
    800039c4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    800039c6:	000aa583          	lw	a1,0(s5)
    800039ca:	028a2503          	lw	a0,40(s4)
    800039ce:	fffff097          	auipc	ra,0xfffff
    800039d2:	c98080e7          	jalr	-872(ra) # 80002666 <bread>
    800039d6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039d8:	40000613          	li	a2,1024
    800039dc:	05850593          	addi	a1,a0,88
    800039e0:	05848513          	addi	a0,s1,88
    800039e4:	ffffd097          	auipc	ra,0xffffd
    800039e8:	896080e7          	jalr	-1898(ra) # 8000027a <memmove>
    bwrite(to);  // write the log
    800039ec:	8526                	mv	a0,s1
    800039ee:	fffff097          	auipc	ra,0xfffff
    800039f2:	d6a080e7          	jalr	-662(ra) # 80002758 <bwrite>
    brelse(from);
    800039f6:	854e                	mv	a0,s3
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	d9e080e7          	jalr	-610(ra) # 80002796 <brelse>
    brelse(to);
    80003a00:	8526                	mv	a0,s1
    80003a02:	fffff097          	auipc	ra,0xfffff
    80003a06:	d94080e7          	jalr	-620(ra) # 80002796 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a0a:	2905                	addiw	s2,s2,1
    80003a0c:	0a91                	addi	s5,s5,4
    80003a0e:	02ca2783          	lw	a5,44(s4)
    80003a12:	f8f94ee3          	blt	s2,a5,800039ae <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    80003a16:	00000097          	auipc	ra,0x0
    80003a1a:	c8c080e7          	jalr	-884(ra) # 800036a2 <write_head>
    install_trans(0);  // Now install writes to home locations
    80003a1e:	4501                	li	a0,0
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	cec080e7          	jalr	-788(ra) # 8000370c <install_trans>
    log.lh.n = 0;
    80003a28:	00038797          	auipc	a5,0x38
    80003a2c:	9807ae23          	sw	zero,-1636(a5) # 8003b3c4 <log+0x2c>
    write_head();  // Erase the transaction from the log
    80003a30:	00000097          	auipc	ra,0x0
    80003a34:	c72080e7          	jalr	-910(ra) # 800036a2 <write_head>
    80003a38:	69e2                	ld	s3,24(sp)
    80003a3a:	6a42                	ld	s4,16(sp)
    80003a3c:	6aa2                	ld	s5,8(sp)
    80003a3e:	bdc5                	j	8000392e <end_op+0x4c>

0000000080003a40 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80003a40:	1101                	addi	sp,sp,-32
    80003a42:	ec06                	sd	ra,24(sp)
    80003a44:	e822                	sd	s0,16(sp)
    80003a46:	e426                	sd	s1,8(sp)
    80003a48:	e04a                	sd	s2,0(sp)
    80003a4a:	1000                	addi	s0,sp,32
    80003a4c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a4e:	00038917          	auipc	s2,0x38
    80003a52:	94a90913          	addi	s2,s2,-1718 # 8003b398 <log>
    80003a56:	854a                	mv	a0,s2
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	ba4080e7          	jalr	-1116(ra) # 800065fc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a60:	02c92603          	lw	a2,44(s2)
    80003a64:	47f5                	li	a5,29
    80003a66:	06c7c563          	blt	a5,a2,80003ad0 <log_write+0x90>
    80003a6a:	00038797          	auipc	a5,0x38
    80003a6e:	94a7a783          	lw	a5,-1718(a5) # 8003b3b4 <log+0x1c>
    80003a72:	37fd                	addiw	a5,a5,-1
    80003a74:	04f65e63          	bge	a2,a5,80003ad0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003a78:	00038797          	auipc	a5,0x38
    80003a7c:	9407a783          	lw	a5,-1728(a5) # 8003b3b8 <log+0x20>
    80003a80:	06f05063          	blez	a5,80003ae0 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003a84:	4781                	li	a5,0
    80003a86:	06c05563          	blez	a2,80003af0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a8a:	44cc                	lw	a1,12(s1)
    80003a8c:	00038717          	auipc	a4,0x38
    80003a90:	93c70713          	addi	a4,a4,-1732 # 8003b3c8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a94:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a96:	4314                	lw	a3,0(a4)
    80003a98:	04b68c63          	beq	a3,a1,80003af0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a9c:	2785                	addiw	a5,a5,1
    80003a9e:	0711                	addi	a4,a4,4
    80003aa0:	fef61be3          	bne	a2,a5,80003a96 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003aa4:	0621                	addi	a2,a2,8
    80003aa6:	060a                	slli	a2,a2,0x2
    80003aa8:	00038797          	auipc	a5,0x38
    80003aac:	8f078793          	addi	a5,a5,-1808 # 8003b398 <log>
    80003ab0:	97b2                	add	a5,a5,a2
    80003ab2:	44d8                	lw	a4,12(s1)
    80003ab4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	d7a080e7          	jalr	-646(ra) # 80002832 <bpin>
    log.lh.n++;
    80003ac0:	00038717          	auipc	a4,0x38
    80003ac4:	8d870713          	addi	a4,a4,-1832 # 8003b398 <log>
    80003ac8:	575c                	lw	a5,44(a4)
    80003aca:	2785                	addiw	a5,a5,1
    80003acc:	d75c                	sw	a5,44(a4)
    80003ace:	a82d                	j	80003b08 <log_write+0xc8>
    panic("too big a transaction");
    80003ad0:	00005517          	auipc	a0,0x5
    80003ad4:	a7050513          	addi	a0,a0,-1424 # 80008540 <etext+0x540>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	5aa080e7          	jalr	1450(ra) # 80006082 <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	a7850513          	addi	a0,a0,-1416 # 80008558 <etext+0x558>
    80003ae8:	00002097          	auipc	ra,0x2
    80003aec:	59a080e7          	jalr	1434(ra) # 80006082 <panic>
  log.lh.block[i] = b->blockno;
    80003af0:	00878693          	addi	a3,a5,8
    80003af4:	068a                	slli	a3,a3,0x2
    80003af6:	00038717          	auipc	a4,0x38
    80003afa:	8a270713          	addi	a4,a4,-1886 # 8003b398 <log>
    80003afe:	9736                	add	a4,a4,a3
    80003b00:	44d4                	lw	a3,12(s1)
    80003b02:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b04:	faf609e3          	beq	a2,a5,80003ab6 <log_write+0x76>
  }
  release(&log.lock);
    80003b08:	00038517          	auipc	a0,0x38
    80003b0c:	89050513          	addi	a0,a0,-1904 # 8003b398 <log>
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	ba0080e7          	jalr	-1120(ra) # 800066b0 <release>
}
    80003b18:	60e2                	ld	ra,24(sp)
    80003b1a:	6442                	ld	s0,16(sp)
    80003b1c:	64a2                	ld	s1,8(sp)
    80003b1e:	6902                	ld	s2,0(sp)
    80003b20:	6105                	addi	sp,sp,32
    80003b22:	8082                	ret

0000000080003b24 <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    80003b24:	1101                	addi	sp,sp,-32
    80003b26:	ec06                	sd	ra,24(sp)
    80003b28:	e822                	sd	s0,16(sp)
    80003b2a:	e426                	sd	s1,8(sp)
    80003b2c:	e04a                	sd	s2,0(sp)
    80003b2e:	1000                	addi	s0,sp,32
    80003b30:	84aa                	mv	s1,a0
    80003b32:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b34:	00005597          	auipc	a1,0x5
    80003b38:	a4458593          	addi	a1,a1,-1468 # 80008578 <etext+0x578>
    80003b3c:	0521                	addi	a0,a0,8
    80003b3e:	00003097          	auipc	ra,0x3
    80003b42:	a2e080e7          	jalr	-1490(ra) # 8000656c <initlock>
  lk->name = name;
    80003b46:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b4a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b4e:	0204a423          	sw	zero,40(s1)
}
    80003b52:	60e2                	ld	ra,24(sp)
    80003b54:	6442                	ld	s0,16(sp)
    80003b56:	64a2                	ld	s1,8(sp)
    80003b58:	6902                	ld	s2,0(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	e04a                	sd	s2,0(sp)
    80003b68:	1000                	addi	s0,sp,32
    80003b6a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b6c:	00850913          	addi	s2,a0,8
    80003b70:	854a                	mv	a0,s2
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	a8a080e7          	jalr	-1398(ra) # 800065fc <acquire>
  while (lk->locked) {
    80003b7a:	409c                	lw	a5,0(s1)
    80003b7c:	cb89                	beqz	a5,80003b8e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b7e:	85ca                	mv	a1,s2
    80003b80:	8526                	mv	a0,s1
    80003b82:	ffffe097          	auipc	ra,0xffffe
    80003b86:	bce080e7          	jalr	-1074(ra) # 80001750 <sleep>
  while (lk->locked) {
    80003b8a:	409c                	lw	a5,0(s1)
    80003b8c:	fbed                	bnez	a5,80003b7e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b8e:	4785                	li	a5,1
    80003b90:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	510080e7          	jalr	1296(ra) # 800010a2 <myproc>
    80003b9a:	591c                	lw	a5,48(a0)
    80003b9c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b9e:	854a                	mv	a0,s2
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	b10080e7          	jalr	-1264(ra) # 800066b0 <release>
}
    80003ba8:	60e2                	ld	ra,24(sp)
    80003baa:	6442                	ld	s0,16(sp)
    80003bac:	64a2                	ld	s1,8(sp)
    80003bae:	6902                	ld	s2,0(sp)
    80003bb0:	6105                	addi	sp,sp,32
    80003bb2:	8082                	ret

0000000080003bb4 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003bb4:	1101                	addi	sp,sp,-32
    80003bb6:	ec06                	sd	ra,24(sp)
    80003bb8:	e822                	sd	s0,16(sp)
    80003bba:	e426                	sd	s1,8(sp)
    80003bbc:	e04a                	sd	s2,0(sp)
    80003bbe:	1000                	addi	s0,sp,32
    80003bc0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bc2:	00850913          	addi	s2,a0,8
    80003bc6:	854a                	mv	a0,s2
    80003bc8:	00003097          	auipc	ra,0x3
    80003bcc:	a34080e7          	jalr	-1484(ra) # 800065fc <acquire>
  lk->locked = 0;
    80003bd0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bd4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003bd8:	8526                	mv	a0,s1
    80003bda:	ffffe097          	auipc	ra,0xffffe
    80003bde:	bda080e7          	jalr	-1062(ra) # 800017b4 <wakeup>
  release(&lk->lk);
    80003be2:	854a                	mv	a0,s2
    80003be4:	00003097          	auipc	ra,0x3
    80003be8:	acc080e7          	jalr	-1332(ra) # 800066b0 <release>
}
    80003bec:	60e2                	ld	ra,24(sp)
    80003bee:	6442                	ld	s0,16(sp)
    80003bf0:	64a2                	ld	s1,8(sp)
    80003bf2:	6902                	ld	s2,0(sp)
    80003bf4:	6105                	addi	sp,sp,32
    80003bf6:	8082                	ret

0000000080003bf8 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003bf8:	7179                	addi	sp,sp,-48
    80003bfa:	f406                	sd	ra,40(sp)
    80003bfc:	f022                	sd	s0,32(sp)
    80003bfe:	ec26                	sd	s1,24(sp)
    80003c00:	e84a                	sd	s2,16(sp)
    80003c02:	1800                	addi	s0,sp,48
    80003c04:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003c06:	00850913          	addi	s2,a0,8
    80003c0a:	854a                	mv	a0,s2
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	9f0080e7          	jalr	-1552(ra) # 800065fc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c14:	409c                	lw	a5,0(s1)
    80003c16:	ef91                	bnez	a5,80003c32 <holdingsleep+0x3a>
    80003c18:	4481                	li	s1,0
  release(&lk->lk);
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	a94080e7          	jalr	-1388(ra) # 800066b0 <release>
  return r;
}
    80003c24:	8526                	mv	a0,s1
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	6145                	addi	sp,sp,48
    80003c30:	8082                	ret
    80003c32:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c34:	0284a983          	lw	s3,40(s1)
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	46a080e7          	jalr	1130(ra) # 800010a2 <myproc>
    80003c40:	5904                	lw	s1,48(a0)
    80003c42:	413484b3          	sub	s1,s1,s3
    80003c46:	0014b493          	seqz	s1,s1
    80003c4a:	69a2                	ld	s3,8(sp)
    80003c4c:	b7f9                	j	80003c1a <holdingsleep+0x22>

0000000080003c4e <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003c4e:	1141                	addi	sp,sp,-16
    80003c50:	e406                	sd	ra,8(sp)
    80003c52:	e022                	sd	s0,0(sp)
    80003c54:	0800                	addi	s0,sp,16
    80003c56:	00005597          	auipc	a1,0x5
    80003c5a:	93258593          	addi	a1,a1,-1742 # 80008588 <etext+0x588>
    80003c5e:	00038517          	auipc	a0,0x38
    80003c62:	88250513          	addi	a0,a0,-1918 # 8003b4e0 <ftable>
    80003c66:	00003097          	auipc	ra,0x3
    80003c6a:	906080e7          	jalr	-1786(ra) # 8000656c <initlock>
    80003c6e:	60a2                	ld	ra,8(sp)
    80003c70:	6402                	ld	s0,0(sp)
    80003c72:	0141                	addi	sp,sp,16
    80003c74:	8082                	ret

0000000080003c76 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003c76:	1101                	addi	sp,sp,-32
    80003c78:	ec06                	sd	ra,24(sp)
    80003c7a:	e822                	sd	s0,16(sp)
    80003c7c:	e426                	sd	s1,8(sp)
    80003c7e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c80:	00038517          	auipc	a0,0x38
    80003c84:	86050513          	addi	a0,a0,-1952 # 8003b4e0 <ftable>
    80003c88:	00003097          	auipc	ra,0x3
    80003c8c:	974080e7          	jalr	-1676(ra) # 800065fc <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003c90:	00038497          	auipc	s1,0x38
    80003c94:	86848493          	addi	s1,s1,-1944 # 8003b4f8 <ftable+0x18>
    80003c98:	00039717          	auipc	a4,0x39
    80003c9c:	80070713          	addi	a4,a4,-2048 # 8003c498 <disk>
    if (f->ref == 0) {
    80003ca0:	40dc                	lw	a5,4(s1)
    80003ca2:	cf99                	beqz	a5,80003cc0 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003ca4:	02848493          	addi	s1,s1,40
    80003ca8:	fee49ce3          	bne	s1,a4,80003ca0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003cac:	00038517          	auipc	a0,0x38
    80003cb0:	83450513          	addi	a0,a0,-1996 # 8003b4e0 <ftable>
    80003cb4:	00003097          	auipc	ra,0x3
    80003cb8:	9fc080e7          	jalr	-1540(ra) # 800066b0 <release>
  return 0;
    80003cbc:	4481                	li	s1,0
    80003cbe:	a819                	j	80003cd4 <filealloc+0x5e>
      f->ref = 1;
    80003cc0:	4785                	li	a5,1
    80003cc2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003cc4:	00038517          	auipc	a0,0x38
    80003cc8:	81c50513          	addi	a0,a0,-2020 # 8003b4e0 <ftable>
    80003ccc:	00003097          	auipc	ra,0x3
    80003cd0:	9e4080e7          	jalr	-1564(ra) # 800066b0 <release>
}
    80003cd4:	8526                	mv	a0,s1
    80003cd6:	60e2                	ld	ra,24(sp)
    80003cd8:	6442                	ld	s0,16(sp)
    80003cda:	64a2                	ld	s1,8(sp)
    80003cdc:	6105                	addi	sp,sp,32
    80003cde:	8082                	ret

0000000080003ce0 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003ce0:	1101                	addi	sp,sp,-32
    80003ce2:	ec06                	sd	ra,24(sp)
    80003ce4:	e822                	sd	s0,16(sp)
    80003ce6:	e426                	sd	s1,8(sp)
    80003ce8:	1000                	addi	s0,sp,32
    80003cea:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cec:	00037517          	auipc	a0,0x37
    80003cf0:	7f450513          	addi	a0,a0,2036 # 8003b4e0 <ftable>
    80003cf4:	00003097          	auipc	ra,0x3
    80003cf8:	908080e7          	jalr	-1784(ra) # 800065fc <acquire>
  if (f->ref < 1) panic("filedup");
    80003cfc:	40dc                	lw	a5,4(s1)
    80003cfe:	02f05263          	blez	a5,80003d22 <filedup+0x42>
  f->ref++;
    80003d02:	2785                	addiw	a5,a5,1
    80003d04:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d06:	00037517          	auipc	a0,0x37
    80003d0a:	7da50513          	addi	a0,a0,2010 # 8003b4e0 <ftable>
    80003d0e:	00003097          	auipc	ra,0x3
    80003d12:	9a2080e7          	jalr	-1630(ra) # 800066b0 <release>
  return f;
}
    80003d16:	8526                	mv	a0,s1
    80003d18:	60e2                	ld	ra,24(sp)
    80003d1a:	6442                	ld	s0,16(sp)
    80003d1c:	64a2                	ld	s1,8(sp)
    80003d1e:	6105                	addi	sp,sp,32
    80003d20:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003d22:	00005517          	auipc	a0,0x5
    80003d26:	86e50513          	addi	a0,a0,-1938 # 80008590 <etext+0x590>
    80003d2a:	00002097          	auipc	ra,0x2
    80003d2e:	358080e7          	jalr	856(ra) # 80006082 <panic>

0000000080003d32 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003d32:	7139                	addi	sp,sp,-64
    80003d34:	fc06                	sd	ra,56(sp)
    80003d36:	f822                	sd	s0,48(sp)
    80003d38:	f426                	sd	s1,40(sp)
    80003d3a:	0080                	addi	s0,sp,64
    80003d3c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d3e:	00037517          	auipc	a0,0x37
    80003d42:	7a250513          	addi	a0,a0,1954 # 8003b4e0 <ftable>
    80003d46:	00003097          	auipc	ra,0x3
    80003d4a:	8b6080e7          	jalr	-1866(ra) # 800065fc <acquire>
  if (f->ref < 1) panic("fileclose");
    80003d4e:	40dc                	lw	a5,4(s1)
    80003d50:	04f05c63          	blez	a5,80003da8 <fileclose+0x76>
  if (--f->ref > 0) {
    80003d54:	37fd                	addiw	a5,a5,-1
    80003d56:	0007871b          	sext.w	a4,a5
    80003d5a:	c0dc                	sw	a5,4(s1)
    80003d5c:	06e04263          	bgtz	a4,80003dc0 <fileclose+0x8e>
    80003d60:	f04a                	sd	s2,32(sp)
    80003d62:	ec4e                	sd	s3,24(sp)
    80003d64:	e852                	sd	s4,16(sp)
    80003d66:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d68:	0004a903          	lw	s2,0(s1)
    80003d6c:	0094ca83          	lbu	s5,9(s1)
    80003d70:	0104ba03          	ld	s4,16(s1)
    80003d74:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d78:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d7c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d80:	00037517          	auipc	a0,0x37
    80003d84:	76050513          	addi	a0,a0,1888 # 8003b4e0 <ftable>
    80003d88:	00003097          	auipc	ra,0x3
    80003d8c:	928080e7          	jalr	-1752(ra) # 800066b0 <release>

  if (ff.type == FD_PIPE) {
    80003d90:	4785                	li	a5,1
    80003d92:	04f90463          	beq	s2,a5,80003dda <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003d96:	3979                	addiw	s2,s2,-2
    80003d98:	4785                	li	a5,1
    80003d9a:	0527fb63          	bgeu	a5,s2,80003df0 <fileclose+0xbe>
    80003d9e:	7902                	ld	s2,32(sp)
    80003da0:	69e2                	ld	s3,24(sp)
    80003da2:	6a42                	ld	s4,16(sp)
    80003da4:	6aa2                	ld	s5,8(sp)
    80003da6:	a02d                	j	80003dd0 <fileclose+0x9e>
    80003da8:	f04a                	sd	s2,32(sp)
    80003daa:	ec4e                	sd	s3,24(sp)
    80003dac:	e852                	sd	s4,16(sp)
    80003dae:	e456                	sd	s5,8(sp)
  if (f->ref < 1) panic("fileclose");
    80003db0:	00004517          	auipc	a0,0x4
    80003db4:	7e850513          	addi	a0,a0,2024 # 80008598 <etext+0x598>
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	2ca080e7          	jalr	714(ra) # 80006082 <panic>
    release(&ftable.lock);
    80003dc0:	00037517          	auipc	a0,0x37
    80003dc4:	72050513          	addi	a0,a0,1824 # 8003b4e0 <ftable>
    80003dc8:	00003097          	auipc	ra,0x3
    80003dcc:	8e8080e7          	jalr	-1816(ra) # 800066b0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003dd0:	70e2                	ld	ra,56(sp)
    80003dd2:	7442                	ld	s0,48(sp)
    80003dd4:	74a2                	ld	s1,40(sp)
    80003dd6:	6121                	addi	sp,sp,64
    80003dd8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003dda:	85d6                	mv	a1,s5
    80003ddc:	8552                	mv	a0,s4
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	3a2080e7          	jalr	930(ra) # 80004180 <pipeclose>
    80003de6:	7902                	ld	s2,32(sp)
    80003de8:	69e2                	ld	s3,24(sp)
    80003dea:	6a42                	ld	s4,16(sp)
    80003dec:	6aa2                	ld	s5,8(sp)
    80003dee:	b7cd                	j	80003dd0 <fileclose+0x9e>
    begin_op();
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	a78080e7          	jalr	-1416(ra) # 80003868 <begin_op>
    iput(ff.ip);
    80003df8:	854e                	mv	a0,s3
    80003dfa:	fffff097          	auipc	ra,0xfffff
    80003dfe:	25e080e7          	jalr	606(ra) # 80003058 <iput>
    end_op();
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	ae0080e7          	jalr	-1312(ra) # 800038e2 <end_op>
    80003e0a:	7902                	ld	s2,32(sp)
    80003e0c:	69e2                	ld	s3,24(sp)
    80003e0e:	6a42                	ld	s4,16(sp)
    80003e10:	6aa2                	ld	s5,8(sp)
    80003e12:	bf7d                	j	80003dd0 <fileclose+0x9e>

0000000080003e14 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003e14:	715d                	addi	sp,sp,-80
    80003e16:	e486                	sd	ra,72(sp)
    80003e18:	e0a2                	sd	s0,64(sp)
    80003e1a:	fc26                	sd	s1,56(sp)
    80003e1c:	f44e                	sd	s3,40(sp)
    80003e1e:	0880                	addi	s0,sp,80
    80003e20:	84aa                	mv	s1,a0
    80003e22:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e24:	ffffd097          	auipc	ra,0xffffd
    80003e28:	27e080e7          	jalr	638(ra) # 800010a2 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003e2c:	409c                	lw	a5,0(s1)
    80003e2e:	37f9                	addiw	a5,a5,-2
    80003e30:	4705                	li	a4,1
    80003e32:	04f76863          	bltu	a4,a5,80003e82 <filestat+0x6e>
    80003e36:	f84a                	sd	s2,48(sp)
    80003e38:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e3a:	6c88                	ld	a0,24(s1)
    80003e3c:	fffff097          	auipc	ra,0xfffff
    80003e40:	05e080e7          	jalr	94(ra) # 80002e9a <ilock>
    stati(f->ip, &st);
    80003e44:	fb840593          	addi	a1,s0,-72
    80003e48:	6c88                	ld	a0,24(s1)
    80003e4a:	fffff097          	auipc	ra,0xfffff
    80003e4e:	2de080e7          	jalr	734(ra) # 80003128 <stati>
    iunlock(f->ip);
    80003e52:	6c88                	ld	a0,24(s1)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	10c080e7          	jalr	268(ra) # 80002f60 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003e5c:	46e1                	li	a3,24
    80003e5e:	fb840613          	addi	a2,s0,-72
    80003e62:	85ce                	mv	a1,s3
    80003e64:	05093503          	ld	a0,80(s2)
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	d9a080e7          	jalr	-614(ra) # 80000c02 <copyout>
    80003e70:	41f5551b          	sraiw	a0,a0,0x1f
    80003e74:	7942                	ld	s2,48(sp)
    return 0;
  }
  return -1;
}
    80003e76:	60a6                	ld	ra,72(sp)
    80003e78:	6406                	ld	s0,64(sp)
    80003e7a:	74e2                	ld	s1,56(sp)
    80003e7c:	79a2                	ld	s3,40(sp)
    80003e7e:	6161                	addi	sp,sp,80
    80003e80:	8082                	ret
  return -1;
    80003e82:	557d                	li	a0,-1
    80003e84:	bfcd                	j	80003e76 <filestat+0x62>

0000000080003e86 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003e86:	7179                	addi	sp,sp,-48
    80003e88:	f406                	sd	ra,40(sp)
    80003e8a:	f022                	sd	s0,32(sp)
    80003e8c:	e84a                	sd	s2,16(sp)
    80003e8e:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003e90:	00854783          	lbu	a5,8(a0)
    80003e94:	cbc5                	beqz	a5,80003f44 <fileread+0xbe>
    80003e96:	ec26                	sd	s1,24(sp)
    80003e98:	e44e                	sd	s3,8(sp)
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	89ae                	mv	s3,a1
    80003e9e:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003ea0:	411c                	lw	a5,0(a0)
    80003ea2:	4705                	li	a4,1
    80003ea4:	04e78963          	beq	a5,a4,80003ef6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003ea8:	470d                	li	a4,3
    80003eaa:	04e78f63          	beq	a5,a4,80003f08 <fileread+0x82>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003eae:	4709                	li	a4,2
    80003eb0:	08e79263          	bne	a5,a4,80003f34 <fileread+0xae>
    ilock(f->ip);
    80003eb4:	6d08                	ld	a0,24(a0)
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	fe4080e7          	jalr	-28(ra) # 80002e9a <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003ebe:	874a                	mv	a4,s2
    80003ec0:	5094                	lw	a3,32(s1)
    80003ec2:	864e                	mv	a2,s3
    80003ec4:	4585                	li	a1,1
    80003ec6:	6c88                	ld	a0,24(s1)
    80003ec8:	fffff097          	auipc	ra,0xfffff
    80003ecc:	28a080e7          	jalr	650(ra) # 80003152 <readi>
    80003ed0:	892a                	mv	s2,a0
    80003ed2:	00a05563          	blez	a0,80003edc <fileread+0x56>
    80003ed6:	509c                	lw	a5,32(s1)
    80003ed8:	9fa9                	addw	a5,a5,a0
    80003eda:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003edc:	6c88                	ld	a0,24(s1)
    80003ede:	fffff097          	auipc	ra,0xfffff
    80003ee2:	082080e7          	jalr	130(ra) # 80002f60 <iunlock>
    80003ee6:	64e2                	ld	s1,24(sp)
    80003ee8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003eea:	854a                	mv	a0,s2
    80003eec:	70a2                	ld	ra,40(sp)
    80003eee:	7402                	ld	s0,32(sp)
    80003ef0:	6942                	ld	s2,16(sp)
    80003ef2:	6145                	addi	sp,sp,48
    80003ef4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ef6:	6908                	ld	a0,16(a0)
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	400080e7          	jalr	1024(ra) # 800042f8 <piperead>
    80003f00:	892a                	mv	s2,a0
    80003f02:	64e2                	ld	s1,24(sp)
    80003f04:	69a2                	ld	s3,8(sp)
    80003f06:	b7d5                	j	80003eea <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003f08:	02451783          	lh	a5,36(a0)
    80003f0c:	03079693          	slli	a3,a5,0x30
    80003f10:	92c1                	srli	a3,a3,0x30
    80003f12:	4725                	li	a4,9
    80003f14:	02d76a63          	bltu	a4,a3,80003f48 <fileread+0xc2>
    80003f18:	0792                	slli	a5,a5,0x4
    80003f1a:	00037717          	auipc	a4,0x37
    80003f1e:	52670713          	addi	a4,a4,1318 # 8003b440 <devsw>
    80003f22:	97ba                	add	a5,a5,a4
    80003f24:	639c                	ld	a5,0(a5)
    80003f26:	c78d                	beqz	a5,80003f50 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003f28:	4505                	li	a0,1
    80003f2a:	9782                	jalr	a5
    80003f2c:	892a                	mv	s2,a0
    80003f2e:	64e2                	ld	s1,24(sp)
    80003f30:	69a2                	ld	s3,8(sp)
    80003f32:	bf65                	j	80003eea <fileread+0x64>
    panic("fileread");
    80003f34:	00004517          	auipc	a0,0x4
    80003f38:	67450513          	addi	a0,a0,1652 # 800085a8 <etext+0x5a8>
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	146080e7          	jalr	326(ra) # 80006082 <panic>
  if (f->readable == 0) return -1;
    80003f44:	597d                	li	s2,-1
    80003f46:	b755                	j	80003eea <fileread+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003f48:	597d                	li	s2,-1
    80003f4a:	64e2                	ld	s1,24(sp)
    80003f4c:	69a2                	ld	s3,8(sp)
    80003f4e:	bf71                	j	80003eea <fileread+0x64>
    80003f50:	597d                	li	s2,-1
    80003f52:	64e2                	ld	s1,24(sp)
    80003f54:	69a2                	ld	s3,8(sp)
    80003f56:	bf51                	j	80003eea <fileread+0x64>

0000000080003f58 <filewrite>:
// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003f58:	00954783          	lbu	a5,9(a0)
    80003f5c:	12078963          	beqz	a5,8000408e <filewrite+0x136>
int filewrite(struct file *f, uint64 addr, int n) {
    80003f60:	715d                	addi	sp,sp,-80
    80003f62:	e486                	sd	ra,72(sp)
    80003f64:	e0a2                	sd	s0,64(sp)
    80003f66:	f84a                	sd	s2,48(sp)
    80003f68:	f052                	sd	s4,32(sp)
    80003f6a:	e85a                	sd	s6,16(sp)
    80003f6c:	0880                	addi	s0,sp,80
    80003f6e:	892a                	mv	s2,a0
    80003f70:	8b2e                	mv	s6,a1
    80003f72:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003f74:	411c                	lw	a5,0(a0)
    80003f76:	4705                	li	a4,1
    80003f78:	02e78763          	beq	a5,a4,80003fa6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003f7c:	470d                	li	a4,3
    80003f7e:	02e78a63          	beq	a5,a4,80003fb2 <filewrite+0x5a>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003f82:	4709                	li	a4,2
    80003f84:	0ee79863          	bne	a5,a4,80004074 <filewrite+0x11c>
    80003f88:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003f8a:	0cc05463          	blez	a2,80004052 <filewrite+0xfa>
    80003f8e:	fc26                	sd	s1,56(sp)
    80003f90:	ec56                	sd	s5,24(sp)
    80003f92:	e45e                	sd	s7,8(sp)
    80003f94:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f96:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max) n1 = max;
    80003f98:	6b85                	lui	s7,0x1
    80003f9a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f9e:	6c05                	lui	s8,0x1
    80003fa0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003fa4:	a851                	j	80004038 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003fa6:	6908                	ld	a0,16(a0)
    80003fa8:	00000097          	auipc	ra,0x0
    80003fac:	248080e7          	jalr	584(ra) # 800041f0 <pipewrite>
    80003fb0:	a85d                	j	80004066 <filewrite+0x10e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003fb2:	02451783          	lh	a5,36(a0)
    80003fb6:	03079693          	slli	a3,a5,0x30
    80003fba:	92c1                	srli	a3,a3,0x30
    80003fbc:	4725                	li	a4,9
    80003fbe:	0cd76a63          	bltu	a4,a3,80004092 <filewrite+0x13a>
    80003fc2:	0792                	slli	a5,a5,0x4
    80003fc4:	00037717          	auipc	a4,0x37
    80003fc8:	47c70713          	addi	a4,a4,1148 # 8003b440 <devsw>
    80003fcc:	97ba                	add	a5,a5,a4
    80003fce:	679c                	ld	a5,8(a5)
    80003fd0:	c3f9                	beqz	a5,80004096 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003fd2:	4505                	li	a0,1
    80003fd4:	9782                	jalr	a5
    80003fd6:	a841                	j	80004066 <filewrite+0x10e>
      if (n1 > max) n1 = max;
    80003fd8:	00048a9b          	sext.w	s5,s1

      begin_op();
    80003fdc:	00000097          	auipc	ra,0x0
    80003fe0:	88c080e7          	jalr	-1908(ra) # 80003868 <begin_op>
      ilock(f->ip);
    80003fe4:	01893503          	ld	a0,24(s2)
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	eb2080e7          	jalr	-334(ra) # 80002e9a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003ff0:	8756                	mv	a4,s5
    80003ff2:	02092683          	lw	a3,32(s2)
    80003ff6:	01698633          	add	a2,s3,s6
    80003ffa:	4585                	li	a1,1
    80003ffc:	01893503          	ld	a0,24(s2)
    80004000:	fffff097          	auipc	ra,0xfffff
    80004004:	262080e7          	jalr	610(ra) # 80003262 <writei>
    80004008:	84aa                	mv	s1,a0
    8000400a:	00a05763          	blez	a0,80004018 <filewrite+0xc0>
    8000400e:	02092783          	lw	a5,32(s2)
    80004012:	9fa9                	addw	a5,a5,a0
    80004014:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004018:	01893503          	ld	a0,24(s2)
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	f44080e7          	jalr	-188(ra) # 80002f60 <iunlock>
      end_op();
    80004024:	00000097          	auipc	ra,0x0
    80004028:	8be080e7          	jalr	-1858(ra) # 800038e2 <end_op>

      if (r != n1) {
    8000402c:	029a9563          	bne	s5,s1,80004056 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004030:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80004034:	0149da63          	bge	s3,s4,80004048 <filewrite+0xf0>
      int n1 = n - i;
    80004038:	413a04bb          	subw	s1,s4,s3
      if (n1 > max) n1 = max;
    8000403c:	0004879b          	sext.w	a5,s1
    80004040:	f8fbdce3          	bge	s7,a5,80003fd8 <filewrite+0x80>
    80004044:	84e2                	mv	s1,s8
    80004046:	bf49                	j	80003fd8 <filewrite+0x80>
    80004048:	74e2                	ld	s1,56(sp)
    8000404a:	6ae2                	ld	s5,24(sp)
    8000404c:	6ba2                	ld	s7,8(sp)
    8000404e:	6c02                	ld	s8,0(sp)
    80004050:	a039                	j	8000405e <filewrite+0x106>
    int i = 0;
    80004052:	4981                	li	s3,0
    80004054:	a029                	j	8000405e <filewrite+0x106>
    80004056:	74e2                	ld	s1,56(sp)
    80004058:	6ae2                	ld	s5,24(sp)
    8000405a:	6ba2                	ld	s7,8(sp)
    8000405c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000405e:	033a1e63          	bne	s4,s3,8000409a <filewrite+0x142>
    80004062:	8552                	mv	a0,s4
    80004064:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004066:	60a6                	ld	ra,72(sp)
    80004068:	6406                	ld	s0,64(sp)
    8000406a:	7942                	ld	s2,48(sp)
    8000406c:	7a02                	ld	s4,32(sp)
    8000406e:	6b42                	ld	s6,16(sp)
    80004070:	6161                	addi	sp,sp,80
    80004072:	8082                	ret
    80004074:	fc26                	sd	s1,56(sp)
    80004076:	f44e                	sd	s3,40(sp)
    80004078:	ec56                	sd	s5,24(sp)
    8000407a:	e45e                	sd	s7,8(sp)
    8000407c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000407e:	00004517          	auipc	a0,0x4
    80004082:	53a50513          	addi	a0,a0,1338 # 800085b8 <etext+0x5b8>
    80004086:	00002097          	auipc	ra,0x2
    8000408a:	ffc080e7          	jalr	-4(ra) # 80006082 <panic>
  if (f->writable == 0) return -1;
    8000408e:	557d                	li	a0,-1
}
    80004090:	8082                	ret
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80004092:	557d                	li	a0,-1
    80004094:	bfc9                	j	80004066 <filewrite+0x10e>
    80004096:	557d                	li	a0,-1
    80004098:	b7f9                	j	80004066 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    8000409a:	557d                	li	a0,-1
    8000409c:	79a2                	ld	s3,40(sp)
    8000409e:	b7e1                	j	80004066 <filewrite+0x10e>

00000000800040a0 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    800040a0:	7179                	addi	sp,sp,-48
    800040a2:	f406                	sd	ra,40(sp)
    800040a4:	f022                	sd	s0,32(sp)
    800040a6:	ec26                	sd	s1,24(sp)
    800040a8:	e052                	sd	s4,0(sp)
    800040aa:	1800                	addi	s0,sp,48
    800040ac:	84aa                	mv	s1,a0
    800040ae:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800040b0:	0005b023          	sd	zero,0(a1)
    800040b4:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    800040b8:	00000097          	auipc	ra,0x0
    800040bc:	bbe080e7          	jalr	-1090(ra) # 80003c76 <filealloc>
    800040c0:	e088                	sd	a0,0(s1)
    800040c2:	cd49                	beqz	a0,8000415c <pipealloc+0xbc>
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	bb2080e7          	jalr	-1102(ra) # 80003c76 <filealloc>
    800040cc:	00aa3023          	sd	a0,0(s4)
    800040d0:	c141                	beqz	a0,80004150 <pipealloc+0xb0>
    800040d2:	e84a                	sd	s2,16(sp)
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    800040d4:	ffffc097          	auipc	ra,0xffffc
    800040d8:	0d0080e7          	jalr	208(ra) # 800001a4 <kalloc>
    800040dc:	892a                	mv	s2,a0
    800040de:	c13d                	beqz	a0,80004144 <pipealloc+0xa4>
    800040e0:	e44e                	sd	s3,8(sp)
  pi->readopen = 1;
    800040e2:	4985                	li	s3,1
    800040e4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800040e8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040ec:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040f0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040f4:	00004597          	auipc	a1,0x4
    800040f8:	4d458593          	addi	a1,a1,1236 # 800085c8 <etext+0x5c8>
    800040fc:	00002097          	auipc	ra,0x2
    80004100:	470080e7          	jalr	1136(ra) # 8000656c <initlock>
  (*f0)->type = FD_PIPE;
    80004104:	609c                	ld	a5,0(s1)
    80004106:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000410a:	609c                	ld	a5,0(s1)
    8000410c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004110:	609c                	ld	a5,0(s1)
    80004112:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004116:	609c                	ld	a5,0(s1)
    80004118:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000411c:	000a3783          	ld	a5,0(s4)
    80004120:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004124:	000a3783          	ld	a5,0(s4)
    80004128:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000412c:	000a3783          	ld	a5,0(s4)
    80004130:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004134:	000a3783          	ld	a5,0(s4)
    80004138:	0127b823          	sd	s2,16(a5)
  return 0;
    8000413c:	4501                	li	a0,0
    8000413e:	6942                	ld	s2,16(sp)
    80004140:	69a2                	ld	s3,8(sp)
    80004142:	a03d                	j	80004170 <pipealloc+0xd0>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80004144:	6088                	ld	a0,0(s1)
    80004146:	c119                	beqz	a0,8000414c <pipealloc+0xac>
    80004148:	6942                	ld	s2,16(sp)
    8000414a:	a029                	j	80004154 <pipealloc+0xb4>
    8000414c:	6942                	ld	s2,16(sp)
    8000414e:	a039                	j	8000415c <pipealloc+0xbc>
    80004150:	6088                	ld	a0,0(s1)
    80004152:	c50d                	beqz	a0,8000417c <pipealloc+0xdc>
    80004154:	00000097          	auipc	ra,0x0
    80004158:	bde080e7          	jalr	-1058(ra) # 80003d32 <fileclose>
  if (*f1) fileclose(*f1);
    8000415c:	000a3783          	ld	a5,0(s4)
  return -1;
    80004160:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80004162:	c799                	beqz	a5,80004170 <pipealloc+0xd0>
    80004164:	853e                	mv	a0,a5
    80004166:	00000097          	auipc	ra,0x0
    8000416a:	bcc080e7          	jalr	-1076(ra) # 80003d32 <fileclose>
  return -1;
    8000416e:	557d                	li	a0,-1
}
    80004170:	70a2                	ld	ra,40(sp)
    80004172:	7402                	ld	s0,32(sp)
    80004174:	64e2                	ld	s1,24(sp)
    80004176:	6a02                	ld	s4,0(sp)
    80004178:	6145                	addi	sp,sp,48
    8000417a:	8082                	ret
  return -1;
    8000417c:	557d                	li	a0,-1
    8000417e:	bfcd                	j	80004170 <pipealloc+0xd0>

0000000080004180 <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80004180:	1101                	addi	sp,sp,-32
    80004182:	ec06                	sd	ra,24(sp)
    80004184:	e822                	sd	s0,16(sp)
    80004186:	e426                	sd	s1,8(sp)
    80004188:	e04a                	sd	s2,0(sp)
    8000418a:	1000                	addi	s0,sp,32
    8000418c:	84aa                	mv	s1,a0
    8000418e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004190:	00002097          	auipc	ra,0x2
    80004194:	46c080e7          	jalr	1132(ra) # 800065fc <acquire>
  if (writable) {
    80004198:	02090d63          	beqz	s2,800041d2 <pipeclose+0x52>
    pi->writeopen = 0;
    8000419c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800041a0:	21848513          	addi	a0,s1,536
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	610080e7          	jalr	1552(ra) # 800017b4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800041ac:	2204b783          	ld	a5,544(s1)
    800041b0:	eb95                	bnez	a5,800041e4 <pipeclose+0x64>
    release(&pi->lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	00002097          	auipc	ra,0x2
    800041b8:	4fc080e7          	jalr	1276(ra) # 800066b0 <release>
    kfree((char *)pi);
    800041bc:	8526                	mv	a0,s1
    800041be:	ffffc097          	auipc	ra,0xffffc
    800041c2:	eb0080e7          	jalr	-336(ra) # 8000006e <kfree>
  } else
    release(&pi->lock);
}
    800041c6:	60e2                	ld	ra,24(sp)
    800041c8:	6442                	ld	s0,16(sp)
    800041ca:	64a2                	ld	s1,8(sp)
    800041cc:	6902                	ld	s2,0(sp)
    800041ce:	6105                	addi	sp,sp,32
    800041d0:	8082                	ret
    pi->readopen = 0;
    800041d2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800041d6:	21c48513          	addi	a0,s1,540
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	5da080e7          	jalr	1498(ra) # 800017b4 <wakeup>
    800041e2:	b7e9                	j	800041ac <pipeclose+0x2c>
    release(&pi->lock);
    800041e4:	8526                	mv	a0,s1
    800041e6:	00002097          	auipc	ra,0x2
    800041ea:	4ca080e7          	jalr	1226(ra) # 800066b0 <release>
}
    800041ee:	bfe1                	j	800041c6 <pipeclose+0x46>

00000000800041f0 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    800041f0:	711d                	addi	sp,sp,-96
    800041f2:	ec86                	sd	ra,88(sp)
    800041f4:	e8a2                	sd	s0,80(sp)
    800041f6:	e4a6                	sd	s1,72(sp)
    800041f8:	e0ca                	sd	s2,64(sp)
    800041fa:	fc4e                	sd	s3,56(sp)
    800041fc:	f852                	sd	s4,48(sp)
    800041fe:	f456                	sd	s5,40(sp)
    80004200:	1080                	addi	s0,sp,96
    80004202:	84aa                	mv	s1,a0
    80004204:	8aae                	mv	s5,a1
    80004206:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004208:	ffffd097          	auipc	ra,0xffffd
    8000420c:	e9a080e7          	jalr	-358(ra) # 800010a2 <myproc>
    80004210:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004212:	8526                	mv	a0,s1
    80004214:	00002097          	auipc	ra,0x2
    80004218:	3e8080e7          	jalr	1000(ra) # 800065fc <acquire>
  while (i < n) {
    8000421c:	0d405863          	blez	s4,800042ec <pipewrite+0xfc>
    80004220:	f05a                	sd	s6,32(sp)
    80004222:	ec5e                	sd	s7,24(sp)
    80004224:	e862                	sd	s8,16(sp)
  int i = 0;
    80004226:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80004228:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000422a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000422e:	21c48b93          	addi	s7,s1,540
    80004232:	a089                	j	80004274 <pipewrite+0x84>
      release(&pi->lock);
    80004234:	8526                	mv	a0,s1
    80004236:	00002097          	auipc	ra,0x2
    8000423a:	47a080e7          	jalr	1146(ra) # 800066b0 <release>
      return -1;
    8000423e:	597d                	li	s2,-1
    80004240:	7b02                	ld	s6,32(sp)
    80004242:	6be2                	ld	s7,24(sp)
    80004244:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004246:	854a                	mv	a0,s2
    80004248:	60e6                	ld	ra,88(sp)
    8000424a:	6446                	ld	s0,80(sp)
    8000424c:	64a6                	ld	s1,72(sp)
    8000424e:	6906                	ld	s2,64(sp)
    80004250:	79e2                	ld	s3,56(sp)
    80004252:	7a42                	ld	s4,48(sp)
    80004254:	7aa2                	ld	s5,40(sp)
    80004256:	6125                	addi	sp,sp,96
    80004258:	8082                	ret
      wakeup(&pi->nread);
    8000425a:	8562                	mv	a0,s8
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	558080e7          	jalr	1368(ra) # 800017b4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004264:	85a6                	mv	a1,s1
    80004266:	855e                	mv	a0,s7
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	4e8080e7          	jalr	1256(ra) # 80001750 <sleep>
  while (i < n) {
    80004270:	05495f63          	bge	s2,s4,800042ce <pipewrite+0xde>
    if (pi->readopen == 0 || killed(pr)) {
    80004274:	2204a783          	lw	a5,544(s1)
    80004278:	dfd5                	beqz	a5,80004234 <pipewrite+0x44>
    8000427a:	854e                	mv	a0,s3
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	77c080e7          	jalr	1916(ra) # 800019f8 <killed>
    80004284:	f945                	bnez	a0,80004234 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80004286:	2184a783          	lw	a5,536(s1)
    8000428a:	21c4a703          	lw	a4,540(s1)
    8000428e:	2007879b          	addiw	a5,a5,512
    80004292:	fcf704e3          	beq	a4,a5,8000425a <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80004296:	4685                	li	a3,1
    80004298:	01590633          	add	a2,s2,s5
    8000429c:	faf40593          	addi	a1,s0,-81
    800042a0:	0509b503          	ld	a0,80(s3)
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	a42080e7          	jalr	-1470(ra) # 80000ce6 <copyin>
    800042ac:	05650263          	beq	a0,s6,800042f0 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800042b0:	21c4a783          	lw	a5,540(s1)
    800042b4:	0017871b          	addiw	a4,a5,1
    800042b8:	20e4ae23          	sw	a4,540(s1)
    800042bc:	1ff7f793          	andi	a5,a5,511
    800042c0:	97a6                	add	a5,a5,s1
    800042c2:	faf44703          	lbu	a4,-81(s0)
    800042c6:	00e78c23          	sb	a4,24(a5)
      i++;
    800042ca:	2905                	addiw	s2,s2,1
    800042cc:	b755                	j	80004270 <pipewrite+0x80>
    800042ce:	7b02                	ld	s6,32(sp)
    800042d0:	6be2                	ld	s7,24(sp)
    800042d2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800042d4:	21848513          	addi	a0,s1,536
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	4dc080e7          	jalr	1244(ra) # 800017b4 <wakeup>
  release(&pi->lock);
    800042e0:	8526                	mv	a0,s1
    800042e2:	00002097          	auipc	ra,0x2
    800042e6:	3ce080e7          	jalr	974(ra) # 800066b0 <release>
  return i;
    800042ea:	bfb1                	j	80004246 <pipewrite+0x56>
  int i = 0;
    800042ec:	4901                	li	s2,0
    800042ee:	b7dd                	j	800042d4 <pipewrite+0xe4>
    800042f0:	7b02                	ld	s6,32(sp)
    800042f2:	6be2                	ld	s7,24(sp)
    800042f4:	6c42                	ld	s8,16(sp)
    800042f6:	bff9                	j	800042d4 <pipewrite+0xe4>

00000000800042f8 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    800042f8:	715d                	addi	sp,sp,-80
    800042fa:	e486                	sd	ra,72(sp)
    800042fc:	e0a2                	sd	s0,64(sp)
    800042fe:	fc26                	sd	s1,56(sp)
    80004300:	f84a                	sd	s2,48(sp)
    80004302:	f44e                	sd	s3,40(sp)
    80004304:	f052                	sd	s4,32(sp)
    80004306:	ec56                	sd	s5,24(sp)
    80004308:	0880                	addi	s0,sp,80
    8000430a:	84aa                	mv	s1,a0
    8000430c:	892e                	mv	s2,a1
    8000430e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004310:	ffffd097          	auipc	ra,0xffffd
    80004314:	d92080e7          	jalr	-622(ra) # 800010a2 <myproc>
    80004318:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000431a:	8526                	mv	a0,s1
    8000431c:	00002097          	auipc	ra,0x2
    80004320:	2e0080e7          	jalr	736(ra) # 800065fc <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004324:	2184a703          	lw	a4,536(s1)
    80004328:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    8000432c:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004330:	02f71963          	bne	a4,a5,80004362 <piperead+0x6a>
    80004334:	2244a783          	lw	a5,548(s1)
    80004338:	cf95                	beqz	a5,80004374 <piperead+0x7c>
    if (killed(pr)) {
    8000433a:	8552                	mv	a0,s4
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	6bc080e7          	jalr	1724(ra) # 800019f8 <killed>
    80004344:	e10d                	bnez	a0,80004366 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004346:	85a6                	mv	a1,s1
    80004348:	854e                	mv	a0,s3
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	406080e7          	jalr	1030(ra) # 80001750 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004352:	2184a703          	lw	a4,536(s1)
    80004356:	21c4a783          	lw	a5,540(s1)
    8000435a:	fcf70de3          	beq	a4,a5,80004334 <piperead+0x3c>
    8000435e:	e85a                	sd	s6,16(sp)
    80004360:	a819                	j	80004376 <piperead+0x7e>
    80004362:	e85a                	sd	s6,16(sp)
    80004364:	a809                	j	80004376 <piperead+0x7e>
      release(&pi->lock);
    80004366:	8526                	mv	a0,s1
    80004368:	00002097          	auipc	ra,0x2
    8000436c:	348080e7          	jalr	840(ra) # 800066b0 <release>
      return -1;
    80004370:	59fd                	li	s3,-1
    80004372:	a0a5                	j	800043da <piperead+0xe2>
    80004374:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004376:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004378:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    8000437a:	05505463          	blez	s5,800043c2 <piperead+0xca>
    if (pi->nread == pi->nwrite) break;
    8000437e:	2184a783          	lw	a5,536(s1)
    80004382:	21c4a703          	lw	a4,540(s1)
    80004386:	02f70e63          	beq	a4,a5,800043c2 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000438a:	0017871b          	addiw	a4,a5,1
    8000438e:	20e4ac23          	sw	a4,536(s1)
    80004392:	1ff7f793          	andi	a5,a5,511
    80004396:	97a6                	add	a5,a5,s1
    80004398:	0187c783          	lbu	a5,24(a5)
    8000439c:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800043a0:	4685                	li	a3,1
    800043a2:	fbf40613          	addi	a2,s0,-65
    800043a6:	85ca                	mv	a1,s2
    800043a8:	050a3503          	ld	a0,80(s4)
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	856080e7          	jalr	-1962(ra) # 80000c02 <copyout>
    800043b4:	01650763          	beq	a0,s6,800043c2 <piperead+0xca>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800043b8:	2985                	addiw	s3,s3,1
    800043ba:	0905                	addi	s2,s2,1
    800043bc:	fd3a91e3          	bne	s5,s3,8000437e <piperead+0x86>
    800043c0:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    800043c2:	21c48513          	addi	a0,s1,540
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	3ee080e7          	jalr	1006(ra) # 800017b4 <wakeup>
  release(&pi->lock);
    800043ce:	8526                	mv	a0,s1
    800043d0:	00002097          	auipc	ra,0x2
    800043d4:	2e0080e7          	jalr	736(ra) # 800066b0 <release>
    800043d8:	6b42                	ld	s6,16(sp)
  return i;
}
    800043da:	854e                	mv	a0,s3
    800043dc:	60a6                	ld	ra,72(sp)
    800043de:	6406                	ld	s0,64(sp)
    800043e0:	74e2                	ld	s1,56(sp)
    800043e2:	7942                	ld	s2,48(sp)
    800043e4:	79a2                	ld	s3,40(sp)
    800043e6:	7a02                	ld	s4,32(sp)
    800043e8:	6ae2                	ld	s5,24(sp)
    800043ea:	6161                	addi	sp,sp,80
    800043ec:	8082                	ret

00000000800043ee <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    800043ee:	1141                	addi	sp,sp,-16
    800043f0:	e422                	sd	s0,8(sp)
    800043f2:	0800                	addi	s0,sp,16
    800043f4:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    800043f6:	8905                	andi	a0,a0,1
    800043f8:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    800043fa:	8b89                	andi	a5,a5,2
    800043fc:	c399                	beqz	a5,80004402 <flags2perm+0x14>
    800043fe:	00456513          	ori	a0,a0,4
  return perm;
}
    80004402:	6422                	ld	s0,8(sp)
    80004404:	0141                	addi	sp,sp,16
    80004406:	8082                	ret

0000000080004408 <exec>:

int exec(char *path, char **argv) {
    80004408:	df010113          	addi	sp,sp,-528
    8000440c:	20113423          	sd	ra,520(sp)
    80004410:	20813023          	sd	s0,512(sp)
    80004414:	ffa6                	sd	s1,504(sp)
    80004416:	fbca                	sd	s2,496(sp)
    80004418:	0c00                	addi	s0,sp,528
    8000441a:	892a                	mv	s2,a0
    8000441c:	dea43c23          	sd	a0,-520(s0)
    80004420:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004424:	ffffd097          	auipc	ra,0xffffd
    80004428:	c7e080e7          	jalr	-898(ra) # 800010a2 <myproc>
    8000442c:	84aa                	mv	s1,a0

  begin_op();
    8000442e:	fffff097          	auipc	ra,0xfffff
    80004432:	43a080e7          	jalr	1082(ra) # 80003868 <begin_op>

  if ((ip = namei(path)) == 0) {
    80004436:	854a                	mv	a0,s2
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	230080e7          	jalr	560(ra) # 80003668 <namei>
    80004440:	c135                	beqz	a0,800044a4 <exec+0x9c>
    80004442:	f3d2                	sd	s4,480(sp)
    80004444:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	a54080e7          	jalr	-1452(ra) # 80002e9a <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    8000444e:	04000713          	li	a4,64
    80004452:	4681                	li	a3,0
    80004454:	e5040613          	addi	a2,s0,-432
    80004458:	4581                	li	a1,0
    8000445a:	8552                	mv	a0,s4
    8000445c:	fffff097          	auipc	ra,0xfffff
    80004460:	cf6080e7          	jalr	-778(ra) # 80003152 <readi>
    80004464:	04000793          	li	a5,64
    80004468:	00f51a63          	bne	a0,a5,8000447c <exec+0x74>

  if (elf.magic != ELF_MAGIC) goto bad;
    8000446c:	e5042703          	lw	a4,-432(s0)
    80004470:	464c47b7          	lui	a5,0x464c4
    80004474:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004478:	02f70c63          	beq	a4,a5,800044b0 <exec+0xa8>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000447c:	8552                	mv	a0,s4
    8000447e:	fffff097          	auipc	ra,0xfffff
    80004482:	c82080e7          	jalr	-894(ra) # 80003100 <iunlockput>
    end_op();
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	45c080e7          	jalr	1116(ra) # 800038e2 <end_op>
  }
  return -1;
    8000448e:	557d                	li	a0,-1
    80004490:	7a1e                	ld	s4,480(sp)
}
    80004492:	20813083          	ld	ra,520(sp)
    80004496:	20013403          	ld	s0,512(sp)
    8000449a:	74fe                	ld	s1,504(sp)
    8000449c:	795e                	ld	s2,496(sp)
    8000449e:	21010113          	addi	sp,sp,528
    800044a2:	8082                	ret
    end_op();
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	43e080e7          	jalr	1086(ra) # 800038e2 <end_op>
    return -1;
    800044ac:	557d                	li	a0,-1
    800044ae:	b7d5                	j	80004492 <exec+0x8a>
    800044b0:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    800044b2:	8526                	mv	a0,s1
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	cb6080e7          	jalr	-842(ra) # 8000116a <proc_pagetable>
    800044bc:	8b2a                	mv	s6,a0
    800044be:	32050a63          	beqz	a0,800047f2 <exec+0x3ea>
    800044c2:	f7ce                	sd	s3,488(sp)
    800044c4:	efd6                	sd	s5,472(sp)
    800044c6:	e7de                	sd	s7,456(sp)
    800044c8:	e3e2                	sd	s8,448(sp)
    800044ca:	ff66                	sd	s9,440(sp)
    800044cc:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800044ce:	e7042d03          	lw	s10,-400(s0)
    800044d2:	e8845783          	lhu	a5,-376(s0)
    800044d6:	14078d63          	beqz	a5,80004630 <exec+0x228>
    800044da:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044dc:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800044de:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800044e0:	6c85                	lui	s9,0x1
    800044e2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800044e6:	def43823          	sd	a5,-528(s0)
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800044ea:	6a85                	lui	s5,0x1
    800044ec:	a0b5                	j	80004558 <exec+0x150>
    if (pa == 0) panic("loadseg: address should exist");
    800044ee:	00004517          	auipc	a0,0x4
    800044f2:	0e250513          	addi	a0,a0,226 # 800085d0 <etext+0x5d0>
    800044f6:	00002097          	auipc	ra,0x2
    800044fa:	b8c080e7          	jalr	-1140(ra) # 80006082 <panic>
    if (sz - i < PGSIZE)
    800044fe:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    80004500:	8726                	mv	a4,s1
    80004502:	012c06bb          	addw	a3,s8,s2
    80004506:	4581                	li	a1,0
    80004508:	8552                	mv	a0,s4
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	c48080e7          	jalr	-952(ra) # 80003152 <readi>
    80004512:	2501                	sext.w	a0,a0
    80004514:	2aa49363          	bne	s1,a0,800047ba <exec+0x3b2>
  for (i = 0; i < sz; i += PGSIZE) {
    80004518:	012a893b          	addw	s2,s5,s2
    8000451c:	03397563          	bgeu	s2,s3,80004546 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004520:	02091593          	slli	a1,s2,0x20
    80004524:	9181                	srli	a1,a1,0x20
    80004526:	95de                	add	a1,a1,s7
    80004528:	855a                	mv	a0,s6
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	076080e7          	jalr	118(ra) # 800005a0 <walkaddr>
    80004532:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    80004534:	dd4d                	beqz	a0,800044ee <exec+0xe6>
    if (sz - i < PGSIZE)
    80004536:	412984bb          	subw	s1,s3,s2
    8000453a:	0004879b          	sext.w	a5,s1
    8000453e:	fcfcf0e3          	bgeu	s9,a5,800044fe <exec+0xf6>
    80004542:	84d6                	mv	s1,s5
    80004544:	bf6d                	j	800044fe <exec+0xf6>
    sz = sz1;
    80004546:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000454a:	2d85                	addiw	s11,s11,1
    8000454c:	038d0d1b          	addiw	s10,s10,56
    80004550:	e8845783          	lhu	a5,-376(s0)
    80004554:	08fdd663          	bge	s11,a5,800045e0 <exec+0x1d8>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    80004558:	2d01                	sext.w	s10,s10
    8000455a:	03800713          	li	a4,56
    8000455e:	86ea                	mv	a3,s10
    80004560:	e1840613          	addi	a2,s0,-488
    80004564:	4581                	li	a1,0
    80004566:	8552                	mv	a0,s4
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	bea080e7          	jalr	-1046(ra) # 80003152 <readi>
    80004570:	03800793          	li	a5,56
    80004574:	20f51b63          	bne	a0,a5,8000478a <exec+0x382>
    if (ph.type != ELF_PROG_LOAD) continue;
    80004578:	e1842783          	lw	a5,-488(s0)
    8000457c:	4705                	li	a4,1
    8000457e:	fce796e3          	bne	a5,a4,8000454a <exec+0x142>
    if (ph.memsz < ph.filesz) goto bad;
    80004582:	e4043483          	ld	s1,-448(s0)
    80004586:	e3843783          	ld	a5,-456(s0)
    8000458a:	20f4e463          	bltu	s1,a5,80004792 <exec+0x38a>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    8000458e:	e2843783          	ld	a5,-472(s0)
    80004592:	94be                	add	s1,s1,a5
    80004594:	20f4e363          	bltu	s1,a5,8000479a <exec+0x392>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004598:	df043703          	ld	a4,-528(s0)
    8000459c:	8ff9                	and	a5,a5,a4
    8000459e:	20079263          	bnez	a5,800047a2 <exec+0x39a>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800045a2:	e1c42503          	lw	a0,-484(s0)
    800045a6:	00000097          	auipc	ra,0x0
    800045aa:	e48080e7          	jalr	-440(ra) # 800043ee <flags2perm>
    800045ae:	86aa                	mv	a3,a0
    800045b0:	8626                	mv	a2,s1
    800045b2:	85ca                	mv	a1,s2
    800045b4:	855a                	mv	a0,s6
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	3d2080e7          	jalr	978(ra) # 80000988 <uvmalloc>
    800045be:	e0a43423          	sd	a0,-504(s0)
    800045c2:	1e050463          	beqz	a0,800047aa <exec+0x3a2>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    800045c6:	e2843b83          	ld	s7,-472(s0)
    800045ca:	e2042c03          	lw	s8,-480(s0)
    800045ce:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800045d2:	00098463          	beqz	s3,800045da <exec+0x1d2>
    800045d6:	4901                	li	s2,0
    800045d8:	b7a1                	j	80004520 <exec+0x118>
    sz = sz1;
    800045da:	e0843903          	ld	s2,-504(s0)
    800045de:	b7b5                	j	8000454a <exec+0x142>
    800045e0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800045e2:	8552                	mv	a0,s4
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	b1c080e7          	jalr	-1252(ra) # 80003100 <iunlockput>
  end_op();
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	2f6080e7          	jalr	758(ra) # 800038e2 <end_op>
  p = myproc();
    800045f4:	ffffd097          	auipc	ra,0xffffd
    800045f8:	aae080e7          	jalr	-1362(ra) # 800010a2 <myproc>
    800045fc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800045fe:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004602:	6985                	lui	s3,0x1
    80004604:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004606:	99ca                	add	s3,s3,s2
    80004608:	77fd                	lui	a5,0xfffff
    8000460a:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    8000460e:	4691                	li	a3,4
    80004610:	6609                	lui	a2,0x2
    80004612:	964e                	add	a2,a2,s3
    80004614:	85ce                	mv	a1,s3
    80004616:	855a                	mv	a0,s6
    80004618:	ffffc097          	auipc	ra,0xffffc
    8000461c:	370080e7          	jalr	880(ra) # 80000988 <uvmalloc>
    80004620:	892a                	mv	s2,a0
    80004622:	e0a43423          	sd	a0,-504(s0)
    80004626:	e519                	bnez	a0,80004634 <exec+0x22c>
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004628:	e1343423          	sd	s3,-504(s0)
    8000462c:	4a01                	li	s4,0
    8000462e:	a279                	j	800047bc <exec+0x3b4>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004630:	4901                	li	s2,0
    80004632:	bf45                	j	800045e2 <exec+0x1da>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80004634:	75f9                	lui	a1,0xffffe
    80004636:	95aa                	add	a1,a1,a0
    80004638:	855a                	mv	a0,s6
    8000463a:	ffffc097          	auipc	ra,0xffffc
    8000463e:	596080e7          	jalr	1430(ra) # 80000bd0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004642:	7bfd                	lui	s7,0xfffff
    80004644:	9bca                	add	s7,s7,s2
  for (argc = 0; argv[argc]; argc++) {
    80004646:	e0043783          	ld	a5,-512(s0)
    8000464a:	6388                	ld	a0,0(a5)
    8000464c:	c52d                	beqz	a0,800046b6 <exec+0x2ae>
    8000464e:	e9040993          	addi	s3,s0,-368
    80004652:	f9040c13          	addi	s8,s0,-112
    80004656:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004658:	ffffc097          	auipc	ra,0xffffc
    8000465c:	d3a080e7          	jalr	-710(ra) # 80000392 <strlen>
    80004660:	0015079b          	addiw	a5,a0,1
    80004664:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80004668:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    8000466c:	15796363          	bltu	s2,s7,800047b2 <exec+0x3aa>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004670:	e0043d03          	ld	s10,-512(s0)
    80004674:	000d3a03          	ld	s4,0(s10)
    80004678:	8552                	mv	a0,s4
    8000467a:	ffffc097          	auipc	ra,0xffffc
    8000467e:	d18080e7          	jalr	-744(ra) # 80000392 <strlen>
    80004682:	0015069b          	addiw	a3,a0,1
    80004686:	8652                	mv	a2,s4
    80004688:	85ca                	mv	a1,s2
    8000468a:	855a                	mv	a0,s6
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	576080e7          	jalr	1398(ra) # 80000c02 <copyout>
    80004694:	12054163          	bltz	a0,800047b6 <exec+0x3ae>
    ustack[argc] = sp;
    80004698:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000469c:	0485                	addi	s1,s1,1
    8000469e:	008d0793          	addi	a5,s10,8
    800046a2:	e0f43023          	sd	a5,-512(s0)
    800046a6:	008d3503          	ld	a0,8(s10)
    800046aa:	c909                	beqz	a0,800046bc <exec+0x2b4>
    if (argc >= MAXARG) goto bad;
    800046ac:	09a1                	addi	s3,s3,8
    800046ae:	fb8995e3          	bne	s3,s8,80004658 <exec+0x250>
  ip = 0;
    800046b2:	4a01                	li	s4,0
    800046b4:	a221                	j	800047bc <exec+0x3b4>
  sp = sz;
    800046b6:	e0843903          	ld	s2,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    800046ba:	4481                	li	s1,0
  ustack[argc] = 0;
    800046bc:	00349793          	slli	a5,s1,0x3
    800046c0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffba770>
    800046c4:	97a2                	add	a5,a5,s0
    800046c6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800046ca:	00148693          	addi	a3,s1,1
    800046ce:	068e                	slli	a3,a3,0x3
    800046d0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800046d4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800046d8:	e0843983          	ld	s3,-504(s0)
  if (sp < stackbase) goto bad;
    800046dc:	f57966e3          	bltu	s2,s7,80004628 <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800046e0:	e9040613          	addi	a2,s0,-368
    800046e4:	85ca                	mv	a1,s2
    800046e6:	855a                	mv	a0,s6
    800046e8:	ffffc097          	auipc	ra,0xffffc
    800046ec:	51a080e7          	jalr	1306(ra) # 80000c02 <copyout>
    800046f0:	10054363          	bltz	a0,800047f6 <exec+0x3ee>
  p->trapframe->a1 = sp;
    800046f4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800046f8:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800046fc:	df843783          	ld	a5,-520(s0)
    80004700:	0007c703          	lbu	a4,0(a5)
    80004704:	cf11                	beqz	a4,80004720 <exec+0x318>
    80004706:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    80004708:	02f00693          	li	a3,47
    8000470c:	a039                	j	8000471a <exec+0x312>
    8000470e:	def43c23          	sd	a5,-520(s0)
  for (last = s = path; *s; s++)
    80004712:	0785                	addi	a5,a5,1
    80004714:	fff7c703          	lbu	a4,-1(a5)
    80004718:	c701                	beqz	a4,80004720 <exec+0x318>
    if (*s == '/') last = s + 1;
    8000471a:	fed71ce3          	bne	a4,a3,80004712 <exec+0x30a>
    8000471e:	bfc5                	j	8000470e <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004720:	4641                	li	a2,16
    80004722:	df843583          	ld	a1,-520(s0)
    80004726:	158a8513          	addi	a0,s5,344
    8000472a:	ffffc097          	auipc	ra,0xffffc
    8000472e:	c36080e7          	jalr	-970(ra) # 80000360 <safestrcpy>
  oldpagetable = p->pagetable;
    80004732:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004736:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000473a:	e0843783          	ld	a5,-504(s0)
    8000473e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004742:	058ab783          	ld	a5,88(s5)
    80004746:	e6843703          	ld	a4,-408(s0)
    8000474a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    8000474c:	058ab783          	ld	a5,88(s5)
    80004750:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004754:	85e6                	mv	a1,s9
    80004756:	ffffd097          	auipc	ra,0xffffd
    8000475a:	ab0080e7          	jalr	-1360(ra) # 80001206 <proc_freepagetable>
  if (p->pid == 1) {
    8000475e:	030aa703          	lw	a4,48(s5)
    80004762:	4785                	li	a5,1
    80004764:	00f70d63          	beq	a4,a5,8000477e <exec+0x376>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    80004768:	0004851b          	sext.w	a0,s1
    8000476c:	79be                	ld	s3,488(sp)
    8000476e:	7a1e                	ld	s4,480(sp)
    80004770:	6afe                	ld	s5,472(sp)
    80004772:	6b5e                	ld	s6,464(sp)
    80004774:	6bbe                	ld	s7,456(sp)
    80004776:	6c1e                	ld	s8,448(sp)
    80004778:	7cfa                	ld	s9,440(sp)
    8000477a:	7d5a                	ld	s10,432(sp)
    8000477c:	bb19                	j	80004492 <exec+0x8a>
    vmprint(pagetable);
    8000477e:	855a                	mv	a0,s6
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	75c080e7          	jalr	1884(ra) # 80000edc <vmprint>
    80004788:	b7c5                	j	80004768 <exec+0x360>
    8000478a:	e1243423          	sd	s2,-504(s0)
    8000478e:	7dba                	ld	s11,424(sp)
    80004790:	a035                	j	800047bc <exec+0x3b4>
    80004792:	e1243423          	sd	s2,-504(s0)
    80004796:	7dba                	ld	s11,424(sp)
    80004798:	a015                	j	800047bc <exec+0x3b4>
    8000479a:	e1243423          	sd	s2,-504(s0)
    8000479e:	7dba                	ld	s11,424(sp)
    800047a0:	a831                	j	800047bc <exec+0x3b4>
    800047a2:	e1243423          	sd	s2,-504(s0)
    800047a6:	7dba                	ld	s11,424(sp)
    800047a8:	a811                	j	800047bc <exec+0x3b4>
    800047aa:	e1243423          	sd	s2,-504(s0)
    800047ae:	7dba                	ld	s11,424(sp)
    800047b0:	a031                	j	800047bc <exec+0x3b4>
  ip = 0;
    800047b2:	4a01                	li	s4,0
    800047b4:	a021                	j	800047bc <exec+0x3b4>
    800047b6:	4a01                	li	s4,0
  if (pagetable) proc_freepagetable(pagetable, sz);
    800047b8:	a011                	j	800047bc <exec+0x3b4>
    800047ba:	7dba                	ld	s11,424(sp)
    800047bc:	e0843583          	ld	a1,-504(s0)
    800047c0:	855a                	mv	a0,s6
    800047c2:	ffffd097          	auipc	ra,0xffffd
    800047c6:	a44080e7          	jalr	-1468(ra) # 80001206 <proc_freepagetable>
  return -1;
    800047ca:	557d                	li	a0,-1
  if (ip) {
    800047cc:	000a1b63          	bnez	s4,800047e2 <exec+0x3da>
    800047d0:	79be                	ld	s3,488(sp)
    800047d2:	7a1e                	ld	s4,480(sp)
    800047d4:	6afe                	ld	s5,472(sp)
    800047d6:	6b5e                	ld	s6,464(sp)
    800047d8:	6bbe                	ld	s7,456(sp)
    800047da:	6c1e                	ld	s8,448(sp)
    800047dc:	7cfa                	ld	s9,440(sp)
    800047de:	7d5a                	ld	s10,432(sp)
    800047e0:	b94d                	j	80004492 <exec+0x8a>
    800047e2:	79be                	ld	s3,488(sp)
    800047e4:	6afe                	ld	s5,472(sp)
    800047e6:	6b5e                	ld	s6,464(sp)
    800047e8:	6bbe                	ld	s7,456(sp)
    800047ea:	6c1e                	ld	s8,448(sp)
    800047ec:	7cfa                	ld	s9,440(sp)
    800047ee:	7d5a                	ld	s10,432(sp)
    800047f0:	b171                	j	8000447c <exec+0x74>
    800047f2:	6b5e                	ld	s6,464(sp)
    800047f4:	b161                	j	8000447c <exec+0x74>
  sz = sz1;
    800047f6:	e0843983          	ld	s3,-504(s0)
    800047fa:	b53d                	j	80004628 <exec+0x220>

00000000800047fc <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800047fc:	7179                	addi	sp,sp,-48
    800047fe:	f406                	sd	ra,40(sp)
    80004800:	f022                	sd	s0,32(sp)
    80004802:	ec26                	sd	s1,24(sp)
    80004804:	e84a                	sd	s2,16(sp)
    80004806:	1800                	addi	s0,sp,48
    80004808:	892e                	mv	s2,a1
    8000480a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000480c:	fdc40593          	addi	a1,s0,-36
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	af2080e7          	jalr	-1294(ra) # 80002302 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004818:	fdc42703          	lw	a4,-36(s0)
    8000481c:	47bd                	li	a5,15
    8000481e:	02e7eb63          	bltu	a5,a4,80004854 <argfd+0x58>
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	880080e7          	jalr	-1920(ra) # 800010a2 <myproc>
    8000482a:	fdc42703          	lw	a4,-36(s0)
    8000482e:	01a70793          	addi	a5,a4,26
    80004832:	078e                	slli	a5,a5,0x3
    80004834:	953e                	add	a0,a0,a5
    80004836:	611c                	ld	a5,0(a0)
    80004838:	c385                	beqz	a5,80004858 <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000483a:	00090463          	beqz	s2,80004842 <argfd+0x46>
    8000483e:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    80004842:	4501                	li	a0,0
  if (pf) *pf = f;
    80004844:	c091                	beqz	s1,80004848 <argfd+0x4c>
    80004846:	e09c                	sd	a5,0(s1)
}
    80004848:	70a2                	ld	ra,40(sp)
    8000484a:	7402                	ld	s0,32(sp)
    8000484c:	64e2                	ld	s1,24(sp)
    8000484e:	6942                	ld	s2,16(sp)
    80004850:	6145                	addi	sp,sp,48
    80004852:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004854:	557d                	li	a0,-1
    80004856:	bfcd                	j	80004848 <argfd+0x4c>
    80004858:	557d                	li	a0,-1
    8000485a:	b7fd                	j	80004848 <argfd+0x4c>

000000008000485c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	e426                	sd	s1,8(sp)
    80004864:	1000                	addi	s0,sp,32
    80004866:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004868:	ffffd097          	auipc	ra,0xffffd
    8000486c:	83a080e7          	jalr	-1990(ra) # 800010a2 <myproc>
    80004870:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004872:	0d050793          	addi	a5,a0,208
    80004876:	4501                	li	a0,0
    80004878:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000487a:	6398                	ld	a4,0(a5)
    8000487c:	cb19                	beqz	a4,80004892 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000487e:	2505                	addiw	a0,a0,1
    80004880:	07a1                	addi	a5,a5,8
    80004882:	fed51ce3          	bne	a0,a3,8000487a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004886:	557d                	li	a0,-1
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	64a2                	ld	s1,8(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret
      p->ofile[fd] = f;
    80004892:	01a50793          	addi	a5,a0,26
    80004896:	078e                	slli	a5,a5,0x3
    80004898:	963e                	add	a2,a2,a5
    8000489a:	e204                	sd	s1,0(a2)
      return fd;
    8000489c:	b7f5                	j	80004888 <fdalloc+0x2c>

000000008000489e <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    8000489e:	715d                	addi	sp,sp,-80
    800048a0:	e486                	sd	ra,72(sp)
    800048a2:	e0a2                	sd	s0,64(sp)
    800048a4:	fc26                	sd	s1,56(sp)
    800048a6:	f84a                	sd	s2,48(sp)
    800048a8:	f44e                	sd	s3,40(sp)
    800048aa:	ec56                	sd	s5,24(sp)
    800048ac:	e85a                	sd	s6,16(sp)
    800048ae:	0880                	addi	s0,sp,80
    800048b0:	8b2e                	mv	s6,a1
    800048b2:	89b2                	mv	s3,a2
    800048b4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    800048b6:	fb040593          	addi	a1,s0,-80
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	dcc080e7          	jalr	-564(ra) # 80003686 <nameiparent>
    800048c2:	84aa                	mv	s1,a0
    800048c4:	14050e63          	beqz	a0,80004a20 <create+0x182>

  ilock(dp);
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	5d2080e7          	jalr	1490(ra) # 80002e9a <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800048d0:	4601                	li	a2,0
    800048d2:	fb040593          	addi	a1,s0,-80
    800048d6:	8526                	mv	a0,s1
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	ace080e7          	jalr	-1330(ra) # 800033a6 <dirlookup>
    800048e0:	8aaa                	mv	s5,a0
    800048e2:	c539                	beqz	a0,80004930 <create+0x92>
    iunlockput(dp);
    800048e4:	8526                	mv	a0,s1
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	81a080e7          	jalr	-2022(ra) # 80003100 <iunlockput>
    ilock(ip);
    800048ee:	8556                	mv	a0,s5
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	5aa080e7          	jalr	1450(ra) # 80002e9a <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048f8:	4789                	li	a5,2
    800048fa:	02fb1463          	bne	s6,a5,80004922 <create+0x84>
    800048fe:	044ad783          	lhu	a5,68(s5)
    80004902:	37f9                	addiw	a5,a5,-2
    80004904:	17c2                	slli	a5,a5,0x30
    80004906:	93c1                	srli	a5,a5,0x30
    80004908:	4705                	li	a4,1
    8000490a:	00f76c63          	bltu	a4,a5,80004922 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000490e:	8556                	mv	a0,s5
    80004910:	60a6                	ld	ra,72(sp)
    80004912:	6406                	ld	s0,64(sp)
    80004914:	74e2                	ld	s1,56(sp)
    80004916:	7942                	ld	s2,48(sp)
    80004918:	79a2                	ld	s3,40(sp)
    8000491a:	6ae2                	ld	s5,24(sp)
    8000491c:	6b42                	ld	s6,16(sp)
    8000491e:	6161                	addi	sp,sp,80
    80004920:	8082                	ret
    iunlockput(ip);
    80004922:	8556                	mv	a0,s5
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	7dc080e7          	jalr	2012(ra) # 80003100 <iunlockput>
    return 0;
    8000492c:	4a81                	li	s5,0
    8000492e:	b7c5                	j	8000490e <create+0x70>
    80004930:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004932:	85da                	mv	a1,s6
    80004934:	4088                	lw	a0,0(s1)
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	3c0080e7          	jalr	960(ra) # 80002cf6 <ialloc>
    8000493e:	8a2a                	mv	s4,a0
    80004940:	c531                	beqz	a0,8000498c <create+0xee>
  ilock(ip);
    80004942:	ffffe097          	auipc	ra,0xffffe
    80004946:	558080e7          	jalr	1368(ra) # 80002e9a <ilock>
  ip->major = major;
    8000494a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000494e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004952:	4905                	li	s2,1
    80004954:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004958:	8552                	mv	a0,s4
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	474080e7          	jalr	1140(ra) # 80002dce <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    80004962:	032b0d63          	beq	s6,s2,8000499c <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004966:	004a2603          	lw	a2,4(s4)
    8000496a:	fb040593          	addi	a1,s0,-80
    8000496e:	8526                	mv	a0,s1
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	c46080e7          	jalr	-954(ra) # 800035b6 <dirlink>
    80004978:	08054163          	bltz	a0,800049fa <create+0x15c>
  iunlockput(dp);
    8000497c:	8526                	mv	a0,s1
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	782080e7          	jalr	1922(ra) # 80003100 <iunlockput>
  return ip;
    80004986:	8ad2                	mv	s5,s4
    80004988:	7a02                	ld	s4,32(sp)
    8000498a:	b751                	j	8000490e <create+0x70>
    iunlockput(dp);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	772080e7          	jalr	1906(ra) # 80003100 <iunlockput>
    return 0;
    80004996:	8ad2                	mv	s5,s4
    80004998:	7a02                	ld	s4,32(sp)
    8000499a:	bf95                	j	8000490e <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000499c:	004a2603          	lw	a2,4(s4)
    800049a0:	00004597          	auipc	a1,0x4
    800049a4:	c5058593          	addi	a1,a1,-944 # 800085f0 <etext+0x5f0>
    800049a8:	8552                	mv	a0,s4
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	c0c080e7          	jalr	-1012(ra) # 800035b6 <dirlink>
    800049b2:	04054463          	bltz	a0,800049fa <create+0x15c>
    800049b6:	40d0                	lw	a2,4(s1)
    800049b8:	00004597          	auipc	a1,0x4
    800049bc:	c4058593          	addi	a1,a1,-960 # 800085f8 <etext+0x5f8>
    800049c0:	8552                	mv	a0,s4
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	bf4080e7          	jalr	-1036(ra) # 800035b6 <dirlink>
    800049ca:	02054863          	bltz	a0,800049fa <create+0x15c>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800049ce:	004a2603          	lw	a2,4(s4)
    800049d2:	fb040593          	addi	a1,s0,-80
    800049d6:	8526                	mv	a0,s1
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	bde080e7          	jalr	-1058(ra) # 800035b6 <dirlink>
    800049e0:	00054d63          	bltz	a0,800049fa <create+0x15c>
    dp->nlink++;  // for ".."
    800049e4:	04a4d783          	lhu	a5,74(s1)
    800049e8:	2785                	addiw	a5,a5,1
    800049ea:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	3de080e7          	jalr	990(ra) # 80002dce <iupdate>
    800049f8:	b751                	j	8000497c <create+0xde>
  ip->nlink = 0;
    800049fa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049fe:	8552                	mv	a0,s4
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	3ce080e7          	jalr	974(ra) # 80002dce <iupdate>
  iunlockput(ip);
    80004a08:	8552                	mv	a0,s4
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	6f6080e7          	jalr	1782(ra) # 80003100 <iunlockput>
  iunlockput(dp);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	6ec080e7          	jalr	1772(ra) # 80003100 <iunlockput>
  return 0;
    80004a1c:	7a02                	ld	s4,32(sp)
    80004a1e:	bdc5                	j	8000490e <create+0x70>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004a20:	8aaa                	mv	s5,a0
    80004a22:	b5f5                	j	8000490e <create+0x70>

0000000080004a24 <sys_dup>:
uint64 sys_dup(void) {
    80004a24:	7179                	addi	sp,sp,-48
    80004a26:	f406                	sd	ra,40(sp)
    80004a28:	f022                	sd	s0,32(sp)
    80004a2a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004a2c:	fd840613          	addi	a2,s0,-40
    80004a30:	4581                	li	a1,0
    80004a32:	4501                	li	a0,0
    80004a34:	00000097          	auipc	ra,0x0
    80004a38:	dc8080e7          	jalr	-568(ra) # 800047fc <argfd>
    80004a3c:	57fd                	li	a5,-1
    80004a3e:	02054763          	bltz	a0,80004a6c <sys_dup+0x48>
    80004a42:	ec26                	sd	s1,24(sp)
    80004a44:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0) return -1;
    80004a46:	fd843903          	ld	s2,-40(s0)
    80004a4a:	854a                	mv	a0,s2
    80004a4c:	00000097          	auipc	ra,0x0
    80004a50:	e10080e7          	jalr	-496(ra) # 8000485c <fdalloc>
    80004a54:	84aa                	mv	s1,a0
    80004a56:	57fd                	li	a5,-1
    80004a58:	00054f63          	bltz	a0,80004a76 <sys_dup+0x52>
  filedup(f);
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	282080e7          	jalr	642(ra) # 80003ce0 <filedup>
  return fd;
    80004a66:	87a6                	mv	a5,s1
    80004a68:	64e2                	ld	s1,24(sp)
    80004a6a:	6942                	ld	s2,16(sp)
}
    80004a6c:	853e                	mv	a0,a5
    80004a6e:	70a2                	ld	ra,40(sp)
    80004a70:	7402                	ld	s0,32(sp)
    80004a72:	6145                	addi	sp,sp,48
    80004a74:	8082                	ret
    80004a76:	64e2                	ld	s1,24(sp)
    80004a78:	6942                	ld	s2,16(sp)
    80004a7a:	bfcd                	j	80004a6c <sys_dup+0x48>

0000000080004a7c <sys_read>:
uint64 sys_read(void) {
    80004a7c:	7179                	addi	sp,sp,-48
    80004a7e:	f406                	sd	ra,40(sp)
    80004a80:	f022                	sd	s0,32(sp)
    80004a82:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a84:	fd840593          	addi	a1,s0,-40
    80004a88:	4505                	li	a0,1
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	898080e7          	jalr	-1896(ra) # 80002322 <argaddr>
  argint(2, &n);
    80004a92:	fe440593          	addi	a1,s0,-28
    80004a96:	4509                	li	a0,2
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	86a080e7          	jalr	-1942(ra) # 80002302 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004aa0:	fe840613          	addi	a2,s0,-24
    80004aa4:	4581                	li	a1,0
    80004aa6:	4501                	li	a0,0
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	d54080e7          	jalr	-684(ra) # 800047fc <argfd>
    80004ab0:	87aa                	mv	a5,a0
    80004ab2:	557d                	li	a0,-1
    80004ab4:	0007cc63          	bltz	a5,80004acc <sys_read+0x50>
  return fileread(f, p, n);
    80004ab8:	fe442603          	lw	a2,-28(s0)
    80004abc:	fd843583          	ld	a1,-40(s0)
    80004ac0:	fe843503          	ld	a0,-24(s0)
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	3c2080e7          	jalr	962(ra) # 80003e86 <fileread>
}
    80004acc:	70a2                	ld	ra,40(sp)
    80004ace:	7402                	ld	s0,32(sp)
    80004ad0:	6145                	addi	sp,sp,48
    80004ad2:	8082                	ret

0000000080004ad4 <sys_write>:
uint64 sys_write(void) {
    80004ad4:	7179                	addi	sp,sp,-48
    80004ad6:	f406                	sd	ra,40(sp)
    80004ad8:	f022                	sd	s0,32(sp)
    80004ada:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004adc:	fd840593          	addi	a1,s0,-40
    80004ae0:	4505                	li	a0,1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	840080e7          	jalr	-1984(ra) # 80002322 <argaddr>
  argint(2, &n);
    80004aea:	fe440593          	addi	a1,s0,-28
    80004aee:	4509                	li	a0,2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	812080e7          	jalr	-2030(ra) # 80002302 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004af8:	fe840613          	addi	a2,s0,-24
    80004afc:	4581                	li	a1,0
    80004afe:	4501                	li	a0,0
    80004b00:	00000097          	auipc	ra,0x0
    80004b04:	cfc080e7          	jalr	-772(ra) # 800047fc <argfd>
    80004b08:	87aa                	mv	a5,a0
    80004b0a:	557d                	li	a0,-1
    80004b0c:	0007cc63          	bltz	a5,80004b24 <sys_write+0x50>
  return filewrite(f, p, n);
    80004b10:	fe442603          	lw	a2,-28(s0)
    80004b14:	fd843583          	ld	a1,-40(s0)
    80004b18:	fe843503          	ld	a0,-24(s0)
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	43c080e7          	jalr	1084(ra) # 80003f58 <filewrite>
}
    80004b24:	70a2                	ld	ra,40(sp)
    80004b26:	7402                	ld	s0,32(sp)
    80004b28:	6145                	addi	sp,sp,48
    80004b2a:	8082                	ret

0000000080004b2c <sys_close>:
uint64 sys_close(void) {
    80004b2c:	1101                	addi	sp,sp,-32
    80004b2e:	ec06                	sd	ra,24(sp)
    80004b30:	e822                	sd	s0,16(sp)
    80004b32:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004b34:	fe040613          	addi	a2,s0,-32
    80004b38:	fec40593          	addi	a1,s0,-20
    80004b3c:	4501                	li	a0,0
    80004b3e:	00000097          	auipc	ra,0x0
    80004b42:	cbe080e7          	jalr	-834(ra) # 800047fc <argfd>
    80004b46:	57fd                	li	a5,-1
    80004b48:	02054463          	bltz	a0,80004b70 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004b4c:	ffffc097          	auipc	ra,0xffffc
    80004b50:	556080e7          	jalr	1366(ra) # 800010a2 <myproc>
    80004b54:	fec42783          	lw	a5,-20(s0)
    80004b58:	07e9                	addi	a5,a5,26
    80004b5a:	078e                	slli	a5,a5,0x3
    80004b5c:	953e                	add	a0,a0,a5
    80004b5e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b62:	fe043503          	ld	a0,-32(s0)
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	1cc080e7          	jalr	460(ra) # 80003d32 <fileclose>
  return 0;
    80004b6e:	4781                	li	a5,0
}
    80004b70:	853e                	mv	a0,a5
    80004b72:	60e2                	ld	ra,24(sp)
    80004b74:	6442                	ld	s0,16(sp)
    80004b76:	6105                	addi	sp,sp,32
    80004b78:	8082                	ret

0000000080004b7a <sys_fstat>:
uint64 sys_fstat(void) {
    80004b7a:	1101                	addi	sp,sp,-32
    80004b7c:	ec06                	sd	ra,24(sp)
    80004b7e:	e822                	sd	s0,16(sp)
    80004b80:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b82:	fe040593          	addi	a1,s0,-32
    80004b86:	4505                	li	a0,1
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	79a080e7          	jalr	1946(ra) # 80002322 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004b90:	fe840613          	addi	a2,s0,-24
    80004b94:	4581                	li	a1,0
    80004b96:	4501                	li	a0,0
    80004b98:	00000097          	auipc	ra,0x0
    80004b9c:	c64080e7          	jalr	-924(ra) # 800047fc <argfd>
    80004ba0:	87aa                	mv	a5,a0
    80004ba2:	557d                	li	a0,-1
    80004ba4:	0007ca63          	bltz	a5,80004bb8 <sys_fstat+0x3e>
  return filestat(f, st);
    80004ba8:	fe043583          	ld	a1,-32(s0)
    80004bac:	fe843503          	ld	a0,-24(s0)
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	264080e7          	jalr	612(ra) # 80003e14 <filestat>
}
    80004bb8:	60e2                	ld	ra,24(sp)
    80004bba:	6442                	ld	s0,16(sp)
    80004bbc:	6105                	addi	sp,sp,32
    80004bbe:	8082                	ret

0000000080004bc0 <sys_link>:
uint64 sys_link(void) {
    80004bc0:	7169                	addi	sp,sp,-304
    80004bc2:	f606                	sd	ra,296(sp)
    80004bc4:	f222                	sd	s0,288(sp)
    80004bc6:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004bc8:	08000613          	li	a2,128
    80004bcc:	ed040593          	addi	a1,s0,-304
    80004bd0:	4501                	li	a0,0
    80004bd2:	ffffd097          	auipc	ra,0xffffd
    80004bd6:	770080e7          	jalr	1904(ra) # 80002342 <argstr>
    80004bda:	57fd                	li	a5,-1
    80004bdc:	12054663          	bltz	a0,80004d08 <sys_link+0x148>
    80004be0:	08000613          	li	a2,128
    80004be4:	f5040593          	addi	a1,s0,-176
    80004be8:	4505                	li	a0,1
    80004bea:	ffffd097          	auipc	ra,0xffffd
    80004bee:	758080e7          	jalr	1880(ra) # 80002342 <argstr>
    80004bf2:	57fd                	li	a5,-1
    80004bf4:	10054a63          	bltz	a0,80004d08 <sys_link+0x148>
    80004bf8:	ee26                	sd	s1,280(sp)
  begin_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	c6e080e7          	jalr	-914(ra) # 80003868 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004c02:	ed040513          	addi	a0,s0,-304
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	a62080e7          	jalr	-1438(ra) # 80003668 <namei>
    80004c0e:	84aa                	mv	s1,a0
    80004c10:	c949                	beqz	a0,80004ca2 <sys_link+0xe2>
  ilock(ip);
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	288080e7          	jalr	648(ra) # 80002e9a <ilock>
  if (ip->type == T_DIR) {
    80004c1a:	04449703          	lh	a4,68(s1)
    80004c1e:	4785                	li	a5,1
    80004c20:	08f70863          	beq	a4,a5,80004cb0 <sys_link+0xf0>
    80004c24:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004c26:	04a4d783          	lhu	a5,74(s1)
    80004c2a:	2785                	addiw	a5,a5,1
    80004c2c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c30:	8526                	mv	a0,s1
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	19c080e7          	jalr	412(ra) # 80002dce <iupdate>
  iunlock(ip);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	324080e7          	jalr	804(ra) # 80002f60 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004c44:	fd040593          	addi	a1,s0,-48
    80004c48:	f5040513          	addi	a0,s0,-176
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	a3a080e7          	jalr	-1478(ra) # 80003686 <nameiparent>
    80004c54:	892a                	mv	s2,a0
    80004c56:	cd35                	beqz	a0,80004cd2 <sys_link+0x112>
  ilock(dp);
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	242080e7          	jalr	578(ra) # 80002e9a <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004c60:	00092703          	lw	a4,0(s2)
    80004c64:	409c                	lw	a5,0(s1)
    80004c66:	06f71163          	bne	a4,a5,80004cc8 <sys_link+0x108>
    80004c6a:	40d0                	lw	a2,4(s1)
    80004c6c:	fd040593          	addi	a1,s0,-48
    80004c70:	854a                	mv	a0,s2
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	944080e7          	jalr	-1724(ra) # 800035b6 <dirlink>
    80004c7a:	04054763          	bltz	a0,80004cc8 <sys_link+0x108>
  iunlockput(dp);
    80004c7e:	854a                	mv	a0,s2
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	480080e7          	jalr	1152(ra) # 80003100 <iunlockput>
  iput(ip);
    80004c88:	8526                	mv	a0,s1
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	3ce080e7          	jalr	974(ra) # 80003058 <iput>
  end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	c50080e7          	jalr	-944(ra) # 800038e2 <end_op>
  return 0;
    80004c9a:	4781                	li	a5,0
    80004c9c:	64f2                	ld	s1,280(sp)
    80004c9e:	6952                	ld	s2,272(sp)
    80004ca0:	a0a5                	j	80004d08 <sys_link+0x148>
    end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	c40080e7          	jalr	-960(ra) # 800038e2 <end_op>
    return -1;
    80004caa:	57fd                	li	a5,-1
    80004cac:	64f2                	ld	s1,280(sp)
    80004cae:	a8a9                	j	80004d08 <sys_link+0x148>
    iunlockput(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	44e080e7          	jalr	1102(ra) # 80003100 <iunlockput>
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	c28080e7          	jalr	-984(ra) # 800038e2 <end_op>
    return -1;
    80004cc2:	57fd                	li	a5,-1
    80004cc4:	64f2                	ld	s1,280(sp)
    80004cc6:	a089                	j	80004d08 <sys_link+0x148>
    iunlockput(dp);
    80004cc8:	854a                	mv	a0,s2
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	436080e7          	jalr	1078(ra) # 80003100 <iunlockput>
  ilock(ip);
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	1c6080e7          	jalr	454(ra) # 80002e9a <ilock>
  ip->nlink--;
    80004cdc:	04a4d783          	lhu	a5,74(s1)
    80004ce0:	37fd                	addiw	a5,a5,-1
    80004ce2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	0e6080e7          	jalr	230(ra) # 80002dce <iupdate>
  iunlockput(ip);
    80004cf0:	8526                	mv	a0,s1
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	40e080e7          	jalr	1038(ra) # 80003100 <iunlockput>
  end_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	be8080e7          	jalr	-1048(ra) # 800038e2 <end_op>
  return -1;
    80004d02:	57fd                	li	a5,-1
    80004d04:	64f2                	ld	s1,280(sp)
    80004d06:	6952                	ld	s2,272(sp)
}
    80004d08:	853e                	mv	a0,a5
    80004d0a:	70b2                	ld	ra,296(sp)
    80004d0c:	7412                	ld	s0,288(sp)
    80004d0e:	6155                	addi	sp,sp,304
    80004d10:	8082                	ret

0000000080004d12 <sys_unlink>:
uint64 sys_unlink(void) {
    80004d12:	7151                	addi	sp,sp,-240
    80004d14:	f586                	sd	ra,232(sp)
    80004d16:	f1a2                	sd	s0,224(sp)
    80004d18:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004d1a:	08000613          	li	a2,128
    80004d1e:	f3040593          	addi	a1,s0,-208
    80004d22:	4501                	li	a0,0
    80004d24:	ffffd097          	auipc	ra,0xffffd
    80004d28:	61e080e7          	jalr	1566(ra) # 80002342 <argstr>
    80004d2c:	1a054a63          	bltz	a0,80004ee0 <sys_unlink+0x1ce>
    80004d30:	eda6                	sd	s1,216(sp)
  begin_op();
    80004d32:	fffff097          	auipc	ra,0xfffff
    80004d36:	b36080e7          	jalr	-1226(ra) # 80003868 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004d3a:	fb040593          	addi	a1,s0,-80
    80004d3e:	f3040513          	addi	a0,s0,-208
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	944080e7          	jalr	-1724(ra) # 80003686 <nameiparent>
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	cd71                	beqz	a0,80004e28 <sys_unlink+0x116>
  ilock(dp);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	14c080e7          	jalr	332(ra) # 80002e9a <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004d56:	00004597          	auipc	a1,0x4
    80004d5a:	89a58593          	addi	a1,a1,-1894 # 800085f0 <etext+0x5f0>
    80004d5e:	fb040513          	addi	a0,s0,-80
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	62a080e7          	jalr	1578(ra) # 8000338c <namecmp>
    80004d6a:	14050c63          	beqz	a0,80004ec2 <sys_unlink+0x1b0>
    80004d6e:	00004597          	auipc	a1,0x4
    80004d72:	88a58593          	addi	a1,a1,-1910 # 800085f8 <etext+0x5f8>
    80004d76:	fb040513          	addi	a0,s0,-80
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	612080e7          	jalr	1554(ra) # 8000338c <namecmp>
    80004d82:	14050063          	beqz	a0,80004ec2 <sys_unlink+0x1b0>
    80004d86:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004d88:	f2c40613          	addi	a2,s0,-212
    80004d8c:	fb040593          	addi	a1,s0,-80
    80004d90:	8526                	mv	a0,s1
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	614080e7          	jalr	1556(ra) # 800033a6 <dirlookup>
    80004d9a:	892a                	mv	s2,a0
    80004d9c:	12050263          	beqz	a0,80004ec0 <sys_unlink+0x1ae>
  ilock(ip);
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	0fa080e7          	jalr	250(ra) # 80002e9a <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004da8:	04a91783          	lh	a5,74(s2)
    80004dac:	08f05563          	blez	a5,80004e36 <sys_unlink+0x124>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004db0:	04491703          	lh	a4,68(s2)
    80004db4:	4785                	li	a5,1
    80004db6:	08f70963          	beq	a4,a5,80004e48 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004dba:	4641                	li	a2,16
    80004dbc:	4581                	li	a1,0
    80004dbe:	fc040513          	addi	a0,s0,-64
    80004dc2:	ffffb097          	auipc	ra,0xffffb
    80004dc6:	45c080e7          	jalr	1116(ra) # 8000021e <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dca:	4741                	li	a4,16
    80004dcc:	f2c42683          	lw	a3,-212(s0)
    80004dd0:	fc040613          	addi	a2,s0,-64
    80004dd4:	4581                	li	a1,0
    80004dd6:	8526                	mv	a0,s1
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	48a080e7          	jalr	1162(ra) # 80003262 <writei>
    80004de0:	47c1                	li	a5,16
    80004de2:	0af51b63          	bne	a0,a5,80004e98 <sys_unlink+0x186>
  if (ip->type == T_DIR) {
    80004de6:	04491703          	lh	a4,68(s2)
    80004dea:	4785                	li	a5,1
    80004dec:	0af70f63          	beq	a4,a5,80004eaa <sys_unlink+0x198>
  iunlockput(dp);
    80004df0:	8526                	mv	a0,s1
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	30e080e7          	jalr	782(ra) # 80003100 <iunlockput>
  ip->nlink--;
    80004dfa:	04a95783          	lhu	a5,74(s2)
    80004dfe:	37fd                	addiw	a5,a5,-1
    80004e00:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e04:	854a                	mv	a0,s2
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	fc8080e7          	jalr	-56(ra) # 80002dce <iupdate>
  iunlockput(ip);
    80004e0e:	854a                	mv	a0,s2
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	2f0080e7          	jalr	752(ra) # 80003100 <iunlockput>
  end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	aca080e7          	jalr	-1334(ra) # 800038e2 <end_op>
  return 0;
    80004e20:	4501                	li	a0,0
    80004e22:	64ee                	ld	s1,216(sp)
    80004e24:	694e                	ld	s2,208(sp)
    80004e26:	a84d                	j	80004ed8 <sys_unlink+0x1c6>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	aba080e7          	jalr	-1350(ra) # 800038e2 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	64ee                	ld	s1,216(sp)
    80004e34:	a055                	j	80004ed8 <sys_unlink+0x1c6>
    80004e36:	e5ce                	sd	s3,200(sp)
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004e38:	00003517          	auipc	a0,0x3
    80004e3c:	7c850513          	addi	a0,a0,1992 # 80008600 <etext+0x600>
    80004e40:	00001097          	auipc	ra,0x1
    80004e44:	242080e7          	jalr	578(ra) # 80006082 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004e48:	04c92703          	lw	a4,76(s2)
    80004e4c:	02000793          	li	a5,32
    80004e50:	f6e7f5e3          	bgeu	a5,a4,80004dba <sys_unlink+0xa8>
    80004e54:	e5ce                	sd	s3,200(sp)
    80004e56:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e5a:	4741                	li	a4,16
    80004e5c:	86ce                	mv	a3,s3
    80004e5e:	f1840613          	addi	a2,s0,-232
    80004e62:	4581                	li	a1,0
    80004e64:	854a                	mv	a0,s2
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	2ec080e7          	jalr	748(ra) # 80003152 <readi>
    80004e6e:	47c1                	li	a5,16
    80004e70:	00f51c63          	bne	a0,a5,80004e88 <sys_unlink+0x176>
    if (de.inum != 0) return 0;
    80004e74:	f1845783          	lhu	a5,-232(s0)
    80004e78:	e7b5                	bnez	a5,80004ee4 <sys_unlink+0x1d2>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004e7a:	29c1                	addiw	s3,s3,16
    80004e7c:	04c92783          	lw	a5,76(s2)
    80004e80:	fcf9ede3          	bltu	s3,a5,80004e5a <sys_unlink+0x148>
    80004e84:	69ae                	ld	s3,200(sp)
    80004e86:	bf15                	j	80004dba <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004e88:	00003517          	auipc	a0,0x3
    80004e8c:	79050513          	addi	a0,a0,1936 # 80008618 <etext+0x618>
    80004e90:	00001097          	auipc	ra,0x1
    80004e94:	1f2080e7          	jalr	498(ra) # 80006082 <panic>
    80004e98:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e9a:	00003517          	auipc	a0,0x3
    80004e9e:	79650513          	addi	a0,a0,1942 # 80008630 <etext+0x630>
    80004ea2:	00001097          	auipc	ra,0x1
    80004ea6:	1e0080e7          	jalr	480(ra) # 80006082 <panic>
    dp->nlink--;
    80004eaa:	04a4d783          	lhu	a5,74(s1)
    80004eae:	37fd                	addiw	a5,a5,-1
    80004eb0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	f18080e7          	jalr	-232(ra) # 80002dce <iupdate>
    80004ebe:	bf0d                	j	80004df0 <sys_unlink+0xde>
    80004ec0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ec2:	8526                	mv	a0,s1
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	23c080e7          	jalr	572(ra) # 80003100 <iunlockput>
  end_op();
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	a16080e7          	jalr	-1514(ra) # 800038e2 <end_op>
  return -1;
    80004ed4:	557d                	li	a0,-1
    80004ed6:	64ee                	ld	s1,216(sp)
}
    80004ed8:	70ae                	ld	ra,232(sp)
    80004eda:	740e                	ld	s0,224(sp)
    80004edc:	616d                	addi	sp,sp,240
    80004ede:	8082                	ret
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	bfdd                	j	80004ed8 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	21a080e7          	jalr	538(ra) # 80003100 <iunlockput>
    goto bad;
    80004eee:	694e                	ld	s2,208(sp)
    80004ef0:	69ae                	ld	s3,200(sp)
    80004ef2:	bfc1                	j	80004ec2 <sys_unlink+0x1b0>

0000000080004ef4 <sys_open>:

uint64 sys_open(void) {
    80004ef4:	7131                	addi	sp,sp,-192
    80004ef6:	fd06                	sd	ra,184(sp)
    80004ef8:	f922                	sd	s0,176(sp)
    80004efa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004efc:	f4c40593          	addi	a1,s0,-180
    80004f00:	4505                	li	a0,1
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	400080e7          	jalr	1024(ra) # 80002302 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004f0a:	08000613          	li	a2,128
    80004f0e:	f5040593          	addi	a1,s0,-176
    80004f12:	4501                	li	a0,0
    80004f14:	ffffd097          	auipc	ra,0xffffd
    80004f18:	42e080e7          	jalr	1070(ra) # 80002342 <argstr>
    80004f1c:	87aa                	mv	a5,a0
    80004f1e:	557d                	li	a0,-1
    80004f20:	0a07ce63          	bltz	a5,80004fdc <sys_open+0xe8>
    80004f24:	f526                	sd	s1,168(sp)

  begin_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	942080e7          	jalr	-1726(ra) # 80003868 <begin_op>

  if (omode & O_CREATE) {
    80004f2e:	f4c42783          	lw	a5,-180(s0)
    80004f32:	2007f793          	andi	a5,a5,512
    80004f36:	cfd5                	beqz	a5,80004ff2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004f38:	4681                	li	a3,0
    80004f3a:	4601                	li	a2,0
    80004f3c:	4589                	li	a1,2
    80004f3e:	f5040513          	addi	a0,s0,-176
    80004f42:	00000097          	auipc	ra,0x0
    80004f46:	95c080e7          	jalr	-1700(ra) # 8000489e <create>
    80004f4a:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004f4c:	cd41                	beqz	a0,80004fe4 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004f4e:	04449703          	lh	a4,68(s1)
    80004f52:	478d                	li	a5,3
    80004f54:	00f71763          	bne	a4,a5,80004f62 <sys_open+0x6e>
    80004f58:	0464d703          	lhu	a4,70(s1)
    80004f5c:	47a5                	li	a5,9
    80004f5e:	0ee7e163          	bltu	a5,a4,80005040 <sys_open+0x14c>
    80004f62:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	d12080e7          	jalr	-750(ra) # 80003c76 <filealloc>
    80004f6c:	892a                	mv	s2,a0
    80004f6e:	c97d                	beqz	a0,80005064 <sys_open+0x170>
    80004f70:	ed4e                	sd	s3,152(sp)
    80004f72:	00000097          	auipc	ra,0x0
    80004f76:	8ea080e7          	jalr	-1814(ra) # 8000485c <fdalloc>
    80004f7a:	89aa                	mv	s3,a0
    80004f7c:	0c054e63          	bltz	a0,80005058 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004f80:	04449703          	lh	a4,68(s1)
    80004f84:	478d                	li	a5,3
    80004f86:	0ef70c63          	beq	a4,a5,8000507e <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f8a:	4789                	li	a5,2
    80004f8c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f90:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f94:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f98:	f4c42783          	lw	a5,-180(s0)
    80004f9c:	0017c713          	xori	a4,a5,1
    80004fa0:	8b05                	andi	a4,a4,1
    80004fa2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fa6:	0037f713          	andi	a4,a5,3
    80004faa:	00e03733          	snez	a4,a4
    80004fae:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004fb2:	4007f793          	andi	a5,a5,1024
    80004fb6:	c791                	beqz	a5,80004fc2 <sys_open+0xce>
    80004fb8:	04449703          	lh	a4,68(s1)
    80004fbc:	4789                	li	a5,2
    80004fbe:	0cf70763          	beq	a4,a5,8000508c <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	f9c080e7          	jalr	-100(ra) # 80002f60 <iunlock>
  end_op();
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	916080e7          	jalr	-1770(ra) # 800038e2 <end_op>

  return fd;
    80004fd4:	854e                	mv	a0,s3
    80004fd6:	74aa                	ld	s1,168(sp)
    80004fd8:	790a                	ld	s2,160(sp)
    80004fda:	69ea                	ld	s3,152(sp)
}
    80004fdc:	70ea                	ld	ra,184(sp)
    80004fde:	744a                	ld	s0,176(sp)
    80004fe0:	6129                	addi	sp,sp,192
    80004fe2:	8082                	ret
      end_op();
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	8fe080e7          	jalr	-1794(ra) # 800038e2 <end_op>
      return -1;
    80004fec:	557d                	li	a0,-1
    80004fee:	74aa                	ld	s1,168(sp)
    80004ff0:	b7f5                	j	80004fdc <sys_open+0xe8>
    if ((ip = namei(path)) == 0) {
    80004ff2:	f5040513          	addi	a0,s0,-176
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	672080e7          	jalr	1650(ra) # 80003668 <namei>
    80004ffe:	84aa                	mv	s1,a0
    80005000:	c90d                	beqz	a0,80005032 <sys_open+0x13e>
    ilock(ip);
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	e98080e7          	jalr	-360(ra) # 80002e9a <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000500a:	04449703          	lh	a4,68(s1)
    8000500e:	4785                	li	a5,1
    80005010:	f2f71fe3          	bne	a4,a5,80004f4e <sys_open+0x5a>
    80005014:	f4c42783          	lw	a5,-180(s0)
    80005018:	d7a9                	beqz	a5,80004f62 <sys_open+0x6e>
      iunlockput(ip);
    8000501a:	8526                	mv	a0,s1
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	0e4080e7          	jalr	228(ra) # 80003100 <iunlockput>
      end_op();
    80005024:	fffff097          	auipc	ra,0xfffff
    80005028:	8be080e7          	jalr	-1858(ra) # 800038e2 <end_op>
      return -1;
    8000502c:	557d                	li	a0,-1
    8000502e:	74aa                	ld	s1,168(sp)
    80005030:	b775                	j	80004fdc <sys_open+0xe8>
      end_op();
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	8b0080e7          	jalr	-1872(ra) # 800038e2 <end_op>
      return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	74aa                	ld	s1,168(sp)
    8000503e:	bf79                	j	80004fdc <sys_open+0xe8>
    iunlockput(ip);
    80005040:	8526                	mv	a0,s1
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	0be080e7          	jalr	190(ra) # 80003100 <iunlockput>
    end_op();
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	898080e7          	jalr	-1896(ra) # 800038e2 <end_op>
    return -1;
    80005052:	557d                	li	a0,-1
    80005054:	74aa                	ld	s1,168(sp)
    80005056:	b759                	j	80004fdc <sys_open+0xe8>
    if (f) fileclose(f);
    80005058:	854a                	mv	a0,s2
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	cd8080e7          	jalr	-808(ra) # 80003d32 <fileclose>
    80005062:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005064:	8526                	mv	a0,s1
    80005066:	ffffe097          	auipc	ra,0xffffe
    8000506a:	09a080e7          	jalr	154(ra) # 80003100 <iunlockput>
    end_op();
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	874080e7          	jalr	-1932(ra) # 800038e2 <end_op>
    return -1;
    80005076:	557d                	li	a0,-1
    80005078:	74aa                	ld	s1,168(sp)
    8000507a:	790a                	ld	s2,160(sp)
    8000507c:	b785                	j	80004fdc <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000507e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005082:	04649783          	lh	a5,70(s1)
    80005086:	02f91223          	sh	a5,36(s2)
    8000508a:	b729                	j	80004f94 <sys_open+0xa0>
    itrunc(ip);
    8000508c:	8526                	mv	a0,s1
    8000508e:	ffffe097          	auipc	ra,0xffffe
    80005092:	f1e080e7          	jalr	-226(ra) # 80002fac <itrunc>
    80005096:	b735                	j	80004fc2 <sys_open+0xce>

0000000080005098 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80005098:	7175                	addi	sp,sp,-144
    8000509a:	e506                	sd	ra,136(sp)
    8000509c:	e122                	sd	s0,128(sp)
    8000509e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800050a0:	ffffe097          	auipc	ra,0xffffe
    800050a4:	7c8080e7          	jalr	1992(ra) # 80003868 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    800050a8:	08000613          	li	a2,128
    800050ac:	f7040593          	addi	a1,s0,-144
    800050b0:	4501                	li	a0,0
    800050b2:	ffffd097          	auipc	ra,0xffffd
    800050b6:	290080e7          	jalr	656(ra) # 80002342 <argstr>
    800050ba:	02054963          	bltz	a0,800050ec <sys_mkdir+0x54>
    800050be:	4681                	li	a3,0
    800050c0:	4601                	li	a2,0
    800050c2:	4585                	li	a1,1
    800050c4:	f7040513          	addi	a0,s0,-144
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	7d6080e7          	jalr	2006(ra) # 8000489e <create>
    800050d0:	cd11                	beqz	a0,800050ec <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	02e080e7          	jalr	46(ra) # 80003100 <iunlockput>
  end_op();
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	808080e7          	jalr	-2040(ra) # 800038e2 <end_op>
  return 0;
    800050e2:	4501                	li	a0,0
}
    800050e4:	60aa                	ld	ra,136(sp)
    800050e6:	640a                	ld	s0,128(sp)
    800050e8:	6149                	addi	sp,sp,144
    800050ea:	8082                	ret
    end_op();
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	7f6080e7          	jalr	2038(ra) # 800038e2 <end_op>
    return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	b7fd                	j	800050e4 <sys_mkdir+0x4c>

00000000800050f8 <sys_mknod>:

uint64 sys_mknod(void) {
    800050f8:	7135                	addi	sp,sp,-160
    800050fa:	ed06                	sd	ra,152(sp)
    800050fc:	e922                	sd	s0,144(sp)
    800050fe:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	768080e7          	jalr	1896(ra) # 80003868 <begin_op>
  argint(1, &major);
    80005108:	f6c40593          	addi	a1,s0,-148
    8000510c:	4505                	li	a0,1
    8000510e:	ffffd097          	auipc	ra,0xffffd
    80005112:	1f4080e7          	jalr	500(ra) # 80002302 <argint>
  argint(2, &minor);
    80005116:	f6840593          	addi	a1,s0,-152
    8000511a:	4509                	li	a0,2
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	1e6080e7          	jalr	486(ra) # 80002302 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005124:	08000613          	li	a2,128
    80005128:	f7040593          	addi	a1,s0,-144
    8000512c:	4501                	li	a0,0
    8000512e:	ffffd097          	auipc	ra,0xffffd
    80005132:	214080e7          	jalr	532(ra) # 80002342 <argstr>
    80005136:	02054b63          	bltz	a0,8000516c <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    8000513a:	f6841683          	lh	a3,-152(s0)
    8000513e:	f6c41603          	lh	a2,-148(s0)
    80005142:	458d                	li	a1,3
    80005144:	f7040513          	addi	a0,s0,-144
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	756080e7          	jalr	1878(ra) # 8000489e <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005150:	cd11                	beqz	a0,8000516c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005152:	ffffe097          	auipc	ra,0xffffe
    80005156:	fae080e7          	jalr	-82(ra) # 80003100 <iunlockput>
  end_op();
    8000515a:	ffffe097          	auipc	ra,0xffffe
    8000515e:	788080e7          	jalr	1928(ra) # 800038e2 <end_op>
  return 0;
    80005162:	4501                	li	a0,0
}
    80005164:	60ea                	ld	ra,152(sp)
    80005166:	644a                	ld	s0,144(sp)
    80005168:	610d                	addi	sp,sp,160
    8000516a:	8082                	ret
    end_op();
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	776080e7          	jalr	1910(ra) # 800038e2 <end_op>
    return -1;
    80005174:	557d                	li	a0,-1
    80005176:	b7fd                	j	80005164 <sys_mknod+0x6c>

0000000080005178 <sys_chdir>:

uint64 sys_chdir(void) {
    80005178:	7135                	addi	sp,sp,-160
    8000517a:	ed06                	sd	ra,152(sp)
    8000517c:	e922                	sd	s0,144(sp)
    8000517e:	e14a                	sd	s2,128(sp)
    80005180:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005182:	ffffc097          	auipc	ra,0xffffc
    80005186:	f20080e7          	jalr	-224(ra) # 800010a2 <myproc>
    8000518a:	892a                	mv	s2,a0

  begin_op();
    8000518c:	ffffe097          	auipc	ra,0xffffe
    80005190:	6dc080e7          	jalr	1756(ra) # 80003868 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005194:	08000613          	li	a2,128
    80005198:	f6040593          	addi	a1,s0,-160
    8000519c:	4501                	li	a0,0
    8000519e:	ffffd097          	auipc	ra,0xffffd
    800051a2:	1a4080e7          	jalr	420(ra) # 80002342 <argstr>
    800051a6:	04054d63          	bltz	a0,80005200 <sys_chdir+0x88>
    800051aa:	e526                	sd	s1,136(sp)
    800051ac:	f6040513          	addi	a0,s0,-160
    800051b0:	ffffe097          	auipc	ra,0xffffe
    800051b4:	4b8080e7          	jalr	1208(ra) # 80003668 <namei>
    800051b8:	84aa                	mv	s1,a0
    800051ba:	c131                	beqz	a0,800051fe <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800051bc:	ffffe097          	auipc	ra,0xffffe
    800051c0:	cde080e7          	jalr	-802(ra) # 80002e9a <ilock>
  if (ip->type != T_DIR) {
    800051c4:	04449703          	lh	a4,68(s1)
    800051c8:	4785                	li	a5,1
    800051ca:	04f71163          	bne	a4,a5,8000520c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051ce:	8526                	mv	a0,s1
    800051d0:	ffffe097          	auipc	ra,0xffffe
    800051d4:	d90080e7          	jalr	-624(ra) # 80002f60 <iunlock>
  iput(p->cwd);
    800051d8:	15093503          	ld	a0,336(s2)
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	e7c080e7          	jalr	-388(ra) # 80003058 <iput>
  end_op();
    800051e4:	ffffe097          	auipc	ra,0xffffe
    800051e8:	6fe080e7          	jalr	1790(ra) # 800038e2 <end_op>
  p->cwd = ip;
    800051ec:	14993823          	sd	s1,336(s2)
  return 0;
    800051f0:	4501                	li	a0,0
    800051f2:	64aa                	ld	s1,136(sp)
}
    800051f4:	60ea                	ld	ra,152(sp)
    800051f6:	644a                	ld	s0,144(sp)
    800051f8:	690a                	ld	s2,128(sp)
    800051fa:	610d                	addi	sp,sp,160
    800051fc:	8082                	ret
    800051fe:	64aa                	ld	s1,136(sp)
    end_op();
    80005200:	ffffe097          	auipc	ra,0xffffe
    80005204:	6e2080e7          	jalr	1762(ra) # 800038e2 <end_op>
    return -1;
    80005208:	557d                	li	a0,-1
    8000520a:	b7ed                	j	800051f4 <sys_chdir+0x7c>
    iunlockput(ip);
    8000520c:	8526                	mv	a0,s1
    8000520e:	ffffe097          	auipc	ra,0xffffe
    80005212:	ef2080e7          	jalr	-270(ra) # 80003100 <iunlockput>
    end_op();
    80005216:	ffffe097          	auipc	ra,0xffffe
    8000521a:	6cc080e7          	jalr	1740(ra) # 800038e2 <end_op>
    return -1;
    8000521e:	557d                	li	a0,-1
    80005220:	64aa                	ld	s1,136(sp)
    80005222:	bfc9                	j	800051f4 <sys_chdir+0x7c>

0000000080005224 <sys_exec>:

uint64 sys_exec(void) {
    80005224:	7121                	addi	sp,sp,-448
    80005226:	ff06                	sd	ra,440(sp)
    80005228:	fb22                	sd	s0,432(sp)
    8000522a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000522c:	e4840593          	addi	a1,s0,-440
    80005230:	4505                	li	a0,1
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	0f0080e7          	jalr	240(ra) # 80002322 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000523a:	08000613          	li	a2,128
    8000523e:	f5040593          	addi	a1,s0,-176
    80005242:	4501                	li	a0,0
    80005244:	ffffd097          	auipc	ra,0xffffd
    80005248:	0fe080e7          	jalr	254(ra) # 80002342 <argstr>
    8000524c:	87aa                	mv	a5,a0
    return -1;
    8000524e:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005250:	0e07c263          	bltz	a5,80005334 <sys_exec+0x110>
    80005254:	f726                	sd	s1,424(sp)
    80005256:	f34a                	sd	s2,416(sp)
    80005258:	ef4e                	sd	s3,408(sp)
    8000525a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000525c:	10000613          	li	a2,256
    80005260:	4581                	li	a1,0
    80005262:	e5040513          	addi	a0,s0,-432
    80005266:	ffffb097          	auipc	ra,0xffffb
    8000526a:	fb8080e7          	jalr	-72(ra) # 8000021e <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    8000526e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005272:	89a6                	mv	s3,s1
    80005274:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80005276:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000527a:	00391513          	slli	a0,s2,0x3
    8000527e:	e4040593          	addi	a1,s0,-448
    80005282:	e4843783          	ld	a5,-440(s0)
    80005286:	953e                	add	a0,a0,a5
    80005288:	ffffd097          	auipc	ra,0xffffd
    8000528c:	fdc080e7          	jalr	-36(ra) # 80002264 <fetchaddr>
    80005290:	02054a63          	bltz	a0,800052c4 <sys_exec+0xa0>
      goto bad;
    }
    if (uarg == 0) {
    80005294:	e4043783          	ld	a5,-448(s0)
    80005298:	c7b9                	beqz	a5,800052e6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	f0a080e7          	jalr	-246(ra) # 800001a4 <kalloc>
    800052a2:	85aa                	mv	a1,a0
    800052a4:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    800052a8:	cd11                	beqz	a0,800052c4 <sys_exec+0xa0>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    800052aa:	6605                	lui	a2,0x1
    800052ac:	e4043503          	ld	a0,-448(s0)
    800052b0:	ffffd097          	auipc	ra,0xffffd
    800052b4:	006080e7          	jalr	6(ra) # 800022b6 <fetchstr>
    800052b8:	00054663          	bltz	a0,800052c4 <sys_exec+0xa0>
    if (i >= NELEM(argv)) {
    800052bc:	0905                	addi	s2,s2,1
    800052be:	09a1                	addi	s3,s3,8
    800052c0:	fb491de3          	bne	s2,s4,8000527a <sys_exec+0x56>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    800052c4:	f5040913          	addi	s2,s0,-176
    800052c8:	6088                	ld	a0,0(s1)
    800052ca:	c125                	beqz	a0,8000532a <sys_exec+0x106>
    800052cc:	ffffb097          	auipc	ra,0xffffb
    800052d0:	da2080e7          	jalr	-606(ra) # 8000006e <kfree>
    800052d4:	04a1                	addi	s1,s1,8
    800052d6:	ff2499e3          	bne	s1,s2,800052c8 <sys_exec+0xa4>
  return -1;
    800052da:	557d                	li	a0,-1
    800052dc:	74ba                	ld	s1,424(sp)
    800052de:	791a                	ld	s2,416(sp)
    800052e0:	69fa                	ld	s3,408(sp)
    800052e2:	6a5a                	ld	s4,400(sp)
    800052e4:	a881                	j	80005334 <sys_exec+0x110>
      argv[i] = 0;
    800052e6:	0009079b          	sext.w	a5,s2
    800052ea:	078e                	slli	a5,a5,0x3
    800052ec:	fd078793          	addi	a5,a5,-48
    800052f0:	97a2                	add	a5,a5,s0
    800052f2:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800052f6:	e5040593          	addi	a1,s0,-432
    800052fa:	f5040513          	addi	a0,s0,-176
    800052fe:	fffff097          	auipc	ra,0xfffff
    80005302:	10a080e7          	jalr	266(ra) # 80004408 <exec>
    80005306:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80005308:	f5040993          	addi	s3,s0,-176
    8000530c:	6088                	ld	a0,0(s1)
    8000530e:	c901                	beqz	a0,8000531e <sys_exec+0xfa>
    80005310:	ffffb097          	auipc	ra,0xffffb
    80005314:	d5e080e7          	jalr	-674(ra) # 8000006e <kfree>
    80005318:	04a1                	addi	s1,s1,8
    8000531a:	ff3499e3          	bne	s1,s3,8000530c <sys_exec+0xe8>
  return ret;
    8000531e:	854a                	mv	a0,s2
    80005320:	74ba                	ld	s1,424(sp)
    80005322:	791a                	ld	s2,416(sp)
    80005324:	69fa                	ld	s3,408(sp)
    80005326:	6a5a                	ld	s4,400(sp)
    80005328:	a031                	j	80005334 <sys_exec+0x110>
  return -1;
    8000532a:	557d                	li	a0,-1
    8000532c:	74ba                	ld	s1,424(sp)
    8000532e:	791a                	ld	s2,416(sp)
    80005330:	69fa                	ld	s3,408(sp)
    80005332:	6a5a                	ld	s4,400(sp)
}
    80005334:	70fa                	ld	ra,440(sp)
    80005336:	745a                	ld	s0,432(sp)
    80005338:	6139                	addi	sp,sp,448
    8000533a:	8082                	ret

000000008000533c <sys_pipe>:

uint64 sys_pipe(void) {
    8000533c:	7139                	addi	sp,sp,-64
    8000533e:	fc06                	sd	ra,56(sp)
    80005340:	f822                	sd	s0,48(sp)
    80005342:	f426                	sd	s1,40(sp)
    80005344:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	d5c080e7          	jalr	-676(ra) # 800010a2 <myproc>
    8000534e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005350:	fd840593          	addi	a1,s0,-40
    80005354:	4501                	li	a0,0
    80005356:	ffffd097          	auipc	ra,0xffffd
    8000535a:	fcc080e7          	jalr	-52(ra) # 80002322 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    8000535e:	fc840593          	addi	a1,s0,-56
    80005362:	fd040513          	addi	a0,s0,-48
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	d3a080e7          	jalr	-710(ra) # 800040a0 <pipealloc>
    8000536e:	57fd                	li	a5,-1
    80005370:	0c054463          	bltz	a0,80005438 <sys_pipe+0xfc>
  fd0 = -1;
    80005374:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005378:	fd043503          	ld	a0,-48(s0)
    8000537c:	fffff097          	auipc	ra,0xfffff
    80005380:	4e0080e7          	jalr	1248(ra) # 8000485c <fdalloc>
    80005384:	fca42223          	sw	a0,-60(s0)
    80005388:	08054b63          	bltz	a0,8000541e <sys_pipe+0xe2>
    8000538c:	fc843503          	ld	a0,-56(s0)
    80005390:	fffff097          	auipc	ra,0xfffff
    80005394:	4cc080e7          	jalr	1228(ra) # 8000485c <fdalloc>
    80005398:	fca42023          	sw	a0,-64(s0)
    8000539c:	06054863          	bltz	a0,8000540c <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053a0:	4691                	li	a3,4
    800053a2:	fc440613          	addi	a2,s0,-60
    800053a6:	fd843583          	ld	a1,-40(s0)
    800053aa:	68a8                	ld	a0,80(s1)
    800053ac:	ffffc097          	auipc	ra,0xffffc
    800053b0:	856080e7          	jalr	-1962(ra) # 80000c02 <copyout>
    800053b4:	02054063          	bltz	a0,800053d4 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800053b8:	4691                	li	a3,4
    800053ba:	fc040613          	addi	a2,s0,-64
    800053be:	fd843583          	ld	a1,-40(s0)
    800053c2:	0591                	addi	a1,a1,4
    800053c4:	68a8                	ld	a0,80(s1)
    800053c6:	ffffc097          	auipc	ra,0xffffc
    800053ca:	83c080e7          	jalr	-1988(ra) # 80000c02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053ce:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053d0:	06055463          	bgez	a0,80005438 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800053d4:	fc442783          	lw	a5,-60(s0)
    800053d8:	07e9                	addi	a5,a5,26
    800053da:	078e                	slli	a5,a5,0x3
    800053dc:	97a6                	add	a5,a5,s1
    800053de:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053e2:	fc042783          	lw	a5,-64(s0)
    800053e6:	07e9                	addi	a5,a5,26
    800053e8:	078e                	slli	a5,a5,0x3
    800053ea:	94be                	add	s1,s1,a5
    800053ec:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053f0:	fd043503          	ld	a0,-48(s0)
    800053f4:	fffff097          	auipc	ra,0xfffff
    800053f8:	93e080e7          	jalr	-1730(ra) # 80003d32 <fileclose>
    fileclose(wf);
    800053fc:	fc843503          	ld	a0,-56(s0)
    80005400:	fffff097          	auipc	ra,0xfffff
    80005404:	932080e7          	jalr	-1742(ra) # 80003d32 <fileclose>
    return -1;
    80005408:	57fd                	li	a5,-1
    8000540a:	a03d                	j	80005438 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    8000540c:	fc442783          	lw	a5,-60(s0)
    80005410:	0007c763          	bltz	a5,8000541e <sys_pipe+0xe2>
    80005414:	07e9                	addi	a5,a5,26
    80005416:	078e                	slli	a5,a5,0x3
    80005418:	97a6                	add	a5,a5,s1
    8000541a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000541e:	fd043503          	ld	a0,-48(s0)
    80005422:	fffff097          	auipc	ra,0xfffff
    80005426:	910080e7          	jalr	-1776(ra) # 80003d32 <fileclose>
    fileclose(wf);
    8000542a:	fc843503          	ld	a0,-56(s0)
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	904080e7          	jalr	-1788(ra) # 80003d32 <fileclose>
    return -1;
    80005436:	57fd                	li	a5,-1
}
    80005438:	853e                	mv	a0,a5
    8000543a:	70e2                	ld	ra,56(sp)
    8000543c:	7442                	ld	s0,48(sp)
    8000543e:	74a2                	ld	s1,40(sp)
    80005440:	6121                	addi	sp,sp,64
    80005442:	8082                	ret
	...

0000000080005450 <kernelvec>:
    80005450:	7111                	addi	sp,sp,-256
    80005452:	e006                	sd	ra,0(sp)
    80005454:	e40a                	sd	sp,8(sp)
    80005456:	e80e                	sd	gp,16(sp)
    80005458:	ec12                	sd	tp,24(sp)
    8000545a:	f016                	sd	t0,32(sp)
    8000545c:	f41a                	sd	t1,40(sp)
    8000545e:	f81e                	sd	t2,48(sp)
    80005460:	fc22                	sd	s0,56(sp)
    80005462:	e0a6                	sd	s1,64(sp)
    80005464:	e4aa                	sd	a0,72(sp)
    80005466:	e8ae                	sd	a1,80(sp)
    80005468:	ecb2                	sd	a2,88(sp)
    8000546a:	f0b6                	sd	a3,96(sp)
    8000546c:	f4ba                	sd	a4,104(sp)
    8000546e:	f8be                	sd	a5,112(sp)
    80005470:	fcc2                	sd	a6,120(sp)
    80005472:	e146                	sd	a7,128(sp)
    80005474:	e54a                	sd	s2,136(sp)
    80005476:	e94e                	sd	s3,144(sp)
    80005478:	ed52                	sd	s4,152(sp)
    8000547a:	f156                	sd	s5,160(sp)
    8000547c:	f55a                	sd	s6,168(sp)
    8000547e:	f95e                	sd	s7,176(sp)
    80005480:	fd62                	sd	s8,184(sp)
    80005482:	e1e6                	sd	s9,192(sp)
    80005484:	e5ea                	sd	s10,200(sp)
    80005486:	e9ee                	sd	s11,208(sp)
    80005488:	edf2                	sd	t3,216(sp)
    8000548a:	f1f6                	sd	t4,224(sp)
    8000548c:	f5fa                	sd	t5,232(sp)
    8000548e:	f9fe                	sd	t6,240(sp)
    80005490:	ca1fc0ef          	jal	80002130 <kerneltrap>
    80005494:	6082                	ld	ra,0(sp)
    80005496:	6122                	ld	sp,8(sp)
    80005498:	61c2                	ld	gp,16(sp)
    8000549a:	7282                	ld	t0,32(sp)
    8000549c:	7322                	ld	t1,40(sp)
    8000549e:	73c2                	ld	t2,48(sp)
    800054a0:	7462                	ld	s0,56(sp)
    800054a2:	6486                	ld	s1,64(sp)
    800054a4:	6526                	ld	a0,72(sp)
    800054a6:	65c6                	ld	a1,80(sp)
    800054a8:	6666                	ld	a2,88(sp)
    800054aa:	7686                	ld	a3,96(sp)
    800054ac:	7726                	ld	a4,104(sp)
    800054ae:	77c6                	ld	a5,112(sp)
    800054b0:	7866                	ld	a6,120(sp)
    800054b2:	688a                	ld	a7,128(sp)
    800054b4:	692a                	ld	s2,136(sp)
    800054b6:	69ca                	ld	s3,144(sp)
    800054b8:	6a6a                	ld	s4,152(sp)
    800054ba:	7a8a                	ld	s5,160(sp)
    800054bc:	7b2a                	ld	s6,168(sp)
    800054be:	7bca                	ld	s7,176(sp)
    800054c0:	7c6a                	ld	s8,184(sp)
    800054c2:	6c8e                	ld	s9,192(sp)
    800054c4:	6d2e                	ld	s10,200(sp)
    800054c6:	6dce                	ld	s11,208(sp)
    800054c8:	6e6e                	ld	t3,216(sp)
    800054ca:	7e8e                	ld	t4,224(sp)
    800054cc:	7f2e                	ld	t5,232(sp)
    800054ce:	7fce                	ld	t6,240(sp)
    800054d0:	6111                	addi	sp,sp,256
    800054d2:	10200073          	sret
    800054d6:	00000013          	nop
    800054da:	00000013          	nop
    800054de:	0001                	nop

00000000800054e0 <timervec>:
    800054e0:	34051573          	csrrw	a0,mscratch,a0
    800054e4:	e10c                	sd	a1,0(a0)
    800054e6:	e510                	sd	a2,8(a0)
    800054e8:	e914                	sd	a3,16(a0)
    800054ea:	6d0c                	ld	a1,24(a0)
    800054ec:	7110                	ld	a2,32(a0)
    800054ee:	6194                	ld	a3,0(a1)
    800054f0:	96b2                	add	a3,a3,a2
    800054f2:	e194                	sd	a3,0(a1)
    800054f4:	4589                	li	a1,2
    800054f6:	14459073          	csrw	sip,a1
    800054fa:	6914                	ld	a3,16(a0)
    800054fc:	6510                	ld	a2,8(a0)
    800054fe:	610c                	ld	a1,0(a0)
    80005500:	34051573          	csrrw	a0,mscratch,a0
    80005504:	30200073          	mret
	...

000000008000550a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e422                	sd	s0,8(sp)
    8000550e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80005510:	0c0007b7          	lui	a5,0xc000
    80005514:	4705                	li	a4,1
    80005516:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005518:	0c0007b7          	lui	a5,0xc000
    8000551c:	c3d8                	sw	a4,4(a5)
}
    8000551e:	6422                	ld	s0,8(sp)
    80005520:	0141                	addi	sp,sp,16
    80005522:	8082                	ret

0000000080005524 <plicinithart>:

void plicinithart(void) {
    80005524:	1141                	addi	sp,sp,-16
    80005526:	e406                	sd	ra,8(sp)
    80005528:	e022                	sd	s0,0(sp)
    8000552a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000552c:	ffffc097          	auipc	ra,0xffffc
    80005530:	b4a080e7          	jalr	-1206(ra) # 80001076 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005534:	0085171b          	slliw	a4,a0,0x8
    80005538:	0c0027b7          	lui	a5,0xc002
    8000553c:	97ba                	add	a5,a5,a4
    8000553e:	40200713          	li	a4,1026
    80005542:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005546:	00d5151b          	slliw	a0,a0,0xd
    8000554a:	0c2017b7          	lui	a5,0xc201
    8000554e:	97aa                	add	a5,a5,a0
    80005550:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005554:	60a2                	ld	ra,8(sp)
    80005556:	6402                	ld	s0,0(sp)
    80005558:	0141                	addi	sp,sp,16
    8000555a:	8082                	ret

000000008000555c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    8000555c:	1141                	addi	sp,sp,-16
    8000555e:	e406                	sd	ra,8(sp)
    80005560:	e022                	sd	s0,0(sp)
    80005562:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	b12080e7          	jalr	-1262(ra) # 80001076 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000556c:	00d5151b          	slliw	a0,a0,0xd
    80005570:	0c2017b7          	lui	a5,0xc201
    80005574:	97aa                	add	a5,a5,a0
  return irq;
}
    80005576:	43c8                	lw	a0,4(a5)
    80005578:	60a2                	ld	ra,8(sp)
    8000557a:	6402                	ld	s0,0(sp)
    8000557c:	0141                	addi	sp,sp,16
    8000557e:	8082                	ret

0000000080005580 <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    80005580:	1101                	addi	sp,sp,-32
    80005582:	ec06                	sd	ra,24(sp)
    80005584:	e822                	sd	s0,16(sp)
    80005586:	e426                	sd	s1,8(sp)
    80005588:	1000                	addi	s0,sp,32
    8000558a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000558c:	ffffc097          	auipc	ra,0xffffc
    80005590:	aea080e7          	jalr	-1302(ra) # 80001076 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005594:	00d5151b          	slliw	a0,a0,0xd
    80005598:	0c2017b7          	lui	a5,0xc201
    8000559c:	97aa                	add	a5,a5,a0
    8000559e:	c3c4                	sw	s1,4(a5)
}
    800055a0:	60e2                	ld	ra,24(sp)
    800055a2:	6442                	ld	s0,16(sp)
    800055a4:	64a2                	ld	s1,8(sp)
    800055a6:	6105                	addi	sp,sp,32
    800055a8:	8082                	ret

00000000800055aa <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    800055aa:	1141                	addi	sp,sp,-16
    800055ac:	e406                	sd	ra,8(sp)
    800055ae:	e022                	sd	s0,0(sp)
    800055b0:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    800055b2:	479d                	li	a5,7
    800055b4:	04a7cc63          	blt	a5,a0,8000560c <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    800055b8:	00037797          	auipc	a5,0x37
    800055bc:	ee078793          	addi	a5,a5,-288 # 8003c498 <disk>
    800055c0:	97aa                	add	a5,a5,a0
    800055c2:	0187c783          	lbu	a5,24(a5)
    800055c6:	ebb9                	bnez	a5,8000561c <free_desc+0x72>
  disk.desc[i].addr = 0;
    800055c8:	00451693          	slli	a3,a0,0x4
    800055cc:	00037797          	auipc	a5,0x37
    800055d0:	ecc78793          	addi	a5,a5,-308 # 8003c498 <disk>
    800055d4:	6398                	ld	a4,0(a5)
    800055d6:	9736                	add	a4,a4,a3
    800055d8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800055dc:	6398                	ld	a4,0(a5)
    800055de:	9736                	add	a4,a4,a3
    800055e0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800055e4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055e8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055ec:	97aa                	add	a5,a5,a0
    800055ee:	4705                	li	a4,1
    800055f0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800055f4:	00037517          	auipc	a0,0x37
    800055f8:	ebc50513          	addi	a0,a0,-324 # 8003c4b0 <disk+0x18>
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	1b8080e7          	jalr	440(ra) # 800017b4 <wakeup>
}
    80005604:	60a2                	ld	ra,8(sp)
    80005606:	6402                	ld	s0,0(sp)
    80005608:	0141                	addi	sp,sp,16
    8000560a:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    8000560c:	00003517          	auipc	a0,0x3
    80005610:	03450513          	addi	a0,a0,52 # 80008640 <etext+0x640>
    80005614:	00001097          	auipc	ra,0x1
    80005618:	a6e080e7          	jalr	-1426(ra) # 80006082 <panic>
  if (disk.free[i]) panic("free_desc 2");
    8000561c:	00003517          	auipc	a0,0x3
    80005620:	03450513          	addi	a0,a0,52 # 80008650 <etext+0x650>
    80005624:	00001097          	auipc	ra,0x1
    80005628:	a5e080e7          	jalr	-1442(ra) # 80006082 <panic>

000000008000562c <virtio_disk_init>:
void virtio_disk_init(void) {
    8000562c:	1101                	addi	sp,sp,-32
    8000562e:	ec06                	sd	ra,24(sp)
    80005630:	e822                	sd	s0,16(sp)
    80005632:	e426                	sd	s1,8(sp)
    80005634:	e04a                	sd	s2,0(sp)
    80005636:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005638:	00003597          	auipc	a1,0x3
    8000563c:	02858593          	addi	a1,a1,40 # 80008660 <etext+0x660>
    80005640:	00037517          	auipc	a0,0x37
    80005644:	f8050513          	addi	a0,a0,-128 # 8003c5c0 <disk+0x128>
    80005648:	00001097          	auipc	ra,0x1
    8000564c:	f24080e7          	jalr	-220(ra) # 8000656c <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005650:	100017b7          	lui	a5,0x10001
    80005654:	4398                	lw	a4,0(a5)
    80005656:	2701                	sext.w	a4,a4
    80005658:	747277b7          	lui	a5,0x74727
    8000565c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005660:	18f71c63          	bne	a4,a5,800057f8 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005664:	100017b7          	lui	a5,0x10001
    80005668:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000566a:	439c                	lw	a5,0(a5)
    8000566c:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000566e:	4709                	li	a4,2
    80005670:	18e79463          	bne	a5,a4,800057f8 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005674:	100017b7          	lui	a5,0x10001
    80005678:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000567a:	439c                	lw	a5,0(a5)
    8000567c:	2781                	sext.w	a5,a5
    8000567e:	16e79d63          	bne	a5,a4,800057f8 <virtio_disk_init+0x1cc>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005682:	100017b7          	lui	a5,0x10001
    80005686:	47d8                	lw	a4,12(a5)
    80005688:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000568a:	554d47b7          	lui	a5,0x554d4
    8000568e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005692:	16f71363          	bne	a4,a5,800057f8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005696:	100017b7          	lui	a5,0x10001
    8000569a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000569e:	4705                	li	a4,1
    800056a0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056a2:	470d                	li	a4,3
    800056a4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056a6:	10001737          	lui	a4,0x10001
    800056aa:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056ac:	c7ffe737          	lui	a4,0xc7ffe
    800056b0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb9f3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056b4:	8ef9                	and	a3,a3,a4
    800056b6:	10001737          	lui	a4,0x10001
    800056ba:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056bc:	472d                	li	a4,11
    800056be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056c0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800056c4:	439c                	lw	a5,0(a5)
    800056c6:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800056ca:	8ba1                	andi	a5,a5,8
    800056cc:	12078e63          	beqz	a5,80005808 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056d0:	100017b7          	lui	a5,0x10001
    800056d4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800056d8:	100017b7          	lui	a5,0x10001
    800056dc:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800056e0:	439c                	lw	a5,0(a5)
    800056e2:	2781                	sext.w	a5,a5
    800056e4:	12079a63          	bnez	a5,80005818 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056e8:	100017b7          	lui	a5,0x10001
    800056ec:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800056f0:	439c                	lw	a5,0(a5)
    800056f2:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    800056f4:	12078a63          	beqz	a5,80005828 <virtio_disk_init+0x1fc>
  if (max < NUM) panic("virtio disk max queue too short");
    800056f8:	471d                	li	a4,7
    800056fa:	12f77f63          	bgeu	a4,a5,80005838 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800056fe:	ffffb097          	auipc	ra,0xffffb
    80005702:	aa6080e7          	jalr	-1370(ra) # 800001a4 <kalloc>
    80005706:	00037497          	auipc	s1,0x37
    8000570a:	d9248493          	addi	s1,s1,-622 # 8003c498 <disk>
    8000570e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005710:	ffffb097          	auipc	ra,0xffffb
    80005714:	a94080e7          	jalr	-1388(ra) # 800001a4 <kalloc>
    80005718:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000571a:	ffffb097          	auipc	ra,0xffffb
    8000571e:	a8a080e7          	jalr	-1398(ra) # 800001a4 <kalloc>
    80005722:	87aa                	mv	a5,a0
    80005724:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005726:	6088                	ld	a0,0(s1)
    80005728:	12050063          	beqz	a0,80005848 <virtio_disk_init+0x21c>
    8000572c:	00037717          	auipc	a4,0x37
    80005730:	d7473703          	ld	a4,-652(a4) # 8003c4a0 <disk+0x8>
    80005734:	10070a63          	beqz	a4,80005848 <virtio_disk_init+0x21c>
    80005738:	10078863          	beqz	a5,80005848 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000573c:	6605                	lui	a2,0x1
    8000573e:	4581                	li	a1,0
    80005740:	ffffb097          	auipc	ra,0xffffb
    80005744:	ade080e7          	jalr	-1314(ra) # 8000021e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005748:	00037497          	auipc	s1,0x37
    8000574c:	d5048493          	addi	s1,s1,-688 # 8003c498 <disk>
    80005750:	6605                	lui	a2,0x1
    80005752:	4581                	li	a1,0
    80005754:	6488                	ld	a0,8(s1)
    80005756:	ffffb097          	auipc	ra,0xffffb
    8000575a:	ac8080e7          	jalr	-1336(ra) # 8000021e <memset>
  memset(disk.used, 0, PGSIZE);
    8000575e:	6605                	lui	a2,0x1
    80005760:	4581                	li	a1,0
    80005762:	6888                	ld	a0,16(s1)
    80005764:	ffffb097          	auipc	ra,0xffffb
    80005768:	aba080e7          	jalr	-1350(ra) # 8000021e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000576c:	100017b7          	lui	a5,0x10001
    80005770:	4721                	li	a4,8
    80005772:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005774:	4098                	lw	a4,0(s1)
    80005776:	100017b7          	lui	a5,0x10001
    8000577a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000577e:	40d8                	lw	a4,4(s1)
    80005780:	100017b7          	lui	a5,0x10001
    80005784:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005788:	649c                	ld	a5,8(s1)
    8000578a:	0007869b          	sext.w	a3,a5
    8000578e:	10001737          	lui	a4,0x10001
    80005792:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005796:	9781                	srai	a5,a5,0x20
    80005798:	10001737          	lui	a4,0x10001
    8000579c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057a0:	689c                	ld	a5,16(s1)
    800057a2:	0007869b          	sext.w	a3,a5
    800057a6:	10001737          	lui	a4,0x10001
    800057aa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800057ae:	9781                	srai	a5,a5,0x20
    800057b0:	10001737          	lui	a4,0x10001
    800057b4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800057b8:	10001737          	lui	a4,0x10001
    800057bc:	4785                	li	a5,1
    800057be:	c37c                	sw	a5,68(a4)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    800057c0:	00f48c23          	sb	a5,24(s1)
    800057c4:	00f48ca3          	sb	a5,25(s1)
    800057c8:	00f48d23          	sb	a5,26(s1)
    800057cc:	00f48da3          	sb	a5,27(s1)
    800057d0:	00f48e23          	sb	a5,28(s1)
    800057d4:	00f48ea3          	sb	a5,29(s1)
    800057d8:	00f48f23          	sb	a5,30(s1)
    800057dc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800057e0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e4:	100017b7          	lui	a5,0x10001
    800057e8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800057ec:	60e2                	ld	ra,24(sp)
    800057ee:	6442                	ld	s0,16(sp)
    800057f0:	64a2                	ld	s1,8(sp)
    800057f2:	6902                	ld	s2,0(sp)
    800057f4:	6105                	addi	sp,sp,32
    800057f6:	8082                	ret
    panic("could not find virtio disk");
    800057f8:	00003517          	auipc	a0,0x3
    800057fc:	e7850513          	addi	a0,a0,-392 # 80008670 <etext+0x670>
    80005800:	00001097          	auipc	ra,0x1
    80005804:	882080e7          	jalr	-1918(ra) # 80006082 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005808:	00003517          	auipc	a0,0x3
    8000580c:	e8850513          	addi	a0,a0,-376 # 80008690 <etext+0x690>
    80005810:	00001097          	auipc	ra,0x1
    80005814:	872080e7          	jalr	-1934(ra) # 80006082 <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005818:	00003517          	auipc	a0,0x3
    8000581c:	e9850513          	addi	a0,a0,-360 # 800086b0 <etext+0x6b0>
    80005820:	00001097          	auipc	ra,0x1
    80005824:	862080e7          	jalr	-1950(ra) # 80006082 <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    80005828:	00003517          	auipc	a0,0x3
    8000582c:	ea850513          	addi	a0,a0,-344 # 800086d0 <etext+0x6d0>
    80005830:	00001097          	auipc	ra,0x1
    80005834:	852080e7          	jalr	-1966(ra) # 80006082 <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    80005838:	00003517          	auipc	a0,0x3
    8000583c:	eb850513          	addi	a0,a0,-328 # 800086f0 <etext+0x6f0>
    80005840:	00001097          	auipc	ra,0x1
    80005844:	842080e7          	jalr	-1982(ra) # 80006082 <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005848:	00003517          	auipc	a0,0x3
    8000584c:	ec850513          	addi	a0,a0,-312 # 80008710 <etext+0x710>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	832080e7          	jalr	-1998(ra) # 80006082 <panic>

0000000080005858 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    80005858:	7159                	addi	sp,sp,-112
    8000585a:	f486                	sd	ra,104(sp)
    8000585c:	f0a2                	sd	s0,96(sp)
    8000585e:	eca6                	sd	s1,88(sp)
    80005860:	e8ca                	sd	s2,80(sp)
    80005862:	e4ce                	sd	s3,72(sp)
    80005864:	e0d2                	sd	s4,64(sp)
    80005866:	fc56                	sd	s5,56(sp)
    80005868:	f85a                	sd	s6,48(sp)
    8000586a:	f45e                	sd	s7,40(sp)
    8000586c:	f062                	sd	s8,32(sp)
    8000586e:	ec66                	sd	s9,24(sp)
    80005870:	1880                	addi	s0,sp,112
    80005872:	8a2a                	mv	s4,a0
    80005874:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005876:	00c52c83          	lw	s9,12(a0)
    8000587a:	001c9c9b          	slliw	s9,s9,0x1
    8000587e:	1c82                	slli	s9,s9,0x20
    80005880:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005884:	00037517          	auipc	a0,0x37
    80005888:	d3c50513          	addi	a0,a0,-708 # 8003c5c0 <disk+0x128>
    8000588c:	00001097          	auipc	ra,0x1
    80005890:	d70080e7          	jalr	-656(ra) # 800065fc <acquire>
  for (int i = 0; i < 3; i++) {
    80005894:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005896:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005898:	00037b17          	auipc	s6,0x37
    8000589c:	c00b0b13          	addi	s6,s6,-1024 # 8003c498 <disk>
  for (int i = 0; i < 3; i++) {
    800058a0:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058a2:	00037c17          	auipc	s8,0x37
    800058a6:	d1ec0c13          	addi	s8,s8,-738 # 8003c5c0 <disk+0x128>
    800058aa:	a0ad                	j	80005914 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800058ac:	00fb0733          	add	a4,s6,a5
    800058b0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800058b4:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800058b6:	0207c563          	bltz	a5,800058e0 <virtio_disk_rw+0x88>
  for (int i = 0; i < 3; i++) {
    800058ba:	2905                	addiw	s2,s2,1
    800058bc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058be:	05590f63          	beq	s2,s5,8000591c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800058c2:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800058c4:	00037717          	auipc	a4,0x37
    800058c8:	bd470713          	addi	a4,a4,-1068 # 8003c498 <disk>
    800058cc:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    800058ce:	01874683          	lbu	a3,24(a4)
    800058d2:	fee9                	bnez	a3,800058ac <virtio_disk_rw+0x54>
  for (int i = 0; i < NUM; i++) {
    800058d4:	2785                	addiw	a5,a5,1
    800058d6:	0705                	addi	a4,a4,1
    800058d8:	fe979be3          	bne	a5,s1,800058ce <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800058dc:	57fd                	li	a5,-1
    800058de:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    800058e0:	03205163          	blez	s2,80005902 <virtio_disk_rw+0xaa>
    800058e4:	f9042503          	lw	a0,-112(s0)
    800058e8:	00000097          	auipc	ra,0x0
    800058ec:	cc2080e7          	jalr	-830(ra) # 800055aa <free_desc>
    800058f0:	4785                	li	a5,1
    800058f2:	0127d863          	bge	a5,s2,80005902 <virtio_disk_rw+0xaa>
    800058f6:	f9442503          	lw	a0,-108(s0)
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	cb0080e7          	jalr	-848(ra) # 800055aa <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005902:	85e2                	mv	a1,s8
    80005904:	00037517          	auipc	a0,0x37
    80005908:	bac50513          	addi	a0,a0,-1108 # 8003c4b0 <disk+0x18>
    8000590c:	ffffc097          	auipc	ra,0xffffc
    80005910:	e44080e7          	jalr	-444(ra) # 80001750 <sleep>
  for (int i = 0; i < 3; i++) {
    80005914:	f9040613          	addi	a2,s0,-112
    80005918:	894e                	mv	s2,s3
    8000591a:	b765                	j	800058c2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000591c:	f9042503          	lw	a0,-112(s0)
    80005920:	00451693          	slli	a3,a0,0x4

  if (write)
    80005924:	00037797          	auipc	a5,0x37
    80005928:	b7478793          	addi	a5,a5,-1164 # 8003c498 <disk>
    8000592c:	00a50713          	addi	a4,a0,10
    80005930:	0712                	slli	a4,a4,0x4
    80005932:	973e                	add	a4,a4,a5
    80005934:	01703633          	snez	a2,s7
    80005938:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    8000593a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000593e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005942:	6398                	ld	a4,0(a5)
    80005944:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005946:	0a868613          	addi	a2,a3,168
    8000594a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    8000594c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000594e:	6390                	ld	a2,0(a5)
    80005950:	00d605b3          	add	a1,a2,a3
    80005954:	4741                	li	a4,16
    80005956:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005958:	4805                	li	a6,1
    8000595a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000595e:	f9442703          	lw	a4,-108(s0)
    80005962:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005966:	0712                	slli	a4,a4,0x4
    80005968:	963a                	add	a2,a2,a4
    8000596a:	058a0593          	addi	a1,s4,88
    8000596e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005970:	0007b883          	ld	a7,0(a5)
    80005974:	9746                	add	a4,a4,a7
    80005976:	40000613          	li	a2,1024
    8000597a:	c710                	sw	a2,8(a4)
  if (write)
    8000597c:	001bb613          	seqz	a2,s7
    80005980:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005984:	00166613          	ori	a2,a2,1
    80005988:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000598c:	f9842583          	lw	a1,-104(s0)
    80005990:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80005994:	00250613          	addi	a2,a0,2
    80005998:	0612                	slli	a2,a2,0x4
    8000599a:	963e                	add	a2,a2,a5
    8000599c:	577d                	li	a4,-1
    8000599e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800059a2:	0592                	slli	a1,a1,0x4
    800059a4:	98ae                	add	a7,a7,a1
    800059a6:	03068713          	addi	a4,a3,48
    800059aa:	973e                	add	a4,a4,a5
    800059ac:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059b0:	6398                	ld	a4,0(a5)
    800059b2:	972e                	add	a4,a4,a1
    800059b4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    800059b8:	4689                	li	a3,2
    800059ba:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059be:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059c2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800059c6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059ca:	6794                	ld	a3,8(a5)
    800059cc:	0026d703          	lhu	a4,2(a3)
    800059d0:	8b1d                	andi	a4,a4,7
    800059d2:	0706                	slli	a4,a4,0x1
    800059d4:	96ba                	add	a3,a3,a4
    800059d6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800059da:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    800059de:	6798                	ld	a4,8(a5)
    800059e0:	00275783          	lhu	a5,2(a4)
    800059e4:	2785                	addiw	a5,a5,1
    800059e6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059ea:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    800059ee:	100017b7          	lui	a5,0x10001
    800059f2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800059f6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800059fa:	00037917          	auipc	s2,0x37
    800059fe:	bc690913          	addi	s2,s2,-1082 # 8003c5c0 <disk+0x128>
  while (b->disk == 1) {
    80005a02:	4485                	li	s1,1
    80005a04:	01079c63          	bne	a5,a6,80005a1c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005a08:	85ca                	mv	a1,s2
    80005a0a:	8552                	mv	a0,s4
    80005a0c:	ffffc097          	auipc	ra,0xffffc
    80005a10:	d44080e7          	jalr	-700(ra) # 80001750 <sleep>
  while (b->disk == 1) {
    80005a14:	004a2783          	lw	a5,4(s4)
    80005a18:	fe9788e3          	beq	a5,s1,80005a08 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005a1c:	f9042903          	lw	s2,-112(s0)
    80005a20:	00290713          	addi	a4,s2,2
    80005a24:	0712                	slli	a4,a4,0x4
    80005a26:	00037797          	auipc	a5,0x37
    80005a2a:	a7278793          	addi	a5,a5,-1422 # 8003c498 <disk>
    80005a2e:	97ba                	add	a5,a5,a4
    80005a30:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a34:	00037997          	auipc	s3,0x37
    80005a38:	a6498993          	addi	s3,s3,-1436 # 8003c498 <disk>
    80005a3c:	00491713          	slli	a4,s2,0x4
    80005a40:	0009b783          	ld	a5,0(s3)
    80005a44:	97ba                	add	a5,a5,a4
    80005a46:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a4a:	854a                	mv	a0,s2
    80005a4c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	b5a080e7          	jalr	-1190(ra) # 800055aa <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005a58:	8885                	andi	s1,s1,1
    80005a5a:	f0ed                	bnez	s1,80005a3c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a5c:	00037517          	auipc	a0,0x37
    80005a60:	b6450513          	addi	a0,a0,-1180 # 8003c5c0 <disk+0x128>
    80005a64:	00001097          	auipc	ra,0x1
    80005a68:	c4c080e7          	jalr	-948(ra) # 800066b0 <release>
}
    80005a6c:	70a6                	ld	ra,104(sp)
    80005a6e:	7406                	ld	s0,96(sp)
    80005a70:	64e6                	ld	s1,88(sp)
    80005a72:	6946                	ld	s2,80(sp)
    80005a74:	69a6                	ld	s3,72(sp)
    80005a76:	6a06                	ld	s4,64(sp)
    80005a78:	7ae2                	ld	s5,56(sp)
    80005a7a:	7b42                	ld	s6,48(sp)
    80005a7c:	7ba2                	ld	s7,40(sp)
    80005a7e:	7c02                	ld	s8,32(sp)
    80005a80:	6ce2                	ld	s9,24(sp)
    80005a82:	6165                	addi	sp,sp,112
    80005a84:	8082                	ret

0000000080005a86 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005a86:	1101                	addi	sp,sp,-32
    80005a88:	ec06                	sd	ra,24(sp)
    80005a8a:	e822                	sd	s0,16(sp)
    80005a8c:	e426                	sd	s1,8(sp)
    80005a8e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a90:	00037497          	auipc	s1,0x37
    80005a94:	a0848493          	addi	s1,s1,-1528 # 8003c498 <disk>
    80005a98:	00037517          	auipc	a0,0x37
    80005a9c:	b2850513          	addi	a0,a0,-1240 # 8003c5c0 <disk+0x128>
    80005aa0:	00001097          	auipc	ra,0x1
    80005aa4:	b5c080e7          	jalr	-1188(ra) # 800065fc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005aa8:	100017b7          	lui	a5,0x10001
    80005aac:	53b8                	lw	a4,96(a5)
    80005aae:	8b0d                	andi	a4,a4,3
    80005ab0:	100017b7          	lui	a5,0x10001
    80005ab4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005ab6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005aba:	689c                	ld	a5,16(s1)
    80005abc:	0204d703          	lhu	a4,32(s1)
    80005ac0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ac4:	04f70863          	beq	a4,a5,80005b14 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005ac8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005acc:	6898                	ld	a4,16(s1)
    80005ace:	0204d783          	lhu	a5,32(s1)
    80005ad2:	8b9d                	andi	a5,a5,7
    80005ad4:	078e                	slli	a5,a5,0x3
    80005ad6:	97ba                	add	a5,a5,a4
    80005ad8:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005ada:	00278713          	addi	a4,a5,2
    80005ade:	0712                	slli	a4,a4,0x4
    80005ae0:	9726                	add	a4,a4,s1
    80005ae2:	01074703          	lbu	a4,16(a4)
    80005ae6:	e721                	bnez	a4,80005b2e <virtio_disk_intr+0xa8>

    struct buf *b = disk.info[id].b;
    80005ae8:	0789                	addi	a5,a5,2
    80005aea:	0792                	slli	a5,a5,0x4
    80005aec:	97a6                	add	a5,a5,s1
    80005aee:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    80005af0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005af4:	ffffc097          	auipc	ra,0xffffc
    80005af8:	cc0080e7          	jalr	-832(ra) # 800017b4 <wakeup>

    disk.used_idx += 1;
    80005afc:	0204d783          	lhu	a5,32(s1)
    80005b00:	2785                	addiw	a5,a5,1
    80005b02:	17c2                	slli	a5,a5,0x30
    80005b04:	93c1                	srli	a5,a5,0x30
    80005b06:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005b0a:	6898                	ld	a4,16(s1)
    80005b0c:	00275703          	lhu	a4,2(a4)
    80005b10:	faf71ce3          	bne	a4,a5,80005ac8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005b14:	00037517          	auipc	a0,0x37
    80005b18:	aac50513          	addi	a0,a0,-1364 # 8003c5c0 <disk+0x128>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	b94080e7          	jalr	-1132(ra) # 800066b0 <release>
}
    80005b24:	60e2                	ld	ra,24(sp)
    80005b26:	6442                	ld	s0,16(sp)
    80005b28:	64a2                	ld	s1,8(sp)
    80005b2a:	6105                	addi	sp,sp,32
    80005b2c:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005b2e:	00003517          	auipc	a0,0x3
    80005b32:	bfa50513          	addi	a0,a0,-1030 # 80008728 <etext+0x728>
    80005b36:	00000097          	auipc	ra,0x0
    80005b3a:	54c080e7          	jalr	1356(ra) # 80006082 <panic>

0000000080005b3e <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    80005b3e:	1141                	addi	sp,sp,-16
    80005b40:	e422                	sd	s0,8(sp)
    80005b42:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005b44:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b48:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80005b4c:	0037979b          	slliw	a5,a5,0x3
    80005b50:	02004737          	lui	a4,0x2004
    80005b54:	97ba                	add	a5,a5,a4
    80005b56:	0200c737          	lui	a4,0x200c
    80005b5a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005b5c:	6318                	ld	a4,0(a4)
    80005b5e:	000f4637          	lui	a2,0xf4
    80005b62:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b66:	9732                	add	a4,a4,a2
    80005b68:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b6a:	00259693          	slli	a3,a1,0x2
    80005b6e:	96ae                	add	a3,a3,a1
    80005b70:	068e                	slli	a3,a3,0x3
    80005b72:	00037717          	auipc	a4,0x37
    80005b76:	a6e70713          	addi	a4,a4,-1426 # 8003c5e0 <timer_scratch>
    80005b7a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b7c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b7e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80005b80:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80005b84:	00000797          	auipc	a5,0x0
    80005b88:	95c78793          	addi	a5,a5,-1700 # 800054e0 <timervec>
    80005b8c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005b90:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b94:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005b98:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005b9c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ba0:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80005ba4:	30479073          	csrw	mie,a5
}
    80005ba8:	6422                	ld	s0,8(sp)
    80005baa:	0141                	addi	sp,sp,16
    80005bac:	8082                	ret

0000000080005bae <start>:
void start() {
    80005bae:	1141                	addi	sp,sp,-16
    80005bb0:	e406                	sd	ra,8(sp)
    80005bb2:	e022                	sd	s0,0(sp)
    80005bb4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005bb6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005bba:	7779                	lui	a4,0xffffe
    80005bbc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb9fdf>
    80005bc0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005bc2:	6705                	lui	a4,0x1
    80005bc4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005bc8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005bca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005bce:	ffffa797          	auipc	a5,0xffffa
    80005bd2:	7ee78793          	addi	a5,a5,2030 # 800003bc <main>
    80005bd6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005bda:	4781                	li	a5,0
    80005bdc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80005be0:	67c1                	lui	a5,0x10
    80005be2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005be4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005be8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005bec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005bf0:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80005bf4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005bf8:	57fd                	li	a5,-1
    80005bfa:	83a9                	srli	a5,a5,0xa
    80005bfc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005c00:	47bd                	li	a5,15
    80005c02:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	f38080e7          	jalr	-200(ra) # 80005b3e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005c0e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c12:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80005c14:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c16:	30200073          	mret
}
    80005c1a:	60a2                	ld	ra,8(sp)
    80005c1c:	6402                	ld	s0,0(sp)
    80005c1e:	0141                	addi	sp,sp,16
    80005c20:	8082                	ret

0000000080005c22 <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80005c22:	715d                	addi	sp,sp,-80
    80005c24:	e486                	sd	ra,72(sp)
    80005c26:	e0a2                	sd	s0,64(sp)
    80005c28:	f84a                	sd	s2,48(sp)
    80005c2a:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80005c2c:	04c05663          	blez	a2,80005c78 <consolewrite+0x56>
    80005c30:	fc26                	sd	s1,56(sp)
    80005c32:	f44e                	sd	s3,40(sp)
    80005c34:	f052                	sd	s4,32(sp)
    80005c36:	ec56                	sd	s5,24(sp)
    80005c38:	8a2a                	mv	s4,a0
    80005c3a:	84ae                	mv	s1,a1
    80005c3c:	89b2                	mv	s3,a2
    80005c3e:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80005c40:	5afd                	li	s5,-1
    80005c42:	4685                	li	a3,1
    80005c44:	8626                	mv	a2,s1
    80005c46:	85d2                	mv	a1,s4
    80005c48:	fbf40513          	addi	a0,s0,-65
    80005c4c:	ffffc097          	auipc	ra,0xffffc
    80005c50:	f62080e7          	jalr	-158(ra) # 80001bae <either_copyin>
    80005c54:	03550463          	beq	a0,s5,80005c7c <consolewrite+0x5a>
    uartputc(c);
    80005c58:	fbf44503          	lbu	a0,-65(s0)
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	7e4080e7          	jalr	2020(ra) # 80006440 <uartputc>
  for (i = 0; i < n; i++) {
    80005c64:	2905                	addiw	s2,s2,1
    80005c66:	0485                	addi	s1,s1,1
    80005c68:	fd299de3          	bne	s3,s2,80005c42 <consolewrite+0x20>
    80005c6c:	894e                	mv	s2,s3
    80005c6e:	74e2                	ld	s1,56(sp)
    80005c70:	79a2                	ld	s3,40(sp)
    80005c72:	7a02                	ld	s4,32(sp)
    80005c74:	6ae2                	ld	s5,24(sp)
    80005c76:	a039                	j	80005c84 <consolewrite+0x62>
    80005c78:	4901                	li	s2,0
    80005c7a:	a029                	j	80005c84 <consolewrite+0x62>
    80005c7c:	74e2                	ld	s1,56(sp)
    80005c7e:	79a2                	ld	s3,40(sp)
    80005c80:	7a02                	ld	s4,32(sp)
    80005c82:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c84:	854a                	mv	a0,s2
    80005c86:	60a6                	ld	ra,72(sp)
    80005c88:	6406                	ld	s0,64(sp)
    80005c8a:	7942                	ld	s2,48(sp)
    80005c8c:	6161                	addi	sp,sp,80
    80005c8e:	8082                	ret

0000000080005c90 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005c90:	711d                	addi	sp,sp,-96
    80005c92:	ec86                	sd	ra,88(sp)
    80005c94:	e8a2                	sd	s0,80(sp)
    80005c96:	e4a6                	sd	s1,72(sp)
    80005c98:	e0ca                	sd	s2,64(sp)
    80005c9a:	fc4e                	sd	s3,56(sp)
    80005c9c:	f852                	sd	s4,48(sp)
    80005c9e:	f456                	sd	s5,40(sp)
    80005ca0:	f05a                	sd	s6,32(sp)
    80005ca2:	1080                	addi	s0,sp,96
    80005ca4:	8aaa                	mv	s5,a0
    80005ca6:	8a2e                	mv	s4,a1
    80005ca8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005caa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005cae:	0003f517          	auipc	a0,0x3f
    80005cb2:	a7250513          	addi	a0,a0,-1422 # 80044720 <cons>
    80005cb6:	00001097          	auipc	ra,0x1
    80005cba:	946080e7          	jalr	-1722(ra) # 800065fc <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005cbe:	0003f497          	auipc	s1,0x3f
    80005cc2:	a6248493          	addi	s1,s1,-1438 # 80044720 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005cc6:	0003f917          	auipc	s2,0x3f
    80005cca:	af290913          	addi	s2,s2,-1294 # 800447b8 <cons+0x98>
  while (n > 0) {
    80005cce:	0d305763          	blez	s3,80005d9c <consoleread+0x10c>
    while (cons.r == cons.w) {
    80005cd2:	0984a783          	lw	a5,152(s1)
    80005cd6:	09c4a703          	lw	a4,156(s1)
    80005cda:	0af71c63          	bne	a4,a5,80005d92 <consoleread+0x102>
      if (killed(myproc())) {
    80005cde:	ffffb097          	auipc	ra,0xffffb
    80005ce2:	3c4080e7          	jalr	964(ra) # 800010a2 <myproc>
    80005ce6:	ffffc097          	auipc	ra,0xffffc
    80005cea:	d12080e7          	jalr	-750(ra) # 800019f8 <killed>
    80005cee:	e52d                	bnez	a0,80005d58 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005cf0:	85a6                	mv	a1,s1
    80005cf2:	854a                	mv	a0,s2
    80005cf4:	ffffc097          	auipc	ra,0xffffc
    80005cf8:	a5c080e7          	jalr	-1444(ra) # 80001750 <sleep>
    while (cons.r == cons.w) {
    80005cfc:	0984a783          	lw	a5,152(s1)
    80005d00:	09c4a703          	lw	a4,156(s1)
    80005d04:	fcf70de3          	beq	a4,a5,80005cde <consoleread+0x4e>
    80005d08:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005d0a:	0003f717          	auipc	a4,0x3f
    80005d0e:	a1670713          	addi	a4,a4,-1514 # 80044720 <cons>
    80005d12:	0017869b          	addiw	a3,a5,1
    80005d16:	08d72c23          	sw	a3,152(a4)
    80005d1a:	07f7f693          	andi	a3,a5,127
    80005d1e:	9736                	add	a4,a4,a3
    80005d20:	01874703          	lbu	a4,24(a4)
    80005d24:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) {  // end-of-file
    80005d28:	4691                	li	a3,4
    80005d2a:	04db8a63          	beq	s7,a3,80005d7e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005d2e:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005d32:	4685                	li	a3,1
    80005d34:	faf40613          	addi	a2,s0,-81
    80005d38:	85d2                	mv	a1,s4
    80005d3a:	8556                	mv	a0,s5
    80005d3c:	ffffc097          	auipc	ra,0xffffc
    80005d40:	e1c080e7          	jalr	-484(ra) # 80001b58 <either_copyout>
    80005d44:	57fd                	li	a5,-1
    80005d46:	04f50a63          	beq	a0,a5,80005d9a <consoleread+0x10a>

    dst++;
    80005d4a:	0a05                	addi	s4,s4,1
    --n;
    80005d4c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80005d4e:	47a9                	li	a5,10
    80005d50:	06fb8163          	beq	s7,a5,80005db2 <consoleread+0x122>
    80005d54:	6be2                	ld	s7,24(sp)
    80005d56:	bfa5                	j	80005cce <consoleread+0x3e>
        release(&cons.lock);
    80005d58:	0003f517          	auipc	a0,0x3f
    80005d5c:	9c850513          	addi	a0,a0,-1592 # 80044720 <cons>
    80005d60:	00001097          	auipc	ra,0x1
    80005d64:	950080e7          	jalr	-1712(ra) # 800066b0 <release>
        return -1;
    80005d68:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d6a:	60e6                	ld	ra,88(sp)
    80005d6c:	6446                	ld	s0,80(sp)
    80005d6e:	64a6                	ld	s1,72(sp)
    80005d70:	6906                	ld	s2,64(sp)
    80005d72:	79e2                	ld	s3,56(sp)
    80005d74:	7a42                	ld	s4,48(sp)
    80005d76:	7aa2                	ld	s5,40(sp)
    80005d78:	7b02                	ld	s6,32(sp)
    80005d7a:	6125                	addi	sp,sp,96
    80005d7c:	8082                	ret
      if (n < target) {
    80005d7e:	0009871b          	sext.w	a4,s3
    80005d82:	01677a63          	bgeu	a4,s6,80005d96 <consoleread+0x106>
        cons.r--;
    80005d86:	0003f717          	auipc	a4,0x3f
    80005d8a:	a2f72923          	sw	a5,-1486(a4) # 800447b8 <cons+0x98>
    80005d8e:	6be2                	ld	s7,24(sp)
    80005d90:	a031                	j	80005d9c <consoleread+0x10c>
    80005d92:	ec5e                	sd	s7,24(sp)
    80005d94:	bf9d                	j	80005d0a <consoleread+0x7a>
    80005d96:	6be2                	ld	s7,24(sp)
    80005d98:	a011                	j	80005d9c <consoleread+0x10c>
    80005d9a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d9c:	0003f517          	auipc	a0,0x3f
    80005da0:	98450513          	addi	a0,a0,-1660 # 80044720 <cons>
    80005da4:	00001097          	auipc	ra,0x1
    80005da8:	90c080e7          	jalr	-1780(ra) # 800066b0 <release>
  return target - n;
    80005dac:	413b053b          	subw	a0,s6,s3
    80005db0:	bf6d                	j	80005d6a <consoleread+0xda>
    80005db2:	6be2                	ld	s7,24(sp)
    80005db4:	b7e5                	j	80005d9c <consoleread+0x10c>

0000000080005db6 <consputc>:
void consputc(int c) {
    80005db6:	1141                	addi	sp,sp,-16
    80005db8:	e406                	sd	ra,8(sp)
    80005dba:	e022                	sd	s0,0(sp)
    80005dbc:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005dbe:	10000793          	li	a5,256
    80005dc2:	00f50a63          	beq	a0,a5,80005dd6 <consputc+0x20>
    uartputc_sync(c);
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	59c080e7          	jalr	1436(ra) # 80006362 <uartputc_sync>
}
    80005dce:	60a2                	ld	ra,8(sp)
    80005dd0:	6402                	ld	s0,0(sp)
    80005dd2:	0141                	addi	sp,sp,16
    80005dd4:	8082                	ret
    uartputc_sync('\b');
    80005dd6:	4521                	li	a0,8
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	58a080e7          	jalr	1418(ra) # 80006362 <uartputc_sync>
    uartputc_sync(' ');
    80005de0:	02000513          	li	a0,32
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	57e080e7          	jalr	1406(ra) # 80006362 <uartputc_sync>
    uartputc_sync('\b');
    80005dec:	4521                	li	a0,8
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	574080e7          	jalr	1396(ra) # 80006362 <uartputc_sync>
    80005df6:	bfe1                	j	80005dce <consputc+0x18>

0000000080005df8 <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005df8:	1101                	addi	sp,sp,-32
    80005dfa:	ec06                	sd	ra,24(sp)
    80005dfc:	e822                	sd	s0,16(sp)
    80005dfe:	e426                	sd	s1,8(sp)
    80005e00:	1000                	addi	s0,sp,32
    80005e02:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e04:	0003f517          	auipc	a0,0x3f
    80005e08:	91c50513          	addi	a0,a0,-1764 # 80044720 <cons>
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	7f0080e7          	jalr	2032(ra) # 800065fc <acquire>

  switch (c) {
    80005e14:	47d5                	li	a5,21
    80005e16:	0af48563          	beq	s1,a5,80005ec0 <consoleintr+0xc8>
    80005e1a:	0297c963          	blt	a5,s1,80005e4c <consoleintr+0x54>
    80005e1e:	47a1                	li	a5,8
    80005e20:	0ef48c63          	beq	s1,a5,80005f18 <consoleintr+0x120>
    80005e24:	47c1                	li	a5,16
    80005e26:	10f49f63          	bne	s1,a5,80005f44 <consoleintr+0x14c>
    case C('P'):  // Print process list.
      procdump();
    80005e2a:	ffffc097          	auipc	ra,0xffffc
    80005e2e:	dda080e7          	jalr	-550(ra) # 80001c04 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005e32:	0003f517          	auipc	a0,0x3f
    80005e36:	8ee50513          	addi	a0,a0,-1810 # 80044720 <cons>
    80005e3a:	00001097          	auipc	ra,0x1
    80005e3e:	876080e7          	jalr	-1930(ra) # 800066b0 <release>
}
    80005e42:	60e2                	ld	ra,24(sp)
    80005e44:	6442                	ld	s0,16(sp)
    80005e46:	64a2                	ld	s1,8(sp)
    80005e48:	6105                	addi	sp,sp,32
    80005e4a:	8082                	ret
  switch (c) {
    80005e4c:	07f00793          	li	a5,127
    80005e50:	0cf48463          	beq	s1,a5,80005f18 <consoleintr+0x120>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005e54:	0003f717          	auipc	a4,0x3f
    80005e58:	8cc70713          	addi	a4,a4,-1844 # 80044720 <cons>
    80005e5c:	0a072783          	lw	a5,160(a4)
    80005e60:	09872703          	lw	a4,152(a4)
    80005e64:	9f99                	subw	a5,a5,a4
    80005e66:	07f00713          	li	a4,127
    80005e6a:	fcf764e3          	bltu	a4,a5,80005e32 <consoleintr+0x3a>
        c = (c == '\r') ? '\n' : c;
    80005e6e:	47b5                	li	a5,13
    80005e70:	0cf48d63          	beq	s1,a5,80005f4a <consoleintr+0x152>
        consputc(c);
    80005e74:	8526                	mv	a0,s1
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	f40080e7          	jalr	-192(ra) # 80005db6 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e7e:	0003f797          	auipc	a5,0x3f
    80005e82:	8a278793          	addi	a5,a5,-1886 # 80044720 <cons>
    80005e86:	0a07a683          	lw	a3,160(a5)
    80005e8a:	0016871b          	addiw	a4,a3,1
    80005e8e:	0007061b          	sext.w	a2,a4
    80005e92:	0ae7a023          	sw	a4,160(a5)
    80005e96:	07f6f693          	andi	a3,a3,127
    80005e9a:	97b6                	add	a5,a5,a3
    80005e9c:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005ea0:	47a9                	li	a5,10
    80005ea2:	0cf48b63          	beq	s1,a5,80005f78 <consoleintr+0x180>
    80005ea6:	4791                	li	a5,4
    80005ea8:	0cf48863          	beq	s1,a5,80005f78 <consoleintr+0x180>
    80005eac:	0003f797          	auipc	a5,0x3f
    80005eb0:	90c7a783          	lw	a5,-1780(a5) # 800447b8 <cons+0x98>
    80005eb4:	9f1d                	subw	a4,a4,a5
    80005eb6:	08000793          	li	a5,128
    80005eba:	f6f71ce3          	bne	a4,a5,80005e32 <consoleintr+0x3a>
    80005ebe:	a86d                	j	80005f78 <consoleintr+0x180>
    80005ec0:	e04a                	sd	s2,0(sp)
      while (cons.e != cons.w &&
    80005ec2:	0003f717          	auipc	a4,0x3f
    80005ec6:	85e70713          	addi	a4,a4,-1954 # 80044720 <cons>
    80005eca:	0a072783          	lw	a5,160(a4)
    80005ece:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005ed2:	0003f497          	auipc	s1,0x3f
    80005ed6:	84e48493          	addi	s1,s1,-1970 # 80044720 <cons>
      while (cons.e != cons.w &&
    80005eda:	4929                	li	s2,10
    80005edc:	02f70a63          	beq	a4,a5,80005f10 <consoleintr+0x118>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005ee0:	37fd                	addiw	a5,a5,-1
    80005ee2:	07f7f713          	andi	a4,a5,127
    80005ee6:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005ee8:	01874703          	lbu	a4,24(a4)
    80005eec:	03270463          	beq	a4,s2,80005f14 <consoleintr+0x11c>
        cons.e--;
    80005ef0:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005ef4:	10000513          	li	a0,256
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	ebe080e7          	jalr	-322(ra) # 80005db6 <consputc>
      while (cons.e != cons.w &&
    80005f00:	0a04a783          	lw	a5,160(s1)
    80005f04:	09c4a703          	lw	a4,156(s1)
    80005f08:	fcf71ce3          	bne	a4,a5,80005ee0 <consoleintr+0xe8>
    80005f0c:	6902                	ld	s2,0(sp)
    80005f0e:	b715                	j	80005e32 <consoleintr+0x3a>
    80005f10:	6902                	ld	s2,0(sp)
    80005f12:	b705                	j	80005e32 <consoleintr+0x3a>
    80005f14:	6902                	ld	s2,0(sp)
    80005f16:	bf31                	j	80005e32 <consoleintr+0x3a>
      if (cons.e != cons.w) {
    80005f18:	0003f717          	auipc	a4,0x3f
    80005f1c:	80870713          	addi	a4,a4,-2040 # 80044720 <cons>
    80005f20:	0a072783          	lw	a5,160(a4)
    80005f24:	09c72703          	lw	a4,156(a4)
    80005f28:	f0f705e3          	beq	a4,a5,80005e32 <consoleintr+0x3a>
        cons.e--;
    80005f2c:	37fd                	addiw	a5,a5,-1
    80005f2e:	0003f717          	auipc	a4,0x3f
    80005f32:	88f72923          	sw	a5,-1902(a4) # 800447c0 <cons+0xa0>
        consputc(BACKSPACE);
    80005f36:	10000513          	li	a0,256
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	e7c080e7          	jalr	-388(ra) # 80005db6 <consputc>
    80005f42:	bdc5                	j	80005e32 <consoleintr+0x3a>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005f44:	ee0487e3          	beqz	s1,80005e32 <consoleintr+0x3a>
    80005f48:	b731                	j	80005e54 <consoleintr+0x5c>
        consputc(c);
    80005f4a:	4529                	li	a0,10
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	e6a080e7          	jalr	-406(ra) # 80005db6 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f54:	0003e797          	auipc	a5,0x3e
    80005f58:	7cc78793          	addi	a5,a5,1996 # 80044720 <cons>
    80005f5c:	0a07a703          	lw	a4,160(a5)
    80005f60:	0017069b          	addiw	a3,a4,1
    80005f64:	0006861b          	sext.w	a2,a3
    80005f68:	0ad7a023          	sw	a3,160(a5)
    80005f6c:	07f77713          	andi	a4,a4,127
    80005f70:	97ba                	add	a5,a5,a4
    80005f72:	4729                	li	a4,10
    80005f74:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005f78:	0003f797          	auipc	a5,0x3f
    80005f7c:	84c7a223          	sw	a2,-1980(a5) # 800447bc <cons+0x9c>
          wakeup(&cons.r);
    80005f80:	0003f517          	auipc	a0,0x3f
    80005f84:	83850513          	addi	a0,a0,-1992 # 800447b8 <cons+0x98>
    80005f88:	ffffc097          	auipc	ra,0xffffc
    80005f8c:	82c080e7          	jalr	-2004(ra) # 800017b4 <wakeup>
    80005f90:	b54d                	j	80005e32 <consoleintr+0x3a>

0000000080005f92 <consoleinit>:

void consoleinit(void) {
    80005f92:	1141                	addi	sp,sp,-16
    80005f94:	e406                	sd	ra,8(sp)
    80005f96:	e022                	sd	s0,0(sp)
    80005f98:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f9a:	00002597          	auipc	a1,0x2
    80005f9e:	7a658593          	addi	a1,a1,1958 # 80008740 <etext+0x740>
    80005fa2:	0003e517          	auipc	a0,0x3e
    80005fa6:	77e50513          	addi	a0,a0,1918 # 80044720 <cons>
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	5c2080e7          	jalr	1474(ra) # 8000656c <initlock>

  uartinit();
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	354080e7          	jalr	852(ra) # 80006306 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fba:	00035797          	auipc	a5,0x35
    80005fbe:	48678793          	addi	a5,a5,1158 # 8003b440 <devsw>
    80005fc2:	00000717          	auipc	a4,0x0
    80005fc6:	cce70713          	addi	a4,a4,-818 # 80005c90 <consoleread>
    80005fca:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fcc:	00000717          	auipc	a4,0x0
    80005fd0:	c5670713          	addi	a4,a4,-938 # 80005c22 <consolewrite>
    80005fd4:	ef98                	sd	a4,24(a5)
}
    80005fd6:	60a2                	ld	ra,8(sp)
    80005fd8:	6402                	ld	s0,0(sp)
    80005fda:	0141                	addi	sp,sp,16
    80005fdc:	8082                	ret

0000000080005fde <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005fde:	7179                	addi	sp,sp,-48
    80005fe0:	f406                	sd	ra,40(sp)
    80005fe2:	f022                	sd	s0,32(sp)
    80005fe4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005fe6:	c219                	beqz	a2,80005fec <printint+0xe>
    80005fe8:	08054963          	bltz	a0,8000607a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005fec:	2501                	sext.w	a0,a0
    80005fee:	4881                	li	a7,0
    80005ff0:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ff4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ff6:	2581                	sext.w	a1,a1
    80005ff8:	00003617          	auipc	a2,0x3
    80005ffc:	8a860613          	addi	a2,a2,-1880 # 800088a0 <digits>
    80006000:	883a                	mv	a6,a4
    80006002:	2705                	addiw	a4,a4,1
    80006004:	02b577bb          	remuw	a5,a0,a1
    80006008:	1782                	slli	a5,a5,0x20
    8000600a:	9381                	srli	a5,a5,0x20
    8000600c:	97b2                	add	a5,a5,a2
    8000600e:	0007c783          	lbu	a5,0(a5)
    80006012:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80006016:	0005079b          	sext.w	a5,a0
    8000601a:	02b5553b          	divuw	a0,a0,a1
    8000601e:	0685                	addi	a3,a3,1
    80006020:	feb7f0e3          	bgeu	a5,a1,80006000 <printint+0x22>

  if (sign) buf[i++] = '-';
    80006024:	00088c63          	beqz	a7,8000603c <printint+0x5e>
    80006028:	fe070793          	addi	a5,a4,-32
    8000602c:	00878733          	add	a4,a5,s0
    80006030:	02d00793          	li	a5,45
    80006034:	fef70823          	sb	a5,-16(a4)
    80006038:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    8000603c:	02e05b63          	blez	a4,80006072 <printint+0x94>
    80006040:	ec26                	sd	s1,24(sp)
    80006042:	e84a                	sd	s2,16(sp)
    80006044:	fd040793          	addi	a5,s0,-48
    80006048:	00e784b3          	add	s1,a5,a4
    8000604c:	fff78913          	addi	s2,a5,-1
    80006050:	993a                	add	s2,s2,a4
    80006052:	377d                	addiw	a4,a4,-1
    80006054:	1702                	slli	a4,a4,0x20
    80006056:	9301                	srli	a4,a4,0x20
    80006058:	40e90933          	sub	s2,s2,a4
    8000605c:	fff4c503          	lbu	a0,-1(s1)
    80006060:	00000097          	auipc	ra,0x0
    80006064:	d56080e7          	jalr	-682(ra) # 80005db6 <consputc>
    80006068:	14fd                	addi	s1,s1,-1
    8000606a:	ff2499e3          	bne	s1,s2,8000605c <printint+0x7e>
    8000606e:	64e2                	ld	s1,24(sp)
    80006070:	6942                	ld	s2,16(sp)
}
    80006072:	70a2                	ld	ra,40(sp)
    80006074:	7402                	ld	s0,32(sp)
    80006076:	6145                	addi	sp,sp,48
    80006078:	8082                	ret
    x = -xx;
    8000607a:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    8000607e:	4885                	li	a7,1
    x = -xx;
    80006080:	bf85                	j	80005ff0 <printint+0x12>

0000000080006082 <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
    8000608c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000608e:	0003e797          	auipc	a5,0x3e
    80006092:	7407a923          	sw	zero,1874(a5) # 800447e0 <pr+0x18>
  printf("panic: ");
    80006096:	00002517          	auipc	a0,0x2
    8000609a:	6b250513          	addi	a0,a0,1714 # 80008748 <etext+0x748>
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	02e080e7          	jalr	46(ra) # 800060cc <printf>
  printf(s);
    800060a6:	8526                	mv	a0,s1
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	024080e7          	jalr	36(ra) # 800060cc <printf>
  printf("\n");
    800060b0:	00002517          	auipc	a0,0x2
    800060b4:	f7050513          	addi	a0,a0,-144 # 80008020 <etext+0x20>
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	014080e7          	jalr	20(ra) # 800060cc <printf>
  panicked = 1;  // freeze uart output from other CPUs
    800060c0:	4785                	li	a5,1
    800060c2:	00005717          	auipc	a4,0x5
    800060c6:	2af72d23          	sw	a5,698(a4) # 8000b37c <panicked>
  for (;;);
    800060ca:	a001                	j	800060ca <panic+0x48>

00000000800060cc <printf>:
void printf(char *fmt, ...) {
    800060cc:	7131                	addi	sp,sp,-192
    800060ce:	fc86                	sd	ra,120(sp)
    800060d0:	f8a2                	sd	s0,112(sp)
    800060d2:	e8d2                	sd	s4,80(sp)
    800060d4:	f06a                	sd	s10,32(sp)
    800060d6:	0100                	addi	s0,sp,128
    800060d8:	8a2a                	mv	s4,a0
    800060da:	e40c                	sd	a1,8(s0)
    800060dc:	e810                	sd	a2,16(s0)
    800060de:	ec14                	sd	a3,24(s0)
    800060e0:	f018                	sd	a4,32(s0)
    800060e2:	f41c                	sd	a5,40(s0)
    800060e4:	03043823          	sd	a6,48(s0)
    800060e8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060ec:	0003ed17          	auipc	s10,0x3e
    800060f0:	6f4d2d03          	lw	s10,1780(s10) # 800447e0 <pr+0x18>
  if (locking) acquire(&pr.lock);
    800060f4:	040d1463          	bnez	s10,8000613c <printf+0x70>
  if (fmt == 0) panic("null fmt");
    800060f8:	040a0b63          	beqz	s4,8000614e <printf+0x82>
  va_start(ap, fmt);
    800060fc:	00840793          	addi	a5,s0,8
    80006100:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006104:	000a4503          	lbu	a0,0(s4)
    80006108:	18050b63          	beqz	a0,8000629e <printf+0x1d2>
    8000610c:	f4a6                	sd	s1,104(sp)
    8000610e:	f0ca                	sd	s2,96(sp)
    80006110:	ecce                	sd	s3,88(sp)
    80006112:	e4d6                	sd	s5,72(sp)
    80006114:	e0da                	sd	s6,64(sp)
    80006116:	fc5e                	sd	s7,56(sp)
    80006118:	f862                	sd	s8,48(sp)
    8000611a:	f466                	sd	s9,40(sp)
    8000611c:	ec6e                	sd	s11,24(sp)
    8000611e:	4981                	li	s3,0
    if (c != '%') {
    80006120:	02500b13          	li	s6,37
    switch (c) {
    80006124:	07000b93          	li	s7,112
  consputc('x');
    80006128:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000612a:	00002a97          	auipc	s5,0x2
    8000612e:	776a8a93          	addi	s5,s5,1910 # 800088a0 <digits>
    switch (c) {
    80006132:	07300c13          	li	s8,115
    80006136:	06400d93          	li	s11,100
    8000613a:	a0b1                	j	80006186 <printf+0xba>
  if (locking) acquire(&pr.lock);
    8000613c:	0003e517          	auipc	a0,0x3e
    80006140:	68c50513          	addi	a0,a0,1676 # 800447c8 <pr>
    80006144:	00000097          	auipc	ra,0x0
    80006148:	4b8080e7          	jalr	1208(ra) # 800065fc <acquire>
    8000614c:	b775                	j	800060f8 <printf+0x2c>
    8000614e:	f4a6                	sd	s1,104(sp)
    80006150:	f0ca                	sd	s2,96(sp)
    80006152:	ecce                	sd	s3,88(sp)
    80006154:	e4d6                	sd	s5,72(sp)
    80006156:	e0da                	sd	s6,64(sp)
    80006158:	fc5e                	sd	s7,56(sp)
    8000615a:	f862                	sd	s8,48(sp)
    8000615c:	f466                	sd	s9,40(sp)
    8000615e:	ec6e                	sd	s11,24(sp)
  if (fmt == 0) panic("null fmt");
    80006160:	00002517          	auipc	a0,0x2
    80006164:	5f850513          	addi	a0,a0,1528 # 80008758 <etext+0x758>
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	f1a080e7          	jalr	-230(ra) # 80006082 <panic>
      consputc(c);
    80006170:	00000097          	auipc	ra,0x0
    80006174:	c46080e7          	jalr	-954(ra) # 80005db6 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006178:	2985                	addiw	s3,s3,1
    8000617a:	013a07b3          	add	a5,s4,s3
    8000617e:	0007c503          	lbu	a0,0(a5)
    80006182:	10050563          	beqz	a0,8000628c <printf+0x1c0>
    if (c != '%') {
    80006186:	ff6515e3          	bne	a0,s6,80006170 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000618a:	2985                	addiw	s3,s3,1
    8000618c:	013a07b3          	add	a5,s4,s3
    80006190:	0007c783          	lbu	a5,0(a5)
    80006194:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006198:	10078b63          	beqz	a5,800062ae <printf+0x1e2>
    switch (c) {
    8000619c:	05778a63          	beq	a5,s7,800061f0 <printf+0x124>
    800061a0:	02fbf663          	bgeu	s7,a5,800061cc <printf+0x100>
    800061a4:	09878863          	beq	a5,s8,80006234 <printf+0x168>
    800061a8:	07800713          	li	a4,120
    800061ac:	0ce79563          	bne	a5,a4,80006276 <printf+0x1aa>
        printint(va_arg(ap, int), 16, 1);
    800061b0:	f8843783          	ld	a5,-120(s0)
    800061b4:	00878713          	addi	a4,a5,8
    800061b8:	f8e43423          	sd	a4,-120(s0)
    800061bc:	4605                	li	a2,1
    800061be:	85e6                	mv	a1,s9
    800061c0:	4388                	lw	a0,0(a5)
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	e1c080e7          	jalr	-484(ra) # 80005fde <printint>
        break;
    800061ca:	b77d                	j	80006178 <printf+0xac>
    switch (c) {
    800061cc:	09678f63          	beq	a5,s6,8000626a <printf+0x19e>
    800061d0:	0bb79363          	bne	a5,s11,80006276 <printf+0x1aa>
        printint(va_arg(ap, int), 10, 1);
    800061d4:	f8843783          	ld	a5,-120(s0)
    800061d8:	00878713          	addi	a4,a5,8
    800061dc:	f8e43423          	sd	a4,-120(s0)
    800061e0:	4605                	li	a2,1
    800061e2:	45a9                	li	a1,10
    800061e4:	4388                	lw	a0,0(a5)
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	df8080e7          	jalr	-520(ra) # 80005fde <printint>
        break;
    800061ee:	b769                	j	80006178 <printf+0xac>
        printptr(va_arg(ap, uint64));
    800061f0:	f8843783          	ld	a5,-120(s0)
    800061f4:	00878713          	addi	a4,a5,8
    800061f8:	f8e43423          	sd	a4,-120(s0)
    800061fc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006200:	03000513          	li	a0,48
    80006204:	00000097          	auipc	ra,0x0
    80006208:	bb2080e7          	jalr	-1102(ra) # 80005db6 <consputc>
  consputc('x');
    8000620c:	07800513          	li	a0,120
    80006210:	00000097          	auipc	ra,0x0
    80006214:	ba6080e7          	jalr	-1114(ra) # 80005db6 <consputc>
    80006218:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000621a:	03c95793          	srli	a5,s2,0x3c
    8000621e:	97d6                	add	a5,a5,s5
    80006220:	0007c503          	lbu	a0,0(a5)
    80006224:	00000097          	auipc	ra,0x0
    80006228:	b92080e7          	jalr	-1134(ra) # 80005db6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000622c:	0912                	slli	s2,s2,0x4
    8000622e:	34fd                	addiw	s1,s1,-1
    80006230:	f4ed                	bnez	s1,8000621a <printf+0x14e>
    80006232:	b799                	j	80006178 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006234:	f8843783          	ld	a5,-120(s0)
    80006238:	00878713          	addi	a4,a5,8
    8000623c:	f8e43423          	sd	a4,-120(s0)
    80006240:	6384                	ld	s1,0(a5)
    80006242:	cc89                	beqz	s1,8000625c <printf+0x190>
        for (; *s; s++) consputc(*s);
    80006244:	0004c503          	lbu	a0,0(s1)
    80006248:	d905                	beqz	a0,80006178 <printf+0xac>
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	b6c080e7          	jalr	-1172(ra) # 80005db6 <consputc>
    80006252:	0485                	addi	s1,s1,1
    80006254:	0004c503          	lbu	a0,0(s1)
    80006258:	f96d                	bnez	a0,8000624a <printf+0x17e>
    8000625a:	bf39                	j	80006178 <printf+0xac>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    8000625c:	00002497          	auipc	s1,0x2
    80006260:	4f448493          	addi	s1,s1,1268 # 80008750 <etext+0x750>
        for (; *s; s++) consputc(*s);
    80006264:	02800513          	li	a0,40
    80006268:	b7cd                	j	8000624a <printf+0x17e>
        consputc('%');
    8000626a:	855a                	mv	a0,s6
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	b4a080e7          	jalr	-1206(ra) # 80005db6 <consputc>
        break;
    80006274:	b711                	j	80006178 <printf+0xac>
        consputc('%');
    80006276:	855a                	mv	a0,s6
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	b3e080e7          	jalr	-1218(ra) # 80005db6 <consputc>
        consputc(c);
    80006280:	8526                	mv	a0,s1
    80006282:	00000097          	auipc	ra,0x0
    80006286:	b34080e7          	jalr	-1228(ra) # 80005db6 <consputc>
        break;
    8000628a:	b5fd                	j	80006178 <printf+0xac>
    8000628c:	74a6                	ld	s1,104(sp)
    8000628e:	7906                	ld	s2,96(sp)
    80006290:	69e6                	ld	s3,88(sp)
    80006292:	6aa6                	ld	s5,72(sp)
    80006294:	6b06                	ld	s6,64(sp)
    80006296:	7be2                	ld	s7,56(sp)
    80006298:	7c42                	ld	s8,48(sp)
    8000629a:	7ca2                	ld	s9,40(sp)
    8000629c:	6de2                	ld	s11,24(sp)
  if (locking) release(&pr.lock);
    8000629e:	020d1263          	bnez	s10,800062c2 <printf+0x1f6>
}
    800062a2:	70e6                	ld	ra,120(sp)
    800062a4:	7446                	ld	s0,112(sp)
    800062a6:	6a46                	ld	s4,80(sp)
    800062a8:	7d02                	ld	s10,32(sp)
    800062aa:	6129                	addi	sp,sp,192
    800062ac:	8082                	ret
    800062ae:	74a6                	ld	s1,104(sp)
    800062b0:	7906                	ld	s2,96(sp)
    800062b2:	69e6                	ld	s3,88(sp)
    800062b4:	6aa6                	ld	s5,72(sp)
    800062b6:	6b06                	ld	s6,64(sp)
    800062b8:	7be2                	ld	s7,56(sp)
    800062ba:	7c42                	ld	s8,48(sp)
    800062bc:	7ca2                	ld	s9,40(sp)
    800062be:	6de2                	ld	s11,24(sp)
    800062c0:	bff9                	j	8000629e <printf+0x1d2>
  if (locking) release(&pr.lock);
    800062c2:	0003e517          	auipc	a0,0x3e
    800062c6:	50650513          	addi	a0,a0,1286 # 800447c8 <pr>
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	3e6080e7          	jalr	998(ra) # 800066b0 <release>
}
    800062d2:	bfc1                	j	800062a2 <printf+0x1d6>

00000000800062d4 <printfinit>:
}

void printfinit(void) {
    800062d4:	1101                	addi	sp,sp,-32
    800062d6:	ec06                	sd	ra,24(sp)
    800062d8:	e822                	sd	s0,16(sp)
    800062da:	e426                	sd	s1,8(sp)
    800062dc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062de:	0003e497          	auipc	s1,0x3e
    800062e2:	4ea48493          	addi	s1,s1,1258 # 800447c8 <pr>
    800062e6:	00002597          	auipc	a1,0x2
    800062ea:	48258593          	addi	a1,a1,1154 # 80008768 <etext+0x768>
    800062ee:	8526                	mv	a0,s1
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	27c080e7          	jalr	636(ra) # 8000656c <initlock>
  pr.locking = 1;
    800062f8:	4785                	li	a5,1
    800062fa:	cc9c                	sw	a5,24(s1)
}
    800062fc:	60e2                	ld	ra,24(sp)
    800062fe:	6442                	ld	s0,16(sp)
    80006300:	64a2                	ld	s1,8(sp)
    80006302:	6105                	addi	sp,sp,32
    80006304:	8082                	ret

0000000080006306 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006306:	1141                	addi	sp,sp,-16
    80006308:	e406                	sd	ra,8(sp)
    8000630a:	e022                	sd	s0,0(sp)
    8000630c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000630e:	100007b7          	lui	a5,0x10000
    80006312:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006316:	10000737          	lui	a4,0x10000
    8000631a:	f8000693          	li	a3,-128
    8000631e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006322:	468d                	li	a3,3
    80006324:	10000637          	lui	a2,0x10000
    80006328:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000632c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006330:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006334:	10000737          	lui	a4,0x10000
    80006338:	461d                	li	a2,7
    8000633a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000633e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006342:	00002597          	auipc	a1,0x2
    80006346:	42e58593          	addi	a1,a1,1070 # 80008770 <etext+0x770>
    8000634a:	0003e517          	auipc	a0,0x3e
    8000634e:	49e50513          	addi	a0,a0,1182 # 800447e8 <uart_tx_lock>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	21a080e7          	jalr	538(ra) # 8000656c <initlock>
}
    8000635a:	60a2                	ld	ra,8(sp)
    8000635c:	6402                	ld	s0,0(sp)
    8000635e:	0141                	addi	sp,sp,16
    80006360:	8082                	ret

0000000080006362 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006362:	1101                	addi	sp,sp,-32
    80006364:	ec06                	sd	ra,24(sp)
    80006366:	e822                	sd	s0,16(sp)
    80006368:	e426                	sd	s1,8(sp)
    8000636a:	1000                	addi	s0,sp,32
    8000636c:	84aa                	mv	s1,a0
  push_off();
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	242080e7          	jalr	578(ra) # 800065b0 <push_off>

  if (panicked) {
    80006376:	00005797          	auipc	a5,0x5
    8000637a:	0067a783          	lw	a5,6(a5) # 8000b37c <panicked>
    8000637e:	eb85                	bnez	a5,800063ae <uartputc_sync+0x4c>
    for (;;);
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80006380:	10000737          	lui	a4,0x10000
    80006384:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006386:	00074783          	lbu	a5,0(a4)
    8000638a:	0207f793          	andi	a5,a5,32
    8000638e:	dfe5                	beqz	a5,80006386 <uartputc_sync+0x24>
  WriteReg(THR, c);
    80006390:	0ff4f513          	zext.b	a0,s1
    80006394:	100007b7          	lui	a5,0x10000
    80006398:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000639c:	00000097          	auipc	ra,0x0
    800063a0:	2b4080e7          	jalr	692(ra) # 80006650 <pop_off>
}
    800063a4:	60e2                	ld	ra,24(sp)
    800063a6:	6442                	ld	s0,16(sp)
    800063a8:	64a2                	ld	s1,8(sp)
    800063aa:	6105                	addi	sp,sp,32
    800063ac:	8082                	ret
    for (;;);
    800063ae:	a001                	j	800063ae <uartputc_sync+0x4c>

00000000800063b0 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    800063b0:	00005797          	auipc	a5,0x5
    800063b4:	fd07b783          	ld	a5,-48(a5) # 8000b380 <uart_tx_r>
    800063b8:	00005717          	auipc	a4,0x5
    800063bc:	fd073703          	ld	a4,-48(a4) # 8000b388 <uart_tx_w>
    800063c0:	06f70f63          	beq	a4,a5,8000643e <uartstart+0x8e>
void uartstart() {
    800063c4:	7139                	addi	sp,sp,-64
    800063c6:	fc06                	sd	ra,56(sp)
    800063c8:	f822                	sd	s0,48(sp)
    800063ca:	f426                	sd	s1,40(sp)
    800063cc:	f04a                	sd	s2,32(sp)
    800063ce:	ec4e                	sd	s3,24(sp)
    800063d0:	e852                	sd	s4,16(sp)
    800063d2:	e456                	sd	s5,8(sp)
    800063d4:	e05a                	sd	s6,0(sp)
    800063d6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800063d8:	10000937          	lui	s2,0x10000
    800063dc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063de:	0003ea97          	auipc	s5,0x3e
    800063e2:	40aa8a93          	addi	s5,s5,1034 # 800447e8 <uart_tx_lock>
    uart_tx_r += 1;
    800063e6:	00005497          	auipc	s1,0x5
    800063ea:	f9a48493          	addi	s1,s1,-102 # 8000b380 <uart_tx_r>

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);

    WriteReg(THR, c);
    800063ee:	10000a37          	lui	s4,0x10000
    if (uart_tx_w == uart_tx_r) {
    800063f2:	00005997          	auipc	s3,0x5
    800063f6:	f9698993          	addi	s3,s3,-106 # 8000b388 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800063fa:	00094703          	lbu	a4,0(s2)
    800063fe:	02077713          	andi	a4,a4,32
    80006402:	c705                	beqz	a4,8000642a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006404:	01f7f713          	andi	a4,a5,31
    80006408:	9756                	add	a4,a4,s5
    8000640a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000640e:	0785                	addi	a5,a5,1
    80006410:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006412:	8526                	mv	a0,s1
    80006414:	ffffb097          	auipc	ra,0xffffb
    80006418:	3a0080e7          	jalr	928(ra) # 800017b4 <wakeup>
    WriteReg(THR, c);
    8000641c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if (uart_tx_w == uart_tx_r) {
    80006420:	609c                	ld	a5,0(s1)
    80006422:	0009b703          	ld	a4,0(s3)
    80006426:	fcf71ae3          	bne	a4,a5,800063fa <uartstart+0x4a>
  }
}
    8000642a:	70e2                	ld	ra,56(sp)
    8000642c:	7442                	ld	s0,48(sp)
    8000642e:	74a2                	ld	s1,40(sp)
    80006430:	7902                	ld	s2,32(sp)
    80006432:	69e2                	ld	s3,24(sp)
    80006434:	6a42                	ld	s4,16(sp)
    80006436:	6aa2                	ld	s5,8(sp)
    80006438:	6b02                	ld	s6,0(sp)
    8000643a:	6121                	addi	sp,sp,64
    8000643c:	8082                	ret
    8000643e:	8082                	ret

0000000080006440 <uartputc>:
void uartputc(int c) {
    80006440:	7179                	addi	sp,sp,-48
    80006442:	f406                	sd	ra,40(sp)
    80006444:	f022                	sd	s0,32(sp)
    80006446:	ec26                	sd	s1,24(sp)
    80006448:	e84a                	sd	s2,16(sp)
    8000644a:	e44e                	sd	s3,8(sp)
    8000644c:	e052                	sd	s4,0(sp)
    8000644e:	1800                	addi	s0,sp,48
    80006450:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006452:	0003e517          	auipc	a0,0x3e
    80006456:	39650513          	addi	a0,a0,918 # 800447e8 <uart_tx_lock>
    8000645a:	00000097          	auipc	ra,0x0
    8000645e:	1a2080e7          	jalr	418(ra) # 800065fc <acquire>
  if (panicked) {
    80006462:	00005797          	auipc	a5,0x5
    80006466:	f1a7a783          	lw	a5,-230(a5) # 8000b37c <panicked>
    8000646a:	e7c9                	bnez	a5,800064f4 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    8000646c:	00005717          	auipc	a4,0x5
    80006470:	f1c73703          	ld	a4,-228(a4) # 8000b388 <uart_tx_w>
    80006474:	00005797          	auipc	a5,0x5
    80006478:	f0c7b783          	ld	a5,-244(a5) # 8000b380 <uart_tx_r>
    8000647c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006480:	0003e997          	auipc	s3,0x3e
    80006484:	36898993          	addi	s3,s3,872 # 800447e8 <uart_tx_lock>
    80006488:	00005497          	auipc	s1,0x5
    8000648c:	ef848493          	addi	s1,s1,-264 # 8000b380 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006490:	00005917          	auipc	s2,0x5
    80006494:	ef890913          	addi	s2,s2,-264 # 8000b388 <uart_tx_w>
    80006498:	00e79f63          	bne	a5,a4,800064b6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000649c:	85ce                	mv	a1,s3
    8000649e:	8526                	mv	a0,s1
    800064a0:	ffffb097          	auipc	ra,0xffffb
    800064a4:	2b0080e7          	jalr	688(ra) # 80001750 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800064a8:	00093703          	ld	a4,0(s2)
    800064ac:	609c                	ld	a5,0(s1)
    800064ae:	02078793          	addi	a5,a5,32
    800064b2:	fee785e3          	beq	a5,a4,8000649c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064b6:	0003e497          	auipc	s1,0x3e
    800064ba:	33248493          	addi	s1,s1,818 # 800447e8 <uart_tx_lock>
    800064be:	01f77793          	andi	a5,a4,31
    800064c2:	97a6                	add	a5,a5,s1
    800064c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800064c8:	0705                	addi	a4,a4,1
    800064ca:	00005797          	auipc	a5,0x5
    800064ce:	eae7bf23          	sd	a4,-322(a5) # 8000b388 <uart_tx_w>
  uartstart();
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	ede080e7          	jalr	-290(ra) # 800063b0 <uartstart>
  release(&uart_tx_lock);
    800064da:	8526                	mv	a0,s1
    800064dc:	00000097          	auipc	ra,0x0
    800064e0:	1d4080e7          	jalr	468(ra) # 800066b0 <release>
}
    800064e4:	70a2                	ld	ra,40(sp)
    800064e6:	7402                	ld	s0,32(sp)
    800064e8:	64e2                	ld	s1,24(sp)
    800064ea:	6942                	ld	s2,16(sp)
    800064ec:	69a2                	ld	s3,8(sp)
    800064ee:	6a02                	ld	s4,0(sp)
    800064f0:	6145                	addi	sp,sp,48
    800064f2:	8082                	ret
    for (;;);
    800064f4:	a001                	j	800064f4 <uartputc+0xb4>

00000000800064f6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    800064f6:	1141                	addi	sp,sp,-16
    800064f8:	e422                	sd	s0,8(sp)
    800064fa:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    800064fc:	100007b7          	lui	a5,0x10000
    80006500:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006502:	0007c783          	lbu	a5,0(a5)
    80006506:	8b85                	andi	a5,a5,1
    80006508:	cb81                	beqz	a5,80006518 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000650a:	100007b7          	lui	a5,0x10000
    8000650e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006512:	6422                	ld	s0,8(sp)
    80006514:	0141                	addi	sp,sp,16
    80006516:	8082                	ret
    return -1;
    80006518:	557d                	li	a0,-1
    8000651a:	bfe5                	j	80006512 <uartgetc+0x1c>

000000008000651c <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    8000651c:	1101                	addi	sp,sp,-32
    8000651e:	ec06                	sd	ra,24(sp)
    80006520:	e822                	sd	s0,16(sp)
    80006522:	e426                	sd	s1,8(sp)
    80006524:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006526:	54fd                	li	s1,-1
    80006528:	a029                	j	80006532 <uartintr+0x16>
    consoleintr(c);
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	8ce080e7          	jalr	-1842(ra) # 80005df8 <consoleintr>
    int c = uartgetc();
    80006532:	00000097          	auipc	ra,0x0
    80006536:	fc4080e7          	jalr	-60(ra) # 800064f6 <uartgetc>
    if (c == -1) break;
    8000653a:	fe9518e3          	bne	a0,s1,8000652a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000653e:	0003e497          	auipc	s1,0x3e
    80006542:	2aa48493          	addi	s1,s1,682 # 800447e8 <uart_tx_lock>
    80006546:	8526                	mv	a0,s1
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	0b4080e7          	jalr	180(ra) # 800065fc <acquire>
  uartstart();
    80006550:	00000097          	auipc	ra,0x0
    80006554:	e60080e7          	jalr	-416(ra) # 800063b0 <uartstart>
  release(&uart_tx_lock);
    80006558:	8526                	mv	a0,s1
    8000655a:	00000097          	auipc	ra,0x0
    8000655e:	156080e7          	jalr	342(ra) # 800066b0 <release>
}
    80006562:	60e2                	ld	ra,24(sp)
    80006564:	6442                	ld	s0,16(sp)
    80006566:	64a2                	ld	s1,8(sp)
    80006568:	6105                	addi	sp,sp,32
    8000656a:	8082                	ret

000000008000656c <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    8000656c:	1141                	addi	sp,sp,-16
    8000656e:	e422                	sd	s0,8(sp)
    80006570:	0800                	addi	s0,sp,16
  lk->name = name;
    80006572:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006574:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006578:	00053823          	sd	zero,16(a0)
}
    8000657c:	6422                	ld	s0,8(sp)
    8000657e:	0141                	addi	sp,sp,16
    80006580:	8082                	ret

0000000080006582 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006582:	411c                	lw	a5,0(a0)
    80006584:	e399                	bnez	a5,8000658a <holding+0x8>
    80006586:	4501                	li	a0,0
  return r;
}
    80006588:	8082                	ret
int holding(struct spinlock *lk) {
    8000658a:	1101                	addi	sp,sp,-32
    8000658c:	ec06                	sd	ra,24(sp)
    8000658e:	e822                	sd	s0,16(sp)
    80006590:	e426                	sd	s1,8(sp)
    80006592:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006594:	6904                	ld	s1,16(a0)
    80006596:	ffffb097          	auipc	ra,0xffffb
    8000659a:	af0080e7          	jalr	-1296(ra) # 80001086 <mycpu>
    8000659e:	40a48533          	sub	a0,s1,a0
    800065a2:	00153513          	seqz	a0,a0
}
    800065a6:	60e2                	ld	ra,24(sp)
    800065a8:	6442                	ld	s0,16(sp)
    800065aa:	64a2                	ld	s1,8(sp)
    800065ac:	6105                	addi	sp,sp,32
    800065ae:	8082                	ret

00000000800065b0 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    800065b0:	1101                	addi	sp,sp,-32
    800065b2:	ec06                	sd	ra,24(sp)
    800065b4:	e822                	sd	s0,16(sp)
    800065b6:	e426                	sd	s1,8(sp)
    800065b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800065ba:	100024f3          	csrr	s1,sstatus
    800065be:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800065c2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800065c4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800065c8:	ffffb097          	auipc	ra,0xffffb
    800065cc:	abe080e7          	jalr	-1346(ra) # 80001086 <mycpu>
    800065d0:	5d3c                	lw	a5,120(a0)
    800065d2:	cf89                	beqz	a5,800065ec <push_off+0x3c>
  mycpu()->noff += 1;
    800065d4:	ffffb097          	auipc	ra,0xffffb
    800065d8:	ab2080e7          	jalr	-1358(ra) # 80001086 <mycpu>
    800065dc:	5d3c                	lw	a5,120(a0)
    800065de:	2785                	addiw	a5,a5,1
    800065e0:	dd3c                	sw	a5,120(a0)
}
    800065e2:	60e2                	ld	ra,24(sp)
    800065e4:	6442                	ld	s0,16(sp)
    800065e6:	64a2                	ld	s1,8(sp)
    800065e8:	6105                	addi	sp,sp,32
    800065ea:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800065ec:	ffffb097          	auipc	ra,0xffffb
    800065f0:	a9a080e7          	jalr	-1382(ra) # 80001086 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065f4:	8085                	srli	s1,s1,0x1
    800065f6:	8885                	andi	s1,s1,1
    800065f8:	dd64                	sw	s1,124(a0)
    800065fa:	bfe9                	j	800065d4 <push_off+0x24>

00000000800065fc <acquire>:
void acquire(struct spinlock *lk) {
    800065fc:	1101                	addi	sp,sp,-32
    800065fe:	ec06                	sd	ra,24(sp)
    80006600:	e822                	sd	s0,16(sp)
    80006602:	e426                	sd	s1,8(sp)
    80006604:	1000                	addi	s0,sp,32
    80006606:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	fa8080e7          	jalr	-88(ra) # 800065b0 <push_off>
  if (holding(lk)) panic("acquire");
    80006610:	8526                	mv	a0,s1
    80006612:	00000097          	auipc	ra,0x0
    80006616:	f70080e7          	jalr	-144(ra) # 80006582 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000661a:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    8000661c:	e115                	bnez	a0,80006640 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000661e:	87ba                	mv	a5,a4
    80006620:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006624:	2781                	sext.w	a5,a5
    80006626:	ffe5                	bnez	a5,8000661e <acquire+0x22>
  __sync_synchronize();
    80006628:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000662c:	ffffb097          	auipc	ra,0xffffb
    80006630:	a5a080e7          	jalr	-1446(ra) # 80001086 <mycpu>
    80006634:	e888                	sd	a0,16(s1)
}
    80006636:	60e2                	ld	ra,24(sp)
    80006638:	6442                	ld	s0,16(sp)
    8000663a:	64a2                	ld	s1,8(sp)
    8000663c:	6105                	addi	sp,sp,32
    8000663e:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006640:	00002517          	auipc	a0,0x2
    80006644:	13850513          	addi	a0,a0,312 # 80008778 <etext+0x778>
    80006648:	00000097          	auipc	ra,0x0
    8000664c:	a3a080e7          	jalr	-1478(ra) # 80006082 <panic>

0000000080006650 <pop_off>:

void pop_off(void) {
    80006650:	1141                	addi	sp,sp,-16
    80006652:	e406                	sd	ra,8(sp)
    80006654:	e022                	sd	s0,0(sp)
    80006656:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006658:	ffffb097          	auipc	ra,0xffffb
    8000665c:	a2e080e7          	jalr	-1490(ra) # 80001086 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006660:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006664:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80006666:	e78d                	bnez	a5,80006690 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006668:	5d3c                	lw	a5,120(a0)
    8000666a:	02f05b63          	blez	a5,800066a0 <pop_off+0x50>
  c->noff -= 1;
    8000666e:	37fd                	addiw	a5,a5,-1
    80006670:	0007871b          	sext.w	a4,a5
    80006674:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    80006676:	eb09                	bnez	a4,80006688 <pop_off+0x38>
    80006678:	5d7c                	lw	a5,124(a0)
    8000667a:	c799                	beqz	a5,80006688 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000667c:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006680:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006684:	10079073          	csrw	sstatus,a5
}
    80006688:	60a2                	ld	ra,8(sp)
    8000668a:	6402                	ld	s0,0(sp)
    8000668c:	0141                	addi	sp,sp,16
    8000668e:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006690:	00002517          	auipc	a0,0x2
    80006694:	0f050513          	addi	a0,a0,240 # 80008780 <etext+0x780>
    80006698:	00000097          	auipc	ra,0x0
    8000669c:	9ea080e7          	jalr	-1558(ra) # 80006082 <panic>
  if (c->noff < 1) panic("pop_off");
    800066a0:	00002517          	auipc	a0,0x2
    800066a4:	0f850513          	addi	a0,a0,248 # 80008798 <etext+0x798>
    800066a8:	00000097          	auipc	ra,0x0
    800066ac:	9da080e7          	jalr	-1574(ra) # 80006082 <panic>

00000000800066b0 <release>:
void release(struct spinlock *lk) {
    800066b0:	1101                	addi	sp,sp,-32
    800066b2:	ec06                	sd	ra,24(sp)
    800066b4:	e822                	sd	s0,16(sp)
    800066b6:	e426                	sd	s1,8(sp)
    800066b8:	1000                	addi	s0,sp,32
    800066ba:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800066bc:	00000097          	auipc	ra,0x0
    800066c0:	ec6080e7          	jalr	-314(ra) # 80006582 <holding>
    800066c4:	c115                	beqz	a0,800066e8 <release+0x38>
  lk->cpu = 0;
    800066c6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066ca:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800066ce:	0310000f          	fence	rw,w
    800066d2:	0004a023          	sw	zero,0(s1)
  pop_off();
    800066d6:	00000097          	auipc	ra,0x0
    800066da:	f7a080e7          	jalr	-134(ra) # 80006650 <pop_off>
}
    800066de:	60e2                	ld	ra,24(sp)
    800066e0:	6442                	ld	s0,16(sp)
    800066e2:	64a2                	ld	s1,8(sp)
    800066e4:	6105                	addi	sp,sp,32
    800066e6:	8082                	ret
  if (!holding(lk)) panic("release");
    800066e8:	00002517          	auipc	a0,0x2
    800066ec:	0b850513          	addi	a0,a0,184 # 800087a0 <etext+0x7a0>
    800066f0:	00000097          	auipc	ra,0x0
    800066f4:	992080e7          	jalr	-1646(ra) # 80006082 <panic>
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
