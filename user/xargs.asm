
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <clear>:
#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

// Function to reset elements of the argument array to 0 starting from 'start' index
void clear(char *xargv[MAXARG], int start){
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  for(int i = start; i < MAXARG; i++){
   6:	47fd                	li	a5,31
   8:	02b7c263          	blt	a5,a1,2c <clear+0x2c>
   c:	00359793          	slli	a5,a1,0x3
  10:	97aa                	add	a5,a5,a0
  12:	477d                	li	a4,31
  14:	9f0d                	subw	a4,a4,a1
  16:	1702                	slli	a4,a4,0x20
  18:	9301                	srli	a4,a4,0x20
  1a:	972e                	add	a4,a4,a1
  1c:	070e                	slli	a4,a4,0x3
  1e:	0521                	addi	a0,a0,8
  20:	972a                	add	a4,a4,a0
    xargv[i] = 0; 
  22:	0007b023          	sd	zero,0(a5)
  for(int i = start; i < MAXARG; i++){
  26:	07a1                	addi	a5,a5,8
  28:	fee79de3          	bne	a5,a4,22 <clear+0x22>
  }
}
  2c:	6422                	ld	s0,8(sp)
  2e:	0141                	addi	sp,sp,16
  30:	8082                	ret

0000000000000032 <main>:

int main(int argc, char *argv[])
{
  32:	aa010113          	addi	sp,sp,-1376
  36:	54113c23          	sd	ra,1368(sp)
  3a:	54813823          	sd	s0,1360(sp)
  3e:	56010413          	addi	s0,sp,1376
  if(argc < 2){
  42:	4785                	li	a5,1
  44:	06a7da63          	bge	a5,a0,b8 <main+0x86>
  48:	53413823          	sd	s4,1328(sp)
  4c:	53513423          	sd	s5,1320(sp)
  50:	8a2a                	mv	s4,a0
  52:	8aae                	mv	s5,a1
    fprintf(2, "Usage: xarg <cmd>\n"); 
    exit(1);
  }
  
  // Check if the arguments exceed the maximum allowed number
  if(argc > MAXARG){
  54:	02000793          	li	a5,32
  58:	08a7c863          	blt	a5,a0,e8 <main+0xb6>
  5c:	54913423          	sd	s1,1352(sp)
  60:	55213023          	sd	s2,1344(sp)
  64:	53313c23          	sd	s3,1336(sp)
  68:	53613023          	sd	s6,1312(sp)
  6c:	51713c23          	sd	s7,1304(sp)
    fprintf(2, "xargs: too many arguments\n"); 
    exit(1);
  }

  char *xargv[MAXARG] = {0}; 
  70:	10000613          	li	a2,256
  74:	4581                	li	a1,0
  76:	eb040513          	addi	a0,s0,-336
  7a:	1b4000ef          	jal	22e <memset>
  int xargc = 0;

  // Copy initial arguments from the command line into the argument array
  for(; xargc + 1 < argc; xargc++){
  7e:	008a8713          	addi	a4,s5,8
  82:	eb040793          	addi	a5,s0,-336
  86:	000a091b          	sext.w	s2,s4
  8a:	ffea061b          	addiw	a2,s4,-2
  8e:	02061693          	slli	a3,a2,0x20
  92:	01d6d613          	srli	a2,a3,0x1d
  96:	eb840693          	addi	a3,s0,-328
  9a:	9636                	add	a2,a2,a3
    xargv[xargc] = argv[xargc + 1]; 
  9c:	6314                	ld	a3,0(a4)
  9e:	e394                	sd	a3,0(a5)
  for(; xargc + 1 < argc; xargc++){
  a0:	0721                	addi	a4,a4,8
  a2:	07a1                	addi	a5,a5,8
  a4:	fec79ce3          	bne	a5,a2,9c <main+0x6a>
  a8:	397d                	addiw	s2,s2,-1
  }

  char buf[1024]; 
  char c;         
  int p = 0;     
  int start = 0;  
  aa:	4981                	li	s3,0
  int p = 0;     
  ac:	4481                	li	s1,0

  // Read input character by character from stdin
  while(read(0, &c, 1)){
    
    // Handle spaces, newlines, and other characters
    if(c == ' '){  // If the character is a space, mark the end of the word
  ae:	02000b13          	li	s6,32
      buf[p] = 0; 
      xargv[xargc++] = &buf[start]; 
      start = p;  
    }
    else if(c == '\n'){  // If the character is a newline, execute the command
  b2:	4ba9                	li	s7,10
      } else {
        wait(0); 
      }

      // Reset the argument count and clear the argument array for the next input
      xargc = argc - 1;
  b4:	3a7d                	addiw	s4,s4,-1
  b6:	a8b5                	j	132 <main+0x100>
  b8:	54913423          	sd	s1,1352(sp)
  bc:	55213023          	sd	s2,1344(sp)
  c0:	53313c23          	sd	s3,1336(sp)
  c4:	53413823          	sd	s4,1328(sp)
  c8:	53513423          	sd	s5,1320(sp)
  cc:	53613023          	sd	s6,1312(sp)
  d0:	51713c23          	sd	s7,1304(sp)
    fprintf(2, "Usage: xarg <cmd>\n"); 
  d4:	00001597          	auipc	a1,0x1
  d8:	90c58593          	addi	a1,a1,-1780 # 9e0 <malloc+0x100>
  dc:	4509                	li	a0,2
  de:	724000ef          	jal	802 <fprintf>
    exit(1);
  e2:	4505                	li	a0,1
  e4:	330000ef          	jal	414 <exit>
  e8:	54913423          	sd	s1,1352(sp)
  ec:	55213023          	sd	s2,1344(sp)
  f0:	53313c23          	sd	s3,1336(sp)
  f4:	53613023          	sd	s6,1312(sp)
  f8:	51713c23          	sd	s7,1304(sp)
    fprintf(2, "xargs: too many arguments\n"); 
  fc:	00001597          	auipc	a1,0x1
 100:	8fc58593          	addi	a1,a1,-1796 # 9f8 <malloc+0x118>
 104:	4509                	li	a0,2
 106:	6fc000ef          	jal	802 <fprintf>
    exit(1);
 10a:	4505                	li	a0,1
 10c:	308000ef          	jal	414 <exit>
      buf[p] = 0; 
 110:	fb048793          	addi	a5,s1,-80
 114:	97a2                	add	a5,a5,s0
 116:	b0078023          	sb	zero,-1280(a5)
      xargv[xargc++] = &buf[start]; 
 11a:	00391793          	slli	a5,s2,0x3
 11e:	fb078793          	addi	a5,a5,-80
 122:	97a2                	add	a5,a5,s0
 124:	ab040713          	addi	a4,s0,-1360
 128:	99ba                	add	s3,s3,a4
 12a:	f137b023          	sd	s3,-256(a5)
      start = p;  
 12e:	89a6                	mv	s3,s1
      xargv[xargc++] = &buf[start]; 
 130:	2905                	addiw	s2,s2,1
  while(read(0, &c, 1)){
 132:	4605                	li	a2,1
 134:	aaf40593          	addi	a1,s0,-1361
 138:	4501                	li	a0,0
 13a:	2f2000ef          	jal	42c <read>
 13e:	c525                	beqz	a0,1a6 <main+0x174>
    if(c == ' '){  // If the character is a space, mark the end of the word
 140:	aaf44783          	lbu	a5,-1361(s0)
 144:	fd6786e3          	beq	a5,s6,110 <main+0xde>
    else if(c == '\n'){  // If the character is a newline, execute the command
 148:	01778963          	beq	a5,s7,15a <main+0x128>
      clear(xargv, xargc); 
      p = 0;  
      start = 0; 
    }
    else {  // If it's any other character, add it to the buffer
      buf[p++] = c; 
 14c:	fb048713          	addi	a4,s1,-80
 150:	9722                	add	a4,a4,s0
 152:	b0f70023          	sb	a5,-1280(a4)
 156:	2485                	addiw	s1,s1,1
 158:	bfe9                	j	132 <main+0x100>
      buf[p] = 0; 
 15a:	fb048793          	addi	a5,s1,-80
 15e:	008784b3          	add	s1,a5,s0
 162:	b0048023          	sb	zero,-1280(s1)
      xargv[xargc++] = &buf[start]; 
 166:	090e                	slli	s2,s2,0x3
 168:	fb090793          	addi	a5,s2,-80
 16c:	00878933          	add	s2,a5,s0
 170:	ab040793          	addi	a5,s0,-1360
 174:	99be                	add	s3,s3,a5
 176:	f1393023          	sd	s3,-256(s2)
      if(fork() == 0){
 17a:	292000ef          	jal	40c <fork>
 17e:	e105                	bnez	a0,19e <main+0x16c>
        exec(argv[1], xargv); 
 180:	eb040593          	addi	a1,s0,-336
 184:	008ab503          	ld	a0,8(s5)
 188:	2c4000ef          	jal	44c <exec>
      xargc = argc - 1;
 18c:	8952                	mv	s2,s4
      clear(xargv, xargc); 
 18e:	85d2                	mv	a1,s4
 190:	eb040513          	addi	a0,s0,-336
 194:	e6dff0ef          	jal	0 <clear>
      start = 0; 
 198:	4981                	li	s3,0
      p = 0;  
 19a:	4481                	li	s1,0
 19c:	bf59                	j	132 <main+0x100>
        wait(0); 
 19e:	4501                	li	a0,0
 1a0:	27c000ef          	jal	41c <wait>
 1a4:	b7e5                	j	18c <main+0x15a>
    }
  }
  
  exit(0); 
 1a6:	26e000ef          	jal	414 <exit>

00000000000001aa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1b2:	e81ff0ef          	jal	32 <main>
  exit(0);
 1b6:	4501                	li	a0,0
 1b8:	25c000ef          	jal	414 <exit>

00000000000001bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c2:	87aa                	mv	a5,a0
 1c4:	0585                	addi	a1,a1,1
 1c6:	0785                	addi	a5,a5,1
 1c8:	fff5c703          	lbu	a4,-1(a1)
 1cc:	fee78fa3          	sb	a4,-1(a5)
 1d0:	fb75                	bnez	a4,1c4 <strcpy+0x8>
    ;
  return os;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb91                	beqz	a5,1f6 <strcmp+0x1e>
 1e4:	0005c703          	lbu	a4,0(a1)
 1e8:	00f71763          	bne	a4,a5,1f6 <strcmp+0x1e>
    p++, q++;
 1ec:	0505                	addi	a0,a0,1
 1ee:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	fbe5                	bnez	a5,1e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f6:	0005c503          	lbu	a0,0(a1)
}
 1fa:	40a7853b          	subw	a0,a5,a0
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strlen>:

uint
strlen(const char *s)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cf91                	beqz	a5,22a <strlen+0x26>
 210:	0505                	addi	a0,a0,1
 212:	87aa                	mv	a5,a0
 214:	86be                	mv	a3,a5
 216:	0785                	addi	a5,a5,1
 218:	fff7c703          	lbu	a4,-1(a5)
 21c:	ff65                	bnez	a4,214 <strlen+0x10>
 21e:	40a6853b          	subw	a0,a3,a0
 222:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  for(n = 0; s[n]; n++)
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strlen+0x20>

000000000000022e <memset>:

void*
memset(void *dst, int c, uint n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 234:	ca19                	beqz	a2,24a <memset+0x1c>
 236:	87aa                	mv	a5,a0
 238:	1602                	slli	a2,a2,0x20
 23a:	9201                	srli	a2,a2,0x20
 23c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 240:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 244:	0785                	addi	a5,a5,1
 246:	fee79de3          	bne	a5,a4,240 <memset+0x12>
  }
  return dst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret

0000000000000250 <strchr>:

char*
strchr(const char *s, char c)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  for(; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cb99                	beqz	a5,270 <strchr+0x20>
    if(*s == c)
 25c:	00f58763          	beq	a1,a5,26a <strchr+0x1a>
  for(; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	fbfd                	bnez	a5,25c <strchr+0xc>
      return (char*)s;
  return 0;
 268:	4501                	li	a0,0
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <strchr+0x1a>

0000000000000274 <gets>:

char*
gets(char *buf, int max)
{
 274:	711d                	addi	sp,sp,-96
 276:	ec86                	sd	ra,88(sp)
 278:	e8a2                	sd	s0,80(sp)
 27a:	e4a6                	sd	s1,72(sp)
 27c:	e0ca                	sd	s2,64(sp)
 27e:	fc4e                	sd	s3,56(sp)
 280:	f852                	sd	s4,48(sp)
 282:	f456                	sd	s5,40(sp)
 284:	f05a                	sd	s6,32(sp)
 286:	ec5e                	sd	s7,24(sp)
 288:	1080                	addi	s0,sp,96
 28a:	8baa                	mv	s7,a0
 28c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28e:	892a                	mv	s2,a0
 290:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 292:	4aa9                	li	s5,10
 294:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 296:	89a6                	mv	s3,s1
 298:	2485                	addiw	s1,s1,1
 29a:	0344d663          	bge	s1,s4,2c6 <gets+0x52>
    cc = read(0, &c, 1);
 29e:	4605                	li	a2,1
 2a0:	faf40593          	addi	a1,s0,-81
 2a4:	4501                	li	a0,0
 2a6:	186000ef          	jal	42c <read>
    if(cc < 1)
 2aa:	00a05e63          	blez	a0,2c6 <gets+0x52>
    buf[i++] = c;
 2ae:	faf44783          	lbu	a5,-81(s0)
 2b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b6:	01578763          	beq	a5,s5,2c4 <gets+0x50>
 2ba:	0905                	addi	s2,s2,1
 2bc:	fd679de3          	bne	a5,s6,296 <gets+0x22>
    buf[i++] = c;
 2c0:	89a6                	mv	s3,s1
 2c2:	a011                	j	2c6 <gets+0x52>
 2c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c6:	99de                	add	s3,s3,s7
 2c8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2cc:	855e                	mv	a0,s7
 2ce:	60e6                	ld	ra,88(sp)
 2d0:	6446                	ld	s0,80(sp)
 2d2:	64a6                	ld	s1,72(sp)
 2d4:	6906                	ld	s2,64(sp)
 2d6:	79e2                	ld	s3,56(sp)
 2d8:	7a42                	ld	s4,48(sp)
 2da:	7aa2                	ld	s5,40(sp)
 2dc:	7b02                	ld	s6,32(sp)
 2de:	6be2                	ld	s7,24(sp)
 2e0:	6125                	addi	sp,sp,96
 2e2:	8082                	ret

00000000000002e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e4:	1101                	addi	sp,sp,-32
 2e6:	ec06                	sd	ra,24(sp)
 2e8:	e822                	sd	s0,16(sp)
 2ea:	e04a                	sd	s2,0(sp)
 2ec:	1000                	addi	s0,sp,32
 2ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f0:	4581                	li	a1,0
 2f2:	162000ef          	jal	454 <open>
  if(fd < 0)
 2f6:	02054263          	bltz	a0,31a <stat+0x36>
 2fa:	e426                	sd	s1,8(sp)
 2fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fe:	85ca                	mv	a1,s2
 300:	16c000ef          	jal	46c <fstat>
 304:	892a                	mv	s2,a0
  close(fd);
 306:	8526                	mv	a0,s1
 308:	134000ef          	jal	43c <close>
  return r;
 30c:	64a2                	ld	s1,8(sp)
}
 30e:	854a                	mv	a0,s2
 310:	60e2                	ld	ra,24(sp)
 312:	6442                	ld	s0,16(sp)
 314:	6902                	ld	s2,0(sp)
 316:	6105                	addi	sp,sp,32
 318:	8082                	ret
    return -1;
 31a:	597d                	li	s2,-1
 31c:	bfcd                	j	30e <stat+0x2a>

000000000000031e <atoi>:

int
atoi(const char *s)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 324:	00054683          	lbu	a3,0(a0)
 328:	fd06879b          	addiw	a5,a3,-48
 32c:	0ff7f793          	zext.b	a5,a5
 330:	4625                	li	a2,9
 332:	02f66863          	bltu	a2,a5,362 <atoi+0x44>
 336:	872a                	mv	a4,a0
  n = 0;
 338:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33a:	0705                	addi	a4,a4,1
 33c:	0025179b          	slliw	a5,a0,0x2
 340:	9fa9                	addw	a5,a5,a0
 342:	0017979b          	slliw	a5,a5,0x1
 346:	9fb5                	addw	a5,a5,a3
 348:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34c:	00074683          	lbu	a3,0(a4)
 350:	fd06879b          	addiw	a5,a3,-48
 354:	0ff7f793          	zext.b	a5,a5
 358:	fef671e3          	bgeu	a2,a5,33a <atoi+0x1c>
  return n;
}
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  n = 0;
 362:	4501                	li	a0,0
 364:	bfe5                	j	35c <atoi+0x3e>

0000000000000366 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36c:	02b57463          	bgeu	a0,a1,394 <memmove+0x2e>
    while(n-- > 0)
 370:	00c05f63          	blez	a2,38e <memmove+0x28>
 374:	1602                	slli	a2,a2,0x20
 376:	9201                	srli	a2,a2,0x20
 378:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37c:	872a                	mv	a4,a0
      *dst++ = *src++;
 37e:	0585                	addi	a1,a1,1
 380:	0705                	addi	a4,a4,1
 382:	fff5c683          	lbu	a3,-1(a1)
 386:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38a:	fef71ae3          	bne	a4,a5,37e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
    dst += n;
 394:	00c50733          	add	a4,a0,a2
    src += n;
 398:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39a:	fec05ae3          	blez	a2,38e <memmove+0x28>
 39e:	fff6079b          	addiw	a5,a2,-1
 3a2:	1782                	slli	a5,a5,0x20
 3a4:	9381                	srli	a5,a5,0x20
 3a6:	fff7c793          	not	a5,a5
 3aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ac:	15fd                	addi	a1,a1,-1
 3ae:	177d                	addi	a4,a4,-1
 3b0:	0005c683          	lbu	a3,0(a1)
 3b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b8:	fee79ae3          	bne	a5,a4,3ac <memmove+0x46>
 3bc:	bfc9                	j	38e <memmove+0x28>

00000000000003be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c4:	ca05                	beqz	a2,3f4 <memcmp+0x36>
 3c6:	fff6069b          	addiw	a3,a2,-1
 3ca:	1682                	slli	a3,a3,0x20
 3cc:	9281                	srli	a3,a3,0x20
 3ce:	0685                	addi	a3,a3,1
 3d0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d2:	00054783          	lbu	a5,0(a0)
 3d6:	0005c703          	lbu	a4,0(a1)
 3da:	00e79863          	bne	a5,a4,3ea <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3de:	0505                	addi	a0,a0,1
    p2++;
 3e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e2:	fed518e3          	bne	a0,a3,3d2 <memcmp+0x14>
  }
  return 0;
 3e6:	4501                	li	a0,0
 3e8:	a019                	j	3ee <memcmp+0x30>
      return *p1 - *p2;
 3ea:	40e7853b          	subw	a0,a5,a4
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	bfe5                	j	3ee <memcmp+0x30>

00000000000003f8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e406                	sd	ra,8(sp)
 3fc:	e022                	sd	s0,0(sp)
 3fe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 400:	f67ff0ef          	jal	366 <memmove>
}
 404:	60a2                	ld	ra,8(sp)
 406:	6402                	ld	s0,0(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40c:	4885                	li	a7,1
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exit>:
.global exit
exit:
 li a7, SYS_exit
 414:	4889                	li	a7,2
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <wait>:
.global wait
wait:
 li a7, SYS_wait
 41c:	488d                	li	a7,3
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 424:	4891                	li	a7,4
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <read>:
.global read
read:
 li a7, SYS_read
 42c:	4895                	li	a7,5
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <write>:
.global write
write:
 li a7, SYS_write
 434:	48c1                	li	a7,16
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <close>:
.global close
close:
 li a7, SYS_close
 43c:	48d5                	li	a7,21
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <kill>:
.global kill
kill:
 li a7, SYS_kill
 444:	4899                	li	a7,6
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exec>:
.global exec
exec:
 li a7, SYS_exec
 44c:	489d                	li	a7,7
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <open>:
.global open
open:
 li a7, SYS_open
 454:	48bd                	li	a7,15
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45c:	48c5                	li	a7,17
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 464:	48c9                	li	a7,18
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46c:	48a1                	li	a7,8
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <link>:
.global link
link:
 li a7, SYS_link
 474:	48cd                	li	a7,19
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47c:	48d1                	li	a7,20
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 484:	48a5                	li	a7,9
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <dup>:
.global dup
dup:
 li a7, SYS_dup
 48c:	48a9                	li	a7,10
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 494:	48ad                	li	a7,11
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49c:	48b1                	li	a7,12
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a4:	48b5                	li	a7,13
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ac:	48b9                	li	a7,14
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b4:	1101                	addi	sp,sp,-32
 4b6:	ec06                	sd	ra,24(sp)
 4b8:	e822                	sd	s0,16(sp)
 4ba:	1000                	addi	s0,sp,32
 4bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c0:	4605                	li	a2,1
 4c2:	fef40593          	addi	a1,s0,-17
 4c6:	f6fff0ef          	jal	434 <write>
}
 4ca:	60e2                	ld	ra,24(sp)
 4cc:	6442                	ld	s0,16(sp)
 4ce:	6105                	addi	sp,sp,32
 4d0:	8082                	ret

00000000000004d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d2:	7139                	addi	sp,sp,-64
 4d4:	fc06                	sd	ra,56(sp)
 4d6:	f822                	sd	s0,48(sp)
 4d8:	f426                	sd	s1,40(sp)
 4da:	0080                	addi	s0,sp,64
 4dc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4de:	c299                	beqz	a3,4e4 <printint+0x12>
 4e0:	0805c963          	bltz	a1,572 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e4:	2581                	sext.w	a1,a1
  neg = 0;
 4e6:	4881                	li	a7,0
 4e8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ee:	2601                	sext.w	a2,a2
 4f0:	00000517          	auipc	a0,0x0
 4f4:	53050513          	addi	a0,a0,1328 # a20 <digits>
 4f8:	883a                	mv	a6,a4
 4fa:	2705                	addiw	a4,a4,1
 4fc:	02c5f7bb          	remuw	a5,a1,a2
 500:	1782                	slli	a5,a5,0x20
 502:	9381                	srli	a5,a5,0x20
 504:	97aa                	add	a5,a5,a0
 506:	0007c783          	lbu	a5,0(a5)
 50a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 50e:	0005879b          	sext.w	a5,a1
 512:	02c5d5bb          	divuw	a1,a1,a2
 516:	0685                	addi	a3,a3,1
 518:	fec7f0e3          	bgeu	a5,a2,4f8 <printint+0x26>
  if(neg)
 51c:	00088c63          	beqz	a7,534 <printint+0x62>
    buf[i++] = '-';
 520:	fd070793          	addi	a5,a4,-48
 524:	00878733          	add	a4,a5,s0
 528:	02d00793          	li	a5,45
 52c:	fef70823          	sb	a5,-16(a4)
 530:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 534:	02e05a63          	blez	a4,568 <printint+0x96>
 538:	f04a                	sd	s2,32(sp)
 53a:	ec4e                	sd	s3,24(sp)
 53c:	fc040793          	addi	a5,s0,-64
 540:	00e78933          	add	s2,a5,a4
 544:	fff78993          	addi	s3,a5,-1
 548:	99ba                	add	s3,s3,a4
 54a:	377d                	addiw	a4,a4,-1
 54c:	1702                	slli	a4,a4,0x20
 54e:	9301                	srli	a4,a4,0x20
 550:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 554:	fff94583          	lbu	a1,-1(s2)
 558:	8526                	mv	a0,s1
 55a:	f5bff0ef          	jal	4b4 <putc>
  while(--i >= 0)
 55e:	197d                	addi	s2,s2,-1
 560:	ff391ae3          	bne	s2,s3,554 <printint+0x82>
 564:	7902                	ld	s2,32(sp)
 566:	69e2                	ld	s3,24(sp)
}
 568:	70e2                	ld	ra,56(sp)
 56a:	7442                	ld	s0,48(sp)
 56c:	74a2                	ld	s1,40(sp)
 56e:	6121                	addi	sp,sp,64
 570:	8082                	ret
    x = -xx;
 572:	40b005bb          	negw	a1,a1
    neg = 1;
 576:	4885                	li	a7,1
    x = -xx;
 578:	bf85                	j	4e8 <printint+0x16>

000000000000057a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57a:	711d                	addi	sp,sp,-96
 57c:	ec86                	sd	ra,88(sp)
 57e:	e8a2                	sd	s0,80(sp)
 580:	e0ca                	sd	s2,64(sp)
 582:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 584:	0005c903          	lbu	s2,0(a1)
 588:	26090863          	beqz	s2,7f8 <vprintf+0x27e>
 58c:	e4a6                	sd	s1,72(sp)
 58e:	fc4e                	sd	s3,56(sp)
 590:	f852                	sd	s4,48(sp)
 592:	f456                	sd	s5,40(sp)
 594:	f05a                	sd	s6,32(sp)
 596:	ec5e                	sd	s7,24(sp)
 598:	e862                	sd	s8,16(sp)
 59a:	e466                	sd	s9,8(sp)
 59c:	8b2a                	mv	s6,a0
 59e:	8a2e                	mv	s4,a1
 5a0:	8bb2                	mv	s7,a2
  state = 0;
 5a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a4:	4481                	li	s1,0
 5a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b0:	06c00c93          	li	s9,108
 5b4:	a005                	j	5d4 <vprintf+0x5a>
        putc(fd, c0);
 5b6:	85ca                	mv	a1,s2
 5b8:	855a                	mv	a0,s6
 5ba:	efbff0ef          	jal	4b4 <putc>
 5be:	a019                	j	5c4 <vprintf+0x4a>
    } else if(state == '%'){
 5c0:	03598263          	beq	s3,s5,5e4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5c4:	2485                	addiw	s1,s1,1
 5c6:	8726                	mv	a4,s1
 5c8:	009a07b3          	add	a5,s4,s1
 5cc:	0007c903          	lbu	s2,0(a5)
 5d0:	20090c63          	beqz	s2,7e8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d8:	fe0994e3          	bnez	s3,5c0 <vprintf+0x46>
      if(c0 == '%'){
 5dc:	fd579de3          	bne	a5,s5,5b6 <vprintf+0x3c>
        state = '%';
 5e0:	89be                	mv	s3,a5
 5e2:	b7cd                	j	5c4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e4:	00ea06b3          	add	a3,s4,a4
 5e8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ee:	c681                	beqz	a3,5f6 <vprintf+0x7c>
 5f0:	9752                	add	a4,a4,s4
 5f2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f6:	03878f63          	beq	a5,s8,634 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5fa:	05978963          	beq	a5,s9,64c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5fe:	07500713          	li	a4,117
 602:	0ee78363          	beq	a5,a4,6e8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 606:	07800713          	li	a4,120
 60a:	12e78563          	beq	a5,a4,734 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 60e:	07000713          	li	a4,112
 612:	14e78a63          	beq	a5,a4,766 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 616:	07300713          	li	a4,115
 61a:	18e78a63          	beq	a5,a4,7ae <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 61e:	02500713          	li	a4,37
 622:	04e79563          	bne	a5,a4,66c <vprintf+0xf2>
        putc(fd, '%');
 626:	02500593          	li	a1,37
 62a:	855a                	mv	a0,s6
 62c:	e89ff0ef          	jal	4b4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 630:	4981                	li	s3,0
 632:	bf49                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 634:	008b8913          	addi	s2,s7,8
 638:	4685                	li	a3,1
 63a:	4629                	li	a2,10
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	e91ff0ef          	jal	4d2 <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bfad                	j	5c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 64c:	06400793          	li	a5,100
 650:	02f68963          	beq	a3,a5,682 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	06c00793          	li	a5,108
 658:	04f68263          	beq	a3,a5,69c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 65c:	07500793          	li	a5,117
 660:	0af68063          	beq	a3,a5,700 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 664:	07800793          	li	a5,120
 668:	0ef68263          	beq	a3,a5,74c <vprintf+0x1d2>
        putc(fd, '%');
 66c:	02500593          	li	a1,37
 670:	855a                	mv	a0,s6
 672:	e43ff0ef          	jal	4b4 <putc>
        putc(fd, c0);
 676:	85ca                	mv	a1,s2
 678:	855a                	mv	a0,s6
 67a:	e3bff0ef          	jal	4b4 <putc>
      state = 0;
 67e:	4981                	li	s3,0
 680:	b791                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e43ff0ef          	jal	4d2 <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	b72d                	j	5c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69c:	06400793          	li	a5,100
 6a0:	02f60763          	beq	a2,a5,6ce <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a4:	07500793          	li	a5,117
 6a8:	06f60963          	beq	a2,a5,71a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ac:	07800793          	li	a5,120
 6b0:	faf61ee3          	bne	a2,a5,66c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	e11ff0ef          	jal	4d2 <printint>
        i += 2;
 6c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	bde5                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4685                	li	a3,1
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	df7ff0ef          	jal	4d2 <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	bdf9                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	dddff0ef          	jal	4d2 <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b5d9                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4629                	li	a2,10
 708:	000ba583          	lw	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	dc5ff0ef          	jal	4d2 <printint>
        i += 1;
 712:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 1;
 718:	b575                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	dabff0ef          	jal	4d2 <printint>
        i += 2;
 72c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 2;
 732:	bd49                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 734:	008b8913          	addi	s2,s7,8
 738:	4681                	li	a3,0
 73a:	4641                	li	a2,16
 73c:	000ba583          	lw	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	d91ff0ef          	jal	4d2 <printint>
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bdad                	j	5c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 74c:	008b8913          	addi	s2,s7,8
 750:	4681                	li	a3,0
 752:	4641                	li	a2,16
 754:	000ba583          	lw	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	d79ff0ef          	jal	4d2 <printint>
        i += 1;
 75e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
        i += 1;
 764:	b585                	j	5c4 <vprintf+0x4a>
 766:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 768:	008b8d13          	addi	s10,s7,8
 76c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 770:	03000593          	li	a1,48
 774:	855a                	mv	a0,s6
 776:	d3fff0ef          	jal	4b4 <putc>
  putc(fd, 'x');
 77a:	07800593          	li	a1,120
 77e:	855a                	mv	a0,s6
 780:	d35ff0ef          	jal	4b4 <putc>
 784:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 786:	00000b97          	auipc	s7,0x0
 78a:	29ab8b93          	addi	s7,s7,666 # a20 <digits>
 78e:	03c9d793          	srli	a5,s3,0x3c
 792:	97de                	add	a5,a5,s7
 794:	0007c583          	lbu	a1,0(a5)
 798:	855a                	mv	a0,s6
 79a:	d1bff0ef          	jal	4b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79e:	0992                	slli	s3,s3,0x4
 7a0:	397d                	addiw	s2,s2,-1
 7a2:	fe0916e3          	bnez	s2,78e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7a6:	8bea                	mv	s7,s10
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	6d02                	ld	s10,0(sp)
 7ac:	bd21                	j	5c4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7ae:	008b8993          	addi	s3,s7,8
 7b2:	000bb903          	ld	s2,0(s7)
 7b6:	00090f63          	beqz	s2,7d4 <vprintf+0x25a>
        for(; *s; s++)
 7ba:	00094583          	lbu	a1,0(s2)
 7be:	c195                	beqz	a1,7e2 <vprintf+0x268>
          putc(fd, *s);
 7c0:	855a                	mv	a0,s6
 7c2:	cf3ff0ef          	jal	4b4 <putc>
        for(; *s; s++)
 7c6:	0905                	addi	s2,s2,1
 7c8:	00094583          	lbu	a1,0(s2)
 7cc:	f9f5                	bnez	a1,7c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bbcd                	j	5c4 <vprintf+0x4a>
          s = "(null)";
 7d4:	00000917          	auipc	s2,0x0
 7d8:	24490913          	addi	s2,s2,580 # a18 <malloc+0x138>
        for(; *s; s++)
 7dc:	02800593          	li	a1,40
 7e0:	b7c5                	j	7c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7e2:	8bce                	mv	s7,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bbf9                	j	5c4 <vprintf+0x4a>
 7e8:	64a6                	ld	s1,72(sp)
 7ea:	79e2                	ld	s3,56(sp)
 7ec:	7a42                	ld	s4,48(sp)
 7ee:	7aa2                	ld	s5,40(sp)
 7f0:	7b02                	ld	s6,32(sp)
 7f2:	6be2                	ld	s7,24(sp)
 7f4:	6c42                	ld	s8,16(sp)
 7f6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f8:	60e6                	ld	ra,88(sp)
 7fa:	6446                	ld	s0,80(sp)
 7fc:	6906                	ld	s2,64(sp)
 7fe:	6125                	addi	sp,sp,96
 800:	8082                	ret

0000000000000802 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 802:	715d                	addi	sp,sp,-80
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e010                	sd	a2,0(s0)
 80c:	e414                	sd	a3,8(s0)
 80e:	e818                	sd	a4,16(s0)
 810:	ec1c                	sd	a5,24(s0)
 812:	03043023          	sd	a6,32(s0)
 816:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81e:	8622                	mv	a2,s0
 820:	d5bff0ef          	jal	57a <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6161                	addi	sp,sp,80
 82a:	8082                	ret

000000000000082c <printf>:

void
printf(const char *fmt, ...)
{
 82c:	711d                	addi	sp,sp,-96
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e40c                	sd	a1,8(s0)
 836:	e810                	sd	a2,16(s0)
 838:	ec14                	sd	a3,24(s0)
 83a:	f018                	sd	a4,32(s0)
 83c:	f41c                	sd	a5,40(s0)
 83e:	03043823          	sd	a6,48(s0)
 842:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 846:	00840613          	addi	a2,s0,8
 84a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84e:	85aa                	mv	a1,a0
 850:	4505                	li	a0,1
 852:	d29ff0ef          	jal	57a <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6125                	addi	sp,sp,96
 85c:	8082                	ret

000000000000085e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85e:	1141                	addi	sp,sp,-16
 860:	e422                	sd	s0,8(sp)
 862:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 864:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	00000797          	auipc	a5,0x0
 86c:	7987b783          	ld	a5,1944(a5) # 1000 <freep>
 870:	a02d                	j	89a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 872:	4618                	lw	a4,8(a2)
 874:	9f2d                	addw	a4,a4,a1
 876:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	6310                	ld	a2,0(a4)
 87e:	a83d                	j	8bc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 880:	ff852703          	lw	a4,-8(a0)
 884:	9f31                	addw	a4,a4,a2
 886:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 888:	ff053683          	ld	a3,-16(a0)
 88c:	a091                	j	8d0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	6398                	ld	a4,0(a5)
 890:	00e7e463          	bltu	a5,a4,898 <free+0x3a>
 894:	00e6ea63          	bltu	a3,a4,8a8 <free+0x4a>
{
 898:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	fed7fae3          	bgeu	a5,a3,88e <free+0x30>
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e6e463          	bltu	a3,a4,8a8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	fee7eae3          	bltu	a5,a4,898 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a8:	ff852583          	lw	a1,-8(a0)
 8ac:	6390                	ld	a2,0(a5)
 8ae:	02059813          	slli	a6,a1,0x20
 8b2:	01c85713          	srli	a4,a6,0x1c
 8b6:	9736                	add	a4,a4,a3
 8b8:	fae60de3          	beq	a2,a4,872 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c0:	4790                	lw	a2,8(a5)
 8c2:	02061593          	slli	a1,a2,0x20
 8c6:	01c5d713          	srli	a4,a1,0x1c
 8ca:	973e                	add	a4,a4,a5
 8cc:	fae68ae3          	beq	a3,a4,880 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
}
 8da:	6422                	ld	s0,8(sp)
 8dc:	0141                	addi	sp,sp,16
 8de:	8082                	ret

00000000000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	7139                	addi	sp,sp,-64
 8e2:	fc06                	sd	ra,56(sp)
 8e4:	f822                	sd	s0,48(sp)
 8e6:	f426                	sd	s1,40(sp)
 8e8:	ec4e                	sd	s3,24(sp)
 8ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ec:	02051493          	slli	s1,a0,0x20
 8f0:	9081                	srli	s1,s1,0x20
 8f2:	04bd                	addi	s1,s1,15
 8f4:	8091                	srli	s1,s1,0x4
 8f6:	0014899b          	addiw	s3,s1,1
 8fa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8fc:	00000517          	auipc	a0,0x0
 900:	70453503          	ld	a0,1796(a0) # 1000 <freep>
 904:	c915                	beqz	a0,938 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 908:	4798                	lw	a4,8(a5)
 90a:	08977a63          	bgeu	a4,s1,99e <malloc+0xbe>
 90e:	f04a                	sd	s2,32(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 916:	8a4e                	mv	s4,s3
 918:	0009871b          	sext.w	a4,s3
 91c:	6685                	lui	a3,0x1
 91e:	00d77363          	bgeu	a4,a3,924 <malloc+0x44>
 922:	6a05                	lui	s4,0x1
 924:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 928:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92c:	00000917          	auipc	s2,0x0
 930:	6d490913          	addi	s2,s2,1748 # 1000 <freep>
  if(p == (char*)-1)
 934:	5afd                	li	s5,-1
 936:	a081                	j	976 <malloc+0x96>
 938:	f04a                	sd	s2,32(sp)
 93a:	e852                	sd	s4,16(sp)
 93c:	e456                	sd	s5,8(sp)
 93e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 940:	00000797          	auipc	a5,0x0
 944:	6d078793          	addi	a5,a5,1744 # 1010 <base>
 948:	00000717          	auipc	a4,0x0
 94c:	6af73c23          	sd	a5,1720(a4) # 1000 <freep>
 950:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 952:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 956:	b7c1                	j	916 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	e118                	sd	a4,0(a0)
 95c:	a8a9                	j	9b6 <malloc+0xd6>
  hp->s.size = nu;
 95e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 962:	0541                	addi	a0,a0,16
 964:	efbff0ef          	jal	85e <free>
  return freep;
 968:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 96c:	c12d                	beqz	a0,9ce <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	02977263          	bgeu	a4,s1,996 <malloc+0xb6>
    if(p == freep)
 976:	00093703          	ld	a4,0(s2)
 97a:	853e                	mv	a0,a5
 97c:	fef719e3          	bne	a4,a5,96e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 980:	8552                	mv	a0,s4
 982:	b1bff0ef          	jal	49c <sbrk>
  if(p == (char*)-1)
 986:	fd551ce3          	bne	a0,s5,95e <malloc+0x7e>
        return 0;
 98a:	4501                	li	a0,0
 98c:	7902                	ld	s2,32(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	a03d                	j	9c2 <malloc+0xe2>
 996:	7902                	ld	s2,32(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 99e:	fae48de3          	beq	s1,a4,958 <malloc+0x78>
        p->s.size -= nunits;
 9a2:	4137073b          	subw	a4,a4,s3
 9a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a8:	02071693          	slli	a3,a4,0x20
 9ac:	01c6d713          	srli	a4,a3,0x1c
 9b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64a73523          	sd	a0,1610(a4) # 1000 <freep>
      return (void*)(p + 1);
 9be:	01078513          	addi	a0,a5,16
  }
}
 9c2:	70e2                	ld	ra,56(sp)
 9c4:	7442                	ld	s0,48(sp)
 9c6:	74a2                	ld	s1,40(sp)
 9c8:	69e2                	ld	s3,24(sp)
 9ca:	6121                	addi	sp,sp,64
 9cc:	8082                	ret
 9ce:	7902                	ld	s2,32(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
 9d6:	b7f5                	j	9c2 <malloc+0xe2>
